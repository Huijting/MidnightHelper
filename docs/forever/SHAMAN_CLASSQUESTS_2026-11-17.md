# Shaman class quests (WoW Forever 1.60.1.70938): feiten voor `Modules/ForeverClassQuests.lua`

mh-research, 17 nov 2026. Alleen gelezen, niets in de code veranderd. Elke bewering is **GEMETEN** (bron + regel/URL,
gezien op 17 nov 2026) of **AFGELEID** (geredeneerd). Niets hiervan is al in het spel nagemeten: quest-id's tellen pas
als `/mh classquest` ze afvinkt.

## 1. Bronnen

| # | Bron | Wat eruit komt | Datum |
|---|---|---|---|
| Z-H | Zygor Forever `Guides-Forever\Leveling\ZygorLevelingHordeCLASSIC.lua` r. 24504-24842, "Leveling Guides\Shaman Class Quests" | Horde-ketens, coördinaten, `q <id>/<n>` | bestand gelezen 17 nov |
| Z-A | Zygor `ZygorLevelingAllianceCLASSIC.lua` r. 1587-1902, 2355-2639, 5337-5514, 6654-6660 | Dwarf earth/fire, start water. **Geen** aparte Alliance "Shaman Class Quests"-gids (grep "Shaman Class Quests" over `Guides-Forever` vond alleen de Horde-gids + een Trial-placeholder: positieve controle in dezelfde zoekactie) | 17 nov |
| Z-C | Zygor `ZygorLevelingCommonCLASSIC.lua` r. 38-272 (earth), 1003-1099 (fire), 1631 | Skyborne (Zephras Isle) | 17 nov |
| SP-C | Spoken `Spoken_Quests\Data\Compendium.lua` (data Forever 1.60.1.70450 + Efficient Games) | prev, ender/enderObject, races-mask, classes=64 | 17 nov |
| SP-Q | Spoken `SpokenQuestsAudioShared\generated\quest_id_lookups.lua` (secties accept r. 3, complete r. 6027, progress r. 12464) | wie geeft/neemt in (NPC- of objectnaam → quest-id) | 17 nov |
| SP-L | Spoken `...Shared\generated\questlog_npc_lookups.lua`, `questlog_object_lookups.lua`, `questlog_item_lookups.lua` | gever per quest (gecontroleerd tegen Zygor: 1516=5887, 1519=5888, 1524=5907, 98581=658, 94373=257446 kloppen) | 17 nov |
| SP-N | Spoken `Spoken_Quests\Locale\Names\esMX.lua` | esMX-namen die Wowhead mist (controle: 233 = "Granjero Saldean", 5887 = "Canaga Clamatierras") | 17 nov |
| DB2 | `tools/gamedata.py` → wago.tools DB2 **1.60.1.70938** (CharBaseInfo, ChrRaces, SpellEffect, SpellName, SpellLevels, SpellTotems, TotemCategory, ItemSparse in 7 talen, UiMap) | structuur, id's, levels | 17 nov |
| WH-T | `tools/gamedata.py` → Wowhead Forever tooltip-JSON (quest/npc/object, 7 locales) | doel-teksten, eisen-volgorde, spawns, namen | "Wowhead's own data, 2026-11-17" |
| WH-P | Wowhead Forever questpagina's via WebFetch (geen 403): 1518, 1521, 94375, 92468, 96243, 1527, 94468, 97257, 96, 94494, 94495, 94497, 94499, 94500, 94501, 94502, 94503, 94505, 1531, 94789, 96136, 8410, 8411, 8413, 79442, 96016 | beloningen ("You will learn", items), reeks | 17 nov |
| HN | `HandyNotes_ClassTrainers\Data.lua` r. 57-58, 76-77, 135, 159-160, 180-182, 263-265, 322-324 | trainer-coördinaten | 17 nov |
| G | Gidsen: gitm.gg "WoW Forever Call of Water" (15 nov 2026), warcrafttavern.com "Dwarf Shaman Totem Quests" (geen datum), polestar.guide "Call of Water (Alliance)" (laatst gewijzigd 9 nov 2026), conquestcapped.com (1 nov 2026), foreverchanges.pro (geen datum), expcarry/mmojugg/wowforevertavern (Tempest, 13 okt-15 nov 2026) | alleen wat 1-4 niet hebben | 17 nov |
| MH | `Modules/ForeverClassQuests.lua` (hele bestand), `ForeverTrainer.lua:33-49`, `ForeverTrainerData.lua:1007,1022,1051-1053`, `Locales/enUS.lua:5470-5557` | vorm, bestaande sleutels | 17 nov |

## 2. Wie kan shaman zijn in Forever

GEMETEN (DB2 CharBaseInfo ClassID=7, build 70938; positieve controle ClassID=1 in dezelfde query gaf 10 rassen):
CharBaseInfo-rijen voor shaman = RaceID **2, 6, 8, 96, 3**. ChrRaces (zelfde build):

| RaceID | ClientFileString | Naam | Factie (ChrRaces.Alliance: 0 = Alliance, 1 = Horde) | PlayableRaceBit |
|---|---|---|---|---|
| 2 | Orc | Orc | Horde | 1 |
| 6 | Tauren | Tauren | Horde | 5 |
| 8 | Troll | Troll | Horde | 7 |
| 96 | Skyborne | Windshaper Skyborne | Horde | 33 |
| 3 | Dwarf | Dwarf | Alliance | 2 |

- **High Order Skyborne (95, Alliance) kan GEEN shaman zijn** (GEMETEN: rij 898 = 95/ClassID 1, geen 95/7).
- Alliance-shaman = **alleen Dwarf** (GEMETEN). Geen Draenei, Human, Gnome of Night Elf.
- In MH: `RaceToken()` vouwt 95/96 tot "Skyborne"; met `faction = "Horde"` + `races = SKYBORNE` raakt dat alleen 96
  (AFGELEID uit de bestaande code r. 768-777).
- Spoken-races-maskers sluiten hierop aan (GEMETEN SP-C, uitleg in de kop r. 5-6: bit = PlayableRaceBit, Skyborne 32/33):
  98581 = 4 (alleen Dwarf); 94373-94505 = 4294967373 (Alliance + bit 32); 1516-1521, 1525-1536, 8410-8413 =
  8589934770 (Horde 178 + bit 33 Windshaper); **1522, 1523, 1524, 2983, 2984 = 178 (Horde zónder Windshaper)**;
  97243-97257 = 8589934592 (alleen Windshaper).

## 3. Spells, items en welke quest ze geeft

| Element | Spell (id, level) | Totem-item | Gegeven door (laatste quest) | Bron |
|---|---|---|---|---|
| Earth | Stoneskin Totem **8071**, SpellLevel **4** | Earth Totem **5175** | 1518, 1521, 94375, 92468 | GEMETEN WH-P (alle vier: "You will learn: Stoneskin Totem 8071", "You will also receive: Earth Totem 5175"); level DB2 SpellLevels |
| Fire | Searing Totem **3599**, SpellLevel **10** | Fire Totem **5176** (+ Totem of Charged Flames 263412) | 1527, 94468, 97257 | GEMETEN WH-P (alle drie, zelfde beloning) |
| Water | Healing Stream Totem **5394**, SpellLevel **20** | Water Totem **5177** | 96, 94505 | GEMETEN WH-P |
| Air | **geen spell** | Air Totem **5178** | 1531, 94789, 96136 (1532 AFGELEID: zelfde "Find Prate"-quest) | GEMETEN WH-P (1531, 94789, 96136: alleen Air Totem, geen "You will learn") |

- **Het totem-item moet je hebben om totems te plaatsen.** GEMETEN DB2 SpellTotems: 8071 eist RequiredTotemCategoryID 2,
  3599 → 4, 5394 → 5, 8177 Grounding/10595 Nature Resistance/8512 Windfury/15107 Windwall/8835 Grace of Air → 3,
  2484 Earthbind/5730 Stoneclaw → 2. TotemCategory: 2 Earth Totem, 3 Air Totem, 4 Fire Totem, 5 Water Totem.
  ItemSparse met TotemCategoryID 2-5 = precies **5175, 5176, 5177, 5178**. Dat het in je **tas** moet zitten (niet
  ergens anders): AFGELEID (classic-gedrag; Polestar: "Keep the Water Totem in your bags for good").
- Air-totems uit de trainer op 30: Grounding Totem 8177 en Nature Resistance Totem 10595, SpellLevel 30 (GEMETEN DB2).
  Zonder Air Totem kun je ze leren maar niet plaatsen (AFGELEID uit SpellTotems).
- Teach-spells in DB2 (SpellEffect Effect 36): 8073/8199 → 8071, 2075/8200 → 3599, 5396/8201 → 5394 (GEMETEN; welke
  de quest gebruikt: niet gemeten, maakt voor MH niet uit: `Known(8071)` kijkt naar de geleerde spell).
- **`ns.FOREVER_QUEST_FIRST` (8071, 3599, 5394) klopt** en is compleet voor shaman: de Air-quest geeft geen spell
  (GEMETEN WH-P), Elemental Mastery en Tempest's Weapons geven alleen items (GEMETEN WH-P 8413, 79442, 96016). Steun:
  `ForeverTrainerData.lua` heeft rang 2 met `req = { 8071 }` (r. 1007), `{ 3599 }` (r. 1022), `{ 5394 }` (r. 1052) maar
  geen rang 1 daarvan, terwijl trainerspells als Grounding 8177 (r. 1051) er wél staan (positieve controle) → AFGELEID:
  rang 1 komt niet van de trainer. Idee (niet gevraagd): de trainer kan op 30 melden dat Grounding/Nature Resistance
  het Air Totem nodig hebben.
- Level per keten: Earth 4, Fire 10, Water 20, Air 30 = SpellLevel resp. Wowhead-XP-calculator (1531 en 94789: level=30)
  (GEMETEN). Skyborne earth mag mogelijk al op 3: Zygor Z-C r. 75-79 "Helps reach level 3 ... Needed for class quest"
  (GEMETEN tekst; dat 92484 level 3 eist: AFGELEID). Advies: overal 4.

## 4. Ketens

Notatie gever/inleveraar: naam (npc-id). Objecten met `obj`. "Spoken" = SP-Q/SP-L/SP-C.

### 4a. Earth (level 4) — vier routes

**Orc/Troll (Durotar)** — Zygor Z-H r. 24534-24563 (`|only if (Orc Shaman) or (Troll Shaman)`).

| q | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|
| 1516 | Canaga Earthcaller (5887) | Canaga | /1 2× Felstalker Hoof 6640 (Felstalkers 3102, in de grot) | Z-H 24536-24546; WH-T "Requirements: Felstalker Hoof x 2"; Spoken gever 5887 |
| 1517 | Canaga | Minor Manifestation of Earth (5891) bij Spirit Rock | Earth Sapta 6635 drinken, dan praten (geen objective in tooltip) | Z-H 24549-24556; WH-T; SP-C ender 5891 |
| 1518 | Minor Manifestation of Earth (5891) | Canaga | Rough Quartz 6656 brengen (provided) | Z-H 24559-24562; WH-P 1518 (8071 + 5175); SP-L gever 5891 |

**Tauren (Mulgore)** — Z-H r. 24509-24533 (`|only if Tauren Shaman`).

| q | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|
| 1519 | Seer Ravenfeather (5888) | Ravenfeather | /1 2× Ritual Salve 6634 (Bristleback Shaman 2953) | Z-H 24510-24517; WH-T |
| 1520 | Ravenfeather | Minor Manifestation of Earth (5891) bij Kodo Rock | Earth Sapta drinken, praten | Z-H 24524-24528; WH-T |
| 1521 | Minor Manifestation of Earth (5891) | Ravenfeather | Rough Quartz | Z-H 24530-24532; WH-P 1521 (8071 + 5175) |

**Windshaper Skyborne (Zephras Isle)** — Z-C r. 90-272.

| q | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|
| 92484 | Rorian the Dayseeker (251361) | Windshaper Boro (251374) | "Examine the Humming Recall Crystal then speak with Windshaper Boro" (geen Requirements in tooltip) | Z-C 95-130; WH-T; SP-C ender 251374; SP-L gever 251361 |
| 92466 | Boro | Boro | /1 Signet of Akir 251924 (Al'Aketh Convert 251160) | Z-C 197-200, 228-230; WH-T |
| 92467 | Boro | Minor Manifestation of Earth (**251166**, ander id dan 5891) | Earth Sapta drinken bij "Rise of Spirits" | Z-C 238-243; WH-T; SP-Q complete |
| 92468 | Minor Manifestation of Earth (251166) | Boro | Rough Quartz | Z-C 270-271; WH-P 92468 (8071 + 5175, +50 Windshapers-rep); SP-C ender 251374 |

**Dwarf (Dun Morogh)** — Z-A r. 1609, 1754-1902.

| q | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|
| 98581 "Archaic Rune" (alt **96243**) | Sten Stoutarm (658); 96243 van Eldrun Stormbreaker (258098) of Ingrid Dunwald (258113) | Teo Hammerstorm (257446) | brief/breadcrumb | Z-A 1609, 1759-1762; SP-C 98581 prev 179 ender 257446 races 4; SP-Q accept "Ingrid Dunwald"/"Eldrun Stormbreaker" = 96243; SP-L 96243 = 258098; WH-T 96243 "Find Teo Hammerstorm in Dun Morogh" |
| 94373 | Teo | Teo | /1 2× Iceclaw Bear Pendant 264356 (Frostmane Troll Whelp 706) | Z-A 1852-1856, 1883-1886; WH-T (tekst zegt "Frostmane Bear Pendants", eis heet Iceclaw: Blizzard-tekst, ook warcrafttavern) |
| 94374 | Teo | Minor Manifestation of Earth (5891) bij de Spirit Stone | Earth Sapta drinken | Z-A 1889-1895; WH-T; SP-C ender 5891 |
| 94375 | Minor Manifestation (5891) | Teo | Rough Quartz | Z-A 1899-1901; WH-P 94375 (8071 + 5175); SP-L gever 5891 |

- 96243 als `alt`: AFGELEID. Wowhead's reeks op 94375 begint met 96243 (GEMETEN WH-P), Spoken zet 94373 prev = 98581
  (GEMETEN SP-C). Of 94373 één van de twee eist: niet gemeten.
- Earth Sapta kwijt: herhaalquests 1463 (Canaga), 1462 (Ravenfeather), 94472 (Teo) (GEMETEN WH-T + SP-Q complete);
  voor Skyborne niets gevonden. Niet in de keten zetten (AFGELEID: het zijn bijquests).

### 4b. Fire (level 10) — drie routes

**Orc/Troll en Tauren (zelfde keten, andere starter)** — Z-H r. 24570-24653.

| q | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|
| 2983 (Orc/Troll) / 2984 (Tauren); alts 1522, 1523 | 2983 Swart (3173, Razor Hill); 2984 Narm Skychaser (3066, Bloodhoof); 1522 Searn Firewarder (5892, Orgrimmar); 1523 Xanis Flameweaver (5906, Thunder Bluff) | Kranal Fiss (5907) | "Find Kranal Fiss in the Barrens" | Z-H 24571-24588; WH-T (alle vier dezelfde tekst); SP-L gevers; WH-P 1527-reeks "1522, 1523, 2983, 2984" |
| 1524 | Kranal Fiss | Telf Joolam (5900) | Torch of the Dormant Flame 6653 brengen | Z-H 24597-24600; WH-T |
| 1525 | Telf | Telf | /1 Fire Tar 5026 (Razormane, Barrens), /2 Reagent Pouch 6652 (Burning Blade Cultist 3199, grot) | Z-H 24605-24619; WH-T (volgorde Fire Tar, Reagent Pouch) |
| 1526 | Telf | **object** Brazier of the Dormant Flame (61934) | /1 Glowing Ember 6655: Fire Sapta 6636 drinken, Minor Manifestation of Fire 5893 verslaan | Z-H 24636-24646; WH-T; SP-C enderObject 61934 |
| 1527 | **object** Brazier (61934) | Kranal Fiss | Torch of the Eternal Flame 6654 brengen | Z-H 24644-24652; WH-P 1527 (3599 + 5176 + 263412); SP-L object 61934 |

- Windshaper mag 1522/1523/1524/2983/2984 niet (GEMETEN Spoken races 178) → eigen keten hieronder.
- Fire Sapta kwijt: 1464 (Telf) (GEMETEN WH-T).

**Windshaper Skyborne (Zephras Isle)** — Z-C r. 1003-1099.

| q | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|
| 97243 | Sessaria Skystride (252382) **of** Aarnor Galestrike (254082) | Olariaan Swiftburn (268592) | Torch of Dormant Flame brengen | Z-C 1003-1013 (Sessaria); SP-Q accept Sessaria én Aarnor = 97243; SP-L gever 254082; WH-T 98517 noemt beide; SP-C ender 268592 |
| 97244 | Olariaan | Olariaan | /1 Faladiel's Heart 277267 (Skypriest Faladiel 268602) | Z-C 1026-1027; WH-T |
| 97245 | Olariaan | Olariaan | /1 Kuramaa's Mask 277269 (Kuramaa's Stump klikken, Kuramaa 268605 verslaan) | Z-C 1047-1049; WH-T |
| 97257 | Olariaan | Sessaria Skystride | /1 "Complete the Ritual with Olariaan" (Torch of Eternal Flame 277329 gebruiken), /2 "Light the Brazier of Eternal Flame" (**met timer**) | Z-C 1081-1098; WH-T; WH-P 97257 (3599 + 5176 + 263412, +25 rep); SP-C ender 252382 |

- 98517 "Report to Sessaria Skystride or Aarnor Galestrike" start uit het item Torch of the Dormant Flame 6653
  (GEMETEN SP-L item-lookup + WH-T). Een breadcrumb: niet in de keten zetten (AFGELEID: als `alt` van 97243 zou MH
  naar Olariaan wijzen terwijl hij naar Sessaria moet).

**Dwarf (Dun Morogh + Loch Modan)** — Z-A r. 2360-2639, 5340-5514.

| q | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|
| 94449 | Ingrid Dunwald (258113, Kharanos) of Eldrun Stormbreaker (258098, Ironforge) | Bruegs Kindleborn (257597) | "Find Bruegs Kindleborn in Dun Morogh" | Z-A 2360-2362, 2592-2595; SP-Q accept beide; SP-L 258113 |
| 94465 | Bruegs | Braldir Ashmantle (257808) | Torch of the Dormant Flame brengen | Z-A 2596, 2635-2637; WH-T |
| 94466 | Braldir | Braldir | /1 Fire Tar 5026 (Tunnel Rat Geomancer 1174, Silver Stream Mine), /2 Reagent Pouch 6652 (Stonesplinter Seer 1166) | Z-A 5340-5342, 5482-5484; WH-T |
| 94467 | Braldir | **object** Brazier of the Dormant Flame (61934) | /1 Glowing Ember (Fire Sapta, Minor Manifestation of Fire) | Z-A 5496-5504; SP-C enderObject 61934 |
| 94468 | **object** Brazier (61934) | Bruegs | Torch of the Eternal Flame | Z-A 5505-5513; WH-P 94468 (3599 + 5176 + 263412); SP-L object 61934 |

- Fire Sapta kwijt: 94473 (Braldir) (GEMETEN WH-T).

### 4c. Water (level 20) — twee routes

**Horde (Orc, Troll, Tauren én Windshaper)** — Z-H r. 24656-24737.

| q | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|
| 1528; alts 1529, 2985, 2986 | 1528 Searn Firewarder (5892); 1529 Xanis Flameweaver (5906); 2985 Swart (3173); 2986 Narm Skychaser (3066) | Islen Waterseer (5901) | naar Islen | Z-H 24657-24666; SP-L gevers; SP-C ender 5901 |
| 1530 | Islen | Brine (5899) | naar Brine | Z-H 24665-24673 |
| 1535 | Brine | Brine | /1 Filled Brown Waterskin 7769 (Empty Brown Waterskin 7766 gebruiken) | Z-H 24676-24684 |
| 1536 | Brine | Brine | /1 Filled Red Waterskin 7771 (Empty Red 7768), Hillsbrad | Z-H 24686-24695 |
| 1534 | Brine | Brine | /1 Filled Blue Waterskin 7770 (Empty Blue 7767), Ashenvale | Z-H 24697-24707 |
| 220 | Brine | Islen | Vial of Purest Water | Z-H 24707-24713; SP-C ender 5901 |
| 63 | Islen | **object** Brazier of Everfount (113791) | /1 Corrupt Manifestation's Bracers 7812 (Water Sapta 6637 drinken, Corrupt Water Manifestation 5894 verslaan) | Z-H 24715-24726; SP-C enderObject 113791 |
| 100 | **object** Brazier of Everfount | Minor Manifestation of Water (5895) | praten (na de dialoog) | Z-H 24728-24732; SP-L object 113791; SP-C ender 5895 |
| 96 | Minor Manifestation of Water (5895) | Islen | Shard of Water 7813 | Z-H 24734-24736; WH-P 96 (5394 + 5177); SP-L gever 5895 |

- Windshaper mag 1528/1530-1536/220/63/100/96 (GEMETEN Spoken races met bit 33); er is geen Skyborne-water-quest
  gevonden (SP-C "Call of Water" heeft 63, 96, 100, 220, 1103, 1528-1536, 2985, 2986, 94494-94505: positieve controle
  in dezelfde zoekactie). Dat Windshapers deze route lopen: AFGELEID (sterk).
- 1103 (Tiev Mordune 7007): "Bring a Water Sapta ... if you failed to speak to the Minor Manifestation of Water"
  (GEMETEN WH-T). Herstelquest, niet in de keten. 972 (Islen) = nieuwe Water Sapta (GEMETEN WH-T).

**Dwarf (Ironforge → Loch Modan → Wetlands → Redridge → Ashenvale → Westfall)** — Zygor heeft alleen de start (Z-A
6654-6655); rest uit Spoken + Wowhead + Polestar.

| q | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|
| 94494 | Eldrun Stormbreaker (258098) of Ingrid Dunwald (258113) | Norric Lochthane (258043) | naar Norric | Z-A 6654-6655; SP-Q accept beide; SP-C ender 258043; WH-T |
| 94495 | Norric | Hervdana Saegrund (258203) | naar Hervdana | SP-Q accept "Norric Lochthane"; SP-L 258043; SP-C ender 258203; WH-T |
| 94497 | Hervdana | Hervdana | /1 Full Brown Waterskin 265734 (Unfilled Brown 265732), onder de watervallen bij haar grot | WH-T; WH-P; SP-L 258203 |
| 94499 | Hervdana | Hervdana | /1 Full Red Waterskin 265748 (Unfilled Red 265747), Stonewatch Falls, Redridge, bij de Nightcrawler-murlocs | WH-T; WH-P; SP-L |
| 94500 | Hervdana | Hervdana | /1 Full Blue Waterskin 265773 (Unfilled Blue 265772), meer bij Astranaar, Ashenvale | WH-T; WH-P; SP-L |
| 94501 | Hervdana | Norric | Vial of Purest Water 7810; beloning Water Sapta 6637 | WH-T; WH-P; SP-L 258203; SP-C ender 258043 |
| 94502 | Norric | **object** Forgotten Shrine (619896) | /1 Corrupt Manifestation's Bracers 7812 (Water Sapta drinken, Corrupt Minor Manifestation of Water 5894 verslaan; Remaining Drops of Purest Water 7811 provided) | WH-T; SP-L 258043; SP-Q complete "Forgotten Shrine" = 94502; Polestar "this, not Norric, ends the quest" |
| 94503 | **object** Forgotten Shrine (619896) | Minor Manifestation of Water (5895) naast de vijver | praten (hij verschijnt pas na een tijdje) | WH-T; SP-L object 619896; SP-Q accept "Forgotten Shrine" = 94503, complete "Minor Manifestation of Water" = 94503; Polestar; gitm.gg |
| 94505 | Minor Manifestation of Water (5895) | Norric | Shard of Water 7813 | WH-T; WH-P 94505 (5394 + 5177); SP-L 5895 |

- WH-P 94502 zegt "End: Norric" en WH-P 94503 zegt "Start: Minor Manifestation" — dat haalde de WebFetch-samenvatting
  uit de verhaaltekst; Spoken (gever/inleveraar per NPC/object) en Polestar zeggen shrine. Gekozen: Spoken.
- Water Sapta kwijt: 94616 (Norric) (GEMETEN WH-T, SP-Q complete).
- Bug-meldingen: gitm.gg (15 nov) noemt Blizzards hotfix van 10 nov voor "Call of Water ... final quests"; de geest kan
  even op zich laten wachten. GEMETEN (gids), niet in-game.

### 4d. Air (level 30) — item, geen spell

| q | Factie | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|---|
| 1531; alts 1532, 96136 | Horde | 1531 Searn Firewarder (5892); 1532 Xanis Flameweaver (5906); 96136 Alaana Stormwalker (259119, Mulgore, Skywatcher Plateau) | Prate Cloudseer (5905) | "Find Prate Cloudseer in Thousand Needles" | Z-H 24741-24750; SP-L gevers; SP-C ender 5905; WH-T (alle drie); WH-P (Air Totem 5178) |
| 94789 | Alliance (Dwarf) | Eldrun Stormbreaker (258098) | **Veyric Thunderhame** (259023), Arathi | "Find Veyric Thundervein in Arathi Highlands" | SP-L 258098; SP-Q complete "Veyric Thunderhame" = 94789; WH-T; WH-P (Air Totem 5178) |

- Naamverschil: de questtekst zegt "Thundervein", de NPC heet "Thunderhame" (GEMETEN: WH-T quest 94789 én WH-T npc
  259023; warcrafttavern zegt hetzelfde). MH moet de NPC-naam tonen.
- 96136 lijkt de Windshaper-variant (Alaana = Windshapers, landingsplek Skyborne): AFGELEID.

### 4e. Elemental Mastery (Horde, level 52) — item-keten

| q | Gever | Inleveraar | Doel | Bron |
|---|---|---|---|---|
| 8410 (alt **8411**) | 8410 Beram Skychaser (3032, Thunder Bluff) of Sagorne Creststrider (13417, Orgrimmar); 8411 Bath'rah zelf (6176) | Bath'rah the Windwatcher (6176) | Elemental Air 7069, Fire 7068, Earth 7067, Water 7070 (8410-volgorde Air, Fire, Earth, Water; 8411-volgorde Air, Earth, Fire, Water) | Z-H 24752-24781; SP-Q accept Beram + Sagorne = 8410; SP-L 8410 = 13417, 8411 = 6176; WH-T beide; WH-P 8411-reeks "8410, 8411, 8412" |
| 8412 | Bath'rah | Bath'rah | /1 8× Bloodshot Spider Eye 20610, /2 8× Thick Black Claw 20611 (Western Plaguelands) | Z-H 24783-24798; WH-T |
| 8413 | Bath'rah | Bath'rah | /1 2× Amber 20606, /2 2× Blue 20607, /3 2× Green Voodoo Feather 20608 (Sunken Temple, groep) | Z-H 24800-24840; WH-T; WH-P: kies Azurite Fists 20369 / Enamored Water Spirit 20503 / Wildstaff 20556 |

- Alliance: Spoken zet 8410/8412/8413 op Horde-maskers en 8411 zonder ras (GEMETEN SP-C); Zygor heeft geen Alliance-
  versie (grep "Elemental Mastery" Alliance: niets; positieve controle Horde-gids r. 24776 in dezelfde zoekactie).
  Advies: alleen Horde bouwen. Dat Dwarfs hem niet krijgen: AFGELEID, niet gemeten.
- Level 52: Zygor "ding 52" (r. 24752) en Wowhead-XP-calculator level=52 (GEMETEN). Het minimumlevel: niet gemeten.
- De drie beloningsitems 20369/20503/20556 kwamen **niet** terug uit DB2 ItemSparse 70938 (52 van de 55 gevraagde id's
  wel, positieve controle). Oorzaak niet gemeten; voor MH niet nodig.

### 4f. The Tempest's Weapons (30-40) — NIET bouwen, nog te veel open

GEMETEN: Horde-reeks 79360 Elemental Aid → 79364 Eyes on the Sky → 79361 Storm, Earth, and Fire → 79366 Heed My Call →
79442 The Tempest's Weapons (WH-P 79442); Alliance-reeks 94789 → 96264 → 79358 → 96135 → 96016 (WH-P 96016). Beloning:
kies Lightning's Grasp 280607 / Tidebringer's Claw 280605 / Rage of the Storm 280604, plus Elementalist's Guard 280696
(Horde-pagina ook Rune of the Storm 213086) (WH-P, namen DB2 ItemSparse). Gevers (SP-L): 79360 = Prate (5905),
79364 = Rau Cliffrunner (4722), 79361 = Prate, 79366 = Prate, 79442 = Rau; Alliance 96264/79358/96135/96016 = Veyric
(259023); 79365 "With Wind Beneath Your Wings" = Bath'rah → Rau (los van de reeks). Doelen (WH-T): Charlga Razorflank in
Razorfen Kraul (Tattered Note); 5× Twisted Fire/Earth/Air/Water Totem; ritueel met Eye of the Tempest (level 40, elite).
Open: de Horde-inleveraars (gidsen spreken elkaar tegen), de drop-plekken van de Twisted Totems (expcarry en mmojugg
noemen andere mobs en coördinaten), de plek van het ritueel ("steam pools", geen gemeten coördinaat). Zelfde keuze als
bij de warrior ("Not built yet: places unknown").

## 5. Plekken

Regel: Rob > HandyNotes > Zygor > gids; voor NPC's zonder Zygor-coördinaat de Wowhead-spawn (zoals bij de warlock).
UiMap GEMETEN (DB2 UiMap 70938): Durotar 1411, Mulgore 1412, The Barrens 1413, Alterac Mountains 1416, Arathi Highlands
1417, Silverpine Forest 1421, Western Plaguelands 1422, Hillsbrad Foothills 1424, Dun Morogh 1426, Loch Modan 1432,
Redridge Mountains 1433, Swamp of Sorrows 1435, Westfall 1436, Wetlands 1437, Ashenvale 1440, Thousand Needles 1441,
Orgrimmar 1454, Ironforge 1455, Thunder Bluff 1456, Zephras Isle 2521. Dat Wowhead-coördinaten in UiMap-ruimte staan:
AFGELEID (Zygor en Wowhead liggen bij alle vergeleken NPC's binnen 0,2: Boro, Olariaan, Kranal, Telf, Prate, Islen).

| Sleutel | NPC / object (id) | UiMap | x | y | Bron |
|---|---|---|---|---|---|
| canaga | Canaga Earthcaller (5887) | 1411 | 42.41 | 69.17 | Z-H 24536 (Wowhead 42.4,69) |
| felstalkers | — | 1411 | 44.82 | 54.59 | Z-H 24541 ("Inside the cave") |
| earthDurotar | Minor Manifestation of Earth (5891) | 1411 | 44.03 | 76.20 | Z-H 24555 (pad: 43.57,69.85 → 41.56,73.28 → 40.74,74.35 → 42.49,74.89) |
| ravenfeather | Seer Ravenfeather (5888) | 1412 | 44.35 | 76.76 | Z-H 24511 |
| bristleback | — | 1412 | 60.30 | 80.23 | Z-H 24516 (ook 59.92,75.65) |
| earthMulgore | Minor Manifestation of Earth (5891) | 1412 | 51.97 | 80.41 | Z-H 24527 |
| sten | Sten Stoutarm (658) | 1426 | 29.93 | 71.20 | Z-A 1595 |
| teo | Teo Hammerstorm (257446) | 1426 | [stond in HandyNotes] | [stond in HandyNotes] | HN r. 58 (Zygor 28.79,66.19 "Upstairs") |
| whelps | — | 1426 | 26.80 | 79.86 | Z-A 1855 |
| earthDunMorogh | Minor Manifestation of Earth (5891) | 1426 | 24.89 | 61.86 | Z-A 1894 (pad omhoog 26.56,67.54, r. 1890) |
| rorian | Rorian the Dayseeker (251361) | 2521 | 42.06 | 23.48 | Z-C 90 |
| boro | Windshaper Boro (251374) | 2521 | [stond in HandyNotes] | [stond in HandyNotes] | HN r. 324 |
| converts | — | 2521 | 46.72 | 19.83 | Z-C 199 |
| earthZephras | Minor Manifestation of Earth (251166) | 2521 | 49.67 | 23.83 | Z-C 242 (pad 48.11,25.78) |
| swart | Swart (3173) | 1411 | [stond in HandyNotes] | [stond in HandyNotes] | HN r. 77 |
| narm | Narm Skychaser (3066) | 1412 | [stond in HandyNotes] | [stond in HandyNotes] | HN r. 160 |
| kranal | Kranal Fiss (5907) | 1413 | 56.03 | 19.89 | Z-H 24586 |
| telf | Telf Joolam (5900) | 1411 | 38.55 | 58.96 | Z-H 24599 (bovenop de berg, pad vanaf 36.59,57.07) |
| razormane | — | 1413 | 54.15 | 25.01 | Z-H 24607 |
| dustwind | — | 1411 | 52.12 | 24.95 | Z-H 24619 (grotingang 52.82,28.82) |
| fireDurotar | — | 1411 | 38.84 | 58.24 | Z-H 24641 |
| brazierDurotar | Brazier of the Dormant Flame (obj 61934) | 1411 | 38.95 | 58.22 | Z-H 24646 |
| sessaria | Sessaria Skystride (252382) | 2521 | 58.20 | 78.50 | HN r. 323 |
| aarnor | Aarnor Galestrike (254082) | 2521 | 43.50 | 44.80 | HN r. 322 (alleen ter info) |
| olariaan | Olariaan Swiftburn (268592) | 2521 | 51.24 | 86.19 | Z-C 1012 |
| faladiel | — | 2521 | 64.46 | 63.71 | Z-C 1027 |
| kuramaa | — | 2521 | 42.39 | 68.89 | Z-C 1049 |
| ritual | — | 2521 | 51.20 | 86.01 | Z-C 1088 |
| brazierEternal | — (Wowhead: npc 268679) | 2521 | 58.35 | 78.83 | Z-C 1094 |
| ingrid | Ingrid Dunwald (258113) | 1426 | [stond in HandyNotes] | [stond in HandyNotes] | HN r. 57 |
| bruegs | Bruegs Kindleborn (257597) | 1426 | 87.56 | 43.65 | Z-A 2595 (pad omhoog 86.90,46.97; kleine grot) |
| braldir | Braldir Ashmantle (257808) | 1432 | 32.16 | 65.99 | Z-A 2637 (pad 32.10,58.53) |
| silverStream | — | 1432 | 35.48 | 18.86 | Z-A 5342 (in de mijn) |
| stonesplinter | — | 1432 | 35.14 | 84.04 | Z-A 5484 (warcrafttavern 31.0,77.4) |
| fireLoch | — | 1432 | 31.90 | 64.34 | Z-A 5499 |
| brazierLoch | Brazier of the Dormant Flame (obj 61934) | 1432 | 31.79 | 64.52 | Z-A 5504 (Wowhead-object 31.9,64.4) |
| searn | Searn Firewarder (5892) | 1454 | 37.96 | 37.74 | Z-H 24662 |
| islen | Islen Waterseer (5901) | 1413 | 65.83 | 43.78 | Z-H 24666 |
| brine | Brine (5899) | 1413 | 43.42 | 77.41 | Z-H 24673 |
| skinBrownH | — | 1413 | 44.19 | 76.90 | Z-H 24678 |
| skinRedH | — | 1424 | 62.15 | 20.75 | Z-H 24688 |
| skinBlueH | — | 1440 | 33.55 | 67.44 | Z-H 24700 |
| corruptSP | — | 1421 | 38.84 | 44.25 | Z-H 24721 |
| everfount | Brazier of Everfount (obj 113791) | 1421 | 38.28 | 44.56 | Z-H 24725 (Wowhead-object 38.2,44.5) |
| waterSP | Minor Manifestation of Water (5895) | 1421 | 38.75 | 44.62 | Z-H 24731 |
| eldrun | Eldrun Stormbreaker (258098) | 1455 | 47.40 | 13.40 | HN r. 135 |
| norric | Norric Lochthane (258043) | 1432 | 41.8 | 19.0 | Wowhead-spawn (WH-T); gidsen 41.9,19.0 |
| hervdana | Hervdana Saegrund (258203) | 1437 | 65.6 | 76.4 | Wowhead-spawn (2e 65.8,76.6); gidsen 65.7,76.4 |
| skinBrownA | — | 1437 | 65.0 | 74.9 | **alleen gids** gitm.gg 15 nov |
| skinRedA | — | 1433 | 68.6 | 60.6 | **alleen gids** gitm.gg; warcrafttavern zegt 73.7,61.6 |
| skinBlueA | — | 1440 | 32.7 | 50.6 | **alleen gids** gitm.gg; warcrafttavern zegt 37.0,51.6 |
| shrine | Forgotten Shrine (obj 619896) | 1436 | 45.4 | 59.7 | Wowhead-object (2e 45.6,59.9); conquestcapped 45.5,60.0 |
| waterWF | Minor Manifestation of Water (5895) | 1436 | 46.3 | 59.3 | **alleen gids** gitm.gg ("I spoke to the spirit at 46.3, 59.3"); Polestar "beside the shrine" |
| prate | Prate Cloudseer (5905) | 1441 | 53.54 | 42.65 | Z-H 24749 |
| veyric | Veyric Thunderhame (259023) | 1417 | 59.8 | 27.4 | Wowhead-spawn (2e 59.8,27.6); pad omhoog vanaf 60.5,35.2 → 60.5,31.5 (warcrafttavern) |
| alaana | Alaana Stormwalker (259119) | 1412 | 33.35 | 22.54 | Z-C 1631 (alleen ter info) |
| beram | Beram Skychaser (3032) | 1456 | [stond in HandyNotes] | [stond in HandyNotes] | HN r. 263 (Zygor 22.80,19.40) |
| sagorne | Sagorne Creststrider (13417) | 1454 | [stond in HandyNotes] | [stond in HandyNotes] | HN r. 181 (alleen ter info) |
| bathrah | = `WR_P.bathrah` (6176) | 1416 | 80.50 | 66.92 | al in de code |
| spiders | — | 1422 | 33.60 | 60.40 | Z-H 24786 (ook 58.40,53.60) |
| sunken | = `P.sunken` | 1435 | 69.36 | 56.89 | al in de code |

## 6. Objective-index

`idx` = plaats in `C_QuestLog.GetQuestObjectives`. GEMETEN is de volgorde in Wowhead-tooltip ("Requirements") en/of
Zygor `q <id>/<n>`; dat die gelijk is aan de client-index: **AFGELEID** (zoals bij druid/warrior).

| Quest | idx | Objective | Bron van de volgorde |
|---|---|---|---|
| 1516 | 1 | Felstalker Hoof ×2 | Zygor `q 1516/1` + WH-T |
| 1519 | 1 | Ritual Salve ×2 | Zygor `q 1519/1` + WH-T |
| 94373 | 1 | Iceclaw Bear Pendant ×2 | Zygor `q 94373/1` + WH-T |
| 92466 | 1 | Signet of Akir | Zygor `q 92466/1` + WH-T |
| 1517, 1520, 94374, 92467 | — | geen objective (sapta drinken) | WH-T toont geen Requirements; voorstel: textKey zonder idx (zoals warrior 1719) |
| 1525 | 1 / 2 | Fire Tar / Reagent Pouch | Zygor `/1`, `/2` + WH-T |
| 94466 | 1 / 2 | Fire Tar / Reagent Pouch | Zygor `/1`, `/2` + WH-T |
| 1526 | 1 | Glowing Ember | Zygor `q 1526/1` + WH-T |
| 94467 | 1 | Glowing Ember | Zygor `q 94467/1` + WH-T |
| 97244 | 1 | Faladiel's Heart | Zygor `q 97244/1` + WH-T |
| 97245 | 1 | Kuramaa's Mask | Zygor `q 97245/1` + WH-T |
| 97257 | 1 / 2 | Ritual with Olariaan / Light the Brazier of Eternal Flame | Zygor `/1`, `/2` + WH-T |
| 1535 / 1536 / 1534 | 1 | Filled Brown / Red / Blue Waterskin | Zygor `/1` |
| 63 | 1 | Corrupt Manifestation's Bracers | Zygor `q 63/1` |
| 94497 / 94499 / 94500 | 1 | Full Brown / Red / Blue Waterskin | WH-T (één eis) |
| 94502 | 1 | Corrupt Manifestation's Bracers | WH-T (één eis) |
| 8410 | items | Elemental Air 7069, Fire 7068, Earth 7067, Water 7070 | WH-T; via `items` omdat 8411 een andere volgorde heeft (Air, Earth, Fire, Water) |
| 8412 | 1 / 2 | Bloodshot Spider Eye ×8 / Thick Black Claw ×8 | Zygor `/1`, `/2` + WH-T |
| 8413 | 1 / 2 / 3 | Amber / Blue / Green Voodoo Feather ×2 | Zygor `/1-3` + WH-T (deDE-tooltip zelfde volgorde) |

## 7. NPC- en objectnamen per taal

GEMETEN: Wowhead Forever tooltips per locale (WH-T, 17 nov), controle npc 233 in elke run: deDE "Bauer Saldean", frFR
"Saldean le fermier", esES/esMX "Granjero Saldean", ptBR "Fazendeiro Saldanha", ruRU "Фермер Сальден". Haken
(positieve controle: esMX gaf "[Brine]") = Wowhead heeft hem niet → weggelaten ("—"). esMX-gat gevuld uit SP-N waar
Spoken hem heeft (alleen 5899). Engels-ogende de/fr-namen kwamen zonder haken terug = die client-naam. Bath'rah 6176 staat
al in `NPC_NAMES`.

| id | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 5887 | Canaga Earthcaller | Canaga Earthcaller | Canaga Earthcaller | Clamor de Tierra Canaga | Canaga Clamatierras | Ranago Arauto da Terra | Канага заклинатель земли |
| 5888 | Seer Ravenfeather | Seherin Ravenfeather | Prophétesse Ravenfeather | Profeta Plumacuervo | Vidente Pluma de Cuervo | Vidente Pena do Corvo | Провидица Воронье Перо |
| 5891 | Minor Manifestation of Earth | Schwache Erdmanifestation | Manifestation de terre mineure | Manifestación de tierra menor | — | Manifestação Menor de Terra | Низшее воплощение земли |
| 251166 | Minor Manifestation of Earth | Schwache Erdmanifestation | Manifestation de terre mineure | Manifestación de tierra menor | — | — | Низшее воплощение земли |
| 3173 | Swart | Swart | Swart | Swart | Swart | Swart | Злобр |
| 3066 | Narm Skychaser | Narm Skychaser | Narm Skychaser | Narm Cazacielo | Narm Cazacielo | Narm Persegue-céus | Нарм Небесный Охотник |
| 5892 | Searn Firewarder | Searn Firewarder | Searn Firewarder | Searn Guardafogo | Searn Guardafogo | Searn Guardafogo | Огнир хранитель Огня |
| 5906 | Xanis Flameweaver | Xanis Flameweaver | Xanis Flameweaver | Xanis Tejellama | Xanis Tejedor de Fuego | Xanis Tecedor de Chamas | Ксаварик |
| 5907 | Kranal Fiss | Kranal Fiss | Kranal Fiss | Kranal Fiss | Kranal Fiss | Kranal Fiss | Кранал Фисс |
| 5900 | Telf Joolam | Telf Joolam | Telf Joolam | Telf Joolam | Telf Joolam | Telf Joolam | Телф Джулам |
| 5901 | Islen Waterseer | Islen Waterseer | Islen Waterseer | Islen Vident'aqua | Islen Vidente del Agua | Islen Vidente da Água | Ислен Заклинатель Воды |
| 5899 | Brine | Brine | Brine | Salmuera | Salmuera (SP-N) | Salma | Брин |
| 5895 | Minor Manifestation of Water | Schwache Wassermanifestation | Manifestation d'eau mineure | Manifestación de agua menor | — | Manifestação Menor da Água | Низшее воплощение воды |
| 5905 | Prate Cloudseer | Prate Cloudseer | Prate Cloudseer | Prate Nubeprofeta | Prate Vidente de las Nubes | Pradosa Fita Nuvens | Пратта Заклинательница Туч |
| 3032 | Beram Skychaser | Beram Skychaser | Beram Skychaser | Beram Cazacielo | Beram Cazacielo | Beram Persegue-céus | Берам Небесный Охотник |
| 251361 | Rorian the Dayseeker | Rorian der Tagsucher | Rorian le Cherchejour | Rorian el Buscadía | Rorian, el Buscadías | Rorian, o Caça-alva | Рориан Искатель Утра |
| 251374 | Windshaper Boro | Windformer Boro | Sculpte-vent Boro | Formavientos Boro | Formavientos Boro | Moldavento (sic, zie §9) | Ваятель Ветра Боро |
| 252382 | Sessaria Skystride | Sessaria Skystride | Sessaria Marcheciel | Sessaria Caminante del Cielo | Sessaria Zancacielo | Sessaria Andacéu | Сессария Небесная Странница |
| 268592 | Olariaan Swiftburn | Olariaan Swiftburn | Olariaan Vivebrûle | Olariaan Ardeveloz | Olariaan Fuegoveloz | Olariaan Queimabreve | Олариан Быстрая Вспышка |
| 658 | Sten Stoutarm | Sten Stoutarm | Sten Stoutarm | Sten Brazofuerte | Sten Brazorrecio | Sten Braçoforte | Стен Крепкорук |
| 257446 | Teo Hammerstorm | Teo Hammerstorm | Teo Martel-tempête | Teo Mazatormenta | Teo Mazatormenta | Teo Tempestelo | Тео Молотошторм |
| 258113 | Ingrid Dunwald | Ingrid Dunwald | Ingrid Dunwald | Ingrid Montocre | Ingrid Montocre | Ingrid Dunwald | Ингрид Дунвальд |
| 258098 | Eldrun Stormbreaker | Eldrun Stormbreaker | Eldrun Brise-tempête | Eldrun Rompetormentas | — | Eldrun Rompe-procelas | Элдрун Тучегон |
| 257597 | Bruegs Kindleborn | Bruegs Kindleborn | Bruegs Flammené | Bruegs Prendecirios | Bruegs Sangrellamas | Bruegs Igninato | Брюкс Дитя Искр |
| 257808 | Braldir Ashmantle | Braldir Ashmantle | Braldir Houppecendre | Braldir Mantoceniza | — | — | Бралдир Пеплоплащ |
| 258043 | Norric Lochthane | Norric Lochthane | Norric Lochthane | Norric Lochthane | Norric Lagolord | Norric Lochthane | Норрик Тан Лока |
| 258203 | Hervdana Saegrund | Hervdana Saegrund | Hervdana Saegrund | Hervdana Saegrund | — | — | Гервдана Саэгрунд |
| 259023 | Veyric Thunderhame | Veyric Thunderhame | Veyric Hametonne | Veyric Tronador | Veyric Horcatrueno | Veyric Tonitrular | Вейрик Громоцеп |

Alleen ter info (niet als from/to in de schets): 254082 Aarnor Galestrike (de Aarnor Galestrike, fr Aarnor Coup-de-Vent,
esES Aarnor Choquevendaval, esMX Aarnor Ventinazo, pt Aarnor Ventataque, ru Аарнор Удар Шторма); 259119 Alaana
Stormwalker (de Alaana Stormwalker, fr Alaana Marchetempête, esES Alaana Caminatormentas, esMX —, pt Alaana Tempesvaga,
ru Алаана Штормовой Полет); 13417 Sagorne Creststrider (de idem, fr idem, esES Sagorne Zancresta, esMX Sagorne Zanca
Cresta, pt Sagorne Monta Crista, ru Сагорн Гривастый Странник); 4722 Rau Cliffrunner (de/fr idem, esES/esMX Rau
Abiscorredor, pt Rau Corta Montes, ru Рау Скальный Бегун).

**Objecten** (WH-T object-tooltips per locale; esMX 61934 ook SP-N "Blandón de la Llama Latente"):

| obj | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 61934 | Brazier of the Dormant Flame | Kohlenpfanne der schlafenden Flamme | Brasero de la Flamme Dormante | Blandón de la Llama Latente | Blandón de la Llama Latente | Braseiro da Chama Latente | Жаровня Дремлющего Пламени |
| 113791 | Brazier of Everfount | Kohlenpfanne von Everfount | Brasero d'Everfount | Blandón de Siemprefuente | — | Braseiro da Fonteterna | Жаровня Вечного источника |
| 619896 | Forgotten Shrine | Vergessener Schrein | Sanctuaire oublié | Santuario olvidado | Santuario olvidado | Santuário Esquecido | Забытое святилище |

**Itemnamen voor een ketennaam** (DB2 ItemSparse 70938 per locale; controle 6948 = Ruhestein / Pierre de foyer /
Piedra de hogar / Pedra de Regresso / Камень возвращения):

| item | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 5175 | Earth Totem | Erdtotem | Totem de terre | Tótem de tierra | Tótem de tierra | Totem da Terra | Тотем земли |
| 5176 | Fire Totem | Feuertotem | Totem de feu | Tótem de Fuego | Tótem de fuego | Totem do Fogo | Тотем огня |
| 5177 | Water Totem | Wassertotem | Totem d'eau | Tótem de agua | Tótem de agua | Totem da Água | Тотем воды |
| 5178 | Air Totem | Lufttotem | Totem d'air | Tótem de aire | Tótem de aire | Totem do Ar | Тотем воздуха |

Questtitels (WH-T per locale): 1531 Call of Air = Ruf der Luft / L'appel de l'air / La llamada del aire (esES, esMX) /
Clamor do ar / Зов воздуха. 8410 Elemental Mastery = Elementarbeherrschung / La maîtrise des éléments / Maestría
elemental (esES, esMX) / Mestre dos elementos / Покорение стихий. 8413 Da Voodoo = Die Macht des Voodoos / Vaudou ! /
Vudú (esES, esMX) / O Vodu / Вуду. 96016 The Tempest's Weapons = Die Waffen des Sturmgewitters / Les armes de la
tempête / esES+esMX+ptBR — / Оружие урагана.

## 8. Zygor-fouten en -gaten

1. `ZygorLevelingHordeCLASSIC.lua:24805`: de Sunken-Temple-stap van de **shaman** zegt `|confirm |q 8425`; 8425 is de
   warrior-quest (Voodoo Feathers, zie `ForeverClassQuests.lua` r. 549). Moet 8413 zijn. GEMETEN (regel).
2. `ZygorLevelingHordeCLASSIC.lua:24588-24652`: Call of Fire 1524-1527 staat op `|only if Shaman`, dus ook voor
   Windshaper Skyborne, terwijl Spoken 1522/1523/1524/2983/2984 op races 178 zet (zonder Windshaper). AFGELEID
   (Spoken-masker GEMETEN, in-game niet).
3. `ZygorLevelingCommonCLASSIC.lua:1049`: `|q 97245/1 |q 97245/1` dubbel (onschuldig). GEMETEN.
4. `ZygorLevelingCommonCLASSIC.lua:95` en `:98`: dezelfde `accept Embracing the Elements##92484` twee keer
   (onschuldig). GEMETEN.
5. Gat: de Alliance-gids neemt Call of Water 94494 aan (r. 6655) maar doet de rest van de keten nooit (grep
   "Call of Water##" in de Alliance-gids: alleen r. 6655; positieve controle: dezelfde grep vond de Horde-regels). Geen
   Alliance Call of Air (94789) en geen Alliance Elemental Mastery. GEMETEN.
6. Geen fout: Zygor noemt alleen Sessaria als gever van 97243; Aarnor Galestrike geeft hem ook (SP-Q, WH-T 98517).

## 9. Lua-schets (vorm van WR_P / CHAINS.WARRIOR)

Twee kleine code-dingen die de schets nodig heeft (AFGELEID, aan de bouwchat):
- **Objecten als gever/inleveraar** (Brazier of the Dormant Flame, Brazier of Everfount, Forgotten Shrine). Het bestand
  heeft dat nog nergens (GEMETEN: elke `from`/`to` is een NPC). `NpcName(p)` geeft "?" zonder `p.npc`. Voorstel:
  `npc` = Engelse naam + `obj` = object-id, een tabel `OBJ_NAMES` (§7) en in `NpcName`:
  `local row = (p.id and NPC_NAMES[p.id]) or (p.obj and OBJ_NAMES[p.obj])`.
- Sapta-stappen (1517, 1520, 94374, 92467) hebben geen objective: textKey zonder `idx`, zoals warrior 1719. Wat
  `C_QuestLog.IsComplete` voor zo'n quest teruggeeft: niet gemeten; de pijl wijst in beide gevallen naar dezelfde plek.

```lua
--[[ Shaman (17 Nov 2026). All facts: docs/forever/SHAMAN_CLASSQUESTS_2026-11-17.md (mh-research): Zygor Forever
	"Shaman Class Quests" (Horde) + Alliance/Common leveling, Spoken (givers/enders per NPC/object), wago DB2 1.60.1.70938
	(CharBaseInfo: Orc, Tauren, Troll, Dwarf, Windshaper Skyborne 96; no High Order 95), Wowhead Forever (rewards:
	8071/3599/5394 + Earth/Fire/Water Totem, Air Totem item only), HandyNotes. Not copied from Zygor: 8425 in the shaman
	Sunken Temple step (= 8413). Not built: The Tempest's Weapons (30-40, places unknown), sapta replacement quests. ]]
local SH_P = {
	-- Earth: Orc/Troll (Durotar), Tauren (Mulgore), Dwarf (Dun Morogh), Windshaper (Zephras Isle)
	canaga = { npc = "Canaga Earthcaller", id = 5887, m = 1411, x = 42.41, y = 69.17 },
	earthDurotar = { npc = "Minor Manifestation of Earth", id = 5891, m = 1411, x = 44.03, y = 76.20 },
	ravenfeather = { npc = "Seer Ravenfeather", id = 5888, m = 1412, x = 44.35, y = 76.76 },
	earthMulgore = { npc = "Minor Manifestation of Earth", id = 5891, m = 1412, x = 51.97, y = 80.41 },
	sten = { npc = "Sten Stoutarm", id = 658, m = 1426, x = 29.93, y = 71.20 },
	teo = { npc = "Teo Hammerstorm", id = 257446, m = 1426, xy = "stond in HandyNotes" },
	earthDunMorogh = { npc = "Minor Manifestation of Earth", id = 5891, m = 1426, x = 24.89, y = 61.86 },
	rorian = { npc = "Rorian the Dayseeker", id = 251361, m = 2521, x = 42.06, y = 23.48 },
	boro = { npc = "Windshaper Boro", id = 251374, m = 2521, xy = "stond in HandyNotes" },
	earthZephras = { npc = "Minor Manifestation of Earth", id = 251166, m = 2521, x = 49.67, y = 23.83 },
	-- Fire
	swart = { npc = "Swart", id = 3173, m = 1411, xy = "stond in HandyNotes" },
	narm = { npc = "Narm Skychaser", id = 3066, m = 1412, xy = "stond in HandyNotes" },
	kranal = { npc = "Kranal Fiss", id = 5907, m = 1413, x = 56.03, y = 19.89 },
	telf = { npc = "Telf Joolam", id = 5900, m = 1411, x = 38.55, y = 58.96 },
	brazierDurotar = { npc = "Brazier of the Dormant Flame", obj = 61934, m = 1411, x = 38.95, y = 58.22 },
	ingrid = { npc = "Ingrid Dunwald", id = 258113, m = 1426, xy = "stond in HandyNotes" },
	bruegs = { npc = "Bruegs Kindleborn", id = 257597, m = 1426, x = 87.56, y = 43.65 },
	braldir = { npc = "Braldir Ashmantle", id = 257808, m = 1432, x = 32.16, y = 65.99 },
	brazierLoch = { npc = "Brazier of the Dormant Flame", obj = 61934, m = 1432, x = 31.79, y = 64.52 },
	sessaria = { npc = "Sessaria Skystride", id = 252382, m = 2521, x = 58.20, y = 78.50 },
	olariaan = { npc = "Olariaan Swiftburn", id = 268592, m = 2521, x = 51.24, y = 86.19 },
	-- Water
	searn = { npc = "Searn Firewarder", id = 5892, m = 1454, x = 37.96, y = 37.74 },
	islen = { npc = "Islen Waterseer", id = 5901, m = 1413, x = 65.83, y = 43.78 },
	brine = { npc = "Brine", id = 5899, m = 1413, x = 43.42, y = 77.41 },
	everfount = { npc = "Brazier of Everfount", obj = 113791, m = 1421, x = 38.28, y = 44.56 },
	waterSilverpine = { npc = "Minor Manifestation of Water", id = 5895, m = 1421, x = 38.75, y = 44.62 },
	eldrun = { npc = "Eldrun Stormbreaker", id = 258098, m = 1455, x = 47.40, y = 13.40 },
	norric = { npc = "Norric Lochthane", id = 258043, m = 1432, x = 41.8, y = 19.0 },
	hervdana = { npc = "Hervdana Saegrund", id = 258203, m = 1437, x = 65.6, y = 76.4 },
	shrine = { npc = "Forgotten Shrine", obj = 619896, m = 1436, x = 45.4, y = 59.7 },
	waterWestfall = { npc = "Minor Manifestation of Water", id = 5895, m = 1436, x = 46.3, y = 59.3 },
	-- Air, Elemental Mastery
	prate = { npc = "Prate Cloudseer", id = 5905, m = 1441, x = 53.54, y = 42.65 },
	veyric = { npc = "Veyric Thunderhame", id = 259023, m = 1417, x = 59.8, y = 27.4 },
	beram = { npc = "Beram Skychaser", id = 3032, m = 1456, xy = "stond in HandyNotes" },
	-- Objective places (no NPC). Zygor, except the three Alliance waterskins (guide only, gitm.gg 15 Nov 2026).
	felstalkers = { m = 1411, x = 44.82, y = 54.59 },
	bristleback = { m = 1412, x = 60.30, y = 80.23 },
	whelps = { m = 1426, x = 26.80, y = 79.86 },
	converts = { m = 2521, x = 46.72, y = 19.83 },
	razormane = { m = 1413, x = 54.15, y = 25.01 },
	dustwind = { m = 1411, x = 52.12, y = 24.95 },
	fireDurotar = { m = 1411, x = 38.84, y = 58.24 },
	silverStream = { m = 1432, x = 35.48, y = 18.86 },
	stonesplinter = { m = 1432, x = 35.14, y = 84.04 },
	fireLoch = { m = 1432, x = 31.90, y = 64.34 },
	faladiel = { m = 2521, x = 64.46, y = 63.71 },
	kuramaa = { m = 2521, x = 42.39, y = 68.89 },
	ritual = { m = 2521, x = 51.20, y = 86.01 },
	brazierEternal = { m = 2521, x = 58.35, y = 78.83 },
	skinBrownH = { m = 1413, x = 44.19, y = 76.90 },
	skinRedH = { m = 1424, x = 62.15, y = 20.75 },
	skinBlueH = { m = 1440, x = 33.55, y = 67.44 },
	corruptSilverpine = { m = 1421, x = 38.84, y = 44.25 },
	skinBrownA = { m = 1437, x = 65.0, y = 74.9 },
	skinRedA = { m = 1433, x = 68.6, y = 60.6 },
	skinBlueA = { m = 1440, x = 32.7, y = 50.6 },
	spiders = { m = 1422, x = 33.60, y = 60.40 },
}
local S = SH_P
local DWARF = { Dwarf = true }

local function ShEarth(faction, races, quests)
	return { key = "earth", spell = 8071, level = 4, faction = faction, races = races, quests = quests }
end
-- Horde fire, Orc/Troll and Tauren: four starters that all lead to Kranal Fiss (Wowhead series "1522, 1523, 2983, 2984").
local function ShFireH(races, q, alt, starter)
	return { key = "fire", spell = 3599, level = 10, faction = "Horde", races = races, quests = {
		{ q = q, alt = alt, from = starter, to = S.kranal },
		{ q = 1524, from = S.kranal, to = S.telf },
		{ q = 1525, from = S.telf, objs = { O(S.razormane, "FCQ_OBJ_SH_FIRETAR_H", 1), O(S.dustwind, "FCQ_OBJ_SH_POUCH_H", 2) },
			to = S.telf },
		{ q = 1526, from = S.telf, objs = { O(S.fireDurotar, "FCQ_OBJ_SH_EMBER", 1) }, to = S.brazierDurotar },
		{ q = 1527, from = S.brazierDurotar, to = S.kranal },
	} }
end

CHAINS.SHAMAN = {
	-- Earth (4): Stoneskin Totem 8071 + Earth Totem 5175. The sapta steps have no objective (Wowhead): text only.
	ShEarth("Horde", ORCTROLL, {
		{ q = 1516, from = S.canaga, objs = { O(S.felstalkers, "FCQ_OBJ_SH_HOOVES", 1) }, to = S.canaga },
		{ q = 1517, from = S.canaga, objs = { O(S.earthDurotar, "FCQ_OBJ_SH_EARTHSAPTA") }, to = S.earthDurotar },
		{ q = 1518, from = S.earthDurotar, to = S.canaga },
	}),
	ShEarth("Horde", TAUREN, {
		{ q = 1519, from = S.ravenfeather, objs = { O(S.bristleback, "FCQ_OBJ_SH_SALVE", 1) }, to = S.ravenfeather },
		{ q = 1520, from = S.ravenfeather, objs = { O(S.earthMulgore, "FCQ_OBJ_SH_EARTHSAPTA") }, to = S.earthMulgore },
		{ q = 1521, from = S.earthMulgore, to = S.ravenfeather },
	}),
	ShEarth("Horde", SKYBORNE, {
		{ q = 92484, from = S.rorian, to = S.boro },
		{ q = 92466, from = S.boro, objs = { O(S.converts, "FCQ_OBJ_SH_SIGNET", 1) }, to = S.boro },
		{ q = 92467, from = S.boro, objs = { O(S.earthZephras, "FCQ_OBJ_SH_EARTHSAPTA") }, to = S.earthZephras },
		{ q = 92468, from = S.earthZephras, to = S.boro },
	}),
	-- 96243 ("Find Teo", from Eldrun or Ingrid) is the other way in (Spoken, Wowhead series).
	ShEarth("Alliance", DWARF, {
		{ q = 98581, alt = { 96243 }, from = S.sten, to = S.teo },
		{ q = 94373, from = S.teo, objs = { O(S.whelps, "FCQ_OBJ_SH_PENDANTS", 1) }, to = S.teo },
		{ q = 94374, from = S.teo, objs = { O(S.earthDunMorogh, "FCQ_OBJ_SH_EARTHSAPTA") }, to = S.earthDunMorogh },
		{ q = 94375, from = S.earthDunMorogh, to = S.teo },
	}),
	-- Fire (10): Searing Totem 3599 + Fire Totem 5176. Windshapers may not take 1522-1524/2983/2984 (Spoken races 178).
	ShFireH(ORCTROLL, 2983, { 2984, 1522, 1523 }, S.swart),
	ShFireH(TAUREN, 2984, { 2983, 1522, 1523 }, S.narm),
	{ key = "fire", spell = 3599, level = 10, faction = "Horde", races = SKYBORNE, quests = {
		-- Aarnor Galestrike gives 97243 too (Spoken, Wowhead 98517).
		{ q = 97243, from = S.sessaria, to = S.olariaan },
		{ q = 97244, from = S.olariaan, objs = { O(S.faladiel, "FCQ_OBJ_SH_FALADIEL", 1) }, to = S.olariaan },
		{ q = 97245, from = S.olariaan, objs = { O(S.kuramaa, "FCQ_OBJ_SH_KURAMAA", 1) }, to = S.olariaan },
		{ q = 97257, from = S.olariaan, objs = { O(S.ritual, "FCQ_OBJ_SH_RITUAL", 1), O(S.brazierEternal, "FCQ_OBJ_SH_ETERNAL", 2) },
			to = S.sessaria },
	} },
	{ key = "fire", spell = 3599, level = 10, faction = "Alliance", races = DWARF, quests = {
		-- Eldrun Stormbreaker gives 94449 too (Spoken).
		{ q = 94449, from = S.ingrid, to = S.bruegs },
		{ q = 94465, from = S.bruegs, to = S.braldir },
		{ q = 94466, from = S.braldir, objs = { O(S.silverStream, "FCQ_OBJ_SH_FIRETAR_A", 1), O(S.stonesplinter, "FCQ_OBJ_SH_POUCH_A", 2) },
			to = S.braldir },
		{ q = 94467, from = S.braldir, objs = { O(S.fireLoch, "FCQ_OBJ_SH_EMBER", 1) }, to = S.brazierLoch },
		{ q = 94468, from = S.brazierLoch, to = S.bruegs },
	} },
	-- Water (20): Healing Stream Totem 5394 + Water Totem 5177. Horde = every Horde shaman, Windshapers too (Spoken).
	{ key = "water", spell = 5394, level = 20, faction = "Horde", quests = {
		{ q = 1528, alt = { 1529, 2985, 2986 }, from = S.searn, to = S.islen },
		{ q = 1530, from = S.islen, to = S.brine },
		{ q = 1535, from = S.brine, objs = { O(S.skinBrownH, "FCQ_OBJ_SH_SKIN_BROWN_H", 1) }, to = S.brine },
		{ q = 1536, from = S.brine, objs = { O(S.skinRedH, "FCQ_OBJ_SH_SKIN_RED_H", 1) }, to = S.brine },
		{ q = 1534, from = S.brine, objs = { O(S.skinBlueH, "FCQ_OBJ_SH_SKIN_BLUE_H", 1) }, to = S.brine },
		{ q = 220, from = S.brine, to = S.islen },
		{ q = 63, from = S.islen, objs = { O(S.corruptSilverpine, "FCQ_OBJ_SH_BRACERS", 1) }, to = S.everfount },
		{ q = 100, from = S.everfount, to = S.waterSilverpine },
		{ q = 96, from = S.waterSilverpine, to = S.islen },
	} },
	-- 94502 ends at the Forgotten Shrine, not at Norric (Spoken, Polestar); the spirit appears after a while.
	{ key = "water", spell = 5394, level = 20, faction = "Alliance", races = DWARF, quests = {
		{ q = 94494, from = S.eldrun, to = S.norric },
		{ q = 94495, from = S.norric, to = S.hervdana },
		{ q = 94497, from = S.hervdana, objs = { O(S.skinBrownA, "FCQ_OBJ_SH_SKIN_BROWN_A", 1) }, to = S.hervdana },
		{ q = 94499, from = S.hervdana, objs = { O(S.skinRedA, "FCQ_OBJ_SH_SKIN_RED_A", 1) }, to = S.hervdana },
		{ q = 94500, from = S.hervdana, objs = { O(S.skinBlueA, "FCQ_OBJ_SH_SKIN_BLUE_A", 1) }, to = S.hervdana },
		{ q = 94501, from = S.hervdana, to = S.norric },
		{ q = 94502, from = S.norric, objs = { O(S.shrine, "FCQ_OBJ_SH_BRACERS", 1) }, to = S.shrine },
		{ q = 94503, from = S.shrine, to = S.waterWestfall },
		{ q = 94505, from = S.waterWestfall, to = S.norric },
	} },
	-- Air (30): only the Air Totem 5178, no spell, so the chain ends when the quest is done.
	{ key = "air", nameKey = "FCQ_CHAIN_SH_AIR", level = 30, faction = "Horde", quests = {
		{ q = 1531, alt = { 1532, 96136 }, from = S.searn, to = S.prate } } },
	{ key = "air", nameKey = "FCQ_CHAIN_SH_AIR", level = 30, faction = "Alliance", races = DWARF, quests = {
		{ q = 94789, from = S.eldrun, to = S.veyric } } },
	-- Elemental Mastery (Horde, 52): 8411 is Bath'rah's own start. The elements as items: 8410 and 8411 ask them in
	-- another order. The feathers are the warrior's (same items, same order).
	{ key = "mastery", nameKey = "FCQ_CHAIN_SH_MASTERY", level = 52, faction = "Horde", quests = {
		{ q = 8410, alt = { 8411 }, from = S.beram, objs = {
			O(nil, "FCQ_OBJ_SH_ELEM_AIR", nil, { 7069 }),
			O(nil, "FCQ_OBJ_SH_ELEM_FIRE", nil, { 7068 }),
			O(nil, "FCQ_OBJ_SH_ELEM_EARTH", nil, { 7067 }),
			O(nil, "FCQ_OBJ_SH_ELEM_WATER", nil, { 7070 }),
		}, to = R.bathrah },
		{ q = 8412, from = R.bathrah, objs = { O(S.spiders, "FCQ_OBJ_SH_SPIDEREYE", 1), O(S.spiders, "FCQ_OBJ_SH_CLAW", 2) },
			to = R.bathrah },
		{ q = 8413, from = R.bathrah, objs = {
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_AMBER", 1),
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_BLUE", 2),
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_GREEN", 3),
		}, to = R.bathrah },
	} },
}
```

`NPC_NAMES`-rijen: §7 (5887, 5888, 5891, 251166, 3173, 3066, 5892, 5906, 5907, 5900, 5901, 5899, 5895, 5905, 3032,
251361, 251374, 252382, 268592, 658, 257446, 258113, 258098, 257597, 257808, 258043, 258203, 259023; zonder "—"-cellen).
`OBJ_NAMES`: 61934, 113791, 619896.

Voorgestelde enUS-teksten (stijl van r. 5480-5557; namen zijn spelnamen, in de/fr/es/pt/ru de client-naam):

| Sleutel | Voorstel enUS |
|---|---|
| FCQ_OBJ_SH_HOOVES | defeat Felstalkers in and around the cave for 2 Felstalker Hooves |
| FCQ_OBJ_SH_SALVE | defeat Bristleback Shamans for 2 Ritual Salves |
| FCQ_OBJ_SH_PENDANTS | defeat Frostmane Troll Whelps for 2 Iceclaw Bear Pendants |
| FCQ_OBJ_SH_SIGNET | defeat Al'Aketh Converts for a Signet of Akir |
| FCQ_OBJ_SH_EARTHSAPTA | climb to the spirit stone, drink the Earth Sapta from your bags, then talk to the Minor Manifestation of Earth |
| FCQ_OBJ_SH_FIRETAR_H | defeat Razormane quilboar for Fire Tar |
| FCQ_OBJ_SH_POUCH_H | in the cave (entrance at 52.8, 28.8), defeat Burning Blade Cultists for a Reagent Pouch |
| FCQ_OBJ_SH_FIRETAR_A | in Silver Stream Mine, defeat Tunnel Rat Geomancers for Fire Tar |
| FCQ_OBJ_SH_POUCH_A | defeat Stonesplinter Seers for a Reagent Pouch (many troggs: bring help) |
| FCQ_OBJ_SH_EMBER | at the top, drink the Fire Sapta from your bags and defeat the Minor Manifestation of Fire for the Glowing Ember |
| FCQ_OBJ_SH_FALADIEL | defeat Skypriest Faladiel for Faladiel's Heart |
| FCQ_OBJ_SH_KURAMAA | click Kuramaa's Stump, then defeat Kuramaa for Kuramaa's Mask |
| FCQ_OBJ_SH_RITUAL | wait for Olariaan to begin the ritual and follow him |
| FCQ_OBJ_SH_ETERNAL | hurry (a timer): light the Brazier of Eternal Flame |
| FCQ_OBJ_SH_SKIN_BROWN_H / _RED_H / _BLUE_H | use the empty brown / red / blue waterskin from your bags in the water here |
| FCQ_OBJ_SH_SKIN_BROWN_A | jump down from Hervdana's cave and use the brown waterskin in the water below the falls |
| FCQ_OBJ_SH_SKIN_RED_A | use the red waterskin at the foot of Stonewatch Falls, where the murlocs are |
| FCQ_OBJ_SH_SKIN_BLUE_A | use the blue waterskin in the lake around Astranaar (boat from Menethil Harbor to Auberdine) |
| FCQ_OBJ_SH_BRACERS | drink the Water Sapta from your bags here, then defeat the Corrupt Manifestation for its bracers |
| FCQ_OBJ_SH_ELEM_AIR / _FIRE / _EARTH / _WATER | bring 1 Elemental Air / Fire / Earth / Water (drops, or the Auction House) |
| FCQ_OBJ_SH_SPIDEREYE | defeat spiders for 8 Bloodshot Spider Eyes |
| FCQ_OBJ_SH_CLAW | defeat enemies for 8 Thick Black Claws |
| FCQ_CHAIN_SH_AIR | The Air Totem (your air totems need it) |
| FCQ_CHAIN_SH_MASTERY | Bath'rah's quests (a reward to choose) |

(De mob-namen in SPIDEREYE/CLAW: Zygor zegt alleen "Kill enemies around this area" → niet gemeten welke mobs; tekst
zo algemeen laten.)

## 10. Open / niet gemeten

- Niets in-game nagemeten: elk quest-id, elke objective-index en elk `IsComplete` voor de sapta-stappen wacht op
  `/mh classquest` met een shaman.
- Min-levels: Skyborne earth misschien 3 (Zygor-hint); Elemental Mastery 50 of 52; Air 30 (96136 Wowhead-calc 35).
- Of 94373 `98581` of `96243` eist: niet gemeten.
- Alliance-waterzakken: drie plekken alleen uit gidsen, en twee gidsen verschillen 4-5 punten (red: gitm 68.6,60.6 vs
  warcrafttavern 73.7,61.6; blue: 32.7,50.6 vs 37.0,51.6). Gekozen gitm (gedateerd 15 nov, na de hotfix); Rob meten.
- Spirit in Westfall (waterWestfall) en Norric/Hervdana/Veyric: Wowhead-spawn of gids, geen Zygor/HandyNotes.
- Alliance Elemental Mastery: niet gebouwd (Spoken-maskers Horde); in-game niet gemeten.
- The Tempest's Weapons (§4f): niet gebouwd; inleveraars Horde en drop-plekken open.
- Breadcrumb 98517 en herstelquests (1103, 1462/1463/94472, 1464/94473, 972/94616): niet gebouwd.
- ptBR 251374 "Moldavento" (zonder "Boro") en ptBR 5887 "Ranago Arauto da Terra" staan zo in Wowhead; lijkt een fout in
  Wowhead's data, niet gecontroleerd tegen de ptBR-client.
- esMX ontbreekt (Wowhead [haken], ook niet in Spoken): 5891, 251166, 5895, 258098, 257808, 258203; ptBR ontbreekt:
  251166, 257808, 258203; object 113791 esMX.
- De drie 8413-beloningen 20369/20503/20556 niet in DB2 ItemSparse 70938 (rest wel).
- Totem of Charged Flames 263412 (beloning van alle fire-quests): wat het doet, niet gemeten.
- Dat een Windshaper de Horde-water/air-route krijgt: AFGELEID uit Spoken-maskers.
