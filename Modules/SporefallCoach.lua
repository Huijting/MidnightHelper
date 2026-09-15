--[[
	Sporefall raid-coach (Rob wilde raids; 14 jun). De 1-boss-raid Sporefall met
	eindbaas Rotmire (12.0.7, live vanaf 16 juni). Hergebruikt het bestaande
	boss-venster (CUSTOM_BOSS_ENTRIES + DUNGEON_TIPS), net als de Ritual Boss
	Coach.

	Data web-gedataminet (14 jun: Wowhead PTR / agent-research), in-game te
	bevestigen bij launch — zelfde posture als onze andere boss-tips
	("geschreven tegen DBM/Wowhead; in-game verificatie loopt").

	Rotmire = npc 238693 (DBM SetCreatureID; was 254176 uit de PTR-datamining, zie
	hieronder). Energie-balk-fight: bij vol → Fungal Bloom (wipe).
	Auto-open: ENCOUNTER_START dat op de bossnaam matcht, leert de encounterID
	zelf in SavedVars (geen hardcoded encounterID nodig).
]]

local _, ns = ...

local ENTRY = {
	key = "raid_sporefall",
	name = "Sporefall",
	bosses = {
		{
			key = "rotmire",
			name = "Rotmire",
			-- 15 Sep 2026: 238693, DBM's SetCreatureID (DBM-Lairs-Midnight\Sporefall\Rotmire.lua,
			-- revision 20260827050047); our Tidebound Grotto notes call Rotmire 238693 too. The old
			-- 254176 came from Wowhead PTR datamining in June. An id learned in-game from the boss1
			-- frame still wins, as with the Ritual Boss Coach.
			seedCreatureId = 238693,
		},
	},
}

-- Registraties zodat venster/Chat/Share/picker de bestaande route gebruiken.
ns.CUSTOM_BOSS_ENTRIES = ns.CUSTOM_BOSS_ENTRIES or {}
ns.CUSTOM_BOSS_ENTRIES[ENTRY.key] = ENTRY
if type(ns.DUNGEON_TIPS) == "table" then
	ns.DUNGEON_TIPS[ENTRY.key] = {
		rotmire = {
			steps = "RAID_BOSS_ROTMIRE_STEPS",
			tank = "RAID_BOSS_ROTMIRE_TANK",
			healer = "RAID_BOSS_ROTMIRE_HEALER",
			dps = "RAID_BOSS_ROTMIRE_DPS",
		},
	}
end

-- /mh-toegang loopt via de bestaande boss-window-picker; hier alleen de
-- auto-open op encounter-start (zelflerend encounterID).
local function LearnedEncounterStore()
	if not ns.db then
		return nil
	end
	if type(ns.db.sporefallEncounter) ~= "table" then
		ns.db.sporefallEncounter = {}
	end
	return ns.db.sporefallEncounter
end

local function Boss1NpcId()
	if not (UnitExists and UnitGUID and UnitExists("boss1")) then
		return nil
	end
	local guid = UnitGUID("boss1")
	-- 12.x: een boss-GUID kan secret zijn, en een secret string passeert type().
	-- Zelfde guard als TideboundGrottoCoach; hier was hij vergeten.
	if type(guid) ~= "string" or (issecretvalue and issecretvalue(guid)) then
		return nil
	end
	local kind, _, _, _, _, npcId = strsplit("-", guid)
	if kind == "Creature" or kind == "Vehicle" then
		return tonumber(npcId)
	end
	return nil
end

local function OnEncounterStart(encounterID, encounterName)
	local store = LearnedEncounterStore()
	local rotmireName = ENTRY.bosses[1].name
	local rotmireNpc = ENTRY.bosses[1].seedCreatureId
	local match = false

	-- 1. Bekend/geleerd encounterID (snelste, locale-onafhankelijk). 3159 = DBM's
	-- SetEncounterID for Rotmire, the id ENCOUNTER_START carries. Until 15 Sep this said 2711,
	-- DBM's NewMod (journal) id, which ENCOUNTER_START never sends, so on a non-English client
	-- the window only opened if the boss1 npc matched, and that seed was wrong as well. The
	-- Tidebound Grotto coach already matched its SetEncounterID (3379). Found by the 14 Sep audit.
	if encounterID and (encounterID == 3159 or (store and store.id == encounterID)) then
		match = true
	end
	-- 2. Naam-match (leert dan meteen het encounterID).
	if not match and type(encounterName) == "string" and rotmireName
		and encounterName:lower() == rotmireName:lower() then
		match = true
		if store and encounterID then
			store.id = encounterID
		end
	end
	-- 3. boss1-npcID-match (fallback; leert ook het encounterID).
	if not match and Boss1NpcId() == rotmireNpc then
		match = true
		if store and encounterID then
			store.id = encounterID
		end
	end

	if match and ns.AutoShowBossWindowForEntry then
		-- npcID leren van het boss1-frame (model-correctie), net als RitualBoss.
		local id = Boss1NpcId()
		if id then
			ENTRY.bosses[1].creatureId = id
		end
		ns.AutoShowBossWindowForEntry(ENTRY, ENTRY.bosses[1].key)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ENCOUNTER_START")
f:SetScript("OnEvent", function(_, event, encounterID, encounterName)
	if event == "ENCOUNTER_START" then
		pcall(OnEncounterStart, encounterID, encounterName)
	end
end)
