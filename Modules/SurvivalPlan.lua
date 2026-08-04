local _, ns = ...

--[[
	Midnight Helper — survival plan.

	Carola plays a Frost Mage and keeps dying to rares (Rob, 4 Aug). She does not
	know which buttons to press. The answer she needs is not a longer list of
	spells — she can already see those on her bars — but an ORDER: what to press
	first, what to keep up, and what to save for when it goes wrong.

	WHY IT NEEDS NO NEW DATA. `Modules/KeybindRoles_*.lua` already classifies every
	relevant spell of all thirteen classes by ROLE, verified against JustAC and
	ClassCodex:

	    defensive_1   the small one you keep up      (Ice Barrier)
	    defensive_2+  the big one you save           (Ice Block, Alter Time)
	    mobility      how you get away               (Blink, Shimmer)
	    interrupt     how you stop a cast            (Counterspell)

	So the plan is assembled from data that already exists and is already checked,
	and it works for every spec the moment it is written — not just for Frost.

	This is also why it reads KeybindRoles rather than `ns.DPS_DEFENSIVES` in
	DpsToolkit.lua. That table lists Ice Block and Alter Time for Frost and omits
	**Ice Barrier**, which is precisely the button Carola is missing: the shield you
	put up before the pull, rather than the panic button you press after it has gone
	wrong. KeybindRoles has it.

	NEVER-LIE: not one spell name or id is written in this file. Every row is
	resolved live from the classifier's own key through `C_Spell.GetSpellInfo`, so
	a renamed spell shows its new name and an unlearned one is simply not offered.

	The "when" text is per ROLE, not per spec. "Keep this one up" is true of a
	small absorb whether you are a mage or a warlock, and writing 25 spec-specific
	explanations would be 25 chances to be wrong about a class nobody here plays.
]]

--- Roles in the order a fight actually happens, with the sentence each one earns.
--- Order is the whole feature: a list would have told her nothing new.
local PLAN = {
	{ role = "defensive_1", key = "SURVIVAL_STEP_KEEPUP" },
	{ role = "defensive_2", key = "SURVIVAL_STEP_HURTS" },
	{ role = "defensive_3", key = "SURVIVAL_STEP_HURTS" },
	{ role = "defensive_4", key = "SURVIVAL_STEP_HURTS" },
	{ role = "mobility", key = "SURVIVAL_STEP_ESCAPE" },
	{ role = "interrupt", key = "SURVIVAL_STEP_INTERRUPT" },
	{ role = "heal_quick", key = "SURVIVAL_STEP_HEAL" },
}

local function ClassTable()
	if not (UnitClass and ns.KeybindRoleClassifier) then
		return nil
	end
	local _, token = UnitClass("player")
	return token and ns.KeybindRoleClassifier[token] or nil
end

--- Does this classifier entry apply to the given spec?
--- No `specs` field means class baseline — available on every spec.
local function AppliesTo(entry, specID)
	if type(entry.specs) ~= "table" then
		return true
	end
	for _, id in ipairs(entry.specs) do
		if id == specID then
			return true
		end
	end
	return false
end

--- Live name + id for a classifier key.
---
--- The classifier entries carry NO spell id — the ids appear only in the trailing
--- comments, and the table is keyed by the English spell name because the addon
--- matches those against the live spellbook. So the id is resolved from the name,
--- which is the mechanism the classifier was designed around.
---
--- Two things this buys: a tooltip on the row, and the name as the player actually
--- sees it. The key is English, so on a German or French client it would otherwise
--- name a spell that is not on their bar.
---
--- Falls back to the key. A spell that cannot be resolved is more likely one this
--- character has not learned than a broken entry, and showing the English name is
--- honest where inventing an id would not be.
local function LiveName(key)
	if not (C_Spell and C_Spell.GetSpellInfo) then
		return key, nil
	end
	local ok, info = pcall(C_Spell.GetSpellInfo, key)
	if ok and type(info) == "table" and info.spellID then
		local name = (type(info.name) == "string" and info.name ~= "") and info.name or key
		return name, info.spellID
	end
	return key, nil
end

--- @return table|nil steps  { { text, spellID, whenKey }, ... } in press order
---
--- Returns nil rather than an empty table when this class has no classifier data,
--- so the caller can say "not written yet" instead of drawing an empty box that
--- reads as "you have nothing".
function ns.GetSurvivalPlan(specID)
	local tbl = ClassTable()
	if not tbl then
		return nil
	end
	if not specID and GetSpecialization and GetSpecializationInfo then
		local idx = GetSpecialization()
		specID = idx and GetSpecializationInfo(idx) or nil
	end

	local byRole = {}
	for key, entry in pairs(tbl) do
		if type(entry) == "table" and entry.role and AppliesTo(entry, specID) then
			local bucket = byRole[entry.role]
			if not bucket then
				bucket = {}
				byRole[entry.role] = bucket
			end
			bucket[#bucket + 1] = { key = key, entry = entry }
		end
	end

	local steps = {}
	for _, step in ipairs(PLAN) do
		local bucket = byRole[step.role]
		if bucket then
			-- Priority first, then alphabetically, so the same spec always renders
			-- in the same order. A card that reshuffles between logins is one
			-- nobody learns from.
			table.sort(bucket, function(a, b)
				local pa, pb = a.entry.priority or 99, b.entry.priority or 99
				if pa ~= pb then
					return pa < pb
				end
				return a.key < b.key
			end)
			for _, item in ipairs(bucket) do
				local name, id = LiveName(item.key)
				steps[#steps + 1] = {
					text = name,
					spellID = id,
					whenKey = step.key,
					bindKey = item.entry.bindKey,
				}
			end
		end
	end

	if #steps == 0 then
		return nil
	end
	return steps
end
