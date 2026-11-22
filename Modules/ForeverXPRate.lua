local _, ns = ...

--[[
	ForeverXPRate.lua — WoW Forever: XP per hour and the time to your next level, under the XP bar of the overview.

	Rob, 21 Nov 2026 (via sparring, verbatim): "2 en 1, doe maar, daarna 3 en 4 :)". Point 4 = XP per hour + time to the
	next level, with a switch (Quiet helpers, FXPRATE_SW, on unless turned off; account-wide like FREST_SW).

	How it is measured (no guessing, only what the client says):
	  - the XP you gained = the change of UnitXP between two PLAYER_XP_UPDATEs; over a level-up the rest of the old bar
	    (the UnitXPMax seen before) plus the new UnitXP. Kills, quests and exploring all count, as the bar does.
	  - the clock = time you were logged in on THIS character (GetTime while online, kept in SavedVariables), so a
	    night offline or a /reload does not water the number down. Idle time while online DOES count: an honest
	    "per hour of play".
	  - the window = the last 60 minutes of that clock. A number appears once there are at least 5 minutes of it and
	    some XP in it; before that the tooltip says MH is still measuring.
	  - time to level = XP still to go / XP per hour. Not at max level.
	/mh rest xp prints the samples, the window, the rate and why (a quiet line needs a way to see why).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local WINDOW, MIN_SPAN, MAX_SAMPLES = 3600, 300, 400

function ns.IsForeverXPRateOn()
	return not (type(ns.db) == "table" and ns.db.foreverXPRate == false)
end

function ns.SetForeverXPRate(on)
	if type(ns.db) ~= "table" then
		return
	end
	-- plain branches (lint [29])
	if on then
		ns.db.foreverXPRate = nil
	else
		ns.db.foreverXPRate = false
	end
end

local rec -- this character's record: { played = seconds, total = XP gained, samples = { { p, total }, ... } }
local sessionStart, basePlayed
local lastXP, lastMax, lastLevel

local function Record()
	if rec then
		return rec
	end
	if type(ns.db) ~= "table" then
		return nil
	end
	ns.db.foreverXPRateChars = ns.db.foreverXPRateChars or {}
	local t = ns.db.foreverXPRateChars
	local key = ns.ForeverCharKey and ns.ForeverCharKey("xprate", nil, t, { copy = false })
		or (UnitGUID and UnitGUID("player"))
	if not key then
		return nil
	end
	t[key] = t[key] or { played = 0, total = 0, samples = {} }
	rec = t[key]
	return rec
end

local function Played()
	if not (rec and sessionStart) then
		return nil
	end
	return basePlayed + (GetTime() - sessionStart)
end

local function Save()
	local p = Played()
	if p then
		rec.played = p
	end
end

local function Prune()
	local now = Played()
	if not now then
		return
	end
	local s = rec.samples
	-- Keep one sample just before the window as its start; drop the older ones.
	while #s > 2 and s[2][1] <= now - WINDOW do
		table.remove(s, 1)
	end
	while #s > MAX_SAMPLES do
		table.remove(s, 1)
	end
end

local function AddSample()
	local p = Played()
	if not p then
		return
	end
	local s = rec.samples
	s[#s + 1] = { p, rec.total }
	Prune()
	Save()
end

local function ReadBar()
	local cur = UnitXP and UnitXP("player")
	local max = UnitXPMax and UnitXPMax("player")
	local lv = UnitLevel and UnitLevel("player")
	-- max 0 = the bar is not loaded yet; taking it as a start would count the whole bar as just gained.
	if type(cur) ~= "number" or type(max) ~= "number" or type(lv) ~= "number" or max <= 0 then
		return nil
	end
	return cur, max, lv
end

local function OnXP()
	if not rec then
		return
	end
	local cur, max, lv = ReadBar()
	if not cur then
		return
	end
	if lastXP then
		-- 22 Nov 2026: the bar itself says when it rolled over (a new max). UnitLevel alone can lag an update behind
		-- and then counted a whole bar too much.
		local rolled = max ~= lastMax or (lv > lastLevel and cur < lastXP)
		if not rolled and cur < lastXP then
			return -- rolled, but max and level still read old: keep the old start and wait for the next update
		end
		local gained
		if rolled then
			gained = math.max(0, lastMax - lastXP) + cur
		else
			gained = cur - lastXP
		end
		if gained > 0 then
			rec.total = rec.total + gained
			AddSample()
		end
	end
	lastXP, lastMax, lastLevel = cur, max, lv
end

--- XP per hour and seconds to the next level, or nil + the reason.
function ns.ForeverXPRate()
	if IsPlayerAtEffectiveMaxLevel and IsPlayerAtEffectiveMaxLevel() then
		return nil, nil, "max level"
	end
	if not rec or not Played() then
		return nil, nil, "not started yet (no character record)"
	end
	local s, now = rec.samples, Played()
	-- The start: the newest sample at or before the window's edge (60 min of play ago), else the oldest one. The total
	-- does not change between samples, so that sample also holds the total AT the edge: the span is never over an hour
	-- (22 Nov 2026: it was, and three idle hours dragged the next half hour of XP down to a third).
	local base = s[1]
	for _, x in ipairs(s) do
		if x[1] <= now - WINDOW then
			base = x
		end
	end
	if not base then
		return nil, nil, "no samples yet"
	end
	local span = math.min(now - base[1], WINDOW)
	local gained = rec.total - base[2]
	if span < MIN_SPAN then
		return nil, nil, ("only %d s of play measured (need %d)"):format(span, MIN_SPAN)
	end
	if gained <= 0 then
		return nil, nil, ("no XP in the last %d min of play"):format(math.floor(span / 60))
	end
	local rate = gained / span * 3600
	local cur, max = ReadBar()
	local left = cur and max and (max - cur) or nil
	local secs = left and (left / rate * 3600) or nil
	return rate, secs, ("%d XP over %d min of play"):format(gained, math.floor(span / 60))
end

local function Duration(secs)
	local m = math.floor(secs / 60 + 0.5)
	if m < 1 then
		return ns:L("FXPRATE_LT_MIN")
	end
	if m < 60 then
		return ns:L("FXPRATE_MIN_FMT"):format(m)
	end
	return ns:L("FXPRATE_HM_FMT"):format(math.floor(m / 60), m % 60)
end

local function Big(n)
	n = math.floor(n + 0.5)
	if BreakUpLargeNumbers then
		return BreakUpLargeNumbers(n)
	end
	return tostring(n)
end

--- For the overview: the short line under the XP bar and the tooltip line (both nil when switched off or max level).
function ns.ForeverXPRateLines()
	if not ns.IsForeverXPRateOn() then
		return nil, nil
	end
	local rate, secs, why = ns.ForeverXPRate()
	if why == "max level" then
		return nil, nil
	end
	if not rate then
		return nil, ns:L("FXPRATE_MEASURING")
	end
	local lv = UnitLevel and UnitLevel("player") or 0
	local short = secs and ns:L("FXPRATE_SHORT_FMT"):format(lv + 1, Duration(secs)) or nil
	local tip = ns:L("FXPRATE_TIP_FMT"):format(Big(rate)) .. (secs and ("\n" .. ns:L("FXPRATE_TIP_LEVEL_FMT")
		:format(lv + 1, Duration(secs))) or "")
	return short, tip
end

--- /mh rest xp
function ns.ForeverXPRateSlash()
	local rate, secs, why = ns.ForeverXPRate()
	local p = Played()
	print(PREFIX .. ("XP per hour: switch %s; %s"):format(ns.IsForeverXPRateOn() and "on" or "off",
		rate and ("%.0f XP/h, next level in %s"):format(rate, secs and Duration(secs) or "?") or "no number"))
	print(("  why: %s"):format(tostring(why)))
	if rec then
		print(("  this character: %d samples, %d XP counted in all, %.0f min played (counted by MH since it started)")
			:format(#rec.samples, rec.total, (p or rec.played or 0) / 60))
	end
	print(("  window %d min, a number from %d min of play; idle time while logged in counts."):format(WINDOW / 60,
		MIN_SPAN / 60))
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_XP_UPDATE")
ev:RegisterEvent("PLAYER_LOGOUT")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		if not sessionStart and Record() then
			sessionStart, basePlayed = GetTime(), rec.played or 0
			lastXP, lastMax, lastLevel = ReadBar()
			AddSample() -- the clock restarts here: a sample marks where this session's time begins
		end
	elseif event == "PLAYER_XP_UPDATE" then
		OnXP()
	elseif event == "PLAYER_LOGOUT" then
		if rec then
			Save()
		end
	end
end)
