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
	-- fastestTime is already updated with this run, so a new record means dur == it.
	if summary.runs and summary.runs > 1 and summary.fastestTime and summary.fastestTime > 0 and dur <= summary.fastestTime then
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

local function handleRun(summary)
	if not enabled() or type(summary) ~= "table" or not summary.name then
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
			local delta = math.floor((summary.duration - avg) + 0.5)
			print(("   |cff888888%s|r"):format(
				(ns:L("SCORE_DETAIL_FMT")):format(string.format("%+ds", delta), fmtDur(summary.fastestTime))
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
