# CurseForge release 2.1.1 — copy/paste

**Upload:** `dist/MidnightHelper-2.1.1.zip` (build with `tools\package.ps1`).
**Description:** patch — fixes + polish for the Achievements tab (route arrow no longer vanishes on arrival, Skip, type/elite/meta tags, full route localization).

> ⚠️ **Vóór upload:** in-game `/reload`-test met Lua-errors aan — geen fout bij login, changelog-popup toont **2.1.1** bovenaan. Loop een treasure-route: de **grote pijl blijft** en schuift bij aankomst door naar de volgende stop. Probeer `/mh skip`. Check een niet-Engelse taal (`/mh lang nl` of de) — de route-popups/notes zijn vertaald.

---

## Short summary (one line)

Midnight Helper 2.1.1 fixes the route arrow disappearing when you arrive at a stop (it now flows to the next treasure/rare on its own), adds a Skip command/keybind for un-spawned rares, per-card type + Elite + Light Up the Night tags, and full translation of the route notes and popups into all seven languages.

---

## Changelog — paste below (since 2.1.0)

### 2.1.1 — 2026-06-30

Fixes and polish for the Achievements tab.

#### Fixed

- **The route arrow no longer disappears on arrival** — Midnight Helper now re-points TomTom's crazy arrow at the next-nearest open treasure/rare itself, so it keeps flowing even without TomTom's "set closest waypoint" option.
- The **"you're nearly there" rare alert** now fires only when you're actually on a rare route, not when you pass a previously-routed rare while heading to a treasure.

#### New

- **Skip the current route target** — `/mh skip` (or `/mh next`) or a keybind (Esc → Key Bindings → Midnight Helper). Handy when a rare isn't up: the arrow moves to the next open one and you cycle back to skipped stops later.
- **Per-card type tags** (Treasure / Telescope / Lore / Rare), an **Elite** flag on the tougher rares, and a hint on the achievements that count toward **Light Up the Night** (Brilliant Petalwing).
- **Full localization** of the route how-to notes, step labels and chat/popup messages into all seven languages (treasure/rare/item names stay in your game-client language).

---

## CF page description — suggested additions

> **2.1.1** — the Achievements route arrow now keeps flowing as you arrive at each stop, a new Skip command/keybind jumps past un-spawned rares, and the route notes & popups are fully translated into all seven languages.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-2.1.1.zip` |
| **Display version** | **2.1.1** |
| **Game version** | Retail — interface **120007** (12.0.7) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud (`tools/` met scripts en `docs/` mogen er NIET in).
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden of `Locales/i18n_*`-werkbladen.
- Changelog hierboven plakken; juiste game version + release type kiezen.

### Test (na upload, schone AddOns-map)

- `/reload` met Lua-errors aan — geen fouten bij login.
- In-game changelog-popup toont **2.1.1** bovenaan met de nieuwe regels.
- **Route:** loop een treasure-route → de grote pijl verdwijnt niet bij aankomst maar schuift door naar de volgende stop.
- **Skip:** `/mh skip` springt naar de volgende open node; keybind onder Esc → Toetsbindingen → Midnight Helper werkt.
- **Kaarten:** type-tags (Treasure/Telescope/Lore/Rare), (Elite)-markering op de zware rares, en de Light Up the Night-hint in de kaart-tooltip.
- **Talen:** `/mh lang nl` (of de/fr/es/pt/it) → route-notes, stap-labels en chat/popup-meldingen zijn vertaald; namen blijven client-taal.
