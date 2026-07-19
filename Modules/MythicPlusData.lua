--[[
	Mythic+ Season 1 — data-only (Rob wilde "alle Mythics", 15 jun). De Dungeon
	Coach krijgt een Mythic+-subtab die deze data toont: de affix-ladder (wat
	aangaat per keystone-niveau), de wekelijkse Xal'atath's Bargain-varianten, de
	8-dungeon-pool en per-dungeon must-kicks.

	Bron (15 jun): Wowhead "Mythic+ Season 1 Overview" (autoritatief voor affixes
	+ systeem) en method.gg per-dungeon ability-trackers (must-kicks). Zie
	docs/RAID_MPLUS_DATA.md. never-lie: affix-IDs/spell-IDs alleen waar
	gedataminet; per-dungeon kicks zonder gepubliceerde spell-ID blijven
	beschrijvend met "confirm in-game", en dungeons zonder schone bron staan er
	bewust NIET bij.
]]

local _, ns = ...

-- Affix-ladder: wat activeert op welk keystone-niveau. descKey = locale-body
-- (de affix-naam staat in de tekst zelf). spell = {SPELL:}-link waar zinvol.
ns.MPLUS_AFFIX_LADDER = {
	{ level = 2,  descKey = "MPLUS_AFFIX_LINDORMI" },   -- Lindormi's Guidance (affix 165)
	{ level = 5,  descKey = "MPLUS_AFFIX_BARGAIN" },    -- Xal'atath's Bargain (roteert wekelijks)
	{ level = 6,  descKey = "MPLUS_AFFIX_LINDOFF" },    -- Lindormi's Guidance verdwijnt
	{ level = 7,  descKey = "MPLUS_AFFIX_TYRFORT" },    -- Tyrannical OF Fortified (wekelijks)
	{ level = 10, descKey = "MPLUS_AFFIX_BOTH" },       -- Tyrannical EN Fortified
	{ level = 12, descKey = "MPLUS_AFFIX_GUILE" },      -- Xal'atath's Guile (affix 147)
}

-- De 4 wekelijks roterende "kiss-curse"-varianten van Xal'atath's Bargain.
-- spell = de centrale cast (rendert als {SPELL:} in de body-tekst zelf).
ns.MPLUS_BARGAINS = {
	{ key = "ascendant", descKey = "MPLUS_BARGAIN_ASCENDANT" }, -- affix 148, spell 461904
	{ key = "voidbound", descKey = "MPLUS_BARGAIN_VOIDBOUND" }, -- affix 158, spell 462508
	{ key = "pulsar",    descKey = "MPLUS_BARGAIN_PULSAR" },    -- affix 162, spell 1216815
	{ key = "devour",    descKey = "MPLUS_BARGAIN_DEVOUR" },    -- affix 160, spell 440313
}

-- Woordenboek voor de Beginnersmodus: jargon → gewone taal, in een logische
-- leesvolgorde. Bodies in Locales/MythicPlus.lua (6 talen). Bewust kort.
ns.MPLUS_GLOSSARY = {
	"MPLUS_GLOSS_KEY",
	"MPLUS_GLOSS_AFFIX",
	"MPLUS_GLOSS_PULL",
	"MPLUS_GLOSS_KICK",
	"MPLUS_GLOSS_SOAK",
	"MPLUS_GLOSS_TANK",
	"MPLUS_GLOSS_HEALER",
	"MPLUS_GLOSS_DPS",
	"MPLUS_GLOSS_AGGRO",
	"MPLUS_GLOSS_CC",
	"MPLUS_GLOSS_DISPEL",
	"MPLUS_GLOSS_WIPE",
	-- Gearing/rotatie-jargon dat elders in de addon onverklaard voorkwam (F4.5).
	"MPLUS_GLOSS_ILVL",
	"MPLUS_GLOSS_BIS",
	"MPLUS_GLOSS_PROC",
	"MPLUS_GLOSS_UPTIME",
	"MPLUS_GLOSS_VAULT",
}

-- Per-dungeon must-kicks (method.gg). Alleen dungeons met een schone bron;
-- Magisters'/Nexus-Point/Windrunner Spire bewust weggelaten tot bevestigd.
ns.MPLUS_KICKS = {
	maisara         = "MPLUS_KICK_MAISARA",
	magisters       = "MPLUS_KICK_MAGISTERS",
	nexuspoint      = "MPLUS_KICK_NEXUSPOINT",
	windrunnerspire = "MPLUS_KICK_WINDRUNNER",
	pitofsaron      = "MPLUS_KICK_PITOFSARON",
	algethar        = "MPLUS_KICK_ALGETHAR",
	triumvirate     = "MPLUS_KICK_TRIUMVIRATE",
	skyreach        = "MPLUS_KICK_SKYREACH",
}

-- Welk M+-seizoen is actief? Season 2 zodra de client op patch 12.1 draait
-- (interface >= 120100) — dezelfde build-check als de roster-seasongate en
-- SeasonTransition. Vóór 12.1 blijft het de Season 1-pool. (C_MythicPlus.
-- GetCurrentSeason zou ook kunnen, maar het nieuwe season-id is nog onbekend;
-- de build-check is deterministisch en consistent met de rest van MH.)
--- Draait de S2 M+-rotatie ECHT? Anders dan roster-zichtbaarheid mag dit pas true
--- zijn als het seizoen open is: tijdens de patchweek is de S1-pool nog de pool
--- die je daadwerkelijk kunt lopen.
function ns.IsMythicSeason2()
	return ns.IsSeason2Live and ns.IsSeason2Live() or false
end

-- true als dungeon d in de M+-rotatie van het ACTIEVE seizoen zit.
function ns.IsDungeonInMythicPool(d)
	if not d then
		return false
	end
	if ns.IsMythicSeason2() then
		return d.season2 == true
	end
	return d.season1 == true
end

-- De actieve M+-pool = roster-entries in de rotatie van het huidige seizoen
-- (S1: 4 native + 4 legacy; S2: 5 native + 3 legacy). Levert ze in
-- roster-volgorde; de Coach toont ze met hun gelokaliseerde naam.
function ns.GetMythicPoolDungeons()
	local out = {}
	for _, d in ipairs(ns.GetDungeonRoster and ns.GetDungeonRoster() or {}) do
		if ns.IsDungeonInMythicPool(d) then
			out[#out + 1] = d
		end
	end
	return out
end

-- Must-kick body voor een dungeon-key, of nil (Coach toont dan niets — never-lie).
function ns.GetMythicKicks(dungeonKey)
	local key = ns.MPLUS_KICKS and ns.MPLUS_KICKS[dungeonKey]
	return key
end
