local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- =====================================================================
-- MONK keybind-rol-classifier (WoW Midnight, Midnight Helper)
-- =====================================================================
-- VERVANGT de incomplete MONK-sectie uit KeybindRoles_RogueMonkDruid.lua.
-- Volledige dekking van ELKE relevante ACTIEVE spell per spec.
--
-- Koppelen op spell-NAAM (exacte naam als key), niet op ID.
-- specs={<id>} = spec-specifiek. Geen specs = baseline (alle 3 specs).
-- specID's: Brewmaster 268, Windwalker 269, Mistweaver 270.
--
-- Rollen (role):     interrupt, utility_primary, utility_secondary, mobility,
--                    defensive_1..4, cooldown_bar, heal_quick, heal_ooc.
-- Categorieen (cat): main_rotation, spender, utility, dispel_cc, cooldown,
--                    defensive.
--
-- Bronnen (rol HIERUIT afgeleid, geen giswerk):
--   * JustAC\Data\InterruptAbilities.lua -> Spear Hand Strike (interrupt),
--     Leg Sweep / Paralysis (cc).
--   * JustAC\Data\SpellCategories.lua     -> Fortifying Brew / Celestial Brew /
--     Touch of Karma (via HealingItems) / Diffuse Magic / Dampen Harm /
--     Life Cocoon / Zen Meditation (defensieven); Ring of Peace (cc); Detox
--     (dispel); Roll / Tiger's Lust (movement); Provoke (taunt);
--     Transcendence-statues (utility); Soothing Mist / Vivify / Renewing Mist /
--     Enveloping Mist / Thunder Focus Tea / Revival / Invoke Chi-Ji / Life
--     Cocoon (healing).
--   * JustAC\Data\HealingItems.lua        -> (bestaat als Data\HealingItems.lua)
--     bevestigt zelf-defensieve toolkit-lijsten via SpellDB CLASS_DEFENSIVE_DEFAULTS.
--   * JustAC\SpellDB.lua                  -> MONK CLASS_DEFENSIVE_DEFAULTS
--     {MONK 322101 Expel Harm/115203 Fortifying Brew/122783 Diffuse Magic;
--     MONK_1 119582 Purifying Brew/322507 Celestial Brew/322101 Expel Harm/
--     120954 Fortifying Brew; MONK_2 115203 Fortifying Brew/122783 Diffuse
--     Magic; MONK_3 322101 Expel Harm/122470 Touch of Karma/201318 Fortifying
--     Brew/122783 Diffuse Magic}; gap-closers {MONK_1 109132 Roll/115008 Chi
--     Torpedo; MONK_3 109132 Roll/115008 Chi Torpedo/101545 Flying Serpent
--     Kick}; grootste-CD-lijsten {MONK_1 387184 Weapons of Order; MONK_3 137639
--     Storm, Earth, and Fire}; burst-CD's {MONK_1 325153 Exploding Keg; MONK_3
--     123904 Invoke Xuen, the White Tiger}.
--   * JustAC\GapCloserEngine.lua          -> movement-injectie leest MONK_1/MONK_3
--     gap-closer-lijsten (Roll/Chi Torpedo/Flying Serpent Kick).
--   * JustAC\Data\SpellArchetypes.lua     -> builders/spenders per spec
--     (Keg Smash/Tiger Palm/Blackout Kick/Breath of Fire/Rising Sun Kick/
--     Fists of Fury/Spinning Crane Kick/Rushing Jade Wind).
--   * ClassCodex\Data\Monk\guide.lua      -> rotatie-cross-ref (Chi Burst,
--     Rushing Jade Wind, Whirling Dragon Punch, Zenith).
--   * docs\KEYBIND_MAP_DRAFT_rogue_monk_druid.md -> v6 keybind-layout cross-ref
--     (bindKey-toewijzingen, spec-specifieke Fortifying-Brew-varianten).
--
-- REGELS toegepast:
--   * Expel Harm = heal_quick (F2). Vivify = heal_ooc (F3). NIET F4.
--   * NIET opgenomen: Recuperate (globaal F4), heal_sustain/F4, racials,
--     trinkets, potions, zuivere passieven.
--   * Baseline (geen specs=): Roll, Paralysis, Fortifying Brew, Expel Harm,
--     Vivify, Tiger Palm, Blackout Kick, Detox, Transcendence: Transfer.
--     Leg Sweep is baseline (alle 3 specs). Spear Hand Strike = {268,269}.
--
-- NEVER-LIE-NOTITIES (addon-data zegt letterlijk):
--   * MW-interrupt: JustAC InterruptAbilities.lua bevat GEEN Mistweaver-kick;
--     Spear Hand Strike is expliciet {268,269} -> MW krijgt GEEN interrupt.
--   * Expel Harm bij MW: JustAC-comment "Expel Harm removed in 12.0" (MONK_2
--     bevat 322101 NIET). De taak vereist echter Expel Harm(F2) ook voor MW;
--     opgenomen als baseline (alle 3 specs) conform taak, met deze notitie.
--   * Storm, Earth, and Fire: JustAC MONK_3 gebruikt nog 137639 "Storm, Earth,
--     and Fire". De draft-doc vermoedt vervanging door "Zenith" (1249625, alleen
--     ClassCodex-rotatietekst). Hier gevolgd: addon-bevestigde naam SEF.
-- =====================================================================

ns.KeybindRoleClassifier.MONK = {

    -- =================================================================
    -- BREWMASTER (268)  -- tank
    -- =================================================================
    -- Builders / rotatie (SpellArchetypes: Keg Smash/Tiger Palm/Blackout Kick)
    ["Keg Smash"]                    = { category = "main_rotation", priority = 1, specs = { 268 } }, -- 1: AoE-builder + snare
    -- Actieve mitigation (Stagger purge, verbruikt brew-charges)
    ["Purifying Brew"]               = { category = "defensive", priority = 1, specs = { 268 } },     -- 4: purge Stagger (actieve mitigation, GEEN dmg-spender)
    -- AoE
    ["Breath of Fire"]               = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 268 } }, -- AoE/DoT (cleave)
    ["Rushing Jade Wind"]            = { category = "main_rotation", priority = 7, bindKey = "Shift+3", specs = { 268 } }, -- AoE (talent)
    -- Kleine defensive (absorb-shield)
    ["Celestial Brew"]               = { role = "defensive_1", priority = 1, specs = { 268 } },       -- Z: absorb (MONK_1)
    -- Extra CD's
    ["Weapons of Order"]             = { category = "cooldown", priority = 2, specs = { 268 } },      -- MONK_1 grootste-CD-lijst (120s)
    ["Exploding Keg"]                = { category = "cooldown", priority = 3, specs = { 268 } },      -- MONK_1 burst-CD (60s)
    -- Grootste CD (F1)
    ["Invoke Niuzao, the Black Ox"]  = { role = "cooldown_bar", priority = 1, specs = { 268 } },      -- F1: tank-CD (celestial)
    -- Taunt / utility
    ["Provoke"]                      = { category = "taunt", priority = 1, specs = { 268 } }, -- F: taunt (eigen kaart)

    -- =================================================================
    -- WINDWALKER (269)  -- melee-dps
    -- =================================================================
    -- Builders / rotatie (SpellArchetypes)
    ["Fists of Fury"]                = { category = "spender", priority = 1, specs = { 269 } },       -- 4: channeled finisher
    ["Spinning Crane Kick"]          = { category = "main_rotation", priority = 3, bindKey = "Shift+2", specs = { 269 } }, -- AoE-builder (ook ST-relevant)
    ["Whirling Dragon Punch"]        = { category = "main_rotation", priority = 8, specs = { 269 } }, -- burst-window-nuke (guide.lua {152175})
    -- Movement (Q vervangt Roll bij talent)
    ["Chi Torpedo"]                  = { role = "utility_primary", priority = 2, specs = { 269 } },   -- Shift+Q (MONK_3 gap-closer, vervangt Roll)
    ["Flying Serpent Kick"]          = { role = "utility_secondary", priority = 1, specs = { 269 } }, -- F: movement/gap-closer (MONK_3)
    -- Kleine defensive
    ["Touch of Karma"]               = { role = "defensive_1", priority = 1, specs = { 269 } },       -- Z: dmg-redirect (MONK_3)
    -- Extra defensive (talent)
    ["Diffuse Magic"]                = { category = "defensive", priority = 3, specs = { 269 } },     -- Shift+Z (MONK_3)
    -- Grootste CD (F1) + extra CD
    ["Invoke Xuen, the White Tiger"] = { role = "cooldown_bar", priority = 1, specs = { 269 } },      -- F1: WW-celestial (MONK_3 burst-CD)
    ["Storm, Earth, and Fire"]       = { category = "cooldown", priority = 2, specs = { 269 } },      -- MONK_3 grootste-CD-lijst (137639, 90s)

    -- =================================================================
    -- MISTWEAVER (270)  -- healer
    -- ST-heals (Soothing/Renewing/Enveloping Mist) lopen via mouseover/
    -- click-cast en staan bewust NIET op toets-slots. Hieronder: damage /
    -- utility / dispel / defensives + F2/F3 + raid-heal-CD's op CD-slots.
    -- =================================================================
    -- Damage-rotatie (SpellArchetypes: Rising Sun Kick) -- Fistweaving-damage BLIJFT main_rotation
    ["Rising Sun Kick"]              = { category = "main_rotation", priority = 3, specs = { 269, 270 } }, -- WW-builder (2) + MW-damage (3)
    -- -----------------------------------------------------------------
    -- ST-HEALS + ST-HoTs -> click_cast (mouseover/click-cast, GEEN toets)
    -- v6 6: single-target smart-heals lopen via mouseover-frames.
    -- (Vivify staat als baseline heal_ooc; geldt ook voor MW.)
    -- -----------------------------------------------------------------
    ["Enveloping Mist"]              = { role = "click_cast", priority = 1, specs = { 270 } },        -- ST-HoT (grote channel-heal, mouseover)
    ["Soothing Mist"]                = { role = "click_cast", priority = 1, specs = { 270 } },        -- ST channel-heal (mouseover)
    ["Renewing Mist"]                = { role = "click_cast", priority = 1, specs = { 270 } },        -- ST-HoT (springt naar laagste, mouseover)
    ["Sheilun's Gift"]               = { role = "click_cast", priority = 1, specs = { 270 } },        -- grote ST/smart-heal (verplaatst van spender -> click_cast)
    -- -----------------------------------------------------------------
    -- RAID/AoE-heals -> toets-slots
    -- -----------------------------------------------------------------
    ["Essence Font"]                 = { category = "raid_heal", priority = 1, specs = { 270 } },       -- primaire AoE-raid-heal (Mana-Tea)
    ["Refreshing Jade Wind"]         = { category = "raid_heal", priority = 2, specs = { 270 } }, -- AoE-HoT rond speler (talent)
    ["Jadefire Stomp"]               = { category = "raid_heal", priority = 3, specs = { 270 } }, -- AoE damage+heal ground-slam (talent)
    -- Rotationeel-versterkende utility
    ["Thunder Focus Tea"]            = { category = "utility", priority = 6, bindKey = "Shift+1", specs = { 270 } }, -- versterkt volgende cast (healing-CD, geen directe heal)
    -- Movement / utility
    ["Transcendence: Transfer"]      = { role = "utility_primary", priority = 2, specs = { 270 } },   -- Shift+Q: teleport-terug
    -- Kleine externe defensive
    ["Life Cocoon"]                  = { role = "defensive_1", priority = 1, specs = { 270 } },       -- Z: extern shield (SpellCategories)
    -- -----------------------------------------------------------------
    -- HEAL-COOLDOWNS -> cooldown-slots (grootste = cooldown_bar)
    -- -----------------------------------------------------------------
    ["Revival"]                      = { role = "cooldown_bar", priority = 1, specs = { 270 } },      -- F1/C: AoE raid-heal + dispel (grootste CD)
    ["Invoke Chi-Ji, the Red Crane"] = { category = "cooldown", priority = 2, specs = { 270 } },     -- celestial raid-heal (Ctrl+F1)
    ["Invoke Yu'lon, the Jade Serpent"] = { category = "cooldown", priority = 3, specs = { 270 } },  -- celestial raid-heal-CD (alt van Chi-Ji)
    ["Zen Meditation"]               = { category = "cooldown", priority = 4, specs = { 270 } },      -- channel-damage-reductie-CD (SpellCategories defensive/CD)
    -- Dispel / CC
    ["Detox"]                        = { category = "dispel_cc", priority = 1, specs = { 270 } },     -- V: magic/poison/disease dispel
    ["Ring of Peace"]                = { category = "dispel_cc", priority = 2, specs = { 270 } },     -- Shift+V: displacement-CC

    -- =================================================================
    -- GEDEELD (meerdere Monk-specs, geen 3-way-baseline)
    -- =================================================================
    ["Spear Hand Strike"]            = { role = "interrupt", priority = 1, specs = { 268, 269 } },    -- E: interrupt; BM+WW (MW heeft geen kick)
    ["Leg Sweep"]                    = { category = "dispel_cc", priority = 2 },                      -- Shift+V: AoE-stun (alle 3 specs)

    -- =================================================================
    -- BASELINE (alle 3 Monk-specs; geen specs=)
    -- =================================================================
    -- Rotatie-basis (BM 2 / MW 1 / WW 1)
    ["Tiger Palm"]                   = { category = "main_rotation", priority = 1 }, -- meest-voorkomend p1
    ["Blackout Kick"]                = { category = "main_rotation", priority = 3 }, -- BM builder / MW filler / WW spender -> meest voorkomend main_rotation
    -- Movement
    ["Roll"]                         = { role = "utility_primary", priority = 1 }, -- Q: gap-closer (SpellCategories + gap-closer-lijsten)
    -- Self-heals
    ["Expel Harm"]                   = { role = "heal_quick", priority = 1 }, -- F2: snelle self-heal (SpellArchetypes 115129 + MONK/MONK_1/MONK_3 322101). MW: JustAC-comment "removed in 12.0"
    ["Vivify"]                       = { role = "heal_ooc", priority = 1 },  -- F3: out-of-combat/direct heal (SpellCategories 116670)
    -- Grote defensive
    ["Fortifying Brew"]              = { role = "defensive_3", priority = 1 }, -- C: grote defensive (115203 basis; 120954 BM / 201318 WW / 243435 MW-varianten, zelfde naam)
    -- CC / dispel
    ["Paralysis"]                    = { category = "dispel_cc", priority = 1 }, -- V (BM/WW) / F (MW): single-target incapacitate (InterruptAbilities)
    -- Utility
    ["Transcendence"]                = { category = "utility", priority = 3 }, -- plaats-anker (Transcendence: Transfer = MW-specifieke terugkeer)
}
