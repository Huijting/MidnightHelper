--[[
	Midnight Helper — death recap (retrospective, beginner half of Spec 12).
	When you die inside an instance, turn "what just hit me" into one gentle lesson
	("you took heavy damage from X — next time interrupt or step out") instead of a
	silent respawn.

	How it reads the cause (Spec 12 plan B): 12.x's C_DeathInfo does NOT expose the
	death cause (only corpse/graveyard/resurrect — confirmed via /mh death), so we keep
	a TINY ring buffer of the last few damage events that hit YOU. Per Spec 11 the heavy
	COMBAT_LOG_EVENT_UNFILTERED is registered ONLY in dungeons (party, incl. M+) and raids
	(off in the open world / cities) and only records damage where destGUID == the player.
	Restricted content — ritual sites (scenario) and delves — FORBIDS registering CLEU
	(ADDON_ACTION_FORBIDDEN) and hides the log fields as SECRET, so we stay out there and
	leave those deaths to Blizzard's own Death Recap. See inTrackedInstance().

	Toggle with ns.db.deathRecap (default on). /mh death is the API/buffer probe.
]]

local _, ns = ...

local COOLDOWN = 12 -- seconds between auto-lessons, so a wipe doesn't spam
local RING = 8
local lastShown = 0
local dmgRing = {}
local playerGUID

local DMG_SUB = {
	SWING_DAMAGE = true,
	SPELL_DAMAGE = true,
	SPELL_PERIODIC_DAMAGE = true,
	RANGE_DAMAGE = true,
	ENVIRONMENTAL_DAMAGE = true,
}

local function isSecret(v)
	return issecretvalue and issecretvalue(v) == true
end

local function autoEnabled()
	return not (ns.db and ns.db.deathRecap == false)
end

-- Death recap only where COMBAT_LOG_EVENT_UNFILTERED may actually be registered — a
-- WHITELIST of combat-log-friendly difficulties (regular/heroic/mythic/keystone dungeons,
-- timewalking, and raids: where meters work). Restricted content — delves (208), follower
-- dungeons, ritual scenarios — is NOT in the list, so we never hit the ADDON_ACTION_FORBIDDEN
-- that RegisterEvent throws there (which "party"/"raid" kind-matching kept missing: rituals
-- AND follower dungeons both slipped through). Fail-CLOSED: an unknown/new difficulty is just
-- not tracked (no recap, never a crash). The runtime kill-switch below is the backstop.
local SAFE_DIFFICULTY = {
	[1] = true,  -- Dungeon Normal
	[2] = true,  -- Dungeon Heroic
	[8] = true,  -- Mythic Keystone (M+)
	[23] = true, -- Mythic 0
	[24] = true, -- Timewalking dungeon
	[14] = true, -- Raid Normal
	[15] = true, -- Raid Heroic
	[16] = true, -- Raid Mythic
	[17] = true, -- Raid LFR
}
local function inTrackedInstance()
	if not (IsInInstance and GetInstanceInfo) then
		return false
	end
	if not IsInInstance() then
		return false
	end
	local diffID = select(3, GetInstanceInfo())
	if not (diffID and SAFE_DIFFICULTY[diffID]) then
		return false -- delve / follower dungeon / ritual scenario / unknown → stay out
	end
	if ns.IsDelveInstanceInProgress and ns.IsDelveInstanceInProgress() then
		return false -- extra safety
	end
	return true
end

-- Record only damage that landed on the player. Cheap early-outs first; secret
-- fields are dropped (unreadable ≠ absent) so we never index/format a secret.
local function OnCombatLog()
	local t = { CombatLogGetCurrentEventInfo() }
	local sub = t[2]
	if not DMG_SUB[sub] then
		return
	end
	playerGUID = playerGUID or UnitGUID("player")
	if t[8] ~= playerGUID then
		return -- not damage to us
	end
	local srcName = t[5]
	local amount, spell, env
	if sub == "SWING_DAMAGE" then
		amount = t[12]
	elseif sub == "ENVIRONMENTAL_DAMAGE" then
		env, amount = t[12], t[13]
	else
		spell, amount = t[13], t[15] -- SPELL/PERIODIC/RANGE: p2 name, p4 amount
	end
	if isSecret(amount) then
		amount = nil
	end
	dmgRing[#dmgRing + 1] = {
		amount = tonumber(amount) or 0,
		source = (not isSecret(srcName)) and srcName or nil,
		spell = (not isSecret(spell)) and spell or nil,
		env = (not isSecret(env)) and env or nil,
	}
	while #dmgRing > RING do
		table.remove(dmgRing, 1)
	end
end

-- Pick the biggest blow from the buffer → { label, environmental } or nil.
local function DeathCauseFromLog()
	local best, bestAmt
	for i = 1, #dmgRing do
		local r = dmgRing[i]
		if (r.amount or 0) >= (bestAmt or 0) and (r.amount or 0) > 0 then
			bestAmt, best = r.amount, r
		end
	end
	if not best then
		return nil
	end
	if best.env then
		return { label = best.env, environmental = true }
	end
	local label = best.spell or best.source
	if not label then
		return nil -- all secret / unknown
	end
	return { label = label, environmental = false }
end

local function ShowLesson()
	if GetTime() - lastShown < COOLDOWN then
		return
	end
	lastShown = GetTime()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	local head = ("|cff8fd3ff%s|r"):format(ns:L("DEATH_RECAP_HEAD"))
	local cause = DeathCauseFromLog()
	local body
	if not cause then
		body = ns:L("DEATH_RECAP_GENERIC") -- couldn't read → point at Blizzard's recap, no guess
	elseif cause.environmental then
		body = (ns:L("DEATH_RECAP_ENV_FMT")):format(cause.label)
	else
		body = (ns:L("DEATH_RECAP_LESSON_FMT")):format(cause.label)
	end
	print(("%s %s %s"):format(prefix, head, body))
	dmgRing = {} -- fresh for the next life
end

-- Register the heavy combat-log event ONLY while inside a tracked instance.
local clog = CreateFrame("Frame")
local clogOn = false
local cleuBlocked = false -- set if a RegisterEvent is ever forbidden (see the backstop)
clog:SetScript("OnEvent", OnCombatLog)

local function UpdateClogRegistration()
	local want = not cleuBlocked and autoEnabled() and inTrackedInstance()
	if want and not clogOn then
		clog:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		clogOn = true
	elseif not want and clogOn then
		clog:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		clogOn = false
		dmgRing = {}
	end
end
ns.UpdateDeathRecapClog = UpdateClogRegistration -- so the /mh death toggle can re-check

-- Backstop: if the whitelist ever lets us try RegisterEvent in restricted content anyway (a
-- difficulty we did not know about), ADDON_ACTION_FORBIDDEN fires. It is NOT a catchable Lua
-- error, so pcall can't suppress it — the only cure is to stop calling RegisterEvent. Catch
-- the event, stand the capture down for this session, and never retry. Caps any slip at a
-- single error instead of 10x spam.
local forbiddenWatch = CreateFrame("Frame")
forbiddenWatch:RegisterEvent("ADDON_ACTION_FORBIDDEN")
forbiddenWatch:SetScript("OnEvent", function(_, _, who, func)
	if who == "MidnightHelper" and type(func) == "string" and func:find("RegisterEvent", 1, true) then
		cleuBlocked = true
		if clogOn then
			clog:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			clogOn = false
			dmgRing = {}
		end
	end
end)

local zone = CreateFrame("Frame")
zone:RegisterEvent("PLAYER_ENTERING_WORLD")
zone:RegisterEvent("ZONE_CHANGED_NEW_AREA")
zone:RegisterEvent("PLAYER_DEAD")
zone:SetScript("OnEvent", function(_, ev)
	if ev == "PLAYER_DEAD" then
		if not autoEnabled() or not inTrackedInstance() then
			return
		end
		-- tiny delay so the final blow's log event is in the buffer.
		if C_Timer and C_Timer.After then
			C_Timer.After(0.2, function()
				pcall(ShowLesson)
			end)
		else
			pcall(ShowLesson)
		end
		return
	end
	playerGUID = UnitGUID("player")
	UpdateClogRegistration()
end)

-- Legacy C_DeathInfo probe kept for /mh death (some future build may expose a recap).
local function ReadRecapAPICause()
	if type(C_DeathInfo) ~= "table" or type(C_DeathInfo.GetDeathRecapLinks) ~= "function" then
		return nil
	end
	local ok, links = pcall(C_DeathInfo.GetDeathRecapLinks, 1)
	if not ok or type(links) ~= "table" or #links == 0 then
		return nil
	end
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

-- /mh death — show what we can read: the combat-log buffer (plan B) + the C_DeathInfo
-- surface. Die once in an instance, then run this.
function ns.PrintDeathRecapDiagnostics()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s Death recap probe"):format(prefix))
	print(("   in tracked instance: %s   combat-log capture: %s"):format(
		tostring(inTrackedInstance()), clogOn and "on" or "off"
	))
	print(("   damage-buffer entries: %d"):format(#dmgRing))
	for i = 1, #dmgRing do
		local r = dmgRing[i]
		print(("     [%d] %d  %s"):format(
			i, r.amount or 0, r.env and ("env:" .. r.env) or (r.spell or r.source or "?")
		))
	end
	local cause = DeathCauseFromLog()
	print(("   biggest blow: %s"):format(cause and ("|cff8fd3ff" .. cause.label .. "|r") or "nil"))
	if type(C_DeathInfo) == "table" then
		local fns = {}
		for k, v in pairs(C_DeathInfo) do
			if type(v) == "function" then
				fns[#fns + 1] = k
			end
		end
		table.sort(fns)
		print(("   C_DeathInfo: %s"):format(#fns > 0 and table.concat(fns, ", ") or "none"))
		print(("   C_DeathInfo recap: %s"):format(ReadRecapAPICause() or "nil (no recap API on this client)"))
	end
end
