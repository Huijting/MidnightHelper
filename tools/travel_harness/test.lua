-- Headless checks for the travel plan and the route search (Modules/Travel/TravelGraph.lua), 18 Oct 2026.
--   lua5.1 tools/travel_harness/test.lua        → prints each check, exits 1 on any failure
-- The world is a FIXTURE (world.lua): real uiMap ids, invented geometry. What this proves is the LOGIC — which hops
-- exist, which rule fires, what is never offered — not that a coordinate is right in the game. That is Rob's /reload.
local SCR = arg[0]:match("(.*/)") or "./"
local ns = dofile(SCR .. "load.lua")
local scenarios = dofile(SCR .. "scenarios.lua")

local fails, passes = 0, 0
local function check(name, ok, detail)
	if ok then
		passes = passes + 1
		print("  ok    " .. name)
	else
		fails = fails + 1
		print("  FAIL  " .. name .. (detail and ("  — " .. detail) or ""))
	end
end

local function set(p)
	W.P.map, W.P.x, W.P.y = p.map, p.x, p.y
	W.P.faction = p.faction or "Horde"
	W.P.bind = p.bind or (W.P.faction == "Horde" and "Orgrimmar" or "Stormwind City")
	W.P.spells = p.spells or {}
	W.P.hearthCD = p.hearthCD or 0
	W.P.hearth = p.hearth or 1
	local q = p.quests or {}
	W.P.quests = setmetatable(q, { __index = function()
		return true
	end })
end

local function plan(p, t)
	set(p)
	local ok, steps, why = pcall(ns.BuildTravelPlan, t.map, t.x, t.y, t.name)
	assert(ok, steps)
	return steps, why
end

--- The sources of the steps before "arrive", in order.
local function sources(steps)
	local out = {}
	for _, s in ipairs(steps or {}) do
		if s.kind ~= "arrive" then
			out[#out + 1] = tostring(s.source or s.kind)
		end
	end
	return out
end
local function has(list, pat)
	for _, v in ipairs(list) do
		if v:find(pat, 1, true) then
			return true
		end
	end
	return false
end
local function show(list)
	return table.concat(list, " > ")
end

local S = {}
for _, sc in ipairs(scenarios) do
	S[sc.id] = sc
end
local function run(id)
	local sc = S[id]
	local steps, why = plan(sc.p, sc.t)
	return steps, why, sources(steps)
end

print("Legacy Mythic+ dungeons (DungeonRosterData.lua) — had no plan before 18 Oct")
do
	local st, _, src = run("mplus-algethar")
	check("Algeth'ar from Silvermoon: portal room → Valdrakken", st and src[1] == "MOUNTRUN_HOME"
		and has(src, "P_VALDRAKKEN"), show(src))
	check("  …with an estimate", st and st.estimate ~= nil)
	st, _, src = run("mplus-pitofsaron")
	check("Pit of Saron from Silvermoon: via Dalaran (Northrend)", st and has(src, "P_DALARAN_NR"), show(src))
	st, _, src = run("mplus-skyreach")
	check("Skyreach from Silvermoon (Horde): via the Draenor portal", st and has(src, "P_DRAENOR"), show(src))
	st, _, src = run("mplus-skyreach-A")
	check("Skyreach from Silvermoon (Alliance): via Stormwind and Draenor",
		st and src[1] == "MOUNTRUN_HOME" and has(src, "P_DRAENOR"), show(src))
	local why
	st, why = run("mplus-triumvirate")
	check("Seat of the Triumvirate: honest 'no way known', not 'already there'",
		st == nil and why == "PLAN_NO_ROUTE", tostring(why))
	st, _, src = run("mplus-algethar-orgri")
	check("Algeth'ar from Orgrimmar: straight to the Valdrakken portal", st and src[1] == "MOUNTRUN_HUBS.P_VALDRAKKEN",
		show(src))
	st, _, src = run("mplus-pos-dornogal")
	check("Pit of Saron from Dornogal: home, then Dalaran", st and src[1] == "MOUNTRUN_HOME"
		and has(src, "P_DALARAN_NR"), show(src))
end

print("Other old-world pins")
do
	local st, _, src = run("old-jade-from-silvermoon")
	check("Jade Forest from Silvermoon: via the Jade Forest portal", st and has(src, "P_JADE"), show(src))
	st, _, src = run("old-hyjal-from-orgri")
	check("Hyjal from Orgrimmar: the portal, not a flight across Kalimdor", st and src[1] == "MOUNTRUN_HUBS.E_HYJAL",
		show(src))
	st, _, src = run("same-continent")
	check("Same continent, no portal helps: the old 'fly to' step stays", st and src[1] == "FLIGHT_POINTS" and not st.estimate, show(src))
end

print("Unchanged on purpose (Midnight targets keep WayHome / the portal rules)")
do
	for _, id in ipairs({ "mid-harandar-from-valdrakken", "mid-eversong-from-voidstorm", "mid-silvermoon-from-coiled" }) do
		local st, _, src = run(id)
		local graph = st and st.estimate ~= nil
		check(id .. ": route search not used", st and not graph, show(src))
	end
	local st, why = run("already-there")
	check("A pin on your own map: still 'nothing to plan'", st == nil and why == "PLAN_ALREADY_THERE", tostring(why))
end

print("Hearthstone and mage teleports")
do
	local ALG = S["mplus-algethar"].t
	local st = plan({ map = 2393, x = 50, y = 50, spells = { [3567] = true } }, ALG)
	check("Mage in Silvermoon: the portal room beats the teleport (lands beside the next portal)",
		st and st[1].kind == "portal", st and st[1].kind)
	st = plan({ map = 2395, x = 95, y = 95 }, ALG)
	check("Far out in Eversong, Hearth bound Orgrimmar: Hearthstone", st and st[1].kind == "hearth", st and st[1].kind)
	st = plan({ map = 2395, x = 95, y = 95, hearthCD = 900 }, ALG)
	check("…but never while it is on cooldown", st and st[1].kind ~= "hearth", st and st[1].kind)
	st = plan({ map = 2395, x = 95, y = 95, hearth = 0 }, ALG)
	check("…and never without one", st and st[1].kind ~= "hearth", st and st[1].kind)
	st = plan({ map = 2393, x = 50, y = 50 }, ALG)
	check("In Silvermoon a short walk wins over burning the Hearthstone", st and st[1].kind == "portal",
		st and st[1].kind)
end

print("Quest-gated hop (Isle of Thunder) and rides")
do
	local T = { map = 504, x = 50, y = 50, name = "Isle of Thunder pin" }
	local st = plan({ map = 85, x = 50, y = 80, quests = { [32680] = false } }, T)
	local s2 = st and st[2]
	check("Quest not done: the quest giver is the step", s2 and s2.source == "MOUNTRUN_HUBS.TL_THUNDER" and s2.board,
		s2 and tostring(s2.label))
	st = plan({ map = 85, x = 50, y = 80 }, T)
	s2 = st and st[2]
	check("Quest done: the portal itself", s2 and s2.source == "MOUNTRUN_HUBS.TL_THUNDER" and not s2.board)
	st = plan({ map = 84, x = 60, y = 30, faction = "Alliance" }, { map = 87, x = 50, y = 50, name = "Ironforge" })
	check("Alliance to Ironforge: the tram, marked as boarding", st and st[1].source == "MOUNTRUN_HUBS.TRAM_IF"
		and st[1].board == true)
	st = plan({ map = 85, x = 50, y = 80 }, { map = 84, x = 50, y = 50, name = "Stormwind" })
	check("Horde never gets an Alliance-only hop", not (st and has(sources(st), "TRAM_IF")))
end

print("Flight leg (TravelRoute.lua)")
do
	set({ map = 2393, x = 50, y = 50 })
	check("No flight master step to another continent", ns.Travel.FlightLeg(118, 54.78, 91.80, 2393) == nil)
	set({ map = 1, x = 50, y = 50 })
	check("A flight leg on the same continent still exists", ns.Travel.FlightLeg(10, 50, 50, 1) ~= nil)
end

print("Robustness")
do
	local st, why = plan({ map = 2393, x = 50, y = 50 }, { map = 99999, x = 50, y = 50, name = "?" })
	check("Unknown target map: no crash, no invented route", st == nil and why == "PLAN_NO_ROUTE", tostring(why))
	local t0 = os.clock()
	for _ = 1, 20 do
		plan({ map = 2393, x = 50, y = 50 }, S["mplus-skyreach"].t)
	end
	local ms = (os.clock() - t0) * 1000 / 20
	check(("One search under 40 ms in plain Lua 5.1 (%.1f ms)"):format(ms), ms < 40)
end

print(("\n%d passed, %d failed"):format(passes, fails))
os.exit(fails == 0 and 0 or 1)
