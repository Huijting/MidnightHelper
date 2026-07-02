--[[
	MidnightHelper — Keybind schema v6 (roles, slot order, modifier overflow).
	Standard: docs/KEYBIND_STANDARD_v6.md (universal role→key; anchors never move).

	Team rules (all specs):
	- Anchors: E=interrupt, Q=movement, Z=small def, C=big def, V=dispel/CC, F1=big cooldown,
	  F2=quick combat self-heal, F3=out-of-combat heal, F4=recuperate/HoT (upd. 2026-07-02).
	- Base keys first: 1–5, E, Q/F/R/T/X, Z/C/V, F1. F2–F4 are heal anchors. No G on the main map.
	- When a slot group is full: **Shift → Ctrl → Alt** on the same physical key
	  (v6 change — Shift is the best first modifier; Alt = WoW self-cast, so last).
	- AoE = Shift-twin of the matching single-target key (1 → Shift+1, 4 → Shift+4).

	See `ns.KeybindSchema` for slot/role tables; use `ns.Keybind_AllocateSpells` when filling new specs.
]]

local addonName, ns = ...

local MOD_CANON = {
	alt = true,
	shift = true,
	ctrl = true,
}

local MOD_DISPLAY = {
	alt = "Alt",
	shift = "Shift",
	ctrl = "Ctrl",
}

--- v6 display/fill order: base, then Shift, Ctrl, Alt (Alt last — self-cast conflict).
local MOD_RANK = {
	shift = 1,
	ctrl = 2,
	alt = 3,
}

--- @class KeybindSchema
ns.KeybindSchema = {
	schema_version = 6,
	--- Overflow on an occupied base key (same physical key). v6: Shift → Ctrl → Alt.
	modifierFillOrder = { "shift", "ctrl", "alt" },
	--- Not used for Midnight spell binds (grid slot exists but team leaves empty).
	excludedBaseKeys = { G = true },
	--- Base keys in priority when auto-assigning within a category (interrupt uses role, not this list).
	baseSlotFillOrder = {
		"1",
		"2",
		"3",
		"4",
		"5",
		"Q",
		"F",
		"R",
		"X",
		"T",
		"Z",
		"C",
		"V",
		"F1",
	},
	--- Fixed base key per gameplay role (muscle memory across specs).
	roles = {
		interrupt = { ui_key = "E", localeKey = "KEYBIND_ROLE_INTERRUPT" },
		main_rotation_1 = { ui_key = "1", localeKey = "KEYBIND_ROLE_MAIN_ROTATION" },
		main_rotation_2 = { ui_key = "2", localeKey = "KEYBIND_ROLE_MAIN_ROTATION" },
		main_rotation_3 = { ui_key = "3", localeKey = "KEYBIND_ROLE_MAIN_ROTATION" },
		spender = { ui_key = "4", localeKey = "KEYBIND_ROLE_SPENDER" },
		utility_primary = { ui_key = "Q", localeKey = "KEYBIND_ROLE_UTILITY" },
		utility_secondary = { ui_key = "F", localeKey = "KEYBIND_ROLE_UTILITY" },
		defensive_1 = { ui_key = "Z", localeKey = "KEYBIND_ROLE_DEFENSIVE" },
		defensive_2 = { ui_key = "X", localeKey = "KEYBIND_ROLE_DEFENSIVE" },
		defensive_3 = { ui_key = "C", localeKey = "KEYBIND_ROLE_DEFENSIVE" },
		defensive_4 = { ui_key = "V", localeKey = "KEYBIND_ROLE_DEFENSIVE" },
		mobility = { ui_key = "R", localeKey = "KEYBIND_ROLE_MOBILITY" },
		cooldown_bar = { ui_key = "F1", localeKey = "KEYBIND_ROLE_COOLDOWN" },
		--- Heal anchors (2026-07-02): same heal reflex on every alt.
		heal_quick = { ui_key = "F2", localeKey = "KEYBIND_ROLE_HEAL" },
		heal_ooc = { ui_key = "F3", localeKey = "KEYBIND_ROLE_HEAL" },
		heal_sustain = { ui_key = "F4", localeKey = "KEYBIND_ROLE_HEAL" },
	},
	--- Spell groups → physical slots (E omitted here; use role `interrupt`). v6 slot lists;
	--- `defensive` keeps X/V as overflow so legacy Hunter/Paladin maps stay valid.
	categories = {
		main_rotation = { slots = { "1", "2", "3" } },
		spender = { slots = { "4", "5" } },
		utility = { slots = { "F", "R", "X", "T" } }, -- v6: X vóór T (makkelijker reach vanaf WASD; Rob 2026-07-02)
		interrupt = { slots = { "E" } },
		defensive = { slots = { "Z", "C", "X", "V" } },
		dispel_cc = { slots = { "V" } },
		cooldown = { slots = { "F1" } },
		selfheal = { slots = { "F2", "F3", "F4" } },
		pet_care = { slots = { "R", "F1" } },
		blessings = { slots = { "R", "F1" } },
	},
	columnToCategory = {
		Hunter_MainRotation = "main_rotation",
		Hunter_Spender = "spender",
		Hunter_Utility = "utility",
		Hunter_Defensive = "defensive",
		Hunter_PetCare = "pet_care",
		Paladin_MainRotation = "main_rotation",
		Paladin_Spender = "spender",
		Paladin_Utility = "utility",
		Paladin_Defensive = "defensive",
		Paladin_Blessings = "blessings",
		Mage_MainRotation = "main_rotation",
		Mage_Spender = "spender",
		Mage_Utility = "utility",
		Mage_Defensive = "defensive",
		Mage_CC = "dispel_cc",
		Mage_Cooldown = "cooldown",
		Shaman_MainRotation = "main_rotation",
		Shaman_Spender = "spender",
		Shaman_Utility = "utility",
		Shaman_Defensive = "defensive",
		Shaman_CC = "dispel_cc",
		Shaman_Cooldown = "cooldown",
		Shaman_Heal = "selfheal",
	},
}

local Schema = ns.KeybindSchema

local function Trim(s)
	return (tostring(s or ""):gsub("^%s*(.-)%s*$", "%1"))
end

--- Uppercase single keys; preserve F1, F2, …
function ns.Keybind_NormalizeBaseKey(key)
	local k = Trim(key)
	if k == "" then
		return nil
	end
	local f = k:match("^f(%d+)$")
	if f then
		return "F" .. f
	end
	if #k == 1 then
		return string.upper(k)
	end
	return k
end

--- @return mod string|nil, baseKey string|nil
function ns.Keybind_ParseBindKey(bindKey)
	local raw = Trim(bindKey)
	if raw == "" then
		return nil, nil
	end
	local modPart, basePart = raw:match("^(%a+)[%+%-](.+)$")
	if modPart and basePart then
		local mod = string.lower(modPart)
		if MOD_CANON[mod] then
			return mod, ns.Keybind_NormalizeBaseKey(basePart)
		end
	end
	return nil, ns.Keybind_NormalizeBaseKey(raw)
end

function ns.Keybind_GetModifier(bindKey)
	local mod = ns.Keybind_ParseBindKey(bindKey)
	return mod
end

function ns.Keybind_GetBaseUiKey(bindKey)
	local _, base = ns.Keybind_ParseBindKey(bindKey)
	return base
end

function ns.Keybind_MakeBindKey(mod, baseKey)
	local base = ns.Keybind_NormalizeBaseKey(baseKey)
	if not base or base == "" then
		return nil
	end
	if not mod or mod == "" then
		return base
	end
	mod = string.lower(mod)
	if not MOD_CANON[mod] then
		return base
	end
	return MOD_DISPLAY[mod] .. "+" .. base
end

--- Action-bar / guide label (e.g. Alt+E).
function ns.Keybind_FormatKeycap(bindKey)
	local mod, base = ns.Keybind_ParseBindKey(bindKey)
	if not base then
		return nil
	end
	if mod and MOD_DISPLAY[mod] then
		return MOD_DISPLAY[mod] .. "+" .. base
	end
	return base
end

function ns.Keybind_ModifierRank(bindKey)
	local mod = ns.Keybind_ParseBindKey(bindKey)
	if not mod then
		return 0
	end
	return MOD_RANK[mod] or 99
end

--- Sort: same base key together; base before modifiers; Alt before Shift before Ctrl.
function ns.Keybind_CompareBindKeys(a, b)
	local modA, baseA = ns.Keybind_ParseBindKey(a)
	local modB, baseB = ns.Keybind_ParseBindKey(b)
	baseA = baseA or ""
	baseB = baseB or ""
	if baseA ~= baseB then
		return baseA < baseB
	end
	return ns.Keybind_ModifierRank(a) < ns.Keybind_ModifierRank(b)
end

function ns.Keybind_GetRoleUiKey(role)
	local r = Schema.roles and Schema.roles[role]
	return r and r.ui_key or nil
end

function ns.Keybind_GetCategorySlots(category)
	local c = Schema.categories and Schema.categories[category]
	return c and c.slots or nil
end

function ns.Keybind_ColumnToCategory(columnId)
	return Schema.columnToCategory and Schema.columnToCategory[columnId]
end

function ns.Keybind_GetRoleLocaleKey(role)
	local r = Schema.roles and Schema.roles[role]
	return r and r.localeKey or nil
end

local function SpecEntry(spec, bindKey)
	if not spec or not spec.spellByUiKey or not bindKey then
		return nil
	end
	return spec.spellByUiKey[bindKey]
end

function ns.Keybind_GetSpellOnBind(spec, bindKey)
	return SpecEntry(spec, bindKey)
end

--- Sorted list of { bindKey, entry } on one physical key (base + modifier layers).
function ns.Keybind_GetBindingsOnBase(spec, baseKey)
	local base = ns.Keybind_NormalizeBaseKey(baseKey)
	if not spec or not spec.spellByUiKey or not base then
		return {}
	end
	local out = {}
	for bk, entry in pairs(spec.spellByUiKey) do
		if ns.Keybind_GetBaseUiKey(bk) == base and type(entry) == "table" and entry.id then
			out[#out + 1] = { bindKey = bk, entry = entry }
		end
	end
	table.sort(out, function(a, b)
		return ns.Keybind_CompareBindKeys(a.bindKey, b.bindKey)
	end)
	return out
end

function ns.Keybind_IterBindings(spec)
	if not spec or not spec.spellByUiKey then
		return function()
			return nil
		end
	end
	local keys = {}
	for bk in pairs(spec.spellByUiKey) do
		keys[#keys + 1] = bk
	end
	table.sort(keys, ns.Keybind_CompareBindKeys)
	local i = 0
	return function()
		i = i + 1
		local bk = keys[i]
		if not bk then
			return nil
		end
		return bk, spec.spellByUiKey[bk]
	end
end

function ns.Keybind_FindSpellBindKey(spec, spellId)
	local sid = tonumber(spellId)
	if not spec or not spec.spellByUiKey or not sid or sid < 1 then
		return nil
	end
	for bk, def in pairs(spec.spellByUiKey) do
		if type(def) == "table" and tonumber(def.id) == sid then
			return bk
		end
	end
	return nil
end

--- Keys to try on one base slot: base, then Alt, Shift, Ctrl.
function ns.Keybind_BindKeysForBaseSlot(baseKey)
	local base = ns.Keybind_NormalizeBaseKey(baseKey)
	if not base then
		return {}
	end
	local keys = { base }
	for i = 1, #Schema.modifierFillOrder do
		keys[#keys + 1] = ns.Keybind_MakeBindKey(Schema.modifierFillOrder[i], base)
	end
	return keys
end

local function SlotListForSpell(spell, opts)
	opts = opts or {}
	if spell.role == "interrupt" then
		return ns.Keybind_GetCategorySlots("interrupt")
	end
	local roleDef = spell.role and Schema.roles[spell.role]
	if roleDef and roleDef.ui_key then
		return { roleDef.ui_key }
	end
	local cat = spell.category
	if not cat and spell.maps_to_column then
		cat = ns.Keybind_ColumnToCategory(spell.maps_to_column)
	end
	if cat then
		local slots = ns.Keybind_GetCategorySlots(cat)
		if cat == "utility" and opts.hasInterrupt then
			return slots
		end
		if cat == "utility" then
			local merged = { "E" }
			for i = 1, #(slots or {}) do
				merged[#merged + 1] = slots[i]
			end
			return merged
		end
		return slots
	end
	return Schema.baseSlotFillOrder
end

--- Build `spellByUiKey` from a spell list (for new specs). See file header for ordering rules.
--- @param spells table[] { id, minLevel, role?, category?, maps_to_column?, priority? }
--- @param opts table|nil { reserveInterrupt?: boolean, hasInterrupt?: boolean }
--- @return table spellByUiKey
function ns.Keybind_AllocateSpells(spells, opts)
	opts = opts or {}
	local out = {}
	local occupied = {}

	local function isOccupied(bk)
		return occupied[bk] == true
	end

	local function mark(bk, spell)
		occupied[bk] = true
		out[bk] = {
			id = spell.id,
			minLevel = spell.minLevel,
			role = spell.role,
			category = spell.category,
		}
	end

	--- v6 §4: vul eerst ALLE base-toetsen van de slot-lijst, dán de Shift-laag van elk,
	--- dan Ctrl, dan Alt (modifier-major). Zo landen builders op 1/2/3 vóór ze overlopen
	--- naar Shift+1 — i.p.v. eerst alle modifier-lagen van toets 1 te vullen.
	local function trySlots(slots, spell)
		slots = slots or {}
		local layers = { false } -- false = base-laag (geen modifier)
		for i = 1, #Schema.modifierFillOrder do
			layers[#layers + 1] = Schema.modifierFillOrder[i]
		end
		for l = 1, #layers do
			local mod = layers[l]
			for s = 1, #slots do
				local base = ns.Keybind_NormalizeBaseKey(slots[s])
				if base and not Schema.excludedBaseKeys[base] then
					local bk = mod and ns.Keybind_MakeBindKey(mod, base) or base
					if bk and not isOccupied(bk) then
						mark(bk, spell)
						return true
					end
				end
			end
		end
		return false
	end

	--- Optionele expliciete voorkeurs-toets (v6-regels als AoE = Shift-tweeling, of een vaste
	--- anker-plek). Wordt vóór de rol/categorie-logica geprobeerd; valt terug als de toets bezet is.
	local function tryPreferredKey(spell)
		if not spell.bindKey then
			return false
		end
		local mod, base = ns.Keybind_ParseBindKey(spell.bindKey)
		if not base or Schema.excludedBaseKeys[base] then
			return false
		end
		local bk = ns.Keybind_MakeBindKey(mod, base)
		if bk and not isOccupied(bk) then
			mark(bk, spell)
			return true
		end
		return false
	end

	local sorted = {}
	for i = 1, #(spells or {}) do
		sorted[#sorted + 1] = spells[i]
	end
	table.sort(sorted, function(a, b)
		local pa = tonumber(a.priority) or 0
		local pb = tonumber(b.priority) or 0
		if pa ~= pb then
			return pa < pb
		end
		local ra = (a.role == "interrupt") and 0 or 1
		local rb = (b.role == "interrupt") and 0 or 1
		if ra ~= rb then
			return ra < rb
		end
		return (tonumber(a.id) or 0) < (tonumber(b.id) or 0)
	end)

	local hasInterrupt = opts.hasInterrupt
	for i = 1, #sorted do
		if sorted[i].role == "interrupt" then
			hasInterrupt = true
			break
		end
	end
	opts.hasInterrupt = hasInterrupt

	for i = 1, #sorted do
		local spell = sorted[i]
		if spell and spell.id then
			if not tryPreferredKey(spell) then
				local slots = SlotListForSpell(spell, opts)
				if not trySlots(slots, spell) then
					trySlots(Schema.baseSlotFillOrder, spell)
				end
			end
		end
	end

	return out
end
