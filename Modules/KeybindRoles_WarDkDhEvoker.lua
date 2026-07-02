local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- v6 keybind role classifier: spell NAME -> role/category mapping.
-- Generated from docs/KEYBIND_MAP_DRAFT_warrior_dk_dh_evoker.md (DRAFT, 2026-07-02).
-- Keyed on spell name (not ID); the addon matches against the live spellbook.
-- Class tokens: WARRIOR, DEATHKNIGHT, DEMONHUNTER, EVOKER.

ns.KeybindRoleClassifier.WARRIOR = {
	-- Arms
	["Mortal Strike"]      = { category = "main_rotation", priority = 1, specs = { 71 } },
	["Overpower"]          = { category = "main_rotation", priority = 2, specs = { 71 } },
	["Rend"]               = { category = "main_rotation", priority = 3, specs = { 71 } },
	["Execute"]            = { category = "spender", priority = 1 },
	["Slam"]               = { category = "spender", priority = 2, specs = { 71 } },
	["Sweeping Strikes"]   = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 71 } },
	["Cleave"]             = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 71 } },
	["Pummel"]             = { role = "interrupt", priority = 1 },
	["Heroic Leap"]        = { role = "mobility", priority = 1 },
	["Charge"]             = { role = "utility_primary", priority = 2, bindKey = "Shift+Q" },
	["Ignore Pain"]        = { role = "defensive_1", priority = 1, specs = { 71, 73 } },
	["Die by the Sword"]   = { role = "defensive_3", priority = 1, specs = { 71 } },
	["Spell Reflection"]   = { category = "defensive", priority = 4, bindKey = "Shift+C" }, -- Arms/Prot Shift+C; Fury has it on C (defensive_3) -- see note
	["Intimidating Shout"] = { category = "dispel_cc", priority = 1 },
	["Berserker Rage"]     = { category = "dispel_cc", priority = 2, bindKey = "Shift+V" },
	["Colossus Smash"]     = { role = "cooldown_bar", priority = 1, specs = { 71 } },
	["Avatar"]             = { category = "cooldown", priority = 2, bindKey = "Shift+F1" },
	["Battle Shout"]       = { role = "utility_secondary", priority = 1 },
	["Victory Rush"]       = { role = "heal_quick", priority = 1, specs = { 71, 72 } }, -- F2: instant self-heal (talent, wederzijds uitsluitend met Impending Victory)
	["Impending Victory"]  = { role = "heal_quick", priority = 1, specs = { 71, 72 } }, -- F2: instant self-heal (talent-variant van Victory Rush)
	["Hamstring"]          = { category = "utility", priority = 3 },
	["Rallying Cry"]       = { category = "utility", priority = 4 },
	["Wrecking Throw"]     = { category = "utility", priority = 5 }, -- anti-shield/immuniteit (geen heal)
	["Storm Bolt"]         = { category = "utility", priority = 6, specs = { 71, 72 } }, -- CC/utility (talent, geen heal)

	-- Fury
	["Bloodthirst"]           = { category = "main_rotation", priority = 1, specs = { 72 } },
	["Raging Blow"]           = { category = "main_rotation", priority = 2, specs = { 72 } },
	["Rampage"]               = { category = "main_rotation", priority = 3, specs = { 72 } },
	["Whirlwind"]             = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 72 } },
	["Thunder Clap"]          = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 72, 73 } }, -- Fury Shift+3 AoE; Prot has it on 3 (main_rotation p3) -- see note
	["Thunder Blast"]         = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 72, 73 } },
	["Enraged Regeneration"]  = { role = "defensive_1", priority = 1, specs = { 72 } },
	["Recklessness"]          = { role = "cooldown_bar", priority = 1, specs = { 72 } },
	["Bladestorm"]            = { category = "cooldown", priority = 3, bindKey = "Ctrl+F1", specs = { 71, 72 } },
	["Odyn's Fury"]           = { category = "cooldown", priority = 4, specs = { 72 } }, -- major cooldown (geen heal); Enraged Regeneration blijft op Z (defensive_1)

	-- Protection
	["Shield Slam"]        = { category = "main_rotation", priority = 1, specs = { 73 } },
	["Revenge"]            = { category = "main_rotation", priority = 2, specs = { 73 } },
	["Demoralizing Shout"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 73 } },
	["Shield Charge"]      = { role = "utility_primary", priority = 3, bindKey = "Ctrl+Q", specs = { 73 } },
	["Shield Block"]       = { role = "defensive_1", priority = 1, specs = { 73 } },
	["Shield Wall"]        = { role = "defensive_3", priority = 1, specs = { 73 } },
	["Taunt"]              = { role = "utility_secondary", priority = 1, specs = { 73 } },
	["Champion's Spear"]   = { category = "cooldown", priority = 2, bindKey = "Shift+F1", specs = { 73 } },
	["Ravager"]            = { category = "cooldown", priority = 3, bindKey = "Ctrl+F1", specs = { 71, 73 } },
	["Demolish"]           = { category = "cooldown", priority = 3, bindKey = "Ctrl+F1", specs = { 71, 73 } },
	["Shattering Throw"]   = { category = "utility", priority = 5, specs = { 73 } }, -- anti-immuniteit (geen heal)
}

ns.KeybindRoleClassifier.DEATHKNIGHT = {
	-- Blood
	["Heart Strike"]         = { category = "main_rotation", priority = 1, specs = { 250 } },
	["Marrowrend"]           = { category = "main_rotation", priority = 2, specs = { 250 } },
	["Death's Caress"]       = { category = "main_rotation", priority = 3, specs = { 250 } },
	["Death Strike"]         = { role = "defensive_1", priority = 1 }, -- Z anchor; also spender(4) in Blood, defensive across all specs -- see note
	["Blood Boil"]           = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 250 } },
	["Death and Decay"]      = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 250, 252 } }, -- Blood Shift+2; Unholy Shift+1
	["Mind Freeze"]          = { role = "interrupt", priority = 1 },
	["Death's Advance"]      = { role = "utility_primary", priority = 1 },
	["Wraith Walk"]          = { role = "utility_primary", priority = 2, bindKey = "Shift+Q", specs = { 250, 251 } },
	["Lichborne"]            = { category = "defensive", priority = 3, bindKey = "Shift+Z" },
	["Icebound Fortitude"]   = { role = "defensive_3", priority = 1 },
	["Vampiric Blood"]       = { category = "defensive", priority = 4, bindKey = "Shift+C", specs = { 250 } },
	["Death Grip"]           = { category = "dispel_cc", priority = 1 },
	["Dancing Rune Weapon"]  = { role = "cooldown_bar", priority = 1, specs = { 250 } },
	["Consumption"]          = { category = "cooldown", priority = 2, bindKey = "Shift+F1", specs = { 250 } },
	["Dark Command"]         = { role = "utility_secondary", priority = 1 },
	["Anti-Magic Shell"]     = { category = "utility", priority = 2, bindKey = "R" }, -- Blood/Frost R; Unholy Shift+C (defensive)
	["Raise Dead"]           = { category = "utility", priority = 3 },
	["Death Pact"]           = { role = "heal_quick", priority = 1, specs = { 250, 251, 252 } }, -- F2: grote instant self-heal (talent, alle DK-specs). Death Strike blijft rotatie/defensive.

	-- Frost
	["Obliterate"]           = { category = "main_rotation", priority = 1, specs = { 251 } },
	["Empower Rune Weapon"]  = { category = "main_rotation", priority = 2, specs = { 251 } },
	["Remorseless Winter"]   = { category = "main_rotation", priority = 3, specs = { 251 } },
	["Frost Strike"]         = { category = "spender", priority = 1, specs = { 251 } },
	["Howling Blast"]        = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 251 } },
	["Frostscythe"]          = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 251 } },
	["Glacial Advance"]      = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 251 } },
	["Chains of Ice"]        = { category = "dispel_cc", priority = 2, bindKey = "Shift+V", specs = { 251, 252 } },
	["Pillar of Frost"]      = { role = "cooldown_bar", priority = 1, specs = { 251 } },
	["Frostwyrm's Fury"]     = { category = "cooldown", priority = 2, bindKey = "Shift+F1", specs = { 251 } },
	["Breath of Sindragosa"] = { category = "cooldown", priority = 3, bindKey = "Ctrl+F1", specs = { 251 } },

	-- Unholy
	["Festering Strike"]     = { category = "main_rotation", priority = 1, specs = { 252 } },
	["Scourge Strike"]       = { category = "main_rotation", priority = 2, specs = { 252 } },
	["Dark Transformation"]  = { category = "main_rotation", priority = 3, specs = { 252 } },
	["Death Coil"]           = { category = "spender", priority = 1, specs = { 252 } },
	["Epidemic"]             = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 252 } },
	["Army of the Dead"]     = { role = "cooldown_bar", priority = 1, specs = { 252 } },
	["Summon Gargoyle"]      = { category = "cooldown", priority = 2, bindKey = "Shift+F1", specs = { 252 } },
}

ns.KeybindRoleClassifier.DEMONHUNTER = {
	-- Havoc
	["Chaos Strike"]      = { category = "main_rotation", priority = 1, specs = { 577 } },
	["Annihilation"]      = { category = "main_rotation", priority = 1, specs = { 577 } },
	["Immolation Aura"]   = { category = "main_rotation", priority = 2 },
	["Eye Beam"]          = { category = "main_rotation", priority = 3, specs = { 577 } },
	["Throw Glaive"]      = { category = "spender", priority = 1 }, -- Havoc spender(4); Vengeance utility X -- see note
	["Blade Dance"]       = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 577 } },
	["Death Sweep"]       = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 577 } },
	["Disrupt"]           = { role = "interrupt", priority = 1 },
	["Fel Rush"]          = { role = "mobility", priority = 1, specs = { 577 } },
	["Vengeful Retreat"]  = { role = "utility_primary", priority = 2, bindKey = "Shift+Q" },
	["Felblade"]          = { role = "utility_primary", priority = 3, bindKey = "Ctrl+Q" },
	["Blur"]              = { role = "defensive_1", priority = 1, specs = { 577 } },
	["Darkness"]          = { role = "defensive_3", priority = 1, specs = { 577 } },
	["Chaos Nova"]        = { category = "dispel_cc", priority = 1 }, -- Havoc V; Vengeance Ctrl+V (p3)
	["Sigil of Misery"]   = { category = "dispel_cc", priority = 2, bindKey = "Shift+V" }, -- Havoc Shift+V; Vengeance V (p1) -- see note
	["Metamorphosis"]     = { role = "cooldown_bar", priority = 1, specs = { 577 } },
	["The Hunt"]          = { category = "cooldown", priority = 2, bindKey = "Shift+F1", specs = { 577 } },
	["Imprison"]          = { role = "utility_secondary", priority = 1 }, -- Havoc F; Vengeance R (utility p2)
	["Torment"]           = { category = "utility", priority = 2, bindKey = "R" }, -- Havoc R; Vengeance F (utility_secondary)
	["Consume Magic"]     = { category = "utility", priority = 3 },

	-- Vengeance
	["Fracture"]                = { category = "main_rotation", priority = 1, specs = { 581 } },
	["Sigil of Flame"]          = { category = "main_rotation", priority = 3, specs = { 581 } },
	["Soul Cleave"]             = { category = "spender", priority = 1, specs = { 581 } },
	["Spirit Bomb"]             = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 581 } },
	["Infernal Strike"]         = { role = "utility_primary", priority = 1, specs = { 581 } },
	["Demon Spikes"]            = { role = "defensive_1", priority = 1, specs = { 581 } },
	["Fiery Brand"]             = { role = "defensive_3", priority = 1, specs = { 581 } },
	["Fel Devastation"]         = { category = "defensive", priority = 4, bindKey = "Shift+C", specs = { 581 } },
	["Sigil of Chains"]         = { category = "dispel_cc", priority = 2, bindKey = "Shift+V", specs = { 581 } },
	["Metamorphosis (Vengeance)"] = { role = "cooldown_bar", priority = 1, specs = { 581 } },
	["Sigil of Spite"]          = { category = "cooldown", priority = 2, bindKey = "Shift+F1", specs = { 581 } },
}

ns.KeybindRoleClassifier.EVOKER = {
	-- Devastation
	["Living Flame"]          = { category = "main_rotation", priority = 1 }, -- Devastation 1; Preservation spender(5); Augmentation main_rotation(3) -- see note
	["Azure Strike"]          = { category = "main_rotation", priority = 2, specs = { 1467, 1473 } }, -- Devastation 2; Augmentation Shift+3 AoE -- see note
	["Fire Breath"]           = { category = "main_rotation", priority = 3 }, -- Devastation 3; Pres/Aug Shift+4 AoE -- see note
	["Disintegrate"]          = { category = "spender", priority = 1, specs = { 1467 } },
	["Eternity Surge"]        = { category = "spender", priority = 2, specs = { 1467 } },
	["Azure Sweep"]           = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 1467 } },
	["Pyre"]                  = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 1467 } },
	["Firestorm"]             = { category = "spender", priority = 7, bindKey = "Shift+5", specs = { 1467 } },
	["Quell"]                 = { role = "interrupt", priority = 1 },
	["Hover"]                 = { role = "utility_primary", priority = 1 },
	["Deep Breath"]           = { role = "utility_primary", priority = 2, bindKey = "Shift+Q" },
	["Obsidian Scales"]       = { role = "defensive_1", priority = 1 },
	["Renewing Blaze"]        = { role = "heal_ooc", priority = 1, specs = { 1467, 1468 } }, -- F3: HoT self-heal (heelt over 8s). F4 = universele Recuperate. Addon-data ExwindCore: specs {1467,1468}.
	["Zephyr"]                = { role = "defensive_3", priority = 1 }, -- Dev/Aug C; Preservation Shift+C (defensive p4) -- see note
	["Sleep Walk"]            = { category = "dispel_cc", priority = 1 },
	["Expunge"]               = { category = "dispel_cc", priority = 2, bindKey = "Shift+V" },
	["Cauterizing Flame"]     = { category = "dispel_cc", priority = 3, bindKey = "Ctrl+V" },
	["Dragonrage"]            = { role = "cooldown_bar", priority = 1, specs = { 1467 } },
	["Fury of the Aspects"]   = { category = "cooldown", priority = 2, bindKey = "Shift+F1", specs = { 1467, 1473 } },
	["Verdant Embrace"]       = { role = "heal_quick", priority = 1, specs = { 1467 } }, -- F2: dedicated self/ally-heal (Devastation). Preservation gebruikt dit via mouseover/click-cast, niet op anker.
	["Blessing of the Bronze"] = { category = "utility", priority = 2, bindKey = "R" }, -- Dev R (mobility-less buff); Pres/Aug F (utility_secondary) -- see note
	["Landslide"]             = { category = "utility", priority = 3, specs = { 1467, 1468 } },
	["Tail Swipe"]            = { category = "utility", priority = 4, specs = { 1467 } },
	["Tip the Scales"]        = { category = "utility", priority = 5, specs = { 1467, 1473 } }, -- empower-modifier (geen heal)
	["Oppressing Roar"]       = { category = "utility", priority = 6, specs = { 1467 } }, -- fear-immuniteit groep (geen heal)

	-- Preservation (healer)
	["Dream Breath"]      = { category = "main_rotation", priority = 1, specs = { 1468 } },
	["Temporal Anomaly"]  = { category = "main_rotation", priority = 2, specs = { 1468 } },
	["Echo"]              = { category = "main_rotation", priority = 3, specs = { 1468 } },
	["Emerald Blossom"]   = { category = "spender", priority = 1, specs = { 1468 } },
	["Time Dilation"]     = { category = "defensive", priority = 3, bindKey = "Shift+Z", specs = { 1468 } },
	["Rewind"]            = { role = "defensive_3", priority = 1, specs = { 1468 } },
	["Dream Flight"]      = { role = "cooldown_bar", priority = 1, specs = { 1468 } },
	["Stasis"]            = { category = "cooldown", priority = 2, bindKey = "Shift+F1", specs = { 1468 } },
	["Source of Magic"]   = { category = "utility", priority = 2, bindKey = "R", specs = { 1468 } },
	["Reversion"]         = { category = "utility", priority = 5, specs = { 1468 } }, -- healer ST-heal HoT via mouseover/click-cast; NIET op F2/F3/F4 (regel 4: raid-heal-kit niet op ankers)

	-- Augmentation (support)
	["Ebon Might"]        = { category = "main_rotation", priority = 1, specs = { 1473 } },
	["Prescience"]        = { category = "main_rotation", priority = 2, specs = { 1473 } },
	["Eruption"]          = { category = "spender", priority = 1, specs = { 1473 } },
	["Upheaval"]          = { category = "spender", priority = 2, specs = { 1473 } },
	["Defy Fate"]         = { category = "defensive", priority = 4, bindKey = "Shift+C", specs = { 1473 } },
	["Breath of Eons"]    = { role = "cooldown_bar", priority = 1, specs = { 1473 } },
	["Blistering Scales"] = { category = "utility", priority = 2, bindKey = "R", specs = { 1473 } },
	["Time Skip"]         = { category = "utility", priority = 3, specs = { 1473 } },
	["Bestow Weyrnstone"] = { category = "utility", priority = 4, specs = { 1473 } },
}
