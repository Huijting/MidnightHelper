--[[
	Midnight Helper — Role Academy (tank / heal confidence, group content ramp).
]]

local addonName, ns = ...

local TRACK_TANK = "tank"
local TRACK_HEAL = "heal"

local PREFLIGHT_KEYS = {
	tank = { "interrupt", "defensive", "consumables", "taunt" },
	heal = { "macros", "defensive", "consumables", "practice" },
}

local PREFLIGHT_LABEL_KEYS = {
	tank = {
		interrupt = "ACADEMY_PREF_TANK_INTERRUPT",
		defensive = "ACADEMY_PREF_TANK_DEFENSIVE",
		consumables = "ACADEMY_PREF_TANK_CONSUMABLES",
		taunt = "ACADEMY_PREF_TANK_TAUNT",
	},
	heal = {
		macros = "ACADEMY_PREF_HEAL_MACROS",
		defensive = "ACADEMY_PREF_HEAL_DEFENSIVE",
		consumables = "ACADEMY_PREF_HEAL_CONSUMABLES",
		practice = "ACADEMY_PREF_HEAL_PRACTICE",
	},
}

local SECTION_KEYS = {
	tank = {
		{ "ACADEMY_TANK_INTRO_TITLE", "ACADEMY_TANK_INTRO_BODY" },
		{ "ACADEMY_TANK_PULL_TITLE", "ACADEMY_TANK_PULL_BODY" },
		{ "ACADEMY_TANK_WIPE_TITLE", "ACADEMY_TANK_WIPE_BODY" },
		{ "ACADEMY_TANK_DUNGEON_TITLE", "ACADEMY_TANK_DUNGEON_BODY" },
		{ "ACADEMY_TANK_RAID_TITLE", "ACADEMY_TANK_RAID_BODY" },
		{ "ACADEMY_TANK_CHAT_TITLE", "ACADEMY_TANK_CHAT_BODY" },
		{ "ACADEMY_TANK_LADDER_TITLE", "ACADEMY_TANK_LADDER_BODY" },
		{ "ACADEMY_TANK_BOTH_TITLE", "ACADEMY_TANK_BOTH_BODY" },
	},
	heal = {
		{ "ACADEMY_HEAL_INTRO_TITLE", "ACADEMY_HEAL_INTRO_BODY" },
		{ "ACADEMY_HEAL_TRIAGE_TITLE", "ACADEMY_HEAL_TRIAGE_BODY" },
		{ "ACADEMY_HEAL_WIPE_TITLE", "ACADEMY_HEAL_WIPE_BODY" },
		{ "ACADEMY_HEAL_DUNGEON_TITLE", "ACADEMY_HEAL_DUNGEON_BODY" },
		{ "ACADEMY_HEAL_RAID_TITLE", "ACADEMY_HEAL_RAID_BODY" },
		{ "ACADEMY_HEAL_CHAT_TITLE", "ACADEMY_HEAL_CHAT_BODY" },
		{ "ACADEMY_HEAL_LADDER_TITLE", "ACADEMY_HEAL_LADDER_BODY" },
		{ "ACADEMY_HEAL_BOTH_TITLE", "ACADEMY_HEAL_BOTH_BODY" },
	},
}

local SCROLL_BOTTOM = 12
local NAV_H = 32
local PREFLIGHT_ROW_MIN = 24
local CHAT_ROW_H = 24
local CHAT_COPY_BTN = 22
local CHAT_ROW_GAP = 3

local function SL(key)
	if ns.SafeL then
		return ns:SafeL(key)
	end
	return ns:L(key)
end

local function GetTrack()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return TRACK_TANK
	end
	if ui.roleAcademyTrack == TRACK_HEAL then
		return TRACK_HEAL
	end
	return TRACK_TANK
end

local function SetTrack(track)
	if not ns.db then
		return
	end
	if type(ns.db.ui) ~= "table" then
		ns.db.ui = {}
	end
	ns.db.ui.roleAcademyTrack = (track == TRACK_HEAL) and TRACK_HEAL or TRACK_TANK
end

local function EnsurePreflightBag()
	if not ns.db then
		return nil
	end
	if type(ns.db.ui) ~= "table" then
		ns.db.ui = {}
	end
	if type(ns.db.ui.roleAcademyPreflight) ~= "table" then
		ns.db.ui.roleAcademyPreflight = { tank = {}, heal = {} }
	end
	local bag = ns.db.ui.roleAcademyPreflight
	if type(bag.tank) ~= "table" then
		bag.tank = {}
	end
	if type(bag.heal) ~= "table" then
		bag.heal = {}
	end
	return bag
end

local function GetPreflightChecked(track, key)
	local bag = EnsurePreflightBag()
	if not bag then
		return false
	end
	local t = bag[track]
	return t and t[key] and true or false
end

local function SetPreflightChecked(track, key, checked)
	local bag = EnsurePreflightBag()
	if not bag then
		return
	end
	bag[track][key] = checked and true or false
end

local function TintTrackBtn(btn, active)
	if not btn or not btn.GetRegions then
		return
	end
	local tint = active and { 0.96, 0.93, 0.86 } or { 0.7, 0.66, 0.6 }
	for _, region in ipairs({ btn:GetRegions() }) do
		if region.GetObjectType and region:IsObjectType("Texture") and region.SetVertexColor then
			region:SetVertexColor(tint[1], tint[2], tint[3])
		end
	end
end

local function RefreshClassLine(panel)
	if not panel._classLine then
		return
	end
	local classLocalized = UnitClass("player") or "?"
	local specName = "-"
	if GetSpecialization and GetSpecializationInfo then
		local idx = GetSpecialization()
		if idx and idx > 0 then
			local _, name = GetSpecializationInfo(idx)
			if name and name ~= "" then
				specName = name
			end
		end
	end
	panel._classLine:SetText(SL("ACADEMY_CLASS_FMT"):format(classLocalized, specName))
end

local function RebuildPreflightChecks(panel)
	local track = GetTrack()
	local keys = PREFLIGHT_KEYS[track] or {}
	local labels = PREFLIGHT_LABEL_KEYS[track] or {}
	local checks = panel._preflightChecks or {}
	for i = 1, #checks do
		checks[i]:Hide()
	end
	panel._preflightChecks = panel._preflightChecks or {}

	local parent = panel._preflightBox
	if not parent then
		return
	end

	local boxW = math.max(280, (parent:GetWidth() or 400) - 16)
	local labelW = boxW - 36
	local y = -28
	for i = 1, #keys do
		local key = keys[i]
		local chk = panel._preflightChecks[i]
		if not chk then
			chk = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
			panel._preflightChecks[i] = chk
			chk:SetScript("OnClick", function(self)
				SetPreflightChecked(GetTrack(), self._mhPrefKey, self:GetChecked())
			end)
		end
		chk._mhPrefKey = key
		chk:Show()
		chk:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, y)
		chk:SetChecked(GetPreflightChecked(track, key))
		local labelKey = labels[key]
		local txt = chk.text or _G[chk:GetName() .. "Text"]
		local rowH = PREFLIGHT_ROW_MIN
		if txt and txt.SetText and labelKey then
			if txt.SetWidth then
				txt:SetWidth(labelW)
			end
			if txt.SetWordWrap then
				txt:SetWordWrap(true)
			end
			txt:SetText(SL(labelKey))
			if txt.SetTextColor then
				txt:SetTextColor(0.95, 0.9, 0.74)
			end
			if txt.GetStringHeight then
				rowH = math.max(PREFLIGHT_ROW_MIN, math.ceil(txt:GetStringHeight() or 14) + 8)
			end
		end
		y = y - rowH
	end

	if panel._preflightHint then
		local hint = panel._preflightHint
		hint:ClearAllPoints()
		hint:SetWidth(boxW)
		hint:SetText(SL("ACADEMY_PREF_HINT"))
		hint:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, y - 6)
		local hintH = hint:GetStringHeight() or 14
		parent:SetHeight(math.max(72, -y + hintH + 16))
	end
end

local function IsChatBodyKey(bodyKey)
	return bodyKey and bodyKey:find("_CHAT_BODY", 1, true) ~= nil
end

local function SplitChatLines(text)
	local lines = {}
	if not text or text == "" then
		return lines
	end
	for line in string.gmatch(text, "([^\n]+)") do
		lines[#lines + 1] = line
	end
	return lines
end

local function ChatLineForCopy(line)
	local inner = line:match('^%s*"(.*)"%s*$')
	if inner then
		return inner
	end
	return line:gsub('^"', ""):gsub('"$', "")
end

local function HighlightEditBox(eb)
	if not eb or not eb.SetFocus then
		return
	end
	eb:SetFocus(true)
	local t = eb:GetText() or ""
	if eb.HighlightText then
		eb:HighlightText(0, string.len(t))
	end
end

local function StyleChatEditBox(eb)
	if not eb or eb._mhChatStyled then
		return
	end
	eb._mhChatStyled = true
	eb:SetAutoFocus(false)
	eb:SetFontObject("GameFontHighlightSmall")
	eb:SetTextInsets(6, 6, 3, 3)
	eb:EnableMouse(true)
	eb:SetTextColor(0.92, 0.9, 0.82)
	local bg = eb:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", eb, "TOPLEFT", -2, 2)
	bg:SetPoint("BOTTOMRIGHT", eb, "BOTTOMRIGHT", 2, -2)
	bg:SetColorTexture(0.06, 0.06, 0.08, 0.85)
	eb._mhBg = bg
	eb:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	eb:SetScript("OnEditFocusGained", function(self)
		HighlightEditBox(self)
	end)
end

local function StyleChatCopyBtn(btn)
	if not btn or btn._mhChatCopyStyled then
		return
	end
	btn._mhChatCopyStyled = true
	local tex = btn:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints()
	pcall(function()
		if tex.SetAtlas then
			tex:SetAtlas("transmog-icon-chat")
		end
		if not tex.GetTexture or not tex:GetTexture() or tex:GetTexture() == 0 then
			if tex.SetAtlas then
				tex:SetAtlas("Garr_SearchIcon")
			end
		end
		if not tex.GetTexture or not tex:GetTexture() or tex:GetTexture() == 0 then
			tex:SetTexture(134400)
		end
	end)
	local hi = btn:CreateTexture(nil, "HIGHLIGHT")
	hi:SetAllPoints()
	hi:SetColorTexture(1, 1, 1, 0.12)
end

local function AcquireChatRow(panel, parent, index)
	panel._academyChatRows = panel._academyChatRows or {}
	local row = panel._academyChatRows[index]
	if not row then
		row = CreateFrame("Frame", nil, parent)
		row:SetHeight(CHAT_ROW_H)
		local eb = CreateFrame("EditBox", nil, row)
		StyleChatEditBox(eb)
		eb:SetPoint("LEFT", row, "LEFT", 0, 0)
		eb:SetHeight(CHAT_ROW_H)
		local copyBtn = CreateFrame("Button", nil, row)
		copyBtn:SetSize(CHAT_COPY_BTN, CHAT_COPY_BTN)
		copyBtn:SetPoint("RIGHT", row, "RIGHT", -2, 0)
		StyleChatCopyBtn(copyBtn)
		copyBtn:SetScript("OnClick", function()
			HighlightEditBox(eb)
		end)
		copyBtn:SetScript("OnEnter", function(self)
			if _G.GameTooltip then
				_G.GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				_G.GameTooltip:SetText(SL("ACADEMY_CHAT_COPY_TIP"), 1, 1, 1, 1, true)
				_G.GameTooltip:Show()
			end
		end)
		copyBtn:SetScript("OnLeave", function()
			if _G.GameTooltip then
				_G.GameTooltip:Hide()
			end
		end)
		row._eb = eb
		row._copyBtn = copyBtn
		panel._academyChatRows[index] = row
	end
	row:SetParent(parent)
	row:Show()
	return row
end

local function RebuildScrollContent(panel)
	local scroll = panel._academyScroll
	local child = panel._academyScrollChild
	if not scroll or not child then
		return
	end

	for _, fs in ipairs(panel._academySectionFs or {}) do
		if fs then
			fs:Hide()
			fs:SetParent(nil)
		end
	end
	panel._academySectionFs = {}

	for _, row in ipairs(panel._academyChatRows or {}) do
		if row then
			row:Hide()
		end
	end

	local track = GetTrack()
	local sections = SECTION_KEYS[track] or SECTION_KEYS.tank
	local y = -4
	local cw = math.max(320, (scroll:GetWidth() or 400) - 28)

	for i = 1, #sections do
		local titleKey, bodyKey = sections[i][1], sections[i][2]
		local titleFs = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		titleFs:SetPoint("TOPLEFT", child, "TOPLEFT", 4, y)
		titleFs:SetWidth(cw)
		titleFs:SetJustifyH("LEFT")
		titleFs:SetTextColor(1, 0.9, 0.55)
		titleFs:SetText(SL(titleKey))
		titleFs:Show()
		panel._academySectionFs[#panel._academySectionFs + 1] = titleFs

		local _, th = titleFs:GetFont()
		th = th or 14
		y = y - th - 4

		if IsChatBodyKey(bodyKey) then
			local hintFs = child:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
			hintFs:SetPoint("TOPLEFT", child, "TOPLEFT", 4, y)
			hintFs:SetWidth(cw)
			hintFs:SetJustifyH("LEFT")
			hintFs:SetWordWrap(true)
			hintFs:SetTextColor(0.55, 0.53, 0.48)
			hintFs:SetText(SL("ACADEMY_CHAT_HINT"))
			hintFs:Show()
			panel._academySectionFs[#panel._academySectionFs + 1] = hintFs

			local hh = hintFs:GetStringHeight() or 14
			y = y - hh - 6

			local lines = SplitChatLines(SL(bodyKey))
			for j = 1, #lines do
				local row = AcquireChatRow(panel, child, j)
				row:ClearAllPoints()
				row:SetPoint("TOPLEFT", child, "TOPLEFT", 4, y)
				row:SetSize(cw, CHAT_ROW_H)
				row._eb:SetWidth(cw - CHAT_COPY_BTN - 6)
				row._eb:SetText(ChatLineForCopy(lines[j]))
				y = y - CHAT_ROW_H - CHAT_ROW_GAP
			end
			for j = #lines + 1, #(panel._academyChatRows or {}) do
				panel._academyChatRows[j]:Hide()
			end
			y = y - 10
		else
			local bodyFs = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			bodyFs:SetPoint("TOPLEFT", child, "TOPLEFT", 4, y)
			bodyFs:SetWidth(cw)
			bodyFs:SetJustifyH("LEFT")
			bodyFs:SetWordWrap(true)
			bodyFs:SetSpacing(3)
			bodyFs:SetTextColor(0.82, 0.8, 0.74)
			bodyFs:SetText(SL(bodyKey))
			bodyFs:Show()
			panel._academySectionFs[#panel._academySectionFs + 1] = bodyFs

			local bh = bodyFs:GetStringHeight() or 40
			y = y - bh - 14
		end
	end

	child:SetSize(cw + 8, math.max(120, -y + 8))
	if scroll.UpdateScrollChildRect then
		scroll:UpdateScrollChildRect()
	end
	if scroll.SetVerticalScroll then
		scroll:SetVerticalScroll(0)
	end
end

function ns.MH_RefreshRoleAcademyPanel(panel)
	if not panel or not panel._academyBuilt then
		return
	end
	if panel._header and panel._header.SetText then
		panel._header:SetText(SL("TAB_ACADEMY"))
	end
	if panel._subtitle and panel._subtitle.SetText then
		panel._subtitle:SetText(SL("ACADEMY_SUBTITLE"))
	end
	if panel._preflightTitle and panel._preflightTitle.SetText then
		panel._preflightTitle:SetText(SL("ACADEMY_PREF_TITLE"))
	end
	if panel._btnTank and panel._btnTank.SetText then
		panel._btnTank:SetText(SL("ACADEMY_TRACK_TANK"))
	end
	if panel._btnHeal and panel._btnHeal.SetText then
		panel._btnHeal:SetText(SL("ACADEMY_TRACK_HEAL"))
	end
	local track = GetTrack()
	TintTrackBtn(panel._btnTank, track == TRACK_TANK)
	TintTrackBtn(panel._btnHeal, track == TRACK_HEAL)
	RefreshClassLine(panel)
	RebuildPreflightChecks(panel)
	RebuildScrollContent(panel)
end

function ns.BuildRoleAcademyPanel(panel)
	if not panel or panel._academyBuilt then
		return
	end
	panel._academyBuilt = true

	if panel._body then
		panel._body:Hide()
	end

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", panel._header, "BOTTOMLEFT", 0, -6)
	subtitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -6)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.78, 0.76, 0.7)
	panel._subtitle = subtitle

	local nav = CreateFrame("Frame", nil, panel)
	nav:SetHeight(NAV_H)
	nav:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	nav:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -8)
	panel._academyNav = nav

	local btnTank = CreateFrame("Button", nil, nav, "UIPanelButtonTemplate")
	btnTank:SetSize(100, 24)
	btnTank:SetPoint("TOPLEFT", nav, "TOPLEFT", 0, -4)
	btnTank:SetScript("OnClick", function()
		SetTrack(TRACK_TANK)
		ns.MH_RefreshRoleAcademyPanel(panel)
	end)
	panel._btnTank = btnTank

	local btnHeal = CreateFrame("Button", nil, nav, "UIPanelButtonTemplate")
	btnHeal:SetSize(100, 24)
	btnHeal:SetPoint("LEFT", btnTank, "RIGHT", 8, 0)
	btnHeal:SetScript("OnClick", function()
		SetTrack(TRACK_HEAL)
		ns.MH_RefreshRoleAcademyPanel(panel)
	end)
	panel._btnHeal = btnHeal

	local classLine = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	classLine:SetPoint("TOPLEFT", nav, "BOTTOMLEFT", 0, -4)
	classLine:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -4)
	classLine:SetJustifyH("LEFT")
	classLine:SetTextColor(0.85, 0.82, 0.65)
	panel._classLine = classLine

	local preflightBox = CreateFrame("Frame", nil, panel, "BackdropTemplate")
	preflightBox:SetPoint("TOPLEFT", classLine, "BOTTOMLEFT", -4, -6)
	preflightBox:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, -6)
	preflightBox:SetHeight(72)
	if preflightBox.SetBackdrop then
		preflightBox:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		})
		preflightBox:SetBackdropColor(0.08, 0.08, 0.1, 0.45)
		preflightBox:SetBackdropBorderColor(0.45, 0.4, 0.3, 0.5)
	end
	panel._preflightBox = preflightBox

	local preflightTitle = preflightBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	preflightTitle:SetPoint("TOPLEFT", preflightBox, "TOPLEFT", 8, -6)
	preflightTitle:SetTextColor(1, 0.88, 0.45)
	panel._preflightTitle = preflightTitle

	local preflightHint = preflightBox:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	preflightHint:SetJustifyH("LEFT")
	preflightHint:SetWordWrap(true)
	panel._preflightHint = preflightHint

	panel._preflightChecks = {}

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperAcademyScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", preflightBox, "BOTTOMLEFT", 0, -8)
	scroll:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 8, SCROLL_BOTTOM)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, SCROLL_BOTTOM)
	panel._academyScroll = scroll

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)
	panel._academyScrollChild = child
	panel._academySectionFs = {}

	scroll:SetScript("OnSizeChanged", function()
		if panel:IsShown() then
			ns.MH_RefreshRoleAcademyPanel(panel)
		end
	end)

	panel:SetScript("OnShow", function(self)
		ns.MH_RefreshRoleAcademyPanel(self)
	end)

	panel._mhRefreshAcademy = function()
		ns.MH_RefreshRoleAcademyPanel(panel)
	end

	ns.MH_RefreshRoleAcademyPanel(panel)
end
