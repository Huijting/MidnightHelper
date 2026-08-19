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

--------------------------------------------------------------------------------
-- Secret values: one shared pair, because six copies were not enough
--------------------------------------------------------------------------------
--- ⚠️ THE HELPER EXISTED SIX TIMES AND NONE OF THEM WAS REACHABLE.
---
--- `IsSecretValue` is defined as a file-local in DaggerspineCoach, DelveBossShowcase,
--- DelveCuriosAdvisor, DelveItemsPopup, DungeonBossWindow and RitualBossCoach. All six
--- are correct. None is exported, so a new module has nothing to call — and on 18 aug
--- SpotLog hand-rolled a seventh check, got it wrong, and threw on Rob's first target
--- that returned a secret name (the Timeworn Golem).
---
--- ⚠️ `type(x) == "string"` IS TRUE FOR A SECRET STRING. That is the trap, and it is
--- the same one that broke a probe on 16 aug. A type check does not protect a read;
--- only asking whether the value is secret does, BEFORE anything indexes it.
---
--- Declared here at the top of Core so every module loaded after it can use these
--- instead of writing a seventh. The six file-locals still stand and can migrate at
--- leisure; the point is that the NEXT module has something to reach for.
function ns.IsSecretValue(value)
	return issecretvalue ~= nil and value ~= nil and issecretvalue(value) == true
end

--- True only when `value` is a string this addon may actually read.
function ns.CanAccessText(value)
	if value == nil or ns.IsSecretValue(value) then
		return false
	end
	if canaccessvalue and not canaccessvalue(value) then
		return false
	end
	return type(value) == "string"
end

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
	-- The translate nudge caches how complete the active pack is; that answer is
	-- about a different pack now. The settings page says the addon adapts straight
	-- away, so the card has to as well rather than waiting for a reload.
	if ns.ResetTranslateCoverage then
		ns.ResetTranslateCoverage()
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

	-- /mh atal [van] [tot] — Vaults of Atal'Utek: questketen, currency, uiMapID en het
	-- gossip-venster. Capture-commando, geen feature; niets is erop gebouwd.
	if msg == "atal" or msg:match("^atal ") then
		local from, to = msg:match("^atal (%d+) (%d+)$")
		if ns.PrintAtalUtekProbe then
			ns.PrintAtalUtekProbe(tonumber(from), tonumber(to))
		end
		return
	end

	-- /mh rarequests — onze gemeten quest-band naast die van HandyNotes, per rare.
	-- Beslist welke van de twee "deze week gedaan" betekent.
	if msg == "rarequests" then
		if ns.PrintRareQuestProbe then
			ns.PrintRareQuestProbe()
		end
		return
	end

	-- /mh aurainst — kan de 12.1 per-instance route onderscheiden tussen "afwezig" en
	-- "verborgen"? Apart commando, want de uitvoer is te lang naast /mh auras.
	if msg == "aurainst" then
		if ns.PrintAuraInstanceProbe then
			ns.PrintAuraInstanceProbe()
		end
		return
	end

	-- /mh ej [instanceID] — lees de hele bossenlijst uit de Encounter Journal, zonder
	-- te pullen. Voor krappe PTR-testvensters waarin /mh encounters te traag is.
	-- /mh roleset [save|hide] — 12.1 Roleset-verkenning. Vraagt wat de client HEEFT;
	-- gokt geen API-namen, want dan is "niets gevonden" dubbelzinnig.
	if msg == "roleset save" then
		if ns.SaveRolesetProbe then ns.SaveRolesetProbe() end
		return
	end
	if msg == "roleset hide" then
		if ns.HideRolesetTestFrame then ns.HideRolesetTestFrame() end
		return
	end
	if msg == "roleset" then
		if ns.PrintRolesetProbe then ns.PrintRolesetProbe() end
		return
	end

	-- /mh dispel — wat kun je nú van jezelf wegnemen? Eigen debuffs alleen:
	-- die van anderen kunnen in 12.x secret zijn en zijn nog niet gemeten.
	if msg == "dispel alert" then
		if ns.ToggleDispelAlert then
			local on = ns.ToggleDispelAlert()
			print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"),
				ns:L(on and "DISPEL_ALERT_ON" or "DISPEL_ALERT_OFF")))
		end
		return
	end

	-- /mh dispel probe — werkt de opzoek-route wél in gevecht waar opsommen faalt?
	if msg == "dispel probe" then
		if ns.PrintDispelProbeSelf then
			ns.PrintDispelProbeSelf()
		end
		return
	end

	if msg == "dispel" then
		if ns.PrintDispelStatus then
			ns.PrintDispelStatus()
		end
		return
	end

	-- /mh prey — voortgang in de Prey-hunts, live uit de achievements gelezen.
	if msg == "prey" then
		if ns.PrintPreyProgress then
			ns.PrintPreyProgress()
		end
		return
	end

	-- /mh zone — wat weet MH van de zone waar je staat? Op patchdag is dit de
	-- eerste stap in een nieuwe zone: mapID meten in plaats van dataminen.
	if msg == "zone" then
		if ns.PrintZoneReport then
			ns.PrintZoneReport()
		end
		return
	end

	-- /mh delvescan [save] — welke delves biedt de client vandaag echt aan?
	if msg == "delvescan save" then
		if ns.SaveDelveScan then
			ns.SaveDelveScan()
		end
		return
	end
	if msg == "delvescan" then
		if ns.PrintDelveScan then
			ns.PrintDelveScan()
		end
		return
	end

	-- /mh ej save — parkeer de hele vangst in SavedVariables i.p.v. in de chat.
	if msg == "ej save" or msg == "ej all save" then
		if ns.SaveEncounterJournalCapture then
			ns.SaveEncounterJournalCapture()
		end
		return
	end

	if msg == "ej" or msg:match("^ej%s+%d+") or msg:match("^ej%s+all") then
		local ejID, ejDiff = msg:match("^ej%s+(%d+)%s+(%d+)$")
		if not ejID then
			ejID, ejDiff = msg:match("^ej%s+(all)%s+(%d+)$")
		end
		if not ejID then
			ejID = msg:match("^ej%s+(%d+)$") or msg:match("^ej%s+(all)$")
		end
		if ns.PrintEncounterJournalDump then
			ns.PrintEncounterJournalDump(ejID, ejDiff)
		end
		return
	end

	-- /mh flightpins — wat de vliegkaart aanbood toen hij het laatst open stond.
	if msg == "flightpins" then
		if ns.PrintFlightPins then
			ns.PrintFlightPins()
		end
		return
	end

	-- /mh mount <tekst> — mount-id opzoeken op naam. Opzoekgereedschap, net als /mh ach.
	if msg:match("^mount%s+") then
		if ns.PrintMountFind then
			ns.PrintMountFind(msg:match("^mount%s+(.+)$") or "")
		end
		return
	end

	-- /mh curios — wat elke curio-keuze van je companion doet, in de taal van het spel.
	if msg == "curios" or msg == "curio" then
		if ns.ShowCurioExplain then
			ns.ShowCurioExplain()
		end
		return
	end

	-- /mh npc <id> [id …] — vraag de client hoe een npc-id heet. Voor ids uit gidsen die
	-- we niet kunnen verifiëren zolang de GUID van het doelwit secret is.
	if msg == "npc" or msg:match("^npc%s") then
		if ns.LookupNpcIDs then
			ns.LookupNpcIDs(msg:match("^npc%s+(.+)$"))
		end
		return
	end

	-- /mh skip — sla de rare/route-halte over waar de pijl nu op staat en ga door naar de
	-- volgende. Bestond al als keybind-functie en dus alleen voor wie er een toets aan
	-- gebonden had; Rob vloog 19 aug over een rare heen, wilde verder, en kreeg onze pijl
	-- terug zodra TomTom zijn waypoint bij aankomst wiste. Dat is bedoeld gedrag — een
	-- rare-route blijft staan tot de rare dood is — maar er moet een manier zijn om nee te
	-- zeggen die je kunt vinden zonder de keybind-lijst door te lezen.
	if msg == "skip" then
		if MidnightHelper_KeybindSkipNode then
			MidnightHelper_KeybindSkipNode()
		end
		return
	end

	-- /mh item <id> [id …] — vraag de client hoe een item-id heet. Voor de kits en
	-- spellthreads van de been-enchants; item-info is async, dus hij wacht even.
	if msg == "item" or msg:match("^item%s") then
		if ns.LookupItemIDs then
			ns.LookupItemIDs(msg:match("^item%s+(.+)$"))
		end
		return
	end

	-- /mh spell <id> [id …] — vraag de client hoe een spell-id heet. Zusje van /mh npc,
	-- voor enchant- en spell-id's uit gidsen die we niet op hun woord geloven.
	if msg == "spell" or msg:match("^spell%s") then
		if ns.LookupSpellIDs then
			ns.LookupSpellIDs(msg:match("^spell%s+(.+)$"))
		end
		return
	end

	-- /mh quest — id + titel van het questvenster dat nu openstaat. Zelfde logboek als
	-- `/mh here`, want allebei zijn het "iets wat ik al spelend tegenkwam".
	if msg == "quest" then
		if ns.LogQuestHere then
			ns.LogQuestHere()
		end
		return
	end

	-- /mh portals — welke portalen wij voor dit personage bruikbaar achten, mét reden.
	-- Het reisplan gebruikt ze al vóór het vliegen aanraadt; dit maakt zichtbaar waarom.
	if msg == "portals" or msg == "portal" then
		if ns.PrintPortalAccess then
			ns.PrintPortalAccess()
		end
		return
	end

	-- /mh socket — kan een addon het socket-venster nog openen in 12.1? Cisca wist niet
	-- hoe je een gem erin krijgt en wij leggen het nergens uit; dit bepaalt of het een
	-- knop wordt of een uitleg-tekst.
	if msg == "socket" then
		if ns.ProbeSocketUI then
			ns.ProbeSocketUI()
		end
		return
	end

	-- /mh rarehint — waarom je de aankomst-regel wel of niet hoort. Deze hint is twee keer
	-- stil mislukt; "ik zie niks" onderscheidt zes oorzaken niet van elkaar.
	if msg == "rarehint" then
		if ns.PrintRareHintState then
			ns.PrintRareHintState()
		end
		return
	end

	-- /mh crest [tier] [stash] — momentopname van al je currency, en daarna het verschil.
	-- Meet wat een delve echt uitbetaalt in plaats van erover te redeneren; het argument
	-- "tier 8-11 is identiek" ging over gear en heeft crests nooit bekeken.
	if msg == "crest" or msg:match("^crest%s") then
		if ns.CrestProbe then
			ns.CrestProbe(msg:match("^crest%s+(.+)$"))
		end
		return
	end

	-- /mh here [notitie] — schrijf op waar je staat (en wat je aanklikt). Lijst, geen
	-- slot: een rondje lopen en daarna één reload is het hele idee.
	if msg == "here" or msg:match("^here%s+") then
		local arg = msg:match("^here%s+(.+)$")
		if arg == "clear" then
			if ns.ClearSpotLog then ns.ClearSpotLog() end
		elseif ns.LogSpotHere then
			ns.LogSpotHere(arg)
		end
		return
	end

	-- /mh plan — de hele route naar het huidige doel, stap voor stap en klikbaar.
	if msg == "plan" or msg == "route" then
		if ns.PrintTravelPlan then
			local t = ns.lastTarget
			if t and t.mapID then
				ns.PrintTravelPlan(t.mapID, t.x, t.y, t.name)
			else
				print(("|cffffcc00%s|r %s"):format(
					ns:L("PRINT_PREFIX"), ns:L("PLAN_NO_TARGET")))
			end
		end
		return
	end

	-- ⚠️ /mh brace IS WEG (18 aug), en dit is de reden, zodat niemand hem opnieuw bouwt.
	-- De prompt moest waarschuwen voor een cast die je niet kunt onderbreken. 12.1 laat
	-- dat niet toe: het spell-id is secret (13 casts, 13x secret), het npc-id van een
	-- delve-mob ook (16 aug, Gnarldor), en het samplen van alle twaalf returns van
	-- UnitCastingInfo gaf naam, tekst, icoon EN begin-/eindtijd allemaal secret — dus
	-- zelfs de cast-duur is geen kenmerk meer. Er blijft niets over om casts uit elkaar
	-- te houden. Wat er nog kon (de engine de alpha laten zetten) sprak over ELKE
	-- niet-kickbare cast en dus ook de hele fight door op een baas.
	--
	-- Rob heeft hem er 18 aug uit laten halen: te veel tijd voor te weinig, en de mob
	-- staat alleen in de hogere tiers. De kennis staat nu in de Delve Coach bij The Ring
	-- of Glory, waar je hem toch al opent.

	-- /mh keys — de vier Altar of Corrosion-nodes die achter een zoektocht zitten.
	if msg == "keys" or msg == "codexkeys" then
		if ns.ShowCorrosiveKeyHunts then
			ns.ShowCorrosiveKeyHunts()
		end
		return
	end

	-- /mh hazards — wat je hier vermijdbare schade doet, voor waar je nú staat.
	-- `check` legt élk id in het bestand aan de client voor, met twee controles.
	if msg == "hazards check" or msg == "hazard check" then
		if ns.CheckHazardIDs then
			ns.CheckHazardIDs()
		end
		return
	end
	if msg == "hazards" or msg == "hazard" then
		if ns.ShowHazards then
			ns.ShowHazards()
		end
		return
	end

	-- /mh mech — noemen GTFO's 71 mechanic-ids iets op deze client? Twee controles.
	if msg == "mech" or msg == "mechanics" then
		if ns.ProbeMechanicNames then
			ns.ProbeMechanicNames()
		end
		return
	end

	-- /mh binds — jouw eigen keybinds, uit de client, om te printen of te leren.
	if msg == "binds" or msg == "keybinds" then
		if ns.ShowKeybindExport then
			ns.ShowKeybindExport()
		end
		return
	end

	-- /mh ach <tekst> — zoek een achievement-ID op naam. Alleen een opzoekgereedschap:
	-- de addon zelf mag nooit op naam matchen (namen zijn gelokaliseerd).
	if msg:match("^ach%s+") or msg == "ach" then
		-- /mh ach id <n> [n ...] bewijst wat gevonden achievements écht vragen.
		-- Meerdere tegelijk, want kandidaten komen per groepje: op 26 juli moesten er
		-- drie Prey-achievements uitgeplozen worden en dat is één commando waard.
		-- /mh ach check — hold every shipped hunt against the client at once.
		if msg == "ach check" then
			if ns.PrintAchievementDataCheck then
				ns.PrintAchievementDataCheck()
			end
			return
		end
		local detailIDs = msg:match("^ach%s+id%s+([%d%s]+)$")
		if detailIDs then
			if ns.PrintAchievementDetail then
				for one in detailIDs:gmatch("%d+") do
					ns.PrintAchievementDetail(tonumber(one))
				end
			end
			return
		end
		if ns.PrintAchievementFind then
			ns.PrintAchievementFind(msg:match("^ach%s+(.+)$") or "")
		end
		return
	end

	-- /mh trail — meet wat FarstriderLib (indien geïnstalleerd) als reisroute teruggeeft
	-- naar het huidige pijl-doel. Puur diagnose: verandert niets aan de travel assist.
	if msg == "trail" then
		if ns.PrintFarstriderProbe then
			ns.PrintFarstriderProbe()
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
	-- /mh milestones preview — laat het kaartje zien zonder iets uit te reiken.
	if msg == "milestones preview" then
		if ns.PreviewMilestoneToast then ns.PreviewMilestoneToast() end
		return
	end

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

	-- /mh goto <x> <y> — drop the game's waypoint on a spot in the zone you are in.
	--
	-- Built 6 Aug for the Coiled Isle hunt: eight rares were measured off the PTR
	-- with coordinates, but the zone is not in MAP_TO_ZONE_KEY, so no route can
	-- claim the arrow and reading numbers off a map by hand is miserable.
	--
	-- Setting the game's waypoint is only half of it. The first version did just
	-- that, and Rob got the game's own pin ("1.5K yds") with no MH arrow at all —
	-- correct behaviour, because the arrow deliberately keys off `_mhRouteOwner`
	-- rather than off a waypoint existing, so that another addon's pin can never
	-- make us draw. A hand-typed destination has to claim ownership like any route.
	--
	-- It claims "waypoint", the single-destination owner that already exists in
	-- NativeArrow: no auto-advance, and the arrow releases itself once you are
	-- within ~20yd. That is exactly what a typed coordinate should do.
	do
		local gx, gy, gname = msg:match("^goto%s+([%d%.]+)%s+([%d%.]+)%s*(.*)$")
		if gx then
			local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
			local x, y = tonumber(gx), tonumber(gy)
			local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
			if not mapID or not x or not y or x <= 0 or y <= 0 or x > 100 or y > 100 then
				print(prefix .. " goto: give coordinates between 0 and 100, like /mh goto 47.0 62.2")
				return
			end
			if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(mapID, x, y)) then
				print(prefix .. " goto: could not set a waypoint there.")
				return
			end
			-- Name it, in this order: what you typed, then whatever of ours stands
			-- there, then the bare numbers. The arrow labels its target, and two
			-- floating numbers is the one label that tells you nothing you did not
			-- just type yourself.
			local label = gname
			if label == "" then
				label = nil
			end
			if not label and ns.GetRareNameNear then
				local okN, found = pcall(ns.GetRareNameNear, mapID, x, y)
				if okN then
					label = found
				end
			end
			label = label or ("%.1f, %.1f"):format(x, y)

			ns.lastTarget = { mapID = mapID, x = x, y = y, name = label }
			ns._mhRouteOwner = "waypoint"
			print(("%s arrow set to %s."):format(prefix, label))
			return
		end
	end

	-- /mh mouse <n> — how many thumb buttons you have. We cannot read the mouse, and a
	-- Naga's pad may send mouse buttons or number keys depending on its driver, so this
	-- is asked rather than assumed. It decides how many premium slots the keybind
	-- scheme may hand out before it falls back to a second modifier.
	-- /mh twins — ask the game which of the clashing spell pairs replace each other,
	-- instead of marking them by hand across six classes we do not play.
	if msg == "twins" then
		if ns.MH_TwinProbe then
			ns.MH_TwinProbe()
		end
		return
	end

	-- /mh bars — what is on every action slot, and which binding commands this client
	-- knows. Measured, because slot numbering and binding names differ per bar addon.
	if msg == "setup" then
		if ns.MH_ShowLayoutWizard then
			ns.MH_ShowLayoutWizard()
		end
		return
	end

	if msg == "bars plan" then
		if ns.MH_ShowBarPlan then
			ns.MH_ShowBarPlan()
		end
		return
	end

	if msg == "bars" then
		if ns.MH_BarInventory then
			ns.MH_BarInventory()
		end
		return
	end

	-- /mh apply — set the keys the layout suggests. Bare = dry run, "go" = do it,
	-- "undo" = put every touched key back. Never in combat, never automatic.
	if msg == "apply" or msg == "apply go" or msg == "apply undo"
		or msg == "apply full" or msg == "apply full go" or msg == "apply reclaim"
		or msg == "apply clean" or msg == "apply clean go" then
		if ns.MH_ApplyLayout then
			-- The WHOLE remainder: "full go" is two words and one instruction.
			ns.MH_ApplyLayout(msg:match("^apply%s+(.+)$"))
		end
		return
	end

	-- /mh editmode — read how the bars are laid out, and keep the last few pictures.
	if msg == "editmode import" then
		if ns.MH_EditModeShowImport then
			ns.MH_EditModeShowImport()
		end
		return
	end

	-- /mh editmode preset [go] — apply the recommended bar layout.
	if msg == "editmode preset" or msg == "editmode preset go" then
		if ns.MH_ApplyBarPreset then
			ns.MH_ApplyBarPreset(msg:find("go", 1, true) ~= nil)
		end
		return
	end

	if msg == "editmode restore" then
		if ns.MH_EditModeRestore then
			ns.MH_EditModeRestore()
		end
		return
	end

	do
		local barsArg = msg:match("^editmode%s+bars%s+(.+)$")
		if barsArg then
			if ns.MH_EditModeApplyBars then
				ns.MH_EditModeApplyBars(barsArg)
			end
			return
		end
	end

	if msg == "editmode export" then
		if ns.MH_EditModeExport then
			ns.MH_EditModeExport()
		end
		return
	end

	if msg == "editmode" then
		if ns.MH_EditModeReport then
			ns.MH_EditModeReport()
		end
		return
	end

	-- /mh events — does this client know every event we register?
	if msg == "events" then
		if ns.MH_EventProbe then
			ns.MH_EventProbe()
		end
		return
	end

	-- /mh api12 — which 12.1 secret-safe helpers does this client actually have?
	if msg == "api12" then
		if ns.MH_Api12Probe then
			ns.MH_Api12Probe()
		end
		return
	end

	-- /mh delveexit — what could leave a delve? Ask from inside one.
	if msg == "delveexit" then
		if ns.MH_DelveExitScan then
			ns.MH_DelveExitScan()
		end
		return
	end

	-- /mh bar — show or hide the little quick bar.
	if msg == "bar" then
		if ns.MH_ToggleQuickBar then
			ns.MH_ToggleQuickBar()
		end
		return
	end

	-- /mh padkeys [go] — where the thumb-pad keys point, and put them on bar 8.
	if msg == "padkeys" then
		if ns.MH_PadKeysReport then
			ns.MH_PadKeysReport()
		end
		return
	end
	if msg == "padkeys go" then
		if ns.MH_PadKeysApply then
			ns.MH_PadKeysApply(true)
		end
		return
	end

	-- /mh potionkeys — which potion each bindable button points at, and its key.
	if msg == "potionkeys" then
		if ns.MH_PotionKeyReport then
			ns.MH_PotionKeyReport()
		end
		return
	end

	-- /mh fps — read out the graphics settings (reads only, changes nothing).
	if msg == "fps" then
		if ns.MH_ShowFpsPanel then
			ns.MH_ShowFpsPanel()
		end
		return
	end

	-- /mh worldboss — are the four world bosses still a thing in 12.1?
	if msg == "worldboss" or msg == "wb" then
		if ns.MH_WorldBossProbe then
			ns.MH_WorldBossProbe()
		end
		return
	end

	-- /mh anchor — move a role's key to one your hands already know.
	do
		local rest = msg:match("^anchor%s*(.*)$")
		if rest then
			if ns.MH_Anchor then
				ns.MH_Anchor(rest)
			end
			return
		end
	end

	-- /mh tips — the one-line note when you learn an ability the layout has a key for.
	if msg == "tips" then
		if ns.MH_ToggleGrowthTips then
			ns.MH_ToggleGrowthTips()
		end
		return
	end

	--- /mh sba — keep key 1 free for Blizzard's Assisted Combat button.
	---
	--- Opt-in, and only offered to players who actually have the assistant:
	--- `C_AssistedCombat.IsAvailable` answers that, so nobody gets a switch that does
	--- nothing for them. The assistant covers your rotation, not your cooldowns,
	--- defensives or utility — so only `1` is reserved and 2/3/4/5 stay filled as a
	--- manual override. Shift+1 is untouched; it is a different press and on Frost it
	--- carries the AoE twin.
	if msg == "sba" then
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		local id = ns.Keybind_AssistantSpellID and ns.Keybind_AssistantSpellID()
		if not id then
			print(prefix .. " |cffff9900This character has no Assisted Combat button.|r")
			print("   |cff9d9d9dKey 1 already belongs to your rotation here. Nothing to switch.|r")
			return
		end
		ns.db = ns.db or {}
		ns.db.sbaForce = not ns.db.sbaForce
		ns.db.sbaOff = not ns.db.sbaForce
		if ns.db.sbaOff then
			print(prefix .. " key |cffffffff1|r goes back to your rotation.")
			print("   |cff9d9d9dIf you put the assistant on a bar, MH spots it and frees that key anyway.|r")
		else
			local name = (C_Spell and C_Spell.GetSpellName and select(1, pcall(C_Spell.GetSpellName, id))) and
				C_Spell.GetSpellName(id) or "Assisted Combat"
			print((prefix .. " assistant on — |cffffffff%s|r goes on key |cffffffff1|r."):format(tostring(name)))
		end
		print("   |cff9d9d9d/reload, then /mh apply to see it.|r")
		return
	end

	-- /mh mouse fill — let the layout use the thumb buttons as overflow again.
	if msg == "mouse fill" then
		ns.db = ns.db or {}
		ns.db.mouseOverflow = not ns.db.mouseOverflow
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		if ns.db.mouseOverflow then
			print(prefix .. " the layout may use your mouse buttons for abilities that fit nowhere else.")
		else
			print(prefix .. " your mouse buttons are yours — the layout only uses one if you |cffffffff/mh anchor|r something to it.")
		end
		print("   |cff9d9d9d/reload, then /mh apply.|r")
		return
	end

	-- /mh mouse detect — ask the button instead of asking the player.
	if msg == "mouse detect" then
		if ns.StartMouseDetect then
			ns.StartMouseDetect()
		end
		return
	end

	do
		local mn = msg:match("^mouse%s+(%d+)$")
		if mn or msg == "mouse" then
			ns.db = ns.db or {}
			local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
			if mn then
				local n = math.max(0, math.min(tonumber(mn) or 0, 6))
				ns.db.mouseButtonCount = n
				print(("%s thumb buttons: %d. The keybind scheme will use them before a second modifier."):format(prefix, n))
				print("   |cff9d9d9dRun |cffffffff/mhautomap|r to see the new layout.|r")
			else
				print(("%s thumb buttons: %d (set with |cffffffff/mh mouse 6|r, 0-6)."):format(
					prefix, tonumber(ns.db.mouseButtonCount) or 2))
			end
			return
		end
	end

	-- /mh bonusroll — record what Blizzard's bonus-roll popup actually is. Rob met one
	-- after a delve on live and we have no idea what it is; guessing would be worse.
	if msg == "bonusroll" or msg == "bonusroll clear" then
		if ns.HandleBonusRollCapture then
			ns.HandleBonusRollCapture(msg:match("^bonusroll%s+(%S+)"))
		end
		return
	end

	-- /mh questdiff — find the hidden kill-quest behind a rare, by diffing which
	-- quests count as completed before and after a fight.
	if msg == "questdiff" or msg == "questdiff clear" or msg == "questdiff now"
		or msg == "questdiff probe" or msg:match("^questdiff%s+check%s+%d+$") then
		if ns.HandleQuestDiff then
			-- The WHOLE remainder, not the first word: "check 97227" needs its number.
			ns.HandleQuestDiff(msg:match("^questdiff%s+(.+)$"))
		end
		return
	end

	-- /mh vignettes — record every rare vignette you fly past, to SavedVariables.
	if msg == "vignettes" or msg == "vignettes clear" then
		if ns.HandleVignetteCapture then
			ns.HandleVignetteCapture(msg:match("^vignettes%s+(%S+)"))
		end
		return
	end

	-- /mh arrow — why is the route arrow not guiding? Prints who is driving and
	-- whether a route ever handed us a target.
	if msg == "arrow" or msg == "arrow yield" then
		if msg == "arrow yield" then
			if ns.ToggleArrowYield then
				ns.ToggleArrowYield()
			end
			return
		end
		if ns.PrintArrowStatus then
			ns.PrintArrowStatus()
		end
		return
	end

	-- /mh survival — record why a spell is or is not on the survival card.
	if msg == "survival" then
		if ns.SaveSurvivalProbe then
			ns.SaveSurvivalProbe()
		end
		return
	end

	-- /mh prompt — the on-screen "what do I press": your interrupt when the target
	-- casts something interruptible, your dispel when it carries something removable.
	-- Hear it without changing the setting. Cycling round to the mode you already had
	-- just to test it is three keystrokes and two settings you did not want.
	if msg == "prompt sound test" then
		if ns.PreviewActionPromptSound then
			ns.PreviewActionPromptSound()
			local mode = (ns.db and ns.db.actionPromptSound) or "off"
			print(("|cffffcc00%s|r prompt sound test — mode: %s"):format(ns:L("PRINT_PREFIX"), tostring(mode)))
		end
		return
	end

	if msg == "prompt sound" then
		if ns.ToggleActionPromptSound then
			ns.ToggleActionPromptSound()
		end
		return
	end

	if msg == "prompt" then
		if ns.ToggleActionPrompt then
			ns.ToggleActionPrompt()
		end
		return
	end

	-- /mh kicks — interrupt scorecard: your landed/wasted this run. "alert" toggles the
	-- personal pre-12.1 whiff nudge; "reset" clears the tally (Spec 14).
	-- Match any argument rather than a hardcoded list. The list said
	-- kicks/alert/reset, so `/mh kicks who` answered "unknown command" the moment it
	-- was added — the handler had it, the router did not. Routing on the verb and
	-- letting the handler decide keeps those two from drifting apart again.
	if msg == "kicks" or msg:match("^kicks%s+%S+$") then
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
	if msg == "death reset" then
		if ns.ResetDeathRecapBlocks then ns.ResetDeathRecapBlocks() end
		-- Ask for the registration again straight away. Forgetting the refusal but
		-- waiting for the next zone change means someone standing in the dungeon
		-- they want to retest has to walk out and back in to find out.
		if ns.UpdateDeathRecapClog then ns.UpdateDeathRecapClog() end
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

	-- /mh tier — every tier-related call, wherever you are standing. Built to settle
	-- why 27 ritual runs all logged tier 0.
	-- `save [label]` appends a full snapshot: stand at the obelisk, pick each tier
	-- in turn and save one per selection, then /reload and the whole set is readable
	-- from the file. Six labelled records show which field means "this one".
	if msg == "tier" then
		if ns.PrintTierProbe then
			ns.PrintTierProbe()
		end
		return
	end
	if msg == "tier clear" then
		if ns.ClearTierProbe then
			ns.ClearTierProbe()
		end
		return
	end
	if msg == "tier save" or msg:match("^tier save ") then
		if ns.SaveTierProbe then
			ns.SaveTierProbe(msg:match("^tier save%s+(.+)$"))
		end
		return
	end

	-- /mh partytargets [probe] — the panel, or the readability measurement behind it.
	--
	-- These were `partytargets` and `partytarget`, one letter apart, doing entirely
	-- different things. Rob asked which was which within the hour, which is the only
	-- evidence such a pair ever needs. One command with a subcommand instead; the old
	-- singular still works so anything written down tonight keeps working.
	if msg == "partytargets" then
		if ns.TogglePartyTargets then
			ns.TogglePartyTargets()
		end
		return
	end
	if msg == "partytargets probe" or msg == "partytarget" then
		if ns.PrintPartyTargetProbe then
			ns.PrintPartyTargetProbe()
		end
		return
	end

	-- /mh showdown — which Showdown weekly is really in your log, and do we know
	-- its id? The Heroic variant may be a separate quest we do not track.
	if msg == "showdown" then
		if ns.PrintShowdownDiagnostics then
			ns.PrintShowdownDiagnostics()
		end
		return
	end

	-- /mh profweekly — why step 5 of the reset routine did or did not route you
	-- to a profession weekly. Four of its branches produce no route at all.
	if msg == "profweekly" then
		if ns.PrintProfWeeklyDiagnostics then
			ns.PrintProfWeeklyDiagnostics()
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

	-- /mh finditem <tekst> — zoek items in je tassen op naamfragment en print hun
	-- itemID. Dev/verify-hulpje voor captures: anders dan currencies zijn item-ids
	-- NIET blind te sweepen (GetItemInfo geeft nil voor alles wat niet in je cache
	-- zit), dus het item moet je echt bezitten. Bedoeld voor o.a. de S2-curios.
	if msg == "finditem" or msg:match("^finditem ") then
		local needle = msg:match("^finditem%s+(.+)$")
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		if not (C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerItemInfo) then
			print(prefix .. " container API not available")
			return
		end
		if needle then
			needle = needle:lower()
		end
		print(("%s Bag scan%s:"):format(prefix, needle and (" for \"" .. needle .. "\"") or " (everything)"))
		local hits, shown = 0, 0
		for bag = 0, 5 do
			local okSlots, numSlots = pcall(C_Container.GetContainerNumSlots, bag)
			if okSlots and type(numSlots) == "number" and numSlots > 0 then
				for slot = 1, numSlots do
					local okInfo, info = pcall(C_Container.GetContainerItemInfo, bag, slot)
					if okInfo and type(info) == "table" and info.itemID then
						-- Naam uit de hyperlink: die is geladen zodra het item in je tas ligt,
						-- dus geen wachten op een async GetItemInfo.
						local link = info.hyperlink
						local name = link and link:match("%[(.-)%]") or "?"
						if (not needle) or name:lower():find(needle, 1, true) then
							hits = hits + 1
							if shown < 40 then
								shown = shown + 1
								print(("   |cff40c040%-34s|r id %-7s %s"):format(name, tostring(info.itemID), link or ""))
							end
						end
					end
				end
			end
		end
		if hits == 0 then
			print("   |cffff8080nothing in your bags matched|r — you have to own the item; item ids cannot be scanned blind.")
		elseif hits > shown then
			print(("   ... and %d more (narrow the search)"):format(hits - shown))
		end
		return
	end

	-- Anything after the word is kept as a label ("/mh capture kist op gebroken brug"),
	-- because a coordinate without a note is unreadable a day later.
	ns._mhCaptureNote = msg:match("^capture%s+(.+)$") or msg:match("^coord%s+(.+)$")
	if msg == "capture" or msg == "coord" or msg == "rarecapture" or ns._mhCaptureNote then
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
			-- A hostile name is secret in 12.x, and a secret string still passes
			-- type() — the %q below would throw on it, and since captures are stored
			-- now it would also land in SavedVariables. Same trap that hit QuestDiff.
			local nOk, n = pcall(UnitName, "target")
			if nOk and type(n) == "string" and not (issecretvalue and issecretvalue(n)) then
				name = n
			end
			local guid = UnitGUID("target")
			if guid and not (issecretvalue and issecretvalue(guid)) then
				local unitType, _, _, _, _, id = strsplit("-", guid)
				if (unitType == "Creature" or unitType == "Vehicle") and id then
					npcId = tonumber(id)
				end
			end
		end
		if mapID and x and y then
			-- Also KEEP it. The printed line has to be copied out of chat, which is
			-- exactly the thing Rob cannot do while playing — he stands on the spot,
			-- reads numbers back over voice, and they get transcribed wrong. Writing
			-- it to SavedVariables means a lap can be captured spot by spot and read
			-- out of the file afterwards, the same way the vignette recorder works.
			ns.db = ns.db or {}
			if type(ns.db.captures) ~= "table" then
				ns.db.captures = {}
			end
			if #ns.db.captures < 200 then
				ns.db.captures[#ns.db.captures + 1] = {
					mapID = mapID,
					x = math.floor(x * 100 + 0.5) / 100,
					y = math.floor(y * 100 + 0.5) / 100,
					name = name,
					npcID = npcId,
					note = ns._mhCaptureNote,
				}
			end
			print(("|cffffcc00%s|r capture → { 0, %d, %.2f, %.2f, %q, %d },  (#%d opgeslagen)"):format(
				prefix, mapID, x, y, name or "?", npcId or 0, #ns.db.captures))
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

	-- /mh valeera — benoem elke node in de trait-tree van je delve-companion.
	-- /mh poisons — Valeera's poison-keuze met de omschrijving die de client geeft.
	if msg == "poisons" or msg == "poison" then
		if ns.PrintDelvePoisons then
			ns.PrintDelvePoisons()
		end
		return
	end

	-- /mh valeera save — lange lijst hoort in SavedVariables, niet in de chat.
	if msg == "valeera save" or msg == "companion save" then
		if ns.SaveCompanionTreeProbe then ns.SaveCompanionTreeProbe() end
		return
	end

	if msg == "valeera" or msg == "companion" then
		if ns.PrintCompanionTreeProbe then ns.PrintCompanionTreeProbe() end
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

	-- /mh crests [save] — per tier what the game says. `save` writes it to
	-- ns.db.crestProbe instead of chat: with the Season 2 ids in there this runs to
	-- roughly eighty lines, which is not something to read off a screenshot.
	if msg == "crests" or msg == "crests save" then
		if ns.PrintCrestProbe then ns.PrintCrestProbe(msg == "crests save") end
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
