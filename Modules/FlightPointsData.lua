local _, ns = ...

--[[
	Midnight Helper — flight points for the Midnight zones.

	WHY. On 15 Aug 2026 Rob clicked a coordinate link while standing in Silvermoon
	and got nothing. The click now reports what it did (see DelveTipMarkup's
	ReportWaypointResult), but "you are in Silvermoon City, the waypoint is in the
	Vaults of Atal'Utek" still leaves the actual question unanswered: how do I get
	there? His own suggestion: pull the flight points out of Zygor.

	SOURCE. ZygorGuidesViewer's `fpath` lines in Guides-Retail (the Midnight guides),
	with the zone name resolved to a uiMapID through Zygor's OWN LibRover table
	(Libs-Retail/LibRover-1.0/data.lua) rather than through anything I remembered.
	Two Zygor datasets cross-checked against each other, and this repo already trusts
	Zygor for quest chains, transitions and coordinates of exactly this kind.

	⚠️ One apparent contradiction was chased down rather than waved away. LibRover
	maps "Zul Aman M" to 2437 and "Eversong Woods M" to 2395, while our delve roster
	lists Atal'Aman — a Zul'Aman-themed delve — on 2395. Our own Rares.lua settles it:
	[2395] = "eversong", [2437] = "zulaman". LibRover agrees with us; the delve entry
	is simply an entrance that sits in Eversong. Nothing here is swapped.

	⚠️ These are still CANDIDATES. Zygor's coordinates have been ~right all year and
	Rob's standing rule is to use them without a spot-check, but a flight point that
	does not exist sends someone on a walk. If one is wrong, the symptom is a named
	flight master who is not there — report it and it comes out.

	Floors: three entries live on a non-zero floor in Zygor's notation (Atal'Aman
	floor 1, The Den floor 2). Recorded in the comments; the advice only names the
	flight master, so the floor never reaches the player.
]]

--- uiMapID -> { { name, x, y }, ... }
ns.FLIGHT_POINTS = {
	-- Silvermoon City
	[2393] = {
		{ "Sanctum of Light", 50.97, 71.25 },
		{ "The Royal Exchange", 69.36, 63.31 },
	},
	-- Eversong Woods
	[2395] = {
		{ "Fairbreeze Village", 44.70, 44.98 },
		{ "Tranquillien", 47.80, 67.13 },
		{ "Silverglade Refuge", 31.01, 90.07 },
	},
	-- Voidstorm
	[2405] = {
		{ "The Ingress", 36.91, 58.98 },
		{ "Locus Point", 42.29, 73.73 },
		{ "Howling Ridge", 51.14, 69.26 },
	},
	-- Harandar
	[2413] = {
		{ "Har'mara", 35.53, 23.81 },
		{ "Har'kuai", 64.59, 23.15 },
		{ "Har'alnor", 31.73, 67.43 },
		{ "Har'athir", 69.36, 52.60 },
		{ "The Den", 70.74, 53.23 }, -- Zygor floor 2
	},
	-- Isle of Quel'Danas
	[2424] = {
		{ "Terrace of the Sun", 57.55, 33.85 },
	},
	-- Zul'Aman
	[2437] = {
		{ "Amani'Zar Village", 44.82, 65.43 },
		{ "Shadebasin Watch", 44.01, 33.61 },
		{ "Witherbark Bluffs", 38.89, 23.21 },
		{ "Camp Stonewash", 47.31, 25.52 },
		{ "Torntusk Overlook", 33.90, 78.32 },
	},
	-- Slayer's Rise
	[2444] = {
		{ "Master's Perch", 38.13, 79.92 },
	},
	-- Vaults of Atal'Utek (12.1) — measured on Rob's own client as map 2509
	[2509] = {
		{ "Amani Foothold", 44.42, 62.21 },
	},
	-- The Coiled Isle (12.1)
	[2512] = {
		{ "Tokka's Landing", 57.88, 45.70 },
	},
	-- Atal'Aman (delve interior)
	[2535] = {
		{ "Atal'Aman", 39.79, 40.79 }, -- Zygor floor 1
	},
}

--- The flight point on `mapID` closest to (x, y), or nil when we know none.
---
--- Distance is computed in raw map units, which are neither metres nor equal in x
--- and y on a non-square map. That is fine for picking between five flight points
--- in one zone and would not be fine for anything else, so it stays in here.
function ns.GetNearestFlightPoint(mapID, x, y)
	local list = ns.FLIGHT_POINTS[tonumber(mapID) or 0]
	if not list or #list == 0 then
		return nil
	end
	x, y = tonumber(x), tonumber(y)
	if not (x and y) then
		return list[1][1], list[1][2], list[1][3]
	end
	local best, bestDist
	for _, fp in ipairs(list) do
		local dx, dy = fp[2] - x, fp[3] - y
		local d = dx * dx + dy * dy
		if bestDist == nil or d < bestDist then
			best, bestDist = fp, d
		end
	end
	return best[1], best[2], best[3]
end
