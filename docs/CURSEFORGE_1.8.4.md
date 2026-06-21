# CurseForge release 1.8.4 — copy/paste

**Upload:** `dist/MidnightHelper-1.8.4.zip` (build with `tools\package.ps1`).
**Description:** vervang de hele projectpagina-tekst door `docs/CURSEFORGE_DESCRIPTION.md`
(tussen de START/END-markers).

---

## Short summary (one line)

The Consumable board becomes a slick icon view: real item/spell icons with counts and buff timers, click your own consumables (or class buff) to use them, plus raid/class-buff checks that show who has each buff (cross-faction), smarter gap-free columns, ritual/delve triggers, and several fixes. Fully localized.

---

## Changelog — paste below (since 1.8.3)

### 1.8.4 — 2026-06-21

#### New

- **Consumable board redesigned to an icon view:** real item/spell icons with a status badge (green ready/active, amber in-bags-not-used, red missing, grey unknown), stack counts, and buff timers above your own row. Your own consumables are **clickable to use** from the board.
- **Raid & class buffs on the board:** Arcane Intellect, Battle Shout, Power Word: Fortitude, Mark of the Wild, Skyfury — only when a provider class is in the group. **Hover to see who has it / who's missing** (whole group, cross-faction, multiple same-class supported). Your own class buff is **clickable to cast**.
- **Smarter, gap-free columns:** Healthstone only with a Warlock present, weapon oil only for specs that use it.
- **The check now also pops on entering a ritual or delve** (not just dungeons); reopen the board via **middle-click on the minimap button** or `/mh board`.
- **"Not in your bags" tooltip:** hovering a missing slot shows the recommended item.

#### Changed

- **Food (Well Fed) detection now covers every food** (shared buff-icon detection) instead of a fixed spell list.

#### Fixed

- **Omnium Folio unlock counter is now account-wide** (alts no longer show 0/5; also fixes the Folio weekly reminder).
- **Delve/Ritual death counter no longer resets after a `/reload`.**
- **Lua error from 12.x "secret" aura values** when checking buffs is resolved.
- **Catalyst correctly named the Matrix Catalyst** (was "Creation Catalyst") with unlock info; renown vendors Rae'ana & Sergeant Vornin are clickable waypoints.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.8.4.zip` |
| **Display version** | **1.8.4** |
| **Game version** | Retail — interface **120007** (12.0.7) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud.
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden.
- Description + verse screenshots (suggestie: het **nieuwe icoon-bord** met de raid-buff-kolommen +
  een hover-tooltip die "wie heeft 'm" toont, en de buff-timers).
- Changelog hierboven plakken; juiste game version + release type kiezen.

### Test (na upload, schone AddOns-map)

- `/reload` — geen Lua-errors bij login, óók direct in combat.
- In-game changelog-popup toont **1.8.4** bovenaan.
- **Consumable-bord:** `/mh board` → icoon-stijl met badges/counts; je eigen cellen klikbaar (item poppen);
  flask/food-timer boven je rij; "Not in your bags" bij een ontbrekend item.
- **Raid-buffs:** in een groep met mage/druid/etc. verschijnen de juiste buff-kolommen; hover toont
  wie 'm heeft/mist; je eigen class-buff is klikbaar om te casten.
- **Kolommen:** Healthstone alleen bij een Warlock; geen gaten.
- **Trigger:** bord verschijnt bij ritual/delve/dungeon; middel-klik minimap heropent het; verdwijnt bij
  de pull.
- Taal wisselen — alles vertaald, nergens blokjes.
