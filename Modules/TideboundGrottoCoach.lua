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

	--- ⚠️ MEASURED ON THE PTR, 11 Aug, and corrected once — the correction is the
	--- interesting part.
	---
	--- `/mh worldboss` dumps every task quest per zone. Asking Zul'Aman returned
	--- `97128 "Lair: Nymrissa Wavecaller"` at 95.84 / 55.63, so that is what went in
	--- here first. Asking The Coiled Isle returned the SAME quest with the SAME
	--- `poi.mapID` at 59.99 / 66.20 — because those coordinates are expressed in
	--- whichever map you queried, while `poi.mapID` only says where the thing lives.
	---
	--- Both waypoints land on the same spot, so the first one worked and hid its own
	--- mistake; Rob walked 954 yards to it. But it announced "Target: Zul'Aman" for a
	--- place on The Coiled Isle, and that is the version a player has to make sense of.
	--- Rob's own screenshot settles it: he stood at 60.1 / 66.4 on the Coiled Isle map.
	---
	--- The instance behind the door is uiMapID 2987 (DBM's SetZone) — a third id again,
	--- and not somewhere you can put a waypoint.
	---
	--- The quest id travels with the coordinates so the tooltip can say whether the
	--- client currently sees this lair as active, instead of implying the arrow
	--- guarantees something. Before 18 Aug on live it will not be.
	route = {
		mapID = 2512, -- The Coiled Isle
		x = 59.99,
		y = 66.20,
		questID = 97128,
	},

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
	--- Phase 2 (11 Aug): the ability NAMES, and nothing more than that.
	---
	--- DBM-Lairs-Midnight now registers six spells on this encounter, so the ids are
	--- real. What each one DOES is not settled — DBM's own file carries "TODO, verify
	--- it's actually personal" on the tank line and "TODO, is rush an aoe or something
	--- you dodge or both?". Their mod revision is still 24 July, i.e. PTR data, not
	--- launch data.
	---
	--- ⚠️ And a trap worth naming: every one of their six cooldown timers reads 20.5
	--- seconds. That is a placeholder, not a measured cadence — six abilities do not
	--- share a cast cycle to the half-second. So no timings are repeated here.
	---
	--- The text therefore lists what to expect and says plainly that it is a heads-up
	--- rather than a strategy. `{SPELL:id}` renders the name from the client, so we are
	--- not even inventing the spell names. Real steps after the first live run — the
	--- same posture the Mindbreaker and Selen'vjar entries already take.
	ns.DUNGEON_TIPS[ENTRY.key] = {
		nymrissa = {
			steps = "RAID_BOSS_NYMRISSA_STEPS",
			tank = "RAID_BOSS_NYMRISSA_TANK",
			healer = "RAID_BOSS_NYMRISSA_HEALER",
			dps = "RAID_BOSS_NYMRISSA_DPS",
		},
	}
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
