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
		-- Liadrin's choice-of-four Spark weeklies (one per week; 93766 World
		-- Quests / 93909 Delves / 93910 Prey / 93911 Dungeons — Wowhead +
		-- in-game bevestigd 10 jun, regel werd blauw na oppakken), plus
		-- Halduron's rep-dungeon weekly (93761 Windrunner Spire — per week een
		-- andere dungeon/ID, lijst groeit) en Aethas' event-weeklies (93600
		-- The Arena Calls, 94836 Late Night Training — event-gebonden).
		-- mode "any": één gedane weekly tikt de checklist-regel af.
		questIds = { 93766, 93909, 93910, 93911, 93761, 93600, 94836 },
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
