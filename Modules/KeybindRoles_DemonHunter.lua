local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- v6 keybind role classifier: DEMONHUNTER. Spell NAME -> role/category mapping.
-- FULL rebuild (replaces the incomplete DH section of KeybindRoles_WarDkDhEvoker.lua).
-- Keyed on EXACT in-game spell name; the addon matches against the live spellbook.
-- specID's: Havoc 577, Vengeance 581, Devourer 1480 (Midnight 12.0.7 Void Int-caster DPS;
--   verified via wago.tools ChrSpecialization, OrderIndex 2 = spec-index 3).
--
-- Roles/categories are DERIVED FROM ADDON DATA (never-lie), not guesswork:
--   * interrupt / CC  : JustAC Data/InterruptAbilities.lua (Disrupt 183752 kind="interrupt";
--                       Chaos Nova 179057, Fel Eruption 211881 kind="cc")
--                       + Data/SpellCategories.lua CROWD_CONTROL_SPELLS
--                       (179057/183752/211881/217832/207684/202137).
--   * defensives+tier : JustAC SpellDB.lua DEFENSE_TIER (tier2 = grote def:
--                       Fiery Brand 204021) + Data/SpellCategories.lua DEFENSIVE_SPELLS
--                       (187827 Metamorphosis-Veng, 196555 Netherwalk, 198589 Blur,
--                       203720 Demon Spikes, 204021 Fiery Brand) + SpellDB fallback
--                       DEMONHUNTER = {198589 Blur, 196718 Darkness}.
--   * self-heals      : GEEN dedicated self-heal. Soul Cleave (228477) is DEFENSE_TIER tier2
--                       maar het is Vengeance' rotatie-spender (spender-heal, zoals Death
--                       Strike), geen los heal-anker. Leech is passief. -> heal_quick /
--                       heal_ooc bewust LEEG (never-lie: niks verzinnen op F2/F3).
--   * rotatie/AoE     : JustAC Data/SpellArchetypes.lua (162794 Chaos Strike, 201427
--                       Annihilation, 188499 Blade Dance, 210152 Death Sweep, 198013 Eye
--                       Beam, 185123 Throw Glaive, 258920 Immolation Aura, 263642 Fracture,
--                       228477 Soul Cleave, 247454 Spirit Bomb, ...) + ClassCodex
--                       Data/DemonHunter/guide.lua rotation steps (havoc + vengeance).
--   * movement        : JustAC SpellDB.lua CLASS_GAP_CLOSER_DEFAULTS
--                       DEMONHUNTER_1 = {195072 Fel Rush, 232893 Felblade},
--                       DEMONHUNTER_2 = {189110 Infernal Strike}; Vengeful Retreat 198793
--                       (backward jump, both specs per guide.lua) + RangeReferences 232893.
--   * grote CD        : SpellDB CLASS_BURST_TRIGGER_DEFAULTS DEMONHUNTER_1 = {191427
--                       Metamorphosis} / _2 = {187827}, CLASS_..._THE_HUNT
--                       DEMONHUNTER_1/2 = {370965 The Hunt}.
--   * utility         : JustAC Data/SpellCategories.lua UTILITY_SPELLS (185245 Torment,
--                       131347 Glide, 202138 Sigil of Chains) + guide.lua.
--
-- Baseline (GEEN specs; BEIDE specs 577+581): Disrupt, Vengeful Retreat, Chaos Nova,
--   Imprison, Consume Magic, Torment, Immolation Aura, Felblade, The Hunt, Sigil of Misery,
--   Spectral Sight, Glide.

ns.KeybindRoleClassifier.DEMONHUNTER = {
	--==============================================================
	-- BASELINE (beide specs 577+581) - geen specs = {}
	--==============================================================
	-- Interrupt (InterruptAbilities [183752] kind="interrupt" pri=1; SpellCategories CC)
	["Disrupt"]            = { role = "interrupt", priority = 1 },

	-- Movement / utility_primary (GAP_CLOSER + guide.lua both specs)
	["Vengeful Retreat"]   = { role = "utility_primary", priority = 2, bindKey = "Shift+Q" }, -- backward jump (guide.lua havoc + venge)
	["Felblade"]           = { role = "utility_primary", priority = 3, bindKey = "Ctrl+Q" },  -- gap-closer/builder (GAP_CLOSER 232893; RangeReferences)
	["Fel Rush"]           = { role = "utility_primary", priority = 1, specs = { 577 } },     -- Havoc kern-movement/dash (GAP_CLOSER DEMONHUNTER_1 = 195072; ontbrak, toegevoegd)
	["Infernal Strike"]    = { role = "utility_primary", priority = 1, specs = { 581 } },     -- Vengeance kern-movement/gap-closer (GAP_CLOSER DEMONHUNTER_2 = 189110; ontbrak, toegevoegd)

	-- Grote CD / cooldown_bar F1 (SpellDB THE_HUNT DEMONHUNTER_1/2 = {370965})
	["The Hunt"]           = { role = "cooldown_bar", priority = 2, bindKey = "Shift+F1" }, -- baseline major CD (beide specs)

	-- CC / dispel_cc (InterruptAbilities 179057/211881; SpellCategories CROWD_CONTROL)
	["Chaos Nova"]         = { category = "dispel_cc", priority = 1 },                       -- AoE stun (InterruptAbilities kind="cc" mech=12)
	["Sigil of Misery"]    = { category = "dispel_cc", priority = 2, bindKey = "Shift+V" },  -- AoE fear (SpellCategories 207684; beide specs)
	["Imprison"]           = { category = "dispel_cc", priority = 3, bindKey = "Ctrl+V" },   -- cage (SpellCategories 217832)
	["Consume Magic"]      = { category = "dispel_cc", priority = 4 },                       -- offensieve magic-dispel (SpellArchetypes 1277738; beide specs)

	-- Utility (SpellCategories UTILITY 185245 Torment / 131347 Glide)
	["Torment"]            = { category = "taunt", priority = 1 }, -- F: taunt (baseline; eigen kaart)
	["Spectral Sight"]     = { category = "utility", priority = 5 },       -- see-through-walls utility (baseline)
	["Glide"]              = { category = "utility", priority = 8 },       -- val-vertraging (SpellCategories UTILITY 131347)

	--==============================================================
	-- HAVOC (577)
	--==============================================================
	-- Builders / kernrotatie (SpellArchetypes 162794/201427/198013/258920; guide.lua havoc)
	["Demon's Bite"]      = { category = "main_rotation", priority = 1, specs = { 577 } }, -- fury-builder (baseline Havoc generator; Felblade-alt buiten meta)
	["Chaos Strike"]      = { category = "main_rotation", priority = 2, specs = { 577 } }, -- fury-spender ST (SpellArchetypes 162794; guide.lua {162794})
	["Annihilation"]      = { category = "main_rotation", priority = 2, specs = { 577 } }, -- Meta-vorm van Chaos Strike (SpellArchetypes 201427; guide.lua {201427})
	["Immolation Aura"]   = { category = "main_rotation", priority = 3 },                  -- AoE + fury (SpellArchetypes 258920; BEIDE specs -> geen specs-tag)
	["Eye Beam"]          = { category = "main_rotation", priority = 4, specs = { 577 } }, -- channel + Meta-trigger (SpellArchetypes 198013; guide.lua {198013})
	-- Spenders (guide.lua {185123} ranged filler)
	["Throw Glaive"]      = { category = "spender", priority = 1, specs = { 577 } },       -- ranged filler-spender (SpellArchetypes 185123; guide.lua {185123})
	-- AoE (guide.lua {188499}/{210152} Blade Dance/Death Sweep; Shift+N-anker)
	["Blade Dance"]       = { category = "main_rotation", priority = 6, bindKey = "Shift+4", specs = { 577 } }, -- AoE (SpellArchetypes 188499; guide.lua {188499})
	["Death Sweep"]       = { category = "main_rotation", priority = 6, bindKey = "Shift+4", specs = { 577 } }, -- Meta-vorm van Blade Dance (SpellArchetypes 210152; guide.lua {210152})
	-- Kleine def (SpellCategories DEFENSIVE 198589; SpellDB fallback DEMONHUNTER {198589,...})
	["Blur"]              = { role = "defensive_1", priority = 1, specs = { 577, 1480 } }, -- 20% dodge + DR (SpellCategories 198589; JustAC SpellDB DEMONHUNTER {198589,196718} = class-baseline -> ook Devourer, Icy Veins bevestigt)
	-- Grote def (SpellDB fallback DEMONHUNTER {198589,196718}; Darkness = raid-wall)
	["Darkness"]          = { role = "defensive_3", priority = 1, specs = { 577 } },       -- AoE avoidance-koepel (SpellDB DEMONHUNTER 196718)
	["Netherwalk"]        = { category = "defensive", priority = 2, specs = { 577 } },     -- DR + immuniteit (SpellCategories DEFENSIVE 196555; talent-alt van Blur)
	-- Grootste CD / cooldown_bar F1 (SpellDB BURST DEMONHUNTER_1 = {191427})
	["Metamorphosis"]     = { role = "cooldown_bar", priority = 1, specs = { 577 } },      -- Havoc burst-vorm (SpellDB DEMONHUNTER_1 191427)
	-- Extra CD's (guide.lua {258860} Essence Break Fel-Scarred; {213241} Sigil of Doom; {442294} Reaver's Glaive)
	["Essence Break"]     = { category = "cooldown", priority = 3, specs = { 577 } },      -- burst-window-talent (SpellArchetypes 258860; guide.lua {258860})
	["Sigil of Doom"]     = { category = "main_rotation", priority = 5, specs = { 577 } }, -- Fel-Scarred sigil-proc (SpellArchetypes 213241; guide.lua {213241})
	["Reaver's Glaive"]   = { category = "cooldown", priority = 4, specs = { 577 } },      -- Aldrachi Reaver-buffvenster (SpellArchetypes 442294; guide.lua {442294})

	--==============================================================
	-- VENGEANCE (581)
	--==============================================================
	-- Builders / kernrotatie (SpellArchetypes 263642/204596; guide.lua vengeance)
	["Shear"]             = { category = "main_rotation", priority = 1, specs = { 581 } }, -- baseline fury+soul-builder (Fracture-alt zonder talent)
	["Fracture"]          = { category = "main_rotation", priority = 1, specs = { 581 } }, -- fury + 2 souls (SpellArchetypes 263642; guide.lua {263642})
	["Sigil of Flame"]    = { category = "main_rotation", priority = 3, specs = { 581 } }, -- AoE threat-builder (guide.lua {204596})
	-- Spender (SpellArchetypes/RangeReferences 228477; guide.lua {228477} heal+damage spender)
	["Soul Cleave"]       = { category = "spender", priority = 1, specs = { 581 } },       -- spender-heal (DEFENSE_TIER 228477 tier2, MAAR rotatie-spender -> geen los heal-anker; never-lie)
	-- AoE (guide.lua {247454} Spirit Bomb; Shift+N-anker)
	["Spirit Bomb"]       = { category = "spender", priority = 6, bindKey = "Shift+4", specs = { 581 } }, -- soul-spender AoE (SpellArchetypes 247454; guide.lua {247454})
	-- Kleine def (SpellCategories DEFENSIVE 203720; SpellDB DEMONHUNTER_2 mitigatie-lijst)
	["Demon Spikes"]      = { role = "defensive_1", priority = 1, specs = { 581 } },       -- armor + parry mitigatie (SpellCategories 203720)
	-- Grote def (DEFENSE_TIER 204021 = tier2; SpellCategories DEFENSIVE 187827)
	["Fiery Brand"]       = { role = "defensive_3", priority = 1, specs = { 581 } },       -- 40% DR-brand (DEFENSE_TIER 204021 tier2)
	["Metamorphosis (Vengeance)"] = { role = "defensive_3", priority = 2, bindKey = "Shift+C", specs = { 581 } }, -- health + armor wall (SpellCategories DEFENSIVE 187827)
	-- Extra def / major (SpellArchetypes 212084; guide.lua {212084} heal + AoE damage)
	["Fel Devastation"]   = { category = "defensive", priority = 4, specs = { 581 } },     -- heal-over-time + AoE (SpellArchetypes 212084; guide.lua {212084})
	-- Grootste CD's Vengeance (guide.lua {207407} Soul Carver; {390163} Sigil of Spite)
	["Soul Carver"]       = { category = "cooldown", priority = 3, bindKey = "Ctrl+F1", specs = { 581 } }, -- souls/burst-talent (SpellArchetypes 207407; guide.lua {207407})
	["Sigil of Spite"]    = { category = "cooldown", priority = 4, specs = { 581 } },      -- souls-burst sigil (SpellArchetypes 389860; guide.lua {390163})
	-- CC extra (SpellCategories UTILITY/CROWD 202138 Sigil of Chains; 211881 Fel Eruption)
	["Sigil of Chains"]   = { category = "dispel_cc", priority = 5, specs = { 581 } },     -- pull/knock (SpellCategories 202138)
	["Fel Eruption"]      = { category = "dispel_cc", priority = 6, specs = { 581 } },     -- single-target stun (InterruptAbilities 211881 kind="cc"; talent)

	--==============================================================
	-- DEVOURER (1480) — nieuwe Midnight 12.0.7 Void Int-caster DPS-spec.
	-- specID geverifieerd via wago.tools ChrSpecialization (OrderIndex 2 = spec-index 3)
	-- ÉN in-game bevestigd (Rob's dump): GetSpecializationInfo -> 1480 "Devourer", role DAMAGER.
	-- lvl-10 dump bevestigde ook Consume (473662) + Reap (1226019); hogere abilities komen bij levelen.
	-- Rollen AFGELEID (never-lie): ClassCodex Data/DemonHunter/guide.lua "devourer" rotation-
	-- stapvolgorde + JustAC Data/SpellCooldowns.lua & SpellArchetypes.lua (namen/CD/archetype);
	-- Wowhead spell-pages voor naamresolutie (473728 Void Ray, 1217607 Void Metamorphosis, ...).
	-- Baseline DH-spells (Disrupt/Vengeful Retreat/Felblade/Chaos Nova/The Hunt/Immolation Aura/
	-- Glide/... zonder specs) gelden AL voor Devourer; hieronder alleen de spec-eigen abilities.
	-- TODO(id): "Shift" (Devourer-dash 30yd/20s, Icy Veins + Wowhead bevestigen de NAAM) heeft nog
	--   geen geverifieerd spell-ID -> naam-keyed; vul id aan uit Rob's in-game spellbook-dump.
	--==============================================================
	-- Movement / utility_primary (Icy Veins: "Shift" = targeted 30yd dash, 20s CD, Devourer-signatuur)
	["Shift"]             = { role = "utility_primary", priority = 1, specs = { 1480 } },  -- naam-keyed (id volgt uit dump)
	-- Builders / kernrotatie (guide.lua devourer; JustAC SpellArchetypes "ranged")
	["Consume"]           = { id = 473662,  category = "main_rotation", priority = 1, specs = { 1480 } }, -- core builder/filler (SpellArchetypes 473662 "ranged"; guide.lua opener)
	["Voidblade"]         = { id = 1245412, category = "main_rotation", priority = 2, specs = { 1480 } }, -- rotational (SpellCooldowns 1245412=30000; guide.lua)
	["Hungering Slash"]   = { id = 1239123, category = "main_rotation", priority = 5, specs = { 1480 } }, -- AoE-builder (guide.lua multitarget)
	-- Spenders (Fury; guide.lua "at 84 fury" / 100-Fury-channel)
	["Reap"]              = { id = 1226019, category = "spender", priority = 1, specs = { 1480 } },       -- Fury-spender (SpellCooldowns 1226019=8000; guide.lua "at 84 fury")
	["Void Ray"]          = { id = 473728,  category = "spender", priority = 2, specs = { 1480 } },       -- 100-Fury-channel (SpellArchetypes 473728; guide.lua {473728})
	["Devour"]            = { id = 1217610, category = "spender", priority = 3, specs = { 1480 } },       -- Void-Meta-vorm spender (SpellArchetypes 1217610 "ranged"; guide.lua {1217610})
	["Eradicate"]         = { id = 1226033, category = "main_rotation", priority = 6, bindKey = "Shift+4", specs = { 1480 } }, -- AoE-spender (guide.lua multitarget)
	-- Cooldowns
	["Soul Immolation"]   = { id = 1241937, category = "cooldown", priority = 3, specs = { 1480 } },      -- 60s-CD setup/buff (SpellCooldowns 1241937=60000; SelfAuras 1241937)
	-- Grootste CD / cooldown_bar F1 (Void Metamorphosis = burst-vorm; soul-driven, geen timer)
	["Void Metamorphosis"] = { id = 1217607, role = "cooldown_bar", priority = 1, specs = { 1480 } },    -- burst-vorm (Wowhead 1217607; analoog aan Havoc Metamorphosis)
}
