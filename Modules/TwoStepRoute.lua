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

--- 🔴 SILVERMOON HAS NO WORLD COORDINATES, SO THE YARD ROUTE CAN NEVER ANSWER THERE.
--- GEMETEN 7 sep 2026 with `/mh arrow` standing inside the room: the watcher was alive
--- (16 s of its 300), the route was alive, the player was on map 2393 -- the very map the
--- route uses -- and the distance read `ONMEETBAAR`. `C_Map.GetWorldPosFromMapPos(2393, …)`
--- gives nothing, so `SmcYardsToPoint` returns nil every single tick and a threshold that
--- can never be reached is never reached. The hand-over was not fragile here; it was
--- impossible.
---
--- 📌 Same shape as the aura rule in CLAUDE.md: nil meant "could not read", the code treated
--- it as "not yet", and those are not the same answer. It cost a whole afternoon because
--- from outside an arrow that never advances looks exactly like an arrow pointing at the
--- wrong thing.
---
--- So the distance is now asked THREE ways, best first, and the diagnostic says which one
--- answered -- because if this ever silently drops to the coarsest one on a map where the
--- others used to work, that is a finding and not a detail.
---   1. world yards            -- exact, works outdoors
---   2. the map's own size     -- C_Map.GetMapWorldSize, still real yards
---   3. raw map percent        -- coarse, and the only one that needs its own threshold
local ARRIVE_MAP_UNITS = 1.2
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

--- The player's position on `mapID` as 0..1, or nil.
local function PlayerMapXY(mapID)
	if not (C_Map and C_Map.GetPlayerMapPosition) then
		return nil
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
	if not ok or not pos then
		return nil
	end
	return pos:GetXY()
end

--- How far you are from the door, in whatever unit could actually be measured.
---
--- ⚠️ Returns the THRESHOLD alongside the distance on purpose. The two must come from the
--- same method or they are not comparable, and keeping them apart is how a yard threshold
--- ends up being compared against a percentage.
---
--- @return number|nil dist, number limit, string how  -- how: "yards" | "mapsize" | "percent"
local function DoorProximity(mapID, x, y)
	local yards = ns.SmcYardsToPoint(mapID, x, y)
	if yards then
		return yards, ARRIVE_YARDS, "yards"
	end

	local px, py = PlayerMapXY(mapID)
	if not (px and py) then
		return nil, ARRIVE_YARDS, "niets"
	end
	local dx, dy = px - ((tonumber(x) or 0) / 100), py - ((tonumber(y) or 0) / 100)

	-- The map knows its own size in yards even where it cannot place a world position.
	if C_Map and C_Map.GetMapWorldSize then
		local okS, w, h = pcall(C_Map.GetMapWorldSize, mapID)
		if okS and tonumber(w) and tonumber(h) and w > 0 and h > 0 then
			local ax, ay = dx * w, dy * h
			return math.sqrt(ax * ax + ay * ay), ARRIVE_YARDS, "mapsize"
		end
	end

	--- ⚠️ Last resort, and deliberately the only one with its own threshold. A percentage of
	--- the map is not a distance -- it stretches differently in x and y on any map that is not
	--- square -- so this can only ever mean "near enough", never "22 yards". It is still far
	--- better than the nil it replaces, which meant the hand-over could not happen at all.
	return math.sqrt(dx * dx + dy * dy) * 100, ARRIVE_MAP_UNITS, "percent"
end

function ns.StopSmcTwoStepRoute()
	active = nil
end

--- What the door-watcher is doing right now, or nil when it is not running.
---
--- 🔴 BUILT BECAUSE IT COULD NOT BE ASKED — Rob, 7 Sep 2026. `/mh arrow` inside the room
--- proved the hand-over never fires (target still the door, owner still live, same map as
--- the route, so the position is readable in principle). It could not say WHY, because
--- everything this file does happens in a closure nobody can see into: whether the ticker
--- is alive, what it last measured, whether it already gave up. Three different failures
--- produce the identical silence.
---
--- 📌 `yards = nil` is the interesting answer, not the empty one. It means the distance
--- could not be measured, which is exactly the state that makes a distance-driven hand-over
--- impossible -- and it is indistinguishable from "measured, still far" unless we say so.
--- This is CLAUDE.md's rule about modules whose normal outcome is silence.
--- @return table|nil
function ns.SmcTwoStepStatus()
	if not active then
		return nil
	end
	local d, limit, how = DoorProximity(active.mapID, active.door.x, active.door.y)
	return {
		mapID = active.mapID,
		doorX = active.door.x,
		doorY = active.door.y,
		destLabel = active.dest and active.dest.label,
		destX = active.dest and active.dest.x,
		destY = active.dest and active.dest.y,
		yards = d, -- nil = could not be measured at all
		limit = limit,
		how = how, -- which of the three answered; a silent drop to "percent" is a finding
		elapsed = active.elapsed or 0,
		giveUp = GIVE_UP_SECONDS,
		arriveYards = ARRIVE_YARDS,
	}
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
	local d, limit = DoorProximity(active.mapID, active.door.x, active.door.y)
	if d and d <= limit then
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
	-- Already at the door: skip the detour entirely. Sending someone outside to come
	-- back in is worse than the bug this fixes.
	local d, limit = DoorProximity(mapID, e.x, e.y)
	if d and d <= limit then
		return nil
	end

	--- 🔴 …AND "AT THE DOOR" WAS NOT THE SAME AS "PAST IT". Rob, 7 Sep 2026: *"als ik al in
	--- de kamer sta en vraag de weg, stuurt ie me eerst terug naar de deur en dan weer naar
	--- de portal."* The check above only recognised someone standing ON the doorstep. Walk
	--- five paces further in and you are past the threshold in both senses, and the route
	--- marched you back out.
	---
	--- 📌 The rule needs no new number: if the destination is nearer than its own door, the
	--- door is behind you. Both distances come from `DoorProximity`, so they are in the same
	--- unit whichever of the three methods answered -- which is exactly why that function
	--- returns the unit it used.
	---
	--- ⚠️ IT IS GEOMETRY, NOT A DOOR SENSOR, and it can be wrong in one specific place:
	--- standing OUTSIDE but directly behind the building, where the portal really is nearer
	--- than the entrance. Then you get the arrow pointing through a wall -- which is exactly
	--- the 3 sep bug this whole file exists to fix. The trade is deliberate: that spot is
	--- narrow and the wrong answer there is merely the behaviour everyone had before 3 sep,
	--- while being sent back outside happens every time you ask from inside the room.
	local dDest = DoorProximity(mapID, point.x, point.y)
	if d and dDest and dDest <= d then
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
