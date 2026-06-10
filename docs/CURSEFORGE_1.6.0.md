# CurseForge release 1.6.0 — copy/paste

**Upload:** `dist/MidnightHelper-1.6.0.zip` (build with `tools\package.ps1`).
**Description:** vervang de hele projectpagina-tekst door
`docs/CURSEFORGE_DESCRIPTION.md` (tussen de START/END-markers) + nieuwe
screenshots (volgorde-suggestie staat onderin dat doc).

---

## Short summary (one line)

Major update: "After the reset" routine with TomTom route, per-slot vault detail on every alt, Ritual Coach with cross-language party share, Professions weekly tracking for all 11 professions, Start Here roadmap — fully localized in 6 languages.

---

## Changelog — paste below (since 1.5.3)

### 1.6.0 — 2026-06-10

#### New

- **After the reset routine (Home):** an ordered, per-character to-do list — claim the Great Vault, the three weekly quest givers next to the bank (Liadrin / Halduron / Aethas, with real pickup/done status), the Ritual & Void weeklies at the Bazaar hub, and your profession trainer weeklies. One click builds a **TomTom route along all open stops**.
- **Per-slot vault detail on alts (Account Snapshot):** hover a character's vault to see, per slot, the **item level locked in right now** (Blizzard's own example reward) and the registered tier — know instantly whether an alt still needs higher delves/rituals this week.
- **Ritual Coach (Void & Rituals):** every challenge's mechanic, Spoils bonus and unlock path; scenario notes, Dark Obelisk and Tainted Bone Pile locations for **both** sites; recommended item level per tier (T1 215 → T5 264). **Party share included** — groupmates with Midnight Helper receive the tips **in their own language**.
- **Void & Rituals in two views:** *This week* (status, live weekly progress %, route buttons, compact challenge list) and *Ritual Coach* (the full reference). Your choice is remembered.
- **Professions:** weekly trainer/service quest tracking for **all 11 professions** (including rotating variants); Professions 101 beginner course covers every profession; Tree Advisor with selectable goal (Allround / Gold / Self-sufficient); treasure & book routes with a smart auto-advancing arrow and travel advice.
- **Start Here:** a guided first-week roadmap for new Midnight players — weekly steps tick themselves off.
- **Delve party share v2:** delve tips shared to your group arrive in each receiver's own language (when they run Midnight Helper; plain text for everyone else).
- **Consumables:** click any item to copy its name for the Auction House.
- **World boss:** route button on Home; the city-guide button now always shows the boss name when known.
- **Mage travel:** Teleport/Portal Silvermoon City buttons in the travel assistant.
- **Full localization:** all of the above in English, Nederlands, Deutsch, Français, Español and Português.

#### Fixes & polish (general)

A broad stability and quality pass alongside the features: a combat-lockdown error on the rare toast, the vault reminder popup now closes after setting its waypoint, weekly reset timing is region-correct (US Tuesday / EU Wednesday), vault snapshots no longer reset to zeros on login, font-glyph cleanup across all six languages (no more square boxes), several machine-translation corrections, interrupt macros rebuilt as Focus/Mouseover variants (re-copy yours from Toolbox → Macros), and the internal keybinding id was namespaced — if you had a **custom** key bound, re-bind it once under Keybindings → Midnight Helper (default Alt+M is unchanged).

#### Heads-up

- 12.0.7 support is already on board (Showdowns section, Codex articles) and activates automatically on 12.0.7 clients.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.6.0.zip` |
| **Display version** | **1.6.0** |
| **Game version** | Retail — interface **120005** (TOC also lists 120007 for PTR; fine until 12.0.7 is live) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels (eerdere afwijzing voorkomen):**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip — `package.ps1`
  faalt de build als er één doorglipt; controleer de zip-inhoud tóch even.
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden.
- Description + **nieuwe screenshots** (Rob heeft een verse set; minimaal 3,
  volgorde-suggestie in CURSEFORGE_DESCRIPTION.md — routine-screenshot eerst).
- Changelog hierboven plakken; juiste game version + release type kiezen.

### Test (na upload, schone AddOns-map)

- `/reload` — geen Lua-errors bij login, óók wanneer je direct in combat zit
  (toast-fix).
- Home — routine-blok met route-knop; Void & Rituals — beide views;
  Account Snapshot — vault-tooltip met slot-regels; taal wisselen — alles
  vertaald, nergens blokjes.
