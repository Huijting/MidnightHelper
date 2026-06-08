--[[
	Midnight Helper — Ritual Coach (fase 2): logic helpers, no UI.

	Mirrors the RitualSites.lua (logic) <-> WorldContent.lua (UI) split: this
	module exposes pure helpers that WorldContent renders into the Void & Rituals
	scroll. Data comes from RitualCoachData.lua; text from Locales/RitualTips.lua.

	Unlock detection: each challenge is a learnable obelisk spell (spellId). A
	learned one reads "Right click to unlearn" in-game, an unlearned one "Click to
	learn", so IsPlayerSpell(spellId) is the natural signal. pcall-guarded and
	best-effort: if the API can't tell, we fall back to "not unlocked" so the panel
	never claims something is unlocked when it isn't (never lie). Rob's char has 4
	learned / 4 not, so this is directly testable.
]]

local _, ns = ...

-- Ready-check texture for the "unlocked" tick — the plain unicode check renders
-- as a box in the WoW font (same fix as ProfessionAcademy ICON_COMPLETED).
local TICK = "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12:0:0|t"

--- True if the player has learned this challenge's obelisk spell.
function ns.IsRitualChallengeUnlocked(challenge)
	if type(challenge) ~= "table" or not challenge.spellId then
		return false
	end
	if type(IsPlayerSpell) == "function" then
		local ok, known = pcall(IsPlayerSpell, challenge.spellId)
		if ok and known then
			return true
		end
	end
	-- Secondary signal on some clients.
	if type(IsSpellKnown) == "function" then
		local ok, known = pcall(IsSpellKnown, challenge.spellId)
		if ok and known then
			return true
		end
	end
	return false
end

--- Inline icon markup for a challenge (FileDataID works in |T...|t).
function ns.RitualChallengeIconMarkup(challenge, size)
	if type(challenge) ~= "table" or not challenge.iconId then
		return ""
	end
	size = size or 14
	return ("|T%d:%d:%d:0:0|t"):format(challenge.iconId, size, size)
end

--- Challenges sorted by Spoils value (highest first) for the picker; ties keep
--- their data order. Returns a fresh array (never mutates the source).
function ns.GetRitualChallengesForDisplay()
	local out = {}
	if type(ns.RITUAL_CHALLENGES) ~= "table" then
		return out
	end
	for i, c in ipairs(ns.RITUAL_CHALLENGES) do
		out[i] = c
	end
	table.sort(out, function(a, b)
		local pa, pb = a.spoilsPct or 0, b.spoilsPct or 0
		if pa ~= pb then
			return pa > pb
		end
		return (a.id or "") < (b.id or "")
	end)
	return out
end

--- The site entry (RitualCoachData) for the currently active site, or nil if the
--- active site is undetected.
function ns.GetRitualCoachActiveSiteEntry()
	if not (ns.GetActiveRitualSite and ns.GetRitualSiteEntryByKey) then
		return nil
	end
	local site = ns.GetActiveRitualSite()
	if not site or not site.key then
		return nil
	end
	return ns.GetRitualSiteEntryByKey(site.key)
end

--- One coloured title line for a challenge: icon, name, +X% Spoils, unlock state.
--- Status words come from the locale pack so they translate.
function ns.BuildRitualChallengeTitle(challenge)
	if type(challenge) ~= "table" then
		return ""
	end
	local icon = ns.RitualChallengeIconMarkup(challenge, 14)
	local name = (challenge.nameKey and ns:L(challenge.nameKey)) or challenge.id or "?"
	local parts = {}
	if icon ~= "" then
		parts[#parts + 1] = icon
	end
	parts[#parts + 1] = "|cffffffff" .. name .. "|r"
	if challenge.spoilsPct then
		parts[#parts + 1] = ("|cff9ecbff+%d%% Spoils|r"):format(challenge.spoilsPct)
	end
	if ns.IsRitualChallengeUnlocked(challenge) then
		parts[#parts + 1] = TICK .. "|cff74e074 " .. ns:L("RITUAL_COACH_STATUS_UNLOCKED") .. "|r"
	else
		parts[#parts + 1] = "|cffd0a040(" .. ns:L("RITUAL_COACH_STATUS_LOCKED") .. ")|r"
	end
	return table.concat(parts, "  ")
end
