--[[
	Midnight Helper — Dawncrest section (Guide tab).
]]

local _, ns = ...

local C_CurrencyInfo = C_CurrencyInfo

local ROW_H = 18
local ICON = 16
local BODY_PAD = 6
local MIN_EXPANDED_BODY_H = 300

local embeddedPanel
local crestRows = {}
local layoutPending = false

local function GetGuideSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { expanded = true }
	end
	if type(ui.dawncrestGuide) ~= "table" then
		ui.dawncrestGuide = { expanded = true }
	end
	return ui.dawncrestGuide
end

local function GetCurrencyQty(currencyId)
	local id = tonumber(currencyId)
	if not id or not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then
		return 0, 0, 0
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
	if not ok or type(info) ~= "table" then
		return 0, 0, 0
	end
	local qty = math.floor(tonumber(info.quantity) or 0)
	local earned = math.floor(tonumber(info.quantityEarnedThisWeek) or 0)
	local maxQ = tonumber(info.maxQuantity) or tonumber(info.maxWeeklyQuantity) or 0
	return qty, earned, math.floor(maxQ)
end

local function GetTierCurrencyQty(tier)
	if type(tier) ~= "table" then
		return 0, 0, 0
	end
	local ids = { tier.currencyId }
	if type(tier.alternateCurrencyIds) == "table" then
		for i = 1, #tier.alternateCurrencyIds do
			ids[#ids + 1] = tier.alternateCurrencyIds[i]
		end
	end
	local bestQty, bestEarned, bestMax = 0, 0, 0
	for i = 1, #ids do
		local q, earned, maxQ = GetCurrencyQty(ids[i])
		if q > bestQty then
			bestQty = q
			bestEarned = earned
			bestMax = maxQ
		end
	end
	return bestQty, bestEarned, bestMax
end

local function RequestDawncrestCurrencyData()
	if not C_CurrencyInfo or not C_CurrencyInfo.RequestCurrencyDataFromServer then
		return
	end
	local tiers = ns.DAWNCREST_TIERS
	if type(tiers) ~= "table" then
		return
	end
	local seen = {}
	for i = 1, #tiers do
		local tier = tiers[i]
		local ids = { tier and tier.currencyId }
		if tier and type(tier.alternateCurrencyIds) == "table" then
			for j = 1, #tier.alternateCurrencyIds do
				ids[#ids + 1] = tier.alternateCurrencyIds[j]
			end
		end
		for j = 1, #ids do
			local id = ids[j]
			if id and not seen[id] then
				seen[id] = true
				pcall(C_CurrencyInfo.RequestCurrencyDataFromServer, id)
			end
		end
	end
end

local function IsAchievementComplete(achievementId)
	local id = tonumber(achievementId)
	if not id or not GetAchievementInfo then
		return false
	end
	local ok, _, _, completed = pcall(GetAchievementInfo, id)
	return ok and completed == true
end

local function SetRowIcon(tex, currencyId)
	if not tex then
		return
	end
	local id = tonumber(currencyId)
	if id and C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
		if ok and info and info.iconFileID then
			tex:SetTexture(info.iconFileID)
			tex:Show()
			return
		end
	end
	if tex.SetAtlas then
		tex:SetAtlas("WarWithin-Icon-Crest")
	end
end

local function ShowCrestCurrencyTooltip(owner, currencyId)
	local id = tonumber(currencyId)
	if not id or not GameTooltip then
		return
	end
	GameTooltip:SetOwner(owner, "ANCHOR_CURSOR")
	if GameTooltip.SetCurrencyByID then
		GameTooltip:SetCurrencyByID(id)
	else
		GameTooltip:ClearLines()
		if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
			local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
			if ok and type(info) == "table" then
				GameTooltip:AddLine(info.name or "?", 1, 1, 1)
				if info.description and info.description ~= "" then
					GameTooltip:AddLine(info.description, 1, 1, 1, true)
				end
			end
		end
	end
	GameTooltip:Show()
end

local function HideCrestCurrencyTooltip()
	if GameTooltip then
		GameTooltip:Hide()
	end
end

local function BindCrestIconTooltip(iconBtn, currencyId)
	if not iconBtn then
		return
	end
	iconBtn._mhCurrencyId = tonumber(currencyId)
	if iconBtn._mhTooltipBound then
		return
	end
	iconBtn._mhTooltipBound = true
	iconBtn:EnableMouse(true)
	iconBtn:SetScript("OnEnter", function(self)
		ShowCrestCurrencyTooltip(self, self._mhCurrencyId)
	end)
	iconBtn:SetScript("OnLeave", HideCrestCurrencyTooltip)
end

local function LayoutButtons()
	local btnRow = embeddedPanel and embeddedPanel._body and embeddedPanel._body._btnRow
	if not btnRow or not embeddedPanel then
		return
	end
	local w = math.max(200, (embeddedPanel:GetWidth() or 0) - 8)
	local half = math.floor((w - 6) / 2)
	if btnRow._btnV then
		btnRow._btnV:SetSize(half, 22)
	end
	if btnRow._btnC then
		btnRow._btnC:SetSize(half, 22)
	end
	if btnRow._btnS then
		btnRow._btnS:SetSize(w, 22)
	end
end

local function MeasureBodyHeight(expanded)
	if not embeddedPanel or not embeddedPanel._body then
		return 0
	end
	if not expanded then
		return 0
	end
	local body = embeddedPanel._body
	local pw = math.max(280, embeddedPanel:GetWidth() or 400)
	body:SetWidth(pw)
	if body._summary then
		body._summary:SetWidth(pw - 12)
	end
	local h = BODY_PAD
	if body._summary and body._summary:IsShown() then
		h = h + (body._summary:GetStringHeight() or 0) + 8
	end
	if body._crestBlock and body._crestBlock:IsShown() then
		h = h + (body._crestBlock:GetHeight() or 0) + 6
	end
	if body._btnRow and body._btnRow:IsShown() then
		h = h + (body._btnRow:GetHeight() or 0) + BODY_PAD
	end
	return math.max(h, MIN_EXPANDED_BODY_H)
end

local function ApplyPanelHeight()
	if not embeddedPanel then
		return
	end
	local expanded = GetGuideSettings().expanded ~= false
	if not expanded then
		embeddedPanel:SetHeight(18)
		return
	end
	local bodyH = MeasureBodyHeight(true)
	if embeddedPanel._body then
		embeddedPanel._body:SetHeight(bodyH)
	end
	embeddedPanel:SetHeight(18 + bodyH)
end

local function SyncHostScroll()
	if ns.SyncReferenceGuideScroll then
		ns.SyncReferenceGuideScroll()
	end
end

local function ScheduleLayout()
	if layoutPending then
		return
	end
	if not C_Timer or not C_Timer.After then
		ApplyPanelHeight()
		SyncHostScroll()
		return
	end
	layoutPending = true
	C_Timer.After(0.05, function()
		layoutPending = false
		ApplyPanelHeight()
		SyncHostScroll()
	end)
end

function ns.RefreshDawncrestGuide()
	if not embeddedPanel then
		return
	end
	RequestDawncrestCurrencyData()
	local s = GetGuideSettings()
	local expanded = s.expanded ~= false
	if embeddedPanel._collapseBtn then
		embeddedPanel._collapseBtn:SetText(expanded and "−" or "+")
	end
	if embeddedPanel._title then
		embeddedPanel._title:SetText(ns:L("DAWNCREST_GUIDE_TITLE"))
	end
	if embeddedPanel._body then
		embeddedPanel._body:SetShown(expanded)
	end
	local summary = embeddedPanel._body and embeddedPanel._body._summary
	if summary then
		summary:SetText(ns:L("DAWNCREST_GUIDE_SUMMARY"))
	end

	local tiers = ns.DAWNCREST_TIERS
	if expanded and type(tiers) == "table" then
		for i = 1, #tiers do
			local tier = tiers[i]
			local row = crestRows[i]
			if tier and row and row.label and row.count then
				local qty, earned, maxQ = GetTierCurrencyQty(tier)
				row.label:SetText(ns:L(tier.labelKey))
				if maxQ > 0 then
					row.count:SetText(ns:L("DAWNCREST_ROW_FMT"):format(qty, earned, maxQ))
				else
					row.count:SetText(tostring(qty))
				end
				SetRowIcon(row.icon, tier.currencyId)
				BindCrestIconTooltip(row.iconBtn, tier.currencyId)
				local rowFrame = row.row
				if row.ach and rowFrame and rowFrame.SetHeight then
					if IsAchievementComplete(tier.achievementId) then
						row.ach:SetText(ns:L("DAWNCREST_ACH_DONE_FMT"):format(ns:L(tier.achLabelKey)))
						row.ach:Show()
						rowFrame:SetHeight(ROW_H + 14)
					else
						row.ach:Hide()
						rowFrame:SetHeight(ROW_H)
					end
				end
			end
		end
		if embeddedPanel._body and embeddedPanel._body._crestBlock then
			local cy = 0
			for i = 1, #tiers do
				local rowFrame = crestRows[i] and crestRows[i].row
				if rowFrame then
					cy = cy + rowFrame:GetHeight() + 4
				end
			end
			embeddedPanel._body._crestBlock:SetHeight(math.max(1, cy))
		end
	end

	LayoutButtons()
	ApplyPanelHeight()
	ScheduleLayout()
end

function ns.EnsureDawncrestGuidePanel(parent)
	if not parent then
		return nil
	end
	if embeddedPanel then
		if embeddedPanel:GetParent() ~= parent then
			embeddedPanel:SetParent(parent)
			embeddedPanel:ClearAllPoints()
		end
		ns.RefreshDawncrestGuide()
		return embeddedPanel
	end

	local panel = CreateFrame("Frame", nil, parent)
	panel:SetClipsChildren(false)

	local titleRow = CreateFrame("Frame", nil, panel)
	titleRow:SetHeight(18)
	titleRow:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
	titleRow:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, 0)

	local collapseBtn = CreateFrame("Button", nil, titleRow)
	collapseBtn:SetSize(18, 18)
	collapseBtn:SetPoint("LEFT", titleRow, "LEFT", 0, 0)
	collapseBtn:SetNormalFontObject(GameFontNormal)
	collapseBtn:SetText("−")
	collapseBtn:SetScript("OnClick", function()
		local gs = GetGuideSettings()
		gs.expanded = not (gs.expanded ~= false)
		ns.RefreshDawncrestGuide()
		if ns.RefreshReferenceGuidePanel then
			ns.RefreshReferenceGuidePanel()
		end
	end)
	panel._collapseBtn = collapseBtn

	local titleFs = titleRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleFs:SetPoint("LEFT", collapseBtn, "RIGHT", 2, 0)
	titleFs:SetPoint("RIGHT", titleRow, "RIGHT", -2, 0)
	titleFs:SetJustifyH("LEFT")
	titleFs:SetTextColor(0.92, 0.88, 0.75)
	titleFs:SetText(ns:L("DAWNCREST_GUIDE_TITLE"))
	panel._title = titleFs

	local body = CreateFrame("Frame", nil, panel)
	body:SetPoint("TOPLEFT", titleRow, "BOTTOMLEFT", 0, -2)
	body:SetPoint("TOPRIGHT", titleRow, "BOTTOMRIGHT", 0, -2)
	body:SetClipsChildren(false)
	panel._body = body

	local summary = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	summary:SetPoint("TOPLEFT", body, "TOPLEFT", 4, -BODY_PAD)
	summary:SetPoint("RIGHT", body, "RIGHT", -4, 0)
	summary:SetJustifyH("LEFT")
	summary:SetWordWrap(true)
	body._summary = summary

	local crestBlock = CreateFrame("Frame", nil, body)
	crestBlock:SetPoint("TOPLEFT", summary, "BOTTOMLEFT", -4, -8)
	crestBlock:SetPoint("RIGHT", body, "RIGHT", 0, 0)
	body._crestBlock = crestBlock

	local tiers = ns.DAWNCREST_TIERS or {}
	local cy = 0
	for i = 1, #tiers do
		local row = CreateFrame("Frame", nil, crestBlock)
		row:SetHeight(ROW_H)
		row:SetPoint("TOPLEFT", crestBlock, "TOPLEFT", 0, -cy)
		row:SetPoint("RIGHT", crestBlock, "RIGHT", 0, 0)

		local iconBtn = CreateFrame("Button", nil, row)
		iconBtn:SetSize(ICON, ICON)
		iconBtn:SetPoint("LEFT", row, "LEFT", 0, 0)
		local icon = iconBtn:CreateTexture(nil, "ARTWORK")
		icon:SetAllPoints(iconBtn)

		local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		label:SetPoint("LEFT", iconBtn, "RIGHT", 4, 0)
		label:SetPoint("RIGHT", row, "RIGHT", -72, 0)
		label:SetJustifyH("LEFT")

		local count = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		count:SetPoint("RIGHT", row, "RIGHT", 0, 0)
		count:SetJustifyH("RIGHT")

		local achFs = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		achFs:SetPoint("TOPLEFT", row, "BOTTOMLEFT", ICON + 4, -1)
		achFs:SetPoint("RIGHT", row, "RIGHT", 0, 0)
		achFs:SetJustifyH("LEFT")
		achFs:SetTextColor(0.45, 0.95, 0.5)
		achFs:Hide()

		crestRows[i] = { icon = icon, iconBtn = iconBtn, label = label, count = count, ach = achFs, row = row }
		BindCrestIconTooltip(iconBtn, tiers[i] and tiers[i].currencyId)
		cy = cy + ROW_H + 4
	end
	crestBlock:SetHeight(math.max(1, cy))

	local btnRow = CreateFrame("Frame", nil, body)
	btnRow:SetHeight(50)
	btnRow:SetPoint("TOPLEFT", crestBlock, "BOTTOMLEFT", 0, -6)
	btnRow:SetPoint("TOPRIGHT", crestBlock, "BOTTOMRIGHT", 0, -6)
	body._btnRow = btnRow

	local pins = ns.DAWNCREST_SMC_PINS or {}
	local btnV = CreateFrame("Button", nil, btnRow, "UIPanelButtonTemplate")
	btnV:SetPoint("TOPLEFT", btnRow, "TOPLEFT", 0, 0)
	btnV:SetText(ns:L("DAWNCREST_BTN_VASKARN"))
	btnV:SetScript("OnClick", function()
		if ns.SetSMCCityWaypoint then
			ns.SetSMCCityWaypoint(pins.vaskarn or "crest_exchange")
		end
	end)
	btnRow._btnV = btnV

	local btnC = CreateFrame("Button", nil, btnRow, "UIPanelButtonTemplate")
	btnC:SetPoint("TOPLEFT", btnV, "TOPRIGHT", 6, 0)
	btnC:SetText(ns:L("DAWNCREST_BTN_CUZOTH"))
	btnC:SetScript("OnClick", function()
		if ns.SetSMCCityWaypoint then
			ns.SetSMCCityWaypoint(pins.cuzoth or "item_upgrades")
		end
	end)
	btnRow._btnC = btnC

	local btnS = CreateFrame("Button", nil, btnRow, "UIPanelButtonTemplate")
	btnS:SetPoint("TOPLEFT", btnV, "BOTTOMLEFT", 0, -4)
	btnS:SetText(ns:L("DAWNCREST_BTN_SMC"))
	btnS:SetScript("OnClick", function()
		if ns.EnsureMainUI then
			ns:EnsureMainUI()
		end
		if ns.SelectTab then
			ns.SelectTab("smcguide")
		end
		if ns.OpenSMCCityGuidePin then
			ns.OpenSMCCityGuidePin(pins.vaskarn or "crest_exchange")
		end
	end)
	btnRow._btnS = btnS

	panel:SetScript("OnSizeChanged", function()
		LayoutButtons()
		ScheduleLayout()
	end)

	embeddedPanel = panel
	ns.DawncrestGuidePanel = panel
	ns.RefreshDawncrestGuide()
	return panel
end

if not ns._mhDawncrestLocaleHooked then
	ns._mhDawncrestLocaleHooked = true
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ns.RefreshDawncrestGuide then
			ns.RefreshDawncrestGuide()
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ev:RegisterEvent("ACHIEVEMENT_EARNED")
ev:SetScript("OnEvent", function()
	if ns.RefreshReferenceGuidePanel then
		ns.RefreshReferenceGuidePanel()
	end
end)
