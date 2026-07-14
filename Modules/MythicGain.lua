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

--- /mh mplus — a full measured breakdown in chat (a panel is Phase 2).
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
end
