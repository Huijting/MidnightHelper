# WoW Forever — Mage: spells tot 60 + VOORSTEL voor het toetsenblok

> 🌙 **Nacht 5→6 nov 2026, onderzoek door mh-research (één helper per class). NIET goedgekeurd door Rob, NIET in de
> addon.** Alleen een goedgekeurde tabel komt in `Modules/ForeverBlock_<Class>.lua`.
>
> **Zelf nagekeken in de nacht (GEMETEN):**
> - beginspells staan in Blizzards data met AcquireMethod 2: Fireball 133, Frost Armor 168 (wago wowf 1.60.1.70790, SkillLineAbility);
> - de concepttabel hieronder laadt in de échte motor (`Modules/ForeverBlock.lua`, offline met nagebootste spells):
>   elke spellnaam bestaat in SpellName, elke toets is een blok-plek, geen spell op twee toetsen;
> - stance/vorm-nummers: SpellShapeshiftForm.BonusActionBar (Cat 1, Bear 3, Stealth 1, Battle 1, Defensive 2,
>   Berserker 3, Moonkin/Shadowform/Ghost Wolf 0).
> - Niet in het spel getest. Elke toetskeuze is een voorstel (AFGELEID).
> - Voor alle classes geldt (helpers, GEMETEN in de data): een account-perk 'Talented' geeft al talentpunten vanaf
>   level 5-9, dus talent-levels hieronder kunnen tot 5 levels vroeger zijn.

**Aandachtspunten van de nachtcontrole:**
- F, F2 en F4 (taunt / snelle heal / heal over tijd) heeft een Mage niet; de helper zette er Ice Lance, Frost Ward en Fire Ward op (regel 4: elke spell een plek).

---

# WoW Forever Mage: spells 1-60, states and a key-block proposal (client 1.60.1.70790)

Researched 5 Nov 2026 (night of 5 to 6 Nov). Read-only: nothing in the repo was changed. This is a DRAFT for Rob's review,
in the shape of the approved Druid table (`Modules/ForeverBlock_Druid.lua`).

Note on method: my own agent rule forbids reading anything under `MidnightHelper/docs/`, so I did NOT open
`docs/PLAN_FOREVER_DRUID_BLOK_2026-11-05.md` or `docs/FOREVER_DRUID_SPELLS_2026-11-05.md`. I copied the shape from the
code (`ForeverBlock_Druid.lua`, `ForeverBlock.lua` header) and from the scratchpad copy of the Druid list
(`scratchpad\forever_druid_spells.md`).

## Sources

- **DB2** = wago.tools, product `wowf`, build **1.60.1.70790**. The tables in `scratchpad\wago_wowf\` (fetched 5 Nov 2026,
  see its README) plus three I fetched myself on 5 Nov 2026 with plain curl for the same build: `ChrRaces`,
  `CharBaseInfo`, `SkillLineXTraitTree` (in `forever_classes\mage_work\extra\`).
- **Era** = Classic Era DB2 build 1.15.9.70576 (the build the Druid researcher used), fetched 5 Nov 2026:
  `CharBaseInfo`, `SkillLineAbility`, `SpellLevels`, `SpellName` (in `forever_classes\mage_work\extra_era\`).
  Only used to say what Forever changed.
- **WH** = Wowhead Forever, read 5 Nov 2026 in my own in-app browser tab (closed afterwards):
  `wowhead.com/forever/spells/abilities/mage` (248 rows, read from the page's own listview data; `source` 6 = trainer,
  4 = quest, 2 = drop/book, as in the Druid list), plus `spell=1297659` (Teleport: Dalaran), `spell=1296017`
  (Comprehend Scroll), `spell=1302508` (Study). No verification check was shown.
- **UI** = Blizzard UI source for Forever: `github.com/Gethe/wow-ui-source`, branch `forever`,
  `Interface/AddOns/Blizzard_ActionBarController/ActionBarController.lua` (blob 3f18224c, 7378 bytes, fetched 5 Nov 2026).
- **EUI** = `E:\World of Warcraft\_forever_\Interface\AddOns\EllesmereUIActionBars\EUI_ActionBars_Paging.lua` and
  `...\EllesmereUI\EllesmereUI_VisibilityRules.lua` (Rob's installed Forever copy, read 5 Nov 2026).
- **MH code** (read only): `Modules\ForeverBlock.lua`, `Modules\ForeverBlock_Druid.lua`, `Modules\KeyBlock.lua`
  (BLOCK lines 22-59, ANCHOR/CATEGORY 79-107, OVERFLOW 115-116), `Modules\KeybindRoles_Mage.lua` (the retail Mage
  mapping, as a precedent only).
- My scripts: `scratchpad\forever_classes\mage_work\s1..s9*.py` (run with `python -I`). Raw dumps there:
  `mage_sla.tsv` (all 371 Mage SkillLineAbility rows), `tree_1112.txt` (the talent tree), `spell_table.md`.

## Positive control: PASSES (GEMETEN, DB2 70790)

| What | Result |
|---|---|
| Class and spec | ChrClasses ID 8 = MAGE (token MAGE). ChrSpecialization 1482 "Mage", ClassID 8: one spec, as for the Druid (1484). |
| Mage skill lines | SkillRaceClassInfo gives ClassMask 128 to SkillLine 237 Arcane, 6 Frost, 8 Fire. 371 SkillLineAbility rows; 270 have a name in SpellName. |
| **Level-1 starting spells (AcquireMethod 2)** | **Fireball Rank 1 (133)** and **Frost Armor Rank 1 (168)**, both level 1. Also Shoot 5019 (Wands skill line 228, AcquireMethod 2, ClassMask 400 = Priest+Mage+Warlock). This matches the classic start (Fireball + Frost Armor). |
| Level-1 trainer spell | Arcane Intellect Rank 1 (1459), level 1, WH: trainer, 10c. |
| Talent tree | SkillLineXTraitTree row 129: SkillLine 237 -> TraitTree 1112. 53 nodes in 3 sections, 11 of them active spells. Currency 3820, SourcedMax 51 (same as the Druid). |
| My "is it a form?" check finds forms | EffectAura 36 (shapeshift) is on Cat Form 768 and Bear Form 5487 (so the check works). It is on **0** of the 371 Mage spells. |
| Every name in the draft exists | All 73 spell names used below are in SpellName 70790 (0 missing). |
| DB2 and WH agree on the list | Every non-talent active DB2 row is in the WH list, and every WH row I mapped is in DB2 (0 unmatched either way, 197 table rows). |

## Legend

- Level with `*` = talent. The number is the earliest level the tree row opens: each row needs 5 more points in that
  section (TraitCond SpentAmountRequired 5/10/15/20/25/30, GEMETEN), and TraitCurrencySource gives 1 point per level from
  10 to 60 (51 rows "Level 10" ... "Level 60", GEMETEN). So row 3 = 20, row 4 = 25, row 5 = 30, row 7 = 40 (that sum is
  AFGELEID). **Exception:** the "Talented" perk (spell 1225474, TraitTree 1188, ranks 1-5) says "You gain talent points
  every level starting at level $s1 instead of starting at level 10, but you still may not have more than 51" and
  TraitCurrencySource has "Talented Rank 1 (Level 9)" ... "Talented Rank 5 (Level 5)" (GEMETEN). With it a row can open up
  to 5 levels earlier. How a player gets "Talented" I did not check.
- "trainer (needs the talent)" = WH says trainer; that you need the rank-1 talent first is AFGELEID (same as the Druid's
  Insect Swarm ranks).
- Tab = the SkillLine of the row (Arcane / Fire / Frost). That this is the spellbook tab is AFGELEID (as in the Druid list).
- Form/stance column left out: no Mage spell has a form or stance requirement (0 SpellShapeshift rows for Mage spells,
  GEMETEN).
- Not in the table: passive spells (SpellMisc Attributes_0 bit 0x40), the rows without a name (removed spells), the
  Season-of-Discovery rune spells with AcquireMethod 3, and 8 proc/effect spells that are not buttons (see below).

## Spell list (197 active rows, levels 1-60)

| Spell | Rank | ID | Level | How learned | Tab | Measured? |
|---|---|---|---|---|---|---|
| Arcane Intellect | Rank 1 | 1459 | 1 | trainer (10c) | Arcane | GEMETEN (DB2 + WH) |
| Fireball | Rank 1 | 133 | 1 | starting spell (DB2 AcquireMethod 2) | Fire | GEMETEN (DB2) |
| Frost Armor | Rank 1 | 168 | 1 | starting spell (DB2 AcquireMethod 2) | Frost | GEMETEN (DB2) |
| Conjure Water | Rank 1 | 5504 | 4 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 1 | 116 | 4 | trainer | Frost | GEMETEN (DB2 + WH) |
| Conjure Food | Rank 1 | 587 | 6 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Blast | Rank 1 | 2136 | 6 | trainer | Fire | GEMETEN (DB2 + WH) |
| Fireball | Rank 2 | 143 | 6 | trainer | Fire | GEMETEN (DB2 + WH) |
| Arcane Missiles | Rank 1 | 5143 | 8 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 2 | 205 | 8 | trainer | Frost | GEMETEN (DB2 + WH) |
| Polymorph | Rank 1 | 118 | 8 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Conjure Water | Rank 2 | 5505 | 10 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Frost Armor | Rank 2 | 7300 | 10 | trainer | Frost | GEMETEN (DB2 + WH) |
| Frost Nova | Rank 1 | 122 | 10 | trainer | Frost | GEMETEN (DB2 + WH) |
| Conjure Food | Rank 2 | 597 | 12 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Dampen Magic | Rank 1 | 604 | 12 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fireball | Rank 3 | 145 | 12 | trainer | Fire | GEMETEN (DB2 + WH) |
| Slow Fall | - | 130 | 12 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Explosion | Rank 1 | 1449 | 14 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Intellect | Rank 2 | 1460 | 14 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Blast | Rank 2 | 2137 | 14 | trainer | Fire | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 3 | 837 | 14 | trainer | Frost | GEMETEN (DB2 + WH) |
| Arcane Missiles | Rank 2 | 5144 | 16 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Flamestrike | Rank 1 | 2120 | 16 | trainer | Fire | GEMETEN (DB2 + WH) |
| Amplify Magic | Rank 1 | 1008 | 18 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fireball | Rank 4 | 3140 | 18 | trainer | Fire | GEMETEN (DB2 + WH) |
| Remove Lesser Curse | - | 475 | 18 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Blast | Rank 1 | 400574 | 20* | TALENT (Arcane section, row 3) | Arcane | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel 20 |
| Blink | - | 1953 | 20 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Blizzard | Rank 1 | 10 | 20 | trainer | Frost | GEMETEN (DB2 + WH) |
| Conjure Water | Rank 3 | 5506 | 20 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Evocation | - | 12051 | 20 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Ward | Rank 1 | 543 | 20 | trainer | Fire | GEMETEN (DB2 + WH) |
| Frost Armor | Rank 3 | 7301 | 20 | trainer | Frost | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 4 | 7322 | 20 | trainer | Frost | GEMETEN (DB2 + WH) |
| Ice Lance | Rank 1 | 1312002 | 20* | TALENT (Frost section, row 3) | Frost | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel 20 |
| Mana Shield | Rank 1 | 1463 | 20 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Polymorph | Rank 2 | 12824 | 20 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Pyroblast | Rank 1 | 11366 | 20* | TALENT (Fire section, row 3) | Fire | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel 20 |
| Teleport: Ironforge | - | 3562 | 20 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Teleport: Orgrimmar | - | 3567 | 20 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Teleport: Stormwind | - | 3561 | 20 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Teleport: Undercity | - | 3563 | 20 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Explosion | Rank 2 | 8437 | 22 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Conjure Food | Rank 3 | 990 | 22 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Blast | Rank 3 | 2138 | 22 | trainer | Fire | GEMETEN (DB2 + WH) |
| Frost Ward | Rank 1 | 6143 | 22 | trainer | Frost | GEMETEN (DB2 + WH) |
| Scorch | Rank 1 | 2948 | 22 | trainer | Fire | GEMETEN (DB2 + WH) |
| Arcane Missiles | Rank 3 | 5145 | 24 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Counterspell | - | 2139 | 24 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Dampen Magic | Rank 2 | 8450 | 24 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fireball | Rank 5 | 8400 | 24 | trainer | Fire | GEMETEN (DB2 + WH) |
| Flamestrike | Rank 2 | 2121 | 24 | trainer | Fire | GEMETEN (DB2 + WH) |
| Pyroblast | Rank 2 | 12505 | 24 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |
| Arcane Wrath | Rank 1 | 1326079 | 25* | TALENT (Arcane section, row 4) | Arcane | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel 25 |
| Ice Block | - | 11958 | 25* | TALENT (Frost section, row 4) | Frost | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel says 4 |
| Cone of Cold | Rank 1 | 120 | 26 | trainer | Frost | GEMETEN (DB2 + WH) |
| Frost Nova | Rank 2 | 865 | 26 | trainer | Frost | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 5 | 8406 | 26 | trainer | Frost | GEMETEN (DB2 + WH) |
| Arcane Intellect | Rank 3 | 1461 | 28 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Blizzard | Rank 2 | 6141 | 28 | trainer | Frost | GEMETEN (DB2 + WH) |
| Conjure Mana Agate | - | 759 | 28 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Ice Lance | Rank 2 | 400640 | 28 | trainer (needs the talent) | Frost | GEMETEN (DB2 + WH) |
| Mana Shield | Rank 2 | 8494 | 28 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Scorch | Rank 2 | 8444 | 28 | trainer | Fire | GEMETEN (DB2 + WH) |
| Amplify Magic | Rank 2 | 8455 | 30 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Blast | Rank 2 | 1239696 | 30 | trainer (needs the talent) | Arcane | GEMETEN (DB2 + WH) |
| Arcane Explosion | Rank 3 | 8438 | 30 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Blast Wave | Rank 1 | 11113 | 30* | TALENT (Fire section, row 5) | Fire | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel 30 |
| Cold Snap | - | 12472 | 30* | TALENT (Frost section, row 5) | Frost | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel 1 |
| Conjure Water | Rank 4 | 6127 | 30 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Blast | Rank 4 | 8412 | 30 | trainer | Fire | GEMETEN (DB2 + WH) |
| Fire Ward | Rank 2 | 8457 | 30 | trainer | Fire | GEMETEN (DB2 + WH) |
| Fireball | Rank 6 | 8401 | 30 | trainer | Fire | GEMETEN (DB2 + WH) |
| Ice Armor | Rank 1 | 7302 | 30 | trainer | Frost | GEMETEN (DB2 + WH) |
| Presence of Mind | - | 12043 | 30* | TALENT (Arcane section, row 5) | Arcane | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel 1 |
| Pyroblast | Rank 3 | 12522 | 30 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |
| Teleport: Darnassus | - | 3565 | 30 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Teleport: Thunder Bluff | - | 3566 | 30 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Missiles | Rank 4 | 8416 | 32 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Conjure Food | Rank 4 | 6129 | 32 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Flamestrike | Rank 3 | 8422 | 32 | trainer | Fire | GEMETEN (DB2 + WH) |
| Frost Ward | Rank 2 | 8461 | 32 | trainer | Frost | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 6 | 8407 | 32 | trainer | Frost | GEMETEN (DB2 + WH) |
| Cone of Cold | Rank 2 | 8492 | 34 | trainer | Frost | GEMETEN (DB2 + WH) |
| Ice Lance | Rank 3 | 1240044 | 34 | trainer (needs the talent) | Frost | GEMETEN (DB2 + WH) |
| Mage Armor | Rank 1 | 6117 | 34 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Scorch | Rank 3 | 8445 | 34 | trainer | Fire | GEMETEN (DB2 + WH) |
| Arcane Wrath | Rank 2 | 1326080 | 36 | trainer (needs the talent) | Arcane | GEMETEN (DB2 + WH) |
| Blast Wave | Rank 2 | 13018 | 36 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |
| Blizzard | Rank 3 | 8427 | 36 | trainer | Frost | GEMETEN (DB2 + WH) |
| Dampen Magic | Rank 3 | 8451 | 36 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fireball | Rank 7 | 8402 | 36 | trainer | Fire | GEMETEN (DB2 + WH) |
| Mana Shield | Rank 3 | 8495 | 36 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Pyroblast | Rank 4 | 12523 | 36 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |
| Arcane Explosion | Rank 4 | 8439 | 38 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Conjure Mana Jade | - | 3552 | 38 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Blast | Rank 5 | 8413 | 38 | trainer | Fire | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 7 | 8408 | 38 | trainer | Frost | GEMETEN (DB2 + WH) |
| Arcane Blast | Rank 3 | 1239697 | 40 | trainer (needs the talent) | Arcane | GEMETEN (DB2 + WH) |
| Arcane Missiles | Rank 5 | 8417 | 40 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Power | - | 12042 | 40* | TALENT (Arcane section, row 7) | Arcane | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel 1 |
| Combustion | - | 11129 | 40* | TALENT (Fire section, row 7) | Fire | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel 40 |
| Conjure Water | Rank 5 | 10138 | 40 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Ward | Rank 3 | 8458 | 40 | trainer | Fire | GEMETEN (DB2 + WH) |
| Flamestrike | Rank 4 | 8423 | 40 | trainer | Fire | GEMETEN (DB2 + WH) |
| Frost Nova | Rank 3 | 6131 | 40 | trainer | Frost | GEMETEN (DB2 + WH) |
| Frostfire Bolt | Rank 1 | 401502 | 40 | trainer | Fire | GEMETEN (DB2 + WH) |
| Ice Armor | Rank 2 | 7320 | 40 | trainer | Frost | GEMETEN (DB2 + WH) |
| Ice Barrier | Rank 1 | 11426 | 40* | TALENT (Frost section, row 7) | Frost | GEMETEN (DB2 tree 1112); level AFGELEID (row rule); DB2 SpellLevel 40 |
| Polymorph | Rank 3 | 12825 | 40 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Portal: Ironforge | - | 11416 | 40 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Portal: Orgrimmar | - | 11417 | 40 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Portal: Stormwind | - | 10059 | 40 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Portal: Undercity | - | 11418 | 40 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Scorch | Rank 4 | 8446 | 40 | trainer | Fire | GEMETEN (DB2 + WH) |
| Amplify Magic | Rank 3 | 10169 | 42 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Intellect | Rank 4 | 10156 | 42 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Cone of Cold | Rank 3 | 10159 | 42 | trainer | Frost | GEMETEN (DB2 + WH) |
| Conjure Food | Rank 5 | 10144 | 42 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fireball | Rank 8 | 10148 | 42 | trainer | Fire | GEMETEN (DB2 + WH) |
| Frost Ward | Rank 3 | 8462 | 42 | trainer | Frost | GEMETEN (DB2 + WH) |
| Ice Lance | Rank 4 | 1240045 | 42 | trainer (needs the talent) | Frost | GEMETEN (DB2 + WH) |
| Pyroblast | Rank 5 | 12524 | 42 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |
| Blast Wave | Rank 3 | 13019 | 44 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |
| Blizzard | Rank 4 | 10185 | 44 | trainer | Frost | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 8 | 10179 | 44 | trainer | Frost | GEMETEN (DB2 + WH) |
| Mana Shield | Rank 4 | 10191 | 44 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Explosion | Rank 5 | 10201 | 46 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Blast | Rank 6 | 10197 | 46 | trainer | Fire | GEMETEN (DB2 + WH) |
| Ice Barrier | Rank 2 | 13031 | 46 | trainer (needs the talent) | Frost | GEMETEN (DB2 + WH) |
| Mage Armor | Rank 2 | 22782 | 46 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Scorch | Rank 5 | 10205 | 46 | trainer | Fire | GEMETEN (DB2 + WH) |
| Arcane Missiles | Rank 6 | 10211 | 48 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Wrath | Rank 3 | 1326081 | 48 | trainer (needs the talent) | Arcane | GEMETEN (DB2 + WH) |
| Conjure Mana Citrine | - | 10053 | 48 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Dampen Magic | Rank 4 | 10173 | 48 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fireball | Rank 9 | 10149 | 48 | trainer | Fire | GEMETEN (DB2 + WH) |
| Flamestrike | Rank 5 | 10215 | 48 | trainer | Fire | GEMETEN (DB2 + WH) |
| Ice Lance | Rank 5 | 1240046 | 48 | trainer (needs the talent) | Frost | GEMETEN (DB2 + WH) |
| Pyroblast | Rank 6 | 12525 | 48 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |
| Arcane Blast | Rank 4 | 1239699 | 50 | trainer (needs the talent) | Arcane | GEMETEN (DB2 + WH) |
| Cone of Cold | Rank 4 | 10160 | 50 | trainer | Frost | GEMETEN (DB2 + WH) |
| Conjure Water | Rank 6 | 10139 | 50 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Ward | Rank 4 | 10223 | 50 | trainer | Fire | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 9 | 10180 | 50 | trainer | Frost | GEMETEN (DB2 + WH) |
| Frostfire Bolt | Rank 2 | 1237312 | 50 | trainer | Fire | GEMETEN (DB2 + WH) |
| Ice Armor | Rank 3 | 10219 | 50 | trainer | Frost | GEMETEN (DB2 + WH) |
| Portal: Darnassus | - | 11419 | 50 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Portal: Thunder Bluff | - | 11420 | 50 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Teleport: Dalaran | - | 1297659 | 50 | no source on WH | Arcane | level/tab GEMETEN (DB2); source unknown |
| Blast Wave | Rank 4 | 13020 | 52 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |
| Blizzard | Rank 5 | 10186 | 52 | trainer | Frost | GEMETEN (DB2 + WH) |
| Conjure Food | Rank 6 | 10145 | 52 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Frost Ward | Rank 4 | 10177 | 52 | trainer | Frost | GEMETEN (DB2 + WH) |
| Ice Barrier | Rank 3 | 13032 | 52 | trainer (needs the talent) | Frost | GEMETEN (DB2 + WH) |
| Mana Shield | Rank 5 | 10192 | 52 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Scorch | Rank 6 | 10206 | 52 | trainer | Fire | GEMETEN (DB2 + WH) |
| Amplify Magic | Rank 4 | 10170 | 54 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Explosion | Rank 6 | 10202 | 54 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Blast | Rank 7 | 10199 | 54 | trainer | Fire | GEMETEN (DB2 + WH) |
| Fireball | Rank 10 | 10150 | 54 | trainer | Fire | GEMETEN (DB2 + WH) |
| Frost Nova | Rank 4 | 10230 | 54 | trainer | Frost | GEMETEN (DB2 + WH) |
| Pyroblast | Rank 7 | 12526 | 54 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |
| Arcane Brilliance | - | 23028 | 56 | drop/book (WH source 2) | Arcane | GEMETEN (DB2 + WH) |
| Arcane Intellect | Rank 5 | 10157 | 56 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Missiles | Rank 7 | 10212 | 56 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Arcane Missiles | Rank 8 | 25345 | 56 | drop/book (WH source 2) | Arcane | GEMETEN (DB2 + WH) |
| Flamestrike | Rank 6 | 10216 | 56 | trainer | Fire | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 10 | 10181 | 56 | trainer | Frost | GEMETEN (DB2 + WH) |
| Ice Lance | Rank 6 | 1240047 | 56 | trainer (needs the talent) | Frost | GEMETEN (DB2 + WH) |
| Cone of Cold | Rank 5 | 10161 | 58 | trainer | Frost | GEMETEN (DB2 + WH) |
| Conjure Mana Ruby | - | 10054 | 58 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Ice Barrier | Rank 4 | 13033 | 58 | trainer (needs the talent) | Frost | GEMETEN (DB2 + WH) |
| Mage Armor | Rank 3 | 22783 | 58 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Scorch | Rank 7 | 10207 | 58 | trainer | Fire | GEMETEN (DB2 + WH) |
| Arcane Blast | Rank 5 | 1239700 | 60 | trainer (needs the talent) | Arcane | GEMETEN (DB2 + WH) |
| Arcane Wrath | Rank 4 | 1326082 | 60 | trainer (needs the talent) | Arcane | GEMETEN (DB2 + WH) |
| Blast Wave | Rank 5 | 13021 | 60 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |
| Blizzard | Rank 6 | 10187 | 60 | trainer | Frost | GEMETEN (DB2 + WH) |
| Conjure Food | Rank 7 | 28612 | 60 | drop/book (WH source 2) | Arcane | GEMETEN (DB2 + WH) |
| Conjure Water | Rank 7 | 10140 | 60 | quest (WH source 4) | Arcane | GEMETEN (DB2 + WH) |
| Conjure Water | Rank 8 | 468766 | 60 | no source on WH | Arcane | level/tab GEMETEN (DB2); source unknown |
| Dampen Magic | Rank 5 | 10174 | 60 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Fire Ward | Rank 5 | 10225 | 60 | trainer | Fire | GEMETEN (DB2 + WH) |
| Fireball | Rank 11 | 10151 | 60 | trainer | Fire | GEMETEN (DB2 + WH) |
| Fireball | Rank 12 | 25306 | 60 | drop/book (WH source 2) | Fire | GEMETEN (DB2 + WH) |
| Frost Ward | Rank 5 | 28609 | 60 | drop/book (WH source 2) | Frost | GEMETEN (DB2 + WH) |
| Frostbolt | Rank 11 | 25304 | 60 | drop/book (WH source 2) | Frost | GEMETEN (DB2 + WH) |
| Frostfire Bolt | Rank 3 | 1237313 | 60 | trainer | Fire | GEMETEN (DB2 + WH) |
| Ice Armor | Rank 4 | 10220 | 60 | trainer | Frost | GEMETEN (DB2 + WH) |
| Mana Shield | Rank 6 | 10193 | 60 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Polymorph | Pig | 28272 | 60 | quest (WH source 4) | Arcane | GEMETEN (DB2 + WH) |
| Polymorph | Rank 4 | 12826 | 60 | trainer | Arcane | GEMETEN (DB2 + WH) |
| Polymorph | Turtle | 28271 | 60 | drop/book (WH source 2) | Arcane | GEMETEN (DB2 + WH) |
| Polymorph: Cow | - | 28270 | 60 | no source on WH | Arcane | level/tab GEMETEN (DB2); source unknown |
| Pyroblast | Rank 8 | 18809 | 60 | trainer (needs the talent) | Fire | GEMETEN (DB2 + WH) |

### Talent actives (GEMETEN: DB2 tree 1112; levels AFGELEID by the row rule)

| Talent | ID | Section, row | Earliest level | Later ranks |
|---|---|---|---|---|
| Arcane Blast | 400574 | Arcane, row 3 | 20 | trainer R2-R5 at 30/40/50/60 (new IDs 1239696, 1239697, 1239699, 1239700) |
| Pyroblast | 11366 | Fire, row 3 | 20 | trainer R2-R8 at 24/30/36/42/48/54/60 |
| Ice Lance | 1312002 (new ID) | Frost, row 3 | 20 | trainer R2 400640 at 28, R3-R6 at 34/42/48/56 |
| Arcane Wrath (new spell) | 1326079 | Arcane, row 4 | 25 (DB2 SpellLevel also 25) | trainer R2-R4 at 36/48/60 |
| Ice Block | 11958 | Frost, row 4 | 25 (DB2 SpellLevel says 4: stale) | one rank |
| Presence of Mind | 12043 | Arcane, row 5 | 30 | one rank |
| Blast Wave | 11113 | Fire, row 5 | 30 | trainer R2-R5 at 36/44/52/60 |
| Cold Snap | 12472 | Frost, row 5 | 30 | one rank |
| Arcane Power | 12042 | Arcane, row 7 | 40 | one rank |
| Combustion | 11129 | Fire, row 7 | 40 | one rank |
| Ice Barrier | 11426 | Frost, row 7 | 40 | trainer R2-R4 at 46/52/58 |

Prerequisite edges in the tree (TraitEdge type 2, GEMETEN): Arcane Blast -> Arcane Wrath, Presence of Mind -> Arcane Power,
Pyroblast -> Heating Up, Critical Mass -> Combustion, Ice Lance -> Fingers of Frost, Cold Snap -> Ice Barrier,
Arcane Concentration -> Arcane Meditation. New passive nodes (from Season of Discovery runes): Missile Barrage 400588,
Heating Up 400624, Fingers of Frost 400647.

Point math (AFGELEID from GEMETEN numbers: row 7 needs 30 points in its section, 51 points in total): a mage can have
**only one** row-7 talent (two would need 62 points). So Arcane Power and Combustion can never both be known. Row 5
needs 20 in a section, so at most two of Presence of Mind / Blast Wave / Cold Snap.

### Racials of the races that can be a Mage in Forever

CharBaseInfo 70790, ClassID 8 (GEMETEN): **Human, Orc, Undead, Gnome, Troll, High Order Skyborne** (race 95).
Era 1.15.9 has only Human, Undead, Gnome, Troll, so **Orc and Skyborne mages are new**. The other Skyborne
(Windshaper, race 96) cannot be a Mage. Active racials (SkillLineAbility, AcquireMethod 2, GEMETEN; descriptions from
Spell.csv):

| Race | Active racials (ID, cooldown) | What it does (DB2 text, short) |
|---|---|---|
| Human | Perception 20600 (3 min); **Will to Survive** 1259718 (3 min, new) | stealth detection; removes all stuns |
| Orc | **Blood Fury** 20572 (2 min); Shatter Curse 1299026 (3 min, new) | +AP and spell power; removes curses + less magic damage |
| Undead | **Will of the Forsaken** 7744 (2 min); Cannibalize 20577 (2 min) | removes charm/fear/sleep; eat corpse for health+mana |
| Gnome | Escape Artist 20589 (2 min); **Eureka!** 1259817 (2 min, Mage version, ClassMask 128) | escape roots/snares; less mana cost + more damage |
| Troll | **Berserking** 20554 (3 min); Rapid Regeneration 1260270 (3 min, new) | cast/attack speed; regen health, cancels on action |
| High Order Skyborne | **Read Leyline** 1259705 (2 min); Walk on Air 1259416 (90 s) | health+mana regen (more near a leyline); glide downward |

(Skyborne race bits, GEMETEN in ChrRaces: High Order = PlayableRaceBit 32, Windshaper = 33. Read Leyline has RaceMasks_1 = 1
(High Order), Skysight = 2 (Windshaper), Walk on Air = 3 (both).) In **bold** = my pick for Shift-E (AFGELEID).

### Not learnable, removed, or not a button

- **Season of Discovery rune spells** are still in the Mage skill lines but have AcquireMethod 3 (the Druid researcher
  read 3 as "never learned"): Arcane Barrage, Arcane Surge, Balefire Bolt, Fire Blast 400616-400623, Frozen Orb, Icy Veins,
  Living Bomb, Living Flame, Mass Regeneration, Regeneration, Rewind Time, Spellfrost Bolt. Also 42 rows in SkillLine
  2851 (Engraving, "Engrave ..." rune spells) carry the Mage class bit. GEMETEN that the rows have AcquireMethod 3 / are Engraving; "not learnable" is AFGELEID.
- **Detect Magic (2855) is gone**: its SkillLineAbility row (5046) is still there, but 70790 has no SpellName and no Spell
  row for 2855. Era 1.15.9 names it Detect Magic, level 16. GEMETEN.
- Proc/effect spells that are "active" in SpellMisc but are not buttons (not in the WH list either): Chilled 12484,
  Frostbite 12494, Impact 12355, Clearcasting 12536, Master of Elements 29077, Magic Absorption 29442,
  Fire Vulnerability 22959, Felfire 24530. Left out (AFGELEID that they are not buttons).
- No WH source, probably not learnable (AFGELEID): **Polymorph: Cow** 28270, **Conjure Water Rank 8** 468766 (an SoD
  rank). Both are in the table with "no source on WH". Teleport: Dalaran also has no WH source, but it is new and
  clearly meant to be learned (see below).

### What Forever changed for the Mage (only what the data shows)

- New spells (in Forever's Mage skill lines, not in Era's; GEMETEN): Ice Lance R1 1312002 (talent) and R3-R6,
  **Arcane Wrath** R1-R4 (new spell: "Launches a projectile of pure Arcane energy ... gains additional Spell Damage equal
  to $s2% of your maximum Mana", 6 s cooldown), Arcane Blast R2-R5, Frostfire Bolt R2-R3, **Teleport: Dalaran** 1297659.
- SoD rune spells turned into normal spells (Era level 1 + AcquireMethod 3 -> Forever, GEMETEN): Arcane Blast 400574
  (now talent, level 20), Frostfire Bolt 401502 (trainer, level 40), Ice Lance 400640 (trainer rank 2, level 28).
- **Teleport: Dalaran** (level 50): its SkillLineAbility race mask is the same Alliance mask as Teleport: Stormwind
  (GEMETEN), and WH lists the races Human, Dwarf, Night Elf, Gnome, High Order Skyborne. So in this build only
  Alliance mages get it. Needs a Rune of Teleportation (WH tooltip). How it is learned: unknown.
- **New Mage-only skill line "Comprehension"** (SkillLine 3012; SkillRaceClassInfo ClassMask 128, MinLevel 6; GEMETEN):
  Comprehend Scroll 1296017 ("Decipher an untranslated scroll", 5 yd interact; WH: taught by 24 NPCs, e.g. Anastasia Hartwell, Archmage Shymm, Bink) and
  Study 1302508 ("Perform spell research, resulting in a bundle of scrolls. Requires a suitable library", 6 s cast, 1 h
  cooldown). Both level 6. Out-of-combat tools -> block D.
- Fire Ward and Frost Ward share SpellCategories Category 56 with a 30 s category cooldown (GEMETEN), so one ward at a
  time. Presence of Mind and Combustion both have Category 1151 (180 s); you cannot have both talents anyway.
- WH "envChange" labels (GEMETEN on WH, not checked further): most damage spells "values_changed"; Arcane Intellect
  "longer_duration"; Cone of Cold "shorter_duration"; Ice Lance R2 and Frostfire Bolt R1 "trained_later".

## States + conditions

**The Mage has no state at all. One macro per key, no conditions.** (GEMETEN where stated.)

1. **DB2:** no Mage spell has EffectAura 36 (shapeshift), while Cat Form 768 and Bear Form 5487 do (positive control).
   There are 0 SpellShapeshift rows for Mage spells. SpellShapeshiftForm 70790 has Cat, Tree, Travel, Aquatic, Bear,
   Dire Bear, Battle/Defensive/Berserker Stance, Stealth, Moonkin, Shadowform, Ghost Wolf and creature forms: no Mage form.
2. **UI (forever branch):** `ActionBarController_UpdateAll` (lines 160-171) only pages the main bar to
   `C_ActionBar.GetBonusBarIndex()` when `C_ActionBar.HasBonusActionBar()` is true, i.e. when a form/stance/stealth gives a
   bonus bar. Vehicle, override and temporary-shapeshift bars (quest transformations) are the same for every class.
3. **EUI:** `EllesmereUI.CLASS_PAGING_STATES` has DRUID, ROGUE, WARRIOR (+ Berserker on Forever) and EVOKER; no MAGE
   (VisibilityRules.lua lines 61-85). On Forever it pages bar 1 by `[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;
   [bonusbar:4] 10` for every class (Paging.lua lines 128-132 and 199-203). For a Mage none of these can ever be true
   (AFGELEID from 1 and 2).

So `states = {}` and no `baseGuard`. The engine handles that: `Body()` loops over `cls.states or {}` and only adds a guard
when a guarding state has a spell (ForeverBlock.lua lines 117-131, read). Not a state: Ice Block (you cannot cast while in
it; the macro just does nothing) and Evocation (a channel).

## Proposal per key

Rules used: Rob's four rules; the block's fixed tasks (KeyBlock.lua BLOCK); for a class without forms MH's own overflow
order puts extra spells on **Ctrl-1, Ctrl-2, Ctrl-3 first** (KeyBlock.lua line 115, GEMETEN). The Mage has more actives
(33 spells for the 33 free places, plus buffs and travel) than any table so far, so several places are judgment calls,
marked AFGELEID. Level = earliest level the spell is there (`*` = talent).

Fixed, not spells: T potion, Shift-T healthstone, G trinket.

| Key | Task | Spell (base; no states) | Level | Why / note |
|---|---|---|---|---|
| 1 | main button | Fireball | 1 | starting spell, like the Druid's Wrath on 1 |
| 2 | rotation | Frostbolt | 4 | |
| 3 | rotation | Arcane Missiles | 8 | |
| 5 | rotation | Fire Blast | 6 | instant, 8 s cooldown |
| 4 | spender | Pyroblast | 20* | big hitter; Heating Up shortens it. AFGELEID |
| Shift-4 | 2nd / AoE spender | Flamestrike | 16 | KeyBlock calls this place AOESPEND. AFGELEID |
| Shift-1 | AoE | Blizzard | 20 | like the Druid's Hurricane |
| Shift-2 | AoE | Arcane Explosion | 14 | |
| Ctrl-1 | (no forms) overflow | Scorch | 22 | MH overflow order. AFGELEID |
| Ctrl-2 | (no forms) overflow | Arcane Blast | 20* | AFGELEID |
| Ctrl-3 | (no forms) overflow | Frostfire Bolt | 40 | AFGELEID |
| Q | big cooldown | Arcane Power, else Combustion | 40* | never both (point math) |
| F1 | cd2 | Evocation | 20 | mana cooldown, like the Druid's Innervate on F1 |
| Shift-3 | cd3 | Presence of Mind | 30* | |
| F3 | cd4 | Blast Wave | 30* | 45 s cooldown. AFGELEID |
| Shift-F1 | cd2b | Arcane Wrath | 25* | 6 s cooldown nuke, like the Druid's Swiftmend there. AFGELEID |
| E | interrupt | Counterspell | 24 | |
| R | movement | Blink | 20 | |
| Shift-R | movement 2 | Slow Fall | 12 | the only other movement spell. AFGELEID |
| F | taunt/help | Ice Lance | 20* | Mage has no taunt; retail MH also puts a Mage spell (Spellsteal) on F. AFGELEID |
| Z | small defensive | Mana Shield | 20 | |
| X | defensive 2 | Ice Barrier | 40* | |
| C | big defensive | Ice Block | 25* | same as retail MH (C = Ice Block) |
| Shift-C | big defensive 2nd row | Cold Snap | 30* | resets Ice Block: "a second Ice Block". AFGELEID |
| F2 | quick heal | Frost Ward | 22 | Mage has no heal; a ward is damage you do not take. AFGELEID |
| F4 | heal over time | Fire Ward | 20 | same reason; shares its 30 s cooldown with Frost Ward. AFGELEID |
| V | CC | Frost Nova | 10 | root, like the Druid's Entangling Roots on V; retail MH V = Frost Nova |
| Shift-Q | CC | Polymorph | 8 | long CC, like the Druid's Hibernate on Shift-Q |
| Shift-F | CC | Cone of Cold | 26 | slow + damage. AFGELEID |
| Shift-V | dispel | Remove Lesser Curse | 18 | same job as the Druid's Remove Curse on Shift-V |
| Shift-Z | 2nd row (Druid: own buff) | Ice Armor, else Frost Armor | 1 | like Thorns; that Ice Armor (30) replaces Frost Armor (last rank 20) is AFGELEID |
| Shift-X | 2nd row (Druid: group buff) | Arcane Brilliance, else Arcane Intellect | 1 | like Gift over Mark |
| Shift-E | racial | Blood Fury / Berserking / Eureka! / Will of the Forsaken / Will to Survive / Read Leyline | 1 | the race's own one wins; the other racial goes to block D |

All 33 non-fixed places are used.

**Block D (player's own bar; MH only names them):** Mage Armor (no place left, see open question 3), Amplify Magic,
Dampen Magic, Conjure Water, Conjure Food, Conjure Mana Agate/Jade/Citrine/Ruby, all Teleports and Portals (incl.
Teleport: Dalaran), Polymorph: Cow (if it is ever learnable), Comprehend Scroll, Study, and the second racial (Perception,
Shatter Curse, Cannibalize, Escape Artist, Rapid Regeneration, Walk on Air). An Alliance Mage at 60 has about 19 of these
for 12 block-D places (count AFGELEID), so not all fit.

**Listed (counted as handled, no key):** Shoot (wand). See open question 7.

Polymorph Pig (28272) and Turtle (28271) have the same SpellName "Polymorph" as the ranks (GEMETEN), so the table cannot
name them apart. See open question 6.

## Draft Lua table (for review; NOT in the repo)

```lua
ns.FOREVER_BLOCK_CLASSES.MAGE = {
	-- No forms, stances or stealth (DB2: no Mage spell has a shapeshift aura). No states, so no baseGuard.
	states = {},
	keys = {
		["1"] = { base = "Fireball" },
		["2"] = { base = "Frostbolt" },
		["3"] = { base = "Arcane Missiles" },
		["4"] = { base = "Pyroblast" },
		["5"] = { base = "Fire Blast" },
		["SHIFT-4"] = { base = "Flamestrike" },
		["SHIFT-1"] = { base = "Blizzard" },
		["SHIFT-2"] = { base = "Arcane Explosion" },
		["CTRL-1"] = { base = "Scorch" },
		["CTRL-2"] = { base = "Arcane Blast" },
		["CTRL-3"] = { base = "Frostfire Bolt" },
		["Q"] = { base = { "Arcane Power", "Combustion" } },
		["F1"] = { base = "Evocation" },
		["SHIFT-3"] = { base = "Presence of Mind" },
		["F3"] = { base = "Blast Wave" },
		["SHIFT-F1"] = { base = "Arcane Wrath" },
		["E"] = { base = "Counterspell" },
		["R"] = { base = "Blink" },
		["SHIFT-R"] = { base = "Slow Fall" },
		["F"] = { base = "Ice Lance" },
		["Z"] = { base = "Mana Shield" },
		["X"] = { base = "Ice Barrier" },
		["C"] = { base = "Ice Block" },
		["SHIFT-C"] = { base = "Cold Snap" },
		["F2"] = { base = "Frost Ward" },
		["F4"] = { base = "Fire Ward" },
		["V"] = { base = "Frost Nova" },
		["SHIFT-Q"] = { base = "Polymorph" },
		["SHIFT-F"] = { base = "Cone of Cold" },
		["SHIFT-V"] = { base = "Remove Lesser Curse" },
		["SHIFT-Z"] = { base = { "Ice Armor", "Frost Armor" } },
		["SHIFT-X"] = { base = { "Arcane Brilliance", "Arcane Intellect" } },
		["SHIFT-E"] = { base = { "Blood Fury", "Berserking", "Eureka!", "Will of the Forsaken", "Will to Survive",
			"Read Leyline" } },
	},
	toBlockD = {
		"Mage Armor", "Amplify Magic", "Dampen Magic",
		"Conjure Water", "Conjure Food", "Conjure Mana Agate", "Conjure Mana Jade", "Conjure Mana Citrine",
		"Conjure Mana Ruby",
		"Teleport: Stormwind", "Teleport: Ironforge", "Teleport: Darnassus", "Teleport: Dalaran",
		"Teleport: Orgrimmar", "Teleport: Undercity", "Teleport: Thunder Bluff",
		"Portal: Stormwind", "Portal: Ironforge", "Portal: Darnassus",
		"Portal: Orgrimmar", "Portal: Undercity", "Portal: Thunder Bluff",
		"Polymorph: Cow", "Comprehend Scroll", "Study",
		"Perception", "Shatter Curse", "Cannibalize", "Escape Artist", "Rapid Regeneration", "Walk on Air",
	},
	listed = { "Shoot" },
}
```

Checks done on this draft (GEMETEN): all names exist in SpellName 70790; every key name is a BLOCK key in KeyBlock.lua
(`SHIFT-F1`, `CTRL-1` etc. written as there); 33 keys = the 33 non-fixed places of blocks A-C; no spell is on two keys
(script `s10_build.py`); `luac -p` on the extracted table (`mage_work\draft_mage.lua`) passes, and a deliberately broken
file fails, so the check works. Not done: I did not run it through the engine or the offline test (`test_druid.lua` style). Most names also have NPC
namesakes in SpellName (e.g. 64 other "Fireball" rows); for the Druid that did not matter (Rob measured
`C_Spell.GetSpellInfo("Wrath")` = his 5177), but it is only measured for that one name.

## Open questions for Rob

1. **Tree-neutral or build-first?** I put the trainer basics every Mage has on 1/2/3/5 (Fireball, Frostbolt, Arcane
   Missiles, Fire Blast) and the talent nukes on 4 (Pyroblast), F (Ice Lance), Ctrl-2 (Arcane Blast), Shift-F1 (Arcane
   Wrath). A Frost or Arcane Mage would rather have Ice Lance / Arcane Blast on a main key. Keep it neutral, or one table
   per talent direction? (A table per build is not something the engine has now.)
2. **F, F2, F4.** The Mage has no taunt and no heal. I used them (Ice Lance on F, Frost Ward on F2, Fire Ward on F4) because
   otherwise talent spells get no place (your rule 4). Alternative: leave them empty like retail MH does for the Mage
   (`KeybindRoles_Mage.lua` lines 41-42: F2/F3 stay empty) and put the wards on block D.
3. **Mage Armor has no place.** Shift-Z holds Ice/Frost Armor (like Thorns), Shift-X Arcane Intellect (like Mark of the
   Wild). Mage Armor is the other armor (only one can be active, DB2 text) and went to block D. Alternative: Mage Armor on
   Shift-Z and Ice/Frost Armor on block D, or a switch for the player (your "players choose" idea).
4. **Arcane Brilliance over Arcane Intellect**, as Gift over Mark. Brilliance has WH source 2 (drop/book) at 56. In
   Classic it needs a reagent; I did not check reagents in Forever (SpellReagents not fetched).
5. **Racial on Shift-E**: my picks are in bold in the racial table (Gnome: Eureka! over Escape Artist; Orc: Blood Fury over
   Shatter Curse; Skyborne: Read Leyline over Walk on Air). Each race now has two active racials.
6. **Polymorph Pig/Turtle:** they share the name "Polymorph" with the ranks. What `/cast Polymorph` casts once Pig or Turtle is
   learned is not measured. Test in game on a mage that has one: `/dump C_Spell.GetSpellInfo("Polymorph")`.
7. **Shoot (wand):** Mages wand a lot while levelling. It is now only "listed" (like the Druid's Attack). Should it get a key?
8. **Teleport: Dalaran** is Alliance-only in this build and has no known source. Horde Mages will not see it.
9. **Evocation:** F1 (like Innervate, my pick) or F4 ("recuperate")?
10. **Slow Fall on Shift-R** (movement 2) is a stretch; it is the only candidate.
11. **Talented perk:** talent rows may open up to 5 levels earlier with it (see Legend). This touches every class's
    talent levels, not only the Mage.

## What is GEMETEN vs AFGELEID

**GEMETEN** (seen in a named, dated source):
- Every row of the spell table: name, rank, ID, level, tab (DB2 70790, 5 Nov 2026); the "How learned" column from WH
  Forever (5 Nov 2026) for all non-talent rows; starting spells from DB2 AcquireMethod 2.
- Talent tree 1112: its 11 active spells, their sections and rows, the row requirements (5/10/.../30), the 51 points, the
  1 point per level from 10, the edges, and the "Talented" text and rows.
- Race-class combos (CharBaseInfo 70790 vs Era 1.15.9), racial spells and their race masks and cooldowns.
- Detect Magic gone; SoD rune rows with AcquireMethod 3; new spells vs Era; Teleport: Dalaran race mask and WH race list;
  Comprehension skill line and WH data for Comprehend Scroll and Study.
- Fire Ward / Frost Ward share Category 56 (30 s).
- No Mage form/stance/stealth in DB2 (with positive control), the forever UI paging code, and EllesmereUI's state list.
- The MH engine and block facts quoted (file + line).

**AFGELEID** (reasoned):
- Earliest talent levels (row rule; also shifted by "Talented").
- "trainer (needs the talent)" for later talent ranks.
- That AcquireMethod 3 means not learnable; that Polymorph: Cow and Conjure Water R8 are not learnable.
- That the SkillLine is the spellbook tab.
- That a Mage can have only one row-7 talent (math on the measured numbers), so the Q list is safe.
- That Cold Snap resets Ice Block (description says "all your other Frost spells"; Ice Block is in the Frost tab).
- Every key choice marked AFGELEID in the proposal, the racial picks, and the block-D count.
- That the namesakes in SpellName will not break the name lookup (only measured for "Wrath").
