# Spec audit 10 Oct 2026: Hunter, Shaman, Evoker

Scope: Hunter (253 BM, 254 MM, 255 SV), Shaman (262 Ele, 263 Enh, 264 Resto), Evoker (1467 Dev, 1468 Pres, 1473 Aug).
The audit looked for two kinds of bug:
1. One choice for all specs, where the specs actually differ.
2. Spells that no longer exist, that are passive now, or that are the unpicked half of a talent choice but shown as if everyone has them.

Read-only. No code or locale file was changed.

## Method and sources

- **MEASURED** means I saw it in Blizzard DB2 on wago.tools, build **12.1.0.69933**, on 10 Oct 2026. I loaded the full CSVs in the browser for: SpellName, TraitDefinition, TraitNodeEntry, TraitNodeXTraitNodeEntry, TraitNode, TraitSubTree, TraitNodeGroupXTraitNode, TraitNodeGroupXTraitCond, TraitNodeXTraitCond, TraitCond, SpecSetMember, SkillLineXTraitTree, SpecializationSpells, SkillLineAbility and SpellLearnSpell. I filtered these tables for single spells: SpellMisc (passive = Attributes_0 & 0x40), SpellCooldowns, SpellCategories/SpellCategory (charges), Spell (description), SpellEffect (aura 332 = button override) and SpellEquippedItems.
- **How "live" was decided:**
  - **Live talent trees** come from SkillLineXTraitTree: Hunter 774, Shaman 786, Evoker 872. Trees 1033, 1034 (Shaman) and 701 (Evoker) also hold copies of the nodes but are not linked to a skill line. I treated them as dead.
  - **A spell counts as live** if one of these is true:
    - it is on a node in a live tree;
    - it is in SpecializationSpells;
    - it is in the class SkillLineAbility (795 Hunter, 924 Shaman, 2810 Evoker);
    - a live spell teaches it through SpellLearnSpell.
  - **A choice node** is a TraitNode of Type 2 with two entries. Spec gating comes from the TraitCond SpecSet. Hero trees come from TraitSubTree.
- **DERIVED** means reasoned from code reading, from a guide, or from how the client behaves (for example IsPlayerSpell on an overridden base). That client behaviour was not measured in the client during this audit.
- **Guides read on 10 Oct 2026:**
  - Icy Veins Preservation rotation ("Last Updated Aug 13, 2026") and talents (Aug 28, 2026).
  - Icy Veins Elemental rotation ("Aug 10, 2026"). ⚠️ This one is dated before the 18 Aug Season 2 cut.
- **Render paths that decide severity (code read):**
  - The Academy toolkits filter on IsPlayerSpell only for your **own active** spec (RoleAcademy.lua:564-576, :850-868). A preview of another spec shows the whole list.
  - `/mh healcds` prints the whole list with no filter (HealerCooldowns.lua:607-611).
  - Stay alive and Group filter on IsPlayerSpell and skip passive spells (SurvivalPlan.lua:187-274, GroupPlan.lua:456-492).
  - Play cards turn grey any `{SPELL:id}` that the character does not know (PlayCards.lua:239-246, :300-313).
  - TeamMacros cast by **name**.
  - Nothing renders `ns.DPS_DEFENSIVES` (RoleAcademy.lua:891-893).
  - KeybindingData `specsById` is unreachable: `LevelingKeybindSlugForLayout` returns nil (KeybindLayoutSlug.lua:48-59), and `KeybindSlugFromGuidePreview` is never called.

---

## WRONG: tells the player something false, or a button that cannot work (5)

**W1. MissingBuffData.lua:70: Flametongue Weapon is a main-hand imbue for Enhancement as well**
- **MH says:** `{ spell = 318038, kind = "imbue_mh", specs = { 262, 263 } }`. MissingBuff.lua:255-256 counts it as active when **any** main-hand enchant is present.
- **True in 12.1 (MEASURED):** the description of 318038 reads "Imbue your `$?s33757[off-hand ][]`weapon". A shaman who knows Windfury Weapon (33757, Enh node 80958) puts Flametongue on the **off-hand**. Flametongue is an Enh node (80942) and an Ele node (81004).
- **Effect (DERIVED):** an Enhancement Shaman with Windfury on the main hand and **no** Flametongue on the off-hand is told nothing is missing. This is bug type 1: one slot for two specs that use different slots.
- **Fix:** split it into `{318038, imbue_mh, specs {262}}` and `{318038, imbue_oh, specs {263}}`.

**W2. TeamMacrosData.lua:182-189: Preservation macro "Mouseover Spiritbloom"**
- **MH says:** `/cast [@mouseover,help,nodead][] Spiritbloom`
- **True in 12.1 (MEASURED):** none of the 6 SpellName rows called "Spiritbloom" (including 367226 and 382731) has a live trait node, a SpecializationSpells row, a SkillLineAbility row or a SpellLearnSpell path. The macro casts nothing. MH's own KeybindRoles_Evoker.lua:59/121 already says it was removed.
- **Fix:** drop the macro, or replace it with a live Preservation spell (Reversion 366155 or Verdant Embrace 360995, both live).

**W3. TeamMacrosData.lua:663-670: Enhancement macro "Cursor Totems" casts Windfury Totem**
- **MH says:** "Place Windfury or Capacitor Totem at your cursor", but the macro body is only `/cast [@cursor] Windfury Totem`.
- **True in 12.1 (MEASURED):** none of the 12 "Windfury Totem" spells, including 8512, is live. The macro does nothing.
- **Fix:** change the macro to Capacitor Totem 192058 (a live class talent) and remove "Windfury" from both descriptions.

**W4. enUS.lua:1259, 1260, 1264 (PLAYCARD_262_S2/S3/MISTAKE) and enUS.lua:1485, 1489 (PLAYCARD_264_EASY/S4): Flame Shock as `{SPELL:188389}`**
- **True in 12.1 (MEASURED):** 188389 is not live (no node, no SpecializationSpells row, no SkillLineAbility row, no SpellLearnSpell path). The live Flame Shock for **all three** specs is **470411**: SkillLineAbility 924 (Shaman), AcquireMethod 2. MH itself already uses 470411 in HealerSolo.lua:52 and KeybindRoles_Shaman.lua:74.
- **Effect (DERIVED):** the name still resolves to "Flame Shock". But the card shows it **grey** ("you do not have this yet") and links the tooltip of a spell that cannot be learned. That is the core DoT on the Ele card and the "nobody needs healing" step on the Resto card.
- **Same 5 keys in every pack:**
  - nlNL.lua:1209/1210/1214/1435/1439
  - Translations2026.lua de/fr/es/pt/it: 9895/9896/9900/10120, 10372/10373/10377/10597, 10849/10850/10854/11074, 11326/11327/11331/11551, 11803/11804/11808/12028
  - the 264_EASY lines 14795/14807/14819/14831/14843
  - That makes **35 occurrences**.
- **Fix:** replace `{SPELL:188389}` with `{SPELL:470411}` in all 35.
- **Related (RISK, DERIVED):** Voltaic Blaze 470057 **overrides** 470411 on Ele node 81007 and Enh node 80954 (TraitDefinition OverridesSpellID, MEASURED). An Elemental who takes Voltaic Blaze therefore has no Flame Shock button at all, yet PLAYCARD_262_S2 says to keep Flame Shock up. Icy Veins' Ele rotation (10 Aug 2026) only talks about Flame Shock, so the guide build probably skips Voltaic Blaze. The card's AOE line does mention Voltaic Blaze.

**W5. enUS.lua:1406 (PLAYCARD_254_AOE): Multi-Shot as `{SPELL:2643}`**
- **True in 12.1 (MEASURED):** none of the 73 "Multi-Shot" spells is live except **257620**, which is in SpecializationSpells for spec 254. 2643 is not live. KeybindRoles_Hunter.lua:177 already uses 257620.
- **Effect (DERIVED):** the step is grey on every Marksmanship Hunter and links the old tooltip.
- **Same key in every pack:** nlNL.lua:1356 and Translations2026.lua:10040/10517/10994/11471/11948. That makes **7 occurrences**.
- **Fix:** replace `{SPELL:2643}` with `{SPELL:257620}`.

---

## RISK: half of a choice node, a talent or hero half shown to everyone, or a conditional dead button (14)

**R1. HealerCooldowns.lua:131-132 and :165-167, through `/mh healcds` (HealerCooldowns.lua:607-611) and the Academy preview (RoleAcademy.lua:583, OwnedOnly passes everything when activeID is nil)**
- **Choice nodes (MEASURED):** Dream Flight 359816 / Stasis 370537 are one choice node (93267, Pres). Healing Tide Totem 108280 / Ascendance 114052 are another (81032, Resto).
- **Effect:** `/mh healcds` prints both halves of both pairs to a player who has only one of each. The Academy on your own active healer spec filters correctly.
- **Fix:** filter PrintHealerCooldownSheet on IsPlayerSpell, as OwnedOnly does. In the preview, add "(or …)" to the pairs.

**R2. HealerCooldowns.lua:224: Healing Rain 73920 as a Resto core heal**
- **True in 12.1 (MEASURED):** Surging Totem 455630 (Totemic hero, 263/264) teaches 444995 and 456359. 456359 is an aura-332 override of Healing Rain (73920) to 444995, and the description of 444995 says "Replaces Healing Rain".
- **Effect (DERIVED):** for a Totemic Resto, IsPlayerSpell(73920) is true on the base, so the toolkit names "Healing Rain", a button they do not see. Totemic is the build the Resto card itself marks as best.
- **Fix:** show the override name through C_Spell.GetOverrideSpell, as SurvivalPlan.lua:264-271 does.

**R3. HealerCooldowns.lua:271: Purify Spirit listed as removing `{ "magic", "curse" }`**
- **True in 12.1 (MEASURED):** the description of 77130 reads "Removes all Magic`$?s383016[ and Curse][]`". Curse needs **Improved Purify Spirit 383016**, a class node (81073) that only Resto can see. It is a talent, not baseline.
- **Fix:** show curse only when IsPlayerSpell(383016), or label it "(talent)".

**R4. DispelHelper.lua:418 (OFFENSIVE_PURGES.SHAMAN = 370) and PlayCardWindow.lua:464 (ENEMY_DISPELS.SHAMAN ids {370})**
- **True in 12.1 (MEASURED):** Purge 370 and **Greater Purge 378773** are one choice node (103624, class tree, every spec). Greater Purge also removes beneficial Magic effects.
- **Effect (DERIVED):** both places are gated on IsPlayerSpell(370), so a Shaman with Greater Purge never gets the purge prompt or the purge row. They are silently left out.
- **Fix:** use ids `{370, 378773}`. KeybindRoles_Shaman.lua:55 also has no "Greater Purge" entry.

**R5. DpsToolkit.lua:64 ([263] Ascendance 114051 + Doom Winds 384352)**
- **True in 12.1 (MEASURED):** Ascendance 114051 is one half of choice node 92219 (the other half is Deeply Rooted Elements 378270, which is passive). Its TraitDefinition **overrides Doom Winds 384352**, and the description of 114051 says it "unleash[es] Doom Winds".
- **Effect (DERIVED):** an Enhancement with Ascendance still owns the base Doom Winds node, so IsPlayerSpell(384352) is true. Their toolkit then lists Doom Winds as a separate button that has been replaced on the bar.
- **Fix:** hide Doom Winds when IsPlayerSpell(114051).

**R6. enUS.lua:1258 (PLAYCARD_262_S1): "Stormkeeper, then Ancestral Swiftness, then Ascendance"**
- **True in 12.1 (MEASURED):** Ancestral Swiftness 443454 comes only from Farseer node 94894 (448861 teaches 443454; hero tree for 262/264).
- **Effect:** a hero-only button sits in a core step. HERO2 corrects it for Stormbringer.
- **Fix:** move Ancestral Swiftness to HERO1, or write "(Farseer)" after it.

**R7. enUS.lua:1263 (PLAYCARD_262_AOE `{SPELL:61882}`) and TeamMacrosData.lua:645-652 ("Cursor Earthquake", `[@cursor]`)**
- **True in 12.1 (MEASURED):** Earthquake 61882 ("cast at a selected location") and Earthquake 462620 ("cast at your target") are one choice node (80985, Ele).
- **Effect (DERIVED):** with 462620 the card step is grey and a cursor macro makes no sense.
- **Fix:** card: use whichever id the player knows, or name both. Macro: add "only with the ground version".

**R8. TeamMacrosData.lua:673-680 ("Cursor Healing Rain", Resto)**
- **True in 12.1 (MEASURED):** for Totemic, Surging Totem replaces Healing Rain (see R2).
- **DERIVED, not verified:** whether `/cast Healing Rain` follows that override.
- **Fix:** test it in the client, or add a Surging Totem line.

**R9. enUS.lua:1583-1584 (PLAYCARD_1468_EASY step 1, PLAYCARD_1468_S1): Temporal Anomaly 373861 for every Preservation**
- **True in 12.1 (MEASURED):** Temporal Barrier 1291636 (choice node 93258, with Nozdormu's Teachings) **overrides** Temporal Anomaly.
- **DERIVED, low priority:** Icy Veins' Pres rotation (13 Aug 2026) says to cast Temporal Anomaly on cooldown "regardless of build", so the guide does not take Barrier.
- **Fix:** add "(or Temporal Barrier, if you took it)".

**R10. MissingBuffData.lua:67: self Earth Shield `{ spell = 383648, reqSpell = 383010 }`**
- **True in 12.1 (MEASURED):** Elemental Orbit 383010 is live (class node 103602). Its only effect is aura 4 and it teaches nothing. 383648 has no node, no SpecializationSpells row, no SkillLineAbility row and no SpellLearnSpell path. The castable spell is 974, and the description of 974 says that with 383010 it can be on the Shaman **and** one other target.
- **Effect (DERIVED):** IsKnown(383648) is probably false, so this reminder never fires. That is silent, not false.
- **Fix:** check it in the client with `/mh mbuff`. If it is false, cast 974 on yourself and check aura 383648.

**R11. MissingBuffData.lua:73-74: Thunderstrike Ward 462757 (Ele) and Tidecaller's Guard 457481 (Resto) as `imbue_oh`**
- **True in 12.1 (MEASURED):** SpellEquippedItems for both is ItemClass 4 with Subclass mask 64, which means **a shield is required**. Thunderstrike Ward is one half of choice node 103631 (the other is Elemental Resonance). Tidecaller's Guard is taught by Supportive Imbuements 445033 (a Totemic choice node). MissingBuff.lua has no shield check.
- **Effect (DERIVED):** a player who has the talent but carries a two-handed weapon or staff is asked forever for an imbue that cannot be cast.
- **Fix:** only show it when an off-hand shield is equipped.

**R12. KeybindRoles_Hunter.lua:134 (Steady Shot 56641, no `specs`) and :113/:204 (Concussive Shot / Wing Clip)**
- **True in 12.1 (MEASURED):** 56641 is overridden by Barbed Shot 217200 (BM node 102377) and by Kill Command 259489 (SV node 102255). Concussive Shot 5116 overrides Wing Clip 195645 (class node 102407).
- **Effect (DERIVED, from the byId comment at SurvivalPlan.lua:91-94):** a byId match on the base can give the "Steady Shot" entry the BM/SV button that is really Barbed Shot or Kill Command. This is a key-allocation risk only; nothing is told to the player.
- **Fix:** `specs = { 254 }` on Steady Shot.

**R13. GroupPlan.lua:385/395/404 (Roar of Sacrifice 53480 for 253/254/255)**
- **True in 12.1 (MEASURED):** one half of choice node 110164 (the other is Guardian's Hide 1272094).
- **Effect:** the ownership check hides it correctly in game. The note text gives no hint that it is a choice. The site reads ids without a spellbook (comment at SurvivalPlan.lua:90), so it may show the row to everyone.
- **Fix:** add a note like GROUP_NOTE_HEALING_TIDE_TOTEM.

**R14. HealerCooldowns.lua:167 / enUS.lua:1493 (PLAYCARD_264_HERO2): "Farseer: … Your big cooldown is Ascendance"**
- **True in 12.1 (MEASURED):** Ascendance 114052 / Healing Tide Totem is a Resto choice that does not depend on the hero tree (node 81032 has no sub-tree).
- **DERIVED:** the sentence presents one half as a given for Farseer.
- **Fix:** "Ascendance (or Healing Tide Totem)".

---

## STALE: comment, dead data, or an inert id (6)

**S1. DpsToolkit.lua:113-114: Ancestral Guidance 108281 for 262/263**
- **MEASURED:** not live. Only 114911 is in SkillLineAbility, with AcquireMethod 0. KeybindRoles_Shaman.lua:118 already calls it removed.
- Nothing renders DPS_DEFENSIVES, so this is dead data.
- **Fix:** remove it before anyone reuses the table.

**S2. KeybindingData.lua (dead hand-maps, unreachable, see Method)**
- **MEASURED:** these entries are not live, or are wrong for the spec:
  - :281 `hunter_early E = 1130`. Not live; the live Hunter's Mark is 257284.
  - :325 `hunter_beast_mastery Q = 2643`. Not live; BM has Wild Thrash 1264359.
  - :222 `enh_shaman R = 205495`. Stormkeeper is an Ele-only node (80988); 205495 has only a SkillLineAbility row with AcquireMethod 3.
  - :208 `enh_shaman 5 = 117014`. Elemental Blast is on Ele-only choice node 80984.
- **Fix:** delete the hand-maps, or mark them as historical.

**S3. KeybindRoles_Hunter.lua:181: Raptor Swipe `id = 1262293`**
- **MEASURED:** not live. The live ids are 1259003/1259017/1259019 (SV tiered node 110429).
- The name match still works.
- **Fix:** id = 1259003, or drop `id`.

**S4. KeybindRoles_Shaman.lua:131 comment: "the old 444995 has no learnable link"**
- **MEASURED false:** SpellLearnSpell shows 455630 teaches 444995 (and 456359).
- The play cards' `{SPELL:444995}` (enUS 1483, 1492) is therefore **correct**.
- **Fix:** correct the comment, so nobody "fixes" the cards.

**S5. KeybindRoles_Hunter.lua:108 and DispelHelper.lua:419-420 call Tranquilizing Shot 19801 "baseline"**
- **MEASURED:** it is a class-tree talent (node 109489, gated on spent8).
- The code is gated on IsPlayerSpell, so behaviour is fine.
- **Fix:** comment only.

**S6. KeybindRoles_Hunter.lua:36-37 comment: "Kill Shot … (53351 BM/MM, 320976 SV)"**
- **MEASURED:** 320976 is not live. 53351 is an MM-only node (109490); BM has no Kill Shot.
- **Fix:** comment only.

## OPEN: not settled, not counted

- **DpsToolkit.lua:48 / PLAYCARD_253_S1:** Bestial Wrath "a flat 30 s".
  - MEASURED: SpellCooldowns 19574 has RecoveryTime **90000 ms** and no charge category.
  - I did not find the modifier that would make it 30 s. The spec aura 137015 has no flat cooldown modifier for it, and 25 of the 46 aura-107 / -60000 rows I looked at contained no Hunter one.
  - The client tooltip settles it.
- **TeamMacrosData.lua:190-197 ("Cursor Emerald Blossom") and :208-215 ("Cursor Eruption", whose text says "the enemy under your cursor"):**
  - MEASURED: Emerald Blossom is cast "at an ally's location", and Eruption is a targeted spell.
  - DERIVED: `[@cursor]` only works for ground-targeted spells. These are outside the two bug types and untested.

## Verify-only items from the brief

- **Tip the Scales in HEALER_COOLDOWNS[1468] (HealerCooldowns.lua:135): correct.** MEASURED: class node 93350 (gated on spent8, no spec gate) and SpellCooldowns 120000 ms.
- **Celestial Conduit:** Monk, outside my classes. Not checked.
- **GetTopRaidCooldown prefers known spells (HealerCooldowns.lua:417-451): correct by code read.**
  - For 264 the first "raid" entries Healing Tide Totem / Ascendance are choice node 81032 (MEASURED), so the known-first rule matters there.
  - For 1468 the first "raid" entry is Rewind, a single node (93337), so nothing changes.
  - The `/mh healcds` printout does not use this rule (R1).

---

## Checked and correct, per file

Below, "correct" means live in 12.1.0.69933 for the spec(s) it is shown to (MEASURED). Choice halves that are filtered by an ownership check count as correct. Cooldown checks are MEASURED in SpellCooldowns or SpellCategory.

**MissingBuffData.lua**: 14 entries for my classes checked, 11 correct.
- Correct: Evoker 2 (Blessing of the Bronze 364342 in SkillLineAbility; Source of Magic class node). Shaman 8 (Skyfury, Lightning Shield 262/263, Water Shield 264, Earth Shield ally, Windfury main-hand for 263, Earthliving 264, Flametongue main-hand for 262; Thunderstrike Ward and Tidecaller's Guard are live and correctly gated on known).
- The Hunter pet rule is correct: Unbreakable Bond 1223323 is MM choice node 104127 with Avian Specialization, and BM/SV always have a pet.
- Problems: W1, R10, R11.
- Blessing of the Bronze aura 381748: DERIVED correct. SpellEffect 364342 triggers 13 per-class auras, and 381748 is index 3, which is Evoker in alphabetical class order.

**HealerCooldowns.lua**: 23 checked for 1468/264, 19 correct with no remark.
- HEALER_COOLDOWNS: 9. All ids are live, and all cooldowns match DB2: Rewind 240, Dream Flight 120, Stasis 90, Zephyr 120, Time Dilation 60, Tip the Scales 120, Healing Tide Totem 180, Spirit Link Totem 180, Ascendance 180.
- CORE_HEALS: 8. Healing Rain is R2.
- DEFENSIVES: 2. Obsidian Scales 90 and Astral Shift 120.
- HEALER_DISPELS: 2. Naturalize is Magic + Poison, MEASURED. Purify Spirit is R3.
- NONHEALER_DISPELS: Shaman 1 and Evoker 2, all with types MEASURED.
- Problems: R1, R2, R3.

**DpsToolkit.lua**: 17 DPS_COOLDOWNS entries checked, 16 correct.
- All ids are live.
- Cooldowns match: Dragonrage 120, Fire Breath 30, Eternity Surge 30, Deep Breath 120, Breath of Eons 120, Ebon Might 30, Upheaval 40, Trueshot 120, Rapid Fire 16, Explosive Shot 30, Wildfire Bomb 18 per charge, Stormkeeper 60, Ascendance 180 for 262 and 263, Doom Winds 60, Sundering 30.
- Problem: R5. Bestial Wrath's cooldown is OPEN.
- DPS_DEFENSIVES: 13 checked, 11 correct (Obsidian Scales, Zephyr, Turtle 180, Exhilaration 120, Astral Shift 120). Problem: S1 (×2).

**HealerSolo.lua**: 7 of 7 correct.
- 264: 470411, 51505, 188196, 188443.
- 1468: 357208, 356995, 361469.

**InterruptMacrosData.lua**: 9 of 9 correct.
- Evoker: Quell nodes only for 1467/1473, and Pres has `false`.
- Hunter: Counter Shot nodes for 253/254, Muzzle for 255.
- Shaman: Wind Shear is a class node with no spec gate.

**GroupRezLust.lua**: correct. Fury of the Aspects 390386, Harrier's Cry 466904 (SpecializationSpells 254), Primal Rage 264667 (Ferocity pet spec), Bloodlust/Heroism, Ancestral Spirit 2008, Return 361227.

**ConsumableReadyCheck.lua**: 1 of 1 correct. Skyfury 462854.

**DispelHelper.lua / PlayCardWindow.lua (purges)**: 2 per file checked.
- Hunter 19801 is correct: Enrage + Magic, MEASURED.
- Shaman: R4.

**GroupPlan.lua**: 52 rows for my 9 specs. All ids are live. Choice halves are filtered by ownership: Time Spiral / Spatial Paradox, Dream Flight / Stasis, Tremor / Poison Cleansing Totem (the note already says so), Healing Tide Totem (the note already says so), Roar of Sacrifice (R13).

**PlayCards (enUS PLAYCARD_* for 9 specs)**: 86 `{SPELL:id}` uses, 83 correct.
- 3 wrong uses: 188389 on two cards (W4) and 2643 (W5).
- Checked specially and correct:
  - Wailing Arrow 392060 is live as the override that 459808 puts on Trueshot and Bestial Wrath, triggered by Wailing Dead 1264290 (Dark Ranger, 253/254).
  - Black Arrow 466930 is BM's node. On MM, 466932 (passive) overrides Kill Shot with 466930.
  - Healing Stream Totem 5394 is taught by 392915 and 392916.
  - Ancestral Swiftness 443454 is taught by 448861.
  - Surging Totem 444995 is taught by 455630.
  - Tempest 454009 is on the Stormbringer node.
- Problems: R6, R7, R9, R14.

**KeybindRoles_Hunter / _Shaman / _Evoker.lua**: 49 / 49 / 48 entries checked. All names are live for the specs they are tagged with.
- Problems: R12 and S3 (Hunter); S4 (Shaman comment).
- MH's own "removed / passive" claims check out (MEASURED passive or not live): Renewing Blaze 374348 (live node, passive), Defy Fate 404195 (passive), Feral Spirit 469314 (passive), Bloodshed 1272099 (passive), Firestorm, Spiritbloom, Emerald Communion, Call of the Wild, Coordinated Assault, Spearhead, Steel Trap, Bursting Shot, Wyvern Sting, Scatter Shot, Chimaera Shot, Butchery, Flanking Strike, Mongoose Bite (none of these live as a button).

**SurvivalPlan.lua (survival-tagged rows)**: Hunter 9, Shaman 11, Evoker 8. All live and correct.
- Choice pairs are filtered: Gust of Wind / Spirit Walk is class choice node 103591.
- Earth Elemental is gated on Primordial Bond 1279819, a live class node.

**TeamMacrosData.lua**: Hunter 13 macros correct. Evoker 3 of 6 correct (W2, plus the 2 OPEN cursor macros). Shaman 2 of 5 correct (W3, R7, R8).

**KeybindingData.lua**: dead data. 4 bad entries flagged (S2). The rest was not audited, because it cannot be reached.

**Locales (non-PLAYCARD)**: 18 GROUP_NOTE_* and SURVIVAL_NOTE_* strings used by my classes, plus REZLUST_TIP_LUST. No removed spell is named. CHANGELOG_* is history and was not audited.

**No data for my classes found in**: TankToolkit.lua, RoleAcademy.lua, KeyBlock.lua (it only reads HealerSolo), LiveKeys.lua (it only reads the card and Stay alive), MythicPlusData.lua (MPLUS_KICKS is per dungeon). Positive control: the same greps did find class tokens in the other files in the same run.

## Limits

- Client behaviour was not measured: IsPlayerSpell / IsSpellKnownOrOverridesKnown on an overridden or unlearnable id, `/cast` following an override, and `[@cursor]` on targeted spells. Every claim that depends on it is marked DERIVED.
- TraitNode Type 2 = choice was read from the pairs it produces (Spirit Walk / Gust of Wind, Purge / Greater Purge), not from a schema document.
- The site (midnighthelper.com) reads some of these tables. I did not check what the site shows.
