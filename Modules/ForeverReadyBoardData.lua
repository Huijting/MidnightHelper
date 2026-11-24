local _, ns = ...

--[[
	ForeverReadyBoardData.lua — item and aura ids for the Forever group board (ForeverReadyBoard.lua).
	Measured by mh-research on wago DB2 wowf 1.60.1.71037 (ItemXItemEffect -> ItemEffect.SpellID, SpellEffect,
	SpellMisc/SpellDuration, ItemSparse.RequiredLevel) + Wowhead Forever tooltips, 24 Nov 2026. Full report with what
	could NOT be measured: docs/forever/CONSUMABLES_FOREVER_2026-11-24.md (copied from its Lua block by a script; the
	only change: the four utility food auras moved to auras_util).
	- Battle/Guardian elixir groups are NOT in the client data (0x "Elixir" in GlobalStrings): the board treats every
	  elixir and flask as one column ("one of them on you" = green).
	- Order inside a list = best first by RequiredLevel, strength, duration: a judgement (AFGELEID), not data.
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_CONSUMABLES = {
	-- Flasks (2 h, persist through death, one at a time) and pre-fight elixirs.
	flask = {
		{ item = 13510, aura = 17626, lvl = 50, kind = "flask", dur = 7200 },   -- Flask of the Titans: +1200 HP
		{ item = 13512, aura = 17628, lvl = 50, kind = "flask", dur = 7200 },   -- Flask of Supreme Power: +150 SpD
		{ item = 13511, aura = 17627, lvl = 50, kind = "flask", dur = 7200 },   -- Flask of Distilled Wisdom: +2000 mana
		{ item = 13513, aura = 17629, lvl = 50, kind = "flask", dur = 7200 },   -- Flask of Chromatic Resistance
		{ item = 274273, aura = 1293740, lvl = 55, kind = "flask", dur = 7200 }, -- Flask of Natural Accuracy (hit, Hyjal zones)
		{ item = 274274, aura = 1293741, lvl = 55, kind = "flask", dur = 7200 }, -- Flask of Natural Aggression (crit)
		{ item = 274275, aura = 1293742, lvl = 55, kind = "flask", dur = 7200 }, -- Flask of Natural Precision (dodge/parry)
		{ item = 274276, aura = 1293743, lvl = 55, kind = "flask", dur = 7200 }, -- Flask of Natural Swiftness (haste); spell is NAMED "Flask of Natural Accuracy"
		{ item = 250328, aura = 1250918, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Cunning
		{ item = 250329, aura = 1250920, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of the Phalanx
		{ item = 250333, aura = 1250926, lvl = 55, kind = "elixir", dur = 1800 }, -- Greater Cleric's Elixir
		{ item = 250335, aura = 1250931, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Greater Fortitude
		{ item = 250336, aura = 1250932, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Wicked Regeneration
		{ item = 250337, aura = 1250940, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of the Owl
		{ item = 250338, aura = 1250941, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Sages
		{ item = 250341, aura = 1250948, lvl = 55, kind = "elixir", dur = 1800 }, -- Greater Mageblood Elixir
		{ item = 250343, aura = 1250972, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Nature Power
		{ item = 250347, aura = 1250979, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Greater Spirit
		{ item = 250348, aura = 1250981, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of the Whale
		{ item = 250350, aura = 1250985, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Ferocity
		{ item = 250351, aura = 1250986, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of the Grizzly
		{ item = 20004, aura = 24361, lvl = 53, kind = "elixir", dur = 3600 },    -- Major Troll's Blood Elixir
		{ item = 9206, aura = 11405, lvl = 48, kind = "elixir", dur = 3600 },     -- Elixir of Greater Strength
		{ item = 13454, aura = 17539, lvl = 47, kind = "elixir", dur = 3600 },    -- Greater Arcane Elixir
		{ item = 13452, aura = 17538, lvl = 46, kind = "elixir", dur = 1800 },    -- Elixir of the Mongoose
		{ item = 13453, aura = 17537, lvl = 45, kind = "elixir", dur = 3600 },    -- Elixir of Brute Force
		{ item = 250332, aura = 1250925, lvl = 45, kind = "elixir", dur = 1800 }, -- Cleric's Elixir
		{ item = 250334, aura = 1250928, lvl = 45, kind = "elixir", dur = 1800 }, -- Elixir of Fortitude
		{ item = 250346, aura = 1250978, lvl = 45, kind = "elixir", dur = 1800 }, -- Elixir of Spirit
		{ item = 250349, aura = 1250984, lvl = 45, kind = "elixir", dur = 1800 }, -- Elixir of Strength
		{ item = 250354, aura = 1250989, lvl = 45, kind = "elixir", dur = 1800 }, -- Elixir of Intellect
		{ item = 12820, aura = 17038, lvl = 45, kind = "elixir", dur = 1200 },    -- Winterfall Firewater
		{ item = 246948, aura = 17038, lvl = 45, kind = "elixir", dur = 1200 },   -- Distilled Firewater (same aura)
		{ item = 13445, aura = 11348, lvl = 43, kind = "elixir", dur = 3600 },    -- Elixir of Greater Defense
		{ item = 20007, aura = 24363, lvl = 40, kind = "elixir", dur = 3600 },    -- Mageblood Elixir
		{ item = 9264, aura = 11474, lvl = 40, kind = "elixir", dur = 1800 },     -- Elixir of Shadow Power
		{ item = 21546, aura = 1310077, lvl = 40, kind = "elixir", dur = 1800 },  -- Elixir of Holy Power
		{ item = 9187, aura = 11334, lvl = 38, kind = "elixir", dur = 3600 },     -- Elixir of Greater Agility
		{ item = 13447, aura = 17535, lvl = 38, kind = "elixir", dur = 3600 },    -- Elixir of the Sages
		{ item = 9088, aura = 11371, lvl = 38, kind = "elixir", dur = 1800 },     -- Gift of Arthas
		{ item = 9179, aura = 11396, lvl = 37, kind = "elixir", dur = 3600 },     -- Elixir of Greater Intellect
		{ item = 9155, aura = 11390, lvl = 37, kind = "elixir", dur = 1800 },     -- Arcane Elixir
		{ item = 8951, aura = 11349, lvl = 29, kind = "elixir", dur = 3600 },     -- Elixir of Defense
		{ item = 17708, aura = 21920, lvl = 28, kind = "elixir", dur = 1800 },    -- Elixir of Frost Power
		{ item = 217398, aura = 439959, lvl = 28, kind = "elixir", dur = 1800 },  -- Lesser Arcane Elixir
		{ item = 8949, aura = 11328, lvl = 27, kind = "elixir", dur = 3600 },     -- Elixir of Agility
		{ item = 3826, aura = 3223, lvl = 26, kind = "elixir", dur = 3600 },      -- Troll's Blood Elixir
		{ item = 3825, aura = 3593, lvl = 25, kind = "elixir", dur = 3600 },      -- Elixir of Lesser Fortitude
		{ item = 250331, aura = 1250924, lvl = 25, kind = "elixir", dur = 1800 }, -- Lesser Cleric's Elixir
		{ item = 250340, aura = 1250944, lvl = 25, kind = "elixir", dur = 1800 }, -- Lesser Mageblood Elixir
		{ item = 250342, aura = 1250971, lvl = 25, kind = "elixir", dur = 1800 }, -- Lesser Arcane Elixir
		{ item = 250345, aura = 1250976, lvl = 25, kind = "elixir", dur = 1800 }, -- Elixir of Lesser Spirit
		{ item = 250353, aura = 1250988, lvl = 25, kind = "elixir", dur = 1800 }, -- Elixir of Lesser Intellect
		{ item = 3391, aura = 3164, lvl = 20, kind = "elixir", dur = 3600 },      -- Elixir of Ogre Strength
		{ item = 3390, aura = 3160, lvl = 18, kind = "elixir", dur = 3600 },      -- Elixir of Lesser Agility
		{ item = 6373, aura = 7844, lvl = 18, kind = "elixir", dur = 1800 },      -- Elixir of Fire Power
		{ item = 3389, aura = 3220, lvl = 16, kind = "elixir", dur = 3600 },      -- Elixir of Lesser Defense
		{ item = 3388, aura = 3222, lvl = 15, kind = "elixir", dur = 3600 },      -- Lesser Troll's Blood Elixir
		{ item = 3383, aura = 3166, lvl = 10, kind = "elixir", dur = 1800 },      -- Elixir of Wisdom
		{ item = 250330, aura = 1250922, lvl = 5, kind = "elixir", dur = 1800 },  -- Minor Cleric's Elixir
		{ item = 250339, aura = 1250942, lvl = 5, kind = "elixir", dur = 1800 },  -- Minor Mageblood Elixir
		{ item = 250344, aura = 1250974, lvl = 5, kind = "elixir", dur = 1800 },  -- Elixir of Minor Spirit
		{ item = 2457, aura = 2374, lvl = 2, kind = "elixir", dur = 3600 },       -- Elixir of Minor Agility
		{ item = 2458, aura = 2378, lvl = 2, kind = "elixir", dur = 3600 },       -- Elixir of Minor Fortitude
		{ item = 2454, aura = 2367, lvl = 1, kind = "elixir", dur = 3600 },       -- Elixir of Minor Strength
		{ item = 3382, aura = 3219, lvl = 1, kind = "elixir", dur = 3600 },       -- Minor Troll's Blood Elixir
		{ item = 5997, aura = 673, lvl = 1, kind = "elixir", dur = 3600 },        -- Elixir of Minor Defense
		{ item = 247754, aura = 1245244, lvl = 1, kind = "elixir", dur = 1800 },  -- Minor Arcane Elixir
		{ item = 247755, aura = 1245249, lvl = 1, kind = "elixir", dur = 1800 },  -- Elixir of Minor Force
		-- "Endless" elixirs: in the data, stack to 5, sell for 1 copper; where players get them is NOT measured.
		{ item = 289083, aura = 1327737, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Power
		{ item = 289086, aura = 1327751, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Rapidity
		{ item = 289087, aura = 1327753, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Opportunity
		{ item = 289082, aura = 1327736, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Intellect
		{ item = 289084, aura = 1327738, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Healing
		{ item = 289321, aura = 1328032, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Mana
	},

	food = {
		-- Every spell named exactly "Well Fed" in Forever (30). Strength of the new ones comes from the food, not the aura.
		auras = {
			1248406, 1248420, 1248421, 1248422,            -- Stamina / Agility / Intellect / Strength
			1249519, 1249520, 1249523, 1249926, 1249927,   -- AP / spell damage / 1% crit / Spirit / healing
			1225778, 1225779, 1225780, 1319310,            -- lvl 55 foods (Str / Agi / caster) and Plated Armorfish
			19705, 19706, 19708, 19709, 19710, 19711,      -- classic Stamina+Spirit versions
			24799, 24870, 25694, 25941, 1225782, 1283082, 1302064, -- older/unused (24870 = Bobbing Apple, derived)
		},
		-- Utility food buffs (Fishing, Herbalism, speed in Westfall / Hyjal): Well Fed by name, but not for a fight.
		-- The board does not count them (bouwchat 24 Nov 2026); their items carry util = true.
		auras_util = { 1249521, 1249907, 1248688, 1294007 },
		-- Food buffs that are NOT named "Well Fed" (measured).
		auras_other = { 25661, 470361, 470367, 18125, 18141 }, -- Increased Stamina, Increased Spell Damage, Increased Healing Power, Blessed Sunfruit, Blessed Sunfruit Juice
		-- 1243969 "Well Fed XP Boost" (+5% kill XP) is an extra, not a combat buff: left out on purpose.
		items = {
			{ item = 238639, aura = 1225780, lvl = 55 }, -- Sunrise Omelette: 25 SpD, 55 heal, 10 Sta
			{ item = 238637, aura = 1225778, lvl = 55 }, -- Prowler Steak: 25 Str, 10 Sta
			{ item = 238638, aura = 1225779, lvl = 55 }, -- Filet o' Flank: 25 Agi, 10 Sta
			{ item = 267341, aura = 1294007, lvl = 55, util = true }, -- Sweetpaw Jam: speed in Hyjal
			{ item = 13934, aura = 1249519, lvl = 45 },  -- Mightfish Steak: 40 AP
			{ item = 249870, aura = 1249927, lvl = 45 }, -- Sage's Tea: 44 healing
			{ item = 13933, aura = 1249520, lvl = 45 },  -- Lobster Stew: 28 SpD
			{ item = 13935, aura = 1249520, lvl = 45 },  -- Baked Salmon: 28 SpD
			{ item = 21023, aura = 25661, lvl = 45, wf = false }, -- Dirge's Kickin' Chimaerok Chops: 25 Sta
			{ item = 250068, aura = 1248406, lvl = 45 }, -- Savory Turtle Stew: 20 Sta
			{ item = 250069, aura = 1248420, lvl = 45 }, -- Flank au Poivre: 20 Agi
			{ item = 250072, aura = 1248420, lvl = 45 }, -- Swiftstrike Steak: 20 Agi
			{ item = 250066, aura = 1248421, lvl = 45 }, -- Soaring Pamplona: 20 Int
			{ item = 250067, aura = 1248421, lvl = 45 }, -- Bat Hachee: 20 Int
			{ item = 250075, aura = 1248421, lvl = 45 }, -- Prehistoric Pulled Raptor: 20 Int
			{ item = 20452, aura = 1248422, lvl = 45 },  -- Smoked Desert Dumplings: 20 Str
			{ item = 250070, aura = 1248422, lvl = 45 }, -- Bear Bruscitti: 20 Str
			{ item = 250071, aura = 1248422, lvl = 45 }, -- Steaming Stag Steak: 20 Str
			{ item = 249876, aura = 1249926, lvl = 45 }, -- Wicked Smoothie: 20 Spi
			{ item = 232436, aura = 470361, lvl = 45, wf = false }, -- Darkclaw Bisque: 12 SpD, 10 min
			{ item = 13810, aura = 18125, lvl = 45, wf = false },   -- Blessed Sunfruit: 10 Str, 10 min
			{ item = 13813, aura = 18141, lvl = 45, wf = false },   -- Blessed Sunfruit Juice: 10 Spi, 10 min
			{ item = 8957, aura = 1249521, lvl = 45, util = true }, -- Spinefin Halibut: Fishing
			{ item = 16971, aura = 19710, lvl = 40 },    -- Clamlette Surprise: 12 Sta + 12 Spi
			{ item = 13932, aura = 1249519, lvl = 35 },  -- Poached Sunscale Salmon: 40 AP
			{ item = 249869, aura = 1249927, lvl = 35 }, -- Sunny Tea: 33 healing
			{ item = 13927, aura = 1249519, lvl = 35 },  -- Cooked Glossy Mightfish: 30 AP
			{ item = 6887, aura = 1249520, lvl = 35 },   -- Spotted Yellowtail: 22 SpD
			{ item = 13931, aura = 1249520, lvl = 35 },  -- Nightfin Soup: 22 SpD
			{ item = 232438, aura = 470367, lvl = 35, wf = false }, -- Smoked Redgill: 22 healing, 10 min
			{ item = 12218, aura = 1248406, lvl = 35 },  -- Monster Omelet: 15 Sta
			{ item = 17222, aura = 1248406, lvl = 35 },  -- Spider Sausage: 15 Sta
			{ item = 12212, aura = 1248420, lvl = 35 },  -- Jungle Stew: 15 Agi
			{ item = 18045, aura = 1248420, lvl = 35 },  -- Tender Wolf Steak: 15 Agi
			{ item = 18254, aura = 1248421, lvl = 35 },  -- Runn Tum Tuber Surprise: 15 Int
			{ item = 250076, aura = 1248421, lvl = 35 }, -- Raptor Rouladen: 15 Int
			{ item = 250065, aura = 1248422, lvl = 35 }, -- Savory Stag Sliders: 15 Str
			{ item = 249875, aura = 1249926, lvl = 35 }, -- Spicy Smoothie: 15 Spi
			{ item = 13928, aura = 1249523, lvl = 35 },  -- Grilled Squid: 1% crit
			{ item = 13929, aura = 1249523, lvl = 35 },  -- Hot Smoked Bass: 1% crit
			{ item = 286152, aura = 1319310, lvl = 35 }, -- Plated Armorfish: 150 armor
			{ item = 13930, aura = 1249521, lvl = 35, util = true }, -- Filet of Redgill: Fishing
			{ item = 21217, aura = 1249520, lvl = 30 },  -- Sagefish Delight: 7 SpD
			{ item = 249868, aura = 1249927, lvl = 25 }, -- Triage Tea: 22 healing
			{ item = 8364, aura = 1249519, lvl = 25 },   -- Mithril Head Trout: 20 AP
			{ item = 274971, aura = 1249520, lvl = 25 }, -- Briny Seafood Stew: 14 SpD
			{ item = 6038, aura = 1248406, lvl = 25 },   -- Giant Clam Scorcho: 10 Sta
			{ item = 12215, aura = 1248406, lvl = 25 },  -- Heavy Kodo Stew: 10 Sta
			{ item = 250078, aura = 1248406, lvl = 25 }, -- Giant Scrambled Eggs: 10 Sta
			{ item = 3728, aura = 1248420, lvl = 25 },   -- Tasty Lion Steak: 10 Agi
			{ item = 13851, aura = 1248420, lvl = 25 },  -- Hot Wolf Ribs: 10 Agi
			{ item = 20074, aura = 1248420, lvl = 25 },  -- Heavy Crocolisk Stew: 10 Agi
			{ item = 4457, aura = 1248421, lvl = 25 },   -- Barbecued Buzzard Wing: 10 Int
			{ item = 12216, aura = 1248421, lvl = 25 },  -- Spiced Chili Crab: 10 Int
			{ item = 250073, aura = 1248421, lvl = 25 }, -- Raging Raptor Ribs: 10 Int
			{ item = 250074, aura = 1248422, lvl = 25 }, -- Bear Brisket: 10 Str
			{ item = 274976, aura = 1248422, lvl = 25 }, -- Plain Ol' Paletusk: 10 Str
			{ item = 249874, aura = 1249926, lvl = 25 }, -- Calcified Smoothie: 10 Spi
			{ item = 4594, aura = 1249521, lvl = 25, util = true },  -- Rockscale Cod: Fishing
			{ item = 10841, aura = 1249907, lvl = 25, util = true }, -- Goldthorn Tea: Herbalism
			{ item = 249867, aura = 1249927, lvl = 15 }, -- Root Tea: 11 healing
			{ item = 5527, aura = 19708, lvl = 15 },     -- Goblin Deviled Clams: 6 Sta + 6 Spi
			{ item = 3665, aura = 1248406, lvl = 15 },   -- Curiously Tasty Omelet: 5 Sta
			{ item = 3666, aura = 1248406, lvl = 15 },   -- Gooey Spider Cake: 5 Sta
			{ item = 3729, aura = 1248406, lvl = 15 },   -- Soothing Turtle Bisque: 5 Sta
			{ item = 12214, aura = 1248406, lvl = 15 },  -- Mystery Stew: 5 Sta
			{ item = 1017, aura = 1248420, lvl = 15 },   -- Seasoned Wolf Kabob: 5 Agi
			{ item = 3664, aura = 1248420, lvl = 15 },   -- Crocolisk Gumbo: 5 Agi
			{ item = 3727, aura = 1248420, lvl = 15 },   -- Hot Lion Chops: 5 Agi
			{ item = 12209, aura = 1248420, lvl = 15 },  -- Lean Wolf Steak: 5 Agi
			{ item = 12210, aura = 1248421, lvl = 15 },  -- Roast Raptor: 5 Int
			{ item = 2685, aura = 1248422, lvl = 15 },   -- Succulent Pork Ribs: 5 Str
			{ item = 5480, aura = 1248422, lvl = 15 },   -- Lean Venison: 5 Str
			{ item = 249873, aura = 1249926, lvl = 15 }, -- Mrrggl Smrrthle: 5 Spi
			{ item = 4593, aura = 1249521, lvl = 15, util = true },  -- Bristle Whisker Catfish: Fishing
			{ item = 21072, aura = 1249520, lvl = 10 },  -- Smoked Sagefish: 4 SpD
			{ item = 4592, aura = 1249519, lvl = 5 },    -- Longjaw Mud Snapper: 10 AP
			{ item = 249866, aura = 1249927, lvl = 5 },  -- Royal Tea: 7 healing
			{ item = 5479, aura = 1248406, lvl = 5 },    -- Crispy Lizard Tail: 3 Sta
			{ item = 12213, aura = 1248406, lvl = 5 },   -- Carrion Surprise: 3 Sta
			{ item = 250080, aura = 1248406, lvl = 5 },  -- Breakfast Omelette: 3 Sta
			{ item = 268912, aura = 1248406, lvl = 5 },  -- Expiring Crab Cake: 3 Sta
			{ item = 268913, aura = 1248406, lvl = 5 },  -- Expiring Crocolisk Steak: 3 Sta
			{ item = 2684, aura = 1248420, lvl = 5 },    -- Coyote Steak: 3 Agi
			{ item = 3662, aura = 1248420, lvl = 5 },    -- Crocolisk Steak: 3 Agi
			{ item = 1082, aura = 1248421, lvl = 5 },    -- Redridge Goulash: 3 Int
			{ item = 2683, aura = 1248421, lvl = 5 },    -- Crab Cake: 3 Int
			{ item = 250077, aura = 1248421, lvl = 5 },  -- Twice-Spiced Raptor Slice: 3 Int
			{ item = 724, aura = 1248422, lvl = 5 },     -- Goretusk Liver Pie: 3 Str
			{ item = 2687, aura = 1248422, lvl = 5 },    -- Dry Pork Ribs: 3 Str
			{ item = 3220, aura = 1248422, lvl = 5 },    -- Blood Sausage: 3 Str
			{ item = 3726, aura = 1248422, lvl = 5 },    -- Big Bear Steak: 3 Str
			{ item = 249872, aura = 1249926, lvl = 5 },  -- Slimy Smoothie: 3 Spi
			{ item = 263509, aura = 1248406, lvl = 5 },  -- Skywall Souffle: 1 Sta
			{ item = 263512, aura = 1248421, lvl = 5 },  -- Pincer Bites: 1 Int
			{ item = 5095, aura = 1249520, lvl = 5 },    -- Rainbow Fin Albacore: 1 SpD
			{ item = 5476, aura = 1249521, lvl = 5, util = true },  -- Fillet of Frenzy: Fishing
			{ item = 6316, aura = 1249521, lvl = 5, util = true },  -- Loch Frenzy Delight: Fishing
			{ item = 733, aura = 1248688, lvl = 5, util = true },   -- Westfall Stew: speed in Westfall
			{ item = 287973, aura = 1248420, lvl = 1 },  -- Tender Wolf Steak (account-bound): 15 Agi
			{ item = 287974, aura = 1249523, lvl = 1 },  -- Grilled Squid (account-bound): 1% crit
			{ item = 787, aura = 1249519, lvl = 1 },     -- Slitherskin Mackerel: 6 AP
			{ item = 249865, aura = 1249927, lvl = 1 },  -- Peace Tea: 2 healing
			{ item = 6290, aura = 1249519, lvl = 1 },    -- Brilliant Smallfish: 2 AP
			{ item = 206177, aura = 19705, lvl = 1 },    -- Pine Nut Butter: 2 Sta + 2 Spi
			{ item = 7806, aura = 19705, lvl = 1 },      -- Lollipop
			{ item = 7807, aura = 19705, lvl = 1 },      -- Candy Bar
			{ item = 7808, aura = 19705, lvl = 1 },      -- Chocolate Square
			{ item = 11584, aura = 19705, lvl = 0 },     -- Cactus Apple Surprise
			{ item = 17197, aura = 19705, lvl = 1 },     -- Gingerbread Cookie
			{ item = 17198, aura = 19705, lvl = 1 },     -- Egg Nog
			{ item = 20516, aura = 24870, lvl = 0, derived = true }, -- Bobbing Apple (tooltip says well fed; no DB2 link)
			{ item = 21254, aura = 24870, lvl = 0, derived = true }, -- Winter Veil Cookie (idem)
			{ item = 3663, aura = 1248406, lvl = 1 },    -- Murloc Fin Soup: 1 Sta
			{ item = 5472, aura = 1248406, lvl = 1 },    -- Kaldorei Spider Kabob: 1 Sta
			{ item = 5474, aura = 1248406, lvl = 1 },    -- Roasted Kodo Meat: 1 Sta
			{ item = 6888, aura = 1248406, lvl = 1 },    -- Herb Baked Egg: 1 Sta
			{ item = 2680, aura = 1248420, lvl = 1 },    -- Spiced Wolf Meat: 1 Agi
			{ item = 2682, aura = 1248421, lvl = 1 },    -- Cooked Crab Claw: 1 Int
			{ item = 5477, aura = 1248421, lvl = 1 },    -- Strider Stew: 1 Int
			{ item = 12224, aura = 1248421, lvl = 1 },   -- Crispy Bat Wing: 1 Int
			{ item = 250079, aura = 1248421, lvl = 1 },  -- Tasty Raptor Bites: 1 Int
			{ item = 2681, aura = 1248422, lvl = 1 },    -- Roasted Boar Meat: 1 Str
			{ item = 2888, aura = 1248422, lvl = 1 },    -- Beer Basted Boar Ribs: 1 Str
			{ item = 6890, aura = 1248422, lvl = 1 },    -- Smoked Bear Meat: 1 Str
			{ item = 249871, aura = 1249926, lvl = 1 },  -- Venomous Smoothie: 1 Spi
		},
	},

	-- Health potions: plain first, then rejuvenation (also mana), then Discolored (75% comes back as poison/disease),
	-- then two Season of Discovery copies Wowhead says "may not be in WoW: Forever". All share potion category 4 (120 s).
	hpot = {
		{ item = 13446, lvl = 45, heal = 1400 },             -- Major Healing Potion
		{ item = 282011, lvl = 1, pct = 30 },                -- Restored Healing Potion (BoP, 30% HP; place in the list is a guess)
		{ item = 3928, lvl = 35, heal = 800 },               -- Superior Healing Potion
		{ item = 288896, lvl = 1, heal = 800 },              -- Superior Healing Potion (ilvl 30 copy)
		{ item = 18839, lvl = 35, heal = 800 },              -- Combat Healing Potion (PvP rank 5)
		{ item = 1710, lvl = 21, heal = 520 },               -- Greater Healing Potion
		{ item = 287977, lvl = 1, heal = 520 },              -- Greater Healing Potion (account-bound)
		{ item = 929, lvl = 12, heal = 320 },                -- Healing Potion
		{ item = 268883, lvl = 12, heal = 320 },             -- Perishable Healing Potion (conjured)
		{ item = 858, lvl = 3, heal = 160 },                 -- Lesser Healing Potion
		{ item = 268882, lvl = 3, heal = 160 },              -- Perishable Lesser Healing Potion
		{ item = 287967, lvl = 1, heal = 160 },              -- Lesser Healing Potion (account copy)
		{ item = 118, lvl = 1, heal = 80 },                  -- Minor Healing Potion
		{ item = 268881, lvl = 1, heal = 80 },               -- Perishable Minor Healing Potion
		{ item = 287966, lvl = 1, heal = 80 },               -- Minor Healing Potion (account-bound)
		{ item = 18253, lvl = 50, heal = 1600, mana = 1600, kind = "rejuv" }, -- Major Rejuvenation Potion
		{ item = 9144, lvl = 35, heal = 750, mana = 750, kind = "rejuv" },    -- Wildvine Potion
		{ item = 2456, lvl = 5, heal = 120, mana = 120, kind = "rejuv" },     -- Minor Rejuvenation Potion
		{ item = 241650, lvl = 60, heal = 2800, kind = "discolored" },        -- Major Discolored Healing Potion
		{ item = 247242, lvl = 35, heal = 1600, kind = "discolored" },        -- Superior Discolored Healing Potion
		{ item = 247241, lvl = 21, heal = 1040, kind = "discolored" },        -- Greater Discolored Healing Potion
		{ item = 247240, lvl = 12, heal = 640, kind = "discolored" },         -- Discolored Healing Potion
		{ item = 247239, lvl = 3, heal = 320, kind = "discolored" },          -- Lesser Discolored Healing Potion
		{ item = 4596, lvl = 5, heal = 160, kind = "discolored" },            -- Minor Discolored Healing Potion
		{ item = 223913, lvl = 40, heal = 1500, kind = "sod" },               -- Major Healing Potion (SoD)
		{ item = 223914, lvl = 20, heal = 650, kind = "sod" },                -- Greater Healing Potion (SoD)
	},

	mpot = {
		{ item = 13444, lvl = 49, mana = 1800 },             -- Major Mana Potion
		{ item = 282013, lvl = 1, pct = 20 },                -- Restored Mana Potion (BoP, 20% mana; place is a guess)
		{ item = 13443, lvl = 41, mana = 1200 },             -- Superior Mana Potion
		{ item = 288897, lvl = 1, mana = 1200 },             -- Superior Mana Potion (ilvl 30 copy)
		{ item = 18841, lvl = 41, mana = 1200 },             -- Combat Mana Potion (PvP rank 5)
		{ item = 6149, lvl = 31, mana = 800 },               -- Greater Mana Potion
		{ item = 3827, lvl = 22, mana = 520 },               -- Mana Potion
		{ item = 3385, lvl = 14, mana = 320 },               -- Lesser Mana Potion
		{ item = 287969, lvl = 1, mana = 320 },              -- Lesser Mana Potion (account copy)
		{ item = 2455, lvl = 5, mana = 160 },                -- Minor Mana Potion
		{ item = 287968, lvl = 1, mana = 160 },              -- Minor Mana Potion (account copy)
	},

	-- Healthstones: own cooldown category 1153 (not the potion one). 19004-19013 = Improved Healthstone talent copies.
	hs = {
		{ item = 9421, lvl = 48, heal = 1440 },  -- Major Healthstone
		{ item = 19013, lvl = 48, heal = 1440 }, -- Major Healthstone (talent copy)
		{ item = 19012, lvl = 48, heal = 1320 }, -- Major Healthstone (talent copy)
		{ item = 5510, lvl = 36, heal = 960 },   -- Greater Healthstone
		{ item = 19011, lvl = 36, heal = 960 },  -- Greater Healthstone (talent copy)
		{ item = 19010, lvl = 36, heal = 880 },  -- Greater Healthstone (talent copy)
		{ item = 5509, lvl = 24, heal = 600 },   -- Healthstone
		{ item = 19009, lvl = 24, heal = 600 },  -- Healthstone (talent copy)
		{ item = 19008, lvl = 24, heal = 550 },  -- Healthstone (talent copy)
		{ item = 5511, lvl = 12, heal = 300 },   -- Lesser Healthstone
		{ item = 19007, lvl = 12, heal = 300 },  -- Lesser Healthstone (talent copy)
		{ item = 19006, lvl = 12, heal = 275 },  -- Lesser Healthstone (talent copy)
		{ item = 5512, lvl = 1, heal = 120 },    -- Minor Healthstone
		{ item = 19005, lvl = 1, heal = 120 },   -- Minor Healthstone (talent copy)
		{ item = 19004, lvl = 1, heal = 110 },   -- Minor Healthstone (talent copy)
	},
}
