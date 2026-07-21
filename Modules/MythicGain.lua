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
				id = a.id, -- needed to ask the game for that slot's example reward
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

-- NB: no per-key-level ilvl table. C_MythicPlus.GetRewardLevelForDifficultyLevel
-- returns garbage on 12.x (Rob's client: +5 → 263 / 0, not a real ~600 ilvl), and
-- a hardcoded season table would go stale each season — so, never-lie, we point at
-- the game's own accurate source (keystone tooltip / Great Vault) via a hint line.

-- Ensure M+ map/affix data is populated (the per-dungeon reads need it) — request
-- once on login rather than assuming it's already loaded.
do
	local rf = CreateFrame("Frame")
	rf:RegisterEvent("PLAYER_ENTERING_WORLD")
	rf:SetScript("OnEvent", function(self)
		self:UnregisterAllEvents()
		if C_MythicPlus and C_MythicPlus.RequestMapInfo then
			pcall(C_MythicPlus.RequestMapInfo)
		end
	end)
end

--- /mh mplus — a full measured breakdown in chat (a panel is Phase 2, after
--- the per-dungeon API is confirmed in-game).
--- The example reward's item level for one vault slot, or nil.
---
--- ✅ VERIFIED for the dungeon row (Rob, 2026-07-21): the panel read 243 on both
--- filled slots and his Great Vault showed "243 (Heroic)" on exactly those two.
---
--- The two installed addons disagreed about this API, so it was worth checking:
---   • EllesmereUIBlizzardSkin uses it live (GreatVault.lua:750), prepending the
---     number to Blizzard's own difficulty text — the "(Heroic)" is Blizzard's.
---   • Plumber has it COMMENTED OUT: "This default method is unreliable since
---     11.2.0, so we hardcode itemlevel" (API.lua:4526). That is in a DELVE/world
---     context, and the match above says the dungeon row is fine — so read their
---     warning as row-specific, and re-verify before using this for delves.
---
--- Always read from the game, never computed or hardcoded, and it simply does not
--- render when the API returns nothing.
local function ExampleRewardItemLevel(slot)
	if not (slot and slot.id) then
		return nil
	end
	if not (C_WeeklyRewards and C_WeeklyRewards.GetExampleRewardItemHyperlinks) then
		return nil
	end
	local ok, link = pcall(C_WeeklyRewards.GetExampleRewardItemHyperlinks, slot.id)
	if not ok or type(link) ~= "string" or link == "" then
		return nil
	end
	local getIlvl = (C_Item and C_Item.GetDetailedItemLevelInfo) or GetDetailedItemLevelInfo
	if not getIlvl then
		return nil
	end
	local okI, ilvl = pcall(getIlvl, link)
	if okI and type(ilvl) == "number" and ilvl > 0 then
		return ilvl
	end
	return nil
end

--- The Great Vault's DUNGEON row, one entry per slot: { text=, color= }.
--- Shared by /mh keys and the side panel so the two can never drift apart.
---
--- Note what this is NOT: the vault has three rows (Raids / Dungeons / World) and
--- this reads only the dungeon one. Anything showing these lines must say so —
--- Rob's vault had World at 3/4 and Raids at 0/2 while the panel, labelled just
--- "Vault progress", implied it was reporting the lot.
function ns.GetMythicVaultSlotLines()
	local out = {}
	local slots = ReadMythicVaultSlots()
	if not slots then
		return out
	end
	for _, s in ipairs(slots) do
		local best = (s.progress > 0 and s.level and s.level > 0)
			and ((ns:L("MPLUS_CMD_BEST_FMT")):format(s.level))
			or ""
		-- Show the threshold, the way Blizzard's own cards do ("5/8"), instead of a
		-- slot number. s.progress is the TOTAL runs done, so it has to be capped at the
		-- threshold: uncapped it printed "5/1 done" for Rob, which reads like a bug
		-- because it is one — you cannot do 5 of 1.
		local shown = math.min(s.progress or 0, s.threshold or 0)
		local ilvl = ExampleRewardItemLevel(s)
		local text
		if ilvl then
			text = (ns:L("MPLUS_VAULT_SLOT_ILVL_FMT")):format(shown, s.threshold, ilvl, best)
		else
			text = (ns:L("MPLUS_VAULT_SLOT_FMT")):format(shown, s.threshold, best)
		end
		out[#out + 1] = { text = text, color = s.unlocked and "good" or "prog" }
	end
	return out
end

function ns.PrintMythicGain()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s |cff8fd3ff%s|r"):format(prefix, ns:L("MPLUS_CMD_HEADER")))

	if C_MythicPlus and C_MythicPlus.GetOverallDungeonScore then
		local ok, score = pcall(C_MythicPlus.GetOverallDungeonScore)
		if ok and type(score) == "number" and score > 0 then
			print(("   " .. ns:L("MPLUS_CMD_RATING_FMT")):format(math.floor(score + 0.5)))
		end
	end

	local bests = ReadPerDungeonBests()
	local anyRun = false
	for _, d in ipairs(bests or {}) do
		if d.level and d.level > 0 then
			anyRun = true
			break
		end
	end

	-- Say "you have run no keys" FIRST, before any run counts. Rob read the old order
	-- as claiming he had done five Mythic+ runs: the header says "Mythic+ this week",
	-- three lines of run counts followed, and the correction sat six lines further
	-- down where it looked like a contradiction rather than the explanation.
	if bests and #bests > 0 and not anyRun then
		print("   " .. ns:L("MPLUS_CMD_NORUNS_SEASON"))
	end

	-- This week's vault slots — or a gentle "none yet" that still falls through to
	-- the season-wide per-dungeon + gear sections below (they don't need a run
	-- this week; a player who's done nothing this week still wants those).
	local slots = ReadMythicVaultSlots()
	if slots and TotalRuns(slots) > 0 then
		-- Labelled with the same string the side panel uses, so the counts below can
		-- never again be mistaken for keystone runs.
		print(("   |cff8fd3ff%s|r"):format(ns:L("KEYPANEL_TITLE")))
		for _, line in ipairs(ns.GetMythicVaultSlotLines()) do
			print("      " .. line.text)
		end
		print("      |cff9d9d9d" .. ns:L("MPLUS_VAULT_COUNTS_NOTE") .. "|r")
		if anyRun then
			print("   |cff9d9d9d" .. ns:L("MPLUS_CMD_RATING_NOTE") .. "|r")
		end
	else
		print("   " .. ns:L("MPLUS_CMD_NONE"))
	end

	-- Phase 2: per-dungeon season best, lowest first (most rating to gain there).
	-- Skipped entirely when nothing has been run: that case is already stated at the
	-- top, and the list would be eight identical "not run yet" lines followed by a
	-- hint about which to pick first that cannot mean anything yet.
	if bests and #bests > 0 and anyRun then
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

	-- Gear per key level shifts every season and the game's per-level API is
	-- unreliable on 12.x, so point at the accurate in-game source instead of a
	-- number that could be wrong.
	print("   |cff9d9d9d" .. ns:L("MPLUS_CMD_GEAR_HINT") .. "|r")
end
