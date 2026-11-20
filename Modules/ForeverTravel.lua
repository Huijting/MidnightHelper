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
	FERALAS = 1444,
}

-- Rut'theran Village is on the Teldrassil map but on its own island below the portal. Boat stop 54.9,96.8, portal
-- 55.9,89.6 (GEMETEN). Everything from this line south counts as Rut'theran: AFGELEID, /mh travel shows the verdict.
local RUTTHERAN_MIN_Y = 86

-- kind, side (A/H/nil = both), the two ends, oneway. Costs below are in "minutes-ish"; walking is distance / 250 yd.
-- 18 Nov 2026 (Rob via sparring: "ja"): the boat/zeppelin/skycutter ends are now OUR OWN values - the stop (Delay > 0)
-- of each TaxiPathNode path in DB2 Forever 1.60.1.70959 (path id after the line), converted to the zone map (AFGELEID,
-- mh-research; docs/forever/REIZEN_2026-11-18.md). The old values were equal to Zygor's LibRover (All Rights Reserved).
-- A stop is the ship's centre: 10-20 yd off the dock edge is normal (the arrow arrives within 25 yd for these).
-- A5 (portal) and A6 (tram) are not in the taxi tables and keep their own measured values.
local LINKS = {
	{ id = "A1", kind = "boat", side = "A", a = { MAP.STORMWIND, 21.78, 56.86 }, b = { MAP.DARKSHORE, 30.53, 40.88 } }, -- 11616
	{ id = "A2", kind = "boat", side = "A", a = { MAP.DARKSHORE, 33.31, 39.82 }, b = { MAP.TELDRASSIL, 54.81, 97.22 } }, -- 293
	-- The loop: Menethil > Southshore > Auberdine > Menethil, one way only. Menethil > Auberdine means staying on board.
	-- Path 11167; stops Wetlands 4.49,56.66 > Hillsbrad 50.67,70.44 > Darkshore 32.34,44.13.
	{ id = "A3a", kind = "boat", side = "A", oneway = true, a = { MAP.DARKSHORE, 32.34, 44.13 }, b = { MAP.WETLANDS, 4.49, 56.66 } },
	{ id = "A3c", kind = "boat", side = "A", oneway = true, a = { MAP.HILLSBRAD, 50.67, 70.44 }, b = { MAP.DARKSHORE, 32.34, 44.13 } },
	{ id = "A3m", kind = "loop", side = "A", oneway = true, a = { MAP.WETLANDS, 4.49, 56.66 }, b = { MAP.DARKSHORE, 32.34, 44.13 },
		via = MAP.HILLSBRAD },
	{ id = "A4", kind = "boat", side = "A", a = { MAP.WETLANDS, 4.74, 63.76 }, b = { MAP.DUSTWALLOW, 71.73, 56.66 } }, -- 292
	{ id = "A5", kind = "portal", side = "A", a = { MAP.TELDRASSIL, 55.91, 89.64 }, b = { MAP.DARNASSUS, 30.06, 41.44 },
		aName = "FTRAVEL_RUTTHERAN" },
	{ id = "A6", kind = "tram", side = "A", a = { MAP.STORMWIND, 69.31, 30.56 }, b = { MAP.IRONFORGE, 76.58, 51.14 } },
	{ id = "H1", kind = "zeppelin", side = "H", a = { MAP.DUROTAR, 50.98, 13.91 }, b = { MAP.TIRISFAL, 60.64, 58.93 } }, -- 302
	{ id = "H2", kind = "zeppelin", side = "H", a = { MAP.DUROTAR, 50.47, 12.69 }, b = { MAP.STV, 31.17, 30.45 } }, -- 285
	{ id = "N1", kind = "boat", a = { MAP.BARRENS, 63.80, 38.75 }, b = { MAP.STV, 25.67, 73.08 } }, -- 241
	{ id = "N2", kind = "boat", a = { MAP.TANARIS, 68.58, 22.99 }, b = { MAP.RIVERGLADES, 80.60, 54.61 } }, -- 11391
	{ id = "S1", kind = "sky", side = "A", a = { MAP.ZEPHRAS, 65.84, 83.81 }, b = { MAP.ALTERAC, 12.83, 51.17 }, bName = "FTRAVEL_DALARAN" }, -- 11398
	{ id = "S2", kind = "sky", side = "H", a = { MAP.ZEPHRAS, 57.78, 81.01 }, b = { MAP.MULGORE, 34.33, 26.05 } }, -- 11457
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
--------------------------------------------------------------------------------
-- Teleports as a first step (20 Nov 2026, Rob via sparring: "Ik volg voorlopig eerst je advies. Dus doe inderdaad dan
-- maar je advies, als those teleports."). Idea from Shortest Path Forever (GPL-3): no code taken.
-- Spell ids, cast 10 s, cooldowns, reagent and levels: GEMETEN in the Forever DB2 1.60.1.70959 (SpellMisc, SpellCastTimes,
-- SpellCooldowns, SpellReagents, SkillLineAbility; mh-research, 20 Nov 2026). Hearthstone 8690: 60 min. Astral Recall 556:
-- 15 min, shaman 30. City teleports: no cooldown, 1 Rune of Teleportation (17031), mage 20 (Darnassus/Thunder Bluff 30).
-- Moonglade 18960: no cooldown, druid 10. Dalaran 1297659: Alliance mage 50.
-- WHERE they land is decided by the server (SpellEffect target 17/9), so not in client data. We do NOT use another
-- addon's landing table (Zygor's is All Rights Reserved). Until MH has seen you land, the destination is that city's
-- innkeeper from our own list (ForeverCitySpots, GEMETEN) — AFGELEID as "somewhere in the city", good enough to choose;
-- after the teleport the arrow plans again from where you really are. Every landing is learned: ns.db.foreverLandings.
-- Hearthstone and Astral Recall go to your bind point: learned from your own landing (per character), else the inn or
-- learned rest place whose name is GetBindLocation().
local MapName, Side, PlayerPos -- defined below; declared here so the teleport code can use them (lint [6])
local TELEPORTS = {
	{ id = "hs", item = HEARTHSTONE, spell = 8690, bind = true },
	{ id = "astral", spell = 556, bind = true },
	{ id = "tp_sw", spell = 3561, side = "A", reagent = 17031, dest = { MAP.STORMWIND, 60.38, 75.27 } },
	{ id = "tp_if", spell = 3562, side = "A", reagent = 17031, dest = { MAP.IRONFORGE, 18.15, 51.44 } },
	{ id = "tp_dar", spell = 3565, side = "A", reagent = 17031, dest = { MAP.DARNASSUS, 67.42, 15.64 } },
	{ id = "tp_dal", spell = 1297659, side = "A", reagent = 17031, dest = { MAP.ALTERAC, 12.20, 66.50 } },
	{ id = "tp_org", spell = 3567, side = "H", reagent = 17031, dest = { 1454, 54.09, 68.40 } },
	{ id = "tp_tb", spell = 3566, side = "H", reagent = 17031, dest = { 1456, 45.81, 64.71 } },
	{ id = "tp_uc", spell = 3563, side = "H", reagent = 17031, dest = { 1458, 67.73, 37.89 } },
	-- Moonglade (uiMap 1450) has no inn in our list: offered only after MH has seen you land there once.
	{ id = "moonglade", spell = 18960 },
}
-- Costs in the planner's own "minutes-ish" units (AFGELEID): 10 s cast + a loading screen ≈ 0.5, plus the cooldown still
-- to wait, plus TP_MIN so a teleport only wins when it clearly saves time (Shortest Path Forever's idea of a floor).
local TP_CAST, TP_MIN = 0.5, 1.5
local tpWhy = {} -- id -> why it was (not) offered, for /mh travel

local function Known(spell)
	if IsPlayerSpell then
		local ok, v = pcall(IsPlayerSpell, spell)
		if ok and v then
			return true
		end
	end
	if IsSpellKnown then
		local ok, v = pcall(IsSpellKnown, spell)
		if ok and v then
			return true
		end
	end
	return false
end

local function ItemCount(item)
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return nil
	end
	local ok, n = pcall(fn, item)
	return ok and tonumber(n) or nil
end

--- Minutes still to wait before this can be used (0 = ready), or nil when unreadable.
local function WaitMin(t)
	local start, dur
	if t.item then
		local fn = (C_Container and C_Container.GetItemCooldown) or (C_Item and C_Item.GetItemCooldown) or GetItemCooldown
		if not fn then
			return nil
		end
		local ok, a, b = pcall(fn, t.item)
		if not ok then
			return nil
		end
		start, dur = a, b
	else
		if C_Spell and C_Spell.GetSpellCooldown then
			local ok, info = pcall(C_Spell.GetSpellCooldown, t.spell)
			if ok and type(info) == "table" then
				start, dur = info.startTime, info.duration
			end
		elseif GetSpellCooldown then
			local ok, a, b = pcall(GetSpellCooldown, t.spell)
			if ok then
				start, dur = a, b
			end
		end
	end
	start, dur = tonumber(start) or 0, tonumber(dur) or 0
	if start <= 0 or dur <= 2 then -- 0, or only the global cooldown
		return 0
	end
	local left = start + dur - GetTime()
	return left > 0 and left / 60 or 0
end

local function CharKey()
	local n, r = UnitName and UnitName("player"), GetRealmName and GetRealmName()
	return tostring(n) .. "-" .. tostring(r)
end

local function Bind()
	if not GetBindLocation then
		return nil
	end
	local ok, b = pcall(GetBindLocation)
	return (ok and type(b) == "string" and b ~= "") and b or nil
end

--- Where your bind point is: { map, x, y, how } or nil + why.
local function BindDest()
	local bind = Bind()
	if not bind then
		return nil, "bind location unreadable"
	end
	local db = type(ns.db) == "table" and ns.db.foreverLandings
	local own = db and db.bind and db.bind[CharKey()]
	if own and own.name == bind and own.map then
		return { own.map, own.x, own.y, "landed here before" }
	end
	-- An inn or a learned rest place with the same name (ForeverCitySpots / ForeverRestXP).
	for _, s in ipairs(ns.FOREVER_CITY_SPOTS or {}) do
		if s.kind == "inn" and (s.map and MapName(s.map) == bind) then
			return { s.map, s.x, s.y, "inn of " .. bind }
		end
	end
	for _, s in pairs((type(ns.db) == "table" and ns.db.foreverRestSpots) or {}) do
		if s.name == bind then
			return { s.map, s.x, s.y, "rested there before" }
		end
	end
	return nil, ("bound to %s, but MH does not know where that is yet (use your Hearthstone once)"):format(bind)
end

--- The teleports you can use right now: { t, dest = {map,x,y}, cost, waitMin, label }.
local function Teleports()
	local side, out = Side(), {}
	for _, t in ipairs(TELEPORTS) do
		local why
		if t.side and t.side ~= side then
			why = "other faction"
		elseif t.item and (ItemCount(t.item) or 0) < 1 then
			why = "not in your bags"
		elseif not t.item and not Known(t.spell) then
			why = "spell not known"
		elseif t.reagent and (ItemCount(t.reagent) or 0) < 1 then
			why = "no Rune of Teleportation"
		end
		local dest, how
		if not why then
			if t.bind then
				local d, w = BindDest()
				if d then
					dest, how = d, d[4]
				else
					why = w
				end
			else
				local db = type(ns.db) == "table" and ns.db.foreverLandings
				local seen = db and db.spell and db.spell[t.spell]
				if seen then
					dest, how = { seen.map, seen.x, seen.y }, "landed here before"
				elseif t.dest then
					dest, how = t.dest, "the city's inn (until MH sees where you land)"
				else
					why = "landing place not known yet (cast it once)"
				end
			end
		end
		local wait = not why and WaitMin(t) or nil
		if not why and wait == nil then
			why = "cooldown unreadable"
		end
		if why then
			tpWhy[t.id] = why
		else
			tpWhy[t.id] = ("offered: %s, wait %d min"):format(how or "?", math.ceil(wait))
			local name
			if t.item then
				local getName = (C_Item and C_Item.GetItemNameByID) or GetItemInfo
				local ok, n = pcall(getName or function() return nil end, t.item)
				name = ok and n or nil
			else
				local getName = (C_Spell and C_Spell.GetSpellName) or GetSpellInfo
				local ok, n = pcall(getName or function() return nil end, t.spell)
				name = ok and n or nil
			end
			name = (type(name) == "string" and name ~= "") and name or ("spell " .. tostring(t.spell))
			out[#out + 1] = { t = t, dest = dest, waitMin = wait, cost = TP_CAST + TP_MIN + wait,
				label = ns:L(t.item and "FTRAVEL_USE_FMT" or "FTRAVEL_CAST_FMT"):format(name) }
		end
	end
	return out
end

-- Learn where a teleport really lands: the spell is cast, the next loading screen ends, we read the position.
local pendingLand
do
	local lev = CreateFrame("Frame")
	pcall(lev.RegisterUnitEvent, lev, "UNIT_SPELLCAST_SUCCEEDED", "player")
	lev:RegisterEvent("PLAYER_ENTERING_WORLD")
	pcall(lev.RegisterEvent, lev, "ZONE_CHANGED_NEW_AREA")
	lev:SetScript("OnEvent", function(_, event, _, _, spellID)
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			for _, t in ipairs(TELEPORTS) do
				if t.spell == spellID then
					pendingLand = { t = t, at = GetTime(), bind = Bind() }
				end
			end
			return
		end
		if not pendingLand or GetTime() - pendingLand.at > 60 or type(ns.db) ~= "table" then
			return
		end
		local p = pendingLand
		C_Timer.After(1, function()
			local map, x, y = PlayerPos()
			if not (map and x) then
				return
			end
			ns.db.foreverLandings = ns.db.foreverLandings or {}
			local db = ns.db.foreverLandings
			if p.t.bind then
				db.bind = db.bind or {}
				db.bind[CharKey()] = { name = p.bind, map = map, x = x, y = y }
			else
				db.spell = db.spell or {}
				db.spell[p.t.spell] = { map = map, x = x, y = y }
			end
		end)
		pendingLand = nil
	end)
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

function MapName(map) -- the local declared above the teleport code
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

function Side() -- the local declared above the teleport code
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" and "A") or (f == "Horde" and "H") or nil
end

function PlayerPos() -- the local declared above the teleport code
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
	local function add(from, to, cost, link, toEnd, tp)
		edges[from] = edges[from] or {}
		edges[from][#edges[from] + 1] = { to = to, cost = cost, link = link, toEnd = toEnd, tp = tp }
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
	-- Teleports (20 Nov 2026): from where you stand to their landing place, then walking from there to the target or to
	-- any link end. Added after the target, so `it` stays the target.
	local okT, tps = pcall(Teleports)
	for _, tp in ipairs(okT and tps or {}) do
		local p = Point(tp.dest[1], tp.dest[2], tp.dest[3])
		nodes[#nodes + 1] = p
		local ip = #nodes
		add(1, ip, tp.cost, nil, nil, tp)
		local c = WalkCost(p, target)
		if c then
			add(ip, it, c, nil)
		end
		for j = 2, it - 1 do
			local cj = WalkCost(p, nodes[j])
			if cj then
				add(ip, j, cj, nil)
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
		-- Time per step (20 Nov 2026): the walk to the step plus the ride, in the planner's own units, which are rough
		-- minutes (AFGELEID: chosen to order routes, not measured). Shown as "about N min".
		local lastAt = 0
		for _, c in ipairs(chain) do
			if c.edge.link or c.edge.tp then
				local from = nodes[c.from]
				steps = steps or {}
				local min = (dist[c.from] or 0) - lastAt + c.edge.cost
				lastAt = (dist[c.from] or 0) + c.edge.cost
				if c.edge.tp then
					steps[#steps + 1] = { kind = "travel", forever = true, cast = true, mapID = from.map, x = from.x,
						y = from.y, label = c.edge.tp.label, link = c.edge.tp.t.id, linkKind = "teleport", min = min }
				else
					steps[#steps + 1] = { kind = "travel", forever = true, mapID = from.map, x = from.x, y = from.y,
						label = Label(c.edge.link, c.edge.toEnd), link = c.edge.link.id, linkKind = c.edge.link.kind,
						min = min }
				end
			end
		end
		if steps then
			steps[#steps + 1] = { kind = "arrive", mapID = tmap, x = tx, y = ty, min = dist[it] - lastAt }
			steps.totalMin = dist[it]
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
		if s.kind == "travel" and s.cast then
			parts[#parts + 1] = s.label -- "cast Teleport: Stormwind" happens where you stand: no "in <zone>"
		elseif s.kind == "travel" then
			parts[#parts + 1] = ns:L("FTRAVEL_IN_FMT"):format(s.label, MapName(s.mapID))
		end
	end
	local sentence = table.concat(parts, ns:L("FTRAVEL_THEN")) .. "."
	if steps.totalMin then
		sentence = sentence .. " " .. ns:L("FTRAVEL_ABOUT_FMT"):format(math.max(1, math.floor(steps.totalMin + 0.5)))
	end
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
	print(("  hearthstone (item %d): %s; bound to %s"):format(HEARTHSTONE, hs == nil and "count unreadable" or tostring(hs),
		tostring(Bind() or "?")))
	-- Teleports: which ones the planner may use now, and why the others are left out (20 Nov 2026).
	pcall(Teleports)
	for _, t in ipairs(TELEPORTS) do
		if tpWhy[t.id] and tpWhy[t.id] ~= "other faction" then
			print(("  teleport %s (%s %d): %s"):format(t.id, t.item and "item" or "spell", t.item or t.spell, tpWhy[t.id]))
		end
	end
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
			print(("  %d. %s — %s %.1f,%.1f (%s), about %.1f min"):format(i, s.label, MapName(s.mapID), s.x, s.y, s.link,
				s.min or 0))
		elseif s.kind == "arrive" then
			print(("  then walk to the target, about %.1f min"):format(s.min or 0))
		end
	end
	print(("  total: about %.1f min (rough: the planner's units are chosen, not measured)"):format(steps.totalMin or 0))
	print("  no-hearthstone warning: " .. (NoHearthForTrip(steps) and "YES (crosses the water, none in your bags)"
		or "no (you have one, the count is unreadable, or the route does not cross the water)"))
end

--------------------------------------------------------------------------------
-- Find → Travel (18 Nov 2026, Rob via sparring: "ik ben nu op zoek naar de zeppelins in ogrimar en heb geen idee hoe ik
-- daar kom … kortom … HELP !!!" → "ja"). Every boat, zeppelin, tram, portal and skycutter stop as a place to walk to,
-- named after where it goes. The planner's LINKS above, plus TRAVEL_EXTRA: crossings the planner leaves out (both ends
-- on one continent) but a player still looks for. Nothing here changes the planner.
--------------------------------------------------------------------------------
-- Research of 18 Nov 2026 (mh-research; docs/forever/REIZEN_2026-11-18.md). Stops = DB2 TaxiPathNode stops (Delay > 0)
-- of build 1.60.1.70959, converted to the zone map (AFGELEID). Whether the server really runs them: NOT measured.
local TRAVEL_EXTRA = {
	-- Grom'gol <> Undercity, path 301. Masters Squibby Overspeck 12137 (STV 31.5,29.4) and Hin Denburg 3150
	-- (Tirisfal 61.8,59.0), Wowhead Forever; object 176495 "Zeppelin - Grom'Gol to Undercity". Same towers as H1/H2.
	{ id = "X1", kind = "zeppelin", side = "H", a = { MAP.STV, 31.48, 29.10 }, b = { MAP.TIRISFAL, 61.92, 58.92 } },
	-- Feathermoon ferry, path 303: mainland dock <> Sardor Isle. Wowhead Forever object 177233 "Feathermoon Ferry".
	-- side A = it lands at the Alliance stronghold (AFGELEID; DB2 has no side for transports).
	{ id = "X2", kind = "boat", side = "A", a = { MAP.FERALAS, 43.13, 42.76 }, b = { MAP.FERALAS, 31.01, 39.51 },
		-- aName (Fable check, 18 Nov 2026): the way back left Feathermoon "to Feralas" while you are in Feralas; it goes to
		-- the Forgotten Coast (games.gg; DB2 AreaTable 1108).
		aName = "FTRAVEL_FORGOTTEN_COAST", bName = "FTRAVEL_FEATHERMOON" },
}

-- A line under a stop that is hard to find from the nearest city. [link id .. "a"/"b"] = locale key. Directions from the
-- Wowhead Classic guide "Flight Points, Zeppelins, and Ships" + Warcraft Wiki; platform sides fit the DB2 stops.
local STOP_NOTE = {
	H1a = "FTRAVEL_NOTE_ORG", H2a = "FTRAVEL_NOTE_ORG",
	H1b = "FTRAVEL_NOTE_UC", X1b = "FTRAVEL_NOTE_UC",
	-- Thunder Bluff has no zeppelin (no zeppelin path touches Mulgore in DB2, GEMETEN); the flight TB <> Orgrimmar exists
	-- (TaxiPath 387/42). The skycutter in Mulgore is the stop a Thunder Bluff player sees first, so the line goes there.
	S2b = "FTRAVEL_NOTE_TB",
}

local function TitleCase(s)
	return (s:gsub("^%l", string.upper))
end

--- { kind = "transport", name, side ("A"/"H"/"both"), map, x, y, note } for every stop of every crossing, both ends
--- unless the crossing runs one way.
function ns.ForeverTravelTransportSpots()
	local out = {}
	local function add(link, from, to, toName, endKey)
		local dest = toName and ns:L(toName) or MapName(to[1])
		local label = LABEL[link.kind] or "FTRAVEL_BOAT_FMT"
		local name
		if link.kind == "loop" then
			name = ns:L(label):format(dest, MapName(link.via))
		else
			name = ns:L(label):format(dest)
		end
		local side = (link.side == "A" or link.side == "H") and link.side or "both"
		local noteKey = STOP_NOTE[(link.id or "") .. endKey]
		out[#out + 1] = { kind = "transport", name = TitleCase(name), side = side, map = from[1], x = from[2], y = from[3],
			note = noteKey and ns:L(noteKey) or nil, linkKind = link.kind }
	end
	for _, list in ipairs({ LINKS, TRAVEL_EXTRA }) do
		for _, link in ipairs(list) do
			add(link, link.a, link.b, link.bName, "a")
			if not link.oneway then
				add(link, link.b, link.a, link.aName, "b")
			end
		end
	end
	return out
end
