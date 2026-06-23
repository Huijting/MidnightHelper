--[[
	Midnight Helper — Professions beginner guide (Guide tab → Professions).
	Layout: Professions 101 (collapsible) + picker + one profession detail at a time.

]]


local _, ns = ...


local TITLE_H = 18
local BODY_PAD = 6
local BTN_ROW_H = 26
local COMBO_LINK_H = 22
local COMBO_LINK_GAP = 4
local SECTION_GAP = 8
local PICKER_ROW_H = 28
local PICKER_GAP = 4
local DEFAULT_PROF_KEY = "combo_te"


local hostPanel
local introFrame
local pickerRow
local pickerButtons = {}
local detailFrame
local layoutPending = false
local urlCopyFrame


local RefreshIntroSection
local RefreshDetailSection
local RelayoutPanel
local ScheduleLayout


local function GetGuideSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { expanded101 = true, selectedKey = DEFAULT_PROF_KEY }
	end
	if type(ui.professionsGuide) ~= "table" then
		ui.professionsGuide = { expanded101 = true, selectedKey = DEFAULT_PROF_KEY }
	end
	local s = ui.professionsGuide
	if s.expanded101 == nil and type(s.expanded) == "table" and s.expanded["101"] ~= nil then
		s.expanded101 = s.expanded["101"] == true
	end
	if s.expanded101 == nil then
		s.expanded101 = true
	end
	if not s.selectedKey or s.selectedKey == "101" then
		s.selectedKey = DEFAULT_PROF_KEY
	end
	return s
end


local function IsIntroExpanded()
	return GetGuideSettings().expanded101 == true
end


local function SetIntroExpanded(value)
	GetGuideSettings().expanded101 = value == true
end


local function GetSelectedProfKey()
	return GetGuideSettings().selectedKey or DEFAULT_PROF_KEY
end


local function SetSelectedProfKey(key)
	if type(key) ~= "string" or key == "" or key == "101" then
		return
	end
	GetGuideSettings().selectedKey = key
end


local function GetSections()
	return ns.PROFESSIONS_GUIDE_SECTIONS
end


local function GetIntroCfg()
	local sections = GetSections()
	if type(sections) ~= "table" then
		return nil
	end
	for i = 1, #sections do
		local cfg = sections[i]
		if cfg and cfg.key == "101" then
			return cfg
		end
	end
	return nil
end


local function GetProfessionCfgs()
	local out = {}
	local sections = GetSections()
	if type(sections) ~= "table" then
		return out
	end
	for i = 1, #sections do
		local cfg = sections[i]
		if cfg and cfg.key and cfg.key ~= "101" then
			out[#out + 1] = cfg
		end
	end
	return out
end


local function FindSectionCfg(key)
	local sections = GetSections()
	if type(sections) ~= "table" or not key then
		return nil
	end
	for i = 1, #sections do
		local cfg = sections[i]
		if cfg and cfg.key == key then
			return cfg
		end
	end
	return nil
end

local function FindProfessionCfg(key)
	local cfg = FindSectionCfg(key)
	if cfg and cfg.key ~= "101" and cfg.key ~= "combo_te" then
		return cfg
	end
	local profs = GetProfessionCfgs()
	for i = 1, #profs do
		if profs[i].key == key then
			return profs[i]
		end
	end
	return profs[1]
end

local function SelectProfessionGuide(key)
	if type(key) ~= "string" or key == "" or key == "101" then
		return
	end
	SetSelectedProfKey(key)
	ns.RefreshProfessionsGuide()
	if ns.RefreshReferenceGuidePanel then
		ns.RefreshReferenceGuidePanel()
	end
end



--- WoW UI line breaks use |n; avoid Unicode arrows (missing glyph = square).
local function NormalizeGuideText(raw)
	if type(raw) ~= "string" then
		return ""
	end
	local s = raw:gsub("\\n", "|n"):gsub("\r\n", "|n"):gsub("\n", "|n")
	s = s:gsub("→", ": ")
	return s
end


local function EnsureUrlCopyFrame()
	if urlCopyFrame then
		return urlCopyFrame
	end
	local f = CreateFrame("Frame", "MidnightHelperProfGuideUrlCopy", UIParent, "BackdropTemplate")
	f:SetSize(400, 132)
	f:SetFrameStrata("DIALOG")
	f:SetFrameLevel(2000)
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end

	local titleBar, content = ns.EnsureMidnightDialogTitleBar(f)
	local titleFs = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleFs:SetPoint("CENTER", titleBar, "CENTER", -6, 0)
	titleFs:SetJustifyH("CENTER")
	titleFs:SetTextColor(1, 0.9, 0.55)
	f._title = titleFs

	local hintFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	hintFs:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 2, -8)
	hintFs:SetPoint("TOPRIGHT", titleBar, "BOTTOMRIGHT", -2, -8)
	hintFs:SetJustifyH("CENTER")
	hintFs:SetWordWrap(true)
	hintFs:SetTextColor(0.82, 0.8, 0.74)
	f._hint = hintFs

	local eb = CreateFrame("EditBox", nil, content)
	eb:SetAutoFocus(false)
	eb:SetMultiLine(false)
	eb:SetMaxLetters(512)
	eb:SetFontObject("GameFontHighlight")
	eb:SetTextInsets(8, 8, 6, 6)
	eb:SetHeight(28)
	eb:SetPoint("TOPLEFT", hintFs, "BOTTOMLEFT", 0, -10)
	eb:SetPoint("RIGHT", content, "RIGHT", -2, 0)
	eb:SetTextColor(0.92, 0.9, 0.85)
	if ns.StyleMidnightEditBoxHost then
		ns.StyleMidnightEditBoxHost(eb, content)
	end
	eb:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
		f:Hide()
	end)
	eb:SetScript("OnEditFocusGained", function(self)
		self:HighlightText(0, -1)
	end)
	eb:SetScript("OnMouseUp", function(self)
		if not self:HasFocus() then
			self:SetFocus()
		end
		self:HighlightText(0, -1)
	end)
	f._edit = eb

	local openBtn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	openBtn:SetSize(150, 24)
	openBtn:SetPoint("TOP", eb, "BOTTOM", 0, -12)
	openBtn:SetText(ns:L("PROFGUIDE_BTN_OPEN_BROWSER"))
	openBtn:SetScript("OnClick", function()
		local url = f._url
		if url and url ~= "" and OpenURL then
			OpenURL(url)
		end
	end)
	f._openBtn = openBtn

	ns.AttachMidnightDialogCloseButton(f, function()
		if f._edit then
			f._edit:ClearFocus()
		end
	end)

	f:Hide()
	urlCopyFrame = f
	return f
end

local function ShowUrlCopyPopup(url, anchor, label)
	if not url or url == "" then
		return
	end
	local f = EnsureUrlCopyFrame()
	f._url = url
	f._title:SetText(label or ns:L("PROFGUIDE_URL_POPUP_TITLE"))
	f._hint:SetText(ns:L("PROFGUIDE_URL_POPUP_HINT"))
	if f._openBtn then
		f._openBtn:SetShown(OpenURL ~= nil)
	end
	f:SetParent(UIParent)
	if ns.PositionMidnightPopupAboveCharacter then
		ns.PositionMidnightPopupAboveCharacter(f, 120)
	end
	f:Show()
	f:Raise()
	if f._mhCloseBtn then
		f._mhCloseBtn:Raise()
	end
	local eb = f._edit
	eb:SetText(url)
	eb:SetAutoFocus(true)
	eb:SetFocus()
	eb:HighlightText(0, -1)
	if C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			if eb and f:IsShown() then
				eb:SetFocus()
				eb:HighlightText(0, -1)
			end
		end)
	end
end

local function OpenExternalUrl(url, anchor, label)
	ShowUrlCopyPopup(url, anchor, label)
end


local function LayoutComboLinks(body, panelW)
	if not body or not body._comboLinks then
		return 0
	end
	local links = body._comboLinks
	local pw = math.max(260, panelW or 400)
	local gap = COMBO_LINK_GAP
	local btnW = math.floor((pw - gap) / 2)
	btnW = math.max(100, math.min(btnW, 220))
	local labelH = 14
	if links._label then
		labelH = links._label:GetStringHeight() or labelH
	end
	local rowH = COMBO_LINK_H
	local totalH = labelH + 4 + rowH + gap + rowH + 8
	links:SetHeight(totalH)
	if links._label then
		links._label:ClearAllPoints()
		links._label:SetPoint("TOPLEFT", links, "TOPLEFT", 4, -2)
		links._label:SetPoint("RIGHT", links, "RIGHT", -4, 0)
	end
	local profKeys = { "enchanting", "tailoring" }
	for i = 1, 2 do
		local btn = links._profBtns and links._profBtns[i]
		if btn then
			btn:SetSize(btnW, rowH)
			btn:ClearAllPoints()
			btn:SetPoint("TOPLEFT", links, "TOPLEFT", (i - 1) * (btnW + gap), -(labelH + 4))
		end
		local wbtn = links._wowBtns and links._wowBtns[i]
		if wbtn then
			wbtn:SetSize(btnW, rowH)
			wbtn:ClearAllPoints()
			wbtn:SetPoint("TOPLEFT", links, "TOPLEFT", (i - 1) * (btnW + gap), -(labelH + 4 + rowH + gap))
		end
	end
	return totalH
end

local function MeasureBody(body, panelW, showBtnRow, showComboLinks)
	local pw = math.max(260, panelW or 400)
	if body._text then
		body._text:SetWidth(pw - 12)
	end
	local h = BODY_PAD
	if showComboLinks and body._comboLinks and body._comboLinks:IsShown() then
		h = h + LayoutComboLinks(body, pw) + 4
	end
	if body._text and body._text:IsShown() then
		local textH = body._text:GetStringHeight() or 0
		h = h + textH + 8
		if body._btnRow then
			body._btnRow:ClearAllPoints()
			body._btnRow:SetPoint("TOPLEFT", body._text, "BOTTOMLEFT", -4, -8)
			body._btnRow:SetPoint("RIGHT", body, "RIGHT", 0, 0)
		end
	end
	if showBtnRow and body._btnRow and body._btnRow:IsShown() then
		h = h + (body._btnRow:GetHeight() or BTN_ROW_H) + BODY_PAD
	end
	return math.max(BODY_PAD * 2, h)
end


local function LayoutDetailButtons(btnRow, cfg, width)
	local w = math.max(200, width or 300)
	local hasWow = cfg.wowheadUrl and cfg.wowheadUrl ~= ""
	local hasSmc = cfg.smcPin and cfg.smcPin ~= ""
	local count = 1 + (hasWow and 1 or 0) + (hasSmc and 1 or 0)
	local gap = 4
	local btnW = math.floor((w - (count - 1) * gap) / count)
	btnW = math.max(72, math.min(btnW, 200))
	local x = 0
	if btnRow._btnProf then
		btnRow._btnProf:SetSize(btnW, 22)
		btnRow._btnProf:ClearAllPoints()
		btnRow._btnProf:SetPoint("TOPLEFT", btnRow, "TOPLEFT", x, 0)
		x = x + btnW + gap
	end
	if btnRow._btnSmc then
		btnRow._btnSmc:SetShown(hasSmc)
		if hasSmc then
			btnRow._btnSmc:SetSize(btnW, 22)
			btnRow._btnSmc:ClearAllPoints()
			btnRow._btnSmc:SetPoint("TOPLEFT", btnRow, "TOPLEFT", x, 0)
			x = x + btnW + gap
		end
	end
	if btnRow._btnWow then
		btnRow._btnWow:SetShown(hasWow)
		if hasWow then
			btnRow._btnWow:SetSize(btnW, 22)
			btnRow._btnWow:ClearAllPoints()
			btnRow._btnWow:SetPoint("TOPLEFT", btnRow, "TOPLEFT", x, 0)
		end
	end
	btnRow:SetHeight(24)
end


local function LayoutPickerButtons(panelW)
	if not pickerRow or not pickerRow._btnHost then
		return 0
	end
	local host = pickerRow._btnHost
	local profs = GetProfessionCfgs()
	local count = #profs
	if count == 0 then
		host:SetHeight(0)
		return 0
	end
	local pw = math.max(260, panelW or 400)
	local cols = (pw >= 520 and 5) or (pw >= 400 and 3) or 2
	local rows = math.ceil(count / cols)
	local gap = PICKER_GAP
	local btnW = math.floor((pw - (cols - 1) * gap) / cols)
	btnW = math.max(88, math.min(btnW, 160))
	local btnH = 22
	for i = 1, count do
		local btn = pickerButtons[profs[i].key]
		if btn then
			local col = (i - 1) % cols
			local row = math.floor((i - 1) / cols)
			btn:SetSize(btnW, btnH)
			btn:ClearAllPoints()
			btn:SetPoint("TOPLEFT", host, "TOPLEFT", col * (btnW + gap), -row * (btnH + gap))
			btn:SetAlpha(profs[i].key == GetSelectedProfKey() and 1 or 0.82)
		end
	end
	local gridH = rows * btnH + math.max(0, rows - 1) * gap
	host:SetHeight(gridH)
	local labelH = 14
	if pickerRow._label then
		labelH = pickerRow._label:GetStringHeight() or labelH
	end
	pickerRow:SetHeight(labelH + 4 + gridH)
	return pickerRow:GetHeight()
end


function RefreshIntroSection()
	if not introFrame then
		return
	end
	local cfg = GetIntroCfg()
	if not cfg then
		introFrame:Hide()
		return
	end
	introFrame:Show()
	local expanded = IsIntroExpanded()
	if introFrame._collapseBtn then
		introFrame._collapseBtn:SetText(expanded and "−" or "+")
	end
	if introFrame._title then
		introFrame._title:SetText(ns:L(cfg.titleKey))
	end
	if introFrame._body then
		introFrame._body:SetShown(expanded)
	end
	if expanded and introFrame._body then
		if introFrame._body._text then
			introFrame._body._text:SetText(NormalizeGuideText(ns:L(cfg.bodyKey)))
		end
		local pw = math.max(260, (hostPanel and hostPanel:GetWidth()) or 400)
		local bodyH = MeasureBody(introFrame._body, pw, false)
		introFrame._body:SetHeight(bodyH)
		introFrame:SetHeight(TITLE_H + bodyH)
	else
		introFrame:SetHeight(TITLE_H)
	end
end


function RefreshDetailSection()
	if not detailFrame then
		return
	end
	local cfg = FindProfessionCfg(GetSelectedProfKey())
	if not cfg then
		detailFrame:Hide()
		return
	end
	detailFrame:Show()
	detailFrame._cfg = cfg
	if detailFrame._title then
		detailFrame._title:SetText(ns:L(cfg.titleKey))
	end
	if detailFrame._body and detailFrame._body._text then
		-- Optioneel skill-leveling-routje onder de body (PROFGUIDE_LVL_*). Opzet
		-- per professie via cfg.levelingKey; valt per taal terug op Engels.
		local body = ns:L(cfg.bodyKey)
		if cfg.levelingKey then
			local lvl = ns:L(cfg.levelingKey)
			if type(lvl) == "string" and lvl ~= "" and lvl ~= cfg.levelingKey then
				body = body .. "|n|n" .. lvl
			end
		end
		detailFrame._body._text:SetText(NormalizeGuideText(body))
	end
	local pw = math.max(260, (hostPanel and hostPanel:GetWidth()) or 400)
	local isCombo = cfg.key == "combo_te"
	local showBtns = not isCombo
	local showComboLinks = isCombo
	if detailFrame._body then
		if detailFrame._body._comboLinks then
			if showComboLinks then
				local links = detailFrame._body._comboLinks
				if links._label then
					links._label:SetText(ns:L("PROFGUIDE_MORE_DETAIL"))
				end
				local comboProfKeys = { "enchanting", "tailoring" }
				for i = 1, 2 do
					local pkey = comboProfKeys[i]
					local pcfg = FindSectionCfg(pkey)
					local title = pcfg and ns:L(pcfg.titleKey) or pkey
					if links._profBtns and links._profBtns[i] then
						links._profBtns[i]:SetText(title)
					end
					if links._wowBtns and links._wowBtns[i] then
						links._wowBtns[i]:SetText(ns:L("PROFGUIDE_BTN_WOWHEAD_PROF_FMT"):format(title))
					end
				end
				detailFrame._body._comboLinks:Show()
				LayoutComboLinks(detailFrame._body, pw)
				detailFrame._body._text:ClearAllPoints()
				detailFrame._body._text:SetPoint("TOPLEFT", detailFrame._body._comboLinks, "BOTTOMLEFT", 4, -6)
				detailFrame._body._text:SetPoint("RIGHT", detailFrame._body, "RIGHT", -4, 0)
			else
				detailFrame._body._comboLinks:Hide()
				detailFrame._body._text:ClearAllPoints()
				detailFrame._body._text:SetPoint("TOPLEFT", detailFrame._body, "TOPLEFT", 4, -BODY_PAD)
				detailFrame._body._text:SetPoint("RIGHT", detailFrame._body, "RIGHT", -4, 0)
			end
		end
		if detailFrame._body._btnRow then
			if showBtns then
				detailFrame._body._btnRow:Show()
				LayoutDetailButtons(detailFrame._body._btnRow, cfg, pw)
			else
				detailFrame._body._btnRow:Hide()
			end
		end
		local bodyH = MeasureBody(detailFrame._body, pw, showBtns, showComboLinks)
		detailFrame._body:SetHeight(bodyH)
		detailFrame:SetHeight(TITLE_H + bodyH)
	end
end


function RelayoutPanel()
	if not hostPanel then
		return
	end
	local pw = math.max(260, hostPanel:GetWidth() or 400)
	local y = 0
	if introFrame and introFrame:IsShown() then
		introFrame:ClearAllPoints()
		introFrame:SetPoint("TOPLEFT", hostPanel, "TOPLEFT", 0, -y)
		introFrame:SetPoint("RIGHT", hostPanel, "RIGHT", 0, 0)
		y = y + (introFrame:GetHeight() or TITLE_H) + SECTION_GAP
	end
	if pickerRow and pickerRow:IsShown() then
		LayoutPickerButtons(pw)
		pickerRow:ClearAllPoints()
		pickerRow:SetPoint("TOPLEFT", hostPanel, "TOPLEFT", 0, -y)
		pickerRow:SetPoint("RIGHT", hostPanel, "RIGHT", 0, 0)
		y = y + (pickerRow:GetHeight() or 0) + SECTION_GAP
	end
	if detailFrame and detailFrame:IsShown() then
		detailFrame:ClearAllPoints()
		detailFrame:SetPoint("TOPLEFT", hostPanel, "TOPLEFT", 0, -y)
		detailFrame:SetPoint("RIGHT", hostPanel, "RIGHT", 0, 0)
		y = y + (detailFrame:GetHeight() or TITLE_H) + SECTION_GAP
	end
	hostPanel:SetHeight(math.max(1, y))
end


function ScheduleLayout()
	if layoutPending then
		return
	end
	if not C_Timer or not C_Timer.After then
		RelayoutPanel()
		if ns.SyncReferenceGuideScroll then
			ns.SyncReferenceGuideScroll()
		end
		return
	end
	layoutPending = true
	C_Timer.After(0.05, function()
		layoutPending = false
		RefreshIntroSection()
		RefreshDetailSection()
		RelayoutPanel()
		if ns.SyncReferenceGuideScroll then
			ns.SyncReferenceGuideScroll()
		end
	end)
end


function ns.RefreshProfessionsGuide()
	if not hostPanel then
		return
	end
	RefreshIntroSection()
	RefreshDetailSection()
	RelayoutPanel()
	ScheduleLayout()
end


local function CreateIntroSection(parent)
	local cfg = GetIntroCfg()
	if not cfg then
		return nil
	end


	local sf = CreateFrame("Frame", nil, parent)
	sf:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
	sf:SetPoint("RIGHT", parent, "RIGHT", 0, 0)


	local titleRow = CreateFrame("Frame", nil, sf)
	titleRow:SetHeight(TITLE_H)
	titleRow:SetPoint("TOPLEFT", sf, "TOPLEFT", 0, 0)
	titleRow:SetPoint("TOPRIGHT", sf, "TOPRIGHT", 0, 0)


	local collapseBtn = CreateFrame("Button", nil, titleRow)
	collapseBtn:SetSize(18, 18)
	collapseBtn:SetPoint("LEFT", titleRow, "LEFT", 0, 0)
	collapseBtn:SetNormalFontObject(GameFontNormal)
	collapseBtn:SetScript("OnClick", function()
		SetIntroExpanded(not IsIntroExpanded())
		ns.RefreshProfessionsGuide()
		if ns.RefreshReferenceGuidePanel then
			ns.RefreshReferenceGuidePanel()
		end
	end)
	sf._collapseBtn = collapseBtn


	local titleFs = titleRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleFs:SetPoint("LEFT", collapseBtn, "RIGHT", 2, 0)
	titleFs:SetPoint("RIGHT", titleRow, "RIGHT", -2, 0)
	titleFs:SetJustifyH("LEFT")
	titleFs:SetTextColor(0.92, 0.88, 0.75)
	sf._title = titleFs


	local body = CreateFrame("Frame", nil, sf)
	body:SetPoint("TOPLEFT", titleRow, "BOTTOMLEFT", 0, -2)
	body:SetPoint("TOPRIGHT", titleRow, "BOTTOMRIGHT", 0, -2)
	body:SetClipsChildren(true)
	sf._body = body


	local text = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	text:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	text:SetPoint("TOPLEFT", body, "TOPLEFT", 4, -BODY_PAD)
	text:SetPoint("RIGHT", body, "RIGHT", -4, 0)
	text:SetJustifyH("LEFT")
	text:SetWordWrap(true)
	text:SetTextColor(0.88, 0.86, 0.82)
	body._text = text


	sf:SetHeight(TITLE_H)
	return sf
end


local function CreatePickerRow(parent)
	local row = CreateFrame("Frame", nil, parent)
	row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
	row:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
	row:SetHeight(PICKER_ROW_H)


	local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	label:SetPoint("TOPLEFT", row, "TOPLEFT", 2, 0)
	label:SetPoint("RIGHT", row, "RIGHT", -2, 0)
	label:SetJustifyH("LEFT")
	label:SetTextColor(0.75, 0.72, 0.65)
	label:SetText(ns:L("PROFGUIDE_PICK_PROF"))
	row._label = label


	local btnHost = CreateFrame("Frame", nil, row)
	btnHost:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -4)
	btnHost:SetPoint("RIGHT", row, "RIGHT", 0, 0)
	row._btnHost = btnHost


	local profs = GetProfessionCfgs()
	for i = 1, #profs do
		local cfg = profs[i]
		local btn = CreateFrame("Button", nil, btnHost, "UIPanelButtonTemplate")
		btn:SetText(ns:L(cfg.titleKey))
		btn:SetScript("OnClick", function()
			SetSelectedProfKey(cfg.key)
			ns.RefreshProfessionsGuide()
			if ns.RefreshReferenceGuidePanel then
				ns.RefreshReferenceGuidePanel()
			end
		end)
		pickerButtons[cfg.key] = btn
	end


	return row
end


local function CreateDetailSection(parent)
	local sf = CreateFrame("Frame", nil, parent)
	sf:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
	sf:SetPoint("RIGHT", parent, "RIGHT", 0, 0)


	local titleRow = CreateFrame("Frame", nil, sf)
	titleRow:SetHeight(TITLE_H)
	titleRow:SetPoint("TOPLEFT", sf, "TOPLEFT", 0, 0)
	titleRow:SetPoint("TOPRIGHT", sf, "TOPRIGHT", 0, 0)


	local titleFs = titleRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleFs:SetPoint("LEFT", titleRow, "LEFT", 4, 0)
	titleFs:SetPoint("RIGHT", titleRow, "RIGHT", -2, 0)
	titleFs:SetJustifyH("LEFT")
	titleFs:SetTextColor(0.92, 0.88, 0.75)
	sf._title = titleFs


	local body = CreateFrame("Frame", nil, sf)
	body:SetPoint("TOPLEFT", titleRow, "BOTTOMLEFT", 0, -2)
	body:SetPoint("TOPRIGHT", titleRow, "BOTTOMRIGHT", 0, -2)
	body:SetClipsChildren(true)
	sf._body = body

	local comboLinks = CreateFrame("Frame", nil, body)
	comboLinks:SetPoint("TOPLEFT", body, "TOPLEFT", 0, 0)
	comboLinks:SetPoint("RIGHT", body, "RIGHT", 0, 0)
	comboLinks:Hide()
	body._comboLinks = comboLinks

	local comboLabel = comboLinks:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	comboLabel:SetJustifyH("LEFT")
	comboLabel:SetTextColor(0.92, 0.88, 0.55)
	comboLabel:SetText(ns:L("PROFGUIDE_MORE_DETAIL"))
	comboLinks._label = comboLabel

	comboLinks._profBtns = {}
	comboLinks._wowBtns = {}
	local comboProfKeys = { "enchanting", "tailoring" }
	for i = 1, 2 do
		local pkey = comboProfKeys[i]
		local pcfg = FindSectionCfg(pkey)
		local profBtn = CreateFrame("Button", nil, comboLinks, "UIPanelButtonTemplate")
		profBtn:SetText(pcfg and ns:L(pcfg.titleKey) or pkey)
		profBtn:SetScript("OnClick", function()
			SelectProfessionGuide(pkey)
		end)
		comboLinks._profBtns[i] = profBtn

		local wowBtn = CreateFrame("Button", nil, comboLinks, "UIPanelButtonTemplate")
		local title = pcfg and ns:L(pcfg.titleKey) or pkey
		wowBtn:SetText(ns:L("PROFGUIDE_BTN_WOWHEAD_PROF_FMT"):format(title))
		wowBtn:SetScript("OnClick", function()
			local c = FindSectionCfg(pkey)
			if c and c.wowheadUrl then
				OpenExternalUrl(c.wowheadUrl, wowBtn, ns:L("PROFGUIDE_BTN_WOWHEAD_PROF_FMT"):format(title))
			end
		end)
		comboLinks._wowBtns[i] = wowBtn
	end

	local text = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	text:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	text:SetPoint("TOPLEFT", body, "TOPLEFT", 4, -BODY_PAD)
	text:SetPoint("RIGHT", body, "RIGHT", -4, 0)
	text:SetJustifyH("LEFT")
	text:SetWordWrap(true)
	text:SetTextColor(0.88, 0.86, 0.82)
	body._text = text


	local btnRow = CreateFrame("Frame", nil, body)
	btnRow:SetPoint("TOPLEFT", text, "BOTTOMLEFT", -4, -8)
	btnRow:SetPoint("RIGHT", body, "RIGHT", 0, 0)
	btnRow:SetHeight(BTN_ROW_H)
	body._btnRow = btnRow


	local btnProf = CreateFrame("Button", nil, btnRow, "UIPanelButtonTemplate")
	btnProf:SetText(ns:L("PROFGUIDE_BTN_PROFESSIONS_TAB"))
	btnProf:SetScript("OnClick", function()
		if ns.EnsureMainUI then
			ns:EnsureMainUI()
		end
		if ns.SelectTab then
			ns.SelectTab("professions")
		end
		if ns.mainUI and ns.mainUI.Show then
			ns.mainUI:Show()
		end
	end)
	btnRow._btnProf = btnProf


	local btnSmc = CreateFrame("Button", nil, btnRow, "UIPanelButtonTemplate")
	btnSmc:SetText(ns:L("PROFGUIDE_BTN_SMC"))
	btnSmc:SetScript("OnClick", function()
		local cfg = sf._cfg
		if cfg and cfg.smcPin and ns.SetSMCCityWaypoint then
			ns.SetSMCCityWaypoint(cfg.smcPin)
		end
		if ns.EnsureMainUI and ns.SelectTab then
			ns:EnsureMainUI()
			ns.SelectTab("smcguide")
			if ns.mainUI and ns.mainUI.Show then
				ns.mainUI:Show()
			end
		end
	end)
	btnRow._btnSmc = btnSmc


	local btnWow = CreateFrame("Button", nil, btnRow, "UIPanelButtonTemplate")
	btnWow:SetText(ns:L("PROFGUIDE_BTN_WOWHEAD"))
	btnWow:SetScript("OnClick", function()
		local cfg = sf._cfg
		if cfg and cfg.wowheadUrl then
			OpenExternalUrl(cfg.wowheadUrl, btnWow, ns:L("PROFGUIDE_BTN_WOWHEAD"))
		end
	end)
	btnRow._btnWow = btnWow


	sf:SetHeight(TITLE_H)
	return sf
end


function ns.EnsureProfessionsGuidePanel(parent)
	if not parent then
		return nil
	end
	if hostPanel then
		if hostPanel:GetParent() ~= parent then
			hostPanel:SetParent(parent)
			hostPanel:ClearAllPoints()
		end
		ns.RefreshProfessionsGuide()
		return hostPanel
	end


	local panel = CreateFrame("Frame", nil, parent)
	panel:SetClipsChildren(true)


	introFrame = CreateIntroSection(panel)
	pickerRow = CreatePickerRow(panel)
	detailFrame = CreateDetailSection(panel)


	panel:SetScript("OnSizeChanged", function()
		ns.RefreshProfessionsGuide()
	end)


	hostPanel = panel
	ns.ProfessionsGuidePanel = panel
	ns.RefreshProfessionsGuide()
	return panel
end


if not ns._mhProfGuideLocaleHooked then
	ns._mhProfGuideLocaleHooked = true
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ns.RefreshProfessionsGuide then
			ns.RefreshProfessionsGuide()
		end
	end
end

