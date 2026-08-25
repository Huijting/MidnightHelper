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

local function GetDelverCapLevel()
	if ns.GetDelveCapLevel then
		return ns.GetDelveCapLevel()
	end
	return 80
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

-- Ritual Site Studies weekly (Lady Darkglen, "Week X of 3"). Wk1 = 96728, wk2 = 96729
-- — beide in-game bevestigd (Rob /mh questscan, 24 jun; zie docs/PTR_12.0.7_DATA.md).
-- Wk3 vermoedelijk 96730 (PATROON) maar nog NIET bevestigd → niet toevoegen (never-lie),
-- bij reset scannen. We checken alle bekende weken; de huidige week matcht op done/onQuest.
-- (NB: de "Seeking Knowledge"-serie 96441 is iets ánders — die unlockt de Omnium Folio,
-- zie OmniumFolioData.lua, en hoort niet in deze ritual-weekly.) Toont de huidige character.
local RITUAL_WEEKLY_QUESTS = { 96728, 96729 }

local function RitualWeeklyState()
	if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return nil
	end
	local done, onQuest = false, false
	for i = 1, #RITUAL_WEEKLY_QUESTS do
		local q = RITUAL_WEEKLY_QUESTS[i]
		local okC, c = pcall(C_QuestLog.IsQuestFlaggedCompleted, q)
		if okC and c then
			done = true
		end
		if C_QuestLog.IsOnQuest then
			local okO, o = pcall(C_QuestLog.IsOnQuest, q)
			if okO and o then
				onQuest = true
			end
		end
	end
	local level = (UnitLevel and UnitLevel("player")) or 0
	local available = done or onQuest or level >= GetDelverCapLevel()
	return { available = available, done = done, onQuest = onQuest }
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
	--- 🔴 CATALYST CHARGES BELONG HERE, NOT ONLY IN A ROW TOOLTIP.
	---
	--- Added 25 aug 2026 the same evening the tooltip version shipped. Rob asked to
	--- track Manaflux per character, I put it in the row tooltip, and his next message
	--- was "waar vind ik de manaflux precies, ik zie het hier niet". He was reading the
	--- table, where Keys and Shards live. A number you have to go hunting for is not a
	--- tracker.
	---
	--- This block already answers exactly his question for other resources ("Restored
	--- Coffer Keys on account: 18"), so the charges go in beside them. The cap line is
	--- the one that actually needs acting on: a character at 8 has stopped gaining, and
	--- that happens to the alts nobody logs into.
	local fluxTotal, fluxChars, fluxCappedLabels = 0, 0, {}
	local MANAFLUX_CAP = 8

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
		-- nil means "captured before we tracked this", not zero. Such a character is
		-- left out of both the total and the count rather than counted as empty.
		local flux = tonumber(e.manaflux)
		if flux then
			fluxTotal = fluxTotal + flux
			if flux > 0 then
				fluxChars = fluxChars + 1
			end
			if flux >= MANAFLUX_CAP then
				fluxCappedLabels[#fluxCappedLabels + 1] = label
			end
		end
		if ns.MhAccountEntryShardsBelowCap and ns:MhAccountEntryShardsBelowCap(e) then
			shardBelowLabels[#shardBelowLabels + 1] = label
		end
		if ns.MhAccountEntryDundunIncomplete and ns:MhAccountEntryDundunIncomplete(e) then
			dundunLabels[#dundunLabels + 1] = label
		end
	end

	-- Delver's Call weekly rollup. Current character uses the live state;
	-- other characters use their last saved snapshot (skipped when stale).
	local delverCurrent
	if ns.GetDelverCallState then
		delverCurrent = ns.GetDelverCallState()
	end
	local curGuid = UnitGUID and UnitGUID("player") or nil
	local delverCapLevel = GetDelverCapLevel()
	local delverIncompleteLabels, delverBankedLabels = {}, {}
	local delverBankedTotal = 0
	for i = 1, #entries do
		local e = entries[i]
		local total = tonumber(e.delverTotal) or 0
		local isCurrent = curGuid ~= nil and e.guid == curGuid
		if isCurrent and delverCurrent then
			total = delverCurrent.total
		end
		if total > 0 then
			local completed = tonumber(e.delverCompleted) or 0
			local banked = tonumber(e.delverBanked) or 0
			local level = tonumber(e.level) or 0
			local stale = ns.MhAccountEntryIsStale and ns:MhAccountEntryIsStale(e)
			if isCurrent and delverCurrent then
				completed = delverCurrent.completed
				banked = delverCurrent.banked
				stale = false
			end
			-- Rollup lines describe OTHER characters; the current one already
			-- has its own dedicated line.
			if not stale and not isCurrent then
				local label = FormatCharLabel(e.name, e.realm)
				-- Only max-level alts count as a real chore. Leveling alts that
				-- hold quests show up under the banked line instead.
				if completed < total and level >= delverCapLevel then
					delverIncompleteLabels[#delverIncompleteLabels + 1] = label
				end
				if banked > 0 then
					delverBankedTotal = delverBankedTotal + banked
					delverBankedLabels[#delverBankedLabels + 1] = ("%s (%d)"):format(label, banked)
				end
			end
		end
	end

	local troveCurrent = ns.GetTrovehunterState and ns.GetTrovehunterState() or nil
	local gildedCurrent = ns.GetGildedStashState and ns.GetGildedStashState() or nil
	local saCurrent = ns.GetSpecialAssignmentState and ns.GetSpecialAssignmentState() or nil
	local troveNeedLabels, troveUnusedLabels = {}, {}
	local gildedIncompleteLabels = {}
	local saIncompleteLabels = {}
	for i = 1, #entries do
		local e = entries[i]
		local level = tonumber(e.level) or 0
		local isCurrent = curGuid ~= nil and e.guid == curGuid
		local stale = ns.MhAccountEntryIsStale and ns:MhAccountEntryIsStale(e)
		if isCurrent then
			stale = false
		end
		if not stale and not isCurrent and level >= delverCapLevel then
			local label = FormatCharLabel(e.name, e.realm)
			local troveStatus = type(e.troveStatus) == "string" and e.troveStatus or "available"
			local troveInBag = tonumber(e.troveInBag) or 0
			if troveStatus == "available" then
				troveNeedLabels[#troveNeedLabels + 1] = label
			elseif troveStatus == "looted" and troveInBag > 0 then
				troveUnusedLabels[#troveUnusedLabels + 1] = label
			end
			local gProg = tonumber(e.gildedProgress) or 0
			local gMax = tonumber(e.gildedMax) or 4
			if gProg < gMax then
				gildedIncompleteLabels[#gildedIncompleteLabels + 1] = ("%s (%d/%d)"):format(label, gProg, gMax)
			end
			local saDone = tonumber(e.saCompleted) or 0
			local saMax = tonumber(e.saMax) or 3
			if saDone < saMax then
				saIncompleteLabels[#saIncompleteLabels + 1] = label
			end
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
		fluxTotal = fluxTotal,
		fluxChars = fluxChars,
		fluxCapped = fluxCappedLabels,
		shardBelowLabels = shardBelowLabels,
		dundunLabels = dundunLabels,
		smcDone = smcDone,
		smcTotal = smcTotal,
		delverCurrent = delverCurrent,
		delverIncompleteLabels = delverIncompleteLabels,
		delverBankedLabels = delverBankedLabels,
		delverBankedTotal = delverBankedTotal,
		troveCurrent = troveCurrent,
		troveNeedLabels = troveNeedLabels,
		troveUnusedLabels = troveUnusedLabels,
		gildedCurrent = gildedCurrent,
		gildedIncompleteLabels = gildedIncompleteLabels,
		saCurrent = saCurrent,
		saIncompleteLabels = saIncompleteLabels,
		folioWeekly = ns.GetOmniumFolioWeeklyStatus and ns.GetOmniumFolioWeeklyStatus() or nil,
		ritualWeekly = RitualWeeklyState(),
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

local function SetLine(line, show, text, r, g, b, onClick, tooltipFn)
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
		if tooltipFn then
			line.hit:EnableMouse(true)
			line.hit:SetScript("OnEnter", function(self)
				if not GameTooltip then
					return
				end
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				tooltipFn(self)
				GameTooltip:Show()
			end)
			line.hit:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end)
		elseif onClick then
			line.hit:EnableMouse(true)
			line.hit:SetScript("OnEnter", function(self)
				if not GameTooltip then
					return
				end
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
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

	local function DelverStateInfo(state)
		if state == "completed" then
			return ns:L("DELVER_STATE_COMPLETED"), 0.45, 0.95, 0.5
		elseif state == "ready" then
			return ns:L("DELVER_STATE_READY"), 1, 0.84, 0.18
		elseif state == "inProgress" then
			return ns:L("DELVER_STATE_INPROGRESS"), 1, 0.55, 0.15
		end
		return ns:L("DELVER_STATE_FRESH"), 0.6, 0.6, 0.6
	end

	local function BuildDelverTooltip()
		local dc = data.delverCurrent
		if not dc then
			return
		end
		GameTooltip:ClearLines()
		GameTooltip:AddLine(ns:L("DELVER_TOOLTIP_TITLE"), 1, 0.9, 0.5)
		GameTooltip:AddLine(
			ns:L("ACCOUNT_WEEKLY_DELVER_FMT"):format(dc.completed or 0, dc.total or 0),
			0.85,
			0.85,
			0.85
		)
		GameTooltip:AddLine(" ")
		local lastZone
		for _, q in ipairs(dc.quests or {}) do
			if q.zone ~= lastZone then
				lastZone = q.zone
				GameTooltip:AddLine(q.zone, 1, 0.82, 0.3)
			end
			local stateText, sr, sg, sb = DelverStateInfo(q.state)
			GameTooltip:AddDoubleLine("  " .. tostring(q.delve), stateText, 0.92, 0.92, 0.92, sr, sg, sb)
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(ns:L("DELVER_TOOLTIP_HINT"), 0.7, 0.85, 0.7, true)
	end

	local function BuildUnderlevelTooltip()
		GameTooltip:ClearLines()
		GameTooltip:AddLine(
			ns:L("DELVE_WEEKLY_UNDERLEVEL_HINT"):format(GetDelverCapLevel()),
			0.75,
			0.78,
			0.85,
			true
		)
	end

	local function BuildGildedTooltip()
		local gs = data.gildedCurrent
		if not gs then
			return
		end
		GameTooltip:ClearLines()
		GameTooltip:AddLine(ns:L("GILDED_TOOLTIP_TITLE"), 1, 0.9, 0.5)
		if ns.ShouldShowDelveWeeklyUnderlevel and ns.ShouldShowDelveWeeklyUnderlevel("gilded", gs) then
			GameTooltip:AddLine(
				ns:L("ACCOUNT_WEEKLY_GILDED_UNDERLEVEL_FMT"):format(GetDelverCapLevel()),
				0.6,
				0.6,
				0.6
			)
		else
			GameTooltip:AddLine(
				ns:L("ACCOUNT_WEEKLY_GILDED_FMT"):format(gs.progress or 0, gs.max or 4),
				0.85,
				0.85,
				0.85
			)
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(ns:L("GILDED_TOOLTIP_HINT"), 0.7, 0.85, 0.7, true)
	end

	local function SaStateInfo(state)
		if state == "completed" then
			return ns:L("SA_STATE_COMPLETED"), 0.45, 0.95, 0.5
		elseif state == "active" then
			return ns:L("SA_STATE_ACTIVE"), 0.45, 0.95, 0.5
		elseif state == "available" then
			return ns:L("SA_STATE_AVAILABLE"), 0.9, 0.85, 0.55
		end
		return ns:L("SA_STATE_LOCKED"), 0.6, 0.6, 0.6
	end

	local function BuildSpecialAssignmentTooltip()
		local sa = data.saCurrent
		if not sa then
			return
		end
		GameTooltip:ClearLines()
		GameTooltip:AddLine(ns:L("SA_TOOLTIP_TITLE"), 1, 0.9, 0.5)
		GameTooltip:AddLine(
			ns:L("ACCOUNT_WEEKLY_SA_FMT"):format(sa.completed or 0, sa.max or 3),
			0.85,
			0.85,
			0.85
		)
		GameTooltip:AddLine(" ")
		for _, a in ipairs(sa.assignments or {}) do
			local stateText, sr, sg, sb = SaStateInfo(a.state)
			GameTooltip:AddDoubleLine("  " .. tostring(a.title), stateText, 0.92, 0.92, 0.92, sr, sg, sb)
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(ns:L("SA_TOOLTIP_HINT"), 0.7, 0.85, 0.7, true)
	end

	local function nextLine(show, text, r, g, b, onClick, tooltipFn)
		idx = idx + 1
		SetLine(lines[idx], show and not collapsed, text, r, g, b, onClick, tooltipFn)
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

		-- Omnium Folio weekly (account-breed, "doe-dit-eerst"): alleen tonen zolang
		-- deze week's Mote nog open is en je niet op 5/5 zit.
		if data.folioWeekly and data.folioWeekly.pending then
			nextLine(
				true,
				ns:L("ACCOUNT_WEEKLY_FOLIO_FMT"):format(data.folioWeekly.unlocked or 0),
				1,
				0.82,
				0.30,
				nil,
				function()
					if not GameTooltip then
						return
					end
					GameTooltip:ClearLines()
					GameTooltip:AddLine(ns:L("ACCOUNT_WEEKLY_FOLIO_TT_TITLE"), 1, 0.9, 0.5)
					-- Wat moet je deze week doen (objective van de huidige rij)?
					if data.folioWeekly.objectiveKey then
						GameTooltip:AddLine(ns:L(data.folioWeekly.objectiveKey), 1, 0.82, 0.35, true)
					end
					GameTooltip:AddLine(ns:L("ACCOUNT_WEEKLY_FOLIO_TT_BODY"), 0.82, 0.85, 0.9, true)
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

		-- Catalyst charges: where they are, and where they have stopped growing.
		if (data.fluxTotal or 0) > 0 then
			nextLine(
				true,
				ns:L("ACCOUNT_WEEKLY_FLUX_FMT"):format(data.fluxTotal, data.fluxChars),
				0.9,
				0.9,
				0.95
			)
		end
		if data.fluxCapped and #data.fluxCapped > 0 then
			nextLine(
				true,
				ns:L("ACCOUNT_WEEKLY_FLUX_CAPPED_FMT")
					:format(#data.fluxCapped, FormatNamePreview(data.fluxCapped)),
				1,
				0.82,
				0.35
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

		-- 12.0.7 Showdowns: current character's weekly. Build-gated inside
		-- IsShowdownsAvailable; zones with unknown weekly IDs never match
		-- (Showdowns.lua, never lie) — then no line shows at all.
		if ns.IsShowdownsAvailable and ns.IsShowdownsAvailable() and ns.GetActiveShowdownZone then
			local zone = ns.GetActiveShowdownZone()
			if zone then
				local zoneName = (ns.GetActiveShowdownZoneName and ns.GetActiveShowdownZoneName()) or "?"
				if ns.IsShowdownWeeklyDone and ns.IsShowdownWeeklyDone() then
					nextLine(true, ns:L("ACCOUNT_WEEKLY_SHOWDOWN_DONE_FMT"):format(zoneName), 0.45, 0.95, 0.5)
				else
					nextLine(true, ns:L("ACCOUNT_WEEKLY_SHOWDOWN_OPEN_FMT"):format(zoneName), 1, 0.82, 0.35)
				end
			end
		end

		local rw = data.ritualWeekly
		if rw and rw.available then
			if rw.done then
				nextLine(true, ns:L("ACCOUNT_WEEKLY_RITUAL_DONE"), 0.45, 0.95, 0.5)
			else
				nextLine(true, ns:L("ACCOUNT_WEEKLY_RITUAL_OPEN"), 1, 0.82, 0.35)
			end
		end

		local dc = data.delverCurrent
		if dc and (tonumber(dc.total) or 0) > 0 then
			local completed = tonumber(dc.completed) or 0
			local total = tonumber(dc.total) or 0
			local banked = tonumber(dc.banked) or 0
			local text = ns:L("ACCOUNT_WEEKLY_DELVER_FMT"):format(completed, total)
			if banked > 0 then
				text = text .. ns:L("ACCOUNT_WEEKLY_DELVER_BANKED_SUFFIX"):format(banked)
			end
			local r, g, b
			if completed >= total then
				r, g, b = 0.45, 0.95, 0.5
			elseif banked > 0 then
				r, g, b = 1, 0.84, 0.18
			else
				r, g, b = 0.9, 0.85, 0.55
			end
			nextLine(true, text, r, g, b, nil, BuildDelverTooltip)

			if data.delverBankedTotal and data.delverBankedTotal > 0 then
				nextLine(
					true,
					ns:L("ACCOUNT_WEEKLY_DELVER_BANKED_ALTS_FMT"):format(
						data.delverBankedTotal,
						FormatNamePreview(data.delverBankedLabels)
					),
					1,
					0.84,
					0.18
				)
			end

			if data.delverIncompleteLabels and #data.delverIncompleteLabels > 0 then
				nextLine(
					true,
					ns:L("ACCOUNT_WEEKLY_DELVER_ALTS_FMT"):format(
						#data.delverIncompleteLabels,
						FormatNamePreview(data.delverIncompleteLabels)
					),
					0.9,
					0.82,
					0.45
				)
			end
		end

		local gs = data.gildedCurrent
		if gs and (tonumber(gs.max) or 0) > 0 then
			local progress = tonumber(gs.progress) or 0
			local max = tonumber(gs.max) or 4
			local text = ns:L("ACCOUNT_WEEKLY_GILDED_FMT"):format(progress, max)
			local gr, gg, gb
			if ns.ShouldShowDelveWeeklyUnderlevel and ns.ShouldShowDelveWeeklyUnderlevel("gilded", gs) then
				text = ns:L("ACCOUNT_WEEKLY_GILDED_UNDERLEVEL_FMT"):format(GetDelverCapLevel())
				gr, gg, gb = 0.6, 0.6, 0.6
				nextLine(true, text, gr, gg, gb, nil, BuildUnderlevelTooltip)
			else
				if progress >= max then
					gr, gg, gb = 0.45, 0.95, 0.5
				elseif progress > 0 then
					gr, gg, gb = 0.9, 0.82, 0.45
				else
					gr, gg, gb = 0.9, 0.85, 0.55
				end
				nextLine(true, text, gr, gg, gb, nil, BuildGildedTooltip)
			end
			if data.gildedIncompleteLabels and #data.gildedIncompleteLabels > 0 then
				nextLine(
					true,
					ns:L("ACCOUNT_WEEKLY_GILDED_ALTS_FMT"):format(
						#data.gildedIncompleteLabels,
						FormatNamePreview(data.gildedIncompleteLabels)
					),
					0.9,
					0.82,
					0.45
				)
			end
		end

		local trove = data.troveCurrent
		if trove then
			local text = ns:L("ACCOUNT_WEEKLY_TROVE_AVAILABLE")
			local tr, tg, tb = 0.9, 0.85, 0.55
			if ns.ShouldShowDelveWeeklyUnderlevel and ns.ShouldShowDelveWeeklyUnderlevel("trove", trove) then
				text = ns:L("ACCOUNT_WEEKLY_TROVE_UNDERLEVEL_FMT"):format(GetDelverCapLevel())
				tr, tg, tb = 0.6, 0.6, 0.6
				nextLine(true, text, tr, tg, tb, nil, BuildUnderlevelTooltip)
			else
				if trove.status == "done" or trove.status == "active" then
					text = trove.status == "active" and ns:L("ACCOUNT_WEEKLY_TROVE_ACTIVE") or ns:L("ACCOUNT_WEEKLY_TROVE_DONE")
					tr, tg, tb = 0.45, 0.95, 0.5
				elseif trove.status == "looted" then
					text = ns:L("ACCOUNT_WEEKLY_TROVE_LOOTED")
					tr, tg, tb = 1, 0.84, 0.18
				end
				nextLine(true, text, tr, tg, tb)
			end
			if data.troveUnusedLabels and #data.troveUnusedLabels > 0 then
				nextLine(
					true,
					ns:L("ACCOUNT_WEEKLY_TROVE_UNUSED_ALTS_FMT"):format(
						#data.troveUnusedLabels,
						FormatNamePreview(data.troveUnusedLabels)
					),
					1,
					0.84,
					0.18
				)
			end
			if data.troveNeedLabels and #data.troveNeedLabels > 0 then
				nextLine(
					true,
					ns:L("ACCOUNT_WEEKLY_TROVE_NEED_ALTS_FMT"):format(
						#data.troveNeedLabels,
						FormatNamePreview(data.troveNeedLabels)
					),
					0.9,
					0.82,
					0.45
				)
			end
		end

		local sa = data.saCurrent
		if sa and (tonumber(sa.max) or 0) > 0 then
			local completed = tonumber(sa.completed) or 0
			local max = tonumber(sa.max) or 3
			local active = tonumber(sa.active) or 0
			local text = ns:L("ACCOUNT_WEEKLY_SA_FMT"):format(completed, max)
			if active > 0 then
				text = text .. ns:L("ACCOUNT_WEEKLY_SA_ACTIVE_SUFFIX"):format(active)
			end
			local sr, sg, sb
			if ns.ShouldShowDelveWeeklyUnderlevel and ns.ShouldShowDelveWeeklyUnderlevel("sa", sa) then
				text = ns:L("ACCOUNT_WEEKLY_SA_UNDERLEVEL_FMT"):format(GetDelverCapLevel())
				sr, sg, sb = 0.6, 0.6, 0.6
				nextLine(true, text, sr, sg, sb, nil, BuildUnderlevelTooltip)
			else
				if completed >= max then
					sr, sg, sb = 0.45, 0.95, 0.5
				elseif active > 0 then
					sr, sg, sb = 0.45, 0.95, 0.5
				else
					sr, sg, sb = 0.9, 0.85, 0.55
				end
				nextLine(true, text, sr, sg, sb, nil, BuildSpecialAssignmentTooltip)
			end
			if data.saIncompleteLabels and #data.saIncompleteLabels > 0 then
				nextLine(
					true,
					ns:L("ACCOUNT_WEEKLY_SA_ALTS_FMT"):format(
						#data.saIncompleteLabels,
						FormatNamePreview(data.saIncompleteLabels)
					),
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
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local lineH = LINE_H * s
	local titleH = 18 * s
	if panelUi.titleRow then
		panelUi.titleRow:SetHeight(titleH)
	end
	local collapsed = GetCollapsed()
	local visibleLines = 0
	for i, line in ipairs(panelUi.lines or {}) do
		-- Re-anker + hoogte met de huidige tekstschaal (mount zette vaste posities).
		line:SetHeight(lineH)
		line:ClearAllPoints()
		line:SetPoint("TOPLEFT", panelUi.block, "TOPLEFT", 4, -(titleH + (i - 1) * lineH))
		line:SetPoint("TOPRIGHT", panelUi.block, "TOPRIGHT", -4, -(titleH + (i - 1) * lineH))
		if line:IsShown() then
			visibleLines = visibleLines + 1
		end
	end
	local bodyH = collapsed and 0 or math.max(visibleLines * lineH, 0)
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
	panelUi.titleRow = titleRow

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
	titleFs:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	titleFs:SetPoint("LEFT", collapseBtn, "RIGHT", 2, 0)
	titleFs:SetPoint("RIGHT", titleRow, "RIGHT", -4, 0)
	titleFs:SetJustifyH("LEFT")
	titleFs:SetText(ns:L("ACCOUNT_WEEKLY_TITLE"))
	panelUi.titleFs = titleFs

	panelUi.lines = {}
	for i = 1, 24 do
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
		fs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
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
