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

-- Gear per key level: the game's OWN reward API, so the item levels are always
-- this-season-accurate (never-lie: no hardcoded ilvls that go stale). vault ilvl
-- is always >= end-of-run, so if the two returns come back in the other order we
-- swap them by that rule rather than trusting the argument order.
local GEAR_KEYS = { 2, 4, 6, 8, 10, 12 }
local function PrintGearRewards()
	if not (C_MythicPlus and C_MythicPlus.GetRewardLevelForDifficultyLevel) then
		return
	end
	local lines = {}
	for _, lvl in ipairs(GEAR_KEYS) do
		local ok, a, b = pcall(C_MythicPlus.GetRewardLevelForDifficultyLevel, lvl)
		if ok and type(a) == "number" and type(b) == "number" and a > 0 and b > 0 then
			local vault, endrun = a, b
			if vault < endrun then
				vault, endrun = endrun, vault -- vault ilvl is never below end-of-run
			end
			lines[#lines + 1] = ("      |cffffd100+%d|r — %s"):format(lvl, (ns:L("MPLUS_CMD_GEAR_FMT")):format(endrun, vault))
		end
	end
	if #lines > 0 then
		print(("   |cff8fd3ff%s|r"):format(ns:L("MPLUS_CMD_GEAR_HEAD")))
		for _, l in ipairs(lines) do
			print(l)
		end
		print("      |cff9d9d9d" .. ns:L("MPLUS_CMD_GEAR_NOTE") .. "|r")
	else
		-- Diagnostic (temporary): tell us WHY there's no gear data — the function
		-- missing vs it returning 0 (reward data not populated on this client).
		local fn = C_MythicPlus and type(C_MythicPlus.GetRewardLevelForDifficultyLevel) == "function"
		local a, b = "-", "-"
		if fn then
			local okp, x, y = pcall(C_MythicPlus.GetRewardLevelForDifficultyLevel, 5)
			a = okp and tostring(x) or "err"
			b = okp and tostring(y) or "err"
		end
		print(("   |cff9d9d9dgear diag: fn=%s  +5→(%s, %s)|r"):format(tostring(fn), a, b))
	end
end

-- Several M+ APIs (reward levels, map/affix info) return 0/empty until the client
-- has been asked to populate them. Request once on login so /mh mplus has data.
do
	local rf = CreateFrame("Frame")
	rf:RegisterEvent("PLAYER_ENTERING_WORLD")
	rf:SetScript("OnEvent", function(self)
		self:UnregisterAllEvents()
		if C_MythicPlus then
			if C_MythicPlus.RequestMapInfo then
				pcall(C_MythicPlus.RequestMapInfo)
			end
			if C_MythicPlus.RequestRewards then
				pcall(C_MythicPlus.RequestRewards)
			end
		end
	end)
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

	-- This week's vault slots — or a gentle "none yet" that still falls through to
	-- the season-wide per-dungeon + gear sections below (they don't need a run
	-- this week; a player who's done nothing this week still wants those).
	local slots = ReadMythicVaultSlots()
	if slots and TotalRuns(slots) > 0 then
		for i, s in ipairs(slots) do
			local best = (s.progress > 0 and s.level and s.level > 0)
				and ((ns:L("MPLUS_CMD_BEST_FMT")):format(s.level))
				or ""
			print(("   " .. ns:L("MPLUS_CMD_SLOT_FMT")):format(i, s.threshold, s.progress, s.threshold, best))
		end
		print("   |cff9d9d9d" .. ns:L("MPLUS_CMD_RATING_NOTE") .. "|r")
	else
		print("   " .. ns:L("MPLUS_CMD_NONE"))
	end

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

	-- Gear you can get per key level (this-season-accurate via the game's API).
	PrintGearRewards()
end
