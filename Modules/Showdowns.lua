--[[
	Showdowns — Midnight (12.0.7 "Revelations") rotating Void-world event.
	A portal in the Voidstorm (or the permanent Silvermoon portal) leads to one
	of two rotating Void worlds: Naigtal or Val. The weekly "Showdown on <zone>"
	awards a Riftstalker's Cache and fills the Great Vault World row. Heroic
	World Tier is an optional difficulty picked at the portal (no unlock).

	This module owns detection + ns.* helpers only; the section UI lives in
	WorldContent.lua (third section, after Ritual Sites and Void Assaults).
	Data comes from ShowdownsData.lua (ns.SHOWDOWNS). Val fields are nil until
	the next PTR rotation — every consumer nil-checks so the panel never lies
	(same pattern as VoidAssaults.lua).

	Gating: the section only shows on clients >= 120007 (live release ~16 June
	2026); see ns.IsShowdownsAvailable().
]]

local _, ns = ...

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

-- 12.0.7 clients only: the zones, quests and APIs (GetInstanceInfo ret11) do
-- not exist on 12.0.5 live, so the UI section hides itself entirely there.
function ns.IsShowdownsAvailable()
	if not ns.SHOWDOWNS then
		return false
	end
	local toc = select(4, GetBuildInfo())
	return (tonumber(toc) or 0) >= 120007
end

local function ZoneName(zone)
	if not zone then
		return nil
	end
	if zone.uiMapID and C_Map and C_Map.GetMapInfo then
		local info = C_Map.GetMapInfo(zone.uiMapID)
		if info and info.name and info.name ~= "" then
			return info.name
		end
	end
	-- Fallback for zones without a verified uiMapID yet (Val): proper noun
	-- from the data table, same in every locale.
	return zone.name or zone.key
end

local function IsQuestActiveOrDone(qid)
	if not (qid and C_QuestLog) then
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

-- Best-effort: the active world is the one whose Showdown weekly is on the
-- player or already completed this week (only the active world's weekly is
-- offered). Zones with a nil weekly (Val, until verified) can never match —
-- the UI then shows the "rotates" fallback instead of guessing.
local function DetectActiveZone()
	local d = ns.SHOWDOWNS
	if not d then
		return nil
	end
	for _, z in ipairs(d.zones) do
		if z.weekly and IsQuestActiveOrDone(z.weekly) then
			return z
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- Public API (consumed by WorldContent.lua; Home/checklist can reuse later)
--------------------------------------------------------------------------------

function ns.GetShowdownZones()
	return ns.SHOWDOWNS and ns.SHOWDOWNS.zones or nil
end

function ns.GetActiveShowdownZone()
	return DetectActiveZone()
end

function ns.ShowdownZoneName(zone)
	return ZoneName(zone)
end

function ns.GetActiveShowdownZoneName()
	local zone = DetectActiveZone()
	return zone and ZoneName(zone) or nil
end

function ns.IsShowdownWeeklyDone()
	local d = ns.SHOWDOWNS
	if not (d and C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return false
	end
	for _, z in ipairs(d.zones) do
		if z.weekly and C_QuestLog.IsQuestFlaggedCompleted(z.weekly) then
			return true
		end
	end
	return false
end

-- Progress (0-100) of the active weekly while it is on the player — the
-- Showdown weeklies are percentage quests ("Ethereal Operations Disrupted").
-- Returns nil when not on the quest or the API disagrees.
function ns.GetShowdownWeeklyProgress()
	local zone = DetectActiveZone()
	if not (zone and zone.weekly and C_QuestLog and C_QuestLog.IsOnQuest) then
		return nil
	end
	if not C_QuestLog.IsOnQuest(zone.weekly) then
		return nil
	end
	if type(GetQuestProgressBarPercent) == "function" then
		local ok, pct = pcall(GetQuestProgressBarPercent, zone.weekly)
		if ok and type(pct) == "number" then
			return pct
		end
	end
	return nil
end

-- Returns bossName, done for the active world. done is nil when the kill
-- quest id is not known yet (Val) — the UI shows "status unknown" then.
-- Returns nil when no active world is detected.
function ns.GetShowdownWorldBossStatus()
	local zone = DetectActiveZone()
	if not (zone and zone.bossName) then
		return nil
	end
	if not (zone.worldBossQuest and C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return zone.bossName, nil
	end
	return zone.bossName, C_QuestLog.IsQuestFlaggedCompleted(zone.worldBossQuest) and true or false
end

-- Returns inZone, hasWorldTier. hasWorldTier is GetInstanceInfo() ret11
-- (PTR-verified true inside Naigtal); only meaningful while in a Showdown
-- zone, so callers should hide the indicator when inZone is false.
function ns.GetShowdownHWTInfo()
	local d = ns.SHOWDOWNS
	local best = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player") or nil
	local inZone = false
	if d and best then
		for _, z in ipairs(d.zones) do
			if z.uiMapID and z.uiMapID == best then
				inZone = true
				break
			end
		end
	end
	if not inZone then
		return false, false
	end
	local hasWT = select(11, GetInstanceInfo())
	return true, hasWT and true or false
end

-- TomTom waypoint to Riftblade Maella (intro quest giver, Silvermoon City).
function ns.RouteShowdownIntro()
	local d = ns.SHOWDOWNS
	local npc = d and d.introNpc
	if not (npc and npc.mapID and ns.AddSmartTomTomWay) then
		return false
	end
	ns.MH_TomTomClearAll()
	return ns.AddSmartTomTomWay(npc.mapID, npc.x, npc.y, ns:L("SHOWDOWNS_WAYPOINT_MAELLA")) and true or false
end

-- TomTom waypoint to the Voidstorm portal. No-op (returns false) until the
-- Voidstorm uiMapID is verified on the PTR (portalVoidstorm.mapID is nil) —
-- WorldContent hides the button in that case.
function ns.RouteShowdownPortal()
	local d = ns.SHOWDOWNS
	local p = d and d.portalVoidstorm
	if not (p and p.mapID and ns.AddSmartTomTomWay) then
		return false
	end
	ns.MH_TomTomClearAll()
	return ns.AddSmartTomTomWay(p.mapID, p.x, p.y, ns:L("SHOWDOWNS_WAYPOINT_PORTAL")) and true or false
end
