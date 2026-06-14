--[[
	Ritual Boss Coach (Rob, 12 jun): het zwevende boss-venster hergebruikt
	in de Broken Throne-ritual (scenarioID 3236, in-game bevestigd). De
	trigger is scenario-stap-gebaseerd (C_ScenarioInfo) — dat werkt dus ÓÓK
	als scenario-bosses geen ENCOUNTER_START blijken af te vuren (nog
	onbevestigd; de spy hieronder beantwoordt precies die vraag).

	Never-lie: alleen de Corrupted Amani Dragonhawk heeft geverifieerde
	stappen (Robs death recaps 12 jun + Wowhead-tooltips). Andere stages
	komen pas in beeld zodra we ze écht kennen; de spy verzamelt daarvoor
	automatisch data tijdens Robs runs (stages, encounter-IDs, boss-npcIDs)
	in SavedVariables — geen /dump-huiswerk meer.

	Het boss-model is zelflerend (rares-recept): npcID wordt alléén geleerd
	van het boss1-unitframe terwijl de bijbehorende stage actief is.

	/mh ritualboss = venster handmatig togglen (testen buiten de ritual)
	/mh ritualspy  = verzamelde spy-data dumpen
]]

local _, ns = ...

local SCENARIO_ID = 3236

-- Synthetische "dungeon"-entry voor het boss-venster. Eigennamen blijven
-- EN (bestandsconventie); de tips-keys staan in Locales/RitualTips.lua.
-- Volledige stage-map "A Corrupted Path" (Robs spy-run, 12 jun):
--   stage 1 = step 16391 "Void Reversal" (objectives, geen boss)
--   stage 2 = step 16393 "Corrupted Beast" (mini-boss; Dragonhawk —
--             Wowheads "can spawn" suggereert mogelijk een pool)
--   stage 3 = step 16394 "Corruptor's End" (eindboss Ger'lok)
-- Robs run logde GEEN ENCOUNTER_START/END en geen boss-frames →
-- stage-triggering is hier de enige route, en model-IDs komen uit seeds.
local ENTRY = {
	key = "ritual_brokenthrone",
	name = "The Broken Throne",
	bosses = {
		{
			key = "dragonhawk",
			name = "Corrupted Amani Dragonhawk",
			-- Stage 2 "Corrupted Beast" (stepID 16393; Rob, 12 jun, in-game).
			stepIDs = { [16393] = true },
			-- Model-seed: Wowhead npc=255653, onafhankelijk bevestigd door
			-- Petopia (12 jun). Een in-game geleerd ID wint altijd van de seed.
			seedCreatureId = 255653,
		},
		{
			key = "gerlok",
			name = "Faithbreaker Ger'lok",
			-- Stage 3 "Corruptor's End" (stepID 16394; Robs spy, 12 jun).
			stepIDs = { [16394] = true },
			-- Model-seed: Wowhead npc=257284 + Warcraft Wiki (eindboss
			-- Broken Throne, <Twilight Blade Commander>).
			seedCreatureId = 257284,
		},
	},
}

-- Registraties zodat venster/Chat/Share de bestaande route gebruiken.
ns.CUSTOM_BOSS_ENTRIES = ns.CUSTOM_BOSS_ENTRIES or {}
ns.CUSTOM_BOSS_ENTRIES[ENTRY.key] = ENTRY
if type(ns.DUNGEON_TIPS) == "table" then
	ns.DUNGEON_TIPS[ENTRY.key] = {
		dragonhawk = { steps = "RITUAL_BOSS_DRAGONHAWK_STEPS" },
		gerlok = { steps = "RITUAL_BOSS_GERLOK_STEPS" },
	}
end

local inScenario = false
local lastStepID = nil
local shownForStep = {} -- per scenario-bezoek éénmaal auto-openen per step

-- Cast-alerts (idee uit RitualAlert; spell-IDs uit 14-jun datamining). Terwijl we
-- in het Broken-Throne-scenario zitten, flasht een waarschuwing zodra de boss/add
-- een bekende spell cast. De CLEU-listener (clf) draait alléén tijdens het
-- scenario (in OnScenarioTick aan, in LeaveScenario uit) — geen wereldwijde
-- combat-log-belasting. Per spell ~3s throttle.
local ALERT_SPELLS = {
	[1284125] = "RITUAL_ALERT_BINDING_NEBULA", -- Binding Nebula (live)
	[1284106] = "RITUAL_ALERT_BINDING_NEBULA", -- Binding Nebula (PTR)
	[1284081] = "RITUAL_ALERT_DISSONANT", -- Dissonant Reflections (live)
	[1284085] = "RITUAL_ALERT_DISSONANT", -- Dissonant Reflections (PTR)
}
local alertFrame
local lastAlertAt = {}

local function FlashAlert(msg)
	if not alertFrame then
		local a = CreateFrame("Frame", "MidnightHelperRitualAlert", UIParent)
		a:SetSize(700, 60)
		a:SetPoint("TOP", UIParent, "TOP", 0, -200)
		a:SetFrameStrata("HIGH")
		a:Hide()
		local fs = a:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
		fs:SetPoint("CENTER")
		fs:SetTextColor(1, 0.3, 0.3)
		a.text = fs
		a.anim = a:CreateAnimationGroup()
		local f1 = a.anim:CreateAnimation("Alpha")
		f1:SetFromAlpha(0); f1:SetToAlpha(1); f1:SetDuration(0.15); f1:SetOrder(1)
		local f2 = a.anim:CreateAnimation("Alpha")
		f2:SetFromAlpha(1); f2:SetToAlpha(1); f2:SetDuration(2.2); f2:SetOrder(2)
		local f3 = a.anim:CreateAnimation("Alpha")
		f3:SetFromAlpha(1); f3:SetToAlpha(0); f3:SetDuration(0.6); f3:SetOrder(3)
		a.anim:SetScript("OnFinished", function() a:Hide() end)
		alertFrame = a
	end
	alertFrame.text:SetText(msg)
	alertFrame:Show()
	alertFrame.anim:Stop()
	alertFrame.anim:Play()
	if PlaySound and SOUNDKIT and SOUNDKIT.RAID_WARNING then
		pcall(PlaySound, SOUNDKIT.RAID_WARNING, "Master")
	end
end

local function OnCombatLog()
	if not inScenario then
		return
	end
	local _, sub, _, _, _, _, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
	if sub ~= "SPELL_CAST_START" and sub ~= "SPELL_CAST_SUCCESS" then
		return
	end
	local key = spellID and ALERT_SPELLS[spellID]
	if not key then
		return
	end
	local now = (GetTime and GetTime()) or 0
	if (lastAlertAt[spellID] or 0) + 3 > now then
		return
	end
	lastAlertAt[spellID] = now
	FlashAlert(ns:L(key))
end

local clf = CreateFrame("Frame")
clf:SetScript("OnEvent", OnCombatLog)

local function Spy()
	if not ns.db then
		return nil
	end
	if type(ns.db.ritualBossSpy) ~= "table" then
		ns.db.ritualBossSpy = {}
	end
	return ns.db.ritualBossSpy
end

local function LearnedIds()
	if not ns.db then
		return nil
	end
	if type(ns.db.ritualBossNpcIds) ~= "table" then
		ns.db.ritualBossNpcIds = {}
	end
	return ns.db.ritualBossNpcIds
end

local function SpyLog(line)
	local st = Spy()
	if st then
		st.log = st.log or {}
		st.log[#st.log + 1] = date("%d-%m %H:%M:%S ") .. line
		while #st.log > 80 do
			table.remove(st.log, 1)
		end
	end
	if ns.db and ns.db.ui and ns.db.ui.debug then
		print("|cffffcc00MH-spy:|r " .. line)
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

local function NpcIdFromGUID(guid)
	if type(guid) ~= "string" then
		return nil
	end
	local kind, _, _, _, _, npcId = strsplit("-", guid)
	if kind == "Creature" or kind == "Vehicle" then
		return tonumber(npcId)
	end
	return nil
end

-- npcID leren van boss-unitframes; geleerd wordt alléén boss1 tijdens de
-- bijbehorende stage (nooit op afstand gokken — rares-les). Alle frames
-- worden wel gelogd, dat is precies de data die we nog zochten.
local function TryLearnBossUnits()
	if not inScenario then
		return
	end
	local b = FindBossForStep(lastStepID)
	for i = 1, 5 do
		local unit = "boss" .. i
		if UnitExists and UnitExists(unit) then
			local id = NpcIdFromGUID(UnitGUID and UnitGUID(unit))
			local nm = UnitName and UnitName(unit)
			if id then
				SpyLog(("boss-unit %s: %s (npc %d)"):format(unit, tostring(nm), id))
				if b and i == 1 then
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
end

local function LeaveScenario()
	if not inScenario then
		return
	end
	inScenario = false
	lastStepID = nil
	wipe(shownForStep)
	clf:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	if ns.HideBossWindowForEntry then
		ns.HideBossWindowForEntry(ENTRY.key)
	end
	SpyLog("scenario verlaten/afgerond")
end

local function OnScenarioTick()
	local info = CurrentScenario()
	if not info then
		LeaveScenario()
		return
	end
	if not inScenario then
		inScenario = true
		clf:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		SpyLog(("scenario start: %s (id %d, %s stages)"):format(
			tostring(info.name), info.scenarioID, tostring(info.numStages)))
	end
	local ok, step = pcall(C_ScenarioInfo.GetScenarioStepInfo)
	step = (ok and type(step) == "table") and step or nil
	local stepID = step and step.stepID
	if stepID and stepID ~= lastStepID then
		lastStepID = stepID
		SpyLog(("stage %s/%s — step %d: %s"):format(
			tostring(info.currentStage), tostring(info.numStages),
			stepID, tostring(step.title)))
		local b = FindBossForStep(stepID)
		if b and not shownForStep[stepID] then
			shownForStep[stepID] = true
			-- X tijdens deze run = met rust laten (zelfde regel als dungeons).
			if not (ns.IsBossWindowSuppressedFor
				and ns.IsBossWindowSuppressedFor(ENTRY.key)) then
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
f:RegisterEvent("ENCOUNTER_START")
f:RegisterEvent("ENCOUNTER_END")
f:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
f:SetScript("OnEvent", function(_, event, arg1, arg2)
	if event == "ENCOUNTER_START" or event == "ENCOUNTER_END" then
		-- DE openstaande vraag: vuren scenario-bosses encounters af?
		if inScenario then
			SpyLog(("%s: %s %s"):format(event, tostring(arg1), tostring(arg2)))
			local st = Spy()
			if st then
				st.encounters = st.encounters or {}
				st.encounters[tostring(arg1)] = tostring(arg2)
			end
		end
		return
	end
	if event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
		TryLearnBossUnits()
		return
	end
	if event == "PLAYER_ENTERING_WORLD" and C_Timer and C_Timer.After then
		-- Scenario-info is vlak na een load vaak nog leeg.
		C_Timer.After(2, OnScenarioTick)
		return
	end
	OnScenarioTick()
end)

-- /mh ritualboss — handmatig togglen (test buiten de ritual; heft suppress
-- niet op of aan, dit is de expliciete-wens-route).
function ns.ToggleRitualBossWindow()
	if ns.IsBossWindowShowing and ns.IsBossWindowShowing(ENTRY.key) then
		ns.HideBossWindowForEntry(ENTRY.key)
		return
	end
	local b = ENTRY.bosses[1]
	ApplyLearnedModel(b)
	if ns.ShowBossWindowForEntry then
		ns.ShowBossWindowForEntry(ENTRY, b.key)
	end
end

-- /mh ritualspy — alles wat de spy tot nu toe ving.
function ns.DumpRitualBossSpy()
	local st = ns.db and ns.db.ritualBossSpy
	local learned = ns.db and ns.db.ritualBossNpcIds
	print("|cffffcc00MH ritual-spy:|r")
	if learned and next(learned) then
		for k, v in pairs(learned) do
			print(("  geleerd model: %s = npc %d"):format(k, v))
		end
	end
	if st and st.encounters and next(st.encounters) then
		for id, nm in pairs(st.encounters) do
			print(("  encounter: %s = %s"):format(id, nm))
		end
	end
	if st and st.log and #st.log > 0 then
		for _, line in ipairs(st.log) do
			print("  " .. line)
		end
	else
		print("  nog geen data — draai een Broken Throne-ritual.")
	end
end
