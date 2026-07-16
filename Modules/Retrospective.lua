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

local SKULL_ICON = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8" -- the skull marker

-- Open Blizzard's own Death Recap (its addon is load-on-demand). recapID 1 = most recent,
-- mirroring how the C_DeathInfo probe reads GetDeathRecapLinks(1). All guarded — if the API
-- is absent this is a harmless no-op (Rob confirms in-game whether the click opens it).
-- Open Blizzard's Death Recap. The addon loads on demand, so pull it in first, then try
-- the known entry points — each type-guarded, so we only ever call what actually exists
-- on this client (no guessing). Returns true only when something really fired.
-- Rob 16 jul: the old version called OpenDeathRecap() only, which does NOT exist on
-- 12.0.7 — clicking the death toast silently did nothing.
local function OpenBlizzardRecap()
	if UIParentLoadAddOn then
		pcall(UIParentLoadAddOn, "Blizzard_DeathRecap")
	end
	if type(OpenDeathRecap) == "function" and pcall(OpenDeathRecap, 1) then
		return true
	end
	if type(DeathRecapFrame_OpenRecap) == "function" and pcall(DeathRecapFrame_OpenRecap, 1) then
		return true
	end
	if type(DeathRecapFrame) == "table" and type(DeathRecapFrame.Show) == "function"
		and pcall(DeathRecapFrame.Show, DeathRecapFrame) then
		return true
	end
	-- Nothing worked: say so instead of failing silently under the player's click.
	print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("DEATH_RECAP_OPEN_FAILED")))
	return false
end

-- The visible card (reuses the Midnight toast: title + body + skull icon + click-to-open the
-- Death Recap). Carola died twice in a ritual not knowing why — a card beats a chat line she
-- scrolls past.
local function ShowDeathPopup(body)
	if ns.QueueMidnightToast then
		ns.QueueMidnightToast({
			id = "mh_deathrecap",
			icon = SKULL_ICON,
			title = ns:L("DEATH_RECAP_HEAD"),
			body = body,
			displaySec = 10, -- a death lesson needs reading (+ time to click through to Blizzard's recap); the default 4.25s was too quick (Rob 16 jul)
			onClick = OpenBlizzardRecap,
			-- Own hover hint; without it the toast falls back to the delve-bounty
			-- text ("set a waypoint"), which is wrong on a death card.
			clickHintKey = "DEATH_RECAP_OPEN_HINT",
		})
	end
end

-- Readable content (dungeons/raids/M+): name the biggest blow + a lesson, in chat AND a popup.
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
	ShowDeathPopup(body .. "\n|cff9d9d9d" .. ns:L("DEATH_RECAP_OPEN_HINT") .. "|r")
	dmgRing = {} -- fresh for the next life
end

-- Restricted content (delves / follower dungeons / rituals): we never read the combat log
-- there (it's forbidden/secret), so we can't name the cause — point at Blizzard's Death
-- Recap, which is not subject to the addon restriction and CAN show it.
local function ShowRestrictedDeathLesson()
	if GetTime() - lastShown < COOLDOWN then
		return
	end
	lastShown = GetTime()
	ShowDeathPopup(ns:L("DEATH_RECAP_RESTRICTED") .. "\n|cff9d9d9d" .. ns:L("DEATH_RECAP_OPEN_HINT") .. "|r")
end

-- Register the heavy combat-log event ONLY while inside a tracked instance.
local clog = CreateFrame("Frame")
local clogOn = false
local cleuBlocked = false -- set if a RegisterEvent is ever forbidden (see the backstop)
clog:SetScript("OnEvent", OnCombatLog)

local function DoClogRegistration()
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

-- Coalesce zone-event bursts into ONE deferred check. On a load / reload,
-- PLAYER_ENTERING_WORLD + ZONE_CHANGED_NEW_AREA can fire several times while
-- GetInstanceInfo() briefly returns a stale/"safe" difficulty before it settles.
-- Reacting per event made us register/unregister CLEU repeatedly, and in content
-- that forbids CLEU registration (a reload inside a delve/ritual) that produced a
-- BURST of ADDON_ACTION_FORBIDDEN errors before the kill-switch could latch (Rob,
-- 15 jul: 12x). A short debounce lets the instance info stabilise first, so in
-- restricted content the difficulty reads correctly (not whitelisted) and we never
-- call RegisterEvent at all. Guarded so overlapping bursts collapse to one check.
local clogCheckQueued = false
local function UpdateClogRegistration()
	if clogCheckQueued then
		return
	end
	if C_Timer and C_Timer.After then
		clogCheckQueued = true
		C_Timer.After(0.1, function()
			clogCheckQueued = false
			DoClogRegistration()
		end)
	else
		DoClogRegistration()
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
		if not autoEnabled() then
			return
		end
		if inTrackedInstance() then
			-- readable content: tiny delay so the final blow's log event is in the buffer.
			if C_Timer and C_Timer.After then
				C_Timer.After(0.2, function()
					pcall(ShowLesson)
				end)
			else
				pcall(ShowLesson)
			end
		elseif IsInInstance then
			-- restricted PvE instance (delve/follower/ritual): we can't read the cause here, so
			-- point at Blizzard's Death Recap instead of showing nothing (Carola's rituals).
			-- Gate on the instanceType: ONLY PvE ("party"/"scenario"/"raid"). Battlegrounds and
			-- arenas are also IsInInstance()==true but their combat log is NOT restricted and
			-- this is a PvE feature — without this, every PvP death popped the restricted lesson.
			local inInst, instType = IsInInstance()
			if inInst and (instType == "party" or instType == "scenario" or instType == "raid") then
				pcall(ShowRestrictedDeathLesson)
			end
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
	-- Instance/difficulty context — so a slip (e.g. a follower dungeon reporting a
	-- whitelisted difficulty) can be diagnosed exactly and excluded (never guessed).
	if IsInInstance and IsInInstance() and GetInstanceInfo then
		local name, itype, diffID, diffName = GetInstanceInfo()
		print(("   instance: %s  type: %s  difficultyID: %s (%s)"):format(
			tostring(name), tostring(itype), tostring(diffID), tostring(diffName)
		))
	end
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
	-- Open-path probe (plan item 2: can we point/auto-open Blizzard's Death Recap?).
	-- Just reports what exists — never calls it here. Die once, then check these:
	-- if OpenDeathRecap is a function and/or DeathRecapFrame exists, the skull-click
	-- open-path works and auto-opening is on the table for restricted content.
	-- LOAD the on-demand addon first, else we only measure "not loaded yet" and learn
	-- nothing about which entry point actually exists (Rob 16 jul: clicking the toast
	-- did nothing, and the un-loaded probe had hidden why).
	if UIParentLoadAddOn then
		pcall(UIParentLoadAddOn, "Blizzard_DeathRecap")
	end
	print(("   open-path (after loading the addon): OpenDeathRecap=%s  DeathRecapFrame_OpenRecap=%s  DeathRecapFrame=%s  loaded=%s"):format(
		type(OpenDeathRecap) == "function" and "|cff40c040function|r" or "|cffff5040nil|r",
		type(DeathRecapFrame_OpenRecap) == "function" and "|cff40c040function|r" or "|cffff5040nil|r",
		type(DeathRecapFrame) == "table" and "|cff40c040table|r" or "|cffff5040nil|r",
		(C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded("Blizzard_DeathRecap")) and "yes" or "no"
	))
end
