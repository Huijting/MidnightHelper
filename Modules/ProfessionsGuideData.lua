--[[
	Midnight Helper — Professions beginner guide (data).
	Section order and Wowhead / SMC links. Text lives in Locales (PROFGUIDE_*).
]]

local _, ns = ...

--- Collapsible sections (top = Professions 101, then professions for phase 2+).
ns.PROFESSIONS_GUIDE_SECTIONS = {
	{
		key = "101",
		titleKey = "PROFGUIDE_SEC_101_TITLE",
		bodyKey = "PROFGUIDE_SEC_101_BODY",
		defaultExpanded = true,
	},
	{
		key = "combo_te",
		titleKey = "PROFGUIDE_SEC_COMBO_TE_TITLE",
		bodyKey = "PROFGUIDE_SEC_COMBO_TE_BODY",
	},
	{
		key = "enchanting",
		titleKey = "PROFGUIDE_SEC_ENCHANTING_TITLE",
		bodyKey = "PROFGUIDE_SEC_ENCHANTING_BODY",
		wowheadUrl = "https://www.wow-professions.com/midnight/enchanting-guide",
		smcPin = "enchanting",
	},
	{
		key = "tailoring",
		titleKey = "PROFGUIDE_SEC_TAILORING_TITLE",
		bodyKey = "PROFGUIDE_SEC_TAILORING_BODY",
		wowheadUrl = "https://www.wow-professions.com/midnight/tailoring-guide",
		smcPin = "tailoring",
	},
	{
		key = "alchemy",
		titleKey = "PROFGUIDE_SEC_ALCHEMY_TITLE",
		bodyKey = "PROFGUIDE_SEC_ALCHEMY_BODY",
		wowheadUrl = "https://www.wow-professions.com/midnight/alchemy-guide",
		smcPin = "alchemy",
	},
	{
		key = "herbalism",
		titleKey = "PROFGUIDE_SEC_HERBALISM_TITLE",
		bodyKey = "PROFGUIDE_SEC_HERBALISM_BODY",
		wowheadUrl = "https://www.wow-professions.com/midnight/herbalism-guide",
		smcPin = "herbalism_trainer",
	},
	{
		key = "skinning",
		titleKey = "PROFGUIDE_SEC_SKINNING_TITLE",
		bodyKey = "PROFGUIDE_SEC_SKINNING_BODY",
		wowheadUrl = "https://www.wow-professions.com/midnight/skinning-guide",
		smcPin = "skinning_trainer",
	},
	{
		key = "leatherworking",
		titleKey = "PROFGUIDE_SEC_LEATHERWORKING_TITLE",
		bodyKey = "PROFGUIDE_SEC_LEATHERWORKING_BODY",
		wowheadUrl = "https://www.wow-professions.com/midnight/leatherworking-guide",
		smcPin = "leatherworking",
	},
}

--- More professions (blacksmithing, jewelcrafting, mining, cooking, fishing, …) in later phases.
