local _, ns = ...

--[[
	Midnight Helper — Travel, part 2 of 5: map knowledge (docs/TRAVEL_DESIGN_2026-10-16.md §2.2).

	Rob, 16 Oct 2026: "een soort centrale travel lua", design agreed the same day. Phase 1 builds this file and
	TravelData.lua next to the old code; nothing old is switched over yet except the Mount run (same behaviour).

	Why one file: the travel map (docs/TRAVEL_MAP_2026-10-16.md §7) counted 9 parent-chain walkers, ~10 map→world
	helpers and 11 "arrived" thresholds, each answering slightly differently. Every new travel feature should ask here.

	Rules kept from the old code:
	  - nil means "could not read", never "no" (CLAUDE.md aura rule; TwoStepRoute 7 Sep).
	  - a distance comes back WITH the unit it was measured in, and the threshold that belongs to that unit
	    (TwoStepRoute's DoorProximity, the one variant that worked in Silvermoon).
	  - world positions use CreateVector2D, like every other caller in MH; TwoStepRoute's WorldXY passes a UiMapPoint,
	    which may be why it reads nil in Silvermoon (travel map §1b-5) — NOT changed there until Rob's /dump settles it.
]]

ns.Travel = ns.Travel or {}
local T = ns.Travel

local function MapInfo(m)
	if not (m and C_Map and C_Map.GetMapInfo) then
		return nil
	end
	local ok, info = pcall(C_Map.GetMapInfo, m)
	return ok and info or nil
end

--- The player's current map, or nil (for a moment after a loading screen it is nil).
function T.PlayerMap()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil
	end
	local ok, m = pcall(C_Map.GetBestMapForUnit, "player")
	return ok and m or nil
end

--- true when map `inner` is `outer` or lies inside it (a city inside its zone, a cave inside its zone).
function T.InMap(inner, outer)
	inner, outer = tonumber(inner), tonumber(outer)
	if not (inner and outer) then
		return false
	end
	local guard = 0
	while inner and inner ~= 0 and guard < 12 do
		if inner == outer then
			return true
		end
		local info = MapInfo(inner)
		inner = info and info.parentMapID
		guard = guard + 1
	end
	return false
end

--- The continent a map lies on (uiMap id), or nil.
function T.Continent(m)
	m = tonumber(m)
	local guard = 0
	while m and m ~= 0 and guard < 12 do
		local info = MapInfo(m)
		if not info then
			return nil
		end
		if Enum and Enum.UIMapType and info.mapType == Enum.UIMapType.Continent then
			return m
		end
		m = info.parentMapID
		guard = guard + 1
	end
	return nil
end

--- The client's own (localized) name of a map, or nil.
function T.MapName(m)
	local info = MapInfo(tonumber(m))
	return info and info.name or nil
end

--- World position of a map point (x, y in 0-100): continentID, wx, wy — or nil.
function T.WorldXY(m, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D and m and x and y) then
		return nil
	end
	local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, m, CreateVector2D(x / 100, y / 100))
	if ok and cont and pos and pos.GetXY then
		local wx, wy = pos:GetXY()
		if wx and wy then
			return cont, wx, wy
		end
	end
	return nil
end

--- The player's position on map `m` as 0-100, or nil.
function T.PlayerXY(m)
	if not (C_Map and C_Map.GetPlayerMapPosition and m) then
		return nil
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, m, "player")
	if not (ok and pos and pos.GetXY) then
		return nil
	end
	local px, py = pos:GetXY()
	if not (px and py) then
		return nil
	end
	return px * 100, py * 100
end

--- Thresholds, one table, each with its unit. Names say what they are for; the old code's eleven numbers are listed
--- in the travel map §5c and move here as each part is switched over (phase 3).
T.NEAR = {
	-- A door with something behind it (Astalor's Sanctum → Coiled Isle portal). Was 22 yd (TwoStepRoute): Rob, 16 Oct
	-- 2026, ~20 m in front of the archway, already had the arrow on the portal behind the wall. Now the hand-over waits
	-- until you are THROUGH: in the doorway (8 yd), or you came within `passedNear` of the door and now stand closer to
	-- the step than the door itself is (TravelRoute.lua Reached).
	door = { yards = 8, percent = 0.35, passedNear = 25 },
	via = { yards = 7, percent = 0.3 }, -- Mount run `via` (door → portal in one room)
	-- Phase 3 (TravelRoute.lua), moved from the old code unchanged:
	step = { yards = 25, percent = 1.2 }, -- a walked door / Windcaller on the way: reached → next step (old leg watcher)
	walkedAway = { near = 60, back = 15 }, -- ...or was within 60 yd and is now 15 yd further away (Underbelly, 14 Oct)
	-- NativeArrow lets a single-destination route go (NativeArrow.lua Tick); phase 4: a managed route standing on its lead
	-- asks for the next one (TravelRoute.lua Arrival). percent AFGELEID from `step` (25 yd ≈ 1.2 %), not measured.
	arrived = { yards = 20, percent = 0.9 },
	done = { yards = 400 }, -- "route finished" after a zone change (Delves.lua IsMidnightTravelComplete)
}

--- How far the player is from (x, y) on map `m`: dist, how ("yards" | "mapsize" | "percent"), or nil.
--- Best method first, the same three as TwoStepRoute's DoorProximity, but with Vector2D world positions.
function T.Distance(m, x, y)
	local px, py = T.PlayerXY(m)
	if not (px and py and x and y) then
		return nil
	end
	local c1, ax, ay = T.WorldXY(m, px, py)
	local c2, bx, by = T.WorldXY(m, x, y)
	if c1 and c2 and c1 == c2 then
		return math.sqrt((ax - bx) ^ 2 + (ay - by) ^ 2), "yards"
	end
	local dx, dy = (px - x) / 100, (py - y) / 100
	if C_Map and C_Map.GetMapWorldSize then
		local ok, w, h = pcall(C_Map.GetMapWorldSize, m)
		if ok and tonumber(w) and tonumber(h) and w > 0 and h > 0 then
			return math.sqrt((dx * w) ^ 2 + (dy * h) ^ 2), "mapsize"
		end
	end
	return math.sqrt(dx * dx + dy * dy) * 100, "percent"
end

--- Distance between two points on map `m`, in the same units T.Distance would give on that map: dist, how — or nil.
function T.PointDistance(m, ax, ay, bx, by)
	if not (m and ax and ay and bx and by) then
		return nil
	end
	local c1, wx1, wy1 = T.WorldXY(m, ax, ay)
	local c2, wx2, wy2 = T.WorldXY(m, bx, by)
	if c1 and c2 and c1 == c2 then
		return math.sqrt((wx1 - wx2) ^ 2 + (wy1 - wy2) ^ 2), "yards"
	end
	local dx, dy = (ax - bx) / 100, (ay - by) / 100
	if C_Map and C_Map.GetMapWorldSize then
		local ok, w, h = pcall(C_Map.GetMapWorldSize, m)
		if ok and tonumber(w) and tonumber(h) and w > 0 and h > 0 then
			return math.sqrt((dx * w) ^ 2 + (dy * h) ^ 2), "mapsize"
		end
	end
	return math.sqrt(dx * dx + dy * dy) * 100, "percent"
end

--- Is the player within `kind`'s threshold of (x, y)? true / false, or nil when the distance could not be read.
function T.Near(kind, m, x, y)
	local limits = T.NEAR[kind]
	local d, how = T.Distance(m, x, y)
	if not (limits and d) then
		return nil
	end
	local limit = (how == "percent") and limits.percent or limits.yards
	return d < limit
end
