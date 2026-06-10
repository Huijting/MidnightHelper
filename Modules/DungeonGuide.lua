--[[
	Dungeons tab — phase 1+2 of docs/DUNGEON_COACH_PLAN.md.

	Three views (same proven pattern as Void & Rituals):
	  - This week  : Spark weekly, Halduron's dungeon of the week, Cracked
	                 Keystone, Great Vault Dungeons row, Follower hint.
	  - Dungeons 101: six beginner chapters with per-character done-marks
	                 (manual marks for now — auto-detect signals are a later
	                 phase, never guessed).
	  - Coach      : full roster (launch + Season 1 rotation) with localized
	                 EJ names; per-boss steps arrive per dungeon in phase 3 —
	                 until then the view says so honestly.

	Data lives in Modules/DungeonRosterData.lua; strings in
	Locales/DungeonGuide.lua (EN+NL pilot).
]]

local _, ns = ...

local SIDE_PAD = 14
local TOP_PAD = 12
local BTN_H = 24

local COLOR_HEADER = { 0.82, 0.68, 0.30 }
local COLOR_DIM = { 0.75, 0.78, 0.82 }
local COLOR_GOOD = { 0.45, 0.95, 0.5 }
local COLOR_WARN = { 1, 0.84, 0.18 }
local COLOR_PROG = { 0.45, 0.85, 0.95 }
local COLOR_SOFT = { 0.9, 0.82, 0.45 }
local COLOR_ACCENT = { 0.55, 0.78, 1 }

local ICON_DONE = "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12:0:0|t"
local ICON_OPEN = "|TInterface\\RaidFrame\\ReadyCheck-Waiting:12:12:0:0|t"

local ui

local COURSE_CHAPTERS = {
	{ key = "ch1", titleKey = "DGN_CH1_TITLE", bodyKey = "DGN_CH1_BODY" },
	{ key = "ch2", titleKey = "DGN_CH2_TITLE", bodyKey = "DGN_CH2_BODY" },
	{ key = "ch3", titleKey = "DGN_CH3_TITLE", bodyKey = "DGN_CH3_BODY" },
	{ key = "ch4", titleKey = "DGN_CH4_TITLE", bodyKey = "DGN_CH4_BODY" },
	{ key = "ch5", titleKey = "DGN_CH5_TITLE", bodyKey = "DGN_CH5_BODY" },
	{ key = "ch6", titleKey = "DGN_CH6_TITLE", bodyKey = "DGN_CH6_BODY" },
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

-- Per-character course progress bag (created on demand; nil-safe before login).
local function CourseBag()
	if not ns.db then
		return nil
	end
	ns.db.dungeonCourse = ns.db.dungeonCourse or {}
	local guid = UnitGUID and UnitGUID("player")
	if not guid then
		return nil
	end
	ns.db.dungeonCourse[guid] = ns.db.dungeonCourse[guid] or {}
	return ns.db.dungeonCourse[guid]
end

-- Great Vault Dungeons row (live, type 1 = Activities). Returns
-- unlocked, total, progress or nil while the weekly data hasn't loaded.
local function GetDungeonVaultRow()
	if not (C_WeeklyRewards and C_WeeklyRewards.GetActivities) then
		return nil
	end
	local ok, acts = pcall(C_WeeklyRewards.GetActivities)
	if not ok or type(acts) ~= "table" or #acts == 0 then
		return nil
	end
	local rows, maxP = {}, 0
	for _, a in ipairs(acts) do
		if tonumber(a.type) == 1 and tonumber(a.threshold) then
			rows[#rows + 1] = a
			local p = math.floor(tonumber(a.progress) or 0)
			if p > maxP then
				maxP = p
			end
		end
	end
	if #rows == 0 then
		return nil
	end
	local unlocked = 0
	for _, a in ipairs(rows) do
		if maxP >= (tonumber(a.threshold) or 0) then
			unlocked = unlocked + 1
		end
	end
	return unlocked, #rows, maxP
end

--------------------------------------------------------------------------------
-- Layout (push/Relayout engine, WorldContent pattern with view modes)
--------------------------------------------------------------------------------

local function Relayout()
	if not ui or not ui.child then
		return
	end
	local width = ui.child:GetWidth()
	if not width or width <= 0 then
		return
	end
	local mode = ui.viewMode or "week"
	local y = 4
	for _, el in ipairs(ui.order) do
		local w = el.w
		if el.mode then
			if el.mode ~= mode then
				w:Hide()
			else
				w:Show()
			end
		end
		if w:IsShown() then
			local indent = el.indent or 0
			y = y + (el.gapTop or 0)
			w:ClearAllPoints()
			w:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent, -y)
			w:SetWidth(math.max(width - indent, 1))
			if el.button then
				y = y + BTN_H
			else
				y = y + math.max(w:GetStringHeight() or 0, 1)
			end
		end
	end
	ui.child:SetHeight(math.max(y + 8, 1))
end

--------------------------------------------------------------------------------
-- Refresh
--------------------------------------------------------------------------------

function ns.RefreshDungeonGuidePanel()
	if not ui or not ui.panel or not ui.panel:IsVisible() then
		return
	end

	-- This week ------------------------------------------------------------
	local spark = ns.GetDungeonSparkState and ns.GetDungeonSparkState() or "todo"
	if spark == "done" then
		ui.sparkFs:SetText(ICON_DONE .. " " .. ns:L("DGN_SPARK_DONE"))
		ui.sparkFs:SetTextColor(COLOR_GOOD[1], COLOR_GOOD[2], COLOR_GOOD[3])
	elseif spark == "inlog" then
		ui.sparkFs:SetText(ICON_OPEN .. " " .. ns:L("DGN_SPARK_INLOG"))
		ui.sparkFs:SetTextColor(COLOR_PROG[1], COLOR_PROG[2], COLOR_PROG[3])
	else
		ui.sparkFs:SetText(ICON_OPEN .. " " .. ns:L("DGN_SPARK_TODO"))
		ui.sparkFs:SetTextColor(COLOR_SOFT[1], COLOR_SOFT[2], COLOR_SOFT[3])
	end

	local weekKey, weekState = nil, nil
	if ns.GetDungeonOfTheWeek then
		weekKey, weekState = ns.GetDungeonOfTheWeek()
	end
	if weekKey then
		local d = ns.GetDungeonByKey and ns.GetDungeonByKey(weekKey)
		local name = d and ns.GetDungeonDisplayName(d) or weekKey
		if weekState == "done" then
			ui.weekDgnFs:SetText(ICON_DONE .. " " .. ns:L("DGN_WEEKDGN_DONE_FMT"):format(name))
			ui.weekDgnFs:SetTextColor(COLOR_GOOD[1], COLOR_GOOD[2], COLOR_GOOD[3])
		else
			ui.weekDgnFs:SetText(ICON_OPEN .. " " .. ns:L("DGN_WEEKDGN_INLOG_FMT"):format(name))
			ui.weekDgnFs:SetTextColor(COLOR_PROG[1], COLOR_PROG[2], COLOR_PROG[3])
		end
	else
		ui.weekDgnFs:SetText(ns:L("DGN_WEEKDGN_UNKNOWN"))
		ui.weekDgnFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	end

	if ns.IsCrackedKeystoneDone and ns.IsCrackedKeystoneDone() then
		ui.keystoneFs:SetText(ICON_DONE .. " " .. ns:L("DGN_KEYSTONE_DONE"))
		ui.keystoneFs:SetTextColor(COLOR_GOOD[1], COLOR_GOOD[2], COLOR_GOOD[3])
	else
		ui.keystoneFs:SetText(ns:L("DGN_KEYSTONE_TODO"))
		ui.keystoneFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	end

	local unlocked, total, progress = GetDungeonVaultRow()
	if unlocked then
		ui.vaultFs:SetText(ns:L("DGN_VAULT_FMT"):format(unlocked, total, progress))
		ui.vaultFs:SetTextColor(unlocked > 0 and COLOR_GOOD[1] or COLOR_SOFT[1], unlocked > 0 and COLOR_GOOD[2] or COLOR_SOFT[2], unlocked > 0 and COLOR_GOOD[3] or COLOR_SOFT[3])
	else
		ui.vaultFs:SetText(ns:L("DGN_VAULT_UNKNOWN"))
		ui.vaultFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	end

	-- Dungeons 101 -----------------------------------------------------------
	local bag = CourseBag()
	local done = 0
	for _, ch in ipairs(COURSE_CHAPTERS) do
		local isDone = bag and bag[ch.key] and true or false
		if isDone then
			done = done + 1
		end
		local row = ui.courseRows[ch.key]
		if row then
			row.titleFs:SetText((isDone and (ICON_DONE .. " ") or "") .. ns:L(ch.titleKey))
			row.markBtn:SetText(isDone and (ICON_DONE .. " " .. ns:L("DGN_CH_DONE")) or ns:L("DGN_CH_MARK"))
		end
	end
	ui.courseProgressFs:SetText(ns:L("DGN_COURSE_PROGRESS_FMT"):format(done, #COURSE_CHAPTERS))

	-- Coach (names can localize late — EJ data may warm up after login) ------
	for _, row in ipairs(ui.coachRows) do
		local d = row.dungeon
		local label = ns.GetDungeonDisplayName(d)
		if d.native and d.season1 then
			label = label .. "  |cffffcc00[" .. ns:L("DGN_BADGE_S1") .. "]|r"
		end
		row.nameFs:SetText(label)
		local names = {}
		for i, b in ipairs(d.bosses or {}) do
			names[#names + 1] = "• " .. ns.GetDungeonBossName(b, d, i)
		end
		row.bossFs:SetText(table.concat(names, "|n"))
	end

	Relayout()
end

--------------------------------------------------------------------------------
-- Build
--------------------------------------------------------------------------------

local function MakeFS(parent, font, color)
	local fs = parent:CreateFontString(nil, "OVERLAY", font)
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	if color then
		fs:SetTextColor(color[1], color[2], color[3])
	end
	return fs
end

local function MakeButton(parent, onClick)
	local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	btn:SetHeight(BTN_H)
	local fs = btn.GetFontString and btn:GetFontString()
	if fs then
		fs:SetJustifyH("LEFT")
		fs:ClearAllPoints()
		fs:SetPoint("LEFT", btn, "LEFT", 8, 0)
		fs:SetPoint("RIGHT", btn, "RIGHT", -8, 0)
	end
	btn:SetScript("OnClick", onClick)
	return btn
end

function ns.BuildDungeonGuidePanel(panel)
	if not panel or panel._mhDungeonBuilt then
		return
	end
	panel._mhDungeonBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("DGN_TITLE"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	subtitle:SetText(ns:L("DGN_SUBTITLE"))

	-- View switcher: This week | Dungeons 101 | Dungeon Coach.
	local navWeek = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	navWeek:SetHeight(22)
	navWeek:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	local navCourse = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	navCourse:SetHeight(22)
	navCourse:SetPoint("LEFT", navWeek, "RIGHT", 6, 0)
	local navCoach = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	navCoach:SetHeight(22)
	navCoach:SetPoint("LEFT", navCourse, "RIGHT", 6, 0)

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperDungeonScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", navWeek, "BOTTOMLEFT", 0, -8)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)

	ui = {
		panel = panel,
		title = title,
		subtitle = subtitle,
		scroll = scroll,
		child = child,
		order = {},
		courseRows = {},
		coachRows = {},
		navWeek = navWeek,
		navCourse = navCourse,
		navCoach = navCoach,
		viewMode = (ns.db and ns.db.ui and ns.db.ui.dungeonViewMode) or "week",
	}
	if ui.viewMode ~= "week" and ui.viewMode ~= "course" and ui.viewMode ~= "coach" then
		ui.viewMode = "week"
	end

	local function UpdateNavButtons()
		navWeek:SetText(ns:L("DGN_VIEW_WEEK"))
		navCourse:SetText(ns:L("DGN_VIEW_COURSE"))
		navCoach:SetText(ns:L("DGN_VIEW_COACH"))
		navWeek:SetWidth(math.max((navWeek:GetTextWidth() or 0) + 24, 90))
		navCourse:SetWidth(math.max((navCourse:GetTextWidth() or 0) + 24, 90))
		navCoach:SetWidth(math.max((navCoach:GetTextWidth() or 0) + 24, 90))
		navWeek:SetEnabled(ui.viewMode ~= "week")
		navCourse:SetEnabled(ui.viewMode ~= "course")
		navCoach:SetEnabled(ui.viewMode ~= "coach")
	end
	ui.updateNavButtons = UpdateNavButtons

	local function SetViewMode(mode)
		ui.viewMode = mode
		if ns.db then
			ns.db.ui = ns.db.ui or {}
			ns.db.ui.dungeonViewMode = mode
		end
		UpdateNavButtons()
		ns.RefreshDungeonGuidePanel()
	end
	navWeek:SetScript("OnClick", function()
		SetViewMode("week")
	end)
	navCourse:SetScript("OnClick", function()
		SetViewMode("course")
	end)
	navCoach:SetScript("OnClick", function()
		SetViewMode("coach")
	end)
	UpdateNavButtons()

	local function push(w, gapTop, indent, button, mode)
		ui.order[#ui.order + 1] = { w = w, gapTop = gapTop, indent = indent, button = button, mode = mode }
	end

	-- This week --------------------------------------------------------------
	local weekHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	weekHeader._mhKey = "DGN_WEEK_HEADER"
	weekHeader:SetText(ns:L("DGN_WEEK_HEADER"))
	push(weekHeader, 0, 0, false, "week")
	ui.weekHeader = weekHeader

	ui.sparkFs = MakeFS(child, "GameFontHighlightSmall")
	push(ui.sparkFs, 6, 0, false, "week")
	ui.weekDgnFs = MakeFS(child, "GameFontHighlightSmall")
	push(ui.weekDgnFs, 4, 0, false, "week")
	ui.keystoneFs = MakeFS(child, "GameFontHighlightSmall")
	push(ui.keystoneFs, 4, 0, false, "week")
	ui.vaultFs = MakeFS(child, "GameFontHighlightSmall")
	push(ui.vaultFs, 4, 0, false, "week")
	ui.followerFs = MakeFS(child, "GameFontHighlightSmall", COLOR_ACCENT)
	ui.followerFs._mhKey = "DGN_FOLLOWER_HINT"
	ui.followerFs:SetText(ns:L("DGN_FOLLOWER_HINT"))
	push(ui.followerFs, 12, 0, false, "week")

	-- Dungeons 101 -------------------------------------------------------------
	local courseHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	courseHeader._mhKey = "DGN_COURSE_HEADER"
	courseHeader:SetText(ns:L("DGN_COURSE_HEADER"))
	push(courseHeader, 0, 0, false, "course")
	ui.courseHeader = courseHeader

	ui.courseProgressFs = MakeFS(child, "GameFontHighlightSmall", COLOR_ACCENT)
	push(ui.courseProgressFs, 4, 0, false, "course")

	for _, ch in ipairs(COURSE_CHAPTERS) do
		local titleFs = MakeFS(child, "GameFontNormal", COLOR_SOFT)
		push(titleFs, 12, 0, false, "course")
		local bodyFs = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
		bodyFs._mhBodyKey = ch.bodyKey
		bodyFs:SetText(ns:L(ch.bodyKey))
		push(bodyFs, 4, 8, false, "course")
		local markBtn = MakeButton(child, function()
			local bag = CourseBag()
			if bag then
				bag[ch.key] = not bag[ch.key] or nil
				ns.RefreshDungeonGuidePanel()
			end
		end)
		push(markBtn, 4, 8, true, "course")
		ui.courseRows[ch.key] = { titleFs = titleFs, bodyFs = bodyFs, markBtn = markBtn }
	end

	-- Coach ---------------------------------------------------------------------
	local coachHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	coachHeader._mhKey = "DGN_COACH_HEADER"
	coachHeader:SetText(ns:L("DGN_COACH_HEADER"))
	push(coachHeader, 0, 0, false, "coach")
	ui.coachHeader = coachHeader

	ui.coachIntroFs = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	ui.coachIntroFs._mhKey = "DGN_COACH_INTRO"
	ui.coachIntroFs:SetText(ns:L("DGN_COACH_INTRO"))
	push(ui.coachIntroFs, 4, 0, false, "coach")

	local function AddCoachGroup(headerKey, filterFn)
		local groupFs = MakeFS(child, "GameFontNormal", COLOR_ACCENT)
		groupFs._mhKey = headerKey
		groupFs:SetText(ns:L(headerKey))
		push(groupFs, 14, 0, false, "coach")
		for _, d in ipairs(ns.GetDungeonRoster and ns.GetDungeonRoster() or {}) do
			if filterFn(d) then
				local nameFs = MakeFS(child, "GameFontNormal", COLOR_WARN)
				push(nameFs, 8, 0, false, "coach")
				local bossFs = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
				push(bossFs, 2, 10, false, "coach")
				ui.coachRows[#ui.coachRows + 1] = { dungeon = d, nameFs = nameFs, bossFs = bossFs }
			end
		end
	end
	AddCoachGroup("DGN_GROUP_LAUNCH", function(d)
		return d.native
	end)
	AddCoachGroup("DGN_GROUP_SEASON", function(d)
		return d.season1 and not d.native
	end)

	ui.coachSoonFs = MakeFS(child, "GameFontDisableSmall", COLOR_DIM)
	ui.coachSoonFs._mhKey = "DGN_TIPS_SOON"
	ui.coachSoonFs:SetText(ns:L("DGN_TIPS_SOON"))
	push(ui.coachSoonFs, 14, 0, false, "coach")

	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
			Relayout()
		end
	end
	scroll:SetScript("OnSizeChanged", syncWidth)
	syncWidth()

	panel:SetScript("OnShow", function()
		syncWidth()
		ns.RefreshDungeonGuidePanel()
	end)

	ns.DungeonGuidePanel = panel
	ns.RefreshDungeonGuidePanel()
end

--------------------------------------------------------------------------------
-- Locale refresh + events
--------------------------------------------------------------------------------

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("DGN_TITLE"))
			ui.subtitle:SetText(ns:L("DGN_SUBTITLE"))
			if ui.updateNavButtons then
				ui.updateNavButtons()
			end
			for _, el in ipairs(ui.order) do
				if el.w._mhKey then
					el.w:SetText(ns:L(el.w._mhKey))
				elseif el.w._mhBodyKey then
					el.w:SetText(ns:L(el.w._mhBodyKey))
				end
			end
		end
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshDungeonGuidePanel()
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("QUEST_LOG_UPDATE")
ev:RegisterEvent("WEEKLY_REWARDS_UPDATE")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function()
	if ui and ui.panel and ui.panel:IsShown() then
		ns.RefreshDungeonGuidePanel()
	end
end)
