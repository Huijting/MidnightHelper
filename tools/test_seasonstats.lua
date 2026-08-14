--[[
	Behavioural test for the Season 2 roll fix in Modules/SeasonStats.lua.

	This is the one change in this batch that REWRITES SAVED PLAYER DATA, so it gets a
	test that runs the shipped code rather than a copy of its logic. The roll is a local
	function, but it is reachable: the module registers PLAYER_ENTERING_WORLD on a frame,
	so stubbing CreateFrame captures the real handler and firing it exercises the real
	path.

	Four states, all of which exist on someone's machine right now:
	  A. counting since before patch day, rolled early  -> merge back, one Season 1 block
	  B. installed after patch day, never rolled        -> relabel as Season 1
	  C. repaired, and then the season really opens     -> roll for real, archive S1
	  D. a genuine Season 2 block                       -> left alone

	Run: lua5.1 scratchpad/test_seasonstats.lua
]]

local SEASON_STARTS = 1787011200 -- 18 Aug 2026 00:00 UTC, same constant the addon uses
local NOW = SEASON_STARTS - 3 * 86400 -- 15 Aug: patch live, season not

local fakeNow = NOW
local captured

_G.time = function(t)
	if t then
		return 0
	end
	return fakeNow
end
_G.date = function()
	return "x"
end
_G.CreateFrame = function()
	local f = {}
	function f:RegisterEvent() end
	function f:SetScript(_, fn)
		captured = fn
	end
	return f
end
_G.C_EventUtils = { IsEventValid = function() return true end }
_G.C_MythicPlus = { GetCurrentSeason = function() return 18 end }

local function freshNs(seasonLive)
	local ns = {
		SEASON2 = { seasonStartsAt = SEASON_STARTS, s1MplusSeasonId = 17 },
		IsSeason2Live = function() return seasonLive end,
	}
	function ns:L(k) return k end
	return ns
end

local function load(ns)
	local chunk = assert(loadfile("Modules/SeasonStats.lua"))
	chunk("MidnightHelper", ns)
end

local fails = {}
local function check(label, cond, detail)
	if not cond then
		fails[#fails + 1] = label .. (detail and ("  -- " .. tostring(detail)) or "")
	end
end

--------------------------------------------------------------------- A
-- Counting since July, rolled at patch time: archive["17"] holds the real Season 1,
-- seasonStats holds a week of Season 1 mislabelled as 18.
do
	local ns = freshNs(false)
	ns.db = {
		seasonStats = { startedAt = NOW - 3 * 86400, seasonId = 18, counts = { deaths = 2, keysRun = 1 } },
		seasonStatsArchive = {
			["17"] = { startedAt = 1753000000, endedAt = NOW - 3 * 86400, counts = { deaths = 40, keysRun = 12 } },
		},
	}
	load(ns)
	captured(nil, "PLAYER_ENTERING_WORLD")
	local s = ns.db.seasonStats
	check("A: relabelled as Season 1", s.seasonId == 17, s.seasonId)
	check("A: counts merged", s.counts.deaths == 42 and s.counts.keysRun == 13,
		tostring(s.counts.deaths) .. "/" .. tostring(s.counts.keysRun))
	check("A: original start date restored", s.startedAt == 1753000000, s.startedAt)
	check("A: stale archive entry removed", ns.db.seasonStatsArchive["17"] == nil)
end

--------------------------------------------------------------------- B
-- Installed after patch day: no archive, block stamped 18 but full of Season 1.
do
	local ns = freshNs(false)
	ns.db = {
		seasonStats = { startedAt = NOW - 86400, seasonId = 18, counts = { deaths = 5 } },
	}
	load(ns)
	captured(nil, "PLAYER_ENTERING_WORLD")
	local s = ns.db.seasonStats
	check("B: relabelled as Season 1", s.seasonId == 17, s.seasonId)
	check("B: counts untouched", s.counts.deaths == 5, s.counts.deaths)
	check("B: nothing archived", ns.db.seasonStatsArchive == nil)
end

--------------------------------------------------------------------- C
-- The season actually opens. The repaired block must now roll for real.
do
	local ns = freshNs(true)
	fakeNow = SEASON_STARTS + 3600
	ns.db = {
		seasonStats = { startedAt = NOW - 3 * 86400, seasonId = 18, counts = { deaths = 7 } },
	}
	load(ns)
	captured(nil, "PLAYER_ENTERING_WORLD")
	local s = ns.db.seasonStats
	local arch = ns.db.seasonStatsArchive
	check("C: fresh Season 2 block", s.seasonId == 18 and next(s.counts) == nil, s.seasonId)
	check("C: Season 1 archived under 17", arch and arch["17"] and arch["17"].counts.deaths == 7)
	check("C: new block starts now", s.startedAt == SEASON_STARTS + 3600, s.startedAt)
	fakeNow = NOW
end

--------------------------------------------------------------------- D
-- A genuine Season 2 block, opened after the season started: do not touch it.
do
	local ns = freshNs(true)
	fakeNow = SEASON_STARTS + 10 * 86400
	ns.db = {
		seasonStats = { startedAt = SEASON_STARTS + 60, seasonId = 18, counts = { deaths = 3 } },
	}
	load(ns)
	captured(nil, "PLAYER_ENTERING_WORLD")
	local s = ns.db.seasonStats
	check("D: left alone", s.seasonId == 18 and s.counts.deaths == 3 and s.startedAt == SEASON_STARTS + 60)
	check("D: nothing archived", ns.db.seasonStatsArchive == nil)
	fakeNow = NOW
end

if #fails > 0 then
	print("FAIL")
	for _, f in ipairs(fails) do
		print("  - " .. f)
	end
	os.exit(1)
end
print("OK - 4 states: early roll merged, late install relabelled, real roll archives, genuine S2 untouched")
