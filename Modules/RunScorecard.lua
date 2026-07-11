--[[
	Midnight Helper — post-run scorecard.
	When a Midnight delve completes, print one gentle line: which delve + tier,
	the time (with a nudge vs. your own average/record) and deaths. Fed entirely
	by DelveHistory's already-logged data (ns.OnDelveRunLogged) — we recompute
	nothing and invent nothing (never-lie: only what was measured).

	Positive-first tone (Spec 12): the run just happened, so lead with the result,
	not a scolding. Toggle with /mh scorecard (on by default).
]]

local _, ns = ...

local function enabled()
	return not (ns.db and ns.db.runScorecard == false)
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

local function timeNote(summary)
	local dur = summary.duration or 0
	if dur <= 0 then
		return nil
	end
	-- fastestTime is already updated with this run, so a new record means dur == it.
	if summary.runs and summary.runs > 1 and summary.fastestTime and summary.fastestTime > 0 and dur <= summary.fastestTime then
		return ns:L("SCORE_RECORD")
	end
	if summary.runs and summary.runs > 1 then
		local prevAvg = ((summary.totalDuration or 0) - dur) / (summary.runs - 1)
		if prevAvg > 0 then
			if dur < prevAvg then
				return ns:L("SCORE_FASTER")
			elseif dur > prevAvg then
				return ns:L("SCORE_SLOWER")
			end
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

function ns.OnDelveRunLogged(summary)
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
end

-- /mh scorecard — toggle the post-run summary line.
function ns.ToggleRunScorecard()
	ns.db = ns.db or {}
	ns.db.runScorecard = (ns.db.runScorecard == false)
	return ns.db.runScorecard ~= false
end
