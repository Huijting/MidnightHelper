# CurseForge release 1.7.1 — copy/paste

**Upload:** `dist/MidnightHelper-1.7.1.zip` (build with `tools\package.ps1`).
**Description:** geen volledige vervanging nodig; optioneel de Dungeons-
sectie aanvullen met de boss-window-zin (onderaan) en de "honest footnote"
over EN/NL-only boss steps SCHRAPPEN uit eerdere teksten — die geldt niet
meer. Screenshot-suggestie: het boss-venster mét model-zijpaneel naast een
boss (Robs Derelict Duo-shot was prachtig).

---

## Short summary (one line)

The Boss Window update: a floating boss companion with a full 3D model, auto-advancing boss pager, Chat/Share buttons and Shift+scroll scaling — plus boss steps now in all six languages.

---

## Changelog — paste below (since 1.7.0)

### 1.7.1 — 2026-06-12

#### New

- **Floating Boss Window**: a compact companion window that opens automatically at every boss pull and follows the fight — the current boss's steps with **clickable spell links**, a **full-body 3D model** in an attached side panel (close it per dungeon; the portrait button brings it back), a boss pager that **advances automatically when a boss dies**, Chat and Share buttons, a resize grip, ESC to close, and **Shift+scroll to scale the whole window** — perfect for ultrawide and high-DPI setups. Drag it anywhere; position, width and scale are remembered.
- **Boss steps in all six languages.** The last localization gap is closed: every one of the 43 boss guides now reads natively in English, Nederlands, Deutsch, Français, Español and Português. (Spell names were already shown in your client's language via the links.)

#### Fixed

- Windrunner Spire boss order: Emberdawn is boss 1 (Coach tab, boss window pager and live coach all corrected).
- Boss window model could render empty on first show (async model loading) — it now reloads itself an instant later.
- Closing the model side panel is now per dungeon: the next dungeon always opens with the model visible.

---

## Projectpagina — zin om aan de Dungeons-sectie toe te voegen

In a dungeon, a floating boss window follows the fight: the current boss's steps with clickable spell links and a full 3D model at your side — it pages to the next boss automatically when one dies. Scale it with Shift+scroll to fit any screen.
