--[[
	Experimental Leveling sub-tab: ISO-style keyboard preview (NL/UK-like):
	L-shaped Enter spans Q + Caps only (no stub key on Q row); \| sits on the home row (before Enter),
	not beside Z. AltGr / RWin / Menu on the bottom; RShift aligns with RCtrl (no arrow island).
	Midnight-bound keys stay bright; other keys are dimmed.
	Safe to delete this file + UI wiring + TOC line when the real layout ships.
]]

local addonName, ns = ...

local KW, KH = 30, 26
local GAP = 5

local MODIFIER_KEYS = {
	Esc = true,
	Tab = true,
	Caps = true,
	LShift = true,
	RShift = true,
	LCtrl = true,
	RCtrl = true,
	LAlt = true,
	RAlt = true,
	LWin = true,
	RWin = true,
	Menu = true,
	BkSp = true,
	Enter = true,
	[" "] = true,
}
local function SpellNameFromID(spellID)
	if not spellID or spellID < 1 then
		return nil
	end
	local ok, si = pcall(function()
		if C_Spell and C_Spell.GetSpellInfo then
			return C_Spell.GetSpellInfo(spellID)
		end
		return nil
	end)
	if ok and si and si.name and si.name ~= "" then
		return si.name
	end
	return ("Spell %d"):format(spellID)
end

local function ProtoResolveSlug()
	local slug = ns.MH_GetHunterKeybindSlugForUi and ns.MH_GetHunterKeybindSlugForUi()
	if slug then
		return slug
	end
	return "hunter_early"
end

local function ProtoTooltipForKey(uiKey, slot, spec)
	local ref = ns.KeybindingReference
	if not ref or not spec or not spec.spellByUiKey then
		return ns:L("LAYOUT_KEY_EMPTY_TOOLTIP")
	end
	local sp = spec.spellByUiKey[uiKey]
	if not sp or not sp.id then
		if uiKey == "G" then
			return ns:L("LAYOUT_KEY_G_OPTIONAL_TOOLTIP")
		end
		return ns:L("LAYOUT_KEY_EMPTY_TOOLTIP")
	end
	local name = SpellNameFromID(sp.id) or ("#" .. tostring(sp.id))
	local cat = ""
	if slot and slot.categoryLocaleKey then
		cat = ns:L(slot.categoryLocaleKey)
	end
	if cat ~= "" then
		return ns:L("LAYOUT_KEY_SPELL_TOOLTIP_FMT"):format(name, cat)
	end
	return name
end

--- Build pixel positions: ISO block (Enter spans Q+Caps only), RShift flush with RCtrl.
--- Esc+F-row centered on main block width.
local function BuildKeyPositions()
	local P = {}
	local CELL = KW + GAP
	local M = 10
	local yF = 6
	local yTopMain = yF + KH + 14
	local yNum = yTopMain
	local yQ = yNum + KH + GAP
	local yA = yQ + KH + GAP
	local yZ = yA + KH + GAP
	local yBot = yZ + KH + GAP + 6

	local function bumpMainRight(xm, xy)
		local w = (type(xy[3]) == "number" and xy[3]) or KW
		return math.max(xm, xy[1] + w)
	end

	-- Number row
	local y = yNum
	local x = M
	local numRow = { "`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=" }
	for i = 1, #numRow do
		P[numRow[i]] = { x, y }
		x = x + CELL
	end
	local bkW = CELL * 2
	P["BkSp"] = { x + GAP, y, bkW }
	local numBlockRight = x + GAP + bkW

	local tabW = CELL * 1.52
	local capsW = tabW

	-- Q row: Tab, Q…P, [, ] — Enter column only below (no stub key on Q row)
	P["Tab"] = { M, yQ, tabW }
	local xq = M + tabW + GAP
	local qRow = { "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]" }
	for i = 1, #qRow do
		P[qRow[i]] = { xq + (i - 1) * CELL, yQ }
	end
	local enterX = xq + #qRow * CELL + GAP
	local enterW = CELL * 1.22
	local enterH = 2 * KH + GAP
	P["Enter"] = { enterX, yQ, enterW, enterH }

	-- Caps row
	P["Caps"] = { M, yA, capsW }
	local xa = M + capsW + GAP
	local aRow = { "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "\\" }
	for i = 1, #aRow do
		P[aRow[i]] = { xa + (i - 1) * CELL, yA }
	end

	-- Bottom row first (defines right edge for RShift alignment)
	y = yBot
	local lcW = CELL * 1.12
	local lwW = CELL * 1.04
	local laW = CELL * 1.04
	local spW = CELL * 5.95
	local raW = CELL * 1.14
	local rwW = CELL * 1.04
	local menuW = CELL * 1.02
	local rcW = CELL * 1.12
	x = M
	P["LCtrl"] = { x, y, lcW }
	x = x + lcW + GAP
	P["LWin"] = { x, y, lwW }
	x = x + lwW + GAP
	P["LAlt"] = { x, y, laW }
	x = x + laW + GAP
	P[" "] = { x, y, spW }
	x = x + spW + GAP
	P["RAlt"] = { x, y, raW }
	x = x + raW + GAP
	P["RWin"] = { x, y, rwW }
	x = x + rwW + GAP
	P["Menu"] = { x, y, menuW }
	x = x + menuW + GAP
	P["RCtrl"] = { x, y, rcW }
	local botRight = x + rcW

	-- Shift row: LShift then Z…/ (no \| here — backslash is on the home row); Z aligns under A
	local lsW = capsW
	P["LShift"] = { M, yZ, lsW }
	local zStart = M + lsW + GAP
	local zRow = { "Z", "X", "C", "V", "B", "N", "M", ",", ".", "/" }
	for i = 1, #zRow do
		P[zRow[i]] = { zStart + (i - 1) * CELL, yZ }
	end
	local rShiftLeft = zStart + #zRow * CELL + GAP
	local rsW = botRight - rShiftLeft
	P["RShift"] = { rShiftLeft, yZ, rsW }

	local mainRight = M
	for k, xy in pairs(P) do
		if k ~= "Enter" then
			mainRight = bumpMainRight(mainRight, xy)
		end
	end
	mainRight = bumpMainRight(mainRight, P["Enter"])

	local escW = CELL * 1.05
	local fStripW = 12 * CELL - GAP
	local topStripW = escW + GAP + fStripW
	local topStart = M + (mainRight - M - topStripW) / 2
	if topStart < M then
		topStart = M
	end
	P["Esc"] = { topStart, yF, escW }
	local f0 = topStart + escW + GAP
	for i = 1, 12 do
		P["F" .. i] = { f0 + (i - 1) * CELL, yF }
	end

	local maxX, maxY = 0, 0
	for _, xy in pairs(P) do
		local w = (type(xy[3]) == "number" and xy[3]) or KW
		local h = (type(xy[4]) == "number" and xy[4]) or KH
		maxX = math.max(maxX, xy[1] + w)
		maxY = math.max(maxY, xy[2] + h)
	end

	maxX = math.max(maxX, numBlockRight, topStart + topStripW)
	return P, maxX + M + 10, maxY + M + 12
end

local KEY_POS, HOST_W, HOST_H = BuildKeyPositions()

local function ProtoAttachTooltip(btn, text)
	if not btn then
		return
	end
	btn:SetScript("OnEnter", function(self)
		local gt = _G.GameTooltip
		if not gt or not self then
			return
		end
		gt:SetOwner(self, "ANCHOR_RIGHT")
		gt:SetText(text, nil, nil, nil, nil, true)
		gt:Show()
	end)
	btn:SetScript("OnLeave", function()
		local gt = _G.GameTooltip
		if gt then
			gt:Hide()
		end
	end)
	btn:SetScript("OnClick", function(self)
		if self._mhProtoTipText then
			local ts = self._mhProtoTipText
			if ts == "" then
				return
			end
			if DEFAULT_CHAT_FRAME then
				DEFAULT_CHAT_FRAME:AddMessage("|cffaaeeffMidnight Helper (Layout):|r " .. ts)
			end
		end
	end)
end

local function PlainTooltipText(raw)
	if not raw then
		return ""
	end
	return raw:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
end

local function ProtoTooltipForDimmedKey(uiKey)
	if MODIFIER_KEYS[uiKey] then
		return ns:L("LAYOUT_KEY_MODIFIER_TOOLTIP")
	end
	return ns:L("LAYOUT_KEY_UNUSED_TOOLTIP")
end

local function LabelForPrototypeKey(uiKey)
	if uiKey == " " then
		return "Space"
	end
	if uiKey == "\\" then
		return "\\"
	end
	if uiKey == "BkSp" then
		return "Back"
	end
	if uiKey == "Esc" then
		return "Esc"
	end
	if uiKey == "LWin" then
		return "Win"
	end
	if uiKey == "RWin" then
		return "Win"
	end
	if uiKey == "Menu" then
		return "Menu"
	end
	if uiKey == "RAlt" then
		return "AltGr"
	end
	if uiKey == "LCtrl" or uiKey == "RCtrl" then
		return "Ctrl"
	end
	if uiKey == "LAlt" then
		return "Alt"
	end
	if uiKey == "LShift" or uiKey == "RShift" then
		return "Shift"
	end
	return uiKey
end

function ns.KeyboardLayoutPrototype_Refresh(panel)
	if not panel or not panel._mhProtoButtons then
		return
	end
	local ref = ns.KeybindingReference
	local slug = ProtoResolveSlug()
	local spec = ref and ref.specsById and ref.specsById[slug]
	local slots = ref and ref.slots
	local slotByUi = {}
	local usedUiKeys = {}
	if type(slots) == "table" then
		for i = 1, #slots do
			local s = slots[i]
			if s and s.ui_key then
				slotByUi[s.ui_key] = s
				usedUiKeys[s.ui_key] = true
			end
		end
	end

	for uiKey, btn in pairs(panel._mhProtoButtons) do
		if btn then
			local slot = slotByUi[uiKey]
			local tip
			local plain

			if not usedUiKeys[uiKey] then
				tip = ProtoTooltipForDimmedKey(uiKey)
				plain = PlainTooltipText(tip)
				btn:SetAlpha(0.32)
			else
				tip = ProtoTooltipForKey(uiKey, slot, spec)
				plain = PlainTooltipText(tip)
				local sp = spec and spec.spellByUiKey and spec.spellByUiKey[uiKey]
				if uiKey == "G" and (not sp or not sp.id) then
					btn:SetAlpha(0.52)
				elseif sp and sp.id then
					btn:SetAlpha(1)
				else
					btn:SetAlpha(0.62)
				end
			end

			btn._mhProtoTipText = plain
			ProtoAttachTooltip(btn, tip)
		end
	end

	if panel._header then
		panel._header:SetText(ns:L("TAB_LEVELING_SUB_LAYOUT"))
	end
	if panel._mhProtoSubtitle then
		panel._mhProtoSubtitle:SetText(ns:L("LAYOUT_PROTOTYPE_SUBTITLE"))
	end

	if panel._mhProtoHost then
		panel._mhProtoHost:SetSize(HOST_W, HOST_H)
	end
end

function ns.BuildKeyboardLayoutPrototypePanel(panel)
	if not panel then
		return
	end
	--- Earlier builds could set `_mhProtoBuilt` before failing (e.g. host without `CreateModulePanel` `_header`).
	if panel._mhProtoBuilt and not panel._mhProtoHost then
		panel._mhProtoBuilt = false
	end
	if panel._mhProtoBuilt then
		return
	end

	if panel._body then
		panel._body:Hide()
	end

	if not panel._header then
		local header = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
		header:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -12)
		panel._header = header
	else
		panel._header:ClearAllPoints()
		panel._header:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -12)
	end
	panel._header:SetText(ns:L("TAB_LEVELING_SUB_LAYOUT"))

	if not panel._mhProtoBg then
		local bg = CreateFrame("Frame", nil, panel, "BackdropTemplate")
		bg:SetFrameStrata(panel:GetFrameStrata())
		bg:SetFrameLevel(math.max(0, (panel:GetFrameLevel() or 0) - 1))
		bg:SetAllPoints()
		if bg.SetBackdrop then
			bg:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8X8",
				tile = false,
				edgeSize = 1,
				insets = { left = 0, right = 0, top = 0, bottom = 0 },
			})
		end
		if bg.SetBackdropColor then
			bg:SetBackdropColor(0.07, 0.07, 0.09, 0.97)
		end
		panel._mhProtoBg = bg
	end

	local sub = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	sub:SetPoint("TOPLEFT", panel._header, "BOTTOMLEFT", 0, -6)
	sub:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -14)
	sub:SetJustifyH("LEFT")
	sub:SetWordWrap(true)
	sub:SetSpacing(3)
	sub:SetText(ns:L("LAYOUT_PROTOTYPE_SUBTITLE"))
	sub:SetTextColor(0.78, 0.74, 0.68)
	panel._mhProtoSubtitle = sub

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperKeyboardProtoScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetFrameStrata(panel:GetFrameStrata())
	scroll:SetFrameLevel(math.max(1, (panel:GetFrameLevel() or 0) + 5))
	scroll:SetPoint("TOPLEFT", sub, "BOTTOMLEFT", -4, -10)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, 12)

	local host = CreateFrame("Frame", nil, scroll)
	host:SetSize(HOST_W, HOST_H)
	scroll:SetScrollChild(host)
	panel._mhProtoHost = host

	panel._mhProtoButtons = {}

	for uiKey, xy in pairs(KEY_POS) do
		local b = CreateFrame("Button", nil, host, "UIPanelButtonTemplate")
		local w = KW
		local h = KH
		if type(xy[3]) == "number" then
			w = xy[3]
		end
		if type(xy[4]) == "number" then
			h = xy[4]
		end
		b:SetSize(w, h)
		b:SetPoint("TOPLEFT", host, "TOPLEFT", xy[1], -xy[2])
		b:SetText(LabelForPrototypeKey(uiKey))
		panel._mhProtoButtons[uiKey] = b
	end

	ns.KeyboardLayoutPrototype_Refresh(panel)

	if not panel._mhProtoEvents then
		panel._mhProtoEvents = true
		panel:RegisterEvent("PLAYER_LEVEL_UP")
		panel:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		panel:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		panel:RegisterEvent("PLAYER_ENTERING_WORLD")
		panel:SetScript("OnEvent", function(_, event)
			if
				event == "PLAYER_LEVEL_UP"
				or event == "PLAYER_SPECIALIZATION_CHANGED"
				or event == "ACTIVE_TALENT_GROUP_CHANGED"
				or event == "PLAYER_ENTERING_WORLD"
			then
				ns.KeyboardLayoutPrototype_Refresh(panel)
			end
		end)

		panel:SetScript("OnShow", function()
			ns.KeyboardLayoutPrototype_Refresh(panel)
		end)
	end

	panel._mhProtoBuilt = true
end
