# CurseForge release 2.1.1 — copy/paste

**Upload:** `dist/MidnightHelper-2.1.1.zip` (build with `tools\package.ps1`).
**Description:** patch — Achievements tab: route arrow no longer vanishes (arrival, detour-kill, sub-zone map changes), Skip, type/elite tags, full route localization, and a live Light Up the Night zone breakdown with mount preview.

> ⚠️ **Vóór upload:** in-game `/reload`-test met Lua-errors aan — geen fout bij login, changelog-popup toont **2.1.1** bovenaan. Loop een rare/treasure-route door meerdere sub-zones: de **grote pijl blijft** en schuift door. Probeer `/mh skip`. Open de Achievements-tab → hover de Light Up the Night-zones (vinkjes kloppen met je achievementspaneel), klik de gouden regel → Petalwing-preview. Check een niet-Engelse taal (`/mh lang nl`) — route-popups/notes vertaald.

---

## Short summary (one line)

Midnight Helper 2.1.1 fixes the route arrow disappearing — on arrival, after killing a rare on the way, and when crossing between sub-zones — by keeping it pinned to your next open stop and translating it onto whatever map you're on. It adds a Skip command/keybind for un-spawned rares, a live Light Up the Night breakdown of the four zone metas (with accurate hover checklists and a Brilliant Petalwing mount preview), per-card type/Elite tags, and full translation of the route notes and popups into all seven languages.

---

## Changelog — paste below (since 2.1.0)

### 2.1.1 — 2026-07-01

Fixes and polish for the Achievements tab.

#### Fixed

- **The route arrow no longer disappears** — not on arrival, not after killing a rare on the way, and not when crossing between sub-zones (e.g. into Slayer's Rise while routing in Voidstorm). Midnight Helper keeps the crazy arrow pinned to your next open treasure/rare, translating it onto whatever map you're standing on (via HereBeDragons), so it flows even without TomTom's "set closest waypoint" option.
- The **"you're nearly there" rare alert** now fires only when you're actually on a rare route, not when you pass a previously-routed rare while heading to a treasure.

#### New

- **Skip the current route target** — `/mh skip` (or `/mh next`) or a keybind (Esc → Key Bindings → Midnight Helper). Handy when a rare isn't up: the arrow moves to the next open one and you cycle back to skipped stops later.
- **Live Light Up the Night breakdown** — the four zone metas it needs (Forever Song, Making an Amani Out of You, That's Aln Folks!, Yelling into the Voidstorm), each with its own progress. Hover for an accurate criteria checklist, click the header to preview the **Brilliant Petalwing** mount.
- **Per-card type tags** (Treasure / Telescope / Lore / Rare), an **Elite** flag on the tougher rares, and a hint on the achievements that count toward Light Up the Night.
- **Full localization** of the route how-to notes, step labels and chat/popup messages into all seven languages (treasure/rare/item names stay in your game-client language).
- **Checklist readability** (zebra striping + hover highlight) and `/mh arrowdebug` for routing diagnostics.

---

## CF page description — suggested additions

> **2.1.1** — the Achievements route arrow now keeps flowing through arrivals, detour kills and sub-zone changes, a new Skip command/keybind jumps past un-spawned rares, the tab breaks down the Light Up the Night meta per zone with a Brilliant Petalwing preview, and the route notes & popups are fully translated into all seven languages.

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
