local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

--[[
	Naam->rol-classifier voor Hunter, Paladin, Shaman (v6-keybind-standaard).
	Bron 1: docs/KEYBIND_MAP_DRAFT_hunter_paladin_shaman.md (MM/SV Hunter, Holy/Prot Paladin,
	        Ele/Resto Shaman).
	Bron 2: Modules/KeybindingData.lua spellByUiKey-blokken (hunter_early, hunter_beast_mastery,
	        paladin_early, paladin_retribution, enh_shaman, ele_shaman) - in-game bevestigd.
	Gekeyd op de exacte spell-NAAM; de addon matcht dit tegen de live spellbook. Toets->entry
	volgens de v6-conversietabel. Alle specs van een class in EEN tabel; namen zijn vrijwel uniek
	per spec, dus prioriteiten botsen niet. Bij dubbele naam met andere rol: meest voorkomende
	slot + comment. Overgeslagen: Shift+E (racial), Ctrl+F1 (trinket), Alt+C (potion) en zuivere
	passieve talents.
]]

ns.KeybindRoleClassifier.HUNTER = {
	-- Marksmanship (draft)
	["Aimed Shot"] = { category = "main_rotation", priority = 1, specs = { 254 } },
	["Rapid Fire"] = { category = "main_rotation", priority = 2, specs = { 254 } },
	["Wailing Arrow"] = { category = "main_rotation", priority = 3, specs = { 254 } },
	["Arcane Shot"] = { category = "spender", priority = 1, specs = { 254 } },
	["Black Arrow"] = { category = "spender", priority = 2, specs = { 254 } },
	["Multi-Shot"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 254 } },
	["Volley"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 254 } },
	["Explosive Shot"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 254 } },
	["Counter Shot"] = { role = "interrupt", priority = 1, specs = { 254, 253 } }, -- MM E + BM E (interrupt); SV heeft Muzzle
	["Disengage"] = { role = "utility_primary", priority = 1 }, -- MM Q (movement); SV Shift+Q; BM Z (baseline, alle 3)
	["Exhilaration"] = { role = "heal_quick", priority = 1 }, -- F2 heal-anker: dedicated self+pet quick heal, baseline (MM/SV/BM)
	["Aspect of the Turtle"] = { role = "defensive_3", priority = 1 }, -- baseline (MM/SV/BM)
	["Tranquilizing Shot"] = { category = "dispel_cc", priority = 1, specs = { 254 } },
	["Trueshot"] = { role = "cooldown_bar", priority = 1, specs = { 254 } },
	["Kill Shot"] = { role = "utility_secondary", priority = 1, specs = { 254 } },
	["Hunter's Mark"] = { category = "utility", priority = 2, specs = { 254 } }, -- MM R (marker, geen movement)

	-- Survival (draft)
	["Kill Command"] = { category = "main_rotation", priority = 1, specs = { 255 } },
	["Raptor Strike"] = { category = "main_rotation", priority = 2, specs = { 255 } },
	["Wildfire Bomb"] = { category = "main_rotation", priority = 3, specs = { 255 } },
	["Boomstick"] = { category = "spender", priority = 1, specs = { 255 } },
	["Flamefang Pitch"] = { category = "spender", priority = 2, specs = { 255 } },
	["Raptor Swipe"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 255 } },
	["Muzzle"] = { role = "interrupt", priority = 1, specs = { 255 } },
	["Harpoon"] = { role = "mobility", priority = 1, specs = { 255 } }, -- SV Q (engage/pull)
	["Survival of the Fittest"] = { category = "defensive", priority = 4, specs = { 255, 253 } }, -- SV Shift+C; BM R (zie comment)
	["Wing Clip"] = { category = "dispel_cc", priority = 1, specs = { 255 } },
	["Takedown"] = { role = "cooldown_bar", priority = 1, specs = { 255 } },
	["Howl of the Pack Leader"] = { role = "utility_secondary", priority = 1, specs = { 255 } },

	-- Beast Mastery (KeybindingData, in-game bevestigd)
	["Barbed Shot"] = { category = "main_rotation", priority = 2, specs = { 253 } },
	["Cobra Shot"] = { category = "main_rotation", priority = 3, specs = { 253 } },
	["Bestial Wrath"] = { category = "spender", priority = 1, specs = { 253 } },
	["Feign Death"] = { category = "utility", priority = 4 }, -- BM/early X; class-baseline (alle hunters)
	["Freezing Trap"] = { role = "utility_secondary", priority = 1, specs = { 253 } }, -- BM F
	["Mend Pet"] = { role = "cooldown_bar", priority = 1 }, -- BM/early F1; class-baseline (pet-heal, alle hunters)

	-- Hunter level 1-10 (KeybindingData) - alleen unieke namen
	["Steady Shot"] = { category = "main_rotation", priority = 1 }, -- early 1; class-baseline (generieke builder)
	-- early: E=Hunter's Mark (1130), X=Feign Death (5384), 2=Arcane Shot (185358),
	-- R=Revive Pet (982, spellbook-only), Z=Disengage (781), C=Aspect of the Turtle,
	-- V=Exhilaration, F=Wing Clip, F1=Mend Pet -> allemaal al hierboven, geen dubbele entries.
}

ns.KeybindRoleClassifier.PALADIN = {
	-- Holy (draft)
	["Holy Shock"] = { category = "main_rotation", priority = 1, specs = { 65 } },
	["Flash of Light"] = { category = "main_rotation", priority = 2, specs = { 65 } },
	["Holy Light"] = { category = "main_rotation", priority = 3, specs = { 65 } },
	["Word of Glory"] = { role = "heal_quick", priority = 1, specs = { 65, 66, 70 } }, -- F2 heal-anker: instant self-heal (persoonlijke noodheal), baseline alle Paladin-specs
	["Light of Dawn"] = { category = "spender", priority = 2, specs = { 65 } },
	["Rebuke"] = { role = "interrupt", priority = 1, specs = { 65, 66 } }, -- Holy/Prot E; Ret E = Hammer of Wrath
	["Divine Shield"] = { role = "defensive_1", priority = 1 }, -- baseline (Holy/Prot/Ret)
	["Guardian of Ancient Kings"] = { role = "defensive_3", priority = 1, specs = { 65, 66 } }, -- Holy/Prot C; Ret C = Shield of Vengeance
	["Cleanse"] = { category = "dispel_cc", priority = 1 }, -- baseline (class-wide dispel; Holy/Prot V, Ret bindt V op Freedom maar heeft Cleanse)
	["Avenging Wrath"] = { role = "cooldown_bar", priority = 1, specs = { 65, 66 } }, -- Holy/Prot F1; Ret F1 = Hammer of Justice
	["Aura Mastery"] = { category = "cooldown", priority = 2, specs = { 65 } }, -- Holy Shift+F1
	["Blessing of Protection"] = { role = "utility_secondary", priority = 1, specs = { 65, 66 } }, -- Holy F; Prot X
	["Divine Toll"] = { category = "utility", priority = 2, specs = { 65, 66 } }, -- Holy R; Prot Shift+F1 (Ret C = Shield of Vengeance, geen Divine Toll)

	-- Protection (draft)
	["Judgment"] = { category = "main_rotation", priority = 1, specs = { 66, 70 } }, -- Prot 1; Ret 2 (zelfde ID)
	["Avenger's Shield"] = { category = "main_rotation", priority = 2, specs = { 66 } },
	["Hammer of the Righteous"] = { category = "main_rotation", priority = 3, specs = { 66 } },
	["Blessed Hammer"] = { category = "main_rotation", priority = 3, specs = { 66 } }, -- talent-alternatief voor Hammer of the Righteous
	["Shield of the Righteous"] = { category = "spender", priority = 1, specs = { 66 } },
	["Hammer of Wrath"] = { category = "spender", priority = 2, specs = { 66, 70 } }, -- Prot 5; Ret E
	["Consecration"] = { role = "utility_secondary", priority = 1, specs = { 66 } }, -- Prot F
	["Hand of Reckoning"] = { category = "utility", priority = 2, specs = { 66 } }, -- Prot R (taunt, geen movement)

	-- Retribution (KeybindingData, in-game bevestigd)
	["Crusader Strike"] = { category = "main_rotation", priority = 1, specs = { 70 } }, -- Ret/early 1 (Holy verliest CS in Midnight)
	["Blade of Justice"] = { category = "main_rotation", priority = 3, specs = { 70 } }, -- Ret 3
	["Templar's Verdict"] = { category = "spender", priority = 1, specs = { 70 } }, -- Ret 4
	["Wake of Ashes"] = { role = "utility_primary", priority = 1, specs = { 70 } }, -- Ret Q
	["Divine Storm"] = { role = "utility_secondary", priority = 1, specs = { 70 } }, -- Ret F
	["Blessing of Freedom"] = { category = "dispel_cc", priority = 1 }, -- baseline (class-wide utility; alleen op Ret V/early gebonden)
	["Divine Steed"] = { category = "utility", priority = 2 }, -- baseline (class-wide movement; Ret/early R)
	["Hammer of Justice"] = { role = "cooldown_bar", priority = 1 }, -- baseline (class-wide stun; alleen op Ret F1 gebonden)

	-- Paladin level 1-10 (KeybindingData) - unieke namen
	["Blessing of Sacrifice"] = { category = "dispel_cc", priority = 1 }, -- baseline (class-wide utility; early V=6940)
	-- early: E=Flash of Light, F=Hammer of Justice, X=Turn Evil(10326, spellbook-only),
	-- Z=Divine Shield, C=Blessing of Freedom, Q=Hand of Reckoning -> al hierboven.
}

ns.KeybindRoleClassifier.SHAMAN = {
	-- Elemental (KeybindingData live is leidend + draft-aanvullingen)
	["Lava Burst"] = { category = "main_rotation", priority = 1, specs = { 262 } },
	["Voltaic Blaze"] = { category = "main_rotation", priority = 2, specs = { 262, 263 } }, -- Ele 2 + Enh 3
	["Lightning Bolt"] = { category = "main_rotation", priority = 3, specs = { 262, 263 } }, -- Ele 3; Enh 4
	["Earth Shock"] = { category = "main_rotation", priority = 3, specs = { 262 } }, -- Ele-draft 3 (Maelstrom-dump)
	["Elemental Blast"] = { category = "spender", priority = 1, specs = { 262, 263 } }, -- Ele/Enh 4-5
	["Flame Shock"] = { category = "spender", priority = 2, specs = { 262 } }, -- Ele-draft 5 (Enh cast via Voltaic Blaze)
	["Chain Lightning"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 262, 263 } }, -- Ele Shift+1; Enh Shift+4
	["Earthquake"] = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 262 } },
	["Thunderstorm"] = { category = "utility", priority = 4, specs = { 262 } }, -- Ele X
	["Gust of Wind"] = { role = "utility_primary", priority = 1 }, -- baseline (class-movement, Ele Q)
	["Spiritwalker's Grace"] = { role = "utility_secondary", priority = 1 }, -- baseline (class-utility, Ele F)
	["Skyfury"] = { category = "utility", priority = 2 }, -- baseline (class-raidbuff, Ele R)
	["Nature's Swiftness"] = { category = "utility", priority = 5 }, -- baseline (class-utility, Ele Shift+R)
	["Earth Elemental"] = { category = "defensive", priority = 4 }, -- baseline (class-defensive, Ele Shift+C)
	["Cleanse Spirit"] = { category = "dispel_cc", priority = 2, specs = { 262 } }, -- Ele Shift+V (Resto = Purify Spirit)
	["Stormkeeper"] = { role = "cooldown_bar", priority = 1, specs = { 262, 263 } }, -- Ele F1 (live); Enh Shift+F1/R
	["Lightning Lasso"] = { role = "utility_secondary", priority = 1, specs = { 262 } }, -- Ele-draft F
	["Fire Elemental"] = { role = "cooldown_bar", priority = 1, specs = { 262 } }, -- Ele-draft F1

	-- Enhancement (KeybindingData, in-game bevestigd)
	["Stormstrike"] = { category = "main_rotation", priority = 1, specs = { 263 } },
	["Lava Lash"] = { category = "main_rotation", priority = 2, specs = { 263 } },
	["Crash Lightning"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 263 } },
	["Sundering"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 263 } },
	["Frost Shock"] = { role = "utility_secondary", priority = 1, specs = { 263 } }, -- Enh F (ranged slow)
	["Wind Rush Totem"] = { category = "utility", priority = 3, specs = { 263 } }, -- Enh Shift+T (T-slot = utility)
	["Feral Spirit"] = { role = "cooldown_bar", priority = 1, specs = { 263 } }, -- Enh F1
	["Doom Winds"] = { category = "cooldown", priority = 3, specs = { 263 } }, -- Enh Shift+F1
	["Ascendance"] = { category = "cooldown", priority = 3, specs = { 262, 263 } }, -- Enh/Ele Alt+F1
	["Primordial Wave"] = { category = "utility", priority = 5, specs = { 263 } }, -- Enh Shift+R
	["Bloodlust"] = { category = "cooldown", priority = 4 }, -- baseline (class-haste; Horde; Alliance = Heroism)
	["Heroism"] = { category = "cooldown", priority = 4 }, -- baseline (Alliance-variant van Bloodlust)

	-- Gedeelde class-utility (Enh/Ele/Resto - 1 entry per naam)
	["Wind Shear"] = { role = "interrupt", priority = 1 },
	["Spirit Walk"] = { role = "utility_primary", priority = 1 }, -- Q (movement)
	["Ghost Wolf"] = { role = "utility_primary", priority = 2 }, -- Shift+Q (travel)
	["Astral Shift"] = { role = "defensive_3", priority = 1 }, -- C (grote def)
	["Hex"] = { category = "dispel_cc", priority = 1 }, -- V (CC)
	["Purge"] = { category = "dispel_cc", priority = 1 }, -- Ele V / Enh Shift+V (enemy dispel)
	["Capacitor Totem"] = { category = "utility", priority = 3 }, -- T (AoE stun)
	["Tremor Totem"] = { category = "utility", priority = 4 }, -- Enh/Ele-draft X
	["Healing Surge"] = { role = "heal_quick", priority = 1 }, -- F2 (heal-anker)

	-- Restoration (draft; healer - heal-spells volgen de v6-tabel op hun draft-toets)
	["Riptide"] = { category = "main_rotation", priority = 1, specs = { 264 } },
	["Chain Heal"] = { category = "main_rotation", priority = 2, specs = { 264 } },
	["Healing Wave"] = { category = "main_rotation", priority = 3, specs = { 264 } },
	["Unleash Life"] = { category = "spender", priority = 1, specs = { 264 } },
	["Healing Rain"] = { category = "spender", priority = 2, specs = { 264 } },
	["Purify Spirit"] = { category = "dispel_cc", priority = 1, specs = { 264 } }, -- Resto V
	["Healing Tide Totem"] = { role = "cooldown_bar", priority = 1, specs = { 264 } }, -- Resto F1
	["Healing Stream Totem"] = { role = "utility_secondary", priority = 1, specs = { 264 } }, -- Resto F
	["Spirit Link Totem"] = { category = "utility", priority = 2, specs = { 264 } }, -- Resto R (raid-CD, geen movement -> utility)
	["Ancestral Spirit"] = { category = "utility", priority = 3 }, -- baseline (class-wide out-of-combat rez; Resto T)
}
