-- Prints what BuildTravelPlan gives for every scenario: lua5.1 tools/travel_harness/run.lua [scenario-id]
local SCR = arg[0]:match("(.*/)") or "./"
local ns = dofile(SCR .. "load.lua")
local scenarios = dofile(SCR .. "scenarios.lua")
local only = arg[1]

local function reset(p)
	W.P.map, W.P.x, W.P.y = p.map, p.x, p.y
	W.P.faction = p.faction or "Horde"
	W.P.bind = p.bind or (W.P.faction == "Horde" and "Orgrimmar" or "Stormwind City")
	W.P.spells = p.spells or {}
	W.P.hearthCD = p.hearthCD or 0
end

local function line(s)
	local name = ns.TravelStepName and ns.TravelStepName(s, "?") or s.label or "?"
	local where = (s.mapID and s.x) and ("  [%s %.1f/%.1f]"):format(s.mapID, s.x, s.y) or ""
	local cost = s.secs and ("  ~%ds"):format(s.secs) or ""
	return ("%-7s %s%s%s"):format(s.kind, tostring(name), where, cost)
end

local out = {}
for _, sc in ipairs(scenarios) do
	if not only or sc.id == only then
		reset(sc.p)
		local ok, steps, why = pcall(ns.BuildTravelPlan, sc.t.map, sc.t.x, sc.t.y, sc.t.name)
		print(("== %s  (%s → %s)"):format(sc.id, sc.who, sc.t.name))
		if ok and type(steps) == "table" and steps.estimate then
			print(("   estimate ~%d s, %d places compared"):format(steps.estimate, steps.compared or 0))
		end
		local placed = 0
		if not ok then
			print("   ERROR " .. tostring(steps))
		elseif not steps then
			print("   (no plan: " .. tostring(why) .. ")")
		else
			for i, s in ipairs(steps) do
				print(("   %d. %s"):format(i, line(s)))
				if s.kind ~= "arrive" and ((s.mapID and s.x) or s.kind == "hearth" or s.kind == "mage") then
					placed = placed + 1
				end
			end
		end
		-- What the runner falls back to when no plan step has a place (TravelRoute.lua BuildPlainSteps).
		if placed == 0 and ns.Travel.FlightLeg then
			local leg = ns.Travel.FlightLeg(sc.t.map, sc.t.x, sc.t.y, W.P.map)
			print("   runner: " .. (leg and ("flight leg: " .. tostring(leg.text)) or "ARROW STRAIGHT AT THE TARGET"))
		end
		out[#out + 1] = { id = sc.id, placed = placed, steps = ok and steps or nil }
	end
end
return out
