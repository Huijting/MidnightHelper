local _, ns = ...

--[[
	Midnight Helper — route to the door first, then to the thing behind it.

	Rob, 3 sep 2026, standing 94 yards from the Coiled Isle portal with the arrow
	pointing straight through a wall: "onze pijl stuurt ons naar de plek op de kaart
	maar niet naar de ingang van het gebouw."

	A map coordinate is not a route. Inside a city the last thirty yards are the only
	ones that are hard, and they are exactly the ones a single waypoint cannot help
	with -- it points at where the portal IS, which from outside is a wall.

	📌 THE ENTRANCE WAS ALREADY IN THE FILE, RECORDED AS AN ERROR. UI.lua's comment on
	the portal pin says the Codex used to send people to 55.00/63.40 and calls it
	"bijna vier punten mis". Rob's own reading of the doorway today is 54.99/63.30 --
	the same spot, measured five weeks apart by two different means. That coordinate
	was never wrong; it was the DOOR, and on 19 aug it was replaced by the destination
	rather than kept alongside it. Correcting a coordinate is not the same as
	understanding what it was pointing at.

	⚠️ WHY A TICKER AND NOT AN EVENT. There is no "player entered building" event to
	hook. Distance is the only signal, so this polls -- but only while a two-step route
	is actually running, once a second, with a hard stop. A poll that cannot end is a
	leak; this one ends on arrival, on timeout, and when another route takes the arrow.
]]

local C_Timer = C_Timer

-- How close to the door counts as "you are at the door". Generous on purpose: the
-- point is to hand over early rather than to make you stand on a pixel.
local ARRIVE_YARDS = 22
-- Stop looking after this long. Someone who clicked and then went to do something
-- else should not leave a ticker running for the rest of the session.
local GIVE_UP_SECONDS = 300
local TICK = 1

local active = nil -- { mapID, dest, token }
local token = 0

--- World position in yards for a map coordinate, or nil.
--- ⚠️ Returns nil rather than guessing: without both positions there is no distance,
--- and a made-up one would advance the route while the player is still outside.
local function WorldXY(mapID, x01, y01)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and UiMapPoint
		and UiMapPoint.CreateFromCoordinates) then
		return nil
	end
	local okP, p = pcall(UiMapPoint.CreateFromCoordinates, mapID, x01, y01)
	if not okP or not p then
		return nil
	end
	local okW, _, world = pcall(C_Map.GetWorldPosFromMapPos, mapID, p)
	if not okW or not world then
		return nil
	end
	return world.x, world.y
end

local function PlayerWorldXY(mapID)
	if not (C_Map and C_Map.GetPlayerMapPosition) then
		return nil
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
	if not ok or not pos then
		return nil
	end
	local px, py = pos:GetXY()
	if not px or not py then
		return nil
	end
	return WorldXY(mapID, px, py)
end

--- Distance in yards between the player and a map coordinate, or nil when unknown.
function ns.SmcYardsToPoint(mapID, x, y)
	local ax, ay = PlayerWorldXY(mapID)
	local bx, by = WorldXY(mapID, (tonumber(x) or 0) / 100, (tonumber(y) or 0) / 100)
	if not (ax and ay and bx and by) then
		return nil
	end
	local dx, dy = ax - bx, ay - by
	return math.sqrt(dx * dx + dy * dy)
end

function ns.StopSmcTwoStepRoute()
	active = nil
end

--- Hand the arrow over to the real destination.
local function Arrive()
	local a = active
	active = nil
	if not a or not a.dest then
		return
	end
	-- ⚠️ Only if nothing else has claimed the arrow in the meantime. Silently yanking
	-- someone off a rare route because they clicked a city pin four minutes ago is
	-- exactly the kind of surprise NativeArrow's ownership token exists to prevent.
	if ns._mhRouteOwner ~= nil and ns._mhRouteOwner ~= "waypoint" then
		return
	end
	if ns.SetSMCWaypointDirect then
		ns.SetSMCWaypointDirect(a.dest, a.mapID)
	end
	if ns.PrintChat then
		ns:PrintChat((ns:L("SMC_ENTRANCE_ARRIVED_FMT")):format(a.dest.label or "?"))
	end
end

local function Tick(myToken)
	if not active or active.token ~= myToken then
		return
	end
	active.elapsed = (active.elapsed or 0) + TICK
	if active.elapsed >= GIVE_UP_SECONDS then
		active = nil
		return
	end
	local d = ns.SmcYardsToPoint(active.mapID, active.door.x, active.door.y)
	if d and d <= ARRIVE_YARDS then
		Arrive()
		return
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(TICK, function() Tick(myToken) end)
	end
end

--- Begin a two-step route for a pin that has an `entrance`.
--- @return table|nil doorTarget  the entrance to route to now, or nil to go direct
function ns.StartSmcTwoStepRoute(point, mapID)
	local e = point and point.entrance
	if type(e) ~= "table" or not (e.x and e.y) then
		return nil
	end
	-- Already at the door (or inside): skip the detour entirely. Sending someone
	-- outside to come back in is worse than the bug this fixes.
	local d = ns.SmcYardsToPoint(mapID, e.x, e.y)
	if d and d <= ARRIVE_YARDS then
		return nil
	end
	token = token + 1
	active = {
		mapID = mapID,
		door = { x = e.x, y = e.y },
		dest = point,
		token = token,
		elapsed = 0,
	}
	if C_Timer and C_Timer.After then
		local myToken = token
		C_Timer.After(TICK, function() Tick(myToken) end)
	end
	return {
		x = e.x,
		y = e.y,
		label = (ns:L("SMC_ENTRANCE_LABEL_FMT")):format(point.label or "?"),
	}
end
