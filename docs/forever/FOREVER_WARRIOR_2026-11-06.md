# WoW Forever — Warrior: spells tot 60 + VOORSTEL voor het toetsenblok

> 🌙 **Nacht 5→6 nov 2026, onderzoek door mh-research (één helper per class). NIET goedgekeurd door Rob, NIET in de
> addon.** Alleen een goedgekeurde tabel komt in `Modules/ForeverBlock_<Class>.lua`.
>
> **Zelf nagekeken in de nacht (GEMETEN):**
> - beginspells staan in Blizzards data met AcquireMethod 2: Battle Stance 2457, Heroic Strike 78 (wago wowf 1.60.1.70790, SkillLineAbility);
> - de concepttabel hieronder laadt in de échte motor (`Modules/ForeverBlock.lua`, offline met nagebootste spells):
>   elke spellnaam bestaat in SpellName, elke toets is een blok-plek, geen spell op twee toetsen;
> - stance/vorm-nummers: SpellShapeshiftForm.BonusActionBar (Cat 1, Bear 3, Stealth 1, Battle 1, Defensive 2,
>   Berserker 3, Moonkin/Shadowform/Ghost Wolf 0).
> - Niet in het spel getest. Elke toetskeuze is een voorstel (AFGELEID).
> - Voor alle classes geldt (helpers, GEMETEN in de data): een account-perk 'Talented' geeft al talentpunten vanaf
>   level 5-9, dus talent-levels hieronder kunnen tot 5 levels vroeger zijn.

**Aandachtspunten van de nachtcontrole:**
- Toets 2 is hier 'stance-aanval' (Overpower/Revenge/Whirlwind); bij de Druid is 2 de bloeding/DoT. Bewuste keuze van de helper, Rob beslist.

---

# WoW Forever Warrior: spells 1-60, stances and key-block proposal (client 1.60.1.70790)

Researched in the night of 5 to 6 Nov 2026. Read only: nothing in the repo was changed. Class token `WARRIOR`,
ChrClasses ID 1, one spec: ChrSpecialization 1491 "Warrior" (GEMETEN, DB2).

## Sources
- **DB2** = wago.tools, product `wowf`, build **1.60.1.70790** (the tables in `scratchpad\wago_wowf\`, fetched 5 Nov 2026
  about 23:25 according to its README). I fetched four more tables of the same build myself that night with plain
  curl: `SkillLineXTraitTree`, `CharBaseInfo`, `ChrRaces`, `SpellCastTimes` (in `forever_classes\warrior_work\`).
  Tables used: SkillLineAbility (SkillLine 26 Arms, 256 Fury, 257 Protection), SpellName, Spell (rank subtext and text),
  SpellLevels, SpellMisc (passive bit 0x40), SpellShapeshift, SpellShapeshiftForm, SpellEffect (teach spells),
  SpellCooldowns, SpellCategories, Trait* (talents), CharBaseInfo + ChrRaces (which races can be a Warrior).
- **Era** = Classic Era DB2 build **1.15.9.70576** (SpellShapeshift, SkillLineAbility, SpellLevels, SpellCooldowns,
  SpellMisc), fetched by me with curl the same night, for the "what Forever changed" list.
- **WH** = Wowhead Forever `wowhead.com/forever/spells/abilities/warrior`: 177 rows, read from the page's own listview data
  (`g_listviews.spells.data`) in the in-app browser that night; `source` 6 = trainer, 4 = quest, 2 = drop/book. Also the
  spell pages of Defensive Stance (71) and Berserker Stance (2458), "Reward from quest" tab. Tab closed afterwards.
- **UI** = Blizzard UI source, `github.com/Gethe/wow-ui-source`, branch `forever`, newest commit "1.60.1 (70790)",
  4 Nov 2026 18:16 UTC: `Blizzard_ActionBarController/ActionBarController.lua` lines 145-182 and
  `Blizzard_APIDocumentationGenerated/ActionBarFrameDocumentation.lua` (GetBonusBarOffset, GetBonusBarIndex).
- **EUI** = EllesmereUI in `E:\World of Warcraft\_forever_\Interface\AddOns\`: `EllesmereUI\EllesmereUI_VisibilityRules.lua`
  lines 56-85 and `EllesmereUIActionBars\EUI_ActionBars_Paging.lua` lines 128-132 and 197-203. Another addon: a
  candidate, not proof.
- **MH code** (read only): `Modules\ForeverBlock.lua` (engine, header), `Modules\ForeverBlock_Druid.lua`,
  `Modules\KeyBlock.lua` lines 22-116, `Modules\KeybindRoles_Warrior.lua` (how MH files retail Warrior spells).
- **Druid example**: I used `scratchpad\forever_druid_spells.md` and the Druid Lua table. I did **not** read the two
  Druid files under `MidnightHelper\docs\` (my own agent rule forbids reading `docs\`), so the table shape below is
  copied from the Lua table, not from the PLAN document.
- **kami-labs.fr**, "WoW Forever Warrior: Every Changed Spell and Talent", published 30 Sep 2026 (beta era). Used only to
  back up what DB2 already shows.

## Positive control: PASSES inside DB2 (GEMETEN), not yet seen in a Warrior client
| What | DB2 70790 |
|---|---|
| Level-1 starting spells (AcquireMethod 2) | **Battle Stance 2457** (Arms, level 1) and **Heroic Strike Rank 1 78** (Arms, level 1). Both found. |
| Also at level 1 | Battle Shout Rank 1 6673, level 1, AcquireMethod 0; WH: trainer, 10 copper. |
| Same check that works for the Druid | AcquireMethod 2 = starting spell was confirmed on Rob's Druid (5185, 5176). |
| Search pattern itself | The Era grep for new IDs found Cultivation 20552 and Victory Rush 402927, so "not found" for the others means something. |
| Spec | ChrSpecialization 1491 = "Warrior", ClassID 1. |
| Talent tree link | SkillLineXTraitTree row 165: SkillLine 26 (Arms) -> TraitTree **1117**. The Druid row 158 (574 -> 1089) is in the same file, as the Druid research said. |

Nobody has looked at a Warrior in Rob's client yet. A level-1 check is in "Open questions".

## Spell list 1-60 (117 active rows, 42 spell names)
Legend:
- `*` level = talent. The number is the earliest level its row opens: row n needs 5 x (n-1) points spent in that section
  (TraitCond SpentAmountRequired 5/10/15/20/25/30), and TraitCurrency 3820 gives one point per level from 10 to 60
  (TraitCurrencySource "Level 10" ... "Level 60", 51 rows; GEMETEN). So row 3 = 20, row 4 = 25, row 5 = 30, row 7 = 40.
  That reading is AFGELEID (it assumes every point goes into that one section).
- Stance = DB2 SpellShapeshift mask (GEMETEN): form 17 Battle, 18 Defensive, 19 Berserker. "any" = no SpellShapeshift row
  for the spell, read as "usable in every stance" (AFGELEID, the normal meaning of no mask).
- "GEMETEN (DB2 + WH)": ID, rank and level from DB2, and WH lists the same ID at the same level. For all 107 non-talent
  rows the WH level equals the DB2 level (script check, 0 differences).

| Spell | Rank | ID | Level | How learned | Tab | Stance | Measured? |
|---|---|---|---|---|---|---|---|
| Battle Shout | Rank 1 | 6673 | 1 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Battle Stance | - | 2457 | 1 | starting spell (DB2 AcquireMethod 2) | Arms | (is a stance) | GEMETEN (DB2 + WH) |
| Heroic Strike | Rank 1 | 78 | 1 | starting spell (DB2 AcquireMethod 2) | Arms | any | GEMETEN (DB2 + WH) |
| Charge | Rank 1 | 100 | 4 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Rend | Rank 1 | 772 | 4 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Thunder Clap | Rank 1 | 6343 | 6 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Hamstring | Rank 1 | 1715 | 8 | trainer | Arms | Battle+Berserker | GEMETEN (DB2 + WH) |
| Heroic Strike | Rank 2 | 284 | 8 | trainer | Arms | any | GEMETEN (DB2 + WH) |
| Bloodrage | - | 2687 | 10 | trainer | Protection | any | GEMETEN (DB2 + WH) |
| Defensive Stance | - | 71 | 10 | quest (see "Quests" below; teach spell 8121 Path of Defense learns 71 + 7386 + 355) | Protection | (is a stance) | GEMETEN (DB2 + WH) |
| Rend | Rank 2 | 6546 | 10 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Sunder Armor | Rank 1 | 7386 | 10 | quest (comes with Defensive Stance, teach spell 8121) | Protection | any | GEMETEN (DB2 + WH, WH gives no source) |
| Taunt | - | 355 | 10 | quest (comes with Defensive Stance, teach spell 8121) | Protection | Defensive | GEMETEN (DB2 + WH, WH gives no source) |
| Battle Shout | Rank 2 | 5242 | 12 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Overpower | Rank 1 | 7384 | 12 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Shield Bash | Rank 1 | 72 | 12 | trainer | Protection | Battle+Defensive | GEMETEN (DB2 + WH) |
| Demoralizing Shout | Rank 1 | 1160 | 14 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Revenge | Rank 1 | 6572 | 14 | trainer | Protection | Defensive | GEMETEN (DB2 + WH) |
| Heroic Strike | Rank 3 | 285 | 16 | trainer | Arms | any | GEMETEN (DB2 + WH) |
| Mocking Blow | Rank 1 | 694 | 16 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Shield Block | - | 2565 | 16 | trainer | Protection | Defensive | GEMETEN (DB2 + WH) |
| Disarm | - | 676 | 18 | trainer | Protection | Defensive | GEMETEN (DB2 + WH) |
| Thunder Clap | Rank 2 | 8198 | 18 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Cleave | Rank 1 | 845 | 20 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Last Stand | - | 12975 | 20* | TALENT (Protection section, row 3) | Protection | any | GEMETEN (DB2 tree 1117); level AFGELEID |
| Piercing Howl | - | 12323 | 20* | TALENT (Fury section, row 3) | Fury | any | GEMETEN (DB2 tree 1117); level AFGELEID |
| Rend | Rank 3 | 6547 | 20 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Retaliation | - | 20230 | 20 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Slam | Rank 1 | 1240193 | 20 | trainer (NEW ID, not in Era) | Fury | any | GEMETEN (DB2 + WH) |
| Victory Rush | - | 402927 | 20 | trainer (was AcquireMethod 3 in Era) | Arms | any | GEMETEN (DB2 + WH, 4000c) |
| Battle Shout | Rank 3 | 6192 | 22 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Intimidating Shout | - | 5246 | 22 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Sunder Armor | Rank 2 | 7405 | 22 | trainer | Protection | any | GEMETEN (DB2 + WH) |
| Demoralizing Shout | Rank 2 | 6190 | 24 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Execute | Rank 1 | 5308 | 24 | trainer | Fury | Battle+Berserker | GEMETEN (DB2 + WH) |
| Heroic Strike | Rank 4 | 1608 | 24 | trainer | Arms | any | GEMETEN (DB2 + WH) |
| Revenge | Rank 2 | 6574 | 24 | trainer | Protection | Defensive | GEMETEN (DB2 + WH) |
| Reckless Swings | - | 1329555 | 25* | TALENT (Fury section, row 4; NEW, not in Era) | Fury | any | GEMETEN (DB2 tree 1117); level AFGELEID |
| Spearing Strike | - | 1310222 | 25* | TALENT (Arms section, row 4; NEW, not in Era) | Arms | Battle | GEMETEN (DB2 tree 1117); level AFGELEID |
| Challenging Shout | - | 1161 | 26 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Charge | Rank 2 | 6178 | 26 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Mocking Blow | Rank 2 | 7400 | 26 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Overpower | Rank 2 | 7887 | 28 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Shield Wall | - | 871 | 28 | trainer | Protection | Defensive | GEMETEN (DB2 + WH) |
| Thunder Clap | Rank 3 | 8204 | 28 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Berserker Rage | - | 18499 | 30 | trainer (Era: 32) | Fury | Berserker | GEMETEN (DB2 + WH) |
| Berserker Stance | - | 2458 | 30 | quest The Affray 1719 (WH); teach spell 8616 Path of the Berserker learns 2458 + 20252 | Fury | (is a stance) | GEMETEN (DB2 + WH) |
| Cleave | Rank 2 | 7369 | 30 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Concussion Blow | - | 12809 | 30* | TALENT (Protection section, row 5) | Protection | any | GEMETEN (DB2 tree 1117); level AFGELEID |
| Death Wish | - | 12328 | 30* | TALENT (Fury section, row 5) | Fury | any | GEMETEN (DB2 tree 1117); level AFGELEID |
| Intercept | Rank 1 | 20252 | 30 | quest (comes with Berserker Stance, teach spell 8616) | Fury | Berserker | GEMETEN (DB2 + WH, WH gives no source) |
| Rend | Rank 4 | 6548 | 30 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Slam | Rank 2 | 1464 | 30 | trainer (was Rank 1 in Era) | Fury | any | GEMETEN (DB2 + WH) |
| Sweeping Strikes | - | 12292 | 30* | TALENT (Arms section, row 5) | Arms | Battle | GEMETEN (DB2 tree 1117); level AFGELEID |
| Battle Shout | Rank 4 | 11549 | 32 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Execute | Rank 2 | 20658 | 32 | trainer | Fury | Battle+Berserker | GEMETEN (DB2 + WH) |
| Hamstring | Rank 2 | 7372 | 32 | trainer | Arms | Battle+Berserker | GEMETEN (DB2 + WH) |
| Heroic Strike | Rank 5 | 11564 | 32 | trainer | Arms | any | GEMETEN (DB2 + WH) |
| Shield Bash | Rank 2 | 1671 | 32 | trainer | Protection | Battle+Defensive | GEMETEN (DB2 + WH) |
| Demoralizing Shout | Rank 3 | 11554 | 34 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Revenge | Rank 3 | 7379 | 34 | trainer | Protection | Defensive | GEMETEN (DB2 + WH) |
| Sunder Armor | Rank 3 | 8380 | 34 | trainer | Protection | any | GEMETEN (DB2 + WH) |
| Mocking Blow | Rank 3 | 7402 | 36 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Whirlwind | - | 1680 | 36 | trainer | Fury | Berserker | GEMETEN (DB2 + WH) |
| Pummel | Rank 1 | 6552 | 38 | trainer | Fury | Berserker | GEMETEN (DB2 + WH) |
| Slam | Rank 3 | 8820 | 38 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Thunder Clap | Rank 4 | 8205 | 38 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Bloodthirst | Rank 1 | 23881 | 40* | TALENT (Fury section, row 7) | Fury | any | GEMETEN (DB2 tree 1117); level AFGELEID |
| Cleave | Rank 3 | 11608 | 40 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Execute | Rank 3 | 20660 | 40 | trainer | Fury | Battle+Berserker | GEMETEN (DB2 + WH) |
| Heroic Strike | Rank 6 | 11565 | 40 | trainer | Arms | any | GEMETEN (DB2 + WH) |
| Mortal Strike | Rank 1 | 12294 | 40* | TALENT (Arms section, row 7) | Arms | any | GEMETEN (DB2 tree 1117); level AFGELEID |
| Rend | Rank 5 | 11572 | 40 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Shield Slam | Rank 1 | 23922 | 40* | TALENT (Protection section, row 7) | Protection | any | GEMETEN (DB2 tree 1117); level AFGELEID |
| Battle Shout | Rank 5 | 11550 | 42 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Intercept | Rank 2 | 20616 | 42 | trainer | Fury | Berserker | GEMETEN (DB2 + WH) |
| Demoralizing Shout | Rank 4 | 11555 | 44 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Overpower | Rank 3 | 11584 | 44 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Revenge | Rank 4 | 11600 | 44 | trainer | Protection | Defensive | GEMETEN (DB2 + WH) |
| Charge | Rank 3 | 11578 | 46 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Mocking Blow | Rank 4 | 20559 | 46 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Slam | Rank 4 | 11604 | 46 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Sunder Armor | Rank 4 | 11596 | 46 | trainer | Protection | any | GEMETEN (DB2 + WH) |
| Bloodthirst | Rank 2 | 23892 | 48 | trainer (needs the talent) | Fury | any | GEMETEN (DB2 + WH) |
| Execute | Rank 4 | 20661 | 48 | trainer | Fury | Battle+Berserker | GEMETEN (DB2 + WH) |
| Heroic Strike | Rank 7 | 11566 | 48 | trainer | Arms | any | GEMETEN (DB2 + WH) |
| Mortal Strike | Rank 2 | 21551 | 48 | trainer (needs the talent) | Arms | any | GEMETEN (DB2 + WH) |
| Shield Slam | Rank 2 | 23923 | 48 | trainer (needs the talent) | Protection | any | GEMETEN (DB2 + WH) |
| Thunder Clap | Rank 5 | 11580 | 48 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Cleave | Rank 4 | 11609 | 50 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Recklessness | - | 1719 | 50 | trainer | Fury | Berserker | GEMETEN (DB2 + WH) |
| Rend | Rank 6 | 11573 | 50 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Battle Shout | Rank 6 | 11551 | 52 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Intercept | Rank 3 | 20617 | 52 | trainer | Fury | Berserker | GEMETEN (DB2 + WH) |
| Shield Bash | Rank 3 | 1672 | 52 | trainer | Protection | Battle+Defensive | GEMETEN (DB2 + WH) |
| Bloodthirst | Rank 3 | 23893 | 54 | trainer (needs the talent) | Fury | any | GEMETEN (DB2 + WH) |
| Demoralizing Shout | Rank 5 | 11556 | 54 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Hamstring | Rank 3 | 7373 | 54 | trainer | Arms | Battle+Berserker | GEMETEN (DB2 + WH) |
| Mortal Strike | Rank 3 | 21552 | 54 | trainer (needs the talent) | Arms | any | GEMETEN (DB2 + WH) |
| Revenge | Rank 5 | 11601 | 54 | trainer | Protection | Defensive | GEMETEN (DB2 + WH) |
| Shield Slam | Rank 3 | 23924 | 54 | trainer (needs the talent) | Protection | any | GEMETEN (DB2 + WH) |
| Slam | Rank 5 | 11605 | 54 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Execute | Rank 5 | 20662 | 56 | trainer | Fury | Battle+Berserker | GEMETEN (DB2 + WH) |
| Heroic Strike | Rank 8 | 11567 | 56 | trainer | Arms | any | GEMETEN (DB2 + WH) |
| Mocking Blow | Rank 5 | 20560 | 56 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Pummel | Rank 2 | 6554 | 58 | trainer | Fury | Berserker | GEMETEN (DB2 + WH) |
| Sunder Armor | Rank 5 | 11597 | 58 | trainer | Protection | any | GEMETEN (DB2 + WH) |
| Thunder Clap | Rank 6 | 11581 | 58 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Battle Shout | Rank 7 | 25289 | 60 | book/drop (WH source 2) | Fury | any | GEMETEN (DB2 + WH) |
| Bloodthirst | Rank 4 | 23894 | 60 | trainer (needs the talent) | Fury | any | GEMETEN (DB2 + WH) |
| Cleave | Rank 5 | 20569 | 60 | trainer | Fury | any | GEMETEN (DB2 + WH) |
| Heroic Strike | Rank 9 | 25286 | 60 | book/drop (WH source 2) | Arms | any | GEMETEN (DB2 + WH) |
| Mortal Strike | Rank 4 | 21553 | 60 | trainer (needs the talent) | Arms | any | GEMETEN (DB2 + WH) |
| Overpower | Rank 4 | 11585 | 60 | trainer | Arms | Battle | GEMETEN (DB2 + WH) |
| Rend | Rank 7 | 11574 | 60 | trainer | Arms | Battle+Defensive | GEMETEN (DB2 + WH) |
| Revenge | Rank 6 | 25288 | 60 | book/drop (WH source 2) | Protection | Defensive | GEMETEN (DB2 + WH) |
| Shield Slam | Rank 4 | 23925 | 60 | trainer (needs the talent) | Protection | any | GEMETEN (DB2 + WH) |

"Trainer (needs the talent)" for Mortal Strike, Bloodthirst and Shield Slam Ranks 2-4: WH source 6 (trainer, 2000 /
2800 / 3100 copper). That you must have Rank 1 first is AFGELEID (Classic rule; not checked in the client).

**Passive, not in the table:** Tactical Mastery 1310185 (trainer, level 14, 1500c, WH; NEW: "You retain up to 10 Rage when
you change Stances", DB2 text), Battle/Defensive/Berserker Stance Passive, all passive talents.

**Ranged pull (not class skill lines):** Shoot Bow 2480, Shoot Gun 7918, Shoot Crossbow 7919, Throw 2764 come with the
weapon skill (SkillLineAbility AcquireMethod 1, ClassMask includes Warrior; GEMETEN). Which one a character has depends
on its weapon skills.

### Quests (WH Forever, "Reward from quest", read that night)
- Defensive Stance 71, level 10: Path of Defense 1498 (Horde), Bartleby's Mug 1665 (Alliance), Vejrek 1678 (Alliance),
  Vorlus Vilehoof 1683 (Alliance), Ulag the Cleaver 1819 (Horde), **The Skybreaker Bulwark 94003** (WH reqrace bit 32 =
  High Order Skyborne, AFGELEID from the bit). Also item 6619 "Manual: The Path of Defense".
- Berserker Stance 2458, level 30: **The Affray 1719** (both factions). Also item 6897 "Manual: Path of the Berserker".
- DB2 teach spells (SpellEffect 36, GEMETEN): 8121 "Path of Defense" learns Defensive Stance 71 + Sunder Armor 7386 +
  Taunt 355; 8616 "Path of the Berserker" learns Berserker Stance 2458 + Intercept 20252. That is why WH shows Sunder
  Armor R1, Taunt and Intercept R1 without a source.

### Talent tree (GEMETEN: TraitTree 1117, 53 nodes, three sections, currency 3820 = 51 points)
Active talent spells (SpellMisc passive bit off), with row by node PosY (2130 = row 1 ... 5730 = row 7):
- Arms: Spearing Strike 1310222 (row 4, needs Battle Stance), Sweeping Strikes 12292 (row 5, Battle), Mortal Strike 12294 (row 7).
- Fury: Piercing Howl 12323 (row 3), Reckless Swings 1329555 (row 4), Death Wish 12328 (row 5), Bloodthirst 23881 (row 7).
- Protection: Last Stand 12975 (row 3), Concussion Blow 12809 (row 5), Shield Slam 23922 (row 7).
- All other nodes are passive. Two passives change how keys behave:
  **Vanguard** 1310317 (Protection row 4): "Your Charge ability is now usable while in Defensive Stance". DB2: aura 332
  swaps Charge 100/6178/11578 for Charge 1240287/1240288/1240289, whose mask is Battle+Defensive (GEMETEN).
  **Bloodthrill** 1289682 (Arms row 5): Overpower can also light up from Rend hits (DB2 text).

### Racials (races that can be a Warrior: CharBaseInfo ClassID 1, GEMETEN)
Human 1, Orc 2, Dwarf 3, Night Elf 4, Undead 5, Tauren 6, Gnome 7, Troll 8, **High Order Skyborne 95** (Alliance) and
**Windshaper Skyborne 96** (Horde). Active racials (SkillLineAbility, AcquireMethod 2, passive bit off; GEMETEN):

| Race | Racial 1 (proposed for Shift-E) | Racial 2 (proposed for block D) |
|---|---|---|
| Human | Will to Survive 1259718 ("Instantly removes all Stun effects"; ID not in Era) | Perception 20600 |
| Orc | Blood Fury 20572 | Shatter Curse 1299026 (removes Curses, less magic damage; not in Era) |
| Dwarf | Stoneform 20594 | Find Treasure 2481 |
| Night Elf | Shadowmeld 20580 (same as the Druid table) | Elune's Light 1259799 (not in Era) |
| Undead | Will of the Forsaken 7744 | Cannibalize 20577 |
| Tauren | War Stomp 20549 | Cultivation 20552 (active "Racial" in Forever) |
| Gnome | Escape Artist 20589 | Eureka! 1259813 (the Warrior version, ClassMask 1; not in Era) |
| Troll | Berserking 20554 | Rapid Regeneration 1260270 (no "Racial" subtext; not in Era) |
| High Order Skyborne | Walk on Air 1259416 (both Skyborne) | Read Leyline 1259705 (RaceMasks_1 bit 0 = race 95) |
| Windshaper Skyborne | Walk on Air 1259416 | Skysight 1259686 (RaceMasks_1 bit 1 = race 96) |

### What Forever changed compared with Classic Era 1.15.9.70576 (GEMETEN, script compare of the two DB2 builds)
- **Thunder Clap**: usable in Battle **and Defensive** Stance (Era: Battle only); cooldown 6 s (Era 4 s). kami-labs says the same about Defensive.
- **Victory Rush** 402927: AcquireMethod 3 -> 0, level 1 -> 20, trainer (WH 4000c); cooldown 30 s (Era 8 s). Heals (SpellEffect 136, base 10).
- **Slam**: new Rank 1 1240193 at level 20; the old 1464 is now "Rank 2" at 30. Cast 1.5 s in both builds, but Forever adds a **15 s cooldown** (Era none).
- **Berserker Rage**: level 32 -> 30.
- **Taunt**: cooldown 10 s -> 8 s.
- **Retaliation** and **Shield Wall**: each its own 15 min cooldown (Era: 30 min on the spell category). **Recklessness**: 30 min, own cooldown.
- **Last Stand**: cooldown 10 min -> 3 min.
- New: Tactical Mastery 1310185 (baseline passive, 14), Spearing Strike, Reckless Swings, Vanguard, Bloodthrill and more passives in the new tree.
- Not learnable (AcquireMethod 3 in Forever, WH lists them with no source): Devastate 403196, Raging Blow 402911, Quick
  Strike 429765, Commanding Shout 403215, Rallying Cry 426490, Enraged Regeneration 402913, Meathook 403228, Shockwave
  440488, Valor of Azeroth 461475 (Season of Discovery rune spells). The files also still hold the "Engraving" skill line
  with rune-engrave spells. Whether Forever has runes at all is **not measured**; I treat these as not learnable
  (AFGELEID; Victory Rush, the one rune spell that became a trainer spell, has AcquireMethod 0).

## States + macro conditions
The Warrior has **three states: Battle, Defensive and Berserker Stance**. No stealth, no swim state needed.

| State | Macro condition | Evidence |
|---|---|---|
| Battle Stance (form 17) | `[bonusbar:1]` | DB2 SpellShapeshiftForm row 17: BonusActionBar **1** (GEMETEN). EUI WARRIOR "battle" = `[bonusbar:1]`. |
| Defensive Stance (form 18) | `[bonusbar:2]` | DB2 row 18: BonusActionBar **2** (GEMETEN). EUI "defensive" = `[bonusbar:2]`. |
| Berserker Stance (form 19) | `[bonusbar:3]` | DB2 row 19: BonusActionBar **3** (GEMETEN). EUI adds "berserker" = `[bonusbar:3]` only when IS_FOREVER, with the comment that on Forever Berserker Stance has bonus bar 3. |

- How the client uses it (UI, GEMETEN): `ActionBarController_UpdateAll` pages the main bar to `C_ActionBar.GetBonusBarIndex()`
  when `C_ActionBar.HasBonusActionBar()` and the page is 1 (lines 160-171). EUI's Forever paging mirrors that as
  `[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10`, "for EVERY class (vanilla warrior stances ...)".
- That `[bonusbar:N]` is true when GetBonusBarOffset() equals the form's BonusActionBar is AFGELEID (standard macro rule;
  the condition itself is resolved inside the client, not in Lua). Two independent sources (DB2 numbers and EUI's
  Forever-only code) agree, and the Druid table uses the same mechanism.
- Why not `[stance:1/2/3]`: the stance number is the button's place on the stance bar. A Warrior who skips the level-10
  Defensive Stance quest would have Berserker as stance 2. The bonus bar number belongs to the form and does not move.
  (StanceBarOrder in DB2: Defensive 1, Berserker 2, Battle has no row; GEMETEN. The rest is AFGELEID.)
- A Warrior is always in one of the three stances once Battle Stance is known (AFGELEID, vanilla behaviour). So every
  key below uses a stance column only for spells that need that stance, and a plain spell for "any stance" spells.
- **No guards needed.** In the Druid table, Bear and Cat guard the base spell because caster spells fail there. For the
  Warrior, every "any" spell works in every stance, and no key mixes an "any" spell with stance spells. `baseGuard` is
  left out (the engine only uses it when a state has `guards = true`; ForeverBlock.lua line 129).
- One exception to the "mask decides" rule: **R in Defensive = Charge** only works with the Vanguard talent. Without it,
  pressing R in Defensive gives the game's red "wrong stance" error. Whether `/cast Charge` casts the Vanguard version
  (1240287-89) is AFGELEID; it needs a test.

Side note for the Druid table (not my class, but measured on the way): DB2 SpellShapeshiftForm row 31 Moonkin Form
has BonusActionBar **0**, and EUI removes the Moonkin paging state on Forever. The comment in ForeverBlock_Druid.lua
("4 = Moonkin") is therefore probably wrong. The Druid table is not affected: it has no Moonkin state and its guard
only covers 1-3.

## Proposal per key
Columns: "all" = the same spell in every stance (no condition). A stance column = `[bonusbar:N] spell`. "-" = that key
does nothing in that stance (empty place, no error). Levels in brackets; `*` = talent (earliest level, AFGELEID).
Every spell name below is exactly as in SpellName.csv. The macro casts the highest rank by name.

How I chose (AFGELEID, please check): (1) the stance columns follow the DB2 masks exactly; (2) a spell that works in
every stance sits on one key in all three stances, so its place never moves; (3) spells that need *different* stances
share a key when they do the same kind of job (Overpower / Revenge / Whirlwind; Shield Bash / Pummel; Charge /
Intercept; Mocking Blow / Taunt); (4) where the Druid has the same spell, the Warrior gets the same key (Maul -> Heroic
Strike on 1, Faerie Fire -> Sunder Armor on 5, Swipe -> Thunder Clap on Shift-1, Demoralizing Roar -> Demoralizing Shout
on Shift-2, Growl -> Taunt on F, Challenging Roar -> Challenging Shout on Shift-F, Mark of the Wild -> Battle Shout on
Shift-X, Barkskin -> Shield Block on Z); (5) where MH's retail Warrior list already decided (KeybindRoles_Warrior.lua),
I followed it: Victory Rush F2, Berserker Rage Shift-V, Cleave Shift-4, Pummel E, Taunt F, Shield Block Z, Shield Wall C,
Execute spender, Recklessness on Q; (6) what did not fit went to bar C in KeyBlock's own overflow order (KeyBlock.lua
line 115: Ctrl keys, then Shift-V, Shift-C, Shift-X, Shift-Z).

| Key | Task | all | Battle `[bonusbar:1]` | Defensive `[bonusbar:2]` | Berserker `[bonusbar:3]` |
|---|---|---|---|---|---|
| 1 | main | Heroic Strike (1) | | | |
| 2 | rotation | | Overpower (12) | Revenge (14) | Whirlwind (36) |
| 3 | rotation | Mortal Strike / Bloodthirst / Shield Slam (40*, first one known) | | | |
| 4 | spender | | Execute (24) | - | Execute (24) |
| 5 | rotation | Sunder Armor (10) | | | |
| Shift-1 | AoE | | Thunder Clap (6) | Thunder Clap (6) | - |
| Shift-2 | AoE | Demoralizing Shout (14) | | | |
| Shift-4 | 2nd spender | Cleave (20) | | | |
| Q | big cooldown | | Sweeping Strikes (30*) | - | Recklessness (50) |
| F1 | cd2 | Bloodrage (10) | | | |
| Shift-3 | cd3 | Death Wish (30*) | | | |
| F3 | cd4 | | Spearing Strike (25*) | - | - |
| Shift-F1 | cd2b | Reckless Swings (25*) | | | |
| E | interrupt | | Shield Bash (12) | Shield Bash (12) | Pummel (38) |
| R | movement | | Charge (4) | Charge (only with Vanguard*) | Intercept (30) |
| Shift-R | movement 2 | Piercing Howl (20*) | | | |
| F | taunt | | Mocking Blow (16) | Taunt (10) | - |
| Z | small defensive | | - | Shield Block (16) | - |
| X | defensive 2 | Last Stand (20*) | | | |
| C | big defensive | | Retaliation (20) | Shield Wall (28) | - |
| Shift-Z | def. 2nd row | | Rend (4) | Rend (4) | - |
| Shift-X | def. 2nd row | Battle Shout (1) | | | |
| Shift-C | def. 2nd row | Slam (20) | | | |
| V | CC | | Hamstring (8) | Disarm (18) | Hamstring (8) |
| Shift-Q | CC | Intimidating Shout (22) | | | |
| Shift-F | CC / taunt 2 | Challenging Shout (26) | | | |
| Shift-V | CC / dispel | | Concussion Blow (30*) | Concussion Blow (30*) | Berserker Rage (30) |
| F2 | quick heal | Victory Rush (20) | | | |
| F4 | heal over time | - (a Warrior has none) | | | |
| Shift-E | racial | own race's racial 1 (table above) | | | |
| Ctrl-1 | form 1 | Battle Stance (1) | | | |
| Ctrl-2 | form 2 | Defensive Stance (10) | | | |
| Ctrl-3 | form 3 | Berserker Stance (30) | | | |
| T / Shift-T / G | potion / healthstone / trinket | fixed, not spells | | | |
| **Block D** | player's own bar | Shoot Bow / Shoot Gun / Shoot Crossbow / Throw (ranged pull), the race's racial 2 | | | |

All 42 active Warrior spell names have a place on the block (script count). The judgment calls, marked AFGELEID:
- **Key 2 per stance** (Overpower / Revenge / Whirlwind): "the stance's own strike". The Druid pattern would put the
  bleed (Rend) on 2 instead; Rend then moved to Shift-Z, which is far for a level-4 spell. See question 1.
- **Key 3** stays empty until the level-40 talent. Slam and Spearing Strike do not fill it, because they would then
  have to move at 40 (rule 3).
- **Q in Battle = Sweeping Strikes** and **C in Battle = Retaliation**. C now holds each stance's 15-minute button
  (Retaliation and Shield Wall both have a 900 s cooldown in DB2). Retaliation fights back rather than lowering damage.
- **Concussion Blow** works in every stance but sits only in the Battle and Defensive columns of Shift-V, because
  Berserker Rage owns Shift-V in Berserker. A Protection-talent Warrior rarely stands in Berserker.
- **Piercing Howl on Shift-R** (an area slow, no second movement spell exists), **Spearing Strike on F3** (it has a 20 s
  cooldown), **Rend on Shift-Z** and **Slam on Shift-C** (overflow; Slam now has a 15 s cooldown and a 1.5 s cast).
- **F4 stays empty**, so F4 keeps meaning "heal over time" on every character.

What the engine makes of it (offline test: my draft table + the real `Modules\ForeverBlock.lua`, stubbed APIs, run
with `lua`; GEMETEN offline, not in the game). Level 60, Mortal Strike build:
```
2       [bonusbar:1] Overpower; [bonusbar:2] Revenge; [bonusbar:3] Whirlwind
E       [bonusbar:1] Shield Bash; [bonusbar:2] Shield Bash; [bonusbar:3] Pummel
R       [bonusbar:1] Charge; [bonusbar:2] Charge; [bonusbar:3] Intercept
V       [bonusbar:1] Hamstring; [bonusbar:2] Disarm; [bonusbar:3] Hamstring
```
Longest macro body 90 characters (limit 255). Level 1 Human: only 1 Heroic Strike, Ctrl-1 Battle Stance, Shift-X Battle
Shout and Shift-E Will to Survive get a macro; Perception is listed for block D. Test files:
`forever_classes\warrior_work\test_warrior.lua` and `ForeverBlock_Warrior_DRAFT.lua`.

## Draft Lua table (for review; NOT in the repo)
```lua
ns.FOREVER_BLOCK_CLASSES.WARRIOR = {
	-- bonusbar 1/2/3 = Battle/Defensive/Berserker (DB2 SpellShapeshiftForm.BonusActionBar, build 1.60.1.70790).
	-- No guards and no baseGuard: every "all" spell works in every stance, and no key mixes one with stance spells.
	states = {
		{ name = "battle", cond = "[bonusbar:1]" },
		{ name = "defensive", cond = "[bonusbar:2]" },
		{ name = "berserker", cond = "[bonusbar:3]" },
	},
	keys = {
		-- Block A
		["1"] = { all = "Heroic Strike" },
		["2"] = { battle = "Overpower", defensive = "Revenge", berserker = "Whirlwind" },
		["3"] = { all = { "Mortal Strike", "Bloodthirst", "Shield Slam" } },
		["4"] = { battle = "Execute", berserker = "Execute" },
		["SHIFT-1"] = { battle = "Thunder Clap", defensive = "Thunder Clap" },
		["SHIFT-2"] = { all = "Demoralizing Shout" },
		["SHIFT-3"] = { all = "Death Wish" },
		["F1"] = { all = "Bloodrage" },
		["Z"] = { defensive = "Shield Block" },
		["X"] = { all = "Last Stand" },
		["C"] = { battle = "Retaliation", defensive = "Shield Wall" },
		["V"] = { battle = "Hamstring", defensive = "Disarm", berserker = "Hamstring" },
		-- Block B
		["5"] = { all = "Sunder Armor" },
		["Q"] = { battle = "Sweeping Strikes", berserker = "Recklessness" },
		["E"] = { battle = "Shield Bash", defensive = "Shield Bash", berserker = "Pummel" },
		["R"] = { battle = "Charge", defensive = "Charge", berserker = "Intercept" }, -- Defensive: Vanguard talent only
		["F"] = { battle = "Mocking Blow", defensive = "Taunt" },
		["F2"] = { all = "Victory Rush" },
		["SHIFT-Q"] = { all = "Intimidating Shout" },
		["SHIFT-F"] = { all = "Challenging Shout" },
		["SHIFT-R"] = { all = "Piercing Howl" },
		-- Block C
		["CTRL-1"] = { all = "Battle Stance" },
		["CTRL-2"] = { all = "Defensive Stance" },
		["CTRL-3"] = { all = "Berserker Stance" },
		["F3"] = { battle = "Spearing Strike" },
		["SHIFT-E"] = { all = { "Blood Fury", "Berserking", "Stoneform", "Will of the Forsaken", "War Stomp",
			"Escape Artist", "Shadowmeld", "Will to Survive", "Walk on Air" } },
		["SHIFT-4"] = { all = "Cleave" },
		["SHIFT-F1"] = { all = "Reckless Swings" },
		["SHIFT-Z"] = { battle = "Rend", defensive = "Rend" },
		["SHIFT-X"] = { all = "Battle Shout" },
		["SHIFT-C"] = { all = "Slam" },
		["SHIFT-V"] = { battle = "Concussion Blow", defensive = "Concussion Blow", berserker = "Berserker Rage" },
	},
	toBlockD = { "Shoot Bow", "Shoot Gun", "Shoot Crossbow", "Throw", "Perception", "Shatter Curse", "Find Treasure",
		"Cannibalize", "Cultivation", "Eureka!", "Elune's Light", "Rapid Regeneration", "Read Leyline", "Skysight" },
}
```
The same table as a loadable file (with the `if not ns.IS_FOREVER` header):
`forever_classes\warrior_work\ForeverBlock_Warrior_DRAFT.lua`. It parsed and ran with the real engine (see above).

## Open questions for Rob
1. **Key 2:** each stance's own strike (Overpower / Revenge / Whirlwind, my proposal), or the Druid pattern "2 = bleed"
   (Rend in Battle and Defensive)? With the Druid pattern, Overpower and Revenge need another good key.
2. **Ctrl-1/2/3:** Battle / Defensive / Berserker (same order as the stance bar and the bonus bar numbers), or "tank
   first" like the Druid (Ctrl-1 = Bear): Ctrl-1 Defensive, Ctrl-2 Berserker, Ctrl-3 Battle?
3. **R in Defensive = Charge:** keep it (works with the Vanguard talent, red error without it), or leave R empty in Defensive?
4. **Q and C in Battle:** Sweeping Strikes on Q and Retaliation on C, or swap (Retaliation on Q as the big cooldown)?
5. **Shift-E per race:** Human Will to Survive (stun break) or Perception? Gnome Escape Artist or the new Eureka!? Night
   Elf Shadowmeld (as on the Druid) or Elune's Light? Skyborne: Walk on Air?
6. **Ranged pull** (Shoot Bow / Gun / Crossbow, Throw): block D, or a block key (F4 is free on a Warrior)?
7. **F4:** stay empty on a Warrior, or hold something (ranged pull, or Spearing Strike)?
8. Stance-dance macros (for example "switch to Battle Stance, then Overpower") are **not** in this proposal. A key never
   changes your stance by itself. Do you want that as a switch? (A player choice, not ours.)
9. **In-game checks on a Warrior** (they settle the AFGELEID points):
   - Level 1, in Battle Stance: `/run print(GetBonusBarOffset(), GetShapeshiftForm())` should print `1 1`.
   - After the level-10 quest, in Defensive Stance it should print `2`; after the level-30 quest, in Berserker Stance `3`.
   - Level 1: the spellbook should hold Battle Stance, Heroic Strike and (after the trainer) Battle Shout.
   - With the Vanguard talent: does `/cast Charge` work in Defensive Stance?

## What is GEMETEN vs AFGELEID
**GEMETEN (seen in a named, dated source):**
- Every spell ID, rank, level, tab and stance mask in the spell list (DB2 70790); WH level equal for all 107 non-talent
  rows; WH trainer/quest/book source; the quest names and IDs for both stances (WH, that night).
- Starting spells Battle Stance 2457 and Heroic Strike 78 (AcquireMethod 2).
- Teach spells 8121 and 8616 and what they teach (DB2 SpellEffect).
- Talent tree 1117: which spells, which row, which section, the 5-points-per-row conditions, 51 points from levels 10-60.
- Warrior races including both Skyborne races (CharBaseInfo); every racial and its race bit (SkillLineAbility).
- BonusActionBar 1/2/3 for Battle/Defensive/Berserker Stance, and 0 for Moonkin Form (DB2 SpellShapeshiftForm).
- The UI code path that pages bar 1 by bonus bar (Gethe forever branch, commit "1.60.1 (70790)", 4 Nov 2026).
- EllesmereUI's Forever paging states for the Warrior (local files; a candidate that agrees with DB2).
- The Era-vs-Forever differences listed above (script compare of DB2 70790 and 1.15.9.70576).
- The draft table's macro bodies with the real engine (offline lua test, stubbed APIs).

**AFGELEID (reasoned, not measured):**
- That `[bonusbar:N]` in a macro means GetBonusBarOffset() == N, and that a Warrior is always in a stance.
- That "no SpellShapeshift row" means "usable in every stance".
- Talent earliest levels (row rule, all points in one section).
- That `/cast Charge` uses the Vanguard version in Defensive Stance.
- That the Season of Discovery rune spells are not learnable in Forever (no proof either way about runes).
- That Shield Bash, Shield Block and Shield Slam need a shield (Classic rule; I did not read the item requirement).
- That MS / BT / SS Ranks 2-4 need the talent first.
- The whole key proposal: every placement is a judgment call, explained above.
- Nothing here has been seen in Rob's client on a Warrior.
