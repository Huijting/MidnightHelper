--[[
	Raid Coach — de drie Season 1-raids (Rob wilde "volledige raids", 15 jun).
	Hergebruikt exact het bestaande boss-venster (CUSTOM_BOSS_ENTRIES +
	DUNGEON_TIPS), net als de Sporefall- en Ritual Boss Coach. Elke raid is één
	picker-regel onder "Rituals & Raids"; binnen het venster blader je door de
	bosses (prev/next), elk met 3D-model + stappen + klikbare {SPELL:}-links.

	Data (15 jun datamining, never-lie):
	  - DungeonEncounterID's: autoritatief uit Robs geïnstalleerde
	    DBM-Raids-Midnight (NewMod(encounterID, ...)). Zie docs/RAID_MPLUS_DATA.md.
	  - Boss-NPC-ID's (seedCreatureId, voor het model): Wowhead npc-pages. Een
	    in-game geleerd ID (van het boss1-frame) wint altijd, zoals bij Sporefall.
	  - Stap-teksten: Wowhead/Method/Icy-Veins + DBM-spell-IDs; in-game te
	    bevestigen. Bodies in Locales/RaidTips.lua (6 talen).

	Auto-open: ENCOUNTER_START matcht de DungeonEncounterID → opent meteen de
	juiste boss. Naam/boss1-npc fungeren als fallback (zelflerend, zoals Sporefall).
]]

local _, ns = ...

-- Boss-volgorde = Wowhead-guidevolgorde. Voidspire heeft mogelijk flexibele
-- middenbosses (DBM-encounterID-volgorde zet Vaelgor&Ezzorak vóór Fallen-King);
-- in-game te bevestigen. encounterID hoort bij de specifieke boss, dus auto-open
-- klopt ongeacht de getoonde volgorde.
local RAIDS = {
	{
		key = "raid_dreamrift",
		name = "The Dreamrift",
		bosses = {
			{ key = "chimaerus", name = "Chimaerus, the Undreamt God", seedCreatureId = 256116, encounterID = 2795 },
		},
	},
	{
		key = "raid_voidspire",
		name = "The Voidspire",
		bosses = {
			{ key = "averzian",  name = "Imperator Averzian",      seedCreatureId = 240435, encounterID = 2733 },
			{ key = "vorasius",  name = "Vorasius",                 seedCreatureId = 240434, encounterID = 2734 },
			{ key = "salhadaar", name = "Fallen-King Salhadaar",    seedCreatureId = 240432, encounterID = 2736 },
			{ key = "vaelgor",   name = "Vaelgor & Ezzorak",        seedCreatureId = 242056, encounterID = 2735 },
			{ key = "vanguard",  name = "Lightblinded Vanguard",    seedCreatureId = 250589, encounterID = 2737 },
			{ key = "crown",     name = "Crown of the Cosmos",      seedCreatureId = 244761, encounterID = 2738 },
		},
	},
	{
		key = "raid_queldanas",
		name = "March on Quel'Danas",
		bosses = {
			{ key = "beloren", name = "Belo'ren, Child of Al'ar", seedCreatureId = 240387, encounterID = 2739 },
			{ key = "lura",    name = "Midnight Falls",           seedCreatureId = 240391, encounterID = 2740 },
		},
	},
}

-- Stap-locale-keys per boss. Alleen velden die we ook echt schrijven (de UI
-- toont tank/healer/dps alleen als de key bestaat). never-lie: geen lege rollen.
local TIPS = {
	chimaerus = { steps = "RAID_BOSS_CHIMAERUS_STEPS", tank = "RAID_BOSS_CHIMAERUS_TANK", healer = "RAID_BOSS_CHIMAERUS_HEALER" },
	averzian  = { steps = "RAID_BOSS_AVERZIAN_STEPS",  healer = "RAID_BOSS_AVERZIAN_HEALER" },
	vorasius  = { steps = "RAID_BOSS_VORASIUS_STEPS",  healer = "RAID_BOSS_VORASIUS_HEALER" },
	salhadaar = { steps = "RAID_BOSS_SALHADAAR_STEPS", dps = "RAID_BOSS_SALHADAAR_DPS" },
	vaelgor   = { steps = "RAID_BOSS_VAELGOR_STEPS",   tank = "RAID_BOSS_VAELGOR_TANK", healer = "RAID_BOSS_VAELGOR_HEALER" },
	vanguard  = { steps = "RAID_BOSS_VANGUARD_STEPS",  tank = "RAID_BOSS_VANGUARD_TANK" },
	crown     = { steps = "RAID_BOSS_CROWN_STEPS" },
	beloren   = { steps = "RAID_BOSS_BELOREN_STEPS" },
	lura      = { steps = "RAID_BOSS_LURA_STEPS",      tank = "RAID_BOSS_LURA_TANK" },
}

-- encounterID → { entry, bossKey } voor auto-open op ENCOUNTER_START.
local BY_ENCOUNTER = {}

ns.CUSTOM_BOSS_ENTRIES = ns.CUSTOM_BOSS_ENTRIES or {}
for _, raid in ipairs(RAIDS) do
	ns.CUSTOM_BOSS_ENTRIES[raid.key] = raid
	if type(ns.DUNGEON_TIPS) == "table" then
		ns.DUNGEON_TIPS[raid.key] = ns.DUNGEON_TIPS[raid.key] or {}
		for _, b in ipairs(raid.bosses) do
			if TIPS[b.key] then
				ns.DUNGEON_TIPS[raid.key][b.key] = TIPS[b.key]
			end
			if b.encounterID then
				BY_ENCOUNTER[b.encounterID] = { entry = raid, bossKey = b.key }
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Auto-open op encounter-start (zelfde patroon als SporefallCoach).
--------------------------------------------------------------------------------

local function Boss1NpcId()
	if not (UnitExists and UnitGUID and UnitExists("boss1")) then
		return nil
	end
	local guid = UnitGUID("boss1")
	if type(guid) ~= "string" then
		return nil
	end
	local kind, _, _, _, _, npcId = strsplit("-", guid)
	if kind == "Creature" or kind == "Vehicle" then
		return tonumber(npcId)
	end
	return nil
end

local function FindBossByName(name)
	if type(name) ~= "string" or name == "" then
		return nil, nil
	end
	local lower = name:lower()
	for _, raid in ipairs(RAIDS) do
		for _, b in ipairs(raid.bosses) do
			if b.name and b.name:lower() == lower then
				return raid, b.key
			end
		end
	end
	return nil, nil
end

local function FindBossByNpc(npcId)
	if not npcId then
		return nil, nil
	end
	for _, raid in ipairs(RAIDS) do
		for _, b in ipairs(raid.bosses) do
			if b.seedCreatureId == npcId then
				return raid, b.key
			end
		end
	end
	return nil, nil
end

local function OnEncounterStart(encounterID, encounterName)
	local entry, bossKey

	-- 1. encounterID (snelst, locale-onafhankelijk).
	local hit = encounterID and BY_ENCOUNTER[encounterID]
	if hit then
		entry, bossKey = hit.entry, hit.bossKey
	end
	-- 2. naam-match (fallback).
	if not entry then
		entry, bossKey = FindBossByName(encounterName)
	end
	-- 3. boss1-npc-match (fallback).
	if not entry then
		entry, bossKey = FindBossByNpc(Boss1NpcId())
	end

	if entry and bossKey and ns.ShowBossWindowForEntry then
		-- npcID leren van het boss1-frame (model-correctie), zoals Sporefall.
		local learned = Boss1NpcId()
		if learned then
			for _, b in ipairs(entry.bosses) do
				if b.key == bossKey then
					b.creatureId = learned
					break
				end
			end
		end
		ns.ShowBossWindowForEntry(entry, bossKey)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ENCOUNTER_START")
f:SetScript("OnEvent", function(_, event, encounterID, encounterName)
	if event == "ENCOUNTER_START" then
		pcall(OnEncounterStart, encounterID, encounterName)
	end
end)
