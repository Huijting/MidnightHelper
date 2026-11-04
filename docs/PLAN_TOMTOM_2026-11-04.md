# Plan: TomTom 4.4.0 beter gebruiken (4 nov 2026)

Rob: *"kunnen we misschien iets leren van de nieuwe tomtom versie?"* → *"Ja, plan 1 en 2"*.

TomTom 4.4.0 kwam op 4 nov binnen via CurseForge (Rob heeft auto-update aan). Hij heeft een nieuw stuk "voor addon-makers"
in zijn README. Dit plan gebruikt alleen die openbare knoppen.

⚠️ **TomTom is "All Rights Reserved"**. GEMETEN in de kop van `core/suppress.lua` en `core/callbacks.lua`. We nemen dus
geen code over. We roepen alleen functies aan die TomTom zelf openzet (README "Supported Addon API").

## Wat er nu is (GEMETEN in MH)

- **"Speler stopt de route"** ziet MH alleen via een `hooksecurefunc` op `TomTom:ClearAllWaypoints`
  (`Core.lua:1016-1036`, de vlag `ns._mhSelfWaypointOp` scheidt dat van onze eigen wis-acties).
  - Wist de speler één pijl (rechtsklik → Remove waypoint), dan merkt MH niets. De route blijft dan "aan" staan.
- **Of TomTom's pijl leeg is** vraagt MH steeds zelf, met `IsCrazyArrowEmpty`:
  - `NativeArrow.lua:226` en `:1022`;
  - de wake-up-tikker van één seconde, `TravelRoute.lua:1370-1451`.
- **De fout met de "dode" pijl van 16 okt zit nog steeds in 4.4.0.** GEMETEN in `core/waypoints.lua`:
  - `ClearAllWaypoints` (r. 151) doet alleen `ClearWaypoint`. De pin blijft dan in `TomTom.waypoints` staan.
  - `AddWaypoint` (r. 434-438) geeft voor dezelfde kaart/x/y/titel die oude uid terug.
  - Onze reparatie in `Core.lua:977-999` (`RemoveWaypoint` per pin) **blijft dus nodig**.

## Wat TomTom 4.4.0 nu biedt (GEMETEN in de code, niet alleen in de README)

- `TomTom.RegisterCallback(owner, event, handler)` (CallbackHandler), `core/callbacks.lua`.
  - **`ArrowTargetChanged(uid)`**: vuurt bij elke wissel van het doel, en met `nil` als het doel verdwijnt.
    - `ClearWaypoint` → `TOMTOM_WAYPOINT_REMOVED` → `ClearTarget()` → `nil`.
    - Dat gebeurt dus ook bij "clear all", bij "Remove" uit het menu, **en bij aankomst**: TomTom haalt de pin zelf weg op
      `cleardistance`.
  - `WaypointRemoved(uid)`: alleen bij `RemoveWaypoint` en bij een reload, **niet** bij `ClearWaypoint` (r. 334/188 tegen
    r. 96-101). Hiervoor is hij dus minder geschikt.
- `TomTom:SuppressFeature(owner, feature)` / `ReleaseFeature`, `core/suppress.lua`.
  - Het geldt alleen voor die sessie, en de instellingen van de speler blijven heel.
  - In het optievenster van TomTom staat dan "Controlled by Midnight Helper".
  - **`"arrow.setclosest"`**: als het doel weg is, springt de pijl niet meer naar de dichtstbijzijnde andere pin
    (`ShouldSetClosest`, `crazy_arrow.lua:327-337`).
  - `"poi"` zet de questpijl-module uit. **Die gebruiken we NIET**, zie "Bewust niet".
- Een onbekende feature-naam geeft een **error** (`CheckFeature`). Daarom: altijd eerst `TomTom.SuppressFeature` testen, en
  altijd `pcall`.

## Stap 1: luisteren in plaats van raden

1. **Eén plek voor de koppeling.** Bij `PLAYER_LOGIN`, en alleen als `type(TomTom.RegisterCallback) == "function"`:
   registreer `ArrowTargetChanged` met owner `"MidnightHelper"`.
   - Een oude TomTom heeft deze functie niet. Dan blijft alles zoals nu: de hook op ClearAllWaypoints plus het pollen.
2. **`ArrowTargetChanged(nil)` met een MH-route actief, en niet tijdens onze eigen wis-actie** (`ns._mhSelfWaypointOp`):
   - **Bij aankomst:** de speler staat binnen ~`cleardistance + 10` yd van het doel van de route (`ns.lastTarget` /
     `activeLead`). Dan doet de stap niets: de route-code zelf gaat door naar de volgende stap, zoals nu.
   - **Anders:** de speler heeft het doel weggehaald → `ns.ClearActiveRoute()`, net als de huidige hook doet bij "clear all".
     Plus één regel in de chat dat de route gestopt is.
   - ⚠️ De drempel en de afstandsmeting nemen we over van de bestaande `tomtomArrived`-regel (`ns.Travel.NEAR`). We verzinnen
     geen nieuw getal.
3. **`ArrowTargetChanged(uid)` met een andere uid dan `ns._mhCrazyArrowUid`, terwijl een route loopt:** een andere addon of
   de speler zette iets anders op de pijl. In stap 1 **alleen loggen** (`travelRouteLog`), nog niets doen. Eerst kijken hoe
   vaak het voorkomt.
4. **De hook op ClearAllWaypoints blijft staan** als terugval. Met de callbacks erbij zou "clear all" de route twee keer
   stoppen. `ClearActiveRoute` mag twee keer draaien (doet dan niets), maar dat meten we na.
5. **Het pollen blijft in stap 1.** De callbacks komen er alleen bij, voor het gat "één pin weg". Pas als Rob het getest
   heeft, kijken we of de wake-up-tikker minder vaak kan.
6. **Diagnose** (regel uit CLAUDE.md "Bouw je iets dat kan zwijgen"): `/mh arrow` krijgt een regel erbij:
   - "TomTom callbacks: yes/no";
   - wat de laatste `ArrowTargetChanged` was, met tijd en reden (aankomst / speler / eigen wis-actie).

## Stap 2: TomTom niet laten wegspringen tijdens onze route

1. **Zodra een MH-route de pijl claimt** (`ns._mhRouteOwner` wordt gezet): `pcall(TomTom.SuppressFeature, TomTom,
   "MidnightHelper", "arrow.setclosest")`, alleen als die functie bestaat.
2. **Zodra de route echt klaar is** (`ns._mhRouteOwner = nil`, in `ClearActiveRoute` en waar elke route afloopt):
   `ReleaseFeature`. Daarna geldt de instelling van de speler weer.
   - ⚠️ `_mhRouteOwner` wordt op 7 plekken gezet (GEMETEN: UI.lua, Core.lua, Delves.lua ×3, TravelPlaces.lua,
     FlightPointsData.lua). Niet op 7 plekken de suppress-regel plakken. Liever één kleine functie
     `ns.SetRouteOwner(owner)` die de toestand bijhoudt, of één tikker die `_mhRouteOwner` vergelijkt met de vorige keer.
     Welke van de twee, beslissen we bij het bouwen. Het moet in ieder geval **één** plek zijn.
3. **Waarom:** als TomTom ons doel weghaalt (aankomst), springt hij nu naar de dichtstbijzijnde andere pin. Dat kan een oude
   pin van de speler zijn, of een HandyNotes-pin. Dan wijst de pijl even de verkeerde kant op, tot onze route de volgende
   stap zet.
   - ⚠️ **AFGELEID**, niet gemeten: of dit bij Rob ooit zichtbaar gebeurde. Een `/mh arrow`-log na een route laat het zien.
4. **Diagnose:** `/mh arrow` laat zien of MH `arrow.setclosest` nu tegenhoudt.

## Bewust niet

- **`"poi"` (de questpijl) niet automatisch uitzetten.** Dat is iets wat de speler zelf kiest
  ([[players-choose-not-us]]). Botst het in de praktijk, dan eerst een schakelaar voorstellen.
- **Geen `HijackCrazyArrow`.** Dan zouden wij de pijl van TomTom besturen. Dat is precies wat "TomTom houdt de pijl" belooft
  níét te doen.
- **De afstandsmeldingen (punt 3 van 4 nov)** komen later. Onze aankomst-logica werkt en is getest.

## Testen (Rob)

Beide stappen, met TomTom 4.4.0 aan:
1. Typ in de zoekbalk **ah** en klik op Auction House. Rechtsklik op de TomTom-pijl → **Remove waypoint**. MH hoort te
   zeggen dat de route gestopt is, en mag de pijl niet terugzetten na een zonewissel.
2. Doe een route met meerdere stappen, bv. een rare-route of een reis naar een andere zone. Bij aankomst op een tussenstap
   hoort de route gewoon door te gaan en **niet** te stoppen.
3. `/tomtom` → Waypoint Arrow: tijdens een MH-route hoort bij "set closest" te staan: *Controlled by MidnightHelper*.
   Na de route niet meer.
4. Een oude TomTom kunnen we niet testen. Daarom vangen alle aanroepen af of de functie bestaat (code lezen).
