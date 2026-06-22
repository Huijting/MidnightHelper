# CurseForge release 1.8.5 — copy/paste

**Upload:** `dist/MidnightHelper-1.8.5.zip` (build with `tools\package.ps1`).
**Description:** ongewijzigd t.o.v. 1.8.4 (geen nieuwe tab/feature-categorie).

> ⚠️ **Vóór upload:** in-game `/reload`-test op een schoon profiel — geen Lua-fout bij login, en `/mh lang it` (+ de/fr/es/pt) zonder fouten. De grote locale-bestanden zijn structureel geverifieerd, maar de definitieve check is een in-game reload.

---

## Short summary (one line)

Midnight Helper now speaks Italian, Professions 101 gained per-profession "Skill leveling 1-100" routes and a clear "Work Orders explained" chapter (in all 7 languages), two new requested toggles, and fixes for the world-boss warband line and the weekly shard popup.

---

## Changelog — paste below (since 1.8.4)

### 1.8.5 — 2026-06-21

#### New

- **Italian language (itIT).** Full interface and guide translation. Auto-selects on an Italian WoW client (since patch 5.0.4), or pick it manually with `/mh lang it` (or the new IT button in Settings / the AddOns options panel).
- **Professions 101 — skill-leveling routes & Work Orders.** Each profession chapter can show a concise **"Skill leveling 1-100"** route (trainer, shopping list, step-by-step skill ranges) — all 11 professions covered. Plus a new **"Work Orders explained"** chapter: the four order types and how to both order items and craft for others. Translated in all 7 languages.
- **Setting: hide the weekly Coffer Shard cap popup** (Settings → Dungeon). Thanks to **gadrinonturalyon** for the request!
- **Setting: show or hide the 3D boss model** in the boss window (Settings → Dungeon). Also requested by gadrinonturalyon.

#### Fixed

- **World boss "Warband: defeated this week"** now shows on every character once any one of them kills it (account-wide quest flag, same approach as the Omnium Folio fix), and remembers which character did it.
- **Weekly Coffer Shard cap popup** now appears only once per character per week (you may see it one more time after this update, then it stays off until the next reset).

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
- Optioneel: kort reageren op gadrinonturalyon's comment dat beide opties + meer erin zitten.

### Test (na upload, schone AddOns-map)

- `/reload` — geen Lua-errors bij login.
- In-game changelog-popup toont **1.8.5** bovenaan.
- **Talen:** `/mh lang it` → Italiaanse UI; ook de/fr/es/pt zonder blokjes/fouten. IT-knop zichtbaar in Settings + AddOns-paneel.
- **Professions 101** (Toolbox → Professions → Course): "Work Orders"-hoofdstuk zichtbaar; per professie die je hebt verschijnt de "Skill leveling 1-100"-route.
- **Settings → Dungeon:** twee checkboxes (shard-popup, 3D-bossmodel) werken.
- **World boss (Home):** "Warband: defeated this week" verschijnt op een alt zodra een char 'm killde.
