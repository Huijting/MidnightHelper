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
		-- Note: HandyNotes has no node for criterion 111865 yet, so we route the 13
		-- treasures we can place; the achievement may list one more.
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
	{
		achievementID = 62288, -- Eversong Woods: The Highest Peaks
		nameKey = "ACH_PEAKS_EVERSONG",
		nodes = {
			{ criteria = 111573, mapID = 2393, x = 20.22, y = 79.61, name = "Telescope 1", quest = 94536 },
			{ criteria = 111574, mapID = 2395, x = 40.41, y = 10.10, name = "Telescope 2", quest = 94537 },
			{ criteria = 111575, mapID = 2395, x = 37.41, y = 47.89, name = "Telescope 3", quest = 94538 },
			{ criteria = 111576, mapID = 2395, x = 54.58, y = 51.01, name = "Telescope 4", quest = 94539 },
			{ criteria = 111577, mapID = 2395, x = 50.19, y = 85.43, name = "Telescope 5", quest = 94540 },
		},
	},
	{
		achievementID = 62289, -- Zul'Aman: The Highest Peaks
		nameKey = "ACH_PEAKS_ZULAMAN",
		nodes = {
			{ criteria = 111578, mapID = 2437, x = 27.79, y = 70.01, name = "Telescope 1", quest = 94541 },
			{ criteria = 111579, mapID = 2437, x = 53.01, y = 82.02, name = "Telescope 2", quest = 94542 },
			{ criteria = 111580, mapID = 2437, x = 57.69, y = 21.23, name = "Telescope 3", quest = 94543 },
			{ criteria = 111581, mapID = 2437, x = 24.63, y = 58.30, name = "Telescope 4", quest = 94544 },
			{ criteria = 111582, mapID = 2437, x = 41.85, y = 41.63, name = "Telescope 5", quest = 94545 },
		},
	},
	{
		achievementID = 62290, -- Harandar: The Highest Peaks
		nameKey = "ACH_PEAKS_HARANDAR",
		nodes = {
			{ criteria = 111583, mapID = 2413, x = 69.17, y = 46.38, name = "Telescope 1", quest = 94546 },
			{ criteria = 111584, mapID = 2413, x = 68.16, y = 25.97, name = "Telescope 2", quest = 94547 },
			{ criteria = 111585, mapID = 2413, x = 49.40, y = 75.92, name = "Telescope 3", quest = 94548 },
			{ criteria = 111586, mapID = 2413, x = 69.40, y = 63.39, name = "Telescope 4", quest = 94549 },
			{ criteria = 111587, mapID = 2413, x = 53.49, y = 58.55, name = "Telescope 5", quest = 94550 },
		},
	},
	{
		achievementID = 62291, -- Voidstorm: The Highest Peaks
		nameKey = "ACH_PEAKS_VOIDSTORM",
		nodes = {
			{ criteria = 111588, mapID = 2405, x = 39.68, y = 61.16, name = "Telescope 1", quest = 94551 },
			{ criteria = 111589, mapID = 2405, x = 36.50, y = 44.30, name = "Telescope 2", quest = 94552 },
			{ criteria = 111590, mapID = 2405, x = 55.46, y = 67.17, name = "Telescope 3", quest = 94553 },
			{ criteria = 111591, mapID = 2405, x = 41.76, y = 70.22, name = "Telescope 4", quest = 94554 },
			{ criteria = 111592, mapID = 2405, x = 37.81, y = 54.97, name = "Telescope 5", quest = 94555 },
		},
	},
	-- TODO (next slice): Midnight Lore Hunter (LoreObject nodes across all zones).
}
