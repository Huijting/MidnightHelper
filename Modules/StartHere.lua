--[[
	Midnight Helper — "Start Here" tab: a guided first-week roadmap for brand-new
	Midnight players. It does not duplicate any system — each step links to the
	tool that already covers it (ns.SelectTab) and the weekly steps auto-tick from
	the same helpers the Home dashboard uses (never-lie: a tick only appears where
	a real signal exists). Layout mirrors WorldContent.lua (scroll child + push +
	Relayout on GetStringHeight).
]]

local _, ns = ...

local SIDE_PAD = 14
local TOP_PAD = 12
local BTN_H = 26

local COLOR_HEADER = { 0.91, 0.76, 0.42 }
local COLOR_DIM = { 0.75, 0.78, 0.82 }
local COLOR_GOOD = { 0.45, 0.95, 0.5 }
local COLOR_SOFT = { 0.9, 0.82, 0.45 }
local COLOR_ACCENT = { 0.55, 0.78, 1 }

-- Ready-check texture for the "done" tick (plain unicode renders as a box).
local TICK = "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12:0:0|t"

-- The roadmap. navTab values are ids/aliases accepted by ns.SelectTab.
-- weeklies entries auto-tick from ns[<fnName>]() (resolved at refresh time so
-- load order never matters).
local STEPS = {
	{ titleKey = "START_S1_TITLE", bodyKey = "START_S1_BODY", navTab = "delves", navLabelKey = "START_S1_NAV" },
	{ titleKey = "START_S2_TITLE", bodyKey = "START_S2_BODY", navTab = "consumables", navLabelKey = "START_S2_NAV" },
	{ titleKey = "START_S3_TITLE", bodyKey = "START_S3_BODY", navTab = "home", navLabelKey = "START_S3_NAV", statusKind = "vault" },
	{ titleKey = "START_S4_TITLE", bodyKey = "START_S4_BODY", navTab = "delves", navLabelKey = "START_S4_NAV" },
	{
		titleKey = "START_S5_TITLE", bodyKey = "START_S5_BODY", navTab = "world", navLabelKey = "START_S5_NAV",
		weeklies = {
			{ labelKey = "START_WEEKLY_RITUAL", fnName = "IsRitualWeeklyDone" },
			{ labelKey = "START_WEEKLY_VOID", fnName = "IsVoidAssaultWeeklyDone" },
		},
	},
	{ titleKey = "START_S6_TITLE", bodyKey = "START_S6_BODY", navTab = "profacademy", navLabelKey = "START_S6_NAV" },
}

local ui

--------------------------------------------------------------------------------
-- Layout (same engine as WorldContent.lua)
--------------------------------------------------------------------------------

local function Relayout()
	if not ui or not ui.child then
		return
	end
	local width = ui.child:GetWidth()
	if not width or width <= 0 then
		return
	end
	local y = 4
	for _, el in ipairs(ui.order) do
		local w = el.w
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
-- Refresh (weekly ticks)
--------------------------------------------------------------------------------

local function WeeklyDone(fnName)
	local fn = ns[fnName]
	if type(fn) ~= "function" then
		return nil -- not available → not counted
	end
	local ok, res = pcall(fn)
	return ok and res and true or false
end

function ns.RefreshStartHerePanel()
	if not ui or not ui.panel or not ui.panel:IsVisible() then
		return
	end

	-- Top summary: count only the cleanly-detectable binary weeklies (Ritual,
	-- Void, and Showdown on 12.0.7). never-lie: a weekly without a helper is not
	-- counted at all.
	if ui.summaryFs then
		local total, done = 0, 0
		local checks = { "IsRitualWeeklyDone", "IsVoidAssaultWeeklyDone" }
		if ns.IsShowdownsAvailable and ns.IsShowdownsAvailable() then
			checks[#checks + 1] = "IsShowdownWeeklyDone"
		end
		for _, fnName in ipairs(checks) do
			local d = WeeklyDone(fnName)
			if d ~= nil then
				total = total + 1
				if d then
					done = done + 1
				end
			end
		end
		ui.summaryFs:SetText(ns:L("START_WEEKLY_SUMMARY_FMT"):format(done, total))
		if total > 0 and done >= total then
			ui.summaryFs:SetTextColor(0.45, 0.95, 0.5)
		else
			ui.summaryFs:SetTextColor(0.9, 0.82, 0.45)
		end
	end

	-- Per-step weekly ticks (step 5: Ritual + Void).
	for _, row in ipairs(ui.weeklyRows or {}) do
		local done = WeeklyDone(row.fnName) and true or false
		local label = ns:L(row.labelKey)
		if done then
			row.fs:SetText(TICK .. " |cffb8ffc0" .. label .. "|r — |cff74e074" .. ns:L("START_STATUS_DONE") .. "|r")
		else
			row.fs:SetText("|cffd9d2b8" .. label .. "|r — |cffe8c860" .. ns:L("START_STATUS_TODO") .. "|r")
		end
	end

	-- Per-step status lines. Only the vault claim nudge: a per-character "delves
	-- done this week" signal isn't available (Delver's Call quest flags are
	-- account/warband-wide → misleading on a fresh char), so step 4 has no counter.
	for _, row in ipairs(ui.statusRows or {}) do
		if row.kind == "vault" then
			local ready = false
			if ns.GetVaultReminderState then
				local ok, st = pcall(ns.GetVaultReminderState)
				if ok and type(st) == "table" and type(st.entries) == "table" then
					for _, e in ipairs(st.entries) do
						if e.isCurrent and e.kind == "ready" then
							ready = true
							break
						end
					end
				end
			end
			if ready then
				row.fs:SetText(TICK .. " |cffffe066" .. ns:L("START_VAULT_READY") .. "|r")
			else
				row.fs:SetText("|cffaeb4bf" .. ns:L("START_VAULT_NONE") .. "|r")
			end
		end
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

function ns.BuildStartHerePanel(panel)
	if not panel or panel._mhStartHereBuilt then
		return
	end
	panel._mhStartHereBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("START_TITLE"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	subtitle:SetText(ns:L("START_SUBTITLE"))

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperStartHereScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
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
		localeLines = {}, -- { fs, key } static texts re-set on language change
		navButtons = {}, -- { btn, key }
		weeklyRows = {}, -- { fs, fnName, labelKey }
		statusRows = {}, -- { fs, kind } vault / delvercall
	}

	local function push(w, gapTop, indent, button)
		ui.order[#ui.order + 1] = { w = w, gapTop = gapTop, indent = indent, button = button }
	end

	local function staticLine(font, color, key, gapTop, indent)
		local fs = MakeFS(child, font, color)
		fs._mhKey = key
		fs:SetText(ns:L(key))
		ui.localeLines[#ui.localeLines + 1] = fs
		push(fs, gapTop, indent or 0)
		return fs
	end

	-- Weekly progress summary (refreshed live).
	ui.summaryFs = MakeFS(child, "GameFontHighlightSmall", COLOR_SOFT)
	push(ui.summaryFs, 6, 0)

	-- Intro.
	staticLine("GameFontNormal", COLOR_HEADER, "START_INTRO_HEADER", 10, 0)
	staticLine("GameFontHighlightSmall", COLOR_DIM, "START_INTRO_BODY", 4, 0)

	-- Steps.
	for _, step in ipairs(STEPS) do
		staticLine("GameFontNormal", COLOR_HEADER, step.titleKey, 16, 0)
		staticLine("GameFontHighlightSmall", COLOR_DIM, step.bodyKey, 4, 0)

		if step.weeklies then
			for _, wk in ipairs(step.weeklies) do
				local fs = MakeFS(child, "GameFontHighlightSmall")
				push(fs, 4, 8)
				ui.weeklyRows[#ui.weeklyRows + 1] = { fs = fs, fnName = wk.fnName, labelKey = wk.labelKey }
			end
		end

		if step.statusKind then
			local fs = MakeFS(child, "GameFontHighlightSmall")
			push(fs, 4, 8)
			ui.statusRows[#ui.statusRows + 1] = { fs = fs, kind = step.statusKind }
		end

		if step.navTab then
			local target = step.navTab
			local btn = MakeButton(child, function()
				if ns.SelectTab then
					ns.SelectTab(target)
				end
			end)
			btn._mhKey = step.navLabelKey
			btn:SetText(ns:L(step.navLabelKey))
			ui.navButtons[#ui.navButtons + 1] = btn
			push(btn, 6, 0, true)
		end
	end

	-- Reset day.
	staticLine("GameFontNormal", COLOR_ACCENT, "START_RESET_TITLE", 16, 0)
	staticLine("GameFontHighlightSmall", COLOR_DIM, "START_RESET_BODY", 4, 0)

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
		ns.RefreshStartHerePanel()
	end)

	ns.StartHerePanel = panel
	ns.RefreshStartHerePanel()
end

--------------------------------------------------------------------------------
-- Locale + events
--------------------------------------------------------------------------------

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("START_TITLE"))
			ui.subtitle:SetText(ns:L("START_SUBTITLE"))
			for _, fs in ipairs(ui.localeLines) do
				fs:SetText(ns:L(fs._mhKey))
			end
			for _, btn in ipairs(ui.navButtons) do
				btn:SetText(ns:L(btn._mhKey))
			end
		end
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshStartHerePanel()
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("QUEST_LOG_UPDATE")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("WEEKLY_REWARDS_UPDATE")
ev:SetScript("OnEvent", function()
	if ui and ui.panel and ui.panel:IsShown() then
		ns.RefreshStartHerePanel()
	end
end)
