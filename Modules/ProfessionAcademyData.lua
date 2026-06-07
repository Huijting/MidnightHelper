--[[
	Profession Academy (data) — beginner chapters for the Midnight profession
	system. Pilot covers the generic system (chapters 1-5) plus Enchanting and
	Alchemy starter guides (6-7). Chapter text lives in the locale packs
	(PROFACAD_*); this module only defines structure and metadata.

	Sources: Wowhead/Method/wow-professions (March-June 2026), see
	docs/PROFESSION_ACADEMY_PLAN.md. Facts verified there; anything we cannot
	detect in-game is a manual checkbox, never a fake claim ("never lie").

	detect values:
	  "profui" — auto-completes when TRADE_SKILL_SHOW fires (player opened a
	  profession window). Anything else is manual.
]]

local _, ns = ...

ns.PROF_ACADEMY = {
	-- Work Order-station in de Bazaar (Captain Flaresworn / Mar'nah) — zelfde
	-- coördinaten als SMC City Guide "crafting_orders".
	workOrderStation = { mapID = 2393, x = 45.0, y = 55.6 },

	-- English fallback names per profession skillLineID; the localized name from
	-- C_TradeSkillUI.GetProfessionInfoBySkillLineID wins when available.
	profNames = {
		[164] = "Blacksmithing",
		[165] = "Leatherworking",
		[171] = "Alchemy",
		[182] = "Herbalism",
		[186] = "Mining",
		[197] = "Tailoring",
		[202] = "Engineering",
		[333] = "Enchanting",
		[393] = "Skinning",
		[755] = "Jewelcrafting",
		[773] = "Inscription",
	},

	-- Midnight spec-tree skillLineID per base profession, used for reading
	-- tree state via C_ProfSpecs. 2909 in-game verified (Rob, live 7 jun:
	-- config 52497993, tabs 1152-1155, root ranks readable); the rest from
	-- Wowhead skill pages (12.0.5, wowhead.com/skill=2906..2918; 2908 Cooking
	-- and 2911 Fishing are secondary skills without spec trees). A wrong ID
	-- fails safe: GetSpecSummary returns nil and no line is shown.
	specSkillLines = {
		[164] = 2907, -- Midnight Blacksmithing
		[165] = 2915, -- Midnight Leatherworking
		[171] = 2906, -- Midnight Alchemy
		[182] = 2912, -- Midnight Herbalism
		[186] = 2916, -- Midnight Mining
		[197] = 2918, -- Midnight Tailoring
		[202] = 2910, -- Midnight Engineering
		[333] = 2909, -- Midnight Enchanting (in-game verified)
		[393] = 2917, -- Midnight Skinning
		[755] = 2914, -- Midnight Jewelcrafting
		[773] = 2913, -- Midnight Inscription
	},

	-- Curated "fits your class" advice (armor-type logic; consensus from the
	-- guides in docs/PROFESSION_ACADEMY_PLAN.md). Shown only when the character
	-- has an open profession slot. Alchemy+Herbalism is the universal alt.
	advice = {
		WARRIOR = { profs = { 164, 186 }, whyKey = "PROFACAD_WHY_PLATE" },
		PALADIN = { profs = { 164, 186 }, whyKey = "PROFACAD_WHY_PLATE" },
		DEATHKNIGHT = { profs = { 164, 186 }, whyKey = "PROFACAD_WHY_PLATE" },
		HUNTER = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_MAIL" },
		SHAMAN = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_MAIL" },
		EVOKER = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_MAIL" },
		ROGUE = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_LEATHER" },
		MONK = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_LEATHER" },
		DEMONHUNTER = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_LEATHER" },
		DRUID = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_LEATHER" },
		MAGE = { profs = { 197, 333 }, whyKey = "PROFACAD_WHY_CLOTH" },
		PRIEST = { profs = { 197, 333 }, whyKey = "PROFACAD_WHY_CLOTH" },
		WARLOCK = { profs = { 197, 333 }, whyKey = "PROFACAD_WHY_CLOTH" },
	},
	adviceAlt = { 171, 182 },

	chapters = {
		{
			key = "knowledge",
			titleKey = "PROFACAD_CH_KNOWLEDGE_TITLE",
			bodyKey = "PROFACAD_CH_KNOWLEDGE_BODY",
			taskKey = "PROFACAD_CH_KNOWLEDGE_TASK",
			detect = "profui",
		},
		{
			key = "trees",
			titleKey = "PROFACAD_CH_TREES_TITLE",
			bodyKey = "PROFACAD_CH_TREES_BODY",
			taskKey = "PROFACAD_CH_TREES_TASK",
			detect = "kpspent",
		},
		{
			key = "recipes",
			titleKey = "PROFACAD_CH_RECIPES_TITLE",
			bodyKey = "PROFACAD_CH_RECIPES_BODY",
			taskKey = "PROFACAD_CH_RECIPES_TASK",
		},
		{
			key = "moxie",
			titleKey = "PROFACAD_CH_MOXIE_TITLE",
			bodyKey = "PROFACAD_CH_MOXIE_BODY",
			taskKey = "PROFACAD_CH_MOXIE_TASK",
		},
		{
			key = "weekly",
			titleKey = "PROFACAD_CH_WEEKLY_TITLE",
			bodyKey = "PROFACAD_CH_WEEKLY_BODY",
			taskKey = "PROFACAD_CH_WEEKLY_TASK",
			taskWaypoint = "workOrderStation",
		},
		{
			key = "enchanting",
			titleKey = "PROFACAD_CH_ENCHANTING_TITLE",
			bodyKey = "PROFACAD_CH_ENCHANTING_BODY",
			taskKey = "PROFACAD_CH_ENCHANTING_TASK",
			skillLineID = 333,
		},
		{
			key = "alchemy",
			titleKey = "PROFACAD_CH_ALCHEMY_TITLE",
			bodyKey = "PROFACAD_CH_ALCHEMY_BODY",
			taskKey = "PROFACAD_CH_ALCHEMY_TASK",
			skillLineID = 171,
		},
	},
}
