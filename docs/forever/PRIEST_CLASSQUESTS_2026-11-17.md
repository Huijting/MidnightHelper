# Priest class-quests in WoW Forever — feiten voor `Modules/ForeverClassQuests.lua`

17 nov 2026, mh-research (Fable). Client: WoW Forever build **1.60.1.70938**. Alleen gelezen, niets gebouwd.
De voordeur (`_probe.py` / `run gamedata`) is in deze ronde **niet** gebruikt (opdracht). DB2 komt uit de lokale cache,
het web via Exa-fetch en WebFetch.

**Legenda:** **G** = GEMETEN (gezien in de genoemde bron), **A** = AFGELEID (beredeneerd). Een leeg zoekresultaat telt
nergens als bewijs; waar ik "niet gevonden" zeg, staat de positieve controle erbij.

---

## 0. In het kort

1. **Zes rassen kunnen priest zijn**: Human, Dwarf, Night Elf, **Gnome (nieuw)**, Undead, Troll. Geen Skyborne, Orc of Tauren. (G, DB2)
2. **Alle 12 spell-id's uit `ns.FOREVER_QUEST_FIRST` kloppen.** Elk ras leert er één op level 10 en één op level 20, bij zijn
   eigen hogepriester. Tabel in §3. (G, Wowhead Forever "You will learn" per quest)
3. 🔑 **Elke ras-spell is één quest met meerdere id's.** De quest van de hogepriester zelf en de "ga naar de hogepriester"-quests
   van de andere trainers delen **één voltooid-bit** (`QuestV2.UniqueBitFlag`, G in DB2). Dus: **één stap, de andere id's als
   `alt`**. Dat is ook de vorm die het minst stuk kan (§4).
4. **Zygor is voor priest grotendeels Classic-data en op 11 punten fout of verouderd** (§9). Het ergste: Zygor stuurt een
   Dwarf naar Stormwind (moet Ironforge zijn) en geeft een Human "Desperate Prayer" (die krijgt in Forever Divine Grace).
5. **Spoken is hier op één punt verouderd**: `ender = 376` (Laurena) bij Desperate Prayer 5634-5640; in Forever is dat Rohan.
6. **In de schets (§10):** 5× eerste gewaad (level 5, item), 12× ras-spell (level 10 en 20), 2× Cenarion Aid (level 50, item).
   **Niet in de schets:** Benediction/Anathema (level 60), de Dungeon Set 2-keten, raid-inleverquests (§5.5).

---

## 1. Bronnen

| Code | Bron | Datum / build |
|---|---|---|
| DB2 | `C:\Users\RobHu\AppData\Local\MidnightHelper\gamedata_cache\db2\1.60.1.70938\` — `CharBaseInfo`, `ChrRaces`, `QuestV2`, `SpellName` (7 talen), `SpellLevels`, `ItemSparse` (7 talen), `UiMap` | build 70938 |
| WH-T | Wowhead Forever tooltip-JSON `https://nether.wowhead.com/forever/tooltip/{quest,npc,item,spell}/<id>` (taal: `?locale=deDE` enz.) | gelezen 17 nov 2026 |
| WH-P | Wowhead Forever questpagina `https://www.wowhead.com/forever/quest=<id>` via WebFetch. ⚠️ Een klein model vat de pagina samen; ik heb alleen overgenomen wat het letterlijk teruggaf (spell-id uit de link, serie-lijst). | gelezen 17 nov 2026 |
| IV-DB | Icy Veins database `https://db.icy-veins.com/wow-forever/quests/<id>` (Level, Requires level, Race, Start, End, kaartpunten, questtekst) | "Added in patch 1.60.1.70532" |
| IV-G | Icy Veins "World of Warcraft: Forever Priest Class Quests Guide", `https://www.icy-veins.com/wow-forever/priest-class-quests` | 4 nov 2026 |
| FORG | ForG "Priest racial spells", `https://forg.gg/en/forever/tips/priest-racial-spells` | 7 okt 2026 |
| UGT | UrGameTips "Contingency Plan Quest", `https://urgametips.com/wow-forever/quest-guides/contingency-plan-high-priestess-mims-gnome-priest/` | 21 okt 2026 |
| HB | WoW Handbook "Priest Class Quests", `https://wowhandbook.com/classes/priest/quests/` (tabel "Starts at", met "New"-labels) | ongedateerd, Forever-data |
| WCL | WCLBox `https://wowforever.wclbox.com/en/renwu/<id>` — zegt per quest zélf of het "Data from Wowhead's Forever database" is of "match Classic" | ongedateerd |
| SP-C | Spoken `Spoken_Quests\Data\Compendium.lua` (races/classes/prev/ender) | gemaakt uit Forever 70450 + Era |
| SP-G | Spoken `SpokenQuestsAudioShared\generated\questlog_npc_lookups.lua` (quest → gever) | idem |
| SP-T | Spoken `Spoken_Quests\Data\QuestText.lua` | idem |
| SP-N | Spoken `Spoken_Quests\Locale\Names\<taal>.lua` | idem |
| HN | `HandyNotes_ClassTrainers\Data.lua` (trainerplekken; kop: "WoW Forever 1.60.1.70532") | 70532 |
| Z-A | Zygor `Guides-Forever\Leveling\ZygorLevelingAllianceCLASSIC.lua` — "Priest Class Quests" r. 21815-21876 + leveling-stappen | versie van 17 nov |
| Z-H | Zygor `...\ZygorLevelingHordeCLASSIC.lua` — "Priest Class Quests" r. 23141-23268 + leveling-stappen | idem |
| Z-D | Zygor `Guides-Forever\Dungeons\ZygorDungeonAllianceCLASSIC.lua` r. 8106-8108, 8278-8303, 8870-8871 | idem |
| MH | `Modules/ForeverTrainer.lua` r. 41-42, `ForeverTrainerData.lua` r. 669-734, `ForeverSpellIds.lua` | repo |

Alleen als **tegenvoorbeeld** gebruikt (Classic-data volgens henzelf, dus géén Forever-bewijs): `foreverdb.net/quests/priest`
("Titles, objectives and givers are Classic data (CMaNGOS classic-db)"), `worstguidesever.com` (16 sep 2026, "Classic
Anniversary data is the skeleton"), `wowforever.kickegg.net` (9 nov 2026, "Chain structure ... = classic 1.12 consensus").

**Positieve controles in deze run:** druid-quest 98393 gaf via WH-T "The Great Cat Spirit" (dus nieuwe Forever-id's zijn
zo te vinden); npc 233 gaf met `?locale=deDE` "Bauer Saldean" (WH-T) en staat ook zo in SP-N `deDE.lua:14`; item 15877
"Shrine Bauble" stond in mijn ItemSparse-zoekpatroon (zelfde id als in de module).

---

## 2. Wie kan priest zijn

G, DB2 `CharBaseInfo.enUS.csv` (kolommen `ID,RaceID,ClassID`), ClassID 5 = Priest; rasnamen uit `ChrRaces.enUS.csv`
(`ClientFileString`):

| CharBaseInfo-rij | RaceID | raceFile | Factie | Opmerking |
|---|---|---|---|---|
| `4,1,5` | 1 | `Human` | Alliance | |
| `16,3,5` | 3 | `Dwarf` | Alliance | |
| `32,4,5` | 4 | `NightElf` | Alliance | |
| `919,7,5` | 7 | `Gnome` | Alliance | **nieuw in Forever** (G: FORG "Gnome Priests, newly available in Forever"; in DB2 een hoge rij-id, 919) |
| `29,5,5` | 5 | `Scourge` | Horde | |
| `55,8,5` | 8 | `Troll` | Horde | |

Geen rij met ClassID 5 voor RaceID 2 (Orc), 6 (Tauren), 95 of 96 (Skyborne). Positieve controle in hetzelfde bestand:
Skyborne heeft wél `900,95,11` en `903,96,11` (druid), zoals de module al gebruikt. (G)

Dat ClassID 5 = Priest: A (Spoken zet priest-quests op `classes = 16` = bit van class-id 5; `ChrClasses` regel 6 = PRIEST).

---

## 3. De 12 ras-spells en de quest die ze leert

Alle spell-id's: G in WH-P ("You will learn: <naam>", id uit de spell-link) op de quest van de hogepriester.
Level: G in DB2 `SpellLevels` (BaseLevel) én IV-DB ("Requires level"). Namen: G in DB2 `SpellName.enUS`.

| Ras | Lvl | Spell (id) | Quest bij de hogepriester | Hogepriester (npc) | Zelfde quest, andere gever (`alt`) | Bit |
|---|---|---|---|---|---|---|
| Human | 10 | **Divine Grace** (1277370) *nieuw* | 94773 Divine Grace | High Priestess Laurena (376), Stormwind | 94774-94779 | 68258 |
| Human | 20 | Feedback (13896) | 5676 Arcane Feedback | Laurena (376) | 5677, 5678 | 2402 |
| Dwarf | 10 | Desperate Prayer (13908) | 5639 Desperate Prayer | High Priest Rohan (11406), Ironforge | 5634-5638, 5640 | 2384 |
| Dwarf | 20 | **Chastise** (1277331) *nieuw* | 5641 Chastise (was "A Lack of Fear") | Rohan (11406) | 5645, 5647 | 2404 |
| Gnome | 10 | **Confounding Flash** (1277455) *nieuw* | 94817 Confounding Flash | High Priestess Mims (258785), Ironforge | 94821-94826 | 68287 |
| Gnome | 20 | **Contingency Plan** (1277462) *nieuw* | 94818 Contingency Plan | Mims (258785) | 94819, 94820 | 68288 |
| Night Elf | 10 | Starshards (10797) | 5627 Stars of Elune | Priestess Alathea (11401), Darnassus | 5628-5633 (Returning Home) | 2382 |
| Night Elf | 20 | Elune's Grace (2651) | 5672 Elune's Grace | Alathea (11401) | 5673-5675 | 2400 |
| Troll | 10 | Hex of Weakness (9035) | 5652 Hex of Weakness | Ur'kyo (6018), Orgrimmar | 5654-5657 | 2392 |
| Troll | 20 | Shadowguard (18137) | 5680 Shadowguard | Ur'kyo (6018) | 5642, 5643 | 2407 |
| Undead | 10 | Touch of Weakness (2652) | 5658 Touch of Weakness | Aelthalyste (4606), Undercity | 5660-5663 | 2394 |
| Undead | 20 | **Dark Sacrifice** (1277324) *nieuw* | 5679 Dark Sacrifice (was "Devouring Plague") | Aelthalyste (4606) | 5644, 5646 | 2403 |

Bewijs per regel:
- Spell-id op de quest (G, WH-P): 94773→1277370, 5676→13896, 5639→13908, 5641→1277331, 94817→1277455, 94818→1277462,
  5627→10797, 5672→2651, 5652→9035, 5680→18137, 5658→2652, 5679→1277324. Ook op de zusterquests staat dezelfde spell
  (G, WH-P: 5634 en 5640 → 13908, 5629 → 10797, 5654 → 9035, 94774 → 1277370).
- Level 10/20 (G, DB2 `SpellLevels`): 2652→10, 2651→20, 10797→10, 9035→10, 13896→20, 13908→10, 18137→20, 1277324→20,
  1277331→20, 1277370→10, 1277455→10, 1277462→20. Positieve controle zelfde patroon: spell 543 → rij `97395,…,20,20,543`.
- "Requires level 10/20" en ras per quest (G, IV-DB op elk van de 12 hoofdquests; ras ook G in SP-C `races`-masker:
  1 Human, 4 Dwarf, 8 Night Elf, 16 Undead, 64 Gnome, 128 Troll).
- Start = einde = de hogepriester (G, IV-DB "Start and End") voor 5639, 5641, 5676, 94817, 94818, 5627, 5672, 5652, 5680,
  5679; voor 94773 G in WCL ("Start/End High Priestess Laurena", Wowhead-data) en HB. **5658: zie §5.2, twijfel.**
- De hogepriester geeft de quest ook zonder dat je eerst bij een andere trainer was: G in drie gidsen (FORG: "take the quest
  from your race's high priest and turn it in right away"; IV-G: "Optionally, you can go directly to …"; UGT: "Accept
  Contingency Plan, then speak with her again to complete it"). Spoken geeft geen `prev` bij deze quests (G, SP-C).
  **Niet in het spel gemeten.**

**`ns.FOREVER_QUEST_FIRST` (ForeverTrainer.lua r. 41-42):** de twaalf id's daar zijn precies de twaalf rang-1-id's hierboven. (G)

**Wat in Forever veranderd is** (G tenzij anders):
- Gnome priest bestaat (DB2). Eigen spells Confounding Flash en Contingency Plan; eigen hogepriester Mims in Ironforge
  (HN `Data.lua:132`, WH-T npc 258785 "Priest Trainer … Gnomeregan Exiles").
- Human level 10: Divine Grace in plaats van Desperate Prayer (FORG; SP-C `races = 1` bij 94774).
- Desperate Prayer is alleen nog voor Dwarf (SP-C `races = 4` bij 5634-5640; IV-DB "Race: Dwarf") en wordt ingeleverd bij
  **Rohan in Ironforge** (WH-T doeltekst "Speak to High Priest Rohan in Ironforge" bij 5634-5638; IV-DB "End: High Priest
  Rohan"). In Classic was dat Laurena in Stormwind.
- Dwarf level 20: Chastise in plaats van Fear Ward; Undead level 20: Dark Sacrifice in plaats van Devouring Plague. Fear
  Ward (6346) en Devouring Plague (2944) zijn nu gewone trainer-spells op 20 voor elke priest (FORG; MH
  `ForeverTrainerData.lua:696,698`).
- De questnamen 5641/5645/5647 heten nu "Chastise", 5644/5646/5679 "Dark Sacrifice" (WH-T, SP-C).
- Nieuwe id's: 94773-94779, 94817-94826, 98574 (Hallowed Memorandum, Gnome, level 1). Gezocht via WH-T op 94770-94790 en
  94810-94832; gevonden wat hier staat plus vier niet-priest-quests (94782, 94789, 94829, 94832). HB noemt als nieuw
  dezelfde vier namen ("Hallowed Memorandum, Divine Grace, Confounding Flash and Contingency Plan"). Buiten die reeksen
  niet gezocht. Spoken (70450) mist 13 van deze id's: 94773, 94775-94779, 94818-94821, 94823, 94825, 94826.

---

## 4. 🔑 Hoe deze quests in elkaar zitten (bepaalt de vorm)

**G, DB2 `QuestV2.enUS.csv` (kolommen `ID,UniqueBitFlag,UiQuestDetailsThemeID`):** de id's van één ras-spell hebben
allemaal hetzelfde `UniqueBitFlag`. Voorbeelden van regels: `5627,2382,0` … `5633,2382,0`; `5634,2384,0` … `5640,2384,0`;
`94773,68258,0` … `94779,68258,0`; `94817,68287,0` en `94821,68287,0` … `94826,68287,0`; `94818/94819/94820,68288,0`.
Alle groepen staan in de tabel van §3 (kolom Bit).

Positieve controle in dezelfde zoekactie: de druid-brieven 5923/5924/5925 delen bit 2504 (die staan in de module al als
`alt`), terwijl de vervolgquest 5921 een eigen bit heeft (2501). De gewaad-quests 5621-5626, 5648-5651 en de level 50-quests
8254-8257 hebben elk een eigen bit. Bij de priest zit dus óók de quest van de hogepriester zelf in de groep — anders dan bij
de druid.

**Wat dat betekent (A, uit hoe dit veld werkt: het is de plek van de quest in de "voltooid"-bitreeks van het character):**
- Lever je één id van de groep in, dan zegt de client voor **alle** id's van die groep "voltooid".
  `C_QuestLog.IsQuestFlaggedCompleted(5627)` is dan ook waar als je 5629 inleverde.
- Het is dus één quest met meerdere gevers. De "ga naar de hogepriester"-versie leert de spell óók (G: Wowhead toont
  "You will learn" op 5634, 5640, 5629, 5654, 94774; de inlevertekst van 5637 bij Rohan is in Forever "Please, accept this
  lesson", IV-DB).
- Zygor's leveling-gids doet na Returning Home nog "accept Stars of Elune##5627 |instant" (Z-A:4151). Met een gedeeld bit
  is die tweede stap in Forever leeg. Sites die de twee als "keten van 2" tonen (wowforevercodex, WCL "Previous quest")
  zeggen iets anders; dat is niet in het spel gemeten. De vorm hieronder werkt in beide gevallen.

**Vorm die daaruit volgt — één stap:**
```lua
{ q = <quest van de hogepriester>, alt = { <de andere id's> }, from = <hogepriester>, to = <hogepriester> }
```
Wat de module (r. 938-968) daarmee doet:
- Niets in het logboek → "haal de quest bij <hogepriester>".
- Een zusterquest in het logboek (bv. 5637 van Maxan Anvol) → `LogQuest` vindt hem via `alt`, er zijn geen `objs` →
  "ga naar <hogepriester>". Klopt.
- Eén van de id's voltooid → keten klaar, ook als `Known(spell)` niets zegt.

**Waarom niet twee stappen (eerst de dorpstrainer, dan de hogepriester):** dan hangt "klaar" af van `Known(rang 1)`. De
module-code zelf zegt dat Forever lagere rangen soms uit het spellbook haalt (`ForeverTrainer.lua:164-165`). Rang 2 komt op
18 (Desperate Prayer 19236, Divine Grace 1277371, Starshards 19296), 20 (Hex of Weakness 19281, Touch of Weakness 19261),
28 (Shadowguard 19308) of 30 (Chastise 1277332, Contingency Plan 1277634, Dark Sacrifice 1277325, Feedback 19271) —
G in `ForeverTrainerData.lua:690-734`. Met één stap + `alt` maakt dat niet uit.

---

## 5. Per keten

### 5.1 Eerste gewaad (level 5) — item, `nameKey`

Twee quests per ras: de trainer in het startgebied stuurt je naar de trainer in het eerste dorp; die laat je een gewonde
wachter genezen. Beloning: een gewaad (alleen voor Priest). Geen spell (G, WH-P 5624: geen "You will learn").
"Requires level 5", questlevel 4 (G, IV-DB op alle tien; HB "4 (5)"). Volgorde: de tweede heeft de eerste als `prev` (G, SP-C
r. 2533-2563).

| Ras | Quest 1 (gever → inleveraar) | Quest 2 (gever = inleveraar) | Doel | Beloning (item) |
|---|---|---|---|---|
| Human | 5623 In Favor of the Light: Priestess Anetta (375) → Priestess Josetta (377) | 5624 Garments of the Light: Josetta | Guard Roberts (12423) | Friar's Robes of the Light (16605) |
| Dwarf, Gnome | 5626 In Favor of the Light: Branstock Khalder (837) → Maxan Anvol (1226) | 5625 Garments of the Light: Maxan Anvol | Mountaineer Dolf (12427) | Friar's Robes of the Light (16605) |
| Night Elf | 5622 In Favor of Elune: Shanda (3595) → Laurna Morninglight (3600) | 5621 Garments of the Moon: Laurna | Sentinel Shaya (12429) | Moon Robes of Elune (16604) |
| Troll | 5649 In Favor of Spirituality: Ken'jai (3707) → Tai'jin (3706) | 5648 Garments of Spirituality: Tai'jin | Grunt Kor'ja (12430) | Juju Hex Robes (16606) |
| Undead | 5651 In Favor of Darkness: Dark Cleric Duesten (2123) → Dark Cleric Beryl (2129) | 5650 Garments of Darkness: Beryl | Deathguard Kel (12428) | Acolyte's Sacrificial Robes (16607) |

- Gevers en inleveraars: G in SP-G (5623=375, 5624=377, 5626=837, 5625=1226, 5622=3595, 5621=3600, 5649=3707, 5648=3706,
  5651=2123, 5650=2129) en SP-C `ender`; ook G in IV-DB (Start/End) voor 5623, 5624, 5626, 5625, 5621, 5648, 5650 en in HB
  voor alle tien; Zygor-leveling heeft dezelfde stappen (Z-A:436-531, 3398-3596; Z-H:381-554, 3286-3451; voor Dwarf/Gnome
  alleen de tweede quest 5625, Z-A:1980-1990).
- 5625/5626 zijn voor Dwarf **en** Gnome: G (SP-C `races = 68`; IV-DB "Races: Dwarf, Gnome").
- Doel: "Heal and fortify <naam>" is het enige doel (G, WH-T op 5621, 5624, 5625, 5648, 5650). Questtekst: "heal his wounds
  using **Lesser Heal (Rank 2)**. Afterwards, grant him Power Word: Fortitude" (G, WH-T). Lesser Heal rang 2 = spell 2052,
  trainer level 4 (G, `ForeverTrainerData.lua:671`). Of een hogere rang ook telt: niet gemeten.
- Npc-id's van de wachters: G (WH-T npc 12423, 12427, 12429, 12430, 12428 geven die namen).
- Beloning: 5624 → 16605 G (WH-P). De andere drie: naam G in IV-G ("Rewards – …"), id bij die naam G in DB2 `ItemSparse`;
  de koppeling quest→id is voor die drie dus A.

De level 1-quests (Hallowed Letter 3103, Rune 3110, Sigil 3119, Tablet 3085, Scroll 3097, Memorandum 98574) leveren niets op
behalve reputatie (G, WH-P 3103 en 98574: geen Rewards-sectie, "50 reputation"). **Niet in de schets.**

### 5.2 Ras-spell level 10

Eén stap per ras (zie §4). `from` = `to` = de hogepriester. Alle id's per groep, met wie hem geeft:

**Human — Divine Grace 1277370**
| id | gever → inleveraar | bron |
|---|---|---|
| **94773** | Laurena → Laurena | G: WCL (Wowhead-data), HB |
| 94774 | Priestess Josetta (Goldshire) → Laurena | G: IV-DB, SP-G:3483, WCL |
| 94775 | Laurna Morninglight (Dolanaar) → Laurena | G: IV-DB (Start) |
| 94776 | Maxan Anvol | A: de tekst is Maxans tekst ("Time's come for you to head to Stormwind", IV-DB) |
| 94777 | Nara Meideros | A: zelfde tekst als 5638 (SP-G: Nara Meideros) |
| 94778 | een trainer in Ironforge (IV-G noemt Braenna Flintcrag) | A: tekst van de oude Ironforge-versie |
| 94779 | Priestess Alathea | A: zelfde tekst als 5640 |

**Dwarf — Desperate Prayer 13908**
| id | gever → inleveraar | bron |
|---|---|---|
| **5639** | Rohan → Rohan | G: IV-DB; WH-T toont alleen de inlevertekst (geen doelregel) |
| 5634 | Laurena → Rohan | G: IV-DB |
| 5635 | Priestess Josetta → Rohan | G gever: SP-G:145; G doel: WH-T |
| 5636 | Laurna Morninglight → Rohan | G gever: SP-G:1035; G doel: WH-T |
| 5637 | Maxan Anvol (Kharanos) → Rohan | G: IV-DB, SP-G:323 |
| 5638 | Nara Meideros → Rohan | G gever: SP-G:2179; G doel: WH-T |
| 5640 | Priestess Alathea → Rohan | G gever: SP-G:2180; WH-T zegt "Rohan in Stormwind" (tikfout van Blizzard) |

**Gnome — Confounding Flash 1277455**
| id | gever → inleveraar | bron |
|---|---|---|
| **94817** | Mims → Mims | G: IV-DB, WCL |
| 94821 | Laurena → Mims | G: IV-DB |
| 94822 | Priestess Josetta → Mims | G: IV-DB, SP-G:3659 |
| 94823 | Laurna Morninglight → Mims | G: IV-DB |
| 94824 | Maxan Anvol → Mims | G: IV-DB, SP-G:3469 |
| 94825 | Nara Meideros | A: tekst |
| 94826 | Priestess Alathea | A: tekst |

**Night Elf — Starshards 10797**
| id | gever → inleveraar | bron |
|---|---|---|
| **5627** Stars of Elune | Alathea → Alathea | G: IV-DB, WCL, Z-A:4151 |
| 5628 Returning Home | Priestess Josetta → Alathea | G: IV-DB, SP-G:144 |
| 5629 | Laurna Morninglight → Alathea | G: IV-DB, SP-G:1034, Z-A:21848 |
| 5630 | Maxan Anvol | G: SP-G:322, HB |
| 5631 | Laurena (IV-DB) of Brother Joshua (SP-G:1332) | bronnen verschillen |
| 5632 | Nara Meideros | G: SP-G:2178 |
| 5633 | Braenna Flintcrag (SP-G:1277) of Rohan (HB) | bronnen verschillen |

**Troll — Hex of Weakness 9035**
| id | gever → inleveraar | bron |
|---|---|---|
| **5652** | Ur'kyo → Ur'kyo | G: IV-DB, WCL |
| 5654 | Tai'jin (Razor Hill) → Ur'kyo | G: IV-DB, SP-G:1087, Z-H:3757 |
| 5655 | Var'jun (11407, Bloodhoof Village) → Ur'kyo | G: IV-DB, SP-G:2187 |
| 5656 | Miles Welsh (Thunder Bluff) | G: SP-G:823, HB |
| 5657 | Aelthalyste → Ur'kyo | G: IV-DB, SP-G:3050 |

**Undead — Touch of Weakness 2652**
| id | gever → inleveraar | bron |
|---|---|---|
| **5658** | **Aelthalyste → Aelthalyste (A)** | vóór: HB ("Touch of Weakness · Undead · Aelthalyste"), IV-G (Aelthalyste in de lijst met gevers), Z-H:959-963 (accept én turnin op 49.26,17.12), WH-T toont alleen de inlevertekst. Tegen: Z-H:23159 en de Classic-bronnen (WCL "match Classic", foreverdb) zeggen Father Lankester (4607). IV-DB heeft geen gever. |
| 5660 | Tai'jin → Aelthalyste | G: IV-DB, SP-G:1088 |
| 5661 | Var'jun → Aelthalyste | G: IV-DB, SP-G:2188 |
| 5662 | Ur'kyo → Aelthalyste | G: IV-DB, SP-G:1451 |
| 5663 | Miles Welsh → Aelthalyste | G: IV-DB, SP-G:824 |

Father Lankester staat in dezelfde ruimte als Aelthalyste (HN: 49.14,14.61 tegen 49.26,17.12). Voor de pijl maakt het
weinig uit; de naam in de regel kan fout zijn.

5653 en 5659 heten op Wowhead "<NYI> …" (G, WH-T) en zitten wel in het bit (G, DB2). **Niet in `alt`** (niet te krijgen, A).

### 5.3 Ras-spell level 20

| Ras | hoofdquest (gever = inleveraar) | zusterquests | bron |
|---|---|---|---|
| Human | **5676** Arcane Feedback, Laurena | 5677 Rohan → Laurena; 5678 Alathea → Laurena | G: IV-DB (alle drie), SP-G:2185, 2182 |
| Dwarf | **5641** Chastise, Rohan | 5645 Laurena → Rohan; 5647 trainer in Darnassus → Rohan | G: IV-DB (5641, 5645), SP-G:141; 5647: Alathea volgens SP-G:2181 en HB, Lariia volgens IV-G |
| Gnome | **94818** Contingency Plan, Mims | 94819 Laurena → Mims; 94820 trainer in Darnassus → Mims | G: IV-DB (94818, 94819), UGT; 94820: Alathea volgens HB, Lariia volgens IV-G |
| Night Elf | **5672** Elune's Grace, Alathea | 5673 Laurena; 5674 Nara Meideros (IV-DB) of Laurna Morninglight (SP-G:1036); 5675 Rohan | G: IV-DB, SP-G:142, 2184 |
| Troll | **5680** Shadowguard, Ur'kyo | 5642 Miles Welsh; 5643 Aelthalyste | G: IV-DB (5680), SP-G:821, 3049, HB |
| Undead | **5679** Dark Sacrifice, Aelthalyste | 5644 Miles Welsh → Aelthalyste; 5646 Ur'kyo → Aelthalyste | G: IV-DB (alle drie), SP-G:822, 1450 |

Geen `needs`: de level 20-quest hangt niet aan de level 10-quest (G: geen `prev` in SP-C; A dat de server het ook zo doet).

### 5.4 Cenarion Aid (vanaf level 50) — item, `nameKey`

Zelfde quests voor beide facties ("Faction: Both", G, IV-DB). Questlevel 52, **Requires level 50** (G, IV-DB; HB "52 (50)").
Volgorde G: Wowhead-serie op 8257 (8254 → 8255 → 8256 → 8257), SP-C `prev`, IV-DB "Quest Chain".
Beloning van 8257, één kiezen (G, WH-P): Blessed Prayer Beads 19990 (trinket, alleen Priest), Circle of Hope 20006 (ring),
Woestave 20082 (wand) — soort G in WH-T item.

| # | Quest | Gever → inleveraar | Doel (objective) | Plek van het doel |
|---|---|---|---|---|
| 1 | 8254 Cenarion Aid | priest-trainer → Ogtinc (8405), Azshara | — | — |
| 2 | 8255 Of Coursers We Know | Ogtinc → Ogtinc | 1: 4 Healthy Courser Gland (20027), van Mosshoof Courser (8761) | Azshara 49.47, 17.62 (= `H.coursers`) |
| 3 | 8256 The Ichor of Undeath | Ogtinc → Ogtinc | 1: 1 Ichor of Undeath (7972) | Winterspring 52.59, 40.68 (Zygor) |
| 4 | 8257 Blood of Morphaz | Ogtinc → Greta Mosshoof (10922), Felwood | 1: Blood of Morphaz (20025), van Morphaz (5719) in de Sunken Temple | ingang Swamp of Sorrows (= `P.sunken`) |

- Wie 8254 geeft (G, IV-DB "Start"): **Brother Joshua (5489, Stormwind), Ur'kyo (6018, Orgrimmar), Malakai Cross (3045,
  Thunder Bluff)**. Zygor: Brother Joshua (Z-D:8106-8108) en Ur'kyo (Z-H:23190-23192). Spoken noemt nog Rohan (SP-G:1333);
  HB toont alleen Malakai Cross. Of de trainers in Ironforge, Darnassus en Undercity hem in Forever ook geven: niet gemeten.
  **Keuze in de schets (A): Alliance → Brother Joshua, Horde → Ur'kyo.**
- Ogtinc geeft 8255, 8256 en 8257 (G: SP-G:3099-3101, IV-DB, Zygor). 8257 inleveren bij Greta Mosshoof (G: SP-C `ender =
  10922`, IV-DB, WH-T doeltekst, Z-H:23240-23241).
- Ichor of Undeath: Zygor laat je "Highborne enemies" doden in Winterspring (Z-H:23210-23215, "low drop rate"). Daar staan
  Suffering Highborne (7523) en Anguished Highborne (7524) op 50-57, 39-47 (G, WH-T npc). De questtekst zelf noemt de
  Ruins of Eldarath in Azshara (G, IV-DB). Dat deze mobs het item in Forever laten vallen: alleen Zygor, niet gemeten.
- Morphaz: Sunken Temple, een kerker; je hebt een groep nodig (IV-DB "Type: Dungeon").

### 5.5 Genoemd, **niet** in de schets

| Wat | Waarom niet |
|---|---|
| **Benediction / Anathema (level 60)**: 7621 "A Warning" en 7622 "The Balance of Light and Shadow", beide bij Eris Havenfire (14494, Eastern Plaguelands, WH-T 20.8, 18.4). 7622 geeft Splinter of Nordrassil (18659) (G, WH-P). Volgorde G: SP-C `prev = 7621`. | De keten begint in feite met een **item**: The Eye of Divinity (18646, G id in DB2) uit een raid; pas dan zie je Eris (Classic-kennis, **in Forever niet gemeten**; IV-DB heeft voor 7621/7622 geen gegevens, IV-G zegt "what lies beyond Level 30 is unknown"). De module kan geen item als voorwaarde zetten (`needs` is een quest-id). Daarna heb je nog The Eye of Shadow (18665) nodig. In DB2 staan ook nieuwe id's met dezelfde namen (Splinter 228749, Benediction 289296, Anathema 289297): niet uitgezocht. |
| **Dungeon Set 2** ("An Earnest Proposition" 8909 Alliance bij Deliana 16013 in Ironforge, 8916 Horde bij Mokvar 16012 in Orgrimmar, daarna Just Compensation 8934/8940, Anthion's Parting Words 8955/9019, Saving the Best for Last 9003/9009; G in SP-C r. 3926-4030, WH-T) | Elke class heeft deze keten; lang, met kerkers; hoort niet bij "priest". |
| Raid-inleverquests (Zul'Gurub 8049-8071, Ahn'Qiraj 8592-8705, Naxxramas 9111-9118, Atiesh 9257; G in SP-C) | Inleveren van raid-stukken, geen keten met een gever-route. |
| Hallowed Letter/Rune/Sigil/Tablet/Scroll/Memorandum (level 1) | Geen beloning (§5.1). |

---

## 6. Plekkentabel

UiMap-id's: G in DB2 `UiMap.enUS.csv` (Durotar 1411, Tirisfal Glades 1420, Dun Morogh 1426, Elwynn Forest 1429, Swamp of
Sorrows 1435, Teldrassil 1438, Azshara 1447, Felwood 1448, Winterspring 1452, Stormwind City 1453, Orgrimmar 1454,
Ironforge 1455, Thunder Bluff 1456, Darnassus 1457, Undercity 1458) en gelijk aan de tabellen die al in de module staan.
Regel: Rob gemeten > HandyNotes > Zygor > gids. Niets hiervan is in het spel gezien.

| Sleutel | NPC (id) | UiMap | x, y | Bron van de waarde | Andere bronnen |
|---|---|---|---|---|---|
| `laurena` | High Priestess Laurena (376) | 1453 | 49.53, 44.60 | HN `Data.lua:207` | Zygor 49.53, 44.57 (Z-A:21867); WH-T 49.4-49.6, 44.4-44.8. De WH-T-set 38.4-38.8, 26.2-26.6 is de oude kaartruimte: niet gebruiken. |
| `rohan` | High Priest Rohan (11406) | 1455 | 24.73, 8.16 | HN :131 | Zygor 24.72, 8.14; WH-T 23.4-26.8, 7.0-9.0 (hij loopt rond) |
| `mims` | High Priestess Mims (258785) | 1455 | 24.80, 9.70 | HN :132 | WH-T 24.8, 9.4 / 24.8, 10 / 25.6, 9.4 / 25.6, 10.4; IV-DB 24.8, 9.4 en 24.9, 10.0 |
| `alathea` | Priestess Alathea (11401) | 1457 | 39.52, 81.20 | HN :38 | Zygor 39.53, 81.18; WH-T 38.8-40.2, 80.4-81.6 |
| `urkyo` | Ur'kyo (6018) | 1454 | 35.56, 87.83 | HN :177 | Zygor 35.59, 87.83; WH-T 35.4-35.6, 87.4-87.6 |
| `aelthalyste` | Aelthalyste (4606) | 1458 | 49.26, 17.12 | HN :299 | Zygor 49.27, 17.11; WH-T 48.2-49.6, 17.0-19.2 |
| `anetta` | Priestess Anetta (375) | 1429 | 49.95, 39.57 | HN :99 | Zygor 49.81, 39.49; WH-T 49.8, 39.4-39.6 |
| `josetta` | Priestess Josetta (377) | 1429 | 43.28, 65.71 | HN :100 | Zygor 43.28, 65.72; WH-T 43.4, 65.6 |
| `branstock` | Branstock Khalder (837) | 1426 | 28.45, 66.68 | HN :55 | Zygor 28.60, 66.39; WH-T 28.6, 66.4-66.6 |
| `maxan` | Maxan Anvol (1226) | 1426 | 47.06, 52.32 | HN :56 | Zygor 47.34, 52.19; WH-T 47.2, 52.2; IV-DB ook 46.7, 53.8 |
| `shanda` | Shanda (3595) | 1438 | 59.17, 40.44 | HN :242 | Zygor gelijk |
| `laurna` | Laurna Morninglight (3600) | 1438 | 55.56, 56.75 | HN :241 | Zygor gelijk |
| `kenjai` | Ken'jai (3707) | 1411 | 42.33, 68.50 | HN :74 | Zygor 42.36, 68.81 en WH-T 42.4, 68.8 (0,3 verschil in y) |
| `taijin` | Tai'jin (3706) | 1411 | 54.23, 42.99 | HN :75 | Zygor 54.26, 42.93; WH-T 54.2, 42.8 |
| `duesten` | Dark Cleric Duesten (2123) | 1420 | 31.34, 65.85 | HN :283 | Zygor 31.11, 66.03; WH-T 31, 66 |
| `beryl` | Dark Cleric Beryl (2129) | 1420 | 61.31, 52.10 | HN :282 | Zygor 61.57, 52.19; WH-T 61.6, 52.2 |
| `joshua` | Brother Joshua (5489) | 1453 | 49.50, 45.21 | HN :206 | Zygor 49.70, 44.86 (Z-D:8108); IV-DB 49.6, 45.1 |
| `greta` | Greta Mosshoof (10922) | 1448 | 51.20, 82.20 | Zygor (Z-H:23241) | WH-T 51.2, 82.2 |
| (`H.ogtinc`, bestaat) | Ogtinc (8405) | 1447 | 42.40, 42.62 | staat al in `HU_P` | Zygor 42.40, 42.60; WH-T 42.4, 42.6 |
| `roberts` | — (Guard Roberts 12423) | 1429 | 48.15, 68.05 | Zygor (Z-A:524) | WH-T 48, 67.6 |
| `dolf` | — (Mountaineer Dolf 12427) | 1426 | 45.81, 54.57 | Zygor (Z-A:1983) | WH-T 45.8, 54.4-54.6 |
| `shaya` | — (Sentinel Shaya 12429) | 1438 | 57.24, 63.51 | Zygor (Z-A:3508) | WH-T 57.2, 63.2-63.6 |
| `korja` | — (Grunt Kor'ja 12430) | 1411 | 53.10, 46.46 | Zygor (Z-H:3444) | WH-T 53, 46.4-46.6 |
| `kel` | — (Deathguard Kel 12428) | 1420 | 59.18, 46.50 | Zygor (Z-H:547) | WH-T 59.2, 46.4-46.8 |
| (`H.coursers`, bestaat) | — | 1447 | 49.47, 17.62 | staat al in `HU_P` | Zygor (Z-H:23202) gelijk |
| `highborne` | — | 1452 | 52.59, 40.68 | Zygor (Z-H:23211) | WH-T npc 7523/7524: 50.2-56.8, 39.4-46.8 |
| (`P.sunken`, bestaat) | — | 1435 | 69.36, 56.89 | staat al in `P` | Zygor (Z-H:23223) gelijk |

Dat de Wowhead-zonecoördinaten dezelfde ruimte zijn als de UiMap: A (voor steden behalve Stormwind en voor zones kwam het in
deze tabel steeds binnen 0,5 uit; voor Stormwind zijn er twee sets).

---

## 7. Objective-index

G = volgorde in de Wowhead-tooltip ("Requirements") + Zygor `|q <id>/<n>`. Dat die gelijk is aan de index van
`C_QuestLog.GetQuestObjectives`: A (zelfde aanname als bij de andere classes).

| Quest | idx | Doel | Bron |
|---|---|---|---|
| 5624 | 1 | Heal and fortify Guard Roberts | WH-T; Z-A:524 `|q 5624/1` |
| 5625 | 1 | Heal and fortify Mountaineer Dolf | WH-T; Z-A:1983 `|q 5625/1` |
| 5621 | 1 | Heal and fortify Sentinel Shaya | WH-T; Z-A:3508 `|q 5621/1` |
| 5648 | 1 | Heal and fortify Grunt Kor'ja | WH-T; Z-H:3444 `|q 5648/1` |
| 5650 | 1 | Heal and fortify Deathguard Kel | WH-T; Z-H:547 `|q 5650/1` |
| 8255 | 1 | Healthy Courser Gland ×4 (item 20027) | WH-T; Z-H:23202 `|q 8255/1` |
| 8256 | 1 | Ichor of Undeath ×1 (item 7972) | WH-T; Z-H:23211 `|q 8256/1` |
| 8257 | 1 | Blood of Morphaz ×1 (item 20025) | WH-T; Z-H:23237 `|q 8257/1` |

De ras-spell-quests en 5623/5626/5622/5649/5651/8254 hebben geen doel (alleen "Speak to …").

---

## 8. NPC-namen per taal

G: WH-T met `?locale=deDE|frFR|esES|esMX|ptBR|ruRU` (17 nov 2026). Tweede bron SP-N waar die de naam heeft; die was op één na
gelijk. Controle npc 233: deDE "Bauer Saldean" (WH-T en SP-N). Engels uitziende de/fr-namen kwamen zonder [haken] terug =
de naam van die client. De ruRU-namen kwamen als `\u….`-codes; 16 ervan zijn letter voor letter gelijk aan SP-N `ruRU.lua`,
de rest (258785, 4606, 8405 en de vijf wachters) heb ik met de hand omgezet.

**NPC's met een naam in de regels (gevers en inleveraars)**

| id | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 376 | High Priestess Laurena | Hohepriesterin Laurena | Grande prêtresse Laurena | Suma Sacerdotisa Laurena | Suma sacerdotisa Laurena | Alta-sacerdotisa Laurena | Верховная жрица Лорена |
| 11406 | High Priest Rohan | Hohepriester Rohan | Grandprêtre Rohan | Sumo Sacerdote Rohan | Sumo sacerdote Rohan | Sumo Sacerdote Rohan | Верховный жрец Рохан |
| 258785 | High Priestess Mims | Hohepriesterin Mims | Grande prêtresse Mims | Suma sacerdotisa Mims | Suma sacerdotisa Mims | Alta-sacerdotisa Mims | Верховная жрица Мимс |
| 11401 | Priestess Alathea | Priesterin Alathea | Prêtresse Alathea | Sacerdotisa Alathea | Sacerdotisa Alathea | Sacerdotisa Alathea | Жрица Алатея |
| 6018 | Ur'kyo | Ur'kyo | Ur'kyo | Ur'kyo | Ur'kyo | Ur'kyo | Ур'кьо |
| 4606 | Aelthalyste | Aelthalyste | Aelthalyste | Aelthalyste | Aelthalyste | Aelthalyste | Эльталисте |
| 375 | Priestess Anetta | Priesterin Anetta | Prêtresse Anetta | Sacerdotisa Anetta | Sacerdotisa Anetta | Sacerdotisa Anita | Жрица Анетта |
| 377 | Priestess Josetta | Priesterin Josetta | Prêtresse Josetta | Sacerdotisa Josetta | Sacerdotisa Josetta | Sacerdotisa Joselita | Жрица Жозетта |
| 837 | Branstock Khalder | Branstock Khalder | Branstock Khalder | Silo Khalder | Silo Khalder | Branstock Khalder | Брансток Халдер |
| 1226 | Maxan Anvol | Maxan Anvol | Maxan Anvol | Maxan Anvol | Maxan Anvol | Maxan Begurno | Максан Анвол |
| 3595 | Shanda | Shanda | Shanda | Shanda | Shanda | Shanda | Шанда |
| 3600 | Laurna Morninglight | Laurna Morninglight | Laurna Morninglight | Laurna Luzdelalba | Laurna Luzdelalba | Laurna Luzalbor | Лорна Утренний Свет |
| 3707 | Ken'jai | Ken'jai | Ken'jai | Ken'jai | Ken'jai | Ken'jai | Кен'джай |
| 3706 | Tai'jin | Tai'jin | Tai'jin | Tai'jin | Tai'jin | Tai'jin | Тай'джин |
| 2123 | Dark Cleric Duesten | Dunkler Kleriker Duesten | Sombre clerc Duesten | Clérico oscuro Duesten | Clérigo oscuro Duesten | Clérigo das Trevas Duesten | Темный священник Дьюстен |
| 2129 | Dark Cleric Beryl | Dunkler Kleriker Beryl | Sombre clerc Beryl | Clérigo oscuro Beryl ⚠️ | Clérigo oscuro Beryl | Clérigo das Trevas Beryl | Темный священник Берил |
| 5489 | Brother Joshua | Bruder Joshua | Frère Joshua | Hermano Joshua | Hermano Joshua | Irmão Josué | Брат Джошуа |
| 10922 | Greta Mosshoof | Greta Mosshoof | Greta Mosshoof | Greta Pezuñamusgo | Greta Pezuñamusgo (alleen SP-N) | Greta Musgo no Casco | Грета Замшелое Копыто |
| 8405 | Ogtinc | Ogtinc | Ogtinc | Ogtinc | — (Wowhead: "[Ogtinc]" = niet vertaald; weglaten) | Ogtinc | Огтинк |

⚠️ 2129 esES: Wowhead zegt "Clérigo oscuro Beryl", Spoken `esES.lua:181` zegt "Clérico oscuro Beryl". Bij 2123 zeggen beide
"Clérico" (met c). Ik heb per id de Wowhead-waarde genomen.
10922 esMX: Wowhead geeft "[Greta Mosshoof]" (haken = geen eigen naam); Spoken `esMX.lua:629` heeft "Greta Pezuñamusgo".

**Namen die in de doel-teksten staan (voor de vertaler; niet in `NPC_NAMES`)**

| id | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| npc 12423 | Guard Roberts | Wache Roberts | Garde Roberts | Guardia Roberts | Guardia Roberts | Guarda Roberts | Стражник Робертс |
| npc 12427 | Mountaineer Dolf | Gebirgsjäger Dolf | Montagnard Dolf | Montaraz Dolf | Montaraz Dolf | Montanhista Dolf | Горный пехотинец Дольф |
| npc 12429 | Sentinel Shaya | Schildwache Shaya | Sentinelle Shaya | Centinela Shaya | Centinela Shaya | Sentinela Shaya | Часовой Шайя |
| npc 12430 | Grunt Kor'ja | Grunzer Kor'ja | Grunt Kor'ja | Bruto Kor'ja | Bruta Kor'ja | Bruta Kor'ja | Рубака Кор'жа |
| npc 12428 | Deathguard Kel | Todeswache Kel | Garde noir Kel | Guardia de la Muerte Kel | Guardia de la Muerte Kel | Necroguarda Querêncio | Страж смерти Кел |
| spell 2052 | Lesser Heal | Geringes Heilen | Soins inférieurs | Curación inferior | Sanación inferior | Cura Inferior | Малое исцеление |
| spell 1243 | Power Word: Fortitude | Machtwort: Seelenstärke | Mot de pouvoir : Robustesse | Palabra de poder: entereza | Palabra de poder: entereza | Palavra de Poder: Fortitude | Слово силы: Стойкость |
| item 20027 | Healthy Courser Gland | Gesunde Rennerdrüse | Glande de coursier en bonne santé | Glándula de corcel sano | Glándula de trotador sano | Glândula de Ginete Saudável | Железа здорового бегового оленя |
| item 7972 | Ichor of Undeath | Sekret des Untodes | Ichor de non-mort | Icor de no-muerto | Icor de no-muerto | Linfa de Morte-viva | Лимфа нежити |
| item 20025 | Blood of Morphaz | Morphaz' Blut | Sang de Morphaz | Sangre de Morphaz | Sangre de Morphaz | Sangue de Morphaz | Кровь Морфаза |

Npc-namen: G, WH-T per taal. Spell- en itemnamen: G, DB2 `SpellName.<taal>.csv` en `ItemSparse.<taal>.csv`.
**Niet gemeten per taal:** Mosshoof Courser (8761), Suffering/Anguished Highborne (7523/7524), Morphaz (5719), "Sunken Temple".
De spellnamen van de ketens zelf komen uit de client (`C_Spell.GetSpellName`), die hoeven niet in een pack.

---

## 9. Fouten in Zygor (en één in Spoken)

Zygor "Leveling Guides\Priest Class Quests". Alle regels G gelezen op 17 nov 2026.

| # | Zygor (regel) | Wat er staat | Wat het in Forever is | Bewijs |
|---|---|---|---|---|
| 1 | Z-A:21827-21830 (ook leveling Z-A:2911) | Dwarf levert Desperate Prayer 5637 in bij **Laurena in Stormwind** | bij **Rohan in Ironforge** | WH-T 5637 "Speak to High Priest Rohan in Ironforge"; IV-DB "End: High Priest Rohan" |
| 2 | Z-A:21833-21842 (ook leveling Z-A:965, 1208 met 5635) | Human neemt bij Josetta "Desperate Prayer##5637" | Human krijgt **Divine Grace**: 94774 bij Josetta, 94773 bij Laurena. 5637 is bovendien de quest van Maxan Anvol, en alleen voor Dwarf | IV-DB 94774 (Start Josetta, Race Human); SP-C `races = 4` bij 5637; SP-G:323 |
| 3 | Z-A:21858-21861 | "A Lack of Fear##5641" | heet **Chastise** en leert Chastise 1277331 (niet Fear Ward) | WH-T/WH-P 5641 |
| 4 | Z-A:21815-21876 | geen enkele Gnome-stap | Confounding Flash 94817 (10), Contingency Plan 94818 (20) bij Mims | §3. Positieve controle: Zygor kent Gnome-priests wél elders ("Hallowed Memorandum##98574 … only Gnome Priest", Z-A:1614) |
| 5 | Z-A:21815-21876 | geen level 50-keten | Cenarion Aid 8254 → 8257 bestaat ook voor Alliance | staat wel in Z-D:8106-8303, 8870 |
| 6 | Z-H:23148-23150 | Tai'jin geeft "Hex of Weakness##**5652**" | Tai'jin geeft **5654**; 5652 is die van Ur'kyo zelf | IV-DB 5654 "Start: Tai'jin"; SP-G:1087; Zygor's eigen leveling-gids Z-H:3757 gebruikt 5654 |
| 7 | Z-H:23169-23171 | Miles Welsh geeft "Shadowguard##**5643**" | Miles Welsh geeft **5642**; 5643 is van Aelthalyste | SP-G:821 en 3049; Zygor-leveling Z-H:5879 gebruikt 5642 |
| 8 | Z-H:23179-23185 | Ur'kyo geeft "**Devouring Plague**##**5644**" | de quest heet **Dark Sacrifice** en leert 1277324; Ur'kyo geeft **5646**, 5644 is van Miles Welsh | IV-DB 5644 "Start: Miles Welsh", 5646 "Start: Ur'kyo"; WH-P 5679 |
| 9 | Z-H:23232 | priest-stap Sunken Temple met `|q 9053 |future` | 9053 is de druid-quest (staat zo in de module); priest = 8257 | module r. 173-183; SP-C 8257 |
| 10 | Z-H:23246, 23264 | "talk **Movkar**##16012" | de NPC heet **Mokvar** | WH-T npc 16012 |
| 11 | Z-H:23252 en 23261 | 8916 vraagt "15 Winterspring Blood Sample"; "Collect 20 Gold |complete _G.GetMoney() >= 2000" | Horde-8916 vraagt **15 Silithus Venom Samples** (Winterspring Blood is de Alliance-versie 8909); 2000 koper is 20 zilver, 20 goud = 200000 | WH-T 8916 en 8909 |

Twijfel, geen bewezen fout: Z-H:23158-23159 laat Touch of Weakness 5658 beginnen bij **Father Lankester**; Zygor's eigen
leveling-gids (Z-H:959-963) en de Forever-bronnen zeggen Aelthalyste (§5.2).
Klein: Z-H:23188 "ding 52" voor Cenarion Aid (vereist level 50); Z-A:21848-21853 slaat Stars of Elune over (maakt niet uit, §4).

**Spoken:** `Compendium.lua:2546-2552` geeft Desperate Prayer 5634-5640 `ender = 376` (Laurena). In Forever is het Rohan
(11406): G in WH-T en IV-DB. Ook `QuestText.lua` heeft voor 5635-5639 nog de oude tekst ("find High Priestess Laurena").
De `races`-maskers in Spoken klopten wél met IV-DB. Twee gevers in SP-G wijken af van IV-DB (5631, 5674); voor de module
maakt dat niet uit (alleen `alt`-id's).

---

## 10. Lua-schets

Plaats ná het laatste class-blok (na de hunter-`for`-lus die `HuCharm` invoegt, of na rogue/shaman als die er al staan) en
vóór `local MOONGLADE, TELEPORT_MOONGLADE`. Hergebruikt: `O`, `P.sunken`, `H.ogtinc`, `H.coursers`, `HUM`, `GNO`,
`ORCTROLL`, `UD`, `DWGN`, `NELF`. Nieuw: één local `DWARF` (Desperate Prayer en Chastise zijn níét voor Gnome, dus `DWGN`
kan daar niet). Inspringen met tabs, zoals de rest van het bestand.

```lua
--[[ Priest (17 Nov 2026). All facts: docs/forever/PRIEST_CLASSQUESTS_2026-11-17.md (mh-research): wago DB2 1.60.1.70938,
	Wowhead Forever, Icy Veins (guide of 4 Nov + database), Spoken, HandyNotes, Zygor Forever.
	Six priest races (CharBaseInfo): Human, Dwarf, Night Elf, Gnome (new), Undead, Troll. No Skyborne, Orc or Tauren.
	Each race learns one spell at 10 and one at 20 from its own high priest. GEMETEN (QuestV2.UniqueBitFlag): the high
	priest's quest and the "go and see your high priest" quests of the other trainers share one completion bit, so they
	are one quest with several ids: one step, the other ids as alt. Handing in any of them ends the chain, also when a
	later rank has pushed rank 1 out of the spellbook.
	NOT copied from Zygor (GEMETEN): Dwarf Desperate Prayer is handed in to Rohan in Ironforge (Zygor: Laurena); Humans
	learn Divine Grace 94773 (Zygor: Desperate Prayer 5637); Tai'jin gives 5654, Miles Welsh 5642, Ur'kyo 5646 (Zygor:
	5652, 5643, 5644); Zygor has no Gnome steps. Spoken's ender 376 for 5634-5640 is the Classic value.
	AFGELEID: Touch of Weakness 5658 starts at Aelthalyste (Classic sources: Father Lankester, who stands next to her);
	which trainer gives Cenarion Aid per faction (three are known); the objective index.
	Not built: Benediction/Anathema (7621-7622: Eris Havenfire only shows with The Eye of Divinity, a raid item).
	Trainers: HandyNotes; the guards and the level 50 places: Zygor. ]]
local PR_P = {
	-- The race's high priest: gives and takes the spell quest at 10 and at 20.
	laurena = { npc = "High Priestess Laurena", id = 376, m = 1453, x = 49.53, y = 44.60 },
	rohan = { npc = "High Priest Rohan", id = 11406, m = 1455, x = 24.73, y = 8.16 },
	mims = { npc = "High Priestess Mims", id = 258785, m = 1455, x = 24.80, y = 9.70 },
	alathea = { npc = "Priestess Alathea", id = 11401, m = 1457, x = 39.52, y = 81.20 },
	urkyo = { npc = "Ur'kyo", id = 6018, m = 1454, x = 35.56, y = 87.83 },
	aelthalyste = { npc = "Aelthalyste", id = 4606, m = 1458, x = 49.26, y = 17.12 },
	-- First robe (level 5): the trainer of the starting area, then the trainer of the first village.
	anetta = { npc = "Priestess Anetta", id = 375, m = 1429, x = 49.95, y = 39.57 },
	josetta = { npc = "Priestess Josetta", id = 377, m = 1429, x = 43.28, y = 65.71 },
	branstock = { npc = "Branstock Khalder", id = 837, m = 1426, x = 28.45, y = 66.68 },
	maxan = { npc = "Maxan Anvol", id = 1226, m = 1426, x = 47.06, y = 52.32 },
	shanda = { npc = "Shanda", id = 3595, m = 1438, x = 59.17, y = 40.44 },
	laurna = { npc = "Laurna Morninglight", id = 3600, m = 1438, x = 55.56, y = 56.75 },
	kenjai = { npc = "Ken'jai", id = 3707, m = 1411, x = 42.33, y = 68.50 },
	taijin = { npc = "Tai'jin", id = 3706, m = 1411, x = 54.23, y = 42.99 },
	duesten = { npc = "Dark Cleric Duesten", id = 2123, m = 1420, x = 31.34, y = 65.85 },
	beryl = { npc = "Dark Cleric Beryl", id = 2129, m = 1420, x = 61.31, y = 52.10 },
	-- Whom to heal (no NPC name here: the text names them), Zygor.
	roberts = { m = 1429, x = 48.15, y = 68.05 },
	dolf = { m = 1426, x = 45.81, y = 54.57 },
	shaya = { m = 1438, x = 57.24, y = 63.51 },
	korja = { m = 1411, x = 53.10, y = 46.46 },
	kel = { m = 1420, x = 59.18, y = 46.50 },
	-- Cenarion Aid (level 50). Ogtinc and the coursers are the hunter's places (H); Winterspring = UiMap 1452 (DB2).
	joshua = { npc = "Brother Joshua", id = 5489, m = 1453, x = 49.50, y = 45.21 },
	greta = { npc = "Greta Mosshoof", id = 10922, m = 1448, x = 51.20, y = 82.20 },
	highborne = { m = 1452, x = 52.59, y = 40.68 },
}
local PR = PR_P
local DWARF = { Dwarf = true }

-- One quest, several ids: q = the high priest's own, alt = the same quest from another trainer.
local function PrSpell(key, spell, level, faction, races, priest, q, alt)
	return { key = key, spell = spell, level = level, faction = faction, races = races,
		quests = { { q = q, alt = alt, from = priest, to = priest } } }
end
-- t = { first quest, its giver, second quest, the village trainer, where the guard stands, textKey }
local function PrRobe(faction, races, t)
	return { key = "robe", nameKey = "FCQ_CHAIN_PR_ROBE", level = 5, faction = faction, races = races, quests = {
		{ q = t[1], from = t[2], to = t[4] },
		{ q = t[3], from = t[4], objs = { O(t[5], t[6], 1) }, to = t[4] },
	} }
end
-- Cenarion Aid (level 50): an item chain; the last quest is handed in to Greta Mosshoof in Felwood.
local function PrCenarion(faction, trainer)
	return { key = "cenarion", nameKey = "FCQ_CHAIN_PR_CENARION", level = 50, faction = faction, quests = {
		{ q = 8254, from = trainer, to = H.ogtinc },
		{ q = 8255, from = H.ogtinc, objs = { O(H.coursers, "FCQ_OBJ_PR_GLANDS", 1) }, to = H.ogtinc },
		{ q = 8256, from = H.ogtinc, objs = { O(PR.highborne, "FCQ_OBJ_PR_ICHOR", 1) }, to = H.ogtinc },
		{ q = 8257, from = H.ogtinc, objs = { O(P.sunken, "FCQ_OBJ_PR_MORPHAZ", 1) }, to = PR.greta },
	} }
end

CHAINS.PRIEST = {
	-- First robe (level 5). DWGN: Dwarf and Gnome share these two quests (Spoken races 68).
	PrRobe("Alliance", HUM, { 5623, PR.anetta, 5624, PR.josetta, PR.roberts, "FCQ_OBJ_PR_ROBERTS" }),
	PrRobe("Alliance", DWGN, { 5626, PR.branstock, 5625, PR.maxan, PR.dolf, "FCQ_OBJ_PR_DOLF" }),
	PrRobe("Alliance", NELF, { 5622, PR.shanda, 5621, PR.laurna, PR.shaya, "FCQ_OBJ_PR_SHAYA" }),
	-- ORCTROLL: there is no Orc priest (CharBaseInfo), so the extra race does nothing.
	PrRobe("Horde", ORCTROLL, { 5649, PR.kenjai, 5648, PR.taijin, PR.korja, "FCQ_OBJ_PR_KORJA" }),
	PrRobe("Horde", UD, { 5651, PR.duesten, 5650, PR.beryl, PR.kel, "FCQ_OBJ_PR_KEL" }),
	-- Race spell, level 10
	PrSpell("divinegrace", 1277370, 10, "Alliance", HUM, PR.laurena, 94773, { 94774, 94775, 94776, 94777, 94778, 94779 }),
	PrSpell("desperateprayer", 13908, 10, "Alliance", DWARF, PR.rohan, 5639, { 5634, 5635, 5636, 5637, 5638, 5640 }),
	PrSpell("confoundingflash", 1277455, 10, "Alliance", GNO, PR.mims, 94817, { 94821, 94822, 94823, 94824, 94825, 94826 }),
	PrSpell("starshards", 10797, 10, "Alliance", NELF, PR.alathea, 5627, { 5628, 5629, 5630, 5631, 5632, 5633 }),
	PrSpell("hexofweakness", 9035, 10, "Horde", ORCTROLL, PR.urkyo, 5652, { 5654, 5655, 5656, 5657 }),
	PrSpell("touchofweakness", 2652, 10, "Horde", UD, PR.aelthalyste, 5658, { 5660, 5661, 5662, 5663 }),
	-- Race spell, level 20
	PrSpell("feedback", 13896, 20, "Alliance", HUM, PR.laurena, 5676, { 5677, 5678 }),
	PrSpell("chastise", 1277331, 20, "Alliance", DWARF, PR.rohan, 5641, { 5645, 5647 }),
	PrSpell("contingencyplan", 1277462, 20, "Alliance", GNO, PR.mims, 94818, { 94819, 94820 }),
	PrSpell("elunesgrace", 2651, 20, "Alliance", NELF, PR.alathea, 5672, { 5673, 5674, 5675 }),
	PrSpell("shadowguard", 18137, 20, "Horde", ORCTROLL, PR.urkyo, 5680, { 5642, 5643 }),
	PrSpell("darksacrifice", 1277324, 20, "Horde", UD, PR.aelthalyste, 5679, { 5644, 5646 }),
	-- Level 50: the trainer per faction is a choice (AFGELEID); Malakai Cross in Thunder Bluff gives 8254 too.
	PrCenarion("Alliance", PR.joshua),
	PrCenarion("Horde", PR.urkyo),
}
```

**Twee dingen om te kiezen in de bouwchat (niet door mij beslist):**
1. **Het gewaad (level 5).** `MyChains()` sorteert op level, en "Do this now" noemt de oudste open keten. Een priest van
   level 20 die het gewaad nooit haalde, krijgt dan eerst het gewaad te zien in plaats van zijn level 20-spell. De beloning
   is een level 5-gewaad. Opties: (a) zo laten, (b) de vijf `PrRobe`-regels weglaten, (c) het gewaad alleen tonen onder
   level 10. Voor (c) is een klein stukje nieuwe code nodig.
2. **`spell = <rang 1>`** dient hier alleen voor de naam en als snelle "klaar"-check. De keten eindigt ook zonder die check
   (§4). Wil je de check toch rang-vast maken: `ns.FOREVER_SPELL_IDS[<Engelse naam>]` heeft alle rangen
   (`ForeverSpellIds.lua` r. 77, 91, 99, 117, 128, 143, 154, 175, 231, 395, 424, 461).

---

## 11. enUS-teksten (voorstel)

Zelfde stijl als de bestaande `FCQ_`-regels (kleine letter, gebiedende wijs). `nlNL` krijgt dezelfde Engelse spelnamen.

```lua
	FCQ_CHAIN_PR_ROBE = "Your first priest robe",
	FCQ_CHAIN_PR_CENARION = "Ogtinc's quests (a trinket, ring or wand)",
	FCQ_OBJ_PR_ROBERTS = "heal Guard Roberts with Lesser Heal (Rank 2), then cast Power Word: Fortitude on him",
	FCQ_OBJ_PR_DOLF = "heal Mountaineer Dolf with Lesser Heal (Rank 2), then cast Power Word: Fortitude on him",
	FCQ_OBJ_PR_SHAYA = "heal Sentinel Shaya with Lesser Heal (Rank 2), then cast Power Word: Fortitude on her",
	FCQ_OBJ_PR_KORJA = "heal Grunt Kor'ja with Lesser Heal (Rank 2), then cast Power Word: Fortitude on her",
	FCQ_OBJ_PR_KEL = "heal Deathguard Kel with Lesser Heal (Rank 2), then cast Power Word: Fortitude on him",
	FCQ_OBJ_PR_GLANDS = "defeat Mosshoof Coursers for 4 Healthy Courser Glands",
	FCQ_OBJ_PR_ICHOR = "defeat Suffering or Anguished Highborne for 1 Ichor of Undeath (it drops rarely)",
	FCQ_OBJ_PR_MORPHAZ = "in the dungeon Sunken Temple (you need a group), defeat Morphaz for the Blood of Morphaz",
```

- "on him / on her": G uit de questtekst (WH-T: Roberts "his wounds", Dolf "his", Shaya "her", Kor'ja "her", Kel "his").
- "(Rank 2)": letterlijk uit de questtekst (G, WH-T). Train je op level 4 (G, `ForeverTrainerData.lua:671`).
- "a trinket, ring or wand": G (WH-T items 19990, 20006, 20082).
- "it drops rarely": Zygor ("These have a low drop rate", Z-H:23212). Niet gemeten.
- De ras-spell-ketens hebben geen eigen tekst nodig: de naam is de spellnaam van de client, de regel is `FCQ_GET_FMT` /
  `FCQ_TURN_FMT`.

---

## 12. `NPC_NAMES`-regels

```lua
	-- Priest (17 Nov 2026, mh-research: Wowhead Forever tooltips per locale; Spoken agreed where it has the name; control
	-- npc 233 again). 2129 esES: Wowhead "Clérigo", Spoken "Clérico" (Wowhead kept). 10922 esMX: Spoken only.
	[376] = { deDE = "Hohepriesterin Laurena", frFR = "Grande prêtresse Laurena", esES = "Suma Sacerdotisa Laurena", esMX = "Suma sacerdotisa Laurena", ptBR = "Alta-sacerdotisa Laurena", ruRU = "Верховная жрица Лорена" },
	[11406] = { deDE = "Hohepriester Rohan", frFR = "Grandprêtre Rohan", esES = "Sumo Sacerdote Rohan", esMX = "Sumo sacerdote Rohan", ptBR = "Sumo Sacerdote Rohan", ruRU = "Верховный жрец Рохан" },
	[258785] = { deDE = "Hohepriesterin Mims", frFR = "Grande prêtresse Mims", esES = "Suma sacerdotisa Mims", esMX = "Suma sacerdotisa Mims", ptBR = "Alta-sacerdotisa Mims", ruRU = "Верховная жрица Мимс" },
	[11401] = { deDE = "Priesterin Alathea", frFR = "Prêtresse Alathea", esES = "Sacerdotisa Alathea", esMX = "Sacerdotisa Alathea", ptBR = "Sacerdotisa Alathea", ruRU = "Жрица Алатея" },
	[6018] = { deDE = "Ur'kyo", frFR = "Ur'kyo", esES = "Ur'kyo", esMX = "Ur'kyo", ptBR = "Ur'kyo", ruRU = "Ур'кьо" },
	[4606] = { deDE = "Aelthalyste", frFR = "Aelthalyste", esES = "Aelthalyste", esMX = "Aelthalyste", ptBR = "Aelthalyste", ruRU = "Эльталисте" },
	[375] = { deDE = "Priesterin Anetta", frFR = "Prêtresse Anetta", esES = "Sacerdotisa Anetta", esMX = "Sacerdotisa Anetta", ptBR = "Sacerdotisa Anita", ruRU = "Жрица Анетта" },
	[377] = { deDE = "Priesterin Josetta", frFR = "Prêtresse Josetta", esES = "Sacerdotisa Josetta", esMX = "Sacerdotisa Josetta", ptBR = "Sacerdotisa Joselita", ruRU = "Жрица Жозетта" },
	[837] = { deDE = "Branstock Khalder", frFR = "Branstock Khalder", esES = "Silo Khalder", esMX = "Silo Khalder", ptBR = "Branstock Khalder", ruRU = "Брансток Халдер" },
	[1226] = { deDE = "Maxan Anvol", frFR = "Maxan Anvol", esES = "Maxan Anvol", esMX = "Maxan Anvol", ptBR = "Maxan Begurno", ruRU = "Максан Анвол" },
	[3595] = { deDE = "Shanda", frFR = "Shanda", esES = "Shanda", esMX = "Shanda", ptBR = "Shanda", ruRU = "Шанда" },
	[3600] = { deDE = "Laurna Morninglight", frFR = "Laurna Morninglight", esES = "Laurna Luzdelalba", esMX = "Laurna Luzdelalba", ptBR = "Laurna Luzalbor", ruRU = "Лорна Утренний Свет" },
	[3707] = { deDE = "Ken'jai", frFR = "Ken'jai", esES = "Ken'jai", esMX = "Ken'jai", ptBR = "Ken'jai", ruRU = "Кен'джай" },
	[3706] = { deDE = "Tai'jin", frFR = "Tai'jin", esES = "Tai'jin", esMX = "Tai'jin", ptBR = "Tai'jin", ruRU = "Тай'джин" },
	[2123] = { deDE = "Dunkler Kleriker Duesten", frFR = "Sombre clerc Duesten", esES = "Clérico oscuro Duesten", esMX = "Clérigo oscuro Duesten", ptBR = "Clérigo das Trevas Duesten", ruRU = "Темный священник Дьюстен" },
	[2129] = { deDE = "Dunkler Kleriker Beryl", frFR = "Sombre clerc Beryl", esES = "Clérigo oscuro Beryl", esMX = "Clérigo oscuro Beryl", ptBR = "Clérigo das Trevas Beryl", ruRU = "Темный священник Берил" },
	[5489] = { deDE = "Bruder Joshua", frFR = "Frère Joshua", esES = "Hermano Joshua", esMX = "Hermano Joshua", ptBR = "Irmão Josué", ruRU = "Брат Джошуа" },
	[10922] = { deDE = "Greta Mosshoof", frFR = "Greta Mosshoof", esES = "Greta Pezuñamusgo", esMX = "Greta Pezuñamusgo", ptBR = "Greta Musgo no Casco", ruRU = "Грета Замшелое Копыто" },
	-- Ogtinc is also the hunter's (H.ogtinc): add this line only when 8405 is not in the table yet. esMX: not measured.
	[8405] = { deDE = "Ogtinc", frFR = "Ogtinc", esES = "Ogtinc", ptBR = "Ogtinc", ruRU = "Огтинк" },
```

Toen ik het bestand las (17 nov) stond geen van deze id's in `NPC_NAMES` (de tabel eindigde bij 7572). Het bestand wordt
vandaag door meer helpers aangevuld: kijk bij het plakken of 8405 er intussen bij staat.

---

## 13. Open / niet gemeten

1. **Gedeeld bit = samen voltooid** (§4) is A. Test op een priest die zijn level 10-spell al heeft, bv. Night Elf:
   `/run print(C_QuestLog.IsQuestFlaggedCompleted(5627), C_QuestLog.IsQuestFlaggedCompleted(5629))` — verwacht: twee keer
   `true`. `/mh classquest` toont het per keten.
2. **De hogepriester geeft de quest direct** (zonder eerst een andere trainer): G in drie gidsen, niet in het spel.
3. **Leert ook de "ga naar"-versie de spell meteen bij inleveren?** Wowhead toont de spell op die versies (G); of het spel
   dat doet is niet gezien. De schets werkt in beide gevallen.
4. **Gever van 5658** (Undead, level 10): Aelthalyste (A) of Father Lankester (Classic). Ze staan naast elkaar.
5. **Geen enkele coördinaat is in het spel gezien.** HandyNotes en Zygor verschillen het meest bij Ken'jai (y 68.50 / 68.81),
   Maxan Anvol (x 47.06 / 47.34), Branstock Khalder (y 66.68 / 66.39), Dark Cleric Beryl (x 61.31 / 61.57).
6. **Objective-index = client-index**: A (alle acht zijn index 1, één doel per quest).
7. **Garments:** telt alleen Lesser Heal rang 2, of ook een hogere rang? Niet gemeten. Volgorde heal → Fortitude: uit de
   questtekst.
8. **Cenarion Aid:** welke trainers 8254 in Forever geven buiten Stormwind, Orgrimmar en Thunder Bluff: niet gemeten. Een
   Dwarf, Gnome of Night Elf wordt nu naar Stormwind gestuurd, een Undead naar Orgrimmar.
9. **Ichor of Undeath:** de plek en "valt zelden" komen alleen uit Zygor; de questtekst noemt Azshara. Of het item te koop
   is op het Auction House: niet gemeten (de tooltip toont geen "Binds when picked up").
10. **Benediction/Anathema in Forever:** bestaan de quests (G: id's in DB2 `QuestV2` en WH-T), maar hoe je begint is niet
    in een Forever-bron gemeten. Ook niet of level 60 in Forever nu al bereikbaar is.
11. **Namen:** 8405 esMX ontbreekt; 2129 esES heeft twee spellingen; de mobs van level 50 zijn per taal niet gemeten.
12. **Gevers van losse zusterquests** (94776-94779, 94825, 94826, 94820, 5647, 5631, 5633, 5674): alleen uit tekst of één
    bron. Voor de module niet van belang (alleen `alt`-id's); wel als de bouwchat ooit "je kunt hem ook hier halen" wil tonen.
13. **Nieuwe priest-quests buiten de gezochte reeksen** (94770-94790, 94810-94832): niet uitgesloten. HB noemt geen andere.
14. **WH-P** is gelezen via een samenvattend model. De spell-id's zijn daarna bevestigd in DB2 `SpellName` (naam bij id) en
    `SpellLevels` (level), maar de zin "You will learn" zelf heb ik niet met eigen ogen op de pagina gezien.
