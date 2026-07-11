--[[
	Midnight Helper — Ritual Log (Rob-wens 15 jun: "Delve & Ritual Log").

	Logt ritual-scenario-runs (site, tier indien leesbaar, tijd, deaths, voltooid)
	met dezelfde aanpak als DelveHistory, en in EXACT hetzelfde run-model
	({ lifetime = {...}, recent = {...} }) zodat het Delve-Log-paneel de bestaande
	rij-opmaak kan hergebruiken (geen dubbele UI).

	never-lie: Spoils/score zijn waarschijnlijk niet betrouwbaar leesbaar → die
	loggen we niet. Tier proberen we te lezen (1-5); lukt het niet, dan 0/onbekend.
	Detectie: IsInInstance()=="scenario" + scenario-naam matcht een bekende ritual-
	site. Voltooid = SCENARIO_COMPLETED; vroegtijdig weg = niet gelogd.

	Heeft een echte ritual-run nodig om in-game te bevestigen wat leesbaar is.
]]

local _, ns = ...

local MAX_RECENT = 20
local MAX_RESUME_AGE = 6 * 3600

-- Bekende ritual-sites (substring-match op de scenario-naam → nette weergavenaam).
-- Uitbreidbaar zodra er meer sites bevestigd zijn.
local KNOWN_RITUALS = {
	{ match = "Broken Throne", name = "Broken Throne" },
	{ match = "Daggerspine", name = "Daggerspine Point" },
}

--------------------------------------------------------------------------------
-- Store (per character)
--------------------------------------------------------------------------------

local function GetStore()
	if not ns.db then
		return nil
	end
	ns.db.ritualLog = ns.db.ritualLog or {}
	local guid = UnitGUID("player")
	if not guid then
		return nil
	end
	local store = ns.db.ritualLog[guid]
	if not store then
		store = { name = UnitName("player"), sites = {} }
		ns.db.ritualLog[guid] = store
	end
	store.sites = store.sites or {}
	store.name = UnitName("player") or store.name
	return store
end

--------------------------------------------------------------------------------
-- Detectie
--------------------------------------------------------------------------------

local function CurrentRitualName()
	local _, instanceType = IsInInstance()
	if instanceType ~= "scenario" then
		return nil
	end
	local sname
	if C_ScenarioInfo and C_ScenarioInfo.GetScenarioInfo then
		local ok, info = pcall(C_ScenarioInfo.GetScenarioInfo)
		if ok and type(info) == "table" then
			sname = info.name
		end
	end
	if (not sname or sname == "") and C_Scenario and C_Scenario.GetInfo then
		local ok, n = pcall(C_Scenario.GetInfo)
		if ok then
			sname = n
		end
	end
	if type(sname) ~= "string" or sname == "" then
		return nil
	end
	local lower = sname:lower()
	for _, r in ipairs(KNOWN_RITUALS) do
		if lower:find(r.match:lower(), 1, true) then
			return r.name
		end
	end
	return nil
end

-- Ritual-tier (1-5) als die leesbaar is uit de instance-difficulty; anders nil.
local function DetectRitualTier()
	local _, _, _, difficultyName = GetInstanceInfo()
	if type(difficultyName) == "string" and difficultyName ~= "" then
		local m = difficultyName:match("(%d+)")
		local n = m and tonumber(m)
		if n and n >= 1 and n <= 5 then
			return n
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- Run-tracking
--------------------------------------------------------------------------------

local runState = { inRun = false, name = nil, startTime = 0, deaths = 0, tier = 0 }

local function BeginRun(name)
	runState.inRun = true
	runState.name = name
	runState.startTime = GetTime()
	runState.deaths = 0
	runState.tier = DetectRitualTier() or 0
	local store = GetStore()
	if store then
		store.activeRun = {
			name = name,
			startTime = runState.startTime,
			startedAt = time(),
			deaths = 0,
			tier = runState.tier,
		}
	end
end

local function EndRun()
	runState.inRun = false
	runState.name = nil
	runState.startTime = 0
	runState.deaths = 0
	runState.tier = 0
	local store = GetStore()
	if store then
		store.activeRun = nil
	end
end

local function LogRun(name, tier, duration, deaths)
	local store = GetStore()
	if not (name and store) then
		return
	end
	local entry = store.sites[name]
	if not entry then
		entry = {
			lifetime = { totalRuns = 0, totalDeaths = 0, totalDuration = 0, highestTier = 0, fastestTime = 0 },
			recent = {},
		}
		store.sites[name] = entry
	end
	local life = entry.lifetime
	life.totalRuns = (life.totalRuns or 0) + 1
	life.totalDeaths = (life.totalDeaths or 0) + (deaths or 0)
	life.totalDuration = (life.totalDuration or 0) + (duration or 0)
	if tier and tier > (life.highestTier or 0) then
		life.highestTier = tier
	end
	if duration and duration > 0 and (not life.fastestTime or life.fastestTime == 0 or duration < life.fastestTime) then
		life.fastestTime = duration
	end
	-- Zelfde run-shape als DelveHistory (tier/duration/deaths/keyUsed/boss/
	-- timestamp) zodat het paneel BuildRunText kan hergebruiken. keyUsed/boss n.v.t.
	table.insert(entry.recent, 1, {
		tier = tier or 0,
		duration = duration or 0,
		deaths = deaths or 0,
		keyUsed = false,
		timestamp = time(),
	})
	while #entry.recent > MAX_RECENT do
		table.remove(entry.recent)
	end
	-- Post-run scorecard hook (Modules/RunScorecard.lua), same shape as DelveHistory.
	if ns.OnRitualRunLogged then
		ns.OnRitualRunLogged({
			name = name,
			tier = tier or 0,
			duration = duration or 0,
			deaths = deaths or 0,
			runs = life.totalRuns or 1,
			fastestTime = life.fastestTime or 0,
			totalDuration = life.totalDuration or 0,
			isRitual = true,
		})
	end
	if ns.RefreshDelveLogPanel then
		ns.RefreshDelveLogPanel()
	end
end

--------------------------------------------------------------------------------
-- Publieke accessor voor het paneel
--------------------------------------------------------------------------------

-- Gesorteerde lijst { { name=, entry= }, ... } met ten minste één gelogde run.
function ns.GetRitualLogEntries()
	local out = {}
	local store = GetStore()
	if not store then
		return out
	end
	for name, entry in pairs(store.sites) do
		if entry and entry.lifetime and (entry.lifetime.totalRuns or 0) > 0 then
			out[#out + 1] = { name = name, entry = entry }
		end
	end
	table.sort(out, function(a, b)
		return (a.name or "") < (b.name or "")
	end)
	return out
end

function ns.ClearRitualLog()
	local store = GetStore()
	if store then
		wipe(store.sites)
	end
	if ns.RefreshDelveLogPanel then
		ns.RefreshDelveLogPanel()
	end
end

--------------------------------------------------------------------------------
-- Tracker (eigen frame, los van de dispatcher — zoals DelveHistory)
--------------------------------------------------------------------------------

local function TryBegin(source)
	local name = CurrentRitualName()
	if not name then
		if runState.inRun then
			EndRun()
		end
		return
	end
	-- Verse world-entry (geen /reload) = nieuwe instance → nieuwe run.
	local fresh = (source == "fresh")
	if (not runState.inRun) or runState.name ~= name or fresh then
		local store = GetStore()
		local saved = store and store.activeRun
		if
			source == "reload"
			and saved
			and saved.name == name
			and saved.startTime
			and saved.startTime <= GetTime()
			and saved.startedAt
			and (time() - saved.startedAt) < MAX_RESUME_AGE
		then
			runState.inRun = true
			runState.name = name
			runState.startTime = saved.startTime
			runState.deaths = saved.deaths or 0
			runState.tier = saved.tier or 0
		else
			if store then
				store.activeRun = nil
			end
			BeginRun(name)
		end
	elseif (not runState.tier) or runState.tier <= 0 then
		runState.tier = DetectRitualTier() or 0
		local store = GetStore()
		if store and store.activeRun then
			store.activeRun.tier = runState.tier
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("SCENARIO_UPDATE")
f:RegisterEvent("SCENARIO_COMPLETED")
f:RegisterEvent("PLAYER_DEAD")
f:SetScript("OnEvent", function(_, event, arg1, arg2)
	if event == "PLAYER_ENTERING_WORLD" then
		local isReload = arg2 and true or false
		TryBegin(isReload and "reload" or "fresh")
	elseif event == "ZONE_CHANGED_NEW_AREA" or event == "SCENARIO_UPDATE" then
		TryBegin(event)
	elseif event == "PLAYER_DEAD" then
		if runState.inRun then
			runState.deaths = runState.deaths + 1
			-- Ook persistent opslaan: anders reset een /reload de death naar 0
			-- (resume leest store.activeRun.deaths, die nooit werd bijgewerkt).
			local store = GetStore()
			if store and store.activeRun then
				store.activeRun.deaths = runState.deaths
			end
		end
	elseif event == "SCENARIO_COMPLETED" then
		if runState.inRun then
			local name = runState.name
			local duration = (runState.startTime > 0) and math.max(0, math.floor(GetTime() - runState.startTime)) or 0
			if duration > MAX_RESUME_AGE then
				duration = 0
			end
			local tier = (runState.tier and runState.tier > 0) and runState.tier or (DetectRitualTier() or 0)
			LogRun(name, tier, duration, runState.deaths)
			EndRun()
		end
	end
end)
