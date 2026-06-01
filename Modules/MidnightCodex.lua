--[[
	Midnight Helper — Midnight Codex (handbook / Start Here).
]]

local _, ns = ...

local SIDE_PAD = 14
local TOP_PAD = 12
local CAT_BTN_MIN_W = 72
local CAT_BTN_H = 22
local CAT_BTN_PAD = 14
local CAT_GAP = 4
local ARTICLE_GAP = 14
local LINE_H = 15

local COLOR_HEADER = { 0.82, 0.68, 0.30 }
local COLOR_DIM = { 0.72, 0.75, 0.82 }
local COLOR_LINK = { 0.55, 0.78, 1 }
local COLOR_BODY = { 0.88, 0.86, 0.82 }

local ui

local function CodexL(key)
	if ns.SafeL then
		return ns:SafeL(key)
	end
	return ns:L(key)
end

local function GetCodexSettings()
	local s = ns.db and ns.db.ui
	if type(s) ~= "table" then
		return { category = "start" }
	end
	if type(s.codex) ~= "table" then
		s.codex = { category = "start" }
	end
	if not s.codex.category then
		s.codex.category = "start"
	end
	return s.codex
end

local function SetCodexCategory(categoryId)
	GetCodexSettings().category = categoryId
end

local function GetCodexCategory()
	return GetCodexSettings().category or "start"
end

local function GetCurrencyIcon(currencyId)
	local qty, info = ns.GetCodexCurrencyQuantity and ns.GetCodexCurrencyQuantity(currencyId)
	if info and info.iconFileID then
		return info.iconFileID, qty, info.name
	end
	return nil, qty, nil
end

local function AttachCurrencyTooltip(frame, currencyId)
	if not frame or not currencyId then
		return
	end
	frame:EnableMouse(true)
	frame:SetScript("OnEnter", function(self)
		if GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			if GameTooltip.SetCurrencyByID then
				pcall(GameTooltip.SetCurrencyByID, GameTooltip, currencyId, 0)
			elseif GameTooltip.SetCurrencyToken then
				local _, _, name = GetCurrencyIcon(currencyId)
				if name then
					pcall(GameTooltip.SetCurrencyToken, GameTooltip, name)
				end
			end
			GameTooltip:Show()
		end
	end)
	frame:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
end

local function LayoutContent()
	if not ui or not ui.child then
		return
	end
	local w = ui.child:GetWidth()
	if not w or w <= 0 then
		return
	end

	local y = 4
	for _, block in ipairs(ui.blocks) do
		if block.root and block.root:IsShown() then
			block.root:ClearAllPoints()
			block.root:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
			block.root:SetWidth(w)
			local h = block.root:GetHeight() or 1
			if block.root._mhMeasure then
				h = block.root._mhMeasure() or h
			end
			y = y + h + ARTICLE_GAP
		end
	end
	ui.child:SetHeight(math.max(y + 8, 1))
	if ui.scroll and ui.scroll.UpdateScrollChildRect then
		ui.scroll:UpdateScrollChildRect()
	end
end

local function ClearBlocks()
	if not ui then
		return
	end
	for _, block in ipairs(ui.blocks) do
		if block.root then
			block.root:Hide()
		end
	end
	for i = #ui.blocks, 1, -1 do
		ui.blocks[i] = nil
	end
end

local function CreateArticleBlock(article)
	local child = ui.child
	local root = CreateFrame("Frame", nil, child)
	root:SetWidth(child:GetWidth() or 300)

	local titleFs = root:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleFs:SetPoint("TOPLEFT", root, "TOPLEFT", 0, 0)
	titleFs:SetPoint("RIGHT", root, "RIGHT", 0, 0)
	titleFs:SetJustifyH("LEFT")
	titleFs:SetText("|cffffcc00" .. CodexL(article.titleKey) .. "|r")

	local anchor = titleFs

	if article.currencyId then
		local curRow = CreateFrame("Frame", nil, root)
		curRow:SetSize(200, 20)
		curRow:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -4)

		local icon = curRow:CreateTexture(nil, "ARTWORK")
		icon:SetSize(18, 18)
		icon:SetPoint("LEFT", curRow, "LEFT", 0, 0)
		local iconId, qty = GetCurrencyIcon(article.currencyId)
		if iconId then
			icon:SetTexture(iconId)
		end
		AttachCurrencyTooltip(icon, article.currencyId)

		local curFs = curRow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		curFs:SetPoint("LEFT", icon, "RIGHT", 6, 0)
		curFs:SetJustifyH("LEFT")
		if qty ~= nil then
			curFs:SetText(CodexL("CODEX_BALANCE_FMT"):format(qty))
		else
			curFs:SetText(CodexL("CODEX_BALANCE_UNKNOWN"))
		end
		curFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
		anchor = curRow
	end

	local bodyFs = root:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	bodyFs:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6)
	bodyFs:SetPoint("RIGHT", root, "RIGHT", 0, 0)
	bodyFs:SetJustifyH("LEFT")
	bodyFs:SetWordWrap(true)
	bodyFs:SetText(CodexL(article.bodyKey))
	bodyFs:SetTextColor(COLOR_BODY[1], COLOR_BODY[2], COLOR_BODY[3])

	local navBtn
	if article.tabId then
		navBtn = CreateFrame("Button", nil, root, "UIPanelButtonTemplate")
		navBtn:SetHeight(22)
		local labelKey = article.tabLabelKey or "TAB_HOME"
		navBtn:SetText(CodexL("CODEX_OPEN_TAB_FMT"):format(CodexL(labelKey)))
		navBtn:SetPoint("TOPLEFT", bodyFs, "BOTTOMLEFT", 0, -6)
		navBtn:SetScript("OnClick", function()
			if ns.SelectTab then
				ns:SelectTab(article.tabId)
			end
		end)
		local tw = navBtn:GetFontString() and navBtn:GetFontString():GetStringWidth() or 120
		navBtn:SetWidth(math.min(280, math.max(120, tw + 28)))
	end

	root._mhMeasure = function()
		local h = (titleFs:GetStringHeight() or 16) + 6
		if article.currencyId then
			h = h + 24
		end
		h = h + 6 + (bodyFs:GetStringHeight() or 40) + 6
		if navBtn then
			h = h + 30
		end
		return h
	end
	root:SetHeight(root._mhMeasure())
	root:Show()

	return { root = root, article = article }
end

local function RefreshCategoryNav()
	if not ui or not ui.catButtons then
		return
	end
	local active = GetCodexCategory()
	for catId, btn in pairs(ui.catButtons) do
		if btn then
			if catId == active then
				btn:SetAlpha(1)
			else
				btn:SetAlpha(0.82)
			end
		end
	end
end

local function LayoutCategoryNav()
	if not ui or not ui.catNav or not ui.catButtons then
		return
	end
	local navW = ui.catNav:GetWidth() or 320
	if navW < 120 then
		navW = 320
	end
	local x, rowY = 0, 0
	for _, cat in ipairs(ns.CODEX_CATEGORIES or {}) do
		local btn = ui.catButtons[cat.id]
		if btn then
			local label = CodexL(cat.labelKey)
			if ns.EscapeButtonAmpersand then
				label = ns:EscapeButtonAmpersand(label)
			end
			btn:SetText(label)
			btn:SetHeight(CAT_BTN_H)
			local fs = btn.GetFontString and btn:GetFontString()
			local textW = (fs and fs.GetStringWidth and fs:GetStringWidth()) or 0
			local bw = math.min(navW - 4, math.max(CAT_BTN_MIN_W, math.ceil(textW + CAT_BTN_PAD)))
			btn:SetSize(bw, CAT_BTN_H)
			if fs and fs.GetStringWidth then
				textW = fs:GetStringWidth() or textW
				bw = math.min(navW - 4, math.max(CAT_BTN_MIN_W, math.ceil(textW + CAT_BTN_PAD)))
				btn:SetSize(bw, CAT_BTN_H)
			end
			if x > 0 and (x + bw) > navW then
				x = 0
				rowY = rowY - (CAT_BTN_H + CAT_GAP)
			end
			btn:ClearAllPoints()
			btn:SetPoint("TOPLEFT", ui.catNav, "TOPLEFT", x, rowY)
			btn:SetSize(bw, CAT_BTN_H)
			btn:Show()
			x = x + bw + CAT_GAP
		end
	end
	ui.catNav:SetHeight(math.abs(rowY) + CAT_BTN_H + 6)
end

function ns.RefreshCodexPanel()
	if not ui or not ui.panel then
		return
	end
	if ui.intro then
		ui.intro:SetText(CodexL("CODEX_PANEL_INTRO"))
	end
	if ui.title then
		ui.title:SetText(CodexL("CODEX_PANEL_TITLE"))
	end
	LayoutCategoryNav()
	RefreshCategoryNav()
	ClearBlocks()

	local categoryId = GetCodexCategory()
	local articles = ns.GetCodexArticlesForCategory and ns:GetCodexArticlesForCategory(categoryId) or {}
	for _, article in ipairs(articles) do
		ui.blocks[#ui.blocks + 1] = CreateArticleBlock(article)
	end

	LayoutContent()
	if ui.scroll and ui.scroll.SetVerticalScroll then
		ui.scroll:SetVerticalScroll(0)
	end
end

local function SelectCodexCategory(categoryId)
	if not ns.GetCodexCategoryById or not ns:GetCodexCategoryById(categoryId) then
		categoryId = "start"
	end
	SetCodexCategory(categoryId)
	ns.RefreshCodexPanel()
end

function ns.BuildCodexPanel(panel)
	if not panel or panel._mhCodexBuilt then
		return
	end
	panel._mhCodexBuilt = true

	if panel._header then
		panel._header:Hide()
	end
	if panel._body then
		panel._body:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(CodexL("CODEX_PANEL_TITLE"))

	local intro = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	intro:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	intro:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	intro:SetJustifyH("LEFT")
	intro:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	intro:SetText(CodexL("CODEX_PANEL_INTRO"))

	local catNav = CreateFrame("Frame", nil, panel)
	catNav:SetPoint("TOPLEFT", intro, "BOTTOMLEFT", -2, -8)
	catNav:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	catNav:SetHeight(52)

	local catButtons = {}
	for _, cat in ipairs(ns.CODEX_CATEGORIES or {}) do
		local btn = CreateFrame("Button", nil, catNav, "UIPanelButtonTemplate")
		btn:SetHeight(CAT_BTN_H)
		local catId = cat.id
		btn:SetScript("OnClick", function()
			SelectCodexCategory(catId)
		end)
		catButtons[cat.id] = btn
	end

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperCodexScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", catNav, "BOTTOMLEFT", 0, -8)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)
	scroll:EnableMouseWheel(true)

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)

	ui = {
		panel = panel,
		title = title,
		intro = intro,
		catNav = catNav,
		catButtons = catButtons,
		scroll = scroll,
		child = child,
		blocks = {},
	}

	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
			LayoutCategoryNav()
			LayoutContent()
		end
	end
	scroll:SetScript("OnSizeChanged", syncWidth)
	catNav:SetScript("OnSizeChanged", syncWidth)
	panel:SetScript("OnSizeChanged", syncWidth)
	syncWidth()

	panel:SetScript("OnShow", function()
		syncWidth()
		ns.RefreshCodexPanel()
	end)

	local ev = CreateFrame("Frame")
	ev:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	ev:SetScript("OnEvent", function()
		if ui and ui.panel and ui.panel:IsShown() and GetCodexCategory() == "currencies" then
			ns.RefreshCodexPanel()
		end
	end)

	ns.CodexPanel = panel
end

function ns.TryCodexSearch(query)
	if type(query) ~= "string" or query == "" then
		return false
	end
	local q = query:lower():gsub("^%s+", ""):gsub("%s+$", "")
	if q == "" then
		return false
	end
	local hits = {
		{ "codex", "start" },
		{ "wiki", "start" },
		{ "handbook", "start" },
		{ "start here", "start" },
		{ "currency", "currencies" },
		{ "currencies", "currencies" },
		{ "valuta", "currencies" },
		{ "weekly", "weekly" },
		{ "week", "weekly" },
		{ "delve", "delves" },
		{ "delves", "delves" },
		{ "vault", "weekly" },
		{ "great vault", "weekly" },
		{ "m+", "dungeons" },
		{ "mythic", "dungeons" },
		{ "raid", "raid" },
		{ "void", "world" },
		{ "ritual", "world" },
		{ "rare", "world" },
		{ "profession", "professions" },
	}
	for i = 1, #hits do
		local needle, cat = hits[i][1], hits[i][2]
		if q:find(needle, 1, true) then
			if ns.ShowMainUI then
				ns:ShowMainUI()
			end
			if ns.SelectTab then
				ns:SelectTab("codex")
			end
			SelectCodexCategory(cat)
			if DEFAULT_CHAT_FRAME then
				DEFAULT_CHAT_FRAME:AddMessage(
					("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("CODEX_SEARCH_OPENED"))
				)
			end
			return true
		end
	end
	return false
end

do
	local origSearch = ns.MH_RunSearchQuery
	function ns.MH_RunSearchQuery(query)
		if ns.TryCodexSearch and ns.TryCodexSearch(query) then
			return
		end
		if origSearch then
			return origSearch(query)
		end
	end
end

do
	local origLocale = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if origLocale then
			origLocale(self)
		end
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshCodexPanel()
		end
	end
end
