local _, ns = ...

--[[
	Midnight Helper — the Labyrinth splits window (design A + B, approved by Rob 27 Oct 2026, built 29 Oct: "Ja, begin
	maar met A en B"). Design: https://claude.ai/artifact/TKwQPXn1wA5PPaKc4kHFvw

	One frame, two faces:
	  A "run"  — opens by itself when you leave the Labyrinth: Tier, total, new bests, one row per room with the time and
	             how it compares to your best. Can be switched off with its own checkbox (players choose, not us).
	  B "best" — `/mh labsplits`: your best time per room, one Tier at a time, with the day it was set, your bests added
	             up and the last run. The chat list stays as a record; this is the answer in place.
	Data: LabyrinthSplits.lua (ns.LabSplitsDB, ns.LabSplitsClock). Nothing here writes a time; it only reads, switches
	the two settings and wipes one Tier on request.
]]

local W = 440
local PAD = 22
local ROW_H = 22
local COL_TIME, COL_VS = 64, 120

local STAR = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:12|t"
local GREY = { 0.72, 0.68, 0.59 }
local GREEN = { 0.44, 0.88, 0.44 }
local RED = { 1, 0.54, 0.48 }

local win
local mode = "run" -- "run" or "best"
local shownTier

local function L(key)
	return (ns.L and ns:L(key)) or key
end

local function Clock(s)
	return ns.LabSplitsClock and ns.LabSplitsClock(s) or tostring(s)
end

local function Day(ts)
	-- Same form as the Delve Log (DelveHistory.lua), without the time.
	return (type(ts) == "number" and ts > 0 and date) and date("%b %d", ts) or "-"
end

local function Box(parent)
	local b = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	if b.SetBackdrop then
		b:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
		b:SetBackdropColor(0.13, 0.11, 0.08, 0.95)
	end
	return b
end

local function Text(parent, font, r, g, b)
	local fs = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
	fs:SetJustifyH("LEFT")
	if r then
		fs:SetTextColor(r, g, b)
	end
	return fs
end

--- One row: a coloured strip with three columns. Made on demand, reused.
local function Row(f, i)
	f.rows = f.rows or {}
	local r = f.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, f)
	r:SetSize(W - 2 * PAD, ROW_H)
	r.bg = r:CreateTexture(nil, "BACKGROUND")
	r.bg:SetAllPoints()
	r.a = Text(r)
	r.a:SetPoint("LEFT", 8, 0)
	r.a:SetPoint("RIGHT", r, "RIGHT", -(COL_TIME + COL_VS + 16), 0)
	r.a:SetWordWrap(false)
	r.b = Text(r)
	r.b:SetJustifyH("RIGHT")
	r.b:SetWidth(COL_TIME)
	r.b:SetPoint("RIGHT", r, "RIGHT", -(COL_VS + 8), 0)
	r.c = Text(r)
	r.c:SetJustifyH("RIGHT")
	r.c:SetWidth(COL_VS)
	r.c:SetPoint("RIGHT", r, "RIGHT", -8, 0)
	f.rows[i] = r
	return r
end

local function SetRow(r, a, b, c, color, tint)
	r.a:SetText(a)
	r.b:SetText(b)
	r.c:SetText(c)
	r.c:SetTextColor(unpack(color or GREY))
	if tint then
		r.bg:SetColorTexture(0.10, 0.17, 0.09, 0.9)
	else
		r.bg:SetColorTexture(0.12, 0.10, 0.07, 0.9)
	end
	r:Show()
end

local Refresh

local function Ensure()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperLabSplits", UIParent, "BackdropTemplate")
	f:SetFrameStrata("DIALOG")
	f:SetSize(W, 400)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)

	f.title = Text(f, "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", PAD, -18)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)

	-- A: three stat boxes.
	f.stats = {}
	local boxW = (W - 2 * PAD - 2 * 10) / 3
	for i = 1, 3 do
		local b = Box(f)
		b:SetSize(boxW, 44)
		b:SetPoint("TOPLEFT", PAD + (i - 1) * (boxW + 10), -46)
		b.label = Text(b, "GameFontHighlightSmall", unpack(GREY))
		b.label:SetPoint("TOPLEFT", 8, -6)
		b.value = Text(b, "GameFontHighlightLarge")
		b.value:SetPoint("BOTTOMLEFT", 8, 6)
		f.stats[i] = b
	end

	-- B: one button per Tier that has times.
	f.tierBtns = {}

	f.head = Row(f, 0)
	f.head.bg:SetColorTexture(0, 0, 0, 0)
	for _, fs in ipairs({ f.head.a, f.head.b, f.head.c }) do
		fs:SetFontObject("GameFontHighlightSmall")
		fs:SetTextColor(unpack(GREY))
	end

	f.note = Text(f, "GameFontHighlightSmall", unpack(GREY))
	f.note:SetWidth(W - 2 * PAD)
	f.note:SetSpacing(2)

	-- B: the summary box (bests added up, last run).
	f.sum = Box(f)
	f.sum:SetSize(W - 2 * PAD, 46)
	f.sum.l1 = Text(f.sum, "GameFontHighlightSmall", unpack(GREY))
	f.sum.l1:SetPoint("TOPLEFT", 10, -8)
	f.sum.v1 = Text(f.sum, "GameFontNormal")
	f.sum.v1:SetPoint("TOPRIGHT", -10, -8)
	f.sum.l2 = Text(f.sum, "GameFontHighlightSmall", unpack(GREY))
	f.sum.l2:SetPoint("BOTTOMLEFT", 10, 8)
	f.sum.v2 = Text(f.sum, "GameFontNormal")
	f.sum.v2:SetPoint("BOTTOMRIGHT", -10, 8)

	f.check = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
	f.check:SetPoint("BOTTOMLEFT", PAD - 4, 46)
	f.check.label = f.check.text or Text(f.check)
	if not f.check.text then
		f.check.label:SetPoint("LEFT", f.check, "RIGHT", 2, 0)
	end
	f.check:SetScript("OnClick", function(self)
		local on = self:GetChecked() and true or false
		if mode == "run" then
			ns.LabSplitsDB().noWindow = (not on) and true or nil
		elseif ns.SetLabSplitsEnabled then
			ns.SetLabSplitsEnabled(on)
		end
	end)

	local bw = (W - 2 * PAD - 10) / 2
	f.btn1 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.btn1:SetSize(bw, 26)
	f.btn1:SetPoint("BOTTOMLEFT", PAD, 18)
	f.btn1:SetScript("OnClick", function()
		mode = (mode == "run") and "best" or "run"
		Refresh()
	end)
	f.btn2 = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.btn2:SetSize(bw, 26)
	f.btn2:SetPoint("BOTTOMRIGHT", -PAD, 18)
	f.btn2:SetScript("OnClick", function()
		if mode == "run" then
			f:Hide()
		elseif shownTier and StaticPopup_Show then
			StaticPopup_Show("MH_LABSPLITS_WIPE", (L("LAB_WIN_WIPE_CONFIRM_FMT")):format(shownTier), nil, shownTier)
		end
	end)

	f:Hide()
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	win = f
	return f
end

local function HideRows(f, from)
	for i = from, #(f.rows or {}) do
		f.rows[i]:Hide()
	end
end

--- A: the run that just ended (or the last one, from B).
local function FillRun(f)
	local d = ns.LabSplitsDB()
	local run = d.lastRun
	f.title:SetText(L("LAB_WIN_RUN_TITLE"))
	for _, b in ipairs(f.tierBtns) do
		b:Hide()
	end
	f.sum:Hide()
	for _, b in ipairs(f.stats) do
		b:Show()
	end
	local rooms = run and run.rooms or {}
	f.stats[1].label:SetText(L("LAB_WIN_TIER"))
	f.stats[1].value:SetText(run and tostring(run.tier or 0) or "-")
	f.stats[2].label:SetText(L("LAB_WIN_TOTAL"))
	f.stats[2].value:SetText(run and Clock(run.total) or "-")
	f.stats[3].label:SetText(L("LAB_WIN_NEW_BESTS"))
	f.stats[3].value:SetText(tostring(run and run.records or 0))
	f.stats[3].value:SetTextColor(unpack((run and (run.records or 0) > 0) and GREEN or { 1, 1, 1 }))

	local y = -100
	f.head:SetPoint("TOPLEFT", PAD, y)
	f.head.a:SetText(L("LAB_WIN_COL_ROOM"))
	f.head.b:SetText(L("LAB_WIN_COL_TIME"))
	f.head.c:SetText(L("LAB_WIN_COL_VS"))
	f.head:Show()
	y = y - ROW_H

	local ifBest, anyStar = 0, false
	for i, r in ipairs(rooms) do
		local row = Row(f, i)
		row:SetPoint("TOPLEFT", PAD, y - (i - 1) * (ROW_H + 2))
		local vs, color = L("LAB_WIN_FIRST"), GREY
		if r.noName then
			vs = "-"
		elseif r.best then
			local diff = r.secs - r.best
			if diff < 0 then
				vs, color = (L("LAB_WIN_FASTER_FMT")):format(Clock(-diff)), GREEN
			elseif diff > 0 then
				vs, color = (L("LAB_WIN_SLOWER_FMT")):format(Clock(diff)), RED
			else
				vs = L("LAB_WIN_SAME")
			end
		end
		local star = (r.record or (r.best and r.secs < r.best)) and true or false
		anyStar = anyStar or star
		SetRow(row, star and (r.room .. " " .. STAR) or r.room, Clock(r.secs), vs, color, star)
		ifBest = ifBest + ((r.best and math.min(r.best, r.secs)) or r.secs or 0)
	end
	HideRows(f, #rooms + 1)
	y = y - #rooms * (ROW_H + 2) - 8

	local lines = {}
	if #rooms == 0 then
		lines[#lines + 1] = L("LAB_WIN_NO_RUN")
	else
		if anyStar then
			lines[#lines + 1] = (L("LAB_WIN_STAR_NOTE_FMT")):format(STAR, run.tier or 0)
		end
		lines[#lines + 1] = (L("LAB_WIN_IF_BEST_FMT")):format(Clock(ifBest))
	end
	f.note:SetText(table.concat(lines, "\n"))
	f.note:ClearAllPoints()
	f.note:SetPoint("TOPLEFT", PAD, y)
	f.note:Show()
	y = y - (f.note:GetStringHeight() or 14) - 12

	f.check.label:SetText(L("LAB_WIN_AUTO_SHOW"))
	f.check:SetChecked(d.noWindow ~= true)
	f.btn1:SetText(L("LAB_WIN_BTN_BEST"))
	f.btn1:Enable()
	f.btn2:SetText(CLOSE or "Close")
	f:SetHeight(-y + 84)
end

--- B: best times, one Tier at a time.
local function FillBest(f)
	local d = ns.LabSplitsDB()
	f.title:SetText(L("LAB_WIN_BEST_TITLE"))
	for _, b in ipairs(f.stats) do
		b:Hide()
	end
	local tiers = {}
	for t, rooms in pairs(d.best) do
		if next(rooms) then
			tiers[#tiers + 1] = t
		end
	end
	table.sort(tiers)
	if not (shownTier and d.best[shownTier] and next(d.best[shownTier])) then
		-- The last run's Tier if it has times, else the highest.
		local lr = d.lastRun and d.lastRun.tier
		shownTier = (lr and d.best[lr] and next(d.best[lr])) and lr or tiers[#tiers]
	end

	local y = -46
	local n = #tiers
	local tw = n > 0 and math.min(90, (W - 2 * PAD - (n - 1) * 6) / n) or 0
	for i, t in ipairs(tiers) do
		local b = f.tierBtns[i]
		if not b then
			b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
			b:SetHeight(24)
			b:SetScript("OnClick", function(self)
				shownTier = self.tier
				Refresh()
			end)
			f.tierBtns[i] = b
		end
		b.tier = t
		b:SetWidth(tw)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", PAD + (i - 1) * (tw + 6), y)
		b:SetText((L("LAB_WIN_TIER") .. " %d"):format(t))
		if t == shownTier then
			b:LockHighlight()
		else
			b:UnlockHighlight()
		end
		b:Show()
	end
	for i = n + 1, #f.tierBtns do
		f.tierBtns[i]:Hide()
	end
	if n > 0 then
		y = y - 32
	end

	local rows = {}
	for room, secs in pairs(shownTier and d.best[shownTier] or {}) do
		rows[#rows + 1] = { room = room, secs = secs, at = d.bestAt[shownTier] and d.bestAt[shownTier][room] }
	end
	table.sort(rows, function(a, b)
		return a.room < b.room
	end)

	f.head:SetPoint("TOPLEFT", PAD, y)
	f.head.a:SetText(L("LAB_WIN_COL_ROOM"))
	f.head.b:SetText(L("LAB_WIN_COL_BEST"))
	f.head.c:SetText(L("LAB_WIN_COL_SET"))
	f.head:SetShown(#rows > 0)
	if #rows > 0 then
		y = y - ROW_H
	end
	local sum = 0
	for i, r in ipairs(rows) do
		local row = Row(f, i)
		row:SetPoint("TOPLEFT", PAD, y - (i - 1) * (ROW_H + 2))
		SetRow(row, r.room, Clock(r.secs), Day(r.at), GREY, false)
		sum = sum + r.secs
	end
	HideRows(f, #rows + 1)
	y = y - #rows * (ROW_H + 2) - 8

	if #rows == 0 then
		f.note:SetText(L("LAB_SPLITS_NO_BEST"))
		f.note:ClearAllPoints()
		f.note:SetPoint("TOPLEFT", PAD, y)
		f.note:Show()
		y = y - (f.note:GetStringHeight() or 14) - 12
		f.sum:Hide()
	else
		f.note:Hide()
		f.sum:ClearAllPoints()
		f.sum:SetPoint("TOPLEFT", PAD, y)
		f.sum.l1:SetText(L("LAB_WIN_SUM_BESTS"))
		f.sum.v1:SetText(Clock(sum))
		local lr = d.lastRun
		if lr then
			f.sum.l2:SetText((L("LAB_WIN_LAST_RUN_FMT")):format(Day(lr.at), #(lr.rooms or {}), lr.tier or 0))
			f.sum.v2:SetText(Clock(lr.total))
		else
			f.sum.l2:SetText(L("LAB_WIN_NO_RUN_SHORT"))
			f.sum.v2:SetText("-")
		end
		f.sum:Show()
		y = y - 46 - 12
	end

	f.check.label:SetText(L("LAB_WIN_ENABLE"))
	f.check:SetChecked(ns.IsLabSplitsEnabled and ns.IsLabSplitsEnabled() or false)
	f.btn1:SetText(L("LAB_WIN_BTN_LAST"))
	f.btn1:SetEnabled(d.lastRun ~= nil)
	f.btn2:SetText(shownTier and (L("LAB_WIN_BTN_WIPE_FMT")):format(shownTier) or "-")
	f.btn2:SetEnabled(shownTier ~= nil)
	f:SetHeight(-y + 84)
end

Refresh = function()
	local f = Ensure()
	if mode == "run" then
		FillRun(f)
	else
		FillBest(f)
	end
end

function ns.ShowLabSplitsRun()
	mode = "run"
	Refresh()
	win:Show()
end

function ns.ShowLabSplitsBest()
	mode = "best"
	Refresh()
	win:Show()
end

if StaticPopupDialogs then
	StaticPopupDialogs["MH_LABSPLITS_WIPE"] = {
		text = "%s",
		button1 = YES,
		button2 = NO,
		OnAccept = function(_, tier)
			local d = ns.LabSplitsDB()
			if tier then
				d.best[tier], d.bestAt[tier] = nil, nil
			end
			shownTier = nil
			if win and win:IsShown() then
				Refresh()
			end
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}
end
