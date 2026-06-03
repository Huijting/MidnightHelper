# CurseForge release 1.5.3 — vanaf laatste live build **1.5.0**

**Gebruik dit** als CurseForge nog op **1.5.0** staat (1.5.1 / 1.5.2 niet live geworden).

**Bestand:** `dist/MidnightHelper-1.5.3.zip` — `powershell -ExecutionPolicy Bypass -File tools\package.ps1`

**Description:** `CURSEFORGE_DESCRIPTION.md` (Midnight Codex onder beta-blok).

---

## Short summary (one line)

Since 1.5.0: Midnight Codex (beta), Home delve weeklies, Delve Coach improvements, world boss reset-day fix, and delve/nameplate tooltip hotfixes.

---

## Changelog — paste on CurseForge

### 1.5.3 — 2026-06-03

**Since the last CurseForge release (1.5.0)**

#### Midnight Codex (beta)

- New **Midnight Codex** tab in the **beta** sidebar block — Season 1 handbook: Start Here, weekly loop, currencies, delves, M+, raid, world content, professions.
- **Live currency balances** when logged in (with snapshot fallback); Blizzard **tooltips** on currency titles and icons.
- **Open** buttons jump to the correct addon tab (e.g. Dawncrests → **Basics**, Great Vault → **Delves & Vault** section).
- Toggle in **Esc → AddOns → Midnight Helper** (beta master switch + **Midnight Codex** checkbox).
- Global search: `codex`, `wiki`, `handbook`, `start here`, `currency`, …

#### Home — delve weeklies

- **Trovehunter's Bounty**, **Gilded Stash** (T11+ bountiful), and **Special Assignments** on the Home tab with account-wide alt rollup.

#### Delve Coach

- **Auto-select** the active boss in multi-boss delves (story / scenario / map tooltip signals).
- **Session carousel** browse without saving the wrong boss into preview or SavedVariables.
- **Live delve boss 3D preview** and story-variant detection improvements (map tooltip, Grudge Pit / Arena Champion fallbacks).

#### Fixes

- **Trovehunter's Bounty** on Home / Account no longer says “use it!” unless the map is actually in your bags.
- **World boss** on Home / Delves: weekly status **resets after reset day** — last week's kill no longer shows as “defeated this week”.
- **World boss:** fixed login Lua error when refreshing shortcuts.
- **Delve story tooltip hook** no longer listens to **UnitAura** / nameplate tooltips — fixes errors in delves with addons such as **Platynator** (12.x secret POI IDs).
- Release zip excludes dev sync files (`.bat`, scripts).

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.5.3.zip` |
| **Display version** | **1.5.3** |
| **Interface** | **120005** |
| **Release type** | **Release** |
