# Broker_MidnightEvents — analyse & absorptieplan

**Doel (Rob):** zo min mogelijk losse addons; alles via Midnight Helper.
Dit document legt vast wat `Broker_MidnightEvents` doet, wat wij ervan kunnen
overnemen (aanpak + feitelijke IDs/API's, **geen code**), en in welke volgorde
we de ontbrekende stukken in MidnightHelper bouwen zodat de losse broker
uiteindelijk uit kan.

Bron: `..\Broker_MidnightEvents\` (artherion77, v1.0.3, 2026-06-13).
Analyse: Claude, 13 juni 2026.

---

## ⚖️ Licentie — eerst lezen

Broker_MidnightEvents staat onder **GPL-2.0** (copyleft). MidnightHelper is
**MIT**. GPL-code in een MIT-project trekken is een licentieconflict. Daarom:

- ✅ Overnemen: **API-oppervlak** (welke functies bestaan), **feitelijke IDs**
  (quest-/achievement-/widget-IDs — feiten, geen auteursrecht), en de
  **techniek/aanpak** in eigen woorden + eigen implementatie.
- ❌ Niet doen: regels Lua kopiëren/plakken, hun tabellen 1-op-1 overnemen,
  hun teksten hergebruiken.

Zelfde posture als bij RitualAlert. Never-lie blijft leidend: een feit pas in de
addon nadat Rob het in-game heeft bevestigd of het web-geverifieerd is.

---

## 🔧 Taint-ontwerpregel (verplicht zodra we live-timers bouwen)

Onze huidige code is **schoon**: we lezen geen `C_UIWidgetManager`
StatusBar-widgets of `C_EventScheduler`-timestamps. Onze weekly-% loopt via
`GetQuestProgressBarPercent` (pcall + `math.floor`), dat in 12.x geen secret
oplevert, en gaat naar eigen FontStrings — niet naar de gedeelde GameTooltip.

Maar het 12.x protected-data-model behandelt **widget `barValue`/`barMax` en
scheduler-timestamps als secret**. Rekenen met die waarden taint je
execution-context; schrijf je daarna naar de gedeelde `GameTooltip` of raak je
Blizzard-frame-state aan, dan propageert de taint en breekt onverwante
Blizzard-UI ("attempt to compare a secret number value"). Regels die we
**moeten** volgen zodra we event-timers/voortgangsbalken bouwen:

1. **Eén dedicated ticker** (bv. `C_Timer.NewTicker(2, ...)`) doet ál het
   rekenwerk op secret widget-waarden en schrijft alleen naar **platte Lua-
   tabellen** (bv. `progressCache[poiID] = percent`).
2. **Render- en click-paden lezen alleen die tabellen** — nooit zelf
   widget-arithmetic in een tooltip-/OnClick-handler.
3. **Eigen `GameTooltipTemplate`-frame** voor onze hover-UI; nooit naar de
   gedeelde `GameTooltip` schrijven vanuit een mogelijk-getainte context.
4. **Geen custom velden op Blizzard-frames** — onze state in eigen tabellen of
   weak side-tables op frame-key.

(Broker doet dit in Core.lua r75-160 / AltsPanel.lua r50-60; alleen ter
referentie — we implementeren het zelf.)

---

## 📚 Geverifieerd API-/ID-naslag (door Broker gebruikt, bruikbaar voor ons)

> Status hieronder = "in Broker waargenomen". Vóór gebruik in onze addon: door
> Rob in-game laten bevestigen (never-lie).

### Event scheduler (de grootste gap voor ons)
- `C_EventScheduler.GetOngoingEvents()` — nu actieve events.
- `C_EventScheduler.GetScheduledEvents()` — komende fires (volgorde = Blizzards
  events-paneel).
- `C_EventScheduler.GetEventUiMapID(...)` → **directe route naar de open
  Val-uiMapID** uit PTR_12.0.7_DATA.md.
- `C_EventScheduler.GetEventZoneName(...)`, `GetActiveContinentName()`.
- `C_EventScheduler.HasData()` / `CanShowEvents()` / `RequestEvents()` —
  data-readiness + async refresh.

### Event-/delve-POI's
- `C_AreaPoiInfo.GetEventsForMap(uiMapID)`, `GetDelvesForMap(uiMapID)`,
  `GetAreaPOIForMap(uiMapID)`.
- `C_AreaPoiInfo.GetAreaPOIInfo(uiMapID, poiID)`,
  `IsAreaPOITimed(...)`, `GetAreaPOISecondsLeft(...)` — countdown-bron.

### Voortgangsbalken (secret → via ticker, zie taintregel)
- `C_UIWidgetManager.GetAllWidgetsBySetID(setID)` → filter `widgetType == 2`
  (StatusBar), dan `GetStatusBarWidgetVisualizationInfo(widgetID)` →
  `barValue`/`barMax`.
- Bountiful-delve **story-variant**: per delve-POI één `TextWithState`-widget
  (`widgetType == 8`) waarvan de tekst begint met `"Story Variant:"`.

### Concrete IDs (feiten)
- Story-variant-achievements: **criteria 61724–61733** (per bountiful delve;
  groene ✓ = criterion al behaald).
- Void Incursion voortgang: widget-set **8718 → 2042**; Zul'Aman variant **8717**.
- `C_ScenarioInfo.GetCriteriaInfo(...)` — relevant voor onze RitualBossCoach-
  trigger en de Void-Rift-scenariovraag.

### Diagnose-aanpak (lijkt op onze spy)
- Broker dumpt naar SavedVariables via `/mediag` (+ `/mesched`, `/mepois`,
  `/mewidget <setID>`). Idee: onze `/mh ritualspy` uitbreiden met een
  scheduler-/widget-dump in hetzelfde format.

---

## 🗺️ Feature-gap-map (Broker vs. MidnightHelper)

| Broker-feature | Wij | Notitie |
|---|---|---|
| Per-char weekly checklist | ✅ `AccountWeeklyChecklist` | Mappen welke rijen we missen (zie ⬇️). |
| Alts-overzicht (grid) | ✅ `AltOverview` | Vergelijkbare scope. |
| World Boss-rij | ✅ `WorldBoss` (`GetQuestTimeLeftMinutes`) | — |
| Void Assault: actieve zone + weekly% | ✅ `VoidAssaults` | — |
| Showdowns (12.0.7) | ✅ `Showdowns` | — |
| Bountiful-delve **story-variant** | ⚠️ deels | We detecteren de story (`DelveBossShowcase`, via `C_ScenarioInfo.GetCriteriaInfo`) voor de boss-showcase, maar tonen **geen** per-char achievement-✓ (criteria 61724-61733). → toevoegen indien gewenst. |
| Vault-voortgang | ✅ `VaultAdvisor` | — |
| LDB-broker + minimapknop | ✅ `Broker.lua` | **Coexistence checken** (beide LDB). |
| **Wereld-event-timers (Now / Upcoming 24h)** | ❌ **GAP** | `C_EventScheduler` + `GetEventsForMap`; bestaat niet bij ons. |
| **Live event-voortgang (Void Incursion % e.d.)** | ❌ **GAP** | `C_UIWidgetManager` via ticker (taintregel). |
| Abundant Offerings | ❌ **GAP** | questID **89507** — niet in onze code. |
| A Nightmarish Task | ❌ **GAP** | questID **94446** — niet in onze code. |
| Lost Legends | ❌ **GAP** | questID **89268** — niet in onze code. |
| Gnawing Curiosity | ❌ **GAP** | questID **93784** — niet in onze code. |
| Arcantina (patron-voortgang) | ❌ **GAP** | questID **93767** — niet in onze code. |
| Voidforge (Decimus: Voidcores/Nilhammer) | ❓ in-game | geen quest-ID (widget-scrape) — in-game verifiëren. |
| Beacon of Hope (Nullaeus Cache) | ❓ in-game | loot-flag; in-game verifiëren. |
| Prey Hunts (per-tier x/4) | ❓ in-game | in-game verifiëren. |
| Saltheril's Soiree / Bonus Event / Liadrin-pick | deels (Liadrin ✅) | Soiree/Bonus Event-picks verifiëren. |

> **Bevestigde gaps (13 jun, code-vergelijking):** Abundant Offerings (89507),
> A Nightmarish Task (94446), Lost Legends (89268), Gnawing Curiosity (93784),
> Arcantina (93767), én de delve-story-✓ (61724-61733).
> ❓ = geen quest-ID in Broker (widget/loot-flag) → Rob bevestigt in-game.

---

## 🏗️ Bouwvolgorde (voorstel)

**Fase A — Event-timer-fundament (grootste meerwaarde + lost PTR-data op).**
1. ✅ **GEBOUWD (13 jun)** — `Modules/EventScheduler.lua`: taint-veilige
   ticker (5s) leest `GetOngoingEvents`/`GetScheduledEvents` + POI-naam/zone/
   `uiMapID`/`SecondsLeft` in platte tabellen. Alle secret-arithmetic in de
   ticker, elk event in een pcall. Getters: `ns.GetOngoingWorldEvents()`,
   `ns.GetUpcomingWorldEvents()`, `ns.GetWorldEventsLastScan()`. In TOC na
   VoidAssaults. Lua-syntax host-geverifieerd (luaparser).
2. ✅ **GEBOUWD (13 jun)** — `/mh eventspy` (Core.lua): forceert een scan,
   print naam · zone · **uiMapID** · resttijd voor NU/KOMT-eraan, en bewaart
   een snapshot in `MidnightHelperDB.eventSpy` (blijft na /reload). Bedoeld om
   o.a. de **Val-uiMapID** te oogsten voor PTR_12.0.7_DATA.md.
   → **Test (Rob):** `/reload`, ga bij Midnight-event-content staan, `/mh
   eventspy`, lees de uiMap-kolom af. Werkt op live (12.0.5) én PTR.
3. ✅ **GEBOUWD (13 jun)** — "Nu / Komt eraan"-blok bovenaan de Void &
   Rituals-tab (status-view), `Modules/WorldContent.lua`. Header + 8-regel-pool,
   read-only uit `ns.GetOngoingWorldEvents()/GetUpcomingWorldEvents()`; lopende
   events goud (naam — zone), geplande gedimd (naam (zone) — over tijd, via
   `ns.FormatEventDuration`). Verbergt zich als er geen data is (never-lie).
   Locale-keys in enUS + nlNL (rest valt terug op enUS). Syntax host-
   geverifieerd. → **Test (Rob):** `/reload`, open Void & Rituals → "Deze week".
   Sluit aan op het **Void Rifts-idee** in TOMORROW.md.
4. ✅ **GEBOUWD (13 jun)** — **lopende events zijn klikbaar**: een live event
   met bekende uiMapID + coords toont een ▸-pijltje en zet bij klik een
   waypoint via de bestaande `ns.AddSmartTomTomWay` (TomTom of Blizzard +
   reisadvies, zelfde keten als de site-knoppen). Coords komen uit
   `info.position` (EventScheduler `posXY`, 0-100, gelaunderd). Geplande events
   = platte tekst (nog geen coords). push/Relayout uitgebreid met kleine
   regel-knophoogte.

5. ✅ **GEBOUWD (13 jun)** — **eigen "Events"-tab** (`Modules/EventsPanel.lua`):
   alle wereld-events los van Void & Rituals (dat blijft puur Ritual+Void) en
   Home. Twee secties (Nu bezig / Komt eraan), klikbare live-regels met route,
   hover-tooltips met uitleg + beloningen (EventInfoData), live mee-tikkend.
   Het A3-blok is uit WorldContent gehaald. Tab geregistreerd in UI.lua
   (TAB_DEFS + dispatch), locale TAB_EVENTS/EVENTS_SUBTITLE/EVENTS_NONE.
6. ✅ **GEBOUWD (13 jun)** — **event-info-laag** (`Modules/EventInfoData.lua`):
   per event "wat is dit / wat levert het op", op areaPoiID. Nu: Stormarion
   Assault (8419) + Legends of the Haranir (8423), web-geverifieerd.

**Volgende kandidaten (uit Robs vragen, 13 jun):**
- **Event-info-laag**: korte "wat is dit / wat levert het op" per event
  (geverifieerd via Wowhead/Icy Veins — zie SESSION_NOTES bronnen). Lost ook
  de generieke "Event in <zone>" op door bekende events te benoemen.
- ✅ **GEBOUWD (14 jun) — Weekly-status per event**: de Events-tab toont per
  event met bekende weekly een gekleurde tag (groen "weekly gedaan" / amber
  "inleveren!" / blauw "bezig" / grijs "beschikbaar") + een regel in de hover.
  Techniek uit Kaliel's Tracker: `IsQuestFlaggedCompleted` (gedaan) +
  `GetLogIndexForQuestID`/`IsComplete` (turn-in vs bezig), pcall-guarded in
  `ns.GetWeeklyQuestStatus`. Quest-koppeling in EVENT_INFO: Stormarion 8419 →
  "Stand Your Ground" 94581, Haranir 8423 → "Lost Legends" 89268 (live 12.0.5).
  Meer events koppelen zodra hun areaPoiID + weekly-quest zeker is.

**Fase B — Live voortgangsbalken.**
4. Ticker uitbreiden met `C_UIWidgetManager`-StatusBar-reads (Void Incursion
   8718→2042 etc.) → percent in de tabel; render toont balk/percentage.

**Fase C — Ontbrekende weekly-rijen.**
5. Op basis van Robs in-game gap-lijst: de echt ontbrekende rijen toevoegen
   (kandidaten: Voidforge/Decimus, Beacon of Hope, Arcantina, Prey Hunts,
   Soiree/Bonus Event). Elk pas na ID-bevestiging.

**Fase D — Coexistence → uitfaseren.**
6. Checken dat onze `Broker.lua` en Brokers LDB-feed niet botsen zolang beide
   draaien.
7. Zodra A-C dekken wat Rob dagelijks uit Broker haalt: Broker_MidnightEvents
   kan uit. Eén addon minder. 🎯

---

## ✅ Direct te doen (klein, nu mogelijk)
- [ ] In-game: Rob vergelijkt onze weekly-checklist met Brokers tooltip →
      definitieve gap-lijst (vult de ❓-rijen hierboven in).
- [ ] Verifiëren of we de delve-story-✓ (criteria 61724-61733) al tonen.
- [ ] Fase A1+A2 bouwen (event-scheduler-spy) → Val-uiMapID oogsten.
