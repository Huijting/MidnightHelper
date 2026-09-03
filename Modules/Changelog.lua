local addonName, ns = ...

local changelogFrame

local CHANGELOG_ENTRIES = {
	{
		version = "3.7.3",
		lines = {
			"CHANGELOG_373_1",
			"CHANGELOG_373_2",
			"CHANGELOG_373_3",
			"CHANGELOG_373_4",
			"CHANGELOG_373_5",
			"CHANGELOG_373_6",
		},
	},
	{
		version = "3.7.2",
		lines = {
			"CHANGELOG_372_1",
			"CHANGELOG_372_2",
			"CHANGELOG_372_3",
			"CHANGELOG_372_4",
			"CHANGELOG_372_5",
		},
	},
	{
		version = "3.7.0",
		lines = {
			"CHANGELOG_370_1",
			"CHANGELOG_370_2",
			"CHANGELOG_370_3",
			"CHANGELOG_370_4",
			"CHANGELOG_370_5",
		},
	},
	{
		version = "3.6.0",
		lines = {
			"CHANGELOG_360_1",
			"CHANGELOG_360_2",
			"CHANGELOG_360_3",
			"CHANGELOG_360_4",
			"CHANGELOG_360_5",
			"CHANGELOG_360_6",
			"CHANGELOG_360_7",
			"CHANGELOG_360_8",
			"CHANGELOG_360_9",
			"CHANGELOG_360_10",
		},
	},
	{
		version = "3.5.0",
		lines = {
			"CHANGELOG_350_1",
			"CHANGELOG_350_2",
			"CHANGELOG_350_3",
			"CHANGELOG_350_4",
			"CHANGELOG_350_5",
			"CHANGELOG_350_6",
			"CHANGELOG_350_7",
			"CHANGELOG_350_8",
			"CHANGELOG_350_9",
			"CHANGELOG_350_10",
		},
	},
	{
		version = "3.4.0",
		lines = {
			"CHANGELOG_340_1",
			"CHANGELOG_340_2",
			"CHANGELOG_340_3",
			"CHANGELOG_340_4",
			"CHANGELOG_340_5",
			"CHANGELOG_340_6",
			"CHANGELOG_340_7",
			"CHANGELOG_340_8",
		},
	},
	{
		version = "3.3.0",
		lines = {
			"CHANGELOG_330_1",
			"CHANGELOG_330_2",
			"CHANGELOG_330_3",
			"CHANGELOG_330_4",
			"CHANGELOG_330_5",
			"CHANGELOG_330_6",
		},
	},
	{
		version = "3.2.0",
		lines = {
			"CHANGELOG_320_1",
			"CHANGELOG_320_2",
			"CHANGELOG_320_3",
			"CHANGELOG_320_4",
			"CHANGELOG_320_5",
			"CHANGELOG_320_6",
		},
	},
	{
		version = "3.1.0",
		lines = {
			"CHANGELOG_310_1",
			"CHANGELOG_310_2",
			"CHANGELOG_310_3",
			"CHANGELOG_310_4",
			"CHANGELOG_310_5",
			"CHANGELOG_310_6",
		},
	},
	{
		version = "3.0.0",
		lines = {
			"CHANGELOG_300_1",
			"CHANGELOG_300_2",
			"CHANGELOG_300_3",
			"CHANGELOG_300_4",
			"CHANGELOG_300_5",
			"CHANGELOG_300_6",
		},
	},
	{
		version = "2.18.0",
		lines = {
			"CHANGELOG_2180_1",
			"CHANGELOG_2180_2",
			"CHANGELOG_2180_3",
			"CHANGELOG_2180_4",
			"CHANGELOG_2180_5",
			"CHANGELOG_2180_6",
		},
	},
	{
		version = "2.17.0",
		lines = {
			"CHANGELOG_2170_1",
			"CHANGELOG_2170_2",
			"CHANGELOG_2170_3",
			"CHANGELOG_2170_4",
			"CHANGELOG_2170_5",
			"CHANGELOG_2170_6",
		},
	},
	{
		version = "2.16.0",
		lines = {
			"CHANGELOG_2160_1",
			"CHANGELOG_2160_2",
			"CHANGELOG_2160_3",
			"CHANGELOG_2160_4",
			"CHANGELOG_2160_5",
			"CHANGELOG_2160_6",
		},
	},
	{
		version = "2.15.0",
		lines = {
			"CHANGELOG_2150_1",
			"CHANGELOG_2150_2",
			"CHANGELOG_2150_3",
			"CHANGELOG_2150_4",
			"CHANGELOG_2150_5",
			"CHANGELOG_2150_6",
			"CHANGELOG_2150_7",
			"CHANGELOG_2150_8",
		},
	},
	{
		version = "2.14.0",
		lines = {
			"CHANGELOG_2140_1",
			"CHANGELOG_2140_2",
			"CHANGELOG_2140_3",
			"CHANGELOG_2140_4",
			"CHANGELOG_2140_5",
			"CHANGELOG_2140_6",
			"CHANGELOG_2140_7",
			"CHANGELOG_2140_8",
			"CHANGELOG_2140_9",
		},
	},
	{
		version = "2.13.0",
		lines = {
			"CHANGELOG_2130_1",
			"CHANGELOG_2130_2",
			"CHANGELOG_2130_3",
			"CHANGELOG_2130_4",
			"CHANGELOG_2130_5",
			"CHANGELOG_2130_6",
			"CHANGELOG_2130_7",
		},
	},
	{
		version = "2.12.0",
		lines = {
			"CHANGELOG_2120_1",
			"CHANGELOG_2120_2",
			"CHANGELOG_2120_3",
			"CHANGELOG_2120_4",
			"CHANGELOG_2120_5",
		},
	},
	{
		version = "2.11.1",
		lines = {
			"CHANGELOG_2111_1",
		},
	},
	{
		version = "2.11.0",
		lines = {
			"CHANGELOG_2110_1",
			"CHANGELOG_2110_2",
			"CHANGELOG_2110_3",
			"CHANGELOG_2110_4",
			"CHANGELOG_2110_5",
			"CHANGELOG_2110_6",
			"CHANGELOG_2110_7",
		},
	},
	{
		version = "2.10.0",
		lines = {
			"CHANGELOG_2100_1",
			"CHANGELOG_2100_2",
			"CHANGELOG_2100_3",
			"CHANGELOG_2100_4",
			"CHANGELOG_2100_5",
			"CHANGELOG_2100_6",
		},
	},
	{
		version = "2.9.0",
		lines = {
			"CHANGELOG_290_1",
			"CHANGELOG_290_2",
			"CHANGELOG_290_3",
			"CHANGELOG_290_4",
			"CHANGELOG_290_5",
			"CHANGELOG_290_6",
			"CHANGELOG_290_7",
		},
	},
	{
		version = "2.8.4",
		lines = {
			"CHANGELOG_284_1",
			"CHANGELOG_284_2",
			"CHANGELOG_284_3",
			"CHANGELOG_284_4",
			"CHANGELOG_284_5",
		},
	},
	{
		version = "2.8.3",
		lines = {
			"CHANGELOG_283_1",
			"CHANGELOG_283_2",
			"CHANGELOG_283_3",
		},
	},
	{
		version = "2.8.2",
		lines = {
			"CHANGELOG_282_1",
			"CHANGELOG_282_2",
			"CHANGELOG_282_3",
			"CHANGELOG_282_4",
			"CHANGELOG_282_5",
			"CHANGELOG_282_6",
			"CHANGELOG_282_7",
		},
	},
	{
		version = "2.8.1",
		lines = {
			"CHANGELOG_281_1",
			"CHANGELOG_281_2",
			"CHANGELOG_281_3",
			"CHANGELOG_281_4",
			"CHANGELOG_281_5",
			"CHANGELOG_281_6",
		},
	},
	{
		version = "2.8.0",
		lines = {
			"CHANGELOG_280_1",
			"CHANGELOG_280_2",
			"CHANGELOG_280_3",
			"CHANGELOG_280_4",
			"CHANGELOG_280_5",
			"CHANGELOG_280_6",
			"CHANGELOG_280_7",
			"CHANGELOG_280_8",
			"CHANGELOG_280_9",
		},
	},
	{
		version = "2.7.0",
		lines = {
			"CHANGELOG_270_1",
			"CHANGELOG_270_2",
			"CHANGELOG_270_3",
			"CHANGELOG_270_4",
			"CHANGELOG_270_5",
			"CHANGELOG_270_6",
			"CHANGELOG_270_7",
		},
	},
	{
		version = "2.6.0",
		lines = {
			"CHANGELOG_260_1",
			"CHANGELOG_260_2",
			"CHANGELOG_260_3",
			"CHANGELOG_260_4",
			"CHANGELOG_260_5",
			"CHANGELOG_260_6",
			"CHANGELOG_260_7",
		},
	},
	{
		version = "2.5.0",
		lines = {
			"CHANGELOG_250_1",
			"CHANGELOG_250_2",
			"CHANGELOG_250_3",
			"CHANGELOG_250_4",
			"CHANGELOG_250_5",
			"CHANGELOG_250_6",
			"CHANGELOG_250_7",
		},
	},
	{
		version = "2.4.1",
		lines = {
			"CHANGELOG_241_1",
			"CHANGELOG_241_2",
			"CHANGELOG_241_3",
			"CHANGELOG_241_4",
		},
	},
	{
		version = "2.4.0",
		lines = {
			"CHANGELOG_240_1",
			"CHANGELOG_240_2",
			"CHANGELOG_240_3",
		},
	},
	{
		version = "2.3.1",
		lines = {
			"CHANGELOG_231_1",
		},
	},
	{
		version = "2.3.0",
		lines = {
			"CHANGELOG_230_1",
			"CHANGELOG_230_2",
			"CHANGELOG_230_3",
			"CHANGELOG_230_4",
			"CHANGELOG_230_5",
			"CHANGELOG_230_6",
			"CHANGELOG_230_7",
		},
	},
	{
		version = "2.2.0",
		lines = {
			"CHANGELOG_220_1",
			"CHANGELOG_220_2",
			"CHANGELOG_220_3",
			"CHANGELOG_220_4",
		},
	},
	{
		version = "2.1.1",
		lines = {
			"CHANGELOG_211_1",
			"CHANGELOG_211_2",
			"CHANGELOG_211_3",
			"CHANGELOG_211_4",
			"CHANGELOG_211_5",
			"CHANGELOG_211_6",
			"CHANGELOG_211_7",
		},
	},
	{
		version = "2.1.0",
		lines = {
			"CHANGELOG_210_1",
			"CHANGELOG_210_2",
			"CHANGELOG_210_3",
			"CHANGELOG_210_4",
			"CHANGELOG_210_5",
			"CHANGELOG_210_6",
			"CHANGELOG_210_7",
		},
	},
	{
		version = "2.0.0",
		lines = {
			"CHANGELOG_200_1",
			"CHANGELOG_200_2",
			"CHANGELOG_200_3",
			"CHANGELOG_200_4",
			"CHANGELOG_200_5",
			"CHANGELOG_200_6",
			"CHANGELOG_200_7",
			"CHANGELOG_200_8",
			"CHANGELOG_200_9",
			"CHANGELOG_200_10",
		},
	},
	{
		version = "1.8.6",
		lines = {
			"CHANGELOG_186_1",
			"CHANGELOG_186_2",
		},
	},
	{
		version = "1.8.5",
		lines = {
			"CHANGELOG_185_1",
			"CHANGELOG_185_2",
			"CHANGELOG_185_3",
			"CHANGELOG_185_4",
			"CHANGELOG_185_5",
			"CHANGELOG_185_6",
		},
	},
	{
		version = "1.8.4",
		lines = {
			"CHANGELOG_184_1",
			"CHANGELOG_184_2",
			"CHANGELOG_184_3",
			"CHANGELOG_184_4",
			"CHANGELOG_184_5",
			"CHANGELOG_184_6",
			"CHANGELOG_184_7",
		},
	},
	{
		version = "1.8.3",
		lines = {
			"CHANGELOG_183_1",
			"CHANGELOG_183_2",
			"CHANGELOG_183_3",
			"CHANGELOG_183_4",
			"CHANGELOG_183_5",
			"CHANGELOG_183_6",
			"CHANGELOG_183_7",
			"CHANGELOG_183_8",
			"CHANGELOG_183_9",
			"CHANGELOG_183_10",
		},
	},
	{
		version = "1.8.2",
		lines = {
			"CHANGELOG_182_4",
			"CHANGELOG_182_1",
			"CHANGELOG_182_2",
			"CHANGELOG_182_5",
			"CHANGELOG_182_3",
		},
	},
	{
		version = "1.8.1",
		lines = {
			"CHANGELOG_181_1",
			"CHANGELOG_181_2",
			"CHANGELOG_181_3",
			"CHANGELOG_181_4",
			"CHANGELOG_181_5",
			"CHANGELOG_181_6",
		},
	},
	{
		version = "1.8.0",
		lines = {
			"CHANGELOG_180_1",
			"CHANGELOG_180_2",
			"CHANGELOG_180_3",
			"CHANGELOG_180_4",
			"CHANGELOG_180_5",
		},
	},
	{
		version = "1.7.1",
		lines = {
			"CHANGELOG_171_1",
		},
	},
	{
		version = "1.7.0",
		lines = {
			"CHANGELOG_170_1",
			"CHANGELOG_170_2",
			"CHANGELOG_170_3",
		},
	},
	{
		version = "1.6.0",
		lines = {
			"CHANGELOG_160_1",
			"CHANGELOG_160_2",
			"CHANGELOG_160_3",
		},
	},
	{
		version = "1.5.5",
		lines = {
			"CHANGELOG_155_1",
		},
	},
	{
		version = "1.5.4",
		lines = {
			"CHANGELOG_154_1",
		},
	},
	{
		version = "1.5.3",
		lines = {
			"CHANGELOG_153_1",
			"CHANGELOG_153_2",
			"CHANGELOG_153_3",
		},
	},
	{
		version = "1.5.2",
		lines = {
			"CHANGELOG_152_1",
			"CHANGELOG_152_2",
		},
	},
	{
		version = "1.5.1",
		lines = {
			"CHANGELOG_151_1",
			"CHANGELOG_151_2",
			"CHANGELOG_151_3",
			"CHANGELOG_151_4",
			"CHANGELOG_151_5",
			"CHANGELOG_151_6",
		},
	},
	{
		version = "1.5.0",
		lines = {
			"CHANGELOG_150_1",
			"CHANGELOG_150_2",
			"CHANGELOG_150_3",
			"CHANGELOG_150_4",
			"CHANGELOG_150_5",
			"CHANGELOG_150_6",
		},
	},
	{
		version = "1.4.0",
		lines = {
			"CHANGELOG_140_1",
			"CHANGELOG_140_2",
			"CHANGELOG_140_3",
			"CHANGELOG_140_4",
			"CHANGELOG_140_5",
		},
	},
	{
		version = "1.3.0",
		lines = {
			"CHANGELOG_130_1",
			"CHANGELOG_130_2",
			"CHANGELOG_130_3",
			"CHANGELOG_130_4",
			"CHANGELOG_130_5",
			"CHANGELOG_130_6",
		},
	},
	{
		version = "1.2.6",
		lines = {
			"CHANGELOG_126_1",
			"CHANGELOG_126_2",
			"CHANGELOG_126_3",
			"CHANGELOG_126_4",
			"CHANGELOG_126_5",
		},
	},
	{
		version = "1.2.5",
		lines = {
			"CHANGELOG_125_1",
			"CHANGELOG_125_2",
			"CHANGELOG_125_3",
		},
	},
	{
		version = "1.2.4",
		lines = {
			"CHANGELOG_124_1",
			"CHANGELOG_124_2",
			"CHANGELOG_124_3",
			"CHANGELOG_124_4",
		},
	},
	{
		version = "1.2.3",
		lines = {
			"CHANGELOG_123_1",
			"CHANGELOG_123_2",
			"CHANGELOG_123_3",
			"CHANGELOG_123_4",
		},
	},
	{
		version = "1.2.2",
		lines = {
			"CHANGELOG_122_1",
			"CHANGELOG_122_2",
			"CHANGELOG_122_3",
			"CHANGELOG_122_4",
			"CHANGELOG_122_5",
		},
	},
	{
		version = "1.2.1",
		lines = {
			"CHANGELOG_121_1",
			"CHANGELOG_121_2",
			"CHANGELOG_121_3",
		},
	},
	{
		version = "1.2.0",
		lines = {
			"CHANGELOG_120_1",
			"CHANGELOG_120_2",
			"CHANGELOG_120_3",
			"CHANGELOG_120_4",
		},
	},
}

local function GetAddonVersion()
	if ns.GetAddonVersion then
		return ns.GetAddonVersion()
	end
	return "0.0.0"
end

-- Gold section headers + white bullets (Blizzard-style hierarchy).
local COLOR_SECTION = "|cffffcc00"
local COLOR_BULLET = "|cffffffff"

local function BuildChangelogBodyText()
	local blocks = {}
	for i = 1, #CHANGELOG_ENTRIES do
		local e = CHANGELOG_ENTRIES[i]
		local head = COLOR_SECTION .. ns:L("CHANGELOG_VERSION_FMT"):format(e.version) .. ":|r"
		local lines = { head }
		for j = 1, #(e.lines or {}) do
			local lineKey = e.lines[j]
			local lineText = (ns.SafeL and ns:SafeL(lineKey)) or ns:L(lineKey)
			lines[#lines + 1] = COLOR_BULLET .. "- " .. lineText .. "|r"
		end
		blocks[#blocks + 1] = table.concat(lines, "\n")
	end
	return table.concat(blocks, "\n\n")
end

-- 🔴 THE FOOTER RESERVATION WAS A CONSTANT AND THE FOOTER IS NOT. Rob, 3 Sep 2026, from
-- a screenshot: the changelog body ran past the bottom edge and the last line had two
-- lines drawn on top of each other. The scroll frame reserved a hardcoded 100px --
-- "BOTTOMRIGHT, -44, 100" -- which fitted the two checkboxes exactly, and then Spec 31 B4
-- added a third element ABOVE them. At 480px wide that grey line wraps to two rows, the
-- stack needs about 120px, and the overflow is drawn straight over the changelog text.
--
-- 📌 It is the same mistake as Professions -> Overview, named in the test list the day
-- before as the thing to watch for -- and it still shipped, because the layout was only
-- ever checked with the strings that existed when the constant was written. A reserved
-- height is a promise about content nobody re-measures.
--
-- ⚠️ Measure the row, not the widget. A checkbox is a fixed 32px box, but its LABEL is a
-- wrapped font string beside it and can be taller -- and the labels are longest in exactly
-- the languages nobody here reads (deDE, nlNL). Take whichever is bigger per row.
local FOOTER_BOTTOM_PAD = 12
local FOOTER_GAP = 10

local function LayoutChangelogFooter(f)
	local scroll, cbVersion, cbNever, ask = f._scroll, f._cbVersion, f._cbNever, f._ask
	if not (scroll and cbVersion and cbNever and ask) then
		return
	end
	local function rowH(cb)
		local box = cb:GetHeight() or 0
		local label = (cb.text and cb.text:GetStringHeight()) or 0
		return math.max(box, label)
	end
	local h = FOOTER_BOTTOM_PAD
		+ rowH(cbVersion) + FOOTER_GAP
		+ rowH(cbNever) + 8
		+ (ask:GetStringHeight() or 0)
		+ FOOTER_GAP
	-- The close button shares the bottom row with the first checkbox; if it is ever the
	-- taller of the two, the reservation has to follow it instead.
	local btnH = (f._closeBtn and f._closeBtn:GetHeight()) or 0
	h = math.max(h, FOOTER_BOTTOM_PAD + btnH + FOOTER_GAP)
	f._footerH = h
	scroll:ClearAllPoints()
	scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -52)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -44, h)
end

local function LayoutChangelogScroll(f)
	local scroll = f._scroll
	local content = f._content
	local body = f._body
	if not scroll or not content or not body then
		return
	end
	local scrollW = scroll:GetWidth() or 600
	local textW = math.max(320, scrollW - 24)
	content:SetWidth(textW)
	body:SetWidth(textW - 8)
	body:SetText(BuildChangelogBodyText())
	local bodyH = body:GetStringHeight() or 1
	content:SetHeight(math.max(bodyH + 20, 40))
	if scroll.UpdateScrollChildRect then
		scroll:UpdateScrollChildRect()
	end
	if scroll.SetVerticalScroll then
		scroll:SetVerticalScroll(0)
	end
end

-- Order matters: the footer decides where the scroll frame ends, and the body wraps to
-- the scroll frame's width. Doing it the other way round measures the body against a
-- height that is about to change.
local function LayoutChangelogWindow(f)
	LayoutChangelogFooter(f)
	LayoutChangelogScroll(f)
end

local function EnsureChangelogFrame()
	if changelogFrame then
		return changelogFrame
	end

	local f = CreateFrame("Frame", "MidnightHelperChangelogFrame", UIParent, "BackdropTemplate")
	f:SetSize(680, 500)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	-- Blizzard ornate dialog chrome (stone tile + gold frame).
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(1, 1, 1, 0.92)
	f:SetBackdropBorderColor(1, 1, 1, 1)
	f:Hide()
	f:SetClampedToScreen(true)

	local title = f:CreateFontString(nil, "OVERLAY", "QuestFont_Large")
	title:SetPoint("TOP", f, "TOP", 0, -16)
	title:SetTextColor(1, 0.82, 0)
	title:SetText(ns:L("CHANGELOG_TITLE"))
	f._title = title

	local subtitle = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	subtitle:SetPoint("TOPLEFT", f, "TOPLEFT", 24, -18)
	if RED_FONT_COLOR and RED_FONT_COLOR.GetRGB then
		subtitle:SetTextColor(RED_FONT_COLOR:GetRGB())
	else
		subtitle:SetTextColor(1, 0.1, 0.1)
	end
	subtitle:SetText(ns:L("CHANGELOG_SUBTITLE"):format(GetAddonVersion()))
	f._subtitle = subtitle

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -6)
	close:SetScript("OnClick", function()
		f:Hide()
	end)

	-- Footer: stacked checkboxes (NL strings wrap) + close button — generous inset for multi-line labels.
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -52)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -44, 100)
	f._scroll = scroll

	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(600, 40)
	scroll:SetScrollChild(content)

	local body = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	body:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -4)
	body:SetJustifyH("LEFT")
	body:SetJustifyV("TOP")
	body:SetWordWrap(true)
	body:SetSpacing(4)
	f._body = body
	f._content = content
	-- Laid out below, once the footer exists — it is what decides where this ends.

	-- Labels wrap within left column so they never draw over the bottom-right close button.
	local FOOTER_TEXT_W = 480

	local cbVersion = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
	cbVersion:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 18, 12)
	cbVersion.text:SetText(ns:L("CHANGELOG_CB_UNTIL_NEXT"))
	cbVersion.text:SetTextColor(1, 0.85, 0.2)
	cbVersion.text:SetWidth(FOOTER_TEXT_W)
	cbVersion.text:SetJustifyH("LEFT")
	f._cbVersion = cbVersion

	--- Spec 31 B4. This window opens by itself on every version change, so everyone who
	--- updates reads it -- and until now it asked for nothing. It is the largest completely
	--- unused surface in the addon.
	---
	--- 📌 Deliberately NOT "join our Discord". The moment is one where the player is looking
	--- at a list of claims we just made, so the honest ask is whether any of it is wrong for
	--- them. That also follows Spec 31 B6's finding: the strongest thing we can ask for is
	--- the information we are missing, at the point where we admit we might be missing it.
	---
	--- ⚠️ It sits ABOVE the two checkboxes, which are already a permanent off switch, so
	--- anyone who does not want to be asked has had a way to stop it since 2.4.0.
	local ask = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	ask:SetWidth(FOOTER_TEXT_W)
	ask:SetJustifyH("LEFT")
	ask:SetText(ns:L("CHANGELOG_ASK"))
	f._ask = ask

	local cbNever = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
	cbNever:SetPoint("BOTTOMLEFT", cbVersion, "TOPLEFT", 0, 10)
	ask:SetPoint("BOTTOMLEFT", cbNever, "TOPLEFT", 4, 8)
	cbNever.text:SetText(ns:L("CHANGELOG_CB_NEVER"))
	cbNever.text:SetTextColor(1, 0.25, 0.21)
	cbNever.text:SetWidth(FOOTER_TEXT_W)
	cbNever.text:SetJustifyH("LEFT")
	f._cbNever = cbNever

	local okBtn
	do
		local ok = pcall(function()
			okBtn = CreateFrame("Button", nil, f, "UIPanelGoldButtonTemplate")
		end)
		if not ok or not okBtn then
			okBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		end
	end
	okBtn:SetSize(140, 28)
	okBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -18, 12)
	okBtn:SetText(ns:L("CHANGELOG_CLOSE"))
	f._closeBtn = okBtn

	LayoutChangelogWindow(f)

	cbVersion:SetScript("OnClick", function(self)
		if self:GetChecked() then
			cbNever:SetChecked(false)
		end
	end)
	cbNever:SetScript("OnClick", function(self)
		if self:GetChecked() then
			cbVersion:SetChecked(false)
		end
	end)
	f._closeBtn:SetScript("OnClick", function()
		local db = ns.db and ns.db.changelog
		if db then
			if cbNever:GetChecked() then
				db.hideForever = true
			elseif cbVersion:GetChecked() then
				db.lastSeenVersion = GetAddonVersion()
			end
		end
		f:Hide()
	end)

	f:SetScript("OnHide", function()
		cbVersion:SetChecked(false)
		cbNever:SetChecked(false)
	end)
	f:SetScript("OnShow", function()
		LayoutChangelogWindow(f)
	end)

	changelogFrame = f

	-- ESC behavior: add this frame to Blizzard's special-frame stack.
	if type(UISpecialFrames) ~= "table" then
		UISpecialFrames = {}
	end
	local found = false
	for i = 1, #UISpecialFrames do
		if UISpecialFrames[i] == "MidnightHelperChangelogFrame" then
			found = true
			break
		end
	end
	if not found then
		UISpecialFrames[#UISpecialFrames + 1] = "MidnightHelperChangelogFrame"
	end

	return f
end

function ns:ShowChangelogWindow(force)
	local db = self.db and self.db.changelog
	if not db then
		return
	end
	local version = GetAddonVersion()
	if not force then
		if db.hideForever then
			return
		end
		if db.lastSeenVersion == version then
			return
		end
	end

	local f = EnsureChangelogFrame()
	f._title:SetText(ns:L("CHANGELOG_TITLE"))
	f._subtitle:SetText(ns:L("CHANGELOG_SUBTITLE"):format(version))
	LayoutChangelogWindow(f)
	f:Show()
end

-- Dev-zelfcheck: waarschuw als de addon-versie nieuwer is dan het bovenste
-- changelog-blok (= changelog vergeten bij te werken bij een release). STIL voor
-- spelers; zet `MidnightHelperDB.changelogDevCheck = true` op een dev-install om
-- 'm te zien. Zo wordt een stale changelog (zoals 1.8.0 t/m 1.5.5) meteen gevangen.
local function DevChangelogStaleCheck()
	if not (MidnightHelperDB and MidnightHelperDB.changelogDevCheck) then
		return
	end
	local v = GetAddonVersion()
	local top = CHANGELOG_ENTRIES[1] and CHANGELOG_ENTRIES[1].version
	if top and v and v ~= "0.0.0" and top ~= v then
		print(("|cffff5555[MidnightHelper] Changelog achterloopt: addon %s, nieuwste regel %s — werk Modules/Changelog.lua + CHANGELOG_<ver>_* keys bij.|r"):format(tostring(v), tostring(top)))
	end
end

local boot = CreateFrame("Frame")
boot:RegisterEvent("PLAYER_ENTERING_WORLD")
boot:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	DevChangelogStaleCheck()
	if ns and ns.ShowChangelogWindow then
		ns:ShowChangelogWindow(false)
	end
end)
