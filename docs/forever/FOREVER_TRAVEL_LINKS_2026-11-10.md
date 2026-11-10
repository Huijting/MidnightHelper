# WoW Forever: transport links (boats, zeppelins, tram, portals, skycutters)

Research for the MH route-arrow travel planner. Written 10 Nov 2026. Client: Forever 1.60.1, DB2 build **1.60.1.70888**
(wago.tools product `wowf`, build list timestamp 2026-11-10 15:10).

Labels: **GEMETEN** = seen in the named source on the named date. **AFGELEID** = reasoned or computed from measured data.

## How the coordinates were made

Three independent sources, and they agree within about 1 map unit for every link end:

1. **DB2 `TaxiPathNode`** (Forever 70888). Boats, zeppelins and skycutters run on TaxiPaths. Every node with `Flags=2,
   Delay>0` is a stop. That gives the **boat's centre while docked** in world coordinates. GEMETEN.
   Query: `run gamedata db2 TaxiPathNode Delay!=0 --game forever --limit 0`, which returned 29 rows across 14 paths.
   That is the full list of stopping paths in this build.
2. **Conversion to zone-map x,y** with Forever `UiMapAssignment` (`run gamedata db2 UiMapAssignment UiMapID=... --game forever`).
   The formula is `x = (maxY - worldY)/(maxY - minY)*100` and `y = (maxX - worldX)/(maxX - minX)*100`. AFGELEID.
   I checked it against Wowhead Forever NPC spawns:
   - TaxiNode 26 Auberdine gives 36.4,45.6. Caylais Moonfeather (3841) stands at 36.4,45.4/45.6.
   - TaxiNode 27 Rut'theran gives 58.4,93.9. Vesprystus (3838) stands at 58.4,94.
   - All 6 zeppelin masters are within 0.7 of their computed zeppelin stop.
   Script: `C:\Users\RobHu\AppData\Local\Temp\claude\e1c44003d48d72c2\45f8f015-eb58-4e9a-bfdc-686d6fb09ce4\scratchpad\conv.py`.
3. **Zygor Guides Viewer (Forever) 1.6**, local install with files dated 5 Nov 2026:
   `_forever_\Interface\AddOns\ZygorGuidesViewerForever\Libs-Forever\LibRover-1.0\data_transit.lua`. Its coordinates are
   **boarding spots** on the dock or tower. GEMETEN (in Zygor). Zygor is All Rights Reserved, so use it as a cross-check
   only. For MH data, prefer the DB2-derived values or Rob's own measurements.

Coordinate columns: **board** = Zygor boarding spot. **DB2** = docked-vehicle position converted to the same map.
NPC coordinates come from `run gamedata npc <id> --game forever` (nether.wowhead.com/forever tooltips, 10 Nov 2026), GEMETEN.

Guides consulted, all dated after 18 Aug 2026 and all written before launch on beta data:
- method.gg, 14 Oct 2026: https://www.method.gg/wow-forever/all-travel-routes-in-wow-forever-boats-zeppelins
- conquestcapped, 20 Oct 2026: https://conquestcapped.com/guides/wow-forever/wow-forever-travel-routes/
- leprestore, 26 Oct 2026: https://leprestore.com/guides/world-of-warcraft-forever/wow-forever-travel-guide/

## UiMap ids (question 2 and 3)

All ids in the brief exist in Forever `UiMap`, GEMETEN with `run gamedata db2 UiMap Type!=999 --game forever`
(60 rows, the full table):

| uiMapId | Name | Parent | Type |
|---|---|---|---|
| 947 | Azeroth | 0 | 1 world |
| **1414** | **Kalimdor** | 947 | 2 continent |
| **1415** | **Eastern Kingdoms** | 947 | 2 continent |
| 1463 / 1464 | Eastern Kingdoms / Kalimdor (second copies) | 0 | 2 continent (use unknown, see open questions) |
| 1411 Durotar, 1412 Mulgore, 1413 Barrens, 1438 Teldrassil, 1439 Darkshore, 1444 Feralas, 1445 Dustwallow, 1446 Tanaris, 1454 Orgrimmar, 1456 Thunder Bluff, 1457 Darnassus, 2482 Mount Hyjal, 2652 Shen'dralas | | 1414 | 3 zone |
| 1416 Alterac, 1420 Tirisfal, 1421 Silverpine, 1424 Hillsbrad, 1426 Dun Morogh, 1429 Elwynn, 1434 STV, 1437 Wetlands, 1453 Stormwind City, 1455 Ironforge, 1458 Undercity, 2548 Riverglades | | 1415 | 3 zone |
| 2521 | Zephras Isle | **947** (no continent) | 3 zone, instance map 2991 |
| 2665 | Zephras Isle (copy) | 0 | 3 |
| 2524 | Darkspear Islands | 1414 | 6 orphan. Its Map 2997 has InstanceType 3, which is a battleground, not a travel link |

- **Teldrassil and Rut'theran belong to Kalimdor.** GEMETEN in the DB2: UiMap 1438 has parent 1414, and its
  UiMapAssignment uses MapID 1, the same instance map as Darkshore. Darnassus 1457 also has parent 1414 directly.
  Rut'theran is a subzone of the Teldrassil map: Vesprystus's zone is AreaTable 141, Teldrassil. The Auberdine to
  Rut'theran boat stops have ContinentID 1 at both ends, so the trip has no loading screen (AFGELEID).
  `C_Map.GetMapInfo(1438).parentMapID` was **not run in the client**.
- **Zephras Isle has no continent parent.** Its parent is Azeroth 947 and its map is 2991, so a planner must treat it as
  its own continent. GEMETEN (DB2).
- **Deeprun Tram (Map 369) has no UiMap row.** GEMETEN: absent from the full 60-row list.
- **Dalaran has no UiMap row** (also absent from the full list). Its Maps 2959/2980 exist. Zygor puts the Dalaran dock on Alterac Mountains 1416.
- **Stormwind City's map changed from Classic.** GEMETEN by comparing UiMapAssignment 1453:
  - Classic Era 1.15.9: X -9175.2..-8278.9, Y 36.7..1381.0.
  - Forever: X -9154.2..-7995.8, Y -14.6..1722.9. This is the larger map that includes the harbour.

  Classic Stormwind coordinates are therefore **wrong in Forever**. Example: Zygor's own transit line puts the tram at
  "Stormwind City 60.36,12.47". That is the Classic-map spot of AreaTrigger 2173. On the Forever map the same
  trigger sits at 69.6,30.3, and Zygor's Forever guide steps use 69.31,30.56. AFGELEID.

## Link table (one row per link end; "from" = where you board)

| Link end | Faction | Type | From uiMap x,y | To uiMap x,y | NPC / evidence | Status | Source |
|---|---|---|---|---|---|---|---|
| **A1-SW** Stormwind Harbour > Auberdine | Alliance | boat, new in Forever, crosses continents (0>1) | 1453 board 22.60,56.13 (DB2 21.8,56.9; Elwynn 1429 5.5,30.9; EK 1415 41.6,68.7) | 1439 board 30.76,41.00 (DB2 30.5,40.9) | Path 11616, stop idx18. Stormwind Harbor = AreaTable 17203, parent 1519 (Stormwind City). Manifest Clerk Philmor 268511 stands in the harbour, Stormwind City 30.4,29.0. Path 11616 is absent in Classic Era 1.15.9 | GEMETEN (DB2, Zygor, 3 guides). x,y conversion AFGELEID | `db2 TaxiPathNode PathID=11616`; data_transit.lua l.58; `npc 268511` |
| **A1-AU** Auberdine > Stormwind Harbour | Alliance | boat | 1439 board 30.76,41.00 (DB2 30.5,40.9) | 1453 board 22.60,56.13 | Path 11616, stop idx6. Rob saw this boat ("Elwynn Forest / Stormwind harbour") at Auberdine, 10 Nov | GEMETEN (Rob in game, DB2, Zygor) | as above |
| **A2-AU** Auberdine > Rut'theran | Alliance | boat, Classic, same continent (1>1) | 1439 board 33.19,40.13 (DB2 33.3,39.8) | 1438 board 54.86,96.79 (DB2 54.8,97.2) | Path 293. Caylais Moonfeather 3841 (hippogryph master), Darkshore 36.4,45.4. Rob saw this boat, 10 Nov | GEMETEN | `db2 TaxiPathNode PathID=293`; data_transit.lua l.63; `npc 3841` |
| **A2-RT** Rut'theran > Auberdine | Alliance | boat | 1438 board 54.86,96.79 (DB2 54.8,97.2) | 1439 board 33.19,40.13 | Vesprystus 3838, Teldrassil 58.4,94. The Rut'theran stop moved slightly from Classic (8533.7,1025.1) to Forever (8532.0,1023.7) | GEMETEN | `npc 3838`; Classic comparison `--build 1.15.9.70576` |
| **A3a** Auberdine > Menethil (loop leg 1) | Alliance | boat, **one-way loop**, new, crosses continents (1>0) | 1439 board 32.39,43.80 (DB2 32.3,44.1) | 1437 board 4.65,57.16 (DB2 4.5,56.7). Right after the loading screen the ship appears at Wetlands 1.58,40.32 | Path 11167: Menethil stop idx7, Southshore idx20, Auberdine idx34. Node order is Menethil > Southshore > Auberdine > back to Menethil. Rob saw "boat to Wetlands" at Auberdine | GEMETEN (DB2 node order, Zygor one-way legs, conquestcapped and method.gg describe the same loop). Leprestore calls the order "not confirmed" | `db2 TaxiPathNode PathID=11167`; data_transit.lua l.73-74 |
| **A3b** Menethil > Southshore (loop leg 2) | Alliance | boat, one-way, EK only (0>0) | 1437 board 4.65,57.19 (DB2 4.5,56.7) | 1424 board 50.60,69.71 (DB2 50.7,70.4) | Shellei Brondir 1571 (Menethil gryphon master), Wetlands 9.4,59.4. Darla Harris 2432 (Southshore gryphon master), Hillsbrad 49.4,52.2. The Southshore dock was unused in Classic | GEMETEN (DB2, Zygor, conquestcapped) | data_transit.lua l.78; `npc 1571 2432` |
| **A3c** Southshore > Auberdine (loop leg 3) | Alliance | boat, one-way, crosses continents (0>1) | 1424 board 50.60,69.71 (DB2 50.7,70.4) | 1439 board 32.39,43.80 | The loop has **no direct Menethil > Auberdine leg**. From Menethil you stay on board through Southshore | GEMETEN (path) / AFGELEID (planner consequence) | data_transit.lua l.83 |
| **A4-ME** Menethil > Theramore | Alliance | boat, Classic, crosses continents (0>1) | 1437 board 5.08,63.40 (DB2 4.7,63.8). This is a different pier from A3 | 1445 board 71.54,56.34 (DB2 71.7,56.7) | Path 292 | GEMETEN | `db2 TaxiPathNode PathID=292`; data_transit.lua l.68 |
| **A4-TH** Theramore > Menethil | Alliance | boat | 1445 board 71.54,56.34 | 1437 board 5.08,63.40 | Baldruc 4321 (Theramore gryphon master), Dustwallow 67.4,51.2 | GEMETEN | `npc 4321` |
| **A5-RT** Rut'theran > Darnassus | Alliance | pink portal (walk in), Classic | 1438 board 55.91,89.64 (AreaTrigger 542: 55.9,89.3, r=10) | 1457. The exact landing spot is not measured | Zygor: "Enter the pink portal to Darnassus" | GEMETEN (Zygor, trigger position in DB2). Calling AT 542 "the portal" is AFGELEID | data_transit.lua l.20; `db2 AreaTrigger ContinentID=1` |
| **A5-DA** Darnassus > Rut'theran | Alliance | pink portal, Classic | 1457 board 30.06,41.44 (AreaTrigger 527: 29.1,41.2, r=10) | 1438 (Rut'theran) | Zygor: "Enter the pink portal to Rut'theran Village". **The pink-portal claim in our existing text checks out** | GEMETEN (Zygor) | data_transit.lua l.20 |
| **A6-SW** Stormwind > Ironforge | Alliance | Deeprun Tram, Classic, instance Map 369 | 1453 board 69.31,30.56 (AreaTrigger 2173: 69.6,30.3) | 1455 76.58,51.14 | Inside the tram there is no UiMap (see above). The tram uses Map 369, not a TaxiPath | GEMETEN (Zygor guide, AT position). Exit-trigger pairing AFGELEID | ZygorLevelingAllianceCLASSIC.lua l.1216 / l.2791; `db2 AreaTrigger ContinentID=0,369` |
| **A6-IF** Ironforge > Stormwind | Alliance | Deeprun Tram | 1455 board 76.58,51.14 (AreaTrigger 2175: 78.0,51.4) | 1453 69.31,30.56 | Do not use data_transit.lua l.95 "Stormwind City/0 60.36,12.47": it is in Classic-map coordinates | GEMETEN / AFGELEID | as above |
| **A7-FM** Feathermoon Stronghold > Forgotten Coast | Alliance | ferry, Classic, same continent | 1444 DB2 31.0,39.5 (no Zygor transit line) | 1444 DB2 43.1,42.8. Zygor guide: "Ride the boat or swim" at Feralas 43.39,42.75 | Path 303. Stop delay is 30 at Feathermoon and 60 at the coast | GEMETEN (DB2), x,y AFGELEID | `db2 TaxiPathNode PathID=303`; ZygorLevelingAllianceCLASSIC.lua l.10045 |
| **H1-OG** Orgrimmar (Durotar tower) > Undercity | Horde | zeppelin, Classic, crosses continents (1>0) | 1411 board 50.82,13.81 (DB2 51.0,13.9) | 1420 board 60.70,58.76 (DB2 60.6,58.9) | Frezza 9564, Zeppelin Master, Durotar 50.8,13.4/13.6. Path 302. The tower is outside Orgrimmar (1454), in Durotar | GEMETEN (NPC, DB2, Zygor). NPC-to-route pairing AFGELEID (nearest stop) | `npc 9564`; data_transit.lua l.108 |
| **H1-UC** Undercity (Tirisfal tower) > Orgrimmar | Horde | zeppelin | 1420 board 60.70,58.76 | 1411 board 50.82,13.81 | Zapetta 9566, Zeppelin Master, Tirisfal 60.8,58.8. The tower is outside Undercity (1458), in Tirisfal | GEMETEN / pairing AFGELEID | `npc 9566` |
| **H2-OG** Orgrimmar > Grom'gol | Horde | zeppelin, Classic, crosses continents | 1411 board 50.57,12.66 (DB2 50.5,12.7) | 1434 board 31.35,30.12 (DB2 31.2,30.4) | Snurk Bucksquick 12136, Durotar 50.6,12.8. Path 285 | GEMETEN / pairing AFGELEID | `npc 12136`; data_transit.lua l.114 |
| **H2-GG** Grom'gol > Orgrimmar | Horde | zeppelin | 1434 board 31.35,30.12 | 1411 board 50.57,12.66 | Nez'raz 3149, STV 31.4,29.8 | GEMETEN / pairing AFGELEID | `npc 3149` |
| **H3-UC** Undercity > Grom'gol | Horde | zeppelin, Classic, EK only (0>0) | 1420 board 61.88,59.10 (DB2 61.9,58.9) | 1434 board 31.53,29.15 (DB2 31.5,29.1) | Hin Denburg 3150, Tirisfal 61.8,59.0. Path 301 | GEMETEN / pairing AFGELEID | `npc 3150`; data_transit.lua l.111 |
| **H3-GG** Grom'gol > Undercity | Horde | zeppelin | 1434 board 31.53,29.15 | 1420 board 61.88,59.10 | Squibby Overspeck 12137, STV 31.4/31.6,29.4 | GEMETEN / pairing AFGELEID | `npc 12137` |
| **N1-RA** Ratchet > Booty Bay | Neutral | boat, Classic, crosses continents (1>0) | 1413 board 63.66,38.65 (DB2 63.8,38.8) | 1434 board 25.92,73.15 (DB2 25.7,73.1) | Bragok 16227 (flight master), Barrens 63.0,37.2. Path 241 | GEMETEN | `npc 16227`; data_transit.lua l.125 |
| **N1-BB** Booty Bay > Ratchet | Neutral | boat | 1434 board 25.92,73.15 | 1413 board 63.66,38.65 | Gyll 2859 (Alliance), STV 27.4,77.8. Gringer 2858 (Horde), STV 26.8,77.0 | GEMETEN | `npc 2858 2859` |
| **N2-TA** Steamwheedle Port (Tanaris) > Powderfuse Port (Riverglades) | Neutral | goblin boat, **new in Forever**, crosses continents (1>0) | 1446 board 68.34,22.98 (DB2 68.6,23.0) | 2548 board 80.30,54.40 (DB2 80.6,54.6) | Path 11391 (not in Classic Era). TaxiNodes 3274/3275 "Powderfuse Port, Riverglades". No dock NPC found | GEMETEN (DB2, Zygor, 3 guides) | `db2 TaxiPathNode PathID=11391`; data_transit.lua l.128 |
| **N2-RG** Powderfuse Port > Steamwheedle Port | Neutral | goblin boat | 2548 board 80.30,54.40 | 1446 board 68.34,22.98 | | GEMETEN | as above |
| **S1-ZI** Zephras Isle (Valanaar) > Dalaran | Alliance per Zygor (High Order). conquestcapped says both factions can ride | skycutter, new, maps 2991>0 | 2521 board 65.82,83.42 (DB2 65.8,83.8) | 1416 board 12.52,51.96 (DB2 12.8,51.2; the bounds overlap Silverpine 1421 at 72.0,40.1) | **High Order Dockmaster 275269**, Zephras Isle 65.6,83.2. Path 11398. Map 3217 "Dalaran Skycuter" | GEMETEN | `npc 275269`; data_transit.lua l.100; warcraft.wiki.gg/wiki/High_Order_Dockmaster (edited 15 Oct 2026) |
| **S1-DA** Dalaran > Zephras Isle | as S1-ZI | skycutter | 1416 board 12.52,51.96 | 2521 board 65.82,83.42 | | GEMETEN | as above |
| **S2-ZI** Zephras Isle > Mulgore (Skywatcher Plateau) | Horde per Zygor (Windshapers). Both factions can ride per conquestcapped | skycutter, new, maps 2991>1 | 2521 board 57.94,80.72 (DB2 57.7,81.0) | 1412 board 34.29,25.73 (DB2 34.3,26.1; outside the Thunder Bluff 1456 bounds) | Path 11457. Map 3218 "Mulgore Skycuter". Leprestore names Ayessa Dawnsinger at Zephras 59.1,79.8 as a quest hand-off | GEMETEN (DB2, Zygor, guides) | `db2 TaxiPathNode PathID=11457`; data_transit.lua l.117 |
| **S2-MU** Mulgore > Zephras Isle | as S2-ZI | skycutter | 1412 board 34.29,25.73 | 2521 board 57.94,80.72 | | GEMETEN | as above |
| S3 Dalaran <> Stormwind | **Skyborne race only** | portal | 1416 12.04,56.21 > 1453 49.87,86.67; and 1453 50.04,86.97 > 1416 12.12,56.55 | | Zygor condition `RaceClassMatch('SKYBORNE')`. Conquestcapped: "unconfirmed until launch" | GEMETEN (Zygor) | data_transit.lua l.30-37 |
| X1 Auberdine <> Menethil, direct (Classic path 295) | Alliance | boat | 1439 DB2 32.3,44.1 | 1437 DB2 4.5,56.7 | Path 295 is **still in Forever DB2**, at the same piers as the loop. Zygor and all 3 guides know only the loop. The Classic Era 1.15.9 build has 295 and not 11167 | DB2 row GEMETEN. "Not running in Forever" is AFGELEID | `db2 TaxiPathNode Delay!=0` (Forever and `--build 1.15.9.70576`) |

## Forever compared with Classic (2004 / Classic Era 1.15.9)

GEMETEN by comparing the DB2 stop lists. Forever 70888 has 14 stopping paths. Classic Era 1.15.9.70576 has 9, all of which
are also in Forever: 241, 285, 292, 293, 295, 301, 302, 303, 436. Path 436 is Naxxramas, not a travel link.

- **New in Forever:**
  - 11616 Stormwind Harbour <> Auberdine
  - 11167 Menethil > Southshore > Auberdine loop
  - 11391 Steamwheedle Port <> Powderfuse Port
  - 11398 Zephras Isle <> Dalaran skycutter
  - 11457 Zephras Isle <> Mulgore skycutter
  - Stormwind Harbor itself (AreaTable 17203)
  - The larger Stormwind City map
- **Probably gone in Forever:** the direct Auberdine <> Menethil boat (X1). AFGELEID: its DB2 row is still present.
- **Unchanged:** the three Horde zeppelins, Ratchet <> Booty Bay, Auberdine <> Rut'theran, Menethil <> Theramore,
  the Feathermoon ferry, the Deeprun Tram, and the Rut'theran <> Darnassus portal.
- **Not a travel link:** Thunder Bluff has no zeppelin, in Forever (DB2 and guides) or in Classic.
- **Stop delays:** DB2 `Delay`=60 at almost every stop, likely seconds (AFGELEID unit). The exceptions are 30 at
  Feathermoon and 30 at the Zephras stop of path 11457.
- **Transport object names on Wowhead Forever** (`run gamedata object ... --game forever`), GEMETEN:
  - 176310 "Serenity's Shore"
  - 176244 "Moonspray"
  - 176231 "Proudmoore's Treasure"
  - 20808 "TEST Ship"
  - 164871 "Zeppelin - Orgrimmar to Undercity"
  - 175080 "Zeppelin - Grom'Gol-Orgrimar"
  - 176495 "Zeppelin - Grom'Gol to Undercity"

  Which ship object runs which path is not verified.

## Open questions

1. Is Classic path 295 (direct Auberdine <> Menethil) still running next to the loop? Rob can check at **Menethil**: is
   there a ship that goes straight to Auberdine, or only the one via Southshore?
2. Which map does the client report at the Stormwind Harbour pier? Expected 1453 (AFGELEID from AreaTable 17203,
   parent 1519). Check with `/dump C_Map.GetBestMapForUnit("player")` at Stormwind City 22.6,56.1.
3. Which map does the client report at the Dalaran skycutter dock? Zygor says Alterac 1416, but the bounds overlap
   Silverpine 1421.
4. What does `C_Map.GetBestMapForUnit` return inside the Deeprun Tram (Map 369, no UiMap)? The planner must handle nil.
5. Confirm `C_Map.GetMapInfo(1438).parentMapID == 1414` in the client. So far this is DB2 only.
6. What are UiMaps 1463 and 1464 (second EK and Kalimdor rows, parent 0) used for? They have different bounds from
   1414/1415. Use 1414/1415 as the continents.
7. Do the Alliance docks have named dock NPCs? method.gg mentions guards that tell you where a transport goes, but no
   names or ids were found. The only one found is High Order Dockmaster 275269 on Zephras Isle.
8. Can non-Skyborne players of both factions board the skycutters, and at what level? Conquestcapped says both factions
   can, but that is beta-era. Is the Skyborne-only portal live?
9. Are the Powderfuse Port flight nodes live? Leprestore says they were hidden in a late-October beta.
10. AreaTrigger 3546 in Darnassus (41.3,43.1, r=12): its role is unknown. It is not the Rut'theran portal (that is AT 527).
11. The zeppelin-master-to-route pairing is AFGELEID: nearest NPC to each computed stop. No source states it outright.
