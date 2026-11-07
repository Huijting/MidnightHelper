# OpenMap (WoW Forever) review for Midnight Helper

Written 7 Nov 2026. Research only: nothing in MH was changed and nothing was installed in a game folder.

**Labels.** GEMETEN = I saw it in a named file or page during this run. AFGELEID = I reasoned it out and did not
test it in the game. No claim here was tested in the game.

**Sources read in this run**
- OpenMap source: a sparse `git clone --depth 1` of `github.com/openmap-world/openmap` into
  `...\scratchpad\dl_openmap\`. HEAD is commit `8232fcc` (6 Nov 2026 20:29 -0800, jigrobbulus, "Merge pull request
  #15 ... fix/dungeon-map-inside"). The map art (`.blp`/`.tga`/`.png`/`.jpg`, about 340 MB) was left out on purpose.
  Every `.lua`, `.toc`, `.xml`, `.md`, `.py` and `.json` file was checked out. I read the files; I ran none of them.
- GitHub API (7 Nov 2026): repo metadata and releases for OpenMap; the license and toc list for Questie; the license
  for cMaNGOS classic-db.
- MH, read only: `MidnightHelper_Camelot.toc`, `Core.lua` (lines 800-870), `Modules/NativeArrow.lua`, plus greps in
  `ForeverHowToPlay.lua`, `ToolsLaunchpad.lua`, `FpsPanel.lua`, `ZoneLevelGate.lua` and `NavSearch.lua`. I read nothing
  under `docs/`.
- Rob's Forever AddOns folder `E:\World of Warcraft\_forever_\Interface\AddOns\`: I listed it. I also read parts of
  `HandyNotes_ClassTrainers` and `ZygorGuidesViewerForever\WhoWhere.lua`, because they bear on the trainer question.

---

## 0. Short answer to the trainer question

**OpenMap cannot give MH class trainer positions.**
- It ships **no** NPC or trainer data. GEMETEN: a grep for trainer/npc/innkeeper/6491 in `OpenMap/Data/` found only
  one false hit, a texture file ID in `Reveal.lua`. The same grep found 7 hits in `Map/Townsfolk.lua`, which proves
  the pattern works.
- At runtime it reads **Questie's** NPC database. GEMETEN: `Map/Townsfolk.lua` calls
  `QuestieLoader:ImportModule("QuestieDB")` and `ImportModule("ZoneDB")`.
- Its API has **no getter** for townsfolk. It only takes them in, through `RegisterTownsfolkProvider`. GEMETEN:
  `OpenMap/API.lua`.
- Neither Questie nor OpenMap is installed on Rob's Forever client. GEMETEN: the folder listing.
- Rob's Forever client **does** have `HandyNotes_ClassTrainers` installed. Its data header says the positions come from
  "Wowhead's Forever database, and Questie's Classic positions converted". It ships no license file. GEMETEN. So MH
  must not copy that data either.
- Zygor Forever already has a "Class Trainers" finder that it keeps on Forever. GEMETEN: `WhoWhere.lua`, lines 109 and
  139-144.

The clean route is MH's own trainer table, measured in the game, plus an optional runtime read of Questie when a player
has it (see section 4).

---

## 1. Source and license

| Claim | Status |
|---|---|
| The root `LICENSE` is the MIT text ("Copyright (c) 2026 OpenMap contributors"). After it comes one extra paragraph: MIT covers "code, data tables and tools" but **not** the textures cut from Blizzard art or the hand-edited art in `art/edits/` (Blizzard's). Bundled libraries keep their own licences. | GEMETEN `LICENSE` |
| GitHub shows the license as `NOASSERTION`. The likely cause is that extra paragraph, so the file no longer matches the plain MIT template. | GEMETEN (API); the cause is AFGELEID |
| `OpenMap/LICENSE.txt` is plain MIT. `OpenMap/LICENSES/README.txt` lists Ace3 (CallbackHandler, AceGUI, AceConfig) and LibStub (public domain). The toc says `## X-License: MIT (code); map art is Blizzard's`. | GEMETEN |
| Repo size is about 242 MB (GitHub `size` 248180 KB). Releases: `v0.7.5-beta`, `v0.7.4-beta` and `v0.7.3-beta`, each an 86 MB zip, all republished on GitHub on 1 Nov 2026. | GEMETEN (API) |
| CHANGELOG dates v0.7.5-beta to 2026-10-23. HEAD has "Unreleased" changes on top: its own icon, "back on GitHub", flight masters named in the client's language, and a map that opens inside a dungeon. | GEMETEN `CHANGELOG.md` |
| The toc is `## Interface: 16001` with `X-Curse-Project-ID: 1735937`, `SavedVariables: OpenMapDB`, `SavedVariablesPerCharacter: OpenMapCharDB`, and `OptionalDeps: Questie, Leatrix_Maps, BetterMaps, HighFidelityWorldMap, HiddenMaps, Mapster, Magnify`. | GEMETEN `OpenMap/OpenMap.toc` |
| The README says the author uses Claude as a coding partner, and that "It doesn't make any of the art or content". | GEMETEN `README.md` |

---

## 2. What OpenMap actually does (measured in the code)

### 2.1 Features (module by module)

All of these are GEMETEN in `ARCHITECTURE.md` and the named file. Whether each one works in the game is not tested.

- **Stitched map** (`Map/Stitch.lua`, `Map/WorldMap.lua`): every zone map is drawn onto one Azeroth canvas, placed by
  `C_Map.GetMapRectOnMap(map, 947)`. It has zoom levels from the whole world down to street level. It lives **inside**
  Blizzard's `WorldMapFrame`, which it does not replace. Once the view sits still, OpenMap calls `SetMapID` to switch
  the map underneath to the zone under the view's centre. It never switches maps in combat.
- **Closest zoom** (`Map/Close.lua`): the game's minimap tiles blended in, cave and pre-instance maps, softening and
  grain.
- **Dungeon and raid entrances** (`Map/Dungeons.lua`, `Data/Places.lua`): level ranges coloured for your level. A click
  opens Blizzard's dungeon map, or a player-drawn one for Forever's own dungeons (`Data/DungeonDrawn.lua`). A card
  shows the bosses (the game's `DungeonEncounter` list) and quests from Questie, Dungeon Journal or NeedRoll.
- **Boats, zeppelins and airships** (`Map/Routes.lua`, `Data/Places.lua` `transports`/`sailings`): a click jumps to the
  other end.
- **Flight paths** (`Map/Flights.lua`, `Data/FlightData.lua`): learned ones are recorded per character. Click two
  nodes to see the route and an estimated time; measured flight times override the estimate.
- **Navigation** (`Map/Nav.lua`): Find me (also on middle-click), how the map reopens, a waypoint you follow, search
  (zones, dungeons, flight masters), and party/raid dots across the whole stitched map.
- **Map pins** (`Map/Pins.lua`): Ctrl-click for any number of pins, each with a note and a colour, kept per account.
  You can follow a pin (Blizzard's user waypoint plus TomTom), share it by addon message (prefix `OpenMap`) or as an
  `OMPINS1:` code, or Shift-click it to put a chat link in chat.
- **Drawing** (`Map/Sketch.lua`, `/openmap draw`) and **map notes** (`Map/Paint.lua`).
- **Townsfolk and rares** (`Map/Townsfolk.lua`): vendors, repair, innkeepers, bankers, mailboxes, auctioneers, stable
  masters, class trainers (your class only), profession trainers, spirit healers (NPC 6491) and rares. All of them come
  from Questie's DB or a registered provider (section 4).
- **Window** (`Map/Window.lua`): move and resize the map, plus full screen. **Chart** (`Map/Chart.lua`): a painted sea
  chart around the map.
- **Gamepad** (`Map/Gamepad.lua`), **combat taint workarounds** (`Map/Combat.lua`), **compat with other map addons**
  (`Map/Compat.lua`), **What's new** (`Map/News.lua`), **Report a problem** codes (`OM1|...`) for GitHub issues
  (`Map/Report.lua`), and a debug overlay and benchmark (`Map/Debug.lua`, `Map/Bench.lua`).
- **Locales**: ten packs, loaded with `[AllowLoadTextLocale xxXX]` on each toc line so only the client's language is
  read. GEMETEN `OpenMap.toc` lines 33-44. The CHANGELOG for 0.7.4 says this made loading faster: "the other nine
  were a quarter of OpenMap's code". GEMETEN `CHANGELOG.md`.

### 2.2 Slash commands and key bindings

GEMETEN `OpenMap/Init.lua` lines 5-14 and 43-62:
- `/openmap` or `/omap` opens the menu (or the options window when the map is off).
- Subcommands: `status`, `notes` (alias `paint`), `debug`, `bench [zoom]`, `pins`, `news`, `draw`, `dungeons`,
  `entrance <name>` and `welcome`.
- `entrance <name>` prints the player's current position as a data line for `tools/map-data/build.py`, and saves it.
  It is an in-game recorder for data.

GEMETEN `OpenMap/Bindings.xml`: six bindings (`OPENMAP_FIND`, `_PIN`, `_PINS`, `_QUILL`, `_QUESTLOG`, `_MENU`) in their
own "OpenMap" category, all with **no default key**.

### 2.3 Public API (`OpenMapAPI`, major 1, version 4)

GEMETEN in `OpenMap/API.lua` line 22, which matches `docs/api.md`.
- **Positions:** `IsStitched()`, `WorldFromMap(uiMapID,x,y)`, `MapFromWorld(uiMapID,u,v)`,
  `CanvasFromWorldPos(continent,x,y)` (v2), `ArtTopLevel()` (v2), `MapAt(u,v)`, `CursorPosition()` (v3), `GetView()`,
  `ShowWorld(u,v[,zoom])`.
- **Callbacks** (CallbackHandler-1.0): `OpenMap_StitchedChanged`, `OpenMap_ViewChanged` (at most every 0.15 s),
  `OpenMap_DungeonMapShown(info)` and `OpenMap_DungeonMapHidden`. `info` holds `{mapID, instances = {{name, minLevel,
  maxLevel, raid, bosses}}}`.
- **"Add your own":**
  - `RegisterMenuToggle(owner, {id,label,get,set,icon,tab,section})`
  - `RegisterDungeonSection(owner, fn(info) -> title, lines)` (40 lines at most)
  - `RegisterTownsfolkProvider(owner, {db = {NPCPointers, npcFlags, QueryNPCSingle[, QueryObjectSingle]}, zones =
    {GetUiMapIdByAreaId}[, mailboxes]})` (v4)
- By design it is read-only, plus "add your own". **There is no function that returns townsfolk, trainers, flight
  nodes or dungeon entrances.** GEMETEN: every function in `API.lua` is listed above.

### 2.4 What it hooks or replaces in Blizzard's UI

All GEMETEN in `Map/WorldMap.lua` lines 921-1099 unless another file is named.

**`WorldMapFrame.ScrollContainer`**
- Hooked with `hooksecurefunc`: `CreateZoomLevels`.
- Replaced: `ResetZoom` (only while stitched), `CalculateScrollExtentsAtScale`, `IsGamepadZooming` and
  `InstantPanAndZoom`.
- `InstantPanAndZoom` now **ignores calls from other addons while stitched**. It finds the caller through `debugstack`
  and drops the call unless it comes from OpenMap or `Blizzard_*`.
- HookScript on `OnMouseWheel`, `OnMouseDown`, `OnMouseUp` and `OnUpdate`.

**`WorldMapFrame`**
- Hooked: `RefreshDetailLayers` and `GamepadTryPlaceWaypoint`.
- Replaced: `NavigateToGamepadCursor` and `NavigateToParentMap`.
- Added: a canvas click handler, a global pin mouse-action handler, a cursor handler and its own data provider.
- Two pin frame levels inserted: `PIN_FRAME_LEVEL_OPENMAP_STITCH` and `PIN_FRAME_LEVEL_OPENMAP_ICONS`.
- More `hooksecurefunc` and `HookScript` calls in `Window.lua`, `Panel.lua`, `Dungeons.lua`, `Quests.lua` and
  `Extras.lua`.

**Global functions hooked:** `QuestMapFrame_ReturnFromQuestDetails`, plus `ShowUIPanel` and `UpdateUIPanelPositions`
(`Window.lua` lines 261-262).

**Other changes**
- `Map/Extras.lua` line 327 swaps the **area label's OnUpdate** script to add zone levels.
- It takes over pin placement for every loaded copy of **HereBeDragons-Pins**, per `ARCHITECTURE.md` and the
  `Extras.lua` header.
- `Map/Combat.lua` points `MapCanvasPinMixin:CheckMouseButtonPassthrough` and
  `SuperTrackablePinMixin:UpdateMousePropagation` at its own versions, which wait until combat ends.
- `Map/Nav.lua` lines 179-182 and 449-452: on the stitched map it **hides Blizzard's own waypoint pin**
  (`WaypointLocationPinTemplate`) and draws its own marker for the user waypoint instead.

**CVars it holds while it runs and restores at logout** (`Map/Extras.lua`):
- `worldMapShowPlayerCoords` and `worldMapShowCursorCoords`
- `mapFade` (held at "0")
- `maxFPS`, but only while the map is open and only when the player sets the map FPS cap (off by default)

### 2.5 Every data table and where it comes from

| File | What | Source | Status |
|---|---|---|---|
| `Data/Places.lua` | Dungeon/raid entrances in world yards per continent, with min/max level per instance, boss lists and boat/zeppelin/airship docks and sailing paths | Generated by `tools/map-data/build.py` from DB2 tables `Map`, `LFGDungeons`, `ContentTuning`, `DungeonEncounter`, `TaxiNodes`, `TaxiPath`, `TaxiPathNode`, build **1.60.1.70245**, fetched as CSV from wago.tools | GEMETEN (file header, build.py lines 3-20 and 56-171) |
| ...level ranges in `Places.lua` | Classic dungeons: `LFGDungeons -> ContentTuning.MinLevelSquish` gives the **start** level. The max is OpenMap's own **+5 convention** (`SPAN = 5`, capped at 60). Forever's own nine dungeons use "the WoW Forever team's dungeon list, October 2026". | Game data plus an OpenMap convention | GEMETEN `build.py` lines 49-76. ⚠️ The max level is **not** a Blizzard number for classic dungeons. |
| ...five entrances (Dalaran, Drowned City, Excavation Site, Hall of Thanes, Ruins of Lordaeron) | Hand-placed zone coordinates "where players find them", "checked against Leatrix Maps' icons" | Hand-made, checked against another addon | GEMETEN `build.py` lines 77-90 |
| `Data/FlightData.lua` | `nodes[id] = {name, continent, worldX, worldY, factions}` and `paths = {from, to, length yd, cost copper, points}` | `tools/map-flights/flights.py`, Forever DB2 build 1.60.1.70245 | GEMETEN (header) |
| `Data/Levels.lua` | Zone level ranges for 42 classic zones, plus Riverglades (2548) 35-45 and Zephras Isle (2521) 1-12 | **Warcraft Wiki** "Zones by level (original)" and the zones' own wiki pages, entered by hand | GEMETEN (header). The wiki's own license was **not** checked in this run. |
| `Data/Fishing.lua` | Base fishing level per zone | **cMaNGOS classic-db** `skill_fishing_base_level`, entered by hand. That repo's license is **GPL-3.0**. | GEMETEN (header, and GitHub API on 7 Nov 2026 for the license) |
| `Data/Reveal.lua`, `Minimap.lua`, `MinimapLOD.lua`, `Caves.lua`, `CaveMinimap.lua`, `DungeonMaps.lua`, `Gaps.lua`, `GapPlaces.lua`, `Grade.lua`, `Tones.lua`, `ZoneArt.lua`, `ArtEdits.lua` | Map art plumbing: overlay pieces, minimap tile file IDs, cave maps, dungeon floors (taken from Mists Classic's map tables), colour grading | Game tables and texture file IDs via `tools/` | GEMETEN (`ARCHITECTURE.md` "Data sources") |
| `Data/Labels.lua`, `Banners.lua` | Ocean and continent label positions and city banners | Measured or traced on the art | GEMETEN (`ARCHITECTURE.md`) |
| `Data/DungeonDrawn.lua` | Player-drawn maps of Forever's new dungeons ("Map by ...") | Players who gave permission | GEMETEN (`ARCHITECTURE.md`) |
| `Data/Chart.lua` + `art/drawn/chart` | The sea chart by Santiago Reyes, "used with his permission" | Third-party art | GEMETEN (`ARCHITECTURE.md`, `CHANGELOG.md`) |
| Townsfolk, spirit healers, mailboxes, rares | **Not shipped.** Read at runtime from Questie's `QuestieDB`, `ZoneDB` and `Townsfolk` modules, or from a registered provider | Questie at runtime | GEMETEN `Map/Townsfolk.lua`. `ARCHITECTURE.md` also notes "no graveyard table in this build". |

**Questie's real license** (GEMETEN: `LICENSE.md` via the GitHub API, 7 Nov 2026). It is **not** simply GPLv3. It says
that "when in doubt consider Questie as 'all rights reserved'". The team accepts forks and copies under GPLv3 terms,
but says it "can not promise all contributors are" fine with that. Only ten named contributors have agreed to GPLv3.
For MH this means: never copy anything out of Questie. Questie ships `Questie_Forever.toc` and `Questie_Camelot.toc`
(GEMETEN, GitHub API).

---

## 3. Comparison with MH

### 3.1 What MH loads on Forever

GEMETEN `MidnightHelper_Camelot.toc` (Interface 16001, `AllowLoadGameType: camelot`, version 4.15.0): the core,
locales, the keybind and key-block files, the 9 `ForeverBlock_<Class>.lua` files, `ForeverHowToPlay.lua`,
`QuickBar.lua`, `NativeArrow.lua`, `NavSearch.lua`, `ToolsLaunchpad.lua` and the settings files.

Not loaded on Forever: Travel, Rares, Delves, `ZoneLevelGate.lua` and the other Midnight modules (GEMETEN: absent
from the toc).

On Rob's machine, `_forever_\Interface\AddOns\MidnightHelper` is a **symlink** to the retail folder (GEMETEN,
`ls -la`).

No MH Lua file contains `WorldMapFrame`, `InstantPanAndZoom`, `QuestieLoader` or `OpenMap`. GEMETEN: the grep over all
MH `*.lua` came back empty, and in the same session the broader pattern found `HereBeDragons` in `Core.lua` and
`Modules/Travel/TravelRoute.lua`. **So MH never touches the world map, and OpenMap's many map hooks cannot break an MH
code path.** AFGELEID. The only place the two addons meet is the **single Blizzard user waypoint**, plus super-tracking
and TomTom.

### 3.2 NativeArrow and OpenMap: where it helps and where it clashes

How MH places the waypoint (GEMETEN):
- `ns.SetBlizzardUserWaypoint` (`Core.lua` lines 843-870) resolves the map to one that can hold a waypoint
  (`MHResolveWaypointMap`), calls `C_Map.SetUserWaypoint`, then `C_SuperTrack.SetSuperTrackedUserWaypoint(true)`.
- `Tick()` in `NativeArrow.lua` runs every 1 s (line 1105). It pins again only when the lead's key changed or when
  **no** user waypoint exists (lines 1092-1101).
- MH's own on-screen arrow points at its cached `activeLead`, never at the user waypoint (`UpdateArrow`, lines
  324-329).
- MH does not listen to `USER_WAYPOINT_UPDATED`. GEMETEN: there is no such string in MH, and the same grep found
  `function ns.SetBlizzardUserWaypoint`.

What OpenMap does with the waypoint (GEMETEN `Map/Nav.lua`, `Map/Pins.lua`, `Map/WorldMap.lua`):
- On `USER_WAYPOINT_UPDATED` and `SUPER_TRACKING_CHANGED` it redraws **any** user waypoint, MH's included, as its own
  marker on the stitched map. The marker has a tooltip ("Waypoint", zone, coordinates, "Click to stop following it").
  It hides Blizzard's own pin while stitched.
- `TrackPoint` (Ctrl-click, "Drop a pin", "Follow" on a pin card) calls `C_Map.SetUserWaypoint` and
  `C_SuperTrack.SetSuperTrackedUserWaypoint(true)`. If TomTom is loaded it **also** calls
  `TomTom:AddWaypoint(... from = "OpenMap")`.
- Clicking its waypoint marker calls `C_Map.ClearUserWaypoint()`.
- Shift-clicking a pin to make a chat link sets the user waypoint to that pin for a moment, then puts the old waypoint
  back with `SetUserWaypoint(before)`, or clears it if there was none (`Pins.lua` lines 140-147).
- With a gamepad, the left-stick waypoint is set at the cursor's zone (`WorldMap.lua` lines 1008-1018).
- Clicking a quest on the map calls `C_SuperTrack.SetSuperTrackedQuestID` (`Map/Quests.lua` lines 65-69).

What that means for MH (each consequence is AFGELEID from the code above; none was tested in the game):

1. **Helps.** MH's destination shows on OpenMap's map at every zoom, from neighbouring zones and zoomed out. On
   Blizzard's own map the pin only shows on its own zone map.
2. **Clash: a player's pin replaces MH's waypoint and MH does not take it back.** After a Ctrl-click, `HasNativeWaypoint()`
   is still true and MH's key has not changed, so `Tick` does nothing. MH's own arrow keeps pointing at MH's stop,
   while Blizzard's super-track (and TomTom, if loaded) points at the OpenMap pin. That is two arrows with two
   targets. **I think not taking it back is right:** the player chose that pin, and Rob's rule is that players choose,
   not us.
3. **Clash, and the one real bug: MH clears waypoints it does not own.** When a route ends (`NativeArrow.lua` lines
   916-920), or a delve/waypoint route arrives (lines 1085-1087), MH calls `C_Map.ClearUserWaypoint()` if `mhOwnedKey`
   is set and **any** waypoint exists. It never checks that the waypoint is still MH's. With OpenMap that wipes the
   waypoint of the pin the player is following. OpenMap's pin stays in its list but is no longer followed. The same
   happens on retail with Blizzard's own map pins, so this is a general MH issue that OpenMap makes common.
4. **Minor: "Click to stop following it" does not stick for MH's route.** OpenMap clears the waypoint, and within about
   a second MH's `Tick` sees `waypointGone and not atLead` and sets it again. The player has to stop the route inside
   MH.
5. **Shift-click to chat** fires `USER_WAYPOINT_UPDATED` twice and restores the waypoint. MH does not listen to that
   event, so nothing happens on MH's side. Whether the restore keeps super-tracking is not known.
6. **With TomTom** (not installed on Rob's Forever, GEMETEN listing): every OpenMap pin you follow adds a TomTom
   waypoint. MH stands down while TomTom's crazy arrow is shown (lines 186-260 and 986-988), so an OpenMap pin can
   pause MH's arrow **and its advancing**. How this interacts with MH's TomTom callbacks and its "set closest"
   suppression is unknown.
7. **A quest click** moves super-tracking to the quest. MH does not set it back, because the key did not change and a
   waypoint still exists. Blizzard's own quest tracker behaves the same way, so this is not specific to OpenMap.

A Forever lesson that touches the arrow:
- OpenMap's `Core.lua` lines 34-63 say Forever has secret values, "sometimes positions". It also says "some APIs on
  this client hand back a plain { x, y } table" instead of a vector, so OpenMap reads every position through
  `Safe.XY`/`Safe.IsSecret`. GEMETEN, but OpenMap does not name which API.
- MH's `PlayerWorld()` calls `pos:GetXY()` directly (`NativeArrow.lua` line 169), and `NativeArrow.lua` has **0**
  `issecretvalue` calls. GEMETEN; the same pattern found 3 hits in MH's `Core.lua`.
- Whether Forever ever returns a secret or plain-table player position outside instances is **not measured**. MH
  already hides the arrow inside instances (line 1003).

### 3.3 The other modules named in the brief

- **KeyBlock / QuickBar.** No overlap. OpenMap's bindings have no default keys (GEMETEN `Bindings.xml`), so nothing
  collides out of the box. OpenMap's taint work (`Combat.lua`) only touches map pins. MH's secure buttons are a
  different area. AFGELEID.
- **ToolsLaunchpad.** No overlap. OpenMap's launcher is the addon compartment plus an optional minimap button
  (`Launcher.lua`). Both addons use `AddonCompartmentFunc` (GEMETEN in both tocs), which is fine.
- **ForeverHowToPlay.** It already tells players "You buy new ranks from your class trainer as you level up" (GEMETEN
  line 28) and names trainer spells (line 79). There is no button or arrow next to that sentence. This is the natural
  spot for the trainer arrow, following MH's rule to put the explanation in the same room as the button.
- **FpsPanel** only reads CVars ("THIS PANEL CHANGES NOTHING", line 16) and does not mention `maxFPS` (GEMETEN). So
  OpenMap's optional `maxFPS` hold does not clash with it.

---

## 4. The class trainer arrow on Forever

What OpenMap would do if Questie were present (GEMETEN `Map/Townsfolk.lua` lines 74-81 and 96-193):
- It imports `QuestieDB` and `ZoneDB` through `QuestieLoader:ImportModule`, wrapped in `pcall`.
- It walks `QDB.NPCPointers`, 400 NPCs per frame.
- It keeps an NPC when `bit.band(QueryNPCSingle(id,"npcFlags"), QDB.npcFlags.TRAINER) ~= 0` **and**
  `QueryNPCSingle(id,"subName")` contains the player's own `UnitClass("player")` name (a plain substring test against
  `LOCALIZED_CLASS_NAMES_MALE`).
- It keeps only NPCs friendly to the player's faction (`friendlyToFaction` contains "A" or "H").
- It reads `spawns = {[areaID] = {{x,y},...}}` (0-100) and converts each area with `ZoneDB:GetUiMapIdByAreaId(areaID)`.
- It retries up to 12 times, 5 s apart, while Questie's DB is still loading.
- OpenMap itself calls these modules "not a public API", which fail quietly if Questie changes (GEMETEN
  `ARCHITECTURE.md`).

AFGELEID weak spot in that filter: the class match is a case-sensitive plain substring of the **male** class name. On
de/fr/es/it/pt clients a title such as "Maître des guerriers" would not contain "Guerrier". MH should match by NPC ID
or by data, not by subtitle text.

**What MH may legally reuse (AFGELEID, not legal advice):**
- **From OpenMap's own work: yes, under MIT, with the copyright notice kept.** That covers `Places.lua` and
  `FlightData.lua` (compiled from Blizzard's DB2), the code patterns, and the API usage. MH is MIT too (GEMETEN:
  `X-License: MIT` in MH's toc). For the trainer question this gives nothing, because OpenMap has no trainer data.
- **From Questie: no copying of any kind** (see the license in 2.5). A **runtime read** of a Questie the player has
  installed, as OpenMap does, ships no Questie data. Whether calling into its modules at runtime counts as making a
  "derivative work" is a legal question I cannot settle. In practice many addons do it, OpenMap (MIT) among them.
- **From `Levels.lua` (Warcraft Wiki) and `Fishing.lua` (cMaNGOS, GPL-3.0): don't copy them as "MIT data".** OpenMap
  labels them MIT, but the numbers came from those sources.
- **From `HandyNotes_ClassTrainers`: no copying.** Its header says Wowhead plus converted Questie positions, and it has
  no license (GEMETEN). At runtime its data sits behind HandyNotes' plugin handler (`ns:GetNodes2`, registered as
  "ClassTrainers", GEMETEN `Core.lua` lines 6, 240 and 470), so reading it is possible but fragile and filtered by the
  player's own HandyNotes settings. AFGELEID.

**Three ways to build the trainer arrow, in order of preference (AFGELEID):**
1. **MH's own table, measured by Rob in the game.** This follows MH's coordinate rule (what Rob measured beats every
   other source).
   - Copy OpenMap's `/openmap entrance` idea: a `/mh trainer here` command. With the trainer targeted, it saves the NPC
     ID (from `UnitGUID("target")`), the name, `C_Map.GetBestMapForUnit("player")` and the player's position to
     SavedVariables. Rob reads them back as with MH's other measurement dumps.
   - Scope it to what a new player needs: the class trainers in each race's starting zone and capital.
   - The HandyNotes data hints that Forever has extra trainers outside the classic set, for example Alterac
     Mountains: Mage NPC 246797 and Druid NPC 270459. That is GEMETEN in their file, but unverified, and **not** to be
     copied.
2. **Optional: Questie at runtime, only when it is loaded.** Use the same reads as above, matched on NPC ID or flags,
   never on subtitle text. Never ship the result. Rob does not have Questie on Forever, so he cannot test this today.
3. **Ask the client first, to test before building.** Two quick checks for Rob with `/run`: whether Forever's minimap
   tracking (`C_Minimap.GetNumTrackingTypes` / `GetTrackingInfo`) has a class-trainer type, and whether a city guard's
   directions set a map POI for "class trainer". Both are untested ideas; I measured nothing here.

**Honest value:** high for a new Forever player, since a new spell rank every two levels means a trainer visit. But
players with **Zygor** already have a "Class Trainers" finder on Forever (GEMETEN `WhoWhere.lua`: it is removed only
on retail, lines 143-144). That it really works is AFGELEID. MH's own value is the **explanation plus one button** in
ForeverHowToPlay and on level-up, which fits MH's niche of explaining things.

---

## 5. What MH could reuse from OpenMap (MIT, keep the notice)

| Item | Clean? | Note |
|---|---|---|
| `Data/Places.lua` entrances, LFG start levels, bosses, transports | Yes (OpenMap's compilation of Blizzard DB2) | The **max** level is OpenMap's +5 convention. The five Forever entrance spots were checked against Leatrix Maps, so measure those yourself. Better still, run the same recipe yourself on wago DB2 (`build.py` names the tables). |
| `Data/FlightData.lua` nodes and paths | Yes | Build 1.60.1.70245. Names are English; the HEAD commit now names them from the client. |
| `docs/api.md` patterns: versioned API, `pcall` plus `geterrorhandler`, CallbackHandler events | Yes (ideas and code) | |
| `[AllowLoadTextLocale]` toc pattern | It is a toc feature, not their property | |
| `Data/Levels.lua` | Avoid copying | Warcraft Wiki; that license was not checked here |
| `Data/Fishing.lua` | Avoid copying | cMaNGOS classic-db is GPL-3.0 (GEMETEN) |
| Townsfolk | Nothing to copy | It is Questie at runtime |
| Any texture or art | No | Blizzard's or Santiago Reyes's (GEMETEN `LICENSE` paragraph) |

---

## 6. Ideas: small and concrete, with honest value for a Forever player

1. **Fix MH's waypoint ownership check (NativeArrow). Value: medium. Size: small.**
   - Have `ns.SetBlizzardUserWaypoint` record the exact resolved point it set. Mind the parent-map resolution: compare
     against the resolved point, not `activeLead`.
   - Before every `ClearUserWaypoint` (`NativeArrow.lua` lines 916-919 and 1085-1086), compare `C_Map.GetUserWaypoint()`
     with that point.
   - Keep the current "don't take it back" behaviour.
   - This stops MH from wiping a pin the player set in OpenMap, in Blizzard's map, or through any other addon.
     AFGELEID design; it needs Rob's `/reload` and a test: follow an OpenMap pin, finish an MH route, and check that
     the pin stays followed.
2. **"Take me to my trainer" (ForeverHowToPlay plus an optional level-up line). Value: high for new players. Cost: the
   data.** It is built on idea 1's `/mh trainer here` recorder and NativeArrow with a new owner (for example
   `"trainer"`) in `OWNER_STYLE`. Optional runtime Questie source (section 4). The data effort is real; Rob has to
   visit each trainer.
3. **Load only the client's locale pack on Forever with `[AllowLoadTextLocale xxXX]`. Value: load time. Size: small.**
   - OpenMap shows the tag working on Interface 16001 (GEMETEN toc; their CHANGELOG reports a measured gain). MH's
     Camelot toc does not use it (GEMETEN: 0 hits for `AllowLoadTextLocale` in MH `*.lua`/`*.toc`; the same run found
     `GetMapLevels` in `ZoneLevelGate.lua`).
   - ⚠️ `nlNL` is manual-only (`/mh lang`), so it must stay unconditional. `Translations2026.lua`, `TranslationsS2.lua`
     and `esMX.lua` hold or patch several languages, so check what each one needs before gating it.
   - Measure the gain first (`debugprofilestop`, as OpenMap's `/openmap status` does).
4. **Test `C_Map.GetMapLevels` on Forever. Value: zone level hints with no wiki data. Size: one `/run`.**
   - MH already uses it on retail (GEMETEN `ZoneLevelGate.lua` lines 141-150 and 375-376). OpenMap never calls it
     (GEMETEN: 0 hits in the clone; the same tool found `C_Map.GetMapInfo` in `Nav.lua`) and says "the client's tables
     don't carry them".
   - If `/run print(C_Map.GetMapLevels(1429))` (Elwynn) answers on Forever, MH can show "this zone is X-Y" from the
     game itself. If it does not, MH should not take the wiki numbers into an MIT addon without checking that license.
5. **Guard the arrow's player position the way OpenMap does. Value: robustness. Size: small.**
   - Read `C_Map.GetPlayerMapPosition` through a helper that accepts a vector or a plain `{x,y}` table and returns
     nothing for a secret value.
   - Test with `/mh arrow` on Forever, in combat and close to an instance entrance.
6. **A dungeon-entrance and flight-master arrow on Forever. Value: medium.** Use MH's own wago DB2 pull with the same
   tables as OpenMap's `build.py` (`Map` corpse point, `LFGDungeons`/`ContentTuning`, `TaxiNodes`), or OpenMap's
   `Places.lua`/`FlightData.lua` under MIT. Say "starts at level N", not "N-N+5".
7. **Tooling note for MH's wago access (untested).** OpenMap's `build.py` fetches
   `https://wago.tools/db2/<Table>/csv?build=<build>` with `urllib` and a custom `User-Agent: openmap-data/1` (GEMETEN
   lines 19-20). MH's memory says WebFetch gets a 403 there. A small script through `_probe.py` with its own
   User-Agent might work. AFGELEID.
8. **Optional OpenMap hook, only if Rob wants one. Value: low today.** When `OpenMapAPI` exists, call
   `OpenMapAPI.RegisterMenuToggle("MidnightHelper", {id = "arrow", ...})` to switch MH's arrow from OpenMap's menu.
   Later, if MH ever has Forever dungeon tips, `RegisterDungeonSection` would put them on OpenMap's dungeon card.

**Not worth building:** a map of our own, townsfolk pins, or pin sharing. OpenMap, HandyNotes and Zygor already cover
those, and MH's strength is explaining things (MH memory: market position).

---

## 7. Not checked or still open

- No in-game test of anything: not OpenMap, not the waypoint clashes, not `GetMapLevels`, not tracking types.
- Whether Forever's `C_Map.SetUserWaypoint` works on every zone map. OpenMap guards it with `CanSetUserWaypointOnMap`
  and keeps its own pin as a fallback.
- The Warcraft Wiki's content license, and Leatrix Maps' license (for the five entrance spots).
- The CurseForge page itself. I used the GitHub repo and the GitHub API, not CF (the project ID matches the toc,
  GEMETEN).
- `HandyNotes_ClassTrainers` (CF project 1762709, author Frost-Lightbringer, v1.0.0): only its header and plugin hook
  were read.

## Files
- This report: `C:\Users\RobHu\AppData\Local\Temp\claude\e1c44003d48d72c2\6b683006-f185-4f0a-b7b3-af9a8f2dc4a8\scratchpad\REVIEW_OPENMAP.md`
- OpenMap clone (untrusted, not run): `C:\Users\RobHu\AppData\Local\Temp\claude\e1c44003d48d72c2\6b683006-f185-4f0a-b7b3-af9a8f2dc4a8\scratchpad\dl_openmap\`
- Key OpenMap files: `OpenMap\API.lua`, `OpenMap\Map\Townsfolk.lua`, `OpenMap\Map\Nav.lua`, `OpenMap\Map\Pins.lua`, `OpenMap\Map\WorldMap.lua`, `OpenMap\Data\Places.lua`, `OpenMap\Data\FlightData.lua`, `OpenMap\Data\Levels.lua`, `OpenMap\Data\Fishing.lua`, `tools\map-data\build.py`, `docs\api.md`, `ARCHITECTURE.md`, `LICENSE`
- MH files referenced: `E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Modules\NativeArrow.lua` (lines 157-174, 324-329, 908-1105), `...\MidnightHelper\Core.lua` (lines 843-870), `...\MidnightHelper\MidnightHelper_Camelot.toc`, `...\MidnightHelper\Modules\ForeverHowToPlay.lua` (line 28)
- Side sources: `E:\World of Warcraft\_forever_\Interface\AddOns\HandyNotes_ClassTrainers\Data.lua` (header), `E:\World of Warcraft\_forever_\Interface\AddOns\ZygorGuidesViewerForever\WhoWhere.lua` (lines 105-149)
- Helper file I wrote: `...\scratchpad\questie_license.b64` (Questie's LICENSE.md as base64; I decoded it to read it).
