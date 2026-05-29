--[[
	Home dashboard — the "This Week" landing page (first tab in the THIS WEEK
	sidebar section). It is a read-only overview that reuses existing weekly
	aggregates (account weekly checklist, vault reminder, world boss) and offers
	one-click navigation into the detailed tabs. No new game data is computed
	here; every source call is guarded so the panel degrades gracefully when a
	module is missing.
]]

local _, ns = ...

local SECTION_GAP = 8
local HEADER_H = 18
local LINE_H = 15
local TOP_PAD = 12
local SIDE_PAD = 14
local MAX_NAME_PREVIEW = 2

local COLOR_HEADER = { 0.82, 0.68, 0.30 }
local COLOR_DIM = { 0.72, 0.75, 0.82 }
local COLOR_GOOD = { 0.45, 0.95, 0.5 }
local COLOR_WARN = { 1, 0.84, 0.18 }
local COLOR_SOFT = { 0.9, 0.82, 0.45 }
local COLOR_LINK = { 0.55, 0.78, 1 }

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

-- Build the flat list of row descriptors for the current state. Each row is a
-- table: { header=bool, text=string, color={r,g,b}, onClick=fn|nil }.
local function BuildRows()
	local rows = {}

	local function header(text)
		rows[#rows + 1] = { header = true, text = text, color = COLOR_HEADER }
	end
	local function line(text, color, onClick)
		rows[#rows + 1] = { text = text, color = color or COLOR_DIM, onClick = onClick }
	end
	local function navLine(tabId, labelKey)
		line(ns:L("HOME_OPEN_FMT"):format(ns:L(labelKey)), COLOR_LINK, function()
			if ns.SelectTab then
				ns.SelectTab(tabId)
			end
		end)
	end

	local data = ns.ComputeAccountWeeklyChecklist and ns.ComputeAccountWeeklyChecklist() or nil

	------------------------------------------------------------------ Great Vault
	header(ns:L("HOME_SECTION_VAULT"))
	if data and data.charCount and data.charCount > 0 then
		if #data.vaultReady > 0 then
			line(
				ns:L("ACCOUNT_WEEKLY_VAULT_READY_FMT"):format(#data.vaultReady, FormatNamePreview(data.vaultReady)),
				COLOR_WARN
			)
		else
			line(ns:L("ACCOUNT_WEEKLY_VAULT_NONE"), COLOR_GOOD)
		end
		if #data.vaultLikely > 0 then
			line(
				ns:L("ACCOUNT_WEEKLY_VAULT_LIKELY_FMT"):format(#data.vaultLikely, FormatNamePreview(data.vaultLikely)),
				COLOR_SOFT
			)
		end
	else
		line(ns:L("ACCOUNT_WEEKLY_NO_SNAPSHOTS"), COLOR_DIM)
	end
	navLine("delves", "TAB_DELVES")

	------------------------------------------------------------------ World Boss
	header(ns:L("HOME_SECTION_WORLDBOSS"))
	if ns.GetActiveWorldBoss then
		local boss = ns.GetActiveWorldBoss()
		if boss then
			local name = boss.labelKey and ns:L(boss.labelKey) or boss.name or "?"
			line(ns:L("HOME_WB_ACTIVE_FMT"):format(name), COLOR_DIM)
			local warbandDone = ns.IsWorldBossKilled and ns.IsWorldBossKilled(boss)
			if warbandDone then
				local who = ns.GetWorldBossWarbandCompleter and ns.GetWorldBossWarbandCompleter()
				if type(who) == "string" and who ~= "" then
					line(ns:L("HOME_WB_WARBAND_DONE_BY_FMT"):format(who), COLOR_GOOD)
				else
					line(ns:L("HOME_WB_WARBAND_DONE"), COLOR_GOOD)
				end
			else
				line(ns:L("HOME_WB_WARBAND_TODO"), COLOR_WARN)
			end
			if ns.IsWorldBossDoneOnThisCharacter and ns.IsWorldBossDoneOnThisCharacter(boss) then
				line(ns:L("HOME_WB_CHAR_DONE"), COLOR_GOOD)
			else
				line(ns:L("HOME_WB_CHAR_TODO"), COLOR_SOFT)
			end
		else
			line(ns:L("HOME_WB_UNKNOWN"), COLOR_DIM)
		end
	else
		line(ns:L("HOME_WB_UNKNOWN"), COLOR_DIM)
	end

	------------------------------------------------------------------ Weekly chores
	header(ns:L("HOME_SECTION_CHORES"))
	if data and data.charCount and data.charCount > 0 then
		local any = false
		if data.smcTotal then
			any = true
			local done = data.smcDone or 0
			if done >= data.smcTotal then
				line(ns:L("ACCOUNT_WEEKLY_SMC_DONE_FMT"):format(done, data.smcTotal), COLOR_GOOD)
			else
				line(ns:L("ACCOUNT_WEEKLY_SMC_FMT"):format(done, data.smcTotal), COLOR_SOFT)
			end
		end
		if data.keysTotal and data.keysTotal > 0 then
			any = true
			line(ns:L("ACCOUNT_WEEKLY_KEYS_FMT"):format(data.keysTotal, data.altsWithKeys), COLOR_DIM, function()
				if ns.SelectTab then
					ns.SelectTab("account")
				end
			end)
		end
		if #data.shardBelowLabels > 0 then
			any = true
			line(
				ns:L("ACCOUNT_WEEKLY_SHARDS_FMT"):format(#data.shardBelowLabels, FormatNamePreview(data.shardBelowLabels)),
				COLOR_SOFT
			)
		end
		if #data.dundunLabels > 0 then
			any = true
			line(
				ns:L("ACCOUNT_WEEKLY_DUNDUN_FMT"):format(#data.dundunLabels, FormatNamePreview(data.dundunLabels)),
				COLOR_SOFT
			)
		end
		if #data.staleLabels > 0 then
			any = true
			line(
				ns:L("ACCOUNT_WEEKLY_STALE_FMT"):format(#data.staleLabels, FormatNamePreview(data.staleLabels)),
				COLOR_SOFT
			)
		end
		if not any then
			line(ns:L("ACCOUNT_WEEKLY_ALL_CURRENT"), COLOR_GOOD)
		end
	else
		line(ns:L("ACCOUNT_WEEKLY_NO_SNAPSHOTS"), COLOR_DIM)
	end
	navLine("account", "TAB_ACCOUNT_SNAPSHOT")

	------------------------------------------------------------------ Rares
	header(ns:L("HOME_SECTION_RARES"))
	line(ns:L("HOME_RARES_HINT"), COLOR_DIM)
	navLine("rares", "TAB_RARES")

	------------------------------------------------------------------ Ritual Sites
	header(ns:L("HOME_SECTION_RITUAL"))
	local activeSite = ns.GetActiveRitualSite and ns.GetActiveRitualSite() or nil
	if activeSite then
		local zone = ns.RitualSiteZoneName and ns.RitualSiteZoneName(activeSite) or nil
		local label = zone and (activeSite.name .. " — " .. zone) or activeSite.name
		line(ns:L("HOME_RITUAL_ACTIVE_FMT"):format(label), COLOR_SOFT)
	else
		line(ns:L("HOME_RITUAL_UNKNOWN"), COLOR_DIM)
	end
	if ns.IsRitualWeeklyDone and ns.IsRitualWeeklyDone() then
		line(ns:L("HOME_RITUAL_WEEKLY_DONE"), COLOR_GOOD)
	else
		line(ns:L("HOME_RITUAL_WEEKLY_TODO"), COLOR_WARN)
	end
	local renownText = ns.GetRitualRenownText and ns.GetRitualRenownText() or nil
	if renownText and renownText ~= "" then
		line(ns:L("HOME_RITUAL_RENOWN_FMT"):format(renownText), COLOR_DIM)
	end
	navLine("world", "TAB_WORLD")

	------------------------------------------------------------------ Void Assaults
	header(ns:L("HOME_SECTION_VOID"))
	local voidZone = ns.GetActiveVoidAssaultZoneName and ns.GetActiveVoidAssaultZoneName() or nil
	if voidZone then
		line(ns:L("HOME_VOID_ACTIVE_FMT"):format(voidZone), COLOR_SOFT)
	else
		line(ns:L("HOME_VOID_UNKNOWN"), COLOR_DIM)
	end
	if ns.IsVoidAssaultWeeklyDone and ns.IsVoidAssaultWeeklyDone() then
		line(ns:L("HOME_VOID_WEEKLY_DONE"), COLOR_GOOD)
	else
		line(ns:L("HOME_VOID_WEEKLY_TODO"), COLOR_WARN)
	end
	navLine("world", "TAB_WORLD")

	return rows
end

local function AcquireRow(index)
	local rows = ui.rows
	local row = rows[index]
	if row then
		return row
	end

	row = CreateFrame("Button", nil, ui.child)
	row:SetHeight(LINE_H)
	if index == 1 then
		row:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, 0)
		row:SetPoint("TOPRIGHT", ui.child, "TOPRIGHT", 0, 0)
	else
		row:SetPoint("TOPLEFT", rows[index - 1], "BOTTOMLEFT", 0, 0)
		row:SetPoint("TOPRIGHT", rows[index - 1], "BOTTOMRIGHT", 0, 0)
	end

	local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	fs:SetPoint("LEFT", row, "LEFT", 0, 0)
	fs:SetPoint("RIGHT", row, "RIGHT", 0, 0)
	fs:SetJustifyH("LEFT")
	row.fs = fs

	rows[index] = row
	return row
end

function ns.RefreshHomePanel()
	if not ui or not ui.child then
		return
	end

	local resetText = GetWeeklyResetText()
	if ui.subtitle then
		ui.subtitle:SetText(resetText or ns:L("HOME_RESET_UNKNOWN"))
	end

	local rows = BuildRows()
	local y = 0
	for i = 1, #rows do
		local spec = rows[i]
		local row = AcquireRow(i)

		if spec.header then
			if i > 1 then
				y = y + SECTION_GAP
			end
			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
			row:SetPoint("TOPRIGHT", ui.child, "TOPRIGHT", 0, -y)
			row:SetHeight(HEADER_H)
			row.fs:SetFontObject(GameFontNormal)
			row.fs:SetText(spec.text)
			y = y + HEADER_H
		else
			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 10, -y)
			row:SetPoint("TOPRIGHT", ui.child, "TOPRIGHT", 0, -y)
			row:SetHeight(LINE_H)
			row.fs:SetFontObject(GameFontHighlightSmall)
			row.fs:SetText(spec.text)
			y = y + LINE_H
		end

		local c = spec.color or COLOR_DIM
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

		row:Show()
	end

	for i = #rows + 1, #ui.rows do
		ui.rows[i]:Hide()
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
	}

	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
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
