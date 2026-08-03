local _, ns = ...

--[[
	Midnight Helper — interrupt scorecard (Spec 14, Phase 1: local only).

	Tracks YOUR OWN interrupt: did the kick land, or was it wasted (you kicked while
	nothing was casting)? 100% local — no comms, no HUD, no kick-assignment (Midnight
	forbids that in instances). The cross-player GROUP scorecard (sync after the run via
	Comms) is Phase 2.

	Detection uses only long-standing events — UNIT_SPELLCAST_SUCCEEDED (player) and
	UNIT_SPELLCAST_INTERRUPTED — the same ones CombatSafety already leans on, so there is
	no heavy combat-log handler (Spec 11). Casts/spellIds can be SECRET in restricted
	content, so reads are issecretvalue-guarded and degrade to a time-only match.

	12.1 shows a NATIVE "missed" visual on a wasted interrupt, so our optional live whiff
	alert is build-gated OFF there (never a double render). The tally always runs; only the
	SHOWING is gated.
]]

local WINDOW = 0.5    -- seconds after your kick within which a landed interrupt counts
local ANNOUNCE_CD = 4 -- anti-spam for the whiff alert

local function isSecret(v)
	return v ~= nil and issecretvalue ~= nil and issecretvalue(v) == true
end

--- True while Blizzard does NOT show the native missed-interrupt visual (< 12.1), so our
--- own live whiff alert would not be a duplicate.
function ns.ShouldShowLocalMissHint()
	local _, _, _, iface = GetBuildInfo()
	return (tonumber(iface) or 0) < 120100
end

--------------------------------------------------------------------------------
-- Which spell is my interrupt (per spec)
--------------------------------------------------------------------------------

local myInterrupt -- lowercased spell name, or nil if this spec has none
-- Same spell, display casing. Rob, 2026-07-28: the miss hint said "Kick" to a
-- Paladin whose interrupt is Rebuke -- it named a spell he does not have.
local myInterruptName

local function RefreshMyInterrupt()
	myInterrupt = nil
	myInterruptName = nil
	local token = select(2, UnitClass("player"))
	local specIdx = GetSpecialization and GetSpecialization()
	if token and specIdx and ns.MH_GetInterruptSpell then
		local name = ns.MH_GetInterruptSpell(token, specIdx)
		if type(name) == "string" and name ~= "" then
			myInterrupt = name:lower()
			-- Keep the display casing too. The lowercased copy is for comparing
			-- against a cast; the messages need the name as a player reads it.
			myInterruptName = name
		end
	end
end

--------------------------------------------------------------------------------
-- Detection + tally
--------------------------------------------------------------------------------

local tally = { landed = 0, wasted = 0 }
local pending -- { t, guid, gen }
local gen = 0
local lastAnnounce = 0

local function Speak(text)
	if not (C_VoiceChat and C_VoiceChat.SpeakText) then
		return
	end
	local voiceId = 0
	if C_TTSSettings and C_TTSSettings.GetVoiceOptionID and Enum and Enum.TtsVoiceType then
		voiceId = C_TTSSettings.GetVoiceOptionID(Enum.TtsVoiceType.Standard) or 0
	end
	-- SpeakText(voiceID, text, destination, rate, volume): rate 0 = normal, volume 0-100.
	-- Was (…, 2, 100, true) — rate out of range + a boolean volume → the call errored and
	-- pcall swallowed it, so the alert was silently mute (Rob 15 jul).
	pcall(C_VoiceChat.SpeakText, voiceId, text, 2, 0, 100)
end

-- A wasted kick: you pressed your interrupt but nothing got interrupted (usually
-- nothing was casting — a proactive/early kick). This is a PERSONAL training nudge,
-- local-only and opt-in (/mh kicks alert), build-gated to pre-12.1 (12.1 has its own
-- visual), throttled by ANNOUNCE_CD. NO party-chat shout: a wasted kick is not a
-- "missed interrupt", and broadcasting every proactive kick to the group is spammy
-- and reads as an accusation — dropped (Rob 16 jul).
local function OnWasted()
	local now = (GetTime and GetTime()) or 0
	if now - lastAnnounce < ANNOUNCE_CD then
		return
	end
	if ns.db and ns.db.interruptMissAlert and ns.ShouldShowLocalMissHint() then
		local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
		-- Name the spell the player actually pressed. Falls back to the generic
		-- word when the spec's interrupt cannot be resolved -- never to another
		-- class's ability.
		local spell = myInterruptName or ns:L("INTERRUPT_GENERIC_WORD")
		print(("%s |cffffcf7d%s|r"):format(prefix, (ns:L("INTERRUPT_MISS_HINT")):format(spell)))
		Speak((ns:L("INTERRUPT_MISS_TTS")):format(spell))
		lastAnnounce = now
	end
end

-- My own interrupt fired: remember it and, if nothing resolves it within the window, it
-- was wasted. A generation counter makes a resolved (landed) kick's timer a no-op.
local function OnMyInterrupt()
	gen = gen + 1
	local myGen = gen
	-- Capture EVERY unit our kick could have hit. MH's own interrupt macros cast
	-- @focus / @mouseover with a target-fallback ([@focus,harm,nodead][]), so the
	-- landed unit is target OR focus OR mouseover — not just the current target.
	-- Storing only the target made a successful focus/mouseover kick look like a
	-- whiff (false "you missed!" + false party shout — Rob 15 jul).
	local guids
	if UnitGUID then
		for _, u in ipairs({ "target", "focus", "mouseover" }) do
			local gg = UnitGUID(u)
			if gg then
				guids = guids or {}
				guids[#guids + 1] = gg
			end
		end
	end
	pending = {
		t = (GetTime and GetTime()) or 0,
		guids = guids, -- nil in restricted content / no readable unit → time-only match
		gen = myGen,
	}
	if C_Timer and C_Timer.After then
		C_Timer.After(WINDOW, function()
			if pending and pending.gen == myGen then
				tally.wasted = tally.wasted + 1
				pending = nil
				OnWasted()
			end
		end)
	end
end

-- A cast got interrupted; if it lines up with my pending kick (same target, in the window)
-- it landed. GUID match when readable, else time-only (never-lie: don't over-claim).
local function OnInterrupted(unit)
	if not pending then
		return
	end
	local now = (GetTime and GetTime()) or 0
	if (now - pending.t) > WINDOW then
		return
	end
	local match = true
	local g = UnitGUID and UnitGUID(unit)
	-- Compare GUIDs only when readable. In restricted content (rituals/delves) the stored
	-- GUIDs captured at kick time are SECRET; comparing throws. If the interrupted unit is
	-- readable AND we have at least one readable candidate, it landed only when it matches one
	-- of them; otherwise (anything secret / no readable candidate) → time-only match.
	if g and not isSecret(g) and pending.guids then
		local haveReadable = false
		match = false
		for i = 1, #pending.guids do
			local pg = pending.guids[i]
			if not isSecret(pg) then
				haveReadable = true
				if pg == g then
					match = true
					break
				end
			end
		end
		if not haveReadable then
			match = true -- all candidates secret → fall back to time-only
		end
	end
	if match then
		tally.landed = tally.landed + 1
		pending = nil -- the pending.gen check turns its timer into a no-op
	end
end

function ns.GetInterruptTally()
	return { landed = tally.landed, wasted = tally.wasted }
end

local function ResetTally()
	tally.landed, tally.wasted = 0, 0
	pending = nil
end

--------------------------------------------------------------------------------
-- Slash: /mh kicks  (inspect the run tally; /mh kicks alert toggles the whiff alert)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Who interrupted (`/mh kicks who`)
--------------------------------------------------------------------------------

--- Default OFF. It adds chat lines for everyone who updates, and a new default
--- that talks is the kind of change people experience as the addon breaking
--- rather than gaining something. One command turns it on.
function ns.IsInterruptAnnounceEnabled()
	return (ns.db and ns.db.interruptAnnounce) and true or false
end

--- Called by Retrospective's combat-log handler, which owns the registration and
--- the whitelist of content where it is permitted. Arguments arrive already
--- stripped of secrets: anything unreadable comes through as nil.
---
--- Names are never compared against the group. Rob pointed out he sees Valeera
--- interrupt in dungeons, and a companion is not in your party — filtering to
--- party members would have dropped exactly the case he named. The combat log
--- reports whoever did it, and so do we.
--- `/mh kicks probe` — record instead of print.
---
--- Rob's idea, and the right one: watching chat mid-dungeon is how the last three
--- measurements got lost. It also answers the question chat cannot. A run with no
--- interrupt lines has two completely different explanations — nobody kicked
--- anything, or we were never listening — and only the second is a bug. That is
--- exactly what happened in Timewalking, where difficulty 24 has been refusing the
--- combat log since 25 July.
---
--- So every record carries whether the combat log was registered AT THAT MOMENT,
--- not merely what was seen.
local KICKS_MAX = 60
local function KicksProbeOn()
	return (ns.db and ns.db.kicksProbe) and true or false
end

local function RecordKick(source, dest, stoppedSpell)
	if not (ns.db and KicksProbeOn()) then
		return
	end
	local log = ns.db.kicksProbeLog
	if type(log) ~= "table" then
		log = {}
		ns.db.kicksProbeLog = log
	end
	if #log >= KICKS_MAX then
		return
	end
	local ok, _, _, diffID, diffName = pcall(GetInstanceInfo)
	log[#log + 1] = {
		source = source or "nil",
		dest = dest or "nil",
		stopped = stoppedSpell or "nil",
		zone = GetRealZoneText and GetRealZoneText() or nil,
		difficultyID = ok and diffID or nil,
		difficultyName = ok and diffName or nil,
		clogRegistered = ns.IsCombatLogRegistered and ns.IsCombatLogRegistered() or false,
		announceOn = ns.IsInterruptAnnounceEnabled(),
	}
end

--- Write down where we are and whether we are listening, interrupts or not.
---
--- Without this an empty log is unreadable: it could mean a quiet run, a refused
--- registration, or a probe nobody switched on. One row on entering the content
--- separates all three.
function ns.MarkKicksProbeContext(reason)
	if not (ns.db and KicksProbeOn()) then
		return
	end
	local log = ns.db.kicksProbeContext
	if type(log) ~= "table" then
		log = {}
		ns.db.kicksProbeContext = log
	end
	if #log >= KICKS_MAX then
		return
	end
	local ok, name, itype, diffID, diffName = pcall(GetInstanceInfo)
	log[#log + 1] = {
		reason = reason,
		zone = GetRealZoneText and GetRealZoneText() or nil,
		instance = ok and name or nil,
		instanceType = ok and itype or nil,
		difficultyID = ok and diffID or nil,
		difficultyName = ok and diffName or nil,
		clogRegistered = ns.IsCombatLogRegistered and ns.IsCombatLogRegistered() or false,
		announceOn = ns.IsInterruptAnnounceEnabled(),
	}
end

local lastAnnounce, lastKey = 0, nil
function ns.OnInterruptAttributed(source, dest, stoppedSpell)
	-- Recorded before the enable check: the probe is for diagnosing a feature that
	-- is producing nothing, and gating the record on the same switch that might be
	-- the fault would hide it.
	RecordKick(source, dest, stoppedSpell)

	if not ns.IsInterruptAnnounceEnabled() or not source then
		return
	end

	-- A double SPELL_INTERRUPT on one cast (two kicks landing together) would
	-- otherwise print twice for what the player saw as one event.
	local key = tostring(source) .. "|" .. tostring(stoppedSpell)
	local now = GetTime and GetTime() or 0
	if key == lastKey and (now - lastAnnounce) < 0.5 then
		return
	end
	lastKey, lastAnnounce = key, now

	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	if stoppedSpell then
		print(("%s " .. ns:L("INTERRUPT_WHO_FMT")):format(prefix, source, stoppedSpell))
	else
		print(("%s " .. ns:L("INTERRUPT_WHO_FMT_PLAIN")):format(prefix, source))
	end
end

function ns.HandleInterruptCommand(arg)
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	if arg == "alert" then
		ns.db = ns.db or {}
		ns.db.interruptMissAlert = not ns.db.interruptMissAlert
		print(("%s %s"):format(prefix, ns:L(ns.db.interruptMissAlert and "INTERRUPT_ALERT_ON" or "INTERRUPT_ALERT_OFF")))
		return
	end
	if arg == "probe" then
		ns.db = ns.db or {}
		ns.db.kicksProbe = not ns.db.kicksProbe
		if ns.db.kicksProbe then
			ns.db.kicksProbeLog, ns.db.kicksProbeContext = {}, {}
			ns.MarkKicksProbeContext("probe switched on")
			print(("%s kicks probe ON — recording. |cffffffff/reload|r when you are done."):format(prefix))
		else
			print(("%s kicks probe OFF — %d interrupt(s) kept."):format(prefix,
				#(ns.db.kicksProbeLog or {})))
		end
		return
	end
	if arg == "who" then
		ns.db = ns.db or {}
		ns.db.interruptAnnounce = not ns.db.interruptAnnounce
		print(("%s %s"):format(prefix,
			ns:L(ns.db.interruptAnnounce and "INTERRUPT_WHO_ON" or "INTERRUPT_WHO_OFF")))
		-- The combat log is registered on entering tracked content, so switching
		-- this on mid-dungeon has to ask for that registration now rather than at
		-- the next zone change.
		if ns.UpdateDeathRecapClog then
			ns.UpdateDeathRecapClog()
		end
		return
	end
	if arg == "reset" then
		ResetTally()
	end
	if (tally.landed + tally.wasted) == 0 then
		print(("%s %s"):format(prefix, ns:L("INTERRUPT_KICKS_NONE")))
	else
		print(("%s " .. ns:L("INTERRUPT_KICKS_FMT")):format(prefix, tally.landed, tally.wasted))
	end
	print("   |cff9d9d9d" .. ns:L("INTERRUPT_KICKS_HINT") .. "|r")
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player") -- filtered to the player: cheap
f:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")
--- MEASUREMENT (2 Aug 2026): who actually interrupted, without a combat log.
---
--- Rob noticed EllesmereUI printing "Interrupted by <name>" under the cast bar and
--- asked the obvious question: if they can read it, why can't we?
---
--- They are not reading a combat log. `UNIT_SPELLCAST_INTERRUPTED` carries a fourth
--- argument, `interruptedBy` — the GUID of whoever did it. Two independent sources
--- in this AddOns folder document that payload: `oUF/elements/castbar.lua:390`
--- ("GUID of whomever interrupted the cast") and
--- `EllesmereUIResourceBars.lua:8650` ("args: unit, castGUID, spellID,
--- interruptedBy, castID"). This file has registered that event all along and
--- discarded the argument.
---
--- If it holds up, the attribution needs no COMBAT_LOG_EVENT_UNFILTERED at all —
--- which walks straight around the CLEU-taint blocker that has stalled this for
--- weeks (see docs, "CLEU-taint onderzoek").
---
--- MEASURED AND CLOSED. 40 interrupts captured in Rob's client, 2 Aug 2026:
---
---   28x nil, 12x secret, never once a readable GUID
---
--- and the split is not random. Where the interrupted caster was HOSTILE
--- (nameplate3, target, softenemy) the value came back SECRET. Where it was
--- FRIENDLY (party2, party4, player) it came back nil. So the one case the feature
--- needs — an enemy getting kicked — is exactly the case that is withheld. The
--- cheap route is shut.
---
--- Nor is it rescued by the marker trick. A secret can be handed to a Blizzard
--- helper that draws it (that is how the raid icon on the party-targets panel
--- works), but there is no helper that turns a GUID into a displayed name.
---
--- The route that DOES work is one this addon already owns.
--- `Modules/Retrospective.lua` registers COMBAT_LOG_EVENT_UNFILTERED behind a
--- whitelist of difficulties — dungeons normal/heroic, M+, Mythic 0, Timewalking
--- (24) and raids — and stays out of delves, ritual scenarios and follower
--- dungeons, where registering it is refused outright. In the whitelisted content
--- SPELL_INTERRUPT carries sourceName, which is the attribution, and Timewalking
--- is where Rob asked for it. Reuse that gate rather than inventing a second one:
--- it is fail-closed, and it already knows which content bites.

f:SetScript("OnEvent", function(_, event, unit, _, spellID, interruptedBy)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		if not myInterrupt then
			return
		end
		if isSecret(spellID) or not (C_Spell and C_Spell.GetSpellName) then
			return -- can't confirm it was our interrupt without over-guessing
		end
		local name = C_Spell.GetSpellName(spellID)
		if type(name) == "string" and not isSecret(name) and name:lower() == myInterrupt then
			OnMyInterrupt()
		end
	elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
		OnInterrupted(unit)
	elseif event == "PLAYER_ENTERING_WORLD" then
		-- Note where we landed and whether the combat log took, before anything
		-- happens. The registration is attempted 1.5s after this event, so ask
		-- again once that has had its chance.
		if ns.MarkKicksProbeContext then
			ns.MarkKicksProbeContext("entered")
			if C_Timer and C_Timer.After then
				C_Timer.After(4, function()
					pcall(ns.MarkKicksProbeContext, "4s after entering")
				end)
			end
		end
		-- Fresh tally per run: reset when we (re)enter an instance.
		if IsInInstance and IsInInstance() then
			ResetTally()
		end
		RefreshMyInterrupt()
	else -- PLAYER_LOGIN / PLAYER_SPECIALIZATION_CHANGED
		RefreshMyInterrupt()
	end
end)
