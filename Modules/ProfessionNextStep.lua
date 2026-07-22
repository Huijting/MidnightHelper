local _, ns = ...

--[[
	Midnight Helper — "what is waiting on my professions?" (Spec 22).

	One provider, in the usual { text, color, onClick } shape, used by This Week and
	by the profession side panel so there is a single source of truth per fact.

	⚠️ WHAT THIS DELIBERATELY DOES NOT SAY — and why it is narrower than the spec.
	The design asked for a weekly Knowledge checklist. Measured on 2026-07-22
	(/mh kp), only part of that is knowable:

	  • Unspent Knowledge — READABLE (C_Traits.GetTreeCurrencyInfo). Points sitting
	    idle are the single most wasteful thing on a profession, so they lead.
	  • Trainer weekly — READABLE per profession, via verified quest ids in
	    PROF_ACADEMY.weekly.trainerQuests. Flagged = turned in, in log = picked up.
	  • "3 of 5 done this week" — NOT READABLE. No API exposes weekly KP progress.
	    Bag counts are not progress: hand in five essences, loot one more, and a
	    bag-based line would read 1/5 as if you had not started. That is why the
	    Professions hub no longer prints a fraction, and why nothing here does.

	So this file reports what is true and stays quiet about the rest. A profession
	whose Knowledge could not be read is omitted entirely rather than shown as
	"0 unspent", which would be a confident claim built on an empty return.
]]

local MAX_LINES = 6

--- Trainer-weekly state for one profession.
--- @return string|nil "done" / "picked" / "todo", nil when we have no verified id
---
--- Keyed on the BASE skill line (Tailoring 197), never the expansion line
--- (Midnight Tailoring 2918) — mixing those up made /mh kp report both of Rob's
--- professions as untracked while This Week listed them correctly.
local function TrainerWeeklyState(baseSkillLine)
	local weekly = ns.PROF_ACADEMY and ns.PROF_ACADEMY.weekly
	local quests = weekly and weekly.trainerQuests
	if not baseSkillLine or type(quests) ~= "table" then
		return nil
	end
	local ids = quests[baseSkillLine]
	if type(ids) == "number" then
		ids = { ids }
	end
	if type(ids) ~= "table" or #ids == 0 then
		return nil
	end
	if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return nil
	end
	-- Rotating variants: ANY flagged means this week is done.
	local picked = false
	for _, qid in ipairs(ids) do
		local okD, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, qid)
		if okD and done then
			return "done"
		end
		if C_QuestLog.IsOnQuest then
			local okO, on = pcall(C_QuestLog.IsOnQuest, qid)
			if okO and on then
				picked = true
			end
		end
	end
	return picked and "picked" or "todo"
end

--- Where a Knowledge line sends you: MH's own Professions tab.
---
--- It used to call C_TradeSkillUI.OpenTradeSkill first and only fall back if that
--- errored. Two things were wrong with that, and together they made the click look
--- dead (Rob, 2026-07-22):
---
---   1. pcall returns true the moment a call does not ERROR, including when it
---      quietly does nothing. Taking that as proof of success skipped the fallback.
---      Same mistake the death recap made with RegisterEvent, where a refused
---      registration raised no error and the code believed itself.
---   2. More basic: the side panel only exists WHILE the profession window is open,
---      so "open the profession window" was a no-op by definition. The player is
---      already looking at it.
---
---   3. And then SelectTab alone still looked dead, because SelectTab only PICKS a
---      tab -- it does not open anything. From This Week that is invisible (the
---      window is already up), but the side panel lives OUTSIDE the main window, so
---      the click was selecting a tab in a window nobody could see. NavSearch has
---      always done both (OpenTab: ShowMainUI then SelectTab); this now matches it.
---
--- Jumping Blizzard's window to its Specializations tab would be the ideal target,
--- but no installed addon references such a page by name (CraftingPage and
--- OrdersPage are confirmed via Auctionator; a spec page is not), so that stays
--- unguessed. Our own tab is the better destination anyway: it carries the advice
--- line that says WHICH node to put the points in, which a bare spec tree does not.
local function OpenProfession()
	if ns.ShowMainUI then
		pcall(ns.ShowMainUI, ns)
	end
	if ns.SelectTab then
		pcall(ns.SelectTab, "professions")
	end
end

--- Ordered next steps. Same shape as the other providers.
--- @return table { { text=, color=, onClick= }, ... }
function ns.GetProfessionNextSteps()
	local steps = {}
	if type(ns.GetProfessionKnowledgeStatus) ~= "function" then
		return steps
	end
	local ok, list = pcall(ns.GetProfessionKnowledgeStatus)
	if not ok or type(list) ~= "table" then
		return steps
	end

	-- 1. Unspent Knowledge first: it is the only thing here that is being wasted
	--    right now, and it is fixed in one click.
	for _, p in ipairs(list) do
		if p.readable and (p.unspent or 0) > 0 and #steps < MAX_LINES then
			steps[#steps + 1] = {
				text = (ns:L("PROFNEXT_UNSPENT_FMT")):format(p.baseName or p.name, p.unspent),
				color = "warn",
				onClick = OpenProfession,
			}
		end
	end

	-- 2. Trainer weekly per profession. A profession with no verified quest id is
	--    skipped rather than reported as "not done" — we would not know.
	for _, p in ipairs(list) do
		if #steps < MAX_LINES then
			local state = TrainerWeeklyState(p.baseSkillLine)
			local key, colour
			if state == "done" then
				key, colour = "PROFNEXT_WEEKLY_DONE_FMT", "good"
			elseif state == "picked" then
				key, colour = "PROFNEXT_WEEKLY_PICKED_FMT", "warn"
			elseif state == "todo" then
				key, colour = "PROFNEXT_WEEKLY_TODO_FMT", "prog"
			end
			if key then
				steps[#steps + 1] = {
					text = (ns:L(key)):format(p.baseName or p.name),
					color = colour,
					onClick = OpenProfession,
				}
			end
		end
	end

	return steps
end
