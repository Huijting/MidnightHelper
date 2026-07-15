local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- =====================================================================
-- DRUID keybind-rol-classifier (WoW Midnight, Midnight Helper)
-- =====================================================================
-- VERVANGT de incomplete Druid-sectie uit KeybindRoles_RogueMonkDruid.lua.
-- Volledige dekking van elke relevante ACTIEVE spell per spec, incl. de
-- self-heals (Regrowth / Renewal / Frenzied Regeneration).
--
-- Koppelen op spell-NAAM (exacte naam als key), niet op ID.
-- specs={<id>} = spec-specifiek. Geen specs = baseline (alle 4 specs).
-- specID's: Balance 102, Feral 103, Guardian 104, Restoration 105.
--
-- Druid heeft 4 specs die veel spells DELEN maar met andere rol; daarom is
-- de spec-filter zorgvuldig gezet (spell staat bij de spec(s) waar hij
-- daadwerkelijk actief op de balk komt).
--
-- Rollen (role):     interrupt, utility_primary, utility_secondary, mobility,
--                    defensive_1..4, cooldown_bar, heal_quick, heal_ooc.
-- Categorieen (cat): main_rotation, spender, utility, dispel_cc, cooldown,
--                    defensive.
--
-- Bronnen (rol HIERUIT afgeleid, geen giswerk):
--   * JustAC\Data\InterruptAbilities.lua  -> Skull Bash (106839, pri1,
--     interrupt), Solar Beam (78675, pri2, interrupt), Mighty Bash (5211, cc
--     stun), Incapacitating Roar (99, cc pbaoe).
--   * JustAC\Data\SpellCategories.lua      -> DEFENSIVE {Barkskin 22812,
--     Survival Instincts 61336, Ironbark 102342, Rage of the Sleeper 200851,
--     Renewal 108238, Frenzied Regeneration 22842, Ironfur 192081};
--     CROWD_CONTROL {Incap. Roar, Entangling Roots, Hibernate, Mighty Bash,
--     Maim, Cyclone, Solar Beam, Mass Entanglement, Ursol's Vortex, Skull
--     Bash, Typhoon}; HEALING {Rejuvenation, Regrowth, Swiftmend, Lifebloom,
--     Wild Growth, Cenarion Ward, Efflorescence, Flourish, Tranquility};
--     UTILITY {Dash, Tiger Dash, Stampeding Roar, Growl, Innervate, Rebirth,
--     Remove Corruption, Nature's Cure, Soothe, Wild Charge}.
--   * JustAC\Data\SpellArchetypes.lua      -> builders (Wrath, Starfire,
--     Moonfire, Shred, Rake, Thrash, Swipe, Mangle) / spenders (Rip,
--     Ferocious Bite, Maim, Starsurge, Starfall, Primal Wrath, Ironfur).
--   * JustAC\SpellDB.lua (DRUID_1..4)      -> cooldowns per spec: DRUID_1
--     {Celestial Alignment 194223, Incarnation: Chosen of Elune 102560};
--     DRUID_2 {Berserk 106951, Incarnation: Avatar of Ashamane 102543};
--     DRUID_3 {Incarnation: Guardian of Ursoc 102558, Berserk 50334};
--     DRUID_4 {Tranquility 740, Flourish}.
--   * ClassCodex\Data\Druid\guide.lua      -> self-heal-gebruik: Feral
--     Frenzied Regeneration (22842) "if your health dips low"; Resto Regrowth
--     (8936). Renewal (108238) = talent, ExwindCore specs {102,103,104,105}.
--   * docs\KEYBIND_MAP_DRAFT_rogue_monk_druid.md -> v6 keybind-layout cross-ref
--     (F1=cooldown_bar, F2=heal_quick, C=defensive_3, Z=defensive_1, E=interrupt,
--     Q/Shift+Q=movement, V/Shift+V=cc, Shift+N=AoE, R/F=utility).
--
-- REGELS toegepast:
--   * Key = EXACTE spell-naam.
--   * Skull Bash specs {103,104}; Solar Beam specs {102}.
--   * Berserk: Feral (106951) + Guardian (50334), zelfde naam -> specs {103,104}.
--   * heal_quick (F2): Renewal (talent) + Regrowth. NIET F4.
--   * NIET opgenomen: Recuperate/globaal F4, heal_sustain/F4, racials,
--     trinkets, potions, zuivere passieven, vorm-shapeshifts (behalve als
--     nuttige utility: Bear/Cat/Moonkin/Prowl).
--   * Baseline (geen specs=): Barkskin, Wild Charge, Rebirth, Cyclone, Soothe,
--     Remove Corruption, Renewal, Dash.
-- =====================================================================

ns.KeybindRoleClassifier.DRUID = {

    -- =================================================================
    -- BALANCE (102)
    -- =================================================================
    -- Builders / DoT-onderhoud
    ["Wrath"]                            = { category = "main_rotation", priority = 1, specs = { 102, 105 } }, -- Balance builder / Resto filler
    ["Starfire"]                         = { category = "main_rotation", priority = 2, specs = { 102 } },      -- cleave-builder
    ["Moonfire"]                         = { category = "main_rotation", priority = 3, specs = { 102, 104, 105 } }, -- Balance/Guardian/Resto DoT
    ["Sunfire"]                          = { category = "main_rotation", priority = 4, specs = { 102, 105 } }, -- AoE-DoT (Balance/Resto)
    -- Spenders
    ["Starsurge"]                        = { category = "spender", priority = 1, specs = { 102 } },
    -- AoE
    ["Starfall"]                         = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 102 } }, -- AoE-spender (Shift-tweeling van Starsurge, spender 4)
    -- Interrupt
    ["Solar Beam"]                       = { role = "interrupt", priority = 1, specs = { 102 } }, -- Balance ranged AoE-silence
    -- Movement (Balance-specifiek talent)
    ["Tiger Dash"]                       = { role = "utility_primary", priority = 2, specs = { 102 } }, -- Shift+Q (Cat Form sprint)
    -- CC
    ["Typhoon"]                          = { category = "dispel_cc", priority = 1, specs = { 102, 104, 105 } }, -- knockback+daze (Balance V; Guardian/Resto talent)
    -- Cooldowns
    ["Celestial Alignment"]              = { role = "cooldown_bar", priority = 1, specs = { 102 } }, -- grootste CD (F1)
    ["Incarnation: Chosen of Elune"]     = { category = "cooldown", priority = 2, specs = { 102 } }, -- talent-alternatief (Shift+F1)

    -- =================================================================
    -- FERAL (103)
    -- =================================================================
    -- Builders
    ["Shred"]                            = { category = "main_rotation", priority = 1, specs = { 103 } },
    ["Rake"]                             = { category = "main_rotation", priority = 2, specs = { 103 } },
    -- Spenders
    ["Rip"]                              = { category = "spender", priority = 1, specs = { 103 } },
    ["Ferocious Bite"]                   = { category = "spender", priority = 2, specs = { 103 } },
    ["Primal Wrath"]                     = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 103 } }, -- AoE-finisher (bleed-spread; Shift-tweeling van Rip, spender 4)
    -- CC (Cat Form finisher-stun)
    ["Maim"]                             = { category = "dispel_cc", priority = 1, specs = { 103 } },
    -- Cooldowns
    ["Incarnation: Avatar of Ashamane"]  = { category = "cooldown", priority = 2, specs = { 103 } }, -- talent-alternatief voor Berserk (Shift+F1)

    -- =================================================================
    -- GUARDIAN (104)
    -- =================================================================
    -- Builders
    ["Mangle"]                           = { category = "main_rotation", priority = 1, specs = { 104 } }, -- primaire Rage-generator
    -- Spenders (mitigation / self-heal)
    ["Ironfur"]                          = { category = "defensive", priority = 1, specs = { 104 } }, -- actieve mitigation (armor), GEEN damage-spender -> Defensive-kaart
    ["Maul"]                             = { category = "spender", priority = 3, specs = { 104 } }, -- Rage-dump
    -- CC
    ["Mighty Bash"]                      = { category = "dispel_cc", priority = 1, specs = { 102, 104 }, alsoStop = "stun" }, -- JustAC InterruptAbilities [5211] cc mech=12 (stun) → Spec 08 alsoStop
    ["Incapacitating Roar"]              = { category = "dispel_cc", priority = 2, specs = { 103, 104 }, alsoStop = "incap" }, -- JustAC InterruptAbilities [99] cc mech=14 (incapacitate) → Spec 08 alsoStop
    -- Cooldowns
    ["Incarnation: Guardian of Ursoc"]   = { category = "cooldown", priority = 2, specs = { 104 } }, -- talent-alternatief (F1/Shift+F1)
    ["Rage of the Sleeper"]              = { category = "defensive", priority = 3, specs = { 104 } }, -- Guardian actieve def (dmg-reductie + reflect + heal), GEEN offensieve CD -> Defensive
    -- Utility
    ["Growl"]                            = { category = "taunt", priority = 1, specs = { 104 } }, -- taunt (F, eigen kaart)
    ["Bristling Fur"]                    = { category = "defensive", priority = 4, specs = { 104 } }, -- Rage-on-damage def-talent

    -- =================================================================
    -- GEDEELD: Feral + Guardian (melee-vormen)
    -- =================================================================
    ["Thrash"]                           = { category = "main_rotation", priority = 2, specs = { 103, 104 } }, -- Feral builder / Guardian AoE-builder
    ["Swipe"]                            = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 103, 104 } }, -- AoE-builder (Shift-tweeling van primaire builder Shred/Mangle, builder 1)
    ["Skull Bash"]                       = { role = "interrupt", priority = 1, specs = { 103, 104 } }, -- charge+interrupt (melee-specs)
    ["Stampeding Roar"]                  = { role = "utility_primary", priority = 2, specs = { 103, 104 } }, -- Shift+Q (raid-speed)
    ["Survival Instincts"]               = { role = "defensive_3", priority = 1, specs = { 103, 104 } }, -- grote def (-50% dmg), C
    ["Frenzied Regeneration"]            = { role = "heal_quick", priority = 2, specs = { 103, 104 } }, -- self-heal (Guardian spender/Feral noodheal), F2/5
    ["Berserk"]                          = { role = "cooldown_bar", priority = 1, specs = { 103, 104 } }, -- Feral 106951 + Guardian 50334, zelfde naam, F1
    ["Tiger's Fury"]                     = { category = "cooldown", priority = 3, specs = { 103 } }, -- Feral signature 30s energy/dmg-CD (JustAC SpellCooldowns 5217=30s; SimC core)

    -- =================================================================
    -- RESTORATION (105) - healer
    -- =================================================================
    -- ST-heals + ST-HoTs lopen via mouseover/click-cast (role="click_cast") en
    -- zitten NIET op een toets (Regrowth/Rejuvenation/Swiftmend/Lifebloom/
    -- Cenarion Ward/Healing Touch). Raid/AoE-heals BLIJVEN op toets. Heal-CD's
    -- gaan naar category="cooldown" (grootste = cooldown_bar). Resto krijgt
    -- daarnaast damage/utility/dispel/defensives + persoonlijke self-heal.
    -- Swiftmend = ST -> click_cast; Wild Growth = AoE-raidheal -> toets:
    ["Swiftmend"]                        = { role = "click_cast", priority = 1, specs = { 105 } }, -- ST-heal (instant, consumeert HoT) -> mouseover/click-cast, GEEN toets (v6 6)
    -- Ontbrekende ST-heals + ST-HoTs -> click_cast (mouseover, GEEN toets). Regrowth is
    -- Resto-only en bestaat NIET als aparte Lua-key elders -> veilig toegevoegd.
    ["Rejuvenation"]                     = { role = "click_cast", priority = 1, specs = { 105 } }, -- ST-HoT (Resto-only) -> mouseover/click-cast
    ["Regrowth"]                         = { role = "click_cast", priority = 1, specs = { 105 } }, -- ST-heal + kort HoT -> mouseover/click-cast
    ["Lifebloom"]                        = { role = "click_cast", priority = 1, specs = { 105 } }, -- ST-HoT op tank (Resto-only) -> mouseover/click-cast
    ["Cenarion Ward"]                    = { role = "click_cast", priority = 1, specs = { 105 } }, -- ST-schild/HoT (Resto-only) -> mouseover/click-cast
    ["Wild Growth"]                      = { category = "raid_heal", priority = 2, bindKey = "Shift+4", specs = { 105 } }, -- AoE-raidheal BLIJFT op toets (Shift+4)
    ["Efflorescence"]                    = { category = "raid_heal", priority = 4, specs = { 105 } }, -- grond-AoE-raidheal (bloom) -> toets
    -- Kleine defensive (extern)
    ["Ironbark"]                         = { role = "defensive_1", priority = 2, specs = { 105 } }, -- extern -20% dmg (Z); ook raid-CD-slot
    -- Raid-heal cooldowns (op cooldown-slots)
    ["Tranquility"]                      = { role = "cooldown_bar", priority = 1, specs = { 105 } }, -- grote raid-heal (C/F1)
    ["Flourish"]                         = { category = "cooldown", priority = 2, specs = { 105 } }, -- verlengt HoTs (F1)
    ["Incarnation: Tree of Life"]        = { category = "cooldown", priority = 2, specs = { 105 } }, -- Resto heal-vorm CD (talent)
    ["Convoke the Spirits"]              = { category = "cooldown", priority = 2, specs = { 105 } }, -- burst heal/dmg CD (talent)
    ["Grove Guardians"]                  = { category = "cooldown", priority = 2, specs = { 105 } }, -- treants die mee-healen (talent)
    -- Dispel / CC
    ["Nature's Cure"]                    = { category = "dispel_cc", priority = 1, specs = { 105 } }, -- magic/curse/poison dispel
    ["Mass Entanglement"]                = { category = "dispel_cc", priority = 2, specs = { 105 } }, -- AoE-root
    -- Utility
    ["Innervate"]                        = { category = "utility", priority = 2, specs = { 102, 105 } }, -- mana-utility (Balance+Resto), R

    -- =================================================================
    -- BASELINE (alle 4 Druid-specs; geen specs=)
    -- =================================================================
    -- Movement
    ["Wild Charge"]                      = { role = "utility_primary", priority = 1 }, -- Q (vorm-afhankelijke gap-closer)
    ["Dash"]                             = { role = "utility_primary", priority = 3 }, -- Cat Form sprint (baseline movement)
    ["Travel Form"]                      = { role = "mobility", priority = 1 }, -- R (snelle reis-vorm: outdoor speed / zwem / vlieg; alle specs, out-of-combat)
    -- Kleine defensive
    ["Barkskin"]                         = { role = "defensive_1", priority = 1 }, -- -20% dmg, alle vormen (Z)
    -- Self-heal
    ["Renewal"]                          = { role = "heal_quick", priority = 1 }, -- F2 instant self-heal (talent; ExwindCore alle specs)
    -- Dispel / CC (class-gedeeld)
    ["Cyclone"]                          = { category = "dispel_cc", priority = 3 }, -- banish-CC (1 doel)
    ["Entangling Roots"]                 = { category = "dispel_cc", priority = 4 }, -- single-target root
    ["Soothe"]                           = { category = "dispel_cc", priority = 5 }, -- enrage-dispel
    ["Remove Corruption"]                = { category = "dispel_cc", priority = 6, specs = { 102, 103, 104 } }, -- curse/poison-dispel; non-Resto only (Resto uses Nature's Cure -> anders dubbel + overflow op C)
    -- Utility / vormen (class-gedeeld)
    ["Rebirth"]                          = { role = "utility_secondary", priority = 2 }, -- battle-res (F/R)
    ["Prowl"]                            = { category = "utility", priority = 3 }, -- stealth (Cat Form openers)
    -- Vaste vormen-cluster: in ELKE Druid-spec dezelfde toets, zodat een beginner
    -- de vormen makkelijk terugvindt ("Shift+R/T/X = kat/beer/uil"). Travel Form
    -- blijft op R (base, mobility). bindKey forceert de plek (base R/T/X telt mee
    -- op het keyboard, geen overflow naar de situational-lijst).
    ["Bear Form"]                        = { category = "utility", priority = 4, bindKey = "Shift+T" }, -- tank/def-vorm (nood-mitigation)
    ["Cat Form"]                         = { category = "utility", priority = 5, bindKey = "Shift+R" }, -- melee-DPS-vorm
    ["Moonkin Form"]                     = { category = "utility", priority = 6, bindKey = "Shift+X" }, -- caster-vorm (Balance/Resto Affinity)
}
