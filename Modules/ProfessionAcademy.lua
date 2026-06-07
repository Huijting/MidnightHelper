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

--- Colored, localized advisor line for one profession, or nil when no advice.
--- Shows purchased ranks (API rank minus the free base rank), matching the
--- in-game node tooltip ("Rank 5/30").
local function BuildAdviceLine(skillLine, summary)
	local advice = GetAdviceForProf(skillLine, summary)
	if advice == false then
		return "|cff8ee6a1" .. SL("PROFACAD_ADVISE_DONE") .. "|r"
	elseif advice then
		return "|cff8ee6a1"
			.. SL("PROFACAD_ADVISE_NEXT_FMT"):format(
				advice.name,
				math.max(advice.active - 1, 0),
				math.max(advice.max - 1, 0))
			.. "|r"
	end
	return nil
end

--- Header text: detected professions (+ tree state where readable), plus
--- class advice while a slot is open. summaries: [skillLine] = GetSpecSummary.
local function BuildProfsText(profs, summaries)
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
				local line = BuildAdviceLine(p.skillLine, s)
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
	return { spent = spent, unspent = unspent or 0, started = started, tabs = tabsOut }
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

local function RouteWorkOrderStation()
	local d = ns.PROF_ACADEMY
	local wp = d and d.workOrderStation
	if not (wp and wp.mapID and ns.AddSmartTomTomWay) then
		return false
	end
	if ns.IsTomTomReady and ns.IsTomTomReady() then
		pcall(function()
			_G.TomTom:ClearAllWaypoints()
		end)
	end
	return ns.AddSmartTomTomWay(wp.mapID, wp.x, wp.y, SL("PROFACAD_WAYPOINT_WORKORDER")) and true or false
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

function ns.MH_RefreshProfessionAcademyPanel(panel)
	panel = panel or builtPanel
	if not panel or not panel._profAcadBuilt then
		return
	end

	if panel._header and panel._header.SetText then
		panel._header:SetText(SL("TAB_PROF_ACADEMY"))
	end
	panel._subtitle:SetText(SL("PROFACAD_SUBTITLE"))

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
	if anySpent then
		for _, ch in ipairs(ns.PROF_ACADEMY.chapters) do
			if ch.detect == "kpspent" and not IsChapterDone(ch.key) then
				SetChapterDone(ch.key, true)
			end
		end
	end

	local done, total = CountProgress(profs)
	panel._progressFs:SetText(SL("PROFACAD_PROGRESS_FMT"):format(done, total))

	if panel._profsFs then
		panel._profsFs:SetText(BuildProfsText(profs, summaries))
	end

	-- The "choosing trees" chapter repeats the live advice right where the
	-- decision is made (Rob: the header block is out of view by then).
	local treesAdvice = ""
	for _, p in ipairs(profs) do
		local s = summaries[p.skillLine]
		local line = s and BuildAdviceLine(p.skillLine, s)
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
			if ch.key == "trees" and treesAdvice ~= "" then
				body = body .. "\n" .. treesAdvice
			end
			row.bodyFs:SetText(body)

			local task = SL(ch.taskKey)
			if ch.detect then
				task = task .. "  |cff8a8f98" .. SL("PROFACAD_TASK_AUTO_HINT") .. "|r"
			end
			row.taskFs:SetText(task)
			row.check:SetChecked(isDone)

			if row.wpBtn then
				row.wpBtn:SetText(SL("PROFACAD_BTN_WORKORDER"))
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
	subtitle:SetPoint("TOPLEFT", panel._header, "BOTTOMLEFT", 0, -6)
	subtitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -SIDE_PAD, -6)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.78, 0.76, 0.7)
	panel._subtitle = subtitle

	local progressFs = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	progressFs:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -6)
	progressFs:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -SIDE_PAD, -6)
	progressFs:SetJustifyH("LEFT")
	progressFs:SetTextColor(0.55, 0.78, 1)
	panel._progressFs = progressFs

	-- Detected professions + class advice (multi-line; height drives the scroll
	-- anchor below).
	local profsFs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
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
		titleFs:SetJustifyH("LEFT")
		titleFs:SetWordWrap(true)
		push(titleFs, (i == 1) and 0 or 18, 0)
		row.titleFs = titleFs

		local bodyFs = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
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
			wpBtn:SetScript("OnClick", RouteWorkOrderStation)
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
	elseif event == "SKILL_LINES_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
		-- Profession learned/dropped, or KP spent — refresh detection block.
		changed = true
	end
	if changed and builtPanel and builtPanel:IsShown() then
		ns.MH_RefreshProfessionAcademyPanel(builtPanel)
	end
end)
