--[[
	GroupPlan.lua — the fifth "How you play" tab, "Group": buttons you press FOR SOMEONE ELSE
	(ally-target) or for the whole group, in plain words.

	3 Oct 2026. Proposed by the play-card audit (docs/playcards_audit_2026-10-03/), sketched for
	Prot Paladin, approved by Rob ("E en G zijn goedgekeurd"; tab name "Group" / "Groep").

	📌 OWN DATA, NOT KeybindRoles TAGS. Every matched KeybindRoles entry is handed to the key
	allocator (KeybindAutoMap.lua), so tagging new spells there could move binds, and most group
	spells of other classes are name-only there (a name only resolves out of your own spellbook).
	Here every row carries a CONFIRMED spell id. Ownership and the displayed name go through the
	same check as "Stay alive" (ns.SurvivalLiveName: IsPlayerSpell on the base, skip passives,
	show the override name), so an untalented spell drops off by itself.

	📌 A SPEC WITHOUT ROWS GETS NO TAB. The brief: "leave the tab out with a reason, never show it
	empty" (an empty-but-present box reads as advice). `/mh group` prints, per row, shown or why not.

	Row fields: step ("save" | "heal" | "free" | "raid" | "boost" | "rez"), id (spell id), name
	(English fallback for the trace only), note (optional locale key, a short remark). Rows are
	drawn in GROUP_STEPS order, then in list order.
]]

local _, ns = ...

local GROUP_STEPS = {
	{ step = "save", key = "GROUP_STEP_SAVE" },
	{ step = "heal", key = "GROUP_STEP_HEAL" },
	{ step = "free", key = "GROUP_STEP_FREE" },
	{ step = "raid", key = "GROUP_STEP_RAID" },
	{ step = "boost", key = "GROUP_STEP_BOOST" },
	{ step = "rez", key = "GROUP_STEP_REZ" },
}

--- Per spec: source line (guides + dates) and rows. Research files: scratchpad cards\group_*.json.
ns.GROUP_PLAN = {
	-- Protection Paladin. Icy Veins 21 Aug + 21 Sep · Method 3 Sep · Wowhead 12 Aug 2026 (sketch, 3 Oct).
	[66] = {
		source = "Icy Veins 21 Aug + 21 Sep · Method 3 Sep · Wowhead 12 Aug 2026",
		rows = {
			{ step = "save", id = 6940, name = "Blessing of Sacrifice", note = "GROUP_NOTE_SAC" },
			{ step = "save", id = 1022, name = "Blessing of Protection", note = "GROUP_NOTE_BOP" },
			{ step = "save", id = 204018, name = "Blessing of Spellwarding", note = "GROUP_NOTE_SPELLWARD" },
			{ step = "heal", id = 85673, name = "Word of Glory", note = "GROUP_NOTE_WOG_OTHER" },
			{ step = "heal", id = 633, name = "Lay on Hands", note = "GROUP_NOTE_LOH" },
			{ step = "free", id = 1044, name = "Blessing of Freedom" },
			{ step = "raid", id = 465, name = "Devotion Aura", note = "GROUP_NOTE_AURA" },
			-- 391054: the id Rob's own client holds on his paladin's bar (SavedVariables, slot 63).
			{ step = "rez", id = 391054, name = "Intercession", note = "GROUP_NOTE_BREZ" },
			{ step = "rez", id = 7328, name = "Redemption", note = "GROUP_NOTE_OOC" },
		},
	},
}

--- True when this spec has group data at all (decides whether the tab exists).
function ns.HasGroupPlan(specID)
	local d = specID and ns.GROUP_PLAN[specID]
	return d ~= nil and type(d.rows) == "table" and #d.rows > 0
end

function ns.GetGroupPlanSource(specID)
	local d = specID and ns.GROUP_PLAN[specID]
	return d and d.source or nil
end

--- @return table|nil steps  { { text, spellID, whenKey, noteKey }, ... } — same shape as Stay alive.
function ns.GetGroupPlan(specID, trace)
	local d = specID and ns.GROUP_PLAN[specID]
	if not d or type(d.rows) ~= "table" then
		return nil
	end
	local steps, already = {}, {}
	for _, gs in ipairs(GROUP_STEPS) do
		for _, row in ipairs(d.rows) do
			if row.step == gs.step then
				local name, idOrWhy
				if ns.SurvivalLiveName then
					name, idOrWhy = ns.SurvivalLiveName(row.name, { id = row.id }, specID)
				else
					name, idOrWhy = row.name, row.id
				end
				local id = name and idOrWhy or nil
				local dedupe = id or name
				local shown = name and not already[dedupe]
				if shown then
					already[dedupe] = true
					steps[#steps + 1] = { text = name, spellID = id, whenKey = gs.key, noteKey = row.note }
				end
				if trace then
					trace[#trace + 1] = {
						key = row.name .. " (" .. tostring(row.id) .. ")",
						step = gs.step,
						shown = shown and true or false,
						why = shown and "" or (name and "same spell already listed") or idOrWhy,
					}
				end
			end
		end
	end
	return #steps > 0 and steps or nil
end

--- `/mh group` — what the Group tab shows for your spec, and why each row is in or out.
function ns.PrintGroupPlanTrace()
	local specID
	if ns.GetSpecialization and ns.GetSpecializationInfo then
		local idx = ns.GetSpecialization()
		specID = idx and ns.GetSpecializationInfo(idx) or nil
	end
	local prefix = ("|cffffcc00%s|r "):format(ns:L("PRINT_PREFIX"))
	if not ns.HasGroupPlan(specID) then
		print(prefix .. ("Group tab, spec %s: no group list yet, so the tab is hidden."):format(tostring(specID)))
		return
	end
	local trace = {}
	ns.GetGroupPlan(specID, trace)
	print(prefix .. ("Group tab, spec %s:"):format(tostring(specID)))
	for _, t in ipairs(trace) do
		print(("  %s %s |cff9d9d9d[%s]|r %s"):format(
			t.shown and "|cff40ff40+|r" or "|cffff8080-|r", t.key, t.step or "-", t.why or ""))
	end
end
