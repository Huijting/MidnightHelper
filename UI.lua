--[[
	MidnightHelper - UI.lua

	Builds the main shell: movable/resizable frame, Blizzard dialog-style chrome
	(gold border + stone tile, same family as Changelog), title bar, search row,
	sidebar tabs, and module host panels. Core.lua toggles visibility via ns:ToggleMainWindow.
]]

local addonName, ns = ...

--------------------------------------------------------------------------------
-- Layout constants (tweak in one place)
--------------------------------------------------------------------------------
-- Wider default so Professions tab can show two treasure columns side-by-side.
-- Default matches a typical user-tuned layout (795×600 at UI scale 1.25 fits Delves + Guide).
local DEFAULT_WIDTH = 795
local DEFAULT_HEIGHT = 600
-- Suggested minimum for first-time installs only; never overrides mainWindowUserSized.
local MIN_DELVES_WINDOW_H = 800
local SIDEBAR_WIDTH = 132
local TITLE_BAR_HEIGHT = 32
-- Global search bar (full width under title) — not in the narrow sidebar: keeps the field wide on all tabs.
local SEARCH_BAR_HEIGHT = 30
local RESIZE_GRIP_SIZE = 16
local MIN_WIDTH, MIN_HEIGHT = 620, 600
local MAX_WIDTH, MAX_HEIGHT = 1000, 920

local function ClampMainWidth(w)
	w = tonumber(w) or DEFAULT_WIDTH
	return math.max(MIN_WIDTH, math.min(MAX_WIDTH, w))
end

local function ClampMainHeight(h)
	h = tonumber(h) or DEFAULT_HEIGHT
	return math.max(MIN_HEIGHT, math.min(MAX_HEIGHT, h))
end

--- Prefer SavedVariables size; fall back to layout defaults.
local function GetSavedMainWidth()
	local ui = ns.db and ns.db.ui
	local w = ui and tonumber(ui.mainWidth)
	if w and w >= MIN_WIDTH then
		return ClampMainWidth(w)
	end
	return DEFAULT_WIDTH
end

local function GetSavedMainHeight()
	local ui = ns.db and ns.db.ui
	local h = ui and tonumber(ui.mainHeight)
	if h and h >= MIN_HEIGHT then
		return ClampMainHeight(h)
	end
	return DEFAULT_HEIGHT
end

--- One-time bump for pre-v3 saves that are too short for Delves; never shrink a user-resized window.
local function ResolveMainHeightForOpen()
	local ui = ns.db and ns.db.ui
	if not ui then
		return DEFAULT_HEIGHT
	end
	local h = GetSavedMainHeight()
	local ver = tonumber(ui.layoutVersion) or 0
	if ui.mainWindowUserSized and h >= MIN_HEIGHT then
		if ver < 3 then
			ui.layoutVersion = 3
		end
		return h
	end
	if ver < 3 and h < MIN_DELVES_WINDOW_H then
		h = DEFAULT_HEIGHT
		ui.mainHeight = h
		ui.layoutVersion = 3
	elseif ver < 3 then
		ui.layoutVersion = 3
	end
	return h
end

function ns:ApplySavedMainWindowSize()
	if not self.mainUI then
		return
	end
	local w = GetSavedMainWidth()
	local h = ResolveMainHeightForOpen()
	self.mainUI:SetSize(w, h)
end

local ABOUT_BTN_WIDTH = 110
local ABOUT_BTN_HEIGHT = 22
local ABOUT_BTN_BOTTOM_INSET = 10

-- Chrome: Blizzard dialog stone + gold frame (aligns with Changelog), warm tab tints.
local MH_TEX = {
	dialogBg = "Interface\\DialogFrame\\UI-DialogBox-Background",
	dialogBgDark = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
	goldEdge = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
}
--- Children stay inside this inset so they don't paint over the dialog gold corner ornaments.
local MH_MAIN_EDGE = { L = 12, R = 12, T = 12, B = 11 }
local MH_CHROME = {
	-- Fallbacks if a region still uses flat color.
	mainBg = { 0.09, 0.09, 0.11, 0.96 },
	outerEdge = { 0, 0, 0, 0.42 },
	-- Title strip: warm bronze over dialog art.
	titleStrip = { 0.2, 0.15, 0.1, 0.88 },
	sidebar = { 0.075, 0.076, 0.082, 0.96 },
	contentWell = { 0.048, 0.05, 0.062, 0.9 },
	-- Gold accent (sidebar | content, subnav rules).
	separator = { 0.78, 0.62, 0.32, 0.75 },
	separatorShadow = { 0, 0, 0, 0.4 },
	tabTexActive = { 0.98, 0.94, 0.82 },
	tabTexInactive = { 0.78, 0.72, 0.62 },
}

local function MHUnpack4(t)
	return t[1], t[2], t[3], t[4]
end

local function MHTintButtonTextures(btn, r, g, b)
	if not btn or not btn.GetRegions then
		return
	end
	for _, region in ipairs({ btn:GetRegions() }) do
		if region.GetObjectType and region:IsObjectType("Texture") and region.SetVertexColor then
			region:SetVertexColor(r, g, b)
		end
	end
end

local function MHRefreshSidebarTabChrome(activeId)
	if not ns.tabButtons then
		return
	end
	for id, btn in pairs(ns.tabButtons) do
		if id == activeId then
			btn:SetAlpha(1)
			MHTintButtonTextures(btn, MH_CHROME.tabTexActive[1], MH_CHROME.tabTexActive[2], MH_CHROME.tabTexActive[3])
		else
			btn:SetAlpha(0.9)
			MHTintButtonTextures(btn, MH_CHROME.tabTexInactive[1], MH_CHROME.tabTexInactive[2], MH_CHROME.tabTexInactive[3])
		end
	end
end

local function MHGetLayoutMetrics()
	local compact = ns.db and ns.db.settings and ns.db.settings.compactMode == true
	return {
		compact = compact,
		sidebarWidth = compact and 124 or SIDEBAR_WIDTH,
		sidebarTabHeight = compact and 24 or 28,
		sidebarTabStep = compact and 30 or 34,
		addonSubTabHeight = compact and 22 or 24,
		addonSubNavHeight = compact and 34 or 40,
		addonSubContentTopGap = compact and -4 or -6,
		aboutBtnHeight = compact and 20 or ABOUT_BTN_HEIGHT,
		aboutBtnWidth = compact and 104 or ABOUT_BTN_WIDTH,
		searchBarHeight = compact and 26 or SEARCH_BAR_HEIGHT,
		searchResetBtnWidth = compact and 94 or 108,
		searchGoBtnWidth = compact and 64 or 72,
		infoWindowWidth = compact and 236 or 268,
		infoWindowHeight = compact and 180 or 210,
	}
end

local function FitTitleBarButton(btn, minW, maxW)
	if not btn or not btn.GetFontString then
		return
	end
	local fs = btn:GetFontString()
	if not fs or not fs.GetStringWidth then
		return
	end
	minW = minW or 56
	maxW = maxW or 120
	local w = math.ceil((fs:GetStringWidth() or 0) + 14)
	btn:SetWidth(math.min(maxW, math.max(minW, w)))
end

local function FitSidebarTabButton(btn, sidebarWidth)
	if not btn or not btn.GetFontString then
		return
	end
	local fs = btn:GetFontString()
	if not fs or not fs.GetStringWidth then
		return
	end
	local maxW = (sidebarWidth or MHGetLayoutMetrics().sidebarWidth) - 16
	local textW = fs:GetStringWidth() or 0
	if textW + 24 > maxW and fs.SetFont then
		local font, size, flags = fs:GetFont()
		if font and size and size > 9 then
			fs:SetFont(font, size - 1, flags)
			textW = fs:GetStringWidth() or textW
		end
	end
	btn:SetWidth(maxW)
end

local MH_BETA_TAB_IDS = {
	reference = true,
	guide = true,
	macros = true,
	academy = true,
}

-- Sidebar is grouped into labelled sections (header + tabs). Tab ids whose
-- buttons do not exist yet (home, ritual) are skipped during layout, which
-- reserves their slot for later phases without breaking the current build.
local SIDEBAR_SECTIONS = {
	{ key = "week", titleKey = "SIDEBAR_SECTION_WEEK", ids = { "home", "delves", "rares", "ritual" } },
	{ key = "character", titleKey = "SIDEBAR_SECTION_CHARACTER", ids = { "account", "professions", "consumables" } },
	{ key = "guides", titleKey = "SIDEBAR_SECTION_GUIDES", ids = { "guide", "reference", "smcguide", "academy", "macros" } },
	{ key = "tools", titleKey = "SIDEBAR_SECTION_TOOLS", ids = { "addons" } },
}
local SIDEBAR_SECTION_GAP = 10
local SIDEBAR_HEADER_HEIGHT = 16

local function SidebarTabVisible(tabId)
	if tabId == "guide" then
		return ns.IsBetaTabEnabled and ns.IsBetaTabEnabled("guide")
	end
	if MH_BETA_TAB_IDS[tabId] then
		return ns.IsBetaTabEnabled and ns.IsBetaTabEnabled(tabId)
	end
	return true
end

local function MHAttachTabBetaBadge(btn, tabId)
	if not btn or not MH_BETA_TAB_IDS[tabId] then
		return
	end
	if not btn._mhBetaBadge then
		local badge = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		badge:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -3, -1)
		badge:SetTextColor(1, 0.72, 0.15)
		btn._mhBetaBadge = badge
		btn:HookScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(ns:L("TAB_BETA_TOOLTIP_TITLE"), 1, 0.82, 0)
			GameTooltip:AddLine(ns:L("TAB_BETA_TOOLTIP_BODY"), 0.92, 0.92, 0.92, true)
			GameTooltip:Show()
		end)
		btn:HookScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end
	btn._mhBetaBadge:SetText(ns:L("TAB_BETA_BADGE"))
end

local function MHGetInfoBodyKeyForTab(tabId)
	if tabId == "delves" then
		return "INFO_DRAWER_BODY_DELVES"
	elseif tabId == "account" then
		return "INFO_DRAWER_BODY_ACCOUNT"
	elseif tabId == "rares" then
		return "INFO_DRAWER_BODY_RARES"
	elseif tabId == "smcguide" then
		return "INFO_DRAWER_BODY_SMC"
	elseif tabId == "professions" then
		return "INFO_DRAWER_BODY_PROFESSIONS"
	elseif tabId == "reference" then
		return "INFO_DRAWER_BODY_REFERENCE"
	elseif tabId == "guide" then
		return "INFO_DRAWER_BODY_GUIDE"
	elseif tabId == "macros" then
		return "INFO_DRAWER_BODY_MACROS"
	elseif tabId == "consumables" then
		return "INFO_DRAWER_BODY_CONSUMABLES"
	elseif tabId == "academy" then
		return "INFO_DRAWER_BODY_ACADEMY"
	elseif tabId == "addons" then
		return "INFO_DRAWER_BODY_ADDONS"
	end
	return "INFO_DRAWER_BODY_DELVES"
end

--- Apply ns:L() to the main shell (tabs, search row, SMC headers, side helpers). See Locales/*.lua.
function ns:RefreshLocaleUI()
	local r = self._mhLocaleRefs
	if not r then
		return
	end

	if r.title and r.title.SetText then
		r.title:SetText(self:L("MAIN_TITLE"))
	end
	if r.titleVersion and r.titleVersion.SetText then
		local ver = ns.GetAddonVersion and ns.GetAddonVersion() or "?"
		r.titleVersion:SetText(self:L("MAIN_TITLE_VERSION_FMT"):format(ver))
	end
	if r.searchHint and r.searchHint.SetText then
		r.searchHint:SetText(self:L("SEARCH_LABEL"))
	end
	if r.searchResetBtn and r.searchResetBtn.SetText then
		r.searchResetBtn:SetText(self:L("SEARCH_MY_CHARACTER"))
	end
	if r.searchGoBtn and r.searchGoBtn.SetText then
		r.searchGoBtn:SetText(self:L("SEARCH_GO"))
	end
	if r.aboutBtn and r.aboutBtn.SetText then
		r.aboutBtn:SetText(self:L("ABOUT_BUTTON"))
	end

	if r.tabKeys and self.tabButtons then
		for id, btn in pairs(self.tabButtons) do
			local key = r.tabKeys[id]
			if key and btn and btn.SetText then
				btn:SetText(self:EscapeButtonAmpersand(self:L(key)))
				FitSidebarTabButton(btn)
			end
		end
	end

	if r.smcHeader and r.smcHeader.SetText then
		r.smcHeader:SetText(self:L("SMC_GUIDE_TITLE"))
	end
	if r.smcSubtitle and r.smcSubtitle.SetText then
		r.smcSubtitle:SetText(self:L("SMC_GUIDE_SUBTITLE"))
	end

	local sg = self.panels and self.panels.smcguide
	local clRef = sg and sg._mhChecklistLocaleRefs
	if type(clRef) == "table" then
		if clRef.header and clRef.header.SetText then
			clRef.header:SetText(self:L("SMC_CHECKLIST_TITLE"))
		end
		if clRef.hint and clRef.hint.SetText then
			clRef.hint:SetText(self:L("SMC_CHECKLIST_HINT"))
		end
		local rows = clRef.rows
		if type(rows) == "table" then
			for i = 1, #rows do
				local row = rows[i]
				if row and row.titleFs and row.entry and row.entry.labelKey then
					row.titleFs:SetText(self:L(row.entry.labelKey))
				end
			end
		end
	end
	if ns.SMC_RefreshDynamicChecklist then
		ns.SMC_RefreshDynamicChecklist()
	end
	if ns.MH_RefreshRoleAcademyPanel and self.panels and self.panels.academy then
		ns.MH_RefreshRoleAcademyPanel(self.panels.academy)
	end

	if r.guideSubTabButtons then
		local bg = r.guideSubTabButtons.guide
		local bl = r.guideSubTabButtons.layout
		if bg and bg.SetText then
			bg:SetText(self:L("TAB_GUIDE_SUB_GUIDE"))
		end
		if bl and bl.SetText then
			bl:SetText(self:L("TAB_GUIDE_SUB_LAYOUT"))
		end
	end

	if self.uiSelectedTab == "guide" and self._mhGuideRefresh then
		self:_mhGuideRefresh()
	end
	local macroPanel = self.panels and self.panels.macros
	if macroPanel and macroPanel._mhRefreshMacros then
		macroPanel._mhRefreshMacros()
	end
	local consPanel = self.panels and self.panels.consumables
	if consPanel and consPanel._mhRefreshConsumables then
		consPanel._mhRefreshConsumables()
	end
	local layoutPanel = self._mhGuideLayoutPanel
	if layoutPanel and layoutPanel._mhProtoBuilt and ns.KeyboardLayoutPrototype_Refresh then
		ns.KeyboardLayoutPrototype_Refresh(layoutPanel)
	end
	if self._mhRefreshSidePanel then
		self:_mhRefreshSidePanel(self.uiSelectedTab or "delves")
	end
end

function ns:ApplyCompactMode()
	local refs = self._mhLayoutRefs
	if not refs or not refs.main then
		return
	end
	local m = MHGetLayoutMetrics()

	if refs.sidebar and refs.sidebar.SetWidth then
		refs.sidebar:SetWidth(m.sidebarWidth)
	end
	if refs.content then
		refs.content:ClearAllPoints()
		refs.content:SetPoint("TOPLEFT", refs.searchBar, "BOTTOMLEFT", m.sidebarWidth, 0)
		refs.content:SetPoint("BOTTOMRIGHT", refs.main, "BOTTOMRIGHT", -MH_MAIN_EDGE.R, MH_MAIN_EDGE.B)
	end
	if refs.searchResetBtn and refs.searchResetBtn.SetWidth then
		refs.searchResetBtn:SetWidth(m.searchResetBtnWidth)
	end
	if refs.searchGoBtn and refs.searchGoBtn.SetWidth then
		refs.searchGoBtn:SetWidth(m.searchGoBtnWidth)
	end
	if refs.searchBar and refs.searchBar.SetHeight then
		refs.searchBar:SetHeight(m.searchBarHeight)
	end
	if refs.aboutBtn and refs.aboutBtn.SetSize then
		refs.aboutBtn:SetSize(m.aboutBtnWidth, m.aboutBtnHeight)
	end
	if refs.addonsSubNav and refs.addonsSubNav.SetHeight then
		refs.addonsSubNav:SetHeight(m.addonSubNavHeight)
	end
	if refs.addonsSubContent then
		refs.addonsSubContent:ClearAllPoints()
		refs.addonsSubContent:SetPoint("TOPLEFT", refs.addonsSubNav, "BOTTOMLEFT", 0, m.addonSubContentTopGap)
		refs.addonsSubContent:SetPoint("BOTTOMRIGHT", refs.addonsPanel, "BOTTOMRIGHT", -8, 8)
	end
	if refs.infoWindow and refs.infoWindow.SetWidth then
		refs.infoWindow:SetWidth(m.infoWindowWidth)
		refs.infoWindow:SetHeight(m.infoWindowHeight)
	end
	if refs.reanchorInfoWindow then
		refs.reanchorInfoWindow()
	end
	if self.tabButtons then
		for _, btn in pairs(self.tabButtons) do
			if btn and btn.SetSize then
				btn:SetSize(m.sidebarWidth - 16, m.sidebarTabHeight)
			end
		end
	end
	if self.addonSubTabButtons then
		for _, btn in pairs(self.addonSubTabButtons) do
			if btn and btn.SetHeight then
				btn:SetHeight(m.addonSubTabHeight)
			end
		end
	end
	if self.guideSubTabButtons then
		for _, btn in pairs(self.guideSubTabButtons) do
			if btn and btn.SetHeight then
				btn:SetHeight(m.addonSubTabHeight)
			end
		end
	end
	local gp = refs.guidePanel
	if gp and gp._mhSubNav and gp._mhSubNav.SetHeight then
		gp._mhSubNav:SetHeight(m.addonSubNavHeight)
	end
	if gp and gp._mhSubNav and gp._mhSubContent then
		gp._mhSubContent:ClearAllPoints()
		gp._mhSubContent:SetPoint("TOPLEFT", gp._mhSubNav, "BOTTOMLEFT", 0, m.addonSubContentTopGap)
		gp._mhSubContent:SetPoint("BOTTOMRIGHT", gp, "BOTTOMRIGHT", -8, 8)
	end
	if self._mhRelayoutSidebarTabs then
		self._mhRelayoutSidebarTabs()
	end

	local scale = (self.db and self.db.ui and self.db.ui.scale) or 1
	if refs.main.SetScale then
		refs.main:SetScale(scale * (m.compact and 0.92 or 1))
	end
end

local function MHRefreshAddonSubTabChrome(activeSubId)
	if not ns.addonSubTabButtons then
		return
	end
	for id, btn in pairs(ns.addonSubTabButtons) do
		if id == activeSubId then
			btn:SetAlpha(1)
			MHTintButtonTextures(btn, MH_CHROME.tabTexActive[1], MH_CHROME.tabTexActive[2], MH_CHROME.tabTexActive[3])
		else
			btn:SetAlpha(0.88)
			MHTintButtonTextures(btn, MH_CHROME.tabTexInactive[1], MH_CHROME.tabTexInactive[2], MH_CHROME.tabTexInactive[3])
		end
	end
end

local function MHRefreshGuideSubTabChrome(activeSubId)
	if not ns.guideSubTabButtons then
		return
	end
	for id, btn in pairs(ns.guideSubTabButtons) do
		if id == activeSubId then
			btn:SetAlpha(1)
			MHTintButtonTextures(btn, MH_CHROME.tabTexActive[1], MH_CHROME.tabTexActive[2], MH_CHROME.tabTexActive[3])
		else
			btn:SetAlpha(0.88)
			MHTintButtonTextures(btn, MH_CHROME.tabTexInactive[1], MH_CHROME.tabTexInactive[2], MH_CHROME.tabTexInactive[3])
		end
	end
end

--------------------------------------------------------------------------------
-- SMC City Guide (Midnight 12.0.5)
--------------------------------------------------------------------------------
local SMC_CITY_MAP_ID = 2393

local SMC_CATEGORIES = {
	{
		title = "Essential Services",
		items = {
			{ id = "bank", label = "Bank & Vault", description = "Zet een waypoint naar de bank en Great Vault locatie in Silvermoon City.", atlas = "services-icon-bank", x = 49.93, y = 64.54 },
			{ id = "item_upgrades", label = "Cuzoth — Item Upgrades", description = "Zet een waypoint naar Cuzoth (item upgrades met Dawncrests). Bazaar, naast Vaskarn.", atlas = "ItemUpgrade-FX-UpgradeArrow", x = 48.23, y = 61.75 },
			{ id = "crest_exchange", label = "Vaskarn — Crest Exchange", description = "Zet een waypoint naar Vaskarn (Dawncrest exchange). Bazaar, naast Cuzoth.", atlas = "WarWithin-Icon-Crest", x = 48.28, y = 61.75 },
			{ id = "ah", label = "Auction House", description = "Zet een waypoint naar het Auction House.", atlas = "services-icon-auctioneer", x = 51.50, y = 74.68 },
			{ id = "mailbox", label = "Mailbox", description = "Zet een waypoint naar de mailbox in Silvermoon City.", atlas = "services-icon-mailroom", x = 49.41, y = 65.92 },
			{ id = "inn_cooking", label = "Inn & Cooking", description = "Zet een waypoint naar de inn en cooking voorzieningen.", atlas = "services-icon-innkeeper", x = 56.28, y = 70.33 },
			{ id = "trading_post", label = "Trading Post", description = "Zet een waypoint naar de Trading Post locatie.", atlas = "ui-delves", x = 48.88, y = 78.15 },
			{ id = "bmah", label = "BMAH", description = "Zet een waypoint naar het Black Market Auction House.", atlas = "services-icon-auctioneer", x = 51.86, y = 48.56 },
			{ id = "transmog", label = "Transmog", description = "Zet een waypoint naar Transmog en Void Storage.", atlas = "services-icon-transmogrifier", x = 52.87, y = 57.44 },
			{ id = "crafting_orders", label = "Crafting Orders (Mar'nah)", description = "Zet een waypoint naar crafting orders in de Bazaar (bijv. Mar'nah).", atlas = "services-icon-battlenet", x = 45.0, y = 55.6 },
			{ id = "creation_catalyst", label = "Creation Catalyst", description = "Zet een waypoint naar de Creation Catalyst in de Bazaar (neutral).", atlas = "creationcatalyst-32x32", x = 40.31, y = 64.85 },
		},
	},
	{
		title = "Travel",
		items = {
			{ id = "portals", label = "Portal Room", description = "Zet een waypoint naar de portal room.", atlas = "portal-horde-white", x = 53.37, y = 66.31 },
			{ id = "portal_voidstorm", label = "Portal to Voidstorm", description = "Zet een waypoint naar de portal naar Voidstorm.", atlas = "portal-horde-white", x = 35.25, y = 65.85 },
			{ id = "portal_harandar", label = "Portal to Harandar", description = "Zet een waypoint naar de portal naar Harandar.", atlas = "portal-horde-white", x = 36.76, y = 68.52 },
			{ id = "timeways", label = "Timeways (Lindormi)", description = "Zet een waypoint naar de Timeways-portal bij Lindormi.", atlas = "portal-horde-white", x = 42.30, y = 58.30 },
			{ id = "mplus_teleports", label = "M+ Teleports", description = "Zet een waypoint naar de M+ teleport locatie.", atlas = "flightmaster", x = 42.03, y = 58.30 },
		},
	},
	{
		title = "Quest Hubs",
		items = {
			{
				id = "world_boss_week",
				label = "World boss this week",
				description = "Open Delves & Vault and route to this week's world boss (TomTom + Travel Assistant when available).",
				atlas = "groupfinder-icon-flag",
				action = "worldboss_week",
				x = 48.95,
				y = 64.92,
			},
			{ id = "prey_hub", label = "Prey Hub", description = "Zet een waypoint naar de Prey-hub (in de inn, Adventure Guide / Prey).", atlas = "ui-delves", x = 56.19, y = 65.33 },
			{ id = "astalor", label = "Magister Astalor Bloodsworn", description = "Zet een waypoint naar Magister Astalor Bloodsworn (prey quest giver).", atlas = "services-icon-transmogrifier", x = 55.00, y = 63.40 },
			{ id = "weekly_hub", label = "Weekly Quest Givers", description = "Zet een waypoint naar Aethas, Liadrin en Halduron (weekly hub).", atlas = "services-icon-innkeeper", x = 48.95, y = 64.92 },
			{ id = "delves_hq", label = "Delves HQ", description = "Zet een waypoint naar het Delves-hoofdkwartier.", atlas = "ui-delves", x = 52.10, y = 77.70 },
			{ id = "valeera_delves", label = "Valeera Sanguinar (Delves)", description = "Zet een waypoint naar Valeera Sanguinar, Delves questgiver.", atlas = "ui-delves", x = 52.40, y = 78.20 },
			{ id = "training_dummies", label = "Training Dummies", description = "Zet een waypoint naar de training dummies in Silvermoon City.", atlas = "services-icon-dueling", x = 36.0, y = 84.2 },
			{ id = "pvp_hub", label = "PvP Hub", description = "Zet een waypoint naar de PvP-hub in Silvermoon City.", atlas = "pvpqueue-icon-honor", x = 34.40, y = 81.00 },
		},
	},
	{
		title = "Horde District (Horde only)",
		items = {
			{ id = "horde_inn", label = "Horde Inn", description = "Zet een waypoint naar de Horde-inn (Court of Blood, alleen Horde).", atlas = "services-icon-innkeeper", x = 66.91, y = 62.09 },
			{ id = "horde_bank", label = "Horde Bank & Vault", description = "Zet een waypoint naar bank en Great Vault in het Horde-gedeelte.", atlas = "services-icon-bank", x = 72.04, y = 64.87 },
			{ id = "horde_ah", label = "Horde Auction House", description = "Zet een waypoint naar het Auction House in het Horde-gedeelte.", atlas = "services-icon-auctioneer", x = 67.64, y = 70.74 },
			{ id = "horde_creation_catalyst", label = "Horde Creation Catalyst", description = "Zet een waypoint naar de Creation Catalyst in Court of Blood (alleen Horde).", atlas = "creationcatalyst-32x32", x = 70.06, y = 83.27 },
		},
	},
	{
		title = "Professions",
		items = {
			{ id = "alchemy", label = "Alchemy", description = "Zet een waypoint naar de Alchemy trainer.", atlas = "ui-profession-alchemy", x = 47.02, y = 51.88 },
			{ id = "blacksmithing", label = "Blacksmithing", description = "Zet een waypoint naar de Blacksmithing trainer.", atlas = "ui-profession-blacksmithing", x = 43.74, y = 51.33 },
			{ id = "enchanting", label = "Enchanting", description = "Zet een waypoint naar de Enchanting trainer.", atlas = "ui-profession-enchanting", x = 47.97, y = 53.63 },
			{ id = "engineering", label = "Engineering", description = "Zet een waypoint naar de Engineering trainer.", atlas = "ui-profession-engineering", x = 43.53, y = 54.01 },
			{ id = "inscription", label = "Inscription", description = "Zet een waypoint naar de Inscription trainer.", atlas = "ui-profession-inscription", x = 46.78, y = 51.48 },
			{ id = "jewelcrafting", label = "Jewelcrafting", description = "Zet een waypoint naar de Jewelcrafting trainer.", atlas = "ui-profession-jewelcrafting", x = 47.93, y = 55.15 },
			{ id = "leatherworking", label = "Leatherworking", description = "Zet een waypoint naar de Leatherworking trainer.", atlas = "ui-profession-leatherworking", x = 43.15, y = 55.70 },
			{ id = "tailoring", label = "Tailoring", description = "Zet een waypoint naar de Tailoring trainer.", atlas = "ui-profession-tailoring", x = 48.25, y = 54.15 },
		},
	},
	{
		title = "Gathering",
		items = {
			{ id = "fishing", label = "Fishing", description = "Zet een waypoint naar de Fishing-trainer / visplek in de Bazaar.", atlas = "ui-profession-fishing", x = 44.70, y = 60.20 },
			{ id = "herbalism_trainer", label = "Herbalism Trainer", description = "Zet een waypoint naar de Herbalism trainer.", atlas = "ui-profession-herbalism", x = 48.20, y = 51.52 },
			{ id = "mining_trainer", label = "Mining Trainer", description = "Zet een waypoint naar de Mining trainer.", atlas = "ui-profession-mining", x = 42.68, y = 52.84 },
			{ id = "skinning_trainer", label = "Skinning Trainer", description = "Zet een waypoint naar de Skinning trainer.", atlas = "ui-profession-skinning", x = 43.27, y = 55.59 },
		},
	},
}

-- Search helpers (Guide.lua): keyword blobs per waypoint + scroll target after panel build.
do
	local rows = {}
	for _, cat in ipairs(SMC_CATEGORIES) do
		for _, point in ipairs(cat.items or {}) do
			local blob = string.lower(
				string.format(
					"%s %s %s %s",
					tostring(cat.title or ""),
					tostring(point.label or ""),
					tostring(point.description or ""),
					tostring(point.id or "")
				)
			)
			rows[#rows + 1] = { blob = blob, point = point }
		end
	end
	ns._mhSMCGuideSearchRows = rows
end

local function TriggerTomTomWaySlash(point)
	if not C_AddOns then
		return false
	end

	if C_AddOns.IsAddOnLoaded and not C_AddOns.IsAddOnLoaded("TomTom") and C_AddOns.LoadAddOn then
		pcall(C_AddOns.LoadAddOn, "TomTom")
	end

	local slashWay = SlashCmdList and SlashCmdList["TOMTOM_WAY"]
	if type(slashWay) ~= "function" then
		return false
	end

	local mapID = SMC_CITY_MAP_ID
	local cmd = ("#%d %.2f %.2f %s"):format(mapID, point.x, point.y, point.label or "SMC")
	local ok = pcall(slashWay, cmd)
	return ok
end

local function SetSMCWaypoint(point)
	if type(point) ~= "table" then
		return
	end

	-- Non-map actions (pseudo rows in SMC list).
	if point.action == "worldboss_week" then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("delves")
		end
		if ns.RouteToActiveWorldBoss then
			ns.RouteToActiveWorldBoss()
		end
		return
	end

	local mapID = SMC_CITY_MAP_ID
	point.mapID = mapID

	local x = (tonumber(point.x) or 0) / 100
	local y = (tonumber(point.y) or 0) / 100
	if x <= 0 or y <= 0 then
		return
	end

	local mapPoint = nil
	if UiMapPoint and UiMapPoint.CreateFromCoordinates then
		local ok, created = pcall(UiMapPoint.CreateFromCoordinates, mapID, x, y)
		if ok and created then
			mapPoint = created
		end
	end

	if mapPoint and C_Map and C_Map.SetUserWaypoint then
		pcall(C_Map.SetUserWaypoint, mapPoint)
		if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
		end
	end

	TriggerTomTomWaySlash(point)
	print(
		("|cffffcc00%s|r %s"):format(
			ns:L("PRINT_PREFIX"),
			ns:L("WAYPOINT_SET"):format(point.label or "SMC", mapID, point.x or 0, point.y or 0)
		)
	)
end

function ns.GetSMCCityPin(pinId)
	if not pinId then
		return nil
	end
	for _, cat in ipairs(SMC_CATEGORIES) do
		for _, pt in ipairs(cat.items or {}) do
			if pt.id == pinId then
				return pt
			end
		end
	end
	return nil
end

function ns.SetSMCCityWaypoint(pinId)
	local pt = ns.GetSMCCityPin(pinId)
	if pt then
		SetSMCWaypoint(pt)
	end
end

function ns.OpenSMCCityGuidePin(pinId)
	if ns.EnsureMainUI then
		ns:EnsureMainUI()
	end
	if ns.SelectTab then
		ns.SelectTab("smcguide")
	end
	local pt = ns.GetSMCCityPin(pinId)
	if not pt then
		return
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0.08, function()
			if ns.JumpSMCCityGuideToPoint then
				ns.JumpSMCCityGuideToPoint(pt)
			end
		end)
	else
		ns.JumpSMCCityGuideToPoint(pt)
	end
end

-- Called from Guide search: open SMC tab and scroll the city list to a matching pin (no Delves.lua edits).
function ns.JumpSMCCityGuideToPoint(point)
	if type(point) ~= "table" then
		return
	end
	local panel = ns.panels and ns.panels.smcguide
	local scroll = panel and panel._mhSmlScroll
	if not scroll or not scroll.SetVerticalScroll then
		return
	end
	local maxV = 0
	if scroll.GetVerticalScrollRange then
		maxV = scroll:GetVerticalScrollRange() or 0
	end
	local y = tonumber(point._mhNavY)
	if not y or y < 0 then
		y = 0
	end
	local want = math.max(0, math.min(maxV, y - 28))
	scroll:SetVerticalScroll(want)
	if scroll.SetHorizontalScroll then
		scroll:SetHorizontalScroll(0)
	end
	if panel and panel._mhSmlSyncScroll then
		panel._mhSmlSyncScroll()
	end
	if scroll.UpdateScrollChildRect then
		scroll:UpdateScrollChildRect()
	end
	local btn = point._mhWaypointButton
	if btn and btn.LockHighlight then
		btn:LockHighlight()
		if C_Timer and C_Timer.After then
			C_Timer.After(1.6, function()
				if btn and btn.UnlockHighlight then
					btn:UnlockHighlight()
				end
			end)
		end
	end
end

-- Update the special \"World boss this week\" SMC shortcut label.
function ns.MH_RefreshSMCWorldBossShortcut()
	local sg = ns.panels and ns.panels.smcguide
	local list = sg and sg._mhSMCWaypointButtons
	if type(list) ~= "table" then
		return
	end

	local boss, fromClient = ns.GetActiveWorldBoss and ns.GetActiveWorldBoss()

	-- If we already know warband completion from SavedVariables, show the boss name even when
	-- Blizzard task/map APIs haven't loaded on this character yet.
	if (not fromClient) and ns.db and ns.db.ui and ns.db.ui.worldBossWeek and ns.db.ui.worldBossWeek.bossId and ns.WORLD_BOSSES then
		local wantId = ns.db.ui.worldBossWeek.bossId
		for i = 1, #ns.WORLD_BOSSES do
			local b = ns.WORLD_BOSSES[i]
			if b and b.id == wantId then
				boss = b
				break
			end
		end
	end

	local name = boss and boss.labelKey and ns.L and ns:L(boss.labelKey) or "?"
	local showName = fromClient or (ns.IsWorldBossKilled and boss and ns.IsWorldBossKilled(boss))
	local text = showName and ns:L("WB_SMC_BUTTON_FMT"):format(name) or ns:L("WB_SMC_BUTTON_GUESS")

	for i = 1, #list do
		local row = list[i]
		local btn = row and row[1]
		local pt = row and row[2]
		local label = btn and btn._mhSMCLabel
		if pt and pt.action == "worldboss_week" and label and label.SetText then
			label:SetText(text)
		end
	end
end

local function BuildSMCCityGuidePanel(panel)
	if not panel or panel._mhSmlBuilt then
		return
	end
	panel._mhSmlBuilt = true
	panel._mhSmlScroll = nil
	panel._mhSmlSyncScroll = nil

	if panel._header then
		panel._header:SetText(ns:L("SMC_GUIDE_TITLE"))
	end
	if panel._body then
		panel._body:Hide()
	end

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -34)
	subtitle:SetText(ns:L("SMC_GUIDE_SUBTITLE"))
	subtitle:SetTextColor(0.92, 0.85, 0.68)
	panel._mhSMCSubtitle = subtitle

	-- Host + guide-style chrome + Custom ScrollBar (mirrors `Addons/Guide.lua`):
	-- Never anchor the rail to the subtitle (too narrow) — that parks the bar mid-panel.
	local SMC_SCROLL_INSET = 2
	local SMC_SCROLL_BAR_GUTTER = 22
	local scrollHost = CreateFrame("Frame", "MidnightHelperSMCScrollHost", panel)
	scrollHost:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -10)
	scrollHost:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -12, 12)
	scrollHost:SetFrameLevel((panel:GetFrameLevel() or 0) + 8)

	-- Subtle "guide body" border around the whole viewport
	local smcRim = CreateFrame("Frame", nil, scrollHost, "BackdropTemplate")
	smcRim:SetAllPoints(scrollHost)
	smcRim:SetFrameStrata(scrollHost:GetFrameStrata())
	smcRim:SetFrameLevel(scrollHost:GetFrameLevel() + 1)
	if smcRim.SetBackdrop then
		smcRim:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 0, right = 0, top = 0, bottom = 0 },
		})
		smcRim:SetBackdropColor(0, 0, 0, 0)
		smcRim:SetBackdropBorderColor(MH_CHROME.separator[1], MH_CHROME.separator[2], MH_CHROME.separator[3], 0.5)
	end
	smcRim:EnableMouse(false)

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperSMCGuideScroll", scrollHost)
	panel._mhSmlScroll = scroll
	scroll:SetPoint("TOPLEFT", scrollHost, "TOPLEFT", SMC_SCROLL_INSET, -SMC_SCROLL_INSET)
	scroll:SetPoint("BOTTOMRIGHT", scrollHost, "BOTTOMRIGHT", -SMC_SCROLL_INSET - SMC_SCROLL_BAR_GUTTER, SMC_SCROLL_INSET)
	scroll:SetFrameLevel(scrollHost:GetFrameLevel() + 2)
	scroll:EnableMouse(true)
	scroll:EnableMouseWheel(true)
	local smcScrollFill = scroll:CreateTexture(nil, "BACKGROUND", nil, -8)
	smcScrollFill:SetAllPoints()
	smcScrollFill:SetColorTexture(0.04, 0.042, 0.055, 1)

	local smcBar = CreateFrame("Slider", "MidnightHelperSMCScrollBar", scrollHost)
	smcBar:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 2, 0)
	smcBar:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", 2, 0)
	smcBar:SetWidth(16)
	smcBar:SetOrientation("VERTICAL")
	smcBar:SetFrameLevel(scrollHost:GetFrameLevel() + 4)
	local smcBarBg = smcBar:CreateTexture(nil, "BACKGROUND")
	smcBarBg:SetAllPoints()
	smcBarBg:SetColorTexture(0.07, 0.07, 0.09, 0.88)
	local smcThumb = smcBar:CreateTexture(nil, "OVERLAY")
	smcThumb:SetSize(16, 28)
	smcThumb:SetColorTexture(0.72, 0.74, 0.78, 0.96)
	smcBar:SetThumbTexture(smcThumb)
	smcBar:SetValueStep(1)
	smcBar:SetObeyStepOnDrag(false)
	smcBar:SetScript("OnEnter", function()
		smcThumb:SetColorTexture(0.86, 0.88, 0.92, 1.0)
	end)
	smcBar:SetScript("OnLeave", function()
		smcThumb:SetColorTexture(0.72, 0.74, 0.78, 0.96)
	end)

	local smcScrollUp = CreateFrame("Button", nil, scrollHost)
	smcScrollUp:SetSize(20, 20)
	smcScrollUp:SetPoint("BOTTOM", smcBar, "TOP", 0, 4)
	smcScrollUp:SetFrameLevel(smcBar:GetFrameLevel() + 1)
	smcScrollUp:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
	smcScrollUp:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
	smcScrollUp:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight")

	local smcScrollDown = CreateFrame("Button", nil, scrollHost)
	smcScrollDown:SetSize(20, 20)
	smcScrollDown:SetPoint("TOP", smcBar, "BOTTOM", 0, -4)
	smcScrollDown:SetFrameLevel(smcBar:GetFrameLevel() + 1)
	smcScrollDown:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
	smcScrollDown:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
	smcScrollDown:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight")

	local scrollContent = CreateFrame("Frame", nil, scroll)
	scrollContent:SetSize(1, 1)
	scroll:SetScrollChild(scrollContent)

	local smcBarSyncing = false
	local function SyncSMCScrollBar()
		if not smcBar or not scroll or smcBarSyncing then
			return
		end
		if not smcBar.SetMinMaxValues or not smcBar.SetValue or not smcBar.Enable or not smcBar.Disable then
			return
		end
		smcBarSyncing = true
		local maxScroll = 0
		if scroll.GetVerticalScrollRange then
			maxScroll = scroll:GetVerticalScrollRange() or 0
		end
		if maxScroll < 0 then
			maxScroll = 0
		end
		smcBar:SetMinMaxValues(0, maxScroll)
		local cur = 0
		if scroll.GetVerticalScroll then
			cur = scroll:GetVerticalScroll() or 0
		end
		smcBar:SetValue(cur)
		if maxScroll <= 0.5 then
			smcBar:Disable()
			smcBar:SetAlpha(0.45)
			if smcScrollUp then
				smcScrollUp:Disable()
				smcScrollUp:SetAlpha(0.45)
			end
			if smcScrollDown then
				smcScrollDown:Disable()
				smcScrollDown:SetAlpha(0.45)
			end
		else
			smcBar:Enable()
			smcBar:SetAlpha(1)
			if smcScrollUp and smcScrollUp.Enable then
				smcScrollUp:Enable()
				smcScrollUp:SetAlpha(1)
			end
			if smcScrollDown and smcScrollDown.Enable then
				smcScrollDown:Enable()
				smcScrollDown:SetAlpha(1)
			end
		end
		smcBarSyncing = false
	end

	smcBar:SetScript("OnValueChanged", function(_, value)
		-- `SetValue` in SyncSMCScrollBar is programmatic; do not re-set scroll in that case.
		if smcBarSyncing or not scroll or not scroll.SetVerticalScroll then
			return
		end
		scroll:SetVerticalScroll(tonumber(value) or 0)
	end)
	scroll:SetScript("OnVerticalScroll", function()
		SyncSMCScrollBar()
	end)
	local scrollStep = (_G.WORLDWIDE_SCROLL_STEP and math.floor(_G.WORLDWIDE_SCROLL_STEP * 0.75)) or 30
	scroll:SetScript("OnMouseWheel", function(self, delta)
		if not self.GetVerticalScrollRange or not self.SetVerticalScroll or not self.GetVerticalScroll then
			return
		end
		local maxScroll = self:GetVerticalScrollRange() or 0
		if maxScroll <= 0 then
			return
		end
		local nextScroll = (self:GetVerticalScroll() or 0) - (delta * scrollStep)
		if nextScroll < 0 then
			nextScroll = 0
		elseif nextScroll > maxScroll then
			nextScroll = maxScroll
		end
		self:SetVerticalScroll(nextScroll)
		SyncSMCScrollBar()
	end)

	if smcScrollUp then
		smcScrollUp:SetScript("OnClick", function()
			if not scroll or not scroll.SetVerticalScroll or not scroll.GetVerticalScroll or not scroll.GetVerticalScrollRange then
				return
			end
			local maxV = scroll:GetVerticalScrollRange() or 0
			local v = (scroll:GetVerticalScroll() or 0) - scrollStep
			if v < 0 then
				v = 0
			elseif v > maxV then
				v = maxV
			end
			scroll:SetVerticalScroll(v)
			SyncSMCScrollBar()
		end)
	end
	if smcScrollDown then
		smcScrollDown:SetScript("OnClick", function()
			if not scroll or not scroll.SetVerticalScroll or not scroll.GetVerticalScroll or not scroll.GetVerticalScrollRange then
				return
			end
			local maxV = scroll:GetVerticalScrollRange() or 0
			local v = (scroll:GetVerticalScroll() or 0) + scrollStep
			if v < 0 then
				v = 0
			elseif v > maxV then
				v = maxV
			end
			scroll:SetVerticalScroll(v)
			SyncSMCScrollBar()
		end)
	end

	local BTN_H = 34
	local GAP_X, GAP_Y = 8, 6
	-- Match the ScrollFrame's inner width (inset L/R + right scrollbar gutter) using panel width.
	-- (scroll:GetWidth is often 0 the same frame it is created)
	local availableW = math.max(
		120,
		math.floor(
			(panel:GetWidth() or 640)
				- 24
				- 2 * SMC_SCROLL_INSET
				- SMC_SCROLL_BAR_GUTTER
		)
	)
	local cols = 3
	local btnW = math.max(100, math.floor((availableW - (cols - 1) * GAP_X) / cols))

	panel._mhSMCWaypointButtons = {}
	panel._mhSMCChecklistRows = {}

	-- top-down Y so we can set a real content height for scrolling
	local y = 0

	-- Dynamic checklist (quest IDs from Modules/SMCChecklistData.lua — verify after patches)
	do
		local defs = ns.SMC_CHECKLIST_DEF
		local anyTracked = false
		if type(defs) == "table" and ns.SMC_IsChecklistEntryTracked then
			for di = 1, #defs do
				local entry = defs[di]
				if entry and ns.SMC_IsChecklistEntryTracked(entry) then
					anyTracked = true
					break
				end
			end
		end
		if anyTracked then
			local clHeader = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
			clHeader:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, -y)
			clHeader:SetText(ns:L("SMC_CHECKLIST_TITLE"))
			clHeader:SetTextColor(MH_CHROME.tabTexActive[1], MH_CHROME.tabTexActive[2], MH_CHROME.tabTexActive[3])
			y = y + 22
			local clHint = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			clHint:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, -y)
			clHint:SetWidth(availableW)
			clHint:SetJustifyH("LEFT")
			clHint:SetText(ns:L("SMC_CHECKLIST_HINT"))
			clHint:SetTextColor(0.72, 0.74, 0.78)
			y = y + 38
			local rowsLocale = {}
			for _, entry in ipairs(defs) do
				if ns.SMC_IsChecklistEntryTracked(entry) then
					local titleFs = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
					titleFs:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, -y)
					titleFs:SetWidth(math.floor(availableW * 0.62))
					titleFs:SetJustifyH("LEFT")
					titleFs:SetText(ns:L(entry.labelKey))
					local statusFs = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
					statusFs:SetPoint("TOPRIGHT", scrollContent, "TOPRIGHT", 0, -y)
					statusFs:SetWidth(math.floor(availableW * 0.34))
					statusFs:SetJustifyH("RIGHT")
					local crow = { entry = entry, statusFs = statusFs, titleFs = titleFs }
					panel._mhSMCChecklistRows[#panel._mhSMCChecklistRows + 1] = crow
					rowsLocale[#rowsLocale + 1] = crow
					y = y + 18
				end
			end
			y = y + 10
			panel._mhChecklistLocaleRefs = {
				header = clHeader,
				hint = clHint,
				rows = rowsLocale,
			}
		end
	end

	for _, cat in ipairs(SMC_CATEGORIES) do
		local header = scrollContent:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
		header:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, -y)
		header:SetText(cat.title)
		header:SetTextColor(MH_CHROME.tabTexActive[1], MH_CHROME.tabTexActive[2], MH_CHROME.tabTexActive[3])
		y = y + 20

		local separator = scrollContent:CreateTexture(nil, "ARTWORK")
		separator:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, -y)
		separator:SetPoint("TOPRIGHT", scrollContent, "TOPRIGHT", 0, -y)
		separator:SetHeight(1)
		separator:SetColorTexture(MH_CHROME.separator[1], MH_CHROME.separator[2], MH_CHROME.separator[3], MH_CHROME.separator[4])
		y = y + 8

		local items = cat.items or {}
		for i, point in ipairs(items) do
			local btn = CreateFrame("Button", nil, scrollContent, "UIPanelButtonTemplate")
			btn:SetSize(btnW, BTN_H)
			btn:SetText("")

			local col = (i - 1) % cols
			local row = math.floor((i - 1) / cols)
			btn:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", col * (btnW + GAP_X), -y - row * (BTN_H + GAP_Y))

			local icon = btn:CreateTexture(nil, "ARTWORK")
			icon:SetSize(20, 20)
			icon:SetPoint("LEFT", btn, "LEFT", 8, 0)
			local iconSet = false
			if point.atlas and icon.SetAtlas then
				iconSet = select(1, pcall(icon.SetAtlas, icon, point.atlas))
			end
			if not iconSet then
				icon:SetTexture("Interface\\MINIMAP\\TRACKING\\Banker")
			end

			local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			label:SetPoint("LEFT", icon, "RIGHT", 8, 0)
			label:SetPoint("RIGHT", btn, "RIGHT", -8, 0)
			label:SetJustifyH("LEFT")
			if point.action == "worldboss_week" and ns.GetActiveWorldBoss then
				local boss, fromClient = ns.GetActiveWorldBoss()
				local name = boss and boss.labelKey and ns.L and ns:L(boss.labelKey) or "?"
				label:SetText(fromClient and ns:L("WB_SMC_BUTTON_FMT"):format(name) or ns:L("WB_SMC_BUTTON_GUESS"))
			else
				label:SetText(point.label)
			end
			label:SetTextColor(1, 0.94, 0.75)

			btn._mhSMCIcon = icon
			btn._mhSMCLabel = label
			panel._mhSMCWaypointButtons[#panel._mhSMCWaypointButtons + 1] = { btn, point }
			if ns.SMC_ApplyQuestTintToWaypointButton then
				ns.SMC_ApplyQuestTintToWaypointButton(btn, point)
			end

			point._mhNavY = y + row * (BTN_H + GAP_Y)
			point._mhWaypointButton = btn

			btn:SetScript("OnClick", function()
				SetSMCWaypoint(point)
			end)
			btn:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(point.label, 1, 0.9, 0.6)
				GameTooltip:AddLine(point.description, 0.9, 0.9, 0.9, true)
				GameTooltip:AddLine(("Map 2393 • %.2f, %.2f"):format(point.x, point.y), 0.8, 0.8, 0.8, false)
				GameTooltip:AddLine("Klik: native pin + /way #2393 (TomTom indien beschikbaar)", 0.7, 0.8, 1, true)
				GameTooltip:Show()
			end)
			btn:SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)
		end

		local rows = math.ceil((#items) / cols)
		if rows < 0 then
			rows = 0
		end
		y = y + rows * (BTN_H + GAP_Y) + 10
	end

	scrollContent:SetWidth(availableW)
	scrollContent:SetHeight(math.max(1, y + 8))
	if scroll.UpdateScrollChildRect then
		scroll:UpdateScrollChildRect()
	end
	if scroll.SetHorizontalScroll then
		scroll:SetHorizontalScroll(0)
	end
	scroll:SetVerticalScroll(0)
	SyncSMCScrollBar()
	panel._mhSmlSyncScroll = SyncSMCScrollBar
	if ns.SMC_RefreshDynamicChecklist then
		ns.SMC_RefreshDynamicChecklist()
	end
	if ns.MH_RefreshWorldBossSMCBlock then
		ns.MH_RefreshWorldBossSMCBlock()
	end
	if ns.MH_RefreshSMCWorldBossShortcut then
		ns.MH_RefreshSMCWorldBossShortcut()
	end
end

--------------------------------------------------------------------------------
-- Tab configuration: order = display order in the sidebar
--------------------------------------------------------------------------------
local TAB_DEFS = {
	{ id = "delves", labelKey = "TAB_DELVES" },
	{ id = "account", labelKey = "TAB_ACCOUNT_SNAPSHOT" },
	{ id = "rares", labelKey = "TAB_RARES" },
	{ id = "reference", labelKey = "TAB_REFERENCE" },
	{ id = "smcguide", labelKey = "TAB_SMC" },
	{ id = "professions", labelKey = "TAB_PROFESSIONS" },
	{ id = "guide", labelKey = "TAB_GUIDE" },
	{ id = "macros", labelKey = "TAB_MACROS" },
	{ id = "consumables", labelKey = "TAB_CONSUMABLES" },
	{ id = "academy", labelKey = "TAB_ACADEMY" },
	{ id = "addons", labelKey = "TAB_ADDONS" },
}

local TAB_LABEL_BY_ID = {}
for _, tab in ipairs(TAB_DEFS) do
	TAB_LABEL_BY_ID[tab.id] = tab.labelKey
end

--------------------------------------------------------------------------------
-- Internal Addons sub-tab registry (modules call ns.RegisterAddonSubTab at load)
--------------------------------------------------------------------------------
ns._mhAddonSubTabById = ns._mhAddonSubTabById or {}
ns._mhAddonSubTabOrder = ns._mhAddonSubTabOrder or {}

function ns.RegisterAddonSubTab(def)
	if type(def) ~= "table" or type(def.id) ~= "string" or type(def.label) ~= "string" then
		return
	end
	if type(def.Build) ~= "function" then
		return
	end
	if ns._mhAddonSubTabById[def.id] then
		return
	end
	ns._mhAddonSubTabById[def.id] = def
	tinsert(ns._mhAddonSubTabOrder, def.id)
end

--------------------------------------------------------------------------------
-- Forward declarations (filled in after main UI exists)
--------------------------------------------------------------------------------
local SelectTab
local SelectAddonSubTab
local RelayoutSidebarTabs

--------------------------------------------------------------------------------
-- Main shell: MidnightHelperMainUI
--------------------------------------------------------------------------------
function ns:EnsureMainUI()
	if self.mainUI then
		return self.mainUI
	end

	local main = CreateFrame("Frame", "MidnightHelperMainUI", UIParent, "BackdropTemplate")
	local initW = GetSavedMainWidth()
	local initH = ResolveMainHeightForOpen()
	main:SetSize(initW, initH)
	main:SetPoint("CENTER")
	main:SetFrameStrata("MEDIUM")
	main:SetFrameLevel(100)
	main:SetMovable(true)
	main:SetResizable(true)
	main:SetResizeBounds(MIN_WIDTH, MIN_HEIGHT, MAX_WIDTH, MAX_HEIGHT)
	main:SetClampedToScreen(true)
	main:EnableMouse(true)
	main:Hide()

	-- Main window closes with Escape like most addon windows.
	tinsert(UISpecialFrames, main:GetName())

	if main.SetBackdrop then
		main:SetBackdrop({
			bgFile = MH_TEX.dialogBg,
			edgeFile = MH_TEX.goldEdge,
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		main:SetBackdropColor(1, 1, 1, 0.94)
		main:SetBackdropBorderColor(1, 1, 1, 1)
	end

	-- Title strip (drag handle); moving is started from here so tabs stay easy to click.
	local titleBar = CreateFrame("Frame", nil, main)
	titleBar:SetHeight(TITLE_BAR_HEIGHT)
	titleBar:SetPoint("TOPLEFT", main, "TOPLEFT", MH_MAIN_EDGE.L, -MH_MAIN_EDGE.T)
	titleBar:SetPoint("TOPRIGHT", main, "TOPRIGHT", -MH_MAIN_EDGE.R, -MH_MAIN_EDGE.T)
	titleBar:EnableMouse(true)
	titleBar:RegisterForDrag("LeftButton")
	titleBar:SetScript("OnDragStart", function()
		main:StartMoving()
	end)
	titleBar:SetScript("OnDragStop", function()
		main:StopMovingOrSizing()
		if ns._mhLayoutRefs and ns._mhLayoutRefs.reanchorInfoWindow then
			ns._mhLayoutRefs.reanchorInfoWindow()
		end
	end)

	local titleHighlight = titleBar:CreateTexture(nil, "BACKGROUND")
	titleHighlight:SetAllPoints()
	titleHighlight:SetTexture(MH_TEX.dialogBgDark)
	if titleHighlight.SetHorizTile then
		titleHighlight:SetHorizTile(true)
	end
	if titleHighlight.SetVertTile then
		titleHighlight:SetVertTile(true)
	end
	titleHighlight:SetVertexColor(0.55, 0.45, 0.35, 0.9)

	local titleIcon = titleBar:CreateTexture(nil, "ARTWORK")
	titleIcon:SetSize(24, 24)
	titleIcon:SetTexture("Interface\\AddOns\\MidnightHelper\\Media\\Addon_Icon")
	titleIcon:SetPoint("TOPLEFT", titleBar, "TOPLEFT", 12, -(TITLE_BAR_HEIGHT - 24) / 2)

	-- Title on titleBar, OVERLAY: above bar tint (BACKGROUND) and icon (ARTWORK); thick outline reads as dark edge on gold.
	local title = titleBar:CreateFontString(nil, "OVERLAY")
	title:SetFontObject(GameFontNormalHuge)
	title:SetPoint("LEFT", titleIcon, "RIGHT", 6, 0)
	title:SetText(ns:L("MAIN_TITLE"))
	local font, size = title:GetFont()
	if font and size then
		title:SetFont(font, size, "THICKOUTLINE")
	end
	title:SetAlpha(1)
	title:SetTextColor(1, 0.82, 0)
	title:SetShadowOffset(1, -1)
	title:SetShadowColor(0, 0, 0, 1)

	local titleVersion = titleBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	titleVersion:SetPoint("LEFT", title, "RIGHT", 8, -1)
	titleVersion:SetTextColor(0.72, 0.82, 0.95)

	-- Close hides the shell; slash can reopen.
	local closeBtn = CreateFrame("Button", nil, titleBar, "UIPanelCloseButton")
	closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", -4, 0)
	closeBtn:SetScript("OnClick", function()
		main:Hide()
	end)

	local infoToggleBtn = CreateFrame("Button", "MidnightHelperInfoToggleBtn", titleBar, "UIPanelButtonTemplate")
	infoToggleBtn:SetSize(56, 22)
	infoToggleBtn:SetPoint("RIGHT", closeBtn, "LEFT", -4, 0)
	MHTintButtonTextures(infoToggleBtn, MH_CHROME.tabTexInactive[1], MH_CHROME.tabTexInactive[2], MH_CHROME.tabTexInactive[3])

	-- Global search row: visible on every tab, full width (wider than the ~132px sidebar would allow).
	local searchBar = CreateFrame("Frame", "MidnightHelperGlobalSearch", main)
	searchBar:SetHeight(MHGetLayoutMetrics().searchBarHeight)
	searchBar:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, 0)
	searchBar:SetPoint("TOPRIGHT", titleBar, "BOTTOMRIGHT", 0, 0)
	searchBar:EnableMouse(true)
	local searchBarBg = searchBar:CreateTexture(nil, "BACKGROUND")
	searchBarBg:SetAllPoints()
	searchBarBg:SetTexture(MH_TEX.dialogBgDark)
	if searchBarBg.SetHorizTile then
		searchBarBg:SetHorizTile(true)
	end
	if searchBarBg.SetVertTile then
		searchBarBg:SetVertTile(true)
	end
	searchBarBg:SetVertexColor(0.22, 0.2, 0.24, 0.92)
	local searchBarEdge = searchBar:CreateTexture(nil, "BORDER")
	searchBarEdge:SetHeight(1)
	searchBarEdge:SetPoint("BOTTOMLEFT", searchBar, "BOTTOMLEFT", 0, 0)
	searchBarEdge:SetPoint("BOTTOMRIGHT", searchBar, "BOTTOMRIGHT", 0, 0)
	searchBarEdge:SetColorTexture(MH_CHROME.separator[1], MH_CHROME.separator[2], MH_CHROME.separator[3], 0.65)

	local searchBarHint = searchBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	searchBarHint:SetPoint("LEFT", searchBar, "LEFT", 10, 0)
	searchBarHint:SetTextColor(0.82, 0.78, 0.68)
	searchBarHint:SetText(ns:L("SEARCH_LABEL"))

	local searchResetBtn = CreateFrame("Button", nil, searchBar, "UIPanelButtonTemplate")
	searchResetBtn:SetSize(MHGetLayoutMetrics().searchResetBtnWidth, 22)
	searchResetBtn:SetPoint("RIGHT", searchBar, "RIGHT", -8, 0)
	searchResetBtn:SetText(ns:L("SEARCH_MY_CHARACTER"))
	MHTintButtonTextures(searchResetBtn, MH_CHROME.tabTexInactive[1], MH_CHROME.tabTexInactive[2], MH_CHROME.tabTexInactive[3])

	local searchGoBtn = CreateFrame("Button", nil, searchBar, "UIPanelButtonTemplate")
	searchGoBtn:SetSize(MHGetLayoutMetrics().searchGoBtnWidth, 22)
	searchGoBtn:SetPoint("RIGHT", searchResetBtn, "LEFT", -6, 0)
	searchGoBtn:SetText(ns:L("SEARCH_GO"))
	MHTintButtonTextures(searchGoBtn, MH_CHROME.tabTexInactive[1], MH_CHROME.tabTexInactive[2], MH_CHROME.tabTexInactive[3])

	local searchEdit = CreateFrame("EditBox", nil, searchBar)
	searchEdit:SetAutoFocus(false)
	searchEdit:SetMultiLine(false)
	searchEdit:SetFontObject("GameFontHighlightSmall")
	searchEdit:SetHeight(20)
	searchEdit:SetPoint("LEFT", searchBarHint, "RIGHT", 8, 0)
	searchEdit:SetPoint("RIGHT", searchGoBtn, "LEFT", -8, 0)
	if searchEdit.SetMaxLetters then
		searchEdit:SetMaxLetters(96)
	end
	searchEdit:SetTextInsets(6, 6, 0, 0)
	searchEdit:SetTextColor(0.95, 0.93, 0.88)
	ns.mhSearchEdit = searchEdit

	local searchEditBg = CreateFrame("Frame", nil, searchBar, "BackdropTemplate")
	searchEditBg:SetPoint("TOPLEFT", searchEdit, "TOPLEFT", -4, 2)
	searchEditBg:SetPoint("BOTTOMRIGHT", searchEdit, "BOTTOMRIGHT", 4, -2)
	searchEditBg:SetFrameLevel(searchBar:GetFrameLevel() + 1)
	if searchEditBg.SetBackdrop then
		searchEditBg:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		})
		searchEditBg:SetBackdropColor(0.05, 0.05, 0.07, 0.94)
		searchEditBg:SetBackdropBorderColor(0.55, 0.46, 0.3, 0.85)
	end
	searchEdit:SetFrameLevel(searchBar:GetFrameLevel() + 2)

	local function runSearchFromBar()
		if ns.MH_RunSearchQuery then
			ns.MH_RunSearchQuery(searchEdit:GetText())
		else
			print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("SEARCH_NOT_READY")))
		end
	end
	searchEdit:SetScript("OnEnterPressed", function(self)
		runSearchFromBar()
		self:ClearFocus()
	end)
	searchGoBtn:SetScript("OnClick", function()
		runSearchFromBar()
		searchEdit:ClearFocus()
	end)
	searchResetBtn:SetScript("OnClick", function()
		if ns.MH_ClearSearchAndPreview then
			ns.MH_ClearSearchAndPreview()
		else
			if ns.mhSearchEdit and ns.mhSearchEdit.SetText then
				ns.mhSearchEdit:SetText("")
			end
		end
	end)

	searchBar:SetScript("OnEnter", function()
		local gt = _G.GameTooltip
		if not gt or not gt.SetOwner then
			return
		end
		gt:SetOwner(searchBar, "ANCHOR_TOPRIGHT", 0, 0)
		gt:ClearLines()
		gt:AddLine(ns:L("SEARCH_TOOLTIP_TITLE"), 1, 0.9, 0.5)
		gt:AddLine(
			ns:L("SEARCH_TOOLTIP_BODY"),
			0.9,
			0.88,
			0.82,
			true
		)
		gt:Show()
	end)
	searchBar:SetScript("OnLeave", function()
		local gt = _G.GameTooltip
		if gt then
			gt:Hide()
		end
	end)

	ns.mhSearchBar = searchBar

	-- Sidebar column for module tabs (left, below global search).
	local sidebar = CreateFrame("Frame", nil, main)
	sidebar:SetWidth(MHGetLayoutMetrics().sidebarWidth)
	sidebar:SetPoint("TOPLEFT", searchBar, "BOTTOMLEFT", 0, 0)
	-- Inner shell uses only the gold-border inset; resize grip sits in the corner on top.
	sidebar:SetPoint("BOTTOMLEFT", main, "BOTTOMLEFT", MH_MAIN_EDGE.L, MH_MAIN_EDGE.B)

	local sidebarBg = sidebar:CreateTexture(nil, "ARTWORK", nil, -7)
	sidebarBg:SetAllPoints()
	sidebarBg:SetTexture(MH_TEX.dialogBgDark)
	if sidebarBg.SetHorizTile then
		sidebarBg:SetHorizTile(true)
	end
	if sidebarBg.SetVertTile then
		sidebarBg:SetVertTile(true)
	end
	sidebarBg:SetVertexColor(0.34, 0.32, 0.38, 0.94)

	local betaSepTop = sidebar:CreateTexture(nil, "ARTWORK")
	betaSepTop:SetHeight(1)
	betaSepTop:SetColorTexture(0.45, 0.40, 0.30, 0.55)
	sidebar._mhBetaSepTop = betaSepTop
	local betaSepBottom = sidebar:CreateTexture(nil, "ARTWORK")
	betaSepBottom:SetHeight(1)
	betaSepBottom:SetColorTexture(0.45, 0.40, 0.30, 0.45)
	sidebar._mhBetaSepBottom = betaSepBottom

	-- About stays pinned to the bottom
	local aboutBtn = CreateFrame("Button", "MidnightHelperAboutBtn", sidebar, "UIPanelButtonTemplate")
	aboutBtn:SetSize(MHGetLayoutMetrics().aboutBtnWidth, MHGetLayoutMetrics().aboutBtnHeight)
	aboutBtn:SetPoint("BOTTOM", sidebar, "BOTTOM", 0, ABOUT_BTN_BOTTOM_INSET)
	MHTintButtonTextures(aboutBtn, MH_CHROME.tabTexInactive[1], MH_CHROME.tabTexInactive[2], MH_CHROME.tabTexInactive[3])
	aboutBtn:SetText(ns:L("ABOUT_BUTTON"))
	aboutBtn:SetScript("OnClick", function()
		if ns._mhToggleAboutPanel then
			ns:_mhToggleAboutPanel()
		end
	end)

	-- Content region: hosts one visible module panel at a time.
	local content = CreateFrame("Frame", nil, main)
	content:SetPoint("TOPLEFT", searchBar, "BOTTOMLEFT", MHGetLayoutMetrics().sidebarWidth, 0)
	content:SetPoint("BOTTOMRIGHT", main, "BOTTOMRIGHT", -MH_MAIN_EDGE.R, MH_MAIN_EDGE.B)

	local contentBg = content:CreateTexture(nil, "BACKGROUND")
	contentBg:SetAllPoints()
	contentBg:SetTexture(MH_TEX.dialogBg)
	if contentBg.SetHorizTile then
		contentBg:SetHorizTile(true)
	end
	if contentBg.SetVertTile then
		contentBg:SetVertTile(true)
	end
	contentBg:SetVertexColor(0.42, 0.44, 0.52, 0.72)

	local infoWindow = CreateFrame("Frame", "MidnightHelperInfoWindow", main, "BackdropTemplate")
	infoWindow:SetSize(MHGetLayoutMetrics().infoWindowWidth, MHGetLayoutMetrics().infoWindowHeight)
	infoWindow:SetFrameLevel(main:GetFrameLevel() + 8)
	infoWindow:SetClampedToScreen(true)
	if infoWindow.SetBackdrop then
		infoWindow:SetBackdrop({
			bgFile = MH_TEX.dialogBg,
			edgeFile = MH_TEX.goldEdge,
			tile = true,
			tileSize = 32,
			edgeSize = 16,
			insets = { left = 8, right = 9, top = 8, bottom = 8 },
		})
		infoWindow:SetBackdropColor(1, 1, 1, 0.93)
		infoWindow:SetBackdropBorderColor(1, 1, 1, 1)
	end
	infoWindow:Hide()

	local infoTitle = infoWindow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	infoTitle:SetPoint("TOPLEFT", infoWindow, "TOPLEFT", 12, -12)
	infoTitle:SetPoint("TOPRIGHT", infoWindow, "TOPRIGHT", -12, -12)
	infoTitle:SetJustifyH("LEFT")
	infoTitle:SetTextColor(1, 0.9, 0.6)

	local infoBody = infoWindow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	infoBody:SetPoint("TOPLEFT", infoTitle, "BOTTOMLEFT", 0, -10)
	infoBody:SetPoint("TOPRIGHT", infoWindow, "TOPRIGHT", -12, -10)
	infoBody:SetPoint("BOTTOMLEFT", infoWindow, "BOTTOMLEFT", 12, 12)
	infoBody:SetJustifyH("LEFT")
	infoBody:SetJustifyV("TOP")
	infoBody:SetWordWrap(true)
	infoBody:SetTextColor(0.88, 0.86, 0.8)

	function ns:_mhRefreshSidePanel(tabId)
		if not infoWindow or not infoTitle or not infoBody then
			return
		end
		local mode = self._mhSidePanelMode or "info"
		if mode == "about" then
			infoTitle:SetText(self:L("ABOUT_WINDOW_TITLE"))
			local ver = ns.GetAddonVersion and ns.GetAddonVersion() or "?"
			infoBody:SetText(self:L("ABOUT_VERSION_FMT"):format(ver) .. "\n\n" .. self:L("ABOUT_WINDOW_BODY"))
		else
			local keyById = {
				delves = "TAB_DELVES",
				account = "TAB_ACCOUNT_SNAPSHOT",
				rares = "TAB_RARES",
				reference = "TAB_REFERENCE",
				smcguide = "TAB_SMC",
				professions = "TAB_PROFESSIONS",
				guide = "TAB_GUIDE",
				macros = "TAB_MACROS",
				academy = "TAB_ACADEMY",
				addons = "TAB_ADDONS",
			}
			local tabName = self:L(keyById[tabId] or "TAB_DELVES")
			infoTitle:SetText(self:L("INFO_DRAWER_TITLE_FMT"):format(tabName))
			infoBody:SetText(self:L(MHGetInfoBodyKeyForTab(tabId)))
		end
		local infoToggleKey = (infoWindow:IsShown() and mode == "info") and "INFO_DRAWER_TOGGLE_HIDE" or "INFO_DRAWER_TOGGLE_SHOW"
		infoToggleBtn:SetText(self:EscapeButtonAmpersand(self:L(infoToggleKey)))
		FitTitleBarButton(infoToggleBtn, 56, 120)
		local aboutBtnKey = (infoWindow:IsShown() and mode == "about") and "INFO_DRAWER_TOGGLE_HIDE" or "ABOUT_BUTTON"
		aboutBtn:SetText(self:EscapeButtonAmpersand(self:L(aboutBtnKey)))
		FitTitleBarButton(aboutBtn, 56, 100)
	end

	local function reanchorInfoWindow()
		local m = MHGetLayoutMetrics()
		local gap = 8
		local uiLeft = UIParent.GetLeft and UIParent:GetLeft() or 0
		local uiRight = UIParent.GetRight and UIParent:GetRight() or 0
		local mainLeft = main.GetLeft and main:GetLeft() or 0
		local mainRight = main.GetRight and main:GetRight() or 0
		local need = (infoWindow.GetWidth and infoWindow:GetWidth() or m.infoWindowWidth) + gap
		local rightSpace = uiRight - mainRight
		local leftSpace = mainLeft - uiLeft

		infoWindow:ClearAllPoints()
		if rightSpace >= need then
			-- Preferred: compact helper window to the right of the addon.
			infoWindow:SetPoint("BOTTOMLEFT", main, "BOTTOMRIGHT", gap, 0)
		elseif leftSpace >= need then
			-- Fallback: place it to the left if right side is against screen edge.
			infoWindow:SetPoint("BOTTOMRIGHT", main, "BOTTOMLEFT", -gap, 0)
		else
			-- Last resort on very small screens: keep it inside the addon, bottom-right (inside gold border).
			infoWindow:SetPoint("BOTTOMRIGHT", main, "BOTTOMRIGHT", -MH_MAIN_EDGE.R - 6, MH_MAIN_EDGE.B + 6)
		end
	end

	local function setSidePanelMode(mode)
		if infoWindow:IsShown() and ns._mhSidePanelMode == mode then
			infoWindow:Hide()
		else
			ns._mhSidePanelMode = mode
			reanchorInfoWindow()
			infoWindow:Show()
		end
		ns:_mhRefreshSidePanel(ns.uiSelectedTab or "delves")
	end

	local function toggleInfoWindow()
		setSidePanelMode("info")
	end
	infoToggleBtn:SetScript("OnClick", toggleInfoWindow)
	function ns:_mhToggleAboutPanel()
		setSidePanelMode("about")
	end
	ns._mhSidePanelMode = ns._mhSidePanelMode or "info"

	-- Vertical rule + shadow (embossed gold accent between sidebar and content).
	local sidebarSepShadow = main:CreateTexture(nil, "ARTWORK", nil, 0)
	sidebarSepShadow:SetWidth(3)
	sidebarSepShadow:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", -1, 0)
	sidebarSepShadow:SetPoint("BOTTOMLEFT", sidebar, "BOTTOMRIGHT", -1, 0)
	sidebarSepShadow:SetColorTexture(MHUnpack4(MH_CHROME.separatorShadow))
	local sidebarSep = main:CreateTexture(nil, "ARTWORK", nil, 1)
	sidebarSep:SetWidth(2)
	sidebarSep:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 0, 0)
	sidebarSep:SetPoint("BOTTOMLEFT", sidebar, "BOTTOMRIGHT", 0, 0)
	sidebarSep:SetColorTexture(MHUnpack4(MH_CHROME.separator))

	-- Module panels: siblings in `content`; tab clicks toggle visibility.
	ns.panels = ns.panels or {}

	local function CreateModulePanel(id, displayName)
		local panel = CreateFrame("Frame", nil, content)
		panel:SetAllPoints()
		panel:Hide()

		local header = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
		header:SetPoint("TOPLEFT", 12, -12)
		header:SetText(displayName)
		panel._header = header

		local body = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		body:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -8)
		body:SetWidth(content:GetWidth() - 24)
		body:SetJustifyH("LEFT")
		body:SetText(ns:L("MODULE_PLACEHOLDER"):format(displayName))

		panel._body = body
		panel:SetScript("OnShow", function()
			body:SetWidth(panel:GetWidth() - 24)
		end)

		ns.panels[id] = panel
		return panel
	end

	local tabKeys = {}
	for _, tab in ipairs(TAB_DEFS) do
		tabKeys[tab.id] = tab.labelKey
	end

	for _, tab in ipairs(TAB_DEFS) do
		if tab.id ~= "addons" and tab.id ~= "guide" then
			local panel = CreateModulePanel(tab.id, ns:L(tab.labelKey))
			if tab.id == "smcguide" then
				BuildSMCCityGuidePanel(panel)
			elseif tab.id == "macros" and ns.BuildInterruptMacrosPanel then
				ns.BuildInterruptMacrosPanel(panel)
			elseif tab.id == "consumables" and ns.BuildConsumablesPanel then
				ns.BuildConsumablesPanel(panel)
			elseif tab.id == "academy" and ns.BuildRoleAcademyPanel then
				ns.BuildRoleAcademyPanel(panel)
			elseif tab.id == "reference" and ns.BuildReferenceGuidePanel then
				ns.BuildReferenceGuidePanel(panel)
			elseif tab.id == "rares" and ns.BuildRaresPanel then
				ns.BuildRaresPanel(panel)
			end
		end
	end

	-- Leveling Guides: original advisor (Guide.lua) + Layout keyboard prototype sub-tabs.
	do
		local guideHost = CreateFrame("Frame", "MidnightHelperLevelingGuidesHost", content)
		guideHost:SetAllPoints()
		guideHost:Hide()
		ns.panels.guide = guideHost

		local subNav = CreateFrame("Frame", nil, guideHost)
		subNav:SetHeight(MHGetLayoutMetrics().addonSubNavHeight)
		subNav:SetPoint("TOPLEFT", guideHost, "TOPLEFT", 8, -8)
		subNav:SetPoint("TOPRIGHT", guideHost, "TOPRIGHT", -8, -8)
		guideHost._mhSubNav = subNav

		local line = guideHost:CreateTexture(nil, "ARTWORK")
		line:SetHeight(1)
		line:SetPoint("TOPLEFT", subNav, "BOTTOMLEFT", 0, -2)
		line:SetPoint("TOPRIGHT", subNav, "BOTTOMRIGHT", 0, -2)
		line:SetColorTexture(MH_CHROME.separator[1], MH_CHROME.separator[2], MH_CHROME.separator[3], 0.55)

		local subContent = CreateFrame("Frame", nil, guideHost)
		subContent:SetPoint("TOPLEFT", subNav, "BOTTOMLEFT", 0, MHGetLayoutMetrics().addonSubContentTopGap)
		subContent:SetPoint("BOTTOMRIGHT", guideHost, "BOTTOMRIGHT", -8, 8)
		guideHost._mhSubContent = subContent

		local guideBody = CreateFrame("Frame", nil, subContent)
		guideBody:SetAllPoints()
		ns.panels.guideBody = guideBody

		local layoutPanel = CreateFrame("Frame", nil, subContent)
		layoutPanel:SetAllPoints()
		layoutPanel:Hide()
		ns._mhGuideLayoutPanel = layoutPanel

		ns.guideSubTabButtons = {}
		local btnGuide = CreateFrame("Button", "MidnightHelperGuideSubTab_guide", subNav, "UIPanelButtonTemplate")
		btnGuide:SetSize(100, MHGetLayoutMetrics().addonSubTabHeight)
		btnGuide:SetPoint("TOPLEFT", subNav, "TOPLEFT", 0, -6)
		btnGuide:SetText(ns:L("TAB_GUIDE_SUB_GUIDE"))
		btnGuide:SetScript("OnClick", function()
			ns._mhSelectGuideSubTab("guide")
		end)
		ns.guideSubTabButtons.guide = btnGuide

		local btnLayout = CreateFrame("Button", "MidnightHelperGuideSubTab_layout", subNav, "UIPanelButtonTemplate")
		btnLayout:SetSize(100, MHGetLayoutMetrics().addonSubTabHeight)
		btnLayout:SetPoint("TOPLEFT", btnGuide, "TOPRIGHT", 6, 0)
		btnLayout:SetText(ns:L("TAB_GUIDE_SUB_LAYOUT"))
		btnLayout:SetScript("OnClick", function()
			ns._mhSelectGuideSubTab("layout")
		end)
		ns.guideSubTabButtons.layout = btnLayout

		function ns._mhSelectGuideSubTab(which)
			if which ~= "guide" and which ~= "layout" then
				which = "guide"
			end
			ns.uiSelectedGuideSubTab = which
			if which == "guide" then
				guideBody:Show()
				layoutPanel:Hide()
				if ns.KeyboardLayoutPrototype_SetHighlight then
					ns.KeyboardLayoutPrototype_SetHighlight(layoutPanel, nil)
				end
				MHRefreshGuideSubTabChrome("guide")
				if ns._mhGuideRefresh then
					ns:_mhGuideRefresh()
				end
			else
				guideBody:Hide()
				layoutPanel:Show()
				MHRefreshGuideSubTabChrome("layout")
				if ns.BuildKeyboardLayoutPrototypePanel then
					ns.BuildKeyboardLayoutPrototypePanel(layoutPanel)
				end
				if ns.KeyboardLayoutPrototype_Refresh then
					ns.KeyboardLayoutPrototype_Refresh(layoutPanel)
				end
			end
		end

		ns.uiSelectedGuideSubTab = ns.uiSelectedGuideSubTab or "guide"
		ns._mhSelectGuideSubTab(ns.uiSelectedGuideSubTab)
	end

	-- Addons: single main tab with a top row of sub-tabs and a shared content well.
	local addonsPanel = CreateFrame("Frame", "MidnightHelperAddonsHost", content)
	addonsPanel:SetAllPoints()
	addonsPanel:Hide()
	ns.panels["addons"] = addonsPanel

	local addonsSubNav = CreateFrame("Frame", nil, addonsPanel)
	addonsSubNav:SetHeight(MHGetLayoutMetrics().addonSubNavHeight)
	addonsSubNav:SetPoint("TOPLEFT", addonsPanel, "TOPLEFT", 8, -8)
	addonsSubNav:SetPoint("TOPRIGHT", addonsPanel, "TOPRIGHT", -8, -8)

	local addonsLine = addonsPanel:CreateTexture(nil, "ARTWORK")
	addonsLine:SetHeight(1)
	addonsLine:SetPoint("TOPLEFT", addonsSubNav, "BOTTOMLEFT", 0, -2)
	addonsLine:SetPoint("TOPRIGHT", addonsSubNav, "BOTTOMRIGHT", 0, -2)
	addonsLine:SetColorTexture(MH_CHROME.separator[1], MH_CHROME.separator[2], MH_CHROME.separator[3], 0.55)

	local addonsSubContent = CreateFrame("Frame", nil, addonsPanel)
	addonsSubContent:SetPoint("TOPLEFT", addonsSubNav, "BOTTOMLEFT", 0, MHGetLayoutMetrics().addonSubContentTopGap)
	addonsSubContent:SetPoint("BOTTOMRIGHT", addonsPanel, "BOTTOMRIGHT", -8, 8)

	ns._mhAddonSubFrames = {}
	ns.addonSubTabButtons = {}

	local navX = 0
	for _, subId in ipairs(ns._mhAddonSubTabOrder) do
		local def = ns._mhAddonSubTabById[subId]
		if def and def.Build then
			local btn = CreateFrame("Button", "MidnightHelperAddonSubTab_" .. subId, addonsSubNav, "UIPanelButtonTemplate")
			btn:SetSize(120, MHGetLayoutMetrics().addonSubTabHeight)
			btn:SetText(def.label)
			btn:SetPoint("TOPLEFT", addonsSubNav, "TOPLEFT", navX, -6)
			btn:SetScript("OnClick", function()
				SelectAddonSubTab(subId)
			end)
			ns.addonSubTabButtons[subId] = btn
			navX = navX + btn:GetWidth() + 6

			local child = def.Build(addonsSubContent)
			if child then
				child:SetAllPoints(addonsSubContent)
				child:Hide()
				ns._mhAddonSubFrames[subId] = child
			end
		end
	end

	-- Tab buttons stacked in the sidebar (Addons sits just above About).
	ns.tabButtons = ns.tabButtons or {}
	local y = -8
	for i, tab in ipairs(TAB_DEFS) do
		local btn = CreateFrame("Button", "MidnightHelperTab_" .. tab.id, sidebar, "UIPanelButtonTemplate")
		btn:SetSize(MHGetLayoutMetrics().sidebarWidth - 16, MHGetLayoutMetrics().sidebarTabHeight)
		btn:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 8, y)
		y = y - MHGetLayoutMetrics().sidebarTabStep
		btn:SetText(ns:L(tab.labelKey))
		FitSidebarTabButton(btn, MHGetLayoutMetrics().sidebarWidth)
		btn:SetScript("OnClick", function()
			SelectTab(tab.id)
		end)
		MHAttachTabBetaBadge(btn, tab.id)
		ns.tabButtons[tab.id] = btn
	end

	RelayoutSidebarTabs = function()
		local lm = MHGetLayoutMetrics()
		local yy = -8

		sidebar._mhSectionHeaders = sidebar._mhSectionHeaders or {}

		-- The old beta band separators are unused in the sectioned layout.
		if sidebar._mhBetaSepTop then
			sidebar._mhBetaSepTop:Hide()
		end
		if sidebar._mhBetaSepBottom then
			sidebar._mhBetaSepBottom:Hide()
		end

		local function layoutTab(tabId)
			local btn = ns.tabButtons and ns.tabButtons[tabId]
			if not btn then
				return
			end
			local labelKey = TAB_LABEL_BY_ID[tabId]
			if labelKey then
				btn:SetText(ns:L(labelKey))
			end
			FitSidebarTabButton(btn, lm.sidebarWidth)
			btn:SetSize(lm.sidebarWidth - 16, lm.sidebarTabHeight)
			btn:ClearAllPoints()
			if not SidebarTabVisible(tabId) then
				btn:Hide()
				return
			end
			btn:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 8, yy)
			btn:Show()
			MHAttachTabBetaBadge(btn, tabId)
			yy = yy - lm.sidebarTabStep
		end

		local firstSectionDrawn = false
		for _, section in ipairs(SIDEBAR_SECTIONS) do
			local visibleCount = 0
			for _, tabId in ipairs(section.ids) do
				local btn = ns.tabButtons and ns.tabButtons[tabId]
				if btn and SidebarTabVisible(tabId) then
					visibleCount = visibleCount + 1
				end
			end

			local header = sidebar._mhSectionHeaders[section.key]
			if not header then
				header = sidebar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
				header:SetJustifyH("LEFT")
				header:SetTextColor(0.82, 0.68, 0.30)
				sidebar._mhSectionHeaders[section.key] = header
			end
			header:SetText(ns:L(section.titleKey))

			if visibleCount > 0 then
				if firstSectionDrawn then
					yy = yy - SIDEBAR_SECTION_GAP
				end
				header:ClearAllPoints()
				header:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 10, yy)
				header:Show()
				yy = yy - SIDEBAR_HEADER_HEIGHT
				firstSectionDrawn = true
				for _, tabId in ipairs(section.ids) do
					layoutTab(tabId)
				end
			else
				header:Hide()
			end
		end

		if ns.uiSelectedTab and ns.IsBetaTabId and ns.IsBetaTabId(ns.uiSelectedTab) and not SidebarTabVisible(ns.uiSelectedTab) then
			SelectTab("delves")
		elseif ns.uiSelectedTab == "guide" and ns.IsGuideTabEnabled and not ns:IsGuideTabEnabled() then
			SelectTab("delves")
		end
	end

	-- Resize grip: bottom-right corner uses StartSizing so the shell stays resizable.
	local grip = CreateFrame("Button", nil, main)
	grip:SetSize(RESIZE_GRIP_SIZE, RESIZE_GRIP_SIZE)
	grip:SetPoint("BOTTOMRIGHT", main, "BOTTOMRIGHT", -MH_MAIN_EDGE.R - 2, MH_MAIN_EDGE.B + 2)
	grip:SetFrameLevel(main:GetFrameLevel() + 25)
	grip:RegisterForDrag("LeftButton")
	-- Simple corner affordance; drag starts BOTTOMRIGHT sizing on the main frame.
	grip:SetNormalTexture("Interface\\Buttons\\UI-ResizeButton-Up")
	grip:SetPushedTexture("Interface\\Buttons\\UI-ResizeButton-Down")
	grip:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	grip:SetScript("OnDragStart", function()
		main:StartSizing("BOTTOMRIGHT")
	end)
	grip:SetScript("OnDragStop", function()
		main:StopMovingOrSizing()
		if ns._mhLayoutRefs and ns._mhLayoutRefs.reanchorInfoWindow then
			ns._mhLayoutRefs.reanchorInfoWindow()
		end
	end)

	local function SaveMainWindowSize()
		local dbUi = ns.db and ns.db.ui
		if not dbUi then
			return
		end
		dbUi.mainWidth = ClampMainWidth(math.floor(main:GetWidth() or DEFAULT_WIDTH))
		dbUi.mainHeight = ClampMainHeight(math.floor(main:GetHeight() or DEFAULT_HEIGHT))
		dbUi.mainWindowUserSized = true
		dbUi.layoutVersion = math.max(tonumber(dbUi.layoutVersion) or 0, 3)
	end

	function ns:SaveMainWindowSize()
		if not self.mainUI then
			return
		end
		SaveMainWindowSize()
	end

	function ns:PrintMainWindowSize()
		local dbUi = ns.db and ns.db.ui
		local w = self.mainUI and math.floor(self.mainUI:GetWidth() or 0) or 0
		local h = self.mainUI and math.floor(self.mainUI:GetHeight() or 0) or 0
		local scale = dbUi and tonumber(dbUi.scale) or 1
		local savedW = dbUi and tonumber(dbUi.mainWidth)
		local savedH = dbUi and tonumber(dbUi.mainHeight)
		local msg = self:L("FRAME_SIZE_REPORT"):format(w, h, scale, savedW or "-", savedH or "-")
		DEFAULT_CHAT_FRAME:AddMessage(("|cffffcc00%s|r %s"):format(self:L("PRINT_PREFIX"), msg))
	end

	main:SetScript("OnSizeChanged", function()
		SaveMainWindowSize()
	end)
	titleBar:SetScript("OnDragStop", function()
		main:StopMovingOrSizing()
		if ns._mhLayoutRefs and ns._mhLayoutRefs.reanchorInfoWindow then
			ns._mhLayoutRefs.reanchorInfoWindow()
		end
		SaveMainWindowSize()
	end)
	grip:SetScript("OnDragStop", function()
		main:StopMovingOrSizing()
		if ns._mhLayoutRefs and ns._mhLayoutRefs.reanchorInfoWindow then
			ns._mhLayoutRefs.reanchorInfoWindow()
		end
		SaveMainWindowSize()
	end)

	ns._mhLocaleRefs = {
		title = title,
		titleVersion = titleVersion,
		searchHint = searchBarHint,
		searchResetBtn = searchResetBtn,
		searchGoBtn = searchGoBtn,
		aboutBtn = aboutBtn,
		infoToggleBtn = infoToggleBtn,
		tabKeys = tabKeys,
		guideSubTabButtons = ns.guideSubTabButtons,
		smcHeader = ns.panels.smcguide and ns.panels.smcguide._header,
		smcSubtitle = ns.panels.smcguide and ns.panels.smcguide._mhSMCSubtitle,
	}
	ns._mhLayoutRefs = {
		main = main,
		sidebar = sidebar,
		content = content,
		searchBar = searchBar,
		searchResetBtn = searchResetBtn,
		searchGoBtn = searchGoBtn,
		aboutBtn = aboutBtn,
		guidePanel = ns.panels.guide,
		addonsPanel = addonsPanel,
		addonsSubNav = addonsSubNav,
		addonsSubContent = addonsSubContent,
		infoWindow = infoWindow,
		reanchorInfoWindow = reanchorInfoWindow,
	}
	ns._mhInfoWindow = infoWindow
	ns._mhRelayoutSidebarTabs = RelayoutSidebarTabs
	ns:RefreshLocaleUI()
	RelayoutSidebarTabs()

	self.mainUI = main
	self.mainUIContent = content

	-- Old keys: standalone Great Vault tab merged into Delves dashboard.
	if ns.uiSelectedTab == "dungeons" or ns.uiSelectedTab == "vault" then
		ns.uiSelectedTab = "delves"
	end
	if ns.uiSelectedTab == "companion" then
		ns.uiSelectedTab = "delves"
	end

	-- Default tab on first open
	SelectTab(ns.uiSelectedTab or "delves")
	ns:ApplySavedMainWindowSize()
	ns:_mhRefreshSidePanel(ns.uiSelectedTab or "delves")

	main:SetScript("OnHide", function()
		if ns._mhInfoWindow and ns._mhInfoWindow.Hide then
			ns._mhInfoWindow:Hide()
		end
	end)

	-- Enable interactive scaling with Shift + MouseWheel
	main:EnableMouseWheel(true)
	main:SetScript("OnMouseWheel", function(self, delta)
		if IsShiftKeyDown() then
			local currentScale = ns.db.ui.scale or 1
			-- Change scale by 5% per scroll tick
			local newScale = currentScale + (delta * 0.05)

			-- Keep scale within usable bounds (50% to 300%)
			newScale = math.max(0.5, math.min(3.0, newScale))

			ns.db.ui.scale = newScale
			ns:ApplyCompactMode()

			-- Optional: show scale in chat for feedback
			-- print(string.format("|cffffcc00Midnight Helper:|r Scale: %.2f", newScale))
		end
	end)

	-- Apply the saved scale on load, then restore user window dimensions (tab init must not override).
	ns:ApplyCompactMode()
	ns:ApplySavedMainWindowSize()

	return main
end

--------------------------------------------------------------------------------
-- Tab routing: one module frame visible at a time
--------------------------------------------------------------------------------
SelectTab = function(tabId)
	if tabId == "guide" and ns.IsGuideTabEnabled and not ns:IsGuideTabEnabled() then
		tabId = "delves"
	end
	if not ns.panels or not ns.panels[tabId] then
		return
	end

	ns.uiSelectedTab = tabId

	for id, panel in pairs(ns.panels) do
		if id == tabId then
			panel:Show()
		else
			panel:Hide()
		end
	end

	-- Blizzard-ish tab chrome: warm metal active vs muted inactive (UIPanelButton textures only).
	MHRefreshSidebarTabChrome(tabId)
	if ns._mhRefreshSidePanel then
		ns:_mhRefreshSidePanel(tabId)
	end

	if tabId == "guide" then
		local sid = ns.uiSelectedGuideSubTab or "guide"
		if ns._mhSelectGuideSubTab then
			ns._mhSelectGuideSubTab(sid)
		end
	end

	if tabId == "reference" and ns.RefreshReferenceGuidePanel then
		ns.RefreshReferenceGuidePanel()
	end

	if tabId == "rares" and ns.RefreshRaresPanel then
		ns.RefreshRaresPanel()
	end

	if tabId == "delves" then
		if ns.RefreshDelvesPanel then
			ns.RefreshDelvesPanel(true)
		end
		if ns.mainUI and ns.mainUI.SetHeight then
			local dbUi = ns.db and ns.db.ui
			local userSized = dbUi and dbUi.mainWindowUserSized
			local mh = ns.mainUI:GetHeight() or 0
			if not userSized and mh < MIN_DELVES_WINDOW_H then
				local targetH = ClampMainHeight(math.max(MIN_DELVES_WINDOW_H, DEFAULT_HEIGHT))
				ns.mainUI:SetHeight(targetH)
				if dbUi then
					dbUi.mainHeight = targetH
					dbUi.layoutVersion = 3
				end
			end
		end
	end

	if tabId == "addons" then
		local sid = ns.uiSelectedAddonSubTab
		if not sid or not (ns._mhAddonSubFrames and ns._mhAddonSubFrames[sid]) then
			sid = ns._mhAddonSubTabOrder and ns._mhAddonSubTabOrder[1]
		end
		if sid then
			SelectAddonSubTab(sid)
		end
	end
end

ns.SelectTab = SelectTab

function ns:RefreshGuideTabVisibility()
	if ns.RefreshBetaTabVisibility then
		ns.RefreshBetaTabVisibility()
	end
end

function ns.RefreshBetaTabVisibility()
	if RelayoutSidebarTabs then
		RelayoutSidebarTabs()
	end
	local t = ns.uiSelectedTab
	if not t or not ns.SelectTab then
		return
	end
	if ns.IsBetaTabId and ns.IsBetaTabId(t) and ns.IsBetaTabEnabled and not ns.IsBetaTabEnabled(t) then
		ns.SelectTab("delves")
	elseif t == "guide" and ns.IsGuideTabEnabled and not ns:IsGuideTabEnabled() then
		ns.SelectTab("delves")
	end
end

--------------------------------------------------------------------------------
-- Addons sub-tab routing (internal modules inside the Addons main tab)
--------------------------------------------------------------------------------
SelectAddonSubTab = function(subId)
	if not ns._mhAddonSubFrames or not ns._mhAddonSubFrames[subId] then
		return
	end

	ns.uiSelectedAddonSubTab = subId

	for id, frame in pairs(ns._mhAddonSubFrames) do
		if id == subId then
			frame:Show()
		else
			frame:Hide()
		end
	end

	MHRefreshAddonSubTabChrome(subId)
end

ns.SelectAddonSubTab = SelectAddonSubTab

do
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_LEVEL_UP")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function()
		if ns.RefreshGuideTabVisibility then
			ns:RefreshGuideTabVisibility()
		end
	end)
end

--------------------------------------------------------------------------------
-- Public entry points used by Core.lua and slash commands
--------------------------------------------------------------------------------
function ns:ToggleMainWindow()
	local main = self:EnsureMainUI()
	if main:IsShown() then
		main:Hide()
	else
		main:Show()
		self:ApplySavedMainWindowSize()
		if self.uiSelectedTab == "guide" and self._mhSelectGuideSubTab then
			C_Timer.After(0, function()
				if self._mhSelectGuideSubTab then
					self._mhSelectGuideSubTab(self.uiSelectedGuideSubTab or "guide")
				end
			end)
		end
	end
end

function ns:ShowMainUI()
	local main = self:EnsureMainUI()
	main:Show()
	self:ApplySavedMainWindowSize()
	if self.uiSelectedTab == "guide" and self._mhSelectGuideSubTab then
		C_Timer.After(0, function()
			if self._mhSelectGuideSubTab then
				self._mhSelectGuideSubTab(self.uiSelectedGuideSubTab or "guide")
			end
		end)
	end
end
