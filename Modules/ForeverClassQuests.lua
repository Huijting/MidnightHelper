local _, ns = ...

--[[
	ForeverClassQuests.lua — WoW Forever: class quests that unlock something, step by step, with the arrow.

	Rob, 16 Nov 2026 (via sparring), letterlijk: "Carola is net, of die kan al beervorm krijgen, maar we weten niet hoe.
	Ik weet dat er een questlijn is … Maar begin inderdaad met de Druid, dan kan ze daar zo meteen alvast mee beginnen."
	First chain: Druid Bear Form (level 10), Alliance (Night Elf) and Horde (Tauren). Same day (Bouwchat 16-11 (2)): Cure
	Poison (14), Aquatic Form (16) and Torwa Pathfinder (50), with steps inside a quest (objs) and other starter quests (alt),
	plus a block in How you play (ns.ForeverClassQuestOverview). Cat Form (20) is a NEW Forever quest chain (98393…,
	Wowhead) that Zygor does not have: built from Wowhead tooltips + the Spoken addon's quest data (see Cat() below).

	Source: the Forever Zygor guide "Leveling Guides\Druid Class Quests" (GEMETEN 16 Nov 2026; after Zygor's 17 Nov update
	the guide sits at ZygorLevelingAllianceCLASSIC.lua:21514-21814 and ZygorLevelingHordeCLASSIC.lua:22830-23140). Coordinates are Zygor's (rule:
	Rob measured > HandyNotes > Zygor > guide), not yet seen in game. Map ids GEMETEN in wago UiMap 1.60.1.70938.
	Quest ids are unproven until the client ticks them off; `/mh classquest` prints what the client says per quest.

	How the current step is found: the LAST quest of the chain that is done or in your log decides where you are, so a
	player who skipped the first pickup (Zygor: only offered while you do not have the second) is not sent back.
	  quest done          → next quest
	  in log, objective   → go to the objective (unless the client says it is complete)
	  in log, no objective/complete → go to the NPC who takes it
	  not in log          → go to the NPC who gives it
	The chain is over once the spell is known (Bear Form 5487) or the last quest is done.
	NPC names come from NPC_NAMES per client language (measured; English when a language is missing); zone names from the client.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- Places: m = UiMap id, x/y in %. Map ids GEMETEN in wago UiMap 70938 (mh-research, 16 Nov 2026): Darnassus 1457,
-- Moonglade 1450, Darkshore 1439, Thunder Bluff 1456, The Barrens 1413, Silverpine Forest 1421, Westfall 1436,
-- Un'Goro Crater 1449, Swamp of Sorrows 1435. All coordinates are Zygor's (Druid Class Quests, both factions).
local P = {
	denatharion = { npc = "Denatharion", id = 4218, m = 1457, x = 34.77, y = 7.36 },
	mathrengyl = { npc = "Mathrengyl Bearwalker", id = 4217, m = 1457, x = 35.38, y = 8.41 },
	dendrite = { npc = "Dendrite Starblaze", id = 11802, m = 1450, x = 56.21, y = 30.64 },
	bearspirit = { npc = "Great Bear Spirit", id = 11956, m = 1450, x = 39.11, y = 27.51 },
	lunaclawA = { m = 1439, x = 43.48, y = 45.96 },
	gennia = { npc = "Gennia Runetotem", id = 3064, m = 1412, x = 47.47, y = 62.98 },
	turak = { npc = "Turak Runetotem", id = 3033, m = 1456, x = 76.46, y = 27.23 },
	lunaclawH = { m = 1413, x = 42.00, y = 60.86 },
	-- Cure Poison (level 14)
	alanndarian = { npc = "Alanndarian Nightsong", id = 3702, m = 1439, x = 37.69, y = 40.66 },
	samplerA = { m = 1439, x = 54.93, y = 33.32 },
	fungus = { m = 1439, x = 43.07, y = 45.55 },
	deer = { m = 1439, x = 41.51, y = 46.08 },
	tonga = { npc = "Tonga Runetotem", id = 3448, m = 1413, x = 52.26, y = 31.93 },
	samplerH = { m = 1413, x = 48.41, y = 18.89 },
	kodo = { m = 1413, x = 51.93, y = 43.65 },
	gazelle = { m = 1413, x = 50.17, y = 31.12 },
	-- Aquatic Form (level 16)
	bauble = { m = 1450, x = 54.33, y = 55.65 },
	shrine = { m = 1450, x = 35.92, y = 41.40 },
	tajarri = { npc = "Tajarri", id = 11799, m = 1450, x = 36.51, y = 40.11 },
	boxDarkshore = { m = 1439, x = 48.87, y = 11.32 },
	boxWestfall = { m = 1436, x = 17.87, y = 33.11 },
	boxSilverpine = { m = 1421, x = 29.54, y = 29.53 },
	boxBarrens = { m = 1413, x = 56.68, y = 8.32 },
	-- Cat Form (level 20): a NEW Forever chain, not in Zygor. Spawns from Wowhead Forever tooltips (zone map space; equal
	-- to UiMap AFGELEID, cross-checked against Zygor on 4 NPCs). Givers/enders from the Spoken addon data (third party).
	catspirit = { npc = "Great Cat Spirit", id = 11957, m = 1450, x = 54.50, y = 75.00 },
	relicClaw = { m = 1450, x = 75.25, y = 67.45 },
	relicFang = { m = 1450, x = 72.45, y = 66.00 },
	relicShadow = { m = 1450, x = 74.50, y = 65.40 },
	-- Skyborne (16 Nov 2026, mh-research): Cat Form via the Avatar (Wowhead spawn 43.9-44.0, 73.4-73.6); Bear Form on
	-- Zephras Isle (UiMap 2521 GEMETEN in DB2; "Zephras Isle/0" = 2521 AFGELEID), coordinates Zygor
	-- ZygorLevelingCommonCLASSIC.lua:1142-1344. Ur'endra's cave: entered from the top (Wowhead comments).
	avatar = { npc = "Avatar of Saeyleenan", id = 272054, m = 1450, x = 43.95, y = 73.50 },
	lotheluum = { npc = "Lotheluum Starbreeze", id = 252359, m = 2521, x = 63.98, y = 75.09 },
	ursendris = { npc = "Urs'endris", id = 255853, m = 2521, x = 69.85, y = 61.75 },
	urendra = { m = 2521, x = 54.41, y = 65.94 },
	-- Torwa Pathfinder (from level 50)
	torwa = { npc = "Torwa Pathfinder", id = 9619, m = 1449, x = 71.63, y = 75.96 },
	gorishi = { m = 1449, x = 50.40, y = 78.60 },
	bloodcap = { m = 1449, x = 71.90, y = 57.40 },
	devilsaur = { m = 1449, x = 67.31, y = 33.89 },
	sunken = { m = 1435, x = 69.36, y = 56.89 },
}

-- q = quest id; alt = other quest ids that count as this step (another starter NPC); from/to = places.
-- objs = what to do between taking and handing in, in order. Each: { place (or nil), textKey, idx = objective index in
-- C_QuestLog.GetQuestObjectives, or items = { item ids: done once one of them is in your bags } }. Objective order
-- GEMETEN in Wowhead tooltips + Zygor "q <id>/<n>" (mh-research, 16 Nov); that it equals the client's index = AFGELEID.
-- Rewards GEMETEN on Wowhead Forever (mh-research, 16 Nov): 6125/6130 teach Cure Poison 8946, 5061/31 Aquatic Form 1066
-- (+ Aquarius Belt, Idol of Shifting Tides), 9053 a choice of Forest's Embrace / Grizzled Pelt / Moonshadow Stave.
local function O(place, textKey, idx, items)
	return { place = place, textKey = textKey, idx = idx, items = items }
end

local CHAINS = {
	DRUID = {
		{
			key = "bear", spell = 5487, level = 10, faction = "Alliance", races = { NightElf = true },
			quests = {
				-- 5924/5925: the same letter from another druid trainer (Wowhead series, mh-research 16 Nov).
				{ q = 5923, alt = { 5924, 5925 }, from = P.denatharion, to = P.mathrengyl },
				{ q = 5921, from = P.mathrengyl, to = P.dendrite },
				{ q = 5929, from = P.dendrite, objs = { O(P.bearspirit, "FCQ_OBJ_BEARSPIRIT", 1) }, to = P.dendrite },
				{ q = 5931, from = P.dendrite, to = P.mathrengyl },
				{ q = 6001, from = P.mathrengyl, objs = { O(P.lunaclawA, "FCQ_OBJ_LUNACLAW", 1) }, to = P.mathrengyl },
			},
		},
		{
			key = "bear", spell = 5487, level = 10, faction = "Horde", races = { Tauren = true },
			quests = {
				{ q = 5928, alt = { 5926, 5927 }, from = P.gennia, to = P.turak },
				{ q = 5922, from = P.turak, to = P.dendrite },
				{ q = 5930, from = P.dendrite, objs = { O(P.bearspirit, "FCQ_OBJ_BEARSPIRIT", 1) }, to = P.dendrite },
				{ q = 5932, from = P.dendrite, to = P.turak },
				-- Horde has no cave: the Moonkin Stone stands outside, behind the first hut (Wowhead Forever 6002 + comments;
				-- Zygor Horde has no cave step). Found by the Fable check of 17 Nov 2026 (Sparring 17-11).
				{ q = 6002, from = P.turak, objs = { O(P.lunaclawH, "FCQ_OBJ_LUNACLAW_H", 1) }, to = P.turak },
			},
		},
		{
			key = "poison", spell = 8946, level = 14, faction = "Alliance",
			quests = {
				{ q = 6121, from = P.mathrengyl, to = P.dendrite },
				{ q = 6122, from = P.dendrite, objs = { O(P.samplerA, "FCQ_OBJ_SAMPLER_A", 1) }, to = P.alanndarian },
				{ q = 6123, from = P.alanndarian, objs = { O(P.fungus, "FCQ_OBJ_FUNGUS", 2), O(nil, "FCQ_OBJ_EARTHROOT", 1) },
					to = P.alanndarian },
				{ q = 6124, from = P.alanndarian, objs = { O(P.deer, "FCQ_OBJ_DEER", 1) }, to = P.dendrite },
				{ q = 6125, from = P.dendrite, to = P.mathrengyl },
			},
		},
		{
			key = "poison", spell = 8946, level = 14, faction = "Horde",
			quests = {
				{ q = 6126, from = P.turak, to = P.dendrite },
				{ q = 6127, from = P.dendrite, objs = { O(P.samplerH, "FCQ_OBJ_SAMPLER_H", 1) }, to = P.tonga },
				{ q = 6128, from = P.tonga, objs = { O(P.kodo, "FCQ_OBJ_KODO", 2), O(nil, "FCQ_OBJ_EARTHROOT", 1) }, to = P.tonga },
				{ q = 6129, from = P.tonga, objs = { O(P.gazelle, "FCQ_OBJ_GAZELLE", 1) }, to = P.dendrite },
				{ q = 6130, from = P.dendrite, to = P.turak },
			},
		},
		{
			key = "aquatic", spell = 1066, level = 16, faction = "Alliance",
			quests = {
				{ q = 26, from = P.mathrengyl, to = P.dendrite },
				-- The Shrine Bauble (15877) is used up at the shrine; the quest is then complete.
				{ q = 29, from = P.dendrite, objs = { O(P.bauble, "FCQ_OBJ_BAUBLE", nil, { 15877 }), O(P.shrine, "FCQ_OBJ_SHRINE", 1) },
					to = P.tajarri },
				-- Two half pendants (15883 Agility, 15882 Endurance) become the Pendant of the Sea Lion (15885).
				{ q = 272, from = P.tajarri, objs = {
					O(P.boxDarkshore, "FCQ_OBJ_LOCKBOX", nil, { 15883, 15885 }),
					O(P.boxWestfall, "FCQ_OBJ_LOCKBOX", nil, { 15882, 15885 }),
					O(P.shrine, "FCQ_OBJ_PENDANT", 1),
				}, to = P.dendrite },
				{ q = 5061, from = P.dendrite, to = P.mathrengyl },
			},
		},
		{
			key = "aquatic", spell = 1066, level = 16, faction = "Horde",
			quests = {
				{ q = 27, from = P.turak, to = P.dendrite },
				{ q = 28, from = P.dendrite, objs = { O(P.bauble, "FCQ_OBJ_BAUBLE", nil, { 15877 }), O(P.shrine, "FCQ_OBJ_SHRINE", 1) },
					to = P.tajarri },
				{ q = 30, from = P.tajarri, objs = {
					O(P.boxSilverpine, "FCQ_OBJ_LOCKBOX", nil, { 15882, 15885 }),
					O(P.boxBarrens, "FCQ_OBJ_LOCKBOX", nil, { 15883, 15885 }),
					O(P.shrine, "FCQ_OBJ_PENDANT", 1),
				}, to = P.dendrite },
				{ q = 31, from = P.dendrite, to = P.turak },
			},
		},
	},
}

-- Torwa Pathfinder (9063 → 9052 → 9051 → 9053), the same for both factions from the druid trainer; requires level 50
-- (Wowhead/fan databases, mh-research 16 Nov). Reward: an item, no spell, so the chain ends when 9053 is done.
local function Torwa(faction, trainer)
	return {
		key = "torwa", nameKey = "FCQ_CHAIN_TORWA", level = 50, faction = faction,
		quests = {
			{ q = 9063, from = trainer, to = P.torwa },
			{ q = 9052, from = P.torwa, objs = { O(P.gorishi, "FCQ_OBJ_GORISHI", 1), O(P.bloodcap, "FCQ_OBJ_BLOODCAP", 2) },
				to = P.torwa },
			{ q = 9051, from = P.torwa, objs = { O(P.devilsaur, "FCQ_OBJ_DEVILSAUR", 1) }, to = P.torwa },
			{ q = 9053, from = P.torwa, objs = { O(P.sunken, "FCQ_OBJ_SUNKEN", 1) }, to = P.torwa },
		},
	}
end
-- Cat Form 768 (level 20; "Requires level 20" GEMETEN in the spell tooltip). A: 98393 → 98394 → 98396 → 98731 → 98397,
-- H: 98340 → 98405 → 98342 → 98739 → 98362 (Wowhead series, mh-research 16 Nov). The relic quest's objectives: 1 Fang,
-- 2 Claw, 3 Silent Shadow (Wowhead order; = client index AFGELEID). Asked in the order you walk the Barrow Dens (Claw in
-- the first room, Fang a level down, Silent Shadow at the bottom: guide + Wowhead comments, AFGELEID).
-- Skyborne (both factions): 98393/98340 → 98341 → 98404 → 98738 → 98397/98362, the spirit is the Avatar of Saeyleenan.
-- 98404→98738 and Dendrite starting 98397/98362 after 98738 GEMETEN (Wowhead series, classic-wow.com NPC lists, Warcraft
-- Tavern); the formal links 98341→98404 and 98738→98397/98362 AFGELEID (strong), mh-research 16 Nov 2026.
local function Cat(faction, races, trainer, spirit, ids)
	return {
		key = "cat", spell = 768, level = 20, faction = faction, races = races,
		quests = {
			{ q = ids[1], from = trainer, to = P.dendrite },
			{ q = ids[2], from = P.dendrite, to = spirit },
			{ q = ids[3], from = spirit, objs = {
				O(P.relicClaw, "FCQ_OBJ_RELIC_CLAW", 2),
				O(P.relicFang, "FCQ_OBJ_RELIC_FANG", 1),
				O(P.relicShadow, "FCQ_OBJ_RELIC_SHADOW", 3),
			}, to = spirit },
			{ q = ids[4], from = spirit, to = P.dendrite },
			{ q = ids[5], from = P.dendrite, to = trainer },
		},
	}
end
local SKYBORNE = { Skyborne = true }
table.insert(CHAINS.DRUID, Cat("Alliance", { NightElf = true }, P.mathrengyl, P.catspirit, { 98393, 98394, 98396, 98731, 98397 }))
table.insert(CHAINS.DRUID, Cat("Horde", { Tauren = true }, P.turak, P.catspirit, { 98340, 98405, 98342, 98739, 98362 }))
table.insert(CHAINS.DRUID, Cat("Alliance", SKYBORNE, P.mathrengyl, P.avatar, { 98393, 98341, 98404, 98738, 98397 }))
table.insert(CHAINS.DRUID, Cat("Horde", SKYBORNE, P.turak, P.avatar, { 98340, 98341, 98404, 98738, 98362 }))

-- Skyborne Bear Form (level 10): 94006 Lotheluum Starbreeze → Urs'endris; 94638 "Strength and Mercy": defeat Ur'endra in
-- the cave, back to Urs'endris, who teaches Bear Form (quest text + Warcraft Tavern; that it is spell 5487 AFGELEID).
-- Steps GEMETEN in Zygor (ZygorLevelingCommonCLASSIC.lua:1142-1344). The Skyborne Moonglade intro (94913/94914) is no
-- bear quest and is left out.
for _, faction in ipairs({ "Alliance", "Horde" }) do
	table.insert(CHAINS.DRUID, {
		key = "bear", spell = 5487, level = 10, faction = faction, races = SKYBORNE,
		quests = {
			{ q = 94006, from = P.lotheluum, to = P.ursendris },
			{ q = 94638, from = P.ursendris, objs = { O(P.urendra, "FCQ_OBJ_URENDRA", 1) }, to = P.ursendris },
		},
	})
end
table.insert(CHAINS.DRUID, Torwa("Alliance", P.mathrengyl))
table.insert(CHAINS.DRUID, Torwa("Horde", P.turak))

--[[ Warlock (17 Nov 2026, Bouwchat 17-11, stap 3). All facts: docs/forever/WARLOCK_CLASSQUESTS_2026-11-17.md (mh-research):
	Zygor Forever "Warlock Class Quests", the Spoken addon, wago DB2 1.60.1.70938, Wowhead Forever tooltips, gidsen.
	NOT copied from Zygor (three Zygor mistakes, GEMETEN): the felhunter binding is 1795 (Zygor says 1471, the Undercity
	voidwalker), the Horde hand-in at Jorah is 1801 (Zygor 1758), Demisette gives 4488 and Briarthorn 4487.
	Not in Zygor, built from Wowhead + Spoken + guides: the Undercity succubus (1472-1476-1474) and the incubus (Forever).
	AFGELEID: incubus = spell 713; 65602 is given by Takar; Orc/Troll take the Orgrimmar routes (the Wowhead record says
	"Orc, Undead" for most of them, the guides say trolls walk Orgrimmar); the Dreadsteed order below (a choice; the
	guides take 7623 early, then the arrow jumps to Banehollow while 7626-7628 are still open: still a valid place).
	No Skyborne warlock (DB2 CharBaseInfo). Inferno and Ritual of Doom: no quest found (trainer). Not built yet: the item
	chains Shard of the Green Flame (7601-7603) and An Imp's Request (8419-8422). Coordinates: HandyNotes for trainers,
	else Zygor, else Wowhead/Questie pins; Stormwind uses the 39.x set (the 25.x Wowhead set is another map space). ]]
local WL_P = {
	drusilla = { npc = "Drusilla La Salle", id = 459, m = 1429, x = 49.69, y = 42.65 },
	alamar = { npc = "Alamar Grimm", id = 460, m = 1426, x = 28.38, y = 66.18 },
	ruzan = { npc = "Ruzan", id = 5765, m = 1411, x = 42.59, y = 69.00 },
	venya = { npc = "Venya Marthand", id = 5667, m = 1420, x = 30.98, y = 66.41 },
	remen = { npc = "Remen Marcot", id = 6121, m = 1429, x = 44.49, y = 66.27 },
	lago = { npc = "Lago Blackwrench", id = 6120, m = 1455, x = 47.63, y = 9.26 },
	gakin = { npc = "Gakin the Darkbinder", id = 6122, m = 1453, x = 39.22, y = 85.23 },
	ophek = { npc = "Ophek", id = 3294, m = 1411, x = 54.37, y = 41.29 },
	ganrul = { npc = "Gan'rul Bloodeye", id = 5875, m = 1454, x = 48.24, y = 45.29 },
	ageron = { npc = "Ageron Kargal", id = 5724, m = 1420, x = 61.62, y = 52.67 },
	carendin = { npc = "Carendin Halgar", id = 5675, m = 1458, x = 85.04, y = 26.01 },
	takar = { npc = "Takar the Seer", id = 6244, m = 1413, x = 49.31, y = 57.10 },
	cazul = { npc = "Cazul", id = 5909, m = 1454, x = 47.06, y = 46.48 },
	zankaja = { npc = "Zankaja", id = 5910, m = 1454, x = 37.03, y = 59.45 },
	gazrog = { npc = "Gazrog", id = 3464, m = 1413, x = 51.93, y = 30.32 },
	kenzigla = { npc = "Ken'zigla", id = 4197, m = 1442, x = 73.25, y = 95.12 },
	logmar = { npc = "Grunt Logmar", id = 5911, m = 1413, x = 44.62, y = 59.27 },
	dogran = { npc = "Grunt Dogran", id = 5908, m = 1413, x = 43.31, y = 47.89 },
	magar = { npc = "Magar", id = 3363, m = 1454, x = 63.7, y = 49.9 },
	godrick = { npc = "Godrick Farsan", id = 5693, m = 1458, x = 84.81, y = 14.83 },
	strahad = { npc = "Strahad Farsan", id = 6251, m = 1413, x = 62.63, y = 35.50 },
	krom = { npc = "Krom Stoutarm", id = 6294, m = 1455, x = 74.21, y = 9.42 },
	jorah = { npc = "Jorah Annison", id = 6293, m = 1458, x = 75.91, y = 37.87 },
	demisette = { npc = "Demisette Cloyce", id = 461, m = 1453, x = 39.24, y = 84.96 },
	briarthorn = { npc = "Briarthorn", id = 5172, m = 1455, x = 50.35, y = 5.66 },
	zevrost = { npc = "Zevrost", id = 3326, m = 1454, x = 48.47, y = 45.43 },
	kaal = { npc = "Kaal Soulreaper", id = 4563, m = 1458, x = 86.21, y = 15.93 },
	spackle = { npc = "Spackle Thornberry", id = 5520, m = 1453, x = 39.53, y = 84.53 },
	jubahl = { npc = "Jubahl Corpseseeker", id = 6382, m = 1455, x = 52.70, y = 6.08 },
	kurgul = { npc = "Kurgul", id = 5815, m = 1454, x = 47.52, y = 46.72 },
	martha = { npc = "Martha Strain", id = 5753, m = 1458, x = 85.70, y = 16.08 },
	morzul = { npc = "Mor'zul Bloodbringer", id = 14436, m = 1428, x = 12.69, y = 31.64 },
	gorzeeki = { npc = "Gorzeeki Wildeyes", id = 14437, m = 1428, x = 12.43, y = 31.63 },
	banehollow = { npc = "Lord Banehollow", id = 9516, m = 1448, x = 35.93, y = 44.41 },
	urdan = { m = 1448, x = 36.17, y = 44.46 },
	-- The spirit has no spawn on Wowhead; the arrow points at the Dire Maul West door (ZH 25438, AFGELEID).
	dreadsteedSpirit = { npc = "Dreadsteed Spirit", id = 14504, m = 1444, x = 60.32, y = 30.16 },
	-- Objective places (no NPC).
	circleSW = { m = 1453, x = 39.11, y = 84.37 },
	circleOrg = { m = 1454, x = 49.44, y = 50.02 },
	circleUC = { m = 1458, x = 86.62, y = 27.10 },
	circleRatchet = { m = 1413, x = 62.60, y = 35.28 },
	stolenBooks = { m = 1429, x = 56.71, y = 43.95 },
	featherCharms = { m = 1426, x = 28.73, y = 82.58 },
	familiars = { m = 1411, x = 45.34, y = 56.36 },
	rattlecage = { m = 1420, x = 32.73, y = 60.10 },
	surena = { m = 1429, x = 71.02, y = 80.78 },
	verga = { m = 1411, x = 51.62, y = 9.74 },
	grimoire = { m = 1420, x = 51.06, y = 67.57 },
	heartswood = { m = 1440, x = 31.49, y = 31.45 },
	figurine = { m = 1440, x = 26.6, y = 22.0 },
	scarf = { m = 1440, x = 64.0, y = 79.0 },
	dalin = { m = 1421, x = 44.4, y = 83.4 },
	corma = { m = 1437, x = 50.0, y = 12.8 },
	avelina = { m = 1421, x = 63.5, y = 65.3 },
	isaac = { m = 1413, x = 61.8, y = 38.5 },
	moldyTome = { m = 1424, x = 27.78, y = 72.78 },
	manuscript = { m = 1441, x = 43.43, y = 32.69 },
	rods = { m = 1437, x = 45.09, y = 43.08 },
	owlbeasts = { m = 1452, x = 63.65, y = 16.33 },
	ulathek = { m = 1448, x = 40.77, y = 48.42 },
}

local HUM, GNO = { Human = true }, { Gnome = true }
local ORCTROLL, UD = { Orc = true, Troll = true }, { Scourge = true }
local W = WL_P

local function WlVoid(faction, races, first, steps)
	local quests = { first }
	for _, s in ipairs(steps) do
		quests[#quests + 1] = s
	end
	return { key = "voidwalker", spell = 697, level = 10, faction = faction, races = races, quests = quests }
end
local VOID_A = {
	{ q = 1688, from = W.gakin, objs = { O(W.surena, "FCQ_OBJ_WL_SURENA", 1) }, to = W.gakin },
	{ q = 1689, from = W.gakin, objs = { O(W.circleSW, "FCQ_OBJ_WL_BIND_VOID", 1) }, to = W.gakin },
}

local function WlFelhunter(faction, races, first, tome, tomeQ, rodsQ)
	return {
		key = "felhunter", spell = 691, level = 30, faction = faction, races = races,
		quests = {
			first,
			{ q = tomeQ[1], from = W.strahad, to = tome },
			{ q = tomeQ[2], from = tome, objs = { O(W.moldyTome, "FCQ_OBJ_WL_MOLDYTOME", 1), O(W.manuscript, "FCQ_OBJ_WL_MANUSCRIPT", 2) },
				to = tome },
			{ q = rodsQ, from = tome, objs = { O(W.rods, "FCQ_OBJ_WL_RODS", 1) }, to = W.strahad },
			{ q = 1795, from = W.strahad, objs = { O(W.circleRatchet, "FCQ_OBJ_WL_BIND_FEL", 1) }, to = W.strahad },
		},
	}
end

local function WlFelsteed(faction, races, q, alt, trainer)
	return {
		key = "felsteed", spell = 5784, level = 40, faction = faction, races = races,
		quests = {
			{ q = q, alt = alt, from = trainer, to = W.strahad },
			{ q = 4490, from = W.strahad, to = W.strahad },
		},
	}
end

-- Dreadsteed (60): 7562 from the race's demon trainer, then one line (order AFGELEID, see the header).
local function WlDreadsteed(faction, races, starter)
	return {
		key = "dreadsteed", spell = 23161, level = 60, faction = faction, races = races,
		quests = {
			{ q = 7562, from = starter, to = W.morzul },
			{ q = 7563, from = W.morzul, objs = { O(W.owlbeasts, "FCQ_OBJ_WL_BEASTBLOOD", 1) }, to = W.morzul },
			{ q = 7564, from = W.morzul, to = W.gorzeeki },
			{ q = 7626, from = W.morzul, objs = { O(nil, "FCQ_OBJ_WL_ELIXIR", 1) }, to = W.gorzeeki },
			{ q = 7627, from = W.morzul, objs = { O(nil, "FCQ_OBJ_WL_SHARDS", 1), O(nil, "FCQ_OBJ_WL_IRONORE", 2) }, to = W.gorzeeki },
			{ q = 7628, from = W.morzul, objs = { O(nil, "FCQ_OBJ_WL_DRAGONSCALE", 1) }, to = W.gorzeeki },
			{ q = 7630, from = W.gorzeeki, objs = { O(nil, "FCQ_OBJ_WL_ARCANITE", 1) }, to = W.gorzeeki },
			{ q = 7623, from = W.gorzeeki, to = W.banehollow },
			{ q = 7624, from = W.banehollow, objs = { O(W.ulathek, "FCQ_OBJ_WL_ULATHEK", 1) }, to = W.banehollow },
			{ q = 7625, from = W.banehollow, objs = { O(W.urdan, "FCQ_OBJ_WL_STARDUST", 1) }, to = W.gorzeeki },
			{ q = 7629, from = W.gorzeeki, objs = { O(nil, "FCQ_OBJ_WL_IMPJAR", 1) }, to = W.gorzeeki },
			-- Objective 1 = defeat the Xorothian Dreadsteed (14502): AFGELEID (the tooltip shows no objective).
			{ q = 7631, from = W.morzul, objs = { O(W.dreadsteedSpirit, "FCQ_OBJ_WL_RITUAL", 1) }, to = W.dreadsteedSpirit },
		},
	}
end

CHAINS.WARLOCK = {
	-- Imp (1): the first class quest teaches it in Forever (Wowhead Forever record, GEMETEN for 1598/1485).
	{ key = "imp", spell = 688, level = 1, faction = "Alliance", races = HUM, quests = {
		{ q = 1598, from = W.drusilla, objs = { O(W.stolenBooks, "FCQ_OBJ_WL_POWERSVOID", 1) }, to = W.drusilla } } },
	{ key = "imp", spell = 688, level = 1, faction = "Alliance", races = GNO, quests = {
		{ q = 1599, from = W.alamar, objs = { O(W.featherCharms, "FCQ_OBJ_WL_FEATHERCHARM", 1) }, to = W.alamar } } },
	{ key = "imp", spell = 688, level = 1, faction = "Horde", races = ORCTROLL, quests = {
		{ q = 1485, from = W.ruzan, objs = { O(W.familiars, "FCQ_OBJ_WL_FAMILIARHEAD", 1) }, to = W.ruzan } } },
	{ key = "imp", spell = 688, level = 1, faction = "Horde", races = UD, quests = {
		{ q = 1470, from = W.venya, objs = { O(W.rattlecage, "FCQ_OBJ_WL_RATTLESKULL", 1) }, to = W.venya } } },
	-- Voidwalker (10)
	WlVoid("Alliance", HUM, { q = 1685, from = W.remen, to = W.gakin }, VOID_A),
	WlVoid("Alliance", GNO, { q = 1715, from = W.lago, to = W.gakin }, VOID_A),
	WlVoid("Horde", ORCTROLL, { q = 1506, from = W.ophek, to = W.ganrul }, {
		{ q = 1501, from = W.ganrul, objs = { O(W.verga, "FCQ_OBJ_WL_VERGA", 1) }, to = W.ganrul },
		{ q = 1504, from = W.ganrul, objs = { O(W.circleOrg, "FCQ_OBJ_WL_BIND_VOID", 1) }, to = W.ganrul },
	}),
	WlVoid("Horde", UD, { q = 1478, from = W.ageron, to = W.carendin }, {
		{ q = 1473, from = W.carendin, objs = { O(W.grimoire, "FCQ_OBJ_WL_GRIMOIRE", 1) }, to = W.carendin },
		{ q = 1471, from = W.carendin, objs = { O(W.circleUC, "FCQ_OBJ_WL_BIND_VOID", 1) }, to = W.carendin },
	}),
	-- Succubus and Incubus (20): the same first quest; you can do both.
	{ key = "succubus", spell = 712, level = 20, faction = "Alliance", quests = {
		{ q = 1716, from = W.gakin, to = W.takar },
		{ q = 1738, from = W.takar, objs = { O(W.heartswood, "FCQ_OBJ_WL_HEARTSWOOD", 1) }, to = W.gakin },
		{ q = 1739, from = W.gakin, objs = { O(W.circleSW, "FCQ_OBJ_WL_BIND_SUCC", 1) }, to = W.gakin } } },
	{ key = "incubus", spell = 713, level = 20, faction = "Alliance", quests = {
		{ q = 1716, from = W.gakin, to = W.takar },
		{ q = 65602, from = W.takar, objs = { O(W.figurine, "FCQ_OBJ_WL_FIGURINE", 1) }, to = W.gakin },
		{ q = 65603, from = W.gakin, objs = { O(W.circleSW, "FCQ_OBJ_WL_BIND_INC", 1) }, to = W.gakin } } },
	{ key = "succubus", spell = 712, level = 20, faction = "Horde", races = ORCTROLL, quests = {
		{ q = 1507, from = W.ganrul, to = W.cazul },
		{ q = 1508, from = W.cazul, to = W.zankaja },
		{ q = 1509, from = W.zankaja, to = W.gazrog },
		{ q = 1510, from = W.gazrog, to = W.kenzigla },
		{ q = 1511, from = W.kenzigla, to = W.logmar },
		{ q = 1515, from = W.logmar, to = W.dogran },
		{ q = 1512, from = W.dogran, to = W.ganrul },
		{ q = 1513, from = W.ganrul, objs = { O(W.circleOrg, "FCQ_OBJ_WL_BIND_SUCC", 1) }, to = W.ganrul } } },
	{ key = "incubus", spell = 713, level = 20, faction = "Horde", races = ORCTROLL, quests = {
		{ q = 1507, from = W.ganrul, to = W.cazul },
		{ q = 65601, from = W.cazul, to = W.magar },
		{ q = 65610, from = W.magar, objs = { O(W.scarf, "FCQ_OBJ_WL_SCARF", 1) }, to = W.ganrul },
		{ q = 65604, from = W.ganrul, objs = { O(W.circleOrg, "FCQ_OBJ_WL_BIND_INC", 1) }, to = W.ganrul } } },
	{ key = "succubus", spell = 712, level = 20, faction = "Horde", races = UD, quests = {
		{ q = 1472, from = W.carendin, to = W.godrick },
		{ q = 1476, from = W.godrick, objs = { O(W.dalin, "FCQ_OBJ_WL_DALIN", 1), O(W.corma, "FCQ_OBJ_WL_CORMA", 2) }, to = W.carendin },
		{ q = 1474, from = W.carendin, objs = { O(W.circleUC, "FCQ_OBJ_WL_BIND_SUCC", 1) }, to = W.carendin } } },
	{ key = "incubus", spell = 713, level = 20, faction = "Horde", races = UD, quests = {
		{ q = 1472, from = W.carendin, to = W.godrick },
		{ q = 65593, from = W.godrick, objs = { O(W.avelina, "FCQ_OBJ_WL_AVELINA", 1), O(W.isaac, "FCQ_OBJ_WL_ISAAC", 2) }, to = W.carendin },
		{ q = 65597, from = W.carendin, objs = { O(W.circleUC, "FCQ_OBJ_WL_BIND_INC", 1) }, to = W.carendin } } },
	-- Felhunter (30): 2996 and 3001 exclude each other, so each is the other's alt.
	WlFelhunter("Alliance", nil, { q = 1798, from = W.gakin, to = W.strahad }, W.krom, { 1758, 1802 }, 1804),
	WlFelhunter("Horde", ORCTROLL, { q = 2996, alt = { 3001 }, from = W.ganrul, to = W.strahad }, W.jorah, { 1801, 1803 }, 1805),
	WlFelhunter("Horde", UD, { q = 3001, alt = { 2996 }, from = W.carendin, to = W.strahad }, W.jorah, { 1801, 1803 }, 1805),
	-- Felsteed (40): one starter per race (they exclude each other), then 4490 at Strahad. In Forever the Felsteed is also
	-- a collection mount: whether the spell check sees it = NOT measured; the chain also ends once 4490 is done.
	WlFelsteed("Alliance", HUM, 4488, { 4487 }, W.demisette),
	WlFelsteed("Alliance", GNO, 4487, { 4488 }, W.briarthorn),
	WlFelsteed("Horde", ORCTROLL, 3631, { 4489 }, W.zevrost),
	WlFelsteed("Horde", UD, 4489, { 3631 }, W.kaal),
	-- Dreadsteed (60)
	WlDreadsteed("Alliance", HUM, W.spackle),
	WlDreadsteed("Alliance", GNO, W.jubahl),
	WlDreadsteed("Horde", ORCTROLL, W.kurgul),
	WlDreadsteed("Horde", UD, W.martha),
}

--[[ Warrior (17 Nov 2026, Bouwchat 17-11). All facts: docs/forever/WARRIOR_CLASSQUESTS_2026-11-17.md (mh-research):
	Zygor Forever "Warrior Class Quests" + Common (Skyborne), Spoken, wago DB2 1.60.1.70938 (teach spells GEMETEN: 8121
	"Path of Defense" = 71 + 7386 + 355, 8616 "Path of the Berserker" = 2458 + 20252), Wowhead Forever, HandyNotes.
	AFGELEID: Taunt/Sunder come with the level 10 quest and Intercept with 1719 (Wowhead shows only the first spell);
	Skyborne 94003 = Defensive Stance GEMETEN, Taunt/Sunder for Skyborne NOT measured; which race walks which level 10
	route (every route is open to the whole faction; the split by starting zone is Zygor's). 1719 has no objective
	index on purpose (Wowhead and Zygor disagree): its step waits until the client says the quest is complete.
	Zygor mistakes not copied: 1821 sword /1 (not built), 1719 order, Sunken Temple |q 9053 in the Alliance guide (= 8425).
	Not built yet: the level 10 weapon and level 20 armour follow-ups (places of most materials unknown). ]]
local WR_P = {
	lyria = { npc = "Lyria Du Lac", id = 913, m = 1429, x = 41.10, y = 65.63 },
	harry = { npc = "Harry Burlguard", id = 6089, m = 1453, x = 77.13, y = 53.27 },
	bartleby = { npc = "Bartleby", id = 6090, m = 1453, x = 76.80, y = 53.20 },
	granis = { npc = "Granis Swiftaxe", id = 1229, m = 1426, x = 47.24, y = 52.78 },
	muren = { npc = "Muren Stormpike", id = 6114, m = 1455, x = 70.78, y = 90.27 },
	kyra = { npc = "Kyra Windblade", id = 3598, m = 1438, x = 56.21, y = 59.19 },
	elanaria = { npc = "Elanaria", id = 4088, m = 1457, x = 57.29, y = 34.61 },
	tarshaw = { npc = "Tarshaw Jaggedscar", id = 3169, m = 1411, x = 54.09, y = 42.39 },
	krang = { npc = "Krang Stonehoof", id = 3063, m = 1412, x = 48.35, y = 63.74 },
	uzzek = { npc = "Uzzek", id = 5810, m = 1413, x = 61.38, y = 21.11 },
	austil = { npc = "Austil de Mon", id = 2131, m = 1420, x = 61.87, y = 52.85 },
	dillinger = { npc = "Deathguard Dillinger", id = 1496, m = 1420, x = 58.20, y = 51.45 },
	seena = { npc = "Seena Skybreaker", id = 252377, m = 2521, x = 59.91, y = 73.08 },
	wushen = { npc = "Wu Shen", id = 5479, m = 1453, x = 80.70, y = 59.95 },
	sorek = { npc = "Sorek", id = 3354, m = 1454, x = 80.39, y = 32.38 },
	klannoc = { npc = "Klannoc Macleod", id = 6236, m = 1413, x = 68.62, y = 49.17 },
	bathrah = { npc = "Bath'rah the Windwatcher", id = 6176, m = 1416, x = 80.50, y = 66.92 },
	fallenHero = { npc = "Fallen Hero of the Horde", id = 7572, m = 1435, x = 34.29, y = 66.15 },
	-- Objective places (no NPC), Zygor.
	vejrek = { m = 1426, x = 27.83, y = 57.95 },
	vorlus = { m = 1438, x = 47.26, y = 63.52 },
	lizards = { m = 1411, x = 39.27, y = 28.29 },
	ulag = { m = 1420, x = 59.64, y = 48.09 },
	zaal = { m = 2521, x = 56.61, y = 50.37 },
	grate = { m = 1413, x = 68.61, y = 48.72 },
	tusks = { m = 1434, x = 25.85, y = 11.25 },
	charmBurning = { m = 1417, x = 26.60, y = 31.80 },
	charmThundering = { m = 1417, x = 52.60, y = 52.20 },
	charmCresting = { m = 1417, x = 68.00, y = 30.00 },
	cauldron = { m = 1416, x = 79.31, y = 66.81 },
	cyclonian = { m = 1416, x = 80.57, y = 62.56 },
	helboar = { m = 1419, x = 51.34, y = 53.45 },
	shadowsworn = { m = 1419, x = 65.17, y = 32.83 },
}
local R = WR_P
local DWGN, NELF, TAUREN = { Dwarf = true, Gnome = true }, { NightElf = true }, { Tauren = true }

local function WrDefense(faction, races, quests)
	return { key = "defensive", spell = 71, level = 10, faction = faction, races = races, quests = quests }
end
local function WrUzzek(races, starter)
	return WrDefense("Horde", races, {
		{ q = 1505, from = starter, to = R.uzzek },
		{ q = 1498, from = R.uzzek, objs = { O(R.lizards, "FCQ_OBJ_WR_SCALES", 1) }, to = R.uzzek },
	})
end

CHAINS.WARRIOR = {
	WrDefense("Alliance", HUM, {
		{ q = 1638, from = R.lyria, to = R.harry },
		{ q = 1639, from = R.harry, to = R.bartleby },
		{ q = 1640, from = R.bartleby, objs = { O(R.bartleby, "FCQ_OBJ_WR_BEATBARTLEBY", 1) }, to = R.bartleby },
		{ q = 1665, from = R.bartleby, to = R.harry },
	}),
	WrDefense("Alliance", DWGN, {
		{ q = 1679, from = R.granis, to = R.muren },
		{ q = 1678, from = R.muren, objs = { O(R.vejrek, "FCQ_OBJ_WR_VEJREK", nil, { 6799 }) }, to = R.muren },
	}),
	WrDefense("Alliance", NELF, {
		{ q = 1684, from = R.kyra, to = R.elanaria },
		{ q = 1683, from = R.elanaria, objs = { O(R.vorlus, "FCQ_OBJ_WR_VORLUS", nil, { 6805 }) }, to = R.elanaria },
	}),
	WrUzzek(ORCTROLL, R.tarshaw),
	WrUzzek(TAUREN, R.krang),
	WrDefense("Horde", UD, {
		{ q = 1818, from = R.austil, to = R.dillinger },
		{ q = 1819, from = R.dillinger, objs = { O(R.ulag, "FCQ_OBJ_WR_ULAG", 1) }, to = R.dillinger },
	}),
}
for _, faction in ipairs({ "Alliance", "Horde" }) do
	local trainer = faction == "Alliance" and R.wushen or R.sorek
	table.insert(CHAINS.WARRIOR, WrDefense(faction, SKYBORNE, {
		{ q = 94003, from = R.seena, objs = { O(R.zaal, "FCQ_OBJ_WR_ZAAL", nil, { 263993 }) }, to = R.seena },
	}))
	table.insert(CHAINS.WARRIOR, { key = "berserker", spell = 2458, level = 30, faction = faction, quests = {
		{ q = 1718, from = trainer, to = R.klannoc },
		{ q = 1719, from = R.klannoc, objs = { O(R.grate, "FCQ_OBJ_WR_AFFRAY") }, to = R.klannoc },
	} })
	-- Item chain: opens after 1719 (Spoken prev, GEMETEN). Cyclonian is a level 40 elite. The three charms are quest
	-- 1714 at the cauldron (an object, not an NPC): asked inside 1712; one charm in your bags counts as done (a limit).
	table.insert(CHAINS.WARRIOR, { key = "whirlwind", nameKey = "FCQ_CHAIN_WR_WHIRLWIND", level = 30, needs = 1719,
		faction = faction, quests = {
			{ q = 1791, from = R.klannoc, to = R.bathrah },
			{ q = 1712, from = R.bathrah, objs = {
				O(nil, "FCQ_OBJ_WR_LIFEROOT", 1),
				O(R.tusks, "FCQ_OBJ_WR_TUSKS", 2),
				O(R.charmBurning, "FCQ_OBJ_WR_CHARM_BURNING", nil, { 4479, 6851 }),
				O(R.charmThundering, "FCQ_OBJ_WR_CHARM_THUNDERING", nil, { 4480, 6851 }),
				O(R.charmCresting, "FCQ_OBJ_WR_CHARM_CRESTING", nil, { 4481, 6851 }),
				O(R.cauldron, "FCQ_OBJ_WR_ESSENCE", 3),
			}, to = R.bathrah },
			{ q = 1713, from = R.bathrah, objs = { O(R.cyclonian, "FCQ_OBJ_WR_CYCLONIAN", nil, { 6894 }) }, to = R.bathrah },
			{ q = 1792, from = R.bathrah, to = R.bathrah },
		} })
	table.insert(CHAINS.WARRIOR, { key = "fallenhero", nameKey = "FCQ_CHAIN_WR_FALLENHERO", level = 50, faction = faction,
		quests = {
			{ q = 8417, from = trainer, to = R.fallenHero },
			{ q = 8423, from = R.fallenHero, objs = { O(R.helboar, "FCQ_OBJ_WR_HELBOAR", 1) }, to = R.fallenHero },
			{ q = 8424, from = R.fallenHero, objs = {
				O(R.shadowsworn, "FCQ_OBJ_WR_ADEPT", 1),
				O(R.shadowsworn, "FCQ_OBJ_WR_CULTIST", 2),
				O(R.shadowsworn, "FCQ_OBJ_WR_THUG", 3),
			}, to = R.fallenHero },
			{ q = 8425, from = R.fallenHero, objs = {
				O(P.sunken, "FCQ_OBJ_WR_FEATHER_AMBER", 1),
				O(P.sunken, "FCQ_OBJ_WR_FEATHER_BLUE", 2),
				O(P.sunken, "FCQ_OBJ_WR_FEATHER_GREEN", 3),
			}, to = R.fallenHero },
		} })
end

--[[ Hunter (17 Nov 2026, Bouwchat 17-11; researched by mh-research on Fable after Rob's "ja" via Sparring 17-11). All
	facts: docs/forever/HUNTER_CLASSQUESTS_2026-11-17.md: Zygor Forever "Hunter Class Quests" + the leveling guides
	(Human, Skyborne), Spoken, wago DB2 1.60.1.70938, Wowhead Forever, HandyNotes.
	GEMETEN: teach spell 1579 = Tame Beast 1515 + Call Pet 883 + Dismiss Pet 2641; 5300 = Beast Training 5149 + Feed Pet
	6991 + Revive Pet 982 (DB2); Wowhead shows "You will learn" Tame Beast on the third taming quest and Beast Training on
	Training the Beast. AFGELEID: the Human quests (Wowhead: Taming Lesson 23356 / Training Lesson 23357, dummy spells)
	teach the same six; the Elwynn chain is for Humans (Spoken: every Alliance race may take it); the objective index;
	which trainer starts the level 50 chain per race (five trainers give 8151). No Gnome or Undead hunter (CharBaseInfo).
	Not built: the breadcrumb The Hunter's Path (optional), and the level 60 chain The Ancient Leaf (starts from an item).
	Zygor mistakes not copied: |q 8425 in the Horde hunter guide (= 8232), "Vartus". Trainers: HandyNotes; the rest: Zygor. ]]
local HU_P = {
	dazalar = { npc = "Dazalar", id = 3601, m = 1438, x = 56.66, y = 59.40 },
	jocaste = { npc = "Jocaste", id = 4146, m = 1457, x = 40.38, y = 8.55 },
	grif = { npc = "Grif Wildheart", id = 1231, m = 1426, x = 45.81, y = 53.04 },
	belia = { npc = "Belia Thundergranite", id = 10090, m = 1455, x = 70.86, y = 85.83 },
	josephine = { npc = "Josephine Carson", id = 251507, m = 1429, x = 41.36, y = 66.28 },
	isaac = { npc = "Isaac Chan", id = 258930, m = 1429, x = 41.84, y = 66.41 },
	thotar = { npc = "Thotar", id = 3171, m = 1411, x = 51.66, y = 43.40 },
	ormak = { npc = "Ormak Grimshot", id = 3352, m = 1454, x = 66.05, y = 18.53 },
	yaw = { npc = "Yaw Sharpmane", id = 3065, m = 1412, x = 47.11, y = 59.57 },
	holt = { npc = "Holt Thunderhorn", id = 3039, m = 1456, x = 57.33, y = 89.82 },
	quelana = { npc = "Quel'ana Quickgale", id = 252389, m = 2521, x = 59.33, y = 72.63 },
	queldora = { npc = "Quel'dora Quickgale", id = 254411, m = 2521, x = 59.69, y = 72.11 },
	dorion = { npc = "Dorion", id = 4205, m = 1457, x = 42.21, y = 7.27 },
	olmin = { npc = "Olmin Burningbeard", id = 5116, m = 1455, x = 70.89, y = 83.61 },
	ulfir = { npc = "Ulfir Ironbeard", id = 5516, m = 1453, x = 67.57, y = 35.77 },
	ogtinc = { npc = "Ogtinc", id = 8405, m = 1447, x = 42.40, y = 42.62 },
	-- Where to tame (no NPC), Zygor. Azshara = UiMap 1447 (DB2).
	webwood = { m = 1438, x = 59.81, y = 59.06 },
	nightsaber = { m = 1438, x = 55.95, y = 71.98 },
	screecher = { m = 1438, x = 43.99, y = 51.16 },
	cragboar = { m = 1426, x = 48.26, y = 56.81 },
	snowleopard = { m = 1426, x = 48.68, y = 58.93 },
	iceclaw = { m = 1426, x = 49.06, y = 62.12 },
	rockhide = { m = 1429, x = 46.04, y = 77.92 },
	graywolf = { m = 1429, x = 65.73, y = 63.52 },
	forestbear = { m = 1429, x = 46.92, y = 78.34 },
	direboar = { m = 1411, x = 51.84, y = 47.23 },
	surfcrawler = { m = 1411, x = 59.01, y = 27.64 },
	scorpid = { m = 1411, x = 45.21, y = 45.77 },
	plainstrider = { m = 1412, x = 43.58, y = 56.46 },
	stalker = { m = 1412, x = 45.81, y = 54.16 },
	swoop = { m = 1412, x = 45.81, y = 54.16 },
	windsong = { m = 2521, x = 53.72, y = 77.80 },
	galestrider = { m = 2521, x = 57.30, y = 71.27 },
	vuldren = { m = 2521, x = 56.63, y = 67.74 },
	coursers = { m = 1447, x = 49.47, y = 17.62 },
	wavethrashers = { m = 1447, x = 52.61, y = 41.87 },
}
local H = HU_P

-- Three times Taming the Beast at one trainer: the Taming Rod is in your bags, objective 1 = tame the beast.
-- t = { { quest id, place, textKey }, ... }
local function HuTame(faction, races, trainer, t)
	local quests = {}
	for i, s in ipairs(t) do
		quests[i] = { q = s[1], from = trainer, objs = { O(s[2], s[3], 1) }, to = trainer }
	end
	return { key = "tame", spell = 1515, level = 10, faction = faction, races = races, quests = quests }
end
-- Training the Beast: opens after the third taming quest (Spoken prev, GEMETEN).
local function HuTrain(faction, races, q, needs, trainer, petTrainer)
	return { key = "training", spell = 5149, level = 10, needs = needs, faction = faction, races = races,
		quests = { { q = q, from = trainer, to = petTrainer } } }
end
-- The Hunter's Charm (level 50): an item chain. Any of the five trainers gives 8151 (Spoken).
local function HuCharm(faction, races, trainer)
	return { key = "charm", nameKey = "FCQ_CHAIN_HU_CHARM", level = 50, faction = faction, races = races, quests = {
		{ q = 8151, from = trainer, to = H.ogtinc },
		{ q = 8153, from = H.ogtinc, objs = { O(H.coursers, "FCQ_OBJ_HU_ANTLERS", 1) }, to = H.ogtinc },
		{ q = 8231, from = H.ogtinc, objs = { O(H.wavethrashers, "FCQ_OBJ_HU_SCALES", 1) }, to = H.ogtinc },
		{ q = 8232, from = H.ogtinc, objs = { O(P.sunken, "FCQ_OBJ_HU_MORPHAZ", 1) }, to = H.ogtinc },
	} }
end

CHAINS.HUNTER = {
	HuTame("Alliance", NELF, H.dazalar, {
		{ 6063, H.webwood, "FCQ_OBJ_HU_WEBWOOD" },
		{ 6101, H.nightsaber, "FCQ_OBJ_HU_NIGHTSABER" },
		{ 6102, H.screecher, "FCQ_OBJ_HU_SCREECHER" },
	}),
	HuTrain("Alliance", NELF, 6103, 6102, H.dazalar, H.jocaste),
	-- DWGN: there is no Gnome hunter (CharBaseInfo), so the extra race does nothing.
	HuTame("Alliance", DWGN, H.grif, {
		{ 6064, H.cragboar, "FCQ_OBJ_HU_CRAGBOAR" },
		{ 6084, H.snowleopard, "FCQ_OBJ_HU_SNOWLEOPARD" },
		{ 6085, H.iceclaw, "FCQ_OBJ_HU_ICECLAW" },
	}),
	HuTrain("Alliance", DWGN, 6086, 6085, H.grif, H.belia),
	-- Human: NEW in Forever. Wowhead shows Taming Lesson / Training Lesson; the same spells AFGELEID.
	HuTame("Alliance", HUM, H.josephine, {
		{ 94792, H.rockhide, "FCQ_OBJ_HU_ROCKHIDE" },
		{ 94863, H.graywolf, "FCQ_OBJ_HU_GRAYWOLF" },
		{ 94864, H.forestbear, "FCQ_OBJ_HU_FORESTBEAR" },
	}),
	HuTrain("Alliance", HUM, 94793, 94864, H.josephine, H.isaac),
	-- Orc/Troll: mind the order 6062, 6083, 6082.
	HuTame("Horde", ORCTROLL, H.thotar, {
		{ 6062, H.direboar, "FCQ_OBJ_HU_DIREBOAR" },
		{ 6083, H.surfcrawler, "FCQ_OBJ_HU_SURFCRAWLER" },
		{ 6082, H.scorpid, "FCQ_OBJ_HU_SCORPID" },
	}),
	HuTrain("Horde", ORCTROLL, 6081, 6082, H.thotar, H.ormak),
	HuTame("Horde", TAUREN, H.yaw, {
		{ 6061, H.plainstrider, "FCQ_OBJ_HU_PLAINSTRIDER" },
		{ 6087, H.stalker, "FCQ_OBJ_HU_STALKER" },
		{ 6088, H.swoop, "FCQ_OBJ_HU_SWOOP" },
	}),
	HuTrain("Horde", TAUREN, 6089, 6088, H.yaw, H.holt),
}
for _, faction in ipairs({ "Alliance", "Horde" }) do
	-- Skyborne: NEW in Forever, the same quests for both factions (Zephras Isle).
	table.insert(CHAINS.HUNTER, HuTame(faction, SKYBORNE, H.quelana, {
		{ 94978, H.windsong, "FCQ_OBJ_HU_WINDSONG" },
		{ 94979, H.galestrider, "FCQ_OBJ_HU_GALESTRIDER" },
		{ 94013, H.vuldren, "FCQ_OBJ_HU_VULDREN" },
	}))
	table.insert(CHAINS.HUNTER, HuTrain(faction, SKYBORNE, 94050, 94013, H.quelana, H.queldora))
end
-- Level 50: the trainer per race is a choice (AFGELEID); any of them gives 8151.
for _, c in ipairs({
	{ "Alliance", HUM, H.ulfir }, { "Alliance", DWGN, H.olmin }, { "Alliance", NELF, H.dorion }, { "Alliance", SKYBORNE, H.ulfir },
	{ "Horde", ORCTROLL, H.ormak }, { "Horde", TAUREN, H.holt }, { "Horde", SKYBORNE, H.ormak },
}) do
	table.insert(CHAINS.HUNTER, HuCharm(c[1], c[2], c[3]))
end

--[[ Rogue (17 Nov 2026, Bouwchat 17-11; researched by mh-research on Fable). All facts:
	docs/forever/ROGUE_CLASSQUESTS_2026-11-17.md: Zygor Forever (class guides + main leveling guides), Spoken, wago DB2
	1.60.1.70938 (local cache), Wowhead Forever, Icy Veins, Polestar, HandyNotes.
	Poisons 2842 comes from 2359 (Alliance) / 2480 (Horde): GEMETEN on Wowhead Forever. Pick Lock is a trainer spell.
	NEW in Forever, not in Zygor: The Horn of Xelthos (78261-78307) and The Eye of Bhossca (78676-78699); the hand-in
	quests come after a letter from C, so their step says to wait (e.wait). No Tauren rogue (CharBaseInfo).
	AFGELEID: Troll starts at 1963; Skyborne (Alliance) walks the Human route; 2379 without its pointer quest;
	level 23/30 and needs = 78261 for the two Dead Drop chains; what 8236 pays in Forever is NOT measured.
	Not built (bouwchat choice, Rob may reverse): the Touch of Zanzil cure (a player who cures it another way would keep
	the line forever), the level 16 race pointers, Ravenholdt reputation quests.
	Zygor mistakes not copied: Varimathras 59.75,84.64, the 1978 pickup at 65.53,79.73, |q 8232 / 8425 (= 8236). ]]
local RO_P = {
	keryn = { npc = "Keryn Sylvius", id = 917, m = 1429, x = 43.87, y = 65.94 },
	shaw = { npc = "Master Mathias Shaw", id = 332, m = 1453, x = 78.31, y = 70.75 },
	hogral = { npc = "Hogral Bakkan", id = 1234, m = 1426, x = 47.72, y = 52.62 },
	hulfdan = { npc = "Hulfdan Blackbeard", id = 5165, m = 1455, x = 51.96, y = 14.84 },
	onin = { npc = "Onin MacHammar", id = 6886, m = 1426, x = 25.16, y = 44.45 },
	jannok = { npc = "Jannok Breezesong", id = 3599, m = 1438, x = 56.38, y = 60.14 },
	syurna = { npc = "Syurna", id = 4163, m = 1457, x = 36.99, y = 21.91 },
	renzik = { npc = "Renzik \"The Shiv\"", id = 6946, m = 1453, x = 78.25, y = 71.13 },
	lucius = { npc = "Lucius", id = 6966, m = 1433, x = 22.97, y = 52.04 },
	kearnen = { npc = "Agent Kearnen", id = 7024, m = 1436, x = 68.49, y = 70.08 },
	romano = { npc = "Lord Tony Romano", id = 13283, m = 1453, x = 80.28, y = 68.58 },
	kaplak = { npc = "Kaplak", id = 3170, m = 1411, x = 51.92, y = 43.83 },
	therzok = { npc = "Therzok", id = 6446, m = 1454, x = 42.74, y = 53.54 },
	marion = { npc = "Marion Call", id = 2130, m = 1420, x = 61.85, y = 51.89 },
	mennet = { npc = "Mennet Carkad", id = 6467, m = 1458, x = 83.51, y = 69.11 },
	andron = { npc = "Andron Gant", id = 6522, m = 1458, x = 54.82, y = 76.30 },
	varimathras = { npc = "Varimathras", id = 2425, m = 1458, x = 56.24, y = 92.22 },
	shenthul = { npc = "Shenthul", id = 3401, m = 1454, x = 43.05, y = 53.74 },
	zandozan = { npc = "Zando'zan", id = 3402, m = 1454, x = 42.73, y = 52.95 },
	wrenix = { npc = "Wrenix the Wretched", id = 7161, m = 1413, x = 63.07, y = 36.32 },
	fizzule = { npc = "Taskmaster Fizzule", id = 7233, m = 1413, x = 55.44, y = 5.56 },
	hinott = { npc = "Serge Hinott", id = 2391, m = 1424, x = 61.63, y = 19.19 },
	ormok = { npc = "Ormok", id = 3328, m = 1454, x = 43.90, y = 54.63 },
	jorach = { npc = "Lord Jorach Ravenholdt", id = 6768, m = 1416, x = 86.03, y = 78.88 },
	xylem = { npc = "Archmage Xylem", id = 8379, m = 1447, x = 29.71, y = 40.52 },
	-- The Dead Drop is a chest (object 410369), not an NPC: no id, so the English name shows in every language.
	deadDrop = { npc = "Dead Drop", m = 1421, x = 47.1, y = 71.1 },
	veenix = { npc = "Veenix", id = 4086, m = 1442, x = 58.2, y = 51.6 },
	-- Objective places (no NPC).
	dockmaster = { m = 1429, x = 48.0, y = 87.0 },
	sethir = { m = 1438, x = 37.52, y = 24.29 },
	luciusBox = { m = 1433, x = 46.95, y = 44.69 },
	towerKey = { m = 1436, x = 71.63, y = 73.91 },
	duskChest = { m = 1436, x = 70.41, y = 73.93 },
	tazan = { m = 1413, x = 62.92, y = 44.07 },
	gamon = { m = 1454, x = 54.00, y = 68.03 },
	astor = { m = 1421, x = 47.50, y = 39.80 },
	bookshelf = { m = 1458, x = 55.42, y = 77.05 },
	gizmo = { m = 1413, x = 63.12, y = 36.32 },
	jewel = { m = 1413, x = 64.95, y = 45.44 },
	flare = { m = 1413, x = 55.47, y = 6.08 },
	silixiz = { m = 1413, x = 54.80, y = 5.97 },
	vtower = { m = 1413, x = 54.75, y = 5.59 },
	timbermaw = { m = 1447, x = 43.77, y = 25.56 },
	oozes = { m = 1447, x = 73.40, y = 25.20 },
	sfk = { m = 1421, x = 44.8, y = 67.8 },
	sm = { m = 1420, x = 82.65, y = 32.88 },
}
local RO = RO_P
local HUMSKY, ORC, TROLL = { Human = true, Skyborne = true }, { Orc = true }, { Troll = true }

local function RoBlade(faction, races, quests)
	return { key = "blade", nameKey = "FCQ_CHAIN_RO_BLADE", level = 10, faction = faction, races = races, quests = quests }
end
-- 1963: the satchel is objective 1 (handed in, then given back for 1858). 1858: 1 = Logbook, 2 = Key (Wowhead order).
local RO_HAND1 = { q = 1963, from = RO.therzok, objs = { O(RO.tazan, "FCQ_OBJ_RO_TAZAN", 1) }, to = RO.therzok }
local RO_HAND2 = { q = 1858, from = RO.therzok, objs = {
	O(RO.gamon, "FCQ_OBJ_RO_TAZANKEY", 2),
	O(nil, "FCQ_OBJ_RO_LOGBOOK", 1),
}, to = RO.therzok }

CHAINS.ROGUE = {
	-- Blade of Cunning (10). Skyborne (Alliance) on the Human route: Polestar + the quest's race mask, not seen in game.
	RoBlade("Alliance", HUMSKY, {
		{ q = 2205, from = RO.keryn, to = RO.shaw },
		{ q = 2206, from = RO.shaw, objs = { O(RO.dockmaster, "FCQ_OBJ_RO_SCHEDULE", 1) }, to = RO.shaw },
	}),
	RoBlade("Alliance", DWGN, {
		{ q = 2218, from = RO.hogral, to = RO.hulfdan },
		{ q = 2238, from = RO.hulfdan, to = RO.onin },
		{ q = 2239, from = RO.onin, to = RO.hulfdan },
	}),
	RoBlade("Alliance", NELF, {
		{ q = 2241, from = RO.jannok, to = RO.syurna },
		{ q = 2242, from = RO.syurna, objs = { O(RO.sethir, "FCQ_OBJ_RO_SETHIR", 1) }, to = RO.syurna },
	}),
	-- 1859 is Orc only (a pointer); a Troll takes 1963 straight from Therzok (Polestar; AFGELEID that it needs no 1859).
	RoBlade("Horde", ORC, { { q = 1859, from = RO.kaplak, to = RO.therzok }, RO_HAND1, RO_HAND2 }),
	RoBlade("Horde", TROLL, { RO_HAND1, RO_HAND2 }),
	RoBlade("Horde", UD, {
		{ q = 1885, from = RO.marion, to = RO.mennet },
		{ q = 1886, from = RO.mennet, objs = { O(RO.astor, "FCQ_OBJ_RO_ASTOR", 1) }, to = RO.mennet },
		{ q = 1898, from = RO.mennet, to = RO.andron },
		{ q = 1899, from = RO.andron, objs = { O(RO.bookshelf, "FCQ_OBJ_RO_LEDGER", 1) }, to = RO.mennet },
		{ q = 1978, from = RO.mennet, to = RO.varimathras },
	}),
	-- Thieves' Tools and the first lock (16). The race pointers (2300, 2299-2298, 2259-2260; 2380, 2378) are left out.
	{ key = "tools", nameKey = "FCQ_CHAIN_RO_TOOLS", level = 16, faction = "Alliance", quests = {
		{ q = 2281, from = RO.renzik, to = RO.lucius },
		{ q = 2282, from = RO.lucius, objs = { O(RO.luciusBox, "FCQ_OBJ_RO_LUCIUSBOX", 1) }, to = RO.lucius },
	} },
	{ key = "tools", nameKey = "FCQ_CHAIN_RO_TOOLS", level = 16, faction = "Horde", quests = {
		{ q = 2379, from = RO.shenthul, to = RO.zandozan },
		{ q = 2382, from = RO.zandozan, to = RO.wrenix },
		-- E.C.A.C. (7970) in your bags, or the treasure already: the machine step is done.
		{ q = 2381, from = RO.wrenix, objs = {
			O(RO.gizmo, "FCQ_OBJ_RO_GIZMO", nil, { 7970, 7968 }),
			O(RO.jewel, "FCQ_OBJ_RO_SOUTHSEA", 1),
		}, to = RO.wrenix },
	} },
	-- Poisons (20).
	{ key = "poisons", spell = 2842, level = 20, faction = "Alliance", quests = {
		{ q = 2360, from = RO.shaw, to = RO.kearnen },
		{ q = 2359, from = RO.kearnen, objs = {
			O(RO.towerKey, "FCQ_OBJ_RO_TOWERKEY", 2),
			O(RO.duskChest, "FCQ_OBJ_RO_JOURNAL", 1),
		}, to = RO.shaw },
	} },
	{ key = "poisons", spell = 2842, level = 20, faction = "Horde", quests = {
		{ q = 2460, from = RO.shenthul, objs = { O(RO.shenthul, "FCQ_OBJ_RO_SALUTE", 1) }, to = RO.shenthul },
		-- No index on purpose (Wowhead shows no objective, Zygor says /1): waits until the client says complete.
		{ q = 2458, from = RO.shenthul, objs = { O(RO.flare, "FCQ_OBJ_RO_FLARE") }, to = RO.fizzule },
		{ q = 2478, from = RO.fizzule, objs = {
			O(RO.silixiz, "FCQ_OBJ_RO_SILIXIZ", 5),
			O(RO.vtower, "FCQ_OBJ_RO_DRONES", 1),
			O(RO.vtower, "FCQ_OBJ_RO_PATROLLERS", 3),
			O(RO.vtower, "FCQ_OBJ_RO_LOOKOUTS", 2),
			O(RO.vtower, "FCQ_OBJ_RO_GALLYWIX", 4),
			O(RO.vtower, "FCQ_OBJ_RO_CACHE", 6),
		}, to = RO.shenthul },
		{ q = 2479, from = RO.shenthul, to = RO.hinott },
		{ q = 2480, from = RO.hinott, objs = { O(RO.hinott, "FCQ_OBJ_RO_CURE", 1) }, to = RO.hinott },
	} },
}
for _, faction in ipairs({ "Alliance", "Horde" }) do
	-- NEW in Forever. 78270 Goblin Lockpicks (Veenix) is a side quest inside 78261, not a step (missing from QuestV2).
	-- 78307 and 78699 are hand-ins only, offered after a letter from C (minutes to hours later): e.wait.
	table.insert(CHAINS.ROGUE, { key = "xelthos", nameKey = "FCQ_CHAIN_RO_XELTHOS", level = 23, faction = faction, quests = {
		{ q = 78261, from = RO.deadDrop, objs = {
			O(RO.veenix, "FCQ_OBJ_RO_VEENIX", 2),
			O(RO.sfk, "FCQ_OBJ_RO_HORN", 1),
		}, to = RO.deadDrop },
		{ q = 78307, from = RO.deadDrop, wait = "FCQ_WAIT_RO_LETTER", to = RO.deadDrop },
	} })
	table.insert(CHAINS.ROGUE, { key = "bhossca", nameKey = "FCQ_CHAIN_RO_BHOSSCA", level = 30, needs = 78261,
		faction = faction, quests = {
			{ q = 78676, from = RO.deadDrop, objs = { O(RO.sm, "FCQ_OBJ_RO_EYE", 1) }, to = RO.deadDrop },
			{ q = 78699, from = RO.deadDrop, wait = "FCQ_WAIT_RO_LETTER", to = RO.deadDrop },
		} })
	-- The Azure Key (50). What 8236 pays in Forever is not measured (the Classic item choice may be gone).
	local trainer = faction == "Alliance" and RO.romano or RO.ormok
	table.insert(CHAINS.ROGUE, { key = "azure", nameKey = "FCQ_CHAIN_RO_AZURE", level = 50, faction = faction, quests = {
		{ q = 8233, from = trainer, to = RO.jorach },
		{ q = 8234, from = RO.jorach, objs = { O(RO.timbermaw, "FCQ_OBJ_RO_AZUREBAG", 1) }, to = RO.xylem },
		{ q = 8235, from = RO.xylem, objs = { O(RO.oozes, "FCQ_OBJ_RO_FRAGMENTS", 1) }, to = RO.xylem },
		{ q = 8236, from = RO.xylem, objs = { O(P.sunken, "FCQ_OBJ_RO_AZUREKEY", 1) }, to = RO.jorach },
	} })
end

local MOONGLADE, TELEPORT_MOONGLADE = 1450, 18960

local function Done(q)
	local f = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted
	if f then
		local ok, v = pcall(f, q)
		if ok then
			return v and true or false
		end
	end
	return false
end

local function InLog(q)
	local f = C_QuestLog and C_QuestLog.GetLogIndexForQuestID
	if f then
		local ok, v = pcall(f, q)
		return ok and v ~= nil and v ~= 0
	end
	return false
end

local function ObjDone(q)
	local f = C_QuestLog and C_QuestLog.IsComplete
	if f then
		local ok, v = pcall(f, q)
		return ok and v and true or false
	end
	return false
end

--- This step's quest, or one of its alternatives, is done / in the log.
local function AnyDone(e)
	if Done(e.q) then
		return true
	end
	for _, a in ipairs(e.alt or {}) do
		if Done(a) then
			return true
		end
	end
	return false
end

--- The quest id of this step that is in your log (an alternative counts), or nil.
local function LogQuest(e)
	if InLog(e.q) then
		return e.q
	end
	for _, a in ipairs(e.alt or {}) do
		if InLog(a) then
			return a
		end
	end
	return nil
end

local function HaveItem(id)
	for _, fn in ipairs({ C_Item and C_Item.GetItemCount, GetItemCount }) do
		if fn then
			local ok, n = pcall(fn, id)
			if ok and type(n) == "number" then
				return n > 0
			end
		end
	end
	return false
end

--- One objective of a quest in your log: finished? items = one of them in your bags; idx = the client's objective.
local function ObjFinished(q, o)
	if o.items then
		for _, id in ipairs(o.items) do
			if HaveItem(id) then
				return true
			end
		end
		return false
	end
	if o.idx and C_QuestLog and C_QuestLog.GetQuestObjectives then
		local ok, list = pcall(C_QuestLog.GetQuestObjectives, q)
		local row = ok and type(list) == "table" and list[o.idx]
		if row then
			return row.finished and true or false
		end
	end
	return false
end

local function Known(id)
	for _, fn in ipairs({ IsPlayerSpell, IsSpellKnown }) do
		if fn then
			local ok, k = pcall(fn, id)
			if ok and k then
				return true
			end
		end
	end
	return false
end

local function ZoneName(m)
	if C_Map and C_Map.GetMapInfo then
		local ok, info = pcall(C_Map.GetMapInfo, m)
		if ok and info and info.name then
			return info.name
		end
	end
	return "#" .. tostring(m)
end

-- NPC names per client language (rule 20 Oct 2026: every game name is the name THAT client shows). Filled from measured
-- data; a language missing here shows the English name. enUS/nlNL/itIT use English (no Dutch client; Forever itIT = English).
-- GEMETEN 16 Nov 2026 (mh-research): Wowhead Forever NPC tooltips per locale + the Spoken addon's name files (control: npc
-- 233 "Bauer Saldean" in both). English-looking de/fr names came back without Wowhead's [brackets] = that client's name.
-- 3064 esES: sources disagree (Runatótem vs Tótem de Runa), majority kept. 11799 esMX: not known, left out.
local NPC_NAMES = {
	[4218] = { deDE = "Denatharion", frFR = "Denatharion", esES = "Denatharion", esMX = "Denatharion", ptBR = "Denatharion", ruRU = "Денатарион" },
	[4217] = { deDE = "Mathrengyl Bearwalker", frFR = "Mathrengyl Bearwalker", esES = "Mathrengyl Garroso", esMX = "Mathrengyl Garroso", ptBR = "Mathrengyl Ursivagus", ruRU = "Матренгил Медвежья Лапа" },
	[11802] = { deDE = "Dendrite Starblaze", frFR = "Dendrite Starblaze", esES = "Dendrite Rafagaestelar", esMX = "Dendrita Rafagaestelar", ptBR = "Dendrite Stellardor", ruRU = "Дендрит Блеск Звезд" },
	[11956] = { deDE = "Großer Bärengeist", frFR = "Esprit du Grand ours", esES = "Espíritu del gran oso", esMX = "Espíritu del gran oso", ptBR = "Espírito do Grande Urso", ruRU = "Дух Великого Медведя" },
	[3064] = { deDE = "Gennia Runetotem", frFR = "Gennia Runetotem", esES = "Gennia Runatótem", esMX = "Gennia Tótem de Runa", ptBR = "Gennia Runa Totem", ruRU = "Генния Рунический Тотем" },
	[3033] = { deDE = "Turak Runetotem", frFR = "Turak Runetotem", esES = "Turak Runatótem", esMX = "Turak Tótem de Runa", ptBR = "Turak Runa Totem", ruRU = "Тюрак Рунический Тотем" },
	[3702] = { deDE = "Alanndarian Nightsong", frFR = "Alanndarian Nightsong", esES = "Alanndarian Arrullanoche", esMX = "Alanndarian Arrullanoche", ptBR = "Alanndária Noturcanto", ruRU = "Аландариан Песня Ночи" },
	[3448] = { deDE = "Tonga Runetotem", frFR = "Tonga Runetotem", esES = "Tonga Runatótem", esMX = "Tonga Tótem de Runa", ptBR = "Tonga Runa Totem", ruRU = "Тонга Рунический Тотем" },
	[11799] = { deDE = "Tajarri", frFR = "Tajarri", esES = "Tajarri", ptBR = "Tajarri", ruRU = "Таджарри" },
	[9619] = { deDE = "Torwa Pathfinder", frFR = "Torwa Pathfinder", esES = "Abrecaminos Torwa", esMX = "Torwa Abrecaminos", ptBR = "Torwa Mateiro", ruRU = "Землепроходец Торва" },
	[11957] = { deDE = "Großer Katzengeist", frFR = "Esprit du Grand félin", esES = "Gran espíritu felino", esMX = "Gran espíritu felino", ptBR = "Espírito do Grande Felino", ruRU = "Дух Великой Кошки" },
	[272054] = { deDE = "Avatar von Saeyleenan", frFR = "Avatar de Saeyleenan", esES = "Avatar de Saeyleenan", esMX = "Avatar de Saeyleenan", ptBR = "Avatar de Saeyleenan", ruRU = "Аватара Сэйлинан" },
	[252359] = { deDE = "Lotheluum Starbreeze", frFR = "Lotheluum Brise-Stellaire", esES = "Lotheluum Brisa Estelar", esMX = "Lotheluum Brisa Estelar", ptBR = "Lotheluum Brisastral", ruRU = "Лотелум Звездный Ветер" },
	[255853] = { deDE = "Urs'endris", frFR = "Urs'endris", esES = "Urs'endris", esMX = "Urs'endris", ptBR = "Urs'endris", ruRU = "Урс'ендрис" },
	-- Warlock (17 Nov 2026, mh-research: Wowhead Forever tooltips per locale; esMX gaps from Spoken esMX.lua; control npc
	-- 233 again). Missing esMX = not measured, English shows. 460 ruRU "Мрачнн" is as Wowhead has it (kept).
	[459] = { deDE = "Drusilla La Salle", frFR = "Drusilla La Salle", esES = "Drusilla La Salle", esMX = "Drusilla La Salle", ptBR = "Drusilla La Salle", ruRU = "Друзилла ла Салле" },
	[460] = { deDE = "Alamar Grimm", frFR = "Alamar Grimm", esES = "Alamar Grimm", esMX = "Alamar Grimm", ptBR = "Alamar Carranca", ruRU = "Аламар Мрачнн" },
	[5765] = { deDE = "Ruzan", frFR = "Ruzan", esES = "Ruzan", esMX = "Ruzan", ptBR = "Ruzan", ruRU = "Рузан" },
	[5667] = { deDE = "Venya Marthand", frFR = "Venya Marthand", esES = "Venya Martmani", esMX = "Venya Marthand", ptBR = "Vênia Martingil", ruRU = "Вения Мартанд" },
	[6121] = { deDE = "Remen Marcot", frFR = "Remen Marcot", esES = "Remen Marcot", esMX = "Remen Marcot", ptBR = "Rêmulo Marcos", ruRU = "Ремен Маркот" },
	[6120] = { deDE = "Lago Blackwrench", frFR = "Lago Blackwrench", esES = "Llago Llavenegra", esMX = "Yago Llavenegra", ptBR = "Iago Chavenegra", ruRU = "Лаго Злобноверт" },
	[6122] = { deDE = "Gakin der Dunkelbinder", frFR = "Gakin le Tisse-noir", esES = "Gakin el Presotenebra", esMX = "Gakin el Presotenebra", ptBR = "Gakin, o Neromante", ruRU = "Гакин Темнопряд" },
	[3294] = { deDE = "Ophek", frFR = "Ophek", esES = "Ophek", esMX = "Ophek", ptBR = "Ophek", ruRU = "Офек" },
	[5875] = { deDE = "Gan'rul Bloodeye", frFR = "Gan'rul Bloodeye", esES = "Ojo sangriento de Gan'rul", esMX = "Gan'rul Ojosangre", ptBR = "Gan'rul Olho de Sangue", ruRU = "Ган'рул Кровавый Глаз" },
	[5724] = { deDE = "Ageron Kargal", frFR = "Ageron Kargal", esES = "Ageron Kargal", esMX = "Ageron Kargal", ptBR = "Ageron Karhal", ruRU = "Агерон Каргал" },
	[5675] = { deDE = "Carendin Halgar", frFR = "Carendin Halgar", esES = "Carendin Halgar", esMX = "Carendin Halgar", ptBR = "Silvério Hidalgo", ruRU = "Карендин Халгар" },
	[6244] = { deDE = "Takar der Seher", frFR = "Takar le Prophète", esES = "Takar el Profeta", esMX = "Takar el Vidente", ptBR = "Takar, o Vidente", ruRU = "Такар Провидец" },
	[5909] = { deDE = "Cazul", frFR = "Cazul", esES = "Cazul", esMX = "Cazul", ptBR = "Cazul", ruRU = "Казул" },
	[5910] = { deDE = "Zankaja", frFR = "Zankaja", esES = "Zankaja", esMX = "Zankaja", ptBR = "Zankaja", ruRU = "Занкайя" },
	[3464] = { deDE = "Gazrog", frFR = "Gazrog", esES = "Gazrog", esMX = "Gazrog", ptBR = "Gazrog", ruRU = "Газрог" },
	[4197] = { deDE = "Ken'zigla", frFR = "Ken'zigla", esES = "Ken'zigla", esMX = "Ken'zigla", ptBR = "Ken'zigla", ruRU = "Кен'зигла" },
	[5911] = { deDE = "Grunzer Logmar", frFR = "Grunt Logmar", esES = "Bruto Logmar", esMX = "Bruto Logmar", ptBR = "Bruto Logmar", ruRU = "Рубака Логмар" },
	[5908] = { deDE = "Grunzer Dogran", frFR = "Grunt Dogran", esES = "Bruto Dogran", esMX = "Bruto Dogran", ptBR = "Bruto Dogran", ruRU = "Рубака Догран" },
	[3363] = { deDE = "Magar", frFR = "Magar", esES = "Magar", esMX = "Magar", ptBR = "Magar", ruRU = "Магар" },
	[5693] = { deDE = "Godrick Farsan", frFR = "Godrick Farsan", esES = "Godrick Farsan", esMX = "Godrick Farsan", ptBR = "Godofredo Fasano", ruRU = "Годрик Фарсан" },
	[6251] = { deDE = "Strahad Farsan", frFR = "Strahad Farsan", esES = "Strahad Farsan", esMX = "Strahad Farsan", ptBR = "Strahad Farsan", ruRU = "Страхад Фарсан" },
	[6294] = { deDE = "Krom Stoutarm", frFR = "Krom Stoutarm", esES = "Krom Brazorrecio", esMX = "Krom Brazorrecio", ptBR = "Krom Braçoforte", ruRU = "Кром Крепкорук" },
	[6293] = { deDE = "Jorah Annison", frFR = "Jorah Annison", esES = "Jorah Annison", esMX = "Jorah Annison", ptBR = "Jonas Anísio", ruRU = "Йорах Аннисон" },
	[461] = { deDE = "Demisette Cloyce", frFR = "Demisette Cloyce", esES = "Demisette Cloyce", esMX = "Demisette Cloyce", ptBR = "Joyce Lopes", ruRU = "Демизетта Клойс" },
	[5172] = { deDE = "Briarthorn", frFR = "Eglantine", esES = "Brezospina", esMX = "Brezospina", ptBR = "Cravespinho", ruRU = "Остротерн" },
	[3326] = { deDE = "Zevrost", frFR = "Zevrost", esES = "Zevrost", esMX = "Zevrost", ptBR = "Zevrost", ruRU = "Зеврост" },
	[4563] = { deDE = "Kaal Soulreaper", frFR = "Kaal Soulreaper", esES = "Revientalmas Kaal", esMX = "Kaal Segador de Almas", ptBR = "Kaal Ceifalma", ruRU = "Каел Жнец Душ" },
	[5520] = { deDE = "Spackle Thornberry", frFR = "Spackle Thornberry", esES = "Spackle Espinamora", esMX = "Spackle Zarzamora", ptBR = "Spackle Cardopomo", ruRU = "Шпакл Шиповникс" },
	[6382] = { deDE = "Jubaal Corpseseeker", frFR = "Jubahl Cherche-corps", esES = "Jubahl Buscadáver", esMX = "Jubahl Buscador de cadáveres", ptBR = "Jubahl Catadefunto", ruRU = "Жубал Труполов" },
	[5815] = { deDE = "Kurgul", frFR = "Kurgul", esES = "Kurgul", esMX = "Kurgul", ptBR = "Kurgul", ruRU = "Кургул" },
	[5753] = { deDE = "Martha Strain", frFR = "Martha Strain", esES = "Martha Forza", esMX = "Martha Strain", ptBR = "Marta Seixas", ruRU = "Марта Стрейн" },
	[14436] = { deDE = "Mor'zul Bloodbringer", frFR = "Mor'zul Bloodbringer", esES = "Mor'zul Sangredoble", esMX = "Mor'zul Sangredoble", ptBR = "Mor'zul Trazangre", ruRU = "Мор'зул Кровопуск" },
	[14437] = { deDE = "Gorzeeki Wildeyes", frFR = "Gorzeeki Wildeyes", esES = "Gorzeeki Ojosalvajes", esMX = "Gorzeeki Ojovago", ptBR = "Gorzeeki Olholouco", ruRU = "Горзиеки Дикоглаз" },
	[9516] = { deDE = "Lord Banehollow", frFR = "Seigneur Banehollow", esES = "Lord Pesadilla", ptBR = "Lorde Nihilus", ruRU = "Лорд Гиблопуст" },
	[14504] = { deDE = "Schreckensrossgeist", frFR = "Esprit de Destrier de l'effroi", esES = "Espíritu Corcelorror", ptBR = "Espírito de Corcel Medonho", ruRU = "Дух коня погибели" },
	-- Warrior (17 Nov 2026, mh-research, same way; second source Spoken agreed where both had a name). 6236 esMX: not measured.
	[913] = { deDE = "Lyria Du Lac", frFR = "Lyria Du Lac", esES = "Lyria Du Lac", esMX = "Lyria Du Lac", ptBR = "Lyria Du Lac", ruRU = "Лирия дю Лак" },
	[6089] = { deDE = "Harry Burlguard", frFR = "Harry Burlguard", esES = "Harry Burlguard", esMX = "Harry Burlguard", ptBR = "Ari Barbotina", ruRU = "Гарри Берлгард" },
	[6090] = { deDE = "Bartleby", frFR = "Bartleby", esES = "Bartleby", esMX = "Bartleby", ptBR = "Bartolino", ruRU = "Бартлби" },
	[1229] = { deDE = "Granis Swiftaxe", frFR = "Granis Swiftaxe", esES = "Granis Hachaveloz", esMX = "Granis Hachaveloz", ptBR = "Granis Celeraxa", ruRU = "Гранис Быстрый Топор" },
	[6114] = { deDE = "Muren Stormpike", frFR = "Muren Foudrepique", esES = "Muren Pico Tormenta", esMX = "Muren Pico Tormenta", ptBR = "Muren Lançatroz", ruRU = "Марен Грозовая Вершина" },
	[3598] = { deDE = "Kyra Windblade", frFR = "Kyra Windblade", esES = "Kyra Espada del Viento", esMX = "Kyra Espada del Viento", ptBR = "Kyra Laminéola", ruRU = "Кайра Ветрорез" },
	[4088] = { deDE = "Elanaria", frFR = "Elanaria", esES = "Elanaria", esMX = "Elanaria", ptBR = "Elanaria", ruRU = "Эланария" },
	[3169] = { deDE = "Tarshaw Jaggedscar", frFR = "Tarshaw Jaggedscar", esES = "Tarshaw Marcauna", esMX = "Tarshaw Marcauna", ptBR = "Tarshaw Zigatriz", ruRU = "Таршо Рваный Шрам" },
	[3063] = { deDE = "Krang Stonehoof", frFR = "Krang Stonehoof", esES = "Krang Pezuñapétrea", esMX = "Krang Pezuña Pétrea", ptBR = "Krang Casco de Pedra", ruRU = "Кранг Каменное Копыто" },
	[5810] = { deDE = "Uzzek", frFR = "Uzzek", esES = "Uzzek", esMX = "Uzzek", ptBR = "Uzzek", ruRU = "Уззек" },
	[2131] = { deDE = "Austil de Mon", frFR = "Austil de Mon", esES = "Austil de Mon", esMX = "Austil de Mon", ptBR = "Austil de Mon", ruRU = "Остил де Мон" },
	[1496] = { deDE = "Todeswache Dillinger", frFR = "Garde noir Dillinger", esES = "Guardia de la Muerte Dillinger", esMX = "Guardia de la Muerte Dillinger", ptBR = "Necroguarda Dinis", ruRU = "Страж смерти Диллинжер" },
	[252377] = { deDE = "Seena Skybreaker", frFR = "Seena Briseciel", esES = "Seena Rompecielos", esMX = "Seena Rompecielos", ptBR = "Seena Rompe-céus", ruRU = "Сиина Небовержица" },
	[5479] = { deDE = "Wu Shen", frFR = "Wu Shen", esES = "Wu Shen", esMX = "Wu Shen", ptBR = "Wu Shen", ruRU = "Ву Шен" },
	[3354] = { deDE = "Sorek", frFR = "Sorek", esES = "Sorek", esMX = "Sorek", ptBR = "Sorek", ruRU = "Сорек" },
	[6236] = { deDE = "Klannoc Macleod", frFR = "Klannoc Macleod", esES = "Klannoc Macleod", ptBR = "Klannoc Macleod", ruRU = "Кланнок Маклеод" },
	[6176] = { deDE = "Bath'rah der Windbehüter", frFR = "Bath'rah la Vigie des vents", esES = "Bath'rah el Cazavientos", esMX = "Bath'rah el Vigía del viento", ptBR = "Bath'rah, o Vigia dos Ventos", ruRU = "Бат'ра Ветростраж" },
	[7572] = { deDE = "Gefallener Held der Horde", frFR = "Héros déchu de la Horde", esES = "Héroe caído de la Horda", esMX = "Héroe caído de la Horda", ptBR = "Herói Caído da Horda", ruRU = "Павший герой Орды" },
	-- Hunter (17 Nov 2026, mh-research: Wowhead Forever tooltips per locale; control npc 233; Spoken agreed where it had a name).
	-- 3065 esES: Spoken says "Guin Crinafilada", Wowhead kept. 8405 esMX: not on Wowhead, left out. 3352 de/fr: Zygor's
	-- language file has other names; Wowhead Forever kept (AFGELEID which one the client shows).
	[3601] = { deDE = "Dazalar", frFR = "Dazalar", esES = "Dazalar", esMX = "Dazalar", ptBR = "Dazalar", ruRU = "Дазалар" },
	[4146] = { deDE = "Jocaste", frFR = "Jocaste", esES = "Jocaste", esMX = "Jocaste", ptBR = "Jocasta", ruRU = "Иокаста" },
	[1231] = { deDE = "Grif Wildheart", frFR = "Grif Wildheart", esES = "Grif Corazón Salvaje", esMX = "Grif Corazón Salvaje", ptBR = "Grif Selvacuore", ruRU = "Гриф Дикое Сердце" },
	[10090] = { deDE = "Belia Thundergranite", frFR = "Belia Thundergranite", esES = "Belia Tronagranito", esMX = "Belia Tronagranito", ptBR = "Bélia Granitrondo", ruRU = "Белия Громовой Гранит" },
	[3171] = { deDE = "Thotar", frFR = "Thotar", esES = "Thotar", esMX = "Thotar", ptBR = "Thotar", ruRU = "Тотар" },
	[3352] = { deDE = "Ormak Grimshot", frFR = "Ormak Grimshot", esES = "Ormak Tirosiniestro", esMX = "Ormak Tirosiniestro", ptBR = "Ormak Tiroatroz", ruRU = "Ормак Лютострел" },
	[3065] = { deDE = "Yaw Sharpmane", frFR = "Yaw Sharpmane", esES = "Yaw Crinafilada", esMX = "Yaw Crinafilada", ptBR = "Yaw Crina Cortante", ruRU = "Йо Колкая Грива" },
	[3039] = { deDE = "Holt Thunderhorn", frFR = "Holt Thunderhorn", esES = "Holt Tronacuerno", esMX = "Holt Tronacuerno", ptBR = "Holto Chifre Troante", ruRU = "Холь Громовой Рог" },
	[251507] = { deDE = "Josephine Carson", frFR = "Joséphine Carson", esES = "Josephine Carson", esMX = "Josephine Carson", ptBR = "Josefina Carsom", ruRU = "Жозефина Карсон" },
	[258930] = { deDE = "Isaac Chan", frFR = "Isaac Chan", esES = "Isaac Chan", esMX = "Isaac Chan", ptBR = "Isaac Chan", ruRU = "Исаак Чан" },
	[252389] = { deDE = "Quel'ana Quickgale", frFR = "Quel'ana Vent-Vif", esES = "Quel'ana Prestovendaval", esMX = "Quel'ana Ventarrápido", ptBR = "Quel'ana Ventiágil", ruRU = "Кве'лана Быстрый Порыв" },
	[254411] = { deDE = "Quel'dora Quickgale", frFR = "Quel'dora Vent-Vif", esES = "Quel'dora Prestovendaval", esMX = "Quel'dora Ventarrápido", ptBR = "Quel'dora Ventiágil", ruRU = "Кель'дора Стремительный Шторм" },
	[4205] = { deDE = "Dorion", frFR = "Dorion", esES = "Dorion", esMX = "Dorion", ptBR = "Dorion", ruRU = "Дорион" },
	[5116] = { deDE = "Olmin Burningbeard", frFR = "Olmin Burningbeard", esES = "Olmin Barbanllamas", esMX = "Olmin Barbardiente", ptBR = "Olmin Barbardente", ruRU = "Олмин Пламебород" },
	[5516] = { deDE = "Ulfir Ironbeard", frFR = "Ulfir Ironbeard", esES = "Ulfir Barbaférrea", esMX = "Ulfir Barbaférrea", ptBR = "Ulfir Barbaférrea", ruRU = "Ульфир Железнобород" },
	[8405] = { deDE = "Ogtinc", frFR = "Ogtinc", esES = "Ogtinc", ptBR = "Ogtinc", ruRU = "Огтинк" },
	-- Rogue (17 Nov 2026, mh-research: Spoken name files; 13283, 3328, 2425 from Wowhead Forever tooltips per locale;
	-- control npc 233). A name equal to English = Spoken's rule "missing = not translated" (12 spot checks on Wowhead).
	-- Veenix (4086) and the Dead Drop: not measured, English shows.
	[917] = { deDE = "Keryn Sylvius", frFR = "Keryn Sylvius", esES = "Keryn Sylvius", esMX = "Keryn Sylvius", ptBR = "Anabela Cabreira", ruRU = "Керин Сильвиус" },
	[332] = { deDE = "Meister Mathias Shaw", frFR = "Maître Mathias Shaw", esES = "Maestro Mathias Shaw", esMX = "Maestro Mathias Shaw", ptBR = "Mestre Mathias Shaw", ruRU = "Мастер Матиас Шоу" },
	[1234] = { deDE = "Hogral Bakkan", frFR = "Hogral Bakkan", esES = "Hogral Bakkan", esMX = "Hogral Bakkan", ptBR = "Hogral Bakkan", ruRU = "Хограл Баккан" },
	[5165] = { deDE = "Hulfdan Blackbeard", frFR = "Hulfdan Blackbeard", esES = "Hulfdan Barbanegra", esMX = "Hulfdan Barbanegra", ptBR = "Hulfdan Barbanegra", ruRU = "Хальфдан Чернобород" },
	[6886] = { deDE = "Onin MacHammar", frFR = "Onin MacHammar", esES = "Onin MacHammar", esMX = "Onin MacHammar", ptBR = "Onin MacHammar", ruRU = "Онин МакМолот" },
	[3599] = { deDE = "Jannok Breezesong", frFR = "Jannok Breezesong", esES = "Jannok Brisón", esMX = "Jannok Brisón", ptBR = "Jannok Brisacanto", ruRU = "Джаннок Поющий Ветерок" },
	[4163] = { deDE = "Syurna", frFR = "Syurna", esES = "Syurna", esMX = "Syurna", ptBR = "Syurna", ruRU = "Сиарна" },
	[6946] = { deDE = "Renzik \"Das Messer\"", frFR = "Renzik \"le kriss\"", esES = "Renzik \"Cuchillo\"", esMX = "Renzik \"Chafarote\"", ptBR = "Renzik, \"O Bicudo\"", ruRU = "Рензик Нож" },
	[6966] = { deDE = "Lucius", frFR = "Lucius", esES = "Lucius", esMX = "Lucius", ptBR = "Lucius", ruRU = "Люций" },
	[7024] = { deDE = "Agentin Kearnen", frFR = "Agent Kearnen", esES = "Agente Kearnen", esMX = "Agente Kearnen", ptBR = "Agente Marta Hari", ruRU = "Посланница Кеарнен" },
	[13283] = { deDE = "Lord Tony Romano", frFR = "Seigneur Tony Romano", esES = "Lord Tony Romano", esMX = "Lord Tony Romano", ptBR = "Lorde Tony Romano", ruRU = "Лорд Тони Романо" },
	[3170] = { deDE = "Kaplak", frFR = "Kaplak", esES = "Kaplak", esMX = "Kaplak", ptBR = "Kaplak", ruRU = "Каплак" },
	[6446] = { deDE = "Therzok", frFR = "Therzok", esES = "Therzok", esMX = "Therzok", ptBR = "Therzok", ruRU = "Терзок" },
	[2130] = { deDE = "Marion Call", frFR = "Marion Call", esES = "Marion Call", esMX = "Marion Call", ptBR = "Marion Calder", ruRU = "Марион Зов" },
	[6467] = { deDE = "Mennet Carkad", frFR = "Mennet Carkad", esES = "Mennet Carkad", esMX = "Mennet Carkad", ptBR = "Júnio Aquino", ruRU = "Меннит Каркад" },
	[6522] = { deDE = "Andron Gant", frFR = "Andron Gant", esES = "Andron Gant", esMX = "Andron Gant", ptBR = "Andron Gante", ruRU = "Андрон Гант" },
	[2425] = { deDE = "Varimathras", frFR = "Varimathras", esES = "Varimathras", esMX = "Varimathras", ptBR = "Varimatras", ruRU = "Вариматрас" },
	[3401] = { deDE = "Shenthul", frFR = "Shenthul", esES = "Shenthul", esMX = "Shenthul", ptBR = "Shenthul", ruRU = "Шентул" },
	[3402] = { deDE = "Zando'zan", frFR = "Zando'zan", esES = "Zando'zan", esMX = "Zando'zan", ptBR = "Zando'zan", ruRU = "Зандо'зан" },
	[7161] = { deDE = "Wrenix der Jämmerliche", frFR = "Wrenix le Misérable", esES = "Desdio el Desdichado", esMX = "Desdio el Desdichado", ptBR = "Wrenix, o Ignóbil", ruRU = "Реникс Презренный" },
	[7233] = { deDE = "Zuchtmeister Fizzule", frFR = "Sous-chef Fizzule", esES = "Capataz Burbujita", esMX = "Capataz Fizzule", ptBR = "Capataz Arruela", ruRU = "Надсмотрщик Физзул" },
	[2391] = { deDE = "Serge Hinott", frFR = "Serge Hinott", esES = "Serge Hinott", esMX = "Serge Hinott", ptBR = "Serguei Hinoto", ruRU = "Серж Хинотт" },
	[3328] = { deDE = "Ormok", frFR = "Ormok", esES = "Ormok", esMX = "Ormok", ptBR = "Ormok", ruRU = "Ормок" },
	[6768] = { deDE = "Lord Jorach Ravenholdt", frFR = "Seigneur Jorach Ravenholdt", esES = "Lord Jorach Ravenholdt", esMX = "Lord Jorach Ravenholdt", ptBR = "Lorde Jorach Corvoforte", ruRU = "Лорд Джорах Черный Ворон" },
	[8379] = { deDE = "Erzmagier Xylem", frFR = "Archimage Xylem", esES = "Archimago Xylem", esMX = "Archimago Xylem", ptBR = "Arquimago Tauriel", ruRU = "Верховный маг Ксилем" },
}

local function NpcName(p)
	if not (p and p.npc) then
		return "?"
	end
	local loc = GetLocale and GetLocale()
	local row = p.id and NPC_NAMES[p.id]
	return (row and loc and row[loc]) or p.npc
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and n then
			return n
		end
	end
	return "#" .. tostring(id)
end

--- The race token, with the two Skyborne races folded into "Skyborne": ChrRaces 95 High Order (Alliance) and 96
--- Windshaper (Horde) both have ClientFileString "Skyborne" (GEMETEN DB2 70938); that UnitRace returns it = AFGELEID,
--- so the race id counts too.
local function RaceToken()
	if not UnitRace then
		return nil
	end
	local _, race, id = UnitRace("player")
	if id == 95 or id == 96 then
		return "Skyborne"
	end
	return race
end

--- The chains for this character (class + faction + race where a chain names races).
local function MyChains()
	local token = select(2, UnitClass("player"))
	local faction = UnitFactionGroup and UnitFactionGroup("player")
	local race = RaceToken()
	local out, pos = {}, {}
	for _, c in ipairs(CHAINS[token] or {}) do
		if c.faction == faction and (not c.races or (race and c.races[race])) then
			out[#out + 1] = c
			pos[c] = #out
		end
	end
	-- Lowest level first, so "Do this now" names the oldest open chain (the table order is not the level order). Same
	-- level: the table order (17 Nov 2026: warrior Berserker before Whirlwind; table.sort alone is not stable).
	table.sort(out, function(a, b)
		if a.level ~= b.level then
			return a.level < b.level
		end
		return pos[a] < pos[b]
	end)
	return out
end

--- Can this chain start now? Level reached, and its `needs` quest done (a chain that only opens after another one,
--- e.g. the warrior Whirlwind weapon after The Affray 1719).
local function Ready(c, level)
	return level >= c.level and (not c.needs or Done(c.needs))
end

--- Where you are in a chain: step = { kind = "get"/"do"/"turn", place (may be nil), textKey, q }, or nil + why.
local function Step(c)
	if c.spell and Known(c.spell) then
		return nil, "spell known"
	end
	local last = 0
	for i, e in ipairs(c.quests) do
		if AnyDone(e) or LogQuest(e) then
			last = i
		end
	end
	local i = math.max(1, last)
	while c.quests[i] and AnyDone(c.quests[i]) do
		i = i + 1
	end
	local e = c.quests[i]
	if not e then
		return nil, "all quests done"
	end
	local q = LogQuest(e)
	if not q then
		-- e.wait: a quest that is only offered later (rogue: after a letter from C), so "get the quest" would send the
		-- player to a place where nothing is yet. The text says to wait (17 Nov 2026).
		if e.wait then
			return { kind = "wait", place = e.from, textKey = e.wait, q = e.q }
		end
		return { kind = "get", place = e.from, q = e.q }
	end
	if e.objs and not ObjDone(q) then
		for _, o in ipairs(e.objs) do
			if not ObjFinished(q, o) then
				return { kind = "do", place = o.place, textKey = o.textKey, q = q }
			end
		end
	end
	return { kind = "turn", place = e.to, q = q }
end

local function ChainName(c)
	if c.nameKey then
		return ns:L(c.nameKey)
	end
	return SpellName(c.spell)
end

local function Where(p)
	local s = ("%s (%.1f, %.1f)"):format(ZoneName(p.m), p.x, p.y)
	-- Moonglade is far for everyone; the druid's own teleport goes there (level 10, GEMETEN SpellLevels 70938).
	if p.m == MOONGLADE and Known(TELEPORT_MOONGLADE) then
		s = s .. ns:L("FCQ_MOONGLADE_TIP")
	end
	return s
end

--- What to do now, without the chain name ("get the quest from …").
local function StepWhat(s)
	local p = s.place
	if s.kind == "get" then
		return ns:L("FCQ_GET_FMT"):format(NpcName(p), Where(p))
	elseif s.kind == "do" or s.kind == "wait" then
		return ns:L(s.textKey) .. (p and (" — " .. Where(p)) or "")
	end
	return ns:L("FCQ_TURN_FMT"):format(NpcName(p), Where(p))
end

local function StepText(c, s)
	return ns:L("FCQ_LINE_FMT"):format(ChainName(c), c.level, StepWhat(s))
end

--- For "Do this now": the line for the first chain you can do now, and its step (for the arrow).
function ns.ForeverClassQuestNow()
	local level = UnitLevel and UnitLevel("player") or 1
	for _, c in ipairs(MyChains()) do
		if Ready(c, level) then
			local s = Step(c)
			if s then
				return StepText(c, s), s
			end
		end
	end
	return nil
end

--- The arrow to the current step.
function ns.ForeverClassQuestGo()
	local _, s = ns.ForeverClassQuestNow()
	if not s then
		print(PREFIX .. ns:L("FCQ_NOTHING"))
		return false
	end
	local p = s.place
	if not p then
		-- Something to collect anywhere (Earthroot): no spot to point at, the line says what to do.
		print(PREFIX .. (ns.ForeverClassQuestNow()))
		return false
	end
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(p.m, p.x, p.y)) then
		print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		return false
	end
	ns.lastTarget = { mapID = p.m, x = p.x, y = p.y, name = p.npc and NpcName(p) or ZoneName(p.m), via = "/mh classquest", arriveYards = 15 }
	ns._mhRouteOwner = "waypoint"
	print(PREFIX .. (ns.ForeverClassQuestNow()))
	return true
end

--- /mh classquest [go]: per chain and quest what the client says, and the step MH picks (silence rule).
function ns.ForeverClassQuestSlash(arg)
	if (arg or ""):lower() == "go" then
		ns.ForeverClassQuestGo()
		return
	end
	local chains = MyChains()
	print(PREFIX .. ("class quests: %d chain(s) for your class and faction; level %s"):format(#chains,
		tostring(UnitLevel and UnitLevel("player"))))
	for _, c in ipairs(chains) do
		local s, why = Step(c)
		print(("  %s (level %d, spell %s known: %s): %s"):format(ChainName(c), c.level, tostring(c.spell),
			c.spell and tostring(Known(c.spell)) or "-", s and (s.kind .. " quest " .. s.q) or why))
		for _, e in ipairs(c.quests) do
			local q = LogQuest(e) or e.q
			local objs = {}
			for n, o in ipairs(e.objs or {}) do
				objs[#objs + 1] = ("%d=%s"):format(n, tostring(ObjFinished(q, o)))
			end
			print(("    quest %d%s: done %s, in log %s, complete %s%s"):format(q, e.alt and " (or alt)" or "",
				tostring(AnyDone(e)), tostring(LogQuest(e) ~= nil), tostring(ObjDone(q)),
				#objs > 0 and (", steps " .. table.concat(objs, " ")) or ""))
		end
	end
	local line = ns.ForeverClassQuestNow()
	print("  line in Do this now: " .. (line or "none"))
end

--- For "How you play": every class quest of this character, with where it stands. nil when the class has none.
function ns.ForeverClassQuestOverview()
	local chains = MyChains()
	if #chains == 0 then
		return nil
	end
	local level = UnitLevel and UnitLevel("player") or 1
	local lines = { ns:L("FCQ_HOWTO_INTRO") }
	for _, c in ipairs(chains) do
		local s = Step(c)
		local state
		if not s then
			state = ns:L("FCQ_ST_DONE")
		elseif not Ready(c, level) then
			local first = c.quests[1].from
			state = ns:L("FCQ_ST_LATER_FMT"):format(NpcName(first), ZoneName(first.m))
		else
			state = ns:L("FCQ_ST_NOW_FMT"):format(StepWhat(s))
		end
		lines[#lines + 1] = ("- **%d: %s**. %s"):format(c.level, ChainName(c), state)
	end
	lines[#lines + 1] = ns:L("FCQ_HOWTO_BTN")
	return table.concat(lines, "\n")
end
