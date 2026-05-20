--[[
	SMC Dynamic Checklist — data only (edit quest IDs after Wowhead / in-game verification).

	- pinIds: SMC waypoint `id` values from UI.lua SMC_CATEGORIES (tint those buttons when complete).
	- questIds: C_QuestLog.IsQuestFlaggedCompleted — weekly quests reset flag when the weekly resets.
	- mode: "any" = done if at least one ID is completed; "all" = every ID must be completed.

	Empty questIds = row disabled (hidden). IDs set to 0 are skipped.
	Unverified quest IDs can show false "Done" on low-level characters — only add confirmed IDs.
]]

local _, ns = ...

ns.SMC_CHECKLIST_DEF = {
	{
		id = "astalor_prey",
		labelKey = "SMC_CHK_ASTALOR",
		pinIds = { "prey_hub", "astalor" },
		-- Fill questIds after you confirm the real Midnight Astalor / weekly quest ID(s) in-game (/dump or Wowhead).
		questIds = {},
		mode = "any",
	},
	{
		id = "weekly_hub",
		labelKey = "SMC_CHK_WEEKLY_HUB",
		pinIds = { "weekly_hub" },
		-- VERIFY: optional separate IDs for Liadrin / Halduron / Aethas weeklies — add when confirmed.
		questIds = {},
		mode = "any",
	},
	{
		id = "ritual_site",
		labelKey = "SMC_CHK_RITUAL_SITE",
		pinIds = {},
		-- VERIFY: ritual / scenario quest IDs for Silvermoon ritual progression when datamined.
		questIds = {},
		mode = "all",
	},
}
