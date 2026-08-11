local _, ns = ...

--[[
	Midnight Helper — are the world bosses still there? (`/mh worldboss`)

	The 12.1 patch notes say Lairs replace world bosses. `WorldBoss.lua` carries four
	Season 1 bosses with hardcoded quest ids and a rotation anchored to 18 March, so if
	that rotation has stopped, MH shows a list that means nothing — and the first Lair,
	The Tidebound Grotto, only opens 18 Aug. That leaves a gap where the panel would be
	confidently wrong.

	⚠️ This probe does not decide anything. It asks the client and writes down the
	answers; the conclusion is drawn afterwards, by a person, from the file. Three
	separate questions, because "the bosses are gone" and "our quest ids are stale" and
	"the rotation moved on" look identical from the panel:

	  1. Per boss — does the quest still report as a task, is it active, completed?
	  2. Per zone — EVERY task quest the map offers, not only the four we know. If
	     something replaced them, it shows up here rather than as an absence.
	  3. The Lair API — `Enum.TieredEntranceType.Lairs` was datamined in July as the
	     new system's enum. Present or not is a fact worth having.

	Bonus, since we are walking the map tree anyway: the child maps of the Midnight
	continent, which is where the Coiled Isle uiMapID has to come from (still on the
	live-capture list).

	Everything is read-only and wrapped in pcall. Output goes to
	`ns.db.worldBossProbe`; run it, `/reload`, and the SavedVariables file has the lot.
]]

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

--- pcall wrapper that records WHY something is missing rather than just dropping it —
--- "function absent" and "function threw" are different findings, and on a patch day
--- that difference is the whole point.
local function Ask(fn, ...)
	if type(fn) ~= "function" then
		return nil, "absent"
	end
	local ok, a, b = pcall(fn, ...)
	if not ok then
		return nil, "error"
	end
	return a, nil, b
end

local function QuestTitle(questId)
	if C_QuestLog and C_QuestLog.GetTitleForQuestID then
		local v = Ask(C_QuestLog.GetTitleForQuestID, questId)
		if type(v) == "string" and v ~= "" then
			return v
		end
	end
	if C_TaskQuest and C_TaskQuest.GetQuestInfoByQuestID then
		local v = Ask(C_TaskQuest.GetQuestInfoByQuestID, questId)
		if type(v) == "string" and v ~= "" then
			return v
		end
	end
	return nil
end

--- `/mh worldboss` — write down what the client says about the four world bosses.
function ns.MH_WorldBossProbe()
	ns.db = ns.db or {}

	local out = {
		takenAt = time(),
		build = nil,
		bosses = {},
		zones = {},
		api = {},
		active = {},
		continent = {},
	}

	-- Build number, so a file read weeks later says which patch it describes.
	if GetBuildInfo then
		local ok, version, _, _, iface = pcall(GetBuildInfo)
		if ok then
			out.build = ("%s (interface %s)"):format(tostring(version), tostring(iface))
		end
	end

	-- 1. Per boss ------------------------------------------------------------
	for _, boss in ipairs(ns.WORLD_BOSSES or {}) do
		local q = boss.questId
		local rec = {
			id = boss.id,
			questId = q,
			mapID = boss.mapID,
			title = QuestTitle(q),
		}

		local active, why = Ask(C_TaskQuest and C_TaskQuest.IsActive, q)
		rec.taskActive = why or tostring(active)

		local mins, why2 = Ask(C_TaskQuest and C_TaskQuest.GetQuestTimeLeftMinutes, q)
		rec.minutesLeft = why2 or tostring(mins)

		local done, why3 = Ask(C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted, q)
		rec.completedChar = why3 or tostring(done)

		local acc, why4 = Ask(C_QuestLog and C_QuestLog.IsQuestFlaggedCompletedOnAccount, q)
		rec.completedAccount = why4 or tostring(acc)

		--- The tag is the sharpest single question: a world-boss quest carries its own
		--- tag, so if the quest still exists but has stopped being one, that is a very
		--- different world from the quest having been removed outright.
		local tag, why5 = Ask(C_QuestLog and C_QuestLog.GetQuestTagInfo, q)
		if type(tag) == "table" then
			rec.tagId = tag.tagID
			rec.tagName = tag.tagName
			rec.worldQuestType = tag.worldQuestType
		else
			rec.tagId = why5 or "nil"
		end

		out.bosses[#out.bosses + 1] = rec
	end

	-- 2. Per zone: everything the map offers, ours or not ---------------------
	for _, mapID in ipairs({ 2395, 2437, 2413, 2405, 2576 }) do
		local zone = { mapID = mapID, tasks = {} }

		local info = Ask(C_Map and C_Map.GetMapInfo, mapID)
		zone.name = (type(info) == "table" and info.name) or "?"
		zone.mapType = (type(info) == "table" and info.mapType) or nil

		--- Same order the module uses now: whichever name this client has. The first
		--- run here is what proved `GetQuestsForPlayerByMapID` is gone on 12.1.
		local tasks, why
		for _, fn in ipairs({ C_TaskQuest and C_TaskQuest.GetQuestsOnMap,
		                      C_TaskQuest and C_TaskQuest.GetQuestsForPlayerByMapID }) do
			if type(fn) == "function" then
				local v, w = Ask(fn, mapID)
				if type(v) == "table" then
					tasks = v
					break
				end
				why = w or why
			else
				why = why or "absent"
			end
		end

		if type(tasks) ~= "table" then
			zone.tasks = why or "no table"
		else
			for _, poi in ipairs(tasks) do
				local qid = poi and (poi.questID or poi.questId)
				if qid then
					zone.tasks[#zone.tasks + 1] = {
						questId = qid,
						title = QuestTitle(qid),
						x = poi.x,
						y = poi.y,
					}
				end
			end
			zone.taskCount = #zone.tasks
			--- What an entry actually looks like. The scan reads questID/x/y off these,
			--- and a renamed field would drop every boss just as quietly as the removed
			--- function did — so record the shape rather than trust it.
			if tasks[1] and type(tasks[1]) == "table" then
				local fields = {}
				for k, v in pairs(tasks[1]) do
					fields[#fields + 1] = ("%s=%s"):format(tostring(k), type(v))
				end
				table.sort(fields)
				zone.entryShape = table.concat(fields, " ")
			end
		end
		out.zones[#out.zones + 1] = zone
	end

	--- 2b. WHICH task-quest functions still exist.
	---
	--- The first PTR run answered a question nobody had asked: every zone came back
	--- `tasks = "absent"`, meaning `C_TaskQuest.GetQuestsForPlayerByMapID` is not a
	--- function on 12.1 at all. Two of the three detection paths in QueryLiveWorldBoss
	--- call it, so they cannot work — and they fail silently, which is why the panel
	--- quietly fell back to a stale cache instead of saying anything.
	---
	--- So list what the namespace DOES offer rather than guessing at a replacement.
	for _, ns2 in ipairs({ "C_TaskQuest", "C_QuestLog" }) do
		local tbl = _G[ns2]
		if type(tbl) == "table" then
			local names = {}
			for k, v in pairs(tbl) do
				if type(k) == "string" and type(v) == "function" then
					names[#names + 1] = k
				end
			end
			table.sort(names)
			out.api[ns2] = names
		else
			out.api[ns2] = "absent"
		end
	end

	--- And try the likely replacement by name, on a map we know has content.
	--- Suggestive is not evidence: record what it returns, do not adopt it here.
	if C_TaskQuest and C_TaskQuest.GetQuestsOnMap then
		local v = Ask(C_TaskQuest.GetQuestsOnMap, 2395)
		out.api.getQuestsOnMap = type(v) == "table"
			and ("table, %d entries"):format(#v) or tostring(v)
	else
		out.api.getQuestsOnMap = "absent"
	end

	-- 3. The Lair API --------------------------------------------------------
	if Enum and Enum.TieredEntranceType then
		local kinds = {}
		for k, v in pairs(Enum.TieredEntranceType) do
			kinds[tostring(k)] = tostring(v)
		end
		out.api.tieredEntranceType = kinds
		out.api.hasLairs = (Enum.TieredEntranceType.Lairs ~= nil)
	else
		out.api.tieredEntranceType = "Enum.TieredEntranceType absent"
	end

	-- 4. What MH itself currently believes -----------------------------------
	if ns.GetActiveWorldBoss then
		local ok, boss, fromClient, source = pcall(ns.GetActiveWorldBoss)
		if ok and type(boss) == "table" then
			out.active.bossId = boss.id
			out.active.questId = boss.questId
			out.active.fromClient = tostring(fromClient)
			out.active.source = tostring(source)
		else
			out.active.error = true
		end
	end

	-- 5. Map tree, for the Coiled Isle id ------------------------------------
	local parentInfo = Ask(C_Map and C_Map.GetMapInfo, 2395)
	local parent = type(parentInfo) == "table" and parentInfo.parentMapID or nil
	out.continent.parentOfEversong = parent
	if parent then
		local kids = Ask(C_Map and C_Map.GetMapChildrenInfo, parent)
		if type(kids) == "table" then
			out.continent.children = {}
			for _, k in ipairs(kids) do
				out.continent.children[#out.continent.children + 1] =
					("%d = %s (type %s)"):format(
						tonumber(k.mapID) or -1, tostring(k.name), tostring(k.mapType))
			end
		end
	end

	ns.db.worldBossProbe = out

	-- Short summary in chat; the detail is in the file.
	local anyActive, known = 0, #out.bosses
	for _, b in ipairs(out.bosses) do
		if b.taskActive == "true" then
			anyActive = anyActive + 1
		end
	end
	print(("%s world-boss probe: |cffffffff%d|r bosses checked, |cffffffff%d|r reporting active."):format(
		Prefix(), known, anyActive))
	print(("   Lair enum present: |cffffffff%s|r"):format(tostring(out.api.hasLairs)))
	for _, z in ipairs(out.zones) do
		print(("   %s (%d): |cffffffff%s|r task quest(s)"):format(
			tostring(z.name), z.mapID, tostring(z.taskCount or z.tasks)))
	end
	print("   |cff9d9d9dSaved to the DB — now |cffffffff/reload|r so it lands in the file.|r")
end
