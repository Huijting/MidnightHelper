# GearQuest Forever: what it is, and what MH can learn from it

Research date: Sat 7 Nov 2026. Read only. Nothing in MH was changed, nothing was installed in any game folder, and the downloaded code was read but never run.

Labels: **GEMETEN** = I saw it in a named file or page, on 7 Nov 2026. **AFGELEID** = my own reasoning, not checked in the game client.

---

## 1. Which addon "GearQuest" is

Rob's dictated name matches one CurseForge project exactly: **GearQuest Forever**. There is also an older sister project, plus four similar gear addons for Forever.

| Project (CurseForge) | Author | Flavor | Downloads | Last file | License | Source |
|---|---|---|---|---|---|---|
| **GearQuest Forever** (id 1698950) | weber8210 | Forever, 1.60.1 | **1,219,452** | v1.0.9, 6 Nov 2026 | **All Rights Reserved** | GEMETEN, CF page via Exa (`?nocache=20261107`) + CF files API |
| GearQuest - TBC Anniversary (id 1669225) | weber8210 | Classic TBC 2.5.6 only | 2,339 | v0.1.1-beta.3, 27 Aug 2026 | All Rights Reserved | GEMETEN, CF page. Its description says it is no longer worked on "due to the success of GearQuest Forever" |
| ForeverGear (id 1702821) | Loyftwa | Forever | 44,209 | 1.3.40, 6 Nov 2026 | All Rights Reserved | GEMETEN, CF page |
| GearScore Forever (id 1709249) | Daelerbackbi | Forever | 6,952 | v1.1.0, 6 Nov 2026 | All Rights Reserved | GEMETEN, CF page |
| GearedForever (id 1741641) | fistedwaffles05 | Forever | 1,855 | 1.0, 4 Nov 2026 | **GPLv3** | GEMETEN, CF page |
| Forever Gear (id 1715648) | Pyrogawd | Forever | 1,037 | 0.40.4, 22 Oct 2026 | All Rights Reserved | GEMETEN, CF page |

**I picked GearQuest Forever.** The name matches, it supports Forever, and it has far more downloads than any other project here (about 1.2M against 44K for the next one). Several Forever addon round-ups also name it, among them DalaGG's video, wowcamp.fun, mmonster.co and gamesstarter.com (5 Nov 2026). The other five projects are different addons with similar names. I did not review them.

**Facts about GearQuest Forever:**
- **Author.** On CurseForge the owner is "weber8210". The TOC says `## Author: Henrik8210`, and the login chat line says "By Weber8210". GEMETEN: `GearQuestForever.toc` and `Core.lua:304`.
- **Latest version.** v1.0.9, file id 9481633, uploaded 2026-11-06 21:04 UTC. GEMETEN: CF files API. The project has 55 files in total. The first entry on page 1 of the API list is v0.5.1-beta from 9 Oct 2026, and v1.0.0 came out on 20 Oct 2026.
- **Interface.** `## Interface: 16001`, client 1.60.1. The TOC has no `AllowLoadGameType` line. GEMETEN: TOC.
- **License.** The CurseForge "License" field says **"All Rights Reserved"**. GEMETEN: CF page, 7 Nov 2026. The zip has **no license file at all**, and the TOC has no `X-License` line. GEMETEN: full file listing of the zip, and the TOC. **So MH may not copy any code, data, art or sound from it.**
- **Data provenance.** The data comes from sources MH could not use even if the license allowed it. GEMETEN in the file headers:
  - Wowhead Forever tooltips: `Data.ForeverAudit.generated.lua` holds a "Wowhead Forever tooltip audit", and each class's `AuditTips.lua` stores Wowhead tooltip text word for word.
  - Wowhead Classic BiS guides, used for level 60 (`Data.Paladin.generated.lua` header).
  - **Questie's location index**, used to fill gaps in the coordinates (`Data.Coordinates.generated.lua` header). Questie is GPL.
  - The game client's item tables (ItemRandomProperties).
  - AtlasLoot, for a level-70 block that is a leftover from the TBC version.

## 2. Download

- **Folder:** `C:\Users\RobHu\AppData\Local\Temp\claude\e1c44003d48d72c2\6b683006-f185-4f0a-b7b3-af9a8f2dc4a8\scratchpad\dl_gearquest\`. It was new and empty.
- **Zip:** `GearQuestForever-v1.0.9.zip`, 47,825,967 bytes. That matches the `fileLength` in the CF API exactly. GEMETEN.
- **Unpacked to:** `...\dl_gearquest\x\`. It contains 10 folders: `GearQuestForever` plus `GearQuestForever_<CLASS>` for each of the 9 classes. GEMETEN.

## 3. What it does, measured in the code

### Structure
- **Main addon:** 24 Lua files.
  - Biggest files: `Log.lua` 564 KB, `Data.lua` 255 KB, `Gamepad.lua` 85 KB.
  - Generated data in `_generated/`: coordinates 3.5 MB, item stats 0.95 MB, Wowhead audit 1.05 MB.
  - Also ships about 12 MB of PNG/TGA art and 36 MP3 voice files.
  - GEMETEN: file listing.
- **Nine class addons.** Each has `## LoadOnDemand: 1` and depends on the main addon. Each holds one class's hunt lists: 4–8 MB for levels 10–60, 0.35–0.95 MB for levels 1–9, and an `AuditTips.lua` of 0.5–1.2 MB. GEMETEN: `GearQuestForever_PALADIN.toc` and the file sizes.
- **Item fact rows:** 33,791 across the class files, counting duplicates between classes. GEMETEN: grep count.
- **Memory.** The CF page says 200–400 MB depending on class, down from 1.3 GB. That is the author's claim, GEMETEN on the CF page. A CF comment from 6 Nov 2026 says it "doubles my addon memory usage". GEMETEN: CF comments API.
- **Language.** English only. There is no `GetLocale(` anywhere in the main addon. GEMETEN, with a positive control: the same grep run found `GetItemInfo(` 44 times.

### Features (all GEMETEN in code unless marked)
1. **Right-click a character-panel slot** to get a popup with the top 3 upgrades for that slot. The popup takes your class, spec, level and faction into account. `PaperDoll.lua` hooks `Character<Slot>Slot` with OnClick/OnEnter, and shows `GQ.Popup:ShowForSlot`.
2. **"GearQuest Log" window.** It has tabs for Active, Completed and Removed hunts, Lookup, Simulator and Settings. Each hunt shows its source (quest, boss drop, vendor, profession, rare NPC, container, world drop, auction house), the quest level and chain, the craft and its materials. It has Track / Show on map / Remove buttons. Code: `Log.lua`, plus the source labels in `Core.lua:168-191`.
3. **Tracker and guide arrow.** A tracked hunt goes into a tracker frame, gets world-map pins, and a "Guide" arrow can point to it. If the target is on another continent, the arrow first points to the boat, zeppelin or airship. Code: `Tracker.lua`, `Pins.lua`, `Map.lua`, `Guide.lua` (the dock table is in the comment at line 289 and below). The pins also set Blizzard's user waypoint (`Pins.lua:375-377` comment).
4. **Green pulsing up-arrow on upgrades.** It appears on any item that is one of your listed upgrades, wherever that item shows up: quest-offer and quest-log rewards, the loot frame, group loot rolls and the merchant. Profession windows are excluded on purpose. Code: `Indicator.lua:894-927` and `1766-1941`.
5. **Tooltip score line.** It shows a 0–100 number with a green or red arrow compared to what you wear. Items it cannot score get a reason instead, such as "Not ranked for your class", "Not ranked at your level. Ranked from X to Y", or "Not this roll". Code: `Data.lua:6617-6806`.
6. **"GearQuest Index Score" bar.** It is the average 0–100 index over your worn slots. An empty slot counts as 0. Code: `Data.lua:6139-6161`.
7. **Recommended enchant line** on gear tooltips. It uses a hand-written table of enchant formulas with skill levels. The file header says "Wowhead Forever is the source". Code: `Enchant.lua`.
8. **Play Styles**, which are preset filter bundles: No Dungeons!, Dungeon Enjoyer, Get it now!, Manageable Quests, Manageable Dungeons, Buy it, and Focus Zone. Focus Zone re-filters on `ZONE_CHANGED*`. There are also source filters and a weapon-type filter. Code: `Log.lua:7596-7688`, `14059-14061`.
9. **Simulator.** You can view the lists for another class, spec, faction or level. Code: `Preview.lua`, slash `/gq class|level|faction|spec|set`.
10. **Custom specs.** You can build your own stat-weight profile, saved account-wide. Code: `CustomSpec.lua`. The CF page FAQ says the built-in weights cannot be edited, but custom specs can.
11. **Obtain toast.** When a top-ranked piece lands in your bags, a toast pops up and the hunt moves to "Completed". It plays `SOUNDKIT.IG_QUEST_LIST_COMPLETE`. Code: `Toast.lua:24`; obtain detection is in `Log.lua:5770-5853` (BAG_UPDATE, PLAYER_EQUIPMENT_CHANGED, CHAT_MSG_LOOT and others).
12. **Level-up milestones in chat.** At level 10 it announces that specs are now available, and it posts a message when a ring slot unlocks. On login it only remembers milestones you have already passed and does not print them. Code: `Core.lua:475-582`.
13. **Voiced onboarding tour.** "The GearQuest Knight" walks you through 12 parchment pages, each with an MP3 and UI highlights. It plays automatically once per account and can be replayed from the portrait. Code: `PortraitGuide.lua:7-112`.
14. **Full gamepad support.** It handles Forever's new gamepad UI mode, including right-stick click on a slot. Code: `Gamepad.lua`, `PaperDoll.lua:116-182`.

### Slash commands (GEMETEN, `Commands.lua`, `Preview.lua:329-340`)
- `/gq` or `/gearquest`: toggle the log. `/gq log` does the same.
- `/gq track` and `/gq untrack`: track or untrack the selected hunt.
- `/gq help`.
- `/gq set`, `/gq set on|off|me`: simulator status and switches.
- `/gq class <x>`, `/gq level <n>`, `/gq faction <x>`, `/gq spec <x>` (alias `/gq lvl`), `/gq preview`, `/gq status`, `/gq debug`.
- `/gq wipe data`: reset this character's hunt progress.
- `/gq seen`: retired. Its message says "Forever item data comes from Wowhead".

### Settings (GEMETEN, `settings.*` keys grepped across all files)
- Chat and score: `hideChat`, `showGearScore`, `showGearScoreBar`, `showGearEnchant`.
- Arrows and toasts: `hideUpgradeArrows`, `hideGuideArrow`, `hideObtainToast`.
- Window: `hideLogArt`, `huntsPerSlot`, `windowScalePercent`, `largeWindow`.
- Minimap and tracker: `hideMinimapIcon`, `minimapAngle`, `trackerPos`, `trackerSize`, `trackerCollapsed`.
- Other: `weaponFilter`, and `preview` (the simulator class, level, faction and spec).
- Saved variables are `GearQuestForeverDB` (account) and `GearQuestForeverCharDB` (character). GEMETEN: TOC.

### How it scores items
- **Hunt order is computed offline.** Every row carries a precomputed `pipelineScore` from the author's offline pipeline, which uses `weights.json`, `score.py` and `procs.py`, plus an armour-class multiplier per spec. Random-suffix items are scored on their **best roll**. At level 60 the order comes from Wowhead's Classic BiS guides (`origin="guide"`), and a curated `curatedRank` always beats the raw score. GEMETEN: `Data.Paladin.generated.lua` header, `Compare.lua:594-638`.
- **Weights.** There are per-class, per-spec tables in two files. GEMETEN: `_generated/StatWeights.generated.lua` and `_generated/ScoringWeights.generated.lua`.
  - The first file's header says the source is "TBC stat priority / pipeline weights". `Compare.lua:60-64` links a Wowhead *TBC* stats guide.
  - So the weights are hand-set by the author and adapted from TBC priorities. They are not simulated and not measured in Forever. The "TBC" is GEMETEN in the comments; that the numbers are hand-set is AFGELEID.
  - The tables still carry TBC-only stats (haste, expertise, armorPen). `CustomSpec.lua` itself marks expertise, armorPen and resilience as `DEAD_STAT`. GEMETEN.
- **Specs.** It uses the 27 classic talent-tree specs plus its own hybrid specs: Shockadin, Enhancement Tank, three Battle Mage variants and Bear Tank. GEMETEN: `Spec.lua:21-73`.
  - It detects your spec from the talent tab with the most points, through `GetPrimaryTalentTree`, `GetTalentTabInfo` and `GetTalentInfo`. Every call is wrapped in `pcall`, and it tries several return-value positions. GEMETEN: `Spec.lua:442-537`.
  - AFGELEID: the author was not sure of the 16001 return shapes.
  - A spec you pick by hand overrides the talent guess.
- **Leveling multiplier.** Up to level 60, stamina, health and hp5 count 3×, and armor, int, spi, mp5 and mana count 2×. GEMETEN: `ScoringWeights.generated.lua:7-17`. The CF page explains the order as "damage first, survivability second, endurance third".
- **Runtime fallback.** An item without a pipeline score is scored by the client. It reads `GetItemStats` and `C_Item.GetItemStats`, and if those give nothing it scans the tooltip text. GEMETEN: `Compare.lua:396-541`.
- **The 0–100 tooltip number is relative.** It is a min-max rescale inside that slot's rank list for your current level band: the best piece in the list reads 100 and the worst reads 0. It is not an absolute power number. GEMETEN: `Data.lua:6023-6054`, `6163-6177`.
- **Armour rules are hard-coded.** Warrior and Paladin wear plate from level 40, and Hunter and Shaman wear mail from 40. Below that they wear mail and leather respectively. GEMETEN: `Equip.lua:256-260`, `335-359`. **I have not checked whether this is true in Forever 1.60.1.**

### Blizzard frames, hooks and events it uses (GEMETEN)
- **`hooksecurefunc` on:**
  - Loot: `LootFrame_Update`, `GroupLootFrame_OpenNewFrame`.
  - Quests: `QuestLog_UpdateQuestDetails`, `QuestLog_Update`, `QuestInfo_ShowRewards`, `QuestFrameItems_Update`, `QuestFrame_UpdatePortrait`.
  - Professions: `TradeSkillFrame_Update`, `TradeSkillFrame_SetSelection`, `CraftFrame_Update`, `CraftFrame_SetSelection`.
  - Merchant: `MerchantFrame_Update`, `MerchantFrame_UpdateMerchantInfo`.
  - Logout: `CancelLogout`.
  - Source: `Indicator.lua:1774-1817`, `Guide.lua:57`.
- **`HookScript` on:** `Character<Slot>Slot` (OnClick/OnEnter), `CharacterFrame` (OnShow/OnHide), `GameTooltip`/`ItemRefTooltip` (OnTooltipCleared), and `Minimap` (OnSizeChanged).
- **Tooltips.** It uses `TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, ...)` when that exists, and falls back to `OnTooltipSetItem`. GEMETEN: `Data.lua:6808-6859`.
- **Events:**
  - Login and level: PLAYER_LOGIN, ADDON_LOADED, VARIABLES_LOADED, PLAYER_LEVEL_UP, PLAYER_ENTERING_WORLD, PLAYER_LOGOUT, PLAYER_CAMPING.
  - Talents: PLAYER_TALENT_UPDATE, CHARACTER_POINTS_CHANGED.
  - Items and bags: GET_ITEM_INFO_RECEIVED, BAG_UPDATE, PLAYER_EQUIPMENT_CHANGED.
  - Loot and merchant: START_LOOT_ROLL, LOOT_OPENED/CLOSED, MERCHANT_SHOW/UPDATE/CLOSED.
  - Professions and reputation: TRADE_SKILL_*, CRAFT_SHOW/UPDATE, CHAT_MSG_SKILL, CHAT_MSG_LOOT, UPDATE_FACTION, SKILL_LINES_CHANGED.
  - Quests: QUEST_DETAIL/PROGRESS/COMPLETE/FINISHED, QUEST_LOG_UPDATE.
  - Zones: ZONE_CHANGED, ZONE_CHANGED_INDOORS, ZONE_CHANGED_NEW_AREA.
  - Almost all of them are registered through `pcall`. GEMETEN: `Core.lua:69-74`.

### Forever-client lessons in its comments
All of these are **the author's claims, GEMETEN as text in his code, not verified by us**:
- On 16001 the old item globals (`GetItemInfo`, `GetItemStats` and others) "can be nil". It shims them from `C_Item`. Source: `Core.lua:26-65`. This matches our own memory note that `GetItemInfo` is gone on Forever (`wow-forever-research.md`, 22 Sep 2026).
- Forever dropped some Classic events (TRADE_SKILL_UPDATE, CRAFT_*), and "Registering an unknown event throws". Source: `Core.lua:67-74`.
- Forever can mark tooltip text as a secret value. It guards this with `issecretvalue`/`canaccessvalue`. Source: `Core.lua:76-101`.
- `OnTooltipSetItem` taints the bag button, and selling with right-click at a vendor is then blocked. Its fix is `TooltipDataProcessor`. Source: `Data.lua:6823-6826`.
- Replacing `ReloadUI`/`C_UI.Reload` breaks the AddOn List's Reload button. Source: `Guide.lua:36-39`.
- Gamepad mode has two taint traps. Registering a world-map data provider, or touching `WorldMapFrame.pinPools`, taints the gamepad focus clear. Copying a pin to the clipboard from an addon is blocked. Source: `Pins.lua:120-122`, `Map.lua:109-120`.

### Risky practice, not to copy
- **It silences Blizzard's taint warnings for all addons.** In gamepad mode it unregisters `ADDON_ACTION_FORBIDDEN` and `ADDON_ACTION_BLOCKED` from `UIParent` (GEMETEN: `Core.lua:238-244`). That hides those warnings for every addon, not just its own. AFGELEID: it is a workaround for a real gamepad hang, but MH must never do this.
- **Small bug:** `self._rebuildCacheTimer = C_Timer.After(...)`. `C_Timer.After` returns nil, so the `:Cancel()` beside it never fires. GEMETEN: `Indicator.lua:1062-1065`, `1094`. Harmless.

### What players say (GEMETEN, CF comments API, 6–7 Nov 2026)
- Memory use is the most-mentioned complaint.
- Items from Classic that do not exist in Forever still show up. The author replied that the databases assume them and will improve.
- A Protection Paladin got cloth and leather suggestions and was missing blacksmithing crafts.
- Opposite-faction city dungeons appeared in the lists. The author has since excluded RFC, Stockade and others per faction.
- Players ask for hybrid talent builds.
- One player could not restart the tutorial.

## 4. Compared with MH

**What MH loads on Forever.** I read `MidnightHelper_Camelot.toc` on disk (GEMETEN). It loads the core, locales, the key block (KeyBlock, ForeverBlock_<class>, ForeverHowToPlay), the quick bar, NativeArrow, settings, search, the dashboard and the side panel. It loads **no gear module at all**.

**MH's retail gear tools, none of which are in the Camelot TOC** (GEMETEN, `ls Modules/` plus the TOC):
- `LootUpgrade.lua` writes one tooltip line, "Upgrade / Sidegrade / Lower · ilvl ±N · for your spec". It only calls clear-cut cases and stays silent when it cannot compare. It uses `TooltipDataProcessor`. GEMETEN: `LootUpgrade.lua:1-70`.
- `BagUpgrade.lua` puts a green arrow on bag items that are clear upgrades (`/mh bagarrows`). GEMETEN.
- Both depend on `ns.GetLootUpgradeInfo` in `VaultAdvisor.lua:860-886`. That function scores **only secondary stats** (crit, haste, mastery, vers). It keys them by **retail spec ID + hero talent + M+/raid profile**, using `ns.VAULT_ADVISOR_SPEC_WEIGHTS`, which is generated from Icy Veins/Wowhead stat-priority order (`VaultAdvisorData.lua:1-40`). GEMETEN.
- `GearLadder.lua` (`/mh gear`) is about Midnight upgrade tracks and crests (`C_Item.GetItemUpgradeInfo`). GEMETEN: `GearLadder.lua:1-22`. **It has no meaning on Forever** (AFGELEID: Forever has no crest upgrade tracks).
- Also retail-only: `GearEnchantCheck.lua`, `StatCoach.lua`, `PawnExport.lua`, `SimcExport.lua`, `TierSet.lua`, `GearExport.lua`.
- MH has **no quest-reward helper, even on retail.** Nothing calls `GetQuestItemLink`, `GetNumQuestChoices` or `QuestInfo_ShowRewards`. GEMETEN, with a positive control: the same grep found `QUEST_COMPLETE` in `ResetRoutine.lua:1946`.

**Why the retail scorer cannot simply be switched on for Forever** (AFGELEID from the code above):
- Forever items carry classic stats: Str/Agi/Sta/Int/Spi, AP, spell damage/healing, hit, crit, mp5, and random suffixes. MH's weight table has none of them.
- MH looks weights up by retail spec ID and hero talent. Forever has talent *trees*, and specs only exist from level 10 on (GQ code assumes this; not measured by me).
- VaultAdvisor also touches `C_WeeklyRewards`. Even if it loaded, `GetSpecWeights()` would return nil, and the tooltip would stay silent everywhere. That is correctly silent, but useless.

**Would something like GearQuest fit MH on Forever?**
- **A full BiS database like GQ's does NOT fit** (AFGELEID). There are four reasons:
  - The data cannot be had cleanly. GQ's comes from Wowhead scrapes, Questie (GPL), AtlasLoot and its own ARR pipeline.
  - Memory: 200–400 MB, per GQ's own page.
  - Upkeep: GQ ships an update almost daily. It made 9 releases between 20 Oct and 6 Nov (GEMETEN: files API).
  - The niche is crowded. Five Forever gear addons already exist, one with 1.2M downloads.
- **A small "explain it" layer DOES fit** (AFGELEID). It would use only client data and answer the beginner's two questions: "is this better for me?" and "which quest reward do I take?". This matches MH's stated strength, which is explaining (memory `mh-market-position`), and the client-only rule in MH's CLAUDE.md ("Ask the client instead").

**What it would take**, in order. Each step is a measurement or a choice for Rob, not code:
1. **Measure in the Forever client** before writing anything. Do these exist on 16001, and do they work?
   - `TooltipDataProcessor`.
   - `C_Item.GetItemStats(link)`: does it return `ITEM_MOD_*` keys for quest-reward and bag links? GQ's code reads it in two ways, which suggests even its author was unsure.
   - `GetNumQuestChoices` / `GetQuestItemLink("choice", i)`.
   - The names of the quest-reward buttons.
   - The talent-tab API.
   - Our own memory note from 22 Sep says item stats are "hidden until first drop" (fan-site source, not measured). That could leave unseen items unreadable. Measure it.
2. **Decide where the stat priorities come from.** MH may not take them from GQ. It needs its own short, sourced list per class and role: Blizzard's Forever class pages, DB2 1.60.1, plus an mh-research fact check. This is the same process ForeverHowToPlay.lua already went through (GEMETEN: its header).
3. **Build a new small Forever-only module** (e.g. `ForeverGearHint.lua`, loaded only from the Camelot TOC).
   - It needs its own small scorer. VaultAdvisor stays retail-only.
   - It needs an on/off switch, because players choose (memory `players-choose-not-us`).
   - It needs a `/mh <x> why` diagnosis, because MH's CLAUDE.md requires that for any module whose normal result is silence.

## 5. Ideas for MH: small, concrete, with honest value

All value estimates are AFGELEID. Rob chooses.

1. **Quest reward hint (highest value, smallest scope).**
   - **What:** On the quest-complete screen, mark the reward that has the most of *your* main stats, and say why in one line. For example: "More Agility, your main stat as a Rogue."
   - **If nothing fits your class:** say "none of these is gear for you; this one sells for the most".
   - **Value:** From 1 to 60 most gear comes from quest rewards, and this is the moment a new player hesitates. GQ already covers it with an arrow, but without the "why".
   - **Cost:** One file and a small priority table, all client data.
2. **"Better for me?" tooltip line on Forever.**
   - **What:** One plain-language line, for example "+4 Stamina, −2 Spirit compared to what you wear". Name the stats instead of showing a 0–100 index, because GQ's index is relative to its own list and hard to explain.
   - **Cost:** Reuse the honesty rules of `LootUpgrade.lua` (only clear-cut cases; silent and with a reason otherwise). Do not reuse its scorer.
   - **Coexistence:** Add a switch to hide MH's line when GearQuestForever or ForeverGear is loaded. Two verdicts on one tooltip confuse. This follows the TomTom stand-down idea in NativeArrow.
3. **"Can I wear this yet?" explainer.** Some beginners ask why they cannot equip an item. Possible answers are the armour type (mail or plate later), a weapon skill they have not trained yet, or the item's required level.
   - ⚠️ First measure the real Forever rule. GQ hard-codes "mail and plate at 40" from Classic (`Equip.lua:256-260`), which is not proven for Forever. Also measure whether weapon skills must be bought at a trainer.
   - If it is true, it also makes a good one-time level-40 chat note in MH's own words.
4. **Look at Forever-specific risks in MH's own Forever build, prompted by GQ's notes.**
   - MH already wraps registrations in pcall, for example `ResetRoutine.lua:1946`.
   - Worth one check each in Rob's client: MH's arrow and map pins in **gamepad mode**, and whether any MH tooltip hook on Forever uses `OnTooltipSetItem`, which would block vendor right-click selling according to GQ.
   - **Never** do GQ's trick of unregistering `ADDON_ACTION_BLOCKED` from UIParent.
5. **Ideas to borrow as ideas only, no code.** Each is written in MH's own way:
   - A "why is nothing shown" reason line, like GQ's "Not ranked at your level. Ranked from X to Y".
   - A replayable onboarding tour. MH already has `Tour.lua`, retail only.
   - A once-only level-milestone note: mark milestones you already passed on login and do not print them.

**What not to build:**
- A BiS database, a gear simulator, or voiced tours.
- Hunt-tracking with map pins to quest givers. That needs coordinate data MH has no clean source for on Forever.

---

**One measurement aside for the caller:** while comparing, the Glob tool returned **nothing** for `Modules/**/*Gear*` and `Modules/**/*Ladder*`, although `Modules\GearLadder.lua` exists. GEMETEN: `ls Modules/` and Grep both find it. An empty Glob on this repo path proves nothing; use `ls` or Grep as the control.
