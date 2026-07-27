local _, ns = ...

--[[
	Midnight Helper — dispel helper, first slice.

	The pieces for this have been lying around for weeks and were never joined up:

	  ns.GetKnownClassDispels()  what THIS character can dispel, filtered on
	                             IsPlayerSpell so nothing is claimed for a spec
	                             that does not have it
	  ns.HEALER_DISPELS[spec]    the healing-spec variant, verified against JustAC
	  ns.Aura.ForEachPlayerDebuff  secret-safe reads through the 12.1 facade
	  DispelCapture.lua          already records which schools bosses actually use

	What was missing is the one sentence that matters in the moment: **you have
	something on you right now that you can remove yourself.**

	⚠️ YOUR OWN DEBUFFS ONLY, and that is a deliberate limit rather than a first
	step half-done. In 12.x another unit's auras can be secret, and on the 12.1
	release candidate only the PLAYER's own auras have been measured as readable
	(2026-07-27). A party-wide dispel helper would be built on something nobody has
	confirmed can be read. Your own debuffs are fully readable, in every kind of
	content, including the delves where the rest of 12.1 turns opaque.

	Never-lie throughout:
	  • A secret dispelName is skipped. Unreadable is not the same as absent, and
	    this never reports "nothing to dispel" -- it reports what it can see.
	  • Nothing is shown for a character with no dispel. GetKnownClassDispels
	    already returns empty there, and an alert you cannot act on is noise.
	  • The school comes from the game's own dispelName, never from a table of
	    spell ids we maintain.
]]

-- The API's English school string -> our canonical key. Same map DispelCapture
-- uses; kept local rather than shared because one file owning a two-line table is
-- cheaper than a dependency between them.
local SCHOOL = {
	Magic = "magic",
	Curse = "curse",
	Poison = "poison",
	Disease = "disease",
}

local function isSecret(v)
	return issecretvalue ~= nil and issecretvalue(v)
end

--- Every debuff school this character can actually remove from a friendly target.
--- Healing spec and non-healing spec both counted: a Prot Paladin dispels too,
--- which was Rob's point on 2026-07-15 and is why the toolkit shows it for
--- non-healers as well.
--- @return table set  { magic = true, poison = true, ... } (possibly empty)
--- @return table list { { id, types }, ... } the spells behind it
function ns.GetDispellableSchools()
	local set, spells = {}, {}

	local known = ns.GetKnownClassDispels and ns.GetKnownClassDispels()
	if type(known) == "table" then
		for _, d in ipairs(known) do
			spells[#spells + 1] = d
			for _, t in ipairs(d.types or {}) do
				set[t] = true
			end
		end
	end

	-- The healing-spec dispel, when this character is in that spec.
	if ns.HEALER_DISPELS and GetSpecialization and GetSpecializationInfo then
		local okIdx, idx = pcall(GetSpecialization)
		if okIdx and idx then
			local okID, specID = pcall(GetSpecializationInfo, idx)
			local d = okID and specID and ns.HEALER_DISPELS[specID]
			if d then
				-- Only if the character really has the spell. Same honesty bar as
				-- GetKnownClassDispels: a spec table is not proof of a spellbook.
				local known2 = true
				if IsPlayerSpell then
					local okS, res = pcall(IsPlayerSpell, d.id)
					known2 = (not okS) or res == true
				end
				if known2 then
					spells[#spells + 1] = d
					for _, t in ipairs(d.types or {}) do
						set[t] = true
					end
				end
			end
		end
	end

	return set, spells
end

--- Debuffs on YOU right now that YOU could dispel.
---
--- @return table found  { { name, school, spellID }, ... } — empty is "none seen",
---                      which is not the same as "none there"; see `readable`.
--- @return boolean readable  false when the aura scan itself could not be trusted
function ns.GetDispellableSelfDebuffs()
	local found = {}
	local schools = ns.GetDispellableSchools()
	if not next(schools) then
		return found, true -- nothing this character can dispel: honestly empty
	end
	if not (ns.Aura and ns.Aura.ForEachPlayerDebuff) then
		return found, false
	end

	local ok = ns.Aura.ForEachPlayerDebuff(function(aura)
		local dn = aura and aura.dispelName
		if dn == nil or isSecret(dn) then
			return -- unreadable: say nothing about it either way
		end
		local school = SCHOOL[dn]
		if not school or not schools[school] then
			return
		end
		local name = aura.name
		if isSecret(name) then
			name = nil
		end
		found[#found + 1] = {
			name = name,
			school = school,
			spellID = (not isSecret(aura.spellId)) and aura.spellId or nil,
		}
	end)

	return found, ok and true or false
end

--- /mh dispel — what can you remove from yourself right now?
function ns.PrintDispelStatus()
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	local schools, spells = ns.GetDispellableSchools()

	if #spells == 0 then
		print(("%s %s"):format(prefix, ns:L("DISPEL_NONE_KNOWN")))
		return
	end

	local names = {}
	for _, d in ipairs(spells) do
		local n = ns.HealerCooldownSpellName and ns.HealerCooldownSpellName(d.id)
		names[#names + 1] = n or tostring(d.id)
	end
	local schoolList = {}
	for s in pairs(schools) do
		schoolList[#schoolList + 1] = s
	end
	table.sort(schoolList)
	print(("%s %s"):format(prefix, ns:L("DISPEL_HEADER")))
	print(("   %s: %s"):format(table.concat(names, ", "), table.concat(schoolList, ", ")))

	local found, readable = ns.GetDispellableSelfDebuffs()
	if not readable then
		-- The one thing this must never do is turn an unreadable scan into "clear".
		print("   " .. ns:L("DISPEL_UNREADABLE"))
		return
	end
	if #found == 0 then
		print("   " .. ns:L("DISPEL_CLEAR"))
		return
	end
	for _, d in ipairs(found) do
		print(("   |cffff8080%s|r  (%s)%s"):format(
			tostring(d.name or "?"), d.school,
			d.spellID and ("  spell " .. tostring(d.spellID)) or ""))
	end
end

--------------------------------------------------------------------------------
-- The live alert.
--
-- This deliberately does NOT register its own UNIT_AURA handler. AccessibleAlerts
-- already runs one, engine-filtered to the player, with a global cooldown and a
-- per-spell cooldown, reading through ns.Aura and skipping secret values. A second
-- handler on the same event would double the work every time an aura changes on
-- you, and would need its own copy of every one of those guards.
--
-- So this exposes a hook that the existing scan calls, and owns only two things:
-- its own on/off setting, and the decision of what counts as worth saying.
--
-- Separate setting on purpose. AccessibleAlerts is a beginner accessibility aid;
-- wanting "tell me when I can cleanse myself" is a different wish, and a raider
-- who wants the second should not have to switch on the first.
--------------------------------------------------------------------------------

local function AlertSettings()
	if not ns.db then
		return nil
	end
	ns.db.dispelAlert = ns.db.dispelAlert or {}
	local d = ns.db.dispelAlert
	if d.enabled == nil then
		d.enabled = false -- opt-in, like every other on-screen helper here
	end
	return d
end

--- @return boolean
function ns.DispelAlertEnabled()
	local d = AlertSettings()
	return (d and d.enabled) and true or false
end

--- @return boolean now
function ns.ToggleDispelAlert()
	local d = AlertSettings()
	if not d then
		return false
	end
	d.enabled = not d.enabled
	return d.enabled
end

--- Called by AccessibleAlerts for each readable debuff it scans.
---
--- Returns the line to show, or nil to stay quiet. Kept to a pure decision with no
--- side effects: the caller owns the cooldowns, the sound and the frame, so this
--- cannot accidentally alert twice or bypass a gap.
---
--- @param aura table  a debuff already checked for a readable spellId
--- @return string|nil message
function ns.GetDispelAlertFor(aura)
	if not ns.DispelAlertEnabled() then
		return nil
	end
	if type(aura) ~= "table" then
		return nil
	end
	local dn = aura.dispelName
	if dn == nil or isSecret(dn) then
		return nil -- unreadable: not "no school", just unknown
	end
	local school = SCHOOL[dn]
	if not school then
		return nil
	end
	local schools = ns.GetDispellableSchools()
	if not schools[school] then
		return nil -- something else's job, or nobody's
	end
	local name = aura.name
	if name == nil or isSecret(name) then
		name = nil
	end
	if name then
		return (ns:L("DISPEL_ALERT_FMT")):format(name)
	end
	-- The school alone is still actionable, and is better than inventing a name.
	return (ns:L("DISPEL_ALERT_SCHOOL_FMT")):format(ns:L("DISPEL_SCHOOL_" .. school:upper()))
end
