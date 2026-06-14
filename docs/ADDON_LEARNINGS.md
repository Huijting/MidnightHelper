# Learnings uit andere addons (techniek + API's, GEEN code)

Verzamelplek voor wat we leren door geïnstalleerde addons door te pluizen. Steeds
dezelfde posture: **aanpak en feitelijke API's overnemen, nooit code kopiëren**,
en een feit pas hard maken na in-game bevestiging (never-lie).

| Addon | Licentie | Status | Notitie |
|---|---|---|---|
| RitualAlert | geen (ARR) | bekeken (12 jun) | emote-listener-aanpak → idee in TOMORROW.md |
| Broker_MidnightEvents | GPL-2.0 | absorptie loopt | zie BROKER_ABSORPTION_PLAN.md |
| **Kaliel's Tracker** | **geen (ARR)** | **bekeken (14 jun)** | dit document |

---

## Kaliel's Tracker (v8.6.1, Marouan Sabbagh) — 14 juni

Volwassen objective-tracker-replacement (~44k regels, Ace3-gebaseerd). **Geen
LICENSE-bestand → all rights reserved.** We willen de tracker NIET vervangen;
we lenen losse technieken. De vijf bruikbaarste:

### 1. Native "next waypoint" routing ⭐ (grootste meerwaarde)
KT gebruikt Blizzards eigen objectief-waypoint i.p.v. hardcoded coords:
- `C_QuestLog.GetNextWaypoint(questID)` → **mapID, x, y** van het volgende
  objectief van een quest.
- `C_QuestLog.GetNextWaypointText(questID)` → de bijbehorende tekst.
- `C_ContentTracking.GetNextWaypointForTrackable(type, id, mapID)` → idem voor
  trackable content (achievements e.d.).

**Toepassing bij ons:** onze route-knoppen (Ritual/Void/weeklies) zetten nu vaste
hub-coords. Voor een quest die in je log staat kunnen we i.p.v. dat de **echte
volgende-objectief-waypoint** pakken — preciezer, en zelf-updatend per stap.
Mooi voor de "route naar de weekly"-knoppen en de Reset-routine.

### 2. SuperTrack-API (schonere native routing)
- `C_SuperTrack.SetSuperTrackedQuestID(questID)` / `GetSuperTrackedQuestID`
- `C_SuperTrack.SetSuperTrackedMapPin(...)` / `GetSuperTrackedMapPin`
- `C_SuperTrack.GetHighestPrioritySuperTrackingType()` / `ClearAllSuperTracked`

**Toepassing:** naast onze TomTom/Blizzard-waypoint-keten kunnen we een quest of
map-pin native "supertracken" (de blizzard-pijl/afstand). Lichter dan een user-
waypoint als we alleen willen highlighten wat er getrackt is.

### 3. Tiered Entrance / World Tier-scenario-API ⭐ (direct voor 12.0.7)
TOC heeft `## Dependencies: Blizzard_TieredEntranceTraits`. KT gebruikt:
- `C_ScenarioInfo.IsTieredEntranceScenario()`
- `C_ScenarioInfo.GetTieredEntranceActiveSpells()`

**Toepassing:** dit is precies de API achter **Heroic World Tier** (12.0.7
Showdowns) én waarschijnlijk de Delve/Ritual-tiers. Hiermee kan onze coach
betrouwbaar detecteren *welke tier* actief is (Normal/Heroic) i.p.v. te gokken —
relevant voor de Showdowns-sectie en de Delve/Ritual-coach.

### 4. Scenario-criteria per stap (verrijkt onze coaches)
- `C_Scenario.GetInfo()` · `GetStepInfo()` · `IsInScenario()` ·
  `ShouldShowCriteria()` · `GetSupersededObjectives()` · `GetBonusSteps()` /
  `GetBonusStepRewardQuestID()`
- `C_ScenarioInfo.GetCriteriaInfoByStep(stepID, criteriaIndex)` (wij gebruiken nu
  alleen `GetCriteriaInfo`) · `GetDisplayInfo()`

**Toepassing:** onze RitualBossCoach/Delve-coach leest stages al via
`C_ScenarioInfo`. Met `GetCriteriaInfoByStep` + `ShouldShowCriteria` kunnen we per
stage de criteria/voortgang tonen ("doel 2/3") en bonus-stappen herkennen —
zonder ENCOUNTER_START nodig te hebben (sluit aan op onze stage-trigger-aanpak).

### 5. Quest-voltooiing & "turn in!"-status (voor weekly-status per event)
- `C_QuestLog.IsComplete(questID)` → objectieven klaar maar nog niet ingeleverd
  (= de amber "turn in!"-status die Broker ook toont).
- `C_QuestLog.GetLogIndexForQuestID` · `GetTitleForQuestID` · `IsQuestBounty` ·
  `GetQuestRewardCurrencyInfo` · `AddQuestWatch`/`RemoveQuestWatch`.

**Toepassing:** dit is de bouwsteen voor de **"weekly-status per event"**-feature.
Met onze nu-gedataminede weekly-quest-IDs (Stand Your Ground 94581, Lost Legends
89268, Showdown on Val 96716, Fortify the Runestones 90573-90576, …; zie
PTR_12.0.7_DATA.md) + `IsQuestFlaggedCompleted` (af) en `IsComplete` (klaar om in
te leveren) tonen we per event in de Events-tab: open / in-progress / turn-in /
done. Precies het driestaten-model dat Broker gebruikt.

### Taint
KT doet géén secret-widget-arithmetic (alleen `InCombatLockdown`-guards); een
tracker leest die secret widget-bars niet. Bevestigt onze keuze: wij isoleren
secret-reads in de EventScheduler-ticker, zij vermijden ze simpelweg.

### Niet overnemen
- De hele tracker-replacement-scope (Ace3 + eigen ObjectiveTrackerModule). Te
  groot, en buiten onze scope; we willen alleen de losse technieken hierboven.
