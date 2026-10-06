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

	⚠️ SURVIVAL IS UITGEDUND IN MIDNIGHT -- zes entries verwijderd op 7 aug 2026.
	Butchery, Carve, Flanking Strike, Mongoose Bite, Spearhead en Coordinated Assault
	bestaan niet meer. Icy Veins' Survival-gids voor 12.0.7 zegt het met zoveel woorden:
	"The abilities Butchery, Flanking Strike, Mongoose Bite, Explosive Shot, Kill Shot,
	Spearhead, and Coordinated Assault are gone."
	  https://www.icy-veins.com/wow/survival-hunter-pve-dps-guide
	Carve staat in geen enkele huidige gids meer -- ook niet als "verwijderd", wat er
	meestal op wijst dat hij al eerder weg was. De AoE van Survival loopt nu via Raptor
	Swipe, Wildfire Bomb en Moonlight Chakram (Method-rotatie).

	Gevonden doordat de linter meldde dat Butchery en Carve dezelfde toets wilden: de
	botsing bleek een spook tussen twee dode spells. Explosive Shot staat hier nog voor
	MM (254) en is BEWUST NIET verwijderd -- dat citaat gaat over wat Survival verloor,
	en of Marksmanship hem ook kwijt is, is niet nagetrokken.
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

	STAY ALIVE CARD (17 Sep 2026). `survival`, `survivalOrder` and `survivalNote` feed only
	Modules/SurvivalPlan.lua; the key fields (role, category, priority, bindKey, alsoStop) are
	untouched. Every tag follows docs/audit_2026-09-17/audit_hunter_rogue_dh.md (Icy Veins / Method 12.1).
	Order: Roar of Sacrifice (15%, your pet takes half) and Survival of the Fittest (30%, 2 charges)
	are the small buttons, Aspect of the Turtle the big one. Escapes: Disengage (leaps backwards),
	Feign Death (drops aggro), Aspect of the Cheetah.
	Left OFF the card on purpose: Harpoon (a gap-closer TOWARDS the enemy, not an escape; its
	`mobility` role stays for the keybind), Camouflage and Mend Pet (small, out of combat / pet only).
	Removed 17 Sep, no longer buttons in 12.1 (M-BM, hackmd, WH-SV): Call of the Wild (removed),
	Bloodshed (now a passive bleed with Bestial Wrath), Fury of the Eagle (folded into Boomstick).
	Fortitude of the Bear never had an entry here (a passive 3% DR in Midnight).
]]

ns.KeybindRoleClassifier.HUNTER = {
	--==================================================================================
	-- INTERRUPT (E)
	--==================================================================================
	["Counter Shot"] = { id = 147362, role = "interrupt", priority = 1, specs = { 253, 254 }, survival = "interrupt", survivalOrder = 1 }, -- BM/MM kick (147362); SV = Muzzle
	["Muzzle"] = { id = 187707, role = "interrupt", priority = 1, specs = { 255 }, survival = "interrupt", survivalOrder = 1 }, -- SV kick (187707)

	--==================================================================================
	-- MOVEMENT (Q)
	--==================================================================================
	["Disengage"] = { id = 781, role = "utility_primary", priority = 1, survival = "escape", survivalOrder = 1, survivalNote = "SURVIVAL_NOTE_BACKWARDS" }, -- baseline retreat (781); alle 3 specs
	["Harpoon"] = { id = 190925, role = "mobility", priority = 1, specs = { 255 } }, -- SV engage/gap-closer (190925); NOT on the card: pulls you TOWARDS the enemy
	["Aspect of the Cheetah"] = { id = 186257, role = "utility_primary", priority = 2, survival = "escape", survivalOrder = 3 }, -- baseline sprint/movement (186257); movement -> utility_primary

	--==================================================================================
	-- DEFENSIVES
	--==================================================================================
	["Exhilaration"] = { id = 109304, role = "heal_quick", priority = 1, survival = "heal", survivalOrder = 1 }, -- F2 heal-anker: self+pet quick heal (109304), baseline; 1 min (IV)
	-- Card: 30% DR for 8 s, 2 charges — pressed before a hit, not kept up (IV).
	["Survival of the Fittest"] = { id = 264735, role = "defensive_1", priority = 1, survival = "small", survivalOrder = 2 }, -- kleine def, 30% DR (264735), baseline (talent)
	["Aspect of the Turtle"] = { id = 186265, role = "defensive_3", priority = 1, survival = "big", survivalOrder = 1 }, -- grote def, immune (186265), baseline
	-- Survival too (3 Oct 2026, mh-research: Icy Veins SV pets guide 10 Aug - SV takes a Ferocity pet when it must be
	-- the group's Bloodlust). Not Marksmanship: that spec has Harrier's Cry and no pet by default.
	["Primal Rage"] = { category = "cooldown", priority = 5, specs = { 253, 255 } }, -- pet-Bloodlust/Heroism-equivalent (JustAC SpellCategories 264667); analoog aan Shaman Bloodlust
	["Camouflage"] = { id = 199483, category = "utility", priority = 5 }, -- baseline stealth/reset-utility (JustAC SpellCooldowns 199483)
	-- Card: self-castable in Midnight (IV-SVguide); 15% DR, the pet takes half — the smallest button.
	["Roar of Sacrifice"] = { id = 53480, category = "defensive", priority = 2, survival = "small", survivalOrder = 1, survivalNote = { [253] = "SURVIVAL_NOTE_PET", [255] = "SURVIVAL_NOTE_PET" } }, -- externe pet-def (53480), baseline (talent); card: pet-note niet voor MM (speelt meestal zonder pet; IV 12.1, 3 okt 2026)
	["Feign Death"] = { id = 5384, category = "utility", priority = 4, survival = "escape", survivalOrder = 2, survivalNote = "SURVIVAL_NOTE_AGGRO" }, -- baseline threat-drop (5384); 30 s

	--==================================================================================
	-- DISPEL / CC (V + overflow)
	--==================================================================================
	["Tranquilizing Shot"] = { id = 19801, category = "dispel_cc", priority = 1 }, -- enrage/magic dispel (19801), baseline
	["Freezing Trap"] = { id = 187650, category = "dispel_cc", priority = 2 }, -- incapacitate (187650), baseline
	["Binding Shot"] = { id = 109248, category = "dispel_cc", priority = 3 }, -- root/stun (117405), baseline (talent)
	["Intimidation"] = { id = 19577, category = "dispel_cc", priority = 3, alsoStop = "stun" }, -- pet-stun; JustAC InterruptAbilities [24394] cc mech=12 → Spec 08 alsoStop
    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): ["Scatter Shot"] = { id = 213691, category = "dispel_cc", priority = 4 }, -- disorient (213691), baseline (talent)
	["Concussive Shot"] = { id = 5116, category = "dispel_cc", priority = 4 }, -- slow (5116), baseline
    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): ["Bursting Shot"] = { category = "dispel_cc", priority = 5 }, -- disorient/knockback (186387), MM/baseline
    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): ["Wyvern Sting"] = { category = "dispel_cc", priority = 5 }, -- sleep (19386), baseline (talent)
	["Scare Beast"] = { id = 1513, category = "dispel_cc", priority = 6 }, -- beast fear (1513), baseline
    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): ["Steel Trap"] = { category = "dispel_cc", priority = 5, specs = { 255 } }, -- SV root+bleed (162488, talent)

	--==================================================================================
	-- GROTE COOLDOWN (F1) + extra CD's
	--==================================================================================
	-- Beast Mastery
	["Bestial Wrath"] = { id = 19574, blockQ = { [253] = true }, role = "cooldown_bar", priority = 1, specs = { 253 } }, -- BM grote CD (19574)
	-- Call of the Wild (removed) and Bloodshed (passive now) deleted 17 Sep 2026 (M-BM, hackmd).
	-- Marksmanship
	["Trueshot"] = { id = 288613, blockQ = { [254] = true }, role = "cooldown_bar", priority = 1, specs = { 254 } }, -- MM grote CD (288613)
	-- Survival: Fury of the Eagle deleted 17 Sep 2026, folded into Boomstick (WH-SV, IV-SV).
	-- Gedeeld (talent-CD's die op meerdere specs kunnen zitten)
    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): ["Stampede"] = { category = "cooldown", priority = 4 }, -- pet-charge CD (baseline talent)

	--==================================================================================
	-- BUILDERS (main_rotation)
	--==================================================================================
	["Steady Shot"] = { id = 56641, category = "main_rotation", priority = 1 }, -- baseline generieke builder
	-- Beast Mastery
	["Barbed Shot"] = { id = 217200, category = "main_rotation", priority = 2, specs = { 253 } }, -- BM builder (Frenzy)
	["Cobra Shot"] = { id = 193455, category = "main_rotation", priority = 3, specs = { 253 } }, -- BM builder/dump
	["Kill Command"] = { id = 34026, category = "main_rotation", priority = 1, specs = { 253, 255 } }, -- BM (34026) + SV (259489) core
	-- Marksmanship
	["Aimed Shot"] = { id = 19434, category = "main_rotation", priority = 1, specs = { 254 } }, -- MM builder (19434)
	["Rapid Fire"] = { id = 257044, category = "main_rotation", priority = 2, specs = { 254 } }, -- MM channel builder (257044)
	["Wailing Arrow"] = { id = 392060, category = "main_rotation", priority = 3, specs = { 254 }, alsoStop = "silence" }, -- MM Dark Ranger; JustAC InterruptAbilities [355589/392060] cc mech=9 (silence) → Spec 08 cross-list (stays rotational)
    -- REMOVED 5 Oct 2026 (gap round, mh-research: not castable in 12.1): ["Chimaera Shot"] = { category = "main_rotation", priority = 4, specs = { 254 } }, -- MM builder (talent)
	-- Survival
	["Raptor Strike"] = { id = 186270, category = "main_rotation", priority = 2, specs = { 255 } }, -- SV melee builder (186270)
	["Wildfire Bomb"] = { id = 259495, category = "main_rotation", priority = 3, specs = { 255 } }, -- SV builder (DoT + directe schade)

	--==================================================================================
	-- SPENDERS
	--==================================================================================
	-- Beast Mastery / gedeeld
	["Kill Shot"] = { id = 53351, category = "spender", priority = 4, specs = { 254 } }, -- execute damage (53351 BM/MM, 320976 SV), baseline; damage -> spender
	-- Marksmanship
	["Arcane Shot"] = { id = 185358, category = "spender", priority = 1, specs = { 254 } }, -- MM spender (Precise Shots)
	["Black Arrow"] = { id = 466930, category = "spender", priority = 2, specs = { 254, 253 } }, -- MM Dark Ranger spender
	-- Survival
	["Boomstick"] = { id = 1261193, category = "spender", priority = 1, specs = { 255 } }, -- SV ranged filler (1261215, Midnight)
	["Takedown"] = { id = 1250646, blockQ = { [255] = true }, category = "spender", priority = 3, specs = { 255 } }, -- SV Midnight spender/proc

	--==================================================================================
	-- AoE (Shift+N)
	--==================================================================================
	-- 🔴 VERVANGEN, NIET HERNOEMD — gerepareerd 7 sep 2026 (Spec 32 §1d).
	-- Midnight heeft Multi-Shot voor Beast Mastery vervangen door **Wild Thrash**: dezelfde rol
	-- (het is waar Beast Cleave sindsdien vandaan komt, met 8 s cooldown) maar een andere naam
	-- én een ander ID. Robs spellbook kent `Wild Thrash` en kent **geen** `Multi-Shot`.
	--
	-- ⚠️ Gevolg was dat `Shift+1` — de AoE-tweeling — bij BM gewoon LEEG bleef, terwijl de knop
	-- waar de hele AoE-rotatie om draait geen toets had. En het faalde stil: de dump meldde
	-- "0 did not fit", want er viel niets om; er werd alleen niets geplaatst.
	--
	-- 📌 `specs` gaat van { 253, 254 } naar { 254 }, en dat is veilig ONGEACHT of Marksmanship
	-- Multi-Shot nog heeft — wat op Robs BM-hunter niet te meten viel. Heeft MM hem nog, dan
	-- klopt de entry. Heeft MM hem óók niet meer, dan is hij inert: de pijplijn loopt over de
	-- live spellbook en zoekt daarin op, dus een regel voor een spell die niet bestaat matcht
	-- nooit. Zie §2 — een spell die verdwijnt kost niets, een spell die erbij komt kost een toets.
	["Multi-Shot"] = { id = 257620, category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 254 } }, -- MM AoE (2643), Shift-tweeling van Steady Shot (1)
	["Wild Thrash"] = { id = 1264359, category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 253 } }, -- BM AoE sinds Midnight; bron van Beast Cleave
	["Volley"] = { id = 260243, category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 254 } }, -- MM AoE-CD (260243), Shift-tweeling van Rapid Fire (2)
	["Explosive Shot"] = { id = 212431, category = "main_rotation", priority = 6, bindKey = "Shift+4", specs = { 254 } }, -- MM AoE/ST (talent), Shift-tweeling van Arcane Shot (4)
	["Raptor Swipe"] = { id = 1262293, category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 255 } }, -- SV AoE-variant Raptor Strike, Shift-tweeling van Raptor Strike (2)

	--==================================================================================
	-- UTILITY
	--==================================================================================
	-- Pet spells live in spellbook FLYOUTS since Midnight ("Pet Utility" 103, "Call Pet" 9; mh-research
	-- 5 Oct 2026, wago.tools DB2 12.1.0.69933). KeybindAutoMap now reads flyout slots. By id, because Call
	-- Pet takes the pet's name ("Call Balou", MissingBuff.lua:729). Rob, 5 Oct 2026: "het healen van je pet
	-- … die mis ik eigenlijk". Feed Pet, Beast Lore, Tame Beast and Dismiss Pet stay off: out of combat only.
	["Mend Pet"] = { id = 136, category = "utility", priority = 1 }, -- pet-heal, flyout Pet Utility
	["Revive Pet"] = { id = 982, category = "utility", priority = 4 }, -- flyout Pet Utility
	["Call Pet 1"] = { id = 883, category = "utility", priority = 6 }, -- flyout Call Pet; MM only with Unbreakable Bond
	["Hunter's Mark"] = { id = 257284, category = "utility", priority = 2 }, -- target-marker (baseline)
	-- ⚠️ NOT baseline: a CLASS-TREE TALENT in Midnight. Measured 10 Sep 2026 - Rob's hunter showed
	-- Misdirection as a talent node at Rank 0/1 (spell 34477), and /mh macrocheck read it "not found"
	-- in BM and MM until taken. No `specs` field stays right: every hunter spec can take it.
	["Misdirection"] = { id = 34477, category = "utility", priority = 3 }, -- threat-transfer (34477), class talent
	["Flare"] = { id = 1543, category = "utility", priority = 5 }, -- reveal/dispel-stealth (baseline)

    -- Gap round 5 Oct 2026 (Rob: "ja doe maar"): castable 12.1 spells that had no entry.
    ["Harrier's Cry"] = { id = 466904, category = "cooldown", priority = 5, specs = { 254 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): MM baseline Bloodlust (DB2 SpecializationSpells 254). Wowhead tooltip: 6 min, +30% haste f
    ["Tar Trap"] = { id = 187698, category = "dispel_cc", priority = 5, specs = { 253, 254, 255 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): Class tree choice node 102393. IV BM 12.1 lists it (30 s slow pool).
    ["Aspect of the Eagle"] = { id = 186289, category = "cooldown", priority = 3, specs = { 255 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): SV baseline (DB2 SpecializationSpells 255). IV SV 12.1, Wowhead (1.5 min). In the SimC SV 
    ["Wing Clip"] = { id = 195645, category = "dispel_cc", priority = 6, specs = { 253, 254, 255 } }, -- gap round 5 Oct 2026 (mh-research, wago 69933): Baseline (DB2 SkillLineAbility, AcquireMethod 2). The class talent Concussive Shot overrid
}
