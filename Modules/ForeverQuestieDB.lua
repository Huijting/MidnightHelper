local _, ns = ...

--[[
	ForeverQuestieDB.lua — WoW Forever: MEASURE whether MH can read QuestieDB while you play, before anything uses it.
	Rob, 23 Nov 2026 via Sparring 23-11, verbatim: "quest a", then "Ik volg jullie advies." (= measure A first, fill gaps
	B only after this measurement; docs/forever/QUESTIEDB_LIVE_2026-11-23.md).

	It changes nothing in the game and draws nothing. Players are not told about it (lint [16]/[27]: unlisted, dev only).
	🔴 MH ships NO QuestieDB data: nothing from it is written to an MH file. It is read in the game, only when the player
	has QuestieDB enabled. What this probe keeps in ns.db.questieDbProbe is ours: counts, milliseconds, kilobytes, and
	DISTANCES between QuestieDB's spawn points and MH's own trainer places. Never its coordinates, names or quest data.

	/mh questiedb       = is it there, does its contract fit, how long 50 reads take (cold and warm), its memory, and
	                      how far its NPC spawns lie from MH's own trainer places (Rob-measured ones listed apart).
	                      Distances raw and after LibQuestieDB.EraToForever: that tells whether its points are Era or
	                      Forever map space (the open question in the research doc).
	/mh questiedb here  = target an NPC and stand next to it: the distance from you to that NPC's nearest QuestieDB spawn.
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

--- /mh questiedb [here]
function ns.ForeverQuestieDBSlash(arg)
	if InCombatLockdown and InCombatLockdown() then
		print(PREFIX .. "QuestieDB test: not in combat (MH reads nothing then). Try again after the fight.")
		return
	end
	arg = (arg or ""):lower()
	local ok, err = pcall(arg == "here" and Here or Probe)
	if not ok then
		print(PREFIX .. "QuestieDB test stopped: " .. tostring(err))
	end
end
