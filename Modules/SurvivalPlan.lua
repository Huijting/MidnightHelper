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

--- Steps in the order a fight actually happens.
---
--- ⚠️ CORRECTED 4 Aug, after Rob checked it on the Frost Mage the first version was
--- written for. Two structural mistakes:
---
--- 1. The classifier has TWO fields, not one. `role` is the fixed key slots
---    (defensive_1..4, interrupt, …) and `category` is everything that did not
---    earn its own key (defensive, selfheal, dispel_cc, …). Reading only `role`
---    dropped **Alter Time**, which is `category = "defensive"` — a defensive, on
---    the very spec this was built for.
--- 2. `mobility` is a real role (key R in KeybindSchema) but Mage does not use it:
---    Blink sits at `utility_primary` (Q). And `utility_primary` means general
---    utility in the schema, not escape — on another class it is something else
---    entirely. So "how do I get away" CANNOT be derived reliably, and the first
---    version claimed it could. It is now only shown where a class genuinely uses
---    the `mobility` role, and skipped in silence otherwise.
---
--- `dispel_cc` is deliberately left out even though Frost Nova lives there and is
--- a real escape tool for a mage. The same category holds Polymorph and Remove
--- Curse, so including it would put crowd control under "stay alive" for every
--- class. Four right rows beat seven with two wrong ones.
--- `survival` — an explicit third field, added 4 Aug.
---
--- Rob wanted Frost Nova and Blink on the card. Neither can be derived: Blink is
--- `utility_primary` because that is the key it belongs on, and Frost Nova is
--- `dispel_cc` alongside Polymorph and Remove Curse. Both classifications are
--- correct for what they are for — deciding keys — and wrong for this question.
---
--- Rather than bend `role` or `category`, which would move keybinds and change
--- what the allocator does, an entry may now carry `survival = "<step>"`. It says
--- one thing only: this spell belongs on the survival card, at this step. Nothing
--- else reads it.
---
--- The cost is that it must be tagged per class by hand, and the benefit is that
--- it is a deliberate judgement per spell instead of a rule that guesses right for
--- mages and wrong for paladins.
local PLAN = {
	{ survival = "keepup", roles = { "defensive_1" }, key = "SURVIVAL_STEP_KEEPUP" },
	{ survival = "hurts", roles = { "defensive_2", "defensive_3", "defensive_4" },
		categories = { "defensive" }, key = "SURVIVAL_STEP_HURTS" },
	{ survival = "heal", roles = { "heal_quick", "heal_ooc", "heal_sustain" },
		categories = { "selfheal" }, key = "SURVIVAL_STEP_HEAL" },
	{ survival = "escape", roles = { "mobility" }, key = "SURVIVAL_STEP_ESCAPE" },
	{ survival = "interrupt", roles = { "interrupt" }, categories = { "interrupt" },
		key = "SURVIVAL_STEP_INTERRUPT" },
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
--- @return string|nil name, number|nil spellID  — nil when the player lacks it
---
--- ⚠️ The known-check is not a nicety, it is what makes the card true. Blink and
--- Shimmer are both classified for Mage, but Shimmer is a talent that REPLACES
--- Blink — nobody has both, and the first version listed both. Same for Mirror
--- Image, Greater Invisibility and every other talent entry.
---
--- `C_Spell.GetSpellInfo` answers for spells that merely EXIST, so it cannot carry
--- this on its own; `IsPlayerSpell` is the filter, the same one
--- `ns.GetKnownClassDispels` already uses so the two agree about what you own.
---
--- Fails open: if IsPlayerSpell is missing we show the row. A card with one row
--- too many is repairable by eye; one silently missing your panic button is not.
local function LiveName(key)
	if not (C_Spell and C_Spell.GetSpellInfo) then
		return key, nil
	end
	local ok, info = pcall(C_Spell.GetSpellInfo, key)
	if not (ok and type(info) == "table" and info.spellID) then
		return nil
	end
	if IsPlayerSpell then
		local kOk, known = pcall(IsPlayerSpell, info.spellID)
		if kOk and known ~= true then
			return nil
		end
	end
	local name = (type(info.name) == "string" and info.name ~= "") and info.name or key
	return name, info.spellID
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

	-- Index by all three fields, since a spell may be classified any of the ways.
	local byRole, byCategory, bySurvival = {}, {}, {}
	for key, entry in pairs(tbl) do
		if type(entry) == "table" and AppliesTo(entry, specID) then
			if entry.role then
				byRole[entry.role] = byRole[entry.role] or {}
				table.insert(byRole[entry.role], { key = key, entry = entry })
			end
			if entry.category then
				byCategory[entry.category] = byCategory[entry.category] or {}
				table.insert(byCategory[entry.category], { key = key, entry = entry })
			end
			if entry.survival then
				bySurvival[entry.survival] = bySurvival[entry.survival] or {}
				table.insert(bySurvival[entry.survival], { key = key, entry = entry })
			end
		end
	end

	local steps, already = {}, {}
	for _, step in ipairs(PLAN) do
		local bucket = {}
		-- Explicitly tagged spells join the same bucket; the sort below decides the
		-- final order by priority, so a tag adds a row without jumping the queue.
		for _, item in ipairs(step.survival and bySurvival[step.survival] or {}) do
			bucket[#bucket + 1] = item
		end
		for _, r in ipairs(step.roles or {}) do
			for _, item in ipairs(byRole[r] or {}) do
				bucket[#bucket + 1] = item
			end
		end
		for _, c in ipairs(step.categories or {}) do
			for _, item in ipairs(byCategory[c] or {}) do
				bucket[#bucket + 1] = item
			end
		end
		if #bucket > 0 then
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
				-- A spell carrying both a role and a category would otherwise be
				-- listed twice under the same step.
				if not already[item.key] then
					already[item.key] = true
					local name, id = LiveName(item.key)
					-- nil means this character does not have it. Skip in silence:
					-- naming a spell someone cannot cast is worse than a short card.
					if name then
						steps[#steps + 1] = {
							text = name,
							spellID = id,
							whenKey = step.key,
							bindKey = item.entry.bindKey,
						}
					end
				end
			end
		end
	end

	if #steps == 0 then
		return nil
	end
	return steps
end
