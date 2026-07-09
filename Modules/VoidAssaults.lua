--[[
	Void Assaults — Midnight (12.0.5) open-world event. The Void attacks one of
	two zones each week (Eversong Woods / Zul'Aman), rotating weekly. Players run
	Void Strikes that fill a shared bar and trigger a larger Void Incursion. It
	shares the hub, the Field Accolades currency and the Ritual Sites renown
	faction with the Ritual Sites tab.

	This companion tab tells you which zone is active this week, tracks the weekly
	meta-quest, and gives a TomTom waypoint to the shared Bazaar hub where the
	weeklies and vendors live.

	Data (verified via Wowhead / guides, May 2026):
	  - Active zone rotates between Eversong Woods (map 2395) and Zul'Aman (2437)
	  - Meta weekly "Midnight: Void Assaults" — quest 95842 (Spark of Radiance)
	  - Zone weekly "Void Assaults: Eversong Woods" — quest 94385
	  - Zone weekly "Void Assaults: Zul'Aman"      — quest 94386

	Active-zone detection is best-effort: whichever zone's weekly quest is on the
	player or already completed this week is the active one. When neither signals
	we fall back to a clear "check your map" note so the panel never lies.
]]

local _, ns = ...

local VOID_META_QUEST = 95842
local FIELD_ACCOLADE_CURRENCY = 3405
-- Shared Void Assaults / Ritual Sites hub on the 2nd floor of The Bazaar in
-- Silvermoon City (Ranger Captain Lilatha).
local HUB_MAP, HUB_X, HUB_Y = 2393, 48.2, 49.6

local ZONES = {
	{ key = "eversong", mapID = 2395, weekly = 94385 },
	{ key = "zulaman", mapID = 2437, weekly = 94386 },
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function ZoneName(mapID)
	if C_Map and C_Map.GetMapInfo then
		local info = C_Map.GetMapInfo(mapID)
		if info and info.name and info.name ~= "" then
			return info.name
		end
	end
	return "Map " .. tostring(mapID)
end

local function IsQuestActiveOrDone(qid)
	if not C_QuestLog then
		return false
	end
	if C_QuestLog.IsQuestFlaggedCompleted and C_QuestLog.IsQuestFlaggedCompleted(qid) then
		return true
	end
	if C_QuestLog.IsOnQuest and C_QuestLog.IsOnQuest(qid) then
		return true
	end
	return false
end

-- Best-effort: the active zone is the one whose weekly quest is on the player or
-- already completed this week (only the active zone's weekly is available).
local function DetectActiveZone()
	for _, z in ipairs(ZONES) do
		if IsQuestActiveOrDone(z.weekly) then
			return z
		end
	end
	return nil
end

local function GetNextWeekZone(activeZone)
	if not activeZone then
		return nil
	end
	for _, z in ipairs(ZONES) do
		if z.key ~= activeZone.key then
			return z
		end
	end
	return nil
end

local function IsWeeklyDone()
	if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return false
	end
	-- Meta-quest ÓF een zone-weekly telt als gedaan: Robs mage (12 jun)
	-- voltooide de zone-weekly terwijl 95842 false bleef — de routine zette
	-- "done" daardoor terug op "pick it up". Zone-flags zijn weekly-reset
	-- flags, dus dit blijft never-lie-veilig.
	if C_QuestLog.IsQuestFlaggedCompleted(VOID_META_QUEST) then
		return true
	end
	for _, z in ipairs(ZONES) do
		if C_QuestLog.IsQuestFlaggedCompleted(z.weekly) then
			return true
		end
	end
	return false
end

local function GetAccoladeInfo()
	if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, FIELD_ACCOLADE_CURRENCY)
		if ok and type(info) == "table" and info.quantity then
			return info.quantity, info.quantityEarnedThisWeek, info.maxWeeklyQuantity
		end
	end
	return nil
end

local function RouteHub()
	if not ns.AddSmartTomTomWay then
		return false
	end
	ns.MH_TomTomClearAll()
	return ns.AddSmartTomTomWay(HUB_MAP, HUB_X, HUB_Y, ns:L("VOID_HUB_WAYPOINT")) and true or false
end

--------------------------------------------------------------------------------
-- Public API (used by the Home dashboard)
--------------------------------------------------------------------------------

function ns.GetActiveVoidAssaultZoneName()
	local zone = DetectActiveZone()
	return zone and ZoneName(zone.mapID) or nil
end

-- The Void Assault roams its zone and the weekly quest exposes no single waypoint
-- (in-game the strikes are marked one by one as scouts identify them, so GetNextWaypoint
-- returns nothing — verified with Rob, 9 jul). There is no honest single point to route
-- to, so we offer the shared staging hub (Ranger Captain Lilatha in The Bazaar) as the
-- reliable "get started here" target. Returns true on success.
function ns.RouteVoidHub()
	return RouteHub()
end

function ns.IsVoidAssaultWeeklyDone()
	return IsWeeklyDone()
end

-- Progress (1-100) of the active zone weekly's progress bar ("Strikes
-- disrupted") while it is on the player. Mirrors ns.GetShowdownWeeklyProgress.
-- Returns nil when not on the quest, the API disagrees, or the bar reads 0
-- (a non-bar quest also reads 0 — never claim a percentage we can't trust).
function ns.GetVoidAssaultWeeklyProgress()
	if not (C_QuestLog and C_QuestLog.IsOnQuest) or type(GetQuestProgressBarPercent) ~= "function" then
		return nil
	end
	for _, z in ipairs(ZONES) do
		local okOn, onQuest = pcall(C_QuestLog.IsOnQuest, z.weekly)
		if okOn and onQuest then
			local ok, pct = pcall(GetQuestProgressBarPercent, z.weekly)
			if ok and type(pct) == "number" and pct > 0 then
				return math.floor(pct)
			end
			return nil
		end
	end
	return nil
end

-- Primitives consumed by the combined Void & Rituals panel.
function ns.GetVoidZones()
	return ZONES
end

function ns.GetActiveVoidAssaultZone()
	return DetectActiveZone()
end

function ns.VoidZoneName(zone)
	return zone and ZoneName(zone.mapID) or nil
end

--------------------------------------------------------------------------------
-- Panel
--------------------------------------------------------------------------------

local SIDE_PAD = 14
local TOP_PAD = 12
local BTN_H = 26
local GAP = 8

local ui

function ns.RefreshVoidPanel()
	if not ui or not ui.panel or not ui.panel:IsVisible() then
		return
	end

	local activeZone = DetectActiveZone()
	local weeklyDone = IsWeeklyDone()

	if ui.activeFs then
		if activeZone then
			ui.activeFs:SetText(ns:L("VOID_ACTIVE_FMT"):format(ZoneName(activeZone.mapID)))
			ui.activeFs:SetTextColor(1, 0.84, 0.18)
		else
			ui.activeFs:SetText(ns:L("VOID_ACTIVE_UNKNOWN"))
			ui.activeFs:SetTextColor(0.75, 0.78, 0.82)
		end
	end

	if ui.nextFs then
		local nextZone = GetNextWeekZone(activeZone)
		if nextZone then
			ui.nextFs:SetText(ns:L("VOID_NEXT_FMT"):format(ZoneName(nextZone.mapID)))
			ui.nextFs:Show()
		else
			ui.nextFs:Hide()
		end
	end

	if ui.weeklyFs then
		if weeklyDone then
			ui.weeklyFs:SetText(ns:L("VOID_WEEKLY_DONE"))
			ui.weeklyFs:SetTextColor(0.45, 0.95, 0.5)
		else
			ui.weeklyFs:SetText(ns:L("VOID_WEEKLY_TODO"))
			ui.weeklyFs:SetTextColor(0.9, 0.82, 0.45)
		end
	end

	if ui.accoladesFs then
		local n, wkThis, wkMax = GetAccoladeInfo()
		if n then
			if wkMax and wkMax > 0 then
				ui.accoladesFs:SetText(ns:L("VOID_INFO_ACCOLADES_WEEKLY_FMT"):format(n, wkThis or 0, wkMax))
			else
				ui.accoladesFs:SetText(ns:L("VOID_INFO_ACCOLADES_FMT"):format(n))
			end
			ui.accoladesFs:Show()
		else
			ui.accoladesFs:Hide()
		end
	end
end

function ns.BuildVoidPanel(panel)
	if not panel or panel._mhVoidBuilt then
		return
	end
	panel._mhVoidBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("VOID_TITLE"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.75, 0.78, 0.82)
	subtitle:SetText(ns:L("VOID_SUBTITLE"))

	local activeFs = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	activeFs:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	activeFs:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -14)
	activeFs:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	activeFs:SetJustifyH("LEFT")
	activeFs:SetWordWrap(true)

	local nextFs = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	nextFs:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	nextFs:SetPoint("TOPLEFT", activeFs, "BOTTOMLEFT", 0, -3)
	nextFs:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	nextFs:SetJustifyH("LEFT")
	nextFs:SetWordWrap(true)

	local weeklyFs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	weeklyFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	weeklyFs:SetPoint("TOPLEFT", nextFs, "BOTTOMLEFT", 0, -6)
	weeklyFs:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	weeklyFs:SetJustifyH("LEFT")

	local hubBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	hubBtn:SetHeight(BTN_H)
	hubBtn:SetPoint("TOPLEFT", weeklyFs, "BOTTOMLEFT", 0, -GAP - 4)
	hubBtn:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	hubBtn:SetText(ns:L("VOID_BTN_HUB"))
	do
		local hfs = hubBtn.GetFontString and hubBtn:GetFontString()
		if hfs then
			hfs:SetJustifyH("LEFT")
			hfs:ClearAllPoints()
			hfs:SetPoint("LEFT", hubBtn, "LEFT", 8, 0)
			hfs:SetPoint("RIGHT", hubBtn, "RIGHT", -8, 0)
		end
	end
	hubBtn:SetScript("OnClick", RouteHub)

	local note = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	note:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	note:SetPoint("TOPLEFT", hubBtn, "BOTTOMLEFT", 0, -GAP)
	note:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	note:SetJustifyH("LEFT")
	note:SetWordWrap(true)
	note:SetText(ns:L("VOID_MAP_NOTE"))

	-- Info section: what Void Assaults are, the strike->incursion loop, currency
	-- and how it ties into Ritual Sites.
	local infoHeader = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	infoHeader:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	infoHeader:SetPoint("TOPLEFT", note, "BOTTOMLEFT", 0, -GAP - 4)
	infoHeader:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	infoHeader:SetJustifyH("LEFT")
	infoHeader:SetTextColor(0.82, 0.68, 0.30)
	infoHeader:SetText(ns:L("VOID_INFO_HEADER"))

	local accoladesFs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	accoladesFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	accoladesFs:SetPoint("TOPLEFT", infoHeader, "BOTTOMLEFT", 0, -6)
	accoladesFs:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	accoladesFs:SetJustifyH("LEFT")
	accoladesFs:SetTextColor(0.55, 0.78, 1)

	local infoKeys = { "VOID_INFO_LOOP", "VOID_INFO_GATHER", "VOID_INFO_VAULT", "VOID_INFO_PARTICLES", "VOID_INFO_SHARED" }
	local infoLines = {}
	local prevInfo = accoladesFs
	for i = 1, #infoKeys do
		local fs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		fs:SetPoint("TOPLEFT", prevInfo, "BOTTOMLEFT", 0, -5)
		fs:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
		fs:SetJustifyH("LEFT")
		fs:SetWordWrap(true)
		fs:SetTextColor(0.75, 0.78, 0.82)
		fs:SetText("• " .. ns:L(infoKeys[i]))
		fs._mhKey = infoKeys[i]
		infoLines[i] = fs
		prevInfo = fs
	end

	ui = {
		panel = panel,
		title = title,
		subtitle = subtitle,
		activeFs = activeFs,
		nextFs = nextFs,
		weeklyFs = weeklyFs,
		hubBtn = hubBtn,
		note = note,
		infoHeader = infoHeader,
		accoladesFs = accoladesFs,
		infoLines = infoLines,
	}

	panel:SetScript("OnShow", function()
		ns.RefreshVoidPanel()
	end)

	ns.VoidPanel = panel
	ns.RefreshVoidPanel()
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("VOID_TITLE"))
			ui.subtitle:SetText(ns:L("VOID_SUBTITLE"))
			ui.note:SetText(ns:L("VOID_MAP_NOTE"))
			ui.hubBtn:SetText(ns:L("VOID_BTN_HUB"))
			ui.infoHeader:SetText(ns:L("VOID_INFO_HEADER"))
			for _, fs in ipairs(ui.infoLines) do
				fs:SetText("• " .. ns:L(fs._mhKey))
			end
		end
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshVoidPanel()
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("QUEST_LOG_UPDATE")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ev:SetScript("OnEvent", function()
	if ui and ui.panel and ui.panel:IsShown() then
		ns.RefreshVoidPanel()
	end
end)
