local _, ns = ...

--[[
	Midnight Helper — Travel: places you can be taken to (Rob, 16 Oct 2026: "kunnen we niet ook zoeken in MH naar bv
	dalaran of een van de andere plekken waar we kunnen komen via portals, en dan bedoel ik in onze search balk?").

	No new travel data. A place is every map the Mount run's hubs (MOUNTRUN_HUBS) lead to, reached the way the Mount run
	already walks: the way home (Travel.WayHome: portal, mage teleport, Hearthstone), then hub after hub. Two roots:
	the player's capital, and Silvermoon (its own way there is better than "capital, then the portal": a mage teleport
	or a Hearthstone bound there). Names come from C_Map, so a German player finds "Dalaran" as their client spells it.

	The route ends on arrival in the place (`arrivesOn`), not at a spot inside it: we know where the portal stands, not
	where it puts you down. The last step is the middle of the map, only shown when the zone change did not end it.
]]

ns.Travel = ns.Travel or {}
local T = ns.Travel

local function Fac()
	return (UnitFactionGroup and UnitFactionGroup("player") == "Horde") and "H" or "A"
end

--- Where a hub stands and where it leads for this faction: map, to — or nil.
local function HubFor(hub, fac)
	local p = hub[fac] or hub.both
	if not p then
		return nil
	end
	local to = p.to or hub.to
	if type(to) == "table" then
		to = to[1]
	end
	return p[1], to
end

local cache = {} -- per faction: the list below never changes during a session

--- Every place for this character's faction: { map, root, keys = { hub keys in order } }, shortest chain first.
--- root = the capital (84/85) or Silvermoon (T.HUB); the route puts the way to the root in front.
function T.Places()
	local fac = Fac()
	if cache[fac] then
		return cache[fac]
	end
	local hubs = ns.MOUNTRUN_HUBS or {}
	local keys = {}
	for k in pairs(hubs) do
		keys[#keys + 1] = k
	end
	table.sort(keys) -- one fixed order, so two hubs to one place always give the same chain
	local capital = (fac == "H") and T.CAPITAL.Horde or T.CAPITAL.Alliance
	local out, seen = {}, { [capital] = true, [T.HUB] = true }
	-- The roots are places too: Silvermoon for everyone, the own capital.
	out[#out + 1] = { map = T.HUB, root = T.HUB, keys = {} }
	out[#out + 1] = { map = capital, root = capital, keys = {} }
	-- Breadth first, so the first chain that reaches a map is the shortest one.
	local queue = { { map = capital, root = capital, keys = {} }, { map = T.HUB, root = T.HUB, keys = {} } }
	local head = 1
	while queue[head] do
		local cur = queue[head]
		head = head + 1
		for _, k in ipairs(keys) do
			local at, to = HubFor(hubs[k], fac)
			-- The portal to Silvermoon is not a hop: Silvermoon is a root with its own way there.
			if at == cur.map and to and not seen[to] and k ~= "P_SILVERMOON" then
				seen[to] = true
				local chain = {}
				for i, v in ipairs(cur.keys) do
					chain[i] = v
				end
				chain[#chain + 1] = k
				local place = { map = to, root = cur.root, keys = chain }
				out[#out + 1] = place
				queue[#queue + 1] = place
			end
		end
	end
	cache[fac] = out
	return out
end

--- Start the route to `place` (from T.Places). Prints and returns false when the player is already there.
function T.GoToPlace(place)
	if not place then
		return false
	end
	local name = T.MapName(place.map) or "?"
	local pm = T.PlayerMap()
	if pm and T.InMap(pm, place.map) then
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), (ns:L("NAV_PLACE_HERE_FMT")):format(name)))
		return false
	end
	local steps = (ns.MountRunHubSteps and ns.MountRunHubSteps(place.keys)) or {}
	for _, s in ipairs(steps) do
		s.final = nil
	end
	steps[#steps + 1] = { map = place.map, x = 50, y = 50, text = name, final = true }
	local start = 1
	if T.StepFor(steps) == 1 then
		-- Not on the chain yet: the way to its root first (to a root itself, that way IS the route). The Mount run's
		-- rule (MountRunStartRoute): `start` = where the chain's own steps begin.
		local pre = T.WayHome(place.root)
		for _, s in ipairs(pre) do
			if s.via then
				s.viaNear = "via"
			end
		end
		for i = #pre, 1, -1 do
			table.insert(steps, 1, pre[i])
		end
		start = #pre + 1
	end
	ns._mhRouteOwner = "waypoint"
	T.Start({ map = place.map, x = 50, y = 50, name = name, arrivesOn = place.map }, {
		owner = "waypoint",
		steps = steps,
		start = start,
		noTravelAdvice = true, -- NativeArrow's continent advice only knows Midnight
		finish = true,
		via = "place search",
	})
	return true
end
