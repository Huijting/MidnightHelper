--[[
	Professions Hub — one Toolbox sub-tab bundling all profession tools
	behind inner tabs: Overview (dashboard) | Treasures & Books
	(Profession.lua) | Course (ProfessionAcademy.lua).

	The treasures inner frame registers under the LEGACY panel id
	(ns.panels.professions) so Profession.lua's EnsureMainUI hook builds into
	it unchanged. The course frame is handed to BuildProfessionAcademyPanel
	directly. SelectTab("professions"/"profacademy") routes here via the
	alias in UI.lua (search, ProfessionsGuide button, saved tabs).
]]

local _, ns = ...

local NAV_H = 34
local BTN_W = 130
local BTN_H = 24

local TAB_TEX_ACTIVE = { 0.98, 0.94, 0.82 }
local TAB_TEX_INACTIVE = { 0.78, 0.72, 0.62 }
local SEP_COLOR = { 0.78, 0.62, 0.32, 0.55 }

local hub

local function SL(key)
	if ns.SafeL then
		return ns:SafeL(key)
	end
	return ns:L(key)
end

local INNER_DEFS = {
	{ id = "overview", labelKey = "PROFHUB_TAB_OVERVIEW" },
	{ id = "treasures", labelKey = "PROFHUB_TAB_TREASURES" },
	{ id = "course", labelKey = "PROFHUB_TAB_COURSE" },
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

local function RefreshChrome()
	if not hub then
		return
	end
	local active = ns.uiSelectedProfHubInner or "overview"
	for id, btn in pairs(hub._phButtons) do
		if id == active then
			btn:SetAlpha(1)
			TintButtonTextures(btn, TAB_TEX_ACTIVE[1], TAB_TEX_ACTIVE[2], TAB_TEX_ACTIVE[3])
		else
			btn:SetAlpha(0.88)
			TintButtonTextures(btn, TAB_TEX_INACTIVE[1], TAB_TEX_INACTIVE[2], TAB_TEX_INACTIVE[3])
		end
	end
end

local function RefreshOverview()
	if not (hub and hub._phOverview and hub._phOverview:IsShown()) then
		return
	end
	if hub._phOverviewHeader then
		hub._phOverviewHeader:SetText(SL("TAB_PROFESSIONS"))
	end
	if hub._phOverviewText then
		local text = ns.MH_GetProfessionsOverviewText and ns.MH_GetProfessionsOverviewText() or ""
		hub._phOverviewText:SetText(text)
	end
	if hub._phOverviewHint then
		hub._phOverviewHint:SetText(SL("PROFHUB_OVERVIEW_HINT"))
	end
end

function ns.MH_SelectProfessionsInnerTab(which)
	local valid = false
	for _, d in ipairs(INNER_DEFS) do
		if d.id == which then
			valid = true
			break
		end
	end
	if not valid then
		which = "overview"
	end
	ns.uiSelectedProfHubInner = which
	if not hub then
		return
	end
	for id, frame in pairs(hub._phFrames) do
		frame:SetShown(id == which)
	end
	RefreshChrome()
	if which == "overview" then
		RefreshOverview()
	end
	-- Help drawer text follows the active inner tab.
	if ns._mhRefreshSidePanel and ns.uiSelectedTab == "toolbox" then
		ns:_mhRefreshSidePanel("toolbox")
	end
end

function ns.BuildProfessionsHubPanel(panel)
	if not panel or panel._phBuilt then
		return
	end
	panel._phBuilt = true
	hub = panel

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local nav = CreateFrame("Frame", nil, panel)
	nav:SetHeight(NAV_H)
	nav:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -2)
	nav:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -2)

	panel._phButtons = {}
	local x = 0
	for _, def in ipairs(INNER_DEFS) do
		local btn = CreateFrame("Button", "MidnightHelperProfHubTab_" .. def.id, nav, "UIPanelButtonTemplate")
		btn:SetSize(BTN_W, BTN_H)
		btn:SetPoint("TOPLEFT", nav, "TOPLEFT", x, -4)
		btn:SetText(SL(def.labelKey))
		local id = def.id
		btn:SetScript("OnClick", function()
			ns.MH_SelectProfessionsInnerTab(id)
		end)
		panel._phButtons[def.id] = btn
		x = x + BTN_W + 6
	end

	local sep = panel:CreateTexture(nil, "ARTWORK")
	sep:SetHeight(1)
	sep:SetPoint("TOPLEFT", nav, "BOTTOMLEFT", 0, -2)
	sep:SetPoint("TOPRIGHT", nav, "BOTTOMRIGHT", 0, -2)
	sep:SetColorTexture(SEP_COLOR[1], SEP_COLOR[2], SEP_COLOR[3], SEP_COLOR[4])

	panel._phFrames = {}
	local function MakeInner(id)
		local f = CreateFrame("Frame", nil, panel)
		f:SetPoint("TOPLEFT", sep, "BOTTOMLEFT", 0, -4)
		f:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 0)
		f:Hide()
		panel._phFrames[id] = f
		return f
	end

	-- Overview: profession dashboard (detection, KP, live tree advice).
	local overview = MakeInner("overview")
	panel._phOverview = overview
	local oh = overview:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	oh:SetPoint("TOPLEFT", overview, "TOPLEFT", 12, -10)
	oh:SetJustifyH("LEFT")
	panel._phOverviewHeader = oh
	local ot = overview:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	ot:SetPoint("TOPLEFT", oh, "BOTTOMLEFT", 0, -10)
	ot:SetPoint("RIGHT", overview, "RIGHT", -16, 0)
	ot:SetJustifyH("LEFT")
	ot:SetWordWrap(true)
	ot:SetSpacing(3)
	panel._phOverviewText = ot
	local hint = overview:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hint:SetPoint("BOTTOMLEFT", overview, "BOTTOMLEFT", 12, 12)
	hint:SetPoint("RIGHT", overview, "RIGHT", -16, 0)
	hint:SetJustifyH("LEFT")
	hint:SetWordWrap(true)
	panel._phOverviewHint = hint

	-- Treasures & Books: Profession.lua finds ns.panels.professions via its
	-- EnsureMainUI hook (runs after the main UI build) and builds into it.
	local treasures = MakeInner("treasures")
	treasures._header = treasures:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	treasures._header:SetPoint("TOPLEFT", treasures, "TOPLEFT", 12, -10)
	ns.panels = ns.panels or {}
	ns.panels.professions = treasures

	-- Course: Professions 101 builds directly into its inner frame.
	local course = MakeInner("course")
	course._header = course:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	course._header:SetPoint("TOPLEFT", course, "TOPLEFT", 12, -10)
	course._header:SetJustifyH("LEFT")
	if ns.BuildProfessionAcademyPanel then
		ns.BuildProfessionAcademyPanel(course)
	end

	-- Live overview refresh (profession learned/dropped, KP committed).
	local ev = CreateFrame("Frame", nil, panel)
	ev:RegisterEvent("SKILL_LINES_CHANGED")
	ev:RegisterEvent("TRAIT_CONFIG_UPDATED")
	ev:RegisterEvent("TRADE_SKILL_SHOW")
	ev:SetScript("OnEvent", function()
		RefreshOverview()
	end)

	panel:SetScript("OnShow", function()
		ns.MH_SelectProfessionsInnerTab(ns.uiSelectedProfHubInner or "overview")
	end)

	do
		local orig = ns.RefreshLocaleUI
		function ns:RefreshLocaleUI()
			if orig then
				orig(self)
			end
			if hub and hub._phBuilt then
				for _, def in ipairs(INNER_DEFS) do
					local btn = hub._phButtons[def.id]
					if btn then
						btn:SetText(SL(def.labelKey))
					end
				end
				RefreshOverview()
			end
		end
	end

	ns.MH_SelectProfessionsInnerTab(ns.uiSelectedProfHubInner or "overview")
end
