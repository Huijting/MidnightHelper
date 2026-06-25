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
			{ criteria = 110257, mapID = 2413, x = 40.64, y = 28.02, name = "Peculiar Cauldron", quest = 93587,
				note = "Needs 150x Crystalized Resin Fragment: loot Flame-Hardened Sap of Teldrassil along the river (~39.7,20.9 down to 49.9,51.2), then open the cauldron." },
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
	-- TODO (next slices): Zul'Aman / Voidstorm treasures, Midnight Lore Hunter
	-- (LoreObject nodes), Midnight: The Highest Peaks (Telescope nodes).
}
