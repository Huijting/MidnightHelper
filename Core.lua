--[[
	MidnightHelper - Core.lua (load order: first)

	This file owns saved-variable initialization, a hidden event frame, and
	slash-command routing. The Blizzard client passes (addonName, ns) via ...
	to every TOC-loaded file; all modules share the same `ns` table.
]]

--------------------------------------------------------------------------------
-- Namespace: addonName + private addon table (ns), provided by the client.
--------------------------------------------------------------------------------

-- LuaLS type basis (review F3.9). These are annotations only — pure comments, no
-- runtime effect. `ns` is the shared table every module receives via `...`; `ns.db`
-- is MidnightHelperDB. Fields grow dynamically, so this documents the stable core.

---@class MHDB  saved variables (MidnightHelperDB); fields mirror DEFAULT_DB
---@field schemaVersion integer  migration version, see RunSchemaMigrations
---@field locale string  "auto" or a pack code (enUS/deDE/…/nlNL)
---@field firstRunSeen boolean  set once the first-run popup has shown
---@field favourites string[]  pinned tab ids (on-demand; NOT in DEFAULT_DB)
---@field ui table  window/display + per-feature UI settings
---@field settings table  guideVisibility, compactMode
---@field minimap table  LibDBIcon: hide, minimapPos, lock
---@field changelog table  lastSeenVersion, hideForever
---@field charCurrencies table  per-alt snapshot bag

---@class MidnightHelperNS  the private addon namespace shared across all files
---@field db MHDB
---@field L fun(self:MidnightHelperNS, key:string, ...):string  localized string

local addonName, ns = ... ---@type string, MidnightHelperNS

--- Load an on-demand Blizzard addon (e.g. "Blizzard_AchievementUI").
--- 12.1 renames `UIParentLoadAddOn` to `LoadAddOnWithErrorHandling` (Warcraft Wiki,
--- Patch 12.1.0 API changes, datamined build 68675). Every call site guarded the
--- old name with `if UIParentLoadAddOn then`, so on 12.1 they would not error —
--- they would silently do nothing, and the Achievement window and Death Recap
--- would just stop opening with no clue why. Try the new name first, fall back to
--- the old one, so this works on 12.0.7 and 12.1 without a version gate.
--- @return boolean loaded
function ns.LoadBlizzardAddOn(name)
	if type(name) ~= "string" then
		return false
	end
	local fn = _G.LoadAddOnWithErrorHandling or _G.UIParentLoadAddOn
	if not fn then
		return false
	end
	return pcall(fn, name) == true
end

--- Installed version from MidnightHelper.toc (## Version); used in UI and changelog.
function ns.GetAddonVersion()
	if C_AddOns and C_AddOns.GetAddOnMetadata then
		local ok, v = pcall(C_AddOns.GetAddOnMetadata, addonName, "Version")
		if ok and type(v) == "string" and v ~= "" then
			return v
		end
	end
	if GetAddOnMetadata then
		local ok, v = pcall(GetAddOnMetadata, addonName, "Version")
		if ok and type(v) == "string" and v ~= "" then
			return v
		end
	end
	return "?"
end

--------------------------------------------------------------------------------
-- Default settings merged into MidnightHelperDB on first run
--------------------------------------------------------------------------------
local DEFAULT_DB = {
	--- Display language: "auto" (WoW client), explicit pack (enUS, deDE, …), or nlNL (manual only).
	locale = "auto",
	--- Spec 15 nudges the user dismissed: { [nudgeId] = true }. Empty default is safe
	--- (a set, not a list) — MergeDefaults only ensures the table exists, never re-adds.
	nudgeDismissed = {},
	--- Spec 13 mount wishlist: { [mountID] = true }. Account-wide, like collecting is.
	mountWishlist = {},
	--- Personal milestones already awarded: { [id] = unixTime }. Never re-fires.
	--- Keys starting with "_" are bookkeeping (highest track seen), not awards.
	milestones = {},
	--- Waar de combat log ons weigerde + waar hij wel mocht (bewijs voor de
	--- ADDON_ACTION_FORBIDDEN-jacht; moet reloads overleven, zie Retrospective).
	cleuRefusals = {},
	cleuAllowed = {},
	--- Season counters, groundwork for a retrospective: { startedAt=, seasonId=, counts={} }.
	seasonStats = {},
	--- One Codex entry per day on This Week: { dismissedDay=, enabled= }.
	dailyTip = {},
	ui = {
		-- If true, the main window will be shown automatically after login.
		openOnLogin = false,
		debug = false,
		scale = 1.0,
		--- Content text scale (independent of window scale). See ns.ApplyContentFontScale.
		fontScale = 1.0,
		--- Delves tab accordion: `"midnight"` | `"vault"`.
		delvesAccordionSection = "midnight",
		--- Account snapshot tab: sort + filter (see Modules/AltOverview.lua).
		accountSnapshot = {
			sortBy = "name",
			sortDesc = false,
			filterStaleOnly = false,
			filterHasKeysOnly = false,
			filterShardCapOnly = false,
			filterDundunIncompleteOnly = false,
		},
		--- Great Vault reset reminders (chat, minimap tooltip, icon pulse).
		vaultReminder = {
			enabled = true,
			chat = true,
			minimap = true,
			ping = true,
			popup = true,
		},
		--- Great Vault Advisor (guide stats, optional Pawn, raid/M+ profile).
		vaultAdvisor = {
			usePawn = true,
			profileMode = "auto",
			showBlizzardPanel = true,
		},
		--- Sidebar beta tabs (Codex, Basics, Leveling Guides, Macros, Role Academy).
		betaTabs = {
			enabled = true,
			codex = true,
			reference = true,
			guide = true,
			macros = true,
			academy = true,
		},
		--- Active world boss this week (account cache after any char detects it).
		worldBossWeek = {},
		--- Midnight Codex handbook (last viewed category).
		codex = {
			category = "start",
		},
		--- Floating Delve Coach panel (position, minimize state).
		--- Floating RAID-R Mini / Trovehunter's Bounty buttons (beside Delve Coach in delves).
		delveItemsPopup = {
			enabled = true,
			autoShowInDelve = true,
			point = "CENTER",
			relPoint = "CENTER",
			x = 0,
			y = 80,
			userPositioned = false,
		},
		--- Event-style toasts (bounty detected, etc.).
		toast = {
			enabled = true,
			delveBounty = true,
		},
		delveCoach = {
			enabled = true,
			autoShow = true,
			shareTestMode = false,
			minimized = false,
			scale = 1,
			width = 320,
			height = 480,
			bossIndex = {},
			bossCam = {},
			storyDaily = {},
			point = "RIGHT",
			relPoint = "RIGHT",
			x = -36,
			y = 0,
		},
		--- Side panels beside Blizzard's own windows (character sheet, Mythic+,
		--- Adventure Guide, mount collection). Default on; ns.SetSidePanelsEnabled
		--- hides them immediately when switched off.
		sidePanels = true,
		--- Role Academy tab: "tank" | "heal" (see Modules/RoleAcademy.lua).
		roleAcademyTrack = "tank",
		roleAcademyPreflight = {
			tank = {},
			heal = {},
			dps = {},
		},
	},
	-- Leveling Guides: optional preview of another class/spec (see Addons/Guide.lua search bar).
	guide = {
		preview = false,
		classToken = "",
		specIndex = 0,
	},
	--- Minimap button (LibDBIcon-1.0): hide, minimapPos, lock.
	minimap = {
		hide = false,
	},
	--- Delve consumable minimap icons (separate position/hide per icon).
	minimapDelveRadar = {
		hide = false,
	},
	minimapDelveTreasure = {
		hide = false,
	},
	settings = {
		--- Guide tab visibility: "auto" (hide at level 90+), "always", "hidden".
		guideVisibility = "auto",
		--- Compact mode: denser main UI layout for smaller resolutions.
		compactMode = false,
	},
	changelog = {
		--- Last addon version for which the changelog popup was dismissed.
		lastSeenVersion = "",
		--- User opted out permanently.
		hideForever = false,
	},
}

local function MergeDefaults(target, defaults)
	if type(target) ~= "table" then
		target = {}
	end
	for k, v in pairs(defaults) do
		if type(v) == "table" then
			target[k] = MergeDefaults(target[k], v)
		elseif target[k] == nil then
			target[k] = v
		end
	end
	return target
end

--------------------------------------------------------------------------------
-- SavedVariables schema versioning + migrations (review F3.2)
--   `db.schemaVersion` records how far the DB has been migrated. Each entry in
--   MIGRATIONS[] upgrades from version n-1 to n; keep them ordered and idempotent
--   and bump CURRENT_SCHEMA_VERSION when you add one. Migrations run BEFORE
--   MergeDefaults so they transform raw persisted data, then defaults fill gaps.
--
--   NB: several user-editable fields are stored on demand rather than in
--   DEFAULT_DB, on purpose — MergeDefaults merges tables by key, so seeding a
--   LIST default (e.g. favourites) would re-add entries a user deliberately
--   removed. On-demand fields: db.favourites (UI.lua), db.firstRunSeen
--   (Modules/FirstRun.lua), ui.mainWidth/mainHeight/mainPoint (window size+pos).
--------------------------------------------------------------------------------
local CURRENT_SCHEMA_VERSION = 1

local MIGRATIONS = {
	-- v0 -> v1 (2026-07): drop ghost fields (re-seeded or written-never-read) and
	-- fold in the old ad-hoc InitSavedVariables cleanups.
	function(db)
		if type(db.ui) == "table" then
			db.ui.altOverviewExpanded = nil -- legacy; was re-seeded from DEFAULT_DB forever
			db.ui.simpleMode = nil          -- phased-out simple-mode ghost
			if db.ui.delvesAccordionSection == "alt" then
				db.ui.delvesAccordionSection = "midnight" -- section no longer exists
			end
		end
		db.simpleMode = nil -- ghost could also sit at top level (a UI toggle wrote it here)
	end,
}

--- Run migrations the DB hasn't seen, then stamp the version. `fresh` = brand-new
--- install (no prior data): nothing to migrate, just stamp the current version.
local function RunSchemaMigrations(db, fresh)
	local from = tonumber(db.schemaVersion) or 0
	if not fresh then
		for v = from + 1, CURRENT_SCHEMA_VERSION do
			local m = MIGRATIONS[v]
			if m then
				pcall(m, db)
			end
		end
		-- A pre-schema DB with real data belongs to a returning player, not a
		-- newcomer: don't let the first-run popup greet them (Modules/FirstRun.lua).
		if from == 0 and db.firstRunSeen == nil then
			db.firstRunSeen = true
		end
	end
	db.schemaVersion = CURRENT_SCHEMA_VERSION
end

--------------------------------------------------------------------------------
-- Saved variables: MidnightHelperDB (see MidnightHelper.toc)
--------------------------------------------------------------------------------
function ns:InitSavedVariables()
	-- Capture "brand-new install" BEFORE we touch the table, so migrations can tell
	-- a first-ever load apart from a returning player's pre-schema DB.
	local fresh = (type(MidnightHelperDB) ~= "table") or (next(MidnightHelperDB) == nil)

	if type(MidnightHelperDB) ~= "table" then
		MidnightHelperDB = {}
	end

	if not MidnightHelperDB.charCurrencies then
		MidnightHelperDB.charCurrencies = {}
	end

	RunSchemaMigrations(MidnightHelperDB, fresh) -- transform raw data first...
	MergeDefaults(MidnightHelperDB, DEFAULT_DB)  -- ...then fill in any missing defaults
	self.db = MidnightHelperDB

	--- Remove invalid / stale alt snapshot entries (bad GUID keys, empty names).
	do
		local bag = MidnightHelperDB.charCurrencies
		if type(bag) == "table" then
			for guid, snap in pairs(bag) do
				if type(snap) ~= "table" then
					bag[guid] = nil
				elseif type(guid) ~= "string" or not string.match(guid, "^Player%-") then
					bag[guid] = nil
				else
					local nm = snap.name
					if type(nm) ~= "string" or nm == "" or nm == "?" then
						bag[guid] = nil
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Content font scaling (independent of window scale)
--   Modules render text with Blizzard font objects (GameFontHighlightSmall…).
--   ns.MHScalableFont(name) returns a per-name MH *copy* of that font object;
--   ns.ApplyContentFontScale() resizes every copy live, so any panel that routes
--   its SetFontObject calls through it scales on the fly — no panel rebuild.
--   Window chrome that keeps the raw Blizzard fonts is untouched: that is the
--   decoupling Rob asked for (window stays put, text scales).
--------------------------------------------------------------------------------
ns._mhFonts = ns._mhFonts or {}        -- blizzName -> CreateFont() object
ns._mhFontBase = ns._mhFontBase or {}  -- blizzName -> { path, size, flags }

function ns.MHScalableFont(name)
	if type(name) ~= "string" then
		return name -- already a font object (or nil): leave as-is
	end
	local existing = ns._mhFonts[name]
	if existing then
		return existing
	end
	local base = _G[name]
	if type(base) ~= "table" or type(base.GetFont) ~= "function" then
		return name
	end
	local path, size, flags = base:GetFont()
	if not path or not size then
		return name -- font not ready yet: fall back to the raw object name
	end
	local fo = CreateFont("MidnightHelperSF_" .. name)
	fo:CopyFontObject(base)
	ns._mhFonts[name] = fo
	ns._mhFontBase[name] = { path = path, size = size, flags = flags }
	local scale = (ns.db and ns.db.ui and ns.db.ui.fontScale) or 1
	if scale ~= 1 then
		fo:SetFont(path, math.max(6, size * scale), flags)
	end
	return fo
end

--- Resize every MH scalable font in place. Pass a number to also persist it.
function ns.ApplyContentFontScale(scale)
	if type(scale) == "number" and ns.db and ns.db.ui then
		ns.db.ui.fontScale = scale
	end
	local s = (ns.db and ns.db.ui and ns.db.ui.fontScale) or 1
	for name, fo in pairs(ns._mhFonts) do
		local b = ns._mhFontBase[name]
		if b and b.path and b.size then
			fo:SetFont(b.path, math.max(6, b.size * s), b.flags)
		end
	end
	return s
end

function ns.GetContentFontScale()
	return (ns.db and ns.db.ui and ns.db.ui.fontScale) or 1
end

--------------------------------------------------------------------------------
-- Central event dispatcher
--------------------------------------------------------------------------------
function ns:OnEvent(event, ...)
	if event == "ADDON_LOADED" then
		local loadedAddon = ...
		if loadedAddon ~= addonName then
			return
		end

		self:InitSavedVariables()
		if ns.ApplyContentFontScale then
			ns.ApplyContentFontScale()
		end
		if self.MigrateLocalePreference then
			self:MigrateLocalePreference()
		end
		if self.ReconcileGatedLocale then
			self:ReconcileGatedLocale()
		end
		if self.ApplyBindingLabels then
			self:ApplyBindingLabels()
		end

		-- Trigger module setup in a single, predictable call.
		-- Both Delves and Profession hook EnsureMainUI; calling it once here
		-- ensures they initialise in TOC load order, not in hook-wrapping order.
		if self.EnsureMainUI then
			self:EnsureMainUI()
		end

		if self.db and self.InitDelveItemBrokers then
			self:InitDelveItemBrokers()
		end

		if self.db and self.db.ui and self.db.ui.openOnLogin and self.ShowMainUI then
			self:ShowMainUI()
		end

		self.eventFrame:UnregisterEvent("ADDON_LOADED")
		return
	end
end

function ns:SetLocale(code, silent)
	local normalized = self.NormalizeLocaleInput and self:NormalizeLocaleInput(code) or code
	if not normalized then
		return false
	end
	if self.db then
		self.db.locale = normalized
	end
	if not silent then
		local label = self.GetLocaleDisplayNameForChat and self:GetLocaleDisplayNameForChat(normalized)
			or self:GetLanguageStatusLabel()
			or self:GetLocaleDisplayName(normalized)
		if self.PrintChatKey then
			self:PrintChatKey("LANG_SET", label)
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(self:L("PRINT_PREFIX"), self:L("LANG_SET"):format(label))
			)
		end
		-- The caveats come AFTER the confirmation, never before it. Printed first, the
		-- gated-pack notice answered a question the player had not been told the result
		-- of yet, and then "Language set to French" seemed to contradict it (Rob,
		-- 2026-07-22). Order matters: what happened, then what it means.
		if self.ReconcileGatedLocale then
			self:ReconcileGatedLocale()
		end
		if self.PrintChatKey and self.GetChatLocaleCode and self.GetEffectiveLocaleCode then
			local eff = self:GetEffectiveLocaleCode()
			local chat = self:GetChatLocaleCode()
			if chat ~= eff then
				self:PrintChatKey("LANG_SET_CHAT_FALLBACK")
			end
		end
	end
	if self.ApplyBindingLabels then
		self:ApplyBindingLabels()
	end
	if self.RefreshLocaleUI then
		self:RefreshLocaleUI()
	end
	return true
end

function ns:GetGuideVisibilityMode()
	local mode = self.db and self.db.settings and self.db.settings.guideVisibility
	if mode == "always" or mode == "hidden" or mode == "auto" then
		return mode
	end
	return "auto"
end

function ns:IsGuideTabEnabled()
	local mode = self:GetGuideVisibilityMode()
	if mode == "always" then
		return true
	end
	if mode == "hidden" then
		return false
	end
	if self.db and self.db.guide and self.db.guide.preview == true then
		return true
	end
	local level = UnitLevel and UnitLevel("player") or 0
	return (tonumber(level) or 0) < 90
end

local BETA_TAB_IDS = {
	codex = true,
	reference = true,
	guide = true,
	macros = true,
	academy = true,
}

function ns.GetBetaTabsSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { enabled = true, codex = true, reference = true, guide = true, macros = true, academy = true }
	end
	if type(ui.betaTabs) ~= "table" then
		ui.betaTabs = { enabled = true, codex = true, reference = true, guide = true, macros = true, academy = true }
	end
	if ui.betaTabs.codex == nil then
		ui.betaTabs.codex = true
	end
	return ui.betaTabs
end

function ns.IsBetaTabId(tabId)
	return tabId and BETA_TAB_IDS[tabId] == true
end

function ns.IsBetaTabEnabled(tabId)
	if not ns.IsBetaTabId(tabId) then
		return true
	end
	local bt = ns.GetBetaTabsSettings()
	if bt.enabled == false then
		return false
	end
	if bt[tabId] == false then
		return false
	end
	if tabId == "guide" and ns.IsGuideTabEnabled and not ns:IsGuideTabEnabled() then
		return false
	end
	return true
end

function ns.SetBetaTabOption(key, value)
	local bt = ns.GetBetaTabsSettings()
	if key == "enabled" then
		bt.enabled = value and true or false
	elseif BETA_TAB_IDS[key] then
		bt[key] = value and true or false
	else
		return
	end
	if ns.RefreshBetaTabVisibility then
		ns.RefreshBetaTabVisibility()
	end
end

function ns:SetGuideVisibilityMode(mode, silent)
	local normalized = tostring(mode or ""):lower()
	if normalized ~= "auto" and normalized ~= "always" and normalized ~= "hidden" then
		return false
	end
	if self.db and self.db.settings then
		self.db.settings.guideVisibility = normalized
	end
	if self.RefreshGuideTabVisibility then
		self:RefreshGuideTabVisibility()
	end
	if not silent then
		local map = {
			auto = self:L("SETTINGS_GUIDE_MODE_AUTO"),
			always = self:L("SETTINGS_GUIDE_MODE_ALWAYS"),
			hidden = self:L("SETTINGS_GUIDE_MODE_HIDDEN"),
		}
		local label = map[normalized] or normalized
		DEFAULT_CHAT_FRAME:AddMessage(
			("|cffffcc00%s|r %s"):format(self:L("PRINT_PREFIX"), self:L("SETTINGS_GUIDE_MODE_SET"):format(label))
		)
	end
	return true
end

function ns:IsCompactModeEnabled()
	return self.db and self.db.settings and self.db.settings.compactMode == true
end

function ns:SetCompactModeEnabled(enabled, silent)
	local value = enabled and true or false
	if self.db and self.db.settings then
		self.db.settings.compactMode = value
	end
	if self.ApplyCompactMode then
		self:ApplyCompactMode()
	end
	if not silent then
		local state = value and self:L("SETTINGS_BOOL_ON") or self:L("SETTINGS_BOOL_OFF")
		DEFAULT_CHAT_FRAME:AddMessage(
			("|cffffcc00%s|r Compact mode: %s"):format(self:L("PRINT_PREFIX"), state)
		)
	end
	return true
end

-- Some sub-area maps (Slayer's Rise, The Den, a city Bazaar, cave floors) don't
-- accept a user waypoint, so SetUserWaypoint silently fails and you get NO arrow.
-- Walk up to the first ancestor map that DOES accept one, translating the coord
-- through world position (linear), so a treasure on a sub-map still gets a
-- trackable waypoint on its parent zone. Returns mapID, x01, y01 (0-1 coords).
local function MHResolveWaypointMap(mapID, x01, y01)
	if not (C_Map and C_Map.CanSetUserWaypointOnMap) then
		return mapID, x01, y01
	end
	if C_Map.CanSetUserWaypointOnMap(mapID) then
		return mapID, x01, y01
	end
	if not (C_Map.GetWorldPosFromMapPos and C_Map.GetMapInfo and CreateVector2D) then
		return mapID, x01, y01
	end
	local function worldXY(uiMap, px, py)
		local ok, _, world = pcall(C_Map.GetWorldPosFromMapPos, uiMap, CreateVector2D(px, py))
		if not ok or not world then
			return nil
		end
		if world.GetXY then
			return world:GetXY()
		end
		return world.x, world.y
	end
	local wx, wy = worldXY(mapID, x01, y01)
	if not wx then
		return mapID, x01, y01
	end
	local cur = mapID
	for _ = 1, 10 do -- safety bound on the parent chain
		local info = C_Map.GetMapInfo(cur)
		if not info or not info.parentMapID or info.parentMapID == 0 then
			break
		end
		cur = info.parentMapID
		if C_Map.CanSetUserWaypointOnMap(cur) then
			local x0, y0 = worldXY(cur, 0, 0)
			local x1, y1 = worldXY(cur, 1, 1)
			if x0 and x1 and x0 ~= x1 and y0 ~= y1 then
				local nx = (wx - x0) / (x1 - x0)
				local ny = (wy - y0) / (y1 - y0)
				if nx >= 0 and nx <= 1 and ny >= 0 and ny <= 1 then
					return cur, nx, ny
				end
			end
		end
	end
	return mapID, x01, y01
end

--- Blizzard map waypoint using 0–100 map coordinates (fallback when TomTom is absent).
function ns.SetBlizzardUserWaypoint(mapID, xPct, yPct)
	local targetMap = tonumber(mapID)
	local xN, yN = tonumber(xPct), tonumber(yPct)
	if not targetMap or not xN or not yN then
		return false
	end
	local x = xN / 100
	local y = yN / 100
	if x <= 0 or y <= 0 then
		return false
	end
	if not UiMapPoint or not UiMapPoint.CreateFromCoordinates then
		return false
	end
	-- Resolve sub-area maps that can't hold a waypoint up to their parent zone.
	targetMap, x, y = MHResolveWaypointMap(targetMap, x, y)
	local ok, mapPoint = pcall(UiMapPoint.CreateFromCoordinates, targetMap, x, y)
	if not ok or not mapPoint then
		return false
	end
	if C_Map and C_Map.SetUserWaypoint then
		pcall(C_Map.SetUserWaypoint, mapPoint)
	end
	if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
		pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
	end
	return true
end

--------------------------------------------------------------------------------
-- Hidden core frame: registers events and forwards to ns:OnEvent
--------------------------------------------------------------------------------
ns.eventFrame = CreateFrame("Frame", "MidnightHelperEventFrame", UIParent)
ns.eventFrame:SetScript("OnEvent", function(_, event, ...)
	ns:OnEvent(event, ...)
end)
ns.eventFrame:RegisterEvent("ADDON_LOADED")

--------------------------------------------------------------------------------
-- Slash commands: /mh and /midnight toggle the main window (implemented in UI.lua)
--------------------------------------------------------------------------------
SLASH_MIDNIGHTHELPER1 = "/mh"
SLASH_MIDNIGHTHELPER2 = "/midnight"

--- Esc → Keybindings → Midnight Helper (custom section) → Toggle main window
function MidnightHelper_KeybindToggleMain()
	if SlashCmdList and SlashCmdList["MIDNIGHTHELPER"] then
		SlashCmdList["MIDNIGHTHELPER"]("")
	end
end

-- Skip the achievement node the route arrow is currently on (e.g. an un-spawned
-- rare) and re-point at the next-nearest open one. Handy as an in-flight keybind.
function MidnightHelper_KeybindSkipNode()
	-- During a rare hunt the shared arrow is a Rares route — skip the current rare;
	-- otherwise skip the current achievement route node.
	if ns._mhRouteOwner == "rare" and ns.SkipCurrentRare then
		ns.SkipCurrentRare()
	elseif ns.SkipCurrentAchievementNode then
		ns.SkipCurrentAchievementNode()
	end
end

-- Clear whatever route/arrow is currently active (any type). Asks each route module
-- to fully stop (so its ticker/events don't re-draw), then clears the shared arrow,
-- TomTom waypoints and the native user waypoint. Safe to call with nothing active.
function ns.ClearActiveRoute()
	local hadRoute = (ns._mhRouteOwner ~= nil) or (ns.lastTarget ~= nil)
	if ns.StopAchievementRoute then
		ns.StopAchievementRoute()
	end
	if ns.StopRareRoute then
		ns.StopRareRoute()
	end
	if ns.StopTreasureRoute then
		ns.StopTreasureRoute()
	end
	if ns.CancelResetRoute then
		ns.CancelResetRoute()
	end
	ns.MH_TomTomClearAll()
	if C_Map and C_Map.ClearUserWaypoint then
		pcall(C_Map.ClearUserWaypoint)
	end
	ns._mhRouteOwner = nil
	ns.lastTarget = nil
	return hadRoute
end

-- Guarded TomTom-clear. Onze eigen route-code wist soms bewust alle waypoints om
-- daarna direct opnieuw te pinnen (clear-then-add bij het starten van een route).
-- Deze helper markeert dat WÍJ aan het wissen zijn (ns._mhSelfWaypointOp), zodat de
-- ClearAllWaypoints-hook hieronder dat NIET als "speler annuleert" opvat. Alle
-- interne clears lopen via deze helper.
function ns.MH_TomTomClearAll()
	ns._mhSelfWaypointOp = true
	if ns.IsTomTomReady and ns.IsTomTomReady() and _G.TomTom and _G.TomTom.ClearAllWaypoints then
		pcall(_G.TomTom.ClearAllWaypoints, _G.TomTom)
	end
	ns._mhSelfWaypointOp = false
end

-- Detecteer wanneer de SPELER TomTom-waypoints zelf wist (rechtsklik op de crazy
-- arrow → "alle pijlen wissen"). Zonder dit bleven onze route-states (ns.lastTarget
-- voor delve-reizen, ns._mhRouteOwner voor rare/achievement/treasure/reset) staan,
-- waardoor de zone-handlers de pijl bij elke zonewissel opnieuw opbouwden.
--
-- De hook kan "wij" en "de speler" uit elkaar houden via ns._mhSelfWaypointOp: onze
-- eigen clear-then-add zet die vlag (via ns.MH_TomTomClearAll), dus dan doen we niks.
-- Bij een échte spelersclear stoppen we de route volledig via ns.ClearActiveRoute
-- (die zelf óók de guarded helper gebruikt → geen recursie).
local function MH_InstallTomTomClearHook()
	if ns._mhTomTomClearHooked then
		return
	end
	local tt = _G.TomTom
	if type(tt) ~= "table" or type(tt.ClearAllWaypoints) ~= "function" then
		return
	end
	ns._mhTomTomClearHooked = true
	hooksecurefunc(tt, "ClearAllWaypoints", function()
		if ns._mhSelfWaypointOp then
			return -- onze eigen clear-then-add: route wordt juist (her)gestart
		end
		if ns.ClearActiveRoute then
			ns.ClearActiveRoute()
		else
			ns.lastTarget = nil
			ns._mhRouteOwner = nil
		end
	end)
end

local mhTomTomHookFrame = CreateFrame("Frame")
mhTomTomHookFrame:RegisterEvent("PLAYER_LOGIN")
mhTomTomHookFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
mhTomTomHookFrame:SetScript("OnEvent", function()
	MH_InstallTomTomClearHook()
end)

-- Esc → Key Bindings → Midnight Helper → Clear active route.
function MidnightHelper_KeybindClearRoute()
	if ns.ClearActiveRoute then
		ns.ClearActiveRoute()
	end
end

SlashCmdList["MIDNIGHTHELPER"] = function(msg)
	msg = (msg or ""):gsub("^%s+", ""):gsub("%s+$", "")

	if ns.RunDelveItemsSlashCommand and ns:RunDelveItemsSlashCommand(msg) then
		return
	end

	if ns.RunAchievementSlashCommand and ns:RunAchievementSlashCommand(msg) then
		return
	end

	-- /mh mbuff — debug: toon Missing-Buff-detectie (geleerd/spec/actief + missende lijst).
	if msg == "mbuff" then
		if ns.PrintMissingBuffDebug then
			ns.PrintMissingBuffDebug()
		end
		return
	end

	-- /mh groupbuffs — which raid-wide class buffs is the group missing?
	if msg == "groupbuffs" or msg == "gbuffs" then
		if ns.PrintGroupBuffs then
			ns.PrintGroupBuffs()
		end
		return
	end

	-- /mh pawn — export this spec's stat weights as a Pawn scale string.
	if msg == "pawn" then
		if ns.ShowPawnExport then
			ns.ShowPawnExport()
		end
		return
	end

	-- /mh wishlist — your mount wishlist progress; opens the Mounts tab.
	if msg == "wishlist" then
		if ns.PrintMountWishlist then
			ns.PrintMountWishlist()
		end
		return
	end

	-- /mh auras — kunnen we auras lezen, en mogen we ze geloven? Eerste commando om te
	-- draaien zodra 12.1 op de PTR staat (de aura-API verandert daar).
	if msg == "auras" then
		if ns.PrintAuraDiagnostics then
			ns.PrintAuraDiagnostics()
		end
		return
	end

	-- /mh campaign — verifieer de Curse-of-Ula'tek-lead-in quest-IDs tegen de live game.
	if msg == "campaign" then
		if ns.PrintCampaignLeadInDiagnostics then
			ns.PrintCampaignLeadInDiagnostics()
		end
		return
	end

	-- /mh season — toon de S1→S2-fase + elk item met opgeloste achievement/quest-naam,
	-- zodat de IDs (bv. KSM 61256) in-game te verifiëren zijn vóór we ze vertrouwen.
	-- /mh milestones — de persoonlijke mijlpalen die al zijn uitgereikt.
	if msg == "milestones" then
		if ns.PrintMilestones then ns.PrintMilestones() end
		return
	end

	-- /mh season stats — de seizoenstellers (zelfde patroon als "scorecard detail").
	if msg == "season stats" then
		if ns.PrintSeasonStats then ns.PrintSeasonStats() end
		return
	end

	if msg == "season" then
		if ns.PrintSeasonTransitionDiagnostics then
			ns.PrintSeasonTransitionDiagnostics()
		end
		return
	end

	-- /mh translate — open the "help translate Midnight Helper" how-to (Spec 15).
	if msg == "translate" then
		if ns.OpenTranslateHelp then ns.OpenTranslateHelp() end
		return
	end

	-- /mh discord — print the community Discord invite + a copy box (Spec 15).
	if msg == "discord" then
		if ns.ShowDiscordInvite then ns.ShowDiscordInvite() end
		return
	end

	-- /mh mplus — Mythic+ gain advisor: this week's Great Vault M+ slots + rating (Spec 20).
	if msg == "mplus" then
		if ns.PrintMythicGain then
			ns.PrintMythicGain()
		end
		return
	end

	-- /mh kicks — interrupt scorecard: your landed/wasted this run. "alert" toggles the
	-- personal pre-12.1 whiff nudge; "reset" clears the tally (Spec 14).
	if msg == "kicks" or msg == "kicks alert" or msg == "kicks reset" then
		if ns.HandleInterruptCommand then
			ns.HandleInterruptCommand(msg:match("^kicks%s+(%S+)"))
		end
		return
	end

	-- /mh loot — toggle the loot-upgrade tooltip tips (is this drop better for my spec?).
	if msg == "loot" then
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		if ns.ToggleLootUpgradeTips then
			local on = ns.ToggleLootUpgradeTips()
			print(("%s loot upgrade tips: %s"):format(prefix, on and "on" or "off"))
		end
		return
	end

	-- /mh encounters — toggle logging ENCOUNTER_START/END (encounterID capture, PTR).
	if msg == "encounters" then
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		if ns.ToggleEncounterCapture then
			local onNow = ns.ToggleEncounterCapture()
			print(("%s encounter capture: %s"):format(prefix, onNow and "on — now pull bosses" or "off"))
		end
		return
	end

	-- /mh instance — print the current instance's journalInstanceID + name (PTR capture).
	if msg == "instance" then
		if ns.PrintInstanceCapture then
			ns.PrintInstanceCapture()
		end
		return
	end

	-- /mh death — probe C_DeathInfo + what we can read of the last death recap,
	-- so the beginner death-recap can be finalised against the real API.
	-- /mh death auto — toggle auto-opening Blizzard's recap on a restricted-content death.
	if msg == "death auto" then
		if ns.ToggleDeathRecapAutoOpen then
			ns.ToggleDeathRecapAutoOpen()
		end
		return
	end
	if msg == "death" then
		if ns.PrintDeathRecapDiagnostics then
			ns.PrintDeathRecapDiagnostics()
		end
		return
	end

	-- /mh healcds — print your spec's healing-cooldown cheat-sheet (healer specs).
	if msg == "healcds" then
		if ns.PrintHealerCooldownSheet then
			ns.PrintHealerCooldownSheet()
		end
		return
	end

	-- /mh dispelprobe — check whether party/raid debuffs are readable (vs secret)
	-- on this client, to decide if a live dispel heads-up is feasible.
	-- /mh dispelprobe watch — auto-fire the probe on the first ally debuff (no manual timing).
	if msg == "dispelprobe watch" then
		if ns.ArmDispelProbe then
			ns.ArmDispelProbe()
		end
		return
	end
	-- /mh folio — why the "Open rune window" button did not open a window.
	-- /mh tracks — which equipped slots are at their upgrade ceiling, and what
	-- actually raises them from there (Spec 21).
	-- /mh weeklies — probe for the weekly quest-giver ids MH has never been able to
	-- track (Liadrin / Void Assault rotation). Unverified on purpose; see the module.
	if msg == "weeklies" then
		if ns.PrintWeeklyHubProbe then
			ns.PrintWeeklyHubProbe()
		end
		return
	end
	if msg == "tracks" then
		if ns.PrintTrackCeiling then
			ns.PrintTrackCeiling()
		end
		return
	end
	-- /mh panelreset — put every side panel back beside its window. Cheap insurance:
	-- the panels are draggable, and a panel dragged off-screen has no other way back.
	if msg == "panelreset" then
		if ns.ResetSidePanels then
			ns.ResetSidePanels()
		elseif ns.db then
			ns.db.sidePanelOffsets = nil
		end
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("SIDEPANEL_RESET_DONE")))
		return
	end
	if msg == "folio" then
		if ns.PrintOmniumFolioProbe then
			ns.PrintOmniumFolioProbe()
		end
		return
	end
	if msg == "dispelprobe" then
		if ns.PrintDispelProbe then
			ns.PrintDispelProbe()
		end
		return
	end

	-- /mh dispellog [clear] — the heal-lens data collector: dispellable debuffs
	-- captured on you in instances (spell / school / boss).
	if msg == "dispellog" then
		if ns.PrintDispelCaptureLog then
			ns.PrintDispelCaptureLog()
		end
		return
	end
	if msg == "dispellog clear" then
		if ns.ClearDispelCaptureLog then
			ns.ClearDispelCaptureLog()
		end
		return
	end

	-- /mh pullsummary [boss|popup] — toggle the per-pull tank summary (opt-in) or
	-- its boss-only / popup options.
	if msg == "pullsummary status" then
		if ns.PrintTankPullSummaryStatus then
			ns.PrintTankPullSummaryStatus()
		end
		return
	end
	if msg == "pullsummary" then
		if ns.ToggleTankPullSummary then
			ns.ToggleTankPullSummary()
		end
		return
	end
	if msg == "pullsummary boss" then
		if ns.ToggleTankPullSummaryBossOnly then
			ns.ToggleTankPullSummaryBossOnly()
		end
		return
	end
	if msg == "pullsummary popup" then
		if ns.ToggleTankPullSummaryPopup then
			ns.ToggleTankPullSummaryPopup()
		end
		return
	end

	-- /mh bagarrows — toggle the green upgrade arrows on bag items.
	if msg == "bagarrows" then
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		if ns.ToggleBagUpgradeArrows then
			local on = ns.ToggleBagUpgradeArrows()
			print(("%s bag upgrade arrows: %s"):format(prefix, on and "on" or "off"))
		end
		return
	end

	-- /mh scorecard test — print a sample scorecard (see the format without a delve).
	if msg == "scorecard test" then
		if ns.TestRunScorecard then
			ns.TestRunScorecard()
		end
		return
	end

	-- /mh scorecard detail — toggle the die-hard detail line (exact seconds delta).
	if msg == "scorecard detail" then
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		if ns.ToggleScorecardDetail then
			local on = ns.ToggleScorecardDetail()
			print(("%s scorecard detail line: %s"):format(prefix, on and "on" or "off"))
		end
		return
	end

	-- /mh scorecard — toggle the post-run delve/ritual summary line.
	if msg == "scorecard" then
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		if ns.ToggleRunScorecard then
			local on = ns.ToggleRunScorecard()
			print(("%s post-run scorecard: %s"):format(prefix, on and "on" or "off"))
		end
		return
	end

	-- /mh arrowsize [N] — resize the standalone route arrow (also in Settings > General).
	if msg == "arrowsize" or msg:match("^arrowsize%s+") then
		local n = tonumber(msg:match("^arrowsize%s+(%d+)$"))
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		if n and ns.SetNativeArrowSize then
			local applied = ns.SetNativeArrowSize(n)
			if ns.PreviewNativeArrow then
				ns.PreviewNativeArrow(4)
			end
			print(("%s route arrow size = %d"):format(prefix, math.floor((tonumber(applied) or n) + 0.5)))
		else
			local cur = (ns.GetNativeArrowSize and ns.GetNativeArrowSize()) or "?"
			local b = ns.NativeArrowSizeBounds or { min = 28, max = 160 }
			print(("%s /mh arrowsize <%d-%d> (now %s)"):format(prefix, b.min, b.max, tostring(cur)))
			if ns.PreviewNativeArrow then
				ns.PreviewNativeArrow(4)
			end
		end
		return
	end

	-- /mh mark — toggle the Fast Mark bar (raid target + world markers).
	if msg == "mark" or msg == "fastmark" then
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		if ns.ToggleFastMark then
			local on = ns.ToggleFastMark()
			print(("%s Fast Mark: %s"):format(prefix, on and "on" or "off"))
		end
		return
	end

	-- /mh clear (aliases: clearroute, stop) — wipe the active route + arrow.
	if msg == "clear" or msg == "clearroute" or msg == "stop" then
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		local had = ns.ClearActiveRoute and ns.ClearActiveRoute()
		local m = ns:L("ROUTE_CLEARED")
		if not m or m == "ROUTE_CLEARED" then
			m = had and "Route cleared." or "No active route to clear."
		elseif not had then
			local none = ns:L("ROUTE_CLEAR_NONE")
			if none and none ~= "ROUTE_CLEAR_NONE" then
				m = none
			end
		end
		print(("%s %s"):format(prefix, m))
		return
	end

	-- /mh resetdebug — one-shot snapshot of the weekly/reset route state (diagnostics).
	if msg == "resetdebug" then
		if ns.ResetRouteDebug then
			ns.ResetRouteDebug()
		else
			print(("|cffffcc00%s|r reset debug unavailable."):format(ns:L("PRINT_PREFIX")))
		end
		return
	end

	if msg == "lang" then
		DEFAULT_CHAT_FRAME:AddMessage(
			("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("LANG_SLASH_HINT"))
		)
		return
	end

	local langArg = msg:match("^lang%s+(.+)$")
	if langArg then
		if not ns:NormalizeLocaleInput(langArg) then
			local bad = langArg
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("LANG_UNKNOWN"):format(bad))
			)
			return
		end
		ns:SetLocale(langArg)
		return
	end

	if msg == "guide" then
		if ns._mhGuidePrintLayout then
			ns._mhGuidePrintLayout()
		else
			print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("GUIDE_MODULE_NOT_LOADED")))
		end
		return
	end

	-- /mh questscan [filter] — print questID + title for every quest in the log
	-- (optioneel gefilterd op titel). Handig om quest-IDs te dumpen bij resets.
	if msg == "questscan" or msg:match("^questscan%s+") then
		local filter = msg:match("^questscan%s+(.+)$")
		filter = filter and filter:lower() or nil
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		if not (C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo) then
			print(prefix .. " questscan: quest API unavailable.")
			return
		end
		local n = C_QuestLog.GetNumQuestLogEntries() or 0
		local count = 0
		for i = 1, n do
			local q = C_QuestLog.GetInfo(i)
			if q and not q.isHeader and q.questID then
				local title = q.title or "?"
				if not filter or title:lower():find(filter, 1, true) then
					print(("%s  |cff00ff00%d|r  %s"):format(prefix, q.questID, title))
					count = count + 1
				end
			end
		end
		print(("%s questscan: %d quest(s)%s."):format(prefix, count, filter and (" matching '" .. filter .. "'") or ""))
		return
	end

	if msg == "capture" or msg == "coord" or msg == "rarecapture" then
		-- Dev/verify-hulpje: print een pasteable rare-regel (mapID + coords +
		-- target-npcID) in het ns.RARE_ZONES-formaat { questId, mapID, x, y, name, npcId }.
		-- Handig om HandyNotes-coords in-game te spot-checken of roamers vast te leggen.
		local prefix = ns:L("PRINT_PREFIX")
		local mapID, x, y
		pcall(function()
			mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
			if mapID and C_Map.GetPlayerMapPosition then
				local pos = C_Map.GetPlayerMapPosition(mapID, "player")
				if pos and pos.x then
					x, y = pos.x * 100, pos.y * 100
				end
			end
		end)
		local name, npcId
		if UnitExists("target") then
			name = UnitName("target")
			local guid = UnitGUID("target")
			if guid and not (issecretvalue and issecretvalue(guid)) then
				local unitType, _, _, _, _, id = strsplit("-", guid)
				if (unitType == "Creature" or unitType == "Vehicle") and id then
					npcId = tonumber(id)
				end
			end
		end
		if mapID and x and y then
			print(("|cffffcc00%s|r capture → { 0, %d, %.2f, %.2f, %q, %d },"):format(
				prefix, mapID, x, y, name or "?", npcId or 0))
			if not npcId then
				print(("|cffffcc00%s|r  (target de rare voor z'n npcID; questId 0 vul ik aan)"):format(prefix))
			end
		else
			print(("|cffffcc00%s|r capture: geen positie beschikbaar (sta je in een zone met kaart?)."):format(prefix))
		end
		return
	end

	if msg == "settings" then
		-- Settings live now in the native Blizzard Settings panel (Escape >
		-- Options > AddOns > Midnight Helper). Open straight to it; fall back to
		-- the in-addon launcher tab if the native API isn't available.
		if ns.OpenNativeSettings and ns.OpenNativeSettings() then
			return
		end
		if ns.ShowMainUI then
			ns:ShowMainUI()
		end
		if ns.SelectTab then
			ns.SelectTab("settings")
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("UI_LOADING"))
			)
		end
		return
	end

	if msg == "codex" or msg == "wiki" or msg == "handbook" then
		if ns.OpenMidnightCodex then
			if ns.OpenMidnightCodex() then
				DEFAULT_CHAT_FRAME:AddMessage(
					("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("CODEX_SEARCH_OPENED"))
				)
			end
		elseif ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("codex")
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("CODEX_SEARCH_OPENED"))
			)
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("UI_LOADING"))
			)
		end
		return
	end

	if msg == "coach" or msg == "delve" or msg == "delves" then
		if ns.ToggleDelveCoach then
			local shown = ns:ToggleDelveCoach()
			local key = shown and "DELVE_COACH_SLASH_OPEN" or "DELVE_COACH_SLASH_CLOSED"
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L(key))
			)
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("UI_LOADING"))
			)
		end
		return
	end

	if msg == "curiodebug" then
		if ns.DebugCompanionRole then
			ns.DebugCompanionRole()
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("UI_LOADING"))
			)
		end
		return
	end

	if msg == "curio" or msg == "curios" then
		if ns.ToggleDelveCuriosPopup then
			ns:ToggleDelveCuriosPopup()
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("UI_LOADING"))
			)
		end
		return
	end

	if msg == "toast" or msg == "toast test" or msg == "toast bounty" then
		if ns.PreviewDelveBountyToast then
			ns:PreviewDelveBountyToast()
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("UI_LOADING"))
			)
		end
		return
	end

	if msg == "changelog" then
		if ns.ShowChangelogWindow then
			ns:ShowChangelogWindow(true)
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("UI_LOADING"))
			)
		end
		return
	end

	if msg == "framesize" or msg == "size" then
		if ns.EnsureMainUI then
			ns:EnsureMainUI()
		end
		if ns.SaveMainWindowSize then
			ns:SaveMainWindowSize()
		end
		if ns.PrintMainWindowSize then
			ns:PrintMainWindowSize()
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("UI_LOADING"))
			)
		end
		return
	end

	if msg == "rarescan" then
		if ns.DebugRareScan then
			ns.DebugRareScan()
		else
			print("|cffffcc00Midnight Helper:|r rare scan not loaded")
		end
		return
	end

	if msg == "raretest" then
		if ns.TestRareAlert then
			ns.TestRareAlert()
		else
			print("|cffffcc00Midnight Helper:|r rare alert not loaded")
		end
		return
	end

	if msg == "shardtest" then
		if ns.TestShardCapAlert then
			ns.TestShardCapAlert()
		else
			print("|cffffcc00Midnight Helper:|r shard alert not loaded")
		end
		return
	end

	if msg == "bossshare" then
		if ns.ShareDungeonBossTips then
			ns.ShareDungeonBossTips()
		else
			print("|cffffcc00Midnight Helper:|r live coach not loaded")
		end
		return
	end

	if msg == "livetips" then
		if ns.ToggleDungeonLiveTips then
			ns.ToggleDungeonLiveTips()
		else
			print("|cffffcc00Midnight Helper:|r live coach not loaded")
		end
		return
	end

	-- /mh moxie — have the game name each Artisan's Moxie currency id, so the
	-- placeholder ids in Config can be confirmed or corrected instead of trusted.
	-- /mh crests — laat het spel elke crest-tier beschrijven, zodat bron-teksten
	-- gemeten worden in plaats van verzonnen (zelfde idee als /mh moxie).
	-- /mh kp — scheidt leesbare wekelijkse Knowledge van niet-leesbare.
	-- /mh nodes — laat het spel elke node in je professiebomen benoemen.
	if msg == "nodes" then
		if ns.PrintProfessionNodeProbe then ns.PrintProfessionNodeProbe() end
		return
	end

	if msg == "kp" then
		if ns.PrintKnowledgeProbe then ns.PrintKnowledgeProbe() end
		return
	end

	-- /mh crestscan — loop de hele currency-lijst af en toon elke "crest".
	-- /mh crestfind [van] [tot] — scan currency-ids en laat het spel elke crest benoemen.
	if msg == "crestfind" or msg:match("^crestfind ") then
		local f, to = msg:match("^crestfind (%d+) (%d+)$")
		if ns.PrintCrestFind then ns.PrintCrestFind(tonumber(f), tonumber(to)) end
		return
	end

	if msg == "crestscan" then
		if ns.PrintCrestScan then ns.PrintCrestScan() end
		return
	end

	if msg == "crests" then
		if ns.PrintCrestProbe then ns.PrintCrestProbe() end
		return
	end

	if msg == "moxie" then
		if ns.PrintMoxieProbe then
			ns.PrintMoxieProbe()
		end
		return
	end

	if msg == "bosswin why" or msg == "bosswin diag" then
		if ns.PrintBossWindowDiag then
			ns.PrintBossWindowDiag()
		else
			print("|cffffcc00Midnight Helper:|r boss window not loaded")
		end
		return
	end

	if msg == "bosswin" then
		if ns.ToggleDungeonBossWindow then
			ns.ToggleDungeonBossWindow()
		else
			print("|cffffcc00Midnight Helper:|r boss window not loaded")
		end
		return
	end

	-- Undocumented on purpose: the CurseForge gallery rig (Modules/DevShots.lua).
	if msg == "shots" then
		if ns.RunDevShots then
			ns.RunDevShots()
		else
			print("|cffffcc00Midnight Helper:|r screenshot rig not loaded")
		end
		return
	end

	if msg == "ritualboss" then
		if ns.ToggleRitualBossWindow then
			ns.ToggleRitualBossWindow()
		else
			print("|cffffcc00Midnight Helper:|r ritual boss coach not loaded")
		end
		return
	end

	if msg == "ritualspy" then
		if ns.DumpRitualBossSpy then
			ns.DumpRitualBossSpy()
		else
			print("|cffffcc00Midnight Helper:|r ritual boss coach not loaded")
		end
		return
	end

	if msg == "eventspy" then
		if ns.EventSchedulerSpyDump then
			ns.EventSchedulerSpyDump()
		else
			print("|cffffcc00Midnight Helper:|r event scheduler not loaded")
		end
		return
	end

	if msg == "enchants" or msg == "enchant" then
		if ns.PrintGearEnchantCheck then
			ns.PrintGearEnchantCheck()
		end
		return
	end

	if msg == "readycheck" or msg == "ready" or msg == "consready" then
		if ns.PrintConsumableReadyCheck then
			ns.PrintConsumableReadyCheck()
		end
		return
	end

	if msg == "readytoggle" then
		if ns.ToggleConsumableReadyCheck then
			ns.ToggleConsumableReadyCheck()
		end
		return
	end

	if msg == "auradump" then
		if ns.PrintPlayerAuraDump then
			ns.PrintPlayerAuraDump()
		end
		return
	end

	if msg == "readytest" then
		if ns.ConsumableReadyTest then
			ns.ConsumableReadyTest()
		end
		return
	end

	if msg == "readyboard" or msg == "board" then
		if ns.ShowConsumableBoard then
			ns.ShowConsumableBoard()
		end
		return
	end

	if msg == "boardall" or msg == "readyall" then
		if ns.BroadcastReopenBoard then
			ns.BroadcastReopenBoard()
		end
		return
	end

	-- /mh model <item-link | itemID | npc <id>> — roteerbare 3D-model-preview.
	local modelArg = msg:match("^model%s+(.+)$")
	if msg == "model" or modelArg then
		local arg = modelArg or ""
		local npcId = arg:match("^npc%s+(%d+)$")
		local itemId = arg:match("item:(%d+)") or arg:match("^(%d+)$")
		if npcId and ns.PreviewCreature then
			ns.PreviewCreature(tonumber(npcId))
		elseif itemId and ns.PreviewItem then
			ns.PreviewItem(tonumber(itemId))
		else
			print("|cffffcc00Midnight Helper:|r /mh model [item-link] · /mh model <itemID> · /mh model npc <npcID>  (shift-klik een item in de chatregel)")
		end
		return
	end

	if msg == "debug" then
		-- Toggle debug mode
		if ns.db and ns.db.ui then
			ns.db.ui.debug = not ns.db.ui.debug
		end
		local stateKey = (ns.db and ns.db.ui and ns.db.ui.debug) and "DEBUG_STATE_ON" or "DEBUG_STATE_OFF"
		print(
			("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("DEBUG_MODE"):format(ns:L(stateKey)))
		)

		-- Dump current state
		print("  ns.panels:       " .. (ns.panels and "ok" or "NIL"))
		print("  ns.DelvesFrame:  " .. (ns.DelvesFrame and "ok" or "NIL"))
		print("  ns.ProfessionFrame: " .. (ns.ProfessionFrame and "ok" or "NIL"))
		print("  ns.mainUI:       " .. (ns.mainUI and "ok" or "NIL"))
		print("  ns.db:           " .. (ns.db and "ok" or "NIL"))
		print("  uiSelectedTab:   " .. tostring(ns.uiSelectedTab))
		return
	end

	if msg ~= "" then
		DEFAULT_CHAT_FRAME:AddMessage(
			("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("UNKNOWN_COMMAND"):format(msg))
		)
		return
	end

	if ns.ToggleMainWindow then
		ns:ToggleMainWindow()
	else
		DEFAULT_CHAT_FRAME:AddMessage(
			("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("UI_LOADING"))
		)
	end
end
