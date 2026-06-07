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

	-- Weekly KP routine (concept B, eerste plak) — ONLY in-game verified IDs.
	-- trainerQuests: weekly quest at the profession trainer, keyed by base
	-- skillLine. 93698 = "Splintered Radiance" (Enchanting, Dolothos; Rob
	-- picked up + turned in live 7 jun — flag-semantiek check: ⬜ /run
	-- print(C_QuestLog.IsQuestFlaggedCompleted(93698)) hoort true te zijn
	-- tot woensdag-reset). Andere profs: ID dumpen bij de trainer (questlog-
	-- dump vóór inleveren) en hier toevoegen — regel verschijnt vanzelf.
	weekly = {
		trainerQuests = {
			[333] = 93698,
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
			taskKey = "PROFACAD_CH_KNOWLEDGE_TASK",
			detect = "profui",
		},
		{
			key = "gearup",
			titleKey = "PROFACAD_CH_GEARUP_TITLE",
			bodyKey = "PROFACAD_CH_GEARUP_BODY",
			taskKey = "PROFACAD_CH_GEARUP_TASK",
			detect = "proftool",
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
		{
			key = "tailoring",
			titleKey = "PROFACAD_CH_TAILORING_TITLE",
			bodyKey = "PROFACAD_CH_TAILORING_BODY",
			taskKey = "PROFACAD_CH_TAILORING_TASK",
			skillLineID = 197,
		},
		{
			key = "leatherworking",
			titleKey = "PROFACAD_CH_LEATHERWORKING_TITLE",
			bodyKey = "PROFACAD_CH_LEATHERWORKING_BODY",
			taskKey = "PROFACAD_CH_LEATHERWORKING_TASK",
			skillLineID = 165,
		},
		{
			key = "blacksmithing",
			titleKey = "PROFACAD_CH_BLACKSMITHING_TITLE",
			bodyKey = "PROFACAD_CH_BLACKSMITHING_BODY",
			taskKey = "PROFACAD_CH_BLACKSMITHING_TASK",
			skillLineID = 164,
		},
		{
			key = "engineering",
			titleKey = "PROFACAD_CH_ENGINEERING_TITLE",
			bodyKey = "PROFACAD_CH_ENGINEERING_BODY",
			taskKey = "PROFACAD_CH_ENGINEERING_TASK",
			skillLineID = 202,
		},
		{
			key = "inscription",
			titleKey = "PROFACAD_CH_INSCRIPTION_TITLE",
			bodyKey = "PROFACAD_CH_INSCRIPTION_BODY",
			taskKey = "PROFACAD_CH_INSCRIPTION_TASK",
			skillLineID = 773,
		},
		{
			key = "jewelcrafting",
			titleKey = "PROFACAD_CH_JEWELCRAFTING_TITLE",
			bodyKey = "PROFACAD_CH_JEWELCRAFTING_BODY",
			taskKey = "PROFACAD_CH_JEWELCRAFTING_TASK",
			skillLineID = 755,
		},
		{
			key = "herbalism",
			titleKey = "PROFACAD_CH_HERBALISM_TITLE",
			bodyKey = "PROFACAD_CH_HERBALISM_BODY",
			taskKey = "PROFACAD_CH_HERBALISM_TASK",
			skillLineID = 182,
		},
		{
			key = "mining",
			titleKey = "PROFACAD_CH_MINING_TITLE",
			bodyKey = "PROFACAD_CH_MINING_BODY",
			taskKey = "PROFACAD_CH_MINING_TASK",
			skillLineID = 186,
		},
		{
			key = "skinning",
			titleKey = "PROFACAD_CH_SKINNING_TITLE",
			bodyKey = "PROFACAD_CH_SKINNING_BODY",
			taskKey = "PROFACAD_CH_SKINNING_TASK",
			skillLineID = 393,
		},
	},
}
