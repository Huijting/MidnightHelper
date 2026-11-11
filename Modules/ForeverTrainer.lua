local _, ns = ...

--[[
	ForeverTrainer.lua — WoW Forever: "new at your trainer", with the key each spell lands on.

	Rob, 7 Nov 2026: "ik denk aan a en dan evt zelf de optie geven om een pijl naar de trainer maken, dan hoeven we niet
	de extra addon te installeren" → "Ja, A + pijl". This file is step A; the arrow to the trainer is step 2.
	Idea from What's Training? (docs/forever/WHATS_TRAINING_2026-11-07.md). What MH adds: the KEY. What's Training knows
	what you can learn; only MH knows where it goes on your block.

	Data: ForeverTrainerData.lua (generated from What's Training?'s MIT data, levels cross-checked with our research).
	  - At every level-up: one chat line, and the window opens by itself when there is something to learn (out of combat).
	    /mh trainer auto off stops the window opening by itself (the chat line stays) — players choose, not us.
	  - /mh trainer        opens or closes the window (with the "Take me to my trainer" button, step 2)
	  - /mh trainer go     the arrow to your nearest class trainer; /mh trainer here records one; /mh trainer forget
	  - /mh trainer mark   the cross above your trainer when you arrive (step 3): on | off | plates, bare = diagnosis
	  - /mh trainer check  prints what was decided and why (a module whose normal result is "nothing" needs a way to see
	                       that it decided nothing on purpose — CLAUDE.md).
	Window texts are FTRAIN_* locale keys since 7 Nov 2026 (enUS + nlNL; the other packs in the translation round). The
chat lines of /mh trainer check stay English (a diagnosis).
]]

if not ns.IS_FOREVER then
	return
end

local DATA = ns.FOREVER_TRAINER_SPELLS

-- First ranks you only get from a class quest, never from the trainer (Rob, 11 Nov 2026: "Als ik er geen ervaring mee
-- had, snapte ik er niks van" → "Ja, bouw dat"). When one of these is the missing "first" rank, the trainer window says
-- it comes from a class quest. Source: docs/forever/FOREVER_QUEST_LOCKED_SPELLS_2026-11-11.md (mh-research; Wowhead
-- Forever "Reward from", Icy Veins 4 Nov 2026, Forever DB2 teaching spells). Hand-kept, not generated.
ns.FOREVER_QUEST_FIRST = {
	[7328] = true, -- Paladin: Redemption (12)
	[635] = true, -- Paladin: Holy Light, Undead only (2); Human/Dwarf start with it, so it is never "missing" for them
	[71] = true, [355] = true, [7386] = true, -- Warrior: Defensive Stance, Taunt, Sunder Armor (10)
	[2458] = true, [20252] = true, -- Warrior: Berserker Stance, Intercept (30, The Affray)
	[1515] = true, [883] = true, [2641] = true, -- Hunter: Tame Beast, Call Pet, Dismiss Pet (10)
	[5149] = true, [6991] = true, [982] = true, -- Hunter: Beast Training, Feed Pet, Revive Pet (10)
	[2842] = true, -- Rogue: Poisons (20)
	[1277370] = true, [13896] = true, [13908] = true, [1277331] = true, [10797] = true, [2651] = true, -- Priest race
	[1277455] = true, [1277462] = true, [9035] = true, [18137] = true, [2652] = true, [1277324] = true, -- spells (10/20)
	[8071] = true, [3599] = true, [5394] = true, -- Shaman: Stoneskin (4), Searing (10), Healing Stream Totem (20)
	[688] = true, [697] = true, [712] = true, [713] = true, [691] = true, -- Warlock: Imp, Voidwalker, Succubus, Incubus, Felhunter
	[5487] = true, [6795] = true, [6807] = true, -- Druid: Bear Form, Growl, Maul (10)
	[1066] = true, -- Druid: Aquatic Form (16)
	[768] = true, [5215] = true, [1082] = true, [1079] = true, -- Druid: Cat Form, Prowl, Claw, Rip (20)
}

local function Token()
	local _, token = UnitClass("player")
	return token
end

local function Settings()
	if not ns.db then
		return { auto = true }
	end
	ns.db.foreverTrainer = ns.db.foreverTrainer or { auto = true }
	return ns.db.foreverTrainer
end

--- Does this character have this exact spell id?
local function KnownId(id)
	for _, fn in ipairs({ IsPlayerSpell, IsSpellKnown }) do
		if fn then
			local ok, v = pcall(fn, id)
			if ok and v == true then
				return true
			end
		end
	end
	return false
end

local function SpellName(e)
	if C_Spell and C_Spell.GetSpellName then
		local ok, nm = pcall(C_Spell.GetSpellName, e.id)
		if ok and type(nm) == "string" and nm ~= "" and not (issecretvalue and issecretvalue(nm)) then
			return nm
		end
	end
	return e.n
end

local function RankText(id)
	if C_Spell and C_Spell.GetSpellSubtext then
		local ok, sub = pcall(C_Spell.GetSpellSubtext, id)
		if ok and type(sub) == "string" and sub ~= "" and not (issecretvalue and issecretvalue(sub)) then
			return sub
		end
	end
	return nil
end

local function Money(c)
	if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
		local ok, s = pcall(C_CurrencyInfo.GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	if GetCoinTextureString then
		return GetCoinTextureString(c)
	end
	return tostring(c) .. "c"
end

--- Where a spell goes on the key block: "Q", "block D", or nil (not on the block).
local function KeyFor(token, name)
	local cls = ns.FOREVER_BLOCK_CLASSES and ns.FOREVER_BLOCK_CLASSES[token]
	if not cls then
		return nil
	end
	local function has(v)
		if type(v) == "string" then
			return v == name
		elseif type(v) == "table" then
			for _, n in ipairs(v) do
				if n == name then
					return true
				end
			end
		end
		return false
	end
	local label = ns.KeyBlockKeyLabel or function(k) return k end
	for key, def in pairs(cls.keys or {}) do
		for field, v in pairs(def) do
			if field == "pair" then
				if has(v.first) or has(v.second) then
					return label(key)
				end
			elseif field ~= "cmd" and field ~= "open" and field ~= "bang" and has(v) then
				return label(key)
			end
		end
	end
	if has(cls.toBlockD) then
		return ns:L("FTRAIN_BLOCK_D") -- the pack's own word, as in KEYBLOCK_UNPLACED_FMT ("bloc D", "Block D" …)
	end
	if has(cls.listed) then
		return false -- left off the block ON PURPOSE (the class table's `listed`), not forgotten
	end
	return nil
end

--- Everything the window and the check need, for this character at this level.
local function Compute(level)
	local token = Token()
	local list = DATA and token and DATA[token]
	local out = { token = token, level = level, now = {}, needs = {}, next = {}, nextLevel = nil, known = 0, other = 0,
		total = 0, data = list and #list or 0 }
	if not list then
		return out
	end
	local faction = UnitFactionGroup and UnitFactionGroup("player")
	local _, _, raceID = UnitRace("player")
	local levelOf = {}
	for _, e in ipairs(list) do
		levelOf[e.id] = e.l
	end
	-- Highest rank this character has under each name: a lower rank counts as known once a higher one is (Forever
	-- replaces some ranks in the spellbook; What's Training keeps "overriddenGroups" for the same reason).
	local bestByName = {}
	local function Known(e)
		if KnownId(e.id) then
			return true
		end
		if bestByName[e.n] == nil then
			local id = ns.ForeverKnownSpell and ns.ForeverKnownSpell(e.n)
			bestByName[e.n] = id or false
		end
		local best = bestByName[e.n]
		return best and levelOf[best] and levelOf[best] >= e.l or false
	end
	local function Fits(e)
		if e.fac and e.fac ~= faction then
			return false
		end
		if e.race and e.race ~= raceID then
			return false
		end
		if e.races then
			local ok = false
			for _, r in ipairs(e.races) do
				if r == raceID then
					ok = true
				end
			end
			if not ok then
				return false
			end
		end
		if e.tal and not KnownId(e.tal) then
			return false -- a talent spell: only for whoever took the talent
		end
		return true
	end
	local avail = {}
	for _, e in ipairs(list) do
		if not Fits(e) then
			out.other = out.other + 1
		elseif Known(e) then
			out.known = out.known + 1
		elseif e.l <= level then
			local missing
			for _, r in ipairs(e.req or {}) do
				-- The previous rank counts when any rank of that name is known: Forever swaps some out of the spellbook
				-- (Seal of Righteousness 20154 -> 21084 with Judgement; What's Training's "overriddenGroups").
				local byName = false
				if not KnownId(r) and not avail[r] and C_Spell and C_Spell.GetSpellName and ns.ForeverKnownSpell then
					local okN, rn = pcall(C_Spell.GetSpellName, r)
					byName = okN and type(rn) == "string" and ns.ForeverKnownSpell(rn) and true or false
				end
				if not KnownId(r) and not avail[r] and not byName then
					missing = r
				end
			end
			if missing then
				local nm
				if C_Spell and C_Spell.GetSpellName then
					local ok, n = pcall(C_Spell.GetSpellName, missing)
					nm = ok and n or nil
				end
				out.needs[#out.needs + 1] = { e = e, first = nm or ("spell " .. missing),
					fromQuest = ns.FOREVER_QUEST_FIRST and ns.FOREVER_QUEST_FIRST[missing] or nil }
			else
				avail[e.id] = true
				out.now[#out.now + 1] = e
				out.total = out.total + e.c
			end
		elseif not out.nextLevel or e.l == out.nextLevel then
			out.nextLevel = e.l
			out.next[#out.next + 1] = e
		end
	end
	return out
end
ns.ForeverTrainerCompute = Compute -- the offline check calls it

local function Line(token, e)
	local name = SpellName(e)
	local rank = RankText(e.id)
	local key = KeyFor(token, e.n)
	local passive = false
	if not key and C_Spell and C_Spell.IsSpellPassive then
		local okP, p = pcall(C_Spell.IsSpellPassive, e.id)
		passive = okP and p == true
	end
	-- Rob, 7 Nov 2026 ("Ja, pas aan"): Track Beasts said "put it on your own bar" although the Hunter table leaves all
	-- tracking off the block on purpose. `false` from KeyFor = on purpose; nil = really not in our list.
	local where = key and ("|cffffd100" .. key .. "|r")
		or passive and ("|cff9d9d9d" .. ns:L("FTRAIN_PASSIVE") .. "|r")
		or key == false and ("|cff9d9d9d" .. ns:L("FTRAIN_ON_PURPOSE") .. "|r")
		or ("|cff9d9d9d" .. ns:L("FTRAIN_OWN_BAR") .. "|r")
	return ("- %s%s  %s  ->  %s"):format(name, rank and (" |cff9d9d9d(" .. rank .. ")|r") or "", Money(e.c), where)
end

--------------------------------------------------------------------------------
-- Shaman totems need their element's Totem item in your bags. Rob, 7 Nov 2026: a Tauren learned Earthbind Totem at 6,
-- the tooltip said "Tools: Earth Totem" in red and nothing of ours had told him ("ja" to this note).
-- Items MEASURED (wago ItemSparse 1.60.1.70862, TotemCategory): 5175 Earth, 5176 Fire, 5177 Water, 5178 Air. Which spell
-- needs which is NOT a list of ours: the game's own tooltip says it ("Tools: <item>"), so we read that line.
-- Quest levels and starting NPCs: two mh-research reports of 7 Nov 2026 that agreed (Icy Veins Forever class quests,
-- Wowhead Forever, the Zygor Forever guide). Only what both had; elsewhere the line gives the level alone.
--------------------------------------------------------------------------------
local TOTEM_ITEMS = { 5175, 5176, 5177, 5178 }
local TOTEM_LEVEL = { [5175] = 4, [5176] = 10, [5177] = 20, [5178] = 30 }
-- English NPC and place names, so only shown on an English client (on others the client says other names).
local TOTEM_FROM = {
	[5175] = {
		Tauren = "Seer Ravenfeather, Camp Narache",
		Orc = "Canaga Earthcaller, Durotar",
		Troll = "Canaga Earthcaller, Durotar",
		Dwarf = "Teo Hammerstorm, Anvilmar",
	},
	[5176] = { Tauren = "Narm Skychaser, Bloodhoof Village" },
	[5177] = { Tauren = "Searn Firewarder, Orgrimmar", Orc = "Searn Firewarder, Orgrimmar", Troll = "Searn Firewarder, Orgrimmar" },
	[5178] = { Tauren = "Searn Firewarder, Orgrimmar", Orc = "Searn Firewarder, Orgrimmar", Troll = "Searn Firewarder, Orgrimmar" },
}
if C_Item and C_Item.RequestLoadItemDataByID then
	for _, it in ipairs(TOTEM_ITEMS) do
		pcall(C_Item.RequestLoadItemDataByID, it)
	end
end

local function TotemItemName(it)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, it)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	if GetItemInfo then
		local ok, n = pcall(GetItemInfo, it)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
end

local totemOf = {} -- [spell id] = item id, or false (needs none)
local totemScan
--- The Totem item this spell needs, from the "Tools:" line of the game's tooltip; nil when that cannot be read (yet).
local function TotemFor(id)
	if totemOf[id] ~= nil then
		return totemOf[id] or nil
	end
	local names = {}
	for _, it in ipairs(TOTEM_ITEMS) do
		names[it] = TotemItemName(it)
		if not names[it] then
			return nil -- item data not loaded yet: ask again next time, do not remember "none"
		end
	end
	totemScan = totemScan or CreateFrame("GameTooltip", "MidnightHelperTotemScan", nil, "GameTooltipTemplate")
	totemScan:SetOwner(WorldFrame, "ANCHOR_NONE")
	totemScan:ClearLines()
	if not pcall(totemScan.SetSpellByID, totemScan, id) then
		return nil
	end
	-- "Tools: %s" in the client's own words when the global exists; else a short line that ENDS with the item name
	-- (a description such as "Summons a Strength of Earth Totem." ends with a full stop and is long).
	local prefix = type(SPELL_TOTEMS) == "string" and SPELL_TOTEMS:match("^(.-)%%s") or nil
	local found = false
	for i = 2, totemScan:NumLines() do
		local fs = _G["MidnightHelperTotemScanTextLeft" .. i]
		local t = fs and fs:GetText()
		if type(t) == "string" and not (issecretvalue and issecretvalue(t)) then
			for it, n in pairs(names) do
				local hit
				if prefix and prefix ~= "" then
					hit = t:sub(1, #prefix) == prefix and t:find(n, 1, true)
				else
					hit = #t <= #n + 12 and t:sub(-#n) == n
				end
				if hit then
					found = it
				end
			end
		end
	end
	totemScan:Hide()
	totemOf[id] = found
	return found or nil
end

local function HasItem(it)
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return true -- cannot tell: say nothing rather than claim it is missing
	end
	local ok, n = pcall(fn, it)
	return not ok or (tonumber(n) or 0) > 0
end

--- "needs the Earth Totem from a Shaman quest at level 4 (starts at …)", or nil when nothing is missing.
local function TotemNote(token, id)
	if token ~= "SHAMAN" then
		return nil
	end
	local it = TotemFor(id)
	if not it or HasItem(it) then
		return nil
	end
	local s = ns:L("FTRAIN_TOTEM_FMT"):format(TotemItemName(it) or "?", TOTEM_LEVEL[it])
	local race = select(2, UnitRace("player"))
	local from = GetLocale() == "enUS" and TOTEM_FROM[it] and TOTEM_FROM[it][race]
	if from then
		s = s .. " " .. ns:L("FTRAIN_TOTEM_FROM_FMT"):format(from)
	end
	return s, it
end

--- Totem spells you already know but cannot place, grouped by the missing item: { {it=, names={...}, note=}, ... }.
local function KnownTotemsMissing(r)
	local out, byItem = {}, {}
	if r.token ~= "SHAMAN" then
		return out
	end
	for _, e in ipairs((DATA and DATA[r.token]) or {}) do
		if e.l <= (r.level or 0) and KnownId(e.id) then
			local note, it = TotemNote(r.token, e.id)
			if note then
				local g = byItem[it]
				if not g then
					g = { it = it, names = {}, seen = {}, note = note }
					byItem[it] = g
					out[#out + 1] = g
				end
				if not g.seen[e.n] then
					g.seen[e.n] = true
					g.names[#g.names + 1] = SpellName(e)
				end
			end
		end
	end
	return out
end

--- The window's lines, plus `ids[i]` = the spell id of line i (for its tooltip) or nil.
local function Text(r)
	local p, ids = {}, {}
	local HEAD = "|cffffcc66"
	-- Rob, 7 Nov 2026: "dat we ook kunnen zien hoeveel geld we hebben … nu moet ik ook eerst op B drukken". Your money
	-- on top; red with what is missing when it is not enough for everything you can learn now.
	local have = GetMoney and GetMoney()
	if have then
		local short = #r.now > 0 and have < r.total
		p[#p + 1] = HEAD .. ns:L("FTRAIN_MONEY") .. "|r  " .. Money(have) ..
			(short and ("  |cffff5555" .. ns:L("FTRAIN_SHORT_FMT"):format(Money(r.total - have)) .. "|r") or "")
		p[#p + 1] = ""
	end
	local TOTEM = "|cffff8040"
	local stuck = KnownTotemsMissing(r)
	if #stuck > 0 then
		p[#p + 1] = HEAD .. ns:L("FTRAIN_TOTEM_HEAD") .. "|r"
		for _, g in ipairs(stuck) do
			p[#p + 1] = "- " .. table.concat(g.names, ", ") .. ": " .. TOTEM .. g.note .. "|r"
		end
		p[#p + 1] = ""
	end
	if #r.now > 0 then
		p[#p + 1] = HEAD .. ns:L("FTRAIN_NOW_FMT"):format(#r.now) .. "|r  " .. Money(r.total)
		for _, e in ipairs(r.now) do
			p[#p + 1] = Line(r.token, e)
			ids[#p] = e.id
			local note = TotemNote(r.token, e.id)
			if note then
				p[#p + 1] = "    " .. TOTEM .. note .. "|r"
			end
		end
		p[#p + 1] = "|cff9d9d9d" .. ns:L("FTRAIN_KEY_HINT") .. "|r"
	else
		p[#p + 1] = HEAD .. ns:L("FTRAIN_NOTHING") .. "|r"
	end
	if #r.needs > 0 then
		p[#p + 1] = ""
		p[#p + 1] = HEAD .. ns:L("FTRAIN_NEEDS_HEAD") .. "|r"
		for _, n in ipairs(r.needs) do
			p[#p + 1] = ns:L(n.fromQuest and "FTRAIN_NEEDS_QUEST_FMT" or "FTRAIN_NEEDS_FMT"):format(SpellName(n.e), n.first)
			ids[#p] = n.e.id
		end
	end
	if r.nextLevel then
		p[#p + 1] = ""
		p[#p + 1] = HEAD .. ns:L("FTRAIN_NEXT_FMT"):format(r.nextLevel) .. "|r"
		for _, e in ipairs(r.next) do
			p[#p + 1] = Line(r.token, e)
			ids[#p] = e.id
			local note = TotemNote(r.token, e.id)
			if note then
				p[#p + 1] = "    " .. TOTEM .. note .. "|r"
			end
		end
	end
	p[#p + 1] = ""
	p[#p + 1] = "|cff9d9d9d" .. ns:L("FTRAIN_FOOTER") .. "|r"
	return table.concat(p, "\n"), p, ids
end

ns.ForeverTrainerText = function(level) -- the offline check prints it
	return (Text(Compute(level)))
end

local win
local MODEL_W = 170 -- the trainer model's panel; the window grows by this plus a gap when it shows
local BASE_W = 560
local PROF_SLOTS = 12 -- the profession buttons: 2 rows of 6 (ns.FOREVER_PROFS below has 12)
local PROF_BTN_W = 82

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverTrainer", UIParent, "BackdropTemplate")
	f:SetSize(BASE_W, 530)
	f:SetPoint("CENTER", 0, 60)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 22, -18)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	-- The arrow button sits in the same window as the list (CLAUDE.md: the explanation in the same room as the button).
	local go = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	go:SetSize(210, 24)
	go:SetPoint("BOTTOMLEFT", 20, 16)
	go:SetText(ns:L("HOME_FOREVER_BTN_GO"))
	go:SetScript("OnClick", function()
		if ns.ForeverTrainerGo then
			ns.ForeverTrainerGo()
		end
	end)
	f.go = go
	f.goHint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.goHint:SetPoint("LEFT", go, "RIGHT", 8, 0)
	f.goHint:SetPoint("RIGHT", f, "RIGHT", -20, 0)
	f.goHint:SetJustifyH("LEFT")
	-- Profession trainers (Rob, 8 Nov 2026, "Ja, zo bouwen"): two rows of buttons above the arrow button, your own
	-- professions first. A click sets the same arrow and cross as the class trainer; the tooltip says who and how far.
	f.profHead = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.profHead:SetPoint("BOTTOMLEFT", 22, 98)
	f.profBtns = {}
	for i = 1, PROF_SLOTS do
		local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		b:SetSize(PROF_BTN_W, 20)
		local row, col = math.floor((i - 1) / 6), (i - 1) % 6
		b:SetPoint("BOTTOMLEFT", 20 + col * (PROF_BTN_W + 4), 70 - row * 24)
		b:SetScript("OnClick", function(self)
			if self.prof and ns.ForeverTrainerGo then
				ns.ForeverTrainerGo(self.prof)
				if ns.ForeverTrainerWindowHint then
					ns.ForeverTrainerWindowHint(self.prof)
				end
			end
		end)
		b:SetScript("OnEnter", function(self)
			if GameTooltip and self.prof and ns.ForeverProfTooltip then
				GameTooltip:SetOwner(self, "ANCHOR_TOP")
				ns.ForeverProfTooltip(GameTooltip, self.prof)
				GameTooltip:Show()
			end
		end)
		b:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		f.profBtns[i] = b
	end
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	-- Fixed width (not anchored to the right edge): the window grows to the right when the trainer model shows.
	scroll:SetPoint("TOPLEFT", 22, -48)
	scroll:SetPoint("BOTTOMLEFT", 22, 118)
	scroll:SetWidth(BASE_W - 60)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(490, 10)
	scroll:SetScrollChild(child)
	-- One font string per line, so a spell line can carry its own hover area (Rob, 7 Nov 2026: "ik wil tooltips bij
	-- de spells"). Not |Hspell links in one text: links fail inside a ScrollFrame (PlayCardWindow.lua's note).
	f.rows, f.hot = {}, {}
	f.scroll, f.child = scroll, child
	-- Rob, 7 Nov 2026 ("Ja, bouw maar"): the nearest trainer as a turning 3D model on the right, like the boss and
	-- mount windows on retail. Creature id from MH's trainer list, HandyNotes or /mh trainer here. No id or no model:
	-- the panel stays away and the window keeps its old width (SetModelShown).
	local model = CreateFrame("PlayerModel", nil, f)
	model:SetPoint("TOPRIGHT", f, "TOPRIGHT", -22, -48)
	model:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -22, 70)
	model:SetWidth(MODEL_W)
	model:Hide()
	model:SetScript("OnUpdate", function(self, elapsed)
		self._facing = ((self._facing or 0.45) + elapsed * 0.6) % (2 * math.pi)
		if self.SetFacing then
			pcall(self.SetFacing, self, self._facing)
		end
	end)
	f.model = model
	f.modelName = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.modelName:SetPoint("TOP", model, "BOTTOM", 0, -4)
	f.modelName:SetWidth(MODEL_W)
	f.modelName:SetJustifyH("CENTER")
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

local function SetModelShown(f, shown, name)
	f.model:SetShown(shown)
	f.modelName:SetText(shown and name or "")
	f.modelName:SetShown(shown)
	f:SetWidth(shown and (BASE_W + MODEL_W + 10) or BASE_W)
end

--- Put the nearest trainer in the model panel. `force` on opening the window: a model frame that was hidden can come
--- back empty, so it is set again (DungeonBossWindow.lua: "plaatje kwam pas na heen-en-weer bladeren").
local function ShowModel(f, force)
	local npc, name = nil, nil
	if ns.ForeverTrainerNearestNpc then
		npc, name = ns.ForeverTrainerNearestNpc()
	end
	if not force and npc == f.model._npc then
		return
	end
	f.model._npc = npc
	if not (npc and f.model.SetCreature) then
		SetModelShown(f, false)
		return
	end
	local function apply()
		f.model:ClearModel()
		f.model:SetCreature(npc)
		if f.model.SetPortraitZoom then
			f.model:SetPortraitZoom(0) -- the whole figure, not a face
		end
		if f.model.SetCamDistanceScale then
			f.model:SetCamDistanceScale(1.0)
		end
		if f.model.SetPosition then
			f.model:SetPosition(0, 0, 0)
		end
	end
	local ok = pcall(apply)
	SetModelShown(f, ok, name)
	if not (ok and C_Timer and C_Timer.After) then
		return
	end
	-- Models load async: set it once more, then hide the panel if still nothing loaded (no empty black box).
	C_Timer.After(0.2, function()
		if f.model._npc == npc and f:IsShown() then
			pcall(apply)
		end
	end)
	C_Timer.After(1.5, function()
		if f.model._npc ~= npc or not f.model.GetModelFileID then
			return
		end
		local okF, fid = pcall(f.model.GetModelFileID, f.model)
		if okF and (fid == nil or fid == 0) then
			SetModelShown(f, false)
		end
	end)
end

local function Fill(level, force)
	local f = Build()
	ShowModel(f, force)
	local r = Compute(level or UnitLevel("player"))
	f.title:SetText(ns:L("FTRAIN_TITLE_FMT"):format(r.level))
	f.go:SetText(ns:L("HOME_FOREVER_BTN_GO")) -- the language can change while the window exists
	local _, lines, ids = Text(r)
	local y = -4
	for i, s in ipairs(lines) do
		local fs = f.rows[i]
		if not fs then
			fs = f.child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			fs:SetWidth(480)
			fs:SetJustifyH("LEFT")
			f.rows[i] = fs
		end
		fs:ClearAllPoints()
		fs:SetPoint("TOPLEFT", f.child, "TOPLEFT", 4, y)
		fs:SetText(s ~= "" and s or " ")
		fs:Show()
		local h = s ~= "" and fs:GetStringHeight() or 6
		local hot = f.hot[i]
		if ids[i] then
			if not hot then
				hot = CreateFrame("Button", nil, f.child)
				hot:SetScript("OnEnter", function(self)
					if not GameTooltip then
						return
					end
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					local ok = pcall(GameTooltip.SetSpellByID, GameTooltip, self.spellId)
					if ok then
						GameTooltip:Show()
					else
						GameTooltip:Hide()
					end
				end)
				hot:SetScript("OnLeave", function()
					if GameTooltip then
						GameTooltip:Hide()
					end
				end)
				f.hot[i] = hot
			end
			hot.spellId = ids[i]
			hot:ClearAllPoints()
			hot:SetPoint("TOPLEFT", fs, "TOPLEFT")
			hot:SetSize(math.min(480, math.max(20, fs:GetStringWidth())), math.max(10, h))
			hot:Show()
		elseif hot then
			hot:Hide()
		end
		y = y - h - 3
	end
	for i = #lines + 1, #f.rows do
		f.rows[i]:Hide()
		if f.hot[i] then
			f.hot[i]:Hide()
		end
	end
	f.child:SetHeight(-y + 16)
	f.scroll:SetVerticalScroll(0)
	f.goHint:SetText(ns.ForeverTrainerNearestText and ns.ForeverTrainerNearestText() or "")
	-- Profession buttons: yours first (gold), then the rest in the usual order.
	f.profHead:SetText(ns:L("FTRAIN_PROF_HEAD"))
	local mine = ns.ForeverMyProfessions and ns.ForeverMyProfessions() or {}
	local order = {}
	for _, p in ipairs(ns.FOREVER_PROFS or {}) do
		if mine[p[1]] then
			order[#order + 1] = p[1]
		end
	end
	for _, p in ipairs(ns.FOREVER_PROFS or {}) do
		if not mine[p[1]] then
			order[#order + 1] = p[1]
		end
	end
	for i, b in ipairs(f.profBtns) do
		local key = order[i]
		b.prof = key
		if key then
			local nm = ns.ForeverProfName and ns.ForeverProfName(key, mine) or key
			b:SetText(mine[key] and ("|cffffd100" .. nm .. "|r") or nm)
			local fs = b:GetFontString()
			if fs then
				fs:SetWidth(PROF_BTN_W - 8)
				fs:SetWordWrap(false)
			end
			b:Show()
		else
			b:Hide()
		end
	end
	return f, r
end

--- The tooltip of a profession button: your rank, the trainer the arrow would pick, and the distance.
function ns.ForeverProfTooltip(tt, prof)
	local mine = ns.ForeverMyProfessions and ns.ForeverMyProfessions() or {}
	tt:AddLine(ns.ForeverProfName(prof, mine))
	local m = mine[prof]
	if m and m.rank and m.maxRank then
		tt:AddLine(ns:L("FTRAIN_PROF_TIP_YOURS"):format(m.rank, m.maxRank), 1, 1, 1)
	elseif not m then
		tt:AddLine(ns:L("FTRAIN_PROF_TIP_NEW"), 1, 1, 1)
	end
	local best, dist, _, why = ns.ForeverProfTrainerNearest(prof)
	if best then
		tt:AddLine(ns:L("FTRAIN_PROF_TIP_NEAREST"):format(best.name or "?", ns.ForeverTrainerDistance(dist)), 0.6, 1, 0.6)
		if best.max then
			tt:AddLine(ns:L("FTRAIN_PROF_TIP_MAX"):format(best.max), 0.8, 0.8, 0.8)
		end
		tt:AddLine(ns:L("FTRAIN_PROF_TIP_CLICK"), 0.6, 0.6, 0.6)
	else
		tt:AddLine(ns.ForeverTrainerWhyText and ns.ForeverTrainerWhyText(why) or why, 1, 0.5, 0.5)
	end
end

function ns.ShowForeverTrainer(level)
	local f = Fill(level, true)
	f:Show()
	-- The money line follows your purse while the window is open (buy at the trainer, loot, sell).
	if not f.moneyWatch then
		f.moneyWatch = true
		f:RegisterEvent("PLAYER_MONEY")
		f:SetScript("OnEvent", function(self)
			if self:IsShown() then
				Fill(self.level)
			end
		end)
	end
	f.level = level
	-- Rank texts load on demand; fill once more when the client has them (AFGELEID: the first call can miss some).
	if C_Timer and C_Timer.After then
		C_Timer.After(0.5, function()
			if f:IsShown() then
				Fill(level)
			end
		end)
	end
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

--------------------------------------------------------------------------------
-- Step 2: the arrow to your class trainer (Rob, 7 Nov 2026: "alle drie, en eigenlijk vind ik dat we gewoon die van
-- handy notes moeten kunnen gebruiken !!"). Three sources, nearest wins:
--   1. places YOU recorded with /mh trainer here (MidnightHelperDB, per class, every character of that class);
--   2. HandyNotes: Class Trainers, when it is installed: read from that addon WHILE YOU PLAY. Its data is All Rights
--      Reserved, so MH never copies it into its own files; it only asks the addon the player already has.
--   3. ns.FOREVER_TRAINER_SPOTS (ForeverTrainerSpots.lua: 218 class trainers, our own list from Wowhead's Forever NPC
--      pages, checked against Zygor; works for everyone, also without HandyNotes).
--------------------------------------------------------------------------------

local function PlayerSide()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" and "A") or (f == "Horde" and "H") or nil
end

--- map + x/y (0-100) → continent id and world x/y, or nil.
local function World(map, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(x / 100, y / 100))
	if not ok or not cont or not pos then
		return nil
	end
	local okXY, wx, wy = pcall(pos.GetXY, pos)
	if not okXY or not wx or (issecretvalue and (issecretvalue(wx) or issecretvalue(wy) or issecretvalue(cont))) then
		return nil
	end
	return cont, wx, wy
end

--- Where the player stands: map, x, y (0-100), or nil.
local function PlayerPlace()
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not map or not C_Map.GetPlayerMapPosition then
		return nil
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, map, "player")
	if not ok or not pos then
		return nil
	end
	local okXY, x, y = pcall(pos.GetXY, pos)
	if not okXY or not x or (issecretvalue and (issecretvalue(x) or issecretvalue(y))) then
		return nil
	end
	return map, x * 100, y * 100
end

local function Spots()
	local db = ns.db
	if not db then
		return {}
	end
	db.foreverTrainerSpots = db.foreverTrainerSpots or {}
	return db.foreverTrainerSpots
end

--- The HandyNotes: Class Trainers addon object, or nil. Its points table is
--- points[uiMapID][XXXXYYYY] = { npc, class, side = "A"/"H"/"N", name, kind, title } (read from its Data.lua header).
local function HandyNotesTrainers()
	local AceAddon = LibStub and LibStub("AceAddon-3.0", true)
	local addon = AceAddon and AceAddon:GetAddon("HandyNotes_ClassTrainers", true)
	if type(addon) == "table" and type(addon.points) == "table" then
		return addon
	end
	return nil
end

--------------------------------------------------------------------------------
-- Profession trainers (Rob, 8 Nov 2026: "ik heb al herbalism, ik wil alchemie leren. Dat ik daar gewoon de alchemie
-- trainer kan vinden" → "Ja, zo bouwen"). Same arrow and cross as the class trainer; the places come from
-- ForeverProfTrainerSpots.lua (our own list from Wowhead's Forever NPC pages, checked against Zygor) and from
-- /mh trainer here <profession>. HandyNotes: Class Trainers has no profession trainers (GEMETEN: 0 hits for them).
--------------------------------------------------------------------------------

-- key, skill line id, English name. The ids are the ones Zygor's Forever Profession.lua uses with GetProfessionInfo
-- (AFGELEID until /mh trainer check prints them from the client). GEMETEN 11 Nov 2026 for 129 First Aid, 185 Cooking,
-- 164 Blacksmithing and 186 Mining: Rob's /mh usedfor printed them from GetProfessionInfo. The other eight: still AFGELEID.
local PROFS = {
	{ "ALCHEMY", 171, "Alchemy" }, { "BLACKSMITHING", 164, "Blacksmithing" }, { "ENCHANTING", 333, "Enchanting" },
	{ "ENGINEERING", 202, "Engineering" }, { "HERBALISM", 182, "Herbalism" }, { "LEATHERWORKING", 165, "Leatherworking" },
	{ "MINING", 186, "Mining" }, { "SKINNING", 393, "Skinning" }, { "TAILORING", 197, "Tailoring" },
	{ "COOKING", 185, "Cooking" }, { "FIRSTAID", 129, "First Aid" }, { "FISHING", 356, "Fishing" },
}
local PROF_BY_LINE, PROF_ENGLISH = {}, {}
for _, p in ipairs(PROFS) do
	PROF_BY_LINE[p[2]] = p[1]
	PROF_ENGLISH[p[1]] = p[3]
end
ns.FOREVER_PROFS = PROFS

local function Readable(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

--- This character's professions: [key] = { name, rank, maxRank }, plus a reason when the client gave nothing.
local function MyProfessions()
	local out = {}
	if not (GetProfessions and GetProfessionInfo) then
		return out, "the game has no GetProfessions here"
	end
	local ok, a, b, c, d, e, f = pcall(GetProfessions)
	if not ok then
		return out, "GetProfessions failed"
	end
	local idx = { a, b, c, d, e, f }
	for i = 1, 6 do
		if idx[i] then
			local okI, name, _, rank, maxRank, _, _, line = pcall(GetProfessionInfo, idx[i])
			local key = okI and Readable(line) and PROF_BY_LINE[line]
			if key then
				out[key] = { name = Readable(name) and name or nil, rank = Readable(rank) and rank or nil,
					maxRank = Readable(maxRank) and maxRank or nil, line = line }
			end
		end
	end
	return out
end
ns.ForeverMyProfessions = MyProfessions

--- The name THIS client shows for a profession (CLAUDE.md: client name wins), English when the client does not say.
local function ProfName(key, mine)
	mine = mine or MyProfessions()
	if mine[key] and mine[key].name then
		return mine[key].name
	end
	for _, p in ipairs(PROFS) do
		if p[1] == key and C_TradeSkillUI and C_TradeSkillUI.GetTradeSkillDisplayName then
			local ok, nm = pcall(C_TradeSkillUI.GetTradeSkillDisplayName, p[2])
			if ok and type(nm) == "string" and nm ~= "" and Readable(nm) then
				return nm
			end
		end
	end
	return PROF_ENGLISH[key] or key
end
ns.ForeverProfName = ProfName

--- Which trainer rank this character needs: nil = any trainer will do. You can train the next rank once you are
--- 25 below your cap (Classic: Journeyman at 50, Expert at 125, Artisan at 200; AFGELEID for Forever, see the research
--- doc). Below that, any trainer of that profession has your recipes. A new profession: any trainer.
local function NeedRank(key, mine)
	local m = (mine or MyProfessions())[key]
	if not (m and m.rank and m.maxRank) or m.maxRank >= 300 then
		return nil
	end
	if m.rank >= m.maxRank - 25 then
		return m.maxRank + 75
	end
	return nil
end

--- Which profession a word means: the key, the English name, or this client's name ("alchemy", "first aid", "alchimie").
local function ProfFromWord(word)
	word = (word or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
	if word == "" then
		return nil
	end
	local mine = MyProfessions()
	for _, p in ipairs(PROFS) do
		if word == p[1]:lower() or word == p[3]:lower() or word == ProfName(p[1], mine):lower() then
			return p[1]
		end
	end
	return nil
end
ns.ForeverProfFromWord = ProfFromWord

--- A place we saw the NPC from (ForeverSeenPlaces.lua) replaces the rounded list value, same map only (Rob, 11 Nov 2026:
--- the arrow to Aramis Hammerhand pointed 12 m off). Marked `seen` so /mh trainer check can show it.
local function FixPlaces(out)
	if not ns.ForeverPlaceFix then
		return out
	end
	for _, s in ipairs(out) do
		local x, y, seen = ns.ForeverPlaceFix(s.npc, s.map, s.x, s.y)
		if seen then
			s.x, s.y, s.seen = x, y, true
		end
	end
	return out
end

--- Every known trainer place for this character: { map, x, y, name, src }. `prof` = a profession key, or nil for the
--- class trainer. For a profession, trainers that cannot teach the rank you need are left out (counted in `dropped`).
local function Candidates(token, prof, all)
	local out, side = {}, PlayerSide()
	if prof then
		local need, dropped = NeedRank(prof), 0
		-- `all` (the Profession trainers window): keep the low-rank trainers too, marked `low`, so the list shows every
		-- trainer near you and says which one cannot teach your next rank.
		for _, s in ipairs(Spots()["PROF_" .. prof] or {}) do
			out[#out + 1] = { map = s.map, x = s.x, y = s.y, name = s.name, npc = s.npc, src = "yours" }
		end
		for _, s in ipairs((ns.FOREVER_PROF_TRAINER_SPOTS or {})[prof] or {}) do
			-- Only rows with a place and a readable rank: max = nil is a recipe seller or a page without a Teaches tab
			-- (research doc, open rows 5 and 6), and Annora (inside Uldaman) has no coordinates.
			if s.max and s.map and s.x and s.y and (not s.side or s.side == "both" or s.side == side) then
				local low = need and s.max and s.max < need
				if low and not all then
					dropped = dropped + 1
				else
					out[#out + 1] = { map = s.map, x = s.x, y = s.y, name = s.name, npc = s.npc, src = "MH list",
						measured = s.measured, max = s.max, low = low or nil }
				end
			end
		end
		return FixPlaces(out), dropped, need
	end
	for _, s in ipairs(Spots()[token] or {}) do
		out[#out + 1] = { map = s.map, x = s.x, y = s.y, name = s.name, npc = s.npc, src = "yours" }
	end
	local hn = HandyNotesTrainers()
	if hn then
		for map, nodes in pairs(hn.points) do
			if type(nodes) == "table" then
				for coord, node in pairs(nodes) do
					if type(node) == "table" and node.class == token and not node.kind and type(coord) == "number"
						and (node.side == "N" or node.side == side) then
						out[#out + 1] = { map = map, x = math.floor(coord / 10000) / 100, y = (coord % 10000) / 100,
							name = node.name, npc = tonumber(node.npc), src = "HandyNotes" }
					end
				end
			end
		end
	end
	for _, s in ipairs((ns.FOREVER_TRAINER_SPOTS or {})[token] or {}) do
		if not s.side or s.side == "N" or s.side == side then
			out[#out + 1] = { map = s.map, x = s.x, y = s.y, name = s.name, npc = s.npc, src = "MH list",
				measured = s.measured }
		end
	end
	return FixPlaces(out)
end
ns.ForeverTrainerCandidates = Candidates -- the offline check calls it

--- The nearest trainer on the player's continent: the candidate, its distance (yards), and how many were looked at.
--- One place per trainer (the coordinate rule: a place measured in game > HandyNotes > a guide; one value per place).
--- Rob, 8 Nov 2026: standing next to Dark Cleric Duesten, the arrow said "12 m" and pointed into the wall. Nearest-wins
--- had picked the HandyNotes point (31.34, 65.85) over MH's own (31.11, 66.07, measured by Rob) because it was a few
--- yards closer from where he typed /mh trainer go. Same NPC id = same trainer: keep only the best source.
--- seen (0): the place MH stored when you talked to this NPC (ForeverSeenPlaces.lua) beats everything (Rob, 11 Nov 2026).
local SRC_RANK = { seen = 0, yours = 1, measured = 2, HandyNotes = 3, ["MH list"] = 4 }
local function OnePerTrainer(all)
	local best = {}
	for _, c in ipairs(all) do
		if c.npc then
			local rank = SRC_RANK[(c.seen and "seen") or (c.measured and "measured") or c.src] or 9
			local b = best[c.npc]
			if not b or rank < b.rank then
				best[c.npc] = { rank = rank, c = c }
			end
		end
	end
	local out = {}
	for _, c in ipairs(all) do
		if not c.npc or best[c.npc].c == c then
			out[#out + 1] = c
		end
	end
	return out
end

local function Nearest(token, prof)
	local cands, dropped = Candidates(token, prof)
	local all = OnePerTrainer(cands)
	if #all == 0 and dropped and dropped > 0 then
		-- Every trainer in the list stops below your next rank (Cooking, First Aid and Fishing past 150 on Wowhead).
		return nil, nil, 0, "no trainer teaches your next rank"
	end
	local map, px, py = PlayerPlace()
	local cont, wx, wy
	if map then
		cont, wx, wy = World(map, px, py)
	end
	if not cont then
		return nil, nil, #all, "your position cannot be read here"
	end
	local best, bestD
	for _, c in ipairs(all) do
		local cc, cx, cy = World(c.map, c.x, c.y)
		if cc == cont then
			local d = math.sqrt((cx - wx) ^ 2 + (cy - wy) ^ 2)
			if not bestD or d < bestD then
				best, bestD = c, d
			end
		end
	end
	if not best then
		return nil, nil, #all, (#all == 0) and "no trainer places known yet" or "none on this continent"
	end
	return best, math.floor(bestD + 0.5), #all -- whole yards: %d needs an integer
end

--- "141 yards" or "129 meters", the same unit as the route arrow (setting "Show route distance in meters";
--- Rob, 7 Nov 2026: "wil je hem op meters zetten trouwens").
local function Distance(yards)
	if ns.GetNativeArrowMeters and ns.GetNativeArrowMeters() then
		return ns:L("FTRAIN_METERS_FMT"):format(math.floor(yards * 0.9144 + 0.5))
	end
	return ns:L("FTRAIN_YARDS_FMT"):format(yards)
end

-- The source names as the player reads them ("HandyNotes" is an addon's name and stays).
local SRC_KEY = { yours = "FTRAIN_SRC_YOURS", ["MH list"] = "FTRAIN_SRC_MH" }
local WHY_KEY = {
	["your position cannot be read here"] = "FTRAIN_WHY_POS",
	["no trainer places known yet"] = "FTRAIN_WHY_NONE",
	["none on this continent"] = "FTRAIN_WHY_CONT",
	["no trainer teaches your next rank"] = "FTRAIN_WHY_RANK",
}

ns.ForeverTrainerDistance = Distance
function ns.ForeverTrainerWhyText(why)
	return WHY_KEY[why] and ns:L(WHY_KEY[why]) or why
end

--- After a profession button: the line under the arrow button says where it now points.
function ns.ForeverTrainerWindowHint(prof)
	if not (win and win:IsShown()) then
		return
	end
	local best, dist, _, why = Nearest(Token(), prof)
	if best then
		win.goHint:SetText(ns:L("FTRAIN_PROF_ARROW_FMT"):format(ProfName(prof), best.name or "?", Distance(dist)))
	else
		win.goHint:SetText(ns.ForeverTrainerWhyText(why))
	end
end

--- The nearest trainer's creature id and name, for the window's 3D model; nil when unknown.
function ns.ForeverTrainerNearestNpc()
	local best = Nearest(Token())
	if best and type(best.npc) == "number" and best.npc > 0 then
		return best.npc, best.name
	end
	return nil
end

--- One line under the window's button: where it would take you, or what is missing.
function ns.ForeverTrainerNearestText()
	local best, dist, _, why = Nearest(Token())
	if best then
		local src = SRC_KEY[best.src] and ns:L(SRC_KEY[best.src]) or best.src
		return ns:L("FTRAIN_NEAREST_FMT"):format(best.name or ns:L("FTRAIN_YOUR_TRAINER"), Distance(dist), src)
	end
	return ns:L("FTRAIN_WHY_FMT"):format(WHY_KEY[why] and ns:L(WHY_KEY[why]) or why)
end

--- The nearest trainer of a profession: the candidate, distance (yards), places looked at, why-not.
function ns.ForeverProfTrainerNearest(prof)
	return Nearest(Token(), prof)
end

--- Every trainer of a profession on your side, for the Profession trainers window (ForeverProfTrainers.lua).
--- Returns a list of { c = candidate, dist = yards or nil (other continent / unreadable), zone = map name }, nearest
--- first and the other continents after it (by zone), plus the rank you need (nil = any) and whether your own position
--- could be read. `c.low` = this trainer cannot teach your next rank.
function ns.ForeverProfTrainerList(prof)
	local all = OnePerTrainer((Candidates(Token(), prof, true)))
	local map, px, py = PlayerPlace()
	local cont, wx, wy
	if map then
		cont, wx, wy = World(map, px, py)
	end
	local out = {}
	for _, c in ipairs(all) do
		local d
		if cont and c.map and c.x and c.y then
			local cc, cx, cy = World(c.map, c.x, c.y)
			if cc == cont then
				d = math.floor(math.sqrt((cx - wx) ^ 2 + (cy - wy) ^ 2) + 0.5)
			end
		end
		local zone
		if c.map and C_Map and C_Map.GetMapInfo then
			local ok, info = pcall(C_Map.GetMapInfo, c.map)
			if ok and type(info) == "table" and Readable(info.name) then
				zone = info.name
			end
		end
		out[#out + 1] = { c = c, dist = d, zone = zone or ("map " .. tostring(c.map)) }
	end
	table.sort(out, function(a, b)
		if a.dist and b.dist then
			return a.dist < b.dist
		elseif a.dist or b.dist then
			return a.dist ~= nil
		end
		if a.zone ~= b.zone then
			return a.zone < b.zone
		end
		return (a.c.name or "") < (b.c.name or "")
	end)
	return out, NeedRank(prof), cont ~= nil
end

function ns.ForeverTrainerGo(prof)
	-- Rob, 8 Nov 2026 (BugSack): the start page's arrow button calls this as its OnClick, so `prof` was the Button.
	-- Only a profession key counts; anything else means the class trainer.
	if type(prof) ~= "string" then
		prof = nil
	end
	local token = Token()
	local best, dist, n, why = Nearest(token, prof)
	if not best then
		if prof then
			print(PREFIX .. ("trainer arrow (%s): %s. Stand next to the trainer and type /mh trainer here %s.")
				:format(ProfName(prof), why, PROF_ENGLISH[prof]:lower()))
		else
			print(PREFIX .. "trainer arrow: " .. why .. ". Stand next to your trainer and type /mh trainer here " ..
				"(or install HandyNotes: Class Trainers).")
		end
		return false
	end
	return ns.ForeverTrainerGoTo(best, dist, n, prof)
end

--- Set the arrow and the cross to one trainer place (the nearest from ForeverTrainerGo, or the one the player picked in
--- the Profession trainers window). `dist` may be nil (another continent).
function ns.ForeverTrainerGoTo(best, dist, n, prof)
	if not (best and best.map and best.x and best.y) then
		return false
	end
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(best.map, best.x, best.y)) then
		print(PREFIX .. "trainer arrow: the game does not allow a waypoint on that map.")
		return false
	end
	local label = (best.name or (prof and ProfName(prof)) or "Class trainer") ..
		(prof and (" (" .. ProfName(prof) .. ")") or " (trainer)")
	-- arriveYards: the arrow stays until 5 yd (NativeArrow's default is 20 yd; Rob, 8 Nov 2026: at ~15 m "is mijn pijl
	-- al weg ... dan moet ik alsnog zoeken"). Talking to the trainer ends the route too (TRAINER_SHOW below).
	-- trainerNpc/trainerName: so TRAINER_SHOW only ends the route at THIS trainer (Rob, 9 Nov 2026: a fishing trainer on
	-- the way to the leatherworker took the arrow away).
	-- nearKey: within 20 yd the arrow adds "you're there, look around" (Rob, 11 Nov 2026: the arrow pointed 12 m off,
	-- through a wall, because the list place was rounded). best.x/y may already be the place we saw him from.
	ns.lastTarget = { mapID = best.map, x = best.x, y = best.y, name = label, via = "/mh trainer go", arriveYards = 5,
		trainerNpc = (type(best.npc) == "number" and best.npc > 0) and best.npc or nil, trainerName = best.name,
		nearKey = "FARROW_NEAR_NPC", nearYards = 20 }
	ns._mhRouteOwner = "waypoint"
	if dist then
		print(PREFIX .. ("arrow set to %s, about %s (%s, %d places known)."):format(label, Distance(dist), best.src,
			n or 0))
	else
		print(PREFIX .. ("arrow set to %s (%s)."):format(label, best.src))
	end
	if ns.ForeverTrainerMark then
		ns.ForeverTrainerMark(best)
	end
	return true
end

--- /mh trainer here: remember where this class's trainer stands (your target, or just this spot).
local function RecordHere(prof)
	local token = prof and ("PROF_" .. prof) or Token()
	local map, x, y = PlayerPlace()
	if not (map and token) then
		print(PREFIX .. "trainer here: your position cannot be read here.")
		return
	end
	local name = UnitExists and UnitExists("target") and UnitName("target") or nil
	local npc
	local guid = name and UnitGUID and UnitGUID("target")
	if type(guid) == "string" and not (issecretvalue and issecretvalue(guid)) then
		-- Fields 2-5 loose: Forever 1.60.1 (and 12.1.7 later) obfuscate the server and spawn id, form not documented.
		npc = tonumber(guid:match("^Creature%-[^%-]+%-[^%-]+%-[^%-]+%-[^%-]+%-(%d+)"))
	end
	local list = Spots()
	list[token] = list[token] or {}
	table.insert(list[token], { map = map, x = math.floor(x * 100 + 0.5) / 100, y = math.floor(y * 100 + 0.5) / 100,
		name = name, npc = npc, at = time and time() or nil })
	if prof then
		print(PREFIX .. ("trainer here: saved %s at %.2f, %.2f on map %d as a %s trainer, for all your characters. " ..
			"/mh trainer forget %s removes the last one."):format(name or "this spot", x, y, map, ProfName(prof),
			PROF_ENGLISH[prof]:lower()))
		return
	end
	print(PREFIX .. ("trainer here: saved %s at %.2f, %.2f on map %d for every %s. /mh trainer forget removes the last one.")
		:format(name or "this spot", x, y, map, token:lower()))
end

local function ForgetLast(prof)
	local token = prof and ("PROF_" .. prof) or Token()
	local list = Spots()[token]
	if list and #list > 0 then
		local s = table.remove(list)
		print(PREFIX .. ("trainer: forgot %s (%.2f, %.2f)."):format(s.name or "that spot", s.x, s.y))
	else
		print(PREFIX .. (prof and "trainer: you have not saved a place for this profession." or
			"trainer: you have not saved a trainer place for this class."))
	end
end

--------------------------------------------------------------------------------
-- Step 3: a cross above the trainer when you get there (Rob, 8 Nov 2026: "kunnen wij ook ... een kruis bovenop de
-- trainer zetten, zodat we hem sneller kunnen zien als we aankomen?" → "Ja, bouw maar").
-- The same way as the rare skull in Rares.lua (Retail only): a texture on the trainer's nameplate frame, found by NPC
-- id (or by name when the place has no id). Not a real raid mark: those are protected since 12.0 and need the trainer
-- targeted first, which is the thing we are trying to help with. Nameplate addons (MF Nameplates) hide Blizzard's
-- UnitFrame, not the nameplate frame itself, so the cross should stay visible with them (AFGELEID from MF's
-- Driver.lua, not tested). It needs the game's friendly NPC nameplates. Gone when the trainer window opens, when
-- another route takes over, or after 20 minutes. /mh trainer mark prints what it decided and why (CLAUDE.md: a
-- module whose normal result is "nothing" needs a way to see that).
--------------------------------------------------------------------------------

local CROSS_TEX = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_7" -- the game's own cross marker picture
local MARK_TTL = 20 * 60
local mark -- { npc, name, at } while a trainer is marked
local markStats = { looked = 0, found = 0, secret = 0 }

local function MarkOn()
	return Settings().mark ~= false
end

local function FriendlyPlatesCVar()
	if not (C_CVar and C_CVar.GetCVar) then
		return nil
	end
	local ok, v = pcall(C_CVar.GetCVar, "nameplateShowFriendlyNpcs")
	if not ok or (issecretvalue and issecretvalue(v)) then
		return nil
	end
	return v
end

--- Is the mark still wanted? nil lastTarget = our route arrived: keep the cross, that is the moment it is for.
local function MarkActive()
	if not mark then
		return false, "no trainer marked"
	end
	if time() - mark.at > MARK_TTL then
		return false, "older than 20 minutes"
	end
	local lt = ns.lastTarget
	if lt and lt.via ~= "/mh trainer go" then
		return false, "another route took over"
	end
	return true
end

--- The NPC id of a nameplate unit; second value true when the game hides it (secret).
local function NpcOfUnit(unit)
	local guid = UnitGUID and UnitGUID(unit)
	if issecretvalue and issecretvalue(guid) then
		return nil, true
	end
	if type(guid) ~= "string" then
		return nil, false
	end
	-- Fields 2-5 loose, as in SpotLog.lua: the obfuscated server/spawn id need not be digits.
	return tonumber(guid:match("^Creature%-[^%-]+%-[^%-]+%-[^%-]+%-[^%-]+%-(%d+)")), false
end

local function NameOfUnit(unit)
	local ok, n = pcall(UnitName, unit)
	if not ok or (issecretvalue and issecretvalue(n)) or type(n) ~= "string" then
		return nil
	end
	return n
end

local function IsMarkedTrainer(unit)
	local npc, secret = NpcOfUnit(unit)
	if secret then
		markStats.secret = markStats.secret + 1
	end
	if mark.npc and npc then
		return npc == mark.npc
	end
	return mark.name ~= nil and NameOfUnit(unit) == mark.name
end

--- Is the trainer whose window just opened ("npc" unit) the one the route points at? By npc id, else by name, else by
--- standing within 15 yd of the route's spot. Cannot tell at all → true (the old behaviour: talking ends the route).
local ROUTE_TRAINER_YARDS = 15
local function IsRouteTrainer(lt)
	local npc = NpcOfUnit("npc")
	if lt.trainerNpc and npc then
		return npc == lt.trainerNpc
	end
	local name = NameOfUnit("npc")
	if lt.trainerName and name then
		return name == lt.trainerName
	end
	local tc, tx, ty = World(lt.mapID, lt.x, lt.y)
	local pm, px, py = PlayerPlace()
	local pc, wx, wy
	if pm then
		pc, wx, wy = World(pm, px, py)
	end
	if tc and pc then
		return tc == pc and ((tx - wx) ^ 2 + (ty - wy) ^ 2) <= ROUTE_TRAINER_YARDS ^ 2
	end
	return true
end

local function ShowCross(np, show)
	local t = np._mhTrainerCross
	if show then
		if not t then
			t = np:CreateTexture(nil, "OVERLAY")
			t:SetTexture(CROSS_TEX)
			t:SetSize(32, 32)
			t:SetPoint("BOTTOM", np, "TOP", 0, 4)
			np._mhTrainerCross = t
		end
		t:Show()
	elseif t then
		t:Hide()
	end
end

local function RefreshPlate(unit)
	if not (unit and C_NamePlate and C_NamePlate.GetNamePlateForUnit) then
		return
	end
	local np = C_NamePlate.GetNamePlateForUnit(unit)
	if not np or (np.IsForbidden and np:IsForbidden()) then
		return
	end
	local show = false
	-- In instances friendly plates belong to the game (forbidden frames); trainers are never there anyway.
	if MarkOn() and MarkActive() and not (IsInInstance and IsInInstance()) then
		markStats.looked = markStats.looked + 1
		show = IsMarkedTrainer(unit)
		if show then
			markStats.found = markStats.found + 1
		end
	end
	ShowCross(np, show)
end

local function EachPlateUnit(fn)
	if not (C_NamePlate and C_NamePlate.GetNamePlates) then
		return
	end
	for _, np in ipairs(C_NamePlate.GetNamePlates() or {}) do
		local unit = np.namePlateUnitToken or (np.UnitFrame and np.UnitFrame.unit)
		if unit then
			fn(unit, np)
		end
	end
end

local function RefreshAll()
	EachPlateUnit(RefreshPlate)
end

--- Called by ForeverTrainerGo with the trainer the arrow now points at.
function ns.ForeverTrainerMark(best)
	mark = { npc = (type(best.npc) == "number" and best.npc > 0) and best.npc or nil, name = best.name, at = time() }
	markStats = { looked = 0, found = 0, secret = 0 }
	if not MarkOn() then
		return
	end
	if not (mark.npc or mark.name) then
		mark = nil -- a place without id or name (/mh trainer here without a target): nothing to recognise him by
		return
	end
	if FriendlyPlatesCVar() == "0" then
		print(PREFIX .. ns:L("FTRAIN_MARK_NEED_PLATES"))
	end
	RefreshAll()
end

local function ClearMark()
	mark = nil
	RefreshAll()
end

local function MarkSlash(arg)
	if arg == "on" or arg == "off" then
		Settings().mark = (arg == "on")
		RefreshAll()
		print(PREFIX .. ns:L(arg == "on" and "FTRAIN_MARK_ON" or "FTRAIN_MARK_OFF"))
		return
	end
	if arg == "plates" then
		if InCombatLockdown and InCombatLockdown() then
			print(PREFIX .. "trainer mark: after combat, please.")
			return
		end
		if C_CVar and C_CVar.SetCVar then
			pcall(C_CVar.SetCVar, "nameplateShowFriendlyNpcs", "1")
		end
		print(PREFIX .. ns:L(FriendlyPlatesCVar() == "1" and "FTRAIN_MARK_PLATES_DONE" or "FTRAIN_MARK_PLATES_FAIL"))
		RefreshAll()
		return
	end
	-- Diagnosis: the decision and the reason (English, like /mh trainer check).
	local active, why = MarkActive()
	print(PREFIX .. ("trainer mark: %s (/mh trainer mark on|off)"):format(MarkOn() and "on" or "off"))
	if mark then
		print(("  marked: %s, npc %s, %d s ago, %s"):format(tostring(mark.name), tostring(mark.npc), time() - mark.at,
			active and "still wanted" or ("dropped: " .. why)))
	else
		print("  no trainer marked: /mh trainer go (or the window's button) sets one")
	end
	local cv = FriendlyPlatesCVar()
	print("  game's friendly NPC nameplates: " .. tostring(cv) ..
		(cv == "0" and "  <- off: no plate, so no cross (/mh trainer mark plates)" or ""))
	print(("  in an instance: %s"):format((IsInInstance and IsInInstance()) and "yes (no cross there)" or "no"))
	print(("  since the mark: plates looked at %d, trainer found %d, NPC id hidden by the game %d")
		:format(markStats.looked, markStats.found, markStats.secret))
	local shown = 0
	EachPlateUnit(function(unit, np)
		if shown < 10 then
			shown = shown + 1
			local npc, secret = NpcOfUnit(unit)
			print(("  plate %s: %s, npc %s, cross %s"):format(unit, tostring(NameOfUnit(unit)),
				secret and "hidden" or tostring(npc), (np._mhTrainerCross and np._mhTrainerCross:IsShown()) and "yes" or "no"))
		end
	end)
	if shown == 0 then
		print("  no nameplates on screen right now")
	end
end

do
	local plates = CreateFrame("Frame")
	plates:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	plates:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
	plates:RegisterEvent("TRAINER_SHOW")
	plates:SetScript("OnEvent", function(_, event, unit)
		if event == "TRAINER_SHOW" then
			-- Only the trainer the arrow points at ends the route (Rob, 9 Nov 2026: the fishing trainer on the way to the
			-- leatherworker took the arrow away). Any other trainer: arrow and cross stay.
			local lt = ns.lastTarget
			local ours = lt and lt.via == "/mh trainer go" and ns._mhRouteOwner == "waypoint"
			if ours and not IsRouteTrainer(lt) then
				return
			end
			if mark then
				ClearMark() -- you found him
			end
			-- ...and the arrow is done too: NativeArrow tears down a route whose owner is gone (and clears its pin).
			if ours then
				ns._mhRouteOwner = nil
			end
		elseif event == "NAME_PLATE_UNIT_ADDED" then
			if mark then
				RefreshPlate(unit)
			end
		else
			local np = C_NamePlate and C_NamePlate.GetNamePlateForUnit and C_NamePlate.GetNamePlateForUnit(unit)
			if np and np._mhTrainerCross then
				np._mhTrainerCross:Hide()
			end
		end
	end)
end

local function Check()
	local level = UnitLevel("player")
	local r = Compute(level)
	print(PREFIX .. ("trainer check: class %s, level %d, data rows %d"):format(tostring(r.token), level, r.data))
	print(("  known %d, learn now %d (%s), needs something first %d, next level %s (%d), other race/faction/talent %d")
		:format(r.known, #r.now, Money(r.total), #r.needs, tostring(r.nextLevel), #r.next, r.other))
	print(("  opens by itself at level-up: %s (/mh trainer auto on|off)"):format(Settings().auto and "yes" or "no"))
	if r.data == 0 then
		print("  no trainer data for this class: the window stays empty on purpose")
	end
	local yours, hn, list = 0, 0, 0
	for _, c in ipairs(Candidates(r.token)) do
		if c.src == "yours" then
			yours = yours + 1
		elseif c.src == "HandyNotes" then
			hn = hn + 1
		else
			list = list + 1
		end
	end
	print(("  trainer places: yours %d, HandyNotes %s, MH list %d"):format(yours,
		HandyNotesTrainers() and tostring(hn) or "not installed", list))
	local best, dist, _, why = Nearest(r.token)
	print("  nearest: " .. (best and ("%s, %s (%s)"):format(best.name or "?", Distance(dist), best.src) or why))
	print(("  cross above the trainer: %s (/mh trainer mark shows why)"):format(MarkOn() and "on" or "off"))
	-- Professions: what the client says you have, and what the arrow would pick per profession.
	local mine, whyNone = MyProfessions()
	local any = false
	for _, p in ipairs(PROFS) do
		local m = mine[p[1]]
		if m then
			any = true
			print(("  profession %s (line %s): %s / %s"):format(ProfName(p[1], mine), tostring(m.line), tostring(m.rank),
				tostring(m.maxRank)))
		end
	end
	if not any then
		print("  professions: none read" .. (whyNone and (" (" .. whyNone .. ")") or ""))
	end
	local rows = 0
	for _, list in pairs(ns.FOREVER_PROF_TRAINER_SPOTS or {}) do
		rows = rows + #list
	end
	print(("  profession trainer places in MH's list: %d"):format(rows))
	for _, p in ipairs(PROFS) do
		local cands, dropped, need = Candidates(r.token, p[1])
		local b, d, _, w = Nearest(r.token, p[1])
		print(("  %s: %d places for you%s; nearest %s"):format(p[3], #cands,
			need and (", needs rank %d (%d left out)"):format(need, dropped) or "",
			b and ("%s, %s"):format(b.name or "?", Distance(d)) or w))
	end
end

function ns.ForeverTrainerSlash(arg)
	arg = (arg or ""):lower()
	local profWord = ProfFromWord(arg)
	if profWord then
		ns.ForeverTrainerGo(profWord) -- /mh trainer alchemy
	elseif arg:match("^here ") and ProfFromWord(arg:match("^here%s+(.+)$")) then
		RecordHere(ProfFromWord(arg:match("^here%s+(.+)$")))
	elseif arg:match("^forget ") and ProfFromWord(arg:match("^forget%s+(.+)$")) then
		ForgetLast(ProfFromWord(arg:match("^forget%s+(.+)$")))
	elseif arg == "check" then
		Check()
	elseif arg == "go" then
		ns.ForeverTrainerGo()
	elseif arg == "here" then
		RecordHere()
	elseif arg == "forget" then
		ForgetLast()
	elseif arg == "mark" or arg:match("^mark ") then
		MarkSlash(arg:match("^mark%s+(%S+)"))
	elseif arg == "button" or arg:match("^button ") then
		if ns.ForeverTrainAllSlash then -- ForeverTrainAll.lua: the Train all button under the game's trainer window
			ns.ForeverTrainAllSlash(arg:match("^button%s+(%S+)"))
		end
	elseif arg == "auto off" or arg == "auto on" then
		Settings().auto = (arg == "auto on")
		print(PREFIX .. "the trainer window " .. (Settings().auto and "opens by itself at level-up again." or
			"no longer opens by itself. The chat line stays; /mh trainer opens it."))
	elseif win and win:IsShown() then
		win:Hide()
	else
		ns.ShowForeverTrainer()
	end
end

-- Level-up: wait a moment (the new level settles), never pop up in combat.
local pendingLevel
local function OnLevel(level)
	if InCombatLockdown and InCombatLockdown() then
		pendingLevel = level -- fought straight after the ding: PLAYER_REGEN_ENABLED tries again
		return
	end
	local r = Compute(level)
	-- Rob, 7 Nov 2026 ("Ja, alleen nieuw"): the window opens by itself only when THIS level brings
	-- something new. Spells left over from an earlier level (not trained yet) get a chat line, not the window again.
	local new = 0
	for _, e in ipairs(r.now) do
		if e.l == level then
			new = new + 1
		end
	end
	if new > 0 then
		print(PREFIX .. ("level %d: %d new at your trainer, %d to learn in all (%s). /mh trainer shows them with their keys.")
			:format(level, new, #r.now, Money(r.total)))
		if Settings().auto then
			ns.ShowForeverTrainer(level)
		end
	elseif #r.now > 0 then
		print(PREFIX .. ("level %d: nothing new, still %d to learn at your trainer (%s). /mh trainer shows them.")
			:format(level, #r.now, Money(r.total)))
	elseif r.nextLevel then
		print(PREFIX .. ("level %d: nothing new at your trainer. Next: level %d (%d)."):format(level, r.nextLevel, #r.next))
	end
end

ns.ForeverTrainerOnLevel = OnLevel -- the offline check calls it

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event, level)
	if event == "PLAYER_LEVEL_UP" then
		pendingLevel = tonumber(level) or UnitLevel("player")
		if InCombatLockdown and InCombatLockdown() then
			return
		end
	elseif not pendingLevel then
		return
	end
	local lv = pendingLevel
	pendingLevel = nil
	if C_Timer and C_Timer.After then
		C_Timer.After(2, function()
			OnLevel(lv)
		end)
	else
		OnLevel(lv)
	end
end)
