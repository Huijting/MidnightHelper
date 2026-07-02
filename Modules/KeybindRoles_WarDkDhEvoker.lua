local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- v6 keybind role classifier: spell NAME -> role/category mapping.
-- Generated from docs/KEYBIND_MAP_DRAFT_warrior_dk_dh_evoker.md (DRAFT, 2026-07-02).
-- Keyed on spell name (not ID); the addon matches against the live spellbook.
-- Class tokens: WARRIOR, DEATHKNIGHT, DEMONHUNTER, EVOKER.

ns.KeybindRoleClassifier.WARRIOR = {
	-- Arms
	["Mortal Strike"]      = { category = "main_rotation", priority = 1 },
	["Overpower"]          = { category = "main_rotation", priority = 2 },
	["Rend"]               = { category = "main_rotation", priority = 3 },
	["Execute"]            = { category = "spender", priority = 1 },
	["Slam"]               = { category = "spender", priority = 2 },
	["Sweeping Strikes"]   = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Cleave"]             = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Pummel"]             = { role = "interrupt", priority = 1 },
	["Heroic Leap"]        = { role = "mobility", priority = 1 },
	["Charge"]             = { role = "utility_primary", priority = 2, bindKey = "Shift+Q" },
	["Ignore Pain"]        = { role = "defensive_1", priority = 1 },
	["Die by the Sword"]   = { role = "defensive_3", priority = 1 },
	["Spell Reflection"]   = { category = "defensive", priority = 4, bindKey = "Shift+C" }, -- Arms/Prot Shift+C; Fury has it on C (defensive_3) -- see note
	["Intimidating Shout"] = { category = "dispel_cc", priority = 1 },
	["Berserker Rage"]     = { category = "dispel_cc", priority = 2, bindKey = "Shift+V" },
	["Colossus Smash"]     = { role = "cooldown_bar", priority = 1 },
	["Avatar"]             = { category = "cooldown", priority = 2, bindKey = "Shift+F1" },
	["Battle Shout"]       = { role = "utility_secondary", priority = 1 },
	["Victory Rush"]       = { category = "utility", priority = 2, bindKey = "R" },
	["Impending Victory"]  = { category = "utility", priority = 2, bindKey = "R" },
	["Hamstring"]          = { category = "utility", priority = 3 },
	["Rallying Cry"]       = { category = "utility", priority = 4 },
	["Wrecking Throw"]     = { role = "heal_quick", priority = 1 }, -- F2 anchor slot per v6 heal-anchor note
	["Storm Bolt"]         = { role = "heal_ooc", priority = 1 },   -- F3 anchor slot per v6 heal-anchor note

	-- Fury
	["Bloodthirst"]           = { category = "main_rotation", priority = 1 },
	["Raging Blow"]           = { category = "main_rotation", priority = 2 },
	["Rampage"]               = { category = "main_rotation", priority = 3 },
	["Whirlwind"]             = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Thunder Clap"]          = { category = "main_rotation", priority = 6, bindKey = "Shift+3" }, -- Fury Shift+3 AoE; Prot has it on 3 (main_rotation p3) -- see note
	["Thunder Blast"]         = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Enraged Regeneration"]  = { role = "defensive_1", priority = 1 },
	["Recklessness"]          = { role = "cooldown_bar", priority = 1 },
	["Bladestorm"]            = { category = "cooldown", priority = 3, bindKey = "Ctrl+F1" },
	["Odyn's Fury"]           = { role = "heal_ooc", priority = 1 }, -- F3 anchor slot per v6 heal-anchor note

	-- Protection
	["Shield Slam"]        = { category = "main_rotation", priority = 1 },
	["Revenge"]            = { category = "main_rotation", priority = 2 },
	["Demoralizing Shout"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Shield Charge"]      = { role = "utility_primary", priority = 3, bindKey = "Ctrl+Q" },
	["Shield Block"]       = { role = "defensive_1", priority = 1 },
	["Shield Wall"]        = { role = "defensive_3", priority = 1 },
	["Taunt"]              = { role = "utility_secondary", priority = 1 },
	["Champion's Spear"]   = { category = "cooldown", priority = 2, bindKey = "Shift+F1" },
	["Ravager"]            = { category = "cooldown", priority = 3, bindKey = "Ctrl+F1" },
	["Demolish"]           = { category = "cooldown", priority = 3, bindKey = "Ctrl+F1" },
	["Shattering Throw"]   = { role = "heal_ooc", priority = 1 }, -- F3 anchor slot per v6 heal-anchor note
}

ns.KeybindRoleClassifier.DEATHKNIGHT = {
	-- Blood
	["Heart Strike"]         = { category = "main_rotation", priority = 1 },
	["Marrowrend"]           = { category = "main_rotation", priority = 2 },
	["Death's Caress"]       = { category = "main_rotation", priority = 3 },
	["Death Strike"]         = { role = "defensive_1", priority = 1 }, -- Z anchor; also spender(4) in Blood, defensive across all specs -- see note
	["Blood Boil"]           = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Death and Decay"]      = { category = "main_rotation", priority = 6, bindKey = "Shift+2" }, -- Blood Shift+2; Unholy Shift+1
	["Mind Freeze"]          = { role = "interrupt", priority = 1 },
	["Death's Advance"]      = { role = "utility_primary", priority = 1 },
	["Wraith Walk"]          = { role = "utility_primary", priority = 2, bindKey = "Shift+Q" },
	["Lichborne"]            = { category = "defensive", priority = 3, bindKey = "Shift+Z" },
	["Icebound Fortitude"]   = { role = "defensive_3", priority = 1 },
	["Vampiric Blood"]       = { category = "defensive", priority = 4, bindKey = "Shift+C" },
	["Death Grip"]           = { category = "dispel_cc", priority = 1 },
	["Dancing Rune Weapon"]  = { role = "cooldown_bar", priority = 1 },
	["Consumption"]          = { category = "cooldown", priority = 2, bindKey = "Shift+F1" },
	["Dark Command"]         = { role = "utility_secondary", priority = 1 },
	["Anti-Magic Shell"]     = { category = "utility", priority = 2, bindKey = "R" }, -- Blood/Frost R; Unholy Shift+C (defensive)
	["Raise Dead"]           = { category = "utility", priority = 3 },
	["Death Pact"]           = { category = "utility", priority = 4 }, -- Blood X; Frost Shift+C (defensive) -- see note

	-- Frost
	["Obliterate"]           = { category = "main_rotation", priority = 1 },
	["Empower Rune Weapon"]  = { category = "main_rotation", priority = 2 },
	["Remorseless Winter"]   = { category = "main_rotation", priority = 3 },
	["Frost Strike"]         = { category = "spender", priority = 1 },
	["Howling Blast"]        = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Frostscythe"]          = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Glacial Advance"]      = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Chains of Ice"]        = { category = "dispel_cc", priority = 2, bindKey = "Shift+V" },
	["Pillar of Frost"]      = { role = "cooldown_bar", priority = 1 },
	["Frostwyrm's Fury"]     = { category = "cooldown", priority = 2, bindKey = "Shift+F1" },
	["Breath of Sindragosa"] = { category = "cooldown", priority = 3, bindKey = "Ctrl+F1" },

	-- Unholy
	["Festering Strike"]     = { category = "main_rotation", priority = 1 },
	["Scourge Strike"]       = { category = "main_rotation", priority = 2 },
	["Dark Transformation"]  = { category = "main_rotation", priority = 3 },
	["Death Coil"]           = { category = "spender", priority = 1 },
	["Epidemic"]             = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Army of the Dead"]     = { role = "cooldown_bar", priority = 1 },
	["Summon Gargoyle"]      = { category = "cooldown", priority = 2, bindKey = "Shift+F1" },
}

ns.KeybindRoleClassifier.DEMONHUNTER = {
	-- Havoc
	["Chaos Strike"]      = { category = "main_rotation", priority = 1 },
	["Annihilation"]      = { category = "main_rotation", priority = 1 },
	["Immolation Aura"]   = { category = "main_rotation", priority = 2 },
	["Eye Beam"]          = { category = "main_rotation", priority = 3 },
	["Throw Glaive"]      = { category = "spender", priority = 1 }, -- Havoc spender(4); Vengeance utility X -- see note
	["Blade Dance"]       = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Death Sweep"]       = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Disrupt"]           = { role = "interrupt", priority = 1 },
	["Fel Rush"]          = { role = "mobility", priority = 1 },
	["Vengeful Retreat"]  = { role = "utility_primary", priority = 2, bindKey = "Shift+Q" },
	["Felblade"]          = { role = "utility_primary", priority = 3, bindKey = "Ctrl+Q" },
	["Blur"]              = { role = "defensive_1", priority = 1 },
	["Darkness"]          = { role = "defensive_3", priority = 1 },
	["Chaos Nova"]        = { category = "dispel_cc", priority = 1 }, -- Havoc V; Vengeance Ctrl+V (p3)
	["Sigil of Misery"]   = { category = "dispel_cc", priority = 2, bindKey = "Shift+V" }, -- Havoc Shift+V; Vengeance V (p1) -- see note
	["Metamorphosis"]     = { role = "cooldown_bar", priority = 1 },
	["The Hunt"]          = { category = "cooldown", priority = 2, bindKey = "Shift+F1" },
	["Imprison"]          = { role = "utility_secondary", priority = 1 }, -- Havoc F; Vengeance R (utility p2)
	["Torment"]           = { category = "utility", priority = 2, bindKey = "R" }, -- Havoc R; Vengeance F (utility_secondary)
	["Consume Magic"]     = { category = "utility", priority = 3 },

	-- Vengeance
	["Fracture"]                = { category = "main_rotation", priority = 1 },
	["Sigil of Flame"]          = { category = "main_rotation", priority = 3 },
	["Soul Cleave"]             = { category = "spender", priority = 1 },
	["Spirit Bomb"]             = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Infernal Strike"]         = { role = "utility_primary", priority = 1 },
	["Demon Spikes"]            = { role = "defensive_1", priority = 1 },
	["Fiery Brand"]             = { role = "defensive_3", priority = 1 },
	["Fel Devastation"]         = { category = "defensive", priority = 4, bindKey = "Shift+C" },
	["Sigil of Chains"]         = { category = "dispel_cc", priority = 2, bindKey = "Shift+V" },
	["Metamorphosis (Vengeance)"] = { role = "cooldown_bar", priority = 1 },
	["Sigil of Spite"]          = { category = "cooldown", priority = 2, bindKey = "Shift+F1" },
}

ns.KeybindRoleClassifier.EVOKER = {
	-- Devastation
	["Living Flame"]          = { category = "main_rotation", priority = 1 }, -- Devastation 1; Preservation spender(5); Augmentation main_rotation(3) -- see note
	["Azure Strike"]          = { category = "main_rotation", priority = 2 }, -- Devastation 2; Augmentation Shift+3 AoE -- see note
	["Fire Breath"]           = { category = "main_rotation", priority = 3 }, -- Devastation 3; Pres/Aug Shift+4 AoE -- see note
	["Disintegrate"]          = { category = "spender", priority = 1 },
	["Eternity Surge"]        = { category = "spender", priority = 2 },
	["Azure Sweep"]           = { category = "main_rotation", priority = 6, bindKey = "Shift+2" },
	["Pyre"]                  = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Firestorm"]             = { category = "spender", priority = 7, bindKey = "Shift+5" },
	["Quell"]                 = { role = "interrupt", priority = 1 },
	["Hover"]                 = { role = "utility_primary", priority = 1 },
	["Deep Breath"]           = { role = "utility_primary", priority = 2, bindKey = "Shift+Q" },
	["Obsidian Scales"]       = { role = "defensive_1", priority = 1 },
	["Renewing Blaze"]        = { category = "defensive", priority = 3, bindKey = "Shift+Z" }, -- Dev/Aug Shift+Z; Preservation X (utility) -- see note
	["Zephyr"]                = { role = "defensive_3", priority = 1 }, -- Dev/Aug C; Preservation Shift+C (defensive p4) -- see note
	["Sleep Walk"]            = { category = "dispel_cc", priority = 1 },
	["Expunge"]               = { category = "dispel_cc", priority = 2, bindKey = "Shift+V" },
	["Cauterizing Flame"]     = { category = "dispel_cc", priority = 3, bindKey = "Ctrl+V" },
	["Dragonrage"]            = { role = "cooldown_bar", priority = 1 },
	["Fury of the Aspects"]   = { category = "cooldown", priority = 2, bindKey = "Shift+F1" },
	["Verdant Embrace"]       = { role = "utility_secondary", priority = 1 },
	["Blessing of the Bronze"] = { category = "utility", priority = 2, bindKey = "R" }, -- Dev R (mobility-less buff); Pres/Aug F (utility_secondary) -- see note
	["Landslide"]             = { category = "utility", priority = 3 },
	["Tail Swipe"]            = { category = "utility", priority = 4 },
	["Tip the Scales"]        = { role = "heal_quick", priority = 1 }, -- F2 anchor slot per v6 heal-anchor note
	["Oppressing Roar"]       = { role = "heal_ooc", priority = 1 },  -- F3 anchor slot per v6 heal-anchor note

	-- Preservation (healer)
	["Dream Breath"]      = { category = "main_rotation", priority = 1 },
	["Temporal Anomaly"]  = { category = "main_rotation", priority = 2 },
	["Echo"]              = { category = "main_rotation", priority = 3 },
	["Emerald Blossom"]   = { category = "spender", priority = 1 },
	["Time Dilation"]     = { category = "defensive", priority = 3, bindKey = "Shift+Z" },
	["Rewind"]            = { role = "defensive_3", priority = 1 },
	["Dream Flight"]      = { role = "cooldown_bar", priority = 1 },
	["Stasis"]            = { category = "cooldown", priority = 2, bindKey = "Shift+F1" },
	["Source of Magic"]   = { category = "utility", priority = 2, bindKey = "R" },
	["Reversion"]         = { role = "heal_quick", priority = 1 }, -- ST-heal, click-cast/mouseover; classified as quick heal

	-- Augmentation (support)
	["Ebon Might"]        = { category = "main_rotation", priority = 1 },
	["Prescience"]        = { category = "main_rotation", priority = 2 },
	["Eruption"]          = { category = "spender", priority = 1 },
	["Upheaval"]          = { category = "spender", priority = 2 },
	["Defy Fate"]         = { category = "defensive", priority = 4, bindKey = "Shift+C" },
	["Breath of Eons"]    = { role = "cooldown_bar", priority = 1 },
	["Blistering Scales"] = { category = "utility", priority = 2, bindKey = "R" },
	["Time Skip"]         = { category = "utility", priority = 3 },
	["Bestow Weyrnstone"] = { category = "utility", priority = 4 },
}
