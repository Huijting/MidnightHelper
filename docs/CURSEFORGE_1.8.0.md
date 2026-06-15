# CurseForge release 1.8.0 — copy/paste

**Upload:** `dist/MidnightHelper-1.8.0.zip` (build with `tools\package.ps1`).
**Description:** vervang de hele projectpagina-tekst door
`docs/CURSEFORGE_DESCRIPTION.md` (tussen de START/END-markers) + nieuwe
screenshots (volgorde-suggestie staat onderin dat doc).

---

## Short summary (one line)

Major update: full raid + Mythic+ coaches, an Enchants checker and a Currencies map (both with click-to-copy / waypoints), a Delve & Ritual log, opt-in accessibility alerts, and an Events tab — plus a world-boss warband fix — fully localized in 6 languages.

---

## Changelog — paste below (since 1.7.1)

### 1.8.0 — 2026-06-15

#### New

- **Events tab:** every Midnight world event in one place — what's firing **now** and what's **coming up**, with live countdowns, click-to-route (TomTom / Blizzard waypoint + travel advice), hover descriptions, and **Shift-click for 3D reward previews**. `/mh eventspy` dumps the live scheduler for diagnostics.
- **Full raid coaches:** beginner boss steps for **The Dreamrift**, **The Voidspire** (6 bosses) and **March on Quel'Danas**, plus **Sporefall (Rotmire)** and the **Daggerspine ritual**. Each boss lists its key casts as clickable spell links with the action to take; the boss window opens automatically on pull.
- **Mythic+ tab:** affix ladder, Xal'atath's Bargain variants, the Season 1 dungeon pool and **must-interrupt lists per dungeon** — with a **Beginner mode + glossary** so the jargon doesn't bury you.
- **Enchants tab:** scans your equipped gear, flags slots missing an enchant, and suggests a stat-matched Midnight enchant for your spec. Every suggestion is a clickable/hoverable link, and **clicking it copies the name for an Auction House search**. Head/feet show the Speed/Leech/Avoidance choice; legs show armor-kit (Agi/Str) and spellthread (Int).
- **Currencies tab:** a "where do I earn it / where do I spend it" map for every Midnight currency, with your **live balance** beside each and a **waypoint button per Renown Quartermaster**. Plus a **Gear & Currency Vendors** section (Maren Silverwing, Triam Dawnsetter) in the Silvermoon City guide.
- **Helper alerts (opt-in, accessibility):** one big, calm on-screen warning (with sound) when **you** get a dangerous debuff to react to. Enable it in the Mythic+ Beginner mode.
- **Delve & Ritual Log:** ritual-scenario runs are logged alongside your delves, with totals.
- **Full localization:** all of the above in English, Nederlands, Deutsch, Français, Español and Português.

#### Fixed

- **World boss "Warband" status:** now shows the boss as defeated this week on **every** character once **any** of your characters has killed it — and names who did it first (it used to read "not defeated yet" on alts that hadn't personally looted).
- Veteran Dawncrest balance reads the correct currency; Delve Log entries expand correctly; the Broken Throne dragonhawk and Ger'lok steps were corrected.

#### Heads-up

- Built for 12.0.5 and **12.0.7-ready**; new-zone/boss data is being verified in-game and will keep filling in.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.8.0.zip` |
| **Display version** | **1.8.0** |
| **Game version** | Retail — interface **120005** (TOC also lists 120007; fine until 12.0.7 is live) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels (eerdere afwijzing voorkomen):**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip — `package.ps1`
  faalt de build als er één doorglipt; controleer de zip-inhoud tóch even.
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden.
- Description + **nieuwe screenshots** (suggestie: Currencies-tab, Enchants-tab,
  een raid/M+ boss-window, Events-tab).
- Changelog hierboven plakken; juiste game version + release type kiezen.

### Test (na upload, schone AddOns-map)

- `/reload` — geen Lua-errors bij login, óók direct in combat.
- Nieuwe tabs openen: **Currencies** (saldo's + QM-waypoint-knoppen), **Enchants**
  (links + klik → AH-kopieerveld), **Mythic+**, **Events**.
- World boss-kaart op een alt die 'm niet zelf deed → "defeated this week by …".
- Taal wisselen — alles vertaald, nergens blokjes.
