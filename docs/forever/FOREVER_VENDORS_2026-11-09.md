# Forever vendors: profession tools + General Goods / Trade Supplies (9 Nov 2026)

WoW: Forever, client 1.60.1, build 70862. Research by mh-research (read-only); saved here by the build chat because the
helper may not write .md files. Rows: `Modules/ForeverVendorSpots.lua`. Rob, 9 Nov 2026: learned Fishing and could not
find where to buy a Fishing Pole → "die moeten we ook vindbaar maken" → "Yeah, je mag zo beginnen".

## Sources
- Who sells an item: Wowhead Forever item page, `sold-by` listview (`https://www.wowhead.com/forever/item=<id>`), read
  2026-11-09 ~19:20 and again 19:42 (same counts).
- Where an NPC stands: Wowhead Forever NPC page, `g_mapperData`, read 19:39–21:12.
- Classic frame and old seller lists: Wowhead Classic pages, 20:48–21:16.
- Cross-check only (licence): Zygor `Data-Forever\NPCData.lua` (file date 6 Nov 2026).

## Method (same as ForeverProfTrainerSpots.lua)
1. Sellers from the sold-by lists of 6256, 6365, 2901, 7005, 5956, 4471, 5060. Goods seeds 4470 Simple Wood, 6217 Copper
   Rod, 4496 Small Brown Pouch: every General/Trade seller found that way also sells a tool (0 goods-only; GEMETEN).
2. Point = medoid of the g_mapperData entry with the most points (single-linkage clusters at 2.0 map units).
3. Two or more clusters: the cluster with a Classic Era point is dropped. Positive control: reproduces trainer rows 5493
   (55.00, 69.40), 812 (16.20, 45.60) and 6290 (45.00, 61.40) exactly (GEMETEN).
4. Side from Wowhead react [Alliance, Horde]: 1 or 0 = usable (0 = "neutral counted usable", AFGELEID).
5. Zygor compared by npc id on the same uiMap, within 1.5 units = agrees.

## Counts (GEMETEN)
- 306 distinct sellers of the 7 tools; 3 skipped (Reagent Bot 242498, Repair Bot 254695, duplicate 216672) → 303 rows
  (1 commented out: 235164), 290 with a point, 12 without.
- 20 rows where the Classic frame was dropped (Stormwind 11, Redridge 6, Mulgore 3).
- 118 goods rows (62 general, 56 trade). Every capital, every classic starting zone and Zephras Isle has at least one of
  each.
- Zygor: 272 agree, 15 differ, 10 other map / no point, 6 not in Zygor.
- Per item: Fishing Pole 77 (75 with point; A 48 / H 44), Strong Fishing Pole 25 (all `stock = 1`), Mining Pick 139,
  Skinning Knife 95, Blacksmith Hammer 102, Flint and Tinder 87, Thieves' Tools 22.

## No Forever vendor (GEMETEN: page 200, no sold-by list; same parser found the 7 tools' sellers in the same batch)
Rock Chipper 6206, Vindael's Spectral Pickaxe 259229, Keen Skinning Knife 269716, crafted hammers 285280/285281, Gnomish
Army Knife 260811, Arclight Spanner 6219 (no seller in Classic Era either), Gyromatic Micro-Adjustor 10498, Philosopher's
Stone 9149, Alchemist's Stone 13503, runed rods 6218/6339/11130/11145/16207, Big Iron Fishing Pole 6367, Blump Family
Fishing Pole 12225, Nat Pagle's Extreme Angler FC-5000 19022, Arcanite Fishing Pole 19970; Darkwood Fishing Pole 6366 = 404.

## New in Forever vs Classic Era (GEMETEN, sold-by lists compared; no Classic seller lost)
- Fishing Pole +10 (Zephras Isle 4, Alterac Mountains 1, Riverglades 3, two engineer bots); Strong Fishing Pole +3.
- Mining Pick +31 and Skinning Knife +27: starting-area General Supplies vendors and the capital General Goods vendors now
  sell them, plus the new Junior Mining / Skinning Trainers and new-zone vendors.
- Blacksmith Hammer +16, Flint and Tinder +33 (cooks, chefs, innkeepers), Thieves' Tools +2.
- Wowhead labels: 54 "new", 6 "faction_changed" (5411, 8139, 9179, 9544, 12941, 14624), 1 "renamed" (6777).

## Open items
1. Redridge frame: Wowhead's Forever points lie ~5.2 west of Classic for the 7 Lakeshire NPCs; Zygor has the Classic
   numbers. Rows use Wowhead. One `/way` check at Amy Davenport (777) settles it.
2. Eastern Plaguelands (`unsure = true`: 11038, 12941, 16376): only Classic-frame points on Wowhead, Zygor shifted
   ~(-10,-10). The arrow skips these until checked in game.
3. Felika 3367 walks a route (37 points, spread 18.3): row = medoid on her path (60.40, 52.00).
4. G00 DV-1B3 Generator 235164: 7 spawn spots, row commented out.
5. "0 moved" only covers NPCs Wowhead has Forever data for.
6. `map = nil` (12 rows): 10 Alterac Valley vendors, Tink Sprocketwhistle 9676 (Gnomeregan), Field Repair Bot 74A 14337.
7. `side = nil` (4 rows): Gorn One Eye 11555 (react [-1,-1]), 256629, 244512, 270780.
8. Goods coverage depends on the seed items (AFGELEID that none is missing).


---

# Full tables

| item | id | rows | with point | Alliance | Horde |
|---|---|---|---|---|---|
| Fishing Pole | 6256 | 77 | 75 | 48 | 44 |
| Strong Fishing Pole | 6365 | 25 | 25 | 16 | 14 |
| Mining Pick | 2901 | 139 | 133 | 91 | 84 |
| Skinning Knife | 7005 | 95 | 93 | 59 | 56 |
| Blacksmith Hammer | 5956 | 102 | 96 | 66 | 62 |
| Flint and Tinder | 4471 | 87 | 85 | 54 | 45 |
| Thieves' Tools | 5060 | 22 | 18 | 14 | 9 |

| zone | side | vendor (npc) | x, y | sells | tag |
|---|---|---|---|---|---|
| Alterac Mountains | A | Jack Findle (252020) | 13.20, 71.40 | 6256 | Trade Supplies |
| Arathi Highlands | A | Hammon Karwn (2810) | 46.40, 47.40 | 6256 | Superior Tradesman |
| Arathi Highlands | H | Keena (2821) | 74.00, 32.40 | 6256 | Trade Goods |
| Ashenvale | A | Dalria (3954) | 35.00, 52.00 | 6256 | Trade Goods |
| Ashenvale | A | Shandrina (3955) | 49.40, 67.00 | 6256 | Trade Goods |
| Ashenvale | H | Wik'Tar (12962) | 11.80, 34.00 | 6256+6365 | Fish Merchant & Supplies |
| Azshara | both | Blimo Gadgetspring (12957) | 45.20, 90.80 | 6256 | Trade Supplier |
| Darkshore | A | Gorbold Steelhand (6301) | 38.00, 41.20 | 6256 | General Trade Supplier |
| Darkshore | A | Gubber Blump (10216) | 36.00, 44.80 | 6256 |  |
| Darkshore | A | Ullanna (4194) | 43.80, 76.40 | 6256 | Trade Supplies |
| Darnassus | A | Mythrin'dir (4229) | 61.00, 18.00 | 6256 | General Trade Supplier |
| Darnassus | A | Voloren (4222) | 47.00, 56.40 | 6256+6365 | Fishing Supplier |
| Desolace | H | Kireena (9636) | 51.00, 53.40 | 6256 | Trade Goods |
| Desolace | H | Lah'Mawhani (12028) | 23.00, 71.60 | 6256 | Trade Supplies |
| Desolace | H | Mai'Lahii (12031) | 22.60, 72.00 | 6256+6365 | Fishing Supplies |
| Desolace | both | Vendor-Tron 1000 (12245) | 60.20, 38.20 | 6256 |  |
| Dun Morogh | A | Golorn Frostbeard (1692) | 46.60, 53.40 | 6256 | Tradesman |
| Dun Morogh | A | Gretta Ganter (8508) | 31.60, 44.60 | 6256+6365 | Fisherman Supplies |
| Durotar | H | Flakk (3168) | 52.80, 42.00 | 6256 | Trade Supplies |
| Durotar | H | Tai'tasi (3187) | 56.40, 73.80 | 6256 | Trade Supplies |
| Durotar | H | Zansoa (5942) | 56.00, 73.40 | 6256+6365 | Fishing Supplies |
| Dustwallow Marsh | A | Helenia Olden (4897) | 66.40, 51.40 | 6256 | Trade Supplies |
| Eastern Plaguelands | both | Jase Farlane (12941) | 80.40, 57.60 | 6256 | Trade Supplies |
| Elwynn Forest | A | Drake Lindgren (1250) | 83.00, 66.40 | 6256 | General & Trade Supplies |
| Elwynn Forest | A | Tharynn Bouden (66) | 41.80, 67.00 | 6256 | Trade Supplies |
| Feralas | A | Savanne (7945) | 31.00, 46.00 | 6256+6365 | Fishing Supplies |
| Feralas | A | Vivianna (7947) | 31.20, 43.40 | 6256 | Trade Supplies |
| Feralas | H | Sheendra Tallgrass (8145) | 74.40, 42.80 | 6256 | Trade Supplies |
| Hillsbrad Foothills | A | Lindea Rabonne (2383) | 50.40, 61.00 | 6256+6365 | Tackle and Bait |
| Ironforge | A | Tansy Puddlefizz (5162) | 47.80, 6.60 | 6256+6365 | Fishing Supplier |
| Loch Modan | A | Drac Roughcut (1465) | 35.40, 48.80 | 6256 | Tradesman |
| Loch Modan | A | Khara Deepwater (1684) | 39.40, 39.20 | 6256+6365 | Fishing Supplies |
| Moonglade | both | Lorelae Wintersong (12022) | 48.60, 40.20 | 6256 | Trade Supplies |
| Mulgore | H | Harn Longcast (5940) | 46.60, 59.20 | 6256+6365 | Fishing Supplies |
| Mulgore | H | Wunna Darkmane (3081) | 45.40, 61.80 | 6256 | Trade Goods |
| Orgrimmar | H | Felika (3367) | 60.40, 52.00 | 6256 | General Trade Goods Merchant |
| Orgrimmar | H | Shankys (3333) | 69.80, 29.60 | 6256+6365 | Fishing Supplies |
| Orgrimmar | H | Shimra (5817) | 48.00, 80.20 | 6256 | General Trade Goods Merchant |
| Redridge Mountains | A | Amy Davenport (777) | 23.80, 47.60 | 6256 | Tradeswoman |
| Redridge Mountains | A | Vernon Hale (1678) | 22.20, 47.60 | 6256+6365 | Bait and Tackle Supplier |
| Riverglades | A | Kenneth \"Kirby\" Millstead (270545) | 65.40, 90.00 | 6256+6365 |  |
| Riverglades | both | Gilliwigs (260559) | 79.20, 54.60 | 6256 | Trade Goods |
| Riverglades | both | Gritta Chumwater (260487) | 78.40, 55.00 | 6256+6365 | Fisherman |
| Silithus | both | Mishta (15179) | 49.80, 36.40 | 6256 | General Trade Goods Vendor |
| Silverpine Forest | H | Andrew Hilbert (3556) | 43.20, 40.60 | 6256 | Trade Goods |
| Stonetalon Mountains | H | Kulwia (12043) | 45.40, 59.40 | 6256 | Trade Supplies |
| Stormwind City | A | Catherine Leland (5494) | 55.00, 69.40 | 6256+6365 | Fishing Supplier |
| Stormwind City | A | Edna Mullby (1286) | 64.60, 71.40 | 6256 | Trade Supplier |
| Stranglethorn Vale | H | Nerrist (1148) | 32.60, 29.20 | 6256 | Trade Goods |
| Stranglethorn Vale | both | Old Man Heming (2626) | 27.40, 77.00 | 6256+6365 | Fisherman |
| Swamp of Sorrows | H | Banalash (989) | 44.40, 57.00 | 6256 | Trade Goods |
| Teldrassil | A | Narret Shadowgrove (3614) | 55.20, 57.00 | 6256 | Trade Supplies |
| Teldrassil | A | Nessa Shadowsong (10118) | 56.20, 92.40 | 6256+6365 | Fishing Supplies |
| The Barrens | H | Tari'qa (3482) | 51.60, 30.00 | 6256 | Trade Supplies |
| The Barrens | both | Kilxx (3497) | 62.80, 38.20 | 6256+6365 | Fisherman |
| The Barrens | both | Ranik (3499) | 61.80, 38.60 | 6256 | Trade Supplies |
| The Barrens | both | Zizzek (3572) | 62.00, 39.00 | 6256+6365 | Fisherman |
| The Hinterlands | H | Katoom the Angler (14740) | 80.40, 81.60 | 6256+6365 | Fishing Trainer & Supplies |
| The Hinterlands | both | Gigget Zipcoil (12958) | 34.40, 38.40 | 6256 | Trade Supplies |
| Thunder Bluff | H | Sewa Mistrunner (3029) | 55.60, 47.60 | 6256+6365 | Fishing Supplier |
| Thunder Bluff | H | Shadi Mistrunner (8363) | 40.40, 63.40 | 6256 | Trade Goods Supplier |
| Tirisfal Glades | H | Abigail Shiel (2118) | 61.00, 52.40 | 6256 | Trade Supplies |
| Tirisfal Glades | H | Martine Tramblay (3550) | 65.80, 59.40 | 6256+6365 | Fishing Supplies |
| Undercity | H | Daniel Bartlett (4561) | 64.20, 37.80 | 6256 | General Trade Supplier |
| Undercity | H | Felicia Doan (4775) | 64.80, 49.60 | 6256 | General Trade Goods Vendor |
| Undercity | H | Lizbeth Cromwell (4574) | 81.20, 30.80 | 6256+6365 | Fishing Supplier |
| Westfall | A | Christopher Hewen (8934) | 52.20, 52.80 | 6256 | General Trade Goods Vendor |
| Westfall | A | Gina MacGregor (843) | 57.40, 54.00 | 6256 | Trade Supplies |
| Wetlands | A | Stuart Fleming (3178) | 8.00, 58.20 | 6256+6365 | Fisherman |
| Winterspring | A | Syurana (3779) | 51.40, 29.80 | 6256 | Trade Goods Supplies |
| Winterspring | both | Qia (11189) | 61.20, 37.20 | 6256 | Trade Goods Supplies |
| Zephras Isle | both | Baelann Swiftcurrent (257008) | 63.20, 75.40 | 6256+6365 | Fisher |
| Zephras Isle | both | Belandiel Farflight (254360) | 44.80, 45.00 | 6256 | Trade Supplies |
| Zephras Isle | both | Fenn Fairweather (251992) | 45.00, 48.40 | 6256 | Fisherman |
| Zephras Isle | both | Iallion Featherfall (252449) | 58.80, 75.40 | 6256 | Trade Supplies |
| loc 2597 | A | Svalbrad Farmountain (5135) | nil, nil | 6256 | Trade Goods |
| loc 2597 | H | Zora Guthrek (2225) | nil, nil | 6256 | Trade Goods |

| zone (uiMap) | general | trade |
|---|---|---|
| Alterac Mountains (1416) | - | Jack Findle[A] |
| Arathi Highlands (1417) | Graud[H]; Vikki Lonsav[A] | Hammon Karwn[A]; Keena[H] |
| Ashenvale (1440) | Haljan Oakheart[A] | Dalria[A]; Shandrina[A] |
| Azshara (1447) | - | Blimo Gadgetspring[both] |
| Badlands (1418) | Grawl[H] | - |
| Darkshore (1439) | Dalmond[A] | Gorbold Steelhand[A]; Ullanna[A] |
| Darnassus (1457) | Ellandrieth[A]; Mydrannul[A] | Mythrin'dir[A] |
| Desolace (1443) | Christi Galvanis[A]; Tukk[H] | Kireena[H]; Lah'Mawhani[H] |
| Dun Morogh (1426) | Adlin Pridedrift[A]; Kreg Bilmn[A] | Golorn Frostbeard[A] |
| Durotar (1411) | Duokna[H]; Jark[H]; K'waii[H] | Flakk[H]; Tai'tasi[H] |
| Duskwood (1431) | Mabel Solaj[A] | Gunder Thornbush[A] |
| Dustwallow Marsh (1445) | Charity Mipsy[A] | Helenia Olden[A] |
| Eastern Plaguelands (1423) | - | Jase Farlane[both] |
| Elwynn Forest (1429) | Brog Hamfist[A]; Brother Danil[A] | Drake Lindgren[A]; Tharynn Bouden[A] |
| Felwood (1448) | Bale[H]; Malygen[A] | - |
| Feralas (1444) | Faralorn[A] | Sheendra Tallgrass[H]; Vivianna[A] |
| Hillsbrad Foothills (1424) | Kayren Soothallow[H]; Sarah Raycroft[A] | Christoph Jeffcoat[H]; Micha Yance[A] |
| Ironforge (1455) | Bryllia Ironbrand[A] | Burbik Gearspanner[A]; Fillius Fizzlespinner[A] |
| Loch Modan (1432) | Xandar Goodbeard[A]; Yanni Stoutheart[A] | Drac Roughcut[A] |
| Moonglade (1450) | Daeolyn Summerleaf[both] | Lorelae Wintersong[both] |
| Mount Hyjal (2482) | Lenedil Moonwing[both] | - |
| Mulgore (1412) | Kawnie Softbreeze[H]; Moorat Longstride[H] | Wunna Darkmane[H] |
| Orgrimmar (1454) | Asoran[H]; Trak'gen[H] | Felika[H]; Shimra[H] |
| Redridge Mountains (1433) | Lindsay Ashlock[A] | Amy Davenport[A] |
| Riverglades (2548) | Grizzek[both]; Maka[H]; Martha Wellsworth[A] | Gilliwigs[both] |
| Silithus (1451) | - | Mishta[both] |
| Silverpine Forest (1421) | Edwin Harly[H] | Andrew Hilbert[H] |
| Stonetalon Mountains (1442) | Chylina[A]; Grawnal[H] | Kulwia[H] |
| Stormwind City (1453) | Thurman Mullby[A] | Edna Mullby[A] |
| Stranglethorn Vale (1434) | Corporal Bluth[A]; Uthok[H] | Nerrist[H] |
| Swamp of Sorrows (1435) | - | Banalash[H] |
| Tanaris (1446) | Jabbey[both] | - |
| Teldrassil (1438) | Aldia[A]; Lyrai[A] | Narret Shadowgrove[A] |
| The Barrens (1413) | Barg[H]; Jazzik[both] | Ranik[both]; Tari'qa[H] |
| The Hinterlands (1425) | - | Gigget Zipcoil[both] |
| Thousand Needles (1441) | Jawn Highmesa[H] | Jandia[H] |
| Thunder Bluff (1456) | Kuruk[H]; Netali Proudwind[H] | Shadi Mistrunner[H] |
| Tirisfal Glades (1420) | Joshua Kien[H]; Mrs. Winters[H] | Abigail Shiel[H] |
| Un'Goro Crater (1449) | Nergal[both] | - |
| Undercity (1458) | Eleanor Rusk[H] | Daniel Bartlett[H]; Felicia Doan[H] |
| Westfall (1436) | - | Christopher Hewen[A]; Gina MacGregor[A] |
| Wetlands (1437) | Gruham Rumdnul[A]; Neal Allen[A] | Kersok Prond[A] |
| Winterspring (1452) | Natheril Raincaller[A] | Qia[both]; Syurana[A] |
| Zephras Isle (2521) | Antelariaa Cloudgaze[both]; Uualia Suncrest[both]; Veena Vericloud[both] | Belandiel Farflight[both]; Iallion Featherfall[both] |
