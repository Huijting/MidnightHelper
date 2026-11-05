local _, ns = ...

--[[
	TimePlan.lua — "I have 20 minutes: what fits?" (idea B, docs/PLAN_IDEEEN_2026-11-05.md; Rob, 5 Nov 2026: "ik volg
	jouw advies").

	MH knows no time per task (measured that day: only travel time, PLAN_ESTIMATE_FMT). So this window invents none.
	It uses two measured things:
	  1. The player's OWN delve and ritual times: the average duration of this character's recent runs, per delve, on
	     the Tier they play most (DelveHistory.lua / RitualLog.lua). A delve never run has no time and is not offered.
	     The Labyrinth is left out: one run there is a string of rooms of any length.
	  2. The open stops of the weekly routine (ResetRoutine.lua): shown WITHOUT minutes, as "quick stops", because we
	     have no time for them. Clicking one routes there, the same click as on the Home tab.
	Travel time is not added, and the footer says so.

	Doors in: a button under "Your week" on the Home tab, the search bar (CommandList row), and /mh time [10|20|40].
]]

local BUDGETS = { 10, 20, 40 }
local MAX_RUN_ROWS = 5
local MAX_QUICK_ROWS = 5
local MAX_SANE_DURATION = 3 * 3600 -- a run "longer" than this is a log left open, not a time

local win

local function Budget()
	local m = ns.db and ns.db.ui and tonumber(ns.db.ui.timePlanMinutes)
	if m == 10 or m == 20 or m == 40 then
		return m
	end
	return 20
end

--- Per delve (or ritual site): the Tier this character plays most and the average time there.
--- @return table list of { name, tier, avg (seconds), runs }
local function CollectRunTimes()
	local out = {}
	local function addFrom(name, entry)
		if type(name) ~= "string" or type(entry) ~= "table" or type(entry.recent) ~= "table" then
			return
		end
		if ns.IsAlwaysBountifulDelve and ns.IsAlwaysBountifulDelve(name) then
			return -- the Labyrinth: see the header
		end
		local byTier = {}
		for _, run in ipairs(entry.recent) do
			local d = tonumber(run.duration) or 0
			local t = tonumber(run.tier) or 0
			if d > 0 and d < MAX_SANE_DURATION and t > 0 and not run.rooms then
				local b = byTier[t] or { sum = 0, n = 0 }
				b.sum = b.sum + d
				b.n = b.n + 1
				byTier[t] = b
			end
		end
		local bestTier, best
		for t, b in pairs(byTier) do
			if not best or b.n > best.n or (b.n == best.n and t > bestTier) then
				bestTier, best = t, b
			end
		end
		if best then
			out[#out + 1] = { name = name, tier = bestTier, avg = best.sum / best.n, runs = best.n }
		end
	end
	local guid = UnitGUID and UnitGUID("player")
	local store = guid and ns.db and ns.db.delveLog and ns.db.delveLog[guid]
	if type(store) == "table" and type(store.delves) == "table" then
		for name, entry in pairs(store.delves) do
			addFrom(name, entry)
		end
	end
	if ns.GetRitualLogEntries then
		local ok, list = pcall(ns.GetRitualLogEntries)
		if ok and type(list) == "table" then
			for _, rit in ipairs(list) do
				addFrom(rit.name, rit.entry)
			end
		end
	end
	return out
end

local function Minutes(seconds)
	return math.max(1, math.ceil((seconds or 0) / 60))
end

--- The open routine stops this character can act on (same filter as the Home headline: open + heroEligible).
local function CollectQuickStops()
	local out = {}
	if not ns.GetResetRoutineSteps then
		return out
	end
	local ok, steps = pcall(ns.GetResetRoutineSteps)
	if not ok or type(steps) ~= "table" then
		return out
	end
	for _, s in ipairs(steps) do
		if s.open and s.heroEligible == true and s.color ~= "good" and s.color ~= "dim" then
			out[#out + 1] = s
		end
	end
	return out
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperTimePlan", UIParent, "BackdropTemplate")
	f:SetSize(480, 360)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- Shift+scroll scales it, like every MH window
	end
	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 18, -16)
	title:SetPoint("TOPRIGHT", -40, -16)
	title:SetJustifyH("LEFT")
	f.title = title

	f.budgetBtns = {}
	local prev
	for i, m in ipairs(BUDGETS) do
		local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		b:SetSize(80, 24)
		if prev then
			b:SetPoint("LEFT", prev, "RIGHT", 8, 0)
		else
			b:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
		end
		b:SetText(ns:L("TIMEPLAN_MIN_FMT"):format(m))
		b:SetScript("OnClick", function()
			ns.db.ui = ns.db.ui or {}
			ns.db.ui.timePlanMinutes = m
			ns.ShowTimePlan()
		end)
		b._minutes = m
		f.budgetBtns[i] = b
		prev = b
	end

	f.lines = {}
	win = f
	return f
end

local function AcquireLine(f, i)
	local row = f.lines[i]
	if not row then
		row = CreateFrame("Button", nil, f)
		row.fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		row.fs:SetPoint("TOPLEFT", 0, 0)
		row.fs:SetPoint("RIGHT", row, "RIGHT", 0, 0)
		row.fs:SetJustifyH("LEFT")
		row.fs:SetSpacing(2)
		row:SetScript("OnEnter", function(self)
			if self._onClick then
				self.fs:SetTextColor(1, 0.82, 0)
			end
		end)
		row:SetScript("OnLeave", function(self)
			self.fs:SetTextColor(unpack(self._color or { 1, 1, 1 }))
		end)
		row:SetScript("OnClick", function(self)
			if self._onClick then
				pcall(self._onClick)
			end
		end)
		f.lines[i] = row
	end
	return row
end

local COLOR_HEAD = { 0.91, 0.76, 0.42 }
local COLOR_BODY = { 0.95, 0.93, 0.88 }
local COLOR_DIM = { 0.65, 0.63, 0.58 }

local function Refresh(f)
	local budget = Budget()
	f.title:SetText(ns:L("TIMEPLAN_TITLE_FMT"):format(budget))
	for _, b in ipairs(f.budgetBtns) do
		if b._minutes == budget then
			b:LockHighlight()
		else
			b:UnlockHighlight()
		end
	end

	local items = {}
	local function add(text, color, onClick, gap)
		items[#items + 1] = { text = text, color = color, onClick = onClick, gap = gap }
	end

	-- 1. Runs with a measured time.
	add(ns:L("TIMEPLAN_RUNS_HEAD"), COLOR_HEAD, nil, 14)
	local runs = CollectRunTimes()
	if #runs == 0 then
		add(ns:L("TIMEPLAN_NO_RUNS"), COLOR_DIM)
	else
		local fits = {}
		local quickest
		for _, r in ipairs(runs) do
			if r.avg <= budget * 60 then
				fits[#fits + 1] = r
			end
			if not quickest or r.avg < quickest.avg then
				quickest = r
			end
		end
		-- The ones you play most first: that average is the most trustworthy.
		table.sort(fits, function(a, b)
			if a.runs ~= b.runs then
				return a.runs > b.runs
			end
			return a.avg < b.avg
		end)
		if #fits == 0 then
			add(ns:L("TIMEPLAN_NONE_FIT_FMT"):format(quickest.name, quickest.tier, Minutes(quickest.avg)), COLOR_DIM)
		end
		for i = 1, math.min(#fits, MAX_RUN_ROWS) do
			local r = fits[i]
			if r.runs == 1 then
				add("- " .. ns:L("TIMEPLAN_RUN_ONE_FMT"):format(r.name, r.tier, Minutes(r.avg)), COLOR_BODY)
			else
				add("- " .. ns:L("TIMEPLAN_RUN_FMT"):format(r.name, r.tier, Minutes(r.avg), r.runs), COLOR_BODY)
			end
		end
	end

	-- 2. Quick stops from the weekly routine, without minutes.
	add(ns:L("TIMEPLAN_QUICK_HEAD"), COLOR_HEAD, nil, 14)
	local quick = CollectQuickStops()
	if #quick == 0 then
		add(ns:L("TIMEPLAN_QUICK_NONE"), COLOR_DIM)
	end
	for i = 1, math.min(#quick, MAX_QUICK_ROWS) do
		add("- " .. (quick[i].text or ""), COLOR_BODY, quick[i].onClick)
	end

	add(ns:L("TIMEPLAN_FOOTER"), COLOR_DIM, nil, 14)

	-- Lay out.
	for _, row in ipairs(f.lines) do
		row:Hide()
	end
	local width = (f:GetWidth() or 480) - 36
	local anchor = f.budgetBtns[1]
	for i, it in ipairs(items) do
		local row = AcquireLine(f, i)
		row._onClick = it.onClick
		row._color = it.color
		row.fs:SetText(it.text)
		row.fs:SetTextColor(unpack(it.color))
		row:SetWidth(width)
		row.fs:SetWidth(width)
		row:SetHeight(math.max(14, row.fs:GetStringHeight() or 14))
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(it.gap or 4))
		row:Show()
		anchor = row
	end
	-- Grow with the text, so a longer translation never runs out of the bottom.
	local top = f:GetTop()
	local bottom = anchor and anchor:GetBottom()
	if top and bottom then
		f:SetHeight(math.max(200, top - bottom + 20))
	end
end

--- Open the window. @param minutes number|nil 10, 20 or 40 (remembered); nil keeps the last choice.
function ns.ShowTimePlan(minutes)
	minutes = tonumber(minutes)
	if minutes == 10 or minutes == 20 or minutes == 40 then
		ns.db.ui = ns.db.ui or {}
		ns.db.ui.timePlanMinutes = minutes
	end
	local f = Build()
	f:Show()
	Refresh(f)
end

function ns.ToggleTimePlan()
	if win and win:IsShown() then
		win:Hide()
	else
		ns.ShowTimePlan()
	end
end
