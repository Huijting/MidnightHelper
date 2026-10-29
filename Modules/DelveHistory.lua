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

--- 🧩 THE LABYRINTH FINISHES ONE SCENARIO PER ROOM. Rob's log after two evenings said "17 runs": GEMETEN 17 Oct 2026 in
--- his SavedVariables, one entry per room, 8-28 min each, back to back. So in the Labyrinth a finished scenario adds a
--- room to the run, and the run is logged once, with its room count, when the player leaves the instance.
local ROOM_RUN_DELVES = { ["The Labyrinth of Kindo'jan"] = true }
--- The Labyrinth is always Bountiful (AreaPOI 9035/9037 "Bountiful Delve", Wowhead/Icy Veins), but the Bountiful map pin
--- check never sees it: GEMETEN 22 Oct 2026, every Labyrinth run in Rob's log had wasBountiful = false, so the Gilded
--- Stash count skipped them while a Tier 11 run had just left him one (his screenshot).
function ns.IsAlwaysBountifulDelve(name)
	return name ~= nil and ROOM_RUN_DELVES[name] == true
end
-- Old per-room entries less than this far apart (end of one → start of the next) were one run (merge below).
local ROOM_GAP_SAME_RUN = 15 * 60 -- CHOSEN: Rob's rooms followed each other within minutes

--- One-time repair of logs written before 17 Oct 2026: back-to-back Labyrinth rooms become one run with `rooms`.
local function MergeRoomRuns(store)
	for name in pairs(ROOM_RUN_DELVES) do
		local entry = store.delves[name]
		local recent = entry and entry.recent
		if type(recent) == "table" and #recent > 1 then
			local runs, cur = {}, nil
			-- `recent` is newest first; walk it oldest first.
			for i = #recent, 1, -1 do
				local r = recent[i]
				local startAt = (r.timestamp or 0) - (r.duration or 0)
				if cur and startAt - (cur.timestamp or 0) <= ROOM_GAP_SAME_RUN then
					cur.duration = (cur.duration or 0) + (r.duration or 0)
					cur.deaths = (cur.deaths or 0) + (r.deaths or 0)
					cur.timestamp = r.timestamp
					cur.rooms = (cur.rooms or 1) + (r.rooms or 1)
					cur.boss = r.boss or cur.boss
					cur.keyUsed = cur.keyUsed or r.keyUsed
					if (r.tier or 0) > (cur.tier or 0) then
						cur.tier = r.tier
					end
				else
					cur = {}
					for k, v in pairs(r) do
						cur[k] = v
					end
					cur.rooms = cur.rooms or 1
					runs[#runs + 1] = cur
				end
			end
			local merged = #recent - #runs
			if merged > 0 then
				wipe(recent)
				for i = #runs, 1, -1 do
					recent[#recent + 1] = runs[i]
				end
				local life = entry.lifetime
				if type(life) == "table" then
					life.totalRuns = math.max(#runs, (life.totalRuns or 0) - merged)
					local fastest
					for _, r in ipairs(runs) do
						if (r.duration or 0) > 0 and (not fastest or r.duration < fastest) then
							fastest = r.duration
						end
					end
					life.fastestTime = fastest or life.fastestTime
				end
			end
		end
	end
end

--- 🏁 RECORDS PER TIER (design C/D, Rob 29 Oct 2026: "By deze zeg ik go"). `lifetime.fastestTime` counts every tier
--- together, so a Tier 1 run could be your "record" next to Tier 11 runs (MEASURED 27 Oct, LogRun below). Records now live
--- in `lifetime.bestByTier[tier] = seconds`. A run with tier 0 (unknown) or a Labyrinth run (rooms; it has its own
--- splits) never becomes a record.
--- Is this run one that can hold a record?
local function CountsForRecord(name, tier, duration)
	return (tier or 0) > 0 and (duration or 0) > 0 and not ROOM_RUN_DELVES[name]
end

--- One-time: fill bestByTier from the runs we still have (the last MAX_RECENT per delve; older runs are gone).
local function BackfillTierBests(store)
	for name, entry in pairs(store.delves or {}) do
		local life = type(entry) == "table" and entry.lifetime
		if type(life) == "table" then
			life.bestByTier = life.bestByTier or {}
			for _, r in ipairs(entry.recent or {}) do
				if CountsForRecord(name, r.tier, r.duration) then
					local old = life.bestByTier[r.tier]
					if not old or r.duration < old then
						life.bestByTier[r.tier] = r.duration
					end
				end
			end
		end
	end
end

-- Shared status palette (UI.lua). The fallbacks keep this module standalone.
local C = ns.UI_COLORS or {}
local COLOR_HEADER = C.header or { 0.91, 0.76, 0.42 }
local COLOR_DIM = C.dim or { 0.75, 0.78, 0.82 }

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
	if not store.roomRunsMerged then
		store.roomRunsMerged = true
		MergeRoomRuns(store)
	end
	if not store.tierBestsBuilt then
		store.tierBestsBuilt = true
		BackfillTierBests(store)
	end
	return store
end

--------------------------------------------------------------------------------
-- Tier auto-detection (ported from EverythingDelves, debug stripped)
--------------------------------------------------------------------------------

--- The scenario header widget, which is where the tier actually lives.
---
--- Everything below this function mines digits out of a string, and that is why
--- this file records a tier for roughly a third of runs. Measured in Rob's client
--- on 1 Aug 2026, inside The Darkway at Tier 11: `GetInstanceInfo()` returns
--- difficultyID 208 with difficultyName **"Delves"**. No digits. The scenario name
--- is "Delves" and the step name is the delve's own name. None of the three
--- fallbacks can succeed, and the tracker scrape only works while the header
--- happens to be drawn.
---
--- The number is only ever display text on a UI widget — the "Tier 11" caption
--- above the tracker. A sweep of set IDs 1-4200 and widget IDs 1-9000 found
--- exactly one widget carrying it, id 6183 in set 842, `tierText = "11"`. DBM has
--- read it this way since delves shipped (`DBM-Core/modules/objects/Difficulties.lua:565`).
---
--- The three IDs are DBM's. 6184 and 6185 are the non-tiered normal/mythic
--- variants, so `tierText` on those is not expected; they are tried anyway because
--- asking costs nothing and assuming which one is live costs a run.
---
--- No upper bound on the value. The string-mining below clamps to 1-11 to reject
--- digits that happened to sit in a name, but a field literally called `tierText`
--- needs no such defence — and clamping would silently drop a Tier 12 the moment
--- Blizzard adds one.
local function WidgetDelveTier()
	local reader = C_UIWidgetManager and C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo
	if type(reader) ~= "function" then
		return nil
	end
	for _, id in ipairs({ 6183, 6184, 6185 }) do
		local ok, info = pcall(reader, id)
		if ok and type(info) == "table" and info.shownState == 1 then
			local n = tonumber(info.tierText)
			if n and n >= 1 then
				return n
			end
		end
	end
	return nil
end

--- Return the current delve tier (1-11) or nil. Strategy, most authoritative
--- first: the scenario header widget -> instance difficulty name -> scenario /
--- step name -> a scrape of the objective tracker for "Tier N".
local function AutoDetectDelveTier()
	local widgetTier = WidgetDelveTier()
	if widgetTier then
		return widgetTier
	end

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
	wasBountiful = false,
	rooms = 0, -- Labyrinth only: rooms finished in this run
	roomDuration = 0, -- seconds from the start to the last finished room
}


local function GetDelveMapID(name)
	if not name or not ns.MIDNIGHT_DELVES then
		return nil
	end
	for _, row in ipairs(ns.MIDNIGHT_DELVES) do
		if row[5] == name then
			return row[2]
		end
	end
	return nil
end

local function RefreshBountifulSnapshot()
	if runState.wasBountiful or not runState.delveName then
		return
	end
	if ROOM_RUN_DELVES[runState.delveName] then
		runState.wasBountiful = true
		local store = GetStore()
		if store and store.activeRun then
			store.activeRun.wasBountiful = true
		end
		return
	end
	if ns.IsDelveBountiful then
		local mapID = GetDelveMapID(runState.delveName)
		if ns.IsDelveBountiful(runState.delveName, mapID) then
			runState.wasBountiful = true
			local store = GetStore()
			if store and store.activeRun then
				store.activeRun.wasBountiful = true
			end
		end
	end
end

local function GetCurrencyQty(id)
	if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local info = C_CurrencyInfo.GetCurrencyInfo(id)
		if info then
			return info.quantity or 0
		end
	end
	return 0
end

--- The widget beats a guess: a tier mined from text at zone-in used to stick for the whole run (Rob, 27 Oct 2026: his
--- Tier 11 Labyrinth run was latched as Tier 6 while the widget said tierText "11", MEASURED with a /run that evening).
local function TryCaptureTier()
	local w = WidgetDelveTier()
	if w and w ~= runState.tier then
		runState.tier = w
		local store = GetStore()
		if store and store.activeRun then
			store.activeRun.tier = w
		end
		return
	end
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

--- Public: which delve are you in right now, and at which tier.
---
--- Exported 22 Aug 2026 for the Valeera popup, which needs to know whether the run it
--- is watching is bountiful. This file already resolves the name carefully (scenario
--- text, then the POI list), and a second guess elsewhere would be a second thing to
--- get wrong. Returns nil outside a delve.
function ns.GetCurrentDelveRun()
	if not runState.inDelve then
		return nil
	end
	return runState.delveName, runState.tier
end

--- Public: the tier on the scenario header widget right now, or nil when it is not shown. Exported 27 Oct 2026 for the
--- Labyrinth splits, whose SCENARIO_COMPLETED handler runs before this file's (load order) and so read the stale tier.
function ns.ReadDelveTierWidget()
	return WidgetDelveTier()
end

local function BeginDelveRun(name)
	runState.inDelve = true
	runState.delveName = name
	runState.startTime = GetTime()
	runState.deaths = 0
	runState.startKeyCount = GetCurrencyQty(COFFER_KEY_CURRENCY)
	runState.tier = 0
	runState.boss = nil
	runState.wasBountiful = false
	runState.rooms = 0
	runState.roomDuration = 0
	local store = GetStore()
	if store then
		store.activeRun = {
			name = name,
			startTime = runState.startTime,
			startedAt = time(),
			deaths = 0,
			startKeyCount = runState.startKeyCount,
			tier = 0,
			wasBountiful = false,
			rooms = 0,
		}
	end
	RefreshBountifulSnapshot()
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
	runState.wasBountiful = false
	runState.rooms = 0
	runState.roomDuration = 0
	local store = GetStore()
	if store then
		store.activeRun = nil
	end
end

local function LogRun(name, tier, duration, deaths, keyUsed, boss, wasBountiful, rooms)
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

	-- Record per tier (see CountsForRecord). prevBest = the record this run had to beat (nil = first time on this tier).
	life.bestByTier = life.bestByTier or {}
	local counts = CountsForRecord(name, tier, duration)
	local prevBest = counts and life.bestByTier[tier] or nil
	local isRecord, isFirst = false, false
	if counts then
		if not prevBest then
			isFirst = true
			life.bestByTier[tier] = duration
		elseif duration < prevBest then
			isRecord = true
			life.bestByTier[tier] = duration
		end
	end

	table.insert(entry.recent, 1, {
		record = isRecord or nil,
		firstTier = isFirst or nil,
		beat = isRecord and (prevBest - duration) or nil,
		tier = tier or 0,
		duration = duration or 0,
		deaths = deaths or 0,
		keyUsed = keyUsed and true or false,
		boss = (boss and boss ~= "") and boss or nil,
		wasBountiful = wasBountiful and true or false,
		rooms = (rooms and rooms > 0) and rooms or nil,
		timestamp = time(),
	})
	while #entry.recent > MAX_RECENT do
		table.remove(entry.recent)
	end

	-- Post-run scorecard hook (Modules/RunScorecard.lua). Passes the run + the
	-- updated lifetime totals so the card can say "faster than your average" etc.
	if ns.OnDelveRunLogged then
		ns.OnDelveRunLogged({
			name = name,
			tier = tier or 0,
			duration = duration or 0,
			deaths = deaths or 0,
			boss = (boss and boss ~= "") and boss or nil,
			wasBountiful = wasBountiful and true or false,
			runs = life.totalRuns or 1,
			fastestTime = life.fastestTime or 0,
			totalDuration = life.totalDuration or 0,
			rooms = (rooms and rooms > 0) and rooms or nil,
			-- Per-tier record (RunScorecard: the chat note and the on-screen notice, design D).
			tierCounts = counts,
			tierPrevBest = prevBest,
			tierRecord = isRecord,
			tierFirst = isFirst,
		})
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

--- Log a Labyrinth run that has finished rooms, once, as one run. From the live state, or (after a logout inside) from
--- the saved activeRun. Nothing to log → nothing happens; the caller still ends the run.
local function FlushRoomRun()
	local store = GetStore()
	local saved = store and store.activeRun
	local name, rooms, duration, deaths, tier, boss, startKeys, bountiful
	if runState.inDelve and (runState.rooms or 0) > 0 then
		name, rooms, duration = runState.delveName, runState.rooms, runState.roomDuration
		deaths, tier, boss = runState.deaths, runState.tier, runState.boss
		startKeys, bountiful = runState.startKeyCount, runState.wasBountiful
	elseif type(saved) == "table" and (saved.rooms or 0) > 0 then
		name, rooms, duration = saved.name, saved.rooms, saved.roomDuration
		deaths, tier, boss = saved.deaths, saved.tier, saved.boss
		startKeys, bountiful = saved.startKeyCount, saved.wasBountiful
	end
	if not (name and rooms) then
		return
	end
	local keyNow = GetCurrencyQty(COFFER_KEY_CURRENCY)
	local keyUsed = (startKeys or 0) > 0 and keyNow < startKeys or false
	LogRun(name, tier or 0, duration or 0, deaths or 0, keyUsed, boss, bountiful, rooms)
	if store then
		store.activeRun = nil
	end
end

local function TryBeginFromCurrentZone(source)
	local _, instanceType = IsInInstance()
	local instName, _, diffID = GetInstanceInfo()
	local isDelve = (diffID == 208) or (instanceType == "scenario")

	if not isDelve then
		FlushRoomRun() -- a Labyrinth run is logged when you leave it
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
		-- Inside the Labyrinth a loading screen between rooms is not a new run: you never left the instance (leaving
		-- goes through the "not isDelve" branch above, which logs the run).
		if freshEntry and runState.inDelve and runState.delveName == matched and ROOM_RUN_DELVES[matched] then
			freshEntry = false
		end
		if runState.inDelve and runState.delveName ~= matched then
			FlushRoomRun()
		end
		if (not runState.inDelve) or runState.delveName ~= matched or freshEntry then
			local store = GetStore()
			local saved = store and store.activeRun
			-- A Labyrinth run with finished rooms also survives a logout inside it (same instance, same run).
			local roomResume = saved and ROOM_RUN_DELVES[matched] and (saved.rooms or 0) > 0
			if
				(enteredViaReload or roomResume)
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
				runState.boss = saved.boss
				runState.wasBountiful = saved.wasBountiful and true or false
				runState.rooms = saved.rooms or 0
				runState.roomDuration = saved.roomDuration or 0
				TryCaptureTier()
				RefreshBountifulSnapshot()
			else
				if store then
					store.activeRun = nil
				end
				BeginDelveRun(matched)
			end
		else
			TryCaptureTier()
			RefreshBountifulSnapshot()
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
			runState.wasBountiful = false
		end
		TryCaptureTier()
		RefreshBountifulSnapshot()
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
		if runState.inDelve then
			RefreshBountifulSnapshot()
			if not runState.tier or runState.tier <= 0 then
				TryBeginFromCurrentZone(event)
			else
				TryCaptureTier()
			end
		else
			TryBeginFromCurrentZone(event)
		end
	elseif event == "PLAYER_DEAD" then
		if runState.inDelve then
			runState.deaths = runState.deaths + 1
			-- Ook in de persistente run opslaan: anders gaat de death verloren bij
			-- een /reload (de resume-logica leest store.activeRun.deaths terug, en
			-- die werd nooit bijgewerkt → telde terug naar 0).
			local store = GetStore()
			if store and store.activeRun then
				store.activeRun.deaths = runState.deaths
			end
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

		if matched and ROOM_RUN_DELVES[matched] then
			-- One room done, the run goes on (see ROOM_RUN_DELVES). Kept in activeRun so a /reload or logout keeps it.
			if not runState.inDelve then
				BeginDelveRun(matched)
			end
			runState.rooms = (runState.rooms or 0) + 1
			runState.roomDuration = duration
			if tier and tier > 0 then
				runState.tier = tier
			end
			local store = GetStore()
			if store and store.activeRun then
				store.activeRun.rooms = runState.rooms
				store.activeRun.roomDuration = duration
				store.activeRun.tier = runState.tier
				store.activeRun.boss = runState.boss
			end
			return
		elseif matched then
			RefreshBountifulSnapshot()
			LogRun(matched, tier, duration, runState.deaths, keyUsed, runState.boss, runState.wasBountiful)
		else
			-- ⚠️ ADDED 14 Aug 2026. The delve roster is a hardcoded eleven, so a delve
			-- 12.1 added does not match and its run was silently dropped -- while the
			-- client had just told us its name. That is a free measurement thrown away
			-- at the exact moment we are refusing to ship datamined delve names.
			--
			-- Nothing is logged as a run and no panel changes: an unrecognised delve
			-- must not appear in the history as if we understood it. This only keeps
			-- the name where the next session can read it out of SavedVariables.
			local secret = (issecretvalue ~= nil) and issecretvalue(candidate) == true
			if type(candidate) == "string" and candidate ~= "" and not secret then
				-- The instance id is the column that would let us extend
				-- instanceIDToName above; it is the 8th return of GetInstanceInfo.
				local instanceID
				if GetInstanceInfo then
					local ok, _, _, _, _, _, _, _, id = pcall(GetInstanceInfo)
					instanceID = ok and tonumber(id) or nil
				end
				ns.db = ns.db or {}
				ns.db.unknownDelves = ns.db.unknownDelves or {}
				local seen = ns.db.unknownDelves[candidate]
				ns.db.unknownDelves[candidate] = {
					name = candidate,
					count = ((type(seen) == "table" and seen.count) or 0) + 1,
					lastSeen = (time and time()) or 0,
					instanceID = instanceID,
					tier = tier,
					boss = runState.boss,
				}
			end
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
-- Column widths (design C), multiplied by the content text scale.
local COL_RUNS_W, COL_TIER_W, COL_REC_W = 50, 64, 96
local COL_RUN_TIER_W, COL_RUN_TIME_W, COL_RUN_VS_W = 36, 52, 100
local STAR = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:12|t"

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
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local row = CreateFrame("Button", nil, ui.child)
	row:SetHeight(HEADER_ROW_H * s)

	local arrow = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	arrow:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	arrow:SetPoint("LEFT", row, "LEFT", 2, 0)
	arrow:SetWidth(14)
	arrow:SetJustifyH("LEFT")
	row.arrow = arrow

	-- Design C (29 Oct 2026): columns Delve | Runs | Top Tier | Record there, right-aligned from the right edge.
	local function Col(width, rightOffset)
		local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		fs:SetFontObject(ns.MHScalableFont("GameFontHighlight"))
		fs:SetWidth(width * s)
		fs:SetJustifyH("RIGHT")
		fs:SetWordWrap(false)
		fs:SetPoint("RIGHT", row, "RIGHT", -rightOffset * s, 0)
		return fs
	end
	row.recFS = Col(COL_REC_W, 8)
	row.tierFS = Col(COL_TIER_W, 8 + COL_REC_W + 8)
	row.runsFS = Col(COL_RUNS_W, 8 + COL_REC_W + 8 + COL_TIER_W + 8)

	local nameFS = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	nameFS:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	nameFS:SetPoint("LEFT", arrow, "RIGHT", 4, 0)
	nameFS:SetPoint("RIGHT", row.runsFS, "LEFT", -8, 0)
	nameFS:SetJustifyH("LEFT")
	nameFS:SetWordWrap(false)
	row.nameFS = nameFS

	row.bg = row:CreateTexture(nil, "BACKGROUND")
	row.bg:SetAllPoints()

	-- The Labyrinth's "splits ->": opens the splits window instead of folding the row open.
	local splits = CreateFrame("Button", nil, row)
	splits:SetAllPoints(row.recFS)
	splits:SetScript("OnClick", function()
		if ns.ShowLabSplitsBest then
			ns.ShowLabSplitsBest()
		end
	end)
	splits:Hide()
	row.splitsBtn = splits

	row:SetScript("OnClick", HeaderRow_OnClick)
	return row
end

--- A run row, or a tier-chips line / sub-header (then only `notes` is used, across the whole width when `wide`).
local function CreateRunRow()
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local row = CreateFrame("Frame", nil, ui.child)
	row:SetHeight(RUN_ROW_H * s)
	local function FS(justify)
		local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		fs:SetJustifyH(justify)
		fs:SetWordWrap(false)
		return fs
	end
	row.tierFS = FS("LEFT")
	row.tierFS:SetPoint("LEFT", row, "LEFT", 0, 0)
	row.tierFS:SetWidth(COL_RUN_TIER_W * s)
	row.timeFS = FS("RIGHT")
	row.timeFS:SetPoint("LEFT", row.tierFS, "RIGHT", 4 * s, 0)
	row.timeFS:SetWidth(COL_RUN_TIME_W * s)
	row.vsFS = FS("RIGHT")
	row.vsFS:SetPoint("RIGHT", row, "RIGHT", -8 * s, 0)
	row.vsFS:SetWidth(COL_RUN_VS_W * s)
	row.fs = FS("LEFT")
	row.s = s
	return row
end

--- Lay a run row out as four columns, or as one wide line.
local function SetRunRowWide(row, wide)
	row.fs:ClearAllPoints()
	if wide then
		row.tierFS:SetText("")
		row.timeFS:SetText("")
		row.vsFS:SetText("")
		row.fs:SetPoint("LEFT", row, "LEFT", 0, 0)
		row.fs:SetPoint("RIGHT", row, "RIGHT", -8 * row.s, 0)
	else
		row.fs:SetPoint("LEFT", row.timeFS, "RIGHT", 10 * row.s, 0)
		row.fs:SetPoint("RIGHT", row.vsFS, "LEFT", -8 * row.s, 0)
	end
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

local CC_BAD = "|cffff8a7a"

--- 13:48 (design C), or 1:26:38 for a long Labyrinth run.
local function Clock(sec)
	sec = math.floor((sec or 0) + 0.5)
	if sec <= 0 then
		return "--"
	end
	if sec >= 3600 then
		return ("%d:%02d:%02d"):format(math.floor(sec / 3600), math.floor((sec % 3600) / 60), sec % 60)
	end
	return ("%d:%02d"):format(math.floor(sec / 60), sec % 60)
end

local function TierCount(life)
	local n = 0
	for _ in pairs(life and life.bestByTier or {}) do
		n = n + 1
	end
	return n
end

--- One delve line: name, runs, top tier, the record on that top tier ("splits ->" for the Labyrinth).
local function FillHeaderRow(row, name, life, expanded, kind)
	row.arrow:SetText(expanded and (CC_GOLD .. "v" .. CC_CLOSE) or (CC_GOLD .. ">" .. CC_CLOSE))
	row.nameFS:SetText(CC_BODY .. name .. CC_CLOSE)
	row.runsFS:SetText(CC_BODY .. (life.totalRuns or 0) .. CC_CLOSE)
	local top = life.highestTier or 0
	row.tierFS:SetText(top > 0 and (CC_BODY .. "T" .. top .. CC_CLOSE) or (CC_DIM .. "--" .. CC_CLOSE))
	row.splitsBtn:Hide()
	if kind == "lab" then
		row.recFS:SetText(CC_GOLD .. ns:L("DELVELOG_SPLITS") .. CC_CLOSE)
		row.splitsBtn:Show()
	elseif kind == "ritual" then
		row.recFS:SetText(CC_BODY .. Clock(life.fastestTime) .. CC_CLOSE)
	else
		local rec = life.bestByTier and life.bestByTier[top]
		row.recFS:SetText(rec and (CC_BODY .. Clock(rec) .. CC_CLOSE) or (CC_DIM .. "--" .. CC_CLOSE))
	end
	if expanded then
		row.bg:SetColorTexture(0.16, 0.13, 0.09, 0.9)
	else
		row.bg:SetColorTexture(0.12, 0.10, 0.07, 0.75)
	end
end

--- One run under an open delve: Tier | Time | boss · notes | vs record.
local function FillRunRow(row, run, life, withRecord)
	SetRunRowWide(row, false)
	local tier = run.tier or 0
	row.tierFS:SetText(CC_GOLD .. "T" .. tier .. CC_CLOSE)
	row.timeFS:SetText(CC_BODY .. Clock(run.duration) .. CC_CLOSE)
	local notes = {}
	if run.boss and run.boss ~= "" then
		notes[#notes + 1] = run.boss
	end
	if run.rooms then
		notes[#notes + 1] = ns:L("DELVELOG_LBL_ROOMS") .. " " .. run.rooms
	end
	if (run.deaths or 0) > 0 then
		notes[#notes + 1] = ns:L("DELVELOG_LBL_DEATHS") .. " " .. run.deaths
	end
	if run.keyUsed then
		notes[#notes + 1] = CC_GOOD .. ns:L("DELVELOG_LBL_KEY") .. CC_CLOSE .. CC_DIM
	end
	notes[#notes + 1] = FormatDateTime(run.timestamp)
	row.fs:SetText(CC_DIM .. table.concat(notes, " · ") .. CC_CLOSE)
	local vs = ""
	local best = withRecord and tier > 0 and life.bestByTier and life.bestByTier[tier]
	if withRecord and run.record and run.beat then
		vs = CC_GOOD .. STAR .. " -" .. Clock(run.beat) .. CC_CLOSE
	elseif withRecord and run.firstTier then
		vs = CC_DIM .. (ns:L("DELVELOG_FIRST_TIER_FMT")):format(tier) .. CC_CLOSE
	elseif best and (run.duration or 0) > 0 then
		local diff = run.duration - best
		if diff > 0 then
			vs = CC_BAD .. "+" .. Clock(diff) .. CC_CLOSE
		elseif diff == 0 then
			vs = CC_GOOD .. STAR .. CC_CLOSE
		end
	end
	row.vsFS:SetText(vs)
end

function Refresh()
	if not ui or not ui.child then
		return
	end

	-- Content-tekstschaal: rij-hoogtes + Y-stappen schalen mee zodat grotere tekst
	-- niet overlapt. Bij schaal 1.0 zijn alle stappen identiek aan voorheen.
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local headerStep = HEADER_ROW_H * s
	local runStep = RUN_ROW_H * s
	local indent = 24 * s

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

	-- Ritual-runs (RitualLog.lua) tellen mee in de totalen + krijgen een eigen
	-- sectie onderaan. Zelfde run-shape, dus dezelfde rij-opmaak.
	local ritEntries = ns.GetRitualLogEntries and ns.GetRitualLogEntries() or {}
	for _, rit in ipairs(ritEntries) do
		local life = rit.entry and rit.entry.lifetime
		if life then
			totalRuns = totalRuns + (life.totalRuns or 0)
			totalDeaths = totalDeaths + (life.totalDeaths or 0)
			totalDur = totalDur + (life.totalDuration or 0)
		end
	end

	-- Design C: four boxes. Records = how many (delve, Tier) records you hold.
	local records = 0
	for _, key in ipairs(keys) do
		records = records + TierCount(delves[key].lifetime)
	end
	ui.stats[1].value:SetText(tostring(totalRuns))
	ui.stats[2].value:SetText(FormatDuration(totalDur))
	ui.stats[3].value:SetText(tostring(records))
	ui.stats[4].value:SetText(tostring(totalDeaths))

	for _, r in ipairs(headerRowPool) do
		r:Hide()
	end
	for _, r in ipairs(runRowPool) do
		r:Hide()
	end
	if ui.colHead then
		ui.colHead:Hide()
	end

	local width = ui.child:GetWidth()
	if not width or width <= 0 then
		return
	end

	local y = 4

	if #keys == 0 and #ritEntries == 0 then
		ui.empty:Show()
		ui.empty:ClearAllPoints()
		ui.empty:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 2, -y)
		ui.empty:SetWidth(math.max(width - 4, 1))
		ui.child:SetHeight(math.max(y + (ui.empty:GetStringHeight() or 16) + 8, 1))
		return
	end
	ui.empty:Hide()

	-- Column header (design C): Delve | Runs | Top Tier | Record there.
	if not ui.colHead then
		ui.colHead = CreateHeaderRow()
		ui.colHead:EnableMouse(false)
		ui.colHead.bg:SetColorTexture(0, 0, 0, 0)
	end
	local ch = ui.colHead
	ch:ClearAllPoints()
	ch:SetHeight(runStep)
	ch.arrow:SetText("")
	ch.splitsBtn:Hide()
	for fs, key in pairs({ [ch.nameFS] = "DELVELOG_COL_DELVE", [ch.runsFS] = "DELVELOG_COL_RUNS",
		[ch.tierFS] = "DELVELOG_COL_TOPTIER", [ch.recFS] = "DELVELOG_COL_RECORD" }) do
		fs:SetText(CC_DIM .. ns:L(key) .. CC_CLOSE)
	end
	ch:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
	ch:SetPoint("RIGHT", ui.child, "RIGHT", -4, 0)
	ch:Show()
	y = y + runStep + 2 * s

	local hUsed, rUsed = 0, 0
	for _, key in ipairs(keys) do
		local entry = delves[key]
		local life = entry.lifetime
		local expanded = expandedByKey[key] and true or false
		local isLab = ROOM_RUN_DELVES[key] and true or false

		hUsed = hUsed + 1
		local row = AcquireHeaderRow(hUsed)
		row:SetHeight(headerStep)
		row._mhKey = key -- nodig voor uitklappen (werd nooit gezet — bestaande bug)
		FillHeaderRow(row, key, life, expanded, isLab and "lab" or nil)
		row:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
		row:SetPoint("RIGHT", ui.child, "RIGHT", -4, 0)
		row:Show()
		y = y + headerStep + 2 * s

		if expanded and entry.recent then
			-- The record per Tier, lowest first: "T8 7:55   T9 9:31 …".
			local tiers = {}
			for t in pairs(life.bestByTier or {}) do
				tiers[#tiers + 1] = t
			end
			table.sort(tiers)
			if #tiers > 0 then
				local chips = {}
				for _, t in ipairs(tiers) do
					chips[#chips + 1] = CC_DIM .. "T" .. t .. CC_CLOSE .. " " .. CC_BODY .. Clock(life.bestByTier[t]) .. CC_CLOSE
				end
				rUsed = rUsed + 1
				local crow = AcquireRunRow(rUsed)
				crow:SetHeight(runStep)
				SetRunRowWide(crow, true)
				crow.fs:SetText(table.concat(chips, "     "))
				crow:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent, -y)
				crow:SetPoint("RIGHT", ui.child, "RIGHT", -4, 0)
				crow:Show()
				y = y + runStep + 4 * s
			end
			-- Sub-header: Tier | Time | Boss · notes | vs record.
			rUsed = rUsed + 1
			local hrow = AcquireRunRow(rUsed)
			hrow:SetHeight(runStep)
			SetRunRowWide(hrow, false)
			hrow.tierFS:SetText(CC_DIM .. ns:L("DELVELOG_COL_TIER") .. CC_CLOSE)
			hrow.timeFS:SetText(CC_DIM .. ns:L("DELVELOG_COL_TIME") .. CC_CLOSE)
			hrow.fs:SetText(CC_DIM .. ns:L("DELVELOG_COL_NOTES") .. CC_CLOSE)
			hrow.vsFS:SetText(isLab and "" or (CC_DIM .. ns:L("DELVELOG_COL_VS") .. CC_CLOSE))
			hrow:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent, -y)
			hrow:SetPoint("RIGHT", ui.child, "RIGHT", -4, 0)
			hrow:Show()
			y = y + runStep + 1 * s
			for _, run in ipairs(entry.recent) do
				rUsed = rUsed + 1
				local rrow = AcquireRunRow(rUsed)
				rrow:SetHeight(runStep)
				FillRunRow(rrow, run, life, not isLab)
				rrow:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent, -y)
				rrow:SetPoint("RIGHT", ui.child, "RIGHT", -4, 0)
				rrow:Show()
				y = y + runStep + 1 * s
			end
			y = y + 6 * s
		end
	end

	-- Rituals-sectie (zelfde rij-opmaak; eigen "ritual:"-keys voor uitklappen).
	if #ritEntries > 0 then
		rUsed = rUsed + 1
		local secRow = AcquireRunRow(rUsed)
		secRow:SetHeight(runStep)
		SetRunRowWide(secRow, true)
		secRow.fs:SetText(CC_GOLD .. ns:L("DELVELOG_SEC_RITUALS") .. CC_CLOSE)
		secRow:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -(y + 6 * s))
		secRow:SetPoint("RIGHT", ui.child, "RIGHT", -4, 0)
		secRow:Show()
		y = y + 6 * s + runStep + 2 * s
		for _, rit in ipairs(ritEntries) do
			local entry = rit.entry
			local life = entry.lifetime
			local rkey = "ritual:" .. rit.name
			local expanded = expandedByKey[rkey] and true or false
			hUsed = hUsed + 1
			local row = AcquireHeaderRow(hUsed)
			row:SetHeight(headerStep)
			row._mhKey = rkey
			FillHeaderRow(row, rit.name, life, expanded, "ritual")
			row:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
			row:SetPoint("RIGHT", ui.child, "RIGHT", -4, 0)
			row:Show()
			y = y + headerStep
			if expanded and entry.recent then
				for _, run in ipairs(entry.recent) do
					rUsed = rUsed + 1
					local rrow = AcquireRunRow(rUsed)
					rrow:SetHeight(runStep)
					FillRunRow(rrow, run, life, false)
					rrow:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent, -y)
					rrow:SetPoint("RIGHT", ui.child, "RIGHT", -4, 0)
					rrow:Show()
					y = y + runStep + 1 * s
				end
				y = y + 4 * s
			end
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
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("TAB_DELVE_LOG"))

	-- Deliberately understated: a small grey text link in the corner rather
	-- than a prominent button, so wiping history is reachable but never an easy
	-- accidental click. Brightens on hover; still gated behind a confirm popup.
	local clearBtn = CreateFrame("Button", nil, panel)
	clearBtn:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -SIDE_PAD, -TOP_PAD - 2)
	local clearText = clearBtn:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	clearText:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	clearText:SetPoint("RIGHT", clearBtn, "RIGHT", 0, 0)
	clearText:SetText(ns:L("DELVELOG_CLEAR"))
	clearText:SetTextColor(0.5, 0.5, 0.5)
	clearBtn.text = clearText
	clearBtn:SetSize(math.max(clearText:GetStringWidth() + 4, 10), math.max(16, (clearText:GetStringHeight() or 16)))
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
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	subtitle:SetText(ns:L("DELVELOG_SUBTITLE"))

	-- Design C: four boxes (Runs / Time in delves / Records / Deaths) instead of one line of text.
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local statsRow = CreateFrame("Frame", nil, panel)
	statsRow:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	statsRow:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	statsRow:SetHeight(44 * s)
	local stats = {}
	local STAT_KEYS = { "DELVELOG_STAT_RUNS", "DELVELOG_STAT_TIME", "DELVELOG_STAT_RECORDS", "DELVELOG_STAT_DEATHS" }
	for i, key in ipairs(STAT_KEYS) do
		local b = CreateFrame("Frame", nil, statsRow, "BackdropTemplate")
		if b.SetBackdrop then
			b:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
			b:SetBackdropColor(0.13, 0.11, 0.08, 0.9)
		end
		b.label = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		b.label:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		b.label:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
		b.label:SetPoint("TOPLEFT", 8, -5)
		b.label:SetText(ns:L(key))
		b.label._mhKey = key
		b.value = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
		b.value:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
		b.value:SetPoint("BOTTOMLEFT", 8, 5)
		if i == 3 then
			b.value:SetTextColor(0.45, 0.85, 0.45)
		end
		stats[i] = b
	end
	local function LayoutStats()
		local w = statsRow:GetWidth() or 0
		if w <= 0 then
			return
		end
		local bw = (w - 3 * 8) / 4
		for i, b in ipairs(stats) do
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", statsRow, "TOPLEFT", (i - 1) * (bw + 8), 0)
			b:SetSize(bw, 44 * s)
		end
	end
	statsRow:SetScript("OnSizeChanged", LayoutStats)
	LayoutStats()

	-- Under the list: why a Tier 8 run never beats your Tier 11 time.
	local foot = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	foot:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	foot:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", SIDE_PAD, 12)
	foot:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	foot:SetJustifyH("LEFT")
	foot:SetWordWrap(true)
	foot:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	foot:SetText(ns:L("DELVELOG_FOOT"))

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperDelveLogScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", statsRow, "BOTTOMLEFT", 0, -10)
	scroll:SetPoint("RIGHT", panel, "RIGHT", -30, 0)
	scroll:SetPoint("BOTTOM", foot, "TOP", 0, 8)

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)

	local empty = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	empty:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	empty:SetJustifyH("LEFT")
	empty:SetWordWrap(true)
	empty:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	empty:SetText(ns:L("DELVELOG_EMPTY"))
	empty:Hide()

	ui = {
		panel = panel,
		title = title,
		subtitle = subtitle,
		stats = stats,
		foot = foot,
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
			ui.foot:SetText(ns:L("DELVELOG_FOOT"))
			for _, b in ipairs(ui.stats) do
				b.label:SetText(ns:L(b.label._mhKey))
			end
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
