# QuestieDB live lezen ("quest A") — onderzoek + voorstel, 23 nov 2026

Opdracht: Rob via Sparring 23-11, letterlijk *"quest a"*. MH leest QuestieDB alleen tijdens het spelen, als de speler het
heeft. Wij leveren niets mee: geen QuestieDB-data in MH-bestanden, ook niet in docs of kladjes. Dit bestand beschrijft
alleen hoe de API werkt, geen inhoud. Nog niets gebouwd.

## 1. Hoe QuestieDB zijn data aanbiedt (GEMETEN in de bestanden, `_forever_\Interface\AddOns\QuestieDB`)

- Versie 1.1.4, `## X-Contract-Version: 4`, `## X-Mode: baked`, `## X-Flavor: Forever`. Alleen een Forever-toc
  (`## Interface: 16001`). Geen LoadOnDemand-regel: laadt gewoon mee bij het inloggen.
- De data staat **in de toc zelf**, als `## X-…`-metadata (de toc is 18,8 MB). Per regel één quest, NPC, item of object,
  gecodeerd (Base64 + CBOR, via `C_EncodingUtil`). 6080 quests en 15563 NPC's (de `-S`-rijen geteld).
- Bij het laden wordt alleen de lijst met id's uitgepakt. Een veld wordt pas uitgepakt als iemand erom vraagt
  (`src/read/baked.lua`). Een MH-vraag kost dus alleen de rijen die MH zelf opvraagt.
- Publieke ingang (`src/api.lua`): globals `LibQuestieDB`, `QuestDB`, `NpcDB`, `ItemDB`, `ObjectDB`.
  `QuestDB.Get(id, "finishedBy")`, `NpcDB.Get(id, "spawns")`, `.Exists(id)`, en `LibQuestieDB.RequireContract(n)`, dat
  een duidelijke fout geeft bij een verkeerde versie. Velden (namen, geen inhoud): quest: startedBy, finishedBy,
  requiredLevel, requiredClasses/Races, objectives, preQuestSingle/Group, nextQuestInChain, breadcrumbs, zoneOrSort.
  NPC: spawns (per zone), waypoints, questStarts, questEnds, subName, npcFlags.
- ⚠️ Plekken staan per **AreaID**, niet per kaart-id (uiMapId). Er is een omrekening Era → Forever voor 4 zones
  (Mulgore, Eastern Plaguelands, Redridge, Stormwind), en die wordt "nooit automatisch toegepast". Of de opgeslagen
  plekken al Forever zijn of nog Era: **NIET GEMETEN**. Dat moet eerst in het spel, met een NPC waarvan Rob de plek kent.
- Laadtijd en geheugen in het spel: **NIET GEMETEN**. Die kosten heeft de speler toch al zodra hij QuestieDB heeft; MH
  voegt alleen zijn eigen vragen toe.
- Bij Rob: QuestieDB staat sinds vandaag (bestand 23 nov 11:23) in de map, maar nog in geen enkele `AddOns.txt`
  (MidnightHelper wel, in 23 characters: positieve controle). Hij heeft het dus nog niet geladen. Questie zelf en WalkMap
  zijn niet geïnstalleerd.

## 2. Wat MH er concreet mee kan (waar MH nu zijn data vandaan haalt)

| MH-onderdeel | nu | wat QuestieDB live kan toevoegen |
|---|---|---|
| Class-quests (`ForeverClassQuests.lua`) | eigen lijst: Zygor, Wowhead, Spoken | gever/inleveraar + plek als MH er een mist; volgorde-check |
| Dungeon-quests (`ForeverDungeonQuestsData.lua`) | Zygor-id's | wie geeft de quest, waar; welke quest eerst |
| Trainers/verkopers (`ForeverTrainerData`, `LivePlace`) | Rob > HandyNotes > lijst | nog een stap in die rij, alleen als de rest zwijgt |
| **Quest in je log** (nieuw) | MH weet alleen je eigen log | "waar lever ik in": inleveraar + pijl |
| **"Waarom krijg ik deze quest niet?"** (nieuw) | niets | voorganger-quests en level |

## 3. Risico's

- **Taint**: AFGELEID laag. Het is alleen lezen van gewone tabellen en `C_AddOns.GetAddOnMetadata`, geen beveiligde
  frames. In een gevecht lezen we niets (zelfde regel als elders).
- **Updates**: QuestieDB wordt vaak bijgewerkt. Eerst `RequireContract(4)`. Klopt dat niet: MH zwijgt en zegt waarom.
  Elke vraag zit in `pcall`, zodat een andere structuur nooit een Lua-fout bij de speler geeft.
- **Zwijgen met diagnose** (CLAUDE.md): `/mh questiedb` toont gevonden ja/nee, contract, leesmodus, aantal vragen en
  waarom het zweeg.
- **Plekken in de verkeerde kaartruimte** (zie 1): zonder meting kan de pijl verkeerd wijzen. In de MH-code staat al
  dat Stormwind twee sets coördinaten kent.
- **Licentie**: alleen lezen tijdens het spelen; niets in onze bestanden. Er gaat dus niets van hen mee in onze zip.

## 4. Naamsvermelding

Questie-naam en -logo niet gebruiken (hun LICENSE.md zegt dat ook). Wel een zin als *"Uses QuestieDB if you have it
installed"* in README/THIRD_PARTY, en in `/mh questiedb`. Geen optionele afhankelijkheid in de toc nodig: MH kijkt pas
na het inloggen of `LibQuestieDB` bestaat.

## 5. Gevonden tijdens dit onderzoek: Questie zit al in MH (raakt de nieuwe regel)

GEMETEN met grep: `ForeverClassQuests.lua:243` zegt dat plekken die niet van Zygor komen "Wowhead/Questie pins" zijn, en
r.362 dat de Dreadsteed-volgorde AFGELEID is "from the Questie Forever data". `THIRD_PARTY.txt:168` noemt Questie (GPL)
als bron. Daarnaast noemen 16 docs Questie (vóór dit bestand). Niet nagelopen welke waarden precies van Questie komen. Niets gewijzigd: dat
is een aparte keuze voor Rob.

## 6. Opties

- **A. Eerst meten** (klein): alleen `/mh questiedb`. Kijkt of het er is, controleert het contract, meet de tijd van
  50 vragen en vergelijkt één NPC-plek met een plek die Rob kent. Spelers zien niets.
- **B. Aanvullen waar MH zwijgt** (na A): MH's eigen data wint altijd. QuestieDB vult alleen gaten: inleveraar van een
  quest in je log + pijl, gever/plek bij class- en dungeon-quests, en een extra stap in de `LivePlace`-rij. Met een
  schakelaar (standaard aan als het geïnstalleerd is).
- **C. Groot**: een eigen questzoeker (welke quests zijn er bij jou in de buurt). Dat is wat Questie en WalkMap al doen.
- **D. Niet doen.**

**Advies: A, dan B.** A is klein en vertelt of de plekken kloppen. B geeft de meeste winst zonder dat MH iets meelevert.
C niet: dat doen andere addons al. Los daarvan kiest Rob wat er met punt 5 gebeurt (nalopen en vervangen, of laten).
