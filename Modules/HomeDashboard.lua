--[[
	Home dashboard — the "This Week" landing page (first tab in the THIS WEEK
	sidebar section). It is a read-only overview that reuses existing weekly
	aggregates (account weekly checklist, vault reminder, world boss) and offers
	one-click navigation into the detailed tabs. No new game data is computed
	here; every source call is guarded so the panel degrades gracefully when a
	module is missing.

	Layout: compact sections (Vault, World Boss, Rares, Ritual, Void) render in
	two columns; Weekly chores stays full-width because of the long alt rollup.
]]

local _, ns = ...

-- Shared insets come from ns.UI_METRICS (UI.lua); fallbacks keep the module standalone.
local M = ns.UI_METRICS or {}
local SECTION_GAP = M.sectionGap or 8
local HEADER_H = 18
local LINE_H = 15
local TOP_PAD = M.topPad or 12
local SIDE_PAD = M.sidePad or 14
local COL_GAP = 14
local MAX_NAME_PREVIEW = 2

local BTN_H = 22

local COLOR_HEADER = { 0.82, 0.68, 0.30 }
local COLOR_DIM = { 0.72, 0.75, 0.82 }
local COLOR_GOOD = { 0.45, 0.95, 0.5 }
local COLOR_WARN = { 1, 0.84, 0.18 }
local COLOR_SOFT = { 0.9, 0.82, 0.45 }
local COLOR_LINK = { 0.55, 0.78, 1 }
-- "Picked up / in progress" — clearly distinct from WARN yellow (Rob, 10 Jun).
local COLOR_PROG = { 0.45, 0.85, 0.95 }

local ui

local function FormatNamePreview(labels)
	if type(labels) ~= "table" or #labels == 0 then
		return ""
	end
	if #labels <= MAX_NAME_PREVIEW then
		return table.concat(labels, ", ")
	end
	local out = {}
	for i = 1, MAX_NAME_PREVIEW do
		out[#out + 1] = labels[i]
	end
	return table.concat(out, ", ") .. (" (+%d)"):format(#labels - MAX_NAME_PREVIEW)
end

local function FormatResetDuration(seconds)
	seconds = tonumber(seconds)
	if not seconds or seconds <= 0 then
		return nil
	end
	local days = math.floor(seconds / 86400)
	local hours = math.floor((seconds % 86400) / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	if days > 0 then
		return ("%dd %dh"):format(days, hours)
	end
	if hours > 0 then
		return ("%dh %dm"):format(hours, mins)
	end
	return ("%dm"):format(mins)
end

local function GetWeeklyResetText()
	if C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset then
		local ok, secs = pcall(C_DateAndTime.GetSecondsUntilWeeklyReset)
		if ok then
			local dur = FormatResetDuration(secs)
			if dur then
				return ns:L("HOME_RESET_FMT"):format(dur)
			end
		end
	end
	return nil
end

--- Row spec: { header=bool, text=string, color={r,g,b}, onClick=fn|nil }
--- Layout block: { type="full", rows={...} } or { type="columns", left={...}, right={...} }
local function BuildLayout()
	local blocks = {}

	local function header(rows, text)
		rows[#rows + 1] = { header = true, text = text, color = COLOR_HEADER }
	end
	local function line(rows, text, color, onClick)
		rows[#rows + 1] = { text = text, color = color or COLOR_DIM, onClick = onClick }
	end
	local function navLine(rows, tabId, labelKey)
		line(rows, ns:L("HOME_OPEN_FMT"):format(ns:L(labelKey)), COLOR_LINK, function()
			if ns.SelectTab then
				ns.SelectTab(tabId)
			end
		end)
	end
	local function addFull(buildFn)
		local rows = {}
		buildFn(rows)
		blocks[#blocks + 1] = { type = "full", rows = rows }
	end
	local function addColumns(buildLeft, buildRight)
		local left, right = {}, {}
		buildLeft(left)
		buildRight(right)
		blocks[#blocks + 1] = { type = "columns", left = left, right = right }
	end

	local data = ns.ComputeAccountWeeklyChecklist and ns.ComputeAccountWeeklyChecklist() or nil

	------------------------------------------------------------------ Reset routine (ordered, current character)
	if ns.GetResetRoutineSteps then
		local okSteps, steps = pcall(ns.GetResetRoutineSteps)
		if okSteps and type(steps) == "table" and #steps > 0 then
			local colorMap = { good = COLOR_GOOD, warn = COLOR_WARN, soft = COLOR_SOFT, dim = COLOR_DIM, prog = COLOR_PROG }
			addFull(function(rows)
				header(rows, ns:L("HOME_ROUTINE_HEADER"))
				for i, st in ipairs(steps) do
					line(rows, ("%d. %s"):format(i, st.text or ""), colorMap[st.color] or COLOR_DIM, st.onClick)
				end
				if ns.StartResetRoute then
					rows[#rows + 1] = {
						button = true,
						text = ns:L("HOME_ROUTINE_ROUTE_BTN"),
						onClick = function()
							ns.StartResetRoute()
						end,
					}
				end
			end)
		end
	end

	------------------------------------------------------------------ Vault | World Boss
	addColumns(
		function(rows)
			header(rows, ns:L("HOME_SECTION_VAULT"))
			if data and data.charCount and data.charCount > 0 then
				if #data.vaultReady > 0 then
					line(
						rows,
						ns:L("ACCOUNT_WEEKLY_VAULT_READY_FMT"):format(#data.vaultReady, FormatNamePreview(data.vaultReady)),
						COLOR_WARN
					)
				else
					line(rows, ns:L("ACCOUNT_WEEKLY_VAULT_NONE"), COLOR_GOOD)
				end
				if #data.vaultLikely > 0 then
					line(
						rows,
						ns:L("ACCOUNT_WEEKLY_VAULT_LIKELY_FMT"):format(#data.vaultLikely, FormatNamePreview(data.vaultLikely)),
						COLOR_SOFT
					)
				end
			else
				line(rows, ns:L("ACCOUNT_WEEKLY_NO_SNAPSHOTS"), COLOR_DIM)
			end
			navLine(rows, "delves", "TAB_DELVES")
		end,
		function(rows)
			header(rows, ns:L("HOME_SECTION_WORLDBOSS"))
			if ns.GetActiveWorldBoss then
				local boss = ns.GetActiveWorldBoss()
				if boss then
					local name = boss.labelKey and ns:L(boss.labelKey) or boss.name or "?"
					line(rows, ns:L("HOME_WB_ACTIVE_FMT"):format(name), COLOR_DIM)
					local warbandDone = ns.IsWorldBossKilled and ns.IsWorldBossKilled(boss)
					if warbandDone then
						local who = ns.GetWorldBossWarbandCompleter and ns.GetWorldBossWarbandCompleter()
						if type(who) == "string" and who ~= "" then
							line(rows, ns:L("HOME_WB_WARBAND_DONE_BY_FMT"):format(who), COLOR_GOOD)
						else
							line(rows, ns:L("HOME_WB_WARBAND_DONE"), COLOR_GOOD)
						end
					else
						line(rows, ns:L("HOME_WB_WARBAND_TODO"), COLOR_WARN)
					end
					if ns.IsWorldBossDoneOnThisCharacter and ns.IsWorldBossDoneOnThisCharacter(boss) then
						line(rows, ns:L("HOME_WB_CHAR_DONE"), COLOR_GOOD)
					else
						line(rows, ns:L("HOME_WB_CHAR_TODO"), COLOR_SOFT)
					end
					-- Red route button — only when the boss entry has verified
					-- coordinates (RouteToWorldBoss refuses without them).
					if ns.RouteToWorldBoss and boss.mapID and boss.x and boss.y then
						rows[#rows + 1] = {
							button = true,
							text = ns:L("HOME_WB_ROUTE_BTN_FMT"):format(name),
							onClick = function()
								ns.RouteToWorldBoss(boss)
							end,
						}
					end
				else
					line(rows, ns:L("HOME_WB_UNKNOWN"), COLOR_DIM)
				end
			else
				line(rows, ns:L("HOME_WB_UNKNOWN"), COLOR_DIM)
			end
		end
	)

	------------------------------------------------------------------ Weekly chores (full width)
	addFull(function(rows)
		header(rows, ns:L("HOME_SECTION_CHORES"))
		if data and data.charCount and data.charCount > 0 then
			local any = false
			if data.smcTotal then
				any = true
				local done = data.smcDone or 0
				if done >= data.smcTotal then
					line(rows, ns:L("ACCOUNT_WEEKLY_SMC_DONE_FMT"):format(done, data.smcTotal), COLOR_GOOD)
				else
					line(rows, ns:L("ACCOUNT_WEEKLY_SMC_FMT"):format(done, data.smcTotal), COLOR_SOFT)
				end
			end
			local dc = data.delverCurrent
			if dc and (tonumber(dc.total) or 0) > 0 then
				any = true
				local completed = tonumber(dc.completed) or 0
				local total = tonumber(dc.total) or 0
				local banked = tonumber(dc.banked) or 0
				local text = ns:L("ACCOUNT_WEEKLY_DELVER_FMT"):format(completed, total)
				if banked > 0 then
					text = text .. ns:L("ACCOUNT_WEEKLY_DELVER_BANKED_SUFFIX"):format(banked)
				end
				local dcColor = COLOR_SOFT
				if completed >= total then
					dcColor = COLOR_GOOD
				elseif banked > 0 then
					dcColor = COLOR_WARN
				end
				line(rows, text, dcColor, function()
					if ns.SelectTab then
						ns.SelectTab("account")
					end
				end)
				if data.delverBankedTotal and data.delverBankedTotal > 0 then
					line(
						rows,
						ns:L("ACCOUNT_WEEKLY_DELVER_BANKED_ALTS_FMT"):format(
							data.delverBankedTotal,
							FormatNamePreview(data.delverBankedLabels)
						),
						COLOR_WARN
					)
				end
				if data.delverIncompleteLabels and #data.delverIncompleteLabels > 0 then
					line(
						rows,
						ns:L("ACCOUNT_WEEKLY_DELVER_ALTS_FMT"):format(
							#data.delverIncompleteLabels,
							FormatNamePreview(data.delverIncompleteLabels)
						),
						COLOR_SOFT
					)
				end
			end
			local gs = data.gildedCurrent
			if gs and (tonumber(gs.max) or 0) > 0 then
				any = true
				local progress = tonumber(gs.progress) or 0
				local max = tonumber(gs.max) or 4
				local gsColor = COLOR_SOFT
				local gsText = ns:L("ACCOUNT_WEEKLY_GILDED_FMT"):format(progress, max)
				if ns.ShouldShowDelveWeeklyUnderlevel and ns.ShouldShowDelveWeeklyUnderlevel("gilded", gs) then
					gsText = ns:L("ACCOUNT_WEEKLY_GILDED_UNDERLEVEL_FMT"):format(ns.GetDelveCapLevel())
					gsColor = COLOR_DIM
				elseif progress >= max then
					gsColor = COLOR_GOOD
				end
				line(rows, gsText, gsColor, function()
					if ns.SelectTab then
						ns.SelectTab("account")
					end
				end)
				if data.gildedIncompleteLabels and #data.gildedIncompleteLabels > 0 then
					line(
						rows,
						ns:L("ACCOUNT_WEEKLY_GILDED_ALTS_FMT"):format(
							#data.gildedIncompleteLabels,
							FormatNamePreview(data.gildedIncompleteLabels)
						),
						COLOR_SOFT
					)
				end
			end
			local trove = data.troveCurrent
			if trove then
				any = true
				local text = ns:L("ACCOUNT_WEEKLY_TROVE_AVAILABLE")
				local troveColor = COLOR_SOFT
				if ns.ShouldShowDelveWeeklyUnderlevel and ns.ShouldShowDelveWeeklyUnderlevel("trove", trove) then
					text = ns:L("ACCOUNT_WEEKLY_TROVE_UNDERLEVEL_FMT"):format(ns.GetDelveCapLevel())
					troveColor = COLOR_DIM
				elseif trove.status == "done" or trove.status == "active" then
					text = trove.status == "active" and ns:L("ACCOUNT_WEEKLY_TROVE_ACTIVE") or ns:L("ACCOUNT_WEEKLY_TROVE_DONE")
					troveColor = COLOR_GOOD
				elseif trove.status == "looted" then
					text = ns:L("ACCOUNT_WEEKLY_TROVE_LOOTED")
					troveColor = COLOR_WARN
				end
				line(rows, text, troveColor, function()
					if ns.SelectTab then
						ns.SelectTab("account")
					end
				end)
				if data.troveUnusedLabels and #data.troveUnusedLabels > 0 then
					line(
						rows,
						ns:L("ACCOUNT_WEEKLY_TROVE_UNUSED_ALTS_FMT"):format(
							#data.troveUnusedLabels,
							FormatNamePreview(data.troveUnusedLabels)
						),
						COLOR_WARN
					)
				end
				if data.troveNeedLabels and #data.troveNeedLabels > 0 then
					line(
						rows,
						ns:L("ACCOUNT_WEEKLY_TROVE_NEED_ALTS_FMT"):format(
							#data.troveNeedLabels,
							FormatNamePreview(data.troveNeedLabels)
						),
						COLOR_SOFT
					)
				end
			end
			local sa = data.saCurrent
			if sa and (tonumber(sa.max) or 0) > 0 then
				any = true
				local completed = tonumber(sa.completed) or 0
				local max = tonumber(sa.max) or 3
				local active = tonumber(sa.active) or 0
				local text = ns:L("ACCOUNT_WEEKLY_SA_FMT"):format(completed, max)
				if active > 0 then
					text = text .. ns:L("ACCOUNT_WEEKLY_SA_ACTIVE_SUFFIX"):format(active)
				end
				local saColor = COLOR_SOFT
				if ns.ShouldShowDelveWeeklyUnderlevel and ns.ShouldShowDelveWeeklyUnderlevel("sa", sa) then
					text = ns:L("ACCOUNT_WEEKLY_SA_UNDERLEVEL_FMT"):format(ns.GetDelveCapLevel())
					saColor = COLOR_DIM
				elseif completed >= max or active > 0 then
					saColor = COLOR_GOOD
				end
				line(rows, text, saColor, function()
					if ns.SelectTab then
						ns.SelectTab("account")
					end
				end)
				if data.saIncompleteLabels and #data.saIncompleteLabels > 0 then
					line(
						rows,
						ns:L("ACCOUNT_WEEKLY_SA_ALTS_FMT"):format(
							#data.saIncompleteLabels,
							FormatNamePreview(data.saIncompleteLabels)
						),
						COLOR_SOFT
					)
				end
			end
			if data.keysTotal and data.keysTotal > 0 then
				any = true
				line(rows, ns:L("ACCOUNT_WEEKLY_KEYS_FMT"):format(data.keysTotal, data.altsWithKeys), COLOR_DIM, function()
					if ns.SelectTab then
						ns.SelectTab("account")
					end
				end)
			end
			if #data.shardBelowLabels > 0 then
				any = true
				line(
					rows,
					ns:L("ACCOUNT_WEEKLY_SHARDS_FMT"):format(#data.shardBelowLabels, FormatNamePreview(data.shardBelowLabels)),
					COLOR_SOFT
				)
			end
			if #data.dundunLabels > 0 then
				any = true
				line(
					rows,
					ns:L("ACCOUNT_WEEKLY_DUNDUN_FMT"):format(#data.dundunLabels, FormatNamePreview(data.dundunLabels)),
					COLOR_SOFT
				)
			end
			if #data.staleLabels > 0 then
				any = true
				line(
					rows,
					ns:L("ACCOUNT_WEEKLY_STALE_FMT"):format(#data.staleLabels, FormatNamePreview(data.staleLabels)),
					COLOR_SOFT
				)
			end
			if not any then
				line(rows, ns:L("ACCOUNT_WEEKLY_ALL_CURRENT"), COLOR_GOOD)
			end
		else
			line(rows, ns:L("ACCOUNT_WEEKLY_NO_SNAPSHOTS"), COLOR_DIM)
		end
		navLine(rows, "account", "TAB_ACCOUNT_SNAPSHOT")
	end)

	------------------------------------------------------------------ Rares | Ritual + Void
	addColumns(
		function(rows)
			header(rows, ns:L("HOME_SECTION_RARES"))
			line(rows, ns:L("HOME_RARES_HINT"), COLOR_DIM)
			navLine(rows, "rares", "TAB_RARES")
		end,
		function(rows)
			header(rows, ns:L("HOME_SECTION_RITUAL"))
			local activeSite = ns.GetActiveRitualSite and ns.GetActiveRitualSite() or nil
			if activeSite then
				local zone = ns.RitualSiteZoneName and ns.RitualSiteZoneName(activeSite) or nil
				local label = zone and (activeSite.name .. " — " .. zone) or activeSite.name
				line(rows, ns:L("HOME_RITUAL_ACTIVE_FMT"):format(label), COLOR_SOFT)
			else
				line(rows, ns:L("HOME_RITUAL_UNKNOWN"), COLOR_DIM)
			end
			if ns.IsRitualWeeklyDone and ns.IsRitualWeeklyDone() then
				line(rows, ns:L("HOME_RITUAL_WEEKLY_DONE"), COLOR_GOOD)
			else
				line(rows, ns:L("HOME_RITUAL_WEEKLY_TODO"), COLOR_WARN)
			end
			local renownText = ns.GetRitualRenownText and ns.GetRitualRenownText() or nil
			if renownText and renownText ~= "" then
				line(rows, ns:L("HOME_RITUAL_RENOWN_FMT"):format(renownText), COLOR_DIM)
			end
			navLine(rows, "world", "TAB_WORLD")

			header(rows, ns:L("HOME_SECTION_VOID"))
			local voidZone = ns.GetActiveVoidAssaultZoneName and ns.GetActiveVoidAssaultZoneName() or nil
			if voidZone then
				line(rows, ns:L("HOME_VOID_ACTIVE_FMT"):format(voidZone), COLOR_SOFT)
			else
				line(rows, ns:L("HOME_VOID_UNKNOWN"), COLOR_DIM)
			end
			if ns.IsVoidAssaultWeeklyDone and ns.IsVoidAssaultWeeklyDone() then
				line(rows, ns:L("HOME_VOID_WEEKLY_DONE"), COLOR_GOOD)
			else
				line(rows, ns:L("HOME_VOID_WEEKLY_TODO"), COLOR_WARN)
			end
			navLine(rows, "world", "TAB_WORLD")
		end
	)

	return blocks
end

local function AcquireRow(index)
	local rows = ui.rows
	local row = rows[index]
	if row then
		return row
	end

	row = CreateFrame("Button", nil, ui.child)
	row:SetHeight(LINE_H)

	local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	fs:SetPoint("LEFT", row, "LEFT", 0, 0)
	fs:SetPoint("RIGHT", row, "RIGHT", 0, 0)
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	row.fs = fs

	rows[index] = row
	return row
end

-- Real (red) UIPanel buttons get their own pool — the text rows are plain
-- Buttons without a template, and templates can't be added after creation.
local function AcquireButton(index)
	local btns = ui.btns
	local btn = btns[index]
	if btn then
		return btn
	end
	btn = CreateFrame("Button", nil, ui.child, "UIPanelButtonTemplate")
	btn:SetHeight(BTN_H)
	btns[index] = btn
	return btn
end

local function ApplyRowSpec(row, spec)
	local c = spec.color or COLOR_DIM
	if spec.header then
		row:SetHeight(HEADER_H)
		row.fs:SetFontObject(GameFontNormal)
	else
		row:SetHeight(LINE_H)
		row.fs:SetFontObject(GameFontHighlightSmall)
	end
	row.fs:SetText(spec.text or "")
	row.fs:SetTextColor(c[1], c[2], c[3])

	row._mhClick = spec.onClick
	if spec.onClick then
		row:EnableMouse(true)
		row:SetScript("OnClick", function(self)
			if self._mhClick then
				self._mhClick()
			end
		end)
		row:SetScript("OnEnter", function(self)
			self.fs:SetTextColor(1, 1, 1)
		end)
		row:SetScript("OnLeave", function(self)
			local cc = self._mhColor or COLOR_DIM
			self.fs:SetTextColor(cc[1], cc[2], cc[3])
		end)
		row._mhColor = c
	else
		row:EnableMouse(false)
		row:SetScript("OnClick", nil)
		row:SetScript("OnEnter", nil)
		row:SetScript("OnLeave", nil)
	end
end

local function RowStep(spec)
	return spec.header and HEADER_H or LINE_H
end

local function LayoutColumnRow(row, spec, blockY, colY, column, colWidth)
	local xOff = (column == "right") and (colWidth + COL_GAP) or 0
	local indent = spec.header and 0 or 0
	row:ClearAllPoints()
	row:SetPoint("TOPLEFT", ui.child, "TOPLEFT", xOff + indent, -(blockY + colY))
	row:SetWidth(colWidth - indent)
	ApplyRowSpec(row, spec)
end

local function LayoutFullRow(row, spec, y)
	row:ClearAllPoints()
	local indent = spec.header and 0 or 0
	row:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent, -y)
	row:SetPoint("TOPRIGHT", ui.child, "TOPRIGHT", 0, -y)
	ApplyRowSpec(row, spec)
end

local function LayoutColumnSpecs(specs, blockY, column, colWidth)
	local colY = 0
	local rowIndex = ui._layoutRowIndex
	for i = 1, #specs do
		local spec = specs[i]
		if spec.header and colY > 0 then
			colY = colY + SECTION_GAP
		end
		if spec.button then
			local btn = AcquireButton(ui._layoutBtnIndex)
			ui._layoutBtnIndex = ui._layoutBtnIndex + 1
			local xOff = (column == "right") and (colWidth + COL_GAP) or 0
			colY = colY + 4
			btn:ClearAllPoints()
			btn:SetPoint("TOPLEFT", ui.child, "TOPLEFT", xOff, -(blockY + colY))
			btn:SetText(spec.text or "")
			local tw = (btn.GetTextWidth and btn:GetTextWidth() or 160) + 28
			btn:SetWidth(math.min(math.max(tw, 110), colWidth))
			btn:SetScript("OnClick", spec.onClick)
			btn:Show()
			colY = colY + BTN_H
		else
			local row = AcquireRow(rowIndex)
			LayoutColumnRow(row, spec, blockY, colY, column, colWidth)
			row:Show()
			colY = colY + RowStep(spec)
			rowIndex = rowIndex + 1
		end
	end
	ui._layoutRowIndex = rowIndex
	return colY
end

function ns.RefreshHomePanel()
	if not ui or not ui.child then
		return
	end

	local resetText = GetWeeklyResetText()
	if ui.subtitle then
		ui.subtitle:SetText(resetText or ns:L("HOME_RESET_UNKNOWN"))
	end

	local childW = ui.child:GetWidth() or 400
	local colWidth = math.max(80, math.floor((childW - COL_GAP) / 2))
	local blocks = BuildLayout()
	local y = 0
	local rowIndex = 1
	ui._layoutBtnIndex = 1

	for b = 1, #blocks do
		local block = blocks[b]
		if b > 1 then
			y = y + SECTION_GAP
		end

		if block.type == "full" then
			for i = 1, #block.rows do
				local spec = block.rows[i]
				if spec.header and i > 1 then
					y = y + SECTION_GAP
				end
				if spec.button then
					y = y + 4
					local btn = AcquireButton(ui._layoutBtnIndex)
					ui._layoutBtnIndex = ui._layoutBtnIndex + 1
					btn:ClearAllPoints()
					btn:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
					btn:SetText(spec.text or "")
					local tw = (btn.GetTextWidth and btn:GetTextWidth() or 200) + 28
					btn:SetWidth(math.min(math.max(tw, 120), childW))
					btn:SetScript("OnClick", spec.onClick)
					btn:Show()
					y = y + BTN_H
				else
					local row = AcquireRow(rowIndex)
					LayoutFullRow(row, spec, y)
					row:Show()
					y = y + RowStep(spec)
					rowIndex = rowIndex + 1
				end
			end
		elseif block.type == "columns" then
			ui._layoutRowIndex = rowIndex
			local leftH = LayoutColumnSpecs(block.left or {}, y, "left", colWidth)
			local rightH = LayoutColumnSpecs(block.right or {}, y, "right", colWidth)
			rowIndex = ui._layoutRowIndex
			y = y + math.max(leftH, rightH)
		end
	end

	for i = rowIndex, #ui.rows do
		ui.rows[i]:Hide()
	end
	for i = ui._layoutBtnIndex, #ui.btns do
		ui.btns[i]:Hide()
	end

	ui.child:SetHeight(math.max(y + 8, 1))
end

function ns.BuildHomePanel(panel)
	if not panel or panel._mhHomeBuilt then
		return
	end
	panel._mhHomeBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("HOME_TITLE"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperHomeScroll", panel, "UIPanelScrollFrameTemplate")
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
		rows = {},
		btns = {},
	}

	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
		end
		if panel:IsShown() then
			ns.RefreshHomePanel()
		end
	end
	scroll:SetScript("OnSizeChanged", syncWidth)
	syncWidth()

	panel:SetScript("OnShow", function()
		syncWidth()
		ns.RefreshHomePanel()
	end)

	ns.HomePanel = panel
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("HOME_TITLE"))
		end
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshHomePanel()
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("WEEKLY_REWARDS_UPDATE")
ev:RegisterEvent("QUEST_LOG_UPDATE")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function()
	if ui and ui.panel and ui.panel:IsShown() then
		ns.RefreshHomePanel()
	end
end)
