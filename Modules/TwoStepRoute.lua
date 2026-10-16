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

	🚌 TRAVEL PHASE 3 (16 Oct 2026): the ticker is gone from this file. The door hand-over is now the route runner's
	`via` (Modules/Travel/TravelRoute.lua), shared with the Mount run and the travel plan's portal doors. This file
	keeps the decision whether a door is needed, the distance helpers, and the old names as pass-throughs.
]]

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

--- World position in yards for a map coordinate, or nil.
--- ⚠️ Returns nil rather than guessing: without both positions there is no distance,
--- and a made-up one would advance the route while the player is still outside.
--- ✅ 16 Oct 2026 — THE NIL WAS OURS, NOT SILVERMOON'S. Rob ran
--- `/dump C_Map.GetWorldPosFromMapPos(2393, CreateVector2D(0.5,0.5))` in Silvermoon: continent 0, x 8837.5,
--- y -4738.54. Silvermoon has world coordinates; this function passed a UiMapPoint where the API takes a Vector2D
--- (every other caller in MH passes a Vector2D, travel map §1b-5). Vector2D first now; the old form stays as a fallback.
local function WorldXY(mapID, x01, y01)
	if not (C_Map and C_Map.GetWorldPosFromMapPos) then
		return nil
	end
	if CreateVector2D then
		local okV, _, world = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(x01, y01))
		if okV and world and world.x and world.y then
			return world.x, world.y
		end
	end
	if not (UiMapPoint and UiMapPoint.CreateFromCoordinates) then
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

--- For other door hand-overs (DelveTipMarkup's travel-plan door, 16 Oct 2026): the same three-way measurement, so a
--- door in Silvermoon can be reached at all. Returns dist, limit, how — compare dist with limit, never with yards.
ns.SmcDoorProximity = DoorProximity

function ns.StopSmcTwoStepRoute()
	if ns.Travel and ns.Travel.Stop then
		ns.Travel.Stop("StopSmcTwoStepRoute")
	end
end

--- What the door hand-off is doing right now, or nil when there is none (`/mh arrow`).
---
--- 🔴 BUILT BECAUSE IT COULD NOT BE ASKED — Rob, 7 Sep 2026: three different failures (ticker dead, never close
--- enough, distance unreadable) produced the identical silence. Travel phase 3 (16 Oct 2026): the watcher itself is
--- now the route runner's (Modules/Travel/TravelRoute.lua, Travel.ViaStatus); this name stays for NativeArrow.
--- @return table|nil
function ns.SmcTwoStepStatus()
	if ns.Travel and ns.Travel.ViaStatus then
		return ns.Travel.ViaStatus()
	end
	return nil
end

--- Begin a two-step route for a pin that has an `entrance`.
--- Travel phase 3: the decision (door needed or not) stays here; the hand-over at the door is the route runner's
--- `via`, the same one the Mount run's portal room and the Coiled Isle delve route use. The 300 s give-up is gone:
--- the runner stops when the route ends, another route takes the arrow, or /mh clear.
--- @return table|nil doorTarget  the entrance to route to now, or nil to go direct
function ns.StartSmcTwoStepRoute(point, mapID)
	local e = point and point.entrance
	if type(e) ~= "table" or not (e.x and e.y) then
		return nil
	end
	--- 🔴 "AT THE DOOR" IS NOT "THROUGH IT" — either way round. Rob, 7 Sep 2026, inside the room: sent back out to the
	--- door ("als ik al in de kamer sta … stuurt ie me eerst terug naar de deur"). Rob, 16 Oct 2026, ~20 m in front of
	--- the archway: the arrow already on the portal behind the wall, because "within 22 yd of the door" counted as
	--- passed. Both answers now come from the route runner (Travel.ViaInside, TravelRoute.lua): through = closer to
	--- what lies behind the door than the door is, and closer to the door than that span. The orb down to the Coiled
	--- Isle portal (Rob, same evening, 55.80/65.02) is a second such point.
	if not (ns.Travel and ns.Travel.Start and ns.Travel.PendingVia) then
		return nil
	end
	-- The pin's own code (UI.lua SetSMCWaypoint) points at what this returns and sets the owner right after.
	local orb = type(point.orb) == "table" and point.orb.x and point.orb.y and { point.orb.x, point.orb.y } or nil
	ns.Travel.Start({ map = mapID, x = point.x, y = point.y, name = point.label, arrivesOn = point.arrivesOn }, {
		owner = "waypoint",
		steps = { { map = mapID, x = point.x, y = point.y, text = point.label, final = true,
			via = { e.x, e.y }, orb = orb, viaNear = "door",
			viaDoneKey = (not orb) and "SMC_ENTRANCE_ARRIVED_FMT" or nil } },
		finish = true,
		alreadyPointed = true,
		via = "Silvermoon pin",
	})
	local vx, vy, label, isOrb = ns.Travel.PendingVia()
	if not vx then
		return nil -- already through everything: straight to the portal
	end
	return {
		x = vx,
		y = vy,
		label = isOrb and label or (ns:L("SMC_ENTRANCE_LABEL_FMT")):format(point.label or "?"),
	}
end
