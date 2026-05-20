--[[
	Midnight Helper — Role Academy (tank / heal confidence, group content ramp).
]]

local addonName, ns = ...

local TRACK_TANK = "tank"
local TRACK_HEAL = "heal"

local SECTION_KEYS = {
	tank = {
		{ "ACADEMY_TANK_INTRO_TITLE", "ACADEMY_TANK_INTRO_BODY" },
		{ "ACADEMY_TANK_PREP_TITLE", "ACADEMY_TANK_PREP_BODY" },
		{ "ACADEMY_TANK_PULL_TITLE", "ACADEMY_TANK_PULL_BODY" },
		{ "ACADEMY_TANK_WIPE_TITLE", "ACADEMY_TANK_WIPE_BODY" },
		{ "ACADEMY_TANK_LADDER_TITLE", "ACADEMY_TANK_LADDER_BODY" },
		{ "ACADEMY_TANK_BOTH_TITLE", "ACADEMY_TANK_BOTH_BODY" },
	},
	heal = {
		{ "ACADEMY_HEAL_INTRO_TITLE", "ACADEMY_HEAL_INTRO_BODY" },
		{ "ACADEMY_HEAL_PREP_TITLE", "ACADEMY_HEAL_PREP_BODY" },
		{ "ACADEMY_HEAL_TRIAGE_TITLE", "ACADEMY_HEAL_TRIAGE_BODY" },
		{ "ACADEMY_HEAL_WIPE_TITLE", "ACADEMY_HEAL_WIPE_BODY" },
		{ "ACADEMY_HEAL_LADDER_TITLE", "ACADEMY_HEAL_LADDER_BODY" },
		{ "ACADEMY_HEAL_BOTH_TITLE", "ACADEMY_HEAL_BOTH_BODY" },
	},
}

local SCROLL_BOTTOM = 52
local NAV_H = 32
local LINK_BTN_W = 118
local LINK_BTN_H = 22

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

local function OpenTab(tabId)
	if ns.ShowMainUI then
		ns:ShowMainUI()
	end
	if ns.SelectTab then
		ns.SelectTab(tabId)
	end
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
		titleFs:SetText(ns:L(titleKey))
		titleFs:Show()
		panel._academySectionFs[#panel._academySectionFs + 1] = titleFs

		local _, th = titleFs:GetFont()
		th = th or 14
		y = y - th - 4

		local bodyFs = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		bodyFs:SetPoint("TOPLEFT", child, "TOPLEFT", 4, y)
		bodyFs:SetWidth(cw)
		bodyFs:SetJustifyH("LEFT")
		bodyFs:SetWordWrap(true)
		bodyFs:SetSpacing(3)
		bodyFs:SetTextColor(0.82, 0.8, 0.74)
		bodyFs:SetText(ns:L(bodyKey))
		bodyFs:Show()
		panel._academySectionFs[#panel._academySectionFs + 1] = bodyFs

		local bh = bodyFs:GetStringHeight() or 40
		y = y - bh - 14
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
		panel._header:SetText(ns:L("TAB_ACADEMY"))
	end
	if panel._subtitle and panel._subtitle.SetText then
		panel._subtitle:SetText(ns:L("ACADEMY_SUBTITLE"))
	end
	if panel._btnTank and panel._btnTank.SetText then
		panel._btnTank:SetText(ns:L("ACADEMY_TRACK_TANK"))
	end
	if panel._btnHeal and panel._btnHeal.SetText then
		panel._btnHeal:SetText(ns:L("ACADEMY_TRACK_HEAL"))
	end
	if panel._linkMacros and panel._linkMacros.SetText then
		panel._linkMacros:SetText(ns:L("ACADEMY_LINK_MACROS"))
	end
	if panel._linkConsumables and panel._linkConsumables.SetText then
		panel._linkConsumables:SetText(ns:L("ACADEMY_LINK_CONSUMABLES"))
	end
	if panel._linkGuide and panel._linkGuide.SetText then
		panel._linkGuide:SetText(ns:L("ACADEMY_LINK_GUIDE"))
	end
	if panel._linkDelves and panel._linkDelves.SetText then
		panel._linkDelves:SetText(ns:L("ACADEMY_LINK_DELVES"))
	end

	local track = GetTrack()
	TintTrackBtn(panel._btnTank, track == TRACK_TANK)
	TintTrackBtn(panel._btnHeal, track == TRACK_HEAL)
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

	local linkBar = CreateFrame("Frame", nil, panel)
	linkBar:SetHeight(LINK_BTN_H + 4)
	linkBar:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 12, 12)
	linkBar:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -12, 12)
	panel._academyLinkBar = linkBar

	local function MakeLink(parent, anchor, offsetX, tabId, key)
		local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
		btn:SetSize(LINK_BTN_W, LINK_BTN_H)
		if anchor then
			btn:SetPoint("LEFT", anchor, "RIGHT", offsetX, 0)
		else
			btn:SetPoint("LEFT", parent, "LEFT", 0, 0)
		end
		btn:SetScript("OnClick", function()
			OpenTab(tabId)
		end)
		return btn
	end

	panel._linkMacros = MakeLink(linkBar, nil, 0, "macros", "ACADEMY_LINK_MACROS")
	panel._linkConsumables = MakeLink(linkBar, panel._linkMacros, 6, "consumables", "ACADEMY_LINK_CONSUMABLES")
	panel._linkGuide = MakeLink(linkBar, panel._linkConsumables, 6, "guide", "ACADEMY_LINK_GUIDE")
	panel._linkDelves = MakeLink(linkBar, panel._linkGuide, 6, "delves", "ACADEMY_LINK_DELVES")

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperAcademyScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", nav, "BOTTOMLEFT", 0, -6)
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
