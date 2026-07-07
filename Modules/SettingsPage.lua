--[[
	Midnight Helper — Settings-tab (launcher + snelle acties).

	Sinds 5 jul wonen alle aan/uit-instellingen in het native Blizzard
	Settings-venster (zie Modules/NativeSettings.lua): daar krijg je zoekbalk,
	per-optie tooltips, subcategorieën en de native look gratis.

	Deze tab is de vriendelijke landingsplek: de roterende eyecatcher als
	branding, een grote knop naar het native paneel, één "Aanbevolen stand"-knop,
	en de losse acties (Voorbeeld/Test/Reset). Die acties staan hier — en niet in
	het native paneel — omdat native knoppen (CreateSettingsButtonInitializer) op
	client 12.0 een Blizzard-assertion triggeren (bevestigd door ClassCodex + MDT).
	Gewone UIPanelButtons hier werken wél betrouwbaar.
]]

local _, ns = ...

local BTN_H = 24
local EYE_H = 86

local COLOR_HEADER = { 1, 0.82, 0.2 }
local COLOR_SOFT = { 0.95, 0.9, 0.74 }
local COLOR_DIM = { 0.72, 0.74, 0.78 }

local ui

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
-- Hulp
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

--------------------------------------------------------------------------------
-- Build (launcher)
--------------------------------------------------------------------------------

function ns.BuildSettingsPanel(panel)
	if not panel or panel._mhSettingsBuilt then
		return
	end
	panel._mhSettingsBuilt = true
	if panel._body then
		panel._body:Hide()
	end

	ui = { panel = panel, texts = {} }

	-- Onthoud label-key per widget zodat een taalwissel alles herlabelt.
	local function track(obj, key, isFS)
		ui.texts[#ui.texts + 1] = { obj = obj, key = key, isFS = isFS }
	end

	local function MakeBtn(w, labelKey, onClick)
		local b = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
		b:SetSize(w, BTN_H)
		b:SetText(ns:L(labelKey))
		b:SetScript("OnClick", function()
			pcall(onClick)
		end)
		track(b, labelKey, false)
		return b
	end

	local function MakeHeader(labelKey, anchorTo, gapY)
		local fs = MakeFS(panel, "GameFontNormal", COLOR_HEADER)
		fs:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", 0, gapY or -16)
		fs:SetText(ns:L(labelKey))
		track(fs, labelKey, true)
		return fs
	end

	-- Eyecatcher-strip: roterend model links, tagline + versie rechts.
	local eye = CreateFrame("Frame", nil, panel)
	eye:SetHeight(EYE_H)
	eye:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -56)
	eye:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
	if eye.SetClipsChildren then
		eye:SetClipsChildren(true)
	end
	local eyeModel = CreateFrame("PlayerModel", nil, eye)
	eyeModel:SetPoint("TOPLEFT", eye, "TOPLEFT", 0, -2)
	eyeModel:SetPoint("BOTTOMLEFT", eye, "BOTTOMLEFT", 0, 2)
	eyeModel:SetWidth(110)
	eyeModel:EnableMouse(false)
	ui.eyeModel = eyeModel
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
	local accent = eye:CreateTexture(nil, "ARTWORK")
	accent:SetHeight(2)
	accent:SetPoint("BOTTOMLEFT", eye, "BOTTOMLEFT", 0, 0)
	accent:SetPoint("BOTTOMRIGHT", eye, "BOTTOMRIGHT", 0, 0)
	accent:SetColorTexture(1, 0.82, 0.2, 0.9)

	-- Uitleg.
	local body = MakeFS(panel, "GameFontHighlight", COLOR_SOFT)
	body:SetPoint("TOPLEFT", eye, "BOTTOMLEFT", 2, -18)
	body:SetPoint("RIGHT", panel, "RIGHT", -20, 0)
	body:SetText(ns:L("SET_LAUNCH_BODY"))
	track(body, "SET_LAUNCH_BODY", true)

	-- Primaire knoppen: open native paneel + aanbevolen stand.
	local openBtn = MakeBtn(260, "SET_LAUNCH_OPEN", function()
		if not (ns.OpenNativeSettings and ns.OpenNativeSettings()) then
			-- In combat OpenNativeSettings already printed a "can't open in combat" note
			-- (opening is a protected action); don't also print the API-fallback hint.
			if not (InCombatLockdown and InCombatLockdown()) then
				DEFAULT_CHAT_FRAME:AddMessage(
					("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("SET_LAUNCH_HINT"))
				)
			end
		end
	end)
	openBtn:SetHeight(30)
	openBtn:SetPoint("TOPLEFT", body, "BOTTOMLEFT", 0, -16)

	local recBtn = MakeBtn(260, "SET_BTN_RECOMMENDED", function()
		if ns.ApplyRecommendedSettings then
			ns.ApplyRecommendedSettings()
		end
	end)
	recBtn:SetPoint("TOPLEFT", openBtn, "BOTTOMLEFT", 0, -8)

	local hint = MakeFS(panel, "GameFontHighlightSmall", COLOR_DIM)
	hint:SetPoint("TOPLEFT", recBtn, "BOTTOMLEFT", 2, -12)
	hint:SetPoint("RIGHT", panel, "RIGHT", -20, 0)
	hint:SetText(ns:L("SET_LAUNCH_HINT"))
	track(hint, "SET_LAUNCH_HINT", true)

	-- Voorbeeld & plaatsen.
	local placeH = MakeHeader("SET_LAUNCH_PLACE", hint, -16)
	local csBtn = MakeBtn(200, "SET_LAUNCH_CS", function()
		if ns.TestCombatSafety then ns.TestCombatSafety() end
	end)
	csBtn:SetPoint("TOPLEFT", placeH, "BOTTOMLEFT", 0, -6)
	local toastBtn = MakeBtn(150, "SET_LAUNCH_TOAST", function()
		if ns.QueueMidnightToast then
			ns.QueueMidnightToast({
				id = "settings-preview",
				title = ns:L("SET_TOAST_POS_TITLE"),
				body = ns:L("SET_TOAST_POS_DESC"),
				displaySec = 12,
			})
		end
	end)
	toastBtn:SetPoint("LEFT", csBtn, "RIGHT", 8, 0)

	-- Snelle acties.
	local actH = MakeHeader("SET_LAUNCH_ACTIONS", csBtn, -16)
	local testRareBtn = MakeBtn(170, "SET_LAUNCH_TEST_RARE", function()
		if ns.TestRareAlert then ns.TestRareAlert() end
	end)
	testRareBtn:SetPoint("TOPLEFT", actH, "BOTTOMLEFT", 0, -6)
	local bossBtn = MakeBtn(170, "SET_LAUNCH_BOSSWIN", function()
		if ns.ToggleDungeonBossWindow then ns.ToggleDungeonBossWindow() end
	end)
	bossBtn:SetPoint("LEFT", testRareBtn, "RIGHT", 8, 0)
	local testShardBtn = MakeBtn(170, "SET_LAUNCH_TEST_SHARD", function()
		if ns.TestShardCapAlert then ns.TestShardCapAlert() end
	end)
	testShardBtn:SetPoint("TOPLEFT", testRareBtn, "BOTTOMLEFT", 0, -6)
	local boardBtn = MakeBtn(170, "SET_LAUNCH_BOARD", function()
		if ns.ShowConsumableBoard then ns.ShowConsumableBoard() end
	end)
	boardBtn:SetPoint("LEFT", testShardBtn, "RIGHT", 8, 0)

	-- Geavanceerd (reset-knoppen).
	local advH = MakeHeader("SET_CAT_ADVANCED", testShardBtn, -16)
	local forgetBtn = MakeBtn(170, "SET_LAUNCH_FORGET", function()
		if ns.db then ns.db.rareNpcIds = {} end
	end)
	forgetBtn:SetPoint("TOPLEFT", advH, "BOTTOMLEFT", 0, -6)
	local resetBossBtn = MakeBtn(170, "SET_LAUNCH_RESETBOSS", function()
		if ns.ResetBossWindowLayout then ns.ResetBossWindowLayout() end
	end)
	resetBossBtn:SetPoint("LEFT", forgetBtn, "RIGHT", 8, 0)
	local toastResetBtn = MakeBtn(170, "SET_LAUNCH_TOAST_RESET", function()
		local uiDb = ns.db and ns.db.ui
		if uiDb and type(uiDb.toast) == "table" then
			uiDb.toast.pos = nil
		end
	end)
	toastResetBtn:SetPoint("TOPLEFT", forgetBtn, "BOTTOMLEFT", 0, -6)

	panel:SetScript("OnShow", function()
		ApplyEyecatcherModel()
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
	for _, t in ipairs(ui.texts) do
		if t.obj then
			if t.isFS then
				t.obj:SetText(ns:L(t.key))
			else
				t.obj:SetText(ns:L(t.key))
			end
		end
	end
end
