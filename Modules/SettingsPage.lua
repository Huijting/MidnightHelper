--[[
	Midnight Helper — Settings-tab "Mission Control" (Robs go, 12 jun;
	zie docs/SETTINGS_PAGE_PLAN.md, besluiten verwerkt: roulerende
	eyecatcher, Broker blijft mini, slider naast shift+scroll, Geavanceerd
	als eigen categorie, gelokaliseerde tabnaam).

	Opbouw: push/Relayout-engine (DungeonGuide-patroon) met categorieën als
	view-modes. Bovenin een altijd-zichtbare eyecatcher: clip-container met
	een langzaam roterend 3D-model, geloot uit alle bekende creature-IDs
	(dungeon-bosses + geleerde rares — rouleert per bezoek). Elke instelling
	schrijft via de bestaande setters (geen dubbele waarheid) en heeft waar
	zinnig een live Test/Voorbeeld-knop.
]]

local _, ns = ...

local BTN_H = 22
local EYE_H = 86

local COLOR_HEADER = { 1, 0.82, 0.2 }
local COLOR_ACCENT = { 0.95, 0.8, 0.35 }
local COLOR_SOFT = { 0.95, 0.9, 0.74 }
local COLOR_DIM = { 0.72, 0.74, 0.78 }

-- Sharing-categorie bewust geschrapt tot fase 5 ’m echt vult (Robs review:
-- één tekstregel = te leeg); de uitleg staat onderaan Dungeon Coach.
local CATS = {
	{ key = "general", labelKey = "SETTINGS_SECTION_GENERAL" },
	{ key = "alerts", labelKey = "SET_CAT_ALERTS" },
	{ key = "dungeon", labelKey = "SET_CAT_DUNGEON" },
	{ key = "vault", labelKey = "SET_CAT_VAULT" },
	{ key = "tabs", labelKey = "SET_CAT_TABS" },
	{ key = "advanced", labelKey = "SET_CAT_ADVANCED" },
}

local LOCALES = {
	{ code = "auto", label = "AUTO" },
	{ code = "enUS", label = "EN" },
	{ code = "nlNL", label = "NL" },
	{ code = "deDE", label = "DE" },
	{ code = "frFR", label = "FR" },
	{ code = "esES", label = "ES" },
	{ code = "ptBR", label = "PT" },
	{ code = "itIT", label = "IT" },
}

local ui

--------------------------------------------------------------------------------
-- Layout-engine (DungeonGuide-patroon: order + mode + Relayout)
--------------------------------------------------------------------------------

local function Relayout()
	if not ui or not ui.child then
		return
	end
	local width = ui.child:GetWidth()
	if not width or width <= 0 then
		return
	end
	local mode = ui.viewMode or "general"
	local y = 4
	for _, el in ipairs(ui.order) do
		local w = el.w
		if el.mode then
			if el.mode ~= mode then
				w:Hide()
			else
				w:Show()
			end
		end
		if w:IsShown() then
			local indent = el.indent or 0
			y = y + (el.gapTop or 0)
			w:ClearAllPoints()
			w:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent, -y)
			w:SetWidth(math.max(width - indent, 1))
			if el.h then
				y = y + el.h
			elseif el.button then
				y = y + BTN_H
			else
				y = y + math.max(w:GetStringHeight() or 0, 1)
			end
		end
	end
	ui.child:SetHeight(math.max(y + 8, 1))
end

--------------------------------------------------------------------------------
-- Eyecatcher: roterend model uit alle bekende creature-IDs
--------------------------------------------------------------------------------

local function PickEyecatcherCreature()
	local pool = {}
	if type(ns.DUNGEON_BOSS_CREATURES) == "table" then
		for _, id in pairs(ns.DUNGEON_BOSS_CREATURES) do
			pool[#pool + 1] = id
		end
	end
	local learned = ns.db and ns.db.rareNpcIds
	if type(learned) == "table" then
		for _, id in pairs(learned) do
			pool[#pool + 1] = id
		end
	end
	if #pool == 0 then
		return nil
	end
	return pool[math.random(#pool)]
end

local function ApplyEyecatcherModel()
	local model = ui and ui.eyeModel
	if not model then
		return
	end
	local creature = PickEyecatcherCreature()
	if not creature then
		model:Hide()
		return
	end
	local function apply()
		model:ClearModel()
		model:SetCreature(creature)
		if model.SetPortraitZoom then
			model:SetPortraitZoom(0)
		end
		if model.SetPosition then
			model:SetPosition(0, 0, 0)
		end
	end
	local ok = pcall(apply)
	model:SetShown(ok == true)
	if ok and C_Timer and C_Timer.After then
		C_Timer.After(0.2, function()
			if model:IsShown() then
				pcall(apply)
			end
		end)
	end
end

--------------------------------------------------------------------------------
-- Hulpconstructies
--------------------------------------------------------------------------------

local function MakeFS(parent, font, color)
	local fs = parent:CreateFontString(nil, "OVERLAY", font)
	if ns.MHScalableFont and type(font) == "string" then
		fs:SetFontObject(ns.MHScalableFont(font))
	end
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	if color then
		fs:SetTextColor(color[1], color[2], color[3])
	end
	return fs
end

local function MakeButton(parent, width, onClick)
	local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	btn:SetSize(width or 110, BTN_H)
	btn:SetScript("OnClick", onClick)
	return btn
end

--------------------------------------------------------------------------------
-- Build
--------------------------------------------------------------------------------

function ns.BuildSettingsPanel(panel)
	if not panel or panel._mhSettingsBuilt then
		return
	end
	panel._mhSettingsBuilt = true
	-- Standaard body-placeholder van CreateModulePanel verbergen; de header
	-- (gelokaliseerde tabnaam) blijft gewoon staan.
	if panel._body then
		panel._body:Hide()
	end

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -56)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, 8)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(400, 200)
	scroll:SetScrollChild(child)

	ui = {
		panel = panel,
		scroll = scroll,
		child = child,
		order = {},
		viewMode = "general",
		toggles = {},
		labels = {},
		catBtns = {},
		achToggles = {},
	}

	local function push(w, gapTop, indent, opts)
		opts = opts or {}
		ui.order[#ui.order + 1] = {
			w = w,
			gapTop = gapTop,
			indent = indent,
			mode = opts.mode,
			button = opts.button,
			h = opts.h,
		}
	end

	local function Label(key, font, color, gapTop, indent, mode)
		local fs = MakeFS(child, font or "GameFontHighlightSmall", color or COLOR_DIM)
		fs:SetText(ns:L(key))
		ui.labels[#ui.labels + 1] = { fs = fs, key = key }
		push(fs, gapTop or 4, indent or 0, { mode = mode })
		return fs
	end

	-- Eyecatcher-strip (altijd zichtbaar): model links, tagline + versie.
	local eye = CreateFrame("Frame", nil, child)
	eye:SetHeight(EYE_H)
	if eye.SetClipsChildren then
		eye:SetClipsChildren(true)
	end
	local eyeModel = CreateFrame("PlayerModel", nil, eye)
	eyeModel:SetPoint("TOPLEFT", eye, "TOPLEFT", 0, -2)
	eyeModel:SetPoint("BOTTOMLEFT", eye, "BOTTOMLEFT", 0, 2)
	eyeModel:SetWidth(110)
	eyeModel:EnableMouse(false)
	ui.eyeModel = eyeModel
	-- Langzame rotatie, alleen terwijl het paneel zichtbaar is.
	local facing = 0.4
	eye:SetScript("OnUpdate", function(_, elapsed)
		if eyeModel:IsShown() then
			facing = facing + elapsed * 0.35
			pcall(eyeModel.SetFacing, eyeModel, facing)
		end
	end)
	local eyeTag = MakeFS(eye, "GameFontNormal", COLOR_HEADER)
	eyeTag:SetPoint("TOPLEFT", eye, "TOPLEFT", 122, -18)
	eyeTag:SetPoint("RIGHT", eye, "RIGHT", -8, 0)
	ui.eyeTag = eyeTag
	local eyeVer = MakeFS(eye, "GameFontHighlightSmall", COLOR_DIM)
	eyeVer:SetPoint("TOPLEFT", eyeTag, "BOTTOMLEFT", 0, -6)
	eyeVer:SetPoint("RIGHT", eye, "RIGHT", -8, 0)
	ui.eyeVer = eyeVer
	-- Goud accentlijntje met zachte puls onder de strip.
	local accent = eye:CreateTexture(nil, "ARTWORK")
	accent:SetHeight(2)
	accent:SetPoint("BOTTOMLEFT", eye, "BOTTOMLEFT", 0, 0)
	accent:SetPoint("BOTTOMRIGHT", eye, "BOTTOMRIGHT", 0, 0)
	accent:SetColorTexture(1, 0.82, 0.2, 0.9)
	local pulse = accent:CreateAnimationGroup()
	local a1 = pulse:CreateAnimation("Alpha")
	a1:SetFromAlpha(0.9)
	a1:SetToAlpha(0.35)
	a1:SetDuration(1.6)
	a1:SetSmoothing("IN_OUT")
	local a2 = pulse:CreateAnimation("Alpha")
	a2:SetFromAlpha(0.35)
	a2:SetToAlpha(0.9)
	a2:SetDuration(1.6)
	a2:SetStartDelay(1.6)
	a2:SetSmoothing("IN_OUT")
	pulse:SetLooping("REPEAT")
	pulse:Play()
	push(eye, 0, 0, { h = EYE_H })

	-- Categorie-knoppen (één rij).
	local catRow = CreateFrame("Frame", nil, child)
	catRow:SetHeight(BTN_H + 4)
	local prev
	for _, cat in ipairs(CATS) do
		local btn = CreateFrame("Button", nil, catRow, "UIPanelButtonTemplate")
		btn:SetSize(104, BTN_H)
		if prev then
			btn:SetPoint("LEFT", prev, "RIGHT", 4, 0)
		else
			btn:SetPoint("LEFT", catRow, "LEFT", 0, 0)
		end
		btn:SetScript("OnClick", function()
			ui.viewMode = cat.key
			ns.RefreshSettingsPanel()
		end)
		ui.catBtns[cat.key] = { btn = btn, labelKey = cat.labelKey }
		prev = btn
	end
	push(catRow, 10, 0, { h = BTN_H + 4 })

	-- Toggle-helper: checkbox + omschrijving (+ optionele actieknoppenrij).
	local function AddToggle(mode, titleKey, descKey, getFn, setFn)
		local row = CreateFrame("Frame", nil, child)
		row:SetHeight(26)
		local cb = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
		cb:SetPoint("LEFT", row, "LEFT", 0, 0)
		cb:SetSize(26, 26)
		cb:SetScript("OnClick", function(self)
			setFn(self:GetChecked() and true or false)
			ns.RefreshSettingsPanel()
		end)
		local lbl = MakeFS(row, "GameFontNormal", COLOR_SOFT)
		lbl:SetPoint("LEFT", cb, "RIGHT", 4, 0)
		lbl:SetPoint("RIGHT", row, "RIGHT", -4, 0)
		lbl:SetText(ns:L(titleKey))
		ui.labels[#ui.labels + 1] = { fs = lbl, key = titleKey }
		ui.toggles[#ui.toggles + 1] = { cb = cb, getFn = getFn }
		push(row, 12, 0, { mode = mode, h = 26 })
		if descKey then
			Label(descKey, "GameFontHighlightSmall", COLOR_DIM, 0, 30, mode)
		end
		return row
	end

	-- Actieknoppen-rij (1-2 knoppen naast elkaar).
	local function AddButtons(mode, defs, indent)
		local row = CreateFrame("Frame", nil, child)
		row:SetHeight(BTN_H)
		local p
		for _, def in ipairs(defs) do
			local b = MakeButton(row, def.w or 110, def.onClick)
			if p then
				b:SetPoint("LEFT", p, "RIGHT", 6, 0)
			else
				b:SetPoint("LEFT", row, "LEFT", 0, 0)
			end
			ui.labels[#ui.labels + 1] = { btn = b, key = def.labelKey }
			p = b
		end
		push(row, 6, indent or 30, { mode = mode, h = BTN_H })
		return row
	end

	------------------------------------------------------------------
	-- 🌍 Algemeen
	------------------------------------------------------------------
	Label("SETTINGS_LANGUAGE_LABEL", "GameFontNormal", COLOR_ACCENT, 14, 0, "general")
	local langRow = CreateFrame("Frame", nil, child)
	langRow:SetHeight(BTN_H)
	local lp
	ui.langBtns = {}
	for _, loc in ipairs(LOCALES) do
		local b = CreateFrame("Button", nil, langRow, "UIPanelButtonTemplate")
		b:SetSize(52, BTN_H)
		b:SetText(loc.label)
		if lp then
			b:SetPoint("LEFT", lp, "RIGHT", 4, 0)
		else
			b:SetPoint("LEFT", langRow, "LEFT", 0, 0)
		end
		b:SetScript("OnClick", function()
			ns:SetLocale(loc.code)
			if ns.RefreshGuideTabVisibility then
				ns:RefreshGuideTabVisibility()
			end
			ns.RefreshSettingsPanel()
		end)
		ui.langBtns[loc.code] = b
		lp = b
	end
	push(langRow, 6, 0, { mode = "general", h = BTN_H })

	AddToggle("general", "SETTINGS_OPEN_ON_LOGIN", nil, function()
		return ns.db and ns.db.ui and ns.db.ui.openOnLogin
	end, function(v)
		if ns.db and ns.db.ui then
			ns.db.ui.openOnLogin = v
		end
	end)

	AddToggle("general", "SETTINGS_COMPACT_MODE", nil, function()
		return ns.IsCompactModeEnabled and ns:IsCompactModeEnabled()
	end, function(v)
		if ns.SetCompactModeEnabled then
			ns:SetCompactModeEnabled(v, true)
		end
	end)

	-- Tekstgrootte (los van vensterschaal): A- / A+ stepper i.p.v. slider.
	Label("SETTINGS_TEXT_SIZE_LABEL", "GameFontNormal", COLOR_ACCENT, 14, 0, "general")
	Label("SETTINGS_TEXT_SIZE_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "general")
	local fsRow = CreateFrame("Frame", nil, child)
	fsRow:SetHeight(BTN_H + 6)
	local fsMinus = CreateFrame("Button", nil, fsRow, "UIPanelButtonTemplate")
	fsMinus:SetSize(36, BTN_H)
	fsMinus:SetText("A-")
	fsMinus:SetPoint("LEFT", fsRow, "LEFT", 0, 0)
	local fsValue = MakeFS(fsRow, "GameFontNormal", COLOR_SOFT)
	fsValue:SetJustifyH("CENTER")
	fsValue:SetWidth(64)
	fsValue:SetPoint("LEFT", fsMinus, "RIGHT", 8, 0)
	local fsPlus = CreateFrame("Button", nil, fsRow, "UIPanelButtonTemplate")
	fsPlus:SetSize(36, BTN_H)
	fsPlus:SetText("A+")
	fsPlus:SetPoint("LEFT", fsValue, "RIGHT", 8, 0)
	local function ApplyFontStep(v)
		v = math.max(0.8, math.min(1.6, v))
		v = math.floor(v * 10 + 0.5) / 10 -- snap naar 0.1
		if ns.ApplyContentFontScale then
			ns.ApplyContentFontScale(v)
		end
		ns.RefreshSettingsPanel()
	end
	fsMinus:SetScript("OnClick", function()
		ApplyFontStep((ns.GetContentFontScale and ns.GetContentFontScale() or 1) - 0.1)
	end)
	fsPlus:SetScript("OnClick", function()
		ApplyFontStep((ns.GetContentFontScale and ns.GetContentFontScale() or 1) + 0.1)
	end)
	ui.fontScaleValueFS = fsValue
	push(fsRow, 8, 0, { mode = "general", h = BTN_H + 6 })

	-- Native route-arrow size (our own on-screen arrow, shown when routing without TomTom).
	Label("SET_ARROWSIZE_TITLE", "GameFontNormal", COLOR_ACCENT, 14, 0, "general")
	Label("SET_ARROWSIZE_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "general")
	local arrowRow = CreateFrame("Frame", nil, child)
	arrowRow:SetHeight(44)
	local arrowSlider = CreateFrame("Slider", "MidnightHelperArrowSize", arrowRow, "OptionsSliderTemplate")
	arrowSlider:SetPoint("LEFT", arrowRow, "LEFT", 6, -4)
	arrowSlider:SetWidth(220)
	local aBounds = ns.NativeArrowSizeBounds or { min = 28, max = 160, default = 64 }
	arrowSlider:SetMinMaxValues(aBounds.min, aBounds.max)
	arrowSlider:SetValueStep(4)
	arrowSlider:SetObeyStepOnDrag(true)
	local asName = arrowSlider:GetName()
	if asName then
		_G[asName .. "Low"]:SetText(tostring(aBounds.min))
		_G[asName .. "High"]:SetText(tostring(aBounds.max))
	end
	local curArrow = (ns.GetNativeArrowSize and ns.GetNativeArrowSize()) or aBounds.default
	arrowSlider:SetValue(curArrow)
	if asName and _G[asName .. "Text"] then
		_G[asName .. "Text"]:SetText(tostring(math.floor(curArrow + 0.5)))
	end
	arrowSlider:SetScript("OnValueChanged", function(self, value)
		if self._mhSettingValue then
			return
		end
		if ns.SetNativeArrowSize then
			ns.SetNativeArrowSize(value)
		end
		if ns.PreviewNativeArrow then
			ns.PreviewNativeArrow(3) -- flash the arrow so the new size is visible
		end
		if asName and _G[asName .. "Text"] then
			_G[asName .. "Text"]:SetText(tostring(math.floor(value + 0.5)))
		end
	end)
	ui.arrowSizeSlider = arrowSlider
	push(arrowRow, 8, 0, { mode = "general", h = 44 })

	AddToggle("general", "SET_ARROWUNIT_TITLE", "SET_ARROWUNIT_DESC", function()
		return ns.GetNativeArrowMeters and ns.GetNativeArrowMeters()
	end, function(v)
		if ns.SetNativeArrowMeters then
			ns.SetNativeArrowMeters(v)
		end
		if ns.PreviewNativeArrow then
			ns.PreviewNativeArrow(3)
		end
	end)

	Label("SETTINGS_GUIDE_LABEL", "GameFontNormal", COLOR_ACCENT, 14, 0, "general")
	Label("SETTINGS_HINT", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "general")
	local guideRow = CreateFrame("Frame", nil, child)
	guideRow:SetHeight(BTN_H)
	ui.guideBtns = {}
	local gp
	for _, def in ipairs({
		{ mode = "auto", labelKey = "SETTINGS_GUIDE_MODE_AUTO" },
		{ mode = "always", labelKey = "SETTINGS_GUIDE_MODE_ALWAYS" },
		{ mode = "hidden", labelKey = "SETTINGS_GUIDE_MODE_HIDDEN" },
	}) do
		local b = CreateFrame("Button", nil, guideRow, "UIPanelButtonTemplate")
		b:SetSize(118, BTN_H)
		if gp then
			b:SetPoint("LEFT", gp, "RIGHT", 6, 0)
		else
			b:SetPoint("LEFT", guideRow, "LEFT", 0, 0)
		end
		b:SetScript("OnClick", function()
			if ns.SetGuideVisibilityMode then
				ns:SetGuideVisibilityMode(def.mode)
			end
			ns.RefreshSettingsPanel()
		end)
		ui.guideBtns[def.mode] = { btn = b, labelKey = def.labelKey }
		gp = b
	end
	push(guideRow, 6, 0, { mode = "general", h = BTN_H })

	------------------------------------------------------------------
	-- 🔔 Meldingen & popups
	------------------------------------------------------------------
	AddToggle("alerts", "SETTINGS_RARE_ALERT", "SETTINGS_RARE_ALERT_TT", function()
		local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
		return not s or s.enabled ~= false
	end, function(v)
		if ns.SetRareAlertEnabled then
			ns.SetRareAlertEnabled(v)
		end
	end)
	AddToggle("alerts", "SET_RARE_SOUND", "SET_RARE_SOUND_DESC", function()
		local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
		return not s or s.sound ~= false
	end, function(v)
		local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
		if s then
			s.sound = v
		end
	end)
	AddToggle("alerts", "SETTINGS_RARE_ALERT_ONLYROUTE", "SETTINGS_RARE_ALERT_ONLYROUTE_TT", function()
		local s = ns.GetRareAlertSettings and ns.GetRareAlertSettings()
		return s and s.onlyWhileRouting == true
	end, function(v)
		if ns.SetRareAlertOnlyWhileRouting then
			ns.SetRareAlertOnlyWhileRouting(v)
		end
	end)
	AddButtons("alerts", {
		{ labelKey = "SET_BTN_TEST", onClick = function()
			if ns.TestRareAlert then
				ns.TestRareAlert()
			end
		end },
	})

	Label("SET_SHARD_TITLE", "GameFontNormal", COLOR_ACCENT, 16, 0, "alerts")
	Label("SET_SHARD_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "alerts")
	AddButtons("alerts", {
		{ labelKey = "SET_BTN_TEST", onClick = function()
			if ns.TestShardCapAlert then
				ns.TestShardCapAlert()
			end
		end },
	}, 0)

	Label("SET_TOAST_POS_TITLE", "GameFontNormal", COLOR_ACCENT, 16, 0, "alerts")
	Label("SET_TOAST_POS_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "alerts")
	AddButtons("alerts", {
		{ labelKey = "SET_BTN_PREVIEW", onClick = function()
			if ns.QueueMidnightToast then
				ns.QueueMidnightToast({
					id = "settings-preview",
					title = ns:L("SET_TOAST_POS_TITLE"),
					body = ns:L("SET_TOAST_POS_DESC"),
					displaySec = 12,
				})
			end
		end },
		{ labelKey = "SET_BTN_RESET", onClick = function()
			local uiDb = ns.db and ns.db.ui
			if uiDb and type(uiDb.toast) == "table" then
				uiDb.toast.pos = nil
			end
		end },
	}, 0)

	------------------------------------------------------------------
	-- 🗡 Dungeon Coach
	------------------------------------------------------------------
	AddToggle("dungeon", "SET_LIVETIPS_TITLE", "SET_LIVETIPS_DESC", function()
		return ns.IsDungeonLiveTipsEnabled and ns.IsDungeonLiveTipsEnabled()
	end, function(v)
		if ns.SetDungeonLiveTipsEnabled then
			ns.SetDungeonLiveTipsEnabled(v)
		end
	end)

	Label("SET_BOSSWIN_TITLE", "GameFontNormal", COLOR_ACCENT, 16, 0, "dungeon")
	Label("SET_BOSSWIN_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "dungeon")
	AddToggle("dungeon", "SET_BOSSWIN_AUTO_TITLE", "SET_BOSSWIN_AUTO_DESC", function()
		return ns.IsBossWindowAutoOpenEnabled and ns.IsBossWindowAutoOpenEnabled()
	end, function(v)
		if ns.SetBossWindowAutoOpenEnabled then
			ns.SetBossWindowAutoOpenEnabled(v)
		end
	end)
	AddToggle("dungeon", "SET_BOSSWIN_MODEL_TITLE", "SET_BOSSWIN_MODEL_DESC", function()
		return ns.IsBossWindowModelEnabled and ns.IsBossWindowModelEnabled()
	end, function(v)
		if ns.SetBossWindowModelEnabled then
			ns.SetBossWindowModelEnabled(v)
		end
	end)
	AddToggle("dungeon", "SET_BOSSWIN_SPOTLIGHT_TITLE", "SET_BOSSWIN_SPOTLIGHT_DESC", function()
		return ns.IsBossWindowThumbEnabled and ns.IsBossWindowThumbEnabled()
	end, function(v)
		if ns.SetBossWindowThumbEnabled then
			ns.SetBossWindowThumbEnabled(v)
		end
	end)
	-- Schaal-slider (naast shift+scroll, Robs besluit 3).
	local sliderRow = CreateFrame("Frame", nil, child)
	sliderRow:SetHeight(44)
	local slider = CreateFrame("Slider", "MidnightHelperBossWinScale", sliderRow, "OptionsSliderTemplate")
	slider:SetPoint("LEFT", sliderRow, "LEFT", 6, -4)
	slider:SetWidth(220)
	slider:SetMinMaxValues(0.7, 1.8)
	slider:SetValueStep(0.1)
	slider:SetObeyStepOnDrag(true)
	local sliderName = slider:GetName()
	if sliderName then
		_G[sliderName .. "Low"]:SetText("0.7")
		_G[sliderName .. "High"]:SetText("1.8")
	end
	slider:SetScript("OnValueChanged", function(self, value)
		if self._mhSettingValue then
			return -- programmatische update, geen feedback-loop
		end
		if ns.SetBossWindowScale then
			ns.SetBossWindowScale(value)
		end
		local label = sliderName and _G[sliderName .. "Text"]
		if label then
			label:SetText(("%.1f"):format(value))
		end
	end)
	ui.scaleSlider = slider
	push(sliderRow, 6, 0, { mode = "dungeon", h = 44 })
	AddButtons("dungeon", {
		{ labelKey = "SET_BTN_OPEN", onClick = function()
			if ns.ToggleDungeonBossWindow then
				ns.ToggleDungeonBossWindow()
			end
		end },
	}, 0)

	-- Wekelijkse coffer-shard-cap-popup (community-verzoek 21 jun).
	Label("SET_SHARDCAP_TITLE", "GameFontNormal", COLOR_ACCENT, 16, 0, "dungeon")
	Label("SET_SHARDCAP_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "dungeon")
	AddToggle("dungeon", "SET_SHARDCAP_TOGGLE_TITLE", "SET_SHARDCAP_TOGGLE_DESC", function()
		return ns.IsShardCapAlertEnabled and ns.IsShardCapAlertEnabled()
	end, function(v)
		if ns.SetShardCapAlertEnabled then
			ns.SetShardCapAlertEnabled(v)
		end
	end)

	-- Consumable ready check (auto bij ritual/delve/dungeon-entry; ook /mh readytoggle).
	Label("SET_CONSREADY_TITLE", "GameFontNormal", COLOR_ACCENT, 16, 0, "dungeon")
	Label("SET_CONSREADY_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "dungeon")
	AddToggle("dungeon", "SET_CONSREADY_TOGGLE_TITLE", "SET_CONSREADY_TOGGLE_DESC", function()
		return ns.IsConsumableReadyCheckEnabled and ns.IsConsumableReadyCheckEnabled()
	end, function(v)
		if ns.SetConsumableReadyCheckEnabled then
			ns.SetConsumableReadyCheckEnabled(v)
		end
	end)
	-- "Toon nu" — het bord handmatig oproepen (zelfde als /mh board).
	AddButtons("dungeon", {
		{ labelKey = "SET_CONSREADY_SHOW", onClick = function()
			if ns.ShowConsumableBoard then
				ns.ShowConsumableBoard()
			end
		end },
	}, 0)

	-- Missing Buff-reminder (icoon bij een missende onderhoudsbuff; klikbaar buiten combat).
	Label("SET_MBUFF_TITLE", "GameFontNormal", COLOR_ACCENT, 16, 0, "dungeon")
	Label("SET_MBUFF_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "dungeon")
	AddToggle("dungeon", "SET_MBUFF_TOGGLE_TITLE", "SET_MBUFF_TOGGLE_DESC", function()
		return ns.IsMissingBuffEnabled and ns.IsMissingBuffEnabled()
	end, function(v)
		if ns.SetMissingBuffEnabled then
			ns.SetMissingBuffEnabled(v)
		end
	end)

	-- Openables (openbare tas-items: caches/lockboxes/satchels; klik = openen).
	Label("SET_OPEN_TITLE", "GameFontNormal", COLOR_ACCENT, 16, 0, "dungeon")
	Label("SET_OPEN_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "dungeon")
	AddToggle("dungeon", "SET_OPEN_TOGGLE_TITLE", "SET_OPEN_TOGGLE_DESC", function()
		return ns.IsOpenablesEnabled and ns.IsOpenablesEnabled()
	end, function(v)
		if ns.SetOpenablesEnabled then
			ns.SetOpenablesEnabled(v)
		end
	end)

	-- Fast Mark (versleepbare balk: target-markers /tm + world-markers).
	Label("SET_MARK_TITLE", "GameFontNormal", COLOR_ACCENT, 16, 0, "dungeon")
	Label("SET_MARK_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "dungeon")
	AddToggle("dungeon", "SET_MARK_TOGGLE_TITLE", "SET_MARK_TOGGLE_DESC", function()
		return ns.IsFastMarkEnabled and ns.IsFastMarkEnabled()
	end, function(v)
		if ns.SetFastMarkEnabled then
			ns.SetFastMarkEnabled(v)
		end
	end)

	-- Delen-uitleg onderaan de Dungeon Coach-categorie (eigen categorie
	-- volgt zodra fase 5 echte share-instellingen brengt).
	Label("SET_SHARING_BODY", "GameFontHighlightSmall", COLOR_DIM, 18, 0, "dungeon")

	------------------------------------------------------------------
	-- 🛠 Geavanceerd
	------------------------------------------------------------------
	AddToggle("advanced", "SET_ADV_DEBUG", "SET_ADV_DEBUG_DESC", function()
		return ns.db and ns.db.ui and ns.db.ui.debug
	end, function(v)
		if ns.db and ns.db.ui then
			ns.db.ui.debug = v and true or nil
		end
	end)

	Label("SET_ADV_FORGET_RARES", "GameFontNormal", COLOR_ACCENT, 14, 0, "advanced")
	Label("SET_ADV_FORGET_RARES_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "advanced")
	AddButtons("advanced", {
		{ labelKey = "SET_BTN_RESET", onClick = function()
			if ns.db then
				ns.db.rareNpcIds = {}
			end
		end },
	}, 0)

	Label("SET_ADV_RESET_BOSSWIN", "GameFontNormal", COLOR_ACCENT, 14, 0, "advanced")
	Label("SET_ADV_RESET_BOSSWIN_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "advanced")
	AddButtons("advanced", {
		{ labelKey = "SET_BTN_RESET", onClick = function()
			if ns.ResetBossWindowLayout then
				ns.ResetBossWindowLayout()
			end
			ns.RefreshSettingsPanel()
		end },
	}, 0)

	-- Vault reminders & advisor + Beta tabs — hosted from the shared builders so every
	-- setting lives in this one tab (the old right-click / Blizzard panel is retired).
	-- Each builder gets its own left-aligned container; refresh runs in RefreshSettingsPanel.
	-- Each now lives in its own category (Vault / Tabs) with a short intro for air.
	Label("SET_CAT_VAULT_DESC", "GameFontHighlightSmall", COLOR_DIM, 14, 0, "vault")
	local vaultBox = CreateFrame("Frame", nil, child)
	vaultBox:SetHeight(290)
	local vAnchor = vaultBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	vAnchor:SetPoint("TOPLEFT", vaultBox, "TOPLEFT", 2, 0)
	vAnchor:SetText("")
	if ns.AttachVaultSettingsControls then
		ns.AttachVaultSettingsControls(vaultBox, vAnchor, "OVERLAY", vaultBox)
	end
	ui.vaultBox = vaultBox
	push(vaultBox, 16, 0, { mode = "vault", h = 290 })

	Label("SET_CAT_TABS_DESC", "GameFontHighlightSmall", COLOR_DIM, 14, 0, "tabs")
	local betaBox = CreateFrame("Frame", nil, child)
	betaBox:SetHeight(224)
	local bAnchor = betaBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	bAnchor:SetPoint("TOPLEFT", betaBox, "TOPLEFT", 2, 0)
	bAnchor:SetText("")
	if ns.AttachBetaTabsSettings then
		ns.AttachBetaTabsSettings(betaBox, bAnchor, "OVERLAY", betaBox)
	end
	ui.betaBox = betaBox
	push(betaBox, 16, 0, { mode = "tabs", h = 224 }) -- contains label + 6 checkboxes (was 190, clipped Academy into the next section)

	-- Per-achievement visibility for the Achievements tab. A checkbox per tracked
	-- achievement (checked = shown). Hidden ones stay tracked/routable — this just
	-- folds their card away. Pairs with the "all done — hide it?" popup.
	Label("SET_ACH_VIS_TITLE", "GameFontNormal", COLOR_ACCENT, 18, 0, "tabs")
	Label("SET_ACH_VIS_DESC", "GameFontHighlightSmall", COLOR_DIM, 2, 0, "tabs")
	AddToggle("tabs", "SET_ACH_AUTOHIDE_TITLE", "SET_ACH_AUTOHIDE_DESC", function()
		return ns.IsAchAutoHideDoneEnabled and ns.IsAchAutoHideDoneEnabled()
	end, function(v)
		if ns.SetAchAutoHideDoneEnabled then
			ns.SetAchAutoHideDoneEnabled(v)
		end
	end)
	for _, entry in ipairs(ns.ACHIEVEMENT_TREASURES or {}) do
		local id = entry.achievementID
		local row = CreateFrame("Frame", nil, child)
		row:SetHeight(24)
		local cb = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
		cb:SetPoint("LEFT", row, "LEFT", 0, 0)
		cb:SetSize(24, 24)
		cb:SetScript("OnClick", function(self)
			if ns.SetAchievementHidden then
				ns.SetAchievementHidden(id, not self:GetChecked())
			end
		end)
		local lbl = MakeFS(row, "GameFontNormal", COLOR_SOFT)
		lbl:SetPoint("LEFT", cb, "RIGHT", 4, 0)
		lbl:SetPoint("RIGHT", row, "RIGHT", -4, 0)
		ui.achToggles[#ui.achToggles + 1] = { cb = cb, lbl = lbl, entry = entry }
		push(row, 4, 0, { mode = "tabs", h = 24 })
	end

	-- Reset all MidnightHelper settings to defaults (was only on the old panel).
	Label("SETTINGS_RESET_DEFAULTS", "GameFontNormal", COLOR_ACCENT, 16, 0, "advanced")
	AddButtons("advanced", {
		{ labelKey = "SETTINGS_RESET_DEFAULTS", onClick = function()
			if ns.SetLocale then
				ns:SetLocale(ns.MH_LOCALE_AUTO or "auto", true)
			end
			if ns.SetGuideVisibilityMode then
				ns:SetGuideVisibilityMode("auto", true)
			end
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
			ns.RefreshSettingsPanel()
		end },
	}, 0)

	-- Breedte-sync + verversing bij tonen.
	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
			Relayout()
		end
	end
	scroll:SetScript("OnSizeChanged", syncWidth)
	syncWidth()

	panel:SetScript("OnShow", function()
		syncWidth()
		ApplyEyecatcherModel() -- rouleren: elke open-beurt een ander model
		ns.RefreshSettingsPanel()
	end)
end

--------------------------------------------------------------------------------
-- Refresh
--------------------------------------------------------------------------------

function ns.RefreshSettingsPanel()
	if not ui or not ui.panel or not ui.panel:IsVisible() then
		return
	end

	ui.eyeTag:SetText(ns:L("SET_EYE_TAGLINE"))
	local ver = "?"
	if C_AddOns and C_AddOns.GetAddOnMetadata then
		ver = C_AddOns.GetAddOnMetadata("MidnightHelper", "Version") or "?"
	elseif GetAddOnMetadata then
		ver = GetAddOnMetadata("MidnightHelper", "Version") or "?"
	end
	ui.eyeVer:SetText(ns:L("SET_ADV_VERSION_FMT"):format(ver))

	-- Labels/knoppen herlabelen (taalwissel-proof).
	for _, l in ipairs(ui.labels) do
		if l.fs then
			l.fs:SetText(ns:L(l.key))
		elseif l.btn then
			l.btn:SetText(ns:L(l.key))
		end
	end

	-- Categorie-knoppen: actieve goud.
	for key, def in pairs(ui.catBtns) do
		def.btn:SetText(ns:L(def.labelKey))
		local fs = def.btn:GetFontString()
		if fs then
			if key == ui.viewMode then
				fs:SetTextColor(1, 0.82, 0.2)
			else
				fs:SetTextColor(1, 1, 1)
			end
		end
	end

	-- Taalknoppen: actieve goud.
	local curLocale = (ns.db and ns.db.locale) or ns.MH_LOCALE_AUTO or "auto"
	for code, btn in pairs(ui.langBtns or {}) do
		local fs = btn:GetFontString()
		if fs then
			if code == curLocale then
				fs:SetTextColor(1, 0.82, 0.2)
			else
				fs:SetTextColor(1, 1, 1)
			end
		end
	end

	-- Guide-modus-knoppen: actieve goud.
	local curMode = ns.GetGuideVisibilityMode and ns:GetGuideVisibilityMode() or "auto"
	for mode, def in pairs(ui.guideBtns or {}) do
		def.btn:SetText(ns:L(def.labelKey))
		local fs = def.btn:GetFontString()
		if fs then
			if mode == curMode then
				fs:SetTextColor(1, 0.82, 0.2)
			else
				fs:SetTextColor(1, 1, 1)
			end
		end
	end

	-- Toggles syncen.
	for _, t in ipairs(ui.toggles) do
		t.cb:SetChecked(t.getFn() and true or false)
	end

	-- Achievement-zichtbaarheid: vinkje = getoond; label volgt de live (gelokaliseerde)
	-- prestatienaam.
	for _, t in ipairs(ui.achToggles or {}) do
		local id = t.entry.achievementID
		local hidden = ns.IsAchievementHidden and ns.IsAchievementHidden(id)
		t.cb:SetChecked(not hidden)
		local nm = ns.AchievementDisplayName and ns.AchievementDisplayName(t.entry)
		t.lbl:SetText(nm or t.entry.nameKey or tostring(id))
	end

	-- Slider syncen (zonder OnValueChanged-feedback).
	if ui.scaleSlider then
		local sc = (ns.GetBossWindowScale and ns.GetBossWindowScale()) or 1
		ui.scaleSlider._mhSettingValue = true
		ui.scaleSlider:SetValue(sc)
		ui.scaleSlider._mhSettingValue = nil
		local name = ui.scaleSlider:GetName()
		local label = name and _G[name .. "Text"]
		if label then
			label:SetText(("%.1f"):format(sc))
		end
	end

	-- Tekstgrootte-waarde tonen (A- / A+ stepper).
	if ui.fontScaleValueFS then
		local fsc = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
		ui.fontScaleValueFS:SetText(("%d%%"):format(math.floor(fsc * 100 + 0.5)))
	end

	-- Vault- en beta-tabs-settings (gehost vanuit de gedeelde bouwers) verversen.
	if ui.vaultBox and ns.RefreshVaultSettingsControls then
		ns.RefreshVaultSettingsControls(ui.vaultBox)
	end
	if ui.betaBox and ns.RefreshBetaTabsSettingsControls then
		ns.RefreshBetaTabsSettingsControls(ui.betaBox)
	end

	Relayout()
end
