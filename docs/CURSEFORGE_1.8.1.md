# CurseForge release 1.8.1 — copy/paste

**Upload:** `dist/MidnightHelper-1.8.1.zip` (build with `tools\package.ps1`).
**Description:** vervang de hele projectpagina-tekst door `docs/CURSEFORGE_DESCRIPTION.md`
(tussen de START/END-markers) — die is bijgewerkt naar 1.8.1.

---

## Short summary (one line)

A big polish + features pass: new Tier Sets and Currencies tabs, clickable vendor waypoints, a rare skull marker, a calmer unified look with tooltips at your cursor, an optional Simple view, the Val & Naigtal Showdown rares — plus fixes. Fully localized in 6 languages.

---

## Changelog — paste below (since 1.8.0)

### 1.8.1 — 2026-06-16

#### New

- **Tier Sets tab:** your class set, your 2- and 4-piece bonuses as clickable links (hover for the live tooltip), and a live counter of equipped tier pieces. Explains how to get them — raid tokens, the Great Vault, and the Creation Catalyst (a clickable waypoint).
- **Currencies tab:** where to earn and spend every Midnight currency, with **live balances** and a waypoint to each Renown Quartermaster.
- **Clickable vendor names → waypoints** anywhere in the addon (TomTom or Blizzard waypoint).
- **Rare skull:** route to a rare from its alert and a skull marks it on its nameplate as you arrive.
- **Simple view:** a one-click toggle at the top of the menu hides everything but the core tabs — calmer for new players (full view stays the default; the choice is remembered account-wide).
- **Val & Naigtal Showdown rares** in the Rares tab.

#### Changed

- **Calmer, more cohesive UI:** one unified gold across all tabs/languages, role **icons** instead of a colour rainbow on boss steps, softer links and status colours, the Silvermoon City guide no longer looks "boxed in", and **tooltips now appear at your cursor**.
- The **Enchants** panel refreshes the instant you apply an enchant; each suggestion copies to the Auction House in one click.

#### Fixed

- World-boss "defeated this week" line is correct across your whole warband (and names who did it first); Veteran Dawncrest balance; the in-game changelog popup was stuck on old versions; duplicate ability names next to their own spell links removed.

#### Heads-up

- 12.0.7-ready; Val (map 2599) & Naigtal Showdown data is in. New-zone data keeps filling in.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.8.1.zip` |
| **Display version** | **1.8.1** |
| **Game version** | Retail — interface **120005** (TOC also lists 120007; fine until 12.0.7 is live) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud.
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden.
- Description + verse screenshots (suggestie: Tier Sets-tab, Currencies-tab met klikbare vendors,
  een raid/M+ boss-window, de Simple-view-toggle).
- Changelog hierboven plakken; juiste game version + release type kiezen.

### Test (na upload, schone AddOns-map)

- `/reload` — geen Lua-errors bij login, óók direct in combat.
- In-game changelog-popup toont **1.8.1** bovenaan (niet stale).
- Nieuwe tabs: **Tier Sets**, **Currencies** (klik een vendor → waypoint). Tooltips bij de cursor.
- **Simple view**-toggle bovenaan: schakelt naar 5 kerntabs en terug.
- Taal wisselen — alles vertaald, nergens blokjes.
