local addonName, ns = ...

--- @return body string|nil, reason string|nil, classToken string|nil, specIndex number, specName string|nil
function ns.MH_GetInterruptMacroContext()
	local classLocalized, classFile = UnitClass("player")
	if not classFile then
		return nil, "noclass", nil, 0, nil
	end
	local token = string.upper(classFile)
	local specIdx = (GetSpecialization and GetSpecialization()) or 0
	local specName
	if specIdx > 0 and GetSpecializationInfo then
		local ok, _, name = pcall(GetSpecializationInfo, specIdx)
		if ok and name and name ~= "" then
			specName = name
		end
	end
	local t = ns.InterruptMacrosByClassSpec and ns.InterruptMacrosByClassSpec[token]
	if not t then
		return nil, "noclassdata", token, specIdx, specName
	end
	if specIdx < 1 then
		return nil, "nospec", token, specIdx, specName
	end
	local body = t[specIdx]
	if body == nil then
		return nil, "nospecdata", token, specIdx, specName
	end
	body = tostring(body)
	if body == "" then
		return nil, "empty", token, specIdx, specName
	end
	return body, nil, token, specIdx, specName
end

local function RefreshMacrosPanel(panel)
	if not panel or not panel._mhMacrosEdit then
		return
	end
	local body, reason, _token, _specIdx, specName = ns.MH_GetInterruptMacroContext()
	local classLocalized = select(1, UnitClass("player"))
	local eb = panel._mhMacrosEdit
	local specLine = panel._mhMacrosSpecLine
	local hint = panel._mhMacrosHint

	if panel._header and panel._header.SetText then
		panel._header:SetText(ns:L("TAB_MACROS"))
	end
	if panel._mhMacrosCopyBtn and panel._mhMacrosCopyBtn.SetText then
		panel._mhMacrosCopyBtn:SetText(ns:L("MACROS_COPY_BUTTON"))
	end

	if panel._mhMacrosSubtitle and panel._mhMacrosSubtitle.SetText then
		panel._mhMacrosSubtitle:SetText(ns:L("MACROS_PANEL_SUBTITLE"))
	end

	if specLine then
		if classLocalized and specName and specName ~= "" then
			specLine:SetText(ns:L("MACROS_SPEC_LINE_FMT"):format(classLocalized, specName))
			specLine:Show()
		elseif classLocalized then
			specLine:SetText(classLocalized)
			specLine:Show()
		else
			specLine:Hide()
		end
	end

	if body then
		eb:SetText(body)
		eb:SetTextColor(0.92, 0.90, 0.82)
		if hint then
			hint:SetText(ns:L("MACROS_COPY_HINT"))
			hint:Show()
		end
		if panel._mhMacrosCopyBtn and panel._mhMacrosCopyBtn.Enable then
			panel._mhMacrosCopyBtn:Enable()
		end
	else
		eb:SetText("")
		local msgKey = "MACROS_ERR_GENERIC"
		if reason == "nospec" then
			msgKey = "MACROS_ERR_NO_SPEC"
		elseif reason == "empty" then
			msgKey = "MACROS_ERR_EMPTY_SPEC"
		elseif reason == "noclassdata" or reason == "nospecdata" then
			msgKey = "MACROS_ERR_NO_DATA"
		end
		eb:SetText(ns:L(msgKey))
		eb:SetTextColor(0.75, 0.72, 0.65)
		if hint then
			hint:Hide()
		end
		if panel._mhMacrosCopyBtn and panel._mhMacrosCopyBtn.Disable then
			panel._mhMacrosCopyBtn:Disable()
		end
	end

	if eb.GetNumLines and eb.SetHeight and panel._mhMacrosScroll then
		local sw = panel._mhMacrosScroll:GetWidth() or 600
		-- UIPanelScrollFrameTemplate: leave room for vertical scrollbar + padding.
		local w = math.max(160, sw - 36)
		eb:SetWidth(w)
		local n = eb:GetNumLines() or 1
		local _, fontH = eb:GetFont()
		fontH = fontH or 12
		eb:SetHeight(math.max(120, n * (fontH + 2) + 16))
	end
	if panel._mhMacrosScroll and panel._mhMacrosScroll.UpdateScrollChildRect then
		panel._mhMacrosScroll:UpdateScrollChildRect()
	end
	if panel._mhMacrosScroll and panel._mhMacrosScroll.SetVerticalScroll then
		panel._mhMacrosScroll:SetVerticalScroll(0)
	end
end

function ns.BuildInterruptMacrosPanel(panel)
	if not panel or panel._mhMacrosBuilt then
		return
	end
	panel._mhMacrosBuilt = true
	if panel._body then
		panel._body:Hide()
	end

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", panel._header, "BOTTOMLEFT", 0, -6)
	subtitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -6)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetText(ns:L("MACROS_PANEL_SUBTITLE"))
	subtitle:SetTextColor(0.78, 0.74, 0.68)
	panel._mhMacrosSubtitle = subtitle

	local specLine = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	specLine:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	specLine:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -8)
	specLine:SetJustifyH("LEFT")
	specLine:SetTextColor(1, 0.88, 0.55)
	panel._mhMacrosSpecLine = specLine

	local copyBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	copyBtn:SetSize(120, 24)
	copyBtn:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 12, 14)
	copyBtn:SetText(ns:L("MACROS_COPY_BUTTON"))
	copyBtn:SetScript("OnClick", function()
		local eb = panel._mhMacrosEdit
		if not eb or not eb.GetText then
			return
		end
		local macroBody = ns.MH_GetInterruptMacroContext()
		if not macroBody then
			return
		end
		eb:SetFocus(true)
		local t = eb:GetText() or ""
		eb:HighlightText(0, string.len(t))
	end)
	panel._mhMacrosCopyBtn = copyBtn

	local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hint:SetPoint("LEFT", copyBtn, "RIGHT", 10, 0)
	hint:SetPoint("RIGHT", panel, "RIGHT", -12, 14)
	hint:SetJustifyH("LEFT")
	hint:SetText(ns:L("MACROS_COPY_HINT"))
	hint:SetTextColor(0.55, 0.53, 0.48)
	panel._mhMacrosHint = hint

	local scrollBottomPad = 46

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperMacrosScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", specLine, "BOTTOMLEFT", 0, -10)
	scroll:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 12, scrollBottomPad)
	-- Full content width minus small edge inset (scrollbar sits inside the template).
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -12, scrollBottomPad)

	local eb = CreateFrame("EditBox", "MidnightHelperMacrosEdit", scroll)
	eb:SetMultiLine(true)
	eb:SetFontObject("GameFontHighlightSmall")
	eb:SetAutoFocus(false)
	eb:EnableMouse(true)
	eb:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	eb:SetTextInsets(8, 8, 8, 8)
	local bg = eb:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", eb, "TOPLEFT", -2, 2)
	bg:SetPoint("BOTTOMRIGHT", eb, "BOTTOMRIGHT", 2, -2)
	bg:SetColorTexture(0.06, 0.06, 0.08, 0.92)
	eb:SetTextColor(0.92, 0.90, 0.82)
	scroll:SetScrollChild(eb)
	panel._mhMacrosScroll = scroll
	panel._mhMacrosEdit = eb

	panel._mhRefreshMacros = function()
		RefreshMacrosPanel(panel)
	end

	panel:SetScript("OnShow", function()
		if panel._mhRefreshMacros then
			panel._mhRefreshMacros()
		end
	end)

	local ev = CreateFrame("Frame", nil, panel)
	ev:SetFrameStrata("LOW")
	ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	ev:RegisterEvent("PLAYER_ENTERING_WORLD")
	ev:SetScript("OnEvent", function()
		if panel:IsShown() and panel._mhRefreshMacros then
			panel._mhRefreshMacros()
		end
	end)

	panel:HookScript("OnSizeChanged", function()
		if panel:IsShown() and panel._mhRefreshMacros then
			panel._mhRefreshMacros()
		end
	end)
end
