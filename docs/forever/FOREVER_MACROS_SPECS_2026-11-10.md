# WoW: Forever macros per spec (talent tree), and how an addon can tell the spec

Research date: 10 Nov 2026. Input, not redone: `FOREVER_MACROS_POPULAR_2026-11-10.md` (POPULAR: families, counting,
class ranking), `FOREVER_MACROS_2026-11-09_A/B/C.md` (macro ids), and the 45 built class macros in
`Modules/ForeverMacros.lua` (`CLASS_MACROS`, 5 per class). Ids are the A/B/C ids. Where B and C share an id, the class
is named next to it. **NEW** = not in A/B/C. **"not in the 5"** = an A/B/C id that `CLASS_MACROS` does not ship.

Labels: **GEMETEN** = seen in a named, dated source (all read 10 Nov 2026). **AFGELEID** = my reasoning.
Every count, family list, spell id, level and player name in the tables is GEMETEN. The score and the ranking built
from it are AFGELEID.

**Nobody has tested any of this in the live Forever client.** That includes me and every source (foreverdb: "Not yet
tested in game"; classicwowforever: "Not tested in the live Forever client yet", per POPULAR). Part 2 is client
structure read from files, not a test. The two `/run` lines in §13 are the test.

---

## 0. Main findings

1. **Forever has the 27 classic trees, with these names** (GEMETEN, wago DB2 `TalentTab`, Forever 1.60.1.70862):
   Warrior Arms/Fury/Protection, Paladin Holy/Protection/Retribution, Hunter Beast Mastery/Marksmanship/Survival,
   Rogue Assassination/Combat/Subtlety, Priest Discipline/Holy/Shadow, Shaman Elemental/Enhancement/Restoration,
   Mage Arcane/Fire/Frost, Warlock Affliction/Demonology/Destruction, Druid Balance/**Feral Combat**/Restoration.
   This is the in-game left-to-right order (`OrderIndex`).
2. **The spec API cannot tell the tree.** GEMETEN: Forever `ChrSpecialization` has one row per class, named after the
   class (Warrior 1491, Paladin 1486, Hunter 1485, Rogue 1488, Priest 1487, Shaman 1489, Mage 1482, Warlock 1490,
   Druid 1484), plus "Default" 1493. AFGELEID: `C_SpecializationInfo.GetSpecialization()` can at most give that one
   class row.
3. **The trees live in `C_Traits`: one trait tree per class, with the three tabs side by side.** GEMETEN, DB2: each tab
   sits in its own X band (PosX 1020-2820, 5020-6820, 9080-10880). That matches TalentsForeverBook's node-to-tab data
   for all 467 nodes it lists, with 0 differences. GEMETEN, `Wow.exe` (Forever, 7 Nov 2026): `C_ClassTalents` and
   `C_Traits` names are in it. `GetTalentTabInfo`, `GetNumTalentTabs`, `GetPrimaryTalentTree` and
   `UnitCharacterPoints` are not. **Best answer (AFGELEID):** the spec is the band with the most purchased ranks
   (§12). The test line is in §13.
4. **The spec macros are mostly talent macros.** Of the 81 top picks below (3 per spec), about 64 need a talent in that
   spec's tree (GEMETEN, DB2 `TraitDefinition` per band). MH already hides `talent = true` rows until the spell is
   known. AFGELEID: that check also hides another spec's talent macros, so MH needs the spec only to group and sort
   the rows, not to hide them.
5. **Spec-level player evidence is thin.** In 16 new forum searches plus POPULAR's, the clearest cases are these
   (GEMETEN, §14):
   - Protection Warrior: Revenge + Shield Block on one key (Pixxy, 1 Nov).
   - Retribution: a seal + Judgement key (3 authors, Sep to Nov).
   - Holy Paladin: a Light's Vigil macro idea (19 Oct).
   - Elemental: a cancel-cast for Chain Lightning (4 Nov).
   - Feral: shift macros. These are mostly bug reports (POPULAR §0.1).
6. **Icy Veins (a 13th family) has exactly one Forever macro across its 27 rotation pages.** It is Protection Warrior
   Shield Block + Shield Slam (GEMETEN, page updated 4 Nov 2026). I found no Wowhead Forever spec guide (§15).

---

## 1. The trees (GEMETEN, wago DB2 Forever 1.60.1.70862, read with `run gamedata`)

| Class | Trait tree | Tab 1 (PosX 1020-2820) | Tab 2 (5020-6820) | Tab 3 (9080-10880) | Whole-tab node groups |
|---|---|---|---|---|---|
| Warrior | 1117 | Arms (161) | Fury (164) | Protection (163) | 11650 / 11657 / 11670 |
| Paladin | 1100 | Holy (382) | Protection (383) | Retribution (381) | 11486 / 11541 / 11559 |
| Hunter | 1091 | Beast Mastery (361) | Marksmanship (363) | Survival (362) | 11372 / 11371 / 11370 |
| Rogue | 1111 | Assassination (182) | Combat (181) | Subtlety (183) | 11580 / 11573 / 11572 |
| Priest | 1114 | Discipline (201) | Holy (202) | Shadow (203) | 11608 / 11615 / 11622 |
| Shaman | 1082 | Elemental (261) | Enhancement (263) | Restoration (262) | 11326 / 11363 / 11362 |
| Mage | 1112 | Arcane (81) | Fire (41) | Frost (61) | 11582 / 11594 / 11601 |
| Warlock | 1116 | Affliction (302) | Demonology (303) | Destruction (301) | 11629 / 11636 / 11637 |
| Druid | 1089 | Balance (283) | Feral Combat (281) | Restoration (282) | 11328 / 11347 / 11340 |

(TalentTab ids in brackets.)

- One Hunter node sits at PosX 102800 (a data quirk). It still falls in band 3. Shaman tree 1082 and Druid tree 1089
  have `TraitSystemID` 0, the other seven have 10.
- Four more class-like trees exist: 1058 (9 mage nodes), 1081 (16 shaman nodes), 1083 (36 druid nodes) and 1066
  (1 node). AFGELEID: these are old or test trees. TalentsForeverBook names 1082 and 1089 as the live ones.
- TraitSystem 45 holds trees 1187, 1188 and 1189 (9 nodes each) and 1118 (empty). AFGELEID: these are
  TalentsForeverBook's three "Legacy" trees. They are not class tabs.
- Each tree has one currency, 3820 (`TraitTreeXTraitCurrency`). So the three tabs share one point pool.
- Row gates are node-group conditions: 169 `TraitCond` rows with `SpentAmountRequired` and a `TraitNodeGroupID`. That
  matches TalentsForeverBook's "Rows open every five points in one tree".
- Localized tree names (DB2 `TalentTab.Name_lang`, GEMETEN). Two notes:
  - deDE is cut short in Blizzard's own data: "Wiederherst" (Restoration) and "Verstärk" (Enhancement).
  - itIT comes back English: wago serves no Italian strings for Forever.

  | Tree | deDE | frFR | esES | esMX | ptBR | ruRU |
  |---|---|---|---|---|---|---|
  | Arms | Waffen | Armes | Armas | Armas | Armas | Оружие |
  | Fury | Furor | Fureur | Furia | Furia | Fúria | Неистовство |
  | Protection | Schutz | Protection | Protección | Protección | Proteção | Защита |
  | Holy | Heilig | Sacré | Sagrado | Sagrado | Sagrado | Свет |
  | Retribution | Vergeltung | Vindicte | Reprensión | Reprensión | Retribuição | Воздаяние |
  | Beast Mastery | Tierherrschaft | Maîtrise des bêtes | Dominio de bestias | Bestias | Domínio das Feras | Чувство зверя |
  | Marksmanship | Treffsicherheit | Précision | Puntería | Puntería | Precisão | Стрельба |
  | Survival | Überleben | Survie | Supervivencia | Supervivencia | Sobrevivência | Выживание |
  | Assassination | Meucheln | Assassinat | Asesinato | Asesinato | Assassinato | Ликвидация |
  | Combat | Kampf | Combat | Combate | Combate | Combate | Бой |
  | Subtlety | Täuschung | Finesse | Sutileza | Sutileza | Subterfúgio | Скрытность |
  | Discipline | Disziplin | Discipline | Disciplina | Disciplina | Disciplina | Послушание |
  | Shadow | Schatten | Ombre | Sombra | Sombra | Sombra | Тьма |
  | Elemental | Elementar | Elémentaire | Elemental | Elemental | Elemental | Стихии |
  | Enhancement | Verstärk | Amélioration | Mejora | Mejora | Aperfeiçoamento | Совершенствование |
  | Restoration | Wiederherst | Restauration | Recuperación | Restauración | Restauração | Исцеление |
  | Arcane | Arkan | Arcanes | Arcano | Arcano | Arcano | Тайная магия |
  | Fire | Feuer | Feu | Fuego | Fuego | Fogo | Огонь |
  | Frost | Frost | Givre | Escarcha | Escarcha | Gelo | Лед |
  | Affliction | Gebrechen | Affliction | Aflicción | Aflicción | Suplício | Колдовство |
  | Demonology | Dämonologie | Démonologie | Demonología | Demonología | Demonologia | Демонология |
  | Destruction | Zerstörung | Destruction | Destrucción | Destrucción | Destruição | Разрушение |
  | Balance | Gleichgewicht | Equilibre | Equilibrio | Equilibrio | Equilíbrio | Баланс |
  | Feral Combat | Wilder Kampf | Combat farouche | Combate feral | Combate feral | Combate Feral | Сила зверя |

  Not measured: whether the talent window shows these exact strings. MH's "client name wins" rule needs that check.

---

## 2. Sources and counting method

Pages are those saved by the POPULAR run (scratchpad `dl/`, read 10 Nov). There are three additions:
- rankedboost's **27 spec pages**, used per spec this time.
- **Icy Veins Forever**: 27 rotation pages fetched by script (HTTP 200, dated 3 to 9 Nov 2026), plus the Protection
  Warrior main guide.
- **16 new forum searches** (US Discourse JSON, one EU), `<class|tank|healer|seal|moonkin|shadowform|feral> macro
  after:2026-08-18`.

A block counts for a spec when one of these holds (script `spec_macros.py`):
- **(a) spec page or section**:
  - the rankedboost spec page;
  - classicwowforever's `<Spec>` or `<Spec> PvP` section ("Feral" = Feral Combat);
  - kami-labs sections `tank` / `healing`;
  - a heading that names the spec (wow-forever.gg "Protection threat button", "Fury burst" and so on).
- **(b) talent**: the macro casts a spell that is a node in that spec's band (DB2, GEMETEN). This counts in any family.
- **(c) role section**: foreverdb "Tanking", "Feral: …", "Tank: …" and "Healing …" go to that class's tank or healer
  spec(s). Priest healing goes to both Discipline and Holy. AFGELEID mapping.

Families as in POPULAR (classicwowforever + 60.tools = one), plus **icy-veins**. That makes 13. Abbreviations:
- fdb = foreverdb
- cwf = classicwowforever
- rb = rankedboost
- mm = mmonster
- kami = kami-labs
- zk = zockify
- wfgg = wow-forever.gg
- gh = github-compendium
- gj = guildjen
- iv = icy-veins

**Score (AFGELEID, only for sorting) = families + 1 if it is a rankedboost spec-page pick + min(players, 3).**

**Bias (AFGELEID):** talent macros pick up hits in every family through rule (b). Baseline macros (Revenge, Sunder,
Holy Light…) only count where a source has a spec or role section. So for a spec, a baseline macro with 3 families
can be as strong as a talent macro with 5.

Level = DB2 `SpellLevels` of the first player rank (GEMETEN). For talents this is the spell's level, **not** the level
the talent node needs. `TraitCond` per node was not measured.

Macro texts below are classicwowforever's own text unless marked. Its license is GEMETEN: page footer "licensed under
CC BY 4.0, so you can reuse them if you credit us with a link" (https://classicwowforever.com/macros/<class>/). Only
the rb editor picks are listed for rankedboost, not their text (rankedboost: "All Rights Reserved").

rankedboost spec-page picks, all 27 (GEMETEN, dateModified 2026-11-08, 3 to 6 per page), are listed in each table as
"rb".

---

## 3. Warrior (built: W6 taunt, W2 overpower, W5 shieldbash, W3 execute, W1 charge)

### Arms
| # | id | Macro | Families | rb | Players | Talent (DB2) | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Mortal Strike key (+ Hamstring on Shift, or Sweeping Strikes on Ctrl) | 4: cwf, gh, kami, rb | yes | 1 (Lancer, EU 5 Nov) | Mortal Strike 12294, Arms | 40 | 6 |
| 2 | **NEW** | Sweeping Strikes with a swap to Battle Stance | 3: cwf, fdb, gh (+rb on Ctrl in #1) | - | 0 | Sweeping Strikes 12292, Arms | 30 | 3 |
| 3 | **NEW** | Spearing Strike + `/startattack` (Forever-new) | 3: cwf, wfgg, zk | - | 0 | Spearing Strike 1310222, Arms | 1 (spell) | 3 |
| 4 | W2 | Overpower from any stance (rb: Rend on Ctrl) | 2: cwf, rb | yes | 0 | - | 12 | 3 |
| 5 | W3 | Execute (rb: Slam, Execute on Ctrl; kami: Execute else MS) | 2: kami, rb | yes | 0 | - | 24 | 3 |

Texts (cwf):
- #1 `#showtooltip [mod:shift] Hamstring; Mortal Strike` / `/startattack` / `/cast [mod:shift] Hamstring; Mortal Strike`
- #2 `#showtooltip Sweeping Strikes` / `/cast [nostance:1] Battle Stance` / `/cast Sweeping Strikes`. This is a
  stance swap, so it needs two presses (POPULAR §0.1).
- #3 `#showtooltip Spearing Strike` / `/startattack` / `/cast Spearing Strike`

Built five, most useful for Arms (AFGELEID): **W2**, then W3, then W1.

### Fury
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Bloodthirst + `/startattack` (rb: Execute on Ctrl) | 4: cwf, gh, kami, rb | yes | 0 | Bloodthirst 23881, Fury | 40 | 5 |
| 2 | **NEW** | Death Wish burst (+ Bloodrage / Recklessness / trinkets) | 4: cwf, fdb, rb, wfgg | yes | 0 | Death Wish 12328, Fury | 1 (spell) | 5 |
| 3 | **NEW** | Whirlwind from any stance (rb: Cleave on Ctrl) | 2: cwf, rb | yes | 0 | - (baseline) | 36 | 3 |
| 4 | W5 | Pummel on mouseover (cwf Fury section) | 1: cwf | - | 0 | - | 38 | 1 |

Texts (cwf):
- #1 `#showtooltip Bloodthirst` / `/startattack` / `/cast Bloodthirst` / `/cast [mod:shift] Heroic Strike`
- #2 `#showtooltip Death Wish` / `/cast Bloodrage` / `/cast Death Wish` / `/use 14`
- #3 `#showtooltip Whirlwind` / `/cast [nostance:3] Berserker Stance` / `/cast Whirlwind` (two presses)

Built five for Fury: **W5** (Pummel in Berserker), W3, W1 (Intercept).

### Protection
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Shield Slam (+ Shield Block first; cwf: → Revenge → Sunder) | 5: cwf, kami, rb, wfgg, **iv** | yes | 0 | Shield Slam 23922, Prot | 40 | 6 |
| 2 | **NEW** | Revenge + Shield Block on one key | 4: cwf, fdb, kami, rb | yes | 1 sure (Pixxy 1 Nov) + 1 likely (pigzig 9 Nov) | - (Revenge 14, Shield Block 16) | 14 | 6 |
| 3 | **NEW** | Shield Wall, Last Stand on Shift (rb: the other way round) | 4: cwf, fdb, kami, rb | yes | 0 | Last Stand 12975 is a Prot talent; Shield Wall baseline | 28 | 5 |
| 4 | W7 (not in the 5) | Sunder Armor on mouseover / find a target | 4: cwf, fdb, kami, rb (Taunt + Sunder) | yes | 0 | - | 10 | 5 |
| 5 | W6 | Taunt on mouseover (rb: + Sunder) | 4: cwf, fdb, kami, rb | yes | (POPULAR: 4) | - | 10 | 5+ |

Texts:
- #1 (iv, Icy Veins Protection Warrior rotation page, 4 Nov 2026) `#showtooltip Shield Slam` / `/cast Shield Block` /
  `/cast Shield Slam`. Icy Veins says Shield Block is off the GCD and that the same pattern works on every main
  ability.
- #1 (cwf) `#showtooltip Shield Slam` / `/startattack` / `/cast Shield Slam` / `/cast Revenge` / `/cast Sunder Armor`
- #2 (cwf) `#showtooltip Revenge` / `/startattack` / `/cast [mod:shift,equipped:Shields] Shield Block` / `/cast Revenge`.
  Player variant: Revenge + Shield Block with no modifier (Pixxy, US forum thread 2397527, 1 Nov 2026).
- #3 (cwf) `#showtooltip Shield Wall` / `/cast [mod:shift] Last Stand` / `/cast [nostance:2] Defensive Stance` /
  `/cast Shield Wall`
- #4 (cwf) `#showtooltip Sunder Armor` / `/startattack` / `/cast [@mouseover,harm,nodead][] Sunder Armor`

Built five for Prot: **W6** Taunt, **W5** Shield Bash.

---

## 4. Rogue (built: R2 opener, R4 sap, R5 kick, R3 pickpocket, blind)

### Assassination
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Cold Blood + Eviscerate (Shift: Mutilate); rb also has Cold Blood + Ambush | 4: cwf, fdb, rb, wfgg | yes | 0 | Cold Blood 14177, Assa | no SkillLineAbility row | 5 |
| 2 | **NEW** | Mutilate + `/startattack` | 4: cwf, kami, wfgg, zk (rb: Garrote → Mutilate opener) | (yes, as opener) | 0 | Mutilate 399956, Assa | 40 | 4-5 |
| 3 | **NEW** | Slice and Dice, Venom on Shift (Forever-new Venom) | 2: cwf, zk | - | 0 | Venom 1329328, Assa | 30 | 2 |

Texts (cwf):
- #1 `#showtooltip [mod:shift] Mutilate; Eviscerate` / `/cast Cold Blood` / `/cast [mod:shift] Mutilate; Eviscerate`
- #2 `#showtooltip Mutilate` / `/startattack` / `/cast Mutilate`
- #3 `#showtooltip [mod:shift] Venom; Slice and Dice` / `/cast [mod:shift] Venom; Slice and Dice` (cwf text as copied
  on 60.tools)

Built five: **R2** (rb's Garrote → Mutilate is an R2 variant), R5.

### Combat
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Adrenaline Rush + both trinkets (→ Blade Flurry) | 4: cwf, fdb, rb, wfgg | yes | 0 | Adrenaline Rush 13750, Combat | no SkillLineAbility row | 5 |
| 2 | **NEW** | Blade Flurry, Shift cancels it | 3: cwf, fdb, rb | yes | 0 | Blade Flurry 13877, Combat | - | 4 |
| 3 | **NEW** | Riposte, then Sinister Strike (or mouseover Riposte) | 2: cwf, gh | - | 0 | Riposte 14251, Combat | - | 2 |

Texts (cwf):
- #1 `#showtooltip Adrenaline Rush` / `/use 13` / `/use 14` / `/castsequence reset=20 Adrenaline Rush, Blade Flurry`.
  Castsequence stalls were reported in the beta (file A).
- #2 `#showtooltip Blade Flurry` / `/cancelaura [mod:shift] Blade Flurry` / `/startattack [nomod]` /
  `/cast [nomod] Blade Flurry`
- #3 `#showtooltip Sinister Strike` / `/startattack` / `/cast Riposte` / `/cast Sinister Strike`

Built five: **R5** Kick, R2 (its Sinister Strike fallback).

### Subtlety
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Premeditation, then open (Ambush / Cheap Shot / Garrote) | 3: cwf, fdb, rb | yes | 0 | Premeditation 14183, Sub | 20 | 4 |
| 2 | **NEW** | Ghostly Strike, else Backstab (rb: + Evasion) | 2: cwf, rb | yes | 0 | Ghostly Strike 14278, Sub | - | 3 |
| 3 | **NEW** | Vanish / escapes, then Preparation | 2: cwf, rb | yes | 0 | Preparation 14185, Sub | - | 3 |
| 4 | **NEW** | Hemorrhage + `/startattack` | 2: cwf, kami | - | 0 | Hemorrhage 16511, Sub | 30 | 2 |

Texts (cwf):
- #1 `#showtooltip [mod:shift] Ambush; Garrote` / `/cast [stealth] Premeditation` / `/cast [mod:shift] Ambush; Garrote`
- #2 `#showtooltip Ghostly Strike` / `/startattack [nostealth]` / `/cast Ghostly Strike` / `/cast Backstab`
- #3 `#showtooltip Preparation` / `/stopattack [mod:shift]` / `/cast [mod:shift] Vanish; Evasion` / `/cast Sprint` /
  `/cast Preparation`
- #4 `#showtooltip Hemorrhage` / `/startattack` / `/cast Hemorrhage`

Built five: **R2** (Ambush / Cheap Shot), R4 Sap.

---

## 5. Hunter (built: H8 feign, H4 meleeweave, petcontrol, H1 mark+pet, H5 petcare)

### Beast Mastery
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Intimidation + `/petattack` | 4: cwf, fdb, rb, zk | yes | 0 | Intimidation 19577, BM | 30 | 5 |
| 2 | **NEW** | Bestial Wrath + trinket (Rapid Fire on Shift) | 4: cwf, fdb, rb, wfgg | yes | 0 | Bestial Wrath 19574, BM | 40 | 5 |
| 3 | **NEW** | Summon Hawk with the pet sent in (Arcane Shot on a modifier) | 3: cwf, rb, zk | yes | 0 | Summon Hawk 1293241, BM | 25 | 4 |

Texts (cwf):
- #1 `#showtooltip Intimidation` / `/petattack` / `/cast Intimidation`
- #2 `#showtooltip Bestial Wrath` / `/petattack` / `/use 13` / `/cast [mod:shift] Rapid Fire` / `/cast Bestial Wrath`
- #3 `#showtooltip Summon Hawk` / `/petattack [@mouseover,harm,nodead][]` / `/cast [@mouseover,harm,nodead][] Summon Hawk`

Built five: **petcontrol**, H1, H5. Player posts are class-wide, not BM:
- EvoCyber (17 Oct): pet ability macro.
- Ullad (21 Sep): Aspect of the Hawk + Arcane Shot on one key.
- SpizyPie (5 Oct): `!Aspect of the Hawk` recasts the aspect anyway, a bug report.

### Marksmanship
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Scatter Shot with the pet held back (rb: Freezing Trap on Ctrl) | 4: cwf, gh, rb, zk | yes | 0 | Scatter Shot 19503, MM | 30 | 5 |
| 2 | H3 (not in the 5) | Aimed Shot / Multi-Shot on one key (rb: + Rapid Fire) | 2: cwf, rb | yes | 0 | - (baseline in Forever) | 20 | 3 |
| 3 | H1-type | Hunter's Mark → Serpent Sting opener | 2: cwf, rb | yes | 0 | - | 6 | 3 |
| 4 | **NEW** | Sniper Shot + Auto Shot (Forever-new) | 2: cwf, zk | - | 0 | Sniper Shot 1310687, MM | 40 | 2 |

Texts (cwf):
- #1 `#showtooltip Scatter Shot` / `/petstay [@pettarget,harm]` / `/petpassive [@pettarget,harm]` /
  `/cast [mod:shift,@mouseover,harm,nodead] Scatter Shot; Scatter Shot`
- #4 `#showtooltip Sniper Shot` / `/cast [mod:shift,@mouseover,harm,nodead][] Sniper Shot` / `/cast !Auto Shot`

AFGELEID on H3: Aimed Shot is not in `TraitDefinition`, so in Forever every hunter has it (from 20). It is a class
macro, but only the MM sources pick it.

Built five: **H1** Mark + pet, H8.

### Survival
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Strider Kick (+ Raptor Strike, Wing Clip on Ctrl) (Forever-new) | 3: cwf, rb, zk (+wfgg melee button) | yes | 1 (Hadre 24 Oct, weapon-swap version) | Strider Kick 1317257, SV | 30 | 5 |
| 2 | **NEW** | Counterattack on mouseover, Deterrence on Shift | 3: cwf, rb, wfgg | yes | 0 | Counterattack 19306, Deterrence 19263, SV | 30 | 4 |
| 3 | **NEW** | Deterrence + `!Aspect of the Monkey` | 2: cwf, fdb | - | 0 | Deterrence 19263, SV | 20 | 2 |
| 4 | NEW (POPULAR "traps") | Traps on modifiers | 2: cwf, rb | yes | (POPULAR: 1) | - | 20/28/34 | 3 |

Texts (cwf):
- #1 `#showtooltip Strider Kick` / `/startattack [nomod]` / `/cast [mod:shift,@mouseover,harm,nodead][] Strider Kick`
- #2 `#showtooltip Counterattack` / `/cast [mod:shift] Deterrence` / `/startattack` /
  `/cast [@mouseover,harm,nodead][] Counterattack`
- #3 `#showtooltip Deterrence` / `/cast Deterrence` / `/cast !Aspect of the Monkey`. The `!Aspect` caveat from
  SpizyPie (5 Oct) applies.

Built five: **H4** melee weave (Swervus, 14 Oct, also macros Raptor Strike + Wing Clip), H8.

---

## 6. Paladin (built: P7 holylight, P2 holystrike, divineshield, holyshock (talent), protectally)

### Holy
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | built "holyshock" | Holy Shock friend-or-foe | 7: cwf, gh, kami, rb, senseos, wfgg, zk | yes | 0 | Holy Shock 1311606, Holy | 30 | 8 |
| 2 | **NEW** | Light's Vigil, Shift = Holy Shock (Forever-new) | 7: cwf, fdb, gh, kami, mm, wfgg, zk | - | 1 (Laweternal 19 Oct, idea) | Light's Vigil 1310911, Holy | 40 | 8 |
| 3 | **NEW** | Divine Favor → Holy Light (or Holy Shock) | 5: cwf, fdb, gh, rb, wfgg | yes | 0 | Divine Favor 20216, Holy | no SkillLineAbility row | 6 |
| 4 | built P7 | Holy Light / Flash of Light on mouseover | 6: cwf, fdb, gh, kami, rb, wfgg | yes | 0 | - | 1 | 7 |
| 5 | **NEW** | Purify / Cleanse on mouseover | 3: cwf, fdb, kami | - | 0 | - | 8 / 42 | 3 |

Texts (cwf):
- #2 `#showtooltip [mod:shift] Holy Shock; Light's Vigil` / `/cast [mod:shift,@mouseover,exists,nodead][mod:shift,exists,nodead] Holy Shock; [@mouseover,help,nodead][help,nodead][@player] Light's Vigil`
- #3 `#showtooltip [mod:shift] Flash of Light; Holy Light` / `/cast Divine Favor` / `/cast [mod:shift,@mouseover,help,nodead][mod:shift] Flash of Light; [@mouseover,help,nodead][help,nodead][@player] Holy Light`
- #5 `#showtooltip Cleanse` / `/cast [mod:alt,@player][@mouseover,help,nodead][help,nodead][@player] Cleanse`
  (Purify: the same line with Purify)

Built five: **holyshock**, **P7**, protectally.

### Protection
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | P4 (not in the 5) | Judgement taunt on mouseover (rb: Swift Judgement on Ctrl) | 3: fdb, kami, rb | yes | 2 (Opti 21 Sep; thebigmoist 28 Oct) | Swift Judgement 1310994 for the Ctrl part, Prot | - | 6 |
| 2 | **NEW** | Hammer of the Righteous, Shift = Holy Strike (or Consecration) | 4: cwf, kami, rb, wfgg | yes | 0 | - (HotR not in TraitDefinition) | 40 | 5 |
| 3 | **NEW** | Holy Shield + Judgement in one press | 3: cwf, kami, rb | yes | 0 | Holy Shield 20925, Prot | 30 | 4 |
| 4 | **NEW** | Templar's Bulwark, Shift = Divine Protection (rb: Lay on Hands self on Ctrl) | 3: cwf, rb, zk | yes | 0 | Templar's Bulwark 1311015, Prot | - | 4 |

Texts:
- #1 is file B's P4. foreverdb text not re-extracted; the plain form is `/cast [@mouseover,harm,nodead][] Judgement`
  (AFGELEID, my own one-liner).
- #2 (cwf) `#showtooltip [mod:shift] Holy Strike; Hammer of the Righteous` / `/startattack` /
  `/cast [mod:shift] Holy Strike; Hammer of the Righteous`
- #3 (cwf) `#showtooltip Holy Shield` / `/startattack` / `/cast Judgement` / `/cast Holy Shield`. Judgement 20271 is off
  the GCD (POPULAR / parent notes, GEMETEN).
- #4 (cwf) `#showtooltip [mod:shift] Divine Protection; Templar's Bulwark` /
  `/cast [mod:shift] Divine Protection; Templar's Bulwark`

Built five: **divineshield** (JonS, 22 Oct: "Cancelaura macro divine shield is the norm as a paladin tank"),
P2 holystrike, protectally.

### Retribution
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Seal of Command / Judgement key (seal twist that keeps swinging) | 3: cwf, kami, rb | yes | 3 (hiddenmarkov 21 Sep; Apachecheif 15 Sep; cletiscake 5 Nov) | Seal of Command 20375, Ret | 20 | 7 |
| 2 | built P2 | Holy Strike + Judgement + `/startattack` | (class-level) | - | 2 (crazyapple 4 Nov; PHR 8 Nov) | - | 4/6 | - |
| 3 | **NEW** | Opener castsequence Crusader → Judgement → Command | 2: cwf, kami | - | (hiddenmarkov) | Seal of Command, Ret | 20 | 3 |
| 4 | **NEW** | Hammer of Wrath with Judgement | 2: cwf, rb | yes | 0 | - | 44 | 3 |

Texts:
- #1 (cwf) `#showtooltip [mod:shift] Seal of Command; Judgement` / `/cast [mod:shift] Seal of Command; Judgement`
- #3 (cwf as copied on 60.tools) `#showtooltip` / `/castsequence reset=10 Seal of the Crusader, Judgement, Seal of Command` / `/startattack`
- #4 (cwf) `#showtooltip [mod:shift] Hammer of Wrath; Holy Strike` / `/startattack` /
  `/cast [mod:shift] Hammer of Wrath; Holy Strike`

Player caveat (GEMETEN, one post): ShadowofNoob (5 Nov) says the `/startattack` macro "was not working with my seals
only worked for judgement".

Built five: **P2**, divineshield, protectally.

---

## 7. Shaman (built: S4 earthshock, S6 healwave, S1 totems, S5 purge, firenova)

### Elemental
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Lightning Mastery, then Lightning Bolt / Chain Lightning on Shift | 3: cwf, rb, wfgg | yes | 0 | Lightning Mastery 16166, Ele | CL 32 | 4 |
| 2 | **NEW** | Lightning Bolt with a cancel-cast (rb: Frost Shock on Ctrl; cwf: LB or CL) | 2: cwf, rb | yes | 1 (McStankDaddy 4 Nov) | - | 1 / 20 | 4 |
| 3 | **NEW** | Earthbind Totem mid-cast (`/stopcasting`) | 2: cwf, rb | yes | 0 | - | 6 | 3 |
| 4 | built firenova | Fire Nova (rb: Magma Totem on Ctrl) | 2: cwf, rb | yes | 0 | - | 12 | 3 |

Texts (cwf):
- #1 `#showtooltip [mod:shift] Chain Lightning; Lightning Bolt` / `/cast Lightning Mastery` /
  `/cast [mod:shift] Chain Lightning; Lightning Bolt`
- #2 `#showtooltip [mod:shift] Chain Lightning; Lightning Bolt` / `/cast [mod:shift] Chain Lightning; Lightning Bolt`.
  Add `/stopcasting [mod:shift]` for the cancel-cast the player describes (AFGELEID).
- #3 `#showtooltip [mod:shift] Frost Shock; Earthbind Totem` / `/stopcasting` /
  `/cast [mod:shift,@mouseover,harm,nodead][mod:shift] Frost Shock; Earthbind Totem`

Built five: **S4**, firenova, S1.

### Enhancement
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Stormstrike + `/startattack` (rb: Rage of the Farseer on Ctrl) | 4: cwf, fdb, rb, zk | yes | 0 | Stormstrike 17364, Enh | 40 | 5 |
| 2 | S8 (not in the 5) | Shock + `/startattack` (rb: Flame Shock, Earth Shock on Ctrl) | 2: cwf, rb | yes | 2 (Seawolf 20 Sep; Kasorayn 9 Nov, POPULAR) | - | 4/10 | 5 |
| 3 | **NEW** | Rage of the Farseer + trinkets → Stormstrike (Forever-new) | 3: cwf, wfgg, zk (+rb in #1) | (in #1) | 0 | Rage of the Farseer 425336, Enh | - | 3-4 |

Texts (cwf):
- #1 `#showtooltip Stormstrike` / `/startattack` / `/cast Stormstrike`
- #3 `#showtooltip Stormstrike` / `/startattack` / `/cast [mod:ctrl] Rage of the Farseer` / `/use [mod:ctrl] 13` /
  `/use [mod:ctrl] 14` / `/cast Stormstrike`

Built five: **S4**, S1, S5.

### Restoration
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Nature's Swiftness → instant Healing Wave (mouseover) | 6: cwf, fdb, gh, rb, wfgg, zk | yes | 0 | Nature's Swiftness 16188, Resto | - | 7 |
| 2 | **NEW** | Riptide on mouseover (rb: Chain Heal on Ctrl) (Forever-new) | 5: cwf, gh, kami, rb, wfgg | yes | 0 | Riptide 408521, Resto | 40 | 6 |
| 3 | **NEW** | Chain Heal on mouseover | 3: cwf, kami, zk (+rb Ctrl) | - | 0 | - | 40 | 3 |
| 4 | built S6 | Healing Wave / Lesser Healing Wave on mouseover | 6 incl. LHW variants | yes (LHW) | 0 | - | 1 / 20 | 7 |

Texts (cwf):
- #1 `#showtooltip Healing Wave` / `/cast Nature's Swiftness` / `/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] Chain Heal; [@mouseover,help,nodead][help,nodead][@player] Healing Wave`
- #2 `#showtooltip Riptide` / `/cast [@mouseover,help,nodead][help,nodead][@player] Riptide`
- #3 `#showtooltip Chain Heal` / `/cast [@mouseover,help,nodead][help,nodead][@player] Chain Heal`

Also counted: Ancestral Spirit on mouseover (3: cwf, fdb, kami), Water Shield (talent 408510; 3: cwf, fdb, zk), Cure
Poison/Disease on mouseover (2).

Built five: **S6**, S5, S1.

## 8. Mage (built: M2 counterspell, M1 polymorph, M3 frostnova, M8 decurse, M7 frostbolt)

### Arcane
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Burst: trinkets + Arcane Power (+ Presence of Mind) → Arcane Blast | 5: cwf, fdb, gj, rb, wfgg | yes | 0 | Arcane Power 12042, Presence of Mind 12043, Arcane | - | 6 |
| 2 | **NEW** | Arcane Blast that never clips Arcane Missiles (modifiers) | 4: cwf, gh, kami, zk | - | 0 | Arcane Blast 400574, Arcane | 20 | 4 |
| 3 | **NEW** | Instant Arcane Wrath (Presence of Mind; Arcane Power on Shift) (Forever-new) | 3: cwf, kami, zk | - | 0 | Arcane Wrath 1326079, Arcane | 25 | 3 |
| 4 | MX2 (not in the 5) | Arcane Explosion (rb: Arcane Power on Ctrl; cwf: rank 1 out of combat) | 2: cwf, rb | yes | 0 | - | 14 | 3 |

Texts (cwf):
- #1 `#showtooltip Arcane Blast` / `/use 13` / `/use 14` / `/cast Arcane Power` /
  `/cast [nochanneling:Arcane Missiles] Arcane Blast`
- #2 `#showtooltip Arcane Blast` / `/cast [mod:shift,nochanneling:Arcane Missiles] Arcane Missiles; [mod:ctrl,nochanneling:Arcane Missiles] Frostbolt; [nochanneling:Arcane Missiles] Arcane Blast`
- #3 `#showtooltip Arcane Wrath` / `/stopcasting` / `/use [mod:shift] 13` / `/use [mod:shift] 14` /
  `/cast [mod:shift] Arcane Power` / `/cast Presence of Mind` / `/cast Arcane Wrath`

Built five: **M2** (rb: Counterspell → PoM Polymorph), M1.

### Fire
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Pyroblast opener, Fireball after (rb: + trinkets) | 3: cwf, kami, rb | yes | 0 | Pyroblast 11366, Fire | 20 | 4 |
| 2 | **NEW** | Trinkets + Combustion, then Fireball | 3: cwf, rb, wfgg | yes | 0 | Combustion 11129, Fire | 40 | 4 |
| 3 | **NEW** | Blast Wave right now (`/stopcasting`) | 3: cwf, kami, rb | yes | 0 | Blast Wave 11113, Fire | 30 | 4 |

Texts (cwf):
- #1 `#showtooltip [nocombat] Pyroblast; Fireball` / `/cast [nocombat] Pyroblast; Fireball`
- #2 `#showtooltip Combustion` / `/use 13` / `/use 14` / `/cast Combustion` / `/cast [mod:shift] Scorch; Fireball`
- #3 `#showtooltip Blast Wave` / `/stopcasting` / `/cast Blast Wave`

Built five: **M2**, M1, M3.

### Frost
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | M6 (not in the 5) | Ice Block, press again (or modifier) to break it | 6: cwf, fdb, gh, rb, wfgg, zk | yes | 0 | Ice Block 11958, Frost | 4 (spell) | 7 |
| 2 | **NEW** | Ice Lance mid-cast (Fire Blast / Cone of Cold on modifiers) | 5: cwf, kami, rb, wfgg, zk | yes | 0 | Ice Lance 1312002, Frost | 20 | 6 |
| 3 | **NEW** | Ice Barrier, Cold Snap first on a modifier | 4: cwf, kami, rb, wfgg | yes | 0 | Ice Barrier 11426, Cold Snap 12472, Frost | 40 | 5 |

Texts:
- #1 (fdb, license not stated) `#showtooltip Ice Block` / `/stopcasting` / `/cancelaura Ice Block` / `/cast Ice Block`.
  This is file C's M6.
- #2 (cwf) `#showtooltip Ice Lance` / `/stopcasting` / `/cast [mod:shift] Fire Blast; [mod:ctrl] Cone of Cold; Ice Lance`
- #3 (cwf) `#showtooltip` / `/stopcasting` / `/cast [mod:shift][mod:ctrl] Cold Snap` / `/cast [mod:ctrl] Ice Barrier; Frost Nova`

Built five: **M3** Frost Nova, M7 Frostbolt, M2.

---

## 9. Warlock (built: W2 fear, agony, W8 demonbutton, curses, summon)

### Affliction
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | built "agony" + **NEW** variant | Amplify Curse → Bane of Agony | 3: cwf, fdb, rb | yes | (Aarku 22 Sep wishes for "improved curse" + trinket + racial + dots) | Amplify Curse 18288, Affl | - | 4-5 |
| 2 | **NEW** | Curse of Exhaustion mid-cast (Amplify first) | 2: cwf, rb | yes | 0 | Curse of Exhaustion 18223, Affl | - | 3 |
| 3 | W6 (not in the 5) | Drain Life / Drain Soul you can mash | 2: cwf, rb | yes | 0 | - | 14 / 10 | 3 |
| 4 | **NEW** | Siphon Life on mouseover | 2: cwf, kami | - | 0 | Siphon Life 18265, Affl | 30 | 2 |
| 5 | **NEW** | Wrack without clipping (Forever-new) | 2: cwf, zk | - | 0 | Wrack 1316697, Affl | 40 | 2 |

Texts (cwf):
- #1 `#showtooltip Bane of Agony` / `/cast Amplify Curse` / `/cast Bane of Agony`
- #2 `#showtooltip Curse of Exhaustion` / `/stopcasting` / `/cast Amplify Curse` /
  `/cast [@mouseover,harm,nodead][] Curse of Exhaustion`
- #4 `#showtooltip Siphon Life` / `/cast [@mouseover,harm,nodead][] Siphon Life`
- #5 `#showtooltip Wrack` / `/cast [nochanneling:Wrack,@mouseover,harm,nodead][nochanneling:Wrack] Wrack`

Built five: **agony**, curses, W2.

### Demonology
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | built "summon" | Summon demon on modifiers, Fel Domination in combat | 5: cwf, fdb, gh, rb, wfgg | yes | 0 | **Fel Domination 18708 is a Demonology talent** | 10 | 6 |
| 2 | **NEW** | Demonic Sacrifice, then summon another demon | 3: cwf, fdb, rb (Ctrl in Health Funnel) | yes | 0 | Demonic Sacrifice 18788, Demo | - | 4 |
| 3 | W3 (not in the 5) | Health Funnel that doesn't restart | 2: cwf, rb | yes | 0 | - | 12 | 3 |
| 4 | **NEW** | Searing Pain that sends the demon at the same enemy | 2: cwf, rb | yes | 0 | - | 18 | 3 |

Texts (cwf):
- #2 `#showtooltip Demonic Sacrifice` / `/cast Demonic Sacrifice` / `/cast [mod:shift] Summon Imp; [mod:ctrl] Summon Voidwalker; [mod:alt] Summon Succubus; Summon Felhunter`
- #3 `#showtooltip Health Funnel` / `/stopcasting [mod:shift]` / `/stopmacro [mod:shift]` /
  `/cast [@pet,exists,nodead,nochanneling:Health Funnel] Health Funnel`
- #4 `#showtooltip Searing Pain` / `/petattack [@mouseover,harm,nodead][harm,nodead]` /
  `/cast [@mouseover,harm,nodead][] Searing Pain`

AFGELEID on the built "summon": its `/cast [combat] Fel Domination` line is talent-only. What a non-Demonology warlock
sees when it fires is not measured.

Built five: **summon**, W8.

### Destruction
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Bane of Havoc on mouseover (Forever-new) | 4: cwf, rb, wfgg, zk | yes | 0 | Bane of Havoc 1225228, Destro | - | 5 |
| 2 | **NEW** | Shadowburn right now (rb: Conflagrate on Ctrl) | 4: cwf, fdb, kami, rb | yes | 0 | Shadowburn 17877, Destro | 20 | 5 |
| 3 | **NEW** | Nuke picker: Shadow Bolt, Shift Incinerate, Ctrl Conflagrate, Alt Shadowburn | 4: cwf, kami, wfgg, zk | - | 0 | Incinerate 412758, Conflagrate 1293817, Destro | 40 / 25 | 4 |

Texts (cwf):
- #1 `#showtooltip Bane of Havoc` / `/cast [@mouseover,harm,nodead][] Bane of Havoc`
- #2 `#showtooltip Shadowburn` / `/cast [@mouseover,harm,nodead][] Shadowburn`
- #3 `#showtooltip` / `/cast [mod:shift] Incinerate; [mod:ctrl] Conflagrate; [mod:alt] Shadowburn; Shadow Bolt`

Also with an rb pick: Hellfire without restart (cwf, rb), Soul Fire opener (cwf, rb). Built five: W2, curses.

---

## 10. Priest (built: P3 flashheal, P4 dispel, P1 pwshield, penance (talent), swpain)

### Discipline
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | built "penance" | Penance friend-or-foe | 7: cwf, fdb, gh, kami, rb, wfgg, zk | yes | 0 | Penance 402174, Disc | 30 | 8 |
| 2 | **NEW** | Power Infusion on mouseover / focus / you | 4: cwf, gh, rb, zk | yes | 0 | Power Infusion 10060, Disc | 40 | 5 |
| 3 | **NEW** | Inner Focus → Flash Heal / Greater Heal | 4: cwf, fdb, rb (with PoH), wfgg | yes | 0 | Inner Focus 14751, Disc | - | 5 |
| 4 | P8 (not in the 5) | Prayer of Healing (Inner Focus on a modifier) | 3: fdb, kami, rb | yes | 0 | - | 30 | 4 |

Texts (cwf):
- #2 `#showtooltip Power Infusion` / `/cast [mod:alt,@player][@mouseover,help,nodead][help,nodead][@player] Power Infusion`
- #3 `#showtooltip Greater Heal` / `/cast Inner Focus` / `/cast [@mouseover,help,nodead][help,nodead][@player] Greater Heal`

Built five: **penance**, **P1**, P3, P4.

### Holy
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Prayer of Mending on mouseover / focus (Forever-new for Classic) | 6: cwf, gh, kami, rb, wfgg, zk | yes | 0 | Prayer of Mending 401859, Holy | 40 | 7 |
| 2 | P2 (not in the 5) | Renew on mouseover (cwf: Rank 5 on Shift) | 3: cwf, fdb, kami (+rb on Ctrl) | (yes) | 1 (Bixby 30 Sep: the Renew mouseover works) | - | 8 | 5 |
| 3 | **NEW** | Holy Nova rank 1, top rank on Shift | 3: cwf, kami, rb | yes | 0 | Holy Nova 15237, Holy | 20 | 4 |
| 4 | P8 (not in the 5) | Prayer of Healing on mouseover's group | 3: cwf, fdb, kami | - | 0 | - | 30 | 3 |

Texts (cwf):
- #1 `#showtooltip Prayer of Mending` / `/cast [@mouseover,help,nodead][help,nodead][@player] Prayer of Mending`
- #2 `#showtooltip Renew` / `/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] Renew(Rank 5); [@mouseover,help,nodead][help,nodead][@player] Renew`
- #3 `#showtooltip Holy Nova` / `/stopcasting [mod:shift]` / `/cast [mod:shift] Holy Nova; Holy Nova(Rank 1)`

**Player caveat (GEMETEN, one post, beta-era):** Bixby (30 Sep) could not get a mouseover **Lesser Heal** to work
"unless i have the friendly player targeted". The same Renew macro worked. AFGELEID: cast-time mouseover heals
(P3 Flash Heal, P7, S6, D8) may behave differently from instants. That is not measured on live.

Built five: **P3**, P4, P1.

### Shadow
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Silence focus/mouseover/target, even mid-cast | 6: cwf, fdb, gh, rb, wfgg, zk | yes | 0 | Silence 15487, Shadow | - | 7 |
| 2 | **NEW** | Mind Flay that won't restart (rb: puts Shadowform back on) | 5: cwf, gh, kami, rb, zk | yes | 0 | Mind Flay 15407, Shadow | 20 | 6 |
| 3 | **NEW** | Shadowform on, Shift drops it / leave Shadowform + Flash Heal | 3: cwf, gh, rb | yes | 0 | Shadowform 15473, Shadow | - | 4 |

Texts:
- #1 (fdb, license not stated) `#showtooltip Silence` / `/stopcasting` /
  `/cast [@focus,harm,nodead][@mouseover,harm,nodead][] Silence`. The cwf version uses Shift for mouseover.
- #2 (cwf) `#showtooltip Mind Flay` / `/cast [nochanneling:Mind Flay] Mind Flay`
- #3 (cwf) `#showtooltip Shadowform` / `/cancelaura [mod:shift] Shadowform` / `/cast [nomod,noform:1] Shadowform`, and
  `#showtooltip Flash Heal` / `/cancelaura Shadowform` / `/cast [@mouseover,help,nodead][help,nodead][@player] Flash Heal`

Built five: **swpain** (Myk, 28 Sep: SW:Pain + `/cast !Shoot` works on his priest), P4. Fake (16 to 31 Oct) says the
whole Shadow rotation fits one castsequence. That is an opinion, not counted.

---

## 11. Druid (built: D8 healtouch, rejuv, wildbuffs, D2 travel (formbar warning), D4 innervate)

### Balance
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Insect Swarm on mouseover (rb: cancel-cast, Moonfire on Ctrl) | 3: cwf, kami, rb | yes | 0 | Insect Swarm 5570, Balance | 20 | 4 |
| 2 | **NEW** | Starfire / Wrath key (rb: back into Moonkin; trinkets) | 2: cwf, rb | yes | 1 (Risemix 3 Nov castsequence; Zolmation same day says it drifts) | - | 20 | 4 |
| 3 | **NEW** | Leave Moonkin to heal (Regrowth / Rejuvenation) | 2: cwf, rb | yes | 0 | Moonkin Form 24858, Balance | 40 | 3 |
| 4 | NEW (POPULAR) | Faerie Fire on mouseover | 2: cwf, kami | - | 0 | - | 18 | 2 |

Texts (cwf):
- #1 `#showtooltip Insect Swarm` / `/cast [@mouseover,harm,nodead][] Insect Swarm`
- #2 `#showtooltip [mod:shift] Wrath; Starfire` / `/cast [mod:shift] Wrath; Starfire`
- #3 `#showtooltip` / `/cancelform` / `/castsequence [@player] reset=10 Regrowth, Moonkin Form`. This may hit the form
  bar bug (POPULAR §0.1).

Built five: **rejuv**, **wildbuffs**, D4.

### Feral Combat
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Feral Charge + `/startattack` (rb: Bash up close) | 5: cwf, fdb, gh, rb, zk | yes | 0 | Feral Charge 1238122, Feral | 20 | 6 |
| 2 | DX3 (not in the 5) | Growl on mouseover (rb: + Faerie Fire, Challenging Roar on Ctrl) | 4: cwf, fdb, kami, rb | yes | 0 | - | 10 | 5 |
| 3 | **NEW** | Primal Bite + `/startattack` (rb: Maul queued) (Forever-new) | 4: cwf, rb, wfgg, zk | yes | 0 | Primal Bite 407995, Feral | 40 | 5 |
| 4 | **NEW** | Enrage → Frenzied Regeneration | 3: cwf, kami, rb | yes | 0 | - | 36 (FR) | 4 |
| 5 | **NEW** | Lacerate on mouseover | 3: cwf, kami, zk | - | 1 (Zarn 7 Nov: Bear → Lacerate macro) | Lacerate 1328617, Feral | 25 | 4 |
| - | D1 | Powershift `!Cat Form` | (POPULAR) | - | 7+ (bug reports) | - | 20 | (bugged) |

Texts (cwf):
- #1 `#showtooltip Feral Charge` / `/startattack` / `/cast [form:3,harm] Feral Charge` / `/cast [form:3,harm] Shred`.
  fdb uses the plain `/cast Feral Charge` / `/startattack`.
- #2 `#showtooltip Growl` / `/cast [@mouseover,harm,nodead][] Growl`
- #3 `#showtooltip Primal Bite` / `/startattack` / `/cast Primal Bite`
- #4 `#showtooltip Frenzied Regeneration` / `/cast [form:1] Enrage` / `/cast Frenzied Regeneration`

**Player caveat (GEMETEN):**
- Mattaru (25 Sep, beta): `/cancelform` / `/cast Cat Form` / `/cast Prowl` only shifts. Prowl fails with "must be in
  cat form".
- Lunatic (7 Nov): `[form:1]` Bash / War Stomp asks "is there a different syntax?".

AFGELEID: shift-then-act macros look like the warrior two-press case. Avoid shifting inside a Feral macro, as cwf's
`[form:3]` conditions do.

Built five: **D2** travel (formbar warning), D8 (self-heal), wildbuffs.

### Restoration
| # | id | Macro | Families | rb | Players | Talent | Level | Score |
|---|---|---|---|---|---|---|---|---|
| 1 | **NEW** | Nature's Swiftness → instant Healing Touch (Shift: Regrowth) | 5: cwf, fdb, rb, wfgg, zk | yes | 0 | Nature's Swiftness 17116, Resto | - | 6 |
| 2 | D5 (not in the 5) | Rebirth in combat / Revive out of combat (mouseover) | 4: cwf, fdb, kami, rb (Ctrl) | yes | 0 | - | 20 | 5 |
| 3 | **NEW** | Swiftmend on mouseover (rb: Rejuvenation, Swiftmend on Ctrl) | 3: cwf, zk, rb | yes | 0 | Swiftmend 18562, Resto | - | 4 |
| 4 | **NEW** | Wild Growth on mouseover (Forever-new for Classic) | 3: cwf, kami, zk | - | 0 | Wild Growth 408120, Resto | 40 | 3 |
| 5 | **NEW** | Regrowth on mouseover / target's target | 3: cwf, fdb, kami | - | 0 | - | 12 | 3 |

Texts (cwf):
- #1 `#showtooltip Nature's Swiftness` / `/cancelform` / `/cast Nature's Swiftness` / `/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] Regrowth; [@mouseover,help,nodead][help,nodead][@player] Healing Touch`
- #2 `#showtooltip [combat] Rebirth; Revive` / `/cast [@mouseover,help,dead,combat][help,dead,combat] Rebirth` /
  `/cast [@mouseover,help,dead,nocombat][help,dead,nocombat] Revive`
- #3 `#showtooltip Swiftmend` / `/cast [@mouseover,help,nodead][help,nodead][@player] Swiftmend`
- #4 `#showtooltip Wild Growth` / `/cast [@mouseover,help,nodead][help,nodead][@player] Wild Growth`

Built five: **D8**, **rejuv**, D4.

---

## 12. Part 2: how an addon can tell a Forever player's spec

### What the client has (GEMETEN)
| Evidence | What it shows | Source, date |
|---|---|---|
| DB2 `ChrSpecialization` | 10 rows: one per class named after the class (ids 1482-1491) + "Default" 1493. No per-tree specs. | wago DB2 Forever 1.60.1.70862 |
| DB2 `TalentTab` | 27 trees, names, order (§1) | same |
| DB2 `TraitTree`/`TraitNode` | 9 live class trees; tabs = 3 PosX bands; whole-tab node groups; one currency per tree | same |
| `Wow.exe` strings | Present: `C_ClassTalents` (22×), `C_Traits` (49×), `GetActiveConfigID`, `GetConfigInfo`, `GetTreeNodes`, `GetNodeInfo`, `GetTreeCurrencyInfo`, `C_SpecializationInfo`, `GetSpecialization`, `GetSpecializationInfo`, `GetActiveSpecGroup`; events `TRAIT_CONFIG_UPDATED`, `PLAYER_TALENT_UPDATE`, `CHARACTER_POINTS_CHANGED`. **Absent:** `GetTalentTabInfo`, `GetNumTalentTabs`, `GetNumTalents`, `GetPrimaryTalentTree`, `GetActiveTalentGroup`, `UnitCharacterPoints`, `GetUnspentTalentPoints`. Positive controls in the same run: `UnitClass`, `UnitLevel`, `GetBuildInfo`. Retail `Wow.exe` shows the same pattern. | `E:\World of Warcraft\_forever_\Wow.exe` (file date 7 Nov 2026), scratch `spec_exe_strings.py` |
| Rob's Forever SavedVariables | TalentsForeverBook's `diag.loaded` lists `Blizzard_PlayerSpells`; `framesSeen.PlayerSpellsFrame = true`. So the talent window is the modern PlayerSpellsFrame. | `_forever_\WTF\Account\JOEYWHATEVER\SavedVariables\TalentsForeverBook.lua`, written 10 Nov 2026 07:54 |
| TalentsForeverBook 0.38.21 (candidate) | Reads talents only through `C_ClassTalents.GetActiveConfigID` → `C_Traits.GetConfigInfo/GetTreeNodes/GetNodeInfo/GetEntryInfo/GetDefinitionInfo`; falls back to `C_Traits.GetConfigIDByTreeID(tree)` and `GetConfigIDBySystemID(1..40)`. Ranks via `activeRank or ranksPurchased or currentRank`. Its node→tab data matches the DB2 bands 467/467. | `_forever_\Interface\AddOns\TalentsForeverBook\Game.lua`, `Data.lua` (site data, build 70755, 5 Nov) |
| MagePlan (candidate) | Comment: "WoW Forever uses Blizzard's modern talent system (C_Traits, the PlayerSpellsFrame window) with the three classic trees drawn side by side". It splits trees by X position. `GetNumTalentTabs` is only a guarded fallback. | `_forever_\Interface\AddOns\MagePlan\Talents.lua` |
| HandyNotes_WoWForever, Zygor Forever (candidates) | `C_Traits.GetConfigIDByTreeID`; Zygor uses generic multi-flavour code (`GetPrimaryTalentTree or GetSpecialization`), so it proves nothing for Forever. Details' LibOpenRaid does not load here (it returns when the toc is below 100000). | their Lua files |

### Answer (AFGELEID)
- **Use `C_ClassTalents` + `C_Traits`. Sum the purchased ranks per X band. The band with the most points is the spec.**
  Band 1 = PosX < 4000, band 2 = < 8000, band 3 = the rest. This matches DB2 PosX 1020-2820 / 5020-6820 /
  9080-10880 and the Hunter outlier.
- Map the band to the tree name with §1 (TalentTab order).
- **No spec** when the total is 0, which is every character below level 10 (Forever talents start at 10 per
  TalentsForeverBook's `UnitLevel - 9` rule; AFGELEID). Also no spec on a tie.
- Refresh on `TRAIT_CONFIG_UPDATED`, `PLAYER_TALENT_UPDATE`, `CHARACTER_POINTS_CHANGED` and `PLAYER_ENTERING_WORLD`.
  All four names are in `Wow.exe`. TalentsForeverBook registers the first three plus `TRAIT_NODE_CHANGED`.
- Fallback when `GetActiveConfigID` gives no config holding the tree: use the class tree id from §1 with
  `C_Traits.GetConfigIDByTreeID(tree)`. This is TalentsForeverBook's own order.
- Do **not** use `C_SpecializationInfo` for the tree. AFGELEID from `ChrSpecialization`: it can only return the
  one-per-class placeholder, so a specID→role table would see 1482-1491. Do not use `GetTalentTabInfo` /
  `GetPrimaryTalentTree` either. GEMETEN: they are not in `Wow.exe`. A Lua shim in Blizzard's FrameXML could still
  define them; there is no FrameXML export under `_forever_` to check.
- For the macro window, the spec is optional. `ClassRow` already hides talent rows until `KnownSpell(need)`, and every
  spec-only macro above has a talent `need` (DB2 table). AFGELEID: use the spec only to put that spec's macros
  first, and keep showing class macros to every spec.

Sketch, untested:
```lua
local TREE = { WARRIOR=1117, PALADIN=1100, HUNTER=1091, ROGUE=1111, PRIEST=1114, SHAMAN=1082, MAGE=1112, WARLOCK=1116, DRUID=1089 }
local function ForeverSpecBand()
  local _, cls = UnitClass("player")
  local tree, cfg = TREE[cls], C_ClassTalents and C_ClassTalents.GetActiveConfigID and C_ClassTalents.GetActiveConfigID()
  local info = cfg and C_Traits.GetConfigInfo(cfg)
  if not (info and info.treeIDs and tContains(info.treeIDs, tree)) then cfg = C_Traits.GetConfigIDByTreeID(tree) end
  if not cfg then return nil end
  local pts = { 0, 0, 0 }
  for _, id in ipairs(C_Traits.GetTreeNodes(tree) or {}) do
    local n = C_Traits.GetNodeInfo(cfg, id)
    if n and n.posX then
      local b = n.posX < 4000 and 1 or (n.posX < 8000 and 2 or 3)
      pts[b] = pts[b] + (n.ranksPurchased or 0)
    end
  end
  local best = (pts[1] >= pts[2] and pts[1] >= pts[3]) and 1 or (pts[2] >= pts[3] and 2 or 3)
  if pts[best] == 0 then return nil end
  for b = 1, 3 do if b ~= best and pts[b] == pts[best] then return nil end end   -- tie: no spec
  return best, pts
end
```

Confidence:
- **High** that Forever's talents are read through `C_Traits` / `C_ClassTalents`. Four independent signs: the exe
  strings, the DB2 trees, PlayerSpellsFrame in Rob's SV, and two Forever addons that only work this way.
- **Medium-high** that the PosX band is the tab. DB2 plus a 467/467 cross-check, but it assumes the client's
  `posX` equals DB2 PosX.
- **Medium** on the field name `ranksPurchased`. It is the retail name, and TalentsForeverBook tries it second.
- **Unknown**: what `C_SpecializationInfo.GetSpecialization()` returns on Forever.

---

## 13. Test lines for Rob (GEMETEN: 253 and 189 bytes, both ≤ 255)

1. Points per tree (prints three numbers, left to right as in the talent window):
   ```
   /run local T,c,p=C_Traits,C_ClassTalents.GetActiveConfigID(),{0,0,0} for _,n in ipairs(T.GetTreeNodes(T.GetConfigInfo(c).treeIDs[1])) do local i=T.GetNodeInfo(c,n) local b=min(3,floor(i.posX/4e3)+1) p[b]=p[b]+(i.ranksPurchased or 0) end print(unpack(p))
   ```
   Pass: the three numbers equal the points in each tree of the talent window.
   - `0 0 0` with points spent: the field is called something else. Then try `currentRank`.
   - An error on `min`/`floor`: those WoW globals are missing in Forever (AFGELEID that they exist).
   - An error on `treeIDs`: there is no active config, so the fallback is needed.
2. What the spec API and the classic API say:
   ```
   /run local S=C_SpecializationInfo local s=S and S.GetSpecialization() local id,nm=S and S.GetSpecializationInfo(s or 1) print(s,id,nm,GetNumTalentTabs,GetTalentTabInfo,GetPrimaryTalentTree)
   ```
   Expected (AFGELEID): something like `1 1491 Warrior nil nil nil` on a warrior. A non-nil 4th to 6th value means
   Blizzard's Lua defines the classic functions after all.

Not tested by anyone. Rob's in-game result settles it.

---

## 14. Player posts used (GEMETEN, Blizzard forums, posted after 18 Aug 2026)

These come from the 16 searches in §2 and POPULAR's dump. Category 347/349/352 = Forever boards.

- **Warrior.**
  - Pixxy (US 2397527, 1 Nov): "macro your revenge and shield block into one button".
  - pigzig (9 Nov): an off-GCD ability "poppin on my revenge key".
  - Lancer (EU 639793, 5 Nov): Charge → Execute → Mortal Strike → Heroic Strike fall-through.
  - Shield-swap macros as old habit: oceangang (1 Oct), Sketch (13 Oct), BigDeepers (6 Oct).
  - InnovatorJay (29 Oct): a stance-dance delay complaint.
- **Paladin.**
  - Ret seal macros: hiddenmarkov (21 Sep), Apachecheif (15 Sep), cletiscake (5 Nov).
  - Holy Strike + Judgement on one key (P2): crazyapple (4 Nov), PHR (8 Nov).
  - ShadowofNoob (5 Nov): `/startattack` not working with seals.
  - Protection: Opti (21 Sep), a Swift Judgement taunt macro idea; thebigmoist (28 Oct), seal + Judgement on one
    button; JonS (22 Oct), cancelaura Divine Shield.
  - Holy: Laweternal (19 Oct), a Light's Vigil "heal snipe" macro idea.
- **Shaman.** McStankDaddy (4 Nov): cancel-cast macro to weave Chain Lightning. Seawolf (20 Sep): wants
  `/startattack` on offensive spells. Qerach (9 Oct): asks for a `[nototem]` conditional (not in the game). Locruid
  (22 Oct, 1 Nov): multibox macros, not counted.
- **Hunter.** Swervus (14 Oct): Raptor Strike + Wing Clip. Hadre (24 Oct): weapon swap with Mongoose Bite / Strider
  Kick. Ullad (21 Sep), SpizyPie (5 Oct), EvoCyber (17 Oct), Serafima (26 Sep): class-wide.
- **Priest.** Bixby (30 Sep): mouseover Lesser Heal fails, Renew works. Myk (28 Sep): SW:Pain + `!Shoot` works on
  priest, the Shadow Bolt version fails on warlock. Fake (Oct): castsequence opinions.
- **Warlock.** Aarku (22 Sep): wish for a curse + trinket + racial burst. Chad (14 Oct): Drain Soul + shard-delete
  `/run`. zack (8 Nov): `[target=none] Consume Shadows` (POPULAR).
- **Druid.**
  - Risemix (3 Nov) Balance castsequence; Zolmation (3 Nov) says it drifts; LastShinobi (31 Oct) opinion.
  - Feral: Zarn (7 Nov), Mattaru (25 Sep), Lunatic (7 Nov), BrotherTom (6 Oct) form conditionals.
  - Powershift bar bug: Raka (7 Nov), Taw (8 Nov), jmancini (7 to 8 Nov), Hotblooded (29 Sep to 9 Oct), Liger (7 Oct).
    Overlap with POPULAR's 7 authors not checked.
  - Koughee (15 Sep): mouseover macros for raid healing.
- **Rogue, Mage:** no spec-specific macro post found.

---

## 15. What I searched, and what I could not reach

**Searched (10 Nov 2026):**
- 16 forum searches (§2).
- WebSearch "wowhead forever … spec macros", "icy-veins wow-forever macros", "site:wowhead.com/forever guide warrior".
- Icy Veins Forever: index + 27 rotation pages (26 + Protection Warrior). One macro found, Protection Warrior. The
  positive control "rotation" hit in all 26 other pages.
- Icy Veins Protection Warrior main guide: no macro.
- warcrafttavern Arms + Protection Warrior, wowtbc.gg Fury, method.gg warrior, wow.gg Protection Warrior,
  gamer-guides wiki: 0 macros (GEMETEN, positive control "Warrior" hit on each page).

**Not reached:**
- **Wowhead Forever spec guides:** none found in search. `www.wowhead.com` was not opened in the browser this run.
- **mobalytics.gg** (HTTP 403 to script). **CurseForge "Forever Macro Creator"** addon page (HTTP 403). Not
  inspected.
- **Reddit:** not tried again (POPULAR: 403 / login).
- **The other 25 warcrafttavern spec guides and the other 26 Icy Veins main guides:** not fetched.
- **Forum search depth:** only the top 50 topics per query. **An empty search proves nothing.**
- **`TraitCond` per talent node:** the level a talent node opens is not measured. The table levels are spell levels.
- **Blizzard's Forever Lua (FrameXML):** not on disk. So it is unknown whether a Lua shim defines `GetTalentTabInfo`
  and friends.
- **Live client:** nothing tested. That covers the `posX` values, `ranksPurchased` and every macro.

Working files (scratchpad, temporary):
`C:\Users\RobHu\AppData\Local\Temp\claude\e1c44003d48d72c2\45f8f015-eb58-4e9a-bfdc-686d6fb09ce4\scratchpad\`
- scripts `spec_trees.py`, `spec_bands.py`, `spec_exe_strings.py`, `spec_macros.py`, `spec_ids.py`, `spec_misc.py`,
  `spec_texts.py`, `spec_forum_dump.py`
- output `out_spec\spec_report.txt`, `out_spec\spec_ids.txt`, `out_spec\spec_texts.txt`, `out_spec\forum_spec.txt`
- fetched pages `dl\spf_*`, `dl\spg_*`, `dl\ivr_*`
