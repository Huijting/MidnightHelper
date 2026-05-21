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

--- Returns ok, list of missing locale keys (for dev / release checks).
function ns:ValidateDelveTipLocales()
	local issues = {}
	local packs = {
		{ code = "enUS", pack = ns._mhLocales and ns._mhLocales.enUS },
		{ code = "nlNL", pack = ns._mhLocales and ns._mhLocales.nlNL },
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
