local _, ns = ...

--[[
	ForeverTravel.lua — WoW Forever: the travel planner behind the route arrow. Boats, zeppelins, the Deeprun Tram and the
	Darnassus portal, so a target on another continent (or on Teldrassil, or in Ironforge seen from Stormwind) gets
	"first: the boat to Stormwind City" instead of "other continent — travel back first".
	Rob, 10 Nov 2026, in Darkshore on his way to the Two-Handed Mace trainer in Ironforge: "waar ga ik naartoe? … Kunnen we
	dat ook in de Forever versie oplossen?" → "uitzoeken en bouwen graag".

	Data: docs/forever/FOREVER_TRAVEL_LINKS_2026-11-10.md (mh-research, 10 Nov 2026). Stops from the Forever DB2
	TaxiPathNode (1.60.1.70888, GEMETEN), converted to zone x,y (AFGELEID) and matched within 1 unit by Wowhead Forever NPC
	spawns and an independent guide. Rob saw the three Auberdine boats himself that day (Teldrassil, Elwynn/Stormwind,
	Wetlands). Left out: the direct Auberdine <> Menethil boat (probably gone, AFGELEID), the Grom'gol <> Undercity zeppelin
	(both ends in the Eastern Kingdoms; this planner only knows "walk" inside a continent), the Skyborne-only portal and the
	Feathermoon ferry.

	It hooks into NativeArrow.lua through the same names the Midnight travel planner uses (ns.BuildTravelPlan, steps with
	kind/mapID/x/y/label), plus two Forever-only additions: ns.ForeverTravelNeedsLink (Teldrassil and the tram are the same
	continent, but you cannot walk there) and step.forever (a dock elsewhere on your continent may be pointed at).
	/mh travel prints what it decides and why (CLAUDE.md: a module that can stay quiet needs that).
]]

if not ns.IS_FOREVER then
	return
end

local MAP = {
	KALIMDOR = 1414, EK = 1415,
	DARKSHORE = 1439, TELDRASSIL = 1438, DARNASSUS = 1457, STORMWIND = 1453, ELWYNN = 1429, IRONFORGE = 1455,
	DUN_MOROGH = 1426, WETLANDS = 1437, HILLSBRAD = 1424, DUSTWALLOW = 1445, DUROTAR = 1411, TIRISFAL = 1420,
	STV = 1434, BARRENS = 1413, TANARIS = 1446, RIVERGLADES = 2548, ZEPHRAS = 2521, ALTERAC = 1416, MULGORE = 1412,
}

-- Rut'theran Village is on the Teldrassil map but on its own island below the portal. Boat stop 54.9,96.8, portal
-- 55.9,89.6 (GEMETEN). Everything from this line south counts as Rut'theran: AFGELEID, /mh travel shows the verdict.
local RUTTHERAN_MIN_Y = 86

-- kind, side (A/H/nil = both), the two ends, oneway. Costs below are in "minutes-ish"; walking is distance / 250 yd.
local LINKS = {
	{ id = "A1", kind = "boat", side = "A", a = { MAP.STORMWIND, 22.60, 56.13 }, b = { MAP.DARKSHORE, 30.76, 41.00 } },
	{ id = "A2", kind = "boat", side = "A", a = { MAP.DARKSHORE, 33.19, 40.13 }, b = { MAP.TELDRASSIL, 54.86, 96.79 } },
	-- The loop: Menethil > Southshore > Auberdine > Menethil, one way only. Menethil > Auberdine means staying on board.
	{ id = "A3a", kind = "boat", side = "A", oneway = true, a = { MAP.DARKSHORE, 32.39, 43.80 }, b = { MAP.WETLANDS, 4.65, 57.16 } },
	{ id = "A3c", kind = "boat", side = "A", oneway = true, a = { MAP.HILLSBRAD, 50.60, 69.71 }, b = { MAP.DARKSHORE, 32.39, 43.80 } },
	{ id = "A3m", kind = "loop", side = "A", oneway = true, a = { MAP.WETLANDS, 4.65, 57.16 }, b = { MAP.DARKSHORE, 32.39, 43.80 },
		via = MAP.HILLSBRAD },
	{ id = "A4", kind = "boat", side = "A", a = { MAP.WETLANDS, 5.08, 63.40 }, b = { MAP.DUSTWALLOW, 71.54, 56.34 } },
	{ id = "A5", kind = "portal", side = "A", a = { MAP.TELDRASSIL, 55.91, 89.64 }, b = { MAP.DARNASSUS, 30.06, 41.44 },
		aName = "FTRAVEL_RUTTHERAN" },
	{ id = "A6", kind = "tram", side = "A", a = { MAP.STORMWIND, 69.31, 30.56 }, b = { MAP.IRONFORGE, 76.58, 51.14 } },
	{ id = "H1", kind = "zeppelin", side = "H", a = { MAP.DUROTAR, 50.82, 13.81 }, b = { MAP.TIRISFAL, 60.70, 58.76 } },
	{ id = "H2", kind = "zeppelin", side = "H", a = { MAP.DUROTAR, 50.57, 12.66 }, b = { MAP.STV, 31.35, 30.12 } },
	{ id = "N1", kind = "boat", a = { MAP.BARRENS, 63.66, 38.65 }, b = { MAP.STV, 25.92, 73.15 } },
	{ id = "N2", kind = "boat", a = { MAP.TANARIS, 68.34, 22.98 }, b = { MAP.RIVERGLADES, 80.30, 54.40 } },
	{ id = "S1", kind = "sky", side = "A", a = { MAP.ZEPHRAS, 65.82, 83.42 }, b = { MAP.ALTERAC, 12.52, 51.96 }, bName = "FTRAVEL_DALARAN" },
	{ id = "S2", kind = "sky", side = "H", a = { MAP.ZEPHRAS, 57.94, 80.72 }, b = { MAP.MULGORE, 34.29, 25.73 } },
}
local COST = { boat = 4, zeppelin = 4, sky = 4, loop = 7, tram = 1, portal = 0.5 }

-- No Hearthstone + a route over the water = a long way back (Rob, 11 Nov 2026, on a Paladin who had sold his to make room:
-- "bouw het stukje maar van, je hebt geen hearthstone, zeker in het begin"). Item 6948 "Hearthstone" in the Forever DB2
-- ItemSparse, 1.60.1.70888 (GEMETEN). The tram and the portal are short hops, so only these kinds count.
local HEARTHSTONE = 6948
local CROSSING = { boat = true, zeppelin = true, loop = true, sky = true }

--- How many Hearthstones you carry; nil when the count cannot be read (then we say nothing).
local function HearthCount()
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return nil
	end
	local ok, n = pcall(fn, HEARTHSTONE)
	return ok and tonumber(n) or nil
end

--- True when the plan crosses the water and you have no Hearthstone (counted, not guessed).
local function NoHearthForTrip(steps)
	if not steps then
		return false
	end
	local crosses = false
	for _, s in ipairs(steps) do
		if s.linkKind and CROSSING[s.linkKind] then
			crosses = true
		end
	end
	return crosses and HearthCount() == 0
end
local LABEL = { boat = "FTRAVEL_BOAT_FMT", zeppelin = "FTRAVEL_ZEPPELIN_FMT", tram = "FTRAVEL_TRAM_FMT",
	portal = "FTRAVEL_PORTAL_FMT", sky = "FTRAVEL_SKY_FMT", loop = "FTRAVEL_LOOP_FMT" }
-- Stormwind and Ironforge are one walk apart on paper, but the walk is long and dangerous: a penalty makes the tram win.
local SUB = { [MAP.STORMWIND] = "SW", [MAP.ELWYNN] = "SW", [MAP.IRONFORGE] = "IF", [MAP.DUN_MOROGH] = "IF" }
local SUB_PENALTY = 8
local ZONE_CHANGE = 2

local function World(map, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(x / 100, y / 100))
	if not ok or not cont or not pos then
		return nil
	end
	local okXY, wx, wy = pcall(pos.GetXY, pos)
	if not okXY or not wx or (issecretvalue and (issecretvalue(wx) or issecretvalue(wy) or issecretvalue(cont))) then
		return nil
	end
	return cont, wx, wy
end

local function ParentMap(map)
	local ok, info = pcall(C_Map.GetMapInfo, map)
	return ok and info and info.parentMapID or nil
end

local function MapName(map)
	local ok, info = pcall(C_Map.GetMapInfo, map)
	return ok and info and info.name or ("map " .. tostring(map))
end

--- Which piece of land a point is on: you can walk between two points only when this is the same.
local function Group(map, x, y)
	if map == MAP.DARNASSUS then
		return "TELD"
	elseif map == MAP.TELDRASSIL then
		return (y and y >= RUTTHERAN_MIN_Y) and "RUT" or "TELD"
	elseif map == MAP.ZEPHRAS then
		return "ZEPH"
	end
	local m, hops = map, 0
	while m and hops < 8 do
		if m == MAP.KALIMDOR then
			return "KAL"
		elseif m == MAP.EK then
			return "EK"
		end
		m = ParentMap(m)
		hops = hops + 1
	end
	local cont = World(map, x or 50, y or 50)
	return (cont == 0 and "EK") or (cont == 1 and "KAL") or nil
end

local function Side()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" and "A") or (f == "Horde" and "H") or nil
end

local function PlayerPos()
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not map or not C_Map.GetPlayerMapPosition then
		return map
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, map, "player")
	if not ok or not pos then
		return map
	end
	local okXY, x, y = pcall(pos.GetXY, pos)
	if not okXY or not x or (issecretvalue and (issecretvalue(x) or issecretvalue(y))) then
		return map
	end
	return map, x * 100, y * 100
end

--- A graph point: map, x, y, plus its land group and world position (cached on the point).
local function Point(map, x, y)
	local p = { map = map, x = x, y = y, group = Group(map, x, y) }
	p.cont, p.wx, p.wy = World(map, x, y)
	return p
end

local function WalkCost(p, q)
	if not (p.group and p.group == q.group) then
		return nil
	end
	local c = 6 -- unreadable world position: a fixed guess, only used to compare
	if p.wx and q.wx and p.cont == q.cont then
		c = math.sqrt((p.wx - q.wx) ^ 2 + (p.wy - q.wy) ^ 2) / 250
	end
	local sp, sq = SUB[p.map], SUB[q.map]
	if sp and sq and sp ~= sq then
		c = c + SUB_PENALTY
	end
	-- A straight line into another zone is shorter than the road around the mountains: a small price per zone change
	-- (AFGELEID). It is what makes "boat to Stormwind + tram" beat "boat to Menethil + walk through the Wetlands".
	if p.map ~= q.map then
		c = c + ZONE_CHANGE
	end
	return c
end

local function Label(link, toEnd)
	local key = LABEL[link.kind]
	local named
	if toEnd == "b" then
		named = link.bName
	else
		named = link.aName
	end
	local dest = named and ns:L(named) or MapName(link[toEnd][1])
	if link.kind == "loop" then
		return ns:L(key):format(dest, MapName(link.via))
	end
	return ns:L(key):format(dest)
end

--- The link ends and the edges between them never change for one faction: build them once.
local staticBySide = {}
local function StaticGraph(side)
	local key = side or "?"
	if staticBySide[key] then
		return staticBySide[key]
	end
	local g = { points = {}, edges = {} }
	for _, l in ipairs(LINKS) do
		if not l.side or l.side == side then
			g.points[#g.points + 1] = Point(l.a[1], l.a[2], l.a[3])
			local ia = #g.points
			g.points[#g.points + 1] = Point(l.b[1], l.b[2], l.b[3])
			local ib = #g.points
			g.edges[#g.edges + 1] = { from = ia, to = ib, cost = COST[l.kind] or 4, link = l, toEnd = "b" }
			if not l.oneway then
				g.edges[#g.edges + 1] = { from = ib, to = ia, cost = COST[l.kind] or 4, link = l, toEnd = "a" }
			end
		end
	end
	for i = 1, #g.points do
		for j = 1, #g.points do
			if i ~= j then
				local c = WalkCost(g.points[i], g.points[j])
				if c then
					g.edges[#g.edges + 1] = { from = i, to = j, cost = c }
				end
			end
		end
	end
	-- Only keep it when every point could be read; a half-read graph at login is rebuilt on the next call.
	local complete = true
	for _, p in ipairs(g.points) do
		if not (p.group and p.wx) then
			complete = false
		end
	end
	if complete then
		staticBySide[key] = g
	end
	return g
end

--- The plan from the player to (map, x, y): a list of steps, or nil when you can simply walk (or nothing is known).
--- Dijkstra over: the player, every link end on your side, the target. Small (about 30 points), cached for a second.
local cache = { key = nil, at = 0, steps = nil, why = nil }
local function Plan(tmap, tx, ty)
	local pmap, px, py = PlayerPos()
	if not (pmap and px and tmap and tx and ty) then
		return nil, "player or target position unreadable"
	end
	-- The arrow asks ~30 times a second while it waits on a plan: recompute at most once a second for the same target
	-- and map. Moving inside a map does not change which boat is best often enough to matter.
	local key = ("%d>%d:%.1f:%.1f"):format(pmap, tmap, tx, ty)
	local now = GetTime and GetTime() or 0
	if cache.key == key and now - cache.at < 1 then
		return cache.steps, cache.why
	end
	local side = Side()
	local static = StaticGraph(side)
	local nodes = { Point(pmap, px, py) } -- 1 = start, then the link ends (same order as static.points), then the target
	for _, p in ipairs(static.points) do
		nodes[#nodes + 1] = p
	end
	local target = Point(tmap, tx, ty)
	nodes[#nodes + 1] = target
	local it = #nodes
	local edges = {} -- from index -> list of { to, cost, link, toEnd }
	local function add(from, to, cost, link, toEnd)
		edges[from] = edges[from] or {}
		edges[from][#edges[from] + 1] = { to = to, cost = cost, link = link, toEnd = toEnd }
	end
	for _, e in ipairs(static.edges) do -- link rides and walks between link ends: computed once per side
		add(e.from + 1, e.to + 1, e.cost, e.link, e.toEnd)
	end
	for j = 1, it do -- walks from the start, and walks into the target
		if j ~= 1 then
			local c = WalkCost(nodes[1], nodes[j])
			if c then
				add(1, j, c, nil)
			end
		end
		if j ~= it and j ~= 1 then
			local c = WalkCost(nodes[j], target)
			if c then
				add(j, it, c, nil)
			end
		end
	end
	local dist, prev, done = { [1] = 0 }, {}, {}
	for _ = 1, #nodes do
		local u, best = nil, math.huge
		for i = 1, #nodes do
			if not done[i] and dist[i] and dist[i] < best then
				u, best = i, dist[i]
			end
		end
		if not u or u == it then
			break
		end
		done[u] = true
		for _, e in ipairs(edges[u] or {}) do
			local nd = best + e.cost
			if not dist[e.to] or nd < dist[e.to] then
				dist[e.to], prev[e.to] = nd, { from = u, edge = e }
			end
		end
	end
	local steps, why
	if not dist[it] then
		why = ("no route known from %s to %s"):format(tostring(nodes[1].group), tostring(target.group))
	else
		local chain, i = {}, it
		while prev[i] do
			table.insert(chain, 1, prev[i])
			i = prev[i].from
		end
		for _, c in ipairs(chain) do
			if c.edge.link then
				local from = nodes[c.from]
				steps = steps or {}
				steps[#steps + 1] = { kind = "travel", forever = true, mapID = from.map, x = from.x, y = from.y,
					label = Label(c.edge.link, c.edge.toEnd), link = c.edge.link.id, linkKind = c.edge.link.kind }
			end
		end
		if steps then
			steps[#steps + 1] = { kind = "arrive", mapID = tmap, x = tx, y = ty }
		else
			why = "same land: walk"
		end
	end
	cache.key, cache.at, cache.steps, cache.why = key, now, steps, why
	return steps, why
end

-- The arrow asks for a plan many times a second; the "no Hearthstone" chat line comes once per target per session.
-- Chat is right here (CLAUDE.md, route arrow): it is an event you might miss, and it stays readable afterwards.
local hearthWarned = {}
if not ns.BuildTravelPlan then
	function ns.BuildTravelPlan(mapID, x, y)
		local ok, steps = pcall(Plan, mapID, x, y)
		steps = ok and steps or nil
		if steps then
			local k = ("%s:%.0f:%.0f"):format(tostring(mapID), x or 0, y or 0)
			if not hearthWarned[k] and NoHearthForTrip(steps) then
				hearthWarned[k] = true
				print("|cffffcc00Midnight Helper:|r " .. ns:L("FTRAVEL_NO_HEARTH_CHAT"))
			end
		end
		return steps
	end
end

--- NativeArrow: true when the target is on the same continent but cannot be walked to (Teldrassil, Rut'theran) or the
--- tram beats the walk (Stormwind <> Ironforge). Then the arrow asks for the plan instead of pointing across the sea.
function ns.ForeverTravelNeedsLink(_, mapID, x, y)
	local ok, steps = pcall(Plan, mapID, x, y)
	return ok and steps ~= nil
end

--- One sentence for a window ("The way there: …"). nil, true = you can walk there; nil = not known.
function ns.ForeverTravelSentence(mapID, x, y)
	local ok, steps, why = pcall(Plan, mapID, x, y)
	if not (ok and steps) then
		return nil, ok and why == "same land: walk"
	end
	local parts = {}
	for _, s in ipairs(steps) do
		if s.kind == "travel" then
			parts[#parts + 1] = ns:L("FTRAVEL_IN_FMT"):format(s.label, MapName(s.mapID))
		end
	end
	local sentence = table.concat(parts, ns:L("FTRAVEL_THEN")) .. "."
	if NoHearthForTrip(steps) then
		sentence = sentence .. " " .. ns:L("FTRAVEL_NO_HEARTH")
	end
	return sentence
end

--- /mh travel: where MH thinks you are, and the plan to the arrow's current target.
function ns.ForeverTravelSlash()
	local P = "|cffffcc00Midnight Helper:|r "
	local pmap, px, py = PlayerPos()
	print(P .. ("travel: you are on %s (%s) %s, land %s, side %s"):format(MapName(pmap or 0), tostring(pmap),
		px and ("%.1f,%.1f"):format(px, py) or "?", tostring(pmap and Group(pmap, px, py)), tostring(Side())))
	local hs = HearthCount()
	print(("  hearthstone (item %d): %s"):format(HEARTHSTONE, hs == nil and "count unreadable" or tostring(hs)))
	if ns.ForeverSeenCount then
		print(("  NPC places learned by talking to them (trainers, vendors): %d"):format(ns.ForeverSeenCount()))
	end
	local lead = ns.GetActiveArrowLead and ns.GetActiveArrowLead()
	if not lead then
		print("  no arrow target. Set one (a trainer, a vendor) and type /mh travel again.")
		return
	end
	local steps, why = Plan(lead.mapID, lead.x, lead.y)
	print(("  target: %s on %s (%s) %.1f,%.1f, land %s"):format(tostring(lead.name), MapName(lead.mapID),
		tostring(lead.mapID), lead.x or 0, lead.y or 0, tostring(Group(lead.mapID, lead.x, lead.y))))
	if not steps then
		print("  no travel step: " .. tostring(why))
		return
	end
	for i, s in ipairs(steps) do
		if s.kind == "travel" then
			print(("  %d. %s — %s %.1f,%.1f (%s)"):format(i, s.label, MapName(s.mapID), s.x, s.y, s.link))
		end
	end
	print("  no-hearthstone warning: " .. (NoHearthForTrip(steps) and "YES (crosses the water, none in your bags)"
		or "no (you have one, the count is unreadable, or the route does not cross the water)"))
end
