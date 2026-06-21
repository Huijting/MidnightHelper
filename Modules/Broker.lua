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

function ns.TintSettingsButton(btn, active)
	TintBtn(btn, active)
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
	if host._langPt then
		TintBtn(host._langPt, pref == "ptBR")
	end
	if host._langNl then
		TintBtn(host._langNl, pref == "nlNL")
	end
end

local function AttachSettingsTooltip(widget, titleKey, bodyKey)
	if not widget or not widget.SetScript then
		return
	end
	widget._tipTitleKey = titleKey
	widget._tipBodyKey = bodyKey
	widget:SetScript("OnEnter", function(self)
		if not self._tipBodyKey then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if self._tipTitleKey then
			GameTooltip:AddLine(ns:L(self._tipTitleKey), 1, 0.82, 0)
		end
		GameTooltip:AddLine(ns:L(self._tipBodyKey), 0.92, 0.92, 0.92, true)
		GameTooltip:Show()
	end)
	widget:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

local function RefreshVaultSettingsControls(panel)
	if not panel then
		return
	end
	if panel._vaultLabel then
		panel._vaultLabel:SetText(ns:L("SETTINGS_SECTION_VAULT"))
	end
	if panel._vaultAdvisorLabel then
		panel._vaultAdvisorLabel:SetText(ns:L("SETTINGS_VAULT_ADVISOR_LABEL"))
	end
	local vaultKeys = {
		{ chk = panel._vaultEnabled, key = "enabled", loc = "SETTINGS_VAULT_REMINDER_ENABLED" },
		{ chk = panel._vaultChat, key = "chat", loc = "SETTINGS_VAULT_REMINDER_CHAT" },
		{ chk = panel._vaultMinimap, key = "minimap", loc = "SETTINGS_VAULT_REMINDER_MINIMAP" },
		{ chk = panel._vaultPing, key = "ping", loc = "SETTINGS_VAULT_REMINDER_PING" },
		{ chk = panel._vaultPopup, key = "popup", loc = "SETTINGS_VAULT_REMINDER_POPUP" },
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
	local vas = ns.GetVaultAdvisorSettings and ns.GetVaultAdvisorSettings() or {}
	if panel._vaultBlizzardPanel and panel._vaultBlizzardPanel._text then
		panel._vaultBlizzardPanel:SetChecked(vas.showBlizzardPanel ~= false)
		panel._vaultBlizzardPanel._text:SetText(ns:L("SETTINGS_VAULT_ADVISOR_SHOW_BLIZZARD"))
		if panel._vaultBlizzardPanel._text.SetTextColor then
			panel._vaultBlizzardPanel._text:SetTextColor(0.95, 0.9, 0.74)
		end
	end
	if panel._vaultUsePawn and panel._vaultUsePawn._text then
		panel._vaultUsePawn:SetChecked(vas.usePawn ~= false)
		panel._vaultUsePawn._text:SetText(ns:L("SETTINGS_VAULT_ADVISOR_USE_PAWN"))
		if panel._vaultUsePawn._text.SetTextColor then
			panel._vaultUsePawn._text:SetTextColor(0.95, 0.9, 0.74)
		end
	end
	if panel._vaultProfileLabel and panel._vaultProfileLabel.SetText then
		panel._vaultProfileLabel:SetText(ns:L("SETTINGS_VAULT_ADVISOR_PROFILE_LABEL"))
	end
	if panel._vaultProfileAuto then
		panel._vaultProfileAuto:SetText(ns:L("SETTINGS_VAULT_ADVISOR_PROFILE_AUTO"))
	end
	if panel._vaultProfileRaid then
		panel._vaultProfileRaid:SetText(ns:L("SETTINGS_VAULT_ADVISOR_PROFILE_RAID"))
	end
	if panel._vaultProfileMplus then
		panel._vaultProfileMplus:SetText(ns:L("SETTINGS_VAULT_ADVISOR_PROFILE_MPLUS_BTN"))
	end
	local profileMode = vas.profileMode or "auto"
	if ns.TintSettingsButton then
		ns.TintSettingsButton(panel._vaultProfileAuto, profileMode == "auto")
		ns.TintSettingsButton(panel._vaultProfileRaid, profileMode == "raid")
		ns.TintSettingsButton(panel._vaultProfileMplus, profileMode == "mplus")
	end
end

local function SetVaultAdvisorProfileMode(mode, host)
	if ns.SetVaultAdvisorOption then
		ns.SetVaultAdvisorOption("profileMode", mode)
	end
	if ns.RefreshBlizzardVaultBanner then
		ns.RefreshBlizzardVaultBanner()
	end
	if host and host._refresh then
		host:_refresh()
	end
end

local function AttachVaultProfileButtons(parent, anchor, layer, store)
	layer = layer or "OVERLAY"
	store = store or parent
	local profileLabel = parent:CreateFontString(nil, layer, "GameFontHighlightSmall")
	profileLabel:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 2, -10)
	profileLabel:SetTextColor(0.82, 0.8, 0.74)
	store._vaultProfileLabel = profileLabel

	local profileAuto = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	profileAuto:SetSize(72, 22)
	profileAuto:SetPoint("TOPLEFT", profileLabel, "BOTTOMLEFT", -2, -4)
	profileAuto:SetScript("OnClick", function()
		SetVaultAdvisorProfileMode("auto", store)
	end)
	AttachSettingsTooltip(profileAuto, "SETTINGS_VAULT_ADVISOR_PROFILE_AUTO", "SETTINGS_VAULT_ADVISOR_PROFILE_AUTO_TT")
	store._vaultProfileAuto = profileAuto

	local profileRaid = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	profileRaid:SetSize(72, 22)
	profileRaid:SetPoint("LEFT", profileAuto, "RIGHT", 6, 0)
	profileRaid:SetScript("OnClick", function()
		SetVaultAdvisorProfileMode("raid", store)
	end)
	AttachSettingsTooltip(profileRaid, "SETTINGS_VAULT_ADVISOR_PROFILE_RAID", "SETTINGS_VAULT_ADVISOR_PROFILE_RAID_TT")
	store._vaultProfileRaid = profileRaid

	local profileMplus = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	profileMplus:SetSize(72, 22)
	profileMplus:SetPoint("LEFT", profileRaid, "RIGHT", 6, 0)
	profileMplus:SetScript("OnClick", function()
		SetVaultAdvisorProfileMode("mplus", store)
	end)
	AttachSettingsTooltip(profileMplus, "SETTINGS_VAULT_ADVISOR_PROFILE_MPLUS_BTN", "SETTINGS_VAULT_ADVISOR_PROFILE_MPLUS_TT")
	store._vaultProfileMplus = profileMplus
end

local function AttachVaultSettingsControls(parent, topAnchor, layer, store, colOffset)
	layer = layer or "OVERLAY"
	store = store or parent
	local twoCol = colOffset and colOffset > 0
	local vaultLabel = parent:CreateFontString(nil, layer, "GameFontHighlight")
	vaultLabel:SetPoint("TOPLEFT", topAnchor, "BOTTOMLEFT", 0, -14)
	vaultLabel:SetTextColor(0.95, 0.9, 0.74)
	store._vaultLabel = vaultLabel

	local vaultAdvisorLabel = parent:CreateFontString(nil, layer, "GameFontHighlight")
	vaultAdvisorLabel:SetTextColor(0.95, 0.9, 0.74)
	store._vaultAdvisorLabel = vaultAdvisorLabel

	local function refreshHost()
		if store._refresh then
			store:_refresh()
		elseif parent._refresh then
			parent:_refresh()
		end
	end

	local function MakeVaultChk(anchor, offsetY, key, tipKey)
		local chk = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
		chk:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", -2, offsetY)
		chk:SetScript("OnClick", function(self)
			if ns.SetVaultReminderOption then
				ns.SetVaultReminderOption(key, self:GetChecked())
			end
			refreshHost()
		end)
		local txt = chk.text or _G[chk:GetName() .. "Text"]
		chk._text = txt
		AttachSettingsTooltip(chk, tipKey, tipKey .. "_TT")
		return chk
	end

	local function MakeAdvisorChk(anchor, offsetY, setter, tipKey)
		local chk = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
		chk:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", -2, offsetY)
		chk:SetScript("OnClick", function(self)
			if setter == "blizzard" then
				if ns.SetVaultAdvisorOption then
					ns.SetVaultAdvisorOption("showBlizzardPanel", self:GetChecked())
				end
				if ns.RefreshBlizzardVaultBanner then
					ns.RefreshBlizzardVaultBanner()
				end
			elseif setter == "pawn" then
				if ns.SetVaultAdvisorOption then
					ns.SetVaultAdvisorOption("usePawn", self:GetChecked())
				end
			end
			refreshHost()
		end)
		chk._text = chk.text or _G[chk:GetName() .. "Text"]
		AttachSettingsTooltip(chk, tipKey, tipKey .. "_TT")
		return chk
	end

	store._vaultEnabled = MakeVaultChk(vaultLabel, -6, "enabled", "SETTINGS_VAULT_REMINDER_ENABLED")
	store._vaultChat = MakeVaultChk(store._vaultEnabled, -4, "chat", "SETTINGS_VAULT_REMINDER_CHAT")
	store._vaultMinimap = MakeVaultChk(store._vaultChat, -4, "minimap", "SETTINGS_VAULT_REMINDER_MINIMAP")
	store._vaultPing = MakeVaultChk(store._vaultMinimap, -4, "ping", "SETTINGS_VAULT_REMINDER_PING")
	store._vaultPopup = MakeVaultChk(store._vaultPing, -4, "popup", "SETTINGS_VAULT_REMINDER_POPUP")

	if twoCol then
		vaultAdvisorLabel:SetPoint("TOPLEFT", topAnchor, "BOTTOMLEFT", colOffset, -14)
	else
		vaultAdvisorLabel:SetPoint("TOPLEFT", store._vaultPopup, "BOTTOMLEFT", 2, -12)
	end

	store._vaultBlizzardPanel = MakeAdvisorChk(vaultAdvisorLabel, -6, "blizzard", "SETTINGS_VAULT_ADVISOR_SHOW_BLIZZARD")
	store._vaultUsePawn = MakeAdvisorChk(store._vaultBlizzardPanel, -4, "pawn", "SETTINGS_VAULT_ADVISOR_USE_PAWN")
	AttachVaultProfileButtons(parent, store._vaultUsePawn, layer, store)
	store._vaultTwoColumn = twoCol
end

local function AttachBetaTabsSettings(parent, topAnchor, layer, store)
	layer = layer or "OVERLAY"
	store = store or parent

	local betaLabel = parent:CreateFontString(nil, layer, "GameFontHighlight")
	betaLabel:SetPoint("TOPLEFT", topAnchor, "BOTTOMLEFT", 0, -14)
	betaLabel:SetTextColor(0.95, 0.9, 0.74)
	store._betaTabsLabel = betaLabel

	local function refreshHost()
		if store._refresh then
			store:_refresh()
		elseif parent._refresh then
			parent:_refresh()
		end
	end

	local function MakeBetaChk(anchor, offsetY, key, tipKey)
		local chk = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
		chk:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", -2, offsetY)
		chk:SetScript("OnClick", function(self)
			if ns.SetBetaTabOption then
				ns.SetBetaTabOption(key, self:GetChecked())
			end
			refreshHost()
		end)
		chk._text = chk.text or _G[chk:GetName() .. "Text"]
		AttachSettingsTooltip(chk, tipKey, tipKey .. "_TT")
		return chk
	end

	store._betaTabsEnabled = MakeBetaChk(betaLabel, -6, "enabled", "SETTINGS_BETA_TABS_ENABLED")
	store._betaTabCodex = MakeBetaChk(store._betaTabsEnabled, -4, "codex", "SETTINGS_BETA_TAB_CODEX")
	store._betaTabReference = MakeBetaChk(store._betaTabCodex, -4, "reference", "SETTINGS_BETA_TAB_REFERENCE")
	store._betaTabGuide = MakeBetaChk(store._betaTabReference, -4, "guide", "SETTINGS_BETA_TAB_GUIDE")
	store._betaTabMacros = MakeBetaChk(store._betaTabGuide, -4, "macros", "SETTINGS_BETA_TAB_MACROS")
	store._betaTabAcademy = MakeBetaChk(store._betaTabMacros, -4, "academy", "SETTINGS_BETA_TAB_ACADEMY")
end

local function RefreshBetaTabsSettingsControls(panel)
	if not panel then
		return
	end
	if panel._betaTabsLabel and panel._betaTabsLabel.SetText then
		panel._betaTabsLabel:SetText(ns:L("SETTINGS_SECTION_BETA"))
	end
	local bt = ns.GetBetaTabsSettings and ns.GetBetaTabsSettings() or {}
	local rows = {
		{ chk = panel._betaTabsEnabled, key = "enabled", loc = "SETTINGS_BETA_TABS_ENABLED" },
		{ chk = panel._betaTabCodex, key = "codex", loc = "SETTINGS_BETA_TAB_CODEX" },
		{ chk = panel._betaTabReference, key = "reference", loc = "SETTINGS_BETA_TAB_REFERENCE" },
		{ chk = panel._betaTabGuide, key = "guide", loc = "SETTINGS_BETA_TAB_GUIDE" },
		{ chk = panel._betaTabMacros, key = "macros", loc = "SETTINGS_BETA_TAB_MACROS" },
		{ chk = panel._betaTabAcademy, key = "academy", loc = "SETTINGS_BETA_TAB_ACADEMY" },
	}
	for _, row in ipairs(rows) do
		if row.chk then
			if row.key == "enabled" then
				row.chk:SetChecked(bt.enabled ~= false)
			else
				row.chk:SetChecked(bt.enabled ~= false and bt[row.key] ~= false)
			end
			if row.chk._text and row.chk._text.SetText then
				row.chk._text:SetText(ns:L(row.loc))
				row.chk._text:SetTextColor(0.95, 0.9, 0.74)
			end
			if row.chk.Enable and row.chk.Disable and row.key ~= "enabled" then
				if bt.enabled ~= false then
					row.chk:Enable()
				else
					row.chk:Disable()
				end
			end
		end
	end
end

local function UpdateSettingsCategoryScrollHeight(panel)
	local content = panel and panel._settingsContent
	local scroll = panel and panel._settingsScroll
	if not content or not scroll then
		return
	end
	local candidates = {
		panel._betaTabAcademy,
		panel._betaTabGuide,
		panel._vaultProfileMplus,
		panel._vaultPopup,
		panel._vaultUsePawn,
	}
	local bottom = panel._vaultPopup
	for _, widget in ipairs(candidates) do
		if widget and widget.GetBottom then
			local wb = widget:GetBottom()
			if wb and bottom and bottom.GetBottom then
				local bb = bottom:GetBottom()
				if bb and wb < bb then
					bottom = widget
				end
			elseif wb and not bottom then
				bottom = widget
			end
		end
	end
	if not bottom then
		return
	end
	local contentTop = content:GetTop()
	local bottomY = bottom:GetBottom()
	local h = 640
	if contentTop and bottomY then
		h = contentTop - bottomY + 36
	end
	content:SetHeight(math.max(480, h))
	if scroll.UpdateScrollChildRect then
		scroll:UpdateScrollChildRect()
	end
end

local function EnsureSettingsFrame()
	if settingsFrame then
		return settingsFrame
	end

	local f = CreateFrame("Frame", "MidnightHelperQuickSettings", UIParent, "BackdropTemplate")
	f:SetSize(440, 450)
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

	local langPt = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	langPt:SetSize(72, 24)
	langPt:SetPoint("LEFT", langEs, "RIGHT", 6, 0)
	langPt:SetScript("OnClick", function()
		OnLanguageChosen(f, "ptBR")
	end)
	f._langPt = langPt

	local langNl = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	langNl:SetSize(88, 24)
	langNl:SetPoint("LEFT", langPt, "RIGHT", 6, 0)
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

	AttachVaultSettingsControls(f, hint, "OVERLAY", f, 218)

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
		if self._langPt then
			self._langPt:SetText(ns:L("LOCALE_NAME_ptBR"))
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
		RefreshVaultSettingsControls(self)

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
	if settingsCategoryFrame and (not settingsCategoryFrame._vaultProfileMplus or not settingsCategoryFrame._settingsScroll or settingsCategoryFrame._vaultTwoColumn or not settingsCategoryFrame._betaTabsLabel) then
		settingsCategoryFrame = nil
	end
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

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", line, "BOTTOMLEFT", -4, -6)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, 12)
	panel._settingsScroll = scroll

	local content = CreateFrame("Frame", nil, scroll)
	content:SetWidth(600)
	scroll:SetScrollChild(content)
	panel._settingsContent = content

	local generalLabel = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	generalLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 16, -10)
	panel._generalLabel = generalLabel

	local generalBox = CreateFrame("Frame", nil, content, "BackdropTemplate")
	generalBox:SetPoint("TOPLEFT", generalLabel, "TOPLEFT", -8, 16)
	generalBox:SetPoint("TOPRIGHT", content, "TOPRIGHT", -16, 16)
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
	generalBox:SetFrameLevel(content:GetFrameLevel() + 1)
	generalLabel:SetDrawLayer("ARTWORK", 1)
	panel._generalBox = generalBox

	local openOnLogin = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
	openOnLogin:SetPoint("TOPLEFT", generalLabel, "BOTTOMLEFT", -2, -6)
	openOnLogin:SetScript("OnClick", function(self)
		if ns.db and ns.db.ui then
			ns.db.ui.openOnLogin = self:GetChecked() and true or false
		end
	end)
	panel._openOnLogin = openOnLogin
	local openOnLoginText = openOnLogin.text or _G[openOnLogin:GetName() .. "Text"]
	panel._openOnLoginText = openOnLoginText

	local compactMode = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
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

	local rareAlert = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
	rareAlert:SetPoint("TOPLEFT", compactMode, "BOTTOMLEFT", 0, -4)
	rareAlert:SetScript("OnClick", function(self)
		if ns.SetRareAlertEnabled then
			ns.SetRareAlertEnabled(self:GetChecked())
		end
	end)
	panel._rareAlert = rareAlert
	local rareAlertText = rareAlert.text or _G[rareAlert:GetName() .. "Text"]
	panel._rareAlertText = rareAlertText
	AttachSettingsTooltip(rareAlert, "SETTINGS_RARE_ALERT", "SETTINGS_RARE_ALERT_TT")

	-- Sub-optie (Rob 11 jun): alleen melden tijdens een rare-hunt — d.w.z.
	-- nadat deze sessie een route naar een rare is gestart.
	local rareAlertRoute = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
	rareAlertRoute:SetPoint("TOPLEFT", rareAlert, "BOTTOMLEFT", 18, -2)
	rareAlertRoute:SetScript("OnClick", function(self)
		if ns.SetRareAlertOnlyWhileRouting then
			ns.SetRareAlertOnlyWhileRouting(self:GetChecked())
		end
	end)
	panel._rareAlertRoute = rareAlertRoute
	local rareAlertRouteText = rareAlertRoute.text or _G[rareAlertRoute:GetName() .. "Text"]
	panel._rareAlertRouteText = rareAlertRouteText
	AttachSettingsTooltip(rareAlertRoute, "SETTINGS_RARE_ALERT_ONLYROUTE", "SETTINGS_RARE_ALERT_ONLYROUTE_TT")

	local openMain = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	openMain:SetSize(152, 24)
	openMain:SetPoint("TOPLEFT", rareAlertRoute, "BOTTOMLEFT", -14, -8)
	openMain:SetScript("OnClick", function()
		if ns.ShowMainUI then
			ns:ShowMainUI()
		end
	end)
	panel._openMain = openMain

	local reset = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
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
		if ns.GetBetaTabsSettings then
			local bt = ns.GetBetaTabsSettings()
			bt.enabled = true
			bt.reference = true
			bt.guide = true
			bt.macros = true
			bt.academy = true
		end
		if ns.RefreshBetaTabVisibility then
			ns.RefreshBetaTabVisibility()
		end
		if ns.RefreshGuideTabVisibility then
			ns:RefreshGuideTabVisibility()
		end
		if panel._refresh then
			panel:_refresh()
		end
	end)
	panel._reset = reset

	local langLabel = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	langLabel:SetPoint("TOPLEFT", openMain, "BOTTOMLEFT", -4, -14)
	panel._langLabel = langLabel

	local languageBox = CreateFrame("Frame", nil, content, "BackdropTemplate")
	languageBox:SetPoint("TOPLEFT", langLabel, "TOPLEFT", -8, 16)
	languageBox:SetPoint("TOPRIGHT", content, "TOPRIGHT", -16, 16)
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
	languageBox:SetFrameLevel(content:GetFrameLevel() + 1)
	langLabel:SetDrawLayer("ARTWORK", 1)
	panel._languageBox = languageBox

	local langAuto = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	langAuto:SetSize(108, 24)
	langAuto:SetPoint("TOPLEFT", langLabel, "BOTTOMLEFT", 0, -8)
	langAuto:SetScript("OnClick", function()
		OnLanguageChosen(panel, ns.MH_LOCALE_AUTO or "auto")
	end)
	panel._langAuto = langAuto

	local langEn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	langEn:SetSize(88, 24)
	langEn:SetPoint("LEFT", langAuto, "RIGHT", 6, 0)
	langEn:SetScript("OnClick", function()
		OnLanguageChosen(panel, "enUS")
	end)
	panel._langEn = langEn

	local langDe = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	langDe:SetSize(88, 24)
	langDe:SetPoint("LEFT", langEn, "RIGHT", 6, 0)
	langDe:SetScript("OnClick", function()
		OnLanguageChosen(panel, "deDE")
	end)
	panel._langDe = langDe

	local langFr = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	langFr:SetSize(88, 24)
	langFr:SetPoint("LEFT", langDe, "RIGHT", 6, 0)
	langFr:SetScript("OnClick", function()
		OnLanguageChosen(panel, "frFR")
	end)
	panel._langFr = langFr

	local langEs = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	langEs:SetSize(88, 24)
	langEs:SetPoint("TOPLEFT", langAuto, "BOTTOMLEFT", 0, -8)
	langEs:SetScript("OnClick", function()
		OnLanguageChosen(panel, "esES")
	end)
	panel._langEs = langEs

	local langPt = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	langPt:SetSize(88, 24)
	langPt:SetPoint("LEFT", langEs, "RIGHT", 6, 0)
	langPt:SetScript("OnClick", function()
		OnLanguageChosen(panel, "ptBR")
	end)
	panel._langPt = langPt

	local langNl = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	langNl:SetSize(96, 24)
	langNl:SetPoint("LEFT", langPt, "RIGHT", 6, 0)
	langNl:SetScript("OnClick", function()
		OnLanguageChosen(panel, "nlNL")
	end)
	panel._langNl = langNl

	local langHint = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	langHint:SetPoint("TOPLEFT", langEs, "BOTTOMLEFT", 0, -6)
	langHint:SetPoint("RIGHT", content, "RIGHT", -16, 0)
	langHint:SetJustifyH("LEFT")
	langHint:SetWordWrap(true)
	langHint:SetTextColor(0.72, 0.74, 0.78)
	panel._langHint = langHint

	local guideLabel = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	guideLabel:SetPoint("TOPLEFT", langHint, "BOTTOMLEFT", 0, -10)
	panel._guideLabel = guideLabel

	local guideBox = CreateFrame("Frame", nil, content, "BackdropTemplate")
	guideBox:SetPoint("TOPLEFT", guideLabel, "TOPLEFT", -8, 16)
	guideBox:SetPoint("TOPRIGHT", content, "TOPRIGHT", -16, 16)
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
	guideBox:SetFrameLevel(content:GetFrameLevel() + 1)
	guideLabel:SetDrawLayer("ARTWORK", 1)
	panel._guideBox = guideBox

	local modeAuto = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	modeAuto:SetSize(120, 24)
	modeAuto:SetPoint("TOPLEFT", guideLabel, "BOTTOMLEFT", 0, -8)
	modeAuto:SetScript("OnClick", function()
		ns:SetGuideVisibilityMode("auto")
		if panel._refresh then
			panel:_refresh()
		end
	end)
	panel._modeAuto = modeAuto

	local modeAlways = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	modeAlways:SetSize(120, 24)
	modeAlways:SetPoint("LEFT", modeAuto, "RIGHT", 8, 0)
	modeAlways:SetScript("OnClick", function()
		ns:SetGuideVisibilityMode("always")
		if panel._refresh then
			panel:_refresh()
		end
	end)
	panel._modeAlways = modeAlways

	local modeHidden = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	modeHidden:SetSize(120, 24)
	modeHidden:SetPoint("LEFT", modeAlways, "RIGHT", 8, 0)
	modeHidden:SetScript("OnClick", function()
		ns:SetGuideVisibilityMode("hidden")
		if panel._refresh then
			panel:_refresh()
		end
	end)
	panel._modeHidden = modeHidden

	local hint = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	hint:SetPoint("TOPLEFT", modeAuto, "BOTTOMLEFT", 0, -12)
	hint:SetPoint("RIGHT", content, "RIGHT", -16, 0)
	hint:SetJustifyH("LEFT")
	hint:SetWordWrap(true)
	hint:SetTextColor(0.82, 0.8, 0.74)
	panel._hint = hint

	AttachBetaTabsSettings(content, hint, "ARTWORK", panel)

	local autoSaveHint = content:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	autoSaveHint:SetPoint("TOPLEFT", panel._betaTabAcademy or panel._betaTabGuide or hint, "BOTTOMLEFT", 0, -8)
	autoSaveHint:SetPoint("RIGHT", content, "RIGHT", -16, 0)
	autoSaveHint:SetJustifyH("LEFT")
	autoSaveHint:SetWordWrap(true)
	autoSaveHint:SetTextColor(0.65, 0.64, 0.62)
	panel._autoSaveHint = autoSaveHint

	AttachVaultSettingsControls(content, autoSaveHint, "ARTWORK", panel, 0)

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
		if self._langPt then
			self._langPt:SetText(ns:L("LOCALE_NAME_ptBR"))
		end
		self._langNl:SetText(ns:L("LOCALE_NAME_NL"))
		if self._langHint then
			self._langHint:SetText(ns:L("LOCALE_AUTO_HINT"))
		end
		self._modeAuto:SetText(ns:L("SETTINGS_GUIDE_MODE_AUTO"))
		self._modeAlways:SetText(ns:L("SETTINGS_GUIDE_MODE_ALWAYS"))
		self._modeHidden:SetText(ns:L("SETTINGS_GUIDE_MODE_HIDDEN"))
		self._hint:SetText(ns:L("SETTINGS_HINT"))
		RefreshBetaTabsSettingsControls(self)
		self._autoSaveHint:SetText(ns:L("SETTINGS_AUTOSAVE_HINT"))
		RefreshVaultSettingsControls(self)
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
		if self._rareAlert then
			local ra = ns.GetRareAlertSettings and ns.GetRareAlertSettings() or nil
			self._rareAlert:SetChecked(not ra or ra.enabled ~= false)
			if self._rareAlertText and self._rareAlertText.SetText then
				self._rareAlertText:SetText(ns:L("SETTINGS_RARE_ALERT"))
				if self._rareAlertText.SetTextColor then
					self._rareAlertText:SetTextColor(0.95, 0.9, 0.74)
				end
			end
			if self._rareAlertRoute then
				self._rareAlertRoute:SetChecked(ra and ra.onlyWhileRouting == true or false)
				if self._rareAlertRouteText and self._rareAlertRouteText.SetText then
					self._rareAlertRouteText:SetText(ns:L("SETTINGS_RARE_ALERT_ONLYROUTE"))
					if self._rareAlertRouteText.SetTextColor then
						self._rareAlertRouteText:SetTextColor(0.95, 0.9, 0.74)
					end
				end
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
		UpdateSettingsCategoryScrollHeight(self)
	end

	panel:_refresh()
	panel:HookScript("OnShow", function(self)
		UpdateSettingsCategoryScrollHeight(self)
	end)
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
			elseif btn == "MiddleButton" then
				-- Snelkoppeling: consumable-bord tonen (zelfde als /mh board).
				if ns.ShowConsumableBoard then
					ns.ShowConsumableBoard()
				end
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
			tt:AddLine(ns:L("BROKER_TOOLTIP_BOARD"), 0.86, 0.86, 0.82, true)
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
