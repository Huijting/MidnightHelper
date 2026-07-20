local addonName, ns = ...

local changelogFrame

local CHANGELOG_ENTRIES = {
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
