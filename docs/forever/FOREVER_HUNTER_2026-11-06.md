# WoW Forever — Hunter: spells tot 60 + VOORSTEL voor het toetsenblok

> 🌙 **Nacht 5→6 nov 2026, onderzoek door mh-research (één helper per class). NIET goedgekeurd door Rob, NIET in de
> addon.** Alleen een goedgekeurde tabel komt in `Modules/ForeverBlock_<Class>.lua`.
>
> **Zelf nagekeken in de nacht (GEMETEN):**
> - beginspells staan in Blizzards data met AcquireMethod 2: Auto Shot 75, Raptor Strike 2973 (wago wowf 1.60.1.70790, SkillLineAbility);
> - de concepttabel hieronder laadt in de échte motor (`Modules/ForeverBlock.lua`, offline met nagebootste spells):
>   elke spellnaam bestaat in SpellName, elke toets is een blok-plek, geen spell op twee toetsen;
> - stance/vorm-nummers: SpellShapeshiftForm.BonusActionBar (Cat 1, Bear 3, Stealth 1, Battle 1, Defensive 2,
>   Berserker 3, Moonkin/Shadowform/Ghost Wolf 0).
> - Niet in het spel getest. Elke toetskeuze is een voorstel (AFGELEID).
> - Voor alle classes geldt (helpers, GEMETEN in de data): een account-perk 'Talented' geeft al talentpunten vanaf
>   level 5-9, dus talent-levels hieronder kunnen tot 5 levels vroeger zijn.

**Aandachtspunten van de nachtcontrole:**
- Toets 1 (Auto Shot) moet `bang = true` krijgen (de motor kan dat sinds deze nacht: `/cast !Auto Shot`, dan zet een tweede druk hem niet uit). Staat nog niet in de concepttabel hieronder.

---

# WoW Forever Hunter: spells 1-60, states and a key-block proposal (client 1.60.1.70790)

Researched on the night of 5 Nov 2026. Read only: nothing in the repo was changed.
G = GEMETEN (seen in a named, dated source). A = AFGELEID (reasoned).

Short version:
- The Hunter has **no state at all**. No form, no stance, no stealth, no bar paging. So the table has `states = {}` and
  every key has one job (G for the data, A for the conclusion; see "States").
- The Hunter has more buttons than the block has places (33 spell keys). The draft keeps every talent on a fixed key
  (rule 4) and both level-1 spells on easy keys. 11 class spells and the second racial go to block D.
- Melee and ranged cannot share a key: WoW has no macro condition for distance (A). So melee spells get their own keys.

## Sources

| Source | What | Date |
|---|---|---|
| wago.tools DB2, product `wowf`, build **1.60.1.70790** | the scratchpad copy in `wago_wowf\` (README: fetched 5 Nov 2026 about 23:25). Plus my own curl fetches for the same build: `SkillLineXTraitTree`, `CharBaseInfo`, `ChrRaces` | 5 Nov 2026 |
| wago.tools DB2, Classic Era **1.15.9.70576** | `SkillLineAbility`, `SpellLevels`, `CharBaseInfo`, `SpellName` (to name the removed IDs), to compare | 5 Nov 2026 |
| wago.tools DB2, Forever **1.60.1.70707** | `TraitDefinition`, to check older talent trees | 5 Nov 2026 |
| Wowhead Forever, `wowhead.com/forever/spells/abilities/hunter` | the page's own listview data (312 rows), read with JavaScript in my own in-app browser tab (tab closed afterwards). Fields used: `source` (6 trainer, 4 quest, 2 drop/book), `level`, `envChange` (Wowhead's "changed vs Classic" notes) | 5 Nov 2026 |
| Zygor Forever, `E:\World of Warcraft\_forever_\Interface\AddOns\ZygorGuidesViewerForever\Data-Forever\Skill_Training.lua` lines 5-212 (HUNTER) | trainer list per level. It is **older than the live build**: it says Aimed Shot ranks need "talent=19434", but 19434 is in no talent tree in 70707 or 70790 (G, TraitDefinition) | file on disk |
| Blizzard UI source, `github.com/Gethe/wow-ui-source`, branch `forever`, head commit "1.60.1 (70790)" of 2026-11-04 18:16 UTC | `Blizzard_ActionBarController/ActionBarController.lua` lines 145-182, `Blizzard_ActionBar/Shared/StanceBar.lua`, `Blizzard_Minimap/Camelot/MinimapTrackingButton.lua` | fetched 5 Nov 2026 |
| EllesmereUI, `E:\World of Warcraft\_forever_\Interface\AddOns\EllesmereUIActionBars\EUI_ActionBars_Paging.lua` lines 108-132 and 197-209 | bar paging per class | file on disk |
| MH engine (read only): `Modules\ForeverBlock.lua` (header and `Body()`, lines 1-138), `Modules\ForeverBlock_Druid.lua`, `Modules\KeyBlock.lua` lines 22-107 | table format and the fixed key tasks | repo on disk |
| Rob's Forever key bindings: `E:\World of Warcraft\_forever_\WTF\Account\JOEYWHATEVER\bindings-cache.wtf` | which keys the block uses now | file on disk |

Not read: anything under `MidnightHelper\docs\` (my own agent rule). So I did not open the Druid plan or spell list in
`docs\`. For the shape of the spell list I used the scratchpad copy `forever_druid_spells.md`.

All scripts and raw outputs are in `...\scratchpad\forever_classes\hunter_work\` (`extract.py`, `talents.py`,
`compare.py`, `forms.py`, `details.py`, `details2.py`, `verify_names.py`, `gen_table.py` and their `*_out` files).

## Positive control

- **Level-1 starting spells (G, DB2 70790 SkillLineAbility, AcquireMethod 2):** Auto Shot 75 (Marksmanship) and
  Raptor Strike Rank 1 2973 (Survival). These are the only AcquireMethod-2 rows in the three hunter skill lines
  (50 Beast Mastery, 51 Survival, 163 Marksmanship). Wowhead Forever lists both at level 1 with no trainer source.
  Track Beasts 1494 is the only trainer spell at level 1 (G: WH source 6, 10 copper; Zygor level 1).
- **The class and spec (G):** ChrClasses ID 3 = Hunter (`HUNTER`). ChrSpecialization 1485 = "Hunter", ClassID 3: one spec.
- **The talent tree (G):** SkillLineXTraitTree ID 159 links SkillLine 50 (Beast Mastery) to TraitTree 1091. Its 52
  nodes sit in three sections (TraitNodeGroupDisplayInfo: 50 Beast Mastery, 163 Marksmanship, 51 Survival).
- **My filters find what must be there (G):** the shapeshift check finds aura 36 on Battle Stance 2457, Cat Form 768
  and Bear Form 5487, and finds it on 0 of the 379 hunter skill-line spells. The name check finds all 72 names of the
  draft in SpellName.csv; its one "MISSING" (Beast Training) is correct, because Beast Training 5149 sits on skill
  line 261 and not on the three hunter tabs. The TraitDefinition grep finds Sniper Shot 1310687 and Trueshot Aura
  1299346, and does not find Aimed Shot 19434.

## Spell list (levels 1-60, active spells only)

Legend:
- Level with `*` = talent. The number is the earliest level for that row: each row needs 5 more points in that section
  (TraitCond, G), and there is 1 point per level from level 10 (TraitCurrencySource "Level 10" ... "Level 60", G).
  So "row needs N points" = level 10 + N. That rule is **A**, the same rule the Druid list used.
  Watch out: TraitCurrencySource also has "Talented Rank 1-5" rows that give an extra point at levels 9, 8, 7, 6 and 5
  (G). They come from the spell "Talented" 1225474 in TraitTree 1188 (TraitSystem 45). I did not find out how a player
  gets them. If a player has them, every talent comes up to 5 levels earlier (A).
- "Kind": melee = range index 2 or "on next swing"; ranged shot = uses the ranged slot (SpellMisc Attributes_0 bit 0x2).
  The values are G, my reading of the bits is A.
- Tab = the skill line (spellbook tab). The Hunter has no form requirement on any spell (SpellShapeshift masks, G).
- "+WH" in "GEMETEN (DB2 + WH)" means Wowhead Forever lists the same ID at the same level, with the source shown.
- Pet abilities that you teach your pet (Growl, Claw, Bite, Cower, Dash, Dive, resistances, and the new family
  abilities Swipe, Pinch, Dismember, Tendon Rip, Mine!, Savage Rend, Web, Dust Cloud, WH "new") are pet spells.
  They are not player buttons, so they are not in this list.

| Spell | Rank | ID | Level | How learned | Tab | Kind | Measured? |
|---|---|---|---|---|---|---|---|
| Auto Shot | - | 75 | 1 | starting spell (DB2 AcquireMethod 2) | Marksmanship | ranged shot | GEMETEN (DB2 + WH level 1) |
| Raptor Strike | Rank 1 | 2973 | 1 | starting spell (DB2 AcquireMethod 2) | Survival | melee | GEMETEN (DB2 + WH level 1) |
| Track Beasts | - | 1494 | 1 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Aspect of the Monkey | - | 13163 | 4 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Serpent Sting | Rank 1 | 1978 | 4 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Arcane Shot | Rank 1 | 3044 | 6 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Hunter's Mark | Rank 1 | 1130 | 6 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Concussive Shot | - | 5116 | 8 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Raptor Strike | Rank 2 | 14260 | 8 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Aspect of the Hawk | Rank 1 | 13165 | 10 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Beast Training | - | 5149 | 10 | quest reward (teach spell 5300); not on the WH hunter list (skill line 261) | Beast Training | - | GEMETEN (DB2 teach spell); quest AFGELEID |
| Call Pet | - | 883 | 10 | quest reward (teach spell 1579) | Beast Mastery | - | GEMETEN (DB2 teach spell); quest AFGELEID |
| Dismiss Pet | - | 2641 | 10 | quest reward (teach spell 1579) | Beast Mastery | - | GEMETEN (DB2 teach spell); quest AFGELEID |
| Feed Pet | - | 6991 | 10 | quest reward (teach spell 1584,5300) | Beast Mastery | - | GEMETEN (DB2 teach spell); quest AFGELEID |
| Revive Pet | - | 982 | 10 | quest reward (teach spell 5300) | Beast Mastery | - | GEMETEN (DB2 teach spell); quest AFGELEID |
| Serpent Sting | Rank 2 | 13549 | 10 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Tame Beast | - | 1515 | 10 | quest (WH source 4; teach spell 1579) | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Track Humanoids | - | 19883 | 10 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Arcane Shot | Rank 2 | 14281 | 12 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Distracting Shot | Rank 1 | 20736 | 12 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Mend Pet | Rank 1 | 136 | 12 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Wing Clip | Rank 1 | 2974 | 12 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Eagle Eye | - | 6197 | 14 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Eyes of the Beast | - | 1002 | 14 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Scare Beast | Rank 1 | 1513 | 14 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Immolation Trap | Rank 1 | 13795 | 16 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Mongoose Bite | Rank 1 | 1495 | 16 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Raptor Strike | Rank 3 | 14261 | 16 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Aspect of the Hawk | Rank 2 | 14318 | 18 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Multi-Shot | - | 2643 | 18 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Serpent Sting | Rank 3 | 13550 | 18 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Track Undead | - | 19884 | 18 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Aimed Shot | Rank 1 | 19434 | 20 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Arcane Shot | Rank 3 | 14282 | 20 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Aspect of the Cheetah | - | 5118 | 20 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Deterrence | - | 19263 | 20* | TALENT (Survival section, row 3) | Survival | - | GEMETEN (DB2 tree 1091); level AFGELEID |
| Disengage | Rank 1 | 781 | 20 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Distracting Shot | Rank 2 | 14274 | 20 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Freezing Trap | Rank 1 | 1499 | 20 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Mend Pet | Rank 2 | 3111 | 20 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Hunter's Mark | Rank 2 | 14323 | 22 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Scorpid Sting | - | 3043 | 22 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Beast Lore | - | 1462 | 24 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Raptor Strike | Rank 4 | 14262 | 24 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Track Hidden | - | 19885 | 24 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Counterattack | Rank 1 | 19306 | 25* | TALENT (Survival section, row 4); DB2 SpellLevels says 30 | Survival | melee | GEMETEN (DB2 tree 1091); level AFGELEID |
| Summon Hawk | Rank 1 | 1293241 | 25* | TALENT (Beast Mastery section, row 4) | Beast Mastery | - | GEMETEN (DB2 tree 1091); level AFGELEID |
| Trueshot Aura | Rank 1 | 1299346 | 25* | TALENT (Marksmanship section, row 4) | Marksmanship | - | GEMETEN (DB2 tree 1091); level AFGELEID |
| Immolation Trap | Rank 2 | 14302 | 26 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Rapid Fire | - | 3045 | 26 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Serpent Sting | Rank 4 | 13551 | 26 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Track Elementals | - | 19880 | 26 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Aimed Shot | Rank 2 | 20900 | 28 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Arcane Shot | Rank 4 | 14283 | 28 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Aspect of the Hawk | Rank 3 | 14319 | 28 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Frost Trap | - | 13809 | 28 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Mend Pet | Rank 3 | 3661 | 28 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Aspect of the Beast | Rank 1 | 13161 | 30 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Counterattack | Rank 2 | 1242634 | 30 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Distracting Shot | Rank 3 | 15629 | 30 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Feign Death | - | 5384 | 30 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Intimidation | - | 19577 | 30* | TALENT (Beast Mastery section, row 5) | Beast Mastery | - | GEMETEN (DB2 tree 1091); level AFGELEID |
| Mongoose Bite | Rank 2 | 14269 | 30 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Scare Beast | Rank 2 | 14326 | 30 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Scatter Shot | - | 19503 | 30* | TALENT (Marksmanship section, row 5) | Marksmanship | ranged shot | GEMETEN (DB2 tree 1091); level AFGELEID |
| Strider Kick | - | 1317257 | 30* | TALENT (Survival section, row 5) | Survival | melee | GEMETEN (DB2 tree 1091); level AFGELEID |
| Flare | - | 1543 | 32 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Raptor Strike | Rank 5 | 14263 | 32 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Track Demons | - | 19878 | 32 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Trueshot Aura | Rank 2 | 1299348 | 32 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Disengage | Rank 2 | 14272 | 34 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Explosive Trap | Rank 1 | 13813 | 34 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Serpent Sting | Rank 5 | 13552 | 34 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Aimed Shot | Rank 3 | 20901 | 36 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Arcane Shot | Rank 5 | 14284 | 36 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Immolation Trap | Rank 3 | 14303 | 36 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Mend Pet | Rank 4 | 3662 | 36 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Summon Hawk | Rank 2 | 1293525 | 36 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Viper Sting | Rank 1 | 3034 | 36 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Aspect of the Hawk | Rank 4 | 14320 | 38 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Wing Clip | Rank 2 | 14267 | 38 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Aspect of the Beast | Rank 2 | 1299445 | 40 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Aspect of the Pack | - | 13159 | 40 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Bestial Wrath | - | 19574 | 40* | TALENT (Beast Mastery section, row 7) | Beast Mastery | - | GEMETEN (DB2 tree 1091); level AFGELEID |
| Distracting Shot | Rank 4 | 15630 | 40 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Freezing Trap | Rank 2 | 14310 | 40 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Hunter's Mark | Rank 3 | 14324 | 40 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Raptor Strike | Rank 6 | 14264 | 40 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Sniper Shot | Rank 1 | 1310687 | 40* | TALENT (Marksmanship section, row 7) | Marksmanship | ranged shot | GEMETEN (DB2 tree 1091); level AFGELEID |
| Track Giants | - | 19882 | 40 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Trueshot Aura | Rank 3 | 19506 | 40 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Volley | Rank 1 | 1510 | 40 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Counterattack | Rank 3 | 20909 | 42 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Serpent Sting | Rank 6 | 13553 | 42 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Aimed Shot | Rank 4 | 20902 | 44 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Arcane Shot | Rank 6 | 14285 | 44 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Explosive Trap | Rank 2 | 14316 | 44 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Mend Pet | Rank 5 | 13542 | 44 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Mongoose Bite | Rank 3 | 14270 | 44 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Aspect of the Wild | Rank 1 | 20043 | 46 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Immolation Trap | Rank 4 | 14304 | 46 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Scare Beast | Rank 3 | 14327 | 46 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Viper Sting | Rank 2 | 14279 | 46 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Aspect of the Hawk | Rank 5 | 14321 | 48 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Disengage | Rank 3 | 14273 | 48 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Raptor Strike | Rank 7 | 14265 | 48 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Sniper Shot | Rank 2 | 1310785 | 48 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Summon Hawk | Rank 3 | 1293526 | 48 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Aspect of the Beast | Rank 3 | 1299446 | 50 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Distracting Shot | Rank 5 | 15631 | 50 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Serpent Sting | Rank 7 | 13554 | 50 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Track Dragonkin | - | 19879 | 50 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Trueshot Aura | Rank 4 | 20905 | 50 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Volley | Rank 2 | 14294 | 50 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Aimed Shot | Rank 5 | 20903 | 52 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Arcane Shot | Rank 7 | 14286 | 52 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Mend Pet | Rank 6 | 13543 | 52 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Counterattack | Rank 4 | 20910 | 54 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Explosive Trap | Rank 3 | 14317 | 54 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Aspect of the Wild | Rank 2 | 20190 | 56 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Immolation Trap | Rank 5 | 14305 | 56 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Raptor Strike | Rank 8 | 14266 | 56 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Viper Sting | Rank 3 | 14280 | 56 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Aspect of the Hawk | Rank 6 | 14322 | 58 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Hunter's Mark | Rank 4 | 14325 | 58 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Mongoose Bite | Rank 4 | 14271 | 58 | trainer | Survival | melee | GEMETEN (DB2 + WH) |
| Serpent Sting | Rank 8 | 13555 | 58 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Sniper Shot | Rank 3 | 1310786 | 58 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Volley | Rank 3 | 14295 | 58 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Aimed Shot | Rank 6 | 20904 | 60 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Arcane Shot | Rank 8 | 14287 | 60 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Aspect of the Beast | Rank 4 | 1299447 | 60 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Aspect of the Hawk | Rank 7 | 25296 | 60 | book/drop (WH source 2) | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Distracting Shot | Rank 6 | 15632 | 60 | trainer | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Freezing Trap | Rank 3 | 14311 | 60 | trainer | Survival | - | GEMETEN (DB2 + WH) |
| Mend Pet | Rank 7 | 13544 | 60 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Serpent Sting | Rank 9 | 25295 | 60 | book/drop (WH source 2) | Marksmanship | ranged shot | GEMETEN (DB2 + WH) |
| Summon Hawk | Rank 4 | 1293527 | 60 | trainer | Beast Mastery | - | GEMETEN (DB2 + WH) |
| Tranquilizing Shot | - | 19801 | 60 | book/drop (WH source 2) | Beast Mastery | ranged shot | GEMETEN (DB2 + WH) |
| Trueshot Aura | Rank 5 | 20906 | 60 | trainer | Marksmanship | - | GEMETEN (DB2 + WH) |
| Wing Clip | Rank 3 | 14268 | 60 | trainer | Survival | melee | GEMETEN (DB2 + WH) |

141 active rows. Flags (not found on WH list): none

**Left out of the list (non-passive rows in the hunter skill lines that are not player buttons or not learnable):**

| ID | Spell | Rank | DB2 AcquireMethod | Why left out |
|---|---|---|---|---|
| 3674 | Black Arrow | Rank 1 | 0 | Black Arrow: not on the Wowhead Forever hunter list, not in Zygor trainer data |
| 14296 | Black Arrow | Rank 2 | 0 | Black Arrow R2: as R1 |
| 13535 | Tame Beast |  | 0 | Tame Beast internal part |
| 13481 | Tame Beast |  | 0 | Tame Beast internal part |
| 19185 | Entrapment |  | 0 | Entrapment effect |
| 13812 | Explosive Trap | Rank 1 | 0 | Explosive Trap effect spell |
| 14314 | Explosive Trap | Rank 2 | 0 | Explosive Trap effect |
| 14315 | Explosive Trap | Rank 3 | 0 | Explosive Trap effect |
| 23989 | Readiness |  | 3 | Readiness: AcquireMethod 3 (was 0 in Classic Era 70576) |
| 24529 | Spirit Bond |  | 0 | Spirit Bond aura (triggered) |
| 24406 | Improved Mend Pet |  | 0 | Improved Mend Pet effect |
| 13797 | Immolation Trap | Rank 1 | 0 | Immolation Trap effect spell |
| 14298 | Immolation Trap | Rank 2 | 0 | Immolation Trap effect |
| 14299 | Immolation Trap | Rank 3 | 0 | Immolation Trap effect |
| 14300 | Immolation Trap | Rank 4 | 0 | Immolation Trap effect |
| 14301 | Immolation Trap | Rank 5 | 0 | Immolation Trap effect |
| 409379 | Kill Command |  | 3 | Kill Command: AcquireMethod 3 (Season of Discovery rune) |
| 425737 | Serpent Sting | Rank 9 | 3 | AcquireMethod 3 (never learned) |
| 425736 | Serpent Sting | Rank 8 | 3 | AcquireMethod 3 (never learned) |
| 425735 | Serpent Sting | Rank 7 | 3 | AcquireMethod 3 (never learned) |
| 425734 | Serpent Sting | Rank 6 | 3 | AcquireMethod 3 (never learned) |
| 425733 | Serpent Sting | Rank 5 | 3 | AcquireMethod 3 (never learned) |
| 425732 | Serpent Sting | Rank 4 | 3 | AcquireMethod 3 (never learned) |
| 425730 | Serpent Sting | Rank 3 | 3 | AcquireMethod 3 (never learned) |
| 425729 | Serpent Sting | Rank 2 | 3 | AcquireMethod 3 (never learned) |
| 425728 | Serpent Sting | Rank 1 | 3 | AcquireMethod 3 (never learned) |
| 409433 | Chimera Shot |  | 3 | Chimera Shot: AcquireMethod 3 (SoD rune) |
| 409494 | Chimera Shot - Viper |  | 3 | SoD rune part |
| 409493 | Chimera Shot - Serpent |  | 3 | SoD rune part |
| 409495 | Chimera Shot - Scorpid |  | 3 | SoD rune part |
| 409755 | Raptor Strike | Rank 8 | 3 | AcquireMethod 3 (never learned) |
| 409754 | Raptor Strike | Rank 7 | 3 | AcquireMethod 3 (never learned) |
| 409752 | Raptor Strike | Rank 6 | 3 | AcquireMethod 3 (never learned) |
| 409751 | Raptor Strike | Rank 5 | 3 | AcquireMethod 3 (never learned) |
| 409750 | Raptor Strike | Rank 4 | 3 | AcquireMethod 3 (never learned) |
| 409748 | Raptor Strike | Rank 3 | 3 | AcquireMethod 3 (never learned) |
| 409693 | Raptor Strike | Rank 2 | 3 | AcquireMethod 3 (never learned) |
| 409691 | Raptor Strike | Rank 1 | 3 | AcquireMethod 3 (never learned) |
| 415343 | Raptor Strike | Rank 8 | 3 | AcquireMethod 3 (never learned) |
| 415342 | Raptor Strike | Rank 7 | 3 | AcquireMethod 3 (never learned) |
| 415341 | Raptor Strike | Rank 6 | 3 | AcquireMethod 3 (never learned) |
| 415340 | Raptor Strike | Rank 5 | 3 | AcquireMethod 3 (never learned) |
| 415338 | Raptor Strike | Rank 4 | 3 | AcquireMethod 3 (never learned) |
| 415337 | Raptor Strike | Rank 3 | 3 | AcquireMethod 3 (never learned) |
| 415336 | Raptor Strike | Rank 2 | 3 | AcquireMethod 3 (never learned) |
| 415335 | Raptor Strike | Rank 1 | 3 | AcquireMethod 3 (never learned) |
| 415320 | Flanking Strike |  | 3 | Flanking Strike: AcquireMethod 3 (SoD rune) |
| 425711 | Carve |  | 3 | Carve: AcquireMethod 3 (SoD rune) |
| 409580 | Heart of the Lion |  | 0 | Heart of the Lion: no source on Wowhead Forever, not in Zygor trainer data (SoD rune in Classic) |
| 415423 | Aspect of the Viper |  | 0 | Aspect of the Viper: no source on Wowhead Forever, not in Zygor trainer data (SoD rune in Classic) |
| 469145 | Aspect of the Falcon |  | 0 | Aspect of the Falcon: no source on Wowhead Forever, not in Zygor trainer data (SoD) |
| 1221404 | Enchanted Flare |  | 0 | Enchanted Flare: no source on Wowhead Forever, not in Zygor trainer data (SoD) |
| 24118 | Lacerate | Rank 1 | 0 | Lacerate: no source on Wowhead (status new); unclear how it is obtained |
| 24119 | Lacerate | Rank 2 | 0 | Lacerate |
| 24120 | Lacerate | Rank 3 | 0 | Lacerate |
| 1299332 | Lacerate | Rank 4 | 0 | Lacerate |
| 1310725 | Spirit Bond |  | 0 | Spirit Bond aura (no tooltip, triggered by the passive talent) |

### Talent tree 1091: the active talents (G, DB2 70790)

| Section | Row (points) | Talent | ID | Earliest level (A) | Later ranks (trainer) |
|---|---|---|---|---|---|
| Survival | 3 (10) | Deterrence | 19263 | 20 | - |
| Beast Mastery | 4 (15) | Summon Hawk | 1293241 | 25 | R2 1293525 (36), R3 1293526 (48), R4 1293527 (60) |
| Marksmanship | 4 (15) | Trueshot Aura | 1299346 | 25 | R2 1299348 (32), R3 19506 (40), R4 20905 (50), R5 20906 (60) |
| Survival | 4 (15) | Counterattack | 19306 | 25 (DB2 SpellLevels says 30) | R2 1242634 (30), R3 20909 (42), R4 20910 (54) |
| Beast Mastery | 5 (20) | Intimidation | 19577 | 30 | - |
| Marksmanship | 5 (20) | Scatter Shot | 19503 | 30 | - |
| Survival | 5 (20) | Strider Kick | 1317257 | 30 | - |
| Beast Mastery | 7 (30) | Bestial Wrath | 19574 | 40 | - |
| Marksmanship | 7 (30) | Sniper Shot | 1310687 | 40 | R2 1310785 (48), R3 1310786 (58) |

- All other nodes are passive (SpellMisc passive bit 0x40, G). Passives that change how buttons are used:
  Expose Prey 1310532 (Hunter's Mark can light up Mongoose Bite), Lacerating Strikes 1310533 (Mongoose Bite also
  bleeds), Lone Wolf 415370 (more damage while you have **no** pet), Focused Fire 1223755 (more damage while you have a
  pet), Rapid Killing 415405, Improved Stings 1310661 (Viper Sting cooldown shorter).
- TraitEdge links Deterrence (node 104986) to Counterattack (node 104989), G. That this is a hard requirement is A.
- Counterattack: the tree row says 15 points (level 25, A), but DB2 SpellLevels gives 30. Which one the game uses is
  not measured.

### Racials for the races that can be a Hunter in Forever

Races (G, DB2 CharBaseInfo 70790, class 3): Human (row 887), Orc, Dwarf, Night Elf, Tauren, Troll,
High Order Skyborne (race 95, row 888) and Windshaper Skyborne (race 96, row 891).
**Human Hunter and both Skyborne Hunters are new in Forever:** Classic Era 70576 CharBaseInfo has no such rows (G).
That a player can really pick them at character creation is A (only the DB2 row is measured).

| Race | Spell | ID | Kind | Cooldown (DB2) | Measured? |
|---|---|---|---|---|---|
| Tauren | War Stomp | 20549 | Racial | 90 s | GEMETEN (DB2) |
| Tauren | Cultivation | 20552 | Racial | 900 s | GEMETEN (DB2) |
| Troll | Berserking | 20554 | Racial | 180 s | GEMETEN (DB2) |
| Orc | Blood Fury | 20572 | Racial | 120 s | GEMETEN (DB2) |
| Night Elf | Shadowmeld | 20580 | Racial | 0 s | GEMETEN (DB2) |
| Dwarf | Find Treasure | 2481 | Racial | 0 s | GEMETEN (DB2) |
| Dwarf | Stoneform | 20594 | Racial | 180 s | GEMETEN (DB2) |
| Human | Perception | 20600 | Racial | 180 s | GEMETEN (DB2) |
| High Order Skyborne | Read Leyline | 1259705 | Racial | 120 s | GEMETEN (DB2) |
| both Skyborne | Walk on Air | 1259416 | Racial | 90 s | GEMETEN (DB2) |
| Windshaper Skyborne | Skysight | 1259686 | Racial | 120 s | GEMETEN (DB2) |
| Human | Will to Survive | 1259718 | Racial | 180 s | GEMETEN (DB2) |
| Night Elf | Elune's Light | 1259799 | Racial | 180 s | GEMETEN (DB2) |
| Orc | Shatter Curse | 1299026 | Racial | 180 s | GEMETEN (DB2) |
| Troll | Rapid Regeneration | 1260270 |  | 180 s | GEMETEN (DB2) |

- Racial spells are on the race skill lines (Human 754, Orc 125, Dwarf 101, Night Elf 126, Tauren 124, Troll 733,
  Skyborne 2980), all AcquireMethod 2 (starting), G. Skyborne: RaceMasks_1 = 1 is High Order only, 2 is Windshaper
  only, 3 is both (G values, A reading).
- New in Forever (absent from Classic Era 70576 SkillLineAbility, G): Will to Survive (Human, "Instantly removes all
  Stun effects"), Shatter Curse (Orc), Elune's Light (Night Elf), Rapid Regeneration (Troll), and the Skyborne three.
  Cultivation 20552 exists in both.
- Passive racials (not listed): Human Ruthless 20597 and The Human Spirit 20598, Orc Hardiness, Tauren Endurance,
  Troll Regeneration and Beast Slaying, Night Elf Quickness and Wisp Spirit (G, passive bit).

### What Forever changed for the Hunter (only where the data shows it)

- **Aimed Shot is a trainer spell now**, Rank 1 at level 20, cast 2 sec (WH envChange: "A talent in Classic; trained
  without one now"; G). It is in no talent tree in 70790 or 70707 (G).
- **New active talents:** Summon Hawk, Sniper Shot, Strider Kick (all with WH status "new"); Trueshot Aura is now a
  row-4 talent with a new Rank 2 at 32, and the old ranks moved up (WH: "Now Rank 4 (was Rank 2)"); G.
- **Counterattack** has a new Rank 2 (1242634, trainer, level 30); the old ranks are now Rank 3 and 4 (WH, G).
- **Aspect of the Beast** has new Ranks 2-4 (40/50/60) and now raises melee attack power (DB2 description, G).
- **Gone from the client** (in Classic Era 70576 SkillLineAbility and named in Classic Era 70576 SpellName, missing
  from Forever SpellName, G): Wyvern Sting
  (19386 and 24131-24135), Multi-Shot Ranks 2-5 (14288, 14289, 14290, 25294), Scorpid Sting Ranks 2-4 (14275-14277).
  So Multi-Shot and Scorpid Sting have one rank; their mana cost is now a % of base mana (WH, G).
- **Readiness** 23989: AcquireMethod 0 in Classic Era, 3 ("never learned") in Forever (G).
- **All four traps share one cooldown:** Freezing, Frost, Immolation and Explosive Trap all have SpellCategories
  Category 411 with a 30 sec category cooldown (G). WH: "Cooldown 30 sec instead of 15 sec".
- Multi-Shot 6 sec cooldown (was 10) and it shares its cooldown with Aimed Shot (DB2 descriptions + WH, G). Volley has
  no cooldown any more (WH, G). Viper Sting has a 15 sec cooldown (WH, G). Summon Hawk shares its cooldown with Arcane
  Shot (DB2 description, G). Eyes of the Beast lasts 2 min (WH, G).
- Season of Discovery leftovers in the DB2 (Kill Command, Chimera Shot, Flanking Strike, Carve: AcquireMethod 3, G;
  Heart of the Lion, Aspect of the Viper, Aspect of the Falcon, Enchanted Flare: AcquireMethod 0 but no source on
  Wowhead and not in Zygor's trainer data, G). I treat all of them as not learnable (A). The same rows are in Classic
  Era 70576 too (G), so the DB2 alone cannot settle this.

## States + conditions

**The Hunter has no state.** Evidence:
1. G, DB2 SpellShapeshiftForm 70790: the forms with a bonus action bar are Cat Form (1), Bear Form (3), Dire Bear
   Form (3), Battle Stance (1), Defensive Stance (2), Berserker Stance (3) and Stealth (1). None is a hunter form.
2. G, DB2 SpellEffect 70790: 0 of 379 hunter skill-line spells apply aura 36 (shapeshift). Positive control above.
   The Aspects are plain buffs: Hawk aura 124 (ranged attack power), Monkey 49 (dodge), Cheetah/Pack 31 (speed),
   Beast 120/99, Wild 22 (resistance). "Only one Aspect can be active at a time" is a rule of the spells, not a form.
3. G, Blizzard `ActionBarController.lua` (forever branch, 70790) lines 160-168: the main bar only moves to the bonus
   bar page when `C_ActionBar.HasBonusActionBar()` is true. A: that is never true for a Hunter, because of 1 and 2.
4. G, EllesmereUI paging lines 108-111: `CLASS_DEFAULTS` only has DRUID and ROGUE. Lines 130-132 and 199-203 add
   `[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10` for every class in Forever. A: for a Hunter
   these never fire.
5. G, `StanceBar.lua` uses `GetNumShapeshiftForms()`. A: it returns 0 for a Hunter, so there is no stance bar.

So: `states = {}` and no `baseGuard`. Every key uses `base` (or `all`, which gives the same macro when there are no
states; `Body()` in ForeverBlock.lua, G).

Conditions that do exist and could matter for a Hunter (all A, not measured in Forever):
- `[pet]` / `[nopet]`: is a pet out. Useful for Call Pet. Open question: is a **dead** pet "no pet" in Forever?
- `[combat]`, as the Druid uses on F3.
- There is **no** macro condition for distance or melee range. So one key cannot be "Raptor Strike in melee, Arcane
  Shot at range". That is why melee spells get their own keys.

## Proposal per key

One column only, because there are no states. Level = when the key gets its first spell (rule 3: the key keeps its
place and stays empty until then). `*` = talent level (A). Every choice of spell per key is **A** (a judgment call);
the levels and names are G.

| Key | Task (KeyBlock.lua) | Hunter | Level | Why / note |
|---|---|---|---|---|
| 1 | main | Auto Shot | 1 | starting spell. ⚠ see open question 1 (pressing it again may stop shooting) |
| 2 | rotation | Serpent Sting | 4 | the damage-over-time, like Druid 2 (Moonfire / Rake) |
| 3 | rotation | Arcane Shot | 6 | instant hit, 6 sec cooldown |
| 4 | spender | Aimed Shot | 20 | the big shot; trainer spell now |
| 5 | rotation | Raptor Strike | 1 | melee main button; starting spell |
| Shift-1 | AoE | Multi-Shot | 18 | |
| Shift-2 | AoE | Explosive Trap, else Immolation Trap | 16 (34) | "fire trap": Immolation from 16, Explosive takes over at 34. All traps share one 30 sec cooldown (G) |
| Shift-3 | cd3 | Intimidation* | 30* | Beast Mastery, 1 min |
| Shift-4 | 2nd spender | Sniper Shot* | 40* | Marksmanship, 15 sec, the second big shot |
| Q | big cooldown | Rapid Fire | 26 | 5 min |
| F1 | cd2 | Bestial Wrath* | 40* | Beast Mastery, 2 min |
| Shift-F1 | cd2b | Summon Hawk* | 25* | Beast Mastery; shares its cooldown with Arcane Shot |
| F3 | cd4 (Druid: resurrection) | Revive Pet | 10 | same job as Druid F3 (Rebirth/Revive): bring back to life |
| E | interrupt | Scatter Shot* | 30* | the Hunter has no real interrupt. Scatter Shot disorients (A: that stops a cast) |
| R | movement | Aspect of the Cheetah | 20 | like Druid R (Travel Form) |
| Shift-R | movement 2 | Strider Kick* | 30* | Survival; a melee kick that also gives movement speed (DB2 description) |
| F | taunt / help | Distracting Shot | 12 | the Hunter's taunt-like threat shot |
| Z | small defensive | Disengage | 20 | threat drop, 5 sec |
| X | defensive 2 | Feign Death | 30 | 30 sec |
| C | big defensive | Deterrence* | 20* | Survival, 5 min |
| V | CC | Freezing Trap | 20 | the main CC |
| Shift-Q | CC | Concussive Shot | 8 | ranged slow |
| Shift-F | CC | Wing Clip | 12 | melee slow |
| Shift-V | CC / dispel | Counterattack* | 25* | Survival; after a parry, immobilizes the target |
| Shift-Z | 2nd row (Druid: Thorns) | Hunter's Mark | 6 | put up once per target |
| Shift-X | 2nd row (Druid: group buff) | Trueshot Aura* | 25* | Marksmanship group buff |
| Shift-C | 2nd row (Druid: poison cure) | Mongoose Bite | 16 | melee, only after you dodge |
| F2 | quick heal | Mend Pet | 12 | the Hunter has no self heal; this heals the pet |
| F4 | heal over time / recuperate | Call Pet | 10 | get your pet back. F2-F4 is then the "pet row" |
| Ctrl-1 | form 1 | Aspect of the Hawk | 10 | the main aspect |
| Ctrl-2 | form 2 | Aspect of the Monkey | 4 | defense |
| Ctrl-3 | form 3 | Aspect of the Beast | 30 | melee (Forever made it a melee aspect) |
| Shift-E | racial | the race's main racial | 1 | Shadowmeld / War Stomp / Stoneform / Blood Fury / Berserking / Perception / Walk on Air |
| T, Shift-T, G | fixed | potion, healthstone, trinket | - | not spells |

What a new Hunter sees (A, from the levels above): level 1 = keys 1, 5 and Shift-E. Level 4 = 2 and Ctrl-2.
Level 6 = 3 and Shift-Z. Level 8 = Shift-Q. Level 10 = Ctrl-1, F3, F4 (after the pet quests). Level 12 = F, F2,
Shift-F. Level 16 = Shift-2, Shift-C. Level 18 = Shift-1. Level 20 = 4, R, Z, V (and C for Survival).

**Block D (the player's own Alt keys; MH never fills it)**: Volley (40), Frost Trap (28), Viper Sting (36),
Scorpid Sting (22), Scare Beast (14), Aspect of the Pack (40), Aspect of the Wild (46), Tranquilizing Shot (60, book),
Flare (32), Feed Pet (10), Dismiss Pet (10), plus the race's second racial (Will to Survive, Shatter Curse,
Find Treasure, Elune's Light, Cultivation, Rapid Regeneration, Read Leyline or Skysight). That is 11 + 1 = 12 per
character, exactly block D's 12 places. Immolation Trap leaves Shift-2 at level 34; a player who still wants it can
put it on block D too.

**On no key (handled on purpose, A):** Tame Beast, Beast Training, Beast Lore, Eyes of the Beast, Eagle Eye and the
eight Track spells. They are used outside combat. Forever has a minimap tracking button
(`Blizzard_Minimap/Camelot/MinimapTrackingButton.lua`, G); that it lists the hunter tracking spells is A.

## Draft Lua table

Draft for review only. Not in the repo. Names checked against SpellName.csv 70790 (`verify_names_out.txt`, G).

```lua
local _, ns = ...

--[[
	ForeverBlock_Hunter.lua — DRAFT key-block table for the Hunter in WoW Forever (not approved).

	The Hunter has no state: no form, stance, stealth or bar paging (DB2 SpellShapeshiftForm + SpellEffect 70790,
	Blizzard ActionBarController forever branch, EllesmereUI paging). So states is empty and every key has one job.
	Melee and ranged get separate keys: macros have no condition for distance.
	Spells and levels: scratchpad forever_classes\hunter.md (5 Nov 2026).
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.HUNTER = {
	states = {},
	keys = {
		["1"] = { base = "Auto Shot" }, -- open question 1: "/cast Auto Shot" may toggle shooting off
		["2"] = { base = "Serpent Sting" },
		["3"] = { base = "Arcane Shot" },
		["4"] = { base = "Aimed Shot" },
		["5"] = { base = "Raptor Strike" },
		["SHIFT-1"] = { base = "Multi-Shot" },
		["SHIFT-2"] = { base = { "Explosive Trap", "Immolation Trap" } },
		["SHIFT-3"] = { base = "Intimidation" },
		["SHIFT-4"] = { base = "Sniper Shot" },
		["Q"] = { base = "Rapid Fire" },
		["F1"] = { base = "Bestial Wrath" },
		["SHIFT-F1"] = { base = "Summon Hawk" },
		["F3"] = { base = "Revive Pet" },
		["E"] = { base = "Scatter Shot" },
		["R"] = { base = "Aspect of the Cheetah" },
		["SHIFT-R"] = { base = "Strider Kick" },
		["F"] = { base = "Distracting Shot" },
		["Z"] = { base = "Disengage" },
		["X"] = { base = "Feign Death" },
		["C"] = { base = "Deterrence" },
		["V"] = { base = "Freezing Trap" },
		["SHIFT-Q"] = { base = "Concussive Shot" },
		["SHIFT-F"] = { base = "Wing Clip" },
		["SHIFT-V"] = { base = "Counterattack" },
		["SHIFT-Z"] = { base = "Hunter's Mark" },
		["SHIFT-X"] = { base = "Trueshot Aura" },
		["SHIFT-C"] = { base = "Mongoose Bite" },
		["F2"] = { base = "Mend Pet" },
		["F4"] = { base = "Call Pet" },
		["CTRL-1"] = { base = "Aspect of the Hawk" },
		["CTRL-2"] = { base = "Aspect of the Monkey" },
		["CTRL-3"] = { base = "Aspect of the Beast" },
		["SHIFT-E"] = { all = { "Shadowmeld", "War Stomp", "Stoneform", "Blood Fury", "Berserking", "Perception", "Walk on Air" } },
	},
	toBlockD = {
		"Volley", "Frost Trap", "Viper Sting", "Scorpid Sting", "Scare Beast", "Aspect of the Pack", "Aspect of the Wild",
		"Tranquilizing Shot", "Flare", "Feed Pet", "Dismiss Pet",
		"Will to Survive", "Shatter Curse", "Find Treasure", "Elune's Light", "Cultivation", "Rapid Regeneration",
		"Read Leyline", "Skysight",
	},
	listed = {
		"Tame Beast", "Beast Training", "Beast Lore", "Eyes of the Beast", "Eagle Eye", "Immolation Trap",
		"Track Beasts", "Track Humanoids", "Track Undead", "Track Hidden", "Track Elementals", "Track Demons",
		"Track Giants", "Track Dragonkin",
	},
}
```

Notes on the draft (A, from reading `ForeverBlock.lua`):
- `states = {}` is safe: `Body()` loops over `cls.states or {}` and only adds a guard when a state guarded something.
- `listed` is the engine's field for "names that count as handled". I used it for the spells that are on no key on
  purpose. If Rob wants those to show up as "not in MH's list" instead, drop the field.
- 33 keys means 33 macros. The engine makes character macros first (it assumes 18) and then account macros
  (`ForeverEnsureMacro`, G). That is the same as for the Druid (32 keys).

## Open questions for Rob

1. **Auto Shot on key 1.** In Classic, `/cast Auto Shot` while you are already shooting stops the shooting; hunters
   use `/cast !Auto Shot` (A, from Classic, not measured in Forever). The engine writes `/cast <name>`. Options:
   a) a small engine change (a flag per key that writes `!`), b) Arcane Shot on 1 and Auto Shot elsewhere,
   c) leave it and test first. Test: press 1 twice on a target dummy.
2. **Melee or ranged first?** The draft is ranged-first (shots on 1-4, Raptor Strike on 5, Mongoose Bite on Shift-C).
   Forever pushes a melee Survival hunter (Strider Kick, Counterattack R2, Lacerating Strikes, Aspect of the Beast
   ranks; G). Following "players choose": a per-character switch "melee hunter" could swap 1 with 5 and 3 with
   Shift-C. That needs engine work. Or one key with two lines (`/cast Raptor Strike` and `/cast !Auto Shot`) that does
   the right thing at both distances (A, an old hunter trick; untested in Forever; the engine writes one line).
3. **Shift-2: fire trap or Volley?** The draft has the fire trap (from level 16) and puts Volley (40) on block D.
4. **Pet keys.** F2 Mend Pet, F3 Revive Pet, F4 Call Pet. Option: F4 as `pair = { cond = "[nopet]", first = "Call Pet",
   second = "Mend Pet" }`, which frees F2. That only works if a dismissed pet and a dead pet behave as expected with
   `[nopet]`; not measured. Test: let the pet die, then `/dump UnitExists("pet")`.
5. **Pet bar keys.** The block uses Ctrl-1/2/3 (Rob's bindings-cache lines 18-20 bind them to MULTIACTIONBAR6, G).
   In Blizzard's default bindings Ctrl-1 to Ctrl-0 drive the pet bar (A, from memory; the file only stores changes,
   so I could not measure the default). Then a Hunter has no key for Pet Attack/Follow/Stay. Where should those go?
   (block D macros such as `/petattack`, or clicks).
6. **E has no real interrupt.** Scatter Shot (Marksmanship talent) is the closest. Non-Marksmanship hunters have an
   empty E. OK?
7. **Racial order on Shift-E.** One racial per race. The draft keeps the old racial (like the Druid table chose
   Shadowmeld over Elune's Light). For a Human, Will to Survive (stun break) may be more useful than Perception.
8. **Intimidation has a name twin.** Pet spell 24394 is also called "Intimidation" (skill line 270, G). Check in game
   that `C_Spell.GetSpellInfo("Intimidation")` gives 19577.
9. **Aspects pressed twice.** Does casting an active Aspect again turn it off in Forever? Not measured. Matters for
   Ctrl-1/2/3 and R.
10. **Lacerate 24118 (Survival skill line, ranks 30/40/50/60, WH "new").** No source on Wowhead, no trainer in Zygor,
    no teach spell. It may be a triggered effect. Not on the block; please check the trainer at level 30.
11. **"Talented" points** (TraitTree 1188, levels 5-9). If a player can have them, all talent levels in this file are
    up to 5 levels too late. This affects every class.

## What is GEMETEN vs AFGELEID

GEMETEN (seen in a named, dated source):
- Every spell ID, name, rank, level and skill line in the spell table (DB2 70790), and the trainer/quest/book source
  for each row (Wowhead Forever listview, 5 Nov 2026) or the DB2 teach spell (1579 teaches Tame Beast, Call Pet,
  Dismiss Pet; 5300 teaches Beast Training, Feed Pet, Revive Pet; 1117 teaches Mend Pet R1).
- The level-1 starting spells (Auto Shot, Raptor Strike R1), the class/spec IDs, the talent tree 1091 and its 9 active
  talents with their rows, and the race/class rows in CharBaseInfo (incl. new Human and Skyborne hunters).
- No hunter form, no shapeshift aura, the shared trap category 411, the cooldowns and descriptions quoted.
- What Forever changed vs Classic Era, as listed (DB2 70576 vs 70790 diff and Wowhead envChange).
- Blizzard's paging rule (`HasBonusActionBar`), EllesmereUI's paging lines, and Rob's current Ctrl-1/2/3 bindings.

AFGELEID (reasoned, not measured):
- The earliest level of each talent (10 + points), and the meaning of the "Talented" rows.
- That the Hunter never gets a bonus bar, so no state and no macro condition (follows from the measured data).
- That the SoD leftovers, Black Arrow and Lacerate are not learnable.
- That the quests "Taming the Beast" / "Training the Beast" give the teach spells (quest titles seen in Zygor's quest
  list, e.g. 6061/6087/6088; which quest gives which teach spell is not measured).
- That Human and Skyborne hunters can really be created (only the DB2 row is measured).
- Every key choice in the proposal and the draft table.
- The behaviour of `/cast Auto Shot`, `[nopet]` with a dead pet, recasting an Aspect, and Blizzard's default pet-bar keys.
