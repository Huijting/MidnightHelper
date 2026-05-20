# Changelog

All notable changes to this project are documented in this file.

## [Unreleased]

### Added

- **Leveling Guides — In groups** advisor tab: dungeon/raid interrupt priority, defensive timing, and party tips per role (tank, healer, melee, caster, support) at level brackets 10/30/60/80.
- Search keywords (`in groups`, `dungeon tips`, `interrupt priority`, …) open Leveling Guides on the In groups tab.

- Leveling Guides tab: **Layout** sub-tab with the ISO keyboard prototype (Midnight key highlights) using `Modules/KeyboardLayoutPrototype.lua` and `Modules/KeybindingData.lua`.
- SMC City Guide: weekly/hub checklist using `C_QuestLog.IsQuestFlaggedCompleted`; waypoint buttons for linked pins tint green when done. Configure quest IDs in `Modules/SMCChecklistData.lua` (verify after patches). Default ships with **no** quest IDs until confirmed (avoids false “Done” from placeholder IDs).

## [1.2.5] - 2026-05-20

### Added

- **Role Academy** tab: tank and heal tracks (mindset, prep, triage, anxiety ladder from delves → dungeons/raids).
- Quick links to Macros, Consumables, Leveling Guides, and Delves from the academy panel.
- Search routes keywords such as `tank`, `heal`, `academy`, and `mentor` to Role Academy.

## [1.2.4] - 2026-05-20

### Added

- **Great Vault reset reminders:** chat on login, minimap tooltip lines, pulsing minimap icon (toggle in minimap quick settings).
- **Blizzard map waypoint fallback** when TomTom is not installed (delves, profession pins, bountiful finder, portal step).
- **Account snapshot:** profession weekly currencies in row tooltip (Abundance, Dundun shards, Moxie summary).

### Changed

- Account snapshot: sort/filter toolbar, level/ilvl, stale-since-Wednesday badge, Untainted Mana-Crystals column.
- Guide search routes consumable keywords to the Consumables tab; multi-word queries improved.

## [1.2.3] - 2026-05-19

### Fixed

- **Travel Assistant (Delves):** no longer suggests Hearthstone when you are already near a delve entrance or after you enter the delve; zone changes no longer re-open the travel popup.
- **Bountiful delve routing:** fixed a Lua error when calculating distance to the waypoint (`GetWorldPosFromMapPos` return value).

### Added

- **Consumables** sidebar tab (Wowhead-backed lists per spec, with guide search preview).

### Changed

- Clearer **TomTom** guidance (EN/NL): TomTom is recommended for the map arrow; Travel Assistant (Hearthstone / hub portals) works without TomTom. Info drawer, tooltips, travel popup hint, and chat messages updated.

### Note

- Minor drop-in update — safe to install over 1.2.2.

## [1.2.2] - 2026-05-16

### Added

- **Macros** tab: per-spec team interrupt macro plus utility macros (cursor / mouseover / focus), EN and NL descriptions.
- Guide search **preview** drives keyboard layout and macros for another class/spec without relogging.
- Guide search chat and strings respect `/mh lang en` or `nl`.

### Changed

- Midnight key layout roles (interrupt on E, overflow Alt / Shift / Ctrl).

### Note

- Addon is still actively evolving; expect ongoing tweaks and improvements.

## [1.2.1] - 2026-04-30

### Fixed

- Main window gold dialog frame: inner layout stays inside the border art so corners no longer look clipped; removed the transparent gutter along the bottom and right edges (resize grip still works and draws on top).

### Changed

- Info and About buttons restored to standard `UIPanelButtonTemplate` styling with the same chrome tint as the search row, matching other sidebar controls.

## [1.2.0] - 2026-04-29

### Changed

- Leveling guide consumables use Midnight Wowhead-backed item ID priority lists (feasts, food, flasks, potions, oil where relevant, runes); Death Knight keeps Runeforging (no weapon oil).
- Guide gear tips aligned with Stat priority where wording conflicted (including Beast Mastery Hunter and several other specs).
- Shadow Priest / Elemental Shaman guide data fixes (gear keys).

## [1.1.0] - 2026-04-29

### Added

- Delves and Great Vault dashboard improvements.
- Alt overview with per-character currencies (keys, shards, undercoins).
- Localization support for English and Dutch text flow.
