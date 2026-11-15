# 12.1.7 speldata: live tegen PTR (speur-opdracht 2)

Gemaakt op 15 nov 2026. Alleen gelezen, niets in de code veranderd.

## Bron en meetwijze

- **Live** = wago.tools build **12.1.5.70783** (gemaakt 2026-11-04). **PTR** = **12.1.7.70892** (gemaakt 2026-11-12).
  Dat is de nieuwste `wowt`-build in `wago.tools/api/builds`, gelezen 15 nov 2026 15:24.
- Werkwijze: `tools/gamedata.py`, via de voordeur. Twee eigen scripts in de scratchpad (`p2_gd_diff.py`, `p2_detail.py`).
  Die vergelijken per tabel elke rij op ID: nieuw, weg, of andere waarde.
- Questnamen: Wowhead PTR-tooltip (`nether.wowhead.com/ptr/tooltip/quest/<id>`), opgehaald 15 nov 2026.
- GEMETEN = gezien in die tabel, met dat id, in die build. AFGELEID = door mij beredeneerd.
- DB2 is data van de client. De server kan anders doen, en hotfixes na 70892 zie ik niet.
- ⚠️ Eén zoekopdracht liet per ongeluk regels uit `docs/` zien. Die heb ik nergens als bron gebruikt.

### Tabellen en tellingen (alles GEMETEN, live 70783 tegen PTR 70892)

| Tabel | live | PTR | nieuw | weg | anders |
|---|---|---|---|---|---|
| Achievement | 14139 | 14281 | 142 | 0 | 77 (bijna alleen `Ui_order`) |
| CriteriaTree | 121821 | 122778 | 957 | 0 | 21 |
| Criteria | 66666 | 67217 | 551 | 0 | 3 |
| QuestV2 | 66552 | 66772 | 220 | 0 | 0 |
| QuestLine / QuestLineXQuest | 1694 / 21150 | 1697 / 21214 | 3 / 64 | 0 | 2 / 0 |
| CurrencyTypes | 1528 | 1555 | 27 | 0 | 0 |
| Item / ItemSparse | 213950 / 175791 | 215048 / 176847 | 1103 / 1057 | 5 / 1 | 44 / 324 |
| SpellName | 416286 | 420217 | 3933 | 2 | 44 |
| Holidays | 811 | 804 | 1 | 8 | 65 |
| Mount / MountXDisplay | 1705 / 2064 | 1716 / 2076 | 11 / 12 | 0 | 9 / 0 |
| UiMap / AreaTable / Map | 1967 / 10046 / 1187 | 1974 / 10056 / 1201 | 7 / 10 / 14 | 0 | 0 / 32 / 0 |
| LFGDungeons | 1906 | 1918 | 12 | 0 | 10 |
| Achievement_Category | 243 | 247 | 4 | 0 | 0 |
| AreaPOI | 3946 | 3946 | 0 | 0 | 6 |
| ModifierTree | 317512 | 319559 | 2049 | 2 | 93 |
| MythicPlusSeason, MythicPlusSeasonRewardLevels, MythicPlusSeasonTrackedAffix, MythicPlusSeasonTrackedMap, ChallengeModeItemBonusOverride, MapChallengeMode | | | **0** | **0** | **0** |
| GroupFinderActivity, GroupFinderActivityGrp, GroupFinderCategory, JournalInstance, JournalEncounter, HolidayNames, HolidayDescriptions, CurrencyContainer | | | **0** | **0** | **0** |

Kolommen die erbij kwamen op de PTR (GEMETEN): `CurrencyTypes.MaxQtyCurveID` (in alle 1555 rijen 0), `Item.ItemPetFoodID`
en `Item.AmmunitionType` (en `Field_12_0_0_63534_010` is weg), `Map.OceanLiquidTypeID`, `AreaTable.ExplorationLevel`.

---

## 1. De id's die MH al gebruikt: er verdwijnt niets

Bron: `Modules/SelftestData.lua` (de R- en B-lijsten, de retail-kant). De F-lijst (Forever) heb ik niet gecontroleerd.

- **Spells, 1053 stuks:** alle 1053 staan in live en in de PTR, met dezelfde naam. GEMETEN (`SpellName`, 70783/70892).
  ⚠️ Alleen de naam is vergeleken. Wat een spell doet (SpellEffect, SpellMisc) heb ik niet vergeleken.
- **Achievements, 39 stuks:** 38 in live, 39 op de PTR. Dat is 64207, die alleen op de PTR bestaat. De criteria-bomen
  van alle 38 andere zijn gelijk, knoop voor knoop, met hun Criteria-rijen. GEMETEN (`Achievement`, `CriteriaTree`, `Criteria`).
  - Eén verschuift: **61463** "Master of the Turbulent Timeways V". `Category` 15454 (World Events > Timewalking) wordt
    **15274 (Feats of Strength > Events)**. GEMETEN (`Achievement` + `Achievement_Category`, 70892).
    AFGELEID: dat betekent "niet meer te halen". De mount heeft op de PTR een andere bron, zie punt 8. [RAAKT MH]
    `Modules/MountProgress.lua` entry `vyranoth` (r. 74-82).
- **Quests, 341 stuks:** alle 341 staan in live en in de PTR. GEMETEN (`QuestV2`). Deze tabel heeft geen namen of
  "weekly"-vlag, dus alleen het bestaan is gemeten.
- **Items, 18 stuks:** alle 18 zijn er nog. In de kolommen die beide builds hebben is niets veranderd, ook naam en
  itemlevel niet. GEMETEN (`Item`, `ItemSparse`). Het script meldde ze eerst als "anders". Dat kwam alleen door de
  nieuwe kolommen; ze staan niet in de echte lijst met wijzigingen.
- **Maps, 22 stuks:** alle 22 staan erin, met dezelfde rij. GEMETEN (`UiMap`).
- **Valuta die MH in de code gebruikt** (grep in `Modules/`): 3383, 3341, 3343, 3345, 3347 (Dawncrest), 3442-3446
  (Mistcrest), 3028, 3310, 2803, 3356, 3405, 3418, 3448, 3316, 2032, plus 1166 Timewarped Badge. Alle 20 staan in de
  PTR. `CurrencyTypes` heeft **0** veranderde rijen. GEMETEN (70892).

---

## 2. Wat al bekend was: klopt nog op 70892

- **64207 vraagt 4 weken.** CriteriaTree **235236**, `Amount` = **4**, criterium **118375**. Criteria 118375 = type 27,
  asset **quest 99424**, `Eligibility_world_state` 24978 = 1. GEMETEN (`CriteriaTree`/`Criteria`, 70892).
  - Turbulent Timeways V werkt precies zo: criterium 109788 = type 27, quest **93509**, dezelfde worldstate 24978.
    GEMETEN (`Criteria`, 70783).
  - AFGELEID: type 27 betekent "quest voltooid". De mijlpaal telt dus 4× quest 99424, één keer per week met Mastery.
    Wowhead PTR geeft voor 99424 een 404. Dat bewijst niets.
  - Let op: in TT V zegt de tekst van knoop 218589 "for **5** weeks", maar `Amount` is 4. De tekst kan dus liegen. MH
    leest `Amount` (`needFromCriterion`, MountProgress.lua r. 459-461). Dat is de goede keuze.
- **Timeways VI start 1/2 december.** GEMETEN (`Holidays`, naam 430 "Turbulent Timeways"):
  - holiday **1425** (regio 961): nieuwe datum **2026-12-01 07:00**
  - **1458** (regio 4): **2026-12-02 05:00**
  - **1459** (regio 2): 2026-12-03 08:00. **1460** (regio 24): 2026-12-03 07:00.
  - `Duration_0` gaat van **1008 → 1344**, in alle vier.
  - AFGELEID: de eenheid is uren. 1344 uur = 56 dagen = **8 weken**, dus einde rond **26 jan 2027** (VS) en 27 jan (EU).
    Controle: TT V staat in live op 2026-06-30 met 1008 uur (42 dagen). Dat komt uit op 11 aug, en dat zegt MH zelf
    ook (`CODEX_127_TIMEWAYS_TITLE` "Jun 30 - Aug 11", enUS.lua r. 3164).
  - AFGELEID: 961 = Amerika (07:00 = reset om 15:00 UTC), 4 = Europa (05:00 servertijd), 2 en 24 = de Aziatische regio's.
    De datums staan gecodeerd in de tabel; het uitpakken heb ik zelf gedaan. De ruwe getallen zijn GEMETEN.
  - [RAAKT MH] `Locales/Codex.lua` r. 186 `CODEX_TT6_BODY` ("for eight weeks", "Mastery in 4 different weeks") en
    enUS.lua r. 1068 `MOUNTPROG_TIMEWAYS6_HOWTO` ("for eight weeks"). Beide kloppen met de data.
- **Quests 99508/99509** staan in `QuestV2` (nieuw). GEMETEN. Zie punt 6 voor de volgorde.
- **Runen:** `SpellName` **1324888** = "Rune of Empowerment", **1324904** = "Rune of Critical Mass". Die tweede naam
  staat op de PTR 13× (onder andere 1325089, 1325140, 1325335). GEMETEN (70892).
- **63713 "The Coreway Advance"**: "Complete the Coreway Advance storyline.", 10 punten, categorie 15547 (Quests >
  Midnight). GEMETEN (`Achievement`, 70892). Zie punt 4.

---

## 3. Nieuw: Talebound / "Tales of the Storyteller" (het grootste stuk van de patch)

Alles GEMETEN in 70892, tenzij er AFGELEID staat.

- **Achievement-categorieën:** 15625 "Talebound" (bovenaan, Parent -1), 15627 "Bosses" en 15628 "Levels" (daaronder),
  15631 "Talebound" onder Expansion Features (15301). (`Achievement_Category`)
- **Achievements:** de meeste van de 142 nieuwe horen hierbij:
  - 63734-63826: baasgevechten op elke moeilijkheid, "The Complete Tale", Ducats, puzzels, Scribe, Outfitter, Arcanist,
    Antiquarian
  - 64135-64139: verhalen, met titel "Listener"
  - 64227-64230: puzzels per verhaal
  - 64416-64465: categorie 15631, beloningen via de **Traveling Raven**
  - De meeste geven "20 Bound Silver". Titels: "Monster Hunter" (63805), "of the Crooked Path" (63809), "of the Sacred
    Flame" (63813), "Listener" (64139).
- **Vier verhalen + een slotgevecht:**
  - Greenthistle Wood, Darkhaven, Court of Night, Greywake's Expedition, en "The Final Confrontation"
  - Drie rollen: Slayer, Witch en Inquisitor
  - AreaTable: 16391 Greenthistle Wood, 16402 Darkhaven, 16387 Grove of the Night Court, 16409 Greywake's Expedition,
    16381 Ravenswood Manor, 16533 Quillgrave, 16621 Red Hollow. In live heetten die rijen nog "[DO NOT DISTURB]".
- **Instance:** `Map` **2910** "Tales of the Storyteller" (InstanceType 2) en Map 2863 "Quillgrave".
  - `LFGDungeons` 2899, 3062, 3063 en 3064 "Tales of the Storyteller", met moeilijkheid 234, 238, 239 en 240.
  - `Difficulty`: 240 Normal, 234 Veteran, 238 Heroic, 239 Mythic. Alle vier zijn nieuw, InstanceType 2, **MaxPlayers 3**.
  - AFGELEID: dus een inhoud voor 1 tot 3 spelers, met 4 moeilijkheden.
- **Geen** nieuwe UiMap voor Quillgrave of de Tales. Ik zocht op Quillgrave, Storyteller, Talebound, Greenthistle,
  Darkhaven, Greywake en Court of Night in de UiMap van de PTR: 0 treffers. Andere nieuwe UiMaps vond dezelfde run wel.
  Ook geen JournalInstance en geen GroupFinderActivity (0 nieuwe rijen).
  AFGELEID: een route-pijl of het Dungeon Journal heeft daar (nog) niets aan.
- **Nieuwe valuta** (`CurrencyTypes`):

  | id | naam |
  |---|---|
  | 3325 | Ducats |
  | 3361 | Bound Silver (te ruilen bij Nib in Quillgrave) |
  | 3327 | Tales of Valor (Scribe) |
  | 3332 | Alkahest (Arcanist) |
  | 3320 | Outfitter Supplies |
  | 3362 | Lost Relic (Antiquarian) |
  | 3326 | Experience |
  | 3593 | Lives ("Lives Remaining This Run") |

  Daarnaast 18 rijen "Reuse NN [DNT]".
- **Traveling Raven-beloningen** (achievements 64416-64465):
  - "Venomstone Cache" (64427-64430, The Final Confrontation's Conclusion op Normal t/m Mythic)
  - "Nebulous Voidcache" (64443-64445, The X and the Scribe Complete)
  - Mistcrest Pouches (64435-64439)
  - "Cache of Champion/Heroic/Mythic Treasures"
  - Bij de vorige drie: zie punt 9 voor de items.
- **Quests met naam** (Wowhead PTR, 15 nov):
  - Quillgrave: 93189 Explore Quillgrave, 93191, 93192, 93194
  - de tutorial: **93357** "Alone in the Dark" (= criterium 119580 van achievement 64417 "Delving into a Tale")
  - 98760-98766: The Tale of …, The Slayer's/Witch's/Inquisitor's Tale
  - 98825 A Tale Yet Told, 98828 The Veteran's Ballad (150 vijanden), 98829 The Hero's Saga (10 bazen), 98835 A Daunting Final Tale
  - AFGELEID, NIET GEMETEN: dat 98825-98835 weekly zijn. DB2 heeft geen weekly-vlag.
- [RAAKT MH] `Modules/MidnightAchList.lua` r. 23-34 `GROUPS`: daar staan 15625, 15627, 15628 en 15631 **niet** in. Dan
  laat `/mh achlist` de Talebound-achievements weg. GEMETEN (de code). Of ze erin horen, kiest Rob.

---

## 4. Nieuw: campagne "The Coreway Advance"

- `QuestLine` **6210** "The Coreway Advance" (nieuw), **14 quests** op volgorde:
  95287, 95302, 95289, 95291, 95292, 95297, 95298, 95299, 95300, 95301, 95305, 95303, 95306, 95307.
  GEMETEN (`QuestLineXQuest`, `OrderIndex` 0-13, 70892).
- Namen (Wowhead PTR, 15 nov): 95287 "The Coreway Advance" (Arator in Dornogal), 95302 "To the Core of the Matter",
  95299 "Family Road Trip" (Uldaman via de Archives in Dornogal), 95307 "Worldcore Revealed".
- Nieuwe zones: UiMap 2603/2604 "Uldaman_Dornogal_A/B". AreaTable 16911 "Uldaman" (UldamanReturnToDornogal) en
  17024 "Hall of the Keepers". Map 3054 "Uldaman". GEMETEN.
- [RAAKT MH] `Modules/CampaignLeadIn.lua`: deze quest-id's staan er nog niet in. GEMETEN: grep op 95287 in `Modules/`
  geeft 0 treffers; grep op 95533 vindt dezelfde file wel.

---

## 5. Nieuw: Lorewalking Jaina, Titans, Tyr en Thrall

- Achievements (categorie 15552 Lorewalking):
  - 63604 "Lorewalking: Tyr", decor "Origin of the Silver Hand"
  - 63691 "Lorewalking: Thrall", decor "Tale of the First Warchief"
  - 63710 "Lorewalking: Titans", decor "A Brief History of the Titans"
  - 63712 "Lorewalking: Jaina", decor "Tome of the Sea"
  - GEMETEN (`Achievement`, 70892; alle vier zijn nieuw)
- QuestLines (GEMETEN):
  - 6212 "Lorewalking: Jaina" (nieuw, 6 quests)
  - 6222 "Lorewalking: Titans" (nieuw, 10 quests)
  - 6220 heette "Tyr Lorewalking" en heet nu "Lorewalking: Tyr". Hij krijgt 32 quests; in live zaten er 0 in.
- Scenario's (`LFGDungeons` 3217-3219):
  - "12.1.7 Lorewalking - Jaina Hyjal / Dazar'alor / Theramore Scenario"
  - Maps 3059-3061, UiMap 2716-2718 (Hyjal Summit, Theramore Isle, Ruins of Theramore)
  - Titans: UiMap 2592 "Seat of the Pantheon" en 2593 "Frachtorn"
- `Difficulty` 236 "Lorewalking" (5 spelers) en 241 "Lorewalking" (InstanceType 2, 10 spelers).
  - Nieuwe `LFGDungeons` 3216 Uldaman en 3220 Halls of Stone (beide 236), en 3221 Ulduar en 3236 Antorus (beide 241).
  - De oude achievements 638 "Uldaman" en 485 "Halls of Stone" krijgen een andere `OrderIndex`. Hun criteria krijgen
    ModifierTree 403949 (type 73, asset 300083). GEMETEN.
- [RAAKT MH] `Locales/Codex.lua` r. 188 `CODEX_LOREWALK_BODY` ("Four stories: Jaina, Thrall, the Titans and Tyr").
  Dat klopt met de vier achievements. GEMETEN.

---

## 6. Omnium Folio stap 6 en 7

- `QuestLine` **6307** "The Empowered Folio", volgorde (GEMETEN, `QuestLineXQuest`, 70892):
  96410 (0), 96441 (1), 96442 (2), 96443 (3), 96444 (4), **99509 (5)**, **99508 (6)**.
- Achievement 64290 "The Power of Stories": boom 236100 "Complete Omnium Unlock 6", knoop 236101 "**Sixth** Omnium Point".
  Criterium 118818 = quest **99508**. GEMETEN.
- Achievement 64291 "Core Logic": boom 236102 "Complete Omnium Unlock 7", knoop 236103 "**Seventh** Omnium Point".
  Criterium 118819 = quest **99509**. GEMETEN.
- ⚠️ Ze spreken elkaar tegen. Volgens de achievement is 99508 de zesde. In de QuestLine komt **99509 vóór 99508**.
  Welke het spel eerst geeft, is NIET GEMETEN. Dat moet in de client blijken.
- Nieuw: quest **99647** "Seeking Knowledge: Coreway Rune Fragment" ("Return the Coreway Rune Fragment to Grand
  Magister Rommath"). Hij heeft dezelfde `UniqueBitFlag` 72530 als 99509. GEMETEN (`QuestV2` + Wowhead PTR).
  AFGELEID: een tweede vorm of vervolg van "Core Logic".
- 64290 en 64291 staan in categorie **15610** (Void Assaults), met Flags 1179648. GEMETEN.
  AFGELEID: verborgen tracking-achievements, dus niet zichtbaar in `/mh achlist`, al staat 15610 in `GROUPS`.
- [RAAKT MH]
  - `Modules/OmniumFolioData.lua` r. 22 `unlockQuests = { 96410, 96441, 96442, 96443, 96444 }`: 99509 en 99508 ontbreken.
  - `Locales/Codex.lua` r. 71 `CODEX_FOLIO_BODY` zegt "(5 steps)". De QuestLine heeft er op de PTR 7.
  - Rij 6 en 7 met de runen 1324888 en 1324904 staan nog niet in OmniumFolioData. GEMETEN: grep op 99508|99509|1324888
    in `Modules/` geeft 0 treffers buiten SelftestData; dezelfde grep vond 64207 wel.

---

## 7. Timewalking-weken in december en januari

- In de PTR heeft elke week van Turbulent Timeways VI een eigen "Timewalking Dungeon Event". GEMETEN (`Holidays`, 70892):

  | week | regio 961 | regio 4 |
  |---|---|---|
  | 1 | 1669: 12-01 | 1667: 12-02 |
  | 2 | 1703: 12-08 | 1705: 12-09 |
  | 3 | 1722: 12-15 | 1720: 12-16 |
  | 4 | 1508: 12-22 (regio 2017) | 1583: 12-23 |
  | 5 | 559: 12-29 | 622: 12-30 |
  | 6 | 562: 2027-01-05 | 616: 01-06 |
  | 7 | 587: 01-12 | 628: 01-13 |
  | 8 | 643: 01-19 | 652: 01-20 |

  Elk event duurt 167 uur.
- Welk uitbreidingsdeel bij welk holiday-id hoort, staat niet in DB2: ze heten allemaal "Timewalking Dungeon Event".
  NIET GEMETEN.
- Weg uit de PTR: 651, 653, 655 en 657 (zonder naam, 192 uur), en 1704, 1706, 1708 en 1710 (192 uur, met 2026-12-29).
  GEMETEN.
- Nieuw: holiday **1895**, zonder naam, regio 0, Flags 15, 2904 uur, start **2026-12-01 00:00**. GEMETEN.
  AFGELEID: ongeveer 17 weken lang. Waar het voor dient, weet ik niet.
- Ook nieuw (GEMETEN, alleen PTR):
  - Delves Bonus Event 1559/1560: 2027-02-02 en 02-03. De datum 2026-12-15 stond ook al in live.
  - Midnight Dungeon Event 1802: 2027-02-16.
  - Lunar Festival 327: 2027-02-02 → **2027-02-05**.
- [RAAKT MH] niet direct. MH heeft geen holiday-id's in de code. GEMETEN: grep op 1425|1458|559|562|587|1559|1802 in
  `Modules/` vond alleen spell 1459 en Forever-map 1458/1425, geen holidays.

---

## 8. Spawn of Vyranoth en de mounts

- **Spawn of Vyranoth** (`Mount` 2806):
  - live `SourceText` = "Achievement: Master of the Turbulent Timeways V"
  - PTR = "**Vendor: Any Timewalking Vendor, Cost: 5000** |Hcurrency:1166|h" (1166 = Timewarped Badge)
  - `SourceTypeEnum` 5 → 2
  - GEMETEN (`Mount`, 70892)
  - [RAAKT MH] enUS.lua r. 1066 `MOUNTPROG_VYRANOTH_HOWTO` zegt "Expected but not confirmed: from patch 12.1.7 a
    Timewalking vendor sells it for 5,000 Timewarped Badges". Dat staat nu zo in de PTR-data, maar nog niet live. Ook
    `Modules/MountProgress.lua` r. 70-82 (`vyranoth`, achievement 61463, die naar Feats of Strength gaat).
- **Markeet of the Infinite**: `Mount` 3175, bron "Achievement: Master of the Turbulent Timeways VI", spell 1323203.
  `ItemSparse` 287513 "Teaches you how to summon this mount." GEMETEN.
- **Nieuwe Talebound-mounts:** 3000 Shadowbound Storybook, 3134 Stone-Carved Crusher, 3135 Autumn Dream Jumper,
  3136 Shadowpaw Wood Watcher. GEMETEN.
- **Zes Trading Post-mounts zijn hernoemd en komen nu uit Talebound** (`SourceText` Trading Post → Talebound,
  `SourceTypeEnum` 11 → 2). GEMETEN:

  | mount-id | oude naam | nieuwe naam |
  |---|---|---|
  | 2187 | Underlight Shorestalker | The Watcher in the Waves |
  | 2481 | Midnight Darkmoon Charger | Lost Mare of the Maddening Faire |
  | 2494 | Midnight Butterfly | Night Court Courier |
  | 2521 | Summer Harvesthog | Enchanted Woodland Wanderer |
  | 2581 | Banshee's Sickening Charger | Faith-Cursed Courser |
  | 2927 | Gilnean Copper Charger | Ambermill Traveler's Rouncey |

  De bijbehorende sets heten ook anders, bijvoorbeeld "Ensemble: Faith-Cursed Vestments" en "Ensemble: Ambermill
  Traveler Attire" (`SpellName`/`ItemSparse`).
- **Nieuw bij de Trading Post:** 4 Stegodons (3161-3164) en Reanimated Skeletal Raptor (3176). Bij Winter Veil:
  "Winterrrgl's Pine-Powered Candy Cane Contraption" (3172, "Drop: Greench"). GEMETEN.
- [RAAKT MH] geen. Grep op deze oude namen en spell-id's in `Modules/` en `Locales/enUS.lua`: 0 treffers.
  Positieve controle: in dezelfde grep stond Spawn of Vyranoth, en die werd gevonden.

---

## 9. Items: caches en pouches (`ItemSparse`, 70892, GEMETEN)

- **Venomstone Cache** 288962, 288963, 288964 en **288965**: "Contains 10 Ascendant Venomstones which can be used to
  upgrade weapons, trinkets and necklaces. Only usable in Season 2." Itemlevel 297, RequiredLevel 90.
- **Nebulous Voidcache** 288959, 288960 en **288961**: "Contains a Nebulous Voidcore … Only usable in Season 2."
- Pouches met 20 crests: Myth Mistcrest Pouch 288975/288976, Hero Mistcrest Pouch 288977/288978, Champion Mistcrest Pouch 288979.
- Cache of Champion/Heroic/Mythic Treasures (288980-288987): "… from the Vaults of Atal'Utek". Ook Packed Alchemy
  Crate 288973 en Outfitter's Crate 288974.
- **Satchel of Corrosive Coins** 281223: de tekst gaat van "Contains a small amount Corrosive Coins." naar
  "**Contains 100 Corrosive Coins.**" GEMETEN.
- Ascendant Venomstone 280562 is gelijk gebleven. GEMETEN.
- [RAAKT MH] AFGELEID, een keuze voor Rob: er komt een nieuwe, eenmalige bron bij voor Venomstones (de
  Talebound-achievements). Die bron noemt MH nog niet:
  - enUS.lua r. 3661 `TRACKCEIL_ROUTE_VENOM` (de lijst met bronnen)
  - `Locales/Codex.lua` `CODEX_VENOMSTONE_BODY`
  - voor de Voidcache: `CODEX_VOIDCORE_BODY` en `Modules/BonusRollCapture.lua`
  - Het woord "neck" staat er al in, dus dat deel klopt.

---

## 10. Seizoen, Mythic+, Group Finder en Journal: niets veranderd

- `MythicPlusSeason` (35 rijen), `MythicPlusSeasonRewardLevels`, `MythicPlusSeasonTrackedAffix`,
  `MythicPlusSeasonTrackedMap`, `ChallengeModeItemBonusOverride` en `MapChallengeMode` (87 rijen) zijn gelijk.
  `GroupFinderActivity` (1350), `GroupFinderActivityGrp` en `GroupFinderCategory` ook, net als `JournalInstance` (216)
  en `JournalEncounter` (1161): 0 nieuw, 0 weg, 0 anders. GEMETEN (70783 tegen 70892).
- AFGELEID: geen nieuw M+-seizoen en geen andere dungeon-pool in 12.1.7, voor zover de client het weet. De server kan
  dat nog veranderen.
- [RAAKT MH] `Modules/DawncrestData.lua` (Mistcrest-id's 3442-3446) blijft goed. GEMETEN.

---

## 11. Overige wijzigingen

- **Aqir Invasions zijn voorbij.** `AreaPOI` 8903 "Aqir Researchers": de tekst wordt "Researchers remain to give out
  rewards **now that the aqir invasions are finished**." `UiWidgetSetID` 2338 → 0. GEMETEN (70892).
  [RAAKT MH] `Modules/MidnightCodexData.lua` r. 604-613 (`aqir_invasion`; de opmerking daar zegt dit al),
  `Modules/EventInfoData.lua` r. 50-64, en `Modules/MidnightAchList.lua` r. 51 (63657, 63658, 63680, 63659; alleen
  `Ui_order` veranderd).
- **Horrific Visions Revisited** 41971: de omschrijving krijgt erbij "Must have been completed prior to Midnight."
  GEMETEN.
- **Winter Veil 2026:**
  - achievements 64174 "Bow Go", 64175, en 64367-64372 (housing neighborhood: tree defense, carolers, Candy Cane Brigade)
  - 62502 "Master of Merry Mayhem" wordt account-breed (Flags 0 → 131072)
  - de boom 224832 verandert: Operator 8 → 5, Amount van 224833 1 → 0
  - valuta 3642 "Winter Veil Gift", quests 99262, 99263 en 99343
  - GEMETEN. Niet voor MH.
- **QuestLine 6385 "The Labyrinth of Kindo'jan":** alleen een hoofdletter ("Myth"). Er zitten 6 quests in:
  98951, 98963, 98962, 98961, 98960 en 98959. GEMETEN.
- **SpellName:** weg op de PTR zijn 1262256 "Teleport (DNT)" en 1285442 "Ask Lorewalker Cho a Question".
  Hernoemd: 1257557/1257558 "Summon Cho" en "Talk to Lorewalker Cho" → "… Li Li". Geen van alle staat in MH. GEMETEN.

---

## 12. Wat ik NIET heb kunnen meten

- Welke quests weekly zijn. `QuestV2` heeft daar geen kolom voor.
- 130 van de 220 nieuwe quests gaven een 404 bij Wowhead PTR (onder andere 99424 en 99508). Dat bewijst niets.
- Wat spells doen (SpellEffect, SpellMisc). Alleen de namen zijn vergeleken.
- Welk uitbreidingsdeel bij welke Timewalking-week hoort.
- Wat holiday 1895 is.
- Welke Folio-quest het spel als zesde geeft (99508 of 99509).
- Of de server na build 70892 nog iets verandert: hotfixes, of een nieuwere PTR-build na 12 nov.
- De F-lijst (Forever) van SelftestData.lua. Die hoort bij een ander spel en is hier niet vergeleken.

## Ruwe uitvoer (scratchpad, voor nameten)

`C:\Users\RobHu\AppData\Local\Temp\claude\E--World-of-Warcraft--retail--Interface-AddOns\f5f259a6-b38e-526f-86e4-08d1f38cb4f3\scratchpad\p2_out\`
Per tabel een `<Tabel>.txt`, plus `mh_ids.txt` (de SelftestData-check), `detail.txt` (holidays, Folio, questnamen)
en `summary.txt`. De scripts staan ernaast: `p2_gd_diff.py` en `p2_detail.py`.
