local _, ns = ...

--[[
	Midnight Helper — flight points for the Midnight zones.

	WHY. On 15 Aug 2026 Rob clicked a coordinate link while standing in Silvermoon
	and got nothing. The click now reports what it did (see DelveTipMarkup's
	ReportWaypointResult), but "you are in Silvermoon City, the waypoint is in the
	Vaults of Atal'Utek" still leaves the actual question unanswered: how do I get
	there? His own suggestion: pull the flight points out of Zygor.

	SOURCE. ZygorGuidesViewer's `fpath` lines in Guides-Retail (the Midnight guides),
	with the zone name resolved to a uiMapID through Zygor's OWN LibRover table
	(Libs-Retail/LibRover-1.0/data.lua) rather than through anything I remembered.
	Two Zygor datasets cross-checked against each other, and this repo already trusts
	Zygor for quest chains, transitions and coordinates of exactly this kind.

	⚠️ One apparent contradiction was chased down rather than waved away. LibRover
	maps "Zul Aman M" to 2437 and "Eversong Woods M" to 2395, while our delve roster
	lists Atal'Aman — a Zul'Aman-themed delve — on 2395. Our own Rares.lua settles it:
	[2395] = "eversong", [2437] = "zulaman". LibRover agrees with us; the delve entry
	is simply an entrance that sits in Eversong. Nothing here is swapped.

	⚠️ These are still CANDIDATES. Zygor's coordinates have been ~right all year and
	Rob's standing rule is to use them without a spot-check, but a flight point that
	does not exist sends someone on a walk. If one is wrong, the symptom is a named
	flight master who is not there — report it and it comes out.

	Floors: three entries live on a non-zero floor in Zygor's notation (Atal'Aman
	floor 1, The Den floor 2). Recorded in the comments; the advice only names the
	flight master, so the floor never reaches the player.
]]

--- uiMapID -> { { name, x, y }, ... }
--- uiMapID -> { { name, x, y, faction }, ... }
---
--- ⚠️ REGENERATED 16 aug 2026 from Zygor (LibTaxi joined to LibRover through
--- their own name->uiMapID table, never by matching zone names by eye). Rerun
--- tools/flight_points.py after a Zygor update: it diffs before it prints.
---
--- Our own measured stops were KEPT and take precedence. Amani Foothold
--- (Eagletender Mal'Tiki, in the Vaults) and Atal'Aman exist only here —
--- overwriting the file wholesale would have traded two things we know are
--- right for 626 we have not walked to.
---
--- faction: "A", "H" or "B". Sending an Alliance player to a Horde flight
--- master is a confident wrong answer, so the filter needs the letter.
ns.FLIGHT_POINTS = {
	[1] = {
		{ "Razor Hill", 53.09, 43.58, "H" },
		{ "Sen'jin Village", 55.38, 73.31, "H" },
	},
	[7] = {
		{ "Bloodhoof Village", 47.44, 58.64, "H" },
	},
	[10] = {
		{ "Nozzlepot's Outpost", 62.31, 17.12, "H" },
		{ "Ratchet", 69.12, 70.70, "B" },
		{ "The Crossroads", 48.70, 58.67, "H" },
		{ "The Mor'Shan Ramparts", 41.98, 15.87, "H" },
	},
	[14] = {
		{ "Galen's Fall", 13.31, 34.82, "H" },
		{ "Hammerfall", 68.16, 33.39, "H" },
		{ "Refuge Pointe", 39.89, 47.35, "A" },
	},
	[15] = {
		{ "Bloodwatcher Point", 52.40, 50.74, "H" },
		{ "Dragon's Mouth", 21.57, 57.80, "A" },
		{ "Dustwind Dig", 48.99, 36.20, "A" },
		{ "Fuselight", 64.33, 35.03, "B" },
		{ "New Kargath", 17.18, 40.01, "H" },
	},
	[17] = {
		{ "Dreadmaul Hold", 43.71, 14.25, "H" },
		{ "Nethergarde Keep", 61.25, 21.58, "A" },
		{ "Shattered Beachhead", 67.64, 27.97, "A" },
		{ "Shattered Landing", 72.95, 48.63, "H" },
		{ "Sunveil Excursion", 50.92, 72.88, "H" },
		{ "Surwich", 47.13, 89.36, "A" },
	},
	[18] = {
		{ "Brill", 58.84, 51.94, "H" },
		{ "The Bulwark", 83.58, 69.95, "H" },
	},
	[21] = {
		{ "Forsaken Rear Guard", 45.93, 21.88, "H" },
		{ "The Forsaken Front", 50.87, 63.62, "H" },
		{ "The Sepulcher", 45.41, 42.48, "H" },
	},
	[22] = {
		{ "Andorhal", 39.43, 69.55, "A" },
		{ "Chillwind Camp", 42.92, 85.06, "A" },
		{ "Hearthglen", 44.66, 18.47, "B" },
		{ "The Menders' Stead", 50.50, 52.23, "B" },
	},
	[23] = {
		{ "Crown Guard Tower", 34.90, 67.89, "B" },
		{ "Eastwall Tower", 61.64, 43.84, "B" },
		{ "Light's Hope Chapel", 75.85, 53.41, "A" },
		{ "Light's Shield Tower", 52.77, 53.57, "B" },
		{ "Northpass Tower", 51.35, 21.31, "B" },
		{ "Plaguewood Tower", 18.46, 27.37, "B" },
		{ "Thondroril River", 10.09, 65.66, "B" },
	},
	[25] = {
		{ "Eastpoint Tower", 59.61, 63.25, "H" },
		{ "Ruins of Southshore", 49.02, 66.21, "H" },
		{ "Southpoint Gate", 29.14, 64.41, "H" },
		{ "Strahnbrad", 58.23, 26.48, "H" },
		{ "Tarren Mill", 56.06, 46.08, "H" },
	},
	[26] = {
		{ "Aerie Peak", 11.07, 46.15, "A" },
		{ "Hiri'watha Research Station", 32.45, 58.08, "H" },
		{ "Revantusk Village", 81.71, 81.75, "H" },
		{ "Stormfeather Outpost", 65.77, 44.87, "A" },
	},
	[27] = {
		{ "Gol'Bolar Quarry", 75.87, 54.44, "A" },
		{ "Kharanos", 53.80, 52.76, "A" },
	},
	[32] = {
		{ "Iron Summit", 41.06, 68.78, "B" },
		{ "Thorium Point", 37.94, 30.86, "A" },
	},
	[37] = {
		{ "Eastvale Logging Camp", 81.83, 66.56, "A" },
		{ "Goldshire", 41.71, 64.64, "A" },
	},
	[47] = {
		{ "Darkshire", 77.48, 44.28, "A" },
		{ "Raven Hill", 21.08, 56.44, "A" },
	},
	[48] = {
		{ "Farstrider Lodge", 81.88, 64.07, "A" },
		{ "Thelsamar", 33.94, 50.95, "A" },
	},
	[49] = {
		{ "Camp Everstill", 52.92, 54.64, "A" },
		{ "Lakeshire", 29.42, 53.76, "A" },
		{ "Shalewind Canyon", 77.97, 65.91, "A" },
	},
	[50] = {
		{ "Bambala", 62.40, 39.24, "H" },
		{ "Fort Livingston", 52.64, 66.10, "A" },
		{ "Grom'gol", 39.01, 51.25, "H" },
		{ "Rebel Camp", 47.86, 11.85, "A" },
	},
	[51] = {
		{ "Bogpaddle", 72.02, 12.04, "B" },
		{ "Marshtide Watch", 70.05, 38.57, "A" },
		{ "Stonard", 47.78, 55.22, "H" },
		{ "The Harborage", 30.78, 34.60, "A" },
	},
	[52] = {
		{ "Furlbrow's Pumpkin Farm", 49.79, 18.69, "A" },
		{ "Moonbrook", 42.08, 63.28, "A" },
		{ "Sentinel Hill", 56.64, 49.44, "A" },
	},
	[56] = {
		{ "Dun Modr", 49.90, 18.56, "A" },
		{ "Greenwarden's Grove", 56.31, 41.85, "A" },
		{ "Menethil Harbor", 9.45, 59.58, "A" },
		{ "Slabchisel's Survey", 56.87, 71.10, "A" },
		{ "Whelgar's Retreat", 38.78, 39.04, "A" },
	},
	[57] = {
		{ "Dolanaar", 55.47, 50.42, "A" },
		{ "Rut'theran Village", 55.41, 88.40, "A" },
	},
	[62] = {
		{ "Bashal'Aran", 46.85, 33.18, "A" },
		{ "Grove of the Ancients", 44.41, 75.47, "A" },
		{ "Lor'danel", 51.72, 17.65, "A" },
		{ "Ruins of Mathystra", 58.57, 19.99, "A" },
		{ "Shatterspear Vale", 69.11, 18.87, "A" },
	},
	[63] = {
		{ "Astranaar", 34.41, 47.99, "A" },
		{ "Blackfathom Camp", 18.14, 20.59, "A" },
		{ "Forest Song", 85.09, 43.45, "A" },
		{ "Hellscream's Watch", 38.08, 42.22, "H" },
		{ "Maestra's Post", 26.80, 35.99, "A" },
		{ "Silverwind Refuge", 49.29, 65.25, "H" },
		{ "Splintertree Post", 73.18, 61.59, "H" },
		{ "Stardust Spire", 35.02, 72.07, "A" },
		{ "Zoram'gar Outpost", 11.17, 34.43, "H" },
	},
	[64] = {
		{ "Fizzle & Pozzik's Speedbarge", 79.15, 71.95, "A" },
		{ "Westreach Summit", 11.21, 11.58, "H" },
	},
	[65] = {
		{ "Cliffwalker Post", 45.11, 30.87, "H" },
		{ "Farwatcher's Glen", 32.02, 61.84, "A" },
		{ "Krom'gar Fortress", 66.52, 62.75, "H" },
		{ "Malaka'jin", 70.61, 89.46, "H" },
		{ "Mirkfallon Post", 48.64, 51.52, "A" },
		{ "Northwatch Expedition Base Camp", 70.92, 80.58, "A" },
		{ "Sun Rock Retreat", 48.48, 61.95, "H" },
		{ "Thal'darah Overlook", 40.12, 31.96, "A" },
		{ "The Sludgewerks", 53.87, 40.12, "H" },
		{ "Windshear Hold", 58.80, 54.28, "A" },
	},
	[66] = {
		{ "Ethel Rethor", 39.07, 26.93, "B" },
		{ "Furien's Post", 44.28, 29.68, "H" },
		{ "Karnum's Glade", 57.72, 49.75, "B" },
		{ "Nijel's Point", 64.66, 10.54, "A" },
		{ "Shadowprey Village", 21.60, 74.13, "H" },
		{ "Thargad's Camp", 36.76, 71.68, "A" },
		{ "Thunk's Abode", 70.67, 32.89, "B" },
	},
	[69] = {
		{ "Camp Ataya", 41.54, 15.46, "H" },
		{ "Camp Mojache", 75.45, 44.36, "H" },
		{ "Dreamer's Rest", 50.21, 16.72, "A" },
		{ "Feathermoon", 46.77, 45.35, "A" },
		{ "Shadebough", 77.31, 56.79, "A" },
		{ "Stonemaul Hold", 51.00, 48.42, "H" },
		{ "Tower of Estulan", 57.08, 53.95, "A" },
	},
	[70] = {
		{ "Brackenwall Village", 35.57, 31.88, "H" },
		{ "Mudsprocket", 42.82, 72.43, "B" },
		{ "Theramore", 67.48, 51.30, "A" },
	},
	[71] = {
		{ "Bootlegger Outpost", 55.88, 60.60, "B" },
		{ "Dawnrise Expedition", 33.30, 77.36, "H" },
		{ "Gadgetzan", 51.35, 29.49, "A" },
		{ "Gunstan's Dig", 40.05, 77.54, "A" },
	},
	[76] = {
		{ "Bilgewater Harbor", 52.92, 49.86, "H" },
		{ "Northern Rocketway", 66.50, 21.01, "H" },
		{ "Southern Rocketway", 51.49, 74.29, "H" },
		{ "Valormok", 14.35, 65.02, "H" },
	},
	[77] = {
		{ "Emerald Sanctuary", 51.53, 80.87, "B" },
		{ "Irontree Clearing", 56.36, 8.64, "H" },
		{ "Talonbranch Glade", 60.52, 25.29, "A" },
		{ "Whisperwind Grove", 43.59, 28.70, "B" },
		{ "Wildheart Point", 44.29, 61.87, "B" },
	},
	[80] = {
		{ "Moonglade", 48.10, 67.34, "A" },
	},
	[81] = {
		{ "Cenarion Hold", 54.40, 32.72, "A" },
	},
	[83] = {
		{ "Everlook", 60.99, 48.62, "A" },
	},
	[84] = {
		{ "Stormwind", 70.94, 72.46, "A" },
	},
	[85] = {
		{ "Orgrimmar", 49.65, 59.21, "H" },
	},
	[87] = {
		{ "Ironforge", 55.51, 47.74, "A" },
	},
	[88] = {
		{ "Thunder Bluff", 47.02, 49.60, "H" },
	},
	[89] = {
		{ "Darnassus", 36.61, 47.83, "A" },
	},
	[90] = {
		{ "Undercity", 63.26, 48.55, "H" },
	},
	[94] = {
		{ "Fairbreeze Village", 43.94, 69.98, "H" },
		{ "Falconwing Square", 46.25, 46.79, "H" },
		{ "Silvermoon City", 54.37, 50.73, "H" },
	},
	[95] = {
		{ "Tranquillien", 45.42, 30.52, "H" },
		{ "Zul'Aman", 74.76, 67.15, "B" },
	},
	[97] = {
		{ "Azure Watch", 49.71, 49.10, "A" },
	},
	[100] = {
		{ "Falcon Watch", 27.79, 59.98, "H" },
		{ "Hellfire Peninsula, The Dark Portal", 87.36, 52.42, "A" },
		{ "Honor Hold", 54.68, 62.35, "A" },
		{ "Shatter Point", 78.42, 34.90, "A" },
		{ "Spinebreaker Ridge", 61.65, 81.19, "H" },
		{ "Temple of Telhamat", 25.19, 37.23, "A" },
		{ "Thrallmar", 56.29, 36.25, "H" },
	},
	[102] = {
		{ "Orebor Harborage", 41.28, 29.00, "A" },
		{ "Swamprat Post", 84.76, 55.11, "H" },
		{ "Telredor", 67.83, 51.46, "A" },
		{ "Zabra'jin", 33.07, 51.07, "H" },
	},
	[103] = {
		{ "The Exodar", 54.49, 36.27, "A" },
	},
	[104] = {
		{ "Shadowmoon Village", 30.34, 29.19, "H" },
		{ "Wildhammer Stronghold", 37.61, 55.45, "A" },
	},
	[106] = {
		{ "Blood Watch", 57.68, 53.88, "A" },
	},
	[107] = {
		{ "Garadar", 57.19, 35.25, "H" },
		{ "Telaar", 54.17, 75.06, "A" },
	},
	[108] = {
		{ "Allerian Stronghold", 59.45, 55.43, "A" },
		{ "Stonebreaker Hold", 49.19, 43.42, "H" },
	},
	[109] = {
		{ "Area 52", 33.74, 63.99, "B" },
		{ "Cosmowrench", 65.20, 66.81, "B" },
		{ "The Stormspire", 45.31, 34.87, "B" },
	},
	[111] = {
		{ "Shattrath", 64.07, 41.12, "B" },
	},
	[114] = {
		{ "Amber Ledge", 45.32, 34.49, "B" },
		{ "Bor'gorok Outpost", 49.65, 11.05, "H" },
		{ "Fizzcrank Airstrip", 56.57, 20.06, "A" },
		{ "Taunka'le Village", 77.76, 37.77, "H" },
		{ "Transitus Shield", 33.13, 34.44, "B" },
		{ "Unu'pe", 78.54, 51.53, "B" },
		{ "Valiance Keep", 58.96, 68.29, "A" },
		{ "Warsong Hold", 40.36, 51.40, "H" },
	},
	[115] = {
		{ "Agmar's Hammer", 37.51, 45.76, "H" },
		{ "Fordragon Hold", 39.52, 25.91, "A" },
		{ "Kor'kron Vanguard", 43.85, 16.94, "H" },
		{ "Moa'ki", 48.51, 74.39, "B" },
		{ "Stars' Rest", 29.18, 55.32, "A" },
		{ "Venomspite", 76.48, 62.21, "H" },
		{ "Wintergarde Keep", 77.00, 49.79, "A" },
		{ "Wyrmrest Temple", 60.32, 51.55, "B" },
	},
	[116] = {
		{ "Amberpine Lodge", 31.31, 59.11, "A" },
		{ "Camp Oneqwah", 64.96, 46.93, "H" },
		{ "Conquest Hold", 21.99, 64.43, "H" },
		{ "Westfall Brigade", 59.89, 26.68, "A" },
	},
	[117] = {
		{ "Apothecary Camp", 25.98, 25.07, "H" },
		{ "Camp Winterhoof", 49.56, 11.59, "H" },
		{ "Fort Wildervar", 60.06, 16.11, "A" },
		{ "Kamagua", 24.66, 57.77, "B" },
		{ "New Agamand", 52.01, 67.38, "H" },
		{ "Valgarde Port", 59.79, 63.24, "A" },
		{ "Vengeance Landing", 79.04, 29.71, "H" },
		{ "Westguard Keep", 31.26, 43.98, "A" },
	},
	[118] = {
		{ "Argent Tournament Grounds", 72.59, 22.61, "B" },
		{ "Death's Rise", 19.34, 47.78, "B" },
		{ "The Argent Vanguard", 87.80, 78.07, "B" },
	},
	[119] = {
		{ "River's Heart", 50.13, 61.36, "B" },
	},
	[120] = {
		{ "Bouldercrag's Refuge", 30.65, 36.32, "B" },
		{ "Camp Tunka'lo", 65.41, 50.60, "H" },
		{ "Frosthold", 29.50, 74.33, "A" },
		{ "Grom'arsh Crash-Site", 36.19, 49.39, "H" },
		{ "K3", 40.75, 84.55, "B" },
		{ "Ulduar", 44.49, 28.19, "B" },
	},
	[123] = {
		{ "Valiance Landing Camp", 71.98, 30.95, "A" },
		{ "Warsong Camp", 21.62, 34.95, "H" },
	},
	[125] = {
		{ "Dalaran", 72.18, 45.77, "B" },
	},
	[127] = {
		{ "Sunreaver's Command", 78.54, 50.41, "H" },
		{ "Windrunner's Overlook", 72.17, 80.97, "A" },
	},
	[198] = {
		{ "Grove of Aessina", 19.59, 36.38, "B" },
		{ "Nordrassil", 62.13, 21.59, "B" },
		{ "Shrine of Aviana", 41.18, 42.59, "B" },
	},
	[199] = {
		{ "Desolation Hold", 41.24, 70.76, "H" },
		{ "Fort Triumph", 49.20, 67.80, "A" },
		{ "Honor's Stand", 38.93, 10.88, "A" },
		{ "Hunter's Hill", 39.79, 20.26, "H" },
		{ "Northwatch Hold", 66.38, 47.13, "A" },
		{ "Vendetta Point", 41.55, 47.60, "H" },
	},
	[204] = {
		{ "Darkbreak Cove", 56.90, 75.53, "A" },
		{ "Tenebrous Cavern", 53.88, 59.62, "H" },
	},
	[205] = {
		{ "Legion's Rest", 50.74, 63.47, "H" },
		{ "Sandy Beach", 57.04, 17.05, "A" },
		{ "Silver Tide Hollow", 49.52, 41.21, "B" },
		{ "Tranquil Wash", 48.55, 57.43, "A" },
	},
	[210] = {
		{ "Booty Bay", 41.67, 74.53, "A" },
		{ "Explorers' League Digsite", 55.74, 41.22, "A" },
		{ "Hardwrench Hideaway", 35.14, 29.39, "H" },
	},
	[217] = {
		{ "Forsaken Forward Command", 57.28, 17.75, "H" },
	},
	[241] = {
		{ "Bloodgulch", 54.15, 42.22, "H" },
		{ "Crushblow", 45.76, 76.19, "H" },
		{ "Firebeard's Patrol", 60.42, 57.65, "A" },
		{ "Kirthaven", 56.78, 15.11, "A" },
		{ "The Gullet", 36.90, 37.99, "H" },
		{ "The Krazzworks", 75.33, 17.79, "H" },
		{ "Thundermar", 48.54, 28.10, "A" },
		{ "Victor's Point", 43.89, 57.27, "A" },
	},
	[249] = {
		{ "Oasis of Vir'sar", 26.61, 8.38, "B" },
		{ "Ramkahen", 56.19, 33.60, "B" },
		{ "Schnottz's Landing", 22.29, 64.93, "B" },
	},
	[371] = {
		{ "Dawn's Blossom", 47.05, 46.24, "B" },
		{ "Emperor's Omen", 50.82, 26.80, "B" },
		{ "Grookin Hill", 27.81, 47.91, "H" },
		{ "Honeydew Village", 28.11, 15.62, "H" },
		{ "Jade Temple Grounds", 54.57, 61.76, "B" },
		{ "Paw'Don Village", 46.04, 85.15, "A" },
		{ "Pearlfin Village", 57.95, 82.51, "A" },
		{ "Serpent's Overlook", 43.10, 68.49, "B" },
		{ "Sri-La Village", 55.38, 23.73, "B" },
		{ "The Arboretum", 57.01, 44.03, "B" },
		{ "Tian Monastery", 43.57, 24.53, "B" },
	},
	[376] = {
		{ "Grassy Cline", 70.82, 24.10, "B" },
		{ "Halfhill", 56.50, 50.36, "B" },
		{ "Pang's Stead", 84.50, 21.06, "B" },
	},
	[379] = {
		{ "Binan Village", 72.55, 94.17, "B" },
		{ "Eastwind Rest", 62.43, 80.72, "H" },
		{ "Kota Basecamp", 42.81, 69.64, "B" },
		{ "One Keg", 57.73, 59.69, "B" },
		{ "Serpent's Spine", 35.97, 83.71, "H" },
		{ "Shado-Pan Fallback", 43.91, 89.54, "B" },
		{ "Temple of the White Tiger", 66.31, 50.67, "B" },
		{ "Westwind Rest", 53.98, 84.27, "A" },
		{ "Winter's Blossom", 34.54, 59.12, "B" },
		{ "Zouchin Village", 62.42, 30.12, "B" },
	},
	[388] = {
		{ "Gao-Ran Battlefront", 74.39, 81.46, "B" },
		{ "Longying Outpost", 71.08, 57.32, "B" },
		{ "Rensai's Watchpost", 54.29, 79.05, "B" },
		{ "Shado-Pan Garrison", 50.08, 71.98, "B" },
	},
	[390] = {
		{ "Serpent's Spine", 14.22, 79.28, "B" },
		{ "Shrine of Seven Stars", 84.61, 62.41, "A" },
		{ "Shrine of Two Moons", 62.86, 21.80, "H" },
		{ "The Lion's Redoubt", 11.11, 101.67, "A" },
	},
	[418] = {
		{ "Cradle of Chi-Ji", 31.14, 63.16, "B" },
		{ "Dawnchaser Retreat", 29.00, 50.32, "H" },
		{ "Domination Point", 9.69, 52.51, "H" },
		{ "Lion's Landing", 88.33, 34.69, "A" },
		{ "Marista", 52.48, 76.60, "B" },
		{ "Sentinel Basecamp", 25.14, 33.46, "A" },
		{ "The Incursion", 67.77, 32.49, "A" },
		{ "Thunder Cleft", 59.20, 24.67, "H" },
		{ "Zhu's Watch", 76.74, 8.38, "B" },
	},
	[422] = {
		{ "Klaxxi'vess", 55.83, 34.88, "B" },
		{ "Soggy's Gamble", 56.10, 70.18, "B" },
		{ "The Briny Muck", 42.53, 55.75, "B" },
		{ "The Sunset Brewgarden", 50.20, 12.24, "B" },
	},
	[433] = {
		{ "Tavern in the Mists", 56.74, 75.75, "B" },
	},
	[507] = {
		{ "Beeble's Wreck", 41.75, 79.31, "A" },
		{ "Bozzle's Wreck", 52.02, 75.50, "H" },
	},
	[525] = {
		{ "Bladespire Citadel", 19.95, 51.78, "H" },
		{ "Bloodmaul Slag Mines", 51.45, 21.45, "B" },
		{ "Darkspear's Edge", 51.70, 41.12, "H" },
		{ "Iron Siegeworks", 87.42, 62.60, "A" },
		{ "Stonefang Outpost", 40.11, 51.84, "H" },
		{ "Throm'Var", 31.83, 9.56, "H" },
		{ "Thunder Pass", 83.62, 60.88, "H" },
		{ "Wolf's Stand", 73.63, 60.03, "H" },
		{ "Wor'gol", 21.57, 56.15, "H" },
	},
	[534] = {
		{ "Aktar's Post", 26.14, 38.88, "B" },
		{ "Lion's Watch", 57.51, 58.76, "A" },
		{ "Malo's Lookout", 43.40, 42.24, "B" },
		{ "Sha'naari Refuge", 29.55, 63.14, "B" },
		{ "The Iron Front", 10.03, 53.07, "A" },
		{ "Vault of the Earth", 47.00, 70.26, "B" },
		{ "Vol'mar", 60.43, 46.44, "H" },
	},
	[535] = {
		{ "Anchorite's Sojourn", 80.08, 56.68, "A" },
		{ "Durotan's Grasp", 55.42, 40.82, "H" },
		{ "Exarch's Refuge", 54.79, 68.79, "A" },
		{ "Fort Wrynn", 69.86, 21.49, "A" },
		{ "Frostwolf Overlook", 61.41, 10.51, "H" },
		{ "Redemption Rise", 63.29, 25.72, "A" },
		{ "Retribution Point", 42.11, 76.79, "B" },
		{ "Shattrath City", 51.27, 42.66, "B" },
		{ "Terokkar Refuge", 70.34, 57.10, "B" },
		{ "Vol'jin's Pride", 70.74, 29.40, "H" },
		{ "Zangarra", 80.42, 25.32, "B" },
	},
	[539] = {
		{ "Darktide Roost", 59.85, 81.38, "B" },
		{ "Elodor", 58.68, 31.92, "A" },
		{ "Embaari Village", 45.68, 38.86, "A" },
		{ "Exile's Rise", 45.57, 25.40, "B" },
		{ "Path of Light", 59.37, 45.98, "A" },
		{ "Socrethar's Rise", 43.89, 77.53, "B" },
		{ "Temple of Karabor", 0.00, 0.00, "B" },
		{ "The Draakorium", 57.03, 56.63, "A" },
		{ "Tranquil Court", 70.42, 50.42, "A" },
		{ "Twilight Glade", 40.73, 55.28, "A" },
	},
	[542] = {
		{ "Akeeta's Hovel", 65.67, 17.51, "B" },
		{ "Apexis Excavation", 36.99, 24.62, "B" },
		{ "Axefall", 39.51, 43.37, "H" },
		{ "Crow's Crook", 51.82, 31.05, "B" },
		{ "Pinchwhistle Gearworks", 60.88, 73.30, "B" },
		{ "Southport", 39.08, 61.80, "A" },
		{ "Talon Watch", 61.90, 42.62, "B" },
		{ "Veil Terokk", 46.17, 44.12, "B" },
	},
	[543] = {
		{ "Bastion Rise", 46.40, 92.41, "A" },
		{ "Beastwatch", 45.98, 69.22, "H" },
		{ "Breaker's Crown", 45.87, 54.94, "B" },
		{ "Deeproot", 46.47, 76.60, "A" },
		{ "Everbloom Overlook", 68.72, 28.75, "B" },
		{ "Everbloom Wilds", 57.01, 45.88, "B" },
		{ "Evermorn Springs", 41.31, 87.17, "H" },
		{ "Highpass", 52.83, 59.33, "A" },
		{ "Iron Docks", 43.04, 20.21, "B" },
		{ "Skysea Ridge", 39.55, 36.58, "B" },
		{ "Wildwood Wash", 64.16, 57.50, "A" },
	},
	[550] = {
		{ "Joz's Rylaks", 62.24, 32.90, "B" },
		{ "Nivek's Overlook", 49.38, 75.91, "B" },
		{ "Rilzit's Holdfast", 50.75, 30.64, "B" },
		{ "Riverside Post", 49.56, 48.06, "H" },
		{ "Telaari Station", 63.64, 61.56, "A" },
		{ "The Ring of Trials", 79.82, 49.72, "B" },
		{ "Throne of the Elements", 73.70, 26.65, "B" },
		{ "Wor'var", 83.31, 44.68, "H" },
		{ "Yrel's Watch", 62.66, 40.65, "A" },
	},
	[554] = {
		{ "Huojin Landing", 21.92, 39.75, "H" },
		{ "Tushui Landing", 23.08, 71.05, "A" },
	},
	[582] = {
		{ "Lunarfall", 47.99, 49.81, "A" },
	},
	[590] = {
		{ "Frostwall", 45.79, 50.92, "H" },
	},
	[622] = {
		{ "Stormshield", 30.57, 48.47, "A" },
	},
	[624] = {
		{ "Warspear", 44.15, 33.87, "H" },
	},
	[626] = {
		{ "Dalaran", 69.83, 51.11, "B" },
	},
	[630] = {
		{ "Azurewing Repose", 48.45, 28.07, "B" },
		{ "Challiane's Terrace", 40.81, 9.02, "B" },
		{ "Felblaze Ingress", 63.84, 28.47, "B" },
		{ "Illidari Perch", 31.81, 46.29, "B" },
		{ "Illidari Stand", 44.60, 43.85, "B" },
		{ "Shackle's Den", 56.19, 58.92, "B" },
		{ "Wardens' Redoubt", 48.19, 72.95, "B" },
		{ "Watchers' Aerie", 51.75, 82.11, "B" },
	},
	[634] = {
		{ "Cullen's Post", 44.89, 59.14, "H" },
		{ "Dreadwake's Landing", 54.52, 73.03, "H" },
		{ "Forsaken Foothold", 36.49, 30.62, "H" },
		{ "Greywatch", 72.15, 59.82, "A" },
		{ "Hafr Fjall", 55.63, 87.43, "B" },
		{ "Lorna's Watch", 37.41, 63.99, "A" },
		{ "Shield's Rest", 89.87, 10.68, "B" },
		{ "Skyfire Triage Camp", 33.59, 50.65, "A" },
		{ "Stormtorn Foothills", 51.97, 34.81, "B" },
		{ "Valdisdall", 60.73, 50.88, "B" },
	},
	[646] = {
		{ "Aalgen Point", 70.76, 47.62, "B" },
		{ "Deliverance Point", 45.16, 64.12, "B" },
		{ "Vengeance Point", 49.67, 21.02, "B" },
	},
	[650] = {
		{ "Felbane Camp", 29.93, 39.32, "B" },
		{ "Ironhorn Enclave", 56.82, 83.85, "B" },
		{ "Nesingwary", 40.23, 52.70, "B" },
		{ "Obsidian Overlook", 47.26, 84.64, "B" },
		{ "Prepfoot", 57.98, 28.62, "B" },
		{ "Shipwreck Cove", 41.90, 10.42, "B" },
		{ "Skyhorn", 52.60, 45.32, "B" },
		{ "Stonehoof Watch", 59.23, 65.05, "B" },
		{ "Sylvan Falls", 35.86, 65.92, "B" },
		{ "The Witchwood", 38.35, 39.29, "B" },
	},
	[680] = {
		{ "Crimson Thicket", 64.27, 41.98, "B" },
		{ "Irongrove Retreat", 25.46, 31.73, "B" },
		{ "Meredil", 34.38, 49.41, "B" },
	},
	[739] = {
		{ "Trueshot Lodge", 35.80, 27.58, "B" },
	},
	[747] = {
		{ "The Dreamgrove", 61.73, 33.99, "B" },
	},
	[750] = {
		{ "Thunder Totem", 44.75, 38.55, "B" },
	},
	[790] = {
		{ "Eye of Azshara", 38.28, 46.07, "B" },
	},
	[862] = {
		{ "Atal'Gral", 79.97, 41.39, "B" },
		{ "Atal'dazar", 46.17, 35.81, "H" },
		{ "Castaway Encampment", 77.66, 54.45, "A" },
		{ "Garden of the Loa", 49.72, 26.27, "H" },
		{ "Isle of Fangs", 54.45, 87.06, "H" },
		{ "Mistvine Ledge", 64.33, 47.33, "A" },
		{ "Mugamba Overlook", 44.84, 27.07, "A" },
		{ "Nesingwary's Gameland", 66.19, 17.60, "B" },
		{ "Scaletrader Post", 70.78, 29.60, "B" },
		{ "Seeker's Outpost", 70.45, 65.31, "B" },
		{ "Temple of the Prophet", 49.81, 44.59, "H" },
		{ "The Mugambala", 53.34, 57.33, "H" },
		{ "Tusk Isle", 59.39, 77.94, "H" },
		{ "Verdant Hollow", 55.65, 24.85, "A" },
		{ "Warbeast Kraal", 67.26, 43.03, "H" },
		{ "Warport Rastari", 48.22, 60.34, "H" },
		{ "Xibala", 44.84, 72.25, "H" },
		{ "Zeb'ahari", 77.36, 15.35, "H" },
	},
	[863] = {
		{ "Forlorn Ruins", 82.15, 26.69, "H" },
		{ "Fort Victory", 62.35, 41.38, "A" },
		{ "Gloom Hollow", 66.98, 43.76, "H" },
		{ "Grimwatt's Crash", 34.31, 63.21, "A" },
		{ "Redfield's Watch", 50.82, 20.77, "A" },
		{ "Zo'bal Ruins", 40.17, 42.83, "H" },
		{ "Zul'jan", 38.85, 78.14, "H" },
	},
	[895] = {
		{ "Anglepoint Wharf", 42.15, 30.67, "A" },
		{ "Bridgeport", 75.79, 48.59, "A" },
		{ "Castaway Point", 86.42, 80.81, "B" },
		{ "Eastpoint Station", 74.23, 44.34, "A" },
		{ "Firebreaker Expedition", 63.84, 30.38, "A" },
		{ "Freehold", 77.03, 82.89, "B" },
		{ "Hatherford", 66.93, 23.06, "A" },
		{ "Kennings Lodge", 76.67, 65.42, "A" },
		{ "Norwington Estate", 52.91, 28.80, "A" },
		{ "Old Drust Road", 54.01, 53.21, "A" },
		{ "Outrigger Post", 35.55, 24.90, "A" },
		{ "Plunder Harbor", 87.28, 50.66, "H" },
		{ "Roughneck Camp", 42.48, 23.02, "A" },
		{ "Southwind Ferry Dock", 66.74, 49.76, "A" },
		{ "Stonefist Watch", 53.14, 63.16, "H" },
		{ "Timberfell Outpost", 72.18, 51.91, "H" },
		{ "Vigil Hill", 57.74, 61.54, "A" },
		{ "Waning Glacier", 39.68, 18.54, "H" },
		{ "Wolf's Den", 62.11, 13.57, "H" },
	},
	[896] = {
		{ "Anyport", 19.14, 43.31, "B" },
		{ "Arom's Stand", 38.14, 52.53, "A" },
		{ "Barbthorn Ridge", 62.61, 23.99, "A" },
		{ "Falconhurst", 26.98, 72.38, "A" },
		{ "Fallhaven", 55.13, 34.70, "A" },
		{ "Fletcher's Hollow", 70.21, 60.45, "A" },
		{ "Hangman's Point", 71.06, 40.88, "A" },
		{ "Krazzlefrazz Outpost", 37.37, 24.04, "H" },
		{ "Mudfisher Cove", 62.03, 16.88, "H" },
		{ "Swiftwind Post", 66.46, 59.32, "H" },
		{ "Watchman's Rise", 31.87, 30.45, "A" },
		{ "Whitegrove Chapel", 25.74, 16.56, "B" },
	},
	[942] = {
		{ "Brennadam", 59.73, 70.56, "A" },
		{ "Deadwash", 42.77, 57.54, "A" },
		{ "Diretusk Hollow", 54.27, 49.35, "H" },
		{ "Fort Daelin", 34.28, 47.23, "A" },
		{ "Hillcrest Pasture", 52.76, 80.13, "H" },
		{ "Ironmaul Overlook", 75.88, 64.14, "H" },
		{ "Mildenhall Meadery", 68.53, 64.99, "A" },
		{ "Millstone Hamlet", 30.75, 66.57, "A" },
		{ "Seekers Vista", 40.03, 37.32, "B" },
		{ "Stonetusk Watch", 38.84, 66.64, "H" },
		{ "The Amber Waves", 50.75, 70.21, "A" },
		{ "Tidecross", 65.56, 48.00, "A" },
		{ "Warfang Hold", 51.42, 33.74, "H" },
		{ "Windfall Cavern", 60.84, 27.12, "H" },
	},
	[1161] = {
		{ "Mariner's Row", 76.64, 72.62, "A" },
		{ "Proudmoore Keep", 47.76, 65.44, "A" },
		{ "Tradewinds Market", 66.97, 15.01, "A" },
		{ "Tradewinds Market Harbor", 74.17, 24.78, "A" },
	},
	[1169] = {
		{ "Ashen Strand", 31.85, 38.09, "A" },
		{ "Ekka's Hideaway", 63.98, 51.81, "H" },
		{ "Elun'alor Temple", 73.98, 40.03, "A" },
		{ "Kelya's Grave", 74.16, 24.92, "B" },
		{ "Mezzamere", 39.92, 54.12, "A" },
		{ "Newhome", 47.48, 63.26, "H" },
		{ "The Tidal Conflux", 49.81, 23.62, "A" },
		{ "Tol Dagor", 38.00, 92.00, "A" },
		{ "Utama's Stand", 61.68, 36.51, "A" },
		{ "Wreck of the Hungry Riverbeast", 36.14, 82.31, "H" },
		{ "Wreck of the Old Blanchy", 44.48, 85.51, "A" },
		{ "Zin'Azshari", 79.52, 37.92, "H" },
	},
	[1462] = {
		{ "Overspark Expedition Camp", 77.83, 40.94, "A" },
		{ "Prospectus Bay", 73.48, 25.80, "H" },
	},
	[1525] = {
		{ "Charred Ramparts", 38.95, 49.33, "B" },
		{ "Darkhaven", 60.50, 60.62, "B" },
		{ "Dominance Keep", 25.96, 28.88, "B" },
		{ "Halls of Atonement", 71.58, 40.06, "B" },
		{ "Menagerie of the Master", 54.22, 25.68, "B" },
		{ "Old Gate", 61.22, 38.79, "B" },
		{ "Pridefall Hamlet", 70.35, 81.16, "B" },
		{ "Sanctuary of the Mad", 30.56, 48.88, "B" },
		{ "Wanecrypt Hill", 47.88, 69.40, "B" },
	},
	[1527] = {
		{ "Oasis of Vir'sar", 26.61, 8.38, "B" },
		{ "Ramkahen", 56.19, 33.60, "B" },
	},
	[1530] = {
		{ "Mistfall Village", 38.91, 72.80, "B" },
		{ "The Golden Terrace", 63.11, 19.19, "H" },
		{ "The Summer Terrace", 85.17, 60.31, "A" },
	},
	[1533] = {
		{ "Aspirant's Rest", 48.10, 74.25, "B" },
		{ "Hero's Rest", 51.37, 46.80, "B" },
		{ "Sagehaven", 44.07, 32.45, "B" },
		{ "Terrace of the Collectors", 35.80, 21.07, "B" },
	},
	[1536] = {
		{ "Bleak Redoubt", 52.47, 67.65, "B" },
		{ "Keres' Rest", 53.82, 30.69, "B" },
		{ "Plague Watch", 58.14, 72.45, "B" },
		{ "Renounced Bastille", 67.93, 45.84, "B" },
		{ "Spider's Watch", 37.51, 29.22, "B" },
		{ "The Spearhead", 39.03, 55.24, "B" },
		{ "Theater of Pain", 49.91, 53.40, "B" },
	},
	[1543] = {
		{ "Ve'nari's Refuge", 47.29, 43.67, "B" },
	},
	[1565] = {
		{ "Claw's Edge", 51.30, 71.31, "B" },
		{ "Glitterfall Basin", 51.42, 34.52, "B" },
		{ "Heart of the Forest", 46.26, 50.81, "B" },
		{ "Hibernal Hollow", 60.35, 53.49, "B" },
		{ "Refugee Camp", 49.35, 51.82, "B" },
		{ "Root-Home", 35.14, 51.71, "B" },
		{ "Tirna Vaal", 63.46, 37.56, "B" },
	},
	[1670] = {
		{ "Oribos", 60.83, 68.60, "B" },
	},
	[1699] = {
		{ "Sinfall", 67.31, 21.42, "B" },
	},
	[1707] = {
		{ "Elysian Hold", 50.94, 49.03, "B" },
	},
	[1961] = {
		{ "Keeper's Respite", 64.97, 23.67, "B" },
	},
	[1970] = {
		{ "Antecedent Isle", 47.36, 13.29, "B" },
		{ "Faith's Repose", 35.62, 44.33, "B" },
		{ "Haven", 35.75, 65.11, "B" },
		{ "Pilgrim's Grace", 61.61, 50.21, "B" },
		{ "Primus Locus", 48.43, 26.35, "B" },
		{ "Quartus Locus", 48.52, 29.70, "B" },
		{ "Quintus Locus", 50.67, 32.60, "B" },
		{ "Secundus Locus", 47.96, 27.91, "B" },
		{ "Sepulcher Overlook", 64.89, 53.55, "B" },
		{ "Sepulcher of the First Ones", 73.00, 53.39, "B" },
		{ "Tertius Locus", 51.91, 27.11, "B" },
		{ "Ultimus Locus", 48.89, 31.43, "B" },
		{ "Zovaal's Grasp", 46.09, 21.62, "B" },
	},
	[2016] = {
		{ "Tazavesh", 91.96, 41.71, "B" },
	},
	[2022] = {
		{ "Apex Observatory", 23.79, 83.14, "B" },
		{ "Dragonscale Basecamp", 47.91, 83.32, "B" },
		{ "Life Vault Ruins", 65.03, 57.36, "B" },
		{ "Obsidian Bulwark", 42.26, 66.25, "B" },
		{ "Obsidian Throne", 25.27, 56.83, "B" },
		{ "Ruby Life Pools", 57.80, 68.12, "B" },
		{ "Skytop Observatory", 72.77, 51.91, "B" },
		{ "Uktulut Backwater", 54.32, 36.97, "B" },
		{ "Uktulut Outpost", 17.51, 88.70, "B" },
		{ "Uktulut Pier", 45.84, 27.48, "B" },
		{ "Wingrest Embassy", 76.03, 35.05, "B" },
	},
	[2024] = {
		{ "Azure Archives", 37.06, 60.82, "B" },
		{ "Camp Antonidas", 46.71, 39.56, "B" },
		{ "Camp Nowhere", 63.45, 58.67, "B" },
		{ "Iskaara", 13.29, 48.77, "B" },
		{ "Rhonin's Shield", 66.00, 25.39, "B" },
		{ "Theron's Watch", 65.37, 16.39, "B" },
		{ "Three-Falls Lookout", 19.15, 23.78, "B" },
	},
	[2025] = {
		{ "Garden Shrine", 35.62, 78.86, "B" },
		{ "Gelikyr Post", 51.16, 67.08, "B" },
		{ "Shifting Sands", 57.63, 79.02, "B" },
		{ "Temporal Conflux", 59.91, 81.34, "B" },
		{ "Vault of the Incarnates", 72.14, 56.45, "B" },
		{ "Veiled Ossuary", 62.07, 18.93, "B" },
	},
	[2029] = {
		{ "Arcae Locus", 40.33, 34.34, "B" },
		{ "Camber Alcove", 40.33, 34.34, "B" },
		{ "Dormant Alcove", 40.33, 34.34, "B" },
		{ "Fulgor Alcove", 40.33, 34.34, "B" },
		{ "Gravid Repose Locus", 59.35, 41.51, "B" },
		{ "Interior Locus", 40.33, 34.34, "B" },
		{ "Repertory Alcove", 40.33, 34.34, "B" },
		{ "Rondure Alcove", 43.00, 39.89, "B" },
	},
	[2070] = {
		{ "Brill", 58.76, 51.88, "H" },
	},
	[2112] = {
		{ "Valdrakken", 44.04, 67.97, "B" },
	},
	[2133] = {
		{ "Dragonscale Camp", 40.34, 67.80, "B" },
		{ "Loamm", 55.64, 54.79, "B" },
		{ "Obsidian Rest", 51.03, 26.17, "B" },
	},
	[2151] = {
		{ "Morqut Village", 35.85, 59.12, "B" },
	},
	[2200] = {
		{ "Central Encampment", 51.09, 62.35, "B" },
		{ "Eye of Ysera", 55.29, 29.57, "B" },
		{ "Verdant Landing", 68.82, 54.79, "B" },
		{ "Wellspring Overlook", 35.65, 33.66, "B" },
	},
	[2214] = {
		{ "Camp Murroch", 54.01, 64.05, "B" },
		{ "Gundargaz", 42.71, 33.36, "B" },
		{ "Gutterville", 71.52, 83.35, "B" },
		{ "Opportunity Point", 60.55, 78.08, "B" },
		{ "Shadowvein Point", 57.28, 47.94, "B" },
	},
	[2215] = {
		{ "Dunelle's Kindness", 67.48, 44.62, "B" },
		{ "Hillhelm Family Farm", 61.34, 30.99, "B" },
		{ "Light's Redoubt", 40.45, 71.31, "B" },
		{ "Lightspark", 52.86, 61.33, "B" },
		{ "Lorel's Crossing", 48.38, 40.71, "B" },
		{ "Mereldar", 41.57, 52.59, "B" },
		{ "Priory of the Sacred Flame", 41.14, 33.66, "B" },
		{ "The Aegis Wall", 71.36, 56.50, "B" },
	},
	[2239] = {
		{ "Bel'ameth", 50.23, 55.93, "B" },
	},
	[2248] = {
		{ "Durgaz Cabin", 67.48, 43.31, "B" },
		{ "Freywold Village", 41.04, 72.93, "B" },
		{ "Rambleshire", 59.16, 28.58, "B" },
		{ "Tranquil Strand", 29.74, 58.34, "B" },
	},
	[2255] = {
		{ "Faerin's Advance", 60.00, 18.70, "B" },
		{ "Mmarl", 76.84, 64.45, "B" },
		{ "Weaver's Lair", 56.87, 47.04, "B" },
		{ "Wildcamp Or'lay", 23.14, 51.14, "B" },
		{ "Wildcamp Ul'ar", 44.49, 67.48, "B" },
	},
	[2339] = {
		{ "Dornogal", 44.67, 51.16, "B" },
	},
	[2346] = {
		{ "Demolition Dome", 24.47, 58.02, "B" },
		{ "Slam Central Station", 24.47, 52.40, "B" },
		{ "The Gallagio", 61.68, 48.16, "B" },
		{ "The Heaps", 43.68, 79.28, "B" },
		{ "The Incontinental Hotel", 43.01, 45.98, "B" },
	},
	[2351] = {
		{ "Cragthorn Highlands", 66.30, 56.55, "H" },
		{ "Entrance Gate", 54.78, 51.22, "H" },
		{ "Runetotem's Bounty North", 42.70, 55.88, "H" },
		{ "Runetotem's Bounty South", 47.77, 69.90, "H" },
		{ "Saltfang Shoals East", 68.09, 75.59, "H" },
		{ "The Bloom", 59.21, 71.84, "H" },
		{ "The Bluffs", 52.71, 81.72, "H" },
		{ "The Common", 53.66, 59.72, "H" },
	},
	[2393] = {
		{ "Sanctum of Light", 50.97, 71.25, "B" },
		{ "The Royal Exchange", 69.36, 63.31, "B" },
	},
	[2395] = {
		{ "Fairbreeze Village", 44.70, 44.98, "B" },
		{ "Silverglade Refuge", 31.01, 90.07, "B" },
		{ "Tranquillien", 47.80, 67.13, "B" },
	},
	[2405] = {
		{ "Howling Ridge", 51.14, 69.26, "B" },
		{ "Locus Point", 42.29, 73.73, "B" },
		{ "The Ingress", 36.91, 58.98, "B" },
	},
	[2413] = {
		{ "Har'alnor", 31.73, 67.43, "B" },
		{ "Har'athir", 69.36, 52.60, "B" },
		{ "Har'kuai", 64.59, 23.15, "B" },
		{ "Har'mara", 35.53, 23.81, "B" },
		{ "The Den", 70.74, 53.23, "B" },
	},
	[2424] = {
		{ "Terrace of the Sun", 57.55, 33.85, "B" },
	},
	[2437] = {
		{ "Amani'Zar Village", 44.82, 65.43, "B" },
		{ "Camp Stonewash", 47.31, 25.52, "B" },
		{ "Shadebasin Watch", 44.01, 33.61, "B" },
		{ "Torntusk Overlook", 33.90, 78.32, "B" },
		{ "Witherbark Bluffs", 38.89, 23.21, "B" },
	},
	[2444] = {
		{ "Master's Perch", 38.13, 79.92, "B" },
	},
	[2472] = {
		{ "Tazavesh", 34.75, 10.03, "B" },
	},
	[2509] = {
		{ "Amani Foothold", 44.42, 62.21, "B" },
	},
	[2512] = {
		{ "Tokka's Landing", 57.88, 45.70, "B" },
	},
	[2535] = {
		{ "Atal'Aman", 39.79, 40.79, "B" },
	},
	[2536] = {
		{ "Atal'Aman", 39.79, 40.79, "B" },
	},
	[2600] = {
		{ "Extraction Coast", 32.27, 46.01, "B" },
		{ "Nexus Port", 55.02, 46.99, "B" },
		{ "Sporeforge", 77.29, 42.92, "B" },
		{ "Umbral Base Camp", 46.69, 82.90, "B" },
	},
}

--- ⚠️ FACTION MATTERS NOW. While this table held 23 hand-picked 12.x stops they were
--- all neutral, so nobody had to ask. It now covers the whole game, and a good part of
--- Kalimdor and the Eastern Kingdoms is faction-locked: pointing an Alliance player at
--- Razor Hill is not a small inaccuracy, it is a flight they cannot take and a walk
--- they did not need.
---
--- Unknown faction is treated as usable. A missing letter means our data is thin, and
--- the cost of showing one extra stop is far below the cost of hiding the only one.
local function UsableByPlayer(fp)
	local fac = fp[4]
	if not fac or fac == "B" then
		return true
	end
	if not UnitFactionGroup then
		return true
	end
	local ok, mine = pcall(UnitFactionGroup, "player")
	if not ok or type(mine) ~= "string" then
		return true
	end
	return (mine == "Alliance" and fac == "A") or (mine == "Horde" and fac == "H")
end

function ns.GetNearestFlightPoint(mapID, x, y)
	local list = ns.FLIGHT_POINTS[tonumber(mapID) or 0]
	if not list or #list == 0 then
		return nil
	end
	x, y = tonumber(x), tonumber(y)
	local best, bestDist
	for _, fp in ipairs(list) do
		if UsableByPlayer(fp) then
			if not (x and y) then
				return fp[1], fp[2], fp[3] -- no position: the first one we may use
			end
			local dx, dy = fp[2] - x, fp[3] - y
			local d = dx * dx + dy * dy
			if bestDist == nil or d < bestDist then
				best, bestDist = fp, d
			end
		end
	end
	if not best then
		return nil -- the zone has stops, but none this faction can use
	end
	return best[1], best[2], best[3]
end

--- Map coords -> world (yard) coords. Raw 0-100 map coords are NOT isotropic: a step
--- in x and a step in y cover different distances, and by different amounts per zone.
--- Comparing them squared therefore picks the nearer-looking stop rather than the
--- nearer one. Same helper shape as Achievements.lua's nearest-route.
local function MapPosToWorld(mapID, x100, y100)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, _, world = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(x100 / 100, y100 / 100))
	if ok and type(world) == "table" then
		local wx, wy
		if world.GetXY then
			wx, wy = world:GetXY()
		else
			wx, wy = world.x, world.y
		end
		if type(wx) == "number" and type(wy) == "number" then
			return wx, wy
		end
	end
	return nil
end

--- "Take me to the nearest flight point, wherever I am." (Rob, 21 Aug 2026.)
---
--- He asked for a pin in the city guide first, then said what he actually wanted:
--- not "where is the flight master in Silvermoon" but a button that works anywhere.
--- The pin only helps in the one city; this helps in every zone we have data for.
---
--- ⚠️ Deliberately NOT reusing GetNearestFlightPoint's own comparison. That one
--- compares raw map coordinates, which several callers rely on and which is fine for
--- their purposes — but for "which of these two is nearer to me" it is the wrong
--- measure, because map units are not square. This does the comparison in yards when
--- the client can convert, and falls back to the shared lookup when it cannot.
---
--- Sets the game's own waypoint AND claims the arrow, the same pair `/mh goto` uses:
--- setting a waypoint alone gives Blizzard's pin and no MH arrow, because the arrow
--- keys off ownership rather than off a waypoint existing.
function ns.RouteToNearestFlightPoint()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not mapID then
		print(prefix .. " " .. ns:L("FP_NEAREST_NO_MAP"))
		return false
	end

	local px, py
	if C_Map.GetPlayerMapPosition then
		local okPos, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
		if okPos and type(pos) == "table" and pos.GetXY then
			local x01, y01 = pos:GetXY()
			-- An instance or a zone that hides coordinates returns 0,0. That is not
			-- a position, and treating it as one would silently pick the stop nearest
			-- the map's top-left corner.
			if x01 and y01 and (x01 ~= 0 or y01 ~= 0) then
				px, py = x01 * 100, y01 * 100
			end
		end
	end

	local name, x, y
	local list = ns.FLIGHT_POINTS[tonumber(mapID) or 0]
	-- NOT `wx, wy = px and py and MapPosToWorld(...)`: an `and` expression is adjusted
	-- to a single value, so the second return would silently be nil and every stop
	-- would fall through to the fallback. CLAUDE.md's linter has a rule for this trap;
	-- it did not fire on this shape.
	local wx, wy
	if px and py then
		wx, wy = MapPosToWorld(mapID, px, py)
	end
	if list and wx and wy then
		local bestD
		for _, fp in ipairs(list) do
			if UsableByPlayer(fp) then
				local fx, fy = MapPosToWorld(mapID, fp[2], fp[3])
				if fx and fy then
					local dx, dy = fx - wx, fy - wy
					local d = dx * dx + dy * dy
					if bestD == nil or d < bestD then
						bestD, name, x, y = d, fp[1], fp[2], fp[3]
					end
				end
			end
		end
	end
	if not name then
		name, x, y = ns.GetNearestFlightPoint(mapID, px, py)
	end
	if not name then
		-- Honest about which of the two it is: a zone we have no data for is a
		-- different problem from a zone whose stops your faction cannot use.
		print(prefix .. " " .. ns:L((list and #list > 0) and "FP_NEAREST_NONE_FACTION" or "FP_NEAREST_NONE"))
		return false
	end

	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(mapID, x, y)) then
		print(prefix .. " " .. ns:L("FP_NEAREST_NO_WAYPOINT"))
		return false
	end
	ns.lastTarget = { mapID = mapID, x = x, y = y, name = name }
	ns._mhRouteOwner = "waypoint"
	print(("%s %s"):format(prefix, ns:L("FP_NEAREST_SET_FMT"):format(name)))
	return true, name
end
