# Dungeon-check 2 (onafhankelijk), 18 nov 2026

Forever-build: wago `builds` meldt wowf = 1.60.1.70959 (17 nov 2026). Gethe-branch `forever` laatste commit
3d8abb1da7 "1.60.1 (70959)", 17 nov 2026. Het verslag van de eerste helper heb ik NIET gelezen.

## 1. DB2: Journal-tabellen weg, DungeonEncounter wel  ->  KLOPT, behalve het aantal (KLOPT NIET)

- GEMETEN (wago.tools, build 1.60.1.70959): JournalInstance, JournalEncounter, JournalEncounterSection en
  JournalEncounterItem geven alle vier "HTTP Error 400: Bad Request".
- Positieve controle, zelfde tool: JournalInstance op retail 12.1.5.70961 = 216 rijen (tabelnaam klopt).
- GEMETEN: DungeonEncounter Forever = **376 rijen**, niet ~277. Kolommen: Name_lang, ID, MapID, DifficultyID,
  OrderIndex, CompleteWorldStateID, Bit, Flags, SpellIconFileID, Faction, ItemSequenceLevel. Bazen per dungeon via MapID.
- GEMETEN: namen per taal bestaan. deDE: 2747 "Edwin van Cleef", 2755 "Erzmagier Arugal", 3676 "Minenarbeiter Johnson".
- Let op (GEMETEN): dubbele sets voor Blackfathom Deeps (48), Gnomeregan (90) en Sunken Temple (109); rij 3061
  "No Longer in Use" (MapID 0); test-rijen 3078 Rahuz (map 13 "Test Dungeon") en 3025 Testwerk (2720).
  Map 3002 (Deathulus, Crushfist Bloodbreaker) heeft GEEN rij in de Map-tabel.

## 2. Blizzard_EncounterJournal laadt niet in Forever  ->  KLOPT

- GEMETEN: `Interface/AddOns/Blizzard_EncounterJournal/Blizzard_EncounterJournal.toc` (branch forever),
  **regel 7: `## AllowLoadGameType: standard, classic`**. Forever/camelot staat er niet in.
- GEMETEN (warcraft.wiki.gg "TOC format", laatst bewerkt 5 nov 2026): familie `mainline` = `standard, forever,
  camelot, plunderstorm, wowhack`; `classic` = `vanilla, tbc, wrath, cata, mists`. Dus `standard` = alleen Midnight.
- Steun in de bron zelf (GEMETEN): `Blizzard_Collections.toc` r.41 `[AllowLoadGameType camelot, standard]` noemt
  ze apart; `Blizzard_MicroMenu.toc` r.9 `[AllowLoadGameType mainline] [ExcludeLoadGameType camelot]` en
  `Blizzard_Collections.toc` r.30: camelot valt onder mainline, niet onder standard.
- Kanttekening (GEMETEN): in Forever staat de EJ-knop wel in het micromenu:
  `Blizzard_MicroMenu/Camelot/MicroMenuContainerOverrides.lua` r.12
  `GenerateButtonCallbackInfo(EJMicroButton, GameRulesUtil.EJIsDisabled)`. EJIsDisabled
  (`Blizzard_SharedXML/GameRulesUtil.lua` r.78) hangt af van spelregels op de server. Dat kan ik niet meten.
  AFGELEID: de knop kan zichtbaar zijn, maar het addon mag volgens regel 7 niet laden.

## 3. Steekproef dungeon_guide_sample.lua

NPC's (GEMETEN, Wowhead Forever tooltip, 18 nov): alle 6 KLOPPEN.
| id | naam | zone | DB2-encounter in sample |
|---|---|---|---|
| 644 | Rhahk'Zor (Elite, lvl 19) | 1581 Deadmines | 2741 KLOPT |
| 639 | Edwin VanCleef (lvl 21) | 1581 | 2747 KLOPT |
| 3671 | Lady Anacondra (lvl 20) | 718 Wailing Caverns | 585 KLOPT |
| 3654 | Mutanus the Devourer (lvl 22) | 718 | 592 KLOPT |
| 3887 | Baron Silverlaine (lvl 24) | 209 Shadowfang Keep | 2750 KLOPT |
| 4275 | Archmage Arugal (lvl 26) | 209 | 2755 KLOPT |
Ook GEMETEN: WC = alleen 585-592 en SFK = alleen 2748-2755 in DB2, dus "Deviate Faerie Dragon en Deathsworn Captain
hebben geen rij" KLOPT.

Items: naam en stats GEMETEN (Wowhead Forever tooltip). Wie het laat vallen: tooltip noemt alleen 5193 en 273643.
Voor de andere 7 is de 2e bron ForeverDungeonJournal `Data/DropRates.lua` (zegt zelf: Wowhead Forever-tellingen,
gelezen 18 nov 2026). Alle 9 KLOPPEN.
| item | naam (WHT) | baas in sample | bewijs baas |
|---|---|---|---|
| 5191 | Cruel Barb, 1H sword | 639 VanCleef | FDJ r.214/218 |
| 7230 | Smite's Mighty Hammer, 2H mace, +11 Str | 646 Smite | FDJ r.203/204 |
| 5193 | Cape of the Brotherhood, +5 Agi | 639 VanCleef | WHT "Dropped by: Edwin VanCleef 19.28%" |
| 6469 | Venomstrike, bow | 3673 Serpentis | FDJ r.279/280 |
| 6631 | Living Root, staff, +5 Spirit | 5775 Verdan | FDJ r.287/289 |
| 6627 | Mutant Scale Breastplate, mail, +10 Str | 3654 Mutanus | FDJ r.293/295 |
| 6220 | Meteor Shard, dagger | 4275 Arugal | FDJ r.365/368 |
| 6324 | Robes of Arugal, cloth, +6 Spirit | 4275 Arugal | FDJ r.365/366 |
| 273643 | Worgenbane Talisman, trinket, +2 mana/5s | 4278 Springvale | WHT "Dropped by: Commander Springvale 32.10%" |

Opletten (GEMETEN): de FC-percentages in de sample zijn Classic-cijfers. Wowhead Forever via FDJ zegt anders:
Cruel Barb 21.2 (FC 16), Smite's Hammer 24.6 (19), Venomstrike 14.1 (17), Living Root 31.6 (38),
Mutant Scale 28.8 (22), Meteor Shard 29.4 (18), Robes 29.6 (35). Ook de stats verschillen: Classic-tooltips geven
voor 6469, 6631, 6627, 6220, 6324 andere waarden dan Forever. Gebruik dus alleen Forever-tooltips.

Drie mechaniek-regels tegen een 2e bron:
- Mr. Smite "stunt de groep op vaste levensdrempels, wisselt dan van wapen": KLOPT. Wowhead Forever npc=646
  (via Exa): reacties "at 2/3 ... he stuns your entire group ... (he does this at 1/3 hp as well)" en "stuns when he
  changes his weapons". Let op: oude Classic-reacties (Thottbot), geen datum na 18 aug.
- Mutanus "komt pas na de vier Lords en de escort van de Disciple": KLOPT. Wowhead Forever npc=3654, reactie 9193:
  "kill all 4 Fanglords then go back to the start ... speak with Disciple of Naralex ... escort". Plus
  ForeverDungeonJournal `Core/Journal.lua` r.555 "Mutanus appears at Naralex after the escort." Reactie is oud.
- Silverlaine "curse, healing 75% minder": GEDEELTELIJK. GEMETEN: Forever-spell 7068 Veil of Shadow =
  "Reduces healing effects for an enemy by 75% for 15 sec", Dispel type Curse (Wowhead Forever spell-pagina).
  NIET TE METEN: welke spell Silverlaine in Forever echt gebruikt. Er bestaat ook 460755 (75%, "nearby enemies",
  dus een gebied) en 455350 (30%). Is het 460755, dan klopt "curses someone" niet. Graag in het spel nameten.

## 4. Negen nieuwe Forever-dungeons  ->  KLOPT

GEMETEN in Map (1.60.1.70959). Alle negen hebben InstanceType 1 (dungeon) en bazen in DungeonEncounter:
| Map | naam in DB2 | bazen |
|---|---|---|
| 3065 | The Hall of Thanes | 4 (3493-3496) |
| 2999 | Ruins of Lordaeron | 7 |
| 2998 | Excavation Site: Wetlands | 4 |
| 2959 | City of Dalaran | 9 |
| 2970 | The Drowned City | 6 |
| 3039 | Krol'dok Stronghold | 5 |
| 2994 | Alcaz Prison | 5 |
| 2974 | Blackmaw Hold | 7 |
| 3001 | The Shaper's Terrace | 11 |
"Nieuw" GEMETEN: geen van de negen staat in Map van Classic Era 1.15.9.70576 of retail 12.1.5.70961. Positieve
controle: Map 36 Deadmines staat in beide. De andere niet-vanilla kaarten (2720, 2784 Demon Fall Canyon, 2856,
2875 Karazhan Crypts, 2921) staan wel in Classic Era. Dat zijn dus geen nieuwe Forever-dungeons.
Kleine let-op: DB2 noemt baas 3495 in Hall of Thanes "Infurnus", maar FDJ DropRates r.79 zegt "Magmatus". Niet uitgezocht.

## 5. Licenties  ->  KLOPT (met een kanttekening)

- Spoken_Bosses: `E:\World of Warcraft\_forever_\Interface\AddOns\Spoken_Bosses\Spoken_Bosses.toc` regel 23:
  `## X-License: Addon code MIT. Boss names are Blizzard's, from the game's own tables.` Geen LICENSE-bestand in de
  map. Positieve controle: de glob vond wel `Spoken\Libs\LibDeflate\LICENSE.txt`. AFGELEID: "Addon code MIT" zegt niet
  met zoveel woorden dat de datatabellen (Creatures.lua, Stories.lua) ook MIT zijn.
- ForeverDungeonJournal (Author: Exehn, 2.0.11): `ForeverDungeonJournal.toc` regels 1-11 hebben geen licentieveld.
  Er is geen LICENSE-bestand bovenin, alleen `Libs\LibDeflate\LICENSE.txt` (van de lib).
  Zoeken op "licen[cs]e|copyright|rights reserved" (zonder Libs) vindt alleen verwijzingen naar Polestar's
  LICENSE-DATA: SOURCES.txt r.794 en LOCALIZATION-AUDIT.md r.121. Zoeken op "MIT" (hoofdletters) in de hele map
  vindt 0 keer. Hetzelfde woord vond ik wel in Spoken_Bosses.toc. AFGELEID: zonder licentie mag je kijken,
  maar niets overnemen.
