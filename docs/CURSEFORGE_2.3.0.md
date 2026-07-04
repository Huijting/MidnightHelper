# CurseForge release 2.3.0 — copy/paste

**Upload:** `dist/MidnightHelper-2.3.0.zip` (build with `tools\package.ps1`).
**Description:** the biggest release yet — the Leveling tab is completely rebuilt around a live, self-building keyboard layout for all 13 classes and 39 specs, plus three new on-screen tools (Missing Buff reminder, Openables tracker, Fast Mark bar), a per-content route arrow, guides out of Beta, and full localization of everything new.

> ⚠️ **Vóór upload:** in-game `/reload`-test met Lua-errors aan — geen fout bij login, changelog-popup toont **2.3.0** bovenaan. Test op meerdere classes/specs (Layout-tab), Missing Buff (klik-cast), Openables, Fast Mark (in een groep), en de pijl mét/zonder TomTom/WaypointUI.

---

## Short summary (one line)

Midnight Helper 2.3.0 rebuilds the Leveling tab into a live keyboard layout that reads your own spellbook and lays out every ability by role for all 13 classes and 39 specs, adds a clickable Missing Buff reminder, an Openables tracker and a Fast Mark bar, gives the route arrow per-content icons/colours (and hands off to WaypointUI when installed), takes the guides out of Beta, and fully translates everything new into six languages.

---

## Changelog — paste below (since 2.2.0)

### 2.3.0 — 2026-07-04

The biggest release yet: a completely rebuilt Leveling/Layout tab, three new on-screen tools, and full localization of it all.

#### Added

- **Leveling tab completely rebuilt around a live keyboard layout.** The old per-class/spec guide (~6,900 lines plus a 5,152-key advisor and duplicate consumables data) is gone. In its place: an ISO keyboard that reads your **actual spellbook** and lays out every ability by role, following one universal keybind standard (v6). Coverage is **all 13 classes and 39 specs** via a name→role classifier built and cross-checked against installed rotation/interrupt/defensive addons. Hand-tuned maps ship for a few specs and act as overrides; every other spec is generated live from what you can currently cast — no wrong or missing spell IDs — and it re-draws on level-up, talent/loadout swap and spec change.
- **Spell-strip category cards** under the keyboard group your abilities (builder, spender, AoE, interrupt, movement, utility, defensive, dispel/CC, cooldowns, self-heals) with real in-game tooltips. Healers get a dedicated mouseover single-target heal card; raid heals stay on keys.
- **"Consumables & extras" bar** on the Layout tab: flasks, food, weapon oils/runes, augment runes and other non-keybind essentials with live ready/missing status.
- **Missing Buff reminder** (replaces the standalone MissingClassBuff addon): a movable, resizable on-screen icon when you can cast a maintainable class buff you don't have active — raid buff, form, shield, weapon imbue, poison, stance, pet or ally buff. Click it to cast (out of combat). Own Wowhead-12.0.7-verified data across all 13 classes.
- **Openables tracker:** a movable button with a count badge and list for openable bag items — caches, lockboxes, satchels, quest containers. Left-click opens the next; items you can't open yet are hidden; a sound plays on a new drop.
- **Fast Mark bar:** mark your target (raid icons + clear), drop world markers (left-click set, right-click clear, clear-all) and run a ready check, on a draggable bar that appears only while you're in a party/raid. Enable in Settings or with `/mh mark`.

#### Changed

- **Route arrow shows a per-content icon and colour** — rare (red), treasure (gold), achievement (yellow), reset route (blue). If **WaypointUI** is installed, the route is handed to its in-world pin; with TomTom it stays out of the way; with neither, the built-in arrow guides you.
- **Guides are out of Beta** (Codex, Guide, Leveling, Macros, Role Academy).
- **Full localization** of everything new into German, French, Spanish, Portuguese, Italian and Dutch.

#### Fixed

- Ritual consumable checks now trigger on every ritual site, not one hardcoded scenario.
- The treasure toast no longer vanishes when you move away from a treasure it's already showing.
- Dungeon boss info opens when you **target** the boss, instead of on encounter-start.
- Route clearing is more reliable across all route types (internal clears no longer stop a route the player didn't clear).

---

## CF page description — suggested short blurb

> **2.3.0** — the Leveling tab is reborn as a live keyboard layout that reads your own spellbook and shows every ability on the right key, for all 13 classes and 39 specs. Plus a clickable Missing Buff reminder, an Openables tracker, a Fast Mark bar, a per-content route arrow, and full translations. (Guides are now out of Beta.)

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-2.3.0.zip` |
| **Display version** | **2.3.0** |
| **Game version** | Retail — interface **120007** (12.0.7) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud (`tools/` en `docs/` mogen er NIET in).
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden of `Locales/i18n_*`-werkbladen.
- Changelog hierboven plakken; game version Retail 120007.
- Description bijwerken vanuit `CURSEFORGE_DESCRIPTION.md` (compleet herschreven voor 2.3.0).

### Test (na /reload / na upload)

**Layout / Leveling (de grote wijziging):**

- Log op meerdere classes/specs → Layout-tab tekent automatisch de map met live tooltips (ook classes zonder hand-map: Warrior, Rogue, niet-Frost Mage …). Hand-maps (Frost/Enh/Ele/Hunter/Paladin) blijven de override.
- Level een level / wissel talent-loadout / wissel spec → de map hertekent automatisch.
- Spell-strook-kaarten onder het toetsenbord tonen de juiste categorieën; hover een rij = echte spell-tooltip. Healer → aparte "Single-target heals (mouseover)"-kaart.
- "Consumables & extras"-balk toont ✓/✗-status.

**Nieuwe tools:**

- **Missing Buff:** mis een class-buff → icoon verschijnt; klik = casten (buiten combat). Test o.a. Hunter (pet), Mage (Arcane Intellect), Shaman (shields/imbues), Rogue (poisons).
- **Openables:** draag een cache/lockbox → knop met teller; links-klik opent; te-hoog-level items verborgen.
- **Fast Mark:** `/mh mark` of Settings → in een groep verschijnt de balk; klik een target-marker, zet/​wis een world-marker, ready check.

**Pijl:**

- Zonder TomTom/WaypointUI: eigen pijl met per-type icoon/kleur (rare rood, treasure goud, reset blauw).
- Met WaypointUI: eigen pijl verdwijnt, WaypointUI toont de pin.
- Met TomTom: TomTom-pijl stuurt, onze pijl blijft stil.

**Beide:**

- In-game changelog-popup toont **2.3.0** bovenaan met de nieuwe regels.
- Geen Lua-errors bij login (`/console scriptErrors 1`).
- Talen: wissel taal (`/mh lang de|fr|es|pt|it|nl`) → nieuwe features/settings staan in die taal.
