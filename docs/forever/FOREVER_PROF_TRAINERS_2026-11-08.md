# WoW Forever: profession trainers (12 professions), 8 Nov 2026

Research only, for Midnight Helper. Nothing in the MH repo was touched.
Every claim is tagged **GEMETEN** (read in a named, dated source) or **AFGELEID** (my reasoning).

## Method

**Important deviation (read first).** My agent rule forbids reading anything under `MidnightHelper/docs/`, so I did
NOT open `docs/forever/FOREVER_TRAINERS_2026-11-07.md`. The method below is rebuilt from the task brief (Wowhead Forever
NPC pages, `g_mapperData`, medoid, wago UiMap 1.60.1.70790, the Stormwind 1453 / Mulgore 1412 bigger-map rule,
~14 s between fetches). Please diff it against the class doc's Method section before merging the two.

1. **Roster.** Wowhead Forever NPC filter `https://www.wowhead.com/forever/npcs?filter=28;1;0` ("Trainer"),
   read in the in-app browser on 8 Nov 2026: **596 rows** (GEMETEN). I dropped rows whose tag is a class trainer,
   riding, pet, portal or weapon master trainer: **321 candidates** left (GEMETEN, my filter).
   All **237** Zygor profession-trainer rows (`ZygorGuidesViewerForever\Data-Forever\NPCData.lua`, sections
   `TrainerAlchemy` .. `TrainerTailoring`, lines 814-1074) are inside those 596 rows, so Zygor added no extra
   candidate (GEMETEN). My in-browser copy of the Zygor rows was checked against the file with a SHA-256 hash
   (`4a9cd91e...0f6c`, 237 rows, both sides equal) (GEMETEN).
2. **Fetch.** Each candidate's page `https://www.wowhead.com/forever/npc=<id>` was fetched one at a time,
   ~14-15 s apart, 8 Nov 2026 17:34-19:05 UTC (GEMETEN). From each page I parsed `g_mapperData` (coords) and every
   `teaches-*` Listview (the Teaches tab). Afterwards I fetched the Forever spell page of all 48 rank spells
   (12 professions x 4 ranks) and read their `taught-by-npc` lists (GEMETEN).
3. **Profession.** From the NPC tag (`<Expert Alchemist>` -> ALCHEMY etc.). Where the tag names no profession
   (`<Emerald Circle>`, `<Cenarion Circle>`, `<Innkeeper>`, no tag) the profession comes from the Teaches tab.
   Spec field (`spec = "GNOMISH"` etc.) comes from the tag only (AFGELEID), because Wowhead lists no
   specialisation spell for these NPCs.
4. **max.** Highest rank spell on the NPC's Teaches tab: Apprentice 75, Journeyman 150, Expert 225, Artisan 300
   (GEMETEN per row). Cross-check: for all 314 rows, `max` equals the highest rank spell whose "Taught by" list
   contains that NPC; 314/314 agree, 0 conflicts (GEMETEN). This is the same Wowhead database, so it is a
   consistency check, not an independent source (AFGELEID).
   `max = nil` + no flag = the Wowhead page has **no Teaches tab at all** (12 spec trainers).
   `max = nil, recipesOnly = true` = the Teaches tab exists but lists only recipes, no rank spell (11 NPCs).
   The tag alone was never used for `max`.
5. **Coordinates.** Take the uiMap with the most points; then the **medoid** (the real point with the smallest sum
   of distances to the others; tie -> first point in Wowhead's order). x/y are Wowhead's own 0-100 values
   (1 decimal, written as 2).
6. **Bigger-map rule (generalised).** wago.tools `UiMapAssignment`, Classic Era 1.15.9.70576 vs Forever
   1.60.1.70790: exactly four maps have other bounds in Forever (GEMETEN):

   | uiMap | Classic Era minX, minY, maxX, maxY | Forever minX, minY, maxX, maxY |
   |---|---|---|
   | 1453 Stormwind City | -9175.21, 36.70, -8278.85, 1380.97 | -9154.17, -14.58, -7995.83, 1722.92 |
   | 1412 Mulgore | -3697.92, -3089.58, -272.92, 2047.92 | -3835.42, -3675.00, 266.67, 2479.17 |
   | 1433 Redridge Mountains | -10022.92, -3741.67, -8575.00, -1570.83 | -10022.92, -3852.08, -8575.00, -1681.25 |
   | 1423 Eastern Plaguelands | 1218.75, -6056.25, 3800.00, -2185.42 | 825.00, -6558.33, 3691.67, -2256.25 |

   For NPCs on these maps Wowhead often lists two clusters: the old Classic-frame point and the Forever-frame point.
   I convert each cluster Classic -> world -> Forever (`y = maxY_c - u*(maxY_c-minY_c)`, `x = maxX_c - v*(maxX_c-minX_c)`,
   then `u' = (maxY_f-y)/(maxY_f-minY_f)`, `v' = (maxX_f-x)/(maxX_f-minX_f)`). A cluster whose converted centre lands
   within 2.5 of another cluster is the Classic copy and is dropped. Proof the formula is right (GEMETEN + AFGELEID):
   Stephen Ryback Classic point (75.5, 37.1) converts to (78.09, 53.14); Wowhead's other point is (78.2, 53.0).
   Pyall Silentstride (45.5, 58.0) converts to (44.99, 61.58); Wowhead's other point is (45.0, 61.6).
   Dropped Classic copies: Stormwind 22 rows, Mulgore 6, Redridge 4 (GEMETEN). 3 new Mulgore NPCs (267330-332) have
   only one cluster; they are new in Forever (`firstseenpatch 16001`), so their point can only be Forever-frame
   (AFGELEID). UiMap and UiMapAssignment are byte-identical in the newest Forever build on wago, 1.60.1.70862 (GEMETEN).
7. **uiMap names.** All 41 uiMaps used exist in wago `UiMap` build 1.60.1.70790 with the same name as Wowhead's
   `uiMapName` (GEMETEN). Riverglades = 2548, Mount Hyjal = 2482, Zephras Isle = 2521 (GEMETEN). There is **no
   separate Dalaran uiMap**: the Alterac hub NPCs sit on 1416 Alterac Mountains (GEMETEN).
8. **Side.** From Wowhead `react` `[Alliance, Horde]`: 1 = friendly, 0 = neutral, -1 = hostile, null = not given.
   A side counts as usable at 1 **or 0**; so `[1,null]` -> A, `[null,1]` -> H, `[1,1]`/`[0,0]` -> both.
   Counting neutral (0) as usable is AFGELEID and flagged per row. `[null,null]` -> `side = nil`.
9. **Zygor cross-check.** Same uiMap and distance <= 1.5 -> "Zygor agrees". No Zygor value is in any row.
10. Not used: HandyNotes_ClassTrainers, HandyNotes_WoWForever, Questie (licence).

## Counts

GEMETEN (from the rows below). "nil" = no rank spell readable: (recipes only / no Teaches tab).

| prof | rows | max 75 | 150 | 225 | 300 | nil (rec/no tab) | spec | A | H | both | side nil | in Zygor | Wowhead-only | Zygor rows |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ALCHEMY | 33 | 14 | 9 | 5 | 3 | 2 (2/0) | 0 | 16 | 12 | 4 | 1 | 19 | 14 | 19 |
| BLACKSMITHING | 33 | 13 | 9 | 3 | 1 | 7 (1/6) | 7 | 13 | 16 | 4 | 0 | 15 | 18 | 15 |
| ENCHANTING | 23 | 11 | 7 | 4 | 1 | 0 | 0 | 11 | 9 | 3 | 0 | 14 | 9 | 14 |
| ENGINEERING | 25 | 11 | 5 | 2 | 2 | 5 (5/0) | 5 | 10 | 7 | 7 | 1 | 17 | 8 | 17 |
| HERBALISM | 30 | 6 | 0 | 0 | 24 | 0 | 0 | 15 | 11 | 4 | 0 | 29 | 1 | 29 |
| LEATHERWORKING | 33 | 12 | 11 | 2 | 2 | 6 (1/5) | 6 | 14 | 16 | 3 | 0 | 24 | 9 | 24 |
| MINING | 22 | 6 | 0 | 0 | 16 | 0 | 0 | 10 | 8 | 4 | 0 | 21 | 1 | 21 |
| SKINNING | 23 | 6 | 0 | 0 | 17 | 0 | 0 | 10 | 11 | 2 | 0 | 23 | 0 | 23 |
| TAILORING | 27 | 9 | 10 | 4 | 2 | 2 (1/1) | 0 | 12 | 12 | 3 | 0 | 18 | 9 | 18 |
| COOKING | 24 | 0 | 23 | 0 | 0 | 1 (1/0) | 0 | 10 | 10 | 3 | 1 | 18 | 6 | 18 |
| FIRSTAID | 16 | 0 | 16 | 0 | 0 | 0 | 0 | 7 | 6 | 3 | 0 | 16 | 0 | 16 |
| FISHING | 25 | 0 | 25 | 0 | 0 | 0 | 0 | 12 | 9 | 4 | 0 | 23 | 2 | 23 |
| **TOTAL** | **314** | 88 | 115 | 20 | 68 | 23 | 18 | 140 | 127 | 44 | 3 | 237 | 77 | 237 |

Pattern (GEMETEN on the rows, AFGELEID as a rule): in Forever's Wowhead data the tag is one rank "ahead" of what the
NPC teaches. `<Journeyman X>` mostly teaches only Apprentice (75), `<Expert X>` teaches up to Journeyman (150),
`<Artisan X>` up to Expert (225), `<Master X>` Artisan (300). Gathering trainers without "Junior" teach all four ranks;
the 18 "Junior ... Trainer" NPCs teach Apprentice only. So never derive max from the tag.

## Rank spells (GEMETEN, Wowhead Forever spell pages, 8 Nov 2026)

| prof (skill line) | Apprentice | Journeyman | Expert | Artisan |
|---|---|---|---|---|
| ALCHEMY (171) | 2259 | 3101 | 3464 | 11611 |
| BLACKSMITHING (164) | 2018 | 3100 | 3538 | 9785 |
| ENCHANTING (333) | 7411 | 7412 | 7413 | 13920 |
| ENGINEERING (202) | 4036 | 4037 | 4038 | 12656 |
| HERBALISM (182) | 2366 | 2368 | 3570 | 11993 |
| LEATHERWORKING (165) | 2108 | 3104 | 3811 | 10662 |
| MINING (186) | 2575 | 2576 | 3564 | 10248 |
| SKINNING (393) | 8613 | 8617 | 8618 | 10768 |
| TAILORING (197) | 3908 | 3909 | 3910 | 12180 |
| COOKING (185) | 2550 | 3102 | 3413 | 18260 |
| FIRSTAID (129) | 3273 | 3274 | 7924 | 10846 |
| FISHING (356) | 7620 | 7731 | 7732 | 18248 |

Infobox values (GEMETEN): Journeyman "Requires <Prof> (50)", 500 copper (5s); Expert "(125)", 5000 (50s);
Artisan "(200)", 50000 (5g); Apprentice 10 copper (Cooking, First Aid, Fishing: 100 = 1s).
Exception: the Artisan Tailoring page (12180) shows no "Requires Tailoring (200)" line and its listview says
`learnedat 9999` (GEMETEN; looks like a Wowhead data gap, AFGELEID).
Compare Classic: Wowhead Classic Artisan Alchemy 11611 costs 45000 (4g50s); Forever 50000 (5g) (GEMETEN, both pages).

## Where Artisan (300) is trained in Forever

GEMETEN = the Forever spell page's "Taught by" list, 8 Nov 2026.

| prof | Artisan spell | taught by (Forever) | vs Wowhead Classic |
|---|---|---|---|
| ALCHEMY | 11611 | Rogvar 1386 (Swamp of Sorrows, H), Kylanna Windwhisper 7948 (Feralas, A), **Master Mycologist Shurome 259585 (Felwood, new NPC, side unknown)** | Classic: Rogvar + Kylanna W. only. Shurome is new (GEMETEN) |
| BLACKSMITHING | 9785 | Brikk Keencraft 2836 (Booty Bay, STV, both) | same as Classic |
| ENCHANTING | 13920 | Annora 11073 (inside Uldaman, both) | same as Classic |
| ENGINEERING | 12656 | Buzzek Bracketswing 8736 (Gadgetzan, Tanaris, both), **Kaylaena Springwhisper 249235 (Mount Hyjal, new NPC, side unknown)** | Classic: Buzzek only. Kaylaena is new (GEMETEN) |
| LEATHERWORKING | 10662 | Drakk Stonehand 11097 (Aerie Peak, Hinterlands, A), Hahrana Ironhide 11098 (Feralas, H) | same as Classic |
| TAILORING | 12180 | Daryl Stack 2399 (Tarren Mill, Hillsbrad, H), Timothy Worthington 11052 (Theramore, Dustwallow, A) | Classic also lists Meilosh 11557 (Felwood). Forever's Meilosh page has no Teaches tab (empty proves nothing) |
| HERBALISM | 11993 | 24 trainers: every non-Junior herbalism trainer | - |
| MINING | 10248 | 16 trainers: every non-Junior mining trainer | - |
| SKINNING | 10768 | 17 trainers: every non-Junior skinning trainer | - |
| COOKING | 18260 | **nobody** on Wowhead Forever (Expert 3413 also nobody) | - |
| FIRSTAID | 10846 | **nobody** on Wowhead Forever (Expert 7924 also nobody) | - |
| FISHING | 18248 | **nobody** on Wowhead Forever (Expert 7732 also nobody) | - |

Cooking / First Aid / Fishing Expert + Artisan: Wowhead Forever lists no trainer (GEMETEN), which proves nothing on its
own. Third-party guides say it works as in Classic: Expert from a book, Artisan from a quest
(Clamlette Surprise / Triage / "Nat Pagle, Angler Extreme"): 1mw.io/en/professions/trainers ("beta data, last verified
15 Oct 2026", marked untested) and foreverartisan.app (fishing) (GEMETEN that they say so; not verified in game).

## Is the Classic level requirement (Journeyman 10, Expert 20, Artisan 35) still there?

- **Wowhead cannot answer it.** No Forever rank-spell page shows a level requirement; the infobox only shows skill and
  cost, and the listview has `level: 0` (GEMETEN, 3101, 3464, 11611 and the other 45). Wowhead Classic shows no level
  on these pages either (GEMETEN, Classic 3101 and 11611). So its absence means nothing (AFGELEID).
- **Not in the client files:** SenseOS (26 Oct 2026, read against launch client 1.60.1.70790) says the game files hold
  no character level per rank and no training price, and Blizzard has not published one (GEMETEN, that source).
  wowclassicforever.info: "The Forever client has no trainer table" (GEMETEN, that source, undated).
- **Guides say yes, Classic values:**
  - Icy Veins "WoW Forever Profession Guide", updated 3 Nov 2026: Journeyman skill 50 / crafting level 10 / gathering
    none; Expert 125 / 20 / 10; Artisan 200 / 35 / 25 (GEMETEN, that source).
  - wowcarry.com enchanting guide, 4 Nov 2026: 10 / 20 / 35 (GEMETEN, that source).
  - Wowhead Forever "Enchanting Overview" guide: levels 10 / 20 / 35 (GEMETEN; undated in my read; it gives Artisan
    min skill 225, which contradicts Wowhead's own spell page "(200)").
  - wow-professions.com Alchemy trainers, wow.gg Blacksmithing (8 Nov 2026), Zockify, wowcamp.fun: 10 / 20 / 35.
- **Verdict: AFGELEID, not proven.** All guides agree on 10 / 20 / 35 for crafting (Icy Veins adds gathering:
  none / 10 / 25). None shows an in-game measurement, and the value is server-side. To make it GEMETEN, someone has to
  look at a trainer in game with a low-level character (for example a level 9 crafter with skill 50 at an
  `<Expert X>` trainer).

## Zygor vs Wowhead

- **Zygor trainers missing from Wowhead: 0** (all 237 in the 596-row filter and on their NPC pages) (GEMETEN).
- **Wowhead trainers missing from Zygor: 77** (GEMETEN):
  - ALCHEMY: 1937 Apothecary Renferrel, 249713 Odd Child, 11044 Doctor Martin Felben, 4609 Doctor Marsh, 11046 Whuut,
    5500 Tel'Athir, 253004 Iaadaria Bitterwind, 1246 Vosur Brakthel, 246795 Linzy Blackbolt, 11047 Kray,
    259585 Master Mycologist Shurome, 11041 Milla Fairancora, 11042 Sylvanna Forestmoon, 275322 Patricia Egan
  - BLACKSMITHING: 276067 Angus Hammerhand, 957 Dane Lindgren, 10266 Ug'thok, 4605 Basil Frye, 1383 Snarl,
    7232 Borgus Steelhand, 28694 Alard Schmied, 10276 Rotgath Stonebeard, 10278 Thrag Stonehoof, 10277 Groum Stonebeard,
    7230 Shayis Steelfury, 259250 Alphonse Dumas, 256658 Gur'dok, 11178 Borgosh Corebender, 5164 Grumnus Steelshaper,
    11146 Ironus Coldsteel, 7231 Kelgruk Bloodaxe, 11177 Okothos Ironrager
  - ENCHANTING: 11068 Betty Quin, 266881 Pa'zula, 11065 Thonys Pillarstone, 11073 Annora, 11066 Jhag, 11067 Malcomb Wynn,
    11071 Mot Dawnstrider, 11070 Lalina Summermoon, 259287 Melanie Sable
  - ENGINEERING: 11026 Sprite Jumpsprocket, 11028 Jemma Quikswitch, 3412 Nogg, 4586 Graham Van Talen, 2857 Thund,
    11029 Trixie Quikswitch, 260562 Melbin Powderfuse, 249235 Kaylaena Springwhisper
  - HERBALISM: 275321 Edward Egan (Artisan trainer, Alterac hub)
  - LEATHERWORKING: 5811 Kamari, 11096 Randal Worth, 1466 Gretta Finespindle, 11083 Darianna, 11081 Faldron, 5784 Waldor,
    3008 Mak, 11084 Tarn, 223 Dan Golthas
  - MINING: 255891 Grungle (Artisan trainer, Riverglades)
  - TAILORING: 5567 Sellandus, 1300 Lawrence Schneider, 1703 Uthrar Threx, 2855 Snang, 11048 Victor Ward,
    251972 Charles Worth, 11049 Rhiannon Davis, 11050 Trianna, 11051 Vhan
  - COOKING: 3191 Cook Torka, 2818 Slagg, 256655 Gorg, 244512 Ortak Lomgok, 249968 Hnaz Blunderflame, 267000 Paige
  - FISHING: 255877 Hunter Moore, 260558 Krix
  - (SKINNING, FIRSTAID: none missing.)
  Zygor mostly lists one trainer per profession per city (the higher-rank one) and misses Riverglades, Mount Hyjal,
  Felwood-new and most of the Alterac hub (AFGELEID).
- **Coordinates:** 232 of 237 agree within 1.5 (largest 1.40) (GEMETEN). 5 differ:
  - Redridge 1433, 4 rows (812 Alma Jainrose 5.5, 1680 Matthew Hooper 5.6, 3087 Crystal Boughman 5.2,
    6295 Wilma Ranthal 5.2): Zygor equals Wowhead's **Classic-frame** cluster; the Forever Redridge map is shifted
    110.42 yards = 5.09 x-units (wago, GEMETEN). So Zygor is very likely off by ~5 in Redridge (AFGELEID).
  - 2367 Donald Rabonne (Hillsbrad): Wowhead has 4 points spread 3.2 from the medoid; Zygor (50.78, 61.03) vs ours
    (50.40, 64.20) (GEMETEN).
- **Side:** 3 differ: 10993 Twizwick Sprocketgrind (Wowhead `[null,1]` -> H, Zygor B), 11097 Drakk Stonehand
  (Wowhead `[1,null]` -> A, Zygor B), 251977 Angelique Butler (Wowhead `[1,0]` -> both by my rule, Zygor A) (GEMETEN).
- **Profession:** 0 differences (GEMETEN).

## Open / unsure rows

1. **Redridge (4 rows above):** we use Wowhead's Forever-frame point; Zygor uses the Classic frame. One in-game
   `/way` check of Crystal Boughman (expect ~17.6, 43.6) settles it.
2. **Side rule, neutral react counted as usable (AFGELEID):** `[1,0]` 28694 Alard Schmied, 251977 Angelique Butler,
   267000 Paige (Alterac hub); `[0,null]` 259287 Melanie Sable, 259250 Alphonse Dumas (Riverglades);
   `[0,0]` 8736 Buzzek, 8126 Nixx, 8128 Pikkle, 255891 Grungle, 260558 Krix, 260562 Melbin.
   **side = nil** (Wowhead gives no react, infobox has no React line): 259585 Shurome (Felwood),
   249235 Kaylaena Springwhisper (Mount Hyjal), 244512 Ortak Lomgok (Mount Hyjal).
3. **No coordinates:** 11073 Annora (Wowhead location 1337 = Uldaman, instance; `map/x/y = nil`).
4. **Continent-map coordinates only:** 249713 Odd Child (map 1415 Eastern Kingdoms; a guide places it in the Moonbrook
   barn, Westfall) and 5784 Waldor (map 1414 Kalimdor; Wailing Caverns cave per 1mw.io). A zone uiMap would need
   another source.
5. **No Teaches tab on Wowhead -> max nil (12):** BLACKSMITHING 5164, 11146, 11178, 7231, 11177, 7232;
   LEATHERWORKING 7869, 7866, 7870, 7868, 7871; TAILORING 4578 (GEMETEN that the tab is missing).
6. **Recipes only -> max nil, recipesOnly (11):** 1937, 249713 (special alchemy recipes), 7230, 7944, 7406, 8126, 8738,
   260562, 7867, 9584, 2818 (GEMETEN).
7. **Spec field is from the tag (AFGELEID).** Especially `<Weapon Crafter>` / `<Armor Crafter>` / `<Special Weapon
   Crafter>` (7232, 7231, 5164, 7230, 11146): in Classic some of these were quest-givers, not trainers. 1mw.io (beta)
   calls 5164 Armorsmithing-only, 11146 / 11178 Weaponsmithing-only, 11177 Armorsmithing-only.
8. **Odd extra ranks on a Teaches tab (GEMETEN, probably Wowhead data mixing, AFGELEID):** 5500 Tel'Athir
   `<Journeyman Alchemist>` lists Alchemy Apprentice AND Herbalism Apprentice..Artisan (he is in all four Herbalism
   taught-by lists); kept as ALCHEMY 75. 5513 Gelman Stonehand lists Blacksmithing Apprentice; 7088 Thuwd lists
   Leatherworking Apprentice.
9. **Tag vs Teaches conflict worth an in-game look:** 1300 Lawrence Schneider `<Journeyman Tailor>`: Wowhead says up to
   Expert (225); 1mw.io (beta) says Apprentice only.
10. **Mulgore single-frame rows** 267330, 267331, 267332: Forever frame assumed because the NPC is new (AFGELEID);
    Zygor agrees on all three.
11. **Excluded candidates (no profession on tag or Teaches tab):** 265003 Thom Filch (no tag, no Teaches tab,
    6 points Ironforge), 6251 Strahad Farsan (teaches warlock spells), 11557 Meilosh (no Teaches tab in Forever; Classic
    Wowhead lists him for Artisan Tailoring), 6707 Fahrad, 5492 Katherine the Pure, 331 Maginor Dumas, 5994 Zayus.
12. Fetch side note: one Classic comparison script timed out in the tool and kept running, so for about 1.5 minutes two
    loops ran side by side (~2 requests per 14 s). No error or non-200 status was seen in any of the 375 fetches
    (GEMETEN).

## Rows

Comment format: zone; tag; Wowhead URL; GEMETEN (coords + max from that page); N points used; flags; Zygor check.

```lua
local FOREVER_PROF_TRAINERS = {
  -- ALCHEMY (33)
  { npc = 246795, name = "Linzy Blackbolt", prof = "ALCHEMY", side = "A", map = 1416, x = 18.40, y = 62.40, max = 225 }, -- Alterac Mountains; <Alchemist>; https://www.wowhead.com/forever/npc=246795; GEMETEN; 2pt; not in Zygor
  { npc = 275322, name = "Patricia Egan", prof = "ALCHEMY", side = "A", map = 1416, x = 18.40, y = 62.40, max = 225 }, -- Alterac Mountains; <Alchemist>; https://www.wowhead.com/forever/npc=275322; GEMETEN; 2pt; not in Zygor
  { npc = 3964, name = "Kylanna", prof = "ALCHEMY", side = "A", map = 1440, x = 50.80, y = 67.00, max = 150 }, -- Ashenvale; <Expert Alchemist>; https://www.wowhead.com/forever/npc=3964; GEMETEN; 1pt; Zygor agrees (50.85,67.11)
  { npc = 4160, name = "Ainethil", prof = "ALCHEMY", side = "A", map = 1457, x = 55.60, y = 24.40, max = 225 }, -- Darnassus; <Artisan Alchemist>; https://www.wowhead.com/forever/npc=4160; GEMETEN; 5pt; Zygor agrees (54.87,24.01)
  { npc = 11041, name = "Milla Fairancora", prof = "ALCHEMY", side = "A", map = 1457, x = 55.20, y = 22.80, max = 75 }, -- Darnassus; <Journeyman Alchemist>; https://www.wowhead.com/forever/npc=11041; GEMETEN; 5pt; not in Zygor
  { npc = 11042, name = "Sylvanna Forestmoon", prof = "ALCHEMY", side = "A", map = 1457, x = 56.20, y = 24.20, max = 225 }, -- Darnassus; <Expert Alchemist>; https://www.wowhead.com/forever/npc=11042; GEMETEN; 5pt; not in Zygor
  { npc = 3184, name = "Miao'zan", prof = "ALCHEMY", side = "H", map = 1411, x = 55.40, y = 74.00, max = 75 }, -- Durotar; <Journeyman Alchemist>; https://www.wowhead.com/forever/npc=3184; GEMETEN; 2pt; Zygor agrees (55.4,73.94)
  { npc = 4900, name = "Alchemist Narett", prof = "ALCHEMY", side = "A", map = 1445, x = 64.00, y = 47.60, max = 150 }, -- Dustwallow Marsh; <Expert Alchemist>; https://www.wowhead.com/forever/npc=4900; GEMETEN; 1pt; Zygor agrees (63.93,47.64)
  { npc = 249713, name = "Odd Child", prof = "ALCHEMY", side = "both", map = 1415, x = 41.20, y = 79.00, max = nil, recipesOnly = true }, -- Eastern Kingdoms (continent map); <>; https://www.wowhead.com/forever/npc=249713; GEMETEN; 1pt; prof from Teaches tab, recipes only (6); not in Zygor
  { npc = 1215, name = "Alchemist Mallory", prof = "ALCHEMY", side = "A", map = 1429, x = 39.80, y = 48.40, max = 75 }, -- Elwynn Forest; <Journeyman Alchemist>; https://www.wowhead.com/forever/npc=1215; GEMETEN; 2pt; Zygor agrees (39.84,48.23)
  { npc = 259585, name = "Master Mycologist Shurome", prof = "ALCHEMY", side = nil, map = 1448, x = 51.40, y = 82.00, max = 300 }, -- Felwood; <Emerald Circle>; https://www.wowhead.com/forever/npc=259585; GEMETEN; 1pt; prof from Teaches tab; no react on Wowhead [null,null]; not in Zygor
  { npc = 7948, name = "Kylanna Windwhisper", prof = "ALCHEMY", side = "A", map = 1444, x = 32.40, y = 43.80, max = 300 }, -- Feralas; <Master Alchemist>; https://www.wowhead.com/forever/npc=7948; GEMETEN; 2pt; Zygor agrees (32.62,43.77)
  { npc = 2391, name = "Serge Hinott", prof = "ALCHEMY", side = "H", map = 1424, x = 61.40, y = 19.20, max = 150 }, -- Hillsbrad Foothills; <Expert Alchemist>; https://www.wowhead.com/forever/npc=2391; GEMETEN; 2pt; Zygor agrees (61.62,19.18)
  { npc = 5177, name = "Tally Berryfizz", prof = "ALCHEMY", side = "A", map = 1455, x = 66.60, y = 55.20, max = 150 }, -- Ironforge; <Expert Alchemist>; https://www.wowhead.com/forever/npc=5177; GEMETEN; 5pt; Zygor agrees (66.61,55.68)
  { npc = 1246, name = "Vosur Brakthel", prof = "ALCHEMY", side = "A", map = 1455, x = 66.60, y = 55.20, max = 75 }, -- Ironforge; <Journeyman Alchemist>; https://www.wowhead.com/forever/npc=1246; GEMETEN; 4pt; not in Zygor
  { npc = 1470, name = "Ghak Healtouch", prof = "ALCHEMY", side = "A", map = 1432, x = 37.00, y = 49.20, max = 75 }, -- Loch Modan; <Journeyman Alchemist>; https://www.wowhead.com/forever/npc=1470; GEMETEN; 1pt; Zygor agrees (37.06,49.37)
  { npc = 11046, name = "Whuut", prof = "ALCHEMY", side = "H", map = 1454, x = 55.80, y = 33.20, max = 75 }, -- Orgrimmar; <Journeyman Alchemist>; https://www.wowhead.com/forever/npc=11046; GEMETEN; 2pt; not in Zygor
  { npc = 3347, name = "Yelmak", prof = "ALCHEMY", side = "H", map = 1454, x = 56.60, y = 33.60, max = 150 }, -- Orgrimmar; <Expert Alchemist>; https://www.wowhead.com/forever/npc=3347; GEMETEN; 4pt; Zygor agrees (56.83,33.03)
  { npc = 1937, name = "Apothecary Renferrel", prof = "ALCHEMY", side = "H", map = 1421, x = 42.80, y = 40.80, max = nil, recipesOnly = true }, -- Silverpine Forest; <Royal Apothecary Society>; https://www.wowhead.com/forever/npc=1937; GEMETEN; 1pt; recipes only (6); not in Zygor
  { npc = 5499, name = "Lilyssia Nightbreeze", prof = "ALCHEMY", side = "A", map = 1453, x = 55.60, y = 85.80, max = 150 }, -- Stormwind City; <Expert Alchemist>; https://www.wowhead.com/forever/npc=5499; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (55.66,86.08)
  { npc = 5500, name = "Tel'Athir", prof = "ALCHEMY", side = "A", map = 1453, x = 55.40, y = 85.40, max = 75 }, -- Stormwind City; <Journeyman Alchemist>; https://www.wowhead.com/forever/npc=5500; GEMETEN; 4pt; tab also lists HERBALISM rank<=300 (open item 8); classic-frame pts dropped; not in Zygor
  { npc = 2837, name = "Jaxin Chong", prof = "ALCHEMY", side = "both", map = 1434, x = 28.00, y = 78.00, max = 150 }, -- Stranglethorn Vale; <Expert Alchemist>; https://www.wowhead.com/forever/npc=2837; GEMETEN; 1pt; Zygor agrees (28.04,77.99)
  { npc = 1386, name = "Rogvar", prof = "ALCHEMY", side = "H", map = 1435, x = 48.40, y = 55.60, max = 300 }, -- Swamp of Sorrows; <Master Alchemist>; https://www.wowhead.com/forever/npc=1386; GEMETEN; 3pt; Zygor agrees (48.52,55.84)
  { npc = 3603, name = "Cyndra Kindwhisper", prof = "ALCHEMY", side = "A", map = 1438, x = 57.60, y = 60.60, max = 75 }, -- Teldrassil; <Journeyman Alchemist>; https://www.wowhead.com/forever/npc=3603; GEMETEN; 1pt; Zygor agrees (57.63,60.8)
  { npc = 3009, name = "Bena Winterhoof", prof = "ALCHEMY", side = "H", map = 1456, x = 46.80, y = 33.40, max = 150 }, -- Thunder Bluff; <Expert Alchemist>; https://www.wowhead.com/forever/npc=3009; GEMETEN; 2pt; Zygor agrees (46.61,33.17)
  { npc = 11047, name = "Kray", prof = "ALCHEMY", side = "H", map = 1456, x = 46.80, y = 34.20, max = 75 }, -- Thunder Bluff; <Journeyman Alchemist>; https://www.wowhead.com/forever/npc=11047; GEMETEN; 3pt; not in Zygor
  { npc = 2132, name = "Carolai Anise", prof = "ALCHEMY", side = "H", map = 1420, x = 59.40, y = 52.20, max = 75 }, -- Tirisfal Glades; <Journeyman Alchemist>; https://www.wowhead.com/forever/npc=2132; GEMETEN; 1pt; Zygor agrees (59.43,52.19)
  { npc = 4611, name = "Doctor Herbert Halsey", prof = "ALCHEMY", side = "H", map = 1458, x = 47.60, y = 73.00, max = 225 }, -- Undercity; <Artisan Alchemist>; https://www.wowhead.com/forever/npc=4611; GEMETEN; 6pt; Zygor agrees (47.77,73.34)
  { npc = 4609, name = "Doctor Marsh", prof = "ALCHEMY", side = "H", map = 1458, x = 51.60, y = 74.60, max = 150 }, -- Undercity; <Expert Alchemist>; https://www.wowhead.com/forever/npc=4609; GEMETEN; 5pt; not in Zygor
  { npc = 11044, name = "Doctor Martin Felben", prof = "ALCHEMY", side = "H", map = 1458, x = 46.60, y = 74.40, max = 75 }, -- Undercity; <Journeyman Alchemist Trainer>; https://www.wowhead.com/forever/npc=11044; GEMETEN; 5pt; not in Zygor
  { npc = 253004, name = "Iaadaria Bitterwind", prof = "ALCHEMY", side = "A", map = 2521, x = 66.20, y = 79.40, max = 75 }, -- Zephras Isle; <Alchemist>; https://www.wowhead.com/forever/npc=253004; GEMETEN; 2pt; react [1,-1]; not in Zygor
  { npc = 257019, name = "Nyassa Swiftdraught", prof = "ALCHEMY", side = "both", map = 2521, x = 43.60, y = 43.40, max = 75 }, -- Zephras Isle; <Alchemist>; https://www.wowhead.com/forever/npc=257019; GEMETEN; 2pt; Zygor agrees (43.69,43.42)
  { npc = 257005, name = "Valiena Swiftgale", prof = "ALCHEMY", side = "both", map = 2521, x = 59.20, y = 76.20, max = 75 }, -- Zephras Isle; <Alchemist>; https://www.wowhead.com/forever/npc=257005; GEMETEN; 1pt; Zygor agrees (59.25,76.32)
  -- BLACKSMITHING (33)
  { npc = 28694, name = "Alard Schmied", prof = "BLACKSMITHING", side = "both", map = 1416, x = 19.60, y = 63.20, max = 225 }, -- Alterac Mountains; <Blacksmith>; https://www.wowhead.com/forever/npc=28694; GEMETEN; 2pt; react [1,0], neutral counted usable (AFGELEID); not in Zygor
  { npc = 6299, name = "Delfrum Flintbeard", prof = "BLACKSMITHING", side = "A", map = 1439, x = 38.20, y = 41.00, max = 75 }, -- Darkshore; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=6299; GEMETEN; 1pt; Zygor agrees (38.19,40.93)
  { npc = 1241, name = "Tognus Flintfire", prof = "BLACKSMITHING", side = "A", map = 1426, x = 45.20, y = 52.00, max = 75 }, -- Dun Morogh; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=1241; GEMETEN; 1pt; Zygor agrees (45.34,51.93)
  { npc = 3174, name = "Dwukk", prof = "BLACKSMITHING", side = "H", map = 1411, x = 52.00, y = 40.60, max = 75 }, -- Durotar; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=3174; GEMETEN; 1pt; Zygor agrees (52.03,40.71)
  { npc = 3136, name = "Clarise Gnarltree", prof = "BLACKSMITHING", side = "A", map = 1431, x = 73.80, y = 48.60, max = 150 }, -- Duskwood; <Expert Blacksmith>; https://www.wowhead.com/forever/npc=3136; GEMETEN; 2pt; Zygor agrees (74,48.54)
  { npc = 514, name = "Smith Argus", prof = "BLACKSMITHING", side = "A", map = 1429, x = 41.60, y = 65.40, max = 75 }, -- Elwynn Forest; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=514; GEMETEN; 2pt; Zygor agrees (41.7,65.54)
  { npc = 4258, name = "Bengus Deepforge", prof = "BLACKSMITHING", side = "A", map = 1455, x = 52.20, y = 41.40, max = 225 }, -- Ironforge; <Artisan Blacksmith>; https://www.wowhead.com/forever/npc=4258; GEMETEN; 6pt; Zygor agrees (52.54,41.45)
  { npc = 10277, name = "Groum Stonebeard", prof = "BLACKSMITHING", side = "A", map = 1455, x = 52.00, y = 42.00, max = 75 }, -- Ironforge; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=10277; GEMETEN; 5pt; not in Zygor
  { npc = 5164, name = "Grumnus Steelshaper", prof = "BLACKSMITHING", spec = "ARMORSMITH", side = "A", map = 1455, x = 50.20, y = 42.60, max = nil }, -- Ironforge; <Armor Crafter>; https://www.wowhead.com/forever/npc=5164; GEMETEN; spec from tag AFGELEID; 7pt; no Teaches tab on Wowhead; not in Zygor
  { npc = 11146, name = "Ironus Coldsteel", prof = "BLACKSMITHING", spec = "WEAPONSMITH", side = "A", map = 1455, x = 50.60, y = 43.60, max = nil }, -- Ironforge; <Special Weapon Crafter>; https://www.wowhead.com/forever/npc=11146; GEMETEN; spec from tag AFGELEID; 7pt; no Teaches tab on Wowhead; not in Zygor
  { npc = 10276, name = "Rotgath Stonebeard", prof = "BLACKSMITHING", side = "A", map = 1455, x = 52.00, y = 42.40, max = 150 }, -- Ironforge; <Expert Blacksmith>; https://www.wowhead.com/forever/npc=10276; GEMETEN; 5pt; not in Zygor
  { npc = 11178, name = "Borgosh Corebender", prof = "BLACKSMITHING", spec = "WEAPONSMITH", side = "H", map = 1454, x = 79.40, y = 23.40, max = nil }, -- Orgrimmar; <Weaponsmith>; https://www.wowhead.com/forever/npc=11178; GEMETEN; spec from tag AFGELEID; 4pt; no Teaches tab on Wowhead; not in Zygor
  { npc = 7231, name = "Kelgruk Bloodaxe", prof = "BLACKSMITHING", spec = "WEAPONSMITH", side = "H", map = 1454, x = 81.80, y = 18.60, max = nil }, -- Orgrimmar; <Weapon Crafter>; https://www.wowhead.com/forever/npc=7231; GEMETEN; spec from tag AFGELEID; 2pt; no Teaches tab on Wowhead; not in Zygor
  { npc = 11177, name = "Okothos Ironrager", prof = "BLACKSMITHING", spec = "ARMORSMITH", side = "H", map = 1454, x = 79.40, y = 23.60, max = nil }, -- Orgrimmar; <Armorsmith>; https://www.wowhead.com/forever/npc=11177; GEMETEN; spec from tag AFGELEID; 4pt; no Teaches tab on Wowhead; not in Zygor
  { npc = 3355, name = "Saru Steelfury", prof = "BLACKSMITHING", side = "H", map = 1454, x = 82.20, y = 23.00, max = 225 }, -- Orgrimmar; <Artisan Blacksmith>; https://www.wowhead.com/forever/npc=3355; GEMETEN; 2pt; Zygor agrees (82.34,22.97)
  { npc = 7230, name = "Shayis Steelfury", prof = "BLACKSMITHING", spec = "ARMORSMITH", side = "H", map = 1454, x = 80.40, y = 23.60, max = nil, recipesOnly = true }, -- Orgrimmar; <Armor Crafter>; https://www.wowhead.com/forever/npc=7230; GEMETEN; spec from tag AFGELEID; 4pt; recipes only (2); not in Zygor
  { npc = 1383, name = "Snarl", prof = "BLACKSMITHING", side = "H", map = 1454, x = 79.40, y = 23.00, max = 150 }, -- Orgrimmar; <Expert Blacksmith>; https://www.wowhead.com/forever/npc=1383; GEMETEN; 4pt; not in Zygor
  { npc = 10266, name = "Ug'thok", prof = "BLACKSMITHING", side = "H", map = 1454, x = 80.40, y = 23.40, max = 75 }, -- Orgrimmar; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=10266; GEMETEN; 4pt; not in Zygor
  { npc = 259250, name = "Alphonse Dumas", prof = "BLACKSMITHING", side = "A", map = 2548, x = 64.40, y = 82.00, max = 75 }, -- Riverglades; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=259250; GEMETEN; 1pt; react [0,null], neutral counted usable (AFGELEID); not in Zygor
  { npc = 256658, name = "Gur'dok", prof = "BLACKSMITHING", side = "H", map = 2548, x = 60.00, y = 46.20, max = 75 }, -- Riverglades; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=256658; GEMETEN; 1pt; not in Zygor
  { npc = 3557, name = "Guillaume Sorouy", prof = "BLACKSMITHING", side = "H", map = 1421, x = 43.20, y = 41.00, max = 75 }, -- Silverpine Forest; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=3557; GEMETEN; 1pt; Zygor agrees (43.19,41.08)
  { npc = 7232, name = "Borgus Steelhand", prof = "BLACKSMITHING", spec = "WEAPONSMITH", side = "A", map = 1453, x = 59.40, y = 34.20, max = nil }, -- Stormwind City; <Weapon Crafter>; https://www.wowhead.com/forever/npc=7232; GEMETEN; spec from tag AFGELEID; 2pt; no Teaches tab on Wowhead; classic-frame pts dropped; not in Zygor
  { npc = 957, name = "Dane Lindgren", prof = "BLACKSMITHING", side = "A", map = 1453, x = 64.00, y = 37.20, max = 75 }, -- Stormwind City; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=957; GEMETEN; 1pt; classic-frame pts dropped; not in Zygor
  { npc = 5511, name = "Therum Deepforge", prof = "BLACKSMITHING", side = "A", map = 1453, x = 63.40, y = 37.20, max = 150 }, -- Stormwind City; <Expert Blacksmith>; https://www.wowhead.com/forever/npc=5511; GEMETEN; 2pt; classic-frame pts dropped; Zygor agrees (63.65,36.96)
  { npc = 2836, name = "Brikk Keencraft", prof = "BLACKSMITHING", side = "both", map = 1434, x = 29.00, y = 75.40, max = 300 }, -- Stranglethorn Vale; <Master Blacksmith>; https://www.wowhead.com/forever/npc=2836; GEMETEN; 2pt; Zygor agrees (28.99,75.55)
  { npc = 3478, name = "Traugh", prof = "BLACKSMITHING", side = "H", map = 1413, x = 51.20, y = 28.80, max = 150 }, -- The Barrens; <Expert Blacksmith>; https://www.wowhead.com/forever/npc=3478; GEMETEN; 1pt; Zygor agrees (51.29,28.9)
  { npc = 2998, name = "Karn Stonehoof", prof = "BLACKSMITHING", side = "H", map = 1456, x = 39.40, y = 55.40, max = 150 }, -- Thunder Bluff; <Expert Blacksmith>; https://www.wowhead.com/forever/npc=2998; GEMETEN; 6pt; Zygor agrees (39.38,55.08)
  { npc = 10278, name = "Thrag Stonehoof", prof = "BLACKSMITHING", side = "H", map = 1456, x = 39.20, y = 56.20, max = 75 }, -- Thunder Bluff; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=10278; GEMETEN; 7pt; not in Zygor
  { npc = 276067, name = "Angus Hammerhand", prof = "BLACKSMITHING", side = "H", map = 1420, x = 21.20, y = 45.80, max = 150 }, -- Tirisfal Glades; <Blacksmith>; https://www.wowhead.com/forever/npc=276067; GEMETEN; 1pt; not in Zygor
  { npc = 4605, name = "Basil Frye", prof = "BLACKSMITHING", side = "H", map = 1458, x = 60.00, y = 28.60, max = 75 }, -- Undercity; <Journeyman Blacksmith>; https://www.wowhead.com/forever/npc=4605; GEMETEN; 5pt; not in Zygor
  { npc = 4596, name = "James Van Brunt", prof = "BLACKSMITHING", side = "H", map = 1458, x = 61.20, y = 30.00, max = 150 }, -- Undercity; <Expert Blacksmith>; https://www.wowhead.com/forever/npc=4596; GEMETEN; 4pt; Zygor agrees (61.26,30.62)
  { npc = 251913, name = "Aedi Thriceforged", prof = "BLACKSMITHING", side = "both", map = 2521, x = 44.80, y = 44.40, max = 75 }, -- Zephras Isle; <Blacksmith>; https://www.wowhead.com/forever/npc=251913; GEMETEN; 1pt; Zygor agrees (44.88,44.36)
  { npc = 252479, name = "Daeann Steelwind", prof = "BLACKSMITHING", side = "both", map = 2521, x = 65.40, y = 80.20, max = 150 }, -- Zephras Isle; <Blacksmith>; https://www.wowhead.com/forever/npc=252479; GEMETEN; 1pt; Zygor agrees (65.47,80.28)
  -- ENCHANTING (23)
  { npc = 11073, name = "Annora", prof = "ENCHANTING", side = "both", map = nil, x = nil, y = nil, max = 300 }, -- Uldaman (instance, Wowhead location 1337); <Master Enchanter>; https://www.wowhead.com/forever/npc=11073; GEMETEN; no coords on Wowhead; not in Zygor
  { npc = 251978, name = "Vanessa Sellers", prof = "ENCHANTING", side = "A", map = 1416, x = 16.60, y = 62.60, max = 225 }, -- Alterac Mountains; <Enchanting Trainer>; https://www.wowhead.com/forever/npc=251978; GEMETEN; 2pt; Zygor agrees (16.7,62.4)
  { npc = 11070, name = "Lalina Summermoon", prof = "ENCHANTING", side = "A", map = 1457, x = 58.80, y = 13.00, max = 75 }, -- Darnassus; <Journeyman Enchanter>; https://www.wowhead.com/forever/npc=11070; GEMETEN; 6pt; not in Zygor
  { npc = 4213, name = "Taladan", prof = "ENCHANTING", side = "A", map = 1457, x = 58.40, y = 13.20, max = 150 }, -- Darnassus; <Expert Enchanter>; https://www.wowhead.com/forever/npc=4213; GEMETEN; 4pt; Zygor agrees (58.4,13.12)
  { npc = 266881, name = "Pa'zula", prof = "ENCHANTING", side = "H", map = 1411, x = 56.40, y = 73.60, max = 75 }, -- Durotar; <Journeyman Enchanter>; https://www.wowhead.com/forever/npc=266881; GEMETEN; 2pt; not in Zygor
  { npc = 11072, name = "Kitta Firewind", prof = "ENCHANTING", side = "A", map = 1429, x = 64.80, y = 70.40, max = 225 }, -- Elwynn Forest; <Artisan Enchanter>; https://www.wowhead.com/forever/npc=11072; GEMETEN; 2pt; Zygor agrees (64.92,70.71)
  { npc = 7949, name = "Xylinnia Starshine", prof = "ENCHANTING", side = "A", map = 1444, x = 31.40, y = 44.20, max = 150 }, -- Feralas; <Expert Enchanter>; https://www.wowhead.com/forever/npc=7949; GEMETEN; 2pt; Zygor agrees (31.54,44.25)
  { npc = 5157, name = "Gimble Thistlefuzz", prof = "ENCHANTING", side = "A", map = 1455, x = 60.00, y = 45.40, max = 150 }, -- Ironforge; <Expert Enchanter>; https://www.wowhead.com/forever/npc=5157; GEMETEN; 6pt; Zygor agrees (59.76,45.44)
  { npc = 11065, name = "Thonys Pillarstone", prof = "ENCHANTING", side = "A", map = 1455, x = 60.60, y = 44.80, max = 75 }, -- Ironforge; <Journeyman Enchanter>; https://www.wowhead.com/forever/npc=11065; GEMETEN; 5pt; not in Zygor
  { npc = 3345, name = "Godan", prof = "ENCHANTING", side = "H", map = 1454, x = 53.80, y = 38.40, max = 150 }, -- Orgrimmar; <Expert Enchanter>; https://www.wowhead.com/forever/npc=3345; GEMETEN; 2pt; Zygor agrees (53.9,38.66)
  { npc = 11066, name = "Jhag", prof = "ENCHANTING", side = "H", map = 1454, x = 53.60, y = 38.20, max = 75 }, -- Orgrimmar; <Journeyman Enchanter>; https://www.wowhead.com/forever/npc=11066; GEMETEN; 3pt; not in Zygor
  { npc = 259287, name = "Melanie Sable", prof = "ENCHANTING", side = "A", map = 2548, x = 66.20, y = 83.20, max = 225 }, -- Riverglades; <Expert Enchanter>; https://www.wowhead.com/forever/npc=259287; GEMETEN; 1pt; react [0,null], neutral counted usable (AFGELEID); not in Zygor
  { npc = 11074, name = "Hgarth", prof = "ENCHANTING", side = "H", map = 1442, x = 49.20, y = 57.20, max = 225 }, -- Stonetalon Mountains; <Artisan Enchanter>; https://www.wowhead.com/forever/npc=11074; GEMETEN; 1pt; Zygor agrees (49.17,57.18)
  { npc = 11068, name = "Betty Quin", prof = "ENCHANTING", side = "A", map = 1453, x = 53.00, y = 73.80, max = 75 }, -- Stormwind City; <Journeyman Enchanter>; https://www.wowhead.com/forever/npc=11068; GEMETEN; 1pt; classic-frame pts dropped; not in Zygor
  { npc = 1317, name = "Lucan Cordell", prof = "ENCHANTING", side = "A", map = 1453, x = 53.00, y = 74.20, max = 150 }, -- Stormwind City; <Expert Enchanter>; https://www.wowhead.com/forever/npc=1317; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (52.9,74.45)
  { npc = 3606, name = "Alanna Raveneye", prof = "ENCHANTING", side = "A", map = 1438, x = 36.80, y = 34.20, max = 75 }, -- Teldrassil; <Journeyman Enchanter>; https://www.wowhead.com/forever/npc=3606; GEMETEN; 1pt; Zygor agrees (36.7,34.16)
  { npc = 11071, name = "Mot Dawnstrider", prof = "ENCHANTING", side = "H", map = 1456, x = 44.80, y = 38.80, max = 75 }, -- Thunder Bluff; <Journeyman Enchanter>; https://www.wowhead.com/forever/npc=11071; GEMETEN; 5pt; not in Zygor
  { npc = 3011, name = "Teg Dawnstrider", prof = "ENCHANTING", side = "H", map = 1456, x = 45.00, y = 38.00, max = 150 }, -- Thunder Bluff; <Expert Enchanter>; https://www.wowhead.com/forever/npc=3011; GEMETEN; 3pt; Zygor agrees (44.91,37.49)
  { npc = 5695, name = "Vance Undergloom", prof = "ENCHANTING", side = "H", map = 1420, x = 61.60, y = 51.40, max = 75 }, -- Tirisfal Glades; <Journeyman Enchanter>; https://www.wowhead.com/forever/npc=5695; GEMETEN; 2pt; Zygor agrees (61.76,51.56)
  { npc = 4616, name = "Lavinia Crowe", prof = "ENCHANTING", side = "H", map = 1458, x = 62.40, y = 61.40, max = 150 }, -- Undercity; <Expert Enchanter>; https://www.wowhead.com/forever/npc=4616; GEMETEN; 3pt; Zygor agrees (62.47,61.79)
  { npc = 11067, name = "Malcomb Wynn", prof = "ENCHANTING", side = "H", map = 1458, x = 62.20, y = 60.60, max = 75 }, -- Undercity; <Journeyman Enchanter>; https://www.wowhead.com/forever/npc=11067; GEMETEN; 4pt; not in Zygor
  { npc = 257004, name = "Eaysaa Brightgust", prof = "ENCHANTING", side = "both", map = 2521, x = 59.20, y = 76.20, max = 75 }, -- Zephras Isle; <Enchanter>; https://www.wowhead.com/forever/npc=257004; GEMETEN; 1pt; Zygor agrees (59.19,76.4)
  { npc = 257020, name = "Nasalanna Windsinger", prof = "ENCHANTING", side = "both", map = 2521, x = 43.20, y = 43.20, max = 75 }, -- Zephras Isle; <Enchanter>; https://www.wowhead.com/forever/npc=257020; GEMETEN; 1pt; Zygor agrees (43.24,43.16)
  -- ENGINEERING (25)
  { npc = 11037, name = "Jenna Lemkenilli", prof = "ENGINEERING", side = "A", map = 1439, x = 38.20, y = 41.00, max = 75 }, -- Darkshore; <Journeyman Engineer>; https://www.wowhead.com/forever/npc=11037; GEMETEN; 1pt; Zygor agrees (38.3,41.11)
  { npc = 1702, name = "Bronk Guzzlegear", prof = "ENGINEERING", side = "A", map = 1426, x = 50.20, y = 50.40, max = 75 }, -- Dun Morogh; <Journeyman Engineer>; https://www.wowhead.com/forever/npc=1702; GEMETEN; 1pt; Zygor agrees (50.17,50.37)
  { npc = 11025, name = "Mukdrak", prof = "ENGINEERING", side = "H", map = 1411, x = 52.20, y = 40.80, max = 75 }, -- Durotar; <Journeyman Engineer>; https://www.wowhead.com/forever/npc=11025; GEMETEN; 1pt; Zygor agrees (52.18,40.79)
  { npc = 1676, name = "Finbus Geargrind", prof = "ENGINEERING", side = "A", map = 1431, x = 77.40, y = 48.40, max = 150 }, -- Duskwood; <Expert Engineer>; https://www.wowhead.com/forever/npc=1676; GEMETEN; 2pt; Zygor agrees (77.38,48.82)
  { npc = 11028, name = "Jemma Quikswitch", prof = "ENGINEERING", side = "A", map = 1455, x = 67.80, y = 44.00, max = 75 }, -- Ironforge; <Journeyman Engineer>; https://www.wowhead.com/forever/npc=11028; GEMETEN; 5pt; not in Zygor
  { npc = 5174, name = "Springspindle Fizzlegear", prof = "ENGINEERING", side = "A", map = 1455, x = 68.60, y = 44.20, max = 225 }, -- Ironforge; <Artisan Engineer>; https://www.wowhead.com/forever/npc=5174; GEMETEN; 5pt; Zygor agrees (68.45,43.54)
  { npc = 7944, name = "Tinkmaster Overspark", prof = "ENGINEERING", spec = "GNOMISH", side = "A", map = 1455, x = 69.60, y = 50.60, max = nil, recipesOnly = true }, -- Ironforge; <Master Gnome Engineer>; https://www.wowhead.com/forever/npc=7944; GEMETEN; spec from tag AFGELEID; 7pt; recipes only (9); Zygor agrees (69.54,50.32)
  { npc = 11029, name = "Trixie Quikswitch", prof = "ENGINEERING", side = "A", map = 1455, x = 67.80, y = 43.20, max = 150 }, -- Ironforge; <Expert Engineer>; https://www.wowhead.com/forever/npc=11029; GEMETEN; 3pt; not in Zygor
  { npc = 3290, name = "Deek Fizzlebizz", prof = "ENGINEERING", side = "A", map = 1432, x = 45.80, y = 13.40, max = 75 }, -- Loch Modan; <Journeyman Engineer>; https://www.wowhead.com/forever/npc=3290; GEMETEN; 2pt; Zygor agrees (45.91,13.44)
  { npc = 249235, name = "Kaylaena Springwhisper", prof = "ENGINEERING", side = nil, map = 2482, x = 60.20, y = 61.40, max = 300 }, -- Mount Hyjal; <Cenarion Circle>; https://www.wowhead.com/forever/npc=249235; GEMETEN; 1pt; prof from Teaches tab; no react on Wowhead [null,null]; not in Zygor
  { npc = 10993, name = "Twizwick Sprocketgrind", prof = "ENGINEERING", side = "H", map = 1412, x = 58.60, y = 39.40, max = 75 }, -- Mulgore; <Journeyman Engineer>; https://www.wowhead.com/forever/npc=10993; GEMETEN; 2pt; classic-frame pts dropped; Zygor agrees (58.64,39.37), Zygor side both
  { npc = 3412, name = "Nogg", prof = "ENGINEERING", side = "H", map = 1454, x = 75.40, y = 24.80, max = 150 }, -- Orgrimmar; <Expert Engineer>; https://www.wowhead.com/forever/npc=3412; GEMETEN; 2pt; not in Zygor
  { npc = 11017, name = "Roxxik", prof = "ENGINEERING", side = "H", map = 1454, x = 75.40, y = 24.80, max = 225 }, -- Orgrimmar; <Artisan Engineer>; https://www.wowhead.com/forever/npc=11017; GEMETEN; 2pt; Zygor agrees (76.17,25.17)
  { npc = 2857, name = "Thund", prof = "ENGINEERING", side = "H", map = 1454, x = 75.80, y = 24.40, max = 75 }, -- Orgrimmar; <Journeyman Engineer>; https://www.wowhead.com/forever/npc=2857; GEMETEN; 4pt; not in Zygor
  { npc = 260562, name = "Melbin Powderfuse", prof = "ENGINEERING", spec = "GOBLIN", side = "both", map = 2548, x = 77.60, y = 50.80, max = nil, recipesOnly = true }, -- Riverglades; <Master Goblin Engineer>; https://www.wowhead.com/forever/npc=260562; GEMETEN; spec from tag AFGELEID; 1pt; recipes only (9); react [0,0], neutral counted usable (AFGELEID); not in Zygor
  { npc = 5518, name = "Lilliam Sparkspindle", prof = "ENGINEERING", side = "A", map = 1453, x = 62.00, y = 30.60, max = 150 }, -- Stormwind City; <Expert Engineer>; https://www.wowhead.com/forever/npc=5518; GEMETEN; 2pt; classic-frame pts dropped; Zygor agrees (62.09,30.31)
  { npc = 11026, name = "Sprite Jumpsprocket", prof = "ENGINEERING", side = "A", map = 1453, x = 61.80, y = 30.80, max = 75 }, -- Stormwind City; <Journeyman Engineer>; https://www.wowhead.com/forever/npc=11026; GEMETEN; 1pt; classic-frame pts dropped; not in Zygor
  { npc = 7406, name = "Oglethorpe Obnoticus", prof = "ENGINEERING", spec = "GNOMISH", side = "both", map = 1434, x = 28.20, y = 76.20, max = nil, recipesOnly = true }, -- Stranglethorn Vale; <Master Gnome Engineer>; https://www.wowhead.com/forever/npc=7406; GEMETEN; spec from tag AFGELEID; 1pt; recipes only (9); Zygor agrees (28.35,76.35)
  { npc = 8736, name = "Buzzek Bracketswing", prof = "ENGINEERING", side = "both", map = 1446, x = 52.20, y = 27.40, max = 300 }, -- Tanaris; <Master Engineer>; https://www.wowhead.com/forever/npc=8736; GEMETEN; 2pt; react [0,0], neutral counted usable (AFGELEID); Zygor agrees (52.33,27.72)
  { npc = 8126, name = "Nixx Sprocketspring", prof = "ENGINEERING", spec = "GOBLIN", side = "both", map = 1446, x = 52.40, y = 27.20, max = nil, recipesOnly = true }, -- Tanaris; <Master Goblin Engineer>; https://www.wowhead.com/forever/npc=8126; GEMETEN; spec from tag AFGELEID; 1pt; recipes only (9); react [0,0], neutral counted usable (AFGELEID); Zygor agrees (52.47,27.32)
  { npc = 3494, name = "Tinkerwiz", prof = "ENGINEERING", side = "both", map = 1413, x = 62.60, y = 36.20, max = 75 }, -- The Barrens; <Journeyman Engineer>; https://www.wowhead.com/forever/npc=3494; GEMETEN; 1pt; Zygor agrees (62.66,36.31)
  { npc = 8738, name = "Vazario Linkgrease", prof = "ENGINEERING", spec = "GOBLIN", side = "both", map = 1413, x = 62.60, y = 36.20, max = nil, recipesOnly = true }, -- The Barrens; <Master Goblin Engineer>; https://www.wowhead.com/forever/npc=8738; GEMETEN; spec from tag AFGELEID; 1pt; recipes only (9); Zygor agrees (62.69,36.25)
  { npc = 11031, name = "Franklin Lloyd", prof = "ENGINEERING", side = "H", map = 1458, x = 76.00, y = 73.80, max = 150 }, -- Undercity; <Expert Engineer>; https://www.wowhead.com/forever/npc=11031; GEMETEN; 8pt; Zygor agrees (76.12,74.02)
  { npc = 4586, name = "Graham Van Talen", prof = "ENGINEERING", side = "H", map = 1458, x = 75.40, y = 73.60, max = 75 }, -- Undercity; <Journeyman Engineer>; https://www.wowhead.com/forever/npc=4586; GEMETEN; 7pt; not in Zygor
  { npc = 251684, name = "Strange Hermit", prof = "ENGINEERING", side = "both", map = 2521, x = 54.00, y = 39.00, max = 75 }, -- Zephras Isle; <>; https://www.wowhead.com/forever/npc=251684; GEMETEN; 1pt; prof from Teaches tab; Zygor agrees (53.96,38.9)
  -- HERBALISM (30)
  { npc = 275321, name = "Edward Egan", prof = "HERBALISM", side = "A", map = 1416, x = 18.40, y = 63.20, max = 300 }, -- Alterac Mountains; <Herbalist>; https://www.wowhead.com/forever/npc=275321; GEMETEN; 2pt; not in Zygor
  { npc = 3965, name = "Cylania Rootstalker", prof = "HERBALISM", side = "A", map = 1440, x = 50.40, y = 67.00, max = 300 }, -- Ashenvale; <Herbalist>; https://www.wowhead.com/forever/npc=3965; GEMETEN; 2pt; Zygor agrees (50.68,67.17)
  { npc = 4204, name = "Firodren Mooncaller", prof = "HERBALISM", side = "A", map = 1457, x = 48.00, y = 68.40, max = 300 }, -- Darnassus; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=4204; GEMETEN; 2pt; Zygor agrees (47.94,68.02)
  { npc = 267338, name = "Emrys Flintbeard", prof = "HERBALISM", side = "A", map = 1426, x = 28.80, y = 66.40, max = 75 }, -- Dun Morogh; <Junior Herbalism Trainer>; https://www.wowhead.com/forever/npc=267338; GEMETEN; 2pt; Zygor agrees (28.8,66.5)
  { npc = 3185, name = "Mishiki", prof = "HERBALISM", side = "H", map = 1411, x = 55.40, y = 75.00, max = 300 }, -- Durotar; <Herbalist>; https://www.wowhead.com/forever/npc=3185; GEMETEN; 2pt; Zygor agrees (55.44,75.08)
  { npc = 267329, name = "Zor'la", prof = "HERBALISM", side = "H", map = 1411, x = 42.60, y = 67.40, max = 75 }, -- Durotar; <Junior Herbalism Trainer>; https://www.wowhead.com/forever/npc=267329; GEMETEN; 1pt; Zygor agrees (42.7,67.5)
  { npc = 4898, name = "Brant Jasperbloom", prof = "HERBALISM", side = "A", map = 1445, x = 64.00, y = 47.60, max = 300 }, -- Dustwallow Marsh; <Herbalist>; https://www.wowhead.com/forever/npc=4898; GEMETEN; 1pt; Zygor agrees (64,47.53)
  { npc = 1218, name = "Herbalist Pomeroy", prof = "HERBALISM", side = "A", map = 1429, x = 39.80, y = 48.40, max = 300 }, -- Elwynn Forest; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=1218; GEMETEN; 1pt; Zygor agrees (39.95,48.4)
  { npc = 247223, name = "Nancy Songflower", prof = "HERBALISM", side = "A", map = 1429, x = 52.40, y = 43.80, max = 75 }, -- Elwynn Forest; <Junior Herbalism Trainer>; https://www.wowhead.com/forever/npc=247223; GEMETEN; 3pt; Zygor agrees (52.45,43.69)
  { npc = 8146, name = "Ruw", prof = "HERBALISM", side = "H", map = 1444, x = 76.00, y = 43.40, max = 300 }, -- Feralas; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=8146; GEMETEN; 1pt; Zygor agrees (75.97,43.33)
  { npc = 2390, name = "Aranae Venomblood", prof = "HERBALISM", side = "H", map = 1424, x = 61.60, y = 19.60, max = 300 }, -- Hillsbrad Foothills; <Herbalist>; https://www.wowhead.com/forever/npc=2390; GEMETEN; 3pt; Zygor agrees (61.71,19.51)
  { npc = 5137, name = "Reyna Stonebranch", prof = "HERBALISM", side = "A", map = 1455, x = 55.60, y = 58.80, max = 300 }, -- Ironforge; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=5137; GEMETEN; 5pt; Zygor agrees (55.89,59.13)
  { npc = 1473, name = "Kali Healtouch", prof = "HERBALISM", side = "A", map = 1432, x = 36.40, y = 48.40, max = 300 }, -- Loch Modan; <Herbalist>; https://www.wowhead.com/forever/npc=1473; GEMETEN; 2pt; Zygor agrees (36.47,48.54)
  { npc = 12025, name = "Malvor", prof = "HERBALISM", side = "both", map = 1450, x = 45.40, y = 47.00, max = 300 }, -- Moonglade; <Herbalist>; https://www.wowhead.com/forever/npc=12025; GEMETEN; 2pt; Zygor agrees (45.41,46.96)
  { npc = 267332, name = "Garan Sunstrider", prof = "HERBALISM", side = "H", map = 1412, x = 44.20, y = 77.80, max = 75 }, -- Mulgore; <Junior Herbalism Trainer>; https://www.wowhead.com/forever/npc=267332; GEMETEN; 1pt; one frame only, NPC new in 16001 -> Forever frame (AFGELEID); Zygor agrees (44.2,77.8)
  { npc = 3404, name = "Jandi", prof = "HERBALISM", side = "H", map = 1454, x = 55.40, y = 39.40, max = 300 }, -- Orgrimmar; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=3404; GEMETEN; 4pt; Zygor agrees (55.61,39.46)
  { npc = 812, name = "Alma Jainrose", prof = "HERBALISM", side = "A", map = 1433, x = 16.20, y = 45.60, max = 300 }, -- Redridge Mountains; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=812; GEMETEN; 2pt; classic-frame pts dropped; Zygor DIFFERS by 5.5 (21.68,45.77) = Classic frame (open item 1)
  { npc = 5502, name = "Shylamiir", prof = "HERBALISM", side = "A", map = 1453, x = 31.40, y = 63.00, max = 300 }, -- Stormwind City; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=5502; GEMETEN; 2pt; classic-frame pts dropped; Zygor agrees (31.5,62.6)
  { npc = 5566, name = "Tannysa", prof = "HERBALISM", side = "A", map = 1453, x = 54.40, y = 84.00, max = 300 }, -- Stormwind City; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=5566; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (54.29,84.1)
  { npc = 2856, name = "Angrun", prof = "HERBALISM", side = "H", map = 1434, x = 32.20, y = 27.40, max = 300 }, -- Stranglethorn Vale; <Superior Herbalist>; https://www.wowhead.com/forever/npc=2856; GEMETEN; 2pt; Zygor agrees (32.24,27.42)
  { npc = 908, name = "Flora Silverwind", prof = "HERBALISM", side = "both", map = 1434, x = 27.60, y = 77.80, max = 300 }, -- Stranglethorn Vale; <Superior Herbalist>; https://www.wowhead.com/forever/npc=908; GEMETEN; 1pt; Zygor agrees (27.72,77.86)
  { npc = 267335, name = "Eleyna Duskbreeze", prof = "HERBALISM", side = "A", map = 1438, x = 59.80, y = 41.40, max = 75 }, -- Teldrassil; <Junior Herbalism Trainer>; https://www.wowhead.com/forever/npc=267335; GEMETEN; 2pt; Zygor agrees (59.8,41.5)
  { npc = 3604, name = "Malorne Bladeleaf", prof = "HERBALISM", side = "A", map = 1438, x = 57.40, y = 60.60, max = 300 }, -- Teldrassil; <Herbalist>; https://www.wowhead.com/forever/npc=3604; GEMETEN; 2pt; Zygor agrees (57.72,60.64)
  { npc = 3013, name = "Komin Winterhoof", prof = "HERBALISM", side = "H", map = 1456, x = 49.80, y = 39.40, max = 300 }, -- Thunder Bluff; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=3013; GEMETEN; 3pt; Zygor agrees (49.95,40.4)
  { npc = 2114, name = "Faruza", prof = "HERBALISM", side = "H", map = 1420, x = 59.80, y = 52.00, max = 300 }, -- Tirisfal Glades; <Apprentice Herbalist>; https://www.wowhead.com/forever/npc=2114; GEMETEN; 1pt; Zygor agrees (59.78,52.12)
  { npc = 267326, name = "Florence Nightshade", prof = "HERBALISM", side = "H", map = 1420, x = 32.40, y = 65.20, max = 75 }, -- Tirisfal Glades; <Junior Herbalism Trainer>; https://www.wowhead.com/forever/npc=267326; GEMETEN; 1pt; Zygor agrees (32.4,65.2)
  { npc = 4614, name = "Martha Alliestar", prof = "HERBALISM", side = "H", map = 1458, x = 54.60, y = 50.40, max = 300 }, -- Undercity; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=4614; GEMETEN; 6pt; Zygor agrees (54,49.54)
  { npc = 1458, name = "Telurinon Moonshadow", prof = "HERBALISM", side = "A", map = 1437, x = 8.00, y = 55.80, max = 300 }, -- Wetlands; <Herbalism Trainer>; https://www.wowhead.com/forever/npc=1458; GEMETEN; 1pt; Zygor agrees (7.98,55.84)
  { npc = 257021, name = "Halassa Fernbreeze", prof = "HERBALISM", side = "both", map = 2521, x = 43.00, y = 43.40, max = 300 }, -- Zephras Isle; <Herbalist>; https://www.wowhead.com/forever/npc=257021; GEMETEN; 2pt; Zygor agrees (42.96,43.53)
  { npc = 254345, name = "Syriel Nightrain", prof = "HERBALISM", side = "both", map = 2521, x = 57.80, y = 75.40, max = 300 }, -- Zephras Isle; <Herbalist>; https://www.wowhead.com/forever/npc=254345; GEMETEN; 1pt; Zygor agrees (57.88,75.53)
  -- LEATHERWORKING (33)
  { npc = 7869, name = "Brumn Winterhoof", prof = "LEATHERWORKING", spec = "ELEMENTAL", side = "H", map = 1417, x = 28.20, y = 45.00, max = nil }, -- Arathi Highlands; <Master Elemental Leatherworker>; https://www.wowhead.com/forever/npc=7869; GEMETEN; spec from tag AFGELEID; 1pt; no Teaches tab on Wowhead; Zygor agrees (28.26,45.08)
  { npc = 3967, name = "Aayndia Floralwind", prof = "LEATHERWORKING", side = "A", map = 1440, x = 35.80, y = 52.00, max = 150 }, -- Ashenvale; <Expert Leatherworker>; https://www.wowhead.com/forever/npc=3967; GEMETEN; 1pt; Zygor agrees (35.97,52.1)
  { npc = 7866, name = "Peter Galen", prof = "LEATHERWORKING", spec = "DRAGONSCALE", side = "A", map = 1447, x = 37.40, y = 65.40, max = nil }, -- Azshara; <Master Dragonscale Leatherworker>; https://www.wowhead.com/forever/npc=7866; GEMETEN; spec from tag AFGELEID; 3pt; no Teaches tab on Wowhead; Zygor agrees (37.58,65.41)
  { npc = 7867, name = "Thorkaf Dragoneye", prof = "LEATHERWORKING", spec = "DRAGONSCALE", side = "H", map = 1418, x = 62.40, y = 57.40, max = nil, recipesOnly = true }, -- Badlands; <Master Dragonscale Leatherworker>; https://www.wowhead.com/forever/npc=7867; GEMETEN; spec from tag AFGELEID; 4pt; recipes only (4); Zygor agrees (62.7,57.4)
  { npc = 11083, name = "Darianna", prof = "LEATHERWORKING", side = "A", map = 1457, x = 64.40, y = 21.20, max = 75 }, -- Darnassus; <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=11083; GEMETEN; 4pt; not in Zygor
  { npc = 11081, name = "Faldron", prof = "LEATHERWORKING", side = "A", map = 1457, x = 64.40, y = 21.40, max = 150 }, -- Darnassus; <Expert Leatherworker>; https://www.wowhead.com/forever/npc=11081; GEMETEN; 4pt; not in Zygor
  { npc = 4212, name = "Telonis", prof = "LEATHERWORKING", side = "A", map = 1457, x = 64.40, y = 21.40, max = 225 }, -- Darnassus; <Artisan Leatherworker>; https://www.wowhead.com/forever/npc=4212; GEMETEN; 4pt; Zygor agrees (64.42,21.53)
  { npc = 8153, name = "Narv Hidecrafter", prof = "LEATHERWORKING", side = "H", map = 1443, x = 55.20, y = 56.20, max = 150 }, -- Desolace; <Expert Leathercrafter>; https://www.wowhead.com/forever/npc=8153; GEMETEN; 1pt; Zygor agrees (55.24,56.33)
  { npc = 1632, name = "Adele Fielder", prof = "LEATHERWORKING", side = "A", map = 1429, x = 46.40, y = 62.20, max = 75 }, -- Elwynn Forest; <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=1632; GEMETEN; 2pt; Zygor agrees (46.38,62.04)
  { npc = 7870, name = "Caryssia Moonhunter", prof = "LEATHERWORKING", spec = "TRIBAL", side = "A", map = 1444, x = 89.40, y = 46.40, max = nil }, -- Feralas; <Tribal Leatherworking Trainer>; https://www.wowhead.com/forever/npc=7870; GEMETEN; spec from tag AFGELEID; 2pt; no Teaches tab on Wowhead; Zygor agrees (89.41,46.55)
  { npc = 11098, name = "Hahrana Ironhide", prof = "LEATHERWORKING", side = "H", map = 1444, x = 74.40, y = 43.00, max = 300 }, -- Feralas; <Master Leatherworker>; https://www.wowhead.com/forever/npc=11098; GEMETEN; 1pt; Zygor agrees (74.36,43.11)
  { npc = 5127, name = "Fimble Finespindle", prof = "LEATHERWORKING", side = "A", map = 1455, x = 39.80, y = 33.40, max = 150 }, -- Ironforge; <Expert Leatherworker>; https://www.wowhead.com/forever/npc=5127; GEMETEN; 6pt; Zygor agrees (40.23,33.67)
  { npc = 1466, name = "Gretta Finespindle", prof = "LEATHERWORKING", side = "A", map = 1455, x = 39.00, y = 32.80, max = 75 }, -- Ironforge; <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=1466; GEMETEN; 4pt; not in Zygor
  { npc = 5784, name = "Waldor", prof = "LEATHERWORKING", side = "both", map = 1414, x = 51.80, y = 55.40, max = 75 }, -- Kalimdor (continent map); <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=5784; GEMETEN; 1pt; continent coords only (open item 4); not in Zygor
  { npc = 3069, name = "Chaw Stronghide", prof = "LEATHERWORKING", side = "H", map = 1412, x = 45.00, y = 61.40, max = 75 }, -- Mulgore; <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=3069; GEMETEN; 2pt; classic-frame pts dropped; Zygor agrees (44.93,61.46)
  { npc = 5811, name = "Kamari", prof = "LEATHERWORKING", side = "H", map = 1454, x = 63.00, y = 45.00, max = 75 }, -- Orgrimmar; <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=5811; GEMETEN; 2pt; not in Zygor
  { npc = 3365, name = "Karolek", prof = "LEATHERWORKING", side = "H", map = 1454, x = 62.80, y = 44.40, max = 150 }, -- Orgrimmar; <Expert Leatherworker>; https://www.wowhead.com/forever/npc=3365; GEMETEN; 2pt; Zygor agrees (62.8,44.14)
  { npc = 7868, name = "Sarah Tanner", prof = "LEATHERWORKING", spec = "ELEMENTAL", side = "A", map = 1427, x = 63.60, y = 75.80, max = nil }, -- Searing Gorge; <Master Elemental Leatherworker>; https://www.wowhead.com/forever/npc=7868; GEMETEN; spec from tag AFGELEID; 4pt; no Teaches tab on Wowhead; Zygor agrees (63.55,75.97)
  { npc = 11096, name = "Randal Worth", prof = "LEATHERWORKING", side = "A", map = 1453, x = 72.00, y = 62.60, max = 75 }, -- Stormwind City; <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=11096; GEMETEN; 2pt; classic-frame pts dropped; not in Zygor
  { npc = 5564, name = "Simon Tanner", prof = "LEATHERWORKING", side = "A", map = 1453, x = 71.80, y = 62.80, max = 150 }, -- Stormwind City; <Expert Leatherworker>; https://www.wowhead.com/forever/npc=5564; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (71.68,62.99)
  { npc = 1385, name = "Brawn", prof = "LEATHERWORKING", side = "H", map = 1434, x = 31.60, y = 28.80, max = 150 }, -- Stranglethorn Vale; <Expert Leatherworker>; https://www.wowhead.com/forever/npc=1385; GEMETEN; 1pt; Zygor agrees (31.74,28.89)
  { npc = 7871, name = "Se'Jib", prof = "LEATHERWORKING", spec = "TRIBAL", side = "H", map = 1434, x = 36.40, y = 34.00, max = nil }, -- Stranglethorn Vale; <Master Tribal Leatherworker>; https://www.wowhead.com/forever/npc=7871; GEMETEN; spec from tag AFGELEID; 2pt; no Teaches tab on Wowhead; Zygor agrees (36.54,34.08)
  { npc = 3605, name = "Nadyia Maneweaver", prof = "LEATHERWORKING", side = "A", map = 1438, x = 41.80, y = 49.40, max = 75 }, -- Teldrassil; <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=3605; GEMETEN; 2pt; Zygor agrees (41.87,49.44)
  { npc = 3703, name = "Krulmoo Fullmoon", prof = "LEATHERWORKING", side = "H", map = 1413, x = 44.80, y = 59.40, max = 150 }, -- The Barrens; <Expert Leatherworker>; https://www.wowhead.com/forever/npc=3703; GEMETEN; 1pt; Zygor agrees (44.84,59.45)
  { npc = 11097, name = "Drakk Stonehand", prof = "LEATHERWORKING", side = "A", map = 1425, x = 13.40, y = 43.40, max = 300 }, -- The Hinterlands; <Master Leatherworking Trainer>; https://www.wowhead.com/forever/npc=11097; GEMETEN; 1pt; Zygor agrees (13.38,43.49), Zygor side both
  { npc = 3008, name = "Mak", prof = "LEATHERWORKING", side = "H", map = 1456, x = 42.20, y = 43.20, max = 75 }, -- Thunder Bluff; <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=3008; GEMETEN; 3pt; not in Zygor
  { npc = 11084, name = "Tarn", prof = "LEATHERWORKING", side = "H", map = 1456, x = 42.40, y = 43.00, max = 150 }, -- Thunder Bluff; <Expert Leatherworker>; https://www.wowhead.com/forever/npc=11084; GEMETEN; 2pt; not in Zygor
  { npc = 3007, name = "Una", prof = "LEATHERWORKING", side = "H", map = 1456, x = 41.60, y = 42.40, max = 225 }, -- Thunder Bluff; <Artisan Leatherworker>; https://www.wowhead.com/forever/npc=3007; GEMETEN; 3pt; Zygor agrees (41.5,42.56)
  { npc = 3549, name = "Shelene Rhobart", prof = "LEATHERWORKING", side = "H", map = 1420, x = 65.40, y = 60.00, max = 75 }, -- Tirisfal Glades; <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=3549; GEMETEN; 1pt; Zygor agrees (65.42,60.12)
  { npc = 4588, name = "Arthur Moore", prof = "LEATHERWORKING", side = "H", map = 1458, x = 70.40, y = 57.80, max = 150 }, -- Undercity; <Expert Leatherworker>; https://www.wowhead.com/forever/npc=4588; GEMETEN; 5pt; Zygor agrees (70.17,57.42)
  { npc = 223, name = "Dan Golthas", prof = "LEATHERWORKING", side = "H", map = 1458, x = 70.60, y = 58.60, max = 75 }, -- Undercity; <Journeyman Leatherworker>; https://www.wowhead.com/forever/npc=223; GEMETEN; 5pt; not in Zygor
  { npc = 252376, name = "Emerii Tallgust", prof = "LEATHERWORKING", side = "both", map = 2521, x = 63.80, y = 80.40, max = 150 }, -- Zephras Isle; <Leatherworker>; https://www.wowhead.com/forever/npc=252376; GEMETEN; 2pt; Zygor agrees (63.73,80.68)
  { npc = 251993, name = "Indari Sunseam", prof = "LEATHERWORKING", side = "both", map = 2521, x = 44.60, y = 44.40, max = 75 }, -- Zephras Isle; <Leatherworker>; https://www.wowhead.com/forever/npc=251993; GEMETEN; 2pt; Zygor agrees (44.68,44.52)
  -- MINING (22)
  { npc = 6297, name = "Kurdram Stonehammer", prof = "MINING", side = "A", map = 1439, x = 38.20, y = 41.00, max = 300 }, -- Darkshore; <Mining Trainer>; https://www.wowhead.com/forever/npc=6297; GEMETEN; 1pt; Zygor agrees (38.24,41)
  { npc = 1701, name = "Dank Drizzlecut", prof = "MINING", side = "A", map = 1426, x = 69.20, y = 55.40, max = 300 }, -- Dun Morogh; <Mining Trainer>; https://www.wowhead.com/forever/npc=1701; GEMETEN; 2pt; Zygor agrees (69.32,55.45)
  { npc = 267337, name = "Sally Swiftwrench", prof = "MINING", side = "A", map = 1426, x = 28.80, y = 67.80, max = 75 }, -- Dun Morogh; <Junior Mining Trainer>; https://www.wowhead.com/forever/npc=267337; GEMETEN; 1pt; Zygor agrees (28.8,67.8)
  { npc = 5392, name = "Yarr Hammerstone", prof = "MINING", side = "A", map = 1426, x = 50.00, y = 50.20, max = 300 }, -- Dun Morogh; <Mining Trainer>; https://www.wowhead.com/forever/npc=5392; GEMETEN; 1pt; Zygor agrees (50,50.3)
  { npc = 3175, name = "Krunn", prof = "MINING", side = "H", map = 1411, x = 51.80, y = 40.80, max = 300 }, -- Durotar; <Miner>; https://www.wowhead.com/forever/npc=3175; GEMETEN; 1pt; Zygor agrees (51.81,40.88)
  { npc = 267328, name = "Norzsh", prof = "MINING", side = "H", map = 1411, x = 40.40, y = 68.00, max = 75 }, -- Durotar; <Junior Mining Trainer>; https://www.wowhead.com/forever/npc=267328; GEMETEN; 2pt; Zygor agrees (40.5,68)
  { npc = 3137, name = "Matt Johnson", prof = "MINING", side = "A", map = 1431, x = 74.00, y = 49.40, max = 300 }, -- Duskwood; <Mining Trainer>; https://www.wowhead.com/forever/npc=3137; GEMETEN; 2pt; Zygor agrees (74.06,49.63)
  { npc = 247226, name = "Kelsey Fargo", prof = "MINING", side = "A", map = 1429, x = 47.20, y = 32.20, max = 75 }, -- Elwynn Forest; <Junior Mining Trainer>; https://www.wowhead.com/forever/npc=247226; GEMETEN; 2pt; Zygor agrees (47.2,32.4)
  { npc = 4254, name = "Geofram Bouldertoe", prof = "MINING", side = "A", map = 1455, x = 50.20, y = 26.60, max = 300 }, -- Ironforge; <Mining Trainer>; https://www.wowhead.com/forever/npc=4254; GEMETEN; 4pt; Zygor agrees (50,26.29)
  { npc = 1681, name = "Brock Stoneseeker", prof = "MINING", side = "A", map = 1432, x = 37.00, y = 47.80, max = 300 }, -- Loch Modan; <Mining Trainer>; https://www.wowhead.com/forever/npc=1681; GEMETEN; 2pt; Zygor agrees (37.01,47.8)
  { npc = 267331, name = "Vartha Rockmane", prof = "MINING", side = "H", map = 1412, x = 44.20, y = 78.20, max = 75 }, -- Mulgore; <Junior Mining Trainer>; https://www.wowhead.com/forever/npc=267331; GEMETEN; 1pt; one frame only, NPC new in 16001 -> Forever frame (AFGELEID); Zygor agrees (44.2,78.2)
  { npc = 3357, name = "Makaru", prof = "MINING", side = "H", map = 1454, x = 73.00, y = 26.40, max = 300 }, -- Orgrimmar; <Mining Trainer>; https://www.wowhead.com/forever/npc=3357; GEMETEN; 2pt; Zygor agrees (73.11,26.08)
  { npc = 255891, name = "Grungle", prof = "MINING", side = "both", map = 2548, x = 77.60, y = 51.80, max = 300 }, -- Riverglades; <Miner>; https://www.wowhead.com/forever/npc=255891; GEMETEN; 1pt; react [0,0], neutral counted usable (AFGELEID); not in Zygor
  { npc = 3555, name = "Johan Focht", prof = "MINING", side = "H", map = 1421, x = 43.40, y = 40.40, max = 300 }, -- Silverpine Forest; <Miner>; https://www.wowhead.com/forever/npc=3555; GEMETEN; 2pt; Zygor agrees (43.4,40.45)
  { npc = 5513, name = "Gelman Stonehand", prof = "MINING", side = "A", map = 1453, x = 59.00, y = 37.80, max = 300 }, -- Stormwind City; <Mining Trainer>; https://www.wowhead.com/forever/npc=5513; GEMETEN; 1pt; tab also lists BLACKSMITHING rank<=75; classic-frame pts dropped; Zygor agrees (59.29,37.82)
  { npc = 8128, name = "Pikkle", prof = "MINING", side = "both", map = 1446, x = 51.00, y = 28.00, max = 300 }, -- Tanaris; <Miner>; https://www.wowhead.com/forever/npc=8128; GEMETEN; 1pt; react [0,0], neutral counted usable (AFGELEID); Zygor agrees (51.07,28.1)
  { npc = 267334, name = "Fanorran Stilloak", prof = "MINING", side = "A", map = 1438, x = 58.20, y = 41.40, max = 75 }, -- Teldrassil; <Junior Mining Trainer>; https://www.wowhead.com/forever/npc=267334; GEMETEN; 2pt; Zygor agrees (58.2,41.5)
  { npc = 3001, name = "Brek Stonehoof", prof = "MINING", side = "H", map = 1456, x = 34.40, y = 57.40, max = 300 }, -- Thunder Bluff; <Mining Trainer>; https://www.wowhead.com/forever/npc=3001; GEMETEN; 4pt; Zygor agrees (34.36,57.9)
  { npc = 267325, name = "Walter Mason", prof = "MINING", side = "H", map = 1420, x = 32.20, y = 65.40, max = 75 }, -- Tirisfal Glades; <Junior Mining Trainer>; https://www.wowhead.com/forever/npc=267325; GEMETEN; 2pt; Zygor agrees (32.2,65.5)
  { npc = 4598, name = "Brom Killian", prof = "MINING", side = "H", map = 1458, x = 55.40, y = 36.20, max = 300 }, -- Undercity; <Mining Trainer>; https://www.wowhead.com/forever/npc=4598; GEMETEN; 3pt; Zygor agrees (56.03,37.45)
  { npc = 252388, name = "Halavuul Cragwind", prof = "MINING", side = "both", map = 2521, x = 65.40, y = 80.40, max = 300 }, -- Zephras Isle; <Mining Trainer>; https://www.wowhead.com/forever/npc=252388; GEMETEN; 1pt; Zygor agrees (65.4,80.4)
  { npc = 257022, name = "Messana Crestwind", prof = "MINING", side = "both", map = 2521, x = 44.60, y = 44.60, max = 300 }, -- Zephras Isle; <Miner>; https://www.wowhead.com/forever/npc=257022; GEMETEN; 2pt; Zygor agrees (44.77,44.55)
  -- SKINNING (23)
  { npc = 6288, name = "Jayla", prof = "SKINNING", side = "A", map = 1440, x = 50.00, y = 67.20, max = 300 }, -- Ashenvale; <Skinner>; https://www.wowhead.com/forever/npc=6288; GEMETEN; 1pt; Zygor agrees (49.97,67.28)
  { npc = 6292, name = "Eladriel", prof = "SKINNING", side = "A", map = 1457, x = 64.40, y = 21.20, max = 300 }, -- Darnassus; <Skinning Trainer>; https://www.wowhead.com/forever/npc=6292; GEMETEN; 3pt; Zygor agrees (64.13,22.26)
  { npc = 12030, name = "Malux", prof = "SKINNING", side = "H", map = 1443, x = 23.20, y = 69.80, max = 300 }, -- Desolace; <Skinning Trainer>; https://www.wowhead.com/forever/npc=12030; GEMETEN; 1pt; Zygor agrees (23.23,69.71)
  { npc = 267336, name = "Brighid Stormflayer", prof = "SKINNING", side = "A", map = 1426, x = 29.00, y = 67.40, max = 75 }, -- Dun Morogh; <Junior Skinning Trainer>; https://www.wowhead.com/forever/npc=267336; GEMETEN; 2pt; Zygor agrees (29.1,67.5)
  { npc = 267327, name = "Kagil", prof = "SKINNING", side = "H", map = 1411, x = 40.80, y = 67.80, max = 75 }, -- Durotar; <Junior Skinning Trainer>; https://www.wowhead.com/forever/npc=267327; GEMETEN; 1pt; Zygor agrees (40.8,67.8)
  { npc = 6306, name = "Helene Peltskinner", prof = "SKINNING", side = "A", map = 1429, x = 46.20, y = 62.20, max = 300 }, -- Elwynn Forest; <Skinner>; https://www.wowhead.com/forever/npc=6306; GEMETEN; 1pt; Zygor agrees (46.24,62.24)
  { npc = 247227, name = "Riley Peltskinner", prof = "SKINNING", side = "A", map = 1429, x = 47.00, y = 39.80, max = 75 }, -- Elwynn Forest; <Junior Skinning Trainer>; https://www.wowhead.com/forever/npc=247227; GEMETEN; 1pt; Zygor agrees (47,39.8)
  { npc = 8144, name = "Kulleg Stonehorn", prof = "SKINNING", side = "H", map = 1444, x = 74.40, y = 43.00, max = 300 }, -- Feralas; <Skinning Trainer>; https://www.wowhead.com/forever/npc=8144; GEMETEN; 2pt; Zygor agrees (74.46,43.04)
  { npc = 6291, name = "Balthus Stoneflayer", prof = "SKINNING", side = "A", map = 1455, x = 39.40, y = 32.40, max = 300 }, -- Ironforge; <Skinning Trainer>; https://www.wowhead.com/forever/npc=6291; GEMETEN; 4pt; Zygor agrees (39.86,32.49)
  { npc = 267330, name = "Nawka Wildsong", prof = "SKINNING", side = "H", map = 1412, x = 44.40, y = 76.80, max = 75 }, -- Mulgore; <Junior Skinning Trainer>; https://www.wowhead.com/forever/npc=267330; GEMETEN; 2pt; one frame only, NPC new in 16001 -> Forever frame (AFGELEID); Zygor agrees (44.5,76.8)
  { npc = 6290, name = "Yonn Deepcut", prof = "SKINNING", side = "H", map = 1412, x = 45.00, y = 61.40, max = 300 }, -- Mulgore; <Skinner>; https://www.wowhead.com/forever/npc=6290; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (44.97,61.39)
  { npc = 7088, name = "Thuwd", prof = "SKINNING", side = "H", map = 1454, x = 63.20, y = 45.20, max = 300 }, -- Orgrimmar; <Skinning Trainer>; https://www.wowhead.com/forever/npc=7088; GEMETEN; 2pt; tab also lists LEATHERWORKING rank<=75; Zygor agrees (63.35,45.41)
  { npc = 6295, name = "Wilma Ranthal", prof = "SKINNING", side = "A", map = 1433, x = 83.60, y = 71.00, max = 300 }, -- Redridge Mountains; <Skinning Trainer>; https://www.wowhead.com/forever/npc=6295; GEMETEN; 1pt; classic-frame pts dropped; Zygor DIFFERS by 5.2 (88.83,71.29) = Classic frame (open item 1)
  { npc = 1292, name = "Maris Granger", prof = "SKINNING", side = "A", map = 1453, x = 72.00, y = 62.40, max = 300 }, -- Stormwind City; <Skinning Trainer>; https://www.wowhead.com/forever/npc=1292; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (72.14,62.2)
  { npc = 6287, name = "Radnaal Maneweaver", prof = "SKINNING", side = "A", map = 1438, x = 42.00, y = 50.00, max = 300 }, -- Teldrassil; <Skinner>; https://www.wowhead.com/forever/npc=6287; GEMETEN; 1pt; Zygor agrees (42.09,49.96)
  { npc = 267333, name = "Terunne Bearshaper", prof = "SKINNING", side = "A", map = 1438, x = 59.40, y = 38.60, max = 75 }, -- Teldrassil; <Junior Skinning Trainer>; https://www.wowhead.com/forever/npc=267333; GEMETEN; 1pt; Zygor agrees (59.4,38.6)
  { npc = 6387, name = "Dranh", prof = "SKINNING", side = "H", map = 1413, x = 45.00, y = 59.00, max = 300 }, -- The Barrens; <Skinner>; https://www.wowhead.com/forever/npc=6387; GEMETEN; 1pt; Zygor agrees (45.07,59.09)
  { npc = 7089, name = "Mooranta", prof = "SKINNING", side = "H", map = 1456, x = 44.40, y = 42.60, max = 300 }, -- Thunder Bluff; <Skinning Trainer>; https://www.wowhead.com/forever/npc=7089; GEMETEN; 5pt; Zygor agrees (44.44,43.15)
  { npc = 267324, name = "Margaret Weaver", prof = "SKINNING", side = "H", map = 1420, x = 32.40, y = 65.60, max = 75 }, -- Tirisfal Glades; <Junior Skinning Trainer>; https://www.wowhead.com/forever/npc=267324; GEMETEN; 2pt; Zygor agrees (32.5,65.59)
  { npc = 6289, name = "Rand Rhobart", prof = "SKINNING", side = "H", map = 1420, x = 65.40, y = 60.00, max = 300 }, -- Tirisfal Glades; <Skinner>; https://www.wowhead.com/forever/npc=6289; GEMETEN; 2pt; Zygor agrees (65.58,60.03)
  { npc = 7087, name = "Killian Hagey", prof = "SKINNING", side = "H", map = 1458, x = 70.40, y = 59.20, max = 300 }, -- Undercity; <Skinning Trainer>; https://www.wowhead.com/forever/npc=7087; GEMETEN; 5pt; Zygor agrees (70.15,59.17)
  { npc = 257003, name = "Ishlee Breezewhisper", prof = "SKINNING", side = "both", map = 2521, x = 59.40, y = 76.00, max = 300 }, -- Zephras Isle; <Skinner>; https://www.wowhead.com/forever/npc=257003; GEMETEN; 2pt; Zygor agrees (59.63,76.06)
  { npc = 257024, name = "Mendalass Tattermend", prof = "SKINNING", side = "both", map = 2521, x = 43.20, y = 43.40, max = 300 }, -- Zephras Isle; <Skinner>; https://www.wowhead.com/forever/npc=257024; GEMETEN; 1pt; Zygor agrees (43.29,43.37)
  -- TAILORING (27)
  { npc = 251972, name = "Charles Worth", prof = "TAILORING", side = "A", map = 1416, x = 17.60, y = 60.20, max = 225 }, -- Alterac Mountains; <Expert Tailor>; https://www.wowhead.com/forever/npc=251972; GEMETEN; 2pt; not in Zygor
  { npc = 4193, name = "Grondal Moonbreeze", prof = "TAILORING", side = "A", map = 1439, x = 38.20, y = 40.40, max = 75 }, -- Darkshore; <Journeyman Tailor>; https://www.wowhead.com/forever/npc=4193; GEMETEN; 2pt; Zygor agrees (38.24,40.53)
  { npc = 4159, name = "Me'lynn", prof = "TAILORING", side = "A", map = 1457, x = 62.60, y = 22.60, max = 150 }, -- Darnassus; <Expert Tailor>; https://www.wowhead.com/forever/npc=4159; GEMETEN; 6pt; Zygor agrees (63.4,22.37)
  { npc = 11050, name = "Trianna", prof = "TAILORING", side = "A", map = 1457, x = 63.40, y = 21.40, max = 75 }, -- Darnassus; <Journeyman Tailor>; https://www.wowhead.com/forever/npc=11050; GEMETEN; 4pt; not in Zygor
  { npc = 11052, name = "Timothy Worthington", prof = "TAILORING", side = "A", map = 1445, x = 66.20, y = 51.60, max = 300 }, -- Dustwallow Marsh; <Master Tailor>; https://www.wowhead.com/forever/npc=11052; GEMETEN; 1pt; Zygor agrees (66.17,51.81)
  { npc = 1103, name = "Eldrin", prof = "TAILORING", side = "A", map = 1429, x = 79.20, y = 69.00, max = 75 }, -- Elwynn Forest; <Journeyman Tailor>; https://www.wowhead.com/forever/npc=1103; GEMETEN; 1pt; Zygor agrees (79.21,69.02)
  { npc = 2399, name = "Daryl Stack", prof = "TAILORING", side = "H", map = 1424, x = 63.40, y = 20.80, max = 300 }, -- Hillsbrad Foothills; <Master Tailor>; https://www.wowhead.com/forever/npc=2399; GEMETEN; 2pt; Zygor agrees (63.74,20.78)
  { npc = 5153, name = "Jormund Stonebrow", prof = "TAILORING", side = "A", map = 1455, x = 43.60, y = 29.00, max = 150 }, -- Ironforge; <Expert Tailor>; https://www.wowhead.com/forever/npc=5153; GEMETEN; 6pt; Zygor agrees (43.14,29.35)
  { npc = 1703, name = "Uthrar Threx", prof = "TAILORING", side = "A", map = 1455, x = 43.60, y = 28.60, max = 75 }, -- Ironforge; <Journeyman Tailor>; https://www.wowhead.com/forever/npc=1703; GEMETEN; 5pt; not in Zygor
  { npc = 3363, name = "Magar", prof = "TAILORING", side = "H", map = 1454, x = 63.40, y = 50.00, max = 150 }, -- Orgrimmar; <Expert Tailor>; https://www.wowhead.com/forever/npc=3363; GEMETEN; 3pt; Zygor agrees (63.64,49.92)
  { npc = 2855, name = "Snang", prof = "TAILORING", side = "H", map = 1454, x = 62.80, y = 49.40, max = 75 }, -- Orgrimmar; <Journeyman Tailor>; https://www.wowhead.com/forever/npc=2855; GEMETEN; 3pt; not in Zygor
  { npc = 1346, name = "Georgio Bolero", prof = "TAILORING", side = "A", map = 1453, x = 53.20, y = 81.40, max = 225 }, -- Stormwind City; <Artisan Tailor>; https://www.wowhead.com/forever/npc=1346; GEMETEN; 2pt; classic-frame pts dropped; Zygor agrees (53.07,81.34)
  { npc = 9584, name = "Jalane Ayrole", prof = "TAILORING", side = "A", map = 1453, x = 40.20, y = 84.40, max = nil, recipesOnly = true }, -- Stormwind City; <Master Shadoweave Tailor>; https://www.wowhead.com/forever/npc=9584; GEMETEN; 2pt; recipes only (5); classic-frame pts dropped; Zygor agrees (40.35,84.61)
  { npc = 1300, name = "Lawrence Schneider", prof = "TAILORING", side = "A", map = 1453, x = 53.40, y = 81.60, max = 225 }, -- Stormwind City; <Journeyman Tailor>; https://www.wowhead.com/forever/npc=1300; GEMETEN; 3pt; classic-frame pts dropped; tag vs Teaches conflict (open item 9); not in Zygor
  { npc = 5567, name = "Sellandus", prof = "TAILORING", side = "A", map = 1453, x = 52.20, y = 83.40, max = 150 }, -- Stormwind City; <Expert Tailor>; https://www.wowhead.com/forever/npc=5567; GEMETEN; 2pt; classic-frame pts dropped; not in Zygor
  { npc = 2627, name = "Grarnik Goodstitch", prof = "TAILORING", side = "both", map = 1434, x = 28.60, y = 76.80, max = 150 }, -- Stranglethorn Vale; <Expert Tailor>; https://www.wowhead.com/forever/npc=2627; GEMETEN; 1pt; Zygor agrees (28.77,76.84)
  { npc = 3484, name = "Kil'hala", prof = "TAILORING", side = "H", map = 1413, x = 52.20, y = 31.60, max = 75 }, -- The Barrens; <Journeyman Tailor>; https://www.wowhead.com/forever/npc=3484; GEMETEN; 1pt; Zygor agrees (52.2,31.7)
  { npc = 3704, name = "Mahani", prof = "TAILORING", side = "H", map = 1413, x = 44.80, y = 59.40, max = 150 }, -- The Barrens; <Expert Tailor>; https://www.wowhead.com/forever/npc=3704; GEMETEN; 1pt; Zygor agrees (44.92,59.39)
  { npc = 3004, name = "Tepa", prof = "TAILORING", side = "H", map = 1456, x = 43.80, y = 44.40, max = 150 }, -- Thunder Bluff; <Expert Tailor>; https://www.wowhead.com/forever/npc=3004; GEMETEN; 2pt; Zygor agrees (44.52,45.35)
  { npc = 11051, name = "Vhan", prof = "TAILORING", side = "H", map = 1456, x = 44.00, y = 44.40, max = 75 }, -- Thunder Bluff; <Journeyman Tailor>; https://www.wowhead.com/forever/npc=11051; GEMETEN; 3pt; not in Zygor
  { npc = 3523, name = "Bowen Brisboise", prof = "TAILORING", side = "H", map = 1420, x = 52.60, y = 55.60, max = 75 }, -- Tirisfal Glades; <Journeyman Tailor>; https://www.wowhead.com/forever/npc=3523; GEMETEN; 3pt; Zygor agrees (52.59,55.52)
  { npc = 4576, name = "Josef Gregorian", prof = "TAILORING", side = "H", map = 1458, x = 70.60, y = 30.40, max = 225 }, -- Undercity; <Artisan Tailor>; https://www.wowhead.com/forever/npc=4576; GEMETEN; 5pt; Zygor agrees (70.75,30.69)
  { npc = 4578, name = "Josephine Lister", prof = "TAILORING", side = "H", map = 1458, x = 86.40, y = 22.20, max = nil }, -- Undercity; <Master Shadoweave Tailor>; https://www.wowhead.com/forever/npc=4578; GEMETEN; 3pt; no Teaches tab on Wowhead; Zygor agrees (86.65,22.08)
  { npc = 11049, name = "Rhiannon Davis", prof = "TAILORING", side = "H", map = 1458, x = 70.60, y = 29.60, max = 150 }, -- Undercity; <Expert Tailor>; https://www.wowhead.com/forever/npc=11049; GEMETEN; 5pt; not in Zygor
  { npc = 11048, name = "Victor Ward", prof = "TAILORING", side = "H", map = 1458, x = 70.40, y = 29.40, max = 75 }, -- Undercity; <Journeyman Tailor>; https://www.wowhead.com/forever/npc=11048; GEMETEN; 4pt; not in Zygor
  { npc = 252380, name = "Othesia Evengale", prof = "TAILORING", side = "both", map = 2521, x = 64.40, y = 81.00, max = 150 }, -- Zephras Isle; <Tailor>; https://www.wowhead.com/forever/npc=252380; GEMETEN; 1pt; Zygor agrees (64.41,81.18)
  { npc = 251991, name = "Taleen Shimmerthread", prof = "TAILORING", side = "both", map = 2521, x = 44.80, y = 44.20, max = 150 }, -- Zephras Isle; <Tailor>; https://www.wowhead.com/forever/npc=251991; GEMETEN; 1pt; Zygor agrees (44.88,44.18)
  -- COOKING (24)
  { npc = 252084, name = "Katherine Lee", prof = "COOKING", side = "A", map = 1416, x = 12.40, y = 65.80, max = 150 }, -- Alterac Mountains; <Cooking Trainer>; https://www.wowhead.com/forever/npc=252084; GEMETEN; 2pt; Zygor agrees (12.5,65.8)
  { npc = 267000, name = "Paige", prof = "COOKING", side = "both", map = 1416, x = 20.80, y = 74.60, max = 150 }, -- Alterac Mountains; <Chef>; https://www.wowhead.com/forever/npc=267000; GEMETEN; 2pt; react [1,0], neutral counted usable (AFGELEID); not in Zygor
  { npc = 2818, name = "Slagg", prof = "COOKING", side = "H", map = 1417, x = 73.80, y = 33.40, max = nil, recipesOnly = true }, -- Arathi Highlands; <Superior Butcher>; https://www.wowhead.com/forever/npc=2818; GEMETEN; 2pt; recipes only (1); not in Zygor
  { npc = 4210, name = "Alegorn", prof = "COOKING", side = "A", map = 1457, x = 49.00, y = 21.20, max = 150 }, -- Darnassus; <Cooking Trainer>; https://www.wowhead.com/forever/npc=4210; GEMETEN; 3pt; Zygor agrees (49.03,21.24)
  { npc = 1355, name = "Cook Ghilm", prof = "COOKING", side = "A", map = 1426, x = 68.40, y = 54.40, max = 150 }, -- Dun Morogh; <Cooking Trainer>; https://www.wowhead.com/forever/npc=1355; GEMETEN; 2pt; Zygor agrees (68.37,54.49)
  { npc = 1699, name = "Gremlock Pilsnor", prof = "COOKING", side = "A", map = 1426, x = 47.60, y = 52.40, max = 150 }, -- Dun Morogh; <Cooking Trainer>; https://www.wowhead.com/forever/npc=1699; GEMETEN; 1pt; Zygor agrees (47.67,52.3)
  { npc = 3191, name = "Cook Torka", prof = "COOKING", side = "H", map = 1411, x = 51.20, y = 42.40, max = 150 }, -- Durotar; <>; https://www.wowhead.com/forever/npc=3191; GEMETEN; 2pt; prof from Teaches tab; not in Zygor
  { npc = 1430, name = "Tomas", prof = "COOKING", side = "A", map = 1429, x = 44.20, y = 66.00, max = 150 }, -- Elwynn Forest; <Cook>; https://www.wowhead.com/forever/npc=1430; GEMETEN; 1pt; Zygor agrees (44.36,65.98)
  { npc = 5159, name = "Daryl Riknussun", prof = "COOKING", side = "A", map = 1455, x = 60.00, y = 36.80, max = 150 }, -- Ironforge; <Cooking Trainer>; https://www.wowhead.com/forever/npc=5159; GEMETEN; 3pt; Zygor agrees (60.07,36.43)
  { npc = 249968, name = "Hnaz Blunderflame", prof = "COOKING", side = "A", map = 2482, x = 15.40, y = 50.00, max = 150 }, -- Mount Hyjal; <>; https://www.wowhead.com/forever/npc=249968; GEMETEN; 2pt; prof from Teaches tab; not in Zygor
  { npc = 244512, name = "Ortak Lomgok", prof = "COOKING", side = nil, map = 2482, x = 12.80, y = 52.40, max = 150 }, -- Mount Hyjal; <Innkeeper>; https://www.wowhead.com/forever/npc=244512; GEMETEN; 2pt; prof from Teaches tab; no react on Wowhead [null,null]; not in Zygor
  { npc = 3067, name = "Pyall Silentstride", prof = "COOKING", side = "H", map = 1412, x = 45.00, y = 61.60, max = 150 }, -- Mulgore; <Cook>; https://www.wowhead.com/forever/npc=3067; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (44.91,61.67)
  { npc = 3399, name = "Zamja", prof = "COOKING", side = "H", map = 1454, x = 57.40, y = 53.40, max = 150 }, -- Orgrimmar; <Cooking Trainer>; https://www.wowhead.com/forever/npc=3399; GEMETEN; 4pt; Zygor agrees (57.39,53.95)
  { npc = 3087, name = "Crystal Boughman", prof = "COOKING", side = "A", map = 1433, x = 17.60, y = 43.60, max = 150 }, -- Redridge Mountains; <Cooking Trainer>; https://www.wowhead.com/forever/npc=3087; GEMETEN; 1pt; classic-frame pts dropped; Zygor DIFFERS by 5.2 (22.78,43.46) = Classic frame (open item 1)
  { npc = 256655, name = "Gorg", prof = "COOKING", side = "H", map = 2548, x = 58.60, y = 44.60, max = 150 }, -- Riverglades; <Cook>; https://www.wowhead.com/forever/npc=256655; GEMETEN; 1pt; not in Zygor
  { npc = 5482, name = "Stephen Ryback", prof = "COOKING", side = "A", map = 1453, x = 78.20, y = 53.00, max = 150 }, -- Stormwind City; <Cooking Trainer>; https://www.wowhead.com/forever/npc=5482; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (78.17,53.1)
  { npc = 1382, name = "Mudduk", prof = "COOKING", side = "H", map = 1434, x = 31.40, y = 28.00, max = 150 }, -- Stranglethorn Vale; <Superior Cook>; https://www.wowhead.com/forever/npc=1382; GEMETEN; 1pt; Zygor agrees (31.34,27.97)
  { npc = 6286, name = "Zarrin", prof = "COOKING", side = "A", map = 1438, x = 57.00, y = 61.20, max = 150 }, -- Teldrassil; <Cook>; https://www.wowhead.com/forever/npc=6286; GEMETEN; 1pt; Zygor agrees (57.12,61.29)
  { npc = 8306, name = "Duhng", prof = "COOKING", side = "H", map = 1413, x = 55.20, y = 31.80, max = 150 }, -- The Barrens; <Cook>; https://www.wowhead.com/forever/npc=8306; GEMETEN; 1pt; Zygor agrees (55.28,31.77)
  { npc = 3026, name = "Aska Mistrunner", prof = "COOKING", side = "H", map = 1456, x = 50.80, y = 52.40, max = 150 }, -- Thunder Bluff; <Cooking Trainer>; https://www.wowhead.com/forever/npc=3026; GEMETEN; 2pt; Zygor agrees (50.71,53.11)
  { npc = 265944, name = "William Pickman", prof = "COOKING", side = "H", map = 1420, x = 61.80, y = 51.40, max = 150 }, -- Tirisfal Glades; <Cooking Trainer>; https://www.wowhead.com/forever/npc=265944; GEMETEN; 2pt; Zygor agrees (61.8,51.5)
  { npc = 4552, name = "Eunice Burch", prof = "COOKING", side = "H", map = 1458, x = 62.20, y = 44.40, max = 150 }, -- Undercity; <Cooking Trainer>; https://www.wowhead.com/forever/npc=4552; GEMETEN; 4pt; Zygor agrees (62.14,44.91)
  { npc = 257006, name = "Nyalah Brightfire", prof = "COOKING", side = "both", map = 2521, x = 60.60, y = 72.60, max = 150 }, -- Zephras Isle; <Cook>; https://www.wowhead.com/forever/npc=257006; GEMETEN; 1pt; Zygor agrees (60.64,72.66)
  { npc = 251905, name = "Zerril Softbreeze", prof = "COOKING", side = "both", map = 2521, x = 43.80, y = 43.80, max = 150 }, -- Zephras Isle; <Cook>; https://www.wowhead.com/forever/npc=251905; GEMETEN; 1pt; Zygor agrees (43.85,43.84)
  -- FIRSTAID (16)
  { npc = 251977, name = "Angelique Butler", prof = "FIRSTAID", side = "both", map = 1416, x = 17.20, y = 61.00, max = 150 }, -- Alterac Mountains; <First Aid Trainer>; https://www.wowhead.com/forever/npc=251977; GEMETEN; 1pt; react [1,0], neutral counted usable (AFGELEID); Zygor agrees (17.2,61), Zygor side A
  { npc = 4211, name = "Dannelor", prof = "FIRSTAID", side = "A", map = 1457, x = 51.60, y = 12.60, max = 150 }, -- Darnassus; <First Aid Trainer>; https://www.wowhead.com/forever/npc=4211; GEMETEN; 5pt; Zygor agrees (51.71,12.21)
  { npc = 2326, name = "Thamner Pol", prof = "FIRSTAID", side = "A", map = 1426, x = 47.20, y = 52.40, max = 150 }, -- Dun Morogh; <Physician>; https://www.wowhead.com/forever/npc=2326; GEMETEN; 2pt; Zygor agrees (47.17,52.61)
  { npc = 5943, name = "Rawrk", prof = "FIRSTAID", side = "H", map = 1411, x = 54.00, y = 42.00, max = 150 }, -- Durotar; <First Aid Trainer>; https://www.wowhead.com/forever/npc=5943; GEMETEN; 1pt; Zygor agrees (54.17,41.92)
  { npc = 2329, name = "Michelle Belle", prof = "FIRSTAID", side = "A", map = 1429, x = 43.40, y = 65.60, max = 150 }, -- Elwynn Forest; <Physician>; https://www.wowhead.com/forever/npc=2329; GEMETEN; 1pt; Zygor agrees (43.39,65.54)
  { npc = 5150, name = "Nissa Firestone", prof = "FIRSTAID", side = "A", map = 1455, x = 54.80, y = 58.60, max = 150 }, -- Ironforge; <First Aid Trainer>; https://www.wowhead.com/forever/npc=5150; GEMETEN; 3pt; Zygor agrees (55.08,58.26)
  { npc = 5939, name = "Vira Younghoof", prof = "FIRSTAID", side = "H", map = 1412, x = 46.00, y = 63.80, max = 150 }, -- Mulgore; <First Aid Trainer>; https://www.wowhead.com/forever/npc=5939; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (46.08,63.95)
  { npc = 3373, name = "Arnok", prof = "FIRSTAID", side = "H", map = 1454, x = 34.00, y = 84.40, max = 150 }, -- Orgrimmar; <First Aid Trainer>; https://www.wowhead.com/forever/npc=3373; GEMETEN; 1pt; Zygor agrees (34.17,84.57)
  { npc = 2327, name = "Shaina Fuller", prof = "FIRSTAID", side = "A", map = 1453, x = 52.80, y = 44.80, max = 150 }, -- Stormwind City; <First Aid Trainer>; https://www.wowhead.com/forever/npc=2327; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (53.01,44.65)
  { npc = 6094, name = "Byancie", prof = "FIRSTAID", side = "A", map = 1438, x = 55.20, y = 56.80, max = 150 }, -- Teldrassil; <First Aid Trainer>; https://www.wowhead.com/forever/npc=6094; GEMETEN; 1pt; Zygor agrees (55.28,56.81)
  { npc = 2798, name = "Pand Stonebinder", prof = "FIRSTAID", side = "H", map = 1456, x = 29.40, y = 21.40, max = 150 }, -- Thunder Bluff; <First Aid Trainer>; https://www.wowhead.com/forever/npc=2798; GEMETEN; 4pt; Zygor agrees (29.69,21.17)
  { npc = 5759, name = "Nurse Neela", prof = "FIRSTAID", side = "H", map = 1420, x = 61.80, y = 52.80, max = 150 }, -- Tirisfal Glades; <First Aid Trainer>; https://www.wowhead.com/forever/npc=5759; GEMETEN; 1pt; Zygor agrees (61.81,52.82)
  { npc = 4591, name = "Mary Edras", prof = "FIRSTAID", side = "H", map = 1458, x = 73.40, y = 55.40, max = 150 }, -- Undercity; <First Aid Trainer>; https://www.wowhead.com/forever/npc=4591; GEMETEN; 4pt; Zygor agrees (73.15,55.14)
  { npc = 3181, name = "Fremal Doohickey", prof = "FIRSTAID", side = "A", map = 1437, x = 10.80, y = 61.20, max = 150 }, -- Wetlands; <First Aid Trainer>; https://www.wowhead.com/forever/npc=3181; GEMETEN; 1pt; Zygor agrees (10.81,61.4)
  { npc = 257007, name = "Melasa Fairmend", prof = "FIRSTAID", side = "both", map = 2521, x = 63.00, y = 72.40, max = 150 }, -- Zephras Isle; <Medic>; https://www.wowhead.com/forever/npc=257007; GEMETEN; 2pt; Zygor agrees (63.17,72.56)
  { npc = 257018, name = "Naleeia Tattermend", prof = "FIRSTAID", side = "both", map = 2521, x = 43.00, y = 46.20, max = 150 }, -- Zephras Isle; <Medic>; https://www.wowhead.com/forever/npc=257018; GEMETEN; 1pt; Zygor agrees (43.07,46.31)
  -- FISHING (25)
  { npc = 12961, name = "Kil'Hiwana", prof = "FISHING", side = "H", map = 1440, x = 10.80, y = 33.40, max = 150 }, -- Ashenvale; <Fisherman>; https://www.wowhead.com/forever/npc=12961; GEMETEN; 2pt; Zygor agrees (10.82,33.65)
  { npc = 4156, name = "Astaia", prof = "FISHING", side = "A", map = 1457, x = 47.40, y = 56.40, max = 150 }, -- Darnassus; <Fishing Trainer>; https://www.wowhead.com/forever/npc=4156; GEMETEN; 4pt; Zygor agrees (47.88,56.65)
  { npc = 12032, name = "Lui'Mala", prof = "FISHING", side = "H", map = 1443, x = 22.60, y = 72.40, max = 150 }, -- Desolace; <Fisherman>; https://www.wowhead.com/forever/npc=12032; GEMETEN; 2pt; Zygor agrees (22.69,72.42)
  { npc = 1700, name = "Paxton Ganter", prof = "FISHING", side = "A", map = 1426, x = 35.40, y = 40.20, max = 150 }, -- Dun Morogh; <Fisherman>; https://www.wowhead.com/forever/npc=1700; GEMETEN; 2pt; Zygor agrees (35.47,40.22)
  { npc = 5941, name = "Lau'Tiki", prof = "FISHING", side = "H", map = 1411, x = 53.20, y = 81.40, max = 150 }, -- Durotar; <Fisherman>; https://www.wowhead.com/forever/npc=5941; GEMETEN; 2pt; Zygor agrees (53.24,81.59)
  { npc = 1651, name = "Lee Brown", prof = "FISHING", side = "A", map = 1429, x = 47.40, y = 62.20, max = 150 }, -- Elwynn Forest; <Fisherman>; https://www.wowhead.com/forever/npc=1651; GEMETEN; 2pt; Zygor agrees (47.6,62.32)
  { npc = 7946, name = "Brannock", prof = "FISHING", side = "A", map = 1444, x = 32.20, y = 41.40, max = 150 }, -- Feralas; <Fisherman>; https://www.wowhead.com/forever/npc=7946; GEMETEN; 2pt; Zygor agrees (32.25,41.6)
  { npc = 2367, name = "Donald Rabonne", prof = "FISHING", side = "A", map = 1424, x = 50.40, y = 64.20, max = 150 }, -- Hillsbrad Foothills; <Fisherman>; https://www.wowhead.com/forever/npc=2367; GEMETEN; 4pt; spread 3.2 from medoid; Zygor DIFFERS by 3.2 (50.78,61.03)
  { npc = 255877, name = "Hunter Moore", prof = "FISHING", side = "A", map = 1424, x = 54.00, y = 80.20, max = 150 }, -- Hillsbrad Foothills; <Fisherman>; https://www.wowhead.com/forever/npc=255877; GEMETEN; 2pt; not in Zygor
  { npc = 5161, name = "Grimnur Stonebrand", prof = "FISHING", side = "A", map = 1455, x = 48.40, y = 6.40, max = 150 }, -- Ironforge; <Fishing Trainer>; https://www.wowhead.com/forever/npc=5161; GEMETEN; 4pt; Zygor agrees (48.06,6.91)
  { npc = 1683, name = "Warg Deepwater", prof = "FISHING", side = "A", map = 1432, x = 40.40, y = 39.40, max = 150 }, -- Loch Modan; <Fisherman>; https://www.wowhead.com/forever/npc=1683; GEMETEN; 4pt; Zygor agrees (40.58,39.68)
  { npc = 5938, name = "Uthan Stillwater", prof = "FISHING", side = "H", map = 1412, x = 44.20, y = 63.80, max = 150 }, -- Mulgore; <Fisherman>; https://www.wowhead.com/forever/npc=5938; GEMETEN; 1pt; classic-frame pts dropped; Zygor agrees (44.16,63.79)
  { npc = 3332, name = "Lumak", prof = "FISHING", side = "H", map = 1454, x = 69.60, y = 29.20, max = 150 }, -- Orgrimmar; <Fishing Trainer>; https://www.wowhead.com/forever/npc=3332; GEMETEN; 4pt; Zygor agrees (69.8,29.21)
  { npc = 1680, name = "Matthew Hooper", prof = "FISHING", side = "A", map = 1433, x = 21.40, y = 51.00, max = 150 }, -- Redridge Mountains; <Fishing Trainer>; https://www.wowhead.com/forever/npc=1680; GEMETEN; 3pt; classic-frame pts dropped; Zygor DIFFERS by 5.6 (26.98,51.13) = Classic frame (open item 1)
  { npc = 260558, name = "Krix", prof = "FISHING", side = "both", map = 2548, x = 79.20, y = 54.80, max = 150 }, -- Riverglades; <Superior Fisherman>; https://www.wowhead.com/forever/npc=260558; GEMETEN; 1pt; react [0,0], neutral counted usable (AFGELEID); not in Zygor
  { npc = 5493, name = "Arnold Leland", prof = "FISHING", side = "A", map = 1453, x = 55.00, y = 69.40, max = 150 }, -- Stormwind City; <Fishing Trainer>; https://www.wowhead.com/forever/npc=5493; GEMETEN; 2pt; classic-frame pts dropped; Zygor agrees (54.98,69.64)
  { npc = 2834, name = "Myizz Luckycatch", prof = "FISHING", side = "both", map = 1434, x = 27.40, y = 77.00, max = 150 }, -- Stranglethorn Vale; <Superior Fisherman>; https://www.wowhead.com/forever/npc=2834; GEMETEN; 2pt; Zygor agrees (27.46,77.11)
  { npc = 3607, name = "Androl Oakhand", prof = "FISHING", side = "A", map = 1438, x = 55.80, y = 93.40, max = 150 }, -- Teldrassil; <Fisherman>; https://www.wowhead.com/forever/npc=3607; GEMETEN; 2pt; Zygor agrees (55.87,93.51)
  { npc = 14740, name = "Katoom the Angler", prof = "FISHING", side = "H", map = 1425, x = 80.40, y = 81.60, max = 150 }, -- The Hinterlands; <Fishing Trainer & Supplies>; https://www.wowhead.com/forever/npc=14740; GEMETEN; 3pt; Zygor agrees (80.33,81.52)
  { npc = 3028, name = "Kah Mistrunner", prof = "FISHING", side = "H", map = 1456, x = 55.80, y = 47.60, max = 150 }, -- Thunder Bluff; <Fishing Trainer>; https://www.wowhead.com/forever/npc=3028; GEMETEN; 2pt; Zygor agrees (56.13,46.38)
  { npc = 5690, name = "Clyde Kellen", prof = "FISHING", side = "H", map = 1420, x = 67.20, y = 51.00, max = 150 }, -- Tirisfal Glades; <Fisherman>; https://www.wowhead.com/forever/npc=5690; GEMETEN; 1pt; Zygor agrees (67.16,50.98)
  { npc = 4573, name = "Armand Cromwell", prof = "FISHING", side = "H", map = 1458, x = 80.80, y = 31.20, max = 150 }, -- Undercity; <Fishing Trainer>; https://www.wowhead.com/forever/npc=4573; GEMETEN; 5pt; Zygor agrees (80.69,31.26)
  { npc = 3179, name = "Harold Riggs", prof = "FISHING", side = "A", map = 1437, x = 8.00, y = 58.40, max = 150 }, -- Wetlands; <Fishing Trainer>; https://www.wowhead.com/forever/npc=3179; GEMETEN; 2pt; Zygor agrees (8.08,58.59)
  { npc = 257008, name = "Baelann Swiftcurrent", prof = "FISHING", side = "both", map = 2521, x = 63.20, y = 75.40, max = 150 }, -- Zephras Isle; <Fisher>; https://www.wowhead.com/forever/npc=257008; GEMETEN; 2pt; Zygor agrees (63.27,75.72)
  { npc = 251992, name = "Fenn Fairweather", prof = "FISHING", side = "both", map = 2521, x = 45.00, y = 48.40, max = 150 }, -- Zephras Isle; <Fisherman>; https://www.wowhead.com/forever/npc=251992; GEMETEN; 1pt; Zygor agrees (45.02,48.44)
}
```

## Sources (all read 8 Nov 2026)

- Wowhead Forever: NPC filter `npcs?filter=28;1;0`, 321 NPC pages `forever/npc=<id>`, 48 rank-spell pages
  `forever/spell=<id>`; Wowhead Classic `classic/spell=3101, 11611, 9785, 13920, 12656, 10662, 12180`, `classic/npc=4160`.
- wago.tools DB2 `UiMap` + `UiMapAssignment`, builds 1.60.1.70790, 1.60.1.70862 (Forever) and 1.15.9.70576 (Classic Era).
- Zygor `E:\World of Warcraft\_forever_\Interface\AddOns\ZygorGuidesViewerForever\Data-Forever\NPCData.lua` (cross-check only).
- Level requirement (third-party, quoted only as "this source says"): icy-veins.com/wow-forever/professions-overview
  (updated 3 Nov 2026); senseos.gg/guides/wow-forever/profession-skill/ (26 Oct 2026); wowcarry.com/blog/wow-forever/
  professions/enchanting-guide (4 Nov 2026); wowhead.com/forever/guide/professions/enchanting/overview;
  wow-professions.com/forever/alchemy-trainers; wow.gg/professions/forever/blacksmithing (8 Nov 2026);
  conquestcapped.com/guides/wow-forever/wow-forever-mining/ (13 Oct 2026); 1mw.io/en/professions/trainers (beta,
  15 Oct 2026); wowclassicforever.info/trainers/.
