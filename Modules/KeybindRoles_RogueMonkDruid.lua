local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- Auto-generated from docs/KEYBIND_MAP_DRAFT_rogue_monk_druid.md (v6 keybind maps).
-- Koppelen op spell-NAAM (niet ID). Alle specs van een class in EEN tabel.
-- Overgeslagen: Shift+E (racial), Ctrl+F1 (trinket-anker), Alt+C (potion),
-- zuiver passieve talents, en lege/dubbele "(zie X)"-rijen zonder eigen ability.

ns.KeybindRoleClassifier.ROGUE = {
	-- Assassination
	["Mutilate"]         = { category = "main_rotation", priority = 1 },
	["Shiv"]             = { category = "main_rotation", priority = 2 },
	["Garrote"]          = { category = "main_rotation", priority = 3 },
	["Envenom"]          = { category = "spender", priority = 1 },
	["Rupture"]          = { category = "spender", priority = 2 },
	["Fan of Knives"]    = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Crimson Tempest"]  = { category = "spender", priority = 7, bindKey = "Shift+5" },
	["Deathmark"]        = { role = "cooldown_bar", priority = 1 },
	["Kingsbane"]        = { category = "cooldown", priority = 2 },
	-- Outlaw
	["Sinister Strike"]     = { category = "main_rotation", priority = 1 },
	["Pistol Shot"]         = { category = "main_rotation", priority = 2 },
	["Roll the Bones"]      = { category = "main_rotation", priority = 3 },
	["Between the Eyes"]    = { category = "spender", priority = 1 },
	["Dispatch"]            = { category = "spender", priority = 2 },
	["Blade Flurry"]        = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Grappling Hook"]      = { role = "utility_primary", priority = 1 }, -- Outlaw Q (movement)
	["Adrenaline Rush"]     = { role = "cooldown_bar", priority = 1 },
	["Killing Spree"]       = { category = "cooldown", priority = 2 },
	-- Subtlety
	["Shadowstrike"]        = { category = "main_rotation", priority = 1 },
	["Backstab"]            = { category = "main_rotation", priority = 2 },
	["Secret Technique"]    = { category = "main_rotation", priority = 3 },
	["Eviscerate"]          = { category = "spender", priority = 1 },
	["Mark for Death"]      = { category = "spender", priority = 2 },
	["Shuriken Storm"]      = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Black Powder"]        = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Shadow Dance"]        = { role = "cooldown_bar", priority = 1 },
	["Shadow Blades"]       = { category = "cooldown", priority = 2 },
	-- Gedeeld (alle Rogue-specs)
	["Kick"]                = { role = "interrupt", priority = 1 },
	["Sprint"]              = { role = "utility_primary", priority = 1 }, -- Q op Assa/Sub; Shift+Q op Outlaw (movement)
	["Shadowstep"]          = { role = "utility_primary", priority = 1 }, -- Q op Sub; Shift+Q op Assa (movement)
	["Crimson Vial"]        = { role = "defensive_1", priority = 1 },
	["Feint"]               = { category = "defensive", priority = 3 },
	["Cloak of Shadows"]    = { role = "defensive_3", priority = 1 },
	["Evasion"]             = { category = "defensive", priority = 4 },
	["Blind"]               = { category = "dispel_cc", priority = 1 },
	["Kidney Shot"]         = { category = "dispel_cc", priority = 2 },
	["Vanish"]              = { role = "utility_secondary", priority = 1 },
	["Sap"]                 = { category = "utility", priority = 2 }, -- R (geen movement -> utility)
	["Cheap Shot"]          = { category = "utility", priority = 3 }, -- T
}

ns.KeybindRoleClassifier.MONK = {
	-- Brewmaster
	["Keg Smash"]                    = { category = "main_rotation", priority = 1 },
	["Purifying Brew"]               = { category = "spender", priority = 1 },
	["Breath of Fire"]               = { category = "main_rotation", priority = 6, bindKey = "Shift+2" },
	["Rushing Jade Wind"]            = { category = "main_rotation", priority = 6, bindKey = "Shift+3" },
	["Celestial Brew"]               = { role = "defensive_1", priority = 1 },
	["Invoke Niuzao, the Black Ox"]  = { role = "cooldown_bar", priority = 1 },
	["Provoke"]                      = { role = "utility_secondary", priority = 1 },
	-- Mistweaver
	["Rising Sun Kick"]              = { category = "main_rotation", priority = 3 }, -- MW 3; ook WW 2 (main_rotation p2)
	["Sheilun's Gift"]               = { category = "spender", priority = 1 },
	["Thunder Focus Tea"]            = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Transcendence: Transfer"]      = { role = "utility_primary", priority = 2 },
	["Life Cocoon"]                  = { role = "defensive_1", priority = 1 },
	["Revival"]                      = { role = "defensive_3", priority = 1 },
	["Detox"]                        = { category = "dispel_cc", priority = 1 },
	["Ring of Peace"]                = { category = "dispel_cc", priority = 2 },
	-- Windwalker
	["Spinning Crane Kick"]          = { category = "main_rotation", priority = 3 },
	["Fists of Fury"]                = { category = "spender", priority = 1 },
	["Chi Torpedo"]                  = { role = "utility_primary", priority = 2 }, -- Shift+Q (movement)
	["Touch of Karma"]               = { role = "defensive_1", priority = 1 },
	["Diffuse Magic"]                = { category = "defensive", priority = 3 },
	["Invoke Xuen, the White Tiger"] = { role = "cooldown_bar", priority = 1 },
	["Flying Serpent Kick"]          = { role = "utility_secondary", priority = 1 },
	-- Gedeeld (meerdere Monk-specs)
	["Tiger Palm"]                   = { category = "main_rotation", priority = 1 }, -- BM 2 / MW 1 / WW 1 (meest voorkomend p1)
	["Blackout Kick"]                = { category = "main_rotation", priority = 3 }, -- BM 3 / MW 2 / WW 5 (spender). Meest voorkomend: main_rotation
	["Spear Hand Strike"]            = { role = "interrupt", priority = 1 },
	["Roll"]                         = { role = "utility_primary", priority = 1 }, -- Q (movement)
	["Fortifying Brew"]              = { role = "defensive_3", priority = 1 }, -- C (grote defensive)
	["Paralysis"]                    = { category = "dispel_cc", priority = 1 }, -- V op BM/WW; F op MW
	["Leg Sweep"]                    = { category = "dispel_cc", priority = 2 },
}

ns.KeybindRoleClassifier.DRUID = {
	-- Balance
	["Wrath"]                          = { category = "main_rotation", priority = 1 }, -- Balance 1 / Resto 1
	["Starfire"]                       = { category = "main_rotation", priority = 2 },
	["Moonfire"]                       = { category = "main_rotation", priority = 3 }, -- Balance 3 / Guardian 3 / Resto 2
	["Starsurge"]                      = { category = "spender", priority = 1 },
	["Sunfire"]                        = { category = "main_rotation", priority = 2 }, -- Balance 5 (spender p2); Resto 3. Meest voorkomend: main_rotation
	["Starfall"]                       = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Solar Beam"]                     = { role = "interrupt", priority = 1 },
	["Tiger Dash"]                     = { role = "utility_primary", priority = 2 }, -- Shift+Q (movement)
	["Typhoon"]                        = { category = "dispel_cc", priority = 1 }, -- V op Balance; F (utility) op Resto
	["Celestial Alignment"]            = { role = "cooldown_bar", priority = 1 },
	["Incarnation: Chosen of Elune"]   = { category = "cooldown", priority = 2 },
	-- Feral
	["Shred"]                          = { category = "main_rotation", priority = 1 },
	["Rake"]                           = { category = "main_rotation", priority = 2 },
	["Thrash"]                         = { category = "main_rotation", priority = 2 }, -- Feral 3 / Guardian 2. Meest voorkomend: main_rotation
	["Rip"]                            = { category = "spender", priority = 1 },
	["Ferocious Bite"]                 = { category = "spender", priority = 2 },
	["Skull Bash"]                     = { role = "interrupt", priority = 1 },
	["Stampeding Roar"]                = { role = "utility_primary", priority = 2 }, -- Shift+Q (movement)
	["Survival Instincts"]             = { role = "defensive_3", priority = 1 },
	["Maim"]                           = { category = "dispel_cc", priority = 1 },
	["Berserk"]                        = { role = "cooldown_bar", priority = 1 },
	["Incarnation: Avatar of Ashamane"]= { category = "cooldown", priority = 2 },
	["Rebirth"]                        = { role = "utility_secondary", priority = 1 }, -- Feral F; Guardian R (utility). Meest voorkomend: utility_secondary
	-- Guardian
	["Mangle"]                         = { category = "main_rotation", priority = 1 },
	["Ironfur"]                        = { category = "spender", priority = 1 },
	["Frenzied Regeneration"]          = { category = "spender", priority = 2 },
	["Mighty Bash"]                    = { category = "dispel_cc", priority = 1 }, -- Balance Shift+V (p2) / Guardian V (p1). Meest voorkomend: p1
	["Incapacitating Roar"]            = { category = "dispel_cc", priority = 2 },
	["Incarnation: Guardian of Ursoc"] = { role = "cooldown_bar", priority = 1 },
	["Berserk: Ravage"]                = { category = "cooldown", priority = 2 },
	["Growl"]                          = { role = "utility_secondary", priority = 1 },
	-- Restoration
	["Swiftmend"]                      = { category = "spender", priority = 1 },
	["Wild Growth"]                    = { category = "spender", priority = 2 },
	["Ironbark"]                       = { role = "defensive_1", priority = 1 },
	["Tranquility"]                    = { role = "defensive_3", priority = 1 },
	["Nature's Cure"]                  = { category = "dispel_cc", priority = 1 },
	["Mass Entanglement"]              = { category = "dispel_cc", priority = 2 },
	["Flourish"]                       = { role = "cooldown_bar", priority = 1 },
	["Innervate"]                      = { category = "utility", priority = 2 }, -- R (geen movement -> utility)
	-- Gedeeld (alle Druid-specs)
	["Wild Charge"]                    = { role = "utility_primary", priority = 1 }, -- Q (movement)
	["Barkskin"]                       = { role = "defensive_1", priority = 1 },
	["Renewal"]                        = { role = "defensive_3", priority = 1 },
}
