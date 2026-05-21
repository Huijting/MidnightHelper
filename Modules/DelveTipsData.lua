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
---@field poiId number|nil
---@field sections MHDelveTipSection[]

ns.DELVE_TIP_ENTRIES = {
	{
		id = "shadow_enclave",
		rosterName = "The Shadow Enclave",
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
		poiId = 93420,
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
		poiId = 93427,
		sections = {
			{ titleKey = "DELVE_COACH_SEC_OVERVIEW", bodyKey = "DELVE_TIP_TORMENTS_RISE_OVERVIEW" },
			{ titleKey = "DELVE_COACH_SEC_ROUTE", bodyKey = "DELVE_TIP_TORMENTS_RISE_ROUTE" },
			{ titleKey = "DELVE_COACH_SEC_TRASH", bodyKey = "DELVE_TIP_TORMENTS_RISE_TRASH" },
			{ titleKey = "DELVE_COACH_SEC_BOSS", bodyKey = "DELVE_TIP_TORMENTS_RISE_BOSS" },
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
