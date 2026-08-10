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
	--- Overflow on an occupied base key (same physical key). Shift → Ctrl.
	---
	--- ⚠️ ALT REMOVED 6 Aug 2026, and it cost nothing. Measured across all 40 specs, the
	--- Alt layer held 0–4 of 18 keys and usually 1–2; Fury Warrior and two Warlock specs
	--- got none at all. It could not fill up: layers are tried per key, so Alt only came
	--- up once BOTH Shift and Ctrl of that same key were taken, which almost never
	--- happens. So it contributed a near-empty strip of AF1/A1/AQ cells that Rob could
	--- not read — and he is the expert here; a beginner had no chance.
	---
	--- It also actively costs functionality: Alt is WoW's self-cast modifier, and a bind
	--- on Alt+X breaks self-casting that key. On Rob's Prot Paladin that is Lay on Hands
	--- and Word of Glory. Blizzard's own forums carry the same complaint repeatedly, with
	--- "unbind your Alt combinations" as the answer. No community keybinding guide
	--- recommends Alt as a general layer.
	modifierFillOrder = { "shift", "ctrl" },
	--- Not used for Midnight spell binds (grid slot exists but team leaves empty).
	excludedBaseKeys = { G = true },

	--- Thumb buttons, in the order they get handed out.
	---
	--- ⚠️ ADDED 6 Aug 2026. The standard has called mouse4/mouse5 green-tier since v6
	--- (§2) and assigns them trinket + movement (§3) — but the ALLOCATOR knew of no
	--- mouse button at all. Eighteen keyboard keys, nothing else. So on Rob's Naga six
	--- first-class buttons sat unused under his thumb while the scheme pushed a third
	--- defensive onto Ctrl+Z. Every keybinding guide rates thumb buttons alongside 1
	--- and Q; a double modifier is rated below both.
	---
	--- ⚠️ THE NAMES ARE A DEFAULT, NOT A MEASUREMENT. WoW accepts BUTTON1..BUTTON31,
	--- but a Razer Naga's pad can be configured to send either mouse buttons or number
	--- keys, and we cannot read which from inside the game. BUTTON4/5 are safe — nearly
	--- every mouse has them. Anything beyond that depends on the player's own driver, so
	--- the count is a setting rather than an assumption. Default 2 covers an ordinary
	--- mouse; Rob runs 6.
	mouseSlotFillOrder = { "BUTTON4", "BUTTON5", "BUTTON6", "BUTTON7", "BUTTON8", "BUTTON9" },
	--- Base keys in priority when auto-assigning within a category (interrupt uses role, not this list).
	---
	--- ⚠️ T IS THE CONSUMABLE ANCHOR AND IS NOT AUTO-ASSIGNED. `LayoutConsumables.lua`
	--- takes the first free key from `T 5 R X Z C` for your healing potion, which meant
	--- it only ever got whatever the abilities happened to leave — and measured on 7 Aug,
	--- 18 of 39 specs had nothing left even before the categories were widened. A potion
	--- you cannot reach when you are about to die is the one binding that must not be an
	--- afterthought, so it gets a key of its own instead of the scraps. With T out of the
	--- automatic pool it is free on all 39 specs.
	---
	--- An explicit `bindKey` may still name a T layer — Druid's Bear Form asks for
	--- Shift+T — so T stays in PREF_BASE_OK below. A wish on Shift+T does not occupy the
	--- bare T the potion needs.
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
		--- 4 and 5 added 6 Aug. They are role anchors (spender, and 5 was unused), so a
		--- spec without a spender left two premium number keys empty while a rotation
		--- spell was pushed onto a thumb button — measured on Rob's Frost Mage, where
		--- Cone of Cold landed on BUTTON5 with 4 and 5 sitting free beside it. Every
		--- keybinding guide says fill the base number row before reaching further.
		--- Safe only because role anchors are now allocated BEFORE categories; without
		--- that ordering a fourth rotation spell would steal the spender's key.
		main_rotation = { slots = { "1", "2", "3", "4", "5" } },
		spender = { slots = { "4", "5" } },
		raid_heal = { slots = { "1", "2", "3", "4", "5" } }, -- healer party/raid-heals op de nummertoetsen
		taunt = { slots = { "F" } }, -- tank-taunt op een vaste toets (essentieel, eigen kaart)

		utility = { slots = { "F", "R", "X" } }, -- T is de consumable-anker (zie baseSlotFillOrder)
		interrupt = { slots = { "E" } },
		defensive = { slots = { "Z", "C", "X", "V" } },
		--- ⚠️ TWO KEYS WERE CARRYING THE WHOLE SCHEME. Measured 7 Aug across all 39 specs:
		--- 63 abilities got no key at all, and every single one of them came from these
		--- two categories. Both had exactly ONE slot, so three places once Shift and Ctrl
		--- are counted — against a Druid's 10 dispel/CC abilities and a Blood Death
		--- Knight's 11 cooldowns. Occupancy said the same thing from the other side: V
		--- had 12 free places out of 117 and F1 had 17, while every other key had between
		--- 43 and 102.
		---
		--- The abilities that fell out were not all small. Bloodlust, Heroism, Empower
		--- Rune Weapon, Spellsteal and Primal Rage were among them.
		---
		--- Widening was measured, not guessed — five variants, against both a two-button
		--- and a six-button mouse. These lists take unplaced from 63 to 4 on an ordinary
		--- mouse and to 0 on six, and they cut the number of abilities landing outside
		--- their own group from 77 to 54, because overflow no longer has to leave the
		--- family to find room. The four that still do not fit are all situational:
		--- Remove Corruption, Scare Beast, Steel Trap, Blessing of Freedom.
		---
		--- ⚠️ T IS NOT IN EITHER LIST, AND THAT IS DELIBERATE — see baseSlotFillOrder.
		--- The variant that scored best on abilities alone was `V, T, X` with 1 unplaced,
		--- and it was rejected: it left 27 of 39 specs with no free key for a healing
		--- potion. Abilities and consumables were competing for the same keys and the
		--- abilities always won, because consumables only ever got the leftovers.
		---
		--- On the F-row order: F3 is tried before F2 on purpose. F2 holds a self-heal on
		--- 34 specs and F3 on only 12, so reaching for the emptier key first keeps
		--- cooldowns out of the heals' way. Verified after the change — F2 still holds its
		--- 34 self-heals, F3 its 12, F4 all 39; the cooldowns took only what was free.
		---
		--- The trade we accept: on a healer F3 is an out-of-combat heal, on most others it
		--- is a cooldown. That costs a little cross-spec sameness. No key at all costs
		--- more.
		dispel_cc = { slots = { "V", "X", "C" } },
		cooldown = { slots = { "F1", "F3", "F2" } },
		--- Racial: §3 of the standard reserves Shift+E and the code never did.
		---
		--- One slot, `E`, on purpose. `E` is the interrupt role's key and roles are
		--- allocated before categories, so a racial cannot land on the base key and
		--- overflows to Shift+E — exactly what the document describes, without needing
		--- the role table to learn about modifiers. A second active racial gets Ctrl+E.
		racial = { slots = { "E" } },
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

--- Toegestane base-toetsen voor een expliciete `bindKey` (de v6-toetsen). Weert stray-keys zoals
--- "N" (kwam uit een letterlijk overgenomen placeholder "Shift+N" in de dataset) -> die worden
--- genegeerd en vallen terug op de normale categorie-overflow (AoE -> Shift+1/2/3 enz.).
--- T is here but NOT in baseSlotFillOrder: it is the consumable anchor, so nothing lands
--- there automatically, while a spell that explicitly asks for a T layer (Bear Form wants
--- Shift+T) is still honoured.
local PREF_BASE_OK = { E = true, F1 = true, F2 = true, F3 = true, F4 = true, T = true }
for _, k in ipairs(Schema.baseSlotFillOrder or {}) do
	PREF_BASE_OK[k] = true
end

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

--- ⚠️ THE PLAYER MAY MOVE AN ANCHOR. Rob, 10 Aug 2026: "normaal zou ik op 6 een interrupt
--- zetten, op 7 bv een shield, op a taunt". His hands have known that for years, and the
--- scheme was quietly overruling them — worse, it was using his thumb buttons as the
--- OVERFLOW drain, so Dragon's Breath got his best key because it fitted nowhere else.
---
--- The scheme's value was never in WHICH key holds the interrupt. It is that the answer
--- is the same on every character. So the key becomes the player's choice and the
--- sameness is kept: an override applies to all specs, not one.
---
--- Overridable names are the roles in `Schema.roles` plus the single-slot categories
--- (`taunt`, `interrupt`, `cooldown`). Anything else has a list to choose from and does
--- not have an anchor to move.
--- ⚠️ AND IT IS RE-CHECKED EVERY TIME, NOT ONLY WHEN IT IS SET.
---
--- An override may name a mouse key, which only exists because `/mh mouse detect`
--- measured it. Play on a laptop without that mouse, or re-measure with fewer buttons,
--- and the anchor points at a button that sends nothing — and the layout would say
--- "your interrupt is on 6" while 6 did nothing. That is precisely the failure we
--- removed on 7 Aug when we stopped assuming thumb buttons, rebuilt two days later by
--- me in a different place.
---
--- So the preference is stored, and the MEASUREMENT decides whether it applies. An
--- unreachable anchor falls back to the scheme's own key, silently in the allocator and
--- loudly in `/mh anchor`.
--- @return string|nil key
function ns.Keybind_AnchorOverride(name)
	local t = ns.db and ns.db.anchorOverrides
	local v = t and name and t[name]
	if type(v) ~= "string" or v == "" then
		return nil
	end
	local base = ns.Keybind_NormalizeBaseKey(v)
	if not base then
		return nil
	end
	return ns.Keybind_KeyIsReachable(base) and base or nil
end

--- Can the player actually press this key on THIS setup?
---
--- Two sources: the scheme's own keyboard pool, and whatever this player's mouse was
--- measured sending. Nothing is assumed — a key we were never told about is not
--- reachable, which is the whole point.
function ns.Keybind_KeyIsReachable(base)
	if not base then
		return false
	end
	if PREF_BASE_OK[base] then
		return true
	end
	for _, entry in ipairs((ns.db and ns.db.mouseDetect) or {}) do
		local k = entry and entry.key and ns.Keybind_NormalizeBaseKey(entry.key)
		if k == base then
			return true
		end
	end
	return false
end

--- Every key currently claimed by an override, so nothing else may be handed it —
--- including the thumb-button overflow, which is exactly what took Rob's `6`.
--- Only the ones that apply: an anchor on a key this setup cannot reach blocks nothing,
--- because it is not in force either.
function ns.Keybind_AnchoredKeys()
	local out = {}
	for name in pairs((ns.db and ns.db.anchorOverrides) or {}) do
		local base = ns.Keybind_AnchorOverride(name)
		if base then
			out[base] = true
		end
	end
	return out
end

--- Base keys no spell may be given, decided per player rather than per file.
---
--- `T` is reserved the static way — it is simply absent from every list. `1` cannot be,
--- because it is only reserved for the players who use Blizzard's Assisted Combat button
--- and want it under their index finger. Rob asked for exactly that on 7 Aug 2026, and
--- only for `1`: the assistant casts your rotation, not your cooldowns, defensives or
--- utility, so 2/3/4/5 stay filled as a manual override.
---
--- Measured before building it: taking `1` out costs one extra unplaced ability across
--- all 39 specs on a two-button mouse, and none at all on six. Cheap.
--- Is Blizzard's Assisted Combat button sitting on one of the player's bars, and which
--- key drives it?
---
--- `C_ActionBar.IsAssistedCombatAction(slot)` answers the first half — verified present,
--- and EllesmereUI leans on it in 19 places. Asking beats a setting: a switch called
--- "I use the assistant" is a thing the player has to know about, remember, and keep in
--- step with reality, and every one of those is a way for the layout to be wrong while
--- looking right.
--- @return string|nil bindKey  the key that presses the assistant, if it is on a bar
function ns.Keybind_AssistantKey()
	if not (C_ActionBar and C_ActionBar.IsAssistedCombatAction and ns.MH_CommandSlotMap) then
		return nil
	end
	local okMap, commandSlot = pcall(ns.MH_CommandSlotMap)
	if not okMap or type(commandSlot) ~= "table" then
		return nil
	end
	for command, slot in pairs(commandSlot) do
		local ok, isAssist = pcall(C_ActionBar.IsAssistedCombatAction, slot)
		if ok and isAssist and GetBindingKey then
			local okK, key = pcall(GetBindingKey, command)
			if okK and key then
				local base = ns.Keybind_NormalizeBaseKey(key)
				-- Only a bare key can be reserved; Shift+1 is a different press.
				if base and not key:find("%-") then
					return base
				end
			end
		end
	end
	return nil
end

--- The spell that IS the assistant button, straight from the game.
---
--- Measured on the 12.1 PTR: `C_AssistedCombat.GetActionSpell()` returns 1229376,
--- "Single-Button Assistant". That number is deliberately NOT written down anywhere in
--- MH — it is asked for every time, because an id that is correct today is exactly the
--- kind of thing that quietly stops being correct, and the API costs nothing.
--- @return number|nil spellID
function ns.Keybind_AssistantSpellID()
	if not (C_AssistedCombat and C_AssistedCombat.GetActionSpell and C_AssistedCombat.IsAvailable) then
		return nil
	end
	local okA, available = pcall(C_AssistedCombat.IsAvailable)
	if not (okA and available) then
		return nil
	end
	local okS, id = pcall(C_AssistedCombat.GetActionSpell)
	if okS and type(id) == "number" and id > 0 then
		return id
	end
	return nil
end

function ns.Keybind_ReservedBaseKeys()
	local reserved = {}
	--- ⚠️ ON BY DEFAULT WHERE THE ASSISTANT EXISTS. Until now this was opt-in, which Rob
	--- questioned: "kan je hem gewoon niet standaard eropzetten? als ie niet bestaat
	--- blijft het alsnog leeg." He is right, and it is now possible — GetActionSpell
	--- gives us something to place, so the reserved key is no longer an empty promise.
	---
	--- The game decides, not a setting: no assistant on this character means `1` goes
	--- straight back to the rotation. `/mh sba` is the way out for a player who has one
	--- and does not want it.
	if ns.Keybind_AssistantSpellID and ns.Keybind_AssistantSpellID()
		and not (ns.db and ns.db.sbaOff) then
		reserved["1"] = true
	end
	-- And if the assistant already sits on a bar, whichever key drives it is spoken for.
	local detected = ns.Keybind_AssistantKey and ns.Keybind_AssistantKey()
	if detected then
		reserved[detected] = true
	end
	return reserved
end

--- The rotation roles resolve to exactly one key each, so a reserved key would strand
--- them. Send them to their category instead, which has a list to choose from.
local ROLE_FALLBACK_CATEGORY = {
	main_rotation_1 = "main_rotation",
	main_rotation_2 = "main_rotation",
	main_rotation_3 = "main_rotation",
	spender = "spender",
}

local function SlotListForSpell(spell, opts)
	opts = opts or {}
	--- An override outranks everything below it, including the interrupt special case:
	--- if the player has said where their interrupt lives, that IS where it lives.
	local override = ns.Keybind_AnchorOverride
		and (ns.Keybind_AnchorOverride(spell.role) or ns.Keybind_AnchorOverride(spell.category))
	if override then
		return { override }
	end
	if spell.role == "interrupt" then
		return ns.Keybind_GetCategorySlots("interrupt")
	end
	local roleDef = spell.role and Schema.roles[spell.role]
	if roleDef and roleDef.ui_key then
		local reserved = ns.Keybind_ReservedBaseKeys()
		if reserved[roleDef.ui_key] then
			local fallback = ROLE_FALLBACK_CATEGORY[spell.role]
			if fallback then
				return ns.Keybind_GetCategorySlots(fallback)
			end
			return Schema.baseSlotFillOrder
		end
		return { roleDef.ui_key }
	end
	local cat = spell.category
	if not cat and spell.maps_to_column then
		cat = ns.Keybind_ColumnToCategory(spell.maps_to_column)
	end
	if cat then
		-- E is het interrupt-anker; utility landt NIET op E (voorheen werd E vooraan gezet bij
		-- classes zonder interrupt -> een utility-spell werd dan als "Interrupt" gegroepeerd).
		return ns.Keybind_GetCategorySlots(cat)
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
			alsoStop = spell.alsoStop, -- Spec 08: carried so the coach can cross-list stops
		}
	end

	--- v6 §4: vul eerst ALLE base-toetsen van de slot-lijst, dán de Shift-laag van elk,
	--- dan Ctrl, dan Alt (modifier-major). Zo landen builders op 1/2/3 vóór ze overlopen
	--- naar Shift+1 — i.p.v. eerst alle modifier-lagen van toets 1 te vullen.
	--- The keys the player's thumb actually sends.
	---
	--- ⚠️ MEASURED FIRST, ASSUMED SECOND. `/mh mouse detect` records what each thumb
	--- button produces, and on Rob's Naga that is `6 7 8 9 0 -` — keyboard keys, not
	--- BUTTON4..BUTTON9. Everything the allocator put on BUTTON4/BUTTON5 for him was
	--- therefore bound to something he cannot press: Remove Curse and Spellsteal on
	--- keys his mouse never sends. The driver decides this, not the mouse, so no table
	--- of mouse models could have got it right.
	---
	--- This also contradicts our own standard, and the standard is wrong. §2 bans
	--- `6 7 8 9 0 - =` for combat as too far a reach — true for a left hand walking up
	--- the number row, false for a thumb resting on them. Reach is a property of the
	--- player's hardware, not of a key's name, so a key the player has TOLD us is under
	--- their thumb is not "far" and the ban does not apply to it.
	--- ⚠️ AN ANCHORED THUMB BUTTON IS NOT OVERFLOW. This is the whole of Rob's complaint
	--- on 10 Aug: he wants `6` for his interrupt, and the allocator had put Dragon's
	--- Breath there — not because it mattered, but because it fitted nowhere else and the
	--- thumb buttons are where the scheme drains its leftovers. A key the player has
	--- claimed by name is removed from that drain.
	local anchored = ns.Keybind_AnchoredKeys and ns.Keybind_AnchoredKeys() or {}

	local function MouseSlots()
		local detected = ns.db and ns.db.mouseDetect
		if type(detected) == "table" and #detected > 0 then
			local out = {}
			for i = 1, #detected do
				local k = detected[i] and detected[i].key
				local base = k and ns.Keybind_NormalizeBaseKey(k)
				if base and not anchored[base] then
					out[#out + 1] = base
				end
			end
			if #out > 0 then
				return out
			end
		end
		--- ⚠️ NEVER MEASURED MEANS NONE. This used to fall back on "the two thumb buttons
		--- nearly every mouse has", which is an assumption dressed up as a safe default —
		--- in a function whose own header says MEASURED FIRST, ASSUMED SECOND.
		---
		--- Measured 7 Aug 2026 across all 39 specs: that default puts 52 bindings on
		--- BUTTON4/BUTTON5. For a player whose mouse has no thumb buttons, or who has
		--- them mapped to browser back/forward, those 52 abilities are simply
		--- unreachable — and silently so, because the layout shows a key and the key
		--- does nothing. Rob, twice: "we mogen er niet van uitgaan dat users een mmo muis
		--- gebruiken."
		---
		--- Costing it out honestly: assuming nothing leaves 17 abilities across all 39
		--- specs with no key instead of 3, worst case 4 on one spec. "This one did not
		--- fit, place it yourself" is a true statement. A key you cannot press is not.
		---
		--- `/mh mouse detect` records what the buttons actually send, and `/mh mouse N`
		--- lets a player state it. Either one turns this back on.
		local n = tonumber(ns.db and ns.db.mouseButtonCount)
		if not n then
			n = 0
		end
		n = math.max(0, math.min(n, #Schema.mouseSlotFillOrder))
		local out = {}
		for i = 1, n do
			out[i] = Schema.mouseSlotFillOrder[i]
		end
		return out
	end

	local reservedBase = ns.Keybind_ReservedBaseKeys()

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
				--- Only the BARE key is reserved. Rob asked for "alleen de 1 knop", and
				--- Shift+1 is a different press: on Frost it carries Frozen Orb as the
				--- AoE twin of Frostbolt, and taking the whole column would break that
				--- pairing for no reason the assistant cares about.
				---
				--- An anchored key is blocked the same way, unless THIS spell is the one
				--- that anchored it — `slots` is then the single-key list from the
				--- override, so the check is simply whether we came in through it.
				local isOwnAnchor = (#slots == 1 and anchored[base]) or false
				local blocked = (reservedBase[base] and not mod)
					or (anchored[base] and not mod and not isOwnAnchor)
				if base and not Schema.excludedBaseKeys[base] and not blocked then
					local bk = mod and ns.Keybind_MakeBindKey(mod, base) or base
					if bk and not isOccupied(bk) then
						mark(bk, spell)
						return true
					end
				end
			end

			--- After Shift, before Ctrl: a free thumb button beats a double modifier.
			---
			--- This is the one place the scheme deliberately breaks its own
			--- same-kind-same-place rule, and it is worth stating why. A third sibling
			--- has to go SOMEWHERE. The choice is Ctrl+&lt;its own key&gt; — cohesive but
			--- awkward, and every guide rates a second modifier poorly — or a thumb
			--- button, which is rated alongside 1 and Q but sits away from its family.
			--- Measured on Rob's Prot Paladin, the Ctrl layer held exactly two spells:
			--- Blinding Light and Blessing of Spellwarding. Both are the kind you press
			--- rarely and want to hit first time. Cohesion loses that trade.
			if mod == "shift" then
				local mice = MouseSlots()
				for m = 1, #mice do
					local bk = mice[m]
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
		if not base or Schema.excludedBaseKeys[base] or not PREF_BASE_OK[base] then
			return false
		end
		-- A reserved bare key beats a wish: the player told us that button is spoken for.
		if reservedBase[base] and not mod then
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

	--- ⚠️ NO GLOBAL FALLBACK. Until 6 Aug an ability whose own category was full fell back
	--- on the WHOLE base list and took the first free key from the left — which is the
	--- number row. Measured, that put Sap on 3, Concussive Shot on 4 and Spellsteal on 5:
	--- crowd control sitting on builder keys while its own sibling sat on V. Enhancement
	--- got Bloodlust on 5 and Heroism on X, two faces of one button two keys apart.
	---
	--- The whole promise of this scheme is that the same KIND of thing lives in the same
	--- place. A fallback that breaks that promise to avoid an empty hand is a bad trade:
	--- it does not lose one binding, it makes the entire layout unreadable — which is
	--- exactly the report that started this.
	---
	--- So a spell that does not fit its own key and that key's modifier layers gets NO
	--- key, and is returned instead. "This one did not fit, click it or place it
	--- yourself" is an honest answer. Silently landing on 3 is not.
	--- ANCHORS FIRST, THEN CATEGORIES. `KEYBIND_STANDARD_v6.md` §4 has said so since the
	--- standard was written — "wijs eerst alle ankers toe, dán de categorie-slots, dán
	--- overflow" — but the code only ever sorted by priority and mixed the two. It went
	--- unnoticed while categories were narrow enough never to reach an anchor's key.
	--- The moment main_rotation was allowed to use 4 and 5, a fourth rotation spell
	--- would have taken the spender's anchor from under it.
	---
	--- A role resolves to exactly ONE key, so it has nowhere else to go; a category has
	--- a list. Serving the one with no alternative first is the only order that cannot
	--- strand anybody.
	local unplaced = {}
	local function place(spell)
		if not (spell and spell.id) then
			return
		end
		if tryPreferredKey(spell) then
			return
		end
		local slots = SlotListForSpell(spell, opts)
		if not trySlots(slots, spell) then
			unplaced[#unplaced + 1] = spell
		end
	end

	--- ⚠️ WISHES BEFORE THE REST, INSIDE EACH PASS. `bindKey` is how the AoE twin rule
	--- is written down — "Blizzard belongs on Shift+2, because Flurry is on 2" — and it
	--- was only ever a hint that `tryPreferredKey` gave up on the moment the key was
	--- taken. Measured across all 40 specs before this change: 108 wishes, 20 refused,
	--- 14 specs with at least one broken pair. The refusals were not conflicts between
	--- two wishes; they were ordinary overflow arriving first and sitting on a key that
	--- was spoken for.
	---
	--- Third time today the same shape has been the answer: serve whoever named one
	--- specific place before whoever will take anything.
	local handled = {}
	local function pass(wantsRole)
		for wishesFirst = 1, 2 do
			for i = 1, #sorted do
				local s = sorted[i]
				local isRole = s and s.role ~= nil
				local hasWish = s and s.bindKey ~= nil
				if s and not handled[s] and isRole == wantsRole
					and ((wishesFirst == 1) == (hasWish and true or false)) then
					handled[s] = true
					place(s)
				end
			end
		end
	end
	pass(true)  -- role anchors: exactly one key each, so they cannot move
	pass(false) -- categories: a list to choose from

	--- @return table spellByUiKey, table unplaced  — second value is new; older callers
	--- ignore it and behave as before, minus the key theft.
	return out, unplaced
end
