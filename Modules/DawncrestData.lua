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

-- SEASON 2 ("Mistcrest") ids, captured on the 12.1 PTR with /mh crestfind on
-- 2026-07-24 — see docs/CREST_SOURCES_MEASURED.md. Added ALONGSIDE the Season 1 ids,
-- never replacing them: before the flip a player still has Dawncrest balances to plan
-- with, and afterwards those numbers stay readable.
--
-- ⚠ WHICH SET IS PRIMARY IS NOT MEASURED. Season 2 has two full runs of five
-- (3437-3441 and 3442-3446) and both read qty 0 on the PTR, so nothing told us which
-- one Blizzard's own currency tab uses. Season 1 has the same duplication and there it
-- mattered: the wrong id displayed 100 Veteran crests Rob did not have (see the
-- Veteran comment below). Set A is primary here only because it comes first, and the
-- alternate is consulted just as in Season 1 — when the primary is not a currency the
-- game knows, never to beat a real balance.
--
-- Verify on patch day: run /mh crests once crests can be earned and compare against
-- the currency tab. Same session as block 12.
--
-- Season 2 ACHIEVEMENT ids are unknown and deliberately absent. The "of the Dawn" ids
-- below are Season 1 only; showing them as a Season 2 goal would name a reward that
-- no longer exists.
ns.DAWNCREST_TIERS = {
	{
		key = "adventurer",
		currencyId = 3383,
		season2CurrencyId = 3437,
		season2AlternateCurrencyIds = { 3442 },
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
		season2CurrencyId = 3438,
		season2AlternateCurrencyIds = { 3443 },
		labelKey = "DAWNCREST_TIER_VETERAN",
		achievementId = 42767,
		achLabelKey = "DAWNCREST_ACH_VETERAN",
	},
	{
		key = "champion",
		currencyId = 3343,
		alternateCurrencyIds = { 3344 },
		season2CurrencyId = 3439,
		season2AlternateCurrencyIds = { 3444 },
		labelKey = "DAWNCREST_TIER_CHAMPION",
		achievementId = 42768,
		achLabelKey = "DAWNCREST_ACH_CHAMPION",
	},
	{
		key = "hero",
		currencyId = 3345,
		season2CurrencyId = 3440,
		season2AlternateCurrencyIds = { 3445 },
		labelKey = "DAWNCREST_TIER_HERO",
		achievementId = 42769,
		achLabelKey = "DAWNCREST_ACH_HERO",
	},
	{
		key = "myth",
		currencyId = 3347,
		season2CurrencyId = 3441,
		season2AlternateCurrencyIds = { 3446 },
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
