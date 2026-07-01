--[[
	MidnightHelper — Midnight 80→90 leveling tips (class-agnostic).
	Data: ns.GuideData80to90 (defined here). Tab host + sub-tabs built in UI.lua.

	Public hooks the rest of the addon relies on (names must stay stable):
		ns.SetupUniversalGuideModule  — build the guide UI host (top bar + scroll).
		ns:_mhGuideRefresh            — repopulate when the guide sub-tab is visible.
		ns.ClearGuideUI               — wipe the scroll content before a repopulate.
		ns._mhGuidePrintLayout        — /mh guide chat diagnostics.
		ns._mhGuideLayoutPanel        — keyboard-layout prototype panel (built in UI.lua).
		ns.MH_RunSearchQuery          — global search router (search box in UI.lua).
		ns.MH_ClearSearchAndPreview   — clear search/preview (Consumables tab, etc.).
]]

local addonName, ns = ...

local SECTION_BAR_H = 24
local SECTION_GAP_AFTER = 6
local BULLET_GAP = 6
local lastGuideCenterFs

local DEFAULT_THEME = {
	tint = { 0.06, 0.06, 0.08, 0.92 },
	topBar = { 0.15, 0.15, 0.18, 0.95 },
	titleColor = { 0.85, 0.88, 0.92 },
	sectionBar = { 0.22, 0.22, 0.26, 0.9 },
	sectionText = { 0.9, 0.88, 0.82 },
	icyBackdrop = { 0.08, 0.08, 0.10, 0.85 },
	icyBorder = { 0.4, 0.4, 0.45, 0.9 },
	icyTitleColor = { 0.85, 0.9, 1.0 },
	ebBg = { 0.1, 0.1, 0.12, 0.95 },
}

--------------------------------------------------------------------------------
-- Content: the six class-agnostic 80→90 tip sections.
-- Each `title` / `bullets[i]` is a locale key (LVL8090_*). Optional `buttons`
-- entries route to existing addon tabs for the level-90 handoff.
--------------------------------------------------------------------------------
ns.GuideData80to90 = {
	sections = {
		{
			titleKey = "LVL8090_SEC_PATH_TITLE",
			bullets = {
				"LVL8090_PATH_1",
				"LVL8090_PATH_2",
				"LVL8090_PATH_3",
				"LVL8090_PATH_4",
				"LVL8090_PATH_5",
				"LVL8090_PATH_6",
				"LVL8090_PATH_7",
				"LVL8090_PATH_8",
			},
		},
		{
			titleKey = "LVL8090_SEC_XP_TITLE",
			bullets = {
				"LVL8090_XP_1",
				"LVL8090_XP_2",
				"LVL8090_XP_3",
				"LVL8090_XP_4",
				"LVL8090_XP_5",
				"LVL8090_XP_6",
				"LVL8090_XP_7",
			},
		},
		{
			titleKey = "LVL8090_SEC_UNLOCKS_TITLE",
			bullets = {
				"LVL8090_UNLOCK_1",
				"LVL8090_UNLOCK_2",
				"LVL8090_UNLOCK_3",
				"LVL8090_UNLOCK_4",
				"LVL8090_UNLOCK_5",
				"LVL8090_UNLOCK_6",
			},
		},
		{
			titleKey = "LVL8090_SEC_CONS_TITLE",
			bullets = {
				"LVL8090_CONS_1",
				"LVL8090_CONS_2",
				"LVL8090_CONS_3",
			},
			buttons = {
				{ labelKey = "LVL8090_BTN_OPEN_CONSUMABLES", tab = "consumables" },
			},
		},
		{
			titleKey = "LVL8090_SEC_GEAR_TITLE",
			bullets = {
				"LVL8090_GEAR_1",
				"LVL8090_GEAR_2",
				"LVL8090_GEAR_3",
				"LVL8090_GEAR_4",
				"LVL8090_GEAR_5",
			},
		},
		{
			titleKey = "LVL8090_SEC_HANDOFF_TITLE",
			bullets = {
				"LVL8090_HANDOFF_1",
				"LVL8090_HANDOFF_2",
				"LVL8090_HANDOFF_3",
				"LVL8090_HANDOFF_4",
				"LVL8090_HANDOFF_5",
			},
			buttons = {
				{ labelKey = "LVL8090_BTN_OPEN_DELVES", tab = "delves" },
				{ labelKey = "LVL8090_BTN_OPEN_RITUALS", tab = "rares" },
			},
		},
	},
}

--------------------------------------------------------------------------------
-- Small helpers
--------------------------------------------------------------------------------
local function L(key)
	return ns:L(key)
end

-- Remove every direct child of the scroll content so refresh never stacks overlapping regions.
local function DestroyAllChildren(parent)
	if not parent or not parent.GetChildren then
		return
	end
	for _ = 1, 64 do
		local children = { parent:GetChildren() }
		if #children == 0 then
			break
		end
		for i = 1, #children do
			local c = children[i]
			if c then
				c:Hide()
				c:SetParent(nil)
			end
		end
	end
end

-- FontStrings created on scrollContent are regions, not child frames — clear them too.
local function DestroyAllRegions(parent)
	if not parent or not parent.GetRegions then
		return
	end
	for _ = 1, 128 do
		local regions = { parent:GetRegions() }
		if #regions == 0 then
			break
		end
		for i = 1, #regions do
			local r = regions[i]
			if r and r.SetParent then
				r:Hide()
				r:SetParent(nil)
			end
		end
	end
end

-- Centered onboarding / placeholder copy inside scrollContent.
local function PlaceCenteredGuideMessage(parent, fullW, markup)
	if lastGuideCenterFs and lastGuideCenterFs.SetParent then
		lastGuideCenterFs:Hide()
		lastGuideCenterFs:SetParent(nil)
		lastGuideCenterFs = nil
	end
	local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	fs:SetWidth(math.max(160, fullW - 40))
	fs:SetPoint("CENTER", parent, "CENTER", 0, 0)
	fs:SetJustifyH("CENTER")
	if fs.SetJustifyV then
		fs:SetJustifyV("MIDDLE")
	end
	fs:SetWordWrap(true)
	fs:SetTextColor(0.88, 0.86, 0.78)
	fs:SetText(markup)
	lastGuideCenterFs = fs
	local textH = fs:GetStringHeight() or 100
	parent:SetHeight(math.max(160, textH + 56))
end

local function ApplyTheme(theme, tintTex, topBarTex, titleFs)
	local t = theme or DEFAULT_THEME
	local function c4(k)
		local v = t[k] or DEFAULT_THEME[k]
		return v[1], v[2], v[3], v[4]
	end
	if tintTex and tintTex.SetColorTexture then
		tintTex:SetColorTexture(c4("tint"))
	end
	if topBarTex and topBarTex.SetColorTexture then
		topBarTex:SetColorTexture(c4("topBar"))
	end
	if titleFs and titleFs.SetTextColor then
		local tc = t.titleColor or DEFAULT_THEME.titleColor
		titleFs:SetTextColor(tc[1], tc[2], tc[3])
	end
end

--------------------------------------------------------------------------------
-- UI refs (built once)
--------------------------------------------------------------------------------
local guideRoot
local guideTopBar
local tintTex
local topBarTex
local titleFs
local scroll
local guideScrollBar
local guideScrollUpBtn
local guideScrollDownBtn
local guideContentBorder
local guideThemeGlowOuter
local scrollContent
local syncingGuideScrollBar
local ScheduleGuidePopulate

local function SyncGuideScrollBarState()
	if not scroll or not guideScrollBar then
		return
	end
	local maxScroll = scroll:GetVerticalScrollRange() or 0
	local curScroll = scroll:GetVerticalScroll() or 0
	if curScroll < 0 then
		curScroll = 0
	elseif curScroll > maxScroll then
		curScroll = maxScroll
	end

	guideScrollBar:SetMinMaxValues(0, maxScroll)
	syncingGuideScrollBar = true
	guideScrollBar:SetValue(curScroll)
	syncingGuideScrollBar = false

	if maxScroll <= 0 then
		guideScrollBar:Disable()
		guideScrollBar:SetAlpha(0.45)
	else
		guideScrollBar:Enable()
		guideScrollBar:SetAlpha(1)
	end

	if guideScrollUpBtn then
		local canUp = maxScroll > 0 and curScroll > 0
		guideScrollUpBtn:SetEnabled(canUp)
		guideScrollUpBtn:SetAlpha(canUp and 1 or 0.45)
	end
	if guideScrollDownBtn then
		local canDown = maxScroll > 0 and curScroll < maxScroll
		guideScrollDownBtn:SetEnabled(canDown)
		guideScrollDownBtn:SetAlpha(canDown and 1 or 0.45)
	end
end

function ns.ClearGuideUI()
	if not scrollContent then
		return
	end
	DestroyAllChildren(scrollContent)
	DestroyAllRegions(scrollContent)
	if lastGuideCenterFs and lastGuideCenterFs.SetParent then
		lastGuideCenterFs:Hide()
		lastGuideCenterFs:SetParent(nil)
		lastGuideCenterFs = nil
	end
end

--------------------------------------------------------------------------------
-- Search router — routes search-box queries to the right tab. Class-agnostic:
-- no per-spec preview anymore, just keyword → tab routing.
--------------------------------------------------------------------------------
local function TrimString(s)
	return (tostring(s or ""):gsub("^%s*(.-)%s*$", "%1"))
end

local function GuideChatMsg(key, ...)
	local fmt = L(key)
	local text = fmt
	if select("#", ...) > 0 then
		text = fmt:format(...)
	end
	print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), text))
end

local function SanitizeGuideDb()
	local db = ns.db
	if not db then
		return nil
	end
	if type(db.guide) ~= "table" then
		db.guide = { preview = false, classToken = "", specIndex = 0 }
	end
	return db.guide
end

local function ApplyGuideSearchQuery(raw)
	local q = string.lower(TrimString(raw))
	if q == "" then
		GuideChatMsg("SEARCH_CHAT_EMPTY")
		return
	end

	local function qHits(words)
		for i = 1, #words do
			if q:find(words[i], 1, true) then
				return true
			end
		end
		return false
	end

	if qHits({
		"academy",
		"role academy",
		"masterclass",
		"master class",
		"tank track",
		"heal track",
		"leren tank",
		"leren heal",
		"tanken",
		"healen",
		"group role",
		"dungeon anxiety",
		"raid anxiety",
		"mentor",
	}) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("academy")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_ACADEMY")
		return
	end

	if qHits({
		"delve",
		"delves",
		"vault",
		"great vault",
		"undertyr",
		"bountiful",
		"companion",
		"brann",
		"zekvir",
		"undercoin",
		"undercoins",
		"delves key",
		"curios",
		"curio",
		"spore",
		"dreadshore",
		"stormstout",
		"dornogal",
		"delves &",
		"delves and",
		"m+ teleport",
		"m+ teleports",
	}) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("delves")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_DELVES")
		return
	end

	if qHits({ "prof", "beroep", "treasure", "kp", "recipe", "craft" }) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("professions")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_PROFESSIONS")
		return
	end

	if qHits({ "rare", "rares", "zulaman", "zul'aman", "eversong", "harandar", "voidstorm" }) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("rares")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_RARES")
		return
	end

	if qHits({ "world boss", "luashal", "cragpine", "thormbelan", "predaxas" }) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("delves")
		end
		if ns.RouteToActiveWorldBoss then
			if C_Timer and C_Timer.After then
				C_Timer.After(0.1, function()
					ns.RouteToActiveWorldBoss()
				end)
			else
				ns.RouteToActiveWorldBoss()
			end
		end
		GuideChatMsg("SEARCH_CHAT_WB_ROUTE")
		return
	end

	if qHits({
		"smc",
		"silvermoon",
		"city guide",
		"harandar",
		"voidstorm",
		"bazaar",
	}) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("smcguide")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_SMC")
		return
	end

	local smcRows = ns._mhSMCGuideSearchRows
	if type(smcRows) == "table" and #smcRows > 0 then
		local smcBest, smcScore = nil, -1e9
		for si = 1, #smcRows do
			local srow = smcRows[si]
			local blob = srow.blob
			local pt = srow.point
			if type(blob) == "string" and blob:find(q, 1, true) and type(pt) == "table" then
				local score = 120
				local lab = string.lower(tostring(pt.label or ""))
				if lab:find(q, 1, true) then
					score = score + 350
				end
				if #q > 0 and #q <= #lab and lab:sub(1, #q) == q then
					score = score + 180
				end
				score = score - #blob * 0.01
				if score > smcScore then
					smcScore = score
					smcBest = srow
				end
			end
		end
		if smcBest and smcBest.point then
			local p = smcBest.point
			if ns.ShowMainUI and ns.SelectTab then
				ns:ShowMainUI()
				ns.SelectTab("smcguide")
			end
			if p._mhWorldBossRoute or p._mhDelvesWorldBoss then
				if p._mhDelvesWorldBoss and ns.ShowMainUI and ns.SelectTab then
					ns:ShowMainUI()
					ns.SelectTab("delves")
				end
				local _, fromClient = ns.GetActiveWorldBoss and ns.GetActiveWorldBoss()
				if fromClient and ns.RouteToActiveWorldBoss then
					if C_Timer and C_Timer.After then
						C_Timer.After(0.05, function()
							ns.RouteToActiveWorldBoss()
						end)
					else
						ns.RouteToActiveWorldBoss()
					end
					GuideChatMsg("SEARCH_CHAT_WB_ROUTE")
				else
					GuideChatMsg("WB_OPEN_MAP_HINT")
				end
				return
			end
			local function doJump()
				if ns.JumpSMCCityGuideToPoint then
					ns.JumpSMCCityGuideToPoint(p)
				end
			end
			if C_Timer and C_Timer.After then
				C_Timer.After(0.05, doJump)
			else
				doJump()
			end
			GuideChatMsg("SEARCH_CHAT_SMC_PIN_FMT", tostring(p.label or "?"))
			return
		end
	end

	if q:find("addons", 1, true) and not q:find("platynator", 1, true) and not q:find("wago", 1, true) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("addons")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_ADDONS")
		return
	end

	if qHits({ "platynator", "wago", "visual guide" }) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("addons")
		end
		if ns.SelectAddonSubTab and ns._mhAddonSubTabById and ns._mhAddonSubTabById.platynator then
			ns.SelectAddonSubTab("platynator")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_ADDONS_PLATY")
		return
	end

	if qHits({ "consumable", "consumables", "flask", "flasks", "feast", "food", "potion", "potions", "verbruik", "verbruiks", "oil", "rune" }) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("consumables")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_CONSUMABLES")
		return
	end

	if qHits({ "leveling", "level", "leveltip", "leveltips", "80", "90", "icy", "gids", "guide tab", "guide" }) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("guide")
		end
		if ns._mhSelectGuideSubTab then
			ns._mhSelectGuideSubTab("guide")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_GUIDE")
		return
	end

	GuideChatMsg("SEARCH_CHAT_NO_MATCH_FMT", tostring(raw))
end

local function ClearGuidePreviewAndRefresh()
	local gdb = SanitizeGuideDb()
	if gdb then
		gdb.preview = false
		gdb.classToken = ""
		gdb.specIndex = 0
	end
	if ns.RefreshGuideTabVisibility then
		ns:RefreshGuideTabVisibility()
	end
	if ns.mhSearchEdit and ns.mhSearchEdit.SetText then
		ns.mhSearchEdit:SetText("")
	end
	if ns.MH_RefreshConsumablesPanel then
		ns.MH_RefreshConsumablesPanel()
	end
end

ns.MH_RunSearchQuery = ApplyGuideSearchQuery
ns.MH_ClearSearchAndPreview = ClearGuidePreviewAndRefresh

--------------------------------------------------------------------------------
-- Renderer: class-agnostic 80→90 tip sections.
--------------------------------------------------------------------------------
local function PopulateUniversalGuideContent()
	if guideRoot and not guideRoot:IsVisible() then
		return
	end
	ns.ClearGuideUI()
	if not scrollContent or not titleFs then
		return
	end

	local fullW = math.max(200, scrollContent:GetWidth() or 520)
	ApplyTheme(DEFAULT_THEME, tintTex, topBarTex, titleFs)
	titleFs:SetText(L("LVL8090_TITLE"))

	local c = DEFAULT_THEME.titleColor
	if guideThemeGlowOuter and guideThemeGlowOuter.SetBackdropBorderColor then
		guideThemeGlowOuter:SetBackdropBorderColor(c[1], c[2], c[3], 0.12)
	end
	if guideContentBorder and guideContentBorder.SetBackdropBorderColor then
		guideContentBorder:SetBackdropBorderColor(c[1], c[2], c[3], 0.38)
	end

	local th = DEFAULT_THEME
	local y = 0
	local function nextY(h)
		y = y - h
		return y
	end

	local function addSectionHeader(text)
		local bar = CreateFrame("Frame", nil, scrollContent)
		bar:SetSize(fullW, SECTION_BAR_H)
		bar:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, y)
		local bt = bar:CreateTexture(nil, "BACKGROUND")
		bt:SetAllPoints()
		local sb = th.sectionBar
		bt:SetColorTexture(sb[1], sb[2], sb[3], sb[4])
		local accent = bar:CreateTexture(nil, "OVERLAY")
		accent:SetHeight(1)
		accent:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 4, 0)
		accent:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -4, 0)
		local ac = th.titleColor
		accent:SetColorTexture(ac[1], ac[2], ac[3], 0.45)
		local fs = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalMed3")
		fs:SetPoint("LEFT", bar, "LEFT", 8, 0)
		fs:SetJustifyH("LEFT")
		fs:SetText(text)
		local st = th.sectionText
		fs:SetTextColor(st[1], st[2], st[3])
		nextY(SECTION_BAR_H + SECTION_GAP_AFTER)
	end

	local function addBullet(text)
		local row = CreateFrame("Frame", nil, scrollContent)
		row:SetWidth(fullW - 8)
		row:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 4, y)

		local dot = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		dot:SetPoint("TOPLEFT", row, "TOPLEFT", 2, 0)
		dot:SetText("•")
		dot:SetTextColor(0.95, 0.85, 0.45)

		local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetPoint("TOPLEFT", row, "TOPLEFT", 16, 0)
		fs:SetPoint("TOPRIGHT", row, "TOPRIGHT", -4, 0)
		fs:SetJustifyH("LEFT")
		fs:SetSpacing(2)
		fs:SetWordWrap(true)
		fs:SetTextColor(0.92, 0.90, 0.82)
		fs:SetText(text)

		local h = math.max(16, fs:GetStringHeight() or 16)
		row:SetHeight(h)
		nextY(h + BULLET_GAP)
	end

	local function addTabButton(labelText, tabId)
		local btn = CreateFrame("Button", nil, scrollContent, "UIPanelButtonTemplate")
		btn:SetHeight(24)
		btn:SetText(labelText)
		local fs = btn.GetFontString and btn:GetFontString()
		local textW = 120
		if fs and fs.GetStringWidth then
			textW = fs:GetStringWidth() or textW
		end
		btn:SetWidth(math.min(fullW - 16, math.max(140, math.ceil(textW) + 28)))
		btn:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 8, y)
		btn:SetScript("OnClick", function()
			if ns.ShowMainUI then
				ns:ShowMainUI()
			end
			if ns.SelectTab then
				ns.SelectTab(tabId)
			end
		end)
		nextY(24 + BULLET_GAP)
	end

	-- Intro line.
	do
		local intro = CreateFrame("Frame", nil, scrollContent)
		intro:SetWidth(fullW - 8)
		intro:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 4, y)
		local fs = intro:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetPoint("TOPLEFT", intro, "TOPLEFT", 2, 0)
		fs:SetPoint("TOPRIGHT", intro, "TOPRIGHT", -4, 0)
		fs:SetJustifyH("LEFT")
		fs:SetSpacing(2)
		fs:SetWordWrap(true)
		fs:SetTextColor(0.80, 0.86, 0.95)
		fs:SetText(L("LVL8090_INTRO"))
		local h = math.max(16, fs:GetStringHeight() or 16)
		intro:SetHeight(h)
		nextY(h + SECTION_GAP_AFTER + 2)
	end

	local sections = (ns.GuideData80to90 and ns.GuideData80to90.sections) or {}
	for si = 1, #sections do
		local sec = sections[si]
		if type(sec) == "table" then
			addSectionHeader(L(sec.titleKey))
			for bi = 1, #(sec.bullets or {}) do
				addBullet(L(sec.bullets[bi]))
			end
			if type(sec.buttons) == "table" then
				for bi = 1, #sec.buttons do
					local b = sec.buttons[bi]
					if type(b) == "table" and b.tab then
						addTabButton(L(b.labelKey), b.tab)
					end
				end
			end
			nextY(6)
		end
	end

	scrollContent:SetHeight(math.abs(y) + 20)
	if scroll and scrollContent then
		scroll:SetScrollChild(scrollContent)
		scrollContent:Show()
		if scrollContent.Raise then
			scrollContent:Raise()
		end
		if scroll.SetHorizontalScroll then
			scroll:SetHorizontalScroll(0)
		end
		if scroll.UpdateScrollChildRect then
			scroll:UpdateScrollChildRect()
		end
	end
	if scroll and scroll.SetVerticalScroll then
		scroll:SetVerticalScroll(0)
	end
	SyncGuideScrollBarState()

	local layoutPanel = ns._mhGuideLayoutPanel
	if layoutPanel and layoutPanel._mhProtoBuilt and ns.KeyboardLayoutPrototype_Refresh then
		ns.KeyboardLayoutPrototype_Refresh(layoutPanel)
	end
end

-- Populate after layout: ScrollFrame often reports height 0 during the same frame as Show/Create.
ScheduleGuidePopulate = function()
	if not C_Timer or not C_Timer.After then
		PopulateUniversalGuideContent()
		return
	end
	local attempts = 0
	local function try()
		attempts = attempts + 1
		if not scroll or not scrollContent or not guideRoot then
			return
		end
		if not guideRoot:IsVisible() then
			if attempts < 24 then
				C_Timer.After(0.05, try)
			end
			return
		end
		local h = scroll:GetHeight() or 0
		if h < 8 and attempts < 40 then
			C_Timer.After(0.05, try)
			return
		end
		PopulateUniversalGuideContent()
	end
	C_Timer.After(0, try)
end

--- Chat diagnostics: `/mh guide`.
function ns._mhGuidePrintLayout()
	print("|cffffcc00Midnight Helper|r — guide layout")
	if not guideRoot then
		print("  guideRoot: (nil — UI not built)")
		return
	end
	local vis = tostring(guideRoot:IsVisible())
	local shown = tostring(guideRoot:IsShown())
	local sw, sh = 0, 0
	local cur, max = 0, 0
	local cw, ch, children = 0, 0, 0
	if scroll then
		sw, sh = scroll:GetWidth() or 0, scroll:GetHeight() or 0
		cur = scroll:GetVerticalScroll() or 0
		max = scroll:GetVerticalScrollRange() or 0
	end
	if scrollContent then
		cw, ch = scrollContent:GetWidth() or 0, scrollContent:GetHeight() or 0
		children = #({ scrollContent:GetChildren() })
	end
	print(string.format("  root: visible=%s shown=%s", vis, shown))
	print(string.format("  scroll: %.0fx%.0f  range %.1f/%.1f", sw, sh, cur, max))
	print(string.format("  content: %.0fx%.0f  children=%d", cw, ch, children))
end

function ns:_mhGuideRefresh()
	if guideRoot and guideRoot:IsVisible() then
		ScheduleGuidePopulate()
	end
end

function ns.SetupUniversalGuideModule()
	if ns._mhUniversalGuideUiBuilt then
		return
	end

	local panel = ns.panels and (ns.panels.guideBody or ns.panels.guide)
	if not panel then
		if ns.db and ns.db.ui and ns.db.ui.debug then
			print("|cffffcc00" .. L("PRINT_PREFIX") .. "|r " .. L("GUIDE_PANEL_MISSING"))
		end
		return
	end

	ns._mhUniversalGuideUiBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local root = CreateFrame("Frame", "MidnightHelperUniversalGuideFrame", panel)
	root:SetAllPoints(panel)
	root:SetFrameLevel((panel:GetFrameLevel() or 0) + 2)
	guideRoot = root

	tintTex = root:CreateTexture(nil, "BACKGROUND", nil, -6)
	tintTex:SetAllPoints()

	local margin = 10
	local marginTop = 6
	local topBar = CreateFrame("Frame", nil, root)
	topBar:SetHeight(36)
	topBar:SetPoint("TOPLEFT", root, "TOPLEFT", margin, -marginTop)
	topBar:SetPoint("TOPRIGHT", root, "TOPRIGHT", -margin, -marginTop)
	topBarTex = topBar:CreateTexture(nil, "BACKGROUND")
	topBarTex:SetAllPoints()
	guideTopBar = topBar

	titleFs = topBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titleFs:SetPoint("LEFT", topBar, "LEFT", 10, 0)
	titleFs:SetPoint("RIGHT", topBar, "RIGHT", -10, 0)
	titleFs:SetJustifyH("LEFT")

	-- Host + inset scroll: backdrop border must sit around the viewport.
	local scrollInset = 2
	local scrollBarGutter = 22
	local scrollHost = CreateFrame("Frame", "MidnightHelperGuideScrollHost", root)
	scrollHost:SetPoint("TOPLEFT", topBar, "BOTTOMLEFT", 0, -4)
	scrollHost:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -(margin + 30), margin)
	scrollHost:SetFrameStrata(root:GetFrameStrata())
	scrollHost:SetFrameLevel((root:GetFrameLevel() or 0) + 12)
	scrollHost:EnableMouse(false)

	local bd = {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		tile = true,
		tileSize = 8,
		edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	}
	guideThemeGlowOuter = CreateFrame("Frame", "MidnightHelperGuideThemeGlow", scrollHost, "BackdropTemplate")
	guideThemeGlowOuter:SetPoint("TOPLEFT", scrollHost, "TOPLEFT", -3, 3)
	guideThemeGlowOuter:SetPoint("BOTTOMRIGHT", scrollHost, "BOTTOMRIGHT", 3, -3)
	guideThemeGlowOuter:SetFrameStrata(scrollHost:GetFrameStrata())
	guideThemeGlowOuter:SetFrameLevel(scrollHost:GetFrameLevel())
	if guideThemeGlowOuter.SetBackdrop then
		local glowBd = {}
		for k, v in pairs(bd) do
			glowBd[k] = v
		end
		glowBd.edgeSize = 4
		guideThemeGlowOuter:SetBackdrop(glowBd)
		guideThemeGlowOuter:SetBackdropColor(0, 0, 0, 0)
		local tc = DEFAULT_THEME.titleColor
		guideThemeGlowOuter:SetBackdropBorderColor(tc[1], tc[2], tc[3], 0.1)
	end
	guideThemeGlowOuter:EnableMouse(false)

	guideContentBorder = CreateFrame("Frame", "MidnightHelperGuideThemeRim", scrollHost, "BackdropTemplate")
	guideContentBorder:SetAllPoints(scrollHost)
	guideContentBorder:SetFrameStrata(scrollHost:GetFrameStrata())
	guideContentBorder:SetFrameLevel(scrollHost:GetFrameLevel() + 1)
	if guideContentBorder.SetBackdrop then
		guideContentBorder:SetBackdrop(bd)
		guideContentBorder:SetBackdropColor(0, 0, 0, 0)
		local tc = DEFAULT_THEME.titleColor
		guideContentBorder:SetBackdropBorderColor(tc[1], tc[2], tc[3], 0.35)
	end
	guideContentBorder:EnableMouse(false)

	scroll = CreateFrame("ScrollFrame", "MidnightHelperUniversalGuideScroll", scrollHost)
	scroll:SetPoint("TOPLEFT", scrollHost, "TOPLEFT", scrollInset, -scrollInset)
	scroll:SetPoint("BOTTOMRIGHT", scrollHost, "BOTTOMRIGHT", -scrollInset - scrollBarGutter, scrollInset)
	scroll:SetFrameStrata(scrollHost:GetFrameStrata())
	scroll:SetFrameLevel(scrollHost:GetFrameLevel() + 2)
	scroll:EnableMouse(true)
	scroll:EnableMouseWheel(true)
	local scrollFill = scroll:CreateTexture(nil, "BACKGROUND", nil, -8)
	scrollFill:SetAllPoints()
	scrollFill:SetColorTexture(0.04, 0.042, 0.055, 1)
	local scrollStep = (_G.WORLDWIDE_SCROLL_STEP and math.floor(_G.WORLDWIDE_SCROLL_STEP * 0.75)) or 30
	scroll:SetScript("OnMouseWheel", function(self, delta)
		local maxScroll = self:GetVerticalScrollRange() or 0
		if maxScroll <= 0 then
			return
		end
		local nextScroll = self:GetVerticalScroll() - (delta * scrollStep)
		if nextScroll < 0 then
			nextScroll = 0
		elseif nextScroll > maxScroll then
			nextScroll = maxScroll
		end
		self:SetVerticalScroll(nextScroll)
		SyncGuideScrollBarState()
	end)
	if scroll.SetHorizontalScroll then
		scroll:SetHorizontalScroll(0)
	end

	scrollContent = CreateFrame("Frame", "MidnightHelperUniversalGuideScrollContent", scroll)
	scrollContent:SetFrameStrata(scroll:GetFrameStrata())
	scrollContent:SetFrameLevel(scroll:GetFrameLevel() + 1)
	scrollContent:SetWidth(1)
	scrollContent:SetHeight(1)
	scroll:SetScrollChild(scrollContent)
	scroll:SetScript("OnVerticalScroll", function()
		SyncGuideScrollBarState()
	end)

	guideScrollBar = CreateFrame("Slider", nil, scrollHost)
	guideScrollBar:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 2, 0)
	guideScrollBar:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", 2, 0)
	guideScrollBar:SetWidth(16)
	guideScrollBar:SetOrientation("VERTICAL")
	guideScrollBar:SetFrameLevel(scrollHost:GetFrameLevel() + 4)
	local barBg = guideScrollBar:CreateTexture(nil, "BACKGROUND")
	barBg:SetAllPoints()
	barBg:SetColorTexture(0.07, 0.07, 0.09, 0.88)
	local thumb = guideScrollBar:CreateTexture(nil, "OVERLAY")
	thumb:SetSize(16, 28)
	thumb:SetColorTexture(0.72, 0.74, 0.78, 0.96)
	guideScrollBar:SetThumbTexture(thumb)
	guideScrollBar:SetScript("OnEnter", function()
		thumb:SetColorTexture(0.86, 0.88, 0.92, 1.0)
	end)
	guideScrollBar:SetScript("OnLeave", function()
		thumb:SetColorTexture(0.72, 0.74, 0.78, 0.96)
	end)
	guideScrollBar:SetMinMaxValues(0, 0)
	guideScrollBar:SetValue(0)
	guideScrollBar:SetValueStep(1)
	guideScrollBar:SetObeyStepOnDrag(false)
	guideScrollBar:SetScript("OnValueChanged", function(self, value)
		if syncingGuideScrollBar then
			return
		end
		if scroll and scroll.SetVerticalScroll then
			scroll:SetVerticalScroll(value or 0)
		end
		SyncGuideScrollBarState()
	end)

	guideScrollUpBtn = CreateFrame("Button", nil, scrollHost)
	guideScrollUpBtn:SetSize(20, 20)
	guideScrollUpBtn:SetPoint("BOTTOM", guideScrollBar, "TOP", 0, 4)
	guideScrollUpBtn:SetFrameLevel(scrollHost:GetFrameLevel() + 5)
	guideScrollUpBtn:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
	guideScrollUpBtn:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
	guideScrollUpBtn:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight")
	guideScrollUpBtn:SetScript("OnClick", function()
		if not scroll then
			return
		end
		local nextScroll = math.max(0, (scroll:GetVerticalScroll() or 0) - 40)
		scroll:SetVerticalScroll(nextScroll)
		SyncGuideScrollBarState()
	end)

	guideScrollDownBtn = CreateFrame("Button", nil, scrollHost)
	guideScrollDownBtn:SetSize(20, 20)
	guideScrollDownBtn:SetPoint("TOP", guideScrollBar, "BOTTOM", 0, -4)
	guideScrollDownBtn:SetFrameLevel(scrollHost:GetFrameLevel() + 5)
	guideScrollDownBtn:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
	guideScrollDownBtn:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
	guideScrollDownBtn:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight")
	guideScrollDownBtn:SetScript("OnClick", function()
		if not scroll then
			return
		end
		local maxScroll = scroll:GetVerticalScrollRange() or 0
		local nextScroll = math.min(maxScroll, (scroll:GetVerticalScroll() or 0) + 40)
		scroll:SetVerticalScroll(nextScroll)
		SyncGuideScrollBarState()
	end)

	root:SetScript("OnShow", function()
		if scrollContent and scroll then
			scrollContent:SetWidth(math.max(200, scroll:GetWidth() - 8))
		end
		ScheduleGuidePopulate()
	end)

	scroll:SetScript("OnSizeChanged", function()
		if scrollContent and scroll then
			scrollContent:SetWidth(math.max(200, scroll:GetWidth() - 8))
		end
		SyncGuideScrollBarState()
	end)

	local evt = CreateFrame("Frame")
	evt:RegisterEvent("PLAYER_ENTERING_WORLD")
	evt:RegisterEvent("PLAYER_LEVEL_UP")
	evt:SetScript("OnEvent", function()
		if ns._mhUniversalGuideUiBuilt and guideRoot and guideRoot:IsVisible() then
			ScheduleGuidePopulate()
		end
	end)

	if scrollContent and scroll then
		scrollContent:SetWidth(math.max(200, scroll:GetWidth() - 8))
	end
	ScheduleGuidePopulate()
end

local function HookEnsureMainUI()
	if ns._mhGuideEnsureHooked then
		return
	end
	ns._mhGuideEnsureHooked = true

	local orig = ns.EnsureMainUI
	function ns:EnsureMainUI(...)
		local main = orig(self, ...)
		if ns.SetupUniversalGuideModule then
			ns.SetupUniversalGuideModule()
		end
		return main
	end
end

HookEnsureMainUI()
