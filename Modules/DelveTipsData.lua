--[[
	Midnight Helper — Delve Coach roster (Midnight Season 1).
	Body text keys live in Locales/DelveTips.lua (enUS + nlNL).
]]

local _, ns = ...

---@class MHDelveTipSection
---@field titleKey string
---@field bodyKey string

---@class MHDelveTipEntry
---@field id string
---@field rosterName string  -- matches MIDNIGHT_DELVES[5]
---@field nameKey string|nil -- ns:L() display name (EN/NL)
---@field poiId number|nil
---@field sections MHDelveTipSection[]

ns.DELVE_TIP_ENTRIES = {
	{
		id = "shadow_enclave",
		rosterName = "The Shadow Enclave",
		nameKey = "DELVE_NAME_SHADOW_ENCLAVE",
		poiId = 93372,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_SHADOW_ENCLAVE_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_SHADOW_ENCLAVE_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_SHADOW_ENCLAVE_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_SHADOW_ENCLAVE_BOSS" },
		},
	},
	{
		id = "collegiate_calamity",
		rosterName = "Collegiate Calamity",
		nameKey = "DELVE_NAME_COLLEGIATE_CALAMITY",
		poiId = 93419,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_COLLEGIATE_CALAMITY_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_COLLEGIATE_CALAMITY_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_COLLEGIATE_CALAMITY_BOSS" },
		},
	},
	{
		id = "the_darkway",
		rosterName = "The Darkway",
		nameKey = "DELVE_NAME_THE_DARKWAY",
		poiId = 93420,
		-- In-game subzone is often "The Arcway" (Silvermoon), not the roster name.
		zoneAliases = { "Arcway", "Darkway", "Gulkat", "Gulkar", "Infiltrator Gulkat", "Eversong" },
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_THE_DARKWAY_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_THE_DARKWAY_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_THE_DARKWAY_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_THE_DARKWAY_BOSS" },
		},
	},
	{
		id = "parhelion_plaza",
		rosterName = "Parhelion Plaza",
		nameKey = "DELVE_NAME_PARHELION_PLAZA",
		poiId = 93421,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_PARHELION_PLAZA_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_PARHELION_PLAZA_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_PARHELION_PLAZA_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_PARHELION_PLAZA_BOSS" },
		},
	},
	{
		id = "atal_aman",
		rosterName = "Atal'Aman",
		nameKey = "DELVE_NAME_ATAL_AMAN",
		poiId = 93422,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_ATAL_AMAN_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_ATAL_AMAN_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_ATAL_AMAN_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_ATAL_AMAN_BOSS" },
		},
	},
	{
		id = "twilight_crypts",
		rosterName = "Twilight Crypts",
		nameKey = "DELVE_NAME_TWILIGHT_CRYPTS",
		poiId = 93423,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_TWILIGHT_CRYPTS_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_TWILIGHT_CRYPTS_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_TWILIGHT_CRYPTS_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_TWILIGHT_CRYPTS_BOSS" },
		},
	},
	{
		id = "gulf_of_memory",
		rosterName = "The Gulf of Memory",
		nameKey = "DELVE_NAME_GULF_OF_MEMORY",
		poiId = 93424,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_GULF_OF_MEMORY_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_GULF_OF_MEMORY_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_GULF_OF_MEMORY_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_GULF_OF_MEMORY_BOSS" },
		},
	},
	{
		id = "grudge_pit",
		rosterName = "The Grudge Pit",
		nameKey = "DELVE_NAME_GRUDGE_PIT",
		poiId = 93425,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_GRUDGE_PIT_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_GRUDGE_PIT_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_GRUDGE_PIT_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_GRUDGE_PIT_BOSS" },
		},
	},
	{
		id = "sunkiller_sanctum",
		rosterName = "Sunkiller Sanctum",
		nameKey = "DELVE_NAME_SUNKILLER_SANCTUM",
		poiId = 93426,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_SUNKILLER_SANCTUM_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_SUNKILLER_SANCTUM_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_SUNKILLER_SANCTUM_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_SUNKILLER_SANCTUM_BOSS" },
		},
	},
	{
		id = "shadowguard_point",
		rosterName = "Shadowguard Point",
		nameKey = "DELVE_NAME_SHADOWGUARD_POINT",
		poiId = 93428,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_SHADOWGUARD_POINT_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_SHADOWGUARD_POINT_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_SHADOWGUARD_POINT_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_SHADOWGUARD_POINT_BOSS" },
		},
	},
	{
		id = "torments_rise",
		rosterName = "Torment's Rise",
		nameKey = "DELVE_NAME_TORMENTS_RISE",
		poiId = 93427,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_TORMENTS_RISE_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_TORMENTS_RISE_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_TORMENTS_RISE_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_TORMENTS_RISE_BOSS" },
		},
	},

	-- ⚠️ 15 aug 2026, tweede versie dezelfde dag. De eerste had één placeholder-sectie
	-- ("niets gemeten"); Rob wilde de delves er vandaag betrouwbaar in. Een sweep over
	-- de geïnstalleerde addons leverde echte inhoud uit bronnen die deze repo al
	-- vertrouwt: HandyNotes_Midnight voor coördinaten (Robs staande regel: ~95%, geen
	-- spot-check) en Zygor voor questketens/overgangen.
	--
	-- Wat er WEL staat: binnenkaart-id, drie Sturdy Chests per delve met coördinaten op
	-- die binnenkaart, de uitgang, en bij Gnarldor de questketen bij de ingang.
	-- Wat er NIET staat: een boss. DBM-Delves-Midnight heeft voor beide een lege stub
	-- (Zones/GnarldorIsle.lua en Zones/RingofGlory.lua: nog steeds 9 regels in r258,
	-- opnieuw gecontroleerd 18 aug) en verzinnen doen we niet. De overview zegt dat
	-- hardop; DelveHistory logt de bossnaam bij de eerstvolgende run nu de namen in de
	-- roster staan.
	--
	-- ⚠️ "GEEN ENKELE ADDON OP SCHIJF NOEMT EEN NAAM" STOND HIER, EN DAT WAS AL ONWAAR
	-- OP HET MOMENT DAT HET GESCHREVEN WERD. Twee van onze eigen bestanden spraken
	-- elkaar tegen: `HazardData.lua` r.242 draagt sinds 17 aug de bosnaam uit GTFO,
	-- mét encounter-id én mét een spellingsverschil dat deze regel ontkende:
	--
	--     instance 3038  encounter 3512  GTFO: "Graka Snake-Eater" / Method: "Gralka"
	--     instance 3077  encounter 3535  GTFO: "Drakta"  (ook Method + Icy Veins)
	--
	-- Op 18 aug meldde ik dit aan Rob als een vondst van GTFO 6.8. Dat was het niet —
	-- 6.7.2 had die regels ook, wij hadden ze al geoogst, en ik had het in ons eigen
	-- bestand kunnen lezen. De les is niet "GTFO checken" maar: kijk eerst wat wij zelf
	-- al weten voordat je een andere bron nieuws noemt.
	--
	-- ⚠️ EN ZE GAAN HIER NOG STEEDS NIET IN. Het zijn commentaarregels in andermans
	-- addon, en de twee bronnen zijn het niet eens over de spelling — precies waarom
	-- CLAUDE.md zegt: kandidaten, geen bewijs. Een verkeerd gespelde bossnaam is erger
	-- dan geen, want de speler kan hem nergens terugvinden. Encounter 3512 of Robs
	-- eigen client via DelveHistory beslist het, en dat kost ons niets extra's.
	--
	-- Binnenkaarten (drie addons eens): Gnarldor Isle = 2635, The Ring of Glory = 2633.
	-- DBM-zone-ids: 3038 / 3077. Chest-quest-ids 96802-96807 bestaan in HandyNotes maar
	-- gaan hier NIET in: dat is dezelfde quest-band-klasse die op 13 aug niet de vlag
	-- bleek die het spel afvuurt. Coördinaten vertrouwd, ids niet.
	{
		id = "gnarldor_isle",
		rosterName = "Gnarldor Isle",
		poiId = 8761,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_GNARLDOR_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_GNARLDOR_ROUTE" },
		},
	},
	{
		id = "ring_of_glory",
		rosterName = "The Ring of Glory",
		poiId = 8764,
		sections = {
			--- ⚠️ EERST, EN ROOD, EN DAT IS EEN BESLISSING VAN 18 AUG. Dit had een
			-- live prompt moeten zijn: een melding op het moment dat de golem begint
			-- te casten. Dat kan niet in 12.1 — spell-id, npc-id, icoon én begin-/
			-- eindtijd van een vijandelijke cast zijn allemaal secret, dus een addon
			-- kan niet zien WELKE cast er loopt. Er is niets meer om op te reageren.
			--
			-- Wat overblijft is dit: het vooraf vertellen, op de plek die je toch
			-- opent voordat je naar binnen gaat. Minder mooi, maar het is waar, en
			-- een waarschuwing die je vóór de pull leest is niet waardeloos.
			{ titleKey = "DELVE_COACH_SEC_DANGER", bodyKey = "DELVE_TIP_RINGOFGLORY_DANGER", danger = true },
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_RINGOFGLORY_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_RINGOFGLORY_ROUTE" },
		},
	},
	--- ⚠️ THE NEMESIS DELVE, AND THE ONLY ENTRY HERE BUILT AROUND SOMEBODY'S DEATH.
	---
	--- Venomfall Deeps was the one delve with no coach entry at all. It got one on 19 aug
	--- because Rob walked in on a Mage at ilvl 280 and Azta'rec killed him from full
	--- health, and the pieces to explain why were scattered across four places that only
	--- meet here.
	---
	--- `rosterName` is what HIS CLIENT wrote into ns.db.hazardZones on entry, not a name
	--- from a guide. `poiId` is deliberately absent: the delve POI sweep has never
	--- returned this delve, and inventing an id to fill the field would break the fast
	--- path in GetDelvePoiState rather than help it.
	---
	--- ⚠️ SOURCING, because this entry leans harder on third parties than any other. The
	--- ability names, the fixed rotation and the intermission rules come from one guide
	--- video, which is weaker than measurement and is why the body says so in the text a
	--- player reads. What IS ours: the instance id (his client), the hazard ids (already
	--- shipping, and the one that killed him was in there), that Wrath of Ula'tek deals
	--- Nature damage and is marked Avoidable (his death recap), and that this delve gives
	--- out no coordinates at all (`/mh here`, measured on the spot).
	{
		id = "venomfall_deeps",
		rosterName = "Venomfall Deeps",
		sections = {
			{ titleKey = "DELVE_COACH_SEC_DANGER", bodyKey = "DELVE_TIP_VENOMFALL_DANGER", danger = true },
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_VENOMFALL_OVERVIEW" },
			--- ⚠️ The one section in this file that reads the player before it speaks.
			---
			--- Rob, 19 Aug 2026, about to pull Azta'rec with Valeera on Tank: every
			--- guide says "set Valeera to Healer" and none says why. The why is Void
			--- Toxin — a magic debuff (confirmed by DBM's own mod, which files its timer
			--- under the magic icon) — and whether it matters depends entirely on
			--- whether YOU can take it off yourself. A Priest can. A Mage cannot, and
			--- for them her role is not a preference.
			---
			--- That is the whole translation MH exists to make, and it is one line.
			{
				titleKey = "DELVE_COACH_SEC_BOSS",
				bodyKey = "DELVE_TIP_VENOMFALL_BOSS",
				bodyFn = function()
					if type(ns.CanSelfRemoveMagic) ~= "function" then
						return nil
					end
					local can = ns.CanSelfRemoveMagic()
					if can == nil then
						return nil -- unreadable stays quiet rather than guessing
					end
					local key = can and "DELVE_TIP_VENOMFALL_DISPEL_YOU"
						or "DELVE_TIP_VENOMFALL_DISPEL_NOTYOU"
					return ns.SafeL and ns:SafeL(key) or nil
				end,
			},
		},
	},
}

local byId = {}
local byRosterName = {}

for _, entry in ipairs(ns.DELVE_TIP_ENTRIES) do
	byId[entry.id] = entry
	byRosterName[entry.rosterName] = entry
end

ns.GetDelveTipEntryById = function(id)
	return id and byId[id] or nil
end

ns.GetDelveTipEntryByRosterName = function(name)
	return name and byRosterName[name] or nil
end

function ns:GetDelveTipDisplayName(entry)
	if not entry then
		return ""
	end
	if entry.nameKey and ns.L then
		local localized = ns:L(entry.nameKey)
		if localized and localized ~= entry.nameKey then
			return localized
		end
	end
	return entry.rosterName or entry.id or ""
end

function ns:GetDelveChatDisplayName(entry)
	if not entry then
		return ""
	end
	local loc = ns.GetChatLocaleCode and ns:GetChatLocaleCode() or nil
	if entry.nameKey and loc and ns._mhLocales then
		local pack = ns._mhLocales[loc]
		local localized = pack and pack[entry.nameKey]
		if localized and localized ~= entry.nameKey then
			return localized
		end
	end
	return entry.rosterName or entry.id or ""
end

--- Returns ok, list of missing locale keys (for dev / release checks).
function ns:ValidateDelveTipLocales()
	local issues = {}
	local packs = {
		{ code = "enUS", pack = ns._mhLocales and ns._mhLocales.enUS },
		{ code = "nlNL", pack = ns._mhLocales and ns._mhLocales.nlNL },
		{ code = "deDE", pack = ns._mhLocales and ns._mhLocales.deDE },
		{ code = "frFR", pack = ns._mhLocales and ns._mhLocales.frFR },
		{ code = "esES", pack = ns._mhLocales and ns._mhLocales.esES },
		{ code = "ptBR", pack = ns._mhLocales and ns._mhLocales.ptBR },
	}
	for _, entry in ipairs(ns.DELVE_TIP_ENTRIES or {}) do
		if entry.nameKey then
			for i = 1, #packs do
				local p = packs[i]
				if not p.pack or not p.pack[entry.nameKey] or p.pack[entry.nameKey] == entry.nameKey then
					issues[#issues + 1] = ("%s:%s"):format(p.code, entry.nameKey)
				end
			end
		end
		if type(entry.sections) == "table" then
			for j = 1, #entry.sections do
				local bodyKey = entry.sections[j].bodyKey
				if bodyKey then
					for i = 1, #packs do
						local p = packs[i]
						if not p.pack or not p.pack[bodyKey] or p.pack[bodyKey] == bodyKey then
							issues[#issues + 1] = ("%s:%s"):format(p.code, bodyKey)
						end
					end
				end
			end
		end
	end
	return #issues == 0, issues
end

local function normalizeDelveName(s)
	if type(s) ~= "string" then
		return ""
	end
	s = s:lower():gsub("^%s+", ""):gsub("%s+$", "")
	s = s:gsub("^bountiful%s+delve%s*:%s*", "")
	s = s:gsub("^delve%s*:%s*", "")
	return s
end

local function namesMatch(a, b)
	local na = normalizeDelveName(a)
	local nb = normalizeDelveName(b)
	if na == "" or nb == "" then
		return false
	end
	if na == nb or na:find(nb, 1, true) or nb:find(na, 1, true) then
		return true
	end
	return false
end

local function CollectZoneStrings()
	local out = {}
	local function add(s)
		if type(s) == "string" and s ~= "" then
			out[#out + 1] = s
		end
	end
	add(GetSubZoneText and GetSubZoneText() or nil)
	add(GetZoneText and GetZoneText() or nil)
	add(GetRealZoneText and GetRealZoneText() or nil)
	if C_Map and C_Map.GetBestMapForUnit then
		local mapID = C_Map.GetBestMapForUnit("player")
		for _ = 1, 14 do
			if not mapID then
				break
			end
			local info = C_Map.GetMapInfo(mapID)
			if info and info.name then
				add(info.name)
			end
			if not info or not info.parentMapID or info.parentMapID == 0 then
				break
			end
			mapID = info.parentMapID
		end
	end
	return out
end

local function ZoneMatchesDelveEntry(zoneStr, entry)
	if not zoneStr or not entry then
		return false, 0
	end
	if namesMatch(zoneStr, entry.rosterName) then
		return true, 4
	end
	if type(entry.zoneAliases) == "table" then
		for _, alias in ipairs(entry.zoneAliases) do
			if namesMatch(zoneStr, alias) then
				return true, 3
			end
		end
	end
	local bosses = ns.DELVE_BOSS_SHOWCASE and ns.DELVE_BOSS_SHOWCASE[entry.id]
	if type(bosses) == "table" then
		for _, boss in ipairs(bosses) do
			if boss.label and namesMatch(zoneStr, boss.label) then
				return true, 5
			end
		end
	end
	return false, 0
end

function ns.GetActiveDelveTipEntryForPlayer()
	local entries = ns.DELVE_TIP_ENTRIES
	if type(entries) ~= "table" then
		return nil
	end
	local zones = CollectZoneStrings()
	local bestEntry
	local bestScore = 0
	for _, entry in ipairs(entries) do
		for i = 1, #zones do
			local matched, score = ZoneMatchesDelveEntry(zones[i], entry)
			if matched and score > bestScore then
				bestScore = score
				bestEntry = entry
			end
		end
	end
	return bestEntry
end

--- Active delve **run** only (C_PartyInfo). Zone name match is for coach tips, not consumables UI.
function ns.IsDelveInstanceInProgress()
	if C_PartyInfo and C_PartyInfo.IsDelveInProgress then
		local ok, active = pcall(C_PartyInfo.IsDelveInProgress)
		if ok and active == true then
			-- A real delve run is a SCENARIO instance. C_PartyInfo.IsDelveInProgress
			-- reads true in places that are not delves: the open world with a group
			-- world boss (Rob 9 jul) and inside FOLLOWER DUNGEONS, which are type
			-- "party" (Rob 18 jul — the delve treasure toast wrongly popped in Voidscar
			-- Arena). Requiring the instance to actually be a scenario rules out both.
			if IsInInstance then
				local inInst, instType = IsInInstance()
				if not inInst or instType ~= "scenario" then
					return false
				end
			end
			return true
		end
	end
	return false
end

--- True when the player is in any active delve run (API). Zone name match is optional for coach tips only.
function ns.IsPlayerInActiveDelve()
	return ns.IsDelveInstanceInProgress()
end
