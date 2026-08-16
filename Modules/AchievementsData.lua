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
	-- ⚠️ TOEGEVOEGD 15 aug 2026. Rob, met een screenshot van deze tab: het eiland
	-- moet dezelfde behandeling krijgen als de oude zones. Terecht — Eversong,
	-- Harandar, Zul'Aman en Voidstorm hadden allemaal een Treasures-hunt en de
	-- Coiled Isle had alleen The Honored Dead.
	--
	-- Twee onafhankelijke bronnen noemen dit achievement 63359: onze watcher (13 aug,
	-- derdepartij) en HandyNotes_Midnight, die er 22 criteria bij levert. Dat is de
	-- sterkste soort kandidaat die we buiten de client hebben.
	--
	-- ⚠️ GEEN `quest`-velden, en dat is opzet. HandyNotes heeft ze wel, maar hun
	-- Coiled Isle-questband bleek op 13 aug niet de vlag die het spel afvuurt. Hun
	-- coördinaten zijn vertrouwd (Robs staande regel), hun criteria hebben een goed
	-- track record (de twaalf van The Honored Dead waren op 14 aug allemaal juist).
	-- Dus: criteria en coördinaten wel, quest-ids niet. Zonder quest-veld valt
	-- NodeDone terug op het criterium, en dat is toch al de gezaghebbende bron.
	--
	-- ⚠️ GEEN `name`-velden. HandyNotes bewaart deze labels als sjablonen
	-- ("{npc:263242}") die alleen binnen hun eigen renderer iets betekenen; veertien
	-- van de tweeëntwintig zouden als letterlijke accolades op het scherm komen.
	-- ns.AchievementNodeName haalt de naam nu uit de client — al vertaald en per
	-- definitie in overeenstemming met het spel.
	--
	-- Volgorde is een looproute van noord naar zuid, zodat de pijl niet kriskras stuurt.
	-- Nog te verifiëren: `/mh ach id 63359` op Robs client bevestigt of de 22 criteria
	-- kloppen. Staan ze fout, dan blijft de kaart stil op 0/22 staan — dat is precies
	-- de stille fout waar dit bestand vaker last van had.
	{
		achievementID = 63359, -- Treasures of the Coiled Isle
		nameKey = "ACH_TREASURE_COILEDISLE",
		nodes = {
			{ criteria = 115295, mapID = 2512, x = 31.43, y = 83.49 },
			{ criteria = 115314, mapID = 2512, x = 64.91, y = 78.89 },
			{ criteria = 115294, mapID = 2512, x = 70.63, y = 76.63, note = "ACH_NOTE_BRINE_CRUSTED" },
			{ criteria = 115306, mapID = 2512, x = 75.37, y = 68.33 },
			{ criteria = 115292, mapID = 2512, x = 43.64, y = 67.38, note = "ACH_NOTE_PROFANE_SPOILS" },
			{ criteria = 115302, mapID = 2512, x = 29.54, y = 67.23 },
			{ criteria = 115289, mapID = 2512, x = 71.88, y = 66.66, note = "ACH_NOTE_PRIVATEERS_CACHE" },
			{ criteria = 115313, mapID = 2512, x = 45.91, y = 66.28 },
			{ criteria = 115310, mapID = 2512, x = 68.05, y = 65.90, note = "ACH_NOTE_LOST_SPIRIT" },
			{ criteria = 115309, mapID = 2512, x = 60.43, y = 59.46 },
			{ criteria = 115308, mapID = 2512, x = 73.44, y = 56.61 },
			{ criteria = 115291, mapID = 2512, x = 67.26, y = 48.46, note = "ACH_NOTE_GRAVE_FORGOTTEN" },
			{ criteria = 115293, mapID = 2512, x = 58.19, y = 45.72, note = "ACH_NOTE_VULZAHN" },
			{ criteria = 115312, mapID = 2512, x = 58.14, y = 43.55 },
			{ criteria = 115300, mapID = 2512, x = 53.09, y = 43.10 },
			{ criteria = 115307, mapID = 2512, x = 55.21, y = 37.96 },
			{ criteria = 115298, mapID = 2512, x = 64.72, y = 36.65 },
			{ criteria = 115301, mapID = 2512, x = 49.48, y = 31.98 },
			{ criteria = 115296, mapID = 2512, x = 46.86, y = 29.57 },
			{ criteria = 115299, mapID = 2512, x = 66.91, y = 28.06 },
			{ criteria = 115297, mapID = 2512, x = 43.90, y = 26.54 },
			{ criteria = 115290, mapID = 2512, x = 65.44, y = 5.60, note = "ACH_NOTE_SUNKEN_DIVER" },
		},
	},
	-- ⚠️ TOEGEVOEGD 15 aug 2026, tweede ronde van "het eiland op niveau". De oude
	-- zones hebben elk vier soorten hunts; de Coiled Isle had er twee.
	--
	-- HandyNotes_Midnight kent ZEVEN achievements op dit eiland. Vier daarvan staan
	-- nu in dit bestand. De andere drie zijn met opzet NIET overgenomen, en dat is
	-- de bruikbaarste uitkomst van deze ronde:
	--
	--   62601 (Soft Underbelly) en 63601 (de drie Ancient Foes) hebben in HandyNotes
	--   coördinaten als 10.00/10.00, 10.00/20.00, 10.00/30.00. Dat zijn geen plekken,
	--   dat is hun manier om "onbekend" op te schrijven. Onze eigen VAULTS_DISCOVERIES
	--   kwam los daarvan tot dezelfde conclusie: de Ancient Foes worden vermoedelijk
	--   ge-event-spawnd en hebben geen vaste locatie. Zulke nodes overnemen levert een
	--   pijl richting de zee op, en een pijl die ergens heen wijst wordt geloofd.
	--
	--   62601 heeft daarbij één criterium (113661) TWEE keer, op 38.40 en 38.41 —
	--   nog een teken dat dat blok bij hen ook nog niet af is.
	--
	-- Wat wél is overgenomen: 11 skyriding-glyphs en 10 lore-objecten, allemaal met
	-- echte coördinaten en oplopende criteria-ids. Geen `name`- en geen `quest`-velden,
	-- om dezelfde reden als bij de treasures hierboven: de client levert de naam al
	-- vertaald, en HandyNotes' questband bleek op 13 aug niet de vlag die het spel
	-- afvuurt. Volgorde noord → zuid, zodat de route niet kriskras stuurt.
	{
		achievementID = 63395, -- glyph hunt, Coiled Isle (client supplies the title)
		nameKey = "ACH_GLYPHS_COILEDISLE",
		nodes = {
			{ criteria = 115775, mapID = 2512, x = 42.88, y = 30.59 },
			{ criteria = 115774, mapID = 2512, x = 52.01, y = 38.41 },
			{ criteria = 115776, mapID = 2512, x = 43.82, y = 44.19 },
			{ criteria = 115773, mapID = 2512, x = 70.28, y = 48.16 },
			{ criteria = 115771, mapID = 2512, x = 58.94, y = 48.91 },
			{ criteria = 115491, mapID = 2512, x = 37.41, y = 60.53 },
			{ criteria = 115772, mapID = 2512, x = 64.12, y = 60.65 },
			{ criteria = 115766, mapID = 2512, x = 26.63, y = 63.14 },
			{ criteria = 115770, mapID = 2512, x = 45.84, y = 64.93 },
			{ criteria = 115768, mapID = 2512, x = 28.82, y = 75.23 },
			{ criteria = 115769, mapID = 2512, x = 40.55, y = 90.49 },
		},
	},
	{
		achievementID = 63662, -- lore hunt, Coiled Isle (client supplies the title)
		nameKey = "ACH_LORE_COILEDISLE",
		nodes = {
			{ criteria = 116709, mapID = 2512, x = 34.10, y = 36.45 },
			{ criteria = 116710, mapID = 2512, x = 71.94, y = 44.92 },
			{ criteria = 116707, mapID = 2512, x = 45.77, y = 47.93 },
			{ criteria = 116711, mapID = 2512, x = 32.56, y = 63.66 },
			{ criteria = 116702, mapID = 2512, x = 42.43, y = 65.02 },
			{ criteria = 116704, mapID = 2512, x = 70.00, y = 65.97 },
			{ criteria = 116708, mapID = 2512, x = 25.02, y = 67.75 },
			{ criteria = 116705, mapID = 2512, x = 50.75, y = 68.20 },
			{ criteria = 116703, mapID = 2512, x = 57.35, y = 80.36 },
			{ criteria = 116706, mapID = 2512, x = 31.62, y = 83.74 },
		},
	},
	{
		achievementID = 61960, -- Treasures of Eversong Woods
		nameKey = "ACH_TREASURE_EVERSONG", -- localized title (falls back to API name)
		faction = 2710, -- Silvermoon Court (renown), verified via GetMajorFactionIDs dump
		-- Completion reward: Sootpaw battle pet (speciesID 5012, confirmed in-game via
		-- C_PetJournal.FindPetIDByName). Collected-check uses GetNumCollectedInfo.
		reward = { kind = "pet", speciesID = 5012, name = "Sootpaw" },
		nodes = {
			{ criteria = 111471, mapID = 2393, x = 24.38, y = 69.58, name = "Rookery Cache", quest = 93967,
				note = "ACH_NOTE_ROOKERY" },
			{ criteria = 111472, mapID = 2395, x = 38.89, y = 76.06, name = "Triple-Locked Safebox", quest = 93456,
				note = "ACH_NOTE_SAFEBOX",
				prereqs = {
					{ name = "Battered Safebox Key", mapID = 2395, x = 37.63, y = 74.80 },
					{ name = "Worn Safebox Key", mapID = 2395, x = 38.46, y = 73.46 },
					{ name = "Tarnished Safebox Key", mapID = 2395, x = 40.24, y = 75.82 },
				} },
			{ criteria = 111473, mapID = 2395, x = 40.96, y = 19.45, name = "Gift of the Phoenix", quest = 93544,
				note = "ACH_NOTE_PHOENIX" },
			{ criteria = 111474, mapID = 2395, x = 43.27, y = 69.49, name = "Forgotten Ink and Quill", quest = 94747 },
			{ criteria = 111475, mapID = 2395, x = 44.61, y = 45.54, name = "Gilded Armillary Sphere", quest = 93908 },
			{ criteria = 111476, mapID = 2395, x = 52.34, y = 45.43, name = "Antique Nobleman's Signet Ring", quest = 93455 },
			{ criteria = 111477, mapID = 2395, x = 60.68, y = 67.29, name = "Farstrider's Lost Quiver", quest = 93457 },
			{ criteria = 111478, mapID = 2395, x = 40.47, y = 60.88, name = "Stone Vat of Wine", quest = 86645,
				note = "ACH_NOTE_STONEVAT",
				prereqs = {
					{ name = "ACH_STEP_SHERI", mapID = 2395, x = 40.83, y = 60.48 },
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
				note = "ACH_NOTE_GOURD" },
			{ criteria = 110256, mapID = 2413, x = 46.65, y = 67.78, name = "Sporespawned Cache", quest = 93650,
				note = "ACH_NOTE_SPORECACHE",
				prereqs = {
					{ name = "Fungal Mallet", mapID = 2413, x = 41.30, y = 67.90 },
				} },
			{ criteria = 110257, mapID = 2413, x = 40.65, y = 28.04, name = "Peculiar Cauldron", quest = 93587,
				counterItem = 260531, counterNeed = 150, counterName = "Crystalized Resin Fragment",
				note = "ACH_NOTE_CAULDRON" },
			-- Wowhead-confirmed: the chest spawns in the middle of the Den on the
			-- main Harandar map (2413) at 51.21/52.93 after all 3 altar rituals.
			{ criteria = 110254, mapID = 2413, x = 51.21, y = 52.93, name = "Gift of the Cycle", quest = 93144,
				note = "ACH_NOTE_GIFTCYCLE",
				prereqs = {
					{ name = "ACH_STEP_PILLOW", mapID = 2413, x = 51.39, y = 56.00 },
					{ name = "ACH_STEP_ALTARWISDOM", mapID = 2413, x = 51.15, y = 58.56 },
					{ name = "ACH_STEP_KNIFE", mapID = 2413, x = 45.14, y = 54.12 },
					{ name = "ACH_STEP_ALTARVIGOR", mapID = 2413, x = 47.18, y = 53.14 },
					{ name = "ACH_STEP_BALL", mapID = 2413, x = 51.10, y = 50.49 },
					{ name = "ACH_STEP_ALTARINNOCENCE", mapID = 2413, x = 51.15, y = 47.55 },
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
				note = "ACH_NOTE_HONOREDURNS",
				prereqs = {
					{ name = "ACH_STEP_URN_AKILZON", mapID = 2437, x = 51.57, y = 84.91, item = 259221 },
					{ name = "ACH_STEP_URN_NALORAKK", mapID = 2437, x = 32.69, y = 83.49, item = 259219 },
					{ name = "ACH_STEP_URN_JANALAI", mapID = 2437, x = 54.77, y = 22.40, item = 259220 },
					{ name = "ACH_STEP_URN_HALAZZI", mapID = 2437, x = 34.54, y = 33.48, item = 259223 },
				} },
			{ criteria = 111856, mapID = 2437, x = 21.89, y = 77.38, name = "Sealed Twilight Blade Bounty", quest = 93871,
				note = "ACH_NOTE_SEALINGORBS",
				prereqs = {
					{ name = "Sealing Orb 1", mapID = 2437, x = 24.02, y = 75.66, quest = 93918 },
					{ name = "Sealing Orb 2", mapID = 2437, x = 26.09, y = 74.01, quest = 93919 },
					{ name = "Sealing Orb 3", mapID = 2437, x = 26.09, y = 80.74, quest = 93916 },
					{ name = "Sealing Orb 4", mapID = 2437, x = 23.95, y = 78.95, quest = 93917 },
				} },
			{ criteria = 111857, mapID = 2437, x = 20.84, y = 66.54, name = "Bait and Tackle", quest = 90795,
				note = "ACH_NOTE_BAITTACKLE" },
			{ criteria = 111858, mapID = 2437, x = 41.99, y = 47.79, name = "Burrow Bounty", quest = 90796,
				note = "ACH_NOTE_BURROW" },
			{ criteria = 111859, mapID = 2437, x = 52.32, y = 65.99, name = "Mrruk's Mangy Trove", quest = 90797,
				note = "ACH_NOTE_MRRUK" },
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
				note = "ACH_NOTE_PREDAXAS" },
			{ criteria = 111864, mapID = 2405, x = 25.76, y = 67.28, name = "Void-Shielded Tomb", quest = 92414,
				note = "ACH_NOTE_VOIDTOMB",
				prereqs = {
					{ name = "Potion of Dissociation", mapID = 2405, x = 25.74, y = 67.49 },
					{ name = "Key of Fused Darkness", mapID = 2405, x = 25.97, y = 68.67 },
				} },
			{ criteria = 111866, mapID = 2405, x = 64.53, y = 75.47, name = "Bloody Sack", quest = 93431,
				note = "ACH_NOTE_BLOODYSACK" },
			{ criteria = 111867, mapID = 2405, x = 53.36, y = 42.66, name = "Malignant Chest", quest = 93840,
				orderedPrereqs = true, -- only one node is active at a time; route them in sequence
				note = "ACH_NOTE_MALIGNANT",
				prereqs = {
					{ name = "ACH_STEP_CAVE_ENTRANCE", mapID = 2405, x = 53.21, y = 44.19 },
					{ name = "Malignant Node 1", mapID = 2405, x = 53.48, y = 43.23, quest = 93812 },
					{ name = "Malignant Node 2", mapID = 2405, x = 52.92, y = 43.32, quest = 93813 },
					{ name = "Malignant Node 3", mapID = 2405, x = 53.53, y = 43.91, quest = 93814 },
					{ name = "Malignant Node 4", mapID = 2405, x = 53.23, y = 42.68, quest = 93815 },
				} },
			{ criteria = 111868, mapID = 2444, x = 53.18, y = 32.21, name = "Stellar Stash", quest = 93996,
				note = "ACH_NOTE_STELLAR",
				prereqs = {
					{ name = "ACH_STEP_CAVE_DOOR", mapID = 2444, x = 52.21, y = 31.16 },
				} },
			{ criteria = 111869, mapID = 2405, x = 47.93, y = 78.51, name = "Forgotten Researcher's Cache", quest = 94454,
				note = "ACH_NOTE_RESEARCHER" },
			{ criteria = 111870, mapID = 2444, x = 49.05, y = 20.12, name = "Scout's Pack", quest = 94387,
				note = "ACH_NOTE_SCOUTPACK" },
			{ criteria = 111871, mapID = 2405, x = 55.37, y = 75.42, name = "Embedded Spear", quest = 93553 },
			{ criteria = 111872, mapID = 2405, x = 31.50, y = 44.51, name = "Quivering Egg", quest = 93500 },
			{ criteria = 111873, mapID = 2405, x = 28.33, y = 72.90, name = "Exaliburn", quest = 93498,
				note = "ACH_NOTE_EXALIBURN" },
			{ criteria = 111874, mapID = 2405, x = 35.77, y = 41.41, name = "Discarded Energy Pike", quest = 93496 },
			{ criteria = 111875, mapID = 2405, x = 43.01, y = 81.94, name = "Faindel's Quiver", quest = 93493 },
			{ criteria = 111876, mapID = 2405, x = 37.69, y = 69.76, name = "Half-Digested Viscera", quest = 93467,
				note = "ACH_NOTE_VISCERA" },
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
				note = "ACH_NOTE_NALORAKKTABLET" },
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
	-- Void Showdown rare-metas (Naigtal 2600 / Val 2599, rotating). Nodes cross-
	-- referenced from HandyNotes_Midnight (npcID/criteria/quest) + coords. These feed
	-- the Showdown zone metas (A Trip Through/Around the Stars), NOT Light Up the Night
	-- (feedsMeta = false). The 2 extra Naigtal rares (Warbringer Thal'kuur, Voidwarped
	-- Sporebat) aren't part of the meta and live only in the Rares tab. Coords need an
	-- in-game spot-check (they differ from earlier Wowhead-guide values).
	{
		achievementID = 62883, -- Showdown Slugger: Naigtal
		feedsMeta = false,
		nodes = {
			{ criteria = 114005, mapID = 2600, x = 37.60, y = 61.80, name = "Interminable Uarn", quest = 96205 },
			{ criteria = 114007, mapID = 2600, x = 77.70, y = 38.30, name = "Swalewing Matriarch", quest = 96207 },
			{ criteria = 114009, mapID = 2600, x = 28.00, y = 50.60, name = "Auredar's Chassis", quest = 96316 },
			{ criteria = 114011, mapID = 2600, x = 54.60, y = 42.30, name = "Indomitable Mk XII", quest = 96317 },
			{ criteria = 114006, mapID = 2600, x = 45.10, y = 55.40, name = "Broxion", quest = 96206 },
			{ criteria = 114008, mapID = 2600, x = 68.50, y = 62.20, name = "Lomelith", quest = 96208 },
			{ criteria = 114010, mapID = 2600, x = 70.30, y = 76.40, name = "Warp Agent Xi'grivr", quest = 96319 },
			{ criteria = 114012, mapID = 2600, x = 55.20, y = 62.00, name = "Slaipaan", quest = 96320 },
			-- ⚠️ TOEGEVOEGD 15 aug 2026. `/mh ach check` zag dat dit achievement tien
			-- criteria heeft en wij er acht hadden — een gat dat je in het spel niet ziet,
			-- want de kaart telde gewoon 8/8 en zweeg over de rest.
			--
			-- De naam hielp niet: de client geeft voor criteria 8, 9 én 10 de string
			-- "Slaipaan". Drie keer dezelfde naam voor drie verschillende criteria.
			-- Wat het wél oploste is `assetID` — bij criteriaType 0 (kill creature) is dat
			-- de NPC-id, en die twee komen exact overeen met twee rares die HandyNotes
			-- in Naigtal kent maar niet aan dit achievement had gekoppeld.
			--
			-- ⚠️ Deze twee `name`-velden zijn er met opzet, tegen de gewoonte in dit
			-- bestand in. Normaal wint de client, want die is vertaald en per definitie
			-- in overeenstemming met het spel. Hier is de client aantoonbaar kapot, en
			-- "Slaipaan" op drie regels zou de speler naar de verkeerde rare sturen.
			{ criteria = 116833, mapID = 2600, x = 29.70, y = 19.20, name = "Warbringer Thal'kuur", quest = 97014 },
			{ criteria = 116834, mapID = 2600, x = 48.80, y = 47.40, name = "Voidwarped Sporebat", quest = 96566 },
		},
	},
	{
		achievementID = 62881, -- Showdown Slugger: Val
		feedsMeta = false,
		nodes = {
			{ criteria = 113995, mapID = 2599, x = 66.80, y = 86.40, name = "Sleet-Rune", quest = 95939 },
			{ criteria = 113997, mapID = 2599, x = 67.20, y = 41.80, name = "Glacial Broodmother", quest = 95559 },
			{ criteria = 113999, mapID = 2599, x = 28.50, y = 74.50, name = "Xirah", quest = 96370 },
			{ criteria = 114001, mapID = 2599, x = 33.30, y = 43.00, name = "Opprimius", quest = 96373 },
			{ criteria = 114003, mapID = 2599, x = 33.50, y = 58.20, name = "The Horror Below", quest = 96375 },
			{ criteria = 113996, mapID = 2599, x = 37.90, y = 77.25, name = "Atomus", quest = 95940 },
			{ criteria = 113998, mapID = 2599, x = 49.70, y = 79.20, name = "Mercilus", quest = 96371 },
			{ criteria = 114000, mapID = 2599, x = 42.60, y = 58.30, name = "Krilkan", quest = 96372 },
			{ criteria = 114002, mapID = 2599, x = 23.20, y = 41.40, name = "Nelgothar", quest = 96374 },
			{ criteria = 114004, mapID = 2599, x = 35.90, y = 59.80, name = "Shadowguard Destroyer", quest = 96465 },
		},
	},
	--- The Honored Dead — Vaults of Atal'Utek (uiMapID 2509, child of 2512 The Coiled
	--- Isle, measured with /mh atal on 13 Aug 2026).
	---
	--- WHY THIS ENTRY EXISTS. Rob walked in on 13 Aug and said "I have no idea what I
	--- can all do there and above all where." Twelve memorials with real coordinates is
	--- the answer to both halves, and this table is the whole feature: the card, the
	--- checklist, the Route button, the arrow, the per-node waypoints and the NavSearch
	--- rows all come off it without another line of code.
	---
	--- ⚠️ SOURCE: HandyNotes_Midnight 150 (14 Aug 2026) — the source this repo trusts
	--- for rare COORDINATES and, since 13 Aug, explicitly does NOT trust for quest ids.
	--- Its Coiled Isle quest band (93829..97122) turned out not to be the flag that
	--- fires on a kill; ours (98344..98354) was. That ruling was about rares, and these
	--- are quest objectives rather than kills, so it does not automatically carry over —
	--- but it is the reason both bands below are still unconfirmed rather than assumed.
	---
	--- The failure mode is mild either way: NodeDone prefers the criteria id and falls
	--- back to the quest, so wrong ids leave the card stuck at 0/12 instead of claiming
	--- progress that is not there. `/mh ach id 63610` prints every criterion of 63610 in
	--- order and settles 116407..116418 in one go; `/mh questdiff` over a memorial
	--- settles the quest band.
	---
	--- Node order is the walking order the Codex article prints — top of the map
	--- downwards — so the checklist and the article read the same. The Route button
	--- re-sorts by real distance anyway.
	---
	--- nameKey is ACH_LORE_* deliberately. These are memorials you visit, not chests, so
	--- [Lore] is the honest tag; it also makes feedsMeta default to false, which is
	--- right, because nobody has measured whether 63610 rolls into a zone meta.
	---
	--- No `faction`: the Coiled Isle's major-faction id has never been measured here.
	--- RenownLineText omits the line when it is nil, which beats naming the wrong one.
	{
		achievementID = 63610, -- The Honored Dead
		nameKey = "ACH_LORE_HONORED_DEAD",
		nodes = {
			{ criteria = 116415, mapID = 2509, x = 46.79, y = 7.51, name = "To a sister", quest = 98037 },
			{ criteria = 116418, mapID = 2509, x = 56.49, y = 22.88, name = "To a shield-bearer", quest = 98040 },
			{ criteria = 116414, mapID = 2509, x = 47.22, y = 28.77, name = "To a father", quest = 98036 },
			{ criteria = 116417, mapID = 2509, x = 42.57, y = 33.18, name = "To a stranger", quest = 98039,
				note = "ACH_NOTE_STRANGER" },
			{ criteria = 116411, mapID = 2509, x = 52.91, y = 33.90, name = "To a captain", quest = 98033 },
			{ criteria = 116410, mapID = 2509, x = 55.62, y = 40.60, name = "To a dream", quest = 98032 },
			-- ✅ GECORRIGEERD 15 aug 2026 door Robs eigen meting. Stond op 42.91/41.23
			-- (HandyNotes); hij liep de route, haalde het achievement, en las bij dit
			-- gedenkteken 42.84/39.93 van zijn scherm. De x viel binnen afronding, de
			-- y zat er 1,3 naast — genoeg om de pijl er voorbij te sturen.
			-- Eerste HandyNotes-coördinaat op dit eiland die aantoonbaar fout was.
			{ criteria = 116412, mapID = 2509, x = 42.84, y = 39.93, name = "To sons", quest = 98034 },
			{ criteria = 116408, mapID = 2509, x = 52.21, y = 45.12, name = "To a lover", quest = 98030 },
			{ criteria = 116416, mapID = 2509, x = 38.50, y = 47.66, name = "To Comrades", quest = 98038 },
			{ criteria = 116409, mapID = 2509, x = 55.31, y = 48.45, name = "To parents", quest = 98031 },
			{ criteria = 116407, mapID = 2509, x = 49.50, y = 56.59, name = "To a daughter", quest = 98029 },
			{ criteria = 116413, mapID = 2509, x = 45.81, y = 61.79, name = "To Failure", quest = 98035 },
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
	[114011] = true,                                   -- Naigtal (Indomitable Mk XII)
	[113997] = true,                                   -- Val (Glacial Broodmother)
}
