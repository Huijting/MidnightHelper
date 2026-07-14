local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

--[[
	Naam->rol-classifier voor HUNTER (WoW Midnight, v6-keybind-standaard).
	VERVANGT de oude incomplete draft (was gedeeld in KeybindRoles_HunterPaladinShaman.lua).
	Doel: ELKE relevante actieve spell per spec dekken.

	Rollen zijn AFGELEID uit addon-data (never-lie); geen ID's/rollen verzonnen. Bronnen:
	  - JustAC/Data/InterruptAbilities.lua : Counter Shot (147362, BM/MM), Muzzle (187707, SV),
	    Intimidation (24394), Wailing Arrow (silence-variant).
	  - JustAC/Data/SpellCategories.lua : defensives (Aspect of the Turtle 186265, Exhilaration
	    109304, Survival of the Fittest 264735, Roar of Sacrifice 53480); healing (Mend Pet 136,
	    Exhilaration); CC (Freezing Trap 187650, Binding Shot 117405, Scatter Shot 213691,
	    Concussive Shot 5116, Bursting Shot 186387, Wyvern Sting 19386, Scare Beast 1513,
	    Steel Trap 162488); utility (Disengage 781, Aspect of the Cheetah 186257,
	    Tranquilizing Shot 19801, Misdirection 34477, Feign Death via SpellDB).
	  - JustAC/SpellDB.lua : grote CD per spec -- BM Bestial Wrath (19574) + Call of the Wild
	    (359844) + Bloodshed (321530); MM Trueshot (288613) + Volley (260243); SV Coordinated
	    Assault (360952) + Fury of the Eagle (203415). Gap-closer Harpoon (190925, SV).
	    Pet-heals: Mend Pet (136), Exhilaration (109304). Kill Shot execute (53351 BM/MM,
	    320976 SV).
	  - JustAC/Data/SpellArchetypes.lua : builder/spender + aoe-archetypes (Multi-Shot 2643,
	    Volley 260247, Explosive Shot, Boomstick 1261215, Raptor Swipe, Flamefang Pitch,
	    Takedown, Wildfire Bomb/Cluster).
	  - docs/KEYBIND_MAP_DRAFT_hunter_paladin_shaman.md : MM/SV rotatie-toewijzing + v6-ankers
	    (E=interrupt, Q=movement, Z/C=def, F1=grote CD, F2=heal-anker).

	Vocab (exact):
	  role : interrupt, utility_primary, utility_secondary, mobility, defensive_1..4,
	         cooldown_bar, heal_quick, heal_ooc
	  category : main_rotation, spender, utility, dispel_cc, cooldown, defensive

	Regels:
	  - Key = EXACTE Engelse spell-naam (addon matcht tegen live spellbook).
	  - specs = { <specID> } maakt de entry spec-specifiek; ontbreekt specs => baseline (alle 3).
	    specID's: Beast Mastery 253, Marksmanship 254, Survival 255.
	  - Counter Shot = {253,254}; Survival gebruikt Muzzle {255}.
	  - Baseline (geen specs): Disengage, Exhilaration, Aspect of the Turtle, Mend Pet,
	    Aspect of the Cheetah, Feign Death, Misdirection, Hunter's Mark, Concussive Shot,
	    Tranquilizing Shot, Intimidation, Binding Shot, Freezing Trap, Scatter Shot,
	    Bursting Shot, Scare Beast, Survival of the Fittest, Roar of Sacrifice, Kill Shot.
	  - NIET opgenomen: Recuperate (globale F4), heal_sustain/F4, racials, trinket, potion,
	    passieve talents, pet-summon/revive.
]]

ns.KeybindRoleClassifier.HUNTER = {
	--==================================================================================
	-- INTERRUPT (E)
	--==================================================================================
	["Counter Shot"] = { role = "interrupt", priority = 1, specs = { 253, 254 } }, -- BM/MM kick (147362); SV = Muzzle
	["Muzzle"] = { role = "interrupt", priority = 1, specs = { 255 } }, -- SV kick (187707)

	--==================================================================================
	-- MOVEMENT (Q)
	--==================================================================================
	["Disengage"] = { role = "utility_primary", priority = 1 }, -- baseline retreat (781); alle 3 specs
	["Harpoon"] = { role = "mobility", priority = 1, specs = { 255 } }, -- SV engage/gap-closer (190925)
	["Aspect of the Cheetah"] = { role = "utility_primary", priority = 2 }, -- baseline sprint/movement (186257); movement -> utility_primary

	--==================================================================================
	-- DEFENSIVES
	--==================================================================================
	["Exhilaration"] = { role = "heal_quick", priority = 1 }, -- F2 heal-anker: self+pet quick heal (109304), baseline
	["Survival of the Fittest"] = { role = "defensive_1", priority = 1 }, -- kleine def, 30% DR (264735), baseline (talent)
	["Aspect of the Turtle"] = { role = "defensive_3", priority = 1 }, -- grote def, immune (186265), baseline
	["Roar of Sacrifice"] = { category = "defensive", priority = 2 }, -- externe pet-def (53480), baseline (talent)
	["Feign Death"] = { category = "utility", priority = 4 }, -- baseline threat-drop (5384)

	--==================================================================================
	-- DISPEL / CC (V + overflow)
	--==================================================================================
	["Tranquilizing Shot"] = { category = "dispel_cc", priority = 1 }, -- enrage/magic dispel (19801), baseline
	["Freezing Trap"] = { category = "dispel_cc", priority = 2 }, -- incapacitate (187650), baseline
	["Binding Shot"] = { category = "dispel_cc", priority = 3 }, -- root/stun (117405), baseline (talent)
	["Intimidation"] = { category = "dispel_cc", priority = 3, alsoStop = "stun" }, -- pet-stun; JustAC InterruptAbilities [24394] cc mech=12 → Spec 08 alsoStop
	["Scatter Shot"] = { category = "dispel_cc", priority = 4 }, -- disorient (213691), baseline (talent)
	["Concussive Shot"] = { category = "dispel_cc", priority = 4 }, -- slow (5116), baseline
	["Bursting Shot"] = { category = "dispel_cc", priority = 5 }, -- disorient/knockback (186387), MM/baseline
	["Wyvern Sting"] = { category = "dispel_cc", priority = 5 }, -- sleep (19386), baseline (talent)
	["Scare Beast"] = { category = "dispel_cc", priority = 6 }, -- beast fear (1513), baseline
	["Steel Trap"] = { category = "dispel_cc", priority = 5, specs = { 255 } }, -- SV root+bleed (162488, talent)

	--==================================================================================
	-- GROTE COOLDOWN (F1) + extra CD's
	--==================================================================================
	-- Beast Mastery
	["Bestial Wrath"] = { role = "cooldown_bar", priority = 1, specs = { 253 } }, -- BM grote CD (19574)
	["Call of the Wild"] = { category = "cooldown", priority = 2, specs = { 253 } }, -- BM extra CD (359844, talent)
	["Bloodshed"] = { category = "cooldown", priority = 3, specs = { 253 } }, -- BM extra CD (321530, talent)
	-- Marksmanship
	["Trueshot"] = { role = "cooldown_bar", priority = 1, specs = { 254 } }, -- MM grote CD (288613)
	-- Survival
	["Coordinated Assault"] = { role = "cooldown_bar", priority = 1, specs = { 255 } }, -- SV grote CD (360952)
	["Fury of the Eagle"] = { category = "cooldown", priority = 2, specs = { 255 } }, -- SV extra CD (203415, talent)
	["Spearhead"] = { category = "cooldown", priority = 3, specs = { 255 } }, -- SV extra CD (talent)
	-- Gedeeld (talent-CD's die op meerdere specs kunnen zitten)
	["Stampede"] = { category = "cooldown", priority = 4 }, -- pet-charge CD (baseline talent)

	--==================================================================================
	-- BUILDERS (main_rotation)
	--==================================================================================
	["Steady Shot"] = { category = "main_rotation", priority = 1 }, -- baseline generieke builder
	-- Beast Mastery
	["Barbed Shot"] = { category = "main_rotation", priority = 2, specs = { 253 } }, -- BM builder (Frenzy)
	["Cobra Shot"] = { category = "main_rotation", priority = 3, specs = { 253 } }, -- BM builder/dump
	["Kill Command"] = { category = "main_rotation", priority = 1, specs = { 253, 255 } }, -- BM (34026) + SV (259489) core
	-- Marksmanship
	["Aimed Shot"] = { category = "main_rotation", priority = 1, specs = { 254 } }, -- MM builder (19434)
	["Rapid Fire"] = { category = "main_rotation", priority = 2, specs = { 254 } }, -- MM channel builder (257044)
	["Wailing Arrow"] = { category = "main_rotation", priority = 3, specs = { 254 }, alsoStop = "silence" }, -- MM Dark Ranger; JustAC InterruptAbilities [355589/392060] cc mech=9 (silence) → Spec 08 cross-list (stays rotational)
	["Chimaera Shot"] = { category = "main_rotation", priority = 4, specs = { 254 } }, -- MM builder (talent)
	-- Survival
	["Raptor Strike"] = { category = "main_rotation", priority = 2, specs = { 255 } }, -- SV melee builder (186270)
	["Mongoose Bite"] = { category = "main_rotation", priority = 2, specs = { 255 } }, -- SV melee builder (talent, vervangt Raptor Strike)
	["Wildfire Bomb"] = { category = "main_rotation", priority = 3, specs = { 255 } }, -- SV builder (DoT + directe schade)
	["Flanking Strike"] = { category = "main_rotation", priority = 4, specs = { 255 } }, -- SV builder (259489, talent)

	--==================================================================================
	-- SPENDERS
	--==================================================================================
	-- Beast Mastery / gedeeld
	["Kill Shot"] = { category = "spender", priority = 4 }, -- execute damage (53351 BM/MM, 320976 SV), baseline; damage -> spender
	-- Marksmanship
	["Arcane Shot"] = { category = "spender", priority = 1, specs = { 254 } }, -- MM spender (Precise Shots)
	["Black Arrow"] = { category = "spender", priority = 2, specs = { 254 } }, -- MM Dark Ranger spender
	-- Survival
	["Boomstick"] = { category = "spender", priority = 1, specs = { 255 } }, -- SV ranged filler (1261215, Midnight)
	["Flamefang Pitch"] = { category = "spender", priority = 2, specs = { 255 } }, -- SV hero-talent spender (1251592)
	["Takedown"] = { category = "spender", priority = 3, specs = { 255 } }, -- SV Midnight spender/proc

	--==================================================================================
	-- AoE (Shift+N)
	--==================================================================================
	["Multi-Shot"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 253, 254 } }, -- BM/MM AoE (2643), Shift-tweeling van Steady Shot (1)
	["Volley"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 254 } }, -- MM AoE-CD (260243), Shift-tweeling van Rapid Fire (2)
	["Explosive Shot"] = { category = "main_rotation", priority = 6, bindKey = "Shift+4", specs = { 254 } }, -- MM AoE/ST (talent), Shift-tweeling van Arcane Shot (4)
	["Raptor Swipe"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 255 } }, -- SV AoE-variant Raptor Strike, Shift-tweeling van Raptor Strike (2)
	["Carve"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 255 } }, -- SV melee-AoE (187708), Shift-tweeling van Kill Command (1)
	["Butchery"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 255 } }, -- SV melee-AoE (212436, talent), zelfde slot als Carve (1)

	--==================================================================================
	-- UTILITY
	--==================================================================================
	["Mend Pet"] = { category = "utility", priority = 1 }, -- pet-heal (136), baseline
	["Hunter's Mark"] = { category = "utility", priority = 2 }, -- target-marker (baseline)
	["Misdirection"] = { category = "utility", priority = 3 }, -- threat-transfer (34477), baseline
	["Flare"] = { category = "utility", priority = 5 }, -- reveal/dispel-stealth (baseline)
}
