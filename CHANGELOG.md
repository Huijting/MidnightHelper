# Changelog

All notable changes to this project are documented in this file.

## [1.7.1] - 2026-06-12

### Added

- **Floating Boss Window** (`/mh bosswin`): a compact, movable companion window with the current boss's steps — clickable spell links, a full-body **3D model side panel** (close it per dungeon; the portrait button brings it back), boss pager that **auto-advances when a boss dies**, Chat and Share buttons, resize grip, and **Shift+scroll to scale** the whole window (great for high resolutions). Opens automatically at every boss pull; closing it keeps it away for that dungeon only.
- **Boss steps now in all six languages** — the final localization gap is closed: every dungeon guide reads natively in English, Nederlands, Deutsch, Français, Español and Português (spell names were already client-localized via the links).

### Fixed

- **Windrunner Spire boss order:** Emberdawn is boss 1 (was listed after Derelict Duo) — affects the Coach tab, boss window pager and live coach.
- Boss window model could render empty on first show (async model loading) — it now reloads itself an instant later.

## [1.7.0] - 2026-06-11

### Added

- **Dungeons tab** — your new dungeon companion (sidebar → Dungeons):
  - **This week:** Spark weekly, Halduron's dungeon of the week, Cracked Keystone and your Great Vault Dungeons row, tracked live.
  - **Dungeons 101:** a six-chapter beginner course from your first queue to your first Heroic, with per-character progress — in all six languages.
  - **Dungeon Coach:** boss steps for **all 12 dungeons (43 bosses)** — what to dodge, what to kick, what your role does — in plain beginner language. Every ability is a **clickable spell link**: hover for the real tooltip, and the spell names show in your client's language. Collapsible per dungeon, with a route button to every entrance (TomTom + travel advice, including the legacy portals).
  - **Live coach:** the steps for a boss appear in your chat the moment you pull it (once per boss per session; `/mh livetips` toggles). `/mh bossshare` shares the last boss's steps with your group — used mid-fight, the share is queued and sent automatically the moment combat ends (Blizzard blocks addon chat in combat).
  - Boss steps are written against DBM data and Wowhead spell tooltips; in-game verification is ongoing — corrections welcome!
- **Rare alert, supercharged:** the toast now shows the actual **3D model** of the rare at double size, is **draggable** (position saved for all toasts), and knows when you're already flying to your routed target ("you're nearly there!" instead of "click to add a waypoint"). New option: only alert during an active rare hunt (starts when you route a rare, ends when the route is done). False positives from treasures/events are gone (kill-vignette filter + npcID matching).
- **Weekly shard cap alert:** one clear popup (with its own ready-check sound) the moment a character hits 600/600 Coffer Shards for the week — stop farming, go do something fun. `/mh shardtest` previews it.
- **"After the reset" routine on Home** now understands low-level characters: quest givers show "available from level 90" instead of sending you to an NPC with nothing to offer, Halduron's leveling weekly is tracked, and profession weeklies respect your skill level.

### Fixed

- **Ritual Sites intro hint is step-aware:** it now shows exactly which of the five intro steps is next (robust against Blizzard's out-of-order quest flags) instead of always pointing at Lilatha.
- **Vordaza (Maisara Caverns):** corrected dangerous advice — kill the Unstable Phantoms before they reach anyone; do not touch them.
- **Herbalism/Mining 101:** corrected the Overload mechanic description (12h cooldown reduced by gathering, not a 30-minute cooldown).
- **Delves guidance:** Start Here and the weekly hints now mention that Delves are capped at Tier 3 below level 90.
- **Dungeons 101 chapter 3:** arrow glyph no longer renders as a box.
- **Shard cap alert:** the once-per-week marker is only set when the popup actually shows (a /reload could previously swallow it).

## [1.6.0] - 2026-06-10

### Fixed

- **Ritual Sites:** Daggerspine Point Curious Obelisk waypoint **37.59, 65.20** (was 34.9, 65.4).
- **Main window:** programmatic resize (Delves min-height, saved size apply) no longer sets `mainWindowUserSized`, so auto-sizing still works until you drag the grip.
- **Account snapshot:** vault progress is not overwritten with zeros on login before `C_WeeklyRewards.GetActivities` loads; previous vault values and `ts` are kept until a real refresh.
- **Vault Advisor:** no Lua error on low-level / spec-less characters (title falls back to `?`).
- **Travel Assistant:** Hearthstone secure button uses `/use item:6948` so it works on non-English clients.
- **Delve bounty toast / Vault Advisor:** forward-declaration fixes for `GetItemIcon` and `GetItemIDFromLink` (avoids nil global calls on 12.x).
- **Weekly reset timing:** Account snapshot and Vault Reminder use `C_DateAndTime.GetSecondsUntilWeeklyReset` via `ns.MhGetWeeklyResetAnchorTs()` (region-correct; US Tuesday / EU Wednesday at server reset) instead of hardcoded local Wednesday 08:00.
- **Toasts:** hide timer uses `C_Timer.NewTimer` so dismissing one toast early no longer fades out the next queued toast.
- **Main window:** opening the Delves tab no longer forces height to 800px on every switch; content scrolls in the existing Delves ScrollFrame.
- **Search bar:** Codex topic search (`vault`, `weekly`, `delve`, `dawncrest`, etc.) runs before Guide/SMC routing — the old `MH_RunSearchQuery` wrap in Midnight Codex was overwritten by Guide.lua at load time and never ran. Typo-tolerant second pass for longer keywords (e.g. `dawncreast` → Dawncrest).
- **Vault Reminder:** after claiming vault rewards, the reminder button clears immediately for the logged-in character (live `C_WeeklyRewards.HasAvailableRewards` is authoritative; stale snapshot no longer keeps "ready").
- **Alt Overview:** characters without a vault snapshot timestamp (`ts == 0`) no longer show a false "likely claim" status.
- **Consumables:** fixed mistranslated spec-cycle hint in German, French, Spanish, and Brazilian Portuguese (`CONS_SPEC_HINT`; German had literally "bicycle specifications").
- **Toolbox — Professions — Generate Route Treasures/Books:** dynamic TomTom arrow to the nearest remaining pin with auto-advance, region gate, and hearthstone/portal travel advice via the shared travel assistant.
- **Void & Rituals — Ritual Coach:** removed misleading per-run unlock tags (obelisk learn/unlearn is selection, not permanent unlock).

### Improved

- **Midnight Codex:** four **12.0.7** articles (Showdowns, Sporefall, Omnium Folio, Turbulent Timeways) in all six locale packs (`CODEX_127_*`).
- **12.0.7 prep:** `ShowdownsData.lua` — PTR-verified Naigtal ids (uiMapID 2600, weekly 96717, Riftstalker's Cache 275690); Val placeholders until next rotation. See `docs/PTR_12.0.7_DATA.md`.
- **12.0.7 prep:** PTR-verified Silvermoon Showdown portal (**2393, 47.93, 48.09**); two more Naigtal rare NPC ids in `docs/PTR_12.0.7_DATA.md` (Warbringer Thal'kuur, Auredar's Chassis).
- **12.0.7 prep:** `docs/PTR_12.0.7_DATA.md` §3b — instructions for collecting rare coords and kill-quest IDs before adding Showdown rares to `Rares.lua`.
- **Account weekly checklist:** Showdown weekly line for the current character on 12.0.7+ clients (build-gated; hidden when zone weekly ID is unknown).
- **World tab — Showdowns (12.0.7):** new section under Void Assaults (active rotation, weekly progress, world boss, Heroic World Tier in-zone, Maella waypoint). Hidden on clients below interface 120007; portal button stays hidden until Voidstorm map ID is verified.
- **Professions tab:** BAG_UPDATE / QUEST_LOG_UPDATE refreshes are debounced (max one panel refresh per 0.2s) so looting or quest hand-ins do not trigger a burst of redraws.
- **Professions tab:** Enchanting characters see weekly disenchant material bag counts (Swirling Arcane Essence 0–5, Brimming Mana Shard 0–1) in the currency summary.
- **Midnight Codex:** article blocks are pooled and reused on refresh (AcquireRow-style pattern), so Currencies live updates no longer create new frames on every `CURRENCY_DISPLAY_UPDATE`.
- **Sidebar:** Home is listed first in the This Week section (matches the default tab).
- **Layout:** shared `ns.UI_METRICS` insets for Home and Codex panels (prep for tab consolidation).
- **Main window:** resize cap scales up on large displays (up to 1400×1200, bounded by screen size); verified at 1400px width on UI scale 1.35.
- **Toolbox — Consumables:** click an item row to copy its name for the Auction House (repeated clicks cycle alternates); tooltip hint on item hover.
- **Travel Assistant:** Mage **Teleport: Silvermoon City** and **Portal: Silvermoon City** buttons in the travel popup; `ShowTravelAssistFor` is reusable for treasure routes and other waypoints.
- **Toolbox — Professions:** treasure/book tracker grouped by zone; generate buttons renamed and localized (`Generate Route Treasures` / `Generate Route Books`).

### Changed

- **TOC:** `## Interface: 120005, 120007` for live + 12.0.7 PTR; drop `120005` from the TOC once 12.0.7 is live (see `RELEASE_CHECKLIST.md`).
- **Sidebar (13 tabs):** **Toolbox** merges Macros, Consumables, and Role Academy (sub-tabs under Guides). Legacy tab ids (`macros` / `consumables` / `academy`) still route via `SelectTab` for Guide and Codex navigation. Beta Settings checkboxes gate the Macros and Academy sub-tabs.
- **Sidebar (12 tabs):** **Reference** is now a **Midnight Codex** category (embedded Reference guide with Dawncrest / Professions sub-tabs). `SelectTab("reference")` still works via alias. Reference beta checkbox gates the category button.
- **Keybinding:** internal binding id is now `MIDNIGHTHELPER_TOGGLEMAIN` (was generic `TOGGLEMAIN`, collision-prone across addons). Default **Alt+M** is unchanged; if you set a **custom** key for Toggle main window, re-bind it once under **Keybindings → Midnight Helper**.
- **Interrupt macros:** replaced the old focus-swap macro with **Focus** and **Mouseover** variants (one spell table, generated per spec). If you copied the old macro into your action bars, copy the new text from **Toolbox → Macros → Interrupt**.
- **Professions panel:** moved from the sidebar into **Toolbox** (legacy `SelectTab("professions")` and search still route there).
- **Toolbox — Professions:** one hub sub-tab with **Overview**, **Treasures & Books**, and **Course (101)** inner tabs (legacy `professions` / `profacademy` ids still route to the matching inner tab).
- **Professions panel — Generate Treasures/Books:** TomTom waypoints now follow a shortest-hop route per zone (greedy chain from your position or the first pin), grouped by map.

### Added

- **Home — "After the reset" routine:** ordered per-character to-do list at the top of Home (claim the Great Vault, weekly quest givers next to the vault, Ritual/Void weeklies at the Bazaar hub, profession trainer weeklies) with live status colors (to do / picked up / done / locked) and a one-click **TomTom route along the open stops** (vault → quest givers → hub → trainer).
- **Weekly quest givers tracked:** Lady Liadrin's Spark weekly (choice of four), Halduron Brightwing's dungeon-of-the-week, and Aethas Sunreaver's event weeklies show real per-NPC pickup/done status.
- **Profession trainer weeklies — all 11 professions:** the Professions Hub "This week" block and the reset routine now track every profession's weekly trainer/service quest (including rotating variants for Enchanting and the gathering professions).
- **Account snapshot — per-slot vault detail:** hover a character's vault column to see, per World/Dungeon/Raid slot, the **item level of the reward currently locked in** (Blizzard's own example reward) and the registered tier — so on an alt you instantly know whether higher delves or rituals are still worth running this week.
- **Void & Rituals — two views:** "This week" (currencies, active sites, weekly status with live progress %, route buttons, compact challenge list) and "Ritual Coach" (full reference: scenario notes, how-it-works, challenge mechanics and unlocks, party share). Your choice is remembered.
- **Void & Rituals — live weekly progress:** the Void Assaults zone weekly shows its "Strikes disrupted" percentage live; same for the Ritual weekly when it exposes a progress bar.
- **Ritual weekly intro hint:** characters that have not finished the per-character intro questline ("Ranger Captain's Summons" chain) see exactly that, instead of a misleading "pick it up at the hub".
- **Ritual Coach — site intel completed:** Broken Throne scenario ("A Corrupted Path" — Faithbreaker Ger'lok), Dark Obelisk locations for **both** sites, verified Tainted Bone Pile spots, and recommended item levels per tier (T1 215 → T5 264).
- **Home — World boss route button:** one click sets a TomTom waypoint to the active world boss.
- **Localization:** Ritual Coach, Start Here, the route buttons and all new strings above are fully translated in all six languages (English, Nederlands, Deutsch, Français, Español, Português).
- **Delve party share v2:** receivers with a different chat locale get tips re-rendered locally via addon message (`MHDelve` prefix); plain chat text remains the universal fallback. Solo test mode whispers the descriptor to yourself.

### Added (verify on second PC before CurseForge release notes)

- **PTR sync:** `Sync-MidnightHelper-PTR.bat` copies the working tree to `_ptr_` / `_xptr_` installs (excluded from CurseForge zip).
- **Keybinding (1.5.5):** **Keybindings → Midnight Helper → Toggle main window** — same as `/mh`; default **Alt+M**; Stream Deck hotkey OK. *Not in CF changelog until confirmed.*
- **Toolbox — Professions 101:** beginner profession course (seven chapters, per-character progress, class-based profession advice, Enchanting/Alchemy starter chapters when owned, KP tree summary when spec data is available). Work Order station waypoint at Captain Flaresworn.
- **Toolbox — Professions 101:** starter chapters for all eleven Midnight professions with trees (Tailoring through Skinning); only chapters for professions you have are shown.
- **Toolbox — Professions 101:** Tree Advisor shows live next-root advice per owned profession (purchased ranks, repeated under the choosing-trees chapter).
- **Toolbox — Professions 101:** new **Gear up** chapter (tools, stations, Midnight tier, first recipes) with auto-detect when profession tools are equipped (slots 20/23).
- **Toolbox — Professions Hub:** **This week** block on Overview (trainer weekly quest flag per known profession, Enchanting disenchant mat bag counts).
- **Toolbox — Professions Hub:** Tree Advisor v2 — per-character advice goal (Allround / Gold / Self-sufficient) with goal-specific routes and hover tooltips on the goal buttons.
- **Toolbox — Professions Hub:** trainer weekly unlock hint when not yet available; optional accessory-slot tip on Overview (slots 21/22/24/25).
- **Void & Rituals — Ritual Coach:** scenario tips and challenge picker (sorted by Spoils) with party share (`MHRitual` cross-locale sync) and ritual weekly hints (locked / pickup / in-progress).
- **Start Here:** new-player roadmap tab with weekly progress ticks and navigation into existing tabs.

### Fixed

- **Combat lockdown:** rare-spotted toast no longer triggers `ADDON_ACTION_BLOCKED` (`SetPropagateMouseClicks`) when your first toast of the session fires mid-combat — the toast frame is now created at load time.
- **Vault reminder popup:** closes itself after you click the waypoint button (the arrow takes over).
- **SMC city guide — World boss button:** shows the boss name whenever it is known (live, cache, or kill data); only a pure rotation guess gets an "open map to confirm" suffix.
- **Font rendering sweep:** characters the game fonts can't render (checkmark in the Dawncrest done-line, unguarded arrow glyphs, invisible zero-width spaces from old machine translations) replaced or removed across all six languages; a handful of garbled machine-translated strings rewritten.
- **Keybindings:** appear under **Midnight Helper** (not Other); binding uses `SlashCmdList` (not Other / broken direct call).
- **Keybindings:** `Bindings.xml` not listed in `.toc` (avoids Unrecognized XML warnings).

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
