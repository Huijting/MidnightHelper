local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- Naam -> rol/categorie classifier voor Priest, Warlock, Mage (v6 keybind-map).
-- Gekoppeld op spell-NAAM (niet ID). Gegenereerd uit
-- docs/KEYBIND_MAP_DRAFT_priest_warlock_mage.md.
-- Alleen ASCII; geen ID's als key.

-- =====================================================================
-- PRIEST (Discipline / Holy / Shadow)
-- =====================================================================
ns.KeybindRoleClassifier.PRIEST = {
	-- Discipline
	["Penance"] = { category = "main_rotation", priority = 1, specs = { 256 } },
	["Power Word: Shield"] = { category = "main_rotation", priority = 2, specs = { 256, 257 } }, -- Disc builder (Holy gebruikt op Shift+C defensive)
	["Shadow Word: Pain"] = { category = "main_rotation", priority = 3, specs = { 256, 258 } }, -- Disc 3 / Shadow 1
	["Power Word: Radiance"] = { category = "spender", priority = 1, specs = { 256 } },
	["Shadow Word: Death"] = { category = "spender", priority = 2, specs = { 256, 258 } },
	["Mind Blast"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 256, 258 } }, -- Disc Shift+2 (Shadow zet op 3)
	["Evangelism"] = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 256 } },
	["Mind Control"] = { role = "utility_secondary", priority = 1, specs = { 256, 257 } }, -- E: geen interrupt (Disc/Holy)
	["Fade"] = { role = "utility_primary", priority = 1 },
	["Desperate Prayer"] = { role = "heal_quick", priority = 1 }, -- F2 (baseline persoonlijke noodheal, alle specs)
	["Power Word: Barrier"] = { role = "defensive_3", priority = 1, specs = { 256 } },
	["Pain Suppression"] = { category = "defensive", priority = 4, specs = { 256 } },
	["Psychic Scream"] = { category = "dispel_cc", priority = 1 },
	["Purify"] = { category = "dispel_cc", priority = 2, specs = { 256, 257 } },
	["Rapture"] = { role = "cooldown_bar", priority = 1, specs = { 256 } },
	["Ultimate Penitence"] = { category = "cooldown", priority = 2, specs = { 256 } },
	["Shadowfiend"] = { role = "utility_secondary", priority = 1, specs = { 256, 258 } }, -- Disc F (Shadow deelt F met Mindbender)
	["Power Infusion"] = { category = "utility", priority = 2 }, -- R: geen movement -> utility
	["Mass Dispel"] = { category = "utility", priority = 3 },
	["Leap of Faith"] = { category = "utility", priority = 4 },
	["Shackle Horror"] = { category = "dispel_cc", priority = 1, specs = { 256, 258 } }, -- Disc F2 / Shadow Shift+V (dispel/CC)

	-- Holy
	["Flash Heal"] = { role = "heal_ooc", priority = 1 }, -- F3: tweede snelle self-heal, baseline alle priester-specs (incl. Shadow)
	["Smite"] = { category = "main_rotation", priority = 2, specs = { 257 } },
	["Prayer of Mending"] = { category = "main_rotation", priority = 3, specs = { 257 } },
	["Holy Word: Serenity"] = { category = "spender", priority = 1, specs = { 257 } },
	["Holy Word: Sanctify"] = { category = "spender", priority = 2, specs = { 257 } },
	["Prayer of Healing"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 257 } },
	["Renew"] = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 257 } },
	["Guardian Spirit"] = { role = "defensive_3", priority = 1, specs = { 257 } },
	["Apotheosis"] = { role = "cooldown_bar", priority = 1, specs = { 257 } },
	["Divine Hymn"] = { category = "cooldown", priority = 2, specs = { 257 } },
	["Holy Word: Chastise"] = { role = "utility_secondary", priority = 1, specs = { 257 } },
	["Power Word: Life"] = { role = "heal_ooc", priority = 1, specs = { 257 } }, -- Holy F3 (tweede snelle self/low-hp-heal; F2 = Desperate Prayer baseline)
	["Symbol of Hope"] = { category = "utility", priority = 5, specs = { 257 } }, -- mana/CD-regen (geen self-heal, geen heal-anker)

	-- Shadow
	["Vampiric Touch"] = { category = "main_rotation", priority = 2, specs = { 258 } },
	["Shadow Word: Madness"] = { category = "spender", priority = 1, specs = { 258 } },
	["Void Bolt"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 258 } }, -- Shift+3 tweeling
	["Void Volley"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 258 } },
	["Mind Flay"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 258 } },
	["Silence"] = { role = "interrupt", priority = 1, specs = { 258 } },
	["Dispersion"] = { role = "defensive_3", priority = 1, specs = { 258 } },
	["Voidform"] = { role = "cooldown_bar", priority = 1, specs = { 258 } },
	["Void Torrent"] = { category = "cooldown", priority = 2, specs = { 258 } },
	["Mindbender"] = { role = "utility_secondary", priority = 1, specs = { 258 } }, -- Shadow F (alternatief voor Shadowfiend)
}

-- =====================================================================
-- WARLOCK (Affliction / Demonology / Destruction)
-- =====================================================================
ns.KeybindRoleClassifier.WARLOCK = {
	-- Gedeelde ankers (alle specs)
	["Spell Lock"] = { role = "interrupt", priority = 1, specs = { 265, 267 } }, -- pet-interrupt (Affli/Destro)
	["Axe Toss"] = { role = "interrupt", priority = 1, specs = { 266 } }, -- pet-interrupt (Demo)
	["Burning Rush"] = { role = "utility_primary", priority = 1 },
	["Demonic Circle: Teleport"] = { role = "utility_primary", priority = 2 }, -- Shift+Q
	["Drain Life"] = { role = "defensive_1", priority = 1 },
	["Dark Pact"] = { category = "defensive", priority = 3 }, -- Shift+Z
	["Unending Resolve"] = { role = "defensive_3", priority = 1 },
	["Fear"] = { category = "dispel_cc", priority = 1 },
	["Mortal Coil"] = { category = "dispel_cc", priority = 2, specs = { 265, 266 } }, -- Shift+V (Affli/Demo)
	["Healthstone"] = { role = "utility_secondary", priority = 1 },
	["Banish"] = { category = "utility", priority = 2 }, -- R: geen movement -> utility
	["Demonic Gateway"] = { category = "utility", priority = 4 },
	["Soulstone"] = { category = "utility", priority = 5 }, -- battle-res (geen self-heal, geen heal-anker)

	-- Affliction
	["Agony"] = { category = "main_rotation", priority = 1, specs = { 265 } },
	["Unstable Affliction"] = { category = "main_rotation", priority = 2, specs = { 265 } },
	["Haunt"] = { category = "main_rotation", priority = 3, specs = { 265 } },
	["Malefic Grasp"] = { category = "spender", priority = 1, specs = { 265 } },
	["Drain Soul"] = { category = "spender", priority = 2, specs = { 265 } },
	["Seed of Corruption"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 265 } },
	["Corruption"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 265 } },
	["Wither"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 265, 267 } }, -- Affli Shift+2 / Destro 2 (Hellcaller-variant)
	["Dark Harvest"] = { category = "spender", priority = 7, bindKey = "Shift+5", specs = { 265 } },
	["Summon Darkglare"] = { role = "cooldown_bar", priority = 1, specs = { 265 } },
	["Malevolence"] = { category = "cooldown", priority = 2, specs = { 265, 267 } }, -- Shift+F1 (Affli/Destro)
	["Howl of Terror"] = { category = "utility", priority = 3, specs = { 265 } }, -- Affli T

	-- Demonology
	["Shadow Bolt"] = { category = "main_rotation", priority = 1, specs = { 266 } },
	["Demonbolt"] = { category = "main_rotation", priority = 2, specs = { 266 } },
	["Call Dreadstalkers"] = { category = "main_rotation", priority = 3, specs = { 266 } },
	["Hand of Gul'dan"] = { category = "spender", priority = 1, specs = { 266 } },
	["Summon Vilefiend"] = { category = "spender", priority = 2, specs = { 266 } },
	["Implosion"] = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 266 } },
	["Power Siphon"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 266 } },
	["Summon Demonic Tyrant"] = { role = "cooldown_bar", priority = 1, specs = { 266 } },
	["Doom"] = { category = "utility", priority = 3, specs = { 266 } }, -- Demo T

	-- Destruction
	["Incinerate"] = { category = "main_rotation", priority = 1, specs = { 267 } },
	["Immolate"] = { category = "main_rotation", priority = 2, specs = { 267 } },
	["Conflagrate"] = { category = "main_rotation", priority = 3, specs = { 267 } },
	["Chaos Bolt"] = { category = "spender", priority = 1, specs = { 267 } },
	["Shadowburn"] = { category = "spender", priority = 2, specs = { 267 } },
	["Rain of Fire"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 267 } },
	["Havoc"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 267 } },
	["Soulfire"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 267 } },
	["Summon Infernal"] = { role = "cooldown_bar", priority = 1, specs = { 267 } },
	["Diabolic Ritual"] = { category = "utility", priority = 3, specs = { 267 } }, -- Destro T
}

-- =====================================================================
-- MAGE (Arcane / Fire)
-- =====================================================================
ns.KeybindRoleClassifier.MAGE = {
	-- Gedeelde ankers (Arcane / Fire, class tree)
	["Counterspell"] = { role = "interrupt", priority = 1 },
	["Blink"] = { role = "utility_primary", priority = 1 },
	["Shimmer"] = { role = "utility_primary", priority = 2 }, -- Shift+Q
	["Ice Block"] = { role = "defensive_3", priority = 1 },
	["Frost Nova"] = { category = "dispel_cc", priority = 1 },
	["Remove Curse"] = { category = "dispel_cc", priority = 2 },
	["Spellsteal"] = { role = "utility_secondary", priority = 1 },
	["Dragon's Breath"] = { category = "utility", priority = 3 }, -- Arcane X / Fire T
	["Mirror Image"] = { category = "utility", priority = 4 }, -- klonen/defensive (geen self-heal, geen heal-anker)

	-- Arcane
	["Arcane Blast"] = { category = "main_rotation", priority = 1, specs = { 62 } },
	["Arcane Orb"] = { category = "main_rotation", priority = 2, specs = { 62 } },
	["Arcane Missiles"] = { category = "main_rotation", priority = 3, specs = { 62 } },
	["Arcane Barrage"] = { category = "spender", priority = 1, specs = { 62 } },
	["Arcane Explosion"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 62 } },
	["Arcane Pulse"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 62 } },
	["Prismatic Barrier"] = { role = "defensive_1", priority = 1, specs = { 62 } },
	["Arcane Surge"] = { role = "cooldown_bar", priority = 1, specs = { 62 } },
	["Touch of the Magi"] = { category = "cooldown", priority = 2, specs = { 62 } },
	["Presence of Mind"] = { category = "utility", priority = 2, specs = { 62 } }, -- Arcane R: geen movement -> utility
	["Evocation"] = { category = "utility", priority = 3, specs = { 62 } }, -- Arcane T

	-- Fire
	["Fireball"] = { category = "main_rotation", priority = 1, specs = { 63 } },
	["Fire Blast"] = { category = "main_rotation", priority = 2, specs = { 63 } },
	["Scorch"] = { category = "main_rotation", priority = 3, specs = { 63 } },
	["Pyroblast"] = { category = "spender", priority = 1, specs = { 63 } },
	["Flamestrike"] = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 63 } },
	["Blazing Barrier"] = { role = "defensive_1", priority = 1, specs = { 63 } },
	["Cauterize"] = { category = "defensive", priority = 4, specs = { 63 } }, -- Fire Shift+C
	["Combustion"] = { role = "cooldown_bar", priority = 1, specs = { 63 } },
	["Meteor"] = { category = "cooldown", priority = 2, specs = { 63 } },
	["Time Warp"] = { category = "utility", priority = 2, specs = { 63 } }, -- Fire R: geen movement -> utility
}
