# Changelog

All notable changes to this project are documented in this file.

## [Unreleased]

## [1.5.4] - 2026-06-03

### Added

- **Keybinding:** **Esc → Keybindings → AddOns → Midnight Helper → Toggle main window** (no macro on a hidden action bar needed; works with Stream Deck hotkeys).

## [1.5.3] - 2026-06-03

### Fixed

- **World boss weekly status** no longer shows last week's kill as done after reset (only the active boss this week; clears stale SavedVariables; uses Blizzard weekly reset time).
- **World boss** login error fixed (`attempt to call a nil value` in cache cleanup).
- **Packaging:** CurseForge zip excludes dev files (`Sync-MidnightHelper.bat`, scripts); build fails if any slip through.

## [1.5.2] - 2026-06-02

### Fixed

- **Delve story tooltip hook** no longer registers on every tooltip type (e.g. **UnitAura** from nameplate addons). Fixes `secret number` compare errors in delves when addons such as **Platynator** show aura tooltips.
- **POI ID** handling uses `canaccessvalue` / safe tonumber before matching delve map POIs.

## [1.5.1] - 2026-05-30

### Added

- **Midnight Codex** (beta sidebar tab): handbook with **Start Here**, weekly loop, currencies, delves, dungeons, raid, world content, and professions — each article links to the relevant addon tab. Toggle in **Esc → AddOns → Midnight Helper** (beta tabs).
- **Live currency balances** in Codex (with snapshot fallback) and **Blizzard tooltips** on currency titles and icons.
- Global search keywords (`codex`, `wiki`, `start here`, `currency`, …) open the Codex.
- **Delve weekly trackers** on Home: Trovehunter's Bounty, Gilded Stash (T11+ bountiful), and Special Assignments with account alt rollup.

### Changed

- Codex moved into the **beta** sidebar block (between Professions and Consumables) with its own settings checkbox.
- Codex **Open** buttons use correct destinations (e.g. Dawncrests → **Basics**, Great Vault → **Delves & Vault** section).

### Fixed

- **Trovehunter's Bounty** on Home / Account: no longer shows “looted — use it!” unless the map is actually in your bags.
- **Delve Coach**: auto-select active boss in multi-boss delves; session-only carousel browse without sticking preview state; live delve **boss 3D preview** and story-variant detection (map tooltip, Grudge Pit / Arena Champion fallbacks).

## [1.5.0] - 2026-05-29

### Added — Home "This Week" dashboard

- New **Home** tab that opens by default: weekly reset countdown, account-wide Great Vault status, world boss this week, weekly chores (SMC, keys, shards), and a quick shortcut to Rares.

### Added — Rares tab

- **Rares** tab with per-character weekly tracking. Pick the nearest incomplete rare or build a full **route** (nearest-neighbour ordering).
- Distances use **world coordinates (yards)** so the route truly starts at the closest rare and works across maps.
- **TomTom** integration: the "crazy arrow" stays locked on the nearest waypoint instead of jumping to the last one added.

### Added — Live rare-nearby alerts

- Audible alert + on-screen toast when a tracked rare is detected near you, **even with the main window closed** (uses `C_VignetteInfo`).
- Distance-gated (~500 yds) so you are not pinged for rares across the zone; a far rare still alerts once you get close.
- Clicking the toast adds the rare as an **extra** TomTom waypoint (arrow points to it) **without clearing** a route you are already following.
- Toggle in **Esc → AddOns → Midnight Helper**.

### Changed

- Sidebar tabs grouped into labelled sections; **Reference** tab renamed to **Basics**.
- Main window enforces a dynamic minimum height so the new tabs never overlap the About button.

## [1.4.3] - 2026-05-27

### Changed — World boss

- Moved from SMC City Guide to **Delves & Vault** tab (top of panel).
- Warband kill stored in SavedVariables so alts show done without re-opening the map.
- Compact single line when warband already finished (~18px, no empty gap).

### Fixed

- TomTom button uses fresh state (no stale “open map” after UI already shows the boss).
- Alt shows “warband done (CharacterName)” when another character completed the boss.

## [1.4.2] - 2026-05-27

### Fixed — World boss (SMC City Guide)

- TomTom button always re-checks live/cache state (no stale “open map” after UI already shows the boss).
- Compact one-line row when the warband already completed this week's boss (shows character name).
- Account-wide week cache: once any character finds the boss, alts use it without opening the map.
- Background scan on login scans zone map data automatically.

## [1.4.1] - 2026-05-27

### Added

- **SMC City Guide — World boss this week:** shows the active Midnight Season 1 boss (Lu'ashal, Cragpine, Thorm'belan, or Predaxas), warband kill status, and a **TomTom** button with Travel Assistant for cross-zone routing.

## [1.4.0] - 2026-05-27

*First CurseForge upload after **1.3.2**.*

### Added — Great Vault Advisor

- **Great Vault Advisor** side panel on Blizzard’s Great Vault loot screen: ranks vault choices vs. your equipped gear (item level, guide stat weights, tier sets).
- **Auto / Raid / M+** stat profiles (Auto picks raid vs. M+ weights from vault slot type).
- Optional **Pawn** integration when installed.
- Advisor strings and settings in **Esc → AddOns → Midnight Helper** (all six UI languages).
- Hero-talent-specific stat weights for supported specs (Icy Veins–sourced catalog).

### Added — Beta sidebar tabs

- **Beta** tab group in the sidebar (between Professions and Consumables): **Guide** (reference), **Leveling Guides**, **Macros**, **Role Academy** — each with a Beta badge and tooltip.
- Per-tab and master toggles in addon settings (`Show beta tabs in sidebar`).

### Added — Vault reminders (settings)

- Great Vault reminder options in addon settings: chat summary, minimap ping, login popup (localized).

### Changed

- Sidebar layout: beta block separated; macros no longer duplicated at the bottom of the tab list.
- Vault Advisor panel layout and Blizzard vault UI hook polish; duplicate advisor on Delves tab removed.

### Fixed

- Beta tab settings checkboxes no longer cause Lua errors (`RefreshBetaTabVisibility` nil `self`).
- Vault Advisor Blizzard banner / claim UI edge cases from earlier 1.4.0 dev builds.

## [1.3.2] - 2026-05-23

*First CurseForge upload after **1.3.0** — bundles everything that landed on `main` since then (including work that was tagged 1.3.1 in git only).*

### Added — Localization

- **Six UI languages:** English, **Deutsch**, **Français**, **Español**, **Português (BR)**, and **Nederlands** (NL is addon-only — use `/mh lang nl`).
- **`/mh lang auto`** follows your WoW client when a pack exists (`de`, `fr`, `es`, `pt`, `en`; `esMX` → Spanish pack).
- Translated **Delve Coach** tips, **Leveling Guides** advisor + gear notes, consumable notes, and guide groups for DE / FR / ES / PT / NL (not only EN/NL anymore).
- Minimap broker language picker updated for all packs.

### Added — Features

- **Valeera curio advisor** on the Delves tab and popup at repair / gossip NPCs.
- **Delve consumables:** per-delve session tracking, “active” state, `/mh items mark` and `/mh items reset`; secure item-click buttons.
- **Bounty toast** reminder when Trovehunter's Bounty is available in a delve.
- **Leveling Guides — In groups** tab: interrupt priority, defensives, and party tips by role (level brackets 10 / 30 / 60 / 80).
- Leveling Guides **Layout** sub-tab: ISO keyboard prototype (Midnight key highlights).
- **SMC City Guide** weekly/hub checklist; waypoint buttons tint green when quests are done (configure IDs in `Modules/SMCChecklistData.lua`).

### Changed

- Delve consumable minimap icons and popup behaviour polished for Midnight secure rules.
- Delves panel layout and localized delve names improved.

### Fixed

- Delve consumables popup: no Lua errors on use or `/mh items mark`; no forbidden `COMBAT_LOG_EVENT_UNFILTERED` registration on Midnight.
- Delve party chat fallbacks where needed for client font/locale edge cases.

## [1.3.1] - 2026-05-24

*Git-only tag between CF 1.3.0 and 1.3.2 — not published separately on CurseForge.*

### Added

- Valeera curio advisor; delve consumables session tracking; bounty toast (see **1.3.2** notes above).

## [1.3.0] - 2026-05-19

### Added

- **Delve Party Share:** send Delve Coach tips to party, raid, or instance chat (brief, boss, sections, copy dialog). Recipients do not need this addon. **Test (/say)** on Delve Coach for solo testing.
- **Delve items popup:** quick-use panel for **RAID-R Mini** (244193) and **Trovehunter's Bounty** (252415) when you carry them in a delve.
- **Minimap launchers** for those items (left-click opens popup, right-click uses item) — visible **only during an active delve**.
- **Delve Coach:** Shift + mouse wheel scales the whole panel (like the main Midnight Helper window). Resize via corner grip, bottom bar, or right edge; mouse wheel scrolls tip text.
- Party-share chat lines with **spell hyperlinks** (EN/NL).

### Changed

- Delve items UI auto-shows when entering a delve (retries until `IsDelveInProgress` is true). Closing the popup suppresses auto-show until the next delve.
- Boss spotlight: more reliable first-load preview, loading text no longer hidden behind the model, saved zoom per boss.

### Fixed

- Party share only sends when you are in a real group (avoids Blizzard “You aren't in a party” spam when solo).
- Delve Coach “More” share menu, share API wiring, and assorted open/layout edge cases from 1.2.6 testing.

### Note

- Major feature release for CurseForge. Small follow-up patches may use the **Valeera** codename in release notes.

## [1.2.6] - 2026-05-21

### Added

- **Delve Coach:** floating in-delve tips panel for all **11 Midnight Season 1 delves** (Overview, Route, Trash, Boss).
- **English and Dutch** tip text (`/mh lang en` / `/mh lang nl`); locale validation for every delve section.
- **Boss spotlight:** 3D creature preview with prev/next; **mouse-wheel zoom** per boss (saved per character).
- **Blue spell hyperlinks** in tips (hover/click for spell tooltips where IDs are known).
- **Preview** from Delves tab (“Delve Coach (preview tips)”) and `/mh coach`; auto-show when entering a delve (optional).
- Resizable, draggable coach window with minimize.

### Fixed

- Boss model camera framing and `SetLight` crash on `PlayerModel`.
- GameTooltip `SetText` signature on boss zoom hint (retail API).

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
