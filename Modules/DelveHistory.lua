--[[
	Midnight Helper — Delve Log.

	Two halves:
	  1. A tracker that watches SCENARIO_COMPLETED and records every finished
	     Midnight delve to a per-character store (tier, duration, deaths, whether
	     a Restored Coffer Key was spent, end-boss name, timestamp).
	  2. A "Delve Log" tab that shows, per delve, lifetime totals (runs / best
	     tier / average + fastest time / deaths) and a collapsible list of the
	     most recent runs.

	The detection approach (tier auto-detect, /reload-safe run resume, instance
	mapID fallback) is adapted from the EverythingDelves addon, trimmed down to
	the core stats we keep. Delve names/zones are reused from ns.MIDNIGHT_DELVES
	(Delves.lua) so there is no duplicated data table.
]]

local _, ns = ...

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

-- Restored Coffer Key (Midnight). Verified value lives in Delves.lua; a drop in
-- this currency across a run means the player spent a key on the chest.
local COFFER_KEY_CURRENCY = 3028
local MAX_RECENT = 20
-- A persisted run is only resumed on /reload if it began within this many
-- wall-clock seconds. GetTime() is system uptime (survives a client restart),
-- so this guard stops a stale cross-session run from logging an absurd duration.
local MAX_RESUME_AGE = 6 * 3600

local COLOR_HEADER = { 0.82, 0.68, 0.30 }
local COLOR_DIM = { 0.75, 0.78, 0.82 }

-- Inline colour escapes for the densely formatted stat / run lines.
local CC_GOLD = "|cffe0c060"
local CC_DIM = "|cff9aa0a8"
local CC_BODY = "|cffe8e8e8"
local CC_GOOD = "|cff73d873"
local CC_CLOSE = "|r"

--------------------------------------------------------------------------------
-- Delve-name lookups (built lazily; ns.MIDNIGHT_DELVES is filled by Delves.lua)
--------------------------------------------------------------------------------

local loggableNames -- canonical delve name -> true
local instanceIDToName -- delve instance uiMapID -> canonical name

local function EnsureLookups()
	if loggableNames then
		return
	end
	loggableNames = {}
	if ns.MIDNIGHT_DELVES then
		for _, d in ipairs(ns.MIDNIGHT_DELVES) do
			-- d = { questId, mapID, x, y, name }
			local name = d[5]
			if name and name ~= "" then
				loggableNames[name] = true
			end
		end
	end
	-- Delve *instance* map IDs -> our canonical names. These differ from the
	-- world map IDs in MIDNIGHT_DELVES; used as a fallback when zone/instance
	-- text doesn't resolve to a known delve. (IDs catalogued by EverythingDelves.)
	instanceIDToName = {
		[2933] = "Collegiate Calamity",
		[2952] = "The Shadow Enclave",
		[2953] = "Parhelion Plaza",
		[2961] = "Twilight Crypts",
		[2962] = "Atal'Aman",
		[2963] = "The Grudge Pit",
		[2964] = "The Gulf of Memory",
		[2965] = "Sunkiller Sanctum",
		[2966] = "Torment's Rise",
		[2979] = "Shadowguard Point",
		[3003] = "The Darkway",
	}
end

--- Match a scenario/zone name against the delve directory.
--- Tries exact, then case-insensitive, then substring either direction so
--- "The Grudge Pit" <-> "Grudge Pit" still resolves. Returns the canonical
--- name or nil.
local function MatchDelveName(name)
	if not name or name == "" then
		return nil
	end
	EnsureLookups()
	if loggableNames[name] then
		return name
	end
	local lowered = name:lower()
	for canonical in pairs(loggableNames) do
		if canonical:lower() == lowered then
			return canonical
		end
	end
	for canonical in pairs(loggableNames) do
		local cl = canonical:lower()
		if lowered:find(cl, 1, true) or cl:find(lowered, 1, true) then
			return canonical
		end
	end
	return nil
end

--- Resolve the current delve name from the most reliable sources available.
local function ResolveDelveName()
	EnsureLookups()
	local zoneName = GetRealZoneText()
	if zoneName and zoneName ~= "" and MatchDelveName(zoneName) then
		return zoneName
	end
	if C_Map and C_Map.GetBestMapForUnit then
		local ok, mapID = pcall(C_Map.GetBestMapForUnit, "player")
		if ok and mapID and instanceIDToName[mapID] then
			return instanceIDToName[mapID]
		end
	end
	local instName = GetInstanceInfo()
	return instName
end

--------------------------------------------------------------------------------
-- Per-character store
--------------------------------------------------------------------------------

local function GetStore()
	if not ns.db then
		return nil
	end
	ns.db.delveLog = ns.db.delveLog or {}
	local guid = UnitGUID("player")
	if not guid then
		return nil
	end
	local store = ns.db.delveLog[guid]
	if not store then
		store = { name = UnitName("player"), delves = {} }
		ns.db.delveLog[guid] = store
	end
	store.delves = store.delves or {}
	store.name = UnitName("player") or store.name
	return store
end

--------------------------------------------------------------------------------
-- Tier auto-detection (ported from EverythingDelves, debug stripped)
--------------------------------------------------------------------------------

--- Return the current delve tier (1-11) or nil. Strategy, most authoritative
--- first: instance difficulty name -> scenario / step name -> a scrape of the
--- objective tracker for "Tier N".
local function AutoDetectDelveTier()
	local _, _, _, difficultyName = GetInstanceInfo()
	if difficultyName and difficultyName ~= "" then
		local m = difficultyName:match("(%d+)")
		local n = m and tonumber(m)
		if n and n >= 1 and n <= 11 then
			return n
		end
	end

	local m2
	pcall(function()
		if C_Scenario and C_Scenario.GetInfo then
			local scenarioName = C_Scenario.GetInfo() or ""
			local m = scenarioName:match("(%d+)")
			local n = m and tonumber(m)
			if n and n >= 1 and n <= 11 then
				m2 = n
				return
			end
		end
		if C_Scenario and C_Scenario.GetStepInfo then
			local stepName = C_Scenario.GetStepInfo()
			if stepName and stepName ~= "" then
				local m = stepName:match("(%d+)")
				local n = m and tonumber(m)
				if n and n >= 1 and n <= 11 then
					m2 = n
				end
			end
		end
	end)
	if m2 then
		return m2
	end

	local tracker = _G["ObjectiveTrackerFrame"] or _G["ScenarioObjectiveTracker"]
	if tracker then
		local foundDelveHeader = false
		local foundTier
		local zoneName = GetRealZoneText() or ""

		local function SearchForTier(frame)
			if foundTier then
				return
			end
			if not frame or frame:IsForbidden() then
				return
			end
			local nRegs = frame:GetNumRegions()
			for i = 1, nRegs do
				local r = select(i, frame:GetRegions())
				if r and r:GetObjectType() == "FontString" and r:IsShown() then
					local txt = r:GetText()
					if txt and txt ~= "" then
						local clean = txt:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
						local m = clean:match("Tier%s*:?%s*(%d+)") or clean:match("Difficulty%s*:?%s*(%d+)")
						if m then
							local n = tonumber(m)
							if n and n >= 1 and n <= 11 then
								foundTier = n
								return
							end
						end
						if clean == "Delves" or clean == zoneName then
							foundDelveHeader = true
						elseif foundDelveHeader and clean:match("^%d+$") then
							local n = tonumber(clean)
							if n and n >= 1 and n <= 11 then
								foundTier = n
								return
							end
						end
					end
				end
			end
			local nChildren = frame:GetNumChildren()
			for i = 1, nChildren do
				SearchForTier(select(i, frame:GetChildren()))
				if foundTier then
					return
				end
			end
		end

		pcall(SearchForTier, tracker)
		if foundTier then
			return foundTier
		end
	end

	return nil
end

--------------------------------------------------------------------------------
-- Run tracking
--------------------------------------------------------------------------------

local runState = {
	inDelve = false,
	delveName = nil,
	startTime = 0,
	deaths = 0,
	startKeyCount = 0,
	tier = 0,
	boss = nil,
}

local function GetCurrencyQty(id)
	if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local info = C_CurrencyInfo.GetCurrencyInfo(id)
		if info then
			return info.quantity or 0
		end
	end
	return 0
end

local function TryCaptureTier()
	if runState.tier and runState.tier > 0 then
		return
	end
	local t = AutoDetectDelveTier()
	if t and t > 0 then
		runState.tier = t
		local store = GetStore()
		if store and store.activeRun then
			store.activeRun.tier = t
		end
	end
end

local function BeginDelveRun(name)
	runState.inDelve = true
	runState.delveName = name
	runState.startTime = GetTime()
	runState.deaths = 0
	runState.startKeyCount = GetCurrencyQty(COFFER_KEY_CURRENCY)
	runState.tier = 0
	runState.boss = nil
	local store = GetStore()
	if store then
		store.activeRun = {
			name = name,
			startTime = runState.startTime,
			startedAt = time(),
			deaths = 0,
			startKeyCount = runState.startKeyCount,
			tier = 0,
		}
	end
	TryCaptureTier()
end

local function EndDelveRun()
	runState.inDelve = false
	runState.delveName = nil
	runState.startTime = 0
	runState.deaths = 0
	runState.startKeyCount = 0
	runState.tier = 0
	runState.boss = nil
	local store = GetStore()
	if store then
		store.activeRun = nil
	end
end

local function LogRun(name, tier, duration, deaths, keyUsed, boss)
	local store = GetStore()
	if not (name and store) then
		return
	end
	local entry = store.delves[name]
	if not entry then
		entry = {
			lifetime = {
				totalRuns = 0,
				totalDeaths = 0,
				totalDuration = 0,
				totalKeysUsed = 0,
				highestTier = 0,
				fastestTime = 0,
			},
			recent = {},
		}
		store.delves[name] = entry
	end

	local life = entry.lifetime
	life.totalRuns = (life.totalRuns or 0) + 1
	life.totalDeaths = (life.totalDeaths or 0) + (deaths or 0)
	life.totalDuration = (life.totalDuration or 0) + (duration or 0)
	life.totalKeysUsed = (life.totalKeysUsed or 0) + (keyUsed and 1 or 0)
	if tier and tier > (life.highestTier or 0) then
		life.highestTier = tier
	end
	if duration and duration > 0 then
		if not life.fastestTime or life.fastestTime == 0 or duration < life.fastestTime then
			life.fastestTime = duration
		end
	end

	table.insert(entry.recent, 1, {
		tier = tier or 0,
		duration = duration or 0,
		deaths = deaths or 0,
		keyUsed = keyUsed and true or false,
		boss = (boss and boss ~= "") and boss or nil,
		timestamp = time(),
	})
	while #entry.recent > MAX_RECENT do
		table.remove(entry.recent)
	end

	if ns.RefreshDelveLogPanel then
		ns.RefreshDelveLogPanel()
	end
end

--- Wipe this character's delve log.
function ns.ClearDelveLog()
	local store = GetStore()
	if store then
		wipe(store.delves)
	end
	if ns.RefreshDelveLogPanel then
		ns.RefreshDelveLogPanel()
	end
end

--------------------------------------------------------------------------------
-- Tracker event frame (independent of the central dispatcher)
--------------------------------------------------------------------------------

local enteredViaReload = false

local function TryBeginFromCurrentZone(source)
	local _, instanceType = IsInInstance()
	local instName, _, diffID = GetInstanceInfo()
	local isDelve = (diffID == 208) or (instanceType == "scenario")

	if not isDelve then
		if runState.inDelve then
			EndDelveRun()
		end
		return
	end

	local candidate = ResolveDelveName() or instName
	local matched = MatchDelveName(candidate or "")

	if matched then
		-- A genuine new world-entry (PEW that is NOT a /reload) always means a
		-- fresh delve instance, so start a new run even if the name matches the
		-- one we were tracking. Otherwise back-to-back runs of the same delve
		-- could measure run 2 from run 1's start time.
		local freshEntry = (source == "PLAYER_ENTERING_WORLD") and not enteredViaReload
		if (not runState.inDelve) or runState.delveName ~= matched or freshEntry then
			local store = GetStore()
			local saved = store and store.activeRun
			if
				enteredViaReload
				and saved
				and saved.name == matched
				and saved.startTime
				and saved.startTime <= GetTime()
				and saved.startedAt
				and (time() - saved.startedAt) < MAX_RESUME_AGE
			then
				runState.inDelve = true
				runState.delveName = matched
				runState.startTime = saved.startTime
				runState.deaths = saved.deaths or 0
				runState.startKeyCount = saved.startKeyCount or 0
				runState.tier = saved.tier or 0
				runState.boss = nil
				TryCaptureTier()
			else
				if store then
					store.activeRun = nil
				end
				BeginDelveRun(matched)
			end
		else
			TryCaptureTier()
		end
	else
		-- Unknown name: still track timing/deaths provisionally; completion will
		-- re-resolve and only log if it matches a known delve.
		if not runState.inDelve then
			runState.inDelve = true
			runState.delveName = candidate
			runState.startTime = GetTime()
			runState.deaths = 0
			runState.startKeyCount = GetCurrencyQty(COFFER_KEY_CURRENCY)
			runState.tier = 0
			runState.boss = nil
		end
		TryCaptureTier()
	end
end

local tracker = CreateFrame("Frame")
tracker:RegisterEvent("PLAYER_ENTERING_WORLD")
tracker:RegisterEvent("ZONE_CHANGED_NEW_AREA")
tracker:RegisterEvent("SCENARIO_UPDATE")
tracker:RegisterEvent("SCENARIO_COMPLETED")
tracker:RegisterEvent("PLAYER_DEAD")
tracker:RegisterEvent("ENCOUNTER_END")
tracker:SetScript("OnEvent", function(_, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		local _, isReloadingUi = ...
		enteredViaReload = isReloadingUi and true or false
		TryBeginFromCurrentZone(event)
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		TryBeginFromCurrentZone(event)
	elseif event == "SCENARIO_UPDATE" then
		-- Once we're in and the tier is captured, skip the expensive re-scan.
		if runState.inDelve and runState.tier and runState.tier > 0 then
			return
		end
		TryBeginFromCurrentZone(event)
	elseif event == "PLAYER_DEAD" then
		if runState.inDelve then
			runState.deaths = runState.deaths + 1
		end
	elseif event == "ENCOUNTER_END" then
		if runState.inDelve then
			local _, encounterName = ...
			if encounterName and encounterName ~= "" then
				runState.boss = encounterName
			end
		end
	elseif event == "SCENARIO_COMPLETED" then
		local candidate = ResolveDelveName()
		if not candidate or candidate == "" then
			candidate = runState.delveName
		end
		local matched = MatchDelveName(candidate or "")

		local duration = (runState.startTime > 0) and math.max(0, math.floor(GetTime() - runState.startTime)) or 0
		if duration > MAX_RESUME_AGE then
			duration = 0
		end

		-- The entry-latched tier can be the PREVIOUS run's (the tracker still
		-- shows the delve we just left at zone-in), so re-read now and prefer it.
		local latched = runState.tier or 0
		local confirmed = AutoDetectDelveTier()
		local tier = (confirmed and confirmed > 0) and confirmed or latched

		local keyNow = GetCurrencyQty(COFFER_KEY_CURRENCY)
		local keyUsed = (runState.startKeyCount > 0) and (keyNow < runState.startKeyCount) or false

		if matched then
			LogRun(matched, tier, duration, runState.deaths, keyUsed, runState.boss)
		end
		EndDelveRun()
	end
end)

--------------------------------------------------------------------------------
-- Formatting helpers (UI)
--------------------------------------------------------------------------------

local function FormatDuration(sec)
	sec = sec or 0
	if sec <= 0 then
		return "--"
	end
	if sec < 60 then
		return string.format("%ds", sec)
	end
	if sec < 3600 then
		return string.format("%dm %02ds", math.floor(sec / 60), sec % 60)
	end
	return string.format("%dh %dm", math.floor(sec / 3600), math.floor((sec % 3600) / 60))
end

local function FormatDateTime(ts)
	if not ts or ts == 0 then
		return ""
	end
	return date("%b %d, %H:%M", ts)
end

--------------------------------------------------------------------------------
-- UI panel
--------------------------------------------------------------------------------

local SIDE_PAD = 14
local TOP_PAD = 12
local HEADER_ROW_H = 22
local RUN_ROW_H = 16

local ui
local expandedByKey = {}
local headerRowPool = {}
local runRowPool = {}

local Refresh -- forward declaration

local function HeaderRow_OnClick(self)
	local key = self._mhKey
	if not key then
		return
	end
	expandedByKey[key] = not expandedByKey[key]
	if Refresh then
		Refresh()
	end
end

local function CreateHeaderRow()
	local row = CreateFrame("Button", nil, ui.child)
	row:SetHeight(HEADER_ROW_H)

	local arrow = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	arrow:SetPoint("LEFT", row, "LEFT", 2, 0)
	arrow:SetWidth(14)
	arrow:SetJustifyH("LEFT")
	row.arrow = arrow

	local nameFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	nameFS:SetPoint("LEFT", arrow, "RIGHT", 4, 0)
	nameFS:SetWidth(170)
	nameFS:SetJustifyH("LEFT")
	nameFS:SetWordWrap(false)
	row.nameFS = nameFS

	local statsFS = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	statsFS:SetPoint("LEFT", nameFS, "RIGHT", 6, 0)
	statsFS:SetPoint("RIGHT", row, "RIGHT", -4, 0)
	statsFS:SetJustifyH("LEFT")
	statsFS:SetWordWrap(false)
	row.statsFS = statsFS

	row:SetScript("OnClick", HeaderRow_OnClick)
	return row
end

local function CreateRunRow()
	local row = CreateFrame("Frame", nil, ui.child)
	row:SetHeight(RUN_ROW_H)
	local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	fs:SetPoint("LEFT", row, "LEFT", 0, 0)
	fs:SetPoint("RIGHT", row, "RIGHT", -4, 0)
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(false)
	row.fs = fs
	return row
end

local function AcquireHeaderRow(i)
	local row = headerRowPool[i]
	if not row then
		row = CreateHeaderRow()
		headerRowPool[i] = row
	end
	row:ClearAllPoints()
	return row
end

local function AcquireRunRow(i)
	local row = runRowPool[i]
	if not row then
		row = CreateRunRow()
		runRowPool[i] = row
	end
	row:ClearAllPoints()
	return row
end

local function BuildStatsText(life)
	local avg = (life.totalRuns and life.totalRuns > 0) and math.floor(life.totalDuration / life.totalRuns) or 0
	return string.format(
		"%s%s %s%d%s   %s%s %s%s%d%s   %s%s %s%s%s   %s%s %s%s%s   %s%s %s%d%s",
		CC_DIM,
		ns:L("DELVELOG_LBL_RUNS"),
		CC_BODY,
		life.totalRuns or 0,
		CC_CLOSE,
		CC_DIM,
		ns:L("DELVELOG_LBL_BEST"),
		CC_BODY,
		"T",
		life.highestTier or 0,
		CC_CLOSE,
		CC_DIM,
		ns:L("DELVELOG_LBL_AVG"),
		CC_BODY,
		FormatDuration(avg),
		CC_CLOSE,
		CC_DIM,
		ns:L("DELVELOG_LBL_FASTEST"),
		CC_BODY,
		FormatDuration(life.fastestTime),
		CC_CLOSE,
		CC_DIM,
		ns:L("DELVELOG_LBL_DEATHS"),
		CC_BODY,
		life.totalDeaths or 0,
		CC_CLOSE
	)
end

local function BuildRunText(run)
	local parts = {}
	parts[#parts + 1] = CC_GOLD .. "T" .. (run.tier or 0) .. CC_CLOSE
	parts[#parts + 1] = CC_BODY .. FormatDuration(run.duration) .. CC_CLOSE
	parts[#parts + 1] = CC_DIM .. ns:L("DELVELOG_LBL_DEATHS") .. " " .. CC_BODY .. (run.deaths or 0) .. CC_CLOSE
	if run.keyUsed then
		parts[#parts + 1] = CC_GOOD .. ns:L("DELVELOG_LBL_KEY") .. CC_CLOSE
	end
	if run.boss and run.boss ~= "" then
		parts[#parts + 1] = CC_BODY .. run.boss .. CC_CLOSE
	end
	parts[#parts + 1] = CC_DIM .. FormatDateTime(run.timestamp) .. CC_CLOSE
	return table.concat(parts, "   ")
end

function Refresh()
	if not ui or not ui.child then
		return
	end

	local store = GetStore()
	local delves = store and store.delves or {}

	-- Collect logged delve keys + aggregate totals.
	local keys = {}
	local totalRuns, totalDeaths, totalDur = 0, 0, 0
	for name, entry in pairs(delves) do
		local life = entry and entry.lifetime
		if life and (life.totalRuns or 0) > 0 then
			keys[#keys + 1] = name
			totalRuns = totalRuns + (life.totalRuns or 0)
			totalDeaths = totalDeaths + (life.totalDeaths or 0)
			totalDur = totalDur + (life.totalDuration or 0)
		end
	end
	table.sort(keys)

	ui.summary:SetText(
		string.format(
			"%s%s %s%d%s    %s%s %s%d%s    %s%s %s%s%s",
			CC_DIM,
			ns:L("DELVELOG_LBL_RUNS"),
			CC_GOLD,
			totalRuns,
			CC_CLOSE,
			CC_DIM,
			ns:L("DELVELOG_LBL_DEATHS"),
			CC_GOLD,
			totalDeaths,
			CC_CLOSE,
			CC_DIM,
			ns:L("DELVELOG_TOTAL_TIME"),
			CC_GOLD,
			FormatDuration(totalDur),
			CC_CLOSE
		)
	)

	for _, r in ipairs(headerRowPool) do
		r:Hide()
	end
	for _, r in ipairs(runRowPool) do
		r:Hide()
	end

	local width = ui.child:GetWidth()
	if not width or width <= 0 then
		return
	end

	local y = 4

	if #keys == 0 then
		ui.empty:Show()
		ui.empty:ClearAllPoints()
		ui.empty:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 2, -y)
		ui.empty:SetWidth(math.max(width - 4, 1))
		ui.child:SetHeight(math.max(y + (ui.empty:GetStringHeight() or 16) + 8, 1))
		return
	end
	ui.empty:Hide()

	local hUsed, rUsed = 0, 0
	for _, key in ipairs(keys) do
		local entry = delves[key]
		local life = entry.lifetime
		local expanded = expandedByKey[key] and true or false

		hUsed = hUsed + 1
		local row = AcquireHeaderRow(hUsed)
		row.arrow:SetText(expanded and (CC_GOLD .. "v" .. CC_CLOSE) or (CC_GOLD .. ">" .. CC_CLOSE))
		row.nameFS:SetText(CC_BODY .. key .. CC_CLOSE)
		row.statsFS:SetText(BuildStatsText(life))
		row:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
		row:SetPoint("RIGHT", ui.child, "RIGHT", -4, 0)
		row:Show()
		y = y + HEADER_ROW_H

		if expanded and entry.recent then
			for _, run in ipairs(entry.recent) do
				rUsed = rUsed + 1
				local rrow = AcquireRunRow(rUsed)
				rrow.fs:SetText(BuildRunText(run))
				rrow:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 24, -y)
				rrow:SetPoint("RIGHT", ui.child, "RIGHT", -4, 0)
				rrow:Show()
				y = y + RUN_ROW_H + 1
			end
			y = y + 4
		end
	end

	ui.child:SetHeight(math.max(y + 8, 1))
end

function ns.RefreshDelveLogPanel()
	if not ui or not ui.panel or not ui.panel:IsVisible() then
		return
	end
	Refresh()
end

-- NOTE: index-assign only. Never reassign the global StaticPopupDialogs table
-- (e.g. `StaticPopupDialogs = StaticPopupDialogs or {}`) — writing the global
-- from addon code taints the whole table, which then blocks protected calls
-- like AcceptSpellConfirmationPrompt() the next time ANY Blizzard popup (such
-- as the leave-delve confirmation) fires, falsely blaming this addon.
StaticPopupDialogs["MIDNIGHTHELPER_CLEAR_DELVELOG"] = {
	text = "%s",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		ns.ClearDelveLog()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

function ns.BuildDelveLogPanel(panel)
	if not panel or panel._mhDelveLogBuilt then
		return
	end
	panel._mhDelveLogBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("TAB_DELVE_LOG"))

	-- Deliberately understated: a small grey text link in the corner rather
	-- than a prominent button, so wiping history is reachable but never an easy
	-- accidental click. Brightens on hover; still gated behind a confirm popup.
	local clearBtn = CreateFrame("Button", nil, panel)
	clearBtn:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -SIDE_PAD, -TOP_PAD - 2)
	local clearText = clearBtn:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	clearText:SetPoint("RIGHT", clearBtn, "RIGHT", 0, 0)
	clearText:SetText(ns:L("DELVELOG_CLEAR"))
	clearText:SetTextColor(0.5, 0.5, 0.5)
	clearBtn.text = clearText
	clearBtn:SetSize(math.max(clearText:GetStringWidth() + 4, 10), 16)
	clearBtn:SetScript("OnClick", function()
		StaticPopup_Show("MIDNIGHTHELPER_CLEAR_DELVELOG", ns:L("DELVELOG_CLEAR_CONFIRM"))
	end)
	clearBtn:SetScript("OnEnter", function(self)
		self.text:SetTextColor(0.95, 0.5, 0.4)
	end)
	clearBtn:SetScript("OnLeave", function(self)
		self.text:SetTextColor(0.5, 0.5, 0.5)
	end)

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	subtitle:SetText(ns:L("DELVELOG_SUBTITLE"))

	local summary = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	summary:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	summary:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	summary:SetJustifyH("LEFT")
	summary:SetWordWrap(false)

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperDelveLogScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", summary, "BOTTOMLEFT", 0, -10)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)

	local empty = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	empty:SetJustifyH("LEFT")
	empty:SetWordWrap(true)
	empty:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	empty:SetText(ns:L("DELVELOG_EMPTY"))
	empty:Hide()

	ui = {
		panel = panel,
		title = title,
		subtitle = subtitle,
		summary = summary,
		scroll = scroll,
		child = child,
		empty = empty,
		clearBtn = clearBtn,
	}

	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
			Refresh()
		end
	end
	scroll:SetScript("OnSizeChanged", syncWidth)
	syncWidth()

	panel:SetScript("OnShow", function()
		syncWidth()
		Refresh()
	end)
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_DELVE_LOG"))
			ui.subtitle:SetText(ns:L("DELVELOG_SUBTITLE"))
			ui.empty:SetText(ns:L("DELVELOG_EMPTY"))
			if ui.clearBtn and ui.clearBtn.text then
				ui.clearBtn.text:SetText(ns:L("DELVELOG_CLEAR"))
				ui.clearBtn:SetSize(math.max(ui.clearBtn.text:GetStringWidth() + 4, 10), 16)
			end
		end
		if ui and ui.panel and ui.panel:IsShown() then
			Refresh()
		end
	end
end
