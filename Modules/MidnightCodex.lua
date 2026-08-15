--[[
	Midnight Helper — Midnight Codex (handbook / Start Here).
]]

local _, ns = ...

-- Shared insets come from ns.UI_METRICS (UI.lua); fallbacks keep the module standalone.
local M = ns.UI_METRICS or {}
local SIDE_PAD = M.sidePad or 14
local TOP_PAD = M.topPad or 12
local CAT_BTN_MIN_W = 72
local CAT_BTN_H = 22
local CAT_BTN_PAD = 14
local CAT_GAP = 4
local ARTICLE_GAP = 14
local LINE_H = 15

local COLOR_HEADER = { 0.91, 0.76, 0.42 }
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

-- Public accessors: UI.lua uses these for the reference→codex tab alias, the
-- info drawer, and the beta-visibility bounce.
function ns.GetActiveCodexCategory()
	return GetCodexCategory()
end

function ns.SetActiveCodexCategory(categoryId)
	SetCodexCategory(categoryId)
end

--- Open the tab (and optional sub-section) for a codex article. Use ns.SelectTab, not ns:SelectTab.
function ns.IsCodexTabEnabled()
	return not ns.IsBetaTabEnabled or ns.IsBetaTabEnabled("codex")
end

function ns.OpenMidnightCodex(categoryId)
	if not ns.IsCodexTabEnabled() then
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("CODEX_BETA_DISABLED"))
			)
		end
		return false
	end
	if ns.ShowMainUI then
		ns:ShowMainUI()
	end
	if ns.SelectTab then
		ns.SelectTab("codex")
	end
	if categoryId then
		SetCodexCategory(categoryId)
	end
	if ns.RefreshCodexPanel then
		ns.RefreshCodexPanel()
	end
	if categoryId == "currencies" and ui and ui.scheduleCurrencyRefresh then
		ui.scheduleCurrencyRefresh()
	end
	return true
end

function ns.NavigateFromCodex(article)
	if type(article) ~= "table" or not article.tabId then
		return
	end
	if ns.ShowMainUI then
		ns:ShowMainUI()
	end
	local tabId = article.tabId
	if ns.IsBetaTabEnabled and not ns.IsBetaTabEnabled(tabId) then
		tabId = "home"
	end
	if ns.SelectTab then
		ns.SelectTab(tabId)
	end
	if tabId == "reference" and ns.SetReferenceGuideSubTab then
		local sub = article.referenceSubTab or "crest"
		ns.SetReferenceGuideSubTab(sub)
	end
	if tabId == "delves" and article.delvesSection and ns.SyncDelvesAccordion then
		ns.SyncDelvesAccordion(article.delvesSection)
	end
end

local function GetCurrencyIcon(currencyId)
	-- ⚠️ GEREPAREERD 15 aug 2026. Stond hier als `ns.GetCodexCurrencyQuantity(id)`
	-- terwijl de functie met een DUBBELE PUNT gedefinieerd is (`function ns:...`).
	-- Daardoor belandde het currency-id op de plek van `self` en was de echte
	-- parameter nil, dus gaf de functie altijd niets terug. Gevolg: de balans is
	-- nog NOOIT getoond — elk currency-artikel liet in plaats daarvan de
	-- terugvalzin "Balance updates when you log in on this character" zien, wat
	-- eruitziet als een uitleg en het in werkelijkheid stilletjes fout deed.
	-- Rob merkte het omdat hij moest hoveren voor een getal dat er hoorde te staan.
	local qty, info = ns.GetCodexCurrencyQuantity and ns:GetCodexCurrencyQuantity(currencyId)
	if info and info.iconFileID then
		return info.iconFileID, qty, info.name
	end
	return nil, qty, nil
end

-- Pool-friendly: scripts are attached once and read _mhCurrencyId at hover
-- time, so a reused block frame only needs the field updated. Pass nil to
-- detach (disables mouse, tooltip stops showing).
local function AttachCurrencyTooltip(frame, currencyId)
	if not frame then
		return
	end
	frame._mhCurrencyId = currencyId
	frame:EnableMouse(currencyId ~= nil)
	if frame._mhTooltipHooked then
		return
	end
	frame._mhTooltipHooked = true
	frame:SetScript("OnEnter", function(self)
		local id = self._mhCurrencyId
		if id and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			if GameTooltip.SetCurrencyByID then
				pcall(GameTooltip.SetCurrencyByID, GameTooltip, id, 0)
			elseif GameTooltip.SetCurrencyToken then
				local _, _, name = GetCurrencyIcon(id)
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
	local heightChanged = false
	for _, block in ipairs(ui.blocks) do
		if block.root and block.root:IsShown() then
			block.root:ClearAllPoints()
			block.root:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
			block.root:SetWidth(w)
			local h = block.root:GetHeight() or 1
			if block.root._mhMeasure then
				h = block.root._mhMeasure() or h
			end
			-- EditBox-hoogtes zijn de eerste meting na SetText soms verouderd
			-- (zelfde valkuil als RaidGuide en de Dungeon Coach): één verspringende
			-- hoogte plant precies één hermeting, twee gelijke passes stoppen de lus.
			if block.root._mhLastH ~= h then
				block.root._mhLastH = h
				heightChanged = true
			end
			block.root:SetHeight(h)
			y = y + h + ARTICLE_GAP
		end
	end
	ui.child:SetHeight(math.max(y + 8, 1))
	if ui.scroll and ui.scroll.UpdateScrollChildRect then
		ui.scroll:UpdateScrollChildRect()
	end
	if heightChanged and C_Timer and C_Timer.After and not ui._mhRelayoutPending then
		ui._mhRelayoutPending = true
		C_Timer.After(0, function()
			ui._mhRelayoutPending = false
			LayoutContent()
		end)
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

-- Frame pool (AcquireRow pattern from HomeDashboard ~r.413): article blocks
-- are created once with every sub-element and reused on each refresh. WoW
-- frames are never garbage-collected, so the old create-per-refresh approach
-- accumulated dead frames on every CURRENCY_DISPLAY_UPDATE while the
-- Currencies category was open.
local function AcquireArticleBlock(index)
	local pool = ui.blockPool
	local block = pool[index]
	if block then
		return block
	end

	local root = CreateFrame("Frame", nil, ui.child)
	root:SetWidth(ui.child:GetWidth() or 300)

	-- Title hit-rect; doubles as currency tooltip area when the article has one.
	local titleHit = CreateFrame("Frame", nil, root)
	titleHit:SetPoint("TOPLEFT", root, "TOPLEFT", 0, 0)
	titleHit:SetPoint("RIGHT", root, "RIGHT", 0, 0)
	titleHit:SetHeight(20)

	local titleFs = titleHit:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleFs:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	titleFs:SetPoint("TOPLEFT", titleHit, "TOPLEFT", 0, 0)
	titleFs:SetPoint("RIGHT", titleHit, "RIGHT", 0, 0)
	titleFs:SetJustifyH("LEFT")

	local curRow = CreateFrame("Frame", nil, root)
	curRow:SetSize(200, 20)
	curRow:SetPoint("TOPLEFT", titleHit, "BOTTOMLEFT", 0, -4)

	local icon = curRow:CreateTexture(nil, "ARTWORK")
	icon:SetSize(18, 18)
	icon:SetPoint("LEFT", curRow, "LEFT", 0, 0)

	local curFs = curRow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	curFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	curFs:SetPoint("LEFT", icon, "RIGHT", 6, 0)
	curFs:SetJustifyH("LEFT")
	curFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])

	-- ⚠️ OMGEBOUWD 15 aug 2026, op Robs herhaalde wens: klikbare coördinaten in de
	-- Codex-tekst. Een FontString kan geen hyperlinks; dit is nu de read-only
	-- multiline EditBox die RaidGuide en de coach al jaren gebruiken, met dezelfde
	-- hyperlink-attach. De hoogtemeting verhuist mee naar het GetNumLines-patroon
	-- inclusief de één-frame-hermeting — de FontString-meting met GetStringHeight
	-- gaf hier op 15 jul al eens overlappende artikelen, dus die valkuil is bekend
	-- en de beveiliging ertegen zit in LayoutContent.
	local bodyFs = CreateFrame("EditBox", nil, root)
	bodyFs:SetMultiLine(true)
	bodyFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	bodyFs:SetJustifyH("LEFT")
	bodyFs:SetAutoFocus(false)
	bodyFs:EnableMouse(true)
	if bodyFs.SetMaxLetters then
		bodyFs:SetMaxLetters(0)
	end
	bodyFs:SetTextColor(COLOR_BODY[1], COLOR_BODY[2], COLOR_BODY[3])
	bodyFs._mhTipBox = true
	if ns.AttachDelveTipHyperlinksToEditBox then
		ns:AttachDelveTipHyperlinksToEditBox(bodyFs)
	end

	-- Meetlat. Een EditBox kan zijn eigen tekst niet opmeten (geen GetStringHeight),
	-- dus stond hier regels x (fontH + 2). Die "+ 2" is een gok, en een gok per regel
	-- schaalt mee met de lengte: onzichtbaar op een tip van vier regels, een gat van
	-- ruim honderd pixels onder een artikel van zestig (Rob, screenshot 15 aug — de
	-- Vaults-tekst eindigde en het volgende artikel begon pas een halve schermhoogte
	-- later). Een onzichtbare FontString met dezelfde font en breedte kán het wél
	-- exact zeggen. Hij wordt nooit getekend; hij bestaat alleen om te meten.
	local measureFs = root:CreateFontString(nil, "ARTWORK")
	measureFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	measureFs:SetJustifyH("LEFT")
	measureFs:SetPoint("TOPLEFT", root, "TOPLEFT", 0, 0)
	measureFs:SetAlpha(0)

	local navBtn = CreateFrame("Button", nil, root, "UIPanelButtonTemplate")
	navBtn:SetHeight(22)
	navBtn:SetPoint("TOPLEFT", bodyFs, "BOTTOMLEFT", 0, -6)
	navBtn:SetScript("OnClick", function(self)
		if self._mhArticle and ns.NavigateFromCodex then
			ns.NavigateFromCodex(self._mhArticle)
		end
	end)

	-- Routeknop (15 aug 2026): een artikel dat een bestaande hunt beschrijft mag hem
	-- ook stárten. Zelfde route, pijl en skip-gedrag als de Achievements-tab — dit is
	-- alleen een tweede deurtje naar dezelfde machine.
	local routeBtn = CreateFrame("Button", nil, root, "UIPanelButtonTemplate")
	routeBtn:SetHeight(22)
	routeBtn:SetPoint("TOPLEFT", bodyFs, "BOTTOMLEFT", 0, -6)
	routeBtn:SetScript("OnClick", function(self)
		if self._mhRouteAch and ns.RouteAchievementHuntById then
			ns.RouteAchievementHuntById(self._mhRouteAch)
		end
	end)

	block = {
		root = root,
		titleHit = titleHit,
		titleFs = titleFs,
		curRow = curRow,
		icon = icon,
		curFs = curFs,
		bodyFs = bodyFs,
		measureFs = measureFs,
		navBtn = navBtn,
		routeBtn = routeBtn,
	}
	root._mhMeasure = function()
		local h = (titleHit:GetHeight() or 20) + 6
		if curRow:IsShown() then
			h = h + 24
		end
		-- Geef de body eerst een EXPLICIETE breedte, dán meten. Met alleen
		-- twee-zijdige anchors is de wrap-hoogte in dezelfde frame nog niet
		-- doorgerekend → GetStringHeight() gaf een te lage (single-line) waarde
		-- en de volgende Codex-entry ging overlappen (Rob 15 jul). root-breedte
		-- staat hier al: beide call-sites zetten die vóór het meten.
		local bw = root:GetWidth()
		if bw and bw > 0 then
			bodyFs:SetWidth(bw)
			measureFs:SetWidth(bw)
		end
		-- EditBox: hoogte = regels x regelhoogte (GetStringHeight bestaat hier niet).
		-- De eerste meting na een SetText kan verouderd zijn; LayoutContent plant
		-- daarom één hermeting zodra een hoogte verspringt.
		local lineH = 14
		if bodyFs.GetFont then
			local _, fontH = bodyFs:GetFont()
			if fontH and fontH > 0 then
				lineH = fontH + 2
			end
		end
		local numLines = (bodyFs.GetNumLines and bodyFs:GetNumLines()) or 1
		local guess = math.max(numLines * lineH, 14)
		-- De gemeten hoogte wint van de geschatte — behalve in precies de ene manier
		-- waarop meten hier eerder faalde. Op 15 jul gaf GetStringHeight een verouderde
		-- single-line-waarde en gingen artikelen over elkaar heen; die fout is altijd
		-- VEEL te klein, nooit een beetje. Wijkt de meting minder dan de helft af van
		-- de schatting, dan is ze echt en gebruiken we haar. Ligt ze daaronder, dan is
		-- ze stale en valt hij terug op de schatting — te veel wit is lelijk, tekst
		-- over tekst is onleesbaar, en van die twee wil je de lelijke.
		local textH = guess
		local measured = measureFs.GetStringHeight and measureFs:GetStringHeight() or 0
		if measured and measured >= guess * 0.5 then
			textH = measured
		end
		h = h + 6 + math.max(textH, 14) + 6
		-- Diagnose: als het gat er nog steeds is, zeggen deze drie getallen meteen
		-- welke van de twee metingen loog. Naar de SavedVariables, niet naar chat.
		if ns.db and block and block.article then
			ns.db.codexMeasure = ns.db.codexMeasure or {}
			ns.db.codexMeasure[block.article.bodyKey or "?"] = {
				lines = numLines, lineH = lineH, guess = guess,
				measured = measured, used = textH,
			}
		end
		if navBtn:IsShown() or routeBtn:IsShown() then
			h = h + 30
		end
		return h
	end

	pool[index] = block
	return block
end

local function ApplyArticleToBlock(block, article)
	block.article = article
	block.titleFs:SetText("|cffffcc00" .. CodexL(article.titleKey) .. "|r")
	AttachCurrencyTooltip(block.titleHit, article.currencyId)

	if article.currencyId then
		local iconId, qty = GetCurrencyIcon(article.currencyId)
		block.icon:SetTexture(iconId)
		if qty ~= nil then
			block.curFs:SetText(CodexL("CODEX_BALANCE_FMT"):format(qty))
		else
			block.curFs:SetText(CodexL("CODEX_BALANCE_UNKNOWN"))
		end
		AttachCurrencyTooltip(block.icon, article.currencyId)
		AttachCurrencyTooltip(block.curRow, article.currencyId)
		block.curRow:Show()
	else
		AttachCurrencyTooltip(block.icon, nil)
		AttachCurrencyTooltip(block.curRow, nil)
		block.curRow:Hide()
	end

	-- Body sits under the currency row when present, else directly under the title.
	-- Only a TOPLEFT anchor + an explicit SetWidth (applied in _mhMeasure) — a
	-- second RIGHT anchor would over-constrain the FontString and fight SetWidth.
	local anchor = article.currencyId and block.curRow or block.titleHit
	block.bodyFs:ClearAllPoints()
	block.bodyFs:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6)
	-- Breedte vóór SetText: een EditBox wikkelt bij het zetten, en een meting op
	-- de oude breedte is precies de overlap-bug van 15 jul in een nieuw jasje.
	block.bodyFs:SetWidth(ui.child:GetWidth() or 300)
	local bodyText = CodexL(article.bodyKey)
	if ns.ExpandDelveTipMarkup then
		bodyText = ns:ExpandDelveTipMarkup(bodyText) -- {WAY:}/{SPELL:} → klikbaar
	end
	block.bodyFs:SetText(bodyText)
	-- Dezelfde tekst in de meetlat, anders meet hij het vorige artikel op.
	if block.measureFs then
		block.measureFs:SetWidth(ui.child:GetWidth() or 300)
		block.measureFs:SetText(bodyText)
	end

	if article.tabId then
		block.navBtn._mhArticle = article
		local labelKey = article.navLabelKey or article.tabLabelKey or "TAB_HOME"
		block.navBtn:SetText(CodexL("CODEX_OPEN_TAB_FMT"):format(CodexL(labelKey)))
		local tw = block.navBtn:GetFontString() and block.navBtn:GetFontString():GetStringWidth() or 120
		block.navBtn:SetWidth(math.min(280, math.max(120, tw + 28)))
		block.navBtn:Show()
	else
		block.navBtn._mhArticle = nil
		block.navBtn:Hide()
	end

	if article.routeAchievementID then
		block.routeBtn._mhRouteAch = article.routeAchievementID
		block.routeBtn:SetText(CodexL("CODEX_ROUTE_BTN"))
		local tw = block.routeBtn:GetFontString() and block.routeBtn:GetFontString():GetStringWidth() or 120
		block.routeBtn:SetWidth(math.min(280, math.max(120, tw + 28)))
		-- Naast de navBtn als die er ook is; anders op diens plek.
		block.routeBtn:ClearAllPoints()
		if article.tabId then
			block.routeBtn:SetPoint("LEFT", block.navBtn, "RIGHT", 6, 0)
		else
			block.routeBtn:SetPoint("TOPLEFT", block.bodyFs, "BOTTOMLEFT", 0, -6)
		end
		block.routeBtn:Show()
	else
		block.routeBtn._mhRouteAch = nil
		block.routeBtn:Hide()
	end

	block.root:SetWidth(ui.child:GetWidth() or 300)
	block.root:SetHeight(block.root._mhMeasure())
	block.root:Show()
	return block
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
		-- Beta-gated categories (reference) hide with their Settings checkbox.
		if btn and cat.betaKey and ns.IsBetaTabEnabled and not ns.IsBetaTabEnabled(cat.betaKey) then
			btn:Hide()
		elseif btn then
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

-- Host frame for the embedded Reference panel (former top-level tab). Sits in
-- the same slot as the article scroll; RefreshCodexPanel toggles between them.
local function EnsureReferenceHost()
	if not ui or not ui.panel then
		return nil
	end
	if ui.referenceHost then
		return ui.referenceHost
	end
	local host = CreateFrame("Frame", "MidnightHelperCodexReferenceHost", ui.panel)
	host:SetPoint("TOPLEFT", ui.catNav, "BOTTOMLEFT", 0, -8)
	host:SetPoint("BOTTOMRIGHT", ui.panel, "BOTTOMRIGHT", -8, 8)
	host:Hide()
	ui.referenceHost = host
	return host
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
	-- Saved category may be beta-gated off (reference): bounce to Start.
	if categoryId == "reference" and ns.IsBetaTabEnabled and not ns.IsBetaTabEnabled("reference") then
		SetCodexCategory("start")
		categoryId = "start"
		RefreshCategoryNav()
	end

	-- Reference renders as the embedded ReferenceGuide panel (own scroll plus
	-- Dawncrest/Professions sub-tabs) instead of article blocks.
	if categoryId == "reference" then
		if ui.scroll then
			ui.scroll:Hide()
		end
		local host = EnsureReferenceHost()
		if host then
			host:Show()
			if ns.BuildReferenceGuidePanel then
				-- Idempotent: builds once, refreshes afterwards.
				ns.BuildReferenceGuidePanel(host)
			end
		end
		return
	end
	if ui.referenceHost then
		ui.referenceHost:Hide()
	end
	if ui.scroll then
		ui.scroll:Show()
	end

	if categoryId == "currencies" and ns.RequestCodexCurrencyData then
		ns:RequestCodexCurrencyData()
	end
	local articles = ns.GetCodexArticlesForCategory and ns:GetCodexArticlesForCategory(categoryId) or {}
	for i, article in ipairs(articles) do
		ui.blocks[#ui.blocks + 1] = ApplyArticleToBlock(AcquireArticleBlock(i), article)
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
	if categoryId == "currencies" and ui and ui.scheduleCurrencyRefresh then
		ui.scheduleCurrencyRefresh()
	end
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
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(CodexL("CODEX_PANEL_TITLE"))

	local intro = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	intro:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
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
		-- Reusable article-block frames, indexed by display position (see AcquireArticleBlock).
		blockPool = {},
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
		if GetCodexCategory() == "currencies" and ui.scheduleCurrencyRefresh then
			ui.scheduleCurrencyRefresh()
		end
	end)

	local ev = CreateFrame("Frame")
	ev:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	ev:SetScript("OnEvent", function()
		if ui and ui.panel and ui.panel:IsShown() and GetCodexCategory() == "currencies" then
			ns.RefreshCodexPanel()
		end
	end)
	ui._mhCurrencyRetryToken = 0
	local function scheduleCurrencyRefresh()
		if not C_Timer or not C_Timer.After then
			return
		end
		ui._mhCurrencyRetryToken = (ui._mhCurrencyRetryToken or 0) + 1
		local token = ui._mhCurrencyRetryToken
		for _, delay in ipairs({ 0.15, 0.5, 1.0 }) do
			C_Timer.After(delay, function()
				if ui._mhCurrencyRetryToken ~= token then
					return
				end
				if ui.panel and ui.panel:IsShown() and GetCodexCategory() == "currencies" then
					ns.RefreshCodexPanel()
				end
			end)
		end
	end
	ui.scheduleCurrencyRefresh = scheduleCurrencyRefresh

	ns.CodexPanel = panel
end

function ns.TryCodexSearch(query)
	if type(query) ~= "string" or query == "" then
		return false
	end
	if not ns.IsCodexTabEnabled() then
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
		{ "crest", "reference" },
		{ "reference", "reference" },
	}
	local function openHit(cat)
		if not ns.OpenMidnightCodex(cat) then
			return false
		end
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(
				("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("CODEX_SEARCH_OPENED"))
			)
		end
		return true
	end

	-- Pass 1: exact substring match (cheap, original behavior).
	for i = 1, #hits do
		if q:find(hits[i][1], 1, true) then
			return openHit(hits[i][2])
		end
	end

	-- Pass 2: typo tolerance. Compare each query word against single-word
	-- needles with a small Levenshtein budget (1 for 5-7 chars, 2 for 8+),
	-- so "dawncreast" and "danwcrest" still land on "dawncrest". Short
	-- needles stay exact-only to avoid false positives ("m+", "week").
	local function editDistance(a, b)
		local la, lb = #a, #b
		if math.abs(la - lb) > 2 then
			return 99
		end
		local prev, cur = {}, {}
		for j = 0, lb do
			prev[j] = j
		end
		for i2 = 1, la do
			cur[0] = i2
			local ca = a:byte(i2)
			for j = 1, lb do
				local cost = (ca == b:byte(j)) and 0 or 1
				cur[j] = math.min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + cost)
			end
			prev, cur = cur, prev
		end
		return prev[lb]
	end

	for word in q:gmatch("[%a]+") do
		local wl = #word
		if wl >= 5 then
			for i = 1, #hits do
				local needle = hits[i][1]
				local nl = #needle
				if nl >= 5 and not needle:find("%s") then
					local budget = (nl >= 8 and wl >= 8) and 2 or 1
					if editDistance(word, needle) <= budget then
						return openHit(hits[i][2])
					end
				end
			end
		end
	end
	return false
end

-- NOTE: the old wrap of ns.MH_RunSearchQuery here was dead code — Guide.lua
-- loads after this file (see TOC) and assigns ns.MH_RunSearchQuery wholesale,
-- discarding the wrapper. Codex search precedence now lives at the search-bar
-- call site in UI.lua (runSearchFromBar), which calls ns.TryCodexSearch first.

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
