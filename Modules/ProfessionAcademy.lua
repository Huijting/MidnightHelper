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
local CHECK_SIZE = 24
local BTN_H = 24

local COLOR_TITLE = { 1, 0.88, 0.45 }
local COLOR_TITLE_DONE = { 0.45, 0.9, 0.5 }
local COLOR_BODY = { 0.78, 0.78, 0.8 }
local COLOR_TASK = { 0.85, 0.82, 0.65 }

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
local function GetAdviceForProf(skillLine, summary)
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
	for _, step in ipairs(route) do
		if not (step.skipIfClass and step.skipIfClass == classToken) then
			local names = step.anyOf or { step.tree }
			local display, anyMaxed = nil, false
			for _, n in ipairs(names) do
				local t = byName[n:lower()]
				if t then
					display = display or t
					if t.max > 0 and t.active >= t.max then
						anyMaxed = true
					elseif t.active > 1 then
						-- Player already invests here: advise finishing this one.
						display = t
					end
				end
			end
			if not display then
				return nil
			end
			if not anyMaxed then
				return display
			end
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
	for _, step in ipairs(route) do
		local n = step.node and byName[step.node:lower()]
		if n and (n.purchased or 0) < (n.max or 0) then
			return n, "route"
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
	local advice = GetAdviceForProf(skillLine, summary)
	local text
	if advice == false then
		-- Roots done: name the actual node when we have a verified one for this
		-- profession. Otherwise fall back to the general line.
		local node, why = GetNodeAdviceForProf(skillLine, midnightLine)
		if node then
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
		text = SL("PROFACAD_ADVISE_NEXT_FMT"):format(
			advice.name,
			math.max(advice.active - 1, 0),
			math.max(advice.max - 1, 0))
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
local function Relayout(panel)
	local child = panel._profAcadChild
	local width = child and child:GetWidth()
	if not width or width <= 0 then
		return
	end
	local y = 4
	for _, el in ipairs(panel._profAcadOrder) do
		local w = el.w
		if w:IsShown() then
			y = y + (el.gapTop or 0)
			w:ClearAllPoints()
			w:SetPoint("TOPLEFT", child, "TOPLEFT", el.indent or 0, -y)
			w:SetWidth(math.max(width - (el.indent or 0), 1))
			if el.taskFs then
				-- Task row: height follows the (word-wrapped) label, measured
				-- after the width above is applied.
				local h = math.max((el.taskFs:GetStringHeight() or 0) + 10, CHECK_SIZE)
				w:SetHeight(h)
				y = y + h
			elseif el.fixedH then
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

	local shownNum = 0
	for _, row in ipairs(panel._profAcadRows) do
		local ch = row.chapter
		local visible = IsChapterVisible(ch, profs)
		row.titleFs:SetShown(visible)
		row.bodyFs:SetShown(visible)
		row.taskRow:SetShown(visible)
		if row.wpBtn then
			row.wpBtn:SetShown(visible)
		end

		if visible then
			shownNum = shownNum + 1
			local isDone = IsChapterDone(ch.key)

			local title = ("%d. %s"):format(shownNum, SL(ch.titleKey))
			if isDone then
				title = title .. "  |TInterface\\RaidFrame\\ReadyCheck-Ready:12:12:0:0|t"
				row.titleFs:SetTextColor(COLOR_TITLE_DONE[1], COLOR_TITLE_DONE[2], COLOR_TITLE_DONE[3])
			else
				row.titleFs:SetTextColor(COLOR_TITLE[1], COLOR_TITLE[2], COLOR_TITLE[3])
			end
			row.titleFs:SetText(title)
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
			row.bodyFs:SetText(body)

			local task = SL(ch.taskKey)
			if ch.detect then
				task = task .. "  |cff8a8f98" .. SL("PROFACAD_TASK_AUTO_HINT") .. "|r"
			end
			row.taskFs:SetText(task)
			row.check:SetChecked(isDone)

			if row.wpBtn then
				local wp = ns.PROF_ACADEMY and ch.taskWaypoint and ns.PROF_ACADEMY[ch.taskWaypoint]
				row.wpBtn:SetText(SL((wp and wp.btnKey) or "PROFACAD_BTN_WORKORDER"))
			end
		end
	end

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
	panel._profAcadRows = {}

	local function push(w, gapTop, indent, fixedH, taskFs)
		panel._profAcadOrder[#panel._profAcadOrder + 1] = { w = w, gapTop = gapTop, indent = indent, fixedH = fixedH, taskFs = taskFs }
	end

	for i, ch in ipairs(ns.PROF_ACADEMY.chapters) do
		local row = { chapter = ch }

		local titleFs = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		titleFs:SetFontObject(ns.MHScalableFont("GameFontNormalLarge"))
		titleFs:SetJustifyH("LEFT")
		titleFs:SetWordWrap(true)
		push(titleFs, (i == 1) and 0 or 18, 0)
		row.titleFs = titleFs

		local bodyFs = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		bodyFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		bodyFs:SetJustifyH("LEFT")
		bodyFs:SetWordWrap(true)
		bodyFs:SetTextColor(COLOR_BODY[1], COLOR_BODY[2], COLOR_BODY[3])
		push(bodyFs, 6, 0)
		row.bodyFs = bodyFs

		-- Task row: checkbox + wrapping label. Height is computed in Relayout
		-- from the label's wrapped height (see el.taskFs there).
		local taskRow = CreateFrame("Frame", nil, child)
		taskRow:SetHeight(CHECK_SIZE)
		row.taskRow = taskRow

		local check = CreateFrame("CheckButton", nil, taskRow, "UICheckButtonTemplate")
		check:SetSize(CHECK_SIZE, CHECK_SIZE)
		check:SetPoint("TOPLEFT", taskRow, "TOPLEFT", 0, 0)
		check:SetScript("OnClick", function(self)
			SetChapterDone(ch.key, self:GetChecked() and true or false)
			ns.MH_RefreshProfessionAcademyPanel(panel)
		end)
		row.check = check

		local taskFs = taskRow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		taskFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		taskFs:SetPoint("TOPLEFT", check, "TOPRIGHT", 4, -5)
		taskFs:SetPoint("RIGHT", taskRow, "RIGHT", 0, 0)
		taskFs:SetJustifyH("LEFT")
		taskFs:SetWordWrap(true)
		taskFs:SetTextColor(COLOR_TASK[1], COLOR_TASK[2], COLOR_TASK[3])
		row.taskFs = taskFs
		push(taskRow, 6, 0, CHECK_SIZE, taskFs)

		if ch.taskWaypoint then
			local wpBtn = CreateFrame("Button", nil, child, "UIPanelButtonTemplate")
			wpBtn:SetHeight(BTN_H)
			local wpKey = ch.taskWaypoint
			wpBtn:SetScript("OnClick", function()
				RouteChapterWaypoint(wpKey)
			end)
			local fs = wpBtn.GetFontString and wpBtn:GetFontString()
			if fs then
				fs:SetJustifyH("LEFT")
				fs:ClearAllPoints()
				fs:SetPoint("LEFT", wpBtn, "LEFT", 8, 0)
				fs:SetPoint("RIGHT", wpBtn, "RIGHT", -8, 0)
			end
			push(wpBtn, 4, CHECK_SIZE + 4, BTN_H)
			row.wpBtn = wpBtn
		end

		panel._profAcadRows[i] = row
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
