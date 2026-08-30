--[[
	Profession Academy — beginner course for the Midnight profession system.
	Toolbox sub-tab ("Professions 101"): numbered chapters with body text and a
	practice task per chapter. Progress is stored per character.

	Chapter structure/metadata: ProfessionAcademyData.lua (ns.PROF_ACADEMY).
	Text: locale packs (PROFACAD_*). Detection is deliberately conservative:
	only TRADE_SKILL_SHOW ("open your profession window") auto-completes a
	task; everything else is a manual checkbox — never a fake claim.
]]

local _, ns = ...

local SIDE_PAD = 12
local SCROLL_BOTTOM = 12

-- CHECK_SIZE, BTN_H, RAIL_W, RAIL_ROW_H and the four chapter colours lived here until
-- 24 aug. They dressed the chapters this panel used to render; the course is one surface
-- now and it is the window. Left behind they would read as "the panel still draws
-- chapters", which is exactly the sort of half-truth that sends the next reader looking
-- for code that is not there.

local function SL(key)
	if ns.SafeL then
		return ns:SafeL(key)
	end
	return ns:L(key)
end

--------------------------------------------------------------------------------
-- Per-character progress
--------------------------------------------------------------------------------

local function ProgressBag()
	if not ns.db then
		return nil
	end
	if type(ns.db.profAcademy) ~= "table" then
		ns.db.profAcademy = {}
	end
	local guid = UnitGUID("player")
	if type(guid) ~= "string" or guid == "" then
		return nil
	end
	if type(ns.db.profAcademy[guid]) ~= "table" then
		ns.db.profAcademy[guid] = {}
	end
	return ns.db.profAcademy[guid]
end

local function IsChapterDone(key)
	local bag = ProgressBag()
	return bag and bag[key] == true or false
end

local function SetChapterDone(key, done)
	local bag = ProgressBag()
	if bag then
		bag[key] = done and true or nil
	end
end

--------------------------------------------------------------------------------
-- Player professions + advice
--------------------------------------------------------------------------------

--- The two primary profession slots: { { name, skillLine }, ... } (0-2 entries).
local function GetPrimaryProfessions()
	local out = {}
	if type(GetProfessions) ~= "function" then
		return out
	end
	local p1, p2 = GetProfessions()
	for _, idx in next, { p1, p2 } do
		local name, _, _, _, _, _, skillLine = GetProfessionInfo(idx)
		if name then
			out[#out + 1] = { name = name, skillLine = skillLine }
		end
	end
	return out
end

local function HasSkillLine(profs, skillLineID)
	for _, p in ipairs(profs) do
		if p.skillLine == skillLineID then
			return true
		end
	end
	return false
end

--- Localized profession name; English fallback from data ("never lie" about IDs).
local function ProfName(skillLineID)
	local ok, info = pcall(function()
		return C_TradeSkillUI
			and C_TradeSkillUI.GetProfessionInfoBySkillLineID
			and C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillLineID)
	end)
	local name = ok and info and (info.professionName or info.parentProfessionName)
	if name and name ~= "" then
		return name
	end
	local d = ns.PROF_ACADEMY
	return (d and d.profNames and d.profNames[skillLineID]) or tostring(skillLineID)
end

--- Tree Advisor v1: first unfinished root along the curated route, or false
--- when the route is complete, or nil when no advice is possible (unknown
--- route, name mismatch, no tab data) — then nothing is shown.
--- NB: defined before BuildProfsText, which calls it (local scoping).
--- Goal keys, in the order they are shown. Fixed list rather than pairs(): the
--- two lines must not swap places between reloads.
local GOAL_ORDER = { "gold", "self" }

--- Does this route reach inside a tree anywhere, goal branches included?
--- Reading every node of every tree costs real work, and only Enchanting needs it
--- today; asking first keeps that off the other ten professions.
local function RouteWantsNodes(route)
	local function any(steps)
		if type(steps) ~= "table" then
			return false
		end
		for _, step in ipairs(steps) do
			if step.anyOfNodes or step.node then
				return true
			end
		end
		return false
	end
	if any(route) then
		return true
	end
	if type(route.goals) == "table" then
		for _, branch in pairs(route.goals) do
			if any(branch) then
				return true
			end
		end
	end
	return false
end

--- First unfinished step of a step list, plus that step's points hint.
--- Returns nil, nil when a name does not resolve (a rename or a localised tab
--- name), false when every step is satisfied.
---
--- @param nodesByName table|nil lowercased node name -> { name=, purchased=, max= }
---
--- A step names either TREES (`tree` / `anyOf`, looked up among the window's tabs)
--- or NODES inside a tree (`node` / `anyOfNodes`, looked up among the trait nodes).
--- The two are different layers and cannot share one lookup: Enchanting's second
--- step names two nodes, and as an `anyOf` it was searched among four tab names,
--- found nothing, and killed the advice for the entire profession.
---
--- 🔴 An unresolved step no longer aborts the route. It used to `return nil`, which
--- meant one bad name in step 2 silenced steps 3 and 4 as well — Rob had 235
--- Knowledge and a blank line where the advice belongs (30 Aug 2026). We genuinely
--- do not know whether an invisible step is done, so skipping it can advise slightly
--- out of order; total silence for the rest of a profession is the worse of the two,
--- and `/mh profadvice` names every step we could not resolve so it is never silent
--- to US. If nothing at all resolves, the result is still nil and nothing is shown.
local function FirstUnfinishedStep(steps, byName, classToken, nodesByName)
	local resolved = 0
	for _, step in ipairs(steps) do
		if not (step.skipIfClass and step.skipIfClass == classToken) then
			-- Node steps carry tooltip-form ranks (0/20); tab steps count the free
			-- base rank in both numbers. Wrapped to the tab convention here so the
			-- one comparison below, and the caller's `active - 1` display maths,
			-- stay true for both.
			local names, lookup = step.anyOf or { step.tree }, byName
			if step.anyOfNodes or step.node then
				names, lookup = step.anyOfNodes or { step.node }, nil
			end
			local display, satisfied = nil, false
			-- Every option we could resolve, in route order. An `anyOf` step means
			-- "pick one", and picking the first for the player is how the old code
			-- hid the choice this profession turns on: Enchanting's three sub-nodes
			-- serve Uncommon, Rare and Epic gear and are not interchangeable.
			local options = {}
			for _, n in ipairs(names) do
				local t
				if lookup then
					t = lookup[n:lower()]
				else
					local raw = nodesByName and nodesByName[n:lower()]
					if raw then
						t = { name = raw.name, isNode = true,
							active = (raw.purchased or 0) + 1, max = (raw.max or 0) + 1 }
					end
				end
				if t then
					options[#options + 1] = t
					display = display or t
					if step.points == 0 then
						-- "Open this branch, put nothing in it" (Mining's Over-LODED:
						-- unlocking it already grants the ability, and points beyond
						-- that are a bet on mote prices). Satisfied by the unlock
						-- itself — a root at rank 1 is unlocked but untouched, so
						-- waiting for max here would park the advice on it forever.
						if t.active >= 1 then
							satisfied = true
						end
					elseif t.max > 0 and t.active >= t.max then
						satisfied = true
					elseif t.active > 1 then
						-- Player already invests here: advise finishing this one.
						display = t
					end
				end
			end
			-- No `display` means the step is invisible to us: a rename, a localised
			-- name, or data that is simply wrong. Skipped rather than treated as
			-- satisfied, and named by `/mh profadvice` so it is not silent to us.
			if display then
				resolved = resolved + 1
				if not satisfied then
					-- More than one live option: hand the caller all of them rather
					-- than a winner. Copied, never mutated in place — `display` can
					-- be a table owned by the summary.
					if #options > 1 then
						local out = {}
						for k, v in pairs(display) do
							out[k] = v
						end
						out.options = options
						return out, step.points
					end
					return display, step.points
				end
			end
		end
	end
	-- Nothing resolved at all -> we have no picture of this route, so say nothing.
	-- That is the old behaviour, kept for the case it was actually right for.
	if resolved == 0 then
		return nil
	end
	return false
end

--- Third return value carries a goal split: { { goal, tab, points }, ... }.
--- Four professions (Tailoring, Leatherworking, Enchanting, Skinning) diverge so
--- far between "sell it" and "wear it" that one recommendation is a guess. The
--- old anyOf hid that choice behind a coin flip; showing both surfaces it. We do
--- NOT pick for the player and we do not store a preference — nobody ever told us
--- which they are playing for.
--- @param midnightLine number|nil the Midnight skill line, for node-level steps
local function GetAdviceForProf(skillLine, summary, midnightLine)
	local d = ns.PROF_ACADEMY
	local route = d and d.advisorRoutes and d.advisorRoutes[skillLine]
	if not (route and summary and summary.tabs and #summary.tabs > 0) then
		return nil
	end
	local classToken = select(2, UnitClass("player"))
	local byName = {}
	for _, t in ipairs(summary.tabs) do
		if t.name then
			byName[t.name:lower()] = t
		end
	end
	-- Only fetched when the route actually reaches inside a tree. Walking every
	-- node of every tree is not free, and most routes never need it.
	local nodesByName
	if midnightLine and ns.GetProfessionSpecNodes and RouteWantsNodes(route) then
		local okN, nodes = pcall(ns.GetProfessionSpecNodes, midnightLine)
		if okN and type(nodes) == "table" then
			nodesByName = {}
			for _, n in ipairs(nodes) do
				if n.name then
					nodesByName[n.name:lower()] = n
				end
			end
		end
	end
	local display, points = FirstUnfinishedStep(route, byName, classToken, nodesByName)
	if display == nil then
		return nil
	elseif display then
		return display, points
	end
	-- Shared steps done. Where the route splits by goal, the choice IS the advice.
	if type(route.goals) == "table" then
		local out = {}
		for _, goal in ipairs(GOAL_ORDER) do
			local branch = route.goals[goal]
			if type(branch) == "table" then
				local tab, pts = FirstUnfinishedStep(branch, byName, classToken, nodesByName)
				if tab then
					out[#out + 1] = { goal = goal, tab = tab, points = pts }
				end
			end
		end
		if #out > 0 then
			return nil, nil, out
		end
	end
	return false
end

--- First unfinished node along a curated NODE route, or nil.
---
--- Runs only when the tree-level route is complete -- that is exactly the moment
--- the old advice went vague ("push sub-nodes or spread into the remaining trees")
--- and Rob, with 30 Knowledge spare, had no idea where to put it (2026-07-22).
---
--- The route stores an English node name; the game reports a localised one. They
--- are matched, never assumed: no match means no advice, so a rename or a German
--- client loses the line instead of pointing at the wrong node.
local function GetNodeAdviceForProf(baseSkillLine, midnightLine)
	local d = ns.PROF_ACADEMY
	local route = d and d.advisorNodeRoutes and d.advisorNodeRoutes[baseSkillLine]
	if not (route and midnightLine and ns.GetProfessionSpecNodes) then
		return nil
	end
	local okN, nodes = pcall(ns.GetProfessionSpecNodes, midnightLine)
	if not okN or type(nodes) ~= "table" or #nodes == 0 then
		return nil
	end
	local byName = {}
	for _, n in ipairs(nodes) do
		if n.name then
			byName[n.name:lower()] = n
		end
	end
	-- `anyOfNodes` understood here too, so the two route tables take the same step
	-- shapes. A node route that only ever read `node` is how the same "written one
	-- way, read another" gap could open a second time.
	--
	-- And when a step offers several live options it hands back all of them, exactly
	-- as the tree route does. Returning the first one is what made this route name
	-- Thalassian silently on 30 Aug while Rob was asking which family to pick.
	for _, step in ipairs(route) do
		local opts, satisfied = {}, false
		for _, name in ipairs(step.anyOfNodes or { step.node }) do
			local n = name and byName[name:lower()]
			if n then
				if (n.purchased or 0) < (n.max or 0) then
					opts[#opts + 1] = n
				else
					-- `anyOf` means ONE of these, so a filled option ends the step.
					-- Without this the advice would keep offering the other two
					-- families forever after the player had finished one.
					satisfied = true
				end
			end
		end
		if satisfied then
			opts = {}
		end
		if #opts == 1 then
			return opts[1], "route"
		elseif #opts > 1 then
			local out = {}
			for k, v in pairs(opts[1]) do
				out[k] = v
			end
			out.options = opts
			return out, "route"
		end
	end
	-- Route exhausted (Rob finished Silvermoon's Spellpower and had 10 points
	-- left, 2026-07-22). We do NOT invent a next pick here. What we can honestly
	-- surface is where the player's own points already sit -- reported as an
	-- observation, not as a recommendation.
	--
	-- Rob challenged the first version of this, rightly: "is dat wel een eerlijk
	-- advies, want als ik eerst niet wist wat ik moest doen en maar wat heb
	-- gekozen?" Telling someone to finish what they started assumes the start was
	-- deliberate, and MH exists precisely because it often is not. His own node
	-- tooltips also weaken the sunk-cost case: every rank grants +1 Skill on its
	-- own, so a half-filled node is not wasted -- only the rank breakpoints
	-- ("Next major bonus at Rank 5") reward finishing.
	local best
	for _, n in ipairs(nodes) do
		local got, max = n.purchased or 0, n.max or 0
		if got > 0 and got < max and (not best or got > best.purchased) then
			best = n
		end
	end
	if best then
		return best, "finish"
	end
	return nil
end

--- Colored, localized advisor line for one profession, or nil when no advice.
--- Shows purchased ranks (API rank minus the free base rank), matching the
--- in-game node tooltip ("Rank 5/30").
--- @param withPointer boolean|nil append the "where the build order lives" pointer
---
--- The advice used to end in "the chapter below", which was wrong in BOTH places it
--- renders: on Overview there is no chapter below (the chapters live on the Course
--- sub-tab), and inside the trees chapter it IS the chapter. Rob clicked a Knowledge
--- line, landed on Overview and still could not tell where his 30 points should go
--- (2026-07-22). So the location left the sentence and became a pointer the caller
--- adds only where it is actually true.
local function BuildAdviceLine(skillLine, summary, withPointer, midnightLine)
	-- 🔴 BEFORE ANY ADVICE: can this player spend at all? Every branch below tells them
	-- where to put points, and on a profession whose specializations are still padlocked
	-- behind a skill requirement there is nowhere to put them. Rob hit exactly that on
	-- 23 aug -- 84 Knowledge on Tailoring, nothing started, and this line cheerfully
	-- naming a root -- and his first thought was that HE was doing something wrong.
	-- That is the cost of unactionable advice: the player doubts themselves, not us.
	--
	-- ⚠️ The same lock is asked via ns.MH_CanSpendKnowledge rather than re-derived here.
	-- This bug exists because the 21 aug fix landed in ProfessionNextStep only; a second
	-- copy of the test would set that up to happen again.
	-- nil means unreadable, and then the advice stands rather than a guess either way.
	if midnightLine and ns.MH_CanSpendKnowledge then
		local ok, canSpend = pcall(ns.MH_CanSpendKnowledge, midnightLine)
		if ok and canSpend == false then
			return "|cffaaaaaa" .. SL("PROFACAD_ADVISE_LOCKED") .. "|r"
		end
	end

	local advice, points, goals = GetAdviceForProf(skillLine, summary, midnightLine)
	local text
	if advice == false then
		-- Roots done: name the actual node when we have a verified one for this
		-- profession. Otherwise fall back to the general line.
		local node, why = GetNodeAdviceForProf(skillLine, midnightLine)
		if node and node.options then
			-- Several live options: name them all. Node ranks are already in tooltip
			-- form here (0/20), unlike the tree path, so they are not adjusted.
			local parts = {}
			for _, o in ipairs(node.options) do
				parts[#parts + 1] = SL("PROFACAD_CHOICE_FMT")
					:format(o.name, o.purchased or 0, o.max or 0)
			end
			text = SL("PROFACAD_ADVISE_PICK_ONE_FMT"):format(table.concat(parts, ", "))
			-- Pointer deliberately KEPT here. A choice is not an answer, and what
			-- separates these options lives in the chapter.
		elseif node then
			local key = (why == "finish") and "PROFACAD_ADVISE_NODE_FINISH_FMT" or "PROFACAD_ADVISE_NODE_FMT"
			text = SL(key):format(node.name, node.purchased or 0, node.max or 0)
			-- A route hit answers the question outright, so the pointer is noise. The
			-- fallback does NOT answer it -- it only reports where their points are --
			-- so there the chapter with the real options stays one click away.
			if why == "route" then
				withPointer = false
			end
		else
			text = SL("PROFACAD_ADVISE_DONE")
		end
	elseif advice then
		local spent, cap = math.max(advice.active - 1, 0), math.max(advice.max - 1, 0)
		if advice.options then
			-- The step offers a real choice, so the advice is the choice. Naming the
			-- first option as though it were the answer is what hid Enchanting's
			-- three disenchanting branches behind one of them; they serve Uncommon,
			-- Rare and Epic gear and only one matches what a given player breaks
			-- down. We do not know which, and have never asked.
			local parts = {}
			for _, o in ipairs(advice.options) do
				parts[#parts + 1] = SL("PROFACAD_CHOICE_FMT"):format(o.name,
					math.max((o.active or 0) - 1, 0), math.max((o.max or 0) - 1, 0))
			end
			text = SL("PROFACAD_ADVISE_PICK_ONE_FMT"):format(table.concat(parts, ", "))
		elseif points == 0 then
			-- Threshold of zero is not a typo: unlocking is the whole advice.
			text = SL("PROFACAD_ADVISE_NEXT_OPEN_FMT"):format(advice.name)
		elseif points then
			-- The number is the best-supported figure we found, and sources
			-- disagreed about it at every profession, sometimes by a factor of
			-- two. So it is offered as an aim with the client named as the
			-- authority, never as the truth.
			text = SL("PROFACAD_ADVISE_NEXT_POINTS_FMT"):format(advice.name, spent, cap, points)
		else
			text = SL("PROFACAD_ADVISE_NEXT_FMT"):format(advice.name, spent, cap)
		end
	elseif goals then
		local parts = {}
		for _, g in ipairs(goals) do
			parts[#parts + 1] = SL("PROFACAD_ADVISE_GOAL_LINE_FMT"):format(
				SL("PROFACAD_GOAL_" .. g.goal:upper()),
				g.tab.name,
				math.max(g.tab.active - 1, 0),
				math.max(g.tab.max - 1, 0))
		end
		text = SL("PROFACAD_ADVISE_GOALS_FMT"):format(table.concat(parts, " "))
	else
		return nil
	end
	if withPointer then
		text = text .. " " .. SL("PROFACAD_ADVISE_SEE_COURSE")
	end
	return "|cff8ee6a1" .. text .. "|r"
end

--- Header text: detected professions (+ tree state where readable), plus
--- class advice while a slot is open. summaries: [skillLine] = GetSpecSummary.
--- @param withPointer boolean|nil pass true ONLY from the Overview page
---
--- This same text renders in two places: the hub Overview and the header of the
--- Course page. The "open Course (101)" pointer therefore cannot live inside the
--- advice itself -- Rob was reading it while already sitting in the Course
--- (2026-07-22). Whoever renders the text knows where the reader is; this
--- function does not, so it takes the answer as an argument.
local function BuildProfsText(profs, summaries, withPointer)
	local d = ns.PROF_ACADEMY
	local text
	if #profs > 0 then
		local names = {}
		for _, p in ipairs(profs) do
			names[#names + 1] = p.name
		end
		text = SL("PROFACAD_PROFS_LINE_FMT"):format(table.concat(names, " & "))
		for _, p in ipairs(profs) do
			local s = summaries and summaries[p.skillLine]
			if s then
				local trees = (#s.started > 0) and table.concat(s.started, ", ")
					or SL("PROFACAD_SPEC_NONE_STARTED")
				text = text .. "\n" .. SL("PROFACAD_SPEC_LINE_FMT"):format(p.name, s.spent, s.unspent, trees)
				-- The caller decides; see the note on BuildProfsText.
				local line = BuildAdviceLine(p.skillLine, s, withPointer, s.midnightLine)
				if line then
					text = text .. "\n" .. line
				end
				-- Only while there is something to spend: with nothing in hand this list is
				-- trivia, and the page is long enough already.
				-- ⚠️ These are NODES, and the advice line above names a TREE. Stacked
				-- with an unqualified header they read as alternatives to the advice,
				-- which is how Rob's screen came to say "put points into Disenchanting
				-- Delegate" directly above four branches that did not include it
				-- (2026-08-20). Nothing was wrong; the two lists were different layers
				-- and nothing said so.
				--
				-- The header now names the layer and the count. It also stopped
				-- claiming these are "open": GetProfessionSpecNodes walks every tree
				-- and returns whatever is not full yet, without ever checking whether
				-- the player can buy it right now.
				-- 🔴 And not while the trees are locked. The comment above already admits
				-- this list never checks whether a node can be bought; with every
				-- specialization padlocked that is not a caveat but four nodes offered to
				-- someone who cannot buy any of them, directly under a line that just
				-- said so. Same lock, same single implementation.
				local locked = false
				if s.midnightLine and ns.MH_CanSpendKnowledge then
					local okL, canSpend = pcall(ns.MH_CanSpendKnowledge, s.midnightLine)
					locked = (okL and canSpend == false)
				end
				if not locked and (s.unspent or 0) > 0 and ns.GetProfessionNodeChoices then
					local okC, choices, total = pcall(ns.GetProfessionNodeChoices, s.midnightLine, 4)
					if okC and type(choices) == "table" and #choices > 0 then
						local header = SL("PROFACAD_CHOICES_HEADER")
						if total and total > #choices then
							header = SL("PROFACAD_CHOICES_HEADER_MORE_FMT"):format(#choices, total)
						end
						text = text .. "\n|cff8a8f98" .. header .. "|r"
						for _, c in ipairs(choices) do
							local desc = c.desc and (" - " .. c.desc) or ""
							text = text .. "\n   |cffd8c89a"
								.. (SL("PROFACAD_CHOICE_FMT")):format(c.name, c.purchased or 0, c.max or 0)
								.. "|r|cff8a8f98" .. desc .. "|r"
						end
					end
				end
			end
		end
	else
		text = SL("PROFACAD_PROFS_NONE")
	end
	if #profs < 2 and d then
		local classToken = select(2, UnitClass("player"))
		local adv = d.advice and classToken and d.advice[classToken]
		if adv and adv.profs then
			text = text .. "\n" .. SL("PROFACAD_ADVICE_PICK_FMT"):format(
				ProfName(adv.profs[1]), ProfName(adv.profs[2]), SL(adv.whyKey))
		end
		local alt = d.adviceAlt
		if alt then
			text = text .. "\n" .. SL("PROFACAD_ADVICE_ALT_FMT"):format(
				ProfName(alt[1]), ProfName(alt[2]))
		end
	end
	return text
end

--- Spec-tree summary for an owned profession, or nil when unreadable (unknown
--- spec skillLine, API missing, or trait data not loaded yet) — never guess.
--- Returns { spent, unspent, started = { treeName, ... } }.
local function GetSpecSummary(baseSkillLine)
	local d = ns.PROF_ACADEMY
	local child = d and d.specSkillLines and d.specSkillLines[baseSkillLine]
	if not child or not (C_ProfSpecs and C_ProfSpecs.GetConfigIDForSkillLine and C_Traits) then
		return nil
	end
	local ok, cfg = pcall(C_ProfSpecs.GetConfigIDForSkillLine, child)
	if not ok or type(cfg) ~= "number" or cfg == 0 then
		return nil
	end
	local okTabs, tabs = pcall(C_ProfSpecs.GetSpecTabIDsForSkillLine, child)
	if not okTabs or type(tabs) ~= "table" or #tabs == 0 then
		return nil
	end
	local spent, unspent
	local started = {}
	local tabsOut = {}
	for _, tabID in ipairs(tabs) do
		if spent == nil and C_Traits.GetTreeCurrencyInfo then
			-- KP pool is profession-wide; identical for every tab (verified live).
			local okCur, cur = pcall(C_Traits.GetTreeCurrencyInfo, cfg, tabID, false)
			if okCur and type(cur) == "table" and cur[1] then
				spent = tonumber(cur[1].spent)
				unspent = tonumber(cur[1].quantity)
			end
		end
		if C_ProfSpecs.GetRootPathForTab and C_Traits.GetNodeInfo then
			local okRoot, rootPath = pcall(C_ProfSpecs.GetRootPathForTab, tabID)
			if okRoot and rootPath then
				local okNode, node = pcall(C_Traits.GetNodeInfo, cfg, rootPath)
				if okNode and type(node) == "table" then
					local okInfo, info = pcall(C_ProfSpecs.GetTabInfo, tabID)
					local tabName = (okInfo and type(info) == "table" and info.name) or tostring(tabID)
					local active = tonumber(node.activeRank) or 0
					tabsOut[#tabsOut + 1] = {
						name = tabName,
						active = active,
						max = tonumber(node.maxRanks) or 0,
					}
					-- Root activeRank 1 = unlocked but untouched; > 1 = points spent.
					if active > 1 then
						started[#started + 1] = tabName
					end
				end
			end
		end
	end
	if spent == nil then
		return nil
	end
	-- midnightLine travels with the summary so the node advisor does not have to
	-- look the expansion skill line up a second time (and get it wrong).
	return { spent = spent, unspent = unspent or 0, started = started, tabs = tabsOut,
		midnightLine = child }
end

--- True when every owned primary profession has a tool equipped (profession
--- gear inventory slots: 20 = profession 1 tool, 23 = profession 2 tool).
--- Wrong/empty slots simply never auto-complete — the checkbox stays manual.
local function AllProfToolsEquipped()
	if type(GetProfessions) ~= "function" or type(GetInventoryItemID) ~= "function" then
		return false
	end
	local p1, p2 = GetProfessions()
	if not p1 and not p2 then
		return false
	end
	if p1 and not GetInventoryItemID("player", 20) then
		return false
	end
	if p2 and not GetInventoryItemID("player", 23) then
		return false
	end
	return true
end

--- A chapter is shown when it is generic or matches an owned profession.
local function IsChapterVisible(ch, profs)
	if not ch.skillLineID then
		return true
	end
	return HasSkillLine(profs, ch.skillLineID)
end

--------------------------------------------------------------------------------
-- Panel
--------------------------------------------------------------------------------

local builtPanel

local function CountProgress(profs)
	local d = ns.PROF_ACADEMY
	if not d then
		return 0, 0
	end
	local done, total = 0, 0
	for _, ch in ipairs(d.chapters) do
		if IsChapterVisible(ch, profs) then
			total = total + 1
			if IsChapterDone(ch.key) then
				done = done + 1
			end
		end
	end
	return done, total
end

--- Route to a chapter's waypoint, looked up by name in ns.PROF_ACADEMY.
--- Used to be hardcoded to the Work Order station, so a second destination was
--- impossible without a second function. Unknown name = no button, never a
--- waypoint to a guessed spot.
local function RouteChapterWaypoint(key)
	local d = ns.PROF_ACADEMY
	local wp = d and key and d[key]
	if not (wp and wp.mapID and ns.AddSmartTomTomWay) then
		return false
	end
	ns.MH_TomTomClearAll()
	return ns.AddSmartTomTomWay(wp.mapID, wp.x, wp.y, SL(wp.wpKey or "PROFACAD_WAYPOINT_WORKORDER")) and true or false
end

-- Re-stack all chapter widgets top-to-bottom (heights depend on word wrap).
--- Compose a chapter's full text: intro, body, the advanced paragraph, live tree
--- advice, the levelling route and the dated half, in that order.
---
--- Extracted 21 Aug 2026 so the pop-out course window renders exactly what the
--- panel renders. Two copies of this would drift, and text drifting away from the
--- thing beside it is the fault this course spent two days repairing.
local function ComposeChapterBody(ch, treesAdvice)
	local body = SL(ch.bodyKey)
	-- Instap-alinea vóór de body (PROFACAD_CH_*_INTRO). Zelfde vertaal-
	-- fallback als levelingKey hieronder: staat de key er in deze taal
	-- niet, dan valt 'ie weg en rendert het hoofdstuk als voorheen.
	if ch.introKey then
		local intro = SL(ch.introKey)
		if intro and intro ~= "" and intro ~= ch.introKey then
			body = intro:gsub("|n", "\n") .. "\n\n" .. body
		end
	end
	-- "You are past the starter build" paragraph, after the body and before
	-- the levelling route. Same optional-key pattern as introKey: a chapter
	-- without it renders exactly as before, and a language that has not
	-- translated it yet simply does not show it.
	--
	-- Rob hit the gap this answers: his three recommended Enchanting roots
	-- were done, he had 30 Knowledge spare, and every line in the addon was
	-- written for someone still building UP to that point (2026-07-22).
	if ch.advancedKey then
		local adv = SL(ch.advancedKey)
		if adv and adv ~= "" and adv ~= ch.advancedKey then
			body = body .. "\n\n" .. adv:gsub("|n", "\n")
		end
	end
	-- A reference block for a profession whose branches are a genuine choice rather
	-- than an order. Same optional-key shape as introKey/advancedKey above: a chapter
	-- without it renders exactly as before.
	--
	-- Enchanting has one because its three families are equally strong and differ only
	-- in which stats they let you sell -- and because the addon spent months naming one
	-- of them without ever saying the other two existed.
	if ch.familiesKey then
		local fam = SL(ch.familiesKey)
		if fam and fam ~= "" and fam ~= ch.familiesKey then
			body = body .. "\n\n" .. fam:gsub("|n", "\n")
		end
	end
	if ch.key == "trees" and treesAdvice ~= "" then
		body = body .. "\n" .. treesAdvice
	end
	-- Optioneel skill-leveling-routje onder een professie-hoofdstuk
	-- (PROFGUIDE_LVL_*). De route gebruikt |n-markup; hier omgezet naar
	-- echte newlines zodat 'ie als de andere body-tekst rendert.
	if ch.levelingKey then
		local lvl = SL(ch.levelingKey)
		if lvl and lvl ~= "" and lvl ~= ch.levelingKey then
			local lvlText = lvl:gsub("|n", "\n")
			body = body .. "\n\n" .. lvlText
		end
	end
	-- Perishable half, last and separately keyed. Some advice is durable (how
	-- a market works) and some expires within weeks (what sells right now),
	-- and every guide we read mixes the two — so the whole thing reads as
	-- stale the moment the specific part does.
	--
	-- The key carries its own measurement date (…_DATED_YYYYMM), so a
	-- re-measurement replaces ONE string instead of hunting through seven
	-- language packs for the sentences that went off.
	if ch.datedKey then
		local dated = SL(ch.datedKey)
		if dated and dated ~= "" and dated ~= ch.datedKey then
			body = body .. "\n\n" .. dated:gsub("|n", "\n")
		end
	end
	return body
end

local function Relayout(panel)
	local child = panel._profAcadChild
	local width = child and child:GetWidth()
	if not width or width <= 0 then
		return
	end
	local y = 4
	-- The chapter-position map and the task-row height branch went with the chapters
	-- (24 aug): nothing pushed here carries a chapter key or a wrapping task label any
	-- more, so both were bookkeeping for readers that no longer exist.
	for _, el in ipairs(panel._profAcadOrder) do
		local w = el.w
		if w:IsShown() then
			y = y + (el.gapTop or 0)
			w:ClearAllPoints()
			w:SetPoint("TOPLEFT", child, "TOPLEFT", el.indent or 0, -y)
			w:SetWidth(math.max(width - (el.indent or 0), 1))
			if el.fixedH then
				y = y + math.max(w:GetHeight() or 0, tonumber(el.fixedH) or 1)
			else
				y = y + math.max(w:GetStringHeight() or 0, 1)
			end
		end
	end
	child:SetHeight(math.max(y + 10, 1))
end

--- Public: the Overview dashboard text for the Professions Hub — detected
--- professions, KP totals, started trees and live tree advice.
function ns.MH_GetProfessionsOverviewText()
	local profs = GetPrimaryProfessions()
	local summaries = {}
	for _, p in ipairs(profs) do
		summaries[p.skillLine] = GetSpecSummary(p.skillLine)
	end
	-- Overview: the chapters are one tab away, so say so.
	return BuildProfsText(profs, summaries, true)
end

function ns.MH_RefreshProfessionAcademyPanel(panel)
	panel = panel or builtPanel
	if not panel or not panel._profAcadBuilt then
		return
	end

	if panel._header and panel._header.SetText then
		panel._header:SetText(SL("TAB_PROF_ACADEMY"))
	end
	panel._subtitle:SetText(SL("PROFACAD_SUBTITLE"))
	if panel._guideBtn then
		panel._guideBtn:SetText(SL("PGUIDE_LAUNCH_BTN"))
	end

	local profs = GetPrimaryProfessions()

	-- Tree state per owned profession (nil when unreadable). Spending KP also
	-- auto-completes the "trees" chapter — the choice has clearly been made.
	local summaries = {}
	local anySpent = false
	for _, p in ipairs(profs) do
		local s = GetSpecSummary(p.skillLine)
		if s then
			summaries[p.skillLine] = s
			if s.spent > 0 then
				anySpent = true
			end
		end
	end
	local toolsOk = AllProfToolsEquipped()
	for _, ch in ipairs(ns.PROF_ACADEMY.chapters) do
		if not IsChapterDone(ch.key) then
			if (ch.detect == "kpspent" and anySpent) or (ch.detect == "proftool" and toolsOk) then
				SetChapterDone(ch.key, true)
			end
		end
	end

	local done, total = CountProgress(profs)
	panel._progressFs:SetText(SL("PROFACAD_PROGRESS_FMT"):format(done, total))

	if panel._profsFs then
		-- Course page: the reader is already here, so no pointer to here.
		panel._profsFs:SetText(BuildProfsText(profs, summaries, false))
	end

	-- The "choosing trees" chapter repeats the live advice right where the
	-- decision is made (Rob: the header block is out of view by then).
	local treesAdvice = ""
	for _, p in ipairs(profs) do
		local s = summaries[p.skillLine]
		local line = s and BuildAdviceLine(p.skillLine, s, false, s.midnightLine)
		if line then
			treesAdvice = treesAdvice .. "\n" .. ("|cffffd966%s:|r "):format(p.name) .. line
		end
	end

	-- The live tree advice is built from the player's own trees here; the pop-out
	-- window has no profession data of its own, so it reads what this pass produced.
	-- Never opened the panel? Then it is nil and the trees chapter simply renders
	-- without the live line, which is what it did before that line existed.
	ns._mhTreesAdvice = treesAdvice

	Relayout(panel)
end

function ns.BuildProfessionAcademyPanel(panel)
	if not panel or panel._profAcadBuilt then
		return
	end
	if not (ns.PROF_ACADEMY and ns.PROF_ACADEMY.chapters) then
		return
	end
	panel._profAcadBuilt = true
	builtPanel = panel
	-- The pop-out course window pushes a refresh back here when you pick a chapter
	-- there, so the two surfaces never show different chapters at once.
	ns._mhProfAcadPanelRef = panel

	if panel._body then
		panel._body:Hide()
	end

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	subtitle:SetPoint("TOPLEFT", panel._header, "BOTTOMLEFT", 0, -6)
	subtitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -SIDE_PAD, -6)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.78, 0.76, 0.7)
	panel._subtitle = subtitle

	-- Guided-mode launcher (prototype: Alchemy) — opens the one-step-at-a-time wizard.
	local guideBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	guideBtn:SetSize(170, 22)
	guideBtn:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -SIDE_PAD, -2)
	guideBtn:SetText(SL("PGUIDE_LAUNCH_BTN"))
	guideBtn:SetScript("OnClick", function()
		if ns.MH_OpenProfessionGuide then
			ns.MH_OpenProfessionGuide()
		end
	end)

	--- Contents rail toggle. OFF by default, and that is deliberate: the long scroll
	--- is what everyone has had until now, so nobody should find their course
	--- rearranged without asking. Rob's words: "hij moet natuurlijk alleen verschijnen
	--- als we er om vragen".
	---
	--- Why it exists: the course grew to 14 chapters and ~355 rendered lines on
	--- 20 Aug, which is roughly thirteen screens. Reaching a chapter meant scrolling
	--- past every chapter before it, so better content had made the course less
	--- usable. The fix is navigation, not more room — a second window the same size
	--- would hold the same 355 lines.
	--- 🔴 "Full course" used to be THIS button's on-state label, and it lied by being
	--- reasonable. Rob read it as "open the whole course" -- which is exactly what the
	--- pop-out window does -- clicked it, and got the same cramped panel with the contents
	--- rail switched off (23 aug). He said he had expected the window instead.
	---
	--- The window was built for precisely his complaint, and until now nothing on this page
	--- opened it: it lived behind /mh course and the Pop-out windows card, neither of which
	--- you are looking at while you are reading a chapter. Same lesson as the starter builds
	--- nobody could find -- if the person who commissioned it does not find it, no beginner
	--- will. So the label that misled him now does the thing he expected, and the toggle
	--- below says what it actually toggles.
	local windowBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	windowBtn:SetSize(130, 22)
	windowBtn:SetPoint("TOPRIGHT", guideBtn, "TOPLEFT", -6, 0)
	windowBtn:SetText(SL("PROFACAD_BTN_FULL_COURSE"))
	windowBtn:SetScript("OnClick", function()
		if ns.ToggleProfessionCourseWindow then
			ns.ToggleProfessionCourseWindow()
		end
	end)

	-- The contents-rail toggle lived here for one day. It belonged to a course that
	-- rendered in this panel; the rail now lives in the window, where it is always on and
	-- has full height to be on in. A button that toggles something on another surface is
	-- worse than no button.
	panel._guideBtn = guideBtn

	local progressFs = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	progressFs:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	progressFs:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -6)
	progressFs:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -SIDE_PAD, -6)
	progressFs:SetJustifyH("LEFT")
	progressFs:SetTextColor(0.55, 0.78, 1)
	panel._progressFs = progressFs

	-- Detected professions + class advice (multi-line; height drives the scroll
	-- anchor below).
	local profsFs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	profsFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	profsFs:SetPoint("TOPLEFT", progressFs, "BOTTOMLEFT", 0, -6)
	profsFs:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -SIDE_PAD, -6)
	profsFs:SetJustifyH("LEFT")
	profsFs:SetWordWrap(true)
	profsFs:SetSpacing(2)
	profsFs:SetTextColor(0.82, 0.88, 0.78)
	panel._profsFs = profsFs

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperProfAcademyScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", profsFs, "BOTTOMLEFT", 0, -8)
	scroll:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", SIDE_PAD, SCROLL_BOTTOM)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, SCROLL_BOTTOM)

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)
	panel._profAcadChild = child
	panel._profAcadOrder = {}

	local function push(w, gapTop, indent, fixedH, taskFs)
		panel._profAcadOrder[#panel._profAcadOrder + 1] = { w = w, gapTop = gapTop, indent = indent, fixedH = fixedH, taskFs = taskFs }
	end

	scroll:SetScript("OnSizeChanged", function(_, w)
		if w and w > 0 then
			child:SetWidth(w)
			if panel:IsShown() then
				ns.MH_RefreshProfessionAcademyPanel(panel)
			end
		end
	end)
	local w0 = scroll:GetWidth()
	if w0 and w0 > 0 then
		child:SetWidth(w0)
	end

	panel:SetScript("OnShow", function(self)
		ns.MH_RefreshProfessionAcademyPanel(self)
	end)

	ns.MH_RefreshProfessionAcademyPanel(panel)
end

--- `/mh lock` — why can a specialization not be picked yet, and can we read that?
---
--- The defect this exists for: Rob holds 12 unspent Knowledge Points on Tailoring and
--- cannot spend one of them — his skill is under 25 and all four specializations are
--- padlocked ("Requires level 25 in Midnight Tailoring to unlock a specialization").
--- Meanwhile our own This Week line says "12 Knowledge unspent - spend it". Advice you
--- cannot act on is worse than none: the player doubts themselves instead of us.
---
--- We cannot currently tell locked from unlocked-but-untouched, because `active - 1`
--- collapses both to 0. Rather than guess an API name for it, ASK THE CLIENT WHAT EXISTS:
--- enumerate C_ProfSpecs, then dump every scalar field of the tab info and the root node.
--- A guessed name would either work by luck or fail silently; an enumeration cannot lie.
function ns.ProbeSpecLockState()
	local out = {}
	local function say(s)
		print("|cff66ccff[MH lock]|r " .. s)
		out[#out + 1] = s
	end
	if not (C_ProfSpecs and C_Traits and C_TradeSkillUI) then
		say("profession APIs unavailable")
		return
	end

	-- 1. What does this client actually offer? No name guessing.
	local names = {}
	for k, v in pairs(C_ProfSpecs) do
		if type(v) == "function" then
			names[#names + 1] = k
		end
	end
	table.sort(names)
	say("C_ProfSpecs functions (" .. #names .. "): " .. table.concat(names, ", "))

	-- 2. Everything readable about each tab and its root, scalars only.
	local function dump(prefix, tbl)
		if type(tbl) ~= "table" then
			say(prefix .. " = " .. tostring(tbl))
			return
		end
		local keys = {}
		for k in pairs(tbl) do
			keys[#keys + 1] = tostring(k)
		end
		table.sort(keys)
		for _, k in ipairs(keys) do
			local v = tbl[k] ~= nil and tbl[k] or tbl[tonumber(k)]
			local t = type(v)
			if t == "table" then
				say(("%s.%s = <table, %d entries>"):format(prefix, k, #v))
			elseif t ~= "function" then
				say(("%s.%s = %s"):format(prefix, k, tostring(v)))
			end
		end
	end

	local lines = C_TradeSkillUI.GetAllProfessionTradeSkillLines
		and C_TradeSkillUI.GetAllProfessionTradeSkillLines() or {}
	for _, skillLine in ipairs(lines) do
		local okCfg, cfg = pcall(C_ProfSpecs.GetConfigIDForSkillLine, skillLine)
		local okTabs, tabs = pcall(C_ProfSpecs.GetSpecTabIDsForSkillLine, skillLine)
		if okCfg and cfg and cfg ~= 0 and okTabs and type(tabs) == "table" and tabs[1] then
			local okI, info = pcall(C_TradeSkillUI.GetProfessionInfoBySkillLineID, skillLine)
			local pname = (okI and type(info) == "table" and info.professionName) or tostring(skillLine)
			say(("=== %s (skillLine %d, cfg %s) — skillLevel=%s maxSkill=%s"):format(
				pname, skillLine, tostring(cfg),
				tostring(okI and info and info.skillLevel),
				tostring(okI and info and info.maxSkillLevel)))
			-- Round 2. The enumeration named these; round 1 proved the NODE cannot answer
			-- the question (canPurchaseRank, isAvailable and meetsEdgeRequirements were
			-- all true on a padlocked tab), so the gate lives at tab level.
			-- ShouldShowPointsReminderForSkillLine is the interesting one: it is
			-- Blizzard's own answer to "should I nag this player about unspent points",
			-- which is exactly the sentence we are getting wrong.
			for _, fn in ipairs({
				"ShouldShowPointsReminderForSkillLine",
				"SkillLineHasSpecialization",
				"GetCurrencyInfoForSkillLine",
				"GetDefaultSpecSkillLine",
			}) do
				if C_ProfSpecs[fn] then
					local ok, a, b, c = pcall(C_ProfSpecs[fn], skillLine)
					say(("  %s(%d) -> %s | %s | %s"):format(
						fn, skillLine, tostring(a), tostring(b), tostring(c)))
					if ok and type(a) == "table" then
						dump("    " .. fn, a)
					end
				end
			end
			for _, tabID in ipairs(tabs) do
				local okT, tinfo = pcall(C_ProfSpecs.GetTabInfo, tabID)
				say(("--- tab %s"):format(tostring(tabID)))
				-- Argument order is not documented anywhere we trust, so try both
				-- shapes and report which one answered rather than assuming.
				for _, fn in ipairs({ "CanUnlockTab", "GetStateForTab", "ShouldShowSpecTab" }) do
					if C_ProfSpecs[fn] then
						local ok1, r1 = pcall(C_ProfSpecs[fn], tabID)
						local ok2, r2 = pcall(C_ProfSpecs[fn], tabID, cfg)
						say(("  %s: (tabID)=%s%s  (tabID,cfg)=%s%s"):format(
							fn,
							tostring(r1), ok1 and "" or " [err]",
							tostring(r2), ok2 and "" or " [err]"))
					end
				end
				if okT then
					dump("  tabInfo", tinfo)
				else
					say("  GetTabInfo failed: " .. tostring(tinfo))
				end
				local okR, rootPath = pcall(C_ProfSpecs.GetRootPathForTab, tabID)
				if okR and rootPath then
					local okN, node = pcall(C_Traits.GetNodeInfo, cfg, rootPath)
					if okN then
						dump("  rootNode", node)
					else
						say("  GetNodeInfo failed: " .. tostring(node))
					end
				end
			end
		end
	end

	ns.db = ns.db or {}
	ns.db.lockProbe = out
	print("|cff66ccff[MH lock]|r written to MidnightHelperDB.lockProbe — /reload to flush it.")
end

--- `/mh kp` — dump every currency row of every profession tree, unfiltered.
---
--- GetSpecSummary above reads `cur[1]` and calls its quantity "unspent", and the
--- Professions overview already prints that number. But a profession tree carries
--- more than one currency: Blizzard's own gamedata separates knowledge points from
--- a free unlock token, and three earlier attempts in this project confused the two.
--- If `cur[1]` is the token rather than the points, we have been showing the wrong
--- number for months, and a Home-screen nudge built on it would be wrong louder.
---
--- So: print everything with an index, and write it to SavedVariables as well, since
--- a screenshot of a long list is exactly what we agreed to stop doing. No filter by
--- name or id — a filter can only find the currency we already believe in.
function ns.ProbeKnowledgeCurrency()
	local out = {}
	local function say(s)
		print("|cff66ccff[MH kp]|r " .. s)
		out[#out + 1] = s
	end
	if not (C_ProfSpecs and C_Traits and C_TradeSkillUI) then
		say("profession APIs unavailable")
		return
	end
	local lines = C_TradeSkillUI.GetAllProfessionTradeSkillLines
		and C_TradeSkillUI.GetAllProfessionTradeSkillLines() or {}
	for _, skillLine in ipairs(lines) do
		local okCfg, cfg = pcall(C_ProfSpecs.GetConfigIDForSkillLine, skillLine)
		local okTabs, tabs = pcall(C_ProfSpecs.GetSpecTabIDsForSkillLine, skillLine)
		if okCfg and cfg and okTabs and type(tabs) == "table" and tabs[1] then
			local okInfo, info = pcall(C_TradeSkillUI.GetProfessionInfoBySkillLineID, skillLine)
			local name = (okInfo and type(info) == "table" and info.professionName) or tostring(skillLine)
			say(("--- %s (skillLine %d, cfg %s, %d tabs)"):format(name, skillLine, tostring(cfg), #tabs))
			local okCur, cur = pcall(C_Traits.GetTreeCurrencyInfo, cfg, tabs[1], false)
			if okCur and type(cur) == "table" then
				for i, c in ipairs(cur) do
					say(("  [%d] traitCurrencyID=%s quantity=%s spent=%s maxQuantity=%s"):format(
						i, tostring(c.traitCurrencyID), tostring(c.quantity),
						tostring(c.spent), tostring(c.maxQuantity)))
					-- Round 2: what IS each of these? Row 1 looks like the knowledge pool
					-- (uncapped, large spend) and the rest look like capped unlock tokens,
					-- but that is inferred from shape. Ask the client to name them instead.
					-- Every field is dumped rather than the ones we expect: picking fields
					-- can only ever confirm the structure we already imagine.
					if C_Traits.GetTraitCurrencyInfo and c.traitCurrencyID then
						local okI, a, b, d, e = pcall(C_Traits.GetTraitCurrencyInfo, c.traitCurrencyID)
						if okI then
							say(("       info: %s | %s | %s | %s"):format(
								tostring(a), tostring(b), tostring(d), tostring(e)))
						else
							say("       GetTraitCurrencyInfo failed: " .. tostring(a))
						end
					else
						say("       (no C_Traits.GetTraitCurrencyInfo on this client)")
					end
				end
				if #cur == 0 then
					say("  (no currency rows returned — that is itself the answer)")
				end
			else
				say("  GetTreeCurrencyInfo failed: " .. tostring(cur))
			end
		end
	end
	if #out == 0 then
		say("no professions with spec tabs found")
	end
	ns.db = ns.db or {}
	ns.db.kpProbe = out
	print("|cff66ccff[MH kp]|r written to MidnightHelperDB.kpProbe — /reload to flush it to disk.")
end

--- Public: the course as the pop-out window needs it — the chapters this character
--- actually sees, in order, with their tick state.
---
--- Filtered by IsChapterVisible for the same reason the panel filters: a Tailoring
--- chapter in a Skinner's course is noise, and the numbering has to match what the
--- panel shows or the two surfaces disagree about which chapter is "7".
function ns.MH_GetCourseChapters()
	local out = {}
	if not (ns.PROF_ACADEMY and ns.PROF_ACADEMY.chapters) then
		return out
	end
	local profs = GetPrimaryProfessions()
	for _, ch in ipairs(ns.PROF_ACADEMY.chapters) do
		if IsChapterVisible(ch, profs) then
			out[#out + 1] = {
				key = ch.key,
				title = SL(ch.titleKey),
				done = IsChapterDone(ch.key) and true or false,
				-- The window owns the tick and the task since 24 aug (see the note on
				-- ns.MH_SetChapterDone), so it needs the waypoint key too.
				-- `detect` (not `autoTask` -- I wrote that from memory and grep caught it)
				-- is what marks a chapter the addon ticks off by itself.
				taskWaypoint = ch.taskWaypoint,
				detected = ch.detect and true or false,
			}
		end
	end
	return out
end

--- Public: tick a chapter off, and route its task waypoint.
---
--- ⚠️ EXPORTED 24 AUG BECAUSE THE WINDOW IS NOW THE ONLY COURSE SURFACE. The panel used to
--- render every chapter underneath the overview, and Rob's verdict on that was blunt: "dat
--- onderste gedeelte moet weg -- het past fysiek niet en het is lelijk opgemaakt". Removing
--- it takes the checkbox, the task line and the waypoint button with it, because those only
--- ever existed there. So they move rather than disappear: same two functions, one
--- implementation, called from the window.
---
--- The header of ProfessionCourseWindow used to say "it renders, it does not own" and that
--- the tick "stays in the panel on purpose". That was true when there were two surfaces.
--- There is one now, and that note has been corrected rather than left to mislead.
function ns.MH_SetChapterDone(key, done)
	if key then
		SetChapterDone(key, done and true or false)
	end
end

function ns.MH_RouteChapterWaypoint(key)
	return RouteChapterWaypoint(key)
end

--- Public: the label for a chapter's waypoint button, or nil when it has none.
function ns.MH_GetChapterWaypointLabel(wpKey)
	local wp = wpKey and ns.PROF_ACADEMY and ns.PROF_ACADEMY[wpKey]
	if not wp then
		return nil
	end
	return SL(wp.btnKey or "PROFACAD_BTN_WORKORDER")
end

--- Public: one chapter's title and composed text, for the pop-out window.
--- Same composer the panel uses, so the two can never say different things.
function ns.MH_GetChapterText(chKey)
	if not (chKey and ns.PROF_ACADEMY and ns.PROF_ACADEMY.chapters) then
		return nil
	end
	for _, ch in ipairs(ns.PROF_ACADEMY.chapters) do
		if ch.key == chKey then
			local task = SL(ch.taskKey)
			-- Same "(ticks itself when detected)" the panel appended, so a chapter the
			-- addon watches does not look like one you forgot to tick.
			if ch.detect then
				task = task .. "  |cff8a8f98" .. SL("PROFACAD_TASK_AUTO_HINT") .. "|r"
			end
			return SL(ch.titleKey), ComposeChapterBody(ch, ns._mhTreesAdvice), task
		end
	end
	return nil
end

--- Public: scroll the course to one chapter, used by the search.
---
--- Landing on the tab is not the same as finding the answer. A search hit for
--- "concentration" that only opens the Professions tab has technically worked and
--- practically failed — the reader still has to hunt.
---
--- It used to scroll the panel to a remembered Y offset. The panel no longer renders
--- chapters, so "jump to a chapter" now means: select it and open the course window.
--- The NAME is unchanged on purpose — NavSearch calls it, and renaming a function
--- because its insides moved is churn that breaks a caller for no gain.
---
--- Deferred by a frame because the window may only just have been created: its rows
--- have no width until the layout runs, and Refresh reads widths.
function ns.MH_ScrollProfAcademyToChapter(key)
	if not key then
		return
	end
	ns.db = ns.db or {}
	ns.db.profAcadChapter = key
	local function jump()
		-- Toggle would CLOSE an already-open window, which is the opposite of what a
		-- search result should do. Open it only when it is not already showing.
		local f = _G["MidnightHelperCourseWindow"]
		if not (f and f:IsShown()) and ns.ToggleProfessionCourseWindow then
			ns.ToggleProfessionCourseWindow()
		elseif ns.RefreshProfessionCourseWindow then
			ns.RefreshProfessionCourseWindow()
		end
		if builtPanel and builtPanel._profAcadBuilt then
			ns.MH_RefreshProfessionAcademyPanel(builtPanel)
		end
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0, jump)
	else
		jump()
	end
end

--------------------------------------------------------------------------------
-- Locale refresh + detection
--------------------------------------------------------------------------------

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if builtPanel and builtPanel._profAcadBuilt then
			ns.MH_RefreshProfessionAcademyPanel(builtPanel)
		end
	end
end

-- Conservative auto-detection: opening any profession window completes the
-- "profui" task (chapter 1). Everything else stays manual. SKILL_LINES_CHANGED
-- re-runs detection/filtering when the player learns or drops a profession.
local ev = CreateFrame("Frame")
ev:RegisterEvent("TRADE_SKILL_SHOW")
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:RegisterEvent("TRAIT_CONFIG_UPDATED")
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
ev:SetScript("OnEvent", function(_, event)
	local d = ns.PROF_ACADEMY
	if not d then
		return
	end
	local changed = false
	if event == "TRADE_SKILL_SHOW" then
		for _, ch in ipairs(d.chapters) do
			if ch.detect == "profui" and not IsChapterDone(ch.key) then
				SetChapterDone(ch.key, true)
			end
		end
		-- Always refresh: opening a profession window can make spec-tree data
		-- readable for the first time (config was 0 before).
		changed = true
	elseif event == "SKILL_LINES_CHANGED" or event == "TRAIT_CONFIG_UPDATED"
		or event == "PLAYER_EQUIPMENT_CHANGED" then
		-- Profession learned/dropped, KP spent, or (profession) gear swapped —
		-- refresh detection and auto-completion.
		changed = true
	end
	if changed and builtPanel and builtPanel:IsShown() then
		ns.MH_RefreshProfessionAcademyPanel(builtPanel)
	end
end)

--- `/mh profadvice` — why the advisor said what it said, or nothing at all.
---
--- The advisor's normal failure is SILENCE: no line renders and the panel looks
--- merely sparse. That is exactly how Rob spent a session stuck on 30 Aug 2026 with
--- 235 Knowledge in hand, assuming he had missed something. From outside, "this
--- route is complete", "we cannot read your trees" and "step 2 names a node in a
--- list of trees" are the same blank space.
---
--- So this prints every step and the reason it did or did not resolve, and it walks
--- the SAME functions the panel uses. A probe with its own copy of the logic would
--- pass on the build the real one fails.
function ns.PrintProfAdviceProbe()
	local function say(s)
		print("|cff8ee6a1MH|r " .. s)
	end
	local d = ns.PROF_ACADEMY
	if not (d and d.advisorRoutes) then
		say("no route data loaded at all — ProfessionAcademyData.lua did not run.")
		return
	end
	-- The panel's own two functions, not copies of them.
	local profs = GetPrimaryProfessions()
	if not profs or #profs == 0 then
		say("no professions detected. Open a profession window once, then retry.")
		return
	end
	local classToken = select(2, UnitClass("player"))
	for _, p in ipairs(profs) do
		local summary = GetSpecSummary(p.skillLine)
		say(("=== %s (skillLine %s)"):format(p.name or "?", tostring(p.skillLine)))
		local route = d.advisorRoutes[p.skillLine]
		if not route then
			say("   no curated route for this profession — silence here is correct.")
		elseif not (summary and summary.tabs and #summary.tabs > 0) then
			say("   trees unreadable (no tabs). Not the same as 'no advice'.")
		else
			local tabs = {}
			for _, t in ipairs(summary.tabs) do
				if t.name then
					tabs[t.name:lower()] = t
				end
			end
			local nodes, nodeCount = nil, 0
			if summary.midnightLine and ns.GetProfessionSpecNodes then
				local okN, list = pcall(ns.GetProfessionSpecNodes, summary.midnightLine)
				if okN and type(list) == "table" then
					nodes = {}
					for _, n in ipairs(list) do
						if n.name then
							nodes[n.name:lower()] = n
							nodeCount = nodeCount + 1
						end
					end
				end
			end
			say(("   %d trees, %s nodes readable")
				:format(#summary.tabs, nodes and tostring(nodeCount) or "no"))
			for i, step in ipairs(route) do
				local isNode = (step.anyOfNodes or step.node) and true or false
				local names = step.anyOfNodes or step.anyOf or { step.node or step.tree }
				local hits = {}
				for _, n in ipairs(names) do
					local t = isNode and (nodes and nodes[n:lower()]) or tabs[n:lower()]
					if t then
						local got = isNode and (t.purchased or 0) or math.max((t.active or 0) - 1, 0)
						local cap = isNode and (t.max or 0) or math.max((t.max or 0) - 1, 0)
						hits[#hits + 1] = ("%s %d/%d"):format(n, got, cap)
					else
						hits[#hits + 1] = ("%s |cffff6666NOT FOUND|r"):format(n)
					end
				end
				local skip = (step.skipIfClass and step.skipIfClass == classToken)
					and " |cff8a8f98(skipped for your class)|r" or ""
				say(("   step %d [%s] %s%s"):format(i, isNode and "node" or "tree",
					table.concat(hits, " | "), skip))
			end
			local advice, points, goals = GetAdviceForProf(p.skillLine, summary, summary.midnightLine)
			if advice == nil and goals then
				say("   -> verdict: goal split (gold vs self), both shown.")
			elseif advice == nil then
				say("   -> verdict: |cffff6666nothing resolved|r — no line is drawn.")
			elseif advice == false then
				say("   -> verdict: route complete; node route / fallback decides.")
			else
				say(("   -> verdict: advise %s%s"):format(advice.name or "?",
					points and (" (aim %d)"):format(points) or ""))
			end
		end
	end
end
