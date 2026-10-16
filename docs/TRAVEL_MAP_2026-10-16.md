# Reiskaart van de code — 16 okt 2026

Stap 0 voor een centrale `Travel.lua`: **meten, niet herbouwen.** Er is geen code veranderd.

- Gemaakt door een lees-agent op 16 okt 2026. Alleen `Modules/`, `UI.lua`, `Core.lua`, `Addons/`, `Locales/` (alleen grep) en de `.toc` gelezen.
- **Niets onder `docs/` gelezen** (vaste regel van deze agent). Status uit `NEXT_SESSION.md` zit er dus níet in; alles hieronder komt uit de code zelf.
- Elke bewering heeft een label:
  - **GEMETEN** = ik heb die `bestand:regel` gelezen (of een grep met positieve controle gedaan).
  - **AFGELEID** = mijn redenering uit de code. Niet in het spel getest.
- Een "0 aanroepers" staat er alleen als dezelfde grep in dezelfde run de definitie zelf wél vond (positieve controle).

---

## 0. In gewone taal (voor Rob)

- De reiscode zit niet op één plek. Hij zit verspreid over **12 bestanden**. Daarnaast zetten **27 andere onderdelen** zelf een route.
- Er zijn minstens **vijf plekken** die elk hun eigen antwoord geven op "hoe kom ik daar?". Die antwoorden volgen andere regels. Daarom kan de chat iets anders zeggen dan de pijl of het reisvenster.
- Bij elke zonewissel worden **acht stukjes code** wakker. Elk wacht een eigen tijd (0,7 tot 2 seconden). Daarnaast tikken **negen klokjes** door. Ze weten niets van elkaar en kunnen de pijl om de beurt verzetten. Alleen de Mount run heeft een uitzondering gekregen. Daar kwamen de fouten van vandaag vandaan.
- "Aangekomen" betekent op elke plek iets anders: van 15 meter tot 400 yard.
- Dezelfde plek staat soms twee of drie keer in de code, met andere getallen. Voorbeelden: het Coiled Isle-portaal, de portaalkamer in Silvermoon, de ingang van de Underbelly.
- `/mh clear` wist niet alles. Twee "wachters" blijven draaien en kunnen de pijl later terugzetten.
- Niets hiervan is vandaag veranderd. Dit is alleen de kaart.

---

## 1. Samenvatting

### 1a. Hoeveel

| Wat | Aantal | Status |
|---|---|---|
| Bestanden met kern-reiscode | 12: `TravelPlan.lua`, `DelveTipMarkup.lua`, `Delves.lua`, `NativeArrow.lua`, `TwoStepRoute.lua`, `MountRun.lua`, `MountRunData.lua`, `FlightPointsData.lua`, `FlightNetworkData.lua`, `FlightMapHint.lua`, `UI.lua` (Silvermoon-deel), `Core.lua` (waypoint/clear/slash) | GEMETEN |
| Functies + datatabellen in die 12, opgesomd in §2 | ± 130 | GEMETEN (geteld in §2) |
| Regels code die over reizen gaan | ± 5.000 (Delves.lua alleen al ± 1.700 van zijn 4.565) | AFGELEID (schatting per blok) |
| Modules die `ns.AddSmartTomTomWay` aanroepen | 27 bestanden, 48 aanroepen | GEMETEN (grep, commentaarregels eruit gehaald) |
| Plekken die `ns.lastTarget` een nieuwe tabel geven | 7 (Delves.lua:1839, UI.lua:1689, Core.lua:1913, FlightPointsData.lua:1171, Achievements.lua:1027, ResetRoutine.lua:1515, Rares.lua:2314) + MountRun.lua:272-273 past velden aan | GEMETEN |
| Plekken die `ns.lastTarget = nil` zetten | 9 (Achievements.lua:958, 1456; Delves.lua:3936; MountRun.lua:334; Profession.lua:1465; ResetRoutine.lua:1593; Rares.lua:1609; Core.lua:945, 987) | GEMETEN |
| Waarden van `ns._mhRouteOwner` | 8 echt gezet + 1 alleen in de stijltabel (`ritual`) | GEMETEN |
| Handlers op ZONE_CHANGED* / PLAYER_ENTERING_WORLD die routes raken | 8 | GEMETEN (§5) |
| Tikkers die routes raken | 9 (+1 die alleen de QuickBar tekent) | GEMETEN (§5) |
| Portaalrijen `MIDNIGHT_PORTALS` | 18 | GEMETEN (grep `toID = `) |
| Vliegpunten `FLIGHT_POINTS` | 649 rijen op 154 kaarten | GEMETEN (grep-telling) |
| Namen in `FLIGHT_NETWORK` | 129 | GEMETEN |
| Regels met `{WAY:` in `Locales/` | 160 | GEMETEN (grep-count, telt regels) |

### 1b. De vijf grootste problemen

**1. Vijf antwoorden op "hoe kom ik daar?", met verschillende regels.** GEMETEN dat ze bestaan; dat ze elkaar tegenspreken is per voorbeeld AFGELEID.
- **Reisplan** `ns.BuildTravelPlan` (TravelPlan.lua:202). Kiest een portaal op "mijn kaart of een kaart om mij heen" (TravelPlan.lua:309-315), met hub-terugval alleen als het doel in Midnight ligt (358-367). Heeft **geen Hearthstone-stap**.
- **Reisvenster (popup)**, en dat **twee keer bijna gelijk gekopieerd**: in `AddSmartTomTomWay` (Delves.lua:2001-2077) en in `ShowTravelAssistFor` (Delves.lua:2185-2259). Kiest portalen op `mapMatch and hubMatch` (exacte kaart, geen voorouder-kaart) en rekent afstand als `kaarteenheden × 45` (Delves.lua:2007, 2193). De code zegt zelf dat plan en popup "different rows of the same portal" kunnen kiezen (Delves.lua:2028-2029).
- **Vlieghint**, drie keer:
  - `ReportWaypointResult` (DelveTipMarkup.lua:196): alleen het vliegpunt bij het doel, géén netwerkcheck.
  - `ReportTravelHintForWaypoint` (DelveTipMarkup.lua:261): eerst plan-portaal, dan "vlieg van A naar B" mét netwerkcheck (`FlightPathExists`), zónder de 75%-regel.
  - `RouteFirstToFlightPoint` (DelveTipMarkup.lua:557): de echte pijl-stap, mét netwerkcheck én de regel "vliegen moet onder 75% van rechtstreeks blijven" (DelveTipMarkup.lua:750-786).
  - AFGELEID: chat kan dus "vlieg van A naar B" zeggen terwijl de pijl niet naar A gaat (de 75%-regel zit alleen in de pijl).
  - Een `{WAY}`-klik print beide chat-varianten: `SetMapWaypoint` roept `AddSmartTomTomWay` aan (die `ReportTravelHintForWaypoint` doet, Delves.lua:1914-1915) en daarna `ReportWaypointResult` (DelveTipMarkup.lua:885-886). GEMETEN pad; dubbele/afwijkende regels zijn AFGELEID.
- **Hearthstone**, drie modellen:
  - Popup: alleen item 6948, `HearthstoneGoesTo` + `HearthViaHubPortal` (Delves.lua:468, 1704, 2046-2048).
  - Pijl-label: `MHHearthRouteFor` kijkt alleen naar de cooldown van 6948, niet of je hem bij je hebt (Delves.lua:1723-1734; gebruikt in NativeArrow.lua:467-473).
  - Mount run: item-telling + 19 hearth-toys + dezelfde bind-check (MountRun.lua:382-418).
- **Chat versus label** in NativeArrow zelf: het label probeert eerst de Hearthstone-route (NativeArrow.lua:467-473), de chatregel `AnnounceUnreachable` niet (NativeArrow.lua:797-814). GEMETEN.
- De **Mount run** heeft een eigen routemodel voor de oude wereld (`MOUNTRUN_HUBS/HOME/TO_SILVERMOON`). Hij zet de andere helpers bewust stil via eigenaar `mountrun` en `noTravelAdvice` (MountRun.lua:270-275). GEMETEN.

**2. Concurrerende zone- en aankomst-handlers.** Acht handlers op dezelfde zonewissel, elk met een eigen vertraging (0 / 0,7 / 1,0 / 1,2 / 2,0 s), plus negen tikkers. Details in §5. GEMETEN.
- "Klaar" of "aangekomen" staat op minstens vier plekken, met elf verschillende drempels (§5b):
  - NativeArrow geeft de eigenaar vrij binnen 20 yd (NativeArrow.lua:1073-1081).
  - Delves zegt "route klaar" binnen **400 yd** of via `arrivesOn` (Delves.lua:1266, 1549-1565, 3918-3961).
  - MountRun stopt in een instance (MountRun.lua:524-530).
  - TwoStepRoute geeft op na 300 s (TwoStepRoute.lua:56, 219-221).
- **Of de 20-yd-vrijgave draait, hangt af van TomTom.** `Tick` stopt vóór die regel zodra TomTom stuurt (NativeArrow.lua:993-996 tegenover 1073). GEMETEN.
  - AFGELEID gevolg: met TomTom blijft eigenaar `waypoint`/`delve` staan tot iets anders hem wist. Zonder TomTom verdwijnt hij bij elke tussenstop: vliegmeester, deur.
- Alleen `mountrun` is uitgezonderd in de andere handlers: DelveTipMarkup.lua:481, 558, 838 en Delves.lua:3906. GEMETEN. De andere routes (rare, treasure, achievement, reset, delvechest) hebben zo'n uitzondering niet in `legRetry` en `runZoneNavCheck`. AFGELEID dat ze daar dus last van kunnen krijgen.

**3. Dubbele reiskennis met afwijkende coördinaten.** GEMETEN, volledige lijst in §3b. De belangrijkste:
- Coiled Isle-portaal in Silvermoon: `56.83/67.38` (Delves.lua:292, MountRunData.lua:373) tegenover `56.74/67.30` (UI.lua:1287).
- Underbelly-ingang: `45.19/11.15` (TravelPlan.lua:113-114, AchievementsData.lua:212/219/255) tegenover `47.30/11.20` (alle 7 talen in `Locales/Codex.lua`, o.a. regel 187).
- Amani Windcaller (Foothold): `50.03/61.93` (TravelPlan.lua:53) tegenover `49.99/61.93` (TravelPlan.lua:125-126). Zelfde NPC, zelfde bestand.
- Portaalkamer Silvermoon: pin `53.37/66.31` (UI.lua:1265) tegenover deur `53.30/66.24` en portalen `52.71/64.61` (A) en `52.24/65.28` (H) (MountRunData.lua:399).

**4. De levenscyclus lekt: stoppen bereikt niet alles, en eigenaarschap komt niet altijd terug.** GEMETEN dat de code zo is; de gevolgen zijn AFGELEID.
- `ns.ClearActiveRoute` (Core.lua:926-947) stopt achievement, rare, treasure en reset. Hij raakt **niet**:
  - de vliegstap-wachter `pendingLeg`/`legWatcher` (DelveTipMarkup.lua:370). `ns.ClearTravelLeg` (DelveTipMarkup.lua:385) heeft **0 aanroepers buiten het bestand**;
  - de deurwachter van TwoStepRoute (`active`, TwoStepRoute.lua:59). `StopSmcTwoStepRoute` wordt alleen aangeroepen in Delves.lua:3971;
  - de ritual-herstart na dood (RitualSites.lua:254-274, kijkt niet naar de eigenaar).
- AFGELEID: na `/mh clear` kan de vliegstap-wachter bij landen alsnog `AddSmartTomTomWay` doen (DelveTipMarkup.lua:543-548). De deurwachter kan bij de deur `SetSMCWaypointDirect` doen, want `Arrive` gaat door bij eigenaar `nil` (TwoStepRoute.lua:203-208). In beide gevallen staat de route terug.
- `AddSmartTomTomWay` neemt alleen de eigenaren `nil`/`waypoint`/`delve`/`mountrun` over (Delves.lua:1884-1889). Een gewone klik tijdens een `reset`-, `treasure`-, `achievement`-, `rare`- of `delvechest`-route laat die eigenaar staan. AFGELEID: hun eigen tikkers en zone-handlers zetten hun route dan later terug over de klik heen. Voorbeelden: ResetRoutine.lua:1741 na elke zonewissel; Profession.lua:1411-1412 elke 2 s `SetCrazyArrow`.
- **Treasure krijgt de pijl niet terug na een rare-omweg.**
  - Rares zet de eigenaar op `nil`, met als commentaar "their watcher reclaims on owner == nil" (Rares.lua:3208-3210).
  - Maar `_mhRouteOwner = "treasure"` wordt alléén gezet in Profession.lua:1466, bij de start. GEMETEN (grep).
  - AFGELEID: zonder TomTom zet `TreasureUpdateArrow` dan via `AddSmartTomTomWay` de eigenaar op `waypoint` (Profession.lua:1393). Daarna stopt hij zichzelf op Profession.lua:1322, en staat de schattenjacht stil.
- Achievements en ResetRoutine overschrijven `ns.lastTarget` ná `AddSmartTomTomWay` (Achievements.lua:1027, ResetRoutine.lua:1515). Als die aanroep een vliegstap zette, wijst TomTom naar de vliegmeester en de eigen pijl naar het doel. AFGELEID.

**5. Drie deur-mechanismen, drie drempels, en één ervan kan in Silvermoon waarschijnlijk niet werken.**
- Drie manieren om "je bent bij de deur" te meten. GEMETEN:
  - TwoStepRoute `DoorProximity`: yards, dan kaartgrootte, dan kaartprocent; 22 yd of 1,2 % (TwoStepRoute.lua:126-152).
  - Vliegstap-wachter: alleen `ns.SmcYardsToPoint`, < 25 yd of "weggelopen" (DelveTipMarkup.lua:504-514).
  - MountRun `WatchVia`: alleen kaartprocent, < 0,3 (MountRun.lua:314).
- Drie keer dezelfde "sta je al binnen?"-meetkunde: TwoStepRoute.lua:264-267, DelveTipMarkup.lua:649-660, MountRun.lua:290-301. GEMETEN.
- TwoStepRoute zegt GEMETEN op 7 sep dat `SmcYardsToPoint` in Silvermoon altijd `nil` geeft (TwoStepRoute.lua:34-41). De vliegstap-wachter gebruikt juist die functie, **zonder terugval**. Daar hangt de deur→portaal-overdracht van het Coiled Isle-portaal van 16 okt aan (`door` in Delves.lua:293/295). AFGELEID: die overdracht kan in Silvermoon dan niet vuren.
- Een tweede punt hierbij:
  - `TwoStepRoute.WorldXY` geeft een **UiMapPoint** door aan `C_Map.GetWorldPosFromMapPos` (TwoStepRoute.lua:70-74). Alle andere aanroepen geven een `CreateVector2D` door: NativeArrow.lua:75/103, Delves.lua:1531/1615/3766, FlightPointsData.lua:1080, DelveTipMarkup.lua:752, Core.lua:794, MountRun.lua:452, ResetRoutine.lua:1532. GEMETEN.
  - Steun voor de twijfel, maar zwak:
    - NativeArrow.lua:113-118 legt vast dat `GetWorldPosFromMapPos` op 2393 (met een Vector2D) op 24 aug wél een continent teruggaf. Dat zegt alleen dat de aanroep slaagt, niet dat de positie gevuld is.
    - "the arrow still said 34 m" in Silvermoon (MountRunData.lua:392-393; MountRun.lua:279) kan TomTom's pijl zijn geweest. Rob draait TomTom, en TomTom rekent zelf.
  - AFGELEID, niet getest: "Silvermoon heeft geen wereldcoördinaten" komt mogelijk door dat verkeerde argumenttype, niet door de kaart. Eén `/dump` in Silvermoon met beide argumentvormen beslist dit.

---

## 2. Per bestand

Kolommen: **regel** · **wat het doet** (één regel) · **wie het aanroept** · **events/tikkers**. Alles in de tabellen is GEMETEN, tenzij er AFGELEID bij staat.

### 2.1 `Modules/TravelPlan.lua` (742 regels; laadvolgorde .toc regel 175)

| Functie / tabel | Regel | Wat | Aangeroepen door | Events |
|---|---|---|---|---|
| `ns.AMANI_HUBS` | 52-58 | 3 Windcaller-hubs (npc- en landingspunt) | `ChooseHub` 64 | — |
| `ChooseHub` | 62-79 | welke hub het dichtst bij het doel landt, welke NPC het dichtst bij de speler | TravelPlan.lua:524, 664 | — |
| `ns.TravelStepName` | 84-93 | tekst van een stap, plus de gossip-keuze | NativeArrow.lua:388, 396, 479, 803; DelveTipMarkup.lua:643, 694 | — |
| `LINKS` | 95-133 | 1 rij: Underbelly-deur + Windcaller-hop (`via`) | TravelPlan.lua:487 | — |
| `INSIDE` | 138-141 | 2 rijen: 2613 in 2509, 2509 in 2512 | `ContainerChain` 186 | — |
| `MIDNIGHT_HUB_MAP` | 146 | constante 2393 | 358, 362 | — |
| `FactionCapitalMap` | 156-170 | 85 (Horde) / 84 (Alliance) | 463 | — |
| `PlayerMap` | 172-180 | huidige kaart | 207 | — |
| `ContainerChain` | 183-192 | kaartketen via `INSIDE` | 213 | — |
| `ns.BuildTravelPlan` | 202-700 | stappenlijst (portal/fly/gossip/walk/arrive) naar een doel | TravelPlan.lua:710; NativeArrow.lua:361, 475, 799; DelveTipMarkup.lua:293, 618 | geen (pure functie; leest C_Map, `MIDNIGHT_PORTALS`, vliegdata, `C_Map.GetMapLinksForMap` 596) |
| `ns.PrintTravelPlan` | 709-742 | print het plan in chat, met `mhway`-links | Core.lua:1670 (`/mh plan`/`/mh route`; ook QuickBar shift-klik via slash, QuickBar.lua:321) | — |

Opmerkingen:
- De kop zegt "THIS DELIBERATELY DOES NOT TOUCH THE ARROW" (TravelPlan.lua:17-22). Inmiddels sturen `NativeArrow.UpdateArrow` en `RouteFirstToFlightPoint` de pijl wél met dit plan. GEMETEN: verouderd commentaar.
- **AFGELEID:** de `mhway`-links die `PrintTravelPlan` in chat zet, zijn waarschijnlijk niet klikbaar. Er is geen `SetItemRef`-, `OnHyperlinkShow`- of `EventRegistry`-handler voor `mhway` in de addon (grep op `*.lua`: 0 treffers). De positieve controle (`OnHyperlinkClick`) vond 4 bestanden. Hetzelfde geldt voor `/mh keys` (CorrosiveCodexHunts.lua:205-222).

### 2.2 `Modules/DelveTipMarkup.lua` (1002 regels; .toc 58) — reisdeel

| Functie / tabel | Regel | Wat | Aangeroepen door | Events |
|---|---|---|---|---|
| `ns:ExpandDelveTipMarkup` | 84-129 | o.a. `{WAY:map:x:y:Label}` → klikbare `mhway`-link (115-117) + vendor-namen (120-122) | DelveCoach.lua:368, DelvePartyShare.lua:100, DungeonLiveCoach.lua:169, DungeonGuide.lua:320/913/931, EncounterJournalSidePanel.lua:168, DungeonBossWindow.lua:1353, MidnightCodex.lua:577, RaidGuide.lua:110, TierSet.lua:281 | — |
| `ns.VENDOR_WAYPOINTS` | 141-167 | 16 NPC-namen → kaart/x/y | `LinkifyVendors` 914 | — |
| `ns:GetWayLinkMarkup` | 169-177 | maakt `|Hmhway:…|h` | 116, 915; TravelPlan.lua:723; CorrosiveCodexHunts.lua:206 | — |
| `ns.ReportWaypointResult` | 196-249 | chatregel na een `{WAY}`-klik + vliegpunt bij het doel | DelveTipMarkup.lua:886 | — |
| `ns.ReportTravelHintForWaypoint` | 261-351 | chat: plan-portaal of "vlieg van A naar B" (met netwerkcheck) | Delves.lua:1915 | — |
| `pendingLeg`, `legWatcher` | 370 | toestand van de lopende tussenstap | intern | — |
| `ns.GetPendingFlightStop` | 374-376 | welke halte je op de vliegkaart moet klikken | FlightMapHint.lua:258 | — |
| `ClearLeg` / `ns.ClearTravelLeg` | 378-385 | stap wissen + tikker stoppen | intern 482, 522, 537, 544. **Extern: 0** (grep vond de definitie op 385) | — |
| `ArrivedOnTargetMap` | 387-465 | is de tussenstap klaar? (kaart, slice van 2576, voorouder-kaart, of vliegpunt-buurt) | 501 | — |
| `StartLegWatcher` | 471-554 | tikker: op taxi of aangekomen → stap 2; deur-overdracht; opnieuw plannen bij nieuwe kaart | 697, 797 | **NewTicker 1,5 s** (478) |
| `ns.RouteFirstToFlightPoint` | 557-800 | zet de pijl op de eerste planstap (deur/portaal/gossip) of op een vliegmeester; schrijft `ns._mhArrowLedTo` | Delves.lua:1920; DelveTipMarkup.lua:868 (`legRetry`) | — |
| `ns.HasPendingTravelLeg` | 822-824 | is er een tussenstap? | **0 aanroepers** (grep vond de definitie) | — |
| `legRetry` | 826-872 | na een zonewissel `RouteFirstToFlightPoint` opnieuw proberen | — | **ZONE_CHANGED_NEW_AREA, PLAYER_ENTERING_WORLD → C_Timer.After 0,7 s** |
| `ns:SetMapWaypoint` | 874-903 | `{WAY}`-klik → `AddSmartTomTomWay` + `ReportWaypointResult`; terugval: TomTom-slash / `C_Map.SetUserWaypoint` + SuperTrack (889-902) | DelveTipMarkup.lua:987 | — |
| `ns:LinkifyVendors` | 910-919 | vendor-namen in tekst → `mhway`-link | 121; CurrencyGuide.lua:97 | — |
| `ns:AttachDelveTipHyperlinksToEditBox` | 962-998 | `OnHyperlinkClick` `mhway` → `SetMapWaypoint` (984-991) | CurrencyGuide.lua:257, DelveCoach.lua:1328, DungeonBossWindow.lua:762, DungeonGuide.lua:615/814/879, GearEnchantCheck.lua:1018, MidnightCodex.lua:428, OmniumFolio.lua:535, RaidGuide.lua:336, TierSet.lua:404 | — |

Opmerking: in OmniumFolio.lua:539, TierSet.lua:408 en GearEnchantCheck.lua:1025 wordt `OnHyperlinkClick` **na** de attach overschreven. GEMETEN. AFGELEID: een `{WAY}`- of vendor-link in die teksten doet dan niets bij een klik. TierSet zet wel markup om (TierSet.lua:280-281).

### 2.3 `Modules/Delves.lua` (4565 regels; .toc 167) — reisdeel

| Functie / tabel | Regel | Wat | Aangeroepen door | Events |
|---|---|---|---|---|
| `SafeHideTravelPopup` / `ns.SafeHideTravelPopup` | 16-39 | popup verbergen; in gevecht uitstellen | Delves.lua: 15 plekken (1926…4445). `ns.`-versie: **0 externe aanroepers** | PLAYER_REGEN_ENABLED (30) |
| `MIDNIGHT_DELVES` / `ns.MIDNIGHT_DELVES` | 55-116, 341 | 16 delve-rijen (1 `pinOnly`) | intern; DelveBossShowcase.lua:834, DelveHistory.lua:57/316 | — |
| `ns.IsKnownDelveName` | 130-145 | staat deze delve in de lijst? | AtalUtekProbe.lua:1236, DundunShrine.lua:125/631 | — |
| `MIDNIGHT_PORTALS` / `ns.MIDNIGHT_PORTALS` | 147-320, 342 | 18 portaalrijen (§3) | TravelPlan.lua:336/361; Delves.lua:531, 1323, 1711, 2001, 2185 | — |
| `PORTAL_NAME_KEYS` + `ns.MHPortalLabel` | 325-339 | vertaalde portaalnaam | Delves.lua:2035, 2050, 2221, 2236, 4378, 4397 | — |
| `ns.GetItemCooldownSafe` | 381-400 | cooldown met 12.1.5-terugval | Delves.lua:1728/1990/2176; MountRun.lua:383; DelveItemsPopup.lua:278 | — |
| `PortalUsable` / `ns.MHPortalUsable` | 420-437 | quest-poort (account, dan karakter) | TravelPlan.lua:337/362; Delves.lua:532, 1327, 1712, 2005, 2191 | — |
| `INN_AREAS_BY_ZONE` | 464-466 | 1 rij: Wayfarer's Rest (16645) | 480 | — |
| `HearthstoneGoesTo` / `ns.MHHearthstoneGoesTo` | 468-495 | gaat je Hearthstone naar deze zone? (faalt dicht) | Delves.lua:521, 526, 1708, 1946, 1949, 2046, 2048, 2070, 2153, 2232, 2234; MountRun.lua:412, 415 | — |
| `ns.PrintPortalAccess` | 508-649 | `/mh portals`; schrijft `ns.db.portalBindProbe` | Core.lua:1407 | — |
| `RouteToDelveRow` | 1025-1042 | delve-rij → `AddSmartTomTomWay` + eigenaar `delve` | Delves.lua:2626 | — |
| `ns.IsTomTomReady` | 1047-1049 | is TomTom er? | ± 15 plekken (Core, Delves, DelveTipMarkup, NativeArrow, Profession, RitualSites) | — |
| `GetZoneDisplayName` (1e) | 1051-1060 | kaartnaam, `""` bij nil | travel-code in Delves.lua | — |
| `ns.GetBaseZoneName` | 1084-1152 | basiszone, met slice van 2576 en klim naar de ouder-kaart | Delves.lua:592, 1455, 1582; ZoneLevelGate.lua:245; NativeArrow.lua:1257 | — |
| `ns.GetRegionGroupID` | 1155-1222 | regio 1/2/3/0, met klim naar de ouder-kaart | 1439 | — |
| `MIDNIGHT_OVERWORLD_MAPS` | 1224-1233 | 8 kaarten | `MapsLinkedForTravel` 1504 | — |
| `PlayerIsInSilvermoonHub` | 1245-1264 | sta je in de stad zelf? | 1945, 2041, 2152, 2227 | — |
| `TRAVEL_ARRIVAL_YARDS` | 1266 | **400** | 1560 | — |
| `ns.PrintTravelPopupDecision` | 1284-1337 | `/mh travelwhy` | Core.lua:2117 | — |
| `ns.MIDNIGHT_HUB_MAP_BY_NAME` | 1344-1348 | Silvermoon/Harandar/Voidstorm → kaart-id | DelveTipMarkup.lua:421-423 | — |
| `ns.ResolveHubOnMap2576` | 1350-1362 | slice van canvas 2576 op x (<45 / >58) | Delves.lua:594, 1091, 1382, 1453; NativeArrow.lua:1252 | — |
| `ns.GetTargetRegionGroupID` | 1379-1385 | regio van het doel, met slice | TravelPlan.lua:359, 458; Delves.lua:1314, 1421, 1942, 2150; NativeArrow.lua:1246; ZoneLevelGate.lua:167 | — |
| `ns.SameTravelRegion` | 1412-1423 | zelfde regio? | DelveTipMarkup.lua:272 | — |
| `ns.GetEffectiveRegionGroupID` | 1426-1440 | regio met hub-slice | TravelPlan.lua:454; Delves.lua:1313, 1384, 1420, 1941, 2149, 4501; NativeArrow.lua:1244 | — |
| `ns.GetPlayerHubContext` | 1442-1460 | hub van de speler (slice) | TravelPlan.lua:451; Delves.lua:1260, 1312, 1419, 1579, 1940, 2148, 4500; NativeArrow.lua:1243; DelveTipMarkup.lua:422 | — |
| `IsMidnightDelveWaypoint` | 1462-1472 | is het doel een delve-ingang? | 1556 | — |
| `MapHasAncestor`, `MapsLinkedForTravel` | 1474-1508 | voorouder-test + "beide overworld" | 1593 | — |
| `ns.GetYardsToMapWaypoint` | 1520-1546 | afstand in yards (huge bij ander continent) | 1560 | — |
| `ns.IsMidnightTravelComplete` | 1549-1565 | in een actieve delve of ≤ 400 yd → klaar | Delves.lua:1305, 1569, 3918 | — |
| `ns.ShouldSuppressTravelPopup` | 1568-1598 | popup stil houden (zelfde zone/hub) | Delves.lua:1307, 1924, 1973, 2138 | — |
| `ns.IsCrossContinentTarget` | 1605-1629 | ander continent? (onbekend = ja) | TravelPlan.lua:406; Delves.lua:1636 | — |
| `ns.MHIsCrossContinentFromPlayer` | 1634-1637 | idem, vanaf de speler | Delves.lua:1873; Achievements.lua:1083; Profession.lua:1409 | — |
| `ns.MHSameZoneOrSub` | 1642-1669 | zelfde zone of subzone (beide kanten op) | Delves.lua:1309, 1933, 2143; Achievements.lua:810 | — |
| `MapWithAncestors` | 1673-1689 | set van kaart + voorouders | 1731, 1752, 1999, 2183 | — |
| `HearthViaHubPortal` / `ns.MHHearthViaHubPortal` | 1704-1718 | Hearthstone naar Silvermoon + stadsportaal | 1732, 2046, 2232. `ns.`-versie: **0 externe aanroepers** | — |
| `ns.MHHearthRouteFor` | 1723-1734 | naam van dat portaal, of nil (alleen cooldown 6948) | NativeArrow.lua:468; Delves.lua:1945, 2152 | — |
| `ns.MHIsSelfOrAncestor` | 1747-1753 | is `anc` deze kaart of een voorouder? | TravelPlan.lua:233-234, 314, 318; Delves.lua:1256; DelveTipMarkup.lua:437-440, 624-625 | — |
| `ns.ReassertCrazyArrow` | 1762-1769 | TomTom-pijl opnieuw op `_mhCrazyArrowUid` | Achievements.lua:1065 | — |
| `TravelWhy` / `ns.MHTravelWhy` | 1778-1787 | log van popup-beslissingen in `ns.db.travelWhy` (12) | Delves.lua intern. `ns.`-versie: **0 externe aanroepers** | — |
| **`ns.AddSmartTomTomWay`** | 1789-2080 | **De gedeelde deur.** Volgorde: level-waarschuwing (1826) → `lastTarget` (1839) → TomTom of Blizzard-waypoint (1847-1878) → eigenaar `waypoint` (1884-1889) → vlieghint + `RouteFirstToFlightPoint` (1914-1921) → popup-poorten → portaal/HS-popup (1960-2078) | 48 aanroepen in 27 bestanden (§6) | — |
| `ns.AddSmartQuestRoute` | 2087-2117 | volgt de live quest-waypoint, anders vaste coördinaten | CampaignLeadIn.lua:493/503; EventsPanel.lua:212; ResetRoutine.lua:1229 | — |
| `ns.ShowTravelAssistFor` | 2124-2260 | **2e kopie** van de popup-logica, zonder waypoint | UI.lua:1734; Profession.lua:1398, 1431 | — |
| `DelveMapPosToWorld`, `GetPlayerContinentWorld` | 3761-3803 | wereldcoördinaten | `RouteNearestDelve` | — |
| `RouteNearestDelve` | 3752, 3810-3844 | dichtstbijzijnde (bountiful) delve → `AddSmartTomTomWay` + `delve` | 3755, 3847 (knoppen 4196, 4201) | — |
| `CreateEventBridge` → `RouteLead`, `runZoneNavCheck`, `restoreDelveArrow` | 3850-4048 (reisdeel 3868-4010) | na een zonewissel: route klaar verklaren, of de TomTom-pijl herstellen | — | **ZONE_CHANGED_NEW_AREA, PLAYER_ENTERING_WORLD → After 1 s; restore ook +0,5 s** |
| Popup-frame `MH_TravelPopup` | 4301-4323 | venster (strata TOOLTIP, Esc sluit) | — | — |
| `hsBtn` (secure) | 4326-4348 | `/use item:6948` | klik speler | — |
| `portalBtn` | 4351-4407 | **bypass**: `TomTom:AddWaypoint` direct, of `SetBlizzardUserWaypoint`. Geen eigenaar, geen `lastTarget` | klik speler | — |
| `mageBtn`, `magePortalBtn` (secure) | 4413-4447 | `/cast` Teleport/Portal: Silvermoon (1259190 / 1259194) | klik speler | — |
| `ns:ShowTravelPopup` | 4459-4565 | tekst + magier-knoppen + hoogte; niet in gevecht of in een instance | Delves.lua:2074, 2255 | — |

Kleine vondst: er zijn twee `local function GetZoneDisplayName` (Delves.lua:1051 en 2510). De eerste geeft `""` bij nil, de tweede `"Unknown zone"`. Code na regel 2510 gebruikt de tweede. GEMETEN.

### 2.4 `Modules/NativeArrow.lua` (1309 regels; .toc 179)

| Functie / tabel | Regel | Wat | Aangeroepen door | Events |
|---|---|---|---|---|
| `OWNER_STYLE`, `DEFAULT_STYLE`, `OwnerStyle` | 54-67 | kleur en icoon per eigenaar (`rare`, `treasure`, `achievement`, `reset`, `delve`, `ritual`) | 548 | — |
| `MapToWorld`, `MapContinent`, `ParentMap`, `OneContainsTheOther`, `PlayerWorld` | 71-185 | wereldcoördinaten, continent (gecached), ouder-keten (12 sprongen) | intern | — |
| `TargetKey`, `HasNativeWaypoint`, `TomTomArrowShowing`, `RouteOwned`, `ShouldDriveNative` (TomTom + 4 s respijt) | 187-234 | hulpjes | intern | — |
| `IsWaypointUIPresent`, `YieldToWaypointUI` | 240-272 | wijken voor WaypointUI (`ns.db.arrowYieldWaypointUI`) | intern | — |
| `activeLead` + `ns.GetActiveArrowLead` | 275-285 | eigen kopie van het doel | Rares.lua:1829; Addons/Farstrider.lua:63-64 | — |
| `UpdateArrow` | 316-600 | draait en tekent de pijl. Bij een ander continent: **eerste planstap op deze kaart** (360-404); anders een label met Hearthstone/plan/vliegpunt (463-502) | `OnUpdate` 694-701 | **OnUpdate elke 0,03 s** |
| `EnsureArrowFrame` | 602-706 | frame; rechtsklik → `ns.ClearActiveRoute` (622-626) | Show/Preview | — |
| `AnnounceUnreachable` | 737-826 | eenmalige chatregel "niet op dit continent, ga eerst naar …" | `Tick` 991 | — |
| `ns.SetNativeArrowSize` … `ns.PreviewNativeArrow` | 829-889 | instellingen + preview | Settings, `/mh arrowsize` | — |
| `Tick` | 898-1094 | ruimt op als er geen eigenaar is (ook `_mhSmcPinsSet`, 926-934); `activeLead` uit `lastTarget`; rare/treasure-lead ophalen; stand-down voor TomTom; verbergen in een instance; rare-omweg terug; **vrijgave `delve`/`waypoint` ≤ 20 yd** (1073-1081); Blizzard-waypoint opnieuw zetten (1084-1093) | — | **C_Timer.NewTicker 1,0 s, altijd aan** (1096-1098) |
| `ns.PrintArrowStatus` | 1122-1297 | `/mh arrow` | Core.lua:2377 | — |
| `ns.ToggleArrowYield` | 1300-1309 | `/mh arrow yield` | Core.lua:2372 | — |

AFGELEID (prestaties): in de tak "ander continent" roept `UpdateArrow` per frame `BuildTravelPlan` aan (361), en zo nodig nog een keer (475). Daarnaast ook `MHHearthRouteFor` en `GetNearestFlightPoint`. Dat is tot ± 60 plannen per seconde, zolang het doel op een ander continent staat.

### 2.5 `Modules/TwoStepRoute.lua` (285 regels; .toc 172)

| Functie | Regel | Wat | Aangeroepen door | Events |
|---|---|---|---|---|
| `WorldXY`, `PlayerWorldXY` | 65-94 | wereldpositie (**geeft een UiMapPoint door**, zie §1b-5) | intern | — |
| `ns.SmcYardsToPoint` | 97-105 | afstand in yards of nil | TwoStepRoute.lua:127; DelveTipMarkup.lua:504-506 | — |
| `PlayerMapXY`, `DoorProximity` | 108-152 | afstand op 3 manieren + bijpassende drempel | intern | — |
| `ns.StopSmcTwoStepRoute` | 154-156 | wachter stoppen | **alleen** Delves.lua:3971 | — |
| `ns.SmcTwoStepStatus` | 172-191 | status voor `/mh arrow` | NativeArrow.lua:1177 | — |
| `Arrive` | 194-212 | bij de deur → `ns.SetSMCWaypointDirect`; alleen bij eigenaar `nil`/`waypoint` | `Tick` | — |
| `Tick` | 214-231 | elke seconde; stopt na 300 s | intern | **C_Timer.After 1 s, keten** |
| `ns.StartSmcTwoStepRoute` | 235-285 | start de deur-eerst-route als de pin een `entrance` heeft | UI.lua:1649 | — |

### 2.6 `UI.lua` — Silvermoon City-pins (.toc 109)

| Functie / tabel | Regel | Wat | Aangeroepen door |
|---|---|---|---|
| `SMC_CITY_MAP_ID` | 1153 | 2393 | `SetSMCWaypoint` |
| `SMC_CATEGORIES` → `SMC_CAT_TRAVEL` | 1262-1291 | 6 pins: Portal Room, Voidstorm, Harandar, Coiled Isle (`entrance` + `arrivesOn = 2512` + `requiresQuest`), Timeways, M+ Teleports | — |
| `astalor`-pin | 1308 | "Astalor Bloodsworn (entrance)" 55.00/63.40 = de deur | — |
| vliegmeester-pins | 1371-1410 | `nearest_fp` (actie) + 2 pins uit `ns.FLIGHT_POINTS[2393]`, bij het laden gebouwd | — |
| `AddSMCInstanceCategory` | 1457-1514 | blok Dungeons & Raids (entrances uit DungeonRoster/RaidCoach) | paneel |
| `TriggerTomTomWaySlash` | 1516-1534 | `/way` via TomTom's `SlashCmdList` | 1696 |
| **`SetSMCWaypoint`** | 1536-1736 | **eigen routepad (bypass van `AddSmartTomTomWay`)**: acties (instance, nearest_fp, worldboss_week, world_tab, ritual_site, void_hub), level-slot via `ns.MidnightFloorMet` (1623), TwoStep (1648-1650), `C_Map.SetUserWaypoint` + SuperTrack (1666-1671), `lastTarget` met `arrivesOn` (1689-1690), eigenaar `waypoint` (1691-1694), TomTom-slash (1696), `ns._mhSmcPinsSet` (1702), `ShowTravelAssistFor` (1733-1735) | 1754, 1774, 2601 |
| `ns.SetSMCWaypointDirect` | 1744-1755 | kopie van de pin zonder `entrance` | TwoStepRoute.lua:207 |
| `ns.GetSMCCityPin` / `ns.SetSMCCityWaypoint` / `ns.OpenSMCCityGuidePin` | 1757-1788 | pin op id | DawncrestGuide.lua:654/664/680; ProfessionsGuide.lua:810 |
| pin-knop `OnClick` | 2600-2602 | → `SetSMCWaypoint(point)` | speler |

Geen events of tikkers in UI.lua voor routes. UI.lua:5047-5048 registreert PLAYER_LEVEL_UP en PLAYER_ENTERING_WORLD, maar niet voor routes (niet verder gelezen, AFGELEID uit de context).

### 2.7 `Modules/MountRun.lua` (817 regels) + `MountRunData.lua` (445 regels) (.toc 247-248)

| Functie / tabel | Regel | Wat | Aangeroepen door | Events |
|---|---|---|---|---|
| `EntrancePoint` | MountRun.lua:131-151 | raid-ingang: eerst `C_EncounterJournal.GetDungeonEntrancesForMap`, dan eigen data | `BuildSteps` 224 | — |
| `InMap`, `ContinentOf`, `ArrivedVia` | 158-197 | ouder-keten (12), continent, "door de vorige stap gekomen" | intern | — |
| `STEP_KEY`, `BuildSteps` | 199-227 | stappen uit `raid.route` → `MOUNTRUN_HUBS` | 493 | — |
| `CurrentStep` | 233-253 | bij welke stap ben je nu? | 495, 505, 537 | — |
| `PointAt` | 265-276 | `MH_TomTomClearAll` + `AddSmartTomTomWay(…, skipTravelUI)` + `noTravelAdvice` + eigenaar `mountrun` | 317, 345, 347 | — |
| `WatchVia` | 281-321 | eerst de deur, dan het portaal (< 0,3 kaart-%) | 330, 344 | **NewTicker 0,5 s** |
| `ShowStep` | 323-351 | stap tonen; Hearthstone-stap: `lastTarget = nil`, eigenaar `mountrun` | 505, 539 | — |
| `HomeSteps` | 356-490 | eerst naar huis: portaal hier, Hearthstone (+ toys), via Silvermoon, of de dichtste hub | 496 | — |
| `ns.MountRunStartRoute` | 492-506 | start | MountRun.lua:774 (knop) | — |
| zone-frame | 508-543 | eigenaar ≠ `mountrun` → route weg; in instance → eigenaar nil + TomTom wissen; anders +1 s volgende stap | — | **ZONE_CHANGED_NEW_AREA, ZONE_CHANGED, ZONE_CHANGED_INDOORS, PLAYER_ENTERING_WORLD** |
| `ns.MH_ShowMountRun` | 795-806 | `/mh mountrun` | Core.lua:2228 | UPDATE_INSTANCE_INFO, NEW_MOUNT_ADDED (alleen het venster) |
| `ns.MOUNTRUN_RAIDS` | MountRunData.lua:19-317 | 47 raids, met `route`-sleutels + ingang | `RefreshMountRun` | — |
| `ns.MOUNTRUN_HUBS` | 333-379 | 38 hubs (§3) | `BuildSteps` | — |
| `ns.MOUNTRUN_HOME` | 390-424 | 21 kaarten → portaal naar 84/85 | `HomeSteps` | — |
| `ns.MOUNTRUN_HEARTH_TOYS` | 432-435 | 19 toy-id's | `HomeSteps` 391 | — |
| `ns.MOUNTRUN_TO_SILVERMOON` | 439-445 | 3 kaarten / 4 stappen | `HomeSteps` 419 | — |

### 2.8 `Modules/FlightPointsData.lua` (1175 regels; .toc 56) en `FlightNetworkData.lua` (162; .toc 57)

| Functie / tabel | Regel | Wat | Aangeroepen door |
|---|---|---|---|
| `ns.FLIGHT_POINTS` | FlightPointsData.lua:48-1022 | 154 kaarten, 649 rijen `{naam, x, y, factie}` | `GetNearestFlightPoint`, `RouteToNearestFlightPoint`, UI.lua:1373 |
| `UsableByPlayer` | 1032-1045 | factie-filter (onbekend = bruikbaar) | 1055, 1145 |
| `ns.GetNearestFlightPoint` | 1047-1070 | dichtstbijzijnde op ruwe kaartcoördinaten; **zonder positie: de eerste in de lijst** | DelveTipMarkup.lua:241, 303, 322, 327, 459, 713, 714, 767; TravelPlan.lua:414; NativeArrow.lua:486, 810; FlightPointsData.lua:1158 |
| `MapPosToWorld` | 1076-1093 | wereldcoördinaten | 1140, 1146 |
| `ns.RouteToNearestFlightPoint` | 1110-1175 | **bypass**: `SetBlizzardUserWaypoint` + `lastTarget` (`via "flight point"`) + eigenaar `waypoint`; vergelijkt in yards | UI.lua:1556; Core.lua:1863 (`/mh fp`); QuickBar.lua:345 |
| `ns.FLIGHT_NETWORK` | FlightNetworkData.lua:19-149 | 129 namen → component-nummer (Zygor) | `FlightPathExists` |
| `ns.FlightPathExists` | 153-162 | true / false / nil (= onbekend) | DelveTipMarkup.lua:338, 736 |

### 2.9 `Modules/FlightMapHint.lua` (379 regels; .toc 166)

- Leest `ns.GetPendingFlightStop` (257-259) en licht de juiste halte op de vliegkaart op. GEMETEN.
- Leert ook wat de vliegkaart toont, in `ns.db.taxiSeen` (`LearnFlightPins` 167-206). Dat wordt niet voor routes gebruikt; alleen `/mh flightpins` (`ns.PrintFlightPins` 335, Core.lua:1306-1311). GEMETEN.
- Hookt `FlightMapFrame` OnShow/OnHide bij ADDON_LOADED `Blizzard_FlightMap` / PLAYER_LOGIN (352-379).

### 2.10 `Core.lua` — reisdeel (.toc 25)

| Functie | Regel | Wat | Aangeroepen door |
|---|---|---|---|
| `MHResolveWaypointMap` | 783-827 | kaart die geen waypoint accepteert → klim naar een ouder die het wel doet | 845 |
| `ns.SetBlizzardUserWaypoint` | 830-857 | `C_Map.SetUserWaypoint` + SuperTrack (één gedeeld Blizzard-slot) | Delves.lua:1874, 1877, 3996, 4393; NativeArrow.lua:1090; FlightPointsData.lua:1167; Profession.lua:1419; WorldBoss.lua:606; DungeonBossWindow.lua:877; VaultReminder.lua:327; Core.lua:1893 |
| `MidnightHelper_KeybindSkipNode` | 913-921 | toets: rare overslaan of achievement-knoop overslaan | Bindings |
| `ns.ClearActiveRoute` | 926-947 | stopt Achievement/Rare/Treasure/Reset, TomTom, Blizzard-waypoint, eigenaar, `lastTarget` | NativeArrow.lua:624 (rechtsklik); Core.lua:985, 1003, 2763 |
| `ns.MH_TomTomClearAll` | 954-960 | TomTom wissen met vlag `_mhSelfWaypointOp` | o.a. Achievements, Rares, ResetRoutine, MountRun, DungeonRosterData, RitualSites, VoidAssaults, Showdowns, MountsPanel, ProfessionGuided, ProfessionAcademy, Profession, DelveChestData |
| `MH_InstallTomTomClearHook` | 971-998 | wist de speler TomTom → `ClearActiveRoute` | PLAYER_LOGIN, PLAYER_ENTERING_WORLD (994-995) |
| `MidnightHelper_KeybindClearRoute` | 1001-1005 | toets "route wissen" | Bindings |
| slash `plan`/`route`, `fp`, `goto x y`, `portals`, `travelwhy`, `mountrun`, `arrow`, `arrow yield`, `clear`/`clearroute`/`stop`, `trail`, `here`, `arrowsize` | 1666, 1861, 1883-1918, 1405, 2115, 2226, 2369, 2761, 1768, 1655, 2686 | zie §6 | speler |

### 2.11 Andere modules met een eigen route-machine (buiten de 12)

| Module | Functies / regels | Eigen tikker/events | Eigenaar |
|---|---|---|---|
| Rares.lua | `RouteRare` 1804-1850, `GenerateRaresRoute` 2270-2329, `GoToRare` 2384, `RouteToNearestRare` 2407, `StopRareRoute` 1601, `GetNearestIncompleteRareLead` 1589, `MHRareTryAutoAdvance` 2069, `IsRareVignetteNearWorld` 1918, `ResumePrevRouteOrRelease` / `ns.ResumeInterruptedRareRoute` 3202-3227 | ev 3229-3296 (QUEST_LOG_UPDATE, ZONE_CHANGED_NEW_AREA, PLAYER_ENTERING_WORLD, VIGNETTES_*) | `rare` |
| Achievements.lua | `IssueRoute` 953-1089, `Advance` 1091, `ForceArrowToLead` 1139-1187 (**bypass** `tt.AddWaypoint`), `StartRareWatch` 1219-1312, `ScheduleTravelRefresh` 1320-1340, `EnsureAdvanceFrame` 1368-1426, `RouteAchievementTreasures` 1430, `StopAchievementRoute` 1446 | **NewTicker 2 s** (1224); advanceFrame incl. ZONE_CHANGED_NEW_AREA/PLAYER_ENTERING_WORLD (1383-1387) | `achievement` |
| Profession.lua | `ClearTomTomAndAddSingleWaypoint` 603, `TreasureStop` 1297, `TreasureUpdateArrow` 1318-1434, `RunTomTomGenerate` 1453-1528 (**bypass** `TomTom:AddWaypoint` 1503), `GetNearestIncompleteTreasureLead` 1237 | **NewTicker 2 s** (1524); treasureEvents (1436-1451) | `treasure` |
| ResetRoutine.lua | `RouteSingle` 1021, `IssueRoute` 1505-1519, `CancelResetRoute` 1522, `AdvanceResetRoute` 1582, dwell-tikker 1636-1686, `ReassertRoute` 1693, `EnsureAdvanceFrame` 1707-1755, `StartResetRoute` 1759 | **NewTicker 2 s** (1640); ZONE_CHANGED_NEW_AREA/PLAYER_ENTERING_WORLD → +2 s `ReassertRoute` (1732-1743) | `reset` |
| DelveChestData.lua | `StopRoute` 445, `PointAtNearest` 460-523, `RouteDelveChests` 530-583 | **NewTicker 2 s** (551); resetter PLAYER_ENTERING_WORLD (612-617) | `delvechest` |
| RitualSites.lua | `RouteHub` 209, `RouteSite` 232, `ReassertRouteAfterRevive` 254-274 | PLAYER_UNGHOST/PLAYER_ALIVE → +1,5 s (704-714) | (geen; via `AddSmartTomTomWay` → `waypoint`) |
| CampaignLeadIn.lua | `SuperTrackQuest` 460, `RouteCampaignLeadIn` 480-509 | quest geaccepteerd → super-track (514 e.v., niet verder gelezen) | (via de deur) |

Opmerkingen:
- DelveChestData.lua:434-441 zegt: "This route does NOT go through MHResolveWaypointMap". De route roept wél `AddSmartTomTomWay` aan (486). Zonder TomTom gaat die naar `SetBlizzardUserWaypoint` (Delves.lua:1877) en dan naar `MHResolveWaypointMap` (Core.lua:845). Met TomTom gebeurt dat ook bij een kaart die geen pin accepteert (Delves.lua:1870-1875). GEMETEN pad. AFGELEID: commentaar en code spreken elkaar tegen. Of de klim daar echt iets doet, hangt af van `CanSetUserWaypointOnMap` in een delve. Niet gemeten.
- `NativeArrow.Tick` verbergt de pijl in élke instance (NativeArrow.lua:1010-1013). De code zelf zegt dat een delve een scenario-instance is (DelveTipsData.lua:501-508). AFGELEID: de chest-route in een delve heeft zonder TomTom dus geen eigen pijl, terwijl DelveChestData.lua:440 zegt dat "the arrow we draw ourselves is the whole mechanism".

---

## 3. Datatabellen met reiskennis

### 3a. Overzicht

| Tabel | Plek | Rijen | Bron / status volgens de code zelf | Status van deze telling |
|---|---|---|---|---|
| `MIDNIGHT_PORTALS` | Delves.lua:147-320 | 18 (5× naar 2393 vanaf 2393/2576/85, 2× Den-mond, 2× Den-binnen, 4× Voidstorm-hub, 3× Coiled Isle, 2× beacon) | Orgrimmar, Den en Coiled Isle-deur door Rob gemeten (commentaar 153, 179-182, 289); de rest "inherited" (193-194); Stormwind en Val ontbreken bewust (159, 316-319) | GEMETEN |
| `INN_AREAS_BY_ZONE` | Delves.lua:464-466 | 1 | wago AreaTable (460-463) | GEMETEN |
| `MIDNIGHT_DELVES` | Delves.lua:55-116 | 16 (1 `pinOnly`) | 11 met 93xxx-id's (geen echte POI-id's, 80-85); 4 gemeten via `/mh atal` of PTR | GEMETEN |
| `MIDNIGHT_OVERWORLD_MAPS` | Delves.lua:1224-1233 | 8 | — | GEMETEN |
| `MAPS_BOUNTIFUL_SCRAPE` | Delves.lua:2277 | 8 | — | GEMETEN |
| `ns.MIDNIGHT_HUB_MAP_BY_NAME` | Delves.lua:1344-1348 | 3 | — | GEMETEN |
| Regiolijsten in `GetBaseZoneName` / `GetRegionGroupID` | Delves.lua:1084-1222 | 7 / 6 kaart-id's hardcoded | + klim naar de ouder-kaart | GEMETEN |
| Slice-grenzen 2576 | Delves.lua:1355-1361 | `<45` Silvermoon, `>58` Harandar | niet als gemeten gelabeld | GEMETEN (de grenzen); herkomst onbekend |
| `ns.AMANI_HUBS` | TravelPlan.lua:52-58 | 3 | Rob `/mh here`, 18 aug (36-38) | GEMETEN |
| `LINKS` | TravelPlan.lua:95-133 | 1 (+ `via`) | Method, "Unverified" (96-98); Windcaller uit screenshot 17 aug | GEMETEN |
| `INSIDE` | TravelPlan.lua:138-141 | 2 | — | GEMETEN |
| `FLIGHT_POINTS` | FlightPointsData.lua:48-1022 | 649 / 154 kaarten | Zygor, geregenereerd 16 aug; 2 eigen (Amani Foothold, Atal'Aman) (37-44) | GEMETEN |
| `FLIGHT_NETWORK` | FlightNetworkData.lua:19-149 | 129 | automatisch uit Zygor LibTaxi (1-16) | GEMETEN |
| `ns.db.taxiSeen` | FlightMapHint.lua:172-203 | geleerd, per speler | niet voor routes gebruikt | GEMETEN |
| `ns.VENDOR_WAYPOINTS` | DelveTipMarkup.lua:141-167 | 16 | web/Wowhead, "bevestig in-game" (139-140) | GEMETEN |
| `{WAY:…}` in locales | Locales/*.lua | 160 regels (Codex.lua 56, Translations2026.lua 60, ruRU 19, esMX 12, enUS 7, nlNL 6) | per tekst | GEMETEN (grep-count) |
| SMC-reispins | UI.lua:1262-1291, 1308, 1371-1410 | 6 + deurpin + `nearest_fp` + 2 vliegmeesters | Coiled Isle-pin + deur door Rob gemeten (1268-1283) | GEMETEN |
| `ns.MOUNTRUN_HUBS` | MountRunData.lua:333-379 | 38 | Zygor/HandyNotes in lokale bronbestanden; "none of them has been walked in game yet, except Orgrimmar → Silvermoon" (320-323) | GEMETEN |
| `ns.MOUNTRUN_HOME` | MountRunData.lua:390-424 | 21 | Zygor; [2393] door Rob gemeten 16 okt (395-397) | GEMETEN |
| `ns.MOUNTRUN_TO_SILVERMOON` | MountRunData.lua:439-445 | 3 kaarten / 4 stappen | kopie van `MIDNIGHT_PORTALS` (437-438) | GEMETEN |
| `ns.MOUNTRUN_HEARTH_TOYS` | MountRunData.lua:432-435 | 19 | Zygor `data_items.lua`; "Not verified per id in the client" (430) | GEMETEN |
| `REGION_MIN_LEVEL` / `MAP_MIN_LEVEL` | ZoneLevelGate.lua:60-64, 84-86 | 3 / 1 | client 13 sep / Rob 8 sep | GEMETEN |
| Silvermoon-bestemmingen in losse modules | ResetRoutine.lua:29-38, VaultReminder.lua:14-16, RitualSites.lua:50, VoidAssaults.lua:29, TradingPost.lua:328, TierSet.lua:245, OmniumFolio.lua:273, ProfessionsHub.lua:400 | 1-4 per bestand | wisselend | GEMETEN |

### 3b. Overlappingen (dezelfde plek op twee of meer plekken)

| Ding | Plek A (coördinaat) | Plek B (coördinaat) | Gelijk? | Status |
|---|---|---|---|---|
| Coiled Isle-portaal in Silvermoon | Delves.lua:292-295 `2393/2576 56.83/67.38`; MountRunData.lua:373 `SM_COILED 56.83/67.38` | UI.lua:1287 pin `56.74/67.30` | **nee** (0,09 / 0,08 verschil) | GEMETEN |
| Deur Astalor's Sanctum | Delves.lua:293/295 `door 54.99/63.30`; MountRunData.lua:373 `via 54.99/63.30`; UI.lua:1287 `entrance 54.99/63.30` | UI.lua:1308 pin "Astalor Bloodsworn (entrance)" `55.00/63.40` | **nee** (0,1 in y) | GEMETEN |
| Underbelly-ingang (2509) | TravelPlan.lua:113-114 `45.19/11.15`; AchievementsData.lua:212, 219, 255 `45.19/11.15` | Locales/Codex.lua:187, 322, 485, 620, 757, 894, 1031 `{WAY:2509:47.30:11.20}` | **nee** (2,1 in x) | GEMETEN. DelveTipMarkup.lua:507-509 noemt dit verschil zelf |
| Amani Windcaller (Foothold) | TravelPlan.lua:53 `50.03/61.93` | TravelPlan.lua:125-126 `49.99/61.93` | **nee** (0,04) | GEMETEN |
| Portaalkamer Silvermoon | UI.lua:1265 pin "Portal Room" `53.37/66.31` | MountRunData.lua:399 deur `53.30/66.24`, portaal A `52.71/64.61`, H `52.24/65.28` | **nee**; MountRunData.lua:391-397 legt uit dat de pin de kamer is | GEMETEN |
| Portaal Orgrimmar → Silvermoon | Delves.lua:163 `85 56.25/88.57` | MountRunData.lua:347 `P_SILVERMOON H 85 56.25/88.57` (+ A `84 48.77/95.23`, alleen Zygor) | ja (Horde); Alliance alleen in MountRun | GEMETEN |
| Portalen terug naar Silvermoon | Delves.lua:195, 197, 201, 298 (`2413 54.72/53.10`, `2576 64.33/70.63`, `2405 51.61/70.22`, `2512 58.25/48.46`) | MountRunData.lua:440-444 (zelfde vier waarden) | ja, maar twee kopieën | GEMETEN |
| Silvermoon → Voidstorm/Harandar | Delves.lua:166-169 `35.25/65.85`, `36.76/68.52` | UI.lua:1266-1267 (zelfde waarden) | ja, twee kopieën | GEMETEN |
| Dezelfde x/y op twee verschillende kaarten | Delves.lua:166/168 en 167/169 (2393 ↔ 2576); 201/203 en 202/204 (2405 ↔ 2576) | — | identiek | GEMETEN dat ze gelijk zijn. AFGELEID risico: voor Harandar bleek zo'n paar op 5 sep fout ("one of the pair had to be wrong", Delves.lua:176-177). Voor Silvermoon en Voidstorm is dat niet gemeten. Silvermoon-pins op 2393 hebben x tot ± 57; als 2393 dezelfde ruimte had als 2576, zou de slice-regel (<45) die "Voidstorm" noemen. Delves.lua:579-586 erkent dit voor het Coiled Isle-portaal |
| Ritual-hub / Void-hub | RitualSites.lua:50 `48.2/49.4`; UI.lua:1316-1317 `48.2/49.4` | VoidAssaults.lua:29 `48.2/49.6`; ResetRoutine.lua:29 `48.2/49.6` | **nee** (0,2 in y) | GEMETEN |
| Great Vault | VaultReminder.lua:14-16 `50.36/65.19` | ResetRoutine.lua:33 `50.36/65.19` | ja, twee kopieën | GEMETEN |
| Weekly questgevers | ResetRoutine.lua:38 `48.95/64.92` | UI.lua:1301-1302, 1309 `48.95/64.92` | ja, twee kopieën | GEMETEN |
| Trading Post | TradingPost.lua:328 `48.88/78.15` | UI.lua:1221 `48.88/78.15` | ja (commentaar 326-327 zegt "reusing") | GEMETEN |
| Creation Catalyst | TierSet.lua:245 `40.31/64.85` | UI.lua:1243 `40.31/64.85` | ja | GEMETEN |
| Specialisatie-reset | ProfessionsHub.lua:400 `45.05/56.17` | UI.lua:1242 `45.05/56.17` | ja | GEMETEN |
| Sanctum of Light (vliegmeester) | FlightPointsData.lua:952 `50.97/71.25` | UI.lua:1386-1387 `nearest_fp`-pin `50.97/71.25` (actie gebruikt de coördinaat niet) | ja | GEMETEN |
| Amani Foothold (vliegmeester) | FlightPointsData.lua:1005 `44.42/62.21` | Codex `{WAY:2509:44.42:62.21}` (7 talen) | ja | GEMETEN |
| Coiled Isle → Vaults-tunnels | MountRunData.lua:374-375 `43.30/44.27`, `45.37/64.90` | TravelPlan vraagt het live aan `C_Map.GetMapLinksForMap` (596); commentaar noemt `45.37/64.93` (DelveTipMarkup.lua:679) en `43.12/44.19` (NativeArrow.lua:380) | data tegenover live vraag | GEMETEN |
| Hub-kaart 2393 als constante | TravelPlan.lua:146, Delves.lua:1703/1992/2178, UI.lua:1153, + ≥ 8 modules | — | — | GEMETEN |
| Hoofdstad 84/85 | TravelPlan.lua:156-170 | MountRun (stappen, 340, 359) | twee modellen | GEMETEN |

Ook: de kop van Addons/Farstrider.lua:10-11 spreekt van "twelve portals". De tabel heeft er nu 18. GEMETEN.

---

## 4. Route-eigenaren (`ns._mhRouteOwner`)

| Waarde | Gezet door | Gewist / omgezet door | Gelezen door | Stijl in NativeArrow |
|---|---|---|---|---|
| `waypoint` | Delves.lua:1888 (`AddSmartTomTomWay`, alleen als het nu `nil`/`waypoint`/`delve`/`mountrun` is); UI.lua:1693 (alleen als het nu `nil`/`waypoint`/`delve` is); FlightPointsData.lua:1172; Core.lua:1914 (`/mh goto`); Rares.lua:3216 (zet de vorige eigenaar terug) | NativeArrow.lua:1074 (≤ 20 yd, alleen als wij sturen); Delves.lua:3960 (zone-check "klaar"); Core.lua:944, 988 | NativeArrow.lua:1073; Delves.lua:1884-1887, 3959; TwoStepRoute.lua:203; UI.lua:1691-1692 | **geen** (standaard goud) |
| `delve` | Delves.lua:1031, 3841 (na `AddSmartTomTomWay`) | NativeArrow.lua:1074; Delves.lua:3960; `AddSmartTomTomWay` zet het om naar `waypoint` (1887); Core.lua:944/988 | idem | cyaan (60) |
| `rare` | Rares.lua:1835, 2305; Rares.lua:3216 | Rares.lua:1605, 3209, 3220; Achievements.lua:1305, 1404; Core.lua:944/988 | NativeArrow.lua:524, 951, 1043; Delves.lua:3892; Achievements.lua:1281, 2638; Core.lua:916; Rares.lua:1604, 1616, 1819, 2070, 3073, 3252 | rood (55) |
| `treasure` | **alleen** Profession.lua:1466 | Profession.lua:1305; Rares.lua:3209 (bij omweg → `nil`); Core.lua:944/988 | NativeArrow.lua:968; Delves.lua:3893; Profession.lua:1304, 1322; Achievements.lua:1399 | goud (56) |
| `achievement` | Achievements.lua:989 (ook terugpakken bij `nil` via `Advance` 1096-1100) | Achievements.lua:962, 1454; Rares.lua:3209; Core.lua:944/988 | Achievements.lua:961, 1080, 1236, 1324, 1331, 1419, 1453 | geel (57) |
| `reset` | ResetRoutine.lua:1771; Rares.lua:3216 | ResetRoutine.lua:1597; Core.lua:944/988 | ResetRoutine.lua:1586, 1596, 1697, 1792; Achievements.lua:1399 | blauw (58) |
| `mountrun` | MountRun.lua:275, 335 | MountRun.lua:526 (instance); `AddSmartTomTomWay` → `waypoint` (Delves.lua:1887); Core.lua:944/988 | MountRun.lua:304, 520, 534; DelveTipMarkup.lua:481, 558, 838; Delves.lua:3906 | **geen** |
| `delvechest` | DelveChestData.lua:483 | DelveChestData.lua:452; Core.lua:944/988 | DelveChestData.lua:451, 532, 554, 606 | **geen** |
| `ritual` | **nooit gezet** (grep op `_mhRouteOwner =`; positieve controle vond de 8 andere waarden) | — | NativeArrow.lua:61 (alleen stijl) | paars |
| `nil` | Core.lua:944/988, NativeArrow.lua:1074, enz. | — | NativeArrow.lua:213 (`RouteOwned`), QuickBar.lua:313/503, Achievements.lua:1096 (terugpakken), ResetRoutine.lua:1586/1697 | — |

Verwante gedeelde toestand (GEMETEN):
- `ns.lastTarget`: velden `mapID, x, y, name, leg, via, arrivesOn, noTravelAdvice, hintKey`.
  - `arrivesOn` wordt **alleen** door UI.lua:1690 gezet, en alleen de pin `portal_coiled_isle` heeft er een (UI.lua:1287).
  - AFGELEID: de pins "Portal to Voidstorm" en "Portal to Harandar" (UI.lua:1266-1267) hebben geen `arrivesOn`. Na het portaal blijft die route dus wijzen naar een plek in Silvermoon. Dat is het patroon van de 5 sep-bug.
- `ns._mhTravelLegBusy`: gezet en gewist in DelveTipMarkup.lua:518/520, 547/549, 640/667, 792/795. Gelezen in Delves.lua:1794, 1826, 1841 en DelveTipMarkup.lua:505, 533, 568, 639, 833, 848.
- `ns._mhArrowLedTo`: gezet in DelveTipMarkup.lua:573/668, gelezen in Delves.lua:2027, 2213.
- `ns._mhSmcPinsSet`: gezet in UI.lua:1702, gewist in NativeArrow.lua:926-927.
- `ns._mhCrazyArrowUid`: gezet in Delves.lua:1863, gelezen in 1763.
- `ns._mhLastRoutedRareQuest`, `_mhRarePrevOwner`, `_mhRarePrevLead`: Rares.lua 1817-1837, 3203-3206, 3253; NativeArrow.lua:951, 1043.
- `ns._mhSelfWaypointOp`: Core.lua:955-959, 981.

---

## 5. Handlers op zonewissel en aankomst

### 5a. Wat er gebeurt na één ZONE_CHANGED_NEW_AREA of PLAYER_ENTERING_WORLD

| Moment | Handler | Plek | Wat het met de pijl doet | Status |
|---|---|---|---|---|
| 0 s | MountRun zone-frame (ook ZONE_CHANGED en ZONE_CHANGED_INDOORS) | MountRun.lua:516-531 | eigenaar ≠ `mountrun` → route vergeten; in instance → eigenaar `nil` + TomTom wissen | GEMETEN |
| 0 s | Delves bridge: `ClearDelvePoiCache` | Delves.lua:3865-3867 | niets aan de pijl | GEMETEN |
| 0 s | Rares ev | Rares.lua:3248-3283 | `UpdateRareArrivalWatch`, scan; bij QUEST_LOG_UPDATE vrijgeven/terugzetten | GEMETEN |
| 0 s | DelveChestData resetter (alleen PLAYER_ENTERING_WORLD) | DelveChestData.lua:612-617 | wist bezocht- en overgeslagen-lijsten | GEMETEN |
| **0,7 s** | `legRetry` | DelveTipMarkup.lua:826-872 | `RouteFirstToFlightPoint(lastTarget)` → kan TomTom + `lastTarget` naar een deur, portaal of vliegmeester verzetten en een tussenstap starten. Slaat over bij `mountrun`, `noTravelAdvice`, een lopende stap, een instance of `arrivesOn == hier` | GEMETEN |
| **0,7 s** | Achievements `ScheduleTravelRefresh` | Achievements.lua:1320-1340, 1386-1387 | `AddSmartTomTomWay(…, travelOnly)`: schrijft `lastTarget` opnieuw (Delves.lua:1839 staat vóór de `travelOnly`-poort) en kan de popup tonen | GEMETEN |
| **1,0 s** | Delves `runZoneNavCheck` | Delves.lua:3903-4010 | `arrivesOn` of ≤ 400 yd → "ROUTE_FINISHED" in chat, `lastTarget = nil`, eigenaar `waypoint`/`delve` → `nil`, TwoStep stoppen. Anders TomTom-waypoint opnieuw zetten (+0 s en +0,5 s) of Blizzard-waypoint | GEMETEN |
| **1,0 s** | MountRun volgende stap | MountRun.lua:533-541 | `CurrentStep` → `ShowStep` → `PointAt` | GEMETEN |
| **1,2 s** | Profession `TreasureUpdateArrow` | Profession.lua:1446-1447 | nieuwe dichtste schat; `SetCrazyArrow` of `AddSmartTomTomWay` + popup | GEMETEN |
| **2,0 s** | ResetRoutine `ReassertRoute` | ResetRoutine.lua:1732-1743, 1693-1705 | `IssueRoute` → `AddSmartTomTomWay` **mét** reishulp + `lastTarget` | GEMETEN |
| PLAYER_UNGHOST/ALIVE +1,5 s | RitualSites `ReassertRouteAfterRevive` | RitualSites.lua:704-714, 254-274 | `RouteSite(…, quiet)`; **geen eigenaar-check** | GEMETEN |
| speler wist TomTom | Core-hook | Core.lua:980-990 | `ClearActiveRoute` | GEMETEN |

AFGELEID volgorde-effecten:
- `legRetry` (0,7 s) draait vóór `runZoneNavCheck` (1,0 s). Als `legRetry` `lastTarget` naar een tussenstap verzet, beoordeelt de aankomst-check daarna die tussenstap en niet het eigenlijke doel.
- Staat de tussenstap binnen 400 yd, dan verklaart `runZoneNavCheck` "route klaar". Intussen loopt de vliegstap-wachter gewoon door (hij kent die verklaring niet).
- De `arrivesOn`-wacht zit in beide handlers, maar alleen één pin zet `arrivesOn`.

### 5b. Tikkers die routes raken

| Tikker | Plek | Interval | Loopt wanneer | Status |
|---|---|---|---|---|
| NativeArrow `Tick` | NativeArrow.lua:1096-1098 | 1,0 s | altijd | GEMETEN |
| NativeArrow `OnUpdate` → `UpdateArrow` | NativeArrow.lua:694-701 | 0,03 s | zolang het frame zichtbaar is | GEMETEN |
| `legWatcher` | DelveTipMarkup.lua:478 | 1,5 s | zolang `pendingLeg` bestaat | GEMETEN |
| TwoStep `Tick` | TwoStepRoute.lua:214-231, 276-279 | 1 s (After-keten) | max 300 s | GEMETEN |
| MountRun `viaTicker` | MountRun.lua:303-319 | 0,5 s | stap met `via` | GEMETEN |
| Achievements RareWatch | Achievements.lua:1224 | 2 s | achievement-route actief | GEMETEN |
| Profession treasure | Profession.lua:1524 | 2 s | schattenjacht | GEMETEN |
| ResetRoutine dwell | ResetRoutine.lua:1640 | 2 s | reset-route of losse pin | GEMETEN |
| DelveChestData | DelveChestData.lua:551 | 2 s | chest-route | GEMETEN |
| QuickBar | QuickBar.lua:500-511 | 2 s | altijd (tekent alleen de knop) | GEMETEN |

### 5c. Elf verschillende "aangekomen"-drempels

| Drempel | Waar | Status |
|---|---|---|
| TomTom `cleardistance` 15 (standaard), 0 voor vliegstap/schat/kist/achievement-forceer, `arrivaldistance` 15 (portaalknop) | Delves.lua:1858, 3989, 4383; DelveTipMarkup.lua:548, 794; Profession.lua:1508; DelveChestData.lua:487; Achievements.lua:1175 | GEMETEN |
| ≤ 20 yd → eigenaar `delve`/`waypoint` vrij | NativeArrow.lua:1034, 1073 | GEMETEN |
| < 12 yd groene pijl; 40 yd rare-aankomst; 80 yd aankomst-hint; < 2 kaarteenheden "je staat erop" | NativeArrow.lua:549, 38, 295, 387 | GEMETEN |
| 22 yd of 1,2 kaart-% (deur, TwoStep) | TwoStepRoute.lua:32, 53 | GEMETEN |
| < 25 yd of "weggelopen" (deur, tussenstap) | DelveTipMarkup.lua:513 | GEMETEN |
| < 0,3 kaart-% (deur, MountRun) | MountRun.lua:314 | GEMETEN |
| 22 yd (reset-dwell) | ResetRoutine.lua:1576 | GEMETEN |
| 25 yd (achievement-lead), 60 yd (rare weg) | Achievements.lua:1255, 1296 | GEMETEN |
| **400 yd** (route klaar na een zonewissel) | Delves.lua:1266, 1560 | GEMETEN |
| < 300 "yd" (`dist × 45`) → geen Hearthstone-knop | Delves.lua:2007, 2040 | GEMETEN |
| vlucht moet < 75% van rechtstreeks zijn; Windcaller-hop moet ≥ 10 kaarteenheden schelen | DelveTipMarkup.lua:782; TravelPlan.lua:672 | GEMETEN |

---

## 6. Startpunten die een speler kan klikken

"Deur" = via `ns.AddSmartTomTomWay` (level-waarschuwing, reishulp, eigenaar). "Bypass" = zet zelf een waypoint.

| Startpunt | Plek | Eindigt in | Pad | Status |
|---|---|---|---|---|
| Delve-rij (links of rechts klikken) | Delves.lua:2624-2627 | `RouteToDelveRow` → deur + `delve` | deur | GEMETEN |
| Knop "dichtste bountiful" / "dichtste delve" | Delves.lua:4196, 4201 | `RouteNearestDelve` → deur + `delve` | deur | GEMETEN |
| Popup: portaalknop | Delves.lua:4375-4405 | `TomTom:AddWaypoint` of `SetBlizzardUserWaypoint` | **bypass** (geen eigenaar, geen `lastTarget`) | GEMETEN |
| Popup: Hearthstone / magier-teleport / magier-portaal | Delves.lua:4336-4345, 4422-4446 | secure macro (geen route) | — | GEMETEN |
| SMC-pin | UI.lua:2600-2602 | `SetSMCWaypoint` (eigen pad + TwoStep + `ShowTravelAssistFor`) | **bypass** | GEMETEN |
| SMC-pin, acties | UI.lua:1543-1607 | instance → `RouteDungeonEntrance`; `nearest_fp` → `RouteToNearestFlightPoint`; `worldboss_week` → `RouteToActiveWorldBoss`; `ritual_site` → `RouteRitualSite`; `void_hub` → `RouteVoidHub` | deur, behalve `nearest_fp` (bypass) | GEMETEN |
| Dawncrest-, Professions-gids | DawncrestGuide.lua:653-664; ProfessionsGuide.lua:809-810 | `SetSMCCityWaypoint` → `SetSMCWaypoint` | bypass | GEMETEN |
| Mount run "Route" | MountRun.lua:771-775 | `MountRunStartRoute` → `PointAt` → deur(`skipTravelUI`) + `mountrun` | deur, reishulp uit | GEMETEN |
| Rare-rij / dichtste / genereer / toast / zoekbalk | Rares.lua:2466, 2762, 2772, 2974; NavSearch.lua:512 | `RouteRare` / `RouteToNearestRare` / `GenerateRaresRoute` / `GoToRare` → deur + `rare` | deur | GEMETEN |
| Achievement: kaartknop, rij-waypoint, toast-knoppen, dichtste open, Codex-route, zoekbalk, `/mh treasures` | Achievements.lua:2186-2193, 2273-2288, 750-754, 2422; MidnightCodex.lua:460-461; NavSearch.lua:555-558; Achievements.lua:2627-2634 | `RouteAchievementTreasures` (`IssueRoute`, eigenaar `achievement`) of direct de deur | deur (+ `ForceArrowToLead` bypass) | GEMETEN |
| Profession-rij / genereer schatten of boeken | Profession.lua:973, 978, 1563, 1567 | `ClearTomTomAndAddSingleWaypoint` → deur; `RunTomTomGenerate` → TomTom-pins + tikker | deur / **bypass** | GEMETEN |
| Home: reset-route, wereldbaas, campagne, ritual, void | HomeDashboard.lua:530-535, 676-681, 744-750, 900, 928 | `StartResetRoute`, `RouteToWorldBoss`, `RouteCampaignLeadIn`, `RouteRitualSite`, `RouteVoidHub` | deur | GEMETEN |
| Routine-rijen (losse pin, ritual, quest) | ResetRoutine.lua:1077, 1088, 1109, 1121, 1151, 1187, 1205, 1229, 1245, 1333, 1343, 1378 | `RouteSingle` / `RouteRitualSite` / `RouteRitualHub` / `AddSmartQuestRoute` | deur | GEMETEN |
| World-tab | WorldContent.lua:490, 515, 662, 670 | `RouteRitualHub`, `RouteRitualSite`, `RouteShowdownIntro`, `RouteShowdownPortal` | deur | GEMETEN |
| Ritual-paneelrij | RitualSites.lua:570 | `RouteSite` | deur | GEMETEN |
| Wereldbaas (paneel + gids) | WorldBoss.lua:689; Addons/Guide.lua:413, 416, 477, 480 | `RouteToActiveWorldBoss` → `RouteToWorldBoss` | deur | GEMETEN |
| Dungeon-/raidgids | DungeonGuide.lua:589; RaidGuide.lua:346 | `RouteDungeonEntrance` | deur | GEMETEN |
| Bossvenster "Route" | DungeonBossWindow.lua:868-879 | deur (terugval Blizzard) | deur | GEMETEN |
| Delve Coach "kisten" | DelveCoach.lua:1051-1054 | `RouteDelveChests` → deur + `delvechest` | deur | GEMETEN |
| Currency-gids: Quartermaster | CurrencyGuide.lua:226 | `SetQMWaypoint` (deur, terugval slash/native) | deur | GEMETEN |
| Omnium Folio-link / Catalyst-link | OmniumFolio.lua:539-543; TierSet.lua:408-412 | `SetFolioStartWaypoint` / `SetCatalystWaypoint` (deur, terugval) | deur | GEMETEN |
| Craft-boodschappenlijst | CraftShoppingList.lua:773, 775, 833 | `RouteToPlace` / `RouteToTrainer` | deur | GEMETEN |
| Professions-cursus / gids / hub | ProfessionCourseWindow.lua:411; ProfessionGuided.lua:496; ProfessionsHub.lua:398-400 | `MH_RouteChapterWaypoint`, `RouteWaypoint`, deur | deur | GEMETEN |
| Mounts-paneel / Events-paneel / Trading Post / Vault-popup | MountsPanel.lua:419-423; EventsPanel.lua:210-214; TradingPost.lua:673; VaultReminder.lua:322-328 | deur (`AddSmartQuestRoute` bij events; `skipTravelUI` bij de vault) | deur | GEMETEN |
| `{WAY}`-link in een tekstvak | DelveTipMarkup.lua:984-988 (in 10 modules, §2.2) | `SetMapWaypoint` → deur + `ReportWaypointResult` | deur | GEMETEN |
| `{WAY}`-link in chat (`/mh plan`, `/mh keys`) | TravelPlan.lua:723; CorrosiveCodexHunts.lua:219-222 | **geen handler gevonden** | — | AFGELEID dat de klik niets doet |
| QuickBar-routeknop (links: skip, rechts: clear, shift: plan) / FP-knop | QuickBar.lua:307-331, 333-349 | slash `skip`/`clear`/`plan`; `RouteToNearestFlightPoint` | — / bypass | GEMETEN |
| Rechtsklik op de eigen pijl | NativeArrow.lua:622-626 | `ClearActiveRoute` | — | GEMETEN |
| Toetsen | Core.lua:913-921, 1001-1005 | rare/knoop overslaan; `ClearActiveRoute` | — | GEMETEN |
| Slash `/mh goto x y` | Core.lua:1883-1918 | `SetBlizzardUserWaypoint` + `lastTarget` + `waypoint` | **bypass** | GEMETEN |
| Slash `/mh fp`, `/mh plan`, `/mh mountrun`, `/mh clear` | Core.lua:1861, 1666, 2226, 2761 | zie boven | — | GEMETEN |
| Diagnose (start geen route) `/mh arrow`, `/mh arrow yield`, `/mh travelwhy`, `/mh portals`, `/mh trail`, `/mh here`/`coord`, `/mh flightpins` | Core.lua:2369, 2115, 1405, 1768, 1655/2890, 1306 | `PrintArrowStatus`, `ToggleArrowYield`, `PrintTravelPopupDecision`, `PrintPortalAccess`, `PrintFarstriderProbe`, spot-log, `PrintFlightPins` | — | GEMETEN |
| Campagne: quest geaccepteerd | CampaignLeadIn.lua:511 e.v. | `C_SuperTrack.SetSuperTrackedQuestID` | **bypass** (game-pijl) | GEMETEN (start); verder niet gelezen |

---

## 7. Wat een centrale module zou moeten dekken (alleen inventaris, geen ontwerp)

**Data**
- Portalen: van-kaart, naar-kaart, x/y, quest-poort, `door`, `zone`-slice, `arrivesOn`, vertaalde naam.
- Hubs: Silvermoon, The Den (mond en binnen), Voidstorm-hub, Tokka's Landing, hoofdsteden 84/85, oude-wereld-hubs uit MountRun.
- Deuren en ingangen: SMC-deur, portaalkamer-deur, Underbelly-ingang, live map-links (`C_Map.GetMapLinksForMap`), dungeon/raid-ingangen (eigen data + `C_EncounterJournal.GetDungeonEntrancesForMap`).
- Gossip-hops: Amani Windcallers.
- Vliegpunten met factie, netwerkcomponenten, geleerde vliegkaart-pins.
- Hearthstone: bind-check, herberg-gebieden, item 6948, toys, cooldown.
- Magier-spells (1259190 / 1259194).
- Delve-ingangen.
- Silvermoon-bestemmingen die nu in ± 10 modules los staan.

**Geografische vragen** (nu op meerdere plekken beantwoord)
- Op welke kaart sta ik? Dit is inclusief de slice van canvas 2576.
- Ligt de ene kaart in de andere? Er zijn **9 ouder-keten-lopers**: NativeArrow `ParentMap`/`OneContainsTheOther`, Delves `GetBaseZoneName`, `GetRegionGroupID`, `MapHasAncestor`, `MHSameZoneOrSub`, `MapWithAncestors`, MountRun `InMap`, `ContinentOf`, Core `MHResolveWaypointMap`. GEMETEN.
- Regio, continent, "in de stad zelf", "in Midnight", hoofdstad van de factie.
- Level-poort: er zijn twee modellen. `WarnZoneLevelIfNeeded` waarschuwt alleen (ZoneLevelGate.lua:222). `MidnightFloorMet` weigert bij SMC-pins (ResetRoutine.lua:439, UI.lua:1623). GEMETEN.

**Afstand**
- Wereld-yards, kaartgrootte, kaartprocent.
- Er zijn ± 10 losse "map → wereld"-helpers (§1b-5). GEMETEN dat er meer dan 8 zijn.
- De drempels uit §5c.

**Plannen**
- Portaalkeuze, met hub-terugval.
- Hoofdstad-stap.
- Vliegstap met netwerkcheck en 75%-regel.
- Deur eerst, gossip-hop.
- Hearthstone + portaal.
- Deuren binnen een kaartketen.
- Oude-wereld-stappen (MountRun).
- Quest-waypoint volgen (`AddSmartQuestRoute`).

**Uitvoeren**
- Tussenstap-machine (`pendingLeg`).
- Deur-overdracht: drie varianten.
- Opnieuw plannen bij een nieuwe kaart.
- SMC tweestaps.
- MountRun-stappen + `via`.
- `arrivesOn`, "route klaar", opnieuw proberen na een zonewissel.
- Herstellen na een laadscherm of na dood.

**Uitvoer-kanalen**
- TomTom (waypoint + crazy arrow + `/way`-slash).
- Blizzard user-waypoint + SuperTrack: één gedeeld slot, 11 schrijvers (§2.10).
- Eigen pijl (kleur per eigenaar).
- Reis-popup met secure knoppen (gevecht, instance).
- Chatregels: hint, "route klaar", "tussenstap klaar", "niet op dit continent".
- Vliegkaart-markering.
- Quest-super-track.

**Eigendom en levenscyclus**
- Eigenaar-tokens (§4).
- Beheerde routes tegenover een losse klik.
- Rare-omweg en terugkeer.
- Wissen (`ClearActiveRoute` + TomTom-hook), plus de toestand die wissen nu niet bereikt (§1b-4).

**Diagnose**
- `/mh arrow`, `/mh travelwhy` (+ `ns.db.travelWhy`), `/mh portals` (+ `ns.db.portalBindProbe`), `/mh plan`, `/mh trail`, `/mh here`/`coord`, `/mh flightpins`, `SmcTwoStepStatus`.

**Andere addons**
- TomTom: aanwezig, pijl zichtbaar, 4 s respijt.
- WaypointUI-wijken.
- Zygor: alleen gemeld.
- FarstriderLib: alleen gemeten.

**Randvoorwaarden**
- Combat lockdown.
- Instances: geen popup, pijl verborgen.
- Laadschermen: kaart is even nil.
- Secret values.
- Kaartnamen uit de client: 7 talen + esMX.

---

## 8. Niet gemeten / open (eerlijk opgesomd)

- Of `C_Map.GetWorldPosFromMapPos(2393, UiMapPoint)` echt nil geeft en met `CreateVector2D` wél werkt (§1b-5). **Eén `/dump` in Silvermoon beslist het.** AFGELEID.
- Of `mhway`-links in chat iets doen bij een klik (§2.1). AFGELEID: nee.
- Of 2393 en 2576 dezelfde coördinatenruimte hebben voor de Silvermoon-rijen, en 2405 en 2576 voor Voidstorm (§3b). Niet gemeten.
- Of de chest-route in een delve zonder TomTom een pijl toont (§2.11). AFGELEID: nee.
- Volgorde van handlers met dezelfde vertraging (bijvoorbeeld de twee op 1,0 s). WoW garandeert die niet. Niet gemeten.
- Niets in `docs/` gelezen. Mogelijk zijn sommige punten hier al bekend of opgelost in `NEXT_SESSION.md`. Dat is niet gecontroleerd.
