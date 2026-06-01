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
		sort = 2,
	},
	{
		id = "world_boss",
		category = "weekly",
		titleKey = "CODEX_WORLDBOSS_TITLE",
		bodyKey = "CODEX_WORLDBOSS_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
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
		sort = 1,
	},
	{
		id = "delve_coach",
		category = "delves",
		titleKey = "CODEX_DELVE_COACH_TITLE",
		bodyKey = "CODEX_DELVE_COACH_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		sort = 2,
	},
	{
		id = "delve_curios",
		category = "delves",
		titleKey = "CODEX_DELVE_CURIOS_TITLE",
		bodyKey = "CODEX_DELVE_CURIOS_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
		sort = 3,
	},
	{
		id = "torments_rise",
		category = "delves",
		titleKey = "CODEX_TORMENTS_TITLE",
		bodyKey = "CODEX_TORMENTS_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
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
		sort = 1,
	},
	{
		id = "vault_advisor",
		category = "raid",
		titleKey = "CODEX_VAULT_ADVISOR_TITLE",
		bodyKey = "CODEX_VAULT_ADVISOR_BODY",
		tabId = "delves",
		tabLabelKey = "TAB_DELVES",
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
		sort = 2,
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

function ns:GetCodexCurrencyQuantity(currencyId)
	currencyId = tonumber(currencyId)
	if not currencyId or not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then
		return nil, nil
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, currencyId)
	if not ok or type(info) ~= "table" then
		return nil, nil
	end
	return tonumber(info.quantity), info
end
