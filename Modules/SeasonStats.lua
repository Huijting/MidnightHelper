local _, ns = ...

--[[
	Midnight Helper — season stats collector (groundwork for a season retrospective).

	This module only COLLECTS. There is deliberately no "your season in review"
	screen yet, because there would be nothing honest to put in it: MH has never kept
	season-long history, so any retrospective shown today would be empty or invented.
	Start counting now, show it when there is a season's worth to show.

	Stored in ns.db.seasonStats = {
	    startedAt = unixTime,     -- when counting began, so the display can say so
	    seasonId  = <number|nil>, -- reset marker; nil until the season id is known
	    counts    = { [key] = n },
	}

	SEASON ID SOURCE — C_MythicPlus.GetCurrentSeason(), the same call SeasonTransition
	reads for its self-learning gate (SeasonTransition.lua ~212). The handoff draft
	called ns.GetCurrentSeasonId(), which does not exist in this addon; that would
	have silently disabled the roll-over forever, so old-season numbers would quietly
	accumulate under the new season's heading -- exactly the thing the archive is for.

	Never-lie:
	  • Every counter is incremented from an event we actually receive. Nothing is
	    estimated, back-filled or extrapolated.
	  • startedAt exists so the eventual screen can say "since 22 July" instead of
	    implying it covers the player's whole career.
	  • When the season id changes the old block is archived, not silently reused --
	    a Season 1 number must never appear under a Season 2 heading.
	  • An unknown season id changes nothing. We would rather keep counting into the
	    current block than archive on a guess.
	  • Counters MH cannot observe (turn-ins, offline activity) are simply absent. An
	    absent counter is honest; a zero would not be.
]]

local function Stats()
	if not ns.db then
		return nil
	end
	ns.db.seasonStats = ns.db.seasonStats or {}
	local s = ns.db.seasonStats
	s.counts = s.counts or {}
	if not s.startedAt then
		s.startedAt = (time and time()) or 0
	end
	return s
end

--- The live M+ season number, or nil when the game will not tell us.
local function LiveSeasonId()
	if not (C_MythicPlus and C_MythicPlus.GetCurrentSeason) then
		return nil
	end
	local ok, cur = pcall(C_MythicPlus.GetCurrentSeason)
	if not ok or type(cur) ~= "number" or cur <= 0 then
		return nil
	end
	return cur
end

--- ⚠️ THE SEASON ID MOVES WITH THE PATCH, NOT WITH THE SEASON. Read this before
--- "simplifying" the roll below back to a plain id comparison.
---
--- Measured on live 13 Aug 2026, five days before Season 2 opened:
--- `C_MythicPlus.GetCurrentSeason()` already returned **18** against 17 for Season 1
--- (`Modules/SeasonTransitionData.lua:246` carries the same measurement and the same
--- warning). So the id changed on patch day, 11/12 Aug, and this module rolled then —
--- a week early, in the middle of Season 1.
---
--- The damage is not cosmetic. The block that would be labelled "Season 2" opened on
--- patch day and holds a week of Season 1 keys, deaths and boss kills, and it will
--- never roll again because it already carries the new id. That is exactly what the
--- never-lie note at the top of this file forbids: *a Season 1 number must never appear
--- under a Season 2 heading.*
---
--- So the roll now needs BOTH: the id must have changed AND the shared season gate must
--- agree that the season has actually opened. The gate is date-driven
--- (`ns.SEASON2.seasonStartsAt`) and is the only signal in this addon that means "the
--- season started" rather than "the patch landed".
local function SeasonHasActuallyOpened()
	if ns.IsSeason2Live then
		return ns.IsSeason2Live() and true or false
	end
	return false -- no gate loaded: never archive on a guess
end

--- ⚠️ ONE-OFF REPAIR of the early roll described above. Runs before the roll.
---
--- Two shapes exist in the wild, both created before the season opened, both carrying
--- the NEW id on a block full of OLD data:
---   1. the player was counting before patch day  → the S1 block was archived and a new
---      block opened. Merge the new block's counts back into the archived one.
---   2. the player installed after patch day      → there is no archive, just a fresh
---      block stamped with the new id.
---
--- In both cases the honest label for data collected before `seasonStartsAt` is the
--- PREVIOUS season, and `s1MplusSeasonId` is a measured constant, not a guess. After the
--- repair the ordinary roll fires correctly at the season boundary and archives the
--- whole of Season 1 in one piece.
---
--- Counts are summed rather than replaced: both halves are real events this player had.
local function RepairEarlyRoll()
	local s = ns.db and ns.db.seasonStats
	if not s or type(s.counts) ~= "table" then
		return
	end
	local startsAt = ns.SEASON2 and ns.SEASON2.seasonStartsAt
	local prevId = ns.SEASON2 and ns.SEASON2.s1MplusSeasonId
	if not (startsAt and prevId) then
		return
	end
	-- Only blocks that were OPENED before the season began are suspect. A block opened
	-- after `seasonStartsAt` is a genuine Season 2 block and must be left alone.
	if (tonumber(s.startedAt) or 0) >= startsAt then
		return
	end
	if s.seasonId == prevId then
		return -- already correct (or already repaired)
	end

	local archive = ns.db.seasonStatsArchive
	local prev = archive and archive[tostring(prevId)]
	if type(prev) == "table" and type(prev.counts) == "table" then
		for k, v in pairs(s.counts) do
			prev.counts[k] = (tonumber(prev.counts[k]) or 0) + (tonumber(v) or 0)
		end
		s.counts = prev.counts
		s.startedAt = tonumber(prev.startedAt) or s.startedAt
		archive[tostring(prevId)] = nil
	end
	s.seasonId = prevId
end

--- Archive the current block if the season changed, so numbers never bleed across.
local function RollSeasonIfNeeded()
	local s = Stats()
	if not s then
		return
	end
	RepairEarlyRoll()
	s = Stats() -- RepairEarlyRoll may have rewritten counts/startedAt
	local cur = LiveSeasonId()
	if not cur then
		return -- unknown: leave everything alone rather than archive on a guess
	end
	if s.seasonId == nil then
		s.seasonId = cur
		return
	end
	if s.seasonId ~= cur then
		if not SeasonHasActuallyOpened() then
			-- The id moved with the patch. Keep counting into the current block; the
			-- roll will happen for real when the season opens.
			return
		end
		ns.db.seasonStatsArchive = ns.db.seasonStatsArchive or {}
		ns.db.seasonStatsArchive[tostring(s.seasonId)] = {
			counts = s.counts,
			startedAt = s.startedAt,
			endedAt = (time and time()) or 0,
		}
		ns.db.seasonStats = {
			startedAt = (time and time()) or 0,
			seasonId = cur,
			counts = {},
		}
	end
end

--- Add to a counter. Public so other modules can feed it without duplicating state.
function ns.BumpSeasonStat(key, by)
	if type(key) ~= "string" then
		return
	end
	local s = Stats()
	if not s then
		return
	end
	s.counts[key] = (s.counts[key] or 0) + (tonumber(by) or 1)
end

--- @return table counts, number startedAt  — for the eventual retrospective screen.
function ns.GetSeasonStats()
	local s = Stats()
	if not s then
		return {}, 0
	end
	return s.counts, s.startedAt or 0
end

--------------------------------------------------------------------------------
-- collection
--------------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("NEW_MOUNT_ADDED")
f:RegisterEvent("PLAYER_DEAD")
for _, ev in ipairs({ "CHALLENGE_MODE_COMPLETED", "ENCOUNTER_END" }) do
	if not C_EventUtils or not C_EventUtils.IsEventValid or C_EventUtils.IsEventValid(ev) then
		pcall(f.RegisterEvent, f, ev)
	end
end

f:SetScript("OnEvent", function(_, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		pcall(RollSeasonIfNeeded)
		return
	end
	if event == "NEW_MOUNT_ADDED" then
		ns.BumpSeasonStat("mounts")
		return
	end
	if event == "PLAYER_DEAD" then
		ns.BumpSeasonStat("deaths")
		return
	end
	if event == "CHALLENGE_MODE_COMPLETED" then
		ns.BumpSeasonStat("keysRun")
		-- Same unverified API as the milestone: guarded, and "timed" is only counted
		-- on an explicit true. A key we cannot read counts as run, never as timed.
		if C_ChallengeMode and C_ChallengeMode.GetChallengeCompletionInfo then
			local ok, info = pcall(C_ChallengeMode.GetChallengeCompletionInfo)
			if ok and type(info) == "table" and info.onTime == true then
				ns.BumpSeasonStat("keysTimed")
			end
		end
		return
	end
	if event == "ENCOUNTER_END" then
		-- ENCOUNTER_END: encounterID, name, difficultyID, groupSize, success
		local _, _, _, _, success = ...
		if success == 1 or success == true then
			ns.BumpSeasonStat("bossKills")
		end
		return
	end
end)

--- /mh season stats — what has been counted so far, and since when.
function ns.PrintSeasonStats()
	local counts, since = ns.GetSeasonStats()
	local prefix = "|cffe8c36aMidnight Helper|r"
	local when = (date and type(since) == "number" and since > 0) and date("%d/%m/%Y", since) or "?"
	print(("%s — %s"):format(prefix, (ns:L("SEASONSTATS_SINCE_FMT")):format(when)))
	-- Sorted, so two runs of the command are comparable line by line.
	local keys = {}
	for k in pairs(counts) do
		keys[#keys + 1] = k
	end
	table.sort(keys)
	for _, k in ipairs(keys) do
		print(("   %s: %d"):format(k, counts[k]))
	end
	if #keys == 0 then
		print("   " .. ns:L("SEASONSTATS_EMPTY"))
	end
end
