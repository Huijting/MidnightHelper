# Class quests in Forever: what you must have BEFORE you travel (mh-research, 18 Nov 2026)

> **Gebouwd 18 nov 2026** (Rob via sparring, letterlijk: *"Ik ben de halve wereld over gereisd om bij dit quest te doen,
> deze class quest. Maar dan kom ik aan, dan had ik een boek moeten hebben. …"* → *"ja"*), in
> `Modules/ForeverClassQuests.lua`, blok "What you must HAVE before the trip":
> - Mage Study / Research Access 97286: `book = true` → BookStep: boek-quest gedaan → naar de bibliothecaris; boek in de
>   tassen → inleveren; anders → pijl naar het dichtstbijzijnde startboek van je kant (START_BOOKS, 5 per kant; plekken
>   uit een gids tellen 1,5× zo ver en krijgen "uit een spelersgids" erbij).
> - `pre` (PreStep, terwijl de quest in je log staat): paladin 7637 150 goud; warlock 7625 150 goud (tenzij Stardust
>   18687 al in je tassen); warlock 7623 Shadowy Potion 18802 kopen bij Gorzeeki (niet in Felwood: daar zijn ze op);
>   priest-robe stap 2 Lesser Heal Rank 2 (2052).
> - Mage 1948: 10 sticks i.p.v. 1. (Start-items 98601/98581/92484 eerst toegevoegd, na de tweede controle weer weg.)
> - **Na de tweede Opus-controle** (`CLASSQUEST_CONTROLE2_2026-11-18.md`): 7642 ook 150 goud (pas na de 4 doelen,
>   `turn = true`); het 150-goud-seintje voor de Stardust al bij 7623/7624 (7625 krijg je naast Ur'dan = te laat);
>   7631 de drie ritueel-voorwerpen (alle drie, alleen in de Burning Steppes, `allItems` + `onlyMap`); potion-tekst
>   "6 gold for 3" en alleen in de Burning Steppes (`onlyMap 1428`); priest rank 3 (2053) telt ook; de start-items
>   weer weg (DB2 StartQuestID 0, deden niets); twee level-25-boeken uit START_BOOKS; "free" uit de Study-naam
>   (kost een Light Feather); de: Forscherzugang, andere talen "de volgende quest" i.p.v. de Engelse titel.
>   Niet gedaan: Scholomance-sleutel 7629/7647 (niet gemeten), Study bovenaan "Do this now" (ontwerpkeuze, Rob).
> - NIET gebouwd (niet gemeten / conflict): 94502 inleverplek, aantal Shadowy Potions, Pick Lock voor 2478, de
>   Spoken-breadcrumbs. Ruwe boekdata: scratchpad `mage_books.lua` (41 rijen), niet in de repo.

Read only. Nothing in the repo was touched. Code read in full: `Modules/ForeverClassQuests.lua` (2401 lines) and the
`FCQ_*` texts in `Locales/enUS.lua` (lines 5873-6170).

Labels: **G** = GEMETEN (seen in a named source, date below). **A** = AFGELEID (reasoned).

Main sources (all read 18 Nov 2026):
- **WH-tt**: Wowhead Forever tooltip JSON via `run gamedata quest|object|npc ... --game forever`
  (nether.wowhead.com/forever/tooltip). Fetched: the `q` id of every step of the module plus most `alt` ids
  (about 330 quest ids). NOT fetched: the druid letter alts 5924/5925/5926/5927 and the `alt` ids of the 12 priest
  race-spell steps (talk-only quests; their main id was fetched).
- **DB2**: wago.tools DB2, Forever build **1.60.1.70959** (ItemSparse, SpellLevels, SpellReagents, SpellCooldowns,
  SpellName, UiMap, AreaTable).
- **Spoken**: `_forever_/Interface/AddOns/Spoken_Quests/Data/Compendium.lua` (prev / ender per quest; one prev only).
- **FQL**: foreverquestlog.com quest pages ("Before you can take it", "Requires level"); undated, data-generated.
- **WH-guide**: Wowhead Forever guide "Collecting Library Books: Locations and Rewards" (Serenal, updated
  2026-11-13) + its comments (comments are undated).
- **wiki**: warcraft.wiki.gg (pages "Research Access", "Library book", item pages; undated) and its API extlinks.
- **azw**: azeroth.wiki/forever/quests/research-access (undated).
- **fc**: foreverchanges.pro/library-books (Vektor, updated 4 Oct 2026; player reports Sept-Oct 2026).

---

## Part 1 - Mage library books and Research Access 97286

### What 97286 needs (the "first book")

| Fact | G/A | Source |
|---|---|---|
| 97286 "Research Access" has **no item objective**: the tooltip has only the completion text ("Your actions show you are one who respects knowledge..."). | G | WH-tt 97286; Spoken QuestText.lua (complete-only) |
| It is offered after you have **handed in ANY ONE library-book quest** (78124 Nar'thalas Almanac, 78127 Dalaran Digest, ... 38 titles listed with "or"). | G (azw lists the 38 as "A or B or ..."; FQL: "Complete any one of these quests first"; wiki: "offered by librarians to mages who turn in their first library book") | azw, FQL 97286, wiki |
| Count = **1 book turn-in**. Not 1 book in the bags: the book itself is handed in through its OWN quest first. | G (sources above) / that 1 is enough in game today: A (wowdee 6 Oct still said "no fixed count confirmed") | azw, FQL, wiki, WH-guide ("When Mages hand in their first book, they learn ... Study") |
| Each book quest needs that book item in your bags ("Requirements: - Nar'thalas Almanac, Vol. 74", etc.). | G | WH-tt 78124 ... 84402 |
| The librarian only offers a book quest **while the book is in your bags**. | G as player/site report, not in client data | fc ("only offers the quest if you're already carrying a book"), wowforever.wclbox.com |
| 97286: quest level 20, **requires level 1**, class Mage, both factions; start + end Garion Wendell (Stormwind) or Owen Thadd (Undercity). | G | wiki, azw, FQL |
| Spoken gives 97286 races = Horde mask only (ender Owen Thadd). Disagrees with the three sources above. | G (Spoken says so) / Alliance can do it: A (3 sources vs 1) | Spoken Compendium.lua:4654 |
| Librarians GEMETEN: Garion Wendell 211033 Stormwind (48.8,86.6 / 49.0,86.4); Owen Thadd 211022 Undercity (73.4,33.0 / 73.6,33.0 / 73.8,32.2). Code has 48.9,86.5 and 73.4,33.0: match. | G | WH-tt npc |
| Study 1302508: SpellLevel **6**; reagent **1 x item 17056 Light Feather**; cooldown **3 600 000 ms = 1 hour**. (The Wowhead guide's "one-day cooldown" is wrong; the code's "once an hour" is right. The chain name says "free scrolls": it costs a Light Feather, 30 copper BuyPrice.) | G | DB2 SpellLevels / SpellReagents / SpellCooldowns / ItemSparse 70959 |
| Books are **world objects** you click (bookshelf, scrolls, tome, tablet), not drops or vendor items. | G (object tooltips are "Container" with spawns, see table) + fc / wclbox ("Monsters don't drop them") | WH-tt object, fc |
| All 40 book items: unique (MaxCount 1), any race/class, RequiredLevel 0, not quest starters (StartQuestID 0). | G | DB2 ItemSparse 70959 (`Description_lang~library`, 40 rows) |
| Each book counts once; a deleted book can not be looted again (player report). | G as report | space4games.com (10 Nov 2026) |
| Hostile-zone books: invisible guards bounce you (Loch Modan inn for Horde). An Alliance player looted and handed in the Orgrimmar book; a Horde player did Antonidas. Turn-in works at either librarian. | G as reports | WH-guide comments "Inquire", "Ironpowered", "naluh"; fc (30 Sep 2026) |

### What the code does now (the cause of Rob's trip)

`CHAINS.MAGE` "study": one step `{ q = 97286, from = librarian, wait = "FCQ_WAIT_MA_BOOK", to = librarian }`.
`Step()` returns `kind = "wait"` with **place = e.from = the librarian**. So "Show the way" sends the mage to
Stormwind or Undercity even with no book at all; the text says "first bring any library book", but the arrow
goes to the wrong place. Nothing checks the bags or the 38 book quests. (G: read in the code, lines 1560-1565,
2143-2147.)

What would fix it (A, a proposal for the build chat, not built):
1. Any `BOOK_QUESTS` id done -> 97286 should be on offer: `kind = "get"` at the librarian.
2. Else a book item from `BOOKS` in the bags -> "hand in <book> at the librarian" (place = librarian).
3. Else -> point at the nearest book for this faction/start (see below), not at the librarian.
Data for all three: `scratchpad\mage_books.lua` (`BOOKS`, `BOOK_QUESTS`).

### Books near the mage cities (per side and start)

Coordinates: GEMETEN = Wowhead Forever object tooltip spawn; otherwise WH-guide 13 Nov. "Nearest" = A.

| Mage start | Nearest book | Where | G/A |
|---|---|---|---|
| Human (Elwynn -> Stormwind) | Archmage Theocritus' Research Journal (item 203755, quest 79092) | object 386759 "Library Book", Tower of Azora, Elwynn 1429 **65.4,70.1** (1 spawn) | G spawn; "nearest" A |
| Human, next | Bewitchments and Glamours 209845 (78142); Rumi of Gnomeregan 208860 (79093) | Westfall 1436: Moonbrook 45.4,70.5; Sentinel Hill 52.7,53.8 | guide only (objects not measured) |
| Gnome (Dun Morogh -> Ironforge) | Archmage Antonidas: The Unabridged Autobiography 203754 (79091) | object 386691 "Library Book", Hall of Explorers, Ironforge 1455 **75.7,10.5** (4 spawns) | G |
| Gnome, note | The Alliance librarian is in **Stormwind** (tram). Loch Modan: Rumi (object 408014 "Gnomish Tome", Thelsamar inn 35.4-35.6, 48.2-48.9, 4 spawns) and Runes of the Sorcerer-Kings (409731, Mo'grosh 77.4,14.0; two level 19 elites per comment "melvin") | Loch Modan 1432 | G spawns |
| High Order Skyborne (Zephras Isle 2521) | **No confirmed book on the island.** Wowhead Forever shows object 409562 "Spellbook" with 8 spawns on Zephras Isle; on warcraft.wiki 409562 is the SoD Westfall spellbook (Bewitchments). A Wowhead guide comment ("absonom") says there are NO books on Zephras Isle. After arriving: Elwynn (Theocritus). | - | not measured what 409562 holds |
| Undead (Tirisfal -> Undercity) | The Apothecary's Metaphysical Primer 208185 (79095) | object 405879 "Apothecary Society Primer", Brill, Tirisfal 1420 **59.4,52.3** (2 spawns) | G |
| Undead, next | The Dalaran Digest 209844 (78127): object 409501, Ambermill 63.5,63.1. Ataeric 210177 (79096): object 410299 "Arcane Secrets", Sepulcher 43.4,41.2 (inside the inn, downstairs per fc) | Silverpine 1421 | G spawns |
| Orc / Troll (Durotar -> Orgrimmar) | The Lessons of Ta'zo 207972 (79094) | tablet in front of Darkbriar Lodge, Valley of Spirits, Orgrimmar 1454 **38.7,78.4** | guide + wiki; object id NOT found |
| Orc / Troll, note | The Horde librarian is in **Undercity** (zeppelin). The Brill book (above) lies on the way. Barrens: Baxtan 208800 (object 407566 "Goblin Tome", Ratchet 62.7,36.3), Arcanic Systems Manual 209847 (409700 "Manual", Sludge Fen 56.3,8.8), Secrets of the Dreamers 209846 (409692, no spawn data; Wailing Caverns outer cave, entrance 46.0,36.5) | Barrens 1413 | G spawns (except Secrets) |
| Night Elf (no mage in Forever, CharBaseInfo per code comment) | Nar'thalas Almanac 209843 (78124): object 409496, Darkshore 1439 59.6,22.2 | - | G |

The full list (40 items in 41 rows because Rumi has two spots; 37 object ids, 36 of them with a Wowhead Forever
spawn; map + x,y, side, source per book) is in `scratchpad\mage_books.lua`.

### Not found in Part 1
- Object id of the Ta'zo tablet, the Westfall Bewitchments spellbook, the Westfall Rumi tome, the Stranglethorn
  Basilisks notes. Their coordinates come from the WH-guide only.
- No spawn data on Wowhead Forever for Secrets of the Dreamers (object 409692).
- What object 409562 on Zephras Isle holds (book or not).
- Whether one book turn-in is enough in the current build (all sources say "first book"; nobody shows the count
  in client data). Rob can test: hand in one book, look at the librarian.
- Whether the Wowhead tooltip coordinates equal UiMap coordinates (A: same as the module already assumes).
- The Liminal and the Arcane: Wowhead Forever has object 441249 in Feralas, but quest 81951 is a 404 there and
  players say it is missing. Luddite's Guide quest 79953 is also a 404 on Wowhead Forever.

---

## Part 2 - All class-quest steps: preconditions before the destination makes sense

Checklist used per step: count on item goals, several predecessors, what to click/use/buy, level, start item, spell
you must know, gold. Every quest id in the module was looked up on WH-tt; the rows below are the steps where a
precondition exists. Steps with no precondition are listed after the table.

| Class | Chain | Quest | Code now | Source says | Missing (item id, count, where) | G/A | Source |
|---|---|---|---|---|---|---|---|
| MAGE | study | 97286 | `wait` text "first bring any library book"; arrow to the librarian | needs ANY 1 of 38 book quests done; each book quest needs its book item (40 items) in bags | a book check (40 item ids) + book-quest check (38/40 ids) + arrow to the nearest book, see Part 1 | G (rule) / fix A | azw, FQL, wiki, WH-tt, DB2 |
| MAGE | items | 1948 | `O(witherbark, STICKS, nil, {7273, 7272})` no count: 1 stick = done (known limit); text says 10 | Requirements: Jade, Bolt Charged Bramble, **Witherbark Totem Stick x 10** | count 10 on item 7273 (Witherbark Totem Stick). Jade = item 1529 (text has it, no check) | G (requirement) / whether making the bramble eats a stick: not measured | WH-tt 1948, DB2 ItemSparse |
| MAGE | wand | 1952 | `wait` after 1951; Items chain first in table order | "Complete all of these quests first: 1948 Items of Power, 1951 Rituals of Power" | nothing (the wait text names both) | G | FQL 1952 |
| MAGE | robe | 1921 / 1961 | text: 10 Linen Cloth + 6 gems | Linen Cloth x 10 (item 2589) + 6 Charged Rift Gems / Dalaran Mana Gems | nothing; optional: warn at 1920/1960 already (Linen is the only thing you can bring along) | G / A | WH-tt, DB2 |
| MAGE | spellbook | 82084 | level 42; "whether it needs Research Access first = NOT measured" | Requires level 42 (quest 45); Owen or Garion; no "Before you can take it" section | nothing found (FQL shows no prerequisite; silence = weak) | G level / A no prereq | FQL 82084, WH-tt |
| MAGE | pig | 9364 | text: keep the Shell, Polymorph naga, 50 clones | Polymorph Clone x 50 | needs Polymorph (118, SpellLevel 8): always known at 60 | G / A | WH-tt, DB2 |
| WARLOCK | dreadsteed | 7623 | `{ q = 7623, from = gorzeeki, to = banehollow }`, no step text | "**Purchase Shadowy Potions from Gorzeeki** in the Burning Steppes. Use the potions to travel through Jaedenar" | buy **Shadowy Potion 18802** at Gorzeeki BEFORE leaving the Burning Steppes (DB2 BuyPrice 60 000 copper = 6 g each; how many you need: not measured) | G (text, item, price field) / vendor price = BuyPrice: A | WH-tt 7623, FQL 7623, DB2 ItemSparse |
| WARLOCK | dreadsteed | 7625 | text: "buy Xorothian Stardust from Ur'dan" | "Purchase Xorothian Stardust from Ur'dan" | **150 gold**: item 18687 Xorothian Stardust BuyPrice 1 500 000 copper. Say it before the trip to Felwood | G (BuyPrice) / A (that the vendor charges exactly that) | DB2 ItemSparse, WH-tt, FQL 7625 |
| WARLOCK | dreadsteed | 7626 / 7627 / 7628 / 7630 | texts: 10 Elixir of Shadow Power; 6 Large Brilliant Shards + 25 Dark Iron Ore; 35 Black Dragonscales; 3 Arcanite Bars; 7630 needs {7626,7627,7628} | same counts; 7630 "Complete all of these quests first: 7626, 7627, 7628" | nothing (all counts in the texts; items are hand-ins at Gorzeeki, so no trip without them) | G | WH-tt, FQL 7630 |
| WARLOCK | dreadsteed | 7631 | needs {7629, 7630}; text "Dire Maul West, use the items from Gorzeeki" | "Complete all of: 7629, 7630"; accepting gives Mor'zul's Instructions | nothing for items. FQL files it under "Dire Maul: East" (code says West): not measured which | G needs / dungeon wing open | FQL 7631 |
| WARLOCK | dreadsteed | 7563 | text: 30 Raging Beast's Blood | Raging Beast's Blood x 30 | nothing | G | WH-tt |
| WARLOCK | felhunter | 1804 / 1805 | `O(rods, RODS, 1)`, text 3 Rods | "Bring the Reconstructed Tome and 3 Rods of Channeling" | nothing (the tome comes from Krom/Jorah: A) | G | WH-tt |
| WARLOCK | succubus/incubus/void | 1689, 1504, 1471, 1739, 1513, 1474, 65603, 65604, 65597 | "use the quest item from your bags at the summoning circle" | "Using the <item>, summon and subdue ..." | nothing (item from the previous step / quest) | G | WH-tt |
| PALADIN | charger | 7637 | `{ q = 7637, from = grayson, to = rohan }`, no text | "You will need to make a **donation of 150 gold**"; Requirements: **Money:150** | **150 gold** before the trip to Rohan in Ironforge | G | WH-tt 7637 |
| PALADIN | charger | 7642 | 4 objectives; text "6 Arcanite Bars, and 150 gold" | 5 Stratholme Holy Water, 10 Arthas' Tears (8836), 40 Runecloth (14047), 6 Arcanite Bar (12360), Money:150; index order matches the code | nothing | G | WH-tt 7642, DB2 |
| PALADIN | charger | 7643 (+7645) | text: 20 Enriched Manna Biscuits + 50 gold at Merideth, then DM West | 7645: Enriched Manna Biscuit x 20 (13724) + Money:50; 7643: Manna-Enriched Horse Feed | nothing (Argent Dawn Friendly for the biscuits: text says so, not measured) | G | WH-tt 7643/7645 |
| PALADIN | charger | 7646 | Azerothian Diamond + Pristine Black Diamond | same | nothing | G | WH-tt |
| PALADIN | charger | 7647 | objectives 2 (barding) and 1 (soul) | 4 lines: Charger's Redeemed Soul, Blessed Arcanite Barding, Charger's Lost Soul, Divination Scryer | nothing to bring (Scryer + barding come from the satchel) | G | WH-tt 7647 |
| PALADIN | redemption A/D/UD | 1644, 1648, 94434 | text "bring 10 Linen Cloth" at that step | Linen Cloth x 10 (2589) | nothing; optional: say it one step earlier (1643/1647/94427 send you across town first) | G / A | WH-tt |
| PALADIN | verigan | 1654 | 4 objectives, index order lumber 1, ore 2, hammer 3, gem 4 | same 4, same order | nothing | G | WH-tt 1654 |
| PALADIN | holylight (UD) | 98601 | `from = sarvis`, `needs = 364` | "**Read the Consecrated Scroll** and speak to Aramis"; Spoken prev 364. Item 282423 Consecrated Scroll exists (DB2) | probably a START ITEM: `item = 282423` would make the step say "use ... in your bags" (only when present, so safe). DB2 StartQuestID is 0: not proven | G text + item / start item A | WH-tt 98601, DB2, Spoken |
| SHAMAN | earth (Dwarf) | 98581 | `from = sten`, alt 96243 | "**Read the Archaic Rune** and speak to Teo"; Spoken prev **179** (Dwarven Outfitters); item 282400 Archaic Rune (quest item) | start item 282400 (A, StartQuestID 0); predecessor 179 not in the chain (Spoken only) | G text, item, Spoken / A | WH-tt, DB2, Spoken |
| SHAMAN | earth (Windshaper) | 92484 | `from = rorian` | "**Examine the Humming Recall Crystal** then speak with Windshaper Boro"; item 282418 | start item 282418 (A, StartQuestID 0) | G text + item / A | WH-tt, DB2 |
| SHAMAN | water (Dwarf) | 94502 | `to = S.shrine` (Forgotten Shrine); comment cites Spoken + Polestar | WH text: "Drink the Water Sapta and Cleanse the corruption at Stendel's Pond in Westfall. **Return to Norric in Loch Modan** when finished." Spoken 94502 has NO ender (= handed in at its giver) | CONFLICT on the hand-in place; the Horde twin 63 does end at the brazier. Measure in game | G (both sources) / which is right: not measured | WH-tt 94502, Spoken:4495 |
| SHAMAN | fire (Skyborne) | 97245 | text: only fire hurts Kuramaa, learn Flame Shock first | Kuramaa's Mask | Flame Shock 8050 SpellLevel 10 = chain level 10: fine | G | DB2 SpellLevels |
| SHAMAN | mastery | 8410 / 8411 | items 7069 Air, 7068 Fire, 7067 Earth, 7070 Water | Elemental Air/Fire/Earth/Water x 1 each | nothing (ids GEMETEN: DB2 names match) | G | WH-tt, DB2 |
| SHAMAN | mastery | 8412 | 8 Bloodshot Spider Eyes, 8 Thick Black Claws | same | nothing | G | WH-tt |
| PRIEST | robe | 5624, 5625, 5621, 5648, 5650 | text: heal with Lesser Heal (Rank 2), then Power Word: Fortitude | "heal his wounds using Lesser Heal (Rank 2). Afterwards, grant him Power Word: Fortitude" | spell precondition: Lesser Heal Rank 2 = 2052 (SpellLevel 4), PW:F 1243 (level 1). Optional check `Known(2052)` -> "train Lesser Heal (Rank 2) first". Chain level 5 is above 4: fine | G text + spell levels / check A | WH-tt, DB2 |
| DRUID | poison | 6123 / 6128 | text: 5 Earthroot (+12 Lunar Fungus / 5 Kodo Horns) | Earthroot x 5 (item 2449), Lunar Fungus x 12 / Kodo Horn x 5 | nothing; optional: say "buy 5 Earthroot" at 6122/6127 already | G / A | WH-tt, DB2 |
| DRUID | torwa | 9052 / 9051 / 9053 | 8 stings + 8 bloodcap; barb; Putrid Vine | same; 9051 and 9053 "Level 52" (quest level) | nothing | G | WH-tt |
| WARRIOR | whirlwind | 1712 (+1714) | Liferoot 8 (text), Tusks 30, charms 8 each (count in code) | Liferoot x 8 (3357), Bloodscalp Tusk x 30, Essence; 1714: 8 of each charm | nothing | G | WH-tt, DB2 |
| WARRIOR | fallenhero | 8423 / 8424 / 8425 | 7 / 20-10-20 / 2-2-2 | same | nothing | G | WH-tt |
| HUNTER | charm | 8153 / 8231 / 8232 | 2 antlers, 6 scales, tooth | same | nothing | G | WH-tt |
| PRIEST | cenarion | 8255 / 8256 / 8257 | 4 glands, ichor, blood | same | nothing | G | WH-tt |
| ROGUE | blade / poisons | 2206, 2242, 1858, 2359, 2478 | Pick Pocket in the texts | Pick Pocket targets | Pick Pocket 921 SpellLevel 4: fine. Gallywix's Lockbox (2478 obj 6) needs Pick Lock skill: how much = not measured | G / not measured | DB2, WH-tt |
| ROGUE | blade / poisons | 1858, 2359, 2478 | index order (Logbook 1/Key 2; Journal 1/Key 2; Drones 1, Lookouts 2, Patrollers 3, Head 4) | same order on WH-tt; 2478 shows only 4 lines (Silixiz key = idx 5 and Cache = idx 6 not visible) | nothing; idx 5/6 stay A | G / A | WH-tt |
| ROGUE | xelthos / bhossca | 78261 / 78676 | "go in alone" | "You must complete the job alone." | nothing (text has it) | G | WH-tt |

### Hidden predecessors that Spoken lists (first step of a chain) - not in the code

Spoken stores ONE `prev`. For these chain starters it names a quest the chain leaves out. FQL shows no
"Before you can take it" for the four I checked (1716, 6062, 1963, 2379), so they look like optional breadcrumbs
(A: FQL silence is weak evidence).

| Class | Chain start | Spoken prev | Code | G/A |
|---|---|---|---|---|
| WARLOCK | 1716 Devourer of Souls (A, 20) | 1717 Gakin's Summons | starts at Gakin | G Spoken; FQL no prereq; breadcrumb A |
| HUNTER | 6061 / 6062 / 6063 / 6064 | 6065 / 6068 / 6071 / 6074 The Hunter's Path | left out on purpose (comment) | G Spoken; FQL 6062 no prereq |
| HUNTER | 94978 (Skyborne) | 94007 "Taming the Beast: Report to Quel'ana Quickgale" (WH-tt) | left out | G Spoken + WH-tt; breadcrumb A |
| ROGUE | 1963 (Orc/Troll) | 1859 (Orc only) | Troll route starts at 1963 | G Spoken; FQL 1963 no prereq |
| ROGUE | 2379 Zando'zan | 2378 Find the Shattered Hand | left out | G Spoken; FQL 2379 no prereq |
| MAGE | 1861 / 1884 | 1860 / 1883 | pointer may be skipped (comment) | G Spoken; FQL 1861 shows only "exclusive with 1880" |
| WARLOCK | 3001 / 1801 | 2996 (both) | 2996 and 3001 as each other's alt | G Spoken; real meaning not measured |
| SHAMAN | 98581 | 179 Dwarven Outfitters | not in chain | G Spoken only |
| PALADIN | 3681 | 2998 | 2998 alt {3681} (code calls them alternatives) | G Spoken (3681 follows 2998); minor |

### Steps checked with NO precondition (only talk / go / provided item)

All tooltips seen on WH-tt 18 Nov 2026 (G). "Provided item" = the quest gives it (A where the tooltip does not say so).
- DRUID: 5923, 5928 (alts 5924-5927 not fetched), 5921/5922 (Teleport: Moonglade), 5929/5930, 5931/5932, 6001/6002 (dust
  provided), 6121/6126, 6122/6127 (empty sampler provided), 6124/6129 (salve provided), 6125/6130, 26/27, 29/28,
  272/30, 5061/31, 9063, 94006, 94638, cat 98393-98397 / 98340-98362 / 98341-98738.
- WARLOCK: 1598, 1599 (3), 1485 (6), 1470 (3), 1685, 1715, 1688, 1506, 1501, 1478, 1473, 1738, 65602, 1507-1512,
  1515, 65601, 65610, 1472, 1476, 65593, 1798, 2996, 3001, 1758, 1802, 1801, 1803, 1795, 4488/4487/3631/4489, 4490,
  7562, 7564, 7624, 7629 (Imp in a Jar provided), 7601, 7602 (3 essences), 7603 (Fel Fire provided).
- WARRIOR: 1638, 1639, 1640, 1665, 1679, 1678, 1684, 1683, 1505, 1498 (5 scales), 1818, 1819, 94003, 1718, 1719,
  1791, 1713, 1792, 8417.
- HUNTER: all taming quests (Taming Rod provided), 6103, 6086, 94793, 6081, 6089, 94050, 8151.
- ROGUE: 2205, 2218, 2238, 2239, 2241, 1859, 1885, 1886, 1898, 1899, 1978, 2281, 2282, 2379, 2382, 2381 (E.C.A.C.
  and Thieves' Tools from the machine: code has it), 2360, 2460, 2458 (Flare Gun provided), 2479, 2480, 78307,
  78699 (letter wait), 8233, 8234, 8235 (10), 8236.
- SHAMAN: 1516 (2), 1517, 1518, 1519 (2), 1520, 1521, 92466, 92467, 92468, 96243, 94373 (2), 94374, 94375, all
  fire starters, 1524-1527, 94449, 94465-94468, 97243, 97244, 97257, 1528/1529/2985/2986, 1530, 1535, 1536,
  1534, 220, 63, 100, 96, 94494, 94495, 94497, 94499, 94500, 94501, 94503, 94505, 1531/1532/96136, 94789, 8413.
- PRIEST: robe starters 5623/5626/5622/5649/5651; all 12 race-spell quests (talk only); 8254.
- PALADIN: 2998/3681, 1641, 1642 (tome item: code has `item`), 1643, 1780, 1781, 1786/1783 (Symbol of Life
  provided), 1787, 1784, 1788, 1785, 2999/2997/3000, 1645, 1646, 1647, 1778, 1779, 1655, 1442, 1793/1794, 1649,
  1650, 1651, 1652, 1653, 1806, 4485/4486, 1661, 8415, 8414 (20), 8416, 8418, 7638/7670, 7639, 7640 (25), 7641,
  7648, 7644, 90902 (Holy Light), 91282, 91285, 91294 (index order matches), 91316 (12), 91317 (index order
  matches), 95803, 94427, 94435, 94436, 94438, 94440, 94441, 95042, 91858-91862, 96204, 95034, 95036 (index order
  matches), 95111, 95125, 95126, 95140, 97022, 94971.
- MAGE: 1860, 1861, 1879, 1880, 93791, 93797, 1883, 1884, 1881, 1882, 1919, 1920 (index order matches), 1941,
  1959, 1960, 1962, 1939, 1938, 1940 (8), 1942, 1943, 1944, 1945 (12), 1946, 1947, 1949, 1950, 1951, 1953-1958,
  8250, 8251 (10), 8252 (6), 8253, 7463, 90789/9362.

Start items: DB2 ItemSparse StartQuestID over ALL quest ids of the module gives exactly 3 rows: 6775 Tome of
Divinity -> 1642, 6916 Tome of Divinity -> 1646, 6776 Tome of Valor -> 1649. These are the three `item =` in the
code (G: positive control). The three "Read/Examine the X" quests above are not in that list (StartQuestID 0).

---

## What I could NOT measure

- Anything the game shows only in game: which NPC really offers a quest right now, whether a breadcrumb is required,
  the real vendor price (DB2 BuyPrice is the base price), how many Shadowy Potions 7623 needs.
- Whether 97286 appears after exactly 1 book in the current build (sources say "first book"; no client data).
- Object ids: Ta'zo tablet, Westfall Bewitchments spellbook, Westfall Rumi tome, Basilisks notes; spawn of 409692.
- What object 409562 on Zephras Isle contains.
- Whether 98601 / 98581 / 92484 start from the items 282423 / 282400 / 282418 (texts say "Read/Examine"; DB2
  StartQuestID is 0, which can be a server-side or hotfix field: proves nothing either way).
- The hand-in place of 94502 (Norric per quest text, Forgotten Shrine per the code).
- Whether making the Bolt Charged Bramble uses up a Witherbark Totem Stick (then 11 sticks are needed).
- Pick Lock skill needed for Gallywix's Lockbox (2478).
- Required levels: Wowhead tooltips only show the QUEST level ("Level 52"), not the minimum level; I used FQL for
  the few I checked (82084: 42; 1952: 30; 7623/7625/7629/7630/7631: 60; 1716: 20; 1655/1806/95036/95140: 20).
- warcraft.wiki.gg / azeroth.wiki / foreverquestlog pages carry no date.
