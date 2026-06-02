--[[
	Delve weekly trackers — Trovehunter's Bounty, Gilded Stash, Special Assignments.

	Trovehunter uses Blizzard quest flags (86371 = looted this week).
	Gilded Stash has no live API — progress is inferred from Delve Log runs
	(T11+ bountiful since weekly reset). Special Assignments use fixed quest IDs.
]]

local _, ns = ...

local GILDED_MAX = 4
local GILDED_MIN_TIER = 11
local TROVE_QUEST_LOOTED = 86371
local TROVE_QUEST_USED = 92887
local TROVE_MAP_ITEM = 252415
local TROVE_AURA_SPELL = 1254631
local SA_WEEKLY_MAX = 3

ns.SPECIAL_ASSIGNMENTS = {
	{ questID = 93013, unlockID = 94391, title = "Push back the Light" },
	{ questID = 92063, unlockID = 94390, title = "A Hunter's Regret" },
	{ questID = 92145, unlockID = 92848, title = "The Grand Magister's Drink" },
	{ questID = 91796, unlockID = 94866, title = "Ours Once More!" },
	{ questID = 93244, unlockID = 94795, title = "Agents of the Shield" },
	{ questID = 92139, unlockID = 95435, title = "Shade and Claw" },
	{ questID = 91390, unlockID = 94865, title = "What Remains of a Temple Broken" },
	{ questID = 93438, unlockID = 94743, title = "Precision Excision" },
}

local function GetWeeklyResetAnchorTs()
	if C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset then
		local ok, secs = pcall(C_DateAndTime.GetSecondsUntilWeeklyReset)
		if ok and secs and secs > 0 then
			local now = (GetServerTime and GetServerTime()) or time()
			return now + secs - 604800
		end
	end
	local now = time()
	local t = date("*t", now)
	if not t then
		return now
	end
	local daysSinceReset = ((tonumber(t.wday) or 1) - 4) % 7
	local anchor = time({
		year = t.year,
		month = t.month,
		day = t.day - daysSinceReset,
		hour = 8,
		min = 0,
		sec = 0,
	})
	if anchor and now < anchor then
		anchor = anchor - 7 * 24 * 60 * 60
	end
	return anchor or now
end

local function IsQuestCompleted(questID)
	if not questID or not C_QuestLog or not C_QuestLog.IsQuestFlaggedCompleted then
		return false
	end
	local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, questID)
	return ok and done == true
end

local function IsQuestOnLog(questID)
	if not questID or not C_QuestLog or not C_QuestLog.IsOnQuest then
		return false
	end
	local ok, on = pcall(C_QuestLog.IsOnQuest, questID)
	return ok and on == true
end

local function GetTrovehunterMapCount()
	if not C_Item or not C_Item.GetItemCount then
		return 0
	end
	local ok, count = pcall(C_Item.GetItemCount, TROVE_MAP_ITEM)
	return ok and math.floor(tonumber(count) or 0) or 0
end

function ns.GetTrovehunterMapCount()
	return GetTrovehunterMapCount()
end

--- Trovehunter weekly status for the current character.
--- status: "available" | "looted" | "done" | "active"
function ns.GetTrovehunterState()
	local weeklyLooted = IsQuestCompleted(TROVE_QUEST_LOOTED)
	local bountyUsed = IsQuestCompleted(TROVE_QUEST_USED)
	local inBag = GetTrovehunterMapCount()
	local auraActive = false
	if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
		local ok, aura = pcall(C_UnitAuras.GetPlayerAuraBySpellID, TROVE_AURA_SPELL)
		auraActive = ok and aura ~= nil
	end

	local status = "available"
	if auraActive then
		status = "active"
	elseif inBag > 0 and not bountyUsed then
		-- Map in bags: still need to use it in a delve.
		status = "looted"
	elseif bountyUsed or weeklyLooted then
		-- Used, or weekly loot flag set with nothing left to use on this character.
		status = "done"
	end

	return {
		weeklyLooted = weeklyLooted,
		bountyUsed = bountyUsed,
		inBag = inBag,
		auraActive = auraActive,
		status = status,
	}
end

--- Count Gilded Stash qualifying runs in a per-character delve log store.
function ns.CountGildedStashRuns(store, resetTs)
	if type(store) ~= "table" or type(store.delves) ~= "table" then
		return 0
	end
	local anchor = tonumber(resetTs) or GetWeeklyResetAnchorTs()
	local progress = 0
	for _, entry in pairs(store.delves) do
		if type(entry) == "table" and type(entry.recent) == "table" then
			for _, run in ipairs(entry.recent) do
				if type(run) == "table"
					and run.wasBountiful
					and (tonumber(run.tier) or 0) >= GILDED_MIN_TIER
					and (tonumber(run.timestamp) or 0) >= anchor
				then
					progress = progress + 1
				end
			end
		end
	end
	if progress > GILDED_MAX then
		progress = GILDED_MAX
	end
	return progress
end

function ns.GetGildedStashStateForGuid(guid)
	local progress = 0
	if guid and ns.db and type(ns.db.delveLog) == "table" then
		local store = ns.db.delveLog[guid]
		if store then
			progress = ns.CountGildedStashRuns(store)
		end
	end
	return {
		progress = progress,
		max = GILDED_MAX,
		done = progress >= GILDED_MAX,
	}
end

function ns.GetGildedStashState()
	local guid = UnitGUID and UnitGUID("player") or nil
	return ns.GetGildedStashStateForGuid(guid)
end

local function GetSpecialAssignmentEntryState(entry)
	if type(entry) ~= "table" then
		return "locked", entry
	end
	local unlocked = true
	if entry.unlockID then
		unlocked = IsQuestCompleted(entry.unlockID)
	end
	if not unlocked then
		return "locked", entry
	end
	if IsQuestCompleted(entry.questID) then
		return "completed", entry
	end
	if IsQuestOnLog(entry.questID) then
		return "active", entry
	end
	return "available", entry
end

function ns.GetSpecialAssignmentState()
	local assignments = {}
	local completed, active, available, locked = 0, 0, 0, 0
	for _, entry in ipairs(ns.SPECIAL_ASSIGNMENTS) do
		local state = GetSpecialAssignmentEntryState(entry)
		if state == "completed" then
			completed = completed + 1
		elseif state == "active" then
			active = active + 1
		elseif state == "available" then
			available = available + 1
		else
			locked = locked + 1
		end
		assignments[#assignments + 1] = {
			questID = entry.questID,
			unlockID = entry.unlockID,
			title = entry.title,
			state = state,
		}
	end
	return {
		completed = completed,
		active = active,
		available = available,
		locked = locked,
		max = SA_WEEKLY_MAX,
		assignments = assignments,
		atCap = completed >= SA_WEEKLY_MAX,
	}
end

function ns.GetTrovehunterSnapshotCounts()
	local s = ns.GetTrovehunterState()
	local needsBounty = (s.status == "available") and 1 or 0
	local hasUnused = (s.status == "looted") and 1 or 0
	return s.status, s.inBag or 0, needsBounty, hasUnused
end

function ns.GetGildedStashSnapshotCounts()
	local s = ns.GetGildedStashState()
	return s.progress or 0, s.max or GILDED_MAX
end

function ns.GetSpecialAssignmentSnapshotCounts()
	local s = ns.GetSpecialAssignmentState()
	return s.completed or 0, s.active or 0, s.max or SA_WEEKLY_MAX
end

function ns.MhGetWeeklyResetAnchorTs()
	return GetWeeklyResetAnchorTs()
end

--- Max level for the current expansion (Bountiful Delve weekly gate).
function ns.GetDelveCapLevel()
	if GetMaxLevelForPlayerExpansion then
		local ok, lvl = pcall(GetMaxLevelForPlayerExpansion)
		if ok and (tonumber(lvl) or 0) > 0 then
			return tonumber(lvl)
		end
	end
	if GetMaxPlayerLevel then
		local ok, lvl = pcall(GetMaxPlayerLevel)
		if ok and (tonumber(lvl) or 0) > 0 then
			return tonumber(lvl)
		end
	end
	return 80
end

function ns.IsPlayerAtDelveCapLevel(unit)
	local lvl = UnitLevel and UnitLevel(unit or "player")
	return (tonumber(lvl) or 0) >= ns.GetDelveCapLevel()
end

--- When true, show "requires level N" instead of a misleading fresh/available line.
function ns.ShouldShowDelveWeeklyUnderlevel(kind, state)
	if ns.IsPlayerAtDelveCapLevel() then
		return false
	end
	if kind == "trove" and type(state) == "table" then
		return state.status == "available"
	end
	if kind == "gilded" and type(state) == "table" then
		return (tonumber(state.progress) or 0) <= 0
	end
	if kind == "sa" and type(state) == "table" then
		return (tonumber(state.completed) or 0) <= 0 and (tonumber(state.active) or 0) <= 0
	end
	return false
end
