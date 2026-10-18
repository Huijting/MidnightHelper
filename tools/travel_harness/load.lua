-- Loads MH's travel files into a stubbed client (tools/travel_harness, 18 Oct 2026). Used by test.lua and run.lua.
local SCR = arg[0]:match("(.*/)") or "./"
dofile(SCR .. "world.lua")
local REPO = os.getenv("MH_REPO") or (SCR .. "../..")

-- Anything the files touch at load time that we did not define becomes an inert, callable stub.
local Stub
Stub = setmetatable({}, {
	__index = function()
		return Stub
	end,
	__call = function()
		return Stub
	end,
	__newindex = function() end,
})
_G.Stub = Stub
local loading = true
setmetatable(_G, {
	__index = function(_, k)
		if loading then
			return Stub
		end
		return nil
	end,
})

local ns = { db = {}, VERSION = "test" }
_G.MH_NS = ns
local FILES = os.getenv("MH_FILES") or table.concat({
	"Locales/enUS.lua", "Locales/Locale.lua", "Modules/MountRunData.lua", "Modules/Delves.lua",
	"Modules/FlightPointsData.lua", "Modules/Travel/TravelGeo.lua", "Modules/Travel/TravelData.lua",
	"Modules/Travel/TravelPlanner.lua", "Modules/Travel/TravelRoute.lua", "Modules/Travel/TravelPlaces.lua", "Modules/Travel/TravelGraph.lua",
	"Modules/MountRun.lua", "Modules/TravelPlan.lua",
}, ",")
for f in FILES:gmatch("[^,]+") do
	local chunk, err = loadfile(REPO .. "/" .. f)
	if not chunk then
		error(err)
	end
	local ok, e = pcall(chunk, "MidnightHelper", ns)
	if not ok then
		io.stderr:write(("load %s: %s\n"):format(f, tostring(e)))
	end
end
loading = false
-- Re-stub the client APIs the files may have shadowed with Stub during loading.
ns.db = ns.db or {}
if type(ns.GetItemCooldownSafe) ~= "function" then
	ns.GetItemCooldownSafe = function()
		return W.P.hearthCD
	end
end
return ns
