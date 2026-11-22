# Mage class-quests in WoW Forever (build 1.60.1.70938)

Onderzoek: mh-research, 17 nov 2026. Alleen gelezen, niets in het spel gezien.
Per bewering staat **[G]** = GEMETEN (bron erbij) of **[A]** = AFGELEID (beredeneerd).
Niets hiervan is door Rob in het spel gemeten: quest-id's, coördinaten en objective-nummers zijn onbewezen tot de client ze afvinkt (`/mh classquest`).

## 1. Bronnen (alles gelezen op 17 nov 2026)

| Kort | Bron | Datum / build |
|---|---|---|
| Zygor-A | `ZygorLevelingAllianceCLASSIC.lua:22695-23113` ("Mage Class Quests") | Forever-gids, geïnstalleerd |
| Zygor-H | `ZygorLevelingHordeCLASSIC.lua:23878-24252` ("Mage Class Quests"); hoofdgids `:924-930, 1102-1103, 1486-1488, 3042-3106` | idem |
| Zygor-C | `ZygorLevelingCommonCLASSIC.lua:97-102, 1126-1139, 1188-1190, 1243-1245` (Skyborne) | idem |
| Zygor-D | `ZygorDungeonAllianceCLASSIC.lua:8096-8253`, `ZygorDungeonHordeCLASSIC.lua:7967-7969, 8088-8123` (Sunken Temple class-quests); `ZygorProfessionsAllianceCLASSIC.lua:4891` (Uldaman achterdeur) | idem |
| Spoken | `Spoken_Quests\Data\Compendium.lua` (build 70450) r. 1482-1523, 1801-1828, 2960, 3348-3351, 4242-4243, 4347, 4437-4438, 4654, 4806; `SpokenQuestsAudioShared\generated\quest_id_lookups.lua` r. 180-191, 1453-1480, 2174-2176, 4998, 5213, 5330-5332, 5377, 5876, 12000-12002; `Spoken_Quests\Locale\Names\*.lua` | geïnstalleerd |
| HN | `HandyNotes_ClassTrainers\Data.lua` r. 59, 79, 102, 136-138, 183-186, 209-211, 284, 302-304, 325-326 (build 70532); `HandyNotes_WoWForever\zones\Azshara.lua:39` | geïnstalleerd |
| DB2 | lokale cache `gamedata_cache\db2\1.60.1.70938\`: `CharBaseInfo`, `ChrRaces`, `QuestV2`, `ItemSparse`, `Item`, `SpellName`, `UiMap` | 1.60.1.70938 |
| WH | Wowhead Forever tooltip-JSON `nether.wowhead.com/forever/tooltip/quest|npc/<id>` (+ `?locale=3/2/6/11/8/7`) en questpagina's `www.wowhead.com/forever/quest=<id>` | 17 nov 2026 |
| IV | Icy Veins database `db.icy-veins.com/wow-forever/quests/<id>`, categorie Mage (53 quests) | patch 1.60.1.70532 |
| AW | `azeroth.wiki/forever/quests/<naam>` (ras, level, gever, "Previous quest" / "Prerequisites") | geen datum op de pagina |
| Polestar | `polestar.guide/guides/class/mage/*.md` (gidsen uit de addon Polestar) | 2 nov 2026 (0.3.0); Pig 9 nov (0.3.6) |
| Codex | `wowforevercodex.com/classes/mage/quests` | geen datum |
| ForeverDB | `foreverdb.net/guide/orc-mage`, `/high-order-skyborne-mage` | 14 nov 2026, "build 1.60.1.70938" |
| Wiki | `warcraft.wiki.gg/wiki/Research_Access` | patch 1.60.1 (4 nov 2026) |
| Overig | wowhelm.com (QuestieDB, Classic-data), wowforever.wiki.fextralife.com (12 en 16 nov), conquestcapped.com (7 nov), systematic.gg (14 nov), wowdee.com (6 okt), worstguidesever.com (16 sep / 13 okt) | zie tekst |

Positieve controles in dezelfde runs:
- Wowhead-tooltip quest 98393 gaf "The Great Cat Spirit"; npc 233 gaf "Farmer Saldean" en met `?locale=3` "Bauer Saldean". [G]
- Spoken deDE `[233] = "Bauer Saldean"` (Names\deDE.lua:14). [G]
- Spoken-lookup bevat 98393 en 78261/78676 (quest_id_lookups r. 5217, 5448, 5493). [G]
- `locale=11` = esMX: npc 3064 gaf "Gennia Tótem de Runa" (gelijk aan de regel die al in de module staat). [G]
- ItemSparse: in dezelfde grep als de ontbrekende namen werden "Celestial Stave", "Nether Force Wand" en "Idol of Shifting Tides" wél gevonden. [G]

## 2. Wie kan mage zijn

| Ras | RaceID | Factie | Bron |
|---|---|---|---|
| Human | 1 | Alliance | [G] CharBaseInfo r. 6 (`5,1,8,0`) |
| Gnome | 7 | Alliance | [G] r. 35 (`51,7,8,0`) |
| Skyborne (High Order) | 95 | Alliance | [G] r. 50 (`899,95,8,0`); naam "High Order Skyborne" in ChrRaces r. 58 |
| Orc | 2 | Horde | [G] r. 57 (`921,2,8,0`) — nieuw in Forever |
| Troll | 8 | Horde | [G] r. 41 (`57,8,8,0`) |
| Undead (Scourge) | 5 | Horde | [G] r. 26 (`30,5,8,0`) |

Geen mage: Dwarf, Night Elf, Tauren en Windshaper Skyborne (96, Horde). [G] CharBaseInfo heeft daar geen rij met ClassID 8.
Let op: de gids op wowforever.kickegg.net (9 nov) zegt "four races only"; dat is Classic-data en klopt niet voor Forever. [G]

## 3. Wat geven de mage-quests

Alle quests in de categorie Mage (QuestSort 161): 53 stuks. [G] IV-categorielijst; de pagina toonde 50 rijen, de laatste drie (1879, 1861, 1860) volgen uit de telling [A]. Alle id's staan ook in QuestV2 70938. [G]
Nieuw in Forever: 98576, 97286, 93797, 93791, 92481, 90789, 82084. [G] IV + QuestV2.
Spoken's Compendium mist 82084 en 90789 (net als bij de rogue); 82084 staat wél in Spoken's lookup (r. 5876). [G]

### Spells uit een quest

| Spell | Id | Quest | Level | Bron |
|---|---|---|---|---|
| Conjure Water (Rank 7) | 10140 | 7463 Arcane Refreshment | 60 | [G] WH-questpagina "You will learn: Conjure Water (spell 10140)"; AW "Spells learned"; SpellName 10140 = "Conjure Water" |
| Polymorph (varken) | 28272 | 9364 Fragmented Magic | 60 | [G] WH-questpagina "You will learn: Polymorph (spell=28272)"; AW "Polymorph (Pig)" |
| Study | 1302508 | 97286 Research Access | quest-level 20, vereist level 1 | [G] WH-questpagina "You will learn: Study (1302508)"; Wiki; IV; SpellName 1302508 = "Study" |

**Rank-quests bestaan niet.** [G] In de 53 quests zit geen enkele rank-quest; ForeverDB (14 nov, "from the game client") noemt bij elke mage-spell t/m level 10 "Trainer"; Codex telt "Spells 2" (water en varken).
Fireball Rank 1 (133) en Frost Armor Rank 1 (168) staan niet in de trainerlijst van MH (`ForeverTrainerData.lua:345-519`) [G]; ForeverDB zet ze op level 1 met "You start with your level 1 spells" [G]. Dat het startspells zijn = [A].
**Teleport en Portal: geen quests, alleen de portaaltrainers.** [G] Polestar "Teleports and Portals": "0 quests"; MH's eigen trainerlijst heeft ze met prijs (`ForeverTrainerData.lua:381-384, 414-415, 445-448, 482-483`).
**Polymorph: Cow / Turtle:** de spells bestaan in DB2 (28270, 28271) [G], maar er is geen quest voor in de Mage-categorie [G, lijst van 53].

### Items uit een quest

| Item (id) | Quest | Vanaf | Bron |
|---|---|---|---|
| Ley Orb 7508 of Ley Staff 9513 | 1861 Mirror Lake, 1884 Ju-Ju Heaps | 10 | [G] WH-questpagina's 1861 en 1884; id's in ItemSparse |
| Arcane Orb 7507 of Arcane Staff 9514 | 1880 Mage-tastic Gizmonitor, 1882 The Balnir Farmstead | 10 | [G] WH-questpagina's 1880 en 1882 |
| Windbough Wand 263430 + Elixir of Minor Spirit 250344 | 93797 Boughs in the Wind | 10 | [G] WH-questpagina 93797 |
| Manaweave Robe 7509 | 1941 | 15 | [G] Codex, AW; id in ItemSparse |
| Lesser Spellfire Robes 7510 | 1962 | 15 | [G] Codex; id in ItemSparse |
| Astral Knot Robe 7511 of Blouse 9516 | 1942 | 26 | [G] Codex, AW |
| Nether-lace Robe 7512 of Tunic 9515 | 1946 | 26 | [G] Codex, AW |
| Icefury Wand 7514, Nether Force Wand 11263 of Ragefire Wand 7513 | 1952 Mage's Wand | 30 | [G] Codex, AW, Polestar |
| Celestial Orb 7515 of Celestial Stave 9517 | 1958 Celestial Power | 35 | [G] Codex, AW |
| Personal Spellbook 221344 (off-hand, +9 Int) | 82084 A Lesson in Literacy | 42 | [G] WH-questpagina, IV, Fextralife 16 nov, Conquest Capped 7 nov |

### Geeft (waarschijnlijk) niets meer

- **8253 Destroy Morphaz (level 50).** Wowhead Forever toont nog Glacial Spike / Fire Ruby / Arcane Crystal Pendant [G], maar die drie namen staan NIET in ItemSparse 70938 (controle in dezelfde grep wel gevonden) [G]; Polestar en Codex zeggen "reward: Experience" [G]. Dat de quest alleen XP en geld geeft = [A].
- 🔴 **Bijvangst voor de andere klassen:** in dezelfde grep ontbreken ook Grizzled Pelt, Moonshadow Stave, Forest's Embrace (druid 9053), Devilsaur Eye, Hunting Spear (hunter 8232), Azure Moon Amice, Duskbat Drape (rogue 8236) en Fury Visor (warrior 8425) in ItemSparse 70938, terwijl "Whirlwind Axe" er wel staat. [G] Dat de level-50 Sunken Temple-quests in Forever geen item meer geven = [A]. De ketennamen `FCQ_CHAIN_TORWA`, `FCQ_CHAIN_HU_CHARM` en `FCQ_CHAIN_WR_FALLENHERO` beloven nu een item.
- Level 1 Glyphic-brieven (3104 Human, 3114 Gnome, 3098 Undead, 3086 Troll, 98576 Orc) en 92481 A Student of the Arcane (Skyborne, level 2): alleen XP. [G] Codex "40 experience"; ForeverDB "free experience".

### Niet in de schets (wel genoemd)

- **2861 Tabetha's Task → 2846 Tiara of the Deep** (min. level 40, Zul'Farrak): geen class-quest. [G] AW toont geen klasse; Spoken heeft geen `classes` (r. 1680, 1695); Polestar: "a quest any class can do". Alleen de aanwijzer komt van magetrainers.
- **7500 The Arcanist's Cookbook** (min. level 54): begint met een item (18358, valt in Dire Maul) [G Codex, ItemSparse]. Kan de module niet aan. De beloning Royal Seal of Eldre'Thalas staat niet in ItemSparse. [G]
- Raid- en reputatiequests met `classes = 128` (ZG, AQ, Naxxramas, Atiesh, Tier 0.5). [G] Spoken r. 3233-4209.

## 4. De ketens

Level = het minimum-level van de quest. [G] AW en IV, tenzij anders gezegd.
"Aanwijzer" = een quest die alleen naar de volgende NPC stuurt. AW noemt zo'n quest "Previous quest" en een harde eis "Prerequisites". Dat een aanwijzer overgeslagen mag worden = [A] (Polestar zegt het letterlijk voor 1883 en 1939).

### 4.1 Staf of orb (level 10)

Je kunt er maar één doen. [G] QuestV2: 1861 en 1880 delen UniqueBitFlag 1473, 1882 en 1884 delen 1477; AW: "Only one of these quests can be done". Dat `IsQuestFlaggedCompleted` daardoor voor beide waar wordt = [A].

| Route | Quest | Gever | Inleveren | Doel |
|---|---|---|---|---|
| Human | 1860 Speak with Jennea | Zaldimar Wefhellt (Goldshire) | Jennea Cannon | — |
| | 1861 Mirror Lake | Jennea Cannon | Jennea Cannon | 1 = Mirror Lake Water Sample (7206); gebruik Jennea's Flask (7207) onder de waterval |
| Gnome | 1879 Speak with Bink | Magis Sparkmantle (Kharanos) | Bink (Ironforge) | — |
| | 1880 Mage-tastic Gizmonitor | Bink | Bink | 1 = Mage-tastic Gizmonitor (7226) uit Bink's Toolbox (object 102984) |
| Skyborne | 1861 Mirror Lake, zonder 1860 | Jennea Cannon | Jennea Cannon | als Human |
| Orc | 1883 Speak with Un'thuwa | Uthel'nay (Orgrimmar); ook Thurston Xane (Thunder Bluff) | Un'Thuwa (Sen'jin) | — |
| Orc, Troll | 1884 Ju-Ju Heaps | Un'Thuwa | Un'Thuwa | 1 = 4 Ju-Ju Heaps vernietigd |
| Undead | 1881 Speak with Anastasia | Cain Firesong (Brill) | Anastasia Hartwell | — |
| | 1882 The Balnir Farmstead | Anastasia Hartwell | Anastasia Hartwell | 1 = Balnir Snapdragons (7227) |

- Gevers/inleveraars: [G] IV (Start/End), AW, Spoken (ender 5497, 5144, 5880, 4568; lookup r. 180, 568, 910, 1474-1476), Zygor-A:22701-22718, Zygor-H:23884-23904, Zygor-H hoofdgids :924-930.
- Rassen volgens AW: 1860 Human/Gnome; 1861 Human/Gnome/High Order Skyborne; 1879-1880 Human/Gnome; 1883 heel de Horde; 1884 Orc/Undead/Troll; 1881-1882 Undead/Troll. [G] Welke route bij welk ras hoort (startgebied) = [A].
- Skyborne pakt Mirror Lake rechtstreeks bij Jennea "at about 15": [G] Polestar. Niet in het spel gezien; 1860 staat als "Previous quest" (zacht). [A]
- Troll zonder aanwijzer: [G] Polestar "it is only a pointer and Un'thuwa gives Ju-Ju Heaps without it".
- Objective-nummers: [G] WH-tooltips (1 doel per quest); Zygor `q 1861/1`, `q 1884/1`, `q 1882/1`.

### 4.2 Windbough Wand (level 10, Zephras Isle) — nieuw

| Quest | Gever | Inleveren | Doel |
|---|---|---|---|
| 93791 Speak with Belann | Anathamaas Aetherwind (Valanaar) | Belann Windwood | — |
| 93797 Boughs in the Wind | Belann Windwood | Belann Windwood | 1 = Wind-Infused Bough (262668), ligt op de grond bij de windschrijn |

- [G] Zygor-C:1126-1139, 1188-1190, 1243-1245; Spoken r. 4437-4438 (prev 93791); WH-serie; AW (93797: Prerequisites = 93791).
- Open voor elke Alliance-mage, en sluit staf/orb niet uit: [G] AW (geen ras, geen "only one"), Polestar stap 12. Eén Wowhead-reactie zegt "i think … you can not do this one"; dat is een gok. In de schets alleen voor Skyborne (staat op hun eiland). [A]

### 4.3 Robe (level 15)

| Factie | Quest | Gever | Inleveren | Doelen (objective-nummer) |
|---|---|---|---|---|
| Alliance | 1919 Report to Jennea | Zaldimar Wefhellt, Magis Sparkmantle of Dink | Jennea Cannon | — |
| | 1920 Investigate the Blue Recluse | Jennea | Jennea | 1 = 3 Filled Containment Coffer (7292); 2 = Chest of Containment Coffers (7247); 3 = Cantation of Manifestation (7308) |
| | 1921 Gathering Materials | Jennea | Wynne Larson | 1 = 10 Linen Cloth (2589); 2 = 6 Charged Rift Gem (7249) |
| | 1941 Manaweave Robe | Wynne Larson | Wynne Larson | — |
| Horde | 1959 Report to Anastasia | Uthel'nay, Thurston Xane, Un'Thuwa of Cain Firesong | Anastasia Hartwell | — |
| | 1960 Investigate the Alchemist Shop | Anastasia | Anastasia | 1 = 3 Filled Containment Coffer; 2 = Chest; 3 = Cantation |
| | 1961 Gathering Materials | Anastasia | Josef Gregorian | 1 = 10 Linen Cloth; 2 = 6 Dalaran Mana Gem (7293) |
| | 1962 Spellfire Robes | Josef Gregorian | Josef Gregorian | — |

- [G] Zygor-A:22723-22801, Zygor-H:23909-23958; Spoken r. 1496-1502, 1520-1523 (ender 1309 en 4576); lookup r. 181-184 en 1478-1480; WH-tooltips (volgorde van de doelen); Zygor `q 1920/1,/2,/3`, `q 1921/1,/2`, `q 1961/1,/2`.
- Cain Firesong als gever van 1959: [G] AW en Polestar; staat NIET in Spoken en Zygor.
- 1962: AW noemt drie gevers (Josef Gregorian, Victor Ward, Rhiannon Davis); Polestar: "Forever's quest data has Rhiannon offering it". Ze staan naast elkaar; Spoken en Zygor zeggen Josef. [G]
- 🔴 **Ras niet gemeten voor Orc en Skyborne.** AW: 1919 en 1941 Human/Gnome, 1920 ook Skyborne; 1959 en 1962 Undead/Troll. Codex: Manaweave "Gnome and Human only", Spellfire "Orc, Troll and Undead only". Polestar: Zaldimar "(Human, Skyborne only)", Uthel'nay "(Orc, Troll only)". [G] De bronnen spreken elkaar tegen.

### 4.4 Tweede gewaad (level 26)

| Factie | Quest | Gever | Inleveren | Doel |
|---|---|---|---|---|
| Alliance | 1939 High Sorcerer Andromath | Jennea Cannon of Bink | High Sorcerer Andromath | — |
| | 1938 Ur's Treatise on Shadow Magic | Andromath | Andromath | 1 = Ur's Treatise (7266), Tower of Ilgalar, bovenste verdieping |
| | 1940 Pristine Spider Silk | Andromath | Wynne Larson | 1 = 8 Pristine Spider Silk (7267) |
| | 1942 Astral Knot Garment | Wynne Larson | Wynne Larson | — |
| Horde | 1943 Speak with Deino | Anastasia Hartwell | Deino (Orgrimmar) | — |
| | 1944 Waters of Xavian | Deino | Deino | 1 = Xavian Water Sample (7268); gebruik Deino's Flask (7269) |
| | 1945 Laughing Sisters | Deino | Kil'hala (Crossroads) | 1 = 12 Laughing Sister's Hair (7270) |
| | 1946 Nether-lace Garment | Kil'hala | Kil'hala | — |

- [G] Zygor-A:22806-22838, Zygor-H:23963-23990; Spoken r. 1499-1507; lookup r. 2174-2176; AW; WH-tooltips.
- Ras: AW zegt Alliance Human/Gnome en Horde Undead/Troll; Polestar zegt "Alliance, Mage" (Skyborne begint bij Andromath, zonder aanwijzer) en "Horde, Orc, Undead and Troll". [G] Niet gemeten voor Orc en Skyborne.

### 4.5 Mage's Wand (level 30)

| Quest | Gever | Inleveren | Doel |
|---|---|---|---|
| 1947 Journey to the Marsh | Jennea Cannon, Bink, Deino, Anastasia Hartwell of Ursyn Ghull | Tabetha (Dustwallow Marsh) | — |
| 1949 Hidden Secrets | Tabetha | Magus Tirth (Shimmering Flats) | — |
| 1950 Get the Scoop | Magus Tirth | Magus Tirth | 1 = "Secret phrase found": `/beckon` op "Plucky" Johnson, dan praten |
| 1951 Rituals of Power | Magus Tirth | Tabetha | 1 = Rituals of Power (7274), Scarlet Monastery, Library |
| 1948 Items of Power | Tabetha | Tabetha | 1 = Jade (1529); 2 = Bolt Charged Bramble (7272). Daarvoor 10 Witherbark Totem Stick (7273) |
| 1952 Mage's Wand | Tabetha | Tabetha | — (na haar ritueel) |

- [G] Zygor-A:22847-22928; Spoken r. 1508-1513; lookup r. 1453-1458 (vijf gevers); AW: 1947 "Required for: Items of Power, Hidden Secrets"; 1952 "Prerequisites: Items of Power, Rituals of Power".
- 1948 loopt naast 1949-1951. De 10 sticks staan in de WH-tooltip als derde regel, maar zijn een bron-item, geen doel. [A] Zygor: `q 1948/2` voor de Bramble. [G]
- Geen raseis. [G] AW, Spoken (geen `races`). Welke trainer per ras = [A].

### 4.6 Celestial Power (level 35)

| Quest | Gever | Inleveren | Doel |
|---|---|---|---|
| 1953 Return to the Marsh | dezelfde vijf trainers | Tabetha | — |
| 1954 The Infernal Orb | Tabetha | Tabetha | 1 = Infernal Orb (7291), Burning Blade Summoners (Desolace) |
| 1955 The Exorcism | Tabetha | Tabetha | Demon of the Orb doden (level 40 elite, met tijd) |
| 1956 Power in Uldaman | Tabetha | Tabetha | 1 = Obsidian Power Source (8053), Obsidian Sentinel in Uldaman |
| 1957 Mana Surges | Tabetha | Tabetha | 1 = 12 Mana Surges binnen de tijd |
| 1958 Celestial Power | Tabetha | Tabetha | — |

- [G] Zygor-A:22938-23009; Spoken r. 1514-1519; lookup r. 1460-1465; AW (min. level 35); WH-tooltips.
- 1955: de WH-tooltip toont twee regels ("Demon of the Orb" en "Kill the Demon of the Orb"); Zygor zegt `/1`. Daarom in de schets zonder nummer (wacht tot de client "compleet" zegt). [A]
- Tijden (3 minuten voor de demon, 10 minuten voor de surges): [G] alleen Polestar.

### 4.7 Study (Research Access) — nieuw

| Quest | Gever | Inleveren | Voorwaarde |
|---|---|---|---|
| 97286 Research Access | Garion Wendell (Stormwind) of Owen Thadd (Undercity) | dezelfde | je eerste bibliotheekboek ingeleverd |

- [G] Wiki: "offered by librarians to mages who turn in their first library book", Start/End Garion Wendell en Owen Thadd, Level 20 (Requires 1), Class Mage, beloning Study. [G] IV, AW (lange lijst boekquests als voorwaarde, één volstaat), Spoken-lookup r. 12000-12002.
- De bibliothecaris biedt de boekquest alleen aan als je een boek bij je hebt. [G] foreverchanges.pro. Hoeveel boeken nodig zijn: niet bevestigd. [G] wowdee 6 okt.
- Blizzard-hotfix 6 nov: "you should only have the Study spell after completing the relevant quest"; 13 nov: bibliothecarissen weigerden soms boeken, opgelost. [G] systematic.gg 14 nov (citeert Blizzards hotfixpagina).
- Study zit als recept in een Comprehension-tab. [G] wowdee. Of `IsPlayerSpell(1302508)` het ziet: niet gemeten. De keten eindigt ook als 97286 gedaan is. [A]
- Spoken geeft 97286 een Horde-masker (r. 4654), maar beide bibliothecarissen geven hem. [G]

### 4.8 A Lesson in Literacy (level 42) — nieuw

| Quest | Gever | Inleveren | Doelen |
|---|---|---|---|
| 82084 A Lesson in Literacy | Garion Wendell of Owen Thadd | dezelfde | 1 = Pristine Owlbeast Quill (221359); 2 = 5 Zukk'ash Resin (221361); 3 = 8 Farraki Papyrus (221360) |

- [G] IV (Level 45, Requires 42, Start/End), WH-tooltip (volgorde), WH-questpagina (beloning Personal Spellbook 221344), Fextralife, Conquest Capped.
- Bronnen van de items: Quill = Savage (2929), Primitive (2928), Vicious (2927) Owlbeast in The Hinterlands; Resin = Zukk'ash Tunneler/Stinger/Wasp/Worker (5247/5244/5245/5246) in Feralas; Papyrus = Zul'Farrak Zombie (7286) en Shallow Grave, in Zul'Farrak. [G] IV-itempagina's.
- Of Research Access eerst moet: niet gemeten.

### 4.9 Magecraft (level 50)

| Quest | Gever | Inleveren | Doel |
|---|---|---|---|
| 8250 Magecraft | Maginor Dumas (Stormwind), Dink (Ironforge), Uthel'nay (Orgrimmar), Pierce Shackleton (Undercity), Archmage Shymm (Thunder Bluff) | Sanath Lim-yo (Azshara) | — |
| 8251 Magic Dust | Archmage Xylem | Archmage Xylem | 1 = 10 Glittering Dust (20028) |
| 8252 The Siren's Coral | Archmage Xylem | Archmage Xylem | 1 = 6 Enchanted Coral (20029) |
| 8253 Destroy Morphaz | Archmage Xylem | Archmage Xylem | 1 = Arcane Shard (20085), Morphaz in Sunken Temple |

- [G] Zygor-D (A:8096-8253, H:7967-7969); Spoken r. 3348-3351 (ender 8395); lookup r. 186-191; AW (min. level 50). Codex noemt andere gevers (Thurston Xane, Juli Stormkettle, Elsharin, Enyo); vier bronnen tegen één.
- Beloning: zie hoofdstuk 3 (waarschijnlijk alleen XP). Bouwchat-keuze of hij erin komt.

### 4.10 Conjure Water Rank 7 (level 60)

| Quest | Gever | Inleveren | Doel |
|---|---|---|---|
| 7463 Arcane Refreshment | Lorekeeper Lydros (Dire Maul, Athenaeum) | Lorekeeper Lydros | 1 = Hydrospawn Essence (18299), Hydrospawn in Dire Maul East |

- [G] Zygor-A:23063-23111; Spoken r. 2960; WH-questpagina; AW; Polestar. De gever staat ín de dungeon (via West, of via North met Crescent Key). [G] Polestar.

### 4.11 Polymorph: Pig (level 60)

| Quest | Gever | Inleveren | Doel |
|---|---|---|---|
| 90789 Scalebeard (nieuw) of 9362 Warlord Krellian | Archmage Xylem | Archmage Xylem | 1 = Prismatic Shell (23250) |
| 9364 Fragmented Magic | Archmage Xylem | Archmage Xylem | 1 = 50 Polymorph Clones |

- 90789 en 9362 delen UniqueBitFlag 3576. [G] QuestV2 r. 3739 en 4898. Wowhead zet ze samen in stap 1 van de serie. [G]
- IV geeft bij 90789 "Start/End: Archmage Xylem" en bij 9362 géén gever; Fextralife (12 nov): "Fragmented Magic … Follows Scalebeard"; er is een nieuwe quest-NPC Scalebeard 244188 (level 55, gewoon) naast de rare 13896. [G] Polestar (9 nov), Codex en AW noemen nog 9362 vanaf Xylem. [G] Welke van de twee het spel nu aanbiedt: niet gemeten; 90789 als eerste = [A].
- AW: de Prismatic Shell valt van Scalebeard én Warlord Krellian. [G]
- Objective 9364: WH-tooltip "Polymorph Clone x 50"; de Shell is "Provided". [G]

## 5. Plekken (UiMap-id, x, y)

UiMap-id's: [G] `UiMap.enUS.csv` 70938 — Durotar 1411, The Barrens 1413, Arathi Highlands 1417, Badlands 1418, Tirisfal Glades 1420, Silverpine Forest 1421, The Hinterlands 1425, Dun Morogh 1426, Elwynn Forest 1429, Duskwood 1431, Loch Modan 1432, Redridge Mountains 1433, Ashenvale 1440, Thousand Needles 1441, Desolace 1443, Feralas 1444, Dustwallow Marsh 1445, Tanaris 1446, Azshara 1447, Stormwind City 1453, Orgrimmar 1454, Ironforge 1455, Undercity 1458, Zephras Isle 2521.
Regel: HandyNotes > Zygor > gids. Stormwind is groter in Forever: Wowhead geeft per NPC een oude set (38.x) en een nieuwe (49.x); de nieuwe hoort bij Forever. [G] HN-kop + Zygor + Wowhead.

| Sleutel | NPC (id) | Map | x, y | Bron |
|---|---|---|---|---|
| zaldimar | Zaldimar Wefhellt (328) | 1429 | [stond in HandyNotes] | HN :102 (Zygor 43.25, 66.19) |
| jennea | Jennea Cannon (5497) | 1453 | [stond in HandyNotes] | HN :210 (Zygor 49.50, 85.84) |
| magis | Magis Sparkmantle (1228) | 1426 | [stond in HandyNotes] | HN :59 |
| bink | Bink (5144) | 1455 | [stond in HandyNotes] | HN :136 |
| dink | Dink (7312) | 1455 | [stond in HandyNotes] | HN :137 (Zygor 27.18, 8.58) |
| anathamaas | Anathamaas Aetherwind (252373) | 2521 | 65.80, 80.50 | HN :325 (Zygor 65.91, 80.57) |
| belann | Belann Windwood (256507) | 2521 | 62.90, 77.44 | Zygor-C:1138 (WH 62.8, 77.4) |
| wynne | Wynne Larson (1309) | 1453 | 51.84, 83.51 | Zygor-A:22800 (WH 52, 83.4) |
| andromath | High Sorcerer Andromath (5694) | 1453 | 48.71, 87.61 | Zygor-A:22813 |
| maginor | Maginor Dumas (331) | 1453 | [stond in HandyNotes] | HN :211 (Zygor-D 49.24, 87.78) |
| garion | Garion Wendell (211033) | 1453 | 48.9, 86.5 | WH-tooltip 48.8-49.0, 86.4-86.6; AW; Codex |
| uthelnay | Uthel'nay (7311) | 1454 | 39.16, 86.27 | HN :186 (= Zygor) |
| unthuwa | Un'Thuwa (5880) | 1411 | 56.31, 75.11 | HN :79 (= Zygor) |
| cain | Cain Firesong (2128) | 1420 | [stond in HandyNotes] | HN :284 (Zygor 61.97, 52.47; WH 61.8, 52.4) |
| anastasia | Anastasia Hartwell (4568) | 1458 | 85.14, 10.03 | HN :302 (= Zygor hoofdgids) |
| josef | Josef Gregorian (4576) | 1458 | 70.75, 30.69 | Zygor-H:23956 |
| deino | Deino (5885) | 1454 | [stond in HandyNotes] | HN :183 |
| kilhala | Kil'hala (3484) | 1413 | 52.20, 31.70 | Zygor-H:23989 (WH 52.2, 31.6) |
| pierce | Pierce Shackleton (4567) | 1458 | [stond in HandyNotes] | HN :304 |
| owen | Owen Thadd (211022) | 1458 | 73.4, 33.0 | WH-tooltip 73.4-73.8, 32.2-33.0; AW |
| tabetha | Tabetha (6546) | 1445 | 46.06, 57.09 | Zygor-A:22854 (WH 46, 57) |
| tirth | Magus Tirth (6548) | 1441 | 78.29, 75.70 | Zygor-A:22860 |
| sanath | Sanath Lim-yo (8395) | 1447 | 28.11, 50.09 | Zygor-D A:8218 (WH 28, 50) |
| (RO.xylem) | Archmage Xylem (8379) | 1447 | 29.71, 40.52 | staat al in de module (WH 29.2-29.6, 40.2-40.6) |
| lydros | Lorekeeper Lydros (14368) | 1444 | 60.32, 30.16 | [A] de deur van Dire Maul West, zelfde punt als `W.dreadsteedSpirit`; WH heeft geen spawn |

| Sleutel | Wat | Map | x, y | Bron |
|---|---|---|---|---|
| mirrorLake | waterval Mirror Lake | 1429 | 28.78, 61.47 | Zygor-A:22714 |
| toolbox | Bink's Toolbox | 1426 | 27.7, 36.4 | wowhelm (QuestieDB, Classic-data); niet in Zygor |
| bough | Wind-Infused Bough | 2521 | 48.72, 67.77 | Zygor-C:1190 (WH-reactie 48.5, 68.2) |
| juju | Ju-Ju Heaps (Echo Isles) | 1411 | 67.76, 83.50 | Zygor-H:23899 (Polestar 67.8, 84.3) |
| snapdragons | Balnir Snapdragons | 1420 | 76.94, 62.38 | Zygor-H hoofdgids :1103 |
| cofferChestSW | Chest of Containment Coffers | 1453 | 49.54, 85.61 | Zygor-A:22741 |
| cantationSW | Cantation of Manifestation | 1453 | 49.62, 85.40 | Zygor-A:22746 |
| blueRecluse | The Blue Recluse (Rift Spawns) | 1453 | 51.12, 95.56 | Zygor-A:22756 (Polestar 51.3, 93.3) |
| riftGems | Miners' League Crates, Silver Stream Mine | 1432 | 35.85, 22.58 | Zygor-A:22788 |
| cofferChestUC | Chest en Cantation (Undercity) | 1458 | 85.65, 10.00 | Zygor-H:23921, 23926 |
| alchemist | alchemistenwinkel (Rift Spawns) | 1458 | 52.99, 74.92 | Zygor-H:23935 (Polestar 53.2, 74.5) |
| manaGems | Ambermill (Dalaran Mana Gems) | 1421 | 62.26, 64.24 | Zygor-H:23945 |
| treatise | Tower of Ilgalar | 1433 | 73.78, 47.64 | Zygor-A:22819 |
| spiderSilk | Raven Hill Cemetery | 1431 | 31.38, 26.95 | Zygor-A:22829 |
| xavian | waterval Xavian | 1440 | 76.33, 41.43 | Zygor-H:23974 |
| sisters | Laughing Sisters | 1440 | 58.61, 59.49 | Zygor-H:23984 (binnen de WH-spawns) |
| plucky | "Plucky" Johnson | 1441 | 79.60, 75.60 | Zygor-A:22867 |
| witherbark | Witherbark-trollen | 1417 | 66.66, 64.37 | Zygor-A:22882 |
| bramble | Circle of Outer Binding | 1417 | 52.06, 50.69 | Zygor-A:22889 |
| (RO.sm) | Scarlet Monastery | 1420 | 82.65, 32.88 | staat al in de module (= Zygor-A:22909) |
| summoners | Burning Blade Summoners | 1443 | 53.34, 79.05 | Zygor-A:22952 (binnen de WH-spawns) |
| demon | Demon of the Orb | 1445 | 46.04, 57.10 | Zygor-A:22969 |
| uldaman | Uldaman, achterdeur | 1418 | 65.05, 43.45 | Zygor Professions A:4891 (hoofdingang 44.6, 12.1: MH `ForeverDungeons.lua:78`) |
| surges | Mana Surges | 1445 | 45.85, 56.76 | Zygor-A:23002 |
| owlbeasts | Savage Owlbeasts | 1425 | 55.2, 51.4 | WH-tooltip npc 2929 (één van veel spawns) |
| zukkash | Zukk'ash (The Writhing Deep) | 1444 | 75.4, 61.4 | WH-tooltip npc 5245/5246 |
| zulfarrak | Zul'Farrak, ingang | 1446 | 38.7, 19.5 | MH `ForeverDungeons.lua:79` |
| dust | Thalassian Base Camp | 1447 | 56.94, 29.30 | Zygor-D A:8226 |
| coral | Spitelash Sirens | 1447 | 47.65, 43.93 | Zygor-D A:8240 |
| (P.sunken) | Sunken Temple | 1435 | 69.36, 56.89 | staat al in de module |
| dmEast | Dire Maul East, ingang | 1444 | 64.85, 30.18 | Zygor-A:23082 (MH `ForeverDungeons.lua:84`: 64.8, 30.2) |
| scalebeard | Scalebeard's Cave | 1447 | 54.20, 48.60 | HandyNotes_WoWForever Azshara.lua:39; WH npc 244188 (54.2, 48.6) |
| (krellian) | Warlord Krellian (8408) | 1447 | 41.0, 53.1 | Polestar; WH 40.4-41.6, 52.4-53.8 (alleen in de tekst) |

Wowhead-coördinaten staan in zone-ruimte; dat die gelijk is aan de UiMap = [A] (zelfde aanname als bij de druid).

## 6. Objective-index (volgorde in de Wowhead-tooltip)

Dat dit gelijk is aan de index van `C_QuestLog.GetQuestObjectives` = [A].

| Quest | 1 | 2 | 3 |
|---|---|---|---|
| 1861 | Mirror Lake Water Sample | | |
| 1880 | Mage-tastic Gizmonitor | | |
| 1882 | Balnir Snapdragons | | |
| 1884 | Ju-Ju Heaps Destroyed x4 | | |
| 93797 | Wind-Infused Bough | | |
| 1920 / 1960 | Filled Containment Coffer x3 | Chest of Containment Coffers | Cantation of Manifestation |
| 1921 | Linen Cloth x10 | Charged Rift Gem x6 | |
| 1961 | Linen Cloth x10 | Dalaran Mana Gem x6 | |
| 1938 | Ur's Treatise on Shadow Magic | | |
| 1940 | Pristine Spider Silk x8 | | |
| 1944 | Xavian Water Sample | | |
| 1945 | Laughing Sister's Hair x12 | | |
| 1948 | Jade | Bolt Charged Bramble | (Witherbark Totem Stick x10: bron-item) |
| 1950 | Secret phrase found | | |
| 1951 | Rituals of Power | | |
| 1954 | Infernal Orb | | |
| 1955 | twee regels in de tooltip → geen index | | |
| 1956 | Obsidian Power Source | | |
| 1957 | Mana Surge x12 | | |
| 82084 | Pristine Owlbeast Quill | Zukk'ash Resin x5 | Farraki Papyrus x8 |
| 8251 / 8252 / 8253 | Glittering Dust x10 / Enchanted Coral x6 / Arcane Shard | | |
| 7463 | Hydrospawn Essence | | |
| 90789 / 9362 | Prismatic Shell | | |
| 9364 | Polymorph Clone x50 | | |

## 7. NPC-namen per taal

[G] Wowhead Forever-tooltip per taal (17 nov): deDE `?locale=3`, frFR `2`, esES `6`, esMX `11`, ptBR `8`, ruRU `7`. Controle npc 233 in elke run (deDE "Bauer Saldean", frFR "Saldean le fermier", esES/esMX "Granjero Saldean", ptBR "Fazendeiro Saldanha", ruRU "Фермер Сальден").
Tweede bron Spoken (`Locale\Names\*.lua`): waar Spoken een naam heeft, is hij gelijk (5694, 14368, 1228, 2128, 4568, 5497, 5885, 328, 5144, 7311, 7312, 5880, 6546, 6548). [G]
Een naam tussen [haken] bij Wowhead = niet vertaald → weggelaten: esMX van 252373 en 8395. esMX van 14368 komt uit Spoken (esMX.lua:734); Wowhead heeft hem niet. [G]

| Id | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 328 | Zaldimar Wefhellt | = | = | = | = | = | Залдимар Вефхеллт |
| 5497 | Jennea Cannon | = | = | = | Jennea Cañón | Jana Catão | Джинния Пушка |
| 1228 | Magis Sparkmantle | = | = | Magis Chispamanto | Magis Chispamanto | Magis Fagulhamanto | Магис Искроплащ |
| 5144 | Bink | = | = | = | = | = | Бинк |
| 7312 | Dink | = | = | = | = | = | Динк |
| 252373 | Anathamaas Aetherwind | = | Anathamaas Vent-d'éther | Anathamaas Vientoéter | — | Anathamaas Brisetéria | Анатамаас Эфирный Ветер |
| 256507 | Belann Windwood | = | Belann Vif-Bois | Belann Vientomadera | Belann Vientosauco | Belann Lenhéolo | Беланн Древо Ветров |
| 1309 | Wynne Larson | = | = | = | = | Manoela Galante | Уинн Ларсон |
| 5694 | High Sorcerer Andromath | Zaubermeister Andromath | Grand sorcier Andromath | Sumo Hechicero Andromath | Sumo Hechicero Andromath | Grão-Feiticeiro Andromath | Верховный колдун Андромат |
| 331 | Maginor Dumas | = | = | = | = | = | Магинор Дюма |
| 211033 | Garion Wendell | = | = | = | = | = | Гэрион Уэнделл |
| 7311 | Uthel'nay | = | = | = | = | = | Утель'най |
| 5880 | Un'Thuwa | = | = | = | = | = | Ун'Тува |
| 2128 | Cain Firesong | = | = | Cain Pirosón | Cain Pirosón | Caio Cantígnea | Кейн Песнь Пламени |
| 4568 | Anastasia Hartwell | = | = | Anastasia Pozovenado | = | Anastácia Cordato | Анастасия Хартвелл |
| 4576 | Josef Gregorian | = | = | = | = | Josefo Gregório | Джозеф Грегориан |
| 5885 | Deino | = | = | = | = | Denya | Дейно |
| 3484 | Kil'hala | = | = | = | = | = | Кил'хала |
| 4567 | Pierce Shackleton | = | = | Pierce Esqueletonio | = | Frederico Grilhões | Пирс Шеклтон |
| 211022 | Owen Thadd | = | = | = | = | Adélio Tadeu | Оуэн Тадд |
| 6546 | Tabetha | = | = | = | = | = | Табета |
| 6548 | Magus Tirth | = | = | = | = | Tirth, o Mago | Волхв Тирт |
| 8395 | Sanath Lim-yo | = | = | = | — | = | Санат Лим-Йо |
| 14368 | Lorekeeper Lydros | Hüter des Wissens Lydros | Gardien du savoir Lydros | Tradicionalista Lydros | Tradicionalista Lydros (Spoken) | Erudito Lydros | Сказитель Лидрос |

"=" betekent: Wowhead gaf in die taal dezelfde naam zonder haken, dus de naam van die client. 8379 Archmage Xylem staat al in `NPC_NAMES`.

## 8. Fouten en gaten in Zygor

1. **Horde-gids begint met `ding 15`** vóór de level-10 quest 1883 (Zygor-H:23882; daarna nog een `ding 15` op 23907). De quest is level 10. [G] AW, IV.
2. **Undead level 10 ontbreekt in de class-gids** (1881/1882 staan alleen in de hoofdgids); **Gnome level 10 ontbreekt overal** (1879/1880 staan in geen enkele Zygor-gids). [G] grep op `##1879`/`##1880` gaf niets, `##1881` wel.
3. **Skyborne valt tussen wal en schip**: 1919 heeft alleen stappen `|only if Gnome Mage` en `|only if Human Mage` (Zygor-A:22723-22731). [G]
4. **`|q 18299 |future`** (Zygor-H:24223): 18299 is het item Hydrospawn Essence, geen quest. Moet 7463 zijn. [G]
5. **Return to the Marsh achter `ding 40`** (Zygor-A:22930, Zygor-H:24082); de quest kan vanaf 35. [G] AW, IV, Codex, Polestar.
6. **Tabetha's Task als mage-stap op `ding 46`**: min. level 40 en voor elke klasse. [G] AW, Polestar.
7. **Xylem op 28.11, 50.09** (Zygor-D A:8223-8253): dat is de plek van Sanath Lim-yo onder de toren. Xylem staat boven (WH 29.2-29.6, 40.2-40.6). Bruikbaar als looppunt, niet als NPC-plek. [G]
8. **Ontbreekt helemaal**: Polymorph: Pig (90789/9362 → 9364), Research Access 97286, A Lesson in Literacy 82084, Cain Firesong als gever van 1959. [G]
9. Tikfout "Slay #12# Manage Surges" (Zygor-A:23002, Zygor-H:24146). [G]

## 9. `ns.FOREVER_QUEST_FIRST` in `Modules/ForeverTrainer.lua`

**Geen mage-spells nodig.** De lijst is voor eerste ranks die alleen uit een quest komen en waar een trainerregel op wacht (`req`). In het MAGE-blok van `ForeverTrainerData.lua:345-519` heeft geen enkele regel `req` 10140, 28272 of 1302508; die drie id's komen er niet in voor. [G] De enige `req`-id's zonder eigen trainerregel zijn 133 en 168 (startspells, [A]) en talent-ranks (11366, 400574, 1312002, 11113, 1326079, 11426). [G]

## 10. Lua-schets (plaats ná het laatste class-blok)

De engine kan geen twee quests naast elkaar aan. Daarom staat Items of Power (1948) als eigen keten vóór de Mage's Wand-keten, met `needs = 1947`. Dat is altijd juist, maar niet de kortste route (Arathi komt vóór Shimmering Flats). Een kortere route vraagt één extra veld in de engine; dat is een keuze voor de bouwchat.
`spell` én `nameKey` samen: `ChainName` pakt de naam, `Step` de spell. Dat is nieuw, maar de code laat het toe (r. 1147 en 1183-1188 van de module).

```lua
--[[ Mage (17 Nov 2026; researched by mh-research on Fable). All facts: docs/forever/MAGE_CLASSQUESTS_2026-11-17.md:
	Zygor Forever "Mage Class Quests" + Common + the Sunken Temple dungeon guide, Spoken, wago DB2 1.60.1.70938 (local
	cache), Wowhead Forever, Icy Veins DB, azeroth.wiki, Polestar, HandyNotes.
	GEMETEN on Wowhead Forever: 7463 teaches Conjure Water 10140, 9364 teaches Polymorph 28272 (the pig), 97286 teaches
	Study 1302508. There are no rank quests and no teleport or portal quests (trainers). Mage races (CharBaseInfo): Human,
	Gnome, High Order Skyborne, Orc, Troll, Undead.
	NEW in Forever: Boughs in the Wind (93791-93797), Research Access (97286), A Lesson in Literacy (82084), Scalebeard
	(90789; shares its completion bit with 9362 Warlord Krellian).
	AFGELEID: which race walks which route; that a pointer quest may be skipped (Troll starts at 1884, Skyborne at 1861);
	Orc and Skyborne on the level 15 and 26 chains (sources disagree); 90789 before 9362; the trainer per race from level 30;
	level 6 for Study; Lydros' place = the Dire Maul West door; the objective index.
	1955 has no objective index on purpose (Wowhead shows two lines). 1948 runs beside 1949-1951: its own chain, first.
	Not built: Tabetha's Task / Tiara of the Deep (any class), The Arcanist's Cookbook (starts from an item), the level 1
	letters (experience only). Destroy Morphaz probably pays experience only (its Classic items are not in ItemSparse).
	Zygor mistakes not copied: ding 15 before the level 10 quest, |q 18299 (= 7463), Return to the Marsh at 40 (= 35). ]]
local MA_P = {
	zaldimar = { npc = "Zaldimar Wefhellt", id = 328, m = 1429, xy = "stond in HandyNotes" },
	jennea = { npc = "Jennea Cannon", id = 5497, m = 1453, xy = "stond in HandyNotes" },
	magis = { npc = "Magis Sparkmantle", id = 1228, m = 1426, xy = "stond in HandyNotes" },
	bink = { npc = "Bink", id = 5144, m = 1455, xy = "stond in HandyNotes" },
	dink = { npc = "Dink", id = 7312, m = 1455, xy = "stond in HandyNotes" },
	anathamaas = { npc = "Anathamaas Aetherwind", id = 252373, m = 2521, x = 65.80, y = 80.50 },
	belann = { npc = "Belann Windwood", id = 256507, m = 2521, x = 62.90, y = 77.44 },
	wynne = { npc = "Wynne Larson", id = 1309, m = 1453, x = 51.84, y = 83.51 },
	andromath = { npc = "High Sorcerer Andromath", id = 5694, m = 1453, x = 48.71, y = 87.61 },
	maginor = { npc = "Maginor Dumas", id = 331, m = 1453, xy = "stond in HandyNotes" },
	garion = { npc = "Garion Wendell", id = 211033, m = 1453, x = 48.9, y = 86.5 },
	uthelnay = { npc = "Uthel'nay", id = 7311, m = 1454, x = 39.16, y = 86.27 },
	unthuwa = { npc = "Un'Thuwa", id = 5880, m = 1411, x = 56.31, y = 75.11 },
	cain = { npc = "Cain Firesong", id = 2128, m = 1420, xy = "stond in HandyNotes" },
	anastasia = { npc = "Anastasia Hartwell", id = 4568, m = 1458, x = 85.14, y = 10.03 },
	josef = { npc = "Josef Gregorian", id = 4576, m = 1458, x = 70.75, y = 30.69 },
	deino = { npc = "Deino", id = 5885, m = 1454, xy = "stond in HandyNotes" },
	kilhala = { npc = "Kil'hala", id = 3484, m = 1413, x = 52.20, y = 31.70 },
	pierce = { npc = "Pierce Shackleton", id = 4567, m = 1458, xy = "stond in HandyNotes" },
	owen = { npc = "Owen Thadd", id = 211022, m = 1458, x = 73.4, y = 33.0 },
	tabetha = { npc = "Tabetha", id = 6546, m = 1445, x = 46.06, y = 57.09 },
	tirth = { npc = "Magus Tirth", id = 6548, m = 1441, x = 78.29, y = 75.70 },
	sanath = { npc = "Sanath Lim-yo", id = 8395, m = 1447, x = 28.11, y = 50.09 },
	-- Lydros stands inside Dire Maul (the Athenaeum): the arrow points at the West door (AFGELEID).
	lydros = { npc = "Lorekeeper Lydros", id = 14368, m = 1444, x = 60.32, y = 30.16 },
	-- Objective places (no NPC).
	mirrorLake = { m = 1429, x = 28.78, y = 61.47 },
	toolbox = { m = 1426, x = 27.7, y = 36.4 },
	bough = { m = 2521, x = 48.72, y = 67.77 },
	juju = { m = 1411, x = 67.76, y = 83.50 },
	snapdragons = { m = 1420, x = 76.94, y = 62.38 },
	cofferChestSW = { m = 1453, x = 49.54, y = 85.61 },
	cantationSW = { m = 1453, x = 49.62, y = 85.40 },
	blueRecluse = { m = 1453, x = 51.12, y = 95.56 },
	riftGems = { m = 1432, x = 35.85, y = 22.58 },
	cofferChestUC = { m = 1458, x = 85.65, y = 10.00 },
	alchemist = { m = 1458, x = 52.99, y = 74.92 },
	manaGems = { m = 1421, x = 62.26, y = 64.24 },
	treatise = { m = 1433, x = 73.78, y = 47.64 },
	spiderSilk = { m = 1431, x = 31.38, y = 26.95 },
	xavian = { m = 1440, x = 76.33, y = 41.43 },
	sisters = { m = 1440, x = 58.61, y = 59.49 },
	plucky = { m = 1441, x = 79.60, y = 75.60 },
	witherbark = { m = 1417, x = 66.66, y = 64.37 },
	bramble = { m = 1417, x = 52.06, y = 50.69 },
	summoners = { m = 1443, x = 53.34, y = 79.05 },
	demon = { m = 1445, x = 46.04, y = 57.10 },
	uldaman = { m = 1418, x = 65.05, y = 43.45 },
	surges = { m = 1445, x = 45.85, y = 56.76 },
	owlbeasts = { m = 1425, x = 55.2, y = 51.4 },
	zukkash = { m = 1444, x = 75.4, y = 61.4 },
	zulfarrak = { m = 1446, x = 38.7, y = 19.5 },
	dust = { m = 1447, x = 56.94, y = 29.30 },
	coral = { m = 1447, x = 47.65, y = 43.93 },
	dmEast = { m = 1444, x = 64.85, y = 30.18 },
	scalebeard = { m = 1447, x = 54.20, y = 48.60 },
}
local MA = MA_P

-- Level 10: one staff-or-orb quest per character (1861/1880 and 1882/1884 share a completion bit in QuestV2), so each
-- route names the other as alt.
local function MaFocus(faction, races, quests)
	return { key = "focus", nameKey = "FCQ_CHAIN_MA_FOCUS", level = 10, faction = faction, races = races, quests = quests }
end
local MA_MIRROR = { q = 1861, alt = { 1880 }, from = MA.jennea, objs = { O(MA.mirrorLake, "FCQ_OBJ_MA_MIRRORLAKE", 1) },
	to = MA.jennea }
local MA_JUJU = { q = 1884, alt = { 1882 }, from = MA.unthuwa, objs = { O(MA.juju, "FCQ_OBJ_MA_JUJU", 1) }, to = MA.unthuwa }

-- Level 15: the robe. Orc and Skyborne: the sources disagree whether they may take it (not seen in game).
local function MaRobeA(races, starter)
	return { key = "robe", nameKey = "FCQ_CHAIN_MA_ROBE_A", level = 15, faction = "Alliance", races = races, quests = {
		{ q = 1919, from = starter, to = MA.jennea },
		{ q = 1920, from = MA.jennea, objs = {
			O(MA.cofferChestSW, "FCQ_OBJ_MA_COFFERCHEST", 2),
			O(MA.cantationSW, "FCQ_OBJ_MA_CANTATION", 3),
			O(MA.blueRecluse, "FCQ_OBJ_MA_COFFERS_A", 1),
		}, to = MA.jennea },
		{ q = 1921, from = MA.jennea, objs = { O(MA.riftGems, "FCQ_OBJ_MA_RIFTGEMS", 2), O(nil, "FCQ_OBJ_MA_LINEN", 1) },
			to = MA.wynne },
		{ q = 1941, from = MA.wynne, to = MA.wynne },
	} }
end
local function MaRobeH(races, starter)
	return { key = "robe", nameKey = "FCQ_CHAIN_MA_ROBE_H", level = 15, faction = "Horde", races = races, quests = {
		{ q = 1959, from = starter, to = MA.anastasia },
		{ q = 1960, from = MA.anastasia, objs = {
			O(MA.cofferChestUC, "FCQ_OBJ_MA_COFFERCHEST", 2),
			O(MA.cofferChestUC, "FCQ_OBJ_MA_CANTATION", 3),
			O(MA.alchemist, "FCQ_OBJ_MA_COFFERS_H", 1),
		}, to = MA.anastasia },
		{ q = 1961, from = MA.anastasia, objs = { O(MA.manaGems, "FCQ_OBJ_MA_MANAGEMS", 2), O(nil, "FCQ_OBJ_MA_LINEN", 1) },
			to = MA.josef },
		{ q = 1962, from = MA.josef, to = MA.josef },
	} }
end
local function MaGarmentA(races, starter)
	return { key = "garment", nameKey = "FCQ_CHAIN_MA_GARMENT_A", level = 26, faction = "Alliance", races = races, quests = {
		{ q = 1939, from = starter, to = MA.andromath },
		{ q = 1938, from = MA.andromath, objs = { O(MA.treatise, "FCQ_OBJ_MA_TREATISE", 1) }, to = MA.andromath },
		{ q = 1940, from = MA.andromath, objs = { O(MA.spiderSilk, "FCQ_OBJ_MA_SILK", 1) }, to = MA.wynne },
		{ q = 1942, from = MA.wynne, to = MA.wynne },
	} }
end

CHAINS.MAGE = {
	MaFocus("Alliance", HUM, { { q = 1860, alt = { 1879 }, from = MA.zaldimar, to = MA.jennea }, MA_MIRROR }),
	MaFocus("Alliance", GNO, {
		{ q = 1879, alt = { 1860 }, from = MA.magis, to = MA.bink },
		{ q = 1880, alt = { 1861 }, from = MA.bink, objs = { O(MA.toolbox, "FCQ_OBJ_MA_GIZMONITOR", 1) }, to = MA.bink },
	}),
	-- Skyborne: NEW in Forever. The wand on Zephras Isle first (table order), Mirror Lake once they reach Stormwind
	-- (1860 is for Human and Gnome only; Jennea gives 1861 without it: Polestar, not seen in game).
	{ key = "windbough", nameKey = "FCQ_CHAIN_MA_WINDBOUGH", level = 10, faction = "Alliance", races = SKYBORNE, quests = {
		{ q = 93791, from = MA.anathamaas, to = MA.belann },
		{ q = 93797, from = MA.belann, objs = { O(MA.bough, "FCQ_OBJ_MA_BOUGH", 1) }, to = MA.belann },
	} },
	MaFocus("Alliance", SKYBORNE, { MA_MIRROR }),
	-- 1883 is a pointer from Orgrimmar; a Troll in Sen'jin takes 1884 straight from Un'Thuwa (Polestar).
	MaFocus("Horde", ORC, { { q = 1883, alt = { 1881 }, from = MA.uthelnay, to = MA.unthuwa }, MA_JUJU }),
	MaFocus("Horde", TROLL, { MA_JUJU }),
	MaFocus("Horde", UD, {
		{ q = 1881, alt = { 1883 }, from = MA.cain, to = MA.anastasia },
		{ q = 1882, alt = { 1884 }, from = MA.anastasia, objs = { O(MA.snapdragons, "FCQ_OBJ_MA_SNAPDRAGONS", 1) },
			to = MA.anastasia },
	}),
	MaRobeA(HUMSKY, MA.zaldimar),
	MaRobeA(GNO, MA.dink),
	MaRobeH(ORCTROLL, MA.uthelnay),
	MaRobeH(UD, MA.cain),
	MaGarmentA(HUMSKY, MA.jennea),
	MaGarmentA(GNO, MA.bink),
	{ key = "garment", nameKey = "FCQ_CHAIN_MA_GARMENT_H", level = 26, faction = "Horde", quests = {
		{ q = 1943, from = MA.anastasia, to = MA.deino },
		{ q = 1944, from = MA.deino, objs = { O(MA.xavian, "FCQ_OBJ_MA_XAVIAN", 1) }, to = MA.deino },
		{ q = 1945, from = MA.deino, objs = { O(MA.sisters, "FCQ_OBJ_MA_SISTERS", 1) }, to = MA.kilhala },
		{ q = 1946, from = MA.kilhala, to = MA.kilhala },
	} },
}
-- From level 30 every mage trainer hands out the pointer; the trainer per race is a choice (AFGELEID).
-- c = { faction, races, trainer (1947/1953), giver of Magecraft, librarian }
for _, c in ipairs({
	{ "Alliance", HUMSKY, MA.jennea, MA.maginor, MA.garion },
	{ "Alliance", GNO, MA.bink, MA.dink, MA.garion },
	{ "Horde", ORCTROLL, MA.deino, MA.uthelnay, MA.owen },
	{ "Horde", UD, MA.anastasia, MA.pierce, MA.owen },
}) do
	local faction, races, trainer, master, librarian = c[1], c[2], c[3], c[4], c[5]
	-- NEW in Forever. The librarian only offers 97286 after your first library book: e.wait says so. Study is a recipe in
	-- the Comprehension tab: whether the spell check sees it = NOT measured; the chain also ends once 97286 is done.
	table.insert(CHAINS.MAGE, { key = "study", spell = 1302508, nameKey = "FCQ_CHAIN_MA_STUDY", level = 6, faction = faction,
		races = races, quests = {
			{ q = 97286, from = librarian, wait = "FCQ_WAIT_MA_BOOK", to = librarian },
		} })
	-- Items of Power runs beside 1949-1951 and Mage's Wand needs both: its own chain, BEFORE the wand chain (table order),
	-- open once 1947 is done. The sticks are no objective: one stick or the bramble in your bags counts (a limit).
	table.insert(CHAINS.MAGE, { key = "items", nameKey = "FCQ_CHAIN_MA_ITEMS", level = 30, needs = 1947, faction = faction,
		races = races, quests = {
			{ q = 1948, from = MA.tabetha, objs = {
				O(MA.witherbark, "FCQ_OBJ_MA_STICKS", nil, { 7273, 7272 }),
				O(MA.bramble, "FCQ_OBJ_MA_BRAMBLE", 2),
				O(nil, "FCQ_OBJ_MA_JADE", 1),
			}, to = MA.tabetha },
		} })
	table.insert(CHAINS.MAGE, { key = "wand", nameKey = "FCQ_CHAIN_MA_WAND", level = 30, faction = faction, races = races,
		quests = {
			{ q = 1947, from = trainer, to = MA.tabetha },
			{ q = 1949, from = MA.tabetha, to = MA.tirth },
			{ q = 1950, from = MA.tirth, objs = { O(MA.plucky, "FCQ_OBJ_MA_PLUCKY", 1) }, to = MA.tirth },
			{ q = 1951, from = MA.tirth, objs = { O(RO.sm, "FCQ_OBJ_MA_RITUALS", 1) }, to = MA.tabetha },
			-- Offered a few seconds after 1951 and 1948 are both handed in (Tabetha's ritual).
			{ q = 1952, from = MA.tabetha, wait = "FCQ_WAIT_MA_RITUAL", to = MA.tabetha },
		} })
	table.insert(CHAINS.MAGE, { key = "celestial", nameKey = "FCQ_CHAIN_MA_CELESTIAL", level = 35, faction = faction,
		races = races, quests = {
			{ q = 1953, from = trainer, to = MA.tabetha },
			{ q = 1954, from = MA.tabetha, objs = { O(MA.summoners, "FCQ_OBJ_MA_ORB", 1) }, to = MA.tabetha },
			-- No index on purpose (Wowhead shows two lines, Zygor says /1): waits until the client says complete.
			{ q = 1955, from = MA.tabetha, objs = { O(MA.demon, "FCQ_OBJ_MA_DEMON") }, to = MA.tabetha },
			{ q = 1956, from = MA.tabetha, objs = { O(MA.uldaman, "FCQ_OBJ_MA_POWERSOURCE", 1) }, to = MA.tabetha },
			{ q = 1957, from = MA.tabetha, objs = { O(MA.surges, "FCQ_OBJ_MA_SURGES", 1) }, to = MA.tabetha },
			{ q = 1958, from = MA.tabetha, to = MA.tabetha },
		} })
	-- NEW in Forever. Whether it needs Research Access first = NOT measured.
	table.insert(CHAINS.MAGE, { key = "spellbook", nameKey = "FCQ_CHAIN_MA_SPELLBOOK", level = 42, faction = faction,
		races = races, quests = {
			{ q = 82084, from = librarian, objs = {
				O(MA.owlbeasts, "FCQ_OBJ_MA_QUILL", 1),
				O(MA.zukkash, "FCQ_OBJ_MA_RESIN", 2),
				O(MA.zulfarrak, "FCQ_OBJ_MA_PAPYRUS", 3),
			}, to = librarian },
		} })
	-- Magecraft (50). What 8253 pays in Forever is not measured (the Classic items are not in ItemSparse 70938).
	table.insert(CHAINS.MAGE, { key = "magecraft", nameKey = "FCQ_CHAIN_MA_MAGECRAFT", level = 50, faction = faction,
		races = races, quests = {
			{ q = 8250, from = master, to = MA.sanath },
			{ q = 8251, from = RO.xylem, objs = { O(MA.dust, "FCQ_OBJ_MA_DUST", 1) }, to = RO.xylem },
			{ q = 8252, from = RO.xylem, objs = { O(MA.coral, "FCQ_OBJ_MA_CORAL", 1) }, to = RO.xylem },
			{ q = 8253, from = RO.xylem, objs = { O(P.sunken, "FCQ_OBJ_MA_SHARD", 1) }, to = RO.xylem },
		} })
	-- Conjure Water Rank 7 (60): the giver stands inside Dire Maul.
	table.insert(CHAINS.MAGE, { key = "water", spell = 10140, nameKey = "FCQ_CHAIN_MA_WATER", level = 60, faction = faction,
		races = races, quests = {
			{ q = 7463, from = MA.lydros, objs = { O(MA.dmEast, "FCQ_OBJ_MA_HYDROSPAWN", 1) }, to = MA.lydros },
		} })
	-- Polymorph: Pig (60). 90789 Scalebeard is NEW and shares its completion bit with 9362 Warlord Krellian: alt.
	table.insert(CHAINS.MAGE, { key = "pig", spell = 28272, nameKey = "FCQ_CHAIN_MA_PIG", level = 60, faction = faction,
		races = races, quests = {
			{ q = 90789, alt = { 9362 }, from = RO.xylem, objs = { O(MA.scalebeard, "FCQ_OBJ_MA_SHELL", 1) }, to = RO.xylem },
			{ q = 9364, from = RO.xylem, objs = { O(MA.coral, "FCQ_OBJ_MA_CLONES", 1) }, to = RO.xylem },
		} })
end
```

### `NPC_NAMES`-regels

```lua
	-- Mage (17 Nov 2026, mh-research: Wowhead Forever tooltips per locale; control npc 233; Spoken agreed where it had a
	-- name). 252373 and 8395 esMX: not on Wowhead, left out. 14368 esMX: from Spoken (Wowhead has none).
	[328] = { deDE = "Zaldimar Wefhellt", frFR = "Zaldimar Wefhellt", esES = "Zaldimar Wefhellt", esMX = "Zaldimar Wefhellt", ptBR = "Zaldimar Wefhellt", ruRU = "Залдимар Вефхеллт" },
	[5497] = { deDE = "Jennea Cannon", frFR = "Jennea Cannon", esES = "Jennea Cannon", esMX = "Jennea Cañón", ptBR = "Jana Catão", ruRU = "Джинния Пушка" },
	[1228] = { deDE = "Magis Sparkmantle", frFR = "Magis Sparkmantle", esES = "Magis Chispamanto", esMX = "Magis Chispamanto", ptBR = "Magis Fagulhamanto", ruRU = "Магис Искроплащ" },
	[5144] = { deDE = "Bink", frFR = "Bink", esES = "Bink", esMX = "Bink", ptBR = "Bink", ruRU = "Бинк" },
	[7312] = { deDE = "Dink", frFR = "Dink", esES = "Dink", esMX = "Dink", ptBR = "Dink", ruRU = "Динк" },
	[252373] = { deDE = "Anathamaas Aetherwind", frFR = "Anathamaas Vent-d'éther", esES = "Anathamaas Vientoéter", ptBR = "Anathamaas Brisetéria", ruRU = "Анатамаас Эфирный Ветер" },
	[256507] = { deDE = "Belann Windwood", frFR = "Belann Vif-Bois", esES = "Belann Vientomadera", esMX = "Belann Vientosauco", ptBR = "Belann Lenhéolo", ruRU = "Беланн Древо Ветров" },
	[1309] = { deDE = "Wynne Larson", frFR = "Wynne Larson", esES = "Wynne Larson", esMX = "Wynne Larson", ptBR = "Manoela Galante", ruRU = "Уинн Ларсон" },
	[5694] = { deDE = "Zaubermeister Andromath", frFR = "Grand sorcier Andromath", esES = "Sumo Hechicero Andromath", esMX = "Sumo Hechicero Andromath", ptBR = "Grão-Feiticeiro Andromath", ruRU = "Верховный колдун Андромат" },
	[331] = { deDE = "Maginor Dumas", frFR = "Maginor Dumas", esES = "Maginor Dumas", esMX = "Maginor Dumas", ptBR = "Maginor Dumas", ruRU = "Магинор Дюма" },
	[211033] = { deDE = "Garion Wendell", frFR = "Garion Wendell", esES = "Garion Wendell", esMX = "Garion Wendell", ptBR = "Garion Wendell", ruRU = "Гэрион Уэнделл" },
	[7311] = { deDE = "Uthel'nay", frFR = "Uthel'nay", esES = "Uthel'nay", esMX = "Uthel'nay", ptBR = "Uthel'nay", ruRU = "Утель'най" },
	[5880] = { deDE = "Un'Thuwa", frFR = "Un'Thuwa", esES = "Un'Thuwa", esMX = "Un'Thuwa", ptBR = "Un'Thuwa", ruRU = "Ун'Тува" },
	[2128] = { deDE = "Cain Firesong", frFR = "Cain Firesong", esES = "Cain Pirosón", esMX = "Cain Pirosón", ptBR = "Caio Cantígnea", ruRU = "Кейн Песнь Пламени" },
	[4568] = { deDE = "Anastasia Hartwell", frFR = "Anastasia Hartwell", esES = "Anastasia Pozovenado", esMX = "Anastasia Hartwell", ptBR = "Anastácia Cordato", ruRU = "Анастасия Хартвелл" },
	[4576] = { deDE = "Josef Gregorian", frFR = "Josef Gregorian", esES = "Josef Gregorian", esMX = "Josef Gregorian", ptBR = "Josefo Gregório", ruRU = "Джозеф Грегориан" },
	[5885] = { deDE = "Deino", frFR = "Deino", esES = "Deino", esMX = "Deino", ptBR = "Denya", ruRU = "Дейно" },
	[3484] = { deDE = "Kil'hala", frFR = "Kil'hala", esES = "Kil'hala", esMX = "Kil'hala", ptBR = "Kil'hala", ruRU = "Кил'хала" },
	[4567] = { deDE = "Pierce Shackleton", frFR = "Pierce Shackleton", esES = "Pierce Esqueletonio", esMX = "Pierce Shackleton", ptBR = "Frederico Grilhões", ruRU = "Пирс Шеклтон" },
	[211022] = { deDE = "Owen Thadd", frFR = "Owen Thadd", esES = "Owen Thadd", esMX = "Owen Thadd", ptBR = "Adélio Tadeu", ruRU = "Оуэн Тадд" },
	[6546] = { deDE = "Tabetha", frFR = "Tabetha", esES = "Tabetha", esMX = "Tabetha", ptBR = "Tabetha", ruRU = "Табета" },
	[6548] = { deDE = "Magus Tirth", frFR = "Magus Tirth", esES = "Magus Tirth", esMX = "Magus Tirth", ptBR = "Tirth, o Mago", ruRU = "Волхв Тирт" },
	[8395] = { deDE = "Sanath Lim-yo", frFR = "Sanath Lim-yo", esES = "Sanath Lim-yo", ptBR = "Sanath Lim-yo", ruRU = "Санат Лим-Йо" },
	[14368] = { deDE = "Hüter des Wissens Lydros", frFR = "Gardien du savoir Lydros", esES = "Tradicionalista Lydros", esMX = "Tradicionalista Lydros", ptBR = "Erudito Lydros", ruRU = "Сказитель Лидрос" },
```

### enUS-tekstvoorstellen

De details in de zinnen (waar iets ligt, hoe het werkt) komen uit Polestar en Zygor-tips: gids, niet gemeten.

```lua
	-- Mage class quests (17 Nov 2026; facts docs/forever/MAGE_CLASSQUESTS_2026-11-17.md). Same name rule as above.
	FCQ_CHAIN_MA_FOCUS = "Your first staff or orb",
	FCQ_CHAIN_MA_WINDBOUGH = "Windbough Wand (a wand)",
	FCQ_CHAIN_MA_ROBE_A = "Manaweave Robe (a robe)",
	FCQ_CHAIN_MA_ROBE_H = "Lesser Spellfire Robes (a robe)",
	FCQ_CHAIN_MA_GARMENT_A = "Astral Knot Garment (a robe or blouse)",
	FCQ_CHAIN_MA_GARMENT_H = "Nether-lace Garment (a robe or tunic)",
	FCQ_CHAIN_MA_STUDY = "Study (free scrolls from the library, once an hour)",
	FCQ_CHAIN_MA_ITEMS = "Items of Power (you need it for the Mage's Wand)",
	FCQ_CHAIN_MA_WAND = "Mage's Wand (a frost, arcane or fire wand)",
	FCQ_CHAIN_MA_CELESTIAL = "Celestial Power (an orb or a staff)",
	FCQ_CHAIN_MA_SPELLBOOK = "A Lesson in Literacy (the Personal Spellbook, for your off hand)",
	FCQ_CHAIN_MA_MAGECRAFT = "Magecraft (Archmage Xylem's quests)",
	FCQ_CHAIN_MA_WATER = "Conjure Water (Rank 7)",
	FCQ_CHAIN_MA_PIG = "Polymorph: Pig",
	FCQ_OBJ_MA_MIRRORLAKE = "stand under the waterfall of Mirror Lake and use Jennea's Flask from your bags",
	FCQ_OBJ_MA_GIZMONITOR = "take the Mage-tastic Gizmonitor from Bink's Toolbox: a small grey box in the taller hut north of the Gnomeregan gate (Leper Gnomes guard it)",
	FCQ_OBJ_MA_BOUGH = "pick up a Wind-Infused Bough from the ground by the wind shrine (it does not sparkle)",
	FCQ_OBJ_MA_JUJU = "on the big Echo Isle, click 4 Ju-Ju Heaps: the skull piles inside the huts",
	FCQ_OBJ_MA_SNAPDRAGONS = "pick the Balnir Snapdragons in the garden of the farm (they look like bushes; no Herbalism needed)",
	FCQ_OBJ_MA_COFFERCHEST = "take the Chest of Containment Coffers: it stands right behind the trainer",
	FCQ_OBJ_MA_CANTATION = "take the Cantation of Manifestation: the scroll right behind the trainer",
	FCQ_OBJ_MA_COFFERS_A = "in the Blue Recluse (the tavern, best in the cellar) use the Cantation of Manifestation, beat a Rift Spawn until it sits stunned, use the Chest of Containment Coffers on it and click the Filled Containment Coffer on the floor. You need 3; the Cantation works once every 5 minutes",
	FCQ_OBJ_MA_COFFERS_H = "on the bridge in front of the alchemist shop use the Cantation of Manifestation, beat a Rift Spawn until it sits stunned, use the Chest of Containment Coffers on it and click the Filled Containment Coffer on the floor. You need 3; the Cantation works once every 5 minutes",
	FCQ_OBJ_MA_RIFTGEMS = "in the Silver Stream Mine, open the tall stacks of Miners' League Crates for 6 Charged Rift Gems",
	FCQ_OBJ_MA_MANAGEMS = "defeat Dalaran mages around Ambermill for 6 Dalaran Mana Gems",
	FCQ_OBJ_MA_LINEN = "you also need 10 Linen Cloth (humanoids drop it, or buy it at the Auction House)",
	FCQ_OBJ_MA_TREATISE = "climb to the top floor of the Tower of Ilgalar and take Ur's Treatise on Shadow Magic from the bookshelf",
	FCQ_OBJ_MA_SILK = "defeat spiders at Raven Hill Cemetery for 8 Pristine Spider Silk (Carrion Recluses drop it most)",
	FCQ_OBJ_MA_XAVIAN = "swim in under the highest waterfall at Xavian and use Deino's Flask from your bags",
	FCQ_OBJ_MA_SISTERS = "defeat Laughing Sisters (dryads) for 12 Laughing Sister's Hairs",
	FCQ_WAIT_MA_BOOK = "first bring any library book to the librarian (the books lie on tables and shelves in the world). After your first book the librarian offers Research Access",
	FCQ_OBJ_MA_STICKS = "defeat Witherbark trolls for 10 Witherbark Totem Sticks",
	FCQ_OBJ_MA_BRAMBLE = "clear the elementals, then use a Witherbark Totem Stick from your bags at the middle stone of the Circle of Outer Binding. Wait about ten seconds and click the Bolt Charged Bramble",
	FCQ_OBJ_MA_JADE = "you also need 1 Jade (a gem: miners find it, or buy it at the Auction House)",
	FCQ_OBJ_MA_PLUCKY = "target \"Plucky\" Johnson (a small chicken), type /beckon, then talk to him and ask for the phrase",
	FCQ_OBJ_MA_RITUALS = "in the dungeon Scarlet Monastery, Library (you need a group), take the book Rituals of Power from the shelf on the left in the last long hallway",
	FCQ_WAIT_MA_RITUAL = "hand in Rituals of Power and Items of Power, wait a few seconds for Tabetha's ritual, then take Mage's Wand from her",
	FCQ_OBJ_MA_ORB = "defeat Burning Blade Summoners for the Infernal Orb",
	FCQ_OBJ_MA_DEMON = "defeat the Demon of the Orb in Tabetha's garden: a level 40 elite, and the quest has a timer (bring help or potions)",
	FCQ_OBJ_MA_POWERSOURCE = "in the dungeon Uldaman (you need a group; this back door is closest), defeat the Obsidian Sentinel for the Obsidian Power Source",
	FCQ_OBJ_MA_SURGES = "defeat 12 Mana Surges next to Tabetha's house before the time runs out",
	FCQ_OBJ_MA_QUILL = "defeat owlbeasts for 1 Pristine Owlbeast Quill (Savage Owlbeasts drop it most)",
	FCQ_OBJ_MA_RESIN = "defeat Zukk'ash insects in the Writhing Deep for 5 Zukk'ash Resin",
	FCQ_OBJ_MA_PAPYRUS = "in the dungeon Zul'Farrak (you need a group), get 8 Farraki Papyrus from the Shallow Graves and the zombies that rise from them",
	FCQ_OBJ_MA_DUST = "defeat Blood Elf Surveyors and Reclaimers for 10 Glittering Dust",
	FCQ_OBJ_MA_CORAL = "defeat Spitelash Sirens for 6 Enchanted Coral",
	FCQ_OBJ_MA_SHARD = "in the dungeon Sunken Temple (you need a group), get the Arcane Shard from Morphaz",
	FCQ_OBJ_MA_HYDROSPAWN = "in the dungeon Dire Maul East (you need a group), defeat Hydrospawn for the Hydrospawn Essence",
	FCQ_OBJ_MA_SHELL = "defeat Scalebeard (a turtle) in his cave for the Prismatic Shell. If your quest is called Warlord Krellian: he stands in the Temple of Zin-Malor (41.0, 53.1)",
	FCQ_OBJ_MA_CLONES = "keep the Prismatic Shell in your bags, cast Polymorph on a Spitelash naga, wait a few seconds and defeat the Polymorph Clones that appear. Repeat until you have 50 (not in a raid group)",
```

Spelnamen in deze teksten (items, NPC's, plekken) moeten in de/fr/es/esMX/pt/ru de naam van die client krijgen; item-namen per taal staan in de DB2-cache (`ItemSparse.<taal>.csv`).

## 11. Open / niet gemeten

1. **Niets is in het spel gezien.** Quest-id's, coördinaten en objective-nummers zijn onbewezen tot `/mh classquest` ze afvinkt.
2. 🔴 **Orc en Skyborne op level 15 (robe) en 26 (gewaad):** azeroth.wiki, Codex en Polestar spreken elkaar tegen. De schets laat ze toe. Fout = een regel in "Doe dit nu" die nooit weggaat. Test: een Orc- of Skyborne-mage op level 15 bij Uthel'nay / Zaldimar.
3. **Skyborne en Mirror Lake zonder 1860:** alleen Polestar zegt dat Jennea hem zo geeft.
4. **Aanwijzers overslaan** (1883 voor de Troll): alleen Polestar + de woordkeus van azeroth.wiki.
5. **90789 Scalebeard of 9362 Warlord Krellian:** welke biedt Xylem aan? De schets dekt beide (`alt`), de pijl wijst naar Scalebeard.
6. **Wat 8253 Destroy Morphaz betaalt.** En hetzelfde voor de level-50 ketens van druid, hunter, rogue en warrior (items ontbreken in ItemSparse).
7. **Research Access:** hoeveel boeken, of de quest in je log komt of meteen klaar is, of `IsPlayerSpell(1302508)` Study ziet, en of level 6 een goed moment is (keuze; de quest zelf vraagt level 1).
8. **A Lesson in Literacy:** of Research Access eerst moet; plekken van de owlbeasts en Zukk'ash zijn één Wowhead-spawn uit veel.
9. **Items of Power naast de wandketen:** de schets is veilig maar loopt om. Korter kan met een nieuw veld (bv. een objective dat ook telt als een andere quest gedaan is).
10. **Witherbark Totem Sticks:** één stick in je tas telt al als "klaar" (de engine telt niet).
11. **Lydros staat in Dire Maul:** de pijl wijst naar de deur van West; die coördinaat is overgenomen van het warlock-blok.
12. **Bink's Toolbox 27.7, 36.4:** Classic-data (QuestieDB via wowhelm).
13. **Cain Firesong:** HandyNotes [stond in HandyNotes] wijkt 0,4 af van Zygor en Wowhead.
14. **Spellfire Robes:** Josef Gregorian of Rhiannon Davis als gever (ze staan naast elkaar).
15. **Tijden** bij The Exorcism en Mana Surges: alleen Polestar.
16. **esMX-namen** van 252373 en 8395 ontbreken; 14368 esMX komt alleen uit Spoken.
17. **Xylem:** de pijl wijst naar de torentop; de weg omhoog is Sanath Lim-yo (28.11, 50.09), die je teleporteert.
