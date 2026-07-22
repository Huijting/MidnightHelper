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

--- Archive the current block if the season changed, so numbers never bleed across.
local function RollSeasonIfNeeded()
	local s = Stats()
	if not s then
		return
	end
	local cur = LiveSeasonId()
	if not cur then
		return -- unknown: leave everything alone rather than archive on a guess
	end
	if s.seasonId == nil then
		s.seasonId = cur
		return
	end
	if s.seasonId ~= cur then
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
