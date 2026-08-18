local _, ns = ...

--[[
	Midnight Helper — the third kind of prompt: you cannot stop this, so survive it.

	The Action prompt says INTERRUPT and PURGE. Both are things you do TO a cast. Rob
	spent 18 aug dying to a third kind in The Ring of Glory, and it needed a different
	sentence.

	MEASURED, in this order, over one morning:
	  • The mob is the Timeworn Golem (npc 264496). Its dangerous cast is Fissuring
	    Slam 388310 — 2 seconds, and it shatters the ground BENEATH up to five players
	    within 50 yards, thrown from as far as 100. It lands where you stand, so there
	    is nothing to outrange and nothing to step out of. That is exactly what Rob
	    reported before anyone looked it up.
	  • It is NOT interruptible. DandersFrames showed the shield icon on the cast bar,
	    and our own Action prompt stayed hidden — which is the correct behaviour, since
	    `notInterruptible` goes straight to the engine and never through our Lua.
	  • Valeera stopped it once. That was almost certainly a STUN, not a kick: a stun
	    works on the caster, an interrupt works on the cast.

	So the advice is "stun it or survive it", and INTERRUPT would have been wrong.

	⚠️ AND THEN THE MEASUREMENT KILLED THE DESIGN, which is why this file no longer
	works the way that story suggests. The first build matched the cast against the id
	above. It never once appeared. The counters it carried said why in a single fight:
	13 casts seen, 13 secret ids, 0 readable. Not a bug — 12.1 does not hand addons the
	id at all, and every other way of recognising the cast is closed too (see the block
	under this comment, which is the whole autopsy).

	So the prompt was rebuilt around the only mechanism left: show the frame always, and
	let the ENGINE set its alpha from `notInterruptible`, a value we hand over without
	ever reading. Exactly what ActionPrompt does for INTERRUPT, with the alphas swapped.

	⚠️ WHAT THIS COSTS, stated plainly because it is a real downgrade: the prompt cannot
	say "Fissuring Slam" any more, and cannot be limited to one mob. It speaks for EVERY
	uninterruptible cast your target starts. On the golem that is exactly right. On a
	raid boss it will talk more than you want. That is not a bug to fix later — it is the
	feature 12.1 permits, and if it proves too chatty the honest move is to remove it
	rather than to fake a filter out of values nobody can read.

	⚠️ IT STILL MEASURES WHILE IT RUNS. `ns.db.braceProbe` keeps counting readable versus
	secret ids even though nothing branches on them, so if 12.2 gives the id back we will
	see it instead of assuming forever that it is gone. `/mh brace` reports; `/mh brace
	slots` prints the per-cast sample; `/mh brace reset` clears it.

	⚠️ AND IT NAMES NO SPELL. "Use Hammer of Justice" would need a per-class stun list
	nobody has measured. "STUN OR DEFENSIVE" is true for every class that has either,
	and says nothing false to a class that has neither.
]]

--- ⚠️ THERE IS NO SPELL LIST HERE, AND ONE CANNOT BE ADDED. This file used to keep
--- `ns.BRACE_SPELLS = { [388310] = true }` and match the cast against it. That table is
--- gone because 12.1 makes it unusable, and the next person to reach for one should read
--- this before spending an evening on it:
---
---   • The spell id from UNIT_SPELLCAST_START is SECRET. 13 casts, 13 secrets, 0 readable
---     (Rob, The Ring of Glory, 18 aug). A secret cannot be compared, so `t[spellID]`
---     does not return false — it throws.
---   • The mob cannot stand in for the spell either: `UnitGUID("target")` is secret in a
---     delve, measured 16 aug on Gnarldor Isle (DelveCoach.lua:1704).
---   • Nor can the cast be fingerprinted. Sampling all twelve returns of UnitCastingInfo
---     over six casts gave: slots 1-5 and 7-9 SECRET (name, text, ICON, START and END
---     TIME, castID, notInterruptible, spellID), slot 6 false, slot 10 a plain counter,
---     slot 11 zero. With both timestamps secret even the cast's DURATION is unreadable.
---
--- So nothing distinguishes one enemy cast from another. What is left is the mechanism
--- below: hand the secret to the engine and let IT decide whether we are visible.
--- That cannot name the spell, and does not try to.

local function Prefix()
	return "|cff8fd3ffMidnight Helper|r"
end

local function Bump(key)
	ns.db = ns.db or {}
	ns.db.braceProbe = ns.db.braceProbe or {}
	ns.db.braceProbe[key] = (ns.db.braceProbe[key] or 0) + 1
end

--- Is this prompt allowed to speak for this character right now?
---
--- ⚠️ Rob asked for "only when I play Prot Paladin". Hardcoding a spec id would make
--- the feature dead for every other player on CurseForge, and the golem kills them
--- too. So the default gate is the honest version of his wish — only speak when the
--- player has something to do about it — and the spec restriction is his to switch
--- on, not the addon's to assume.
local function Allowed()
	local db = ns.db or {}
	if not db.bracePrompt then
		return false -- off until switched on, like the Action prompt
	end
	if db.bracePromptMySpecOnly then
		if not (GetSpecialization and GetSpecializationInfo) then
			return false
		end
		local okIdx, idx = pcall(GetSpecialization)
		if not okIdx or not idx then
			return false
		end
		local okID, specID = pcall(GetSpecializationInfo, idx)
		if not okID or specID ~= db.bracePromptSpecID then
			return false
		end
	end
	return true
end

--- Getters and setters, so the Settings panel has something to bind to.
---
--- ⚠️ These exist because the command came first and the switch came second, which is
--- backwards and is the mistake this file was already an example of. Every other
--- toggle in the addon exposes Is/Set pairs for exactly this reason.
function ns.IsBracePromptEnabled()
	return (ns.db and ns.db.bracePrompt) and true or false
end

function ns.SetBracePromptEnabled(v)
	ns.db = ns.db or {}
	ns.db.bracePrompt = v and true or nil
	if not v and frame then
		frame:Hide()
	end
end

function ns.IsBracePromptSpecOnly()
	return (ns.db and ns.db.bracePromptMySpecOnly) and true or false
end

--- Turning this on remembers the spec you are standing in RIGHT NOW. That is the whole
--- mechanism — no table of spec ids, and it works for any class.
function ns.SetBracePromptSpecOnly(v)
	ns.db = ns.db or {}
	if not v then
		ns.db.bracePromptMySpecOnly = nil
		ns.db.bracePromptSpecID = nil
		return
	end
	local specID
	if GetSpecialization and GetSpecializationInfo then
		local okIdx, idx = pcall(GetSpecialization)
		if okIdx and idx then
			local okID, sid = pcall(GetSpecializationInfo, idx)
			specID = okID and sid or nil
		end
	end
	if not specID then
		-- Cannot read the spec: leave it off rather than lock the prompt to nothing.
		ns.db.bracePromptMySpecOnly = nil
		ns.db.bracePromptSpecID = nil
		return
	end
	ns.db.bracePromptMySpecOnly = true
	ns.db.bracePromptSpecID = specID
end

local frame

local function EnsureFrame()
	if frame then
		return frame
	end
	--- A display frame, never a secure one. Same rule as the Action prompt: scripts on
	--- a SecureActionButtonTemplate taint it, which is what broke click-to-target on
	--- 3 aug. This tells you what to press; your own keybind presses it.
	---
	--- ⚠️ A BUTTON, NOT A FRAME, and that is not a style choice. `SetAlphaFromBoolean`
	--- exists on Buttons and is missing on plain Frames — ActionPrompt.lua:62 records
	--- losing a reload to exactly this: the guarded else-branch set alpha 0 and the
	--- feature failed silently, looking for all the world like broken detection. This
	--- prompt now depends on that method entirely, since the engine setting our alpha
	--- from a secret is the ONLY way it can ever appear.
	---
	--- Mouse off: a Button takes clicks by default and this one sits mid-screen.
	frame = CreateFrame("Button", nil, UIParent)
	frame:EnableMouse(false)
	frame:SetSize(320, 64)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
	frame:SetFrameStrata("HIGH")
	frame:EnableMouse(false)

	local word = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	word:SetPoint("CENTER")
	word:SetTextColor(1, 0.35, 0.25)
	frame.word = word

	local sub = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	sub:SetPoint("TOP", word, "BOTTOM", 0, -4)
	sub:SetTextColor(1, 0.82, 0.3)
	frame.sub = sub

	frame:Hide()
	return frame
end

local hideTimer

--- @param notInterruptible any SECRET. Never read, never negated — only handed over.
local function Show(notInterruptible)
	local f = EnsureFrame()
	f.word:SetText((ns.L and ns:L("BRACE_WORD")) or "BRACE")
	f.sub:SetText((ns.L and ns:L("BRACE_SUB")) or "")
	f:Show()

	--- ⚠️ THE WHOLE FEATURE IS THIS LINE. We show the frame unconditionally and let the
	--- ENGINE set its alpha from a value we are not allowed to see. Argument order is
	--- (value, alphaWhenTrue, alphaWhenFalse) — proven in CombatSafety.lua:462 — and we
	--- want the OPPOSITE of the Action prompt, so the alphas are 1,0 there and 0,1 here.
	--- Negating `notInterruptible` would mean reading it, which throws.
	---
	--- Both font strings are children of this button, so they inherit its alpha. That is
	--- why the words appear exactly when the cast cannot be interrupted, while our Lua
	--- never learns whether it could.
	if f.SetAlphaFromBoolean then
		f:SetAlphaFromBoolean(notInterruptible, 1, 0)
	else
		--- Not a fallback, a refusal. Showing it at full alpha would mean warning about
		--- every cast including the ones you should be kicking.
		Bump("noAlphaFromBoolean")
		f:SetAlpha(0)
	end
	if hideTimer then
		hideTimer:Cancel()
	end
	--- Three seconds: longer than the 2-second cast, so it is still on screen at the
	--- moment of impact, and gone before it becomes wallpaper.
	if C_Timer and C_Timer.After then
		hideTimer = C_Timer.NewTimer(3, function()
			if frame then
				frame:Hide()
			end
		end)
	end
end

--- What is this value, without ever assuming it is safe to look at?
---
--- ⚠️ The secret check comes FIRST and the `type()` check second, never the other way
--- round. `type()` on a secret string answers "string" quite happily — that exact
--- mistake crashed `/mh here` on the golem on 18 aug.
local function Describe(v)
	if ns.IsSecretValue and ns.IsSecretValue(v) then
		return "SECRET"
	end
	if v == nil then
		return "nil"
	end
	local t = type(v)
	if t == "number" then
		return ("num %s"):format(tostring(v))
	elseif t == "string" then
		if ns.CanAccessText and ns.CanAccessText(v) then
			return ("str %q"):format(v:sub(1, 40))
		end
		return "str (blocked)"
	elseif t == "boolean" then
		return v and "bool true" or "bool false"
	end
	return t
end

--- Record every return slot of UnitCastingInfo, readable or not.
---
--- ⚠️ THIS IS A MEASUREMENT, NOT A FEATURE. The spell id came back secret 13 times out
--- of 13, and a delve target's GUID has been secret since 16 aug, so neither the spell
--- nor the mob can be named. The prompt therefore has to work the way the Action prompt
--- does — hand `notInterruptible` straight to `SetAlphaFromBoolean` and let the engine
--- decide — which fires on EVERY uninterruptible cast, and a boss does those all fight.
--- Something has to narrow it, and the only honest way to find out what is left to
--- narrow it WITH is to write down which slots survive. Slot numbers are deliberately
--- not named: naming them would be the guess this is meant to replace.
local function SampleCastInfo()
	if not UnitCastingInfo then
		return
	end
	local packed = { pcall(UnitCastingInfo, "target") }
	if not packed[1] then
		Bump("castingInfoError")
		return
	end
	local db = ns.db and ns.db.braceProbe
	if not db then
		return
	end
	db.samples = db.samples or {}
	if #db.samples >= 12 then
		return -- twelve is plenty to read a pattern; the SV file stays small
	end
	local row = {}
	for i = 2, 13 do
		row[#row + 1] = ("%d=%s"):format(i - 1, Describe(packed[i]))
	end
	db.samples[#db.samples + 1] = table.concat(row, " · ")
end

--- @param spellID any the third payload of UNIT_SPELLCAST_START — readable or secret
local function OnCastStart(unit, spellID)
	if unit ~= "target" then
		return
	end
	Bump("castsSeen")
	pcall(SampleCastInfo)

	--- The id counters stay, even though nothing branches on them any more. They are the
	--- evidence for why this module works the way it does, and if 12.2 ever hands the id
	--- back they are how we will find out — instead of assuming forever that it cannot.
	if ns.IsSecretValue and ns.IsSecretValue(spellID) then
		Bump("idWasSecret")
	elseif type(spellID) == "number" then
		Bump("idReadable")
	end

	if not Allowed() then
		Bump("suppressedByGate")
		return
	end

	--- Slot 10 is `castBarID` and is READABLE — measured 18 aug, six casts, six
	--- increasing integers. It is the only fact about an enemy cast 12.1 still gives us,
	--- and all it proves is that a cast exists. That is enough to avoid showing the
	--- prompt when nothing is being cast; the engine judges the rest.
	local notInterruptible, castBarID
	if UnitCastingInfo then
		local ok, _, _, _, _, _, _, _, ni, _, id = pcall(UnitCastingInfo, "target")
		if ok then
			notInterruptible, castBarID = ni, id
		else
			Bump("castingInfoError")
		end
	end
	if castBarID == nil then
		Bump("nothingCasting")
		return
	end
	Bump("reached")
	Show(notInterruptible)
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function(_, event, unit, _, spellID)
	if event == "PLAYER_ENTERING_WORLD" then
		--- Registered per-unit rather than broadly: the prompt only ever speaks about
		--- the thing you are looking at, so there is no reason to watch the world.
		if ev.RegisterUnitEvent then
			pcall(ev.RegisterUnitEvent, ev, "UNIT_SPELLCAST_START", "target")
		else
			ev:RegisterEvent("UNIT_SPELLCAST_START")
		end
		return
	end
	if event == "UNIT_SPELLCAST_START" then
		pcall(OnCastStart, unit, spellID)
	end
end)

--- `/mh brace` — toggle, and print what the probe has seen.
function ns.ToggleBracePrompt(arg)
	ns.db = ns.db or {}
	if arg == "spec" then
		--- Rob's "only on my Prot Paladin", stored as a choice rather than baked in.
		--- Remembers whichever spec he is on when he types it, so it needs no table of
		--- spec ids and works for anyone.
		if ns.db.bracePromptMySpecOnly then
			ns.db.bracePromptMySpecOnly = nil
			ns.db.bracePromptSpecID = nil
			print(("%s %s"):format(Prefix(), (ns.L and ns:L("BRACE_ANY_SPEC")) or "any spec"))
			return
		end
		local okIdx, idx = pcall(GetSpecialization)
		local specID
		if okIdx and idx then
			local okID, sid = pcall(GetSpecializationInfo, idx)
			specID = okID and sid or nil
		end
		if not specID then
			print(("%s |cffff5040could not read your spec — leaving it on for all specs.|r"):format(Prefix()))
			return
		end
		ns.db.bracePromptMySpecOnly = true
		ns.db.bracePromptSpecID = specID
		print(("%s %s"):format(Prefix(),
			((ns.L and ns:L("BRACE_THIS_SPEC")) or "this spec only (%d)"):format(specID)))
		return
	end

	--- ⚠️ BARE `/mh brace` NO LONGER TOGGLES. Rob turned it on, went to the golem, saw
	--- nothing, and the only way to read the counters that explain why was to type the
	--- command again — which switched the feature off. A diagnostic you have to break
	--- the thing to read is not a diagnostic.
	---
	--- The switch lives in Settings now, so the command is free to just report. `on`
	--- and `off` still work for anyone who prefers typing.
	if arg == "on" or arg == "off" then
		if ns.SetBracePromptEnabled then
			ns.SetBracePromptEnabled(arg == "on")
		end
	elseif arg == "reset" then
		--- So a second measurement is not read on top of the first one's numbers.
		ns.db.braceProbe = nil
		print(("%s |cff8a8f98counters cleared.|r"):format(Prefix()))
		return
	end
	print(("%s %s"):format(Prefix(), ns.db.bracePrompt
		and ((ns.L and ns:L("BRACE_ON")) or "on")
		or ((ns.L and ns:L("BRACE_OFF")) or "off")))

	local p = ns.db.braceProbe or {}
	print(("   |cff8a8f98casts seen %d · readable ids %d · secret ids %d · matched %d|r"):format(
		p.castsSeen or 0, p.idReadable or 0, p.idWasSecret or 0, p.matched or 0))
	if (p.castsSeen or 0) > 0 and (p.idReadable or 0) == 0 then
		print(("   |cffff5040%s|r"):format(
			(ns.L and ns:L("BRACE_ALL_SECRET")) or
			"Every cast id came back secret, so this prompt can never fire."))
	end
	--- The other way it can be silent, and the one Rob is most likely hitting: the
	--- event never arrived. Say which of the two it is instead of leaving him to guess.
	if (p.castsSeen or 0) == 0 then
		print(("   |cffffd100%s|r"):format(
			(ns.L and ns:L("BRACE_NO_CASTS")) or
			"No casts seen at all - the mob has to be your TARGET before it starts casting."))
	end

	--- The measurement, printed rather than only written to SavedVariables — Rob should
	--- not need me to read a file to see what his own client answered.
	if arg == "slots" then
		local s = p.samples or {}
		if #s == 0 then
			print("   |cff8a8f98no cast samples yet — target something that casts.|r")
			return
		end
		for i = 1, #s do
			print(("   |cff8a8f98[%d]|r %s"):format(i, s[i]))
		end
	elseif p.samples and #p.samples > 0 then
		print(("   |cff8a8f98%d cast samples stored — /mh brace slots to read them.|r"):format(#p.samples))
	end
end
