--[[
	Delver's Call — Midnight weekly "World Tour" quests.

	One rotational Delver's Call quest per delve. Each can sit in four states
	on the live character:
	  fresh      — not in log, not turned in (pick it up at the delve)
	  inProgress — accepted, objectives not finished
	  ready      — objectives finished, NOT turned in yet ("banked")
	  completed  — turned in this week

	"Banked" is the alt-leveling sweet spot: turn-in XP scales to your level,
	so holding all of them until you are a few levels from cap pays off.

	Quest IDs verified against EverythingDelves and ZamestoTV_Delves.
]]

local _, ns = ...

-- Ordered by zone so the tooltip groups cleanly.
ns.DELVER_CALL_QUESTS = {
	{ questID = 93372, zone = "Eversong Woods / Silvermoon City", delve = "Shadow Enclave" },
	{ questID = 93384, zone = "Eversong Woods / Silvermoon City", delve = "Collegiate Calamity" },
	{ questID = 93385, zone = "Eversong Woods / Silvermoon City", delve = "The Darkway" },
	{ questID = 93386, zone = "Eversong Woods / Silvermoon City", delve = "Parhelion Plaza" },
	{ questID = 93416, zone = "Harandar", delve = "The Gulf of Memory" },
	{ questID = 93421, zone = "Harandar", delve = "The Grudge Pit" },
	{ questID = 93409, zone = "Zul'Aman", delve = "Atal'Aman" },
	{ questID = 93410, zone = "Zul'Aman", delve = "Twilight Crypts" },
	{ questID = 93427, zone = "Voidstorm", delve = "Sunkiller Sanctum" },
	{ questID = 93428, zone = "Voidstorm", delve = "Shadowguard Point" },
}

--- Live state of a single Delver's Call quest on the CURRENT character.
--- Returns one of: "fresh" | "inProgress" | "ready" | "completed".
local function GetQuestState(questID)
	if not questID or not C_QuestLog then
		return "fresh"
	end
	if C_QuestLog.IsQuestFlaggedCompleted and C_QuestLog.IsQuestFlaggedCompleted(questID) then
		return "completed"
	end
	local logIdx = C_QuestLog.GetLogIndexForQuestID and C_QuestLog.GetLogIndexForQuestID(questID)
	if logIdx then
		local objectivesDone = false
		if C_QuestLog.ReadyForTurnIn then
			local ok, ready = pcall(C_QuestLog.ReadyForTurnIn, questID)
			if ok and ready then
				objectivesDone = true
			end
		end
		if not objectivesDone and C_QuestLog.IsComplete then
			local ok, done = pcall(C_QuestLog.IsComplete, questID)
			if ok and done then
				objectivesDone = true
			end
		end
		return objectivesDone and "ready" or "inProgress"
	end
	return "fresh"
end

--- Localized quest title with a safe English fallback.
function ns.GetDelverCallQuestTitle(entry)
	if type(entry) ~= "table" then
		return ""
	end
	if C_QuestLog and C_QuestLog.GetTitleForQuestID then
		local ok, title = pcall(C_QuestLog.GetTitleForQuestID, entry.questID)
		if ok and type(title) == "string" and title ~= "" then
			return title
		end
	end
	return "Delver's Call: " .. tostring(entry.delve or entry.questID or "?")
end

--- Full live snapshot of Delver's Call progress for the current character.
function ns.GetDelverCallState()
	local quests = {}
	local completed, banked, inProgress, fresh = 0, 0, 0, 0
	for _, entry in ipairs(ns.DELVER_CALL_QUESTS) do
		local state = GetQuestState(entry.questID)
		if state == "completed" then
			completed = completed + 1
		elseif state == "ready" then
			banked = banked + 1
		elseif state == "inProgress" then
			inProgress = inProgress + 1
		else
			fresh = fresh + 1
		end
		quests[#quests + 1] = {
			questID = entry.questID,
			zone = entry.zone,
			delve = entry.delve,
			state = state,
		}
	end
	return {
		total = #ns.DELVER_CALL_QUESTS,
		completed = completed,
		banked = banked,
		inProgress = inProgress,
		fresh = fresh,
		quests = quests,
	}
end

--- Compact counts for the account snapshot (alt rollup).
--- Returns completed, banked, inProgress, total.
function ns.GetDelverCallSnapshotCounts()
	local s = ns.GetDelverCallState()
	return s.completed, s.banked, s.inProgress, s.total
end
