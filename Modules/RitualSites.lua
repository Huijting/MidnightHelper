--[[
	Ritual Sites — Midnight (12.0.5) endgame world content. Two sites rotate
	weekly; only one is active at a time, marked with a special icon on the
	world map. This module is a small, high-value companion (like the Rares
	tab): it tells you which site is active this week, gives a TomTom waypoint
	to the active Curious Obelisk, and tracks the weekly meta-quest.

	Data (verified via Wowhead / guides, May 2026):
	  - Daggerspine Point — Eversong Woods (map 2395) — 37.59, 65.20 (Curious Obelisk)
	  - Broken Throne     — Zul'Aman      (map 2437) — 29.7, 78.2
	  - Weekly meta-quest "Midnight: Ritual Sites" — quest 95843

	Active-site detection is best-effort: we scan the map POIs for each site
	and match the one near the known obelisk spot. When the API gives us no
	signal we fall back to showing both sites with a clear note, so the panel
	never lies about which one is live.
]]

local _, ns = ...

local RITUAL_WEEKLY_QUEST = 95843
-- "Ritual Interest" (94383) — final step of the per-character Void Assaults
-- intro chain (94380 Ranger Captain's Summons → 94381 Outfitting and Allies →
-- 96080 Void Strike → 94382 Ritual Problems → 94383). The hub only offers the
-- weekly after this is done on THIS character (renown unlock is warband-wide,
-- the chain is not — verified via Rob's druid dump, 10 Jun 2026).
local RITUAL_INTRO_FINAL_QUEST = 94383
-- Volledige introketen voor de stap-bewuste hint. Let op: Blizzards volgorde
-- is buggy — 94381 kan true zijn terwijl 94380 false blijft (Robs lvl-81-test
-- 11 jun + Wowhead-comments "chain is in the wrong order"). Daarom bepaalt de
-- HOOGSTE voltooide stap wat de volgende is, niet de eerste onvoltooide.
local RITUAL_INTRO_CHAIN = {
	{ quest = 94380, key = "RITUAL_INTRO_STEP_SUMMONS" },
	{ quest = 94381, key = "RITUAL_INTRO_STEP_ALLIES" },
	{ quest = 96080, key = "RITUAL_INTRO_STEP_VOIDSTRIKE" },
	{ quest = 94382, key = "RITUAL_INTRO_STEP_PROBLEMS" },
	{ quest = 94383, key = "RITUAL_INTRO_STEP_INTEREST" },
}
-- Field Accolade — the Midnight 12.0.5 currency earned from Ritual Sites /
-- Void Assaults (per character, not warbound).
local FIELD_ACCOLADE_CURRENCY = 3405
-- Ritual Sites renown/reputation faction.
local RITUAL_RENOWN_FACTION = 2792
-- Void Assaults / Ritual Sites quest hub on the 2nd floor of The Bazaar in
-- Silvermoon City (Ranger Captain Lilatha, Lady Darkglen, Maren Silverwing).
local HUB_MAP, HUB_X, HUB_Y = 2393, 48.2, 49.4
-- Normalized map distance within which a map POI counts as "the obelisk".
local POI_MATCH_RADIUS = 0.06

local SITES = {
	{ key = "daggerspine", name = "Daggerspine Point", mapID = 2395, x = 37.59, y = 65.20 },
	{ key = "brokenthrone", name = "Broken Throne", mapID = 2437, x = 29.7, y = 78.2 },
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

local function PosXY(pos)
	if type(pos) ~= "table" then
		return nil
	end
	if type(pos.GetXY) == "function" then
		local ok, x, y = pcall(pos.GetXY, pos)
		if ok and x then
			return x, y
		end
	end
	if type(pos.x) == "number" then
		return pos.x, pos.y
	end
	return nil
end

local function NearObelisk(px, py, site)
	if not px then
		return false
	end
	local dx = px - (site.x / 100)
	local dy = py - (site.y / 100)
	return (dx * dx + dy * dy) <= (POI_MATCH_RADIUS * POI_MATCH_RADIUS)
end

-- Best-effort: scan the area POIs of each site's map and treat a POI sitting on
-- the known obelisk spot as proof that this is the active site this week.
local function DetectActiveSite()
	if not (C_AreaPoiInfo and C_AreaPoiInfo.GetAreaPOIForMap and C_AreaPoiInfo.GetAreaPOIInfo) then
		return nil
	end
	for _, site in ipairs(SITES) do
		local ok, pois = pcall(C_AreaPoiInfo.GetAreaPOIForMap, site.mapID)
		if ok and type(pois) == "table" then
			for i = 1, #pois do
				local okInfo, info = pcall(C_AreaPoiInfo.GetAreaPOIInfo, site.mapID, pois[i])
				if okInfo and info then
					local px, py = PosXY(info.position)
					if NearObelisk(px, py, site) then
						return site.key
					end
				end
			end
		end
	end
	return nil
end

local function IsWeeklyDone()
	if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return false
	end
	return C_QuestLog.IsQuestFlaggedCompleted(RITUAL_WEEKLY_QUEST) and true or false
end

-- Returns: total quantity, amount earned this week, weekly cap (last two may be
-- nil/0 if the currency has no weekly cap).
local function GetAccoladeInfo()
	if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, FIELD_ACCOLADE_CURRENCY)
		if ok and type(info) == "table" and info.quantity then
			return info.quantity, info.quantityEarnedThisWeek, info.maxWeeklyQuantity
		end
	end
	return nil
end

-- The other site (the one that becomes active next week, since only two rotate).
local function GetNextWeekSite(activeSite)
	if not activeSite then
		return nil
	end
	for _, s in ipairs(SITES) do
		if s.key ~= activeSite.key then
			return s
		end
	end
	return nil
end

-- Ritual Sites has its own 8-rank renown/reputation (faction 2792). It may be
-- exposed as a Major Faction (renown) or a classic reputation depending on the
-- client build, so we try both and fall back to a "not unlocked yet" hint.
local function GetRitualRenownText()
	if C_MajorFactions and C_MajorFactions.GetMajorFactionData then
		local ok, d = pcall(C_MajorFactions.GetMajorFactionData, RITUAL_RENOWN_FACTION)
		if ok and type(d) == "table" and d.renownLevel and d.renownLevel > 0 then
			local cur, need = d.renownReputationEarned or 0, d.renownLevelThreshold or 0
			if need > 0 then
				return ("%s %d (%d/%d)"):format(ns:L("RITUAL_RENOWN_WORD"), d.renownLevel, cur, need)
			end
			return ("%s %d"):format(ns:L("RITUAL_RENOWN_WORD"), d.renownLevel)
		end
	end
	if C_Reputation and C_Reputation.GetFactionDataByID then
		local ok, d = pcall(C_Reputation.GetFactionDataByID, RITUAL_RENOWN_FACTION)
		if ok and type(d) == "table" and d.reaction then
			local standing = _G["FACTION_STANDING_LABEL" .. d.reaction] or ""
			local base = d.currentReactionThreshold or 0
			local cur = (d.currentStanding or 0) - base
			local need = (d.nextReactionThreshold or 0) - base
			if need > 0 then
				return ("%s (%d/%d)"):format(standing, cur, need)
			end
			if standing ~= "" then
				return standing
			end
		end
	end
	return nil
end

local function RouteHub()
	if not ns.AddSmartTomTomWay then
		return false
	end
	if ns.IsTomTomReady and ns.IsTomTomReady() then
		pcall(function()
			_G.TomTom:ClearAllWaypoints()
		end)
	end
	return ns.AddSmartTomTomWay(HUB_MAP, HUB_X, HUB_Y, ns:L("RITUAL_HUB_WAYPOINT")) and true or false
end

local function GetSiteByKey(key)
	for _, site in ipairs(SITES) do
		if site.key == key then
			return site
		end
	end
	return nil
end

-- The site the player last asked us to route to. Kept so we can re-assert the
-- TomTom arrow after a death/loading screen (the crazy arrow is transient and
-- vanishes on resurrect), without forcing a /reload. Cleared once the weekly is
-- done so a later death elsewhere does not resurrect a stale arrow.
local lastRoutedSite

local function RouteSite(site, quiet)
	if not site or not ns.AddSmartTomTomWay then
		return false
	end
	if ns.IsTomTomReady and ns.IsTomTomReady() then
		pcall(function()
			_G.TomTom:ClearAllWaypoints()
		end)
	end
	local label = site.name .. " — " .. ZoneName(site.mapID)
	-- Hybride routing (QoL): bij een expliciete klik op de ACTIEVE site volgen we
	-- het live weekly-objectief als de speler de ritual-weekly in z'n log heeft
	-- (zelf-updatend per stap); anders/elders de vaste obelisk-coords. Alleen de
	-- actieve site, want de quest-route wijst altijd naar de actieve site. Bij
	-- quiet re-assertion (na revive) houden we de simpele coord-route + popup-skip.
	local active = ns.GetActiveRitualSite and ns.GetActiveRitualSite()
	local isActive = active and active.key == site.key
	local ok
	if isActive and not quiet and ns.AddSmartQuestRoute then
		ok = ns.AddSmartQuestRoute(RITUAL_WEEKLY_QUEST, site.mapID, site.x, site.y, label) and true or false
	else
		-- quiet = skip the cross-zone travel popup (used for silent re-assertion).
		ok = ns.AddSmartTomTomWay(site.mapID, site.x, site.y, label, quiet and true or nil) and true or false
	end
	if ok then
		lastRoutedSite = site
	end
	return ok
end

-- Re-point the arrow at the last routed site after a revive. Delayed slightly so
-- the world/map state has settled after the resurrect loading screen.
local function ReassertRouteAfterRevive()
	if not lastRoutedSite then
		return
	end
	if IsWeeklyDone() then
		lastRoutedSite = nil
		return
	end
	if not (ns.IsTomTomReady and ns.IsTomTomReady()) then
		return
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(1.5, function()
			if lastRoutedSite then
				RouteSite(lastRoutedSite, true)
			end
		end)
	else
		RouteSite(lastRoutedSite, true)
	end
end

--------------------------------------------------------------------------------
-- Public API (used by the Home dashboard)
--------------------------------------------------------------------------------

-- Returns the active site table (or nil if undetected) for other modules.
function ns.GetActiveRitualSite()
	local key = DetectActiveSite()
	return key and GetSiteByKey(key) or nil
end

function ns.IsRitualWeeklyDone()
	return IsWeeklyDone()
end

-- Is the Ritual Sites renown (and thus the system) unlocked? The unlock is
-- account/warband-wide, but the weekly quest is per-character. Returns
-- (isUnlocked|nil, unlockDescription).
local function RitualRenownUnlocked()
	if C_MajorFactions and C_MajorFactions.GetMajorFactionData then
		local ok, d = pcall(C_MajorFactions.GetMajorFactionData, RITUAL_RENOWN_FACTION)
		if ok and type(d) == "table" then
			return d.isUnlocked and true or false, d.unlockDescription
		end
	end
	return nil, nil
end

-- Explains WHY the weekly isn't done yet, using only real signals (never lie):
--   locked     — renown not unlocked → show the game's own unlockDescription
--   intro      — renown unlocked (warband) but THIS character hasn't finished
--                the intro chain (Ritual Interest 94383) → hub offers nothing
--   pickup     — unlocked + intro done, but the weekly quest isn't in the log
--   inprogress — the quest is in the log but not turned in
-- Returns (text, kind) or nil when the weekly is done / state is unknowable.
function ns.GetRitualWeeklyHint()
	if IsWeeklyDone() then
		return nil
	end
	local inLog = C_QuestLog and C_QuestLog.GetLogIndexForQuestID
		and C_QuestLog.GetLogIndexForQuestID(RITUAL_WEEKLY_QUEST)
	if inLog then
		return ns:L("RITUAL_WEEKLY_HINT_INPROGRESS"), "inprogress"
	end
	local unlocked, unlockDesc = RitualRenownUnlocked()
	if unlocked == false then
		if type(unlockDesc) == "string" and unlockDesc ~= "" then
			return ns:L("RITUAL_WEEKLY_HINT_LOCKED_FMT"):format(unlockDesc), "locked"
		end
		return ns:L("RITUAL_WEEKLY_HINT_LOCKED_GENERIC"), "locked"
	elseif unlocked == true then
		if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
			local ok, introDone = pcall(C_QuestLog.IsQuestFlaggedCompleted, RITUAL_INTRO_FINAL_QUEST)
			if ok and not introDone then
				-- Stap-bewust: hoogste voltooide stap + 1 = volgende stap
				-- (zie RITUAL_INTRO_CHAIN-comment over Blizzards bug-volgorde).
				local nextIdx = 1
				for i = #RITUAL_INTRO_CHAIN, 1, -1 do
					local okF, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, RITUAL_INTRO_CHAIN[i].quest)
					if okF and done then
						nextIdx = i + 1
						break
					end
				end
				local step = RITUAL_INTRO_CHAIN[nextIdx]
				if step then
					local txt = ns:L("RITUAL_INTRO_STEP_FMT"):format(nextIdx, #RITUAL_INTRO_CHAIN, ns:L(step.key))
					if C_QuestLog.GetLogIndexForQuestID
						and C_QuestLog.GetLogIndexForQuestID(step.quest) then
						txt = txt .. " " .. ns:L("RITUAL_INTRO_STEP_INLOG")
					end
					return txt, "intro"
				end
				-- Vangnet (hoort niet voor te komen: laatste stap true ↔ introDone).
				return ns:L("RITUAL_WEEKLY_HINT_INTRO"), "intro"
			end
		end
		return ns:L("RITUAL_WEEKLY_HINT_PICKUP"), "pickup"
	end
	return nil -- unlock state unknown + not in log → don't guess
end

-- Progress (1-100) of the ritual weekly's progress bar while it is on the
-- player. Mirrors ns.GetShowdownWeeklyProgress; returns nil when not on the
-- quest or the bar reads 0 (non-bar quests also read 0 — never claim a
-- percentage we can't trust).
function ns.GetRitualWeeklyProgress()
	if not (C_QuestLog and C_QuestLog.IsOnQuest) or type(GetQuestProgressBarPercent) ~= "function" then
		return nil
	end
	local okOn, onQuest = pcall(C_QuestLog.IsOnQuest, RITUAL_WEEKLY_QUEST)
	if not okOn or not onQuest then
		return nil
	end
	local ok, pct = pcall(GetQuestProgressBarPercent, RITUAL_WEEKLY_QUEST)
	if ok and type(pct) == "number" and pct > 0 then
		return math.floor(pct)
	end
	return nil
end

-- Renown/reputation text for the Ritual Sites faction (used by the Home tab too).
function ns.GetRitualRenownText()
	return GetRitualRenownText()
end

-- Primitives consumed by the combined Void & Rituals panel.
function ns.GetRitualSites()
	return SITES
end

function ns.RouteRitualSite(site)
	return RouteSite(site)
end

function ns.RouteRitualHub()
	return RouteHub()
end

function ns.GetRitualAccoladeInfo()
	return GetAccoladeInfo()
end

function ns.RitualSiteZoneName(site)
	return site and ZoneName(site.mapID) or nil
end

--------------------------------------------------------------------------------
-- Panel
--------------------------------------------------------------------------------

local SIDE_PAD = 14
local TOP_PAD = 12
local BTN_H = 26
local GAP = 8

local ui

local function SiteRowLabel(site, active)
	local label = site.name .. " — " .. ZoneName(site.mapID)
	if active then
		label = label .. "  |cffffcc00[" .. ns:L("RITUAL_ACTIVE_BADGE") .. "]|r"
	end
	return label
end

function ns.RefreshRitualPanel()
	if not ui or not ui.panel or not ui.panel:IsVisible() then
		return
	end

	local activeSite = ns.GetActiveRitualSite()
	local weeklyDone = IsWeeklyDone()

	if ui.activeFs then
		if activeSite then
			ui.activeFs:SetText(ns:L("RITUAL_ACTIVE_FMT"):format(activeSite.name .. " — " .. ZoneName(activeSite.mapID)))
			ui.activeFs:SetTextColor(1, 0.84, 0.18)
		else
			ui.activeFs:SetText(ns:L("RITUAL_ACTIVE_UNKNOWN"))
			ui.activeFs:SetTextColor(0.75, 0.78, 0.82)
		end
	end

	if ui.nextFs then
		local nextSite = GetNextWeekSite(activeSite)
		if nextSite then
			ui.nextFs:SetText(ns:L("RITUAL_NEXT_FMT"):format(nextSite.name .. " — " .. ZoneName(nextSite.mapID)))
			ui.nextFs:Show()
		else
			ui.nextFs:Hide()
		end
	end

	if ui.weeklyFs then
		if weeklyDone then
			ui.weeklyFs:SetText(ns:L("RITUAL_WEEKLY_DONE"))
			ui.weeklyFs:SetTextColor(0.45, 0.95, 0.5)
		else
			ui.weeklyFs:SetText(ns:L("RITUAL_WEEKLY_TODO"))
			ui.weeklyFs:SetTextColor(0.9, 0.82, 0.45)
		end
	end

	for _, btn in ipairs(ui.siteButtons) do
		local site = btn._mhSite
		local isActive = activeSite and activeSite.key == site.key
		btn:SetText(SiteRowLabel(site, isActive))
	end

	if ui.renownFs then
		local txt = GetRitualRenownText()
		if txt and txt ~= "" then
			ui.renownFs:SetText(ns:L("RITUAL_RENOWN_LABEL") .. ": " .. txt)
			ui.renownFs:SetTextColor(0.7, 0.6, 0.95)
		else
			ui.renownFs:SetText(ns:L("RITUAL_RENOWN_LOCKED"))
			ui.renownFs:SetTextColor(0.6, 0.62, 0.68)
		end
	end

	if ui.accoladesFs then
		local n, wkThis, wkMax = GetAccoladeInfo()
		if n then
			if wkMax and wkMax > 0 then
				ui.accoladesFs:SetText(ns:L("RITUAL_INFO_ACCOLADES_WEEKLY_FMT"):format(n, wkThis or 0, wkMax))
			else
				ui.accoladesFs:SetText(ns:L("RITUAL_INFO_ACCOLADES_FMT"):format(n))
			end
			ui.accoladesFs:Show()
		else
			ui.accoladesFs:Hide()
		end
	end
end

function ns.BuildRitualPanel(panel)
	if not panel or panel._mhRitualBuilt then
		return
	end
	panel._mhRitualBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("RITUAL_TITLE"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.75, 0.78, 0.82)
	subtitle:SetText(ns:L("RITUAL_SUBTITLE"))

	local activeFs = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	activeFs:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -14)
	activeFs:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	activeFs:SetJustifyH("LEFT")
	activeFs:SetWordWrap(true)

	local nextFs = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	nextFs:SetPoint("TOPLEFT", activeFs, "BOTTOMLEFT", 0, -3)
	nextFs:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	nextFs:SetJustifyH("LEFT")
	nextFs:SetWordWrap(true)

	local weeklyFs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	weeklyFs:SetPoint("TOPLEFT", nextFs, "BOTTOMLEFT", 0, -6)
	weeklyFs:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	weeklyFs:SetJustifyH("LEFT")

	local renownFs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	renownFs:SetPoint("TOPLEFT", weeklyFs, "BOTTOMLEFT", 0, -4)
	renownFs:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	renownFs:SetJustifyH("LEFT")
	renownFs:SetTextColor(0.7, 0.6, 0.95)

	local siteButtons = {}
	local prev = renownFs
	for i, site in ipairs(SITES) do
		local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
		btn:SetHeight(BTN_H)
		btn:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, (i == 1) and -GAP - 4 or -GAP)
		btn:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
		btn:SetText(SiteRowLabel(site, false))
		local fs = btn.GetFontString and btn:GetFontString()
		if fs then
			fs:SetJustifyH("LEFT")
			fs:ClearAllPoints()
			fs:SetPoint("LEFT", btn, "LEFT", 8, 0)
			fs:SetPoint("RIGHT", btn, "RIGHT", -8, 0)
		end
		btn._mhSite = site
		btn:SetScript("OnClick", function(self)
			RouteSite(self._mhSite)
		end)
		siteButtons[i] = btn
		prev = btn
	end

	local hubBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	hubBtn:SetHeight(BTN_H)
	hubBtn:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -GAP)
	hubBtn:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	hubBtn:SetText(ns:L("RITUAL_BTN_HUB"))
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
	note:SetPoint("TOPLEFT", hubBtn, "BOTTOMLEFT", 0, -GAP)
	note:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	note:SetJustifyH("LEFT")
	note:SetWordWrap(true)
	note:SetText(ns:L("RITUAL_MAP_NOTE"))

	-- Info section (fills the empty space below the buttons): what a Ritual Site
	-- is, where to grab the weekly, and the currency / reward summary.
	local infoHeader = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	infoHeader:SetPoint("TOPLEFT", note, "BOTTOMLEFT", 0, -GAP - 4)
	infoHeader:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	infoHeader:SetJustifyH("LEFT")
	infoHeader:SetTextColor(0.82, 0.68, 0.30)
	infoHeader:SetText(ns:L("RITUAL_INFO_HEADER"))

	local accoladesFs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	accoladesFs:SetPoint("TOPLEFT", infoHeader, "BOTTOMLEFT", 0, -6)
	accoladesFs:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	accoladesFs:SetJustifyH("LEFT")
	accoladesFs:SetTextColor(0.55, 0.78, 1)

	local infoKeys = { "RITUAL_INFO_PICKUP", "RITUAL_INFO_VAULT", "RITUAL_INFO_VENDOR", "RITUAL_INFO_PARTICLES", "RITUAL_INFO_TIERS", "RITUAL_INFO_RENOWN_REWARDS" }
	local infoLines = {}
	local prevInfo = accoladesFs
	for i = 1, #infoKeys do
		local fs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
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
		renownFs = renownFs,
		siteButtons = siteButtons,
		hubBtn = hubBtn,
		note = note,
		infoHeader = infoHeader,
		accoladesFs = accoladesFs,
		infoLines = infoLines,
	}

	panel:SetScript("OnShow", function()
		ns.RefreshRitualPanel()
	end)

	ns.RitualPanel = panel
	ns.RefreshRitualPanel()
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("RITUAL_TITLE"))
			ui.subtitle:SetText(ns:L("RITUAL_SUBTITLE"))
			ui.note:SetText(ns:L("RITUAL_MAP_NOTE"))
			ui.hubBtn:SetText(ns:L("RITUAL_BTN_HUB"))
			ui.infoHeader:SetText(ns:L("RITUAL_INFO_HEADER"))
			for _, fs in ipairs(ui.infoLines) do
				fs:SetText("• " .. ns:L(fs._mhKey))
			end
		end
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshRitualPanel()
		end
	end
end

-- Pre-warm the AreaPOI cache for the ritual/void zones at world entry. Active-
-- site detection reads C_AreaPoiInfo.GetAreaPOIForMap; if the player logs in or
-- teleports straight into an unrelated zone, that map's POIs may not be loaded
-- yet and the first detection misses. A cheap pcall primes the cache so the
-- panel resolves the active site on its first refresh. (Idea borrowed from the
-- EverythingDelves addon, which pre-warms delve zones the same way.)
local prewarmed = false
local function PrewarmPOIMaps()
	if prewarmed then
		return
	end
	prewarmed = true
	if not (C_AreaPoiInfo and C_AreaPoiInfo.GetAreaPOIForMap) then
		return
	end
	for _, site in ipairs(SITES) do
		pcall(C_AreaPoiInfo.GetAreaPOIForMap, site.mapID)
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("QUEST_LOG_UPDATE")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_UNGHOST")
ev:RegisterEvent("PLAYER_ALIVE")
ev:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ev:RegisterEvent("UPDATE_FACTION")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		PrewarmPOIMaps()
	end
	if event == "PLAYER_UNGHOST" or event == "PLAYER_ALIVE" then
		ReassertRouteAfterRevive()
	end
	if ui and ui.panel and ui.panel:IsShown() then
		ns.RefreshRitualPanel()
	end
end)
