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
	-- Season 2 (patch 12.1 "Curse of Ula'tek"): The Venomous Abyss. encounterID = the DBM
	-- NewMod first-arg (the journal/EJ encounter id, used for name resolution) — the SAME
	-- convention as the S1 raids above, verified from the installed DBM-Raids-Midnight
	-- (journalInstanceID 1320). The differing ENCOUNTER_START ids (SetEncounterID 3420/3421/
	-- 3429/3445/3455/3470/3492/3497) aren't needed here: auto-open falls back to the boss name
	-- like the S1 raids. Season-gated below so it stays hidden until 12.1 is live. Boss order =
	-- SetEncounterID order (confirm the pull order + model NPC IDs in-game). Beginner step
	-- texts land as S2 approaches — never-lie: no invented mechanics, so no TIPS entries yet.
	{
		key = "raid_venomousabyss",
		name = "The Venomous Abyss",
		season = 2,
		--- ✅ CLIENT-VERIFIED 24 aug 2026, and now a FIELD rather than a remark. It sat in
		--- the comment above as "journalInstanceID 1320" read out of DBM, where nothing
		--- could use it. Rob's own `/mh ej save` returned `The Venomous Abyss  id 1320`
		--- from his client, so the number is confirmed rather than borrowed.
		---
		--- What it buys: the boss window can now recognise this raid the moment you walk
		--- in, instead of waiting for ENCOUNTER_START. Cisca opened it in LFR before the
		--- first pull and got the dungeon of the week, because "in an instance we cannot
		--- name yet" and "not in an instance" took the same path.
		---
		--- ⚠️ The Season 1 raids above deliberately have NO id. Rob's capture covers the
		--- current tier only, so theirs would be a guess, and a wrong journalInstanceID
		--- silently matches the wrong raid. Absent means "we never measured it" and the
		--- lookup simply skips them -- which is the old behaviour, not a regression.
		journalInstanceID = 1320,
		-- ⚠️ ORDER CORRECTED 2026-07-27 from the client itself (`/mh ej save` on PTR
		-- build 120100). The list used to be in SetEncounterID order, which is DBM's
		-- numbering and NOT the order you fight them -- the comment above asked for
		-- exactly this confirmation. Sorting encounterIDs gives the wrong answer too:
		-- the journal order is 2888, 2874, 2894, 2882, 2871, 2887, 2883, 2895, which
		-- is neither ascending nor DBM's. Only the journal's own index is the order.
		-- Nek'zali also gained the apostrophe the client spells him with.
		bosses = {
			{ key = "nekzali",       name = "Nek'zali the Soulcoiler", encounterID = 2888 },
			{ key = "entombedsent",  name = "Entombed Sentinels",      encounterID = 2874 },
			{ key = "lostexplorers", name = "The Lost Explorers",      encounterID = 2894 },
			{ key = "vashnik",       name = "Vashnik the Malignant",   encounterID = 2882 },
			{ key = "sszorak",       name = "Sszorak",                 encounterID = 2871 },
			{ key = "twinfangs",     name = "The Twin Fangs",          encounterID = 2887 },
			{ key = "coiledaltar",   name = "The Coiled Altar",        encounterID = 2883 },
			{ key = "ulatek",        name = "Ula'tek",                 encounterID = 2895 },
		},
	},
}

-- Stap-locale-keys per boss. Alleen velden die we ook echt schrijven (de UI
-- toont tank/healer/dps alleen als de key bestaat). never-lie: geen lege rollen.
local TIPS = {
	chimaerus = { steps = "RAID_BOSS_CHIMAERUS_STEPS", tank = "RAID_BOSS_CHIMAERUS_TANK", healer = "RAID_BOSS_CHIMAERUS_HEALER" },
	--- 🔴 THE ROLE LINES BELOW CAME FROM A SECOND SOURCE, 3 Sep 2026. `tools/zygor_tips.py`
	--- compares this table against Zygor's own raid guide and found 13 roles where Zygor
	--- writes advice and we shipped nothing at all -- Ula'tek, the current tier's final
	--- boss, had only a steps line while Zygor had tank, healer and dps.
	---
	--- 📌 Two sources per line where possible: WHAT TO DO from Zygor's `|grouprole` tips,
	--- WHICH SPELL from DBM. A {SPELL:} link appears only where DBM names the same ability
	--- (1241836 Shadowclaw Slam, 1246175 Entropic Unraveling, 1297630 Restless Amani,
	--- 1301118 Grasping Fangs). Blackening Wounds, Dig In and Venomous Heart are in neither
	--- DBM nor any id source, so they stay plain English names with NO link rather than a
	--- number chosen to look complete.
	---
	--- ⚠️ NOBODY HERE HAS DONE THESE FIGHTS. Rob said so plainly about Ula'tek. The wording
	--- is a faithful rendering of a guide players follow, not a claim of experience -- and
	--- that is a weaker footing than the DBM-backed spell ids beside it. Treat a report
	--- that one of these is wrong as likely, not as surprising.
	averzian  = { steps = "RAID_BOSS_AVERZIAN_STEPS",  tank = "RAID_BOSS_AVERZIAN_TANK", healer = "RAID_BOSS_AVERZIAN_HEALER", dps = "RAID_BOSS_AVERZIAN_DPS" },
	vorasius  = { steps = "RAID_BOSS_VORASIUS_STEPS",  tank = "RAID_BOSS_VORASIUS_TANK", healer = "RAID_BOSS_VORASIUS_HEALER" },
	salhadaar = { steps = "RAID_BOSS_SALHADAAR_STEPS", tank = "RAID_BOSS_SALHADAAR_TANK", healer = "RAID_BOSS_SALHADAAR_HEALER", dps = "RAID_BOSS_SALHADAAR_DPS" },
	vaelgor   = { steps = "RAID_BOSS_VAELGOR_STEPS",   tank = "RAID_BOSS_VAELGOR_TANK", healer = "RAID_BOSS_VAELGOR_HEALER" },
	vanguard  = { steps = "RAID_BOSS_VANGUARD_STEPS",  tank = "RAID_BOSS_VANGUARD_TANK" },
	crown     = { steps = "RAID_BOSS_CROWN_STEPS" },
	beloren   = { steps = "RAID_BOSS_BELOREN_STEPS" },
	lura      = { steps = "RAID_BOSS_LURA_STEPS",      tank = "RAID_BOSS_LURA_TANK" },

	-- ⚠️ Season 2, geschreven 15 aug 2026 — DRIE DAGEN VÓÓR DE OPENING. Dit is de al
	-- geplande "fase 2 uit DBM-mechanics" (Spec 01). Bronnen, in volgorde van gewicht:
	-- de geïnstalleerde DBM-Raids-Midnight-modules (met de hand geschreven waarschuwingen
	-- incl. soort: rennen/kicken/soaken/dispellen), en warcraft.wiki.gg's Encounter-
	-- Journal-dumps voor de beginner-framing. Spell-verwijzingen gaan als {SPELL:id}-
	-- markup: de client levert naam, taal en tooltip zelf, en een fout id is meteen
	-- zichtbaar als kapotte link in plaats van als stil verkeerd woord.
	--
	-- Waar DBM en de wiki elkaar tegenspreken staat de mechaniek ZONDER link of ZONDER
	-- advies: Raging Crosswinds (1285425 vs 1285419), Guillotine (1283485 vs 1283489),
	-- en Blink Nova — DBM zegt wegrennen, de wiki zegt stapelen; de tekst zegt dat
	-- hardop. Ula'tek zelf is bij DBM vrijwel leeg én nooit op de PTR getest; haar
	-- regels leunen op de wiki en zeggen dat.
	--
	-- BuildRaidBody toont boven elke season-2-raid RAID_PRERELEASE_NOTE tot iemand dit
	-- na 18 aug live heeft nagelopen — haal die pas weg mét een meting.
	nekzali       = { steps = "RAID_BOSS_NEKZALI_STEPS",       tank = "RAID_BOSS_NEKZALI_TANK", healer = "RAID_BOSS_NEKZALI_HEALER", dps = "RAID_BOSS_NEKZALI_DPS" },
	entombedsent  = { steps = "RAID_BOSS_ENTOMBEDSENT_STEPS",  tank = "RAID_BOSS_ENTOMBEDSENT_TANK", healer = "RAID_BOSS_ENTOMBEDSENT_HEALER" },
	lostexplorers = { steps = "RAID_BOSS_LOSTEXPLORERS_STEPS" },
	vashnik       = { steps = "RAID_BOSS_VASHNIK_STEPS",       tank = "RAID_BOSS_VASHNIK_TANK", healer = "RAID_BOSS_VASHNIK_HEALER", dps = "RAID_BOSS_VASHNIK_DPS" },
	sszorak       = { steps = "RAID_BOSS_SSZORAK_STEPS",       tank = "RAID_BOSS_SSZORAK_TANK", dps = "RAID_BOSS_SSZORAK_DPS" },
	twinfangs     = { steps = "RAID_BOSS_TWINFANGS_STEPS",     tank = "RAID_BOSS_TWINFANGS_TANK" },
	coiledaltar   = { steps = "RAID_BOSS_COILEDALTAR_STEPS",   healer = "RAID_BOSS_COILEDALTAR_HEALER" },
	ulatek        = { steps = "RAID_BOSS_ULATEK_STEPS",        tank = "RAID_BOSS_ULATEK_TANK", healer = "RAID_BOSS_ULATEK_HEALER", dps = "RAID_BOSS_ULATEK_DPS" },
}

--- 3D-modellen voor de acht bosses: journal-displayIDs.
---
--- ✅ GEMETEN 15 aug 2026. Verscheept als DB2-kandidaten (wago.tools) en dezelfde
--- avond geverifieerd met Robs eigen `/mh ej save` op live (build 120100): alle
--- acht nummers staan letterlijk in zijn ejCapture, telkens als eerste creature
--- van de encounter. De capture noemt per boss ook de adds (Barbed Bulwark,
--- Broodling of Ithraz, de drie venoms, …) — uitbreiden kan dus uit ns.db.ejCapture
--- zonder nieuwe bron. Council-fights dragen hier het model van de naamgever.
ns.RAID_BOSS_DISPLAYS = {
	nekzali       = 142077,
	entombedsent  = 143437, -- Breath of Ula'tek (Blood = 143436)
	lostexplorers = 143824, -- Mor'zahi (Iku 143082, Nama 142158, Gebbo 143083)
	vashnik       = 141675,
	sszorak       = 142788,
	twinfangs     = 140993, -- Vexhul (Ithraz 141309)
	coiledaltar   = 142472, -- Zul'jan (Malacrass 142140)
	ulatek        = 140369, -- ⚠️ db2 heeft ook 253512 "TEMP MODEL" (95484) — niet gebruiken
}

-- Season gate: S1 raids are always active; a season-2 raid stays hidden until the client is on
-- patch 12.1 (interface >= 120100), the same build check SeasonTransition uses — so live 12.0.7
-- players never see the not-yet-released Venomous Abyss, and it lights up automatically at S2.
local function SeasonActive(season)
	if not season or season <= 1 then
		return true
	end
	if season == 2 then
		-- Zie DungeonRosterData: zichtbaar vanaf de patch, gelabeld tot het seizoen loopt.
		return ns.IsSeason2Visible and ns.IsSeason2Visible() or false
	end
	return false
end

local ACTIVE_RAIDS = {}
for _, raid in ipairs(RAIDS) do
	if SeasonActive(raid.season) then
		ACTIVE_RAIDS[#ACTIVE_RAIDS + 1] = raid
	end
end

-- encounterID → { entry, bossKey } voor auto-open op ENCOUNTER_START.
local BY_ENCOUNTER = {}

ns.CUSTOM_BOSS_ENTRIES = ns.CUSTOM_BOSS_ENTRIES or {}
for _, raid in ipairs(ACTIVE_RAIDS) do
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

--- De raid-lijst voor de Raids-pagina (Modules/RaidGuide.lua). Zelfde vorm als de
--- dungeon-roster ({ key, name, bosses = { { key, name, encounterID } } }), zodat de
--- Dungeon-Coach-helpers (GetDungeonBossName/GetDungeonBossTips) er direct op werken.
function ns.GetRaidCoachRaids()
	return ACTIVE_RAIDS
end

--- Raid- en boss-telling voor het Home-blok dat de Raid Coach vindbaar maakt.
--- Namen zijn eigennamen (niet vertaald). Geeft een kopie terug.
--- @return names(table), bossCount(number)
function ns.GetRaidCoachSummary()
	local names, bosses = {}, 0
	for _, raid in ipairs(ACTIVE_RAIDS) do
		names[#names + 1] = raid.name
		bosses = bosses + #raid.bosses
	end
	return names, bosses
end

--------------------------------------------------------------------------------
-- Auto-open op encounter-start (zelfde patroon als SporefallCoach).
--------------------------------------------------------------------------------

local function Boss1NpcId()
	if not (UnitExists and UnitGUID and UnitExists("boss1")) then
		return nil
	end
	local guid = UnitGUID("boss1")
	-- 12.x: een boss-GUID kan secret zijn, en een secret string is nog steeds een
	-- string — type() laat hem er dus doorheen en strsplit klapt eronder. Zelfde
	-- guard als TideboundGrottoCoach; hier was hij vergeten.
	if type(guid) ~= "string" or (issecretvalue and issecretvalue(guid)) then
		return nil
	end
	local kind, _, _, _, _, npcId = strsplit("-", guid)
	if kind == "Creature" or kind == "Vehicle" then
		return tonumber(npcId)
	end
	return nil
end

--- ⚠️ THE CLIENT'S NAME, NOT ONLY OURS. This compared an incoming name against `b.name`,
--- which is the English string in our table — so on a German or French client the match
--- could never succeed, and the auto-open silently did nothing for six of our seven
--- languages. The encounterID paths covered the common case, which is exactly why nobody
--- noticed.
---
--- The Soulcaller/Soulcoiler split on 20 aug is the second reason. Blizzard's own hotfix
--- and their own season article spell Nek'zali's surname differently; ours came from the
--- PTR client and may or may not still match live. Asking `EJ_GetEncounterInfo` for the
--- encounterID we already store means a rename costs us nothing.
---
--- Our own string stays as the fallback: the journal is not always loaded, and an English
--- match is better than no match.
local function FindBossByName(name)
	if type(name) ~= "string" or name == "" then
		return nil, nil
	end
	local lower = name:lower()
	for _, raid in ipairs(ACTIVE_RAIDS) do
		for _, b in ipairs(raid.bosses) do
			if b.name and b.name:lower() == lower then
				return raid, b.key
			end
			if b.encounterID and EJ_GetEncounterInfo then
				local ok, ejName = pcall(EJ_GetEncounterInfo, b.encounterID)
				if ok and type(ejName) == "string" and ejName:lower() == lower then
					return raid, b.key
				end
			end
		end
	end
	return nil, nil
end

local function FindBossByNpc(npcId)
	if not npcId then
		return nil, nil
	end
	for _, raid in ipairs(ACTIVE_RAIDS) do
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

	if entry and bossKey and ns.AutoShowBossWindowForEntry then
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
		ns.AutoShowBossWindowForEntry(entry, bossKey)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ENCOUNTER_START")
f:SetScript("OnEvent", function(_, event, encounterID, encounterName)
	if event == "ENCOUNTER_START" then
		pcall(OnEncounterStart, encounterID, encounterName)
	end
end)
