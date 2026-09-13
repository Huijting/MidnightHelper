--[[
	Midnight Helper — Settings-tab (launcher + snelle acties).

	Sinds 5 jul wonen alle aan/uit-instellingen in het native Blizzard
	Settings-venster (zie Modules/NativeSettings.lua): daar krijg je zoekbalk,
	per-optie tooltips, subcategorieën en de native look gratis.

	Deze tab is de vriendelijke landingsplek: de roterende eyecatcher als
	branding, een grote knop naar het native paneel, één "Aanbevolen stand"-knop,
	en de losse acties (Voorbeeld/Test/Reset). Die acties staan hier — en niet in
	het native paneel — omdat native knoppen (CreateSettingsButtonInitializer) op
	client 12.0 een Blizzard-assertion triggeren (bevestigd door ClassCodex + MDT).
	Gewone UIPanelButtons hier werken wél betrouwbaar.

	4.0 (13 sep 2026): hier woont ook de Screens-pagina, de aan/uit-lijst van schermen in MH's
	eigen look. Rob: "moet zo een settings screen niet gewoon in MH??" → "doe maar nummer 2, en
	later nummer 3" (nummer 3 = alle instellingen in MH, na 4.0.0).
]]

local _, ns = ...

local BTN_H = 24
local EYE_H = 86

local COLOR_HEADER = { 1, 0.82, 0.2 }
local COLOR_SOFT = { 0.95, 0.9, 0.74 }
local COLOR_DIM = { 0.72, 0.74, 0.78 }

local ui

--------------------------------------------------------------------------------
-- Eyecatcher: roterend model uit alle bekende creature-IDs
--------------------------------------------------------------------------------

local function PickEyecatcherCreature()
	local pool = {}
	if type(ns.DUNGEON_BOSS_CREATURES) == "table" then
		for _, id in pairs(ns.DUNGEON_BOSS_CREATURES) do
			pool[#pool + 1] = id
		end
	end
	local learned = ns.db and ns.db.rareNpcIds
	if type(learned) == "table" then
		for _, id in pairs(learned) do
			pool[#pool + 1] = id
		end
	end
	if #pool == 0 then
		return nil
	end
	return pool[math.random(#pool)]
end

local function ApplyEyecatcherModel()
	local model = ui and ui.eyeModel
	if not model then
		return
	end
	local creature = PickEyecatcherCreature()
	if not creature then
		model:Hide()
		return
	end
	local function apply()
		model:ClearModel()
		model:SetCreature(creature)
		if model.SetPortraitZoom then
			model:SetPortraitZoom(0)
		end
		if model.SetPosition then
			model:SetPosition(0, 0, 0)
		end
	end
	local ok = pcall(apply)
	model:SetShown(ok == true)
	if ok and C_Timer and C_Timer.After then
		C_Timer.After(0.2, function()
			if model:IsShown() then
				pcall(apply)
			end
		end)
	end
end

--------------------------------------------------------------------------------
-- Hulp
--------------------------------------------------------------------------------

local function MakeFS(parent, font, color)
	local fs = parent:CreateFontString(nil, "OVERLAY", font)
	if ns.MHScalableFont and type(font) == "string" then
		fs:SetFontObject(ns.MHScalableFont(font))
	end
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	if color then
		fs:SetTextColor(color[1], color[2], color[3])
	end
	return fs
end

--------------------------------------------------------------------------------
-- Screens page (4.0). Rob, 13 Sep 2026: "moet zo een settings screen niet gewoon in MH??" The
-- show/hide list inside the addon, in its own look. It is the same list as Blizzard's Settings ->
-- Midnight Helper -> Screens (Modules/NativeSettings.lua): both read and write
-- ns.IsScreenHidden / ns.SetScreenHidden (Core.lua), so the two cannot disagree.
-- Reached from the button on the Settings page, the room cards' right-click menu and search.
--------------------------------------------------------------------------------
local SCR_ROW_H = 26
local SCR_COL_MIN_W = 190
local SCR_GAP = 8
local SCR_ROOMS = {
	{ id = "me", labelKey = "SIDEBAR_ROOM_ME" },
	{ id = "codex", labelKey = "SIDEBAR_ROOM_CODEX" },
	{ id = "tools", labelKey = "SIDEBAR_ROOM_TOOLS" },
}
local screensPage

-- Palette C in the new look; the 3.x gold and grey with Classic on.
local function ScreenColors()
	local p = ns.LOOK_PALETTE
	if p and not (ns.IsClassicLookEnabled and ns:IsClassicLookEnabled()) then
		return { header = p.header, body = p.body, muted = p.muted, accent = p.accent }
	end
	return { header = COLOR_HEADER, body = { 1, 1, 1 }, muted = COLOR_DIM, accent = { 1, 0.82, 0.2, 1 } }
end

-- Every hideable screen, plus the Basics category under Codex, which keeps its own switch.
local function ScreenEntries()
	local list = {}
	for _, s in ipairs(ns.GetHideableScreens and ns.GetHideableScreens() or {}) do
		list[#list + 1] = { id = s.id, room = s.room, labelKey = s.labelKey }
	end
	list[#list + 1] = { id = "reference", room = "codex", basics = true }
	return list
end

local function EntryLabel(e)
	if e.basics then
		return ns:L("TAB_CODEX") .. ": " .. ns:L("SETTINGS_BETA_TAB_REFERENCE")
	end
	return ns:L(e.labelKey)
end

local function EntryOn(e)
	if e.basics then
		local bt = ns.GetBetaTabsSettings and ns.GetBetaTabsSettings() or {}
		return bt.enabled ~= false and bt.reference ~= false
	end
	return not (ns.IsScreenHidden and ns.IsScreenHidden(e.id))
end

local function ToggleEntry(e)
	local on = EntryOn(e)
	if e.basics then
		if ns.SetBetaTabOption then
			ns.SetBetaTabOption("reference", not on)
		end
		if ns.SyncNativeScreenSetting then
			ns.SyncNativeScreenSetting("reference", not on)
		end
		if ns.RefreshScreensPanel then
			ns.RefreshScreensPanel()
		end
	elseif ns.SetScreenHidden then
		ns.SetScreenHidden(e.id, on) -- refreshes this page as well
	end
end

local function MakeScreenRow(parent)
	local row = CreateFrame("Button", nil, parent)
	row:SetHeight(SCR_ROW_H)
	local box = CreateFrame("Frame", nil, row, "BackdropTemplate")
	box:SetSize(14, 14)
	box:SetPoint("LEFT", row, "LEFT", 2, 0)
	box:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	local fill = box:CreateTexture(nil, "ARTWORK")
	fill:SetPoint("TOPLEFT", box, "TOPLEFT", 3, -3)
	fill:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", -3, 3)
	local icon = row:CreateTexture(nil, "ARTWORK")
	icon:SetSize(20, 20)
	icon:SetPoint("LEFT", box, "RIGHT", 8, 0)
	local label = MakeFS(row, "GameFontHighlight")
	label:SetPoint("LEFT", icon, "RIGHT", 6, 0)
	label:SetPoint("RIGHT", row, "RIGHT", -4, 0)
	label:SetWordWrap(false)
	local hl = row:CreateTexture(nil, "HIGHLIGHT")
	hl:SetAllPoints()
	hl:SetColorTexture(1, 1, 1, 0.06)
	row._box, row._fill, row._icon, row._label = box, fill, icon, label
	row:SetScript("OnClick", function(self)
		if self._entry then
			ToggleEntry(self._entry)
		end
	end)
	return row
end

local function PaintScreenRow(row, e, c)
	local on = EntryOn(e)
	row._entry = e
	row._box:SetBackdropBorderColor(c.muted[1], c.muted[2], c.muted[3], 1)
	row._fill:SetColorTexture(c.accent[1], c.accent[2], c.accent[3], 1)
	row._fill:SetShown(on)
	local screen = (ns._mhLookScreens or {})[e.basics and "codex" or e.id]
	if screen and ns._mhLookIconPath then
		row._icon:SetTexture(ns._mhLookIconPath:format(screen.stem))
	else
		row._icon:SetTexture(nil)
	end
	row._icon:SetDesaturated(not on)
	row._icon:SetAlpha(on and 1 or 0.5)
	row._label:SetText(EntryLabel(e))
	local t = on and c.body or c.muted
	row._label:SetTextColor(t[1], t[2], t[3])
end

local function LayoutScreensPage()
	local page = screensPage
	if not page or not page:IsShown() then
		return
	end
	local c = ScreenColors()
	page._title:SetText(ns:L("SETTINGS_SCREENS_TITLE"))
	page._title:SetTextColor(c.header[1], c.header[2], c.header[3])
	page._intro:SetText(ns:L("SCREENS_PANEL_INTRO"))
	page._intro:SetTextColor(c.muted[1], c.muted[2], c.muted[3])
	page._showAll._text:SetText(ns:L("ROOMCARD_RESTORE_ALL"))
	page._showAll._text:SetTextColor(c.accent[1], c.accent[2], c.accent[3])
	page._showAll:SetWidth((page._showAll._text:GetStringWidth() or 80) + 8)

	local width = page._scroll:GetWidth()
	if not width or width < 50 then
		return
	end
	local cols = math.max(1, math.min(3, math.floor((width + SCR_GAP) / (SCR_COL_MIN_W + SCR_GAP))))
	local colW = math.floor((width - SCR_GAP * (cols - 1)) / cols)
	local y, anyHidden = 0, false
	for _, room in ipairs(SCR_ROOMS) do
		local header = page._roomHeaders[room.id]
		header:ClearAllPoints()
		header:SetPoint("TOPLEFT", page._body, "TOPLEFT", 0, -y)
		header:SetText(ns:L(room.labelKey))
		header:SetTextColor(c.header[1], c.header[2], c.header[3])
		y = y + 22
		local n = 0
		for i, e in ipairs(page._entries) do
			if e.room == room.id then
				local row = page._rows[i]
				local col = n % cols
				local line = math.floor(n / cols)
				row:ClearAllPoints()
				row:SetWidth(colW)
				row:SetPoint("TOPLEFT", page._body, "TOPLEFT", col * (colW + SCR_GAP), -(y + line * SCR_ROW_H))
				PaintScreenRow(row, e, c)
				row:Show()
				if not EntryOn(e) then
					anyHidden = true
				end
				n = n + 1
			end
		end
		y = y + math.ceil(n / cols) * SCR_ROW_H + 14
	end
	page._body:SetSize(width, math.max(1, y))
	page._showAll:SetShown(anyHidden)
	-- Same as the room cards: no scroll bar while everything fits.
	local bar = page._scroll.ScrollBar
	if bar then
		local fits = y <= (page._scroll:GetHeight() or 0)
		bar:SetShown(not fits)
		if fits then
			page._scroll:SetVerticalScroll(0)
		end
	end
end

local function ShowAllScreens()
	for _, e in ipairs(screensPage and screensPage._entries or {}) do
		if not EntryOn(e) then
			ToggleEntry(e)
		end
	end
end

local function BuildScreensPage(settingsPanel)
	local host = settingsPanel and settingsPanel:GetParent()
	if screensPage or not host or not ns.panels then
		return
	end
	local page = CreateFrame("Frame", nil, host)
	page:SetAllPoints(settingsPanel)
	page:Hide()

	local title = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", page, "TOPLEFT", 14, -12)
	page._title = title

	local showAll = CreateFrame("Button", nil, page)
	showAll:SetHeight(20)
	showAll:SetPoint("LEFT", title, "RIGHT", 16, 0)
	local showAllText = showAll:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	showAllText:SetPoint("LEFT", showAll, "LEFT", 2, 0)
	showAll._text = showAllText
	showAll:SetScript("OnClick", ShowAllScreens)
	showAll:SetScript("OnEnter", function(self)
		local h = ScreenColors().header
		self._text:SetTextColor(h[1], h[2], h[3])
	end)
	showAll:SetScript("OnLeave", function(self)
		local a = ScreenColors().accent
		self._text:SetTextColor(a[1], a[2], a[3])
	end)
	page._showAll = showAll

	local intro = MakeFS(page, "GameFontHighlightSmall")
	intro:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	intro:SetPoint("RIGHT", page, "RIGHT", -20, 0)
	page._intro = intro

	local scroll = CreateFrame("ScrollFrame", nil, page, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", intro, "BOTTOMLEFT", 0, -14)
	scroll:SetPoint("BOTTOMRIGHT", page, "BOTTOMRIGHT", -30, 10)
	scroll.scrollBarHideable = true
	local body = CreateFrame("Frame", nil, scroll)
	body:SetSize(1, 1)
	scroll:SetScrollChild(body)
	page._scroll, page._body = scroll, body

	page._entries = ScreenEntries()
	page._rows = {}
	for i = 1, #page._entries do
		page._rows[i] = MakeScreenRow(body)
	end
	page._roomHeaders = {}
	for _, room in ipairs(SCR_ROOMS) do
		page._roomHeaders[room.id] = body:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	end

	screensPage = page
	page:SetScript("OnShow", LayoutScreensPage)
	scroll:SetScript("OnSizeChanged", function()
		if page:IsShown() then
			LayoutScreensPage()
		end
	end)
	ns.panels.screens = page
end

--- Redraws the Screens page after a screen was hidden or shown (from anywhere).
function ns.RefreshScreensPanel()
	LayoutScreensPage()
end

--------------------------------------------------------------------------------
-- Build (launcher)
--------------------------------------------------------------------------------

--- The launcher scrolls. Rob, 13 Sep 2026: with the window made smaller, the buttons stuck
--- out below MH. The sheet (scroll child) is as tall as its lowest widget; the bar only shows
--- when that does not fit, as on the room cards.
local function SizeSettingsSheet()
	local scroll, sheet, last = ui and ui.scroll, ui and ui.sheet, ui and ui.last
	if not (scroll and sheet and last) then
		return
	end
	local w = scroll:GetWidth()
	if w and w > 1 then
		sheet:SetWidth(w)
	end
	local top, bottom = sheet:GetTop(), last:GetBottom()
	if not (top and bottom) then
		return
	end
	local h = math.max(1, math.ceil(top - bottom + 16))
	sheet:SetHeight(h)
	local bar = scroll.ScrollBar
	if bar then
		local fits = h <= (scroll:GetHeight() or 0)
		bar:SetShown(not fits)
		if fits then
			scroll:SetVerticalScroll(0)
		end
	end
end

function ns.BuildSettingsPanel(panel)
	if not panel or panel._mhSettingsBuilt then
		return
	end
	panel._mhSettingsBuilt = true
	if panel._body then
		panel._body:Hide()
	end

	ui = { panel = panel, texts = {} }

	-- Everything below is built on `sheet`, a scroll child; the panel's own title (from
	-- CreateModulePanel, 12 px from the top) stays put above it.
	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -44)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 8)
	scroll.scrollBarHideable = true
	local sheet = CreateFrame("Frame", nil, scroll)
	sheet:SetSize(1, 1)
	scroll:SetScrollChild(sheet)
	scroll:SetScript("OnSizeChanged", SizeSettingsSheet)
	ui.scroll, ui.sheet = scroll, sheet

	-- Onthoud label-key per widget zodat een taalwissel alles herlabelt.
	local function track(obj, key, isFS)
		ui.texts[#ui.texts + 1] = { obj = obj, key = key, isFS = isFS }
	end

	local function MakeBtn(w, labelKey, onClick)
		local b = CreateFrame("Button", nil, sheet, "UIPanelButtonTemplate")
		b:SetSize(w, BTN_H)
		b:SetText(ns:L(labelKey))
		b:SetScript("OnClick", function()
			pcall(onClick)
		end)
		track(b, labelKey, false)
		return b
	end

	local function MakeHeader(labelKey, anchorTo, gapY)
		local fs = MakeFS(sheet, "GameFontNormal", COLOR_HEADER)
		fs:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", 0, gapY or -16)
		fs:SetText(ns:L(labelKey))
		track(fs, labelKey, true)
		return fs
	end

	-- Eyecatcher-strip: roterend model links, tagline + versie rechts.
	local eye = CreateFrame("Frame", nil, sheet)
	eye:SetHeight(EYE_H)
	eye:SetPoint("TOPLEFT", sheet, "TOPLEFT", 12, -12)
	eye:SetPoint("RIGHT", sheet, "RIGHT", -16, 0)
	if eye.SetClipsChildren then
		eye:SetClipsChildren(true)
	end
	local eyeModel = CreateFrame("PlayerModel", nil, eye)
	eyeModel:SetPoint("TOPLEFT", eye, "TOPLEFT", 0, -2)
	eyeModel:SetPoint("BOTTOMLEFT", eye, "BOTTOMLEFT", 0, 2)
	eyeModel:SetWidth(110)
	eyeModel:EnableMouse(false)
	ui.eyeModel = eyeModel
	local facing = 0.4
	eye:SetScript("OnUpdate", function(_, elapsed)
		if eyeModel:IsShown() then
			facing = facing + elapsed * 0.35
			pcall(eyeModel.SetFacing, eyeModel, facing)
		end
	end)
	local eyeTag = MakeFS(eye, "GameFontNormal", COLOR_HEADER)
	eyeTag:SetPoint("TOPLEFT", eye, "TOPLEFT", 122, -18)
	eyeTag:SetPoint("RIGHT", eye, "RIGHT", -8, 0)
	ui.eyeTag = eyeTag
	local eyeVer = MakeFS(eye, "GameFontHighlightSmall", COLOR_DIM)
	eyeVer:SetPoint("TOPLEFT", eyeTag, "BOTTOMLEFT", 0, -6)
	eyeVer:SetPoint("RIGHT", eye, "RIGHT", -8, 0)
	ui.eyeVer = eyeVer
	local accent = eye:CreateTexture(nil, "ARTWORK")
	accent:SetHeight(2)
	accent:SetPoint("BOTTOMLEFT", eye, "BOTTOMLEFT", 0, 0)
	accent:SetPoint("BOTTOMRIGHT", eye, "BOTTOMRIGHT", 0, 0)
	accent:SetColorTexture(1, 0.82, 0.2, 0.9)

	-- Uitleg.
	local body = MakeFS(sheet, "GameFontHighlight", COLOR_SOFT)
	body:SetPoint("TOPLEFT", eye, "BOTTOMLEFT", 2, -18)
	body:SetPoint("RIGHT", sheet, "RIGHT", -20, 0)
	body:SetText(ns:L("SET_LAUNCH_BODY"))
	track(body, "SET_LAUNCH_BODY", true)

	-- Primaire knoppen: open native paneel + aanbevolen stand.
	local openBtn = MakeBtn(260, "SET_LAUNCH_OPEN", function()
		if not (ns.OpenNativeSettings and ns.OpenNativeSettings()) then
			-- In combat OpenNativeSettings already printed a "can't open in combat" note
			-- (opening is a protected action); don't also print the API-fallback hint.
			if not (InCombatLockdown and InCombatLockdown()) then
				DEFAULT_CHAT_FRAME:AddMessage(
					("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("SET_LAUNCH_HINT"))
				)
			end
		end
	end)
	openBtn:SetHeight(30)
	openBtn:SetPoint("TOPLEFT", body, "BOTTOMLEFT", 0, -16)

	-- 4.0: the show/hide list inside MH (the Screens page above), right under the big button.
	local screensBtn = MakeBtn(260, "SET_LAUNCH_SCREENS", function()
		if ns.SelectTab then
			ns.SelectTab("screens")
		end
	end)
	screensBtn:SetPoint("TOPLEFT", openBtn, "BOTTOMLEFT", 0, -8)

	local recBtn = MakeBtn(260, "SET_BTN_RECOMMENDED", function()
		if ns.ApplyRecommendedSettings then
			ns.ApplyRecommendedSettings()
		end
	end)
	recBtn:SetPoint("TOPLEFT", screensBtn, "BOTTOMLEFT", 0, -8)

	local hint = MakeFS(sheet, "GameFontHighlightSmall", COLOR_DIM)
	hint:SetPoint("TOPLEFT", recBtn, "BOTTOMLEFT", 2, -12)
	hint:SetPoint("RIGHT", sheet, "RIGHT", -20, 0)
	hint:SetText(ns:L("SET_LAUNCH_HINT"))
	track(hint, "SET_LAUNCH_HINT", true)

	-- Voorbeeld & plaatsen.
	local placeH = MakeHeader("SET_LAUNCH_PLACE", hint, -16)
	local csBtn = MakeBtn(200, "SET_LAUNCH_CS", function()
		if ns.TestCombatSafety then ns.TestCombatSafety() end
	end)
	csBtn:SetPoint("TOPLEFT", placeH, "BOTTOMLEFT", 0, -6)
	local toastBtn = MakeBtn(150, "SET_LAUNCH_TOAST", function()
		if ns.QueueMidnightToast then
			ns.QueueMidnightToast({
				id = "settings-preview",
				title = ns:L("SET_TOAST_POS_TITLE"),
				body = ns:L("SET_TOAST_POS_DESC"),
				displaySec = 12,
			})
		end
	end)
	toastBtn:SetPoint("LEFT", csBtn, "RIGHT", 8, 0)

	-- Snelle acties.
	local actH = MakeHeader("SET_LAUNCH_ACTIONS", csBtn, -16)
	local testRareBtn = MakeBtn(170, "SET_LAUNCH_TEST_RARE", function()
		if ns.TestRareAlert then ns.TestRareAlert() end
	end)
	testRareBtn:SetPoint("TOPLEFT", actH, "BOTTOMLEFT", 0, -6)
	local bossBtn = MakeBtn(170, "SET_LAUNCH_BOSSWIN", function()
		if ns.ToggleDungeonBossWindow then ns.ToggleDungeonBossWindow() end
	end)
	bossBtn:SetPoint("LEFT", testRareBtn, "RIGHT", 8, 0)
	local testShardBtn = MakeBtn(170, "SET_LAUNCH_TEST_SHARD", function()
		if ns.TestShardCapAlert then ns.TestShardCapAlert() end
	end)
	testShardBtn:SetPoint("TOPLEFT", testRareBtn, "BOTTOMLEFT", 0, -6)
	local boardBtn = MakeBtn(170, "SET_LAUNCH_BOARD", function()
		if ns.ShowConsumableBoard then ns.ShowConsumableBoard() end
	end)
	boardBtn:SetPoint("LEFT", testShardBtn, "RIGHT", 8, 0)

	-- Geavanceerd (reset-knoppen).
	local advH = MakeHeader("SET_CAT_ADVANCED", testShardBtn, -16)
	local forgetBtn = MakeBtn(170, "SET_LAUNCH_FORGET", function()
		if ns.db then ns.db.rareNpcIds = {} end
	end)
	forgetBtn:SetPoint("TOPLEFT", advH, "BOTTOMLEFT", 0, -6)
	local resetBossBtn = MakeBtn(170, "SET_LAUNCH_RESETBOSS", function()
		if ns.ResetBossWindowLayout then ns.ResetBossWindowLayout() end
	end)
	resetBossBtn:SetPoint("LEFT", forgetBtn, "RIGHT", 8, 0)
	local toastResetBtn = MakeBtn(170, "SET_LAUNCH_TOAST_RESET", function()
		local uiDb = ns.db and ns.db.ui
		if uiDb and type(uiDb.toast) == "table" then
			uiDb.toast.pos = nil
		end
	end)
	toastResetBtn:SetPoint("TOPLEFT", forgetBtn, "BOTTOMLEFT", 0, -6)
	ui.last = toastResetBtn -- the lowest widget, for the scroll height (nudges move it down)

	-- Notifications & tips (Spec 15): permanent, findable home for nudges.
	if ns.GetSettingsNudges then
		local sNudges = ns.GetSettingsNudges()
		if #sNudges > 0 then
			local nudgeH = MakeHeader("SET_CAT_NUDGES", toastResetBtn, -16)
			local prev = nudgeH
			for _, def in ipairs(sNudges) do
				local b = MakeBtn(220, def.actionLabel, function()
					if def.action then def.action() end
				end)
				b:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -6)
				prev = b
			end
			local resetNudgeBtn = MakeBtn(240, "SET_NUDGE_RESET", function()
				if ns.ResetNudges then ns.ResetNudges() end
			end)
			resetNudgeBtn:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -10)
			ui.last = resetNudgeBtn
		end
	end

	panel:SetScript("OnShow", function()
		ApplyEyecatcherModel()
		ns.RefreshSettingsPanel()
		SizeSettingsSheet()
		-- Once more after the text has wrapped to the new width.
		if C_Timer and C_Timer.After then
			C_Timer.After(0, SizeSettingsSheet)
		end
	end)

	BuildScreensPage(panel)
end

--------------------------------------------------------------------------------
-- Refresh
--------------------------------------------------------------------------------

function ns.RefreshSettingsPanel()
	if not ui or not ui.panel or not ui.panel:IsVisible() then
		return
	end
	ui.eyeTag:SetText(ns:L("SET_EYE_TAGLINE"))
	local ver = "?"
	if C_AddOns and C_AddOns.GetAddOnMetadata then
		ver = C_AddOns.GetAddOnMetadata("MidnightHelper", "Version") or "?"
	elseif GetAddOnMetadata then
		ver = GetAddOnMetadata("MidnightHelper", "Version") or "?"
	end
	ui.eyeVer:SetText(ns:L("SET_ADV_VERSION_FMT"):format(ver))
	for _, t in ipairs(ui.texts) do
		if t.obj then
			if t.isFS then
				t.obj:SetText(ns:L(t.key))
			else
				t.obj:SetText(ns:L(t.key))
			end
		end
	end
end
