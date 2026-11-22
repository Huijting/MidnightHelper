# Class notes in WoW Forever 1.60.1.71037 (mh-research + check by the build chat, 22 Nov 2026)

Rob, 22 Nov 2026 via sparring, verbatim: "b" (card B). Built in `Modules/ForeverClassQuests.lua`. Not seen in game.

**Checked again by the build chat (MEASURED):** 56 combinations = CharBaseInfo; 52 ids in QuestV2; Zygor hands in the gate
and then accepts the note 52 of 52; Spoken prev 45 the same, 7 silent, 0 other; Spoken ender 52 of 52; names 349 of 350
equal to the Wowhead Forever tooltips (251374 ptBR left out); nine class icons in ManifestInterfaceData.
**Built differently from the research:** places are Rob's measurement > the constant the module had > Zygor. The
HandyNotes_ClassTrainers points are All Rights Reserved, so they are not copied here or into the module.
The earth chains of Dwarf and Windshaper got `gate` (179 / 92461). The stop level 5 is AFGELEID.
**Licence question, settled the same day (Rob via sparring, verbatim: "Plekken b"):** the whole module was measured (478
points): 59 that came from HandyNotes_ClassTrainers are Zygor's now; that addon is read live when the player has it.

## Short

- 56 playable class x race combinations (DB2 `CharBaseInfo`; 8 races + Skyborne 95 and 96). **None is without an intro.**
- 46 have a level 1 note, 10 (all Skyborne) an equivalent at level 2. 52 different quests.
- 3 are already the first step of a chain: 98581 (Dwarf shaman, `earth`), 98601 (Undead paladin, `holylight`),
  92484 (Windshaper shaman, `earth`). To add: **49 quests for 53 combinations**.
- Warlocks also have `imp` in CHAINS. That is another quest and does not replace the note.
- Every note opens only after ONE quest at the same NPC is **handed in** (not just accepted).
  747 The Hunt Begins does gate 3091-3094, so **yes, 3092 is gated behind 747**.
- No note teaches anything. No quest that MH shows needs a note as a hard condition.
- A note is not started by an item: you accept it at the NPC and get the paper (DB2 `StartQuestID` = 0 for all 52 items).

## The gates

| Starting race | Turn in first | Objective (Wowhead Forever tooltip) | Before that | Giver of gate and note | Minimum level |
|---|---|---|---|---|---|
| Human | 7 Kobold Camp Cleanup | 10 Kobold Vermin | 783 A Threat Within (talk) | Marshal McBride 197 | 1 |
| Dwarf, Gnome | 179 Dwarven Outfitters | 8 Tough Wolf Meat (drops) | nothing | Sten Stoutarm 658 | 1 |
| Night Elf | 456 The Balance of Nature (part 1) | 7 + 4 kills | nothing | Conservator Ilthalaine 2079 | 1 |
| Orc, Troll | 788 Cutting Teeth | 10 Mottled Boars | 4641 (talk, optional pointer) | Gornek 3143 | 1 |
| Tauren | 747 The Hunt Begins | 7 + 7 drops | nothing | Grull Hawkwind 2980 | 1 |
| Undead | 364 The Mindless Ones | 8 + 8 kills | 363 (talk, pointer) | Shadow Priest Sarvis 1569 | 1 |
| Skyborne | 92461 Harmony in Balance | 8 kills | 92460 Coming of Age (talk) | Rorian the Dayseeker 251361 | **2** |

For Skyborne both must be true: 92461 handed in AND level 2. If 92461 always takes you to level 2 is not measured.

### How certain, and who says it

| Group | Says the gate | Silent | Says something else | Certainty |
|---|---|---|---|---|
| Classic notes: Human, Dwarf, Gnome, Orc, Troll, Undead | giver text (past tense), Zygor order, Zygor chains, Spoken prev, ATT, classicdb, ForeverQuestLog, azeroth.wiki | - | - | high |
| Tauren 3091-3094 | the same, without the giver text | the text is neutral | - | high |
| Night Elf 3116-3120 | Zygor order and chains, Spoken, classicdb, ForeverQuestLog, warcraft.wiki (3117) = 456; azeroth.wiki gives only the shared title | the text is neutral | **ATT: 457 (part 2)** | high for 456, one dissent |
| 92479 Human hunter | giver text, Zygor order, Spoken, ForeverQuestLog, azeroth.wiki | Zygor chains, ATT | - | high |
| 98581 Dwarf shaman, 98574 Gnome priest | giver text, Zygor order, ATT, ForeverQuestLog, azeroth.wiki (98581 also Spoken) | Zygor chains (98574 also Spoken) | - | high |
| 98575 Troll warlock, 98576 Orc mage | giver text, Zygor order, ForeverQuestLog, azeroth.wiki | Zygor chains, Spoken, ATT | - | medium-high |
| 98601 Undead paladin | giver text, Zygor order, Spoken, ForeverQuestLog, warcraft.wiki | Zygor chains, ATT, azeroth.wiki | - | medium-high |
| Skyborne (6) | giver text, Zygor order, ATT, ForeverQuestLog, azeroth.wiki, Warcraft Tavern walkthrough | Zygor chains; Spoken for 4 of the 6 | - | high |

**Not independent:** classicdb.ch, ForeverQuestLog (its data page: NorgannonDB, built on Questie) and very likely Spoken's
world database share one Classic dataset: count them as one source. ATT and Zygor may also have Classic roots. Really
separate are the quest text (Blizzard's words), Zygor's route order, and the player-written walkthrough and wiki.

Closed by: none recorded (control in the same run: 92466 and 1598 do show an exclusivity). Opens: nothing hard (below).
Disappears: MEASURED no exclusive quest; DERIVED only once it is in the log or handed in. A maximum level is recorded
nowhere, but that absence proves nothing.

## Every combination (56)

| Class | Race | Side | Quest | Min / quest level | Needs handed in | Get | Turn in | Status |
|---|---|---|---|---|---|---|---|---|
| HUNTER | Human | Alliance | 92479 A Scribbled Letter | 1 / 1 | 7 | Marshal McBride 197 | Tordrin Sternblade 248415 | add |
| MAGE | Human | Alliance | 3104 Glyphic Letter | 1 / 1 | 7 | Marshal McBride 197 | Khelden Bremen 198 | add |
| PALADIN | Human | Alliance | 3101 Consecrated Letter | 1 / 1 | 7 | Marshal McBride 197 | Brother Sammuel 925 | add |
| PRIEST | Human | Alliance | 3103 Hallowed Letter | 1 / 1 | 7 | Marshal McBride 197 | Priestess Anetta 375 | add |
| ROGUE | Human | Alliance | 3102 Encrypted Letter | 1 / 1 | 7 | Marshal McBride 197 | Jorik Kerridan 915 | add |
| WARLOCK | Human | Alliance | 3105 Tainted Letter | 1 / 1 | 7 | Marshal McBride 197 | Drusilla La Salle 459 | add |
| WARRIOR | Human | Alliance | 3100 Simple Letter | 1 / 1 | 7 | Marshal McBride 197 | Llane Beshere 911 | add |
| HUNTER | Dwarf | Alliance | 3108 Etched Rune | 1 / 1 | 179 | Sten Stoutarm 658 | Thorgas Grimson 895 | add |
| PALADIN | Dwarf | Alliance | 3107 Consecrated Rune | 1 / 1 | 179 | Sten Stoutarm 658 | Bromos Grummner 926 | add |
| PRIEST | Dwarf | Alliance | 3110 Hallowed Rune | 1 / 1 | 179 | Sten Stoutarm 658 | Branstock Khalder 837 | add |
| ROGUE | Dwarf | Alliance | 3109 Encrypted Rune | 1 / 1 | 179 | Sten Stoutarm 658 | Solm Hargrin 916 | add |
| SHAMAN | Dwarf | Alliance | 98581 Archaic Rune | 1 / 1 | 179 | Sten Stoutarm 658 | Teo Hammerstorm 257446 | in CHAINS: SHAMAN earth |
| WARRIOR | Dwarf | Alliance | 3106 Simple Rune | 1 / 1 | 179 | Sten Stoutarm 658 | Thran Khorman 912 | add |
| MAGE | Gnome | Alliance | 3114 Glyphic Memorandum | 1 / 1 | 179 | Sten Stoutarm 658 | Marryk Nurribit 944 | add |
| PRIEST | Gnome | Alliance | 98574 Hallowed Memorandum | 1 / 1 | 179 | Sten Stoutarm 658 | Branstock Khalder 837 | add |
| ROGUE | Gnome | Alliance | 3113 Encrypted Memorandum | 1 / 1 | 179 | Sten Stoutarm 658 | Solm Hargrin 916 | add |
| WARLOCK | Gnome | Alliance | 3115 Tainted Memorandum | 1 / 1 | 179 | Sten Stoutarm 658 | Alamar Grimm 460 | add |
| WARRIOR | Gnome | Alliance | 3112 Simple Memorandum | 1 / 1 | 179 | Sten Stoutarm 658 | Thran Khorman 912 | add |
| DRUID | Night Elf | Alliance | 3120 Verdant Sigil | 1 / 1 | 456 | Conservator Ilthalaine 2079 | Mardant Strongoak 3597 | add |
| HUNTER | Night Elf | Alliance | 3117 Etched Sigil | 1 / 1 | 456 | Conservator Ilthalaine 2079 | Ayanna Everstride 3596 | add |
| PRIEST | Night Elf | Alliance | 3119 Hallowed Sigil | 1 / 1 | 456 | Conservator Ilthalaine 2079 | Shanda 3595 | add |
| ROGUE | Night Elf | Alliance | 3118 Encrypted Sigil | 1 / 1 | 456 | Conservator Ilthalaine 2079 | Frahun Shadewhisper 3594 | add |
| WARRIOR | Night Elf | Alliance | 3116 Simple Sigil | 1 / 1 | 456 | Conservator Ilthalaine 2079 | Alyissia 3593 | add |
| DRUID | High Order Skyborne | Alliance | 92485 A Student of Nature | 2 / 2 | 92461 | Rorian the Dayseeker 251361 | Xyton Silverwind 251373 | add, level 2 equivalent |
| HUNTER | High Order Skyborne | Alliance | 92482 The Way of the Hunter | 2 / 2 | 92461 | Rorian the Dayseeker 251361 | Tai'ree Farsight 251376 | add, level 2 equivalent |
| MAGE | High Order Skyborne | Alliance | 92481 A Student of the Arcane | 2 / 2 | 92461 | Rorian the Dayseeker 251361 | Dorii Brightwhisper 251379 | add, level 2 equivalent |
| ROGUE | High Order Skyborne | Alliance | 92483 At Home in the Shadows | 2 / 2 | 92461 | Rorian the Dayseeker 251361 | Akeri Duskblade 251389 | add, level 2 equivalent |
| WARRIOR | High Order Skyborne | Alliance | 92532 The Warrior's Path | 2 / 2 | 92461 | Rorian the Dayseeker 251361 | Blademaster Ren 251964 | add, level 2 equivalent |
| HUNTER | Orc | Horde | 3087 Etched Parchment | 1 / 1 | 788 | Gornek 3143 | Jen'shan 3154 | add |
| MAGE | Orc | Horde | 98576 Glyphic Parchment | 1 / 1 | 788 | Gornek 3143 | Mai'ah 5884 | add |
| ROGUE | Orc | Horde | 3088 Encrypted Parchment | 1 / 1 | 788 | Gornek 3143 | Rwag 3155 | add |
| SHAMAN | Orc | Horde | 3089 Rune-Inscribed Parchment | 1 / 1 | 788 | Gornek 3143 | Shikrik 3157 | add |
| WARLOCK | Orc | Horde | 3090 Tainted Parchment | 1 / 1 | 788 | Gornek 3143 | Nartok 3156 | add |
| WARRIOR | Orc | Horde | 2383 Simple Parchment | 1 / 1 | 788 | Gornek 3143 | Frang 3153 | add |
| HUNTER | Troll | Horde | 3082 Etched Tablet | 1 / 1 | 788 | Gornek 3143 | Jen'shan 3154 | add |
| MAGE | Troll | Horde | 3086 Glyphic Tablet | 1 / 1 | 788 | Gornek 3143 | Mai'ah 5884 | add |
| PRIEST | Troll | Horde | 3085 Hallowed Tablet | 1 / 1 | 788 | Gornek 3143 | Ken'jai 3707 | add |
| ROGUE | Troll | Horde | 3083 Encrypted Tablet | 1 / 1 | 788 | Gornek 3143 | Rwag 3155 | add |
| SHAMAN | Troll | Horde | 3084 Rune-Inscribed Tablet | 1 / 1 | 788 | Gornek 3143 | Shikrik 3157 | add |
| WARLOCK | Troll | Horde | 98575 Tainted Tablet | 1 / 1 | 788 | Gornek 3143 | Nartok 3156 | add |
| WARRIOR | Troll | Horde | 3065 Simple Tablet | 1 / 1 | 788 | Gornek 3143 | Frang 3153 | add |
| DRUID | Tauren | Horde | 3094 Verdant Note | 1 / 1 | 747 | Grull Hawkwind 2980 | Gart Mistrunner 3060 | add |
| HUNTER | Tauren | Horde | 3092 Etched Note | 1 / 1 | 747 | Grull Hawkwind 2980 | Lanka Farshot 3061 | add |
| SHAMAN | Tauren | Horde | 3093 Rune-Inscribed Note | 1 / 1 | 747 | Grull Hawkwind 2980 | Meela Dawnstrider 3062 | add |
| WARRIOR | Tauren | Horde | 3091 Simple Note | 1 / 1 | 747 | Grull Hawkwind 2980 | Harutt Thunderhorn 3059 | add |
| MAGE | Undead | Horde | 3098 Glyphic Scroll | 1 / 1 | 364 | Shadow Priest Sarvis 1569 | Isabella 2124 | add |
| PALADIN | Undead | Horde | 98601 A Difficult Path | 1 / 1 | 364 | Shadow Priest Sarvis 1569 | Aramis Hammerhand 244808 | in CHAINS: PALADIN holylight |
| PRIEST | Undead | Horde | 3097 Hallowed Scroll | 1 / 1 | 364 | Shadow Priest Sarvis 1569 | Dark Cleric Duesten 2123 | add |
| ROGUE | Undead | Horde | 3096 Encrypted Scroll | 1 / 1 | 364 | Shadow Priest Sarvis 1569 | David Trias 2122 | add |
| WARLOCK | Undead | Horde | 3099 Tainted Scroll | 1 / 1 | 364 | Shadow Priest Sarvis 1569 | Maximillion 2126 | add |
| WARRIOR | Undead | Horde | 3095 Simple Scroll | 1 / 1 | 364 | Shadow Priest Sarvis 1569 | Dannal Stern 2119 | add |
| DRUID | Windshaper Skyborne | Horde | 92485 A Student of Nature | 2 / 2 | 92461 | Rorian the Dayseeker 251361 | Xyton Silverwind 251373 | add, level 2 equivalent |
| HUNTER | Windshaper Skyborne | Horde | 92482 The Way of the Hunter | 2 / 2 | 92461 | Rorian the Dayseeker 251361 | Tai'ree Farsight 251376 | add, level 2 equivalent |
| ROGUE | Windshaper Skyborne | Horde | 92483 At Home in the Shadows | 2 / 2 | 92461 | Rorian the Dayseeker 251361 | Akeri Duskblade 251389 | add, level 2 equivalent |
| SHAMAN | Windshaper Skyborne | Horde | 92484 Embracing the Elements | 2 / 2 | 92461 | Rorian the Dayseeker 251361 | Windshaper Boro 251374 | in CHAINS: SHAMAN earth |
| WARRIOR | Windshaper Skyborne | Horde | 92532 The Warrior's Path | 2 / 2 | 92461 | Rorian the Dayseeker 251361 | Blademaster Ren 251964 | add, level 2 equivalent |

Totals: Human 7, Dwarf 6, Gnome 5, Night Elf 5, High Order Skyborne 5, Orc 6, Troll 7, Tauren 4, Undead 6, Windshaper Skyborne 5 = 56. Alliance 28, Horde 28. Without an intro: 0.

## Is a note needed for something MH shows? (question 4)

| Note | Next thing | Verdict |
|---|---|---|
| 98581 Archaic Rune | 94373 Call of Earth (4) | No hard need (DERIVED, medium). Spoken and ATT name it (ATT: 98581 OR 96243); ForeverQuestLog lists no condition, and the Icy Veins chain starts at 96243 without 98581. |
| 98601 A Difficult Path | 90902 Rediscovering the Light (2), teaches Holy Light | No hard need (DERIVED, medium). warcraft.wiki says "optional"; ForeverQuestLog gates 90902 on 364. Spoken and the Wowhead series chain them. ATT and azeroth.wiki name 91282, a level 8 quest: looks wrong. |
| 92484 Embracing the Elements | 92466 Call of Earth (3) | No. Spoken, ATT and ForeverQuestLog give 92466 no such condition. |
| the other 49 | - | Nothing found in Spoken (4828 quests), ATT (5765), the questcache (2132), classicdb "Open Quests" (control: 747 does open quests), Zygor chains. |

So skipping costs 40 XP (85 for Skyborne) and 50 reputation, nothing else.

### When to stop showing a skipped note (DERIVED)

**Show it up to and including level 5; from 6 only when it is in the log.**

- Quest level 1 (Skyborne 2): MEASURED.
- It only sends you to a starting-zone trainer, and those teach up to level 6 (`cap = 6`, `ForeverTrainerSpots.lua`,
  measured by the owner at Mai'ah).
- The starting valleys are listed as 1-5 (ForeverQuestLog zone list).
- Level 1 turns grey at 6 or 7 by the Classic rules on warcraft.wiki (mob grey level 6; quest green range one level
  later). Forever's own value is `UnitQuestTrivialLevelRange("player")` (exists in the 71037 API), not read in game.
- `ITEM_CHAIN_SPAN` (10) alone would keep a note in "Do this now" until level 11: too long.

## Disagreements

- 92479 class: hunter by ATT, azeroth.wiki, ForeverQuestLog, Zygor and its own text ("our local hunter trainer").
  Warrior by Spoken's mask and the Icy Veins category. Found the cause: the client's questcache files it under
  QuestSortID -81 (warrior log category), which is not a class mask. Use hunter.
- 92479 receiver: the quest text says Stemblade, the NPC is Sternblade (also different in de, fr, es, esMX, ru).
- Night Elf gate: ATT 457, everyone else 456 (above).
- 98601: ATT adds item rewards 6060 and 2173; the client's questcache has none.
- 98601: azeroth.wiki and ATT list no gate; text, Zygor order, Spoken, ForeverQuestLog and warcraft.wiki do.
- Skyborne masks: client data lets every race take 92482, 92483, 92484, 92485, 92532, and all of the Alliance 92481.
  ATT makes 92484 Horde. Only Skyborne start there, so `races = Skyborne` (DERIVED).
- 3092 XP: the azeroth.wiki page as Exa returned it said 60; QuestXP (level 1, difficulty 3), Icy Veins, classicdb say 40.

## Could not check

- Nothing in game: that each giver offers the note right after the hand-in, and not before.
- The server's class masks and previous-quest fields themselves: neither DB2 nor the questcache has them.
- 35 of 52 notes are not in this client's questcache: their levels come from databases.
- That a note stays available at high level; the exact grey level in Forever; that reading the paper is not needed
  (warcraft.wiki says so for 98601 only); re-offer after abandoning.
- Player comments: Wowhead showed none to a logged-out fetch on the two pages read.
- Coordinates: none of the givers measured in game; only two receivers are.
- Client nameplates: names come from Wowhead, not from a client in that language.
