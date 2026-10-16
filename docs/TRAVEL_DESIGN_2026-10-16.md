# Ontwerp: één centrale reismodule (Travel) — 16 okt 2026

Voorstel, nog niets gebouwd. Gebaseerd op `docs/TRAVEL_MAP_2026-10-16.md` (de kaart, "§" verwijst daarnaar).
Rob kiest; pas na zijn "ja" per fase wordt er iets verbouwd.

---

## 0. In gewone taal (voor Rob)

**Nu:** reizen zit in 12 bestanden. Vijf stukken code geven elk hun eigen antwoord op "hoe kom ik daar?", acht
stukken worden wakker bij elke zonewissel en duwen om de beurt aan de pijl, en dezelfde plek staat soms drie keer in
de code met andere getallen. Daarom ging het vandaag een paar keer mis (Honeydew, de Coiled Isle-deur).

**Straks:** één reismodule met vijf vaste onderdelen, elk met één taak:

| Onderdeel | Wat het doet | Vergelijk het met |
|---|---|---|
| **Kennisbank** | Alle portalen, deuren, hubs, terugportalen, hearthstones en toys op één plek, elk punt één keer, met bron | het atlasboek |
| **Kaartkennis** | "Waar sta ik, ligt A in B, hoe ver is het, ben ik er?" — één antwoord, één set drempels | de liniaal |
| **Planner** | Maakt de stappen: eerst naar huis (portaal / hearthstone / toy), dan portalen, deuren, vliegen, doel | de reisagent |
| **Routeloper** | Voert de stappen uit: één pijl, één eigenaar, gaat door bij elke zonewissel, stopt écht bij "stop" | de chauffeur |
| **Uitvoer** | TomTom, eigen pijl, Blizzard-pin, chatregels, knoppen (hearthstone, portaal, magiër) | het dashboard |

Elke knop in MH (delve, rare, schat, Codex-link, Silvermoon-kaart, Mount run …) vraagt dan hetzelfde: *"breng me
hierheen"*. Een verbetering (een nieuw portaal, een gemeten deur, een toy) werkt daarna meteen **overal**.

**Hoe:** in vijf fasen. Na elke fase test jij; pas dan de volgende. Oude functies blijven eerst bestaan als
"doorgeefluik", zodat er nooit iets in één keer omvalt.

---

## 1. Ontwerpregels

1. **Eén eigenaar van de pijl tegelijk.** Een route is één object met een eigenaar. Wie de pijl wil, vraagt hem aan
   de routeloper; niemand zet nog zelf een TomTom-pin of `ns.lastTarget` (§1a: 7 schrijvers, 9 wissers; §6: 5 bypasses).
2. **Eén antwoord op "hoe kom ik daar?".** De planner maakt één stappenlijst; chat, pijl, label en popup lezen díe
   lijst (§1b-1: nu 5 antwoorden, 3 hearthstone-modellen, de 75%-regel alleen in de pijl).
3. **Eén zonewissel-handler.** De routeloper luistert als enige naar ZONE_CHANGED*/PLAYER_ENTERING_WORLD en beslist in
   één keer: volgende stap, opnieuw plannen, of klaar (§5a: nu 8 handlers op 0 / 0,7 / 1,0 / 1,2 / 2,0 s).
4. **Eén set drempels, met eenheid.** "Bij de deur", "aangekomen", "route klaar" komen uit één tabel; afstand wordt op
   één manier gemeten (yards → kaartgrootte → kaartprocent, zoals TwoStepRoute's `DoorProximity`) en de drempel hoort
   bij de eenheid (§5c: nu elf drempels, van 15 yd tot 400 yd).
5. **Elk punt één keer, met bron en meetstatus.** Bij twee waarden wint: **door Rob gemeten > HandyNotes > Zygor >
   gids**. De verliezer wordt een commentaar, geen tweede rij (§3b: 5 conflicten).
6. **Stoppen stopt alles.** `/mh clear` en rechtsklik op de pijl beëindigen de route mét alle wachters, tikkers en
   knoppen (§1b-4: nu blijven de vliegstap- en deurwachter doorlopen).
7. **Fail closed blijft.** Wat niet te meten is (bind-locatie, quest-poort, toy-ID) wordt niet aangeboden, zoals nu.
8. **Geen gedragsverandering zonder test.** Elke fase heeft een lijstje "dit moet hetzelfde blijven" en "dit wordt
   anders" voor Rob, in `docs/TESTLIJST.md`.

---

## 2. De onderdelen (technisch)

Nieuwe map `Modules/Travel/`, vijf bestanden, laadvolgorde in de `.toc` vóór alle modules die routes zetten.

### 2.1 `TravelData.lua` — kennisbank
- Eén tabel `ns.Travel.nodes`: `{ id, kind, map, x, y, to, faction, requiresQuest, door, via, arrivesOn, zone,
  label|labelKey, source, measured }`. `kind` = portal / zeppelin / boat / tram / exit / tunnel / hole / ring / jump /
  teleport / beacon / door / gossip / hearth.
- Vult zich uit wat er nu is: `MIDNIGHT_PORTALS` (§3a, 18 rijen), `MOUNTRUN_HUBS` (38), `MOUNTRUN_HOME` (21),
  `MOUNTRUN_TO_SILVERMOON`, `LINKS` + `AMANI_HUBS`, de SMC-reispins. Hoofdsteden 84/85 en hub 2393 als constanten
  op één plek (§3b laatste rijen: nu ≥ 8 kopieën).
- `ns.Travel.hearth`: item 6948, `MOUNTRUN_HEARTH_TOYS`, `INN_AREAS_BY_ZONE`, de bind-check (nu `HearthstoneGoesTo`).
- Vliegpunten blijven in `FlightPointsData.lua` / `FlightNetworkData.lua` (die zijn al centraal); de kennisbank
  verwijst ernaar.
- De oude namen (`ns.MIDNIGHT_PORTALS`, `ns.MOUNTRUN_HUBS` …) blijven bestaan als **afgeleide lijst** zolang een oude
  aanroeper ze leest.

### 2.2 `TravelGeo.lua` — kaartkennis
- Eén ouder-keten-loper (nu 9, §7): `Travel.InMap(map, outer)`, `Travel.Continent(map)`, `Travel.Region(map)`,
  `Travel.HubSlice2576(x)`.
- Eén afstand: `Travel.Distance(map, x, y)` → `dist, limit, how` (yards / mapsize / percent), plus
  `Travel.WorldXY` met **Vector2D** (TwoStepRoute gebruikt nu een UiMapPoint — §1b-5; eerst Rob's `/dump` om te weten
  of dát de Silvermoon-nil verklaart).
- Eén drempeltabel `Travel.NEAR = { door = 22, step = 20, arrived = …, … }` per eenheid.

### 2.3 `TravelPlanner.lua` — planner
`Travel.Plan(target, opts)` → stappenlijst `{ kind, map, x, y, to, text, door, via, useItem, source }`. Volgorde:
1. Al op de doelkaart of in de keten eromheen → alleen de laatste stap(pen).
2. **Weg naar huis** (zoals de Mount run nu): portaal naar huis hier → hearthstone/toy (klaar + bind-check) →
   Midnight-zijzones via Silvermoon → dichtstbijzijnde hub op dit continent → "In Orgrimmar: …".
3. Hoofdstadportaal / Midnight-portaal (quest-poorten zoals `PortalUsable`).
4. Deuren: data-deur, live `C_Map.GetMapLinksForMap`, gossip-hop (Windcaller).
5. Vliegstap met netwerkcheck én de 75%-regel — dezelfde regel voor chat en pijl.
6. Doel; voor dungeons/raids de client-pin (`GetDungeonEntrancesForMap`) eerst.
Pure functie: leest, zet niets. `/mh plan` print precies dit.

### 2.4 `TravelRoute.lua` — routeloper
- `Travel.Start(target, { owner, label, managed })` → plant, toont stap 1, claimt de pijl.
- **Enige** zonewissel-handler (1 vertraging, ±0,7 s): `CurrentStep` zoals de Mount run (verste stap waar je staat
  of net doorheen kwam) → volgende stap, opnieuw plannen als je van de route af bent, of "klaar".
- Deur/`via`-overdracht en "sta je al binnen?" één keer (nu 3×, §1b-5), met `Travel.Distance`.
- Beheerde routes (rare, achievement, treasure, reset, delvechest, ritual) geven een callback `nextLead()`; de
  routeloper vraagt die bij aankomst. Hun eigen tikkers en zone-handlers (§5b) verdwijnen of worden alleen nog "lead
  gehaald?"-checks die `Travel.LeadReached()` aanroepen.
- `Travel.Stop(reason)` stopt alles: wachters, tikkers, knoppen, TomTom-pins, Blizzard-pin, eigen pijl, chatregel.

### 2.5 `TravelOutput.lua` — uitvoer
- Eén `Travel.Point(step)`: TomTom (crazy arrow, cleardistance), anders Blizzard-pin + SuperTrack, en de eigen pijl
  met kleur per eigenaar.
- Eén `Travel.Say(step, i, n)` voor chat — vervangt ROUTE_FINISHED, WAY_LEG_*, ARROW_CHAT_TRAVEL, de vlieghints.
- Secure knoppen op één plek: hearthstone/toy (nu 2 kopieën), portaal-focus, magiër-teleport/-portaal; allemaal met
  de gevecht-wachtrij van de Mount run-knop.
- Diagnose: `/mh travel` toont plan, huidige stap, eigenaar, gemeten afstand + methode; de oude commando's
  (`/mh arrow`, `/mh travelwhy`, `/mh portals`, `/mh plan`) blijven als alias.

---

## 3. Fasen (elk = eigen commit(s), Rob test tussendoor)

| Fase | Wat | Gedrag voor de speler | Test door Rob |
|---|---|---|---|
| **1. Kennisbank + kaartkennis** | TravelData + TravelGeo; oude tabellen worden afgeleid; dubbele punten opgelost volgens regel 5 | **gelijk**, behalve de 5 gecorrigeerde coördinaten | `/mh portals` hetzelfde; 5 punten in het spel |
| **2. Planner** | `Travel.Plan`; `BuildTravelPlan`, popup, vlieghints, pijl-label en Mount run lezen dezelfde lijst | chat, pijl en popup zeggen voortaan **hetzelfde**; hearthstone/toy overal | `/mh plan` naar 6 vaste doelen |
| **3. Routeloper** | `Travel.Start`; `AddSmartTomTomWay` wordt een doorgeefluik; `legRetry`, `pendingLeg`, `runZoneNavCheck`, TwoStep en de Mount run-handler gaan op in de ene handler | stappen + knoppen voor **elke** route, niet alleen de Mount run | delve vanuit Uldum, Coiled Isle-delve, Mount run, SMC-pin |
| **4. Beheerde routes** | rare, achievement, treasure, reset, delvechest, ritual via `nextLead()` | omwegen en terugkeren werken netjes; `/mh clear` stopt alles | elke routeknop één keer + `/mh clear` |
| **5. Opruimen** | dode code weg; `{WAY}`-links in `/mh plan` klikbaar; `arrivesOn` voor Voidstorm/Harandar-pins | kleine dingen | korte ronde |

Advies: **beta-tag na fase 3** (dan is het grote risico binnen), gewone release na fase 4.

---

## 4. Wat Rob moet kiezen

1. **Akkoord met de vijf onderdelen en de fasen?**
2. **Regel bij dubbele punten:** door Rob gemeten > HandyNotes > Zygor > gids — akkoord?
3. **Hearthstone/toy als stap voor álle routes** (niet alleen de Mount run)? Het blijft fail-closed: alleen als hij
   klaar is én naar de juiste plek gaat.
4. **Wanneer:** fase 1 nu meteen, of eerst de huidige stand op main als beta uitbrengen en testen?
5. **Eén meting vooraf (2 minuten):** in Silvermoon `/dump` met Vector2D tegenover UiMapPoint (§8 van de kaart) — dan
   weten we of "Silvermoon heeft geen wereldcoördinaten" waar is of een fout in onze aanroep.

## 5. Risico's (eerlijk)

- Het raakt **elke** pijl-knop: 48 aanroepen uit 27 modules (§1a). Daarom doorgeefluiken en fasen.
- TomTom en onze eigen pijl gedragen zich anders (§1b-2); beide moeten per fase getest.
- Combat lockdown en instances (geen popup, verborgen pijl) moeten in de routeloper zelf zitten, niet per module.
- Volgorde van WoW-events met dezelfde vertraging is niet gegarandeerd (§8) — daarom één handler.
