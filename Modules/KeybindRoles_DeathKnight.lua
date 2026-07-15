local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

--[[
	Naam->rol-classifier voor DEATH KNIGHT (Blood 250, Frost 251, Unholy 252) - v6-keybind-standaard.
	VERVANGT de oude incomplete draft-versie: dekt ELKE relevante active spell per spec.

	Bron 1: docs/KEYBIND_MAP_DRAFT_warrior_dk_dh_evoker.md (Blood/Frost/Unholy tabellen).
	Bron 2 (addon-data, ter afleiding van rol):
	  - JustAC/Data/InterruptAbilities.lua : Mind Freeze (47528, kind=interrupt),
	    Asphyxiate (108194/221562), Blinding Sleet (207167), Strangulate (47476) -> dispel_cc.
	  - JustAC/Data/SpellCategories.lua + JustAC/SpellDB.lua : defensieven
	    (Icebound Fortitude 48792, Anti-Magic Shell 48707, Vampiric Blood 55233,
	    Lichborne 49039, Death Pact 48743), Death's Advance 48265 / Wraith Walk 212552
	    (movement), Dark Command 56222 (taunt), Raise Dead 46584/46585 (pet).
	  - JustAC/SpellDB.lua CD-lijsten : Dancing Rune Weapon 49028 (Blood), Pillar of Frost 51271
	    (Frost), Army of the Dead 42650 (Unholy) -> grootste CD (cooldown_bar).
	  - JustAC/Data/SpellArchetypes.lua : builders/spenders (Death Strike 49998,
	    Frost Strike 49143, Death Coil 47541, Epidemic 207317, Blood Boil 50842,
	    Howling Blast 49184, Chains of Ice 45524).
	  - JustAC/Data/RangeReferences.lua : Death Strike 49998, Death Grip 49576.
	  - ClassCodex/Data/DeathKnight/guide.lua : Pillar of Frost, Consumption, Death and Decay.

	Gekeyd op de exacte spell-NAAM; de addon matcht dit tegen de live spellbook. Alle specs
	van de class in EEN tabel. Baseline-spells (geen specs-veld) gelden voor alle 3 de specs:
	Mind Freeze, Death's Advance, Wraith Walk, Icebound Fortitude, Anti-Magic Shell, Death Grip,
	Chains of Ice, Death Strike, Death Pact, Raise Dead, Dark Command, Lichborne.

	LET OP: Death Strike blijft de rotatie-SPENDER (category=spender). De self-heal-anker (F2 heal_quick)
	is Death Pact - Death Strike wordt bewust NIET naar heal_quick gedupliceerd.

	Overgeslagen (conform regels): Recuperate/F4, heal_sustain, racial (Shift+E), trinket (Ctrl+F1),
	potion (Alt+C), en zuivere passieve talents (Bone Shield 195181, Last Stand-effecten e.d.).
]]

ns.KeybindRoleClassifier.DEATHKNIGHT = {
	-- ============================================================
	-- BASELINE (alle 3 specs: 250 Blood, 251 Frost, 252 Unholy)
	-- ============================================================
	-- Interrupt (E)
	["Mind Freeze"] = { role = "interrupt", priority = 1 },
	-- Movement (Q / Shift+Q)
	["Death's Advance"] = { role = "utility_primary", priority = 1 }, -- Q (movement, baseline)
	["Wraith Walk"] = { role = "utility_primary", priority = 2 },     -- Shift+Q (movement, talent-alternatief)
	-- Grote defensive (C)
	["Icebound Fortitude"] = { role = "defensive_3", priority = 1 },  -- grote def (baseline)
	-- Dispel/CC (V) - Death Grip als threat/gap-tool op de dispel/CC-anker
	["Death Grip"] = { category = "dispel_cc", priority = 1 },        -- V (CC/threat, baseline)
	["Chains of Ice"] = { category = "dispel_cc", priority = 2 },     -- Shift+V (slow/CC; Frost/Unholy binden dit, baseline spell)
	-- Self-heals (F2 heal-anker)
	["Death Pact"] = { role = "heal_quick", priority = 1 },           -- F2 heal-anker: instant self-heal (talent, baseline beschikbaar)
	-- Spender (rotatie) - Death Strike BLIJFT spender, NIET dupliceren naar heal
	["Death Strike"] = { category = "spender", priority = 1 },        -- rotatie-spender (heal is bijproduct, geen heal_quick)
	-- Extra defensive (Shift+Z)
	["Lichborne"] = { role = "defensive_1", priority = 2 },           -- kleine def / CC-immuniteit (baseline)
	-- Utility (R / F)
	["Anti-Magic Shell"] = { category = "utility", priority = 1 },    -- R (magische mitigatie, baseline)
	["Anti-Magic Zone"] = { category = "defensive", priority = 5 },   -- groeps-magie-DR-koepel, baseline (JustAC SpellCategories DEFENSIVE 51052)
	["Gorefiend's Grasp"] = { category = "dispel_cc", priority = 3, specs = { 250 } }, -- Blood AoE mass-grip (M+ control; JustAC SpellCooldowns 108199=90s)
	["Dark Command"] = { category = "taunt", priority = 1 },          -- F: taunt (baseline, eigen kaart)
	["Raise Dead"] = { category = "utility", priority = 3 },          -- T/F (pet, baseline alle 3 specs)

	-- ============================================================
	-- BLOOD (250) - tank
	-- ============================================================
	-- Builders (main_rotation)
	["Heart Strike"] = { category = "main_rotation", priority = 1, specs = { 250 } },   -- 1 (kernbuilder)
	["Marrowrend"] = { category = "main_rotation", priority = 2, specs = { 250 } },     -- 2 (Bone Shield-onderhoud)
	["Death's Caress"] = { category = "main_rotation", priority = 3, specs = { 250 } }, -- 3 (ranged tag)
	-- AoE (Shift-tweelingen)
	["Blood Boil"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 250 } },      -- AoE
	["Death and Decay"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 250, 252 } }, -- AoE-grondeffect (Blood + Unholy)
	-- Grote defensive (Shift+C)
	["Vampiric Blood"] = { role = "defensive_4", priority = 1, specs = { 250 } },       -- grote def (extra, Blood-only)
	-- Grootste CD (F1) + extra CD's
	["Dancing Rune Weapon"] = { role = "cooldown_bar", priority = 1, specs = { 250 } }, -- F1 (grootste CD: burst/mitigatie)
	["Consumption"] = { category = "cooldown", priority = 2, specs = { 250 } },         -- Shift+F1 (major CD, talent)
	["Bonestorm"] = { category = "cooldown", priority = 3, specs = { 250 } },           -- extra CD (talent, AoE/heal)
	["Blooddrinker"] = { category = "cooldown", priority = 5, specs = { 250 } },        -- kanaal-CD (talent, damage/heal; genereert RP i.p.v. spenden)
	["Tombstone"] = { category = "cooldown", priority = 4, specs = { 250 } },           -- extra CD (talent, Bone Shield-dump)

	-- ============================================================
	-- FROST (251) - dps
	-- ============================================================
	-- Builders (main_rotation)
	["Obliterate"] = { category = "main_rotation", priority = 1, specs = { 251 } },        -- 1 (kernbuilder)
	["Remorseless Winter"] = { category = "main_rotation", priority = 2, specs = { 251 } },-- 3 (rotationeel, AoE-grond)
	["Empower Rune Weapon"] = { category = "cooldown", priority = 5, specs = { 251, 250 } },-- resource-CD (Frost 2; Blood-talent)
	-- Spender (RP-dump)
	["Frost Strike"] = { category = "spender", priority = 1, specs = { 251 } },            -- 4 (RP-spender)
	-- AoE (Shift-tweelingen)
	["Howling Blast"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 251 } },  -- AoE
	["Frostscythe"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 251 } },    -- AoE-alternatief (talent)
	["Glacial Advance"] = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 251 } },      -- AoE-spender
	-- Grootste CD (F1) + extra CD's
	["Pillar of Frost"] = { role = "cooldown_bar", priority = 1, specs = { 251 } },        -- F1 (grootste CD: burst)
	["Frostwyrm's Fury"] = { category = "cooldown", priority = 2, specs = { 251 } },       -- Shift+F1 (major CD, extra)
	["Breath of Sindragosa"] = { category = "cooldown", priority = 3, specs = { 251 } },   -- Ctrl+F1 (major CD, talent-kanaal)

	-- ============================================================
	-- UNHOLY (252) - dps
	-- ============================================================
	-- Builders (main_rotation)
	["Festering Strike"] = { category = "main_rotation", priority = 1, specs = { 252 } },  -- 1 (wounds-builder)
	["Scourge Strike"] = { category = "main_rotation", priority = 2, specs = { 252 } },    -- 2 (wounds-burst)
	["Dark Transformation"] = { category = "cooldown", priority = 4, specs = { 252 } },    -- pet-CD (getransformeerde ghoul)
	-- Spender (RP-dump)
	["Death Coil"] = { category = "spender", priority = 1, specs = { 252 } },              -- 4 (RP-spender)
	-- AoE (Shift-tweelingen)
	["Epidemic"] = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 252 } }, -- AoE-spender
	-- Grootste CD (F1) + extra CD's
	["Army of the Dead"] = { role = "cooldown_bar", priority = 1, specs = { 252 } },       -- F1 (grootste CD: burst-opener)
	["Summon Gargoyle"] = { category = "cooldown", priority = 2, specs = { 252 } },        -- Shift+F1 (major CD, talent)
	["Apocalypse"] = { category = "cooldown", priority = 3, specs = { 252 } },             -- extra CD (talent, wounds-burst)
	["Unholy Assault"] = { category = "cooldown", priority = 4, specs = { 252 } },         -- extra CD (talent, burst)
	["Outbreak"] = { category = "main_rotation", priority = 3, specs = { 252 } },          -- disease-applicatie (builder-onderhoud)

	-- ============================================================
	-- CC-EXTRA per spec (dispel_cc) - Asphyxiate / Blinding Sleet / Strangulate
	-- ============================================================
	["Asphyxiate"] = { category = "dispel_cc", priority = 3, specs = { 250, 252 }, alsoStop = "stun" }, -- stun (Blood 221562 / Unholy 108194); JustAC cc mech=12 → Spec 08 alsoStop
	["Blinding Sleet"] = { category = "dispel_cc", priority = 3, specs = { 251 } },  -- AoE disorient (Frost)
	["Strangulate"] = { category = "dispel_cc", priority = 4, alsoStop = "silence" },                      -- silence (talent, baseline beschikbaar)
}
