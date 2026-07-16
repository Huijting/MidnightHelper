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

local function RefreshMyInterrupt()
	myInterrupt = nil
	local token = select(2, UnitClass("player"))
	local specIdx = GetSpecialization and GetSpecialization()
	if token and specIdx and ns.MH_GetInterruptSpell then
		local name = ns.MH_GetInterruptSpell(token, specIdx)
		if type(name) == "string" and name ~= "" then
			myInterrupt = name:lower()
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
		print(("%s |cffffcf7d%s|r"):format(prefix, ns:L("INTERRUPT_MISS_HINT")))
		Speak(ns:L("INTERRUPT_MISS_TTS"))
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

function ns.HandleInterruptCommand(arg)
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	if arg == "alert" then
		ns.db = ns.db or {}
		ns.db.interruptMissAlert = not ns.db.interruptMissAlert
		print(("%s %s"):format(prefix, ns:L(ns.db.interruptMissAlert and "INTERRUPT_ALERT_ON" or "INTERRUPT_ALERT_OFF")))
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
f:SetScript("OnEvent", function(_, event, unit, _, spellID)
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
		-- Fresh tally per run: reset when we (re)enter an instance.
		if IsInInstance and IsInInstance() then
			ResetTally()
		end
		RefreshMyInterrupt()
	else -- PLAYER_LOGIN / PLAYER_SPECIALIZATION_CHANGED
		RefreshMyInterrupt()
	end
end)
