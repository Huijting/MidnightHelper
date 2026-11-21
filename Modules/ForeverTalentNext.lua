local _, ns = ...

--[[
	ForeverTalentNext.lua — WoW Forever: "Talent point: put it in <Talent> (n/max)" in Do this now.

	Rob, 21 Nov 2026 (via sparring): How you play is "weer heel veel tekst", and he did not see "waar ik mijn punten ... in
	zou moeten stoppen ... Wil ik snel levelen, maar ook wel tanken." On the proposal "'Do this now' zegt bij elk nieuw level
	welk talent je nu moet kiezen ... Dan hoef je die hele lijst nooit te lezen", literally: "Ja, doe dat maar".

	How it decides (no guessing per level):
	  1. Only when you have an unused class talent point: C_Traits.GetTreeCurrencyInfo(config, tree) — the same call MH
	     uses for Legacy Points (ForeverLegacy.lua). nil = not readable → silent, and /mh talent says so.
	  2. The order = your direction (ForeverDirection.lua, the tree you chose); no direction = the class's levelling tree
	     (DEFAULT below), and the line says that.
	  3. MH reads every node of that order in the real tree (C_Traits.GetNodeInfo → ranksPurchased) and names the FIRST
	     step that is not done yet. So a point you put elsewhere does not confuse it; it only skips what you already have.
	Orders: ORDERS below, one public source each (named per order). Node ids GEMETEN in DB2 (see the table comments).
	Reading C_Traits in the game for this = AFGELEID until Rob's /mh talent shows it (the trees were measured for the
	"Which way?" question through the same calls, ForeverMacros.lua SpecBand).
	Switch: Quiet helpers (on by default). Diagnosis: /mh talent.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- Trait tree per class (same as ForeverMacros.lua TREE, GEMETEN in DB2 TraitTree).
local TREE = { WARRIOR = 1117, PALADIN = 1100, HUNTER = 1091, ROGUE = 1111, PRIEST = 1114, SHAMAN = 1082, MAGE = 1112,
	WARLOCK = 1116, DRUID = 1089 }
-- Class talent point currency (GEMETEN 17 Nov 2026, TraitCurrencySource → currency 3820, ForeverMacros.lua Talented note).
local TALENT_CURRENCY = 3820

-- The tree a class levels with when no direction is chosen (band numbers as ForeverDirection / the role texts).
-- 21 Nov 2026: the same tree How you play names for levelling (ForeverHowToPlay.lua role texts, GEMETEN by grep):
-- Paladin Retribution 3, Shaman Enhancement 2, Druid Feral (cat) 2, Mage Frost 3, Priest Shadow 3, Rogue Combat 2,
-- Hunter Beast Mastery 1, Warlock Affliction 1, Warrior Protection 3 ("most say"; the guides disagree).
local DEFAULT = { PALADIN = 3, SHAMAN = 2, DRUID = 2, MAGE = 3, PRIEST = 3, ROGUE = 2, HUNTER = 1, WARLOCK = 1, WARRIOR = 3 }

--[[ ORDERS[class][band] = { source = "...", steps = { { node = id, spell = id, name = "English", to = ranks }, ... } }
	`to` = the rank this step brings the talent to (a talent of 5 ranks in one go = one step with to = 5). ]]
-- 21 Nov 2026, Fable check (one read-only round over all 15 orders, 314 steps, Rob: "om het 1 keer goed na te laten
-- kijken"): every id, rank, band, source sequence, row gate and prerequisite OK (GEMETEN, two checkers + negative
-- controls). Open, not settled by data: Stormstrike 17364 (SpellLevels 40, untouched from Classic Era; guides 25) and
-- Vampiric Embrace 15286 (SpellLevels 30, raised from Era 1; guides 25-27). Hunter Counterattack 19306 has the same
-- pattern (30 on row 4) but is in no order. RequiredLevel is 0 in all 171 TraitCond rows.
-- Node and spell ids GEMETEN 21 Nov 2026 (mh-research, wago DB2 Forever 1.60.1.71037: SpellName → TraitDefinition →
-- TraitNodeEntry → TraitNodeXTraitNodeEntry → TraitNode in tree 1100; MaxRanks match every step; the bouwchat re-checked
-- 3 entries → nodes: 130436→105707, 137873→110875, 130352→105628). The order itself = the named guide (AFGELEID).
local function S(node, spell, name, to)
	return { node = node, spell = spell, name = name, to = to }
end
local ORDERS = {
	PALADIN = {
		-- Retribution (band 3): guided.news "WoW Forever: Dein Vergelter-Paladin Easy Leveln von 1 bis 60", Sascha
		-- Asendorf, 21 Nov 2026 (12 Holy / 8 Protection / 31 Retribution at 60).
		[3] = { source = "guided.news, Retribution levelling guide (21 Nov 2026)", steps = {
			S(105707, 20060, "Deflection", 5),
			S(105703, 20117, "Conviction", 3),
			S(105705, 25956, "Improved Judgement", 2),
			S(105699, 26022, "Pursuit of Justice", 2),
			S(105696, 20375, "Seal of Command", 1),
			S(105701, 1311074, "Sanctified Judgement", 2),
			S(105697, 20111, "Two-Handed Weapon Specialization", 3),
			S(105700, 1311087, "Sacred Arbiter", 1),
			S(105701, 1311074, "Sanctified Judgement", 3),
			S(105693, 20049, "Vengeance", 3),
			S(105694, 20066, "Repentance", 1),
			S(105706, 20101, "Benediction", 1),
			S(110882, 1311084, "Champion of the Light", 5),
			S(105692, 1310735, "Unsealed Wrath", 1),
			S(113630, 20262, "Divine Strength", 5),
			S(110871, 1310899, "Reverence", 2),
			S(105334, 20224, "Improved Seals", 5),
			S(105332, 20257, "Divine Intellect", 5),
			S(105638, 20189, "Precision", 3),
		} },
		-- Protection (band 2): stillsixty.com "Protection Paladin Guide", updated 17 Nov 2026 (0 / 42 / 9 at 60). Steps 1-14
		-- reach Shieldsworn at 40 (its gate: 30 points in the Protection tab, TraitCond 50987, GEMETEN); the rest is the
		-- guide's table after 40.
		[2] = { source = "stillsixty.com, Protection Paladin guide (17 Nov 2026)", steps = {
			S(105626, 20127, "Redoubt", 5),
			S(105638, 20189, "Precision", 3),
			S(105632, 1224697, "Sacred Duty", 2),
			S(105625, 1311015, "Templar's Bulwark", 1),
			S(110874, 20150, "Shield Specialization", 2),
			S(105630, 20143, "Toughness", 2),
			S(105634, 20468, "Improved Righteous Fury", 3),
			S(110878, 1310994, "Swift Judgement", 1),
			S(105630, 20143, "Toughness", 3),
			S(105628, 20925, "Holy Shield", 1),
			S(105627, 20177, "Reckoning", 5),
			S(110879, 1311034, "Iron Creed", 3),
			S(105630, 20143, "Toughness", 4),
			S(110875, 1328544, "Shieldsworn", 1),
			S(105630, 20143, "Toughness", 5),
			S(105636, 20096, "Anticipation", 5),
			S(105332, 20257, "Divine Intellect", 5),
			S(105706, 20101, "Benediction", 5),
			S(105705, 25956, "Improved Judgement", 2),
			S(105703, 20117, "Conviction", 2),
		} },
	},
	-- Shaman, tree 1082 (mh-research 21 Nov 2026, DB2 71037; nodes 104724-104773, tab 1 Elemental, 2 Enhancement,
	-- 3 Restoration; every edge and row gate checked; bouwchat re-checked 129403→104743, 129384→104724, 129413→104753).
	SHAMAN = {
		-- Enhancement (band 2): Mobalytics "WoW Forever Shaman Leveling Guide" by Tiqqle, "1-60 Enhance / Water Shield
		-- First", 13 Nov 2026 (4/36/11). Spec: 6 of 7 guides level as Enhancement (timesaver.gg alone: Elemental).
		[2] = { source = "Mobalytics, Shaman levelling guide by Tiqqle (13 Nov 2026)",
			note = "6 of 7 guides level as Enhancement. Levels 10-24 agree everywhere; after that stillsixty takes Flurry "
				.. "first and Stormstrike only at 40 (the game's own data still says 40 for Stormstrike: if the game "
				.. "refuses it, MH names the next talent).", steps = {
			S(104753, 16255, "Thundering Strikes", 5),
			S(104755, 415140, "Mental Dexterity", 3),
			S(104756, 17485, "Ancestral Knowledge", 2),
			S(104749, 1223030, "Shamanistic Focus", 1),
			S(104750, 16266, "Elemental Weapons", 3),
			S(104756, 17485, "Ancestral Knowledge", 3),
			S(104743, 17364, "Stormstrike", 1),
			S(104752, 16262, "Improved Ghost Wolf", 2),
			S(104747, 16256, "Flurry", 2),
			S(104742, 1223031, "Improved Stormstrike", 2),
			S(104729, 16179, "Tidal Focus", 5),
			S(104734, 1223033, "Mindfulness", 3),
			S(104735, 16173, "Totemic Focus", 2),
			S(104732, 408510, "Water Shield", 1),
			S(104744, 30812, "Mental Quickness", 2),
			S(104747, 16256, "Flurry", 3),
			S(104741, 408498, "Maelstrom Weapon", 5),
			S(104740, 425336, "Rage of the Farseer", 1),
			S(104745, 16268, "Spirit Weapons", 1),
			S(104747, 16256, "Flurry", 5),
			S(104756, 17485, "Ancestral Knowledge", 5),
			S(104772, 16035, "Concussion", 4),
		} },
		-- Restoration (band 3), for a healer second set (Dual Spec, 40): stillsixty.com "Restoration Shaman Guide",
		-- tab "Leveling 1-60" (0/10/41), 2 Nov 2026 (sources checked 19 Nov). Riptide (the 31-point talent) = step 13.
		[3] = { source = "stillsixty.com, Restoration Shaman guide (2 Nov 2026)", steps = {
			S(104739, 16182, "Improved Healing Wave", 5),
			S(104734, 1223033, "Mindfulness", 3),
			S(104729, 16179, "Tidal Focus", 2),
			S(104732, 408510, "Water Shield", 1),
			S(104729, 16179, "Tidal Focus", 5),
			S(104733, 16181, "Healing Focus", 1),
			S(104728, 16190, "Mana Tide Totem", 1),
			S(104733, 16181, "Healing Focus", 3),
			S(104738, 16194, "Tidal Mastery", 5),
			S(104727, 29206, "Healing Way", 3),
			S(104726, 16188, "Nature's Swiftness", 1),
			S(104725, 16178, "Purification", 3),
			S(104724, 408521, "Riptide", 1),
			S(104725, 16178, "Purification", 5),
			S(104730, 16187, "Restorative Totems", 5),
			S(104731, 16176, "Ancestral Healing", 3),
			S(104753, 16255, "Thundering Strikes", 5),
			S(104756, 17485, "Ancestral Knowledge", 5),
		} },
	},
	-- Warrior, tree 1117 (mh-research 21 Nov 2026, DB2 71037; tab 1 Arms, 2 Fury, 3 Protection; edges and row gates
	-- checked; no talent before its SpellLevels; bouwchat re-checked 130706→105976, 130671→105941).
	WARRIOR = {
		-- Protection (band 3): timesaver.gg Protection calculator, order from Maxroll (4 Nov 2026), checked on the live
		-- trees 13 Nov (10/10/31).
		[3] = { source = "timesaver.gg / Maxroll, Protection levelling (4 Nov 2026)",
			note = "Most guides say Protection levels fastest (Icy Veins, Mobalytics, Wowhead, Conquest Capped); "
				.. "SixtySim says Arms is faster, so Arms has its own order (choose the direction Arms).", steps = {
			S(105976, 12298, "Shield Specialization", 5),
			S(105969, 12797, "Improved Revenge", 3),
			S(105972, 12287, "Improved Thunder Clap", 2),
			S(105971, 1310316, "Master of Defense", 2),
			S(105972, 12287, "Improved Thunder Clap", 3),
			S(105970, 12975, "Last Stand", 1),
			S(105974, 12301, "Improved Bloodrage", 1),
			S(105966, 1310317, "Vanguard", 1),
			S(105974, 12301, "Improved Bloodrage", 2),
			S(105975, 12297, "Anticipation", 3),
			S(105965, 12809, "Concussion Blow", 1),
			S(105961, 29787, "Focused Rage", 3),
			S(105975, 12297, "Anticipation", 4),
			S(105962, 16538, "Bastion", 5),
			S(105959, 23922, "Shield Slam", 1),
			S(105956, 12286, "Improved Rend", 3),
			S(105957, 16462, "Deflection", 5),
			S(105939, 12320, "Cruelty", 5),
			S(105955, 12285, "Improved Charge", 2),
			S(105937, 12322, "Unbridled Wrath", 5),
		} },
		-- Arms (band 1): Mobalytics "Warrior Leveling Guide", Arms 1-60 by Ahlaundoh (19 Nov 2026), 32/19/0.
		[1] = { source = "Mobalytics, Arms levelling guide by Ahlaundoh (19 Nov 2026)",
			note = "Every list takes Mortal Strike at 40; Wowhead and Method also take Improved Tactical Mastery and "
				.. "Anger Management, this order skips them.", steps = {
			S(105956, 12286, "Improved Rend", 3),
			S(105957, 16462, "Deflection", 2),
			S(105952, 12290, "Improved Overpower", 2),
			S(105955, 12285, "Improved Charge", 2),
			S(105957, 16462, "Deflection", 3),
			S(105950, 12834, "Deep Wounds", 3),
			S(105957, 16462, "Deflection", 5),
			S(105949, 1310222, "Spearing Strike", 1),
			S(105948, 12163, "Two-Handed Weapon Specialization", 3),
			S(105947, 16493, "Impale", 1),
			S(105945, 12292, "Sweeping Strikes", 1),
			S(110524, 1289682, "Bloodthrill", 2),
			S(105947, 16493, "Impale", 2),
			S(105944, 1290261, "Weaponmaster", 1),
			S(110858, 12862, "Improved Slam", 1),
			S(105944, 1290261, "Weaponmaster", 5),
			S(105941, 12294, "Mortal Strike", 1),
			S(110858, 12862, "Improved Slam", 2),
			S(105939, 12320, "Cruelty", 5),
			S(105937, 12322, "Unbridled Wrath", 5),
			S(105931, 12317, "Enrage", 5),
			S(105935, 12323, "Piercing Howl", 1),
			S(113636, 1329555, "Reckless Swings", 1),
			S(110857, 1323964, "Lingering Rage", 2),
		} },
	},
	-- Druid, tree 1089 (mh-research 21 Nov 2026, DB2 71037; tab 1 Balance, 2 Feral, 3 Restoration; edges and row
	-- gates checked; bouwchat re-checked 129598→104938, 129570→104910).
	DRUID = {
		-- Feral, cat (band 2): Mobalytics "Druid Leveling Guide" (Feral) by yumytv (14 Nov 2026), 9/31/11.
		[2] = { source = "Mobalytics, Feral levelling guide by yumytv (14 Nov 2026)",
			note = "Cat Feral is the levelling pick of most guides. Some guides take Feral Instinct instead of Furor "
				.. "and add Lacerate and Primal Bite (better for a bear tank).", steps = {
			S(104938, 16934, "Ferocity", 3),
			S(104939, 17056, "Furor", 5),
			S(104943, 17002, "Feral Swiftness", 2),
			S(104946, 16942, "Sharpened Claws", 2),
			S(104948, 16998, "Savage Fury", 2),
			S(104944, 1238122, "Feral Charge", 1),
			S(104951, 1328613, "Predatory Discipline", 1),
			S(104947, 16958, "Blood Frenzy", 2),
			S(104952, 16972, "Predatory Strikes", 2),
			S(104955, 17007, "Leader of the Pack", 1),
			S(104950, 1223242, "Natural Instinct", 2),
			S(104952, 16972, "Predatory Strikes", 3),
			S(104938, 16934, "Ferocity", 4),
			S(104953, 1223246, "Rend and Tear", 5),
			S(113563, 1322605, "Shifting Power", 1),
			S(104924, 1223081, "Genesis", 5),
			S(104927, 1223082, "Nature's Majesty", 2),
			S(104929, 16819, "Nature's Reach", 2),
			S(104958, 17003, "Heart of the Wild", 5),
			S(104922, 17069, "Naturalist", 5),
			S(104919, 16833, "Natural Shapeshifter", 1),
		} },
		-- Restoration (band 3), healer second set (Dual Spec, 40): timesaver.gg Restoration, order from Maxroll
		-- (3 Nov 2026), checked on the live trees 13 Nov. Wild Growth (the 31-point talent) = step 12.
		[3] = { source = "timesaver.gg / Maxroll, Restoration (3 Nov 2026)", steps = {
			S(104958, 17003, "Heart of the Wild", 5),
			S(104922, 17069, "Naturalist", 5),
			S(104918, 1328621, "Bloom", 1),
			S(104916, 17104, "Gift of Nature", 4),
			S(104912, 18562, "Swiftmend", 1),
			S(104914, 17111, "Improved Rejuvenation", 3),
			S(104916, 17104, "Gift of Nature", 5),
			S(104911, 1309631, "Living Spirit", 3),
			S(104921, 17116, "Nature's Swiftness", 1),
			S(104920, 17106, "Reflection", 3),
			S(104913, 17074, "Improved Regrowth", 3),
			S(104910, 408120, "Wild Growth", 1),
			S(104924, 1223081, "Genesis", 5),
			S(104927, 1223082, "Nature's Majesty", 2),
			S(104925, 16845, "Moonglow", 3),
			S(104928, 1223083, "Nature's Splendor", 1),
			S(104913, 17074, "Improved Regrowth", 5),
			S(104909, 17123, "Improved Tranquility", 2),
			S(104915, 24968, "Tranquil Spirit", 5),
		} },
	},
	-- Hunter, tree 1091 (mh-research 21 Nov 2026, DB2 71037; tab 1 Beast Mastery, 2 Marksmanship, 3 Survival; edges
	-- and row gates checked; bouwchat re-checked 129621→104960, 129622→104961). No second order: no clear advice for
	-- another spec in groups.
	HUNTER = {
		-- Beast Mastery (band 1): Mobalytics "Hunter Leveling Guide" by Feor (18 Nov 2026), 31/20/0.
		[1] = { source = "Mobalytics, Hunter levelling guide by Feor (18 Nov 2026)",
			note = "The guides level as Beast Mastery (Icy Veins, Wowhead, Mobalytics, Maxroll); Wowhead adds that all "
				.. "three trees work.", steps = {
			S(104960, 19552, "Deadly Aspects", 5),
			S(104975, 1223755, "Focused Fire", 2),
			S(104972, 24443, "Improved Revive Pet", 2),
			S(104976, 19583, "Endurance Training", 1),
			S(104973, 19559, "Pathfinding", 2),
			S(104970, 19596, "Bestial Swiftness", 1),
			S(104969, 19616, "Unleashed Fury", 2),
			S(104966, 1293241, "Summon Hawk", 1),
			S(104969, 19616, "Unleashed Fury", 4),
			S(104967, 19598, "Ferocity", 2),
			S(104964, 19577, "Intimidation", 1),
			S(104963, 19590, "Bestial Discipline", 2),
			S(104967, 19598, "Ferocity", 5),
			S(104962, 19621, "Frenzy", 4),
			S(104961, 19574, "Bestial Wrath", 1),
			S(105011, 19426, "Lethal Attacks", 5),
			S(105008, 1223984, "Careful Aim", 5),
			S(105005, 415405, "Rapid Killing", 2),
			S(105013, 19498, "Hawk Eye", 3),
			S(105004, 1299346, "Trueshot Aura", 1),
			S(105002, 19485, "Mortal Shots", 4),
		} },
	},
	-- Rogue, tree 1111 (mh-research 21 Nov 2026, DB2 71037; tab 1 Assassination, 2 Combat, 3 Subtlety; edges and row
	-- gates checked; bouwchat re-checked 130470→105741, 130453→105724). No second order (no clear group advice).
	ROGUE = {
		-- Combat (band 2): Mobalytics "Rogue Leveling Guide" by Djexde (12 Nov 2026), 16/35/0; his Combat guide of
		-- 5 Nov gives the same order.
		[2] = { source = "Mobalytics, Rogue levelling guide by Djexde (12 Nov 2026)",
			note = "The guides level as Combat (Icy Veins, Mobalytics, Method, Fextralife). Method takes Flawless "
				.. "Execution earlier and Flash of Steel later.", steps = {
			S(105723, 14144, "Remorseless Attacks", 2),
			S(105741, 13732, "Efficient Strikes", 2),
			S(105708, 14162, "Coup de Grace", 3),
			S(105738, 13713, "Deflection", 3),
			S(105737, 13705, "Precision", 2),
			S(105735, 14251, "Riposte", 1),
			S(105737, 13705, "Precision", 3),
			S(105736, 13742, "Endurance", 2),
			S(113398, 13712, "Lightning Reflexes", 1),
			S(105726, 30919, "Weapon Expertise", 2),
			S(105730, 18427, "Aggression", 3),
			S(105728, 13877, "Blade Flurry", 1),
			S(113635, 13715, "Dual Wield Specialization", 2),
			S(105727, 13960, "Hack and Slash", 2),
			S(105740, 1329284, "Flash of Steel", 5),
			S(105724, 13750, "Adrenaline Rush", 1),
			S(105727, 13960, "Hack and Slash", 5),
			S(105722, 14138, "Malice", 3),
			S(105739, 14165, "Improved Slice and Dice", 3),
			S(105722, 14138, "Malice", 5),
			S(105720, 14983, "Vigor", 2),
			S(105718, 1329256, "Blood Splatter", 1),
			S(105716, 14128, "Lethality", 2),
			S(105715, 14177, "Cold Blood", 1),
			S(108100, 1310711, "Flawless Execution", 1),
		} },
	},
	-- Priest, tree 1114 (mh-research 21 Nov 2026, DB2 71037; tab 1 Discipline, 2 Holy, 3 Shadow; edges and row gates
	-- checked; bouwchat re-checked 130546→105817, 137847→110855). Holy Specialization = node 110855 (105865 is a stray).
	PRIEST = {
		-- Shadow (band 3): MMOJUGG "WoW Forever Priest Leveling Guide 1-60" (13 Nov 2026), 20/0/31.
		[3] = { source = "MMOJUGG, Priest levelling guide (13 Nov 2026)",
			note = "Every guide levels as Shadow; Icy Veins and Mobalytics stay Discipline-heavy until 40, then respec. "
				.. "This order takes Vampiric Embrace at 27, the game's own data says 30: if the game refuses it, MH "
				.. "names the next talent.", steps = {
			S(105850, 14524, "Wand Specialization", 2),
			S(105833, 15270, "Spirit Tap", 5),
			S(105830, 15275, "Improved Shadow Word: Pain", 2),
			S(110851, 15260, "Shadow Focus", 3),
			S(105826, 15407, "Mind Flay", 1),
			S(105825, 1225139, "Improved Mind Flay", 2),
			S(105831, 15273, "Improved Mind Blast", 2),
			S(105820, 15286, "Vampiric Embrace", 1),
			S(105821, 15257, "Shadow Weaving", 3),
			S(110851, 15260, "Shadow Focus", 4),
			S(105819, 1309950, "Devouring Contagion", 2),
			S(110851, 15260, "Shadow Focus", 5),
			S(105831, 15273, "Improved Mind Blast", 4),
			S(105818, 15259, "Darkness", 5),
			S(105817, 15473, "Shadowform", 1),
			S(105849, 1225132, "Twin Disciplines", 5),
			S(105837, 18551, "Mental Strength", 3),
			S(105843, 14521, "Meditation", 3),
			S(105844, 14751, "Inner Focus", 1),
			S(105842, 14520, "Mental Agility", 3),
			S(105846, 14748, "Improved Power Word: Shield", 3),
		} },
		-- Holy (band 2), healer second set (Dual Spec, 40): warcraftmaps.com "Holy Priest Guide" by Miisuto (checked
		-- 17 Nov 2026), 18/33/0. Prayer of Mending (the 31-point talent) = step 14.
		[2] = { source = "warcraftmaps.com, Holy Priest guide (17 Nov 2026)",
			note = "For dungeons 4 sources pick Holy, 2 pick Discipline.", steps = {
			S(110855, 14889, "Holy Specialization", 5),
			S(105863, 18530, "Divine Fury", 5),
			S(105866, 14908, "Improved Renew", 3),
			S(105862, 15237, "Holy Nova", 1),
			S(105861, 27811, "Blessed Recovery", 1),
			S(105858, 14912, "Improved Healing", 3),
			S(105856, 1328569, "Holy Binding", 1),
			S(105860, 14892, "Inspiration", 1),
			S(105854, 20711, "Spirit of Redemption", 1),
			S(105853, 14901, "Spiritual Guidance", 4),
			S(105852, 14898, "Spiritual Healing", 3),
			S(105853, 14901, "Spiritual Guidance", 5),
			S(105855, 1317006, "Litany of Light", 1),
			S(105851, 401859, "Prayer of Mending", 1),
			S(105860, 14892, "Inspiration", 3),
			S(105849, 1225132, "Twin Disciplines", 5),
			S(105837, 18551, "Mental Strength", 5),
			S(105844, 14751, "Inner Focus", 1),
			S(105843, 14521, "Meditation", 3),
			S(105842, 14520, "Mental Agility", 3),
			S(105846, 14748, "Improved Power Word: Shield", 1),
		} },
	},
	-- Mage, tree 1112 (mh-research 21 Nov 2026, DB2 71037; tab 1 Arcane, 2 Fire, 3 Frost; edges and row gates checked;
	-- bouwchat re-checked 130491→105762). No second order: the guides do not agree on a group tree.
	MAGE = {
		-- Frost (band 3): GrindClassic "Frost Mage leveling build" (20 Nov 2026), 18/0/33.
		[3] = { source = "GrindClassic, Frost Mage levelling build (20 Nov 2026)",
			note = "Nearly every guide levels as Frost; one Mobalytics guide levels as Arcane.", steps = {
			S(105779, 11070, "Improved Frostbolt", 5),
			S(105778, 29438, "Precision", 2),
			S(105774, 11071, "Frostbite", 3),
			S(105767, 1312002, "Ice Lance", 1),
			S(105777, 11207, "Ice Shards", 4),
			S(105768, 11170, "Shatter", 3),
			S(105777, 11207, "Ice Shards", 5),
			S(105769, 11958, "Ice Block", 1),
			S(105764, 400647, "Fingers of Frost", 2),
			S(105770, 16757, "Arctic Reach", 2),
			S(105766, 12472, "Cold Snap", 1),
			S(105772, 11160, "Frost Channeling", 3),
			S(105778, 29438, "Precision", 3),
			S(105765, 11190, "Improved Cone of Cold", 1),
			S(105762, 11426, "Ice Barrier", 1),
			S(105815, 6057, "Wand Specialization", 2),
			S(105802, 28574, "Arcane Resilience", 3),
			S(105809, 400588, "Missile Barrage", 2),
			S(105812, 11210, "Arcane Subtlety", 2),
			S(105810, 11213, "Arcane Concentration", 1),
			S(105806, 400574, "Arcane Blast", 1),
			S(105810, 11213, "Arcane Concentration", 5),
			S(105803, 18462, "Arcane Meditation", 3),
			S(105765, 11190, "Improved Cone of Cold", 3),
		} },
	},
	-- Warlock, tree 1116 (mh-research 21 Nov 2026, DB2 71037; tab 1 Affliction, 2 Demonology, 3 Destruction; edges and
	-- row gates checked; bouwchat re-checked 130639→105909, 130604→105874). Grim Reach = node 105923.
	WARLOCK = {
		-- Affliction (band 1): Mobalytics "Warlock Leveling Guide" by Crix (updated 20-21 Nov 2026), 40/11/0.
		[1] = { source = "Mobalytics, Warlock levelling guide by Crix (21 Nov 2026)",
			note = "The guides level as Affliction; Crix names Affliction and Demonology as the best two.", steps = {
			S(105924, 17810, "Improved Corruption", 5),
			S(105925, 18174, "Suppression", 4),
			S(105922, 437032, "Soul Harvest", 2),
			S(105919, 18827, "Improved Bane of Agony", 2),
			S(105920, 403511, "Improved Drains", 3),
			S(105918, 17783, "Fel Concentration", 3),
			S(105923, 18218, "Grim Reach", 1),
			S(105912, 18265, "Siphon Life", 1),
			S(105911, 17804, "Soul Siphon", 3),
			S(105923, 18218, "Grim Reach", 2),
			S(105910, 18271, "Shadow Mastery", 5),
			S(105909, 1316697, "Wrack", 1),
			S(105907, 18697, "Demonic Embrace", 5),
			S(105903, 18731, "Fel Vitality", 3),
			S(105902, 1235316, "Demonic Aegis", 2),
			S(105900, 18788, "Demonic Sacrifice", 1),
			S(105916, 18288, "Amplify Curse", 1),
			S(105913, 18223, "Curse of Exhaustion", 1),
			S(105917, 427712, "Pandemic", 3),
			S(110876, 1310949, "Malevolence", 4),
		} },
		-- Destruction (band 3), for players who choose it (3 guides: Destruction for dungeons from 40): wofwforever
		-- (Seren) "Destruction, level 10 to 60: point by point" (9 Nov 2026). Incinerate = step 13.
		[3] = { source = "wofwforever, Destruction point by point (9 Nov 2026)",
			note = "Three guides say Destruction for dungeons from 40; others name Demonology or keep Affliction.", steps = {
			S(105888, 17788, "Bane", 5),
			S(105887, 17778, "Cataclysm", 3),
			S(105885, 1225220, "Molten Skin", 2),
			S(105884, 17877, "Shadowburn", 1),
			S(105883, 17959, "Ruin", 4),
			S(105880, 1293817, "Conflagrate", 1),
			S(105883, 17959, "Ruin", 5),
			S(105879, 17927, "Agonizing Flames", 3),
			S(105876, 1225228, "Bane of Havoc", 1),
			S(105877, 412751, "Fire and Brimstone", 3),
			S(105885, 1225220, "Molten Skin", 3),
			S(105875, 426316, "Shadow and Flame", 5),
			S(105874, 412758, "Incinerate", 1),
			S(105885, 1225220, "Molten Skin", 5),
			S(105889, 17793, "Improved Shadow Bolt", 5),
			S(105882, 18135, "Intensity", 3),
			S(105881, 17917, "Destructive Reach", 2),
			S(105886, 18119, "Aftermath", 3),
			S(105907, 18697, "Demonic Embrace", 5),
		} },
	},
}
ns.FOREVER_TALENT_ORDERS = ORDERS -- the offline check reads it

function ns.IsForeverTalentNextOn()
	return not (type(ns.db) == "table" and ns.db.foreverTalentNext == false)
end

function ns.SetForeverTalentNext(on)
	if type(ns.db) ~= "table" then
		return
	end
	-- plain branches (lint [29])
	if on then
		ns.db.foreverTalentNext = nil
	else
		ns.db.foreverTalentNext = false
	end
end

local function num(v)
	if type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
		return v
	end
	return nil
end

--- The config for this class's tree, or nil + why.
local function Config(tree)
	if not (C_Traits and C_Traits.GetNodeInfo) then
		return nil, "no C_Traits"
	end
	local cfg
	if C_ClassTalents and C_ClassTalents.GetActiveConfigID then
		local ok, v = pcall(C_ClassTalents.GetActiveConfigID)
		if ok and num(v) then
			cfg = v
		end
	end
	if cfg and C_Traits.GetConfigInfo then
		local ok, info = pcall(C_Traits.GetConfigInfo, cfg)
		local has = false
		for _, t in ipairs(ok and type(info) == "table" and info.treeIDs or {}) do
			if t == tree then
				has = true
			end
		end
		if not has then
			cfg = nil
		end
	end
	if not cfg and C_Traits.GetConfigIDByTreeID then
		local ok, v = pcall(C_Traits.GetConfigIDByTreeID, tree)
		if ok and num(v) and v > 0 then
			cfg = v
		end
	end
	if not cfg then
		return nil, "no talent config"
	end
	return cfg
end

--- Unused class talent points, or nil + why.
local function FreePoints(cfg, tree)
	if not C_Traits.GetTreeCurrencyInfo then
		return nil, "no GetTreeCurrencyInfo"
	end
	local ok, list = pcall(C_Traits.GetTreeCurrencyInfo, cfg, tree, false)
	if not (ok and type(list) == "table") then
		return nil, ok and "no currency info" or ("error: " .. tostring(list))
	end
	local pick
	for _, c in ipairs(list) do
		if type(c) == "table" and c.traitCurrencyID == TALENT_CURRENCY then
			pick = c
		end
	end
	pick = pick or list[1]
	if type(pick) ~= "table" or num(pick.quantity) == nil then
		return nil, "currency quantity not readable"
	end
	return pick.quantity, nil, pick.traitCurrencyID
end

local function Ranks(cfg, node)
	local ok, info = pcall(C_Traits.GetNodeInfo, cfg, node)
	if not (ok and type(info) == "table") then
		return nil, nil
	end
	-- Third value: false only when the client SAYS it cannot be bought now (canPurchaseRank, a boolean in the node info;
	-- AFGELEID from Blizzard's talent UI, not measured in Forever). nil = the client did not say: treat as buyable.
	local can = info.canPurchaseRank
	if issecretvalue and issecretvalue(can) then
		can = nil
	end
	return num(info.ranksPurchased) or num(info.currentRank), num(info.maxRanks), can
end

local function SpellName(id, fallback)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return fallback
end

--- The order for this character: order, band, where the band came from.
local function Order()
	local _, cls = UnitClass("player")
	local band, src
	if ns.GetForeverDirection then
		band = ns.GetForeverDirection()
		src = band and "your direction"
	end
	if not band then
		band, src = DEFAULT[cls], "no direction chosen: the class's levelling tree"
	end
	local byClass = ORDERS[cls]
	return byClass and band and byClass[band], band, src, cls
end

--- The decision: { free, step, cur, max, name, order, band, src, why }.
function ns.ForeverTalentNextState()
	local st = {}
	if not ns.IsForeverTalentNextOn() then
		st.why = "switched off (Quiet helpers)"
		return st
	end
	local order, band, src, cls = Order()
	st.band, st.src, st.class = band, src, cls
	if not order then
		st.why = "no talent order for this class and tree yet"
		return st
	end
	st.order = order
	local tree = TREE[cls]
	local cfg, whyC = Config(tree)
	if not cfg then
		st.why = whyC
		return st
	end
	st.config = cfg
	local free, whyF, cur = FreePoints(cfg, tree)
	st.free, st.currency = free, cur
	if free == nil then
		st.why = "unused points not readable (" .. tostring(whyF) .. ") — silent on purpose"
		return st
	end
	if free < 1 then
		st.why = "no unused talent point"
		return st
	end
	-- 21 Nov 2026 (Shaman: the guides take Stormstrike at 25, the client's SpellLevels still says 40 — GEMETEN by
	-- mh-research; which one the game follows is not measured): the FIRST step that is not done and that the client does
	-- not refuse. A refused step is skipped and named in the reason; if every open step is refused, the first one is named.
	local firstOpen, skipped
	for i, s in ipairs(order.steps) do
		local have, max, can = Ranks(cfg, s.node)
		if have == nil then
			st.why = ("node %d (%s) not readable"):format(s.node, s.name)
			return st
		end
		if have < s.to then
			firstOpen = firstOpen or { s = s, i = i, have = have, max = max }
			if can == false then
				skipped = skipped or s.name
			else
				st.step, st.index, st.cur, st.max = s, i, have, max or s.to
				st.name = SpellName(s.spell, s.name)
				st.why = ("step %d of %d: %s has %d, the order wants %d"):format(i, #order.steps, s.name, have, s.to)
					.. (skipped and (" (skipped " .. skipped .. ": the game says it cannot be bought yet)") or "")
				return st
			end
		end
	end
	if firstOpen then
		local s = firstOpen.s
		st.step, st.index, st.cur, st.max = s, firstOpen.i, firstOpen.have, firstOpen.max or s.to
		st.name = SpellName(s.spell, s.name)
		st.why = ("step %d: %s — the game says no open step can be bought now; named anyway"):format(firstOpen.i, s.name)
		return st
	end
	st.why = "every step of the order is done"
	return st
end

--- The Do this now line, or nil. Second value: the spell id (for the tooltip).
function ns.ForeverTalentNextLine()
	if InCombatLockdown and InCombatLockdown() then
		return nil
	end
	local ok, st = pcall(ns.ForeverTalentNextState)
	if not (ok and type(st) == "table" and st.step) then
		return nil
	end
	local link = st.name
	if ns.ForeverSpellLinkText then
		local okL, l = pcall(ns.ForeverSpellLinkText, st.step.spell, st.name)
		if okL and type(l) == "string" then
			link = l
		end
	end
	local s
	if st.free > 1 then
		s = ns:L("FTALENT_NEXT_MANY_FMT"):format(st.free, link, st.cur + 1, st.max)
	else
		s = ns:L("FTALENT_NEXT_FMT"):format(link, st.cur + 1, st.max)
	end
	if st.src ~= "your direction" then
		s = s .. " " .. ns:L("FTALENT_NO_DIR")
	end
	return s, st.step.spell
end

--- Open the game's talent window (AFGELEID: the names exist in this client family; pcall'd).
function ns.ForeverOpenTalents()
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	for _, fn in ipairs({
		function() return PlayerSpellsUtil and PlayerSpellsUtil.ToggleClassTalentFrame and PlayerSpellsUtil.ToggleClassTalentFrame() end,
		function() return ToggleTalentFrame and ToggleTalentFrame() end,
	}) do
		local ok = pcall(fn)
		if ok and ((PlayerSpellsUtil and PlayerSpellsUtil.ToggleClassTalentFrame) or ToggleTalentFrame) then
			return
		end
	end
end

--- /mh talent: what MH reads, which order, and why this talent (or why nothing).
function ns.ForeverTalentSlash()
	local st = ns.ForeverTalentNextState()
	print(PREFIX .. "next talent: " .. (ns.IsForeverTalentNextOn() and "on" or "off") .. " (Quiet helpers).")
	print(("  class %s, tree band %s (%s), order: %s"):format(tostring(st.class), tostring(st.band), tostring(st.src),
		st.order and (st.order.source .. ", " .. #st.order.steps .. " steps") or "none"))
	-- `note` (optional, per order): where the guides disagree and why this order was picked.
	if st.order and st.order.note then
		print("  about this order: " .. st.order.note)
	end
	print(("  talent config %s, unused points %s (currency %s)"):format(tostring(st.config), tostring(st.free),
		tostring(st.currency)))
	if st.order and st.config then
		for i, s in ipairs(st.order.steps) do
			local have, max, can = Ranks(st.config, s.node)
			if i <= 40 then
				-- 21 Nov 2026 (Fable check): "can buy" = what the client says (canPurchaseRank). Rob's test of
				-- Stormstrike (25 vs 40) and Vampiric Embrace (27 vs 30) reads it here.
				print(("    %2d. %s %s/%s (want %d), can buy: %s%s"):format(i, s.name, tostring(have), tostring(max),
					s.to, tostring(can), st.index == i and "  <- next" or ""))
			end
		end
	end
	print("  decision: " .. (st.step and ("put it in " .. tostring(st.name)) or "nothing to say") .. " — " .. tostring(st.why))
	local line = ns.ForeverTalentNextLine()
	print("  line in Do this now: " .. (line or "none"))
	if type(ns.db) == "table" then
		ns.db.foreverTalentProbe = { free = st.free, config = st.config, band = st.band, why = st.why,
			index = st.index, at = time and time() or nil }
	end
end
