local _, ns = ...

--[[
	Midnight Helper — Sturdy Chests per delve, as DATA.

	⚠️ WHY THIS FILE EXISTS. Rob, 16 aug 2026: "in de delves kunnen we ook een route
	inbouwen voor de treasures." His own observation is what made it obviously possible —
	clicking a chest link in the delve coach already draws an arrow inside the delve, so
	the hard part was never the hard part.

	And `/mh zone` inside Gnarldor Isle (2635) measured why that works, which is worth
	writing down because it is not obvious:

	    waypoint  = REFUSED — Blizzard's pin cannot be placed on this map
	    world pos = yes, continent 3038 — our own arrow can work here
	    instance  = true, type scenario

	Two different capabilities. Blizzard's user waypoint is unavailable inside a delve;
	our arrow only needs world coordinates, and those resolve. A feature built on the
	first would be impossible; built on the second it already works.

	⚠️ The coordinates lived in LOCALE STRINGS — `{WAY:2635:60.44:68.12:Sturdy Chest 1}`
	inside DELVE_TIP_GNARLDOR_ROUTE, in seven languages. Fine as prose, useless as data:
	a route must not parse translated text to find out where it is going. Hence a table.

	✅ CROSS-CHECKED, 16 aug. Every coordinate here comes from HandyNotes_Midnight, and
	the six we already shipped in our own tips match it to the decimal (60.44/68.12,
	52.41/40.84, 28.67/41.69, 44.16/22.60, 25.19/73.74, 48.56/94.84). Two sources that
	were written independently and agree exactly — the strongest thing we have short of
	walking to all thirty-six ourselves. Rob's standing rule already trusts HandyNotes
	coordinates; this adds a second vote for the ones we can check.

	⚠️ The QUEST IDS are a different matter and carry no such vote. They come from
	HandyNotes alone, and on 13 aug their Coiled Isle quest band turned out not to be the
	flag the game fires. So a route must keep working when a quest id is wrong: an
	unreadable flag means "not known to be done", never "done", so a bad id costs you a
	chest you walk to twice — not a chest the route silently hides.

	⚠️ Sunkiller Sanctum is split over TWO maps (2528 upper, 2571 lower). Its three chests
	are not on one map, so anything that assumes "a delve has one map and three chests"
	is wrong here. It is the only one.
]]

--- uiMapID -> ordered list of Sturdy Chests. Order is HandyNotes' own numbering, which
--- is the order the delve presents them, not a walking route: the router sorts by
--- distance from where you actually stand.
ns.DELVE_CHESTS = {
	[2502] = { -- The Shadow Enclave
		{ x = 54.59, y = 84.88, quest = 94001 },
		{ x = 54.63, y = 48.85, quest = 94002 },
		{ x = 55.90, y = 34.37, quest = 94028 },
	},
	[2504] = { -- Twilight Crypts
		{ x = 56.82, y = 85.79, quest = 94020 },
		{ x = 21.74, y = 36.29, quest = 94034 },
		{ x = 46.93, y = 49.89, quest = 94037 },
	},
	[2505] = { -- The Gulf of Memory (Upper Rootway)
		{ x = 54.23, y = 25.18, quest = 94023 },
		{ x = 39.72, y = 26.14, quest = 94016 },
		{ x = 55.43, y = 26.15, quest = 94041 },
	},
	[2506] = { -- Shadowguard Point
		{ x = 58.63, y = 60.52, quest = 94044 },
		{ x = 41.80, y = 53.75, quest = 94017 },
		{ x = 58.26, y = 41.51, quest = 94025 },
	},
	[2510] = { -- The Grudge Pit
		{ x = 69.76, y = 31.65, quest = 94022 },
		{ x = 36.97, y = 28.65, quest = 94039 },
		{ x = 67.53, y = 59.56, quest = 94021 },
	},
	[2525] = { -- The Darkway
		{ x = 53.10, y = 43.05, quest = 94026 },
		{ x = 45.81, y = 45.50, quest = 94045 },
		{ x = 41.58, y = 48.24, quest = 94027 },
	},
	[2528] = { -- Sunkiller Sanctum (upper) — see the note above: two maps, one delve
		{ x = 38.14, y = 49.02, quest = 94042 },
	},
	[2535] = { -- Atal'aman
		{ x = 48.34, y = 50.51, quest = 94014 },
		{ x = 53.06, y = 57.95, quest = 94000 },
		{ x = 53.00, y = 65.34, quest = 94038 },
	},
	[2545] = { -- Parhelion Plaza
		{ x = 9.63,  y = 50.31, quest = 94019 },
		{ x = 41.16, y = 86.79, quest = 94033 },
		{ x = 22.44, y = 61.08, quest = 94015 },
	},
	[2547] = { -- Collegiate Calamity
		{ x = 30.95, y = 12.46, quest = 94018 },
		{ x = 29.54, y = 53.97, quest = 94030 },
		{ x = 81.28, y = 32.09, quest = 94029 },
	},
	[2571] = { -- Sunkiller Sanctum (lower)
		{ x = 49.75, y = 50.52, quest = 94043 },
		{ x = 60.11, y = 40.79, quest = 94024 },
	},
	[2633] = { -- The Ring of Glory (12.1)
		{ x = 44.16, y = 22.60, quest = 96807 },
		{ x = 25.19, y = 73.74, quest = 96803 },
		{ x = 48.56, y = 94.84, quest = 96806 },
	},
	[2635] = { -- Gnarldor Isle (12.1)
		{ x = 60.44, y = 68.12, quest = 96802 },
		{ x = 52.41, y = 40.84, quest = 96804 },
		{ x = 28.67, y = 41.69, quest = 96805 },
	},
}

--------------------------------------------------------------------------------
-- Learning a delve we do not ship
--------------------------------------------------------------------------------

--- ⚠️ The table above is hand-extracted from another addon, so it is a snapshot. When
--- 12.2 adds a delve, MH says "no chest list for this delve yet" — honest, and it does
--- not fix itself. Rob asked for that to stop being true (16 aug), while keeping the
--- HandyNotes route as the fast path: `tools/delve_chests.py` re-checks and diffs it.
---
--- This is the other half: learn from what the player actually opens.
---
--- ⚠️ The hard part is knowing a CHEST was opened rather than a mob looted. LOOT_OPENED
--- alone would record every kill. GetLootSourceInfo hands back a GUID per loot slot, and
--- a GameObject GUID is shaped "GameObject-0-…-<objectID>-…" while a creature's says
--- "Creature". That distinction is free and exact — so this records objects only, and
--- keeps the objectID so a later session can tell a Sturdy Chest from a herb node
--- instead of guessing from coordinates.
---
--- Learned entries are CANDIDATES and stay marked as such. They are used for routing on
--- a map we ship nothing for, never to overrule the table above.
local function LearnedStore()
	ns.db = ns.db or {}
	if type(ns.db.delveChestsLearned) ~= "table" then
		ns.db.delveChestsLearned = {}
	end
	return ns.db.delveChestsLearned
end

--- @return table|nil learned rows for this map
function ns.GetLearnedDelveChests(mapID)
	local store = ns.db and ns.db.delveChestsLearned
	return (type(store) == "table" and mapID) and store[mapID] or nil
end

do
	local watcher = CreateFrame("Frame")
	watcher:RegisterEvent("LOOT_OPENED")
	watcher:SetScript("OnEvent", function()
		if not (GetNumLootItems and GetLootSourceInfo and C_Map and C_Map.GetBestMapForUnit) then
			return
		end
		-- Only inside instanced content. Out in the world this would happily record
		-- every treasure chest on the continent into a delve table.
		if IsInInstance then
			local okI, inInst = pcall(IsInInstance)
			if not (okI and inInst) then
				return
			end
		end
		local okM, mapID = pcall(C_Map.GetBestMapForUnit, "player")
		if not okM or not mapID then
			return
		end

		local objectID
		for slot = 1, (GetNumLootItems() or 0) do
			local okS, guid = pcall(GetLootSourceInfo, slot)
			if okS and type(guid) == "string" and guid:find("^GameObject") then
				objectID = tonumber(guid:match("GameObject%-%d+%-%d+%-%d+%-%d+%-(%d+)"))
				break
			end
		end
		if not objectID then
			return -- a creature, or nothing we can attribute: record nothing
		end

		local okP, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
		if not okP or not pos or not pos.GetXY then
			return
		end
		local okXY, px, py = pcall(pos.GetXY, pos)
		if not okXY or not px then
			return
		end
		px, py = px * 100, py * 100

		local store = LearnedStore()
		store[mapID] = store[mapID] or {}
		-- Same spot twice is the same chest seen again, not a second one. Two metres of
		-- map percentage is well inside "you stood next to it once before".
		for _, r in ipairs(store[mapID]) do
			if math.abs(r.x - px) < 2 and math.abs(r.y - py) < 2 then
				r.seen = (r.seen or 1) + 1
				return
			end
		end
		store[mapID][#store[mapID] + 1] = {
			x = tonumber(("%.2f"):format(px)), y = tonumber(("%.2f"):format(py)),
			objectID = objectID, seen = 1, at = (time and time()) or 0,
		}
	end)
end

--- @return table|nil chests, number|nil mapID, boolean learned
function ns.GetDelveChestsHere()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil, nil, false
	end
	local ok, mapID = pcall(C_Map.GetBestMapForUnit, "player")
	if not ok or not mapID then
		return nil, nil, false
	end
	local shipped = ns.DELVE_CHESTS[mapID]
	if shipped then
		return shipped, mapID, false
	end
	-- Nothing shipped for this map: fall back to what this character has walked into.
	-- Marked learned so callers can say where the list came from.
	local learned = ns.GetLearnedDelveChests(mapID)
	if learned and #learned > 0 then
		return learned, mapID, true
	end
	return nil, mapID, false
end

--- Has this chest been opened on this character?
---
--- ⚠️ Three-state on purpose, and the third state is why this is a function and not an
--- `if`. true = opened, false = not opened, nil = we cannot tell (no quest id, or the
--- API is unavailable). Callers must treat nil as "still worth visiting". Collapsing
--- nil into true would make a wrong quest id hide a chest the player never opened, and
--- they would never learn why the route skipped it.
--- @return boolean|nil
function ns.IsDelveChestDone(chest)
	if not (chest and chest.quest) then
		return nil
	end
	if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return nil
	end
	local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, chest.quest)
	if not ok then
		return nil
	end
	return done and true or false
end

--- The chests still worth walking to here, nearest first.
--- @return table list, number|nil mapID, number total, number unknown
function ns.GetOpenDelveChests()
	local chests, mapID, learned = ns.GetDelveChestsHere()
	if not chests then
		return {}, mapID, 0, 0, false
	end
	local px, py
	if C_Map and C_Map.GetPlayerMapPosition then
		local ok, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
		if ok and pos and pos.GetXY then
			local okXY, a, b = pcall(pos.GetXY, pos)
			if okXY and a then
				px, py = a * 100, b * 100
			end
		end
	end

	local open, unknown = {}, 0
	for i = 1, #chests do
		local c = chests[i]
		local done = ns.IsDelveChestDone(c)
		if done == nil then
			unknown = unknown + 1
		end
		if done ~= true then
			local d
			if px then
				local dx, dy = c.x - px, c.y - py
				d = dx * dx + dy * dy -- squared: we only ever compare these
			end
			open[#open + 1] = { x = c.x, y = c.y, quest = c.quest, index = i, dist = d }
		end
	end
	table.sort(open, function(a, b)
		if a.dist and b.dist then
			return a.dist < b.dist
		end
		-- No player position (loading screen): keep the delve's own order rather than
		-- inventing one.
		return a.index < b.index
	end)
	return open, mapID, #chests, unknown, learned
end

--------------------------------------------------------------------------------
-- The route itself
--------------------------------------------------------------------------------

--- ⚠️ This route does NOT go through MHResolveWaypointMap.
---
--- That helper climbs to the first ancestor map that accepts a user waypoint, which is
--- right everywhere else and catastrophic here: the ancestor of a delve interior is the
--- world outside, so it would point the player calmly out of the cave and look like it
--- was working. `/mh zone` in Gnarldor Isle says the pin is refused on this map — so the
--- arrow we draw ourselves is the whole mechanism, and it must be given the delve's own
--- coordinates untranslated.
local ticker, activeMap, activeQuest

local function StopRoute(silent)
	if ticker then
		ticker:Cancel()
		ticker = nil
	end
	activeMap, activeQuest = nil, nil
	if ns._mhRouteOwner == "delvechest" then
		ns._mhRouteOwner = nil
	end
	if not silent and ns.MH_TomTomClearAll then
		ns.MH_TomTomClearAll()
	end
end
ns.StopDelveChestRoute = StopRoute

local function PointAtNearest(announce)
	local open, mapID, total, unknown, learned = ns.GetOpenDelveChests()
	if not mapID or total == 0 then
		StopRoute()
		return false, "nomap"
	end
	if #open == 0 then
		StopRoute()
		if announce ~= false then
			print(("%s %s"):format(ns:L("PRINT_PREFIX"), ns:L("DELVE_CHEST_ALL_DONE")))
		end
		return false, "done"
	end

	local c = open[1]
	activeMap, activeQuest = mapID, c.quest
	ns._mhRouteOwner = "delvechest"
	-- clearDist 0: keep the arrow on the chest while you fight and loot it, instead of
	-- vanishing the moment you are close. Same reason the treasure route passes 0.
	ns.AddSmartTomTomWay(mapID, c.x, c.y,
		(ns:L("DELVE_CHEST_LABEL")):format(c.index), false, false, false, 0)

	if announce ~= false then
		print(("%s %s"):format(ns:L("PRINT_PREFIX"),
			(ns:L("DELVE_CHEST_ROUTING")):format(total - #open + 1, total)))
		-- Say it out loud when a chest's state is unreadable. The route then walks you
		-- past something you may already have opened, and a player who is not told that
		-- concludes the addon is wrong rather than cautious.
		if unknown > 0 then
			print(("   %s"):format((ns:L("DELVE_CHEST_UNSURE")):format(unknown)))
		end
		-- Say out loud that this list came from watching, not from a checked source.
		-- A learned list has no quest ids at all, so it can never tick anything off —
		-- letting that look identical to the shipped route would be the quiet kind of
		-- wrong this file keeps trying to avoid.
		if learned then
			print(("   %s"):format(ns:L("DELVE_CHEST_LEARNED")))
		end
	end
	return true
end

--- Start (or restart) the chest route for the delve the player is standing in.
function ns.RouteDelveChests()
	StopRoute(true)
	local ok = PointAtNearest(true)
	if not ok then
		return false
	end
	if not (C_Timer and C_Timer.NewTicker) then
		return true -- no ticker: the arrow still points, it just will not advance itself
	end
	ticker = C_Timer.NewTicker(2, function()
		-- Someone else took the arrow (a rare route, a manual waypoint): stand down
		-- rather than fighting over it. Ownership is the addon's existing convention.
		if ns._mhRouteOwner ~= "delvechest" then
			StopRoute(true)
			return
		end
		local _, mapID = ns.GetDelveChestsHere()
		if mapID ~= activeMap then
			StopRoute(true) -- left the delve, or moved to its other floor
			return
		end
		-- Only re-point once the chest we are on is actually flagged done. Re-pointing
		-- on distance would jump to the next chest every time you walked past one.
		if activeQuest and C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
			local okQ, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, activeQuest)
			if okQ and done then
				PointAtNearest(true)
			end
		end
	end)
	return true
end
