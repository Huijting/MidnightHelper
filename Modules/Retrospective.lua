--[[
	Midnight Helper — death recap (retrospective, beginner half of Spec 12).
	When you die inside an instance/delve, turn Blizzard's OWN death data into one
	gentle lesson ("you took heavy damage from X — next time interrupt or step out")
	instead of a silent respawn. We read Blizzard's recap (C_DeathInfo) — we do NOT
	turn on COMBAT_LOG_EVENT_UNFILTERED (Spec 11 parks it) and we recompute nothing.

	never-lie: the exact C_DeathInfo functions vary by build, so /mh death is a probe
	that prints what's readable on your client. The auto-lesson only fires when we can
	actually extract a cause; an unclear death shows nothing rather than a guess.

	Toggle the auto-lesson with ns.db.deathRecap (default on); /mh death is the probe.
]]

local _, ns = ...

local COOLDOWN = 12 -- seconds between auto-lessons, so a wipe doesn't spam
local lastShown = 0

local function autoEnabled()
	return not (ns.db and ns.db.deathRecap == false)
end

local function inTrackedInstance()
	if not IsInInstance then
		return false
	end
	local inside, kind = IsInInstance()
	return inside and (kind == "party" or kind == "scenario" or kind == "raid")
end

-- Best-effort read of Blizzard's most-recent death recap. Returns a short cause
-- string (e.g. a spell/source name) or nil when nothing readable is available.
local function ReadLastDeathCause()
	if type(C_DeathInfo) ~= "table" or type(C_DeathInfo.GetDeathRecapLinks) ~= "function" then
		return nil
	end
	local ok, links = pcall(C_DeathInfo.GetDeathRecapLinks, 1)
	if not ok or type(links) ~= "table" or #links == 0 then
		return nil
	end
	-- Each link is a chat hyperlink; its [display text] is the ability/source name.
	for _, link in ipairs(links) do
		if type(link) == "string" then
			local label = link:match("%[(.-)%]")
			if label and label ~= "" then
				return label
			end
		end
	end
	return nil
end

local function ShowLesson()
	if GetTime() - lastShown < COOLDOWN then
		return
	end
	local cause = ReadLastDeathCause()
	if not cause then
		return -- unclear death → say nothing (never a guessed cause)
	end
	lastShown = GetTime()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s |cff8fd3ff%s|r %s"):format(
		prefix, ns:L("DEATH_RECAP_HEAD"), (ns:L("DEATH_RECAP_LESSON_FMT")):format(cause)
	))
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_DEAD")
f:SetScript("OnEvent", function()
	if not autoEnabled() or not inTrackedInstance() then
		return
	end
	-- Give Blizzard's recap a moment to populate, then read it.
	if C_Timer and C_Timer.After then
		C_Timer.After(0.5, function()
			pcall(ShowLesson)
		end)
	else
		pcall(ShowLesson)
	end
end)

-- /mh death — probe what C_DeathInfo exposes on this client + what we can read of
-- the last death, so the recap can be finalised against the real API (never-lie).
function ns.PrintDeathRecapDiagnostics()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s Death recap probe"):format(prefix))
	if type(C_DeathInfo) ~= "table" then
		print("   C_DeathInfo: |cffff5555not present|r")
		return
	end
	local fns = {}
	for k, v in pairs(C_DeathInfo) do
		if type(v) == "function" then
			fns[#fns + 1] = k
		end
	end
	table.sort(fns)
	print(("   C_DeathInfo functions: %s"):format(#fns > 0 and table.concat(fns, ", ") or "none"))
	if type(C_DeathInfo.GetDeathRecapLinks) == "function" then
		local ok, links = pcall(C_DeathInfo.GetDeathRecapLinks, 1)
		if ok and type(links) == "table" then
			print(("   GetDeathRecapLinks(1): %d entries"):format(#links))
			for i = 1, math.min(3, #links) do
				local l = tostring(links[i])
				print(("     [%d] %s"):format(i, l:gsub("|", "||")))
			end
		else
			print("   GetDeathRecapLinks(1): no data (die once, then re-run)")
		end
	end
	local cause = ReadLastDeathCause()
	print(("   parsed cause: %s"):format(cause and ("|cff8fd3ff" .. cause .. "|r") or "nil"))
	print("   in tracked instance: " .. tostring(inTrackedInstance()))
end
