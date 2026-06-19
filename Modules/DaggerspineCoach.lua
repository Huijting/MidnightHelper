--[[
	Daggerspine Point ritual-boss-scaffold (14 jun). De tweede Ritual Site in de
	rotatie. We registreren de boss-entry vast (picker + 3D-model + stage-info)
	zodat het klaarstaat zodra Daggerspine de actieve week is; de exacte
	abilities + scenario/stepIDs vullen we uit Robs eerste run (spy + death
	recaps), net zoals we de Broken Throne hebben opgebouwd.

	Web-geverifieerd (14 jun datamining): zone 16939; eindboss Lady Selen'vjar
	npc 257498 (Ritual Chest object 602746); stage 2 = void-empowered Mindbreaker
	(npc nog te bevestigen). Stages: Ritual Roles / Beast From the Deep /
	Summoner's Fall.

	Auto-trigger ACTIEF (Rob in-game 17 jun, beide stages gevangen):
	  SCENARIO_ID = 3267 (Broken Throne = 3236)
	  stage 2 "Beast From the Deep" (Empowered Mindbreaker) = stepID 16532 ✅
	  stage 3 "Summoner's Fall" (eindboss Lady Selen'vjar)   = stepID 16533 ✅
	Zelfde stage-trigger als RitualBossCoach (OnScenarioTick): bij een nieuwe
	boss-step het venster auto-openen + meebladeren; X = stil voor díé boss.
]]

local _, ns = ...

local ENTRY = {
	key = "ritual_daggerspine",
	name = "Daggerspine Point",
	bosses = {
		{
			key = "mindbreaker",
			name = "Empowered Mindbreaker",
			-- Stage 2 "Beast From the Deep" (stepID 16532, Rob 17 jun). De exacte
			-- boss-npcID is nog niet gedataminet; als stand-in tonen we het model
			-- van de Void-Infused Mindbreaker (npc 260022) zodat het paneel niet
			-- leeg is. Een in-game geleerd ID wint altijd van de seed.
			stepIDs = { [16532] = true },
			seedCreatureId = 260022,
		},
		{
			key = "selenvjar",
			name = "Lady Selen'vjar",
			-- Stage 3 "Summoner's Fall"; web-geverifieerd npc 257498.
			-- stepID 16533 in-game gevangen (Rob, 17 jun).
			stepIDs = { [16533] = true },
			seedCreatureId = 257498,
		},
	},
}

ns.CUSTOM_BOSS_ENTRIES = ns.CUSTOM_BOSS_ENTRIES or {}
ns.CUSTOM_BOSS_ENTRIES[ENTRY.key] = ENTRY
if type(ns.DUNGEON_TIPS) == "table" then
	ns.DUNGEON_TIPS[ENTRY.key] = {
		mindbreaker = { steps = "RITUAL_BOSS_MINDBREAKER_STEPS" },
		selenvjar = { steps = "RITUAL_BOSS_SELENVJAR_STEPS" },
	}
end

--------------------------------------------------------------------------------
-- Auto-open trigger (Rob in-game 17 jun) — zelfde stage-patroon als
-- RitualBossCoach. SCENARIO_ID 3267; boss-step → venster + meebladeren.
--------------------------------------------------------------------------------
local SCENARIO_ID = 3267

local inScenario = false
local lastStepID = nil
local shownForStep = {} -- per scenario-bezoek éénmaal auto-openen per step

local function IsSecretValue(value)
	return issecretvalue ~= nil and value ~= nil and issecretvalue(value) == true
end

local function LearnedIds()
	if not ns.db then
		return nil
	end
	if type(ns.db.daggerspineNpcIds) ~= "table" then
		ns.db.daggerspineNpcIds = {}
	end
	return ns.db.daggerspineNpcIds
end

local function FindBossForStep(stepID)
	if not stepID then
		return nil
	end
	for _, b in ipairs(ENTRY.bosses) do
		if b.stepIDs and b.stepIDs[stepID] then
			return b
		end
	end
	return nil
end

local function ApplyLearnedModel(b)
	local learned = LearnedIds()
	b.creatureId = (learned and learned[b.key]) or b.seedCreatureId
end

-- npcID van boss1 leren tijdens de bijbehorende stage (rares-recept; in-game
-- geleerd ID wint van de seed). 12.x: boss-GUID/naam kan secret zijn → guarden.
local function NpcIdFromGUID(guid)
	if type(guid) ~= "string" or IsSecretValue(guid) then
		return nil
	end
	local kind, _, _, _, _, npcId = strsplit("-", guid)
	if kind == "Creature" or kind == "Vehicle" then
		return tonumber(npcId)
	end
	return nil
end

local function TryLearnBossUnits()
	if not inScenario then
		return
	end
	local b = FindBossForStep(lastStepID)
	if not b then
		return
	end
	for i = 1, 5 do
		local unit = "boss" .. i
		if UnitExists and UnitExists(unit) then
			local id = NpcIdFromGUID(UnitGUID and UnitGUID(unit))
			if id and i == 1 then
				local learned = LearnedIds()
				if learned and learned[b.key] ~= id then
					learned[b.key] = id
					b.creatureId = id
					if ns.RefreshDungeonBossWindow then
						ns.RefreshDungeonBossWindow()
					end
				end
			end
		end
	end
end

local function LeaveScenario()
	if not inScenario then
		return
	end
	inScenario = false
	lastStepID = nil
	wipe(shownForStep)
	if ns.HideBossWindowForEntry then
		ns.HideBossWindowForEntry(ENTRY.key)
	end
end

local function CurrentScenario()
	if not (C_ScenarioInfo and C_ScenarioInfo.GetScenarioInfo) then
		return nil
	end
	local ok, info = pcall(C_ScenarioInfo.GetScenarioInfo)
	if ok and type(info) == "table" and info.scenarioID == SCENARIO_ID then
		return info
	end
	return nil
end

local function OnScenarioTick()
	local info = CurrentScenario()
	if not info then
		LeaveScenario()
		return
	end
	inScenario = true
	local ok, step = pcall(C_ScenarioInfo.GetScenarioStepInfo)
	step = (ok and type(step) == "table") and step or nil
	local stepID = step and step.stepID
	if stepID and stepID ~= lastStepID then
		lastStepID = stepID
		local b = FindBossForStep(stepID)
		if b and not shownForStep[stepID] then
			shownForStep[stepID] = true
			-- X = alléén die ene boss met rust (per-boss, zelfde regel als dungeons).
			if not (ns.IsBossWindowSuppressedFor and ns.IsBossWindowSuppressedFor(ENTRY.key, b.key)) then
				ApplyLearnedModel(b)
				if ns.ShowBossWindowForEntry then
					ns.ShowBossWindowForEntry(ENTRY, b.key)
				end
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("SCENARIO_UPDATE")
f:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
f:RegisterEvent("SCENARIO_COMPLETED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
f:SetScript("OnEvent", function(_, event)
	if event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
		TryLearnBossUnits()
		return
	end
	if event == "PLAYER_ENTERING_WORLD" and C_Timer and C_Timer.After then
		C_Timer.After(2, OnScenarioTick) -- scenario-info is vlak na een load vaak leeg
		return
	end
	OnScenarioTick()
end)
