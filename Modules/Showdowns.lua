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

--- ⚠️ THESE WEEKLIES STOP BEING OFFERED WHEN SEASON 2 OPENS. Blizzard, hotfixes of
--- 13 Aug 2026, verbatim: "The Naigtal and Val Sparks of War quests will no longer be
--- offered when Season 2 begins."
---
--- Without this the section keeps standing on 18 August with a weekly nobody can pick
--- up — an item that reads as "you still have to do this" and can never be finished.
--- That is the same failure as the crest rows this morning: not a crash, a confident
--- wrong answer in the panel whose whole job is telling you what is left.
---
--- ⚠️ BUT THE SEASON IS NOT THE WHOLE ANSWER, and this is where the crest fix earlier
--- today taught us something. "No longer offered" is about NEW quests. Somebody who has
--- one in their log at the flip still has it, and hiding it would take a real to-do off
--- their list. So the season closes the door for new pickups and an open quest keeps it
--- open for whoever is already through it — the player, not the calendar.
---
--- 🔴 SETTLED 4 Oct 2026 (mh-research, twice): THE HOTFIX IS NOT ABOUT THESE QUESTS. "Sparks of
--- War" are separate PvP weeklies from Zerella in Silvermoon (npc 254971): 96725 "Sparks of War:
--- Val" and 96726 "...: Naigtal" were dropped, while 93423-93426 and 96808 run on in Season 2
--- (Blizzard hotfixes 18 Aug, 25 Aug, 3 Sep). Maella's "Showdown on Val/Naigtal" (96713 / 96714 /
--- 96717 / 96718) are a different quest line. So this gate rests on a misread; Wowhead (3 Aug) and
--- Icy Veins (15 Aug, 29 Sep) say the Showdown weekly continues in S2.
---
--- ✅ GEMETEN 4 Oct 2026, AND THE GATE IS GONE. Rob on Redisch: Maella offered the intro "Through
--- the Cold Rift", the portal showed Val with Normal/Heroic, and on Val she offered "Showdown on Val"
--- (Riftstalker's Cache) next to "Surveying the Frozen Wastes". The Season 2 hide had kept this
--- weekly out of every list since 18 Aug.

-- 12.0.7 clients only: the zones, quests and APIs (GetInstanceInfo ret11) do
-- not exist on 12.0.5 live, so the UI section hides itself entirely there.
function ns.IsShowdownsAvailable()
	if not ns.SHOWDOWNS then
		return false
	end
	local toc = select(4, GetBuildInfo())
	if (tonumber(toc) or 0) < 120007 then
		return false
	end
	return true
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

-- Every weekly id a zone can present. Heroic World Tier is a free choice at the
-- portal and it is a DIFFERENT quest: Naigtal is 96717 normal, 96718 heroic
-- (measured 29 jul 2026). Checking only the normal id meant that whoever picked
-- Heroic finished the weekly and got told all week that it was still open.
local function WeeklyIDs(z)
	if type(z) ~= "table" then
		return {}
	end
	local ids = {}
	if z.weekly then
		ids[#ids + 1] = z.weekly
	end
	if z.weeklyHeroic then
		ids[#ids + 1] = z.weeklyHeroic
	end
	return ids
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
		for _, id in ipairs(WeeklyIDs(z)) do
			if IsQuestActiveOrDone(id) then
				return z
			end
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
		for _, id in ipairs(WeeklyIDs(z)) do
			if C_QuestLog.IsQuestFlaggedCompleted(id) then
				return true
			end
		end
	end
	return false
end

-- Progress (0-100) of the active weekly while it is on the player — the
-- Showdown weeklies are percentage quests ("Ethereal Operations Disrupted").
-- Returns nil when not on the quest or the API disagrees.
function ns.GetShowdownWeeklyProgress()
	local zone = DetectActiveZone()
	if not (zone and C_QuestLog and C_QuestLog.IsOnQuest) then
		return nil
	end
	-- Report on whichever variant is actually on the player, normal or heroic.
	for _, id in ipairs(WeeklyIDs(zone)) do
		local okOn, onQuest = pcall(C_QuestLog.IsOnQuest, id)
		if okOn and onQuest and type(GetQuestProgressBarPercent) == "function" then
			local ok, pct = pcall(GetQuestProgressBarPercent, id)
			if ok and type(pct) == "number" then
				return pct
			end
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
	local ids = zone.worldBossQuests or (zone.worldBossQuest and { zone.worldBossQuest })
	if not (ids and C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return zone.bossName, nil
	end
	-- "Any of": the weekly world quest and the old killquest (ShowdownsData.lua, 3 Oct 2026).
	for _, qid in ipairs(ids) do
		local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, qid)
		if ok and done then
			return zone.bossName, true
		end
	end
	return zone.bossName, false
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

--------------------------------------------------------------------------------
-- `/mh showdown` — which Showdown weekly is actually in your log?
--
-- Rob accepted "Showdown on Naigtal (HEROIC)" after the reset (29 jul 2026), and
-- its reward is a "Riftstalker's OVERFLOWING Cache" — a different item from the
-- plain Riftstalker's Cache this file records. Two different reward items usually
-- means two different quests, and ns.SHOWDOWNS knows exactly one id per zone.
--
-- If Heroic carries its own id, IsShowdownWeeklyDone would never see it: you would
-- finish the weekly and MH would keep telling you it is open, every week, for
-- anyone who picks Heroic at the portal.
--
-- So this does not guess. It walks the real quest log, prints every entry whose
-- title mentions Showdown with its id, and says whether that id is one we know.
-- Whatever comes back is measured, and the fix follows from it.
--------------------------------------------------------------------------------
function ns.PrintShowdownDiagnostics()
	local p = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s Showdown weekly — what the quest log actually says:"):format(p))

	local known = {}
	for _, z in ipairs((ns.SHOWDOWNS and ns.SHOWDOWNS.zones) or {}) do
		for _, id in ipairs(WeeklyIDs(z)) do
			known[id] = z.name or "?"
		end
	end
	for id, zone in pairs(known) do
		local onQuest, done = "?", "?"
		if C_QuestLog and C_QuestLog.IsOnQuest then
			local ok, v = pcall(C_QuestLog.IsOnQuest, id)
			onQuest = ok and tostring(v) or "error"
		end
		if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
			local ok, v = pcall(C_QuestLog.IsQuestFlaggedCompleted, id)
			done = ok and tostring(v) or "error"
		end
		print(("   known id %d (%s) — on quest: %s, completed: %s"):format(id, zone, onQuest, done))
	end

	if not (C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo) then
		print("   (cannot walk the quest log on this client)")
		return
	end
	local okN, n = pcall(C_QuestLog.GetNumQuestLogEntries)
	if not okN or not n then
		print("   (quest log unreadable)")
		return
	end
	local found = 0
	for i = 1, n do
		local okI, info = pcall(C_QuestLog.GetInfo, i)
		if okI and type(info) == "table" and not info.isHeader and info.title then
			local title = tostring(info.title)
			if title:lower():find("showdown", 1, true) then
				found = found + 1
				local id = info.questID
				local tag = known[id] and "|cff40c040known|r" or "|cffff8080NOT IN OUR DATA|r"
				print(("   log: \"%s\" — questID %s — %s"):format(title, tostring(id), tag))
			end
		end
	end
	if found == 0 then
		print("   no Showdown quest in your log right now (accept it at the portal first)")
	end
end
