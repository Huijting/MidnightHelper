# CurseForge release 1.5.1 — copy/paste

**Live on CurseForge today:** 1.5.0 → upload **1.5.1**.

Upload `dist/MidnightHelper-1.5.1.zip`. Refresh project **Description** from `CURSEFORGE_DESCRIPTION.md` (Codex added under beta block). Add or refresh **3+ screenshots** (Home with weekly trackers, Midnight Codex currencies, Delve Coach boss preview in a live delve).

---

## Short summary (one line)

Since 1.5.0: Midnight Codex (beta) with live balances and correct deep links, delve weekly trackers on Home, Delve Coach multi-boss detection and 3D preview fixes, Trovehunter bounty status fix.

---

## Changelog (release notes field) — paste on CF

### 1.5.1 — 2026-05-30

**Since the last CurseForge release (1.5.0)**

#### Midnight Codex (beta)

- New **Midnight Codex** tab in the **beta** sidebar block — Season 1 handbook (Start Here, weekly loop, currencies, delves, M+, raid, world content, professions).
- **Live currency balances** when logged in; Blizzard **tooltips** on currency titles and icons.
- **Open** buttons jump to the right addon tab (e.g. Dawncrests → **Basics**, Great Vault → **Delves & Vault**).
- Toggle in **Esc → AddOns → Midnight Helper** (beta master switch + **Midnight Codex** checkbox).
- Search: `codex`, `wiki`, `handbook`, `start here`, `currency`, …

#### Home — delve weeklies

- **Trovehunter's Bounty**, **Gilded Stash** (T11+ bountiful), and **Special Assignments** on Home with account alt rollup.

#### Delve Coach

- **Auto-select** the active boss in multi-boss delves (story / scenario / map tooltip signals).
- **Session carousel** browse without saving a wrong boss into preview or SavedVariables.
- **Live delve boss 3D preview** and story-variant detection fixes (Grudge Pit / Arena Champion fallbacks).

#### Fixes

- **Trovehunter's Bounty** on Home / Account no longer says “use it!” unless the map is in your bags.

---

## CurseForge upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.5.1.zip` |
| **Game version** | Retail — interface **120005** (Midnight / 12.0.5) |
| **Release type** | **Release** |
| **Display version** | **1.5.1** |

### Build zip (from repo root)

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

### Post-upload

- [ ] **About** text = `CURSEFORGE_DESCRIPTION.md` (feature list, not a patch diary)
- [ ] **Changelog** = section above (this *is* where patch details belong)
- [ ] Interface `120005`, type **Release**
- [ ] Smoke-test zip on a clean `Interface\AddOns` folder (`/mh`, Codex currencies, Dawncrest Open → Basics, live delve coach)
- [ ] Optional: `/mh changelog` shows **1.5.1** at top (EN/NL bullets)

### Quick test after install

1. `/reload` → **Midnight Codex** (beta): currency balances + title tooltips.
2. Codex → Dawncrest → **Open: Basics (Dawncrests)** — not Delves list.
3. **Home**: bounty line should not say “use it!” without the map in bags.
4. In a multi-boss delve: coach boss name + 3D preview match the fight you're in.
