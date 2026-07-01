# CurseForge release 2.2.0 — copy/paste

**Upload:** `dist/MidnightHelper-2.2.0.zip` (build with `tools\package.ps1`).
**Description:** route arrow now works standalone (no TomTom needed): Midnight Helper drives the game's own waypoint + on-screen navigation, keeps it on your next open stop, and advances it on arrival. Also a safety net when TomTom's arrow drops, the weekly/reset route tours every stop (and auto-learns rotating giver weeklies), and the cross-zone re-point no longer borrows HereBeDragons.

> ⚠️ **Vóór upload:** in-game `/reload`-test met Lua-errors aan — geen fout bij login, changelog-popup toont **2.2.0** bovenaan. Test met én zonder TomTom (zie testlijst).

---

## Short summary (one line)

Midnight Helper 2.2.0 makes route guidance standalone: the arrow now works without TomTom by driving the game's own map waypoint and on-screen navigation, keeping it on your next open treasure/rare/reset stop and advancing it the moment you arrive. If TomTom is installed but its big arrow drops out, the built-in waypoint takes over as a safety net; when TomTom's arrow is working it stays fully out of the way. Cross-zone re-pointing no longer relies on another addon's HereBeDragons.

---

## Changelog — paste below (since 2.1.1)

### 2.2.0 — 2026-07-01

Standalone route guidance — the arrow no longer depends on TomTom.

#### Fixed

- **Route arrow works without TomTom.** The "arrow survives arrival / advances to the next stop" behaviour used to be TomTom-only; without TomTom you got a single Blizzard waypoint with no keepalive, so it vanished on arrival and never advanced. Midnight Helper now drives the game's native user waypoint + SuperTrack itself, follows the active route lead, re-asserts it when the game clears it on arrival, and advances it to the next open stop — for every route type (Achievements, Rares, Professions/Treasures, Reset routine).
- **Safety net when TomTom's crazy arrow drops.** If TomTom is installed but its arrow is hidden (e.g. an outdated TomTom/HereBeDragons that can't re-point across zones), the native waypoint takes over so you keep a direction. While TomTom's arrow is actually showing, the native layer stays idle — no change for working TomTom setups.
- **No more borrowed HereBeDragons dependency.** The cross-zone arrow re-point now translates coordinates via the game's own `C_Map` world coordinates instead of a `HereBeDragons-2.0` instance lent by TomTom/HandyNotes, so cross-map routing behaves identically for everyone.

---

## CF page description — suggested additions

> **2.2.0** — route guidance now works standalone. No TomTom? Midnight Helper drives the game's own waypoint and keeps it flowing to your next stop. TomTom installed but the arrow keeps vanishing? The built-in waypoint steps in as a safety net.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-2.2.0.zip` |
| **Display version** | **2.2.0** |
| **Game version** | Retail — interface **120007** (12.0.7) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud (`tools/` met scripts en `docs/` mogen er NIET in).
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden of `Locales/i18n_*`-werkbladen.
- Changelog hierboven plakken; **Release type = Release**; game version Retail 120007.

### Test (na upload / na /reload)

**Zonder TomTom (uitschakelen in de AddOns-lijst) — dit is de kernwinst:**

- `/reload` met Lua-errors aan → geen fouten; de gele melding "TomTom is not loaded" mag verschijnen.
- Start een **rare** Generate Route → **MH's eigen richtingspijl** verschijnt (draait mee, afstand eronder) + een kaart-waypoint. Kill een rare → pijl schuift door naar de dichtstbijzijnde open rare.
- **Auto-advance bij niet-gespawnde rare**: vlieg over een lege spawn → de pijl gaat vanzelf naar de volgende (rare komt terug zodra 'ie spawnt). `/mh skip` blijft als handmatige override.
- **Generate Treasures** → zelfde pijl, volgt de dichtstbijzijnde treasure, schuift door na loot.
- **Reset-routine** op Home → route-keten geeft ook zonder TomTom richting.
- Pijl wijst verkeerd/omgekeerd? `ROTATION_OFFSET` bovenin `NativeArrow.lua` = één-regel-fix. Sleep de pijl om 'm te verplaatsen (positie onthouden).
- **Resize** via Settings → General (slider) of `/mh arrowsize 90`; **meters** via de toggle daaronder.
- **Ander continent** (portal naar bv. Orgrimmar): pijl verdwijnt + toont "(ander continent — reis terug)", geen nep-richting.

**Met TomTom (Cisca's geval):**

- Route lopen: zolang de grote TomTom-pijl zichtbaar is verandert er niets (native laag blijft stil).
- Zodra de TomTom-pijl wegvalt (bv. bij een kaart-/zonewissel) → de native waypoint neemt het over, je houdt richting.
- Cross-zone (Light Up the Night over Eversong/Zul'Aman/Harandar/Voidstorm): pijl blijft naar de eerstvolgende open stop wijzen.

**Beide:**

- In-game changelog-popup toont **2.2.0** bovenaan met de nieuwe regels.
- **Route wissen** werkt: rechts-klik op de pijl, `/mh clear`, of keybind (Esc → Toetsbindingen → Midnight Helper → *Clear active route*) → route + pijl + waypoints weg.
- Geen dubbele pijl met TomTom aan; geen vastzittende waypoints; na afronden route is alles weg.
