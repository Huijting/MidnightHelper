local _, ns = ...

--[[
	ForeverRares.lua — WoW Forever: rares in the overview's Find tab (heading "Rares"), the search bar (@rare) and a red
	arrow. Rob, 18 Nov 2026 (via sparring): "en hebben we ook rares in forever ?" → research → "1 eerst a daarna b".
	Step A (this file now): the ~20 that are worth the trip, each with one line why. Step B: all of them, per zone.

	Facts: docs/forever/RARES_2026-11-18.md (mh-research, 18 Nov 2026). Coordinates: the main point of HandyNotes: WoW
	Forever v4 (Kemayo; no licence = All Rights Reserved: facts read, no file or structure copied - the coordinate rule
	Rob > HandyNotes > Zygor > guides; Zygor Forever has no rare data). Levels, Rare/Rare Elite and drop chances:
	Wowhead Forever tooltips, 18 Nov 2026. `kill` = who can attack it (the other side sees it as friendly), from the
	Forever Leveling Guide's faction reactions (read only); Sewer Beast stands in Stormwind, so Alliance in practice
	(AFGELEID). Names are the English ones (other clients: NOT measured; the game shows its own name on the spot).
	There is no rare kill flag in Forever (no tracking quests, and DB2 Vignette has 2 rows): nothing is ticked off.
	Not seen in game yet.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- { npc, name, map, x, y, level, elite, kill ("both"/"Alliance"/"Horde"), why key }
-- Source of every x/y: HandyNotes_WoWForever zones\<Zone>.lua key of that npc (Skarr and The Razza re-read 18 Nov).
-- Levels: the research report; Ghost Howl 12, Blackmoss 13, Silithid Harvester 24 and Mist Howler 22 re-measured by the
-- build chat in the Wowhead Forever tooltip (run gamedata npc, 18 Nov). Lord Condar 15-16 and Scarlet Smith 58-59:
-- the higher value.
ns.FOREVER_RARES_WORTH = {
	{ npc = 2172, name = "Strider Clutchmother", map = 1439, x = 37.6, y = 92.0, level = 20, kill = "both", why = "FRARE_WHY_2172" },
	{ npc = 14268, name = "Lord Condar", map = 1432, x = 77.4, y = 73.4, level = 16, kill = "both", why = "FRARE_WHY_14268" },
	{ npc = 3581, name = "Sewer Beast", map = 1453, x = 64.4, y = 66.8, level = 50, kill = "Alliance", why = "FRARE_WHY_3581" },
	{ npc = 1920, name = "Dalaran Spellscribe", map = 1421, x = 63.0, y = 63.6, level = 21, kill = "Horde", why = "FRARE_WHY_1920" },
	{ npc = 5828, name = "Humar the Pridelord", map = 1413, x = 62.0, y = 33.6, level = 23, elite = true, kill = "both", why = "FRARE_WHY_SET" },
	{ npc = 5831, name = "Swiftmane", map = 1413, x = 60.4, y = 33.0, level = 21, elite = true, kill = "both", why = "FRARE_WHY_SET" },
	{ npc = 5842, name = "Takk the Leaper", map = 1413, x = 60.4, y = 9.4, level = 19, elite = true, kill = "both", why = "FRARE_WHY_SET" },
	{ npc = 263141, name = "Scaldaron", map = 2548, x = 30.7, y = 72.4, level = 43, elite = true, kill = "both", why = "FRARE_WHY_263141" },
	{ npc = 11498, name = "Skarr the Unbreakable", map = 1444, x = 62.4, y = 30.0, level = 58, elite = true, kill = "both", why = "FRARE_WHY_MAUL" },
	{ npc = 11497, name = "The Razza", map = 1444, x = 62.4, y = 30.1, level = 60, elite = true, kill = "both", why = "FRARE_WHY_MAUL" },
	{ npc = 5797, name = "Aean Swiftriver", map = 1413, x = 46.0, y = 69.0, level = 25, elite = true, kill = "Horde", why = "FRARE_WHY_5797" },
	{ npc = 3535, name = "Blackmoss the Fetid", map = 1438, x = 42.8, y = 28.6, level = 13, kill = "both", why = "FRARE_WHY_3535" },
	{ npc = 3056, name = "Ghost Howl", map = 1412, x = 39.5, y = 23.9, level = 12, kill = "both", why = "FRARE_WHY_3056" },
	{ npc = 3253, name = "Silithid Harvester", map = 1413, x = 44.6, y = 69.8, level = 24, kill = "both", why = "FRARE_WHY_3253" },
	{ npc = 1844, name = "Foreman Marcrid", map = 1422, x = 47.0, y = 34.2, level = 58, kill = "both", why = "FRARE_WHY_1844" },
	{ npc = 1885, name = "Scarlet Smith", map = 1422, x = 45.2, y = 13.6, level = 59, kill = "both", why = "FRARE_WHY_1885" },
	{ npc = 276061, name = "Decrepit Harvester", map = 1420, x = 53.2, y = 57.4, level = 8, kill = "both", why = "FRARE_WHY_276061" },
	{ npc = 1106, name = "Lost One Cook", map = 1435, x = 64.4, y = 22.8, level = 37, kill = "both", why = "FRARE_WHY_1106" },
	{ npc = 2447, name = "Narillasanz", map = 1416, x = 74.4, y = 53.4, level = 44, elite = true, kill = "both", why = "FRARE_WHY_2447" },
	{ npc = 8206, name = "Soul of Tanaris", map = 1446, x = 53.0, y = 45.6, level = 51, elite = true, kill = "both", why = "FRARE_WHY_8206" },
	{ npc = 5934, name = "Heartrazor", map = 1441, x = 16.6, y = 41.4, level = 32, elite = true, kill = "both", why = "FRARE_WHY_5934" },
	{ npc = 10644, name = "Mist Howler", map = 1440, x = 22.2, y = 29.4, level = 22, kill = "both", why = "FRARE_WHY_10644" },
	{ npc = 276111, name = "Ghostfang", map = 1426, x = 80.6, y = 47.0, level = 10, kill = "both", why = "FRARE_WHY_TAME" },
	{ npc = 274300, name = "Coldrasp", map = 1420, x = 17.8, y = 68.4, level = 12, kill = "both", why = "FRARE_WHY_TAME" },
}

local function Side()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" or f == "Horde") and f or nil
end

local function World(map, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(x / 100, y / 100))
	if not ok or not cont or not pos then
		return nil
	end
	local okXY, wx, wy = pcall(pos.GetXY, pos)
	if not okXY then
		return nil
	end
	return cont, wx, wy
end

local function PlayerWorld()
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not map or not C_Map.GetPlayerMapPosition then
		return nil
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, map, "player")
	if not ok or not pos then
		return nil
	end
	local okXY, x, y = pcall(pos.GetXY, pos)
	if not okXY or not x or (issecretvalue and (issecretvalue(x) or issecretvalue(y))) then
		return nil
	end
	return World(map, x * 100, y * 100)
end

local function ZoneName(map)
	local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
	return info and info.name or ("map " .. tostring(map))
end

local function GoTo(r, dist)
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(r.map, r.x, r.y)) then
		if not ns._mhWaypointYielded then
			print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		end
		return false
	end
	-- Rares stand a little off their point and some walk about: the arrow lets go at 20 yards, not 5.
	ns.lastTarget = { mapID = r.map, x = r.x, y = r.y, name = r.name, via = "/mh rare", arriveYards = 20 }
	ns._mhRouteOwner = "rarespot" -- red, released on arrival (NativeArrow.lua)
	print(PREFIX .. ns:L("FRARE_ARROW_FMT"):format(r.name, ZoneName(r.map),
		dist and (ns.ForeverTrainerDistance and ns.ForeverTrainerDistance(dist) or ("%d yd"):format(dist))
			or ns:L("FVEND_OTHER_CONT")))
	return true
end

--- Find categories for the overview: { key, name }. Step A: one list, "Worth the trip".
function ns.ForeverRareFindCats()
	return { { key = "worth", name = ns:L("FRARE_CAT_WORTH") } }
end

--- The rares of a category that your side can attack, nearest first: rows { name, tag, why, zone, dist, map, x, y, go }.
--- Second value: whether your own position could be read.
function ns.ForeverRareFindRows(key)
	if key ~= "worth" then
		return {}, true
	end
	local side = Side()
	local pc, px, py = PlayerWorld()
	local list = {}
	for _, r in ipairs(ns.FOREVER_RARES_WORTH) do
		if r.kill == "both" or (side and r.kill == side) then
			local rc, rx, ry = World(r.map, r.x, r.y)
			local dist
			if pc and rc and pc == rc then
				dist = math.sqrt((rx - px) ^ 2 + (ry - py) ^ 2)
			end
			list[#list + 1] = { r = r, dist = dist }
		end
	end
	table.sort(list, function(a, b)
		if a.dist and b.dist then
			return a.dist < b.dist
		end
		if a.dist or b.dist then
			return a.dist ~= nil
		end
		return a.r.level < b.r.level
	end)
	local rows = {}
	for _, e in ipairs(list) do
		local r = e.r
		rows[#rows + 1] = {
			name = r.name,
			tag = ns:L(r.elite and "FRARE_TAG_ELITE_FMT" or "FRARE_TAG_FMT"):format(r.level),
			why = ns:L(r.why),
			zone = ZoneName(r.map), dist = e.dist, map = r.map, x = r.x, y = r.y,
			go = function()
				return GoTo(r, e.dist)
			end,
		}
	end
	return rows, pc ~= nil
end