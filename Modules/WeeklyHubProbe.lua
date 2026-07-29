local _, ns = ...

--[[
	Midnight Helper — weekly hub probe (/mh weeklies).

	MH has admitted for a long time that it cannot see these: "Weekly hub (Liadrin /
	Halduron / Aethas — add quest IDs)" and "pick-up isn't tracked yet". Rob hit it
	from the other side — he accepted Lady Liadrin's weekly and MH still told him to
	go and get it.

	The ids below come from Broker_MidnightEvents/Data.lua, an addon installed on
	this machine. That is a decent source, not a proven one: it is datamined, and its
	own comments flag 93891 as "Wowhead: obsolete — verify". So this file does NOT
	wire them into This Week. It only asks the game what it knows about each one, so
	Rob can hold the answer against his own quest log before we trust any of it.

	Reads only. C_QuestLog.IsQuestFlaggedCompleted and IsOnQuest are both plain
	queries — nothing here accepts, abandons or turns in anything.
]]

--- Lady Liadrin's "Unity against the Void" choice pool. She offers four of these
--- per character per week; completing one flags them ALL until the weekly reset.
--- Meta quest 93744 "Unity Against the Void".
local LIADRIN = {
	{ 93766, "World Quests" },
	{ 93769, "Housing" },
	{ 93889, "Saltheril's Soiree" },
	{ 93890, "Abundance" },
	{ 93891, "Legends of the Haranir" }, -- source flags this one as possibly obsolete
	{ 95843, "Ritual Sites" }, -- IN-GAME gemeten 29 jul 2026: Rob koos deze en de probe gaf "NOT IN OUR DATA". Game-titel "Midnight: Ritual Sites" bevestigt het id. Ligt naast 95842 (Void Assaults) — beide de 12.0.5-wereldsystemen.
	{ 93892, "Stormarion Assault" },
	{ 93909, "Delves" },
	{ 93910, "Prey" },
	{ 93911, "Dungeons" },
	{ 93913, "World Boss" },
	{ 94457, "Battlegrounds" },
	{ 95842, "Void Assaults" }, -- the only one MH already knew (VoidAssaults.lua)
}

--- The Void Assault zone rotation: one zone is active per week, each with its own
--- quest. This is the pair Rob asked about — the two areas that alternate.
local VOID_ZONES = {
	{ 94385, "Eversong Woods" },
	{ 94386, "Zul'Aman" },
}

--- Riftblade Maella's Showdown weeklies. Added because the reset routine kept
--- showing "pick it up" while /mh questscan proved 96674 was sitting in Rob's log
--- (2026-07-22). The routine reads C_QuestLog.IsOnQuest; questscan walks the log
--- with GetInfo. If those two disagree about the same quest, this is where it shows.
local SHOWDOWN = {
	{ 96713, "Showdown on Val" },
	{ 96717, "Showdown on Naigtal" },
	{ 96714, "Showdown on Val (Heroic)" },
	{ 96053, "Surveying the Frozen Wastes" },
	{ 96054, "Surveying the Mana-Bog" },
}

local function QuestState(id)
	local done, onQuest
	if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
		local ok, v = pcall(C_QuestLog.IsQuestFlaggedCompleted, id)
		done = ok and v or false
	end
	if C_QuestLog and C_QuestLog.IsOnQuest then
		local ok, v = pcall(C_QuestLog.IsOnQuest, id)
		onQuest = ok and v or false
	end
	local title
	if C_QuestLog and C_QuestLog.GetTitleForQuestID then
		local ok, v = pcall(C_QuestLog.GetTitleForQuestID, id)
		title = ok and v or nil
	end
	return done, onQuest, title
end

local function PrintPool(label, list)
	print(("   |cff8fd3ff%s|r"):format(label))
	local anyDone, anyOn = false, false
	for _, row in ipairs(list) do
		local id, name = row[1], row[2]
		local done, onQuest, title = QuestState(id)
		local state
		if onQuest then
			state = "|cffffd100in your log|r"
			anyOn = true
		elseif done then
			state = "|cff40c040completed|r"
			anyDone = true
		else
			state = "|cff9d9d9d-|r"
		end
		-- The game's own title is the check that matters: if it does not match the
		-- name we carry, the id belongs to something else and must not be used.
		local shown = title and title ~= "" and title or "|cffff5040no title from the game|r"
		print(("      %d  %-24s %-16s %s"):format(id, name, state, shown))
	end
	if not anyDone and not anyOn then
		print("      |cff9d9d9d(nothing in this pool is active or completed right now)|r")
	end
end

function ns.PrintWeeklyHubProbe()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s Weekly hub probe — quest ids are UNVERIFIED, compare with your quest log"):format(prefix))
	PrintPool("Lady Liadrin's weekly pool", LIADRIN)
	PrintPool("Void Assault zone rotation", VOID_ZONES)
	PrintPool("Showdown (Riftblade Maella)", SHOWDOWN)

	-- Cross-check: walk the quest log the way /mh questscan does and report anything
	-- whose IsOnQuest answer contradicts its presence in the log. That contradiction
	-- is the open question right now, so let the game settle it rather than reasoning
	-- about it from the outside.
	if C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo then
		local mismatches = 0
		local n = C_QuestLog.GetNumQuestLogEntries() or 0
		for i = 1, n do
			local q = C_QuestLog.GetInfo(i)
			if q and not q.isHeader and q.questID then
				local okOn, onQuest = pcall(C_QuestLog.IsOnQuest, q.questID)
				if okOn and not onQuest then
					mismatches = mismatches + 1
					print(("   |cffff5040in the log but IsOnQuest says no:|r %d  %s"):format(q.questID, q.title or "?"))
				end
			end
		end
		if mismatches == 0 then
			print("   |cff9d9d9dEvery quest in your log also answers yes to IsOnQuest.|r")
		end

		-- The pools above can only ever report on ids we already hold, so a weekly
		-- we have never seen is invisible to them -- it just shows up as "nothing
		-- active", which reads exactly like "you have not picked one up". That is
		-- what kept telling Rob to go and get a quest already in his log, and it is
		-- how the Naigtal Heroic weekly (96718) hid from us until 29 jul.
		--
		-- So: name every "Midnight:" quest in the log and say whether we know it.
		-- An unknown id here is the answer, not a puzzle.
		local known = {}
		for _, pool in ipairs({ LIADRIN, VOID_ZONES, SHOWDOWN }) do
			for _, row in ipairs(pool) do
				known[row[1]] = true
			end
		end
		print("   |cff8fd3ffWeekly-hub quests in your log|r")
		local seen = 0
		for i = 1, n do
			local q = C_QuestLog.GetInfo(i)
			if q and not q.isHeader and q.questID and q.title then
				local title = tostring(q.title)
				if title:lower():find("midnight:", 1, true) == 1 or known[q.questID] then
					seen = seen + 1
					print(("      %d  %s  %s"):format(
						q.questID, title,
						known[q.questID] and "|cff40c040known|r" or "|cffff8080NOT IN OUR DATA|r"))
				end
			end
		end
		if seen == 0 then
			print("      |cff9d9d9d(none right now -- pick one up first)|r")
		end
	end
	print("   |cff9d9d9dA title that does not match the label means the id is wrong.|r")
end
