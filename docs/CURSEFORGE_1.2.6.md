# CurseForge release 1.2.6 — copy/paste

Use this on the project page when uploading. Add **3+ screenshots** from in-game (Delve Coach open, boss zoom, EN/NL tips).

---

## Short summary (one line)

Delve Coach: in-delve tips for all 11 Midnight delves (EN/NL), boss 3D preview with scroll-zoom, spell tooltips.

---

## Description (project page / “About”)

**Midnight Helper** is an all-in-one addon for World of Warcraft Midnight Season 1: Delves, Great Vault, alt overview, professions, city guide, leveling guides, and more — in **English** and **Dutch**.

### New in 1.2.6: Delve Coach

- Floating **Delve Coach** panel with practical tips while you run delves.
- Covers all **11 Midnight delves**: overview, route, trash, and boss sections.
- **English and Dutch** — follows `/mh lang en` or `/mh lang nl`.
- **Boss spotlight:** 3D model preview; **scroll** on the preview to zoom in/out (saved per boss).
- **Spell links** in tips (hover/click for tooltips where spell IDs are known).
- Open from the **Delves** tab (“Delve Coach (preview tips)”), **`/mh coach`**, or auto-show when you enter a delve.
- Draggable, resizable window with minimize.

### Also included

- Delves dashboard (currencies, bountiful finder, TomTom routes).
- Great Vault progress on the Delves tab.
- Account snapshot (alts, vault status, currencies).
- Role Academy, Macros, Consumables, Leveling Guides, SMC City Guide, Professions tools.
- Optional TomTom integration.

### Commands

- `/mh` — main window  
- `/mh coach` — Delve Coach  
- `/mh lang en` / `/mh lang nl` — language  

### Requirements

- WoW Retail (interface **120005**)
- Optional: TomTom for map arrows

---

## Changelog (release notes field)

### 1.2.6 — 2026-05-21

**Added**

- **Delve Coach:** floating tips for all 11 Midnight Season 1 delves (Overview, Route, Trash, Boss).
- Full **English and Dutch** tip text; locale check for every delve.
- **Boss spotlight** with 3D creature preview and prev/next navigation.
- **Mouse-wheel zoom** on the boss preview (saved per boss per character).
- **Spell hyperlinks** in tips (tooltips where IDs are verified).
- Preview from Delves tab and `/mh coach`; optional auto-show in delve.
- Resizable, draggable coach panel.

**Fixed**

- Boss model camera framing on PlayerModel.
- Tooltip error when hovering the boss preview (retail SetText API).

---

## Screenshot ideas

1. Main window → Delves tab → **Delve Coach (preview tips)** button visible.  
2. Delve Coach open on a popular delve (e.g. Collegiate Calamity or Grudge Pit) — boss model + tips.  
3. Same delve with **`/mh lang nl`** — Dutch section headers and tip text.  
4. Close-up of **boss spotlight** after scroll-zoom (model fills frame nicely).  
5. Optional: blue **spell link** tooltip on hover.

---

## Package

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

Upload: `dist/MidnightHelper-1.2.6.zip`
