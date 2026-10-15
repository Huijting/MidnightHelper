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
}
