local _, ns = ...

--[[
	Midnight Helper — FarstriderLib probe (/mh trail).

	MEASUREMENT ONLY. This file changes no behaviour, draws no UI, and is not wired
	into the travel assistant. It exists to answer one question with real data:
	does FarstriderLib return a route we could actually show a player?

	Why: MH's travel advice comes from a hand-written table of twelve portals in
	Modules/Delves.lua (MIDNIGHT_PORTALS). It picks whichever of those twelve is
	nearest -- it does not know whether a route exists at all, which is why it can
	suggest a 3km flight when a Hearthstone would do. FarstriderLib is a weighted
	travel graph (portals, flightpaths, boats, zeppelins, items, spells, four
	Hearthstone variants) and would answer a different, better question. Whether it
	does so in practice is unproven, hence this probe.

	Nothing here is assumed:
	  - The API is FarstriderLib_API (README, "Public API"). The older _G.FarstriderLib
	    still works but the README says it will be removed, so we prefer the table and
	    report which one we actually used.
	  - UNITS DIFFER. MH leads carry x/y as 0-100 (NativeArrow.lua divides by 100
	    before converting to world coords). FarstriderLib passes the raw return of
	    C_Map.GetPlayerMapPosition straight into its solver, which is 0-1. So we
	    divide, and we print both numbers so a wrong conversion is visible rather
	    than silent.
	  - A step's shape is { id, loc, completionLoc, loca, actionOptions, checkDistance }
	    and a loc is { mapId = n, pos = { x, y, z } } -- both read from
	    FarstriderLib~Pathfinding.lua, not guessed. We still print a placeholder when
	    a field is missing instead of inventing one.
	  - pcall returning true is NOT success. A path is only reported when the return
	    is a table; anything else is printed as what it was.

	If this probe shows good routes, the integration would still be strictly optional
	with the twelve-portal table kept as fallback -- almost nobody has FarstriderLib
	installed. That is a later decision, not this file's.
]]

local PREFIX = "|cffffff78Midnight Helper:|r "

-- A long cross-continent route is still only a handful of hops, but a bug could
-- produce hundreds. Cap the listing and say so -- a silent cut would read as
-- "that was the whole route".
local MAX_STEPS_SHOWN = 30

--- The library, however it is reachable.
--- @return table|nil api, string source
local function ResolveAPI()
	if type(FarstriderLib_API) == "table" and type(FarstriderLib_API.FindTrailTo) == "function" then
		return FarstriderLib_API, "FarstriderLib_API"
	end
	if type(FarstriderLib) == "table" and type(FarstriderLib.FindTrailTo) == "function" then
		return FarstriderLib, "FarstriderLib (legacy global)"
	end
	return nil, "not found"
end

--- Where are we routing to, and how do we know?
--- Prefers MH's own arrow; falls back to the player's map pin so the probe is
--- usable even when no MH route is running.
--- @return table|nil target { mapID, x, y (0-100), name, source }
local function ResolveTarget()
	if type(ns.GetActiveArrowLead) == "function" then
		local ok, lead = pcall(ns.GetActiveArrowLead)
		if ok and type(lead) == "table" and lead.mapID then
			return {
				mapID = lead.mapID,
				x = tonumber(lead.x) or 0,
				y = tonumber(lead.y) or 0,
				name = lead.name or "(unnamed lead)",
				source = "MH arrow",
			}
		end
	end

	if C_Map and C_Map.GetUserWaypoint then
		local ok, point = pcall(C_Map.GetUserWaypoint)
		if ok and type(point) == "table" and point.uiMapID and point.position then
			local okXY, px, py = pcall(point.position.GetXY, point.position)
			if okXY and px then
				return {
					mapID = point.uiMapID,
					x = px * 100,
					y = (py or 0) * 100,
					name = "(map pin)",
					source = "Blizzard user waypoint",
				}
			end
		end
	end

	return nil
end

--- Describe a step's location without inventing field names.
local function DescribeLoc(loc)
	if type(loc) ~= "table" then
		return "no loc"
	end
	local pos = loc.pos
	if type(pos) ~= "table" or not tonumber(pos.x) then
		return ("map %s, no pos"):format(tostring(loc.mapId))
	end
	-- Farstrider stores 0-1; show the 0-100 reading players recognise from the map.
	return ("map %s at %.1f, %.1f"):format(tostring(loc.mapId), pos.x * 100, (tonumber(pos.y) or 0) * 100)
end

--- /mh trail — ask FarstriderLib for a route to the current target and print it raw.
function ns.PrintFarstriderProbe()
	print(PREFIX .. "FarstriderLib probe")

	local api, source = ResolveAPI()
	print(("  library         = %s"):format(source))
	print(("  FarstriderLibData = %s"):format(
		tostring(C_AddOns and C_AddOns.IsAddOnLoaded and select(1, C_AddOns.IsAddOnLoaded("FarstriderLibData")))))
	if not api then
		print("  FarstriderLib is not installed or not loaded. Nothing to measure.")
		return
	end
	if api.VERSION ~= nil then
		print(("  version         = %s"):format(tostring(api.VERSION)))
	end

	local target = ResolveTarget()
	if not target then
		print("  no target: no MH arrow is running and there is no map pin.")
		print("  Set a waypoint (or start an MH route) and run /mh trail again.")
		return
	end
	print(("  target          = %s [%s]"):format(target.name, target.source))
	print(("  target coords   = map %s at %.1f, %.1f  (sent as %.4f, %.4f)"):format(
		tostring(target.mapID), target.x, target.y, target.x / 100, target.y / 100))

	local from = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	print(("  player map      = %s"):format(tostring(from)))

	local startedAt = debugprofilestop and debugprofilestop() or nil
	-- Farstrider takes 0-1 map coordinates; MH carries 0-100. See the header.
	local ok, steps = pcall(api.FindTrailTo, target.mapID, target.x / 100, target.y / 100, 0)
	local tookMs = (startedAt and debugprofilestop) and (debugprofilestop() - startedAt) or nil

	if not ok then
		print(("  FindTrailTo ERRORED: %s"):format(tostring(steps)))
		return
	end
	if tookMs then
		print(("  solved in       = %.1f ms"):format(tookMs))
	end
	-- pcall said "no error". That is not the same as "we got a route".
	if type(steps) ~= "table" then
		print(("  FindTrailTo returned %s (%s) -- no route."):format(type(steps), tostring(steps)))
		return
	end

	local n = #steps
	print(("  steps           = %d"):format(n))
	if n == 0 then
		print("  Empty path. Either you are already there, or the graph knows no way.")
		return
	end

	local shown = math.min(n, MAX_STEPS_SHOWN)
	for i = 1, shown do
		local step = steps[i]
		if type(step) ~= "table" then
			print(("  %2d. (step is a %s, not a table)"):format(i, type(step)))
		else
			local line = step.loca
			if type(line) ~= "string" then
				line = ("(no loca; id = %s)"):format(tostring(step.id))
			end
			print(("  %2d. %s"):format(i, line))
			local extra = DescribeLoc(step.loc)
			if step.actionOptions ~= nil then
				extra = extra .. "  [has actionOptions]"
			end
			print("        " .. extra)
		end
	end
	if shown < n then
		print(("  ... %d further steps not shown (listing capped at %d)."):format(n - shown, MAX_STEPS_SHOWN))
	end
end
