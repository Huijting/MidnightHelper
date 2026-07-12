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
-- Combat-events (cast/aura) alleen registreren binnen het ritual-scenario (review F3.4):
-- buiten het scenario deden ze niets maar vuurden ze in raid-combat tientallen keren/sec.
-- Assigned zodra het event-frame bestaat; aangeroepen bij scenario-enter/-leave.
local RegisterCombatEvents, UnregisterCombatEvents

-- Cast-alerts (idee uit RitualAlert; spell-IDs uit 14-jun datamining). Terwijl we
-- in het Broken-Throne-scenario zitten, flasht een waarschuwing zodra de boss/add
-- een bekende spell cast. We luisteren via UNIT_SPELLCAST_START/_SUCCEEDED op de
-- gewone f-frame (niet CLEU — dat geeft ADDON_ACTION_FORBIDDEN in 12.x) en gaten
-- op inScenario zodat het buiten het scenario niets doet. Per spell ~3s throttle.
local ALERT_SPELLS = {
	[1284125] = "RITUAL_ALERT_BINDING_NEBULA", -- Binding Nebula (live)
	[1284106] = "RITUAL_ALERT_BINDING_NEBULA", -- Binding Nebula (PTR)
	[1284081] = "RITUAL_ALERT_DISSONANT", -- Dissonant Reflections (live)
	[1284085] = "RITUAL_ALERT_DISSONANT", -- Dissonant Reflections (PTR)
	[1273031] = "RITUAL_ALERT_SHADOWBOLT", -- Ger'lok Shadowbolt Volley (interrupt)
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

-- Cast-alert op een boss/add-cast via UNIT_SPELLCAST_START (CLEU is verboden in
-- 12.x). LET OP (Rob, 15 jun live): de spellID van vijandelijke casts is in 12.x
-- een 'secret' waarde — die als table-key gebruiken of erop testen gooit een fout
-- ("cannot be indexed with secret keys"). We proberen 'm te ontklassificeren met
-- de bekende +0-launder, en doen de lookup sowieso in pcall: lukt het, dan flasht
-- de alert; lukt het niet, dan gewoon geen alert (nooit error-spam). Globale 3s-
-- throttle (geen secret als table-key).
local function LookupAlert(spellID)
	local ok, key = pcall(function()
		local id = spellID + 0 -- launder-poging (secret → plat getal)
		return ALERT_SPELLS[id]
	end)
	if ok then
		return key
	end
	return nil
end

local function OnUnitSpellCast(spellID)
	if not inScenario then
		return
	end
	local key = LookupAlert(spellID)
	if not key then
		return
	end
	local now = (GetTime and GetTime()) or 0
	if (lastAlertAt.t or 0) + 3 > now then
		return
	end
	lastAlertAt.t = now
	FlashAlert(ns:L(key))
end

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

-- Cast-logger (Rob 15 jun): tijdens het scenario elke UNIEKE vijandelijke cast
-- loggen, zodat /mh ritualspy de echte spell-ID's toont — om de alert te
-- bevestigen en de guide met klikbare links te vullen. spellID is in 12.x vaak
-- 'secret' → +0-launder in pcall; lukt dat niet, dan loggen we dat eenmalig.
local seenCast = {}
local function LaunderId(v)
	local ok, n = pcall(function()
		return v + 0
	end)
	if ok and type(n) == "number" then
		return n
	end
	return nil
end
local function SpyLogCast(unit, spellID)
	if not inScenario then
		return
	end
	-- Alleen vijandelijke casts (boss/adds), niet de speler/party.
	if not (unit and UnitCanAttack and UnitCanAttack("player", unit)) then
		return
	end
	-- De ID is in 12.x vaak 'secret'. Test of de cast-NAAM via UnitCastingInfo
	-- wél leesbaar is — dan kunnen we de alert op naam matchen i.p.v. op ID.
	local castName
	if UnitCastingInfo then
		local ok, nm = pcall(UnitCastingInfo, unit)
		if ok and type(nm) == "string" then
			castName = nm
		end
	end
	local who = (UnitName and UnitName(unit)) or tostring(unit)
	local id = LaunderId(spellID)
	if not id then
		-- ID onleesbaar: log de NAAM (uniek per naam) zodat we zien of namen
		-- bruikbaar zijn en welke casts er vallen.
		local key = "name:" .. tostring(castName or "?")
		if not seenCast[key] then
			seenCast[key] = true
			SpyLog(("CAST (secret ID) %s = naam:%s"):format(tostring(who), tostring(castName)))
		end
		return
	end
	if seenCast[id] then
		return
	end
	seenCast[id] = true
	local name = castName
		or (C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(id))
		or (GetSpellInfo and GetSpellInfo(id)) or "?"
	SpyLog(("CAST %s = %d (%s)"):format(tostring(who), id, tostring(name)))
end

-- Debuff-logger (Rob 15 jun): jouw EIGEN debuffs zijn NIET secret, dus die
-- kunnen we wél lezen. Tijdens het scenario loggen we elke nieuwe debuff op de
-- speler → /mh ritualspy toont de ID's (bv. Binding Nebula), waarmee we daarna
-- een werkende "je-zit-vast"-flash bouwen.
local seenDebuff = {}
local function ScanPlayerDebuffs()
	if not inScenario then
		return
	end
	-- Via ns.Aura (Modules/Auras.lua): één plek voor guards, secret-values en de
	-- aanstaande 12.1-aura-API. In restricted content leest 'ie niets en zwijgt de spy.
	ns.Aura.ForEachPlayerDebuff(function(aura)
		local id, nm = aura.spellId, aura.name
		-- 12.1: a secret spellId can't index seenDebuff — skip it (unreadable ≠ absent).
		if id == nil or (issecretvalue and issecretvalue(id)) then
			return
		end
		if not seenDebuff[id] then
			seenDebuff[id] = true
			local safeNm = (nm ~= nil and not (issecretvalue and issecretvalue(nm))) and tostring(nm) or "?"
			SpyLog(("DEBUFF op jou: %d (%s)"):format(id, safeNm))
		end
	end)
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

-- 12.x: boss-unit GUID's (boss1..5) zijn 'secret' — type() zegt "string",
-- maar strsplit/tostring erop tainten de execution en crashen. Nooit
-- string-ops op een secret value (zelfde regel als DelveBossShowcase).
local function IsSecretValue(value)
	return issecretvalue ~= nil and value ~= nil and issecretvalue(value) == true
end

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
			if IsSecretValue(nm) then
				nm = nil -- naam kan ook secret zijn; nooit tostring'en
			end
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
	if UnregisterCombatEvents then
		UnregisterCombatEvents()
	end
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
		if RegisterCombatEvents then
			RegisterCombatEvents()
		end
		if wipe then
			wipe(seenCast) -- nieuwe run → cast-log opnieuw verzamelen
			wipe(seenDebuff) -- idem voor de debuff-log
		end
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
			-- X = alléén die ene boss met rust (per-boss, zelfde regel als
			-- dungeons): een nieuwe stage/boss geeft weer een vers venster.
			if not (ns.IsBossWindowSuppressedFor
				and ns.IsBossWindowSuppressedFor(ENTRY.key, b.key)) then
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
-- UNIT_SPELLCAST_START/SUCCEEDED + UNIT_AURA worden scenario-gated geregistreerd
-- (zie RegisterCombatEvents hieronder), niet permanent.

-- Scenario-gated combat-events (F3.4): pas registreren bij scenario-enter, weer weg
-- bij leave. UNIT_AURA gefilterd op "player" (we lezen alleen eigen debuffs).
function RegisterCombatEvents()
	f:RegisterEvent("UNIT_SPELLCAST_START")
	f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	f:RegisterUnitEvent("UNIT_AURA", "player")
end

function UnregisterCombatEvents()
	f:UnregisterEvent("UNIT_SPELLCAST_START")
	f:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	f:UnregisterEvent("UNIT_AURA")
end

f:SetScript("OnEvent", function(_, event, arg1, arg2, arg3)
	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_SUCCEEDED" then
		OnUnitSpellCast(arg3) -- arg1=unit, arg2=castGUID, arg3=spellID
		if event == "UNIT_SPELLCAST_START" then
			pcall(SpyLogCast, arg1, arg3) -- datamine: echte cast-ID's loggen
		end
		return
	end
	if event == "UNIT_AURA" then
		if arg1 == "player" then
			pcall(ScanPlayerDebuffs) -- datamine: je eigen debuff-ID's loggen
		end
		return
	end
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
