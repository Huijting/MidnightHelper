# WoW Forever — Shaman: spells tot 60 + VOORSTEL voor het toetsenblok

> 🌙 **Nacht 5→6 nov 2026, onderzoek door mh-research (één helper per class). NIET goedgekeurd door Rob, NIET in de
> addon.** Alleen een goedgekeurde tabel komt in `Modules/ForeverBlock_<Class>.lua`.
>
> **Zelf nagekeken in de nacht (GEMETEN):**
> - beginspells staan in Blizzards data met AcquireMethod 2: Lightning Bolt 403, Healing Wave 331 (wago wowf 1.60.1.70790, SkillLineAbility);
> - de concepttabel hieronder laadt in de échte motor (`Modules/ForeverBlock.lua`, offline met nagebootste spells):
>   elke spellnaam bestaat in SpellName, elke toets is een blok-plek, geen spell op twee toetsen;
> - stance/vorm-nummers: SpellShapeshiftForm.BonusActionBar (Cat 1, Bear 3, Stealth 1, Battle 1, Defensive 2,
>   Berserker 3, Moonkin/Shadowform/Ghost Wolf 0).
> - Niet in het spel getest. Elke toetskeuze is een voorstel (AFGELEID).
> - Voor alle classes geldt (helpers, GEMETEN in de data): een account-perk 'Talented' geeft al talentpunten vanaf
>   level 5-9, dus talent-levels hieronder kunnen tot 5 levels vroeger zijn.

**Aandachtspunten van de nachtcontrole:**
- Ctrl-1/2/3 zijn hier de drie 'Call of the …'-totemsets, niet vormen; de Shaman heeft geen vorm die de balk wisselt.

---

# WoW Forever Shaman: spell list 1-60, states and key-block proposal (client 1.60.1.70790)

Researched night of 5→6 Nov 2026 (class researcher, read-only). Nothing in the repo was changed.
Per my own agent rule I did **not** read anything under `MidnightHelper/docs/`. As the Druid example I used the
scratchpad copy `scratchpad/forever_druid_spells.md` (same content as the Druid spell list) and the approved table in
`Modules/ForeverBlock_Druid.lua`, plus the engine header in `Modules/ForeverBlock.lua` and `Modules/KeyBlock.lua`
lines 15-115. So the Druid *plan* text (`PLAN_FOREVER_DRUID_BLOK`) was not read; its result is in the Lua table.

## Sources
- **DB2** = wago.tools, product `wowf`, build **1.60.1.70790** (the brief's offline set in `scratchpad/wago_wowf/`,
  fetched 5 Nov 2026 ~23:25). Tables: SkillLineAbility (SkillLines 375 Elemental Combat, 373 Enhancement,
  374 Restoration; racial lines 125 Orc, 124 Tauren, 733 Troll, 101 Dwarf, 2980 Skyborne), SpellName, Spell (rank
  subtext, descriptions), SpellLevels, SpellMisc (Attributes_0: 0x40 passive, 0x10000 "not while shapeshifted"),
  SpellCategories + SpellCooldowns, SpellEffect, SpellShapeshiftForm, ChrClasses, ChrSpecialization, Trait* tables.
- **DB2 extra (fetched by me 5 Nov 2026, curl, HTTP 200, build 1.60.1.70790)** into `scratchpad/shaman_work/dl/`:
  SkillLineXTraitTree, CharBaseInfo (race/class combos), ChrRaces, SpellTotems, TotemCategory.
- **Classic Era DB2 1.15.9.70576** (for "what Forever changed"), fetched by me 5 Nov 2026 into
  `scratchpad/shaman_work/dl_era/`: CharBaseInfo, SkillLineAbility, SpellName, SpellLevels, SpellTotems, SkillRaceClassInfo.
- **WH** = Wowhead Forever `wowhead.com/forever/spells/abilities/shaman`, 260 rows, read from the page's own listview
  data in the in-app browser on 5 Nov 2026 (my own tab, closed after). Source codes: 6 trainer, 4 quest, 2 drop/book,
  none = starting spell / not trainable. Per-spell "Reward from quest" / "Taught by item" tabs read for 8071, 3599, 5394.
  Raw extract: `scratchpad/shaman_work/wh_sources.txt`.
- **Blizzard UI source**, github.com/Gethe/wow-ui-source branch `forever`, newest commit "1.60.1 (70790)" (4 Nov 2026):
  `Blizzard_ActionBar/Blizzard_ActionBar.toc`, `Shared/MultiCastActionBarFrame.lua`,
  `Camelot/MultiCastActionBarOverrides.lua`, `Blizzard_ActionBarController/ActionBarController.lua`.
- **EllesmereUI (Forever install)**: `EllesmereUIActionBars/EUI_ActionBars_Paging.lua` lines 197-208 and
  `EllesmereUI/EllesmereUI_VisibilityRules.lua` lines 56-85 (`CLASS_PAGING_STATES`).
- **Zygor** `ZygorGuidesViewerForever/Data-Forever/Skill_Training.lua` lines 1496-1560: used only as a cross-check
  (it still calls Totemic Call "Totemic Projection", so it is older than this build).
- Scripts: `scratchpad/shaman_work/s01..s11*.py` (run with `python -I`). Generated table: `out_table.md`.

## Positive control: PASSES (GEMETEN, DB2 70790)
- Level-1 starting spells (SkillLineAbility AcquireMethod 2) for the three Shaman lines: **Lightning Bolt Rank 1 (403,
  Elemental Combat)** and **Healing Wave Rank 1 (331, Restoration)**. Exactly these two, same as Classic Era 1.15.9
  (also AcquireMethod 2 there). WH lists both with no source and level 1.
- Rockbiter Weapon Rank 1 (8017) is the only other level-1 spell: trainer, 10 copper (WH source 6; Zygor `[1]`).
- ChrSpecialization 1489 = "Shaman", ClassID 7: one spec, like every Forever class.
- SkillLineXTraitTree row 163: SkillLine 373 → TraitTree **1082** (the Shaman talent tree, 50 nodes, 3 sections, currency
  3820 = 51 points). Druid positive control from the same table: row 158, 574 → 1089 (matches the Druid file).
- My pattern finds known spells (Earth Shock 8042 at 4, Stoneskin 8071 at 4), so the empty results below (e.g. no
  Fire Nova Totem in the Forever skill lines) are real absences in this build, not a broken search.

## Who can be a Shaman in Forever (GEMETEN, CharBaseInfo)
| Race (ChrRaces ID) | Faction (ChrRaces.Alliance) | Shaman in Forever 70790 | Shaman in Classic Era 1.15.9 |
|---|---|---|---|
| Orc (2) | Horde | yes (row 11) | yes |
| Tauren (6) | Horde | yes (row 26) | yes |
| Troll (8) | Horde | yes (row 56) | yes |
| **Dwarf (3)** | **Alliance** | **yes (row 905, NEW)** | no |
| **Windshaper Skyborne (96)** | Horde | **yes (row 893, NEW race)** | - |
| High Order Skyborne (95) | Alliance | no (rows 888/889/898/899/900: Hunter, Rogue, Warrior, Mage, Druid) | - |

So **both factions can play Shaman**: Alliance only as Dwarf. (Search-result titles from method.gg / warcrafttavern /
icy-veins say the same, "Dwarf Shaman" among six new combos; I did not open them, the Icy Veins page gave HTTP 403. The
DB2 rows are the proof.) Side finding: Skyborne (both 95 and 96) can be **Druid** (rows 900, 903), and the approved
Druid table has no Skyborne racial on Shift-E.

### Racials of the Shaman races (GEMETEN, SkillLineAbility race masks; mask→race via ChrRaces.PlayableRaceBit)
| Race | Active (cooldown) | Passive |
|---|---|---|
| Orc | Blood Fury 20572 (2 min), **Shatter Curse 1299026 (3 min, NEW ID: removes curses, less magic damage)** | Hardiness 20573, Command (pet classes only) |
| Tauren | War Stomp 20549 (90 s), Cultivation 20552 (15 min, grow a herb to pick) | Endurance 20550, **Plainsrunning 1259918 (NEW)** |
| Troll | Berserking 20554 (3 min), **Rapid Regeneration 1260270 (3 min, NEW: heal over time, broken by any action)** | Beast Slaying 20557, Regeneration 20555 |
| Dwarf | Stoneform 20594 (3 min), Find Treasure 2481 | **Artisan's Precision 1259719, Big Game Hunter 1259721 (both NEW)** |
| Windshaper Skyborne | Skysight 1259686 (2 min, speed buff; mask bit 33 = race 96), Walk on Air 1259416 (90 s, glide; both Skyborne) | Elemental Insight 1259707, Wind Blessed 1259710 |
(High Order Skyborne's Read Leyline 1259705 has mask bit 32 = race 95, which cannot be Shaman.)
"NEW" = the ID is not in Classic Era 1.15.9 SpellName (GEMETEN). All racials have AcquireMethod 2 (automatic).

## Spell list (table)
Every ACTIVE (passive bit off), learnable Shaman class spell, levels 1-60, every rank: **179 rows, 55 names**.
Level marked `*` = talent; the number is the earliest level by the row rule (AFGELEID, see legend).
Left out on purpose (all GEMETEN in DB2): AcquireMethod 3 "never learned" entries (Season-of-Discovery leftovers:
Lava Lash, Molten Blast, Earth Shield, Healing Rain, Ancestral Guidance, Decoy Totem, Spirit of the Alpha, the 4084xx
Lightning Bolt/Chain Lightning overload copies, and Dual Wield for class mask 64); the Lightning Shield damage procs
26363-26370 (same name, not castable); Reincarnation 21169 (the self-res used from the death dialog; the spellbook entry
20608 is passive).

Legend
- **Form column**: "none (attr …)" = SpellMisc Attributes_0 has 0x10000 (vanilla meaning "not while shapeshifted"),
  so in Ghost Wolf the cast either fails or the client cancels the wolf first (which one is NOT measured).
  Only Totemic Call, Fire Nova Rank 2 and Lightning Mastery lack the bit. The bit is GEMETEN, its meaning AFGELEID.
- **Talent level rule (AFGELEID)**: a row needs 5 more points spent in that section (TraitCond SpentAmountRequired
  5/10/15/20/25/30, GEMETEN). Points come 1 per level from 10 (TraitCurrencySource "Level 10" … "Level 60", 51 rows,
  GEMETEN), so a row needing N points opens at level 10+N. **New finding**: an account node "Talented" (spell 1225474,
  tree 1188, 5 ranks) lets points start at level 9…5 instead, still max 51 (GEMETEN text). With it, every talent row can
  open up to 5 levels earlier. This holds for the Druid table's `*` levels too.
- **How learned**: trainer/quest/book from WH, matched by spell ID; levels from DB2 SpellLevels (for weapon imbues and
  utility spells BaseLevel is 0, so SpellLevel is used). WH's level equals DB2's level on every trainer row (checked by script).
- **Tab** = SkillLineAbility.SkillLine.

| Spell | Rank | ID | Level | How learned | Tab | Form | Measured? |
|---|---|---|---|---|---|---|---|
| Healing Wave | Rank 1 | 331 | 1 | starting spell (DB2 AcquireMethod 2) | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH no source) |
| Lightning Bolt | Rank 1 | 403 | 1 | starting spell (DB2 AcquireMethod 2) | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH no source) |
| Rockbiter Weapon | Rank 1 | 8017 | 1 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Earth Shock | Rank 1 | 8042 | 4 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneskin Totem | Rank 1 | 8071 | 4 | quest: Call of Earth 1518/1521 (H), 94375 (A), 92468 (H); also Stoneskin Totem Scroll 6648 | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH quest tab) |
| Earthbind Totem | - | 2484 | 6 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Wave | Rank 2 | 332 | 6 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Earth Shock | Rank 2 | 8044 | 8 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Bolt | Rank 2 | 529 | 8 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Shield | Rank 1 | 324 | 8 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Rockbiter Weapon | Rank 2 | 8018 | 8 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneclaw Totem | Rank 1 | 5730 | 8 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flame Shock | Rank 1 | 8050 | 10 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flametongue Weapon | Rank 1 | 8024 | 10 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Searing Totem | Rank 1 | 3599 | 10 | quest: Call of Fire 1527/97257 (H), 94468 (A); also Searing Totem Scroll 6649 | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH quest tab) |
| Strength of Earth Totem | Rank 1 | 8075 | 10 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Ancestral Spirit | Rank 1 | 2008 | 12 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Fire Nova | Rank 1 | 408341 | 12 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Wave | Rank 3 | 547 | 12 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Purge | Rank 1 | 370 | 12 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Earth Shock | Rank 3 | 8045 | 14 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Bolt | Rank 3 | 548 | 14 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneskin Totem | Rank 2 | 8154 | 14 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Cure Poison | - | 526 | 16 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Shield | Rank 2 | 325 | 16 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Rockbiter Weapon | Rank 3 | 8019 | 16 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flame Shock | Rank 2 | 8052 | 18 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flametongue Weapon | Rank 2 | 8027 | 18 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Wave | Rank 4 | 913 | 18 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneclaw Totem | Rank 2 | 6390 | 18 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Tremor Totem | - | 8143 | 18 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Call of the Elements | - | 66842 | 20 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frost Shock | Rank 1 | 8056 | 20 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frostbrand Weapon | Rank 1 | 8033 | 20 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Ghost Wolf | - | 2645 | 20 | trainer | Enhancement | (is the form: Ghost Wolf, form 16) | GEMETEN (DB2 + WH) |
| Healing Stream Totem | Rank 1 | 5394 | 20 | quest: Call of Water 96 (H), 94505 (A); also Healing Stream Totem Scroll 6650 | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH quest tab) |
| Lesser Healing Wave | Rank 1 | 8004 | 20 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Bolt | Rank 4 | 915 | 20 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Searing Totem | Rank 2 | 6363 | 20 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Totemic Recall | - | 36936 | 20 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Water Shield | - | 408510 | 20* | TALENT (Restoration section, row 3, 10 points) | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 tree 1082); level AFGELEID |
| Cure Disease | - | 2870 | 22 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Fire Nova | Rank 2 | 408342 | 22 | trainer | Elemental Combat | no shapeshift attr (castable in Ghost Wolf?) | GEMETEN (DB2 + WH) |
| Poison Cleansing Totem | - | 8166 | 22 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Totemic Call | - | 437009 | 22 | trainer | Enhancement | no shapeshift attr (castable in Ghost Wolf?) | GEMETEN (DB2 + WH) |
| Water Breathing | - | 131 | 22 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Ancestral Spirit | Rank 2 | 20609 | 24 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Earth Shock | Rank 4 | 8046 | 24 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frost Resistance Totem | Rank 1 | 8181 | 24 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Wave | Rank 5 | 939 | 24 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Shield | Rank 3 | 905 | 24 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Rockbiter Weapon | Rank 4 | 10399 | 24 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneskin Totem | Rank 3 | 8155 | 24 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Strength of Earth Totem | Rank 2 | 8160 | 24 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Mana Tide Totem | Rank 1 | 16190 | 25* | TALENT (Restoration section, row 4, 15 points); DB2 SpellLevels says 1 | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 tree 1082); level AFGELEID |
| Stormstrike | - | 17364 | 25* | TALENT (Enhancement section, row 4, 15 points); DB2 SpellLevels says 40 (vanilla value) | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 tree 1082); level AFGELEID |
| Far Sight | - | 6196 | 26 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flametongue Weapon | Rank 3 | 8030 | 26 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Bolt | Rank 5 | 943 | 26 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Magma Totem | Rank 1 | 8190 | 26 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Mana Spring Totem | Rank 1 | 5675 | 26 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Fire Resistance Totem | Rank 1 | 8184 | 28 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flame Shock | Rank 3 | 8053 | 28 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flametongue Totem | Rank 1 | 8227 | 28 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frostbrand Weapon | Rank 2 | 8038 | 28 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lesser Healing Wave | Rank 2 | 8008 | 28 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneclaw Totem | Rank 3 | 6391 | 28 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Water Walking | - | 546 | 28 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Astral Recall | - | 556 | 30 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Call of the Ancestors | - | 66843 | 30 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Grounding Totem | - | 8177 | 30 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Stream Totem | Rank 2 | 6375 | 30 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Nature Resistance Totem | Rank 1 | 10595 | 30 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Nature's Swiftness | - | 16188 | 30* | TALENT (Restoration section, row 5, 20 points) | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 tree 1082); level AFGELEID |
| Searing Totem | Rank 3 | 6364 | 30 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Windfury Weapon | Rank 1 | 8232 | 30 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Chain Lightning | Rank 1 | 421 | 32 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Fire Nova | Rank 3 | 408343 | 32 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Wave | Rank 6 | 959 | 32 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Bolt | Rank 6 | 6041 | 32 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Shield | Rank 4 | 945 | 32 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Purge | Rank 2 | 8012 | 32 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Windfury Totem | Rank 1 | 8512 | 32 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frost Shock | Rank 2 | 8058 | 34 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Rockbiter Weapon | Rank 5 | 16314 | 34 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Sentry Totem | - | 6495 | 34 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneskin Totem | Rank 4 | 10406 | 34 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Ancestral Spirit | Rank 3 | 20610 | 36 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Earth Shock | Rank 5 | 10412 | 36 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flametongue Weapon | Rank 4 | 16339 | 36 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lesser Healing Wave | Rank 3 | 8010 | 36 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Magma Totem | Rank 2 | 10585 | 36 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Mana Spring Totem | Rank 2 | 10495 | 36 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Windwall Totem | Rank 1 | 15107 | 36 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Disease Cleansing Totem | - | 8170 | 38 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flametongue Totem | Rank 2 | 8249 | 38 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frost Resistance Totem | Rank 2 | 10478 | 38 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frostbrand Weapon | Rank 3 | 10456 | 38 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Bolt | Rank 7 | 10391 | 38 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Mana Tide Totem | Rank 2 | 17354 | 38 | trainer (needs the talent) | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneclaw Totem | Rank 4 | 6392 | 38 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Strength of Earth Totem | Rank 3 | 8161 | 38 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Call of the Spirits | - | 66844 | 40 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Chain Heal | Rank 1 | 1064 | 40 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Chain Lightning | Rank 2 | 930 | 40 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flame Shock | Rank 4 | 10447 | 40 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Stream Totem | Rank 3 | 6377 | 40 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Wave | Rank 7 | 8005 | 40 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Mastery | - | 16166 | 40* | TALENT (Elemental section, row 7, 30 points) | Elemental Combat | no shapeshift attr (castable in Ghost Wolf?) | GEMETEN (DB2 tree 1082); level AFGELEID |
| Lightning Shield | Rank 5 | 8134 | 40 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Rage of the Farseer | - | 425336 | 40* | TALENT (Enhancement section, row 7, 30 points) | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 tree 1082); level AFGELEID |
| Riptide | Rank 1 | 408521 | 40* | TALENT (Restoration section, row 7, 30 points); DB2 SpellLevels also 40 | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 tree 1082); level AFGELEID |
| Searing Totem | Rank 4 | 6365 | 40 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Windfury Weapon | Rank 2 | 8235 | 40 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Fire Nova | Rank 4 | 408344 | 42 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Fire Resistance Totem | Rank 2 | 10537 | 42 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Grace of Air Totem | Rank 1 | 8835 | 42 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Windfury Totem | Rank 2 | 10613 | 42 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lesser Healing Wave | Rank 4 | 10466 | 44 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Bolt | Rank 8 | 10392 | 44 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Nature Resistance Totem | Rank 2 | 10600 | 44 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Rockbiter Weapon | Rank 6 | 16315 | 44 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneskin Totem | Rank 5 | 10407 | 44 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Chain Heal | Rank 2 | 10622 | 46 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flametongue Weapon | Rank 5 | 16341 | 46 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frost Shock | Rank 3 | 10472 | 46 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Magma Totem | Rank 3 | 10586 | 46 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Mana Spring Totem | Rank 3 | 10496 | 46 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Windwall Totem | Rank 2 | 15111 | 46 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Ancestral Spirit | Rank 4 | 20776 | 48 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Chain Lightning | Rank 3 | 2860 | 48 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Earth Shock | Rank 6 | 10413 | 48 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flametongue Totem | Rank 3 | 10526 | 48 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frostbrand Weapon | Rank 4 | 16355 | 48 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Wave | Rank 8 | 10395 | 48 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Shield | Rank 6 | 10431 | 48 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Mana Tide Totem | Rank 3 | 17359 | 48 | trainer (needs the talent) | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneclaw Totem | Rank 5 | 10427 | 48 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Stream Totem | Rank 4 | 10462 | 50 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Bolt | Rank 9 | 15207 | 50 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Riptide | Rank 2 | 1239242 | 50 | trainer (needs the talent) | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Searing Totem | Rank 5 | 10437 | 50 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Windfury Weapon | Rank 3 | 10486 | 50 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Fire Nova | Rank 5 | 408345 | 52 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flame Shock | Rank 5 | 10448 | 52 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lesser Healing Wave | Rank 5 | 10467 | 52 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Strength of Earth Totem | Rank 4 | 10442 | 52 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Windfury Totem | Rank 3 | 10614 | 52 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Chain Heal | Rank 3 | 10623 | 54 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frost Resistance Totem | Rank 3 | 10479 | 54 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Rockbiter Weapon | Rank 7 | 16316 | 54 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneskin Totem | Rank 6 | 10408 | 54 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Chain Lightning | Rank 4 | 10605 | 56 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flametongue Weapon | Rank 6 | 16342 | 56 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Grace of Air Totem | Rank 2 | 10627 | 56 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Wave | Rank 9 | 10396 | 56 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Bolt | Rank 10 | 15208 | 56 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lightning Shield | Rank 7 | 10432 | 56 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Magma Totem | Rank 4 | 10587 | 56 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Mana Spring Totem | Rank 4 | 10497 | 56 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Windwall Totem | Rank 3 | 15112 | 56 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Fire Resistance Totem | Rank 3 | 10538 | 58 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flametongue Totem | Rank 4 | 16387 | 58 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frost Shock | Rank 4 | 10473 | 58 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Frostbrand Weapon | Rank 5 | 16356 | 58 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Mana Tide Totem | Rank 4 | 1325256 | 58 | trainer (needs the talent) | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Stoneclaw Totem | Rank 6 | 10428 | 58 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Ancestral Spirit | Rank 5 | 20777 | 60 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Earth Shock | Rank 7 | 10414 | 60 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Flame Shock | Rank 6 | 29228 | 60 | book/drop (WH source 2) | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Grace of Air Totem | Rank 3 | 25359 | 60 | book/drop (WH source 2) | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Stream Totem | Rank 5 | 10463 | 60 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Healing Wave | Rank 10 | 25357 | 60 | book/drop (WH source 2) | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Lesser Healing Wave | Rank 6 | 10468 | 60 | trainer | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Nature Resistance Totem | Rank 3 | 10601 | 60 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Riptide | Rank 3 | 1239243 | 60 | trainer (needs the talent) | Restoration | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Searing Totem | Rank 6 | 10438 | 60 | trainer | Elemental Combat | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Strength of Earth Totem | Rank 5 | 25361 | 60 | book/drop (WH source 2) | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |
| Windfury Weapon | Rank 4 | 16362 | 60 | trainer | Enhancement | none (attr: not while shapeshifted) | GEMETEN (DB2 + WH) |

### Talent tree 1082: the active talents (GEMETEN, SpellMisc passive bit off; all other 43 nodes are passive)
| Talent | ID | Section | Row (points needed) | Earliest level (AFGELEID) | Later ranks |
|---|---|---|---|---|---|
| Water Shield | 408510 | Restoration | 3 (10) | 20 | - |
| Stormstrike | 17364 | Enhancement | 4 (15) | 25 (DB2 SpellLevels still says 40) | - |
| Mana Tide Totem | 16190 | Restoration | 4 (15) | 25 | trainer R2 38, R3 48, R4 58 |
| Nature's Swiftness | 16188 | Restoration | 5 (20) | 30 | - |
| Lightning Mastery | 16166 | Elemental | 7 (30) | 40 | - |
| Rage of the Farseer | 425336 | Enhancement | 7 (30) | 40 | - |
| Riptide | 408521 | Restoration | 7 (30) | 40 | trainer R2 50, R3 60 |
Two row-7 talents need 30 + 30 = 60 points and there are 51, so a Shaman has **at most one** of Lightning Mastery,
Rage of the Farseer and Riptide (AFGELEID from the numbers, which are GEMETEN).

### What Forever changed vs Classic Era (only where the data shows it; GEMETEN by ID comparison 70790 vs 1.15.9.70576)
- **Race/class**: Dwarf Shaman (Alliance) and Windshaper Skyborne Shaman are new (CharBaseInfo, above).
- **Gone**: Fire Nova Totem (all 5 ranks 1535/8498/8499/11314/11315: no longer in the Shaman skill lines) and Tranquil
  Air Totem 25908 (not in Forever SpellName). Old talent rank IDs are gone (talents are now tree nodes).
- **Fire Nova** (408341-408345) is now a trainer spell at 12/22/32/42/52 (AcquireMethod 3 → 0): it blasts enemies
  near *your active Fire totem* (10 s cooldown).
- **New spells**: Call of the Elements 66842 (20), Call of the Ancestors 66843 (30), Call of the Spirits 66844 (40):
  each "places up to 4 totems specified in the Totem Bar"; Totemic Recall 36936 (20): returns totems, refunds 25% mana;
  Riptide Rank 2/3 (1239242/1239243), Mana Tide Totem Rank 4 (1325256).
- **Renamed** (same ID): Elemental Mastery → **Lightning Mastery** 16166 (now: faster Lightning Bolt, no Chain
  Lightning cooldown, 3 min); Shamanistic Rage → **Rage of the Farseer** 425336 (attack speed +30%, 3 min);
  Totemic Projection → **Totemic Call** 437009 (moves your totems to you, 30 s, trainer 22).
- **Talents changed place**: Water Shield and Riptide (SoD runes, AcquireMethod 3 in Era) are now tree talents;
  Riptide also gets trainer ranks. Mana Tide Totem R2/R3 moved from 48/58 to 38/48.
- **Totem tools**: SpellTotems used the four totem *items* (Totem_0 5175/5176/5177/5178) in Era; Forever uses
  TotemCategory 2 Earth / 3 Air / 4 Fire / 5 Water Totem instead. TotemCategory 367 "Elemental Totem" (mask 15 = all
  four) exists; which item carries it I did not measure.
- Weapon imbues: the Forever descriptions say they last 60 minutes (GEMETEN text; Era text not compared).
- Dual Wield (674) is in the Shaman data only with AcquireMethod 3, as in Era: no dual wield (AFGELEID).

### Totems by element (GEMETEN: SpellTotems.RequiredTotemCategoryID + TotemCategory names)
| Earth (2) | Fire (4) | Water (5) | Air (3) |
|---|---|---|---|
| Stoneskin 4 (quest), Earthbind 6, Stoneclaw 8, Strength of Earth 10, Tremor 18 | Searing 10 (quest), Frost Resistance 24, Magma 26, Flametongue Totem 28 | Healing Stream 20 (quest), Poison Cleansing 22, Mana Tide 25*, Mana Spring 26, Fire Resistance 28, Disease Cleansing 38 | Grounding 30, Nature Resistance 30, Windfury Totem 32, Sentry 34, Windwall 36, Grace of Air 42 |
21 totems. Every totem **below level 20** is listed first in its column; from 20 on the totem bar exists (next section).

### Shared cooldowns (GEMETEN: SpellCategories.Category + SpellCooldowns.CategoryRecoveryTime, all ranks)
- **Earth Shock, Flame Shock, Frost Shock: one shared 6-second cooldown (Category 19).** Using any shock locks the
  other two. So if Earth Shock is the interrupt (E), a Flame Shock just before means no interrupt for up to 6 s.
- Others: Chain Lightning 6 s, Stormstrike 6 s, Fire Nova 10 s, Riptide 12 s, Earthbind 15 s, Grounding 15 s,
  Stoneclaw 30 s, Totemic Call 30 s, Nature's Swiftness / Lightning Mastery / Rage of the Farseer 3 min,
  Mana Tide 5 min, Astral Recall 15 min. Earth Shock interrupts (SpellEffect 68) and locks that school.

## States + conditions
**Shaman has exactly one state: Ghost Wolf** (2645, level 20 trainer; aura 36 shapeshift, form **16**). No stance, no
stealth.
- SpellShapeshiftForm 16 "Ghost Wolf" has **BonusActionBar = 0** (GEMETEN). Cat = 1, Bear/Dire Bear = 3, Battle/
  Defensive/Berserker = 1/2/3, Stealth = 1 for comparison. Blizzard's Forever ActionBarController switches bar 1 only
  through `C_ActionBar.HasBonusActionBar()` / `GetBonusBarIndex()` (GEMETEN in the source), so **Ghost Wolf does not page
  bar 1** and `[bonusbar:N]` cannot see it (AFGELEID from those two facts).
- EllesmereUI agrees: `CLASS_PAGING_STATES` has DRUID, ROGUE, WARRIOR (+Berserker on Forever) and no SHAMAN; its Forever
  rule pages bar 1 by `[bonusbar:1..4]` for every class (GEMETEN, file lines quoted in Sources).
- If a condition is ever needed: **`[form:1]`** (or `[stance:1]`) = Ghost Wolf, because it is the Shaman's only
  shapeshift form (AFGELEID, not tested in the client).
- **Recommendation: `states = {}`**. No key needs a different spell in Ghost Wolf: almost every Shaman spell carries the
  "not while shapeshifted" bit, the exceptions are Totemic Call and racials. Guarding base spells in Ghost Wolf would only
  make keys dead. R casts Ghost Wolf again to leave it (AFGELEID: vanilla shapeshift toggle).
- **The totem bar is not a state** but matters for the plan: Blizzard_ActionBar.toc on `forever` loads
  `Shared\MultiCastActionBarFrame.lua` for game types "camelot, wrath, cata" plus a Camelot override file, with
  `NUM_MULTI_CAST_PAGES = 3` and `NUM_MULTI_CAST_BUTTONS_PER_PAGE = 4` (GEMETEN). It shows when the Shaman has totem
  slots with spells (`numActiveSlots > 0`). That Forever is the "camelot" game type is AFGELEID (Camelot-only files on the
  forever branch). So from level 20 the player picks one totem per element per Call on Blizzard's own totem bar.

## Proposal per key
Same fixed tasks as every class; Druid parallels in the last column. Levels: `*` = talent (AFGELEID level),
`(q)` = quest. No state columns because there are no states; the "Ghost Wolf" note applies to every key.

| Key | Task | Spell (level) | Why / Druid parallel |
|---|---|---|---|
| 1 | main | Lightning Bolt (1) | Druid Wrath |
| 2 | rotation | Flame Shock (10) | DoT, Druid Moonfire |
| 3 | rotation | Stormstrike (25*, Enhancement) | empty for Elemental/Restoration (rule 4) |
| 4 | spender | Frost Shock (20) | no spender resource; 2nd shock (slow). Shares the shock cooldown |
| 5 | rotation | Searing Totem (10 q) | the damage totem (fire) |
| Shift-1 | AoE | Chain Lightning (32) | Druid Hurricane |
| Shift-2 | AoE | Chain Heal (40) | AoE heal, Druid Wild Growth |
| Shift-4 | AoE spender | Fire Nova (12) | needs an active fire totem (Searing/Magma) |
| Q | big cooldown | Lightning Mastery or Rage of the Farseer (40*) | at most one exists; empty for Restoration |
| F1 | cd 2 | Mana Tide Totem (25*, Restoration) | mana cooldown, Druid Innervate |
| Shift-3 | cd 3 | Nature's Swiftness (30*) | same as Druid |
| F3 | cd 4 | Ancestral Spirit (12) | resurrect, Druid Rebirth/Revive |
| Shift-F1 | cd 2b | Riptide (40*, Restoration) | instant heal on a cooldown, Druid Swiftmend |
| E | interrupt | Earth Shock (4) | the Shaman interrupt (SpellEffect 68) |
| R | movement | Ghost Wolf (20) | Druid Travel Form |
| Shift-R | movement 2 | Totemic Call (22) | brings your totems along; no shapeshift bit, so also from Ghost Wolf (AFGELEID) |
| F | taunt/help | Stoneclaw Totem (8) | "taunts creatures" around it, Druid Growl |
| Z | small defensive | Stoneskin Totem (4 q) | less melee damage; Shaman has no personal small defensive |
| X | defensive 2 | Grounding Totem (30) | eats one harmful spell |
| C | big defensive / big heal | Healing Wave (1) | Druid Healing Touch |
| Shift-Z | 2nd row (self buff) | Water Shield (20*) if learned, else Lightning Shield (8) | one shield at a time; Druid Thorns |
| Shift-X | 2nd row (group buff) | Strength of Earth Totem (10) | Druid Mark of the Wild |
| Shift-C | 2nd row (dispel) | Cure Poison (16) | same as Druid |
| V | CC | Earthbind Totem (6) | slow; Druid Entangling Roots |
| Shift-Q | CC/dispel | Purge (12) | removes enemy magic; Druid Hibernate |
| Shift-F | CC/dispel | Tremor Totem (18) | removes fear/charm/sleep from the party |
| Shift-V | CC/dispel | Cure Disease (22) | 2nd dispel; Druid Remove Curse |
| F2 | quick heal | Lesser Healing Wave (20) | Druid Regrowth |
| F4 | heal over time | Healing Stream Totem (20 q) | party heal over time; Druid Rejuvenation |
| Shift-E | racial | Blood Fury / War Stomp / Berserking / Stoneform / Skysight | one per race |
| Ctrl-1 | form 1 → totem set 1 | Call of the Elements (20) | drops the 4 totems of totem-bar page 1 |
| Ctrl-2 | form 2 → totem set 2 | Call of the Ancestors (30) | page 2 |
| Ctrl-3 | form 3 → totem set 3 | Call of the Spirits (40) | page 3 |
| T, Shift-T, G | potion, healthstone, trinket | fixed, not spells | |

**Totem scheme in one sentence:** every totem below level 20 has a block key by its job (Stoneskin Z, Earthbind V,
Stoneclaw F, Strength of Earth Shift-X, Searing 5, Tremor Shift-F, Healing Stream F4); from 20 the three Calls on Ctrl-1/2/3
drop whole sets that the player picks on Blizzard's totem bar; the few totems with a sharp job keep their own key
(Grounding X, Mana Tide F1); the rest (resistance totems, Windfury/Grace of Air, Mana Spring, cleansing totems, Sentry,
Windwall) live on the totem bar and count as "handled". This is AFGELEID (a design choice), not measured.
Rejected: one key per element with a modifier (`[mod:shift]` etc.) — the block already binds Shift-/Ctrl-/Alt- keys
separately, so a modifier inside the plain key's macro would never be seen (AFGELEID from the binding layout).

**Block D (player's own bar), suggested in this order:** Rockbiter Weapon (1), Flametongue Weapon (10), Frostbrand
Weapon (20), Windfury Weapon (30), Magma Totem (26), Totemic Recall (20), Astral Recall (30), Water Walking (28), and the
second racial (Shatter Curse / Cultivation / Rapid Regeneration / Find Treasure / Walk on Air). At most 9 for one
character at 60, so 3 of the 12 D places stay free. Water Breathing and Far Sight are "handled" (spellbook only).
Weapon imbues are on D because a Shaman keeps only one at a time on one weapon and it lasts an hour; which one depends on
the play style, so the player chooses (Rob's "players choose" rule).

## Draft Lua table (for review; NOT in the repo)
```lua
ns.FOREVER_BLOCK_CLASSES.SHAMAN = {
	-- Ghost Wolf (form 16) has no bonus bar (SpellShapeshiftForm.BonusActionBar = 0) and no key needs a different
	-- spell in it, so there are no states and no baseGuard. Condition if ever needed: [form:1].
	states = {},
	keys = {
		["1"] = { base = "Lightning Bolt" },
		["2"] = { base = "Flame Shock" },
		["3"] = { base = "Stormstrike" },
		["4"] = { base = "Frost Shock" },
		["5"] = { base = "Searing Totem" },
		["SHIFT-1"] = { base = "Chain Lightning" },
		["SHIFT-2"] = { base = "Chain Heal" },
		["SHIFT-4"] = { base = "Fire Nova" },
		["Q"] = { base = { "Lightning Mastery", "Rage of the Farseer" } },
		["F1"] = { base = "Mana Tide Totem" },
		["SHIFT-3"] = { base = "Nature's Swiftness" },
		["F3"] = { base = "Ancestral Spirit" },
		["SHIFT-F1"] = { base = "Riptide" },
		["E"] = { base = "Earth Shock" },
		["R"] = { base = "Ghost Wolf" },
		["SHIFT-R"] = { base = "Totemic Call" },
		["F"] = { base = "Stoneclaw Totem" },
		["Z"] = { base = "Stoneskin Totem" },
		["X"] = { base = "Grounding Totem" },
		["C"] = { base = "Healing Wave" },
		["SHIFT-Z"] = { base = { "Water Shield", "Lightning Shield" } },
		["SHIFT-X"] = { base = "Strength of Earth Totem" },
		["SHIFT-C"] = { base = "Cure Poison" },
		["V"] = { base = "Earthbind Totem" },
		["SHIFT-Q"] = { base = "Purge" },
		["SHIFT-F"] = { base = "Tremor Totem" },
		["SHIFT-V"] = { base = "Cure Disease" },
		["F2"] = { base = "Lesser Healing Wave" },
		["F4"] = { base = "Healing Stream Totem" },
		["SHIFT-E"] = { all = { "Blood Fury", "War Stomp", "Berserking", "Stoneform", "Skysight" } },
		["CTRL-1"] = { base = "Call of the Elements" },
		["CTRL-2"] = { base = "Call of the Ancestors" },
		["CTRL-3"] = { base = "Call of the Spirits" },
	},
	toBlockD = { "Rockbiter Weapon", "Flametongue Weapon", "Frostbrand Weapon", "Windfury Weapon", "Magma Totem",
		"Totemic Recall", "Astral Recall", "Water Walking",
		"Shatter Curse", "Cultivation", "Rapid Regeneration", "Find Treasure", "Walk on Air" },
	-- Placed through Blizzard's totem bar (Call of the Elements/Ancestors/Spirits) or the spellbook: count as handled.
	listed = { "Frost Resistance Totem", "Flametongue Totem", "Mana Spring Totem", "Poison Cleansing Totem",
		"Fire Resistance Totem", "Disease Cleansing Totem", "Nature Resistance Totem", "Windfury Totem", "Sentry Totem",
		"Windwall Totem", "Grace of Air Totem", "Water Breathing", "Far Sight" },
}
```
Checked by script (`s10_table.py`): every name above is spelled exactly as in SpellName 70790, and every one of the 55
active Shaman names is either on a key, in `toBlockD` or in `listed` (none left over). `luac -p` passes.
**Offline engine test** (`shaman_work/test_shaman.lua` + `s14_runtest.py`, stubbed APIs, the repo's real
`ForeverBlock.lua` loaded read-only, same method as the Druid test): with `states = {}` every macro is a plain
`#showtooltip /cast <name>`; a level-4 Orc gets 1, C, E, Z and Shift-E (Blood Fury) with Rockbiter + Shatter Curse on D;
a level-40 Restoration Dwarf gets 31 keys with Water Shield on Shift-Z; a Tauren with only Enhancement talents gets
Stormstrike on 3 and Rage of the Farseer on Q; the "not in MH's list" check reports only an invented test spell
(Mana Spring Totem and Water Breathing count as handled through `listed`). GEMETEN offline only, not in the client.

## Open questions for Rob
1. **Ctrl-1/2/3 = the three totem Calls** instead of forms (a Shaman has no combat forms). OK? Alternative: Ctrl-1 Call
   of the Elements, Ctrl-2 Totemic Recall, Ctrl-3 empty.
2. **Weapon imbues on block D** (all four), or one imbue key on the block? A single key with a fixed order would pick
   Windfury at 30 also for casters, so I did not do that. If you want one on the block: Shift-X could become the imbue
   and Strength of Earth Totem go to the totem bar.
3. **Key 3 is Stormstrike only**, so it stays empty for an Elemental or Restoration Shaman. Fill it for casters (with
   what)?
4. **The shared shock cooldown**: 2 (Flame Shock), 4 (Frost Shock) and E (Earth Shock) block each other for 6 s. Fine as
   is, or keep 4 for something else (Fire Nova, Magma Totem)?
5. **Shift-Z**: once a Restoration Shaman has Water Shield, Lightning Shield is no longer on the block. OK?
6. **Racial choice**: Orc gets Blood Fury on Shift-E (Shatter Curse to D); Windshaper Skyborne gets Skysight (Walk on
   Air to D). Swap either?
7. **Shift-R = Totemic Call** (moves totems to you) or Water Walking?
8. **Test in the client at 20**: does a spell pressed in Ghost Wolf cancel the wolf and cast, or give an error? If it
   errors, the macros may need a `/cancelform` line (engine change).
9. **Test at 20**: does Blizzard's totem bar appear, and can its buttons be bound? (Not needed for this plan, but it
   decides how comfortable the Calls are.)
10. **Test at 25**: is Stormstrike really pickable at 25 (row rule) although DB2 SpellLevels says 40?
11. **For the Druid table too**: Skyborne can be Druid (CharBaseInfo 900/903), but Druid Shift-E has no Skyborne racial;
    and the "Talented" account unlock can make all `*` talent levels up to 5 earlier.

## What is GEMETEN vs AFGELEID
GEMETEN (named source, 5 Nov 2026):
- Every spell ID, rank, level, tab and AcquireMethod in the table (DB2 70790); trainer/quest/book source (WH listview,
  matched by ID); the three quest names (WH quest tabs); talent nodes, rows and points (TraitNode/TraitCond/
  TraitCurrencySource); the "Talented" node text.
- Race/class combos and the Era comparison (CharBaseInfo 70790 vs 1.15.9); racial IDs, race masks and cooldowns.
- Shock cooldown sharing (Category 19, 6000 ms); all other cooldowns listed; Earth Shock interrupt effect.
- Ghost Wolf = form 16 with BonusActionBar 0; the "not while shapeshifted" bit per spell; EllesmereUI has no Shaman
  paging; the totem bar files, page/button constants and the camelot load condition in Blizzard's forever UI source.
- Totem element per spell (SpellTotems + TotemCategory); the changes vs Classic Era listed above.

AFGELEID (reasoning, not measured in the client):
- Talent earliest levels (`*`), and that only one row-7 talent fits in 51 points.
- What the 0x10000 bit does in Forever (fail vs auto-cancel), that R toggles Ghost Wolf off, that `[form:1]` = Ghost Wolf,
  and that Totemic Call works from Ghost Wolf.
- That Forever is the "camelot" UI game type, and when exactly the totem bar shows.
- That mask bit 32/33 = High Order/Windshaper Skyborne (via PlayableRaceBit).
- That Shamans cannot dual wield (only an AcquireMethod-3 row).
- The whole key proposal, the totem scheme, block D and `listed` choices (design judgment; see the open questions).
- Not measured at all: which item has TotemCategory "Elemental Totem"; whether the level-60 books (Flame Shock R6, Grace
  of Air R3, Strength of Earth R5, Healing Wave R10, WH source 2) can drop yet; trainer costs (WH only, not used).
