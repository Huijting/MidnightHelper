--[[
	Midnight Helper — Dawncrest currency + achievement IDs (Midnight Season 1).
	Verify currency IDs after major patches via Wowhead if quantities show 0.

	✅ ACHIEVEMENT IDS VERIFIED IN-GAME 2026-07-25 (Rob, live, /mh crests). Do not
	"correct" them on the strength of their numeric range: 42767-42770 sit far below
	every other Midnight achievement in this addon (61xxx-63xxx), which looked wrong
	enough that they were nearly changed — but the client resolves them to exactly
	Veteran / Champion / Hero / Myth of the Dawn. Achievement ids are not handed out
	in expansion order. Adventurer is 61809.
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
		-- PTR 16 jun bevestigd: 3341 = "Veteran Dawncrest" (volledige beschrijving,
		-- useTotalEarnedForMaxQty=true) = primary; 3342 heet óók "Veteran Dawncrest"
		-- maar is een duplicaat. GetTierCurrencyQty neemt het MAX van beide → veilig.
		currencyId = 3341,
		alternateCurrencyIds = { 3342 },
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
