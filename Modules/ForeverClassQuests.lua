local _, ns = ...

--[[
	ForeverClassQuests.lua — WoW Forever: class quests that unlock something, step by step, with the arrow.

	Rob, 16 Nov 2026 (via sparring), letterlijk: "Carola is net, of die kan al beervorm krijgen, maar we weten niet hoe.
	Ik weet dat er een questlijn is … Maar begin inderdaad met de Druid, dan kan ze daar zo meteen alvast mee beginnen."
	First chain: Druid Bear Form (level 10), Alliance (Night Elf) and Horde (Tauren). Same day (Bouwchat 16-11 (2)): Cure
	Poison (14), Aquatic Form (16) and Torwa Pathfinder (50), with steps inside a quest (objs) and other starter quests (alt),
	plus a block in How you play (ns.ForeverClassQuestOverview). Cat Form (20) is a NEW Forever quest chain (98393…,
	Wowhead) that Zygor does not have: built from Wowhead tooltips + the Spoken addon's quest data (see Cat() below).

	Source: the Forever Zygor guide "Leveling Guides\Druid Class Quests" (ZygorLevelingAllianceCLASSIC.lua:21298-21367,
	ZygorLevelingHordeCLASSIC.lua:22584-22663; GEMETEN in the guide files 16 Nov 2026). Coordinates are Zygor's (rule:
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
				{ q = 6002, from = P.turak, objs = { O(P.lunaclawH, "FCQ_OBJ_LUNACLAW", 1) }, to = P.turak },
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
	local out = {}
	for _, c in ipairs(CHAINS[token] or {}) do
		if c.faction == faction and (not c.races or (race and c.races[race])) then
			out[#out + 1] = c
		end
	end
	-- Lowest level first, so "Do this now" names the oldest open chain (the table order is not the level order).
	table.sort(out, function(a, b)
		return a.level < b.level
	end)
	return out
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
	elseif s.kind == "do" then
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
		if level >= c.level then
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
		elseif level < c.level then
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
