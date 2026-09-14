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

	14 Sep 2026 ("nummer 3"): the main category is drawn from ns.GetSettingsDefs()
	(Modules/SettingsDefs.lua) instead of inline calls, so MH's own settings page can draw the
	same list. Variables, order, defaults and Recommended values are unchanged.
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
		-- The main category, section by section, from Modules/SettingsDefs.lua. The reasons for
		-- each setting and its Recommended value are written beside its entry there.
		----------------------------------------------------------------
		for _, section in ipairs(ns.GetSettingsDefs and ns.GetSettingsDefs() or {}) do
			AddHeader(section.header)
			for _, d in ipairs(section.items) do
				if d.kind == "toggle" then
					AddToggle(d.var, d.name, d.tip, d.get, d.set, d.rec)
				elseif d.kind == "slider" then
					AddSlider(d.var, d.name, d.tip, d.min, d.max, d.step, d.get, d.set, d.fmt, d.rec)
				elseif d.kind == "dropdown" then
					AddDropdown(d.var, d.name, d.tip, d.default, d.options, d.get, d.set, d.rec)
				end
			end
		end

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
				recommended[variable] = true
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

--- MH's own settings page (Modules/SettingsPage.lua) changed a value through the entry's own
--- setter: mirror it into Blizzard's panel the same way, by writing the proxy only.
function ns.SyncNativeSetting(variable, value)
	if proxy[variable] ~= nil then
		proxy[variable] = value
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
