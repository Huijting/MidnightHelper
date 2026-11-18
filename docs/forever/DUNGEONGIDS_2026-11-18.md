# Dungeon-gids voor WoW Forever: onderzoek (18 nov 2026)

Alleen onderzoek. Niets gebouwd, repo niet aangeraakt. Voorbeelddata: `dungeon_guide_sample.lua` (zelfde map,
luac -p: geen fouten). G = GEMETEN (gezien in een genoemde bron met datum), A = AFGELEID (beredeneerd).

## Kort

- Forever heeft geen bazenboek van Blizzard, maar wel een lijst van alle bazen per dungeon: DB2 `DungeonEncounter`
  (G). Die geeft de namen meteen in elke taal (G voor deDE). Dat is de ruggengraat.
- Bazen-id's (NPC) en buit-id's: Wowhead Forever-tooltips bevestigen ze snel (G). De lijst "wie dropt wat" komt van
  foreverchanges.pro (build 70959, G) en gidsen.
- Wat bazen doen: alleen uit gidsen (Icy Veins okt, Mobalytics nov). Geen Blizzard-bron. Spell-id's: niet gemeten.
- Advies: optie A+ (bazen + 1-3 regels + een tip, en 2-3 opvallende items per dungeon), eerst de 9 dungeons tot
  level 32. Geen volledige buitlijst: dat is het DungeonJournal-addon nabouwen, en dat wilde Rob niet (zie 1).

## 1. Wat MH al heeft

`Modules/ForeverDungeons.lua` (G, gelezen 18 nov):
- 35 regels (28 instances; Scarlet Monastery, Dire Maul, Stratholme, Blackrock Spire per vleugel).
- Velden: `key, name, map` (instance Map-id), `min, max` (level, uit DB2 GroupFinderActivity), `zone, x, y` (ingang,
  HandyNotes_DungeonRaidLocations-Forever, MIT), `side`, `cityOf`, `part`, `ten`, `web`.
- Al aanwezig en herbruikbaar: `CurrentDungeon()` (in welke dungeon sta je, via `GetInstanceInfo` id 8 = `map`),
  `Name()` (naam per taal via `GetRealZoneText`), de lijst `ns.FOREVER_DUNGEONS`, en het tabblad "Dungeons & group"
  in het overzicht (`ns.ShowForeverOverviewPage("dungeons")`, ForeverOverview.lua:2606).
- In de kop staat Robs richting (14 nov): "MH explains in its own way, does NOT rebuild the DungeonJournal addon", en
  "Nothing from ForeverDungeonJournal (no licence found = all rights reserved)".

`Modules/DungeonBossWindow.lua` (2427 regels, G):
- Wordt in Forever NIET geladen: `MidnightHelper_Camelot.toc` noemt `ForeverDungeons.lua` (regel 185) maar niet
  `DungeonBossWindow.lua`, `DungeonTipsData.lua` of `DungeonRosterData.lua` (G, zelfde grep).
- Midnight-only: `EJ_GetInstanceForMap`, `EJ_GetCreatureInfo` (Encounter Journal), de Midnight-roster
  (`DungeonRosterData`, journal-encounterID's), de M+/Heroic/Mythic-filter, ritual/raid-items, `issecretvalue`-guards.
- Herbruikbaar als patroon (A): datavorm `bosses = { {key, encounterID, name} }`, tips per rol (`tank/heal/dps` ->
  locale-sleutels `DGN_TIP_*`), 3D-model via creature-id (`CREATURES`), baas-targeten -> juiste pagina (`NPC_TO_BOSS`),
  apostrof-normalisatie, bladeren `< i/N >`, Shift+scroll-schaal. Het bestand zelf in Forever laden raad ik af (A):
  te veel Midnight-paden; beter een klein Forever-paneel of een uitklapdeel in het bestaande Dungeons-tabblad.

## 2. Blizzard-data in Forever

DB2 via wago, Forever build 1.60.1.70959 (G, 18 nov):
| Tabel | Forever |
|---|---|
| JournalInstance, JournalEncounter, JournalEncounterSection, JournalEncounterItem | HTTP 400 bij wago (alle vier). Positieve controle: JournalInstance retail 12.1.5.70961 gaf rij 63 "Deadmines" (G) |
| DungeonEncounter | Bestaat. Naam, MapID, OrderIndex, DifficultyID. Geen NPC-id, geen buit, geen mechaniek (G) |
| Creature | Bestaat, maar maar 189 rijen: pets en zo (eerste rij Mechanical Squirrel). Geen bazen (G) |
| Map | Bestaat; 33/36/43 = Shadowfang Keep / Deadmines / Wailing Caverns (G) |

- Telling `DungeonEncounter` voor de 28 MH-instances: 277 rijen in totaal (G). Met alleen moeilijkheid 0 (en 1 voor
  BFD/Gnomeregan) houd ik ~241 bazen over (A: 198/201/215 lijken Season-of-Discovery-resten).
- Rares zonder eigen rij: Deviate Faerie Dragon (WC = 585-592), Deathsworn Captain (SFK = 2748-2755), en Sneed's
  Shredder (G: rij ontbreekt). Miner Johnson heeft wel een rij (3676, G).

Kan de client het bazenboek gebruiken?
- Blizzards eigen UI-bron, `Gethe/wow-ui-source` branch `forever`, laatste commit "1.60.1 (70959)", 17 nov 2026 (G):
  `Blizzard_EncounterJournal.toc` heeft `AllowLoadGameType: standard, classic` (G). Forever = `camelot` (MH's toc;
  Blizzards `Blizzard_GroupFinder_VanillaStyle.toc` noemt `classic, camelot` apart, G). Dus het bazenboek-venster
  laadt niet in Forever (A, sterk).
- De API-documentatie `C_EncounterJournal` staat wel in die branch (`Environment = "All"`, G). Of de functies in Forever
  iets teruggeven: NIET gemeten. Zonder Journal-tabellen verwacht ik leeg (A). ForeverDungeonJournal roept
  `EJ_*` aan met `type(...) == "function"`-checks en zegt "Forever adds its new dungeons in a separate Encounter
  Journal tier" (kandidaat, geen bewijs).
- Test voor Rob in het spel (~160 tekens, onder de grens van 255):
  `/run print(EJ_GetNumTiers and EJ_GetNumTiers(), C_EncounterJournal and C_EncounterJournal.GetInstanceForGameMap and C_EncounterJournal.GetInstanceForGameMap(36))`

## 3. Bronnen: wat is betrouwbaar

| Bron | Wat | Datum | Oordeel |
|---|---|---|---|
| wago DB2 (Blizzard) | bazenlijst, volgorde, namen per taal, map-namen | build 70959 | hardste bron (G) |
| Wowhead Forever tooltip-JSON (`run gamedata npc/item --game forever`) | NPC-naam, level, Elite/Rare Elite; item-stats; soms "Dropped by" + kans | 18 nov 2026 | goed, snel (G) |
| foreverchanges.pro/dungeons/... | buit per baas met item-id; "New"-items | build 70959; drops "as of" 3 okt (DM) / 6 okt (WC, SFK) | goed voor buit; kansen zijn die van Classic (zegt de site zelf). Vóór de launch (4 nov) gemeten |
| Icy Veins Forever-gidsen (Neryssa) | mechanieken + buit per baas | 18/19 okt 2026 | bruikbaar; kleine fouten (Pythas-stuk onder kop "Lord Serpentis"; "Druids of the Flame") |
| Mobalytics Forever-gidsen | mechanieken, buit | 12 nov (DM), 14 nov (WC) | na de launch, community-schrijvers; goede 2e bron |
| Warcraft Tavern Forever SFK | mechanieken | geen datum gezien | zwakker: zegt "Location: The Barrens" voor SFK |
| method.gg Forever SFK | Arugal | alleen zoekfragment | niet gelezen |
| Spoken_Bosses (lokaal addon, MIT code) | NPC- en display-id's, bazennamen in 9 talen | v3.10.0 | goede kandidatenbron; namen komen volgens hun toc uit Blizzards tabellen; klopt met DB2 (G: 2741 = Rhahk'Zor, deDE "Edwin van Cleef" = DB2) |

Waar ze het oneens zijn (G): drop-kansen (Cape of the Brotherhood: FC 23%, Wowhead 19,28%); aantal bazen (gidsen
tellen extra's als Fel Steed / Arugal's Voidwalker); Fenrus' voidwalkers (Icy Veins: "at 50% health"; tweede bron niet
gevonden). Advies: geen drop-kansen tonen.

Nieuw in Forever (G: Map-id's 29xx-30xx in DB2 en in MH's lijst; "nieuw" zelf is A): Hall of Thanes (4 bazen), Ruins of
Lordaeron (7), Excavation Site (4), City of Dalaran (9), The Drowned City (6), Krol'dok Stronghold (5), Alcaz Prison (5),
Blackmaw Hold (7), The Shaper's Terrace (11) = 9 dungeons, 58 encounter-rijen (G). Voor deze geen Classic-kennis; de
bronnen zijn dunner (niet nagekeken welke gidsen ze dekken). Ook oude dungeons kregen nieuwe buit (G: "New"-items
bij FC, Icy Veins-changelog 19 okt "item revamps").

## 4. Drie voorbeelden (details en bron per regel in `dungeon_guide_sample.lua`)

Alle NPC-id's GEMETEN in Wowhead Forever (18 nov). Encounter-id's GEMETEN in DB2.

**The Deadmines** (Map 36): Rhahk'Zor 644, Miner Johnson 3586 (rare), Sneed 643 (+ Sneed's Shredder 642), Gilnid 1763,
Mr. Smite 646, Captain Greenskin 647, Edwin VanCleef 639, Cookie 645. Levels 19-21 (G, Wowhead).
- Voorbeeld: Mr. Smite stunt de hele groep op vaste momenten en wisselt dan van wapen. Tip: twee verstopte Blackguards
  vechten mee; die eerst. (2 bronnen: Icy Veins + Mobalytics.)
- Items: Cruel Barb 5191 (melee, zwaard), Smite's Mighty Hammer 7230 (strength, +11 Str), Cape of the Brotherhood 5193
  (agility). Stats G (Wowhead); baas G (FC + Icy Veins + Mobalytics); rol A.

**Wailing Caverns** (Map 43): Lady Anacondra 3671, Lord Cobrahn 3669, Kresh 3653, Lord Pythas 3670, Skum 3674,
Lord Serpentis 3673, Verdan the Everliving 5775, Mutanus the Devourer 3654, Deviate Faerie Dragon 5912 (rare).
- Voorbeeld: de vier druid-bazen slapen iemand in; onderbreek die spell eerst. Mutanus komt pas na de vier Lords en
  het escorteren van de Disciple of Naralex. (2 bronnen.)
- Items: Venomstrike 6469 (hunter, boog), Living Root 6631 (healer, staf), Mutant Scale Breastplate 6627 (strength, mail).

**Shadowfang Keep** (Map 33): Rethilgore 3914, Razorclaw the Butcher 3886, Baron Silverlaine 3887, Commander Springvale
4278, Odo the Blindwatcher 4279, Fenrus the Devourer 4274, Wolf Master Nandos 3927, Archmage Arugal 4275, Deathsworn
Captain 3872 (rare).
- Voorbeeld: Silverlaine's vloek maakt healen op iemand 75% zwakker; haal hem weg. Arugal: ga om de hoek staan, dan
  moet hij naar je toe. (2 bronnen.)
- Items: Meteor Shard 6220 (melee, dolk), Robes of Arugal 6324 (cloth caster), Worgenbane Talisman 273643 (nieuw;
  Wowhead: "Dropped by: Commander Springvale 32.10%").

Per baas: 18 van de 26 bazen hebben minstens een regel uit 2 bronnen; 8 leunen op 1 bron (gemarkeerd "1x"): Miner
Johnson, Greenskin, VanCleef, Cookie, Deviate Faerie Dragon, Fenrus, Nandos, Deathsworn Captain.

## 5. Spelwoorden per taal

- Bazennamen: `run gamedata db2 DungeonEncounter ... --game forever --locale deDE` werkt (G: Kapitän Grünhaut,
  Handlanger Pein, Krümel, Edwin van Cleef, Minenarbeiter Johnson, Plünderung). Een opdracht per taal haalt alle ~241
  bazen tegelijk: 6 opdrachten, een paar minuten (A).
- Rares zonder rij (Sneed's Shredder, Faerie Dragon, Deathsworn Captain, ...): Wowhead-tooltip met `--locale`, per NPC.
  Niet getest (A: zelfde gereedschap).
- Dungeonnamen: MH gebruikt al `GetRealZoneText(map)` (client-naam, G in code).
- Itemnamen en -stats: uit de client zelf (itemlink/tooltip), dus geen vertaalwerk (A).
- Het echte werk: de eigen zinnen (1-3 regels + tip per baas). ~241 bazen x ~3 korte zinnen = ~700 strings, x 5 talen
  (de/fr/es/pt/it) via mh-writer, nl met de hand (A).
- Spellnamen: id's niet gemeten. Advies: in gewone woorden ("hij vervloekt iemand"), zonder spellnamen; dan geldt de
  regel "naam uit de client" niet en hoeven we niets per taal op te meten (A).

## 6. Andere addons in `_forever_` (alleen kandidaten, niets kopiëren)

- **ForeverDungeonJournal** ("DungeonJournal" 2.0.11, Exehn): volledige gids met buit, droprates, quests, routes, 10
  talen. Geen licentiebestand in de hoofdmap, geen X-License in de toc (G) = all rights reserved. Alleen lezen.
- **Spoken_Bosses** (3.10.0, Nucabe): bazen + verhalen, 9 talen; toc: "Addon code MIT. Boss names are Blizzard's" (G).
  Data/Creatures.lua heeft NPC- en display-id's per baas. Goede kandidatenbron (Rob vertrouwt Spoken, 16 nov).
- **HandyNotes_DungeonRaidLocations-Forever** (MIT): ingangen; MH gebruikt die al.
- Details (+ EncounterDetails), ZygorGuidesViewerForever, ForeverLevelingGuide: registreren o.a. ENCOUNTER_START/END
  (G: grep), maar geen bazengids gecontroleerd.

## 7. Drie opties

| | A klein | B + buit | C volledig |
|---|---|---|---|
| Wat | per baas: naam (DB2, 7 talen), NPC-id, 1 tip | A + 2-3 opvallende items per dungeon, met rol (tank/heal/melee/caster/hunter) | per baas 1-3 regels mechaniek + tip + hele buitlijst + trash-buit |
| Omvang | 28 instances, ~241 bazen (+ ~10 rares), ~250 tips | + ~60-90 items | + ~700-900 items (A: ~3-4 per baas) |
| Werk | bazenlijst bijna automatisch; tips: onderzoek in porties van 5-8 dungeons; vertalen ~250 zinnen | + per dungeon 2 bronnen voor de buit; namen/stats uit de client | veel: buit verandert met hotfixes, moet blijvend bijgehouden |
| Risico | 9 nieuwe dungeons hebben dunne bronnen | buit van okt (vóór launch) kan veranderd zijn | botst met Robs "niet het DungeonJournal-addon nabouwen"; dubbel werk naast FDJ |

**Advies: A+ = A met 1-3 korte "doet"-regels, plus de 2-3 items van B.** Begin met de 9 dungeons tot level 32 (RFC,
Hall of Thanes, Ruins of Lordaeron, WC, DM, SFK, Stockade, BFD, Excavation Site: 55 encounter-rijen; rijen G, de
keuze welke BFD-rijen meetellen A). De vorm staat in
het voorbeeldbestand. Toon het in het Dungeons-tabblad (uitklappen per dungeon), en optioneel een klein paneel als je de
dungeon binnenloopt (`CurrentDungeon()` bestaat al). Geen drop-kansen. Spelers kiezen via een schakelaar of het paneel
vanzelf opent.

## Wat ik NIET kon meten

- Of `EJ_*` / `C_EncounterJournal` in Forever data teruggeeft (alleen in het spel; testregel bij 2).
- Of `ENCOUNTER_START` in Forever vuurt met de DungeonEncounter-id (andere Forever-addons registreren het; geen bewijs).
- Spell-id's van baas-vaardigheden (geen enkele gemeten).
- Buit na de launch (4 nov): FC is van 3/6 okt, Icy Veins van 19 okt. Alleen Wowhead-tooltips zijn van vandaag.
- Wie welk item mag dragen in Forever (rol is A uit stats; de client beslist).
- Fenrus' voidwalkers: wanneer ze komen (bronnen niet eens / 1 bron).
- Mobalytics DM-tekst brak af na Mr. Smite; Warcraft Tavern na Fenrus. Dus Greenskin, VanCleef, Cookie, Nandos: 1 bron.
- NPC-id's van de bazen in de 9 nieuwe dungeons (niet opgevraagd; FDJ meldt dat Lordaeron Captain geen vaste id had).
- Welke taalclients Forever heeft.
- Wowhead www-pagina's (tab "Abilities"): niet geprobeerd (403/CAPTCHA).
