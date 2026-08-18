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

	⚠️ THIS MODULE MEASURES WHILE IT RUNS, because two things are unverified and the
	feature depends on both:
	  1. whether `UNIT_SPELLCAST_START` hands addons a READABLE spellID in 12.1, or a
	     secret like so much else this patch;
	  2. whether the event fires for a target at all in the content Rob plays.
	Every cast it sees is counted into `ns.db.braceProbe`, readable or not. If the ids
	come back secret the prompt simply never fires and the counter says why — instead
	of a feature that silently does nothing and looks broken.

	⚠️ AND IT NAMES NO SPELL. "Use Hammer of Justice" would need a per-class stun list
	nobody has measured. "STUN OR DEFENSIVE" is true for every class that has either,
	and says nothing false to a class that has neither.
]]

--- Casts you cannot interrupt and cannot walk out of. One entry, and that is honest:
--- it is the only one anybody has measured. The list grows when the next one is.
---
--- ⚠️ Do NOT add a spell here because a guide called it dangerous. The bar is: not
--- interruptible AND not avoidable by moving. Anything you can side-step belongs in
--- HazardData, where it already is.
ns.BRACE_SPELLS = {
	[388310] = true, -- Fissuring Slam (Timeworn Golem, The Ring of Glory)
}

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

local frame

local function EnsureFrame()
	if frame then
		return frame
	end
	--- A display frame, never a secure one. Same rule as the Action prompt: scripts on
	--- a SecureActionButtonTemplate taint it, which is what broke click-to-target on
	--- 3 aug. This tells you what to press; your own keybind presses it.
	frame = CreateFrame("Frame", nil, UIParent)
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

local function Show()
	local f = EnsureFrame()
	f.word:SetText((ns.L and ns:L("BRACE_WORD")) or "BRACE")
	f.sub:SetText((ns.L and ns:L("BRACE_SUB")) or "")
	f:Show()
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

--- @param spellID any the third payload of UNIT_SPELLCAST_START — readable or secret
local function OnCastStart(unit, spellID)
	if unit ~= "target" then
		return
	end
	Bump("castsSeen")

	--- ⚠️ The whole measurement. A secret id is not a small id — it cannot be compared
	--- at all, and `ns.BRACE_SPELLS[spellID]` on one would throw. Ask first.
	if ns.IsSecretValue and ns.IsSecretValue(spellID) then
		Bump("idWasSecret")
		return
	end
	if type(spellID) ~= "number" then
		Bump("idNotANumber")
		return
	end
	Bump("idReadable")

	if not ns.BRACE_SPELLS[spellID] then
		return
	end
	Bump("matched")
	if not Allowed() then
		Bump("suppressedByGate")
		return
	end
	Show()
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

	ns.db.bracePrompt = not ns.db.bracePrompt or nil
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
end
