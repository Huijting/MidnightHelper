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
-- Baseline caps; EnsureMainUI raises them on large displays (see UpdateMaxWindowBounds).
local MAX_WIDTH, MAX_HEIGHT = 1000, 920

-- Shared content-layout metrics for module panels (HomeDashboard, MidnightCodex,
-- and future tabs). Single source so insets stay consistent across tabs; modules
-- read these with local fallbacks so load order can never break them.
ns.UI_METRICS = {
	sidePad = 14,
	topPad = 12,
	sectionGap = 8,
	scrollGutter = 30,
}

local function ClampMainWidth(w)
	w = tonumber(w) or DEFAULT_WIDTH
	return math.max(MIN_WIDTH, math.min(MAX_WIDTH, w))
end

local function ClampMainHeight(h)
	h = tonumber(h) or DEFAULT_HEIGHT
	return math.max(MIN_HEIGHT, math.min(MAX_HEIGHT, h))
end

--- Raise the size caps on large displays (1440p+): the hard 1000x920 cap left
--- dead space on big screens. UIParent dimensions are in the same (scaled)
--- units as the main frame, so the comparison is scale-safe. Never lowers the
--- baseline caps, so small screens keep the original behavior.
local function UpdateMaxWindowBounds()
	local sw = UIParent and UIParent.GetWidth and UIParent:GetWidth() or 0
	local sh = UIParent and UIParent.GetHeight and UIParent:GetHeight() or 0
	if sw > 0 then
		MAX_WIDTH = math.max(1000, math.min(1400, math.floor(sw * 0.85)))
	end
	if sh > 0 then
		MAX_HEIGHT = math.max(920, math.min(1200, math.floor(sh * 0.9)))
	end
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
	-- Programmatic resize: must not mark the window as user-sized (see OnSizeChanged guard).
	ns._mhProgrammaticResize = true
	self.mainUI:SetSize(w, h)
	ns._mhProgrammaticResize = false
end

--- Restore the saved window position (F4.6). No saved point = leave the default CENTER.
function ns:ApplySavedMainWindowPosition()
	local main = self.mainUI
	if not main then
		return
	end
	local ui = ns.db and ns.db.ui
	local p = ui and ui.mainPoint
	if type(p) ~= "table" or type(p.point) ~= "string" then
		return
	end
	main:ClearAllPoints()
	main:SetPoint(p.point, UIParent, p.relativePoint or p.point, tonumber(p.x) or 0, tonumber(p.y) or 0)
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

-- Gedeeld kleur-palet (Tier-1 visuele-rust-pass, 16 jun). Eén accent-goud, één
-- rustige link-tint, één dim-grijs voor subtitels, en status-kleuren die ALLEEN
-- voor status zijn (niet voor decoratie). Panelen lezen hieruit i.p.v. elk hun
-- eigen tint te declareren → minder concurrerende kleuren = rustiger beeld.
-- RGB-tabellen voor SetTextColor; *_HEX voor |cff-markup (AARRGGBB, AA=ff).
-- The single source for panel status colours. Until now this table existed but was
-- read by nobody, so sixteen modules each declared their own COLOR_* and quietly
-- drifted apart: two greens, two ambers, two greys, and one link blue living under
-- three different names. The values below are the ones the panels already agreed on,
-- so adopting them changes nothing except the two outliers (DungeonGuide's duller
-- green/amber, WorldContent's duller heading gold), which is the point.
--
-- Status only. Category palettes (keybind roles, profession academy) encode meaning
-- of their own and are deliberately left alone.
ns.UI_COLORS = {
	header = { 0.91, 0.76, 0.42 }, -- section headings / titles
	gold = { 0.91, 0.76, 0.42 }, -- alias: chrome accents
	GOLD_HEX = "ffe8c36a",
	dim = { 0.75, 0.78, 0.82 }, -- secondary / explanatory text
	DIM_HEX = "ffbfc7d1",
	body = { 0.86, 0.87, 0.90 }, -- running text
	BODY_HEX = "ffdcdde6",
	footer = { 0.45, 0.47, 0.50 }, -- footnotes
	FOOTER_HEX = "ff73787f",
	good = { 0.45, 0.95, 0.5 }, -- done / ready
	GOOD_HEX = "ff73f280",
	warn = { 1, 0.84, 0.18 }, -- needs doing now
	WARN_HEX = "ffffd62e",
	soft = { 0.9, 0.82, 0.45 }, -- in hand, not urgent
	SOFT_HEX = "ffe6d173",
	prog = { 0.45, 0.85, 0.95 }, -- picked up / in progress
	PROG_HEX = "ff73d9f2",
	link = { 0.55, 0.78, 1 }, -- every clickable jump, one tint
	LINK_HEX = "ff8cc7ff",
	bad = { 0.90, 0.42, 0.42 },
	BAD_HEX = "ffe66b6b",
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
	if not fs or not fs.GetStringWidth or not fs.SetFont then
		return
	end
	-- Capture the pristine font size ONCE. Without this, every relayout read the
	-- already-shrunk size and shrank again, so long labels (deDE/frFR) kept getting
	-- smaller each time the sidebar re-laid out (F3.8).
	if not btn._mhBaseFont then
		local font, size, flags = fs:GetFont()
		if not (font and size) then
			return -- font not ready yet
		end
		btn._mhBaseFont = { font = font, size = size, flags = flags }
	end
	local base = btn._mhBaseFont
	local maxW = (sidebarWidth or MHGetLayoutMetrics().sidebarWidth) - 16
	-- Always start from the base size, then shrink to fit (non-cumulative).
	fs:SetFont(base.font, base.size, base.flags)
	local size = base.size
	local textW = fs:GetStringWidth() or 0
	while textW + 24 > maxW and size > 9 do
		size = size - 1
		fs:SetFont(base.font, size, base.flags)
		textW = fs:GetStringWidth() or textW
	end
	btn:SetWidth(maxW)
end

-- Top-level beta-gated tabs. macros/academy (→ Toolbox sub-tabs) and
-- reference (→ Codex category) are no longer top-level; their beta keys still
-- gate the merged locations via ns.IsBetaTabEnabled, so the Settings
-- checkboxes keep working.
-- Beta-badges uitgezet (Rob, 3 jul 2026): geen zichtbare "Beta"-markering meer op de
-- tabs. De gating-logica (ns.IsBetaTabEnabled / Settings-checkboxes) blijft intact —
-- dit haalt alleen de badge + beta-tooltip weg. Weer aanzetten? Vul tab-id's aan.
local MH_BETA_TAB_IDS = {}

-- Sidebar is grouped into labelled sections (header + tabs). Tab ids whose
-- buttons do not exist yet (home, ritual) are skipped during layout, which
-- reserves their slot for later phases without breaking the current build.
-- 1.9.0 Phase 2 (4-kamer-model, stap 1 = hergroeperen): de zijbalk volgt nu de
-- blueprint-kamers. "Me" is gesplitst in This week / My characters; Codex bundelt
-- alle kennis (gidsen); Tools en Settings staan apart. Titels hergebruiken
-- bestaande locale-keys (TAB_CODEX/TAB_SETTINGS), dus geen nieuwe sleutels nodig.
-- Stap 2 maakt hier klikbare icoon-kamerknoppen van. Home blijft de default/
-- fallback-tab in SelectTab (sidebar-volgorde staat daar los van).
local SIDEBAR_SECTIONS = {
	{ key = "me_now", room = "me", titleKey = "SIDEBAR_SECTION_WEEK", ids = { "home", "starthere", "delves", "rares", "world", "events" } },
	-- The old single "Character" list was an eight-noun wall with no scannable bucket:
	-- someone hunting a collectible mount had nowhere obvious to look. Four named
	-- groups; no tab moved out of reach (Rob, 10 jul).
	{ key = "me_collections", room = "me", titleKey = "SIDEBAR_SECTION_COLLECTIONS", ids = { "mounts", "tradingpost", "achievements" } },
	{ key = "me_gear", room = "me", titleKey = "SIDEBAR_SECTION_GEAR", ids = { "enchants", "tier" } },
	{ key = "me_resources", room = "me", titleKey = "SIDEBAR_SECTION_RESOURCES", ids = { "currency", "omnium" } },
	{ key = "me_alts", room = "me", titleKey = "SIDEBAR_SECTION_ALTS", ids = { "account", "delvelog" } },
	{ key = "codex", room = "codex", titleKey = "TAB_CODEX", ids = { "codex", "dungeons", "raids", "guide", "smcguide" } },
	{ key = "tools", room = "tools", titleKey = "SIDEBAR_SECTION_TOOLS", ids = { "toolslaunch", "toolbox", "addons" } },
	{ key = "settings", room = "settings", titleKey = "TAB_SETTINGS", ids = { "settings" } },
}

-- 1.9.0 Phase 2 stap 2: klikbare icoon-kamerknoppen bovenaan de zijbalk. Elke
-- kamer toont alleen z'n eigen secties; de actieve kamer wordt AFGELEID van de
-- huidige tab (geen aparte staat om te syncen). Klikken op een kamer opent de
-- eerste zichtbare tab erin. Labels: SIDEBAR_ROOM_ME/_CODEX nieuw; Tools/Settings
-- hergebruiken bestaande keys.
local SIDEBAR_ROOMS = {
	{ id = "me", labelKey = "SIDEBAR_ROOM_ME", icon = "Interface\\Icons\\Achievement_Character_Human_Male", defaultTab = "home" },
	{ id = "codex", labelKey = "SIDEBAR_ROOM_CODEX", icon = "Interface\\Icons\\INV_Misc_Book_09", defaultTab = "codex" },
	{ id = "tools", labelKey = "SIDEBAR_ROOM_TOOLS", icon = "Interface\\Icons\\Trade_Engineering", defaultTab = "toolslaunch" },
	{ id = "settings", labelKey = "TAB_SETTINGS", icon = "Interface\\Icons\\INV_Misc_Gear_01", defaultTab = "settings" },
}
local SIDEBAR_ROOM_BY_ID = {}
for _, r in ipairs(SIDEBAR_ROOMS) do
	SIDEBAR_ROOM_BY_ID[r.id] = r
end

local function MHRoomForTab(tabId)
	for _, section in ipairs(SIDEBAR_SECTIONS) do
		for _, id in ipairs(section.ids) do
			if id == tabId then
				return section.room
			end
		end
	end
	return nil
end

local function MHActiveRoom()
	return MHRoomForTab(ns.uiSelectedTab) or "me"
end

-- Phase 3 cross-links: interactieve tabs met een Codex-tegenhanger. De
-- titelbalk-knop "Read in Codex" springt naar die Codex-categorie.
local TAB_TO_CODEX = {
	delves = "delves",
	dungeons = "dungeons",
	world = "world",
	currency = "currencies",
	omnium = "weekly",
}

local SIDEBAR_SECTION_GAP = 10
local SIDEBAR_HEADER_HEIGHT = 16

-- (Simpele modus / Tier 3 uitgefaseerd in Phase 2 — de kamer-rail verving 'm; alle
-- resten opgeruimd in F3.8.)

local function SidebarTabVisible(tabId)
	if tabId == "omnium" and not (ns.IsOmniumFolioAvailable and ns.IsOmniumFolioAvailable()) then
		return false -- 12.0.7-content: alleen op clients >= 120007
	end
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
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
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
	if tabId == "codex" then
		-- The embedded Reference category keeps its own help text.
		if ns.GetActiveCodexCategory and ns.GetActiveCodexCategory() == "reference" then
			return "INFO_DRAWER_BODY_REFERENCE"
		end
		return "INFO_DRAWER_BODY_CODEX"
	elseif tabId == "home" then
		return "INFO_DRAWER_BODY_HOME"
	elseif tabId == "starthere" then
		return "INFO_DRAWER_BODY_STARTHERE"
	elseif tabId == "dungeons" then
		return "INFO_DRAWER_BODY_DUNGEONS"
	elseif tabId == "events" then
		return "INFO_DRAWER_BODY_EVENTS"
	elseif tabId == "omnium" then
		return "INFO_DRAWER_BODY_OMNIUM"
	elseif tabId == "toolslaunch" then
		return "INFO_DRAWER_BODY_TOOLSLAUNCH"
	elseif tabId == "delves" then
		return "INFO_DRAWER_BODY_DELVES"
	elseif tabId == "account" then
		return "INFO_DRAWER_BODY_ACCOUNT"
	elseif tabId == "rares" then
		return "INFO_DRAWER_BODY_RARES"
	elseif tabId == "achievements" then
		return "INFO_DRAWER_BODY_ACHIEVEMENTS"
	elseif tabId == "world" then
		return "INFO_DRAWER_BODY_WORLD"
	elseif tabId == "delvelog" then
		return "INFO_DRAWER_BODY_DELVELOG"
	elseif tabId == "enchants" then
		return "INFO_DRAWER_BODY_ENCHANTS"
	elseif tabId == "tier" then
		return "INFO_DRAWER_BODY_TIER"
	elseif tabId == "smcguide" then
		return "INFO_DRAWER_BODY_SMC"
	elseif tabId == "currency" then
		return "INFO_DRAWER_BODY_CURRENCY"
	elseif tabId == "professions" then
		return "INFO_DRAWER_BODY_PROFESSIONS"
	elseif tabId == "guide" then
		return "INFO_DRAWER_BODY_GUIDE"
	elseif tabId == "toolbox" then
		-- Per-sub-tab help text inside the merged Toolbox tab.
		local sid = ns.uiSelectedToolboxSubTab or "consumables"
		if sid == "macros" then
			return "INFO_DRAWER_BODY_MACROS"
		elseif sid == "academy" then
			return "INFO_DRAWER_BODY_ACADEMY"
		elseif sid == "professionsHub" then
			local inner = ns.uiSelectedProfHubInner or "overview"
			if inner == "treasures" then
				return "INFO_DRAWER_BODY_PROFESSIONS"
			elseif inner == "course" then
				return "INFO_DRAWER_BODY_PROFACADEMY"
			end
			return "INFO_DRAWER_BODY_PROFHUB"
		end
		return "INFO_DRAWER_BODY_CONSUMABLES"
	elseif tabId == "addons" then
		return "INFO_DRAWER_BODY_ADDONS"
	elseif tabId == "settings" then
		return "INFO_DRAWER_BODY_SETTINGS"
	end
	return "INFO_DRAWER_BODY_HOME"
end

--- Apply ns:L() to the main shell (tabs, search row, SMC headers, side helpers). See Locales/*.lua.
function ns:RefreshLocaleUI()
	if self.ApplyBindingLabels then
		self:ApplyBindingLabels()
	end
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
	if ns.mhSearchPlaceholder then
		ns.mhSearchPlaceholder:SetText(self:L("SEARCH_PLACEHOLDER"))
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

	-- Toolbox sub-tab buttons + sub-panel headers (their ids are no longer in
	-- TAB_DEFS, so the generic tab relabel loop above does not cover them).
	if ns.toolboxSubTabButtons and ns._mhToolboxSubTabDefs then
		for _, def in ipairs(ns._mhToolboxSubTabDefs) do
			local btn = ns.toolboxSubTabButtons[def.id]
			if btn and btn.SetText then
				btn:SetText(self:L(def.labelKey))
			end
			local panel = self.panels and self.panels[def.id]
			if panel and panel._header and panel._header.SetText then
				panel._header:SetText(self:L(def.labelKey))
			end
		end
		if ns.RelayoutToolboxSubNav then
			ns.RelayoutToolboxSubNav()
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
		refs.content:SetPoint("TOPLEFT", refs.favRow or refs.searchBar, "BOTTOMLEFT", m.sidebarWidth, 0)
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

local function MHRefreshToolboxSubTabChrome(activeSubId)
	if not ns.toolboxSubTabButtons then
		return
	end
	for id, btn in pairs(ns.toolboxSubTabButtons) do
		if id == activeSubId then
			btn:SetAlpha(1)
			MHTintButtonTextures(btn, MH_CHROME.tabTexActive[1], MH_CHROME.tabTexActive[2], MH_CHROME.tabTexActive[3])
		else
			btn:SetAlpha(0.88)
			MHTintButtonTextures(btn, MH_CHROME.tabTexInactive[1], MH_CHROME.tabTexInactive[2], MH_CHROME.tabTexInactive[3])
		end
	end
end

--- Reposition Toolbox sub-tab buttons, hiding beta-gated ones (macros/academy)
--- when their Settings checkbox is off. Called at build, on locale switch, and
--- from RefreshBetaTabVisibility.
function ns.RelayoutToolboxSubNav()
	local defs = ns._mhToolboxSubTabDefs
	local btns = ns.toolboxSubTabButtons
	local host = ns.panels and ns.panels.toolbox
	local subNav = host and host._mhSubNav
	if not defs or not btns or not subNav then
		return
	end
	local x = 0
	for _, def in ipairs(defs) do
		local btn = btns[def.id]
		if btn then
			local visible = (not def.beta) or (ns.IsBetaTabEnabled and ns.IsBetaTabEnabled(def.id))
			if visible then
				btn:ClearAllPoints()
				btn:SetPoint("TOPLEFT", subNav, "TOPLEFT", x, -6)
				btn:Show()
				x = x + (btn:GetWidth() or 120) + 6
			else
				btn:Hide()
			end
		end
	end
end

--------------------------------------------------------------------------------
-- SMC City Guide (Midnight 12.0.5)
--------------------------------------------------------------------------------
local SMC_CITY_MAP_ID = 2393

--- ⚠️ EVERY PIN HERE USED TO CARRY A HARDCODED DUTCH SENTENCE.
---
--- Rob runs the addon on `auto`, which resolves to English, and on 12 Aug 2026 he
--- noticed the city guide's tooltips were Dutch. All 43 of them were, in every language,
--- since the page was built — the single largest untranslated surface in the addon.
---
--- Thirty of those sentences said nothing their own label did not already say: "Zet een
--- waypoint naar de Alchemy trainer" under a button that reads *Alchemy*. Those are gone
--- rather than translated, and the text is built from the label instead. Seven languages
--- times thirty sentences is the kind of bulk edit that broke three locale files on
--- 22 July; not writing them at all is better than writing them carefully.
---
--- So a pin now says nothing about its own description and gets the generic line, or sets
--- `trainer = true` for the profession phrasing, or names a `descKey` when it genuinely
--- has something to add. Anything still holding a literal `description` is a leftover
--- from the second pass and renders as it always did.
---
--- ⏭️ STILL DUTCH, deliberately (round two): the fifteen pins that carry real content, and
--- the seven category titles. Those need real translations, not a template.
--- A category heading, through the locale. Same reasoning as PinDescription: the seven
--- headings were English literals, which nobody in English ever noticed and nobody in
--- German could ever fix.
local function CategoryTitle(cat)
	if not cat then
		return ""
	end
	if cat.titleKey then
		return ns:L(cat.titleKey)
	end
	return cat.title or ""
end

local function PinDescription(point)
	if not point then
		return ""
	end
	if point.descKey then
		return ns:L(point.descKey)
	end
	if point.description then
		return point.description
	end
	local fmt = ns:L(point.trainer and "SMC_PIN_TRAINER_FMT" or "SMC_PIN_GOTO_FMT")
	local okFmt, text = pcall(string.format, fmt, tostring(point.label or "?"))
	return okFmt and text or tostring(point.label or "")
end

local SMC_CATEGORIES = {
	{
		titleKey = "SMC_CAT_ESSENTIAL",
		items = {
			{ id = "bank", label = "Bank & Vault", atlas = "services-icon-bank", x = 50.36, y = 65.19 },
			{ id = "item_upgrades", label = "Cuzoth — Item Upgrades", descKey = "SMC_PIN_ITEM_UPGRADES", atlas = "ItemUpgrade-FX-UpgradeArrow", x = 48.23, y = 61.75 },
			{ id = "crest_exchange", label = "Vaskarn — Crest Exchange", descKey = "SMC_PIN_CREST_EXCHANGE", atlas = "WarWithin-Icon-Crest", x = 48.28, y = 61.75 },
			{ id = "ah", label = "Auction House", atlas = "services-icon-auctioneer", x = 51.50, y = 74.68 },
			{ id = "mailbox", label = "Mailbox", atlas = "services-icon-mailroom", x = 49.41, y = 65.92 },
			{ id = "inn_cooking", label = "Inn & Cooking", atlas = "services-icon-innkeeper", x = 56.28, y = 70.33 },
			{ id = "trading_post", label = "Trading Post", atlas = "ui-delves", x = 48.88, y = 78.15 },
			{ id = "bmah", label = "BMAH", atlas = "services-icon-auctioneer", x = 51.86, y = 48.56 },
			{ id = "transmog", label = "Transmog", atlas = "services-icon-transmogrifier", x = 52.87, y = 57.44 },
			{ id = "crafting_orders", label = "Crafting Orders (Mar'nah)", atlas = "services-icon-battlenet", x = 45.0, y = 55.6 },
			--- ⚠️ COORDINATEN GEMETEN, NIET UIT EEN GIDS. Rob stond bij hem en draaide
			--- `/mh capture` op 12 aug 2026: map 2393, 45.03 / 56.20. De gids die dit
			--- aanreikte zei 44.95 / 56.07 — dichtbij, en dichtbij is precies hoe je iemand
			--- naast een NPC laat landen.
			---
			--- ⚠️ DE TEKST KOMT UIT ZIJN EIGEN BEVESTIGINGSVENSTER, woordelijk: "You will
			--- lose all associated recipes and be able to re-allocate your knowledge as you
			--- see fit. This can only be done ONCE." De research die hier binnenkwam zei dat
			--- recepten "tijdelijk" weg zijn en vanzelf terugkomen als je identiek herbesteedt.
			--- Dat staat er niet, en het is de ene zin die iemand zijn recepten kan kosten.
			--- Het spel belooft niets terug — dus wij ook niet.
			{ id = "prof_reset", label = "Theremis — Specializations resetten", descKey = "SMC_PIN_PROF_RESET", atlas = "services-icon-trainer", x = 45.03, y = 56.20 },
			{ id = "creation_catalyst", label = "Creation Catalyst", descKey = "SMC_PIN_CREATION_CATALYST", atlas = "creationcatalyst-32x32", x = 40.31, y = 64.85 },
		},
	},
	{
		titleKey = "SMC_CAT_VENDORS",
		items = {
			--- ⚠️ COORDS STILL UNCONFIRMED for both of these — they came from Wowhead
			--- (npc 255473 Maren, npc 255476 Triam, listed there as "Cosmetic Equipment
			--- Salvager") and nobody has stood next to them with `/mh capture`. Both
			--- point at the Ritual/Void hub, which is where they are said to be.
			---
			--- That caveat used to sit in the tooltip, where the player read
			--- "bevestig coords in-game" — an instruction to us, in a sentence meant for
			--- them. It belongs here. If a route lands you beside empty ground, this is
			--- the line that says why.
			{ id = "maren_silverwing", label = "Maren Silverwing — Gear caches", descKey = "SMC_PIN_MAREN_SILVERWING", atlas = "WarWithin-Icon-Crest", x = 48.11, y = 49.10 },
			{ id = "triam_dawnsetter", label = "Triam Dawnsetter — Transmog (cosmetics)", descKey = "SMC_PIN_TRIAM_DAWNSETTER", atlas = "services-icon-transmogrifier", x = 48.11, y = 49.10 },
		},
	},
	{
		titleKey = "SMC_CAT_TRAVEL",
		items = {
			{ id = "portals", label = "Portal Room", atlas = "portal-horde-white", x = 53.37, y = 66.31 },
			{ id = "portal_voidstorm", label = "Portal to Voidstorm", atlas = "portal-horde-white", x = 35.25, y = 65.85 },
			{ id = "portal_harandar", label = "Portal to Harandar", atlas = "portal-horde-white", x = 36.76, y = 68.52 },
			{ id = "timeways", label = "Timeways (Lindormi)", atlas = "portal-horde-white", x = 42.30, y = 58.30 },
			{ id = "mplus_teleports", label = "M+ Teleports", atlas = "flightmaster", x = 42.03, y = 58.30 },
		},
	},
	{
		titleKey = "SMC_CAT_QUEST_HUBS",
		items = {
			{
				id = "world_boss_week",
				label = "World boss this week",
				descKey = "SMC_PIN_WORLD_BOSS_WEEK",
				atlas = "groupfinder-icon-flag",
				action = "worldboss_week",
				x = 48.95,
				y = 64.92,
			},
			{ id = "prey_hub", label = "Prey Hub", atlas = "ui-delves", x = 56.19, y = 65.33 },
			{ id = "astalor", label = "Magister Astalor Bloodsworn", atlas = "services-icon-transmogrifier", x = 55.00, y = 63.40 },
			{ id = "weekly_hub", label = "Weekly Quest Givers", descKey = "SMC_PIN_WEEKLY_HUB", atlas = "services-icon-innkeeper", x = 48.95, y = 64.92 },
			-- Eén knop voor twee systemen kon maar één ding doen, en werd dus de
			-- enige in dit raster die je niet ergens heen stuurde (Rob, 28 jul).
			-- Gesplitst, want de bestemmingen verschillen echt van aard: de
			-- ritual site is één obelisk met exacte coords die weekelijks
			-- rouleert, de void assault heeft géén enkel punt (strikes worden
			-- los gemarkeerd) en kan alleen naar de staging-hub wijzen.
			{ id = "ritual_hub", label = "Ritual Site (active)", descKey = "SMC_PIN_RITUAL_HUB", atlas = "groupfinder-icon-flag", action = "ritual_site", x = 48.2, y = 49.4 },
			{ id = "void_hub", label = "Void Assault hub", descKey = "SMC_PIN_VOID_HUB", atlas = "groupfinder-icon-flag", action = "void_hub", x = 48.2, y = 49.4 },
			{ id = "delves_hq", label = "Delves HQ", atlas = "ui-delves", x = 52.10, y = 77.70 },
			{ id = "valeera_delves", label = "Valeera Sanguinar (Delves)", atlas = "ui-delves", x = 52.40, y = 78.20 },
			{ id = "training_dummies", label = "Training Dummies", atlas = "services-icon-dueling", x = 36.0, y = 84.2 },
			{ id = "pvp_hub", label = "PvP Hub", atlas = "pvpqueue-icon-honor", x = 34.40, y = 81.00 },
		},
	},
	{
		titleKey = "SMC_CAT_HORDE",
		items = {
			{ id = "horde_inn", label = "Horde Inn", atlas = "services-icon-innkeeper", x = 66.91, y = 62.09 },
			{ id = "horde_bank", label = "Horde Bank & Vault", atlas = "services-icon-bank", x = 72.04, y = 64.87 },
			{ id = "horde_ah", label = "Horde Auction House", atlas = "services-icon-auctioneer", x = 67.64, y = 70.74 },
			{ id = "horde_creation_catalyst", label = "Horde Creation Catalyst", atlas = "creationcatalyst-32x32", x = 70.06, y = 83.27 },
		},
	},
	{
		titleKey = "SMC_CAT_PROFESSIONS",
		items = {
			{ id = "alchemy", label = "Alchemy", trainer = true, atlas = "ui-profession-alchemy", x = 47.02, y = 51.88 },
			{ id = "blacksmithing", label = "Blacksmithing", trainer = true, atlas = "ui-profession-blacksmithing", x = 43.74, y = 51.33 },
			{ id = "enchanting", label = "Enchanting", trainer = true, atlas = "ui-profession-enchanting", x = 47.97, y = 53.63 },
			{ id = "engineering", label = "Engineering", trainer = true, atlas = "ui-profession-engineering", x = 43.53, y = 54.01 },
			{ id = "inscription", label = "Inscription", trainer = true, atlas = "ui-profession-inscription", x = 46.78, y = 51.48 },
			{ id = "jewelcrafting", label = "Jewelcrafting", trainer = true, atlas = "ui-profession-jewelcrafting", x = 47.93, y = 55.15 },
			{ id = "leatherworking", label = "Leatherworking", trainer = true, atlas = "ui-profession-leatherworking", x = 43.15, y = 55.70 },
			{ id = "tailoring", label = "Tailoring", trainer = true, atlas = "ui-profession-tailoring", x = 48.25, y = 54.15 },
		},
	},
	{
		titleKey = "SMC_CAT_GATHERING",
		items = {
			{ id = "fishing", label = "Fishing", descKey = "SMC_PIN_FISHING", atlas = "ui-profession-fishing", x = 44.70, y = 60.20 },
			{ id = "herbalism_trainer", label = "Herbalism Trainer", atlas = "ui-profession-herbalism", x = 48.20, y = 51.52 },
			{ id = "mining_trainer", label = "Mining Trainer", atlas = "ui-profession-mining", x = 42.68, y = 52.84 },
			{ id = "skinning_trainer", label = "Skinning Trainer", atlas = "ui-profession-skinning", x = 43.27, y = 55.59 },
		},
	},
}

-- Search helpers (Guide.lua): keyword blobs per waypoint + scroll target after panel build.
--- ⚠️ REBUILT ON A LANGUAGE SWITCH, because the blobs now contain translated text.
--- They used to hold the hardcoded Dutch, which was wrong but at least never went stale;
--- resolving through the locale means a `/mh lang` would otherwise leave the index
--- searching for words the tooltips no longer show.
local function BuildSMCSearchRows()
	local rows = {}
	for _, cat in ipairs(SMC_CATEGORIES) do
		for _, point in ipairs(cat.items or {}) do
			local blob = string.lower(
				string.format(
					"%s %s %s %s",
					tostring(CategoryTitle(cat)),
					tostring(point.label or ""),
					tostring(PinDescription(point)),
					tostring(point.id or "")
				)
			)
			rows[#rows + 1] = { blob = blob, point = point }
		end
	end
	ns._mhSMCGuideSearchRows = rows
end

do
	BuildSMCSearchRows()
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		BuildSMCSearchRows()
	end
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

	if point.action == "world_tab" then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("world")
		end
		return
	end

	-- Route without opening the World tab: Rob asked for that on 9 jul, so the
	-- arrow starts pointing immediately instead of burying you in a screen. The
	-- tab is still a click away when the destination is not known.
	local function OpenWorldTab()
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("world")
		end
	end

	if point.action == "ritual_site" then
		local site = ns.GetActiveRitualSite and ns.GetActiveRitualSite() or nil
		if site and ns.RouteRitualSite and site.mapID and site.x and site.y then
			ns.RouteRitualSite(site)
		else
			OpenWorldTab() -- no active site known; do not invent a destination
		end
		return
	end

	if point.action == "void_hub" then
		if ns.RouteVoidHub then
			ns.RouteVoidHub()
		else
			OpenWorldTab()
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

	-- Drive MidnightHelper's own on-screen arrow too (SMC sets its waypoint directly,
	-- so it wasn't engaging NativeArrow). Give it a lead + generic ownership, resetting
	-- a stale single-dest route so the arrow points here.
	ns.lastTarget = { mapID = mapID, x = tonumber(point.x) or 0, y = tonumber(point.y) or 0, name = point.label }
	local o = ns._mhRouteOwner
	if o == nil or o == "waypoint" or o == "delve" then
		ns._mhRouteOwner = "waypoint"
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

-- Shared label for the SMC "World boss this week" shortcut. Shows the boss
-- name whenever we know it (live API, week-anchored cache, SavedVariables
-- kill data) and falls back to the rotation guess WITH the name + an "open
-- map to confirm" suffix — the Home dashboard already displays the same
-- schedule guess, so the button no longer hides a name we do show elsewhere
-- (Rob, 10 Jun). Only when no boss is known at all does the bare
-- "(open map)" label remain.
local function SMCWorldBossButtonText()
	local boss, fromClient = ns.GetActiveWorldBoss and ns.GetActiveWorldBoss()

	-- If we already know warband completion from SavedVariables, show the boss name even when
	-- Blizzard task/map APIs haven't loaded on this character yet.
	if (not fromClient) and ns.db and ns.db.ui and ns.db.ui.worldBossWeek and ns.db.ui.worldBossWeek.bossId and ns.WORLD_BOSSES then
		local wantId = ns.db.ui.worldBossWeek.bossId
		for i = 1, #ns.WORLD_BOSSES do
			local b = ns.WORLD_BOSSES[i]
			if b and b.id == wantId then
				boss = b
				fromClient = true
				break
			end
		end
	end

	local name = boss and boss.labelKey and ns.L and ns:L(boss.labelKey) or "?"
	local confirmed = fromClient or (ns.IsWorldBossKilled and boss and ns.IsWorldBossKilled(boss))
	if confirmed and name ~= "?" then
		return ns:L("WB_SMC_BUTTON_FMT"):format(name)
	end
	if boss and name ~= "?" then
		return ns:L("WB_SMC_BUTTON_UNCONFIRMED_FMT"):format(name)
	end
	return ns:L("WB_SMC_BUTTON_GUESS")
end

-- Update the special \"World boss this week\" SMC shortcut label.
function ns.MH_RefreshSMCWorldBossShortcut()
	local sg = ns.panels and ns.panels.smcguide
	local list = sg and sg._mhSMCWaypointButtons
	if type(list) ~= "table" then
		return
	end

	local text = SMCWorldBossButtonText()

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
	subtitle:SetTextColor(0.75, 0.78, 0.82)
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
		-- Tier-2: geen border-box meer rond de SMC-scroll (geen ander paneel heeft
		-- die → liet de SMC-gids "als een andere addon" ogen). Onzichtbaar gemaakt.
		smcRim:SetBackdropBorderColor(0, 0, 0, 0)
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
	smcScrollFill:SetColorTexture(0.048, 0.05, 0.062, 1) -- = MH_CHROME.contentWell, gelijk aan de andere panelen

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
		header:SetText(CategoryTitle(cat))
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
				label:SetText(SMCWorldBossButtonText())
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
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				GameTooltip:SetText(point.label, 1, 0.9, 0.6)
				GameTooltip:AddLine(PinDescription(point), 0.9, 0.9, 0.9, true)
				GameTooltip:AddLine(("Map 2393 • %.2f, %.2f"):format(point.x, point.y), 0.8, 0.8, 0.8, false)
				GameTooltip:AddLine(ns:L("SMC_PIN_CLICK_HINT"), 0.7, 0.8, 1, true)
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
	{ id = "starthere", labelKey = "TAB_START_HERE" },
	{ id = "dungeons", labelKey = "TAB_DUNGEONS" },
	{ id = "codex", labelKey = "TAB_CODEX" },
	{ id = "home", labelKey = "TAB_HOME" },
	{ id = "delves", labelKey = "TAB_DELVES" },
	{ id = "account", labelKey = "TAB_ACCOUNT_SNAPSHOT" },
	{ id = "rares", labelKey = "TAB_RARES" },
	{ id = "achievements", labelKey = "TAB_ACHIEVEMENTS" },
	{ id = "mounts", labelKey = "TAB_MOUNTS" },
	{ id = "tradingpost", labelKey = "TAB_TRADINGPOST" },
	{ id = "raids", labelKey = "TAB_RAIDS" },
	{ id = "world", labelKey = "TAB_WORLD" },
	{ id = "events", labelKey = "TAB_EVENTS" },
	{ id = "delvelog", labelKey = "TAB_DELVE_LOG" },
	{ id = "enchants", labelKey = "TAB_ENCHANTS" },
	{ id = "tier", labelKey = "TAB_TIER" },
	{ id = "omnium", labelKey = "TAB_OMNIUM" },
	-- reference is no longer top-level: it lives in the Codex as a category;
	-- SelectTab("reference") still works via the alias below.
	{ id = "smcguide", labelKey = "TAB_SMC" },
	{ id = "currency", labelKey = "TAB_CURRENCY" },
	-- professions is no longer top-level: it lives in the Toolbox as a sub-tab;
	-- SelectTab("professions") still works via the alias below.
	{ id = "guide", labelKey = "TAB_GUIDE" },
	-- Toolbox bundles the former macros/consumables/academy top-level tabs as
	-- sub-tabs; legacy tab ids still route there via the alias in SelectTab.
	{ id = "toolslaunch", labelKey = "TAB_TOOLSLAUNCH" },
	{ id = "toolbox", labelKey = "TAB_TOOLBOX" },
	{ id = "addons", labelKey = "TAB_ADDONS" },
	{ id = "settings", labelKey = "TAB_SETTINGS" },
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
	UpdateMaxWindowBounds()
	local initW = GetSavedMainWidth()
	local initH = ResolveMainHeightForOpen()
	main:SetSize(initW, initH)
	main:SetPoint("CENTER")
	-- HIGH strata so the window sits above action bars / keybind buttons (they render
	-- at MEDIUM and were bleeding through the bottom of the window). Below DIALOG so it
	-- doesn't cover real popups/tooltips.
	main:SetFrameStrata("HIGH")
	main:SetToplevel(true) -- clicking the window raises it above other HIGH frames
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
	-- OnDragStop is set later (with the grip handler) so it also persists window
	-- size + position; the earlier duplicate here was dead code (F3.8).

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

	-- About lives here, beside Info — not pinned to the sidebar bottom, where a growing
	-- tab list (Trading Post pushed it over) collided with the last group (Rob, 10 jul).
	local aboutBtn = CreateFrame("Button", "MidnightHelperAboutBtn", titleBar, "UIPanelButtonTemplate")
	aboutBtn:SetSize(56, 22)
	aboutBtn:SetPoint("RIGHT", infoToggleBtn, "LEFT", -4, 0)
	MHTintButtonTextures(aboutBtn, MH_CHROME.tabTexInactive[1], MH_CHROME.tabTexInactive[2], MH_CHROME.tabTexInactive[3])
	aboutBtn:SetText(ns:L("ABOUT_BUTTON"))
	aboutBtn:SetScript("OnClick", function()
		if ns._mhToggleAboutPanel then
			ns:_mhToggleAboutPanel()
		end
	end)

	-- Phase 3 cross-link: "Read in Codex"-knop, verschijnt bij tabs met een
	-- Codex-tegenhanger (gevuld door SelectTab) en springt naar die categorie.
	local codexLinkBtn = CreateFrame("Button", "MidnightHelperCodexLink", titleBar, "UIPanelButtonTemplate")
	codexLinkBtn:SetSize(110, 20)
	codexLinkBtn:SetPoint("RIGHT", aboutBtn, "LEFT", -6, 0)
	MHTintButtonTextures(codexLinkBtn, MH_CHROME.tabTexInactive[1], MH_CHROME.tabTexInactive[2], MH_CHROME.tabTexInactive[3])
	codexLinkBtn:SetText(ns:L("CODEX_LINK_OPEN"))
	codexLinkBtn:SetScript("OnClick", function(self)
		if self._mhCat and ns.SetActiveCodexCategory then
			ns.SetActiveCodexCategory(self._mhCat)
		end
		if ns.SelectTab then
			ns.SelectTab("codex")
		end
	end)
	codexLinkBtn:Hide()
	ns._mhCodexLinkBtn = codexLinkBtn

	-- Phase 3: breadcrumb in de titelbalk toont 'Kamer > Tab' voor oriëntatie.
	-- Gevuld door SelectTab; tussen versie en de Codex-knop/Info.
	local breadcrumb = titleBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	breadcrumb:SetPoint("LEFT", titleVersion, "RIGHT", 14, 0)
	breadcrumb:SetPoint("RIGHT", codexLinkBtn, "LEFT", -8, 0)
	breadcrumb:SetJustifyH("LEFT")
	breadcrumb:SetWordWrap(false)
	breadcrumb:SetTextColor(0.78, 0.72, 0.55)
	if ns.MHScalableFont then
		breadcrumb:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	end
	ns._mhBreadcrumb = breadcrumb

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
		local query = searchEdit:GetText()
		-- Navigation search (the "front door"): a strong tab-name match jumps
		-- straight there; weaker/keyword queries fall through to Codex/Guide.
		if ns.MHNavSearchTryJump and ns.MHNavSearchTryJump(query) then
			return
		end
		-- Codex topics route first (handbook: dawncrest/reference/weekly/...).
		-- Explicitly here at the call site: Guide.lua loads after
		-- MidnightCodex.lua and assigns ns.MH_RunSearchQuery wholesale, which
		-- silently disabled the old wrap-based precedence.
		if ns.TryCodexSearch and ns.TryCodexSearch(query) then
			return
		end
		if ns.MH_RunSearchQuery then
			ns.MH_RunSearchQuery(query)
		else
			print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("SEARCH_NOT_READY")))
		end
	end
	searchEdit:SetScript("OnEnterPressed", function(self)
		runSearchFromBar()
		self:ClearFocus()
	end)

	-- Placeholder inside the box. This bar is the addon's front door — it finds tabs,
	-- tools and every boss we wrote steps for — but a bare "Search:" never tells you
	-- that. Greyed, and gone the moment you focus the box or type in it. Hooked after
	-- the scripts above, since a later SetScript would drop a HookScript chain.
	local searchPlaceholder = searchEdit:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	searchPlaceholder:SetPoint("LEFT", searchEdit, "LEFT", 6, 0)
	searchPlaceholder:SetPoint("RIGHT", searchEdit, "RIGHT", -6, 0)
	searchPlaceholder:SetJustifyH("LEFT")
	searchPlaceholder:SetText(ns:L("SEARCH_PLACEHOLDER"))
	ns.mhSearchPlaceholder = searchPlaceholder

	local function UpdateSearchPlaceholder()
		searchPlaceholder:SetShown((searchEdit:GetText() or "") == "" and not searchEdit:HasFocus())
	end
	searchEdit:HookScript("OnTextChanged", UpdateSearchPlaceholder)
	searchEdit:HookScript("OnEditFocusGained", UpdateSearchPlaceholder)
	searchEdit:HookScript("OnEditFocusLost", UpdateSearchPlaceholder)
	UpdateSearchPlaceholder()
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

	-- Pinned favourites row (1.9.0 Phase 5): a thin strip under the search bar with the
	-- player's most-used destinations for one-click access. Left-click a chip to jump,
	-- right-click to unpin, the "+" opens a menu to pin/unpin any tab. Stored in
	-- ns.db.favourites (tab ids). Sidebar/content anchor to this row (fixed 24px height,
	-- so pinning/unpinning never re-lays out the window).
	local FAV_MAX = 5
	local favRow = CreateFrame("Frame", "MidnightHelperFavRow", main)
	favRow:SetHeight(24)
	favRow:SetPoint("TOPLEFT", searchBar, "BOTTOMLEFT", 0, 0)
	favRow:SetPoint("TOPRIGHT", searchBar, "BOTTOMRIGHT", 0, 0)
	local favRowBg = favRow:CreateTexture(nil, "BACKGROUND")
	favRowBg:SetAllPoints()
	favRowBg:SetColorTexture(0.16, 0.15, 0.18, 0.85)
	local favRowEdge = favRow:CreateTexture(nil, "BORDER")
	favRowEdge:SetHeight(1)
	favRowEdge:SetPoint("BOTTOMLEFT", favRow, "BOTTOMLEFT", 0, 0)
	favRowEdge:SetPoint("BOTTOMRIGHT", favRow, "BOTTOMRIGHT", 0, 0)
	favRowEdge:SetColorTexture(MH_CHROME.separator[1], MH_CHROME.separator[2], MH_CHROME.separator[3], 0.5)
	ns.mhFavRow = favRow

	local MHRenderFavRow -- forward-declared (chip/menu callbacks re-render)
	local function MHFavList()
		ns.db = ns.db or {}
		if type(ns.db.favourites) ~= "table" then
			ns.db.favourites = { "delves", "enchants", "currency" } -- sensible defaults
		end
		return ns.db.favourites
	end
	local function MHIsFav(id)
		for _, v in ipairs(MHFavList()) do
			if v == id then
				return true
			end
		end
		return false
	end
	local function MHToggleFav(id)
		local list = MHFavList()
		for i, v in ipairs(list) do
			if v == id then
				table.remove(list, i)
				return
			end
		end
		if #list < FAV_MAX then
			list[#list + 1] = id
		end
	end

	local function InitFavPinMenu(_, level)
		if not (UIDropDownMenu_CreateInfo and UIDropDownMenu_AddButton) then
			return
		end
		for _, t in ipairs(TAB_DEFS) do
			if SidebarTabVisible(t.id) then
				local info = UIDropDownMenu_CreateInfo()
				info.text = ns:L(t.labelKey)
				info.checked = MHIsFav(t.id)
				info.isNotRadio = true
				info.keepShownOnClick = true
				info.func = function()
					MHToggleFav(t.id)
					MHRenderFavRow()
				end
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end

	local function FavChip(i)
		favRow._chips = favRow._chips or {}
		local c = favRow._chips[i]
		if c then
			return c
		end
		c = CreateFrame("Button", nil, favRow)
		c:SetHeight(18)
		local bg = c:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints()
		bg:SetColorTexture(0.30, 0.28, 0.34, 0.9)
		local hl = c:CreateTexture(nil, "HIGHLIGHT")
		hl:SetAllPoints()
		hl:SetColorTexture(1, 0.82, 0.2, 0.20)
		local fs = c:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		if ns.MHScalableFont then
			fs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		end
		fs:SetPoint("CENTER")
		c.fs = fs
		c:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		c:SetScript("OnClick", function(self, button)
			if button == "RightButton" then
				if self._mhId then
					MHToggleFav(self._mhId)
					MHRenderFavRow()
				end
				return
			end
			if self._mhId then
				if ns.ShowMainUI then
					ns:ShowMainUI()
				end
				if ns.SelectTab then
					ns.SelectTab(self._mhId)
				end
			end
		end)
		c:SetScript("OnEnter", function(self)
			if GameTooltip and self._mhId then
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(ns:L("FAV_CHIP_HINT"), 1, 0.82, 0.2, 1, true)
				GameTooltip:Show()
			end
		end)
		c:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		favRow._chips[i] = c
		return c
	end

	MHRenderFavRow = function()
		local list = MHFavList()
		local x = 8
		local n = 0
		for _, id in ipairs(list) do
			local labelKey = TAB_LABEL_BY_ID[id]
			if labelKey and SidebarTabVisible(id) then
				n = n + 1
				local c = FavChip(n)
				c._mhId = id
				c.fs:SetText(ns:L(labelKey))
				local w = math.max(46, (c.fs:GetStringWidth() or 40) + 16)
				c:SetWidth(w)
				c:ClearAllPoints()
				c:SetPoint("LEFT", favRow, "LEFT", x, 0)
				c:Show()
				x = x + w + 5
			end
		end
		if favRow._chips then
			for j = n + 1, #favRow._chips do
				favRow._chips[j]:Hide()
			end
		end
		local plus = favRow._plus
		if not plus then
			plus = CreateFrame("Button", nil, favRow)
			plus:SetSize(20, 18)
			local pbg = plus:CreateTexture(nil, "BACKGROUND")
			pbg:SetAllPoints()
			pbg:SetColorTexture(0.26, 0.24, 0.30, 0.9)
			local phl = plus:CreateTexture(nil, "HIGHLIGHT")
			phl:SetAllPoints()
			phl:SetColorTexture(1, 0.82, 0.2, 0.22)
			local pfs = plus:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
			pfs:SetPoint("CENTER", 0, -1)
			pfs:SetText("+")
			plus:SetScript("OnClick", function(self)
				if not (UIDropDownMenu_Initialize and ToggleDropDownMenu) then
					return
				end
				if not favRow._pinMenu then
					favRow._pinMenu = CreateFrame("Frame", "MidnightHelperFavPinMenu", UIParent, "UIDropDownMenuTemplate")
				end
				UIDropDownMenu_Initialize(favRow._pinMenu, InitFavPinMenu, "MENU")
				ToggleDropDownMenu(1, nil, favRow._pinMenu, self, 0, 0)
			end)
			plus:SetScript("OnEnter", function(self)
				if GameTooltip then
					GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
					GameTooltip:SetText(ns:L("FAV_PLUS_HINT"), 1, 0.82, 0.2, 1, true)
					GameTooltip:Show()
				end
			end)
			plus:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end)
			favRow._plus = plus
		end
		plus:ClearAllPoints()
		plus:SetPoint("LEFT", favRow, "LEFT", x, 0)
		plus:Show()
	end

	ns.MHRenderFavRow = MHRenderFavRow
	MHRenderFavRow()

	-- Sidebar column for module tabs (left, below the favourites row).
	local sidebar = CreateFrame("Frame", nil, main)
	sidebar:SetWidth(MHGetLayoutMetrics().sidebarWidth)
	sidebar:SetPoint("TOPLEFT", ns.mhFavRow or searchBar, "BOTTOMLEFT", 0, 0)
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

	-- (About button now lives in the title bar beside Info; see above.)

	-- Content region: hosts one visible module panel at a time.
	local content = CreateFrame("Frame", nil, main)
	content:SetPoint("TOPLEFT", ns.mhFavRow or searchBar, "BOTTOMLEFT", MHGetLayoutMetrics().sidebarWidth, 0)
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
				codex = "TAB_CODEX",
				home = "TAB_HOME",
				delves = "TAB_DELVES",
				world = "TAB_WORLD",
				delvelog = "TAB_DELVE_LOG",
				enchants = "TAB_ENCHANTS",
				tier = "TAB_TIER",
				rares = "TAB_RARES",
				events = "TAB_EVENTS",
				account = "TAB_ACCOUNT_SNAPSHOT",
				reference = "TAB_REFERENCE",
				smcguide = "TAB_SMC",
				currency = "TAB_CURRENCY",
				professions = "TAB_PROFESSIONS",
				guide = "TAB_GUIDE",
				macros = "TAB_MACROS",
				academy = "TAB_ACADEMY",
				addons = "TAB_ADDONS",
			}
			local tabName = self:L(TAB_LABEL_BY_ID[tabId] or keyById[tabId] or "TAB_HOME")
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
		if tab.id ~= "addons" and tab.id ~= "guide" and tab.id ~= "toolbox" then
			local panel = CreateModulePanel(tab.id, ns:L(tab.labelKey))
			if tab.id == "smcguide" then
				BuildSMCCityGuidePanel(panel)
			elseif tab.id == "rares" and ns.BuildRaresPanel then
				ns.BuildRaresPanel(panel)
			elseif tab.id == "achievements" and ns.BuildAchievementsPanel then
				ns.BuildAchievementsPanel(panel)
			elseif tab.id == "codex" and ns.BuildCodexPanel then
				ns.BuildCodexPanel(panel)
			elseif tab.id == "home" and ns.BuildHomePanel then
				ns.BuildHomePanel(panel)
			elseif tab.id == "mounts" and ns.BuildMountsPanel then
				ns.BuildMountsPanel(panel)
			elseif tab.id == "tradingpost" and ns.BuildTradingPostPanel then
				ns.BuildTradingPostPanel(panel)
			elseif tab.id == "raids" and ns.BuildRaidsPanel then
				ns.BuildRaidsPanel(panel)
			elseif tab.id == "world" and ns.BuildWorldPanel then
				ns.BuildWorldPanel(panel)
			elseif tab.id == "events" and ns.BuildEventsPanel then
				ns.BuildEventsPanel(panel)
			elseif tab.id == "delvelog" and ns.BuildDelveLogPanel then
				ns.BuildDelveLogPanel(panel)
			elseif tab.id == "enchants" and ns.BuildGearEnchantPanel then
				ns.BuildGearEnchantPanel(panel)
			elseif tab.id == "tier" and ns.BuildTierSetPanel then
				ns.BuildTierSetPanel(panel)
			elseif tab.id == "omnium" and ns.BuildOmniumFolioPanel then
				ns.BuildOmniumFolioPanel(panel)
			elseif tab.id == "currency" and ns.BuildCurrencyGuidePanel then
				ns.BuildCurrencyGuidePanel(panel)
			elseif tab.id == "starthere" and ns.BuildStartHerePanel then
				ns.BuildStartHerePanel(panel)
			elseif tab.id == "dungeons" and ns.BuildDungeonGuidePanel then
				ns.BuildDungeonGuidePanel(panel)
			elseif tab.id == "toolslaunch" and ns.BuildToolsLaunchpad then
				ns.BuildToolsLaunchpad(panel)
			elseif tab.id == "settings" and ns.BuildSettingsPanel then
				ns.BuildSettingsPanel(panel)
			end
		end
	end

	-- Toolbox: Macros + Consumables + Role Academy merged into one tab with a
	-- sub-tab row (same pattern as the Addons host below). The three panels
	-- stay registered in ns.panels under their old ids so existing references
	-- (RefreshLocaleUI, ConsumablesPanel.lua) keep working; SelectTab's
	-- hide-all loop hides them, after which SelectToolboxSubTab re-shows the
	-- active one — same mechanism the Guide host uses for guideBody.
	do
		local toolboxHost = CreateFrame("Frame", "MidnightHelperToolboxHost", content)
		toolboxHost:SetAllPoints()
		toolboxHost:Hide()
		ns.panels.toolbox = toolboxHost

		local subNav = CreateFrame("Frame", nil, toolboxHost)
		subNav:SetHeight(MHGetLayoutMetrics().addonSubNavHeight)
		subNav:SetPoint("TOPLEFT", toolboxHost, "TOPLEFT", 8, -8)
		subNav:SetPoint("TOPRIGHT", toolboxHost, "TOPRIGHT", -8, -8)
		toolboxHost._mhSubNav = subNav

		local line = toolboxHost:CreateTexture(nil, "ARTWORK")
		line:SetHeight(1)
		line:SetPoint("TOPLEFT", subNav, "BOTTOMLEFT", 0, -2)
		line:SetPoint("TOPRIGHT", subNav, "BOTTOMRIGHT", 0, -2)
		line:SetColorTexture(MH_CHROME.separator[1], MH_CHROME.separator[2], MH_CHROME.separator[3], 0.55)

		local subContent = CreateFrame("Frame", nil, toolboxHost)
		subContent:SetPoint("TOPLEFT", subNav, "BOTTOMLEFT", 0, MHGetLayoutMetrics().addonSubContentTopGap)
		subContent:SetPoint("BOTTOMRIGHT", toolboxHost, "BOTTOMRIGHT", -8, 8)
		toolboxHost._mhSubContent = subContent

		-- Same frame contract as CreateModulePanel (header/body placeholders),
		-- but parented to the Toolbox sub-content well.
		local function CreateToolboxSubPanel(id, displayName)
			local panel = CreateFrame("Frame", nil, subContent)
			panel:SetAllPoints()
			panel:Hide()

			local header = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
			header:SetPoint("TOPLEFT", 12, -12)
			header:SetText(displayName)
			panel._header = header

			local body = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			body:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -8)
			body:SetWidth((subContent:GetWidth() or 600) - 24)
			body:SetJustifyH("LEFT")
			body:SetText(ns:L("MODULE_PLACEHOLDER"):format(displayName))
			panel._body = body
			panel:SetScript("OnShow", function()
				body:SetWidth(panel:GetWidth() - 24)
			end)

			ns.panels[id] = panel
			return panel
		end

		-- Consumables first: not beta-gated, so it is the safe default sub-tab.
		ns._mhToolboxSubTabDefs = {
			{ id = "consumables", labelKey = "TAB_CONSUMABLES" },
			{ id = "macros", labelKey = "TAB_MACROS", beta = true },
			{ id = "academy", labelKey = "TAB_ACADEMY", beta = true },
			-- All profession tools live in one hub (Overview | Treasures &
			-- Books | Course); legacy ids route there via the SelectTab alias.
			{ id = "professionsHub", labelKey = "TAB_PROFESSIONS" },
		}
		local TOOLBOX_BUILDERS = {
			consumables = function(p)
				if ns.BuildConsumablesPanel then
					ns.BuildConsumablesPanel(p)
				end
			end,
			macros = function(p)
				if ns.BuildInterruptMacrosPanel then
					ns.BuildInterruptMacrosPanel(p)
				end
			end,
			academy = function(p)
				if ns.BuildRoleAcademyPanel then
					ns.BuildRoleAcademyPanel(p)
				end
			end,
			professionsHub = function(p)
				if ns.BuildProfessionsHubPanel then
					ns.BuildProfessionsHubPanel(p)
				end
			end,
		}

		ns.toolboxSubTabButtons = {}
		ns._mhToolboxSubFrames = {}
		for _, def in ipairs(ns._mhToolboxSubTabDefs) do
			local btn = CreateFrame("Button", "MidnightHelperToolboxSubTab_" .. def.id, subNav, "UIPanelButtonTemplate")
			btn:SetSize(120, MHGetLayoutMetrics().addonSubTabHeight)
			btn:SetText(ns:L(def.labelKey))
			local subId = def.id
			btn:SetScript("OnClick", function()
				if ns.SelectToolboxSubTab then
					ns.SelectToolboxSubTab(subId)
				end
			end)
			ns.toolboxSubTabButtons[def.id] = btn

			local panel = CreateToolboxSubPanel(def.id, ns:L(def.labelKey))
			TOOLBOX_BUILDERS[def.id](panel)
			ns._mhToolboxSubFrames[def.id] = panel
		end
		ns.RelayoutToolboxSubNav()
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

	-- Kamer-rail (Phase 2): 4 icoon+label-knoppen bovenaan de zijbalk. Klikken
	-- opent de eerste zichtbare tab van die kamer (SelectTab herlayout't de rail).
	ns._mhRoomButtons = ns._mhRoomButtons or {}
	local function MHFirstVisibleTabInRoom(roomId)
		for _, section in ipairs(SIDEBAR_SECTIONS) do
			if section.room == roomId then
				for _, id in ipairs(section.ids) do
					if ns.tabButtons and ns.tabButtons[id] and SidebarTabVisible(id) then
						return id
					end
				end
			end
		end
		return nil
	end
	local function MHSelectRoom(roomId)
		local target = MHFirstVisibleTabInRoom(roomId)
		if target then
			SelectTab(target)
		end
	end
	for _, roomDef in ipairs(SIDEBAR_ROOMS) do
		local rb = CreateFrame("Button", "MidnightHelperRoom_" .. roomDef.id, sidebar)
		rb:SetHeight(MHGetLayoutMetrics().sidebarTabHeight)
		local bg = rb:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints()
		bg:SetColorTexture(0.18, 0.16, 0.20, 0.55)
		rb._mhBg = bg
		local icon = rb:CreateTexture(nil, "ARTWORK")
		icon:SetSize(16, 16)
		icon:SetPoint("LEFT", rb, "LEFT", 4, 0)
		icon:SetTexture(roomDef.icon)
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		rb._mhIcon = icon
		local lbl = rb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		lbl:SetPoint("LEFT", icon, "RIGHT", 5, 0)
		lbl:SetPoint("RIGHT", rb, "RIGHT", -4, 0)
		lbl:SetJustifyH("LEFT")
		rb._mhLabel = lbl
		local hl = rb:CreateTexture(nil, "HIGHLIGHT")
		hl:SetAllPoints()
		hl:SetColorTexture(1, 0.82, 0.2, 0.15)
		rb._mhRoomId = roomDef.id
		rb._mhLabelKey = roomDef.labelKey
		rb:SetScript("OnClick", function()
			MHSelectRoom(roomDef.id)
		end)
		ns._mhRoomButtons[roomDef.id] = rb
	end

	-- (Simpele-modus-schakelaar verwijderd — uitgefaseerd in Phase 2 door de kamer-rail;
	-- schreef alleen nog het spookveld ns.db.simpleMode en werd altijd verborgen. F3.8.)

	RelayoutSidebarTabs = function()
		ns._mhSidebarRelaying = true -- recursion-guard: SelectTab relayout't ook
		local lm = MHGetLayoutMetrics()
		local yy = -8


		-- Kamer-rail: 4 knoppen, de actieve gemarkeerd. Daaronder tonen we alleen
		-- de secties van de actieve kamer (afgeleid van de huidige tab).
		local activeRoom = MHActiveRoom()
		if ns._mhRoomButtons then
			for _, roomDef in ipairs(SIDEBAR_ROOMS) do
				local rb = ns._mhRoomButtons[roomDef.id]
				if rb then
					local isActive = (roomDef.id == activeRoom)
					rb:SetSize(lm.sidebarWidth - 16, lm.sidebarTabHeight)
					if rb._mhLabel then
						rb._mhLabel:SetText(ns:L(roomDef.labelKey))
						if isActive then
							rb._mhLabel:SetTextColor(1, 0.95, 0.6)
						else
							rb._mhLabel:SetTextColor(0.82, 0.78, 0.68)
						end
					end
					if rb._mhBg then
						if isActive then
							rb._mhBg:SetColorTexture(0.85, 0.65, 0.13, 0.55)
						else
							rb._mhBg:SetColorTexture(0.18, 0.16, 0.20, 0.55)
						end
					end
					rb:ClearAllPoints()
					rb:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 8, yy)
					rb:Show()
					yy = yy - lm.sidebarTabStep
				end
			end
			yy = yy - SIDEBAR_SECTION_GAP
		end

		-- Eerst ÁLLE tab-knoppen verbergen: knoppen in volledig-verborgen secties
		-- (simpele modus) worden anders nooit aangeraakt en blijven op hun creatie-
		-- positie staan → overlap (Robs screen 1). Daarna plaatsen we de zichtbare.
		if ns.tabButtons then
			for _, b in pairs(ns.tabButtons) do
				if b and b.Hide then
					b:Hide()
				end
			end
		end

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
			if section.room == activeRoom then
				for _, tabId in ipairs(section.ids) do
					local btn = ns.tabButtons and ns.tabButtons[tabId]
					if btn and SidebarTabVisible(tabId) then
						visibleCount = visibleCount + 1
					end
				end
			end

			local header = sidebar._mhSectionHeaders[section.key]
			if not header then
				header = sidebar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
				header:SetJustifyH("LEFT")
				header:SetTextColor(0.91, 0.76, 0.42)
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

		-- Keep the window tall enough for the full sidebar's tabs. About no longer sits
		-- at the sidebar bottom (it moved to the title bar), so we only reserve a little
		-- bottom padding — which is why the last tab used to be crowded by About.
		do
			local tabsHeight = -yy
			local aboutArea = 8
			-- The sidebar is anchored BELOW the favourites row, so its height must be
			-- reserved too — leaving it out made the auto-grow ~24px short, which pushed
			-- the last tab (Delve & Ritual Log in the tall "Me" room) off the bottom edge
			-- (Rob 16 jul). Read the row's real height so compact mode stays correct.
			local favH = (ns.mhFavRow and ns.mhFavRow.GetHeight and ns.mhFavRow:GetHeight()) or 0
			local overhead = MH_MAIN_EDGE.T + TITLE_BAR_HEIGHT + lm.searchBarHeight + favH + MH_MAIN_EDGE.B
			local requiredH = math.min(MAX_HEIGHT, math.ceil(tabsHeight + aboutArea + overhead))
			local minH = math.max(MIN_HEIGHT, requiredH)
			if main and main.SetResizeBounds then
				UpdateMaxWindowBounds()
				main:SetResizeBounds(MIN_WIDTH, minH, MAX_WIDTH, MAX_HEIGHT)
			end
			if main and (main:GetHeight() or 0) < minH then
				-- Programmatic resize: must not mark the window as user-sized.
				ns._mhProgrammaticResize = true
				main:SetHeight(minH)
				ns._mhProgrammaticResize = false
				local dbUi = ns.db and ns.db.ui
				if dbUi then
					dbUi.mainHeight = ClampMainHeight(minH)
				end
			end
		end

		-- Staat de geselecteerde tab niet meer in beeld (beta-gate óf simpele modus
		-- verbergt 'm)? Val terug op Home (altijd zichtbaar).
		if ns.uiSelectedTab and ns.uiSelectedTab ~= "home" and not SidebarTabVisible(ns.uiSelectedTab) then
			SelectTab("home")
		elseif ns.uiSelectedTab == "guide" and ns.IsGuideTabEnabled and not ns:IsGuideTabEnabled() then
			SelectTab("home")
		end
		ns._mhSidebarRelaying = false
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

	-- Remember where the user dragged the window (F4.6). Stored relative to UIParent.
	local function SaveMainWindowPosition()
		local dbUi = ns.db and ns.db.ui
		if not dbUi then
			return
		end
		local point, _, relativePoint, x, y = main:GetPoint(1)
		if not point then
			return
		end
		dbUi.mainPoint = {
			point = point,
			relativePoint = relativePoint,
			x = math.floor(x or 0),
			y = math.floor(y or 0),
		}
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
		-- Only persist user-driven resizes; programmatic SetHeight/SetSize calls
		-- (RelayoutSidebarTabs, Delves min-height, ApplySavedMainWindowSize) set
		-- this flag so they don't flip mainWindowUserSized and kill auto-sizing.
		if ns._mhProgrammaticResize then
			return
		end
		SaveMainWindowSize()
	end)
	titleBar:SetScript("OnDragStop", function()
		main:StopMovingOrSizing()
		if ns._mhLayoutRefs and ns._mhLayoutRefs.reanchorInfoWindow then
			ns._mhLayoutRefs.reanchorInfoWindow()
		end
		SaveMainWindowSize()
		SaveMainWindowPosition()
	end)
	grip:SetScript("OnDragStop", function()
		main:StopMovingOrSizing()
		if ns._mhLayoutRefs and ns._mhLayoutRefs.reanchorInfoWindow then
			ns._mhLayoutRefs.reanchorInfoWindow()
		end
		SaveMainWindowSize()
		SaveMainWindowPosition()
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
		favRow = favRow,
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

	-- Old keys: the standalone Great Vault ("vault") and Companion tabs merged into the
	-- Delves dashboard. NB: do NOT remap "dungeons" — that is a real tab again (F3.8).
	if ns.uiSelectedTab == "vault" or ns.uiSelectedTab == "companion" then
		ns.uiSelectedTab = "delves"
	end

	-- Default tab on first open
	SelectTab(ns.uiSelectedTab or "home")
	ns:ApplySavedMainWindowSize()
	ns:_mhRefreshSidePanel(ns.uiSelectedTab or "home")

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
	-- Legacy ids from before the Toolbox merge (saved tabs, Guide.lua
	-- navigation, slash commands) route to the matching Toolbox sub-tab.
	if tabId == "macros" or tabId == "consumables" or tabId == "academy" then
		ns.uiSelectedToolboxSubTab = tabId
		tabId = "toolbox"
	end
	-- Profession tools were merged into one hub sub-tab with inner tabs;
	-- legacy ids land on the matching inner tab.
	if tabId == "professions" or tabId == "profacademy" or tabId == "profoverview" then
		-- "professions" has always landed on Treasures & Books, which is fine for the
		-- legacy id but wrong for anyone sent here to SPEND Knowledge -- the advice
		-- lives on Overview. Hence a third id rather than changing what the old one
		-- does (Rob clicked a KP line and got a treasure list, 2026-07-22).
		local inner = "treasures"
		if tabId == "profacademy" then
			inner = "course"
		elseif tabId == "profoverview" then
			inner = "overview"
		end
		ns.uiSelectedProfHubInner = inner
		ns.uiSelectedToolboxSubTab = "professionsHub"
		tabId = "toolbox"
	end
	-- Same for the former Reference tab: now a Codex category.
	if tabId == "reference" then
		if ns.SetActiveCodexCategory then
			ns.SetActiveCodexCategory("reference")
		end
		tabId = "codex"
	end
	if tabId == "guide" and ns.IsGuideTabEnabled and not ns:IsGuideTabEnabled() then
		tabId = "home"
	end
	if not ns.panels or not ns.panels[tabId] then
		-- Saved/stale tab id no longer exists (e.g. merged or removed tab): fall
		-- back to Home rather than leaving the window blank.
		if ns.panels and ns.panels["home"] then
			tabId = "home"
		else
			return
		end
	end

	ns.uiSelectedTab = tabId

	-- Phase 3: breadcrumb 'Kamer > Tab' bijwerken (oriëntatie in de titelbalk).
	if ns._mhBreadcrumb then
		local roomId = MHRoomForTab(tabId)
		local roomDef = roomId and SIDEBAR_ROOM_BY_ID[roomId]
		local roomLabel = (roomDef and ns:L(roomDef.labelKey)) or ""
		local tabKey = TAB_LABEL_BY_ID[tabId]
		local tabLabel = (tabKey and ns:L(tabKey)) or ""
		local text = roomLabel
		if tabLabel ~= "" and tabLabel ~= roomLabel then
			text = (roomLabel ~= "" and (roomLabel .. "  >  ") or "") .. tabLabel
		end
		ns._mhBreadcrumb:SetText(text)
	end

	-- Phase 3 cross-link: toon "Read in Codex" als deze tab een Codex-categorie heeft.
	if ns._mhCodexLinkBtn then
		local cat = (tabId ~= "codex") and TAB_TO_CODEX[tabId] or nil
		if cat then
			ns._mhCodexLinkBtn._mhCat = cat
			ns._mhCodexLinkBtn:Show()
		else
			ns._mhCodexLinkBtn._mhCat = nil
			ns._mhCodexLinkBtn:Hide()
		end
	end

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

	if tabId == "rares" and ns.RefreshRaresPanel then
		ns.RefreshRaresPanel()
	end

	if tabId == "codex" and ns.RefreshCodexPanel then
		ns.RefreshCodexPanel()
	end
	if tabId == "home" and ns.RefreshHomePanel then
		ns.RefreshHomePanel()
	end
	if tabId == "world" and ns.RefreshWorldPanel then
		ns.RefreshWorldPanel()
	end
	if tabId == "delvelog" and ns.RefreshDelveLogPanel then
		ns.RefreshDelveLogPanel()
	end
	if tabId == "enchants" and ns.RefreshGearEnchantPanel then
		ns.RefreshGearEnchantPanel()
	end
	if tabId == "tier" and ns.RefreshTierSetPanel then
		ns.RefreshTierSetPanel()
	end
	if tabId == "currency" and ns.RefreshCurrencyGuidePanel then
		ns.RefreshCurrencyGuidePanel()
	end
	if tabId == "starthere" and ns.RefreshStartHerePanel then
		ns.RefreshStartHerePanel()
	end
	if tabId == "dungeons" and ns.RefreshDungeonGuidePanel then
		ns.RefreshDungeonGuidePanel()
	end
	if tabId == "settings" and ns.RefreshSettingsPanel then
		ns.RefreshSettingsPanel()
	end

	if tabId == "delves" then
		if ns.RefreshDelvesPanel then
			ns.RefreshDelvesPanel(true)
		end
		-- No window auto-resize here anymore: the Delves content lives in a
		-- ScrollFrame (Delves.lua), so the 800px jump on tab switch was only
		-- jarring without adding reachability. ResolveMainHeightForOpen still
		-- normalizes pre-v3 saved layouts once on open.
	end

	if tabId == "toolbox" and ns.SelectToolboxSubTab then
		ns.SelectToolboxSubTab(ns.uiSelectedToolboxSubTab or "consumables")
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

	-- Herlayout de zijbalk zodat de kamer-rail de kamer van de nieuwe tab toont.
	-- Guard: de fallback SelectTab("home") in RelayoutSidebarTabs zou anders recursen.
	if RelayoutSidebarTabs and not ns._mhSidebarRelaying then
		RelayoutSidebarTabs()
	end

	-- Info-drawer (rechtsboven) live meeverversen, zodat-ie altijd de ÉCHTE open tab
	-- toont en niet die van het moment dat je 'm opende (Rob 25 jun). _mhRefreshSidePanel
	-- respecteert de modus zelf (About blijft About; Info volgt de nieuwe tab).
	if ns._mhInfoWindow and ns._mhInfoWindow.IsShown and ns._mhInfoWindow:IsShown()
		and ns._mhRefreshSidePanel then
		ns:_mhRefreshSidePanel(tabId)
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
	-- Toolbox sub-tabs are beta-gated too (macros/academy): reposition the
	-- sub-nav and bounce off a now-disabled sub-tab.
	if ns.RelayoutToolboxSubNav then
		ns.RelayoutToolboxSubNav()
	end
	if ns.uiSelectedTab == "toolbox" and ns.SelectToolboxSubTab then
		ns.SelectToolboxSubTab(ns.uiSelectedToolboxSubTab or "consumables")
	end
	-- Same for the Reference category inside the Codex: bounce to Start and
	-- re-render the category nav when its checkbox goes off while visible.
	if ns.uiSelectedTab == "codex" and ns.GetActiveCodexCategory and ns.GetActiveCodexCategory() == "reference"
		and ns.IsBetaTabEnabled and not ns.IsBetaTabEnabled("reference") and ns.RefreshCodexPanel then
		-- RefreshCodexPanel self-corrects the saved category (reference → start).
		ns.RefreshCodexPanel()
	end
	local t = ns.uiSelectedTab
	if not t or not ns.SelectTab then
		return
	end
	if ns.IsBetaTabId and ns.IsBetaTabId(t) and ns.IsBetaTabEnabled and not ns.IsBetaTabEnabled(t) then
		ns.SelectTab("home")
	elseif t == "guide" and ns.IsGuideTabEnabled and not ns:IsGuideTabEnabled() then
		ns.SelectTab("home")
	end
end

--------------------------------------------------------------------------------
-- Addons sub-tab routing (internal modules inside the Addons main tab)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Toolbox sub-tab routing (Macros / Consumables / Role Academy)
--------------------------------------------------------------------------------
function ns.SelectToolboxSubTab(subId)
	local frames = ns._mhToolboxSubFrames
	if not frames then
		return
	end
	-- Beta-gated sub-tab (macros/academy) switched off, or unknown id: fall
	-- back to the always-available Consumables sub-tab.
	if not frames[subId] then
		subId = "consumables"
	end
	for _, def in ipairs(ns._mhToolboxSubTabDefs or {}) do
		if def.id == subId and def.beta and ns.IsBetaTabEnabled and not ns.IsBetaTabEnabled(subId) then
			subId = "consumables"
			break
		end
	end
	if not frames[subId] then
		return
	end

	ns.uiSelectedToolboxSubTab = subId

	for id, frame in pairs(frames) do
		if id == subId then
			frame:Show()
		else
			frame:Hide()
		end
	end

	MHRefreshToolboxSubTabChrome(subId)
	-- Help drawer text follows the active sub-tab.
	if ns._mhRefreshSidePanel and ns.uiSelectedTab == "toolbox" then
		ns:_mhRefreshSidePanel("toolbox")
	end
end

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
		self:ApplySavedMainWindowPosition()
		-- Re-sync the sidebar with the current beta-tab settings on every open, so a
		-- toggle made in Settings (a different sidebar room) is always reflected without
		-- needing a /reload (Rob 2026-07-07).
		if ns.RefreshBetaTabVisibility then
			ns.RefreshBetaTabVisibility()
		end
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
	self:ApplySavedMainWindowPosition()
	if ns.RefreshBetaTabVisibility then
		ns.RefreshBetaTabVisibility() -- keep the sidebar in sync with beta-tab settings (see ToggleMainWindow)
	end
	if self.uiSelectedTab == "guide" and self._mhSelectGuideSubTab then
		C_Timer.After(0, function()
			if self._mhSelectGuideSubTab then
				self._mhSelectGuideSubTab(self.uiSelectedGuideSubTab or "guide")
			end
		end)
	end
end

