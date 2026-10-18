# Overdracht 18 okt 2026 — routezoeker (TravelGraph.lua)

Van: de cloud-chat van vanochtend (Rob: "kan je dit gewoon doorgeven aan de Claude Code bouwchat").
Aanleiding: Rob vroeg wat Shortest Path Forever (WoW: Forever-addon van cjber, GPL-3) doet en of MH er iets aan
heeft. Antwoord: de code niet (GPL vs MIT, alleen Forever-data), het idee wel: Dijkstra over de reisdata die MH al
heeft. Rob: "Ja doe maar, het moet wel iets opleveren en duidelijk een verbetering zijn."

## Wat er ligt

`docs/TRAVELGRAPH_2026-10-18.patch` — één commit, gemaakt op main **e696f64**, past schoon (`git am --3way`
gecontroleerd op e696f64). 13 bestanden, +1034/−3. Nog **niet** gecommit, niet gepusht.

Toepassen:

```
git am --3way docs/TRAVELGRAPH_2026-10-18.patch
lua5.1 tools/travel_harness/test.lua      # verwacht: 28 passed, 0 failed
python tools/lua_syntax_check.py
python tools/lint_addon.py                # verwacht: HARD 0
```

Daarna mogen `docs/TRAVELGRAPH_2026-10-18.patch` en dit bestand weg (of dit bestand houden als notitie).

## Wat het doet

- **Nieuw `Modules/Travel/TravelGraph.lua`** (in de .toc na TravelPlaces.lua): Dijkstra over MOUNTRUN_HUBS
  (via `ns.MountRunHubSteps`, dus quest-gate Isle of Thunder en stapteksten van de Mount run), MOUNTRUN_HOME,
  MIDNIGHT_PORTALS (alleen `MHPortalUsable`), mage-teleports en Hearthstone/toys met exact de regels van
  `Travel.WayHome` (fail closed). **Geen nieuwe coördinaten.**
  - Een "plek" = map + waar je staat (aankomst = het portaal terug op die map). Zonder dat won een mage-teleport
    (onbekende landingsplek) van de portal room die naast het volgende portaal uitkomt: 109 s i.p.v. 87 s.
  - Kosten zijn **AFGELEID** (`G.COST`), alleen om routes te rangschikken. Hearthstone moet ≥ 60 s schelen.
  - Overland vliegen alleen waar `ns.IsCrossContinentTarget` "zelfde continent" zegt; **nooit binnen Midnight**
    (canvas 2576).
  - `LEG_BEACON` uitgesloten: de staptekst gaat over Antorus en de Vindicaar-console staat niet in de data.
- **`TravelPlan.lua`**: vraagt de zoeker alleen als de eigen regels **geen portaal op je map** vonden **én** het doel
  **buiten Midnight** ligt (region 0). Midnight-routes ongewijzigd (WayHome, door Rob getest 16-17 okt).
  Ander continent en niets gevonden → nieuw `PLAN_NO_ROUTE` i.p.v. het foute `PLAN_ALREADY_THERE`.
  `/mh plan` print een schatting (`PLAN_ESTIMATE_FMT`).
- **`TravelRoute.lua`**: `FlightLeg` geeft geen vluchtmeester meer naar een ander continent (alleen als de client
  beide continenten kan lezen en ze verschillen; onleesbaar = oud gedrag). Planstappen geven `board`
  (boot/zeppelin/tram) en `viaNear` (portal-room-deur) door aan de route runner.
- **Locales**: `PLAN_NO_ROUTE` en `PLAN_ESTIMATE_FMT` in enUS, nlNL, ruRU en via Translations2026 (de/fr/es/pt/it).
  Zelf vertaald, niet door een native speaker gecontroleerd.
- **`tools/travel_harness/`**: headless Lua 5.1 harness (laadt de echte MH-bestanden met gestubde client) +
  28 checks. ⚠️ `world.lua` is een FIXTURE: echte uiMap-ids, verzonnen geometrie. Het bewijst de logica, niet
  welke route in-game precies wint.

## Gemeten in de harness (oud → nieuw)

| Doel (MH-data) | Was | Nu |
|---|---|---|
| Algeth'ar Academy vanuit Silvermoon | "already there", pijl naar Sanctum of Light-vluchtmeester | portal room → Orgrimmar → Valdrakken |
| Pit of Saron vanuit Silvermoon / Dornogal | idem / vluchtmeester Dornogal | → Orgrimmar → Dalaran (Northrend) |
| Skyreach (H en A) | idem | → hoofdstad → Draenor-portaal → Tanaan |
| Seat of the Triumvirate | "already there" | `PLAN_NO_ROUTE` (eerlijk; Vindicaar-console ontbreekt) |
| Hyjal-pin vanuit Orgrimmar | "fly to Nordrassil" | portaal naar Hyjal |
| Midnight-doelen, zelfde continent, al ter plaatse | — | **identiek** aan voorheen |

Zoektijd in gewone Lua 5.1: ~14 ms per plan.

## Test in-game (/reload) — nog door Rob te doen

1. Silvermoon → M+-dungeon Algeth'ar "route": pijl naar de portal room, niet de vluchtmeester.
2. `/mh plan` op Pit of Saron: 3 stappen + "Ongeveer N min".
3. Orgrimmar → pin in Mount Hyjal: pijl naar het Hyjal-portaal.
4. Midnight-delve vanuit Valdrakken: gedrag zoals altijd.
5. Optioneel: `ns.Travel.Graph.Print(map, x, y)` bestaat (hops + bron per hop) maar heeft nog geen slash-commando;
   aan `/mh travel` hangen als dat handig is.

## Open / vervolg

- Seat of the Triumvirate blijft zonder route tot de Vindicaar-console + weg naar Eredath gemeten zijn.
- Volgende winst: M+-teleportspreuken ("Path of …") als startactie — spell-ids eerst in-game meten.
- Changelog-voorstel: *"Reizen: routes naar de oude M+-dungeons en andere plekken buiten Midnight via portalen,
  met een geschatte reistijd in /mh plan."*
