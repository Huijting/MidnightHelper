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

--- Enumerate the player's KNOWN, active (non-passive) spells from the live spellbook.
--- Uses the modern C_SpellBook API (same as JustAC/others on this patch). Returns name -> spellID.
local function ReadKnownActiveSpells()
	local out = {}
	if not (C_SpellBook and C_SpellBook.GetSpellBookItemInfo and Enum and Enum.SpellBookSpellBank) then
		return out
	end
	local bank = Enum.SpellBookSpellBank.Player
	for i = 1, 1000 do
		local info = C_SpellBook.GetSpellBookItemInfo(i, bank)
		if not info then
			break
		end
		if info.spellID and info.name and not info.isPassive then
			local known = (not IsSpellKnown) or IsSpellKnown(info.spellID)
				or (IsPlayerSpell and IsPlayerSpell(info.spellID))
			if known and not out[info.name] then
				out[info.name] = info.spellID
			end
		end
	end
	return out
end

--- @return map table (bindKey -> {id,...}), matchedCount, unmatchedNames table, class string
function ns.MH_AutoMapBuild()
	local _, class = UnitClass("player")
	local roles = RolesForClass(class)
	local known = ReadKnownActiveSpells()

	local spells = {}
	local matched = 0
	local unmatched = {}
	for name, sid in pairs(known) do
		local r = roles and roles[name]
		if r then
			spells[#spells + 1] = {
				id = sid,
				minLevel = 1,
				role = r.role,
				category = r.category,
				priority = r.priority,
				bindKey = r.bindKey,
			}
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

	local map = {}
	if ns.Keybind_AllocateSpells then
		map = ns.Keybind_AllocateSpells(spells, { hasInterrupt = hasInterrupt })
	end
	table.sort(unmatched)
	return map, matched, unmatched, class
end

local function NameForId(id)
	if C_Spell and C_Spell.GetSpellName then
		local n = C_Spell.GetSpellName(id)
		if n then
			return n
		end
	end
	return tostring(id)
end

SLASH_MHAUTOMAP1 = "/mhautomap"
SlashCmdList["MHAUTOMAP"] = function()
	local map, matched, unmatched, class = ns.MH_AutoMapBuild()
	print("|cff33ff99Midnight AutoMap (prototype)|r — class: |cffffd100" .. tostring(class) .. "|r")
	if not RolesForClass(class) then
		print("|cffff6600Nog geen classifier voor deze class geladen.|r")
		return
	end
	local keys = {}
	for bk in pairs(map) do
		keys[#keys + 1] = bk
	end
	table.sort(keys, ns.Keybind_CompareBindKeys)
	for _, bk in ipairs(keys) do
		local def = map[bk]
		print(string.format("  |cffffd100%-8s|r %s |cff888888(%s)|r", bk, NameForId(def.id), tostring(def.id)))
	end
	print(string.format("|cff33ff99%d|r spells geplaatst. |cff888888%d bekende active spells zonder rol:|r %s",
		#keys, #unmatched, table.concat(unmatched, ", ")))
end
