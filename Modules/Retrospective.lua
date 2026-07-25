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
-- Difficulties that refused us THIS SESSION. Deliberately not saved.
--
-- It used to be persisted, and that made things worse: one transient refusal in a
-- Timewalking dungeon disabled the death recap there forever. Proof it was transient --
-- DBM registers COMBAT_LOG_EVENT_UNFILTERED (DBM-Core.lua:2499) and was announcing bosses
-- in that very dungeon, so the combat log is plainly usable at difficulty 24. Persisting a
-- one-off failure turned "we were refused once, probably mid-loading-screen" into "this
-- content is banned", and the symptom was silence: no error, no recap, nothing to notice.
-- The attempt cap below is what stops spam; this only avoids retrying within a session.
local blockedDiff = {}

-- ...and the same knowledge kept ACROSS sessions, scoped to the client build.
--
-- Session-only was the right call in July on the evidence then: one refusal looked
-- transient, DBM registers CLEU at difficulty 24, so banning the content forever was
-- wrong. Rob's BugGrabber has since counted EIGHTEEN SESSIONS of the identical refusal
-- in Timewalking. That is not transient. DBM can register there and MH cannot, and the
-- error says why: "while execution tainted by MidnightHelper". So the refusal is a
-- property of us, not a fluke, and re-testing it every single session buys nothing but
-- one more error in the player's log.
--
-- Keyed on the interface build so it is remembered but never permanent: a patch clears
-- the memory and we measure again. That answers the objection that sank the first
-- attempt — "banned forever" — while ending the per-session spam.
local function PersistedBlocked()
	if not ns.db then
		return nil
	end
	local build = (GetBuildInfo and select(4, GetBuildInfo())) or 0
	local t = ns.db.cleuBlockedDiff
	if type(t) ~= "table" or t.build ~= build then
		t = { build = build, diffs = {} }
		ns.db.cleuBlockedDiff = t
	end
	t.diffs = t.diffs or {}
	return t
end

local function IsPersistedBlocked(diffID)
	local t = PersistedBlocked()
	return (t and diffID and t.diffs[diffID]) and true or false
end

local function RememberBlocked(diffID)
	local t = PersistedBlocked()
	if t and diffID then
		t.diffs[diffID] = true
	end
end

local function inTrackedInstance()
	if not (IsInInstance and GetInstanceInfo) then
		return false
	end
	if not IsInInstance() then
		return false
	end
	-- Ask the group system directly BEFORE trusting the difficulty. On a /reload inside an
	-- instance GetInstanceInfo() briefly reports stale info, so difficulty 205 can read as a
	-- plain dungeon for a moment; this API describes the LFG session and is right immediately.
	if C_LFGInfo and C_LFGInfo.IsInLFGFollowerDungeon then
		local ok, isFollower = pcall(C_LFGInfo.IsInLFGFollowerDungeon)
		if ok and isFollower then
			return false
		end
	end
	local diffID = select(3, GetInstanceInfo())
	if diffID and (blockedDiff[diffID] or IsPersistedBlocked(diffID)) then
		return false
	end
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
	if ns.LoadBlizzardAddOn then
		ns.LoadBlizzardAddOn("Blizzard_DeathRecap")
	end
	if type(OpenDeathRecap) == "function" and pcall(OpenDeathRecap, 1) then
		return true
	end
	if type(DeathRecapFrame_OpenRecap) == "function" and pcall(DeathRecapFrame_OpenRecap, 1) then
		return true
	end
	if type(DeathRecapFrame) == "table" then
		-- 12.0.7: the frame EXISTS but neither global opener does (Rob's /mh death probe),
		-- so the entry point is a method on the frame. Try the populating one first —
		-- a bare :Show() would risk an empty/stale window.
		if type(DeathRecapFrame.OpenRecap) == "function" and pcall(DeathRecapFrame.OpenRecap, DeathRecapFrame, 1) then
			return true
		end
		if type(DeathRecapFrame.Show) == "function" and pcall(DeathRecapFrame.Show, DeathRecapFrame) then
			return true
		end
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
-- Auto-open Blizzard's recap in restricted content? Default ON: there we cannot name the
-- cause ourselves, so the recap is the ONLY explanation — and a true beginner (the whole
-- reason this exists: Carola died twice in a ritual not knowing why) will not think to
-- click a popup. In readable dungeons we already print the cause, so we never auto-open
-- there. /mh death auto toggles it off for anyone who just wants to release and move on.
local function autoOpenEnabled()
	return not (ns.db and ns.db.deathRecapAutoOpen == false)
end

-- Ask ONCE, the first time we actually auto-open something. Default-on would be pushy
-- without an escape, and default-off means the beginner this exists for never finds it
-- (Rob 16 jul). So: help by default, then hand them the off-switch the moment they see
-- what it does. Re-enabling later lives in the native Settings panel.
StaticPopupDialogs["MIDNIGHTHELPER_DEATH_AUTOOPEN"] = {
	text = "%s",
	button1 = OKAY, -- replaced with the localized labels at show time
	button2 = CANCEL,
	OnAccept = function()
		ns.db = ns.db or {}
		ns.db.deathRecapAutoOpen = true
	end,
	OnCancel = function()
		ns.db = ns.db or {}
		ns.db.deathRecapAutoOpen = false
	end,
	timeout = 0,
	whileDead = true, -- you are, definitionally, dead when this fires
	hideOnEscape = true,
	preferredIndex = 3,
}

local function MaybeAskAboutAutoOpen()
	if ns.db and ns.db.deathRecapAutoOpenAsked then
		return
	end
	ns.db = ns.db or {}
	ns.db.deathRecapAutoOpenAsked = true
	local d = StaticPopupDialogs["MIDNIGHTHELPER_DEATH_AUTOOPEN"]
	if not (d and StaticPopup_Show) then
		return
	end
	d.button1 = ns:L("DEATH_AUTOOPEN_KEEP")
	d.button2 = ns:L("DEATH_AUTOOPEN_STOP")
	StaticPopup_Show("MIDNIGHTHELPER_DEATH_AUTOOPEN", ns:L("DEATH_AUTOOPEN_ASK"))
end

--- Is the Death Recap auto-opened in restricted content? (native Settings bridge)
function ns.IsDeathRecapAutoOpenEnabled()
	return autoOpenEnabled()
end

--- Set it from the Settings panel. An explicit choice means we never ask again.
function ns.SetDeathRecapAutoOpenEnabled(v)
	ns.db = ns.db or {}
	ns.db.deathRecapAutoOpen = v and true or false
	ns.db.deathRecapAutoOpenAsked = true
end

local function ShowRestrictedDeathLesson()
	if GetTime() - lastShown < COOLDOWN then
		return
	end
	lastShown = GetTime()
	ShowDeathPopup(ns:L("DEATH_RECAP_RESTRICTED") .. "\n|cff9d9d9d" .. ns:L("DEATH_RECAP_OPEN_HINT") .. "|r")
	if autoOpenEnabled() and C_Timer and C_Timer.After then
		-- Small delay: at PLAYER_DEAD the recap is not populated yet, so opening
		-- immediately would risk an empty window.
		C_Timer.After(1, function()
			local opened = false
			pcall(function()
				opened = OpenBlizzardRecap()
			end)
			-- Only ask about a behaviour the player actually just saw happen.
			if opened then
				MaybeAskAboutAutoOpen()
			end
		end)
	end
end

-- /mh death auto — toggle the auto-open above (the popup itself always stays).
function ns.ToggleDeathRecapAutoOpen()
	ns.db = ns.db or {}
	ns.db.deathRecapAutoOpen = not autoOpenEnabled()
	print(("|cffffcc00%s|r %s"):format(
		ns:L("PRINT_PREFIX"), ns:L(autoOpenEnabled() and "DEATH_AUTOOPEN_ON" or "DEATH_AUTOOPEN_OFF")
	))
	return autoOpenEnabled()
end

-- Register the heavy combat-log event ONLY while inside a tracked instance.
local clog = CreateFrame("Frame")
local clogOn = false
local cleuBlocked = false -- set if a RegisterEvent is ever forbidden (see the backstop)
clog:SetScript("OnEvent", OnCombatLog)

-- Hard cap on RegisterEvent attempts per session. The kill-switch below is smarter, but
-- it is also the part that has now failed twice in a row (13x, then 14x with the "fixed"
-- version). A dumb counter cannot fail: whatever else is wrong, MidnightHelper can never
-- again produce more than this many of these errors in one session.
-- ⚠️ SPOOR (2026-07-25, Rob's /mh death na een Timewalking-run) — nog niet gefixt.
-- De meting: "in tracked instance: false" en toch "HasSecretRestrictions() right here:
-- true". Die vlag staat dus ook BUITEN een instance aan, precies zoals gevreesd toen
-- hij als kandidaat-poort werd opgeschreven (Platynator leest hem eenmalig bij het
-- laden). Als poort is hij daarmee vrijwel afgeschreven: hij onderscheidt niets.
--
-- Het echte spoor staat in de foutmelding zelf: "while execution tainted by
-- 'MidnightHelper'". Onze eigen notities houden vast dat DBM WEL CLEU registreert op
-- difficulty 24. Kan DBM het daar en wij niet, dan weigert de CONTENT het niet — dan
-- is het onze eigen taint. En MH is nu juist de addon die secret values leest
-- (CombatSafety). Volgende vraag is dus niet "welke content blokkeert" maar "wat
-- taint ons, en gebeurt dat vóór de registratie".
--
-- Wat nog ontbreekt om dit rond te maken: een cleuAllowed-monster uit content waar de
-- registratie WEL lukt (normale dungeon/raid). Zonder die helft is er niets te
-- vergelijken.
local MAX_CLOG_ATTEMPTS = 3
local clogAttempts = 0

--- Record that this content refuses us, and say so once. Called straight from the
--- registration path, so it does NOT depend on ADDON_ACTION_FORBIDDEN being delivered.
local function StandDownCLEU(reason)
	cleuBlocked = true
	local iname, itype, diffID, diffName
	if GetInstanceInfo then
		local ok, a, b, c, d = pcall(GetInstanceInfo)
		if ok then
			iname, itype, diffID, diffName = a, b, c, d
		end
	end
	if diffID then
		blockedDiff[diffID] = true
		RememberBlocked(diffID) -- survives the reload, cleared by the next patch
	end

	-- MEASURE, do not guess. Three fixes have now failed here (13x, 14x, 17x), each
	-- one a theory about WHICH content refuses us. C_Secrets.HasSecretRestrictions()
	-- is the obvious candidate gate -- DBM and JustAC both read C_Secrets to decide
	-- what they may touch -- but Platynator reads it ONCE at load, which would mean
	-- it is a client-wide flag and useless for "am I in restricted content now".
	-- Gating on it before knowing which it is would repeat the difficulty-blacklist
	-- mistake: the recap silently dead everywhere.
	--
	-- So: record the candidate signals at the exact moment we are refused, in
	-- SavedVariables (a session table would be wiped by the reload Rob does to pick
	-- up the next build -- that cost three test rounds in July). If the flag is TRUE
	-- here and FALSE in content where the recap works, it is the gate. If it is TRUE
	-- everywhere, it is not, and we stop considering it.
	local function readFlag(fn)
		if type(fn) ~= "function" then
			return "n/a"
		end
		local ok, v = pcall(fn)
		return ok and tostring(v) or "error"
	end
	ns.db = ns.db or {}
	ns.db.cleuRefusals = ns.db.cleuRefusals or {}
	local log = ns.db.cleuRefusals
	log[#log + 1] = {
		at = (time and time()) or 0,
		reason = tostring(reason),
		instance = tostring(iname),
		itype = tostring(itype),
		diffID = diffID,
		diffName = tostring(diffName),
		hasSecretRestrictions = readFlag(C_Secrets and C_Secrets.HasSecretRestrictions),
		aurasSecret = readFlag(C_Secrets and C_Secrets.ShouldAurasBeSecret),
	}
	-- Keep the last 10; this is evidence, not a growing file.
	while #log > 10 do
		table.remove(log, 1)
	end
	print(("|cffffcc00%s|r combat log refused here (%s) — %s (%s), difficultyID %s (%s). Death recap off here; tell Rob."):format(
		ns:L("PRINT_PREFIX"), tostring(reason),
		tostring(iname), tostring(itype), tostring(diffID), tostring(diffName)
	))
	if clogOn then
		clog:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		clogOn = false
		dmgRing = {}
	end
end

local function DoClogRegistration()
	local want = not cleuBlocked and autoEnabled() and inTrackedInstance()
	if want and not clogOn then
		if clogAttempts >= MAX_CLOG_ATTEMPTS then
			StandDownCLEU("attempt cap reached")
			return
		end
		clogAttempts = clogAttempts + 1
		clog:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		-- Ask whether it actually took. A forbidden RegisterEvent is not a Lua error, so the
		-- old code happily set clogOn = true and believed itself, then relied on the
		-- ADDON_ACTION_FORBIDDEN event to undo that. Reading the state back is synchronous
		-- and needs nothing to be delivered -- if the event is not registered, we were
		-- refused, full stop.
		if clog:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then
			clogOn = true
			-- The other half of the comparison. A refusal log alone cannot tell us
			-- whether HasSecretRestrictions() distinguishes anything -- we need its
			-- value where registration SUCCEEDS too. One row per instance is enough.
			if ns.db then
				local okI, iname, itype, diffID = pcall(GetInstanceInfo)
				local okFlag, flag = pcall(function()
					return C_Secrets and C_Secrets.HasSecretRestrictions and C_Secrets.HasSecretRestrictions()
				end)
				ns.db.cleuAllowed = ns.db.cleuAllowed or {}
				ns.db.cleuAllowed[tostring(okI and diffID or "?")] = {
					instance = tostring(okI and iname or "?"),
					itype = tostring(okI and itype or "?"),
					hasSecretRestrictions = okFlag and tostring(flag) or "error",
					at = (time and time()) or 0,
				}
			end
		else
			StandDownCLEU("RegisterEvent did not take")
			return
		end
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
		-- 0.1s was NOT enough: on a /reload inside an instance GetInstanceInfo() had not
		-- settled yet, so a follower dungeon still read as a plain dungeon and we registered
		-- anyway (Rob, 19 jul: 13x, one per reload). Waiting longer costs nothing -- combat
		-- start re-checks below, and nobody pulls within 1.5s of the loading screen.
		C_Timer.After(1.5, function()
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
	-- Secondary net only. The registration path now detects refusal by reading the state
	-- back, so this no longer has to be delivered for us to stop -- which matters, because
	-- whether it was being delivered at all is exactly what could not be established while
	-- the spam was happening.
	if who == "MidnightHelper" and type(func) == "string" and func:find("RegisterEvent", 1, true) then
		if not cleuBlocked then
			StandDownCLEU("ADDON_ACTION_FORBIDDEN")
		end
	end
end)

local zone = CreateFrame("Frame")
zone:RegisterEvent("PLAYER_ENTERING_WORLD")
zone:RegisterEvent("ZONE_CHANGED_NEW_AREA")
zone:RegisterEvent("PLAYER_REGEN_DISABLED") -- combat start: instance info is settled by now
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
	-- Housekeeping: drop the persisted blacklist the previous build wrote. Nothing reads it
	-- any more, so this changes no behaviour -- it just stops a retracted idea's data from
	-- sitting in everyone's SavedVariables forever. Done here because ns.db does not exist
	-- yet while this file is being loaded.
	if ns.db and ns.db.deathRecapBlockedDiff ~= nil then
		ns.db.deathRecapBlockedDiff = nil
	end
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
	-- Live value of the candidate gate, next to the two histories below. The whole
	-- question is whether this flag differs between content that allows the combat
	-- log and content that refuses it.
	if C_Secrets and C_Secrets.HasSecretRestrictions then
		local ok, v = pcall(C_Secrets.HasSecretRestrictions)
		print(("   C_Secrets.HasSecretRestrictions() right here: %s"):format(ok and tostring(v) or "error"))
	else
		print("   C_Secrets.HasSecretRestrictions: not available on this client")
	end
	local refusals = ns.db and ns.db.cleuRefusals
	if type(refusals) == "table" and #refusals > 0 then
		print("   |cffff8080REFUSED here (survives reloads):|r")
		for _, r in ipairs(refusals) do
			-- Timestamp included: without it you cannot tell a refusal from an hour ago
			-- from one that just happened, and this log deliberately survives reloads.
			-- Rob hit exactly that on 2026-07-25 -- four entries, two of them stale.
			local when = (date and type(r.at) == "number" and r.at > 0) and date("%H:%M", r.at) or "??:??"
			print(("      [%s] %s (%s) diff %s (%s)  secretRestrictions=%s  auras=%s  [%s]"):format(
				when,
				tostring(r.instance), tostring(r.itype), tostring(r.diffID), tostring(r.diffName),
				tostring(r.hasSecretRestrictions), tostring(r.aurasSecret), tostring(r.reason)
			))
		end
	end
	local allowed = ns.db and ns.db.cleuAllowed
	if type(allowed) == "table" and next(allowed) then
		print("   |cff40c040ALLOWED here:|r")
		for diff, a in pairs(allowed) do
			print(("      %s (%s) diff %s  secretRestrictions=%s"):format(
				tostring(a.instance), tostring(a.itype), tostring(diff), tostring(a.hasSecretRestrictions)
			))
		end
	end
	if type(refusals) == "table" and #refusals > 0 and type(allowed) == "table" and next(allowed) then
		print("   |cffffd966Compare the two secretRestrictions columns: differ = that is the gate; same = it is not.|r")
	end
	-- Instance/difficulty context — so a slip (e.g. a follower dungeon reporting a
	-- whitelisted difficulty) can be diagnosed exactly and excluded (never guessed).
	if IsInInstance and IsInInstance() and GetInstanceInfo then
		local name, itype, diffID, diffName = GetInstanceInfo()
		print(("   instance: %s  type: %s  difficultyID: %s (%s)"):format(
			tostring(name), tostring(itype), tostring(diffID), tostring(diffName)
		))
	end
	-- Difficulties that refused us this session (cleared on reload — see blockedDiff).
	do
		local ids = {}
		for id in pairs(blockedDiff) do
			ids[#ids + 1] = id
		end
		table.sort(ids)
		print(("   refused this session: %s"):format(
			#ids > 0 and table.concat(ids, ", ") or "none"
		))
	end
	-- What we remember across sessions, and until when. Shown as difficulty IDs, the
	-- same units as the line above.
	do
		local t = ns.db and ns.db.cleuBlockedDiff
		local kept = {}
		if type(t) == "table" and type(t.diffs) == "table" then
			for id in pairs(t.diffs) do
				kept[#kept + 1] = tostring(id)
			end
			table.sort(kept)
		end
		print(("   remembered as refused (build %s): %s%s"):format(
			tostring(t and t.build or "?"),
			#kept > 0 and table.concat(kept, ", ") or "none",
			#kept > 0 and "  |cff8a8f98(cleared by the next patch, or /mh death reset)|r" or ""
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
	if ns.LoadBlizzardAddOn then
		ns.LoadBlizzardAddOn("Blizzard_DeathRecap")
	end
	print(("   open-path (after loading the addon): OpenDeathRecap=%s  DeathRecapFrame_OpenRecap=%s  DeathRecapFrame=%s  loaded=%s"):format(
		type(OpenDeathRecap) == "function" and "|cff40c040function|r" or "|cffff5040nil|r",
		type(DeathRecapFrame_OpenRecap) == "function" and "|cff40c040function|r" or "|cffff5040nil|r",
		type(DeathRecapFrame) == "table" and "|cff40c040table|r" or "|cffff5040nil|r",
		(C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded("Blizzard_DeathRecap")) and "yes" or "no"
	))
	-- The frame exists but the global openers don't, so the real entry point is a method
	-- ON it. List its own (non-inherited) functions rather than guessing a name.
	if type(DeathRecapFrame) == "table" then
		local own = {}
		local ok = pcall(function()
			for k, v in pairs(DeathRecapFrame) do
				if type(v) == "function" then
					own[#own + 1] = tostring(k)
				end
			end
		end)
		table.sort(own)
		print(("   DeathRecapFrame methods: %s"):format(
			(ok and #own > 0) and table.concat(own, ", ") or "none readable"
		))
	end
end

--- /mh death reset — forget which difficulties refused us, and try them again.
--- Needed once the taint that causes the refusal is actually fixed: without this the
--- build-scoped memory would keep us out until the next patch, long after the reason
--- disappeared.
function ns.ResetDeathRecapBlocks()
	if ns.db then
		ns.db.cleuBlockedDiff = nil
	end
	wipe(blockedDiff)
	cleuBlocked = false
	clogAttempts = 0
	print(("|cffffcc00%s|r death recap: forgot every refusal; it will try again."):format(ns:L("PRINT_PREFIX")))
end
