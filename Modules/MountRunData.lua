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
		headKey = "MOUNTRUN_HEAD_NORTHREND",
		raids = {
			{ nameKey = "MOUNTRUN_R_OS", instanceID = 615, journalID = 755, diffs = { 3, 4 }, boss = "Sartharion",
				zoneMap = 115, x = 60.02, y = 57.02, howKey = "MOUNTRUN_HOW_OS",
				mounts = {
					{ mountID = 253, name = "Black Drake", boss = "Sartharion, 10", chance = "~70%" },
					{ mountID = 250, name = "Twilight Drake", boss = "Sartharion, 25", chance = "~75%" },
				} },
			{ nameKey = "MOUNTRUN_R_EOE", instanceID = 616, journalID = 756, diffs = { 3, 4 }, boss = "Malygos",
				zoneMap = 114, x = 27.52, y = 26.74, howKey = "MOUNTRUN_HOW_EOE",
				mounts = {
					{ mountID = 246, name = "Azure Drake", boss = "Malygos", chance = "2-3.5%" },
					{ mountID = 247, name = "Blue Drake", boss = "Malygos", chance = "2-4%" },
				} },
			{ nameKey = "MOUNTRUN_R_VOA", instanceID = 624, journalID = 753, diffs = { 3, 4 }, boss = nil,
				zoneMap = 123, x = 50.06, y = 11.18, howKey = "MOUNTRUN_HOW_VOA",
				mounts = {
					{ mountID = 286, name = "Grand Black War Mammoth", boss = "all 4 bosses", chance = "~0.8% each", faction = "Alliance" },
					{ mountID = 287, name = "Grand Black War Mammoth", boss = "all 4 bosses", chance = "~0.8% each", faction = "Horde" },
				} },
			{ nameKey = "MOUNTRUN_R_ICC", instanceID = 631, journalID = 758, diffs = { 6 }, boss = "The Lich King",
				zoneMap = 118, x = 53.91, y = 87.41, howKey = "MOUNTRUN_HOW_ICC",
				mounts = {
					{ mountID = 363, name = "Invincible", boss = "The Lich King, 25 Heroic", chance = "1%" },
				} },
			{ nameKey = "MOUNTRUN_R_ULDUAR", instanceID = 603, journalID = 759, diffs = { 14 }, boss = "Yogg-Saron",
				zoneMap = 120, x = 41.55, y = 17.58, howKey = "MOUNTRUN_HOW_ULDUAR",
				mounts = {
					{ mountID = 304, name = "Mimiron's Head", boss = "Yogg-Saron, 0 keepers", chance = "1%" },
				} },
			{ nameKey = "MOUNTRUN_R_UP", instanceID = 575, journalID = 286, diffs = { 2 }, boss = "Skadi the Ruthless",
				zoneMap = 117, x = 57.29, y = 46.89, howKey = "MOUNTRUN_HOW_UP",
				mounts = {
					{ mountID = 264, name = "Blue Proto-Drake", boss = "Skadi, Heroic", chance = "1.2%" },
				} },
		},
	},
	{
		headKey = "MOUNTRUN_HEAD_OUTLAND",
		raids = {
			{ nameKey = "MOUNTRUN_R_TK", instanceID = 550, journalID = 749, diffs = { 4 }, boss = "Kael'thas Sunstrider",
				zoneMap = 109, x = 73.88, y = 63.74, howKey = "MOUNTRUN_HOW_TK",
				mounts = {
					{ mountID = 183, name = "Ashes of Al'ar", boss = "Kael'thas", chance = "1.7%" },
				} },
			{ nameKey = "MOUNTRUN_R_SETHEKK", instanceID = 556, journalID = 252, diffs = { 2 }, boss = "Anzu",
				zoneMap = 108, x = 45.06, y = 65.62, howKey = "MOUNTRUN_HOW_SETHEKK",
				mounts = {
					{ mountID = 185, name = "Reins of the Raven Lord", boss = "Anzu, Heroic", chance = "1.6%" },
				} },
			{ nameKey = "MOUNTRUN_R_MT", instanceID = 585, journalID = 249, diffs = { 2 }, boss = "Kael'thas Sunstrider",
				zoneMap = 122, x = 61.52, y = 31.10, howKey = "MOUNTRUN_HOW_MT",
				mounts = {
					{ mountID = 213, name = "Swift White Hawkstrider", boss = "Kael'thas, Heroic", chance = "5.3%" },
				} },
			{ nameKey = "MOUNTRUN_R_KARA", instanceID = 532, journalID = 745, diffs = { 3 }, boss = "Attumen the Huntsman",
				zoneMap = 42, x = 46.59, y = 74.11, howKey = "MOUNTRUN_HOW_KARA",
				mounts = {
					{ mountID = 168, name = "Fiery Warhorse", boss = "Attumen", chance = "1.1%" },
				} },
			{ nameKey = "MOUNTRUN_R_RTK", instanceID = 1651, journalID = 860, diffs = { 23 }, boss = "Nightbane",
				zoneMap = 42, x = 46.37, y = 70.66, howKey = "MOUNTRUN_HOW_RTK",
				mounts = {
					{ mountID = 883, name = "Smoldering Ember Wyrm", boss = "Nightbane", chance = "~19%" },
					{ mountID = 875, name = "Midnight", boss = "Attumen", chance = "1.3%" },
				} },
			{ nameKey = "MOUNTRUN_R_COS", instanceID = 595, journalID = 279, diffs = { 2 }, boss = nil,
				zoneMap = 71, x = 64.86, y = 49.97, howKey = "MOUNTRUN_HOW_COS",
				mounts = {
					{ mountID = 248, name = "Bronze Drake", boss = "in time, Heroic", chance = "~92%" },
				} },
			{ nameKey = "MOUNTRUN_R_DS", instanceID = 967, journalID = 187, diffs = { 5, 6 }, boss = "Madness of Deathwing",
				zoneMap = 71, x = 64.86, y = 49.97, howKey = "MOUNTRUN_HOW_DS",
				mounts = {
					{ mountID = 444, name = "Life-Binder's Handmaiden", boss = "Deathwing, Heroic", chance = "1-1.8%" },
					{ mountID = 442, name = "Blazing Drake", boss = "Deathwing", chance = "0.7-0.9%" },
					{ mountID = 445, name = "Experiment 12-B", boss = "Ultraxion", chance = "0.5-0.7%" },
				} },
			{ nameKey = "MOUNTRUN_R_ONY", instanceID = 249, journalID = 760, diffs = { 3, 4 }, boss = "Onyxia",
				zoneMap = 70, x = 52.90, y = 78.15, howKey = "MOUNTRUN_HOW_ONY",
				mounts = {
					{ mountID = 349, name = "Onyxian Drake", boss = "Onyxia", chance = "1.3-1.7%" },
				} },
		},
	},
	{
		headKey = "MOUNTRUN_HEAD_CATA",
		raids = {
			{ nameKey = "MOUNTRUN_R_FL", instanceID = 720, journalID = 78, diffs = { 14, 15 }, boss = "Ragnaros",
				zoneMap = 198, x = 47.00, y = 78.24, howKey = "MOUNTRUN_HOW_FL",
				mounts = {
					{ mountID = 425, name = "Flametalon of Alysrazor", boss = "Alysrazor", chance = "2.1%" },
					{ mountID = 415, name = "Pureblood Fire Hawk", boss = "Ragnaros", chance = "0.9-1.7%" },
				} },
			{ nameKey = "MOUNTRUN_R_T4W", instanceID = 754, journalID = 74, diffs = { 3, 4, 5, 6 }, boss = "Al'Akir",
				zoneMap = 249, x = 38.24, y = 80.70, howKey = "MOUNTRUN_HOW_T4W",
				mounts = {
					{ mountID = 396, name = "Drake of the South Wind", boss = "Al'Akir", chance = "1-2%" },
				} },
			{ nameKey = "MOUNTRUN_R_TOT", instanceID = 1098, journalID = 362, diffs = { 3, 4, 5, 6 }, boss = "Ji-Kun",
				zoneMap = 504, x = 63.82, y = 32.05, howKey = "MOUNTRUN_HOW_TOT",
				mounts = {
					{ mountID = 531, name = "Spawn of Horridon", boss = "Horridon", chance = "2.4%" },
					{ mountID = 543, name = "Clutch of Ji-Kun", boss = "Ji-Kun", chance = "2.3%" },
				} },
			{ nameKey = "MOUNTRUN_R_MSV", instanceID = 1008, journalID = 317, diffs = { 3, 4, 5, 6 }, boss = "Elegon",
				zoneMap = 379, x = 59.50, y = 39.34, howKey = "MOUNTRUN_HOW_MSV",
				mounts = {
					{ mountID = 478, name = "Astral Cloud Serpent", boss = "Elegon", chance = "0.4-2.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_SOO", instanceID = 1136, journalID = 369, diffs = { 16 }, boss = "Garrosh Hellscream",
				zoneMap = 390, x = 74.30, y = 41.66, howKey = "MOUNTRUN_HOW_SOO",
				mounts = {
					{ mountID = 559, name = "Kor'kron Juggernaut", boss = "Garrosh, Mythic", chance = "2.3%" },
				} },
		},
	},
	{
		headKey = "MOUNTRUN_HEAD_MYTHIC",
		raids = {
			{ nameKey = "MOUNTRUN_R_HFC", instanceID = 1448, journalID = 669, diffs = { 16 }, boss = "Archimonde",
				zoneMap = 534, x = 45.22, y = 53.84, howKey = "MOUNTRUN_HOW_HFC",
				mounts = {
					{ mountID = 751, name = "Felsteel Annihilator", boss = "Archimonde, Mythic", chance = "7.5%*" },
				} },
			{ nameKey = "MOUNTRUN_R_BRF", instanceID = 1205, journalID = 457, diffs = { 16 }, boss = "Blackhand",
				zoneMap = 543, x = 51.59, y = 27.11, howKey = "MOUNTRUN_HOW_BRF",
				mounts = {
					{ mountID = 613, name = "Ironhoof Destroyer", boss = "Blackhand, Mythic", chance = "3.7%*" },
				} },
			{ nameKey = "MOUNTRUN_R_NH", instanceID = 1530, journalID = 786, diffs = { 16 }, boss = "Gul'dan",
				zoneMap = 680, x = 44.23, y = 59.51, howKey = "MOUNTRUN_HOW_NH",
				mounts = {
					{ mountID = 633, name = "Hellfire Infernal", boss = "Gul'dan, Mythic", chance = "8%*" },
					-- Same kill; also drops on Normal/Heroic (JournalItemXDifficulty 14/15/16), shown under the Mythic row.
					{ mountID = 791, name = "Felblaze Infernal", boss = "Gul'dan", chance = "0.4%" },
				} },
			{ nameKey = "MOUNTRUN_R_BOD", instanceID = 2070, journalID = 1176, diffs = { 16 }, boss = "Lady Jaina Proudmoore",
				zoneMap = 862, x = 54.28, y = 30.03, zoneMapA = 1161, xA = 70.65, yA = 35.06, howKey = "MOUNTRUN_HOW_BOD",
				mounts = {
					{ mountID = 1219, name = "Glacial Tidestorm", boss = "Jaina, Mythic", chance = "0.7%" },
				} },
			{ nameKey = "MOUNTRUN_R_AMI", instanceID = 2549, journalID = 1207, diffs = { 16 }, boss = "Fyrakk the Blazing",
				zoneMap = 2200, x = 27.25, y = 31.03, howKey = "MOUNTRUN_HOW_AMI",
				mounts = {
					{ mountID = 1818, name = "Anu'relos, Flame's Guidance", boss = "Fyrakk, Mythic", chance = "0.6%" },
				} },
			{ nameKey = "MOUNTRUN_R_SFO", instanceID = 2481, journalID = 1195, diffs = { 16 }, boss = "The Jailer",
				zoneMap = 1970, x = 81.00, y = 53.33, howKey = "MOUNTRUN_HOW_SFO",
				mounts = {
					{ mountID = 1587, name = "Zereth Overseer", boss = "The Jailer, Mythic", chance = "0.9%" },
				} },
		},
	},
	-- 15 Oct 2026, later (Rob: "alles, ook diegene die een groep benodigen"): second mh-research pass, same sources
	-- (wago 12.1.5.70391; Midnight/Manaforge entrances from AreaPOI because they have no JournalInstanceEntrance row).
	-- Measured corrections: Living/Felblaze Infernal and Sureki Skyrazor / Prototype A.S.M.R. drop on every difficulty;
	-- the Mythic-only mounts are Ascendant Skyrazor and The Big G; G.M.O.D. is Mekkatorque on N/H/M; Kith'ix, Voidspire
	-- and Dreamrift have NO mount. boss may be a list: the lockout name can differ from the journal name (AFGELEID).
	{
		headKey = "MOUNTRUN_HEAD_LEGION_SL",
		raids = {
			{ nameKey = "MOUNTRUN_R_TOS", instanceID = 1676, journalID = 875, diffs = { 14, 15, 16, 17 }, boss = "Mistress Sassz'ine",
				zoneMap = 646, x = 64.97, y = 20.26, howKey = "MOUNTRUN_HOW_TOS",
				mounts = {
					{ mountID = 899, name = "Abyss Worm", boss = "Mistress Sassz'ine, any difficulty", chance = "0.1-0.3%" },
				} },
			{ nameKey = "MOUNTRUN_R_ANT", instanceID = 1712, journalID = 946, diffs = { 14, 15, 16, 17 }, boss = "Felhounds of Sargeras",
				zoneMap = 885, x = 54.70, y = 62.80, howKey = "MOUNTRUN_HOW_ANT",
				mounts = {
					{ mountID = 971, name = "Antoran Charhound", boss = "Felhounds, any difficulty", chance = "?" },
				} },
			{ nameKey = "MOUNTRUN_R_ANT_ARGUS", instanceID = 1712, journalID = 946, diffs = { 16 }, boss = "Argus the Unmaker",
				zoneMap = 885, x = 54.70, y = 62.80, howKey = "MOUNTRUN_HOW_ANT_ARGUS",
				mounts = {
					{ mountID = 954, name = "Shackled Ur'zul", boss = "Argus, Mythic", chance = "~0.8%" },
				} },
			{ nameKey = "MOUNTRUN_R_SOD", instanceID = 2450, journalID = 1193, diffs = { 16 }, boss = "Sylvanas Windrunner",
				zoneMap = 1543, x = 69.75, y = 32.01, howKey = "MOUNTRUN_HOW_SOD",
				mounts = {
					{ mountID = 1471, name = "Vengeance", boss = "Sylvanas, Mythic", chance = "~0.5%" },
				} },
			{ nameKey = "MOUNTRUN_R_NYA", instanceID = 2217, journalID = 1180, diffs = { 16 }, boss = "N'Zoth the Corruptor",
				zoneMap = 1527, x = 55.18, y = 43.96, howKey = "MOUNTRUN_HOW_NYA",
				mounts = {
					{ mountID = 1293, name = "Ny'alotha Allseer", boss = "N'Zoth, Mythic", chance = "~0.7%" },
				} },
			{ nameKey = "MOUNTRUN_R_BOD_GMOD", instanceID = 2070, journalID = 1176, diffs = { 14, 15, 16 },
				boss = { "Mekkatorque", "High Tinker Mekkatorque" },
				zoneMap = 862, x = 54.28, y = 30.03, zoneMapA = 1161, xA = 70.65, yA = 35.06, howKey = "MOUNTRUN_HOW_BOD_GMOD",
				mounts = {
					{ mountID = 1217, name = "G.M.O.D.", boss = "Mekkatorque, Normal/Heroic/Mythic", chance = "?" },
				} },
		},
	},
	{
		headKey = "MOUNTRUN_HEAD_DUNGEONS",
		raids = {
			-- No journalID: DB2 puts the Service Entrance's journal entrance on the Main Gate, so the client pin would point
			-- at the wrong door. The coordinate is HandyNotes_MapNotes' Service Entrance.
			{ nameKey = "MOUNTRUN_R_STRAT", instanceID = 329, diffs = { 1 }, boss = "Lord Aurius Rivendare",
				zoneMap = 23, x = 43.25, y = 18.54, howKey = "MOUNTRUN_HOW_STRAT",
				mounts = {
					{ mountID = 69, name = "Rivendare's Deathcharger", boss = "Rivendare", chance = "0.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_VP", instanceID = 657, journalID = 68, diffs = { 1, 2 }, boss = "Altairus",
				zoneMap = 249, x = 76.84, y = 84.59, howKey = "MOUNTRUN_HOW_VP",
				mounts = {
					{ mountID = 395, name = "Drake of the North Wind", boss = "Altairus", chance = "0.8-0.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_SC", instanceID = 725, journalID = 67, diffs = { 1, 2 }, boss = "Slabhide",
				zoneMap = 207, x = 47.83, y = 51.90, howKey = "MOUNTRUN_HOW_SC",
				mounts = {
					{ mountID = 397, name = "Vitreous Stone Drake", boss = "Slabhide", chance = "0.8-0.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_ZG", instanceID = 859, journalID = 76, diffs = { 2 }, boss = "High Priestess Kilnara",
				zoneMap = 50, x = 72.25, y = 32.91, howKey = "MOUNTRUN_HOW_ZG",
				mounts = {
					{ mountID = 410, name = "Armored Razzashi Raptor", boss = "Mandokir, Heroic", chance = "0.7%" },
					{ mountID = 411, name = "Swift Zulian Panther", boss = "Kilnara, Heroic", chance = "0.9%" },
				} },
			{ nameKey = "MOUNTRUN_R_FH", instanceID = 1754, journalID = 1001, diffs = { 23 }, boss = { "Lord Harlan Sweete", "Harlan Sweete" },
				zoneMap = 895, x = 83.82, y = 79.25, howKey = "MOUNTRUN_HOW_FH",
				mounts = {
					{ mountID = 995, name = "Sharkbait", boss = "Harlan Sweete, Mythic", chance = "0.5%" },
				} },
			{ nameKey = "MOUNTRUN_R_UR", instanceID = 1841, journalID = 1022, diffs = { 23 }, boss = "Unbound Abomination",
				zoneMap = 863, x = 51.08, y = 64.29, howKey = "MOUNTRUN_HOW_UR",
				mounts = {
					{ mountID = 1053, name = "Underrot Crawg", boss = "Unbound Abomination, Mythic", chance = "0.4%" },
				} },
			{ nameKey = "MOUNTRUN_R_DOTI", instanceID = 2579, journalID = 1209, diffs = { 23 }, boss = "Chrono-Lord Deios",
				zoneMap = 2025, x = 61.29, y = 84.73, howKey = "MOUNTRUN_HOW_DOTI",
				mounts = {
					-- A token (item 208216) that opens into a random dungeon mount: no single mountID, so no tick or cross.
					{ mountID = nil, name = "Reins of the Quantum Courser", boss = "Deios, Mythic", chance = "2.2%" },
				} },
		},
	},
	{
		headKey = "MOUNTRUN_HEAD_GROUP",
		raids = {
			{ nameKey = "MOUNTRUN_R_NP", instanceID = 2657, journalID = 1273, diffs = { 14, 15, 16 }, boss = "Queen Ansurek", group = true,
				zoneMap = 2255, x = 43.46, y = 90.44, howKey = "MOUNTRUN_HOW_NP",
				mounts = {
					{ mountID = 2219, name = "Sureki Skyrazor", boss = "Ansurek, any difficulty", chance = "0.4-0.9%" },
					{ mountID = 2223, name = "Ascendant Skyrazor", boss = "Ansurek, Mythic", chance = "14%" },
				} },
			{ nameKey = "MOUNTRUN_R_LOU", instanceID = 2769, journalID = 1296, diffs = { 14, 15, 16 }, boss = "Chrome King Gallywix", group = true,
				zoneMap = 2346, x = 42.12, y = 50.41, howKey = "MOUNTRUN_HOW_LOU",
				mounts = {
					{ mountID = 2507, name = "Prototype A.S.M.R.", boss = "Gallywix, any difficulty", chance = "0.3-0.8%" },
					{ mountID = 2487, name = "The Big G", boss = "Gallywix, Mythic", chance = "13%" },
				} },
			{ nameKey = "MOUNTRUN_R_MFO", instanceID = 2810, journalID = 1302, diffs = { 16 }, boss = "Dimensius, the All-Devouring", group = true,
				zoneMap = 2371, x = 41.66, y = 21.53, howKey = "MOUNTRUN_HOW_MFO",
				mounts = {
					{ mountID = 2569, name = "Unbound Star-Eater", boss = "Dimensius, Mythic", chance = "~17%" },
				} },
			{ nameKey = "MOUNTRUN_R_MOQD", instanceID = 2913, journalID = 1308, diffs = { 16 }, boss = "Midnight Falls", group = true,
				zoneMap = 2424, x = 52.61, y = 85.30, howKey = "MOUNTRUN_HOW_MOQD",
				mounts = {
					{ mountID = 2607, name = "Ashes of Belo'ren", boss = "Midnight Falls, Mythic", chance = "?" },
				} },
			{ nameKey = "MOUNTRUN_R_VA", instanceID = 3004, journalID = 1320, diffs = { 16 }, boss = "Ula'tek", group = true,
				zoneMap = 2509, x = 47.23, y = 22.86, howKey = "MOUNTRUN_HOW_VA",
				mounts = {
					{ mountID = 3030, name = "Primeval Skyfriend", boss = "Ula'tek, Mythic", chance = "?" },
				} },
			{ nameKey = "MOUNTRUN_R_AOF", instanceID = 2993, journalID = 1322, diffs = { 23 }, boss = "Zul'jan", group = true,
				zoneMap = 2509, x = 47.24, y = 68.13, howKey = "MOUNTRUN_HOW_AOF",
				mounts = {
					{ mountID = 3058, name = "The Writhing Brood", boss = "Zul'jan, Mythic or M+ chest", chance = "0.8% (M+ chest 3.9%)" },
				} },
			{ nameKey = "MOUNTRUN_R_WRS", instanceID = 2805, journalID = 1299, diffs = { 23 }, boss = { "Restless Heart", "The Restless Heart" }, group = true,
				zoneMap = 2395, x = 35.45, y = 78.83, howKey = "MOUNTRUN_HOW_WRS",
				mounts = {
					{ mountID = 2805, name = "Spectral Hawkstrider", boss = "The Restless Heart, Mythic", chance = "?" },
				} },
			{ nameKey = "MOUNTRUN_R_MTN", instanceID = 2811, journalID = 1300, diffs = { 23 }, boss = "Degentrius", group = true,
				zoneMap = 2424, x = 63.46, y = 15.39, howKey = "MOUNTRUN_HOW_MTN",
				mounts = {
					{ mountID = 2817, name = "Lucent Hawkstrider", boss = "Degentrius, Mythic", chance = "?" },
				} },
			{ nameKey = "MOUNTRUN_R_DFC", instanceID = 2651, journalID = 1210, diffs = { 23 }, boss = "The Darkness", group = true,
				zoneMap = 2214, x = 55.54, y = 21.42, howKey = "MOUNTRUN_HOW_DFC",
				mounts = {
					{ mountID = 2204, name = "Wick", boss = "The Darkness, Mythic or M+ chest", chance = "?" },
				} },
		},
	},
}
