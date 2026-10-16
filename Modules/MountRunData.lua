local _, ns = ...

--[[
	Data for the Mount run window (MountRun.lua). mh-research 15 Oct 2026:
	  - mountID, instance map id, journal instance id, difficulties, boss names: wago.tools DB2, build 12.1.5.70391
	    (Mount, Map, MapDifficulty, JournalItemXDifficulty, DungeonEncounter) — GEMETEN.
	  - entrance x/y: Blizzard's JournalInstanceEntrance converted to the zone map (AFGELEID conversion, checked against
	    HandyNotes_MapNotes within ~0.7). At runtime MountRun asks C_EncounterJournal.GetDungeonEntrancesForMap first,
	    so the client's own pin wins whenever it has one.
	  - chances: Wowhead drop data, read 15 Oct 2026, per kill, lifetime (periods with boosted drops inflate the
	    Draenor/Legion Mythic numbers; those carry a "*").
	  - routes (MOUNTRUN_HOW_*): Zygor LibRover data_transit.lua (25 Aug 2026) + HandyNotes capitals (7 Oct 2026).
	Uncertain, to measure in game: whether Heroic 5-mans show in GetSavedInstanceInfo at all; the 3-drakes /
	0-keepers / timer conditions (old Wowhead comments).
	boss = nil: no usable encounter name (Bronze Drake, Vault of Archavon's four bosses) → a full clear counts as done.
	faction on a mount: only that faction's version is shown (Grand Black War Mammoth has one per faction).
]]

ns.MOUNTRUN_RAIDS = {
	{
		headKey = "MOUNTRUN_HEAD_NORTHREND", tabKey = "MOUNTRUN_TAB_NORTHREND",
		raids = {
			{ nameKey = "MOUNTRUN_R_OS", route = { "P_DALARAN_NR" }, instanceID = 615, journalID = 755, diffs = { 3, 4 }, boss = "Sartharion", enc = 1616,
				zoneMap = 115, x = 60.02, y = 57.02, howKey = "MOUNTRUN_HOW_OS",
				mounts = {
					{ mountID = 253, name = "Black Drake", boss = "Sartharion, 10", enc = 1616, q = "MOUNTRUN_DIFF_10", chance = "~70%" },
					{ mountID = 250, name = "Twilight Drake", boss = "Sartharion, 25", enc = 1616, q = "MOUNTRUN_DIFF_25", chance = "~75%" },
				} },
			{ nameKey = "MOUNTRUN_R_EOE", route = { "P_DALARAN_NR" }, instanceID = 616, journalID = 756, diffs = { 3, 4 }, boss = "Malygos", enc = 1617,
				zoneMap = 114, x = 27.52, y = 26.74, howKey = "MOUNTRUN_HOW_EOE",
				mounts = {
					{ mountID = 246, name = "Azure Drake", boss = "Malygos", enc = 1617, chance = "2-3.5%" },
					{ mountID = 247, name = "Blue Drake", boss = "Malygos", enc = 1617, chance = "2-4%" },
				} },
			{ nameKey = "MOUNTRUN_R_VOA", route = { "P_DALARAN_NR" }, instanceID = 624, journalID = 753, diffs = { 3, 4 }, boss = nil,
				zoneMap = 123, x = 50.06, y = 11.18, howKey = "MOUNTRUN_HOW_VOA",
				mounts = {
					{ mountID = 286, name = "Grand Black War Mammoth", boss = "all 4 bosses", label = "MOUNTRUN_Q_EACH_OF_4", chance = "~0.8%", faction = "Alliance" },
					{ mountID = 287, name = "Grand Black War Mammoth", boss = "all 4 bosses", label = "MOUNTRUN_Q_EACH_OF_4", chance = "~0.8%", faction = "Horde" },
				} },
			{ nameKey = "MOUNTRUN_R_ICC", route = { "P_DALARAN_NR" }, instanceID = 631, journalID = 758, diffs = { 6 }, boss = "The Lich King", enc = 1636,
				zoneMap = 118, x = 53.91, y = 87.41, howKey = "MOUNTRUN_HOW_ICC",
				mounts = {
					{ mountID = 363, name = "Invincible", boss = "The Lich King, 25 Heroic", enc = 1636, q = "MOUNTRUN_DIFF_25H", chance = "1%" },
				} },
			{ nameKey = "MOUNTRUN_R_ULDUAR", route = { "P_DALARAN_NR" }, instanceID = 603, journalID = 759, diffs = { 14 }, boss = "Yogg-Saron", enc = 1649,
				zoneMap = 120, x = 41.55, y = 17.58, howKey = "MOUNTRUN_HOW_ULDUAR",
				mounts = {
					{ mountID = 304, name = "Mimiron's Head", boss = "Yogg-Saron, 0 keepers", enc = 1649, q = "MOUNTRUN_Q_KEEPERS0", chance = "1%" },
				} },
			{ nameKey = "MOUNTRUN_R_UP", route = { "P_DALARAN_NR" }, instanceID = 575, journalID = 286, diffs = { 2 }, boss = "Skadi the Ruthless", enc = 643,
				zoneMap = 117, x = 57.29, y = 46.89, howKey = "MOUNTRUN_HOW_UP",
				mounts = {
					{ mountID = 264, name = "Blue Proto-Drake", boss = "Skadi, Heroic", enc = 643, q = "MOUNTRUN_DIFF_H", chance = "1.2%" },
				} },
		},
	},
	{
		headKey = "MOUNTRUN_HEAD_OUTLAND", tabKey = "MOUNTRUN_TAB_OUTLAND",
		raids = {
			{ nameKey = "MOUNTRUN_R_TK", route = { "P_SHATTRATH" }, instanceID = 550, journalID = 749, diffs = { 4 }, boss = "Kael'thas Sunstrider", enc = 1576,
				zoneMap = 109, x = 73.88, y = 63.74, howKey = "MOUNTRUN_HOW_TK",
				mounts = {
					{ mountID = 183, name = "Ashes of Al'ar", boss = "Kael'thas", enc = 1576, chance = "1.7%" },
				} },
			{ nameKey = "MOUNTRUN_R_SETHEKK", route = { "P_SHATTRATH" }, instanceID = 556, journalID = 252, diffs = { 2 }, boss = "Anzu", enc = 542,
				zoneMap = 108, x = 45.06, y = 65.62, howKey = "MOUNTRUN_HOW_SETHEKK",
				mounts = {
					{ mountID = 185, name = "Reins of the Raven Lord", boss = "Anzu, Heroic", enc = 542, q = "MOUNTRUN_DIFF_H", chance = "1.6%" },
				} },
			{ nameKey = "MOUNTRUN_R_MT", route = { "P_SHATTRATH", "SH_QUELDANAS" }, instanceID = 585, journalID = 249, diffs = { 2 }, boss = "Kael'thas Sunstrider", enc = 533,
				zoneMap = 122, x = 61.52, y = 31.10, howKey = "MOUNTRUN_HOW_MT",
				mounts = {
					{ mountID = 213, name = "Swift White Hawkstrider", boss = "Kael'thas, Heroic", enc = 533, q = "MOUNTRUN_DIFF_H", chance = "5.3%" },
				} },
			{ nameKey = "MOUNTRUN_R_KARA", route = { "Z_GROMGOL" }, instanceID = 532, journalID = 745, diffs = { 3 }, boss = "Attumen the Huntsman", enc = 1553,
				zoneMap = 42, x = 46.59, y = 74.11, howKey = "MOUNTRUN_HOW_KARA",
				mounts = {
					{ mountID = 168, name = "Fiery Warhorse", boss = "Attumen", enc = 1553, chance = "1.1%" },
				} },
			{ nameKey = "MOUNTRUN_R_RTK", route = { "Z_GROMGOL" }, instanceID = 1651, journalID = 860, diffs = { 23 }, boss = "Nightbane", bossKey = "MOUNTRUN_BOSS_NIGHTBANE",
				zoneMap = 42, x = 46.37, y = 70.66, howKey = "MOUNTRUN_HOW_RTK",
				mounts = {
					{ mountID = 883, name = "Smoldering Ember Wyrm", boss = "Nightbane", label = "MOUNTRUN_BOSS_NIGHTBANE", chance = "~19%" },
					{ mountID = 875, name = "Midnight", boss = "Attumen", enc = 1835, chance = "1.3%" },
				} },
			{ nameKey = "MOUNTRUN_R_COS", route = { "P_COT" }, instanceID = 595, journalID = 279, diffs = { 2 }, boss = nil,
				-- 16 Oct 2026: the portal puts you INSIDE the Caverns (74); the instance portal is on 75 (HandyNotes HD:56).
				-- Was 71 64.86/49.97, the cave mouth on the Tanaris map.
				zoneMap = 75, x = 60.11, y = 82.72, howKey = "MOUNTRUN_HOW_COS",
				mounts = {
					{ mountID = 248, name = "Bronze Drake", boss = "in time, Heroic", label = "MOUNTRUN_Q_TIMED_H", chance = "~92%" },
				} },
			{ nameKey = "MOUNTRUN_R_DS", route = { "P_COT" }, instanceID = 967, journalID = 187, diffs = { 5, 6 }, boss = "Madness of Deathwing", enc = 333,
				-- Same as Culling: map 75, HandyNotes HD:112. Zygor says 61.97/26.97 — the sources differ up to 5.9.
				zoneMap = 75, x = 60.87, y = 21.15, howKey = "MOUNTRUN_HOW_DS",
				mounts = {
					{ mountID = 444, name = "Life-Binder's Handmaiden", boss = "Deathwing, Heroic", enc = 333, q = "MOUNTRUN_DIFF_H", chance = "1-1.8%" },
					{ mountID = 442, name = "Blazing Drake", boss = "Deathwing", enc = 333, chance = "0.7-0.9%" },
					{ mountID = 445, name = "Experiment 12-B", boss = "Ultraxion", enc = 331, chance = "0.5-0.7%" },
				} },
			{ nameKey = "MOUNTRUN_R_ONY", route = { "P_COT_A" }, instanceID = 249, journalID = 760, diffs = { 3, 4 }, boss = "Onyxia", enc = 1651,
				zoneMap = 70, x = 52.90, y = 78.15, howKey = "MOUNTRUN_HOW_ONY",
				mounts = {
					{ mountID = 349, name = "Onyxian Drake", boss = "Onyxia", enc = 1651, chance = "1.3-1.7%" },
				} },
		},
	},
	{
		headKey = "MOUNTRUN_HEAD_CATA", tabKey = "MOUNTRUN_TAB_CATA",
		raids = {
			{ nameKey = "MOUNTRUN_R_FL", route = { "E_HYJAL" }, instanceID = 720, journalID = 78, diffs = { 14, 15 }, boss = "Ragnaros", enc = 198,
				zoneMap = 198, x = 47.00, y = 78.24, howKey = "MOUNTRUN_HOW_FL",
				mounts = {
					{ mountID = 425, name = "Flametalon of Alysrazor", boss = "Alysrazor", enc = 194, chance = "2.1%" },
					{ mountID = 415, name = "Pureblood Fire Hawk", boss = "Ragnaros", enc = 198, chance = "0.9-1.7%" },
				} },
			{ nameKey = "MOUNTRUN_R_T4W", route = { "E_ULDUM" }, instanceID = 754, journalID = 74, diffs = { 3, 4, 5, 6 }, boss = "Al'Akir", enc = 155,
				-- 16 Oct 2026: the Uldum portal lands on 1527 (today's Uldum), not 249 (the old phase). HandyNotes HD:108.
				zoneMap = 1527, x = 38.23, y = 80.69, howKey = "MOUNTRUN_HOW_T4W",
				mounts = {
					{ mountID = 396, name = "Drake of the South Wind", boss = "Al'Akir", enc = 155, chance = "1-2%" },
				} },
			{ nameKey = "MOUNTRUN_R_TOT", route = { "P_JADE", "TL_THUNDER" }, instanceID = 1098, journalID = 362, diffs = { 3, 4, 5, 6 }, boss = "Ji-Kun", enc = 828,
				zoneMap = 504, x = 63.82, y = 32.05, howKey = "MOUNTRUN_HOW_TOT",
				mounts = {
					{ mountID = 531, name = "Spawn of Horridon", boss = "Horridon", enc = 819, chance = "2.4%" },
					{ mountID = 543, name = "Clutch of Ji-Kun", boss = "Ji-Kun", enc = 828, chance = "2.3%" },
				} },
			{ nameKey = "MOUNTRUN_R_MSV", route = { "P_JADE" }, instanceID = 1008, journalID = 317, diffs = { 3, 4, 5, 6 }, boss = "Elegon", enc = 726,
				zoneMap = 379, x = 59.50, y = 39.34, howKey = "MOUNTRUN_HOW_MSV",
				mounts = {
					{ mountID = 478, name = "Astral Cloud Serpent", boss = "Elegon", enc = 726, chance = "0.4-2.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_SOO", route = { "P_JADE" }, instanceID = 1136, journalID = 369, diffs = { 16 }, boss = "Garrosh Hellscream", enc = 869,
				zoneMap = 390, x = 74.30, y = 41.66, howKey = "MOUNTRUN_HOW_SOO",
				mounts = {
					{ mountID = 559, name = "Kor'kron Juggernaut", boss = "Garrosh, Mythic", enc = 869, q = "MOUNTRUN_DIFF_M", chance = "2.3%" },
				} },
		},
	},
	{
		headKey = "MOUNTRUN_HEAD_MYTHIC", tabKey = "MOUNTRUN_TAB_MYTHIC",
		raids = {
			{ nameKey = "MOUNTRUN_R_HFC", route = { "P_DRAENOR", "DR_TANAAN" }, instanceID = 1448, journalID = 669, diffs = { 16 }, boss = "Archimonde", enc = 1438,
				zoneMap = 534, x = 45.22, y = 53.84, howKey = "MOUNTRUN_HOW_HFC",
				mounts = {
					{ mountID = 751, name = "Felsteel Annihilator", boss = "Archimonde, Mythic", enc = 1438, q = "MOUNTRUN_DIFF_M", chance = "7.5%*" },
				} },
			{ nameKey = "MOUNTRUN_R_BRF", route = { "P_DRAENOR" }, instanceID = 1205, journalID = 457, diffs = { 16 }, boss = "Blackhand", enc = 959,
				zoneMap = 543, x = 51.59, y = 27.11, howKey = "MOUNTRUN_HOW_BRF",
				mounts = {
					{ mountID = 613, name = "Ironhoof Destroyer", boss = "Blackhand, Mythic", enc = 959, q = "MOUNTRUN_DIFF_M", chance = "3.7%*" },
				} },
			{ nameKey = "MOUNTRUN_R_NH", route = { "P_AZSUNA" }, instanceID = 1530, journalID = 786, diffs = { 16 }, boss = "Gul'dan", enc = 1737,
				zoneMap = 680, x = 44.23, y = 59.51, howKey = "MOUNTRUN_HOW_NH",
				mounts = {
					{ mountID = 633, name = "Hellfire Infernal", boss = "Gul'dan, Mythic", enc = 1737, q = "MOUNTRUN_DIFF_M", chance = "8%*" },
					-- Same kill; also drops on Normal/Heroic (JournalItemXDifficulty 14/15/16), shown under the Mythic row.
					{ mountID = 791, name = "Felblaze Infernal", boss = "Gul'dan", enc = 1737, chance = "0.4%" },
				} },
			{ nameKey = "MOUNTRUN_R_BOD", route = { "P_BFA", "ZUL_EXIT" }, instanceID = 2070, journalID = 1176, diffs = { 16 }, boss = "Lady Jaina Proudmoore", enc = 2343,
				zoneMap = 862, x = 54.28, y = 30.03, zoneMapA = 1161, xA = 70.65, yA = 35.06, howKey = "MOUNTRUN_HOW_BOD",
				mounts = {
					{ mountID = 1219, name = "Glacial Tidestorm", boss = "Jaina, Mythic", enc = 2343, q = "MOUNTRUN_DIFF_M", chance = "0.7%" },
				} },
			{ nameKey = "MOUNTRUN_R_AMI", route = { "P_VALDRAKKEN", "VALD_DREAM" }, instanceID = 2549, journalID = 1207, diffs = { 16 }, boss = "Fyrakk the Blazing", enc = 2519,
				zoneMap = 2200, x = 27.25, y = 31.03, howKey = "MOUNTRUN_HOW_AMI",
				mounts = {
					{ mountID = 1818, name = "Anu'relos, Flame's Guidance", boss = "Fyrakk, Mythic", enc = 2519, q = "MOUNTRUN_DIFF_M", chance = "0.6%" },
				} },
			{ nameKey = "MOUNTRUN_R_SFO", route = { "P_ORIBOS", "ORI_RING", "ORI_ZERETH" }, instanceID = 2481, journalID = 1195, diffs = { 16 }, boss = "The Jailer", enc = 2464,
				zoneMap = 1970, x = 81.00, y = 53.33, howKey = "MOUNTRUN_HOW_SFO",
				mounts = {
					{ mountID = 1587, name = "Zereth Overseer", boss = "The Jailer, Mythic", enc = 2464, q = "MOUNTRUN_DIFF_M", chance = "0.9%" },
				} },
		},
	},
	-- 15 Oct 2026, later (Rob: "alles, ook diegene die een groep benodigen"): second mh-research pass, same sources
	-- (wago 12.1.5.70391; Midnight/Manaforge entrances from AreaPOI because they have no JournalInstanceEntrance row).
	-- Measured corrections: Living/Felblaze Infernal and Sureki Skyrazor / Prototype A.S.M.R. drop on every difficulty;
	-- the Mythic-only mounts are Ascendant Skyrazor and The Big G; G.M.O.D. is Mekkatorque on N/H/M; Kith'ix, Voidspire
	-- and Dreamrift have NO mount. boss may be a list: the lockout name can differ from the journal name (AFGELEID).
	{
		headKey = "MOUNTRUN_HEAD_LEGION_SL", tabKey = "MOUNTRUN_TAB_LEGION_SL",
		raids = {
			{ nameKey = "MOUNTRUN_R_TOS", route = { "P_AZSUNA" }, instanceID = 1676, journalID = 875, diffs = { 14, 15, 16, 17 }, boss = "Mistress Sassz'ine", enc = 1861,
				zoneMap = 646, x = 64.97, y = 20.26, howKey = "MOUNTRUN_HOW_TOS",
				mounts = {
					{ mountID = 899, name = "Abyss Worm", boss = "Mistress Sassz'ine, any difficulty", enc = 1861, q = "MOUNTRUN_Q_ANY", chance = "0.1-0.3%" },
				} },
			{ nameKey = "MOUNTRUN_R_ANT", route = { "P_AZSUNA", "LEG_BEACON" }, instanceID = 1712, journalID = 946, diffs = { 14, 15, 16, 17 }, boss = "Felhounds of Sargeras", enc = 1987,
				zoneMap = 885, x = 54.70, y = 62.80, howKey = "MOUNTRUN_HOW_ANT",
				mounts = {
					{ mountID = 971, name = "Antoran Charhound", boss = "Felhounds, any difficulty", enc = 1987, q = "MOUNTRUN_Q_ANY", chance = "?" },
				} },
			{ nameKey = "MOUNTRUN_R_ANT_ARGUS", route = { "P_AZSUNA", "LEG_BEACON" }, instanceID = 1712, journalID = 946, diffs = { 16 }, boss = "Argus the Unmaker", enc = 2031,
				zoneMap = 885, x = 54.70, y = 62.80, howKey = "MOUNTRUN_HOW_ANT_ARGUS",
				mounts = {
					{ mountID = 954, name = "Shackled Ur'zul", boss = "Argus, Mythic", enc = 2031, q = "MOUNTRUN_DIFF_M", chance = "~0.8%" },
				} },
			{ nameKey = "MOUNTRUN_R_SOD", route = { "P_ORIBOS", "ORI_RING", "ORI_MAW" }, instanceID = 2450, journalID = 1193, diffs = { 16 }, boss = "Sylvanas Windrunner", enc = 2441,
				zoneMap = 1543, x = 69.75, y = 32.01, howKey = "MOUNTRUN_HOW_SOD",
				mounts = {
					{ mountID = 1471, name = "Vengeance", boss = "Sylvanas, Mythic", enc = 2441, q = "MOUNTRUN_DIFF_M", chance = "~0.5%" },
				} },
			{ nameKey = "MOUNTRUN_R_NYA", route = { "E_ULDUM" }, instanceID = 2217, journalID = 1180, diffs = { 16 }, boss = "N'Zoth the Corruptor", enc = 2375,
				zoneMap = 1527, x = 55.18, y = 43.96, howKey = "MOUNTRUN_HOW_NYA",
				mounts = {
					{ mountID = 1293, name = "Ny'alotha Allseer", boss = "N'Zoth, Mythic", enc = 2375, q = "MOUNTRUN_DIFF_M", chance = "~0.7%" },
				} },
			{ nameKey = "MOUNTRUN_R_BOD_GMOD", route = { "P_BFA", "ZUL_EXIT" }, instanceID = 2070, journalID = 1176, diffs = { 14, 15, 16 },
				boss = { "Mekkatorque", "High Tinker Mekkatorque" }, enc = 2334,
				zoneMap = 862, x = 54.28, y = 30.03, zoneMapA = 1161, xA = 70.65, yA = 35.06, howKey = "MOUNTRUN_HOW_BOD_GMOD",
				mounts = {
					{ mountID = 1217, name = "G.M.O.D.", boss = "Mekkatorque, Normal/Heroic/Mythic", enc = 2334, q = "MOUNTRUN_Q_NHM", chance = "?" },
				} },
		},
	},
	{
		headKey = "MOUNTRUN_HEAD_DUNGEONS", tabKey = "MOUNTRUN_TAB_DUNGEONS",
		raids = {
			-- No journalID: DB2 puts the Service Entrance's journal entrance on the Main Gate, so the client pin would point
			-- at the wrong door. The coordinate is HandyNotes_MapNotes' Service Entrance.
			{ nameKey = "MOUNTRUN_R_STRAT", route = { "Z_TIRISFAL", "TRAM_IF" }, instanceID = 329, diffs = { 1 }, boss = "Lord Aurius Rivendare", enc = 456,
				zoneMap = 23, x = 43.25, y = 18.54, howKey = "MOUNTRUN_HOW_STRAT",
				mounts = {
					{ mountID = 69, name = "Rivendare's Deathcharger", boss = "Rivendare", enc = 456, chance = "0.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_VP", route = { "E_ULDUM" }, instanceID = 657, journalID = 68, diffs = { 1, 2 }, boss = "Altairus", enc = 115,
				-- Same as Throne of the Four Winds: 1527, HandyNotes HD:64.
				zoneMap = 1527, x = 76.70, y = 84.35, howKey = "MOUNTRUN_HOW_VP",
				mounts = {
					{ mountID = 395, name = "Drake of the North Wind", boss = "Altairus", enc = 115, chance = "0.8-0.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_SC", route = { "E_DEEPHOLM" }, instanceID = 725, journalID = 67, diffs = { 1, 2 }, boss = "Slabhide", enc = 111,
				zoneMap = 207, x = 47.83, y = 51.90, howKey = "MOUNTRUN_HOW_SC",
				mounts = {
					{ mountID = 397, name = "Vitreous Stone Drake", boss = "Slabhide", enc = 111, chance = "0.8-0.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_ZG", route = { "Z_GROMGOL" }, instanceID = 859, journalID = 76, diffs = { 2 }, boss = "High Priestess Kilnara", enc = 181,
				zoneMap = 50, x = 72.25, y = 32.91, howKey = "MOUNTRUN_HOW_ZG",
				mounts = {
					{ mountID = 410, name = "Armored Razzashi Raptor", boss = "Mandokir, Heroic", enc = 176, q = "MOUNTRUN_DIFF_H", chance = "0.7%" },
					{ mountID = 411, name = "Swift Zulian Panther", boss = "Kilnara, Heroic", enc = 181, q = "MOUNTRUN_DIFF_H", chance = "0.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_FH", route = { "P_BFA", "ZUL_EXIT", "ZUL_TIRAGARDE" }, instanceID = 1754, journalID = 1001, diffs = { 23 }, boss = { "Lord Harlan Sweete", "Harlan Sweete" }, enc = 2095,
				zoneMap = 895, x = 83.82, y = 79.25, howKey = "MOUNTRUN_HOW_FH",
				mounts = {
					{ mountID = 995, name = "Sharkbait", boss = "Harlan Sweete, Mythic", enc = 2095, q = "MOUNTRUN_DIFF_M", chance = "0.5%" },
				} },
			{ nameKey = "MOUNTRUN_R_UR", route = { "P_BFA", "ZUL_EXIT", "BOR_NAZMIR" }, instanceID = 1841, journalID = 1022, diffs = { 23 }, boss = "Unbound Abomination", enc = 2158,
				zoneMap = 863, x = 51.08, y = 64.29, howKey = "MOUNTRUN_HOW_UR",
				mounts = {
					{ mountID = 1053, name = "Underrot Crawg", boss = "Unbound Abomination, Mythic", enc = 2158, q = "MOUNTRUN_DIFF_M", chance = "0.4%" },
				} },
			{ nameKey = "MOUNTRUN_R_DOTI", route = { "P_VALDRAKKEN" }, instanceID = 2579, journalID = 1209, diffs = { 23 }, boss = "Chrono-Lord Deios", enc = 2538,
				zoneMap = 2025, x = 61.29, y = 84.73, howKey = "MOUNTRUN_HOW_DOTI",
				mounts = {
					-- A token (item 208216) that opens into a random dungeon mount: no single mountID, so no tick or cross.
					{ mountID = nil, itemID = 208216, name = "Reins of the Quantum Courser", boss = "Deios, Mythic", enc = 2538, q = "MOUNTRUN_DIFF_M", chance = "2.2%" },
				} },
		},
	},
	{
		headKey = "MOUNTRUN_HEAD_GROUP", tabKey = "MOUNTRUN_TAB_GROUP",
		raids = {
			{ nameKey = "MOUNTRUN_R_NP", route = { "P_DORNOGAL", "DORN_TUNNEL" }, instanceID = 2657, journalID = 1273, diffs = { 14, 15, 16 }, boss = "Queen Ansurek", enc = 2602, group = true,
				zoneMap = 2255, x = 43.46, y = 90.44, howKey = "MOUNTRUN_HOW_NP",
				mounts = {
					{ mountID = 2219, name = "Sureki Skyrazor", boss = "Ansurek, any difficulty", enc = 2602, q = "MOUNTRUN_Q_ANY", chance = "0.4-0.9%" },
					{ mountID = 2223, name = "Ascendant Skyrazor", boss = "Ansurek, Mythic", enc = 2602, q = "MOUNTRUN_DIFF_M", chance = "14%" },
				} },
			{ nameKey = "MOUNTRUN_R_LOU", route = { "P_DORNOGAL", "DORN_PLATE" }, instanceID = 2769, journalID = 1296, diffs = { 14, 15, 16 }, boss = "Chrome King Gallywix", enc = 2646, group = true,
				zoneMap = 2346, x = 42.12, y = 50.41, howKey = "MOUNTRUN_HOW_LOU",
				mounts = {
					{ mountID = 2507, name = "Prototype A.S.M.R.", boss = "Gallywix, any difficulty", enc = 2646, q = "MOUNTRUN_Q_ANY", chance = "0.3-0.8%" },
					{ mountID = 2487, name = "The Big G", boss = "Gallywix, Mythic", enc = 2646, q = "MOUNTRUN_DIFF_M", chance = "13%" },
				} },
			{ nameKey = "MOUNTRUN_R_MFO", route = { "P_DORNOGAL", "DORN_RIFT" }, instanceID = 2810, journalID = 1302, diffs = { 16 }, boss = "Dimensius, the All-Devouring", enc = 2691, group = true,
				zoneMap = 2371, x = 41.66, y = 21.53, howKey = "MOUNTRUN_HOW_MFO",
				mounts = {
					{ mountID = 2569, name = "Unbound Star-Eater", boss = "Dimensius, Mythic", enc = 2691, q = "MOUNTRUN_DIFF_M", chance = "~17%" },
				} },
			{ nameKey = "MOUNTRUN_R_MOQD", route = { "P_SILVERMOON", "SM_NORTH" }, instanceID = 2913, journalID = 1308, diffs = { 16 }, boss = "Midnight Falls", enc = 2740, group = true,
				zoneMap = 2424, x = 52.61, y = 85.30, howKey = "MOUNTRUN_HOW_MOQD",
				mounts = {
					{ mountID = 2607, name = "Ashes of Belo'ren", boss = "Midnight Falls, Mythic", enc = 2740, q = "MOUNTRUN_DIFF_M", chance = "?" },
				} },
			{ nameKey = "MOUNTRUN_R_VA", route = { "P_SILVERMOON", "SM_COILED", "CI_NORTH" }, instanceID = 3004, journalID = 1320, diffs = { 16 }, boss = "Ula'tek", enc = 2895, group = true,
				zoneMap = 2509, x = 47.23, y = 22.86, howKey = "MOUNTRUN_HOW_VA",
				mounts = {
					{ mountID = 3030, name = "Primeval Skyfriend", boss = "Ula'tek, Mythic", enc = 2895, q = "MOUNTRUN_DIFF_M", chance = "?" },
				} },
			{ nameKey = "MOUNTRUN_R_AOF", route = { "P_SILVERMOON", "SM_COILED", "CI_EAST" }, instanceID = 2993, journalID = 1322, diffs = { 23 }, boss = "Zul'jan", enc = 2880, group = true,
				zoneMap = 2509, x = 47.24, y = 68.13, howKey = "MOUNTRUN_HOW_AOF",
				mounts = {
					{ mountID = 3058, name = "The Writhing Brood", boss = "Zul'jan, Mythic or M+ chest", enc = 2880, q = "MOUNTRUN_Q_MPLUS", chance = "0.8% / 3.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_WRS", route = { "P_SILVERMOON", "SM_SOUTH" }, instanceID = 2805, journalID = 1299, diffs = { 23 }, boss = { "Restless Heart", "The Restless Heart" }, enc = 2658, group = true,
				zoneMap = 2395, x = 35.45, y = 78.83, howKey = "MOUNTRUN_HOW_WRS",
				mounts = {
					{ mountID = 2805, name = "Spectral Hawkstrider", boss = "The Restless Heart, Mythic", enc = 2658, q = "MOUNTRUN_DIFF_M", chance = "?" },
				} },
			{ nameKey = "MOUNTRUN_R_MTN", route = { "P_SILVERMOON", "SM_NORTH" }, instanceID = 2811, journalID = 1300, diffs = { 23 }, boss = "Degentrius", enc = 2662, group = true,
				zoneMap = 2424, x = 63.46, y = 15.39, howKey = "MOUNTRUN_HOW_MTN",
				mounts = {
					{ mountID = 2817, name = "Lucent Hawkstrider", boss = "Degentrius, Mythic", enc = 2662, q = "MOUNTRUN_DIFF_M", chance = "?" },
				} },
			{ nameKey = "MOUNTRUN_R_DFC", route = { "P_DORNOGAL", "DORN_HOLE" }, instanceID = 2651, journalID = 1210, diffs = { 23 }, boss = "The Darkness", enc = 2561, group = true,
				zoneMap = 2214, x = 55.54, y = 21.42, howKey = "MOUNTRUN_HOW_DFC",
				mounts = {
					{ mountID = 2204, name = "Wick", boss = "The Darkness, Mythic or M+ chest", enc = 2561, q = "MOUNTRUN_Q_MPLUS", chance = "?" },
				} },
		},
	},
}

--[[
	The steps of "Arrow to the entrance" (Rob, 16 Oct 2026: "in o.a. Zygor en HandyNotes alle stappen vinden").
	Research: docs/MOUNTRUN_ROUTES_2026-10-16.md (mh-research). Every point is GEMETEN in a local source file
	(ZT = Zygor LibRover data_transit.lua, ZB = data_borders.lua, HC/HD/HZ = HandyNotes_MapNotes); none of them has
	been walked in game yet, except Orgrimmar → Silvermoon (Rob, see MIDNIGHT_PORTALS in Delves.lua).

	Each raid's `route` lists hub keys in travel order; the entrance itself is always the last step (EntrancePoint).
	A hub: `kind` (picks the chat sentence), `to` = the uiMap you arrive on (the client names it, so no translation),
	and per faction `{ uiMap, x, y }` where the thing stands; `both` when it is the same for everyone. A hub without
	the player's faction is skipped (Alliance flies to Zul'Gurub, Horde takes the zeppelin). `lower = true`: the
	Orgrimmar portal is in the lower room of the Pathfinder's Den (HC:129).
	Quest gates (from the sources, not measured in the client) are in the research file; the chat line does not
	promise a portal you may not have yet — the window's "how" line says which ones need a quest.
]]
ns.MOUNTRUN_HUBS = {
	-- Capitals: Stormwind (84) and Orgrimmar (85).
	P_DALARAN_NR = { kind = "portal", to = 125, A = { 84, 44.36, 88.71 }, H = { 85, 56.23, 91.74 } }, -- ZT:1666 / ZT:1482
	P_SHATTRATH = { kind = "portal", to = 111, A = { 84, 44.91, 85.72 }, H = { 85, 57.51, 91.65, lower = true } }, -- ZT:1692 / ZT:1460
	P_COT = { kind = "portal", to = 74, A = { 84, 43.72, 85.35 }, H = { 85, 56.40, 92.56, lower = true } }, -- ZT:1674 / ZT:1449
	P_COT_A = { kind = "portal", to = 74, A = { 84, 43.72, 85.35 } }, -- Onyxia: Alliance via the Caverns, Horde flies
	P_JADE = { kind = "portal", to = 371, A = { 84, 45.70, 87.16 }, H = { 85, 57.46, 92.28 } }, -- ZT:1680 / ZT:1468
	P_DRAENOR = { kind = "portal", A = { 84, 41.36, 89.82, to = 622 }, H = { 85, 55.18, 92.05, lower = true, to = 624 } }, -- ZT:1684 / ZT:1453
	P_AZSUNA = { kind = "portal", to = 630, A = { 84, 42.08, 91.34 }, H = { 85, 57.23, 88.21, lower = true } }, -- ZT:1670 / ZT:1446
	P_BFA = { kind = "portal", A = { 84, 40.85, 92.75, to = 1161 }, H = { 85, 57.89, 89.84, lower = true, to = 1163 } }, -- ZT:1688 / ZT:1456
	P_ORIBOS = { kind = "portal", to = 1670, A = { 84, 47.55, 94.98 }, H = { 85, 58.32, 87.85 } }, -- ZT:787 / ZT:798
	P_VALDRAKKEN = { kind = "portal", to = 2112, A = { 84, 48.89, 93.43 }, H = { 85, 57.11, 87.30 } }, -- ZT:1700 / ZT:1472
	P_DORNOGAL = { kind = "portal", to = 2339, A = { 84, 48.13, 91.95 }, H = { 85, 58.58, 91.36 } }, -- ZT:451 / ZT:466
	-- Horde: Rob measured 56.25/88.57 (Delves.lua MIDNIGHT_PORTALS); Alliance only from Zygor (ZT:164).
	P_SILVERMOON = { kind = "portal", to = 2393, A = { 84, 48.77, 95.23 }, H = { 85, 56.25, 88.57 } },
	E_HYJAL = { kind = "portal", to = 198, A = { 84, 76.20, 18.69 }, H = { 85, 51.13, 38.28 } }, -- ZT:1651 / ZT:1408
	E_ULDUM = { kind = "portal", to = 1527, A = { 84, 75.24, 20.50 }, H = { 85, 48.87, 38.55 } }, -- ZT:1644 / ZT:1402
	E_DEEPHOLM = { kind = "portal", to = 207, A = { 84, 73.19, 19.65 }, H = { 85, 50.84, 36.29 } }, -- ZT:1647 / ZT:1405
	Z_GROMGOL = { kind = "zeppelin", to = 50, H = { 85, 52.52, 53.15 } }, -- ZT:2843 (HC:146)
	-- Arrives on 18 (HandyNotes) or 2070 (Zygor); the sources disagree, so both count as "arrived".
	Z_TIRISFAL = { kind = "portal", to = { 18, 2070 }, H = { 85, 50.74, 55.57 } }, -- ZT:1432 (HC:130)
	TRAM_IF = { kind = "tram", to = 87, A = { 84, 69.62, 31.11 } }, -- ZT:2878
	-- Further hubs.
	SH_QUELDANAS = { kind = "portal", to = 122, both = { 111, 48.57, 42.02 } }, -- ZT:1908 (HC:2433)
	-- `unlock` (16 Oct 2026, Rob on his mage: "stuurt me naar een portal to isle of thunder die niet bestaat voor mij,
	-- maar er staat wel een quest"): until "The Storm Gathers" is done the portal is not there; the quest giver flies
	-- you to the island instead. Zygor ZygorProfessionsHordeLEGION.lua:8847-8876 (GEMETEN in the source):
	-- Horde 32680, Scout Captain Elsia (npc 70358) at 388 50.80/73.39; Alliance 32681, Vereesa Windrunner (npc 70360)
	-- at 388 49.93/69.04.
	TL_THUNDER = { kind = "portal", to = 504, A = { 388, 49.74, 68.67 }, H = { 388, 50.65, 73.40 }, -- ZT:1997 / ZT:2037
		unlock = {
			A = { quest = 32681, questName = "The Storm Gathers", npc = "Vereesa Windrunner", 388, 49.93, 69.04 },
			H = { quest = 32680, questName = "The Storm Gathers", npc = "Scout Captain Elsia", 388, 50.80, 73.39 },
		} },
	DR_TANAAN = { kind = "portal", to = 534, A = { 622, 36.38, 41.15 }, H = { 624, 53.16, 43.91 } }, -- ZT:2097 / ZT:2119
	ZUL_EXIT = { kind = "exit", to = 1165, H = { 1163, 48.59, 17.52 } }, -- HC:971, Hall of Ancient Paths
	ZUL_TIRAGARDE = { kind = "boat", to = 895, H = { 862, 58.46, 62.99 } }, -- ZT:3020, Dread-Admiral Tattersail
	BOR_NAZMIR = { kind = "boat", to = 863, A = { 1161, 67.95, 26.69 } }, -- ZT:2961, Grand Admiral Jes-Tereth
	VALD_DREAM = { kind = "portal", to = 2200, both = { 2112, 62.60, 57.42 } }, -- ZT:650 (HC:3188)
	ORI_RING = { kind = "ring", to = 1671, both = { 1670, 47.02, 50.34 } }, -- ZT:816-825, one of four
	ORI_ZERETH = { kind = "portal", to = 1970, both = { 1671, 49.59, 25.44 } }, -- ZT:804 (HC:3033)
	ORI_MAW = { kind = "jump", to = 1543, both = { 1671, 49.27, 50.88 } }, -- ZT:840 (HC:3031)
	DORN_TUNNEL = { kind = "tunnel", to = 2255, both = { 2339, 63.61, 52.59 } }, -- ZT:508 (HC:3386)
	DORN_PLATE = { kind = "teleport", to = 2346, both = { 2339, 52.47, 50.47 } }, -- ZT:588 (HC:3388)
	DORN_RIFT = { kind = "portal", to = 2472, both = { 2339, 40.31, 22.70 } }, -- ZT:481 (HC:3389), Spatial Rift
	DORN_HOLE = { kind = "hole", to = 2214, both = { 2339, 38.87, 59.81 } }, -- ZB:336
	SM_NORTH = { kind = "exit", to = 2424, both = { 2393, 45.73, 6.48 } }, -- HC:3496
	SM_SOUTH = { kind = "exit", to = 2395, both = { 2393, 37.44, 90.41 } }, -- HC:3497, westernmost of three
	-- Delves.lua MIDNIGHT_PORTALS (ZT:206); `via` = the building's door, Rob measured 54.99/63.30 (3 Sep 2026).
	-- Portal: Rob's `/mh here`, 19 Aug (UI.lua); was 56.83/67.38 (travel design rule, 16 Oct 2026).
	-- 16 Oct 2026, later: via = Rob's `/mh here` IN the archway, 55.02/63.56 (one value with Delves.lua and UI.lua).
	SM_COILED = { kind = "portal", to = 2512, both = { 2393, 56.74, 67.30 }, via = { 55.02, 63.56 }, orb = { 55.80, 65.02 } },
	CI_NORTH = { kind = "tunnel", to = 2509, both = { 2512, 43.30, 44.27 } }, -- ZB:359-361
	CI_EAST = { kind = "tunnel", to = 2509, both = { 2512, 45.37, 64.90 } }, -- ZB:367-369
	-- Antorus is only PARTLY covered: no source places Legion Dalaran itself, the Vindicaar's console or the way
	-- down to the Antoran Wastes. The beacon is Zygor's alone (ZT:2349).
	LEG_BEACON = { kind = "beacon", to = 831, both = { 627, 74.22, 49.26 } },
}

--[[
	The way HOME, put in front of a route when you start it somewhere else (Rob, 16 Oct 2026, standing in Silvermoon:
	"kunnen we geen pijlen ook naar de portals hier toevoegen? … en natuurlijk niet alleen voor deze").
	uiMap where you stand → { A = { x, y } portal to Stormwind, H = { x, y } portal to Orgrimmar }. All from Zygor
	LibRover data_transit.lua (ZT:line); Zygor's map names turned into uiMap ids with its own MapIDsByName table
	(data.lua: Dalaran/1 = 125, Dalaran L/10 = 627, Dazar'alor/1 = 1163, Tanaris/17 = 74). GEMETEN in the source,
	not walked in game. Some need a quest (Silvermoon: 86852 or achievement 41806; Dornogal: level 70 + 80321/79573;
	Valdrakken: 67030; Oribos: 60151 or level 50) — not checked here; a player without it gets told the portal anyway.
]]
ns.MOUNTRUN_HOME = {
	-- Silvermoon: first tried MH's own "Portal Room" pin (UI.lua SMC_CAT_TRAVEL, 53.37/66.31). Rob, 16 Oct 2026,
	-- standing AT the Orgrimmar portal: the arrow still said 34 m — the pin marks the room, not the portal ("beter de
	-- zygor coordinaten er extra aan toe"). So the arrow now goes to the portal itself, Zygor ZT:159 (A) / ZT:172 (H);
	-- the sentence still says "portal room", which is how you find it.
	-- ✅ GEMETEN by Rob the same evening, `/mh here` standing at each portal: Horde 52.24/65.28, Alliance 52.71/64.61
	-- (Zygor was within 0.1 of both).
	-- `via`: the door of the portal room, also measured by Rob (`/mh here`, 53.30/66.24 — MH's Portal Room pin sits on
	-- it). The arrow goes to the door first and to the portal once you are there; both on the same map.
	[2393] = { A = { 52.71, 64.61 }, H = { 52.24, 65.28 }, room = true, via = { 53.30, 66.24 } },
	[2339] = { A = { 41.18, 22.68 }, H = { 38.15, 27.23 } }, -- Dornogal, ZT:447 / ZT:462
	[2112] = { A = { 59.79, 41.71 }, H = { 56.59, 38.26 } }, -- Valdrakken, ZT:659 / ZT:701
	[1670] = { A = { 20.86, 45.67 }, H = { 20.85, 54.77 } }, -- Oribos, ZT:783 / ZT:794
	[125] = { A = { 40.10, 62.81 }, H = { 55.33, 25.45 } }, -- Dalaran (Northrend), ZT:1917 / ZT:1929
	[627] = { A = { 39.55, 63.22 }, H = { 55.25, 23.93 } }, -- Dalaran (Legion), ZT:2158 / ZT:2178
	[111] = { A = { 57.21, 48.27 }, H = { 56.81, 48.85 } }, -- Shattrath, ZT:1892 / ZT:1903
	[371] = { A = { 46.24, 85.17 }, H = { 28.52, 14.02 } }, -- The Jade Forest, ZT:1977 / ZT:2025
	[630] = { A = { 46.66, 41.41 }, H = { 46.67, 41.30 } }, -- Azsuna, ZT:2155 / ZT:2175
	[74] = { A = { 58.20, 26.69 }, H = { 58.97, 26.78 } }, -- Caverns of Time, ZT:1334 / ZT:1377
	[622] = { A = { 60.81, 37.87 } }, -- Stormshield, ZT:2103
	[624] = { H = { 60.70, 51.60 } }, -- Warspear, ZT:2122
	[1161] = { A = { 70.13, 16.79 } }, -- Boralus, ZT:2662
	[1163] = { H = { 74.05, 69.75 } }, -- Dazar'alor, Hall of Ancient Paths, ZT:2726
	[198] = { H = { 63.48, 24.43 } }, -- Mount Hyjal, ZT:1412
	[207] = { H = { 50.93, 53.10 } }, -- Deepholm, ZT:2144
	-- 16 Oct 2026, later (Rob: "het gaat natuurlijk niet alleen om hier in uldum maar overal"): the remaining portals
	-- home Zygor knows outside the old phases. Map ids from Zygor's MapIDsByName (data.lua). Left out on purpose:
	-- Twilight Highlands (ZT:424/431, listed under "PREPATCH" with its own quest — may be gone), Tirisfal and
	-- Teldrassil (only in an old phase).
	[17] = { H = { 72.65, 49.51 } }, -- Blasted Lands, ZT:1758
	[100] = { A = { 89.22, 51.00 }, H = { 89.23, 49.45 } }, -- Hellfire Peninsula (Dark Portal), ZT:1886 / ZT:1897
	[245] = { H = { 56.30, 79.66 } }, -- Tol Barad Peninsula, ZT:2141
	[103] = { A = { 48.34, 62.94 } }, -- The Exodar, ZT:1345
	[2239] = { A = { 55.49, 63.66 } }, -- Amirdrassil (Bel'ameth), ZT:615
}

--- Hearthstone toys that go to your normal bind point (Rob, 16 Oct 2026: "laat ook mijn speelgoed-hearthstones
--- meetellen als de gewone op cooldown is of niet in mijn tas zit"). From Zygor LibRover data_items.lua:17-36, the
--- entries with destination "_HEARTH" and toy=true. Left out on purpose: the four covenant ones (Zygor gates them on
--- the covenant, ZT:39-42), the Garrison and Dalaran Hearthstones (other destinations), Timerunner's (no toy flag).
--- Not verified per id in the client; MountRun asks PlayerHasToy + the item cooldown, so a wrong id is simply never
--- offered (fails closed).
ns.MOUNTRUN_HEARTH_TOYS = {
	245970, 64488, 142542, 162973, 163045, 165669, 165670, 165802, 166746, 166747,
	168907, 172179, 193588, 209035, 208704, 188952, 190196, 200630, 228940,
}

--- Midnight zones without their own portal home: first to Silvermoon, then home from there. The portals are MH's
--- own MIDNIGHT_PORTALS (Delves.lua), measured by Rob; Harandar's sit inside The Den, whose mouth comes first.
ns.MOUNTRUN_TO_SILVERMOON = {
	[2405] = { { 2405, 51.61, 70.22, to = 2393 } }, -- Voidstorm
	[2512] = { { 2512, 58.25, 48.46, to = 2393 } }, -- The Coiled Isle (Tokka's Landing)
	-- No row for 2576 itself: that map is a shared canvas (Delves.lua uses it for Silvermoon, The Den and Voidstorm
	-- with a `zone` tag), so "you stand on 2576" does not say where you are.
	[2413] = { { 2413, 54.72, 53.10, to = 2576, den = true }, { 2576, 64.33, 70.63, to = 2393 } }, -- Harandar
}
