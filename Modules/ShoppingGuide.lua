local _, ns = ...

--[[
	Midnight Helper — "How do I buy this?": the shopping list, step by step.

	Rob, 25 Oct 2026, after doing it all for Carola over Parsec: "Hebben wij daar een eenvoudige handleiding voor? …
	Waarbij gewoon echt stap voor stap uitgelegd wordt … Koop wel de goud variant en niet de zilveren variant." Plus:
	silver is not always the cheaper one, and nobody knew which gem goes in which socket. He chose C: short steps in
	the game, pictures on the website.

	Facts (mh-research 25 Oct 2026, wago 12.1.5.70575 + wow-ui-source 12.1.5; side-session-notes
	shopping_guide_facts_2026-10-25.md): every crafted consumable, enchant, gem and oil comes as silver (quality 13)
	and gold (14), each its own item and its own auction house row; gold was never weaker in 25+ pairs; food and the
	Augment Rune have one kind. The auction house tells them apart ONLY by the small tier icon behind the name
	(Blizzard_AuctionHouseTableBuilder), the atlas measured in Rob's client on 10 Oct (GearExport.lua). Midnight gems
	fit any socket; one Eversong Diamond (or heliotrope) per character. Gem: Shift + right-click (EXPANDITEM).

	Opened from the "Shopping list" window's header and from the character window's Gear check panel.
	No events, nothing secure: a window of text.
]]

local WIDTH = 470
local SILVER = "|A:Professions-ChatIcon-Quality-12-Tier1:18:18|a"
local GOLD = "|A:Professions-ChatIcon-Quality-12-Tier2:18:18|a"

local STEPS = {
	"SHOPGUIDE_STEP_OPEN",
	"SHOPGUIDE_STEP_CLICK",
	"SHOPGUIDE_STEP_TWO_ROWS_FMT",
	"SHOPGUIDE_STEP_PRICE",
	"SHOPGUIDE_STEP_NAME",
	"SHOPGUIDE_STEP_BUY",
	"SHOPGUIDE_STEP_ENCHANT",
	"SHOPGUIDE_STEP_GEM",
	"SHOPGUIDE_STEP_OIL",
}

local win

local function L(k)
	return ns:L(k)
end

local function Build()
	local f = CreateFrame("Frame", "MidnightHelperShoppingGuide", UIParent, "BackdropTemplate")
	f:SetSize(WIDTH, 200)
	f:SetPoint("CENTER", UIParent, "CENTER", 260, 60)
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	if ns.ApplyMidnightDialogBackdrop then
		pcall(ns.ApplyMidnightDialogBackdrop, f)
	end
	tinsert(UISpecialFrames, "MidnightHelperShoppingGuide") -- Escape closes it

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -14)
	f.title:SetWidth(WIDTH - 60)
	f.title:SetJustifyH("LEFT")
	f.title:SetTextColor(1, 0.82, 0.2)

	f.intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.intro:SetWidth(WIDTH - 32)
	f.intro:SetJustifyH("LEFT")
	f.intro:SetWordWrap(true)
	f.intro:SetTextColor(0.62, 0.6, 0.56)

	f.steps = {}
	for i = 1, #STEPS do
		local num = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		num:SetTextColor(1, 0.82, 0.2)
		num:SetWidth(22)
		num:SetJustifyH("RIGHT")
		local fs = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		fs:SetWidth(WIDTH - 32 - 30)
		fs:SetJustifyH("LEFT")
		fs:SetWordWrap(true)
		f.steps[i] = { num = num, fs = fs }
	end

	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.foot:SetWidth(WIDTH - 32)
	f.foot:SetJustifyH("LEFT")
	f.foot:SetWordWrap(true)

	-- The same steps with pictures on midnighthelper.com/shopping/ (site chat, 25 Oct 2026: live in 8 languages,
	-- sections #buy, #use, #sockets). An addon cannot open a browser: the link opens the copy box.
	f.site = CreateFrame("Button", nil, f)
	f.site.fs = f.site:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.site.fs:SetPoint("TOPLEFT")
	f.site.fs:SetWidth(WIDTH - 32)
	f.site.fs:SetJustifyH("LEFT")
	f.site.fs:SetTextColor(0.45, 0.75, 1)
	f.site:SetScript("OnEnter", function(self)
		self.fs:SetTextColor(1, 1, 1)
	end)
	f.site:SetScript("OnLeave", function(self)
		self.fs:SetTextColor(0.45, 0.75, 1)
	end)
	f.site:SetScript("OnClick", function()
		if ns.ShowSiteLink and ns.MHSiteURL then
			ns.ShowSiteLink(ns.MHSiteURL("shopping/"), "SHOPGUIDE_SITE_TITLE")
		end
	end)

	f:Hide()
	return f
end

local function Layout()
	win.title:SetText(L("SHOPGUIDE_TITLE"))
	local y = -14 - win.title:GetStringHeight() - 8
	win.intro:SetText(L("SHOPGUIDE_INTRO"))
	win.intro:ClearAllPoints()
	win.intro:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y)
	y = y - win.intro:GetStringHeight() - 12
	for i, key in ipairs(STEPS) do
		local s = win.steps[i]
		local text = L(key)
		if key == "SHOPGUIDE_STEP_TWO_ROWS_FMT" then
			text = text:format(SILVER, GOLD)
		end
		s.num:SetText(i)
		s.num:ClearAllPoints()
		s.num:SetPoint("TOPLEFT", win, "TOPLEFT", 10, y + 2)
		s.fs:SetText(text)
		s.fs:ClearAllPoints()
		s.fs:SetPoint("TOPLEFT", win, "TOPLEFT", 16 + 30, y)
		y = y - math.max(18, s.fs:GetStringHeight()) - 10
	end
	win.foot:SetText(L("SHOPGUIDE_FOOT"))
	win.foot:ClearAllPoints()
	win.foot:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y)
	y = y - win.foot:GetStringHeight() - 8
	win.site.fs:SetText(L("SHOPGUIDE_SITE_LINK"))
	win.site:SetSize(WIDTH - 32, win.site.fs:GetStringHeight() + 2)
	win.site:ClearAllPoints()
	win.site:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y)
	y = y - win.site:GetHeight() - 16
	win:SetHeight(-y)
end

--- Open (or close, when already open) the step-by-step guide.
function ns.ShowShoppingGuide()
	win = win or Build()
	if win:IsShown() then
		win:Hide()
		return
	end
	Layout()
	win:Show()
end
