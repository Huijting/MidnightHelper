local addonName, ns = ...

--[[ Midnight Helper — Auto-map PROTOTYPE (2026-07-02)

Bewijst de screenshot-vrije pijplijn:
  1. Lees de LIVE spellbook (game-API geeft de ECHTE spell-ID + naam per bekende spell).
  2. Classificeer elke bekende spell naar een v6-rol/categorie via een NAAM-tabel
     (koppelen op naam → de spellbook levert het ID → geen ID-variant-fouten meer).
  3. Laat de bestaande deterministische allocator (ns.Keybind_AllocateSpells) de toetsen bepalen.

Commando: /mhautomap  → print de auto-gegenereerde map, zodat je 'm naast de
handmatige map kunt leggen. Alleen-lezen; verandert niets aan je binds of SavedVars.

Nu alleen SHAMAN ingevuld als proof-of-concept. De volledige naam→rol-dataset voor
alle 40 specs is de volgende fase (agents mijnen addons + web). Exacte slot-polish
(AoE = Shift-tweeling, anker-prioriteiten) komt daar ook; dit prototype toont de pijplijn.
]]

--- name -> { role|category, priority }.  role = vaste anker-toets (§3), category = slot-groep (§4).
local SHAMAN_ROLES = {
	["Wind Shear"]            = { role = "interrupt",         priority = 1 }, -- E
	["Lava Burst"]           = { category = "main_rotation", priority = 1 }, -- 1
	["Voltaic Blaze"]        = { category = "main_rotation", priority = 2 }, -- 2
	["Lightning Bolt"]       = { category = "main_rotation", priority = 3 }, -- 3
	["Chain Lightning"]      = { category = "main_rotation", priority = 6, bindKey = "Shift+1" }, -- AoE = Shift-tweeling van filler
	["Elemental Blast"]      = { category = "spender",       priority = 1 }, -- 4
	["Earthquake"]           = { category = "spender",       priority = 3, bindKey = "Shift+4" }, -- AoE = Shift-tweeling van spender
	["Gust of Wind"]         = { role = "utility_primary",   priority = 1 }, -- Q (movement)
	["Ghost Wolf"]           = { role = "utility_primary",   priority = 2 }, -- -> Shift+Q
	["Spiritwalker's Grace"] = { role = "utility_secondary", priority = 1 }, -- F
	["Astral Shift"]         = { role = "defensive_3",       priority = 1 }, -- C
	["Earth Elemental"]      = { category = "defensive",     priority = 5 }, -- Z / overflow
	["Stormkeeper"]          = { role = "cooldown_bar",      priority = 1 }, -- F1
	["Ascendance"]           = { category = "cooldown",      priority = 2 }, -- -> F1 overflow
	["Purge"]                = { category = "dispel_cc",     priority = 1 }, -- V
	["Cleanse Spirit"]       = { category = "dispel_cc",     priority = 2 }, -- -> Shift+V
	["Capacitor Totem"]      = { category = "utility",       priority = 4 },
	["Thunderstorm"]         = { category = "utility",       priority = 5 },
	["Skyfury"]              = { category = "utility",       priority = 6 },
	["Nature's Swiftness"]   = { category = "utility",       priority = 7 },
	["Healing Surge"]        = { role = "heal_quick",        priority = 1 }, -- F2
	["Bloodlust"]            = { category = "cooldown",       priority = 8 },
	["Heroism"]              = { category = "cooldown",       priority = 8 },
}

-- Fallback-seed (Shaman). De volledige per-class dataset wordt geregistreerd in
-- ns.KeybindRoleClassifier door de KeybindRoles_*.lua databestanden (per class-groep).
-- Registry wint; deze seed houdt Shaman werkend zolang die nog niet geladen is.
local CLASS_ROLES = {
	SHAMAN = SHAMAN_ROLES,
}

local function RolesForClass(class)
	if not class then
		return nil
	end
	local reg = ns.KeybindRoleClassifier
	if reg and reg[class] then
		return reg[class]
	end
	return CLASS_ROLES[class]
end

-- Universele spells die ELKE class kent (Midnight). Recuperate (1231411) = OOC food-heal,
-- 50% HP over 10s -> heal_sustain-anker op F4 voor iedereen. Wordt naast de class-tabel geraadpleegd.
ns.KeybindRoleClassifierGlobal = ns.KeybindRoleClassifierGlobal or {}
ns.KeybindRoleClassifierGlobal["Recuperate"] = { id = 1231411, role = "heal_sustain", priority = 1 }

--- Enumerate the player's KNOWN, active (non-passive) spells from the live spellbook.
--- Uses the modern C_SpellBook API (same as JustAC/others on this patch). Returns name -> spellID.
--- ⚠️ TWO BUGS LIVED HERE, both found on Rob's Frost Mage on 6 Aug. The layout came
--- back with 18 spells and no Ice Block, no Icy Veins, no Mirror Image — not even in
--- the "unclassified" list, so they never reached the classifier at all.
---
--- 1. IT STOPPED AT THE FIRST HOLE. The loop ran `for i = 1, 1000` and `break`-ed the
---    moment an index returned nil. The spellbook is not one contiguous run; it is
---    skill lines with offsets, so the first gap silently truncated everything after
---    it. Walk the skill lines instead, the way EllesmereUI_Range.lua:93 and
---    CDPulse_Options.lua:102 both do, and skip off-spec and hidden lines.
---
--- 2. IT ASKED ABOUT THE WRONG ID. A talent that replaces a spell gives the book two
---    ids: `spellID` is the OVERRIDE and `actionID` the base — CDPulse_Options.lua:112
---    carries that same note. Ice Block becomes Ice Cold, and `IsPlayerSpell` answers
---    FALSE for the override and TRUE for the base, so asking about the override threw
---    away a spell the player very much has. Exactly the trap that cost an hour on the
---    survival card this afternoon; the guard simply was not here.
---
--- The base id is what gets stored, because `KeybindRoles_*.lua` is written in base ids
--- and matching is this function's job. The displayed name still resolves through the
--- override at render time, so a bar showing "Ice Cold" still matches.
local function ReadKnownActiveSpells()
	local out = {}
	if not (C_SpellBook and C_SpellBook.GetSpellBookItemInfo and Enum and Enum.SpellBookSpellBank) then
		return out
	end
	local bank = Enum.SpellBookSpellBank.Player

	local function Take(index)
		local ok, info = pcall(C_SpellBook.GetSpellBookItemInfo, index, bank)
		if not ok or type(info) ~= "table" then
			return
		end
		if not info.name or info.isPassive then
			return
		end
		local override = info.spellID
		local base = info.actionID or override
		if not (override or base) then
			return
		end
		--- Known if EITHER id answers yes. The override is what you press; the base is
		--- what the game admits you own.
		local known = false
		if not IsSpellKnown and not IsPlayerSpell then
			known = true -- no way to ask: do not silently drop the whole book
		else
			for _, id in ipairs({ base, override }) do
				if id then
					if IsSpellKnown then
						local k1, v1 = pcall(IsSpellKnown, id)
						if k1 and v1 then
							known = true
						end
					end
					if not known and IsPlayerSpell then
						local k2, v2 = pcall(IsPlayerSpell, id)
						if k2 and v2 then
							known = true
						end
					end
				end
			end
		end
		if known and not out[info.name] then
			out[info.name] = base or override
		end
	end

	--- What the walk saw, kept for diagnosis. Five real Frost Mage spells were still
	--- missing after the first fix and there was no way to tell "Rob has not talented
	--- it" from "my filter is too strict" — so the filter now writes down what it
	--- skipped and why, instead of leaving that to argument.
	ns._mhSpellbookScan = { lines = {}, skipped = {} }
	local scan = ns._mhSpellbookScan

	local numLines = 0
	if C_SpellBook.GetNumSpellBookSkillLines then
		local okN, n = pcall(C_SpellBook.GetNumSpellBookSkillLines)
		numLines = (okN and n) or 0
	end
	scan.numLines = numLines
	if numLines > 0 and C_SpellBook.GetSpellBookSkillLineInfo then
		for li = 1, numLines do
			local okL, line = pcall(C_SpellBook.GetSpellBookSkillLineInfo, li)
			if okL and type(line) == "table" then
				local hidden = line.shouldHide and true or false
				local offSpec = (line.offSpecID and line.offSpecID ~= 0) and line.offSpecID or nil
				scan.lines[#scan.lines + 1] = {
					index = li,
					name = line.name,
					offset = line.itemIndexOffset,
					count = line.numSpellBookItems,
					shouldHide = hidden,
					offSpecID = offSpec,
				}
				if line.itemIndexOffset and line.numSpellBookItems and not hidden and not offSpec then
					for si = line.itemIndexOffset + 1, line.itemIndexOffset + line.numSpellBookItems do
						Take(si)
					end
				else
					scan.skipped[#scan.skipped + 1] = {
						name = line.name,
						reason = hidden and "shouldHide" or (offSpec and "offSpec" or "no offset/count"),
					}
				end
			end
		end
	else
		-- No skill-line API: sweep a generous range, but never stop at a hole.
		for i = 1, 500 do
			Take(i)
		end
	end
	return out
end

--- Bouwt een spellID -> entry index uit de class-tabel + de globale tabel. Entries
--- zónder `id` (nog niet gemigreerd) staan er niet in en vallen op naam terug. Dit is
--- de PRIMAIRE match-sleutel: de live spellbook geeft gelokaliseerde NAMEN, dus op een
--- niet-Engelse game-client matcht alleen het ID (review F1.3; Paladin is de pilot).
local function BuildIdIndex(roles)
	local byId = {}
	if roles then
		for _, r in pairs(roles) do
			if type(r) == "table" and r.id then
				byId[r.id] = r
			end
		end
	end
	local g = ns.KeybindRoleClassifierGlobal
	if g then
		for _, r in pairs(g) do
			if type(r) == "table" and r.id then
				byId[r.id] = r
			end
		end
	end
	return byId
end

--- Entry geldt als hij geen spec-filter heeft (class-baseline) of de huidige spec bevat.
local function SpecMatches(specs, specID)
	if not specs then
		return true
	end
	if not specID then
		return false
	end
	for i = 1, #specs do
		if specs[i] == specID then
			return true
		end
	end
	return false
end

--- @return map table (bindKey -> {id,...}), matchedCount, unmatchedNames table, class string
function ns.MH_AutoMapBuild()
	local _, class = UnitClass("player")
	local roles = RolesForClass(class)
	local known = ReadKnownActiveSpells()

	local specID
	if GetSpecialization and GetSpecializationInfo then
		local s = GetSpecialization()
		if s and s > 0 then
			specID = GetSpecializationInfo(s)
		end
	end

	local spells = {}
	local clickCast = {} -- healer single-target-heals: geen toets, via mouseover/click-cast (v6 §6)
	local matched = 0
	local unmatched = {}
	local globalRoles = ns.KeybindRoleClassifierGlobal
	local byId = BuildIdIndex(roles)
	for name, sid in pairs(known) do
		-- Primair op spellID (locale-onafhankelijk), naam als fallback voor nog niet
		-- gemigreerde classifiers.
		local r = byId[sid] or (roles and roles[name]) or (globalRoles and globalRoles[name])
		if r and SpecMatches(r.specs, specID) then
			if r.role == "click_cast" or r.category == "click_cast" then
				clickCast[#clickCast + 1] = { id = sid, name = name }
			else
				spells[#spells + 1] = {
					id = sid,
					minLevel = 1,
					role = r.role,
					category = r.category,
					priority = r.priority,
					bindKey = r.bindKey,
					alsoStop = r.alsoStop, -- Spec 08: dual-role stop tag, carried through for cross-listing
				}
			end
			matched = matched + 1
		else
			unmatched[#unmatched + 1] = name
		end
	end

	local hasInterrupt = false
	for _, s in ipairs(spells) do
		if s.role == "interrupt" then
			hasInterrupt = true
			break
		end
	end

	local map, unplaced = {}, {}
	if ns.Keybind_AllocateSpells then
		-- Second return, new 6 Aug: what did not fit its own key. It used to be silently
		-- dumped on the number row; now it is carried out so it can be SAID rather than
		-- hidden. A spell we cannot place is information, not an embarrassment.
		map, unplaced = ns.Keybind_AllocateSpells(spells, { hasInterrupt = hasInterrupt })
		unplaced = unplaced or {}
	end
	table.sort(unmatched)
	table.sort(clickCast, function(a, b)
		return (a.name or "") < (b.name or "")
	end)
	return map, matched, unmatched, class, clickCast, unplaced
end

--- Cache: herbouwen kost een spellbook-scan; alleen opnieuw bij spec/talent-wissel.
local autoCache = {}

local function CurrentSpecKey()
	local _, class = UnitClass("player")
	local specID
	if GetSpecialization and GetSpecializationInfo then
		local s = GetSpecialization()
		if s and s > 0 then
			specID = GetSpecializationInfo(s)
		end
	end
	return (class or "?") .. "-" .. tostring(specID or 0), class
end

--- Bouwt een synthetische spec (spellByUiKey) + slots-lijst uit de live auto-map, zodat de
--- Layout-tab 'm net zo tekent als een hand-map. @return spec|nil, slots|nil
function ns.MH_AutoMapSpecAndSlots()
	local key, class = CurrentSpecKey()
	if autoCache.key == key and autoCache.spec then
		return autoCache.spec, autoCache.slots
	end
	local map, _, _, _, clickCast = ns.MH_AutoMapBuild()
	if (not map or not next(map)) and not (clickCast and #clickCast > 0) then
		autoCache = { key = key }
		return nil, nil
	end
	local spec = { display_name = class or "", spellByUiKey = map or {}, isAutoMap = true, clickCast = clickCast }
	-- Eén slot per unieke BASE-toets in de map → precies die toetsen lichten op.
	local seen, slots = {}, {}
	for bindKey in pairs(map) do
		local base = (ns.Keybind_GetBaseUiKey and ns.Keybind_GetBaseUiKey(bindKey)) or bindKey
		if base and not seen[base] then
			seen[base] = true
			slots[#slots + 1] = { ui_key = base }
		end
	end
	autoCache = { key = key, spec = spec, slots = slots }
	return spec, slots
end

-- Cache leegmaken bij spec-/talent-wissel (SPELLS_CHANGED vangt talent-swaps).
do
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("SPELLS_CHANGED")                -- nieuwe spell geleerd (leveling/talent)
	ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED") -- andere spec
	ev:RegisterEvent("TRAIT_CONFIG_UPDATED")          -- losse talent gekozen / loadout gewisseld
	ev:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")   -- talent-group swap
	ev:SetScript("OnEvent", function()
		autoCache = {}
	end)
end

--- The name the player will actually read on their bar.
---
--- ⚠️ FOLLOW THE OVERRIDE. We store BASE ids, because `KeybindRoles_*.lua` is written
--- in base ids and that is what matching needs. But a talent that replaces a spell
--- also replaces its name, and the player never sees the base one: Rob's spellbook
--- says Ice Cold, Shimmer and Greater Invisibility where our map said Ice Block, Blink
--- and Invisibility. Telling somebody to press a button that is not labelled that is
--- the same fault as promising Alt+M opens the addon.
---
--- Ownership is still asked of the base — that half was right, and the survival card
--- learned it the hard way this afternoon. Only the NAME follows the override.
--- `C_SpellBook.FindSpellOverrideByID` is the call the other addons here use for it.
local function NameForId(id)
	if not id then
		return "?"
	end
	local display = id
	if C_SpellBook and C_SpellBook.FindSpellOverrideByID then
		local ok, over = pcall(C_SpellBook.FindSpellOverrideByID, id)
		if ok and type(over) == "number" and over ~= 0 then
			display = over
		end
	end
	if C_Spell and C_Spell.GetSpellName then
		local n = C_Spell.GetSpellName(display)
		if n then
			return n
		end
		-- Override resolved to something unnameable: fall back to the base.
		if display ~= id then
			local b = C_Spell.GetSpellName(id)
			if b then
				return b
			end
		end
	end
	return tostring(id)
end

--- `/mhautomap` — four lines in chat, the whole picture in SavedVariables.
---
--- ⚠️ It used to print everything. On a level 90 Paladin that is a wall: every placed
--- spell, then every known active spell without a role — which includes professions,
--- Warband items and toys. Rob's verdict was "dit is lastig checken", and he was right;
--- the one line that mattered scrolled past between Zandalari Cooking and a mount.
---
--- Same rule as every other long read in this addon: write it to SavedVariables,
--- reload, and let it be read at leisure.
SLASH_MHAUTOMAP1 = "/mhautomap"
SlashCmdList["MHAUTOMAP"] = function()
	local map, matched, unmatched, class, clickCast, unplaced = ns.MH_AutoMapBuild()
	local p = "|cff33ff99Midnight AutoMap|r"
	if not RolesForClass(class) then
		print(p .. " |cffff6600— nog geen classifier voor " .. tostring(class) .. ".|r")
		return
	end

	local keys = {}
	for bk in pairs(map) do
		keys[#keys + 1] = bk
	end
	table.sort(keys, ns.Keybind_CompareBindKeys)

	-- The full picture, to disk.
	ns.db = ns.db or {}
	local dump = {
		class = class,
		placed = {},
		unplaced = {},
		unmatched = unmatched or {},
		clickCast = {},
		spellbook = ns._mhSpellbookScan,
	}
	-- Every name the scan returned, so "absent" can be told apart from "unclassified".
	do
		local seen = {}
		for name in pairs(ReadKnownActiveSpells()) do
			seen[#seen + 1] = name
		end
		table.sort(seen)
		dump.scanned = seen
	end
	for _, bk in ipairs(keys) do
		local def = map[bk]
		dump.placed[#dump.placed + 1] = {
			key = bk,
			name = NameForId(def.id),
			id = def.id,
			role = def.role,
			category = def.category,
		}
	end
	for i = 1, #(unplaced or {}) do
		local s = unplaced[i]
		dump.unplaced[#dump.unplaced + 1] = {
			name = NameForId(s.id),
			id = s.id,
			role = s.role,
			category = s.category,
			priority = s.priority,
		}
	end
	for i = 1, #(clickCast or {}) do
		dump.clickCast[#dump.clickCast + 1] = clickCast[i].name
	end
	ns.db.autoMapDump = dump

	-- Four lines in chat: enough to know whether it is worth reading the file.
	print(("%s — %s: |cffffd100%d|r placed, |cffff9900%d|r did not fit, |cff888888%d unclassified|r."):format(
		p, tostring(class), #dump.placed, #dump.unplaced, #dump.unmatched))
	if #dump.unplaced > 0 then
		local names = {}
		for i = 1, #dump.unplaced do
			names[#names + 1] = dump.unplaced[i].name
		end
		table.sort(names)
		print("   |cffff9900Did not fit:|r " .. table.concat(names, ", "))
	end
	print("   |cff9d9d9dFull map written to SavedVariables — |cffffffff/reload|r and it can be read from the file.|r")
end
