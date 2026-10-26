local _, ns = ...

--[[
	Midnight Helper — Labyrinth splits: race your own best time, room by room.

	Rob, 26 Oct 2026: "Kan je nog iets bedenken … iets spannends … iets wat anderen niet hebben?" → "begin maar met
	nummer 1". Speedrunners call it splits: after every room the screen says how long it took and how that compares to
	your best for that room, and when you leave there is a list with where the time went.

	Facts this rests on:
	  • The Labyrinth finishes ONE SCENARIO PER ROOM (DelveHistory.lua ROOM_RUN_DELVES, MEASURED 17 Oct 2026 in Rob's
	    SavedVariables: one entry per room, back to back). So SCENARIO_COMPLETED on the Labyrinth's maps = a room done.
	  • Maps: 2647 = the rooms, 2648 = Kindo'jan's platform (LabyrinthHexmask.lua, measured 25 Oct 2026).
	  • The room's name = GetSubZoneText() at that moment (the same source LabyrinthHexmask matches on).
	A split = the time from the previous room's end (or from entering the Labyrinth) to this room's end, so walking and
	the loading screen between rooms count, as in any speedrun. Clock: time() (wall clock), so a /reload keeps the run.

	Bests are kept per Tier and per room name (ns.db.labSplits.best[tier][room]): a Tier 8 room is not a Tier 11 room.
	A room without a name is timed but never becomes a best (its "Room 3" would mean a different room next run).

	It can stay silent (off, not in the Labyrinth, no start time), so `/mh labsplits` prints the decision and the reason
	(CLAUDE.md: build a way to see that it stayed silent).
]]

local LAB_MAP, LAB_BOSS_MAP = 2647, 2648
local MAX_SPLIT = 2 * 60 * 60 -- CHOSEN: longer than any room; anything above is a logout gap, not a room
local MIN_SPLIT = 5 -- CHOSEN: two completions closer than this are one room reported twice

local lastWhy = "nothing yet"

local function L(key)
	return (ns.L and ns:L(key)) or key
end

local function DB()
	ns.db = ns.db or {}
	ns.db.labSplits = ns.db.labSplits or {}
	local d = ns.db.labSplits
	d.best = d.best or {}
	return d
end

function ns.IsLabSplitsEnabled()
	return DB().off ~= true
end

function ns.SetLabSplitsEnabled(on)
	DB().off = (not on) and true or nil
end

local function PlayerMap()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil
	end
	local ok, m = pcall(C_Map.GetBestMapForUnit, "player")
	return ok and m or nil
end

local function InLabyrinth()
	local m = PlayerMap()
	return m == LAB_MAP or m == LAB_BOSS_MAP
end

local function RoomHere()
	if not GetSubZoneText then
		return nil
	end
	local ok, z = pcall(GetSubZoneText)
	if ok and type(z) == "string" and z ~= "" and not (issecretvalue and issecretvalue(z)) then
		return z
	end
	return nil
end

local function Tier()
	if not ns.GetCurrentDelveRun then
		return 0
	end
	local _, t = ns.GetCurrentDelveRun()
	return tonumber(t) or 0
end

local function Clock(sec)
	sec = math.max(0, math.floor((sec or 0) + 0.5))
	return ("%d:%02d"):format(math.floor(sec / 60), sec % 60)
end

local function Say(msg, onScreen)
	if onScreen and ns.ShowBriefNotice then
		ns.ShowBriefNotice(msg, 8)
	end
	print(("%s %s"):format(L("PRINT_PREFIX"), msg))
end

--- Start timing when you are in the Labyrinth and no run is being timed (or the stored one is stale).
--- `partial`: we joined a run already under way (a /reload with nothing stored, e.g. the first time with this version),
--- so the room we are in has no honest start: its time is not compared and never becomes a best.
local function EnsureRun(now, partial)
	local d = DB()
	local a = d.active
	if a and (now - (a.last or 0)) <= MAX_SPLIT then
		return a
	end
	d.active = { started = now, last = now, rooms = {}, records = 0, partial = partial or nil }
	return d.active
end

local function RoomDone()
	if not ns.IsLabSplitsEnabled() then
		lastWhy = "switched off"
		return
	end
	if not InLabyrinth() then
		lastWhy = "a scenario ended outside the Labyrinth maps"
		return
	end
	local now = time()
	local d = DB()
	local a = d.active
	if not a or a.partial then
		-- We never saw this room start (MH was off, or joined mid-run): time from here on, this room gets no time.
		a = EnsureRun(now)
		a.partial, a.last = nil, now
		lastWhy = "room done, but its start was not seen: timing from now"
		return
	end
	local secs = now - (a.last or now)
	if secs < MIN_SPLIT then
		lastWhy = ("ignored: %d s after the previous room"):format(secs)
		return
	end
	a.last = now
	if secs > MAX_SPLIT then
		lastWhy = ("ignored: %s since the last mark (a logout?)"):format(Clock(secs))
		return
	end

	local room = RoomHere()
	local tier = Tier()
	local label = room or (L("LAB_SPLITS_ROOM_N_FMT")):format(#a.rooms + 1)
	local best
	local msg
	if room then
		d.best[tier] = d.best[tier] or {}
		best = d.best[tier][room]
		if not best then
			d.best[tier][room] = secs
			msg = (L("LAB_SPLITS_FIRST_FMT")):format(label, Clock(secs), tier)
		elseif secs < best then
			d.best[tier][room] = secs
			a.records = (a.records or 0) + 1
			msg = (L("LAB_SPLITS_FASTER_FMT")):format(label, Clock(secs), Clock(best - secs), Clock(best))
		elseif secs == best then
			msg = (L("LAB_SPLITS_EQUAL_FMT")):format(label, Clock(secs))
		else
			msg = (L("LAB_SPLITS_SLOWER_FMT")):format(label, Clock(secs), Clock(secs - best), Clock(best))
		end
	else
		msg = (L("LAB_SPLITS_NO_NAME_FMT")):format(label, Clock(secs))
	end
	a.rooms[#a.rooms + 1] = { room = label, secs = secs, best = best, tier = tier }
	lastWhy = ("room '%s' done in %s (best before: %s)"):format(label, Clock(secs), best and Clock(best) or "none")
	Say(msg, true)
end

--- Leaving the Labyrinth: the list, then forget the run (the bests stay).
local function RunOver()
	local d = DB()
	local a = d.active
	d.active = nil
	if not (a and a.rooms and #a.rooms > 0) then
		return
	end
	if not ns.IsLabSplitsEnabled() then
		return
	end
	local total = 0
	for _, r in ipairs(a.rooms) do
		total = total + (r.secs or 0)
	end
	Say((L("LAB_SPLITS_SUMMARY_FMT")):format(a.rooms[1].tier or 0, #a.rooms, Clock(total), a.records or 0), false)
	for _, r in ipairs(a.rooms) do
		local delta = ""
		if r.best then
			local diff = r.secs - r.best
			delta = diff < 0 and (" |cff40ff40-" .. Clock(-diff) .. "|r") or (diff > 0 and (" |cffff8080+" .. Clock(diff) .. "|r") or "")
		end
		print(("   %s: %s%s"):format(r.room, Clock(r.secs), delta))
	end
	lastWhy = "run over: summary printed"
end

local function OnZone(event, isReload)
	if InLabyrinth() then
		if ns.IsLabSplitsEnabled() then
			EnsureRun(time(), isReload)
		end
		return
	end
	-- Between rooms there is a loading screen inside the same instance; only an instance change ends the run.
	local inInstance = IsInInstance and select(1, IsInInstance())
	if not inInstance and not isReload then
		RunOver()
	end
end

--- `/mh labsplits [on|off|reset]`: switch, wipe the bests, or say what it is doing and why.
function ns.LabSplitsCommand(arg)
	local p = "|cffffcc00Midnight Helper|r labsplits:"
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		ns.SetLabSplitsEnabled(arg == "on")
		print(p .. " " .. L(arg == "on" and "LAB_SPLITS_ON" or "LAB_SPLITS_OFF"))
		return
	elseif arg == "reset" then
		local d = DB()
		d.best, d.active = {}, nil
		print(p .. " " .. L("LAB_SPLITS_RESET_DONE"))
		return
	end
	local d = DB()
	local a = d.active
	print(("%s %s"):format(p, L(ns.IsLabSplitsEnabled() and "LAB_SPLITS_ON" or "LAB_SPLITS_OFF")))
	print(("   |cff8a8f98map %s · in Labyrinth %s · room '%s' · tier %d · run %s · last: %s|r"):format(
		tostring(PlayerMap()), tostring(InLabyrinth()), tostring(RoomHere()), Tier(),
		a and (("%d rooms, %s since the last mark"):format(#a.rooms, Clock(time() - (a.last or time())))) or "none",
		lastWhy))
	local tiers = {}
	for t in pairs(d.best) do
		tiers[#tiers + 1] = t
	end
	table.sort(tiers)
	if #tiers == 0 then
		print("   " .. L("LAB_SPLITS_NO_BEST"))
	end
	for _, t in ipairs(tiers) do
		print("   " .. (L("LAB_SPLITS_BEST_HEAD_FMT")):format(t))
		local rooms = {}
		for room, secs in pairs(d.best[t]) do
			rooms[#rooms + 1] = { room = room, secs = secs }
		end
		table.sort(rooms, function(x, y)
			return x.room < y.room
		end)
		for _, r in ipairs(rooms) do
			print(("      %s: %s"):format(r.room, Clock(r.secs)))
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("SCENARIO_COMPLETED")
ev:SetScript("OnEvent", function(_, event, a1, a2)
	if event == "SCENARIO_COMPLETED" then
		RoomDone()
	elseif event == "PLAYER_ENTERING_WORLD" then
		local isReload = a2 and true or false
		-- The map is not always known at the moment of the event.
		if C_Timer and C_Timer.After then
			C_Timer.After(1, function()
				OnZone(event, isReload)
			end)
		else
			OnZone(event, isReload)
		end
	else
		if C_Timer and C_Timer.After then
			C_Timer.After(1, function()
				OnZone(event, false)
			end)
		else
			OnZone(event, false)
		end
	end
end)
