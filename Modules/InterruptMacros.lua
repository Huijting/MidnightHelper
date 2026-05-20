local addonName, ns = ...

local TAB_TEX_ACTIVE = { 0.98, 0.94, 0.82 }
local TAB_TEX_INACTIVE = { 0.78, 0.72, 0.62 }
local SEP_COLOR = { 0.78, 0.62, 0.32, 0.55 }

local TYPE_BTN_W = 96
local TYPE_BTN_H = 24
local TYPE_NAV_H = 34
local PICK_NAV_H = 30
local PICK_BTN_H = 22
local PICK_BTN_PAD = 6
local SCROLL_BOTTOM_PAD = 46

ns.MacroPanelTypes = {
	{
		id = "interrupt",
		labelKey = "MACROS_TYPE_INTERRUPT",
		subtitleKey = "MACROS_INTERRUPT_SUBTITLE",
		getContext = function(panel)
			return ns.MH_GetInterruptMacroContext()
		end,
	},
	{
		id = "utility",
		labelKey = "MACROS_TYPE_UTILITY",
		getContext = function(panel)
			return ns.MH_GetUtilityMacroContext(panel)
		end,
	},
}

local function TintButtonTextures(btn, r, g, b)
	if not btn or not btn.GetRegions then
		return
	end
	for _, region in ipairs({ btn:GetRegions() }) do
		if region.GetObjectType and region:IsObjectType("Texture") and region.SetVertexColor then
			region:SetVertexColor(r, g, b)
		end
	end
end

local function IsNlLocale()
	local code = (ns.db and ns.db.locale) or "enUS"
	return code == "nlNL" or code == "nl"
end

local function GetEntryDescription(entry)
	if not entry then
		return ""
	end
	if IsNlLocale() then
		return entry.descNl or entry.descEn or ""
	end
	return entry.descEn or entry.descNl or ""
end

local function GetMacroTypeDef(typeId)
	for i = 1, #(ns.MacroPanelTypes or {}) do
		local def = ns.MacroPanelTypes[i]
		if def and def.id == typeId then
			return def
		end
	end
	return nil
end

local function RefreshMacroTypeChrome(panel)
	local active = panel._mhMacrosSelectedType or "interrupt"
	local buttons = panel._mhMacrosTypeButtons
	if not buttons then
		return
	end
	for id, btn in pairs(buttons) do
		if id == active then
			btn:SetAlpha(1)
			TintButtonTextures(btn, TAB_TEX_ACTIVE[1], TAB_TEX_ACTIVE[2], TAB_TEX_ACTIVE[3])
		else
			btn:SetAlpha(0.88)
			TintButtonTextures(btn, TAB_TEX_INACTIVE[1], TAB_TEX_INACTIVE[2], TAB_TEX_INACTIVE[3])
		end
	end
end

local function RefreshUtilityPickChrome(panel)
	local active = panel._mhMacrosUtilityIndex or 1
	local buttons = panel._mhMacrosPickButtons
	if not buttons then
		return
	end
	for idx, btn in pairs(buttons) do
		if idx == active then
			btn:SetAlpha(1)
			TintButtonTextures(btn, TAB_TEX_ACTIVE[1], TAB_TEX_ACTIVE[2], TAB_TEX_ACTIVE[3])
		else
			btn:SetAlpha(0.88)
			TintButtonTextures(btn, TAB_TEX_INACTIVE[1], TAB_TEX_INACTIVE[2], TAB_TEX_INACTIVE[3])
		end
	end
end

function ns.MH_GetUtilityMacroList()
	local token, specIdx = ns.MH_GetMacroClassSpecContext()
	if not token then
		return nil
	end
	if specIdx < 1 then
		return nil, token, specIdx
	end
	local t = ns.TeamMacrosByClassSpec and ns.TeamMacrosByClassSpec[token]
	local list = t and t[specIdx]
	if not list or #list < 1 then
		return nil, token, specIdx
	end
	return list, token, specIdx
end

--- body, reason, token, specIdx, specName, entryName, entryDesc
function ns.MH_GetUtilityMacroContext(panel)
	local list, token, specIdx = ns.MH_GetUtilityMacroList()
	local _t, _s, _p, _c, specName = ns.MH_GetMacroClassSpecContext()
	if not list then
		if not token then
			return nil, "noclass", nil, 0, nil, nil, nil
		end
		if specIdx < 1 then
			return nil, "nospec", token, specIdx, specName, nil, nil
		end
		return nil, "noutility", token, specIdx, specName, nil, nil
	end
	local idx = (panel and panel._mhMacrosUtilityIndex) or 1
	if idx < 1 or idx > #list then
		idx = 1
	end
	local entry = list[idx]
	if not entry or not entry.macro or entry.macro == "" then
		return nil, "empty", token, specIdx, specName, nil, nil
	end
	return entry.macro, nil, token, specIdx, specName, entry.name, GetEntryDescription(entry)
end

function ns.MH_GetMacroContextForType(typeId, panel)
	local def = GetMacroTypeDef(typeId)
	if not def or not def.getContext then
		return nil, "notype", nil, 0, nil, nil, nil
	end
	return def.getContext(panel)
end

function ns.MH_GetInterruptMacroContext()
	local token, specIdx, _preview, _classLocalized, specName = ns.MH_GetMacroClassSpecContext()
	if not token then
		return nil, "noclass", nil, 0, nil
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

--- Interrupt + all utility macros for current class/spec (paste into macro editor).
function ns.MH_BuildTeamMacroPack(panel)
	local lines = {}
	local intBody = ns.MH_GetInterruptMacroContext()
	if intBody and intBody ~= "" then
		lines[#lines + 1] = "# " .. ns:L("MACROS_PACK_INTERRUPT_HEADER")
		lines[#lines + 1] = intBody
	end
	local list = ns.MH_GetUtilityMacroList()
	if list then
		if #lines > 0 then
			lines[#lines + 1] = ""
		end
		lines[#lines + 1] = "# " .. ns:L("MACROS_PACK_UTILITY_HEADER")
		for i = 1, #list do
			local entry = list[i]
			if entry and entry.macro and entry.macro ~= "" then
				lines[#lines + 1] = "# " .. tostring(entry.name or ("Macro " .. i))
				lines[#lines + 1] = entry.macro
				lines[#lines + 1] = ""
			end
		end
	end
	if #lines == 0 then
		return nil
	end
	while lines[#lines] == "" do
		lines[#lines] = nil
	end
	return table.concat(lines, "\n")
end

local function MaybeResetUtilityIndexForSpec(panel)
	local token, specIdx = ns.MH_GetMacroClassSpecContext()
	local key = (token or "") .. ":" .. tostring(specIdx or 0)
	if panel._mhMacrosSpecKey ~= key then
		panel._mhMacrosSpecKey = key
		panel._mhMacrosUtilityIndex = 1
	end
end

local function RebuildUtilityPickNav(panel)
	local pickScroll = panel._mhMacrosPickScroll
	local pickChild = panel._mhMacrosPickChild
	if not pickScroll or not pickChild then
		return
	end
	MaybeResetUtilityIndexForSpec(panel)
	if panel._mhMacrosPickButtons then
		for _, btn in pairs(panel._mhMacrosPickButtons) do
			if btn and btn.Hide then
				btn:Hide()
			end
		end
	end
	panel._mhMacrosPickButtons = {}

	local list = ns.MH_GetUtilityMacroList()
	if not list or #list < 1 then
		pickScroll:Hide()
		panel._mhMacrosUtilityIndex = 1
		return
	end

	if (panel._mhMacrosUtilityIndex or 1) > #list then
		panel._mhMacrosUtilityIndex = 1
	end

	pickScroll:Show()
	local x = 0
	for i = 1, #list do
		local entry = list[i]
		local btn = panel._mhMacrosPickButtons[i]
		if not btn then
			btn = CreateFrame("Button", "MidnightHelperMacroPick_" .. i, pickChild, "UIPanelButtonTemplate")
			panel._mhMacrosPickButtons[i] = btn
			btn:SetHeight(PICK_BTN_H)
			btn:SetScript("OnClick", function()
				panel._mhMacrosUtilityIndex = i
				RefreshUtilityPickChrome(panel)
				if panel._mhRefreshMacros then
					panel._mhRefreshMacros()
				end
			end)
		end
		local label = entry.name or ("Macro " .. i)
		btn:SetText(label)
		local fs = btn.GetFontString and btn:GetFontString()
		local tw = (fs and fs.GetStringWidth and fs:GetStringWidth()) or 60
		local w = math.max(72, tw + 24)
		btn:SetWidth(w)
		btn:ClearAllPoints()
		btn:SetPoint("TOPLEFT", pickChild, "TOPLEFT", x, 0)
		btn:Show()
		x = x + w + PICK_BTN_PAD
	end
	pickChild:SetSize(math.max(1, x), PICK_BTN_H + 4)
	if pickScroll.UpdateScrollChildRect then
		pickScroll:UpdateScrollChildRect()
	end
	if pickScroll.SetHorizontalScroll then
		pickScroll:SetHorizontalScroll(0)
	end
	RefreshUtilityPickChrome(panel)
end

local function SelectMacroType(panel, typeId)
	if not panel or not typeId then
		return
	end
	if not GetMacroTypeDef(typeId) then
		typeId = (ns.MacroPanelTypes[1] and ns.MacroPanelTypes[1].id) or "interrupt"
	end
	panel._mhMacrosSelectedType = typeId
	if typeId == "utility" then
		RebuildUtilityPickNav(panel)
	else
		if panel._mhMacrosPickScroll then
			panel._mhMacrosPickScroll:Hide()
		end
		if panel._mhMacrosMacroName then
			panel._mhMacrosMacroName:Hide()
		end
	end
	RefreshMacroTypeChrome(panel)
	if panel._mhRefreshMacros then
		panel._mhRefreshMacros()
	end
end

local function LayoutSubtitleAnchor(panel, typeId)
	local subtitle = panel._mhMacrosSubtitle
	if not subtitle then
		return
	end
	subtitle:ClearAllPoints()
	subtitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -8)
	if typeId == "utility" and panel._mhMacrosPickScroll and panel._mhMacrosPickScroll:IsShown() then
		if panel._mhMacrosMacroName and panel._mhMacrosMacroName:IsShown() then
			subtitle:SetPoint("TOPLEFT", panel._mhMacrosMacroName, "BOTTOMLEFT", 0, -6)
		else
			subtitle:SetPoint("TOPLEFT", panel._mhMacrosPickScroll, "BOTTOMLEFT", 0, -6)
		end
	else
		subtitle:SetPoint("TOPLEFT", panel._mhMacrosSep, "BOTTOMLEFT", 0, -8)
	end
end

local function RefreshMacrosPanel(panel)
	if not panel or not panel._mhMacrosEdit then
		return
	end
	ns._mhMacrosActivePanel = panel
	local typeId = panel._mhMacrosSelectedType or "interrupt"
	local def = GetMacroTypeDef(typeId)
	local body, reason, _token, _specIdx, specName, entryName, entryDesc =
		ns.MH_GetMacroContextForType(typeId, panel)
	local _tokenCtx, _specCtx, isPreview, classLocalized, specNameCtx = ns.MH_GetMacroClassSpecContext()
	if specNameCtx and specNameCtx ~= "" then
		specName = specNameCtx
	end
	local eb = panel._mhMacrosEdit
	local specLine = panel._mhMacrosSpecLine
	local hint = panel._mhMacrosHint
	local subtitle = panel._mhMacrosSubtitle
	local macroName = panel._mhMacrosMacroName

	if panel._header and panel._header.SetText then
		panel._header:SetText(ns:L("TAB_MACROS"))
	end
	if panel._mhMacrosCopyBtn and panel._mhMacrosCopyBtn.SetText then
		panel._mhMacrosCopyBtn:SetText(ns:L("MACROS_COPY_BUTTON"))
	end
	if panel._mhMacrosPackBtn and panel._mhMacrosPackBtn.SetText then
		panel._mhMacrosPackBtn:SetText(ns:L("MACROS_PACK_COPY_BUTTON"))
	end

	local typeButtons = panel._mhMacrosTypeButtons
	if typeButtons then
		for id, btn in pairs(typeButtons) do
			local tdef = GetMacroTypeDef(id)
			if tdef and tdef.labelKey and btn.SetText then
				btn:SetText(ns:L(tdef.labelKey))
			end
		end
	end
	RefreshMacroTypeChrome(panel)

	if typeId == "utility" then
		RebuildUtilityPickNav(panel)
		if macroName then
			if entryName and entryName ~= "" then
				macroName:SetText(ns:L("MACROS_MACRO_NAME_FMT"):format(entryName))
				macroName:Show()
			else
				macroName:Hide()
			end
		end
	else
		if macroName then
			macroName:Hide()
		end
	end
	LayoutSubtitleAnchor(panel, typeId)

	if subtitle then
		if typeId == "utility" then
			if entryDesc and entryDesc ~= "" then
				subtitle:SetText(entryDesc .. "\n\n" .. ns:L("MACROS_COPY_SUFFIX"))
			elseif reason == "noutility" then
				subtitle:SetText(ns:L("MACROS_ERR_NO_UTILITY"))
			else
				subtitle:SetText(ns:L("MACROS_UTILITY_SUBTITLE"))
			end
		elseif def and def.subtitleKey then
			subtitle:SetText(ns:L(def.subtitleKey))
		end
	end

	if specLine then
		local previewMark = isPreview and ns:L("GUIDE_PREVIEW_MARK") or ""
		if classLocalized and specName and specName ~= "" then
			specLine:SetText(ns:L("MACROS_SPEC_LINE_FMT"):format(classLocalized, specName) .. previewMark)
			specLine:Show()
		elseif classLocalized then
			specLine:SetText(classLocalized .. previewMark)
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
		if panel._mhMacrosPackBtn and panel._mhMacrosPackBtn.Enable then
			panel._mhMacrosPackBtn:Enable()
		end
	else
		eb:SetText("")
		local msgKey = "MACROS_ERR_GENERIC"
		if reason == "nospec" then
			msgKey = "MACROS_ERR_NO_SPEC"
		elseif reason == "empty" then
			msgKey = "MACROS_ERR_EMPTY_SPEC"
		elseif reason == "noutility" then
			msgKey = "MACROS_ERR_NO_UTILITY"
		elseif reason == "noclassdata" or reason == "nospecdata" then
			msgKey = "MACROS_ERR_NO_DATA"
		elseif reason == "notype" then
			msgKey = "MACROS_ERR_NO_TYPE"
		end
		eb:SetText(ns:L(msgKey))
		eb:SetTextColor(0.75, 0.72, 0.65)
		if hint then
			hint:Hide()
		end
		if panel._mhMacrosCopyBtn and panel._mhMacrosCopyBtn.Disable then
			panel._mhMacrosCopyBtn:Disable()
		end
		if panel._mhMacrosPackBtn and panel._mhMacrosPackBtn.Disable then
			panel._mhMacrosPackBtn:Disable()
		end
	end

	if eb.SetHeight and panel._mhMacrosScroll then
		local sw = panel._mhMacrosScroll:GetWidth() or 600
		local w = math.max(160, sw - 36)
		eb:SetWidth(w)
		local n = 1
		if eb.GetNumLines then
			n = eb:GetNumLines() or 1
		else
			local text = eb.GetText and eb:GetText() or ""
			for _ in string.gmatch(text, "\n") do
				n = n + 1
			end
		end
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
	panel._mhMacrosSelectedType = "interrupt"
	panel._mhMacrosUtilityIndex = 1
	if panel._body then
		panel._body:Hide()
	end

	local typeNav = CreateFrame("Frame", nil, panel)
	typeNav:SetHeight(TYPE_NAV_H)
	typeNav:SetPoint("TOPLEFT", panel._header, "BOTTOMLEFT", 0, -4)
	typeNav:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -4)
	panel._mhMacrosTypeNav = typeNav

	panel._mhMacrosTypeButtons = {}
	local navX = 0
	for i = 1, #(ns.MacroPanelTypes or {}) do
		local mdef = ns.MacroPanelTypes[i]
		if mdef and mdef.id and mdef.labelKey then
			local btn = CreateFrame("Button", "MidnightHelperMacroType_" .. mdef.id, typeNav, "UIPanelButtonTemplate")
			btn:SetSize(TYPE_BTN_W, TYPE_BTN_H)
			btn:SetPoint("TOPLEFT", typeNav, "TOPLEFT", navX, -4)
			btn:SetText(ns:L(mdef.labelKey))
			btn:SetScript("OnClick", function()
				SelectMacroType(panel, mdef.id)
			end)
			panel._mhMacrosTypeButtons[mdef.id] = btn
			navX = navX + TYPE_BTN_W + 6
		end
	end

	local sep = panel:CreateTexture(nil, "ARTWORK")
	sep:SetHeight(1)
	sep:SetPoint("TOPLEFT", typeNav, "BOTTOMLEFT", 0, -2)
	sep:SetPoint("TOPRIGHT", typeNav, "BOTTOMRIGHT", 0, -2)
	sep:SetColorTexture(SEP_COLOR[1], SEP_COLOR[2], SEP_COLOR[3], SEP_COLOR[4])
	panel._mhMacrosSep = sep

	local pickScroll = CreateFrame("ScrollFrame", "MidnightHelperMacrosPickScroll", panel, "UIPanelScrollFrameTemplate")
	pickScroll:SetHeight(PICK_NAV_H)
	pickScroll:SetPoint("TOPLEFT", sep, "BOTTOMLEFT", 0, -6)
	pickScroll:SetPoint("TOPRIGHT", sep, "BOTTOMRIGHT", 0, -6)
	pickScroll:Hide()
	panel._mhMacrosPickScroll = pickScroll

	local pickChild = CreateFrame("Frame", nil, pickScroll)
	pickChild:SetSize(1, PICK_BTN_H + 4)
	pickScroll:SetScrollChild(pickChild)
	panel._mhMacrosPickChild = pickChild
	panel._mhMacrosPickButtons = {}

	local macroName = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	macroName:SetPoint("TOPLEFT", pickScroll, "BOTTOMLEFT", 0, -4)
	macroName:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -4)
	macroName:SetJustifyH("LEFT")
	macroName:SetTextColor(1, 0.88, 0.42)
	macroName:Hide()
	panel._mhMacrosMacroName = macroName

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", sep, "BOTTOMLEFT", 0, -8)
	subtitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -8)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetSpacing(2)
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
		local macroBody = ns.MH_GetMacroContextForType(panel._mhMacrosSelectedType or "interrupt", panel)
		if not macroBody then
			return
		end
		eb:SetFocus(true)
		local t = eb:GetText() or ""
		eb:HighlightText(0, string.len(t))
	end)
	panel._mhMacrosCopyBtn = copyBtn

	local packBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	packBtn:SetSize(132, 24)
	packBtn:SetPoint("LEFT", copyBtn, "RIGHT", 8, 0)
	packBtn:SetText(ns:L("MACROS_PACK_COPY_BUTTON"))
	packBtn:SetScript("OnClick", function()
		local eb = panel._mhMacrosEdit
		if not eb or not eb.SetText or not eb.SetFocus then
			return
		end
		local pack = ns.MH_BuildTeamMacroPack(panel)
		if not pack or pack == "" then
			return
		end
		eb:SetText(pack)
		eb:SetTextColor(0.92, 0.90, 0.82)
		eb:SetFocus(true)
		local t = eb:GetText() or ""
		eb:HighlightText(0, string.len(t))
		if panel._mhMacrosHint and panel._mhMacrosHint.SetText then
			panel._mhMacrosHint:SetText(ns:L("MACROS_PACK_COPY_HINT"))
		end
	end)
	panel._mhMacrosPackBtn = packBtn

	local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hint:SetPoint("LEFT", packBtn, "RIGHT", 10, 0)
	hint:SetPoint("RIGHT", panel, "RIGHT", -12, 14)
	hint:SetJustifyH("LEFT")
	hint:SetText(ns:L("MACROS_COPY_HINT"))
	hint:SetTextColor(0.55, 0.53, 0.48)
	panel._mhMacrosHint = hint

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperMacrosScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", specLine, "BOTTOMLEFT", 0, -10)
	scroll:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 12, SCROLL_BOTTOM_PAD)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -12, SCROLL_BOTTOM_PAD)

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
		ns._mhMacrosActivePanel = panel
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
			panel._mhMacrosSpecKey = nil
			panel._mhRefreshMacros()
		end
	end)

	panel:HookScript("OnSizeChanged", function()
		if panel:IsShown() and panel._mhRefreshMacros then
			panel._mhRefreshMacros()
		end
	end)

	SelectMacroType(panel, panel._mhMacrosSelectedType)
end
