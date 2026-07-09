# CurseForge release 2.5.0 — copy/paste (RELEASE)

**Publish:** push an annotated git tag `v2.5.0` → the BigWigs packager
(`.github/workflows/release.yml`) builds and uploads the zip to CurseForge
automatically (uses `CF_API_KEY` + `X-Curse-Project-ID: 1528577` from the `.toc`).
A clean version number = **Release** on CF. No manual zip/upload needed.

> Want Cisca to test first? Either tag `v2.5.0-beta1` (packager flags it Beta),
> or upload the built zip once and set the CF file to **Beta** by hand.

**Game version:** Retail 12.0.7 (interface 120007).
**Description:** `CURSEFORGE_DESCRIPTION.md` updated (now says **40 specs, incl. Devourer**) —
re-paste it on the project page between the START/END markers.

> ⚠️ **Before tagging:** `/reload` with Lua errors on → no errors at login (also in combat),
> and the changelog popup shows **2.5.0** on top. On a Demon Hunter, switch to **Devourer**:
> the keybind coach draws its rotation + Void Metamorphosis, and the consumables bar shows a
> flask/potion. Check the minimap-icon toggle (Settings) and Alt+M opening the window.

---

## Short summary (one line)

Midnight Helper 2.5.0 adds a **Guided mode** that walks beginners through every profession one step at a time, full support for the new **Devourer** Demon Hunter spec (keybind coach + consumables), refreshes all consumables for patch 12.0.7, lets you hide the minimap button, finishes the leveling-tips translations, and fixes a batch of Delve / Ritual Site / consumable-check issues.

---

## Changelog — paste below (since 2.4.1)

### 2.5.0 — 2026-07-09 (Release)

Adds support for the new **Devourer** Demon Hunter specialization, refreshes consumables for 12.0.7, and folds in the July distribution / onboarding / polish batch.

**Added**

- **Devourer Demon Hunter support** — the new Void DPS spec. The **keybind coach** maps its
  rotation, cooldowns and **Void Metamorphosis** onto your layout, and the **consumables bar**
  recommends the right flask, potion, oil, augment rune and feast for it — just like every other spec.
- **Minimap-button toggle** — hide Midnight Helper's minimap icon for a clean minimap; the addon
  stays reachable from the game's **AddOns compartment** (top of the minimap). Open the window any
  time with **Alt+M**.
- **Guided mode for professions** — a "take you by the hand" wizard (Professions 101 → *Guided
  mode*) that walks you through learning and levelling any of the 11 professions **one step at a
  time**, ticking steps off automatically as your skill grows, with trainer and Work Order waypoints.

**Changed**

- **Consumables refreshed for patch 12.0.7** — flasks, potions, weapon oil, augment rune and feasts
  double-checked against the current guides.
- **Leveling tips (80→90)** are now fully translated into German, French, Spanish, Portuguese and Italian.

**Fixed**

- Opening **Settings while in combat** (e.g. inside a Delve) no longer throws an error.
- A **Delve crash** tied to patch 12.x "secret" values is gone.
- A **keyboard-layout tooltip crash** on the spell-strip cards is fixed.
- Toggling the **Leveling / beta tabs** now updates the window live, without a `/reload`.
- **Delve boss-coach prompt** now offers at the boss room instead of on trash mobs.
- The **Delve consumables popup** and the group **Consumable Check** no longer re-appear after the
  last boss, nor pop up solo in the open world.
- **Ritual Site buttons** always set a waypoint now (the active-site button used to do nothing).

---

## Test-checklist voor Cisca + Carola

- **Devourer:** op een Demon Hunter → spec op **Devourer** zetten. In **Leveling & Layout** tekent de
  coach de rotatie (Consume, Reap, Void Ray, Voidblade, …) + **Void Metamorphosis** op de layout, en de
  **consumables-balk** toont een flask/potion. (Op lage level zie je alleen wat je al geleerd hebt.)
- **Minimap:** Settings → minimap-icoon uitzetten laat 'm verdwijnen; MH blijft bereikbaar via de
  **AddOns-compartiment**-knop en via **Alt+M**.
- **Settings in combat:** open de instellingen terwijl je in gevecht bent (bv. in een Delve) → geen rode
  Lua-fout meer.
- **Delve:** een Delve in/uit lopen geeft geen "secret number"-crash meer.
- **Talen:** zet de taal op de/fr/es/pt/it → de **80→90 leveling-tips** staan vertaald (geen Engelse blokken).
