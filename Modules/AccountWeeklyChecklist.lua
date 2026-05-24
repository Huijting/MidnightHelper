--[[
	Account weekly checklist — summary above Account snapshot (reuses charCurrencies + vault reminder).
]]

local _, ns = ...

local LINE_H = 14
local MAX_NAME_PREVIEW = 2

local panelUi

local function WeeklyFilterSuffix(kind)
	if ns.MhIsAccountSnapshotWeeklyFilterActive and ns:MhIsAccountSnapshotWeeklyFilterActive(kind) then
		return ns:L("ACCOUNT_WEEKLY_FILTER_ACTIVE")
	end
	return ""
end

local function ToggleWeeklyFilter(kind)
	if ns.MhToggleAccountSnapshotWeeklyFilter then
		ns:MhToggleAccountSnapshotWeeklyFilter(kind)
	end
end

local function FormatCharLabel(name, realm)
	local nm = name
	if type(nm) ~= "string" or nm == "" or nm == "?" then
		return ns:L("ALT_OVERVIEW_UNKNOWN")
	end
	local r = realm
	if type(r) ~= "string" then
		r = ""
	end
	return nm .. (r ~= "" and ("-" .. r) or "")
end

local function FormatNamePreview(labels)
	if #labels == 0 then
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

function ns.ComputeAccountWeeklyChecklist()
	local entries = ns._mhAltOverviewCollectEntries and ns:_mhAltOverviewCollectEntries() or {}
	local vaultReady, vaultLikely = {}, {}
	if ns.GetVaultReminderState then
		local state = ns.GetVaultReminderState()
		if type(state) == "table" and type(state.entries) == "table" then
			for i = 1, #state.entries do
				local ent = state.entries[i]
				if ent.kind == "ready" then
					vaultReady[#vaultReady + 1] = ent.label
				elseif ent.kind == "likely" then
					vaultLikely[#vaultLikely + 1] = ent.label
				end
			end
		end
	end

	local staleLabels, shardBelowLabels, dundunLabels = {}, {}, {}
	local keysTotal, altsWithKeys = 0, 0

	for i = 1, #entries do
		local e = entries[i]
		local label = FormatCharLabel(e.name, e.realm)
		if ns.MhAccountEntryIsStale and ns:MhAccountEntryIsStale(e) then
			staleLabels[#staleLabels + 1] = label
		end
		local k = tonumber(e.keys) or 0
		keysTotal = keysTotal + k
		if k > 0 then
			altsWithKeys = altsWithKeys + 1
		end
		if ns.MhAccountEntryShardsBelowCap and ns:MhAccountEntryShardsBelowCap(e) then
			shardBelowLabels[#shardBelowLabels + 1] = label
		end
		if ns.MhAccountEntryDundunIncomplete and ns:MhAccountEntryDundunIncomplete(e) then
			dundunLabels[#dundunLabels + 1] = label
		end
	end

	local smcDone, smcTotal
	local defs = ns.SMC_CHECKLIST_DEF
	if type(defs) == "table" and ns.SMC_IsChecklistEntryTracked and ns.SMC_IsChecklistEntryDone then
		local done, total = 0, 0
		for i = 1, #defs do
			local entry = defs[i]
			if ns.SMC_IsChecklistEntryTracked(entry) then
				total = total + 1
				local ok = ns.SMC_IsChecklistEntryDone(entry)
				if ok == true then
					done = done + 1
				end
			end
		end
		if total > 0 then
			smcDone, smcTotal = done, total
		end
	end

	return {
		charCount = #entries,
		vaultReady = vaultReady,
		vaultLikely = vaultLikely,
		staleLabels = staleLabels,
		keysTotal = keysTotal,
		altsWithKeys = altsWithKeys,
		shardBelowLabels = shardBelowLabels,
		dundunLabels = dundunLabels,
		smcDone = smcDone,
		smcTotal = smcTotal,
	}
end

local function GetCollapsed()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return false
	end
	if type(uiDb.accountSnapshot) ~= "table" then
		uiDb.accountSnapshot = {}
	end
	return uiDb.accountSnapshot.weeklyChecklistCollapsed == true
end

local function SetCollapsed(collapsed)
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return
	end
	if type(uiDb.accountSnapshot) ~= "table" then
		uiDb.accountSnapshot = {}
	end
	uiDb.accountSnapshot.weeklyChecklistCollapsed = collapsed and true or false
end

local function SetLine(line, show, text, r, g, b, onClick)
	if not line or not line.fs then
		return
	end
	if not show then
		line:Hide()
		line.fs:SetText("")
		line._mhClick = nil
		return
	end
	line:Show()
	line.fs:SetText(text or "")
	line.fs:SetTextColor(r or 0.9, g or 0.9, b or 0.9)
	line._mhClick = onClick
	if line.hit then
		if onClick then
			line.hit:EnableMouse(true)
			line.hit:SetScript("OnEnter", function(self)
				if not GameTooltip then
					return
				end
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(ns:L("ACCOUNT_WEEKLY_CLICK_FILTER"), 1, 0.92, 0.55, 1, true)
				GameTooltip:Show()
			end)
			line.hit:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end)
		else
			line.hit:EnableMouse(false)
			line.hit:SetScript("OnEnter", nil)
			line.hit:SetScript("OnLeave", nil)
		end
	end
end

function ns.RefreshAccountWeeklyChecklist()
	if not panelUi or not panelUi.host or not panelUi.host:IsShown() then
		if panelUi and panelUi.block then
			ns.RefreshAccountWeeklyChecklistLayout()
		end
		return
	end

	local data = ns.ComputeAccountWeeklyChecklist()
	local collapsed = GetCollapsed()
	local lines = panelUi.lines or {}
	local idx = 0

	local function nextLine(show, text, r, g, b, onClick)
		idx = idx + 1
		SetLine(lines[idx], show and not collapsed, text, r, g, b, onClick)
	end

	if data.charCount == 0 then
		nextLine(true, ns:L("ACCOUNT_WEEKLY_NO_SNAPSHOTS"), 0.75, 0.78, 0.85)
	else
		if ns.MhAccountSnapshotAnyTableFilterActive and ns.MhAccountSnapshotAnyTableFilterActive() then
			nextLine(
				true,
				ns:L("ACCOUNT_WEEKLY_SHOW_ALL_FMT"):format(data.charCount),
				1,
				0.92,
				0.55,
				function()
					if ns.MhClearAccountSnapshotTableFilters then
						ns.MhClearAccountSnapshotTableFilters()
					end
				end
			)
		end

		if #data.vaultReady > 0 then
			nextLine(
				true,
				ns:L("ACCOUNT_WEEKLY_VAULT_READY_FMT"):format(#data.vaultReady, FormatNamePreview(data.vaultReady)),
				1,
				0.84,
				0.18
			)
		else
			nextLine(true, ns:L("ACCOUNT_WEEKLY_VAULT_NONE"), 0.45, 0.95, 0.5)
		end

		if #data.vaultLikely > 0 then
			nextLine(
				true,
				ns:L("ACCOUNT_WEEKLY_VAULT_LIKELY_FMT"):format(#data.vaultLikely, FormatNamePreview(data.vaultLikely)),
				1,
				0.72,
				0.22
			)
		end

		if #data.staleLabels > 0 then
			nextLine(
				true,
				ns:L("ACCOUNT_WEEKLY_STALE_FMT"):format(#data.staleLabels, FormatNamePreview(data.staleLabels))
					.. WeeklyFilterSuffix("stale"),
				1,
				0.82,
				0.35,
				function()
					ToggleWeeklyFilter("stale")
				end
			)
		else
			nextLine(true, ns:L("ACCOUNT_WEEKLY_ALL_CURRENT"), 0.45, 0.95, 0.5)
		end

		if data.keysTotal > 0 then
			nextLine(
				true,
				ns:L("ACCOUNT_WEEKLY_KEYS_FMT"):format(data.keysTotal, data.altsWithKeys) .. WeeklyFilterSuffix("keys"),
				0.9,
				0.9,
				0.95,
				function()
					ToggleWeeklyFilter("keys")
				end
			)
		end

		if #data.shardBelowLabels > 0 then
			nextLine(
				true,
				ns:L("ACCOUNT_WEEKLY_SHARDS_FMT"):format(#data.shardBelowLabels, FormatNamePreview(data.shardBelowLabels))
					.. WeeklyFilterSuffix("shards"),
				0.9,
				0.82,
				0.45,
				function()
					ToggleWeeklyFilter("shards")
				end
			)
		end

		if #data.dundunLabels > 0 then
			nextLine(
				true,
				ns:L("ACCOUNT_WEEKLY_DUNDUN_FMT"):format(#data.dundunLabels, FormatNamePreview(data.dundunLabels))
					.. WeeklyFilterSuffix("dundun"),
				0.85,
				0.75,
				0.95,
				function()
					ToggleWeeklyFilter("dundun")
				end
			)
		end

		if data.smcTotal then
			local done = data.smcDone or 0
			local total = data.smcTotal
			if done >= total then
				nextLine(true, ns:L("ACCOUNT_WEEKLY_SMC_DONE_FMT"):format(done, total), 0.45, 0.95, 0.5)
			else
				nextLine(
					true,
					ns:L("ACCOUNT_WEEKLY_SMC_FMT"):format(done, total),
					0.9,
					0.82,
					0.45
				)
			end
		end
	end

	for i = idx + 1, #(panelUi.lines or {}) do
		SetLine(lines[i], false)
	end

	if panelUi.collapseBtn then
		panelUi.collapseBtn:SetText(collapsed and "+" or "−")
	end
	ns.RefreshAccountWeeklyChecklistLayout()
end

function ns.RefreshAccountWeeklyChecklistLayout()
	if not panelUi or not panelUi.block then
		return
	end
	local collapsed = GetCollapsed()
	local visibleLines = 0
	for _, line in ipairs(panelUi.lines or {}) do
		if line:IsShown() then
			visibleLines = visibleLines + 1
		end
	end
	local titleH = 18
	local bodyH = collapsed and 0 or math.max(visibleLines * LINE_H, 0)
	local totalH = titleH + bodyH + 4
	panelUi.block:SetHeight(totalH)
	if panelUi._mhOnHeightChanged then
		panelUi._mhOnHeightChanged()
	end
end

function ns.MountAccountWeeklyChecklist(host, anchorBelow, onLayoutChanged)
	if panelUi and panelUi.host == host then
		panelUi._mhOnHeightChanged = onLayoutChanged
		ns.RefreshAccountWeeklyChecklist()
		return panelUi.block
	end

	panelUi = {}
	panelUi.host = host
	panelUi._mhOnHeightChanged = onLayoutChanged

	local block = CreateFrame("Frame", nil, host)
	block:SetPoint("TOPLEFT", anchorBelow, "BOTTOMLEFT", 0, -6)
	block:SetPoint("TOPRIGHT", anchorBelow, "BOTTOMRIGHT", 0, -6)
	block:SetHeight(80)
	panelUi.block = block

	local titleRow = CreateFrame("Frame", nil, block)
	titleRow:SetHeight(18)
	titleRow:SetPoint("TOPLEFT", block, "TOPLEFT", 0, 0)
	titleRow:SetPoint("TOPRIGHT", block, "TOPRIGHT", 0, 0)

	local collapseBtn = CreateFrame("Button", nil, titleRow)
	collapseBtn:SetSize(18, 18)
	collapseBtn:SetPoint("LEFT", titleRow, "LEFT", 0, 0)
	collapseBtn:SetNormalFontObject(GameFontNormal)
	collapseBtn:SetText("−")
	collapseBtn:SetScript("OnClick", function()
		SetCollapsed(not GetCollapsed())
		ns.RefreshAccountWeeklyChecklist()
	end)
	panelUi.collapseBtn = collapseBtn

	local titleFs = titleRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleFs:SetPoint("LEFT", collapseBtn, "RIGHT", 2, 0)
	titleFs:SetPoint("RIGHT", titleRow, "RIGHT", -4, 0)
	titleFs:SetJustifyH("LEFT")
	titleFs:SetText(ns:L("ACCOUNT_WEEKLY_TITLE"))
	panelUi.titleFs = titleFs

	panelUi.lines = {}
	for i = 1, 8 do
		local line = CreateFrame("Frame", nil, block)
		line:SetHeight(LINE_H)
		line:SetPoint("TOPLEFT", block, "TOPLEFT", 4, -(18 + (i - 1) * LINE_H))
		line:SetPoint("TOPRIGHT", block, "TOPRIGHT", -4, -(18 + (i - 1) * LINE_H))
		local hit = CreateFrame("Button", nil, line)
		hit:SetAllPoints(line)
		hit:SetScript("OnClick", function()
			if line._mhClick then
				line._mhClick()
			end
		end)
		local fs = line:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetPoint("LEFT", line, "LEFT", 0, 0)
		fs:SetPoint("RIGHT", line, "RIGHT", 0, 0)
		fs:SetJustifyH("LEFT")
		line.fs = fs
		line.hit = hit
		panelUi.lines[i] = line
	end

	if not ns._mhWeeklyChecklistLocaleHooked then
		ns._mhWeeklyChecklistLocaleHooked = true
		local orig = ns.RefreshLocaleUI
		function ns:RefreshLocaleUI()
			if orig then
				orig(self)
			end
			if panelUi and panelUi.titleFs then
				panelUi.titleFs:SetText(ns:L("ACCOUNT_WEEKLY_TITLE"))
			end
			ns.RefreshAccountWeeklyChecklist()
		end
	end

	ns.RefreshAccountWeeklyChecklist()
	return block
end
