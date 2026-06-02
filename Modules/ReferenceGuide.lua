--[[
	Midnight Helper — "Guide" tab host (Dawncrests, Professions, …).
]]

local _, ns = ...

local SUB_DAWNCREST = "dawncrest"
local SUB_PROFESSIONS = "professions"

local hostPanel
local scroll
local scrollChild
local subNav
local subButtons = {}

local function GetRefSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { subTab = SUB_DAWNCREST }
	end
	if type(ui.referenceGuide) ~= "table" then
		ui.referenceGuide = { subTab = SUB_DAWNCREST }
	end
	if not ui.referenceGuide.subTab then
		ui.referenceGuide.subTab = SUB_DAWNCREST
	end
	return ui.referenceGuide
end

local function GetRefSubTab()
	return GetRefSettings().subTab or SUB_DAWNCREST
end

local function SetRefSubTab(id)
	GetRefSettings().subTab = id
end

function ns.SyncReferenceGuideScroll()
	if not scroll or not scrollChild then
		return
	end
	local sw = math.max(200, (scroll:GetWidth() or 0) - 4)
	scrollChild:SetWidth(sw)
	local h = 8
	if scrollChild._intro and scrollChild._intro:IsShown() then
		scrollChild._intro:SetWidth(sw - 8)
		h = h + (scrollChild._intro:GetStringHeight() or 0) + 10
	end
	if subNav and subNav:IsShown() then
		h = h + (subNav:GetHeight() or 0) + 6
	end
	if ns.DawncrestGuidePanel and ns.DawncrestGuidePanel:IsShown() then
		h = h + (ns.DawncrestGuidePanel:GetHeight() or 0) + 12
	end
	if ns.ProfessionsGuidePanel and ns.ProfessionsGuidePanel:IsShown() then
		h = h + (ns.ProfessionsGuidePanel:GetHeight() or 0) + 12
	end
	if scrollChild._comingSoon and scrollChild._comingSoon:IsShown() then
		scrollChild._comingSoon:SetWidth(sw - 8)
		h = h + (scrollChild._comingSoon:GetStringHeight() or 0) + 12
	end
	scrollChild:SetHeight(math.max(1, h))
	if scroll.UpdateScrollChildRect then
		scroll:UpdateScrollChildRect()
	end
end

local function RefreshSubNavChrome()
	local active = GetRefSubTab()
	for id, btn in pairs(subButtons) do
		if btn then
			if id == active then
				btn:SetAlpha(1)
			else
				btn:SetAlpha(0.85)
			end
		end
	end
end

local function ApplySubTabVisibility()
	local sub = GetRefSubTab()
	if ns.DawncrestGuidePanel then
		ns.DawncrestGuidePanel:SetShown(sub == SUB_DAWNCREST)
	end
	if ns.ProfessionsGuidePanel then
		ns.ProfessionsGuidePanel:SetShown(sub == SUB_PROFESSIONS)
	end
	if scrollChild and scrollChild._comingSoon then
		scrollChild._comingSoon:SetShown(sub == SUB_DAWNCREST)
	end
	if scrollChild and scrollChild._intro then
		if sub == SUB_PROFESSIONS then
			scrollChild._intro:SetText(ns:L("PROFGUIDE_PANEL_INTRO"))
		else
			scrollChild._intro:SetText(ns:L("REF_PANEL_INTRO"))
		end
	end
end

function ns.RefreshReferenceGuidePanel()
	if not hostPanel then
		return
	end
	RefreshSubNavChrome()
	ApplySubTabVisibility()
	if ns.RefreshDawncrestGuide then
		ns.RefreshDawncrestGuide()
	end
	if ns.RefreshProfessionsGuide then
		ns.RefreshProfessionsGuide()
	end
	ns.SyncReferenceGuideScroll()
end

function ns.SetReferenceGuideSubTab(id)
	if id ~= SUB_DAWNCREST and id ~= SUB_PROFESSIONS then
		return
	end
	SetRefSubTab(id)
	if ns.RefreshReferenceGuidePanel then
		ns.RefreshReferenceGuidePanel()
	end
end

function ns.BuildReferenceGuidePanel(panel)
	if not panel then
		return
	end
	if panel._mhRefBuilt then
		if panel._header then
			panel._header:Hide()
		end
		if panel._body then
			panel._body:Hide()
		end
		ns.RefreshReferenceGuidePanel()
		return
	end
	panel._mhRefBuilt = true
	hostPanel = panel

	if panel._header then
		panel._header:Hide()
	end
	if panel._body then
		panel._body:Hide()
	end

	scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -8)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, 8)
	scroll:EnableMouseWheel(true)

	scrollChild = CreateFrame("Frame", nil, scroll)
	scroll:SetScrollChild(scrollChild)

	local intro = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	intro:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 4, -4)
	intro:SetPoint("RIGHT", scrollChild, "RIGHT", -4, 0)
	intro:SetJustifyH("LEFT")
	intro:SetWordWrap(true)
	intro:SetTextColor(0.85, 0.82, 0.75)
	scrollChild._intro = intro

	subNav = CreateFrame("Frame", nil, scrollChild)
	subNav:SetPoint("TOPLEFT", intro, "BOTTOMLEFT", -4, -8)
	subNav:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
	subNav:SetHeight(26)

	local btnDawn = CreateFrame("Button", nil, subNav, "UIPanelButtonTemplate")
	btnDawn:SetSize(120, 24)
	btnDawn:SetPoint("LEFT", subNav, "LEFT", 0, 0)
	btnDawn:SetText(ns:L("PROFGUIDE_SUB_DAWNCREST"))
	btnDawn:SetScript("OnClick", function()
		ns.SetReferenceGuideSubTab(SUB_DAWNCREST)
	end)
	subButtons[SUB_DAWNCREST] = btnDawn

	local btnProf = CreateFrame("Button", nil, subNav, "UIPanelButtonTemplate")
	btnProf:SetSize(120, 24)
	btnProf:SetPoint("LEFT", btnDawn, "RIGHT", 6, 0)
	btnProf:SetText(ns:L("PROFGUIDE_SUB_PROFESSIONS"))
	btnProf:SetScript("OnClick", function()
		ns.SetReferenceGuideSubTab(SUB_PROFESSIONS)
	end)
	subButtons[SUB_PROFESSIONS] = btnProf

	local contentAnchor = subNav

	if ns.EnsureDawncrestGuidePanel then
		local dawncrest = ns.EnsureDawncrestGuidePanel(scrollChild)
		if dawncrest then
			dawncrest:ClearAllPoints()
			dawncrest:SetPoint("TOPLEFT", contentAnchor, "BOTTOMLEFT", 0, -10)
			dawncrest:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
		end
	end

	if ns.EnsureProfessionsGuidePanel then
		local profGuide = ns.EnsureProfessionsGuidePanel(scrollChild)
		if profGuide then
			profGuide:ClearAllPoints()
			profGuide:SetPoint("TOPLEFT", contentAnchor, "BOTTOMLEFT", 0, -10)
			profGuide:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
		end
	end

	local coming = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	coming:SetPoint("TOPLEFT", ns.DawncrestGuidePanel or contentAnchor, "BOTTOMLEFT", 4, -14)
	coming:SetPoint("RIGHT", scrollChild, "RIGHT", -4, 0)
	coming:SetJustifyH("LEFT")
	coming:SetWordWrap(true)
	scrollChild._comingSoon = coming

	panel:SetScript("OnShow", function()
		ns.RefreshReferenceGuidePanel()
	end)
	panel:SetScript("OnSizeChanged", function()
		if panel:IsVisible() then
			ns.RefreshReferenceGuidePanel()
		end
	end)

	ns.RefreshReferenceGuidePanel()
	if C_Timer and C_Timer.After then
		C_Timer.After(0.1, function()
			if panel:IsShown() then
				ns.RefreshReferenceGuidePanel()
			end
		end)
	end
end

if not ns._mhReferenceLocaleHooked then
	ns._mhReferenceLocaleHooked = true
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ns.RefreshReferenceGuidePanel then
			ns.RefreshReferenceGuidePanel()
		end
	end
end
