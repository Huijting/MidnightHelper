# Review: Leatrix Maps for WoW Forever (1.60.28-forever), and what Midnight Helper can take from it

Researched 7 Nov 2026, about 06:55-07:10 Rob's time. Read only: nothing in MH was changed and nothing was installed in any game folder.
Every claim is tagged **GEMETEN** (seen in a named file or page, with date) or **AFGELEID** (my reasoning).

---

## 1. Source, version, license

| Item | Value | Tag |
|---|---|---|
| Official page | https://www.curseforge.com/wow/addons/leatrix-maps (project ID 298842) | GEMETEN, CF page via WebFetch, 7 Nov 2026 |
| Author | Leatrix (CF owner and uploader; TOC `## Author: Leatrix`) | GEMETEN, CF page + `Leatrix_Maps.toc` |
| Latest Forever build | **1.60.28-forever**, file ID 9467345, uploaded **6 Nov 2026**, CF game version 1.60.1, 23.5 MB | GEMETEN, CF files list + file page, 7 Nov 2026 |
| Changelog date for 1.60.28 | "5th November 2026" | GEMETEN, `Changelog.txt` line 1 |
| Downloads | project 42,779,212; this Forever file 389.6K | GEMETEN, CF page via WebFetch (a summarising fetcher, so treat the exact numbers as "read by a tool", not by eye) |
| **License (CF field)** | **"All Rights Reserved"** | GEMETEN, CF page, read twice in two separate fetches, 7 Nov 2026 |
| License file in the zip | **none**. The zip has 16 files and no LICENSE. A grep of all files for License/MIT/GPL/Copyright headers found only LibStub's "placed in the Public Domain" line (the positive control). | GEMETEN, `unzip -l` + Grep |
| Third-party data inside | `Leatrix_Maps.lua:1559`: "Maps and pins are from MapUtils by D4KiR, used with permission." MapUtils on CurseForge has the license **"GNU General Public License version 3 (GPLv3)"**, supports Forever, updated 7 Nov 2026. | GEMETEN, Lua comment + CF page `wow/addons/maputils` via WebFetch, 7 Nov 2026 |
| leatrix.com | redirects to a Google sign-in page (Google Sites), no usable download page | GEMETEN, WebFetch 302, 7 Nov 2026 |

**What this means for MH:** Leatrix Maps is All Rights Reserved, and part of its Forever data comes from a GPLv3 project. MH (MIT) may copy **nothing** from it: no code, no tables, no coordinates, no NPC or map IDs taken from its files, and no art. Ideas and techniques are fine; the facts behind them have to come from our own sources (the client, wago DB2, Rob). AFGELEID, following the MH rule in the task.

Download: `Leatrix_Maps-1.60.28-forever.zip` (24,678,875 bytes) from the CF API, which redirected to `mediafilez.forgecdn.net/files/9467/345/…`. Unpacked into
`C:\Users\RobHu\AppData\Local\Temp\claude\e1c44003d48d72c2\6b683006-f185-4f0a-b7b3-af9a8f2dc4a8\scratchpad\dl_leatrixmaps\x\Leatrix_Maps\`. I read it and ran none of it. GEMETEN.

---

## 2. What is in the package

GEMETEN, `unzip -l` + `wc -l`:

| File | Size / lines | What it is |
|---|---|---|
| `Leatrix_Maps.toc` | 22 lines | `## Interface: 16001`, `## LoadSavedVariablesFirst: true`, SavedVariables `LeaMapsDB`, `AddonCompartmentFunc`, `OptionalDeps: ElvUI`. It has **no** `AllowLoadGameType` line, because this is a separate Forever-only zip (CF flavor "Forever"). |
| `Leatrix_Maps.lua` | 6141 lines | everything |
| `Leatrix_Maps_Icons.lua` | 486 lines | the points-of-interest table |
| `Leatrix_Maps_Reveal.lua` | 154 lines | the unexplored-area overlay table |
| `Leatrix_Maps_Locale.lua` | 6666 lines | 10 translations plus English fallback |
| `Leatrix_Maps_Library.lua` | 1118 lines | embedded LibStub, CallbackHandler-1.0 (minor 8), LibDataBroker-1.1 (4), LibDBIcon-1.0 (minor 56) |
| `Leatrix_Maps.xml`, `Bindings.xml` | small | a pin template, a slider template, and one key binding "Toggle panel" (no default key) |
| 6 `.blp` files | **about 39 MB** | `Leatrix_Maps_Dungeon_01/02/03.blp` (11.19 MB each), `Leatrix_Maps_Dungeon_Art.blp` (5.59 MB), plus 2 small icon sheets |

What I read: the TOC, the changelog, both XMLs, and these line ranges of the main Lua: 1-70, 144-183, 318-437, 620-669, 1178-1217, 1520-1639, 2080-2214, 2612-3009, 3385-3519, 3640-3684, 3834-4640, 4945-5024, 5195-5217, 5278-5327, 5611-6035. I also grepped every section header and searched the whole file for hooks, CVars, taint, secret values and addon checks.
**Not read line by line:** the map-frame theme code (about 440-1177), the boss-pin data rows (1640-2079), pin drawing (2215-2611), the battlefield map (3108-3384), most of "Unlock map frame" (3564-3833), the battlefield reveal (4640-4847) and the widget builders (5025-5610). GEMETEN that I left them out; I make no claims about their details.

---

## 3. What it actually does on Forever (measured in the code)

### Features and their defaults (GEMETEN, `LoadVarChk` defaults at `Leatrix_Maps.lua:5853-5910`)

| Feature (option key) | Default | What the code does |
|---|---|---|
| Simple map frame (`SimpleMapFrame`) | On | Hides WorldMapFrame's border, portrait, title, NavBar and QuestLogCount. Draws its own title bar, border and themes: 12 themes, one of them "Blizzard". |
| Show zone menus (`ShowZoneMenu`) | On | Continent and zone drop-downs in the title bar. They switch the map with `C_Map.OpenWorldMap(mapID)` and are switched off in combat (`:1190-1192`). |
| Unlock map frame / Allow movement / Scale the map | Off / On / Off | Makes WorldMapFrame movable (`SetMovable`, `SetPoint`, `SetScale`, `SetHitRectInsets`), with separate scales for the windowed and maximised map (0.5-2). |
| Hide blackout frame | On | `WorldMapFrame.BlackoutFrame:SetAlpha(0)` and disables its mouse. |
| Disable map fade (`NoMapFade`) | On | **`SetCVar("mapFade","0")` at every login** (`:3838-3848`). |
| Hide filter reset button | On | Reparents or hides the filter counter. |
| Show unexplored areas (`RevealMap`) + tint | On, tint 0.6/0.6/1.0 | Post-hooks `RefreshOverlays` on the exploration pins and draws unexplored tiles from `Leatrix_Maps_Reveal.lua`. It also replaces the pins' `overlayTexturePool.resetterFunc`. |
| Show points of interest | On | Dungeons/raids (with level range), flight points, boats/zeppelins/trams, portals, spirit healers and zone-crossing arrows; the opposing faction's are Off. Clicking an arrow, portal or travel icon opens the destination map (not in combat). Clicking a dungeon icon opens its dungeon map (this also works in combat). |
| Show zone levels (+ fishing) | On, On | Replaces the map's area-label `OnUpdate`, so the area name under the cursor gets "(min-max)" in quest-difficulty colours and a "Fishing: N" line. Works with the gamepad cursor. Needs a reload. |
| Show coordinates (+ background) | On | **Uses Blizzard's own map coordinates**: `SetCVar("worldMapShowPlayerCoords","1")` and `SetCVar("worldMapShowCursorCoords","1")`, then moves and restyles the PlayerCoords/CursorCoords/CrosshairCoords frames (`:3424-3455`). |
| Hide town and city icons | On | Post-hooks `BaseMapPoiPinMixin.OnAcquired` and hides three icon types on world and continent maps by their texture coordinates. |
| **Show dungeon maps** (new in 1.60.27) | On | Draws its own floor plan with boss pins over the world map: inside the instance, when you click a dungeon icon, or from a "Dungeons" menu entry. Zoom, pan, floor menu; right-click hides it. Does **not** use the Encounter Journal (grep for EncounterJournal/EJ_ = 0; `GetMapArtLayers` matched as the control). |
| Enhance battlefield map | Off | Movable, opacity, centre on player, arrow and group icon sizes. |
| Minimap button | On | Embedded LibDBIcon, plus the Addon Compartment. |
| Language | Automatic | Drop-down with 11 languages. It works because the TOC has `LoadSavedVariablesFirst`, so `Leatrix_Maps_Locale.lua:16` can read `LeaMapsDB["AddonLanguage"]` while the file loads. |
| Always, with no option | | Loads `Blizzard_BattlefieldMap`, hides the world-map tutorial button and sets its `closedInfoFrames` bit (`:341-342`), and hides `BattlefieldMapTab` (`:5007`). |

⚠️ **The description and the code disagree.** The CF description says, quoted by WebFetch on 7 Nov 2026: *"Every setting is optional, and nothing changes until you choose it."* The Forever code switches most features **On** by default and sets the `mapFade` CVar at every login. Both halves are GEMETEN; the mismatch is AFGELEID. The description may have been written for another flavour.

### Slash commands (GEMETEN, `:5615-5835`)
`/ltm` and `/leamaps` open the panel. The subcommands are `reset`, `wipe`, `nosave`, `debug`, `setmap <id>`, `findmap <text>`, `dun [number|name|off]` (preview dungeon maps, arrow keys to page), `duncheck` (checks which game dungeon textures exist), `hadmin`, `map [id]`, `admin` and `help`. Only `admin`/`setmap`/`map <id>` call `WorldMapFrame:SetMapID` directly.

### Blizzard frames it touches (GEMETEN, Grep of `hooksecurefunc`/`HookScript`/`SetScript`)
- WorldMapFrame: `OnShow`; post-hooks on `OnMapChanged`, `OnFrameSizeChanged`, `SynchronizeDisplayState`, `OnCanvasScaleChanged`; `OnSizeChanged`; `OnDragStart`/`OnDragStop` (when unlocked).
- `WorldMapFrame.ScrollContainer` `OnMouseDown`/`OnMouseUp` (pin clicks), and `QuestMapFrame` `OnShow`/`OnHide`.
- Map data providers: the area label's `OnUpdate` is replaced. `BaseMapPoiPinMixin.OnAcquired`; exploration pins' `RefreshOverlays`.
- The coordinates overlay's child frames, BattlefieldMapFrame and BattlefieldMapTab.
- A canvas panel in Blizzard's Settings (`Settings.RegisterCanvasLayoutCategory`).
- It does **not** touch user waypoints, SuperTrack or TomTom: Grep for `UserWaypoint|SuperTrack|TomTom` = 0, with `SetCVar(` matching in the same run as the control. GEMETEN.

### How it avoids taint and secret-value errors (GEMETEN, its own code comments)
- It changes the map with `C_Map.OpenWorldMap`, "so the map is never tainted (calling WorldMapFrame:SetMapID from here would taint it)" (`:1190-1191`, `:4312-4315`).
- It uses its own pop-up lists instead of Blizzard's menus over the map, because "menu entries made by an addon spread taint into the map's own code" (`:149-151`).
- It uses private tooltips (`LeaMapsPOITooltip`, `LeaMapsDungeonTooltip`) "so we never write to the shared GameTooltip".
- Its pins are display-only: they take no mouse input, and hover is found by an OnUpdate hit test. It also handles the gamepad crosshair.
- It locks map move/scale controls while `WorldMapFrame:IsProtected()` in combat, because "another addon can make the map frame protected" (`:5284-5322`).
- It wraps sizes, positions and scales in `issecretvalue` checks, commented "Frame sizes can be secret in combat" (`:184, 573, 638, 1002, 2179-2183, 3588-3606`). That is the author's claim; I did not measure it.

### Data tables and where they come from
| Table | Contents | Source stated? | Tag |
|---|---|---|---|
| Zone levels (`:3857-3915`) | Level ranges and fishing minimums for 48 classic zones (uiMapIDs 1411-1458) and **4 Forever zones**: Mount Hyjal 2482 (60), Zephras Isle 2521 (1-12), Riverglades 2548 (35-45), Shen'dralas 2652 (35-45) | no | GEMETEN content; source unknown |
| Points of interest (`Leatrix_Maps_Icons.lua`) | 50 map tables, 330 pin rows: `{type, x, y, name, note, icon, minLvl, maxLvl, …, rotation, destination mapID}` | no | GEMETEN (Grep counts) |
| Forever dungeons in that table | City of Dalaran (Alterac Mtns, 28-33), The Hall of Thanes (Ironforge, 13-18), The Ruins of Lordaeron (Undercity, 15-20), Excavation Site: Wetlands (24-29), The Drowned City (Stranglethorn, 35-40). A comment lists four more that are not in yet: Blackmaw Hold (N. Azshara 55-60), Krol'dok Stronghold (Riverglades 40-45), Alcaz Prison (Dustwallow 48-53), The Shapers Terrace (Un'Goro 58-60) | no | GEMETEN. That 5 + 4 = 9 matches "9 dungeons" in MH's earlier Forever research note is AFGELEID. |
| Reveal (`Leatrix_Maps_Reveal.lua`) | per map-art ID: overlay tile key → texture fileDataIDs | no | GEMETEN format; probably extracted from client data, AFGELEID |
| Dungeon maps (`:1531-2152`) | 30 instances (26 classic + 4 Forever-new, instance IDs 2959/2998/2999/3065), boss pins with NPC ID, name, level, display ID, plus entrances and floor links | "Maps and pins are from MapUtils by D4KiR, used with permission" (placed above the 4 Forever-new rows) | GEMETEN; whether the credit also covers the classic rows is AFGELEID/unknown |
| Bundled art | `Dungeon_01-03.blp` = copies of the game's own dungeon map textures "for game locales that do not have them (such as esMX and ruRU)"; `Dungeon_Art.blp` = Scholomance plus the Forever-new maps | comment `:1566-1567`, `:1529-1530` | GEMETEN |

---

## 4. Compared with MH

### What MH loads on Forever (GEMETEN, `MidnightHelper_Camelot.toc`, 113 lines, v4.15.0)
The engine, locales, settings/search/home, the key tools (KeyBlock, ForeverBlock + 9 class tables, ForeverHowToPlay), QuickBar (only mh/reload/leave/setup, `QuickBar.lua:357-367`), NativeArrow, ToolsLaunchpad (hides cards whose function is missing, `:139-148`) and a few UI helpers.
**Not loaded:** InstanceMap, ZoneLevelGate, FlightMapHint, FlightPointsData, Travel/*, Rares and the rest of the Midnight modules. `ForeverTrainerData.lua` exists in `Modules/` but is **not** in the Camelot TOC.

### Does MH already do any of this?
| Leatrix feature | MH on Forever | MH on retail | Tag |
|---|---|---|---|
| Any world-map change | **none**: Grep `WorldMapFrame\|OpenWorldMap` = 0 in all MH Lua; `C_Map.GetBestMapForUnit` matched 34 files as the control | none either | GEMETEN |
| Coordinates | `/mh coord` / `/mh capture` prints mapID + player coords (`Core.lua:3219-3234`); `/mh goto x y [name]` sets a Blizzard user waypoint on your current map and claims the arrow (`Core.lua:2174-2211`) | same | GEMETEN |
| Zone levels | none | `ZoneLevelGate.lua` warns about too-high zones using the **client's own `C_Map.GetMapLevels`** (`:141-150`, `:375-376`) | GEMETEN |
| Dungeon floor plans | none; `/mh map` (`Core.lua:3822-3826`) calls `ns.ShowCurrentInstanceMap` only if it exists, and InstanceMap.lua is not loaded, so **on Forever `/mh map` silently does nothing** | `InstanceMap.lua`: client map art + Encounter Journal boss positions, no shipped images (header `:1-16`) | GEMETEN code; that it is silent is AFGELEID from that code |
| Forever zone/dungeon names | none: Grep for Riverglades/Zephras/Shen'dralas/Hall of Thanes/Ruins of Lordaeron/City of Dalaran/Excavation Site = 0. The same grep with "Coiled Isle" added gave 251 hits. | — | GEMETEN |
| Minimap button | LibDBIcon-1.0 minor 56, LDB minor 4, CBH minor 8: the **same minors** Leatrix embeds | | GEMETEN versions |
| Reference to Leatrix | none: Grep `Leatrix\|LeaMaps\|LeaPlus` = 0; with `TomTom` added, 668 hits in 46 files | | GEMETEN |

### Would Leatrix Maps conflict with MH?
- **No shared frames and no shared hooks.** MH never touches the world map; Leatrix never touches user waypoints, SuperTrack or TomTom (both GEMETEN, see the greps above). The slash commands (`/ltm` vs `/mh`), SavedVariables (`LeaMapsDB` vs `MidnightHelperDB`) and binding names do not overlap (GEMETEN). **No direct conflict** (AFGELEID from those facts).
- **Libraries:** both carry LibDBIcon 56 / LDB 4 / CBH 8, so LibStub keeps whichever loads first, and the versions are identical. No version fight (AFGELEID).
- **Keys:** MH's Forever key tables never use M (Grep `["(SHIFT|CTRL|ALT)-M"]` = 0, the same pattern with `V` matched 18 rows), and MH binds no TOGGLEWORLDMAP (GEMETEN). The Leatrix binding has no default key (GEMETEN, `Bindings.xml`). No clash.
- **One visual overlap (AFGELEID):** while a Leatrix dungeon map is showing, its overlay sits above Blizzard's topmost pin level (`:2732-2737`), so the Blizzard user-waypoint pin that MH sets would be hidden under it. MH's on-screen arrow is not on the map and is unaffected.
- **One click quirk (AFGELEID):** the Leatrix pin-click handler (`:4330-4364`) does not check modifier keys, so a ctrl-click right on a Leatrix arrow or portal icon could also switch the map. That is Blizzard's waypoint gesture, not MH code.
- **Rob's Forever folder does not have Leatrix Maps** (GEMETEN, listing of `E:\World of Warcraft\_forever_\Interface\AddOns\`, 7 Nov ~07:04). He does have BlizzMove (also moves map frames), HandyNotes_DungeonRaidLocations-Forever (dungeon icons, which would double up with Leatrix's), Zygor Forever and WaypointUI_Camelot. Those overlaps are between other addons, not MH (AFGELEID).
- 📌 Side observation (GEMETEN, timestamps): while I worked, `OpenMap` (07:01:42) and `GearQuestForever` + 9 class folders (07:04:00) appeared in that `_forever_\AddOns` folder. That was **not me**; it may have been Rob or another session.

---

## 5. Ideas for MH: small, honest, with value for a Forever player

1. **Make `/mh lang` work on any client with `## LoadSavedVariablesFirst` (cross-game, high value).**
   This is the most useful thing to learn from this package. MH's de/fr/es/pt/it packs stop at the top on a client of another language (`deDE.lua:19`, GEMETEN), because the language choice used to arrive after the locale files. Leatrix's Forever TOC loads SavedVariables first and its locale file reads the choice while it loads (GEMETEN). warcraft.wiki.gg says the directive came in 11.1.5 (GEMETEN, search result 7 Nov 2026). On Rob's Forever, BugSack, !BugGrabber and Spoken_Places use it too, but those are candidates, not proof.
   **Measure first (AFGELEID until then):** add it to one TOC, then `/mh lang de` + `/reload` on Rob's English client. Also check file-scope code that reads `MidnightHelperDB` early: `Core.lua:391-392` is guarded, and NativeArrow/ResetRoutine use `or {}`.
   It also gives Rob a way to see translations himself (memory `locale-packs-gated-by-client`).
2. **Make `/mh map` say something on Forever (tiny fix).** Today it is a silent no-op there (AFGELEID from `Core.lua:3822-3826` + the TOC). One line such as "dungeon maps are not in MH for Forever yet" follows MH's own rule "build a way to see that it stayed silent".
3. **Zone levels from the client, without shipping data (small, measure first).** MH already trusts `C_Map.GetMapLevels` on retail (GEMETEN). On Forever, test e.g. `/run print(C_Map.GetMapLevels(1429))` and `(2548)`.
   - If it answers, MH can say "this zone is for levels X-Y" when `/mh goto` sets a route, or on the Forever home card, with no table and no license risk.
   - If it does not answer, **do not copy** Leatrix's table; source from wago DB2 for 1.60.1 and have Rob check.
   - Why Leatrix hard-codes the table is unknown. It may be legacy from its Classic version (AFGELEID).
4. **A "Forever dungeons, explained" card (medium, optional).** Forever has no Dungeon Journal (MH memory `wow-forever-research`, AFGELEID from earlier research). Leatrix, MapUtils and HandyNotes already show *where* the dungeons are; nobody explains them.
   - MH's strength is explaining: what a dungeon is, the level band, what to bring, and a "route me to the entrance" button on the existing arrow.
   - All data must be MH's own (DB2 + Rob in game). Leatrix's list of 9 Forever dungeons is a **lead list only**.
5. **A coordinates switch, the player's choice (small, measure first).** Forever's world map has built-in player and cursor coordinates behind the CVars `worldMapShowPlayerCoords` / `worldMapShowCursorCoords`. Leatrix turns them on (GEMETEN); whether Blizzard also offers its own toggle is unknown.
   - An MH on/off switch, or one line in How to play, would pair naturally with `/mh goto x y`.
   - Check first that the CVars exist on Forever (`/run print(C_CVar.GetCVar("worldMapShowCursorCoords"))`).
6. **Do not build a map addon (a rule worth keeping).** Reveal, POI icons, floor plans and map skins are covered by Leatrix (ARR), MapUtils (GPLv3), HandyNotes plugins, Zygor and now OpenMap. The world map is a taint hotspot: Leatrix's own changelog has a taint fix (1.60.08), "protections against specific addons breaking the map" (1.60.26) and combat locks throughout (GEMETEN).
   If MH ever has to touch the map: use `C_Map.OpenWorldMap(mapID)`, not `WorldMapFrame:SetMapID`; no Blizzard menus over the map; MH's own tooltip (technique from Leatrix's comments; that it holds for MH is AFGELEID).
7. **Optional check: secret frame geometry in combat (low).** Leatrix guards `GetLeft/GetWidth/GetScale` with "can be secret in combat" (GEMETEN comment, not measured). MH's QuickBar saves `self:GetPoint()` on drag stop with no guard (`QuickBar.lua:419-426`, GEMETEN). For MH's own plain frame this is probably fine (AFGELEID). One drag of the bar in combat on Forever, then `/reload` + BugSack, would settle it.

Not recommended: copying the Leatrix approach of shipping ~39 MB of dungeon art. Rob's own constraint for InstanceMap was "zonder dat we vele mb's groter worden" (GEMETEN, `InstanceMap.lua:4-5`), and the Leatrix art is Blizzard textures plus GPLv3 MapUtils art.
