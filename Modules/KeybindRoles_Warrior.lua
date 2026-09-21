local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

-- v6 keybind role classifier: WARRIOR. Spell NAME -> role/category mapping.
-- FULL rebuild (replaces the incomplete Warrior section of KeybindRoles_WarDkDhEvoker.lua).
-- Keyed on EXACT in-game spell name; the addon matches against the live spellbook.
-- specID's: Arms 71, Fury 72, Protection 73.
--
-- Roles/categories are DERIVED FROM ADDON DATA (never-lie), not guesswork:
--   * interrupt / CC  : JustAC Data/InterruptAbilities.lua + Data/SpellCategories.lua (CROWD_CONTROL_SPELLS)
--   * defensives+tier : JustAC SpellDB.lua DEFENSE_TIER (tier2 = grote def) + Data/SpellCategories.lua (DEFENSIVE_SPELLS)
--   * self-heals      : JustAC SpellDB.lua DEFENSE_TIER tier2 instant heals + Data/SpellCategories.lua (HEALING_SPELLS): 34428/202168
--   * rotatie/AoE     : JustAC Data/SpellArchetypes.lua + ClassCodex Data/Warrior/guide.lua (rotation steps)
--   * movement        : JustAC SpellDB.lua CLASS_GAP_CLOSER_DEFAULTS WARRIOR_1/2/3 = {100 Charge, 6544 Heroic Leap}
--   * utility         : JustAC Data/SpellCategories.lua UTILITY_SPELLS (Taunt 355) + guide.lua
--
-- Baseline (GEEN specs; alle 3 specs): Pummel, Battle Shout, Rallying Cry, Berserker Rage,
--   Heroic Leap, Charge, Victory Rush/Impending Victory, Intimidating Shout,
--   en sinds 17 sep ook Storm Bolt, Shockwave en Shattering Throw (class-talenten, zie onder).
--
-- SELF-HEALS (de gaten in de oude draft): Victory Rush (34428) en Impending Victory (202168)
--   zijn baseline instant self-heals (DEFENSE_TIER tier 2 in SpellDB.lua; HEALING_SPELLS in
--   SpellCategories.lua). De oude draft beperkte ze fout tot specs {71,72}; guide.lua toont
--   dat Protection ook Impending Victory gebruikt ("Use {202168} if you have low HP!") -> nu
--   baseline (alle 3 specs). Enraged Regeneration (184364, Fury) is een DR+heal-over-time
--   defensive (DEFENSE_TIER tier 2), geen instant heal -> defensive_3, niet heal-anker.
--   Warrior heeft geen aparte out-of-combat-heal-spell -> geen heal_ooc/F3 (never-lie: niets verzinnen).
--
-- STAY ALIVE CARD (17 Sep 2026). `survival`, `survivalOrder`, `survivalNote` and `survivalId` feed
--   only Modules/SurvivalPlan.lua; the key fields (role/category/priority/bindKey/alsoStop) are
--   untouched. Every tag follows docs/audit_2026-09-17/audit_paladin_warrior_dk.md (Icy Veins 12.1 +
--   wago.tools 12.1.0.69814). Order within a step: small and frequent first, big and rare last.
--   ⚠️ Ignore Pain is ONE entry for Arms and Prot and `survival` is one value, so it is "small" for
--   both: on Arms it is a 20 s layered button (IV-Arms, W-CD 1277297), and "keepup" there was the
--   audit's FOUT. On Prot it is really maintenance next to Shield Block; that needs a per-spec
--   `survival` in SurvivalPlan.lua (lead's call). Arms' own id 1277297 is in `survivalId`.
--   Left OFF the card on purpose: Intervene (ally only, W-DESC 3411), Charge (runs you INTO the
--   enemy), Berserker Rage (fear break only, audit: low priority), Challenging Shout / Disrupting
--   Shout (group tools, not your own health).
--   Removed: nothing here. Last Stand (passive in 12.1, talent 1243659), Thunderous Roar and Bitter
--   Immunity (old tree 880 only) were never classifier entries.
--   Storm Bolt, Shockwave, Shattering Throw and Champion's Spear are class talents for all three
--   specs (W-TREE 850), but their `specs` stay as they were: widening them hands out new keys, and
--   this pass promised to move no binds. A keybind pass can take them up.
--   Ignore Pain carries a per-spec step: small on Arms, keepup on Prot.
--   No `id`s added: the audit warns name lookups jump to replacements; measure with /mh survival.

ns.KeybindRoleClassifier.WARRIOR = {
	--==============================================================
	-- BASELINE (alle 3 specs) - geen specs = {}
	--==============================================================
	-- Interrupt (InterruptAbilities.lua [6552] kind="interrupt" pri=1; SpellCategories CC)
	["Pummel"]             = { role = "interrupt", priority = 1, survival = "interrupt", survivalOrder = 1 },

	-- Movement (SpellDB CLASS_GAP_CLOSER_DEFAULTS WARRIOR_1/2/3 = {100, 6544})
	["Heroic Leap"]        = { role = "utility_primary", priority = 1, survival = "escape", survivalOrder = 1 }, -- card: 45 s leap away (IV-ProtWar; W-CD cat. 1211)
	["Charge"]             = { role = "utility_primary", priority = 2, bindKey = "Shift+Q" },

	-- CC / dispel_cc (InterruptAbilities.lua [5246] fear; SpellCategories CROWD_CONTROL)
	["Intimidating Shout"] = { category = "dispel_cc", priority = 1 },
	["Berserker Rage"]     = { category = "dispel_cc", priority = 2, bindKey = "Shift+V" }, -- fear/CC-immuniteit baseline

	-- Self-heals (baseline instant heal; DEFENSE_TIER tier2 34428/202168; HEALING_SPELLS)
	["Victory Rush"]       = { role = "heal_quick", priority = 1, survival = "heal", survivalOrder = 1, survivalNote = "SURVIVAL_NOTE_AFTER_KILL" }, -- F2: instant self-heal (baseline; talent-wederhelft van Impending Victory); only within 20 s of a kill (W-DESC)
	["Impending Victory"]  = { role = "heal_quick", priority = 1, survival = "heal", survivalOrder = 2 }, -- F2: instant self-heal (baseline; talent-variant; Prot gebruikt dit ook, guide.lua); 30% health, 25 s (IV-ProtWar)

	-- Utility (SpellCategories UTILITY_SPELLS + guide.lua)
	["Battle Shout"]       = { role = "utility_secondary", priority = 1 }, -- raid-buff (Arms/Fury op F, Prot op R)
	["Rallying Cry"]       = { category = "defensive", priority = 4, survival = "big", survivalOrder = 2, survivalNote = "SURVIVAL_NOTE_GROUP" }, -- groeps-defensive CD (+15% max HP; DEFENSIVE_SPELLS 97462) -> functioneel defensive; 3 min (W-CD)
	["Intervene"]          = { category = "defensive", priority = 5 },      -- baseline gap-closer + damage-intercept op ally (JustAC SpellCooldowns 3411=30s); NOT on the card: ally only
	["Heroic Throw"]       = { category = "utility", priority = 5 },        -- baseline ranged pull/threat (JustAC SpellArchetypes 57755); vooral Prot
	["Hamstring"]          = { category = "utility", priority = 3 },        -- slow (SpellArchetypes 1715)

	--==============================================================
	-- ARMS (71)
	--==============================================================
	-- Builders / kernrotatie (guide.lua rotation: {12294},{7384},{772}; SpellArchetypes)
	["Mortal Strike"]      = { category = "main_rotation", priority = 1, specs = { 71 } },
	["Overpower"]          = { category = "main_rotation", priority = 2, specs = { 71 } },
	["Rend"]               = { category = "main_rotation", priority = 3, specs = { 71 } },
	-- Spenders (guide.lua {163201} execute-fase; {1464} filler)
	["Execute"]            = { category = "spender", priority = 1 },              -- baseline execute (alle specs, guide.lua)
	["Slam"]               = { category = "spender", priority = 2, specs = { 71 } },
	-- AoE (Shift-tweelingen; guide.lua Multitarget {260708},{845})
	["Sweeping Strikes"]   = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 71 } },
	["Cleave"]             = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 71 } },
	-- Kleine def (DEFENSE_TIER untagged = tier3; SpellCategories DEFENSIVE 190456)
	-- Card: "small" for both specs (see header); Arms owns 1277297, a 20 s layered button (W-CD, W-DESC).
	["Ignore Pain"]        = { role = "defensive_1", priority = 1, specs = { 71, 73 }, survival = { [71] = "small", [73] = "keepup" }, survivalOrder = 1, survivalId = { [71] = 1277297 } },
	-- Grote def (DEFENSE_TIER 118038 = tier2)
	["Die by the Sword"]   = { role = "defensive_3", priority = 1, specs = { 71 }, survival = "big", survivalOrder = 1 }, -- 2 min (W-CD), Arms' big one
	-- Grootste CD / cooldown_bar (guide.lua opener {167105}; SpellArchetypes 167105)
	["Colossus Smash"]     = { role = "cooldown_bar", priority = 1, specs = { 71 } },
	-- Extra CD's (guide.lua {107574} Avatar; {227847} Bladestorm; {228920} Ravager; {436358} Demolish)
	["Avatar"]             = { category = "cooldown", priority = 2, bindKey = "Shift+F1", specs = { 71, 73 } }, -- Arms/Prot major CD (guide.lua)
	-- Utility (SpellArchetypes 394354 anti-shield; 132169 CC-talent)
	["Wrecking Throw"]     = { category = "utility", priority = 5 },              -- anti-shield/immuniteit (geen heal); baseline throw-utility
	["Storm Bolt"]         = { category = "dispel_cc", priority = 6, specs = { 71, 72 }, alsoStop = "stun" }, -- single-target stun/CC (InterruptAbilities 107570 kind="cc" mech=12) → Spec 08 alsoStop

	--==============================================================
	-- FURY (72)
	--==============================================================
	-- Builders / kernrotatie (guide.lua {23881} implied via Bloodthirst; {184367} Rampage; SpellArchetypes 23881/85288/184367)
	["Bloodthirst"]           = { category = "main_rotation", priority = 1, specs = { 72 } },
	["Raging Blow"]           = { category = "main_rotation", priority = 2, specs = { 72 } },
	["Rampage"]               = { category = "main_rotation", priority = 3, specs = { 72 } }, -- Enrage-trigger (guide.lua {184367})
	-- AoE (guide.lua {190411} Whirlwind; {6343} Thunder Clap MT; {435607} Thunder Blast)
	["Whirlwind"]             = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 72 } },
	["Thunder Clap"]          = { category = "main_rotation", priority = 3, specs = { 72, 73 } }, -- Fury AoE-builder (Mountain Thane) + Prot kernbuilder (guide.lua {6343})
	["Thunder Blast"]         = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 72, 73 } }, -- Mountain Thane proc (guide.lua {435607})
	-- Kleine/vangnet def + self-heal-DR (DEFENSE_TIER 184364 = tier2 DR-over-time)
	["Enraged Regeneration"]  = { role = "defensive_3", priority = 1, specs = { 72 }, survival = "big", survivalOrder = 1, survivalNote = "SURVIVAL_NOTE_STUNNED" }, -- 30% DR + heal-over-time (tier2 wall van Fury); geen instant-heal-anker; usable while stunned (IV-Fury)
	-- Grootste CD / cooldown_bar (guide.lua {385059}=Recklessness variant; SpellDB burst)
	["Recklessness"]          = { role = "cooldown_bar", priority = 1, specs = { 72 } },
	-- Extra CD's (guide.lua {227847} Bladestorm; Odyn's Fury Fury-talent)
	-- ⚠️ GEEN bindKey meer op Bladestorm, Ravager en Demolish (7 aug 2026). Alle drie
	-- vroegen om Ctrl+F1, en dat is dubbel fout: ze kunnen daar niet alle drie op, én
	-- KEYBIND_STANDARD_v6 §3 reserveert Ctrl+F1 voor je TRINKET. Zonder wens plaatst de
	-- allocator ze gewoon in de cooldown-categorie (F1, dan Shift+F1), waar cooldowns
	-- horen. Bladestorm en Ravager delen bij Arms een keuzenode — zie `excludes` — dus
	-- in de praktijk zijn het er hooguit twee tegelijk.
	["Bladestorm"]            = { category = "cooldown", priority = 3, specs = { 71, 72 } }, -- guide.lua {227847} Arms & Fury
	["Odyn's Fury"]           = { category = "cooldown", priority = 4, specs = { 72 } }, -- major CD (geen heal)

	--==============================================================
	-- PROTECTION (73)
	--==============================================================
	-- Builders / kernrotatie (guide.lua {23922} Shield Slam; {6572} Revenge; {6343} Thunder Clap)
	["Shield Slam"]        = { category = "main_rotation", priority = 1, specs = { 73 } },
	["Revenge"]            = { category = "main_rotation", priority = 2, specs = { 73 } },
	-- AoE (Shift-tweelingen; Demoralizing Shout rage-gen)
	-- Card: enemies deal 20% less damage to you, 45 s (IV-ProtWar; W-CD 45).
	["Demoralizing Shout"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 73 }, survival = "small", survivalOrder = 2 },
	-- Movement extra (SpellArchetypes 385954 Shield Charge, gap-closer)
	["Shield Charge"]      = { role = "utility_primary", priority = 3, bindKey = "Ctrl+Q", specs = { 73 } },
	-- Kleine def (SpellDB WARRIOR_3 2565 Shield Block; DEFENSE_TIER untagged = tier3)
	["Shield Block"]       = { role = "defensive_1", priority = 1, specs = { 73 }, survival = "keepup", survivalOrder = 1, survivalNote = "SURVIVAL_NOTE_PHYSICAL" }, -- blocks melee only (W-DESC)
	-- Grote def (DEFENSE_TIER 871 = tier2; Last Stand 12975 nu passief effect van Shield Wall)
	["Shield Wall"]        = { role = "defensive_3", priority = 1, specs = { 73 }, survival = "big", survivalOrder = 1 }, -- -40%, 3 min base (W-CD cat. 1929)
	-- Extra def (SpellCategories DEFENSIVE 23920 Spell Reflection; DEFENSE_TIER untagged = tier3)
	-- Card: reflects the next spell, so press it as the cast comes (W-DESC 23920), not when health drops.
	["Spell Reflection"]   = { category = "defensive", priority = 4, bindKey = "Shift+C", survival = "small", survivalOrder = 3, survivalNote = "SURVIVAL_NOTE_SPELL_AT_YOU" }, -- alle specs kunnen dit; anker Shift+C
	-- Threat-taunt (SpellCategories UTILITY 355 Taunt)
	["Taunt"]              = { category = "taunt", priority = 1, specs = { 73 } },
	-- Grootste CD / cooldown_bar (guide.lua Prot: {107574} Avatar als burst-opener -> zie Avatar hierboven)
	-- Extra CD's (guide.lua {436358} Demolish; SpellArchetypes 228920 Ravager; 376080 Champion's Spear)
	["Champion's Spear"]   = { role = "cooldown_bar", priority = 1, specs = { 73 } }, -- F1 Prot burst-anker (SpellArchetypes 376080). Avatar is bij Prot op de gedeelde 'Avatar'-key category=cooldown (die key is Arms' cooldown terwijl Arms' cooldown_bar Colossus Smash is); één key = één rol, dus Prot krijgt hier zijn eigen cooldown_bar-anker.
	["Ravager"]            = { excludes = "Bladestorm", category = "cooldown", priority = 3, specs = { 71, 73 } }, -- SpellArchetypes 228920 (Arms/Prot Colossus-alt)
	["Demolish"]           = { category = "cooldown", priority = 3, specs = { 71, 73 } }, -- guide.lua {436358} (Colossus hero-tree)
	-- Utility CC (InterruptAbilities 46968 Shockwave kind="cc"; talent stun)
	["Shockwave"]          = { category = "dispel_cc", priority = 3, specs = { 73 }, alsoStop = "stun" }, -- AoE-stun (InterruptAbilities 46968 mech=12) → Spec 08 alsoStop
	-- Utility (SpellArchetypes 394352 Shattering Throw anti-immuniteit)
	-- 17 Sep: a class talent for all three specs (W-TREE 850), but widening `specs` would hand out
	-- new keys; left for a keybind pass (the audit lists it).
	["Shattering Throw"]   = { category = "utility", priority = 5, specs = { 73 } }, -- anti-immuniteit (geen heal)
	-- Shout-utility talenten (ExwindCore Midnight: Challenging Shout 1161 / Disrupting Shout 386071, specs={73})
	["Challenging Shout"]  = { category = "utility", priority = 6, specs = { 73 } }, -- AoE-taunt (Prot-talent)
	-- A true AoE interrupt (JustAC InterruptAbilities [386071] kind=interrupt, 14 yd; ExwindCore agrees
	-- on the id). Was category utility at priority 7 and got NO key at all (unplaced on every Prot
	-- sheet). 21 Sep 2026: moved to the stop family, next to Shockwave, and cross-listed as a stop.
	["Disrupting Shout"]   = { id = 386071, category = "dispel_cc", priority = 4, specs = { 73 }, alsoStop = "aoekick" },
}
