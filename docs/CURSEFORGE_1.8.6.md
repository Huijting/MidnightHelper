# CurseForge release 1.8.6 — copy/paste

**Upload:** `dist/MidnightHelper-1.8.6.zip` (build with `tools\package.ps1`).
**Description:** ongewijzigd t.o.v. 1.8.5 (geen nieuwe tab/feature-categorie).

> ⚠️ **Vóór upload:** in-game `/reload`-test — geen Lua-fout bij login, changelog-popup toont **1.8.6** bovenaan.

---

## Short summary (one line)

Two small group/delve quality-of-life additions: the party leader can re-open everyone's consumable board with `/mh boardall`, and a "Final boss — open coach?" button reappears in delves if you'd closed the Delve Coach earlier.

---

## Changelog — paste below (since 1.8.5)

### 1.8.6 — 2026-06-22

#### New

- **Group leader can reopen everyone's consumable board** with `/mh boardall`. The party/raid leader (or an assistant) pops the board for the whole group at once, so everyone can re-check flasks, runes, food and buffs on demand before a pull. (Groupmates need Midnight Helper installed.)
- **"Final boss — open coach?" button.** If you close the Delve Coach during a delve, a small button now reappears when a boss encounter starts, so you can pull the coach back up for the final fight with one click.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.8.6.zip` |
| **Display version** | **1.8.6** |
| **Game version** | Retail — interface **120007** (12.0.7) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud.
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden.
- Changelog hierboven plakken; juiste game version + release type kiezen.

### Test (na upload, schone AddOns-map)

- `/reload` — geen Lua-errors bij login.
- In-game changelog-popup toont **1.8.6** bovenaan met de twee nieuwe regels.
- **`/mh boardall`** als groepsleider → bord verschijnt bij jezelf (en bij groepsleden met MH).
- **Delve:** Delve Coach wegklikken → bij een boss-encounter verschijnt het "Eindbaas — open coach?"-knopje.
