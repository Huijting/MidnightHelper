local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- Auto-generated from docs/KEYBIND_MAP_DRAFT_rogue_monk_druid.md (v6 keybind maps).
-- Koppelen op spell-NAAM (niet ID). Alle specs van een class in EEN tabel.
-- Overgeslagen: Shift+E (racial), Ctrl+F1 (trinket-anker), Alt+C (potion),
-- zuiver passieve talents, en lege/dubbele "(zie X)"-rijen zonder eigen ability.

ns.KeybindRoleClassifier.ROGUE = {
	-- Assassination
	["Mutilate"]         = { category = "main_rotation", priority = 1, specs = { 259 } },
	["Shiv"]             = { category = "main_rotation", priority = 2, specs = { 259 } },
	["Garrote"]          = { category = "main_rotation", priority = 3, specs = { 259 } },
	["Envenom"]          = { category = "spender", priority = 1, specs = { 259 } },
	["Rupture"]          = { category = "spender", priority = 2, specs = { 259 } },
	["Fan of Knives"]    = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 259 } },
	["Crimson Tempest"]  = { category = "spender", priority = 7, bindKey = "Shift+5", specs = { 259 } },
	["Deathmark"]        = { role = "cooldown_bar", priority = 1, specs = { 259 } },
	["Kingsbane"]        = { category = "cooldown", priority = 2, specs = { 259 } },
	-- Outlaw
	["Sinister Strike"]     = { category = "main_rotation", priority = 1, specs = { 260 } },
	["Pistol Shot"]         = { category = "main_rotation", priority = 2, specs = { 260 } },
	["Roll the Bones"]      = { category = "main_rotation", priority = 3, specs = { 260 } },
	["Between the Eyes"]    = { category = "spender", priority = 1, specs = { 260 } },
	["Dispatch"]            = { category = "spender", priority = 2, specs = { 260 } },
	["Blade Flurry"]        = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 260 } },
	["Grappling Hook"]      = { role = "utility_primary", priority = 1, specs = { 260 } }, -- Outlaw Q (movement)
	["Adrenaline Rush"]     = { role = "cooldown_bar", priority = 1, specs = { 260 } },
	["Killing Spree"]       = { category = "cooldown", priority = 2, specs = { 260 } },
	-- Subtlety
	["Shadowstrike"]        = { category = "main_rotation", priority = 1, specs = { 261 } },
	["Backstab"]            = { category = "main_rotation", priority = 2, specs = { 261 } },
	["Secret Technique"]    = { category = "main_rotation", priority = 3, specs = { 261 } },
	["Eviscerate"]          = { category = "spender", priority = 1, specs = { 261 } },
	["Mark for Death"]      = { category = "spender", priority = 2, specs = { 261 } },
	["Shuriken Storm"]      = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 261 } },
	["Black Powder"]        = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 261 } },
	["Shadow Dance"]        = { role = "cooldown_bar", priority = 1, specs = { 261 } },
	["Shadow Blades"]       = { category = "cooldown", priority = 2, specs = { 261 } },
	-- Gedeeld (alle Rogue-specs)
	["Kick"]                = { role = "interrupt", priority = 1 },
	["Sprint"]              = { role = "utility_primary", priority = 1 }, -- Q op Assa/Sub; Shift+Q op Outlaw (movement)
	["Shadowstep"]          = { role = "utility_primary", priority = 1, specs = { 259, 261 } }, -- Q op Sub; Shift+Q op Assa (movement); niet Outlaw
	["Crimson Vial"]        = { role = "heal_quick", priority = 1 }, -- F2 primaire combat self-heal (instant HoT); alle Rogue-specs baseline. F4 = universele Recuperate.
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
	["Keg Smash"]                    = { category = "main_rotation", priority = 1, specs = { 268 } },
	["Purifying Brew"]               = { category = "spender", priority = 1, specs = { 268 } },
	["Breath of Fire"]               = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 268 } },
	["Rushing Jade Wind"]            = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 268 } },
	["Celestial Brew"]               = { role = "defensive_1", priority = 1, specs = { 268 } },
	["Invoke Niuzao, the Black Ox"]  = { role = "cooldown_bar", priority = 1, specs = { 268 } },
	["Provoke"]                      = { role = "utility_secondary", priority = 1, specs = { 268 } },
	-- Mistweaver
	["Rising Sun Kick"]              = { category = "main_rotation", priority = 3, specs = { 269, 270 } }, -- MW 3; ook WW 2 (main_rotation p2)
	["Sheilun's Gift"]               = { category = "spender", priority = 1, specs = { 270 } },
	["Thunder Focus Tea"]            = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 270 } },
	["Transcendence: Transfer"]      = { role = "utility_primary", priority = 2, specs = { 270 } },
	["Life Cocoon"]                  = { role = "defensive_1", priority = 1, specs = { 270 } },
	["Revival"]                      = { role = "defensive_3", priority = 1, specs = { 270 } },
	["Detox"]                        = { category = "dispel_cc", priority = 1, specs = { 270 } },
	["Ring of Peace"]                = { category = "dispel_cc", priority = 2, specs = { 270 } },
	-- Windwalker
	["Spinning Crane Kick"]          = { category = "main_rotation", priority = 3, specs = { 269 } },
	["Fists of Fury"]                = { category = "spender", priority = 1, specs = { 269 } },
	["Chi Torpedo"]                  = { role = "utility_primary", priority = 2, specs = { 269 } }, -- Shift+Q (movement)
	["Touch of Karma"]               = { role = "defensive_1", priority = 1, specs = { 269 } },
	["Diffuse Magic"]                = { category = "defensive", priority = 3, specs = { 269 } },
	["Invoke Xuen, the White Tiger"] = { role = "cooldown_bar", priority = 1, specs = { 269 } },
	["Flying Serpent Kick"]          = { role = "utility_secondary", priority = 1, specs = { 269 } },
	-- Gedeeld (meerdere Monk-specs)
	["Tiger Palm"]                   = { category = "main_rotation", priority = 1 }, -- BM 2 / MW 1 / WW 1 (meest voorkomend p1) -- alle Monk-specs (baseline)
	["Blackout Kick"]                = { category = "main_rotation", priority = 3 }, -- BM 3 / MW 2 / WW 5 (spender). Meest voorkomend: main_rotation -- alle Monk-specs (baseline)
	["Expel Harm"]                   = { role = "heal_quick", priority = 1, specs = { 268, 269 } }, -- F2 snelle self-heal; BM+WW (addon: 322101). MW: Expel Harm removed in 12.0 (JustAC-comment)
	["Spear Hand Strike"]            = { role = "interrupt", priority = 1, specs = { 268, 269 } }, -- BM+WW; MW heeft geen interrupt in Midnight
	["Roll"]                         = { role = "utility_primary", priority = 1 }, -- Q (movement) -- alle Monk-specs (baseline)
	["Fortifying Brew"]              = { role = "defensive_3", priority = 1, specs = { 268, 269 } }, -- C (grote defensive); MW gebruikt Revival op C
	["Paralysis"]                    = { category = "dispel_cc", priority = 1 }, -- V op BM/WW; F op MW -- alle Monk-specs (baseline)
	["Leg Sweep"]                    = { category = "dispel_cc", priority = 2, specs = { 268, 269 } }, -- BM+WW; niet in MW-tabel
}

ns.KeybindRoleClassifier.DRUID = {
	-- Balance
	["Wrath"]                          = { category = "main_rotation", priority = 1, specs = { 102, 105 } }, -- Balance 1 / Resto 1
	["Starfire"]                       = { category = "main_rotation", priority = 2, specs = { 102 } },
	["Moonfire"]                       = { category = "main_rotation", priority = 3, specs = { 102, 104, 105 } }, -- Balance 3 / Guardian 3 / Resto 2
	["Starsurge"]                      = { category = "spender", priority = 1, specs = { 102 } },
	["Sunfire"]                        = { category = "main_rotation", priority = 2, specs = { 102, 105 } }, -- Balance 5 (spender p2); Resto 3. Meest voorkomend: main_rotation
	["Starfall"]                       = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 102 } },
	["Solar Beam"]                     = { role = "interrupt", priority = 1, specs = { 102 } },
	["Tiger Dash"]                     = { role = "utility_primary", priority = 2, specs = { 102 } }, -- Shift+Q (movement)
	["Typhoon"]                        = { category = "dispel_cc", priority = 1, specs = { 102, 105 } }, -- V op Balance; F (utility) op Resto
	["Celestial Alignment"]            = { role = "cooldown_bar", priority = 1, specs = { 102 } },
	["Incarnation: Chosen of Elune"]   = { category = "cooldown", priority = 2, specs = { 102 } },
	-- Feral
	["Shred"]                          = { category = "main_rotation", priority = 1, specs = { 103 } },
	["Rake"]                           = { category = "main_rotation", priority = 2, specs = { 103 } },
	["Thrash"]                         = { category = "main_rotation", priority = 2, specs = { 103, 104 } }, -- Feral 3 / Guardian 2. Meest voorkomend: main_rotation
	["Rip"]                            = { category = "spender", priority = 1, specs = { 103 } },
	["Ferocious Bite"]                 = { category = "spender", priority = 2, specs = { 103 } },
	["Skull Bash"]                     = { role = "interrupt", priority = 1, specs = { 103, 104 } }, -- Feral+Guardian baseline; Resto alleen via optionele talent-node (niet baseline)
	["Stampeding Roar"]                = { role = "utility_primary", priority = 2, specs = { 103, 104 } }, -- Shift+Q (movement); Feral+Guardian
	["Survival Instincts"]             = { role = "defensive_3", priority = 1, specs = { 103, 104 } }, -- C op Feral en Guardian
	["Maim"]                           = { category = "dispel_cc", priority = 1, specs = { 103 } },
	["Berserk"]                        = { role = "cooldown_bar", priority = 1, specs = { 103, 104 } }, -- Feral (106951) + Guardian (50334); aparte ID's, zelfde naam
	["Incarnation: Avatar of Ashamane"]= { category = "cooldown", priority = 2, specs = { 103 } },
	["Rebirth"]                        = { role = "utility_secondary", priority = 1, specs = { 103, 104 } }, -- Feral F; Guardian R (utility). Meest voorkomend: utility_secondary
	-- Guardian
	["Mangle"]                         = { category = "main_rotation", priority = 1, specs = { 104 } },
	["Ironfur"]                        = { category = "spender", priority = 1, specs = { 104 } },
	["Frenzied Regeneration"]          = { category = "spender", priority = 2, specs = { 104 } },
	["Mighty Bash"]                    = { category = "dispel_cc", priority = 1, specs = { 102, 104 } }, -- Balance Shift+V (p2) / Guardian V (p1). Meest voorkomend: p1
	["Incapacitating Roar"]            = { category = "dispel_cc", priority = 2, specs = { 104 } }, -- alleen in Guardian-tabel (Shift+V)
	["Incarnation: Guardian of Ursoc"] = { role = "cooldown_bar", priority = 1, specs = { 104 } },
	["Berserk: Ravage"]                = { category = "cooldown", priority = 2, specs = { 104 } },
	["Growl"]                          = { role = "utility_secondary", priority = 1, specs = { 104 } }, -- alleen Guardian (F, taunt)
	-- Restoration
	["Swiftmend"]                      = { category = "spender", priority = 1, specs = { 105 } },
	["Wild Growth"]                    = { category = "spender", priority = 2, specs = { 105 } },
	["Ironbark"]                       = { role = "defensive_1", priority = 1, specs = { 105 } },
	["Tranquility"]                    = { role = "defensive_3", priority = 1, specs = { 105 } },
	["Nature's Cure"]                  = { category = "dispel_cc", priority = 1, specs = { 105 } },
	["Mass Entanglement"]              = { category = "dispel_cc", priority = 2, specs = { 105 } },
	["Flourish"]                       = { role = "cooldown_bar", priority = 1, specs = { 105 } },
	["Innervate"]                      = { category = "utility", priority = 2, specs = { 102, 105 } }, -- R (geen movement -> utility); ExwindCore specs 102 en 105 = Balance+Resto
	-- Gedeeld (alle Druid-specs)
	["Wild Charge"]                    = { role = "utility_primary", priority = 1 }, -- Q (movement) -- alle Druid-specs (baseline)
	["Barkskin"]                       = { role = "defensive_1", priority = 1 }, -- alle Druid-specs (baseline)
	["Renewal"]                        = { role = "defensive_3", priority = 1 }, -- alle Druid-specs volgens ExwindCore (baseline)
}
