local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- =====================================================================
-- ROGUE keybind-rol-classifier (WoW Midnight, Midnight Helper)
-- =====================================================================
-- VERVANGT de incomplete Rogue-sectie uit KeybindRoles_RogueMonkDruid.lua.
-- Volledige dekking van elke relevante ACTIEVE spell per spec.
--
-- Koppelen op spell-NAAM (exacte naam als key), niet op ID.
-- specs={<id>} = spec-specifiek. Geen specs = baseline (alle 3 specs).
-- specID's: Assassination 259, Outlaw 260, Subtlety 261.
--
-- Rollen (role):     interrupt, utility_primary, utility_secondary, mobility,
--                    defensive_1..4, cooldown_bar, heal_quick, heal_ooc.
-- Categorieen (cat): main_rotation, spender, utility, dispel_cc, cooldown,
--                    defensive.
--
-- Bronnen (rol HIERUIT afgeleid, geen giswerk):
--   * JustAC\Data\InterruptAbilities.lua  -> Kick (interrupt), Blind/Kidney
--     Shot/Cheap Shot/Gouge (cc).
--   * JustAC\Data\SpellCategories.lua      -> Feint/Evasion/Cloak of Shadows/
--     Crimson Vial (defensieven), Sap (cc), Sprint (movement),
--     Distract/Tricks of the Trade (utility).
--   * JustAC\SpellDB.lua                   -> ROGUE-defensives {185311 Crimson
--     Vial, 1966 Feint, 31224 Cloak of Shadows, 5277 Evasion}; gap-closers
--     ROGUE_1/2/3 {36554 Shadowstep, 195457 Grappling Hook, 2983 Sprint,
--     185438 Shadowstrike}; cooldown-lijsten ROGUE_1 {Deathmark}, ROGUE_2
--     {Adrenaline Rush, Killing Spree}, ROGUE_3 {Shadow Blades}; Stealth
--     {1784, 115191}, Vanish {1856}.
--   * JustAC\Data\SpellArchetypes.lua      -> builders/spenders per spec.
--   * docs\KEYBIND_MAP_DRAFT_rogue_monk_druid.md -> v6 keybind-layout cross-ref.
--
-- REGELS toegepast:
--   * Crimson Vial = heal_quick (F2). NIET F4. F4 = globale Recuperate ->
--     bewust NIET opgenomen.
--   * NIET opgenomen: Recuperate (globaal F4), heal_sustain/F4, racials,
--     trinkets, potions, zuivere passieven, pre-combat poison-toepassing.
--   * Baseline (geen specs=): Kick, Sprint, Crimson Vial, Feint, Cloak of
--     Shadows, Evasion, Blind, Kidney Shot, Vanish, Cheap Shot, Gouge, Sap,
--     Distract, Tricks of the Trade, Stealth.
-- =====================================================================

ns.KeybindRoleClassifier.ROGUE = {

    -- =================================================================
    -- ASSASSINATION (259)
    -- =================================================================
    -- Builders / DoT-onderhoud
    ["Mutilate"]         = { category = "main_rotation", priority = 1, specs = { 259 } },
    ["Shiv"]             = { category = "dispel_cc", priority = 2, specs = { 259 } }, -- offensive dispel (enrage/magic), geen builder
    ["Garrote"]          = { category = "main_rotation", priority = 3, specs = { 259 } },
    -- Spenders (finishers)
    ["Envenom"]          = { category = "spender", priority = 1, specs = { 259 } },
    ["Rupture"]          = { category = "spender", priority = 2, specs = { 259 } },
    -- AoE
    ["Fan of Knives"]    = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 259 } }, -- AoE builder
    ["Crimson Tempest"]  = { category = "spender", priority = 7, bindKey = "Shift+5", specs = { 259 } },       -- AoE spender (bleed-spread)
    -- Cooldowns
    ["Deathmark"]        = { role = "cooldown_bar", priority = 1, specs = { 259 } }, -- grootste CD (F1, 2 min)
    ["Kingsbane"]        = { category = "cooldown", priority = 2, specs = { 259 } }, -- extra CD (Shift+F1, 1 min)

    -- =================================================================
    -- OUTLAW (260)
    -- =================================================================
    -- Builders
    ["Sinister Strike"]  = { category = "main_rotation", priority = 1, specs = { 260 } },
    ["Pistol Shot"]      = { category = "main_rotation", priority = 2, specs = { 260 } },
    ["Roll the Bones"]   = { category = "main_rotation", priority = 3, specs = { 260 } }, -- builder/buff (4-stage)
    -- Spenders (finishers)
    ["Between the Eyes"] = { category = "spender", priority = 1, specs = { 260 } }, -- finisher/stun
    ["Dispatch"]         = { category = "spender", priority = 2, specs = { 260 } },
    -- AoE
    ["Blade Flurry"]     = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 260 } }, -- cleave-toggle
    -- Movement (Outlaw-exclusief)
    ["Grappling Hook"]   = { role = "utility_primary", priority = 1, specs = { 260 } },
    -- Cooldowns
    ["Adrenaline Rush"]  = { role = "cooldown_bar", priority = 1, specs = { 260 } }, -- grootste CD (F1)
    ["Killing Spree"]    = { category = "cooldown", priority = 2, specs = { 260 } }, -- extra CD (Shift+F1)
    ["Keep It Rolling"]  = { category = "cooldown", priority = 3, specs = { 260 } }, -- herrolt RtB (Ctrl+F1; talent)

    -- =================================================================
    -- SUBTLETY (261)
    -- =================================================================
    -- Builders
    ["Shadowstrike"]     = { category = "main_rotation", priority = 1, specs = { 261 } }, -- vanuit Stealth/Shadow Dance
    ["Backstab"]         = { category = "main_rotation", priority = 2, specs = { 261 } }, -- buiten Shadow Dance
    ["Secret Technique"] = { category = "main_rotation", priority = 3, specs = { 261 } }, -- spender/CD-hybride
    -- Spenders (finishers)
    ["Eviscerate"]       = { category = "spender", priority = 1, specs = { 261 } }, -- kern-finisher
    ["Mark for Death"]   = { category = "utility", priority = 2, specs = { 261 } }, -- combo-point enabler, geen directe damage-spender
    -- AoE
    ["Shuriken Storm"]   = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 261 } }, -- AoE builder
    ["Black Powder"]     = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 261 } },       -- AoE spender (3+)
    -- Cooldowns
    ["Shadow Dance"]     = { role = "cooldown_bar", priority = 1, specs = { 261 } }, -- grootste CD (F1, definierend)
    ["Shadow Blades"]    = { category = "cooldown", priority = 2, specs = { 261 } }, -- extra CD (Shift+F1, 90s)

    -- =================================================================
    -- BASELINE (alle 3 Rogue-specs; geen specs=)
    -- =================================================================
    -- Interrupt
    ["Kick"]             = { role = "interrupt", priority = 1 },
    -- Movement / gap-closers
    ["Sprint"]           = { role = "utility_primary", priority = 1 },                     -- Q op Assa/Sub; Shift+Q op Outlaw
    ["Shadowstep"]       = { role = "utility_primary", priority = 1, specs = { 259, 261 } }, -- gap-closer; niet Outlaw (heeft Grappling Hook)
    -- Self-heal
    ["Crimson Vial"]     = { role = "heal_quick", priority = 1 }, -- F2 primaire combat self-heal (instant HoT). NIET F4.
    -- Kleine defensive
    ["Feint"]            = { role = "defensive_1", priority = 1 }, -- kleine def (AoE dmg-reductie)
    -- Grote defensieven
    ["Cloak of Shadows"] = { role = "defensive_3", priority = 1 }, -- magic immunity
    ["Evasion"]          = { role = "defensive_3", priority = 2 }, -- dodge (grote def)
    -- Dispel / CC
    ["Blind"]            = { category = "dispel_cc", priority = 1 }, -- disorient
    ["Kidney Shot"]      = { category = "dispel_cc", priority = 2 }, -- finisher-stun
    ["Cheap Shot"]       = { category = "dispel_cc", priority = 3 }, -- stun vanuit stealth
    ["Sap"]              = { category = "dispel_cc", priority = 4 }, -- incapacitate (uit combat/stealth)
    ["Gouge"]            = { category = "dispel_cc", priority = 5 }, -- incapacitate (frontaal)
    -- Utility
    ["Vanish"]           = { category = "cooldown", priority = 1 },                   -- stealth-CD (reset/opener), geen zuivere utility
    ["Stealth"]          = { category = "utility", priority = 2 },                    -- pre-pull/openers
    ["Distract"]         = { category = "utility", priority = 3 },                    -- misdirect/aggro
    ["Tricks of the Trade"] = { category = "utility", priority = 4 },                 -- threat transfer
}
