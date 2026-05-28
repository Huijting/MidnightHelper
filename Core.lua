--[[
	MidnightHelper - Core.lua (load order: first)

	This file owns saved-variable initialization, a hidden event frame, and
	slash-command routing. The Blizzard client passes (addonName, ns) via ...
	to every TOC-loaded file; all modules share the same `ns` table.
]]

--------------------------------------------------------------------------------
-- Namespace: addonName + private addon table (ns), provided by the client.
--------------------------------------------------------------------------------
local addonName, ns = ...

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
	ui = {
		-- If true, the main window will be shown automatically after login.
		openOnLogin = false,
		debug = false,
		scale = 1.0,
		--- Legacy (ignored): alt snapshot lived in Delves; now a dedicated `account` tab.
		altOverviewExpanded = false,
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
		--- Sidebar beta tabs (Guide, Leveling Guides, Macros, Role Academy).
		betaTabs = {
			enabled = true,
			reference = true,
			guide = true,
			macros = true,
			academy = true,
		},
		--- Active world boss this week (account cache after any char detects it).
		worldBossWeek = {},
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
			point = "RIGHT",
			relPoint = "RIGHT",
			x = -36,
			y = 0,
		},
		--- Role Academy tab: "tank" | "heal" (see Modules/RoleAcademy.lua).
		roleAcademyTrack = "tank",
		roleAcademyPreflight = {
			tank = {},
			heal = {},
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
-- Saved variables: MidnightHelperDB (see MidnightHelper.toc)
--------------------------------------------------------------------------------
function ns:InitSavedVariables()
	if type(MidnightHelperDB) ~= "table" then
		MidnightHelperDB = {}
	end

	if not MidnightHelperDB.charCurrencies then
		MidnightHelperDB.charCurrencies = {}
	end

	MergeDefaults(MidnightHelperDB, DEFAULT_DB)
	self.db = MidnightHelperDB

	--- Legacy flag cleanup (accordion uses `ui.delvesAccordionSection`; do not force `"alt"`).
	if MidnightHelperDB.ui and MidnightHelperDB.ui.altOverviewExpanded == true then
		MidnightHelperDB.ui.altOverviewExpanded = false
	end

	--- Default Delves tab: Midnight Delves expanded, Account snapshot collapsed (drop persisted `"alt"`).
	if MidnightHelperDB.ui and MidnightHelperDB.ui.delvesAccordionSection == "alt" then
		MidnightHelperDB.ui.delvesAccordionSection = "midnight"
	end

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
-- Central event dispatcher
--------------------------------------------------------------------------------
function ns:OnEvent(event, ...)
	if event == "ADDON_LOADED" then
		local loadedAddon = ...
		if loadedAddon ~= addonName then
			return
		end

		self:InitSavedVariables()
		if self.MigrateLocalePreference then
			self:MigrateLocalePreference()
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
			if self.GetChatLocaleCode and self.GetEffectiveLocaleCode then
				local eff = self:GetEffectiveLocaleCode()
				local chat = self:GetChatLocaleCode()
				if chat ~= eff then
					self:PrintChatKey("LANG_SET_CHAT_FALLBACK")
				end
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(self:L("PRINT_PREFIX"), self:L("LANG_SET"):format(label))
			)
		end
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
	reference = true,
	guide = true,
	macros = true,
	academy = true,
}

function ns.GetBetaTabsSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { enabled = true, reference = true, guide = true, macros = true, academy = true }
	end
	if type(ui.betaTabs) ~= "table" then
		ui.betaTabs = { enabled = true, reference = true, guide = true, macros = true, academy = true }
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

SlashCmdList["MIDNIGHTHELPER"] = function(msg)
	msg = (msg or ""):gsub("^%s+", ""):gsub("%s+$", "")

	if ns.RunDelveItemsSlashCommand and ns:RunDelveItemsSlashCommand(msg) then
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

	if msg == "settings" then
		if ns.OpenSettingsPanel then
			ns:OpenSettingsPanel()
		elseif ns.ToggleQuickSettings then
			ns:ToggleQuickSettings(ns.mainUI)
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
