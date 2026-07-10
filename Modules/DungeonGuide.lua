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

-- Shared status palette (UI.lua). The fallbacks keep this module standalone.
local C = ns.UI_COLORS or {}
local COLOR_HEADER = C.header or { 0.91, 0.76, 0.42 }
local COLOR_DIM = C.dim or { 0.75, 0.78, 0.82 }
local COLOR_GOOD = C.good or { 0.45, 0.95, 0.5 }
local COLOR_WARN = C.warn or { 1, 0.84, 0.18 }
local COLOR_PROG = C.prog or { 0.45, 0.85, 0.95 }
local COLOR_SOFT = C.soft or { 0.9, 0.82, 0.45 }
local COLOR_ACCENT = C.link or { 0.55, 0.78, 1 }

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
	local tipHeightChanged = false
	for _, el in ipairs(ui.order) do
		local w = el.w
		if el.mode then
			if el.mode ~= mode then
				w:Hide()
			else
				w:Show()
			end
		end
		-- Inklap-check ná de mode-check (die force-Show't binnen de view).
		if w:IsShown() and el.hiddenFn and el.hiddenFn() then
			w:Hide()
		end
		if w:IsShown() then
			local indent = el.indent or 0
			y = y + (el.gapTop or 0)
			w:ClearAllPoints()
			w:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent, -y)
			w:SetWidth(math.max(width - indent, 1))
			if el.button then
				y = y + BTN_H
			elseif w._mhTipBox then
				-- Read-only EditBox (boss-tips met klikbare spell-links):
				-- hoogte = regels × regelhoogte, gemeten ná SetWidth. De
				-- EERSTE meting na zichtbaar worden is stale (tekst werd
				-- gezet terwijl de box verborgen was — Robs overlap-screen):
				-- bij een hoogte-verandering volgt één nameting op het
				-- volgende frame (convergeert, zie onderaan).
				-- Regelhoogte uit het ACTUELE font (schaalt mee met tekstgrootte).
				-- Bij basisgrootte (12px) blijft dit 14 — geen regressie.
				local lineH = 14
				if w.GetFont then
					local _, fontH = w:GetFont()
					if fontH and fontH > 0 then
						lineH = fontH + 2
					end
				elseif w.GetLineHeight then
					lineH = w:GetLineHeight() or 14
				end
				local numLines = (w.GetNumLines and w:GetNumLines()) or 1
				local h = math.max(numLines * lineH + 4, 14)
				if w._mhLastH ~= h then
					w._mhLastH = h
					tipHeightChanged = true
				end
				y = y + h
			else
				y = y + math.max(w:GetStringHeight() or 0, 1)
			end
		end
	end
	ui.child:SetHeight(math.max(y + 8, 1))
	-- Nameting: alleen als een tipvak van hoogte veranderde (eerste expand);
	-- stopt vanzelf zodra twee passes dezelfde hoogte meten.
	if tipHeightChanged and C_Timer and C_Timer.After and not ui._mhRelayoutPending then
		ui._mhRelayoutPending = true
		C_Timer.After(0, function()
			ui._mhRelayoutPending = false
			Relayout()
		end)
	end
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
		local plainName = ns.GetDungeonDisplayName(d)
		local collapsed = ui._mhIsDgnCollapsed and ui._mhIsDgnCollapsed(d.key)
		-- ASCII-indicator ([+]/[-]) — pijl-glyphs zijn blokjes in WoW-fonts.
		local label = (collapsed and "|cff8a8f98[+]|r " or "|cff8a8f98[-]|r ") .. plainName
		if d.native and d.season1 then
			label = label .. "  |cffffcc00[" .. ns:L("DGN_BADGE_S1") .. "]|r"
		end
		row.nameFs:SetText(label)
		if row.routeBtn then
			row.routeBtn:SetText(ns:L("HOME_WB_ROUTE_BTN_FMT"):format(plainName))
		end
		-- Per boss: name + (when written) the numbered steps and colored role
		-- lines; dungeons without content yet say so honestly per dungeon.
		local lines = {}
		for i, b in ipairs(d.bosses or {}) do
			local bossName = ns.GetDungeonBossName(b, d, i)
			local tips = ns.GetDungeonBossTips and ns.GetDungeonBossTips(d.key, b.key)
			if tips then
				lines[#lines + 1] = "|cffe8c36a" .. bossName .. "|r"
				if tips.steps then
					lines[#lines + 1] = ns:L(tips.steps)
				end
				if tips.tank then
					lines[#lines + 1] = (_G.INLINE_TANK_ICON or "") .. " " .. ns:L(tips.tank)
				end
				if tips.healer then
					lines[#lines + 1] = (_G.INLINE_HEALER_ICON or "") .. " " .. ns:L(tips.healer)
				end
				if tips.dps then
					lines[#lines + 1] = (_G.INLINE_DAMAGER_ICON or "") .. " " .. ns:L(tips.dps)
				end
				if i < #d.bosses then
					lines[#lines + 1] = " "
				end
			else
				lines[#lines + 1] = "• " .. bossName
			end
		end
		if not (ns.DungeonHasTips and ns.DungeonHasTips(d.key)) then
			lines[#lines + 1] = "|cff8a8f98" .. ns:L("DGN_TIPS_SOON") .. "|r"
		end
		local body = table.concat(lines, "|n")
		if ns.ExpandDelveTipMarkup then
			body = ns:ExpandDelveTipMarkup(body) -- {SPELL:id} → klikbare links
		end
		row.bossFs:SetText(body)
	end

	if ui.fillMythic then
		ui.fillMythic()
	end

	Relayout()
end

--------------------------------------------------------------------------------
-- Build
--------------------------------------------------------------------------------

local function MakeFS(parent, font, color)
	local fs = parent:CreateFontString(nil, "OVERLAY", font)
	if ns.MHScalableFont and type(font) == "string" then
		fs:SetFontObject(ns.MHScalableFont(font))
	end
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
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("DGN_TITLE"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
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
	local navMythic = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	navMythic:SetHeight(22)
	navMythic:SetPoint("LEFT", navCoach, "RIGHT", 6, 0)

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
		navMythic = navMythic,
		viewMode = (ns.db and ns.db.ui and ns.db.ui.dungeonViewMode) or "week",
	}
	if ui.viewMode ~= "week" and ui.viewMode ~= "course" and ui.viewMode ~= "coach"
		and ui.viewMode ~= "mythic" then
		ui.viewMode = "week"
	end

	local function UpdateNavButtons()
		navWeek:SetText(ns:L("DGN_VIEW_WEEK"))
		navCourse:SetText(ns:L("DGN_VIEW_COURSE"))
		navCoach:SetText(ns:L("DGN_VIEW_COACH"))
		navMythic:SetText(ns:L("MPLUS_VIEW"))
		navWeek:SetWidth(math.max((navWeek:GetTextWidth() or 0) + 24, 90))
		navCourse:SetWidth(math.max((navCourse:GetTextWidth() or 0) + 24, 90))
		navCoach:SetWidth(math.max((navCoach:GetTextWidth() or 0) + 24, 90))
		navMythic:SetWidth(math.max((navMythic:GetTextWidth() or 0) + 24, 90))
		navWeek:SetEnabled(ui.viewMode ~= "week")
		navCourse:SetEnabled(ui.viewMode ~= "course")
		navCoach:SetEnabled(ui.viewMode ~= "coach")
		navMythic:SetEnabled(ui.viewMode ~= "mythic")
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
	navMythic:SetScript("OnClick", function()
		SetViewMode("mythic")
	end)
	UpdateNavButtons()

	-- hiddenFn (optioneel): extra zichtbaarheidscheck bovenop de view-mode —
	-- gebruikt door de inklapbare Coach-dungeons (Rob 11 jun).
	local function push(w, gapTop, indent, button, mode, hiddenFn)
		ui.order[#ui.order + 1] = { w = w, gapTop = gapTop, indent = indent, button = button, mode = mode, hiddenFn = hiddenFn }
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
		-- SafeL: CH3 bevat "Toolbox → Macros" — kale ns:L zou de pijl als
		-- blokje renderen (zelfde klasse als de 10-juni-sweep).
		bodyFs:SetText(ns.SafeL and ns:SafeL(ch.bodyKey) or ns:L(ch.bodyKey))
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

	-- Inklapbaar per dungeon (Rob 11 jun: "mooier als ze opengeklikt moeten
	-- worden"): standaard dicht (nil = dicht, false = open; sessie-gebonden).
	ui.coachCollapsed = ui.coachCollapsed or {}
	local function IsDgnCollapsed(key)
		return ui.coachCollapsed[key] ~= false
	end
	ui._mhIsDgnCollapsed = IsDgnCollapsed

	local function AddCoachGroup(headerKey, filterFn)
		local groupFs = MakeFS(child, "GameFontNormal", COLOR_ACCENT)
		groupFs._mhKey = headerKey
		groupFs:SetText(ns:L(headerKey))
		push(groupFs, 14, 0, false, "coach")
		for _, d in ipairs(ns.GetDungeonRoster and ns.GetDungeonRoster() or {}) do
			if filterFn(d) then
				-- De dungeonnaam is een MakeButton — exact hetzelfde widget als
				-- de route-knoppen (bewezen render + klik in dit paneel; drie
				-- overlay/plain-Button-varianten faalden live bij Rob).
				local nameFs = MakeButton(child, function()
					-- Expliciete if — NIET de `x and false or true`-idioom:
					-- die geeft altijd true (Robs klik-mysterie, 11 jun).
					if IsDgnCollapsed(d.key) then
						-- Accordion (Rob 15 jun: max één dungeon tegelijk open):
						-- sluit eerst alle andere. Alleen geopende dungeons hebben
						-- een `false`-entry; de rest is al impliciet dicht.
						for k in pairs(ui.coachCollapsed) do
							ui.coachCollapsed[k] = true
						end
						ui.coachCollapsed[d.key] = false
					else
						ui.coachCollapsed[d.key] = true
					end
					ns.RefreshDungeonGuidePanel()
				end)
				nameFs:RegisterForClicks("AnyUp")
				push(nameFs, 8, 0, true, "coach")
				local collapsedFn = function()
					return IsDgnCollapsed(d.key)
				end
				-- Read-only EditBox i.p.v. FontString: nodig voor hover/klik op
				-- de {SPELL:id}-links (FontStrings doen geen hyperlinks) —
				-- zelfde patroon als de Delve Coach (DelveTipMarkup).
				local bossFs = CreateFrame("EditBox", nil, child)
				bossFs:SetMultiLine(true)
				bossFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
				bossFs:SetJustifyH("LEFT")
				bossFs:SetAutoFocus(false)
				bossFs:EnableMouse(true)
				if bossFs.SetMaxLetters then
					bossFs:SetMaxLetters(0)
				end
				bossFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
				bossFs._mhTipBox = true
				if ns.AttachDelveTipHyperlinksToEditBox then
					ns:AttachDelveTipHyperlinksToEditBox(bossFs)
				end
				push(bossFs, 2, 10, false, "coach", collapsedFn)
				local routeBtn
				if d.entrance and ns.RouteDungeonEntrance then
					routeBtn = MakeButton(child, function()
						ns.RouteDungeonEntrance(d)
					end)
					push(routeBtn, 4, 10, true, "coach", collapsedFn)
				end
				ui.coachRows[#ui.coachRows + 1] = { dungeon = d, nameFs = nameFs, bossFs = bossFs, routeBtn = routeBtn }
			end
		end
	end
	AddCoachGroup("DGN_GROUP_LAUNCH", function(d)
		return d.native
	end)
	AddCoachGroup("DGN_GROUP_SEASON", function(d)
		return d.season1 and not d.native
	end)

	-- Mythic+ -------------------------------------------------------------------
	-- Twee weergaven binnen de Mythic+-view: Beginnersmodus (rustig, gewone taal,
	-- weinig op't scherm) en de volledige Expert-info. De toggle staat altijd
	-- bovenaan; de rest filtert via hiddenFn (Rob 15 jun, voor zijn zus: minder
	-- tekst, geen jargon, niks dat overweldigt tot ze er klaar voor is).
	local function beginnerOn()
		return (ns.db and ns.db.ui and ns.db.ui.mplusBeginner) and true or false
	end
	local function beginnerHidden()
		return not beginnerOn()
	end
	local function expertHidden()
		return beginnerOn()
	end
	-- Bonus-regel van het week-kaartje: alleen in beginnersmodus én alleen als we
	-- de dungeon-of-the-week écht kennen (never-lie — anders niks tonen).
	local function weekBonusHidden()
		if not beginnerOn() then
			return true
		end
		if not ns.GetDungeonOfTheWeek then
			return true
		end
		local key = ns.GetDungeonOfTheWeek()
		return not key
	end

	local mythicHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	mythicHeader._mhKey = "MPLUS_HEADER"
	mythicHeader:SetText(ns:L("MPLUS_HEADER"))
	push(mythicHeader, 0, 0, false, "mythic")

	-- Beginner/expert-toggle (altijd zichtbaar; label gezet in FillMythic).
	local beginnerBtn = MakeButton(child, function()
		if ns.db then
			ns.db.ui = ns.db.ui or {}
			ns.db.ui.mplusBeginner = not beginnerOn()
		end
		ns.RefreshDungeonGuidePanel()
	end)
	push(beginnerBtn, 6, 0, true, "mythic")
	ui.mplusBeginnerBtn = beginnerBtn

	-- ===== "Deze week, voor jou"-kaartje (idee 3; beginnersmodus) =====
	local weekHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	weekHeader._mhKey = "MPLUS_WEEK_HEADER"
	weekHeader:SetText(ns:L("MPLUS_WEEK_HEADER"))
	push(weekHeader, 10, 0, false, "mythic", beginnerHidden)

	local weekBody = MakeFS(child, "GameFontHighlightSmall", COLOR_ACCENT)
	weekBody._mhKey = "MPLUS_WEEK_BODY"
	weekBody:SetText(ns:L("MPLUS_WEEK_BODY"))
	push(weekBody, 6, 8, false, "mythic", beginnerHidden)

	ui.mplusWeekBonusFs = MakeFS(child, "GameFontHighlightSmall", COLOR_SOFT)
	push(ui.mplusWeekBonusFs, 4, 8, false, "mythic", weekBonusHidden)

	local weekAvoid = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	weekAvoid._mhKey = "MPLUS_WEEK_AVOID"
	weekAvoid:SetText(ns:L("MPLUS_WEEK_AVOID"))
	push(weekAvoid, 4, 8, false, "mythic", beginnerHidden)

	-- ===== Beginnersmodus (rustig) =====
	local begIntro = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	begIntro._mhKey = "MPLUS_BEGINNER_INTRO"
	begIntro:SetText(ns:L("MPLUS_BEGINNER_INTRO"))
	push(begIntro, 8, 0, false, "mythic", beginnerHidden)

	local begStart = MakeFS(child, "GameFontHighlightSmall", COLOR_ACCENT)
	begStart._mhKey = "MPLUS_BEGINNER_START"
	begStart:SetText(ns:L("MPLUS_BEGINNER_START"))
	push(begStart, 8, 0, false, "mythic", beginnerHidden)

	local glossHeader = MakeFS(child, "GameFontNormal", COLOR_ACCENT)
	glossHeader._mhKey = "MPLUS_GLOSSARY_HEADER"
	glossHeader:SetText(ns:L("MPLUS_GLOSSARY_HEADER"))
	push(glossHeader, 12, 0, false, "mythic", beginnerHidden)

	for _, gkey in ipairs(ns.MPLUS_GLOSSARY or {}) do
		local fs = MakeFS(child, "GameFontHighlightSmall")
		fs._mhKey = gkey
		fs:SetText(ns:L(gkey))
		push(fs, 6, 8, false, "mythic", beginnerHidden)
	end

	-- Toegankelijke meldingen (debuff-alert, idee 2): aan/uit + testknop. Werkt op
	-- je EIGEN debuffs (leesbaar) — vijandelijke casts zijn 'secret' (Rob 15 jun).
	local alertsHdr = MakeFS(child, "GameFontNormal", COLOR_ACCENT)
	alertsHdr._mhKey = "ALERT_HELP_HEADER"
	alertsHdr:SetText(ns:L("ALERT_HELP_HEADER"))
	push(alertsHdr, 12, 0, false, "mythic", beginnerHidden)

	local alertsHelp = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	alertsHelp._mhKey = "ALERT_HELP"
	alertsHelp:SetText(ns:L("ALERT_HELP"))
	push(alertsHelp, 4, 8, false, "mythic", beginnerHidden)

	local alertsBtn = MakeButton(child, function()
		if ns.ToggleAccessibleAlerts then
			ns.ToggleAccessibleAlerts()
		end
		ns.RefreshDungeonGuidePanel()
	end)
	push(alertsBtn, 4, 8, true, "mythic", beginnerHidden)
	ui.mplusAlertsBtn = alertsBtn

	local alertsTestBtn = MakeButton(child, function()
		if ns.ShowAccessibleAlertTest then
			ns.ShowAccessibleAlertTest()
		end
	end)
	alertsTestBtn._mhKey = "ALERT_TEST_BTN"
	alertsTestBtn:SetText(ns:L("ALERT_TEST_BTN"))
	push(alertsTestBtn, 4, 8, true, "mythic", beginnerHidden)

	-- ===== Expertmodus (volledige info) =====
	local mythicIntro = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	mythicIntro._mhKey = "MPLUS_INTRO"
	mythicIntro:SetText(ns:L("MPLUS_INTRO"))
	push(mythicIntro, 8, 0, false, "mythic", expertHidden)

	-- Affix-ladder (level-nummer + body; herbouwd in FillMythic voor taalwissel).
	local affixHeader = MakeFS(child, "GameFontNormal", COLOR_ACCENT)
	affixHeader._mhKey = "MPLUS_AFFIX_HEADER"
	affixHeader:SetText(ns:L("MPLUS_AFFIX_HEADER"))
	push(affixHeader, 12, 0, false, "mythic", expertHidden)

	ui.mythicAffixRows = {}
	for _, a in ipairs(ns.MPLUS_AFFIX_LADDER or {}) do
		local fs = MakeFS(child, "GameFontHighlightSmall")
		push(fs, 4, 8, false, "mythic", expertHidden)
		ui.mythicAffixRows[#ui.mythicAffixRows + 1] = { fs = fs, level = a.level, descKey = a.descKey }
	end

	-- Xal'atath's Bargain-varianten (klikbare {SPELL:}-links → EditBox).
	local bargainHeader = MakeFS(child, "GameFontNormal", COLOR_ACCENT)
	bargainHeader._mhKey = "MPLUS_BARGAIN_HEADER"
	bargainHeader:SetText(ns:L("MPLUS_BARGAIN_HEADER"))
	push(bargainHeader, 12, 0, false, "mythic", expertHidden)

	ui.mythicBargainRows = {}
	for _, b in ipairs(ns.MPLUS_BARGAINS or {}) do
		local box = CreateFrame("EditBox", nil, child)
		box:SetMultiLine(true)
		box:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		box:SetJustifyH("LEFT")
		box:SetAutoFocus(false)
		box:EnableMouse(true)
		if box.SetMaxLetters then
			box:SetMaxLetters(0)
		end
		box:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
		box._mhTipBox = true
		if ns.AttachDelveTipHyperlinksToEditBox then
			ns:AttachDelveTipHyperlinksToEditBox(box)
		end
		push(box, 4, 8, false, "mythic", expertHidden)
		ui.mythicBargainRows[#ui.mythicBargainRows + 1] = { box = box, descKey = b.descKey }
	end

	-- Pool (8 dungeons; namen dynamisch + gelokaliseerd in FillMythic).
	local poolHeader = MakeFS(child, "GameFontNormal", COLOR_ACCENT)
	poolHeader._mhKey = "MPLUS_POOL_HEADER"
	poolHeader:SetText(ns:L("MPLUS_POOL_HEADER"))
	push(poolHeader, 12, 0, false, "mythic", expertHidden)

	ui.mythicPoolFs = MakeFS(child, "GameFontHighlightSmall")
	push(ui.mythicPoolFs, 4, 8, false, "mythic", expertHidden)

	local poolNote = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	poolNote._mhKey = "MPLUS_POOL_NOTE"
	poolNote:SetText(ns:L("MPLUS_POOL_NOTE"))
	push(poolNote, 4, 0, false, "mythic", expertHidden)

	-- Systeem-weetjes.
	local sysHeader = MakeFS(child, "GameFontNormal", COLOR_ACCENT)
	sysHeader._mhKey = "MPLUS_SYSTEM_HEADER"
	sysHeader:SetText(ns:L("MPLUS_SYSTEM_HEADER"))
	push(sysHeader, 12, 0, false, "mythic", expertHidden)

	local sysBody = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	sysBody._mhKey = "MPLUS_SYSTEM"
	sysBody:SetText(ns:L("MPLUS_SYSTEM"))
	push(sysBody, 4, 8, false, "mythic", expertHidden)

	-- Must-kicks per dungeon (alleen dungeons met bron — never-lie).
	local kickHeader = MakeFS(child, "GameFontNormal", COLOR_ACCENT)
	kickHeader._mhKey = "MPLUS_KICK_HEADER"
	kickHeader:SetText(ns:L("MPLUS_KICK_HEADER"))
	push(kickHeader, 12, 0, false, "mythic", expertHidden)

	local kickNote = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	kickNote._mhKey = "MPLUS_KICK_NOTE"
	kickNote:SetText(ns:L("MPLUS_KICK_NOTE"))
	push(kickNote, 4, 0, false, "mythic", expertHidden)

	-- Kick-regels als EditBox (i.p.v. FontString) zodat de {SPELL:}-links
	-- klikbaar zijn met tooltip (Rob 15 jun). Tekst wordt in FillMythic gezet
	-- (markup-expansie + taalwissel).
	ui.mythicKickRows = {}
	for _, d in ipairs(ns.GetMythicPoolDungeons and ns.GetMythicPoolDungeons() or {}) do
		local kickKey = ns.GetMythicKicks and ns.GetMythicKicks(d.key)
		if kickKey then
			local box = CreateFrame("EditBox", nil, child)
			box:SetMultiLine(true)
			box:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
			box:SetJustifyH("LEFT")
			box:SetAutoFocus(false)
			box:EnableMouse(true)
			if box.SetMaxLetters then
				box:SetMaxLetters(0)
			end
			box:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
			box._mhTipBox = true
			if ns.AttachDelveTipHyperlinksToEditBox then
				ns:AttachDelveTipHyperlinksToEditBox(box)
			end
			push(box, 6, 8, false, "mythic", expertHidden)
			ui.mythicKickRows[#ui.mythicKickRows + 1] = { box = box, key = kickKey }
		end
	end

	-- Dynamische Mythic+-tekst (toggle-label, level-prefix, markup-links,
	-- dungeonnamen); opnieuw gevuld bij elke refresh zodat een taalwissel +
	-- de beginner/expert-stand meekomen.
	local function FillMythic()
		if ui.mplusBeginnerBtn then
			ui.mplusBeginnerBtn:SetText(ns:L(beginnerOn() and "MPLUS_BEGINNER_BTN_ON" or "MPLUS_BEGINNER_BTN_OFF"))
		end
		if ui.mplusAlertsBtn then
			local on = ns.AccessibleAlertsEnabled and ns.AccessibleAlertsEnabled()
			ui.mplusAlertsBtn:SetText(ns:L(on and "ALERT_BTN_ON" or "ALERT_BTN_OFF"))
		end
		if ui.mplusWeekBonusFs then
			local key = ns.GetDungeonOfTheWeek and ns.GetDungeonOfTheWeek()
			local d = key and ns.GetDungeonByKey and ns.GetDungeonByKey(key)
			if d then
				local nm = (ns.GetDungeonDisplayName and ns.GetDungeonDisplayName(d)) or d.name or key
				ui.mplusWeekBonusFs:SetText(ns:L("MPLUS_WEEK_BONUS_FMT"):format(nm))
			else
				ui.mplusWeekBonusFs:SetText("")
			end
		end
		for _, row in ipairs(ui.mythicAffixRows or {}) do
			row.fs:SetText(("|cffffd100+%d|r  %s"):format(row.level, ns:L(row.descKey)))
		end
		for _, row in ipairs(ui.mythicBargainRows or {}) do
			local body = ns:L(row.descKey)
			if ns.ExpandDelveTipMarkup then
				body = ns:ExpandDelveTipMarkup(body)
			end
			row.box:SetText(body)
		end
		for _, row in ipairs(ui.mythicKickRows or {}) do
			local body = ns:L(row.key)
			if ns.ExpandDelveTipMarkup then
				body = ns:ExpandDelveTipMarkup(body)
			end
			row.box:SetText(body)
		end
		if ui.mythicPoolFs then
			local names = {}
			for _, d in ipairs(ns.GetMythicPoolDungeons and ns.GetMythicPoolDungeons() or {}) do
				names[#names + 1] = "• " .. (ns.GetDungeonDisplayName and ns.GetDungeonDisplayName(d) or d.name or d.key)
			end
			ui.mythicPoolFs:SetText(table.concat(names, "|n"))
		end
	end
	ui.fillMythic = FillMythic
	FillMythic()

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
					-- SafeL: zie comment bij de cursus-opbouw (CH3 bevat →).
					el.w:SetText(ns.SafeL and ns:SafeL(el.w._mhBodyKey) or ns:L(el.w._mhBodyKey))
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
