--[[
	MidnightHelper — Keybinding / Abilities reference (Hunter Module 1–2, Paladin early + Retribution,
	Frost Mage + Enhancement Shaman via keybind standard v6).

	Visible keys (legacy Hunter/Paladin): 1–4, Q, E, F, R, Z, X, C, V, plus F1. v6 specs (Mage/
	Shaman) also use 5, T, F2/F3 and Shift/Ctrl/Alt layers (see docs/KEYBIND_STANDARD_v6.md).
	G exists on the preview keyboard but is never a Midnight bind (team rule).
	Physical layout reference: `data/KeyboardLayoutMidnight.md` (team gebruikt **geen G** op de hoofdrij
	`1–4 Q E R F` — BM plaatst Survival of the Fittest op **R**, niet op G).
	`categoryLocaleKey` drives row labels (Main Rotation, Spender, …).
	Spells: specsById[slug].spellByUiKey[bind_key] = { id, minLevel, role? }.
	Bind keys: base ("Q") or modifier ("Alt+Q") — see Modules/KeybindSchema.lua (schema v5).
	Optional: abilitiesWithoutHotkey, guideSpellsWithoutKeycap (hunter_early + hunter_beast_mastery).
	Paladin uses `slotsPaladin` (same geometry; Paladin_* column ids + PCAT labels).
]]

local addonName, ns = ...

ns.KeybindingReference = ns.KeybindingReference or {}

ns.KeybindingReference.schema_version = 5
ns.KeybindingReference.patch_target = "12.0.5.67314"

ns.KeybindingReference.columns = {
	"Hunter_MainRotation",
	"Hunter_Spender",
	"Hunter_Utility",
	"Hunter_Defensive",
	"Hunter_PetCare",
	"Paladin_MainRotation",
	"Paladin_Spender",
	"Paladin_Utility",
	"Paladin_Defensive",
	"Paladin_Blessings",
	"Mage_MainRotation",
	"Mage_Spender",
	"Mage_Utility",
	"Mage_Defensive",
	"Mage_CC",
	"Mage_Cooldown",
	"Shaman_MainRotation",
	"Shaman_Spender",
	"Shaman_Utility",
	"Shaman_Defensive",
	"Shaman_CC",
	"Shaman_Cooldown",
	"Shaman_Heal",
}

--- Shift+F2 (Enh Shaman): Bloodlust (Horde 2825) / Heroism (Alliance 32182) — same slot in the
--- v6 map, one bind. Faction is known at addon load; default = Bloodlust if the check fails.
local BLOODLUST_HEROISM_ID = 2825
if UnitFactionGroup and UnitFactionGroup("player") == "Alliance" then
	BLOODLUST_HEROISM_ID = 32182
end

local LCAT = "KEYBIND_HUNTER_CAT_"
local PCAT = "KEYBIND_PALADIN_CAT_"
local MCAT = "KEYBIND_MAGE_CAT_"
local SCAT = "KEYBIND_SHAMAN_CAT_"

ns.KeybindingReference.slots = {
	{ ui_key = "1", layout_row_index = 0, maps_to_column = "Hunter_MainRotation", categoryLocaleKey = LCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "1", mmo_mouse = "M1", alt_layer = "1" } },
	{ ui_key = "2", layout_row_index = 1, maps_to_column = "Hunter_MainRotation", categoryLocaleKey = LCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "2", mmo_mouse = "M2", alt_layer = "2" } },
	{ ui_key = "3", layout_row_index = 2, maps_to_column = "Hunter_MainRotation", categoryLocaleKey = LCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "3", mmo_mouse = "M3", alt_layer = "3" } },
	{ ui_key = "4", layout_row_index = 3, maps_to_column = "Hunter_Spender", categoryLocaleKey = LCAT .. "SPENDER", key_labels = { keyboard_numrow = "4", mmo_mouse = "M4", alt_layer = "4" } },
	{ ui_key = "Q", layout_row_index = 4, maps_to_column = "Hunter_Utility", categoryLocaleKey = LCAT .. "UTILITY", key_labels = { keyboard_numrow = "Q", mmo_mouse = "M5", alt_layer = "Q" } },
	{ ui_key = "E", layout_row_index = 5, maps_to_column = "Hunter_Utility", categoryLocaleKey = LCAT .. "UTILITY", key_labels = { keyboard_numrow = "E", mmo_mouse = "M6", alt_layer = "E" } },
	{ ui_key = "F", layout_row_index = 6, maps_to_column = "Hunter_Utility", categoryLocaleKey = LCAT .. "UTILITY", key_labels = { keyboard_numrow = "F", mmo_mouse = "M7", alt_layer = "F" } },
	{ ui_key = "G", layout_row_index = 7, maps_to_column = "Hunter_Utility", categoryLocaleKey = LCAT .. "UTILITY", key_labels = { keyboard_numrow = "G", mmo_mouse = "M13", alt_layer = "G" } },
	{ ui_key = "Z", layout_row_index = 8, maps_to_column = "Hunter_Defensive", categoryLocaleKey = LCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "Z", mmo_mouse = "M8", alt_layer = "Z" } },
	{ ui_key = "X", layout_row_index = 9, maps_to_column = "Hunter_Defensive", categoryLocaleKey = LCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "X", mmo_mouse = "M9", alt_layer = "X" } },
	{ ui_key = "C", layout_row_index = 10, maps_to_column = "Hunter_Defensive", categoryLocaleKey = LCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "C", mmo_mouse = "M10", alt_layer = "C" } },
	{ ui_key = "V", layout_row_index = 11, maps_to_column = "Hunter_Defensive", categoryLocaleKey = LCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "V", mmo_mouse = "M11", alt_layer = "V" } },
	{ ui_key = "R", layout_row_index = 12, maps_to_column = "Hunter_PetCare", categoryLocaleKey = LCAT .. "PET_CARE", key_labels = { keyboard_numrow = "R", mmo_mouse = "M14", alt_layer = "R" } },
	{ ui_key = "F1", layout_row_index = 13, maps_to_column = "Hunter_PetCare", categoryLocaleKey = LCAT .. "PET_CARE", key_labels = { keyboard_numrow = "F1", mmo_mouse = "M12", alt_layer = "F1" } },
}

--- Same key geometry as `slots`; Paladin-specific column grouping for the Layout tab.
ns.KeybindingReference.slotsPaladin = {
	{ ui_key = "1", layout_row_index = 0, maps_to_column = "Paladin_MainRotation", categoryLocaleKey = PCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "1", mmo_mouse = "M1", alt_layer = "1" } },
	{ ui_key = "2", layout_row_index = 1, maps_to_column = "Paladin_MainRotation", categoryLocaleKey = PCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "2", mmo_mouse = "M2", alt_layer = "2" } },
	{ ui_key = "3", layout_row_index = 2, maps_to_column = "Paladin_MainRotation", categoryLocaleKey = PCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "3", mmo_mouse = "M3", alt_layer = "3" } },
	{ ui_key = "4", layout_row_index = 3, maps_to_column = "Paladin_Spender", categoryLocaleKey = PCAT .. "SPENDER", key_labels = { keyboard_numrow = "4", mmo_mouse = "M4", alt_layer = "4" } },
	{ ui_key = "Q", layout_row_index = 4, maps_to_column = "Paladin_Utility", categoryLocaleKey = PCAT .. "UTILITY", key_labels = { keyboard_numrow = "Q", mmo_mouse = "M5", alt_layer = "Q" } },
	{ ui_key = "E", layout_row_index = 5, maps_to_column = "Paladin_Utility", categoryLocaleKey = PCAT .. "UTILITY", key_labels = { keyboard_numrow = "E", mmo_mouse = "M6", alt_layer = "E" } },
	{ ui_key = "F", layout_row_index = 6, maps_to_column = "Paladin_Utility", categoryLocaleKey = PCAT .. "UTILITY", key_labels = { keyboard_numrow = "F", mmo_mouse = "M7", alt_layer = "F" } },
	{ ui_key = "G", layout_row_index = 7, maps_to_column = "Paladin_Utility", categoryLocaleKey = PCAT .. "UTILITY", key_labels = { keyboard_numrow = "G", mmo_mouse = "M13", alt_layer = "G" } },
	{ ui_key = "Z", layout_row_index = 8, maps_to_column = "Paladin_Defensive", categoryLocaleKey = PCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "Z", mmo_mouse = "M8", alt_layer = "Z" } },
	{ ui_key = "X", layout_row_index = 9, maps_to_column = "Paladin_Defensive", categoryLocaleKey = PCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "X", mmo_mouse = "M9", alt_layer = "X" } },
	{ ui_key = "C", layout_row_index = 10, maps_to_column = "Paladin_Defensive", categoryLocaleKey = PCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "C", mmo_mouse = "M10", alt_layer = "C" } },
	{ ui_key = "V", layout_row_index = 11, maps_to_column = "Paladin_Defensive", categoryLocaleKey = PCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "V", mmo_mouse = "M11", alt_layer = "V" } },
	{ ui_key = "R", layout_row_index = 12, maps_to_column = "Paladin_Blessings", categoryLocaleKey = PCAT .. "BLESSINGS", key_labels = { keyboard_numrow = "R", mmo_mouse = "M14", alt_layer = "R" } },
	{ ui_key = "F1", layout_row_index = 13, maps_to_column = "Paladin_Blessings", categoryLocaleKey = PCAT .. "BLESSINGS", key_labels = { keyboard_numrow = "F1", mmo_mouse = "M12", alt_layer = "F1" } },
}

--- Frost Mage (keybind standard v6). v6 base keys incl. 5/T; V = dispel/CC anchor. No G bind.
ns.KeybindingReference.slotsMage = {
	{ ui_key = "1", layout_row_index = 0, maps_to_column = "Mage_MainRotation", categoryLocaleKey = MCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "1", mmo_mouse = "M1", alt_layer = "1" } },
	{ ui_key = "2", layout_row_index = 1, maps_to_column = "Mage_MainRotation", categoryLocaleKey = MCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "2", mmo_mouse = "M2", alt_layer = "2" } },
	{ ui_key = "3", layout_row_index = 2, maps_to_column = "Mage_MainRotation", categoryLocaleKey = MCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "3", mmo_mouse = "M3", alt_layer = "3" } },
	{ ui_key = "4", layout_row_index = 3, maps_to_column = "Mage_Spender", categoryLocaleKey = MCAT .. "SPENDER", key_labels = { keyboard_numrow = "4", mmo_mouse = "M4", alt_layer = "4" } },
	{ ui_key = "5", layout_row_index = 4, maps_to_column = "Mage_Spender", categoryLocaleKey = MCAT .. "SPENDER", key_labels = { keyboard_numrow = "5", mmo_mouse = "M15", alt_layer = "5" } },
	{ ui_key = "Q", layout_row_index = 5, maps_to_column = "Mage_Utility", categoryLocaleKey = MCAT .. "UTILITY", key_labels = { keyboard_numrow = "Q", mmo_mouse = "M5", alt_layer = "Q" } },
	{ ui_key = "E", layout_row_index = 6, maps_to_column = "Mage_Utility", categoryLocaleKey = MCAT .. "UTILITY", key_labels = { keyboard_numrow = "E", mmo_mouse = "M6", alt_layer = "E" } },
	{ ui_key = "F", layout_row_index = 7, maps_to_column = "Mage_Utility", categoryLocaleKey = MCAT .. "UTILITY", key_labels = { keyboard_numrow = "F", mmo_mouse = "M7", alt_layer = "F" } },
	{ ui_key = "R", layout_row_index = 8, maps_to_column = "Mage_Utility", categoryLocaleKey = MCAT .. "UTILITY", key_labels = { keyboard_numrow = "R", mmo_mouse = "M14", alt_layer = "R" } },
	{ ui_key = "X", layout_row_index = 9, maps_to_column = "Mage_Utility", categoryLocaleKey = MCAT .. "UTILITY", key_labels = { keyboard_numrow = "X", mmo_mouse = "M9", alt_layer = "X" } },
	{ ui_key = "Z", layout_row_index = 10, maps_to_column = "Mage_Defensive", categoryLocaleKey = MCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "Z", mmo_mouse = "M8", alt_layer = "Z" } },
	{ ui_key = "C", layout_row_index = 11, maps_to_column = "Mage_Defensive", categoryLocaleKey = MCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "C", mmo_mouse = "M10", alt_layer = "C" } },
	{ ui_key = "V", layout_row_index = 12, maps_to_column = "Mage_CC", categoryLocaleKey = MCAT .. "CC", key_labels = { keyboard_numrow = "V", mmo_mouse = "M11", alt_layer = "V" } },
	{ ui_key = "F1", layout_row_index = 13, maps_to_column = "Mage_Cooldown", categoryLocaleKey = MCAT .. "COOLDOWN", key_labels = { keyboard_numrow = "F1", mmo_mouse = "M12", alt_layer = "F1" } },
}

--- Enhancement Shaman (keybind standard v6). v6 base keys incl. 5/T/X/F2/F3; V = dispel/CC
--- anchor; R is deliberately free (Voltaic Blaze covers Flame Shock). No G bind.
ns.KeybindingReference.slotsShaman = {
	{ ui_key = "1", layout_row_index = 0, maps_to_column = "Shaman_MainRotation", categoryLocaleKey = SCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "1", mmo_mouse = "M1", alt_layer = "1" } },
	{ ui_key = "2", layout_row_index = 1, maps_to_column = "Shaman_MainRotation", categoryLocaleKey = SCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "2", mmo_mouse = "M2", alt_layer = "2" } },
	{ ui_key = "3", layout_row_index = 2, maps_to_column = "Shaman_MainRotation", categoryLocaleKey = SCAT .. "MAIN_ROTATION", key_labels = { keyboard_numrow = "3", mmo_mouse = "M3", alt_layer = "3" } },
	{ ui_key = "4", layout_row_index = 3, maps_to_column = "Shaman_Spender", categoryLocaleKey = SCAT .. "SPENDER", key_labels = { keyboard_numrow = "4", mmo_mouse = "M4", alt_layer = "4" } },
	{ ui_key = "5", layout_row_index = 4, maps_to_column = "Shaman_Spender", categoryLocaleKey = SCAT .. "SPENDER", key_labels = { keyboard_numrow = "5", mmo_mouse = "M15", alt_layer = "5" } },
	{ ui_key = "Q", layout_row_index = 5, maps_to_column = "Shaman_Utility", categoryLocaleKey = SCAT .. "UTILITY", key_labels = { keyboard_numrow = "Q", mmo_mouse = "M5", alt_layer = "Q" } },
	{ ui_key = "E", layout_row_index = 6, maps_to_column = "Shaman_Utility", categoryLocaleKey = SCAT .. "UTILITY", key_labels = { keyboard_numrow = "E", mmo_mouse = "M6", alt_layer = "E" } },
	{ ui_key = "F", layout_row_index = 7, maps_to_column = "Shaman_Utility", categoryLocaleKey = SCAT .. "UTILITY", key_labels = { keyboard_numrow = "F", mmo_mouse = "M7", alt_layer = "F" } },
	{ ui_key = "R", layout_row_index = 8, maps_to_column = "Shaman_Utility", categoryLocaleKey = SCAT .. "UTILITY", key_labels = { keyboard_numrow = "R", mmo_mouse = "M14", alt_layer = "R" } },
	{ ui_key = "T", layout_row_index = 9, maps_to_column = "Shaman_Utility", categoryLocaleKey = SCAT .. "UTILITY", key_labels = { keyboard_numrow = "T", mmo_mouse = "M16", alt_layer = "T" } },
	{ ui_key = "X", layout_row_index = 10, maps_to_column = "Shaman_Utility", categoryLocaleKey = SCAT .. "UTILITY", key_labels = { keyboard_numrow = "X", mmo_mouse = "M9", alt_layer = "X" } },
	{ ui_key = "C", layout_row_index = 11, maps_to_column = "Shaman_Defensive", categoryLocaleKey = SCAT .. "DEFENSIVES", key_labels = { keyboard_numrow = "C", mmo_mouse = "M10", alt_layer = "C" } },
	{ ui_key = "V", layout_row_index = 12, maps_to_column = "Shaman_CC", categoryLocaleKey = SCAT .. "CC", key_labels = { keyboard_numrow = "V", mmo_mouse = "M11", alt_layer = "V" } },
	{ ui_key = "F1", layout_row_index = 13, maps_to_column = "Shaman_Cooldown", categoryLocaleKey = SCAT .. "COOLDOWN", key_labels = { keyboard_numrow = "F1", mmo_mouse = "M12", alt_layer = "F1" } },
	{ ui_key = "F2", layout_row_index = 14, maps_to_column = "Shaman_Heal", categoryLocaleKey = SCAT .. "HEAL", key_labels = { keyboard_numrow = "F2", mmo_mouse = "M17", alt_layer = "F2" } },
}

function ns.Keybinding_GetSlotsForSlug(specSlug)
	local ref = ns.KeybindingReference
	if not ref then
		return nil
	end
	if specSlug == "paladin_early" or specSlug == "paladin_retribution" then
		return ref.slotsPaladin or ref.slots
	end
	if specSlug == "frost_mage" then
		return ref.slotsMage or ref.slots
	end
	if specSlug == "enh_shaman" or specSlug == "ele_shaman" then
		return ref.slotsShaman or ref.slots
	end
	return ref.slots
end

ns.KeybindingReference.labelPresets = {
	docs = {
		en = {},
		nl = {},
	},
}

ns.KeybindingReference.specsById = {
	--- Frost Mage — keybind standard v6, full map incl. Shift layer (AoE = Shift-twin of the
	--- ST key). IDs in-game confirmed (Rob) — see docs/KEYBIND_MAP_frost-mage_enh-shaman.md.
	--- Cold Snap on X (v6 utility prefers X over T — easier reach from WASD; Rob 2026-07-02).
	--- Glacial Spike now on its map-bind 5. No G bind (team rule).
	frost_mage = {
		display_name = "Frost Mage",
		abilities = {},
		spellByUiKey = {
			["1"] = { id = 116, minLevel = 1 }, -- Frostbolt
			["2"] = { id = 44614, minLevel = 1 }, -- Flurry (Brain Freeze)
			["3"] = { id = 205021, minLevel = 1 }, -- Ray of Frost
			["4"] = { id = 30455, minLevel = 1 }, -- Ice Lance (Shatter)
			["5"] = { id = 199786, minLevel = 1 }, -- Glacial Spike (finisher)
			["Shift+1"] = { id = 84714, minLevel = 1 }, -- Frozen Orb (AoE / cooldown)
			["Shift+2"] = { id = 190356, minLevel = 1 }, -- Blizzard (AoE)
			["Shift+3"] = { id = 120, minLevel = 1 }, -- Cone of Cold (AoE)
			["Shift+4"] = { id = 153595, minLevel = 1 }, -- Comet Storm (AoE spender)
			["Q"] = { id = 1953, minLevel = 1 }, -- Blink (or Shimmer 212653)
			["E"] = { id = 2139, minLevel = 1 }, -- Counterspell
			["F"] = { id = 30449, minLevel = 1 }, -- Spellsteal
			["R"] = { id = 55342, minLevel = 1 }, -- Mirror Image
			["X"] = { id = 235219, minLevel = 1 }, -- Cold Snap (reset defensives)
			["Z"] = { id = 11426, minLevel = 1 }, -- Ice Barrier (small defensive)
			["Shift+Z"] = { id = 108978, minLevel = 1 }, -- Alter Time (extra defensive)
			["C"] = { id = 45438, minLevel = 1 }, -- Ice Block (big defensive)
			["V"] = { id = 122, minLevel = 1 }, -- Frost Nova (CC root)
			["Shift+V"] = { id = 475, minLevel = 1 }, -- Remove Curse (dispel)
			["F1"] = { id = 12472, minLevel = 1 }, -- Icy Veins (burst)
		},
	},
	--- Enhancement Shaman — keybind standard v6 incl. heal anchors (upd. 2026-07-02:
	--- F2=quick combat heal, F3=OOC heal, F4=recuperate/HoT). IDs in-game confirmed (Rob,
	--- tooltips) — see docs/KEYBIND_MAP_frost-mage_enh-shaman.md.
	--- Voltaic Blaze replaces Flame Shock (applies FS itself); Tempest 454009 = passive proc on
	--- Lightning Bolt (no own key). Healing Surge = the F2 heal (was on Z; Enh has no separate
	--- small defensive, so Z stays empty — Astral Shift on C is the def). Stormkeeper moved
	--- F2→R, Primordial Wave F3→Shift+R. Cisca = Stormbringer hero tree → Alt+F1 = Ascendance.
	enh_shaman = {
		display_name = "Enhancement",
		abilities = {},
		spellByUiKey = {
			["1"] = { id = 17364, minLevel = 1 }, -- Stormstrike (Windstrike 115356 during Ascendance via macro)
			["2"] = { id = 60103, minLevel = 1 }, -- Lava Lash (Hot Hand)
			["3"] = { id = 470057, minLevel = 1 }, -- Voltaic Blaze (replaces Flame Shock)
			["4"] = { id = 188196, minLevel = 1 }, -- Lightning Bolt (MSW spender; Tempest proc fires from here)
			["5"] = { id = 117014, minLevel = 1 }, -- Elemental Blast (MSW spender)
			["Shift+1"] = { id = 187874, minLevel = 1 }, -- Crash Lightning (AoE)
			["Shift+2"] = { id = 197214, minLevel = 1 }, -- Sundering (AoE frontal)
			["Shift+4"] = { id = 188443, minLevel = 1 }, -- Chain Lightning (AoE spender)
			["Q"] = { id = 58875, minLevel = 1 }, -- Spirit Walk (snare break)
			["Shift+Q"] = { id = 2645, minLevel = 1 }, -- Ghost Wolf (travel)
			["E"] = { id = 57994, minLevel = 1 }, -- Wind Shear
			["F"] = { id = 196840, minLevel = 1 }, -- Frost Shock (ranged slow)
			["T"] = { id = 192058, minLevel = 1 }, -- Capacitor Totem (AoE stun)
			["Shift+T"] = { id = 192077, minLevel = 1 }, -- Wind Rush Totem (talent)
			["X"] = { id = 8143, minLevel = 1 }, -- Tremor Totem (fear/charm break)
			["C"] = { id = 108271, minLevel = 1 }, -- Astral Shift (40% DR)
			["V"] = { id = 51514, minLevel = 1 }, -- Hex (CC)
			["Shift+V"] = { id = 370, minLevel = 1 }, -- Purge (enemy dispel)
			["R"] = { id = 205495, minLevel = 1 }, -- Stormkeeper (talent; moved from F2)
			["Shift+R"] = { id = 375982, minLevel = 1 }, -- Primordial Wave (talent; moved from F3)
			["F1"] = { id = 51533, minLevel = 1 }, -- Feral Spirit (wolves)
			["Shift+F1"] = { id = 384352, minLevel = 1 }, -- Doom Winds (burst)
			["Alt+F1"] = { id = 114050, minLevel = 1 }, -- Ascendance (Stormbringer)
			["F2"] = { id = 8004, minLevel = 1 }, -- Healing Surge (quick combat heal anchor)
			["Shift+F2"] = { id = BLOODLUST_HEROISM_ID, minLevel = 1 }, -- Bloodlust 2825 / Heroism 32182 (faction; raid-haste boven de heal-toets)
		},
	},
	--- Elemental Shaman (Rob, Stormbringer) — keybind standard v6, gebouwd op zijn ACTUELE
	--- spellbook (in-game afgelezen 2026-07-02): de Midnight-Ele-kit heeft GEEN Earth Shock /
	--- Fire Elemental / Hex / Frost Shock / Tremor Totem / Spirit Walk / Lightning Lasso.
	--- Spenders = Elemental Blast (ST) + Earthquake (AoE); CD's = Stormkeeper (F1) + Ascendance
	--- (Alt+F1); movement = Gust of Wind (Q) + Ghost Wolf (Shift+Q). Gedeelde class-utility op
	--- dezelfde toets als Enh (E/T/C/V/F2/Shift+F2). ID's met "tooltip checken" zijn nog niet
	--- addon-bevestigd (pure utility, niet in de DPS/interrupt-addontabellen) → Robs /reload
	--- bevestigt die. Z leeg (geen kleine def; Astral Shift op C).
	ele_shaman = {
		display_name = "Elemental",
		abilities = {},
		spellByUiKey = {
			["1"] = { id = 51505, minLevel = 1 }, -- Lava Burst (kern-nuke, Lava Surge-proc)
			["2"] = { id = 470057, minLevel = 1 }, -- Voltaic Blaze (instant filler, past Flame Shock toe)
			["3"] = { id = 188196, minLevel = 1 }, -- Lightning Bolt (filler / Maelstrom-builder)
			["4"] = { id = 117014, minLevel = 1 }, -- Elemental Blast (ST-spender)
			["Shift+1"] = { id = 188443, minLevel = 1 }, -- Chain Lightning (AoE builder)
			["Shift+4"] = { id = 462620, minLevel = 1 }, -- Earthquake (AoE-spender) — live-ID uit spellbook (61882 = oude/addon-ID, stale in Midnight)
			["E"] = { id = 57994, minLevel = 1 }, -- Wind Shear (interrupt)
			["Q"] = { id = 192063, minLevel = 1 }, -- Gust of Wind (movement) -- tooltip checken
			["Shift+Q"] = { id = 2645, minLevel = 1 }, -- Ghost Wolf (travel)
			["F"] = { id = 79206, minLevel = 1 }, -- Spiritwalker's Grace (cast-while-moving) -- tooltip checken
			["R"] = { id = 462854, minLevel = 1 }, -- Skyfury (raid-buff, pre-combat) -- tooltip checken
			["Shift+R"] = { id = 378081, minLevel = 1 }, -- Nature's Swiftness (instant next cast) -- tooltip checken
			["T"] = { id = 192058, minLevel = 1 }, -- Capacitor Totem (AoE stun)
			["X"] = { id = 51490, minLevel = 1 }, -- Thunderstorm (AoE knockback + slow)
			["C"] = { id = 108271, minLevel = 1 }, -- Astral Shift (40% DR)
			["Shift+C"] = { id = 198103, minLevel = 1 }, -- Earth Elemental (extra defensive/pet) -- tooltip checken
			["V"] = { id = 370, minLevel = 1 }, -- Purge (enemy dispel)
			["Shift+V"] = { id = 51886, minLevel = 1 }, -- Cleanse Spirit (friendly dispel) -- tooltip checken
			["F1"] = { id = 191634, minLevel = 1 }, -- Stormkeeper (burst-cooldown)
			["Alt+F1"] = { id = 114050, minLevel = 1 }, -- Ascendance (grote CD)
			["F2"] = { id = 8004, minLevel = 1 }, -- Healing Surge (quick combat heal anchor)
			["Shift+F2"] = { id = BLOODLUST_HEROISM_ID, minLevel = 1 }, -- Bloodlust 2825 / Heroism 32182 (faction)
		},
	},
	hunter_early = {
		display_name = "Hunter (level 1–10)",
		abilities = {},
		--- Shown on the Abilities grid after keyed rows; no keycap (spellbook / bar placement).
		abilitiesWithoutHotkey = {
			{ id = 1515, minLevel = 5, categoryLocaleKey = LCAT .. "UTILITY" },
			{ id = 883, minLevel = 5, categoryLocaleKey = LCAT .. "PET_CARE" },
		},
		--- `{SPELL:id}` in guide copy: omit [|cffffcc00key|r] tail for these (still show icon + name).
		guideSpellsWithoutKeycap = {
			[1515] = true,
			[883] = true,
		},
		spellByUiKey = {
			["1"] = { id = 56641, minLevel = 1 },
			["2"] = { id = 185358, minLevel = 2 },
			["E"] = { id = 1130, minLevel = 7 },
			["F"] = { id = 195645, minLevel = 3 },
			["R"] = { id = 982, minLevel = 5 },
			["Z"] = { id = 781, minLevel = 4 },
			["X"] = { id = 5384, minLevel = 6 },
			["C"] = { id = 186265, minLevel = 8 },
			["V"] = { id = 109304, minLevel = 9 },
			["F1"] = { id = 136, minLevel = 5 },
		},
	},
	hunter_beast_mastery = {
		display_name = "Beast Mastery",
		abilities = {},
		--- Same spellbook-only rows as Module 1 (no keycap); keep Tame / Call off the hotkey map.
		abilitiesWithoutHotkey = {
			{ id = 1515, minLevel = 5, categoryLocaleKey = LCAT .. "UTILITY" },
			{ id = 883, minLevel = 5, categoryLocaleKey = LCAT .. "PET_CARE" },
			--- BM uses **R** for Survival of the Fittest — Revive Pet moves to spellbook strip (same as Module 1 pets).
			{ id = 982, minLevel = 5, categoryLocaleKey = LCAT .. "PET_CARE" },
			--- Misdirection: optional utility — drag from spellbook; **E** holds Counter Shot.
			{ id = 34477, minLevel = 22, categoryLocaleKey = LCAT .. "UTILITY" },
		},
		guideSpellsWithoutKeycap = {
			[1515] = true,
			[883] = true,
			[982] = true,
			--- Passive IV tooltip spell — no bar key (avoid [|?|] in guide `{SPELL:id}` rows).
			[459450] = true,
			--- Combat Experience: passive aura, no action button / keybind.
			[1268871] = true,
			--- Animal Companion / Precision Strikes / Alpha Predator are passive nodes.
			[267116] = true,
			[1267003] = true,
			[269737] = true,
			--- Misdirection: optional raid utility — drag from spellbook; no preset letter in this grid.
			[34477] = true,
		},
		--- Keys mirror Module 1 where possible; BM rotation spells fill gaps (Icy Veins leveling priorities).
		spellByUiKey = {
			--- Rotation spells typically appear after their talents unlock — not always on the bar the second you pick BM at 10.
			["1"] = { id = 34026, minLevel = 11 },
			["2"] = { id = 217200, minLevel = 19 },
			["3"] = { id = 193455, minLevel = 35 },
			["4"] = { id = 19574, minLevel = 23 },
			["Q"] = { id = 2643, minLevel = 23 },
			["E"] = { id = 147362, minLevel = 20, role = "interrupt" },
			["F"] = { id = 187650, minLevel = 10 },
			--- Slot **G** exists in the grid UI but this team does not bind G — leave empty (see KeyboardLayoutMidnight.md).
			["Z"] = { id = 781, minLevel = 4 },
			["X"] = { id = 5384, minLevel = 6 },
			["C"] = { id = 186265, minLevel = 8 },
			["V"] = { id = 109304, minLevel = 9 },
			["R"] = { id = 264735, minLevel = 10 },
			["F1"] = { id = 136, minLevel = 5 },
		},
	},
	paladin_early = {
		display_name = "Paladin (level 1–10)",
		abilities = {},
		abilitiesWithoutHotkey = {
			--- Retail teaches rez later than legacy — match spellbook "learned at" for Layout gray / Training unlock lines.
			{ id = 7328, minLevel = 13, categoryLocaleKey = PCAT .. "BLESSINGS" },
			{ id = 10326, minLevel = 12, categoryLocaleKey = PCAT .. "UTILITY" },
		},
		guideSpellsWithoutKeycap = {
			[7328] = true,
			[10326] = true,
		},
		spellByUiKey = {
			["1"] = { id = 35395, minLevel = 1 },
			["2"] = { id = 53600, minLevel = 2 },
			["3"] = { id = 20271, minLevel = 3 },
			["4"] = { id = 26573, minLevel = 6 },
			["Q"] = { id = 62124, minLevel = 9 },
			["E"] = { id = 19750, minLevel = 4 },
			["F"] = { id = 853, minLevel = 6 },
			["Z"] = { id = 642, minLevel = 8 },
			["X"] = { id = 633, minLevel = 9 },
			["C"] = { id = 1044, minLevel = 9 },
			["V"] = { id = 6940, minLevel = 10 },
			["R"] = { id = 190784, minLevel = 28 },
			["F1"] = { id = 85673, minLevel = 9 },
		},
	},
	paladin_retribution = {
		display_name = "Retribution",
		abilities = {},
		abilitiesWithoutHotkey = {
			{ id = 7328, minLevel = 13, categoryLocaleKey = PCAT .. "BLESSINGS" },
			{ id = 633, minLevel = 9, categoryLocaleKey = PCAT .. "BLESSINGS" },
			--- Divine Protection: learned early but Midnight layout has no **G** bind — park on bar where you like.
			{ id = 498, minLevel = 10, categoryLocaleKey = PCAT .. "DEFENSIVES" },
			--- Battle rez — spellbook unlock (not on Midnight letter grid); shown in Training unlock list at 19.
			--- 12.0.x spell id (was 391054 in DF); keep in sync with spellbook tooltip.
			{ id = 461622, minLevel = 19, categoryLocaleKey = PCAT .. "UTILITY" },
		},
		guideSpellsWithoutKeycap = {
			[7328] = true,
			[461622] = true,
			[633] = true,
			[498] = true,
			[230332] = true,
			[383342] = true,
			[234299] = true,
			[404357] = true,
			[383346] = true,
			[326734] = true,
			[402916] = true,
			[379391] = true,
			[403010] = true,
			[405461] = true,
			[223817] = true,
			[383396] = true,
			[385427] = true,
			[407067] = true,
			[406154] = true,
			[1265595] = true,
		},
		spellByUiKey = {
			["1"] = { id = 35395, minLevel = 1 },
			["2"] = { id = 20271, minLevel = 3 },
			["3"] = { id = 184575, minLevel = 10 },
			["4"] = { id = 85256, minLevel = 10 },
			["Q"] = { id = 255937, minLevel = 18 },
			["E"] = { id = 24275, minLevel = 28 },
			["F"] = { id = 53385, minLevel = 13 },
			["Z"] = { id = 642, minLevel = 8 },
			["X"] = { id = 85673, minLevel = 9 },
			["C"] = { id = 375576, minLevel = 26 },
			["V"] = { id = 1044, minLevel = 9 },
			["R"] = { id = 190784, minLevel = 28 },
			["F1"] = { id = 853, minLevel = 6 },
		},
	},
}

ns.KeybindingReference.specOrder = {
	"hunter_early",
	"hunter_beast_mastery",
	"paladin_early",
	"paladin_retribution",
}

function ns.Keybinding_GetSpellLabelForKey(specId, uiKey)
	local ref = ns.KeybindingReference
	if not ref or not specId or not uiKey then
		return nil
	end
	local spec = ref.specsById[specId]
	if not spec then
		return nil
	end
	local base = (ns.Keybind_GetBaseUiKey and ns.Keybind_GetBaseUiKey(uiKey)) or uiKey
	local layers = ns.Keybind_GetBindingsOnBase and ns.Keybind_GetBindingsOnBase(spec, base)
	if layers and #layers > 0 and layers[1].entry then
		local sid = tonumber(layers[1].entry.id)
		if sid and sid > 0 and C_Spell and C_Spell.GetSpellInfo then
			local ok, si = pcall(C_Spell.GetSpellInfo, sid)
			if ok and si and si.name and si.name ~= "" then
				return si.name
			end
		end
	end
	local slotList = ns.Keybinding_GetSlotsForSlug and ns.Keybinding_GetSlotsForSlug(specId) or ref.slots
	for _, slot in ipairs(slotList or {}) do
		if slot.ui_key == base then
			local col = slot.maps_to_column
			if col and spec.abilities and spec.abilities[col] then
				return spec.abilities[col]
			end
			return nil
		end
	end
	return nil
end

--- Bind key for a spell id (e.g. "Q", "Alt+E") in the current spec slug.
function ns.MH_Keybind_GetUiKeyForSpell(spellId, specSlug)
	local ref = ns.KeybindingReference
	local sid = tonumber(spellId)
	if not ref or not sid or sid < 1 then
		return nil
	end
	specSlug = specSlug or "hunter_early"
	local spec = ref.specsById and ref.specsById[specSlug]
	if ns.Keybind_FindSpellBindKey then
		return ns.Keybind_FindSpellBindKey(spec, sid)
	end
	return nil
end

--- Physical layout key for highlighting (strips Alt/Shift/Ctrl).
function ns.MH_Keybind_GetLayoutUiKeyForSpell(spellId, specSlug)
	local bindKey = ns.MH_Keybind_GetUiKeyForSpell(spellId, specSlug)
	if not bindKey then
		return nil
	end
	if ns.Keybind_GetBaseUiKey then
		return ns.Keybind_GetBaseUiKey(bindKey)
	end
	return bindKey
end

--- Action-bar key label (e.g. "1", "Alt+E") for a spell id; drives Guide inline [key] hints.
function ns.MH_Keybind_GetKeycapLabelForSpell(spellId, specSlug)
	local ref = ns.KeybindingReference
	local sid = tonumber(spellId)
	if not ref or not sid or sid < 1 then
		return nil
	end
	specSlug = specSlug or "hunter_early"
	local bindKey = ns.MH_Keybind_GetUiKeyForSpell(sid, specSlug)
	if not bindKey then
		return nil
	end
	if ns.Keybind_FormatKeycap then
		local cap = ns.Keybind_FormatKeycap(bindKey)
		if cap and cap ~= "" then
			return cap
		end
	end
	local base = ns.Keybind_GetBaseUiKey and ns.Keybind_GetBaseUiKey(bindKey) or bindKey
	local slotList = ns.Keybinding_GetSlotsForSlug and ns.Keybinding_GetSlotsForSlug(specSlug) or ref.slots
	for _, slot in ipairs(slotList or {}) do
		if slot.ui_key == base and slot.key_labels then
			local kb = slot.key_labels.keyboard_numrow
			if kb and kb ~= "" and not ns.Keybind_GetModifier(bindKey) then
				return kb
			end
		end
	end
	return base or bindKey
end

--- True when guide `{SPELL:id}` layout should not append a [|key|] tail (spellbook-only utilities).
function ns.MH_Keybind_IsGuideSpellWithoutKeycap(spellId, specSlug)
	local sid = tonumber(spellId)
	if not sid or sid < 1 then
		return false
	end
	local ref = ns.KeybindingReference
	specSlug = specSlug or "hunter_early"
	local spec = ref and ref.specsById and ref.specsById[specSlug]
	local t = spec and spec.guideSpellsWithoutKeycap
	return t and t[sid] == true
end
