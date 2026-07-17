# Midnight Helper

[![Discord](https://img.shields.io/badge/Discord-join%20the%20community-5865F2?logo=discord&logoColor=white)](https://discord.gg/kBHaHcsASQ)
[![CurseForge](https://img.shields.io/badge/CurseForge-download-F16436?logo=curseforge&logoColor=white)](https://www.curseforge.com/wow/addons/midnight-helper)

💬 **Need help or want to help translate?** Join the [Midnight Helper Discord](https://discord.gg/kBHaHcsASQ).

Midnight Helper is an all-in-one World of Warcraft addon for quick weekly planning and character management.

It combines Delves, Great Vault progress, alt snapshots, in-delve coaching, professions utilities, leveling guides, and city guide helpers in one compact UI.

## Features

- **Midnight Codex** — handbook (Start Here, currencies with live balances, weekly loop, delves, M+, raid, world, professions) with buttons into each tab.
- Delves dashboard with currencies, bountiful tracking, Great Vault helper, and travel assistant.
- **Delve Coach** — tips for all 11 Midnight delves; boss 3D preview; party share to group chat.
- **Delve consumables** — RAID-R Mini / Trovehunter's Bounty popup and minimap buttons (in-delve only).
- **Valeera curio advisor** — Delves tab + repair/gossip popup.
- Account snapshot with per-character vault status, keys, shards, and profession currency tooltips.
- Profession tools, Role Academy, Macros, Consumables, and the Midnight 80–90 Leveling Guides tab.
- **Class-layout keybind coach** — reads your live spellbook and shows a recommended keyboard layout per spec, with spell tooltips.
- **On-screen route arrow** — a standalone rotating arrow + Blizzard user-waypoint for rares, treasures, achievements and the weekly reset route. Stands down automatically when TomTom or WaypointUI is driving.
- SMC City Guide with waypoints and optional weekly checklist.
- Optional TomTom / WaypointUI integration (Blizzard user-waypoint fallback when neither is present).
- **Languages:** English, Deutsch, Français, Español, Português (BR), Italiano, Nederlands (`/mh lang`).

See `CURSEFORGE_DESCRIPTION.md` for the full feature list.

## Commands

- `/mh` or `/midnight` — toggle main window
- `/mh codex` — Midnight Codex (Start Here)
- `/mh coach` — Delve Coach
- `/mh items` — delve consumables panel
- `/mh lang auto|en|de|fr|es|pt|it|nl` — language
- `/mh settings` — quick settings
- `/mh changelog` — changelog window
- `/mh debug` — debug mode

## Requirements

- WoW Retail
- Current TOC interface: `120007` (patch 12.0.7 "Midnight")
- Optional: TomTom (for enhanced waypoint flow)

## Installation

1. Download the latest release zip.
2. Extract the `MidnightHelper` folder into:
   - `World of Warcraft/_retail_/Interface/AddOns/`
3. Restart WoW (or `/reload` if already in-game).
4. Enable **Midnight Helper** in the AddOns list.

## Maintainer checks

- Lua syntax: run `python tools/lua_syntax_check.py` from the repo root to compile every addon Lua file with `luac -p` (Lua 5.1) and catch syntax errors before release. This same check runs automatically on GitHub for pushes and pull requests.

## Notes

- Alt snapshot data is refreshed on login and relevant update events.
- Some Blizzard APIs only return progress while logged on that character, so the alt view reflects each character's latest saved state.

## Credits and References

- [Wowhead](https://www.wowhead.com/) for public game-reference validation and lookup support.
- [Icy Veins](https://www.icy-veins.com/wow/) for external leveling and talent reference links.
- [TomTom](https://www.curseforge.com/wow/addons/tomtom) for optional waypoint integration.

## Disclaimer

Midnight Helper is a fan-made addon and is not affiliated with, endorsed, sponsored, or specifically approved by Blizzard Entertainment, Inc.

World of Warcraft and Blizzard are trademarks or registered trademarks of Blizzard Entertainment, Inc. in the U.S. and/or other countries.

Game data and recommendations may change with patches, hotfixes, or tuning updates.

## Reporting Issues

Please open an issue on the project repository with:

- What happened
- Expected behavior
- Repro steps
- Character/realm and region
- Screenshot (if applicable)
