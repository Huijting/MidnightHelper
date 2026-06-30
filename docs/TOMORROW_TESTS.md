# Achievements-feature — waar we staan & wat we morgen testen

_Laatste sessie: treasure-routes voor Midnight-achievements. Alles is gecommit._

## Wat er nu staat
- **Prestaties-tab** (room: Me / This Week) met 4 treasure-achievements, data-gedreven:
  Eversong, Harandar, Zul'Aman, Voidstorm. Per kaart: voortgang (x/total),
  Route-knop, uitklapbare checklist met per-treasure Waypoint-knop.
- **`/mh treasures`** kiest de zone waar je staat; routet nearest-first;
  schuift automatisch door zodra je een treasure loot.
- **Toast** (hint voor meerstaps-treasures): sleepbaar, Shift+scroll schaalbaar,
  knoppen naar de chest + prereqs (items/altaren/orbs), en **sluit vanzelf**
  zodra die treasure klaar is (ook handmatig geopend).
- **Done-detectie** via de achievement-criteria-API (matcht WoW exact).
- **Pijl-gedrag** gelijkgetrokken met de Rares-route: waypoint één keer zetten,
  geen SuperTrack-hijack, geen heruitgave bij zone-wissel → pijl blijft staan.
- **Sub-area fixes**: Blizzard-backup lost op naar een waypoint-bare ouder-map
  (Core.lua); reisassistent matcht portals van de ouder-zone (Delves.lua).
- **travelOnly-modus**: bij zone-wissel ververst alleen het reisadvies
  (volgende etappe) zonder de pijl aan te raken.

## Morgen testen
1. **Pijl blijft staan**: route vanuit SMC naar een treasure → TomTom-pijl
   blijft de hele reis staan over zone-grenzen (zoals de rares-route).
2. **Portal-advies eerste route**: naar Harandar én Voidstorm → beide tonen
   portal-advies (Voidstorm ook als de dichtstbijzijnde Stellar Stash in
   Slayer's Rise is).
3. **Advies per etappe**: Zul'Aman → hearth → SMC → "Portal to Voidstorm"
   verschijnt vanzelf bij aankomst (geen her-klik nodig).
4. **Sub-area pijl**: route naar Stellar Stash / Scout's Pack (Slayer's Rise
   2444) → krijgt nu een pijl (via ouder-map), niet "helemaal niks".
5. **Toast sluit vanzelf** na voltooien van zijn treasure.
6. **Meerstaps-knoppen kloppen**: Gift of the Cycle (item+altaar), Zul'Aman
   Honored Warrior's Cache (4 urnen) + Sealed Twilight Blade (4 orbs),
   Voidstorm Void-Shielded Tomb / Malignant Chest.
7. **Aantallen matchen WoW**: x/total per achievement. Let op: Voidstorm toont
   **13** — criterium 111865 zit niet in HandyNotes; check of WoW er 14 lijst.

## Bekende WoW-restrictie (geen bug)
- Hearthstone werkt niet in flight form — even landen, dan opnieuw klikken.

## Volgende slices (nog te doen)
- Midnight **Lore Hunter** (LoreObject-nodes).
- Midnight: **The Highest Peaks** (telescopen → renown).
