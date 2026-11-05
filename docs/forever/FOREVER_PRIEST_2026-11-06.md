# WoW Forever — Priest: spells tot 60 + VOORSTEL voor het toetsenblok

> 🌙 **Nacht 5→6 nov 2026, onderzoek door mh-research (één helper per class). NIET goedgekeurd door Rob, NIET in de
> addon.** Alleen een goedgekeurde tabel komt in `Modules/ForeverBlock_<Class>.lua`.
>
> **Zelf nagekeken in de nacht (GEMETEN):**
> - beginspells staan in Blizzards data met AcquireMethod 2: Smite 585, Lesser Heal 2050 (wago wowf 1.60.1.70790, SkillLineAbility);
> - de concepttabel hieronder laadt in de échte motor (`Modules/ForeverBlock.lua`, offline met nagebootste spells):
>   elke spellnaam bestaat in SpellName, elke toets is een blok-plek, geen spell op twee toetsen;
> - stance/vorm-nummers: SpellShapeshiftForm.BonusActionBar (Cat 1, Bear 3, Stealth 1, Battle 1, Defensive 2,
>   Berserker 3, Moonkin/Shadowform/Ghost Wolf 0).
> - Niet in het spel getest. Elke toetskeuze is een voorstel (AFGELEID).
> - Voor alle classes geldt (helpers, GEMETEN in de data): een account-perk 'Talented' geeft al talentpunten vanaf
>   level 5-9, dus talent-levels hieronder kunnen tot 5 levels vroeger zijn.

**Aandachtspunten van de nachtcontrole:**
- Elk ras heeft hier eigen priest-spells (bijv. Desperate Prayer alleen Dwarf); die delen toets X en Shift-R.

---

# WoW Forever - PRIEST - spell list, states, key proposal (draft, night of 5-6 Nov 2026)

Researcher: mh-research (priest). Read only. Nothing in the repo was changed. Nothing under `MidnightHelper/docs/` was
read (my own agent rule), so the Druid spell list and plan in `docs/` were NOT read; I copied the shape from
`Modules/ForeverBlock_Druid.lua` and the engine header of `Modules/ForeverBlock.lua` instead.

Labels: **GEMETEN** = seen in a named, dated source. **AFGELEID** = my reasoning.

---

## Sources

| # | Source | Date / build | What I used it for |
|---|---|---|---|
| S1 | Local DB2 CSVs `scratchpad\wago_wowf\` (SkillLineAbility, SkillLine, SkillRaceClassInfo, SpellName, Spell, SpellLevels, SpellMisc, SpellShapeshift, SpellShapeshiftForm, SpellEffect, SpellCategories, SpellCooldowns, Trait*) | build **1.60.1.70790**, fetched 5 Nov 2026 ~23:25 (README) | the whole spell list, ranks, levels, race masks, form masks, talent tree |
| S2 | wago.tools DB2 pages, read in the in-app browser (own tab, closed after): `CharBaseInfo` (filter ClassID=5, RaceID=95, RaceID=96, page 3), `ChrRaces` ID 96 | build 1.60.1.70790, read 5/6 Nov 2026 | which races can be a priest; Skyborne race IDs |
| S3 | wago.tools Classic Era pages (branch `wow_classic_era`): `SkillLineAbility` Spell = 6346, 2944, 13908, 1277370; `CharBaseInfo` ClassID=5; `Spell` 15473; `SpellShapeshift` SpellID=585 | build **1.15.9.70576**, read 5/6 Nov 2026 | what Forever changed vs Classic Era |
| S4 | Blizzard UI source, `github.com/Gethe/wow-ui-source`, branch `forever` (`version.txt` = 1.60.1.70790): `Blizzard_ActionBarController/ActionBarController.lua` (`ActionBarController_UpdateAll`), `Blizzard_ActionBar/Shared/StanceBar.lua` | read 5/6 Nov 2026 via WebFetch (a summariser quoted the code; not byte-checked) | how bar 1 pages |
| S5 | EllesmereUI on Rob's Forever install: `_forever_\...\EllesmereUIActionBars\EUI_ActionBars_Paging.lua` lines 108-131 and 197-209; `_forever_\...\EllesmereUI\EllesmereUI_VisibilityRules.lua` lines 56-85 | file on disk 5/6 Nov 2026 | paging per class on Forever |
| S6 | MH code: `Modules/ForeverBlock.lua` (header + lines 210-289), `Modules/ForeverBlock_Druid.lua`, `Modules/KeyBlock.lua` lines 22-115 | repo on disk 5/6 Nov 2026 | table format, fixed tasks, overflow order |

Scripts (my own, scratch): `scratchpad\priest_work\*.py`; dumps `priest_compact.txt`, `tree_dump.txt`, `desc_dump.txt` in the same folder.

---

## Positive control

- **Level-1 starting spells, AcquireMethod 2 (GEMETEN, S1 SkillLineAbility):** `Smite` Rank 1 (585, SL 56 Holy, level 1),
  `Lesser Heal` Rank 1 (2050, SL 56, level 1), and `Shoot` (5019, SL 228 Wands, ClassMask 400 = priest/mage/warlock).
  Also at level 1 but AcquireMethod 0 (= not automatic, so trainer or other): `Power Word: Fortitude` Rank 1 (1243).
- **Search method works (GEMETEN):** the wago filter `ClassID=5` returned the known Human priest row (ID 4) that the
  unfiltered page also shows; the Classic Era `exact:` filter returned rows for 6346/2944/13908 before it returned
  "No entries found" for 1277370. So those empty answers are real.
- **Talent tree (GEMETEN, S1):** TraitNodeGroupDisplayInfo maps TraitTree **1114** to SkillLines 613 Discipline (group
  11608), 56 Holy (11615), 78 Shadow Magic (11622). 53 nodes. The tree uses currency 3820.

---

## Spell list (levels 1-60)

How learned: S1 cannot tell trainer from book or quest. **acq 2** = learned automatically; **acq 0** = not automatic
(trainer, book or quest - DB2 does not say which); **T** = talent node in TraitTree 1114. Tab = the skill line of the row
(GEMETEN names; that the spellbook shows one tab per line is AFGELEID). Shadowform column from SpellShapeshift
(form 28 = Shadowform, form 32 = Spirit of Redemption): **SF ok** = ShapeshiftMask has 28; **no SF** = ShapeshiftExclude
has 28 (cannot be cast in Shadowform); **free** = no row/no bits.

### Holy (SkillLine 56)

| Spell | Ranks: ID (level) | Learned | Shadowform | Note |
|---|---|---|---|---|
| Smite | 585 (1), 591 (6), 598 (14), 984 (22), 1004 (30), 6060 (38), 10933 (46), 10934 (54) | R1 acq 2, rest acq 0 | **free** | Classic Era excluded form 28 (S3); Forever does not (S1) |
| Lesser Heal | 2050 (1), 2052 (4), 2053 (10) | R1 acq 2 | no SF | |
| Heal | 2054 (16), 2055 (22), 6063 (28), 6064 (34) | acq 0 | no SF | |
| Greater Heal | 2060 (40), 10963 (46), 10964 (52), 10965 (58), 25314 (60) | acq 0 | no SF | |
| Flash Heal | 2061 (20), 9472 (26), 9473 (32), 9474 (38), 10915 (44), 10916 (50), 10917 (56) | acq 0 | no SF | |
| Renew | 139 (8), 6074 (14), 6075 (20), 6076 (26), 6077 (32), 6078 (38), 10927 (44), 10928 (50), 10929 (56), 25315 (60) | acq 0 | no SF | also 425268-425277 "Renew" acq 3, level 0 (not counted, see note A) |
| Prayer of Healing | 596 (30), 996 (40), 10960 (50), 10961 (60), 25316 (60) | acq 0 | no SF | |
| Holy Fire | 14914 (20), 15262 (24), 15263 (30), 15264 (36), 15265 (42), 15266 (48), 15267 (54), 15261 (60) | acq 0 | free | not in tree 1114 |
| Holy Nova | 15237 (20), 15430 (28), 15431 (36), 27799 (44), 27800 (52), 27801 (60) | **T** Holy row 3 | no SF | heal parts 23455/23458/23459/27803/27804/27805 share the name |
| Cure Disease | 528 (14) | acq 0 | SF ok | |
| Abolish Disease | 552 (32) | acq 0 | SF ok | |
| Resurrection | 2006 (10), 2010 (22), 10880 (34), 10881 (46), 20770 (58) | acq 0 | free | out of combat only (description) |
| Prayer of Mending | 401859 (40), 1240826 (50), 1240827 (60) | **T** Holy row 7 | no SF | 401863 = acq 3 helper row; R2/R3 IDs are new (1.24M range) |
| Lightwell | 724 (40), 27870 (50), 27871 (60) | acq 0 | free | **not in tree 1114** - whether anything teaches R1 is unknown |
| Desperate Prayer | 13908 (10), 19236 (18), 19238 (26), 19240 (34), 19241 (42), 19242 (50), 19243 (58) | acq 0, race **Dwarf** (mask 4) | no SF | 10 min cd. Classic Era mask 5 = Human+Dwarf (S3) |
| Fear Ward | 6346 (20) | acq 0, race **all** (-1/-1) | no SF | 3 min cd. Classic Era mask 4 = Dwarf only (S3) |
| Chastise | 1277331 (20), 1277332 (30), 1277333 (40), 1277334 (50), 1277335 (60) | acq 0, race **Dwarf** | no SF | NEW: Holy damage + root, humanoids only, 2 min cd |
| Divine Grace | 1277370 (10), 1277371 (18), 1277372 (26), 1277374 (34), 1277376 (42), 1277377 (50), 1277378 (58) | acq 0, race **Human** | no SF | NEW: instant heal on an ally below a health %, not on self, removes Weakened Soul, 10 min cd. Not in Classic Era SLA (S3) |

### Discipline (SkillLine 613)

| Spell | Ranks: ID (level) | Learned | Shadowform | Note |
|---|---|---|---|---|
| Power Word: Fortitude | 1243 (1), 1244 (12), 1245 (24), 2791 (36), 10937 (48), 10938 (60) | acq 0 | SF ok | |
| Prayer of Fortitude | 21562 (48), 21564 (60) | acq 0 | SF ok | |
| Power Word: Shield | 17 (6), 592 (12), 600 (18), 3747 (24), 6065 (30), 6066 (36), 10898 (42), 10899 (48), 10900 (54), 10901 (60) | acq 0 | SF ok | 4 s cd |
| Inner Fire | 588 (12), 7128 (20), 602 (30), 1006 (40), 10951 (50), 10952 (60) | acq 0 | SF ok | |
| Shackle Undead | 9484 (20), 9485 (40), 10955 (60) | acq 0 | SF ok | |
| Mana Burn | 8129 (24), 8131 (32), 10874 (40), 10875 (48), 10876 (56) | acq 0 | SF ok | |
| Dispel Magic | 527 (18), 988 (36) | acq 0 | SF ok | |
| Divine Spirit | 14752 (30), 14818 (40), 14819 (50), 27841 (60) | acq 0 | SF ok | **not in tree 1114** |
| Prayer of Spirit | 27681 (60) | acq 0 | SF ok | |
| Levitate | 1706 (34) | acq 0 | SF ok | |
| Inner Focus | 14751 | **T** Disc row 3 | SF ok | 3 min cd, off the GCD (StartRecoveryCategory 0) |
| Penance | 402174 (30), 1240720 (40), 1240721 (50), 1316995 (60) | **T** Disc row 5 | free | damage or heal, 12 s cd; acq-3 helper rows 402284/402289 etc. |
| Power Infusion | 10060 (40) | **T** Disc row 7 | free | 3 min cd |
| Starshards | 10797 (10), 19296 (18), 19299 (26), 19302 (34), 19303 (42), 19304 (50), 19305 (58) | acq 0, race **Night Elf** (8) | SF ok | 30 s cd |
| Elune's Grace | 2651 (20) | acq 0, race **Night Elf** | SF ok | 5 min cd |
| Feedback | 13896 (20), 19271 (30), 19273 (40), 19274 (50), 19275 (60) | acq 0, race **Human** (1) | SF ok | 3 min cd |
| Contingency Plan | 1277462 (20), 1277634 (30), 1277638 (40), 1277639 (50), 1277640 (60) | acq 0, race **Gnome** (64) | (mask 32 only) | NEW: ward on an ally, shield + heal when they drop low, 10 min cd |
| Confounding Flash | 1277455 (10) | acq 0, race **Gnome** | no SF | NEW: AoE confuse, 2 min cd, off the GCD |

### Shadow Magic (SkillLine 78)

| Spell | Ranks: ID (level) | Learned | Shadowform | Note |
|---|---|---|---|---|
| Shadow Word: Pain | 589 (4), 594 (10), 970 (18), 992 (26), 2767 (34), 10892 (42), 10893 (50), 10894 (58) | acq 0 | SF ok | |
| Mind Blast | 8092 (10), 8102 (16), 8103 (22), 8104 (28), 8105 (34), 8106 (40), 10945 (46), 10946 (52), 10947 (58) | acq 0 | SF ok | 8 s cd |
| Fade | 586 (8), 9578 (20), 9579 (30), 9592 (40), 10941 (50), 10942 (60) | acq 0 | SF ok | 30 s cd |
| Psychic Scream | 8122 (14), 8124 (28), 10888 (42), 10890 (56) | acq 0 | SF ok | 30 s cd |
| Mind Soothe | 453 (20), 8192 (36), 10953 (52) | acq 0 | SF ok | |
| Mind Vision | 2096 (22), 10909 (44) | acq 0 | SF ok | |
| Mind Control | 605 (30), 10911 (44), 10912 (58) | acq 0 | SF ok | |
| Shadow Protection | 976 (30), 10957 (42), 10958 (56) | acq 0 | SF ok | |
| Prayer of Shadow Protection | 27683 (56) | acq 0 | SF ok | |
| Devouring Plague | 2944 (20), 19276 (28), 19277 (36), 19278 (44), 19279 (52), 19280 (60) | acq 0, race **all** | SF ok | 24 s cd. Classic Era mask 16 = Undead only (S3) |
| Shadow Word: Death | 1309595 (32), 1309633 (40), 1309635 (48), 1309636 (56) | acq 0, SLA ClassMask 0 | SF ok | NEW ranks (1.3M IDs), 18 s cd. 401955 = acq 3 version (note A). Talent Early Demise modifies it |
| Mind Flay | 15407 (20), 17311 (28), 17312 (36), 17313 (44), 17314 (52), 18807 (60) | **T** Shadow row 3 | SF ok | |
| Vampiric Embrace | 15286 (spell level 30) | **T** Shadow row 4 | free | 30 s cd. Row 4 = 15 points = level 25, spell says 30 (open question) |
| Silence | 15487 | **T** Shadow row 5 | SF ok | 45 s cd - the only priest interrupt |
| Shadowform | 15473 | **T** Shadow row 7 | - | the form itself (aura 36, form 28) |
| Touch of Weakness | 2652 (10), 19261 (20), 19262 (30), 19264 (40), 19265 (50), 19266 (60) | acq 0, race **Undead** (16) | SF ok | effect spells 2943/19249/... share the name |
| Hex of Weakness | 9035 (10), 19281 (20), 19282 (30), 19283 (40), 19284 (50), 19285 (60) | acq 0, race **Troll** (128) | SF ok | |
| Shadowguard | 18137 (20), 19308 (28), 19309 (36), 19310 (44), 19311 (52), 19312 (60) | acq 0, race **Troll** | SF ok | effect spells 28377-28382 share the name |
| Dark Sacrifice | 1277324 (20), 1277325 (30), 1277326 (40), 1277327 (50), 1277328 (60) | acq 0, race **Undead** | free | NEW: trade own health for mana over time, 10 min cd |

### Talent actives (TraitTree 1114) - earliest level by row rule

Row from PosY (2130 = row 1 ... 5730 = row 7), gate = TraitCond SpentAmountRequired 0/5/10/15/20/25/30 (GEMETEN, S1).
Talent points: TraitCurrencySource gives 1 point per level from **level 10** to 60 (51 = SourcedMax), plus five extra
rows at levels 5-9 named "Talented Rank 5 (Level 5)" ... "Talented Rank 1 (Level 9)", each tied to a TraitNodeEntryID
(137371-137374, 136852) (GEMETEN). What unlocks those five is unknown. Earliest level = 10 + 5 x (row - 1) without
them (AFGELEID; up to 5 levels earlier if the "Talented" points exist for a character).

| Talent | Tree, row | Earliest level (AFGELEID) | Spell's own level (S1) |
|---|---|---|---|
| Inner Focus | Disc 3 | 20 | - |
| Penance | Disc 5 | 30 | 30 |
| Power Infusion | Disc 7 | 40 | 40 |
| Holy Nova | Holy 3 | 20 | 20 |
| Prayer of Mending | Holy 7 | 40 | 40 |
| Mind Flay | Shadow 3 | 20 | 20 |
| Vampiric Embrace | Shadow 4 | 25 | **30** |
| Silence | Shadow 5 | 30 | - |
| Shadowform | Shadow 7 | 40 | - |

All other 44 nodes are passive (Attributes_0 bit 0x40, GEMETEN). New passive talents with high IDs (Forever): Power in
Light, Twin Disciplines, Holy Precision, Holy Binding, Litany of Light, Improved Mind Flay, Dark Inspiration, Devouring
Contagion, Early Demise; also in the tree: Soul Warding, Renewed Hope, Divine Aegis (SoD-era IDs). NOT in tree 1114:
Divine Spirit, Lightwell, Holy Fire, Improved Fortitude, Unbreakable Will, Force of Will, Shadow Affinity, Improved
Fade, Improved Vampiric Embrace (GEMETEN: absent from the tree dump; their SLA rows still exist). One odd node:
Holy Specialization appears twice (node 105865 at PosY 21300, Holy group only) - looks like a stray.

### Racials for the priest races

Which races can be a priest in Forever (GEMETEN, S2 CharBaseInfo ClassID=5): **Human (1), Dwarf (3), Night Elf (4),
Undead (5), Gnome (7), Troll (8)**. Gnome priest is new: row ID 919; Classic Era CharBaseInfo ClassID=5 has only
races 1, 3, 4, 5, 8 (S3). **Skyborne cannot be a priest** (GEMETEN): ChrRaces 96 = "Windshaper Skyborne"
(PlayableRaceBit 33); CharBaseInfo race 96 = classes 1, 3, 4, 7, 11 and race 95 = classes 1, 3, 4, 8, 11; no class 5.
No priest SLA row carries a Skyborne race bit either.

| Race | Active racials (S1, SL racial lines, acq 2) | Passive |
|---|---|---|
| Human | Perception (20600, 3 min), **Will to Survive** (1259718, NEW, removes stuns, 3 min) | Ruthless, The Human Spirit |
| Dwarf | **Stoneform** (20594, 3 min), Find Treasure (2481) | Artisan's Precision, Big Game Hunter (NEW) |
| Night Elf | **Shadowmeld** (20580), Elune's Light (1259799, NEW, 3 min) | Quickness, Wisp Spirit |
| Undead | **Will of the Forsaken** (7744, 2 min), Cannibalize (20577, 2 min) | Underwater Breathing, Touch of the Grave (priest version 1260201) |
| Troll | **Berserking** (20554, 3 min), Rapid Regeneration (1260270, NEW, 3 min) | Regeneration, Beast Slaying |
| Gnome | **Escape Artist** (20589, 2 min), Eureka! (priest version 1259823, NEW, 2 min) | Expansive Mind (20591), Engineering Specialization |

### The vanilla race-specific priest spells - what Forever does with them (Rob's question)

Each priest race now has exactly **two** own priest spells, one at level 10 and one at level 20, and two former
race spells became **every priest's** (GEMETEN race masks S1; Classic Era masks S3 where marked):

| Spell | Classic Era race | Forever race | Level |
|---|---|---|---|
| Fear Ward | Dwarf (mask 4, S3) | **all priests** | 20 |
| Devouring Plague | Undead (mask 16, S3) | **all priests** | 20 |
| Desperate Prayer | Human + Dwarf (mask 5, S3) | **Dwarf only** | 10 |
| Feedback | (Human in vanilla - AFGELEID, not checked tonight) | Human | 20 |
| Divine Grace (NEW) | not in Classic Era (S3) | Human | 10 |
| Chastise (NEW) | (not checked; new ID 1277331) | Dwarf | 20 |
| Starshards | (Night Elf - AFGELEID) | Night Elf | 10 |
| Elune's Grace | (Night Elf - AFGELEID) | Night Elf | 20 |
| Touch of Weakness | (Undead - AFGELEID) | Undead | 10 |
| Dark Sacrifice (NEW) | (not checked; new ID 1277324) | Undead | 20 |
| Hex of Weakness | (Troll - AFGELEID) | Troll | 10 |
| Shadowguard | (Troll - AFGELEID) | Troll | 20 |
| Confounding Flash (NEW) | (not checked; new ID 1277455) | Gnome | 10 |
| Contingency Plan (NEW) | (not checked; new ID 1277462) | Gnome | 20 |

Extra find: hidden spells **"Priest Racial Ability"** (459695, SL 2853 Runes, acq 2) and **"Priest Racial Ability RAQ"**
(1219274, acq 3). Their text (S1): learn a priest spell from another race to fill this slot. If Forever lets a priest
learn another race's spells, the race lists below must be rethought (open question 6).

### Note A - spells in the data that I left out

The priest skill lines also hold Season of Discovery rune spells (SkillLine 2851 "Engraving" rows, and spells with
acq 3 and level 0): Circle of Healing, Dispersion, Eye of the Void, Homunculi, Void Plague, Mind Sear, Shadow Word:
Death 401955, Pain Suppression, Power Word: Barrier, Shadowfiend 401977, Vampiric Touch, Mind Spike, Renew
425268-425277. No level, mostly acq 3. AFGELEID: not learnable in Forever. If one shows up in a Forever spellbook, the
"not in MH's list" line of the key block window will name it.

---

## States + conditions

**Answer: the priest has NO bar-paging state. Shadowform does not page the bar. Proposal: no state at all.**

- **GEMETEN (S1):** SpellShapeshiftForm 28 "Shadowform" has **BonusActionBar 0** (Flags 201). Spirit of Redemption
  (form 32) also 0. For comparison in the same table: Cat 1, Bear 3, Dire Bear 3, Battle Stance 1, Defensive 2,
  Berserker 3, Stealth 1, and Moonkin Form **0**.
- **GEMETEN (S4):** Blizzard's Forever `ActionBarController_UpdateAll` pages the main bar only when
  `C_ActionBar.HasBonusActionBar()` (and only on page 1). No class-specific code. `StanceBar.lua` is generic
  (shows when `GetNumShapeshiftForms() > 0`).
- **GEMETEN (S5):** EllesmereUI's paging comment says a form pages on Forever only where the client gives it a bonus
  bar, and it lists **no PRIEST** paging state (only DRUID, ROGUE, WARRIOR, EVOKER; on Forever it adds Berserker and
  removes Moonkin).
- **GEMETEN (S1):** Shadowform 15473 = aura 36 (shapeshift) with MiscValue 28, so it IS a shapeshift form and should
  sit on the stance bar as the priest's only form (AFGELEID). Forever's tooltip: no **healing** spells in Shadowform.
  Classic Era's tooltip said no **Holy** spells (S3). The masks agree: heals, Holy Nova, Fear Ward, Desperate Prayer,
  Divine Grace, Chastise, Confounding Flash exclude form 28; Smite and Holy Fire have no exclusion in Forever, while
  Classic Era's Smite excluded form 28 (S3). So in Forever Smite and Holy Fire should work in Shadowform (AFGELEID -
  test in game).

Why no state: the engine's states are only needed when one key must cast a different spell in a form. In Shadowform
the heal keys simply cannot be used; there is no Shadow spell that does their job. A key that fails with an error in
Shadowform is still "the same job" (rule 1).

If Rob wants a state anyway, the condition is **`[form:1]`** (same as `[stance:1]`), AFGELEID: Shadowform is form index 1
because it is the priest's only stance-bar spell. Not tested. Two possible uses (both judgment calls, not in the draft):
(a) key 1 = Mind Flay only in Shadowform; (b) heal keys drop Shadowform first (`[form:1] Shadowform; Flash Heal`), which
costs a press and the form's mana, so I do not recommend it.

Side note for the Druid table (not my class, GEMETEN S1 + S5): Moonkin Form has BonusActionBar 0 on Forever, so the
comment "4 = Moonkin" in `ForeverBlock_Druid.lua` is not backed by data. The table itself uses only `[bonusbar:1/2]` and
`[bonusbar:3]`, so nothing breaks.

---

## Proposal per key

Fixed tasks from `KeyBlock.lua` lines 22-59. "base" only, because there are no states. Level = when the key fills
(earliest rank or talent row). Lists: first known spell wins. Judgment calls are marked **(AF)** = AFGELEID.

| Key | Task | base | Level |
|---|---|---|---|
| 1 | main | Mind Flay, else Smite **(AF)** | 1 (Smite); Mind Flay talent 20 |
| 2 | rotation | Shadow Word: Pain | 4 |
| 3 | rotation | Mind Blast | 10 |
| 4 | spender | Holy Fire **(AF)** | 20 |
| 5 | rotation | Shoot (wand) **(AF)** | 1 (needs a wand) |
| Shift-4 | 2nd spender | Shadow Word: Death **(AF: "finisher")** | 32 |
| Shift-1 | AoE | Holy Nova | talent 20 |
| Shift-2 | AoE | Prayer of Healing | 30 |
| Shift-3 | cd3 | Devouring Plague **(AF: 24 s cd)** | 20 |
| Q | big cooldown | Power Infusion | talent 40 |
| F1 | cd2 | Inner Focus (like Innervate) | talent 20 |
| Shift-F1 | cd2b | Penance (like Swiftmend) | talent 30 |
| F3 | cd4 | Resurrection (like Revive) | 10 |
| E | interrupt | Silence | talent 30 |
| R | movement | Levitate | 34 |
| Shift-R | movement 2 | race spell B: Starshards / Chastise / Divine Grace / Hex of Weakness / Dark Sacrifice / Confounding Flash **(AF)** | 10 or 20 |
| F | taunt/help | Fade (like Cower: threat drop) | 8 |
| Z | small defensive | Power Word: Shield | 6 |
| X | defensive 2 | race spell A: Desperate Prayer / Elune's Grace / Feedback / Shadowguard / Touch of Weakness / Contingency Plan **(AF)** | 10 or 20 |
| C | big defensive / big heal | Greater Heal, else Heal, else Lesser Heal | 1 / 16 / 40 |
| Shift-Z | defensive row 2 | Inner Fire (like Thorns) | 12 |
| Shift-X | defensive row 2 | Prayer of Fortitude, else Power Word: Fortitude (like Gift/Mark) | 1 / 48 |
| Shift-C | defensive row 2 | Abolish Disease, else Cure Disease (like Abolish/Cure Poison) | 14 / 32 |
| V | CC | Psychic Scream | 14 |
| Shift-Q | CC | Shackle Undead (like Hibernate) | 20 |
| Shift-F | CC | Mind Control | 30 |
| Shift-V | dispel | Dispel Magic (like Remove Curse) | 18 |
| F2 | quick heal | Flash Heal | 20 |
| F4 | heal over time | Renew | 8 |
| Shift-E | racial | Will of the Forsaken / Stoneform / Shadowmeld / Escape Artist / Berserking / Will to Survive **(AF)** | 1 |
| Ctrl-1 | form | Shadowform | talent 40 |
| Ctrl-2 | (overflow) | Prayer of Mending **(AF)** | talent 40 |
| Ctrl-3 | (overflow) | Vampiric Embrace **(AF)** | talent 25/30 |
| T, Shift-T, G | fixed | potion, healthstone, trinket | - |

Why Ctrl-2/Ctrl-3 may hold non-forms: the priest has one form, and `KeyBlock.lua` line 115 already puts CTRL-1, CTRL-2,
CTRL-3 first in its OVERFLOW order (GEMETEN, S6). That they suit PoM and VE is AFGELEID.

Why the two race keys: every priest race has exactly one level-10 and one level-20 own spell (GEMETEN). One fixed key
per "race spell" keeps 12 spells on 2 keys instead of 12 keys that are empty for 5 of 6 races. X gets the self-defence
group (Desperate Prayer, Elune's Grace, Feedback, Shadowguard, Touch of Weakness, Contingency Plan); Shift-R gets the
rest. Shift-R's task is "movement 2", but the priest has no second movement spell, and KeyBlock's own anchors already
allow utility on Shift-R (`utility_secondary = { "F", "SHIFT-R" }`, GEMETEN S6). The grouping itself is AFGELEID.

**Block D** (the player's own bar, not filled by MH): Fear Ward, Divine Spirit, Prayer of Spirit, Shadow Protection,
Prayer of Shadow Protection, Mind Soothe, Mind Vision, Mana Burn, Lightwell (if it can be learned at all), and the
second racial: Perception / Find Treasure / Elune's Light / Cannibalize / Rapid Regeneration / Eureka!.
For one character that is at most 10 known names on 12 Alt keys (AFGELEID count).

What a level-1 priest sees: 1 Smite, 5 Shoot, C Lesser Heal, Shift-X Power Word: Fortitude (after the trainer), Shift-E
racial. Everything else stays an empty place until learned (rule 3).

---

## Draft Lua table (for review - NOT in the repo)

Exact names checked against SpellName.csv (GEMETEN: all 68 names below exist; script `cur.py`). Format as in
`ForeverBlock.lua`; with no states the engine never adds a guard.

```lua
ns.FOREVER_BLOCK_CLASSES.PRIEST = {
	-- No states: Shadowform (form 28) has BonusActionBar 0 on Forever and does not page bar 1.
	-- If wanted later: { name = "shadow", cond = "[form:1]" } (untested).
	states = {},
	keys = {
		["1"] = { base = { "Mind Flay", "Smite" } },
		["2"] = { base = "Shadow Word: Pain" },
		["3"] = { base = "Mind Blast" },
		["4"] = { base = "Holy Fire" },
		["SHIFT-4"] = { base = "Shadow Word: Death" },
		["5"] = { base = "Shoot" },
		["SHIFT-1"] = { base = "Holy Nova" },
		["SHIFT-2"] = { base = "Prayer of Healing" },
		["SHIFT-3"] = { base = "Devouring Plague" },
		["Q"] = { base = "Power Infusion" },
		["F1"] = { base = "Inner Focus" },
		["SHIFT-F1"] = { base = "Penance" },
		["F3"] = { base = "Resurrection" },
		["E"] = { base = "Silence" },
		["R"] = { base = "Levitate" },
		["SHIFT-R"] = { base = { "Starshards", "Chastise", "Divine Grace", "Hex of Weakness", "Dark Sacrifice", "Confounding Flash" } },
		["F"] = { base = "Fade" },
		["Z"] = { base = "Power Word: Shield" },
		["X"] = { base = { "Desperate Prayer", "Elune's Grace", "Feedback", "Shadowguard", "Touch of Weakness", "Contingency Plan" } },
		["C"] = { base = { "Greater Heal", "Heal", "Lesser Heal" } },
		["SHIFT-Z"] = { base = "Inner Fire" },
		["SHIFT-X"] = { base = { "Prayer of Fortitude", "Power Word: Fortitude" } },
		["SHIFT-C"] = { base = { "Abolish Disease", "Cure Disease" } },
		["V"] = { base = "Psychic Scream" },
		["SHIFT-Q"] = { base = "Shackle Undead" },
		["SHIFT-F"] = { base = "Mind Control" },
		["SHIFT-V"] = { base = "Dispel Magic" },
		["F2"] = { base = "Flash Heal" },
		["F4"] = { base = "Renew" },
		["SHIFT-E"] = { all = { "Will of the Forsaken", "Stoneform", "Shadowmeld", "Escape Artist", "Berserking", "Will to Survive" } },
		["CTRL-1"] = { base = "Shadowform" },
		["CTRL-2"] = { base = "Prayer of Mending" },
		["CTRL-3"] = { base = "Vampiric Embrace" },
	},
	toBlockD = {
		"Fear Ward", "Divine Spirit", "Prayer of Spirit", "Shadow Protection", "Prayer of Shadow Protection",
		"Mind Soothe", "Mind Vision", "Mana Burn", "Lightwell",
		"Perception", "Find Treasure", "Elune's Light", "Cannibalize", "Rapid Regeneration", "Eureka!",
	},
}
```

Engine notes (GEMETEN from `ForeverBlock.lua`): `toBlockD` must stay a flat list of names (line 221 calls `Known(name)`
per entry; a nested list would silently show nothing). `states = {}` is safe: the state loop does nothing and
`baseGuard` is only read when a guarding state matched.

---

## Open questions for Rob

1. **Key 1:** Mind Flay takes over from Smite once learned (list), so a Shadow priest loses Smite from the block. OK, or
   keep Smite on 1 and give Mind Flay its own key (then something else must go to block D)?
2. **Two "race spell" keys (X and Shift-R):** OK to put each race's own priest spells on two shared keys? Shift-R is
   officially "movement 2", but the priest has none.
3. **Shoot on 5 and Holy Fire on 4:** wand is the classic leveling tool. Swap 4 and Shift-3 (Devouring Plague on 4) if
   you prefer the DoT on 4 like the Druid's Insect Swarm.
4. **Shadowform:** no state. Fine that heal keys just give an error in Shadowform? (Option: `[form:1]` state.)
5. **Overflow on Ctrl-2/Ctrl-3** for Prayer of Mending and Vampiric Embrace - OK, or would you rather have them elsewhere?
6. **"Priest Racial Ability" (459695):** can a Forever priest learn another race's priest spells? If yes, the X and
   Shift-R lists would only show the first one known.
7. **Trainer check at 30-40:** are Divine Spirit, Lightwell and Shadow Word: Death (32) taught by the trainer? Only the
   trainer window can tell (none of the three is in the talent tree).
8. **Vampiric Embrace:** talent row 4 (level 25) but spell level 30 - when can you actually take it?
9. **Talent points at 5-9:** five "Talented Rank" point sources at levels 5-9 exist in the data. Did your Druid get a
   point before level 10?
10. **Smite in Shadowform:** the data says it is allowed now (it was not in Classic Era). One test cast at 40 settles it.

---

## What is GEMETEN vs AFGELEID

**GEMETEN**
- Every spell ID, rank, level, race mask, cooldown, Shadowform mask and AcquireMethod in the tables (S1, build 70790).
- Level-1 automatic spells: Smite R1, Lesser Heal R1, Shoot (S1).
- Talent tree 1114: which nodes are active, row positions and point gates; talent points from level 10 + five
  "Talented Rank" sources at 5-9 (S1).
- Priest races = Human, Dwarf, Night Elf, Undead, Gnome, Troll; Skyborne (races 95/96) cannot be a priest (S2).
- Classic Era vs Forever: Fear Ward Dwarf -> all, Devouring Plague Undead -> all, Desperate Prayer Human+Dwarf -> Dwarf,
  Divine Grace absent in Classic Era, Gnome priest new, Shadowform text "Holy" -> "healing", Smite no longer excluded
  in Shadowform (S3 vs S1).
- Shadowform BonusActionBar 0; Blizzard's Forever bar code pages only on a bonus bar; EllesmereUI has no priest paging
  (S1, S4, S5). S4 was read through a summarising fetch tool, not byte-for-byte.
- All 68 names in the draft exist in SpellName.csv.

**AFGELEID**
- That acq 0 means "trainer" for the normal ranks (DB2 cannot tell trainer, book or quest).
- Earliest talent levels (row rule), and that the 5-9 sources need something the player may not have.
- That `[form:1]` = Shadowform, and that Smite / Holy Fire really work in Shadowform in game.
- That the SoD rune spells (note A) are not in Forever.
- That Divine Spirit, Lightwell and Shadow Word: Death are learnable (not in the tree; SW:D is hinted at by the Early
  Demise talent).
- Classic Era race of Feedback, Starshards, Elune's Grace, Touch of Weakness, Hex of Weakness, Shadowguard (from
  memory, not checked tonight).
- Every key choice marked (AF) in the proposal, including both race keys and the overflow use of Ctrl-2/Ctrl-3.
- Not measured at all: what the trainer offers, what the in-game spellbook tabs look like, the macros working in
  Rob's client.
