# CurseForge release 1.5.2 — vanaf laatste live build **1.5.0**

**Situatie:** 1.5.1 en 1.5.2 zijn niet live gegaan (review / archive / `.bat` in zip). Deze upload is **één release** met alles sinds **1.5.0**.

**Bestand:** `dist/MidnightHelper-1.5.2.zip` (opnieuw bouwen met `tools\package.ps1` — geen `.bat` / dev-scripts in de zip).

**Description:** ververs vanuit `CURSEFORGE_DESCRIPTION.md` (Midnight Codex onder beta-blok).

---

## Short summary (one line) — CF / project teaser

Since 1.5.0: Midnight Codex (beta handbook), Home delve weeklies, Delve Coach multi-boss & 3D preview fixes, Trovehunter bounty fix, and a hotfix for Lua errors with nameplate tooltips in delves.

---

## Changelog (release notes field) — paste on CurseForge

### 1.5.2 — 2026-06-02

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
- **Delve story tooltip hook** no longer listens to **UnitAura** and other non-map tooltip types — fixes Lua errors in delves when nameplate addons (e.g. **Platynator**) show aura tooltips (`secret number` POI compare on 12.x).
- Map **Area POI** story detection still works; POI IDs use 12.x secret-value guards before matching.

---

## Korte samenvatting (NL) — voor jezelf / Discord

Sinds **1.5.0** op CurseForge:

- **Midnight Codex** (beta): handboek met live valuta, tooltips, Open-knoppen naar de juiste tabs.
- **Home:** Trovehunter, Gilded Stash, Special Assignments + alt-rollup.
- **Delve Coach:** juiste baas in multi-boss delves, 3D-preview/story-fixes, carousel zonder vast te lopen.
- **Fix:** geen valse “gebruik de bounty”-melding; geen Lua-errors meer met Platynator/nameplate-tooltips in delves.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.5.2.zip` (vers gebouwd na `package.ps1`-fix) |
| **Display version** | **1.5.2** |
| **Game version** | Retail — interface **120005** |
| **Release type** | **Release** |
| **Changelog** | Sectie **Changelog** hierboven (1.5.0 → 1.5.2, niet alleen “since 1.5.1”) |

### Build

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

Controle: zip bevat **geen** `.bat`, `.ps1`, `.py`, `.exe` (script faalt anders).

### Screenshots (aanbevolen)

1. Home met delve-weekly regels  
2. Midnight Codex — currencies met saldi  
3. Delve Coach — live delve met boss-preview  

### In-game

`/mh changelog` toont **1.5.2** en **1.5.1** als aparte versies; spelers die alleen CF lezen zien één gecombineerde lijst hierboven.
