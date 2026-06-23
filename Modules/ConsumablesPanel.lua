local addonName, ns = ...

local SCROLL_BOTTOM = 12
local TOOLBAR_H = 28

local function ClassFileToClassID(classToken)
	local up = string.upper(tostring(classToken or ""))
	local n = GetNumClasses and GetNumClasses() or 0
	for i = 1, n do
		local ok, _, file, id = pcall(GetClassInfo, i)
		if ok and file and id and string.upper(tostring(file)) == up then
			return id
		end
	end
	return nil
end

local function SpecCountForClass(classToken)
	local cid = ClassFileToClassID(classToken)
	if cid and GetNumSpecializationsForClassID then
		local ok, n = pcall(GetNumSpecializationsForClassID, cid)
		if ok and n and n > 0 then
			return n
		end
	end
	return 4
end

local function SpecNameFor(classToken, specIdx)
	local cid = ClassFileToClassID(classToken)
	if cid and specIdx and specIdx >= 1 and GetSpecializationInfoForClassID then
		local ok, _, name = pcall(GetSpecializationInfoForClassID, cid, specIdx)
		if ok and name and name ~= "" then
			return name
		end
	end
	return nil
end

local function LocalizedClassName(classToken)
	local cid = ClassFileToClassID(classToken)
	if cid and GetClassInfo then
		local ok, name = pcall(GetClassInfo, cid)
		if ok and name and name ~= "" then
			return name
		end
	end
	return classToken
end

function ns.MH_SetConsumablesPreview(classToken, specIndex)
	if not ns.db then
		return
	end
	if type(ns.db.guide) ~= "table" then
		ns.db.guide = { preview = false, classToken = "", specIndex = 0 }
	end
	local g = ns.db.guide
	g.preview = true
	g.classToken = string.upper(tostring(classToken or ""))
	g.specIndex = tonumber(specIndex) or 1
	if ns.MH_RefreshConsumablesPanel then
		ns.MH_RefreshConsumablesPanel()
	end
	if ns.MH_RefreshMacrosPanel then
		ns.MH_RefreshMacrosPanel()
	end
end

function ns.MH_ClearConsumablesPreview()
	if ns.MH_ClearSearchAndPreview then
		ns.MH_ClearSearchAndPreview()
	elseif ns.db and ns.db.guide then
		ns.db.guide.preview = false
		ns.db.guide.classToken = ""
		ns.db.guide.specIndex = 0
	end
	if ns.MH_RefreshConsumablesPanel then
		ns.MH_RefreshConsumablesPanel()
	end
end

function ns.MH_CycleConsumablesSpec(delta)
	local token, specIdx, isPreview = ns.MH_GetMacroClassSpecContext()
	if not token then
		return
	end
	local n = SpecCountForClass(token)
	if n < 1 then
		return
	end
	local nextIdx = (tonumber(specIdx) or 1) + (delta or 1)
	while nextIdx < 1 do
		nextIdx = nextIdx + n
	end
	while nextIdx > n do
		nextIdx = nextIdx - n
	end
	if isPreview or (ns.db and ns.db.guide and ns.db.guide.preview) then
		ns.MH_SetConsumablesPreview(token, nextIdx)
	else
		-- Same class as player: store preview so we can view other specs without relog.
		ns.MH_SetConsumablesPreview(token, nextIdx)
	end
end

function ns.MH_RefreshConsumablesPanel()
	local panel = ns.panels and ns.panels.consumables
	if not panel or not panel._mhConsScroll or not panel._mhConsHost then
		return
	end
	local token, specIdx, isPreview, classLocalized, specName = ns.MH_GetMacroClassSpecContext()
	if panel._mhConsSpecLine then
		local previewMark = isPreview and ns:L("GUIDE_PREVIEW_MARK") or ""
		if classLocalized and specName and specName ~= "" then
			panel._mhConsSpecLine:SetText(ns:L("MACROS_SPEC_LINE_FMT"):format(classLocalized, specName) .. previewMark)
			panel._mhConsSpecLine:Show()
		elseif classLocalized then
			panel._mhConsSpecLine:SetText(classLocalized .. previewMark)
			panel._mhConsSpecLine:Show()
		else
			panel._mhConsSpecLine:Hide()
		end
	end
	local sw = panel._mhConsScroll:GetWidth() or 500
	local h = ns.MH_BuildConsumablesIntoHost(panel._mhConsHost, token, specIdx, sw)
	panel._mhConsHost:SetHeight(math.max(80, h or 80))
	if panel._mhConsScroll.UpdateScrollChildRect then
		panel._mhConsScroll:UpdateScrollChildRect()
	end
	if panel._mhConsScroll.SetVerticalScroll then
		panel._mhConsScroll:SetVerticalScroll(0)
	end
end

function ns.BuildConsumablesPanel(panel)
	if not panel or panel._mhConsBuilt then
		return
	end
	panel._mhConsBuilt = true
	if panel._body then
		panel._body:Hide()
	end

	if panel._header and panel._header.SetText then
		panel._header:SetText(ns:L("TAB_CONSUMABLES"))
	end

	local toolbar = CreateFrame("Frame", nil, panel)
	toolbar:SetHeight(TOOLBAR_H)
	toolbar:SetPoint("TOPLEFT", panel._header, "BOTTOMLEFT", 0, -6)
	toolbar:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -6)
	panel._mhConsToolbar = toolbar

	local myBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
	myBtn:SetSize(108, 22)
	myBtn:SetPoint("LEFT", toolbar, "LEFT", 0, 0)
	myBtn:SetText(ns:L("SEARCH_MY_CHARACTER"))
	myBtn:SetScript("OnClick", function()
		ns.MH_ClearConsumablesPreview()
	end)

	local prevBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
	prevBtn:SetSize(28, 22)
	prevBtn:SetPoint("LEFT", myBtn, "RIGHT", 6, 0)
	prevBtn:SetText("<")
	prevBtn:SetScript("OnClick", function()
		ns.MH_CycleConsumablesSpec(-1)
	end)

	local nextBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
	nextBtn:SetSize(28, 22)
	nextBtn:SetPoint("LEFT", prevBtn, "RIGHT", 4, 0)
	nextBtn:SetText(">")
	nextBtn:SetScript("OnClick", function()
		ns.MH_CycleConsumablesSpec(1)
	end)

	local specBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
	specBtn:SetSize(140, 22)
	specBtn:SetPoint("LEFT", nextBtn, "RIGHT", 6, 0)
	specBtn:SetText(ns:L("CONS_PICK_SPEC_BTN"))
	specBtn:SetScript("OnClick", function()
		ns.MH_CycleConsumablesSpec(1)
	end)
	panel._mhConsSpecPickBtn = specBtn

	local hintFs = toolbar:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hintFs:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	hintFs:SetPoint("LEFT", specBtn, "RIGHT", 8, 0)
	hintFs:SetPoint("RIGHT", toolbar, "RIGHT", 0, 0)
	hintFs:SetJustifyH("LEFT")
	hintFs:SetText(ns:L("CONS_SPEC_HINT"))
	hintFs:SetTextColor(0.62, 0.60, 0.55)

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	subtitle:SetPoint("TOPLEFT", toolbar, "BOTTOMLEFT", 0, -6)
	subtitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -6)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetSpacing(2)
	subtitle:SetTextColor(0.78, 0.74, 0.68)
	subtitle:SetText(ns:L("MACROS_CONSUMABLES_SUBTITLE"))
	panel._mhConsSubtitle = subtitle

	local specLine = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	specLine:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	specLine:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -6)
	specLine:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -6)
	specLine:SetJustifyH("LEFT")
	specLine:SetTextColor(1, 0.88, 0.55)
	panel._mhConsSpecLine = specLine

	-- Copy bar: clicking an item row drops its name here, pre-selected for
	-- Ctrl+C (handy for Auction House searches). Clicks cycle best → alts.
	local copyLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	copyLabel:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	copyLabel:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 12, 16)
	copyLabel:SetJustifyH("LEFT")
	copyLabel:SetText(ns:L("CONS_COPY_HINT"))
	copyLabel:SetTextColor(0.62, 0.60, 0.55)
	panel._mhConsCopyLabel = copyLabel

	local copyBox = CreateFrame("EditBox", "MidnightHelperConsumablesCopyBox", panel, "InputBoxTemplate")
	copyBox:SetHeight(20)
	copyBox:SetPoint("LEFT", copyLabel, "RIGHT", 12, 0)
	copyBox:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
	copyBox:SetAutoFocus(false)
	copyBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	copyBox:SetScript("OnEditFocusGained", function(self)
		self:HighlightText()
	end)
	panel._mhConsCopyBox = copyBox

	function ns.MH_ConsumablesCopyName(name)
		if not name or name == "" then
			return
		end
		copyBox:SetText(name)
		copyBox:SetFocus()
		copyBox:HighlightText()
	end

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperConsumablesScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", specLine, "BOTTOMLEFT", 0, -8)
	scroll:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 12, SCROLL_BOTTOM + 28)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -12, SCROLL_BOTTOM + 28)
	panel._mhConsScroll = scroll

	local host = CreateFrame("Frame", nil, scroll)
	host:SetWidth(400)
	scroll:SetScrollChild(host)
	panel._mhConsHost = host
	if ns.MH_EnsureConsumablesItemListener then
		ns.MH_EnsureConsumablesItemListener(host)
	end

	panel._mhRefreshConsumables = function()
		if myBtn.SetText then
			myBtn:SetText(ns:L("SEARCH_MY_CHARACTER"))
		end
		if specBtn.SetText then
			specBtn:SetText(ns:L("CONS_PICK_SPEC_BTN"))
		end
		if subtitle.SetText then
			subtitle:SetText(ns:L("MACROS_CONSUMABLES_SUBTITLE"))
		end
		if hintFs.SetText then
			hintFs:SetText(ns:L("CONS_SPEC_HINT"))
		end
		if copyLabel.SetText then
			copyLabel:SetText(ns:L("CONS_COPY_HINT"))
		end
		ns.MH_RefreshConsumablesPanel()
	end

	panel:SetScript("OnShow", function()
		if panel._mhRefreshConsumables then
			panel._mhRefreshConsumables()
		end
	end)

	panel:HookScript("OnSizeChanged", function()
		if panel:IsShown() and panel._mhRefreshConsumables then
			panel._mhRefreshConsumables()
		end
	end)

	local ev = CreateFrame("Frame", nil, panel)
	ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	ev:RegisterEvent("PLAYER_ENTERING_WORLD")
	ev:SetScript("OnEvent", function()
		if panel:IsShown() and panel._mhRefreshConsumables then
			panel._mhRefreshConsumables()
		end
	end)

	panel._mhRefreshConsumables()
end
