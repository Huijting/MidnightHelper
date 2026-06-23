--[[
	Midnight Season 1 world bosses — Blizzard client data + account-week cache (SavedVariables).
	UI lives on the Delves & Vault tab (not SMC City Guide).
]]

local addonName, ns = ...

local QUEST_TAG_WORLD_BOSS = 289
local ROTATION_ANCHOR = time({ year = 2026, month = 3, day = 18, hour = 8, min = 0, sec = 0 })

local WORLD_BOSSES = {
	{
		id = "luashal",
		labelKey = "WB_BOSS_LUASHAL",
		zoneKey = "WB_ZONE_EVERSONG",
		mapID = 2395,
		x = 45.0,
		y = 60.0,
		questId = 92560,
	},
	{
		id = "cragpine",
		labelKey = "WB_BOSS_CRAGPINE",
		zoneKey = "WB_ZONE_ZULAMAN",
		mapID = 2437,
		x = 45.11,
		y = 47.73,
		questId = 92123,
	},
	{
		id = "thormbelan",
		labelKey = "WB_BOSS_THORMBELAN",
		zoneKey = "WB_ZONE_HARANDAR",
		mapID = 2413,
		x = 39.0,
		y = 67.57,
		questId = 92034,
	},
	{
		id = "predaxas",
		labelKey = "WB_BOSS_PREDAXAS",
		zoneKey = "WB_ZONE_VOIDSTORM",
		mapID = 2405,
		x = 49.08,
		y = 86.57,
		questId = 92636,
	},
}

local MAP_IDS_TO_SCAN = { 2395, 2437, 2413, 2405, 2576 }

ns.WORLD_BOSSES = WORLD_BOSSES

local BOSS_BY_QUEST = {}
local BOSS_BY_ID = {}
for i = 1, #WORLD_BOSSES do
	local b = WORLD_BOSSES[i]
	BOSS_BY_QUEST[b.questId] = b
	BOSS_BY_ID[b.id] = b
end

local function GetWeekResetAnchorTs()
	if ns.MhGetWeeklyResetAnchorTs then
		return ns.MhGetWeeklyResetAnchorTs()
	end
	if C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset then
		local ok, secs = pcall(C_DateAndTime.GetSecondsUntilWeeklyReset)
		if ok and secs and secs > 0 then
			local now = (GetServerTime and GetServerTime()) or time()
			return now + secs - 604800
		end
	end
	local now = time()
	local t = date("*t", now)
	if not t then
		return now
	end
	local daysSinceReset = ((tonumber(t.wday) or 1) - 4) % 7
	local anchor = time({
		year = t.year,
		month = t.month,
		day = t.day - daysSinceReset,
		hour = 8,
		min = 0,
		sec = 0,
	})
	if anchor and now < anchor then
		anchor = anchor - 7 * 24 * 60 * 60
	end
	return anchor or now
end

ns.GetWeekResetAnchorTs = GetWeekResetAnchorTs

local function CopyBoss(boss, x, y, mapID)
	local out = {}
	for k, v in pairs(boss) do
		out[k] = v
	end
	if x and y then
		out.x = x
		out.y = y
	end
	if mapID then
		out.mapID = mapID
	end
	return out
end

local function NormalizeMapPct(v)
	v = tonumber(v)
	if not v then
		return nil
	end
	if v > 0 and v <= 1 then
		return v * 100
	end
	return v
end

local function GetWbCacheTable()
	if not ns.db then
		return nil
	end
	ns.db.ui = ns.db.ui or {}
	ns.db.ui.worldBossWeek = ns.db.ui.worldBossWeek or {}
	return ns.db.ui.worldBossWeek
end

local function ClearStaleWbWeekCache()
	local cache = GetWbCacheTable()
	if not cache then
		return
	end
	local anchor = GetWeekResetAnchorTs()
	if (tonumber(cache.resetTs) or 0) == anchor then
		return
	end
	cache.resetTs = anchor
	cache.warbandDone = nil
	cache.completedBy = nil
	cache.bossId = nil
	cache.questId = nil
	cache.mapID = nil
	cache.x = nil
	cache.y = nil
	cache.source = nil
	cache.savedAt = nil
end

local function MarkWarbandDone(boss, completedBy)
	local cache = GetWbCacheTable()
	if not cache then
		return
	end
	cache.resetTs = GetWeekResetAnchorTs()
	cache.warbandDone = true
	if boss and boss.id then
		cache.bossId = boss.id
		cache.questId = boss.questId
	end
	if completedBy and completedBy ~= "" then
		cache.completedBy = completedBy
	end
	cache.savedAt = time()
end

-- Robuuste, niet-wisbare completer-naam per boss (account-breed, los van de
-- weekly cache die door anchor-randgevallen gewist kon worden — daardoor viel de
-- naam op alts weg: "defeated this week" zónder "by …", Rob 21 jun). Per anchor
-- gevalideerd zodat 'ie na de reset vanzelf vervalt.
local function RecordWbCompleter(boss, who)
	if not ns.db or not boss or not boss.id or type(who) ~= "string" or who == "" then
		return
	end
	ns.db.ui = ns.db.ui or {}
	ns.db.ui.worldBossCompleter = ns.db.ui.worldBossCompleter or {}
	ns.db.ui.worldBossCompleter[boss.id] = { who = who, anchor = GetWeekResetAnchorTs() }
end

local function GetWbCompleter(boss)
	if not (ns.db and ns.db.ui and ns.db.ui.worldBossCompleter) or not boss or not boss.id then
		return nil
	end
	local rec = ns.db.ui.worldBossCompleter[boss.id]
	if type(rec) == "table" and (tonumber(rec.anchor) or 0) == GetWeekResetAnchorTs() then
		return rec.who
	end
	return nil
end

local function SaveWbWeekCache(boss, source)
	local cache = GetWbCacheTable()
	if not cache or not boss or not boss.id then
		return
	end
	cache.resetTs = GetWeekResetAnchorTs()
	cache.bossId = boss.id
	cache.questId = boss.questId
	cache.mapID = boss.mapID
	cache.x = boss.x
	cache.y = boss.y
	cache.source = source
	cache.savedAt = time()
end

local function LoadWbWeekCache()
	local cache = GetWbCacheTable()
	if not cache or not cache.bossId then
		return nil
	end
	if (tonumber(cache.resetTs) or 0) ~= GetWeekResetAnchorTs() then
		return nil
	end
	local base = BOSS_BY_ID[cache.bossId]
	if not base then
		return nil
	end
	return CopyBoss(base, cache.x, cache.y, cache.mapID), true, "cache"
end

--- Weekly boss loot: only trust the current week's flagged completion (not lifetime quest history).
local function IsQuestCompletedThisWeek(questId)
	if not questId or not C_QuestLog or not C_QuestLog.IsQuestFlaggedCompleted then
		return false
	end
	local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, questId)
	return ok and done == true
end

-- Account-wide weekly completion: true as soon as ANY warband character looted
-- the boss this week. Same OnAccount API that fixed the Omnium Folio alt bug
-- (Rob 21 jun): the per-char flag is false on an alt that didn't loot, but the
-- account flag is true. The world-boss loot quest resets weekly, so this reads
-- "did the warband do it this week" — robust even when our own account-cache was
-- never written/was wiped on this alt. Read-only, taint-safe via pcall.
local function IsQuestCompletedOnAccountThisWeek(questId)
	if not questId or not C_QuestLog or not C_QuestLog.IsQuestFlaggedCompletedOnAccount then
		return false
	end
	local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompletedOnAccount, questId)
	return ok and done == true
end

local function TryTaskQuestActive(questId)
	if not questId then
		return false
	end
	if C_TaskQuest and C_TaskQuest.IsActive then
		local ok, active = pcall(C_TaskQuest.IsActive, questId)
		if ok and active then
			return true
		end
	end
	if C_TaskQuest and C_TaskQuest.GetQuestTimeLeftMinutes then
		local ok, mins = pcall(C_TaskQuest.GetQuestTimeLeftMinutes, questId)
		if ok and mins and mins > 0 then
			return true
		end
	end
	return false
end

local function IsWorldBossAvailableThisWeek(boss)
	if not boss or not boss.questId then
		return false
	end
	return TryTaskQuestActive(boss.questId)
end

local function SyncWarbandDoneFromQuestLog(activeBoss)
	ClearStaleWbWeekCache()
	-- GEEN availability-early-return meer (Robs paladin, 12 jun): de WQ is
	-- per-char beschikbaar, dus "deze char kan 'm nog doen" zegt niets over
	-- de warband — de oude guard maskeerde de account-cache op alts en
	-- toonde "not defeated" terwijl een andere char al geregistreerd had.
	if activeBoss and activeBoss.questId and IsQuestCompletedThisWeek(activeBoss.questId) then
		local who = UnitName and UnitName("player")
		MarkWarbandDone(activeBoss, who)
		RecordWbCompleter(activeBoss, who)
		return activeBoss, who
	end
	-- Any warband char looted it this week (account-wide flag). Robust on alts even
	-- if our own cache was never written/was wiped. We can't get the name from the
	-- API, so keep any previously stored completedBy (MarkWarbandDone with nil keeps it).
	if activeBoss and activeBoss.questId and IsQuestCompletedOnAccountThisWeek(activeBoss.questId) then
		MarkWarbandDone(activeBoss, nil)
		local accCache = GetWbCacheTable()
		return activeBoss, accCache and accCache.completedBy or nil
	end
	local cache = GetWbCacheTable()
	if cache and cache.warbandDone and (tonumber(cache.resetTs) or 0) == GetWeekResetAnchorTs() then
		local base = cache.bossId and BOSS_BY_ID[cache.bossId]
		if base and (not activeBoss or base.id == activeBoss.id) then
			return base, cache.completedBy
		end
	end
	return nil, nil
end

function ns.IsWorldBossKilled(boss)
	if not boss or not boss.questId then
		return false
	end
	ClearStaleWbWeekCache()
	-- GEEN availability-early-return (Robs warband-bug 15 jun): de WQ is per-char
	-- beschikbaar, dus "deze char kan 'm nog doen" zegt niets over de warband. De
	-- oude `if IsWorldBossAvailableThisWeek then return false` maskeerde de account-
	-- cache op alts → toonde "Warband: not defeated" terwijl een andere char 'm al
	-- versloeg. Zelfde fix als eerder in SyncWarbandDoneFromQuestLog. Week-reset
	-- wordt al door ClearStaleWbWeekCache afgevangen, dus de cache is week-vers.
	SyncWarbandDoneFromQuestLog(boss)
	local cache = GetWbCacheTable()
	if cache and cache.warbandDone and (tonumber(cache.resetTs) or 0) == GetWeekResetAnchorTs() then
		if not cache.bossId or cache.bossId == boss.id then
			return true
		end
	end
	if IsQuestCompletedThisWeek(boss.questId) then
		local who = UnitName and UnitName("player")
		MarkWarbandDone(boss, who)
		RecordWbCompleter(boss, who)
		return true
	end
	return false
end

function ns.GetWorldBossWarbandCompleter()
	local boss = ns.GetActiveWorldBoss and ns.GetActiveWorldBoss()
	local _, who = SyncWarbandDoneFromQuestLog(boss)
	if type(who) == "string" and who ~= "" then
		return who
	end
	-- Niet-wisbare account-opslag (overleeft de weekly-cache-wipe op alts).
	local robust = GetWbCompleter(boss)
	if type(robust) == "string" and robust ~= "" then
		return robust
	end
	local cache = GetWbCacheTable()
	if cache and (tonumber(cache.resetTs) or 0) == GetWeekResetAnchorTs() then
		return cache.completedBy
	end
	return nil
end

function ns.IsWorldBossDoneOnThisCharacter(boss)
	if not boss or not boss.questId then
		return false
	end
	if IsWorldBossAvailableThisWeek(boss) then
		return false
	end
	return IsQuestCompletedThisWeek(boss.questId)
end

local function BossFromQuestId(questId, x, y, mapID)
	local base = BOSS_BY_QUEST[questId]
	if base then
		return CopyBoss(base, NormalizeMapPct(x), NormalizeMapPct(y), mapID)
	end
	return nil
end

local function ScanTaskQuestMap(mapID)
	if not mapID or not C_TaskQuest or not C_TaskQuest.GetQuestsForPlayerByMapID then
		return nil
	end
	local ok, tasks = pcall(C_TaskQuest.GetQuestsForPlayerByMapID, mapID)
	if not ok or type(tasks) ~= "table" then
		return nil
	end
	for ti = 1, #tasks do
		local poi = tasks[ti]
		local qid = poi and (poi.questID or poi.questId)
		if qid then
			local poiMap = tonumber(poi.mapID) or mapID
			local boss = BossFromQuestId(qid, poi.x, poi.y, poiMap)
			if boss then
				return boss
			end
		end
	end
	return nil
end

local function ScanQuestLogMap(mapID)
	if not mapID or not C_QuestLog or not C_QuestLog.GetQuestsOnMap then
		return nil
	end
	local ok, quests = pcall(C_QuestLog.GetQuestsOnMap, mapID)
	if not ok or type(quests) ~= "table" then
		return nil
	end
	for qi = 1, #quests do
		local q = quests[qi]
		local qid = q and (q.questID or q.questId)
		if qid then
			local boss = BossFromQuestId(qid, q.x, q.y, mapID)
			if boss then
				return boss
			end
		end
	end
	return nil
end

local function QueryLiveWorldBoss()
	for i = 1, #WORLD_BOSSES do
		local boss = WORLD_BOSSES[i]
		if TryTaskQuestActive(boss.questId) then
			return CopyBoss(boss), true, "task_active"
		end
	end
	for mi = 1, #MAP_IDS_TO_SCAN do
		local boss = ScanTaskQuestMap(MAP_IDS_TO_SCAN[mi])
		if boss then
			return boss, true, "task_map"
		end
	end
	for mi = 1, #MAP_IDS_TO_SCAN do
		local boss = ScanQuestLogMap(MAP_IDS_TO_SCAN[mi])
		if boss then
			return boss, true, "quest_map"
		end
	end
	return nil, false, nil
end

local function GetScheduledWorldBoss()
	local anchor = ROTATION_ANCHOR
	if not anchor or anchor <= 0 then
		return WORLD_BOSSES[1]
	end
	local weeks = math.floor((time() - anchor) / (7 * 86400))
	if weeks < 0 then
		weeks = 0
	end
	return WORLD_BOSSES[(weeks % #WORLD_BOSSES) + 1]
end

function ns.GetActiveWorldBoss()
	local boss, fromClient, source = QueryLiveWorldBoss()
	if fromClient and boss then
		SaveWbWeekCache(boss, source)
		return boss, true, source
	end

	local cached = LoadWbWeekCache()
	if cached then
		boss = cached
		fromClient = true
		source = "cache"
	else
		boss = GetScheduledWorldBoss()
		fromClient = false
		source = "schedule"
	end

	SyncWarbandDoneFromQuestLog(boss)
	return boss, fromClient, source
end

function ns.RouteToWorldBoss(boss)
	if not boss or not boss.mapID or not boss.x or not boss.y then
		return false
	end
	local name = ns:L(boss.labelKey)
	local zone = ns:L(boss.zoneKey)
	local title = ("%s — %s"):format(name, zone)
	if ns.AddSmartTomTomWay then
		ns.AddSmartTomTomWay(boss.mapID, boss.x, boss.y, title)
		print(
			("|cffffcc00%s|r %s"):format(
				ns:L("PRINT_PREFIX"),
				ns:L("WB_ROUTE_CHAT_FMT"):format(name, boss.mapID, boss.x, boss.y)
			)
		)
		return true
	end
	if ns.SetBlizzardUserWaypoint then
		ns.SetBlizzardUserWaypoint(boss.mapID, boss.x, boss.y)
		print(
			("|cffffcc00%s|r %s"):format(
				ns:L("PRINT_PREFIX"),
				ns:L("BLIZZARD_WAYPOINT_SET"):format(title)
			)
		)
		return true
	end
	return false
end

function ns.RouteToActiveWorldBoss()
	local boss, fromClient = ns.GetActiveWorldBoss()
	if not boss then
		return false
	end
	if not fromClient then
		print(
			("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("WB_OPEN_MAP_HINT"))
		)
		return false
	end
	return ns.RouteToWorldBoss(boss)
end

--------------------------------------------------------------------------------
-- Delves & Vault tab UI (compact when warband done)
--------------------------------------------------------------------------------

local function PlayerLabel()
	local name = UnitName and UnitName("player")
	if type(name) == "string" and name ~= "" then
		return name
	end
	return ns:L("WB_THIS_CHARACTER")
end

local function EnsureDelvesHost(parent)
	if not parent then
		return nil
	end
	if parent._mhWorldBossHost then
		return parent._mhWorldBossHost
	end

	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1

	local host = CreateFrame("Frame", nil, parent)
	host:SetHeight(1)

	local line = host:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	line:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	line:SetPoint("TOPLEFT", host, "TOPLEFT", 0, 0)
	line:SetPoint("TOPRIGHT", host, "TOPRIGHT", 0, 0)
	line:SetJustifyH("LEFT")
	line:SetHeight(16 * s)

	local title = host:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightMedium"))
	title:SetPoint("TOPLEFT", host, "TOPLEFT", 0, 0)
	title:SetTextColor(1, 0.82, 0.45)

	local activeFs = host:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	activeFs:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	activeFs:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2 * s)
	activeFs:SetJustifyH("LEFT")

	local zoneFs = host:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	zoneFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	zoneFs:SetPoint("TOPLEFT", activeFs, "BOTTOMLEFT", 0, -2 * s)
	zoneFs:SetJustifyH("LEFT")

	local metaFs = host:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	metaFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	metaFs:SetPoint("TOPLEFT", zoneFs, "BOTTOMLEFT", 0, -2 * s)
	metaFs:SetJustifyH("LEFT")

	local routeBtn = CreateFrame("Button", nil, host, "UIPanelButtonTemplate")
	routeBtn:SetHeight(28 * s)
	routeBtn:SetPoint("TOPLEFT", metaFs, "BOTTOMLEFT", 0, -6 * s)
	routeBtn:SetPoint("TOPRIGHT", host, "TOPRIGHT", 0, 0)
	routeBtn:SetScript("OnClick", function()
		ns.RouteToActiveWorldBoss()
	end)
	routeBtn:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	parent._mhWorldBossHost = host
	parent._mhWorldBossRefs = {
		host = host,
		line = line,
		title = title,
		active = activeFs,
		zone = zoneFs,
		meta = metaFs,
		routeBtn = routeBtn,
	}
	return host
end

function ns.MH_RefreshWorldBossDelvesBlock(parent)
	local host = EnsureDelvesHost(parent)
	local ref = parent and parent._mhWorldBossRefs
	if not host or not ref then
		return 0
	end
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1

	local boss, fromClient, source = ns.GetActiveWorldBoss()
	if not boss then
		host:SetHeight(0)
		host:Hide()
		return 0
	end

	host:Show()
	local name = ns:L(boss.labelKey)
	local zone = ns:L(boss.zoneKey)
	local warbandDone = ns.IsWorldBossKilled(boss)
	local thisCharDone = ns.IsWorldBossDoneOnThisCharacter(boss)
	local completer = ns.GetWorldBossWarbandCompleter()

	if warbandDone then
		ref.line:Show()
		ref.title:Hide()
		ref.active:Hide()
		ref.zone:Hide()
		ref.meta:Hide()
		ref.routeBtn:Hide()

		if thisCharDone then
			ref.line:SetText(ns:L("WB_DONE_COMPACT_FMT"):format(name, PlayerLabel()))
		elseif completer and completer ~= "" then
			ref.line:SetText(ns:L("WB_WARBAND_DONE_OTHER_FMT"):format(name, completer))
		else
			ref.line:SetText(ns:L("WB_WARBAND_DONE_FMT"):format(name))
		end
		ref.line:SetTextColor(0.45, 0.92, 0.55)

		-- Hoogte volgt de tekstschaal (zelfde stap als de teruggegeven blokhoogte).
		ref.line:SetHeight(16 * s)
		host:SetHeight(18 * s)
		return 18 * s
	end

	ref.line:Hide()
	ref.title:Show()
	ref.active:Show()
	ref.zone:Show()
	ref.meta:Show()

	ref.title:SetText(ns:L("WB_SECTION_TITLE"))
	ref.title:ClearAllPoints()
	ref.title:SetPoint("TOPLEFT", host, "TOPLEFT", 0, 0)

	if fromClient then
		ref.active:SetText(ns:L("WB_ACTIVE_FMT"):format(name))
	else
		ref.active:SetText(ns:L("WB_GUESS_FMT"):format(name))
	end
	ref.active:SetTextColor(1, 0.94, 0.75)
	ref.active:SetWidth(host:GetWidth() or 400)

	ref.zone:SetText(ns:L("WB_ZONE_FMT"):format(zone))
	ref.zone:SetTextColor(0.85, 0.88, 0.92)

	if fromClient then
		if source == "cache" then
			ref.meta:SetText(ns:L("WB_CACHED_NOTE"))
			ref.meta:SetTextColor(0.65, 0.82, 0.95)
		elseif source == "task_map" or source == "quest_map" then
			ref.meta:SetText(ns:L("WB_DETECTED_MAP"))
			ref.meta:SetTextColor(0.45, 0.92, 0.55)
		else
			ref.meta:SetText(ns:L("WB_DETECTED_LIVE"))
			ref.meta:SetTextColor(0.45, 0.92, 0.55)
		end
	else
		ref.meta:SetText(ns:L("WB_NOT_DETECTED"))
		ref.meta:SetTextColor(0.95, 0.72, 0.35)
	end

	if fromClient and boss.x and boss.y then
		ref.routeBtn:Show()
		ref.routeBtn:Enable()
		ref.routeBtn:SetAlpha(1)
		ref.routeBtn:SetText(ns:L("WB_ROUTE_BTN"):format(name))
		ref.routeBtn:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:SetText(ns:L("WB_ROUTE_BTN"):format(name), 1, 0.9, 0.6)
			GameTooltip:AddLine(ns:L("WB_TOOLTIP_BODY"), 0.9, 0.9, 0.9, true)
			GameTooltip:Show()
		end)
	else
		ref.routeBtn:Show()
		ref.routeBtn:Disable()
		ref.routeBtn:SetAlpha(0.55)
		ref.routeBtn:SetText(ns:L("WB_ROUTE_BTN_DISABLED"))
	end

	-- Blokhoogte schaalt mee met de tekst (zelfde factor als de gestapelde
	-- font-strings + knop), zodat het volgende blok niet overlapt.
	host:SetHeight(108 * s)
	return 108 * s
end

function ns.MH_LayoutWorldBossDelves(delvesFrame, vaultToggleBar)
	if not delvesFrame then
		return
	end
	local h = ns.MH_RefreshWorldBossDelvesBlock(delvesFrame) or 0
	local host = delvesFrame._mhWorldBossHost
	if host then
		host:ClearAllPoints()
		host:SetPoint("TOPLEFT", delvesFrame, "TOPLEFT", 6, -3)
		host:SetPoint("TOPRIGHT", delvesFrame, "TOPRIGHT", -6, -3)
	end
	if vaultToggleBar then
		vaultToggleBar:ClearAllPoints()
		if host and host:IsShown() and h > 0 then
			vaultToggleBar:SetPoint("TOPLEFT", host, "BOTTOMLEFT", 0, -4)
			vaultToggleBar:SetPoint("TOPRIGHT", host, "BOTTOMRIGHT", 0, -4)
		else
			vaultToggleBar:SetPoint("TOPLEFT", delvesFrame, "TOPLEFT", 6, -3)
			vaultToggleBar:SetPoint("TOPRIGHT", delvesFrame, "TOPRIGHT", -6, -3)
		end
	end
end

do
	ns._mhSMCGuideSearchRows = ns._mhSMCGuideSearchRows or {}
	ns._mhSMCGuideSearchRows[#ns._mhSMCGuideSearchRows + 1] = {
		blob = "world boss wb luashal cragpine thormbelan predaxas delves vault",
		point = { _mhNavY = 0, _mhWorldBossRoute = true, _mhDelvesWorldBoss = true },
	}
end

local probePending = false
local function RunBackgroundWorldBossProbe()
	if probePending then
		return
	end
	probePending = true
	SyncWarbandDoneFromQuestLog()
	local mapIndex = 1
	local function step()
		local boss, live, source = QueryLiveWorldBoss()
		if live and boss then
			SaveWbWeekCache(boss, source)
			probePending = false
			ns.MH_RefreshWorldBossDelvesBlock(ns.panels and ns.panels.delves)
			if ns.RefreshDelvesPanel then
				ns.RefreshDelvesPanel(false)
			end
			return
		end
		if mapIndex <= #MAP_IDS_TO_SCAN then
			local b = ScanTaskQuestMap(MAP_IDS_TO_SCAN[mapIndex])
			mapIndex = mapIndex + 1
			if b then
				SaveWbWeekCache(b, "task_map")
				probePending = false
				ns.MH_RefreshWorldBossDelvesBlock(ns.panels and ns.panels.delves)
				if ns.RefreshDelvesPanel then
					ns.RefreshDelvesPanel(false)
				end
				return
			end
			if C_Timer and C_Timer.After then
				C_Timer.After(0.2, step)
			else
				step()
			end
			return
		end
		probePending = false
	end
	step()
end

local function OnWorldBossEvent()
	SyncWarbandDoneFromQuestLog()
	if ns.panels and ns.panels.delves then
		ns.MH_RefreshWorldBossDelvesBlock(ns.panels.delves)
	end
	if ns.RefreshDelvesPanel then
		ns.RefreshDelvesPanel(false)
	end
end

local wbFrame = CreateFrame("Frame")
wbFrame:RegisterEvent("QUEST_LOG_UPDATE")
wbFrame:RegisterEvent("QUEST_TURNED_IN")
wbFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
wbFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
wbFrame:RegisterEvent("PLAYER_LOGIN")
wbFrame:SetScript("OnEvent", function(_, event, ...)
	if event == "QUEST_TURNED_IN" then
		local questId = ...
		local b = questId and BOSS_BY_QUEST[questId]
		if b then
			-- World-boss weekly loot is warband-gated; persist completion so alts reflect it immediately.
			MarkWarbandDone(b, UnitName and UnitName("player"))
		end
	end
	if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
		if C_Timer and C_Timer.After then
			C_Timer.After(event == "PLAYER_LOGIN" and 2 or 0.5, RunBackgroundWorldBossProbe)
		else
			RunBackgroundWorldBossProbe()
		end
	end
	OnWorldBossEvent()
end)

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if type(orig) == "function" then
			orig(self)
		end
		OnWorldBossEvent()
	end
end

-- Legacy SMC entry points (no-op / redirect)
function ns.MH_BuildWorldBossSMCBlock(panel, scrollContent, startY)
	return startY or 0
end

ns.MH_RefreshWorldBossSMCBlock = function() end
