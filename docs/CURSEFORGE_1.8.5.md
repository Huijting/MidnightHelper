# CurseForge release 1.8.5 — copy/paste

**Upload:** `dist/MidnightHelper-1.8.5.zip` (build with `tools\package.ps1`).
**Description:** ongewijzigd t.o.v. 1.8.4 (geen nieuwe tab/feature-categorie).

---

## Short summary (one line)

Two requested checkbox options: hide the weekly Coffer Shard cap popup, and show/hide the 3D boss model in the boss window. Both under Settings → Dungeon.

---

## Changelog — paste below (since 1.8.4)

### 1.8.5 — 2026-06-21

#### New

- **Setting to hide the weekly Coffer Shard cap popup** (Settings → Dungeon). First community request (thanks gadrinonturalyon!) — the shard-cap toast can now be turned off.
- **Setting to show or hide the 3D boss model** in the floating boss window (Settings → Dungeon). Turning it off hides the model; it takes effect immediately while the window is open.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.8.5.zip` |
| **Display version** | **1.8.5** |
| **Game version** | Retail — interface **120007** (12.0.7) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud.
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden.
- Changelog hierboven plakken; juiste game version + release type kiezen.
- Optioneel: kort op de comment van gadrinonturalyon reageren dat beide opties er nu in zitten.

### Test (na upload, schone AddOns-map)

- `/reload` — geen Lua-errors bij login.
- In-game changelog-popup toont **1.8.5** bovenaan met de twee nieuwe regels.
- **Settings → Dungeon:** twee nieuwe checkboxes ("3D-bossmodel tonen" bij het boss-venster, "Shard-cap-popup tonen").
- Boss-model-toggle uit → model verdwijnt direct uit een open boss-venster; aan → komt terug.
- Shard-cap-toggle uit → `/mh shardtest` (of cap halen) toont geen popup meer.
- Taal wisselen — beide opties vertaald in alle 6 talen.
