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
	["Penance"] = { category = "main_rotation", priority = 1 },
	["Power Word: Shield"] = { category = "main_rotation", priority = 2 }, -- Disc builder (Holy gebruikt op Shift+C defensive)
	["Shadow Word: Pain"] = { category = "main_rotation", priority = 3 }, -- Disc 3 / Shadow 1
	["Power Word: Radiance"] = { category = "spender", priority = 1 },
	["Shadow Word: Death"] = { category = "spender", priority = 2 },
	["Mind Blast"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2" }, -- Disc Shift+2 (Shadow zet op 3)
	["Evangelism"] = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Mind Control"] = { role = "utility_secondary", priority = 1 }, -- E: geen interrupt (Disc/Holy)
	["Fade"] = { role = "utility_primary", priority = 1 },
	["Desperate Prayer"] = { role = "defensive_1", priority = 1 },
	["Power Word: Barrier"] = { role = "defensive_3", priority = 1 },
	["Pain Suppression"] = { category = "defensive", priority = 4 },
	["Psychic Scream"] = { category = "dispel_cc", priority = 1 },
	["Purify"] = { category = "dispel_cc", priority = 2 },
	["Rapture"] = { role = "cooldown_bar", priority = 1 },
	["Ultimate Penitence"] = { category = "cooldown", priority = 2 },
	["Shadowfiend"] = { role = "utility_secondary", priority = 1 }, -- Disc F (Shadow deelt F met Mindbender)
	["Power Infusion"] = { category = "utility", priority = 2 }, -- R: geen movement -> utility
	["Mass Dispel"] = { category = "utility", priority = 3 },
	["Leap of Faith"] = { category = "utility", priority = 4 },
	["Shackle Horror"] = { category = "dispel_cc", priority = 1 }, -- Disc F2 / Shadow Shift+V (dispel/CC)

	-- Holy
	["Flash Heal"] = { category = "main_rotation", priority = 1 },
	["Smite"] = { category = "main_rotation", priority = 2 },
	["Prayer of Mending"] = { category = "main_rotation", priority = 3 },
	["Holy Word: Serenity"] = { category = "spender", priority = 1 },
	["Holy Word: Sanctify"] = { category = "spender", priority = 2 },
	["Prayer of Healing"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3" },
	["Renew"] = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Guardian Spirit"] = { role = "defensive_3", priority = 1 },
	["Apotheosis"] = { role = "cooldown_bar", priority = 1 },
	["Divine Hymn"] = { category = "cooldown", priority = 2 },
	["Holy Word: Chastise"] = { role = "utility_secondary", priority = 1 },
	["Power Word: Life"] = { role = "heal_quick", priority = 1 }, -- Holy F2 (heal-anker)
	["Symbol of Hope"] = { role = "heal_ooc", priority = 1 }, -- Holy F3 (heal-anker)

	-- Shadow
	["Vampiric Touch"] = { category = "main_rotation", priority = 2 },
	["Shadow Word: Madness"] = { category = "spender", priority = 1 },
	["Void Bolt"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3" }, -- Shift+3 tweeling
	["Void Volley"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3" },
	["Mind Flay"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Silence"] = { role = "interrupt", priority = 1 },
	["Dispersion"] = { role = "defensive_3", priority = 1 },
	["Voidform"] = { role = "cooldown_bar", priority = 1 },
	["Void Torrent"] = { category = "cooldown", priority = 2 },
	["Mindbender"] = { role = "utility_secondary", priority = 1 }, -- Shadow F (alternatief voor Shadowfiend)
}

-- =====================================================================
-- WARLOCK (Affliction / Demonology / Destruction)
-- =====================================================================
ns.KeybindRoleClassifier.WARLOCK = {
	-- Gedeelde ankers (alle specs)
	["Spell Lock"] = { role = "interrupt", priority = 1 }, -- pet-interrupt (Affli/Destro)
	["Axe Toss"] = { role = "interrupt", priority = 1 }, -- pet-interrupt (Demo)
	["Burning Rush"] = { role = "utility_primary", priority = 1 },
	["Demonic Circle: Teleport"] = { role = "utility_primary", priority = 2 }, -- Shift+Q
	["Drain Life"] = { role = "defensive_1", priority = 1 },
	["Dark Pact"] = { category = "defensive", priority = 3 }, -- Shift+Z
	["Unending Resolve"] = { role = "defensive_3", priority = 1 },
	["Fear"] = { category = "dispel_cc", priority = 1 },
	["Mortal Coil"] = { category = "dispel_cc", priority = 2 }, -- Shift+V (Affli/Demo)
	["Healthstone"] = { role = "utility_secondary", priority = 1 },
	["Banish"] = { category = "utility", priority = 2 }, -- R: geen movement -> utility
	["Demonic Gateway"] = { category = "utility", priority = 4 },
	["Soulstone"] = { role = "heal_quick", priority = 1 }, -- F2

	-- Affliction
	["Agony"] = { category = "main_rotation", priority = 1 },
	["Unstable Affliction"] = { category = "main_rotation", priority = 2 },
	["Haunt"] = { category = "main_rotation", priority = 3 },
	["Malefic Grasp"] = { category = "spender", priority = 1 },
	["Drain Soul"] = { category = "spender", priority = 2 },
	["Seed of Corruption"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Corruption"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2" },
	["Wither"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2" }, -- Affli Shift+2 / Destro 2 (Hellcaller-variant)
	["Dark Harvest"] = { category = "spender", priority = 7, bindKey = "Shift+5" },
	["Summon Darkglare"] = { role = "cooldown_bar", priority = 1 },
	["Malevolence"] = { category = "cooldown", priority = 2 }, -- Shift+F1 (Affli/Destro)
	["Howl of Terror"] = { category = "utility", priority = 3 }, -- Affli T

	-- Demonology
	["Shadow Bolt"] = { category = "main_rotation", priority = 1 },
	["Demonbolt"] = { category = "main_rotation", priority = 2 },
	["Call Dreadstalkers"] = { category = "main_rotation", priority = 3 },
	["Hand of Gul'dan"] = { category = "spender", priority = 1 },
	["Summon Vilefiend"] = { category = "spender", priority = 2 },
	["Implosion"] = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Power Siphon"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3" },
	["Summon Demonic Tyrant"] = { role = "cooldown_bar", priority = 1 },
	["Doom"] = { category = "utility", priority = 3 }, -- Demo T

	-- Destruction
	["Incinerate"] = { category = "main_rotation", priority = 1 },
	["Immolate"] = { category = "main_rotation", priority = 2 },
	["Conflagrate"] = { category = "main_rotation", priority = 3 },
	["Chaos Bolt"] = { category = "spender", priority = 1 },
	["Shadowburn"] = { category = "spender", priority = 2 },
	["Rain of Fire"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Havoc"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2" },
	["Soulfire"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3" },
	["Summon Infernal"] = { role = "cooldown_bar", priority = 1 },
	["Diabolic Ritual"] = { category = "utility", priority = 3 }, -- Destro T
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
	["Mirror Image"] = { role = "heal_quick", priority = 1 }, -- F2

	-- Arcane
	["Arcane Blast"] = { category = "main_rotation", priority = 1 },
	["Arcane Orb"] = { category = "main_rotation", priority = 2 },
	["Arcane Missiles"] = { category = "main_rotation", priority = 3 },
	["Arcane Barrage"] = { category = "spender", priority = 1 },
	["Arcane Explosion"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Arcane Pulse"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2" },
	["Prismatic Barrier"] = { role = "defensive_1", priority = 1 },
	["Arcane Surge"] = { role = "cooldown_bar", priority = 1 },
	["Touch of the Magi"] = { category = "cooldown", priority = 2 },
	["Presence of Mind"] = { category = "utility", priority = 2 }, -- Arcane R: geen movement -> utility
	["Evocation"] = { category = "utility", priority = 3 }, -- Arcane T

	-- Fire
	["Fireball"] = { category = "main_rotation", priority = 1 },
	["Fire Blast"] = { category = "main_rotation", priority = 2 },
	["Scorch"] = { category = "main_rotation", priority = 3 },
	["Pyroblast"] = { category = "spender", priority = 1 },
	["Flamestrike"] = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Blazing Barrier"] = { role = "defensive_1", priority = 1 },
	["Cauterize"] = { category = "defensive", priority = 4 }, -- Fire Shift+C
	["Combustion"] = { role = "cooldown_bar", priority = 1 },
	["Meteor"] = { category = "cooldown", priority = 2 },
	["Time Warp"] = { category = "utility", priority = 2 }, -- Fire R: geen movement -> utility
}
