--[[
	Midnight Helper — native Blizzard Settings panel (Robs keuze 5 jul: native,
	de custom "Mission Control"-pagina wordt een launcher).

	Waarom native: de Vertical-Layout Settings-API geeft zoekbalk, per-optie
	tooltips, subcategorieën, keyboard-nav en een native look *gratis* — precies
	wat we voor de "goudvis-proof" pagina wilden, tegen de laagste bouwkost.

	Bridge-patroon (geen dubbele waarheid): elke instelling blijft in ns.db via
	de bestaande setters wonen. We seeden een tijdelijke `proxy`-tabel uit de
	bestaande getter, registreren de native setting tegen die proxy, en laten
	OnValueChanged de bestaande setter aanroepen. Bij herlogin seeden we opnieuw
	uit ns.db, dus de proxy is puur een spiegel — ns.db is de waarheid.

	De "Aanbevolen"-knop zet alles in één klik goed via setting:SetValue(), wat
	meteen de checkbox-weergave én de echte setter bijwerkt.

	Template geleend van ClassCodex\Settings.lua + Broker_MidnightEvents (beide
	native in 120007). Knop-initializer bevestigd werkend via BugSack.
]]

local _, ns = ...

-- Transiënte spiegel van ns.db, elke load opnieuw geseed uit de echte getters.
local proxy = {}
-- variable -> Blizzard setting-object (voor de Aanbevolen-knop).
local settingObjs = {}
-- variable -> aanbevolen waarde (bool/number/string).
local recommended = {}

local registered = false

local function L(key)
	return ns:L(key)
end

--------------------------------------------------------------------------------
-- Registratie
--------------------------------------------------------------------------------

function ns.RegisterNativeSettings()
	if registered then
		return
	end
	if not (Settings and Settings.RegisterVerticalLayoutCategory and Settings.RegisterAddOnSetting) then
		return -- classic/oude client zonder de moderne Settings-API
	end
	registered = true

	local ok, err = pcall(function()
		local category, layout = Settings.RegisterVerticalLayoutCategory("Midnight Helper")
		ns.settingsCategory = category

		----------------------------------------------------------------
		-- Helpers
		----------------------------------------------------------------

		-- ns:L geeft de rauwe key terug als die nergens bestaat; deze guard zorgt
		-- dat een ontbrekende tooltip leeg blijft i.p.v. een lelijke key toont.
		local function Tip(key)
			if not key then
				return nil
			end
			local s = L(key)
			if s == key then
				return nil
			end
			return s
		end

		local function AddHeader(key)
			if CreateSettingsListSectionHeaderInitializer then
				layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L(key)))
			end
		end

		-- Bridged checkbox. getFn/setFn zijn de bestaande ns-functies; recVal is
		-- de aanbevolen stand (nil = niet in de Aanbevolen-preset opnemen).
		local function AddToggle(variable, nameKey, tipKey, getFn, setFn, recVal)
			local cur = false
			pcall(function()
				cur = getFn() and true or false
			end)
			proxy[variable] = cur
			local default = recVal
			if default == nil then
				default = cur
			end
			local setting = Settings.RegisterAddOnSetting(
				category, variable, variable, proxy, "boolean", L(nameKey), default and true or false
			)
			Settings.SetOnValueChangedCallback(variable, function()
				pcall(setFn, proxy[variable] and true or false)
			end)
			local initializer = Settings.CreateCheckbox(category, setting, Tip(tipKey))
			settingObjs[variable] = setting
			if recVal ~= nil then
				recommended[variable] = recVal and true or false
			end
			return setting, initializer
		end

		local function AddSlider(variable, nameKey, tipKey, minV, maxV, step, getFn, setFn, fmt, recVal)
			local cur = recVal or minV
			pcall(function()
				local v = getFn()
				if type(v) == "number" then
					cur = v
				end
			end)
			proxy[variable] = cur
			local setting = Settings.RegisterAddOnSetting(
				category, variable, variable, proxy, "number", L(nameKey), recVal or cur
			)
			Settings.SetOnValueChangedCallback(variable, function()
				pcall(setFn, proxy[variable])
			end)
			local opts = Settings.CreateSliderOptions(minV, maxV, step)
			if opts.SetLabelFormatter and MinimalSliderWithSteppersMixin then
				opts:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, fmt or tostring)
			end
			Settings.CreateSlider(category, setting, opts, Tip(tipKey))
			settingObjs[variable] = setting
			if recVal ~= nil then
				recommended[variable] = recVal
			end
		end

		-- options: array van { value=..., labelKey=... }
		local function AddDropdown(variable, nameKey, tipKey, default, options, getFn, setFn, recVal)
			local cur = default
			pcall(function()
				local v = getFn()
				if v ~= nil then
					cur = v
				end
			end)
			proxy[variable] = cur
			local setting = Settings.RegisterAddOnSetting(
				category, variable, variable, proxy, "string", L(nameKey), recVal or default
			)
			Settings.SetOnValueChangedCallback(variable, function()
				pcall(setFn, proxy[variable])
			end)
			Settings.CreateDropdown(category, setting, function()
				local c = Settings.CreateControlTextContainer()
				for _, o in ipairs(options) do
					c:Add(o.value, L(o.labelKey))
				end
				return c:GetData()
			end, Tip(tipKey))
			settingObjs[variable] = setting
			if recVal ~= nil then
				recommended[variable] = recVal
			end
		end

		----------------------------------------------------------------
		-- Taal / Language (bovenaan: Rob speelt Engels, zijn zus Nederlands —
		-- de taalkeuze moet meteen zichtbaar zijn). De rode "Defaults"-knop van
		-- Blizzard zet alles op de aanbevolen stand (we registreren de aanbevolen
		-- waarden immers als default).
		----------------------------------------------------------------
		AddHeader("SETTINGS_LANGUAGE_LABEL")
		AddDropdown("mh_locale", "SETTINGS_LANGUAGE_LABEL", "SET_LANG_RELOAD_TT", "auto", {
			{ value = "auto", labelKey = "LANG_LABEL_AUTO" },
			{ value = "enUS", labelKey = "LANG_LABEL_EN" },
			{ value = "nlNL", labelKey = "LANG_LABEL_NL" },
			{ value = "deDE", labelKey = "LANG_LABEL_DE" },
			{ value = "frFR", labelKey = "LANG_LABEL_FR" },
			{ value = "esES", labelKey = "LANG_LABEL_ES" },
			{ value = "ptBR", labelKey = "LANG_LABEL_PT" },
			{ value = "itIT", labelKey = "LANG_LABEL_IT" },
		}, function()
			return (ns.db and ns.db.locale) or ns.MH_LOCALE_AUTO or "auto"
		end, function(v)
			if ns.SetLocale then ns:SetLocale(v) end
			if ns.RefreshGuideTabVisibility then ns:RefreshGuideTabVisibility() end
		end)

		----------------------------------------------------------------
		-- Waarschuwingen in gevecht
		----------------------------------------------------------------
		AddHeader("SET_SEC_COMBAT")
		AddToggle("mh_combatSafety", "SET_CS_TOGGLE_TITLE", "SET_CS_TOGGLE_DESC", function()
			return ns.IsCombatSafetyEnabled and ns.IsCombatSafetyEnabled()
		end, function(v)
			if ns.SetCombatSafetyEnabled then ns.SetCombatSafetyEnabled(v) end
		end, true)
		-- Party targets sits under Combat because that is when it earns its place --
		-- and because the same combat edge is what limits it. Recommended OFF: it is
		-- another frame on screen, and MH does not decide that for you.
		AddToggle("mh_partyTargets", "SET_PARTYTARGETS_TITLE", "SET_PARTYTARGETS_DESC", function()
			return ns.IsPartyTargetsEnabled and ns.IsPartyTargetsEnabled()
		end, function(v)
			if ns.SetPartyTargetsEnabled then ns.SetPartyTargetsEnabled(v) end
		end, false)
		-- ⚠️ Hier stonden 18 aug twee brace-prompt-schakelaars. Ze zijn dezelfde dag weer
		-- weggehaald: 12.1 geeft geen enkel leesbaar kenmerk van een vijandelijke cast
		-- meer (spell-id, npc-id, icoon en begin-/eindtijd allemaal secret), dus de
		-- prompt kon niet zeggen WELKE cast hij bedoelde. Zie de uitleg bij /mh brace in
		-- Core.lua. De inhoud staat nu in de Delve Coach bij The Ring of Glory.
		AddToggle("mh_csSpeak", "SET_CS_SPEAK_TITLE", "SET_CS_SPEAK_DESC", function()
			return ns.IsCombatSafetySpeakEnabled and ns.IsCombatSafetySpeakEnabled()
		end, function(v)
			if ns.SetCombatSafetySpeakEnabled then ns.SetCombatSafetySpeakEnabled(v) end
		end, false)
		AddToggle("mh_csBars", "SET_CS_BARS_TITLE", "SET_CS_BARS_DESC", function()
			return ns.IsCombatSafetyBarsEnabled and ns.IsCombatSafetyBarsEnabled()
		end, function(v)
			if ns.SetCombatSafetyBarsEnabled then ns.SetCombatSafetyBarsEnabled(v) end
		end, false)
		AddToggle("mh_csImportant", "SET_CS_IMPORTANT_TITLE", "SET_CS_IMPORTANT_DESC", function()
			return ns.IsCombatSafetyImportantOnly and ns.IsCombatSafetyImportantOnly()
		end, function(v)
			if ns.SetCombatSafetyImportantOnly then ns.SetCombatSafetyImportantOnly(v) end
		end, false)
		-- Death Recap auto-open (restricted content only). Recommended ON: it exists for
		-- beginners who die in a delve/ritual and have no other way to learn the cause.
		AddToggle("mh_deathAutoOpen", "SET_DEATH_AUTOOPEN_TITLE", "SET_DEATH_AUTOOPEN_DESC", function()
			return ns.IsDeathRecapAutoOpenEnabled and ns.IsDeathRecapAutoOpenEnabled()
		end, function(v)
			if ns.SetDeathRecapAutoOpenEnabled then ns.SetDeathRecapAutoOpenEnabled(v) end
		end, true)
		AddToggle("mh_missingBuff", "SET_MBUFF_TOGGLE_TITLE", "SET_MBUFF_TOGGLE_DESC", function()
			return ns.IsMissingBuffEnabled and ns.IsMissingBuffEnabled()
		end, function(v)
			if ns.SetMissingBuffEnabled then ns.SetMissingBuffEnabled(v) end
		end, true)

		----------------------------------------------------------------
		-- Meldingen & popups
		----------------------------------------------------------------
		AddHeader("SET_CAT_ALERTS")
		AddToggle("mh_accessAlert", "SET_ACCESSALERT_TITLE", "SET_ACCESSALERT_DESC", function()
			return ns.AccessibleAlertsEnabled and ns.AccessibleAlertsEnabled()
		end, function(v)
			if ns.SetAccessibleAlertsEnabled then ns.SetAccessibleAlertsEnabled(v) end
		end, false)
		AddToggle("mh_rareAlert", "SETTINGS_RARE_ALERT", "SETTINGS_RARE_ALERT_TT", function()
			local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
			return not s or s.enabled ~= false
		end, function(v)
			if ns.SetRareAlertEnabled then ns.SetRareAlertEnabled(v) end
		end, true)
		AddToggle("mh_rareSound", "SET_RARE_SOUND", "SET_RARE_SOUND_DESC", function()
			local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
			return not s or s.sound ~= false
		end, function(v)
			local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
			if s then s.sound = v end
		end, true)
		AddToggle("mh_rareOnlyRoute", "SETTINGS_RARE_ALERT_ONLYROUTE", "SETTINGS_RARE_ALERT_ONLYROUTE_TT", function()
			local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
			return s and s.onlyWhileRouting == true
		end, function(v)
			if ns.SetRareAlertOnlyWhileRouting then ns.SetRareAlertOnlyWhileRouting(v) end
		end, false)
		AddToggle("mh_shardCap", "SET_SHARDCAP_TOGGLE_TITLE", "SET_SHARDCAP_TOGGLE_DESC", function()
			return ns.IsShardCapAlertEnabled and ns.IsShardCapAlertEnabled()
		end, function(v)
			if ns.SetShardCapAlertEnabled then ns.SetShardCapAlertEnabled(v) end
		end, true)
		AddToggle("mh_apConsumables", "SET_AP_CONSUMABLES_TITLE", "SET_AP_CONSUMABLES_DESC", function()
			return ns.IsAutoPopupEnabled and ns.IsAutoPopupEnabled("consumables")
		end, function(v)
			if ns.SetAutoPopupEnabled then ns.SetAutoPopupEnabled("consumables", v) end
		end, true)


		--- ⚠️ These two existed only as `/mh tips`, a command listed nowhere. Rob met the
		--- popup mid-session and asked whether it was even ours; it was, and there was no
		--- way to look it up or refuse it. Anything that takes the screen has to be
		--- findable and refusable before it may be on by default -- so it is now both, and
		--- it defaults to off.
		AddToggle("mh_growthTips", "SET_GROWTH_TIPS_TITLE", "SET_GROWTH_TIPS_DESC", function()
			return ns.IsGrowthTipsEnabled and ns.IsGrowthTipsEnabled()
		end, function(v)
			if ns.SetGrowthTipsEnabled then ns.SetGrowthTipsEnabled(v) end
		end, false)
		AddToggle("mh_growthPopup", "SET_GROWTH_POPUP_TITLE", "SET_GROWTH_POPUP_DESC", function()
			return ns.IsGrowthPopupEnabled and ns.IsGrowthPopupEnabled()
		end, function(v)
			if ns.SetGrowthPopupEnabled then ns.SetGrowthPopupEnabled(v) end
		end, false)

		----------------------------------------------------------------
		-- Dungeon-hulp
		----------------------------------------------------------------
		AddHeader("SET_SEC_DUNGEON")
		AddToggle("mh_liveTips", "SET_LIVETIPS_TITLE", "SET_LIVETIPS_DESC", function()
			return ns.IsDungeonLiveTipsEnabled and ns.IsDungeonLiveTipsEnabled()
		end, function(v)
			if ns.SetDungeonLiveTipsEnabled then ns.SetDungeonLiveTipsEnabled(v) end
		end, true)
		AddToggle("mh_bossAuto", "SET_BOSSWIN_AUTO_TITLE", "SET_BOSSWIN_AUTO_DESC", function()
			return ns.IsBossWindowAutoOpenEnabledFor
				and ns.IsBossWindowAutoOpenEnabledFor("dungeon")
		end, function(v)
			if ns.SetBossWindowAutoOpenEnabledFor then
				ns.SetBossWindowAutoOpenEnabledFor("dungeon", v)
			end
		end, true)
		AddToggle("mh_bossAutoRitual", "SET_BOSSWIN_AUTO_RITUAL_TITLE",
			"SET_BOSSWIN_AUTO_RITUAL_DESC", function()
			return ns.IsBossWindowAutoOpenEnabledFor
				and ns.IsBossWindowAutoOpenEnabledFor("ritual")
		end, function(v)
			if ns.SetBossWindowAutoOpenEnabledFor then
				ns.SetBossWindowAutoOpenEnabledFor("ritual", v)
			end
		end, true)
		AddToggle("mh_bossAutoRaid", "SET_BOSSWIN_AUTO_RAID_TITLE",
			"SET_BOSSWIN_AUTO_RAID_DESC", function()
			return ns.IsBossWindowAutoOpenEnabledFor
				and ns.IsBossWindowAutoOpenEnabledFor("raid")
		end, function(v)
			if ns.SetBossWindowAutoOpenEnabledFor then
				ns.SetBossWindowAutoOpenEnabledFor("raid", v)
			end
		end, true)
		-- Recommended OFF since 14 Sep 2026: the module's own default is off
		-- (IsBossWindowModelEnabled reads showModel == true), and Recommended used to switch it back on.
		AddToggle("mh_bossModel", "SET_BOSSWIN_MODEL_TITLE", "SET_BOSSWIN_MODEL_DESC", function()
			return ns.IsBossWindowModelEnabled and ns.IsBossWindowModelEnabled()
		end, function(v)
			if ns.SetBossWindowModelEnabled then ns.SetBossWindowModelEnabled(v) end
		end, false)
		AddToggle("mh_bossSpotlight", "SET_BOSSWIN_SPOTLIGHT_TITLE", "SET_BOSSWIN_SPOTLIGHT_DESC", function()
			return ns.IsBossWindowThumbEnabled and ns.IsBossWindowThumbEnabled()
		end, function(v)
			if ns.SetBossWindowThumbEnabled then ns.SetBossWindowThumbEnabled(v) end
		end, true)
		-- Rob, 15 Sep 2026: "eli10 versie?" Short tips in the boss window, on by default.
		AddToggle("mh_bossShortTips", "SET_BOSSWIN_SHORT_TITLE", "SET_BOSSWIN_SHORT_DESC", function()
			return ns.IsBossWindowShortTipsEnabled and ns.IsBossWindowShortTipsEnabled()
		end, function(v)
			if ns.SetBossWindowShortTipsEnabled then ns.SetBossWindowShortTipsEnabled(v) end
		end, true)
		-- Rob, 15 Sep 2026: tips for your own difficulty ("manier B"), on by default.
		AddToggle("mh_bossDiffFilter", "SET_BOSSWIN_DIFF_TITLE", "SET_BOSSWIN_DIFF_DESC", function()
			return ns.IsBossWindowDiffFilterEnabled and ns.IsBossWindowDiffFilterEnabled()
		end, function(v)
			if ns.SetBossWindowDiffFilterEnabled then ns.SetBossWindowDiffFilterEnabled(v) end
		end, true)
		AddSlider("mh_bossScale", "SET_BOSSWIN_SCALE", nil, 0.7, 1.8, 0.1, function()
			return ns.GetBossWindowScale and ns.GetBossWindowScale()
		end, function(v)
			if ns.SetBossWindowScale then ns.SetBossWindowScale(v) end
		end, function(v)
			return ("%.1f"):format(v)
		end, 1.0)
		AddToggle("mh_consReady", "SET_CONSREADY_TOGGLE_TITLE", "SET_CONSREADY_TOGGLE_DESC", function()
			return ns.IsConsumableReadyCheckEnabled and ns.IsConsumableReadyCheckEnabled()
		end, function(v)
			if ns.SetConsumableReadyCheckEnabled then ns.SetConsumableReadyCheckEnabled(v) end
		end, true)

		----------------------------------------------------------------
		-- Schermknoppen
		----------------------------------------------------------------
		AddHeader("SET_SEC_SCREEN")
		AddToggle("mh_openables", "SET_OPEN_TOGGLE_TITLE", "SET_OPEN_TOGGLE_DESC", function()
			return ns.IsOpenablesEnabled and ns.IsOpenablesEnabled()
		end, function(v)
			if ns.SetOpenablesEnabled then ns.SetOpenablesEnabled(v) end
		end, true)
		AddToggle("mh_fastMark", "SET_MARK_TOGGLE_TITLE", "SET_MARK_TOGGLE_DESC", function()
			return ns.IsFastMarkEnabled and ns.IsFastMarkEnabled()
		end, function(v)
			if ns.SetFastMarkEnabled then ns.SetFastMarkEnabled(v) end
		end, true)
		-- Side panels appear beside Blizzard's own windows uninvited, which is pushier
		-- than a tab the player chose to open. Off means off: the setter hides them on
		-- the spot rather than waiting for the next window.
		AddToggle("mh_sidePanels", "SET_SIDEPANELS_TITLE", "SET_SIDEPANELS_DESC", function()
			return ns.AreSidePanelsEnabled and ns.AreSidePanelsEnabled()
		end, function(v)
			if ns.SetSidePanelsEnabled then ns.SetSidePanelsEnabled(v) end
		end, true)
		-- Without this the daily tip can only be waved away one day at a time, which
		-- is a nag rather than a choice.
		AddToggle("mh_dailyTip", "SET_DAILYTIP_TITLE", "SET_DAILYTIP_DESC", function()
			return not (ns.db and ns.db.dailyTip and ns.db.dailyTip.enabled == false)
		end, function(v)
			ns.db = ns.db or {}
			ns.db.dailyTip = ns.db.dailyTip or {}
			ns.db.dailyTip.enabled = v and true or false
			if ns.RefreshHomePanel then pcall(ns.RefreshHomePanel) end
		end, true)

		----------------------------------------------------------------
		-- Route-pijl
		----------------------------------------------------------------
		AddHeader("SET_SEC_ARROW")
		local aB = ns.NativeArrowSizeBounds or { min = 28, max = 160, default = 64 }
		AddSlider("mh_arrowSize", "SET_ARROWSIZE_TITLE", "SET_ARROWSIZE_DESC", aB.min, aB.max, 4, function()
			return ns.GetNativeArrowSize and ns.GetNativeArrowSize()
		end, function(v)
			if ns.SetNativeArrowSize then ns.SetNativeArrowSize(v) end
			if ns.PreviewNativeArrow then ns.PreviewNativeArrow(3) end
		end, function(v)
			return tostring(math.floor(v + 0.5))
		end, aB.default)
		AddToggle("mh_arrowMeters", "SET_ARROWUNIT_TITLE", "SET_ARROWUNIT_DESC", function()
			return ns.GetNativeArrowMeters and ns.GetNativeArrowMeters()
		end, function(v)
			if ns.SetNativeArrowMeters then ns.SetNativeArrowMeters(v) end
			if ns.PreviewNativeArrow then ns.PreviewNativeArrow(3) end
		end, false) -- expliciete default (yards); niet de toevallige login-waarde (F4.6)
		--- Rob, 5 sep: "zet hem standaard op uit zodat mensen bewust kiezen om hem wel te
		--- krijgen." Uit = wat iedereen nu al heeft (waarschuwen én toch de route zetten),
		--- dus een update verandert niets onder iemands handen; aan = de addon houdt je
		--- tegen. De waarschuwing zelf staat er los van en is niet uit te zetten — die is
		--- er juist gekomen omdat hij ontbrak.
		AddToggle("mh_zoneGateBlock", "SET_ZONEGATE_BLOCK_TITLE", "SET_ZONEGATE_BLOCK_DESC", function()
			return ns.IsZoneGateBlockEnabled and ns.IsZoneGateBlockEnabled()
		end, function(v)
			if ns.SetZoneGateBlockEnabled then ns.SetZoneGateBlockEnabled(v) end
		end, false) -- expliciete default (uit); niet de toevallige login-waarde (F4.6)

		----------------------------------------------------------------
		-- Venster & weergave
		----------------------------------------------------------------
		AddHeader("SET_SEC_WINDOW")
		AddToggle("mh_openLogin", "SETTINGS_OPEN_ON_LOGIN", nil, function()
			return ns.db and ns.db.ui and ns.db.ui.openOnLogin
		end, function(v)
			if ns.db and ns.db.ui then ns.db.ui.openOnLogin = v end
		end, false) -- expliciete default (uit); niet de toevallige login-waarde (F4.6)
		AddToggle("mh_compact", "SETTINGS_COMPACT_MODE", nil, function()
			return ns.IsCompactModeEnabled and ns:IsCompactModeEnabled()
		end, function(v)
			if ns.SetCompactModeEnabled then ns:SetCompactModeEnabled(v, true) end
		end, false) -- expliciete default (uit); niet de toevallige login-waarde (F4.6)
		-- 4.0: de weg terug naar de 3.x-look (Spec 37 §6a). "Aanbevolen" zet hem uit = nieuwe look.
		AddToggle("mh_classicLook", "SETTINGS_CLASSIC_LOOK", "SETTINGS_CLASSIC_LOOK_TT", function()
			return ns.IsClassicLookEnabled and ns:IsClassicLookEnabled()
		end, function(v)
			if ns.SetClassicLookEnabled then ns:SetClassicLookEnabled(v) end
		end, false)
		AddToggle("mh_minimapIcon", "SETTINGS_MINIMAP_ICON", "SETTINGS_MINIMAP_ICON_TT", function()
			return ns.IsMinimapIconShown and ns.IsMinimapIconShown()
		end, function(v)
			if ns.SetMinimapIconShown then ns.SetMinimapIconShown(v) end
		end, true)
		--- Sits right under the minimap toggle on purpose: it is the answer for players
		--- whose minimap button disappeared into a button-collector addon, which is how
		--- Rob lost reach of the shift-click reload.
		AddToggle("mh_quickBar", "SETTINGS_QUICKBAR", "SETTINGS_QUICKBAR_TT", function()
			return ns.IsQuickBarShown and ns.IsQuickBarShown()
		end, function(v)
			if ns.SetQuickBarShown then ns.SetQuickBarShown(v) end
		end, false)
		AddSlider("mh_fontScale", "SETTINGS_TEXT_SIZE_LABEL", "SETTINGS_TEXT_SIZE_DESC", 0.8, 1.6, 0.1, function()
			return ns.GetContentFontScale and ns.GetContentFontScale()
		end, function(v)
			if ns.ApplyContentFontScale then ns.ApplyContentFontScale(v) end
		end, function(v)
			return ("%d%%"):format(math.floor(v * 100 + 0.5))
		end, 1.0)
		AddDropdown("mh_guideMode", "SETTINGS_GUIDE_LABEL", "SETTINGS_HINT", "auto", {
			{ value = "auto", labelKey = "SETTINGS_GUIDE_MODE_AUTO" },
			{ value = "always", labelKey = "SETTINGS_GUIDE_MODE_ALWAYS" },
			{ value = "hidden", labelKey = "SETTINGS_GUIDE_MODE_HIDDEN" },
		}, function()
			return ns.GetGuideVisibilityMode and ns:GetGuideVisibilityMode()
		end, function(v)
			if ns.SetGuideVisibilityMode then ns:SetGuideVisibilityMode(v) end
		end, "auto")
		-- (4.0: de beta-tab-vinkjes — master + Codex/Basics/Guide/Macros/Academy — zijn opgegaan in
		-- de subcategorie "Screens" hieronder: één schakelaar per scherm. Core.lua-migratie v2 zet
		-- wie er een uit had staan over naar ui.hiddenScreens.)

		----------------------------------------------------------------
		-- Great Vault
		----------------------------------------------------------------
		AddHeader("SET_CAT_VAULT")
		local vaultSubs = {
			{ var = "mh_vaultEnabled", key = "enabled", name = "SETTINGS_VAULT_REMINDER_ENABLED" },
			{ var = "mh_vaultChat", key = "chat", name = "SETTINGS_VAULT_REMINDER_CHAT" },
			{ var = "mh_vaultMinimap", key = "minimap", name = "SETTINGS_VAULT_REMINDER_MINIMAP" },
			{ var = "mh_vaultPing", key = "ping", name = "SETTINGS_VAULT_REMINDER_PING" },
			{ var = "mh_vaultPopup", key = "popup", name = "SETTINGS_VAULT_REMINDER_POPUP" },
		}
		for _, sub in ipairs(vaultSubs) do
			local vKey = sub.key
			AddToggle(sub.var, sub.name, sub.name .. "_TT", function()
				local vs = ns.GetVaultReminderSettings and ns.GetVaultReminderSettings() or {}
				return vs[vKey] ~= false
			end, function(v)
				if ns.SetVaultReminderOption then ns.SetVaultReminderOption(vKey, v) end
			end, true)
		end
		AddToggle("mh_vaultBlizzard", "SETTINGS_VAULT_ADVISOR_SHOW_BLIZZARD", "SETTINGS_VAULT_ADVISOR_SHOW_BLIZZARD_TT", function()
			local vas = ns.GetVaultAdvisorSettings and ns.GetVaultAdvisorSettings() or {}
			return vas.showBlizzardPanel ~= false
		end, function(v)
			if ns.SetVaultAdvisorOption then ns.SetVaultAdvisorOption("showBlizzardPanel", v) end
			if ns.RefreshBlizzardVaultBanner then ns.RefreshBlizzardVaultBanner() end
		end, true)
		AddToggle("mh_vaultPawn", "SETTINGS_VAULT_ADVISOR_USE_PAWN", "SETTINGS_VAULT_ADVISOR_USE_PAWN_TT", function()
			local vas = ns.GetVaultAdvisorSettings and ns.GetVaultAdvisorSettings() or {}
			return vas.usePawn ~= false
		end, function(v)
			if ns.SetVaultAdvisorOption then ns.SetVaultAdvisorOption("usePawn", v) end
		end, true)
		AddDropdown("mh_vaultProfile", "SETTINGS_VAULT_ADVISOR_PROFILE_LABEL", nil, "auto", {
			{ value = "auto", labelKey = "SETTINGS_VAULT_ADVISOR_PROFILE_AUTO" },
			{ value = "raid", labelKey = "SETTINGS_VAULT_ADVISOR_PROFILE_RAID" },
			{ value = "mplus", labelKey = "SETTINGS_VAULT_ADVISOR_PROFILE_MPLUS_BTN" },
		}, function()
			local vas = ns.GetVaultAdvisorSettings and ns.GetVaultAdvisorSettings() or {}
			return vas.profileMode or "auto"
		end, function(v)
			if ns.SetVaultAdvisorOption then ns.SetVaultAdvisorOption("profileMode", v) end
			if ns.RefreshBlizzardVaultBanner then ns.RefreshBlizzardVaultBanner() end
		end, "auto")

		----------------------------------------------------------------
		-- Geavanceerd
		----------------------------------------------------------------
		AddHeader("SET_CAT_ADVANCED")
		AddToggle("mh_debug", "SET_ADV_DEBUG", "SET_ADV_DEBUG_DESC", function()
			return ns.db and ns.db.ui and ns.db.ui.debug
		end, function(v)
			if ns.db and ns.db.ui then ns.db.ui.debug = v and true or nil end
		end, false)

		----------------------------------------------------------------
		-- Screens (4.0). Rob, 13 Sep 2026: "waarom laten we ze zelf niet dingen aan en uit
		-- zetten". One checkbox per screen, room by room; unticked = hidden from the room cards,
		-- the sidebar and the favourites menu (ns.SetScreenHidden, Core.lua). Not in the
		-- Recommended preset: that would undo a player's own choices. The Basics category inside
		-- the Codex keeps its own switch here, under Codex.
		----------------------------------------------------------------
		local scrCat, scrLayout = category, layout
		if Settings.RegisterVerticalLayoutSubcategory then
			local okSub, sc, sl = pcall(Settings.RegisterVerticalLayoutSubcategory, category, L("SETTINGS_SCREENS_TITLE"))
			if okSub and sc then
				scrCat, scrLayout = sc, sl
				-- The layout as second return value is AFGELEID (the parent call returns one); without
				-- either route only the room headers go missing, the checkboxes still work.
				if not scrLayout and SettingsPanel and SettingsPanel.GetLayout then
					local okL, l = pcall(SettingsPanel.GetLayout, SettingsPanel, sc)
					if okL then
						scrLayout = l
					end
				end
			end
		end
		local function ScreenHeader(text)
			if scrLayout and scrLayout.AddInitializer and CreateSettingsListSectionHeaderInitializer then
				scrLayout:AddInitializer(CreateSettingsListSectionHeaderInitializer(text))
			end
		end
		local function ScreenToggle(variable, label, tipKey, getFn, setFn)
			local cur = true
			pcall(function()
				cur = getFn() and true or false
			end)
			proxy[variable] = cur
			local setting = Settings.RegisterAddOnSetting(scrCat, variable, variable, proxy, "boolean", label, true)
			Settings.SetOnValueChangedCallback(variable, function()
				pcall(setFn, proxy[variable] and true or false)
			end)
			Settings.CreateCheckbox(scrCat, setting, Tip(tipKey))
			settingObjs[variable] = setting
		end
		if scrCat == category then
			ScreenHeader(L("SETTINGS_SCREENS_TITLE"))
		end
		local roomLabel = { me = "SIDEBAR_ROOM_ME", codex = "SIDEBAR_ROOM_CODEX", tools = "SIDEBAR_ROOM_TOOLS" }
		local screens = ns.GetHideableScreens and ns.GetHideableScreens() or {}
		for _, room in ipairs({ "me", "codex", "tools" }) do
			local headed = false
			for _, s in ipairs(screens) do
				if s.room == room then
					if not headed then
						ScreenHeader(L(roomLabel[room]))
						headed = true
					end
					local sid = s.id
					ScreenToggle("mh_screen_" .. sid, L(s.labelKey), "SETTINGS_SCREEN_TT", function()
						return not (ns.IsScreenHidden and ns.IsScreenHidden(sid))
					end, function(v)
						if ns.SetScreenHidden then ns.SetScreenHidden(sid, not v) end
					end)
				end
			end
			if room == "codex" then
				ScreenToggle("mh_betaReference", L("TAB_CODEX") .. ": " .. L("SETTINGS_BETA_TAB_REFERENCE"),
					"SETTINGS_BETA_TAB_REFERENCE_TT", function()
						local bt = ns.GetBetaTabsSettings and ns.GetBetaTabsSettings() or {}
						return bt.enabled ~= false and bt.reference ~= false
					end, function(v)
						if ns.SetBetaTabOption then ns.SetBetaTabOption("reference", v) end
					end)
			end
		end

		----------------------------------------------------------------
		-- Achievements — per-achievement zichtbaarheid (vinkje aan = kaart wordt
		-- getoond in de Achievements-tab). Veel meta's over de nieuwe zones, dus
		-- een eigen subcategorie houdt de hoofdpagina schoon. Valt terug op een
		-- sectie in de hoofdcategorie als de vertical-subcategorie-API ontbreekt.
		----------------------------------------------------------------
		local achCat = category
		if Settings.RegisterVerticalLayoutSubcategory then
			local okSub, sc = pcall(Settings.RegisterVerticalLayoutSubcategory, category, L("TAB_ACHIEVEMENTS"))
			if okSub and sc then
				achCat = sc
			end
		end
		if achCat == category then
			AddHeader("TAB_ACHIEVEMENTS")
		end

		do
			local variable = "mh_achAutoHide"
			local cur = false
			pcall(function()
				cur = ns.IsAchAutoHideDoneEnabled and ns.IsAchAutoHideDoneEnabled() or false
			end)
			proxy[variable] = cur
			local setting = Settings.RegisterAddOnSetting(
				achCat, variable, variable, proxy, "boolean", L("SET_ACH_AUTOHIDE_TITLE"), cur
			)
			Settings.SetOnValueChangedCallback(variable, function()
				if ns.SetAchAutoHideDoneEnabled then
					ns.SetAchAutoHideDoneEnabled(proxy[variable] and true or false)
				end
			end)
			Settings.CreateCheckbox(achCat, setting, Tip("SET_ACH_AUTOHIDE_DESC"))
			settingObjs[variable] = setting
		end

		for _, entry in ipairs(ns.ACHIEVEMENT_TREASURES or {}) do
			local id = entry.achievementID
			if id then
				local variable = "mh_ach_" .. id
				local name = entry.nameKey and L(entry.nameKey)
				if not name or name == entry.nameKey then
					name = (ns.AchievementDisplayName and ns.AchievementDisplayName(entry)) or tostring(id)
				end
				local cur = not (ns.IsAchievementHidden and ns.IsAchievementHidden(id))
				proxy[variable] = cur
				local setting = Settings.RegisterAddOnSetting(
					achCat, variable, variable, proxy, "boolean", name, true
				)
				Settings.SetOnValueChangedCallback(variable, function()
					if ns.SetAchievementHidden then
						ns.SetAchievementHidden(id, not (proxy[variable] and true or false))
					end
				end)
				Settings.CreateCheckbox(achCat, setting, nil)
				settingObjs[variable] = setting
				-- Not in the Recommended preset (Rob, 14 Sep 2026: "Ja dus"): which achievements show is
				-- the player's own choice, like the Screens list. It used to show every hidden one again.
			end
		end

		Settings.RegisterAddOnCategory(category)
	end)

	if not ok then
		local prefix = (ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper"
		print(("|cffff0000%s:|r native settings registration failed: %s"):format(prefix, tostring(err)))
	end
end

--------------------------------------------------------------------------------
-- Aanbevolen stand toepassen (launcher-knop). Drijft via de native settings zodat
-- zowel de echte setters als de zichtbare controls meteen meelopen. Doet
-- hetzelfde als Blizzards rode "Defaults"-knop, maar laat taal/venster/grootte
-- met rust (alleen de functie-toggles in `recommended`).
--------------------------------------------------------------------------------

--- A screen was hidden or shown outside this panel (right-click on a room card): mirror it, so
--- the checkbox is right the next time the Screens page is drawn. Writes the proxy directly;
--- going through SetValue would call SetScreenHidden again.
function ns.SyncNativeScreenSetting(id, shown)
	-- "reference" is the Codex Basics category, which kept its old setting name.
	local variable = (id == "reference") and "mh_betaReference" or ("mh_screen_" .. tostring(id))
	if proxy[variable] ~= nil then
		proxy[variable] = shown and true or false
	end
end

--- The player's own layout, not a feature preference: Recommended leaves these alone, as the note
--- above and SET_RECOMMENDED_TT always promised. Until 14 Sep 2026 it did not. It also put Classic,
--- compact mode, text size, the minimap icon, the quick bar, the guide mode and the arrow and boss
--- window sizes back, so a Classic player who pressed it lost the Classic look. Blizzard's own
--- Defaults button still resets everything; that is what "defaults" means there.
local KEEP_ON_RECOMMENDED = {
	mh_openLogin = true,
	mh_compact = true,
	mh_classicLook = true,
	mh_minimapIcon = true,
	mh_quickBar = true,
	mh_fontScale = true,
	mh_guideMode = true,
	mh_arrowSize = true,
	mh_arrowMeters = true,
	mh_bossScale = true,
}

function ns.ApplyRecommendedSettings()
	for variable, val in pairs(recommended) do
		local s = settingObjs[variable]
		if s and s.SetValue and not KEEP_ON_RECOMMENDED[variable] then
			pcall(s.SetValue, s, val)
		end
	end
	return true
end

--------------------------------------------------------------------------------
-- Openen (launcher-knop + /mh settings)
--------------------------------------------------------------------------------

function ns.OpenNativeSettings()
	-- Opening the Blizzard settings calls the protected OpenSettingsPanel(), which is
	-- blocked in combat (ADDON_ACTION_BLOCKED). Don't attempt it; tell the player instead.
	if InCombatLockdown and InCombatLockdown() then
		if ns.PrintChat then
			ns:PrintChat(ns:L("SETTINGS_COMBAT_BLOCKED"))
		end
		return false
	end
	if Settings and Settings.OpenToCategory and ns.settingsCategory then
		Settings.OpenToCategory(ns.settingsCategory:GetID())
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Registreer op PLAYER_LOGIN (alle modules + ns.db geladen; getters kloppen).
--------------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	ns.RegisterNativeSettings()
end)
