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
	["Aimed Shot"] = { category = "main_rotation", priority = 1 },
	["Rapid Fire"] = { category = "main_rotation", priority = 2 },
	["Wailing Arrow"] = { category = "main_rotation", priority = 3 },
	["Arcane Shot"] = { category = "spender", priority = 1 },
	["Black Arrow"] = { category = "spender", priority = 2 },
	["Multi-Shot"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Volley"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2" },
	["Explosive Shot"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3" },
	["Counter Shot"] = { role = "interrupt", priority = 1 },
	["Disengage"] = { role = "utility_primary", priority = 1 }, -- MM Q (movement); SV Shift+Q (zelfde naam)
	["Exhilaration"] = { role = "defensive_1", priority = 1 },
	["Aspect of the Turtle"] = { role = "defensive_3", priority = 1 },
	["Tranquilizing Shot"] = { category = "dispel_cc", priority = 1 },
	["Trueshot"] = { role = "cooldown_bar", priority = 1 },
	["Kill Shot"] = { role = "utility_secondary", priority = 1 },
	["Hunter's Mark"] = { category = "utility", priority = 2 }, -- MM R (marker, geen movement)

	-- Survival (draft)
	["Kill Command"] = { category = "main_rotation", priority = 1 },
	["Raptor Strike"] = { category = "main_rotation", priority = 2 },
	["Wildfire Bomb"] = { category = "main_rotation", priority = 3 },
	["Boomstick"] = { category = "spender", priority = 1 },
	["Flamefang Pitch"] = { category = "spender", priority = 2 },
	["Raptor Swipe"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2" },
	["Muzzle"] = { role = "interrupt", priority = 1 },
	["Harpoon"] = { role = "mobility", priority = 1 }, -- SV Q (engage/pull)
	["Survival of the Fittest"] = { category = "defensive", priority = 4 }, -- SV Shift+C; BM R (zie comment)
	["Wing Clip"] = { category = "dispel_cc", priority = 1 },
	["Takedown"] = { role = "cooldown_bar", priority = 1 },
	["Howl of the Pack Leader"] = { role = "utility_secondary", priority = 1 },

	-- Beast Mastery (KeybindingData, in-game bevestigd)
	["Barbed Shot"] = { category = "main_rotation", priority = 2 },
	["Cobra Shot"] = { category = "main_rotation", priority = 3 },
	["Bestial Wrath"] = { category = "spender", priority = 1 },
	["Feign Death"] = { category = "utility", priority = 4 }, -- BM/early X
	["Freezing Trap"] = { role = "utility_secondary", priority = 1 }, -- BM F
	["Mend Pet"] = { role = "cooldown_bar", priority = 1 }, -- BM/early F1 (PetCare op cooldown-slot)

	-- Hunter level 1-10 (KeybindingData) - alleen unieke namen
	["Steady Shot"] = { category = "main_rotation", priority = 1 }, -- early 1
	-- early: E=Hunter's Mark (1130), X=Feign Death (5384), 2=Arcane Shot (185358),
	-- R=Revive Pet (982, spellbook-only), Z=Disengage (781), C=Aspect of the Turtle,
	-- V=Exhilaration, F=Wing Clip, F1=Mend Pet -> allemaal al hierboven, geen dubbele entries.
}

ns.KeybindRoleClassifier.PALADIN = {
	-- Holy (draft)
	["Holy Shock"] = { category = "main_rotation", priority = 1 },
	["Flash of Light"] = { category = "main_rotation", priority = 2 },
	["Holy Light"] = { category = "main_rotation", priority = 3 },
	["Word of Glory"] = { category = "spender", priority = 1 }, -- Holy 4; Ret X (zie comment)
	["Light of Dawn"] = { category = "spender", priority = 2 },
	["Rebuke"] = { role = "interrupt", priority = 1 },
	["Divine Shield"] = { role = "defensive_1", priority = 1 },
	["Guardian of Ancient Kings"] = { role = "defensive_3", priority = 1 },
	["Cleanse"] = { category = "dispel_cc", priority = 1 },
	["Avenging Wrath"] = { role = "cooldown_bar", priority = 1 },
	["Aura Mastery"] = { category = "cooldown", priority = 2 }, -- Holy Shift+F1
	["Blessing of Protection"] = { role = "utility_secondary", priority = 1 }, -- Holy F; Prot X (utility, zie comment)
	["Divine Toll"] = { category = "utility", priority = 2 }, -- Holy R (utility); ook Prot Shift+F1 + Ret C, meest voorkomend = utility

	-- Protection (draft)
	["Judgment"] = { category = "main_rotation", priority = 1 }, -- Prot 1; Ret 2 (main_rotation, geen conflict)
	["Avenger's Shield"] = { category = "main_rotation", priority = 2 },
	["Hammer of the Righteous"] = { category = "main_rotation", priority = 3 },
	["Blessed Hammer"] = { category = "main_rotation", priority = 3 }, -- talent-alternatief voor Hammer of the Righteous
	["Shield of the Righteous"] = { category = "spender", priority = 1 },
	["Hammer of Wrath"] = { category = "spender", priority = 2 }, -- Prot 5; Ret E (zie comment)
	["Consecration"] = { role = "utility_secondary", priority = 1 }, -- Prot F
	["Hand of Reckoning"] = { category = "utility", priority = 2 }, -- Prot R (taunt, geen movement)

	-- Retribution (KeybindingData, in-game bevestigd)
	["Crusader Strike"] = { category = "main_rotation", priority = 1 }, -- Ret/early 1
	["Blade of Justice"] = { category = "main_rotation", priority = 3 }, -- Ret 3
	["Templar's Verdict"] = { category = "spender", priority = 1 }, -- Ret 4
	["Wake of Ashes"] = { role = "utility_primary", priority = 1 }, -- Ret Q
	["Divine Storm"] = { role = "utility_secondary", priority = 1 }, -- Ret F
	["Blessing of Freedom"] = { category = "dispel_cc", priority = 1 }, -- Ret/early V
	["Divine Steed"] = { category = "utility", priority = 2 }, -- Ret/early R (movement-talent, R->utility want geen mobility-slot in v6-tabel)
	["Hammer of Justice"] = { role = "cooldown_bar", priority = 1 }, -- Ret F1

	-- Paladin level 1-10 (KeybindingData) - unieke namen
	["Blessing of Sacrifice"] = { category = "dispel_cc", priority = 1 }, -- early V=6940
	-- early: E=Flash of Light, F=Hammer of Justice, X=Turn Evil(10326, spellbook-only),
	-- Z=Divine Shield, C=Blessing of Freedom, Q=Hand of Reckoning -> al hierboven.
}

ns.KeybindRoleClassifier.SHAMAN = {
	-- Elemental (KeybindingData live is leidend + draft-aanvullingen)
	["Lava Burst"] = { category = "main_rotation", priority = 1 },
	["Voltaic Blaze"] = { category = "main_rotation", priority = 2 },
	["Lightning Bolt"] = { category = "main_rotation", priority = 3 }, -- Ele 3 (filler/builder); Enh 4 (zie comment)
	["Earth Shock"] = { category = "main_rotation", priority = 3 }, -- Ele-draft 3 (Maelstrom-dump)
	["Elemental Blast"] = { category = "spender", priority = 1 }, -- Ele/Enh 4
	["Flame Shock"] = { category = "spender", priority = 2 }, -- Ele-draft 5
	["Chain Lightning"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Earthquake"] = { category = "spender", priority = 7, bindKey = "Shift+4" },
	["Thunderstorm"] = { category = "utility", priority = 4 }, -- Ele X
	["Gust of Wind"] = { role = "utility_primary", priority = 1 }, -- Ele Q (movement)
	["Spiritwalker's Grace"] = { role = "utility_secondary", priority = 1 }, -- Ele F
	["Skyfury"] = { category = "utility", priority = 2 }, -- Ele R (raid-buff, geen movement)
	["Nature's Swiftness"] = { category = "utility", priority = 5 }, -- Ele Shift+R
	["Earth Elemental"] = { category = "defensive", priority = 4 }, -- Ele Shift+C
	["Cleanse Spirit"] = { category = "dispel_cc", priority = 2 }, -- Ele Shift+V
	["Stormkeeper"] = { role = "cooldown_bar", priority = 1 }, -- Ele F1 (live); Enh-draft Shift+F1
	["Lightning Lasso"] = { role = "utility_secondary", priority = 1 }, -- Ele-draft F
	["Fire Elemental"] = { role = "cooldown_bar", priority = 1 }, -- Ele-draft F1

	-- Enhancement (KeybindingData, in-game bevestigd)
	["Stormstrike"] = { category = "main_rotation", priority = 1 },
	["Lava Lash"] = { category = "main_rotation", priority = 2 },
	["Crash Lightning"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1" },
	["Sundering"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2" },
	["Frost Shock"] = { role = "utility_secondary", priority = 1 }, -- Enh F (ranged slow)
	["Wind Rush Totem"] = { category = "utility", priority = 3 }, -- Enh Shift+T (T-slot = utility)
	["Feral Spirit"] = { role = "cooldown_bar", priority = 1 }, -- Enh F1
	["Doom Winds"] = { category = "cooldown", priority = 3 }, -- Enh Shift+F1
	["Ascendance"] = { category = "cooldown", priority = 3 }, -- Enh/Ele Alt+F1
	["Primordial Wave"] = { category = "utility", priority = 5 }, -- Enh Shift+R
	["Bloodlust"] = { category = "cooldown", priority = 4 }, -- Enh/Ele Shift+F2 (Horde; Alliance = Heroism)
	["Heroism"] = { category = "cooldown", priority = 4 }, -- Alliance-variant van Bloodlust, zelfde slot

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
	["Riptide"] = { category = "main_rotation", priority = 1 },
	["Chain Heal"] = { category = "main_rotation", priority = 2 },
	["Healing Wave"] = { category = "main_rotation", priority = 3 },
	["Unleash Life"] = { category = "spender", priority = 1 },
	["Healing Rain"] = { category = "spender", priority = 2 },
	["Purify Spirit"] = { category = "dispel_cc", priority = 1 }, -- Resto V
	["Healing Tide Totem"] = { role = "cooldown_bar", priority = 1 }, -- Resto F1
	["Healing Stream Totem"] = { role = "utility_secondary", priority = 1 }, -- Resto F
	["Spirit Link Totem"] = { category = "utility", priority = 2 }, -- Resto R (raid-CD, geen movement -> utility)
	["Ancestral Spirit"] = { category = "utility", priority = 3 }, -- Resto T (out-of-combat rez)
}
