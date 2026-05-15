# Midnight Helper

Midnight Helper is an all-in-one World of Warcraft addon for quick weekly planning and character management.

It combines Delves, Great Vault progress, alt snapshots, professions utilities, and city guide helpers in one compact UI.

## Features

- Delves dashboard with current currencies and bountiful tracking.
- Great Vault helper on the Delves tab.
- Account snapshot with per-character overview:
  - Keys, Shards, Undercoins
  - Great Vault compact status for World / Dungeons / Raids
- Subtle reset-day highlight for characters with claimable vault rewards.
- Profession helper tools and overview.
- SMC City Guide with waypoint support.
- Optional TomTom waypoint integration.
- English and Dutch UI support (`enUS`, `nlNL`).

## Commands

- `/mh` or `/midnight` - Toggle main window
- `/mh lang en` - Switch language to English
- `/mh lang nl` - Switch language to Dutch
- `/mh settings` - Open quick settings
- `/mh debug` - Toggle debug mode

## Requirements

- WoW Retail
- Current TOC interface: `120005`
- Optional: TomTom (for enhanced waypoint flow)

## Installation

1. Download the latest release zip.
2. Extract the `MidnightHelper` folder into:
   - `World of Warcraft/_retail_/Interface/AddOns/`
3. Restart WoW (or `/reload` if already in-game).
4. Enable **Midnight Helper** in the AddOns list.

## Maintainer checks

- Leveling tips: run `python tools/audit_guide_spell_tips.py` from the repo root to verify every `GuideData.lua` tip key exists and has text in `Locales/GuideTips.lua`. This same check runs automatically on GitHub for pushes and pull requests.

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
