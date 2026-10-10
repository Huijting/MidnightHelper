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

--- For a switch whose module only offers a toggle (it also prints or redraws): flip only when the wanted state differs.
local function FlipTo(isOn, toggle, want)
	if type(isOn) ~= "function" or type(toggle) ~= "function" then
		return
	end
	local ok, cur = pcall(isOn)
	if ok and ((cur and true or false) ~= (want and true or false)) then
		pcall(toggle)
	end
end

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
	-- 9 Oct 2026 (Rob): count your own presses per spell; /mh presses shows them with their key.
	Toggle("mh_keyPresses", "SET_PRESSES_TITLE", "SET_PRESSES_DESC", function()
		return ns.IsKeyPressesEnabled and ns.IsKeyPressesEnabled()
	end, function(v)
		if ns.SetKeyPressesEnabled then ns.SetKeyPressesEnabled(v) end
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
	-- 6 Oct 2026 (Rob: "dit soort dingen ook als handige knop in de MH", command audit): switches that were
	-- slash-only. Not in the Recommended preset (rec nil): the player's own choice stays as it is.
	Toggle("mh_actionPrompt", "SET_PROMPT_TITLE", "SET_PROMPT_DESC", function()
		return ns.IsActionPromptEnabled and ns.IsActionPromptEnabled()
	end, function(v)
		FlipTo(ns.IsActionPromptEnabled, ns.ToggleActionPrompt, v)
	end)
	Dropdown("mh_actionPromptSound", "SET_PROMPT_SOUND_TITLE", "SET_PROMPT_SOUND_DESC", "off", {
		{ value = "off", labelKey = "SET_PROMPT_SOUND_OFF" },
		{ value = "speak", labelKey = "SET_PROMPT_SOUND_SPEAK" },
		{ value = "chime", labelKey = "SET_PROMPT_SOUND_CHIME" },
	}, function()
		return (ns.db and ns.db.actionPromptSound) or "off"
	end, function(v)
		ns.db = ns.db or {}
		ns.db.actionPromptSound = (v ~= "off") and v or nil
		if v ~= "off" and ns.PreviewActionPromptSound then pcall(ns.PreviewActionPromptSound) end -- choosing is the test
	end)
	Toggle("mh_dispelAlert", "SET_DISPELALERT_TITLE", "SET_DISPELALERT_DESC", function()
		return ns.DispelAlertEnabled and ns.DispelAlertEnabled()
	end, function(v)
		FlipTo(ns.DispelAlertEnabled, ns.ToggleDispelAlert, v)
	end)

	----------------------------------------------------------------
	-- Uitrusting (6 Oct 2026: two slash-only switches)
	----------------------------------------------------------------
	Header("SET_SEC_GEAR")
	Toggle("mh_lootTips", "SET_LOOTTIPS_TITLE", "SET_LOOTTIPS_DESC", function()
		return not (ns.db and ns.db.lootUpgradeTips == false)
	end, function(v)
		ns.db = ns.db or {}
		ns.db.lootUpgradeTips = v and true or false
	end)
	Toggle("mh_bagArrows", "SET_BAGARROWS_TITLE", "SET_BAGARROWS_DESC", function()
		return not (ns.db and ns.db.bagUpgradeArrows == false)
	end, function(v)
		-- through the toggle: it also redraws the open bags
		FlipTo(function() return not (ns.db and ns.db.bagUpgradeArrows == false) end, ns.ToggleBagUpgradeArrows, v)
	end)

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
	-- 10 Oct 2026 (idea B4, Rob put it in the 4.7.6 beta): four switches that had no command and no button, so the
	-- only way to turn them off was editing SavedVariables (mh-sweep, checked in the code that day). Each reads and
	-- writes the same field its module already reads; the defaults stay what they were (all on).
	Toggle("mh_toasts", "SET_TOASTS_TITLE", "SET_TOASTS_DESC", function()
		local t = ns.db and ns.db.ui and ns.db.ui.toast
		return not (type(t) == "table" and t.enabled == false)
	end, function(v)
		ns.db = ns.db or {}
		ns.db.ui = ns.db.ui or {}
		ns.db.ui.toast = type(ns.db.ui.toast) == "table" and ns.db.ui.toast or { delveBounty = true }
		ns.db.ui.toast.enabled = v and true or false
	end, true)
	Toggle("mh_toastBounty", "SET_TOAST_BOUNTY_TITLE", "SET_TOAST_BOUNTY_DESC", function()
		local t = ns.db and ns.db.ui and ns.db.ui.toast
		return not (type(t) == "table" and t.delveBounty == false)
	end, function(v)
		ns.db = ns.db or {}
		ns.db.ui = ns.db.ui or {}
		ns.db.ui.toast = type(ns.db.ui.toast) == "table" and ns.db.ui.toast or { enabled = true }
		ns.db.ui.toast.delveBounty = v and true or false
	end, true)
	Toggle("mh_openablesSound", "SET_OPENABLES_SOUND_TITLE", "SET_OPENABLES_SOUND_DESC", function()
		return not (ns.db and ns.db.ui and ns.db.ui.openablesSound == false)
	end, function(v)
		ns.db = ns.db or {}
		ns.db.ui = ns.db.ui or {}
		ns.db.ui.openablesSound = v and true or false
	end, true)
	Toggle("mh_delvePopupAuto", "SET_DELVEPOPUP_AUTO_TITLE", "SET_DELVEPOPUP_AUTO_DESC", function()
		local s = ns.db and ns.db.ui and ns.db.ui.delveItemsPopup
		return not (type(s) == "table" and s.autoShowInDelve == false)
	end, function(v)
		ns.db = ns.db or {}
		ns.db.ui = ns.db.ui or {}
		ns.db.ui.delveItemsPopup = type(ns.db.ui.delveItemsPopup) == "table" and ns.db.ui.delveItemsPopup or {}
		ns.db.ui.delveItemsPopup.autoShowInDelve = v and true or false
	end, true)
	Toggle("mh_runScorecard", "SET_SCORECARD_TITLE", "SET_SCORECARD_DESC", function()
		return not (ns.db and ns.db.runScorecard == false)
	end, function(v)
		ns.db = ns.db or {}
		ns.db.runScorecard = v and true or false
	end)
	Toggle("mh_scorecardDetail", "SET_SCORECARD_DETAIL_TITLE", "SET_SCORECARD_DETAIL_DESC", function()
		return ns.db and ns.db.scorecardDetail == true
	end, function(v)
		ns.db = ns.db or {}
		ns.db.scorecardDetail = v and true or false
	end)

	----------------------------------------------------------------
	-- Dungeon-hulp
	----------------------------------------------------------------
	Header("SET_SEC_DUNGEON")
	-- Tank pull summary: three slash-only switches until 6 Oct 2026 (command audit).
	Toggle("mh_pullSummary", "SET_PULLSUM_TITLE", "SET_PULLSUM_DESC", function()
		return ns.db and ns.db.tankPullSummary == true
	end, function(v)
		ns.db = ns.db or {}
		ns.db.tankPullSummary = v and true or false
	end)
	Toggle("mh_pullSummaryBoss", "SET_PULLSUM_BOSS_TITLE", "SET_PULLSUM_BOSS_DESC", function()
		return ns.db and ns.db.tankPullSummaryBossOnly == true
	end, function(v)
		ns.db = ns.db or {}
		ns.db.tankPullSummaryBossOnly = v and true or false
	end)
	Toggle("mh_pullSummaryPopup", "SET_PULLSUM_POPUP_TITLE", "SET_PULLSUM_POPUP_DESC", function()
		return ns.db and ns.db.tankPullSummaryPopup == true
	end, function(v)
		ns.db = ns.db or {}
		ns.db.tankPullSummaryPopup = v and true or false
	end)
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
	-- Rob, 4 Oct 2026: the Delve Coach opened by itself with no way to turn that off.
	Toggle("mh_delveCoachAuto", "SET_DELVECOACH_AUTO_TITLE", "SET_DELVECOACH_AUTO_DESC", function()
		return ns.IsDelveCoachAutoShow and ns.IsDelveCoachAutoShow()
	end, function(v)
		if ns.SetDelveCoachAutoShow then ns.SetDelveCoachAutoShow(v) end
	end, true)
	-- Recommended OFF since 14 Sep 2026: the module's own default is off
	-- (IsBossWindowModelEnabled reads showModel == true), and Recommended used to switch it back on.
	Toggle("mh_bossModel", "SET_BOSSWIN_MODEL_TITLE", "SET_BOSSWIN_MODEL_DESC", function()
		return ns.IsBossWindowModelEnabled and ns.IsBossWindowModelEnabled()
	end, function(v)
		if ns.SetBossWindowModelEnabled then ns.SetBossWindowModelEnabled(v) end
	end, false)
	Toggle("mh_bossSpotlight", "SET_BOSSWIN_SPOTLIGHT_TITLE", "SET_BOSSWIN_SPOTLIGHT_DESC", function()
		return ns.IsBossWindowThumbEnabled and ns.IsBossWindowThumbEnabled()
	end, function(v)
		if ns.SetBossWindowThumbEnabled then ns.SetBossWindowThumbEnabled(v) end
	end, true)
	-- Carried in on the merge of 16 Sep 2026: both were added to NativeSettings.lua on main after
	-- this branch had emptied it, so they would have vanished from both panels without this.
	-- Rob, 15 Sep 2026: "eli10 versie?" Short tips in the boss window, on by default.
	Toggle("mh_bossShortTips", "SET_BOSSWIN_SHORT_TITLE", "SET_BOSSWIN_SHORT_DESC", function()
		return ns.IsBossWindowShortTipsEnabled and ns.IsBossWindowShortTipsEnabled()
	end, function(v)
		if ns.SetBossWindowShortTipsEnabled then ns.SetBossWindowShortTipsEnabled(v) end
	end, true)
	-- Rob, 15 Sep 2026: tips for your own difficulty ("manier B"), on by default. Since 16 Sep the
	-- boss window's Difficulty button writes this same value ("All" = off), so the two agree.
	Toggle("mh_bossDiffFilter", "SET_BOSSWIN_DIFF_TITLE", "SET_BOSSWIN_DIFF_DESC", function()
		return ns.IsBossWindowDiffFilterEnabled and ns.IsBossWindowDiffFilterEnabled()
	end, function(v)
		if ns.SetBossWindowDiffFilterEnabled then ns.SetBossWindowDiffFilterEnabled(v) end
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
	Toggle("mh_durabilityWarn", "SET_DURA_TOGGLE_TITLE", "SET_DURA_TOGGLE_DESC", function()
		return ns.IsDurabilityWarnEnabled and ns.IsDurabilityWarnEnabled()
	end, function(v)
		if ns.SetDurabilityWarnEnabled then ns.SetDurabilityWarnEnabled(v) end
	end, true)
	local dB = ns.DurabilityThresholdBounds or { min = 5, max = 80, default = 30 }
	Slider("mh_durabilityLimit", "SET_DURA_LIMIT_TITLE", "SET_DURA_LIMIT_DESC", dB.min, dB.max, 5, function()
		return ns.GetDurabilityThreshold and ns.GetDurabilityThreshold()
	end, function(v)
		if ns.SetDurabilityThreshold then ns.SetDurabilityThreshold(v) end
	end, function(v)
		return ("%d%%"):format(math.floor(v + 0.5))
	end, dB.default)
	-- Rob, 30 Sep 2026: battle res charges + Bloodlust, with who in the group can.
	Toggle("mh_rezLust", "SET_REZLUST_TOGGLE_TITLE", "SET_REZLUST_TOGGLE_DESC", function()
		return ns.IsRezLustEnabled and ns.IsRezLustEnabled()
	end, function(v)
		if ns.SetRezLustEnabled then ns.SetRezLustEnabled(v) end
	end, true)
	-- Rob, 30 Sep 2026: every group instance by default (delves too); this narrows it back.
	Toggle("mh_rezLustKeyRaid", "SET_REZLUST_ONLYKEY_TITLE", "SET_REZLUST_ONLYKEY_DESC", function()
		return ns.IsRezLustKeyRaidOnly and ns.IsRezLustKeyRaidOnly()
	end, function(v)
		if ns.SetRezLustKeyRaidOnly then ns.SetRezLustKeyRaidOnly(v) end
	end, false)

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
	-- `/mh arrow yield` (command audit, 6 Oct 2026). Only means something with WaypointUI; the tip says so.
	Toggle("mh_arrowYield", "SET_ARROWYIELD_TITLE", "SET_ARROWYIELD_DESC", function()
		return ns.db and ns.db.arrowYieldWaypointUI == true
	end, function(v)
		ns.db = ns.db or {}
		ns.db.arrowYieldWaypointUI = v and true or nil
	end)

	----------------------------------------------------------------
	-- Venster & weergave
	----------------------------------------------------------------
	Header("SET_SEC_WINDOW")
	Toggle("mh_openLogin", "SETTINGS_OPEN_ON_LOGIN", nil, function()
		return ns.db and ns.db.ui and ns.db.ui.openOnLogin
	end, function(v)
		if ns.db and ns.db.ui then ns.db.ui.openOnLogin = v end
	end, false) -- expliciete default (uit); niet de toevallige login-waarde (F4.6)
	-- 9 Oct 2026 (Rob at the AH): a button on the auction house window that opens the shopping lists. On by default.
	Toggle("mh_ahShopButton", "SET_AHSHOP_TITLE", "SET_AHSHOP_DESC", function()
		return ns.IsAhShopButtonEnabled and ns.IsAhShopButtonEnabled()
	end, function(v)
		if ns.SetAhShopButtonEnabled then ns.SetAhShopButtonEnabled(v) end
	end, true)
	-- 2 Oct 2026, from the survey: "make the weekly plan … tailored … i like to play solo mostly".
	-- Hides the Mythic+ and Raids blocks on Home; a grey line says they are hidden and where.
	Toggle("mh_homeSolo", "SET_HOMESOLO_TITLE", "SET_HOMESOLO_DESC", function()
		return ns.IsHomeSoloMode and ns.IsHomeSoloMode()
	end, function(v)
		if ns.SetHomeSoloMode then ns.SetHomeSoloMode(v) end
	end, false)
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
	-- 9 Oct 2026 (idea B4): the two keybind-layout switches that only had a slash command (/mh sba, /mh mouse fill;
	-- sweep of SettingsDefs vs Core.lua). Same fields as the commands; both take effect after /reload + /mh apply.
	-- /mh kicks alert stays slash-only on purpose: on 12.1 it shows nothing (InterruptScore.lua:30-33).
	Toggle("mh_sbaForce", "SET_SBA_TITLE", "SET_SBA_DESC", function()
		return ns.db and ns.db.sbaForce == true
	end, function(v)
		ns.db = ns.db or {}
		ns.db.sbaForce = v and true or false
		ns.db.sbaOff = not ns.db.sbaForce
	end, false)
	Toggle("mh_mouseOverflow", "SET_MOUSEFILL_TITLE", "SET_MOUSEFILL_DESC", function()
		return ns.db and ns.db.mouseOverflow == true
	end, function(v)
		ns.db = ns.db or {}
		ns.db.mouseOverflow = v and true or false
	end, false)
	-- 10 Oct 2026 (idea B4): /mh mouse 0-6 had no button. Only used with the switch above on and no measured mouse
	-- (KeybindSchema.lua: Keybind_MouseKeysInPlay); empty means none, so the slider shows 0 then.
	Slider("mh_mouseButtons", "SET_MOUSECOUNT_TITLE", "SET_MOUSECOUNT_DESC", 0, 6, 1, function()
		return tonumber(ns.db and ns.db.mouseButtonCount) or 0
	end, function(v)
		ns.db = ns.db or {}
		ns.db.mouseButtonCount = math.max(0, math.min(6, math.floor((tonumber(v) or 0) + 0.5)))
	end, function(v)
		return tostring(math.floor((tonumber(v) or 0) + 0.5))
	end)
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
