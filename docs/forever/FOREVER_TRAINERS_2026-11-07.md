# WoW Forever class trainers (capitals, start towns, Forever hubs)

Research for Midnight Helper, 7 Nov 2026. Read only, nothing in the MH repo was touched.

## Method (short)

1. **Roster (who is a trainer).** Wowhead Forever zone pages, `https://www.wowhead.com/forever/zone=<areaID>`, NPC listview, read 7 Nov 2026 ~06:00 UTC.
   Zones: Elwynn 12, Dun Morogh 1, Teldrassil 141, Durotar 14, Mulgore 215, Tirisfal 85, Stormwind 1519, Ironforge 1537,
   Darnassus 1657, Orgrimmar 1637, Thunder Bluff 1638, Undercity 1497, Zephras Isle 16593, Alterac Mountains 36 (Dalaran,
   new Forever hub per warcraft.wiki.gg/wiki/Forever). I kept every NPC whose tag is `<X Trainer>`, plus 331 Maginor Dumas
   `<Master Mage>` and 5492 Katherine the Pure `<Church of the Holy Light>` (both flagged by Wowhead's "Class trainer" filter,
   `npcs?filter=24;1;0`). Cross-check: Wowhead's "Trainer" filter (`npcs?filter=28;1;0`, 596 rows) gave 234 class/pet/portal
   trainers in these zones; every one of them was already in the zone-page roster (GEMETEN).
2. **Coordinates.** Each NPC page `https://www.wowhead.com/forever/npc=<id>`, the `g_mapperData` JSON (area, `uiMapId`,
   coords). 249 pages, fetched slowly (14 s apart) 06:17-07:28 UTC on 7 Nov 2026. Wowhead gives 1 decimal on a 0.2 grid,
   so the second decimal is always 0. When an NPC has several points I took the medoid (a real Wowhead point, the one
   closest to all others), not an average.
3. **uiMapIDs.** wago.tools `UiMap` for WoW Forever build **1.60.1.70790** (`/db2/UiMap/csv?build=1.60.1.70790`, 200 OK,
   fetched 7 Nov 2026). GEMETEN: 1411 Durotar, 1412 Mulgore, 1416 Alterac Mountains, 1420 Tirisfal Glades, 1426 Dun Morogh,
   1429 Elwynn Forest, 1438 Teldrassil, 1453 Stormwind City, 1454 Orgrimmar, 1455 Ironforge, 1456 Thunder Bluff,
   1457 Darnassus, 1458 Undercity, 2521 Zephras Isle (System 0; 2665 is a second "Zephras Isle" row with System 1).
   Every Wowhead `uiMapId` matches these IDs (positive control: Lord Grayson 928 -> 1453 on both).
4. **Bigger maps.** wago `UiMapAssignment` for Forever 1.60.1.70790 vs Classic Era 1.15.8.64057 (GEMETEN): the bounds differ
   only for **1453 Stormwind, 1412 Mulgore, 1433 Redridge, 1423 Eastern Plaguelands**; all other maps above are identical.
   On 1453 and 1412 Wowhead lists BOTH the old Classic-map point and the new Forever-map point for the same NPC
   (e.g. 928: (37.2,33) and (48.4,50)). I converted each point with the era->Forever bounds and dropped the point whose image
   lands on another listed point (within 0.6). That choice is AFGELEID; the coordinate itself is read on Wowhead (GEMETEN).
   All 38 rows on 1453/1412 agree with Zygor's Forever data, which is the independent check.
5. **Zygor cross-check.** `ZygorGuidesViewerForever\Data-Forever\NPCData.lua` (file date 6 Nov 2026), sections
   `ClassDruid` ... `ClassWarrior` + `ClassHunter pets`. Only used to compare; no Zygor value is used in the rows.
   Not used at all (licence): HandyNotes_ClassTrainers, HandyNotes_WoWForever, Questie/QuestieDB.

`side`: from Wowhead `react` [Alliance, Horde]; 1 = friendly. "both" = friendly to both (Zephras Isle, Skyborne).
`kind`: only on pet / demon / portal trainers. Per-row comment: zone; source URL; GEMETEN; Zygor check; notes.

## Counts

| class | class trainers | extra (kind) |
|---|---:|---|
| DRUID | 18 | |
| HUNTER | 28 | 11 pet |
| MAGE | 29 | 6 portal |
| PALADIN | 15 | |
| PRIEST | 31 | |
| ROGUE | 27 | |
| SHAMAN | 17 | |
| WARLOCK | 20 | 12 demon |
| WARRIOR | 33 | |
| **total** | **218** | 29 |

All 247 rows: coordinate GEMETEN on Wowhead Forever. AFGELEID parts: the Classic/Forever point choice on 1453 and 1412
(38 rows, all Zygor-confirmed) and `side = "H"` for 262558 and 262560 (Wowhead react is neutral to Horde).

## Lua block

```lua
local FOREVER_CLASS_TRAINERS = {
  -- DRUID (18 rows)
  { npc = 3060, name = "Gart Mistrunner", class = "DRUID", side = "H", map = 1412, x = 44.60, y = 76.60 }, -- Mulgore; https://www.wowhead.com/forever/npc=3060; GEMETEN; Zygor agrees (44.65,76.55); dropped 1 old Classic-map coord(s) e.g. (45,76) whose era->Forever image matches
  { npc = 3064, name = "Gennia Runetotem", class = "DRUID", side = "H", map = 1412, x = 47.40, y = 62.80 }, -- Mulgore; https://www.wowhead.com/forever/npc=3064; GEMETEN; Zygor agrees (47.47,62.95); dropped 4 old Classic-map coord(s) e.g. (48.4,59.4) whose era->Forever image matches
  { npc = 262560, name = "Hana Lighthoof", class = "DRUID", side = "H", map = 1412, x = 33.40, y = 22.00 }, -- Mulgore; https://www.wowhead.com/forever/npc=262560; GEMETEN; Zygor agrees (33.40,22.00); Zygor side sH vs Wowhead react [None, 0]; new Forever NPC, no Classic coords; side H AFGELEID (Wowhead react [None, 0] = neutral to Horde; Horde zone; Zygor sH)
  { npc = 270459, name = "Alfina Nightgaze", class = "DRUID", side = "A", map = 1416, x = 11.80, y = 56.40 }, -- Alterac Mountains; https://www.wowhead.com/forever/npc=270459; GEMETEN; Zygor agrees (11.80,56.50); 2 coords, spread 0.2
  { npc = 3597, name = "Mardant Strongoak", class = "DRUID", side = "A", map = 1438, x = 58.60, y = 40.40 }, -- Teldrassil; https://www.wowhead.com/forever/npc=3597; GEMETEN; Zygor agrees (58.62,40.28)
  { npc = 3602, name = "Kal", class = "DRUID", side = "A", map = 1438, x = 56.00, y = 61.40 }, -- Teldrassil; https://www.wowhead.com/forever/npc=3602; GEMETEN; Zygor agrees (55.94,61.56); 2 coords, spread 0.2
  { npc = 5504, name = "Sheldras Moontree", class = "DRUID", side = "A", map = 1453, x = 36.00, y = 67.20 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5504; GEMETEN; Zygor agrees (35.84,67.35); dropped 2 old Classic-map coord(s) e.g. (21,55.4) whose era->Forever image matches
  { npc = 5505, name = "Theridran", class = "DRUID", side = "A", map = 1453, x = 36.20, y = 64.20 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5505; GEMETEN; Zygor agrees (36.11,64.42); dropped 3 old Classic-map coord(s) e.g. (21.4,51.4) whose era->Forever image matches; unpaired (21.2,52.6)
  { npc = 5506, name = "Maldryn", class = "DRUID", side = "A", map = 1453, x = 34.40, y = 64.80 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5506; GEMETEN; Zygor agrees (34.43,65.19); dropped 5 old Classic-map coord(s) e.g. (18.8,52.6) whose era->Forever image matches
  { npc = 3033, name = "Turak Runetotem", class = "DRUID", side = "H", map = 1456, x = 76.40, y = 27.40 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3033; GEMETEN; Zygor agrees (76.47,27.22); 4 coords, spread 0.3
  { npc = 3034, name = "Sheal Runetotem", class = "DRUID", side = "H", map = 1456, x = 77.00, y = 27.60 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3034; GEMETEN; Zygor agrees (77.14,27.01); 5 coords, spread 0.7
  { npc = 3036, name = "Kym Wildmane", class = "DRUID", side = "H", map = 1456, x = 76.80, y = 29.80 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3036; GEMETEN; Zygor agrees (77.14,29.81); 7 coords, spread 0.9
  { npc = 4217, name = "Mathrengyl Bearwalker", class = "DRUID", side = "A", map = 1457, x = 35.20, y = 8.00 }, -- Darnassus; https://www.wowhead.com/forever/npc=4217; GEMETEN; Zygor agrees (35.37,8.40); 3 coords, spread 0.7
  { npc = 4218, name = "Denatharion", class = "DRUID", side = "A", map = 1457, x = 34.40, y = 7.60 }, -- Darnassus; https://www.wowhead.com/forever/npc=4218; GEMETEN; Zygor agrees (34.76,7.36); 5 coords, spread 1.2
  { npc = 4219, name = "Fylerian Nightwing", class = "DRUID", side = "A", map = 1457, x = 33.60, y = 8.40 }, -- Darnassus; https://www.wowhead.com/forever/npc=4219; GEMETEN; Zygor agrees (33.51,8.34); 5 coords, spread 1.2
  { npc = 251373, name = "Xyton Silverwind", class = "DRUID", side = "both", map = 2521, x = 41.60, y = 23.40 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=251373; GEMETEN; Zygor agrees (41.60,23.40)
  { npc = 252359, name = "Lotheluum Starbreeze", class = "DRUID", side = "both", map = 2521, x = 64.00, y = 75.00 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=252359; GEMETEN; Zygor agrees (64.00,75.00)
  { npc = 254081, name = "Naeluna Swiftmend", class = "DRUID", side = "both", map = 2521, x = 45.20, y = 44.20 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=254081; GEMETEN; Zygor agrees (45.20,44.20)
  -- HUNTER (39 rows)
  { npc = 3154, name = "Jen'shan", class = "HUNTER", side = "H", map = 1411, x = 42.80, y = 69.20 }, -- Durotar; https://www.wowhead.com/forever/npc=3154; GEMETEN; Zygor agrees (42.83,69.32)
  { npc = 3171, name = "Thotar", class = "HUNTER", side = "H", map = 1411, x = 51.80, y = 43.40 }, -- Durotar; https://www.wowhead.com/forever/npc=3171; GEMETEN; Zygor agrees (51.84,43.48); 2 coords, spread 0.2
  { npc = 3061, name = "Lanka Farshot", class = "HUNTER", side = "H", map = 1412, x = 43.80, y = 76.60 }, -- Mulgore; https://www.wowhead.com/forever/npc=3061; GEMETEN; Zygor agrees (43.95,76.35); dropped 1 old Classic-map coord(s) e.g. (44.2,75.8) whose era->Forever image matches
  { npc = 3065, name = "Yaw Sharpmane", class = "HUNTER", side = "H", map = 1412, x = 46.80, y = 59.60 }, -- Mulgore; https://www.wowhead.com/forever/npc=3065; GEMETEN; Zygor agrees (46.92,59.64); dropped 2 old Classic-map coord(s) e.g. (47.8,55.4) whose era->Forever image matches
  { npc = 895, name = "Thorgas Grimson", class = "HUNTER", side = "A", map = 1426, x = 29.00, y = 67.40 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=895; GEMETEN; Zygor agrees (29.17,67.45); 2 coords, spread 0.2
  { npc = 1231, name = "Grif Wildheart", class = "HUNTER", side = "A", map = 1426, x = 45.80, y = 53.00 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=1231; GEMETEN; Zygor agrees (45.81,53.03)
  { npc = 248415, name = "Tordrin Sternblade", class = "HUNTER", side = "A", map = 1429, x = 51.00, y = 40.40 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=248415; GEMETEN; Zygor agrees (51.10,40.59); 2 coords, spread 0.4
  { npc = 251507, name = "Josephine Carson", class = "HUNTER", side = "A", map = 1429, x = 41.20, y = 66.20 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=251507; GEMETEN; Zygor agrees (41.20,66.20)
  { npc = 3596, name = "Ayanna Everstride", class = "HUNTER", side = "A", map = 1438, x = 58.60, y = 40.60 }, -- Teldrassil; https://www.wowhead.com/forever/npc=3596; GEMETEN; Zygor agrees (58.65,40.44); 3 coords, spread 0.2
  { npc = 3601, name = "Dazalar", class = "HUNTER", side = "A", map = 1438, x = 56.60, y = 59.40 }, -- Teldrassil; https://www.wowhead.com/forever/npc=3601; GEMETEN; Zygor agrees (56.67,59.48); 2 coords, spread 0.2
  { npc = 5515, name = "Einris Brightspear", class = "HUNTER", side = "A", map = 1453, x = 67.40, y = 36.40 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5515; GEMETEN; Zygor agrees (67.32,36.18); dropped 3 old Classic-map coord(s) e.g. (61.4,15.4) whose era->Forever image matches
  { npc = 5516, name = "Ulfir Ironbeard", class = "HUNTER", side = "A", map = 1453, x = 67.40, y = 36.20 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5516; GEMETEN; Zygor agrees (67.59,35.75); dropped 2 old Classic-map coord(s) e.g. (61.8,15.6) whose era->Forever image matches
  { npc = 5517, name = "Thorfin Stoneshield", class = "HUNTER", side = "A", map = 1453, x = 68.00, y = 35.80 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5517; GEMETEN; Zygor agrees (67.99,36.01); dropped 3 old Classic-map coord(s) e.g. (62.4,14.4) whose era->Forever image matches
  { npc = 3352, name = "Ormak Grimshot", class = "HUNTER", side = "H", map = 1454, x = 66.20, y = 18.20 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3352; GEMETEN; Zygor agrees (66.04,18.52); 2 coords, spread 0.4
  { npc = 3406, name = "Xor'juul", class = "HUNTER", side = "H", map = 1454, x = 67.00, y = 19.20 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3406; GEMETEN; Zygor close (67.24,20.19), 1.0 away, 0.3 from nearest Wowhead point; 2 coords, spread 0.8
  { npc = 3407, name = "Sian'dur", class = "HUNTER", side = "H", map = 1454, x = 67.80, y = 17.80 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3407; GEMETEN; Zygor agrees (67.95,17.80); 5 coords, spread 0.8
  { npc = 5115, name = "Daera Brightspear", class = "HUNTER", side = "A", map = 1455, x = 70.80, y = 89.40 }, -- Ironforge; https://www.wowhead.com/forever/npc=5115; GEMETEN; Zygor agrees (70.96,89.80); 8 coords, spread 1.4
  { npc = 5116, name = "Olmin Burningbeard", class = "HUNTER", side = "A", map = 1455, x = 70.40, y = 83.80 }, -- Ironforge; https://www.wowhead.com/forever/npc=5116; GEMETEN; Zygor agrees (70.88,83.61); 5 coords, spread 0.9
  { npc = 5117, name = "Regnus Thundergranite", class = "HUNTER", side = "A", map = 1455, x = 69.40, y = 84.40 }, -- Ironforge; https://www.wowhead.com/forever/npc=5117; GEMETEN; Zygor close (69.87,82.89), 1.6 away, 0.5 from nearest Wowhead point; 5 coords, spread 1.1
  { npc = 3038, name = "Kary Thunderhorn", class = "HUNTER", side = "H", map = 1456, x = 58.20, y = 87.00 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3038; GEMETEN; Zygor close (58.48,88.32), 1.3 away, 0.6 from nearest Wowhead point; 2 coords, spread 0.8
  { npc = 3039, name = "Holt Thunderhorn", class = "HUNTER", side = "H", map = 1456, x = 57.60, y = 88.60 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3039; GEMETEN; Zygor close (57.29,89.78), 1.2 away, 0.2 from nearest Wowhead point; 5 coords, spread 1.1
  { npc = 3040, name = "Urek Thunderhorn", class = "HUNTER", side = "H", map = 1456, x = 58.80, y = 86.40 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3040; GEMETEN; Zygor agrees (59.12,86.87); 2 coords, spread 0.2
  { npc = 4138, name = "Jeen'ra Nightrunner", class = "HUNTER", side = "A", map = 1457, x = 39.60, y = 5.80 }, -- Darnassus; https://www.wowhead.com/forever/npc=4138; GEMETEN; Zygor agrees (39.72,5.38); 4 coords, spread 0.8
  { npc = 4146, name = "Jocaste", class = "HUNTER", side = "A", map = 1457, x = 40.20, y = 8.80 }, -- Darnassus; https://www.wowhead.com/forever/npc=4146; GEMETEN; Zygor agrees (40.37,8.54); 3 coords, spread 1.0
  { npc = 4205, name = "Dorion", class = "HUNTER", side = "A", map = 1457, x = 42.20, y = 7.60 }, -- Darnassus; https://www.wowhead.com/forever/npc=4205; GEMETEN; Zygor agrees (42.20,7.26); 3 coords, spread 1.0
  { npc = 251376, name = "Tai'ree Farsight", class = "HUNTER", side = "both", map = 2521, x = 42.40, y = 23.60 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=251376; GEMETEN; Zygor agrees (42.50,23.55); 3 coords, spread 0.2
  { npc = 252389, name = "Quel'ana Quickgale", class = "HUNTER", side = "both", map = 2521, x = 59.60, y = 72.60 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=252389; GEMETEN; Zygor agrees (59.60,72.60)
  { npc = 254084, name = "Elayaa Easewind", class = "HUNTER", side = "both", map = 2521, x = 45.20, y = 44.20 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=254084; GEMETEN; Zygor agrees (45.20,44.20)
  { npc = 3620, name = "Harruk", class = "HUNTER", side = "H", map = 1411, x = 52.00, y = 43.40, kind = "pet" }, -- Durotar <Pet Trainer>; https://www.wowhead.com/forever/npc=3620; GEMETEN; Zygor agrees (52.02,43.54); 2 coords, spread 0.2
  { npc = 3688, name = "Reban Freerunner", class = "HUNTER", side = "H", map = 1412, x = 46.80, y = 59.40, kind = "pet" }, -- Mulgore <Pet Trainer>; https://www.wowhead.com/forever/npc=3688; GEMETEN; Zygor agrees (46.83,59.68); dropped 3 old Classic-map coord(s) e.g. (47.4,55.8) whose era->Forever image matches
  { npc = 2878, name = "Peria Lamenur", class = "HUNTER", side = "A", map = 1426, x = 46.60, y = 54.00, kind = "pet" }, -- Dun Morogh <Pet Trainer>; https://www.wowhead.com/forever/npc=2878; GEMETEN; Zygor agrees (46.68,53.99); 2 coords, spread 29.2 (MULTIPLE SPOTS: [(46.6, 54), (71, 38)])
  { npc = 258930, name = "Isaac Chan", class = "HUNTER", side = "A", map = 1429, x = 41.80, y = 66.40, kind = "pet" }, -- Elwynn Forest <Pet Trainer>; https://www.wowhead.com/forever/npc=258930; GEMETEN; not in Zygor class sections; 3 coords, spread 0.4
  { npc = 3306, name = "Keldas", class = "HUNTER", side = "A", map = 1438, x = 56.60, y = 59.40, kind = "pet" }, -- Teldrassil <Pet Trainer>; https://www.wowhead.com/forever/npc=3306; GEMETEN; Zygor agrees (56.78,59.78); 2 coords, spread 0.3
  { npc = 2879, name = "Karrina Mekenda", class = "HUNTER", side = "A", map = 1453, x = 67.40, y = 36.80, kind = "pet" }, -- Stormwind City <Pet Trainer>; https://www.wowhead.com/forever/npc=2879; GEMETEN; Zygor agrees (67.32,36.79); dropped 2 old Classic-map coord(s) e.g. (61.6,15.4) whose era->Forever image matches; unpaired (61.2,16.8)
  { npc = 10088, name = "Xao'tsu", class = "HUNTER", side = "H", map = 1454, x = 66.40, y = 15.00, kind = "pet" }, -- Orgrimmar <Pet Trainer>; https://www.wowhead.com/forever/npc=10088; GEMETEN; Zygor agrees (66.31,14.81); 3 coords, spread 0.8
  { npc = 10090, name = "Belia Thundergranite", class = "HUNTER", side = "A", map = 1455, x = 70.40, y = 85.00, kind = "pet" }, -- Ironforge <Pet Trainer>; https://www.wowhead.com/forever/npc=10090; GEMETEN; Zygor agrees (70.86,85.83); 4 coords, spread 0.7
  { npc = 10086, name = "Hesuwa Thunderhorn", class = "HUNTER", side = "H", map = 1456, x = 54.40, y = 83.40, kind = "pet" }, -- Thunder Bluff <Pet Trainer>; https://www.wowhead.com/forever/npc=10086; GEMETEN; Zygor agrees (54.08,83.99); 3 coords, spread 0.4
  { npc = 10089, name = "Silvaria", class = "HUNTER", side = "A", map = 1457, x = 42.20, y = 8.40, kind = "pet" }, -- Darnassus <Pet Trainer>; https://www.wowhead.com/forever/npc=10089; GEMETEN; Zygor agrees (42.47,9.16); 2 coords, spread 0.4
  { npc = 254411, name = "Quel'dora Quickgale", class = "HUNTER", side = "both", map = 2521, x = 59.60, y = 72.40, kind = "pet" }, -- Zephras Isle <Pet Trainer>; https://www.wowhead.com/forever/npc=254411; GEMETEN; not in Zygor class sections; 2 coords, spread 0.2
  -- MAGE (35 rows)
  { npc = 5880, name = "Un'Thuwa", class = "MAGE", side = "H", map = 1411, x = 56.20, y = 75.00 }, -- Durotar; https://www.wowhead.com/forever/npc=5880; GEMETEN; Zygor agrees (56.30,75.10)
  { npc = 5884, name = "Mai'ah", class = "MAGE", side = "H", map = 1411, x = 42.40, y = 69.00 }, -- Durotar; https://www.wowhead.com/forever/npc=5884; GEMETEN; Zygor agrees (42.50,69.03); Zygor has this row commented out (-- very limited); 2 coords, spread 0.2
  { npc = 246797, name = "Jessa Weaver", class = "MAGE", side = "A", map = 1416, x = 17.60, y = 69.40 }, -- Alterac Mountains; https://www.wowhead.com/forever/npc=246797; GEMETEN; Zygor agrees (17.60,69.50); 2 coords, spread 0.2
  { npc = 2124, name = "Isabella", class = "MAGE", side = "H", map = 1420, x = 30.80, y = 66.00 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=2124; GEMETEN; Zygor agrees (30.93,66.06); Zygor has this row commented out (-- very limited)
  { npc = 2128, name = "Cain Firesong", class = "MAGE", side = "H", map = 1420, x = 61.80, y = 52.40 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=2128; GEMETEN; Zygor agrees (61.96,52.47)
  { npc = 944, name = "Marryk Nurribit", class = "MAGE", side = "A", map = 1426, x = 28.60, y = 66.40 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=944; GEMETEN; Zygor agrees (28.70,66.36); Zygor has this row commented out (-- very limited)
  { npc = 1228, name = "Magis Sparkmantle", class = "MAGE", side = "A", map = 1426, x = 47.40, y = 52.00 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=1228; GEMETEN; Zygor agrees (47.49,52.07)
  { npc = 198, name = "Khelden Bremen", class = "MAGE", side = "A", map = 1429, x = 49.60, y = 39.60 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=198; GEMETEN; Zygor agrees (49.66,39.40); 3 coords, spread 0.2
  { npc = 328, name = "Zaldimar Wefhellt", class = "MAGE", side = "A", map = 1429, x = 43.20, y = 66.20 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=328; GEMETEN; Zygor agrees (43.24,66.19)
  { npc = 331, name = "Maginor Dumas", class = "MAGE", side = "A", map = 1453, x = 49.00, y = 87.60 }, -- Stormwind City <Master Mage>; https://www.wowhead.com/forever/npc=331; GEMETEN; Zygor agrees (49.22,87.72); dropped 2 old Classic-map coord(s) e.g. (38,81.6) whose era->Forever image matches
  { npc = 5497, name = "Jennea Cannon", class = "MAGE", side = "A", map = 1453, x = 49.40, y = 86.00 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5497; GEMETEN; Zygor agrees (49.49,85.82); dropped 4 old Classic-map coord(s) e.g. (38.4,79.4) whose era->Forever image matches
  { npc = 5498, name = "Elsharin", class = "MAGE", side = "A", map = 1453, x = 48.40, y = 87.20 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5498; GEMETEN; Zygor agrees (48.21,87.29); dropped 3 old Classic-map coord(s) e.g. (37,81.2) whose era->Forever image matches
  { npc = 5882, name = "Pephredo", class = "MAGE", side = "H", map = 1454, x = 38.40, y = 85.40 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=5882; GEMETEN; Zygor agrees (38.35,85.55); 4 coords, spread 0.3
  { npc = 5883, name = "Enyo", class = "MAGE", side = "H", map = 1454, x = 38.60, y = 85.60 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=5883; GEMETEN; Zygor agrees (38.78,85.67); 3 coords, spread 0.3
  { npc = 5885, name = "Deino", class = "MAGE", side = "H", map = 1454, x = 38.40, y = 85.80 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=5885; GEMETEN; Zygor agrees (38.44,86.13); 5 coords, spread 1.0
  { npc = 7311, name = "Uthel'nay", class = "MAGE", side = "H", map = 1454, x = 38.80, y = 85.40 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=7311; GEMETEN; Zygor agrees (39.16,86.27); 2 coords, spread 0.6
  { npc = 5144, name = "Bink", class = "MAGE", side = "A", map = 1455, x = 26.80, y = 8.60 }, -- Ironforge; https://www.wowhead.com/forever/npc=5144; GEMETEN; Zygor agrees (27.24,8.29); 4 coords, spread 1.1
  { npc = 5145, name = "Juli Stormkettle", class = "MAGE", side = "A", map = 1455, x = 26.20, y = 7.60 }, -- Ironforge; https://www.wowhead.com/forever/npc=5145; GEMETEN; Zygor agrees (26.29,6.76); 5 coords, spread 1.0
  { npc = 5146, name = "Nittlebur Sparkfizzle", class = "MAGE", side = "A", map = 1455, x = 26.00, y = 5.80 }, -- Ironforge; https://www.wowhead.com/forever/npc=5146; GEMETEN; Zygor agrees (25.92,6.17); 9 coords, spread 4.2 (MULTIPLE SPOTS: [(25.4, 4.4), (25.4, 4.6), (25.6, 4.4), (25.8, 5.2), (26, 5.8), (26, 6.6), (26.6, 6.4), (26.6, 10), (27, 6.8)])
  { npc = 7312, name = "Dink", class = "MAGE", side = "A", map = 1455, x = 26.80, y = 8.60 }, -- Ironforge; https://www.wowhead.com/forever/npc=7312; GEMETEN; Zygor agrees (27.16,8.57); 4 coords, spread 1.3
  { npc = 3047, name = "Archmage Shymm", class = "MAGE", side = "H", map = 1456, x = 22.40, y = 15.40 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3047; GEMETEN; Zygor agrees (22.76,14.53); 4 coords, spread 0.6
  { npc = 3048, name = "Ursyn Ghull", class = "MAGE", side = "H", map = 1456, x = 25.60, y = 14.60 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3048; GEMETEN; Zygor agrees (25.70,14.19); 5 coords, spread 1.0
  { npc = 3049, name = "Thurston Xane", class = "MAGE", side = "H", map = 1456, x = 25.00, y = 20.60 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3049; GEMETEN; Zygor agrees (25.17,20.96); 6 coords, spread 1.4
  { npc = 4566, name = "Kaelystia Hatebringer", class = "MAGE", side = "H", map = 1458, x = 85.00, y = 14.60 }, -- Undercity; https://www.wowhead.com/forever/npc=4566; GEMETEN; Zygor agrees (85.02,14.02); 5 coords, spread 1.0
  { npc = 4567, name = "Pierce Shackleton", class = "MAGE", side = "H", map = 1458, x = 85.60, y = 14.00 }, -- Undercity; https://www.wowhead.com/forever/npc=4567; GEMETEN; Zygor agrees (85.44,13.50); 4 coords, spread 0.7
  { npc = 4568, name = "Anastasia Hartwell", class = "MAGE", side = "H", map = 1458, x = 84.80, y = 10.60 }, -- Undercity; https://www.wowhead.com/forever/npc=4568; GEMETEN; Zygor agrees (85.13,10.02); 3 coords, spread 0.6
  { npc = 251379, name = "Dorii Brightwhisper", class = "MAGE", side = "A", map = 2521, x = 41.40, y = 23.60 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=251379; GEMETEN; Zygor agrees (41.55,23.52); 3 coords, spread 0.2
  { npc = 252373, name = "Anathamaas Aetherwind", class = "MAGE", side = "both", map = 2521, x = 65.80, y = 80.40 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=252373; GEMETEN; Zygor agrees (65.80,80.50); 2 coords, spread 0.2
  { npc = 254086, name = "Shenaan Spellwind", class = "MAGE", side = "both", map = 2521, x = 45.00, y = 45.80 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=254086; GEMETEN; Zygor agrees (45.00,45.80)
  { npc = 2485, name = "Larimaine Purdue", class = "MAGE", side = "A", map = 1453, x = 50.20, y = 86.00, kind = "portal" }, -- Stormwind City <Portal Trainer>; https://www.wowhead.com/forever/npc=2485; GEMETEN; Zygor agrees (50.50,85.91); Zygor has this row commented out (-- only portals); dropped 4 old Classic-map coord(s) e.g. (39.4,79.4) whose era->Forever image matches
  { npc = 5958, name = "Thuul", class = "MAGE", side = "H", map = 1454, x = 38.40, y = 85.60, kind = "portal" }, -- Orgrimmar <Portal Trainer>; https://www.wowhead.com/forever/npc=5958; GEMETEN; Zygor agrees (38.68,85.40); Zygor has this row commented out (-- only portals); 4 coords, spread 0.3
  { npc = 2489, name = "Milstaff Stormeye", class = "MAGE", side = "A", map = 1455, x = 25.60, y = 7.60, kind = "portal" }, -- Ironforge <Portal Trainer>; https://www.wowhead.com/forever/npc=2489; GEMETEN; Zygor agrees (25.49,7.06); Zygor has this row commented out (-- only portals); 5 coords, spread 1.0
  { npc = 5957, name = "Birgitte Cranston", class = "MAGE", side = "H", map = 1456, x = 22.20, y = 16.80, kind = "portal" }, -- Thunder Bluff <Portal Trainer>; https://www.wowhead.com/forever/npc=5957; GEMETEN; Zygor agrees (22.49,16.90); Zygor has this row commented out (-- only portals); 4 coords, spread 1.3
  { npc = 4165, name = "Elissa Dumas", class = "MAGE", side = "A", map = 1457, x = 40.40, y = 82.00, kind = "portal" }, -- Darnassus <Portal Trainer>; https://www.wowhead.com/forever/npc=4165; GEMETEN; Zygor agrees (40.59,82.13); Zygor has this row commented out (-- only portals); 5 coords, spread 0.9
  { npc = 2492, name = "Lexington Mortaim", class = "MAGE", side = "H", map = 1458, x = 84.20, y = 16.00, kind = "portal" }, -- Undercity <Portal Trainer>; https://www.wowhead.com/forever/npc=2492; GEMETEN; Zygor agrees (84.19,15.58); Zygor has this row commented out (-- only portals); 6 coords, spread 1.3
  -- PALADIN (15 rows)
  { npc = 244808, name = "Aramis Hammerhand", class = "PALADIN", side = "H", map = 1420, x = 31.00, y = 66.20 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=244808; GEMETEN; Zygor agrees (31.00,66.20)
  { npc = 246152, name = "Shari Stilwell", class = "PALADIN", side = "H", map = 1420, x = 60.20, y = 52.40 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=246152; GEMETEN; Zygor agrees (60.20,52.50); 2 coords, spread 0.2
  { npc = 246389, name = "Hilda the Breaker", class = "PALADIN", side = "H", map = 1420, x = 22.00, y = 47.20 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=246389; GEMETEN; Zygor agrees (22.00,47.20)
  { npc = 926, name = "Bromos Grummner", class = "PALADIN", side = "A", map = 1426, x = 28.80, y = 68.20 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=926; GEMETEN; Zygor agrees (28.83,68.33)
  { npc = 1232, name = "Azar Stronghammer", class = "PALADIN", side = "A", map = 1426, x = 47.40, y = 52.00 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=1232; GEMETEN; Zygor agrees (47.59,52.07); 2 coords, spread 0.2
  { npc = 925, name = "Brother Sammuel", class = "PALADIN", side = "A", map = 1429, x = 50.40, y = 42.00 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=925; GEMETEN; Zygor agrees (50.43,42.12)
  { npc = 927, name = "Brother Wilhelm", class = "PALADIN", side = "A", map = 1429, x = 41.00, y = 66.00 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=927; GEMETEN; Zygor agrees (41.09,66.03)
  { npc = 928, name = "Lord Grayson Shadowbreaker", class = "PALADIN", side = "A", map = 1453, x = 48.40, y = 50.00 }, -- Stormwind City; https://www.wowhead.com/forever/npc=928; GEMETEN; Zygor agrees (48.41,50.17); dropped 2 old Classic-map coord(s) e.g. (37.2,33) whose era->Forever image matches
  { npc = 5491, name = "Arthur the Faithful", class = "PALADIN", side = "A", map = 1453, x = 49.40, y = 49.40 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5491; GEMETEN; Zygor agrees (49.61,49.91); dropped 4 old Classic-map coord(s) e.g. (38.4,32.4) whose era->Forever image matches
  { npc = 5492, name = "Katherine the Pure", class = "PALADIN", side = "A", map = 1453, x = 48.40, y = 49.20 }, -- Stormwind City <Church of the Holy Light>; https://www.wowhead.com/forever/npc=5492; GEMETEN; Zygor agrees (48.50,49.13); dropped 3 old Classic-map coord(s) e.g. (37.4,32) whose era->Forever image matches
  { npc = 5147, name = "Valgar Highforge", class = "PALADIN", side = "A", map = 1455, x = 23.40, y = 5.00 }, -- Ironforge; https://www.wowhead.com/forever/npc=5147; GEMETEN; Zygor agrees (23.70,5.09); 6 coords, spread 1.6
  { npc = 5148, name = "Beldruk Doombrow", class = "PALADIN", side = "A", map = 1455, x = 24.60, y = 5.00 }, -- Ironforge; https://www.wowhead.com/forever/npc=5148; GEMETEN; Zygor agrees (24.54,4.47); 5 coords, spread 1.2
  { npc = 5149, name = "Brandur Ironhammer", class = "PALADIN", side = "A", map = 1455, x = 23.60, y = 6.40 }, -- Ironforge; https://www.wowhead.com/forever/npc=5149; GEMETEN; Zygor agrees (23.13,6.14); 4 coords, spread 0.7
  { npc = 246344, name = "Alodan the Hopeful", class = "PALADIN", side = "H", map = 1456, x = 25.40, y = 14.60 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=246344; GEMETEN; Zygor agrees (25.40,14.55); 4 coords, spread 1.0
  { npc = 260093, name = "Garen Largo", class = "PALADIN", side = "H", map = 1458, x = 47.60, y = 14.80 }, -- Undercity; https://www.wowhead.com/forever/npc=260093; GEMETEN; Zygor agrees (47.40,15.05); 4 coords, spread 0.9
  -- PRIEST (31 rows)
  { npc = 3706, name = "Tai'jin", class = "PRIEST", side = "H", map = 1411, x = 54.20, y = 42.80 }, -- Durotar; https://www.wowhead.com/forever/npc=3706; GEMETEN; Zygor agrees (54.25,42.93)
  { npc = 3707, name = "Ken'jai", class = "PRIEST", side = "H", map = 1411, x = 42.40, y = 68.80 }, -- Durotar; https://www.wowhead.com/forever/npc=3707; GEMETEN; Zygor agrees (42.36,68.81)
  { npc = 2123, name = "Dark Cleric Duesten", class = "PRIEST", side = "H", map = 1420, x = 31.00, y = 66.00 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=2123; GEMETEN; Zygor agrees (31.10,66.03)
  { npc = 2129, name = "Dark Cleric Beryl", class = "PRIEST", side = "H", map = 1420, x = 61.60, y = 52.20 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=2129; GEMETEN; Zygor agrees (61.57,52.19)
  { npc = 837, name = "Branstock Khalder", class = "PRIEST", side = "A", map = 1426, x = 28.60, y = 66.40 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=837; GEMETEN; Zygor agrees (28.59,66.38); 2 coords, spread 0.2
  { npc = 1226, name = "Maxan Anvol", class = "PRIEST", side = "A", map = 1426, x = 47.20, y = 52.20 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=1226; GEMETEN; Zygor agrees (47.34,52.18)
  { npc = 375, name = "Priestess Anetta", class = "PRIEST", side = "A", map = 1429, x = 49.80, y = 39.40 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=375; GEMETEN; Zygor agrees (49.80,39.48); 2 coords, spread 0.2
  { npc = 377, name = "Priestess Josetta", class = "PRIEST", side = "A", map = 1429, x = 43.40, y = 65.60 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=377; GEMETEN; Zygor agrees (43.28,65.72)
  { npc = 3595, name = "Shanda", class = "PRIEST", side = "A", map = 1438, x = 59.20, y = 40.40 }, -- Teldrassil; https://www.wowhead.com/forever/npc=3595; GEMETEN; Zygor agrees (59.17,40.43); 2 coords, spread 0.2
  { npc = 3600, name = "Laurna Morninglight", class = "PRIEST", side = "A", map = 1438, x = 55.40, y = 56.80 }, -- Teldrassil; https://www.wowhead.com/forever/npc=3600; GEMETEN; Zygor agrees (55.56,56.74); 2 coords, spread 0.2
  { npc = 376, name = "High Priestess Laurena", class = "PRIEST", side = "A", map = 1453, x = 49.60, y = 44.80 }, -- Stormwind City; https://www.wowhead.com/forever/npc=376; GEMETEN; Zygor agrees (49.52,44.56); dropped 3 old Classic-map coord(s) e.g. (38.4,26.2) whose era->Forever image matches
  { npc = 5484, name = "Brother Benjamin", class = "PRIEST", side = "A", map = 1453, x = 51.60, y = 46.20 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5484; GEMETEN; Zygor close (52.27,47.64), 1.6 away, 0.8 from nearest Wowhead point; dropped 9 old Classic-map coord(s) e.g. (40.4,26.8) whose era->Forever image matches; unpaired (40.2,26.2)
  { npc = 5489, name = "Brother Joshua", class = "PRIEST", side = "A", map = 1453, x = 49.60, y = 45.20 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5489; GEMETEN; Zygor agrees (49.47,45.16); dropped 3 old Classic-map coord(s) e.g. (38.4,26.6) whose era->Forever image matches
  { npc = 11397, name = "Nara Meideros", class = "PRIEST", side = "A", map = 1453, x = 35.80, y = 63.20 }, -- Stormwind City; https://www.wowhead.com/forever/npc=11397; GEMETEN; Zygor agrees (35.68,63.20); dropped 3 old Classic-map coord(s) e.g. (20.4,50.4) whose era->Forever image matches; unpaired (20.2,50.8)
  { npc = 6014, name = "X'yera", class = "PRIEST", side = "H", map = 1454, x = 35.80, y = 87.60 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=6014; GEMETEN; not in Zygor class sections; 4 coords, spread 0.4
  { npc = 6018, name = "Ur'kyo", class = "PRIEST", side = "H", map = 1454, x = 35.60, y = 87.60 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=6018; GEMETEN; Zygor agrees (35.59,87.81); 3 coords, spread 0.2
  { npc = 5141, name = "Theodrus Frostbeard", class = "PRIEST", side = "A", map = 1455, x = 23.80, y = 9.00 }, -- Ironforge; https://www.wowhead.com/forever/npc=5141; GEMETEN; Zygor agrees (24.08,8.41); 6 coords, spread 1.2
  { npc = 5142, name = "Braenna Flintcrag", class = "PRIEST", side = "A", map = 1455, x = 24.60, y = 9.20 }, -- Ironforge; https://www.wowhead.com/forever/npc=5142; GEMETEN; Zygor agrees (24.42,9.17); 6 coords, spread 1.1
  { npc = 5143, name = "Toldren Deepiron", class = "PRIEST", side = "A", map = 1455, x = 25.60, y = 10.20 }, -- Ironforge; https://www.wowhead.com/forever/npc=5143; GEMETEN; Zygor agrees (25.20,10.75); 6 coords, spread 1.0
  { npc = 11406, name = "High Priest Rohan", class = "PRIEST", side = "A", map = 1455, x = 25.00, y = 8.40 }, -- Ironforge; https://www.wowhead.com/forever/npc=11406; GEMETEN; Zygor agrees (24.72,8.15); 10 coords, spread 2.4 (MULTIPLE SPOTS: [(23.4, 7), (23.6, 6.4), (23.6, 7), (25, 8.4), (25, 8.6), (25.6, 9), (26.4, 7.4), (26.4, 7.6), (26.8, 7.4), (26.8, 7.6)])
  { npc = 258785, name = "High Priestess Mims", class = "PRIEST", side = "A", map = 1455, x = 24.80, y = 10.00 }, -- Ironforge; https://www.wowhead.com/forever/npc=258785; GEMETEN; Zygor agrees (24.80,10.00); 3 coords, spread 0.9
  { npc = 3044, name = "Miles Welsh", class = "PRIEST", side = "H", map = 1456, x = 25.40, y = 15.60 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3044; GEMETEN; Zygor agrees (25.31,15.26); 5 coords, spread 1.0
  { npc = 3045, name = "Malakai Cross", class = "PRIEST", side = "H", map = 1456, x = 24.60, y = 22.40 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3045; GEMETEN; Zygor agrees (24.55,22.57); 4 coords, spread 1.2
  { npc = 3046, name = "Father Cobb", class = "PRIEST", side = "H", map = 1456, x = 25.60, y = 21.00 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3046; GEMETEN; Zygor agrees (25.63,20.69); 5 coords, spread 1.0
  { npc = 4090, name = "Astarii Starseeker", class = "PRIEST", side = "A", map = 1457, x = 38.40, y = 80.80 }, -- Darnassus; https://www.wowhead.com/forever/npc=4090; GEMETEN; Zygor agrees (38.33,80.95); 5 coords, spread 1.0
  { npc = 4091, name = "Jandria", class = "PRIEST", side = "A", map = 1457, x = 38.00, y = 82.40 }, -- Darnassus; https://www.wowhead.com/forever/npc=4091; GEMETEN; Zygor agrees (37.89,82.73); 3 coords, spread 0.7
  { npc = 4092, name = "Lariia", class = "PRIEST", side = "A", map = 1457, x = 40.60, y = 88.60 }, -- Darnassus; https://www.wowhead.com/forever/npc=4092; GEMETEN; Zygor agrees (40.34,88.68); 6 coords, spread 1.3
  { npc = 11401, name = "Priestess Alathea", class = "PRIEST", side = "A", map = 1457, x = 39.60, y = 80.80 }, -- Darnassus; https://www.wowhead.com/forever/npc=11401; GEMETEN; Zygor agrees (39.52,81.19); 5 coords, spread 0.9
  { npc = 4606, name = "Aelthalyste", class = "PRIEST", side = "H", map = 1458, x = 49.20, y = 18.20 }, -- Undercity; https://www.wowhead.com/forever/npc=4606; GEMETEN; Zygor agrees (48.99,18.32); 5 coords, spread 1.4
  { npc = 4607, name = "Father Lankester", class = "PRIEST", side = "H", map = 1458, x = 49.40, y = 15.40 }, -- Undercity; https://www.wowhead.com/forever/npc=4607; GEMETEN; Zygor agrees (49.13,14.60); 4 coords, spread 0.3
  { npc = 4608, name = "Father Lazarus", class = "PRIEST", side = "H", map = 1458, x = 47.40, y = 19.20 }, -- Undercity; https://www.wowhead.com/forever/npc=4608; GEMETEN; Zygor agrees (47.56,18.90); 3 coords, spread 0.8
  -- ROGUE (27 rows)
  { npc = 3155, name = "Rwag", class = "ROGUE", side = "H", map = 1411, x = 41.20, y = 68.00 }, -- Durotar; https://www.wowhead.com/forever/npc=3155; GEMETEN; Zygor agrees (41.27,68.00)
  { npc = 3170, name = "Kaplak", class = "ROGUE", side = "H", map = 1411, x = 52.00, y = 43.40 }, -- Durotar; https://www.wowhead.com/forever/npc=3170; GEMETEN; Zygor agrees (51.97,43.69); 2 coords, spread 0.2
  { npc = 2122, name = "David Trias", class = "ROGUE", side = "H", map = 1420, x = 32.40, y = 65.60 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=2122; GEMETEN; Zygor agrees (32.53,65.65); 2 coords, spread 0.2
  { npc = 2130, name = "Marion Call", class = "ROGUE", side = "H", map = 1420, x = 61.60, y = 52.00 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=2130; GEMETEN; Zygor agrees (61.75,51.99)
  { npc = 916, name = "Solm Hargrin", class = "ROGUE", side = "A", map = 1426, x = 28.40, y = 67.40 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=916; GEMETEN; Zygor agrees (28.36,67.51); 2 coords, spread 0.2
  { npc = 1234, name = "Hogral Bakkan", class = "ROGUE", side = "A", map = 1426, x = 47.60, y = 52.40 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=1234; GEMETEN; Zygor agrees (47.56,52.60); 3 coords, spread 0.2
  { npc = 915, name = "Jorik Kerridan", class = "ROGUE", side = "A", map = 1429, x = 50.40, y = 39.80 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=915; GEMETEN; Zygor agrees (50.31,39.91); 2 coords, spread 0.3
  { npc = 917, name = "Keryn Sylvius", class = "ROGUE", side = "A", map = 1429, x = 43.80, y = 65.80 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=917; GEMETEN; Zygor agrees (43.87,65.93)
  { npc = 3594, name = "Frahun Shadewhisper", class = "ROGUE", side = "A", map = 1438, x = 59.40, y = 38.80 }, -- Teldrassil; https://www.wowhead.com/forever/npc=3594; GEMETEN; Zygor agrees (59.63,38.66); 2 coords, spread 0.3
  { npc = 3599, name = "Jannok Breezesong", class = "ROGUE", side = "A", map = 1438, x = 56.20, y = 60.00 }, -- Teldrassil; https://www.wowhead.com/forever/npc=3599; GEMETEN; Zygor agrees (56.38,60.13)
  { npc = 918, name = "Osborne the Night Man", class = "ROGUE", side = "A", map = 1453, x = 77.20, y = 65.20 }, -- Stormwind City; https://www.wowhead.com/forever/npc=918; GEMETEN; Zygor agrees (77.43,65.30); dropped 3 old Classic-map coord(s) e.g. (74,52.4) whose era->Forever image matches; unpaired (74.8,53.8)
  { npc = 13283, name = "Lord Tony Romano", class = "ROGUE", side = "A", map = 1453, x = 80.20, y = 68.80 }, -- Stormwind City; https://www.wowhead.com/forever/npc=13283; GEMETEN; Zygor agrees (80.28,68.57); dropped 2 old Classic-map coord(s) e.g. (78.2,57.2) whose era->Forever image matches
  { npc = 3327, name = "Gest", class = "ROGUE", side = "H", map = 1454, x = 42.80, y = 51.40 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3327; GEMETEN; Zygor agrees (42.69,51.47); 3 coords, spread 1.0
  { npc = 3328, name = "Ormok", class = "ROGUE", side = "H", map = 1454, x = 44.00, y = 54.40 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3328; GEMETEN; Zygor agrees (43.90,54.62); 2 coords, spread 0.2
  { npc = 3401, name = "Shenthul", class = "ROGUE", side = "H", map = 1454, x = 43.00, y = 53.40 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3401; GEMETEN; Zygor agrees (43.04,53.73); 2 coords, spread 0.2
  { npc = 5165, name = "Hulfdan Blackbeard", class = "ROGUE", side = "A", map = 1455, x = 51.60, y = 14.60 }, -- Ironforge; https://www.wowhead.com/forever/npc=5165; GEMETEN; Zygor agrees (51.95,14.84); 7 coords, spread 1.5
  { npc = 5166, name = "Ormyr Flinteye", class = "ROGUE", side = "A", map = 1455, x = 52.60, y = 14.80 }, -- Ironforge; https://www.wowhead.com/forever/npc=5166; GEMETEN; Zygor agrees (52.88,15.00); 4 coords, spread 1.6
  { npc = 5167, name = "Fenthwick", class = "ROGUE", side = "A", map = 1455, x = 51.60, y = 15.00 }, -- Ironforge; https://www.wowhead.com/forever/npc=5167; GEMETEN; Zygor agrees (51.50,15.32); 4 coords, spread 1.5
  { npc = 4163, name = "Syurna", class = "ROGUE", side = "A", map = 1457, x = 36.20, y = 21.60 }, -- Darnassus; https://www.wowhead.com/forever/npc=4163; GEMETEN; Zygor agrees (36.99,21.90); 3 coords, spread 0.6
  { npc = 4214, name = "Erion Shadewhisper", class = "ROGUE", side = "A", map = 1457, x = 34.60, y = 25.60 }, -- Darnassus; https://www.wowhead.com/forever/npc=4214; GEMETEN; Zygor agrees (34.52,25.93); 4 coords, spread 0.7
  { npc = 4215, name = "Anishar", class = "ROGUE", side = "A", map = 1457, x = 37.80, y = 21.20 }, -- Darnassus; https://www.wowhead.com/forever/npc=4215; GEMETEN; Zygor agrees (37.92,20.91); 5 coords, spread 1.6
  { npc = 4582, name = "Carolyn Ward", class = "ROGUE", side = "H", map = 1458, x = 83.80, y = 71.60 }, -- Undercity; https://www.wowhead.com/forever/npc=4582; GEMETEN; Zygor agrees (83.85,72.06); 6 coords, spread 1.4
  { npc = 4583, name = "Miles Dexter", class = "ROGUE", side = "H", map = 1458, x = 85.00, y = 71.20 }, -- Undercity; https://www.wowhead.com/forever/npc=4583; GEMETEN; Zygor agrees (85.21,71.57); 5 coords, spread 1.0
  { npc = 4584, name = "Gregory Charles", class = "ROGUE", side = "H", map = 1458, x = 84.60, y = 73.20 }, -- Undercity; https://www.wowhead.com/forever/npc=4584; GEMETEN; Zygor agrees (84.88,73.52); 6 coords, spread 1.2
  { npc = 251389, name = "Akeri Duskblade", class = "ROGUE", side = "both", map = 2521, x = 43.60, y = 24.20 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=251389; GEMETEN; Zygor agrees (43.60,24.20)
  { npc = 252379, name = "Eltheen Nightbreeze", class = "ROGUE", side = "both", map = 2521, x = 59.80, y = 72.40 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=252379; GEMETEN; Zygor agrees (59.80,72.50); 2 coords, spread 0.2
  { npc = 254087, name = "Miriaan Mistblade", class = "ROGUE", side = "both", map = 2521, x = 43.20, y = 43.20 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=254087; GEMETEN; Zygor agrees (43.20,43.20)
  -- SHAMAN (17 rows)
  { npc = 3157, name = "Shikrik", class = "SHAMAN", side = "H", map = 1411, x = 42.40, y = 69.00 }, -- Durotar; https://www.wowhead.com/forever/npc=3157; GEMETEN; Zygor agrees (42.39,69.00)
  { npc = 3173, name = "Swart", class = "SHAMAN", side = "H", map = 1411, x = 54.40, y = 42.40 }, -- Durotar; https://www.wowhead.com/forever/npc=3173; GEMETEN; Zygor agrees (54.41,42.58); 2 coords, spread 0.2
  { npc = 3062, name = "Meela Dawnstrider", class = "SHAMAN", side = "H", map = 1412, x = 44.60, y = 76.60 }, -- Mulgore; https://www.wowhead.com/forever/npc=3062; GEMETEN; Zygor agrees (44.58,76.56); dropped 1 old Classic-map coord(s) e.g. (45,76) whose era->Forever image matches
  { npc = 3066, name = "Narm Skychaser", class = "SHAMAN", side = "H", map = 1412, x = 47.40, y = 62.60 }, -- Mulgore; https://www.wowhead.com/forever/npc=3066; GEMETEN; Zygor agrees (47.40,62.54); dropped 1 old Classic-map coord(s) e.g. (48.4,59.2) whose era->Forever image matches
  { npc = 262558, name = "Palah Thunderhoof", class = "SHAMAN", side = "H", map = 1412, x = 33.40, y = 22.40 }, -- Mulgore; https://www.wowhead.com/forever/npc=262558; GEMETEN; Zygor agrees (33.50,22.40); Zygor side sH vs Wowhead react [None, 0]; new Forever NPC, no Classic coords; side H AFGELEID (Wowhead react [None, 0] = neutral to Horde; Horde zone; Zygor sH)
  { npc = 257446, name = "Teo Hammerstorm", class = "SHAMAN", side = "A", map = 1426, x = 28.80, y = 66.20 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=257446; GEMETEN; Zygor agrees (28.70,66.10)
  { npc = 258113, name = "Ingrid Dunwald", class = "SHAMAN", side = "A", map = 1426, x = 47.40, y = 52.00 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=258113; GEMETEN; Zygor agrees (47.50,52.00); 2 coords, spread 0.2
  { npc = 3344, name = "Kardris Dreamseeker", class = "SHAMAN", side = "H", map = 1454, x = 38.80, y = 36.60 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3344; GEMETEN; Zygor agrees (38.80,36.36); 3 coords, spread 0.7
  { npc = 3403, name = "Sian'tsu", class = "SHAMAN", side = "H", map = 1454, x = 37.80, y = 36.60 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3403; GEMETEN; Zygor agrees (37.83,36.45); 3 coords, spread 0.7
  { npc = 13417, name = "Sagorne Creststrider", class = "SHAMAN", side = "H", map = 1454, x = 38.60, y = 36.20 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=13417; GEMETEN; Zygor agrees (38.65,35.92); 3 coords, spread 0.4
  { npc = 258098, name = "Eldrun Stormbreaker", class = "SHAMAN", side = "A", map = 1455, x = 47.40, y = 13.40 }, -- Ironforge; https://www.wowhead.com/forever/npc=258098; GEMETEN; Zygor close (46.20,13.00), 1.3 away, 0.4 from nearest Wowhead point; 7 coords, spread 1.4
  { npc = 3030, name = "Siln Skychaser", class = "SHAMAN", side = "H", map = 1456, x = 23.60, y = 20.60 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3030; GEMETEN; Zygor agrees (22.82,21.11); 4 coords, spread 0.6
  { npc = 3031, name = "Tigor Skychaser", class = "SHAMAN", side = "H", map = 1456, x = 23.60, y = 19.20 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3031; GEMETEN; Zygor agrees (23.64,18.79); 4 coords, spread 0.8
  { npc = 3032, name = "Beram Skychaser", class = "SHAMAN", side = "H", map = 1456, x = 22.60, y = 19.60 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3032; GEMETEN; Zygor close (21.98,18.80), 1.0 away, 0.3 from nearest Wowhead point; 4 coords, spread 0.7
  { npc = 251374, name = "Windshaper Boro", class = "SHAMAN", side = "H", map = 2521, x = 42.70, y = 23.50 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=251374; GEMETEN; Zygor agrees (42.80,23.50); 2 coords, spread 0.1
  { npc = 252382, name = "Sessaria Skystride", class = "SHAMAN", side = "H", map = 2521, x = 58.20, y = 78.40 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=252382; GEMETEN; Zygor agrees (58.20,78.50); 2 coords, spread 0.2
  { npc = 254082, name = "Aarnor Galestrike", class = "SHAMAN", side = "H", map = 2521, x = 43.40, y = 44.80 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=254082; GEMETEN; Zygor agrees (43.50,44.80); 2 coords, spread 0.2
  -- WARLOCK (32 rows)
  { npc = 3156, name = "Nartok", class = "WARLOCK", side = "H", map = 1411, x = 40.60, y = 68.40 }, -- Durotar; https://www.wowhead.com/forever/npc=3156; GEMETEN; Zygor agrees (40.65,68.51)
  { npc = 3172, name = "Dhugru Gorelust", class = "WARLOCK", side = "H", map = 1411, x = 54.20, y = 41.20 }, -- Durotar; https://www.wowhead.com/forever/npc=3172; GEMETEN; Zygor agrees (54.38,41.19)
  { npc = 2126, name = "Maximillion", class = "WARLOCK", side = "H", map = 1420, x = 30.80, y = 66.20 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=2126; GEMETEN; Zygor agrees (30.91,66.33)
  { npc = 2127, name = "Rupert Boch", class = "WARLOCK", side = "H", map = 1420, x = 61.60, y = 52.40 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=2127; GEMETEN; Zygor agrees (61.58,52.39); 2 coords, spread 0.2
  { npc = 460, name = "Alamar Grimm", class = "WARLOCK", side = "A", map = 1426, x = 28.60, y = 66.20 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=460; GEMETEN; Zygor agrees (28.64,66.14)
  { npc = 5612, name = "Gimrizz Shadowcog", class = "WARLOCK", side = "A", map = 1426, x = 47.20, y = 53.40 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=5612; GEMETEN; Zygor agrees (47.32,53.69); 2 coords, spread 0.2
  { npc = 459, name = "Drusilla La Salle", class = "WARLOCK", side = "A", map = 1429, x = 49.80, y = 42.60 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=459; GEMETEN; Zygor agrees (49.87,42.64)
  { npc = 906, name = "Maximillian Crowe", class = "WARLOCK", side = "A", map = 1429, x = 44.40, y = 66.00 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=906; GEMETEN; Zygor agrees (44.39,66.24)
  { npc = 461, name = "Demisette Cloyce", class = "WARLOCK", side = "A", map = 1453, x = 39.20, y = 85.00 }, -- Stormwind City; https://www.wowhead.com/forever/npc=461; GEMETEN; Zygor agrees (39.24,84.96); dropped 3 old Classic-map coord(s) e.g. (25.4,78.2) whose era->Forever image matches
  { npc = 5495, name = "Ursula Deline", class = "WARLOCK", side = "A", map = 1453, x = 40.00, y = 84.20 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5495; GEMETEN; Zygor agrees (39.88,84.18); dropped 3 old Classic-map coord(s) e.g. (26,77.6) whose era->Forever image matches
  { npc = 5496, name = "Sandahl", class = "WARLOCK", side = "A", map = 1453, x = 39.60, y = 85.40 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5496; GEMETEN; Zygor agrees (39.65,85.74); dropped 3 old Classic-map coord(s) e.g. (25.4,78.4) whose era->Forever image matches
  { npc = 3324, name = "Grol'dar", class = "WARLOCK", side = "H", map = 1454, x = 48.00, y = 46.20 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3324; GEMETEN; Zygor agrees (47.98,45.93); 2 coords, spread 0.6
  { npc = 3325, name = "Mirket", class = "WARLOCK", side = "H", map = 1454, x = 48.40, y = 47.00 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3325; GEMETEN; Zygor agrees (48.61,46.95); 3 coords, spread 0.6
  { npc = 3326, name = "Zevrost", class = "WARLOCK", side = "H", map = 1454, x = 48.40, y = 45.60 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3326; GEMETEN; Zygor agrees (48.46,45.42); 3 coords, spread 0.3
  { npc = 5171, name = "Thistleheart", class = "WARLOCK", side = "A", map = 1455, x = 50.40, y = 6.60 }, -- Ironforge; https://www.wowhead.com/forever/npc=5171; GEMETEN; Zygor agrees (51.08,6.61); 5 coords, spread 1.9
  { npc = 5172, name = "Briarthorn", class = "WARLOCK", side = "A", map = 1455, x = 50.20, y = 6.00 }, -- Ironforge; https://www.wowhead.com/forever/npc=5172; GEMETEN; Zygor agrees (50.34,5.65); 4 coords, spread 1.4
  { npc = 5173, name = "Alexander Calder", class = "WARLOCK", side = "A", map = 1455, x = 50.60, y = 6.80 }, -- Ironforge; https://www.wowhead.com/forever/npc=5173; GEMETEN; Zygor agrees (50.08,7.45); 6 coords, spread 1.2
  { npc = 4563, name = "Kaal Soulreaper", class = "WARLOCK", side = "H", map = 1458, x = 86.00, y = 15.60 }, -- Undercity; https://www.wowhead.com/forever/npc=4563; GEMETEN; Zygor agrees (86.20,15.92); 4 coords, spread 0.8
  { npc = 4564, name = "Luther Pickman", class = "WARLOCK", side = "H", map = 1458, x = 85.40, y = 15.40 }, -- Undercity; https://www.wowhead.com/forever/npc=4564; GEMETEN; Zygor close (86.42,15.25), 1.0 away, 0.2 from nearest Wowhead point; 4 coords, spread 0.8
  { npc = 4565, name = "Richard Kerwin", class = "WARLOCK", side = "H", map = 1458, x = 88.60, y = 16.00 }, -- Undercity; https://www.wowhead.com/forever/npc=4565; GEMETEN; Zygor agrees (88.90,15.86); 5 coords, spread 1.3
  { npc = 6027, name = "Kitha", class = "WARLOCK", side = "H", map = 1411, x = 54.60, y = 41.40, kind = "demon" }, -- Durotar <Demon Trainer>; https://www.wowhead.com/forever/npc=6027; GEMETEN; not in Zygor class sections; 3 coords, spread 0.2
  { npc = 12776, name = "Hraug", class = "WARLOCK", side = "H", map = 1411, x = 40.60, y = 68.40, kind = "demon" }, -- Durotar <Demon Trainer>; https://www.wowhead.com/forever/npc=12776; GEMETEN; not in Zygor class sections
  { npc = 5749, name = "Kayla Smithe", class = "WARLOCK", side = "H", map = 1420, x = 30.80, y = 66.40, kind = "demon" }, -- Tirisfal Glades <Demon Trainer>; https://www.wowhead.com/forever/npc=5749; GEMETEN; not in Zygor class sections
  { npc = 5750, name = "Gina Lang", class = "WARLOCK", side = "H", map = 1420, x = 61.60, y = 52.40, kind = "demon" }, -- Tirisfal Glades <Demon Trainer>; https://www.wowhead.com/forever/npc=5750; GEMETEN; not in Zygor class sections; 2 coords, spread 0.2
  { npc = 6328, name = "Dannie Fizzwizzle", class = "WARLOCK", side = "A", map = 1426, x = 47.20, y = 53.40, kind = "demon" }, -- Dun Morogh <Demon Trainer>; https://www.wowhead.com/forever/npc=6328; GEMETEN; not in Zygor class sections; 2 coords, spread 0.2
  { npc = 6376, name = "Wren Darkspring", class = "WARLOCK", side = "A", map = 1426, x = 28.80, y = 66.20, kind = "demon" }, -- Dun Morogh <Demon Trainer>; https://www.wowhead.com/forever/npc=6376; GEMETEN; not in Zygor class sections
  { npc = 6373, name = "Dane Winslow", class = "WARLOCK", side = "A", map = 1429, x = 50.00, y = 42.60, kind = "demon" }, -- Elwynn Forest <Demon Trainer>; https://www.wowhead.com/forever/npc=6373; GEMETEN; not in Zygor class sections
  { npc = 6374, name = "Cylina Darkheart", class = "WARLOCK", side = "A", map = 1429, x = 44.40, y = 66.00, kind = "demon" }, -- Elwynn Forest <Demon Trainer>; https://www.wowhead.com/forever/npc=6374; GEMETEN; not in Zygor class sections
  { npc = 5520, name = "Spackle Thornberry", class = "WARLOCK", side = "A", map = 1453, x = 39.60, y = 84.60, kind = "demon" }, -- Stormwind City <Demon Trainer>; https://www.wowhead.com/forever/npc=5520; GEMETEN; not in Zygor class sections; dropped 3 old Classic-map coord(s) e.g. (25.4,77.8) whose era->Forever image matches; unpaired (25.4,78.6)
  { npc = 5815, name = "Kurgul", class = "WARLOCK", side = "H", map = 1454, x = 47.40, y = 46.80, kind = "demon" }, -- Orgrimmar <Demon Trainer>; https://www.wowhead.com/forever/npc=5815; GEMETEN; not in Zygor class sections; 4 coords, spread 0.8
  { npc = 6382, name = "Jubahl Corpseseeker", class = "WARLOCK", side = "A", map = 1455, x = 53.20, y = 6.60, kind = "demon" }, -- Ironforge <Demon Trainer>; https://www.wowhead.com/forever/npc=6382; GEMETEN; not in Zygor class sections; 3 coords, spread 1.0
  { npc = 5753, name = "Martha Strain", class = "WARLOCK", side = "H", map = 1458, x = 85.40, y = 15.40, kind = "demon" }, -- Undercity <Demon Trainer>; https://www.wowhead.com/forever/npc=5753; GEMETEN; not in Zygor class sections; 4 coords, spread 0.6
  -- WARRIOR (33 rows)
  { npc = 3153, name = "Frang", class = "WARRIOR", side = "H", map = 1411, x = 42.80, y = 69.40 }, -- Durotar; https://www.wowhead.com/forever/npc=3153; GEMETEN; Zygor agrees (42.88,69.43)
  { npc = 3169, name = "Tarshaw Jaggedscar", class = "WARRIOR", side = "H", map = 1411, x = 54.00, y = 42.60 }, -- Durotar; https://www.wowhead.com/forever/npc=3169; GEMETEN; Zygor agrees (54.18,42.46); 2 coords, spread 0.3
  { npc = 3059, name = "Harutt Thunderhorn", class = "WARRIOR", side = "H", map = 1412, x = 43.80, y = 76.60 }, -- Mulgore; https://www.wowhead.com/forever/npc=3059; GEMETEN; Zygor agrees (43.74,76.72); dropped 1 old Classic-map coord(s) e.g. (44,76) whose era->Forever image matches
  { npc = 3063, name = "Krang Stonehoof", class = "WARRIOR", side = "H", map = 1412, x = 48.40, y = 63.60 }, -- Mulgore; https://www.wowhead.com/forever/npc=3063; GEMETEN; Zygor agrees (48.34,63.73); dropped 4 old Classic-map coord(s) e.g. (49.4,60.4) whose era->Forever image matches
  { npc = 2119, name = "Dannal Stern", class = "WARRIOR", side = "H", map = 1420, x = 32.40, y = 65.60 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=2119; GEMETEN; Zygor agrees (32.68,65.56); 2 coords, spread 0.2
  { npc = 2131, name = "Austil de Mon", class = "WARRIOR", side = "H", map = 1420, x = 61.80, y = 52.40 }, -- Tirisfal Glades; https://www.wowhead.com/forever/npc=2131; GEMETEN; Zygor agrees (61.85,52.53); 2 coords, spread 0.2
  { npc = 912, name = "Thran Khorman", class = "WARRIOR", side = "A", map = 1426, x = 28.80, y = 67.20 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=912; GEMETEN; Zygor agrees (28.83,67.23)
  { npc = 1229, name = "Granis Swiftaxe", class = "WARRIOR", side = "A", map = 1426, x = 47.20, y = 52.40 }, -- Dun Morogh; https://www.wowhead.com/forever/npc=1229; GEMETEN; Zygor agrees (47.35,52.64); 2 coords, spread 0.2
  { npc = 911, name = "Llane Beshere", class = "WARRIOR", side = "A", map = 1429, x = 50.20, y = 42.20 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=911; GEMETEN; Zygor agrees (50.24,42.28)
  { npc = 913, name = "Lyria Du Lac", class = "WARRIOR", side = "A", map = 1429, x = 41.00, y = 65.80 }, -- Elwynn Forest; https://www.wowhead.com/forever/npc=913; GEMETEN; Zygor agrees (41.08,65.76)
  { npc = 3593, name = "Alyissia", class = "WARRIOR", side = "A", map = 1438, x = 59.60, y = 38.60 }, -- Teldrassil; https://www.wowhead.com/forever/npc=3593; GEMETEN; Zygor agrees (59.63,38.44); 3 coords, spread 0.2
  { npc = 3598, name = "Kyra Windblade", class = "WARRIOR", side = "A", map = 1438, x = 56.20, y = 59.20 }, -- Teldrassil; https://www.wowhead.com/forever/npc=3598; GEMETEN; Zygor agrees (56.22,59.19)
  { npc = 914, name = "Ander Germaine", class = "WARRIOR", side = "A", map = 1453, x = 80.20, y = 61.00 }, -- Stormwind City; https://www.wowhead.com/forever/npc=914; GEMETEN; Zygor agrees (80.19,61.25); dropped 3 old Classic-map coord(s) e.g. (78.2,47.2) whose era->Forever image matches
  { npc = 5479, name = "Wu Shen", class = "WARRIOR", side = "A", map = 1453, x = 80.60, y = 59.60 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5479; GEMETEN; Zygor agrees (80.55,59.87); dropped 2 old Classic-map coord(s) e.g. (78.8,45.4) whose era->Forever image matches
  { npc = 5480, name = "Ilsa Corbin", class = "WARRIOR", side = "A", map = 1453, x = 80.40, y = 59.60 }, -- Stormwind City; https://www.wowhead.com/forever/npc=5480; GEMETEN; Zygor agrees (80.41,59.80); dropped 3 old Classic-map coord(s) e.g. (78.4,45.6) whose era->Forever image matches
  { npc = 3353, name = "Grezz Ragefist", class = "WARRIOR", side = "H", map = 1454, x = 79.40, y = 31.20 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3353; GEMETEN; Zygor agrees (79.78,31.41); 4 coords, spread 0.4
  { npc = 3354, name = "Sorek", class = "WARRIOR", side = "H", map = 1454, x = 80.20, y = 32.40 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3354; GEMETEN; Zygor agrees (80.39,32.38); 3 coords, spread 1.0
  { npc = 3408, name = "Zel'mak", class = "WARRIOR", side = "H", map = 1454, x = 80.20, y = 29.40 }, -- Orgrimmar; https://www.wowhead.com/forever/npc=3408; GEMETEN; Zygor agrees (80.37,29.50); 2 coords, spread 0.2
  { npc = 1901, name = "Kelstrum Stonebreaker", class = "WARRIOR", side = "A", map = 1455, x = 67.00, y = 89.40 }, -- Ironforge; https://www.wowhead.com/forever/npc=1901; GEMETEN; Zygor agrees (66.96,90.14); 3 coords, spread 1.0
  { npc = 5113, name = "Kelv Sternhammer", class = "WARRIOR", side = "A", map = 1455, x = 70.00, y = 90.60 }, -- Ironforge; https://www.wowhead.com/forever/npc=5113; GEMETEN; Zygor agrees (70.33,90.65); 7 coords, spread 1.6
  { npc = 5114, name = "Bilban Tosslespanner", class = "WARRIOR", side = "A", map = 1455, x = 66.80, y = 87.60 }, -- Ironforge; https://www.wowhead.com/forever/npc=5114; GEMETEN; Zygor close (65.90,88.40), 1.2 away, 0.4 from nearest Wowhead point; 4 coords, spread 1.2
  { npc = 3041, name = "Torm Ragetotem", class = "WARRIOR", side = "H", map = 1456, x = 57.40, y = 87.20 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3041; GEMETEN; Zygor agrees (57.24,87.37); 4 coords, spread 0.4
  { npc = 3042, name = "Sark Ragetotem", class = "WARRIOR", side = "H", map = 1456, x = 57.60, y = 88.60 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3042; GEMETEN; Zygor close (56.99,89.51), 1.1 away, 0.1 from nearest Wowhead point; 5 coords, spread 1.2
  { npc = 3043, name = "Ker Ragetotem", class = "WARRIOR", side = "H", map = 1456, x = 57.80, y = 85.40 }, -- Thunder Bluff; https://www.wowhead.com/forever/npc=3043; GEMETEN; Zygor agrees (57.57,85.50); 2 coords, spread 0.2
  { npc = 4087, name = "Arias'ta Bladesinger", class = "WARRIOR", side = "A", map = 1457, x = 58.40, y = 35.00 }, -- Darnassus; https://www.wowhead.com/forever/npc=4087; GEMETEN; Zygor agrees (58.71,34.89); 5 coords, spread 0.8
  { npc = 4089, name = "Sildanair", class = "WARRIOR", side = "A", map = 1457, x = 61.80, y = 41.80 }, -- Darnassus; https://www.wowhead.com/forever/npc=4089; GEMETEN; Zygor agrees (61.77,42.21); 4 coords, spread 1.8
  { npc = 7315, name = "Darnath Bladesinger", class = "WARRIOR", side = "A", map = 1457, x = 58.40, y = 35.40 }, -- Darnassus; https://www.wowhead.com/forever/npc=7315; GEMETEN; Zygor agrees (58.93,35.34); 4 coords, spread 0.3
  { npc = 4593, name = "Christoph Walker", class = "WARRIOR", side = "H", map = 1458, x = 47.20, y = 15.20 }, -- Undercity; https://www.wowhead.com/forever/npc=4593; GEMETEN; Zygor agrees (46.93,15.22); 5 coords, spread 1.5
  { npc = 4594, name = "Angela Curthas", class = "WARRIOR", side = "H", map = 1458, x = 48.20, y = 15.40 }, -- Undercity; https://www.wowhead.com/forever/npc=4594; GEMETEN; Zygor agrees (48.32,15.96); 3 coords, spread 1.0
  { npc = 4595, name = "Baltus Fowler", class = "WARRIOR", side = "H", map = 1458, x = 47.60, y = 16.80 }, -- Undercity; https://www.wowhead.com/forever/npc=4595; GEMETEN; Zygor agrees (47.40,17.29); 5 coords, spread 1.3
  { npc = 251964, name = "Blademaster Ren", class = "WARRIOR", side = "both", map = 2521, x = 43.40, y = 24.20 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=251964; GEMETEN; Zygor agrees (43.50,24.20); 2 coords, spread 0.2
  { npc = 252377, name = "Seena Skybreaker", class = "WARRIOR", side = "both", map = 2521, x = 59.80, y = 72.80 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=252377; GEMETEN; Zygor agrees (59.80,72.80)
  { npc = 254088, name = "Corsan Earthrazer", class = "WARRIOR", side = "both", map = 2521, x = 44.80, y = 45.20 }, -- Zephras Isle; https://www.wowhead.com/forever/npc=254088; GEMETEN; Zygor agrees (44.80,45.20)
}
```

## Missing

- **No in-scope trainer is missing a Forever coordinate.** All 249 Wowhead NPC pages answered 200 with `g_mapperData`.
- Every in-scope Zygor class-trainer ID is also in the Wowhead roster (GEMETEN, `zygor_only.txt`: the 20 Zygor rows not in
  the roster are all field trainers on other maps).

## Disputed / check in game

1. **257944 Elegael Thornpaw** (Zephras Isle 2521, 61.60/39.20 on Wowhead). Zygor lists her under `ClassDruid` (sB).
   Wowhead tag is `<Nightclaw Druid>`, react [0,0] (neutral), and she is in neither Wowhead trainer filter. Zephras Isle
   has 20+ more `<Nightclaw Druid>` NPCs. **Left out of the block.** Ask Rob to check in game.
2. **205729 Boarton Shadetotem** (Thunder Bluff 1456, Wowhead 39.40-39.60 / 64.40-65.60, tag `<Rogue Trainer?>`, react H).
   Wowhead's "Trainer" filter includes him and Zygor lists him under `ClassRogue` (39.5, 64.4). But Tauren rogue is not a
   Forever race/class combo per warcraft.wiki.gg/wiki/Forever (Tauren row: no new class) - AFGELEID that he is a quest NPC,
   not a real rogue trainer. **Left out of the block.**
3. **5492 Katherine the Pure** `<Church of the Holy Light>` and **331 Maginor Dumas** `<Master Mage>`: no "Trainer" tag on
   Wowhead Forever, but both are in Wowhead's "Class trainer" filter and in Zygor's class sections. Class PALADIN / MAGE is
   AFGELEID from that. Included.
4. **Zephras Isle sides.** Wowhead react: the 3 shaman trainers are Horde-only [-1,1]; 251379 Dorii Brightwhisper (mage) is
   Alliance-only [1,-1]; but mages 252373 and 254086 are [1,1] ("both"). Sources say only Alliance Skyborne can be mages
   (warcraft.wiki.gg/wiki/Forever). Zygor also has those two as sB. Kept as measured ("both"); MH may want "A".
5. **262558 Palah Thunderhoof / 262560 Hana Lighthoof** (Mulgore 33.4/22.x, new in Forever): Wowhead react [null,0] =
   neutral to Horde. `side = "H"` is AFGELEID (Horde zone, Zygor sH).
6. **Zygor "close" rows** (Zygor point 1.0-1.6 from the chosen Wowhead point, but only 0.1-0.8 from some Wowhead point;
   wandering NPCs, not a real disagreement): 3406, 5117, 3038, 3039, 5484, 258098, 3032, 4564, 5114, 3042.
   **Zygor disagreements > 2 units: 0. Zygor rows that still use an old Classic-map point on 1453/1412: 0.**
7. **Several spots on Wowhead:** 2878 Peria Lamenur (Dun Morogh 46.6/54.0 and 71.0/38.0, 29 apart; Zygor has only
   46.68/53.99); 5146 Nittlebur Sparkfizzle and 11406 High Priest Rohan wander 2-4 units inside Ironforge.
8. **Zygor commented these out** but Wowhead lists them as trainers, so they are in the block: 944, 2124, 5884
   ("very limited", start-area mage trainers) and the 6 portal trainers ("only portals").
9. **Not in Zygor at all:** 6014 X'yera (Orgrimmar priest), 258930 Isaac Chan (Elwynn pet trainer, new),
   254411 Quel'dora Quickgale (Zephras pet trainer), and all 12 demon trainers (Zygor has no demon section).

## Outside the brief (measured, not in the block)

- The Hinterlands (uiMap 1425), both new in Forever, react [null,null] so side unknown:
  `270278 Bordolf Axegrim <Warrior Trainer> 14.40/43.00` and `270280 Torin Treehame <Hunter Trainer> 14.60/43.00`
  (Wowhead npc pages, 7 Nov 2026, GEMETEN).
- Riverglades (area 16591, uiMap 2548): zone page has 222 NPCs, the only trainer is 260080 `<Weapons Trainer>`, so no class
  trainers there (GEMETEN; positive control = the same method found trainers in all 14 other zones).
  Ruins of Lordaeron (area 16611): 33 NPCs, no trainers. Mount Hyjal (2482) and Shen'dralas (2652): not checked.
- Field trainers seen in Wowhead's Trainer filter but not measured: 12042, 8142, 9465, 543, 5501, 3963, 8308, 3698, 4320,
  3702, 10930, 3545, 986, 987, 988, 985, 3622, 1404, 1411, 3624, 8140, 8141.

## New Forever race/class trainers found

(Town names in brackets are AFGELEID: the new NPC stands next to the old trainers of that town.)

- Undead Paladin: 244808 (Deathknell), 246152 (Brill), 246389 (Tirisfal 22/47), 260093 (Undercity); also 246344 Alodan the
  Hopeful, Paladin Trainer in Thunder Bluff.
- Dwarf Shaman: 257446 (Coldridge), 258113 (Kharanos), 258098 (Ironforge).
- Human Hunter: 248415 (Northshire), 251507 (Goldshire), pet trainer 258930 (Goldshire).
- 258785 High Priestess Mims, a new Priest Trainer in Ironforge (that she is for the new Gnome combo is AFGELEID).
- Orc and Troll new combos (wiki marks one each): no new trainer NPC found in Durotar/Orgrimmar; the existing ones there
  cover it (AFGELEID). I could not read from the wiki table which class each of the six new combos is.

## Notes on the fetch

- Wowhead showed a "Human Verification" CAPTCHA page (HTTP 405) twice after fast bursts. I did not solve it; I waited
  and then fetched 1 page per 14 s. No block after that.
- Working files (scratchpad): `roster.tsv`, `wowhead_mapper.tsv` (raw g_mapperData per NPC), `zygor_class.json`,
  `wago\UiMap.csv`, `wago\UiMapAssignment_wowf.csv`, `wago\UiMapAssignment_era.csv`, `scripts\build.py`.
