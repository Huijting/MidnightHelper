local _, ns = ...

--[[
	ForeverQuestieDB.lua — WoW Forever: MEASURE whether MH can read QuestieDB while you play, before anything uses it.
	Rob, 23 Nov 2026 via Sparring 23-11, verbatim: "quest a", then "Ik volg jullie advies." (= measure A first, fill gaps
	B only after this measurement; docs/forever/QUESTIEDB_LIVE_2026-11-23.md).

	Part A (this probe) changes nothing in the game and draws nothing; its commands are ours (lint [16]/[27]: unlisted,
	dev only). Part B (below, "B: read it while you play") is what players see: lines that say (QuestieDB).
	🔴 MH ships NO QuestieDB data: nothing from it is written to an MH file. It is read in the game, only when the player
	has QuestieDB enabled. What this probe keeps in ns.db.questieDbProbe is ours: counts, milliseconds, kilobytes, and
	DISTANCES between QuestieDB's spawn points and MH's own trainer places. Never its coordinates, names or quest data.

	/mh questiedb       = is it there, does its contract fit, how long 50 reads take (cold and warm), its memory, and
	                      how far its NPC spawns lie from MH's own trainer places (Rob-measured ones listed apart).
	                      Distances raw and after LibQuestieDB.EraToForever: that tells whether its points are Era or
	                      Forever map space (the open question in the research doc).
	/mh questiedb here  = target an NPC and stand next to it: the distance from you to that NPC's nearest QuestieDB spawn.
	/mh questiedb why   = part B: on or off, its last decision and why, and the finished quests it sees with a place.
	Silent on purpose in combat, and says why whenever it reads nothing.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local CONTRACT = 4 -- the contract the research doc read (## X-Contract-Version: 4, QuestieDB 1.1.4)
local READS = 50
local RUNS = 10
local CLOSE = 1.0 -- map percent; MH's own Wowhead/Zygor trainer rows agreed within 2 units (ForeverTrainerSpots.lua)

local function Readable(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

local function Now()
	return debugprofilestop and debugprofilestop() or 0
end

-- Where the addon stands: "loaded", "installed, not loaded" (with the client's reason) or "not installed".
local function AddonState()
	local A = C_AddOns or {}
	local isLoaded = A.IsAddOnLoaded or IsAddOnLoaded
	if isLoaded then
		local ok, yes = pcall(isLoaded, "QuestieDB")
		if ok and yes then
			return "loaded"
		end
	end
	local info = A.GetAddOnInfo or GetAddOnInfo
	if info then
		local ok, name, _, _, _, reason = pcall(info, "QuestieDB")
		if ok and name then
			if reason == "MISSING" then
				return "not installed"
			end
			return "installed, not loaded" .. (reason and reason ~= "" and (" (" .. tostring(reason) .. ")") or "")
		end
	end
	return "not installed"
end

local function Lib()
	local L = rawget(_G, "LibQuestieDB")
	if type(L) ~= "table" then
		return nil, "LibQuestieDB is not there: QuestieDB " .. AddonState()
	end
	if type(L.RequireContract) ~= "function" then
		return nil, "LibQuestieDB has no RequireContract: a version MH does not know"
	end
	local ok, fits, msg = pcall(L.RequireContract, CONTRACT)
	if not ok then
		return nil, "RequireContract failed: " .. tostring(fits)
	end
	if not fits then
		return nil, tostring(msg or "contract does not fit")
	end
	if type(L.Quest) ~= "table" or type(L.Npc) ~= "table" then
		return nil, "no Quest/Npc readers in LibQuestieDB"
	end
	return L
end

-- 50 evenly spread ids, the same list for the cold and the warm round.
local function Spread(entity)
	local ok, ids = pcall(entity.GetAllIds)
	if not ok or type(ids) ~= "table" then
		return {}, 0
	end
	local n = #ids
	local pick, step = {}, math.max(1, math.floor(n / READS))
	for i = 1, n, step do
		pick[#pick + 1] = ids[i]
		if #pick >= READS then
			break
		end
	end
	return pick, n
end

local function TimeReads(entity, ids, fields)
	local errors, empty = 0, 0
	local t0 = Now()
	for _, id in ipairs(ids) do
		for _, f in ipairs(fields) do
			local ok, v = pcall(entity.Get, id, f)
			if not ok then
				errors = errors + 1
			elseif v == nil then
				empty = empty + 1
			end
		end
	end
	return Now() - t0, errors, empty
end

-- QuestieDB's own zone tables (strings that return a table, in its Support data), read once per probe.
local function AreaToUiMap(L)
	local out = {}
	local zdb = L.Support and L.Support.Get and L.Support.Get("ZoneDB")
	local private = type(zdb) == "table" and zdb.private
	if type(private) ~= "table" then
		return out, "no ZoneDB support data"
	end
	for _, key in ipairs({ "areaIdToUiMapId", "areaIdToUiMapIdOverride" }) do -- override last, so it wins
		local src = private[key]
		local compile = loadstring or load
		if type(src) == "string" and compile then
			local fn = compile(src)
			local ok, t = false, nil
			if fn then
				ok, t = pcall(fn)
			end
			if ok and type(t) == "table" then
				for area, map in pairs(t) do
					out[area] = map
				end
			end
		elseif type(src) == "table" then
			for area, map in pairs(src) do
				out[area] = map
			end
		end
	end
	return out
end

-- Nearest spawn of `npc` on uiMap `map` to (x, y): raw, and after EraToForever. nil = not in its data / not on that map.
local function Nearest(L, areaMap, npc, map, x, y)
	local ok, spawns = pcall(L.Npc.Get, npc, "spawns")
	if not ok then
		return "error"
	end
	if type(spawns) ~= "table" then
		return "not in QuestieDB"
	end
	local raw, conv
	for area, points in pairs(spawns) do
		if areaMap[area] == map and type(points) == "table" then
			for _, pt in ipairs(points) do
				local px, py = pt[1], pt[2]
				if type(px) == "number" and type(py) == "number" and px >= 0 and py >= 0 then
					local d = math.sqrt((px - x) ^ 2 + (py - y) ^ 2)
					raw = (not raw or d < raw) and d or raw
					if L.EraToForever then
						local okc, cx, cy = pcall(L.EraToForever, area, px, py)
						if okc and type(cx) == "number" then
							local dc = math.sqrt((cx - x) ^ 2 + (cy - y) ^ 2)
							conv = (not conv or dc < conv) and dc or conv
						end
					end
				end
			end
		end
	end
	if not raw then
		return "not on this map"
	end
	return "ok", raw, conv
end

local function Round(v)
	return v and math.floor(v * 100 + 0.5) / 100 or nil
end

local function Median(list)
	if #list == 0 then
		return nil
	end
	table.sort(list)
	return list[math.floor((#list + 1) / 2)]
end

local function SaveRun(run)
	ns.db = ns.db or {}
	local runs = type(ns.db.questieDbProbe) == "table" and ns.db.questieDbProbe or {}
	ns.db.questieDbProbe = runs
	runs[#runs + 1] = run
	while #runs > RUNS do
		table.remove(runs, 1)
	end
end

local function NewRun(kind)
	local A = C_AddOns or {}
	local meta = A.GetAddOnMetadata or GetAddOnMetadata
	local version
	if meta then
		local ok, v = pcall(meta, "QuestieDB", "Version")
		version = ok and v or nil
	end
	return { kind = kind, at = time and time() or 0, build = GetBuildInfo and select(2, GetBuildInfo()),
		state = AddonState(), version = version }
end

local function Probe()
	local run = NewRun("probe")
	local L, why = Lib()
	if not L then
		run.why = why
		SaveRun(run)
		print(PREFIX .. "QuestieDB test: nothing read. " .. why .. ".")
		if run.state ~= "loaded" then
			print("  Enable QuestieDB at character select (AddOns), restart, then /mh questiedb again.")
		end
		return
	end
	run.contract, run.mode = L.contractVersion, L.readMode

	local qids, nq = Spread(L.Quest)
	local nids, nn = Spread(L.Npc)
	run.quests, run.npcs = nq, nn
	local qf, nf = { "name", "startedBy", "finishedBy" }, { "name", "spawns" }
	local cq, eq1, mq1 = TimeReads(L.Quest, qids, qf)
	local wq, eq2 = TimeReads(L.Quest, qids, qf)
	local cn, en1, mn1 = TimeReads(L.Npc, nids, nf)
	local wn, en2 = TimeReads(L.Npc, nids, nf)
	run.ms = { questCold = Round(cq), questWarm = Round(wq), npcCold = Round(cn), npcWarm = Round(wn) }
	run.reads = { quests = #qids, npcs = #nids, errors = eq1 + eq2 + en1 + en2, empty = mq1 + mn1 }

	local upd = UpdateAddOnMemoryUsage
	local mem = (C_AddOns and C_AddOns.GetAddOnMemoryUsage) or GetAddOnMemoryUsage
	if upd and mem then
		pcall(upd)
		local ok, kb = pcall(mem, "QuestieDB")
		run.memKB = ok and Round(kb) or nil
	end

	-- MH's own trainer places (ForeverTrainerSpots.lua) against its spawns, per map; Rob's measured ones apart.
	local areaMap, zwhy = AreaToUiMap(L)
	run.zoneNote = zwhy
	run.spots, run.byMap = {}, {}
	local byMap = {}
	local counts = { ok = 0, ["not in QuestieDB"] = 0, ["not on this map"] = 0, error = 0 }
	for _, list in pairs(ns.FOREVER_TRAINER_SPOTS or {}) do
		for _, s in ipairs(list) do
			if s.npc and s.map and s.x and s.y then
				local res, raw, conv = Nearest(L, areaMap, s.npc, s.map, s.x, s.y)
				counts[res] = (counts[res] or 0) + 1
				if res == "ok" then
					local m = byMap[s.map] or { raw = {}, conv = {} }
					byMap[s.map] = m
					m.raw[#m.raw + 1] = raw
					m.conv[#m.conv + 1] = conv or raw
				end
				if s.measured then
					run.spots[#run.spots + 1] = { npc = s.npc, map = s.map, result = res, raw = Round(raw), conv = Round(conv) }
				end
			end
		end
	end
	run.trainerResults = counts
	for map, m in pairs(byMap) do
		run.byMap[map] = { n = #m.raw, rawMedian = Round(Median(m.raw)), convMedian = Round(Median(m.conv)) }
	end
	SaveRun(run)

	print(PREFIX .. ("QuestieDB test: %s, version %s, contract %s (MH needs %d), mode %s."):format(run.state,
		tostring(run.version), tostring(run.contract), CONTRACT, tostring(run.mode)))
	print(("  %d quests, %d NPCs. %d+%d reads: quests %.1f ms cold, %.1f ms warm; NPCs %.1f ms cold, %.1f ms warm. %d errors."):format(
		nq, nn, #qids * #qf, #nids * #nf, cq, wq, cn, wn, run.reads.errors))
	print(("  Memory of QuestieDB: %s KB."):format(run.memKB and tostring(run.memKB) or "unreadable"))
	print(("  MH's trainer places: %d compared, %d not in QuestieDB, %d not on that map%s."):format(counts.ok,
		counts["not in QuestieDB"], counts["not on this map"], (counts.error > 0) and (", " .. counts.error .. " errors") or ""))
	local maps = {}
	for map in pairs(run.byMap) do
		maps[#maps + 1] = map
	end
	table.sort(maps)
	for _, map in ipairs(maps) do
		local b = run.byMap[map]
		local differs = b.convMedian and b.rawMedian and math.abs(b.convMedian - b.rawMedian) >= 0.05
		print(("  map %d: %d trainers, median %.2f%s"):format(map, b.n, b.rawMedian or -1,
			differs and (" (after Era->Forever %.2f)"):format(b.convMedian) or ""))
	end
	for _, s in ipairs(run.spots) do
		print(("  Rob measured, NPC %d on map %d: %s%s"):format(s.npc, s.map, s.result,
			s.raw and (", %.2f away%s"):format(s.raw, s.conv and s.conv ~= s.raw and (" (after Era->Forever %.2f)"):format(s.conv) or "") or ""))
	end
	print(("  Close = under %.1f. Done. /reload writes it to MidnightHelperDB.questieDbProbe."):format(CLOSE))
end

-- Stand next to a targeted NPC: how far is its nearest QuestieDB spawn from you?
local function Here()
	local run = NewRun("here")
	local L, why = Lib()
	if not L then
		run.why = why
		SaveRun(run)
		print(PREFIX .. "QuestieDB here: nothing read. " .. why .. ".")
		return
	end
	local guid = UnitGUID and UnitGUID("target")
	if not Readable(guid) or type(guid) ~= "string" then
		print(PREFIX .. "QuestieDB here: target an NPC first and stand next to it.")
		return
	end
	local kind, _, _, _, _, id = strsplit("-", guid)
	local npc = tonumber(id)
	if kind ~= "Creature" or not npc then
		print(PREFIX .. "QuestieDB here: your target is not an NPC.")
		return
	end
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	local pos = map and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(map, "player")
	if not pos then
		print(PREFIX .. "QuestieDB here: MH cannot read your own position here (instance?).")
		return
	end
	local px, py = pos:GetXY()
	px, py = px * 100, py * 100
	local areaMap = AreaToUiMap(L)
	local res, raw, conv = Nearest(L, areaMap, npc, map, px, py)
	run.npc, run.map, run.result, run.raw, run.conv = npc, map, res, Round(raw), Round(conv)
	SaveRun(run)
	print(PREFIX .. ("QuestieDB here: NPC %d on map %d: %s%s."):format(npc, map, res,
		raw and (", nearest spawn %.2f away%s"):format(raw, conv and math.abs(conv - raw) >= 0.05 and
			(" (after Era->Forever %.2f)"):format(conv) or "") or ""))
	print(("  Close = under %.1f. /reload writes it to MidnightHelperDB.questieDbProbe."):format(CLOSE))
end

--------------------------------------------------------------------------------
-- B: read it while you play (Rob, 23 Nov 2026 via sparring: "Ik volg jullie advies weer. En het voelde niet trager bij
-- het inloggen, dus dat scheelt."). Measured in A: its spawns already sit in Forever map space (Era->Forever made
-- Stormwind 0.22 -> 14.77), so NOTHING here converts. MH's own data always wins; this only fills gaps:
--   1. who to turn a finished quest in to (Do this now + overview, "Turn in" button = the arrow);
--   2. a giver's place in the dungeon quest list when MH's data has none (ForeverDungeonQuests.lua);
--   3. the last step of the trainer row in the class quests (ForeverClassQuests.lua LivePlace).
-- Switch: Settings "Use QuestieDB if you have it" (mh_foreverQuestieDb), on by default; it does nothing without
-- QuestieDB. Every read in pcall; nothing in combat. What it decided last: /mh questiedb why.
--------------------------------------------------------------------------------
local lastWhy = "not asked yet"
local areaCache

function ns.IsForeverQuestieDBOn()
	return not (type(ns.db) == "table" and ns.db.foreverQuestieDb == false)
end

function ns.SetForeverQuestieDB(v)
	ns.db = ns.db or {}
	if v then
		ns.db.foreverQuestieDb = nil -- on = the default
	else
		ns.db.foreverQuestieDb = false
	end
	if ns.ForeverDoNowUpdate then
		pcall(ns.ForeverDoNowUpdate)
	end
end

--- LibQuestieDB when it may be read now, else nil (and lastWhy says why).
local function Live()
	if not ns.IsForeverQuestieDBOn() then
		lastWhy = "switched off in the settings"
		return nil
	end
	if InCombatLockdown and InCombatLockdown() then
		lastWhy = "in combat"
		return nil
	end
	local L, why = Lib()
	if not L then
		lastWhy = why
		return nil
	end
	if not areaCache then
		areaCache = AreaToUiMap(L)
	end
	return L
end

local function PlayerPos()
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	local pos = map and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(map, "player")
	if not pos then
		return map
	end
	local x, y = pos:GetXY()
	return map, x * 100, y * 100
end

--- MH's own place for an NPC, if it has one (trainer spots, dungeon quest givers): that one wins.
local function OwnPlace(npc)
	for _, list in pairs(ns.FOREVER_TRAINER_SPOTS or {}) do
		for _, s in ipairs(list) do
			if s.npc == npc and s.map and s.x and s.y then
				return s.map, s.x, s.y
			end
		end
	end
	for _, list in pairs(ns.FOREVER_DUNGEON_QUESTS or {}) do
		for _, e in ipairs(list) do
			if e.npc == npc and e.m and e.x and e.y and e.x > 0 and e.x < 100 and e.y > 0 and e.y < 100 then
				return e.m, e.x, e.y
			end
		end
	end
end

--- Where QuestieDB puts an NPC: on `prefer` map first, then the map you stand on (nearest spawn), then any map.
local function NpcSpot(L, npc, prefer)
	local ok, spawns = pcall(L.Npc.Get, npc, "spawns")
	if not ok or type(spawns) ~= "table" then
		return nil
	end
	local pmap, px, py = PlayerPos()
	local best, bestScore
	for area, points in pairs(spawns) do
		local m = areaCache and areaCache[area]
		if m and type(points) == "table" then
			for _, pt in ipairs(points) do
				local x, y = pt[1], pt[2]
				if type(x) == "number" and type(y) == "number" and x > 0 and x < 100 and y > 0 and y < 100 then
					local score = 3
					if prefer and m == prefer then
						score = 0
					elseif m == pmap then
						score = 1 + (px and math.sqrt((x - px) ^ 2 + (y - py) ^ 2) / 1000 or 0)
					end
					if not bestScore or score < bestScore then
						best, bestScore = { m = m, x = x, y = y }, score
					end
				end
			end
		end
	end
	return best
end

local function NpcNameOf(L, npc)
	local ok, nm = pcall(L.Npc.Get, npc, "name")
	return ok and type(nm) == "string" and nm ~= "" and nm or ("#" .. tostring(npc))
end

--- A place for an NPC MH has none for: m, x, y, name, "QuestieDB". nil when MH has its own, or QuestieDB has none.
function ns.ForeverQuestieNpcPlace(npc, prefer)
	if type(npc) ~= "number" then
		return nil
	end
	if OwnPlace(npc) then
		lastWhy = ("NPC %d: MH has its own place"):format(npc)
		return nil
	end
	local L = Live()
	if not L then
		return nil
	end
	local s = NpcSpot(L, npc, prefer)
	if not s then
		lastWhy = ("NPC %d: no place in QuestieDB on a known map"):format(npc)
		return nil
	end
	lastWhy = ("NPC %d: QuestieDB map %d"):format(npc, s.m)
	return s.m, s.x, s.y, NpcNameOf(L, npc), "QuestieDB"
end

--- True when QuestieDB knows this NPC only inside an instance: every spawn is its (-1, -1) "inside" mark. GEMETEN 23 Nov
--- 2026 on Vorrel Sengutz (3981, Scarlet Monastery): that is how it stores a giver who stands in the dungeon, so there is
--- no place for an arrow, but the row can say "inside". nil when MH has its own place or QuestieDB cannot be read.
function ns.ForeverQuestieNpcInside(npc)
	if type(npc) ~= "number" or OwnPlace(npc) then
		return nil
	end
	local L = Live()
	if not L then
		return nil
	end
	local ok, spawns = pcall(L.Npc.Get, npc, "spawns")
	if not ok or type(spawns) ~= "table" then
		return nil
	end
	local seen = false
	for _, points in pairs(spawns) do
		for _, pt in ipairs(type(points) == "table" and points or {}) do
			if pt[1] ~= -1 or pt[2] ~= -1 then
				return nil
			end
			seen = true
		end
	end
	if seen then
		lastWhy = ("NPC %d: QuestieDB has him only inside an instance"):format(npc)
	end
	return seen or nil
end

local function ZoneName(id)
	if C_Map and C_Map.GetMapInfo then
		local ok, info = pcall(C_Map.GetMapInfo, id)
		if ok and info and info.name then
			return info.name
		end
	end
	return "#" .. tostring(id)
end

--- Finished quests in your log, with who takes them (MH's own place for that NPC first). Nearest first.
local function TurnIns()
	local L = Live()
	local Q = C_QuestLog
	if not (L and Q and Q.GetNumQuestLogEntries and Q.GetInfo and Q.IsComplete) then
		return {}
	end
	local pmap, px, py = PlayerPos()
	local out = {}
	local okN, n = pcall(Q.GetNumQuestLogEntries)
	for i = 1, (okN and n or 0) do
		local okI, info = pcall(Q.GetInfo, i)
		local q = okI and type(info) == "table" and not info.isHeader and info.questID
		if q and q > 0 then
			local okC, done = pcall(Q.IsComplete, q)
			if okC and done then
				local okF, fin = pcall(L.Quest.Get, q, "finishedBy")
				for _, npc in ipairs(okF and type(fin) == "table" and type(fin[1]) == "table" and fin[1] or {}) do
					local m, x, y = OwnPlace(npc)
					local src = "MH"
					if not m then
						local s = NpcSpot(L, npc)
						if s then
							m, x, y, src = s.m, s.x, s.y, "QuestieDB"
						end
					end
					if m then
						local d = (m == pmap and px) and math.sqrt((x - px) ^ 2 + (y - py) ^ 2) or (1000 + #out)
						out[#out + 1] = { q = q, title = info.title or ("#" .. q), npc = npc, who = NpcNameOf(L, npc),
							m = m, x = x, y = y, src = src, d = d }
						break
					end
				end
			end
		end
	end
	table.sort(out, function(a, b) return a.d < b.d end)
	lastWhy = ("%d finished quest(s) with a place to turn in"):format(#out)
	return out
end

--- One line for Do this now / the overview, or nil.
function ns.ForeverQuestieTurnInLine()
	local list = TurnIns()
	local t = list[1]
	if not t then
		return nil
	end
	if #list == 1 then
		return ns:L("FQDB_TURNIN_FMT"):format(t.title, t.who, ZoneName(t.m))
	end
	return ns:L("FQDB_TURNIN_MORE_FMT"):format(#list, t.title, t.who, ZoneName(t.m))
end

--- The "Turn in" button: the arrow to the nearest NPC that takes a finished quest.
function ns.ForeverQuestieGoTurnIn()
	local t = TurnIns()[1]
	if not t then
		print(PREFIX .. ns:L("FQDB_NO_TURNIN"))
		return false
	end
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(t.m, t.x, t.y)) then
		if not ns._mhWaypointYielded then
			print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		end
		return false
	end
	ns.lastTarget = { mapID = t.m, x = t.x, y = t.y, name = t.who, via = "QuestieDB turn in", arriveYards = 15 }
	ns._mhRouteOwner = "waypoint"
	print(PREFIX .. ns:L("FQDB_ARROW_FMT"):format(t.who, ZoneName(t.m), t.title))
	return true
end

--- /mh questiedb why: what B decided last, and the turn-ins it sees now.
local function Why()
	print(PREFIX .. ("QuestieDB use: %s; last decision: %s."):format(ns.IsForeverQuestieDBOn() and "on" or "off", lastWhy))
	local list = TurnIns()
	print(("  now: %s. %d finished quest(s) with a place:"):format(lastWhy, #list))
	for i, t in ipairs(list) do
		if i > 8 then
			break
		end
		print(("  %d %s -> NPC %d %s, map %d %.1f,%.1f (%s)"):format(t.q, t.title, t.npc, t.who, t.m, t.x, t.y, t.src))
	end
end

--- /mh questiedb [here | why]
function ns.ForeverQuestieDBSlash(arg)
	if InCombatLockdown and InCombatLockdown() then
		print(PREFIX .. "QuestieDB test: not in combat (MH reads nothing then). Try again after the fight.")
		return
	end
	arg = (arg or ""):lower()
	local ok, err = pcall((arg == "here" and Here) or (arg == "why" and Why) or Probe)
	if not ok then
		print(PREFIX .. "QuestieDB test stopped: " .. tostring(err))
	end
end
