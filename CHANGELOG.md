# Changelog

All notable changes to this project are documented in this file.

## [Unreleased]

### Added

- Leveling Guides tab: **Layout** sub-tab with the ISO keyboard prototype (Midnight key highlights) using `Modules/KeyboardLayoutPrototype.lua` and `Modules/KeybindingData.lua`.
- Account snapshot now includes compact Great Vault status for World, Dungeons, and Raids.
- Reset-day subtle pulse highlight for characters with claimable vault rewards.
- SMC City Guide: weekly/hub checklist using `C_QuestLog.IsQuestFlaggedCompleted`; waypoint buttons for linked pins tint green when done. Configure quest IDs in `Modules/SMCChecklistData.lua` (verify after patches). Default ships with **no** quest IDs until confirmed (avoids false “Done” from placeholder IDs).

### Changed

- Vault tooltip wording made clearer:
  - "Choices unlocked: x / y"
  - "Next unlock at: x / y"
- Better unavailable messaging for characters where Great Vault is not available yet.

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
