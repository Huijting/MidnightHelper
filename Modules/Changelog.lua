local addonName, ns = ...

local changelogFrame

local CHANGELOG_ENTRIES = {
	{
		version = "1.2.4",
		lines = {
			"CHANGELOG_124_1",
			"CHANGELOG_124_2",
			"CHANGELOG_124_3",
			"CHANGELOG_124_4",
			"CHANGELOG_124_5",
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
	if C_AddOns and C_AddOns.GetAddOnMetadata then
		local v = C_AddOns.GetAddOnMetadata(addonName, "Version")
		if type(v) == "string" and v ~= "" then
			return v
		end
	end
	if GetAddOnMetadata then
		local v = GetAddOnMetadata(addonName, "Version")
		if type(v) == "string" and v ~= "" then
			return v
		end
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
			lines[#lines + 1] = COLOR_BULLET .. "- " .. ns:L(e.lines[j]) .. "|r"
		end
		blocks[#blocks + 1] = table.concat(lines, "\n")
	end
	return table.concat(blocks, "\n\n")
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
	LayoutChangelogScroll(f)

	-- Labels wrap within left column so they never draw over the bottom-right close button.
	local FOOTER_TEXT_W = 480

	local cbVersion = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
	cbVersion:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 18, 12)
	cbVersion.text:SetText(ns:L("CHANGELOG_CB_UNTIL_NEXT"))
	cbVersion.text:SetTextColor(1, 0.85, 0.2)
	cbVersion.text:SetWidth(FOOTER_TEXT_W)
	cbVersion.text:SetJustifyH("LEFT")
	f._cbVersion = cbVersion

	local cbNever = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
	cbNever:SetPoint("BOTTOMLEFT", cbVersion, "TOPLEFT", 0, 10)
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
		LayoutChangelogScroll(f)
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
	LayoutChangelogScroll(f)
	f:Show()
end

local boot = CreateFrame("Frame")
boot:RegisterEvent("PLAYER_ENTERING_WORLD")
boot:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if ns and ns.ShowChangelogWindow then
		ns:ShowChangelogWindow(false)
	end
end)
