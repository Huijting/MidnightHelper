local _, ns = ...

--[[
	ForeverDoNow.lua — WoW Forever: the small window "Do this now / All caught up / Coming up".

	Rob, 11 Nov 2026 (after PaladinPlan; GPL-3.0, so only the idea): "Doe dit nu / Alles bij / Komt eraan". Design talked
	through on 12 Nov (his choices, IDEEEN.md): only Forever; shown "only when there is something to do" by default, a
	setting puts it on "always", and one turns it off; works without a chosen direction. Build-yes 12 Nov via sparring,
	verbatim: "Venster 'Doe dit nu'".

	Every line rests on something MH already has (no new measurement):
	  Do this now
	    - spells ready at your class trainer ............ ns.ForeverTrainerCompute(level).now (ForeverTrainer.lua) + arrow
	    - buttons that still cast an old rank ........... ns.ForeverRankCount / ns.ForeverRankFixAll (ForeverRanks.lua)
	    - weapon skills you can learn now ............... ns.ForeverWeaponsLearnableCount (ForeverWeapons.lua)
	    - a missing buff ................................ ns.GetForeverMissingBuffs + ns.MissingBuffSentence (ForeverBuffs/MissingBuff)
	    - a profession without its tool ................. ns.ForeverMissingTools (ForeverVendors.lua)
	  All caught up — when none of the above.
	  Coming up
	    - trainer spells of the next 3 levels, by name . ns.ForeverTrainerCompute(level + 3), spells above your level
	    - with a chosen direction: the next talent spell of that tree and its earliest level
	      (ns.ForeverDirectionTalents, ForeverMacros.lua SPEC_MACROS; levels AFGELEID from "first point at 10, one per level",
	      minus the rank of the Legacy perk Talented when readable: ns.ForeverTalentedRank, 17 Nov 2026)
	Not here on purpose (sparring's limits): stats, "best weapon", "switch weapons now", professions advice, the tooltip /
	upgrade notice (step 3).
	Hidden in a fight (a text panel has nothing to do there), back afterwards.
	/mh donow = show/hide now · /mh donow auto|always|off · /mh donow check = what it would say and why it is (not) shown.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local HEAD, GREY, GOOD = "|cffffcc66", "|cff9d9d9d", "|cff7fff7f"
-- 23 Nov 2026: true = an upgrade in your bags counts as something to do (the window opens by itself in "auto"); false =
-- a tip (it shows when the window is up anyway). Rob via sparring, verbatim: "Opvallen A." = true.
-- Closing the window without choosing keeps it closed (as the cross always did) until a NEW upgrade comes into your
-- bags: closedWear holds the upgrades that were there when you closed it. Never in combat (Decision), back after it.
local WEAR_TODO = true
local closedWear
local GOLD, STAR = "|cffffd100", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14:14|t"
local W = 300

--- Gold around a line, but not over what has a colour of its own (the spell link stays blue). Every colour is closed
--- again, so nothing runs on into the next line.
local function Golden(s)
	return GOLD .. s:gsub("(|c.-|r)", "|r%1" .. GOLD) .. "|r"
end

local win
local forced = nil -- /mh donow shows (true) or hides (false) it for this session, whatever the mode says

local function Mode()
	local m = ns.db and ns.db.foreverDoNowMode
	return (m == "always" or m == "off") and m or "auto"
end

local function SetMode(m)
	if ns.db then
		ns.db.foreverDoNowMode = (m == "always" or m == "off") and m or nil
	end
	forced = nil
	if ns.ForeverDoNowUpdate then
		ns.ForeverDoNowUpdate()
	end
end
ns.ForeverDoNowMode = Mode
ns.SetForeverDoNowMode = SetMode

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return "#" .. tostring(id)
end

local function Money(c)
	-- 18 Nov 2026 (Rob: "ja laat alle 3 zien"): gold, silver and copper with coins, also when 0 (ForeverStyle.lua).
	if ns.ForeverStyle and ns.ForeverStyle.Money then
		return ns.ForeverStyle.Money(c)
	end
	if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
		local ok, s = pcall(C_CurrencyInfo.GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	return tostring(c)
end

--------------------------------------------------------------------------------
-- New spell on no bar (16 Nov 2026; Rob via sparring: "allemaal", the idea box proposal of 15 Nov).
-- GEMETEN by Rob on a Forever mage: LEARNED_SPELL_IN_SKILL_LINE fires at the trainer with the spell id ("1459 Arcane
-- Intellect false"). Passive spells and auto-attack are skipped (C_Spell.IsSpellPassive / IsAutoAttackSpell, as
-- Blizzard's own spellbook highlight does in Forever). "On a bar" = ANY rank of the same spell name in any action slot,
-- as a spell or inside a macro: a lower rank on a button is ForeverRanks' line, not this one. Silent while the key
-- block is placed: it asks about new spells itself (KeyBlock.lua). Remembered per character until it is on a bar.
--------------------------------------------------------------------------------
local function NewSpells()
	if type(ns.db) ~= "table" or not UnitGUID then
		return {}
	end
	ns.db.foreverNewSpells = ns.db.foreverNewSpells or {}
	local g = UnitGUID("player") or "?"
	ns.db.foreverNewSpells[g] = ns.db.foreverNewSpells[g] or {}
	return ns.db.foreverNewSpells[g]
end

local function SpellNameOf(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return nil
end

--- Is any rank of this spell (same name) in an action slot 1-180, as a spell or as the spell a macro casts?
local function OnAnyBar(name)
	if not (name and GetActionInfo) then
		return nil
	end
	for slot = 1, 180 do
		local ok, kind, id = pcall(GetActionInfo, slot)
		if ok and (kind == "spell" or kind == "macro") and type(id) == "number" and id > 0 then
			if SpellNameOf(id) == name then
				return slot
			end
		end
	end
	return nil
end

local function KeyBlockOn()
	return ns.KeyBlockActive and ns.KeyBlockActive() and true or false
end

--- A spell name the window's hover can answer: |Hspell:id|h…|h shows nothing extra on screen, and the window's
--- OnHyperlinkEnter gives the game's own spell tooltip (19 Nov 2026, Rob: "overal waar een tooltip bestaat in de game").
--- The overview shows the same sentences; there the link is plain text (no hover), which reads the same.
local function SpellLink(id, name)
	if not (id and name) or name:sub(1, 1) == "#" then
		return name
	end
	-- 19 Nov 2026 (Rob: "een ander kleurtje krijgt als het een tooltip bevat. Want nu zie ik dat niet"): the light blue
	-- the game uses for its own spell links (|cff71d5ff), so a name with a tooltip looks like a link.
	return ("|cff71d5ff|Hspell:%d|h%s|h|r"):format(id, name)
end

--- 19 Nov 2026 (the learn list, ForeverRanks.lua; Rob: "volg het maar en doe het maar"): spell names the player said
--- "never" to in that list. Per character, by name, so the next rank of the same spell is not asked about either.
local function NeverNames()
	if type(ns.db) ~= "table" or not UnitGUID then
		return {}
	end
	ns.db.foreverNewSpellsNever = ns.db.foreverNewSpellsNever or {}
	local g = UnitGUID("player") or "?"
	ns.db.foreverNewSpellsNever[g] = ns.db.foreverNewSpellsNever[g] or {}
	return ns.db.foreverNewSpellsNever[g]
end

--- The new spells still on no bar (names), after dropping the ones that are on a bar now. Also used by /mh donow check.
--- Second value: the same names as spell links, in the same order (for the window).
local function NoBarSpells()
	local list, found = NewSpells(), {}
	local never = NeverNames()
	for id in pairs(list) do
		local name = SpellNameOf(id)
		if not name then
			list[id] = nil
		elseif never[name] or OnAnyBar(name) then
			list[id] = nil
		else
			found[#found + 1] = { id = id, name = name }
		end
	end
	table.sort(found, function(a, b)
		return a.name < b.name
	end)
	local out, links, ids = {}, {}, {}
	for i, e in ipairs(found) do
		out[i] = e.name
		links[i] = SpellLink(e.id, e.name)
		ids[i] = e.id
	end
	return out, links, ids
end

--- For the learn list (ForeverRanks.lua): the new spells on no bar, { { id, name }, … } (empty while the key block is
--- placed: it asks about new spells itself), and a way to forget one ("never" = never ask about that name again).
function ns.ForeverNoBarList()
	if KeyBlockOn() then
		return {}
	end
	local names, _, ids = NoBarSpells()
	local out = {}
	for i, n in ipairs(names) do
		out[i] = { id = ids[i], name = n }
	end
	return out
end

function ns.ForeverNoBarForget(id, never)
	local name = SpellNameOf(id)
	NewSpells()[id] = nil
	if never and name then
		NeverNames()[name] = true
	end
end

local learnEv = CreateFrame("Frame")
pcall(learnEv.RegisterEvent, learnEv, "LEARNED_SPELL_IN_SKILL_LINE")
learnEv:SetScript("OnEvent", function(_, _, spellID)
	if type(spellID) ~= "number" or (issecretvalue and issecretvalue(spellID)) then
		return
	end
	if C_Spell and C_Spell.IsSpellPassive then
		local ok, p = pcall(C_Spell.IsSpellPassive, spellID)
		if ok and p then
			return
		end
	end
	if C_Spell and C_Spell.IsAutoAttackSpell then
		local ok, a = pcall(C_Spell.IsAutoAttackSpell, spellID)
		if ok and a then
			return
		end
	end
	local list = NewSpells()
	list[spellID] = true
	-- Keep it small: a character that never drags anything should not grow this forever.
	local n = 0
	for _ in pairs(list) do
		n = n + 1
	end
	if n > 20 then
		list[next(list)] = nil
	end
end)

--------------------------------------------------------------------------------
-- Best stats for you now (16 Nov 2026; Rob via sparring: "b , maar hou ook dps en heling in je achterhoofd", then
-- "alle 4 ja"). The same table as the green tooltip line and the quest-reward hint (ns.ForeverStatDef,
-- ForeverMainStats.lua), so the three never disagree. A tip, not a to-do: it must not open the window by itself.
-- Stat names = the client's own (SPELL_STAT1_NAME .. 5: Strength, Agility, Stamina, Intellect, Spirit).
--------------------------------------------------------------------------------
local STAT_GLOBAL = { STRENGTH = "SPELL_STAT1_NAME", AGILITY = "SPELL_STAT2_NAME", STAMINA = "SPELL_STAT3_NAME",
	INTELLECT = "SPELL_STAT4_NAME", SPIRIT = "SPELL_STAT5_NAME" }

local function StatName(k)
	local g = STAT_GLOBAL[k] and _G[STAT_GLOBAL[k]]
	if type(g) == "string" and g ~= "" then
		return g
	end
	return k and (k:sub(1, 1) .. k:sub(2):lower()) or "?"
end

--- One sentence for a stat def: "A, then B" or "A and B count the same", plus the Stamina tie when it applies.
local function StatSentence(def, fmtKey)
	local main = def and def.main
	if not (main and main[1]) then
		return nil
	end
	local order
	if main[2] then
		order = (def.equal and ns:L("FDONOW_STATS_EQUAL_FMT") or ns:L("FDONOW_STATS_THEN_FMT")):format(StatName(main[1]),
			StatName(main[2]))
	else
		order = StatName(main[1])
	end
	local s = ns:L(fmtKey):format(order)
	if def.stamTie then
		s = s .. " " .. ns:L("FDONOW_STATS_STAM_TIE")
	end
	return s
end

local function StatLines()
	local token = select(2, UnitClass("player"))
	if not (token and ns.ForeverStatDef) then
		return {}
	end
	local out = {}
	local def = ns.ForeverStatDef(token)
	local s = StatSentence(def, "FDONOW_STATS_FMT")
	if s then
		out[#out + 1] = s
	end
	local tank = ns.ForeverTankStatDef and ns.ForeverTankStatDef(token)
	if tank and not (def and def.role == "tank") then
		local t = StatSentence(tank, "FDONOW_STATS_TANK_FMT")
		if t then
			out[#out + 1] = t
		end
	end
	return out
end

--- What the window would say. @return { now = {lines}, actions = {kind = true}, soon = {lines} }
--- One action per kind of line, shared by this window's buttons and the overview (ForeverOverview.lua). 17 Nov 2026,
--- docs/forever/OVERZICHT_PRODUCT_PLAN_2026-11-17.md step 2 (Rob: "ja doe maar"): the overview shows THIS list, so the
--- card and this small window always say the same. `page` = a page of the overview instead of a function.
local ACTS = {
	trainer = { fn = function() if ns.ForeverTrainerGo then ns.ForeverTrainerGo() end end, label = "HOME_FOREVER_BTN_GO", page = "trainer" },
	ranks = { fn = function() if ns.ForeverRankFixAll then ns.ForeverRankFixAll() end end, label = "FRANK_HOME_BTN" },
	classquest = { fn = function() if ns.ForeverClassQuestGo then ns.ForeverClassQuestGo() end end, label = "FCQ_BTN" },
	weapons = { fn = function() if ns.ShowForeverWeapons then ns.ShowForeverWeapons() end end, label = "FWEAP_TITLE" },
	-- "Room for a main profession": the overview's Professions tab (product plan step 6), else the trainer list.
	profs = { fn = function()
		if ns.ShowForeverOverviewPage then
			ns.ShowForeverOverviewPage("profs")
		elseif ns.ShowForeverProfTrainers then
			ns.ShowForeverProfTrainers()
		end
	end, label = "FPROF_TITLE" },
	dungeons = { fn = function() if ns.ShowForeverDungeons then ns.ShowForeverDungeons() end end, label = "FDUNG_BTN" },
	legacy = { page = "legacy", label = "FOV_TAB_LEGACY" },
	-- 21 Nov 2026 (Wolfsbane): Find on Two-Handed Swords (spell 202) with the arrow to the nearest weapon master.
	twohand = { fn = function()
		if ns.ShowForeverFind then
			ns.ShowForeverFind("weapon", 202)
		end
		local rows = ns.ForeverWeaponFindRows and ns.ForeverWeaponFindRows(202)
		if type(rows) == "table" and rows[1] and rows[1].go then
			rows[1].go()
		end
	end, label = "FCQ_BTN" },
	camp = { page = "camp", label = "FOV_TAB_CAMP" },
	-- No "talent" action, on purpose (Rob, 22 Nov 2026: "knop weg"): an addon that opens the talent window taints the
	-- action bars (docs/forever/TALENTKNOP_TAINT_2026-11-22.md). The line names the player's own key instead.
	-- 21 Nov 2026: Dual Spec is bought from your class trainer.
	dualspec = { fn = function() if ns.ForeverTrainerGo then ns.ForeverTrainerGo() end end, label = "HOME_FOREVER_BTN_GO" },
	-- 23 Nov 2026 (Rob via sparring: "Ik volg jullie advies weer."): the arrow to whoever takes a finished quest, read
	-- live from QuestieDB when the player has it (ForeverQuestieDB.lua).
	turnin = { fn = function() if ns.ForeverQuestieGoTurnIn then ns.ForeverQuestieGoTurnIn() end end, label = "FQDB_BTN_TURNIN" },
}
ns.FOREVER_DONOW_ACTS = ACTS

local Collect -- defined below; ns.ForeverDoNowCollect needs the local
--- The same lists the window shows, for the overview (pcall'd there).
function ns.ForeverDoNowCollect()
	return Collect()
end

function Collect()
	local level = UnitLevel and UnitLevel("player") or 1
	-- items: every now- and tip-line in order, { text, kind, tip = true for a tip, key = vendor key for a tool }.
	local out = { now = {}, actions = {}, soon = {}, tips = {}, items = {} }
	-- spells: the spell ids the line names (19 Nov 2026): the overview's Now card shows them as icons with the game's
	-- tooltip (its list scrolls, so links in the text could not answer the mouse there).
	local function item(text, kind, tip, key, spells)
		out.items[#out.items + 1] = { text = text, kind = kind, tip = tip, key = key, spells = spells }
	end
	-- 12 Nov 2026 (O26, Rob via sparring: "A, eerst klein"): room for a main profession. Only when both readings of
	-- ns.ForeverPrimaryCount agree. A tip, not a to-do: it does NOT make the window appear by itself (most new
	-- characters have room, and a window that never goes away is noise); it shows when the window is up anyway.
	if ns.ForeverPrimaryCount then
		local okP, n = pcall(ns.ForeverPrimaryCount)
		if okP and type(n) == "number" and n < 2 then
			out.tips[#out.tips + 1] = (n == 1) and ns:L("FDONOW_PROF_ONE") or ns:L("FDONOW_PROF_TWO")
			item(out.tips[#out.tips], "profs", true)
			out.actions.profs = true
		end
	end
	-- 14 Nov 2026 (Rob via sparring: "Voor A, beginnen we met stap 1"): dungeons that fit your level. A tip, like the
	-- profession one: it fits at almost every level, so it must not make the window appear by itself.
	if ns.ForeverDungeonTip then
		local okD, tip = pcall(ns.ForeverDungeonTip)
		if okD and tip then
			out.tips[#out.tips + 1] = tip
			item(tip, "dungeons", true)
			out.actions.dungeons = true
		end
	end
	-- Best stats for you now (tips: they never open the window by themselves).
	for _, s in ipairs(StatLines()) do
		out.tips[#out.tips + 1] = s
		item(s, "stats", true)
	end
	-- Do this now
	local r = ns.ForeverTrainerCompute and ns.ForeverTrainerCompute(level)
	if r and #r.now > 0 then
		out.now[#out.now + 1] = ns:L("HOME_FOREVER_TRAINER_NOW_FMT"):format(#r.now, Money(r.total))
		item(out.now[#out.now], "trainer")
		out.actions.trainer = true
	end
	local nRank = ns.ForeverRankCount and ns.ForeverRankCount() or 0
	if nRank > 0 then
		out.now[#out.now + 1] = (ns.ForeverRankSentence and ns.ForeverRankSentence()) or ns:L("FRANK_HOME_FMT"):format(nRank)
		item(out.now[#out.now], "ranks")
		out.actions.ranks = true
	end
	-- Class quest that unlocks something (16 Nov 2026, ForeverClassQuests.lua): a to-do, with the arrow button.
	-- A low-priority one (mage Study, 18 Nov 2026, Rob: "lager zetten") is a tip instead: after every to-do, and it does
	-- not open the window by itself.
	if ns.ForeverClassQuestNow then
		local okC, cq, _, low = pcall(ns.ForeverClassQuestNow)
		if okC and cq then
			if low then
				out.tips[#out.tips + 1] = cq
				item(cq, "classquest", true)
			else
				out.now[#out.now + 1] = cq
				item(cq, "classquest")
			end
			out.actions.classquest = true
		end
	end
	if not KeyBlockOn() then
		local noBar, noBarLinks, noBarIds = NoBarSpells()
		if #noBar > 0 then
			out.now[#out.now + 1] = ns:L("FDONOW_NOBAR_FMT"):format(table.concat(noBarLinks, ", "))
			item(out.now[#out.now], "nobar", nil, nil, noBarIds)
		end
	end
	-- 19 Nov 2026 (Rob: he found Comprehend Scroll himself, "Maar dit verrast mij"): an untranslated scroll in your bags
	-- (the 17 of ForeverProfGuide.lua, GEMETEN ItemSparse RequiredSkill 3012) → use Comprehend Scroll from the General tab
	-- (where Rob found it), or, without the spell and level 6+, learn it at your class trainer. Mages only.
	if select(2, UnitClass("player")) == "MAGE" and ns.ForeverCompScrollsCarried then
		local nScroll = ns.ForeverCompScrollsCarried()
		if nScroll > 0 then
			local spell = (C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(1296017)) or "Comprehend Scroll"
			if ns.ForeverKnowsComprehend and ns.ForeverKnowsComprehend() then
				local tab = ns.ForeverSpellbookGeneralTab and ns.ForeverSpellbookGeneralTab() or "General"
				out.now[#out.now + 1] = ns:L("FDONOW_COMP_USE_FMT"):format(nScroll, SpellLink(1296017, spell), tab)
				item(out.now[#out.now], "comp", nil, nil, { 1296017 })
			elseif level >= 6 then
				out.now[#out.now + 1] = ns:L("FDONOW_COMP_LEARN_FMT"):format(nScroll, SpellLink(1296017, spell))
				-- Its own kind: the overview folds every "trainer" line into its one rich trainer row (ForeverOverview
				-- NowItems), which would drop this sentence.
				item(out.now[#out.now], "comp", nil, nil, { 1296017 })
			end
		end
	end
	-- 21 Nov 2026 (Rob: "Ja, graag"): Study known and off cooldown → a tip with the library and your feathers. A tip, not a
	-- to-do (Study is low priority, Rob 18 Nov: "lager zetten"). Cooldown from C_Spell.GetSpellCooldown (1 h, DB2).
	if select(2, UnitClass("player")) == "MAGE" and ns.ForeverStudyLibraryLine and IsPlayerSpell
		and select(2, pcall(IsPlayerSpell, 1302508)) == true then
		local ready = true
		if C_Spell and C_Spell.GetSpellCooldown then
			local okC, cd = pcall(C_Spell.GetSpellCooldown, 1302508)
			if okC and type(cd) == "table" and type(cd.duration) == "number" and not (issecretvalue and issecretvalue(cd.duration))
				and cd.duration > 2 then
				ready = false
			end
		end
		local lib = ns.ForeverStudyLibraryLine()
		if ready and lib then
			local feather = ns.ForeverStudyFeatherLine()
			out.tips[#out.tips + 1] = ns:L("FDONOW_STUDY_READY_FMT"):format(SpellLink(1302508,
				(C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(1302508)) or "Study"), lib, feather)
			item(out.tips[#out.tips], "study", true, nil, { 1302508 })
		end
	end
	-- 12 Nov 2026 (Rob via sparring: "Ja, alle drie"): one/more as two sentences, and with a direction how many fit
	-- (the same player-guide fit as the green + in /mh weapons). The start page uses the same one/more sentences (without the direction part).
	local learn = ns.ForeverWeaponsLearnable and ns.ForeverWeaponsLearnable() or {}
	if #learn > 0 then
		local s = (#learn == 1) and ns:L("FDONOW_WEAP_ONE") or ns:L("FDONOW_WEAP_MANY_FMT"):format(#learn)
		local _, tree, fit = nil, nil, nil
		if ns.ForeverDirectionWeaponFit then
			_, tree, fit = ns.ForeverDirectionWeaponFit()
		end
		if tree and fit then
			local n = 0
			for _, k in ipairs(learn) do
				if fit[k] then
					n = n + 1
				end
			end
			s = s .. " " .. ns:L("FDONOW_WEAP_FIT_FMT"):format(tree, n)
		end
		out.now[#out.now + 1] = s
		item(s, "weapons")
		out.actions.weapons = true
	end
	-- 21 Nov 2026 (Rob via sparring: "Ja, doe dat maar"): an unused talent point → the next talent of your order
	-- (ForeverTalentNext.lua). A to-do: a free point is something to do now.
	if ns.ForeverTalentNextLine then
		local okT, line, spell = pcall(ns.ForeverTalentNextLine)
		if okT and line then
			out.now[#out.now + 1] = line
			item(line, "talent", nil, nil, spell and { spell } or nil)
			-- 22 Nov 2026 (Rob via sparring: "kunnen we de talent point meer laten opvallen", then "talent b"): the window
			-- shows this line on top, in gold (Render). Its button went the same day (Rob: "knop weg", see ACTS).
			out.talent = line
		end
	end
	-- 21 Nov 2026 (Rob via sparring: "Heb ik een two-handed sword nodig?"; GO "Ja, voeg dat maar toe"): the Wolfsbane class
	-- quest (Undead Paladin, item 267369 = a two-handed sword, GEMETEN by sparring's research) is no use without the skill.
	-- From 18 (its first quest can be taken then) a tip, from 20 a to-do: learn Two-Handed Swords (spell 202) first.
	-- Known = C_SpellBook.IsSpellKnown, then IsPlayerSpell / IsSpellKnown (IsPlayerSpell is only a deprecation fallback
	-- in Forever, GEMETEN in ForeverBlock.lua KnownId, 18 Nov 2026).
	local function Knows(id)
		for _, fn in ipairs({ C_SpellBook and C_SpellBook.IsSpellKnown or false, IsPlayerSpell or false,
			IsSpellKnown or false }) do
			if fn then
				local okK, v = pcall(fn, id)
				if okK and v == true then
					return true
				end
			end
		end
		return false
	end
	if select(2, UnitClass("player")) == "PALADIN" and level >= 18 and ns.ForeverClassQuestList and not Knows(202) then
		local okW, list = pcall(ns.ForeverClassQuestList)
		local wolfName = ns:L("FCQ_CHAIN_PA_WOLFSBANE")
		for _, e in ipairs(okW and type(list) == "table" and list or {}) do
			if e.chain == wolfName and e.state ~= "done" then
				-- Archibald (npc 11870) teaches it in Undercity (map 1458, ForeverWeapons.lua); the client names the city.
				local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(1458)
				-- His client name: "Archibald" except ptBR and ruRU (Wowhead Forever npc 11870 per locale, mh-writer 21 Nov).
				local loc = GetLocale and GetLocale() or "enUS"
				local npc = (loc == "ptBR" and "Arquibaldo") or (loc == "ruRU" and "Арчибальд") or "Archibald"
				local s = ns:L("FDONOW_WOLFSBANE_FMT"):format(e.chain, npc, info and info.name or "Undercity")
				if level >= 20 then
					out.now[#out.now + 1] = s
					item(s, "twohand")
				else
					out.tips[#out.tips + 1] = s
					item(s, "twohand", true)
				end
			end
		end
	end
	-- 21 Nov 2026 (same GO): Dual Spec from level 40 (Blizzard). Known = the switch spell 63644 (Activate Secondary Spec;
	-- the id is GEMETEN in DB2 by sparring's research, that the client reports it as known after learning = AFGELEID; /mh
	-- donow check prints it). A tip: it never opens the window by itself.
	if level >= 40 and not Knows(63644) then
		-- Paladin (sparring 21 Nov: "vanaf 40 tip: tweede spec = Prot"): the second set as Protection; MH follows the
		-- Protection order when the direction is Protection (ForeverTalentNext.lua).
		local ds = ns:L("FDONOW_DUALSPEC")
		if select(2, UnitClass("player")) == "PALADIN" then
			ds = ds .. " " .. ns:L("FTALENT_PROT_SECOND")
		end
		out.tips[#out.tips + 1] = ds
		-- Its own kind: the overview folds every "trainer" line into its one trainer row, which would drop this one.
		item(out.tips[#out.tips], "dualspec", true)
	end
	if ns.GetForeverMissingBuffs and ns.MissingBuffSentence then
		local ok, list = pcall(ns.GetForeverMissingBuffs)
		if ok and type(list) == "table" then
			for _, e in ipairs(list) do
				-- A buff that only runs out soon (19 Nov 2026) is the buff icon's job, not a to-do that opens this window.
				if not e.expiring then
					out.now[#out.now + 1] = ns.MissingBuffSentence(e, false)
					item(out.now[#out.now], "buff")
				end
			end
		end
	end
	-- 17 Nov 2026 (Legacy step 1, ForeverLegacy.lua): unused Legacy Points, only when the client lets us read them.
	if ns.ForeverLegacyNow then
		local okL, leg = pcall(ns.ForeverLegacyNow)
		if okL and leg then
			out.now[#out.now + 1] = leg
			item(leg, "legacy")
			out.actions.legacy = true
		end
	end
	-- 17 Nov 2026 (camping step 1, ForeverCamp.lua): near a fire without a camp buff → "sit down". Silent when unreadable.
	if ns.ForeverCampNow then
		local okF, camp = pcall(ns.ForeverCampNow)
		if okF and camp then
			out.now[#out.now + 1] = camp
			item(camp, "camp")
			out.actions.camp = true
		end
	end
	if ns.ForeverMissingTools then
		local ok, tools = pcall(ns.ForeverMissingTools)
		if ok and type(tools) == "table" then
			for _, t in ipairs(tools) do
				out.now[#out.now + 1] = ns:L("FDONOW_TOOL_FMT"):format(t.prof, t.tool, "/mh vendor " .. t.key)
				item(out.now[#out.now], "tool", false, t.key)
				out.actions.tool = out.actions.tool or t.key
			end
		end
	end
	-- 23 Nov 2026 (Rob via sparring: "Ja, doe maar OR-B. Maar dan moet je wel opvallen dat hij erin staat. En als er
	-- meerdere zijn in je tas, dan moet het ook blijven staan."): every upgrade in your bags, one line each, shown at the
	-- top (Render), green with an arrow, with [Wear it] and [Not this one] (ForeverWear.lua). out.wear = those lines.
	-- WEAR_TODO decides whether they open the window by themselves (Rob's choice A/B, see Decision).
	out.wear = {}
	if ns.ForeverWearLines then
		local okW, lines = pcall(ns.ForeverWearLines)
		if okW and type(lines) == "table" then
			out.wearLinks = {}
			for _, w in ipairs(lines) do
				out.wear[#out.wear + 1] = w.text
				out.wearLinks[#out.wearLinks + 1] = w.link
				item(w.plain, "wear", not WEAR_TODO, w.n)
			end
		end
	end
	-- 23 Nov 2026: a finished quest and who takes it (QuestieDB, only when the player has it). A tip, not a to-do: it
	-- does not make the window appear by itself.
	if ns.ForeverQuestieTurnInLine then
		local okT, line = pcall(ns.ForeverQuestieTurnInLine)
		if okT and type(line) == "string" then
			out.tips[#out.tips + 1] = line
			item(line, "turnin", true)
			out.actions.turnin = true
		end
	end
	-- Coming up: trainer spells above your level, up to 3 levels on
	local r3 = ns.ForeverTrainerCompute and ns.ForeverTrainerCompute(level + 3)
	local byLevel, levels = {}, {}
	for _, e in ipairs(r3 and r3.now or {}) do
		if e.l > level then
			if not byLevel[e.l] then
				byLevel[e.l] = {}
				levels[#levels + 1] = e.l
			end
			local nm = SpellName(e.id)
			-- 12 Nov 2026 (Rob via sparring: "Ja, alle drie"): a spell you already know comes as a stronger rank, so say
			-- which one ("Rank 2", the client's own subtext, as the trainer window shows it). A new spell gets no rank.
			if ns.ForeverKnownSpell and e.n and ns.ForeverKnownSpell(e.n) and C_Spell and C_Spell.GetSpellSubtext then
				local okR, rank = pcall(C_Spell.GetSpellSubtext, e.id)
				if okR and type(rank) == "string" and rank ~= "" and not (issecretvalue and issecretvalue(rank)) then
					nm = nm .. " (" .. rank .. ")"
				end
			end
			-- Compare on the plain text (two ids with one name would differ as links); show the first one as a link.
			byLevel[e.l].seen = byLevel[e.l].seen or {}
			if not byLevel[e.l].seen[nm] then
				byLevel[e.l].seen[nm] = true -- two ranks/variants with one name: once is enough
				byLevel[e.l][#byLevel[e.l] + 1] = SpellLink(e.id, nm)
			end
		end
	end
	table.sort(levels)
	for _, l in ipairs(levels) do
		out.soon[#out.soon + 1] = ns:L("FDONOW_SOON_LEVEL_FMT"):format(l, table.concat(byLevel[l], ", "))
	end
	if #out.soon == 0 then
		out.soon[#out.soon + 1] = GREY .. ns:L("FDONOW_SOON_NONE") .. "|r"
	end
	-- With a direction: its next talent spell (only facts the research holds: which spell belongs to which tree).
	local band, tree = nil, nil
	if ns.GetForeverDirection then
		band, tree = ns.GetForeverDirection()
	end
	if band and ns.ForeverDirectionTalents then
		local _, cls = UnitClass("player")
		for _, t in ipairs(ns.ForeverDirectionTalents(cls, band)) do
			if t.level > level then
				-- t.level already counts the Legacy perk Talented when its rank is readable; otherwise say it can be sooner.
				out.soon[#out.soon + 1] = ns:L("FDONOW_TALENT_FMT"):format(tree, SpellLink(t.id, SpellName(t.id)), t.level)
					.. (t.known and "" or ns:L("FDONOW_TALENTED_HINT"))
				break
			end
		end
	end
	return out
end

--- Shown or not, and why (for /mh donow check and Update).
local function Decision(info)
	if InCombatLockdown and InCombatLockdown() then
		return false, "in combat (back after the fight)"
	end
	if forced ~= nil then
		return forced, forced and "shown by /mh donow" or "hidden by /mh donow (this session)"
	end
	local m = Mode()
	if m == "off" then
		return false, "switched off (Settings, or /mh donow auto|always)"
	end
	if m == "always" then
		return true, "mode: always"
	end
	if #info.now > 0 then
		return true, ("mode: only when there is something to do; %d thing(s) to do"):format(#info.now)
	end
	if WEAR_TODO and #(info.wear or {}) > 0 then
		return true, ("mode: only when there is something to do; %d upgrade(s) in your bags"):format(#info.wear)
	end
	return false, "mode: only when there is something to do; nothing to do now"
end

local function Btn(f, x, onClick)
	local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	b:SetSize(90, 20)
	b:SetPoint("BOTTOMLEFT", x, 10)
	b:SetScript("OnClick", onClick)
	b:Hide()
	return b
end

local function SavePos()
	if not (win and ns.db) then
		return
	end
	local p, _, rp, x, y = win:GetPoint()
	ns.db.foreverDoNowPos = { p, rp, x, y, win:GetScale() }
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverDoNow", UIParent, "BackdropTemplate")
	f:SetSize(W, 120)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	f:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	f:SetBackdropColor(0.04, 0.04, 0.06, 0.85)
	f:SetBackdropBorderColor(0.6, 0.5, 0.2, 0.9)
	local pos = ns.db and ns.db.foreverDoNowPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
		if pos[5] then
			f:SetScale(pos[5])
		end
	else
		f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -40, -240)
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePos()
	end)
	-- Shift+scroll = size (the rule for every MH window).
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(self, delta)
		if not IsShiftKeyDown() then
			return
		end
		local s = math.max(0.6, math.min(2, (self:GetScale() or 1) + (delta > 0 and 0.1 or -0.1)))
		self:SetScale(s)
		SavePos()
	end)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.title:SetPoint("TOPLEFT", 10, -8)
	f.title:SetPoint("RIGHT", f, "RIGHT", -46, 0) -- leave room for the gear and the cross
	f.title:SetJustifyH("LEFT")
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)
	close:SetScale(0.8)
	close:SetScript("OnClick", function()
		forced = false
		closedWear = {}
		local okC, info = pcall(Collect)
		for _, l in ipairs(okC and info.wearLinks or {}) do
			closedWear[l] = true
		end
		f:Hide()
		print(PREFIX .. ns:L("FDONOW_CLOSED"))
	end)
	-- 12 Nov 2026 (Rob via sparring: "Tandwieltje (Recommended)"): a small gear next to the cross. A click opens a menu
	-- with the same three modes as the setting (one source: SetMode); the cross keeps hiding until the next login.
	local gear = CreateFrame("Button", nil, f)
	gear:SetSize(14, 14)
	gear:SetPoint("TOPRIGHT", -26, -7)
	gear:SetNormalTexture("Interface\\Buttons\\UI-OptionsButton")
	gear:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	gear:SetScript("OnEnter", function(self)
		if GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(ns:L("SET_FOREVER_DONOW_TITLE"))
			GameTooltip:AddLine(ns:L("FDONOW_GEAR_TIP"), 1, 1, 1, true)
			GameTooltip:Show()
		end
	end)
	gear:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	local menu = CreateFrame("Frame", nil, f, "BackdropTemplate")
	menu:SetPoint("TOPRIGHT", gear, "BOTTOMRIGHT", 4, -2)
	menu:SetFrameStrata("DIALOG")
	menu:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	menu:SetBackdropColor(0.06, 0.06, 0.09, 0.97)
	menu:SetBackdropBorderColor(0.6, 0.5, 0.2, 0.9)
	menu.items = {}
	for i, m in ipairs({ "auto", "always", "off" }) do
		local it = CreateFrame("Button", nil, menu)
		it:SetHeight(18)
		it:SetPoint("TOPLEFT", 6, -6 - (i - 1) * 18)
		it:SetPoint("RIGHT", menu, "RIGHT", -6, 0)
		it.text = it:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		it.text:SetPoint("LEFT", 2, 0)
		it:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
		it.mode = m
		it:SetScript("OnClick", function(self)
			menu:Hide()
			SetMode(self.mode)
			if ns.SyncNativeSetting then
				ns.SyncNativeSetting("mh_foreverDoNowMode", Mode())
			end
			if self.mode == "off" then
				print(PREFIX .. ns:L("FDONOW_OFF_HOW"))
			else
				print(PREFIX .. ns:L("FDONOW_MODE_CHAT_FMT"):format(ns:L("FDONOW_MODE_" .. self.mode:upper())))
			end
		end)
		menu.items[i] = it
	end
	menu:Hide()
	gear:SetScript("OnClick", function()
		if menu:IsShown() then
			menu:Hide()
			return
		end
		local wMax = 0
		for _, it in ipairs(menu.items) do
			local mark = (Mode() == it.mode) and "|cff7fff7f> |r" or "   "
			it.text:SetText(mark .. ns:L("FDONOW_MODE_" .. it.mode:upper()))
			wMax = math.max(wMax, it.text:GetStringWidth() or 0)
		end
		-- As wide as its longest line (lint [28]'s lesson: no text wider than its box).
		menu:SetSize(math.ceil(wMax) + 20, #menu.items * 18 + 12)
		menu:Show()
	end)
	f.gear, f.menu = gear, menu

	f.body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.body:SetPoint("TOPLEFT", 10, -26)
	f.body:SetWidth(W - 20)
	f.body:SetJustifyH("LEFT")
	f.body:SetSpacing(2)
	-- Spell names in the body are |Hspell links (SpellLink): hover = the game's own spell tooltip (19 Nov 2026). The body
	-- sits on the window itself, not in a ScrollFrame, so the window's hyperlink events reach it (PlayCardWindow.lua:97).
	-- Shift-click puts the spell in chat, as in the spellbook. Guarded: a client without it simply has no hover.
	if f.SetHyperlinksEnabled then
		f:SetHyperlinksEnabled(true)
		f:SetScript("OnHyperlinkEnter", function(self, link)
			if not (GameTooltip and link) then
				return
			end
			-- 23 Nov 2026: our own [Wear it] / [Not this one] links (ForeverWear.lua).
			if ns.ForeverWearLinkEnter and ns.ForeverWearLinkEnter(self, link) then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			pcall(GameTooltip.SetHyperlink, GameTooltip, link)
			GameTooltip:Show()
		end)
		f:SetScript("OnHyperlinkLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		f:SetScript("OnHyperlinkClick", function(_, link)
			if ns.ForeverWearLinkClick and ns.ForeverWearLinkClick(link) then
				return
			end
			local id = type(link) == "string" and tonumber(link:match("^spell:(%d+)"))
			if not (id and IsModifiedClick and IsModifiedClick("CHATLINK")) then
				return
			end
			local okL, sl = false, nil
			if C_Spell and C_Spell.GetSpellLink then
				okL, sl = pcall(C_Spell.GetSpellLink, id)
			end
			if okL and type(sl) == "string" and ChatEdit_InsertLink then
				pcall(ChatEdit_InsertLink, sl)
			end
		end)
	end
	f.btnTrainer = Btn(f, 10, function()
		if ns.ForeverTrainerGo then
			ns.ForeverTrainerGo()
		end
	end)
	f.btnRanks = Btn(f, 104, function()
		if ns.ForeverRankFixAll then
			ns.ForeverRankFixAll()
		end
	end)
	f.btnWeapons = Btn(f, 198, function()
		if ns.ShowForeverWeapons then
			ns.ShowForeverWeapons()
		end
	end)
	f.btnProfs = Btn(f, 10, function()
		ACTS.profs.fn()
	end)
	f.btnClassQuest = Btn(f, 10, function()
		if ns.ForeverClassQuestGo then
			ns.ForeverClassQuestGo()
		end
	end)
	f.btnDungeons = Btn(f, 10, function()
		if ns.ShowForeverDungeons then
			ns.ShowForeverDungeons()
		end
	end)
	f.btnTurnIn = Btn(f, 10, function()
		ACTS.turnin.fn()
	end)
	-- 17 Nov 2026 (product plan step 2): the same list, bigger, with a button per line.
	f.btnOverview = Btn(f, 10, function()
		if ns.ShowForeverOverviewPage then
			ns.ShowForeverOverviewPage("now")
		end
	end)
	-- 24 Nov 2026 (Rob: "kunnen we hier onder ook een knop how to play toevoegen"): this character's play card.
	f.btnPlay = Btn(f, 10, function()
		if ns.ShowPlayCardWindow then
			ns.ShowPlayCardWindow()
		end
	end)
	f:Hide()
	-- 17 Nov 2026: style A, like the overview (ForeverStyle.lua S.SkinWindow; Rob: "alle andere vensters ... in
	-- dezelfde stijl").
	if ns.ForeverStyle and ns.ForeverStyle.SkinOnShow then
		ns.ForeverStyle.SkinOnShow(f)
	end
	win = f
	return f
end

-- 24 Nov 2026 (Rob: "in het rijtje van gold aan de linkerzijde het aantal open tas plaatsen"): free bag slots left of
-- your money. Only normal bags count (ForeverWarnings FreeSlots: bag family 0, so no quiver, ammo pouch or soul bag:
-- those hold one kind of thing, and a free arrow slot is no room for loot). Orange from 5 free (or your own bag-warning
-- limit when that is higher), red at 0. Nothing is shown when the bags cannot be read.
local BAG_ICON = "|TInterface\\Buttons\\Button-Backpack-Up:14:14|t "
local BAG_LOW = 5

local function BagText(f)
	if not (f and f.money) then
		return
	end
	if not f.bags then
		f.bags = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		f.bags:SetPoint("RIGHT", f.money, "LEFT", -12, 0)
		f.bags:SetJustifyH("RIGHT")
	end
	local free = ns.ForeverFreeBagSlots and ns.ForeverFreeBagSlots()
	if type(free) ~= "number" then
		f.bags:SetText("")
		return
	end
	local low = math.max(BAG_LOW, (ns.ForeverBagWarnAt and ns.ForeverBagWarnAt()) or 0)
	local color = (free == 0 and "|cffff4040") or (free <= low and "|cffff9933") or "|cffffffff"
	f.bags:SetText(BAG_ICON .. color .. ns:L("FDONOW_BAGS_FREE_FMT"):format(free) .. "|r")
end

local function Render(info)
	local f = Build()
	f.title:SetText(ns:L("FDONOW_TITLE"))
	local lines = {}
	local wear = info.wear or {}
	if #info.now > 0 or #wear > 0 then
		-- 22 Nov 2026 (Rob: "talent b"): the talent line first, gold with a star and an empty line under it. No glow.
		if info.talent then
			lines[1] = STAR .. " " .. Golden(info.talent)
			if #info.now > 1 or #(info.tips or {}) > 0 or #wear > 0 then -- else the empty line above "Coming up" does it
				lines[2] = " "
			end
		end
		-- 23 Nov 2026 (Rob: "opvallen"): the upgrades right under the talent line, above everything else.
		for _, s in ipairs(wear) do
			lines[#lines + 1] = s
		end
		if #wear > 0 and #info.now > (info.talent and 1 or 0) then
			lines[#lines + 1] = " "
		end
		-- No "Do this now" heading under the "Do this now" title (Rob via sparring: "Ja, alle drie").
		for _, s in ipairs(info.now) do
			if s ~= info.talent then
				lines[#lines + 1] = "- " .. s
			end
		end
	else
		lines[#lines + 1] = GOOD .. ns:L("FDONOW_HEAD_DONE") .. "|r"
	end
	for _, s in ipairs(info.tips or {}) do
		lines[#lines + 1] = "- " .. s
	end
	lines[#lines + 1] = " "
	lines[#lines + 1] = HEAD .. ns:L("FDONOW_HEAD_SOON") .. "|r"
	for _, s in ipairs(info.soon) do
		lines[#lines + 1] = "- " .. s
	end
	f.body:SetText(table.concat(lines, "\n"))
	f.btnTrainer:SetText(ns:L("HOME_FOREVER_BTN_GO"))
	f.btnRanks:SetText(ns:L("FRANK_HOME_BTN"))
	f.btnWeapons:SetText(ns:L("FWEAP_TITLE"))
	f.btnProfs:SetText(ns:L("FPROF_TITLE"))
	f.btnDungeons:SetText(ns:L("FDUNG_BTN"))
	f.btnClassQuest:SetText(ns:L("FCQ_BTN"))
	f.btnTurnIn:SetText(ns:L("FQDB_BTN_TURNIN"))
	f.btnOverview:SetText(ns:L("FDONOW_OPEN_OVERVIEW"))
	f.btnPlay:SetText(ns:L("FOV_TAB_PLAY"))
	-- Buttons only for what is on the list; they close up from the left. Each as wide as its own text (Rob's 21.png,
	-- 12 Nov 2026: "Weapon trainers" stuck out of a fixed 90 px button), and a new row when the next one does not fit.
	local shown = {}
	for _, pair in ipairs({ { f.btnClassQuest, info.actions.classquest },
		{ f.btnTrainer, info.actions.trainer }, { f.btnRanks, info.actions.ranks },
		{ f.btnWeapons, info.actions.weapons }, { f.btnProfs, info.actions.profs },
		{ f.btnDungeons, info.actions.dungeons }, { f.btnTurnIn, info.actions.turnin },
		{ f.btnOverview, ns.ShowForeverOverviewPage ~= nil }, { f.btnPlay, ns.ShowPlayCardWindow ~= nil } }) do
		local b, on = pair[1], pair[2]
		if on then
			local fs = b:GetFontString()
			b:SetWidth(math.min(W - 20, math.max(80, math.ceil(((fs and fs:GetStringWidth()) or 70) + 24))))
			shown[#shown + 1] = b
		else
			b:Hide()
		end
	end
	local rows, x = {}, 10
	for _, b in ipairs(shown) do
		if #rows == 0 or x + b:GetWidth() > W - 10 then
			rows[#rows + 1] = {}
			x = 10
		end
		local r = rows[#rows]
		r[#r + 1] = { b = b, x = x }
		x = x + b:GetWidth() + 4
	end
	-- 19 Nov 2026 (Rob: "dat ik in dat overzichtje rechts onderin mijn goudvoorraadje krijg ... ik doe nu heel vaak mijn
	-- tas open om te kijken hoeveel geld ik heb"): your money on its own line at the bottom right (gold, silver and copper
	-- with coins, ForeverStyle.Money); the buttons sit above it. Refreshed on PLAYER_MONEY (moneyEv below).
	local MONEY_H = 16
	for i, r in ipairs(rows) do
		local y = 10 + MONEY_H + (#rows - i) * 24
		for _, e in ipairs(r) do
			e.b:ClearAllPoints()
			e.b:SetPoint("BOTTOMLEFT", e.x, y)
			e.b:Show()
		end
	end
	if not f.money then
		f.money = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		f.money:SetPoint("BOTTOMRIGHT", -10, 8)
		f.money:SetJustifyH("RIGHT")
	end
	f.money:SetText(Money(GetMoney and GetMoney() or 0))
	BagText(f)
	local btnH = (#rows > 0) and (#rows * 24 + 6) or 0
	f:SetHeight(26 + f.body:GetStringHeight() + 12 + btnH + MONEY_H)
end

-- Your money in the corner follows every change (looting, buying, the trainer), without refilling the whole list.
local moneyEv = CreateFrame("Frame")
moneyEv:RegisterEvent("PLAYER_MONEY")
moneyEv:RegisterEvent("BAG_UPDATE_DELAYED")
moneyEv:SetScript("OnEvent", function(_, event)
	if event == "BAG_UPDATE_DELAYED" then
		if win then
			BagText(win)
		end
	elseif win and win.money then
		win.money:SetText(Money(GetMoney and GetMoney() or 0))
	end
end)

local lastWhy = "not checked yet"

local function Update()
	local okC, info = pcall(Collect)
	if not okC then
		lastWhy = "error while collecting: " .. tostring(info)
		if win then
			win:Hide()
		end
		return
	end
	-- A new upgrade after you closed the window: it may open again (WEAR_TODO, see closedWear at the top).
	if WEAR_TODO and forced == false and closedWear then
		for _, l in ipairs(info.wearLinks or {}) do
			if not closedWear[l] then
				forced, closedWear = nil, nil
				break
			end
		end
	end
	local show, why = Decision(info)
	lastWhy = why
	if show then
		Render(info)
		win:Show()
	elseif win then
		win:Hide()
	end
end
ns.ForeverDoNowUpdate = Update

function ns.ForeverDoNowSlash(arg)
	arg = (arg or ""):lower()
	if arg == "auto" or arg == "always" or arg == "off" then
		SetMode(arg)
		if ns.SyncNativeSetting then
			ns.SyncNativeSetting("mh_foreverDoNowMode", Mode())
		end
		print(PREFIX .. ns:L("FDONOW_MODE_CHAT_FMT"):format(ns:L("FDONOW_MODE_" .. arg:upper())))
	elseif arg == "check" or arg == "why" then
		local ok, info = pcall(Collect)
		if not ok then
			print(PREFIX .. "do this now: error - " .. tostring(info))
			return
		end
		local show, why = Decision(info)
		print(PREFIX .. ("do this now: mode %s; %s - %s"):format(Mode(), show and "shown" or "not shown", why))
		print(("  to do now: %d; coming up: %d line(s); last update: %s"):format(#info.now, #info.soon, lastWhy))
		-- Legacy perk Talented (17 Nov 2026): what MH read, so a wrong talent level can be traced (silence rule).
		if ns.ForeverTalentedRank then
			local r, how = ns.ForeverTalentedRank()
			print(("  Legacy perk Talented: rank %s (%s); talent levels are %s"):format(tostring(r), tostring(how),
				r and ("moved " .. r .. " level(s) sooner") or "the plain ones, with the hint 'sooner with Talented'"))
		end
		for _, s in ipairs(info.now) do
			print("  - " .. s)
		end
		-- Best stats (16 Nov 2026): role, where it came from, and the order used by this line, the tooltip and the hint.
		local token = select(2, UnitClass("player"))
		if ns.ForeverStatDef then
			local def, role, src = ns.ForeverStatDef(token)
			local tree
			if ns.GetForeverDirection then
				local _, t = ns.GetForeverDirection()
				tree = t
			end
			print(("  stats: class %s, role %s, from %s%s; order %s%s"):format(tostring(token), tostring(role), tostring(src),
				tree and (" (" .. tostring(tree) .. ")") or "", def and def.main and table.concat(def.main, " > ") or "none",
				def and def.equal and " (counted the same)" or ""))
			local tank = ns.ForeverTankStatDef and ns.ForeverTankStatDef(token)
			print("  tank line: " .. (tank and table.concat(tank.main, " > ") or "none (this class cannot tank)"))
		end
		-- 21 Nov 2026: the two spells the Wolfsbane and Dual Spec lines look at.
		local function knows(id)
			local parts = {}
			for _, p in ipairs({ { "SpellBook", C_SpellBook and C_SpellBook.IsSpellKnown }, { "IsPlayerSpell", IsPlayerSpell },
				{ "IsSpellKnown", IsSpellKnown } }) do
				parts[#parts + 1] = p[1] .. "=" .. (p[2] and tostring(select(2, pcall(p[2], id))) or "none")
			end
			return table.concat(parts, " ")
		end
		print(("  Two-Handed Swords (202) known: %s · Dual Spec switch (63644) known: %s"):format(knows(202), knows(63644)))
		-- New spell on no bar (16 Nov 2026): the decision and why.
		local noBar = NoBarSpells()
		print(("  new spells on no bar: %s; key block placed: %s (then MH stays silent: the block asks itself)"):format(
			#noBar > 0 and table.concat(noBar, ", ") or "none", tostring(KeyBlockOn())))
	else
		forced = not (win and win:IsShown())
		Update()
	end
end

-- Events: anything that can change a line. Throttled to one update per half second.
local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_LEVEL_UP", "SPELLS_CHANGED", "PLAYER_REGEN_ENABLED",
	"PLAYER_REGEN_DISABLED", "BAG_UPDATE_DELAYED", "ACTIONBAR_SLOT_CHANGED", "SKILL_LINES_CHANGED", "PLAYER_MONEY",
	"UNIT_PET", "UPDATE_BINDINGS", "QUEST_LOG_UPDATE" }) do -- QUEST_LOG_UPDATE: class-quest steps (16 Nov 2026; exists in Forever, snapshot)
	pcall(ev.RegisterEvent, ev, e)
end
pcall(ev.RegisterUnitEvent, ev, "UNIT_AURA", "player")
-- Legacy Points (17 Nov 2026): the events Blizzard's own Legacy button and tree use (GEMETEN in its UI code, 70938).
for _, e in ipairs({ "TRAIT_TREE_CURRENCY_INFO_UPDATED", "TRAIT_CONFIG_UPDATED", "MAJOR_FACTION_RENOWN_LEVEL_CHANGED" }) do
	pcall(ev.RegisterEvent, ev, e)
end
local queued = false
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_DISABLED" then
		if win then
			win:Hide()
		end
		return
	end
	if queued then
		return
	end
	queued = true
	C_Timer.After(event == "PLAYER_ENTERING_WORLD" and 4 or 0.5, function()
		queued = false
		Update()
	end)
end)
