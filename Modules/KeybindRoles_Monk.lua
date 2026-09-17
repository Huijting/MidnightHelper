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
--   * Baseline (geen specs=): Roll, Paralysis, Fortifying Brew, Vivify,
--     Tiger Palm, Blackout Kick.
--     (Expel Harm is sinds 17 sep { 268, 269 }; Detox is { 270 }.)
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
--     -> 17 sep: SEF is verwijderd (weg in 12.0.0; Zenith heeft geen entry).
--
-- ---------------------------------------------------------------------
-- STAY ALIVE CARD (17 Sep 2026)
-- ---------------------------------------------------------------------
-- `survival`, `survivalOrder`, `survivalNote` and `survivalId` feed only
-- Modules/SurvivalPlan.lua; role/category/priority/bindKey are untouched.
-- Every tag follows docs/audit_2026-09-17/audit_druid_monk.md (warcraft.wiki.gg,
-- Icy Veins/Method 12.1). Purifying Brew is the Brewmaster keep-up (used on a
-- rhythm); Celestial Brew (1.5 min absorb since 12.1) and Touch of Karma
-- (1.5 min) are small buttons, not keep-ups. Life Cocoon is on the card as a
-- big button you cast on yourself (it is mainly an external).
-- Left OFF the card on purpose: Transcendence (places the anchor; only
-- Transcendence: Transfer gets you away).
-- Removed 17 Sep, gone in 11.x/12.x (BRON in the audit): Weapons of Order,
-- Storm, Earth, and Fire, Diffuse Magic (now passive on Fortifying Brew),
-- Essence Font, Refreshing Jade Wind, Zen Meditation. Dampen Harm had no entry.
-- Specs changed 17 Sep: Expel Harm is gone for Mistweaver -> { 268, 269 };
-- Chi Torpedo and Transcendence: Transfer are class talents; their `specs` stay as they were
-- (no key moves) and `survivalSpecs` shows them on every spec's card.
-- =====================================================================

ns.KeybindRoleClassifier.MONK = {

    -- =================================================================
    -- BREWMASTER (268)  -- tank
    -- =================================================================
    -- Builders / rotatie (SpellArchetypes: Keg Smash/Tiger Palm/Blackout Kick)
    ["Keg Smash"]                    = { category = "main_rotation", priority = 1, specs = { 268 } }, -- 1: AoE-builder + snare
    -- Actieve mitigation (Stagger purge, verbruikt brew-charges)
    ["Purifying Brew"]               = { category = "defensive", priority = 1, specs = { 268 }, survival = "keepup", survivalOrder = 1 }, -- 4: purge Stagger (actieve mitigation, GEEN dmg-spender); card: on a rhythm (IV BM)
    -- AoE
    ["Breath of Fire"]               = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 268 } }, -- AoE/DoT (cleave)
    ["Rushing Jade Wind"]            = { category = "main_rotation", priority = 7, bindKey = "Shift+3", specs = { 268 } }, -- AoE (talent)
    -- Kleine defensive (absorb-shield)
    ["Celestial Brew"]               = { role = "defensive_1", priority = 1, specs = { 268 }, survival = "small", survivalOrder = 1 }, -- Z: absorb (MONK_1); card: 8 s on 1.5 min (wiki)
    -- Extra CD's (Weapons of Order verwijderd 17 sep: weg in 12.0.0, wiki)
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
    -- Chi Torpedo: klassentalent (audit); toetsen blijven { 269 }, de kaart toont hem bij alle specs.
    ["Chi Torpedo"]                  = { role = "utility_primary", priority = 2, specs = { 269 }, survivalSpecs = { 268, 269, 270 }, survival = "escape", survivalOrder = 2 }, -- Shift+Q (MONK_3 gap-closer, vervangt Roll)
    ["Flying Serpent Kick"]          = { role = "utility_secondary", priority = 1, specs = { 269 }, survival = "escape", survivalOrder = 3 }, -- F: movement/gap-closer (MONK_3)
    -- Kleine defensive
    ["Touch of Karma"]               = { role = "defensive_1", priority = 1, specs = { 269 }, survival = "small", survivalOrder = 1 }, -- Z: dmg-redirect (MONK_3); card: 10 s on 1.5 min, before a big hit (Method)
    -- Diffuse Magic: verwijderd 17 sep (sinds 12.0 passief via Fortifying Brew, wiki/IV WW).
    -- Grootste CD (F1)
    ["Invoke Xuen, the White Tiger"] = { role = "cooldown_bar", priority = 1, specs = { 269 } },      -- F1: WW-celestial (MONK_3 burst-CD)
    -- Storm, Earth, and Fire: verwijderd 17 sep (weg in 12.0.0, vervangen door Zenith; wiki).

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
    -- Essence Font (weg in 11.0.0) en Refreshing Jade Wind (weg in 12.0.0): verwijderd 17 sep (wiki).
    ["Jadefire Stomp"]               = { category = "raid_heal", priority = 3, specs = { 270 } }, -- AoE damage+heal ground-slam (talent)
    -- Rotationeel-versterkende utility
    ["Thunder Focus Tea"]            = { category = "utility", priority = 6, bindKey = "Shift+1", specs = { 270 } }, -- versterkt volgende cast (healing-CD, geen directe heal)
    -- Movement / utility
    -- Transcendence: Transfer: klassentalent (audit); toetsen blijven { 270 }, de kaart toont hem bij alle specs.
    ["Transcendence: Transfer"]      = { role = "utility_primary", priority = 2, specs = { 270 }, survivalSpecs = { 268, 269, 270 }, survival = "escape", survivalOrder = 4 }, -- Shift+Q: teleport-terug
    -- Kleine externe defensive
    ["Life Cocoon"]                  = { role = "defensive_1", priority = 1, specs = { 270 }, survival = "big", survivalOrder = 1, survivalNote = "SURVIVAL_NOTE_SELF_CAST" }, -- Z: extern shield (SpellCategories); card: 12 s on 2 min (wiki)
    -- -----------------------------------------------------------------
    -- HEAL-COOLDOWNS -> cooldown-slots (grootste = cooldown_bar)
    -- -----------------------------------------------------------------
    ["Revival"]                      = { role = "cooldown_bar", priority = 1, specs = { 270 } },      -- F1/C: AoE raid-heal + dispel (grootste CD)
    ["Invoke Chi-Ji, the Red Crane"] = { category = "cooldown", priority = 2, specs = { 270 } },     -- celestial raid-heal (Ctrl+F1)
    ["Invoke Yu'lon, the Jade Serpent"] = { category = "cooldown", priority = 3, specs = { 270 } },  -- celestial raid-heal-CD (alt van Chi-Ji)
    -- Zen Meditation: verwijderd 17 sep (geen MW-spell, weg in 11.2.0; wiki).
    -- Dispel / CC
    ["Detox"]                        = { category = "dispel_cc", priority = 1, specs = { 270 } },     -- V: magic/poison/disease dispel
    ["Ring of Peace"]                = { category = "dispel_cc", priority = 2, specs = { 270 } },     -- Shift+V: displacement-CC

    -- =================================================================
    -- GEDEELD (meerdere Monk-specs, geen 3-way-baseline)
    -- =================================================================
    ["Spear Hand Strike"]            = { role = "interrupt", priority = 1, specs = { 268, 269 }, survival = "interrupt", survivalOrder = 1 }, -- E: interrupt; BM+WW (MW heeft geen kick)
    ["Leg Sweep"]                    = { category = "dispel_cc", priority = 2, alsoStop = "stun" },                      -- Shift+V: AoE-stun (alle 3 specs); JustAC 119381 mech=12 → Spec 08

    -- =================================================================
    -- BASELINE (alle 3 Monk-specs; geen specs=)
    -- =================================================================
    -- Rotatie-basis (BM 2 / MW 1 / WW 1)
    ["Tiger Palm"]                   = { category = "main_rotation", priority = 1 }, -- meest-voorkomend p1
    ["Blackout Kick"]                = { category = "main_rotation", priority = 3 }, -- BM builder / MW filler / WW spender -> meest voorkomend main_rotation
    -- Movement
    ["Roll"]                         = { role = "utility_primary", priority = 1, survival = "escape", survivalOrder = 1 }, -- Q: gap-closer (SpellCategories + gap-closer-lijsten)
    -- Self-heals
    -- Expel Harm: was baseline, nu { 268, 269 } sinds 17 sep (weg voor MW in 12.0.0, wiki/Method).
    ["Expel Harm"]                   = { role = "heal_quick", priority = 1, specs = { 268, 269 }, survival = "heal", survivalOrder = 1 }, -- F2: snelle self-heal (SpellArchetypes 115129 + MONK/MONK_1/MONK_3 322101)
    ["Vivify"]                       = { role = "heal_ooc", priority = 1, survival = "heal", survivalOrder = 2 }, -- F3: out-of-combat/direct heal (SpellCategories 116670)
    -- Grote defensive
    ["Fortifying Brew"]              = { role = "defensive_3", priority = 1, survival = "big", survivalOrder = 2 }, -- C: grote defensive (115203 basis; 120954 BM / 201318 WW / 243435 MW-varianten, zelfde naam); card: 6 min (Wowhead), after Life Cocoon
    ["Touch of Death"]               = { category = "cooldown", priority = 4 }, -- iconische baseline execute-CD, alle specs (JustAC SpellCooldowns 322109=180s; SimC WW core)
    -- CC / dispel
    ["Paralysis"]                    = { category = "dispel_cc", priority = 1, alsoStop = "incap" }, -- V (BM/WW) / F (MW): single-target incapacitate (InterruptAbilities 115078 mech=14)
    -- Utility
    ["Transcendence"]                = { category = "utility", priority = 3 }, -- plaats-anker (Transcendence: Transfer = de terugkeer); NOT on the card: Transfer is the escape
}
