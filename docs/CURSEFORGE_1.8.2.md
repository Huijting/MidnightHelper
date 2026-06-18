# CurseForge release 1.8.2 — copy/paste

**Upload:** `dist/MidnightHelper-1.8.2.zip` (build with `tools\package.ps1`).
**Description:** vervang de hele projectpagina-tekst door `docs/CURSEFORGE_DESCRIPTION.md`
(tussen de START/END-markers) — controleer dat de Omnium Folio-tab erin staat.

---

## Short summary (one line)

New Omnium Folio tab — the full 12.0.7 rune tree with clickable spell tooltips and a recommended pick per row for M+/Raid/PvP/World — plus boss-window quality-of-life (targeting a boss reopens it, the X only dismisses that one boss, a new auto-open toggle) and a ritual Lua fix. Fully localized.

---

## Changelog — paste below (since 1.8.1)

### 1.8.2 — 2026-06-17

#### New

- **Omnium Folio tab:** the full patch 12.0.7 rune tree — all five rows and thirteen runes as clickable spell links (hover for the live tooltip), each with a short effect note. A **content-type selector (Mythic+ / Raid / PvP / World)** highlights the recommended pick per row, plus the unlock walkthrough and a live **"x/5 rows unlocked"** counter from your Folio quest progress. Recommendations are general baselines, not per-spec BiS. Appears on clients 12.0.7+.
- **Folio weekly reminder:** the Account snapshot weekly checklist shows an account-wide reminder to do this week's Omnium Folio Mote (tracked across the weekly reset), gone once you're fully unlocked.

#### Changed

- **Floating boss window — the X now only dismisses that one boss.** The next boss brings a fresh window (a new pull, a ritual stage, or simply targeting the boss). A new **"Open automatically" toggle** (Dungeon Coach settings) is the permanent opt-out; the window still opens on `/mh bosswin`.
- **Targeting a dungeon boss reopens the boss window** and jumps to that boss.
- **Great Vault advisor:** the tier-set note is now threshold-aware — it tells you whether a vault tier piece completes your 2- or 4-set bonus, or is just another piece with no new bonus yet.

#### Fixed

- Lua error in ritual scenarios on 12.x (boss unit IDs are now "secret" values and could taint/error when read) — now skipped safely.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.8.2.zip` |
| **Display version** | **1.8.2** |
| **Game version** | Retail — interface **120007** (12.0.7 is live; 120005 removed from the TOC) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud.
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden.
- Description + verse screenshots (suggestie: de **Omnium Folio**-tab met de M+/Raid/PvP/World-knoppen
  en de aanbevolen-markering, een hover-spell-tooltip, en de boss-venster auto-open-toggle in Settings).
- Changelog hierboven plakken; juiste game version + release type kiezen.

### Test (na upload, schone AddOns-map)

- `/reload` — geen Lua-errors bij login, óók direct in combat.
- In-game changelog-popup toont **1.8.2** bovenaan (niet stale).
- **Omnium Folio**-tab: verschijnt op 12.0.7; spell-links tonen tooltips; M+/Raid/PvP/World wisselt de
  "aanbevolen"-markering; de "x/5 rijen ontgrendeld"-teller klopt met je Folio-voortgang.
- **Boss-venster:** in een dungeon/ritual de X → volgende boss geeft weer een venster; een boss targeten
  haalt 'm terug; Settings → Dungeon Coach "Automatisch openen" uit = nooit vanzelf openen.
- Ritual zonder Lua-error.
- Taal wisselen — alles vertaald, nergens blokjes.
