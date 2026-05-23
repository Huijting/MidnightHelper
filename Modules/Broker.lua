--[[
	Midnight Helper — LibDataBroker minimap launcher (embedded LibDBIcon-1.0).

	Load order: after UI.lua (needs ToggleMainWindow + RefreshLocaleUI).
]]

local addonName, ns = ...

local MINIMAP_ICON = "Interface\\AddOns\\MidnightHelper\\Media\\Platy1"
local settingsFrame
local settingsCategoryFrame
local settingsCategoryId

local function TintBtn(btn, active)
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

local function OnLanguageChosen(host, code)
	ns:SetLocale(code)
	if ns.RefreshGuideTabVisibility then
		ns:RefreshGuideTabVisibility()
	end
	if host and host._refresh then
		host:_refresh()
	end
end

local function RefreshLanguageButtonTints(host)
	if not host then
		return
	end
	local pref = ns.GetLocalePreferenceCode and ns:GetLocalePreferenceCode() or "enUS"
	local auto = ns.MH_LOCALE_AUTO or "auto"
	if host._langAuto then
		TintBtn(host._langAuto, pref == auto)
	end
	if host._langEn then
		TintBtn(host._langEn, pref == "enUS")
	end
	if host._langDe then
		TintBtn(host._langDe, pref == "deDE")
	end
	if host._langFr then
		TintBtn(host._langFr, pref == "frFR")
	end
	if host._langEs then
		TintBtn(host._langEs, pref == "esES")
	end
	if host._langNl then
		TintBtn(host._langNl, pref == "nlNL")
	end
end

local function EnsureSettingsFrame()
	if settingsFrame then
		return settingsFrame
	end

	local f = CreateFrame("Frame", "MidnightHelperQuickSettings", UIParent, "BackdropTemplate")
	f:SetSize(440, 350)
	f:SetFrameStrata("DIALOG")
	f:SetFrameLevel(2100)
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		})
		f:SetBackdropColor(0.08, 0.08, 0.10, 0.98)
		f:SetBackdropBorderColor(0.5, 0.42, 0.24, 0.95)
	end

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -10)
	title:SetPoint("TOPRIGHT", f, "TOPRIGHT", -34, -10)
	title:SetJustifyH("LEFT")
	f._title = title

	local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
	closeBtn:SetScript("OnClick", function()
		f:Hide()
	end)

	local langLabel = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	langLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -12)
	langLabel:SetTextColor(0.95, 0.9, 0.74)
	f._langLabel = langLabel

	local langAuto = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	langAuto:SetSize(96, 24)
	langAuto:SetPoint("TOPLEFT", langLabel, "BOTTOMLEFT", 0, -6)
	langAuto:SetScript("OnClick", function()
		OnLanguageChosen(f, ns.MH_LOCALE_AUTO or "auto")
	end)
	f._langAuto = langAuto

	local langEn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	langEn:SetSize(72, 24)
	langEn:SetPoint("LEFT", langAuto, "RIGHT", 6, 0)
	langEn:SetScript("OnClick", function()
		OnLanguageChosen(f, "enUS")
	end)
	f._langEn = langEn

	local langDe = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	langDe:SetSize(72, 24)
	langDe:SetPoint("LEFT", langEn, "RIGHT", 6, 0)
	langDe:SetScript("OnClick", function()
		OnLanguageChosen(f, "deDE")
	end)
	f._langDe = langDe

	local langFr = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	langFr:SetSize(72, 24)
	langFr:SetPoint("LEFT", langDe, "RIGHT", 6, 0)
	langFr:SetScript("OnClick", function()
		OnLanguageChosen(f, "frFR")
	end)
	f._langFr = langFr

	local langEs = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	langEs:SetSize(72, 24)
	langEs:SetPoint("TOPLEFT", langAuto, "BOTTOMLEFT", 0, -6)
	langEs:SetScript("OnClick", function()
		OnLanguageChosen(f, "esES")
	end)
	f._langEs = langEs

	local langNl = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	langNl:SetSize(88, 24)
	langNl:SetPoint("LEFT", langEs, "RIGHT", 6, 0)
	langNl:SetScript("OnClick", function()
		OnLanguageChosen(f, "nlNL")
	end)
	f._langNl = langNl

	local langHint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	langHint:SetPoint("TOPLEFT", langNl, "BOTTOMLEFT", 0, -6)
	langHint:SetPoint("RIGHT", f, "RIGHT", -12, 0)
	langHint:SetJustifyH("LEFT")
	langHint:SetWordWrap(true)
	langHint:SetTextColor(0.72, 0.74, 0.78)
	f._langHint = langHint

	local guideLabel = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	guideLabel:SetPoint("TOPLEFT", langHint, "BOTTOMLEFT", 0, -10)
	guideLabel:SetTextColor(0.95, 0.9, 0.74)
	f._guideLabel = guideLabel

	local modeAuto = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	modeAuto:SetSize(104, 24)
	modeAuto:SetPoint("TOPLEFT", guideLabel, "BOTTOMLEFT", 0, -6)
	modeAuto:SetScript("OnClick", function()
		ns:SetGuideVisibilityMode("auto")
		if f._refresh then
			f:_refresh()
		end
	end)
	f._modeAuto = modeAuto

	local modeAlways = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	modeAlways:SetSize(104, 24)
	modeAlways:SetPoint("LEFT", modeAuto, "RIGHT", 8, 0)
	modeAlways:SetScript("OnClick", function()
		ns:SetGuideVisibilityMode("always")
		if f._refresh then
			f:_refresh()
		end
	end)
	f._modeAlways = modeAlways

	local modeHidden = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	modeHidden:SetSize(104, 24)
	modeHidden:SetPoint("LEFT", modeAlways, "RIGHT", 8, 0)
	modeHidden:SetScript("OnClick", function()
		ns:SetGuideVisibilityMode("hidden")
		if f._refresh then
			f:_refresh()
		end
	end)
	f._modeHidden = modeHidden

	local hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	hint:SetPoint("TOPLEFT", modeAuto, "BOTTOMLEFT", 0, -12)
	hint:SetPoint("RIGHT", f, "RIGHT", -12, 0)
	hint:SetJustifyH("LEFT")
	hint:SetWordWrap(true)
	hint:SetTextColor(0.82, 0.8, 0.74)
	f._hint = hint

	local vaultLabel = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	vaultLabel:SetPoint("TOPLEFT", hint, "BOTTOMLEFT", 0, -14)
	vaultLabel:SetTextColor(0.95, 0.9, 0.74)
	f._vaultLabel = vaultLabel

	local function MakeVaultChk(parent, anchor, offsetY, key)
		local chk = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
		chk:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", -2, offsetY)
		chk:SetScript("OnClick", function(self)
			if ns.SetVaultReminderOption then
				ns.SetVaultReminderOption(key, self:GetChecked())
			end
			if parent._refresh then
				parent:_refresh()
			end
		end)
		local txt = chk.text or _G[chk:GetName() .. "Text"]
		chk._text = txt
		return chk
	end

	f._vaultEnabled = MakeVaultChk(f, vaultLabel, -6, "enabled")
	f._vaultChat = MakeVaultChk(f, f._vaultEnabled, -4, "chat")
	f._vaultMinimap = MakeVaultChk(f, f._vaultChat, -4, "minimap")
	f._vaultPing = MakeVaultChk(f, f._vaultMinimap, -4, "ping")

	function f:_refresh()
		self._title:SetText(ns:L("SETTINGS_TITLE"))
		self._langLabel:SetText(ns:L("SETTINGS_LANGUAGE_LABEL"))
		if self._langAuto then
			self._langAuto:SetText(ns:L("LOCALE_NAME_AUTO"))
		end
		if self._langEn then
			self._langEn:SetText(ns:L("LOCALE_NAME_EN"))
		end
		if self._langDe then
			self._langDe:SetText(ns:L("LOCALE_NAME_deDE"))
		end
		if self._langFr then
			self._langFr:SetText(ns:L("LOCALE_NAME_frFR"))
		end
		if self._langEs then
			self._langEs:SetText(ns:L("LOCALE_NAME_esES"))
		end
		if self._langNl then
			self._langNl:SetText(ns:L("LOCALE_NAME_NL"))
		end
		if self._langHint then
			self._langHint:SetText(ns:L("LOCALE_AUTO_HINT"))
		end
		self._guideLabel:SetText(ns:L("SETTINGS_GUIDE_LABEL"))
		self._modeAuto:SetText(ns:L("SETTINGS_GUIDE_MODE_AUTO"))
		self._modeAlways:SetText(ns:L("SETTINGS_GUIDE_MODE_ALWAYS"))
		self._modeHidden:SetText(ns:L("SETTINGS_GUIDE_MODE_HIDDEN"))
		self._hint:SetText(ns:L("SETTINGS_HINT"))
		self._vaultLabel:SetText(ns:L("SETTINGS_VAULT_REMINDER_LABEL"))
		local vaultKeys = {
			{ chk = self._vaultEnabled, key = "enabled", loc = "SETTINGS_VAULT_REMINDER_ENABLED" },
			{ chk = self._vaultChat, key = "chat", loc = "SETTINGS_VAULT_REMINDER_CHAT" },
			{ chk = self._vaultMinimap, key = "minimap", loc = "SETTINGS_VAULT_REMINDER_MINIMAP" },
			{ chk = self._vaultPing, key = "ping", loc = "SETTINGS_VAULT_REMINDER_PING" },
		}
		local vs = ns.GetVaultReminderSettings and ns.GetVaultReminderSettings() or {}
		for _, row in ipairs(vaultKeys) do
			if row.chk then
				row.chk:SetChecked(vs[row.key] ~= false)
				if row.chk._text and row.chk._text.SetText then
					row.chk._text:SetText(ns:L(row.loc))
					if row.chk._text.SetTextColor then
						row.chk._text:SetTextColor(0.95, 0.9, 0.74)
					end
				end
			end
		end

		RefreshLanguageButtonTints(self)

		local mode = ns:GetGuideVisibilityMode()
		TintBtn(self._modeAuto, mode == "auto")
		TintBtn(self._modeAlways, mode == "always")
		TintBtn(self._modeHidden, mode == "hidden")
	end

	f:SetScript("OnShow", function(self)
		self:_refresh()
	end)
	f:Hide()
	tinsert(UISpecialFrames, "MidnightHelperQuickSettings")
	settingsFrame = f
	return f
end

function ns:ToggleQuickSettings(anchor)
	local f = EnsureSettingsFrame()
	if f:IsShown() then
		f:Hide()
		return
	end
	f:ClearAllPoints()
	if anchor and anchor.GetCenter then
		local x, y = anchor:GetCenter()
		if x and y then
			f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x - 160, y - 10)
		else
			f:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
		end
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
	end
	f:Show()
	f:Raise()
end

local function EnsureSettingsCategoryFrame()
	if settingsCategoryFrame then
		return settingsCategoryFrame
	end

	local panel = CreateFrame("Frame", "MidnightHelperSettingsCategoryPanel", UIParent)
	panel.name = ns:L("MAIN_TITLE")
	panel:Hide()

	local headerBg = panel:CreateTexture(nil, "BACKGROUND")
	headerBg:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -4)
	headerBg:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, -4)
	headerBg:SetHeight(72)
	headerBg:SetColorTexture(0.09, 0.09, 0.11, 0.72)

	local icon = panel:CreateTexture(nil, "ARTWORK")
	icon:SetSize(28, 28)
	icon:SetPoint("TOPLEFT", 16, -18)
	icon:SetTexture(MINIMAP_ICON)
	panel._icon = icon

	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("LEFT", icon, "RIGHT", 8, 4)
	panel._title = title

	local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetTextColor(0.82, 0.8, 0.74)
	panel._subtitle = subtitle

	local status = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	status:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -6)
	status:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
	status:SetJustifyH("LEFT")
	status:SetWordWrap(true)
	status:SetTextColor(0.95, 0.9, 0.74)
	panel._status = status

	local line = panel:CreateTexture(nil, "ARTWORK")
	line:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -102)
	line:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, -102)
	line:SetHeight(1)
	line:SetColorTexture(0.45, 0.40, 0.30, 0.75)

	local generalLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	generalLabel:SetPoint("TOPLEFT", line, "BOTTOMLEFT", 0, -10)
	panel._generalLabel = generalLabel

	local generalBox = CreateFrame("Frame", nil, panel, "BackdropTemplate")
	generalBox:SetPoint("TOPLEFT", generalLabel, "TOPLEFT", -8, 16)
	generalBox:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, 16)
	generalBox:SetHeight(96)
	if generalBox.SetBackdrop then
		generalBox:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		})
		generalBox:SetBackdropColor(0.08, 0.08, 0.1, 0.35)
		generalBox:SetBackdropBorderColor(0.45, 0.40, 0.30, 0.45)
	end
	generalBox:SetFrameLevel(panel:GetFrameLevel() + 1)
	generalLabel:SetDrawLayer("ARTWORK", 1)
	panel._generalBox = generalBox

	local openOnLogin = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
	openOnLogin:SetPoint("TOPLEFT", generalLabel, "BOTTOMLEFT", -2, -6)
	openOnLogin:SetScript("OnClick", function(self)
		if ns.db and ns.db.ui then
			ns.db.ui.openOnLogin = self:GetChecked() and true or false
		end
	end)
	panel._openOnLogin = openOnLogin
	local openOnLoginText = openOnLogin.text or _G[openOnLogin:GetName() .. "Text"]
	panel._openOnLoginText = openOnLoginText

	local compactMode = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
	compactMode:SetPoint("TOPLEFT", openOnLogin, "BOTTOMLEFT", 0, -4)
	compactMode:SetScript("OnClick", function(self)
		if ns.SetCompactModeEnabled then
			ns:SetCompactModeEnabled(self:GetChecked(), true)
		end
		if panel._refresh then
			panel:_refresh()
		end
	end)
	panel._compactMode = compactMode
	local compactModeText = compactMode.text or _G[compactMode:GetName() .. "Text"]
	panel._compactModeText = compactModeText

	local openMain = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	openMain:SetSize(152, 24)
	openMain:SetPoint("TOPLEFT", compactMode, "BOTTOMLEFT", 4, -8)
	openMain:SetScript("OnClick", function()
		if ns.ShowMainUI then
			ns:ShowMainUI()
		end
	end)
	panel._openMain = openMain

	local reset = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	reset:SetSize(152, 24)
	reset:SetPoint("LEFT", openMain, "RIGHT", 8, 0)
	reset:SetScript("OnClick", function()
		ns:SetLocale(ns.MH_LOCALE_AUTO or "auto", true)
		ns:SetGuideVisibilityMode("auto", true)
		if ns.SetCompactModeEnabled then
			ns:SetCompactModeEnabled(false, true)
		end
		if ns.db and ns.db.ui then
			ns.db.ui.openOnLogin = false
		end
		if ns.RefreshGuideTabVisibility then
			ns:RefreshGuideTabVisibility()
		end
		if panel._refresh then
			panel:_refresh()
		end
	end)
	panel._reset = reset

	local langLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	langLabel:SetPoint("TOPLEFT", openMain, "BOTTOMLEFT", -4, -14)
	panel._langLabel = langLabel

	local languageBox = CreateFrame("Frame", nil, panel, "BackdropTemplate")
	languageBox:SetPoint("TOPLEFT", langLabel, "TOPLEFT", -8, 16)
	languageBox:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, 16)
	languageBox:SetHeight(108)
	if languageBox.SetBackdrop then
		languageBox:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		})
		languageBox:SetBackdropColor(0.08, 0.08, 0.1, 0.3)
		languageBox:SetBackdropBorderColor(0.45, 0.40, 0.30, 0.4)
	end
	languageBox:SetFrameLevel(panel:GetFrameLevel() + 1)
	langLabel:SetDrawLayer("ARTWORK", 1)
	panel._languageBox = languageBox

	local langAuto = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	langAuto:SetSize(108, 24)
	langAuto:SetPoint("TOPLEFT", langLabel, "BOTTOMLEFT", 0, -8)
	langAuto:SetScript("OnClick", function()
		OnLanguageChosen(panel, ns.MH_LOCALE_AUTO or "auto")
	end)
	panel._langAuto = langAuto

	local langEn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	langEn:SetSize(88, 24)
	langEn:SetPoint("LEFT", langAuto, "RIGHT", 6, 0)
	langEn:SetScript("OnClick", function()
		OnLanguageChosen(panel, "enUS")
	end)
	panel._langEn = langEn

	local langDe = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	langDe:SetSize(88, 24)
	langDe:SetPoint("LEFT", langEn, "RIGHT", 6, 0)
	langDe:SetScript("OnClick", function()
		OnLanguageChosen(panel, "deDE")
	end)
	panel._langDe = langDe

	local langFr = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	langFr:SetSize(88, 24)
	langFr:SetPoint("LEFT", langDe, "RIGHT", 6, 0)
	langFr:SetScript("OnClick", function()
		OnLanguageChosen(panel, "frFR")
	end)
	panel._langFr = langFr

	local langEs = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	langEs:SetSize(88, 24)
	langEs:SetPoint("TOPLEFT", langAuto, "BOTTOMLEFT", 0, -8)
	langEs:SetScript("OnClick", function()
		OnLanguageChosen(panel, "esES")
	end)
	panel._langEs = langEs

	local langNl = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	langNl:SetSize(96, 24)
	langNl:SetPoint("LEFT", langEs, "RIGHT", 6, 0)
	langNl:SetScript("OnClick", function()
		OnLanguageChosen(panel, "nlNL")
	end)
	panel._langNl = langNl

	local langHint = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	langHint:SetPoint("TOPLEFT", langNl, "BOTTOMLEFT", 0, -6)
	langHint:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
	langHint:SetJustifyH("LEFT")
	langHint:SetWordWrap(true)
	langHint:SetTextColor(0.72, 0.74, 0.78)
	panel._langHint = langHint

	local guideLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	guideLabel:SetPoint("TOPLEFT", langHint, "BOTTOMLEFT", 0, -10)
	panel._guideLabel = guideLabel

	local guideBox = CreateFrame("Frame", nil, panel, "BackdropTemplate")
	guideBox:SetPoint("TOPLEFT", guideLabel, "TOPLEFT", -8, 16)
	guideBox:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, 16)
	guideBox:SetHeight(108)
	if guideBox.SetBackdrop then
		guideBox:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		})
		guideBox:SetBackdropColor(0.08, 0.08, 0.1, 0.25)
		guideBox:SetBackdropBorderColor(0.45, 0.40, 0.30, 0.38)
	end
	guideBox:SetFrameLevel(panel:GetFrameLevel() + 1)
	guideLabel:SetDrawLayer("ARTWORK", 1)
	panel._guideBox = guideBox

	local modeAuto = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	modeAuto:SetSize(120, 24)
	modeAuto:SetPoint("TOPLEFT", guideLabel, "BOTTOMLEFT", 0, -8)
	modeAuto:SetScript("OnClick", function()
		ns:SetGuideVisibilityMode("auto")
		if panel._refresh then
			panel:_refresh()
		end
	end)
	panel._modeAuto = modeAuto

	local modeAlways = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	modeAlways:SetSize(120, 24)
	modeAlways:SetPoint("LEFT", modeAuto, "RIGHT", 8, 0)
	modeAlways:SetScript("OnClick", function()
		ns:SetGuideVisibilityMode("always")
		if panel._refresh then
			panel:_refresh()
		end
	end)
	panel._modeAlways = modeAlways

	local modeHidden = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	modeHidden:SetSize(120, 24)
	modeHidden:SetPoint("LEFT", modeAlways, "RIGHT", 8, 0)
	modeHidden:SetScript("OnClick", function()
		ns:SetGuideVisibilityMode("hidden")
		if panel._refresh then
			panel:_refresh()
		end
	end)
	panel._modeHidden = modeHidden

	local hint = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	hint:SetPoint("TOPLEFT", modeAuto, "BOTTOMLEFT", 0, -12)
	hint:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
	hint:SetJustifyH("LEFT")
	hint:SetWordWrap(true)
	hint:SetTextColor(0.82, 0.8, 0.74)
	panel._hint = hint

	local autoSaveHint = panel:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	autoSaveHint:SetPoint("TOPLEFT", hint, "BOTTOMLEFT", 0, -8)
	autoSaveHint:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
	autoSaveHint:SetJustifyH("LEFT")
	autoSaveHint:SetWordWrap(true)
	autoSaveHint:SetTextColor(0.65, 0.64, 0.62)
	panel._autoSaveHint = autoSaveHint

	function panel:_refresh()
		self.name = ns:L("MAIN_TITLE")
		self._title:SetText(ns:L("SETTINGS_TITLE"))
		self._subtitle:SetText(ns:L("SETTINGS_SUBTITLE"))
		self._generalLabel:SetText(ns:L("SETTINGS_SECTION_GENERAL"))
		self._langLabel:SetText(ns:L("SETTINGS_SECTION_LANGUAGE"))
		self._guideLabel:SetText(ns:L("SETTINGS_SECTION_GUIDE"))
		if self._langAuto then
			self._langAuto:SetText(ns:L("LOCALE_NAME_AUTO"))
		end
		self._langEn:SetText(ns:L("LOCALE_NAME_EN"))
		if self._langDe then
			self._langDe:SetText(ns:L("LOCALE_NAME_deDE"))
		end
		if self._langFr then
			self._langFr:SetText(ns:L("LOCALE_NAME_frFR"))
		end
		if self._langEs then
			self._langEs:SetText(ns:L("LOCALE_NAME_esES"))
		end
		self._langNl:SetText(ns:L("LOCALE_NAME_NL"))
		if self._langHint then
			self._langHint:SetText(ns:L("LOCALE_AUTO_HINT"))
		end
		self._modeAuto:SetText(ns:L("SETTINGS_GUIDE_MODE_AUTO"))
		self._modeAlways:SetText(ns:L("SETTINGS_GUIDE_MODE_ALWAYS"))
		self._modeHidden:SetText(ns:L("SETTINGS_GUIDE_MODE_HIDDEN"))
		self._hint:SetText(ns:L("SETTINGS_HINT"))
		self._autoSaveHint:SetText(ns:L("SETTINGS_AUTOSAVE_HINT"))
		self._openMain:SetText(ns:L("SETTINGS_OPEN_MAIN_WINDOW"))
		self._reset:SetText(ns:L("SETTINGS_RESET_DEFAULTS"))
		self._openOnLogin:SetChecked(ns.db and ns.db.ui and ns.db.ui.openOnLogin or false)
		if self._openOnLoginText and self._openOnLoginText.SetText then
			self._openOnLoginText:SetText(ns:L("SETTINGS_OPEN_ON_LOGIN"))
			if self._openOnLoginText.SetTextColor then
				self._openOnLoginText:SetTextColor(0.95, 0.9, 0.74)
			end
		end
		self._compactMode:SetChecked(ns.IsCompactModeEnabled and ns:IsCompactModeEnabled() or false)
		if self._compactModeText and self._compactModeText.SetText then
			self._compactModeText:SetText(ns:L("SETTINGS_COMPACT_MODE"))
			if self._compactModeText.SetTextColor then
				self._compactModeText:SetTextColor(0.95, 0.9, 0.74)
			end
		end

		RefreshLanguageButtonTints(self)

		local mode = ns:GetGuideVisibilityMode()
		local modeKeyByValue = {
			auto = "SETTINGS_GUIDE_MODE_AUTO",
			always = "SETTINGS_GUIDE_MODE_ALWAYS",
			hidden = "SETTINGS_GUIDE_MODE_HIDDEN",
		}
		local modeLabel = ns:L(modeKeyByValue[mode] or "SETTINGS_GUIDE_MODE_AUTO")
		local langLabel = ns.GetLanguageStatusLabel and ns:GetLanguageStatusLabel() or ns:L("LOCALE_NAME_EN")
		local loginEnabled = ns.db and ns.db.ui and ns.db.ui.openOnLogin
		local loginLabel = loginEnabled and ns:L("SETTINGS_BOOL_ON") or ns:L("SETTINGS_BOOL_OFF")
		self._status:SetText(
			ns:L("SETTINGS_STATUS_FMT"):format(
				("|cffffcc00%s|r"):format(langLabel),
				("|cffffcc00%s|r"):format(modeLabel),
				("|cffffcc00%s|r"):format(loginLabel)
			)
		)

		TintBtn(self._modeAuto, mode == "auto")
		TintBtn(self._modeAlways, mode == "always")
		TintBtn(self._modeHidden, mode == "hidden")
	end

	panel:_refresh()
	settingsCategoryFrame = panel
	return panel
end

local function EnsureSettingsCategoryRegistered()
	if settingsCategoryId then
		return settingsCategoryId
	end

	local panel = EnsureSettingsCategoryFrame()
	if _G.Settings and _G.Settings.RegisterCanvasLayoutCategory and _G.Settings.RegisterAddOnCategory then
		local category = _G.Settings.RegisterCanvasLayoutCategory(panel, ns:L("MAIN_TITLE"), ns:L("MAIN_TITLE"))
		_G.Settings.RegisterAddOnCategory(category)
		settingsCategoryId = category:GetID()
	else
		if _G.InterfaceOptions_AddCategory then
			_G.InterfaceOptions_AddCategory(panel)
		end
		settingsCategoryId = panel
	end
	return settingsCategoryId
end

function ns:OpenSettingsPanel()
	local category = EnsureSettingsCategoryRegistered()
	if settingsCategoryFrame and settingsCategoryFrame._refresh then
		settingsCategoryFrame:_refresh()
	end

	if type(category) == "number" and _G.Settings and _G.Settings.OpenToCategory then
		_G.Settings.OpenToCategory(category)
		return
	end

	if _G.InterfaceOptionsFrame_OpenToCategory and settingsCategoryFrame then
		_G.InterfaceOptionsFrame_OpenToCategory(settingsCategoryFrame)
		_G.InterfaceOptionsFrame_OpenToCategory(settingsCategoryFrame)
	end
end

--- Refresh LDB label when shell locale changes (wrapped below).
function ns:RefreshBrokerLocale()
	local obj = self._mhLDBObject
	if obj then
		obj.label = self:L("MAIN_TITLE")
	end
	if settingsFrame and settingsFrame:IsShown() and settingsFrame._refresh then
		settingsFrame:_refresh()
	end
	if settingsCategoryFrame and settingsCategoryFrame._refresh then
		settingsCategoryFrame:_refresh()
	end
end

function ns:InitMinimapBroker()
	if self._mhMinimapBrokerInited then
		return
	end

	local LibStub = _G.LibStub
	if not LibStub then
		return
	end

	local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
	local iconLib = LibStub:GetLibrary("LibDBIcon-1.0", true)
	if not ldb or not iconLib then
		return
	end

	local db = self.db and self.db.minimap
	if type(db) ~= "table" then
		return
	end

	local obj = ldb:NewDataObject(addonName, {
		type = "launcher",
		label = self:L("MAIN_TITLE"),
		icon = MINIMAP_ICON,
		OnClick = function(_, btn)
			if btn == "LeftButton" and ns.ToggleMainWindow then
				ns:ToggleMainWindow()
			elseif btn == "RightButton" then
				if ns.OpenSettingsPanel then
					ns:OpenSettingsPanel()
				elseif ns.ToggleQuickSettings then
					ns:ToggleQuickSettings(ns.mainUI)
				end
			end
		end,
		OnTooltipShow = function(tt)
			tt:AddLine(ns:L("MAIN_TITLE"), 1, 1, 1)
			local ver = ns.GetAddonVersion and ns.GetAddonVersion() or "?"
			tt:AddLine(ns:L("BROKER_TOOLTIP_VERSION_FMT"):format(ver), 0.72, 0.82, 0.95)
			tt:AddLine(ns:L("BROKER_TOOLTIP_HINT"), 0.86, 0.86, 0.82, true)
			tt:AddLine(" ")
			tt:AddLine(ns:L("BROKER_TOOLTIP_CURRENT_SETTINGS"), 1, 0.9, 0.5)
			local langLabel = ns.GetLanguageStatusLabel and ns:GetLanguageStatusLabel() or ns:L("LOCALE_NAME_EN")
			local modeKeyByValue = {
				auto = "SETTINGS_GUIDE_MODE_AUTO",
				always = "SETTINGS_GUIDE_MODE_ALWAYS",
				hidden = "SETTINGS_GUIDE_MODE_HIDDEN",
			}
			local mode = ns:GetGuideVisibilityMode()
			local modeLabel = ns:L(modeKeyByValue[mode] or "SETTINGS_GUIDE_MODE_AUTO")
			tt:AddLine(ns:L("BROKER_TOOLTIP_LANGUAGE_FMT"):format(langLabel), 0.82, 0.86, 0.92)
			tt:AddLine(ns:L("BROKER_TOOLTIP_GUIDE_FMT"):format(modeLabel), 0.82, 0.86, 0.92)
			if ns.AppendVaultReminderTooltip then
				ns.AppendVaultReminderTooltip(tt)
			end
		end,
	})

	self._mhLDBObject = obj
	self._mhMinimapBrokerInited = true

	local ok, err = pcall(function()
		iconLib:Register(addonName, obj, db)
	end)
	if not ok and self.db and self.db.ui and self.db.ui.debug then
		print(("|cffffcc00%s|r LibDBIcon:Register failed: %s"):format(ns:L("PRINT_PREFIX"), tostring(err)))
	end

	self:RefreshBrokerLocale()
	if ns.UpdateVaultReminderPresentation then
		ns.UpdateVaultReminderPresentation()
	end
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		self:RefreshBrokerLocale()
		if ns.UpdateVaultReminderPresentation then
			ns.UpdateVaultReminderPresentation()
		end
	end
end

local f = CreateFrame("Frame", nil, UIParent)
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
	if name ~= addonName then
		return
	end
	if ns.db then
		ns:InitMinimapBroker()
		if ns.InitDelveItemBrokers then
			ns:InitDelveItemBrokers()
		end
	end
end)
