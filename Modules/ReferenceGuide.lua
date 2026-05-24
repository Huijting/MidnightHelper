--[[
	Midnight Helper — "Guide" tab host (Dawncrests + future topics).
	Future: add a row of sub-tab / topic buttons here (Dawncrests, Professions, …) when more guides ship.
]]

local _, ns = ...

local hostPanel
local scroll
local scrollChild

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
	if ns.DawncrestGuidePanel and ns.DawncrestGuidePanel:IsShown() then
		h = h + (ns.DawncrestGuidePanel:GetHeight() or 0) + 12
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

local function SyncScroll()
	ns.SyncReferenceGuideScroll()
end

local referenceRefreshing = false

function ns.RefreshReferenceGuidePanel()
	if referenceRefreshing or not hostPanel then
		return
	end
	referenceRefreshing = true
	if scrollChild and scrollChild._intro then
		scrollChild._intro:SetText(ns:L("REF_PANEL_INTRO"))
	end
	if scrollChild and scrollChild._comingSoon then
		scrollChild._comingSoon:SetText(ns:L("REF_MORE_COMING"))
	end
	if ns.RefreshDawncrestGuide then
		ns.RefreshDawncrestGuide()
	end
	SyncScroll()
	referenceRefreshing = false
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

	if ns.EnsureDawncrestGuidePanel then
		local dawncrest = ns.EnsureDawncrestGuidePanel(scrollChild)
		if dawncrest then
			dawncrest:ClearAllPoints()
			dawncrest:SetPoint("TOPLEFT", intro, "BOTTOMLEFT", -4, -10)
			dawncrest:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
		end
	end

	local coming = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	coming:SetPoint("TOPLEFT", ns.DawncrestGuidePanel or intro, "BOTTOMLEFT", 4, -14)
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
