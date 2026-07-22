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

	-- Weekly KP routine (concept B). trainerQuests: weekly trainer/service
	-- quest IDs per BASE skillLine; value is a LIST — some professions rotate
	-- between multiple weekly variants ("any" semantics: one flagged = done
	-- this week; weekly flags reset at the weekly reset, verified 10 jun).
	--
	-- Source: complete table mirrored from Rob's local MidnightRoutine addon
	-- (Modules/ProfessionKnowledge.lua), cross-validated three ways on 10 jun:
	-- (1) our in-game verified 93698 "Splintered Radiance" sits in its
	-- Enchanting set, (2) its trainer coordinates match our city-guide pins,
	-- (3) its weekly-drop flags 93528-93543 match our own Wowhead research
	-- (PROFESSION_ACADEMY_PLAN.md). Crafting profs (except Ench) have one
	-- "service quest" at the Work Order station; Ench + gatherers have
	-- rotating trainer-quest variants at their trainer.
	weekly = {
		trainerQuests = {
			[171] = { 93690 }, -- Alchemy (service quest)
			[164] = { 93691 }, -- Blacksmithing (service quest)
			[333] = { 93697, 93698, 93699 }, -- Enchanting (93698 in-game verified 7+10 jun)
			[202] = { 93692 }, -- Engineering (service quest)
			[182] = { 93700, 93701, 93702, 93703, 93704 }, -- Herbalism
			[773] = { 93693 }, -- Inscription (service quest)
			[755] = { 93694 }, -- Jewelcrafting (service quest)
			[165] = { 93695 }, -- Leatherworking (service quest)
			[186] = { 93705, 93706, 93707, 93708, 93709 }, -- Mining
			[393] = { 93710, 93711, 93712, 93713, 93714 }, -- Skinning
			[197] = { 93696 }, -- Tailoring (service quest)
		},
		-- Crafting profs (except Enchanting) pick their weekly up at the WORK
		-- ORDER STATION (Flaresworn/Mar'nah), not at their trainer — Rob walked
		-- to the Alchemy trainer and found nothing (10 jun). Ench + gatherers
		-- use their trainer. Consumers route/word the pickup per this set.
		serviceProfs = {
			[171] = true, -- Alchemy
			[164] = true, -- Blacksmithing
			[202] = true, -- Engineering
			[773] = true, -- Inscription
			[755] = true, -- Jewelcrafting
			[165] = true, -- Leatherworking
			[197] = true, -- Tailoring
		},
		-- Enchanting weekly disenchant mats (zie PROFESSION_ACADEMY_PLAN.md).
		enchantingEssences = {
			{ itemID = 267654, need = 5, fallbackName = "Swirling Arcane Essence" },
			{ itemID = 267655, need = 1, fallbackName = "Brimming Mana Shard" },
		},
	},

	-- Tree Advisor v1: curated default route per profession (consensus from
	-- the guides behind the starter chapters; see docs/PROFESSION_ACADEMY_PLAN.md).
	-- Each step is a tree ROOT to finish; anyOf = either counts (player's
	-- choice). Names MUST match C_ProfSpecs.GetTabInfo().name exactly — on a
	-- mismatch (locale, renamed tree) the advice line simply does not show
	-- (never lie). Verified live so far: Enchanting (all 4), Tailoring
	-- (Nimble Needlework, Fiber Arts), LW (Learned Leatherworker), Skinning
	-- (Thorough Tanning, Talented Tracker). skipIfClass: step skipped for
	-- that class token (Druids gather while shapeshifted, no Botany needed).
	advisorRoutes = {
		[164] = {
			{ tree = "The Old Ways" },
			{ anyOf = { "Armorsmithing", "Weaponsmithing" } },
			{ tree = "Craftsmithing" },
		},
		[165] = {
			{ tree = "Learned Leatherworker" },
			{ anyOf = { "Lasting Leather", "Safeguarding Scales" } },
			{ tree = "Flawless Fortes" },
		},
		[171] = {
			{ anyOf = { "Fluent in Flasks", "Potion Prowess" } },
			{ tree = "Transmutation Authority" },
		},
		[182] = {
			{ tree = "Botany", skipIfClass = "DRUID" },
			{ tree = "Bountiful Harvests" },
			{ tree = "Midnight Overload" },
		},
		[186] = {
			{ tree = "Meticulous Mining" },
			{ tree = "Plentiful Ores" },
		},
		[197] = {
			{ tree = "Nimble Needlework" },
			{ anyOf = { "Sin'dorei Finery", "Fiber Arts" } },
			{ tree = "Fabric Specialist" },
		},
		[202] = {
			{ tree = "Recycling" },
		},
		[333] = {
			{ tree = "Spellbound Shatterer" },
			{ tree = "Elevating Equipment" },
			{ tree = "Disenchanting Delegate" },
		},
		[393] = {
			{ tree = "Thorough Tanning" },
			{ tree = "Gainful Gathering" },
			{ tree = "Talented Tracker" },
		},
		[755] = {
			{ tree = "Thoughtful Throughput" },
			{ tree = "Glamorous Gems" },
			{ tree = "Proficient Processor" },
		},
		[773] = {
			{ tree = "Blueprints" },
			{ tree = "Perfected Products" },
		},
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
			introKey = "PROFACAD_CH_KNOWLEDGE_INTRO",
			taskKey = "PROFACAD_CH_KNOWLEDGE_TASK",
			detect = "profui",
		},
		{
			key = "gearup",
			titleKey = "PROFACAD_CH_GEARUP_TITLE",
			bodyKey = "PROFACAD_CH_GEARUP_BODY",
			introKey = "PROFACAD_CH_GEARUP_INTRO",
			taskKey = "PROFACAD_CH_GEARUP_TASK",
			detect = "proftool",
		},
		{
			key = "trees",
			titleKey = "PROFACAD_CH_TREES_TITLE",
			bodyKey = "PROFACAD_CH_TREES_BODY",
			introKey = "PROFACAD_CH_TREES_INTRO",
			taskKey = "PROFACAD_CH_TREES_TASK",
			detect = "kpspent",
		},
		{
			key = "recipes",
			titleKey = "PROFACAD_CH_RECIPES_TITLE",
			bodyKey = "PROFACAD_CH_RECIPES_BODY",
			introKey = "PROFACAD_CH_RECIPES_INTRO",
			taskKey = "PROFACAD_CH_RECIPES_TASK",
		},
		{
			key = "moxie",
			titleKey = "PROFACAD_CH_MOXIE_TITLE",
			bodyKey = "PROFACAD_CH_MOXIE_BODY",
			introKey = "PROFACAD_CH_MOXIE_INTRO",
			taskKey = "PROFACAD_CH_MOXIE_TASK",
		},
		{
			key = "weekly",
			titleKey = "PROFACAD_CH_WEEKLY_TITLE",
			bodyKey = "PROFACAD_CH_WEEKLY_BODY",
			introKey = "PROFACAD_CH_WEEKLY_INTRO",
			taskKey = "PROFACAD_CH_WEEKLY_TASK",
			taskWaypoint = "workOrderStation",
		},
		{
			key = "workorders",
			titleKey = "PROFACAD_CH_WORKORDERS_TITLE",
			bodyKey = "PROFACAD_CH_WORKORDERS_BODY",
			introKey = "PROFACAD_CH_WORKORDERS_INTRO",
			taskKey = "PROFACAD_CH_WORKORDERS_TASK",
			taskWaypoint = "workOrderStation",
		},
		{
			key = "enchanting",
			titleKey = "PROFACAD_CH_ENCHANTING_TITLE",
			bodyKey = "PROFACAD_CH_ENCHANTING_BODY",
			introKey = "PROFACAD_CH_ENCHANTING_INTRO",
			advancedKey = "PROFACAD_CH_ENCHANTING_ADVANCED",
			taskKey = "PROFACAD_CH_ENCHANTING_TASK",
			levelingKey = "PROFGUIDE_LVL_ENCHANTING",
			skillLineID = 333,
		},
		{
			key = "alchemy",
			titleKey = "PROFACAD_CH_ALCHEMY_TITLE",
			bodyKey = "PROFACAD_CH_ALCHEMY_BODY",
			introKey = "PROFACAD_CH_ALCHEMY_INTRO",
			taskKey = "PROFACAD_CH_ALCHEMY_TASK",
			levelingKey = "PROFGUIDE_LVL_ALCHEMY",
			skillLineID = 171,
		},
		{
			key = "tailoring",
			titleKey = "PROFACAD_CH_TAILORING_TITLE",
			bodyKey = "PROFACAD_CH_TAILORING_BODY",
			introKey = "PROFACAD_CH_TAILORING_INTRO",
			taskKey = "PROFACAD_CH_TAILORING_TASK",
			levelingKey = "PROFGUIDE_LVL_TAILORING",
			skillLineID = 197,
		},
		{
			key = "leatherworking",
			titleKey = "PROFACAD_CH_LEATHERWORKING_TITLE",
			bodyKey = "PROFACAD_CH_LEATHERWORKING_BODY",
			introKey = "PROFACAD_CH_LEATHERWORKING_INTRO",
			taskKey = "PROFACAD_CH_LEATHERWORKING_TASK",
			levelingKey = "PROFGUIDE_LVL_LEATHERWORKING",
			skillLineID = 165,
		},
		{
			key = "blacksmithing",
			titleKey = "PROFACAD_CH_BLACKSMITHING_TITLE",
			bodyKey = "PROFACAD_CH_BLACKSMITHING_BODY",
			introKey = "PROFACAD_CH_BLACKSMITHING_INTRO",
			taskKey = "PROFACAD_CH_BLACKSMITHING_TASK",
			levelingKey = "PROFGUIDE_LVL_BLACKSMITHING",
			skillLineID = 164,
		},
		{
			key = "engineering",
			titleKey = "PROFACAD_CH_ENGINEERING_TITLE",
			bodyKey = "PROFACAD_CH_ENGINEERING_BODY",
			introKey = "PROFACAD_CH_ENGINEERING_INTRO",
			taskKey = "PROFACAD_CH_ENGINEERING_TASK",
			levelingKey = "PROFGUIDE_LVL_ENGINEERING",
			skillLineID = 202,
		},
		{
			key = "inscription",
			titleKey = "PROFACAD_CH_INSCRIPTION_TITLE",
			bodyKey = "PROFACAD_CH_INSCRIPTION_BODY",
			introKey = "PROFACAD_CH_INSCRIPTION_INTRO",
			taskKey = "PROFACAD_CH_INSCRIPTION_TASK",
			levelingKey = "PROFGUIDE_LVL_INSCRIPTION",
			skillLineID = 773,
		},
		{
			key = "jewelcrafting",
			titleKey = "PROFACAD_CH_JEWELCRAFTING_TITLE",
			bodyKey = "PROFACAD_CH_JEWELCRAFTING_BODY",
			introKey = "PROFACAD_CH_JEWELCRAFTING_INTRO",
			taskKey = "PROFACAD_CH_JEWELCRAFTING_TASK",
			levelingKey = "PROFGUIDE_LVL_JEWELCRAFTING",
			skillLineID = 755,
		},
		{
			key = "herbalism",
			titleKey = "PROFACAD_CH_HERBALISM_TITLE",
			bodyKey = "PROFACAD_CH_HERBALISM_BODY",
			introKey = "PROFACAD_CH_HERBALISM_INTRO",
			taskKey = "PROFACAD_CH_HERBALISM_TASK",
			levelingKey = "PROFGUIDE_LVL_HERBALISM",
			skillLineID = 182,
		},
		{
			key = "mining",
			titleKey = "PROFACAD_CH_MINING_TITLE",
			bodyKey = "PROFACAD_CH_MINING_BODY",
			introKey = "PROFACAD_CH_MINING_INTRO",
			taskKey = "PROFACAD_CH_MINING_TASK",
			levelingKey = "PROFGUIDE_LVL_MINING",
			skillLineID = 186,
		},
		{
			key = "skinning",
			titleKey = "PROFACAD_CH_SKINNING_TITLE",
			bodyKey = "PROFACAD_CH_SKINNING_BODY",
			introKey = "PROFACAD_CH_SKINNING_INTRO",
			taskKey = "PROFACAD_CH_SKINNING_TASK",
			levelingKey = "PROFGUIDE_LVL_SKINNING",
			skillLineID = 393,
		},
	},
}
