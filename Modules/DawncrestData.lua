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
-- ✅ WHICH SET IS PRIMARY IS NOW MEASURED — AND IT IS THE SECOND ONE, 14 Aug 2026.
--
-- Both runs of five read qty 0 on the PTR, so nothing could tell them apart and set A
-- (3437-3441) was primary purely because it comes first. Rob earned Mistcrest on live
-- before the season opened, and `/mh crests save` on his Mage settled it:
--
--     3437 Adventurer Mistcrest    qty 0     max 0
--     3442 Adventurer Mistcrest    qty 100   max 100   <- capped, and his
--     3438 Veteran Mistcrest       qty 0     max 0
--     3443 Veteran Mistcrest       qty 20    max 100   <- his
--     3439 Champion Mistcrest      qty 0     max 0
--     3444 Champion Mistcrest      qty 10    max 100   <- his
--
-- The real ids carry a cap of 100; the ones we had as primary carry 0 for everything.
-- His screen the night before said "You've earned the maximum amount of Adventurer
-- Mistcrest" — that is 3442 at 100/100, and we would have shown him a confident 0.
--
-- ⚠ SO THE TWO SEASONS RUN OPPOSITE WAYS, and that is the whole reason this comment is
-- long. Season 1's real id is the LOWER of its pair (3341, not 3342 — measured 22 Jul
-- against Blizzard's own tab). Season 2's is the HIGHER. There is no rule to infer here,
-- only a measurement per season, and "the first one is probably right" is exactly the
-- assumption that put a zero where a hundred belongs.
--
-- `GetTierCurrencyQty` keeps its primary-wins rule; only which id is called primary
-- changed. The rule is correct — an alternate must never beat a real balance — and it is
-- what made this wrong quietly instead of loudly: 3437 EXISTS as a currency, so the
-- lookup stopped there and returned its 0 without ever consulting 3442.
--
-- Season 2 ACHIEVEMENT ids are unknown and deliberately absent. The "of the Dawn" ids
-- below are Season 1 only; showing them as a Season 2 goal would name a reward that
-- no longer exists.
ns.DAWNCREST_TIERS = {
	{
		key = "adventurer",
		currencyId = 3383,
		season2CurrencyId = 3442,
		season2AlternateCurrencyIds = { 3437 },
		labelKey = "DAWNCREST_TIER_ADVENTURER",
		--- 🔴 SPLIT ON 29 aug 2026, and only this rank has one. The label used to read
		--- "Adventurer (green)" — a rank name Blizzard owns plus a colour hint we added
		--- ourselves. As one string it cannot be guarded: the name has to follow Blizzard
		--- per language (English for nlNL, since there is no Dutch client) while the hint
		--- follows the language always, and lint check [15] fired on the CORRECT Dutch
		--- value because it can only compare whole strings.
		hintKey = "DAWNCREST_TIER_ADVENTURER_HINT",
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
		season2CurrencyId = 3443,
		season2AlternateCurrencyIds = { 3438 },
		labelKey = "DAWNCREST_TIER_VETERAN",
		achievementId = 42767,
		achLabelKey = "DAWNCREST_ACH_VETERAN",
	},
	{
		key = "champion",
		currencyId = 3343,
		alternateCurrencyIds = { 3344 },
		season2CurrencyId = 3444,
		season2AlternateCurrencyIds = { 3439 },
		labelKey = "DAWNCREST_TIER_CHAMPION",
		achievementId = 42768,
		achLabelKey = "DAWNCREST_ACH_CHAMPION",
	},
	{
		key = "hero",
		currencyId = 3345,
		season2CurrencyId = 3445,
		season2AlternateCurrencyIds = { 3440 },
		labelKey = "DAWNCREST_TIER_HERO",
		achievementId = 42769,
		achLabelKey = "DAWNCREST_ACH_HERO",
	},
	{
		key = "myth",
		currencyId = 3347,
		season2CurrencyId = 3446,
		season2AlternateCurrencyIds = { 3441 },
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
