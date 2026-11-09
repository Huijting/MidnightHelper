local _, ns = ...

--[[
	ForeverWeek.lua — WoW Forever: "This week in Forever" on the start page.

	Rob, 9 Nov 2026: "ook de Forever versie heeft deze week, maar volgens mij hebben wij niet echt dingen die we moeten
	doen elke week in Forever. Zoek dat maar uit." → research (mh-research, 9 Nov) → "Ja, ik volg jouw adviezen".

	What it shows, all read from the client at the moment you look (no rotation or dates of our own in the code):
	  1. When the weekly and the daily reset come (C_DateAndTime; Blizzard has not published Forever's reset time,
	     so we ask the client instead of writing "Wednesday").
	  2. What the game's own calendar has today (holidays: Darkmoon Faire, the battleground of the week, the fishing
	     contest ...), with the first sentence of Blizzard's own description: that text is in the player's language.
	  3. This character's raid lockouts (GetSavedInstanceInfo). Before 9 Dec 2026 (raids open, Blizzard 20 Oct) one line
	     that says so.
	  4. Two fixed lines on what counts per week or day that the calendar does not show: the PvP rank cap (Blizzard
	     7 Oct) and the crafting writs (once a day each, Wowhead + conquestcapped).
	⚠️ AFGELEID, not measured in the Forever client: that these APIs answer there. Every call is guarded; a missing answer
	   leaves its line out. /mh week prints the raw answers and keeps them in ns.db.foreverWeekDump (a quiet module needs
	   a way to see that it was quiet on purpose).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local RAIDS_OPEN = { year = 2026, month = 12, day = 9 }

local function Secret(v)
	return issecretvalue and issecretvalue(v)
end

local function Duration(seconds)
	seconds = tonumber(seconds)
	if not seconds or Secret(seconds) or seconds <= 0 then
		return nil
	end
	local d = math.floor(seconds / 86400)
	local h = math.floor((seconds % 86400) / 3600)
	local m = math.floor((seconds % 3600) / 60)
	if d > 0 then
		return ("%dd %dh"):format(d, h)
	end
	if h > 0 then
		return ("%dh %dm"):format(h, m)
	end
	return ("%dm"):format(math.max(m, 1))
end

local function Seconds(fnName)
	local f = C_DateAndTime and C_DateAndTime[fnName]
	if type(f) ~= "function" then
		return nil, "no " .. fnName
	end
	local ok, s = pcall(f)
	if not ok then
		return nil, "error"
	end
	if Secret(s) then
		return nil, "secret"
	end
	return tonumber(s), tostring(s)
end

local function Now()
	if not (C_DateAndTime and C_DateAndTime.GetCurrentCalendarTime) then
		return nil
	end
	local ok, t = pcall(C_DateAndTime.GetCurrentCalendarTime)
	if ok and type(t) == "table" and not Secret(t.monthDay) then
		return t
	end
	return nil
end

local function BeforeRaidsOpen(t)
	if not t then
		return false
	end
	local a = (t.year or 0) * 10000 + (t.month or 0) * 100 + (t.monthDay or 0)
	return a < RAIDS_OPEN.year * 10000 + RAIDS_OPEN.month * 100 + RAIDS_OPEN.day
end

--- First sentence of a Blizzard description, without markup, at most ~140 characters.
local function FirstSentence(s)
	if type(s) ~= "string" or Secret(s) or s == "" then
		return nil
	end
	s = s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|n", " "):gsub("\r?\n", " "):gsub("^%s+", "")
	local first = s:match("^(.-[%.!%?])%s") or s
	if #first > 140 then
		first = first:sub(1, 137):gsub("%s+%S*$", "") .. "..."
	end
	return first
end

local function ShortDate(t)
	if type(t) ~= "table" or not t.monthDay or Secret(t.monthDay) then
		return nil
	end
	if FormatShortDate then
		local ok, s = pcall(FormatShortDate, t.monthDay, t.month)
		if ok and type(s) == "string" then
			return s
		end
	end
	return ("%d/%d"):format(t.monthDay, t.month or 0)
end

--------------------------------------------------------------------------------
-- The calendar. It answers only after OpenCalendar() and CALENDAR_UPDATE_EVENT_LIST, and only for the month it has
-- selected: we never move it while the player has the calendar open (HandyNotes does the same).
--------------------------------------------------------------------------------
local calendarAsked = false

local function AskCalendar()
	if not (C_Calendar and C_Calendar.OpenCalendar) then
		return
	end
	local t = Now()
	if t and C_Calendar.SetAbsMonth and not (_G.CalendarFrame and _G.CalendarFrame:IsVisible()) then
		pcall(C_Calendar.SetAbsMonth, t.month, t.year)
	end
	pcall(C_Calendar.OpenCalendar)
	calendarAsked = true
end

local function MonthOffset(t)
	if not (C_Calendar and C_Calendar.GetMonthInfo) then
		return 0
	end
	local ok, sel = pcall(C_Calendar.GetMonthInfo)
	if not ok or type(sel) ~= "table" or not sel.month then
		return 0
	end
	return (t.month - sel.month) + (t.year - sel.year) * 12
end

--- Today's holidays: { title, about, ends, eventID, calendarType }. nil = the calendar did not answer (yet).
local function TodayEvents()
	if not (C_Calendar and C_Calendar.GetNumDayEvents and C_Calendar.GetDayEvent) then
		return nil, "no C_Calendar"
	end
	if InChatMessagingLockdown and InChatMessagingLockdown() then
		return nil, "chat lockdown" -- GetDayEvent returns secrets then (HandyNotes_WarWithin, conditions.lua)
	end
	local t = Now()
	if not t then
		return nil, "no date"
	end
	local off = MonthOffset(t)
	local okN, n = pcall(C_Calendar.GetNumDayEvents, off, t.monthDay)
	if not okN or type(n) ~= "number" or Secret(n) then
		return nil, "no count"
	end
	local out, seen = {}, {}
	for i = 1, n do
		local ok, e = pcall(C_Calendar.GetDayEvent, off, t.monthDay, i)
		if ok and type(e) == "table" and not Secret(e.title) and type(e.title) == "string" then
			if e.calendarType == "HOLIDAY" and not seen[e.title] then
				seen[e.title] = true
				local about
				if C_Calendar.GetHolidayInfo then
					local okH, h = pcall(C_Calendar.GetHolidayInfo, off, t.monthDay, i)
					if okH and type(h) == "table" then
						about = FirstSentence(h.description)
					end
				end
				out[#out + 1] = { title = e.title, about = about, ends = ShortDate(e.endTime), eventID = e.eventID,
					calendarType = e.calendarType }
			end
		end
	end
	return out, ("%d events, offset %d"):format(n, off)
end

--------------------------------------------------------------------------------
-- Raid lockouts of this character.
--------------------------------------------------------------------------------
local raidAsked = false

local function Lockouts()
	if not (GetNumSavedInstances and GetSavedInstanceInfo) then
		return nil
	end
	local okN, n = pcall(GetNumSavedInstances)
	if not okN or type(n) ~= "number" or Secret(n) then
		return nil
	end
	local out = {}
	for i = 1, n do
		local ok, name, _, reset, _, locked, _, _, isRaid, _, _, numEnc, encDone = pcall(GetSavedInstanceInfo, i)
		if ok and locked and isRaid and type(name) == "string" and not Secret(name) then
			out[#out + 1] = { name = name, reset = reset, total = numEnc, done = encDone }
		end
	end
	return out
end

--------------------------------------------------------------------------------
-- The rows for HomeDashboard.lua: { text, tone } with tone = "soft" | "dim" | "warn" | "good".
--------------------------------------------------------------------------------
function ns.ForeverWeekRows()
	local rows = {}
	local function add(text, tone)
		rows[#rows + 1] = { text = text, tone = tone or "soft" }
	end
	if not calendarAsked then
		AskCalendar()
	end
	if not raidAsked and RequestRaidInfo then
		pcall(RequestRaidInfo)
		raidAsked = true
	end

	local week = Duration((Seconds("GetSecondsUntilWeeklyReset")))
	local day = Duration((Seconds("GetSecondsUntilDailyReset")))
	if week then
		add(ns:L("FWEEK_RESET_WEEK_FMT"):format(week), "warn")
	end
	if day then
		add(ns:L("FWEEK_RESET_DAY_FMT"):format(day), "dim")
	end
	if not week and not day then
		add(ns:L("FWEEK_RESET_UNKNOWN"), "dim")
	end

	local events = TodayEvents()
	if events then
		if #events == 0 then
			add(ns:L("FWEEK_EVENTS_NONE"), "dim")
		end
		for _, e in ipairs(events) do
			add(e.ends and ns:L("FWEEK_EVENT_UNTIL_FMT"):format(e.title, e.ends) or e.title, "good")
			if e.about then
				add("   " .. e.about, "dim")
			end
		end
	end

	local raids = Lockouts()
	if BeforeRaidsOpen(Now()) and not (raids and #raids > 0) then
		add(ns:L("FWEEK_RAIDS_SOON"), "dim")
	elseif raids then
		if #raids == 0 then
			add(ns:L("FWEEK_RAIDS_NONE"), "dim")
		end
		for _, r in ipairs(raids) do
			add(ns:L("FWEEK_RAID_FMT"):format(r.name, tonumber(r.done) or 0, tonumber(r.total) or 0,
				Duration(r.reset) or "?"), "soft")
		end
	end

	add(ns:L("FWEEK_PVP_FMT"):format(_G.HONOR or "Honor"), "dim")
	add(ns:L("FWEEK_WRITS"), "dim")
	return rows
end

--- One short line for the Me room card.
function ns.ForeverWeekStatus()
	local week = Duration((Seconds("GetSecondsUntilWeeklyReset")))
	return week and ns:L("FWEEK_STATUS_FMT"):format(week) or nil
end

--- /mh week: the raw answers, in chat and in ns.db.foreverWeekDump (read the SavedVariables after /reload).
function ns.ForeverWeekSlash()
	AskCalendar()
	if RequestRaidInfo then
		pcall(RequestRaidInfo)
	end
	local dump = { when = date and date("%Y-%m-%d %H:%M") or "?" }
	local w, wRaw = Seconds("GetSecondsUntilWeeklyReset")
	local d, dRaw = Seconds("GetSecondsUntilDailyReset")
	dump.weekly, dump.daily = wRaw, dRaw
	print(PREFIX .. ("weekly reset: %s (%s)  daily reset: %s (%s)"):format(Duration(w) or "-", tostring(wRaw),
		Duration(d) or "-", tostring(dRaw)))
	local t = Now()
	dump.today = t and ("%d-%02d-%02d %02d:%02d"):format(t.year, t.month, t.monthDay, t.hour or 0, t.minute or 0) or "nil"
	print(PREFIX .. "calendar date (realm): " .. dump.today)
	-- Everything the calendar has today, not only holidays: we need the types and ids before we explain more.
	dump.events = {}
	if t and C_Calendar and C_Calendar.GetNumDayEvents then
		local off = MonthOffset(t)
		local okN, n = pcall(C_Calendar.GetNumDayEvents, off, t.monthDay)
		print(PREFIX .. ("calendar: %s events today (month offset %d)"):format(okN and tostring(n) or "error", off))
		if okN and type(n) == "number" and not Secret(n) then
			for i = 1, n do
				local ok, e = pcall(C_Calendar.GetDayEvent, off, t.monthDay, i)
				if ok and type(e) == "table" then
					local line = ("%s | %s | id %s | %s"):format(tostring(e.title), tostring(e.calendarType),
						tostring(e.eventID), tostring(e.sequenceType))
					dump.events[#dump.events + 1] = line
					print("   " .. line)
				end
			end
		end
	else
		print(PREFIX .. "calendar: no C_Calendar or no date")
	end
	local raids = Lockouts()
	dump.raids = {}
	print(PREFIX .. ("raid lockouts: %s"):format(raids and tostring(#raids) or "no API"))
	for _, r in ipairs(raids or {}) do
		local line = ("%s %s/%s reset %s"):format(r.name, tostring(r.done), tostring(r.total), tostring(r.reset))
		dump.raids[#dump.raids + 1] = line
		print("   " .. line)
	end
	if ns.db then
		ns.db.foreverWeekDump = dump
	end
	print(PREFIX .. "Saved in MidnightHelperDB.foreverWeekDump (after /reload). The calendar can need a second /mh week.")
end

--------------------------------------------------------------------------------
-- Redraw the start page when the calendar or the raid info arrives.
--------------------------------------------------------------------------------
local ev = CreateFrame("Frame")
local function Redraw()
	-- Only while the window is open: the calendar event fires often, and the page is rebuilt when it opens anyway.
	if ns.RefreshHomePanel and _G.MidnightHelperMainUI and _G.MidnightHelperMainUI:IsShown() then
		pcall(ns.RefreshHomePanel)
	end
end
for _, e in ipairs({ "CALENDAR_UPDATE_EVENT_LIST", "UPDATE_INSTANCE_INFO", "PLAYER_ENTERING_WORLD" }) do
	pcall(ev.RegisterEvent, ev, e) -- Forever may not know every event (not measured)
end
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		ev:UnregisterEvent("PLAYER_ENTERING_WORLD")
		AskCalendar()
		if RequestRaidInfo then
			pcall(RequestRaidInfo)
			raidAsked = true
		end
		return
	end
	Redraw()
end)
