--[[
	Midnight Helper — Midnight Codex article registry.
	Body text lives in Locales/Codex.lua (enUS + nlNL; other packs fall back via ns:L).
]]

local _, ns = ...

---@class MHCodexCategory
---@field id string
---@field labelKey string
---@field sort number

---@class MHCodexArticle
---@field id string
---@field category string
---@field titleKey string
---@field bodyKey string
---@field tabId string|nil
---@field tabLabelKey string|nil
---@field navLabelKey string|nil -- button text override (clearer than tab name alone)
---@field delvesSection string|nil -- "vault" | "midnight" when tabId is delves (accordion)
---@field referenceSubTab string|nil -- "crest" | "professions" when tabId is reference
---@field currencyId number|nil
---@field searchKeys string|nil -- extra words NavSearch matches on. Without it an article
---                             -- is findable only by words already in its own title.
---@field sort number

ns.CODEX_CATEGORIES = {
	{ id = "start", labelKey = "CODEX_CAT_START", sort = 1 },
	{ id = "weekly", labelKey = "CODEX_CAT_WEEKLY", sort = 2 },
	{ id = "currencies", labelKey = "CODEX_CAT_CURRENCIES", sort = 3 },
	{ id = "delves", labelKey = "CODEX_CAT_DELVES", sort = 4 },
	{ id = "dungeons", labelKey = "CODEX_CAT_DUNGEONS", sort = 5 },
	{ id = "raid", labelKey = "CODEX_CAT_RAID", sort = 6 },
	{ id = "world", labelKey = "CODEX_CAT_WORLD", sort = 7 },
	-- ⚠️ TOEGEVOEGD 15 aug 2026, op Robs eigen klacht: "de vault staat bij ritual en
	-- void ?!?". Terecht, en het lag niet aan dat ene artikel. `world` heet "Void &
	-- Rituals" — de naam van Season 1-buitencontent — maar was de restbak geworden voor
	-- negen artikelen uit drie patches. Een categorie waarvan de naam maar een derde van
	-- de inhoud dekt, verstopt de rest.
	--
	-- De Coiled Isle is een plek, geen patchnummer. Spelers zoeken op "waar ga ik heen",
	-- niet op "wat kwam er in 12.1", dus dit is een zone-categorie en géén patch-lade.
	{ id = "coiledisle", labelKey = "CODEX_CAT_COILEDISLE", sort = 8 },
	{ id = "professions", labelKey = "CODEX_CAT_PROFESSIONS", sort = 9 },
	-- Former top-level Reference tab, embedded as a category (no articles:
	-- MidnightCodex.lua hosts the full ReferenceGuide panel for this id).
	-- betaKey: hidden when the Reference beta checkbox is off.
	{ id = "reference", labelKey = "TAB_REFERENCE", betaKey = "reference", sort = 9 },
}

ns.CODEX_ARTICLES = {
	-- Season 2 / patch 12.1 beginner layer (Spec 09) — framing of confirmed
	-- systems, no invented IDs/numbers; browsable now, relevant at the S2 flip.
	{
		id = "s2_new_season",
		category = "start",
		titleKey = "CODEX_S2_TITLE",
		bodyKey = "CODEX_S2_BODY",
		sort = 5,
	},
	{
		id = "s2_terms",
		category = "start",
		titleKey = "CODEX_S2GLOSS_TITLE",
		bodyKey = "CODEX_S2GLOSS_BODY",
		sort = 6,
	},
	-- Deliberately season-proof: no season number, no item levels, no crest names,
	-- no dates. It describes how a season rollover WORKS, so it stays true at the
	-- Season 3 and 4 flips without anyone editing it — the same choice the crafting
	-- entry makes. Two things are left out on purpose: the claim that unclaimed
	-- track rewards are lost (they come back at a vendor, dearer — saying "lost"
	-- would be the scare one guide site prints), and any hard advice on crest
	-- conversion (sources contradict each other and the behaviour can still change,
	-- so the entry points at the currency tab instead).
	{
		id = "season_end",
		category = "start",
		titleKey = "CODEX_SEASONEND_TITLE",
		bodyKey = "CODEX_SEASONEND_BODY",
		sort = 7,
		-- English on purpose: the search box matches raw text, and these are the
		-- words someone types when they do not yet know the article exists.
		searchKeys = "season end ends ending reset rollover roll over new season "
			.. "carry over carryover currency deadline expire expires last week "
			.. "seizoen einde afloopt reset overgang",
	},
	-- 12.0.7 nieuw (datamined; in-game bevestigen bij launch)
	{
		id = "omnium_folio",
		category = "weekly",
		titleKey = "CODEX_FOLIO_TITLE",
		bodyKey = "CODEX_FOLIO_BODY",
		sort = 20,
	},
	{
		id = "turbulent_timeways",
		category = "world",
		titleKey = "CODEX_TT_TITLE",
		bodyKey = "CODEX_TT_BODY",
		sort = 20,
	},

	-- Start Here
	{
		id = "start_here",
		category = "start",
		titleKey = "CODEX_START_TITLE",
		bodyKey = "CODEX_START_BODY",
		sort = 1,
	},
	{
		id = "warband_bank",
		category = "start",
		titleKey = "CODEX_WARBAND_TITLE",
		bodyKey = "CODEX_WARBAND_BODY",
		sort = 2,
	},

	-- Weekly loop
	{
		id = "weekly_reset",
		category = "weekly",
		titleKey = "CODEX_WEEKLY_RESET_TITLE",
		bodyKey = "CODEX_WEEKLY_RESET_BODY",
		tabId = "home",
		tabLabelKey = "TAB_HOME",
		sort = 1,
	},
	{
		id = "great_vault",
		category = "weekly",
		titleKey = "CODEX_VAULT_TITLE",
		bodyKey = "CODEX_VAULT_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_VAULT",
		delvesSection = "vault",
		sort = 2,
	},
	{
		id = "world_boss",
		category = "weekly",
		titleKey = "CODEX_WORLDBOSS_TITLE",
		bodyKey = "CODEX_WORLDBOSS_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_MIDNIGHT",
		delvesSection = "midnight",
		sort = 3,
	},
	{
		id = "delvers_call",
		category = "weekly",
		titleKey = "CODEX_DELVER_CALL_TITLE",
		bodyKey = "CODEX_DELVER_CALL_BODY",
		tabId = "account",
		tabLabelKey = "TAB_ACCOUNT_SNAPSHOT",
		sort = 4,
	},
	{
		id = "account_snapshot",
		category = "weekly",
		titleKey = "CODEX_ACCOUNT_TITLE",
		bodyKey = "CODEX_ACCOUNT_BODY",
		tabId = "account",
		tabLabelKey = "TAB_ACCOUNT_SNAPSHOT",
		sort = 5,
	},

	-- Currencies (live counts when currencyId set)
	{
		id = "currency_coffer_key",
		category = "currencies",
		titleKey = "CODEX_CUR_COFFER_KEY_TITLE",
		bodyKey = "CODEX_CUR_COFFER_KEY_BODY",
		currencyId = 3028,
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_MIDNIGHT",
		delvesSection = "midnight",
		sort = 1,
	},
	{
		id = "currency_coffer_shards",
		category = "currencies",
		titleKey = "CODEX_CUR_SHARDS_TITLE",
		bodyKey = "CODEX_CUR_SHARDS_BODY",
		currencyId = 3310,
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_MIDNIGHT",
		delvesSection = "midnight",
		sort = 2,
	},
	{
		id = "currency_undercoin",
		category = "currencies",
		titleKey = "CODEX_CUR_UNDERCOIN_TITLE",
		bodyKey = "CODEX_CUR_UNDERCOIN_BODY",
		currencyId = 2803,
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_MIDNIGHT",
		delvesSection = "midnight",
		sort = 3,
	},
	{
		id = "currency_mana_crystals",
		category = "currencies",
		titleKey = "CODEX_CUR_MANA_TITLE",
		bodyKey = "CODEX_CUR_MANA_BODY",
		currencyId = 3356,
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_MIDNIGHT",
		delvesSection = "midnight",
		sort = 4,
	},
	{
		id = "currency_field_accolades",
		category = "currencies",
		titleKey = "CODEX_CUR_ACCOLADES_TITLE",
		bodyKey = "CODEX_CUR_ACCOLADES_BODY",
		currencyId = 3405,
		tabId = "world",
		tabLabelKey = "TAB_WORLD",
		sort = 5,
	},
	{
		id = "currency_crest",
		category = "currencies",
		titleKey = "CODEX_CUR_DAWN_TITLE",
		bodyKey = "CODEX_CUR_DAWN_BODY",
		tabId = "reference",
		tabLabelKey = "TAB_REFERENCE",
		navLabelKey = "CODEX_NAV_BASICS_DAWN",
		referenceSubTab = "crest",
		sort = 6,
	},
	{
		-- The Dawncrest guide explains the *currency* (sources, vendors, caps). This
		-- explains the *ladder* those crests upgrade along — the piece a beginner is
		-- missing when a tooltip says "Champion" and means nothing to them.
		id = "gear_tracks",
		category = "currencies",
		titleKey = "CODEX_TRACKS_TITLE",
		bodyKey = "CODEX_TRACKS_BODY",
		tabId = "reference",
		tabLabelKey = "TAB_REFERENCE",
		-- The article IS the gear-tracks content; there is no separate "Gear tracks"
		-- page. Its Open button leads to the Dawncrests page (live crest counts +
		-- Cuzoth/Vaskarn waypoints), so it must be labelled for THAT destination —
		-- reusing the same nav label the currency_dawncrest article uses.
		navLabelKey = "CODEX_NAV_BASICS_DAWN",
		referenceSubTab = "crest",
		sort = 7,
	},

	-- Delves
	{
		id = "delves_intro",
		category = "delves",
		titleKey = "CODEX_DELVES_INTRO_TITLE",
		bodyKey = "CODEX_DELVES_INTRO_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_MIDNIGHT",
		delvesSection = "midnight",
		sort = 1,
	},
	{
		id = "delve_coach",
		category = "delves",
		titleKey = "CODEX_DELVE_COACH_TITLE",
		bodyKey = "CODEX_DELVE_COACH_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_MIDNIGHT",
		delvesSection = "midnight",
		sort = 2,
	},
	{
		id = "delve_curios",
		category = "delves",
		titleKey = "CODEX_DELVE_CURIOS_TITLE",
		bodyKey = "CODEX_DELVE_CURIOS_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_MIDNIGHT",
		delvesSection = "midnight",
		sort = 3,
	},
	{
		id = "torments_rise",
		category = "delves",
		titleKey = "CODEX_TORMENTS_TITLE",
		bodyKey = "CODEX_TORMENTS_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_MIDNIGHT",
		delvesSection = "midnight",
		sort = 4,
	},
	{
		id = "delve_log",
		category = "delves",
		titleKey = "CODEX_DELVE_LOG_TITLE",
		bodyKey = "CODEX_DELVE_LOG_BODY",
		tabId = "delvelog",
		tabLabelKey = "TAB_DELVE_LOG",
		sort = 5,
	},

	-- Dungeons
	{
		id = "mplus_vault",
		category = "dungeons",
		titleKey = "CODEX_MPLUS_TITLE",
		bodyKey = "CODEX_MPLUS_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_VAULT",
		delvesSection = "vault",
		sort = 1,
	},

	-- Raid
	{
		id = "raid_vault",
		category = "raid",
		titleKey = "CODEX_RAID_VAULT_TITLE",
		bodyKey = "CODEX_RAID_VAULT_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		navLabelKey = "CODEX_NAV_DELVES_VAULT",
		delvesSection = "vault",
		sort = 1,
	},
	{
		id = "vault_advisor",
		category = "raid",
		titleKey = "CODEX_VAULT_ADVISOR_TITLE",
		bodyKey = "CODEX_VAULT_ADVISOR_BODY",
		sort = 2,
	},

	-- World
	{
		id = "void_rituals_hub",
		category = "world",
		titleKey = "CODEX_WORLD_HUB_TITLE",
		bodyKey = "CODEX_WORLD_HUB_BODY",
		tabId = "world",
		tabLabelKey = "TAB_WORLD",
		sort = 1,
	},
	{
		id = "ritual_sites",
		category = "world",
		titleKey = "CODEX_RITUAL_TITLE",
		bodyKey = "CODEX_RITUAL_BODY",
		tabId = "world",
		tabLabelKey = "TAB_WORLD",
		sort = 2,
	},
	{
		id = "void_assaults",
		category = "world",
		titleKey = "CODEX_VOID_TITLE",
		bodyKey = "CODEX_VOID_BODY",
		tabId = "world",
		tabLabelKey = "TAB_WORLD",
		sort = 3,
	},
	{
		-- Season-proof like season_end: no counts, no item levels, no tier numbers.
		-- The three difficulty modes, the separate War Mode track and the title at
		-- the end were read from this client's achievements on 2026-07-27, not from
		-- a guide. The number of targets is deliberately absent -- /mh prey reads it
		-- from the achievement's own criteria, so it cannot rot when one is added.
		id = "prey_hunts",
		category = "world",
		titleKey = "CODEX_PREY_TITLE",
		bodyKey = "CODEX_PREY_BODY",
		sort = 4,
		searchKeys = "prey hunt hunts astalor bloodsworn murder row nightmare hard mode "
			.. "preyseeker title war mode great vault world row jacht",
	},
	{
		id = "rares",
		category = "world",
		titleKey = "CODEX_RARES_TITLE",
		bodyKey = "CODEX_RARES_BODY",
		tabId = "rares",
		tabLabelKey = "TAB_RARES",
		sort = 4,
	},

	-- Professions
	{
		id = "craft_gear",
		category = "professions",
		titleKey = "CODEX_CRAFTGEAR_TITLE",
		bodyKey = "CODEX_CRAFTGEAR_BODY",
		tabId = "professions",
		tabLabelKey = "TAB_PROFESSIONS",
		sort = 2,
	},
	{
		id = "professions_weekly",
		category = "professions",
		titleKey = "CODEX_PROF_TITLE",
		bodyKey = "CODEX_PROF_BODY",
		tabId = "professions",
		tabLabelKey = "TAB_PROFESSIONS",
		sort = 1,
	},
	--- Patch 12.1's one-time specialization reset.
	---
	--- ⚠️ EVERY CLAIM HERE COMES FROM THEREMIS'S OWN WINDOWS, photographed by Rob on
	--- 12 Aug 2026. The gossip list showed one line per profession, so "per profession"
	--- is observed rather than reasoned. The confirmation read, in full: "You will lose
	--- all associated recipes and be able to re-allocate your knowledge as you see fit.
	--- This can only be done ONCE." The capitals are Blizzard's.
	---
	--- ⚠️ AND ONE THING IS DELIBERATELY LEFT UNSAID. A guide told Rob the recipes come
	--- back automatically if you re-spend your points the same way. The game promises
	--- nothing of the sort, and that is exactly the reassurance that would cost somebody
	--- their recipes. The article says the game does not state it and to treat them as
	--- gone — same posture as `season_end`, which refuses to repeat the "unclaimed track
	--- rewards are lost" scare for the same reason.
	{
		id = "prof_reset",
		category = "professions",
		titleKey = "CODEX_PROFRESET_TITLE",
		bodyKey = "CODEX_PROFRESET_BODY",
		tabId = "professions",
		tabLabelKey = "TAB_PROFESSIONS",
		sort = 3,
		-- English on purpose: the search box matches raw text, and these are the words
		-- somebody types the moment they regret a choice.
		searchKeys = "reset respec specialization specialisation knowledge points kp "
			.. "unlearn relearn refund undo theremis profession trees "
			.. "resetten herverdelen kennispunten opnieuw",
	},
	{
		id = "professions_guide",
		category = "professions",
		titleKey = "CODEX_PROF_GUIDE_TITLE",
		bodyKey = "CODEX_PROF_GUIDE_BODY",
		tabId = "reference",
		tabLabelKey = "TAB_REFERENCE",
		navLabelKey = "CODEX_NAV_BASICS_PROF",
		referenceSubTab = "professions",
		sort = 2,
	},

	-- Patch 12.0.7 "Revelations" (verified via Wowhead/Blizzard, June 2026).
	-- IDs collected so far: Naigtal zone 16943, Val zone 16900, Leth'ir npc
	-- 263843, Pertinax npc 261072 (Zygor 9.6, 17 jun; killquest 96473), Rotmire npc 254176, folio week-1 quest
	-- 96410, Timeways mount item 258884. uiMapIDs/weekly quest IDs: see
	-- docs/PTR_12.0.7_DATA.md.
	{
		id = "showdowns_127",
		category = "world",
		titleKey = "CODEX_127_SHOWDOWNS_TITLE",
		bodyKey = "CODEX_127_SHOWDOWNS_BODY",
		tabId = "world",
		tabLabelKey = "TAB_WORLD",
		sort = 10,
	},
	{
		id = "sporefall_127",
		category = "raid",
		titleKey = "CODEX_127_SPOREFALL_TITLE",
		bodyKey = "CODEX_127_SPOREFALL_BODY",
		sort = 10,
	},
	{
		id = "folio_127",
		category = "weekly",
		titleKey = "CODEX_127_FOLIO_TITLE",
		bodyKey = "CODEX_127_FOLIO_BODY",
		sort = 10,
	},
	{
		id = "timeways_127",
		category = "weekly",
		titleKey = "CODEX_127_TIMEWAYS_TITLE",
		bodyKey = "CODEX_127_TIMEWAYS_BODY",
		sort = 11,
	},
	{
		id = "ritual_renown_127",
		category = "world",
		titleKey = "CODEX_127_RITUALRENOWN_TITLE",
		bodyKey = "CODEX_127_RITUALRENOWN_BODY",
		tabId = "world",
		tabLabelKey = "TAB_WORLD",
		sort = 11,
	},
	--- The Vaults of Atal'Utek. Written 14 Aug 2026 for Rob's own question: "I have no
	--- idea what I can all do there and above all where."
	---
	--- ⚠️ EVERY NUMBER IN THIS ARTICLE IS MEASURED. Map 2509 (child of 2512, The Coiled
	--- Isle), the Underbelly 2613, the chain 98388 -> 97640 -> 98428 and Corrosive Coin
	--- 3448 come from /mh atal on Rob's own client, 13 Aug. The twelve memorials, the
	--- Underbelly entrance and Szarith come from HandyNotes_Midnight 150. Nothing here
	--- is from a guide site.
	---
	--- The Honored Dead = achievement 63610. Quests 98029-98040 map to criteria
	--- 116407-116418 in that order; the article prints names and coordinates only,
	--- because a player cannot type a criteria id at anything. Kept here so the ids
	--- survive if docs/NEXT_SESSION.md is ever trimmed:
	---     98029/116407 To a daughter 49.50 56.59   98035/116413 To Failure        45.81 61.79
	---     98030/116408 To a lover    52.21 45.12   98036/116414 To a father       47.22 28.77
	---     98031/116409 To parents    55.31 48.45   98037/116415 To a sister       46.79  7.51
	---     98032/116410 To a dream    55.62 40.60   98038/116416 To Comrades       38.50 47.66
	---     98033/116411 To a captain  52.91 33.90   98039/116417 To a stranger     42.57 33.18
	---     98034/116412 To sons       42.91 41.23   98040/116418 To a shield-bearer 56.49 22.88
	--- Underbelly achievement 62601 (Szarith the Fanged, quest 96030, 38.40/17.69);
	--- the three rare elites on 2509 are achievement 63601.
	---
	--- ⚠️ AND FOUR THINGS ARE LEFT OUT ON PURPOSE.
	--- 1. The twelve gift names in the Corrosive Codex. They come from a screenshot,
	---    not from the client. The article says the Codex exists and what it asks for.
	--- 2. What the Altar of Corrosion tree hands out. Never measured — the tooltip said
	---    "Spirit Corrosion" and the counter read 0, which is not enough to claim
	---    anything. The article sends the reader to the window's own tooltips.
	--- 3. Coordinates for Congealed Malice, Khu'tulak and Susarikk. They do not exist;
	---    HandyNotes' 10.00/10.00 is a placeholder, not a place. Saying so is the
	---    point — a reader who thinks we simply forgot will go looking for a list.
	--- 4. Any sentence in which Corrosive Coin and Corrosive Soul could blur together.
	---    Currency 3448 and item 273000 are two objects. The guides conflate them, the
	---    client never has, and that conflation is exactly why a currency sweep spent a
	---    day failing to find something that was in the bags all along.
	{
		id = "vaults_atalutek",
		category = "coiledisle",
		titleKey = "CODEX_ATALUTEK_TITLE",
		bodyKey = "CODEX_ATALUTEK_BODY",
		-- Corrosive Coin, measured 13 Aug. Shows the reader's own balance above the
		-- body, which is also the quietest possible way to keep coin and soul apart.
		currencyId = 3448,
		sort = 12,
		-- English on purpose: the search box matches raw text, and someone who has just
		-- walked in types the zone's name or "corrosive" long before they know we have
		-- a page for it.
		searchKeys = "vaults of atal'utek atalutek atal utek coiled isle underbelly "
			.. "corrosive coin corrosive soul corrosive codex altar of corrosion "
			.. "honored dead memorials amani spirits szarith congealed malice "
			.. "khu'tulak susarikk kluis kluizen gedenktekens waar",
	},

	-- ⚠️ GESPLITST 15 aug 2026, op Robs klacht van dezelfde dag ("een kluwe aan
	-- letters"). Het Vaults-artikel beantwoordde zeven vragen in één scherm; de
	-- bestaande, al vertaalde tekst is op twee bullet-grenzen in drieën geknipt —
	-- geen woord herschreven, alleen de jas. Main houdt "wat is het / hoe kom ik
	-- binnen / de twee currencies"; dit zijn de andere twee.
	{
		id = "vaults_discoveries",
		category = "coiledisle",
		titleKey = "CODEX_ATALUTEK_DISC_TITLE",
		bodyKey = "CODEX_ATALUTEK_DISC_BODY",
		-- Zelfde saldo boven het artikel: de vier sleutels en Corrode Spirit lopen
		-- allebei via Corrosive Coin.
		currencyId = 3448,
		sort = 13,
		searchKeys = "altar of corrosion discoveries corroded key excising knife "
			.. "spirit loupe dispelling charm er'inye venom-worn coffer glideways "
			.. "swift steps broodmaster spectral winds spiritual protection sleutel keys",
	},
	{
		id = "vaults_honored_dead",
		category = "coiledisle",
		titleKey = "CODEX_ATALUTEK_DEAD_TITLE",
		bodyKey = "CODEX_ATALUTEK_DEAD_BODY",
		sort = 14,
		searchKeys = "honored dead memorials gedenktekens twelve route underbelly "
			.. "szarith soft underbelly oppose the foes congealed malice khu'tulak "
			.. "susarikk ancient foe temple incursion rares",
	},
}

local articlesByCategory = {}
for _, article in ipairs(ns.CODEX_ARTICLES) do
	local list = articlesByCategory[article.category]
	if not list then
		list = {}
		articlesByCategory[article.category] = list
	end
	list[#list + 1] = article
end

for _, list in pairs(articlesByCategory) do
	table.sort(list, function(a, b)
		return (a.sort or 0) < (b.sort or 0)
	end)
end

function ns:GetCodexArticlesForCategory(categoryId)
	return articlesByCategory[categoryId] or {}
end

function ns:GetCodexCategoryById(categoryId)
	for _, cat in ipairs(ns.CODEX_CATEGORIES) do
		if cat.id == categoryId then
			return cat
		end
	end
	return nil
end

-- 3448 = Corrosive Coin (Vaults of Atal'Utek). Listed so the panel asks the server for
-- it like the others; without it the balance under that article is whatever the client
-- happened to cache. It has no charCurrencies snapshot fallback, so an uncached read
-- shows CODEX_BALANCE_UNKNOWN rather than a wrong number.
ns.CODEX_TRACKED_CURRENCY_IDS = { 3028, 3310, 2803, 3356, 3405, 3448 }

function ns:RequestCodexCurrencyData()
	if not C_CurrencyInfo or not C_CurrencyInfo.RequestCurrencyDataFromServer then
		return
	end
	for _, id in ipairs(ns.CODEX_TRACKED_CURRENCY_IDS) do
		pcall(C_CurrencyInfo.RequestCurrencyDataFromServer, id)
	end
end

local function CurrencyQuantityFromInfo(info)
	if not info or type(info) ~= "table" then
		return nil
	end
	local q = info.quantity
	if q == nil then
		return nil
	end
	if issecretvalue and issecretvalue(q) then
		if canaccessvalue and canaccessvalue(q) then
			return math.floor(tonumber(q) or 0)
		end
		return nil
	end
	return math.floor(tonumber(q) or 0)
end

local function CurrencyQuantityFromSnapshot(currencyId)
	local guid = UnitGUID and UnitGUID("player")
	if not guid or not ns.db or type(ns.db.charCurrencies) ~= "table" then
		return nil
	end
	local snap = ns.db.charCurrencies[guid]
	if type(snap) ~= "table" then
		return nil
	end
	if currencyId == 3028 then
		return tonumber(snap.keys)
	elseif currencyId == 3310 then
		return tonumber(snap.shards)
	elseif currencyId == 2803 then
		return tonumber(snap.undercoin)
	elseif currencyId == 3356 then
		return tonumber(snap.manaCrystals)
	end
	return nil
end

function ns:GetCodexCurrencyQuantity(currencyId)
	currencyId = tonumber(currencyId)
	if not currencyId or not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then
		return CurrencyQuantityFromSnapshot(currencyId), nil
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, currencyId)
	if not ok or type(info) ~= "table" then
		return CurrencyQuantityFromSnapshot(currencyId), nil
	end
	local qty = CurrencyQuantityFromInfo(info)
	if qty == nil then
		qty = CurrencyQuantityFromSnapshot(currencyId)
	end
	return qty, info
end
