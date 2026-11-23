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
	Rob measured > HandyNotes > Zygor > guide; HandyNotes: Class Trainers is only read live), not yet seen in game. Map ids GEMETEN in wago UiMap 1.60.1.70938.
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
	denatharion = { npc = "Denatharion", id = 4218, m = 1457, x = 34.77, y = 7.36, z = true },
	mathrengyl = { npc = "Mathrengyl Bearwalker", id = 4217, m = 1457, x = 35.38, y = 8.41, z = true },
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
local function O(place, textKey, idx, items, count)
	return { place = place, textKey = textKey, idx = idx, items = items, count = count }
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
	No Skyborne warlock (DB2 CharBaseInfo). CORRECTED 17 Nov 2026 (Fable check, Sparring 17-11): Inferno 1122 IS a quest
	reward (7603, built below as WlInferno) and Ritual of Doom 18540 too (7583 "Suppression", after 7581/7582, Daio the
	Decrepit: NOT built yet, givers and places not measured). Not built: An Imp's Request (8419-8422). Coordinates: Zygor (trainers too, since 22 Nov 2026),
	else Wowhead/Questie pins; Stormwind uses the 39.x set (the 25.x Wowhead set is another map space). ]]
local WL_P = {
	drusilla = { npc = "Drusilla La Salle", id = 459, m = 1429, x = 49.87, y = 42.65, z = true },
	alamar = { npc = "Alamar Grimm", id = 460, m = 1426, x = 28.59, y = 66.23, z = true },
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
	demisette = { npc = "Demisette Cloyce", id = 461, m = 1453, x = 39.24, y = 84.96, z = true },
	briarthorn = { npc = "Briarthorn", id = 5172, m = 1455, x = 50.35, y = 5.66, z = true },
	zevrost = { npc = "Zevrost", id = 3326, m = 1454, x = 48.46, y = 45.40, z = true },
	kaal = { npc = "Kaal Soulreaper", id = 4563, m = 1458, x = 86.21, y = 15.93, z = true },
	spackle = { npc = "Spackle Thornberry", id = 5520, m = 1453, x = 39.53, y = 84.53, z = true },
	jubahl = { npc = "Jubahl Corpseseeker", id = 6382, m = 1455, x = 52.69, y = 6.07, z = true },
	kurgul = { npc = "Kurgul", id = 5815, m = 1454, x = 47.52, y = 46.72, z = true },
	martha = { npc = "Martha Strain", id = 5753, m = 1458, x = 85.70, y = 16.08, z = true },
	morzul = { npc = "Mor'zul Bloodbringer", id = 14436, m = 1428, x = 12.69, y = 31.64 },
	gorzeeki = { npc = "Gorzeeki Wildeyes", id = 14437, m = 1428, x = 12.43, y = 31.63 },
	banehollow = { npc = "Lord Banehollow", id = 9516, m = 1448, x = 35.93, y = 44.41 },
	-- npc + id (Fable check, 18 Nov 2026): without a name the gold line said "you pay it at Felwood". GEMETEN WH-F 14522.
	urdan = { npc = "Ur'dan", id = 14522, m = 1448, x = 36.17, y = 44.46 },
	-- Inferno chain (facts file §7a/§8, Zygor A).
	niby = { npc = "Niby the Almighty", id = 14469, m = 1448, x = 41.38, y = 44.86 },
	impsy = { npc = "Impsy", id = 14470, m = 1448, x = 41.36, y = 45.02 },
	essAzshara = { m = 1447, x = 52.03, y = 18.65 },
	essJaedenar = { m = 1448, x = 36.25, y = 55.94 },
	essBlasted = { m = 1419, x = 61.32, y = 54.18 },
	kroshius = { m = 1448, x = 45.73, y = 34.81 },
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
-- Warlock 20/30/40 (succubus, incubus, felhunter, felsteed): the Wowhead Forever record lists only Orc + Undead for
-- 1507-1513, 2996/3001/1801 and 3631/4489 (Fable check 17 Nov 2026); guides say trolls walk Orgrimmar. Not proven
-- either way, so a troll is NOT sent there (silence beats a wrong trip). Bouwchat choice, Rob may reverse; TESTLIJST.
local WL_ORC = { Orc = true }
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

-- Dreadsteed (60): 7562 from the race's demon trainer. Quests run side by side (Mor'zul gives 7626, 7627, 7628 at once;
-- 7623 can be taken early), so the chain is strict: the first quest in your log comes first, otherwise the first one
-- whose `needs` are done. The needs are AFGELEID from the Questie Forever data + warcraft.wiki (Classic data): 7630 after
-- 7626-7628, 7629 after 7625, 7631 after 7629 and 7630 (Fable check, Sparring 17-11).
local function WlDreadsteed(faction, races, starter)
	return {
		key = "dreadsteed", spell = 23161, level = 60, faction = faction, races = races, strict = true,
		quests = {
			{ q = 7562, from = starter, to = W.morzul },
			{ q = 7563, needs = { 7562 }, from = W.morzul, objs = { O(W.owlbeasts, "FCQ_OBJ_WL_BEASTBLOOD", 1) }, to = W.morzul },
			{ q = 7564, needs = { 7563 }, from = W.morzul, to = W.gorzeeki },
			{ q = 7626, needs = { 7564 }, from = W.morzul, objs = { O(nil, "FCQ_OBJ_WL_ELIXIR", 1) }, to = W.gorzeeki },
			{ q = 7627, needs = { 7564 }, from = W.morzul, objs = { O(nil, "FCQ_OBJ_WL_SHARDS", 1), O(nil, "FCQ_OBJ_WL_IRONORE", 2) },
				to = W.gorzeeki },
			{ q = 7628, needs = { 7564 }, from = W.morzul, objs = { O(nil, "FCQ_OBJ_WL_DRAGONSCALE", 1) }, to = W.gorzeeki },
			{ q = 7630, needs = { 7626, 7627, 7628 }, from = W.gorzeeki, objs = { O(nil, "FCQ_OBJ_WL_ARCANITE", 1) }, to = W.gorzeeki },
			-- 7623: "Purchase Shadowy Potions from Gorzeeki … to travel through Jaedenar" (Wowhead Forever, GEMETEN); item
			-- 18802, DB2 BuyPrice 6 gold with VendorStackCount 3 (= 6 gold for 3, AFGELEID; warcraft.wiki "Buys 3").
			-- How many: NOT measured. Only said in the Burning Steppes (onlyMap), where you can buy them: elsewhere an empty
			-- bag may mean used up. The 150 gold for 7625's Stardust goes along from here too (second check, 18 Nov: 7625 is
			-- handed out next to Ur'dan, so a check there comes when the trip is already made).
			{ q = 7623, needs = { 7564 }, from = W.gorzeeki, to = W.banehollow,
				pre = { { items = { 18802 }, place = W.gorzeeki, textKey = "FCQ_PRE_WL_POTION", onlyMap = 1428 },
					{ gold = 1500000, unlessItem = 18687, at = W.urdan } } },
			{ q = 7624, needs = { 7623 }, from = W.banehollow, objs = { O(W.ulathek, "FCQ_OBJ_WL_ULATHEK", 1) }, to = W.banehollow,
				pre = { { gold = 1500000, unlessItem = 18687, at = W.urdan } } },
			-- 7625: Xorothian Stardust 18687, DB2 BuyPrice 150 gold (that Ur'dan asks exactly that = AFGELEID).
			{ q = 7625, needs = { 7624 }, from = W.banehollow, objs = { O(W.urdan, "FCQ_OBJ_WL_STARDUST", 1) }, to = W.gorzeeki,
				pre = { { gold = 1500000, unlessItem = 18687, at = W.urdan } } },
			{ q = 7629, needs = { 7625 }, from = W.gorzeeki, objs = { O(nil, "FCQ_OBJ_WL_IMPJAR", 1) }, to = W.gorzeeki },
			-- Objective 1 = defeat the Xorothian Dreadsteed (14502): AFGELEID (the tooltip shows no objective).
			-- 7631: the ritual needs J'eevee's Jar 18663, Black Lodestone 18629 and Xorothian Glyphs 18670 from Gorzeeki
			-- (DB2 BuyPrice 150 + 50 + 50 gold, GEMETEN; second check 18 Nov 2026). All three; only said in the Burning Steppes.
			{ q = 7631, needs = { 7629, 7630 }, from = W.morzul, objs = { O(W.dreadsteedSpirit, "FCQ_OBJ_WL_RITUAL", 1) },
				to = W.dreadsteedSpirit,
				pre = { { allItems = { 18663, 18629, 18670 }, place = W.gorzeeki, textKey = "FCQ_PRE_WL_RITUAL", onlyMap = 1428 } } },
		},
	}
end

-- Inferno 1122 (50): reward of 7603 Kroshius' Infernal Core (Wowhead Forever 7603, Fable check 17 Nov 2026). Chain
-- 7601 → 7602 → 7603 from Niby and Impsy in Felwood (facts file §7a, Zygor A 24083-24190). The quest also gives the
-- Shard of the Green Flame. Same for both factions.
local function WlInferno(faction)
	return {
		key = "inferno", spell = 1122, level = 50, faction = faction,
		quests = {
			{ q = 7601, from = W.niby, to = W.impsy },
			{ q = 7602, from = W.impsy, objs = {
				O(W.essAzshara, "FCQ_OBJ_WL_ESS_AZSHARA", 1),
				O(W.essJaedenar, "FCQ_OBJ_WL_ESS_JAEDENAR", 2),
				O(W.essBlasted, "FCQ_OBJ_WL_ESS_PORTAL", 3),
			}, to = W.impsy },
			{ q = 7603, from = W.impsy, objs = { O(W.kroshius, "FCQ_OBJ_WL_KROSHIUS", 1) }, to = W.niby },
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
	{ key = "succubus", spell = 712, level = 20, faction = "Horde", races = WL_ORC, quests = {
		{ q = 1507, from = W.ganrul, to = W.cazul },
		{ q = 1508, from = W.cazul, to = W.zankaja },
		{ q = 1509, from = W.zankaja, to = W.gazrog },
		{ q = 1510, from = W.gazrog, to = W.kenzigla },
		{ q = 1511, from = W.kenzigla, to = W.logmar },
		{ q = 1515, from = W.logmar, to = W.dogran },
		{ q = 1512, from = W.dogran, to = W.ganrul },
		{ q = 1513, from = W.ganrul, objs = { O(W.circleOrg, "FCQ_OBJ_WL_BIND_SUCC", 1) }, to = W.ganrul } } },
	{ key = "incubus", spell = 713, level = 20, faction = "Horde", races = WL_ORC, quests = {
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
	WlFelhunter("Horde", WL_ORC, { q = 2996, alt = { 3001 }, from = W.ganrul, to = W.strahad }, W.jorah, { 1801, 1803 }, 1805),
	WlFelhunter("Horde", UD, { q = 3001, alt = { 2996 }, from = W.carendin, to = W.strahad }, W.jorah, { 1801, 1803 }, 1805),
	-- Felsteed (40): one starter per race (they exclude each other), then 4490 at Strahad. In Forever the Felsteed is also
	-- a collection mount: whether the spell check sees it = NOT measured; the chain also ends once 4490 is done.
	WlFelsteed("Alliance", HUM, 4488, { 4487 }, W.demisette),
	WlFelsteed("Alliance", GNO, 4487, { 4488 }, W.briarthorn),
	WlFelsteed("Horde", WL_ORC, 3631, { 4489 }, W.zevrost),
	WlFelsteed("Horde", UD, 4489, { 3631 }, W.kaal),
	-- Inferno (50)
	WlInferno("Alliance"),
	WlInferno("Horde"),
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
	lyria = { npc = "Lyria Du Lac", id = 913, m = 1429, x = 41.08, y = 65.77, z = true },
	harry = { npc = "Harry Burlguard", id = 6089, m = 1453, x = 77.13, y = 53.27 },
	bartleby = { npc = "Bartleby", id = 6090, m = 1453, x = 76.80, y = 53.20 },
	granis = { npc = "Granis Swiftaxe", id = 1229, m = 1426, x = 47.36, y = 52.65, z = true },
	muren = { npc = "Muren Stormpike", id = 6114, m = 1455, x = 70.78, y = 90.27 },
	kyra = { npc = "Kyra Windblade", id = 3598, m = 1438, x = 56.22, y = 59.20, z = true },
	elanaria = { npc = "Elanaria", id = 4088, m = 1457, x = 57.29, y = 34.61 },
	tarshaw = { npc = "Tarshaw Jaggedscar", id = 3169, m = 1411, x = 54.19, y = 42.47, z = true },
	krang = { npc = "Krang Stonehoof", id = 3063, m = 1412, x = 48.35, y = 63.74, z = true },
	uzzek = { npc = "Uzzek", id = 5810, m = 1413, x = 61.38, y = 21.11 },
	austil = { npc = "Austil de Mon", id = 2131, m = 1420, x = 61.86, y = 52.54, z = true },
	dillinger = { npc = "Deathguard Dillinger", id = 1496, m = 1420, x = 58.20, y = 51.45 },
	seena = { npc = "Seena Skybreaker", id = 252377, m = 2521, x = 59.89, y = 72.86, z = true },
	wushen = { npc = "Wu Shen", id = 5479, m = 1453, x = 80.50, y = 59.86, z = true },
	sorek = { npc = "Sorek", id = 3354, m = 1454, x = 80.39, y = 32.38, z = true },
	klannoc = { npc = "Klannoc Macleod", id = 6236, m = 1413, x = 68.62, y = 49.17 },
	bathrah = { npc = "Bath'rah the Windwatcher", id = 6176, m = 1416, x = 80.50, y = 66.92 },
	fallenHero = { npc = "Fallen Hero of the Horde", id = 7572, m = 1435, x = 34.29, y = 66.15 },
	-- Objective places (no NPC), Zygor.
	vejrek = { m = 1426, x = 27.83, y = 57.95 },
	vorlus = { m = 1438, x = 47.26, y = 63.52 },
	lizards = { m = 1411, x = 39.27, y = 28.29 },
	-- The Mausoleum Trigger (skull stone, object 104593/706178, Wowhead Forever; Fable check 17 Nov). Zygor said "Doors".
	ulag = { m = 1420, x = 59.2, y = 48.6 },
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
				-- 8 of each charm (Wowhead Forever 1714), or the Essence of the Exile 6851 once the cauldron made it.
				O(R.charmBurning, "FCQ_OBJ_WR_CHARM_BURNING", nil, { 4479, 6851 }, 8),
				O(R.charmThundering, "FCQ_OBJ_WR_CHARM_THUNDERING", nil, { 4480, 6851 }, 8),
				O(R.charmCresting, "FCQ_OBJ_WR_CHARM_CRESTING", nil, { 4481, 6851 }, 8),
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
	Zygor mistakes not copied: |q 8425 in the Horde hunter guide (= 8232), "Vartus". Trainers and the rest: Zygor (22 Nov 2026). ]]
local HU_P = {
	dazalar = { npc = "Dazalar", id = 3601, m = 1438, x = 56.68, y = 59.49, z = true },
	jocaste = { npc = "Jocaste", id = 4146, m = 1457, x = 40.38, y = 8.55, z = true },
	grif = { npc = "Grif Wildheart", id = 1231, m = 1426, x = 45.81, y = 53.04, z = true },
	belia = { npc = "Belia Thundergranite", id = 10090, m = 1455, x = 70.86, y = 85.83, z = true },
	josephine = { npc = "Josephine Carson", id = 251507, m = 1429, x = 41.15, y = 66.23, z = true },
	isaac = { npc = "Isaac Chan", id = 258930, m = 1429, x = 41.79, y = 66.37, z = true },
	thotar = { npc = "Thotar", id = 3171, m = 1411, x = 51.85, y = 43.49, z = true },
	ormak = { npc = "Ormak Grimshot", id = 3352, m = 1454, x = 66.06, y = 18.54, z = true },
	yaw = { npc = "Yaw Sharpmane", id = 3065, m = 1412, x = 46.93, y = 59.65, z = true },
	holt = { npc = "Holt Thunderhorn", id = 3039, m = 1456, x = 57.31, y = 89.76, z = true },
	quelana = { npc = "Quel'ana Quickgale", id = 252389, m = 2521, x = 59.57, y = 72.64, z = true },
	queldora = { npc = "Quel'dora Quickgale", id = 254411, m = 2521, x = 59.60, y = 72.53, z = true },
	dorion = { npc = "Dorion", id = 4205, m = 1457, x = 42.21, y = 7.26, z = true },
	olmin = { npc = "Olmin Burningbeard", id = 5116, m = 1455, x = 70.88, y = 83.61, z = true },
	ulfir = { npc = "Ulfir Ironbeard", id = 5516, m = 1453, x = 67.59, y = 35.75, z = true },
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
	level 23/30 for the two Dead Drop chains; what 8236 pays in Forever is NOT measured.
	CORRECTED 23 Nov 2026 (Rob via sparring: "Ja, 1, 2 en 3" = weetjes A; docs/forever/POLESTAR_NAKIJK_2026-11-22.md):
	the Eye waits for 78307 (R12, AllTheThings + MailTemplate 614), and both chains start after a letter from C (78261:
	MailTemplate 612, R11; 78676: at 30 in a capital city, R14), so their first step says to wait for it too.
	Not built (bouwchat choice, Rob may reverse): the Touch of Zanzil cure (a player who cures it another way would keep
	the line forever), the level 16 race pointers, Ravenholdt reputation quests.
	Zygor mistakes not copied: Varimathras 59.75,84.64, the 1978 pickup at 65.53,79.73, |q 8232 / 8425 (= 8236). ]]
local RO_P = {
	keryn = { npc = "Keryn Sylvius", id = 917, m = 1429, x = 43.87, y = 65.94, z = true },
	shaw = { npc = "Master Mathias Shaw", id = 332, m = 1453, x = 78.31, y = 70.75 },
	hogral = { npc = "Hogral Bakkan", id = 1234, m = 1426, x = 47.56, y = 52.61, z = true },
	hulfdan = { npc = "Hulfdan Blackbeard", id = 5165, m = 1455, x = 51.94, y = 14.82, z = true },
	onin = { npc = "Onin MacHammar", id = 6886, m = 1426, x = 25.16, y = 44.45 },
	jannok = { npc = "Jannok Breezesong", id = 3599, m = 1438, x = 56.38, y = 60.14, z = true },
	syurna = { npc = "Syurna", id = 4163, m = 1457, x = 36.99, y = 21.91, z = true },
	renzik = { npc = "Renzik \"The Shiv\"", id = 6946, m = 1453, x = 78.25, y = 71.13 },
	lucius = { npc = "Lucius", id = 6966, m = 1433, x = 22.97, y = 52.04 },
	kearnen = { npc = "Agent Kearnen", id = 7024, m = 1436, x = 68.49, y = 70.08 },
	romano = { npc = "Lord Tony Romano", id = 13283, m = 1453, x = 80.28, y = 68.57, z = true },
	kaplak = { npc = "Kaplak", id = 3170, m = 1411, x = 51.98, y = 43.69, z = true },
	therzok = { npc = "Therzok", id = 6446, m = 1454, x = 42.74, y = 53.54 },
	marion = { npc = "Marion Call", id = 2130, m = 1420, x = 61.75, y = 52.00, z = true },
	mennet = { npc = "Mennet Carkad", id = 6467, m = 1458, x = 83.51, y = 69.11 },
	andron = { npc = "Andron Gant", id = 6522, m = 1458, x = 54.82, y = 76.30 },
	varimathras = { npc = "Varimathras", id = 2425, m = 1458, x = 56.24, y = 92.22 },
	shenthul = { npc = "Shenthul", id = 3401, m = 1454, x = 43.05, y = 53.74, z = true },
	zandozan = { npc = "Zando'zan", id = 3402, m = 1454, x = 42.73, y = 52.95 },
	wrenix = { npc = "Wrenix the Wretched", id = 7161, m = 1413, x = 63.07, y = 36.32 },
	fizzule = { npc = "Taskmaster Fizzule", id = 7233, m = 1413, x = 55.44, y = 5.56 },
	hinott = { npc = "Serge Hinott", id = 2391, m = 1424, x = 61.63, y = 19.19 },
	ormok = { npc = "Ormok", id = 3328, m = 1454, x = 43.90, y = 54.63, z = true },
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
		{ q = 78261, from = RO.deadDrop, wait = "FCQ_WAIT_RO_INVITE", objs = {
			O(RO.veenix, "FCQ_OBJ_RO_VEENIX", 2),
			O(RO.sfk, "FCQ_OBJ_RO_HORN", 1),
		}, to = RO.deadDrop },
		{ q = 78307, from = RO.deadDrop, wait = "FCQ_WAIT_RO_LETTER", to = RO.deadDrop },
	} })
	table.insert(CHAINS.ROGUE, { key = "bhossca", nameKey = "FCQ_CHAIN_RO_BHOSSCA", level = 30, needs = 78307,
		faction = faction, quests = {
			{ q = 78676, from = RO.deadDrop, wait = "FCQ_WAIT_RO_EYE", objs = { O(RO.sm, "FCQ_OBJ_RO_EYE", 1) }, to = RO.deadDrop },
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

--[[ Shaman (17 Nov 2026, Bouwchat 17-11; researched by mh-research on Opus, Fable check by Sparring 17-11 follows).
	All facts: docs/forever/SHAMAN_CLASSQUESTS_2026-11-17.md: Zygor Forever "Shaman Class Quests" (Horde) + Alliance/Common
	leveling, Spoken (givers/enders per NPC/object), wago DB2 1.60.1.70938 (CharBaseInfo: Orc, Tauren, Troll, Dwarf,
	Windshaper Skyborne 96; no High Order 95), Wowhead Forever (rewards: 8071/3599/5394 + Earth/Fire/Water Totem, Air
	Totem item only), HandyNotes. NEW in Forever: the Dwarf shaman chains (94373-94375, 94449-94468, 94494-94505, 94789,
	98581/96243) and the Windshaper chains (92466-92484, 97243-97257).
	AFGELEID: objective order = client index; 96243 as alt of 98581; the Windshaper walks the Horde water/air route; no
	Alliance Elemental Mastery; the three Alliance waterskin places come from a guide only (gitm.gg, 15 Nov).
	The sapta steps have no objective: their step waits until the client says the quest is complete (like warrior 1719).
	Not copied from Zygor: 8425 in the shaman Sunken Temple step (= 8413). Not built: The Tempest's Weapons (30-40, places
	unknown), the breadcrumb 98517, the "lost your sapta" replacement quests. ]]
local SH_P = {
	-- Earth: Orc/Troll (Durotar), Tauren (Mulgore), Dwarf (Dun Morogh), Windshaper (Zephras Isle)
	canaga = { npc = "Canaga Earthcaller", id = 5887, m = 1411, x = 42.41, y = 69.17 },
	earthDurotar = { npc = "Minor Manifestation of Earth", id = 5891, m = 1411, x = 44.03, y = 76.20 },
	ravenfeather = { npc = "Seer Ravenfeather", id = 5888, m = 1412, x = 44.35, y = 76.76 },
	earthMulgore = { npc = "Minor Manifestation of Earth", id = 5891, m = 1412, x = 51.97, y = 80.41 },
	sten = { npc = "Sten Stoutarm", id = 658, m = 1426, x = 29.93, y = 71.20 },
	teo = { npc = "Teo Hammerstorm", id = 257446, m = 1426, x = 28.79, y = 66.19, z = true },
	earthDunMorogh = { npc = "Minor Manifestation of Earth", id = 5891, m = 1426, x = 24.89, y = 61.86 },
	rorian = { npc = "Rorian the Dayseeker", id = 251361, m = 2521, x = 42.06, y = 23.48 },
	boro = { npc = "Windshaper Boro", id = 251374, m = 2521, x = 42.79, y = 23.57, z = true },
	earthZephras = { npc = "Minor Manifestation of Earth", id = 251166, m = 2521, x = 49.67, y = 23.83 },
	-- Fire
	swart = { npc = "Swart", id = 3173, m = 1411, x = 54.42, y = 42.59, z = true },
	narm = { npc = "Narm Skychaser", id = 3066, m = 1412, x = 47.40, y = 62.55, z = true },
	kranal = { npc = "Kranal Fiss", id = 5907, m = 1413, x = 56.03, y = 19.89 },
	telf = { npc = "Telf Joolam", id = 5900, m = 1411, x = 38.55, y = 58.96 },
	brazierDurotar = { npc = "Brazier of the Dormant Flame", obj = 61934, m = 1411, x = 38.95, y = 58.22 },
	ingrid = { npc = "Ingrid Dunwald", id = 258113, m = 1426, x = 47.59, y = 51.95, z = true },
	bruegs = { npc = "Bruegs Kindleborn", id = 257597, m = 1426, x = 87.56, y = 43.65 },
	braldir = { npc = "Braldir Ashmantle", id = 257808, m = 1432, x = 32.16, y = 65.99 },
	brazierLoch = { npc = "Brazier of the Dormant Flame", obj = 61934, m = 1432, x = 31.79, y = 64.52 },
	sessaria = { npc = "Sessaria Skystride", id = 252382, m = 2521, x = 58.20, y = 78.50, z = true },
	olariaan = { npc = "Olariaan Swiftburn", id = 268592, m = 2521, x = 51.24, y = 86.19 },
	-- Water
	searn = { npc = "Searn Firewarder", id = 5892, m = 1454, x = 37.96, y = 37.74 },
	islen = { npc = "Islen Waterseer", id = 5901, m = 1413, x = 65.83, y = 43.78 },
	brine = { npc = "Brine", id = 5899, m = 1413, x = 43.42, y = 77.41 },
	everfount = { npc = "Brazier of Everfount", obj = 113791, m = 1421, x = 38.28, y = 44.56 },
	waterSilverpine = { npc = "Minor Manifestation of Water", id = 5895, m = 1421, x = 38.75, y = 44.62 },
	eldrun = { npc = "Eldrun Stormbreaker", id = 258098, m = 1455, x = 47.40, y = 13.40, w = true },
	norric = { npc = "Norric Lochthane", id = 258043, m = 1432, x = 41.8, y = 19.0 },
	hervdana = { npc = "Hervdana Saegrund", id = 258203, m = 1437, x = 65.6, y = 76.4 },
	shrine = { npc = "Forgotten Shrine", obj = 619896, m = 1436, x = 45.4, y = 59.7 },
	waterWestfall = { npc = "Minor Manifestation of Water", id = 5895, m = 1436, x = 46.3, y = 59.3 },
	-- Air, Elemental Mastery
	prate = { npc = "Prate Cloudseer", id = 5905, m = 1441, x = 53.54, y = 42.65 },
	veyric = { npc = "Veyric Thunderhame", id = 259023, m = 1417, x = 59.8, y = 27.4 },
	beram = { npc = "Beram Skychaser", id = 3032, m = 1456, x = 22.80, y = 19.40, z = true },
	-- Objective places (no NPC). Zygor, except the three Alliance waterskins (guide only, gitm.gg 15 Nov 2026).
	felstalkers = { m = 1411, x = 44.82, y = 54.59 },
	bristleback = { m = 1412, x = 60.30, y = 80.23 },
	whelps = { m = 1426, x = 26.80, y = 79.86 },
	converts = { m = 2521, x = 46.72, y = 19.83 },
	razormane = { m = 1413, x = 54.15, y = 25.01 },
	dustwind = { m = 1411, x = 52.12, y = 24.95 },
	fireDurotar = { m = 1411, x = 38.84, y = 58.24 },
	silverStream = { m = 1432, x = 35.48, y = 18.86 },
	stonesplinter = { m = 1432, x = 35.14, y = 84.04 },
	fireLoch = { m = 1432, x = 31.90, y = 64.34 },
	faladiel = { m = 2521, x = 64.46, y = 63.71 },
	kuramaa = { m = 2521, x = 42.39, y = 68.89 },
	ritual = { m = 2521, x = 51.20, y = 86.01 },
	brazierEternal = { m = 2521, x = 58.35, y = 78.83 },
	skinBrownH = { m = 1413, x = 44.19, y = 76.90 },
	skinRedH = { m = 1424, x = 62.15, y = 20.75 },
	skinBlueH = { m = 1440, x = 33.55, y = 67.44 },
	corruptSilverpine = { m = 1421, x = 38.84, y = 44.25 },
	skinBrownA = { m = 1437, x = 65.0, y = 74.9 },
	skinRedA = { m = 1433, x = 68.6, y = 60.6 },
	skinBlueA = { m = 1440, x = 32.7, y = 50.6 },
	spiders = { m = 1422, x = 33.60, y = 60.40 },
}
local S = SH_P
local DWARF = { Dwarf = true }

local function ShEarth(faction, races, quests, level)
	return { key = "earth", spell = 8071, level = level or 4, faction = faction, races = races, quests = quests }
end
-- Horde fire, Orc/Troll and Tauren: four starters that all lead to Kranal Fiss (Wowhead series "1522, 1523, 2983, 2984").
local function ShFireH(races, q, alt, starter)
	return { key = "fire", spell = 3599, level = 10, faction = "Horde", races = races, quests = {
		{ q = q, alt = alt, from = starter, to = S.kranal },
		{ q = 1524, from = S.kranal, to = S.telf },
		{ q = 1525, from = S.telf, objs = { O(S.razormane, "FCQ_OBJ_SH_FIRETAR_H", 1), O(S.dustwind, "FCQ_OBJ_SH_POUCH_H", 2) },
			to = S.telf },
		{ q = 1526, from = S.telf, objs = { O(S.fireDurotar, "FCQ_OBJ_SH_EMBER", 1) }, to = S.brazierDurotar },
		{ q = 1527, from = S.brazierDurotar, to = S.kranal },
	} }
end

CHAINS.SHAMAN = {
	-- Earth (4): Stoneskin Totem 8071 + Earth Totem 5175. The sapta steps have no objective (Wowhead): text only.
	ShEarth("Horde", ORCTROLL, {
		{ q = 1516, from = S.canaga, objs = { O(S.felstalkers, "FCQ_OBJ_SH_HOOVES", 1) }, to = S.canaga },
		{ q = 1517, from = S.canaga, objs = { O(S.earthDurotar, "FCQ_OBJ_SH_EARTHSAPTA") }, to = S.earthDurotar },
		{ q = 1518, from = S.earthDurotar, to = S.canaga },
	}),
	ShEarth("Horde", TAUREN, {
		{ q = 1519, from = S.ravenfeather, objs = { O(S.bristleback, "FCQ_OBJ_SH_SALVE", 1) }, to = S.ravenfeather },
		{ q = 1520, from = S.ravenfeather, objs = { O(S.earthMulgore, "FCQ_OBJ_SH_EARTHSAPTA") }, to = S.earthMulgore },
		{ q = 1521, from = S.earthMulgore, to = S.ravenfeather },
	}),
	-- Skyborne from level 3 (Polestar + Questie, Fable check 17 Nov); the others from 4.
	ShEarth("Horde", SKYBORNE, {
		{ q = 92484, gate = 92461, from = S.rorian, to = S.boro },
		{ q = 92466, from = S.boro, objs = { O(S.converts, "FCQ_OBJ_SH_SIGNET", 1) }, to = S.boro },
		{ q = 92467, from = S.boro, objs = { O(S.earthZephras, "FCQ_OBJ_SH_EARTHSAPTA") }, to = S.earthZephras },
		{ q = 92468, from = S.earthZephras, to = S.boro },
	}, 3),
	-- 96243 ("Find Teo", from Eldrun or Ingrid) is the other way in (Spoken, Wowhead series).
	ShEarth("Alliance", DWARF, {
		{ q = 98581, gate = 179, alt = { 96243 }, from = S.sten, to = S.teo },
		{ q = 94373, from = S.teo, objs = { O(S.whelps, "FCQ_OBJ_SH_PENDANTS", 1) }, to = S.teo },
		{ q = 94374, from = S.teo, objs = { O(S.earthDunMorogh, "FCQ_OBJ_SH_EARTHSAPTA") }, to = S.earthDunMorogh },
		{ q = 94375, from = S.earthDunMorogh, to = S.teo },
	}),
	-- Fire (10): Searing Totem 3599 + Fire Totem 5176. Windshapers may not take 1522-1524/2983/2984 (Spoken races 178).
	ShFireH(ORCTROLL, 2983, { 2984, 1522, 1523 }, S.swart),
	ShFireH(TAUREN, 2984, { 2983, 1522, 1523 }, S.narm),
	{ key = "fire", spell = 3599, level = 10, faction = "Horde", races = SKYBORNE, quests = {
		-- Aarnor Galestrike gives 97243 too (Spoken, Wowhead 98517).
		{ q = 97243, from = S.sessaria, to = S.olariaan },
		{ q = 97244, from = S.olariaan, objs = { O(S.faladiel, "FCQ_OBJ_SH_FALADIEL", 1) }, to = S.olariaan },
		{ q = 97245, from = S.olariaan, objs = { O(S.kuramaa, "FCQ_OBJ_SH_KURAMAA", 1) }, to = S.olariaan },
		{ q = 97257, from = S.olariaan, objs = { O(S.ritual, "FCQ_OBJ_SH_RITUAL", 1), O(S.brazierEternal, "FCQ_OBJ_SH_ETERNAL", 2) },
			to = S.sessaria },
	} },
	{ key = "fire", spell = 3599, level = 10, faction = "Alliance", races = DWARF, quests = {
		-- Eldrun Stormbreaker gives 94449 too (Spoken).
		{ q = 94449, from = S.ingrid, to = S.bruegs },
		{ q = 94465, from = S.bruegs, to = S.braldir },
		{ q = 94466, from = S.braldir, objs = { O(S.silverStream, "FCQ_OBJ_SH_FIRETAR_A", 1), O(S.stonesplinter, "FCQ_OBJ_SH_POUCH_A", 2) },
			to = S.braldir },
		{ q = 94467, from = S.braldir, objs = { O(S.fireLoch, "FCQ_OBJ_SH_EMBER", 1) }, to = S.brazierLoch },
		{ q = 94468, from = S.brazierLoch, to = S.bruegs },
	} },
	-- Water (20): Healing Stream Totem 5394 + Water Totem 5177. Horde = every Horde shaman, Windshapers too (Spoken).
	{ key = "water", spell = 5394, level = 20, faction = "Horde", quests = {
		{ q = 1528, alt = { 1529, 2985, 2986 }, from = S.searn, to = S.islen },
		{ q = 1530, from = S.islen, to = S.brine },
		{ q = 1535, from = S.brine, objs = { O(S.skinBrownH, "FCQ_OBJ_SH_SKIN_BROWN_H", 1) }, to = S.brine },
		{ q = 1536, from = S.brine, objs = { O(S.skinRedH, "FCQ_OBJ_SH_SKIN_RED_H", 1) }, to = S.brine },
		{ q = 1534, from = S.brine, objs = { O(S.skinBlueH, "FCQ_OBJ_SH_SKIN_BLUE_H", 1) }, to = S.brine },
		{ q = 220, from = S.brine, to = S.islen },
		{ q = 63, from = S.islen, objs = { O(S.corruptSilverpine, "FCQ_OBJ_SH_BRACERS", 1) }, to = S.everfount },
		{ q = 100, from = S.everfount, to = S.waterSilverpine },
		{ q = 96, from = S.waterSilverpine, to = S.islen },
	} },
	-- 94502 ends at the Forgotten Shrine, not at Norric (Spoken, Polestar; confirmed by Zygor + the quest text, S3).
	-- The ritual calls the spirit (quest text); how long that takes is not measured (S6, 23 Nov 2026).
	{ key = "water", spell = 5394, level = 20, faction = "Alliance", races = DWARF, quests = {
		{ q = 94494, from = S.eldrun, to = S.norric },
		{ q = 94495, from = S.norric, to = S.hervdana },
		{ q = 94497, from = S.hervdana, objs = { O(S.skinBrownA, "FCQ_OBJ_SH_SKIN_BROWN_A", 1) }, to = S.hervdana },
		{ q = 94499, from = S.hervdana, objs = { O(S.skinRedA, "FCQ_OBJ_SH_SKIN_RED_A", 1) }, to = S.hervdana },
		{ q = 94500, from = S.hervdana, objs = { O(S.skinBlueA, "FCQ_OBJ_SH_SKIN_BLUE_A", 1) }, to = S.hervdana },
		{ q = 94501, from = S.hervdana, to = S.norric },
		{ q = 94502, from = S.norric, objs = { O(S.shrine, "FCQ_OBJ_SH_BRACERS", 1) }, to = S.shrine },
		{ q = 94503, from = S.shrine, to = S.waterWestfall },
		{ q = 94505, from = S.waterWestfall, to = S.norric },
	} },
	-- Air (30): only the Air Totem 5178, no spell, so the chain ends when the quest is done. `always`: a totem you always
	-- need is never "outgrown", so it does not leave "Do this now" 10 levels later (Fable check 17 Nov).
	{ key = "air", nameKey = "FCQ_CHAIN_SH_AIR", level = 30, always = true, faction = "Horde", quests = {
		{ q = 1531, alt = { 1532, 96136 }, from = S.searn, to = S.prate } } },
	{ key = "air", nameKey = "FCQ_CHAIN_SH_AIR", level = 30, always = true, faction = "Alliance", races = DWARF, quests = {
		{ q = 94789, from = S.eldrun, to = S.veyric } } },
	-- Elemental Mastery (Horde, 52): 8411 is Bath'rah's own start. The feathers are the warrior's (same items, same order).
	-- Level 50 (Fable check 17 Nov: Wowhead Forever guide "Sunken Temple Class Quests" 16 Nov, Polestar, Questie minlvl 50;
	-- Zygor's "ding 52" is pace, not a gate).
	{ key = "mastery", nameKey = "FCQ_CHAIN_SH_MASTERY", level = 50, faction = "Horde", quests = {
		{ q = 8410, alt = { 8411 }, from = S.beram, objs = {
			O(nil, "FCQ_OBJ_SH_ELEM_AIR", nil, { 7069 }),
			O(nil, "FCQ_OBJ_SH_ELEM_FIRE", nil, { 7068 }),
			O(nil, "FCQ_OBJ_SH_ELEM_EARTH", nil, { 7067 }),
			O(nil, "FCQ_OBJ_SH_ELEM_WATER", nil, { 7070 }),
		}, to = R.bathrah },
		{ q = 8412, from = R.bathrah, objs = { O(S.spiders, "FCQ_OBJ_SH_SPIDEREYE", 1), O(S.spiders, "FCQ_OBJ_SH_CLAW", 2) },
			to = R.bathrah },
		{ q = 8413, from = R.bathrah, objs = {
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_AMBER", 1),
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_BLUE", 2),
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_GREEN", 3),
		}, to = R.bathrah },
	} },
}

--[[ Priest (17 Nov 2026, Bouwchat 17-11; researched by mh-research on Fable). All facts:
	docs/forever/PRIEST_CLASSQUESTS_2026-11-17.md: wago DB2 1.60.1.70938, Wowhead Forever, Icy Veins (guide of 4 Nov +
	database), Spoken, HandyNotes, Zygor Forever.
	Six priest races (CharBaseInfo): Human, Dwarf, Night Elf, Gnome (new), Undead, Troll. No Skyborne, Orc or Tauren.
	Each race learns one spell at 10 and one at 20 from its own high priest. GEMETEN (QuestV2.UniqueBitFlag): the high
	priest's quest and the "go and see your high priest" quests of the other trainers share one completion bit, so they
	are one quest with several ids: one step, the other ids as alt. Handing in any of them ends the chain (AFGELEID that
	the client then says "done" for all ids), also when a later rank has pushed rank 1 out of the spellbook.
	NOT copied from Zygor (GEMETEN): Dwarf Desperate Prayer is handed in to Rohan in Ironforge (Zygor: Laurena); Humans
	learn Divine Grace 94773 (Zygor: Desperate Prayer 5637); Tai'jin gives 5654, Miles Welsh 5642, Ur'kyo 5646 (Zygor:
	5652, 5643, 5644); Zygor has no Gnome steps. Spoken's ender 376 for 5634-5640 is the Classic value.
	AFGELEID: Touch of Weakness 5658 starts at Aelthalyste (Classic sources: Father Lankester, who stands next to her);
	which trainer gives Cenarion Aid per faction (three are known); the objective index.
	The first robe (level 5) is an item chain: since 17 Nov it comes after the spell chains and leaves "Do this now" at 15.
	Not built: Benediction/Anathema (7621-7622: starts with a raid item). Trainers and the rest: Zygor (22 Nov 2026). ]]
local PR_P = {
	-- The race's high priest: gives and takes the spell quest at 10 and at 20.
	laurena = { npc = "High Priestess Laurena", id = 376, m = 1453, x = 49.53, y = 44.57, z = true },
	rohan = { npc = "High Priest Rohan", id = 11406, m = 1455, x = 24.72, y = 8.14, z = true },
	mims = { npc = "High Priestess Mims", id = 258785, m = 1455, x = 24.80, y = 10.00, z = true },
	alathea = { npc = "Priestess Alathea", id = 11401, m = 1457, x = 39.53, y = 81.18, z = true },
	urkyo = { npc = "Ur'kyo", id = 6018, m = 1454, x = 35.59, y = 87.80, z = true },
	aelthalyste = { npc = "Aelthalyste", id = 4606, m = 1458, x = 49.26, y = 17.12, z = true },
	-- First robe (level 5): the trainer of the starting area, then the trainer of the first village.
	anetta = { npc = "Priestess Anetta", id = 375, m = 1429, x = 49.81, y = 39.49, z = true },
	josetta = { npc = "Priestess Josetta", id = 377, m = 1429, x = 43.28, y = 65.72, z = true },
	branstock = { npc = "Branstock Khalder", id = 837, m = 1426, x = 28.60, y = 66.39, z = true },
	maxan = { npc = "Maxan Anvol", id = 1226, m = 1426, x = 47.34, y = 52.19, z = true },
	shanda = { npc = "Shanda", id = 3595, m = 1438, x = 59.17, y = 40.44, z = true },
	laurna = { npc = "Laurna Morninglight", id = 3600, m = 1438, x = 55.56, y = 56.75, z = true },
	kenjai = { npc = "Ken'jai", id = 3707, m = 1411, x = 42.36, y = 68.82, z = true },
	taijin = { npc = "Tai'jin", id = 3706, m = 1411, x = 54.26, y = 42.93, z = true },
	duesten = { npc = "Dark Cleric Duesten", id = 2123, m = 1420, x = 31.11, y = 66.07 }, -- Rob measured 8 Nov 2026 (ForeverTrainerSpots.lua)
	beryl = { npc = "Dark Cleric Beryl", id = 2129, m = 1420, x = 61.57, y = 52.20, z = true },
	-- Whom to heal (no NPC name here: the text names them), Zygor.
	roberts = { m = 1429, x = 48.15, y = 68.05 },
	dolf = { m = 1426, x = 45.81, y = 54.57 },
	shaya = { m = 1438, x = 57.24, y = 63.51 },
	korja = { m = 1411, x = 53.10, y = 46.46 },
	kel = { m = 1420, x = 59.18, y = 46.50 },
	-- Cenarion Aid (level 50). Ogtinc and the coursers are the hunter's places (H); Winterspring = UiMap 1452 (DB2).
	joshua = { npc = "Brother Joshua", id = 5489, m = 1453, x = 49.47, y = 45.16, z = true },
	greta = { npc = "Greta Mosshoof", id = 10922, m = 1448, x = 51.20, y = 82.20 },
	highborne = { m = 1452, x = 52.59, y = 40.68 },
}
local PR = PR_P

-- One quest, several ids: q = the high priest's own, alt = the same quest from another trainer.
local function PrSpell(key, spell, level, faction, races, priest, q, alt)
	return { key = key, spell = spell, level = level, faction = faction, races = races,
		quests = { { q = q, alt = alt, from = priest, to = priest } } }
end
-- t = { first quest, its giver, second quest, the village trainer, where the guard stands, textKey }
local function PrRobe(faction, races, t)
	return { key = "robe", nameKey = "FCQ_CHAIN_PR_ROBE", level = 5, faction = faction, races = races, quests = {
		{ q = t[1], from = t[2], to = t[4] },
		-- "heal his wounds using Lesser Heal (Rank 2)" (Wowhead Forever): rank 2 = spell 2052, level 4 (DB2 SpellLevels,
		-- GEMETEN). That the client reports a known RANK this way = AFGELEID (TESTLIJST).
		{ q = t[3], from = t[4], objs = { O(t[5], t[6], 1) }, to = t[4],
			-- Rank 3 (2053, level 10) counts too: should it replace rank 2 in the spellbook, nobody gets stuck (second check).
			pre = { { spell = { 2052, 2053 }, place = t[4], textKey = "FCQ_PRE_PR_HEAL2" } } },
	} }
end
-- Cenarion Aid (level 50): an item chain; the last quest is handed in to Greta Mosshoof in Felwood.
local function PrCenarion(faction, trainer)
	return { key = "cenarion", nameKey = "FCQ_CHAIN_PR_CENARION", level = 50, faction = faction, quests = {
		{ q = 8254, from = trainer, to = H.ogtinc },
		{ q = 8255, from = H.ogtinc, objs = { O(H.coursers, "FCQ_OBJ_PR_GLANDS", 1) }, to = H.ogtinc },
		{ q = 8256, from = H.ogtinc, objs = { O(PR.highborne, "FCQ_OBJ_PR_ICHOR", 1) }, to = H.ogtinc },
		{ q = 8257, from = H.ogtinc, objs = { O(P.sunken, "FCQ_OBJ_PR_MORPHAZ", 1) }, to = PR.greta },
	} }
end

CHAINS.PRIEST = {
	-- First robe (level 5). DWGN: Dwarf and Gnome share these two quests (Spoken races 68).
	PrRobe("Alliance", HUM, { 5623, PR.anetta, 5624, PR.josetta, PR.roberts, "FCQ_OBJ_PR_ROBERTS" }),
	PrRobe("Alliance", DWGN, { 5626, PR.branstock, 5625, PR.maxan, PR.dolf, "FCQ_OBJ_PR_DOLF" }),
	PrRobe("Alliance", NELF, { 5622, PR.shanda, 5621, PR.laurna, PR.shaya, "FCQ_OBJ_PR_SHAYA" }),
	-- ORCTROLL: there is no Orc priest (CharBaseInfo), so the extra race does nothing.
	PrRobe("Horde", ORCTROLL, { 5649, PR.kenjai, 5648, PR.taijin, PR.korja, "FCQ_OBJ_PR_KORJA" }),
	PrRobe("Horde", UD, { 5651, PR.duesten, 5650, PR.beryl, PR.kel, "FCQ_OBJ_PR_KEL" }),
	-- Race spell, level 10
	PrSpell("divinegrace", 1277370, 10, "Alliance", HUM, PR.laurena, 94773, { 94774, 94775, 94776, 94777, 94778, 94779 }),
	PrSpell("desperateprayer", 13908, 10, "Alliance", DWARF, PR.rohan, 5639, { 5634, 5635, 5636, 5637, 5638, 5640 }),
	PrSpell("confoundingflash", 1277455, 10, "Alliance", GNO, PR.mims, 94817, { 94821, 94822, 94823, 94824, 94825, 94826 }),
	PrSpell("starshards", 10797, 10, "Alliance", NELF, PR.alathea, 5627, { 5628, 5629, 5630, 5631, 5632, 5633 }),
	PrSpell("hexofweakness", 9035, 10, "Horde", ORCTROLL, PR.urkyo, 5652, { 5654, 5655, 5656, 5657 }),
	PrSpell("touchofweakness", 2652, 10, "Horde", UD, PR.aelthalyste, 5658, { 5660, 5661, 5662, 5663 }),
	-- Race spell, level 20
	PrSpell("feedback", 13896, 20, "Alliance", HUM, PR.laurena, 5676, { 5677, 5678 }),
	PrSpell("chastise", 1277331, 20, "Alliance", DWARF, PR.rohan, 5641, { 5645, 5647 }),
	PrSpell("contingencyplan", 1277462, 20, "Alliance", GNO, PR.mims, 94818, { 94819, 94820 }),
	PrSpell("elunesgrace", 2651, 20, "Alliance", NELF, PR.alathea, 5672, { 5673, 5674, 5675 }),
	PrSpell("shadowguard", 18137, 20, "Horde", ORCTROLL, PR.urkyo, 5680, { 5642, 5643 }),
	PrSpell("darksacrifice", 1277324, 20, "Horde", UD, PR.aelthalyste, 5679, { 5644, 5646 }),
	-- Level 50: the trainer per faction is a choice (AFGELEID); Malakai Cross in Thunder Bluff gives 8254 too.
	PrCenarion("Alliance", PR.joshua),
	PrCenarion("Horde", PR.urkyo),
}

--[[ Paladin (17 Nov 2026, Bouwchat 17-11; researched by mh-research on Fable). All facts:
	docs/forever/PALADIN_CLASSQUESTS_2026-11-17.md: Zygor Forever "Paladin Class Quests" + the leveling guides (Undead),
	Spoken, wago DB2 1.60.1.70938, Wowhead Forever, azeroth.wiki, the Icy Veins database, HandyNotes.
	Paladins: Human, Dwarf, Undead (CharBaseInfo, Undead NEW); no Tauren, no Skyborne.
	AFGELEID: the trainer breadcrumbs (2998/2999, 4485, 7638, 97022) are optional; 4485 is given by Arthur the Faithful
	(Spoken, forg.gg; azeroth.wiki says Tiza Battleforge); the objective index; Summon Charger = 23214 on 7647.
	1786/1783 have no objective index on purpose (Wowhead shows none): the step waits until the quest is complete.
	`item` = the quest starts from that tome in your bags (step "use … in your bags").
	Zygor mistakes not copied: 2997 at Brandur (= 2999), 1794 at Duthorian (= Tiza), |q 8232 at the Sunken Temple step
	(= 8418), Lost Soul as 7647/1. Trainers and the rest: Zygor (22 Nov 2026); Undead level 12+: azeroth.wiki / Wowhead.
	Not built (bouwchat choice, Rob may reverse): the Undead Forsaken Charger (97174-97185: most givers AFGELEID, a
	player wrote that nothing followed after 97177: measure in game first); Cloak of the Divine Storm (starts at an
	object), the Aeonas quests, The Reliquary of Tyr, The Errant Knight (found, not researched). ]]
local PA_P = {
	-- Alliance
	wilhelm = { npc = "Brother Wilhelm", id = 927, m = 1429, x = 41.10, y = 66.04, z = true },
	duthorian = { npc = "Duthorian Rall", id = 6171, m = 1453, x = 50.48, y = 47.49 },
	stephanie = { npc = "Stephanie Turner", id = 6174, m = 1453, x = 63.84, y = 72.21 },
	gazin = { npc = "Gazin Tenorm", id = 6173, m = 1453, x = 49.51, y = 44.90 },
	henze = { npc = "Henze Faulk", id = 6172, m = 1429, x = 72.60, y = 51.41 },
	brandur = { npc = "Brandur Ironhammer", id = 5149, m = 1455, x = 23.13, y = 6.14, z = true },
	tiza = { npc = "Tiza Battleforge", id = 6179, m = 1455, x = 27.64, y = 12.19 },
	johnTurner = { npc = "John Turner", id = 6175, m = 1455, x = 21.55, y = 50.80 },
	muiredon = { npc = "Muiredon Battleforge", id = 6178, m = 1455, x = 23.53, y = 8.29 },
	narm = { npc = "Narm Faulk", id = 6177, m = 1426, x = 78.32, y = 58.09 },
	daphne = { npc = "Daphne Stilwell", id = 6182, m = 1436, x = 42.71, y = 88.40 },
	jordan = { npc = "Jordan Stilwell", id = 6181, m = 1426, x = 52.48, y = 36.92 },
	bailor = { npc = "Bailor Stonehand", id = 6241, m = 1432, x = 35.96, y = 44.92 },
	thundris = { npc = "Thundris Windweaver", id = 3649, m = 1439, x = 37.40, y = 40.13 },
	arthur = { npc = "Arthur the Faithful", id = 5491, m = 1453, x = 49.61, y = 49.91, z = true },
	grayson = { npc = "Lord Grayson Shadowbreaker", id = 928, m = 1453, x = 48.43, y = 50.22, z = true },
	ashlam = { npc = "Commander Ashlam Valorfist", id = 10838, m = 1422, x = 42.70, y = 84.03 },
	theldanis = { npc = "High Priest Thel'danis", id = 1854, m = 1422, x = 52.09, y = 83.35 },
	rohan = { npc = "High Priest Rohan", id = 11406, m = 1455, x = 26.98, y = 7.30 },
	grimand = { npc = "Grimand Elmore", id = 1416, m = 1453, x = 59.71, y = 33.77 },
	merideth = { npc = "Merideth Carlson", id = 2357, m = 1424, x = 52.18, y = 55.50 },
	-- Inside a dungeon: the arrow points at the Dire Maul West door / the stairs to Scholomance (AFGELEID).
	equineSpirit = { npc = "Ancient Equine Spirit", id = 14566, m = 1444, x = 60.32, y = 30.16 },
	fallenCharger = { npc = "Darkreaver's Fallen Charger", id = 14568, m = 1422, x = 69.94, y = 74.03 },
	-- Horde (Undead)
	sarvis = { npc = "Shadow Priest Sarvis", id = 1569, m = 1420, x = 30.84, y = 66.20 },
	aramis = { npc = "Aramis Hammerhand", id = 244808, m = 1420, x = 31.11, y = 66.38 }, -- Rob measured 11 Nov 2026 (ForeverTrainerSpots.lua)
	shari = { npc = "Shari Stilwell", id = 246152, m = 1420, x = 60.20, y = 52.50, z = true },
	breton = { npc = "Breton Samuels", id = 246349, m = 1420, x = 21.85, y = 45.21 },
	jorin = { npc = "Jorin Croge", id = 246393, m = 1420, x = 22.70, y = 44.68 },
	danitha = { npc = "Danitha Morr", id = 246378, m = 1420, x = 22.09, y = 44.66 },
	sylvanas = { npc = "Lady Sylvanas Windrunner", id = 10181, m = 1458, x = 58.06, y = 91.78 },
	tanis = { npc = "Tanis Alderwood", id = 257648, m = 1458, x = 65.45, y = 37.47 },
	billmuth = { npc = "Deathguard Billmuth", id = 257655, m = 1420, x = 21.9, y = 44.5 },
	falgan = { npc = "Deathguard Falgan", id = 257663, m = 1420, x = 86.7, y = 47.7 },
	trevan = { npc = "Trevan Rol", id = 248840, m = 1421, x = 43.3, y = 41.0 },
	baldren = { npc = "Deathguard Baldren", id = 259611, m = 1421, x = 45.8, y = 41.8 },
	charredRemains = { npc = "Charred Remains", m = 1421, x = 64.9, y = 34.4 }, -- an object: no id, English name
	luminaFenris = { npc = "Lumina Windsinger", id = 248755, m = 1421, x = 65.5, y = 23.5 },
	luminaSepulcher = { npc = "Lumina Windsinger", id = 259620, m = 1421, x = 43.3, y = 41.0 },
	ulric = { npc = "Ulric Frostveil", id = 259649, m = 1440, x = 11.8, y = 34.5 },
	ott = { npc = "Ott", id = 3539, m = 1424, x = 60.4, y = 26.2 },
	garen = { npc = "Garen Largo", id = 260093, m = 1458, x = 47.39, y = 14.89, z = true },
	-- Objective places (no NPC)
	defiasWizards = { m = 1429, x = 74.07, y = 51.57 },
	darkIronSpies = { m = 1426, x = 77.39, y = 61.27 },
	bailorsOre = { m = 1432, x = 71.62, y = 21.55 },
	deadmines = { m = 1436, x = 42.57, y = 71.83 },
	bfd = { m = 1440, x = 14.12, y = 13.88 },
	scourgestones = { m = 1422, x = 40.65, y = 70.27 },
	terrordale = { m = 1423, x = 15.97, y = 25.26 },
	stratGate = { m = 1423, x = 41.43, y = 17.71 },
	deathguards = { m = 1420, x = 31.98, y = 64.72 },
	vileFin = { m = 1420, x = 14.68, y = 54.75 },
	hilda = { m = 1420, x = 21.95, y = 47.24 },
	ander = { m = 1420, x = 25.41, y = 50.41 },
	lumberCrypt = { m = 1420, x = 10.42, y = 65.69 },
	gelhardt = { m = 1420, x = 11.53, y = 64.21 },
	tarnished = { m = 1420, x = 12.87, y = 63.45 },
	oldFireEye = { m = 1421, x = 49.4, y = 86.8 },
}
local PA = PA_P

CHAINS.PALADIN = {
	-- Redemption (12). DWGN: there is no Gnome paladin (CharBaseInfo), so the extra race does nothing.
	{ key = "redemption", spell = 7328, level = 12, faction = "Alliance", races = HUM, quests = {
		{ q = 2998, alt = { 3681 }, from = PA.wilhelm, to = PA.duthorian },
		{ q = 1641, from = PA.duthorian, to = PA.duthorian },
		{ q = 1642, item = 6775, from = PA.duthorian, to = PA.duthorian },
		{ q = 1643, from = PA.duthorian, to = PA.stephanie },
		{ q = 1644, from = PA.stephanie, objs = { O(nil, "FCQ_OBJ_PA_LINEN", 1) }, to = PA.stephanie },
		{ q = 1780, from = PA.stephanie, to = PA.duthorian },
		{ q = 1781, from = PA.duthorian, to = PA.gazin },
		{ q = 1786, from = PA.gazin, objs = { O(PA.henze, "FCQ_OBJ_PA_RESURRECT") }, to = PA.henze },
		{ q = 1787, from = PA.henze, objs = { O(PA.defiasWizards, "FCQ_OBJ_PA_DEFIAS_SCRIPT", 1) }, to = PA.gazin },
		{ q = 1788, from = PA.gazin, to = PA.duthorian },
	} },
	{ key = "redemption", spell = 7328, level = 12, faction = "Alliance", races = DWGN, quests = {
		{ q = 2999, alt = { 2997, 3000 }, from = PA.brandur, to = PA.tiza },
		{ q = 1645, from = PA.tiza, to = PA.tiza },
		{ q = 1646, item = 6916, from = PA.tiza, to = PA.tiza },
		{ q = 1647, from = PA.tiza, to = PA.johnTurner },
		{ q = 1648, from = PA.johnTurner, objs = { O(nil, "FCQ_OBJ_PA_LINEN", 1) }, to = PA.johnTurner },
		{ q = 1778, from = PA.johnTurner, to = PA.tiza },
		{ q = 1779, from = PA.tiza, to = PA.muiredon },
		{ q = 1783, from = PA.muiredon, objs = { O(PA.narm, "FCQ_OBJ_PA_RESURRECT") }, to = PA.narm },
		{ q = 1784, from = PA.narm, objs = { O(PA.darkIronSpies, "FCQ_OBJ_PA_DARKIRON_SCRIPT", 1) }, to = PA.muiredon },
		{ q = 1785, from = PA.muiredon, to = PA.tiza },
	} },
	-- Verigan's Fist (20). The two side quests of 1654 stand first, so they are asked before the dungeons; they open
	-- after 1653 (AFGELEID). 1652 also teaches Sense Undead 5502 (Wowhead).
	{ key = "veriganore", nameKey = "FCQ_CHAIN_PA_VERIGAN_ORE", level = 20, needs = 1653, faction = "Alliance", quests = {
		{ q = 1655, from = PA.bailor, objs = { O(PA.bailorsOre, "FCQ_OBJ_PA_ORECRATE", 1) }, to = PA.bailor } } },
	{ key = "verigangem", nameKey = "FCQ_CHAIN_PA_VERIGAN_GEM", level = 20, needs = 1653, faction = "Alliance", quests = {
		{ q = 1442, from = PA.thundris, objs = { O(PA.bfd, "FCQ_OBJ_PA_KORGEM", 1) }, to = PA.thundris } } },
	{ key = "verigan", nameKey = "FCQ_CHAIN_PA_VERIGAN", level = 20, faction = "Alliance", quests = {
		{ q = 1793, alt = { 1794 }, from = PA.duthorian, to = PA.duthorian },
		{ q = 1649, item = 6776, from = PA.duthorian, to = PA.duthorian },
		{ q = 1650, from = PA.duthorian, to = PA.daphne },
		{ q = 1651, from = PA.daphne, objs = { O(PA.daphne, "FCQ_OBJ_PA_DEFEND_DAPHNE", 1) }, to = PA.daphne },
		{ q = 1652, from = PA.daphne, to = PA.duthorian },
		{ q = 1653, from = PA.duthorian, to = PA.jordan },
		{ q = 1654, from = PA.jordan, objs = {
			O(PA.bailor, "FCQ_OBJ_PA_ORE", 2),
			O(PA.thundris, "FCQ_OBJ_PA_PURIFIEDGEM", 4),
			O(PA.deadmines, "FCQ_OBJ_PA_LUMBER", 1),
			O(nil, "FCQ_OBJ_PA_HAMMER", 3),
		}, to = PA.jordan },
		{ q = 1806, from = PA.jordan, to = PA.jordan },
	} },
	-- Warhorse (40). A collection mount in Forever? Whether the spell check sees it = NOT measured; the chain also ends
	-- once 1661 is done.
	{ key = "warhorse", spell = 13819, level = 40, faction = "Alliance", quests = {
		{ q = 4485, alt = { 4486 }, from = PA.arthur, to = PA.duthorian },
		{ q = 1661, from = PA.duthorian, to = PA.duthorian },
	} },
	-- Level 50 (quest level 52): an item to choose. Brandur Ironhammer in Ironforge gives 8415 too.
	{ key = "mightstone", nameKey = "FCQ_CHAIN_PA_MIGHTSTONE", level = 50, faction = "Alliance", quests = {
		{ q = 8415, from = PA.grayson, to = PA.ashlam },
		{ q = 8414, from = PA.ashlam, objs = { O(PA.scourgestones, "FCQ_OBJ_PA_SCOURGESTONES", 1) }, to = PA.theldanis },
		{ q = 8416, from = PA.theldanis, to = PA.ashlam },
		{ q = 8418, from = PA.ashlam, objs = {
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_AMBER", 1),
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_BLUE", 2),
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_GREEN", 3),
		}, to = PA.ashlam },
	} },
	-- Charger (60). 7645 (Merideth's horse feed) is asked inside 7643.
	{ key = "charger", spell = 23214, level = 60, faction = "Alliance", quests = {
		{ q = 7638, alt = { 7670 }, from = PA.duthorian, to = PA.grayson },
		-- 7637: "a donation of 150 gold", Requirements Money:150 (Wowhead Forever, GEMETEN, 18 Nov 2026).
		{ q = 7637, from = PA.grayson, to = PA.rohan, pre = { { gold = 1500000, at = PA.rohan } } },
		{ q = 7639, from = PA.rohan, to = PA.grayson },
		{ q = 7640, from = PA.grayson, objs = { O(PA.terrordale, "FCQ_OBJ_PA_TERRORDALE", 1) }, to = PA.grayson },
		{ q = 7641, from = PA.grayson, to = PA.grimand },
		{ q = 7642, from = PA.grimand, objs = {
			O(PA.stratGate, "FCQ_OBJ_PA_HOLYWATER", 1),
			O(nil, "FCQ_OBJ_PA_ARTHAS", 2),
			O(nil, "FCQ_OBJ_PA_RUNECLOTH", 3),
			O(nil, "FCQ_OBJ_PA_ARCANITE", 4),
		}, to = PA.grimand,
			-- Money:150 too (Wowhead Forever, GEMETEN by the second check, 18 Nov 2026).
			-- turn = true: only once the four objectives are done, so the Stratholme steps still show first.
			pre = { { gold = 1500000, at = PA.grimand, turn = true } } },
		{ q = 7648, from = PA.grimand, to = PA.grayson },
		{ q = 7643, from = PA.grayson, objs = { O(PA.merideth, "FCQ_OBJ_PA_HORSEFEED", 1) }, to = PA.equineSpirit },
		{ q = 7644, from = PA.equineSpirit, to = PA.grayson },
		{ q = 7646, from = PA.grayson, objs = { O(nil, "FCQ_OBJ_PA_AZEROTHIAN", 1), O(nil, "FCQ_OBJ_PA_BLACKDIAMOND", 2) },
			to = PA.grayson },
		-- Open the satchel (objective 2 = the barding), then the Scholomance fight (objective 1 = the soul).
		{ q = 7647, from = PA.grayson, objs = { O(nil, "FCQ_OBJ_PA_SATCHEL", 2), O(PA.fallenCharger, "FCQ_OBJ_PA_SCRYER", 1) },
			to = PA.fallenCharger },
	} },

	-- Undead. Holy Light (2): opens after The Mindless Ones 364 (Spoken prev). The spell comes when you take 90902
	-- (AFGELEID), so the chain may end there; the quest itself is then in your log.
	{ key = "holylight", spell = 635, level = 2, needs = 364, faction = "Horde", races = UD, quests = {
		{ q = 98601, from = PA.sarvis, to = PA.aramis },
		{ q = 90902, from = PA.aramis, objs = { O(PA.deathguards, "FCQ_OBJ_PA_HEAL_DEATHGUARDS", 1) }, to = PA.aramis },
	} },
	-- Bandarion Keep (from 8): a mace and a shield. Optional; Making Repairs is a side quest of Jorin Croge.
	{ key = "keep", nameKey = "FCQ_CHAIN_PA_KEEP", level = 8, faction = "Horde", races = UD, quests = {
		{ q = 91282, from = PA.shari, to = PA.breton },
		{ q = 91285, from = PA.breton, objs = {
			O(PA.vileFin, "FCQ_OBJ_PA_VILEFIN_ATTACKERS", 1), O(PA.vileFin, "FCQ_OBJ_PA_VILEFIN_SEERS", 2) }, to = PA.breton },
		{ q = 91294, from = PA.breton, objs = {
			O(PA.jorin, "FCQ_OBJ_PA_TOUR_JORIN", 2), O(PA.hilda, "FCQ_OBJ_PA_TOUR_HILDA", 1),
			O(PA.ander, "FCQ_OBJ_PA_TOUR_ANDER", 3), O(PA.danitha, "FCQ_OBJ_PA_TOUR_DANITHA", 4) }, to = PA.danitha },
		{ q = 91316, from = PA.jorin, objs = { O(PA.lumberCrypt, "FCQ_OBJ_PA_STURDY_LUMBER", 1) }, to = PA.jorin },
		{ q = 91317, from = PA.danitha, objs = {
			O(PA.gelhardt, "FCQ_OBJ_PA_GELHARDT", 1), O(PA.tarnished, "FCQ_OBJ_PA_DRUDGES", 2),
			O(PA.tarnished, "FCQ_OBJ_PA_ZEALOTS", 3) }, to = PA.danitha },
		{ q = 95803, from = PA.danitha, to = PA.sylvanas },
	} },
	-- Redemption (12), NEW in Forever. The Scarlet camp is at Falgan's spot in Venomweb Vale (AFGELEID).
	{ key = "redemption", spell = 7328, level = 12, faction = "Horde", races = UD, quests = {
		{ q = 94427, from = PA.danitha, to = PA.tanis },
		{ q = 94434, from = PA.tanis, objs = { O(nil, "FCQ_OBJ_PA_LINEN", 1) }, to = PA.tanis },
		{ q = 94435, from = PA.tanis, to = PA.danitha },
		{ q = 94436, from = PA.danitha, to = PA.billmuth },
		{ q = 94438, from = PA.billmuth, objs = { O(PA.falgan, "FCQ_OBJ_PA_RESURRECT", 1) }, to = PA.falgan },
		{ q = 94440, from = PA.falgan, objs = { O(PA.falgan, "FCQ_OBJ_PA_ATTACK_PLANS", 1) }, to = PA.billmuth },
		{ q = 94441, from = PA.billmuth, to = PA.danitha },
	} },
	-- Wolfsbane (item 267369), NEW in Forever. 91858 can be taken from level 18, 95036 needs 20: level 20 here.
	{ key = "wolfsbanegem", nameKey = "FCQ_CHAIN_PA_WOLFSBANE_GEM", level = 20, needs = 95034, faction = "Horde", races = UD,
		quests = { { q = 95042, from = PA.ulric, objs = { O(PA.bfd, "FCQ_OBJ_PA_KORGEM", 1) }, to = PA.ulric } } },
	{ key = "wolfsbane", nameKey = "FCQ_CHAIN_PA_WOLFSBANE", level = 20, faction = "Horde", races = UD, quests = {
		{ q = 91858, from = PA.danitha, to = PA.trevan },
		{ q = 91859, from = PA.trevan, to = PA.baldren },
		{ q = 91860, from = PA.baldren, to = PA.charredRemains },
		{ q = 91861, from = PA.charredRemains, to = PA.luminaFenris },
		{ q = 91862, from = PA.luminaFenris, objs = { O(PA.luminaFenris, "FCQ_OBJ_PA_FENRIS_KEY", 1) }, to = PA.luminaFenris },
		{ q = 96204, from = PA.luminaFenris, objs = { O(PA.luminaFenris, "FCQ_OBJ_PA_ESCORT_LUMINA", 1) }, to = PA.luminaSepulcher },
		{ q = 95034, from = PA.luminaSepulcher, objs = { O(PA.luminaSepulcher, "FCQ_OBJ_PA_TALK_LUMINA", 1) },
			to = PA.luminaSepulcher },
		{ q = 95036, from = PA.luminaSepulcher, objs = {
			O(PA.trevan, "FCQ_OBJ_PA_WEAPON_NOTES", 1),
			O(PA.ulric, "FCQ_OBJ_PA_PURIFIEDGEM", 4),
			O(PA.deadmines, "FCQ_OBJ_PA_LUMBER", 2),
			O(nil, "FCQ_OBJ_PA_SILVER_INGOT", 3),
		}, to = PA.trevan },
		{ q = 95111, from = PA.trevan, to = PA.ott },
		{ q = 95125, from = PA.ott, objs = { O(PA.ott, "FCQ_OBJ_PA_WATCH_OTT", 1) }, to = PA.ott },
		{ q = 95126, from = PA.ott, to = PA.trevan },
		{ q = 95140, from = PA.luminaSepulcher, objs = { O(PA.oldFireEye, "FCQ_OBJ_PA_OLD_FIREEYE", 1) }, to = PA.luminaSepulcher },
	} },
	-- Warhorse (40), NEW in Forever. Alodan the Hopeful in Thunder Bluff gives 97022 too.
	{ key = "warhorse", spell = 1279399, level = 40, faction = "Horde", races = UD, quests = {
		{ q = 97022, from = PA.garen, to = PA.danitha },
		{ q = 94971, from = PA.danitha, to = PA.danitha },
	} },
}

--[[ Mage (17 Nov 2026, Bouwchat 17-11; researched by mh-research on Fable). All facts:
	docs/forever/MAGE_CLASSQUESTS_2026-11-17.md: Zygor Forever "Mage Class Quests" + Common + the Sunken Temple dungeon
	guide, Spoken, wago DB2 1.60.1.70938 (local cache), Wowhead Forever, Icy Veins DB, azeroth.wiki, Polestar, HandyNotes.
	GEMETEN on Wowhead Forever: 7463 teaches Conjure Water 10140, 9364 teaches Polymorph 28272 (the pig), 97286 teaches
	Study 1302508. There are no rank quests and no teleport or portal quests (trainers). Mage races (CharBaseInfo): Human,
	Gnome, High Order Skyborne, Orc, Troll, Undead.
	NEW in Forever: Boughs in the Wind (93791-93797), Research Access (97286), A Lesson in Literacy (82084), Scalebeard
	(90789; shares its completion bit with 9362 Warlord Krellian).
	AFGELEID: which race walks which route; that a pointer quest may be skipped (Troll starts at 1884, Skyborne at 1861);
	Orc and Skyborne on the level 15 and 26 chains (sources disagree: item chains, so at worst the line leaves "Do this
	now" 10 levels later); 90789 before 9362; the trainer per race from level 30; level 6 for Study; Lydros' place = the
	Dire Maul West door; the objective index. 1955 has no objective index on purpose (Wowhead shows two lines).
	1948 runs beside 1949-1951: its own chain, first. Not built: Tabetha's Task / Tiara of the Deep (any class), The
	Arcanist's Cookbook (starts from an item), the level 1 letters (experience only). Destroy Morphaz pays Glacial Spike
	20035 (Wowhead Forever, 17 Nov); that it is missing from the local ItemSparse 70938 proves nothing (hotfix items).
	Zygor mistakes not copied: ding 15 before the level 10 quest, |q 18299 (= 7463), Return to the Marsh at 40 (= 35). ]]
local MA_P = {
	zaldimar = { npc = "Zaldimar Wefhellt", id = 328, m = 1429, x = 43.25, y = 66.19, z = true },
	jennea = { npc = "Jennea Cannon", id = 5497, m = 1453, x = 49.50, y = 85.84, z = true },
	magis = { npc = "Magis Sparkmantle", id = 1228, m = 1426, x = 47.50, y = 52.08, z = true },
	bink = { npc = "Bink", id = 5144, m = 1455, x = 27.24, y = 8.29, z = true },
	dink = { npc = "Dink", id = 7312, m = 1455, x = 27.16, y = 8.56, z = true },
	anathamaas = { npc = "Anathamaas Aetherwind", id = 252373, m = 2521, x = 65.80, y = 80.50, z = true },
	belann = { npc = "Belann Windwood", id = 256507, m = 2521, x = 62.90, y = 77.44 },
	wynne = { npc = "Wynne Larson", id = 1309, m = 1453, x = 51.84, y = 83.51 },
	andromath = { npc = "High Sorcerer Andromath", id = 5694, m = 1453, x = 48.71, y = 87.61 },
	maginor = { npc = "Maginor Dumas", id = 331, m = 1453, x = 49.24, y = 87.78, z = true },
	garion = { npc = "Garion Wendell", id = 211033, m = 1453, x = 48.9, y = 86.5 },
	uthelnay = { npc = "Uthel'nay", id = 7311, m = 1454, x = 39.16, y = 86.27, z = true },
	unthuwa = { npc = "Un'Thuwa", id = 5880, m = 1411, x = 56.31, y = 75.11, z = true },
	cain = { npc = "Cain Firesong", id = 2128, m = 1420, x = 61.97, y = 52.47, z = true },
	anastasia = { npc = "Anastasia Hartwell", id = 4568, m = 1458, x = 85.14, y = 10.03, z = true },
	josef = { npc = "Josef Gregorian", id = 4576, m = 1458, x = 70.75, y = 30.69 },
	deino = { npc = "Deino", id = 5885, m = 1454, x = 38.45, y = 86.14, z = true },
	kilhala = { npc = "Kil'hala", id = 3484, m = 1413, x = 52.20, y = 31.70 },
	pierce = { npc = "Pierce Shackleton", id = 4567, m = 1458, x = 85.44, y = 13.50, z = true },
	owen = { npc = "Owen Thadd", id = 211022, m = 1458, x = 73.4, y = 33.0 },
	tabetha = { npc = "Tabetha", id = 6546, m = 1445, x = 46.06, y = 57.09 },
	tirth = { npc = "Magus Tirth", id = 6548, m = 1441, x = 78.29, y = 75.70 },
	sanath = { npc = "Sanath Lim-yo", id = 8395, m = 1447, x = 28.11, y = 50.09 },
	-- Lydros stands inside Dire Maul (the Athenaeum): the arrow points at the West door (AFGELEID).
	lydros = { npc = "Lorekeeper Lydros", id = 14368, m = 1444, x = 60.32, y = 30.16 },
	-- Objective places (no NPC).
	mirrorLake = { m = 1429, x = 28.78, y = 61.47 },
	toolbox = { m = 1426, x = 27.7, y = 36.4 },
	bough = { m = 2521, x = 48.72, y = 67.77 },
	juju = { m = 1411, x = 67.76, y = 83.50 },
	snapdragons = { m = 1420, x = 76.94, y = 62.38 },
	cofferChestSW = { m = 1453, x = 49.54, y = 85.61 },
	cantationSW = { m = 1453, x = 49.62, y = 85.40 },
	blueRecluse = { m = 1453, x = 51.12, y = 95.56 },
	riftGems = { m = 1432, x = 35.85, y = 22.58 },
	cofferChestUC = { m = 1458, x = 85.65, y = 10.00 },
	alchemist = { m = 1458, x = 52.99, y = 74.92 },
	manaGems = { m = 1421, x = 62.26, y = 64.24 },
	treatise = { m = 1433, x = 73.78, y = 47.64 },
	spiderSilk = { m = 1431, x = 31.38, y = 26.95 },
	xavian = { m = 1440, x = 76.33, y = 41.43 },
	sisters = { m = 1440, x = 58.61, y = 59.49 },
	plucky = { m = 1441, x = 79.60, y = 75.60 },
	witherbark = { m = 1417, x = 66.66, y = 64.37 },
	bramble = { m = 1417, x = 52.06, y = 50.69 },
	summoners = { m = 1443, x = 53.34, y = 79.05 },
	demon = { m = 1445, x = 46.04, y = 57.10 },
	uldaman = { m = 1418, x = 65.05, y = 43.45 },
	surges = { m = 1445, x = 45.85, y = 56.76 },
	owlbeasts = { m = 1425, x = 55.2, y = 51.4 },
	zukkash = { m = 1444, x = 75.4, y = 61.4 },
	zulfarrak = { m = 1446, x = 38.7, y = 19.5 },
	dust = { m = 1447, x = 56.94, y = 29.30 },
	coral = { m = 1447, x = 47.65, y = 43.93 },
	dmEast = { m = 1444, x = 64.85, y = 30.18 },
	scalebeard = { m = 1447, x = 54.20, y = 48.60 },
}
local MA = MA_P

-- Level 10: one staff-or-orb quest per character (1861/1880 and 1882/1884 share a completion bit in QuestV2), so each
-- route names the other as alt.
local function MaFocus(faction, races, quests)
	return { key = "focus", nameKey = "FCQ_CHAIN_MA_FOCUS", level = 10, faction = faction, races = races, quests = quests }
end
local MA_MIRROR = { q = 1861, alt = { 1880 }, from = MA.jennea, objs = { O(MA.mirrorLake, "FCQ_OBJ_MA_MIRRORLAKE", 1) },
	to = MA.jennea }
local MA_JUJU = { q = 1884, alt = { 1882 }, from = MA.unthuwa, objs = { O(MA.juju, "FCQ_OBJ_MA_JUJU", 1) }, to = MA.unthuwa }

-- Level 15: the robe. Orc and Skyborne: the sources disagree whether they may take it (not seen in game).
local function MaRobeA(races, starter)
	return { key = "robe", nameKey = "FCQ_CHAIN_MA_ROBE_A", level = 15, faction = "Alliance", races = races, quests = {
		{ q = 1919, from = starter, to = MA.jennea },
		{ q = 1920, from = MA.jennea, objs = {
			O(MA.cofferChestSW, "FCQ_OBJ_MA_COFFERCHEST", 2),
			O(MA.cantationSW, "FCQ_OBJ_MA_CANTATION", 3),
			O(MA.blueRecluse, "FCQ_OBJ_MA_COFFERS_A", 1),
		}, to = MA.jennea },
		{ q = 1921, from = MA.jennea, objs = { O(MA.riftGems, "FCQ_OBJ_MA_RIFTGEMS", 2), O(nil, "FCQ_OBJ_MA_LINEN", 1) },
			to = MA.wynne },
		{ q = 1941, from = MA.wynne, to = MA.wynne },
	} }
end
local function MaRobeH(races, starter)
	return { key = "robe", nameKey = "FCQ_CHAIN_MA_ROBE_H", level = 15, faction = "Horde", races = races, quests = {
		{ q = 1959, from = starter, to = MA.anastasia },
		{ q = 1960, from = MA.anastasia, objs = {
			O(MA.cofferChestUC, "FCQ_OBJ_MA_COFFERCHEST", 2),
			O(MA.cofferChestUC, "FCQ_OBJ_MA_CANTATION", 3),
			O(MA.alchemist, "FCQ_OBJ_MA_COFFERS_H", 1),
		}, to = MA.anastasia },
		{ q = 1961, from = MA.anastasia, objs = { O(MA.manaGems, "FCQ_OBJ_MA_MANAGEMS", 2), O(nil, "FCQ_OBJ_MA_LINEN", 1) },
			to = MA.josef },
		{ q = 1962, from = MA.josef, to = MA.josef },
	} }
end
local function MaGarmentA(races, starter)
	return { key = "garment", nameKey = "FCQ_CHAIN_MA_GARMENT_A", level = 26, faction = "Alliance", races = races, quests = {
		{ q = 1939, from = starter, to = MA.andromath },
		{ q = 1938, from = MA.andromath, objs = { O(MA.treatise, "FCQ_OBJ_MA_TREATISE", 1) }, to = MA.andromath },
		{ q = 1940, from = MA.andromath, objs = { O(MA.spiderSilk, "FCQ_OBJ_MA_SILK", 1) }, to = MA.wynne },
		{ q = 1942, from = MA.wynne, to = MA.wynne },
	} }
end

CHAINS.MAGE = {
	MaFocus("Alliance", HUM, { { q = 1860, alt = { 1879 }, from = MA.zaldimar, to = MA.jennea }, MA_MIRROR }),
	MaFocus("Alliance", GNO, {
		{ q = 1879, alt = { 1860 }, from = MA.magis, to = MA.bink },
		{ q = 1880, alt = { 1861 }, from = MA.bink, objs = { O(MA.toolbox, "FCQ_OBJ_MA_GIZMONITOR", 1) }, to = MA.bink },
	}),
	-- Skyborne: NEW in Forever. The wand on Zephras Isle first (table order), Mirror Lake once they reach Stormwind
	-- (1860 is an optional Alliance pointer, not a gate: AllTheThings marks it a breadcrumb, M1 corrected 23 Nov 2026;
	-- Jennea gives 1861 without it: Polestar + AllTheThings, not seen in game).
	{ key = "windbough", nameKey = "FCQ_CHAIN_MA_WINDBOUGH", level = 10, faction = "Alliance", races = SKYBORNE, quests = {
		{ q = 93791, from = MA.anathamaas, to = MA.belann },
		{ q = 93797, from = MA.belann, objs = { O(MA.bough, "FCQ_OBJ_MA_BOUGH", 1) }, to = MA.belann },
	} },
	MaFocus("Alliance", SKYBORNE, { MA_MIRROR }),
	-- 1883 is a pointer from Orgrimmar; a Troll in Sen'jin takes 1884 straight from Un'Thuwa (Polestar).
	MaFocus("Horde", ORC, { { q = 1883, alt = { 1881 }, from = MA.uthelnay, to = MA.unthuwa }, MA_JUJU }),
	MaFocus("Horde", TROLL, { MA_JUJU }),
	MaFocus("Horde", UD, {
		{ q = 1881, alt = { 1883 }, from = MA.cain, to = MA.anastasia },
		{ q = 1882, alt = { 1884 }, from = MA.anastasia, objs = { O(MA.snapdragons, "FCQ_OBJ_MA_SNAPDRAGONS", 1) },
			to = MA.anastasia },
	}),
	MaRobeA(HUMSKY, MA.zaldimar),
	MaRobeA(GNO, MA.dink),
	MaRobeH(ORCTROLL, MA.uthelnay),
	MaRobeH(UD, MA.cain),
	MaGarmentA(HUMSKY, MA.jennea),
	MaGarmentA(GNO, MA.bink),
	{ key = "garment", nameKey = "FCQ_CHAIN_MA_GARMENT_H", level = 26, faction = "Horde", quests = {
		{ q = 1943, from = MA.anastasia, to = MA.deino },
		{ q = 1944, from = MA.deino, objs = { O(MA.xavian, "FCQ_OBJ_MA_XAVIAN", 1) }, to = MA.deino },
		{ q = 1945, from = MA.deino, objs = { O(MA.sisters, "FCQ_OBJ_MA_SISTERS", 1) }, to = MA.kilhala },
		{ q = 1946, from = MA.kilhala, to = MA.kilhala },
	} },
}
-- From level 30 every mage trainer hands out the pointer; the trainer per race is a choice (AFGELEID).
-- c = { faction, races, trainer (1947/1953), giver of Magecraft, librarian }
for _, c in ipairs({
	{ "Alliance", HUMSKY, MA.jennea, MA.maginor, MA.garion },
	{ "Alliance", GNO, MA.bink, MA.dink, MA.garion },
	{ "Horde", ORCTROLL, MA.deino, MA.uthelnay, MA.owen },
	{ "Horde", UD, MA.anastasia, MA.pierce, MA.owen },
}) do
	local faction, races, trainer, master, librarian = c[1], c[2], c[3], c[4], c[5]
	-- NEW in Forever. The librarian only offers 97286 after your first library book: e.wait says so. Study is a recipe in
	-- the Comprehension tab: whether the spell check sees it = NOT measured; the chain also ends once 97286 is done.
	-- low = true (18 Nov 2026, Rob via sparring: "Een studie, laten we inderdaad jouw advies volgen, lager zetten"):
	-- Study comes after every other class quest, and in "Do this now" as a tip after the to-dos, not on top.
	table.insert(CHAINS.MAGE, { key = "study", low = true, spell = 1302508, nameKey = "FCQ_CHAIN_MA_STUDY", level = 6, faction = faction,
		races = races, quests = {
			-- book = true (18 Nov 2026): first a library book, the arrow goes to the nearest one (BookStep).
			{ q = 97286, from = librarian, book = true, wait = "FCQ_WAIT_MA_BOOK", to = librarian },
		} })
	-- Items of Power runs beside 1949-1951 and Mage's Wand needs both: its own chain, BEFORE the wand chain (table order),
	-- open once 1947 is done. The sticks are no objective: one stick or the bramble in your bags counts (a limit).
	table.insert(CHAINS.MAGE, { key = "items", nameKey = "FCQ_CHAIN_MA_ITEMS", level = 30, needs = 1947, faction = faction,
		races = races, quests = {
			{ q = 1948, from = MA.tabetha, objs = {
				-- 10 sticks (Wowhead Forever 1948 "Witherbark Totem Stick x 10", GEMETEN 18 Nov 2026); before, 1 counted.
				O(MA.witherbark, "FCQ_OBJ_MA_STICKS", nil, { 7273, 7272 }, 10),
				O(MA.bramble, "FCQ_OBJ_MA_BRAMBLE", 2),
				O(nil, "FCQ_OBJ_MA_JADE", 1),
			}, to = MA.tabetha },
		} })
	table.insert(CHAINS.MAGE, { key = "wand", nameKey = "FCQ_CHAIN_MA_WAND", level = 30, faction = faction, races = races,
		quests = {
			{ q = 1947, from = trainer, to = MA.tabetha },
			{ q = 1949, from = MA.tabetha, to = MA.tirth },
			{ q = 1950, from = MA.tirth, objs = { O(MA.plucky, "FCQ_OBJ_MA_PLUCKY", 1) }, to = MA.tirth },
			{ q = 1951, from = MA.tirth, objs = { O(RO.sm, "FCQ_OBJ_MA_RITUALS", 1) }, to = MA.tabetha },
			-- Offered a few seconds after 1951 and 1948 are both handed in (Tabetha's ritual).
			{ q = 1952, from = MA.tabetha, wait = "FCQ_WAIT_MA_RITUAL", to = MA.tabetha },
		} })
	table.insert(CHAINS.MAGE, { key = "celestial", nameKey = "FCQ_CHAIN_MA_CELESTIAL", level = 35, faction = faction,
		races = races, quests = {
			{ q = 1953, from = trainer, to = MA.tabetha },
			{ q = 1954, from = MA.tabetha, objs = { O(MA.summoners, "FCQ_OBJ_MA_ORB", 1) }, to = MA.tabetha },
			-- No index on purpose (Wowhead shows two lines, Zygor says /1): waits until the client says complete.
			{ q = 1955, from = MA.tabetha, objs = { O(MA.demon, "FCQ_OBJ_MA_DEMON") }, to = MA.tabetha },
			{ q = 1956, from = MA.tabetha, objs = { O(MA.uldaman, "FCQ_OBJ_MA_POWERSOURCE", 1) }, to = MA.tabetha },
			{ q = 1957, from = MA.tabetha, objs = { O(MA.surges, "FCQ_OBJ_MA_SURGES", 1) }, to = MA.tabetha },
			{ q = 1958, from = MA.tabetha, to = MA.tabetha },
		} })
	-- NEW in Forever. Whether it needs Research Access first = NOT measured.
	table.insert(CHAINS.MAGE, { key = "spellbook", nameKey = "FCQ_CHAIN_MA_SPELLBOOK", level = 42, faction = faction,
		races = races, quests = {
			{ q = 82084, from = librarian, objs = {
				O(MA.owlbeasts, "FCQ_OBJ_MA_QUILL", 1),
				O(MA.zukkash, "FCQ_OBJ_MA_RESIN", 2),
				O(MA.zulfarrak, "FCQ_OBJ_MA_PAPYRUS", 3),
			}, to = librarian },
		} })
	-- Magecraft (50). 8253 pays Glacial Spike 20035 (Wowhead Forever; not in the local ItemSparse = no proof either way).
	table.insert(CHAINS.MAGE, { key = "magecraft", nameKey = "FCQ_CHAIN_MA_MAGECRAFT", level = 50, faction = faction,
		races = races, quests = {
			{ q = 8250, from = master, to = MA.sanath },
			{ q = 8251, from = RO.xylem, objs = { O(MA.dust, "FCQ_OBJ_MA_DUST", 1) }, to = RO.xylem },
			{ q = 8252, from = RO.xylem, objs = { O(MA.coral, "FCQ_OBJ_MA_CORAL", 1) }, to = RO.xylem },
			{ q = 8253, from = RO.xylem, objs = { O(P.sunken, "FCQ_OBJ_MA_SHARD", 1) }, to = RO.xylem },
		} })
	-- Conjure Water Rank 7 (60): the giver stands inside Dire Maul.
	table.insert(CHAINS.MAGE, { key = "water", spell = 10140, nameKey = "FCQ_CHAIN_MA_WATER", level = 60, faction = faction,
		races = races, quests = {
			{ q = 7463, from = MA.lydros, objs = { O(MA.dmEast, "FCQ_OBJ_MA_HYDROSPAWN", 1) }, to = MA.lydros },
		} })
	-- Polymorph: Pig (60). 90789 Scalebeard is NEW and shares its completion bit with 9362 Warlord Krellian: alt.
	table.insert(CHAINS.MAGE, { key = "pig", spell = 28272, nameKey = "FCQ_CHAIN_MA_PIG", level = 60, faction = faction,
		races = races, quests = {
			{ q = 90789, alt = { 9362 }, from = RO.xylem, objs = { O(MA.scalebeard, "FCQ_OBJ_MA_SHELL", 1) }, to = RO.xylem },
			{ q = 9364, from = RO.xylem, objs = { O(MA.coral, "FCQ_OBJ_MA_CLONES", 1) }, to = RO.xylem },
		} })
end

-- Weapon class quests (Rob via sparring: "Oh en 1 t/m 3 mag ook", 18 Nov 2026): data by mh-research (Fable) with
-- a source per line; second check: docs/forever/WAPENQUESTS_*_2026-11-18.md. Pasted here because the warlock
-- chains use MA/PA/RO places defined above. None seen in game.
local WQ_P = {
	-- Warrior, first weapon (level 10)
	thungrim = { npc = "Thun'grim Firegaze", id = 5878, m = 1413, x = 57.23, y = 30.34 }, -- ZY H 23551; WH-F spawn 57.2,30.2 (2)
	ironChest = { m = 1413, x = 55.05, y = 26.66 }, -- Stolen Iron Chest, object 58369: ZY H 23557; WH-F object 55.0,26.6; QF item 6534 (3)
	haggard = { npc = "Marshal Haggard", id = 294, m = 1429, x = 84.5, y = 69.4 }, -- WH-F spawns 84.4-84.6,69.2-69.6 (1 source)
	deadtooth = { m = 1429, x = 88.5, y = 79.3 }, -- Dead-Tooth Jack, npc 6093, level 11 normal: WH-F 12 spawns 86.2-89.6,78.0-80.6 (centre AFGELEID)
	strongbox = { m = 1429, x = 89.4, y = 79.0 }, -- Dead-tooth's Strongbox, object 85563: WH-F 89.3-89.5,78.9-79.0; QF item 6782 (2)
	tormus = { npc = "Tormus Deepforge", id = 6031, m = 1455, x = 48.6, y = 43.0 }, -- WH-F spawns 48.4-49.8,42.4-44.2 (1 source)
	ironband = { m = 1426, x = 77.9, y = 62.2 }, -- Ironband's Strongbox, object 85562: WH-F; QF item 6800 (2)
	eluniteCrates = { m = 1439, x = 31.9, y = 44.0 }, -- Crate of Elunite, object 86492: WH-F 16 spawns 31.1-33.1,42.4-46.6; QF item 6808 (2)
	shadeElura = { m = 1439, x = 31.5, y = 44.8 }, -- Shade of Elura, npc 6133, level 11 normal: WH-F; QF item 6809 (2)
	mathiel = { npc = "Mathiel", id = 6142, m = 1457, x = 59.2, y = 45.5 }, -- WH-F spawns 59.2,45.4-45.6 (1 source)
	coleman = { npc = "Coleman Farthing", id = 1500, m = 1420, x = 61.72, y = 52.29 }, -- ZY H 23588; WH-F 61.8,52.4-52.6 (2)
	rackAxe = { m = 1420, x = 51.70, y = 25.69 }, -- Agamand Weapon Rack 105169, ZY H 23608-23611 (1 source)
	rackSword = { m = 1420, x = 52.65, y = 25.86 }, -- rack 105170, ZY H 23614-23617
	rackMace = { m = 1420, x = 52.66, y = 27.04 }, -- rack 105172, ZY H 23596-23599
	rackDagger = { m = 1420, x = 51.89, y = 27.12 }, -- rack 105171, ZY H 23602-23605
	-- Warlock
	doan = { npc = "Doan Karhan", id = 6247, m = 1413, x = 49.2, y = 57.2 }, -- WH-F spawn; FQL 49.3,57.2 (2)
	menara = { npc = "Menara Voidrender", id = 6266, m = 1413, x = 62.5, y = 35.4 }, -- WH-F 62.4-62.6,35.4; FQL 62.5,35.5 (2)
	-- Acolyte Wytula (6254, Shard of a Felhound 4962) and Acolyte Magaz (6252, Shard of an Infernal 4963) stand on one
	-- spot: WH-F 62.6,35.2 for both; who gives which = QF (1 source). Used as an objective place only (no npc name).
	acolytes = { m = 1413, x = 62.6, y = 35.2 },
	-- Mannoroc Coven: Burning Blade Summoner 4668 (WH-F 19 spawns 50.2-53.0,72.1-84.2), Lesser Infernal 4676 (48-51,68-78),
	-- Mage Hunter 4681, a felhound (52-54,76-83). FQL says "80.3, 77.0" for the summoner: NOT used (conflicts with WH-F).
	mannoroc = { m = 1443, x = 51.5, y = 80.0 },
	rottingWood = { m = 1448, x = 46.89, y = 24.16 }, -- ZY A 24106 (more at 52.81,21.50); WH-F Withered Protector 7149 from 43.2,23.2 (2)
	bloodvenom = { m = 1448, x = 40.92, y = 46.83 }, -- ZY A 24101 (more at 41.93,49.75); WH-F Tainted Ooze 7092 38.4-40.2,48.2-56.6 (2)
	-- Shaman, The Tempest's Weapons
	rau = { npc = "Rau Cliffrunner", id = 4722, m = 1441, x = 46.0, y = 51.5 }, -- WH-F 46.0,51.4-51.6; FQL 46.1,51.7 (2)
	rfk = { m = 1413, x = 42.2, y = 89.8 }, -- Razorfen Kraul entrance: HN Entrances.lua (1 source)
	totemWater = { m = 1445, x = 57.4, y = 20.5 }, -- Mirefin Murloc 4359: WH-F 12 spawns 56.2-57.8,19.4-22.8 (centre AFGELEID)
	totemEarth = { m = 1435, x = 55.5, y = 28.5 }, -- Lost One Hunter 759 / Fisherman 757: WH-F 54.4-57.6,23.4-30.6 (centre AFGELEID)
	totemFire = { m = 1418, x = 26.2, y = 58.5 }, -- Dustbelcher Ogre 2701: WH-F first 12 of 56 spawns 25.4-27.2,56.1-62.0 (the list is sorted, so this is the WEST camp only; AFGELEID)
	totemAir = { m = 1443, x = 29.8, y = 54.5 }, -- Maraudine Mauler 4656: WH-F 29.0-30.5,52.0-60.8; guide "Valley of Spears ~31.7,57.4" (2)
	-- Ravaging Tempest 216474: WH-F 5 spawns 36.7-37.5,37.9-41.4 (centre AFGELEID; a 6th, 54.0,41.2, is the old Season of
	-- Discovery ledge). The steam pools = Scalding/Boiling Elemental 10756/10757, WH-F 32.4-40.6,32.4-39.8; lfcarry
	-- (16 Nov): "beneath Darkcloud Pinnacle". FQL "31.0,45.8" NOT used (conflicts with WH-F; second check 18 Nov).
	steamPools = { m = 1441, x = 36.8, y = 39.2 },
}
local Q = WQ_P

--------------------------------------------------------------------------------
-- WARRIOR: the first weapon (level 10), one route per starting zone. Opens after that route's Defensive Stance quest
-- (prequest: QF preQuestSingle + SP prev, 2 sources). Min level 10 (QF). Race masks: whole faction (QF + SP), the split
-- by starting zone is the same choice as WrDefense. Rewards = choose 1 of 4, item level 15, no level requirement
-- (WH-Fp names + DB2 ids): GEMETEN. No elite, no group (WH-F: Dead-Tooth Jack and Shade of Elura level 11 normal).
-- Skyborne: no weapon follow-up found after 94003 (SP lists only 92532 + 94003 for them): not built.
--------------------------------------------------------------------------------
local function WrFirstWeapon(faction, races, needs, quests)
	return { key = "firstweapon", nameKey = "FCQ_CHAIN_WR_FIRSTWEAPON", level = 10, needs = needs, faction = faction,
		races = races, quests = quests }
end
-- Human: reward of 1667 = Haggard's Axe 6979 / Hammer 6983 / Dagger 6980 / Sword 6985 (WH-Fp 1667, DB2).
table.insert(CHAINS.WARRIOR, WrFirstWeapon("Alliance", HUM, 1665, {
	{ q = 1666, from = R.harry, to = Q.haggard }, -- QF start 6089 end 294, pre 1665; SP prev 1665, ender 294 (2)
	-- 1667: WH-F lists "Marshal Haggard's Badge" and "Dead-tooth's Key". QF: only the badge (6782, from the strongbox)
	-- is an objective; the key 6783 drops from Dead-Tooth Jack 6093 and is a required source item. That the key opens
	-- the strongbox = AFGELEID. The key step counts as done with the key OR the badge in your bags.
	{ q = 1667, from = Q.haggard, objs = {
		O(Q.deadtooth, "FCQ_OBJ_WR_DEADTOOTH_KEY", nil, { 6783, 6782 }),
		O(Q.strongbox, "FCQ_OBJ_WR_HAGGARD_BADGE", 1),
	}, to = Q.haggard }, -- QF start/end 294, pre 1666; SP prev 1666 (2)
}))
-- Dwarf/Gnome: reward of 1682 = Umbral Axe 6978 / Mace 6982 / Dagger 6981 / Sword 6984 (WH-Fp 1682, DB2).
table.insert(CHAINS.WARRIOR, WrFirstWeapon("Alliance", DWGN, 1678, {
	{ q = 1680, from = R.muren, to = Q.tormus }, -- QF start 6114 end 6031, pre 1678; SP prev 1678, ender 6031 (2)
	{ q = 1681, from = Q.tormus, objs = { O(Q.ironband, "FCQ_OBJ_WR_UMBRAL_ORE", 1) }, to = Q.tormus }, -- WH-F "Umbral Ore"; QF item 6800 ← object 85562
	{ q = 1682, from = Q.tormus, to = Q.tormus }, -- QF pre 1681; SP prev 1681 (2); no objective (WH-F)
}))
-- Night Elf: reward of 1693 = Elunite Axe 6966 / Hammer 6968 / Dagger 6969 / Sword 6967 (WH-Fp 1693, DB2).
table.insert(CHAINS.WARRIOR, WrFirstWeapon("Alliance", NELF, 1683, {
	-- WH-F: "Elunite Ore x 8" (line 1), "Elura's Medallion" (line 2). QF: ore 6808 ← Crate of Elunite 86492, medallion
	-- 6809 ← Shade of Elura 6133. The crates lie off the Darkshore coast (x 31-33 is west of Auberdine): under water = AFGELEID.
	{ q = 1686, from = R.elanaria, objs = {
		O(Q.eluniteCrates, "FCQ_OBJ_WR_ELUNITE_ORE", 1),
		O(Q.shadeElura, "FCQ_OBJ_WR_ELURA_MEDALLION", 2),
	}, to = R.elanaria }, -- QF start/end 4088, pre 1683; SP prev 1683 (2)
	{ q = 1692, from = R.elanaria, to = Q.mathiel }, -- QF start 4088 end 6142, pre 1686; SP prev 1686, ender 6142 (2); you carry the Case of Elunite 6812
	{ q = 1693, from = Q.mathiel, to = Q.mathiel }, -- QF pre 1692; SP prev 1692 (2)
}))
-- Orc, Troll, Tauren (all via Uzzek): reward of 1503 = Thun'grim's Axe 7326 / Mace 7328 / Dagger 7327 / Sword 7329
-- (WH-Fp 1503 + series "Veteran Uzzek, Path of Defense, Thun'grim Firegaze, Forged Steel"; DB2).
table.insert(CHAINS.WARRIOR, WrFirstWeapon("Horde", { Orc = true, Troll = true, Tauren = true }, 1498, {
	{ q = 1502, from = R.uzzek, to = Q.thungrim }, -- QF start 5810 end 5878, pre 1498; SP prev 1498, ender 5878; ZY H 23546-23551 (3)
	{ q = 1503, from = Q.thungrim, objs = { O(Q.ironChest, "FCQ_OBJ_WR_STEEL_BARS", 1) }, to = Q.thungrim }, -- ZY H 23552-23562; QF item 6534 ← object 58369 (2)
}))
-- Undead: reward of 1822 = Heirloom Axe 7115 / Hammer 7117 / Dagger 7116 / Sword 7118 (WH-Fp 1822, DB2).
table.insert(CHAINS.WARRIOR, WrFirstWeapon("Horde", UD, 1819, {
	{ q = 1820, from = R.dillinger, to = Q.coleman }, -- QF start 1496 end 1500, pre 1819; SP prev 1819, ender 1500; ZY H 23582-23588 (3)
	-- Four weapon racks in the crypt at Agamand Mills (ZY: crypt door 52.25,26.86). Index = WH-F line order: 1 Axe,
	-- 2 Dagger, 3 Mace, 4 Sword (= QF 7567, 7568, 7569, 7566). Zygor's "sword /1" is a Zygor mistake (already noted in
	-- the file header). Asked in walking order (axe and sword in the back, mace and dagger in front: AFGELEID from x/y).
	{ q = 1821, from = Q.coleman, objs = {
		O(Q.rackMace, "FCQ_OBJ_WR_AGAMAND_MACE", 3),
		O(Q.rackDagger, "FCQ_OBJ_WR_AGAMAND_DAGGER", 2),
		O(Q.rackAxe, "FCQ_OBJ_WR_AGAMAND_AXE", 1),
		O(Q.rackSword, "FCQ_OBJ_WR_AGAMAND_SWORD", 4),
	}, to = Q.coleman }, -- QF pre 1820; SP prev 1820; ZY H 23589-23624 (3)
	{ q = 1822, from = Q.coleman, to = Q.coleman }, -- QF pre 1821; SP prev 1821, ender 1500 (2); not in Zygor
}))

--------------------------------------------------------------------------------
-- WARLOCK
--------------------------------------------------------------------------------
-- The Orb of Soran'ruk (min level 20, quest level 25: QF + FQL + WH-F "Level 25"). One quest, both factions, no
-- prequest (QF, FQL "Previous quest: none listed"; SP has no prev). Reward: choose Orb of Soran'ruk 6898 (off-hand,
-- +9 fire/+9 shadow) or Staff of Soran'ruk 15109 (WH-Fp 1740, FQL, DB2; tooltips WH-F). Both objectives are in
-- dungeons: Twilight Acolyte 4809 in Blackfathom Deeps (3 fragments), Shadowfang Darksoul 3855 in Shadowfang Keep
-- (1 large fragment; FQL shows 20% drop: 1 source). Entrances reuse PA.bfd and RO.sfk (already in the file).
for _, faction in ipairs({ "Alliance", "Horde" }) do
	table.insert(CHAINS.WARLOCK, { key = "soranruk", nameKey = "FCQ_CHAIN_WL_SORANRUK", level = 20, faction = faction, quests = {
		{ q = 1740, from = Q.doan, objs = {
			O(PA.bfd, "FCQ_OBJ_WL_SORANRUK_FRAGMENTS", 1), -- WH-F "Soran'ruk Fragment x 3"; QF item 6914 ← npc 4809; FQL (3)
			O(RO.sfk, "FCQ_OBJ_WL_SORANRUK_LARGE", 2), -- WH-F "Large Soran'ruk Fragment"; QF item 6915 ← npc 3855; FQL (3)
		}, to = Q.doan }, -- QF start/end 6247; FQL start/end Doan Karhan (2)
	} })
end

-- The Orb of Orahil (min level 35, quest level 40: QF + FQL). Order (QF pre/next + SP prev + FQL "step 2 of 5"):
--   Knowledge of the Orb of Orahil (a pointer from a demon trainer: 4965 Briarthorn/Ironforge, 4968 Demisette Cloyce/
--   Stormwind, 4967 Zevrost/Orgrimmar, 4969 Kaal Soulreaper/Undercity; they exclude each other, QF exclusiveTo)
--   → 1799 Fragments of the Orb of Orahil (Menara → Tabetha) → 4961 Cleansing of the Orb (Tabetha: Demon of the Orb,
--   npc 6549, level 40 ELITE, WH-F) → 4976 Returning the Cleansed Orb (Tabetha → Menara) → the finished item.
--   Side by side with 1799 you take ONE of two shard quests from Menara's acolytes (they exclude each other, QF):
--     4962 Shard of a Felhound  → 4964 The Completed Orb of Dar'Orahil: Orb 15108 (shadow) or Staff 15106
--     4963 Shard of an Infernal → 4975 The Completed Orb of Noh'Orahil: Orb 15107 (fire) or Staff 15105
--   (which shard leads to which orb: SP prev 4964←4962, 4975←4963; rewards WH-Fp + DB2; shadow/fire from WH-F tooltips).
-- The shard quest is no step of its own (the engine has no "either of two side quests"): it is asked INSIDE 1799 with
-- item checks, in the order you walk: the gem (Felhas Ruby 12647 / Infus Emerald 12646) in your bags = path chosen;
-- an Imprisoned Spirit (12648 / 12649) in your bags = gem used. Second check 18 Nov: these are `pre` steps with
-- `unlessDone` (the shard quest handed in = done), not `objs`: objs are skipped once 1799 is complete (its only
-- objective is the Infernal Orb), so a player who loots the orb first never saw them and left Desolace without a spirit.
-- The gem: use it when the demon is close to dying (WH-F 4962/4963 description, GEMETEN 18 Nov 2026).
-- NOT measured: whether 1799 needs the pointer quest
-- (QF: no prequest; SP: prev 4965). Race masks: QF has 4967/4968 swapped (it gives 4967 from Zevrost in Orgrimmar an
-- Alliance mask); SP says 4965 + 4968 Alliance, 4967 + 4969 Horde, which matches where the givers stand: SP followed.
-- Which trainer per race = AFGELEID (same split as the Felsteed starters).
local function WlOrahil(faction, races, q, alt, trainer)
	return { key = "orahil", nameKey = "FCQ_CHAIN_WL_ORAHIL", level = 35, faction = faction, races = races, quests = {
		{ q = q, alt = alt, from = trainer, to = Q.menara }, -- QF start 5172/461/3326/4563, end 6266; SP ender 6266 (2)
		{ q = 1799, from = Q.menara,
			pre = {
				{ items = { 12647, 12646, 12648, 12649 }, place = Q.acolytes, textKey = "FCQ_OBJ_WL_ORAHIL_PATH", unlessDone = { 4962, 4963 } }, -- QF 4962 start 6254 (ruby 12647), 4963 start 6252 (emerald 12646)
				{ items = { 12648, 12649 }, place = Q.mannoroc, textKey = "FCQ_OBJ_WL_ORAHIL_SPIRIT", unlessDone = { 4962, 4963 } }, -- WH-F 4962/4963
			},
			objs = { O(Q.mannoroc, "FCQ_OBJ_WL_INFERNAL_ORB", 1) }, -- WH-F "Infernal Orb"; QF item 7291 ← Burning Blade Summoner 4668; FQL (3)
			to = MA.tabetha }, -- QF start 6266 end 6546; SP ender 6546; FQL (3)
		{ q = 4961, from = MA.tabetha, objs = { O(MA.demon, "FCQ_OBJ_WL_ORB_DEMON", 1) }, to = MA.tabetha }, -- QF pre 1799, kill 6549; SP prev 1799; WH-F "Level 40" (3)
		{ q = 4976, from = MA.tabetha, to = Q.menara }, -- QF start 6546 end 6266, pre 4961; SP prev 4961, ender 6266 (2)
		-- One step for both endings: the objective is "Wait for Menara Voidrender to complete your item" (WH-F).
		{ q = 4964, alt = { 4975 }, from = Q.menara, to = Q.menara }, -- QF pre 4976, exclusive to each other (1 source for the prequest)
	} }
end
table.insert(CHAINS.WARLOCK, WlOrahil("Alliance", HUM, 4968, { 4965 }, W.demisette))
table.insert(CHAINS.WARLOCK, WlOrahil("Alliance", GNO, 4965, { 4968 }, W.briarthorn))
table.insert(CHAINS.WARLOCK, WlOrahil("Horde", ORCTROLL, 4967, { 4969 }, W.zevrost))
table.insert(CHAINS.WARLOCK, WlOrahil("Horde", UD, 4969, { 4967 }, W.kaal))

-- An Imp's Request (min level 50, quest level 52: QF; WH-F "Level 52" on 8422): the warlock's Sunken Temple round, the
-- only class that was still missing. 8419 comes from a warlock trainer (QF starters 461, 988, 3324-3326, 4563-4565,
-- 5171, 5173, 5495, 5496; ZY: Demisette Cloyce in Stormwind, Zevrost in Orgrimmar); 8420 Hot and Itchy is the same
-- quest straight from Impsy (they exclude each other, QF) = alt. 8421 needs 8419 or 8420 (QF); 8422 needs 8421.
-- The trainer comes first on purpose: you need 1 Felcloth BEFORE the trip to Felwood, and with the quest in your log
-- the step says so. Reward of 8422: choose Soul Harvester 20536 (staff, item level 52), Abyss Shard 20534 (trinket)
-- or Robes of Servitude 20530 (WH-Fp 8422 + WH-F item tooltips; the three are missing from ItemSparse 70959, which
-- proves nothing: hotfix items, like Glacial Spike). Briarthorn (5172) is NOT in QF's starter list: Gnomes go to
-- Demisette too. Kaal Soulreaper (4563) is in the list: Undead start there.
local function WlImpRequest(faction, races, trainer)
	return { key = "imprequest", nameKey = "FCQ_CHAIN_WL_IMPREQUEST", level = 50, faction = faction, races = races, quests = {
		{ q = 8419, alt = { 8420 }, from = trainer, objs = { O(nil, "FCQ_OBJ_WL_FELCLOTH", 1) }, to = W.impsy }, -- WH-F "Felcloth" (14256); QF end 14470; SP ender 14470; ZY A 24079-24097 (3)
		{ q = 8421, from = W.impsy, objs = {
			O(Q.rottingWood, "FCQ_OBJ_WL_ROTTING_WOOD", 1), -- WH-F "Rotting Wood x 10"; QF 20613 ← npcs 7138, 7139, 7149; ZY "8421/1" (3)
			O(Q.bloodvenom, "FCQ_OBJ_WL_BLOODVENOM", 2), -- WH-F "Bloodvenom Essence x 4"; QF 20614 ← Tainted Ooze 7092; ZY "8421/2" (3)
		}, to = W.impsy },
		-- 2 of each feather (WH-F 8422 "x 2" three times; ZY "collect 2"). The warrior texts already say "get 2 …".
		{ q = 8422, from = W.impsy, objs = {
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_AMBER", 1),
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_BLUE", 2),
			O(P.sunken, "FCQ_OBJ_WR_FEATHER_GREEN", 3),
		}, to = W.impsy }, -- QF pre 8421; SP prev 8421; ZY A 24153-24175 (3)
	} }
end
table.insert(CHAINS.WARLOCK, WlImpRequest("Alliance", nil, W.demisette))
table.insert(CHAINS.WARLOCK, WlImpRequest("Horde", ORCTROLL, W.zevrost))
table.insert(CHAINS.WARLOCK, WlImpRequest("Horde", UD, W.kaal))

--------------------------------------------------------------------------------
-- SHAMAN: The Tempest's Weapons (NEW in Forever). Min level 30 on every step (QF + FQL + guides); quest levels 33
-- (Elemental Aid, a dungeon), 38 (totems), 40 (ritual, ELITE). Reward of the last quest (WH-Fp 79442, raw page text):
-- choose Lightning's Grasp 280607 (fist), Tidebringer's Claw 280605 (fist) or Rage of the Storm 280604 (two-handed
-- mace), "you will also receive" Elementalist's Guard 280696 (shield) and, on the Horde page, a Rune of the Storm
-- (a Season of Discovery leftover per foreverwisp). Ids: DB2 ItemSparse 70959 + QF. FQL shows only Rage of the Storm
-- for 79442: conflict, Wowhead followed.
-- ALLIANCE (Dwarf): every step from Veyric Thunderhame (QF, FQL 96135, 4 guides): solid.
-- HORDE: the sources DISAGREE on who gives and takes each step (QF and FQL list Rau Cliffrunner, Prate Cloudseer AND
--   Bath'rah; three guides say "follow your quest log"). Built here: the NPC that the quest's own objective text names
--   (GEMETEN: 79364 "Speak with Prate Cloudseer", 79361 "for Prate Cloudseer", 79442 "to Bath'rah"), Rau for the rest
--   (FQL primary start/end; wowforeversite.wiki 16 Nov). 79360 hand-in: Rau (FQL, wiki) or Bath'rah (QF, lfcarry) =
--   NOT settled. 79365 With Wind Beneath Your Wings (Bath'rah → Rau, FQL; not in the Wowhead series) is left out.
--   → TESTLIJST: a Horde shaman must check every "hand in to" of this chain in game.
-- Races, Horde: QF and FQL list only Orc, Tauren, Troll on 79361 and 79442 (lfcarry says Windshapers do the chain too):
--   Skyborne was first NOT built (silence beats a wrong trip, as with WL_ORC). 19 Nov 2026: Rob chose to show it —
--   Skyborne is now in the Horde chain's races below (no MyChains change needed).
-- Prequest: Call of Air (Alliance 94789 = needs; Horde has three ids 1531/1532/96136, so no `needs`: the Air chain
--   stands earlier in the table at the same level and is shown first). That Call of Air is required: Wowhead comment
--   (beta) + 3 guides; AFGELEID for the live game.
-- Totem order = WH-F lines: 1 Water, 2 Earth, 3 Fire, 4 Air (QF items 274046, 274045, 274044, 274047). Mobs are level
--   34-42 (guides), far above 30. Drop lists: QF (older) has only Stonevault troggs for Fire; three guides (Blizzard notes
--   of 8 Oct 2026) add Dustbelcher ogres, Murdaloc, Maraudine Scouts and Ongeku.
--------------------------------------------------------------------------------
local SH_TWISTED = {
	O(Q.totemWater, "FCQ_OBJ_SH_TWISTED_WATER", 1), -- QF 274046 ← Mirefin 4358-4363; guides: Dustwallow Marsh NE coast
	O(Q.totemEarth, "FCQ_OBJ_SH_TWISTED_EARTH", 2), -- QF 274045 ← Lost Ones 755-763, 1106; guides: Swamp of Sorrows
	O(Q.totemFire, "FCQ_OBJ_SH_TWISTED_FIRE", 3), -- QF 274044 ← Stonevault 2891, 2893, 2894 (WH-F Bonesnapper 47.2-49.4,63.7-71.8); guides: + Dustbelcher ogres
	O(Q.totemAir, "FCQ_OBJ_SH_TWISTED_AIR", 4), -- QF 274047 ← Maraudine 4655-4659, 4704; guides: Desolace, Valley of Spears
}
-- The ritual: "the steam pools" in Thousand Needles (quest text, WH-Fp 96135). Wowhead comments (96135): a small blue
-- summoning circle in the southern part with a bag on top; four waves of two elementals, then a quilboar and the elite
-- Ravaging Tempest (level 40, FQL; "38-40", conquestcapped); "kill the water elemental within a few yards of the
-- circle or it will not give you credit". The Eye of the Tempest 212792 drops from Ravaging Tempest (WH-F item
-- tooltip, 100%); multi-drop since the 8 Oct notes (3 guides). Click the bag vs. use the Corrupted Totems 268582 from
-- your bags: the sources differ, the text names both.
table.insert(CHAINS.SHAMAN, { key = "tempest", nameKey = "FCQ_CHAIN_SH_TEMPEST", level = 30, needs = 94789,
	faction = "Alliance", races = DWARF, quests = {
		{ q = 96264, from = S.veyric, objs = { O(Q.rfk, "FCQ_OBJ_SH_TATTERED_NOTE", 1) }, to = S.veyric }, -- QF start/end 259023; WH-F "Tattered Note" (274463 ← Charlga Razorflank 4421, QF); guides (3)
		{ q = 79358, from = S.veyric, objs = SH_TWISTED, to = S.veyric }, -- WH-F "… for Veyric Thunderhame in Arathi Highlands"; QF start 259023 (its end "4722" is not followed); guides (3)
		{ q = 96135, from = S.veyric, objs = { O(Q.steamPools, "FCQ_OBJ_SH_TEMPEST_RITUAL", 1) }, to = S.veyric }, -- QF + FQL start/end Veyric (2)
		{ q = 96016, from = S.veyric, to = R.bathrah }, -- QF end 6176; WH-F "Deliver the Eye of the Tempest to Bath'rah"; guides (3). Giver Veyric: guides (QF has no starter)
	} })
-- 19 Nov 2026 (Rob via sparring, letterlijk: "Ja, die mogen door" on the advice to let the Windshaper see it): Skyborne
-- added (lfcarry: Windshapers do this chain; QF/FQL list only Orc/Tauren/Troll on 79361/79442 — a source conflict, Rob
-- chose to show it). RaceToken() folds both Skyborne races into "Skyborne"; faction = "Horde" keeps High Order out.
-- If a Windshaper cannot take a step in game: TESTLIJST, and back out "Skyborne" here.
table.insert(CHAINS.SHAMAN, { key = "tempest", nameKey = "FCQ_CHAIN_SH_TEMPEST", level = 30, faction = "Horde",
	races = { Orc = true, Tauren = true, Troll = true, Skyborne = true }, quests = {
		{ q = 79360, from = S.prate, objs = { O(Q.rfk, "FCQ_OBJ_SH_TATTERED_NOTE", 1) }, to = Q.rau }, -- giver: QF 4722 + 5905, Wowhead comment "same person as Call of Air"; hand-in Rau (FQL, wiki) or Bath'rah (QF, lfcarry): NOT settled
		{ q = 79364, from = Q.rau, to = S.prate }, -- WH-F "Speak with Prate Cloudseer"; FQL start Rau, end Prate; QF also lists Bath'rah (2)
		{ q = 79361, from = S.prate, objs = SH_TWISTED, to = S.prate }, -- WH-F "… for Prate Cloudseer in Thousand Needles"; FQL start/end Prate; QF says Bath'rah (2 vs 1)
		{ q = 79366, from = S.prate, objs = { O(Q.steamPools, "FCQ_OBJ_SH_TEMPEST_RITUAL", 1) }, to = Q.rau }, -- hand-in Rau: QF + FQL + wiki (3). Giver: FQL lists Rau and Prate, QF Rau; Prate = where you hand in the totems (AFGELEID)
		{ q = 79442, from = Q.rau, to = R.bathrah }, -- QF + FQL start Rau, end Bath'rah; WH-F objective (3)
	} })

--

--------------------------------------------------------------------------------
-- The level 1 notes (Rob 22 Nov 2026 via sparring, verbatim: "b"): the quest that sends a new character to the class
-- trainer. All 56 class/race combinations of CharBaseInfo 71037; Skyborne have theirs at level 2. A note opens once
-- one quest of the same giver is handed in (needs): Zygor's order 52 of 52, Spoken prev 45 and 7 silent. It teaches
-- no spell, so it never comes before a spell chain, and a skipped one is shown up to level 5 (AFGELEID: the valleys
-- are 1-5, their trainers stop at 6). intro: the note is also the first step of a spell chain, so as a note it only
-- shows until that chain starts. Not seen in game. Places: Rob measured > this module > Zygor; nothing new from
-- HandyNotes_ClassTrainers (All Rights Reserved). Full table: docs/forever/CLASS_NOTES_2026-11-22.md.
--------------------------------------------------------------------------------
do -- a block of its own: Lua allows 200 locals in the main chunk
	local LAST = 5
	local N = {
		[197] = { npc = "Marshal McBride", id = 197, m = 1429, x = 48.92, y = 41.61 },
		[198] = { npc = "Khelden Bremen", id = 198, m = 1429, x = 49.66, y = 39.41 },
		[895] = { npc = "Thorgas Grimson", id = 895, m = 1426, x = 29.18, y = 67.46 },
		[911] = { npc = "Llane Beshere", id = 911, m = 1429, x = 50.24, y = 42.29 },
		[912] = { npc = "Thran Khorman", id = 912, m = 1426, x = 28.83, y = 67.24 },
		[915] = { npc = "Jorik Kerridan", id = 915, m = 1429, x = 50.31, y = 39.92 },
		[916] = { npc = "Solm Hargrin", id = 916, m = 1426, x = 28.37, y = 67.51 },
		[925] = { npc = "Brother Sammuel", id = 925, m = 1429, x = 50.43, y = 42.13 },
		[926] = { npc = "Bromos Grummner", id = 926, m = 1426, x = 28.83, y = 68.33 },
		[944] = { npc = "Marryk Nurribit", id = 944, m = 1426, x = 28.71, y = 66.36 },
		[2079] = { npc = "Conservator Ilthalaine", id = 2079, m = 1438, x = 58.70, y = 44.27 },
		[2119] = { npc = "Dannal Stern", id = 2119, m = 1420, x = 32.69, y = 65.56 },
		[2122] = { npc = "David Trias", id = 2122, m = 1420, x = 32.53, y = 65.65 },
		[2124] = { npc = "Isabella", id = 2124, m = 1420, x = 30.94, y = 66.06 },
		[2126] = { npc = "Maximillion", id = 2126, m = 1420, x = 30.91, y = 66.34 },
		[2980] = { npc = "Grull Hawkwind", id = 2980, m = 1412, x = 44.47, y = 77.51 },
		[3059] = { npc = "Harutt Thunderhorn", id = 3059, m = 1412, x = 43.75, y = 76.72 },
		[3060] = { npc = "Gart Mistrunner", id = 3060, m = 1412, x = 44.65, y = 76.56 },
		[3061] = { npc = "Lanka Farshot", id = 3061, m = 1412, x = 43.96, y = 76.36 },
		[3062] = { npc = "Meela Dawnstrider", id = 3062, m = 1412, x = 44.58, y = 76.56 },
		[3143] = { npc = "Gornek", id = 3143, m = 1411, x = 42.06, y = 68.33 },
		[3153] = { npc = "Frang", id = 3153, m = 1411, x = 42.89, y = 69.43 },
		[3154] = { npc = "Jen'shan", id = 3154, m = 1411, x = 42.84, y = 69.32 },
		[3155] = { npc = "Rwag", id = 3155, m = 1411, x = 41.28, y = 68.00 },
		[3156] = { npc = "Nartok", id = 3156, m = 1411, x = 40.65, y = 68.51 },
		[3157] = { npc = "Shikrik", id = 3157, m = 1411, x = 42.39, y = 69.00 },
		[3593] = { npc = "Alyissia", id = 3593, m = 1438, x = 59.64, y = 38.44 },
		[3594] = { npc = "Frahun Shadewhisper", id = 3594, m = 1438, x = 59.64, y = 38.66 },
		[3596] = { npc = "Ayanna Everstride", id = 3596, m = 1438, x = 58.65, y = 40.45 },
		[3597] = { npc = "Mardant Strongoak", id = 3597, m = 1438, x = 58.63, y = 40.29 },
		[5884] = { npc = "Mai'ah", id = 5884, m = 1411, x = 42.51, y = 69.04 },
		[248415] = { npc = "Tordrin Sternblade", id = 248415, m = 1429, x = 51.21, y = 40.81 },
		[251373] = { npc = "Xyton Silverwind", id = 251373, m = 2521, x = 41.66, y = 23.33 },
		[251376] = { npc = "Tai'ree Farsight", id = 251376, m = 2521, x = 42.47, y = 23.73 },
		[251379] = { npc = "Dorii Brightwhisper", id = 251379, m = 2521, x = 41.54, y = 23.68 },
		[251389] = { npc = "Akeri Duskblade", id = 251389, m = 2521, x = 43.75, y = 24.35 },
		[251964] = { npc = "Blademaster Ren", id = 251964, m = 2521, x = 43.65, y = 24.13 },
	}
	for _, p in pairs(N) do
		p.z = true -- every place in this table is Zygor's
	end
	local function note(class, faction, race, q, gate, level, from, to, before)
		table.insert(CHAINS[class], { key = "note", note = true, intro = before ~= nil, last = before or LAST, needs = gate,
			level = level, faction = faction, races = { [race] = true }, quests = { { q = q, from = from, to = to } } })
	end
	note("HUNTER", "Alliance", "Human", 92479, 7, 1, N[197], N[248415]) -- A Scribbled Letter
	note("MAGE", "Alliance", "Human", 3104, 7, 1, N[197], N[198]) -- Glyphic Letter
	note("PALADIN", "Alliance", "Human", 3101, 7, 1, N[197], N[925]) -- Consecrated Letter
	note("PRIEST", "Alliance", "Human", 3103, 7, 1, N[197], PR_P.anetta) -- Hallowed Letter
	note("ROGUE", "Alliance", "Human", 3102, 7, 1, N[197], N[915]) -- Encrypted Letter
	note("WARLOCK", "Alliance", "Human", 3105, 7, 1, N[197], WL_P.drusilla) -- Tainted Letter
	note("WARRIOR", "Alliance", "Human", 3100, 7, 1, N[197], N[911]) -- Simple Letter
	note("HUNTER", "Alliance", "Dwarf", 3108, 179, 1, SH_P.sten, N[895]) -- Etched Rune
	note("PALADIN", "Alliance", "Dwarf", 3107, 179, 1, SH_P.sten, N[926]) -- Consecrated Rune
	note("PRIEST", "Alliance", "Dwarf", 3110, 179, 1, SH_P.sten, PR_P.branstock) -- Hallowed Rune
	note("ROGUE", "Alliance", "Dwarf", 3109, 179, 1, SH_P.sten, N[916]) -- Encrypted Rune
	note("SHAMAN", "Alliance", "Dwarf", 98581, 179, 1, SH_P.sten, SH_P.teo, 3) -- Archaic Rune
	note("WARRIOR", "Alliance", "Dwarf", 3106, 179, 1, SH_P.sten, N[912]) -- Simple Rune
	note("MAGE", "Alliance", "Gnome", 3114, 179, 1, SH_P.sten, N[944]) -- Glyphic Memorandum
	note("PRIEST", "Alliance", "Gnome", 98574, 179, 1, SH_P.sten, PR_P.branstock) -- Hallowed Memorandum
	note("ROGUE", "Alliance", "Gnome", 3113, 179, 1, SH_P.sten, N[916]) -- Encrypted Memorandum
	note("WARLOCK", "Alliance", "Gnome", 3115, 179, 1, SH_P.sten, WL_P.alamar) -- Tainted Memorandum
	note("WARRIOR", "Alliance", "Gnome", 3112, 179, 1, SH_P.sten, N[912]) -- Simple Memorandum
	note("DRUID", "Alliance", "NightElf", 3120, 456, 1, N[2079], N[3597]) -- Verdant Sigil
	note("HUNTER", "Alliance", "NightElf", 3117, 456, 1, N[2079], N[3596]) -- Etched Sigil
	note("PRIEST", "Alliance", "NightElf", 3119, 456, 1, N[2079], PR_P.shanda) -- Hallowed Sigil
	note("ROGUE", "Alliance", "NightElf", 3118, 456, 1, N[2079], N[3594]) -- Encrypted Sigil
	note("WARRIOR", "Alliance", "NightElf", 3116, 456, 1, N[2079], N[3593]) -- Simple Sigil
	note("HUNTER", "Horde", "Orc", 3087, 788, 1, N[3143], N[3154]) -- Etched Parchment
	note("MAGE", "Horde", "Orc", 98576, 788, 1, N[3143], N[5884]) -- Glyphic Parchment
	note("ROGUE", "Horde", "Orc", 3088, 788, 1, N[3143], N[3155]) -- Encrypted Parchment
	note("SHAMAN", "Horde", "Orc", 3089, 788, 1, N[3143], N[3157]) -- Rune-Inscribed Parchment
	note("WARLOCK", "Horde", "Orc", 3090, 788, 1, N[3143], N[3156]) -- Tainted Parchment
	note("WARRIOR", "Horde", "Orc", 2383, 788, 1, N[3143], N[3153]) -- Simple Parchment
	note("HUNTER", "Horde", "Troll", 3082, 788, 1, N[3143], N[3154]) -- Etched Tablet
	note("MAGE", "Horde", "Troll", 3086, 788, 1, N[3143], N[5884]) -- Glyphic Tablet
	note("PRIEST", "Horde", "Troll", 3085, 788, 1, N[3143], PR_P.kenjai) -- Hallowed Tablet
	note("ROGUE", "Horde", "Troll", 3083, 788, 1, N[3143], N[3155]) -- Encrypted Tablet
	note("SHAMAN", "Horde", "Troll", 3084, 788, 1, N[3143], N[3157]) -- Rune-Inscribed Tablet
	note("WARLOCK", "Horde", "Troll", 98575, 788, 1, N[3143], N[3156]) -- Tainted Tablet
	note("WARRIOR", "Horde", "Troll", 3065, 788, 1, N[3143], N[3153]) -- Simple Tablet
	note("DRUID", "Horde", "Tauren", 3094, 747, 1, N[2980], N[3060]) -- Verdant Note
	note("HUNTER", "Horde", "Tauren", 3092, 747, 1, N[2980], N[3061]) -- Etched Note
	note("SHAMAN", "Horde", "Tauren", 3093, 747, 1, N[2980], N[3062]) -- Rune-Inscribed Note
	note("WARRIOR", "Horde", "Tauren", 3091, 747, 1, N[2980], N[3059]) -- Simple Note
	note("MAGE", "Horde", "Scourge", 3098, 364, 1, PA_P.sarvis, N[2124]) -- Glyphic Scroll
	note("PALADIN", "Horde", "Scourge", 98601, 364, 1, PA_P.sarvis, PA_P.aramis, 1) -- A Difficult Path
	note("PRIEST", "Horde", "Scourge", 3097, 364, 1, PA_P.sarvis, PR_P.duesten) -- Hallowed Scroll
	note("ROGUE", "Horde", "Scourge", 3096, 364, 1, PA_P.sarvis, N[2122]) -- Encrypted Scroll
	note("WARLOCK", "Horde", "Scourge", 3099, 364, 1, PA_P.sarvis, N[2126]) -- Tainted Scroll
	note("WARRIOR", "Horde", "Scourge", 3095, 364, 1, PA_P.sarvis, N[2119]) -- Simple Scroll
	note("DRUID", "Alliance", "Skyborne", 92485, 92461, 2, SH_P.rorian, N[251373]) -- A Student of Nature
	note("HUNTER", "Alliance", "Skyborne", 92482, 92461, 2, SH_P.rorian, N[251376]) -- The Way of the Hunter
	note("MAGE", "Alliance", "Skyborne", 92481, 92461, 2, SH_P.rorian, N[251379]) -- A Student of the Arcane
	note("ROGUE", "Alliance", "Skyborne", 92483, 92461, 2, SH_P.rorian, N[251389]) -- At Home in the Shadows
	note("WARRIOR", "Alliance", "Skyborne", 92532, 92461, 2, SH_P.rorian, N[251964]) -- The Warrior's Path
	note("DRUID", "Horde", "Skyborne", 92485, 92461, 2, SH_P.rorian, N[251373]) -- A Student of Nature
	note("HUNTER", "Horde", "Skyborne", 92482, 92461, 2, SH_P.rorian, N[251376]) -- The Way of the Hunter
	note("ROGUE", "Horde", "Skyborne", 92483, 92461, 2, SH_P.rorian, N[251389]) -- At Home in the Shadows
	note("SHAMAN", "Horde", "Skyborne", 92484, 92461, 2, SH_P.rorian, SH_P.boro, 2) -- Embracing the Elements
	note("WARRIOR", "Horde", "Skyborne", 92532, 92461, 2, SH_P.rorian, N[251964]) -- The Warrior's Path
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

local function ItemCount(id)
	for _, fn in ipairs({ C_Item and C_Item.GetItemCount, GetItemCount }) do
		if fn then
			local ok, n = pcall(fn, id)
			if ok and type(n) == "number" then
				return n
			end
		end
	end
	return 0
end

local function HaveItem(id)
	return ItemCount(id) > 0
end

--- One objective of a quest in your log: finished? items = one of them in your bags (o.count: the FIRST item needs that
--- many, the others count as done when one is there: warrior charms 8 each, or the Essence; Fable check 17 Nov 2026);
--- idx = the client's objective.
local function ObjFinished(q, o)
	if o.items then
		for i, id in ipairs(o.items) do
			local n = ItemCount(id)
			if (i == 1 and o.count and n >= o.count) or ((i > 1 or not o.count) and n > 0) then
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
	-- the level 1 notes, 22 Nov 2026 (Wowhead Forever npc tooltips per language, checked again by the build chat)
	[197] = { deDE = "Marshal McBride", frFR = "Maréchal McBride", esES = "Alguacil McBride", esMX = "Alguacil McBride", ptBR = "Major Belmonte", ruRU = "Маршал Макбрайд" },
	[198] = { deDE = "Khelden Bremen", frFR = "Khelden Bremen", esES = "Khelden Bremen", esMX = "Khelden Bremen", ptBR = "Gaspar Melchior", ruRU = "Кельден Бремен" },
	[895] = { deDE = "Thorgas Grimson", frFR = "Thorgas Grimson", esES = "Thorgas Grimson", esMX = "Thorgas Grimson", ptBR = "Thorgas Grimson", ruRU = "Торгас Мрачнон" },
	[911] = { deDE = "Llane Beshere", frFR = "Llane Beshere", esES = "Llane Beshere", esMX = "Llane Beshere", ptBR = "Hipólito Valentim", ruRU = "Ллан Бишер" },
	[912] = { deDE = "Thran Khorman", frFR = "Thran Khorman", esES = "Thran Khorman", esMX = "Thran Khorman", ptBR = "Thran Khorman", ruRU = "Тран Корман" },
	[915] = { deDE = "Jorik Kerridan", frFR = "Jorik Kerridan", esES = "Jorik Kerridan", esMX = "Jorik Kerridan", ptBR = "Rufino Raposo", ruRU = "Джорик Керридан" },
	[916] = { deDE = "Solm Hargrin", frFR = "Solm Hargrin", esES = "Solm Hargrin", esMX = "Solm Hargrin", ptBR = "Solm Hargrin", ruRU = "Сольм Харгрин" },
	[925] = { deDE = "Bruder Sammuel", frFR = "Frère Sammuel", esES = "Hermano Sammuel", esMX = "Hermano Sammuel", ptBR = "Irmão Samuel", ruRU = "Брат Самуэль" },
	[926] = { deDE = "Bromos Grummner", frFR = "Bromos Grummner", esES = "Bromos Grummner", esMX = "Bromos Grummner", ptBR = "Bromos Grummner", ruRU = "Бромос Груммнер" },
	[944] = { deDE = "Marryk Nurribit", frFR = "Marryk Nurribit", esES = "Marryk Nurribit", esMX = "Marryk Nurribit", ptBR = "Marryk Nurribit", ruRU = "Маррик Нуррибит" },
	[2079] = { deDE = "Konservator Ilthalaine", frFR = "Conservateur Ilthalaine", esES = "Conservador Ilthalaine", esMX = "Conservador Ilthalaine", ptBR = "Conservador Ilthalaine", ruRU = "Опекун Илталайн" },
	[2119] = { deDE = "Dannal Stern", frFR = "Dannal Stern", esES = "Dannal Stern", esMX = "Dannal Stern", ptBR = "Dannal Stern", ruRU = "Даннал Штерн" },
	[2122] = { deDE = "David Trias", frFR = "David Trias", esES = "David Trias", esMX = "David Trias", ptBR = "Davi Trias", ruRU = "Давид Триас" },
	[2124] = { deDE = "Isabella", frFR = "Isabella", esES = "Isabella", esMX = "Isabella", ptBR = "Isabella", ruRU = "Изабелла" },
	[2126] = { deDE = "Maximillion", frFR = "Maximillion", esES = "Maximillion", esMX = "Maximillion", ptBR = "Maximillion", ruRU = "Максимиллион" },
	[2980] = { deDE = "Grull Hawkwind", frFR = "Grull Hawkwind", esES = "Grull Vientaguilar", esMX = "Grull Viento de Halcón", ptBR = "Grull Vento do Falcão", ruRU = "Грулл Соколиный Ветер" },
	[3059] = { deDE = "Harutt Thunderhorn", frFR = "Harutt Thunderhorn", esES = "Harutt Tronacuerno", esMX = "Harutt Tronacuerno", ptBR = "Harutt Chifre Troante", ruRU = "Харутт Громовой Рог" },
	[3060] = { deDE = "Gart Mistrunner", frFR = "Gart Mistrunner", esES = "Gart Correbruma", esMX = "Gart Correbruma", ptBR = "Gart Corre com a Névoa", ruRU = "Гарт Вестник Туманов" },
	[3061] = { deDE = "Lanka Farshot", frFR = "Lanka Farshot", esES = "Lanka Tirolargo", esMX = "Lanka Tirolejano", ptBR = "Lanka Tiro Distante", ruRU = "Ланко Дальний Выстрел" },
	[3062] = { deDE = "Meela Dawnstrider", frFR = "Meela Dawnstrider", esES = "Meela Caminalba", esMX = "Meela Caminalba", ptBR = "Meela Anda com a Aurora", ruRU = "Мила Рассветная Странница" },
	[3143] = { deDE = "Gornek", frFR = "Gornek", esES = "Gornek", esMX = "Gornek", ptBR = "Gornek", ruRU = "Горнек" },
	[3153] = { deDE = "Frang", frFR = "Frang", esES = "Frang", esMX = "Frang", ptBR = "Frang", ruRU = "Франг" },
	[3154] = { deDE = "Jen'shan", frFR = "Jen'shan", esES = "Jen'shan", esMX = "Jen'shan", ptBR = "Jen'shan", ruRU = "Джен'шан" },
	[3155] = { deDE = "Rwag", frFR = "Rwag", esES = "Rwag", esMX = "Rwag", ptBR = "Rwag", ruRU = "Руаг" },
	[3156] = { deDE = "Nartok", frFR = "Nartok", esES = "Nartok", esMX = "Nartok", ptBR = "Nartok", ruRU = "Нарток" },
	[3157] = { deDE = "Shikrik", frFR = "Shikrik", esES = "Shikrik", esMX = "Shikrik", ptBR = "Shikrik", ruRU = "Шикрик" },
	[3593] = { deDE = "Alyissia", frFR = "Alyissia", esES = "Alyissia", esMX = "Alyissia", ptBR = "Alyissia", ruRU = "Алайссия" },
	[3594] = { deDE = "Frahun Shadewhisper", frFR = "Frahun Shadewhisper", esES = "Frahun Sombrusurro", esMX = "Frahun Sombrusurro", ptBR = "Frahun Umbrurmúrio", ruRU = "Фрагун Шепот Тени" },
	[3596] = { deDE = "Ayanna Everstride", frFR = "Ayanna Everstride", esES = "Ayanna Semprerguida", esMX = "Ayanna Semprerguida", ptBR = "Ayanna Perenanda", ruRU = "Аянна Вечнобродка" },
	[3597] = { deDE = "Mardant Strongoak", frFR = "Mardant Strongoak", esES = "Mardant Cebaforte", esMX = "Mardant Fuerterroble", ptBR = "Mardant Carvalhaço", ruRU = "Мардант Крепкий Дуб" },
	[5884] = { deDE = "Mai'ah", frFR = "Mai'ah", esES = "Mai'ah", esMX = "Mai'ah", ptBR = "Mai'ah", ruRU = "Май'ах" },
	[248415] = { deDE = "Tordrin Sternblade", frFR = "Tordrin Durelame", esES = "Tordrin Hojadusta", esMX = "Tordrin Filosevero", ptBR = "Tordrin Caulâmina", ruRU = "Тордрин Мракоруб" },
	[251373] = { deDE = "Xyton Silberwind", frFR = "Xyton Vent-argent", esES = "Xyton Ventargento", esMX = "Xyton Ventargento", ptBR = "Xyton Brisaprata", ruRU = "Зитон Среброветрый" },
	[251376] = { deDE = "Tai'ree Farsight", frFR = "Tai'ree Doublevue", esES = "Tai'ree Vista Lejana", esMX = "Tai'ree Vistadista", ptBR = "Tai'ree Fitalonge", ruRU = "Тай'ри Дальний Взор" },
	[251379] = { deDE = "Dorii Brightwhisper", frFR = "Dorii Murméclat", esES = "Dorii Susurro Brillante", esMX = "Dorii Susurro Alegre", ptBR = "Dorii Soproluz", ruRU = "Дорийя Громкий Шепот" },
	[251389] = { deDE = "Akeri Duskblade", frFR = "Akeri Lamebrune", esES = "Akeri Hoja Umbría", esMX = "Akeri Hoja Umbría", ptBR = "Akeri Gumúmbrio", ruRU = "Акери Клинок Сумерек" },
	[251964] = { deDE = "Klingenmeisterin Ren", frFR = "Maître-lame Ren", esES = "Maestra del acero Ren", esMX = "Maestra del acero Ren", ptBR = "Mestre de Espadas Ren", ruRU = "Мастер клинка Рен" },
	-- weapon class quests, 18 Nov 2026 (mh-research: Wowhead Forever per locale + Spoken; [4722] ptBR 1 source)
	[5878] = { deDE = "Thun'grim Firegaze", frFR = "Thun'grim Firegaze", esES = "Thun'grim Vistafuego", esMX = "Thun'grim Vistafuego", ptBR = "Thun'grim Olhafogo", ruRU = "Тун'грим Огневзор" },
	[294] = { deDE = "Marshal Haggard", frFR = "Maréchal Haggard", esES = "Alguacil Haggard", esMX = "Mariscal Haggard", ptBR = "Delegado Fadigas", ruRU = "Маршал Хаггард" },
	[6031] = { deDE = "Tormus Deepforge", frFR = "Tormus Deepforge", esES = "Tormus Forjahonda", esMX = "Tormus Forjahonda", ptBR = "Tormus Baixaforja", ruRU = "Тормус Подземная Кузня" },
	[6142] = { deDE = "Mathiel", frFR = "Mathiel", esES = "Mathiel", esMX = "Mathiel", ptBR = "Mathiel", ruRU = "Матиль" },
	[1500] = { deDE = "Coleman Farthing", frFR = "Coleman Farthing", esES = "Coleman Lontananza", esMX = "Coleman Farthing", ptBR = "Eurico Palhares", ruRU = "Колман Фартинг" },
	[6247] = { deDE = "Doan Karhan", frFR = "Doan Karhan", esES = "Doan Karhan", esMX = "Doan Karhan", ptBR = "Doan Karhan", ruRU = "Доан Кархан" },
	[6266] = { deDE = "Menara Voidrender", frFR = "Menara Voidrender", esES = "Menara Nadiz", esMX = "Menara Nadiz", ptBR = "Menara Nihila", ruRU = "Менара Расщепительница Бездны" },
	[4722] = { deDE = "Rau Cliffrunner", frFR = "Rau Cliffrunner", esES = "Rau Abiscorredor", esMX = "Rau Abiscorredor", ptBR = "Rau Corta Montes", ruRU = "Рау Скальный Бегун" },
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
	[14522] = { ruRU = "Ур'дан" }, -- Ur'dan (GEMETEN WH-F ruRU, 18 Nov 2026); other languages: "Ur'dan"
	[14437] = { deDE = "Gorzeeki Wildeyes", frFR = "Gorzeeki Wildeyes", esES = "Gorzeeki Ojosalvajes", esMX = "Gorzeeki Ojovago", ptBR = "Gorzeeki Olholouco", ruRU = "Горзиеки Дикоглаз" },
	[9516] = { deDE = "Lord Banehollow", frFR = "Seigneur Banehollow", esES = "Lord Pesadilla", ptBR = "Lorde Nihilus", ruRU = "Лорд Гиблопуст" },
	[14469] = { deDE = "Niby der Allmächtige", frFR = "Niby le Tout-puissant", esES = "Niby el Todopoderoso", esMX = "Niby el Todopoderoso", ptBR = "Niby, o Todo-poderoso", ruRU = "Ниби Всемогущий" },
	[14470] = { deDE = "Impsy", frFR = "Démonet", esES = "Diblis", ptBR = "Diabretim", ruRU = "Бесенок" },
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
	-- Shaman (17 Nov 2026, mh-research: Wowhead Forever tooltips per locale, control npc 233; 5899 esMX from Spoken).
	-- Left out (not on Wowhead in that language): esMX 5891/251166/5895/258098/257808/258203, ptBR 251166/257808/258203.
	-- 251374 ptBR left out on purpose: Wowhead says "Moldavento" without "Boro" (looks broken). 5887 ptBR "Ranago" kept
	-- as Wowhead has it (doubt in TESTLIJST).
	[5887] = { deDE = "Canaga Earthcaller", frFR = "Canaga Earthcaller", esES = "Clamor de Tierra Canaga", esMX = "Canaga Clamatierras", ptBR = "Ranago Arauto da Terra", ruRU = "Канага заклинатель земли" },
	[5888] = { deDE = "Seherin Ravenfeather", frFR = "Prophétesse Ravenfeather", esES = "Profeta Plumacuervo", esMX = "Vidente Pluma de Cuervo", ptBR = "Vidente Pena do Corvo", ruRU = "Провидица Воронье Перо" },
	[5891] = { deDE = "Schwache Erdmanifestation", frFR = "Manifestation de terre mineure", esES = "Manifestación de tierra menor", ptBR = "Manifestação Menor de Terra", ruRU = "Низшее воплощение земли" },
	[251166] = { deDE = "Schwache Erdmanifestation", frFR = "Manifestation de terre mineure", esES = "Manifestación de tierra menor", ruRU = "Низшее воплощение земли" },
	[3173] = { deDE = "Swart", frFR = "Swart", esES = "Swart", esMX = "Swart", ptBR = "Swart", ruRU = "Злобр" },
	[3066] = { deDE = "Narm Skychaser", frFR = "Narm Skychaser", esES = "Narm Cazacielo", esMX = "Narm Cazacielo", ptBR = "Narm Persegue-céus", ruRU = "Нарм Небесный Охотник" },
	[5892] = { deDE = "Searn Firewarder", frFR = "Searn Firewarder", esES = "Searn Guardafogo", esMX = "Searn Guardafogo", ptBR = "Searn Guardafogo", ruRU = "Огнир хранитель Огня" },
	[5907] = { deDE = "Kranal Fiss", frFR = "Kranal Fiss", esES = "Kranal Fiss", esMX = "Kranal Fiss", ptBR = "Kranal Fiss", ruRU = "Кранал Фисс" },
	[5900] = { deDE = "Telf Joolam", frFR = "Telf Joolam", esES = "Telf Joolam", esMX = "Telf Joolam", ptBR = "Telf Joolam", ruRU = "Телф Джулам" },
	[5901] = { deDE = "Islen Waterseer", frFR = "Islen Waterseer", esES = "Islen Vident'aqua", esMX = "Islen Vidente del Agua", ptBR = "Islen Vidente da Água", ruRU = "Ислен Заклинатель Воды" },
	[5899] = { deDE = "Brine", frFR = "Brine", esES = "Salmuera", esMX = "Salmuera", ptBR = "Salma", ruRU = "Брин" },
	[5895] = { deDE = "Schwache Wassermanifestation", frFR = "Manifestation d'eau mineure", esES = "Manifestación de agua menor", ptBR = "Manifestação Menor da Água", ruRU = "Низшее воплощение воды" },
	[5905] = { deDE = "Prate Cloudseer", frFR = "Prate Cloudseer", esES = "Prate Nubeprofeta", esMX = "Prate Vidente de las Nubes", ptBR = "Pradosa Fita Nuvens", ruRU = "Пратта Заклинательница Туч" },
	[3032] = { deDE = "Beram Skychaser", frFR = "Beram Skychaser", esES = "Beram Cazacielo", esMX = "Beram Cazacielo", ptBR = "Beram Persegue-céus", ruRU = "Берам Небесный Охотник" },
	[251361] = { deDE = "Rorian der Tagsucher", frFR = "Rorian le Cherchejour", esES = "Rorian el Buscadía", esMX = "Rorian, el Buscadías", ptBR = "Rorian, o Caça-alva", ruRU = "Рориан Искатель Утра" },
	[251374] = { deDE = "Windformer Boro", frFR = "Sculpte-vent Boro", esES = "Formavientos Boro", esMX = "Formavientos Boro", ruRU = "Ваятель Ветра Боро" },
	[252382] = { deDE = "Sessaria Skystride", frFR = "Sessaria Marcheciel", esES = "Sessaria Caminante del Cielo", esMX = "Sessaria Zancacielo", ptBR = "Sessaria Andacéu", ruRU = "Сессария Небесная Странница" },
	[268592] = { deDE = "Olariaan Swiftburn", frFR = "Olariaan Vivebrûle", esES = "Olariaan Ardeveloz", esMX = "Olariaan Fuegoveloz", ptBR = "Olariaan Queimabreve", ruRU = "Олариан Быстрая Вспышка" },
	[658] = { deDE = "Sten Stoutarm", frFR = "Sten Stoutarm", esES = "Sten Brazofuerte", esMX = "Sten Brazorrecio", ptBR = "Sten Braçoforte", ruRU = "Стен Крепкорук" },
	[257446] = { deDE = "Teo Hammerstorm", frFR = "Teo Martel-tempête", esES = "Teo Mazatormenta", esMX = "Teo Mazatormenta", ptBR = "Teo Tempestelo", ruRU = "Тео Молотошторм" },
	[258113] = { deDE = "Ingrid Dunwald", frFR = "Ingrid Dunwald", esES = "Ingrid Montocre", esMX = "Ingrid Montocre", ptBR = "Ingrid Dunwald", ruRU = "Ингрид Дунвальд" },
	[258098] = { deDE = "Eldrun Stormbreaker", frFR = "Eldrun Brise-tempête", esES = "Eldrun Rompetormentas", ptBR = "Eldrun Rompe-procelas", ruRU = "Элдрун Тучегон" },
	[257597] = { deDE = "Bruegs Kindleborn", frFR = "Bruegs Flammené", esES = "Bruegs Prendecirios", esMX = "Bruegs Sangrellamas", ptBR = "Bruegs Igninato", ruRU = "Брюкс Дитя Искр" },
	[257808] = { deDE = "Braldir Ashmantle", frFR = "Braldir Houppecendre", esES = "Braldir Mantoceniza", ruRU = "Бралдир Пеплоплащ" },
	[258043] = { deDE = "Norric Lochthane", frFR = "Norric Lochthane", esES = "Norric Lochthane", esMX = "Norric Lagolord", ptBR = "Norric Lochthane", ruRU = "Норрик Тан Лока" },
	[258203] = { deDE = "Hervdana Saegrund", frFR = "Hervdana Saegrund", esES = "Hervdana Saegrund", ruRU = "Гервдана Саэгрунд" },
	-- Priest (17 Nov 2026, mh-research: Wowhead Forever tooltips per locale; Spoken agreed where it has the name; control
	-- npc 233 again). 2129 esES: Wowhead "Clérigo", Spoken "Clérico" (Wowhead kept). 10922 esMX: Spoken only.
	[376] = { deDE = "Hohepriesterin Laurena", frFR = "Grande prêtresse Laurena", esES = "Suma Sacerdotisa Laurena", esMX = "Suma sacerdotisa Laurena", ptBR = "Alta-sacerdotisa Laurena", ruRU = "Верховная жрица Лорена" },
	[11406] = { deDE = "Hohepriester Rohan", frFR = "Grandprêtre Rohan", esES = "Sumo Sacerdote Rohan", esMX = "Sumo sacerdote Rohan", ptBR = "Sumo Sacerdote Rohan", ruRU = "Верховный жрец Рохан" },
	[258785] = { deDE = "Hohepriesterin Mims", frFR = "Grande prêtresse Mims", esES = "Suma sacerdotisa Mims", esMX = "Suma sacerdotisa Mims", ptBR = "Alta-sacerdotisa Mims", ruRU = "Верховная жрица Мимс" },
	[11401] = { deDE = "Priesterin Alathea", frFR = "Prêtresse Alathea", esES = "Sacerdotisa Alathea", esMX = "Sacerdotisa Alathea", ptBR = "Sacerdotisa Alathea", ruRU = "Жрица Алатея" },
	[6018] = { deDE = "Ur'kyo", frFR = "Ur'kyo", esES = "Ur'kyo", esMX = "Ur'kyo", ptBR = "Ur'kyo", ruRU = "Ур'кьо" },
	[4606] = { deDE = "Aelthalyste", frFR = "Aelthalyste", esES = "Aelthalyste", esMX = "Aelthalyste", ptBR = "Aelthalyste", ruRU = "Эльталисте" },
	[375] = { deDE = "Priesterin Anetta", frFR = "Prêtresse Anetta", esES = "Sacerdotisa Anetta", esMX = "Sacerdotisa Anetta", ptBR = "Sacerdotisa Anita", ruRU = "Жрица Анетта" },
	[377] = { deDE = "Priesterin Josetta", frFR = "Prêtresse Josetta", esES = "Sacerdotisa Josetta", esMX = "Sacerdotisa Josetta", ptBR = "Sacerdotisa Joselita", ruRU = "Жрица Жозетта" },
	[837] = { deDE = "Branstock Khalder", frFR = "Branstock Khalder", esES = "Silo Khalder", esMX = "Silo Khalder", ptBR = "Branstock Khalder", ruRU = "Брансток Халдер" },
	[1226] = { deDE = "Maxan Anvol", frFR = "Maxan Anvol", esES = "Maxan Anvol", esMX = "Maxan Anvol", ptBR = "Maxan Begurno", ruRU = "Максан Анвол" },
	[3595] = { deDE = "Shanda", frFR = "Shanda", esES = "Shanda", esMX = "Shanda", ptBR = "Shanda", ruRU = "Шанда" },
	[3600] = { deDE = "Laurna Morninglight", frFR = "Laurna Morninglight", esES = "Laurna Luzdelalba", esMX = "Laurna Luzdelalba", ptBR = "Laurna Luzalbor", ruRU = "Лорна Утренний Свет" },
	[3707] = { deDE = "Ken'jai", frFR = "Ken'jai", esES = "Ken'jai", esMX = "Ken'jai", ptBR = "Ken'jai", ruRU = "Кен'джай" },
	[3706] = { deDE = "Tai'jin", frFR = "Tai'jin", esES = "Tai'jin", esMX = "Tai'jin", ptBR = "Tai'jin", ruRU = "Тай'джин" },
	[2123] = { deDE = "Dunkler Kleriker Duesten", frFR = "Sombre clerc Duesten", esES = "Clérico oscuro Duesten", esMX = "Clérigo oscuro Duesten", ptBR = "Clérigo das Trevas Duesten", ruRU = "Темный священник Дьюстен" },
	[2129] = { deDE = "Dunkler Kleriker Beryl", frFR = "Sombre clerc Beryl", esES = "Clérigo oscuro Beryl", esMX = "Clérigo oscuro Beryl", ptBR = "Clérigo das Trevas Beryl", ruRU = "Темный священник Берил" },
	[5489] = { deDE = "Bruder Joshua", frFR = "Frère Joshua", esES = "Hermano Joshua", esMX = "Hermano Joshua", ptBR = "Irmão Josué", ruRU = "Брат Джошуа" },
	-- Paladin (17 Nov 2026, mh-research: Wowhead Forever tooltips per locale, control npc 233). Missing esMX/ptBR = Wowhead
	-- has no name there. 5149 and 1854 esMX from Spoken. 927 esES, 6179/10838/1569 ruRU: Spoken disagrees, Wowhead kept.
	-- 11406 (Rohan) is already in the priest lines above.
	[927] = { deDE = "Bruder Wilhelm", frFR = "Frère Wilhelm", esES = "Hermano Wilhelm", esMX = "Hermano Wilhelm", ptBR = "Irmão Guilhermino", ruRU = "Брат Вильгельм" },
	[6171] = { deDE = "Duthorian Rall", frFR = "Duthorian Rall", esES = "Duthorian Rall", esMX = "Duthorian Rall", ptBR = "Benedito Brião", ruRU = "Даториан Ралл" },
	[6174] = { deDE = "Stephanie Turner", frFR = "Stephanie Turner", esES = "Stephanie Turner", esMX = "Stephanie Turner", ptBR = "Stephanie Turner", ruRU = "Стефани Тернер" },
	[6173] = { deDE = "Gazin Tenorm", frFR = "Gazin Tenorm", esES = "Gazin Tenorm", esMX = "Gazin Tenorm", ptBR = "Gazin Tenorm", ruRU = "Газин Тенорм" },
	[6172] = { deDE = "Henze Faulk", frFR = "Henze Faulk", esES = "Henze Faulk", esMX = "Henze Faulk", ptBR = "Henze Faulk", ruRU = "Хенз Фолк" },
	[5149] = { deDE = "Brandur Ironhammer", frFR = "Brandur Ironhammer", esES = "Brandur Martiyerro", esMX = "Brandur Martiyerro", ptBR = "Brandur Ferromalho", ruRU = "Брандар Железный Молот" },
	[6179] = { deDE = "Tiza Battleforge", frFR = "Tiza Battleforge", esES = "Tiza Forjabatalla", esMX = "Tiza Forjabatalla", ptBR = "Tiza Beloforja", ruRU = "Тиза Кузнебой" },
	[6175] = { deDE = "John Turner", frFR = "John Turner", esES = "John Turner", esMX = "John Turner", ptBR = "João Turner", ruRU = "Джон Тернер" },
	[6178] = { deDE = "Muiredon Battleforge", frFR = "Muiredon Battleforge", esES = "Muiredon Forjabatalla", esMX = "Muiredon Forjabatalla", ptBR = "Muiredon Beloforja", ruRU = "Майридон Кузнебой" },
	[6177] = { deDE = "Narm Faulk", frFR = "Narm Faulk", esES = "Narm Faulk", esMX = "Narm Faulk", ptBR = "Narm Faulk", ruRU = "Нарм Фолк" },
	[6182] = { deDE = "Daphne Stilwell", frFR = "Daphne Stilwell", esES = "Daphne Fontana", esMX = "Daphne Fontana", ptBR = "Dafne Calmafonte", ruRU = "Дафна Стилвелл" },
	[6181] = { deDE = "Jordan Stilwell", frFR = "Jordan Stilwell", esES = "Jordan Fontana", esMX = "Jordan Fontana", ptBR = "Jardel Calmafonte", ruRU = "Джордан Стилвелл" },
	[6241] = { deDE = "Bailor Stonehand", frFR = "Bailor Stonehand", esES = "Bailor Petramano", esMX = "Bailor Petramano", ptBR = "Bailor Manopedra", ruRU = "Балор Крепкорук" },
	[3649] = { deDE = "Thundris Windwirker", frFR = "Thundris Windweaver", esES = "Thundris Tejevientos", esMX = "Thundris Tejevientos", ptBR = "Trovejius Tecevento", ruRU = "Тандрис Ветропряд" },
	[5491] = { deDE = "Arthur der Treue", frFR = "Arthur le Fidèle", esES = "Arthur el Leal", esMX = "Arthur el Leal", ptBR = "Artur, o Fiel", ruRU = "Артур Верный" },
	[928] = { deDE = "Lord Grayson Shadowbreaker", frFR = "Seigneur Grayson Shadowbreaker", esES = "Lord Grisillo Quiebrasombras", esMX = "Lord Grisillo Quiebrasombras", ptBR = "Lorde Grayson Quebrassombra", ruRU = "Лорд Грейсон Тенелом" },
	[10838] = { deDE = "Kommandant Ashlam Valorfist", frFR = "Commandant Ashlam Valorfist", esES = "Comandante Ashlam Puñovalor", esMX = "Comandante Ashlam Puñovalor", ptBR = "Comandante Ashlam Punhobom", ruRU = "Командир Ашлам Отважный Кулак" },
	[1854] = { deDE = "Hohepriester Thel'danis", frFR = "Grand prêtre Thel'danis", esES = "Sumo Sacerdote Thel'danis", esMX = "Sumo sacerdote Thel'danis", ptBR = "Sumo Sacerdote Thel'danis", ruRU = "Верховный жрец Тель'данис" },
	[1416] = { deDE = "Grimand Elmore", frFR = "Grimand Elmore", esES = "Grimand Elmore", esMX = "Grimand Elmore", ptBR = "Grimand Elmore", ruRU = "Гриманд Элмор" },
	[2357] = { deDE = "Merideth Carlson", frFR = "Merideth Carlson", esES = "Merideth Carlson", ptBR = "Judite Castanheira", ruRU = "Меридет Карлсон" },
	[14566] = { deDE = "Uralter Pferdegeist", frFR = "Ancien esprit équin", esES = "Antiguo espíritu equino", ptBR = "Espírito Equino Antigo", ruRU = "Дух древнего коня" },
	[14568] = { deDE = "Schattensichels gefallenes Streitross", frFR = "Destrier déchu de Ravassombre", esES = "Arremetedor Atracoscuro", ptBR = "Corcel Caído de Noctilatrus", ruRU = "Падший скакун Темного Терзателя" },
	[1569] = { deDE = "Schattenpriester Sarvis", frFR = "Prêtre des ombres Sarvis", esES = "Sacerdote de las Sombras Sarvis", esMX = "Sacerdote de las Sombras Sarvis", ptBR = "Sacerdote Sombrio Sarvis", ruRU = "Жрец Тьмы Сарвис" },
	[244808] = { deDE = "Aramis Hammerhand", frFR = "Aramis Mainmartel", esES = "Aramis Manomartillo", esMX = "Aramis Manomartillo", ptBR = "Aramis Cerramartelo", ruRU = "Арамис Хаммерхенд" },
	[246152] = { deDE = "Shari Stilwell", frFR = "Shari Morpuits", esES = "Shari Fontana", esMX = "Shari Fontana", ptBR = "Shária Calmafonte", ruRU = "Шари Стилвелл" },
	[246349] = { deDE = "Brenton Samuels", frFR = "Breton Samuels", esES = "Breton Samuels", esMX = "Breton Samuels", ptBR = "Bretônio Samuel", ruRU = "Бретон Самуэльс" },
	[246393] = { deDE = "Jorin Croge", frFR = "Jorin Croge", esES = "Jorin Croge", esMX = "Jorin Croge", ptBR = "Jorin Croge", ruRU = "Джорин Крог" },
	[246378] = { deDE = "Danitha Morr", frFR = "Danitha Morr", esES = "Danitha Morr", esMX = "Danitha Morr", ptBR = "Danitha Morr", ruRU = "Данита Морр" },
	[10181] = { deDE = "Fürstin Sylvanas Windrunner", frFR = "Dame Sylvanas Windrunner", esES = "Lady Sylvanas Brisaveloz", esMX = "Lady Sylvanas Brisaveloz", ptBR = "Grande Dama Sylvana Correventos", ruRU = "Леди Сильвана Ветрокрылая" },
	[257648] = { deDE = "Tanis Alderwood", frFR = "Tanis Aulnebois", esES = "Tanis Alderwood", esMX = "Tanis Alisero", ptBR = "Tanis Amieiro", ruRU = "Танис Элдервуд" },
	[257655] = { deDE = "Todeswache Billmuth", frFR = "Nécrogarde Billmuth", esES = "Guardia de la Muerte Billmuth", esMX = "Guardia de la Muerte Billmuth", ptBR = "Necroguarda Billmuth", ruRU = "Страж смерти Билмут" },
	[257663] = { deDE = "Todeswache Falgan", frFR = "Nécrogarde Falgan", esES = "Guardia de la Muerte Falgan", esMX = "Guardia de la Muerte Falgan", ptBR = "Necroguarda Falgan", ruRU = "Страж смерти Фалган" },
	[248840] = { deDE = "Trevan Rol", frFR = "Trevan Rol", esES = "Trevan Rol", esMX = "Trevan Rol", ptBR = "Trevano Rol", ruRU = "Треван Рол" },
	[259611] = { deDE = "Todeswache Baldren", frFR = "Nécrogarde Baldren", esES = "Guardia de la Muerte Baldren", esMX = "Guardia de la muerte Baldren", ptBR = "Necroguarda Baldreno", ruRU = "Страж смерти Балдрен" },
	[248755] = { deDE = "Lumina Windsinger", frFR = "Lumina Chantelevent", esES = "Lumina Vientocantor", esMX = "Lumina Vientocantor", ptBR = "Lúmina Cantavento", ruRU = "Люмина Песнь Ветра" },
	[259620] = { deDE = "Lumina Windsinger", frFR = "Lumina Chantelevent", esES = "Lumina Vientocantor", ruRU = "Люмина Песнь Ветра" },
	[259649] = { deDE = "Ulric Frostveil", frFR = "Ulric Voile-de-givre", esES = "Ulric Veloescarcha", esMX = "Ulric Veloscarcha", ptBR = "Ulorico Glacivéu", ruRU = "Ульрик Фроствейл" },
	[3539] = { deDE = "Ott", frFR = "Ott", esES = "Ott", esMX = "Ott", ptBR = "Ott", ruRU = "Отт" },
	[260093] = { deDE = "Garen Largo", frFR = "Garen Largo", esES = "Garen Largo", esMX = "Garen Largo", ptBR = "Gareno Largo", ruRU = "Гарен Ларго" },
	-- Mage (17 Nov 2026, mh-research: Wowhead Forever tooltips per locale; control npc 233; Spoken agreed where it had a
	-- name). 252373 and 8395 esMX: not on Wowhead, left out. 14368 esMX: from Spoken (Wowhead has none).
	[328] = { deDE = "Zaldimar Wefhellt", frFR = "Zaldimar Wefhellt", esES = "Zaldimar Wefhellt", esMX = "Zaldimar Wefhellt", ptBR = "Zaldimar Wefhellt", ruRU = "Залдимар Вефхеллт" },
	[5497] = { deDE = "Jennea Cannon", frFR = "Jennea Cannon", esES = "Jennea Cannon", esMX = "Jennea Cañón", ptBR = "Jana Catão", ruRU = "Джинния Пушка" },
	[1228] = { deDE = "Magis Sparkmantle", frFR = "Magis Sparkmantle", esES = "Magis Chispamanto", esMX = "Magis Chispamanto", ptBR = "Magis Fagulhamanto", ruRU = "Магис Искроплащ" },
	[5144] = { deDE = "Bink", frFR = "Bink", esES = "Bink", esMX = "Bink", ptBR = "Bink", ruRU = "Бинк" },
	[7312] = { deDE = "Dink", frFR = "Dink", esES = "Dink", esMX = "Dink", ptBR = "Dink", ruRU = "Динк" },
	[252373] = { deDE = "Anathamaas Aetherwind", frFR = "Anathamaas Vent-d'éther", esES = "Anathamaas Vientoéter", ptBR = "Anathamaas Brisetéria", ruRU = "Анатамаас Эфирный Ветер" },
	[256507] = { deDE = "Belann Windwood", frFR = "Belann Vif-Bois", esES = "Belann Vientomadera", esMX = "Belann Vientosauco", ptBR = "Belann Lenhéolo", ruRU = "Беланн Древо Ветров" },
	[1309] = { deDE = "Wynne Larson", frFR = "Wynne Larson", esES = "Wynne Larson", esMX = "Wynne Larson", ptBR = "Manoela Galante", ruRU = "Уинн Ларсон" },
	[5694] = { deDE = "Zaubermeister Andromath", frFR = "Grand sorcier Andromath", esES = "Sumo Hechicero Andromath", esMX = "Sumo Hechicero Andromath", ptBR = "Grão-Feiticeiro Andromath", ruRU = "Верховный колдун Андромат" },
	[331] = { deDE = "Maginor Dumas", frFR = "Maginor Dumas", esES = "Maginor Dumas", esMX = "Maginor Dumas", ptBR = "Maginor Dumas", ruRU = "Магинор Дюма" },
	[211033] = { deDE = "Garion Wendell", frFR = "Garion Wendell", esES = "Garion Wendell", esMX = "Garion Wendell", ptBR = "Garion Wendell", ruRU = "Гэрион Уэнделл" },
	[7311] = { deDE = "Uthel'nay", frFR = "Uthel'nay", esES = "Uthel'nay", esMX = "Uthel'nay", ptBR = "Uthel'nay", ruRU = "Утель'най" },
	[5880] = { deDE = "Un'Thuwa", frFR = "Un'Thuwa", esES = "Un'Thuwa", esMX = "Un'Thuwa", ptBR = "Un'Thuwa", ruRU = "Ун'Тува" },
	[2128] = { deDE = "Cain Firesong", frFR = "Cain Firesong", esES = "Cain Pirosón", esMX = "Cain Pirosón", ptBR = "Caio Cantígnea", ruRU = "Кейн Песнь Пламени" },
	[4568] = { deDE = "Anastasia Hartwell", frFR = "Anastasia Hartwell", esES = "Anastasia Pozovenado", esMX = "Anastasia Hartwell", ptBR = "Anastácia Cordato", ruRU = "Анастасия Хартвелл" },
	[4576] = { deDE = "Josef Gregorian", frFR = "Josef Gregorian", esES = "Josef Gregorian", esMX = "Josef Gregorian", ptBR = "Josefo Gregório", ruRU = "Джозеф Грегориан" },
	[5885] = { deDE = "Deino", frFR = "Deino", esES = "Deino", esMX = "Deino", ptBR = "Denya", ruRU = "Дейно" },
	[3484] = { deDE = "Kil'hala", frFR = "Kil'hala", esES = "Kil'hala", esMX = "Kil'hala", ptBR = "Kil'hala", ruRU = "Кил'хала" },
	[4567] = { deDE = "Pierce Shackleton", frFR = "Pierce Shackleton", esES = "Pierce Esqueletonio", esMX = "Pierce Shackleton", ptBR = "Frederico Grilhões", ruRU = "Пирс Шеклтон" },
	[211022] = { deDE = "Owen Thadd", frFR = "Owen Thadd", esES = "Owen Thadd", esMX = "Owen Thadd", ptBR = "Adélio Tadeu", ruRU = "Оуэн Тадд" },
	[6546] = { deDE = "Tabetha", frFR = "Tabetha", esES = "Tabetha", esMX = "Tabetha", ptBR = "Tabetha", ruRU = "Табета" },
	[6548] = { deDE = "Magus Tirth", frFR = "Magus Tirth", esES = "Magus Tirth", esMX = "Magus Tirth", ptBR = "Tirth, o Mago", ruRU = "Волхв Тирт" },
	[8395] = { deDE = "Sanath Lim-yo", frFR = "Sanath Lim-yo", esES = "Sanath Lim-yo", ptBR = "Sanath Lim-yo", ruRU = "Санат Лим-Йо" },
	[14368] = { deDE = "Hüter des Wissens Lydros", frFR = "Gardien du savoir Lydros", esES = "Tradicionalista Lydros", esMX = "Tradicionalista Lydros", ptBR = "Erudito Lydros", ruRU = "Сказитель Лидрос" },
	[10922] = { deDE = "Greta Mosshoof", frFR = "Greta Mosshoof", esES = "Greta Pezuñamusgo", esMX = "Greta Pezuñamusgo", ptBR = "Greta Musgo no Casco", ruRU = "Грета Замшелое Копыто" },
	[259023] = { deDE = "Veyric Thunderhame", frFR = "Veyric Hametonne", esES = "Veyric Tronador", esMX = "Veyric Horcatrueno", ptBR = "Veyric Tonitrular", ruRU = "Вейрик Громоцеп" },
}

-- Objects that give or take a quest (shaman braziers and a shrine, 17 Nov 2026): name per client language, GEMETEN in
-- Wowhead Forever object tooltips per locale (mh-research). A place with `obj` instead of `id` uses this table.
local OBJ_NAMES = {
	[61934] = { deDE = "Kohlenpfanne der schlafenden Flamme", frFR = "Brasero de la Flamme Dormante", esES = "Blandón de la Llama Latente", esMX = "Blandón de la Llama Latente", ptBR = "Braseiro da Chama Latente", ruRU = "Жаровня Дремлющего Пламени" },
	[113791] = { deDE = "Kohlenpfanne von Everfount", frFR = "Brasero d'Everfount", esES = "Blandón de Siemprefuente", ptBR = "Braseiro da Fonteterna", ruRU = "Жаровня Вечного источника" },
	[619896] = { deDE = "Vergessener Schrein", frFR = "Sanctuaire oublié", esES = "Santuario olvidado", esMX = "Santuario olvidado", ptBR = "Santuário Esquecido", ruRU = "Забытое святилище" },
}

local function NpcName(p)
	if not (p and p.npc) then
		return "?"
	end
	local loc = GetLocale and GetLocale()
	local row = (p.id and NPC_NAMES[p.id]) or (p.obj and OBJ_NAMES[p.obj])
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
	-- 17 Nov 2026 (Fable check, Sparring 17-11): every race route is open to the whole faction (race masks), so a player
	-- may take another race's route (a Night Elf warrior in Goldshire). Per key: if your own route shows no quest done or
	-- in your log but another race's route of your faction does, follow that one (the first such) instead of sending you
	-- to your own giver, who offers nothing any more.
	local function Active(c)
		for _, e in ipairs(c.quests) do
			if AnyDone(e) or LogQuest(e) then
				return true
			end
		end
		return false
	end
	local own, foreign, ownActive = {}, {}, {}
	for _, c in ipairs(CHAINS[token] or {}) do
		if c.faction == faction then
			if not c.races or (race and c.races[race]) then
				own[#own + 1] = c
				if c.races and Active(c) then
					ownActive[c.key] = true
				end
			elseif not foreign[c.key] and Active(c) then
				foreign[c.key] = c
			end
		end
	end
	local out, pos, swapped = {}, {}, {}
	for _, c in ipairs(own) do
		local f = c.races and not ownActive[c.key] and foreign[c.key]
		if f then
			if not swapped[c.key] then
				swapped[c.key] = true
				out[#out + 1] = f
				pos[f] = #out
			end
		else
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
	if level < c.level or (c.needs and not Done(c.needs)) then
		return false
	end
	-- e.gate on the first quest (22 Nov 2026): its giver offers it only after that quest. A chain you are already in
	-- (or came into by the other way) is not held back.
	local gate = c.quests[1] and c.quests[1].gate
	if gate and not Done(gate) then
		for _, e in ipairs(c.quests) do
			if AnyDone(e) or LogQuest(e) then
				return true
			end
		end
		return false
	end
	return true
end

--- Is this chain on the class quest lists? A note only while you can take it, carry it or once it is done (an intro
--- never as done: its spell chain lists that quest). Everything else always.
local function Listed(c, level)
	if not c.note then
		return true
	end
	local e = c.quests[1]
	if c.intro and (level > c.last or AnyDone(e)) then
		return false
	end
	if AnyDone(e) or LogQuest(e) then
		return true
	end
	return Ready(c, level) and level <= c.last
end

--- Where you are in a chain: step = { kind = "get"/"do"/"turn", place (may be nil), textKey, q }, or nil + why.
--- Every quest in e.needs is done (strict chains only).
local function NeedsMet(e)
	for _, n in ipairs(e.needs or {}) do
		if not Done(n) then
			return false
		end
	end
	return true
end

--- The quest a chain is at. Normal chains: the LAST quest that is done or in the log decides (so a skipped pickup
--- does not send you back). c.strict (17 Nov 2026, warlock Dreadsteed, found by the Fable check of Sparring 17-11):
--- quests run side by side (three from Mor'zul at once) and some wait for several others. There the first quest of the
--- table that is in your log comes first; otherwise the first one not done whose `needs` are all done.
local function Current(c)
	if c.strict then
		for _, e in ipairs(c.quests) do
			if not AnyDone(e) and LogQuest(e) then
				return e
			end
		end
		for _, e in ipairs(c.quests) do
			if not AnyDone(e) and NeedsMet(e) then
				return e
			end
		end
		return nil
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
	return c.quests[i]
end

--------------------------------------------------------------------------------
-- What you must HAVE before the trip (18 Nov 2026). Rob, via sparring, letterlijk: "Ik ben de halve wereld over gereisd
-- om bij dit quest te doen, deze class quest. Maar dan kom ik aan, dan had ik een boek moeten hebben. … misschien was er
-- een waarschuwing geweest" → "ja". Research: docs/forever/CLASSQUEST_VOORWAARDEN_2026-11-18.md (mh-research).
--------------------------------------------------------------------------------
-- Mage library books. The librarian offers Research Access 97286 after you handed in ANY ONE book (azeroth.wiki,
-- foreverquestlog, warcraft.wiki: "first book"; that one is enough in today's build = AFGELEID). Each book has its own
-- hand-in quest that needs the book in your bags (Wowhead Forever tooltips, GEMETEN). Books are world objects you click.
-- Book items + quests GEMETEN: DB2 ItemSparse 1.60.1.70959 (40 items, unique) + Wowhead Forever quest tooltips.
local BOOK_ITEMS = {
	203754, 203755, 207972, 208185, 208800, 208860, 209843, 209844, 209845, 209846, 209847, 209848, 209849, 209850,
	209851, 210177, 213165, 215683, 215815, 215816, 215817, 215820, 215822, 215824, 220345, 220346, 220347, 220348,
	220349, 220350, 220352, 220353, 228132, 228133, 228134, 228135, 228136, 228138, 228140, 228141,
}
local BOOK_QUESTS = {
	78124, 78127, 78142, 78143, 78145, 78146, 78147, 78148, 78149, 79091, 79092, 79093, 79094, 79095, 79096, 79097,
	79535, 79947, 79948, 79949, 79950, 79951, 79952, 79953, 81947, 81949, 81951, 81952, 81953, 81954, 81955, 81956,
	84395, 84396, 84397, 84398, 84399, 84400, 84401, 84402,
}
-- The books a level-6 mage can fetch safely near the starting cities, per side; the arrow goes to the nearest one on
-- your continent, else the first of your side. Spawns GEMETEN (Wowhead Forever object tooltips) unless guide = true
-- (Wowhead Forever guide "Collecting Library Books", 13 Nov 2026: object id not found). Left out on purpose: books
-- behind elites, in caves or dungeons (Mo'grosh, Sludge Fen, Wailing Caverns, Raven Hill crypt, Grimtotem Post).
local START_BOOKS = {
	Alliance = {
		{ item = 203755, name = "Archmage Theocritus' Research Journal", m = 1429, x = 65.4, y = 70.1 }, -- Tower of Azora, object 386759
		{ item = 203754, name = "Archmage Antonidas: The Unabridged Autobiography", m = 1455, x = 75.7, y = 10.5 }, -- Hall of Explorers, 386691
		{ item = 208860, name = "Rumi of Gnomeregan: The Collected Works", m = 1432, x = 35.6, y = 48.9 }, -- Thelsamar inn, 408014
		{ item = 208860, name = "Rumi of Gnomeregan: The Collected Works", m = 1436, x = 52.7, y = 53.8, guide = true }, -- Sentinel Hill
		-- Bewitchments and Glamours (Moonbrook) left out: a level 25 book (second check, 18 Nov 2026).
	},
	Horde = {
		{ item = 208185, name = "The Apothecary's Metaphysical Primer", m = 1420, x = 59.4, y = 52.3 }, -- Brill, 405879
		-- A painted tablet on the wall, not a book on a table (second check): the text says "click it where it lies".
		{ item = 207972, name = "The Lessons of Ta'zo", m = 1454, x = 38.7, y = 78.4, guide = true }, -- Valley of Spirits
		{ item = 208800, name = "Baxtan: On Destructive Magics", m = 1413, x = 62.7, y = 36.3 }, -- Ratchet, 407566
		{ item = 210177, name = "Ataeric: On Arcane Curiosities", m = 1421, x = 43.4, y = 41.2 }, -- Sepulcher inn, 410299
		-- The Dalaran Digest (Ambermill) left out: a level 25 book (second check, 18 Nov 2026).
	},
}

local function ItemName(id, fallback)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return fallback or ("#" .. tostring(id))
end

--- World position of a map point (continent, x, y in yards), or nil.
local function WorldPos(m, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, cont, v = pcall(C_Map.GetWorldPosFromMapPos, m, CreateVector2D(x / 100, y / 100))
	if ok and cont and v and v.GetXY then
		local wx, wy = v:GetXY()
		return cont, wx, wy
	end
	return nil
end

local function PlayerWorldPos()
	if not (C_Map and C_Map.GetBestMapForUnit and C_Map.GetPlayerMapPosition) then
		return nil
	end
	local okM, m = pcall(C_Map.GetBestMapForUnit, "player")
	if not (okM and m) then
		return nil
	end
	local okP, pos = pcall(C_Map.GetPlayerMapPosition, m, "player")
	if not (okP and pos and pos.GetXY) then
		return nil
	end
	local px, py = pos:GetXY()
	return WorldPos(m, px * 100, py * 100)
end

local function NearestBook()
	local faction = UnitFactionGroup and UnitFactionGroup("player")
	local list = START_BOOKS[faction]
	if not list then
		return nil
	end
	local pc, px, py = PlayerWorldPos()
	-- A spot from a guide counts as 1.5 times as far as a measured one: still the Ta'zo tablet for an orc in Orgrimmar,
	-- but a measured book when the two are about as near (AFGELEID weighting).
	local best, bestD
	for _, b in ipairs(list) do
		local bc, bx, by = WorldPos(b.m, b.x, b.y)
		if pc and bc and bc == pc then
			local d = math.sqrt((bx - px) ^ 2 + (by - py) ^ 2) * (b.guide and 1.5 or 1)
			if not bestD or d < bestD then
				best, bestD = b, d
			end
		end
	end
	return best or list[1]
end

--- Research Access: where to go first. Any book handed in → the librarian offers it; a book in your bags → hand it
--- in; else → the nearest book, never the librarian with empty hands.
local function BookStep(e)
	for _, q in ipairs(BOOK_QUESTS) do
		if Done(q) then
			return { kind = "get", place = e.from, q = e.q }
		end
	end
	local who = NpcName(e.from)
	for _, id in ipairs(BOOK_ITEMS) do
		if HaveItem(id) then
			return { kind = "do", place = e.from, q = e.q,
				text = ns:L("FCQ_MA_BOOK_HANDIN_FMT"):format(ItemName(id), who) }
		end
	end
	local b = NearestBook()
	if not b then
		return { kind = "do", place = nil, q = e.q, text = ns:L("FCQ_MA_BOOK_UNKNOWN") }
	end
	return { kind = "do", place = { m = b.m, x = b.x, y = b.y }, q = e.q,
		text = ns:L("FCQ_MA_BOOK_GET_FMT"):format(ItemName(b.item, b.name), who)
			.. (b.guide and ns:L("FCQ_MA_BOOK_GUIDE") or "") }
end

local function MoneyText(c)
	local S = ns.ForeverStyle
	if S and S.Money then
		return S.Money(c)
	end
	return tostring(math.floor(c / 10000)) .. "g"
end

local function MapNow()
	if C_Map and C_Map.GetBestMapForUnit then
		local ok, m = pcall(C_Map.GetBestMapForUnit, "player")
		if ok then
			return m
		end
	end
	return nil
end

--- e.pre: what you need before the destination makes sense. Each entry, checked while the quest is in your log:
---   { gold = copper, unlessItem = id, at = place } — not enough money (and not yet bought the item it pays for);
---   { items = { ids }, place, textKey, unlessMap = mapID } — none of the items in your bags (unless you are on that map:
---     the potions get used up in Jaedenar, so in Felwood an empty bag is no reason to go back);
---   { allItems = { ids }, place, textKey } — every one of the items is needed;
---   { spell = id or { ids }, place, textKey } — a spell rank the quest asks for (any of the ids known is enough).
--- onlyMap = mapID: only checked while you are on that map (where you can buy it). turn = true: only checked once the
--- objectives are done (the gold you pay at the hand-in), else before them.
--- @return a "do" step, or nil when nothing is missing
local function PreStep(e, q, atTurn)
	local here
	for _, p in ipairs(e.pre or {}) do
		if p.onlyMap then
			here = here or MapNow() or -1
		end
		if (p.turn == true) ~= (atTurn == true) or (p.onlyMap and here ~= p.onlyMap) then
			-- not this phase / not on the map where it can be fixed
		elseif p.allItems then
			for _, id in ipairs(p.allItems) do
				if not HaveItem(id) then
					return { kind = "do", place = p.place, q = q, textKey = p.textKey }
				end
			end
		elseif p.gold then
			local have = GetMoney and GetMoney() or 0
			if have < p.gold and not (p.unlessItem and HaveItem(p.unlessItem)) then
				-- Ur'dan has no npc name in our data: then the zone ("Felwood").
				local where = (p.at and p.at.npc and NpcName(p.at)) or (p.at and ZoneName(p.at.m)) or "?"
				return { kind = "do", place = nil, q = q, text = ns:L("FCQ_PRE_GOLD_FMT"):format(MoneyText(p.gold),
					where, MoneyText(have)) }
			end
		elseif p.items then
			local any = false
			for _, id in ipairs(p.items) do
				if HaveItem(id) then
					any = true
				end
			end
			-- unlessDone = { quest ids }: the items went with one of these quests (handed in), so nothing is missing
			-- (Orahil's shard quests, second check 18 Nov 2026).
			for _, dq in ipairs(p.unlessDone or {}) do
				if Done(dq) then
					any = true
				end
			end
			if not any and not (p.unlessMap and MapNow() == p.unlessMap) then
				return { kind = "do", place = p.place, q = q, textKey = p.textKey }
			end
		elseif p.spell then
			local known = false
			for _, id in ipairs(type(p.spell) == "table" and p.spell or { p.spell }) do
				if Known(id) then
					known = true
				end
			end
			if not known then
				return { kind = "do", place = p.place, q = q, textKey = p.textKey }
			end
		end
	end
	return nil
end

local function StepRaw(c)
	if c.spell and Known(c.spell) then
		return nil, "spell known"
	end
	local e = Current(c)
	if not e then
		return nil, "all quests done"
	end
	-- Strict chains run quests side by side (Fable check, 18 Nov 2026): the warlock takes 7626-7628 from Mor'zul and 7623
	-- from Gorzeeki together, and then 7626 is "current" — so 7623's "first buy Shadowy Potions here" never showed. A
	-- "buy it here" warning (a pre with onlyMap) of ANY quest of the chain in your log now comes first.
	if c.strict then
		for _, o in ipairs(c.quests) do
			local oq = (o ~= e) and not AnyDone(o) and LogQuest(o)
			if oq then
				for _, p in ipairs(o.pre or {}) do
					if p.onlyMap then
						local s = PreStep({ pre = { p } }, oq)
						if s then
							return s
						end
					end
				end
			end
		end
	end
	local q = LogQuest(e)
	if not q then
		-- e.book: Research Access, see BookStep (18 Nov 2026). A failure falls back to the wait text below.
		if e.book then
			local ok, s = pcall(BookStep, e)
			if ok and s then
				return s
			end
		end
		-- e.wait: a quest that is only offered later (rogue: after a letter from C), so "get the quest" would send the
		-- player to a place where nothing is yet. The text says to wait (17 Nov 2026).
		if e.wait then
			return { kind = "wait", place = e.from, textKey = e.wait, q = e.q }
		end
		-- e.item: the quest starts from that item in your bags (paladin tomes, 17 Nov 2026; ItemSparse StartQuestID).
		if e.item and HaveItem(e.item) then
			return { kind = "use", place = e.from, item = e.item, q = e.q }
		end
		return { kind = "get", place = e.from, q = e.q }
	end
	local pre = PreStep(e, q)
	if pre then
		return pre
	end
	if e.objs and not ObjDone(q) then
		for _, o in ipairs(e.objs) do
			if not ObjFinished(q, o) then
				return { kind = "do", place = o.place, textKey = o.textKey, q = q }
			end
		end
	end
	local preTurn = PreStep(e, q, true)
	if preTurn then
		return preTurn
	end
	return { kind = "turn", place = e.to, q = q }
end

--------------------------------------------------------------------------------
-- Where a trainer stands (Rob 22 Nov 2026 via sparring, verbatim: "Plekken b"; his choice of 7 Nov for the trainer arrow).
-- The places in this file hold no copy of HandyNotes: Class Trainers (All Rights Reserved). Rank, as in ForeverTrainer.lua:
--   Rob's measurement (measured in FOREVER_TRAINER_SPOTS) > where you talked to that trainer > /mh trainer here >
--   HandyNotes: Class Trainers, read while you play and stored nowhere > this file (p.z = Zygor, p.w = Wowhead).
-- A place keeps p.static, so a better place is not a new step for the card. /mh classquest says the source.
--------------------------------------------------------------------------------
local LivePlace
do
	local function Spot(npc, map)
		local known = false
		for _, list in pairs(ns.FOREVER_TRAINER_SPOTS or {}) do
			for _, s in ipairs(list) do
				if s.npc == npc then
					known = true
					if s.measured and s.map == map then
						return true, s.x, s.y
					end
				end
			end
		end
		return known
	end
	local function Yours(npc, map)
		local db = type(ns.db) == "table" and ns.db.foreverTrainerSpots
		if type(db) ~= "table" then
			return nil
		end
		for key, list in pairs(db) do
			if type(list) == "table" and not tostring(key):find("^PROF_") then
				for _, s in ipairs(list) do
					if s.npc == npc and s.map == map and s.x and s.y then
						return s.x, s.y
					end
				end
			end
		end
		return nil
	end
	local function Best(p)
		local known, x, y = Spot(p.id, p.m)
		if x then
			return x, y, "Rob measured"
		end
		local hx, hy, why
		if ns.ForeverHandyNotesPlace then
			local ok, a, b, c = pcall(ns.ForeverHandyNotesPlace, p.id, p.m)
			if ok then
				hx, hy, why = a, b, c
			else
				why = "unreadable"
			end
		end
		local trainer = known or p.z or p.w or hx
		if not trainer then
			return nil
		end
		if ns.ForeverSeenPlace then
			local sx, sy = ns.ForeverSeenPlace(p.id, p.m)
			if sx then
				return sx, sy, "seen: where you talked to this trainer"
			end
		end
		local yx, yy = Yours(p.id, p.m)
		if yx then
			return yx, yy, "yours: /mh trainer here"
		end
		if hx then
			return hx, hy, "HandyNotes: Class Trainers (read live)"
		end
		return nil, nil, why
	end
	--- @return the place to use: p itself, or a copy with a better x, y (src = where that came from).
	LivePlace = function(p)
		if not (p and p.id) then
			return p
		end
		local ok, x, y, src = pcall(Best, p)
		if not ok then
			x, y, src = nil, nil, "reading failed"
		end
		local list = (p.z and "Zygor") or (p.w and "Wowhead") or "MH's own list"
		local out = { static = p }
		for k, v in pairs(p) do
			out[k] = v
		end
		if x and y then
			out.x, out.y, out.src = x, y, src
		elseif not (p.x and p.y) and ns.ForeverQuestieNpcPlace then
			-- 23 Nov 2026 (Rob via sparring: "Ik volg jullie advies weer."): the very last step, only when this file has no
			-- place at all: QuestieDB read live (ForeverQuestieDB.lua). Today every place here has x, y (268 of 268).
			local okQ, qm, qx, qy = pcall(ns.ForeverQuestieNpcPlace, p.id, p.m)
			if okQ and qm then
				out.m, out.x, out.y, out.src = qm, qx, qy, "QuestieDB (read live)"
			else
				out.src = list
			end
		else
			out.src = list .. (src and (" (HandyNotes: Class Trainers: " .. src .. ")") or "")
		end
		return out
	end
end

local function Step(c)
	local s, why = StepRaw(c)
	if s and s.place then
		s.place = LivePlace(s.place)
	end
	return s, why
end

-- The client's own title of a quest. It arrives late the first time: asked for once, and the card looks again on
-- QUEST_DATA_LOAD_RESULT (as ForeverDungeonQuests.lua does).
local titleAsked = {}
local function QuestTitle(q)
	if not (q and C_QuestLog) then
		return nil
	end
	if C_QuestLog.GetTitleForQuestID then
		local ok, v = pcall(C_QuestLog.GetTitleForQuestID, q)
		if ok and type(v) == "string" and v ~= "" then
			return v
		end
	end
	if not titleAsked[q] and C_QuestLog.RequestLoadQuestByID then
		titleAsked[q] = true
		pcall(C_QuestLog.RequestLoadQuestByID, q)
	end
	return nil
end

local function ChainName(c)
	-- A level 1 note is one quest: its own name, as the client says it.
	if c.note then
		return QuestTitle(c.quests[1].q) or ns:L("FCQ_CHAIN_NOTE")
	end
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
	elseif s.kind == "use" then
		local name
		if C_Item and C_Item.GetItemNameByID then
			local ok, n = pcall(C_Item.GetItemNameByID, s.item)
			name = ok and n or nil
		end
		return ns:L("FCQ_USE_ITEM_FMT"):format(name or ("#" .. tostring(s.item)))
	elseif s.kind == "do" or s.kind == "wait" then
		return (s.text or ns:L(s.textKey)) .. (p and (" — " .. Where(p)) or "")
	end
	return ns:L("FCQ_TURN_FMT"):format(NpcName(p), Where(p))
end

local function StepText(c, s)
	return ns:L("FCQ_LINE_FMT"):format(ChainName(c), c.level, StepWhat(s))
end

--- For "Do this now": the line for the first chain you can do now, and its step (for the arrow).
-- An item chain (no spell: a weapon, a trinket) is optional. 17 Nov 2026 (Sparring 17-11, a read-only check): one
-- that is skipped would sit on top of "Do this now" for ever. So spell chains come first, and an item chain only
-- shows until this many levels above its start (its reward is outgrown by then; AFGELEID, Rob may change the number).
local ITEM_CHAIN_SPAN = 10

--- Why a chain is (not) shown in "Do this now"; nil = it can be shown.
local function NowSkip(c, level)
	if not Ready(c, level) then
		return "not open yet"
	end
	-- Never hide one you are in the middle of (a quest of it in your log; Fable check: Cyclonian is a level 40 elite).
	local inLog = false
	for _, e in ipairs(c.quests) do
		if LogQuest(e) then
			inLog = true
			break
		end
	end
	if c.note then
		if level > c.last and (c.intro or not inLog) then
			return ("level 1 note, shown up to level %d"):format(c.last)
		end
	elseif not c.spell and not c.always and level > c.level + ITEM_CHAIN_SPAN and not inLog then
		return ("item chain, you are more than %d levels past it"):format(ITEM_CHAIN_SPAN)
	end
	return nil
end

local function NowPick()
	local level = UnitLevel and UnitLevel("player") or 1
	local chains = MyChains()
	-- Pass 1: spell chains; 2: the level 1 notes (22 Nov 2026, never before a spell chain); 3: item chains; 4: the low
	-- ones (c.low, mage Study).
	for pass = 1, 4 do
		for _, c in ipairs(chains) do
			local own = (c.low and 4) or (c.spell and 1) or (c.note and 2) or 3
			if own == pass and not NowSkip(c, level) then
				local s = Step(c)
				if s then
					return c, s
				end
			end
		end
	end
	return nil
end

--- @return line, step, low (true = a low-priority chain: "Do this now" lists it as a tip, after the to-dos)
function ns.ForeverClassQuestNow()
	local c, s = NowPick()
	if c then
		return StepText(c, s), s, c.low == true
	end
	return nil
end

--- 17 Nov 2026 (the new overview, ForeverOverview.lua): the same step in parts, so a card can show a title, what to do
--- and the place on its own line (Rob: coordinates out of the sentence, an arrow button per place).
--- @return { chain, level, kind, npc, zone, x, y, what } or nil
function ns.ForeverClassQuestNowParts()
	local c, s = NowPick()
	if not c then
		return nil
	end
	local p = s.place
	local out = { chain = ChainName(c), level = c.level, kind = s.kind }
	if p then
		out.npc = p.npc and NpcName(p) or nil
		out.zone, out.x, out.y = ZoneName(p.m), p.x, p.y
	end
	if s.kind == "do" or s.kind == "wait" then
		out.what = s.text or ns:L(s.textKey)
	elseif s.kind == "use" then
		out.what = StepWhat(s)
	end
	return out
end

--- The same step for the small card (22 Nov 2026, Rob: "b"): short lines.
--- @return { id, level, title, who, place, note } or nil
local function CardData()
	local c, s = NowPick()
	if not c then
		return nil
	end
	local p, who = s.place, nil
	if s.kind == "get" then
		who = ns:L("FCQ_CARD_GET_FMT"):format(NpcName(p))
	elseif s.kind == "turn" then
		who = ns:L("FOV_CQ_TURN_FMT"):format(NpcName(p))
	elseif s.kind == "use" then
		who = StepWhat(s)
	else
		who = s.text or ns:L(s.textKey)
	end
	local where = p and ZoneName(p.m) or nil
	if p and p.m == MOONGLADE and Known(TELEPORT_MOONGLADE) then
		where = where .. ns:L("FCQ_MOONGLADE_TIP")
	end
	local note
	if c.note then
		note = ns:L("FCQ_CARD_NOTE")
	elseif c.spell then
		note = ns:L("FCQ_CARD_SPELL_FMT"):format(SpellName(c.spell))
	else
		note = ns:L("FCQ_CARD_FOR_FMT"):format(ChainName(c))
	end
	local at = p and (p.static or p)
	return {
		-- Which step this is, whatever the words say (a name or an item that loads late is not a new step).
		id = table.concat({ c.key, tostring(s.q), s.kind, tostring(s.textKey), p and tostring(p.m) or "-",
			at and tostring(at.x) or "-", at and tostring(at.y) or "-" }, "|"),
		level = c.level,
		title = QuestTitle(s.q) or ChainName(c),
		who = who,
		place = where,
		note = note,
	}
end

--- Route to a place of a chain and say `line` in chat. Shared by "Do this now" and the overview page (17 Nov 2026).
local function GoPlace(p, line)
	if not p then
		-- Something to collect anywhere (Earthroot): no spot to point at, the line says what to do.
		print(PREFIX .. line)
		return false
	end
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(p.m, p.x, p.y)) then
		if not ns._mhWaypointYielded then -- the Forever Leveling Guide steers: Core already said why
			print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		end
		return false
	end
	ns.lastTarget = { mapID = p.m, x = p.x, y = p.y, name = p.npc and NpcName(p) or ZoneName(p.m), via = "/mh classquest", arriveYards = 15 }
	ns._mhRouteOwner = "waypoint"
	print(PREFIX .. line)
	return true
end

--- The arrow to the current step.
function ns.ForeverClassQuestGo()
	local line, s = ns.ForeverClassQuestNow()
	if not s then
		print(PREFIX .. ns:L("FCQ_NOTHING"))
		return false
	end
	return GoPlace(s.place, line)
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
	local level = UnitLevel and UnitLevel("player") or 1
	for _, c in ipairs(chains) do
		local s, why = Step(c)
		local skip = NowSkip(c, level)
		print(("  %s (level %d, spell %s known: %s): %s%s"):format(ChainName(c), c.level, tostring(c.spell),
			c.spell and tostring(Known(c.spell)) or "-", s and (s.kind .. " quest " .. s.q) or why,
			skip and (" — not in Do this now: " .. skip) or ""))
		if s and s.place and s.place.src then
			print(("    place of %s from: %s"):format(NpcName(s.place), s.place.src))
		end
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
	if ns.ForeverCQWindowLine then
		print("  " .. ns.ForeverCQWindowLine())
	end
end

--- 17 Nov 2026 (overview card + Class quests page): every class quest of this character as data, in table order:
--- { { chain, level, state = "done"|"now"|"later", spell, kind, npc, what, zone, x, y, go }, … }; empty when the class
--- has none. "now" = the current step; "later" = who starts it and where (the first quest's giver, kind "get").
--- go = a function that sets the arrow there (nil without a place).
function ns.ForeverClassQuestList()
	local out = {}
	local level = UnitLevel and UnitLevel("player") or 1
	local chains = {}
	for _, c in ipairs(MyChains()) do
		if Listed(c, level) then
			chains[#chains + 1] = c
		end
	end
	for _, c in ipairs(chains) do
		local s = Step(c)
		local e = { chain = ChainName(c), level = c.level, spell = c.spell,
			state = (not s and "done") or (not Ready(c, level) and "later") or "now" }
		-- Same parts as ForeverClassQuestNowParts: kind, npc, and `what` only for a step that is not "go to someone"
		-- (the place is its own line on the page, so it is not in the sentence).
		local p
		if e.state == "now" then
			p = s.place
			e.kind = s.kind
			-- 19 Nov 2026 (tooltips, Rob: "Op beide vragen ja"): the quest of this step and the item a "use" step names, so
			-- the page can show the game's own tooltips for them.
			e.quest = s.q
			e.item = s.kind == "use" and s.item or nil
			if s.kind == "do" or s.kind == "wait" then
				e.what = s.text or ns:L(s.textKey)
			elseif s.kind == "use" then
				e.what = StepWhat(s)
			end
			local line = StepText(c, s)
			e.go = function()
				return GoPlace(p, line)
			end
		elseif e.state == "later" then
			p = LivePlace(c.quests[1] and c.quests[1].from)
			e.quest = c.quests[1] and c.quests[1].q
			if p then
				e.kind = "get"
				local line = ("%s: %s"):format(e.chain, ns:L("FCQ_ST_LATER_FMT"):format(NpcName(p), ZoneName(p.m)))
				e.go = function()
					return GoPlace(p, line)
				end
			end
		end
		if p then
			e.npc = p.npc and NpcName(p) or nil
			e.zone, e.x, e.y = ZoneName(p.m), p.x, p.y
		end
		out[#out + 1] = e
	end
	return out
end

--- For "How you play": every class quest of this character, with where it stands. nil when the class has none.
function ns.ForeverClassQuestOverview()
	local chains = MyChains()
	if #chains == 0 then
		return nil
	end
	local level = UnitLevel and UnitLevel("player") or 1
	local lines = { ns:L("FCQ_HOWTO_INTRO") }
	local listed = {}
	for _, c in ipairs(chains) do
		if Listed(c, level) then
			listed[#listed + 1] = c
		end
	end
	if #listed == 0 then
		return nil
	end
	for _, c in ipairs(listed) do
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

--------------------------------------------------------------------------------
-- A small window with only the class quest step you are on (Rob, 19 Nov 2026, doing the mage quest: "ik moet heel goed
-- lezen in Do This Now wat ik precies moet doen. En, ja, het valt een beetje weg. Kunnen we misschien de optie maken
-- dat we een extra venstertje krijgen wat we los kunnen plaatsen. Al dan niet met een aan- en uitknop in onze
-- settings." → "Doe het nu maar."). Since 22 Nov 2026 a card (Rob via sparring: "b"): class icon and border in the
-- class colour, the quest's own name, who, where, what the step is for, and Show the way.
-- It follows the step by itself; no step = hidden. Movable (place remembered), Shift+scroll = size; the cross hides it
-- until the step changes, Escape until the next quest update. Switch in Quiet helpers, on by default: ns.db.foreverCQWindow ~= false.
-- Silence rule: /mh classquest prints whether it shows and why.
--------------------------------------------------------------------------------
local CQW_W, CQW_ICON, CQW_LEFT = 340, 40, 62
local cqw
local cqwWhy = "not looked yet"
local cqwClosedFor -- the id of the step the player closed the window on

function ns.IsForeverCQWindowOn()
	return not (type(ns.db) == "table" and ns.db.foreverCQWindow == false)
end

local CQWUpdate -- forward

function ns.SetForeverCQWindow(on)
	if type(ns.db) ~= "table" then
		return
	end
	-- plain branches, not `and false or` (lint [29])
	if on then
		ns.db.foreverCQWindow = nil
		cqwClosedFor = nil
	else
		ns.db.foreverCQWindow = false
	end
	CQWUpdate()
end

local function CQWBuild()
	if cqw then
		return cqw
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverClassQuestWindow", UIParent, "BackdropTemplate")
	f:SetSize(CQW_W, 130)
	f:SetFrameStrata("MEDIUM")
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	local pos = type(ns.db) == "table" and ns.db.foreverCQWindowPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 40, -220)
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		if type(ns.db) == "table" then
			local p, _, rp, x, y = self:GetPoint(1)
			ns.db.foreverCQWindowPos = { p, rp, x, y }
		end
	end)
	local Style = ns.ForeverStyle
	local t = Style.T()
	local r, g, b = Style.Accent()
	local _, token = UnitClass("player")
	f.icon = f:CreateTexture(nil, "ARTWORK")
	f.icon:SetSize(CQW_ICON, CQW_ICON)
	f.icon:SetPoint("TOPLEFT", 12, -12)
	if token then
		f.icon:SetTexture("Interface\\Icons\\ClassIcon_" .. token:sub(1, 1) .. token:sub(2):lower())
	end
	local width = CQW_W - CQW_LEFT - 12
	local function line(role, size, color, w)
		local fs = Style.Text(f, role, size, color)
		fs._mhSkinned = true -- its own font and colour: the window skin leaves it alone
		fs:SetJustifyV("TOP")
		fs:SetWidth(w or width)
		return fs
	end
	f.head = line("head2", 13, { r, g, b }, width - 20) -- free of the cross
	f.title = line("head2", 19, t.gold)
	f.who = line("text", 15, t.text)
	f.where = line("text", 14, t.dim)
	f.note = line("text", 13, t.label, CQW_W - 24)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)
	close:SetScale(0.8)
	close:HookScript("OnClick", function()
		cqwClosedFor = f.stepId -- back with the next step
	end)
	f.go = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.go:SetSize(130, 22)
	f.go:SetPoint("BOTTOMRIGHT", -10, 10)
	f.go:SetText(ns:L("FCQ_BTN"))
	f.go:SetScript("OnClick", function()
		ns.ForeverClassQuestGo()
	end)
	function f:Fit()
		local y = 12
		for _, row in ipairs({ { self.head, 2 }, { self.title, 4 }, { self.who, 2 }, { self.where, 0 } }) do
			local fs = row[1]
			fs:ClearAllPoints()
			fs:SetPoint("TOPLEFT", CQW_LEFT, -y)
			if (fs:GetText() or "") ~= "" then
				y = y + (fs:GetStringHeight() or 14) + row[2]
			end
		end
		y = math.max(y, 12 + CQW_ICON) + 10
		self.note:ClearAllPoints()
		self.note:SetPoint("TOPLEFT", 12, -y)
		y = y + (self.note:GetStringHeight() or 13) + 8
		local label = self.go:GetFontString()
		self.go:SetWidth(math.max(130, (label and label:GetStringWidth() or 0) + 24))
		self:SetHeight(y + 22 + 10)
	end
	Style.SkinOnShow(f)
	-- After the skin: its first pass draws a gold border, its late pass (0.1 s) sets the fonts again.
	f:HookScript("OnShow", function(self)
		self:SetBackdropBorderColor(r, g, b, 1)
		self:Fit()
		C_Timer.After(0.15, function()
			if self:IsShown() then
				self:Fit()
			end
		end)
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- Shift+scroll = size (every MH window), Escape closes
	end
	-- Only the cross keeps it away for this step. Escape (which closes every MH window at once, also when you only
	-- wanted to close the map) hides it until the next quest update brings it back.
	f:Hide()
	cqw = f
	return f
end

local function CQWHide(why)
	cqwWhy = why
	if cqw and cqw:IsShown() then
		cqw:Hide()
	end
end

CQWUpdate = function()
	if not ns.IsForeverCQWindowOn() then
		return CQWHide("switched off (Quiet helpers)")
	end
	local ok, d = pcall(CardData)
	if not ok or not d then
		return CQWHide(ok and "no class quest step right now" or ("error: " .. tostring(d)))
	end
	if cqwClosedFor == d.id then
		return CQWHide("you closed it on this step; it comes back with the next one")
	end
	cqwClosedFor = nil
	local f = CQWBuild()
	-- The class name as the client says it; capitals only for plain ASCII (the small-caps font does the rest).
	local head = ("%s · %s"):format((UnitClass("player")) or "", ns:L("FOV_LEVEL_FMT"):format(d.level))
	if not head:gsub("·", ""):find("[\128-\255]") then
		head = head:upper()
	end
	f.head:SetText(head)
	f.title:SetText(d.title)
	f.who:SetText(d.who)
	f.where:SetText(d.place or "")
	f.note:SetText(d.note)
	f.go:SetShown(d.place ~= nil)
	f.stepId = d.id
	f:Fit()
	f:Show()
	cqwWhy = "shown: " .. d.title
end

do
	local pending = false
	local function Soon()
		if pending then
			return
		end
		pending = true
		C_Timer.After(0.5, function()
			pending = false
			CQWUpdate()
		end)
	end
	local ev = CreateFrame("Frame")
	for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "QUEST_LOG_UPDATE", "QUEST_ACCEPTED", "QUEST_TURNED_IN",
		"PLAYER_LEVEL_UP", "SPELLS_CHANGED", "BAG_UPDATE_DELAYED", "QUEST_DATA_LOAD_RESULT" }) do
		pcall(ev.RegisterEvent, ev, e)
	end
	ev:SetScript("OnEvent", Soon)
end

function ns.ForeverCQWindowLine()
	return ("small step window: %s (Quiet helpers); %s"):format(ns.IsForeverCQWindowOn() and "on" or "off", cqwWhy)
end
