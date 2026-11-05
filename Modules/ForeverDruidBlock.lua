local _, ns = ...

--[[
	ForeverDruidBlock.lua — the key block for a Druid in WoW Forever, as one macro per key (5 Nov 2026).

	Rob: "Eigen Forever-lijst" → four rules "Ja, bouwen" → "Macro per toets" → the table "ja goedzo".
	Plan and table: docs/PLAN_FOREVER_DRUID_BLOK_2026-11-05.md. Spells and levels: docs/FOREVER_DRUID_SPELLS_2026-11-05.md.

	Why macros: the block lives on bars 5-7 (KeyBlock.lua DEFAULT_BARS), and those do not page with forms. One macro
	per key gives "same key, same job in every form": /cast [bonusbar:3] Maul; [bonusbar:1/2] Claw; [nobonusbar:1/2/3] Wrath.
	  - bonusbar 1/2 = Cat (and Prowl), 3 = Bear, 4 = Moonkin: AFGELEID from the bar pages in Rob's /mh spellbook dump
	    (Attack on slots 73/85/97/109 = pages 7-10) and EllesmereUI's paging (EUI_ActionBars_Paging.lua). Moonkin keeps
	    the caster spells, which is why the caster clause excludes 1-3 only. To test at level 10 (Bear) and 20 (Cat).
	  - By NAME, so the game casts the highest rank: MEASURED 5 Nov 2026, Rob's level 7, C_Spell.GetSpellInfo("Wrath")
	    gave 5177 (Rank 2), not 5176.
	  - A spell this character does not have yet is left out of the macro; a key with nothing yet gets no macro and
	    stays an empty place (rule 3). When a spell or rank is learned, the macros are rewritten out of combat.

	KeyBlock.lua asks ns.ForeverKeyBlockBuild() first; on any other client or class it returns nil and nothing changes.
]]

if not ns.IS_FOREVER then
	return
end

local MACRO_PREFIX = "MH "
local MACRO_ICON = "INV_MISC_QUESTIONMARK"

-- Key → spells. caster/bear/cat/all/swim may be a list: the first one this character knows wins (Dire Bear Form
-- over Bear Form, Abolish Poison over Cure Poison, Gift of the Wild over Mark of the Wild). rez = Rebirth in combat,
-- Revive out of it. The approved table, 1:1.
local KEYS = {
	["1"] = { bear = "Maul", cat = "Claw", caster = "Wrath" },
	["2"] = { bear = "Lacerate", cat = "Rake", caster = "Moonfire" },
	["3"] = { bear = "Primal Bite", cat = "Shred", caster = "Starfire" },
	["4"] = { cat = "Rip", caster = "Insect Swarm" },
	["SHIFT-4"] = { cat = "Ferocious Bite" },
	["5"] = { all = "Faerie Fire" },
	["SHIFT-1"] = { bear = "Swipe", caster = "Hurricane" },
	["SHIFT-2"] = { bear = "Demoralizing Roar", caster = "Wild Growth" },
	["Q"] = { bear = "Enrage", cat = "Shifting Power", caster = "Tranquility" },
	["F1"] = { caster = "Innervate" },
	["SHIFT-3"] = { caster = "Nature's Swiftness" },
	["SHIFT-F1"] = { caster = "Swiftmend" },
	["F3"] = { rez = true },
	["E"] = { bear = "Feral Charge", cat = "Feral Charge" },
	["V"] = { bear = "Bash", cat = "Pounce", caster = "Entangling Roots" },
	["SHIFT-Q"] = { caster = "Hibernate" },
	["SHIFT-F"] = { bear = "Challenging Roar", caster = "Soothe Animal" },
	["SHIFT-V"] = { caster = "Remove Curse" },
	["SHIFT-C"] = { caster = { "Abolish Poison", "Cure Poison" } },
	-- open = the caster clause also works in Bear (approved table: Bear "idem" = Travel/Aquatic Form).
	["R"] = { cat = "Dash", swim = "Aquatic Form", caster = "Travel Form", open = true },
	["SHIFT-R"] = { cat = "Prowl" },
	["F"] = { bear = "Growl", cat = "Cower" },
	["Z"] = { all = "Barkskin" },
	["X"] = { bear = "Frenzied Regeneration", caster = "Nature's Grasp" },
	["C"] = { caster = "Healing Touch" },
	["F2"] = { caster = "Regrowth" },
	["F4"] = { caster = "Rejuvenation" },
	["SHIFT-Z"] = { caster = "Thorns" },
	["SHIFT-X"] = { caster = { "Gift of the Wild", "Mark of the Wild" } },
	["SHIFT-E"] = { all = { "Shadowmeld", "War Stomp" } },
	["CTRL-1"] = { caster = { "Dire Bear Form", "Bear Form" } },
	["CTRL-2"] = { caster = "Cat Form" },
	["CTRL-3"] = { caster = "Moonkin Form" },
}
ns.FOREVER_DRUID_KEYS = KEYS

-- Not in the block: block D, the player's own bar (table: "Niet in het blok").
local TO_BLOCK_D = { "Teleport: Moonglade", "Track Humanoids", "Ravage", "Elune's Light" }

local function IsDruid()
	local _, token = UnitClass("player")
	return token == "DRUID"
end

--- The spell id this character has under this name (highest rank), or nil when it does not have it.
local function Known(name)
	if not (C_Spell and C_Spell.GetSpellInfo) then
		return nil
	end
	local ok, info = pcall(C_Spell.GetSpellInfo, name)
	if not ok or type(info) ~= "table" or not info.spellID then
		return nil
	end
	local id = info.spellID
	if issecretvalue and issecretvalue(id) then
		return nil
	end
	-- Name lookups should only find spells you have; the spellbook check makes sure (AFGELEID that it is needed).
	if C_SpellBook and C_SpellBook.FindSpellBookSlotForSpell then
		local okS, slot = pcall(C_SpellBook.FindSpellBookSlotForSpell, id)
		if okS and not slot then
			return nil
		end
	end
	return id
end

local function First(v)
	if type(v) == "table" then
		for _, name in ipairs(v) do
			local id = Known(name)
			if id then
				return name, id
			end
		end
		return nil
	end
	if v then
		local id = Known(v)
		if id then
			return v, id
		end
	end
	return nil
end

--- The macro body for one key, the spell ids it uses, and the spell to show on the picture. nil when nothing is known.
local function Body(key)
	local def = KEYS[key]
	if not def then
		return nil
	end
	local ids, show = {}, nil
	local function use(name, id)
		ids[#ids + 1] = id
		show = show or id
		return name
	end
	if def.rez then
		local reb, rebId = First("Rebirth")
		local rev, revId = First("Revive")
		local parts = {}
		if reb then
			parts[#parts + 1] = (rev and "[combat] " or "") .. use(reb, rebId)
		end
		if rev then
			parts[#parts + 1] = use(rev, revId)
		end
		if #parts == 0 then
			return nil
		end
		return "#showtooltip\n/cast " .. table.concat(parts, "; "), ids, show
	end
	local allName, allId = First(def.all)
	if allName then
		return "#showtooltip\n/cast " .. use(allName, allId), ids, show
	end
	local clauses = {}
	local bear, bearId = First(def.bear)
	local cat, catId = First(def.cat)
	local swim, swimId = First(def.swim)
	local caster, casterId = First(def.caster)
	if bear then
		clauses[#clauses + 1] = "[bonusbar:3] " .. use(bear, bearId)
	end
	if cat then
		clauses[#clauses + 1] = "[bonusbar:1/2] " .. use(cat, catId)
	end
	if swim then
		clauses[#clauses + 1] = "[swimming] " .. use(swim, swimId)
	end
	if caster then
		-- Guarded only when a form clause exists: a key that is caster-only stays a plain /cast.
		local guard = ((bear or cat) and not def.open) and "[nobonusbar:1/2/3] " or ""
		clauses[#clauses + 1] = guard .. use(caster, casterId)
	end
	if #clauses == 0 then
		return nil
	end
	-- The caster spell first on the picture: that is the button's everyday meaning.
	show = casterId or show
	return "#showtooltip\n/cast " .. table.concat(clauses, "; "), ids, show
end

local function MacroName(key)
	return MACRO_PREFIX .. key
end

--- Create or rewrite the macro for this key. @return macro index or nil, reason
function ns.ForeverEnsureMacro(key)
	if InCombatLockdown and InCombatLockdown() then
		return nil, "in combat"
	end
	local body = Body(key)
	if not body then
		return nil, "nothing known for " .. tostring(key)
	end
	local name = MacroName(key)
	local idx = GetMacroIndexByName and GetMacroIndexByName(name) or 0
	if idx and idx > 0 then
		local _, icon, old = GetMacroInfo(idx)
		if old ~= body then
			pcall(EditMacro, idx, name, icon, body)
		end
		return GetMacroIndexByName(name)
	end
	-- A character macro first (this druid's own spells). How many Forever allows per character is not measured; when
	-- they are full, the account's shared list is used. A shared "MH 1" is rewritten by whichever druid logs in, with
	-- that druid's own spells (RefreshExisting on PLAYER_ENTERING_WORLD), so it stays right for the one playing.
	local numGlobal, perChar = GetNumMacros()
	local maxChar = MAX_CHARACTER_MACROS or 18
	local maxGlobal = MAX_ACCOUNT_MACROS or 120
	local perCharacter = true
	if (perChar or 0) >= maxChar then
		if (numGlobal or 0) >= maxGlobal then
			return nil, ("no free macro place (character %d of %d, account %d of %d)"):format(perChar or 0, maxChar,
				numGlobal or 0, maxGlobal)
		end
		perCharacter = false
	end
	local ok, newIdx = pcall(CreateMacro, name, MACRO_ICON, body, perCharacter)
	if ok and newIdx then
		return newIdx
	end
	return nil, "CreateMacro failed: " .. tostring(newIdx)
end

--- Rewrite every block macro that exists (new spell or rank learned). Never creates one: a key that gets its first
--- spell is offered by the key block's own "new for your block" question / Update.
local function RefreshExisting()
	if not IsDruid() or (InCombatLockdown and InCombatLockdown()) then
		return
	end
	for key in pairs(KEYS) do
		local idx = GetMacroIndexByName and GetMacroIndexByName(MacroName(key))
		if idx and idx > 0 then
			ns.ForeverEnsureMacro(key)
		end
	end
end

--- The key block's Build() result for this character, or nil (not a Forever Druid). Same shape as KeyBlock.lua Build:
--- occ[key] = { spell = { id, name, macroName, spellIds }, why }.
function ns.ForeverKeyBlockBuild()
	if not IsDruid() then
		return nil
	end
	local occ, trace = {}, {}
	for key in pairs(KEYS) do
		local body, ids, show = Body(key)
		if body then
			local okN, nm = pcall(C_Spell.GetSpellName, show)
			occ[key] = {
				spell = { id = show, name = okN and nm or nil, macroName = MacroName(key), macroKey = key, spellIds = ids },
				why = "Forever Druid macro",
			}
			trace[#trace + 1] = { key = key, id = show, why = "Forever Druid macro: " .. body:gsub("\n", " ") }
		end
	end
	local unplaced = {}
	for _, name in ipairs(TO_BLOCK_D) do
		local id = Known(name)
		if id then
			unplaced[#unplaced + 1] = { id = id, name = name }
		end
	end
	local specID
	if ns.GetSpecialization and ns.GetSpecializationInfo then
		local okS, id = pcall(ns.GetSpecializationInfo, ns.GetSpecialization())
		specID = okS and id or nil
	end
	return { occ = occ, unplaced = unplaced, trace = trace, specID = specID, class = "DRUID", unknown = 0 }
end

-- New spell or rank → rewrite the macros, out of combat, once things settle.
local pending = false
local ev = CreateFrame("Frame")
ev:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_ENABLED" and not pending then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		pending = true
		return
	end
	pending = false
	if C_Timer and C_Timer.After then
		C_Timer.After(1, RefreshExisting)
	else
		RefreshExisting()
	end
end)
