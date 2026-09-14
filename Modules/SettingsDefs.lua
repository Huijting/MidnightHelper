--[[
	Midnight Helper — every setting in one list (4.0 follow-up, "nummer 3").

	Rob, 13 Sep 2026: "moet zo een settings screen niet gewoon in MH??" -> "doe maar nummer 2, en
	later nummer 3"; 14 Sep: "Go voor 1" (build it on its own branch, merge after 4.0.0).

	Until now these definitions lived inline in Modules/NativeSettings.lua, as calls that built
	Blizzard's panel directly. They are data here so two views can draw the same list: Blizzard's
	Settings panel (NativeSettings.lua) and MH's own page (SettingsPage.lua). One list means the two
	can never offer different settings, and ns.db stays the only truth: every entry reads through
	`get` and writes through `set`, the same functions as before the move.

	Built on first use, not at load: some entries read values another module provides (the route
	arrow's size bounds), and NativeSettings asks at PLAYER_LOGIN, when every module is loaded.

	The Screens and Achievements lists are not in here. They are generated from other data (the
	hideable screens, ns.ACHIEVEMENT_TREASURES) and already have their own pages.

	Entry fields:
	  kind      "toggle" | "slider" | "dropdown"
	  var       the Blizzard setting variable, unchanged from 3.x
	  name/tip  locale keys (tip may be nil)
	  rec       the Recommended value; nil = not part of the Recommended preset
	  get/set   the existing ns getters and setters
	  slider:   min, max, step, fmt(value) -> text
	  dropdown: default, options = { { value = ..., labelKey = ... }, ... }
]]

local _, ns = ...

local defs

local function Build()
	local list = {}
	local section

	local function Header(key)
		section = { header = key, items = {} }
		list[#list + 1] = section
	end

	local function Toggle(var, name, tip, get, set, rec)
		section.items[#section.items + 1] = { kind = "toggle", var = var, name = name, tip = tip, get = get, set = set, rec = rec }
	end

	local function Slider(var, name, tip, min, max, step, get, set, fmt, rec)
		section.items[#section.items + 1] = {
			kind = "slider", var = var, name = name, tip = tip,
			min = min, max = max, step = step, get = get, set = set, fmt = fmt, rec = rec,
		}
	end

	local function Dropdown(var, name, tip, default, options, get, set, rec)
		section.items[#section.items + 1] = {
			kind = "dropdown", var = var, name = name, tip = tip,
			default = default, options = options, get = get, set = set, rec = rec,
		}
	end

	----------------------------------------------------------------
	-- Taal / Language (bovenaan: Rob speelt Engels, zijn zus Nederlands —
	-- de taalkeuze moet meteen zichtbaar zijn). De rode "Defaults"-knop van
	-- Blizzard zet alles op de aanbevolen stand (we registreren de aanbevolen
	-- waarden immers als default).
	----------------------------------------------------------------
	Header("SETTINGS_LANGUAGE_LABEL")
	Dropdown("mh_locale", "SETTINGS_LANGUAGE_LABEL", "SET_LANG_RELOAD_TT", "auto", {
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
	Header("SET_SEC_COMBAT")
	Toggle("mh_combatSafety", "SET_CS_TOGGLE_TITLE", "SET_CS_TOGGLE_DESC", function()
		return ns.IsCombatSafetyEnabled and ns.IsCombatSafetyEnabled()
	end, function(v)
		if ns.SetCombatSafetyEnabled then ns.SetCombatSafetyEnabled(v) end
	end, true)
	-- Party targets sits under Combat because that is when it earns its place --
	-- and because the same combat edge is what limits it. Recommended OFF: it is
	-- another frame on screen, and MH does not decide that for you.
	Toggle("mh_partyTargets", "SET_PARTYTARGETS_TITLE", "SET_PARTYTARGETS_DESC", function()
		return ns.IsPartyTargetsEnabled and ns.IsPartyTargetsEnabled()
	end, function(v)
		if ns.SetPartyTargetsEnabled then ns.SetPartyTargetsEnabled(v) end
	end, false)
	-- ⚠️ Hier stonden 18 aug twee brace-prompt-schakelaars. Ze zijn dezelfde dag weer
	-- weggehaald: 12.1 geeft geen enkel leesbaar kenmerk van een vijandelijke cast
	-- meer (spell-id, npc-id, icoon en begin-/eindtijd allemaal secret), dus de
	-- prompt kon niet zeggen WELKE cast hij bedoelde. Zie de uitleg bij /mh brace in
	-- Core.lua. De inhoud staat nu in de Delve Coach bij The Ring of Glory.
	Toggle("mh_csSpeak", "SET_CS_SPEAK_TITLE", "SET_CS_SPEAK_DESC", function()
		return ns.IsCombatSafetySpeakEnabled and ns.IsCombatSafetySpeakEnabled()
	end, function(v)
		if ns.SetCombatSafetySpeakEnabled then ns.SetCombatSafetySpeakEnabled(v) end
	end, false)
	Toggle("mh_csBars", "SET_CS_BARS_TITLE", "SET_CS_BARS_DESC", function()
		return ns.IsCombatSafetyBarsEnabled and ns.IsCombatSafetyBarsEnabled()
	end, function(v)
		if ns.SetCombatSafetyBarsEnabled then ns.SetCombatSafetyBarsEnabled(v) end
	end, false)
	Toggle("mh_csImportant", "SET_CS_IMPORTANT_TITLE", "SET_CS_IMPORTANT_DESC", function()
		return ns.IsCombatSafetyImportantOnly and ns.IsCombatSafetyImportantOnly()
	end, function(v)
		if ns.SetCombatSafetyImportantOnly then ns.SetCombatSafetyImportantOnly(v) end
	end, false)
	-- Death Recap auto-open (restricted content only). Recommended ON: it exists for
	-- beginners who die in a delve/ritual and have no other way to learn the cause.
	Toggle("mh_deathAutoOpen", "SET_DEATH_AUTOOPEN_TITLE", "SET_DEATH_AUTOOPEN_DESC", function()
		return ns.IsDeathRecapAutoOpenEnabled and ns.IsDeathRecapAutoOpenEnabled()
	end, function(v)
		if ns.SetDeathRecapAutoOpenEnabled then ns.SetDeathRecapAutoOpenEnabled(v) end
	end, true)
	Toggle("mh_missingBuff", "SET_MBUFF_TOGGLE_TITLE", "SET_MBUFF_TOGGLE_DESC", function()
		return ns.IsMissingBuffEnabled and ns.IsMissingBuffEnabled()
	end, function(v)
		if ns.SetMissingBuffEnabled then ns.SetMissingBuffEnabled(v) end
	end, true)

	----------------------------------------------------------------
	-- Meldingen & popups
	----------------------------------------------------------------
	Header("SET_CAT_ALERTS")
	Toggle("mh_accessAlert", "SET_ACCESSALERT_TITLE", "SET_ACCESSALERT_DESC", function()
		return ns.AccessibleAlertsEnabled and ns.AccessibleAlertsEnabled()
	end, function(v)
		if ns.SetAccessibleAlertsEnabled then ns.SetAccessibleAlertsEnabled(v) end
	end, false)
	Toggle("mh_rareAlert", "SETTINGS_RARE_ALERT", "SETTINGS_RARE_ALERT_TT", function()
		local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
		return not s or s.enabled ~= false
	end, function(v)
		if ns.SetRareAlertEnabled then ns.SetRareAlertEnabled(v) end
	end, true)
	Toggle("mh_rareSound", "SET_RARE_SOUND", "SET_RARE_SOUND_DESC", function()
		local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
		return not s or s.sound ~= false
	end, function(v)
		local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
		if s then s.sound = v end
	end, true)
	Toggle("mh_rareOnlyRoute", "SETTINGS_RARE_ALERT_ONLYROUTE", "SETTINGS_RARE_ALERT_ONLYROUTE_TT", function()
		local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
		return s and s.onlyWhileRouting == true
	end, function(v)
		if ns.SetRareAlertOnlyWhileRouting then ns.SetRareAlertOnlyWhileRouting(v) end
	end, false)
	Toggle("mh_shardCap", "SET_SHARDCAP_TOGGLE_TITLE", "SET_SHARDCAP_TOGGLE_DESC", function()
		return ns.IsShardCapAlertEnabled and ns.IsShardCapAlertEnabled()
	end, function(v)
		if ns.SetShardCapAlertEnabled then ns.SetShardCapAlertEnabled(v) end
	end, true)
	Toggle("mh_apConsumables", "SET_AP_CONSUMABLES_TITLE", "SET_AP_CONSUMABLES_DESC", function()
		return ns.IsAutoPopupEnabled and ns.IsAutoPopupEnabled("consumables")
	end, function(v)
		if ns.SetAutoPopupEnabled then ns.SetAutoPopupEnabled("consumables", v) end
	end, true)
	--- ⚠️ These two existed only as `/mh tips`, a command listed nowhere. Rob met the
	--- popup mid-session and asked whether it was even ours; it was, and there was no
	--- way to look it up or refuse it. Anything that takes the screen has to be
	--- findable and refusable before it may be on by default -- so it is now both, and
	--- it defaults to off.
	Toggle("mh_growthTips", "SET_GROWTH_TIPS_TITLE", "SET_GROWTH_TIPS_DESC", function()
		return ns.IsGrowthTipsEnabled and ns.IsGrowthTipsEnabled()
	end, function(v)
		if ns.SetGrowthTipsEnabled then ns.SetGrowthTipsEnabled(v) end
	end, false)
	Toggle("mh_growthPopup", "SET_GROWTH_POPUP_TITLE", "SET_GROWTH_POPUP_DESC", function()
		return ns.IsGrowthPopupEnabled and ns.IsGrowthPopupEnabled()
	end, function(v)
		if ns.SetGrowthPopupEnabled then ns.SetGrowthPopupEnabled(v) end
	end, false)

	----------------------------------------------------------------
	-- Dungeon-hulp
	----------------------------------------------------------------
	Header("SET_SEC_DUNGEON")
	Toggle("mh_liveTips", "SET_LIVETIPS_TITLE", "SET_LIVETIPS_DESC", function()
		return ns.IsDungeonLiveTipsEnabled and ns.IsDungeonLiveTipsEnabled()
	end, function(v)
		if ns.SetDungeonLiveTipsEnabled then ns.SetDungeonLiveTipsEnabled(v) end
	end, true)
	Toggle("mh_bossAuto", "SET_BOSSWIN_AUTO_TITLE", "SET_BOSSWIN_AUTO_DESC", function()
		return ns.IsBossWindowAutoOpenEnabledFor and ns.IsBossWindowAutoOpenEnabledFor("dungeon")
	end, function(v)
		if ns.SetBossWindowAutoOpenEnabledFor then ns.SetBossWindowAutoOpenEnabledFor("dungeon", v) end
	end, true)
	Toggle("mh_bossAutoRitual", "SET_BOSSWIN_AUTO_RITUAL_TITLE", "SET_BOSSWIN_AUTO_RITUAL_DESC", function()
		return ns.IsBossWindowAutoOpenEnabledFor and ns.IsBossWindowAutoOpenEnabledFor("ritual")
	end, function(v)
		if ns.SetBossWindowAutoOpenEnabledFor then ns.SetBossWindowAutoOpenEnabledFor("ritual", v) end
	end, true)
	Toggle("mh_bossAutoRaid", "SET_BOSSWIN_AUTO_RAID_TITLE", "SET_BOSSWIN_AUTO_RAID_DESC", function()
		return ns.IsBossWindowAutoOpenEnabledFor and ns.IsBossWindowAutoOpenEnabledFor("raid")
	end, function(v)
		if ns.SetBossWindowAutoOpenEnabledFor then ns.SetBossWindowAutoOpenEnabledFor("raid", v) end
	end, true)
	Toggle("mh_bossModel", "SET_BOSSWIN_MODEL_TITLE", "SET_BOSSWIN_MODEL_DESC", function()
		return ns.IsBossWindowModelEnabled and ns.IsBossWindowModelEnabled()
	end, function(v)
		if ns.SetBossWindowModelEnabled then ns.SetBossWindowModelEnabled(v) end
	end, true)
	Toggle("mh_bossSpotlight", "SET_BOSSWIN_SPOTLIGHT_TITLE", "SET_BOSSWIN_SPOTLIGHT_DESC", function()
		return ns.IsBossWindowThumbEnabled and ns.IsBossWindowThumbEnabled()
	end, function(v)
		if ns.SetBossWindowThumbEnabled then ns.SetBossWindowThumbEnabled(v) end
	end, true)
	Slider("mh_bossScale", "SET_BOSSWIN_SCALE", nil, 0.7, 1.8, 0.1, function()
		return ns.GetBossWindowScale and ns.GetBossWindowScale()
	end, function(v)
		if ns.SetBossWindowScale then ns.SetBossWindowScale(v) end
	end, function(v)
		return ("%.1f"):format(v)
	end, 1.0)
	Toggle("mh_consReady", "SET_CONSREADY_TOGGLE_TITLE", "SET_CONSREADY_TOGGLE_DESC", function()
		return ns.IsConsumableReadyCheckEnabled and ns.IsConsumableReadyCheckEnabled()
	end, function(v)
		if ns.SetConsumableReadyCheckEnabled then ns.SetConsumableReadyCheckEnabled(v) end
	end, true)

	----------------------------------------------------------------
	-- Schermknoppen
	----------------------------------------------------------------
	Header("SET_SEC_SCREEN")
	Toggle("mh_openables", "SET_OPEN_TOGGLE_TITLE", "SET_OPEN_TOGGLE_DESC", function()
		return ns.IsOpenablesEnabled and ns.IsOpenablesEnabled()
	end, function(v)
		if ns.SetOpenablesEnabled then ns.SetOpenablesEnabled(v) end
	end, true)
	Toggle("mh_fastMark", "SET_MARK_TOGGLE_TITLE", "SET_MARK_TOGGLE_DESC", function()
		return ns.IsFastMarkEnabled and ns.IsFastMarkEnabled()
	end, function(v)
		if ns.SetFastMarkEnabled then ns.SetFastMarkEnabled(v) end
	end, true)
	-- Side panels appear beside Blizzard's own windows uninvited, which is pushier
	-- than a tab the player chose to open. Off means off: the setter hides them on
	-- the spot rather than waiting for the next window.
	Toggle("mh_sidePanels", "SET_SIDEPANELS_TITLE", "SET_SIDEPANELS_DESC", function()
		return ns.AreSidePanelsEnabled and ns.AreSidePanelsEnabled()
	end, function(v)
		if ns.SetSidePanelsEnabled then ns.SetSidePanelsEnabled(v) end
	end, true)
	-- Without this the daily tip can only be waved away one day at a time, which
	-- is a nag rather than a choice.
	Toggle("mh_dailyTip", "SET_DAILYTIP_TITLE", "SET_DAILYTIP_DESC", function()
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
	Header("SET_SEC_ARROW")
	local aB = ns.NativeArrowSizeBounds or { min = 28, max = 160, default = 64 }
	Slider("mh_arrowSize", "SET_ARROWSIZE_TITLE", "SET_ARROWSIZE_DESC", aB.min, aB.max, 4, function()
		return ns.GetNativeArrowSize and ns.GetNativeArrowSize()
	end, function(v)
		if ns.SetNativeArrowSize then ns.SetNativeArrowSize(v) end
		if ns.PreviewNativeArrow then ns.PreviewNativeArrow(3) end
	end, function(v)
		return tostring(math.floor(v + 0.5))
	end, aB.default)
	Toggle("mh_arrowMeters", "SET_ARROWUNIT_TITLE", "SET_ARROWUNIT_DESC", function()
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
	Toggle("mh_zoneGateBlock", "SET_ZONEGATE_BLOCK_TITLE", "SET_ZONEGATE_BLOCK_DESC", function()
		return ns.IsZoneGateBlockEnabled and ns.IsZoneGateBlockEnabled()
	end, function(v)
		if ns.SetZoneGateBlockEnabled then ns.SetZoneGateBlockEnabled(v) end
	end, false) -- expliciete default (uit); niet de toevallige login-waarde (F4.6)

	----------------------------------------------------------------
	-- Venster & weergave
	----------------------------------------------------------------
	Header("SET_SEC_WINDOW")
	Toggle("mh_openLogin", "SETTINGS_OPEN_ON_LOGIN", nil, function()
		return ns.db and ns.db.ui and ns.db.ui.openOnLogin
	end, function(v)
		if ns.db and ns.db.ui then ns.db.ui.openOnLogin = v end
	end, false) -- expliciete default (uit); niet de toevallige login-waarde (F4.6)
	Toggle("mh_compact", "SETTINGS_COMPACT_MODE", nil, function()
		return ns.IsCompactModeEnabled and ns:IsCompactModeEnabled()
	end, function(v)
		if ns.SetCompactModeEnabled then ns:SetCompactModeEnabled(v, true) end
	end, false) -- expliciete default (uit); niet de toevallige login-waarde (F4.6)
	-- 4.0: de weg terug naar de 3.x-look (Spec 37 §6a). "Aanbevolen" zet hem uit = nieuwe look.
	Toggle("mh_classicLook", "SETTINGS_CLASSIC_LOOK", "SETTINGS_CLASSIC_LOOK_TT", function()
		return ns.IsClassicLookEnabled and ns:IsClassicLookEnabled()
	end, function(v)
		if ns.SetClassicLookEnabled then ns:SetClassicLookEnabled(v) end
	end, false)
	Toggle("mh_minimapIcon", "SETTINGS_MINIMAP_ICON", "SETTINGS_MINIMAP_ICON_TT", function()
		return ns.IsMinimapIconShown and ns.IsMinimapIconShown()
	end, function(v)
		if ns.SetMinimapIconShown then ns.SetMinimapIconShown(v) end
	end, true)
	--- Sits right under the minimap toggle on purpose: it is the answer for players
	--- whose minimap button disappeared into a button-collector addon, which is how
	--- Rob lost reach of the shift-click reload.
	Toggle("mh_quickBar", "SETTINGS_QUICKBAR", "SETTINGS_QUICKBAR_TT", function()
		return ns.IsQuickBarShown and ns.IsQuickBarShown()
	end, function(v)
		if ns.SetQuickBarShown then ns.SetQuickBarShown(v) end
	end, false)
	Slider("mh_fontScale", "SETTINGS_TEXT_SIZE_LABEL", "SETTINGS_TEXT_SIZE_DESC", 0.8, 1.6, 0.1, function()
		return ns.GetContentFontScale and ns.GetContentFontScale()
	end, function(v)
		if ns.ApplyContentFontScale then ns.ApplyContentFontScale(v) end
	end, function(v)
		return ("%d%%"):format(math.floor(v * 100 + 0.5))
	end, 1.0)
	Dropdown("mh_guideMode", "SETTINGS_GUIDE_LABEL", "SETTINGS_HINT", "auto", {
		{ value = "auto", labelKey = "SETTINGS_GUIDE_MODE_AUTO" },
		{ value = "always", labelKey = "SETTINGS_GUIDE_MODE_ALWAYS" },
		{ value = "hidden", labelKey = "SETTINGS_GUIDE_MODE_HIDDEN" },
	}, function()
		return ns.GetGuideVisibilityMode and ns:GetGuideVisibilityMode()
	end, function(v)
		if ns.SetGuideVisibilityMode then ns:SetGuideVisibilityMode(v) end
	end, "auto")
	-- (4.0: de beta-tab-vinkjes — master + Codex/Basics/Guide/Macros/Academy — zijn opgegaan in
	-- de subcategorie "Screens": één schakelaar per scherm. Core.lua-migratie v2 zet wie er een
	-- uit had staan over naar ui.hiddenScreens.)

	----------------------------------------------------------------
	-- Great Vault
	----------------------------------------------------------------
	Header("SET_CAT_VAULT")
	local vaultSubs = {
		{ var = "mh_vaultEnabled", key = "enabled", name = "SETTINGS_VAULT_REMINDER_ENABLED" },
		{ var = "mh_vaultChat", key = "chat", name = "SETTINGS_VAULT_REMINDER_CHAT" },
		{ var = "mh_vaultMinimap", key = "minimap", name = "SETTINGS_VAULT_REMINDER_MINIMAP" },
		{ var = "mh_vaultPing", key = "ping", name = "SETTINGS_VAULT_REMINDER_PING" },
		{ var = "mh_vaultPopup", key = "popup", name = "SETTINGS_VAULT_REMINDER_POPUP" },
	}
	for _, sub in ipairs(vaultSubs) do
		local vKey = sub.key
		Toggle(sub.var, sub.name, sub.name .. "_TT", function()
			local vs = ns.GetVaultReminderSettings and ns.GetVaultReminderSettings() or {}
			return vs[vKey] ~= false
		end, function(v)
			if ns.SetVaultReminderOption then ns.SetVaultReminderOption(vKey, v) end
		end, true)
	end
	Toggle("mh_vaultBlizzard", "SETTINGS_VAULT_ADVISOR_SHOW_BLIZZARD", "SETTINGS_VAULT_ADVISOR_SHOW_BLIZZARD_TT", function()
		local vas = ns.GetVaultAdvisorSettings and ns.GetVaultAdvisorSettings() or {}
		return vas.showBlizzardPanel ~= false
	end, function(v)
		if ns.SetVaultAdvisorOption then ns.SetVaultAdvisorOption("showBlizzardPanel", v) end
		if ns.RefreshBlizzardVaultBanner then ns.RefreshBlizzardVaultBanner() end
	end, true)
	Toggle("mh_vaultPawn", "SETTINGS_VAULT_ADVISOR_USE_PAWN", "SETTINGS_VAULT_ADVISOR_USE_PAWN_TT", function()
		local vas = ns.GetVaultAdvisorSettings and ns.GetVaultAdvisorSettings() or {}
		return vas.usePawn ~= false
	end, function(v)
		if ns.SetVaultAdvisorOption then ns.SetVaultAdvisorOption("usePawn", v) end
	end, true)
	Dropdown("mh_vaultProfile", "SETTINGS_VAULT_ADVISOR_PROFILE_LABEL", nil, "auto", {
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
	Header("SET_CAT_ADVANCED")
	Toggle("mh_debug", "SET_ADV_DEBUG", "SET_ADV_DEBUG_DESC", function()
		return ns.db and ns.db.ui and ns.db.ui.debug
	end, function(v)
		if ns.db and ns.db.ui then ns.db.ui.debug = v and true or nil end
	end, false)

	return list
end

--- The sections of Blizzard's main Midnight Helper category, in order. Built once, on first call.
function ns.GetSettingsDefs()
	if not defs then
		defs = Build()
	end
	return defs
end
