--[[
	Midnight Helper — NativeArrow (standalone route guidance).

	Keeps Blizzard's native user waypoint + SuperTrack pinned to the ACTIVE route
	lead (ns.lastTarget), so routing works WITHOUT TomTom and keeps flowing to the
	next stop on arrival — the same "arrow survives arrival / advances" behaviour we
	built for TomTom's crazy arrow, but on the built-in navigation everyone has.

	It runs in two situations only:
	  1. No TomTom installed  -> native waypoint is the ONLY guidance, so we drive it.
	  2. TomTom present but its crazy arrow is DOWN (hidden) -> safety net: we point
	     the native waypoint at the lead so you're never left without direction
	     (e.g. an outdated TomTom/HereBeDragons that fails to re-pin across maps).

	While TomTom's crazy arrow is actually showing, this module stands down entirely
	(it never sets a native waypoint), so a working TomTom setup is untouched.

	Every route module (Achievements, Rares, Professions/Treasures, Reset routine)
	already publishes its current lead as ns.lastTarget and claims the shared arrow
	via ns._mhRouteOwner, so a single generic keepalive covers all of them.
]]

local _, ns = ...

local C_Map, C_SuperTrack, C_Timer = C_Map, C_SuperTrack, C_Timer

-- Map (0..1) coords -> world (yard) coords. pcall-safe; nil when unavailable.
local function MapToWorld(mapID, x01, y01)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D and mapID) then
		return nil
	end
	local ok, _, world = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(x01, y01))
	if ok and type(world) == "table" then
		if world.GetXY then
			return world:GetXY()
		end
		return world.x, world.y
	end
	return nil
end

local function PlayerWorld()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil
	end
	local pmap = C_Map.GetBestMapForUnit("player")
	if not pmap then
		return nil
	end
	local pos = C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(pmap, "player")
	if not pos then
		return nil
	end
	local px, py = pos:GetXY()
	if not (px and py) then
		return nil
	end
	return MapToWorld(pmap, px, py)
end

local function TargetKey(t)
	if not (t and t.mapID) then
		return nil
	end
	return tostring(t.mapID) .. ":" .. tostring(t.x) .. ":" .. tostring(t.y)
end

local function HasNativeWaypoint()
	return (C_Map and C_Map.HasUserWaypoint and C_Map.HasUserWaypoint()) and true or false
end

local function TomTomArrowShowing()
	local f = _G.TomTomCrazyArrow
	return (f and f.IsShown and f:IsShown()) and true or false
end

-- A route is live when a module owns the shared arrow and has published a lead.
local function RouteActive()
	return (ns.lastTarget and ns.lastTarget.mapID and ns._mhRouteOwner) and true or false
end

-- Should THIS module drive the native waypoint right now?
--   * no TomTom          -> yes (only guidance available)
--   * TomTom arrow down  -> yes (safety net)
--   * TomTom arrow shown -> no  (leave the working crazy arrow alone)
local function ShouldDriveNative()
	if ns.IsTomTomReady and ns.IsTomTomReady() then
		return not TomTomArrowShowing()
	end
	return true
end

-- The last lead WE pinned the native waypoint to (nil = we don't own one).
local mhOwnedKey

local function Tick()
	if not RouteActive() then
		-- Route ended: clear the native waypoint only if WE set it (never nuke a
		-- waypoint the player placed themselves or another feature owns).
		if mhOwnedKey then
			if HasNativeWaypoint() and C_Map and C_Map.ClearUserWaypoint then
				pcall(C_Map.ClearUserWaypoint)
			end
			mhOwnedKey = nil
		end
		return
	end

	if not ShouldDriveNative() then
		return -- TomTom's crazy arrow is doing the job; stand down.
	end

	local t = ns.lastTarget
	local key = TargetKey(t)
	if not key then
		return
	end

	-- Parked ON the lead (within ~20 yd — e.g. an un-spawned rare you walked up to):
	-- don't re-assert every tick, or Blizzard's arrive-clear vs our re-set would churn.
	local atLead = false
	local pwx, pwy = PlayerWorld()
	local twx, twy = MapToWorld(t.mapID, (t.x or 0) / 100, (t.y or 0) / 100)
	if pwx and twx then
		local dx, dy = pwx - twx, pwy - twy
		atLead = (dx * dx + dy * dy) <= (20 * 20)
	end

	local targetChanged = (key ~= mhOwnedKey)
	local waypointGone = not HasNativeWaypoint()

	-- Re-pin when the lead advanced (new target) or when the native waypoint got
	-- cleared on arrival while the route still has an open stop ahead of us.
	if targetChanged or (waypointGone and not atLead) then
		if ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(t.mapID, t.x, t.y) then
			mhOwnedKey = key
		end
	end
end

if C_Timer and C_Timer.NewTicker then
	C_Timer.NewTicker(1.5, Tick)
end
