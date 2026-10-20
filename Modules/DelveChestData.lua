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
	[2647] = { -- The Labyrinth of Kindo'jan (12.1.5).
		-- 15 Oct 2026 (Rob: "heeft handynotes geen nieuwe dingen als coordinaten?"): HandyNotes_Midnight 157,
		-- zones/labyrinth_of_kindo_jan.lua — 38 "Ancient Chests" (achievement 63717 Kindo'jan's Labyrinth Discoveries),
		-- 31 with a quest flag, including the ones behind the loa seals that no guide placed. Cross-check: their #26
		-- 81.31/55.01 quest 98633 IS our Zygor chest 81.32/55.02 quest 98633, and 17 of our 18 Wowhead/Method chests of
		-- 14 Oct sit on a HandyNotes chest (within ~0.7). Quest ids: HandyNotes alone (see the warning at the top).
		-- Kept from before where HandyNotes has nothing better: Zygor's 98634 at 86.88/63.34 (HandyNotes #36 at
		-- 85.70/62.00 has no quest yet, so it is left out as the same chest) and Method's 21.54/36.48 (no HandyNotes
		-- chest near it). HandyNotes' "-- 2" and "Entrance: 56.93/44.09" remarks are not used.
		-- `seal = N` (15 Oct 2026, mh-research): Labyrinth Journey rank that opens the loa seal in front of the chest
		-- (Akil'zon 3, Jan'alai 5, Nalorakk 7, Halazzi 9). Seal + rank per point GEMETEN in Icy Veins' list of all 44
		-- chests (14 Oct); matching OUR chest to that point is AFGELEID (free chests within 0.35, seal pairs within 1.45;
		-- HandyNotes marks exactly those pairs "-- 2"). #13 GEMETEN at the door by Rob. Rooms: Wowhead guide (Method swaps
		-- the two Nalorakk room names). Flooded Chamber (#3 #11 #12 #14 #25): an ice wall that needs fire, no seal.
		-- 15 Oct, later: HandyNotes 158 filled in every quest id and the five missing sealed chests (end of this list).
		{ x = 46.88, y = 64.38, quest = 97131, room = "Chamber of Rites" },  -- #1
		{ x = 36.96, y = 69.86, quest = 98602, room = "Chamber of Rites" },  -- #2
		{ x = 61.65, y = 44.12, quest = 98604, room = "Flooded Chamber" },  -- #3
		{ x = 38.76, y = 83.42, quest = 98605, seal = 3, room = "Chamber of Rites" },  -- #4 Chamber of Rites, Akil'zon
		{ x = 38.03, y = 83.46, quest = 98606, seal = 3, room = "Chamber of Rites" },  -- #5 Chamber of Rites, Akil'zon
		{ x = 21.77, y = 68.59, quest = 98607, room = "Reliquary" },  -- #6
		{ x = 29.98, y = 74.75, quest = 98608, room = "Reliquary" },  -- #7
		{ x = 13.85, y = 35.11, quest = 98611, room = "Halazzi's Lair" },  -- #8
		{ x = 26.44, y = 40.32, quest = 98612, room = "Halazzi's Lair" },  -- #9
		{ x = 27.48, y = 33.01, quest = 98613, seal = 5, room = "Halazzi's Lair" },  -- #10 Halazzi's Lair, Jan'alai (pair of #13)
		{ x = 61.17, y = 43.48, quest = 98614, room = "Flooded Chamber" },  -- #11
		{ x = 61.53, y = 43.57, quest = 98640, room = "Flooded Chamber" },  -- #12 (HandyNotes 158: 98640; 157 had 98614 twice)
		{ x = 27.94, y = 34.55, quest = 98615, seal = 5, room = "Halazzi's Lair" },  -- #13 behind Jan'alai's seal (GEMETEN, Rob 15 Oct: "does not grant you passage")
		{ x = 61.51, y = 44.72, quest = 98619, room = "Flooded Chamber" },  -- #14
		{ x = 28.69, y = 23.12, quest = 98620, room = "Jan'alai's Refuge" },  -- #15
		{ x = 22.14, y = 29.59, quest = 98621, room = "Jan'alai's Refuge" },  -- #16
		{ x = 22.44, y = 12.04, quest = 98622, seal = 5, room = "Jan'alai's Refuge" },  -- #17 Jan'alai's Refuge, Jan'alai
		{ x = 22.99, y = 11.63, quest = 98623, seal = 5, room = "Jan'alai's Refuge" },  -- #18 Jan'alai's Refuge, Jan'alai
		{ x = 46.09, y = 11.11, quest = 98624, room = "Akil'zon's Roost" },  -- #19
		{ x = 40.58, y = 20.27, quest = 98625, room = "Akil'zon's Roost" },  -- #20
		{ x = 30.56, y = 15.65, quest = 98626, seal = 3, room = "Akil'zon's Roost" },  -- #21 Akil'zon's Roost, Akil'zon
		{ x = 30.48, y = 15.02, quest = 98627, seal = 3, room = "Akil'zon's Roost" },  -- #22 Akil'zon's Roost, Akil'zon
		{ x = 68.24, y = 34.10, quest = 98628, room = "Nalorakk's Rest" },  -- #23
		{ x = 67.89, y = 27.68, quest = 98629, room = "Nalorakk's Rest" },  -- #24
		{ x = 61.16, y = 44.80, quest = 98631, room = "Flooded Chamber" },  -- #25
		{ x = 81.31, y = 55.01, quest = 98633, room = "The Cave Towers" },  -- #26
		{ x = 72.39, y = 65.93, quest = 98637, room = "The Catacombs" },  -- #27
		{ x = 69.25, y = 71.09, quest = 98638, room = "The Catacombs" },  -- #28
		{ x = 40.75, y = 45.41, quest = 98648, room = "Central Chamber" },  -- #29 (underneath the bridge)
		{ x = 47.67, y = 40.01, quest = 98649, room = "Central Chamber" },  -- #30
		{ x = 45.95, y = 48.37, quest = 98650, room = "Central Chamber" },  -- #31
		-- #32-#38: coordinates and quests from HandyNotes 158 (15 Oct 2026, it now gives every chest a quest). Kept in
		-- their old slots so the route's chest numbers do not shift; HandyNotes' own #34/#35 are swapped relative to ours.
		{ x = 65.40, y = 42.60, quest = 98630, seal = 7, room = "Nalorakk's Rest" },  -- #32 Nalorakk's Rest, Nalorakk
		{ x = 64.70, y = 43.10, quest = 98632, seal = 7, room = "Nalorakk's Rest" },  -- #33 Nalorakk's Rest, Nalorakk
		{ x = 66.30, y = 51.80, quest = 98639, seal = 9, room = "The Catacombs" },    -- #34 Catacombs, Halazzi (HN #35)
		{ x = 67.35, y = 51.75, quest = 98641, seal = 9, room = "The Catacombs" },    -- #35 Catacombs, Halazzi (HN #34)
		-- #37/#38: quest ids GEMETEN 15 Oct (Rob looted both behind the Akil'zon seal; questDiff 98636 at 88.6/77.3 and
		-- 98635 at 89.0/77.8). HandyNotes 158 agrees on the same pairing (98636 at 88.50/77.25, 98635 at 89.00/78.00).
		{ x = 88.50, y = 77.25, quest = 98636, seal = 3, room = "The Cave Towers" },  -- #37 The Cave Towers, Akil'zon
		{ x = 89.00, y = 78.00, quest = 98635, seal = 3, room = "The Cave Towers" },  -- #38 The Cave Towers, Akil'zon
		{ x = 86.88, y = 63.34, quest = 98634, room = "The Cave Towers" },  -- Zygor = HandyNotes 158 #36 (86.90/63.30), under water, no seal
		-- Method, Jan'alai's Refuge: NOT a loa seal but a door you click (Method exact, Icy Veins "behind door").
		-- Quest 98603 GEMETEN 15 Oct (Rob looted it; questDiff at 21.5/36.6). Not in HandyNotes 158; HandyNotes 161 has
		-- it at 21.40/36.70 (#19, lower map 2671). Ours stays: Rob's measurement wins.
		{ x = 21.54, y = 36.48, quest = 98603, room = "Jan'alai's Refuge" },
		-- New in HandyNotes 158: the five sealed chests no guide had placed. Seal + room from the Icy Veins list (the
		-- Reliquary pair at ~26.94/80.77 behind Nalorakk, the Halazzi's Lair three at ~10.48/54.68 behind Halazzi);
		-- the match is AFGELEID (within 0.5 of those points). 43 HandyNotes chests + Method's = 44 = achievement 63717.
		{ x = 27.30, y = 81.00, quest = 98609, seal = 7, room = "Reliquary" },        -- HN #39
		{ x = 26.80, y = 81.20, quest = 98610, seal = 7, room = "Reliquary" },        -- HN #40
		{ x = 11.70, y = 54.80, quest = 98616, seal = 9, room = "Halazzi's Lair" },   -- HN #41
		{ x = 9.30,  y = 54.70, quest = 98617, seal = 9, room = "Halazzi's Lair" },   -- HN #42
		{ x = 10.50, y = 55.70, quest = 98618, seal = 9, room = "Halazzi's Lair" },   -- HN #43
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
				-- Fields 2-5 may be anything: 12.1.7 obfuscates the server id of game object GUIDs (see ResetRoutine).
				objectID = tonumber(guid:match("^GameObject%-[^%-]+%-[^%-]+%-[^%-]+%-[^%-]+%-(%d+)"))
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
		if ns._mhDelveChestLootedAt then
			ns._mhDelveChestLootedAt(mapID, px, py)
		end

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
---
--- ✅ VERIFIED 16 aug 2026, and the verification came from a second person. Rob could
--- not test the route advancing because every chest already read as done — the flags are
--- ACCOUNT-WIDE, so once any character has opened a delve's chests, none of his ever
--- sees them again. Carola, who had not, walked the route and it advanced correctly.
---
--- ⚠️ That is worth knowing before anyone "improves" this: for a veteran account the
--- feature is permanently silent, and correctly so. It is for a player seeing a delve
--- for the first time. An empty route on Rob's account is the feature working, not a
--- bug to chase — and MH's own tester could not have found that out alone.
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

	local open, unknown, sealed = {}, 0, 0
	-- `seal = N` on a chest: it sits behind a loa seal that opens at Labyrinth Journey rank N (Akil'zon 3, Jan'alai 5,
	-- Nalorakk 7, Halazzi 9). Below that rank the door says "does not grant you passage" (Rob, 15 Oct), so the chest
	-- is left out. Rank unreadable: keep it, at the back of the line, rather than hide a chest you might reach.
	local journeyRank
	if ns.GetLabyrinthJourneyStatus then
		local st = ns.GetLabyrinthJourneyStatus()
		journeyRank = st and st.rank or nil
	end
	local visited = ns._mhDelveChestVisited
	visited = visited and visited.mapID == mapID and visited or nil
	local skipped = ns._mhDelveChestSkipped
	skipped = skipped and skipped.mapID == mapID and skipped or nil
	-- The room you stand in (the minimap's subzone text, "Chamber of Rites", "Central Chamber" - GEMETEN in Rob's video
	-- 15 Oct). The Labyrinth only opens the rooms a run picks, so a chest in THIS room is one you can certainly reach.
	-- English names only: on another client language no chest matches and the route stays nearest-first.
	local here
	if GetSubZoneText then
		local okZ, z = pcall(GetSubZoneText)
		if okZ and type(z) == "string" and z ~= "" and not (issecretvalue and issecretvalue(z)) then
			here = z
		end
	end
	-- "The Catacombs" on the minimap, "Catacombs" in the guides (Rob, 15 Oct): compare without a leading "The ".
	local function Norm(s)
		return type(s) == "string" and s:gsub("^[Tt]he ", ""):lower() or nil
	end
	local hereShown = here -- as the minimap writes it, for the chat line
	here = Norm(here)
	local knownRoom = false
	for i = 1, #chests do
		if here and Norm(chests[i].room) == here then
			knownRoom = true
			break
		end
	end
	for i = 1, #chests do
		local c = chests[i]
		local done = ns.IsDelveChestDone(c)
		if done == nil then
			unknown = unknown + 1
		end
		-- A chest with no quest flag can never read as done, so the route would sit on the nearest one forever
		-- (the Labyrinth, 14 Oct: 18 of its 20 chests have no id). One you looted this visit counts as done
		-- (ns._mhDelveChestLootedAt, below).
		if done == nil and visited and visited[i] then
			done = true
		end
		local locked = c.seal and journeyRank and journeyRank < c.seal
		if done ~= true and locked then
			sealed = sealed + 1
		elseif done ~= true then
			local d
			if px then
				local dx, dy = c.x - px, c.y - py
				d = dx * dx + dy * dy -- squared: we only ever compare these
			end
			open[#open + 1] = { x = c.x, y = c.y, quest = c.quest, index = i, dist = d, room = c.room,
				inRoom = knownRoom and Norm(c.room) == here or nil,
				-- Rob's run, 19 Oct 2026 (videos B-D): the arrow sat on Flooded Chamber chests for ~40 minutes; that room
				-- is behind an ice wall that needs the Fiery Hexmask. Its chests now come after every other open chest.
				flooded = c.room == "Flooded Chamber" or nil,
				skipped = (skipped and skipped[i]) or (c.seal and not journeyRank) or nil }
		end
	end
	table.sort(open, function(a, b)
		-- A chest you skipped (behind a door this run did not open, Rob 15 Oct) goes to the back of the line,
		-- not off the list: it is still unopened, and once everything else is done it is the only way left.
		if (a.skipped and true or false) ~= (b.skipped and true or false) then
			return not a.skipped
		end
		local af, bf = (a.flooded and not a.inRoom) and true or false, (b.flooded and not b.inRoom) and true or false
		if af ~= bf then
			return bf
		end
		if (a.inRoom and true or false) ~= (b.inRoom and true or false) then
			return a.inRoom and true or false
		end
		if a.dist and b.dist then
			return a.dist < b.dist
		end
		-- No player position (loading screen): keep the delve's own order rather than
		-- inventing one.
		return a.index < b.index
	end)
	return open, mapID, #chests - sealed, unknown, learned, sealed, knownRoom and hereShown or nil
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
local ticker, activeMap, activeQuest, activeIndex
local lastRoomSeen -- subzone text at the last tick, to notice walking into another room
local chestLead -- what the route runner points at (Travel phase 4): the chest this module picked
local floodedLeg -- "entrance" while the arrow points at the Flooded Chamber's underwater entrance (see FLOODED_ENTRANCE)

--- 🚌 Travel phase 4 (16 Oct 2026): the ROUTE RUNNER points (Modules/Travel/TravelRoute.lua), as a `direct` route
--- (only the chest, no travel plan: planning from inside a delve means nothing). This module still decides WHICH chest
--- (the 2 s ticker below: a chest flagged done, a room walked into, a skip) and tells the runner (Travel.Refresh).
--- No owner writes here any more.

--- Forget the route (the runner's onStop, or a restart). No call back into Travel.
local function Forget()
	if ticker then
		ticker:Cancel()
		ticker = nil
	end
	activeMap, activeQuest, activeIndex, chestLead, floodedLeg = nil, nil, nil, nil, nil
end

--- Stop the chest route: forget it and take it out of the runner (a paused route goes on). `silent` keeps the other
--- TomTom pins (left the delve, a restart).
local function StopRoute(silent)
	Forget()
	if ns.Travel and ns.Travel.Has and ns.Travel.Has("delvechest") then
		ns.Travel.Drop("delvechest", "chests stopped")
	end
	if not silent and ns.MH_TomTomClearAll then
		ns.MH_TomTomClearAll()
	end
end
ns.StopDelveChestRoute = StopRoute

local function ChestNextLead(ctx)
	if ctx and ctx.zone then
		local _, mapID = ns.GetDelveChestsHere()
		if mapID ~= activeMap then
			return nil -- left the delve, or moved to its other floor
		end
	end
	return chestLead
end

--- The Flooded Chamber's way in (Rob, 20 Oct 2026: "zet de ingang onder water in de kistenroute"). HandyNotes_Midnight
--- (labyrinth_of_kindo_jan.lua, node 56934409 "Underwater Entrance": inside is npc 270937, "broken with the Fiery Hexmask
--- or fire spells") — GEMETEN in that file, not yet walked by us. Its five chests sit around 61.5/44, and the map draws
--- no room there, so the arrow goes to this entrance first and to the chest once you are at it or past it.
local FLOODED_ENTRANCE = { mapID = 2647, x = 56.93, y = 44.09 }

local function PlayerXY(mapID)
	if not (C_Map and C_Map.GetPlayerMapPosition) then
		return nil
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
	if not ok or not pos or not pos.GetXY then
		return nil
	end
	local x, y = pos:GetXY()
	if not x or (issecretvalue and issecretvalue(x)) then
		return nil
	end
	return x * 100, y * 100
end

--- At the entrance (within about 1 map unit) or already near the chests: the chest itself is the next stop.
local function PastFloodedEntrance(mapID, c)
	local px, py = PlayerXY(mapID)
	if not px then
		return false -- position unreadable: keep pointing at the entrance, the safe way in
	end
	local function d(ax, ay, bx, by)
		return math.sqrt((ax - bx) ^ 2 + (ay - by) ^ 2)
	end
	return d(px, py, FLOODED_ENTRANCE.x, FLOODED_ENTRANCE.y) < 1.0 or d(px, py, c.x, c.y) < 3.0
end

local function PointAtNearest(announce)
	local open, mapID, total, unknown, learned, sealed, hereRoom = ns.GetOpenDelveChests()
	sealed = sealed or 0
	if not mapID or (total == 0 and sealed == 0) then
		StopRoute()
		return false, "nomap"
	end
	local sealedLine = sealed > 0 and (ns:L("DELVE_CHEST_SEALED")):format(sealed) or nil
	if #open == 0 then
		StopRoute()
		if announce ~= false then
			local msg = sealedLine or ns:L("DELVE_CHEST_ALL_DONE")
			if ns.ShowBriefNotice then
				ns.ShowBriefNotice(msg, 5)
			end
			print(("%s %s"):format(ns:L("PRINT_PREFIX"), msg))
		end
		return false, "done"
	end

	local c = open[1]
	activeMap, activeQuest = mapID, c.quest
	activeIndex = c.index
	-- clearDist 0: keep the arrow on the chest while you fight and loot it, instead of
	-- vanishing the moment you are close. Same reason the treasure route passes 0.
	chestLead = { mapID = mapID, x = c.x, y = c.y, name = (ns:L("DELVE_CHEST_LABEL")):format(c.index), clearDist = 0 }
	floodedLeg = nil
	if c.flooded and not c.inRoom and mapID == FLOODED_ENTRANCE.mapID and not PastFloodedEntrance(mapID, c) then
		floodedLeg = "entrance"
		chestLead = { mapID = mapID, x = FLOODED_ENTRANCE.x, y = FLOODED_ENTRANCE.y,
			name = ns:L("DELVE_CHEST_FLOODED_ENTRANCE"), clearDist = 0 }
	end
	if ns.Travel and ns.Travel.Runs and ns.Travel.Runs("delvechest") then
		ns.Travel.Refresh("delvechest", { quiet = true })
	elseif not (ns.Travel and ns.Travel.StartManaged and ns.Travel.StartManaged({
		owner = "delvechest",
		direct = true,
		nextLead = ChestNextLead,
		onStop = Forget,
		via = "delve chests",
	})) then
		Forget()
		return false, "noroute"
	end

	if announce ~= false then
		local headline = (ns:L("DELVE_CHEST_ROUTING")):format(total - #open + 1, total)
		-- On screen AND in chat. The notice answers "did my click work" where the eyes
		-- already are; the chat line stays because it is the one you can scroll back to
		-- when the notice has gone. Rob, 16 aug: he only spotted the chat line because
		-- he asked for the feature.
		-- The Flooded Chamber is not a room this run "may not open": it is behind an ice wall, and the map draws no room
		-- there (Rob's world map, 19 Oct 09:48). Say that on screen, where the arrow is, not only in chat.
		local floodedLine = (c.flooded and not c.inRoom) and ns:L("DELVE_CHEST_FLOODED_HINT") or nil
		if ns.ShowBriefNotice then
			ns.ShowBriefNotice(headline .. "|n" .. (floodedLine or ns:L("DELVE_CHEST_SKIP_HINT")), floodedLine and 9 or 6)
		end
		print(("%s %s"):format(ns:L("PRINT_PREFIX"), headline))
		print(("   %s"):format(ns:L("DELVE_CHEST_SKIP_HINT")))
		if sealedLine then
			print(("   %s"):format(sealedLine))
		end
		if floodedLine then
			print(("   %s"):format(floodedLine))
		-- You stand in a room we know, and its chests are all done: say so, because the next one sits in a room this
		-- run may not open (Rob, 15 Oct, in the Catacombs: the arrow sent him to the Cave Towers' water chest).
		elseif hereRoom and not c.inRoom then
			print(("   %s"):format((ns:L("DELVE_CHEST_ROOM_DONE")):format(hereRoom, c.room or "?")))
		end
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
--- Clicking again while the route already points at a chest here SKIPS that chest: the nearest chest in a
--- straight line can sit behind a sealed door (the Labyrinth only opens the rooms a run picks; Rob, 15 Oct:
--- "hij stuurt me ergens naartoe waar ik niet heen kon"). We have no room-per-chest data to avoid it ourselves,
--- so the player decides; the skip lasts until the next zone-in, like the looted list below.
function ns.RouteDelveChests()
	local _, hereMap = ns.GetDelveChestsHere()
	local runs = ns.Travel and ns.Travel.Runs and ns.Travel.Runs("delvechest")
	if ticker and runs and activeIndex and hereMap and hereMap == activeMap then
		local s = ns._mhDelveChestSkipped
		if not (s and s.mapID == activeMap) then
			s = { mapID = activeMap }
			ns._mhDelveChestSkipped = s
		end
		s[activeIndex] = true
		-- 🔴 Rob's run, 19 Oct 2026 (video D, 10:19:36-10:20:05): his last five chests were all in the Flooded Chamber,
		-- he skipped all five, and every further click said "Skipped Sturdy Chest 11 — it comes back last" for ever.
		-- When nothing un-skipped is left, stop and say why; the next click starts the round again.
		local left = ns.GetOpenDelveChests()
		local allSkipped, flooded = #left > 0, #left > 0
		for _, o in ipairs(left) do
			if not o.skipped then
				allSkipped = false
			end
			if o.room ~= "Flooded Chamber" then
				flooded = false
			end
		end
		if allSkipped then
			ns._mhDelveChestSkipped = nil
			StopRoute()
			local msg = (ns:L(flooded and "DELVE_CHEST_ALL_SKIPPED_FLOODED" or "DELVE_CHEST_ALL_SKIPPED")):format(#left)
			if ns.ShowBriefNotice then
				ns.ShowBriefNotice(msg, 8)
			end
			print(("%s %s"):format(ns:L("PRINT_PREFIX"), msg))
			return true
		end
		print(("%s %s"):format(ns:L("PRINT_PREFIX"), (ns:L("DELVE_CHEST_SKIPPED")):format(activeIndex)))
		PointAtNearest(true)
		return true
	end
	Forget() -- a restart: the runner replaces the old route itself (same owner)
	local ok = PointAtNearest(true)
	if not ok then
		return false
	end
	if not (C_Timer and C_Timer.NewTicker) then
		return true -- no ticker: the arrow still points, it just will not advance itself
	end
	ticker = C_Timer.NewTicker(2, function()
		-- The route ended or was replaced (the runner told us via Forget, which cancels this ticker), or it is paused
		-- under another route: nothing to do now.
		if not (ns.Travel and ns.Travel.Runs and ns.Travel.Runs("delvechest")) then
			if not (ns.Travel and ns.Travel.Has and ns.Travel.Has("delvechest")) then
				Forget()
			end
			return
		end
		local _, mapID = ns.GetDelveChestsHere()
		if mapID ~= activeMap then
			StopRoute(true) -- left the delve, or moved to its other floor
			return
		end
		-- Walked into another room that still has a chest: point there, it is reachable for sure.
		local okZ, z = pcall(GetSubZoneText)
		if okZ and type(z) == "string" and not (issecretvalue and issecretvalue(z)) and z ~= lastRoomSeen then
			lastRoomSeen = z
			local open = ns.GetOpenDelveChests()
			if open[1] and open[1].inRoom and open[1].index ~= activeIndex then
				PointAtNearest(true)
				return
			end
		end
		-- On the way to the underwater entrance: once you are at it (or past it), point at the chest itself.
		if floodedLeg == "entrance" then
			local open = ns.GetOpenDelveChests()
			if open[1] and PastFloodedEntrance(activeMap, open[1]) then
				PointAtNearest(false)
				if ns.ShowBriefNotice then
					ns.ShowBriefNotice(ns:L("DELVE_CHEST_FLOODED_INSIDE"), 7)
				end
				print(("%s %s"):format(ns:L("PRINT_PREFIX"), ns:L("DELVE_CHEST_FLOODED_INSIDE")))
				return
			end
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

--- A chest with no quest flag is ticked off when you loot a game object next to it (the LOOT_OPENED watcher
--- above calls this). Kept for this visit only: PLAYER_ENTERING_WORLD (every zone-in, so every new run) clears it.
function ns._mhDelveChestLootedAt(mapID, px, py)
	local chests = ns.DELVE_CHESTS[mapID]
	if not chests then
		return
	end
	local v = ns._mhDelveChestVisited
	if not (v and v.mapID == mapID) then
		v = { mapID = mapID }
		ns._mhDelveChestVisited = v
	end
	local hitActive = false
	for i, c in ipairs(chests) do
		if not c.quest and math.abs(c.x - px) < 3 and math.abs(c.y - py) < 3 then
			v[i] = true
			if activeMap == mapID and activeIndex == i then
				hitActive = true
			end
		end
	end
	if hitActive and ns._mhRouteOwner == "delvechest" then
		PointAtNearest(true)
	end
end

do
	local resetter = CreateFrame("Frame")
	resetter:RegisterEvent("PLAYER_ENTERING_WORLD")
	resetter:SetScript("OnEvent", function()
		ns._mhDelveChestVisited = nil
		ns._mhDelveChestSkipped = nil
	end)
end
