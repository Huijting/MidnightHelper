--[[
	Dungeon Coach — roster data (data-only, no UI). See docs/DUNGEON_COACH_PLAN.md.

	Sources (10 Jun 2026):
	  - Season 1 journalInstanceIDs + journal encounterIDs mirrored from Rob's
	    local BossHelper addon (MIT) and cross-checked against Method's M+
	    guide list. Spot-check in-game: /dump EJ_GetInstanceInfo(1315) etc.
	  - Launch (native) roster from DungeonHelper's instance map (names only;
	    EJ ids for the four launch-only dungeons still to dump — nil until
	    verified, never guessed).
	  - Normal/Follower carries ALL native launch dungeons; Heroic/M0/M+ uses
	    the Season 1 rotation (4 native + 4 legacy). Follower Dungeons:
	    levels 80-90, ~ilvl 214 rewards, daily start cap (launch: ~10/day).

	never-lie: journalInstanceID/encounterID nil = display falls back to the
	English `name` field.

	Entrance coordinates (11 Jun): mirrored from the ZygorGuidesViewer
	LibRover dungeon-portal data on Rob's machine (factual map data, used as
	cross-reference only — Zygor is proprietary, no text reused) with zone
	names resolved to uiMapIDs via Zygor's Midnight zone table + MH's own
	Rares.lua mapping. In-game spot-check by Rob pending; a slightly-off pin
	is cosmetic, the portals are unmissable.
]]

local _, ns = ...

ns.DUNGEON_ROSTER = {
	-- Native launch dungeons (Normal + Follower; season1 = also in the
	-- Heroic/M+ rotation this season).
	{
		key = "maisara",
		name = "Maisara Caverns",
		journalInstanceID = 1315,
		native = true,
		season1 = true,
		entrance = { mapID = 2437, x = 43.74, y = 39.43 }, -- Zul'Aman
		bosses = {
			{ key = "murojin", encounterID = 2810, name = "Muro'jin and Nekraxx" },
			{ key = "vordaza", encounterID = 2811, name = "Vordaza" },
			{ key = "raktul", encounterID = 2812, name = "Rak'tul, Vessel of Souls" },
		},
	},
	{
		key = "magisters",
		name = "Magisters' Terrace",
		-- 1300 = the Midnight revamp (Rob's EJ scan 10 jun); BossHelper's 249
		-- was the legacy TBC journal entry — do not use it.
		journalInstanceID = 1300,
		native = true,
		season1 = true,
		entrance = { mapID = 2424, x = 63.53, y = 15.48 }, -- Isle of Quel'Danas (Midnight)
		bosses = {
			{ key = "arcanotron", encounterID = 2659, name = "Arcanotron Custos" },
			{ key = "seranel", encounterID = 2661, name = "Seranel Sunlash" },
			{ key = "gemellus", encounterID = 2660, name = "Gemellus" },
			{ key = "degentrius", encounterID = 2662, name = "Degentrius" },
		},
	},
	{
		key = "nexuspoint",
		name = "Nexus-Point Xenas",
		journalInstanceID = 1316,
		native = true,
		season1 = true,
		entrance = { mapID = 2405, x = 64.93, y = 61.78 }, -- Voidstorm
		bosses = {
			{ key = "kasreth", encounterID = 2813, name = "Chief Corewright Kasreth" },
			{ key = "nysarra", encounterID = 2814, name = "Corewarden Nysarra" },
			{ key = "lothraxion", encounterID = 2815, name = "Lothraxion" },
		},
	},
	{
		key = "windrunnerspire",
		name = "Windrunner Spire",
		journalInstanceID = 1299,
		native = true,
		season1 = true,
		entrance = { mapID = 2395, x = 35.37, y = 78.82 }, -- Eversong Woods
		bosses = {
			{ key = "derelictduo", encounterID = 2656, name = "Derelict Duo" },
			{ key = "emberdawn", encounterID = 2655, name = "Emberdawn" },
			{ key = "kroluk", encounterID = 2657, name = "Commander Kroluk" },
			{ key = "restlessheart", encounterID = 2658, name = "The Restless Heart" },
		},
	},
	-- Native launch dungeons outside the Season 1 rotation (Normal/Follower
	-- only this season). EJ ids + encounter ids: dump in-game to fill.
	{
		key = "murderrow",
		name = "Murder Row",
		journalInstanceID = 1304, -- Robs EJ-tier-scan, 10 jun
		native = true,
		season1 = false,
		entrance = { mapID = 2393, x = 57.20, y = 61.06 }, -- Silvermoon City
		bosses = {
			-- dungeonEncounterID = the ENCOUNTER_START/DBM id (Rob's EJ
			-- overlay, 10 jun — EJ_GetEncounterInfo returns nil for these, so
			-- they are NOT journal ids); journal encounterID follows from the
			-- per-instance EJ dump. 3104 ontbreekt (gat in de reeks).
			{ key = "kystia", encounterID = nil, dungeonEncounterID = 3101, name = "Kystia Manaheart" },
			{ key = "zaen", encounterID = nil, dungeonEncounterID = 3102, name = "Zaen Bladesorrow" },
			{ key = "xathuux", encounterID = nil, dungeonEncounterID = 3103, name = "Xathuux the Annihilator" },
			{ key = "lithiel", encounterID = nil, dungeonEncounterID = 3105, name = "Lithiel Cinderfury" },
		},
	},
	{
		key = "nalorakk",
		name = "Den of Nalorakk",
		journalInstanceID = 1311, -- Robs EJ-tier-scan, 10 jun
		native = true,
		season1 = false,
		entrance = { mapID = 2437, x = 29.79, y = 84.51 }, -- Zul'Aman
		bosses = {
			{ key = "hoardmonger", encounterID = nil, dungeonEncounterID = 3207, name = "The Hoardmonger" },
			{ key = "sentinel", encounterID = nil, dungeonEncounterID = 3208, name = "Sentinel of Winter" },
			{ key = "nalorakk", encounterID = nil, dungeonEncounterID = 3209, name = "Nalorakk" },
		},
	},
	{
		key = "blindingvale",
		name = "The Blinding Vale",
		journalInstanceID = 1309, -- Robs EJ-tier-scan, 10 jun
		native = true,
		season1 = false,
		entrance = { mapID = 2413, x = 26.24, y = 78.09 }, -- Harandar
		bosses = {
			{ key = "trinity", encounterID = nil, dungeonEncounterID = 3199, name = "Lightblossom Trinity" },
			{ key = "ikuzz", encounterID = nil, dungeonEncounterID = 3200, name = "Ikuzz the Light Hunter" },
			{ key = "ruia", encounterID = nil, dungeonEncounterID = 3201, name = "Lightwarden Ruia" },
			{ key = "ziekket", encounterID = nil, dungeonEncounterID = 3202, name = "Ziekket" },
		},
	},
	{
		key = "voidscar",
		name = "Voidscar Arena",
		journalInstanceID = 1313, -- Robs EJ-tier-scan, 10 jun
		native = true,
		season1 = false,
		entrance = { mapID = 2444, x = 53.67, y = 33.08 }, -- Slayer's Rise
		bosses = {
			{ key = "tazrah", encounterID = nil, dungeonEncounterID = 3285, name = "Taz'Rah" },
			{ key = "atroxus", encounterID = nil, dungeonEncounterID = 3286, name = "Atroxus" },
			{ key = "charonus", encounterID = nil, dungeonEncounterID = 3287, name = "Charonus" },
		},
	},
	-- Legacy dungeons in the Season 1 Heroic/M+ rotation (not in the
	-- Normal/Follower queue).
	{
		key = "skyreach",
		name = "Skyreach",
		journalInstanceID = 476,
		native = false,
		season1 = true,
		entrance = { mapID = 542, x = 35.6, y = 33.7 }, -- Spires of Arak (Draenor)
		bosses = {
			{ key = "ranjit", encounterID = 965, name = "Ranjit" },
			{ key = "araknath", encounterID = 966, name = "Araknath" },
			{ key = "rukhran", encounterID = 967, name = "Rukhran" },
			{ key = "viryx", encounterID = 968, name = "High Sage Viryx" },
		},
	},
	{
		key = "pitofsaron",
		name = "Pit of Saron",
		journalInstanceID = 278,
		native = false,
		season1 = true,
		entrance = { mapID = 118, x = 54.78, y = 91.80 }, -- Icecrown (Northrend)
		bosses = {
			{ key = "garfrost", encounterID = 608, name = "Forgemaster Garfrost" },
			{ key = "krickick", encounterID = 609, name = "Krick and Ick" },
			{ key = "tyrannus", encounterID = 610, name = "Scourgelord Tyrannus" },
		},
	},
	{
		key = "triumvirate",
		name = "Seat of the Triumvirate",
		journalInstanceID = 945,
		native = false,
		season1 = true,
		entrance = { mapID = 882, x = 22.30, y = 55.89 }, -- Eredath (Argus)
		bosses = {
			{ key = "zuraal", encounterID = 1979, name = "Zuraal the Ascended" },
			{ key = "saprish", encounterID = 1980, name = "Saprish" },
			{ key = "nezhar", encounterID = 1981, name = "Viceroy Nezhar" },
			{ key = "lura", encounterID = 1982, name = "L'ura" },
		},
	},
	{
		key = "algethar",
		name = "Algeth'ar Academy",
		journalInstanceID = 1201,
		native = false,
		season1 = true,
		entrance = { mapID = 2025, x = 58.27, y = 42.22 }, -- Thaldraszus (Dragon Isles)
		bosses = {
			{ key = "vexamus", encounterID = 2509, name = "Vexamus" },
			{ key = "ancient", encounterID = 2512, name = "Overgrown Ancient" },
			{ key = "crawth", encounterID = 2495, name = "Crawth" },
			{ key = "doragosa", encounterID = 2514, name = "Echo of Doragosa" },
		},
	},
}

-- Weekly hooks (ids already verified elsewhere in MH on 10 Jun):
--   spark    = Liadrin's "Midnight: Dungeons" Spark weekly (any seasonal dungeon)
--   keystone = "Cracked Keystone" (item-started, once per season, M+ intro)
--   byHalduronQuest = Halduron's dungeon-of-the-week rep quest -> dungeon key;
--   a new quest id appears each week — add them as Rob dumps them, the
--   "dungeon of the week" line lights up automatically (never guessed).
ns.DUNGEON_WEEKLY = {
	spark = 93911,
	keystone = 92600,
	byHalduronQuest = {
		[93761] = "windrunnerspire", -- week of 10 Jun 2026 (in-game verified)
	},
}

--------------------------------------------------------------------------------
-- Helpers (EJ lookups are localized by the client; fall back to the English
-- name field when the id is unknown or the API declines)
--------------------------------------------------------------------------------

function ns.GetDungeonRoster()
	return ns.DUNGEON_ROSTER
end

function ns.GetDungeonDisplayName(d)
	if not d then
		return "?"
	end
	if d.journalInstanceID and EJ_GetInstanceInfo then
		local ok, name = pcall(EJ_GetInstanceInfo, d.journalInstanceID)
		if ok and type(name) == "string" and name ~= "" then
			return name
		end
	end
	return d.name or "?"
end

-- Localized boss name. Resolution order: journal encounterID -> by index
-- inside the dungeon's journal instance (boss order in our data matches the
-- EJ order, verified against Rob's EJ screenshots 10 jun) -> English fallback.
function ns.GetDungeonBossName(b, d, index)
	if not b then
		return "?"
	end
	if b.encounterID and EJ_GetEncounterInfo then
		local ok, name = pcall(EJ_GetEncounterInfo, b.encounterID)
		if ok and type(name) == "string" and name ~= "" then
			return name
		end
	end
	if d and d.journalInstanceID and index and EJ_GetEncounterInfoByIndex then
		local ok, name = pcall(EJ_GetEncounterInfoByIndex, index, d.journalInstanceID)
		if ok and type(name) == "string" and name ~= "" then
			return name
		end
	end
	return b.name or "?"
end

local function Flagged(qid)
	if not (qid and C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return false
	end
	local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, qid)
	return ok and done or false
end

local function OnQuest(qid)
	if not (qid and C_QuestLog and C_QuestLog.IsOnQuest) then
		return false
	end
	local ok, has = pcall(C_QuestLog.IsOnQuest, qid)
	return ok and has or false
end

-- "done" | "inlog" | "todo" for the Spark dungeon weekly (93911).
function ns.GetDungeonSparkState()
	local id = ns.DUNGEON_WEEKLY and ns.DUNGEON_WEEKLY.spark
	if Flagged(id) then
		return "done"
	elseif OnQuest(id) then
		return "inlog"
	end
	return "todo"
end

-- true when the once-per-season Cracked Keystone quest is completed.
function ns.IsCrackedKeystoneDone()
	return Flagged(ns.DUNGEON_WEEKLY and ns.DUNGEON_WEEKLY.keystone)
end

-- Returns dungeonKey, state ("done"|"inlog") for this week's Halduron
-- dungeon quest, or nil when no known id signals (unknown week — never lie).
function ns.GetDungeonOfTheWeek()
	local map = ns.DUNGEON_WEEKLY and ns.DUNGEON_WEEKLY.byHalduronQuest
	if type(map) ~= "table" then
		return nil
	end
	for qid, key in pairs(map) do
		if Flagged(qid) then
			return key, "done"
		elseif OnQuest(qid) then
			return key, "inlog"
		end
	end
	return nil
end

function ns.GetDungeonByKey(key)
	for _, d in ipairs(ns.DUNGEON_ROSTER) do
		if d.key == key then
			return d
		end
	end
	return nil
end

-- TomTom waypoint (+ the shared travel assistant: hearthstone/portal advice
-- for far-away targets) to a dungeon entrance. No-op without entrance data.
function ns.RouteDungeonEntrance(d)
	if not (d and d.entrance and d.entrance.mapID and ns.AddSmartTomTomWay) then
		return false
	end
	if ns.IsTomTomReady and ns.IsTomTomReady() then
		pcall(function()
			_G.TomTom:ClearAllWaypoints()
		end)
	end
	return ns.AddSmartTomTomWay(d.entrance.mapID, d.entrance.x, d.entrance.y, ns.GetDungeonDisplayName(d)) and true or false
end
