local _, ns = ...

--[[
	Midnight Helper — Travel, part 6: the route search (Rob, 18 Oct 2026, after reading how Shortest Path Forever
	plans: "het moet wel iets opleveren en duidelijk een verbetering zijn").

	WHY. The travel plan (TravelPlan.lua) answers "where to go first" with rules: a portal on the map you stand on, the
	way home (Travel.WayHome), a flight master. Every rule only looks ONE hop ahead. For a target outside Midnight that
	is not on your map's portal list, the plan had nothing — and `/mh plan` then said "you are already there". GEMETEN
	in the headless harness (scratchpad h/, 18 Oct 2026) on MH's own targets:
	  - the four legacy Mythic+ dungeons of the season (Algeth'ar Academy, Pit of Saron, Skyreach, Seat of the
	    Triumvirate; DungeonRosterData.lua) from Silvermoon: no plan; the arrow went to the Silvermoon flight master;
	  - a Mount Hyjal pin from Orgrimmar: "fly to Nordrassil" across Kalimdor, with the portal to Hyjal in the city.

	WHAT. One search over the travel knowledge MH already has — no new coordinates in this file:
	  MOUNTRUN_HUBS      capital portals, boats, zeppelins, trams, tunnels (MountRunData.lua; the Mount run's hops)
	  MOUNTRUN_HOME      the portal home in every hub city (MountRunData.lua)
	  MIDNIGHT_PORTALS   Silvermoon and the Midnight zones (Delves.lua), only when MHPortalUsable says so
	  mage teleports and the Hearthstone/toys, exactly as Travel.WayHome offers them (TravelPlanner.lua)
	A place is a uiMap. Dijkstra over those maps, cheapest total time first, the way Shortest Path Forever's planner
	does (its own data is WoW: Forever's world; nothing of its code is used — GPL-3 vs our MIT).

	THE COST MODEL — every number below is AFGELEID (chosen, not measured). They only have to ORDER routes correctly
	(a portal beats crossing a continent, a short walk beats burning the Hearthstone); the estimate shown in
	`/mh plan` says "about" for that reason.
	  - Where a portal puts you down is not in our data ("we know where the portal stands, not where it puts you down",
	    TravelPlaces.lua). Portals mostly come in pairs, so arrival = the portal BACK on that map when we have one;
	    otherwise the middle of the map, with a flat walk cost instead of a distance.
	  - Overland (flying across a continent) is only offered where ns.IsCrossContinentTarget says "same continent" —
	    the same measured test the plan already trusts.

	SCOPE (on purpose, so nothing Rob tested on 16-17 Oct changes): TravelPlan.lua asks this file only when its own
	rules found no portal on your map AND the target lies outside Midnight. Midnight targets keep WayHome.
]]

ns.Travel = ns.Travel or {}
local T = ns.Travel
local G = {}
T.Graph = G

--- Seconds. AFGELEID, see above.
G.COST = {
	ride = 14, -- yd/s on the ground in a city (a 100% mount)
	fly = 25, -- yd/s across a continent (between flying and skyriding speed)
	load = 5, -- a loading screen
	use = 3, -- clicking a portal, talking to a flight NPC
	unknownWalk = 30, -- from an unknown arrival spot to the next portal on the same map
	boat = 150, -- boat or zeppelin: half a wait plus the ride
	tram = 90,
	cast = 10, -- Hearthstone and mage teleport cast
	hearthReserve = 60, -- the Hearthstone has a cooldown: only spend it to save at least this much (SPF does the same)
	unlock = 120, -- a quest giver who flies you there because the portal is not unlocked yet
}

local RIDES = { boat = "boat", zeppelin = "boat", tram = "tram" }
local WALKED = { exit = true, tunnel = true, hole = true, jump = true, ring = true }
--- Hops whose step text is written for ONE Mount run route and would mislead any other: the Lightforged Beacon's
--- text tells you to move the Vindicaar to the Antoran Wastes (Antorus), and our data has neither the ship's console
--- nor the way down (MountRunData.lua: "Antorus is only PARTLY covered"). Headless harness, 18 Oct 2026: without
--- this, Seat of the Triumvirate (Eredath) was routed through it with the Antorus sentence.
local SEARCH_SKIPS = { LEG_BEACON = true }

local function Fac()
	return (UnitFactionGroup and UnitFactionGroup("player") == "Horde") and "H" or "A"
end

local function L(key)
	return (ns.L and ns:L(key)) or key
end

--- World positions, remembered for one search: a search asks the same few hundred points many times over.
local worldMemo, relatedMemo
local function World(m, x, y)
	local key = m .. ":" .. x .. ":" .. y
	local w = worldMemo and worldMemo[key]
	if w == nil then
		local c, wx, wy
		if T.WorldXY then
			c, wx, wy = T.WorldXY(m, x, y)
		end
		w = c and { c, wx, wy } or false
		if worldMemo then
			worldMemo[key] = w
		end
	end
	return w or nil
end

--- Yards between two points on two maps (x/y 0-100), or nil when the client cannot place both on one continent.
local function Yards(m1, x1, y1, m2, x2, y2)
	if not (m1 and x1 and y1 and m2 and x2 and y2) then
		return nil
	end
	local a, b = World(m1, x1, y1), World(m2, x2, y2)
	if a and b and a[1] == b[1] then
		return math.sqrt((a[2] - b[2]) ^ 2 + (a[3] - b[3]) ^ 2)
	end
	return nil
end
G.Yards = Yards

--- One map is the other or lies inside it (a city in its zone, Silvermoon inside Eversong).
local function Related(a, b)
	if a == b then
		return true
	end
	local key = a .. ":" .. b
	local r = relatedMemo and relatedMemo[key]
	if r == nil then
		r = (T.InMap and (T.InMap(a, b) or T.InMap(b, a))) and true or false
		if relatedMemo then
			relatedMemo[key] = r
		end
	end
	return r
end

--- Seconds to cover `d` yards: riding the first stretch (a city, a portal room), flying the rest. AFGELEID.
local GROUND = 200
local function TravelSecs(d)
	if d <= GROUND then
		return d / G.COST.ride
	end
	return GROUND / G.COST.ride + (d - GROUND) / G.COST.fly
end

--------------------------------------------------------------------------------
-- The edges: every hop this character could take, from the tables MH already has
--------------------------------------------------------------------------------

--- { from, x, y, to, kind, secs, step } — `step` is the plan step it becomes (TravelPlan.lua's format).
local function Edges()
	local fac = Fac()
	local out = {}
	local function add(e)
		if e.from and e.x and e.y and e.to and e.from ~= e.to then
			out[#out + 1] = e
		end
	end

	-- MOUNTRUN_HUBS through ns.MountRunHubSteps, so the quest-gate rule (Isle of Thunder) and the step text are the
	-- Mount run's own: one key gives the one step that hop needs.
	local keys = {}
	for k in pairs(ns.MOUNTRUN_HUBS or {}) do
		keys[#keys + 1] = k
	end
	table.sort(keys) -- a fixed order, so a tie always resolves the same way
	for _, k in ipairs(keys) do
		local hub = not SEARCH_SKIPS[k] and ns.MOUNTRUN_HUBS[k]
		local s = hub and ns.MountRunHubSteps and ns.MountRunHubSteps({ k })[1]
		if hub and s and s.map and s.x and s.y then
			local to = type(s.to) == "table" and s.to[1] or s.to
			local unlock = hub.unlock ~= nil and s.board and not RIDES[hub.kind] -- the quest giver stands in for it
			local secs
			if unlock then
				secs = G.COST.unlock
			elseif RIDES[hub.kind] then
				secs = G.COST[RIDES[hub.kind]]
			elseif WALKED[hub.kind] then
				secs = G.COST.use
			else
				secs = G.COST.use + G.COST.load
			end
			local via = type(s.via) == "table" and s.via[1] and { x = s.via[1], y = s.via[2] } or nil
			local orb = type(s.orb) == "table" and s.orb[1] and { x = s.orb[1], y = s.orb[2] } or nil
			add({ from = s.map, x = s.x, y = s.y, to = to, secs = secs, key = k, step = {
				kind = WALKED[hub.kind] and "walk" or "portal", mapID = s.map, x = s.x, y = s.y, to = to,
				label = s.text, door = via, orb = orb, viaNear = s.viaNear, board = s.board,
				source = "MOUNTRUN_HUBS." .. k,
			} })
		end
	end

	-- MOUNTRUN_HOME: the portal to this faction's capital in every hub city.
	local capital = (fac == "H") and 85 or 84
	for m, row in pairs(ns.MOUNTRUN_HOME or {}) do
		local p = row[fac]
		if p then
			local name = T.MapName and T.MapName(capital) or "?"
			add({ from = m, x = p[1], y = p[2], to = capital, secs = G.COST.use + G.COST.load, step = {
				kind = "portal", mapID = m, x = p[1], y = p[2], to = capital,
				label = (L(row.room and "MOUNTRUN_STEP_ROOM" or "MOUNTRUN_STEP_PORTAL")):format(name),
				door = row.via and { x = row.via[1], y = row.via[2] } or nil, viaNear = row.via and "via" or nil,
				source = "MOUNTRUN_HOME",
			} })
		end
	end

	-- MIDNIGHT_PORTALS. Rows on the shared canvas 2576 carry a `zone` and repeat the 2393/2413/2405 rows; they only
	-- count for someone standing on 2576 itself (Start below), never as a map you arrive on.
	for _, p in ipairs(ns.MIDNIGHT_PORTALS or {}) do
		if not p.zone and p.mapID ~= 2576 and (not ns.MHPortalUsable or ns.MHPortalUsable(p)) then
			add({ from = p.mapID, x = p.x, y = p.y, to = p.toID, secs = G.COST.use + G.COST.load, step = {
				kind = "portal", mapID = p.mapID, x = p.x, y = p.y, to = p.toID,
				label = ns.MHPortalLabel and ns.MHPortalLabel(p.name) or p.name,
				door = p.door, orb = p.orb, source = "MIDNIGHT_PORTALS",
			} })
		end
	end
	return out
end
G.Edges = Edges

--- The rows on canvas 2576, for a player who stands on it.
local function CanvasEdges()
	local out = {}
	for _, p in ipairs(ns.MIDNIGHT_PORTALS or {}) do
		if p.mapID == 2576 and (not ns.MHPortalUsable or ns.MHPortalUsable(p)) then
			out[#out + 1] = { from = 2576, x = p.x, y = p.y, to = p.toID, secs = G.COST.use + G.COST.load, step = {
				kind = "portal", mapID = 2576, x = p.x, y = p.y, to = p.toID,
				label = ns.MHPortalLabel and ns.MHPortalLabel(p.name) or p.name,
				door = p.door, orb = p.orb, source = "MIDNIGHT_PORTALS",
			} }
		end
	end
	return out
end

--- Where you stand after taking `e`: the portal back on the map you arrive on (portals come in pairs), or nil.
local function ArrivalOf(e, edges)
	for _, back in ipairs(edges) do
		if back.from == e.to and Related(back.to, e.from) then
			return back.x, back.y
		end
	end
	return nil
end

--- Mage teleports and the Hearthstone: usable anywhere, only as the first hop. Same rules as Travel.WayHome
--- (TravelPlanner.lua): a mage spell only when IsPlayerSpell knows it, a Hearthstone only when it is in the bags or
--- owned, off cooldown, and the bind check says it lands in the capital or in Silvermoon (fail closed).
local function StartActions(pm)
	local out = {}
	local capital = (Fac() == "H") and 85 or 84
	for _, goal in ipairs({ capital, T.HUB }) do
		-- Not `T.MageTeleportTo and T.MageTeleportTo(goal)`: `and` keeps only the first return, and the name is the second.
		local spell, sName
		if T.MageTeleportTo then
			spell, sName = T.MageTeleportTo(goal)
		end
		if spell then
			out[#out + 1] = { to = goal, secs = G.COST.cast + G.COST.load, step = {
				kind = "mage", to = goal, spellID = spell,
				label = (L("MOUNTRUN_STEP_MAGE")):format(sName or "?", T.MapName and T.MapName(goal) or "?"),
				source = "Travel.MageTeleportTo",
			} }
		end
	end
	local useID, isToy, toyName
	if T.HearthChoice then
		useID, isToy, toyName = T.HearthChoice()
	end
	if useID and ns.MHHearthstoneGoesTo then
		for _, goal in ipairs({ capital, T.HUB }) do
			local name = T.MapName and T.MapName(goal)
			if name and ns.MHHearthstoneGoesTo(name) then
				out[#out + 1] = { to = goal, secs = G.COST.cast + G.COST.load + G.COST.hearthReserve, step = {
					kind = "hearth", to = goal, useID = useID, isToy = isToy,
					label = toyName and (L("MOUNTRUN_STEP_HEARTH_TOY")):format(toyName, name)
						or (L("MOUNTRUN_STEP_HEARTH")):format(name),
					source = "Travel.HearthChoice",
				} }
				break
			end
		end
	end
	return out
end

--------------------------------------------------------------------------------
-- The search
--------------------------------------------------------------------------------

--- In Midnight (region 1-3)? There MH models travel with portals only (MIDNIGHT_PORTALS, MOUNTRUN_TO_SILVERMOON):
--- Silvermoon, Harandar and Voidstorm may share a canvas, and "same continent" there must not become "fly across".
local midnightMemo
local function InMidnight(m)
	local r = midnightMemo and midnightMemo[m]
	if r == nil then
		r = false
		if ns.GetRegionGroupID then
			local ok, g = pcall(ns.GetRegionGroupID, m)
			r = (ok and g and g ~= 0) and true or false
		end
		if midnightMemo then
			midnightMemo[m] = r
		end
	end
	return r
end

--- Seconds from (ax, ay) on map `am` to (bx, by) on map `bm`, or nil when you cannot get there without a hop.
--- `known` = we know where we stand on `am`. Same map (or one inside the other): ride, or a flat cost when we do not
--- know where we are. Another map: only across one continent the client confirms, never inside Midnight.
local function WalkSecs(am, ax, ay, known, bm, bx, by)
	if Related(am, bm) then
		local d = known and Yards(am, ax, ay, bm, bx, by)
		return d and TravelSecs(d) or G.COST.unknownWalk
	end
	if InMidnight(am) or InMidnight(bm) then
		return nil
	end
	local d = Yards(am, ax or 50, ay or 50, bm, bx, by)
	if not d then
		return nil
	end
	return TravelSecs(d) + (known and 0 or G.COST.unknownWalk)
end

--- From a place to the target without another hop: inside it, or across the same continent. secs or nil.
local function FinishSecs(m, x, y, target)
	local ax, ay = x or 50, y or 50
	if Related(m, target.map) then
		local d = Yards(m, ax, ay, target.map, target.x or 50, target.y or 50)
		return d and TravelSecs(d) or G.COST.unknownWalk
	end
	if not ns.IsCrossContinentTarget or InMidnight(m) then
		return nil
	end
	-- IsCrossContinentTarget reads the player's own position on `m`; for any other map it uses the map's middle.
	local ok, cross = pcall(ns.IsCrossContinentTarget, m, target.map, target.x, target.y)
	if not ok or cross then
		return nil
	end
	local d = Yards(m, ax, ay, target.map, target.x or 50, target.y or 50)
	if not d then
		return nil
	end
	return TravelSecs(d)
end

--- The cheapest way from where the player stands to `target` = { map, x, y }.
--- @return table|nil route { hops = { edge... }, secs = total, compared = number of places settled, direct = bool }
function G.Route(target)
	local pm = T.PlayerMap and T.PlayerMap()
	if not (pm and target and target.map) then
		return nil
	end
	local px, py
	if T.PlayerXY then
		px, py = T.PlayerXY(pm)
	end
	worldMemo, relatedMemo, midnightMemo = {}, {}, {}
	local edges = Edges()
	if pm == 2576 then
		for _, e in ipairs(CanvasEdges()) do
			edges[#edges + 1] = e
		end
	end

	-- Where each hop puts you down, worked out once per search.
	for _, e in ipairs(edges) do
		e.ax, e.ay = ArrivalOf(e, edges)
	end

	--- Dijkstra over PLACES, not maps. A label is { map, x, y, known, secs, prev, edge }.
	--- ⚠️ A place is a map AND where on it you stand. Keyed by map alone, a mage teleport to Orgrimmar (quick, lands
	--- somewhere unknown) shut out the Silvermoon portal (a little slower, lands right beside the portal to
	--- Valdrakken) — and the whole route came out slower (headless harness, 18 Oct 2026: 109 s instead of 87 s).
	--- Shortest Path Forever's planner warns about the same trap: a cheaper arrival only beats another when it leaves
	--- at least the same onward choices. Arrival spots come from a small fixed set, so the search stays small.
	local function Key(m, x, y)
		return x and (m .. ":" .. x .. ":" .. y) or (m .. ":?")
	end
	local best = {} -- key -> label
	local open = {}
	local done = {}
	local function push(l)
		l.key = Key(l.map, l.x, l.y)
		if done[l.key] then
			return
		end
		local cur = best[l.key]
		if cur and cur.secs <= l.secs then
			return
		end
		best[l.key] = l
		open[#open + 1] = l
	end
	local start = { map = pm, x = px, y = py, known = px ~= nil, secs = 0 }
	push(start)
	for _, a in ipairs(StartActions(pm)) do
		-- Not to where you already are; and a spell or Hearthstone lands somewhere we do not know (no x/y).
		if not Related(pm, a.to) then
			push({ map = a.to, known = false, secs = a.secs, prev = start, edge = a })
		end
	end

	local finish, settled = nil, 0
	while #open > 0 do
		-- The cheapest open label (a few dozen places: a scan is simpler than a heap and as fast).
		local bi
		for i, l in ipairs(open) do
			if not bi or l.secs < open[bi].secs then
				bi = i
			end
		end
		local l = table.remove(open, bi)
		if best[l.key] == l and not done[l.key] then
			done[l.key] = true
			settled = settled + 1
			if finish and l.secs >= finish.secs then
				break
			end
			local f = FinishSecs(l.map, l.x, l.y, target)
			if f and (not finish or l.secs + f < finish.secs) then
				finish = { secs = l.secs + f, label = l }
			end
			for _, e in ipairs(edges) do
				local walk = WalkSecs(l.map, l.x, l.y, l.known, e.from, e.x, e.y)
				if walk then
					push({ map = e.to, x = e.ax, y = e.ay, known = e.ax ~= nil, secs = l.secs + walk + e.secs, prev = l,
						edge = e })
				end
			end
		end
	end
	worldMemo, relatedMemo, midnightMemo = nil, nil, nil
	if not finish then
		return nil
	end
	local hops = {}
	local l = finish.label
	while l and l.edge do
		table.insert(hops, 1, l.edge)
		l = l.prev
	end
	return { hops = hops, secs = finish.secs, compared = settled, direct = #hops == 0 }
end

--- The plan steps for `target` (TravelPlan.lua's format), or nil when the search found nothing better than going
--- straight there. `steps.estimate` = total seconds, `steps.compared` = places compared.
function G.PlanSteps(target)
	local r = G.Route(target)
	if not r or r.direct then
		return nil
	end
	local steps = {}
	for _, e in ipairs(r.hops) do
		local s = {}
		for k, v in pairs(e.step) do
			s[k] = v
		end
		steps[#steps + 1] = s
	end
	steps.estimate, steps.compared = r.secs, r.compared
	return steps
end

--- `/mh route <map> <x> <y>`-style check from the chat: the hops and the estimate, or why there is none.
function G.Print(map, x, y)
	local p = "|cffffcc00" .. L("PRINT_PREFIX") .. "|r"
	local r = G.Route({ map = tonumber(map), x = tonumber(x), y = tonumber(y) })
	if not r then
		print(p .. " route search: no known way there")
		return
	end
	print(("%s route search: ~%d s over %d hop(s), %d place(s) compared"):format(p, r.secs, #r.hops, r.compared))
	for i, e in ipairs(r.hops) do
		print(("   %d. %s  (%s → %s, %s)"):format(i, tostring(e.step.label), tostring(e.from or "here"),
			tostring(e.to), tostring(e.step.source)))
	end
end
