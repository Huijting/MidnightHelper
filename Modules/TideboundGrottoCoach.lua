--[[
	The Tidebound Grotto lair-coach (Spec 01, Season 2). Patch 12.1 introduces
	"Lairs" — instanced world-boss encounters (Normal → flexible Mythic, count
	toward the Great Vault Raids). The first Lair is The Tidebound Grotto on The
	Coiled Isle; its boss is the Naga sorceress Nymrissa Wavecaller (murloc
	minions, underwater entrance). Same structure as SporefallCoach: one boss,
	reuses the existing boss-window (CUSTOM_BOSS_ENTRIES + DUNGEON_TIPS) and
	auto-opens on ENCOUNTER_START.

	Data (verified 2026-07-15): journalInstanceID 1317, zone mapID 2987, from the
	installed DBM-Lairs-Midnight/TideboundGrotto/NymrissaWavecaller.lua
	(NewMod first-arg 2849 = journal/EJ id; SetEncounterID 3379 = the
	ENCOUNTER_START id we match on). The DBM SetCreatureID is commented out
	(the 238693 in the file is Sporefall's Rotmire, a copy-paste leftover) —
	never-lie: no seedCreatureId, the model self-learns from the boss1 frame.
	No mechanics verified yet, so no step/TIPS entries; beginner steps land as
	S2 approaches (Wowhead PTR + in-game).

	Season-gated: registers only on patch 12.1 (interface >= 120100), so live
	12.0.7 never shows the not-yet-released lair. Lights up automatically at S2.
]]

local _, ns = ...

-- Season gate — same build check as RaidCoachData / DungeonRosterData /
-- SeasonTransition. Bail before registering anything on live 12.0.7.
do
	-- Zichtbaar vanaf de patch (preview); de coach zelf claimt niet dat de lair al
	-- te lopen is — dat hangt aan ns.IsSeason2Live.
	if not (ns.IsSeason2Visible and ns.IsSeason2Visible()) then
		return
	end
end

local ENTRY = {
	key = "raid_tideboundgrotto",
	name = "The Tidebound Grotto",
	bosses = {
		{
			key = "nymrissa",
			name = "Nymrissa Wavecaller",
			-- No verified npcID yet (DBM SetCreatureID is blanked). The model
			-- self-learns from the boss1 frame on pull, like the Ritual Boss Coach.
		},
	},
}

-- Registraties zodat venster/Chat/Share/picker de bestaande route gebruiken.
ns.CUSTOM_BOSS_ENTRIES = ns.CUSTOM_BOSS_ENTRIES or {}
ns.CUSTOM_BOSS_ENTRIES[ENTRY.key] = ENTRY
if type(ns.DUNGEON_TIPS) == "table" then
	-- Empty tips table (no verified mechanics yet) — the window still opens and
	-- shows the boss; per-boss step keys land in phase 2. never-lie: no invented
	-- mechanics.
	ns.DUNGEON_TIPS[ENTRY.key] = ns.DUNGEON_TIPS[ENTRY.key] or {}
end

-- /mh-toegang loopt via de bestaande boss-window-picker; hier alleen de
-- auto-open op encounter-start (zelflerend encounterID + model).
local function LearnedEncounterStore()
	if not ns.db then
		return nil
	end
	if type(ns.db.tideboundEncounter) ~= "table" then
		ns.db.tideboundEncounter = {}
	end
	return ns.db.tideboundEncounter
end

local function Boss1NpcId()
	if not (UnitExists and UnitGUID and UnitExists("boss1")) then
		return nil
	end
	local guid = UnitGUID("boss1")
	if type(guid) ~= "string" then
		return nil
	end
	-- 12.x: boss-GUID kan secret zijn in restricted content → guarden.
	if issecretvalue and issecretvalue(guid) then
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
	local bossName = ENTRY.bosses[1].name
	local match = false

	-- 1. encounterID-match (snelst, locale-onafhankelijk). 3379 = de
	-- SetEncounterID uit DBM-Lairs-Midnight, precies wat ENCOUNTER_START levert.
	if encounterID and (encounterID == 3379 or (store and store.id == encounterID)) then
		match = true
	end
	-- 2. Naam-match (leert dan meteen het encounterID).
	if not match and type(encounterName) == "string" and bossName
		and encounterName:lower() == bossName:lower() then
		match = true
		if store and encounterID then
			store.id = encounterID
		end
	end

	if match and ns.ShowBossWindowForEntry then
		-- npcID leren van het boss1-frame (model-correctie), net als Sporefall.
		local id = Boss1NpcId()
		if id then
			ENTRY.bosses[1].creatureId = id
		end
		ns.ShowBossWindowForEntry(ENTRY, ENTRY.bosses[1].key)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ENCOUNTER_START")
f:SetScript("OnEvent", function(_, event, encounterID, encounterName)
	if event == "ENCOUNTER_START" then
		pcall(OnEncounterStart, encounterID, encounterName)
	end
end)
