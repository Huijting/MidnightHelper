# CurseForge release 1.8.3 — copy/paste

**Upload:** `dist/MidnightHelper-1.8.3.zip` (build with `tools\package.ps1`).
**Description:** vervang de hele projectpagina-tekst door `docs/CURSEFORGE_DESCRIPTION.md`
(tussen de START/END-markers) — controleer dat de Omnium Folio-tab erin staat.

---

## Short summary (one line)

New consumable ready-check on dungeon entry (your flask/rune/potions/food/healthstone plus the group's buffs, with never-lie "?" handling), Daggerspine Point boss-window auto-open, a Ritual Sites Renown Codex article, clickable waypoints for the renown vendors (Rae'ana, Sergeant Vornin), an "Open rune window" button in the Omnium Folio tab, and a Folio weekly reminder that now names this week's objective. Fully localized.

---

## Changelog — paste below (since 1.8.2)

### 1.8.3 — 2026-06-20

#### New

- **Consumable ready-check.** Entering a dungeon checks your own **flask, augment rune, combat & healing potions, food buff and healthstone** (from your bags) and shows the **group's buff status** — all with Blizzard ready-check icons. Run it any time with `/mh readycheck`, mute it with `/mh readytoggle` or the new **settings toggle** (Dungeon Coach). Never-lie: a slot that genuinely can't be read shows a **"?"** rather than a false "missing". (The API can't read other players' bags, so group members show buff status only.)
- **Daggerspine Point boss window** opens automatically at each boss stage (Mindbreaker, Selen'vjar), like the other Midnight dungeons.
- **Ritual Sites Renown Codex article:** a new world Codex entry explaining the **8-rank "Journeys" track** — what each rank unlocks (regeneration orbs, treasures, housing decor, shrines, pets, the Void-Touched Hawkstrider mount) and why a higher-rank site yields more spoils.
- **Vendor waypoints** for the Ritual Sites renown vendors — **Rae'ana** (housing decor, Dark Obelisk) and **Sergeant Vornin** (pets, Void-Touched Hawkstrider) in Silvermoon — clickable anywhere their names appear.

#### Changed

- **Omnium Folio tab — "Open rune window" button.** Opens the Folio directly via the expansion landing page, so you can reach it even when your UI hides the minimap expansion button (e.g. Ellesmere UI). Falls back to a hint if it can't open (e.g. in combat).
- **Folio weekly reminder now names this week's objective** — e.g. "collect 8 Ritualized Arcana from Ritual Site elites" — instead of just a generic do-it reminder.

#### Fixed

- Consumable ready-check derives each item's buff via the item's own spell, so a missing buff is never reported falsely when the item is on cooldown or the aura name differs.
- **Omnium Folio unlock counter** (and the Folio weekly reminder) now count **account-wide** unlocks — an alt that hadn't personally done the questline previously showed 0/5 even though the rows were unlocked on the account.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.8.3.zip` |
| **Display version** | **1.8.3** |
| **Game version** | Retail — interface **120007** (12.0.7) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud.
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden.
- Description + verse screenshots (suggestie: de **consumable ready-check** bij dungeon-entry, het
  **Ritual Sites Renown Codex**-artikel, en de **Omnium Folio**-tab met de nieuwe "Open rune window"-knop).
- Changelog hierboven plakken; juiste game version + release type kiezen.

### Test (na upload, schone AddOns-map)

- `/reload` — geen Lua-errors bij login, óók direct in combat.
- In-game changelog-popup toont **1.8.3** bovenaan (niet stale).
- **Consumable-check:** ga een dungeon binnen → check toont je eigen flask/rune/potions/food/healthstone
  + de buff-status van de groep; `/mh readytoggle` dempt; Settings → Dungeon Coach-toggle werkt; een
  onleesbaar slot toont "?" (geen valse "ontbreekt").
- **Daggerspine Point:** boss-venster opent vanzelf bij Mindbreaker en Selen'vjar.
- **Codex:** het Ritual Sites Renown-artikel staat onder de world-categorie; Rae'ana + Sergeant Vornin
  zijn klikbaar → waypoint in Silvermoon.
- **Omnium Folio:** de "Open rune window"-knop opent de Folio (ook met Ellesmere UI); de Folio-weekly in
  de Account-checklist noemt het objective van deze week.
- Taal wisselen — alles vertaald, nergens blokjes.
