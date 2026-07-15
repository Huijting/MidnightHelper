local _, ns = ...

--[[
	Midnight Helper — Mythic+ gain advisor (Spec 20, Phase 1: Great Vault M+ slots).

	Answers "what do I still get from another key this week?" as ADVICE, never automation
	(MH stays the coach; it never slots a keystone or plays for you).

	NEVER-LIE: everything here is MEASURED data from C_WeeklyRewards.GetActivities and
	C_MythicPlus.GetOverallDungeonScore — both already proven elsewhere in the addon. The
	exact rating a "+N" would ADD shifts every season, so we do NOT compute or guess it:
	we point at the keystone tooltip, which shows the game's own projection. Vault item
	levels per key level are season-dependent too, so we show the measured key LEVEL, not
	a promised ilvl.

	Phase 2 (later, needs in-game verification): per-dungeon best via
	C_MythicPlus.GetSeasonBestForMap + a panel; qualitative rating gain per dungeon.
]]

-- Mythic+ is the "dungeon" vault category (shared mapping with VaultAdvisor).
local function IsMythicActivity(activityType)
	local map = ns.VAULT_ADVISOR_ACTIVITY_TYPES
	local t = tonumber(activityType)
	return (map and t and map[t] == "dungeon") or false
end

-- The three M+ vault slots as measured data, ordered by threshold (1, 4, 8 runs).
--   { threshold = runs needed, progress = runs done, level = key level of the run that
--     fills this slot (0 if none yet), unlocked = progress >= threshold }
local function ReadMythicVaultSlots()
	if not (C_WeeklyRewards and C_WeeklyRewards.GetActivities) then
		return nil
	end
	local ok, activities = pcall(C_WeeklyRewards.GetActivities)
	if not ok or type(activities) ~= "table" then
		return nil
	end
	local slots = {}
	for _, a in ipairs(activities) do
		if a and IsMythicActivity(a.type) then
			slots[#slots + 1] = {
				threshold = tonumber(a.threshold) or 0,
				progress = tonumber(a.progress) or 0,
				level = tonumber(a.level) or 0,
			}
		end
	end
	if #slots == 0 then
		return nil
	end
	table.sort(slots, function(x, y)
		return (x.threshold or 0) < (y.threshold or 0)
	end)
	for _, s in ipairs(slots) do
		s.unlocked = (s.threshold > 0) and (s.progress >= s.threshold)
	end
	return slots
end

local function TotalRuns(slots)
	local most = 0
	for _, s in ipairs(slots) do
		most = math.max(most, s.progress)
	end
	return most
end

-- First slot that is not yet unlocked, and how many runs remain for it.
local function NextLockedSlot(slots)
	for _, s in ipairs(slots) do
		if not s.unlocked then
			return s, math.max((s.threshold or 0) - (s.progress or 0), 0)
		end
	end
	return nil, 0
end

--- Home "This Week" line(s). Empty when the player has done no M+ this week, so it never
--- nags a non-dungeon player. { text, color } — matches the GetXSteps contract.
function ns.GetMythicGainSteps()
	local slots = ReadMythicVaultSlots()
	if not slots or TotalRuns(slots) == 0 then
		return {}
	end
	local next_, remaining = NextLockedSlot(slots)
	if next_ then
		return {
			{ text = (ns:L("MPLUS_GAIN_NEXT_FMT")):format(remaining), color = "prog" },
		}
	end
	-- All three slots filled: show the counted key levels, invite higher keys.
	local levels = {}
	for _, s in ipairs(slots) do
		levels[#levels + 1] = "+" .. tostring(s.level or 0)
	end
	return {
		{ text = (ns:L("MPLUS_GAIN_FULL_FMT")):format(table.concat(levels, " / ")), color = "good" },
	}
end

-- Per-dungeon season best (Phase 2). MEASURED: the current-season map list from
-- C_ChallengeMode.GetMapTable, names from GetMapUIInfo, and each dungeon's best
-- from C_MythicPlus.GetSeasonBestForMap (returns affixScores + bestOverallScore).
-- All reads are pcall-guarded and shape-checked, so an API change just yields an
-- empty list rather than a wrong number. never-lie: we show the measured level +
-- score, never a computed rating gain. Return list sorted lowest-score-first
-- (that's where another key adds the most rating, qualitatively).
-- ⚠️ Verify the return shape in-game before wiring this into a prominent panel.
local function ReadPerDungeonBests()
	if not (C_ChallengeMode and C_ChallengeMode.GetMapTable and C_MythicPlus and C_MythicPlus.GetSeasonBestForMap) then
		return nil
	end
	local ok, maps = pcall(C_ChallengeMode.GetMapTable)
	if not ok or type(maps) ~= "table" or #maps == 0 then
		return nil
	end
	local out = {}
	for _, mapID in ipairs(maps) do
		local name
		if C_ChallengeMode.GetMapUIInfo then
			local ok2, n = pcall(C_ChallengeMode.GetMapUIInfo, mapID)
			if ok2 and type(n) == "string" and n ~= "" then
				name = n
			end
		end
		local level, score = 0, 0
		local ok3, affixScores, bestOverall = pcall(C_MythicPlus.GetSeasonBestForMap, mapID)
		if ok3 then
			if type(bestOverall) == "number" then
				score = bestOverall
			end
			if type(affixScores) == "table" then
				for _, a in ipairs(affixScores) do
					if type(a) == "table" and type(a.level) == "number" and a.level > level then
						level = a.level
					end
				end
			end
		end
		out[#out + 1] = { mapID = mapID, name = name or ("map " .. tostring(mapID)), level = level, score = score }
	end
	table.sort(out, function(a, b)
		return (a.score or 0) < (b.score or 0)
	end)
	return out
end

--- /mh mplus — a full measured breakdown in chat (a panel is Phase 2, after
--- the per-dungeon API is confirmed in-game).
function ns.PrintMythicGain()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s |cff8fd3ff%s|r"):format(prefix, ns:L("MPLUS_CMD_HEADER")))

	if C_MythicPlus and C_MythicPlus.GetOverallDungeonScore then
		local ok, score = pcall(C_MythicPlus.GetOverallDungeonScore)
		if ok and type(score) == "number" and score > 0 then
			print(("   " .. ns:L("MPLUS_CMD_RATING_FMT")):format(math.floor(score + 0.5)))
		end
	end

	local slots = ReadMythicVaultSlots()
	if not slots or TotalRuns(slots) == 0 then
		print("   " .. ns:L("MPLUS_CMD_NONE"))
		return
	end
	for i, s in ipairs(slots) do
		local best = (s.progress > 0 and s.level and s.level > 0)
			and ((ns:L("MPLUS_CMD_BEST_FMT")):format(s.level))
			or ""
		print(("   " .. ns:L("MPLUS_CMD_SLOT_FMT")):format(i, s.threshold, s.progress, s.threshold, best))
	end
	print("   |cff9d9d9d" .. ns:L("MPLUS_CMD_RATING_NOTE") .. "|r")

	-- Phase 2: per-dungeon season best, lowest first (most rating to gain there).
	local bests = ReadPerDungeonBests()
	if bests and #bests > 0 then
		print(("   |cff8fd3ff%s|r"):format(ns:L("MPLUS_CMD_PERDUNGEON")))
		for _, d in ipairs(bests) do
			local lvlStr = (d.level and d.level > 0)
				and (("|cffffd100+%d|r"):format(d.level))
				or ("|cffff6060%s|r"):format(ns:L("MPLUS_CMD_NOTRUN"))
			local scoreStr = (d.score and d.score > 0) and (" |cff9d9d9d(%d)|r"):format(math.floor(d.score + 0.5)) or ""
			print(("      %s — %s%s"):format(d.name, lvlStr, scoreStr))
		end
		print("      |cff9d9d9d" .. ns:L("MPLUS_CMD_GAIN_NOTE") .. "|r")
	end
end
