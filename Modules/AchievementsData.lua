--[[
	Midnight Helper — Achievements data (treasures, lore, telescopes …).

	Per achievement we store the location nodes so we can ROUTE to the ones you
	still miss (reusing the shared AddSmartTomTomWay engine, like rares and
	profession treasures). Live completion is read from the achievement criteria
	API at runtime — we never guess what's done.

	Coordinates / quest- / achievement- / criteria-IDs are FACTS, cross-referenced
	from community data (HandyNotes_Midnight, Zygor) and to be confirmed in-game
	(never-lie). Each node: { criteria, mapID, x, y, name, quest }.

	First slice: "Treasures of Eversong Woods" (achievement 61960, 9 treasures)
	as the proof. Add more zones / achievements to ACHIEVEMENT_TREASURES below.
]]

local _, ns = ...

ns.ACHIEVEMENT_TREASURES = {
	{
		achievementID = 61960, -- Treasures of Eversong Woods
		nameKey = "ACH_TREASURE_EVERSONG", -- localized title (falls back to API name)
		faction = 2710, -- Silvermoon Court (renown), verified via GetMajorFactionIDs dump
		-- Completion reward: Sootpaw battle pet (speciesID 5012, confirmed in-game via
		-- C_PetJournal.FindPetIDByName). Collected-check uses GetNumCollectedInfo.
		reward = { kind = "pet", speciesID = 5012, name = "Sootpaw" },
		nodes = {
			{ criteria = 111471, mapID = 2393, x = 24.38, y = 69.58, name = "Rookery Cache", quest = 93967,
				note = "On the floating Sunwing Rookery platform (Falconwing Square): buy Tasty Meat from Farstrider Aerieminder (by the balcony), then drop it next to the Mischievous Chick opposite the chest to get the key. Reward: Sunwing Hatchling pet." },
			{ criteria = 111472, mapID = 2395, x = 38.89, y = 76.06, name = "Triple-Locked Safebox", quest = 93456,
				note = "Needs 3 hidden Safebox Keys — grab the purple torch next to the chest to reveal them, then pick up the keys nearby.",
				prereqs = {
					{ name = "Battered Safebox Key", mapID = 2395, x = 37.63, y = 74.80 },
					{ name = "Worn Safebox Key", mapID = 2395, x = 38.46, y = 73.46 },
					{ name = "Tarnished Safebox Key", mapID = 2395, x = 40.24, y = 75.82 },
				} },
			{ criteria = 111473, mapID = 2395, x = 40.96, y = 19.45, name = "Gift of the Phoenix", quest = 93544,
				note = "Use Gift of the Phoenix, then collect 5 embers from the reborn phoenixes." },
			{ criteria = 111474, mapID = 2395, x = 43.27, y = 69.49, name = "Forgotten Ink and Quill", quest = 94747 },
			{ criteria = 111475, mapID = 2395, x = 44.61, y = 45.54, name = "Gilded Armillary Sphere", quest = 93908 },
			{ criteria = 111476, mapID = 2395, x = 52.34, y = 45.43, name = "Antique Nobleman's Signet Ring", quest = 93455 },
			{ criteria = 111477, mapID = 2395, x = 60.68, y = 67.29, name = "Farstrider's Lost Quiver", quest = 93457 },
			{ criteria = 111478, mapID = 2395, x = 40.47, y = 60.88, name = "Stone Vat of Wine", quest = 86645,
				note = "On an elevated platform: pick 10x Bunch of Ripe Grapes nearby and add them to the Vat, then buy a Packet of Instant Yeast from Sheri and add that too.",
				prereqs = {
					{ name = "Sheri (Instant Yeast)", mapID = 2395, x = 40.83, y = 60.48 },
				} },
			{ criteria = 111479, mapID = 2395, x = 48.73, y = 75.44, name = "Burbling Paint Pot", quest = 91358 },
		},
	},
	{
		achievementID = 61263, -- Treasures of Harandar
		nameKey = "ACH_TREASURE_HARANDAR",
		faction = 2704, -- Hara'ti (renown)
		-- Completion reward: Vivacious Chloroceros mount (item 263579, Wowhead-confirmed).
		reward = { kind = "mount", itemID = 263579, name = "Vivacious Chloroceros" },
		nodes = {
			{ criteria = 109033, mapID = 2413, x = 71.68, y = 31.00, name = "Failed Shroom Jumper's Satchel", quest = 92424 },
			{ criteria = 109034, mapID = 2413, x = 47.06, y = 50.25, name = "Burning Branch of the World Tree", quest = 92426 },
			{ criteria = 109035, mapID = 2413, x = 73.65, y = 65.35, name = "Sporelord's Fight Prize", quest = 92427 },
			{ criteria = 109036, mapID = 2413, x = 62.90, y = 51.24, name = "Reliquary's Lost Paintbrush", quest = 92431 },
			{ criteria = 109037, mapID = 2413, x = 55.69, y = 39.43, name = "Kemet's Simmering Cauldron", quest = 92436 },
			{ criteria = 110255, mapID = 2413, x = 26.73, y = 67.59, name = "Impenetrably Sealed Gourd", quest = 93508,
				note = "In a small cave (entrance ~27.5, 68.0). Loot Mysterious Red Fluid from the Dangling Jug and Mysterious Purple Fluid from the Hanging Flask, add both to the Durable Vase to make Fizzing Fluid, then open the gourd." },
			{ criteria = 110256, mapID = 2413, x = 46.65, y = 67.78, name = "Sporespawned Cache", quest = 93650,
				note = "Interact with the red Fungal Mallet in Fungara Village for a buff, then use it to ring the Mycelium Gong. The treasure appears next to the gong.",
				prereqs = {
					{ name = "Fungal Mallet", mapID = 2413, x = 41.30, y = 67.90 },
				} },
			{ criteria = 110257, mapID = 2413, x = 40.65, y = 28.04, name = "Peculiar Cauldron", quest = 93587,
				counterItem = 260531, counterNeed = 150, counterName = "Crystalized Resin Fragment",
				note = "Nai'theren Grotto (under a bridge just E of Har'mara). Open it with 150x Crystalized Resin Fragment, looted from Flame-Hardened Sap of Teldrassil. The saps are scattered in and along the whole river that runs through this area (from Nai'theren Grotto down past the Shrine of Ages and Vale of Secrets to the Den) - they are NOT on the minimap and respawn, so sweep the river (2-7 fragments each). The fragments are Warbound, so you can farm on any character and pool them via the Warband Bank. Tip: an Inky Black Potion darkens the world so the purple saps stand out. Bug: the saps vanish at exactly 149 fragments - delete 1 to make them reappear." },
			-- Wowhead-confirmed: the chest spawns in the middle of the Den on the
			-- main Harandar map (2413) at 51.21/52.93 after all 3 altar rituals.
			{ criteria = 110254, mapID = 2413, x = 51.21, y = 52.93, name = "Gift of the Cycle", quest = 93144,
				note = "Spawns in the middle of the Den (fly down to 51.21, 52.93) after all 3 altar rituals. For each: pick up the nearby item, sacrifice it at the altar, then SPEAK to the spirit that appears and pick 'offer item'. Wisdom: Rolled-Up Pillow (51.39, 56.0) -> altar 51.15, 58.56. Vigor: Lost Hunting Knife (45.14, 54.12) -> altar 47.18, 53.14. Innocence: Tattered Ball (51.10, 50.49) -> altar 51.15, 47.55.",
				prereqs = {
					{ name = "1. Pick up: A Rolled-Up Pillow", mapID = 2413, x = 51.39, y = 56.00 },
					{ name = "2. Altar of Wisdom", mapID = 2413, x = 51.15, y = 58.56 },
					{ name = "3. Pick up: A Lost Hunting Knife", mapID = 2413, x = 45.14, y = 54.12 },
					{ name = "4. Altar of Vigor", mapID = 2413, x = 47.18, y = 53.14 },
					{ name = "5. Pick up: A Tattered Ball", mapID = 2413, x = 51.10, y = 50.49 },
					{ name = "6. Altar of Innocence", mapID = 2413, x = 51.15, y = 47.55 },
				} },
		},
	},
	{
		achievementID = 62125, -- Treasures of Zul'Aman
		nameKey = "ACH_TREASURE_ZULAMAN",
		faction = 2696, -- Amani Tribe (renown)
		-- Completion reward: Pango Plating toy (item 268717, Wowhead-confirmed).
		reward = { kind = "toy", itemID = 268717, name = "Pango Plating" },
		nodes = {
			{ criteria = 111855, mapID = 2437, x = 46.83, y = 81.86, name = "Honored Warrior's Cache", quest = 90793,
				note = "Fill the cache by looting the 4 Honored Warrior's Urns around Zul'Aman; each spawns a Chosen miniboss that drops the token, then return to the cache.",
				prereqs = {
					{ name = "Urn: Akil'zon (up the mountainside to the Temple)", mapID = 2437, x = 51.57, y = 84.91, item = 259221 },
					{ name = "Urn: Nalorakk (just below the Den entrance)", mapID = 2437, x = 32.69, y = 83.49, item = 259219 },
					{ name = "Urn: Jan'alai (just S of the Temple walls)", mapID = 2437, x = 54.77, y = 22.40, item = 259220 },
					{ name = "Urn: Halazzi (SE of the Temple)", mapID = 2437, x = 34.54, y = 33.48, item = 259223 },
				} },
			{ criteria = 111856, mapID = 2437, x = 21.89, y = 77.38, name = "Sealed Twilight Blade Bounty", quest = 93871,
				note = "Destroy the 4 Sealing Orbs around the chest to unseal it.",
				prereqs = {
					{ name = "Sealing Orb 1", mapID = 2437, x = 24.02, y = 75.66, quest = 93918 },
					{ name = "Sealing Orb 2", mapID = 2437, x = 26.09, y = 74.01, quest = 93919 },
					{ name = "Sealing Orb 3", mapID = 2437, x = 26.09, y = 80.74, quest = 93916 },
					{ name = "Sealing Orb 4", mapID = 2437, x = 23.95, y = 78.95, quest = 93917 },
				} },
			{ criteria = 111857, mapID = 2437, x = 20.84, y = 66.54, name = "Bait and Tackle", quest = 90795,
				note = "In the back of a small cave (entrance ~21.1, 67.1)." },
			{ criteria = 111858, mapID = 2437, x = 41.99, y = 47.79, name = "Burrow Bounty", quest = 90796,
				note = "In a small cave." },
			{ criteria = 111859, mapID = 2437, x = 52.32, y = 65.99, name = "Mrruk's Mangy Trove", quest = 90797,
				note = "Guarded by the miniboss Mrruk the Musclefin - defeat it first, then loot the trove." },
			{ criteria = 111860, mapID = 2437, x = 40.48, y = 35.95, name = "Secret Formula", quest = 90798 },
			{ criteria = 111861, mapID = 2437, x = 42.64, y = 52.43, name = "Abandoned Nest", quest = 90799 },
		},
	},
	{
		achievementID = 62126, -- Treasures of Voidstorm
		nameKey = "ACH_TREASURE_VOIDSTORM",
		faction = 2699, -- The Singularity (renown)
		-- Completion reward: Interdimensional Parcel Signal toy (item 264695, Wowhead-confirmed).
		reward = { kind = "toy", itemID = 264695, name = "Interdimensional Parcel Signal" },
		-- Verified in-game (criteria dump): the achievement has exactly 13 criteria,
		-- 111863-111864 then 111866-111876. There is no 111865; the list is complete.
		nodes = {
			{ criteria = 111863, mapID = 2405, x = 49.94, y = 79.36, name = "Final Clutch of Predaxas", quest = 93237,
				note = "In a small cave (entrance ~48.96, 78.33). Inside you get the Disruptive Ozone debuff (no spells/abilities) - cross the electrified egg clutch without touching the glowing ground circles to reach the chest." },
			{ criteria = 111864, mapID = 2405, x = 25.76, y = 67.28, name = "Void-Shielded Tomb", quest = 92414,
				note = "Requires level 90. Drink the Potion of Dissociation on the nearby table, then run to the opposite building, grab the Key of Fused Darkness and unlock the chest.",
				prereqs = {
					{ name = "Potion of Dissociation", mapID = 2405, x = 25.74, y = 67.49 },
					{ name = "Key of Fused Darkness", mapID = 2405, x = 25.97, y = 68.67 },
				} },
			{ criteria = 111866, mapID = 2405, x = 64.53, y = 75.47, name = "Bloody Sack", quest = 93431,
				note = "Collect Dripping Meat from nearby bone piles to feed the Forgotten Oubliette." },
			{ criteria = 111867, mapID = 2405, x = 53.36, y = 42.66, name = "Malignant Chest", quest = 93840,
				orderedPrereqs = true, -- only one node is active at a time; route them in sequence
				note = "Enter the cave at 53.21, 44.19. Only one Malignant Node is active at a time - activate them in turn (1 -> 2 -> 3 -> 4) until the chest appears.",
				prereqs = {
					{ name = "Cave entrance", mapID = 2405, x = 53.21, y = 44.19 },
					{ name = "Malignant Node 1", mapID = 2405, x = 53.48, y = 43.23, quest = 93812 },
					{ name = "Malignant Node 2", mapID = 2405, x = 52.92, y = 43.32, quest = 93813 },
					{ name = "Malignant Node 3", mapID = 2405, x = 53.53, y = 43.91, quest = 93814 },
					{ name = "Malignant Node 4", mapID = 2405, x = 53.23, y = 42.68, quest = 93815 },
				} },
			{ criteria = 111868, mapID = 2444, x = 53.18, y = 32.21, name = "Stellar Stash", quest = 93996,
				note = "In Slayer's Rise: click the cave door at 52.21, 31.16 to open it, then head in keeping right to ~53.18, 32.21 and click/pull it 3 times to make the stash appear.",
				prereqs = {
					{ name = "Cave door (click to open)", mapID = 2444, x = 52.21, y = 31.16 },
				} },
			{ criteria = 111869, mapID = 2405, x = 47.93, y = 78.51, name = "Forgotten Researcher's Cache", quest = 94454,
				note = "Inside a cave (Lair of Predaxas, enter near 47.93, 78.51). A Low Gravity debuff lets you jump high - descend the cave avoiding the ground effects, then jump up the rocks to the platform to reach it." },
			{ criteria = 111870, mapID = 2444, x = 49.05, y = 20.12, name = "Scout's Pack", quest = 94387,
				note = "In the Slayer's Rise sub-area." },
			{ criteria = 111871, mapID = 2405, x = 55.37, y = 75.42, name = "Embedded Spear", quest = 93553 },
			{ criteria = 111872, mapID = 2405, x = 31.50, y = 44.51, name = "Quivering Egg", quest = 93500 },
			{ criteria = 111873, mapID = 2405, x = 28.33, y = 72.90, name = "Exaliburn", quest = 93498,
				note = "Drink the nearby Potion of Unquestionable Strength, then pull out the Exaliburn." },
			{ criteria = 111874, mapID = 2405, x = 35.77, y = 41.41, name = "Discarded Energy Pike", quest = 93496 },
			{ criteria = 111875, mapID = 2405, x = 43.01, y = 81.94, name = "Faindel's Quiver", quest = 93493 },
			{ criteria = 111876, mapID = 2405, x = 37.69, y = 69.76, name = "Half-Digested Viscera", quest = 93467,
				note = "In a small cave (entrance ~38.06, 68.77) - walk around it and head up to the left once inside." },
		},
	},

	-- The Highest Peaks: 5 telescopes per zone (grey flag markers on the minimap,
	-- up on the peaks). Each interact plays a short cutscene and grants ~100 renown
	-- with the zone's faction. Per-zone achievements, like the treasures.
	-- Verified in-game (criteria dump): each peaks achievement exposes a SINGLE
	-- aggregate criterion (criteriaID 0), NOT 5 per-telescope ones — so we detect
	-- each telescope via its own quest (NodeDone falls back to the quest flag).
	{
		achievementID = 62288, -- Eversong Woods: The Highest Peaks
		nameKey = "ACH_PEAKS_EVERSONG",
		faction = 2710, -- Silvermoon Court (renown)
		nodes = {
			{ mapID = 2393, x = 20.22, y = 79.61, name = "Telescope 1", quest = 94536 },
			{ mapID = 2395, x = 40.41, y = 10.10, name = "Telescope 2", quest = 94537 },
			{ mapID = 2395, x = 37.41, y = 47.89, name = "Telescope 3", quest = 94538 },
			{ mapID = 2395, x = 54.58, y = 51.01, name = "Telescope 4", quest = 94539 },
			{ mapID = 2395, x = 50.19, y = 85.43, name = "Telescope 5", quest = 94540 },
		},
	},
	{
		achievementID = 62289, -- Zul'Aman: The Highest Peaks
		nameKey = "ACH_PEAKS_ZULAMAN",
		faction = 2696, -- Amani Tribe (renown)
		nodes = {
			{ mapID = 2437, x = 27.79, y = 70.01, name = "Telescope 1", quest = 94541 },
			{ mapID = 2437, x = 53.01, y = 82.02, name = "Telescope 2", quest = 94542 },
			{ mapID = 2437, x = 57.69, y = 21.23, name = "Telescope 3", quest = 94543 },
			{ mapID = 2437, x = 24.63, y = 58.30, name = "Telescope 4", quest = 94544 },
			{ mapID = 2437, x = 41.85, y = 41.63, name = "Telescope 5", quest = 94545 },
		},
	},
	{
		achievementID = 62290, -- Harandar: The Highest Peaks
		nameKey = "ACH_PEAKS_HARANDAR",
		faction = 2704, -- Hara'ti (renown)
		nodes = {
			{ mapID = 2413, x = 69.17, y = 46.38, name = "Telescope 1", quest = 94546 },
			{ mapID = 2413, x = 68.16, y = 25.97, name = "Telescope 2", quest = 94547 },
			{ mapID = 2413, x = 49.40, y = 75.92, name = "Telescope 3", quest = 94548 },
			{ mapID = 2413, x = 69.40, y = 63.39, name = "Telescope 4", quest = 94549 },
			{ mapID = 2413, x = 53.49, y = 58.55, name = "Telescope 5", quest = 94550 },
		},
	},
	{
		achievementID = 62291, -- Voidstorm: The Highest Peaks
		nameKey = "ACH_PEAKS_VOIDSTORM",
		faction = 2699, -- The Singularity (renown)
		nodes = {
			{ mapID = 2405, x = 39.68, y = 61.16, name = "Telescope 1", quest = 94551 },
			{ mapID = 2405, x = 36.50, y = 44.30, name = "Telescope 2", quest = 94552 },
			{ mapID = 2405, x = 55.46, y = 67.17, name = "Telescope 3", quest = 94553 },
			{ mapID = 2405, x = 41.76, y = 70.22, name = "Telescope 4", quest = 94554 },
			{ mapID = 2405, x = 37.81, y = 54.97, name = "Telescope 5", quest = 94555 },
		},
	},
	-- Midnight Lore Hunter: one account-wide achievement; lore objects scattered
	-- across all four zones (read each for ~250 renown with that zone's faction).
	{
		achievementID = 62104, -- Midnight Lore Hunter
		nameKey = "ACH_LORE_HUNTER",
		factionMulti = true, -- lore objects span all four zone factions
		nodes = {
			-- Eversong Woods (+ Silvermoon City)
			{ criteria = 111828, mapID = 2395, x = 47.95, y = 88.20, name = "Memorial Plaque", quest = 91841 },
			{ criteria = 111829, mapID = 2395, x = 37.60, y = 13.78, name = "Shrine of Dath'remar", quest = 93563 },
			{ criteria = 111830, mapID = 2395, x = 50.52, y = 43.47, name = "Mirveda's Notes", quest = 93564 },
			{ criteria = 111831, mapID = 2395, x = 36.05, y = 72.51, name = "Profane Research", quest = 93565 },
			{ criteria = 111832, mapID = 2395, x = 57.81, y = 50.92, name = "Hawkstrider Husbandry: Unabridged Edition", quest = 93562 },
			{ criteria = 111833, mapID = 2393, x = 38.10, y = 76.99, name = "Unfinished Sheet Music", quest = 93570 },
			-- Zul'Aman
			{ criteria = 111772, mapID = 2437, x = 53.10, y = 82.11, name = "Tablet of Akil'zon", quest = 94627 },
			{ criteria = 111773, mapID = 2437, x = 32.08, y = 31.65, name = "Tablet of Halazzi", quest = 94628 },
			{ criteria = 111774, mapID = 2437, x = 55.13, y = 17.62, name = "Tablet of Jan'alai", quest = 94631 },
			{ criteria = 111775, mapID = 2437, x = 30.17, y = 84.66, name = "Tablet of Nalorakk", quest = 94632,
				note = "In a cave (entrance ~31.3, 84.0)." },
			{ criteria = 111777, mapID = 2437, x = 39.26, y = 44.72, name = "Tablet of Kulzi", quest = 94673 },
			{ criteria = 111778, mapID = 2437, x = 52.92, y = 32.12, name = "Tablet of Filo", quest = 94674 },
			-- Harandar
			{ criteria = 111823, mapID = 2413, x = 55.66, y = 54.02, name = "Tarnished Mural", quest = 93554 },
			{ criteria = 111824, mapID = 2413, x = 33.33, y = 60.84, name = "Ancient Runestone", quest = 93556 },
			{ criteria = 111825, mapID = 2413, x = 72.44, y = 38.09, name = "Derelict Mural", quest = 93557 },
			{ criteria = 111826, mapID = 2413, x = 68.21, y = 23.79, name = "Forgotten Mural", quest = 93558 },
			-- Voidstorm
			{ criteria = 111834, mapID = 2405, x = 63.42, y = 78.22, name = "Void Armor", quest = 94389 },
			{ criteria = 111835, mapID = 2405, x = 50.32, y = 87.68, name = "Ancient Tablet", quest = 94394 },
			{ criteria = 111836, mapID = 2405, x = 40.48, y = 58.63, name = "Abandoned Telescope", quest = 94395 },
			{ criteria = 111837, mapID = 2405, x = 60.38, y = 45.50, name = "Tainted Page", quest = 94397 },
			{ criteria = 111838, mapID = 2405, x = 27.83, y = 54.02, name = "Shadowgraft Harness", quest = 94398 },
		},
	},

	-- Rare hunters: kill every rare in the zone for its rare-meta achievement. Each
	-- node = a rare (npcID/coords/criteria/quest cross-referenced from
	-- HandyNotes_Midnight, our facts source; verify criteria counts in-game). These
	-- feed the zone meta-achievements toward "Light Up the Night". Card titles come
	-- live from the achievement API (localized), so no nameKey needed.
	{
		achievementID = 61507, -- A Bloody Song (Eversong Woods rares)
		faction = 2710, -- Silvermoon Court
		nodes = {
			{ criteria = 110166, mapID = 2395, x = 51.92, y = 73.80, name = "Warden of Weeds", quest = 91280 },
			{ criteria = 110167, mapID = 2395, x = 45.05, y = 78.25, name = "Harried Hawkstrider", quest = 91315 },
			{ criteria = 110168, mapID = 2395, x = 54.70, y = 60.18, name = "Overfester Hydra", quest = 92392 },
			{ criteria = 110169, mapID = 2395, x = 37.70, y = 64.20, name = "Bloated Snapdragon", quest = 92366 },
			{ criteria = 110170, mapID = 2395, x = 62.74, y = 49.07, name = "Cre'van", quest = 92391 },
			{ criteria = 110171, mapID = 2395, x = 36.38, y = 36.37, name = "Coralfang", quest = 92389 },
			{ criteria = 110172, mapID = 2395, x = 36.65, y = 77.18, name = "Lady Liminus", quest = 92393 },
			{ criteria = 110173, mapID = 2395, x = 40.19, y = 85.39, name = "Terrinor", quest = 92409 },
			{ criteria = 110174, mapID = 2395, x = 49.05, y = 87.75, name = "Bad Zed", quest = 92404 },
			{ criteria = 110175, mapID = 2395, x = 34.81, y = 20.98, name = "Waverly", quest = 92395 },
			{ criteria = 110176, mapID = 2395, x = 56.42, y = 77.60, name = "Banuran", quest = 92403 },
			{ criteria = 110177, mapID = 2395, x = 59.20, y = 79.20, name = "Lost Guardian", quest = 92399 },
			{ criteria = 110178, mapID = 2395, x = 42.31, y = 68.91, name = "Duskburn", quest = 93550 },
			{ criteria = 110179, mapID = 2395, x = 51.68, y = 45.99, name = "Malfunctioning Construct", quest = 93555 },
			{ criteria = 110180, mapID = 2395, x = 44.99, y = 38.55, name = "Dame Bloodshed", quest = 93561 },
		},
	},
	{
		achievementID = 62122, -- Tallest Tree in the Forest (Zul'Aman rares)
		faction = 2696, -- Amani Tribe
		nodes = {
			{ criteria = 111839, mapID = 2437, x = 34.41, y = 33.05, name = "Necrohexxer Raz'ka", quest = 89569 },
			{ criteria = 111840, mapID = 2437, x = 51.80, y = 18.62, name = "The Snapping Scourge", quest = 89570 },
			{ criteria = 111841, mapID = 2437, x = 51.85, y = 72.91, name = "Skullcrusher Harak", quest = 89571 },
			{ criteria = 111842, mapID = 2437, x = 28.95, y = 24.44, name = "Lightwood Borer", quest = 89575 },
			{ criteria = 111843, mapID = 2437, x = 50.87, y = 65.14, name = "Mrrlokk", quest = 91174 },
			{ criteria = 111844, mapID = 2437, x = 38.99, y = 49.97, name = "Poacher Rav'ik", quest = 91634 },
			{ criteria = 111845, mapID = 2437, x = 30.48, y = 44.56, name = "Spinefrill", quest = 89578 },
			{ criteria = 111846, mapID = 2437, x = 46.29, y = 51.13, name = "Oophaga", quest = 89579 },
			{ criteria = 111847, mapID = 2437, x = 47.77, y = 34.22, name = "Tiny Vermin", quest = 89580 },
			{ criteria = 111848, mapID = 2437, x = 21.30, y = 70.55, name = "Voidtouched Crustacean", quest = 89581 },
			{ criteria = 111849, mapID = 2437, x = 39.59, y = 20.97, name = "The Devouring Invader", quest = 89583 },
			{ criteria = 111850, mapID = 2437, x = 33.71, y = 88.97, name = "Elder Oaktalon", quest = 89572 },
			{ criteria = 111851, mapID = 2437, x = 47.68, y = 20.56, name = "Depthborn Eelamental", quest = 89573 },
			{ criteria = 111852, mapID = 2437, x = 46.39, y = 43.39, name = "The Decaying Diamondback", quest = 91072 },
			{ criteria = 111853, mapID = 2437, x = 45.29, y = 41.70, name = "Asha the Empowered", quest = 91073 },
		},
	},
	{
		achievementID = 61264, -- Leaf None Behind (Harandar rares)
		faction = 2704, -- Hara'ti
		nodes = {
			{ criteria = 109039, mapID = 2413, x = 51.16, y = 45.35, name = "Rhazul", quest = 91832 },
			{ criteria = 109040, mapID = 2413, x = 68.71, y = 40.70, name = "Chironex", quest = 92137 },
			{ criteria = 109041, mapID = 2413, x = 69.17, y = 59.86, name = "Ha'kalawe", quest = 92142 },
			{ criteria = 109042, mapID = 2413, x = 72.63, y = 69.28, name = "Tallcap the Truthspreader", quest = 92148 },
			{ criteria = 109043, mapID = 2413, x = 59.93, y = 46.84, name = "Queen Lashtongue", quest = 92154 },
			{ criteria = 109044, mapID = 2413, x = 64.57, y = 47.94, name = "Chlorokyll", quest = 92161 },
			{ criteria = 109046, mapID = 2413, x = 56.38, y = 32.99, name = "Serrasa", quest = 92170 },
			{ criteria = 109047, mapID = 2413, x = 45.93, y = 31.34, name = "Mindrot", quest = 92172 },
			{ criteria = 109048, mapID = 2413, x = 40.65, y = 42.99, name = "Dracaena", quest = 92176 },
			{ criteria = 109049, mapID = 2413, x = 36.59, y = 75.16, name = "Treetop", quest = 92183 },
			{ criteria = 109051, mapID = 2413, x = 27.27, y = 70.32, name = "Pterrock", quest = 92191 },
			{ criteria = 109052, mapID = 2413, x = 39.69, y = 60.70, name = "Ahl'ua'huhi", quest = 92193 },
			{ criteria = 109045, mapID = 2413, x = 65.55, y = 32.69, name = "Stumpy", quest = 92168 },
			{ criteria = 109050, mapID = 2413, x = 28.11, y = 81.81, name = "Oro'ohna", quest = 92190 },
			{ criteria = 109053, mapID = 2413, x = 44.20, y = 16.58, name = "Annulus the Worldshaker", quest = 92194 },
		},
	},
	{
		achievementID = 62130, -- The Ultimate Predator (Voidstorm rares)
		faction = 2699, -- The Singularity
		nodes = {
			{ criteria = 111877, mapID = 2405, x = 29.51, y = 50.08, name = "Sundereth the Caller", quest = 90805 },
			{ criteria = 111878, mapID = 2405, x = 34.05, y = 81.98, name = "Territorial Voidscythe", quest = 91050 },
			{ criteria = 111879, mapID = 2405, x = 36.16, y = 83.55, name = "Tremora", quest = 91048 },
			{ criteria = 111880, mapID = 2405, x = 43.66, y = 51.54, name = "Screammaxa the Matriarch", quest = 93966 },
			{ criteria = 111881, mapID = 2405, x = 47.05, y = 80.63, name = "Bane of the Vilebloods", quest = 93946 },
			{ criteria = 111882, mapID = 2405, x = 39.23, y = 63.92, name = "Aeonelle Blackstar", quest = 93944 },
			{ criteria = 111883, mapID = 2405, x = 37.89, y = 71.77, name = "Lotus Darkblossom", quest = 93947 },
			{ criteria = 111884, mapID = 2405, x = 55.72, y = 79.45, name = "Queen o' War", quest = 93934 },
			{ criteria = 111886, mapID = 2444, x = 46.33, y = 40.94, name = "Rakshur the Bonegrinder", quest = 93953 },
			{ criteria = 111887, mapID = 2405, x = 35.49, y = 50.23, name = "Bilemaw the Gluttonous", quest = 93884 },
			{ criteria = 111888, mapID = 2444, x = 40.88, y = 88.99, name = "Eruundi", quest = 91047 },
			{ criteria = 111889, mapID = 2405, x = 40.17, y = 41.30, name = "Nightbrood", quest = 91051 },
			{ criteria = 111885, mapID = 2405, x = 48.81, y = 53.26, name = "Ravengerus", quest = 93895 },
			{ criteria = 111890, mapID = 2405, x = 53.94, y = 62.72, name = "Far'thana the Mad", quest = 93896 },
		},
	},
}

-- Elite rares (RareElite in HandyNotes_Midnight): tougher, may want a group or some
-- extra levels. Keyed by the rare-hunter achievement criterion so the checklist can
-- flag them. Everything else in the achievements is solo-friendly.
ns.ELITE_RARE_CRITERIA = {
	[111852] = true, [111853] = true,                  -- Zul'Aman
	[109045] = true, [109050] = true, [109053] = true, -- Harandar
	[111885] = true, [111890] = true,                  -- Voidstorm
}
