--[[
	Midnight Helper — post-run scorecard.
	When a Midnight delve or ritual completes, print one gentle line: which run +
	tier, the time (with a nudge vs. your own average/record) and deaths. Fed
	entirely by DelveHistory / RitualLog's already-logged data (ns.OnDelveRunLogged
	/ ns.OnRitualRunLogged) — we recompute nothing and invent nothing (never-lie:
	only what was measured).

	Two framings (Spec 12): the default line is warm and beginner-safe; /mh scorecard
	detail adds a die-hard second line with the exact seconds delta + fastest time.
	Positive-first tone. Toggle the whole thing with /mh scorecard (on by default).
]]

local _, ns = ...

local function enabled()
	return not (ns.db and ns.db.runScorecard == false)
end

local function detailOn()
	return ns.db and ns.db.scorecardDetail == true
end

local function fmtDur(sec)
	sec = math.floor(sec or 0)
	if sec <= 0 then
		return "--"
	end
	if sec < 60 then
		return sec .. "s"
	end
	return string.format("%dm %02ds", math.floor(sec / 60), sec % 60)
end

-- average of the runs BEFORE this one (0 if this is the first run)
local function prevAverage(summary)
	if summary.runs and summary.runs > 1 then
		local prior = (summary.totalDuration or 0) - (summary.duration or 0)
		return prior / (summary.runs - 1)
	end
	return 0
end

local function timeNote(summary)
	local dur = summary.duration or 0
	if dur <= 0 then
		return nil
	end
	if summary.tierCounts ~= nil then
		-- A delve: records count per tier (DelveHistory.lua, 29 Oct 2026), so a Tier 1 run is no "fastest yet" next to
		-- Tier 11 runs any more.
		if summary.tierRecord then
			return ns:L("SCORE_RECORD")
		end
	elseif summary.runs and summary.runs > 1 and summary.fastestTime and summary.fastestTime > 0 and dur <= summary.fastestTime then
		-- A ritual: fastestTime is already updated with this run, so a new record means dur == it.
		return ns:L("SCORE_RECORD")
	end
	local avg = prevAverage(summary)
	if avg > 0 then
		if dur < avg then
			return ns:L("SCORE_FASTER")
		elseif dur > avg then
			return ns:L("SCORE_SLOWER")
		end
	end
	return nil
end

local function deathNote(deaths)
	deaths = deaths or 0
	if deaths <= 0 then
		return ns:L("SCORE_NO_DEATHS")
	elseif deaths == 1 then
		return ns:L("SCORE_DEATHS_ONE")
	end
	return (ns:L("SCORE_DEATHS_FMT")):format(deaths)
end

local function clock(sec)
	sec = math.max(0, math.floor((sec or 0) + 0.5))
	return ("%d:%02d"):format(math.floor(sec / 60), sec % 60)
end

local STAR = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14|t"

function ns.IsDelveRecordNoticeEnabled()
	return not (ns.db and ns.db.delveRecordNotice == false)
end

function ns.SetDelveRecordNoticeEnabled(on)
	ns.db = ns.db or {}
	ns.db.delveRecordNotice = on and true or false
end

--- Design D (Rob, 29 Oct 2026: "By deze zeg ik go"): after a normal delve, 8 seconds in the middle of the screen, the
--- same notice the Labyrinth splits use. Not for rituals and not for the Labyrinth (it has its own splits).
local function recordNotice(summary)
	if not ns.IsDelveRecordNoticeEnabled() or summary.tierCounts == nil or summary.rooms or not ns.ShowBriefNotice then
		return
	end
	local dur = summary.duration or 0
	if dur <= 0 then
		return
	end
	local head = summary.name
	if (summary.tier or 0) > 0 then
		head = (ns:L("DELVE_NOTICE_HEAD_FMT")):format(summary.name, summary.tier)
	end
	local lines = { head, "|cffffffff" .. clock(dur) .. "|r" }
	if summary.tierCounts then
		if summary.tierFirst then
			lines[3] = "|cffb8ad96" .. (ns:L("DELVE_NOTICE_FIRST_FMT")):format(summary.tier) .. "|r"
		elseif summary.tierRecord then
			lines[3] = "|cff6fe06f" .. (ns:L("DELVE_NOTICE_RECORD_FMT")):format(STAR,
				clock(summary.tierPrevBest - dur), clock(summary.tierPrevBest)) .. "|r"
		elseif summary.tierPrevBest and dur > summary.tierPrevBest then
			lines[3] = "|cffff8a7a" .. (ns:L("DELVE_NOTICE_SLOWER_FMT")):format(
				clock(dur - summary.tierPrevBest), clock(summary.tierPrevBest)) .. "|r"
		else
			lines[3] = "|cffb8ad96" .. ns:L("DELVE_NOTICE_EQUAL") .. "|r"
		end
	end
	ns.ShowBriefNotice(table.concat(lines, "\n"), 8)
end

local function handleRun(summary)
	if type(summary) ~= "table" or not summary.name then
		return
	end
	recordNotice(summary)
	if not enabled() then
		return
	end
	local head = summary.name
	if summary.tier and summary.tier > 0 then
		head = head .. " " .. (ns:L("SCORE_TIER_FMT")):format(summary.tier)
	end
	local timePart = fmtDur(summary.duration)
	local note = timeNote(summary)
	if note then
		timePart = timePart .. " (" .. note .. ")"
	end
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s %s — %s · %s"):format(prefix, head, timePart, deathNote(summary.deaths)))

	-- die-hard detail: exact delta vs your average + your fastest, greyed.
	if detailOn() then
		local avg = prevAverage(summary)
		if avg > 0 and (summary.duration or 0) > 0 then
			-- As a time, not raw seconds (Rob, 27 Oct 2026: "vs avg -2173s" after an 86-minute Labyrinth run).
			local delta = math.floor((summary.duration - avg) + 0.5)
			local deltaText = delta == 0 and "0s" or ((delta < 0 and "-" or "+") .. fmtDur(math.abs(delta)))
			-- "fastest" = the record on THIS tier for a delve (before this run, or this run if it set one).
			local fastest = summary.fastestTime
			if summary.tierCounts then
				fastest = (summary.tierRecord or summary.tierFirst) and summary.duration or summary.tierPrevBest
			end
			print(("   |cff888888%s|r"):format(
				(ns:L("SCORE_DETAIL_FMT")):format(deltaText, fmtDur(fastest))
			))
		end
	end
end

ns.OnDelveRunLogged = handleRun
ns.OnRitualRunLogged = handleRun

-- /mh scorecard — toggle the post-run summary line.
function ns.ToggleRunScorecard()
	ns.db = ns.db or {}
	ns.db.runScorecard = (ns.db.runScorecard == false)
	return ns.db.runScorecard ~= false
end

-- /mh scorecard detail — toggle the die-hard detail line.
function ns.ToggleScorecardDetail()
	ns.db = ns.db or {}
	ns.db.scorecardDetail = not (ns.db.scorecardDetail == true)
	return ns.db.scorecardDetail == true
end

-- /mh scorecard test — fire a sample scorecard so you can see the format (and the
-- detail line) without finishing a real delve. Sample: run 3, this one faster than
-- the prior average but not a record.
function ns.TestRunScorecard()
	handleRun({
		name = "Test Delve",
		tier = 5,
		duration = 252, -- 4m 12s
		deaths = 1,
		runs = 3,
		fastestTime = 234, -- 3m 54s
		totalDuration = 800, -- prior avg = (800-252)/2 = 274s -> "faster than average"
		-- Per tier: a new record against 4:30, so the on-screen notice (design D) shows too, through the same door.
		tierCounts = true,
		tierPrevBest = 270,
		tierRecord = true,
	})
end
