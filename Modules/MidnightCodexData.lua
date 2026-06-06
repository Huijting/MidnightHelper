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
---@field referenceSubTab string|nil -- "dawncrest" | "professions" when tabId is reference
---@field currencyId number|nil
---@field sort number

ns.CODEX_CATEGORIES = {
	{ id = "start", labelKey = "CODEX_CAT_START", sort = 1 },
	{ id = "weekly", labelKey = "CODEX_CAT_WEEKLY", sort = 2 },
	{ id = "currencies", labelKey = "CODEX_CAT_CURRENCIES", sort = 3 },
	{ id = "delves", labelKey = "CODEX_CAT_DELVES", sort = 4 },
	{ id = "dungeons", labelKey = "CODEX_CAT_DUNGEONS", sort = 5 },
	{ id = "raid", labelKey = "CODEX_CAT_RAID", sort = 6 },
	{ id = "world", labelKey = "CODEX_CAT_WORLD", sort = 7 },
	{ id = "professions", labelKey = "CODEX_CAT_PROFESSIONS", sort = 8 },
	-- Former top-level Reference tab, embedded as a category (no articles:
	-- MidnightCodex.lua hosts the full ReferenceGuide panel for this id).
	-- betaKey: hidden when the Reference beta checkbox is off.
	{ id = "reference", labelKey = "TAB_REFERENCE", betaKey = "reference", sort = 9 },
}

ns.CODEX_ARTICLES = {
	-- Start Here
	{
		id = "start_here",
		category = "start",
		titleKey = "CODEX_START_TITLE",
		bodyKey = "CODEX_START_BODY",
		sort = 1,
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
		id = "currency_dawncrest",
		category = "currencies",
		titleKey = "CODEX_CUR_DAWN_TITLE",
		bodyKey = "CODEX_CUR_DAWN_BODY",
		tabId = "reference",
		tabLabelKey = "TAB_REFERENCE",
		navLabelKey = "CODEX_NAV_BASICS_DAWN",
		referenceSubTab = "dawncrest",
		sort = 6,
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
		id = "professions_weekly",
		category = "professions",
		titleKey = "CODEX_PROF_TITLE",
		bodyKey = "CODEX_PROF_BODY",
		tabId = "professions",
		tabLabelKey = "TAB_PROFESSIONS",
		sort = 1,
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
	-- 263843, Pertinax npc 263670, Rotmire npc 254176, folio week-1 quest
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

ns.CODEX_TRACKED_CURRENCY_IDS = { 3028, 3310, 2803, 3356, 3405 }

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
