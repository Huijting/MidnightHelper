--[[
	Midnight Helper — LibDataBroker minimap launcher (embedded LibDBIcon-1.0).

	Load order: after UI.lua (needs ToggleMainWindow + RefreshLocaleUI).
]]

local addonName, ns = ...

local MINIMAP_ICON = "Interface\\AddOns\\MidnightHelper\\Media\\Platy1"

-- AddonCompartment entry (the top-right addon button menu; wired via `## AddonCompartmentFunc`
-- in the .toc). Clicking it toggles the main window, same as a left-click on the minimap icon.
function MidnightHelper_OnAddonCompartmentClick()
	if ns.ToggleMainWindow then
		ns:ToggleMainWindow()
	end
end

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

-- Expose the reusable vault + beta-tabs settings builders so the in-addon Settings
-- tab (SettingsPage.lua) can host them too — one settings home, no Blizzard panel.
ns.AttachVaultSettingsControls = AttachVaultSettingsControls
ns.RefreshVaultSettingsControls = RefreshVaultSettingsControls
ns.AttachBetaTabsSettings = AttachBetaTabsSettings
ns.RefreshBetaTabsSettingsControls = RefreshBetaTabsSettingsControls

--- Refresh LDB label when shell locale changes (wrapped below).
function ns:RefreshBrokerLocale()
	local obj = self._mhLDBObject
	if obj then
		obj.label = self:L("MAIN_TITLE")
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
				-- One settings home: right-click opens the in-addon Settings tab. The old
				-- Blizzard interface panel + quick-settings popup are retired (no longer
				-- reachable), so all settings live in one place.
				if ns.ShowMainUI then
					ns:ShowMainUI()
				end
				if ns.SelectTab then
					ns.SelectTab("settings")
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
