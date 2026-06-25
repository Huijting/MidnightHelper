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
	-- TODO (next slices): Harandar / Zul'Aman / Voidstorm treasures, Midnight
	-- Lore Hunter (LoreObject nodes), Midnight: The Highest Peaks (Telescope nodes).
}
