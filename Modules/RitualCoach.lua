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

-- NOTE: there is deliberately no per-player "unlocked" detection here. The
-- obelisk's "Click to learn / Right click to unlearn" (Rank 0/1 vs 1/1) is the
-- per-run SELECTION toggle, not a permanent unlock (Rob verified in-game: any
-- challenge flips back to "learn" once deselected). So IsPlayerSpell(spellId)
-- reads selection, which would mislead in the panel — we show only static, always-
-- true reference (mechanic + how to unlock). A real "have I permanently unlocked
-- this" signal would come from the unlock-quest flags (fase 4, still open).

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

--- One coloured title line for a challenge: icon, name, +X% Spoils.
--- (No per-player status — see the note near the top of this file.)
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
	return table.concat(parts, "  ")
end
