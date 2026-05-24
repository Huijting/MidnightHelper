--[[
	Midnight Helper — Dawncrest currency + achievement IDs (Midnight Season 1).
	Verify currency IDs after major patches via Wowhead if quantities show 0.
]]

local _, ns = ...

ns.DAWNCREST_TIERS = {
	{
		key = "adventurer",
		currencyId = 3383,
		labelKey = "DAWNCREST_TIER_ADVENTURER",
		achievementId = 61809,
		achLabelKey = "DAWNCREST_ACH_ADVENTURER",
	},
	{
		key = "veteran",
		currencyId = 3342,
		labelKey = "DAWNCREST_TIER_VETERAN",
		achievementId = 42767,
		achLabelKey = "DAWNCREST_ACH_VETERAN",
	},
	{
		key = "champion",
		currencyId = 3343,
		alternateCurrencyIds = { 3344 },
		labelKey = "DAWNCREST_TIER_CHAMPION",
		achievementId = 42768,
		achLabelKey = "DAWNCREST_ACH_CHAMPION",
	},
	{
		key = "hero",
		currencyId = 3345,
		labelKey = "DAWNCREST_TIER_HERO",
		achievementId = 42769,
		achLabelKey = "DAWNCREST_ACH_HERO",
	},
	{
		key = "myth",
		currencyId = 3347,
		labelKey = "DAWNCREST_TIER_MYTH",
		achievementId = 42770,
		achLabelKey = "DAWNCREST_ACH_MYTH",
	},
}

--- SMC pin ids in UI.lua (Essential Services).
ns.DAWNCREST_SMC_PINS = {
	vaskarn = "crest_exchange",
	cuzoth = "item_upgrades",
}
