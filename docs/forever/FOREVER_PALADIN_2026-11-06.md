# WoW Forever — Paladin: spells tot 60 + VOORSTEL voor het toetsenblok

> 🌙 **Nacht 5→6 nov 2026, onderzoek door mh-research (één helper per class). NIET goedgekeurd door Rob, NIET in de
> addon.** Alleen een goedgekeurde tabel komt in `Modules/ForeverBlock_<Class>.lua`.
>
> **Zelf nagekeken in de nacht (GEMETEN):**
> - beginspells staan in Blizzards data met AcquireMethod 2: Seal of Righteousness 20154, Holy Light 635 (alleen Human/Dwarf) (wago wowf 1.60.1.70790, SkillLineAbility);
> - de concepttabel hieronder laadt in de échte motor (`Modules/ForeverBlock.lua`, offline met nagebootste spells):
>   elke spellnaam bestaat in SpellName, elke toets is een blok-plek, geen spell op twee toetsen;
> - stance/vorm-nummers: SpellShapeshiftForm.BonusActionBar (Cat 1, Bear 3, Stealth 1, Battle 1, Defensive 2,
>   Berserker 3, Moonkin/Shadowform/Ghost Wolf 0).
> - Niet in het spel getest. Elke toetskeuze is een voorstel (AFGELEID).
> - Voor alle classes geldt (helpers, GEMETEN in de data): een account-perk 'Talented' geeft al talentpunten vanaf
>   level 5-9, dus talent-levels hieronder kunnen tot 5 levels vroeger zijn.

**Aandachtspunten van de nachtcontrole:**
- Blok D krijgt op level 60 15 spells voor 12 plekken: Rob kiest wat eraf mag.

---

# WoW Forever Paladin: spells 1-60, states, and a key-block proposal (client 1.60.1.70790)

Researched night of 5-6 Nov 2026. Read only: nothing in the repo was changed. I did not read `docs/` (my agent rule),
so the Druid example I followed is the approved code table `Modules/ForeverBlock_Druid.lua`, the engine header of
`Modules/ForeverBlock.lua`, `Modules/KeyBlock.lua` (tasks) and the scratchpad copy `forever_druid_spells.md`.

## Sources
- **DB2** = the full wago CSVs for build **1.60.1.70790** in `scratchpad\wago_wowf\` (fetched 5 Nov 2026 23:25):
  SkillLineAbility (Paladin lines 594 Holy, 267 Protection, 184 Retribution; racial lines 754, 101, 220, 2980; Mounts 777),
  SpellName, Spell, SpellLevels, SpellMisc (passive bit 0x40), SpellShapeshift, SpellShapeshiftForm, SpellEffect,
  SpellCategories, SpellCooldowns, SkillRaceClassInfo, ChrClasses, ChrSpecialization, Trait* (tree 1100).
- **DB2 extra**, read live from wago.tools on 6 Nov 2026 (curl/urllib to memory, no file saved), same build 70790:
  `CharBaseInfo` (race x class), `ChrRaces`, `SkillLineXTraitTree` (SkillLine 184 -> TraitTree 1100), `SpellDuration`,
  `SpellRange`, `SpellCastTimes`.
- **DB2 compare**: SkillLineAbility + SpellName + SpellLevels of Forever beta build **1.60.1.70707** and of Classic Era
  **1.15.9.70576**, read live from wago.tools 6 Nov 2026.
- **Zygor** = `E:\World of Warcraft\_forever_\Interface\AddOns\ZygorGuidesViewerForever\Data-Forever\Skill_Training.lua`
  lines 376-591 (PALADIN trainer list with costs). The Druid research found this file matches build 70707 or older; I see
  the same here (it still lists Blessing of Salvation/Light, which 70790 removed). Used for "trainer" only.
- **Blizzard UI source**, github.com/Gethe/wow-ui-source branch `forever`, commit `eac30af5` "1.60.1 (70790)"
  (4 Nov 2026 18:16 UTC): `Interface/AddOns/Blizzard_ActionBarController/ActionBarController.lua`
  (`ActionBarController_UpdateAll`), `Blizzard_ActionBar/Shared/StanceBar.lua`.
- **EllesmereUI** paging file `E:\World of Warcraft\_forever_\Interface\AddOns\EllesmereUIActionBars\EUI_ActionBars_Paging.lua`
  lines 105-131 and 197-209.
- **warcraft.wiki.gg** "Rediscovering the Light" (last edited 11 Oct 2026): Forever-only quest, level 2, Undead Paladin,
  giver Aramis Hammerhand (Tirisfal Glades), reward Holy Light, learned on accept.
- **warcrafttavern.com/forever/guides/undead-paladin/** (no page date shown; it cites a blue post updated 5 Nov):
  Undead are the only Horde Paladins; class hub Bandarion Keep (Whispering Wood, Tirisfal); unique warhorse at 40,
  epic charger chain at 60.
- Web search results only (pages answered 403, I did not read them): Icy Veins "All New Race and Class Combos ...
  (Official)", Massively OP 29 Sep 2026 "promotes the undead paladin and other new class combos". They agree with DB2.
- **Wowhead Forever** answered HTTP 403 to a plain fetch; not used. No human-verification page was touched.

## Can both factions be Paladin? YES (GEMETEN)
- DB2 `CharBaseInfo` 70790 has Paladin (ClassID 2) for exactly three races: row 2 Human (RaceID 1), row 14 Dwarf (3) and
  **row 877 Undead (RaceID 5, `ChrRaces.Alliance` = 1 = Horde)**. Same table: the five other new combos (Human Hunter 887,
  Dwarf Shaman 905, Gnome Priest 919, Troll Warlock 920, Orc Mage 921) and the Skyborne races 95 "High Order" (Alliance)
  and 96 "Windshaper" (Horde).
- **Skyborne cannot be Paladin**: race 95 has classes 1, 3, 4, 8, 11 and race 96 has 1, 3, 4, 7, 11 (no 2). GEMETEN.
- The class skill lines themselves are open to all races (`SkillRaceClassInfo` 61/63/544: RaceMask -1), so the gate is
  CharBaseInfo. Undead-only DB2 details: Holy Light R1 is NOT a starting spell for Undead (SLA 59546, AcquireMethod 0,
  race mask Undead only; taught by spell 1240334 through the level-2 quest above), Sense Undead IS a starting spell for the
  Horde-race mask (SLA 53945, AcquireMethod 2), mounts `Summon Forsaken Charger` 1296534 and a second `Summon Warhorse`
  1279399 exist next to the Alliance ones (13819, 23214, race mask Human+Dwarf).

## Positive control: PASSES (GEMETEN, DB2 70790)
- Level-1 starting spells (AcquireMethod 2) on the Paladin lines: **Seal of Righteousness R1 20154** (all races),
  **Holy Light R1 635** (race mask Human+Dwarf), **Sense Undead 5502** (Horde-race mask = Undead Paladin).
- Devotion Aura R1 465 is level 1 at the trainer (Zygor level 1, 10c).
- The pattern itself found known rows: ChrSpecialization 1486 = "Paladin", ClassID 2 (one spec per class); the Druid's
  README control SLA 6261 (SkillLine 573, Healing Touch 5185, AcquireMethod 2) is in the same file (checked this run).
- Offline engine test (see "Draft Lua table"): the real `ForeverBlock.lua` with my draft table builds a macro for all 33
  keys at level 60, and `ForeverBlockUnlisted` reports only the invented "Mystery Spell" I planted.

## Talent tree (GEMETEN: TraitTree 1100, linked to SkillLine 184 by SkillLineXTraitTree 160)
51 nodes in three sections (Holy 594 / Protection 267 / Retribution 184, TraitNodeGroupDisplayInfo 10-12). Rows are gated
by points spent **in that section** (TraitCond 5/10/15/20/25/30 on the row groups; the counted group is the section's
rows above). TraitCurrency 3820 SourcedMax 51; TraitCurrencySource gives 1 point at every level 10-60 (GEMETEN), so the
earliest level of a talent = 10 + points needed (AFGELEID). There are also five odd sources "Talented Rank 1-5
(Level 9..5)" in TraitCurrencySource; what they are is unknown (AFGELEID: could make talents up to 5 levels earlier).
Active talent spells (passive bit off): Divine Favor (Holy r3), Oath of Light (Holy r4), Holy Shock R1 1311606 (Holy r5),
Light's Vigil R1 (Holy r7, needs Holy Shock: TraitEdge 105323->105320), Templar's Bulwark (Prot r3), Swift Judgement
(Prot r4, needs Templar's Bulwark: edge 105625->110878), Holy Shield R1 (Prot r5), Seal of Command R1 (Ret r3),
Repentance (Ret r5). Everything else in the tree is passive.

## Spell list (active spells, levels 1-60)
Legend: Level = SpellLevels.SpellLevel in DB2 70790; `*` = talent, earliest level from the row rule (AFGELEID).
"Zygor" = present in Zygor's Forever trainer list with that level and cost. Paladin has no forms, so the form column of
the Druid list is replaced by "Needs / note" (target or other limits, from the DB2 tooltip text or cooldown tables).
Not listed: 54 passive rows, 80 rows with AcquireMethod 3 (Judgement effects like Judgement of Righteousness, Season of
Discovery leftovers like Crusader Strike, Divine Storm, Avenging Wrath, Rebuke, Hand of Reckoning, Beacon of Light), and
110 rows whose spell has no SpellName entry in 70790 (removed from the client). Spell 67 "Vindication" (SLA 13387) is
left out too: it has no SpellLevels row and is the debuff of the passive Vindication talent (AFGELEID).

| Spell | Rank | ID | Level | How learned | Tab | Needs / note | Measured? |
|---|---|---|---|---|---|---|---|
| Sense Undead | - | 5502 | 0 (SpellLevels) | starting spell for the Horde-race mask = Undead (AcquireMethod 2); Human/Dwarf: AcquireMethod 0, source unknown | Holy | tracking | GEMETEN (DB2) |
| Devotion Aura | Rank 1 | 465 | 1 | trainer (Zygor: level 1, 10c) | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Light | Rank 1 | 635 | 1 | starting spell (AcquireMethod 2; Human/Dwarf); Undead: quest Rediscovering the Light (level 2), teach spell 1240334 | Holy | - | GEMETEN (DB2) |
| Seal of Righteousness | Rank 1 | 20154 | 1 | starting spell (AcquireMethod 2; all) | Holy | - | GEMETEN (DB2) |
| Seal of Righteousness | Rank 1 | 21084 | 1 | replaces 20154 (SupercedesSpell); taught by spell 10321, which is named Judgement (GEMETEN); when that fires is AFGELEID | Holy | - | GEMETEN (DB2) |
| Blessing of Might | Rank 1 | 19740 | 4 | trainer (Zygor: level 4, 100c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Judgement | - | 20271 | 4 | trainer (Zygor: level 4, 100c) | Retribution | does not consume the Seal | GEMETEN (DB2) + Zygor |
| Divine Protection | Rank 1 | 498 | 6 | trainer (Zygor: level 6, 100c) | Protection | Forbearance; shares cooldown category 37 with Divine Shield | GEMETEN (DB2) + Zygor |
| Holy Light | Rank 2 | 639 | 6 | trainer (Zygor: level 6, 100c) | Holy | - | GEMETEN (DB2) + Zygor |
| Holy Strike | Rank 1 | 679 | 6 | trainer (Zygor: level 6, 100c) | Retribution | melee; cooldown category 2404 | GEMETEN (DB2) + Zygor |
| Seal of the Crusader | Rank 1 | 21082 | 6 | trainer (Zygor: level 6, 100c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Hammer of Justice | Rank 1 | 853 | 8 | trainer (Zygor: level 8, 100c) | Protection | - | GEMETEN (DB2) + Zygor |
| Purify | - | 1152 | 8 | trainer (Zygor: level 8, 100c) | Holy | - | GEMETEN (DB2) + Zygor |
| Blessing of Protection | Rank 1 | 1022 | 10 | trainer (Zygor: level 10, 300c) | Protection | Forbearance | GEMETEN (DB2) + Zygor |
| Devotion Aura | Rank 2 | 10290 | 10 | trainer (Zygor: level 10, 300c) | Protection | - | GEMETEN (DB2) + Zygor |
| Lay on Hands | Rank 1 | 633 | 10 | trainer (Zygor: level 10, 300c) | Holy | - | GEMETEN (DB2) + Zygor |
| Righteous Fury | - | 25780 | 10 | trainer (Zygor: level 16, 3000c) - CONFLICT: DB2 says 10 | Protection | - | GEMETEN (DB2) + Zygor |
| Seal of Fury | Rank 1 | 1311649 | 10 | trainer (Zygor: level 10, 300c) | Protection | absorb part needs a shield; its Judgement taunts | GEMETEN (DB2) + Zygor |
| Seal of Righteousness | Rank 2 | 20287 | 10 | trainer (Zygor: level 10, 300c) | Holy | - | GEMETEN (DB2) + Zygor |
| Blessing of Might | Rank 2 | 19834 | 12 | trainer (Zygor: level 12, 1000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Holy Strike | Rank 2 | 678 | 12 | trainer (Zygor: level 12, 1000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Redemption | Rank 1 | 7328 | 12 | quest (teach spell 7329; not at Zygor's trainer; AFGELEID which quest) | Holy | not in combat | GEMETEN (DB2) |
| Seal of the Crusader | Rank 2 | 20162 | 12 | trainer (Zygor: level 12, 1000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Blessing of Wisdom | Rank 1 | 19742 | 14 | trainer (Zygor: level 14, 2000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Holy Light | Rank 3 | 647 | 14 | trainer (Zygor: level 14, 2000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Retribution Aura | Rank 1 | 7294 | 16 | trainer (Zygor: level 16, 3000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Blessing of Freedom | - | 1044 | 18 | trainer (Zygor: level 18, 3500c) | Protection | - | GEMETEN (DB2) + Zygor |
| Divine Protection | Rank 2 | 5573 | 18 | trainer (Zygor: level 18, 3500c) | Protection | - | GEMETEN (DB2) + Zygor |
| Seal of Fury | Rank 2 | 1311656 | 18 | trainer (Zygor: level 18, 3500c) | Protection | - | GEMETEN (DB2) + Zygor |
| Seal of Righteousness | Rank 3 | 20288 | 18 | trainer (Zygor: level 18, 3500c) | Holy | - | GEMETEN (DB2) + Zygor |
| Blessing of Kings | - | 20217 | 20 | trainer (Zygor: level 20, 4000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Consecration | Rank 1 | 26573 | 20 | trainer (Zygor: level 20, 4000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Devotion Aura | Rank 3 | 643 | 20 | trainer (Zygor: level 20, 4000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Divine Favor | - | 20216 | 20* | TALENT (Holy section, row 3, 10 points in that section) | Holy | - | GEMETEN (DB2 tree 1100); level AFGELEID |
| Exorcism | Rank 1 | 879 | 20 | trainer (Zygor: level 20, 4000c) | Holy | Undead or Demon target only | GEMETEN (DB2) + Zygor |
| Flash of Light | Rank 1 | 19750 | 20 | trainer (Zygor: level 20, 4000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Holy Strike | Rank 3 | 1866 | 20 | trainer (Zygor: level 20, 4000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Seal of Command | Rank 1 | 20375 | 20* | TALENT (Retribution section, row 3, 10 points in that section) | Retribution | - | GEMETEN (DB2 tree 1100); level AFGELEID |
| Templar's Bulwark | - | 1311015 | 20* | TALENT (Protection section, row 3, 10 points in that section) | Protection | Forbearance | GEMETEN (DB2 tree 1100); level AFGELEID |
| Voice of Truth | - | 1310897 | 20 | UNKNOWN: not in Zygor's trainer list, no teach spell found | Holy | - | GEMETEN (DB2) |
| Blessing of Might | Rank 3 | 19835 | 22 | trainer (Zygor: level 22, 4000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Concentration Aura | - | 19746 | 22 | trainer (Zygor: level 22, 4000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Light | Rank 4 | 1026 | 22 | trainer (Zygor: level 22, 4000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of Justice | - | 20164 | 22 | trainer (Zygor: level 22, 4000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Seal of the Crusader | Rank 3 | 20305 | 22 | trainer (Zygor: level 22, 4000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Blessing of Protection | Rank 2 | 5599 | 24 | trainer (Zygor: level 24, 5000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Blessing of Wisdom | Rank 2 | 19850 | 24 | trainer (Zygor: level 24, 5000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Hammer of Justice | Rank 2 | 5588 | 24 | trainer (Zygor: level 24, 5000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Redemption | Rank 2 | 10322 | 24 | trainer (Zygor: level 24, 5000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Turn Undead | Rank 1 | 2878 | 24 | trainer (Zygor: level 24, 5000c) | Holy | Undead target only | GEMETEN (DB2) + Zygor |
| Oath of Light | - | 1328548 | 25* | TALENT (Holy section, row 4, 15 points in that section) | Holy | - | GEMETEN (DB2 tree 1100); level AFGELEID |
| Swift Judgement | - | 1310994 | 25* | TALENT (Protection section, row 4, 15 points in that section) | Protection | needs Templar's Bulwark (talent edge) | GEMETEN (DB2 tree 1100); level AFGELEID |
| Flash of Light | Rank 2 | 19939 | 26 | trainer (Zygor: level 26, 6000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Retribution Aura | Rank 2 | 10298 | 26 | trainer (Zygor: level 26, 6000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Seal of Fury | Rank 3 | 20163 | 26 | trainer (Zygor: level 25, 6000c) - CONFLICT: DB2 says 26 | Protection | - | GEMETEN (DB2) + Zygor |
| Seal of Righteousness | Rank 4 | 20289 | 26 | trainer (Zygor: level 26, 6000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Exorcism | Rank 2 | 5614 | 28 | trainer (Zygor: level 28, 9000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Holy Strike | Rank 4 | 680 | 28 | trainer (Zygor: level 28, 9000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Shadow Resistance Aura | Rank 1 | 19876 | 28 | trainer (Zygor: level 28, 9000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Consecration | Rank 2 | 20116 | 30 | trainer (Zygor: level 30, 11000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Devotion Aura | Rank 4 | 10291 | 30 | trainer (Zygor: level 30, 11000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Divine Intervention | - | 19752 | 30 | trainer (Zygor: level 30, 11000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Light | Rank 5 | 1042 | 30 | trainer (Zygor: level 30, 11000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Holy Shield | Rank 1 | 20925 | 30* | TALENT (Protection section, row 5, 20 points in that section) | Protection | - | GEMETEN (DB2 tree 1100); level AFGELEID |
| Holy Shock | Rank 1 | 1311606 | 30* | TALENT (Holy section, row 5, 20 points in that section) | Holy | damage or heal | GEMETEN (DB2 tree 1100); level AFGELEID |
| Lay on Hands | Rank 2 | 2800 | 30 | trainer (Zygor: level 30, 11000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Repentance | - | 20066 | 30* | TALENT (Retribution section, row 5, 20 points in that section) | Retribution | Humanoid only | GEMETEN (DB2 tree 1100); level AFGELEID |
| Seal of Command | Rank 2 | 20915 | 30 | trainer (Zygor: level 30, 550c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Seal of Light | Rank 1 | 20165 | 30 | trainer (Zygor: level 30, 11000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Blessing of Might | Rank 4 | 19836 | 32 | trainer (Zygor: level 32, 12000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Frost Resistance Aura | Rank 1 | 19888 | 32 | trainer (Zygor: level 32, 12000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Seal of the Crusader | Rank 4 | 20306 | 32 | trainer (Zygor: level 32, 12000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Blessing of Wisdom | Rank 3 | 19852 | 34 | trainer (Zygor: level 34, 13000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Divine Shield | Rank 1 | 642 | 34 | trainer (Zygor: level 34, 13000c) | Protection | Forbearance; shares cooldown category 37 with Divine Protection | GEMETEN (DB2) + Zygor |
| Flash of Light | Rank 3 | 19940 | 34 | trainer (Zygor: level 34, 13000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of Fury | Rank 4 | 20419 | 34 | trainer (Zygor: level 34, 13000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Seal of Righteousness | Rank 5 | 20290 | 34 | trainer (Zygor: level 34, 13000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Exorcism | Rank 3 | 5615 | 36 | trainer (Zygor: level 36, 14000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Fire Resistance Aura | Rank 1 | 19891 | 36 | trainer (Zygor: level 36, 14000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Strike | Rank 5 | 2495 | 36 | trainer (Zygor: level 36, 14000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Redemption | Rank 3 | 10324 | 36 | trainer (Zygor: level 36, 14000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Retribution Aura | Rank 3 | 10299 | 36 | trainer (Zygor: level 36, 14000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Blessing of Protection | Rank 3 | 10278 | 38 | trainer (Zygor: level 38, 16000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Light | Rank 6 | 3472 | 38 | trainer (Zygor: level 38, 16000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of Wisdom | Rank 1 | 20166 | 38 | trainer (Zygor: level 38, 16000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Turn Undead | Rank 2 | 5627 | 38 | trainer (Zygor: level 38, 16000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Consecration | Rank 3 | 20922 | 40 | trainer (Zygor: level 40, 20000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Devotion Aura | Rank 5 | 1032 | 40 | trainer (Zygor: level 40, 20000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Hammer of Justice | Rank 3 | 5589 | 40 | trainer (Zygor: level 40, 20000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Hammer of the Righteous | - | 407632 | 40 | UNKNOWN: not in Zygor's trainer list, no teach spell found | Protection | melee; shares cooldown category 2404 with Holy Strike | GEMETEN (DB2) |
| Holy Shield | Rank 2 | 20927 | 40 | trainer (Zygor: level 50, 1400c) - CONFLICT: DB2 says 40 | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Shock | Rank 2 | 20473 | 40 | trainer (Zygor: level 40, 1000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Light's Vigil | Rank 1 | 1310911 | 40* | TALENT (Holy section, row 7, 30 points in that section) | Holy | needs Holy Shock (talent edge) | GEMETEN (DB2 tree 1100); level AFGELEID |
| Seal of Command | Rank 3 | 20918 | 40 | trainer (Zygor: level 40, 1000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Seal of Light | Rank 2 | 20347 | 40 | trainer (Zygor: level 40, 20000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Shadow Resistance Aura | Rank 2 | 19895 | 40 | trainer (Zygor: level 40, 20000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Blessing of Might | Rank 5 | 19837 | 42 | trainer (Zygor: level 42, 21000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Cleanse | - | 4987 | 42 | trainer (Zygor: level 42, 21000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Flash of Light | Rank 4 | 19941 | 42 | trainer (Zygor: level 42, 21000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of Fury | Rank 5 | 20421 | 42 | trainer (Zygor: level 42, 21000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Seal of Righteousness | Rank 6 | 20291 | 42 | trainer (Zygor: level 42, 21000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of the Crusader | Rank 5 | 20307 | 42 | trainer (Zygor: level 42, 21000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Blessing of Wisdom | Rank 4 | 19853 | 44 | trainer (Zygor: level 44, 22000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Exorcism | Rank 4 | 10312 | 44 | trainer (Zygor: level 44, 22000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Frost Resistance Aura | Rank 2 | 19897 | 44 | trainer (Zygor: level 44, 22000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Hammer of Wrath | Rank 1 | 24275 | 44 | trainer (Zygor: level 44, 22000c) | Holy | target at 20% health or less | GEMETEN (DB2) + Zygor |
| Holy Strike | Rank 6 | 5569 | 44 | trainer (Zygor: level 44, 22000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Blessing of Sacrifice | Rank 1 | 6940 | 46 | trainer (Zygor: level 46, 24000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Light | Rank 7 | 10328 | 46 | trainer (Zygor: level 46, 24000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Retribution Aura | Rank 4 | 10300 | 46 | trainer (Zygor: level 46, 24000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Fire Resistance Aura | Rank 2 | 19899 | 48 | trainer (Zygor: level 48, 26000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Shock | Rank 3 | 20929 | 48 | trainer (Zygor: level 48, 1300c) | Holy | - | GEMETEN (DB2) + Zygor |
| Redemption | Rank 4 | 20772 | 48 | trainer (Zygor: level 48, 26000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of Wisdom | Rank 2 | 20356 | 48 | trainer (Zygor: level 48, 26000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Consecration | Rank 4 | 20923 | 50 | trainer (Zygor: level 50, 28000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Devotion Aura | Rank 6 | 10292 | 50 | trainer (Zygor: level 50, 28000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Divine Shield | Rank 2 | 1020 | 50 | trainer (Zygor: level 50, 28000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Flash of Light | Rank 5 | 19942 | 50 | trainer (Zygor: level 50, 28000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Holy Shield | Rank 3 | 20928 | 50 | trainer (Zygor: level 60, 2300c) - CONFLICT: DB2 says 50 | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Wrath | Rank 1 | 2812 | 50 | trainer (Zygor: level 50, 28000c) | Holy | hits Undead and Demons only | GEMETEN (DB2) + Zygor |
| Lay on Hands | Rank 3 | 10310 | 50 | trainer (Zygor: level 50, 28000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Light's Vigil | Rank 2 | 1311590 | 50 | trainer (Zygor: level 50, 1400c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of Command | Rank 4 | 20919 | 50 | trainer (Zygor: level 50, 1400c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Seal of Fury | Rank 6 | 20422 | 50 | trainer (Zygor: level 50, 28000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Seal of Light | Rank 3 | 20348 | 50 | trainer (Zygor: level 50, 28000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of Righteousness | Rank 7 | 20292 | 50 | trainer (Zygor: level 50, 28000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Blessing of Might | Rank 6 | 19838 | 52 | trainer (Zygor: level 52, 34000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Exorcism | Rank 5 | 10313 | 52 | trainer (Zygor: level 52, 34000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Greater Blessing of Might | Rank 1 | 25782 | 52 | trainer (Zygor: level 52, 46000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Hammer of Wrath | Rank 2 | 24274 | 52 | trainer (Zygor: level 52, 34000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Holy Strike | Rank 7 | 10332 | 52 | trainer (Zygor: level 52, 34000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Seal of the Crusader | Rank 6 | 20308 | 52 | trainer (Zygor: level 52, 34000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Shadow Resistance Aura | Rank 3 | 19896 | 52 | trainer (Zygor: level 52, 34000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Turn Undead | Rank 3 | 10326 | 52 | trainer (Zygor: level 52, 34000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Blessing of Sacrifice | Rank 2 | 20729 | 54 | trainer (Zygor: level 54, 40000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Blessing of Wisdom | Rank 5 | 19854 | 54 | trainer (Zygor: level 54, 40000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Greater Blessing of Wisdom | Rank 1 | 25894 | 54 | trainer (Zygor: level 54, 46000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Hammer of Justice | Rank 4 | 10308 | 54 | trainer (Zygor: level 54, 40000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Light | Rank 8 | 10329 | 54 | trainer (Zygor: level 54, 40000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Frost Resistance Aura | Rank 3 | 19898 | 56 | trainer (Zygor: level 56, 42000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Holy Shock | Rank 4 | 20930 | 56 | trainer (Zygor: level 56, 2100c) | Holy | - | GEMETEN (DB2) + Zygor |
| Retribution Aura | Rank 5 | 10301 | 56 | trainer (Zygor: level 56, 42000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Flash of Light | Rank 6 | 19943 | 58 | trainer (Zygor: level 58, 44000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of Fury | Rank 7 | 20423 | 58 | trainer (Zygor: level 58, 44000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Seal of Righteousness | Rank 8 | 20293 | 58 | trainer (Zygor: level 58, 44000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of Wisdom | Rank 3 | 20357 | 58 | trainer (Zygor: level 58, 44000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Blessing of Might | Rank 7 | 25291 | 60 | not in Zygor's trainer list; probably a level-60 book or drop as in Classic (AFGELEID) | Retribution | - | GEMETEN (DB2) |
| Blessing of Wisdom | Rank 6 | 25290 | 60 | not in Zygor's trainer list; probably a level-60 book or drop as in Classic (AFGELEID) | Holy | - | GEMETEN (DB2) |
| Consecration | Rank 5 | 20924 | 60 | trainer (Zygor: level 60, 46000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Devotion Aura | Rank 7 | 10293 | 60 | trainer (Zygor: level 60, 46000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Exorcism | Rank 6 | 10314 | 60 | trainer (Zygor: level 60, 46000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Fire Resistance Aura | Rank 3 | 19900 | 60 | trainer (Zygor: level 60, 46000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Greater Blessing of Kings | - | 25898 | 60 | trainer (Zygor: level 60, 46000c) | Protection | - | GEMETEN (DB2) + Zygor |
| Greater Blessing of Might | Rank 2 | 25916 | 60 | trainer (Zygor: level 60, 46000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Greater Blessing of Wisdom | Rank 2 | 25918 | 60 | trainer (Zygor: level 60, 46000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Hammer of Wrath | Rank 3 | 24239 | 60 | trainer (Zygor: level 60, 46000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Holy Light | Rank 9 | 25292 | 60 | not in Zygor's trainer list; probably a level-60 book or drop as in Classic (AFGELEID) | Holy | - | GEMETEN (DB2) |
| Holy Shield | Rank 4 | 1239570 | 60 | not in Zygor (its data is older than this rank); probably trainer (AFGELEID) | Protection | - | GEMETEN (DB2) |
| Holy Strike | Rank 8 | 10333 | 60 | trainer (Zygor: level 60, 46000c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Holy Wrath | Rank 2 | 10318 | 60 | trainer (Zygor: level 60, 46000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Light's Vigil | Rank 3 | 1311595 | 60 | trainer (Zygor: level 60, 2300c) | Holy | - | GEMETEN (DB2) + Zygor |
| Redemption | Rank 5 | 20773 | 60 | trainer (Zygor: level 60, 46000c) | Holy | - | GEMETEN (DB2) + Zygor |
| Seal of Command | Rank 5 | 20920 | 60 | trainer (Zygor: level 60, 2300c) | Retribution | - | GEMETEN (DB2) + Zygor |
| Seal of Light | Rank 4 | 20349 | 60 | trainer (Zygor: level 60, 46000c) | Holy | - | GEMETEN (DB2) + Zygor |

Racials (GEMETEN, SLA AcquireMethod 2, racial lines): Human 754: **Will to Survive** 1259718 ("Instantly removes all Stun
effects", 180 s) and **Perception** 20600 (stealth detection, 180 s). Dwarf 101: **Stoneform** 20594 (180 s) and
**Find Treasure** 2481 (tracking). Undead 220: **Will of the Forsaken** 7744 (120 s) and **Cannibalize** 20577 (120 s).
Passives not listed. Skyborne racials (line 2980) do not apply (no Skyborne Paladin).

Class mounts (GEMETEN names/levels, SkillLine 777 "Mounts", not a Paladin tab): Summon Warhorse 13819 (40, Human/Dwarf,
teach spell 13820), Summon Warhorse 1279399 (40, no race mask, teach spell 1279400), Summon Charger 23214 (60,
Human/Dwarf, teach 23215), Summon Forsaken Charger 1296534 (teach 1296537). In Classic Era 13819/23214 sat on the Holy
line (SLA compare). Whether Forever shows them in the spellbook or only in a mount collection is NOT measured.

## What Forever changed vs Classic Era (GEMETEN: SLA/SpellName/SpellLevels diff 1.15.9.70576 -> 1.60.1.70790)
- New active spells: **Holy Strike** R1-8 (6/12/20/28/36/44/52/60), **Seal of Fury** R1-7 (10/18/26/34/42/50/58; R1-2 new
  IDs 1311649/1311656), **Voice of Truth** (20), **Hammer of the Righteous** (40, on the Protection line, AcquireMethod 0),
  **Light's Vigil** R1-3, **Holy Shield R4** 1239570 (60), Holy Shock R1 with a new ID 1311606, talents Templar's
  Bulwark, Swift Judgement, Oath of Light.
- Gone from the Paladin lines: Blessing of Salvation + Greater, Blessing of Light + Greater, Blessing of Sanctuary +
  Greater (no SpellName in 70790), **Sanctity Aura** 20218 (still in SpellName, on no Paladin line, not in tree 1100),
  Divine Steed. The mounts moved to the Mounts line.
- Level changes: **Righteous Fury 16 -> 10**; **Holy Shield R1/R2/R3 40/50/60 -> 30/40/50**; Sense Undead from level 20
  (AcquireMethod 0) to a starting spell for the Horde-race mask, level 0 for Alliance races; Holy Light R1 a quest spell for Undead.
- In 70790 text: Judgement "Does not consume the Seal"; Seals last 30 s; **all Blessings and Greater Blessings last 60 min**
  (SpellDuration 3600000). I did not compare these texts/durations with Classic Era.
- Build churn 70707 -> 70790 (GEMETEN): Oath of Light added; "Salvation", "Mass Salvation", "Revoke", Blessing of Light
  and Greater Blessing of Light removed; Holy Shield moved to 30/40/50 + R4 at 60.
- Conflicts with Zygor (Zygor is older, DB2 wins until a trainer is checked): Righteous Fury 16 vs DB2 10, Seal of Fury R3
  25 vs 26, Holy Shield R2/R3 50/60 vs 40/50.

### Greater Blessings and books (the question in the brief)
- Greater Blessing of Might R1/R2 (52/60), of Wisdom R1/R2 (54/60) and of Kings (60) are **trainer spells** in Zygor
  (46000c each) and AcquireMethod 0 in DB2. I saw no book for them. GEMETEN (Zygor + DB2), "no book" AFGELEID.
- The level-60 ranks that Zygor's trainer list does NOT have: **Blessing of Might R7 25291, Blessing of Wisdom R6 25290,
  Holy Light R9 25292**. In Classic these came from books (AFGELEID, from memory of Classic, not measured). Wowhead was
  blocked, so I could not check their source in Forever.
- An empty "teach spell" search proves nothing for books: the Druid's Gift of the Wild (a known book) also has no
  Effect-36 teach spell. Positive control for that search: Redemption 7328 <- 7329, Holy Light 635 <- 1240334.

## States and macro conditions
**Paladin has no state at all** in Forever: no form, no stance, no stealth, no bar paging.
- GEMETEN, DB2 `SpellShapeshiftForm` (32 rows): the only forms with a BonusActionBar are Cat (1), Stealth (1), Battle
  Stance (1), Defensive Stance (2), Bear/Dire Bear (3), Berserker Stance (3). No Paladin form exists.
- GEMETEN, DB2 `SpellShapeshift`: Retribution, Concentration, Shadow/Frost/Fire Resistance and Sanctity Aura have
  StanceBarOrder 1-6 with ShapeshiftMask 0; Devotion Aura has no row. Their effects are aura types 15/118/149/232, no
  shapeshift aura (36).
- GEMETEN, Blizzard `ActionBarController_UpdateAll` (forever, 70790): bar 1 pages to `C_ActionBar.GetBonusBarIndex()` only
  when `C_ActionBar.HasBonusActionBar()` and the page is 1 (after vehicle / override / temp-shapeshift checks).
- GEMETEN, EllesmereUI: on Forever it adds `[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10` for every
  class; it has no Paladin entry (CLASS_DEFAULTS knows only DRUID and ROGUE).
- AFGELEID from those: a Paladin never gets a bonus bar, so `[bonusbar:N]` is never true and the table needs
  `states = {}` and no `baseGuard`.
- Conditions the draft does use (standard macro conditionals, not measured in Forever): `[combat]` (F3, same as the Druid's
  Rebirth/Revive) and `[group]` (blessing keys: Greater Blessing in a group, normal Blessing solo).
- Not used, open: if Forever counts the auras as stance-bar forms (StanceBarOrder hints at it), `[stance:N]` would exist.
  Nothing on the block needs it.

## Proposal per key (AFGELEID throughout: the choices are mine, the levels are DB2)
Rob's rules: one macro per key, spells by NAME (highest rank), unlearned spells keep their place, talents get a fixed place.
Because there are no states, the Druid's state columns collapse into one "Spell" column. Level `*` = talent.

| Key | Task | Spell (level) | Why / judgment call |
|---|---|---|---|
| 1 | main | Holy Strike (6) | The melee strike, like Claw/Maul. Shares cooldown category 2404 with Hammer of the Righteous. |
| 2 | rotation | Judgement (4) | 10 s, no GCD, does not consume the Seal. |
| 3 | rotation | Seal of Command (20*) else Seal of Righteousness (1) | Seals last 30 s, so you re-seal in combat. List: the talent wins, like Dire Bear over Bear. A Ret with the talent loses a SoR key (it stays "listed"). |
| 4 | spender | Hammer of Wrath (44) | Execute, 20% health or less: the closest thing to a finisher. |
| 5 | rotation | Exorcism (20) | Undead or Demon only, 15 s. |
| Shift-4 | 2nd spender / AoE spender | Holy Shield (30*) | Prot, 10 s. Damage on every block, so AoE threat next to Shift-1/2. Judgment call: tanks may want it on 5. |
| Shift-1 | AoE | Consecration (20) | |
| Shift-2 | AoE | Hammer of the Righteous (40) | Melee AoE; how it is learned is unknown. |
| Q | big cooldown | Lay on Hands (10) | 20 min. Like the Druid's Tranquility. |
| F1 | cooldown 2 | Swift Judgement (25*) | Prot, 60 s, no GCD, needs Templar's Bulwark. |
| Shift-3 | cooldown 3 | Divine Favor (20*) | Holy, 120 s; next heal crits. Same place as the Druid's Nature's Swiftness. |
| Shift-F1 | cooldown 2, second | Light's Vigil (40*) | Holy; makes the next Holy Shock free + party heal. Same place as Swiftmend. |
| F3 | cooldown 4 | pair `[combat]` Divine Intervention (30) ; Redemption (12) | Same idea as the Druid's Rebirth/Revive. Redemption cannot be cast in combat. |
| E | interrupt | Hammer of Justice (8) | Paladin has no interrupt (Rebuke is AcquireMethod 3). HoJ is a 3 s stun, 60 s; a stun stops a cast. Judgment call. |
| R | movement | Blessing of Freedom (18) | Immunity to movement-impairing effects, 20 s cooldown. Paladin has no other movement spell. |
| Shift-R | movement 2 | Oath of Light (25*) | No 2nd movement spell exists. A talent needs a fixed place; this was the free one. Judgment call. |
| F | taunt / help | Seal of Fury (10) | Paladin has no taunt; Seal of Fury's Judgement taunts (tooltip). Alternative: Blessing of Protection here. |
| Z | small defensive | Divine Shield (34) else Divine Protection (6) | They share cooldown category 37 (300 s), so one key. The always-available defensive, like Barkskin. |
| X | defensive 2 | Templar's Bulwark (20*) | Prot absorb, 300 s, Forbearance. |
| C | big defensive / big heal | Holy Light (1) | Big heal, same as the Druid's Healing Touch. |
| F2 | quick heal | Flash of Light (20) | |
| F4 | HoT / recuperate | Holy Shock (30*) | No HoT exists; the instant heal. |
| V | CC | Repentance (30*) | Ret talent, Humanoid only. Empty for others. |
| Shift-Q | CC | Turn Undead (24) | Undead only, like Hibernate (beasts/dragonkin). |
| Shift-F | CC / help | Blessing of Protection (10) | Save an ally (Forbearance). |
| Shift-V | CC / dispel slot, used for a buff | pair `[group]` Greater Blessing of Wisdom (54) ; Blessing of Wisdom (14) | Paladin has one dispel line only, so the 2nd dispel place holds the 3rd blessing. Judgment call. |
| Shift-Z | buff | pair `[group]` Greater Blessing of Might (52) ; Blessing of Might (4) | Like the Druid's Thorns place. |
| Shift-X | buff | pair `[group]` Greater Blessing of Kings (60) ; Blessing of Kings (20) | Like Mark/Gift of the Wild. |
| Shift-C | dispel | Cleanse (42) else Purify (8) | Like Abolish/Cure Poison. |
| Shift-E | racial | Will to Survive / Stoneform / Will of the Forsaken | One per race; the other racial goes to block D. |
| Ctrl-1 | form 1 / extra | Devotion Aura (1) | Auras are the Paladin's stance-like toggles. |
| Ctrl-2 | form 2 / extra | Retribution Aura (16) | |
| Ctrl-3 | form 3 / extra | Concentration Aura (22) | |
| T, Shift-T, G | fixed | potion, healthstone, trinket | |

**Block D** (12 Alt places, the player's own): Righteous Fury (10), Seal of the Crusader (6), Seal of Justice (22),
Seal of Light (30), Seal of Wisdom (38), Blessing of Sacrifice (46), Holy Wrath (50), Voice of Truth (20), Shadow
Resistance Aura (28), Frost Resistance Aura (32), Fire Resistance Aura (36), Sense Undead, and the second racial
(Perception / Find Treasure / Cannibalize).
**Over by one:** at 60 a character knows 12 of these class spells + 1 racial = 13 for 12 places (offline test: "block D
(13)"). Rob has to pick one that leaves (my suggestion: Sense Undead, if Forever's minimap tracking menu offers it).

Early levels fill well (offline test, Dwarf level 20 with Seal of Command): 1, 2, 3, 5, C, Ctrl-1/2, E, F, F2, F3, Q, R,
Shift-1, Shift-C, Shift-E, Shift-F, Shift-V, Shift-X, Shift-Z, Z = 21 keys; block D 4.

## Draft Lua table (for review, NOT in the repo)
File: `scratchpad\paladin_work\paladin_draft.lua`. Tested offline with the real engine
(`scratchpad\paladin_work\test_paladin.lua`, run with `lua`): every key builds the expected `/cast` line, for example
`SHIFT-Z  [group] Greater Blessing of Might; Blessing of Might` and `F3  [combat] Divine Intervention; Redemption`.

```lua
ns.FOREVER_BLOCK_CLASSES.PALADIN = {
	states = {},
	baseGuard = nil,
	keys = {
		["1"] = { base = "Holy Strike" },
		["2"] = { base = "Judgement" },
		["3"] = { base = { "Seal of Command", "Seal of Righteousness" } },
		["4"] = { base = "Hammer of Wrath" },
		["5"] = { base = "Exorcism" },
		["SHIFT-4"] = { base = "Holy Shield" },
		["SHIFT-1"] = { base = "Consecration" },
		["SHIFT-2"] = { base = "Hammer of the Righteous" },
		["Q"] = { base = "Lay on Hands" },
		["F1"] = { base = "Swift Judgement" },
		["SHIFT-3"] = { base = "Divine Favor" },
		["SHIFT-F1"] = { base = "Light's Vigil" },
		["F3"] = { pair = { cond = "[combat]", first = "Divine Intervention", second = "Redemption" } },
		["E"] = { base = "Hammer of Justice" },
		["R"] = { base = "Blessing of Freedom" },
		["SHIFT-R"] = { base = "Oath of Light" },
		["F"] = { base = "Seal of Fury" },
		["Z"] = { base = { "Divine Shield", "Divine Protection" } },
		["X"] = { base = "Templar's Bulwark" },
		["C"] = { base = "Holy Light" },
		["F2"] = { base = "Flash of Light" },
		["F4"] = { base = "Holy Shock" },
		["V"] = { base = "Repentance" },
		["SHIFT-Q"] = { base = "Turn Undead" },
		["SHIFT-F"] = { base = "Blessing of Protection" },
		["SHIFT-Z"] = { pair = { cond = "[group]", first = "Greater Blessing of Might", second = "Blessing of Might" } },
		["SHIFT-X"] = { pair = { cond = "[group]", first = "Greater Blessing of Kings", second = "Blessing of Kings" } },
		["SHIFT-V"] = { pair = { cond = "[group]", first = "Greater Blessing of Wisdom", second = "Blessing of Wisdom" } },
		["SHIFT-C"] = { base = { "Cleanse", "Purify" } },
		["SHIFT-E"] = { all = { "Stoneform", "Will to Survive", "Will of the Forsaken" } },
		["CTRL-1"] = { base = "Devotion Aura" },
		["CTRL-2"] = { base = "Retribution Aura" },
		["CTRL-3"] = { base = "Concentration Aura" },
	},
	toBlockD = { "Righteous Fury", "Seal of the Crusader", "Seal of Justice", "Seal of Light", "Seal of Wisdom",
		"Blessing of Sacrifice", "Holy Wrath", "Voice of Truth", "Shadow Resistance Aura", "Frost Resistance Aura",
		"Fire Resistance Aura", "Sense Undead", "Perception", "Find Treasure", "Cannibalize" },
}
```
Every name is spelled as in SpellName.csv 70790 (the table generator read them from there). Not added, on purpose: the
class mounts (Summon Warhorse / Summon Charger / Summon Forsaken Charger). If they turn out to be in the spellbook, add
them to `listed` (or to block D) so the "not in MH's list" line stays quiet.

## Open questions for Rob
1. **E = Hammer of Justice** as the "interrupt" (it is a stun), or HoJ on V and E empty, as the Druid's caster form has?
2. **F = Seal of Fury** as the "taunt" (its Judgement taunts), or F = Blessing of Protection (and Seal of Fury on block D)?
   You tank as Prot Paladin in Midnight, so this one is yours to feel.
3. **Key 3**: Seal of Command replaces Seal of Righteousness once talented. Fine, or keep SoR on its own key?
4. **Holy Shield on Shift-4** with Exorcism on 5, or the other way round (tank-first)?
5. **Blessings**: `[group]` = Greater, solo = normal; all last 60 min. OK? And the third blessing (Wisdom) on Shift-V,
   a CC/dispel place?
6. **Shift-R = Oath of Light**: Paladin has no 2nd movement spell. Better place?
7. **Block D is one too full at 60** (13 for 12). Which one leaves?
8. At a trainer: Righteous Fury at 10 (DB2) or 16 (Zygor)? Seal of Fury R3 at 25 or 26? Holy Shield R2 at 40 or 50?
   Where do **Hammer of the Righteous** (40) and **Voice of Truth** (20) come from? Are **Holy Light R9, Blessing of Might
   R7, Blessing of Wisdom R6** books/drops?
9. On a Paladin that knows Retribution Aura: `/run print(GetNumShapeshiftForms())`. 0 = auras are not stances (as the
   draft assumes); more = `[stance:N]` would work.
10. Do the class mounts show in the spellbook, or only in a mount collection?
11. What are the "Talented Rank 1-5 (Level 9..5)" talent-point sources? They could make talents come earlier.
12. How does a Human/Dwarf Paladin get Sense Undead (DB2 says level 0, not at Zygor's trainer)?

## What is GEMETEN vs AFGELEID
GEMETEN (seen in a named, dated source):
- Every spell ID, rank, level, tab, AcquireMethod, passive bit, cooldown, duration and tooltip text: DB2 70790.
- Talent tree 1100, row gates, edges and the 1-point-per-level sources: DB2 70790.
- Paladin races Human, Dwarf, Undead (Horde); no Skyborne Paladin: DB2 CharBaseInfo/ChrRaces 70790; Undead Paladin
  also in warcrafttavern (undated page) and warcraft.wiki.gg (11 Oct 2026).
- Undead Holy Light from the level-2 quest: warcraft.wiki.gg (11 Oct 2026) + DB2 (SLA 59546, teach 1240334).
- "trainer" + cost: Zygor's Forever trainer list (older than 70790).
- No Paladin bonus bar / form: DB2 SpellShapeshiftForm + SpellShapeshift; Blizzard UI 70790; EllesmereUI file.
- Forever vs Classic Era and 70707 differences: DB2 diff read 6 Nov 2026.
- Offline engine test results of the draft table.
AFGELEID (reasoned, not measured):
- Talent levels (`*`) = 10 + points needed.
- "No state" for the Paladin and that `[group]`/`[combat]` behave as in other clients.
- That a stun counts as the Paladin's interrupt; every key choice in the proposal.
- That the level-60 R9/R7/R6 ranks are books; that the mounts live outside the spellbook; that Vindication 67 is only a
  talent debuff.
- Where the "UNKNOWN" spells come from (Hammer of the Righteous, Voice of Truth, Holy Shield R4, Sense Undead for
  Alliance).
