--[[
	MidnightHelper — Leveling guide data per class + specialization index (GetSpecialization); spec 1 when no spec yet (Guide.lua).
	Class keys: ["DRUID"], ["DEATHKNIGHT"], ["DEMONHUNTER"], ["EVOKER"], ["HUNTER"], ["MAGE"], ["MONK"], ["PALADIN"], ["PRIEST"], ["ROGUE"], ["SHAMAN"], ["WARLOCK"], ["WARRIOR"] — must match select(2, UnitClass("player")).
	Uitbreiden: voeg classes/specs toe; zie Guide.lua voor UI.
]]

local addonName, ns = ...

ns.GuideData = ns.GuideData or {}

-- Phase 141+: `consumables` = { feast, food, flask, potion, healingPotion?, weaponOil?, rune } — numeric IDs or priority lists `{ id1, id2, … }` (Guide.lua picks first usable for your level). Default healing: Algari (211878 live, 211880 alt tier).
-- Feast: Silvermoon Parade (255845; Gemini/oude bundel noemde ten onrechte 222720 = The Sushi Special op WoWDB).
-- Strength solo food: Hearty Sizzling Honey Roast (222772); Gemini-naam "Meat Lover's Delight" bestaat niet als item.
-- Tank survival potion: Potion of Withering Vitality (191371). See `Guide.lua` for extra tooltip lines after SetItemByID.
-- Weapon oil (Midnight): Thalassian Phoenix Oil (243734; beta duplicate id 243733).

-- Druid: 1 Balance, 2 Feral, 3 Guardian, 4 Restoration (retail).
ns.GuideData["DRUID"] = {
	[1] = {
		title = "Balance Guide",
		icyTitle = "Icy Veins — Balance leveling",
		link = "https://www.icy-veins.com/wow/balance-druid-leveling-guide",
		tips = {
			{ spell = 8921, textKey = "GUIDE_TIP_001" },
			{ spell = 190984, textKey = "GUIDE_TIP_002" },
			{ spell = 194153, textKey = "GUIDE_TIP_003" },
			{ spell = 78674, textKey = "GUIDE_TIP_004" },
			{ spell = 191034, textKey = "GUIDE_TIP_005" },
			{ spell = 22812, textKey = "GUIDE_TIP_006" },
			{ spell = 132469, textKey = "GUIDE_TIP_007" },
			{ spell = 2908, textKey = "GUIDE_TIP_008" },
			{ spell = 1850, textKey = "GUIDE_TIP_009" },
			{ spell = 24858, textKey = "GUIDE_TIP_010" },
		},
		stats = "GUIDE_STATS_DRUID_BALANCE",
		gear = {
			"GUIDE_GEAR_DRUID_BALANCE_1",
			"GUIDE_GEAR_DRUID_BALANCE_2",
			"GUIDE_GEAR_DRUID_BALANCE_3",
			"GUIDE_GEAR_DRUID_BALANCE_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_BALANCE_10_ROT_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_10_ROT_2",
					"GUIDE_ADVISOR_DRUID_BALANCE_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_BALANCE_10_DEF_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_10_DEF_2",
					"GUIDE_ADVISOR_DRUID_BALANCE_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_BALANCE_10_TAL_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_BALANCE_30_ROT_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_30_ROT_2",
					"GUIDE_ADVISOR_DRUID_BALANCE_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_BALANCE_30_DEF_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_BALANCE_30_TAL_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_BALANCE_60_ROT_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_60_ROT_2",
					"GUIDE_ADVISOR_DRUID_BALANCE_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_BALANCE_60_DEF_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_BALANCE_60_TAL_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_BALANCE_80_ROT_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_BALANCE_80_DEF_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_BALANCE_80_TAL_1",
					"GUIDE_ADVISOR_DRUID_BALANCE_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.08, 0.06, 0.16, 0.92 },
			topBar = { 0.14, 0.10, 0.24, 0.95 },
			titleColor = { 0.82, 0.72, 1.0 },
			sectionBar = { 0.20, 0.14, 0.32, 0.9 },
			sectionText = { 0.92, 0.88, 1.0 },
			icyBackdrop = { 0.08, 0.06, 0.20, 0.85 },
			icyBorder = { 0.45, 0.35, 0.95, 0.9 },
			icyTitleColor = { 0.80, 0.75, 1.0 },
			ebBg = { 0.08, 0.08, 0.14, 0.95 },
		},
	},
	[2] = {
		title = "Feral Guide",
		icyTitle = "Icy Veins — Feral leveling",
		link = "https://www.icy-veins.com/wow/feral-druid-leveling-guide",
		tips = {
			{ spell = 1822, textKey = "GUIDE_TIP_011" },
			{ spell = 1079, textKey = "GUIDE_TIP_012" },
			{ spell = 22568, textKey = "GUIDE_TIP_013" },
			{ spell = 5221, textKey = "GUIDE_TIP_014" },
			{ spell = 5217, textKey = "GUIDE_TIP_015" },
			{ spell = 106830, textKey = "GUIDE_TIP_016" },
			{ spell = 61336, textKey = "GUIDE_TIP_017" },
			{ spell = 106839, textKey = "GUIDE_TIP_018" },
			{ spell = 22570, textKey = "GUIDE_TIP_019" },
			{ spell = 135700, textKey = "GUIDE_TIP_020" },
		},
		stats = "GUIDE_STATS_DRUID_FERAL",
		gear = {
			"GUIDE_GEAR_DRUID_FERAL_1",
			"GUIDE_GEAR_DRUID_FERAL_2",
			"GUIDE_GEAR_DRUID_FERAL_3",
			"GUIDE_GEAR_DRUID_FERAL_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222710, 242296, 242285, 242281 },
			flask = { 241324, 241322, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_FERAL_10_ROT_1",
					"GUIDE_ADVISOR_DRUID_FERAL_10_ROT_2",
					"GUIDE_ADVISOR_DRUID_FERAL_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_FERAL_10_DEF_1",
					"GUIDE_ADVISOR_DRUID_FERAL_10_DEF_2",
					"GUIDE_ADVISOR_DRUID_FERAL_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_FERAL_10_TAL_1",
					"GUIDE_ADVISOR_DRUID_FERAL_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_FERAL_30_ROT_1",
					"GUIDE_ADVISOR_DRUID_FERAL_30_ROT_2",
					"GUIDE_ADVISOR_DRUID_FERAL_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_FERAL_30_DEF_1",
					"GUIDE_ADVISOR_DRUID_FERAL_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_FERAL_30_TAL_1",
					"GUIDE_ADVISOR_DRUID_FERAL_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_FERAL_60_ROT_1",
					"GUIDE_ADVISOR_DRUID_FERAL_60_ROT_2",
					"GUIDE_ADVISOR_DRUID_FERAL_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_FERAL_60_DEF_1",
					"GUIDE_ADVISOR_DRUID_FERAL_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_FERAL_60_TAL_1",
					"GUIDE_ADVISOR_DRUID_FERAL_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_FERAL_80_ROT_1",
					"GUIDE_ADVISOR_DRUID_FERAL_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_FERAL_80_DEF_1",
					"GUIDE_ADVISOR_DRUID_FERAL_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_FERAL_80_TAL_1",
					"GUIDE_ADVISOR_DRUID_FERAL_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.10, 0.07, 0.05, 0.92 },
			topBar = { 0.22, 0.14, 0.08, 0.95 },
			titleColor = { 1.0, 0.78, 0.45 },
			sectionBar = { 0.28, 0.18, 0.10, 0.9 },
			sectionText = { 1.0, 0.90, 0.70 },
			icyBackdrop = { 0.18, 0.12, 0.06, 0.85 },
			icyBorder = { 0.85, 0.55, 0.25, 0.9 },
			icyTitleColor = { 1.0, 0.85, 0.55 },
			ebBg = { 0.12, 0.08, 0.06, 0.95 },
		},
	},
	[3] = {
		title = "Guardian Guide",
		icyTitle = "Icy Veins — Guardian leveling",
		link = "https://www.icy-veins.com/wow/guardian-druid-leveling-guide",
		tips = {
			{ spell = 8921, textKey = "GUIDE_TIP_021" },
			{ spell = 5487, textKey = "GUIDE_TIP_022" },
			{ spell = 192081, textKey = "GUIDE_TIP_023" },
			{ spell = 6795, textKey = "GUIDE_TIP_024" },
			{ spell = 77758, textKey = "GUIDE_TIP_025" },
			{ spell = 33917, textKey = "GUIDE_TIP_026" },
			{ spell = 22812, textKey = "GUIDE_TIP_027" },
			{ spell = 22842, textKey = "GUIDE_TIP_028" },
			{ spell = 1126, textKey = "GUIDE_TIP_029" },
			{ spell = 106839, textKey = "GUIDE_TIP_030" },
		},
		stats = "GUIDE_STATS_DRUID_GUARDIAN",
		gear = {
			"GUIDE_GEAR_DRUID_GUARDIAN_1",
			"GUIDE_GEAR_DRUID_GUARDIAN_2",
			"GUIDE_GEAR_DRUID_GUARDIAN_3",
			"GUIDE_GEAR_DRUID_GUARDIAN_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222710, 242296 },
			flask = { 241324, 241322 },
			potion = { 191371, 241308 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_10_ROT_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_10_ROT_2",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_10_DEF_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_10_DEF_2",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_10_TAL_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_10_TAL_2",
				},
				talentMilestones = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_10_MILE_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_10_MILE_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_30_ROT_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_30_ROT_2",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_30_DEF_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_30_TAL_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_30_TAL_2",
				},
				talentMilestones = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_30_MILE_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_30_MILE_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_60_ROT_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_60_ROT_2",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_60_DEF_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_60_TAL_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_60_TAL_2",
				},
				talentMilestones = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_60_MILE_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_60_MILE_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_80_ROT_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_80_DEF_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_80_TAL_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_80_TAL_2",
				},
				talentMilestones = {
					"GUIDE_ADVISOR_DRUID_GUARDIAN_80_MILE_1",
					"GUIDE_ADVISOR_DRUID_GUARDIAN_80_MILE_2",
				},
			},
		},
		theme = {
			tint = { 0.05, 0.14, 0.08, 0.92 },
			topBar = { 0.22, 0.14, 0.08, 0.95 },
			titleColor = { 0.72, 0.95, 0.55 },
			sectionBar = { 0.30, 0.20, 0.10, 0.9 },
			sectionText = { 0.95, 0.88, 0.65 },
			icyBackdrop = { 0.06, 0.22, 0.10, 0.85 },
			icyBorder = { 0.35, 0.75, 0.35, 0.9 },
			icyTitleColor = { 0.75, 1.0, 0.55 },
			ebBg = { 0.08, 0.10, 0.08, 0.95 },
		},
	},
	[4] = {
		title = "Restoration Guide",
		icyTitle = "Icy Veins — Restoration leveling",
		link = "https://www.icy-veins.com/wow/restoration-druid-leveling-guide",
		tips = {
			{ spell = 774, textKey = "GUIDE_TIP_031" },
			{ spell = 33763, textKey = "GUIDE_TIP_032" },
			{ spell = 48438, textKey = "GUIDE_TIP_033" },
			{ spell = 8936, textKey = "GUIDE_TIP_034" },
			{ spell = 18562, textKey = "GUIDE_TIP_035" },
			{ spell = 145205, textKey = "GUIDE_TIP_036" },
			{ spell = 8921, textKey = "GUIDE_TIP_037" },
			{ spell = 102342, textKey = "GUIDE_TIP_038" },
			{ spell = 29166, textKey = "GUIDE_TIP_039" },
			{ spell = 132158, textKey = "GUIDE_TIP_040" },
		},
		stats = "GUIDE_STATS_DRUID_RESTO",
		gear = {
			"GUIDE_GEAR_DRUID_RESTO_1",
			"GUIDE_GEAR_DRUID_RESTO_2",
			"GUIDE_GEAR_DRUID_RESTO_3",
			"GUIDE_GEAR_DRUID_RESTO_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_RESTO_10_ROT_1",
					"GUIDE_ADVISOR_DRUID_RESTO_10_ROT_2",
					"GUIDE_ADVISOR_DRUID_RESTO_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_RESTO_10_DEF_1",
					"GUIDE_ADVISOR_DRUID_RESTO_10_DEF_2",
					"GUIDE_ADVISOR_DRUID_RESTO_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_RESTO_10_TAL_1",
					"GUIDE_ADVISOR_DRUID_RESTO_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_RESTO_30_ROT_1",
					"GUIDE_ADVISOR_DRUID_RESTO_30_ROT_2",
					"GUIDE_ADVISOR_DRUID_RESTO_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_RESTO_30_DEF_1",
					"GUIDE_ADVISOR_DRUID_RESTO_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_RESTO_30_TAL_1",
					"GUIDE_ADVISOR_DRUID_RESTO_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_RESTO_60_ROT_1",
					"GUIDE_ADVISOR_DRUID_RESTO_60_ROT_2",
					"GUIDE_ADVISOR_DRUID_RESTO_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_RESTO_60_DEF_1",
					"GUIDE_ADVISOR_DRUID_RESTO_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_RESTO_60_TAL_1",
					"GUIDE_ADVISOR_DRUID_RESTO_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_DRUID_RESTO_80_ROT_1",
					"GUIDE_ADVISOR_DRUID_RESTO_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_DRUID_RESTO_80_DEF_1",
					"GUIDE_ADVISOR_DRUID_RESTO_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DRUID_RESTO_80_TAL_1",
					"GUIDE_ADVISOR_DRUID_RESTO_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.05, 0.10, 0.14, 0.92 },
			topBar = { 0.10, 0.16, 0.22, 0.95 },
			titleColor = { 0.65, 0.88, 1.0 },
			sectionBar = { 0.12, 0.22, 0.30, 0.9 },
			sectionText = { 0.88, 0.94, 1.0 },
			icyBackdrop = { 0.05, 0.18, 0.24, 0.85 },
			icyBorder = { 0.35, 0.70, 0.95, 0.9 },
			icyTitleColor = { 0.70, 0.92, 1.0 },
			ebBg = { 0.06, 0.10, 0.14, 0.95 },
		},
	},
}

--[[ Death Knight — consumable IDs match Midnight Wowhead items we already use elsewhere (255845 feast, 241322/241326/241327 flasks, 241308 potion, etc.).
-- DK weapons use Runeforging — we intentionally omit `weaponOil` so the guide does not suggest a conflicting temp weapon coating next to runes.
--]]
-- Death Knight: 1 Blood, 2 Frost, 3 Unholy (retail).
ns.GuideData["DEATHKNIGHT"] = {
	[1] = {
		title = "Blood Death Knight Guide",
		icyTitle = "Icy Veins — Blood Death Knight leveling",
		link = "https://www.icy-veins.com/wow/blood-death-knight-leveling-guide",
		tips = {
			{ spell = 49998, textKey = "GUIDE_TIP_041" },
			{ spell = 206930, textKey = "GUIDE_TIP_042" },
			{ spell = 206931, textKey = "GUIDE_TIP_043" },
			{ spell = 43265, textKey = "GUIDE_TIP_044" },
			{ spell = 50842, textKey = "GUIDE_TIP_045" },
			{ spell = 49028, textKey = "GUIDE_TIP_046" },
			{ spell = 55233, textKey = "GUIDE_TIP_047" },
			{ spell = 48707, textKey = "GUIDE_TIP_048" },
			{ spell = 22156, textKey = "GUIDE_TIP_049" },
			{ spell = 49576, textKey = "GUIDE_TIP_050" },
		},
		stats = "GUIDE_STATS_DK_BLOOD",
		gear = {
			"GUIDE_GEAR_DK_BLOOD_1",
			"GUIDE_GEAR_DK_BLOOD_2",
			"GUIDE_GEAR_DK_BLOOD_3",
			"GUIDE_GEAR_DK_BLOOD_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222772, 242296 },
			flask = { 241326, 241322 },
			potion = { 191371, 241308 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_DK_BLOOD_10_ROT_1",
					"GUIDE_ADVISOR_DK_BLOOD_10_ROT_2",
					"GUIDE_ADVISOR_DK_BLOOD_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_BLOOD_10_DEF_1",
					"GUIDE_ADVISOR_DK_BLOOD_10_DEF_2",
					"GUIDE_ADVISOR_DK_BLOOD_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_BLOOD_10_TAL_1",
					"GUIDE_ADVISOR_DK_BLOOD_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_DK_BLOOD_30_ROT_1",
					"GUIDE_ADVISOR_DK_BLOOD_30_ROT_2",
					"GUIDE_ADVISOR_DK_BLOOD_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_BLOOD_30_DEF_1",
					"GUIDE_ADVISOR_DK_BLOOD_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_BLOOD_30_TAL_1",
					"GUIDE_ADVISOR_DK_BLOOD_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_DK_BLOOD_60_ROT_1",
					"GUIDE_ADVISOR_DK_BLOOD_60_ROT_2",
					"GUIDE_ADVISOR_DK_BLOOD_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_BLOOD_60_DEF_1",
					"GUIDE_ADVISOR_DK_BLOOD_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_BLOOD_60_TAL_1",
					"GUIDE_ADVISOR_DK_BLOOD_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_DK_BLOOD_80_ROT_1",
					"GUIDE_ADVISOR_DK_BLOOD_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_BLOOD_80_DEF_1",
					"GUIDE_ADVISOR_DK_BLOOD_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_BLOOD_80_TAL_1",
					"GUIDE_ADVISOR_DK_BLOOD_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.18, 0.05, 0.06, 0.92 },
			topBar = { 0.32, 0.10, 0.10, 0.95 },
			titleColor = { 1.0, 0.55, 0.48 },
			sectionBar = { 0.38, 0.12, 0.14, 0.9 },
			sectionText = { 1.0, 0.88, 0.86 },
			icyBackdrop = { 0.22, 0.08, 0.08, 0.85 },
			icyBorder = { 0.85, 0.30, 0.28, 0.9 },
			icyTitleColor = { 1.0, 0.65, 0.55 },
			ebBg = { 0.14, 0.06, 0.06, 0.95 },
		},
	},
	[2] = {
		title = "Frost Death Knight Guide",
		icyTitle = "Icy Veins — Frost Death Knight leveling",
		link = "https://www.icy-veins.com/wow/frost-death-knight-leveling-guide",
		tips = {
			{ spell = 49143, textKey = "GUIDE_TIP_051" },
			{ spell = 49184, textKey = "GUIDE_TIP_052" },
			{ spell = 49020, textKey = "GUIDE_TIP_053" },
			{ spell = 196770, textKey = "GUIDE_TIP_054" },
			{ spell = 51271, textKey = "GUIDE_TIP_055" },
			{ spell = 47568, textKey = "GUIDE_TIP_056" },
			{ spell = 45524, textKey = "GUIDE_TIP_057" },
			{ spell = 47528, textKey = "GUIDE_TIP_058" },
			{ spell = 49998, textKey = "GUIDE_TIP_059" },
		},
		stats = "GUIDE_STATS_DK_FROST",
		gear = {
			"GUIDE_GEAR_DK_FROST_1",
			"GUIDE_GEAR_DK_FROST_2",
			"GUIDE_GEAR_DK_FROST_3",
			"GUIDE_GEAR_DK_FROST_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222772, 242296 },
			flask = { 241322, 241326, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_DK_FROST_10_ROT_1",
					"GUIDE_ADVISOR_DK_FROST_10_ROT_2",
					"GUIDE_ADVISOR_DK_FROST_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_FROST_10_DEF_1",
					"GUIDE_ADVISOR_DK_FROST_10_DEF_2",
					"GUIDE_ADVISOR_DK_FROST_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_FROST_10_TAL_1",
					"GUIDE_ADVISOR_DK_FROST_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_DK_FROST_30_ROT_1",
					"GUIDE_ADVISOR_DK_FROST_30_ROT_2",
					"GUIDE_ADVISOR_DK_FROST_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_FROST_30_DEF_1",
					"GUIDE_ADVISOR_DK_FROST_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_FROST_30_TAL_1",
					"GUIDE_ADVISOR_DK_FROST_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_DK_FROST_60_ROT_1",
					"GUIDE_ADVISOR_DK_FROST_60_ROT_2",
					"GUIDE_ADVISOR_DK_FROST_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_FROST_60_DEF_1",
					"GUIDE_ADVISOR_DK_FROST_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_FROST_60_TAL_1",
					"GUIDE_ADVISOR_DK_FROST_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_DK_FROST_80_ROT_1",
					"GUIDE_ADVISOR_DK_FROST_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_FROST_80_DEF_1",
					"GUIDE_ADVISOR_DK_FROST_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_FROST_80_TAL_1",
					"GUIDE_ADVISOR_DK_FROST_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.04, 0.10, 0.20, 0.92 },
			topBar = { 0.08, 0.20, 0.38, 0.95 },
			titleColor = { 0.70, 0.88, 1.0 },
			sectionBar = { 0.12, 0.28, 0.45, 0.9 },
			sectionText = { 0.90, 0.95, 1.0 },
			icyBackdrop = { 0.06, 0.16, 0.30, 0.85 },
			icyBorder = { 0.40, 0.65, 0.95, 0.9 },
			icyTitleColor = { 0.75, 0.90, 1.0 },
			ebBg = { 0.06, 0.10, 0.18, 0.95 },
		},
	},
	[3] = {
		title = "Unholy Death Knight Guide",
		icyTitle = "Icy Veins — Unholy Death Knight leveling",
		link = "https://www.icy-veins.com/wow/unholy-death-knight-leveling-guide",
		tips = {
			{ spell = 77575, textKey = "GUIDE_TIP_060" },
			{ spell = 85948, textKey = "GUIDE_TIP_061" },
			{ spell = 55090, textKey = "GUIDE_TIP_062" },
			{ spell = 47541, textKey = "GUIDE_TIP_063" },
			{ spell = 275699, textKey = "GUIDE_TIP_064" },
			{ spell = 63560, textKey = "GUIDE_TIP_065" },
			{ spell = 42650, textKey = "GUIDE_TIP_066" },
			{ spell = 43265, textKey = "GUIDE_TIP_067" },
			{ spell = 48707, textKey = "GUIDE_TIP_068" },
		},
		stats = "GUIDE_STATS_DK_UNHOLY",
		gear = {
			"GUIDE_GEAR_DK_UNHOLY_1",
			"GUIDE_GEAR_DK_UNHOLY_2",
			"GUIDE_GEAR_DK_UNHOLY_3",
			"GUIDE_GEAR_DK_UNHOLY_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222772, 242296 },
			flask = { 241322, 241326, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_DK_UNHOLY_10_ROT_1",
					"GUIDE_ADVISOR_DK_UNHOLY_10_ROT_2",
					"GUIDE_ADVISOR_DK_UNHOLY_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_UNHOLY_10_DEF_1",
					"GUIDE_ADVISOR_DK_UNHOLY_10_DEF_2",
					"GUIDE_ADVISOR_DK_UNHOLY_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_UNHOLY_10_TAL_1",
					"GUIDE_ADVISOR_DK_UNHOLY_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_DK_UNHOLY_30_ROT_1",
					"GUIDE_ADVISOR_DK_UNHOLY_30_ROT_2",
					"GUIDE_ADVISOR_DK_UNHOLY_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_UNHOLY_30_DEF_1",
					"GUIDE_ADVISOR_DK_UNHOLY_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_UNHOLY_30_TAL_1",
					"GUIDE_ADVISOR_DK_UNHOLY_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_DK_UNHOLY_60_ROT_1",
					"GUIDE_ADVISOR_DK_UNHOLY_60_ROT_2",
					"GUIDE_ADVISOR_DK_UNHOLY_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_UNHOLY_60_DEF_1",
					"GUIDE_ADVISOR_DK_UNHOLY_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_UNHOLY_60_TAL_1",
					"GUIDE_ADVISOR_DK_UNHOLY_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_DK_UNHOLY_80_ROT_1",
					"GUIDE_ADVISOR_DK_UNHOLY_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_DK_UNHOLY_80_DEF_1",
					"GUIDE_ADVISOR_DK_UNHOLY_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DK_UNHOLY_80_TAL_1",
					"GUIDE_ADVISOR_DK_UNHOLY_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.06, 0.12, 0.06, 0.92 },
			topBar = { 0.10, 0.22, 0.10, 0.95 },
			titleColor = { 0.65, 0.95, 0.55 },
			sectionBar = { 0.16, 0.30, 0.14, 0.9 },
			sectionText = { 0.88, 0.95, 0.82 },
			icyBackdrop = { 0.08, 0.18, 0.10, 0.85 },
			icyBorder = { 0.40, 0.78, 0.35, 0.9 },
			icyTitleColor = { 0.60, 0.92, 0.50 },
			ebBg = { 0.08, 0.12, 0.08, 0.95 },
		},
	},
}

-- Demon Hunter: 1 Havoc, 2 Vengeance, 3 Devourer (retail). Key must match select(2, UnitClass("player")) == "DEMONHUNTER".
ns.GuideData["DEMONHUNTER"] = {
	[1] = {
		title = "Havoc Demon Hunter Guide",
		icyTitle = "Icy Veins — Havoc Demon Hunter leveling",
		link = "https://www.icy-veins.com/wow/havoc-demon-hunter-leveling-guide",
		tips = {
			{ spell = 162794, textKey = "GUIDE_TIP_069" },
			{ spell = 188499, textKey = "GUIDE_TIP_070" },
			{ spell = 198013, textKey = "GUIDE_TIP_071" },
			{ spell = 195072, textKey = "GUIDE_TIP_072" },
			{ spell = 198589, textKey = "GUIDE_TIP_073" },
			{ spell = 198793, textKey = "GUIDE_TIP_074" },
			{ spell = 191427, textKey = "GUIDE_TIP_075" },
			{ spell = 258920, textKey = "GUIDE_TIP_076" },
			{ spell = 183752, textKey = "GUIDE_TIP_077" },
			{ spell = 278326, textKey = "GUIDE_TIP_078" },
		},
		stats = "GUIDE_STATS_DH_HAVOC",
		gear = {
			"GUIDE_GEAR_DH_HAVOC_1",
			"GUIDE_GEAR_DH_HAVOC_2",
			"GUIDE_GEAR_DH_HAVOC_3",
			"GUIDE_GEAR_DH_HAVOC_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222710, 242296, 242285, 242281 },
			flask = { 241324, 241322, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_DH_HAVOC_10_ROT_1",
					"GUIDE_ADVISOR_DH_HAVOC_10_ROT_2",
					"GUIDE_ADVISOR_DH_HAVOC_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_HAVOC_10_DEF_1",
					"GUIDE_ADVISOR_DH_HAVOC_10_DEF_2",
					"GUIDE_ADVISOR_DH_HAVOC_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_HAVOC_10_TAL_1",
					"GUIDE_ADVISOR_DH_HAVOC_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_DH_HAVOC_30_ROT_1",
					"GUIDE_ADVISOR_DH_HAVOC_30_ROT_2",
					"GUIDE_ADVISOR_DH_HAVOC_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_HAVOC_30_DEF_1",
					"GUIDE_ADVISOR_DH_HAVOC_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_HAVOC_30_TAL_1",
					"GUIDE_ADVISOR_DH_HAVOC_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_DH_HAVOC_60_ROT_1",
					"GUIDE_ADVISOR_DH_HAVOC_60_ROT_2",
					"GUIDE_ADVISOR_DH_HAVOC_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_HAVOC_60_DEF_1",
					"GUIDE_ADVISOR_DH_HAVOC_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_HAVOC_60_TAL_1",
					"GUIDE_ADVISOR_DH_HAVOC_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_DH_HAVOC_80_ROT_1",
					"GUIDE_ADVISOR_DH_HAVOC_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_HAVOC_80_DEF_1",
					"GUIDE_ADVISOR_DH_HAVOC_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_HAVOC_80_TAL_1",
					"GUIDE_ADVISOR_DH_HAVOC_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.12, 0.06, 0.18, 0.92 },
			topBar = { 0.22, 0.10, 0.32, 0.95 },
			titleColor = { 0.85, 0.55, 1.0 },
			sectionBar = { 0.30, 0.14, 0.38, 0.9 },
			sectionText = { 0.92, 0.82, 1.0 },
			icyBackdrop = { 0.14, 0.08, 0.22, 0.85 },
			icyBorder = { 0.55, 0.30, 0.85, 0.9 },
			icyTitleColor = { 0.88, 0.70, 1.0 },
			ebBg = { 0.10, 0.06, 0.14, 0.95 },
		},
	},
	[2] = {
		title = "Vengeance Demon Hunter Guide",
		icyTitle = "Icy Veins — Vengeance Demon Hunter leveling",
		link = "https://www.icy-veins.com/wow/vengeance-demon-hunter-leveling-guide",
		tips = {
			{ spell = 207407, textKey = "GUIDE_TIP_079" },
			{ spell = 203720, textKey = "GUIDE_TIP_080" },
			{ spell = 258920, textKey = "GUIDE_TIP_081" },
			{ spell = 212084, textKey = "GUIDE_TIP_082" },
			{ spell = 204596, textKey = "GUIDE_TIP_083" },
			{ spell = 189110, textKey = "GUIDE_TIP_084" },
			{ spell = 247454, textKey = "GUIDE_TIP_085" },
			{ spell = 202137, textKey = "GUIDE_TIP_086" },
			{ spell = 187827, textKey = "GUIDE_TIP_087" },
			{ spell = 204157, textKey = "GUIDE_TIP_088" },
		},
		stats = "GUIDE_STATS_DH_VENGEANCE",
		gear = {
			"GUIDE_GEAR_DH_VENGEANCE_1",
			"GUIDE_GEAR_DH_VENGEANCE_2",
			"GUIDE_GEAR_DH_VENGEANCE_3",
			"GUIDE_GEAR_DH_VENGEANCE_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222710, 242296 },
			flask = { 241324, 241322 },
			potion = { 191371, 241308 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_DH_VENGEANCE_10_ROT_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_10_ROT_2",
					"GUIDE_ADVISOR_DH_VENGEANCE_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_VENGEANCE_10_DEF_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_10_DEF_2",
					"GUIDE_ADVISOR_DH_VENGEANCE_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_VENGEANCE_10_TAL_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_DH_VENGEANCE_30_ROT_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_30_ROT_2",
					"GUIDE_ADVISOR_DH_VENGEANCE_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_VENGEANCE_30_DEF_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_VENGEANCE_30_TAL_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_DH_VENGEANCE_60_ROT_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_60_ROT_2",
					"GUIDE_ADVISOR_DH_VENGEANCE_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_VENGEANCE_60_DEF_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_VENGEANCE_60_TAL_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_DH_VENGEANCE_80_ROT_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_VENGEANCE_80_DEF_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_VENGEANCE_80_TAL_1",
					"GUIDE_ADVISOR_DH_VENGEANCE_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.10, 0.06, 0.12, 0.92 },
			topBar = { 0.28, 0.12, 0.18, 0.95 },
			titleColor = { 0.75, 0.45, 0.95 },
			sectionBar = { 0.32, 0.16, 0.22, 0.9 },
			sectionText = { 0.92, 0.82, 0.95 },
			icyBackdrop = { 0.16, 0.08, 0.12, 0.85 },
			icyBorder = { 0.65, 0.35, 0.45, 0.9 },
			icyTitleColor = { 0.90, 0.65, 0.80 },
			ebBg = { 0.12, 0.06, 0.10, 0.95 },
		},
	},
	[3] = {
		title = "Devourer Demon Hunter Guide",
		icyTitle = "Icy Veins — Devourer Demon Hunter leveling",
		link = "https://www.icy-veins.com/wow/demon-hunter-leveling-guide",
		tips = {
			{ spell = 205448, textKey = "GUIDE_TIP_089" },
			{ spell = 228556, textKey = "GUIDE_TIP_090" },
			{ spell = 396368, textKey = "GUIDE_TIP_091" },
			{ spell = 191427, textKey = "GUIDE_TIP_092" },
			{ spell = 179057, textKey = "GUIDE_TIP_093" },
			{ spell = 188501, textKey = "GUIDE_TIP_094" },
			{ spell = 217832, textKey = "GUIDE_TIP_095" },
			{ spell = 196555, textKey = "GUIDE_TIP_096" },
			{ spell = 202137, textKey = "GUIDE_TIP_097" },
			{ spell = 342817, textKey = "GUIDE_TIP_098" },
		},
		stats = "GUIDE_STATS_DH_DEVOURER",
		gear = {
			"GUIDE_GEAR_DH_DEVOURER_1",
			"GUIDE_GEAR_DH_DEVOURER_2",
			"GUIDE_GEAR_DH_DEVOURER_3",
			"GUIDE_GEAR_DH_DEVOURER_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_DH_DEVOURER_10_ROT_1",
					"GUIDE_ADVISOR_DH_DEVOURER_10_ROT_2",
					"GUIDE_ADVISOR_DH_DEVOURER_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_DEVOURER_10_DEF_1",
					"GUIDE_ADVISOR_DH_DEVOURER_10_DEF_2",
					"GUIDE_ADVISOR_DH_DEVOURER_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_DEVOURER_10_TAL_1",
					"GUIDE_ADVISOR_DH_DEVOURER_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_DH_DEVOURER_30_ROT_1",
					"GUIDE_ADVISOR_DH_DEVOURER_30_ROT_2",
					"GUIDE_ADVISOR_DH_DEVOURER_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_DEVOURER_30_DEF_1",
					"GUIDE_ADVISOR_DH_DEVOURER_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_DEVOURER_30_TAL_1",
					"GUIDE_ADVISOR_DH_DEVOURER_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_DH_DEVOURER_60_ROT_1",
					"GUIDE_ADVISOR_DH_DEVOURER_60_ROT_2",
					"GUIDE_ADVISOR_DH_DEVOURER_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_DEVOURER_60_DEF_1",
					"GUIDE_ADVISOR_DH_DEVOURER_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_DEVOURER_60_TAL_1",
					"GUIDE_ADVISOR_DH_DEVOURER_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_DH_DEVOURER_80_ROT_1",
					"GUIDE_ADVISOR_DH_DEVOURER_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_DH_DEVOURER_80_DEF_1",
					"GUIDE_ADVISOR_DH_DEVOURER_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_DH_DEVOURER_80_TAL_1",
					"GUIDE_ADVISOR_DH_DEVOURER_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.10, 0.07, 0.18, 0.92 },
			topBar = { 0.20, 0.12, 0.36, 0.95 },
			titleColor = { 0.86, 0.70, 1.0 },
			sectionBar = { 0.28, 0.16, 0.42, 0.9 },
			sectionText = { 0.92, 0.88, 1.0 },
			icyBackdrop = { 0.12, 0.10, 0.24, 0.85 },
			icyBorder = { 0.50, 0.40, 0.90, 0.9 },
			icyTitleColor = { 0.82, 0.76, 1.0 },
			ebBg = { 0.10, 0.08, 0.16, 0.95 },
		},
	},
}

-- Evoker: 1 Devastation, 2 Preservation, 3 Augmentation (retail).
ns.GuideData["EVOKER"] = {
	[1] = {
		title = "Devastation Evoker Guide",
		icyTitle = "Icy Veins — Devastation Evoker leveling",
		link = "https://www.icy-veins.com/wow/devastation-evoker-leveling-guide",
		tips = {
			{ spell = 356995, textKey = "GUIDE_TIP_099" },
			{ spell = 357212, textKey = "GUIDE_TIP_100" },
			{ spell = 382266, textKey = "GUIDE_TIP_101" },
			{ spell = 359077, textKey = "GUIDE_TIP_102" },
			{ spell = 361469, textKey = "GUIDE_TIP_103" },
			{ spell = 358267, textKey = "GUIDE_TIP_104" },
			{ spell = 375087, textKey = "GUIDE_TIP_105" },
			{ spell = 363916, textKey = "GUIDE_TIP_106" },
			{ spell = 351338, textKey = "GUIDE_TIP_107" },
			{ spell = 358385, textKey = "GUIDE_TIP_108" },
		},
		stats = "GUIDE_STATS_EVOKER_DEVASTATION",
		gear = {
			"GUIDE_GEAR_EVOKER_DEVASTATION_1",
			"GUIDE_GEAR_EVOKER_DEVASTATION_2",
			"GUIDE_GEAR_EVOKER_DEVASTATION_3",
			"GUIDE_GEAR_EVOKER_DEVASTATION_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_10_ROT_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_10_ROT_2",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_10_DEF_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_10_DEF_2",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_10_TAL_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_30_ROT_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_30_ROT_2",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_30_DEF_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_30_TAL_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_60_ROT_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_60_ROT_2",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_60_DEF_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_60_TAL_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_80_ROT_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_80_DEF_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_80_TAL_1",
					"GUIDE_ADVISOR_EVOKER_DEVASTATION_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.14, 0.06, 0.06, 0.92 },
			topBar = { 0.30, 0.12, 0.10, 0.95 },
			titleColor = { 1.0, 0.65, 0.45 },
			sectionBar = { 0.36, 0.16, 0.12, 0.9 },
			sectionText = { 1.0, 0.88, 0.78 },
			icyBackdrop = { 0.20, 0.08, 0.06, 0.85 },
			icyBorder = { 0.90, 0.40, 0.22, 0.9 },
			icyTitleColor = { 1.0, 0.72, 0.50 },
			ebBg = { 0.14, 0.06, 0.06, 0.95 },
		},
	},
	[2] = {
		title = "Preservation Evoker Guide",
		icyTitle = "Icy Veins — Preservation Evoker leveling",
		link = "https://www.icy-veins.com/wow/preservation-evoker-leveling-guide",
		tips = {
			{ spell = 364343, textKey = "GUIDE_TIP_109" },
			{ spell = 355936, textKey = "GUIDE_TIP_110" },
			{ spell = 382445, textKey = "GUIDE_TIP_111" },
			{ spell = 366155, textKey = "GUIDE_TIP_112" },
			{ spell = 360995, textKey = "GUIDE_TIP_113" },
			{ spell = 363534, textKey = "GUIDE_TIP_114" },
			{ spell = 373861, textKey = "GUIDE_TIP_115" },
			{ spell = 359816, textKey = "GUIDE_TIP_116" },
			{ spell = 355916, textKey = "GUIDE_TIP_117" },
			{ spell = 370537, textKey = "GUIDE_TIP_118" },
		},
		stats = "GUIDE_STATS_EVOKER_PRESERVATION",
		gear = {
			"GUIDE_GEAR_EVOKER_PRESERVATION_1",
			"GUIDE_GEAR_EVOKER_PRESERVATION_2",
			"GUIDE_GEAR_EVOKER_PRESERVATION_3",
			"GUIDE_GEAR_EVOKER_PRESERVATION_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_10_ROT_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_10_ROT_2",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_10_DEF_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_10_DEF_2",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_10_TAL_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_30_ROT_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_30_ROT_2",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_30_DEF_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_30_TAL_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_60_ROT_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_60_ROT_2",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_60_DEF_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_60_TAL_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_80_ROT_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_80_DEF_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_80_TAL_1",
					"GUIDE_ADVISOR_EVOKER_PRESERVATION_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.05, 0.12, 0.10, 0.92 },
			topBar = { 0.10, 0.22, 0.16, 0.95 },
			titleColor = { 0.55, 0.95, 0.75 },
			sectionBar = { 0.12, 0.28, 0.22, 0.9 },
			sectionText = { 0.85, 0.96, 0.90 },
			icyBackdrop = { 0.06, 0.18, 0.14, 0.85 },
			icyBorder = { 0.30, 0.85, 0.55, 0.9 },
			icyTitleColor = { 0.60, 0.95, 0.78 },
			ebBg = { 0.06, 0.10, 0.12, 0.95 },
		},
	},
	[3] = {
		title = "Augmentation Evoker Guide",
		icyTitle = "Icy Veins — Augmentation Evoker leveling",
		link = "https://www.icy-veins.com/wow/augmentation-evoker-leveling-guide",
		tips = {
			{ spell = 395152, textKey = "GUIDE_TIP_119" },
			{ spell = 396286, textKey = "GUIDE_TIP_120" },
			{ spell = 403631, textKey = "GUIDE_TIP_121" },
			{ spell = 360827, textKey = "GUIDE_TIP_122" },
			{ spell = 409311, textKey = "GUIDE_TIP_123" },
			{ spell = 395160, textKey = "GUIDE_TIP_124" },
			{ spell = 369459, textKey = "GUIDE_TIP_125" },
			{ spell = 406732, textKey = "GUIDE_TIP_126" },
			{ spell = 370665, textKey = "GUIDE_TIP_127" },
			{ spell = 358385, textKey = "GUIDE_TIP_128" },
		},
		stats = "GUIDE_STATS_EVOKER_AUGMENTATION",
		gear = {
			"GUIDE_GEAR_EVOKER_AUGMENTATION_1",
			"GUIDE_GEAR_EVOKER_AUGMENTATION_2",
			"GUIDE_GEAR_EVOKER_AUGMENTATION_3",
			"GUIDE_GEAR_EVOKER_AUGMENTATION_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_10_ROT_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_10_ROT_2",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_10_DEF_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_10_DEF_2",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_10_TAL_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_30_ROT_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_30_ROT_2",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_30_DEF_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_30_TAL_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_60_ROT_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_60_ROT_2",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_60_DEF_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_60_TAL_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_80_ROT_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_80_DEF_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_80_TAL_1",
					"GUIDE_ADVISOR_EVOKER_AUGMENTATION_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.08, 0.10, 0.16, 0.92 },
			topBar = { 0.14, 0.18, 0.32, 0.95 },
			titleColor = { 0.72, 0.82, 1.0 },
			sectionBar = { 0.18, 0.24, 0.38, 0.9 },
			sectionText = { 0.88, 0.92, 1.0 },
			icyBackdrop = { 0.10, 0.14, 0.26, 0.85 },
			icyBorder = { 0.45, 0.55, 0.92, 0.9 },
			icyTitleColor = { 0.75, 0.85, 1.0 },
			ebBg = { 0.08, 0.10, 0.16, 0.95 },
		},
	},
}

--[[ Hunter consumables — IDs hand-verified against Wowhead (item pages / PTR slugs), not LLM output.
-- Feast: 255845 https://www.wowhead.com/item=255845/silvermoon-parade — 255846 Harandar Celebration (feast alt).
-- Food: 242285 warped-wise-wings, 242281 glitter-skewers, 242296 bloodthistle-wrapped-cutlets, 242309 farstrider-rations
-- Flask: 241322 flask-of-the-magisters (Mastery) — 241327 flask-of-the-shattered-sun (Crit) — 241324 flask-of-the-blood-knights (Agility)
-- Potions: 241308 lights-potential — 241289 potion-of-recklessness
-- Oil: 243734 thalassian-phoenix-oil (alt id 243733 on some builds)
-- Rune: 259085 void-touched-augment-rune
-- Defaults in Guide.lua: healing 211878/211880.
-- We did not find separate Wowhead item pages for exact names "Sun-Dried Berries" or "Flask of the Solar Eclipse" (SV) — keep SV on haste-leaning food order + same flask pool until a real item= link exists.
--]]
-- Hunter: 1 Beast Mastery, 2 Marksmanship, 3 Survival (retail). Key must match select(2, UnitClass("player")) == "HUNTER".
ns.GuideData["HUNTER"] = {
	[1] = {
		title = "Beast Mastery Hunter Guide",
		icyTitle = "Icy Veins — Beast Mastery Hunter leveling",
		link = "https://www.icy-veins.com/wow/beast-mastery-hunter-leveling-guide",
		tips = {
			{ spell = 34026, textKey = "GUIDE_TIP_129" },
			{ spell = 217200, textKey = "GUIDE_TIP_130" },
			{ spell = 19574, textKey = "GUIDE_TIP_131" },
			{ spell = 53351, textKey = "GUIDE_TIP_132" },
			{ spell = 2643, textKey = "GUIDE_TIP_133" },
			{ spell = 109304, textKey = "GUIDE_TIP_134" },
			{ spell = 186265, textKey = "GUIDE_TIP_135" },
			{ spell = 147362, textKey = "GUIDE_TIP_136" },
			{ spell = 34477, textKey = "GUIDE_TIP_137" },
			{ spell = 136, textKey = "GUIDE_TIP_138" },
		},
		stats = "GUIDE_STATS_HUNTER_BM",
		gear = {
			"GUIDE_GEAR_HUNTER_BM_1",
			"GUIDE_GEAR_HUNTER_BM_2",
			"GUIDE_GEAR_HUNTER_BM_3",
			"GUIDE_GEAR_HUNTER_BM_4",
		},
		consumables = {
			feast = { 255845, 255846 }, -- Silvermoon Parade / Harandar Celebration
			food = { 242285, 242281, 242296, 242309 }, -- Mastery-first + mixed stat alternatives (Midnight 12.0.x)
			flask = { 241322, 241327, 241324 }, -- Magisters / Crit / Agility (priority order)
			potion = { 241308, 241289 }, -- Light's Potential / Recklessness
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_BM_10_ROT_1",
					"GUIDE_ADVISOR_HUNTER_BM_10_ROT_2",
					"GUIDE_ADVISOR_HUNTER_BM_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_BM_10_DEF_1",
					"GUIDE_ADVISOR_HUNTER_BM_10_DEF_2",
					"GUIDE_ADVISOR_HUNTER_BM_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_BM_10_TAL_1",
					"GUIDE_ADVISOR_HUNTER_BM_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_BM_30_ROT_1",
					"GUIDE_ADVISOR_HUNTER_BM_30_ROT_2",
					"GUIDE_ADVISOR_HUNTER_BM_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_BM_30_DEF_1",
					"GUIDE_ADVISOR_HUNTER_BM_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_BM_30_TAL_1",
					"GUIDE_ADVISOR_HUNTER_BM_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_BM_60_ROT_1",
					"GUIDE_ADVISOR_HUNTER_BM_60_ROT_2",
					"GUIDE_ADVISOR_HUNTER_BM_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_BM_60_DEF_1",
					"GUIDE_ADVISOR_HUNTER_BM_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_BM_60_TAL_1",
					"GUIDE_ADVISOR_HUNTER_BM_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_BM_80_ROT_1",
					"GUIDE_ADVISOR_HUNTER_BM_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_BM_80_DEF_1",
					"GUIDE_ADVISOR_HUNTER_BM_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_BM_80_TAL_1",
					"GUIDE_ADVISOR_HUNTER_BM_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.08, 0.10, 0.06, 0.92 },
			topBar = { 0.16, 0.20, 0.10, 0.95 },
			titleColor = { 0.85, 0.95, 0.55 },
			sectionBar = { 0.22, 0.28, 0.14, 0.9 },
			sectionText = { 0.92, 0.95, 0.82 },
			icyBackdrop = { 0.10, 0.16, 0.08, 0.85 },
			icyBorder = { 0.45, 0.75, 0.30, 0.9 },
			icyTitleColor = { 0.80, 0.95, 0.60 },
			ebBg = { 0.08, 0.10, 0.08, 0.95 },
		},
	},
	[2] = {
		title = "Marksmanship Hunter Guide",
		icyTitle = "Icy Veins — Marksmanship Hunter leveling",
		link = "https://www.icy-veins.com/wow/marksmanship-hunter-leveling-guide",
		tips = {
			{ spell = 19434, textKey = "GUIDE_TIP_139" },
			{ spell = 257044, textKey = "GUIDE_TIP_140" },
			{ spell = 185358, textKey = "GUIDE_TIP_141" },
			{ spell = 288613, textKey = "GUIDE_TIP_142" },
			{ spell = 2643, textKey = "GUIDE_TIP_143" },
			{ spell = 186257, textKey = "GUIDE_TIP_144" },
			{ spell = 352992, textKey = "GUIDE_TIP_145" },
			{ spell = 187650, textKey = "GUIDE_TIP_146" },
			{ spell = 186265, textKey = "GUIDE_TIP_147" },
			{ spell = 5384, textKey = "GUIDE_TIP_148" },
		},
		stats = "GUIDE_STATS_HUNTER_MM",
		gear = {
			"GUIDE_GEAR_HUNTER_MM_1",
			"GUIDE_GEAR_HUNTER_MM_2",
			"GUIDE_GEAR_HUNTER_MM_3",
			"GUIDE_GEAR_HUNTER_MM_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242281, 242285, 242296, 242309 }, -- Same pool as BM; slightly Crit-skewed ordering (MM)
			flask = { 241322, 241327, 241324 }, -- Usually Magisters; Crit flask next when tuning gear
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_MM_10_ROT_1",
					"GUIDE_ADVISOR_HUNTER_MM_10_ROT_2",
					"GUIDE_ADVISOR_HUNTER_MM_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_MM_10_DEF_1",
					"GUIDE_ADVISOR_HUNTER_MM_10_DEF_2",
					"GUIDE_ADVISOR_HUNTER_MM_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_MM_10_TAL_1",
					"GUIDE_ADVISOR_HUNTER_MM_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_MM_30_ROT_1",
					"GUIDE_ADVISOR_HUNTER_MM_30_ROT_2",
					"GUIDE_ADVISOR_HUNTER_MM_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_MM_30_DEF_1",
					"GUIDE_ADVISOR_HUNTER_MM_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_MM_30_TAL_1",
					"GUIDE_ADVISOR_HUNTER_MM_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_MM_60_ROT_1",
					"GUIDE_ADVISOR_HUNTER_MM_60_ROT_2",
					"GUIDE_ADVISOR_HUNTER_MM_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_MM_60_DEF_1",
					"GUIDE_ADVISOR_HUNTER_MM_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_MM_60_TAL_1",
					"GUIDE_ADVISOR_HUNTER_MM_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_MM_80_ROT_1",
					"GUIDE_ADVISOR_HUNTER_MM_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_MM_80_DEF_1",
					"GUIDE_ADVISOR_HUNTER_MM_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_MM_80_TAL_1",
					"GUIDE_ADVISOR_HUNTER_MM_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.06, 0.10, 0.14, 0.92 },
			topBar = { 0.10, 0.16, 0.26, 0.95 },
			titleColor = { 0.65, 0.82, 1.0 },
			sectionBar = { 0.14, 0.22, 0.34, 0.9 },
			sectionText = { 0.88, 0.92, 1.0 },
			icyBackdrop = { 0.08, 0.14, 0.22, 0.85 },
			icyBorder = { 0.35, 0.55, 0.90, 0.9 },
			icyTitleColor = { 0.70, 0.85, 1.0 },
			ebBg = { 0.06, 0.10, 0.14, 0.95 },
		},
	},
	[3] = {
		title = "Survival Hunter Guide",
		icyTitle = "Icy Veins — Survival Hunter leveling",
		link = "https://www.icy-veins.com/wow/survival-hunter-leveling-guide",
		tips = {
			{ spell = 34026, textKey = "GUIDE_TIP_149" },
			{ spell = 259495, textKey = "GUIDE_TIP_150" },
			{ spell = 259387, textKey = "GUIDE_TIP_151" },
			{ spell = 259491, textKey = "GUIDE_TIP_152" },
			{ spell = 266779, textKey = "GUIDE_TIP_153" },
			{ spell = 190925, textKey = "GUIDE_TIP_154" },
			{ spell = 203415, textKey = "GUIDE_TIP_155" },
			{ spell = 186265, textKey = "GUIDE_TIP_156" },
			{ spell = 19577, textKey = "GUIDE_TIP_157" },
			{ spell = 781, textKey = "GUIDE_TIP_158" },
		},
		stats = "GUIDE_STATS_HUNTER_SURV",
		gear = {
			"GUIDE_GEAR_HUNTER_SURV_1",
			"GUIDE_GEAR_HUNTER_SURV_2",
			"GUIDE_GEAR_HUNTER_SURV_3",
			"GUIDE_GEAR_HUNTER_SURV_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242309, 242296, 242285, 242281 }, -- Haste-leaning order (confirm buff text in-game); no verified "Sun-Dried Berries" item page located
			flask = { 241322, 241327, 241324 }, -- No verified standalone "Solar Eclipse" flask ID found on Wowhead; same tier flasks as BM/MM
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_SURV_10_ROT_1",
					"GUIDE_ADVISOR_HUNTER_SURV_10_ROT_2",
					"GUIDE_ADVISOR_HUNTER_SURV_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_SURV_10_DEF_1",
					"GUIDE_ADVISOR_HUNTER_SURV_10_DEF_2",
					"GUIDE_ADVISOR_HUNTER_SURV_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_SURV_10_TAL_1",
					"GUIDE_ADVISOR_HUNTER_SURV_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_SURV_30_ROT_1",
					"GUIDE_ADVISOR_HUNTER_SURV_30_ROT_2",
					"GUIDE_ADVISOR_HUNTER_SURV_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_SURV_30_DEF_1",
					"GUIDE_ADVISOR_HUNTER_SURV_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_SURV_30_TAL_1",
					"GUIDE_ADVISOR_HUNTER_SURV_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_SURV_60_ROT_1",
					"GUIDE_ADVISOR_HUNTER_SURV_60_ROT_2",
					"GUIDE_ADVISOR_HUNTER_SURV_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_SURV_60_DEF_1",
					"GUIDE_ADVISOR_HUNTER_SURV_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_SURV_60_TAL_1",
					"GUIDE_ADVISOR_HUNTER_SURV_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_HUNTER_SURV_80_ROT_1",
					"GUIDE_ADVISOR_HUNTER_SURV_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_HUNTER_SURV_80_DEF_1",
					"GUIDE_ADVISOR_HUNTER_SURV_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_HUNTER_SURV_80_TAL_1",
					"GUIDE_ADVISOR_HUNTER_SURV_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.12, 0.08, 0.05, 0.92 },
			topBar = { 0.26, 0.14, 0.08, 0.95 },
			titleColor = { 1.0, 0.72, 0.42 },
			sectionBar = { 0.32, 0.18, 0.10, 0.9 },
			sectionText = { 1.0, 0.90, 0.78 },
			icyBackdrop = { 0.18, 0.10, 0.06, 0.85 },
			icyBorder = { 0.90, 0.50, 0.22, 0.9 },
			icyTitleColor = { 1.0, 0.78, 0.48 },
			ebBg = { 0.12, 0.08, 0.06, 0.95 },
		},
	},
}

-- Mage: 1 Arcane, 2 Fire, 3 Frost (retail). Key must match select(2, UnitClass("player")) == "MAGE".
ns.GuideData["MAGE"] = {
	[1] = {
		title = "Arcane Mage Guide",
		icyTitle = "Icy Veins — Arcane Mage leveling",
		link = "https://www.icy-veins.com/wow/arcane-mage-leveling-guide",
		tips = {
			{ spell = 30451, textKey = "GUIDE_TIP_159" },
			{ spell = 5143, textKey = "GUIDE_TIP_160" },
			{ spell = 44425, textKey = "GUIDE_TIP_161" },
			{ spell = 12051, textKey = "GUIDE_TIP_162" },
			{ spell = 110909, textKey = "GUIDE_TIP_163" },
			{ spell = 365350, textKey = "GUIDE_TIP_164" },
			{ spell = 55342, textKey = "GUIDE_TIP_165" },
			{ spell = 31589, textKey = "GUIDE_TIP_166" },
			{ spell = 2139, textKey = "GUIDE_TIP_167" },
			{ spell = 1459, textKey = "GUIDE_TIP_168" },
		},
		stats = "GUIDE_STATS_MAGE_ARCANE",
		gear = {
			"GUIDE_GEAR_MAGE_ARCANE_1",
			"GUIDE_GEAR_MAGE_ARCANE_2",
			"GUIDE_GEAR_MAGE_ARCANE_3",
			"GUIDE_GEAR_MAGE_ARCANE_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_ARCANE_10_ROT_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_10_ROT_2",
					"GUIDE_ADVISOR_MAGE_ARCANE_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_ARCANE_10_DEF_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_10_DEF_2",
					"GUIDE_ADVISOR_MAGE_ARCANE_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_ARCANE_10_TAL_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_ARCANE_30_ROT_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_30_ROT_2",
					"GUIDE_ADVISOR_MAGE_ARCANE_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_ARCANE_30_DEF_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_ARCANE_30_TAL_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_ARCANE_60_ROT_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_60_ROT_2",
					"GUIDE_ADVISOR_MAGE_ARCANE_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_ARCANE_60_DEF_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_ARCANE_60_TAL_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_ARCANE_80_ROT_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_ARCANE_80_DEF_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_ARCANE_80_TAL_1",
					"GUIDE_ADVISOR_MAGE_ARCANE_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.16, 0.08, 0.26, 0.92 },
			topBar = { 0.28, 0.14, 0.42, 0.95 },
			titleColor = { 0.82, 0.65, 1.0 },
			sectionBar = { 0.34, 0.18, 0.52, 0.9 },
			sectionText = { 0.92, 0.86, 1.0 },
			icyBackdrop = { 0.14, 0.10, 0.24, 0.85 },
			icyBorder = { 0.55, 0.35, 0.92, 0.9 },
			icyTitleColor = { 0.85, 0.72, 1.0 },
			ebBg = { 0.12, 0.08, 0.20, 0.95 },
		},
	},
	[2] = {
		title = "Fire Mage Guide",
		icyTitle = "Icy Veins — Fire Mage leveling",
		link = "https://www.icy-veins.com/wow/fire-mage-leveling-guide",
		tips = {
			{ spell = 133, textKey = "GUIDE_TIP_169" },
			{ spell = 108853, textKey = "GUIDE_TIP_170" },
			{ spell = 11366, textKey = "GUIDE_TIP_171" },
			{ spell = 190319, textKey = "GUIDE_TIP_172" },
			{ spell = 2120, textKey = "GUIDE_TIP_173" },
			{ spell = 31661, textKey = "GUIDE_TIP_174" },
			{ spell = 257541, textKey = "GUIDE_TIP_175" },
			{ spell = 2948, textKey = "GUIDE_TIP_176" },
			{ spell = 2139, textKey = "GUIDE_TIP_177" },
			{ spell = 235313, textKey = "GUIDE_TIP_178" },
		},
		stats = "GUIDE_STATS_MAGE_FIRE",
		gear = {
			"GUIDE_GEAR_MAGE_FIRE_1",
			"GUIDE_GEAR_MAGE_FIRE_2",
			"GUIDE_GEAR_MAGE_FIRE_3",
			"GUIDE_GEAR_MAGE_FIRE_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_FIRE_10_ROT_1",
					"GUIDE_ADVISOR_MAGE_FIRE_10_ROT_2",
					"GUIDE_ADVISOR_MAGE_FIRE_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_FIRE_10_DEF_1",
					"GUIDE_ADVISOR_MAGE_FIRE_10_DEF_2",
					"GUIDE_ADVISOR_MAGE_FIRE_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_FIRE_10_TAL_1",
					"GUIDE_ADVISOR_MAGE_FIRE_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_FIRE_30_ROT_1",
					"GUIDE_ADVISOR_MAGE_FIRE_30_ROT_2",
					"GUIDE_ADVISOR_MAGE_FIRE_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_FIRE_30_DEF_1",
					"GUIDE_ADVISOR_MAGE_FIRE_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_FIRE_30_TAL_1",
					"GUIDE_ADVISOR_MAGE_FIRE_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_FIRE_60_ROT_1",
					"GUIDE_ADVISOR_MAGE_FIRE_60_ROT_2",
					"GUIDE_ADVISOR_MAGE_FIRE_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_FIRE_60_DEF_1",
					"GUIDE_ADVISOR_MAGE_FIRE_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_FIRE_60_TAL_1",
					"GUIDE_ADVISOR_MAGE_FIRE_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_FIRE_80_ROT_1",
					"GUIDE_ADVISOR_MAGE_FIRE_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_FIRE_80_DEF_1",
					"GUIDE_ADVISOR_MAGE_FIRE_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_FIRE_80_TAL_1",
					"GUIDE_ADVISOR_MAGE_FIRE_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.18, 0.06, 0.04, 0.92 },
			topBar = { 0.42, 0.12, 0.08, 0.95 },
			titleColor = { 1.0, 0.55, 0.42 },
			sectionBar = { 0.48, 0.16, 0.10, 0.9 },
			sectionText = { 1.0, 0.88, 0.78 },
			icyBackdrop = { 0.22, 0.08, 0.06, 0.85 },
			icyBorder = { 0.92, 0.40, 0.22, 0.9 },
			icyTitleColor = { 1.0, 0.65, 0.45 },
			ebBg = { 0.16, 0.06, 0.04, 0.95 },
		},
	},
	[3] = {
		title = "Frost Mage Guide",
		icyTitle = "Icy Veins — Frost Mage leveling",
		link = "https://www.icy-veins.com/wow/frost-mage-leveling-guide",
		tips = {
			{ spell = 116, textKey = "GUIDE_TIP_179" },
			{ spell = 44614, textKey = "GUIDE_TIP_180" },
			{ spell = 30455, textKey = "GUIDE_TIP_181" },
			{ spell = 84714, textKey = "GUIDE_TIP_182" },
			{ spell = 45438, textKey = "GUIDE_TIP_183" },
			{ spell = 31687, textKey = "GUIDE_TIP_184" },
			{ spell = 12472, textKey = "GUIDE_TIP_185" },
			{ spell = 120, textKey = "GUIDE_TIP_186" },
			{ spell = 2139, textKey = "GUIDE_TIP_187" },
			{ spell = 11426, textKey = "GUIDE_TIP_188" },
		},
		stats = "GUIDE_STATS_MAGE_FROST",
		gear = {
			"GUIDE_GEAR_MAGE_FROST_1",
			"GUIDE_GEAR_MAGE_FROST_2",
			"GUIDE_GEAR_MAGE_FROST_3",
			"GUIDE_GEAR_MAGE_FROST_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_FROST_10_ROT_1",
					"GUIDE_ADVISOR_MAGE_FROST_10_ROT_2",
					"GUIDE_ADVISOR_MAGE_FROST_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_FROST_10_DEF_1",
					"GUIDE_ADVISOR_MAGE_FROST_10_DEF_2",
					"GUIDE_ADVISOR_MAGE_FROST_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_FROST_10_TAL_1",
					"GUIDE_ADVISOR_MAGE_FROST_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_FROST_30_ROT_1",
					"GUIDE_ADVISOR_MAGE_FROST_30_ROT_2",
					"GUIDE_ADVISOR_MAGE_FROST_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_FROST_30_DEF_1",
					"GUIDE_ADVISOR_MAGE_FROST_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_FROST_30_TAL_1",
					"GUIDE_ADVISOR_MAGE_FROST_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_FROST_60_ROT_1",
					"GUIDE_ADVISOR_MAGE_FROST_60_ROT_2",
					"GUIDE_ADVISOR_MAGE_FROST_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_FROST_60_DEF_1",
					"GUIDE_ADVISOR_MAGE_FROST_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_FROST_60_TAL_1",
					"GUIDE_ADVISOR_MAGE_FROST_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_MAGE_FROST_80_ROT_1",
					"GUIDE_ADVISOR_MAGE_FROST_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_MAGE_FROST_80_DEF_1",
					"GUIDE_ADVISOR_MAGE_FROST_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MAGE_FROST_80_TAL_1",
					"GUIDE_ADVISOR_MAGE_FROST_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.06, 0.12, 0.22, 0.92 },
			topBar = { 0.10, 0.20, 0.38, 0.95 },
			titleColor = { 0.65, 0.85, 1.0 },
			sectionBar = { 0.12, 0.26, 0.44, 0.9 },
			sectionText = { 0.88, 0.94, 1.0 },
			icyBackdrop = { 0.08, 0.14, 0.26, 0.85 },
			icyBorder = { 0.30, 0.55, 0.95, 0.9 },
			icyTitleColor = { 0.70, 0.88, 1.0 },
			ebBg = { 0.06, 0.10, 0.18, 0.95 },
		},
	},
}

-- Monk: 1 Brewmaster, 2 Mistweaver, 3 Windwalker (retail). Key must match select(2, UnitClass("player")) == "MONK".
ns.GuideData["MONK"] = {
	[1] = {
		title = "Brewmaster Monk Guide",
		icyTitle = "Icy Veins — Brewmaster Monk leveling",
		link = "https://www.icy-veins.com/wow/brewmaster-monk-leveling-guide",
		tips = {
			{ spell = 121253, textKey = "GUIDE_TIP_189" },
			{ spell = 205523, textKey = "GUIDE_TIP_190" },
			{ spell = 115181, textKey = "GUIDE_TIP_191" },
			{ spell = 119582, textKey = "GUIDE_TIP_192" },
			{ spell = 322109, textKey = "GUIDE_TIP_193" },
			{ spell = 116847, textKey = "GUIDE_TIP_194" },
			{ spell = 115203, textKey = "GUIDE_TIP_195" },
			{ spell = 115072, textKey = "GUIDE_TIP_196" },
			{ spell = 116705, textKey = "GUIDE_TIP_197" },
			{ spell = 119381, textKey = "GUIDE_TIP_198" },
		},
		stats = "GUIDE_STATS_MONK_BREWMASTER",
		gear = {
			"GUIDE_GEAR_MONK_BREWMASTER_1",
			"GUIDE_GEAR_MONK_BREWMASTER_2",
			"GUIDE_GEAR_MONK_BREWMASTER_3",
			"GUIDE_GEAR_MONK_BREWMASTER_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222710, 242296 },
			flask = { 241324, 241322 },
			potion = { 191371, 241308 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_10_ROT_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_10_ROT_2",
					"GUIDE_ADVISOR_MONK_BREWMASTER_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_10_DEF_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_10_DEF_2",
					"GUIDE_ADVISOR_MONK_BREWMASTER_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_10_TAL_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_30_ROT_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_30_ROT_2",
					"GUIDE_ADVISOR_MONK_BREWMASTER_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_30_DEF_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_30_TAL_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_60_ROT_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_60_ROT_2",
					"GUIDE_ADVISOR_MONK_BREWMASTER_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_60_DEF_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_60_TAL_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_80_ROT_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_80_DEF_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_BREWMASTER_80_TAL_1",
					"GUIDE_ADVISOR_MONK_BREWMASTER_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.00, 0.20, 0.12, 0.92 },
			topBar = { 0.00, 0.34, 0.20, 0.95 },
			titleColor = { 0.55, 0.95, 0.78 },
			sectionBar = { 0.00, 0.40, 0.24, 0.9 },
			sectionText = { 0.82, 0.98, 0.90 },
			icyBackdrop = { 0.00, 0.22, 0.14, 0.85 },
			icyBorder = { 0.25, 0.80, 0.55, 0.9 },
			icyTitleColor = { 0.62, 0.96, 0.80 },
			ebBg = { 0.00, 0.16, 0.10, 0.95 },
		},
	},
	[2] = {
		title = "Mistweaver Monk Guide",
		icyTitle = "Icy Veins — Mistweaver Monk leveling",
		link = "https://www.icy-veins.com/wow/mistweaver-monk-leveling-guide",
		tips = {
			{ spell = 115175, textKey = "GUIDE_TIP_199" },
			{ spell = 115151, textKey = "GUIDE_TIP_200" },
			{ spell = 124682, textKey = "GUIDE_TIP_201" },
			{ spell = 116670, textKey = "GUIDE_TIP_202" },
			{ spell = 191837, textKey = "GUIDE_TIP_203" },
			{ spell = 115310, textKey = "GUIDE_TIP_204" },
			{ spell = 116849, textKey = "GUIDE_TIP_205" },
			{ spell = 116680, textKey = "GUIDE_TIP_206" },
			{ spell = 119381, textKey = "GUIDE_TIP_207" },
			{ spell = 115078, textKey = "GUIDE_TIP_208" },
		},
		stats = "GUIDE_STATS_MONK_MISTWEAVER",
		gear = {
			"GUIDE_GEAR_MONK_MISTWEAVER_1",
			"GUIDE_GEAR_MONK_MISTWEAVER_2",
			"GUIDE_GEAR_MONK_MISTWEAVER_3",
			"GUIDE_GEAR_MONK_MISTWEAVER_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_10_ROT_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_10_ROT_2",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_10_DEF_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_10_DEF_2",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_10_TAL_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_30_ROT_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_30_ROT_2",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_30_DEF_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_30_TAL_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_60_ROT_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_60_ROT_2",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_60_DEF_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_60_TAL_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_80_ROT_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_80_DEF_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_MISTWEAVER_80_TAL_1",
					"GUIDE_ADVISOR_MONK_MISTWEAVER_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.00, 0.26, 0.18, 0.92 },
			topBar = { 0.00, 0.48, 0.34, 0.95 },
			titleColor = { 0.60, 1.00, 0.85 },
			sectionBar = { 0.00, 0.56, 0.40, 0.9 },
			sectionText = { 0.86, 1.00, 0.94 },
			icyBackdrop = { 0.00, 0.30, 0.20, 0.85 },
			icyBorder = { 0.30, 0.90, 0.70, 0.9 },
			icyTitleColor = { 0.66, 1.00, 0.88 },
			ebBg = { 0.00, 0.20, 0.14, 0.95 },
		},
	},
	[3] = {
		title = "Windwalker Monk Guide",
		icyTitle = "Icy Veins — Windwalker Monk leveling",
		link = "https://www.icy-veins.com/wow/windwalker-monk-leveling-guide",
		tips = {
			{ spell = 100780, textKey = "GUIDE_TIP_209" },
			{ spell = 100787, textKey = "GUIDE_TIP_210" },
			{ spell = 107428, textKey = "GUIDE_TIP_211" },
			{ spell = 113656, textKey = "GUIDE_TIP_212" },
			{ spell = 101546, textKey = "GUIDE_TIP_213" },
			{ spell = 115080, textKey = "GUIDE_TIP_214" },
			{ spell = 122470, textKey = "GUIDE_TIP_215" },
			{ spell = 115098, textKey = "GUIDE_TIP_216" },
			{ spell = 116705, textKey = "GUIDE_TIP_217" },
			{ spell = 115008, textKey = "GUIDE_TIP_218" },
		},
		stats = "GUIDE_STATS_MONK_WINDWALKER",
		gear = {
			"GUIDE_GEAR_MONK_WINDWALKER_1",
			"GUIDE_GEAR_MONK_WINDWALKER_2",
			"GUIDE_GEAR_MONK_WINDWALKER_3",
			"GUIDE_GEAR_MONK_WINDWALKER_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222710, 242296, 242285, 242281 },
			flask = { 241324, 241322, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_10_ROT_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_10_ROT_2",
					"GUIDE_ADVISOR_MONK_WINDWALKER_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_10_DEF_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_10_DEF_2",
					"GUIDE_ADVISOR_MONK_WINDWALKER_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_10_TAL_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_30_ROT_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_30_ROT_2",
					"GUIDE_ADVISOR_MONK_WINDWALKER_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_30_DEF_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_30_TAL_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_60_ROT_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_60_ROT_2",
					"GUIDE_ADVISOR_MONK_WINDWALKER_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_60_DEF_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_60_TAL_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_80_ROT_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_80_DEF_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_MONK_WINDWALKER_80_TAL_1",
					"GUIDE_ADVISOR_MONK_WINDWALKER_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.00, 0.22, 0.22, 0.92 },
			topBar = { 0.00, 0.40, 0.40, 0.95 },
			titleColor = { 0.60, 0.95, 0.95 },
			sectionBar = { 0.00, 0.48, 0.48, 0.9 },
			sectionText = { 0.84, 0.98, 0.98 },
			icyBackdrop = { 0.00, 0.26, 0.26, 0.85 },
			icyBorder = { 0.28, 0.82, 0.82, 0.9 },
			icyTitleColor = { 0.66, 0.96, 0.96 },
			ebBg = { 0.00, 0.18, 0.18, 0.95 },
		},
	},
}

--[[ Paladin — same verified Midnight item pool as Hunter/DK (Wowhead item=…); `weaponOil` 243734 = Thalassian Phoenix Oil for weapon temp buff.
-- Holy: Int-leaning food 242275; Prot/Ret: Strength food 222772. Flasks: 241322 Mastery, 241327 Crit, 241326 Strength.
--]]
-- Paladin: 1 Holy, 2 Protection, 3 Retribution (retail). Key must match select(2, UnitClass("player")) == "PALADIN".
ns.GuideData["PALADIN"] = {
	[1] = {
		title = "Holy Paladin Guide",
		icyTitle = "Icy Veins — Holy Paladin leveling",
		link = "https://www.icy-veins.com/wow/holy-paladin-leveling-guide",
		tips = {
			{ spell = 20473, textKey = "GUIDE_TIP_219" },
			{ spell = 85673, textKey = "GUIDE_TIP_220" },
			{ spell = 19750, textKey = "GUIDE_TIP_221" },
			{ spell = 53563, textKey = "GUIDE_TIP_222" },
			{ spell = 31884, textKey = "GUIDE_TIP_223" },
			{ spell = 114158, textKey = "GUIDE_TIP_224" },
			{ spell = 498, textKey = "GUIDE_TIP_225" },
			{ spell = 853, textKey = "GUIDE_TIP_226" },
			{ spell = 1044, textKey = "GUIDE_TIP_227" },
			{ spell = 633, textKey = "GUIDE_TIP_228" },
		},
		stats = "GUIDE_STATS_PALADIN_HOLY",
		gear = {
			"GUIDE_GEAR_PALADIN_HOLY_1",
			"GUIDE_GEAR_PALADIN_HOLY_2",
			"GUIDE_GEAR_PALADIN_HOLY_3",
			"GUIDE_GEAR_PALADIN_HOLY_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_HOLY_10_ROT_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_10_ROT_2",
					"GUIDE_ADVISOR_PALADIN_HOLY_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_HOLY_10_DEF_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_10_DEF_2",
					"GUIDE_ADVISOR_PALADIN_HOLY_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_HOLY_10_TAL_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_HOLY_30_ROT_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_30_ROT_2",
					"GUIDE_ADVISOR_PALADIN_HOLY_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_HOLY_30_DEF_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_HOLY_30_TAL_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_HOLY_60_ROT_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_60_ROT_2",
					"GUIDE_ADVISOR_PALADIN_HOLY_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_HOLY_60_DEF_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_HOLY_60_TAL_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_HOLY_80_ROT_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_HOLY_80_DEF_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_HOLY_80_TAL_1",
					"GUIDE_ADVISOR_PALADIN_HOLY_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.24, 0.20, 0.10, 0.92 },
			topBar = { 0.42, 0.36, 0.16, 0.95 },
			titleColor = { 1.0, 0.93, 0.65 },
			sectionBar = { 0.50, 0.42, 0.18, 0.9 },
			sectionText = { 1.0, 0.96, 0.82 },
			icyBackdrop = { 0.28, 0.24, 0.12, 0.85 },
			icyBorder = { 0.92, 0.80, 0.42, 0.9 },
			icyTitleColor = { 1.0, 0.94, 0.72 },
			ebBg = { 0.20, 0.16, 0.08, 0.95 },
		},
	},
	[2] = {
		title = "Protection Paladin Guide",
		icyTitle = "Icy Veins — Protection Paladin leveling",
		link = "https://www.icy-veins.com/wow/protection-paladin-leveling-guide",
		tips = {
			{ spell = 53600, textKey = "GUIDE_TIP_229" },
			{ spell = 31935, textKey = "GUIDE_TIP_230" },
			{ spell = 204019, textKey = "GUIDE_TIP_231" },
			{ spell = 35395, textKey = "GUIDE_TIP_232" },
			{ spell = 20271, textKey = "GUIDE_TIP_233" },
			{ spell = 152262, textKey = "GUIDE_TIP_234" },
			{ spell = 86659, textKey = "GUIDE_TIP_235" },
			{ spell = 31850, textKey = "GUIDE_TIP_236" },
			{ spell = 62124, textKey = "GUIDE_TIP_237" },
			{ spell = 19752, textKey = "GUIDE_TIP_238" },
		},
		stats = "GUIDE_STATS_PALADIN_PROTECTION",
		gear = {
			"GUIDE_GEAR_PALADIN_PROT_1",
			"GUIDE_GEAR_PALADIN_PROT_2",
			"GUIDE_GEAR_PALADIN_PROT_3",
			"GUIDE_GEAR_PALADIN_PROT_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222772, 242296 },
			flask = { 241326, 241322 },
			potion = { 191371, 241308 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_10_ROT_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_10_ROT_2",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_10_DEF_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_10_DEF_2",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_10_TAL_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_30_ROT_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_30_ROT_2",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_30_DEF_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_30_TAL_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_60_ROT_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_60_ROT_2",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_60_DEF_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_60_TAL_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_80_ROT_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_80_DEF_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_PROTECTION_80_TAL_1",
					"GUIDE_ADVISOR_PALADIN_PROTECTION_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.22, 0.18, 0.08, 0.92 },
			topBar = { 0.38, 0.30, 0.12, 0.95 },
			titleColor = { 0.95, 0.85, 0.52 },
			sectionBar = { 0.46, 0.36, 0.16, 0.9 },
			sectionText = { 0.98, 0.92, 0.72 },
			icyBackdrop = { 0.24, 0.18, 0.10, 0.85 },
			icyBorder = { 0.85, 0.70, 0.32, 0.9 },
			icyTitleColor = { 0.96, 0.86, 0.58 },
			ebBg = { 0.18, 0.14, 0.08, 0.95 },
		},
	},
	[3] = {
		title = "Retribution Paladin Guide",
		icyTitle = "Icy Veins — Retribution Paladin leveling",
		link = "https://www.icy-veins.com/wow/retribution-paladin-leveling-guide",
		tips = {
			{ spell = 85256, textKey = "GUIDE_TIP_239" },
			{ spell = 184575, textKey = "GUIDE_TIP_240" },
			{ spell = 20271, textKey = "GUIDE_TIP_241" },
			{ spell = 35395, textKey = "GUIDE_TIP_242" },
			{ spell = 53385, textKey = "GUIDE_TIP_243" },
			{ spell = 24275, textKey = "GUIDE_TIP_244" },
			{ spell = 31884, textKey = "GUIDE_TIP_245" },
			{ spell = 184662, textKey = "GUIDE_TIP_246" },
			{ spell = 642, textKey = "GUIDE_TIP_247" },
			{ spell = 190784, textKey = "GUIDE_TIP_248" },
		},
		stats = "GUIDE_STATS_PALADIN_RETRIBUTION",
		gear = {
			"GUIDE_GEAR_PALADIN_RET_1",
			"GUIDE_GEAR_PALADIN_RET_2",
			"GUIDE_GEAR_PALADIN_RET_3",
			"GUIDE_GEAR_PALADIN_RET_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222772, 242296 },
			flask = { 241322, 241326, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_10_ROT_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_10_ROT_2",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_10_DEF_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_10_DEF_2",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_10_TAL_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_30_ROT_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_30_ROT_2",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_30_DEF_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_30_TAL_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_60_ROT_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_60_ROT_2",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_60_DEF_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_60_TAL_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_80_ROT_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_80_DEF_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_80_TAL_1",
					"GUIDE_ADVISOR_PALADIN_RETRIBUTION_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.24, 0.14, 0.06, 0.92 },
			topBar = { 0.44, 0.24, 0.10, 0.95 },
			titleColor = { 1.0, 0.75, 0.38 },
			sectionBar = { 0.50, 0.30, 0.12, 0.9 },
			sectionText = { 1.0, 0.90, 0.74 },
			icyBackdrop = { 0.26, 0.14, 0.08, 0.85 },
			icyBorder = { 0.92, 0.56, 0.22, 0.9 },
			icyTitleColor = { 1.0, 0.78, 0.46 },
			ebBg = { 0.20, 0.12, 0.06, 0.95 },
		},
	},
}

-- Priest: 1 Discipline, 2 Holy, 3 Shadow (retail). Key must match select(2, UnitClass("player")) == "PRIEST".
ns.GuideData["PRIEST"] = {
	[1] = {
		title = "Discipline Priest Guide",
		icyTitle = "Icy Veins — Discipline Priest leveling",
		link = "https://www.icy-veins.com/wow/discipline-priest-leveling-guide",
		tips = {
			{ spell = 194384, textKey = "GUIDE_TIP_249" },
			{ spell = 17, textKey = "GUIDE_TIP_250" },
			{ spell = 47540, textKey = "GUIDE_TIP_251" },
			{ spell = 585, textKey = "GUIDE_TIP_252" },
			{ spell = 8092, textKey = "GUIDE_TIP_253" },
			{ spell = 33206, textKey = "GUIDE_TIP_254" },
			{ spell = 62618, textKey = "GUIDE_TIP_255" },
			{ spell = 214621, textKey = "GUIDE_TIP_256" },
			{ spell = 527, textKey = "GUIDE_TIP_257" },
			{ spell = 73325, textKey = "GUIDE_TIP_258" },
		},
		stats = "GUIDE_STATS_PRIEST_DISCIPLINE",
		gear = {
			"GUIDE_GEAR_PRIEST_DISC_1",
			"GUIDE_GEAR_PRIEST_DISC_2",
			"GUIDE_GEAR_PRIEST_DISC_3",
			"GUIDE_GEAR_PRIEST_DISC_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_10_ROT_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_10_ROT_2",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_10_DEF_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_10_DEF_2",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_10_TAL_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_30_ROT_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_30_ROT_2",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_30_DEF_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_30_TAL_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_60_ROT_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_60_ROT_2",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_60_DEF_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_60_TAL_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_80_ROT_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_80_DEF_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_80_TAL_1",
					"GUIDE_ADVISOR_PRIEST_DISCIPLINE_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.20, 0.20, 0.20, 0.92 },
			topBar = { 0.42, 0.42, 0.42, 0.95 },
			titleColor = { 1.0, 1.0, 1.0 },
			sectionBar = { 0.55, 0.55, 0.55, 0.9 },
			sectionText = { 1.0, 1.0, 1.0 },
			icyBackdrop = { 0.25, 0.25, 0.25, 0.85 },
			icyBorder = { 0.90, 0.90, 0.90, 0.9 },
			icyTitleColor = { 1.0, 1.0, 1.0 },
			ebBg = { 0.16, 0.16, 0.16, 0.95 },
		},
	},
	[2] = {
		title = "Holy Priest Guide",
		icyTitle = "Icy Veins — Holy Priest leveling",
		link = "https://www.icy-veins.com/wow/holy-priest-leveling-guide",
		tips = {
			{ spell = 2061, textKey = "GUIDE_TIP_259" },
			{ spell = 2050, textKey = "GUIDE_TIP_260" },
			{ spell = 34861, textKey = "GUIDE_TIP_261" },
			{ spell = 139, textKey = "GUIDE_TIP_262" },
			{ spell = 33076, textKey = "GUIDE_TIP_263" },
			{ spell = 64843, textKey = "GUIDE_TIP_264" },
			{ spell = 47788, textKey = "GUIDE_TIP_265" },
			{ spell = 14751, textKey = "GUIDE_TIP_266" },
			{ spell = 586, textKey = "GUIDE_TIP_267" },
			{ spell = 2001, textKey = "GUIDE_TIP_268" },
		},
		stats = "GUIDE_STATS_PRIEST_HOLY",
		gear = {
			"GUIDE_GEAR_PRIEST_HOLY_1",
			"GUIDE_GEAR_PRIEST_HOLY_2",
			"GUIDE_GEAR_PRIEST_HOLY_3",
			"GUIDE_GEAR_PRIEST_HOLY_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_HOLY_10_ROT_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_10_ROT_2",
					"GUIDE_ADVISOR_PRIEST_HOLY_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_HOLY_10_DEF_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_10_DEF_2",
					"GUIDE_ADVISOR_PRIEST_HOLY_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_HOLY_10_TAL_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_HOLY_30_ROT_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_30_ROT_2",
					"GUIDE_ADVISOR_PRIEST_HOLY_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_HOLY_30_DEF_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_HOLY_30_TAL_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_HOLY_60_ROT_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_60_ROT_2",
					"GUIDE_ADVISOR_PRIEST_HOLY_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_HOLY_60_DEF_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_HOLY_60_TAL_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_HOLY_80_ROT_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_HOLY_80_DEF_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_HOLY_80_TAL_1",
					"GUIDE_ADVISOR_PRIEST_HOLY_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.24, 0.22, 0.10, 0.92 },
			topBar = { 0.46, 0.40, 0.18, 0.95 },
			titleColor = { 1.0, 0.94, 0.55 },
			sectionBar = { 0.54, 0.46, 0.22, 0.9 },
			sectionText = { 1.0, 0.97, 0.80 },
			icyBackdrop = { 0.30, 0.26, 0.12, 0.85 },
			icyBorder = { 0.95, 0.85, 0.45, 0.9 },
			icyTitleColor = { 1.0, 0.95, 0.62 },
			ebBg = { 0.20, 0.18, 0.08, 0.95 },
		},
	},
	[3] = {
		title = "Shadow Priest Guide",
		icyTitle = "Icy Veins — Shadow Priest leveling",
		link = "https://www.icy-veins.com/wow/shadow-priest-leveling-guide",
		tips = {
			{ spell = 589, textKey = "GUIDE_TIP_269" },
			{ spell = 34914, textKey = "GUIDE_TIP_270" },
			{ spell = 8092, textKey = "GUIDE_TIP_271" },
			{ spell = 15407, textKey = "GUIDE_TIP_272" },
			{ spell = 228260, textKey = "GUIDE_TIP_273" },
			{ spell = 32379, textKey = "GUIDE_TIP_274" },
			{ spell = 191077, textKey = "GUIDE_TIP_275" },
			{ spell = 47585, textKey = "GUIDE_TIP_276" },
			{ spell = 34433, textKey = "GUIDE_TIP_277" },
			{ spell = 15286, textKey = "GUIDE_TIP_278" },
		},
		stats = "GUIDE_STATS_PRIEST_SHADOW",
		gear = {
			"GUIDE_GEAR_PRIEST_SHADOW_1",
			"GUIDE_GEAR_PRIEST_SHADOW_2",
			"GUIDE_GEAR_PRIEST_SHADOW_3",
			"GUIDE_GEAR_PRIEST_SHADOW_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_10_ROT_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_10_ROT_2",
					"GUIDE_ADVISOR_PRIEST_SHADOW_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_10_DEF_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_10_DEF_2",
					"GUIDE_ADVISOR_PRIEST_SHADOW_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_10_TAL_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_30_ROT_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_30_ROT_2",
					"GUIDE_ADVISOR_PRIEST_SHADOW_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_30_DEF_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_30_TAL_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_60_ROT_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_60_ROT_2",
					"GUIDE_ADVISOR_PRIEST_SHADOW_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_60_DEF_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_60_TAL_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_80_ROT_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_80_DEF_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_PRIEST_SHADOW_80_TAL_1",
					"GUIDE_ADVISOR_PRIEST_SHADOW_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.16, 0.08, 0.22, 0.92 },
			topBar = { 0.32, 0.14, 0.44, 0.95 },
			titleColor = { 0.86, 0.68, 1.0 },
			sectionBar = { 0.40, 0.18, 0.50, 0.9 },
			sectionText = { 0.94, 0.84, 1.0 },
			icyBackdrop = { 0.18, 0.10, 0.26, 0.85 },
			icyBorder = { 0.65, 0.38, 0.90, 0.9 },
			icyTitleColor = { 0.90, 0.74, 1.0 },
			ebBg = { 0.14, 0.08, 0.20, 0.95 },
		},
	},
}

-- Rogue: 1 Assassination, 2 Outlaw, 3 Subtlety (retail). Key must match select(2, UnitClass("player")) == "ROGUE".
ns.GuideData["ROGUE"] = {
	[1] = {
		title = "Assassination Rogue Guide",
		icyTitle = "Icy Veins — Assassination Rogue leveling",
		link = "https://www.icy-veins.com/wow/assassination-rogue-leveling-guide",
		tips = {
			{ spell = 703, textKey = "GUIDE_TIP_279" },
			{ spell = 1943, textKey = "GUIDE_TIP_280" },
			{ spell = 53, textKey = "GUIDE_TIP_281" },
			{ spell = 111240, textKey = "GUIDE_TIP_282" },
			{ spell = 79140, textKey = "GUIDE_TIP_283" },
			{ spell = 1856, textKey = "GUIDE_TIP_284" },
			{ spell = 1766, textKey = "GUIDE_TIP_285" },
			{ spell = 36554, textKey = "GUIDE_TIP_286" },
			{ spell = 5277, textKey = "GUIDE_TIP_287" },
			{ spell = 31224, textKey = "GUIDE_TIP_288" },
		},
		stats = "GUIDE_STATS_ROGUE_ASSASSINATION",
		gear = {
			"GUIDE_GEAR_ROGUE_ASSA_1",
			"GUIDE_GEAR_ROGUE_ASSA_2",
			"GUIDE_GEAR_ROGUE_ASSA_3",
			"GUIDE_GEAR_ROGUE_ASSA_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222710, 242296, 242285, 242281 },
			flask = { 241324, 241322, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_10_ROT_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_10_ROT_2",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_10_DEF_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_10_DEF_2",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_10_TAL_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_30_ROT_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_30_ROT_2",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_30_DEF_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_30_TAL_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_60_ROT_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_60_ROT_2",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_60_DEF_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_60_TAL_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_80_ROT_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_80_DEF_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_80_TAL_1",
					"GUIDE_ADVISOR_ROGUE_ASSASSINATION_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.16, 0.04, 0.04, 0.92 },
			topBar = { 0.32, 0.08, 0.08, 0.95 },
			titleColor = { 0.95, 0.55, 0.55 },
			sectionBar = { 0.40, 0.10, 0.10, 0.9 },
			sectionText = { 0.98, 0.82, 0.82 },
			icyBackdrop = { 0.18, 0.06, 0.06, 0.85 },
			icyBorder = { 0.82, 0.22, 0.22, 0.9 },
			icyTitleColor = { 0.96, 0.64, 0.64 },
			ebBg = { 0.12, 0.04, 0.04, 0.95 },
		},
	},
	[2] = {
		title = "Outlaw Rogue Guide",
		icyTitle = "Icy Veins — Outlaw Rogue leveling",
		link = "https://www.icy-veins.com/wow/outlaw-rogue-leveling-guide",
		tips = {
			{ spell = 193315, textKey = "GUIDE_TIP_289" },
			{ spell = 315341, textKey = "GUIDE_TIP_290" },
			{ spell = 2098, textKey = "GUIDE_TIP_291" },
			{ spell = 185763, textKey = "GUIDE_TIP_292" },
			{ spell = 13877, textKey = "GUIDE_TIP_293" },
			{ spell = 13750, textKey = "GUIDE_TIP_294" },
			{ spell = 2094, textKey = "GUIDE_TIP_295" },
			{ spell = 1856, textKey = "GUIDE_TIP_296" },
			{ spell = 1766, textKey = "GUIDE_TIP_297" },
			{ spell = 1966, textKey = "GUIDE_TIP_298" },
		},
		stats = "GUIDE_STATS_ROGUE_OUTLAW",
		gear = {
			"GUIDE_GEAR_ROGUE_OUTLAW_1",
			"GUIDE_GEAR_ROGUE_OUTLAW_2",
			"GUIDE_GEAR_ROGUE_OUTLAW_3",
			"GUIDE_GEAR_ROGUE_OUTLAW_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222710, 242296, 242285, 242281 },
			flask = { 241324, 241322, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_10_ROT_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_10_ROT_2",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_10_DEF_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_10_DEF_2",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_10_TAL_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_30_ROT_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_30_ROT_2",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_30_DEF_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_30_TAL_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_60_ROT_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_60_ROT_2",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_60_DEF_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_60_TAL_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_80_ROT_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_80_DEF_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_OUTLAW_80_TAL_1",
					"GUIDE_ADVISOR_ROGUE_OUTLAW_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.14, 0.14, 0.14, 0.92 },
			topBar = { 0.24, 0.24, 0.24, 0.95 },
			titleColor = { 0.88, 0.88, 0.88 },
			sectionBar = { 0.30, 0.30, 0.30, 0.9 },
			sectionText = { 0.94, 0.94, 0.94 },
			icyBackdrop = { 0.16, 0.16, 0.16, 0.85 },
			icyBorder = { 0.70, 0.70, 0.70, 0.9 },
			icyTitleColor = { 0.90, 0.90, 0.90 },
			ebBg = { 0.12, 0.12, 0.12, 0.95 },
		},
	},
	[3] = {
		title = "Subtlety Rogue Guide",
		icyTitle = "Icy Veins — Subtlety Rogue leveling",
		link = "https://www.icy-veins.com/wow/subtlety-rogue-leveling-guide",
		tips = {
			{ spell = 185438, textKey = "GUIDE_TIP_299" },
			{ spell = 2807, textKey = "GUIDE_TIP_300" },
			{ spell = 19503, textKey = "GUIDE_TIP_301" },
			{ spell = 185313, textKey = "GUIDE_TIP_302" },
			{ spell = 121471, textKey = "GUIDE_TIP_303" },
			{ spell = 114014, textKey = "GUIDE_TIP_304" },
			{ spell = 1856, textKey = "GUIDE_TIP_305" },
			{ spell = 1766, textKey = "GUIDE_TIP_306" },
			{ spell = 408, textKey = "GUIDE_TIP_307" },
			{ spell = 31224, textKey = "GUIDE_TIP_308" },
		},
		stats = "GUIDE_STATS_ROGUE_SUBTLETY",
		gear = {
			"GUIDE_GEAR_ROGUE_SUB_1",
			"GUIDE_GEAR_ROGUE_SUB_2",
			"GUIDE_GEAR_ROGUE_SUB_3",
			"GUIDE_GEAR_ROGUE_SUB_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222710, 242296, 242285, 242281 },
			flask = { 241324, 241322, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_10_ROT_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_10_ROT_2",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_10_DEF_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_10_DEF_2",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_10_TAL_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_30_ROT_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_30_ROT_2",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_30_DEF_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_30_TAL_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_60_ROT_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_60_ROT_2",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_60_DEF_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_60_TAL_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_80_ROT_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_80_DEF_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_80_TAL_1",
					"GUIDE_ADVISOR_ROGUE_SUBTLETY_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.08, 0.04, 0.14, 0.92 },
			topBar = { 0.16, 0.08, 0.24, 0.95 },
			titleColor = { 0.82, 0.72, 0.95 },
			sectionBar = { 0.22, 0.12, 0.30, 0.9 },
			sectionText = { 0.90, 0.86, 0.98 },
			icyBackdrop = { 0.10, 0.06, 0.18, 0.85 },
			icyBorder = { 0.50, 0.35, 0.78, 0.9 },
			icyTitleColor = { 0.86, 0.76, 0.96 },
			ebBg = { 0.08, 0.04, 0.14, 0.95 },
		},
	},
}

-- Shaman: 1 Elemental, 2 Enhancement, 3 Restoration (retail). Key must match select(2, UnitClass("player")) == "SHAMAN".
ns.GuideData["SHAMAN"] = {
	[1] = {
		title = "Elemental Shaman Guide",
		icyTitle = "Icy Veins — Elemental Shaman leveling",
		link = "https://www.icy-veins.com/wow/elemental-shaman-leveling-guide",
		tips = {
			{ spell = 188196, textKey = "GUIDE_TIP_309" },
			{ spell = 188443, textKey = "GUIDE_TIP_310" },
			{ spell = 8042, textKey = "GUIDE_TIP_311" },
			{ spell = 114074, textKey = "GUIDE_TIP_312" },
			{ spell = 188389, textKey = "GUIDE_TIP_313" },
			{ spell = 198067, textKey = "GUIDE_TIP_314" },
			{ spell = 108271, textKey = "GUIDE_TIP_315" },
			{ spell = 57994, textKey = "GUIDE_TIP_316" },
			{ spell = 192058, textKey = "GUIDE_TIP_317" },
			{ spell = 2825, textKey = "GUIDE_TIP_318" },
		},
		stats = "GUIDE_STATS_SHAMAN_ELEMENTAL",
		gear = {
			"GUIDE_GEAR_SHAMAN_ELEMENTAL_1",
			"GUIDE_GEAR_SHAMAN_ELEMENTAL_2",
			"GUIDE_GEAR_SHAMAN_ELEMENTAL_3",
			"GUIDE_GEAR_SHAMAN_ELEMENTAL_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_10_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_10_ROT_2",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_10_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_10_DEF_2",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_10_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_30_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_30_ROT_2",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_30_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_30_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_60_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_60_ROT_2",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_60_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_60_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_80_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_80_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_80_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_ELEMENTAL_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.22, 0.11, 0.00, 0.92 },
			topBar = { 0.46, 0.22, 0.00, 0.95 },
			titleColor = { 1.0, 0.72, 0.40 },
			sectionBar = { 0.54, 0.28, 0.00, 0.9 },
			sectionText = { 1.0, 0.88, 0.70 },
			icyBackdrop = { 0.28, 0.14, 0.00, 0.85 },
			icyBorder = { 0.95, 0.55, 0.15, 0.9 },
			icyTitleColor = { 1.0, 0.75, 0.45 },
			ebBg = { 0.20, 0.10, 0.00, 0.95 },
		},
	},
	[2] = {
		title = "Enhancement Shaman Guide",
		icyTitle = "Icy Veins — Enhancement Shaman leveling",
		link = "https://www.icy-veins.com/wow/enhancement-shaman-leveling-guide",
		tips = {
			{ spell = 17364, textKey = "GUIDE_TIP_319" },
			{ spell = 193786, textKey = "GUIDE_TIP_320" },
			{ spell = 60103, textKey = "GUIDE_TIP_321" },
			{ spell = 187880, textKey = "GUIDE_TIP_322" },
			{ spell = 188389, textKey = "GUIDE_TIP_323" },
			{ spell = 34428, textKey = "GUIDE_TIP_324" },
			{ spell = 108271, textKey = "GUIDE_TIP_325" },
			{ spell = 57994, textKey = "GUIDE_TIP_326" },
			{ spell = 192058, textKey = "GUIDE_TIP_327" },
			{ spell = 2645, textKey = "GUIDE_TIP_328" },
		},
		stats = "GUIDE_STATS_SHAMAN_ENH",
		gear = {
			"GUIDE_GEAR_SHAMAN_ENH_1",
			"GUIDE_GEAR_SHAMAN_ENH_2",
			"GUIDE_GEAR_SHAMAN_ENH_3",
			"GUIDE_GEAR_SHAMAN_ENH_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222710, 242296, 242285, 242281 },
			flask = { 241324, 241322, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_ENH_10_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_10_ROT_2",
					"GUIDE_ADVISOR_SHAMAN_ENH_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_ENH_10_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_10_DEF_2",
					"GUIDE_ADVISOR_SHAMAN_ENH_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_ENH_10_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_ENH_30_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_30_ROT_2",
					"GUIDE_ADVISOR_SHAMAN_ENH_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_ENH_30_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_ENH_30_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_ENH_60_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_60_ROT_2",
					"GUIDE_ADVISOR_SHAMAN_ENH_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_ENH_60_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_ENH_60_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_ENH_80_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_ENH_80_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_ENH_80_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_ENH_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.00, 0.10, 0.24, 0.92 },
			topBar = { 0.00, 0.18, 0.46, 0.95 },
			titleColor = { 0.62, 0.78, 1.0 },
			sectionBar = { 0.00, 0.24, 0.54, 0.9 },
			sectionText = { 0.84, 0.92, 1.0 },
			icyBackdrop = { 0.00, 0.12, 0.30, 0.85 },
			icyBorder = { 0.20, 0.48, 0.95, 0.9 },
			icyTitleColor = { 0.68, 0.82, 1.0 },
			ebBg = { 0.00, 0.08, 0.20, 0.95 },
		},
	},
	[3] = {
		title = "Restoration Shaman Guide",
		icyTitle = "Icy Veins — Restoration Shaman leveling",
		link = "https://www.icy-veins.com/wow/restoration-shaman-leveling-guide",
		tips = {
			{ spell = 61295, textKey = "GUIDE_TIP_329" },
			{ spell = 1064, textKey = "GUIDE_TIP_330" },
			{ spell = 77472, textKey = "GUIDE_TIP_331" },
			{ spell = 8004, textKey = "GUIDE_TIP_332" },
			{ spell = 5394, textKey = "GUIDE_TIP_333" },
			{ spell = 98008, textKey = "GUIDE_TIP_334" },
			{ spell = 108271, textKey = "GUIDE_TIP_335" },
			{ spell = 57994, textKey = "GUIDE_TIP_336" },
			{ spell = 16166, textKey = "GUIDE_TIP_337" },
			{ spell = 108280, textKey = "GUIDE_TIP_338" },
		},
		stats = "GUIDE_STATS_SHAMAN_RESTO",
		gear = {
			"GUIDE_GEAR_SHAMAN_RESTO_1",
			"GUIDE_GEAR_SHAMAN_RESTO_2",
			"GUIDE_GEAR_SHAMAN_RESTO_3",
			"GUIDE_GEAR_SHAMAN_RESTO_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_10_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_10_ROT_2",
					"GUIDE_ADVISOR_SHAMAN_RESTO_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_10_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_10_DEF_2",
					"GUIDE_ADVISOR_SHAMAN_RESTO_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_10_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_30_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_30_ROT_2",
					"GUIDE_ADVISOR_SHAMAN_RESTO_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_30_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_30_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_60_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_60_ROT_2",
					"GUIDE_ADVISOR_SHAMAN_RESTO_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_60_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_60_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_80_ROT_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_80_DEF_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_SHAMAN_RESTO_80_TAL_1",
					"GUIDE_ADVISOR_SHAMAN_RESTO_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.00, 0.16, 0.22, 0.92 },
			topBar = { 0.00, 0.28, 0.38, 0.95 },
			titleColor = { 0.64, 0.90, 1.0 },
			sectionBar = { 0.00, 0.34, 0.46, 0.9 },
			sectionText = { 0.86, 0.96, 1.0 },
			icyBackdrop = { 0.00, 0.20, 0.28, 0.85 },
			icyBorder = { 0.22, 0.68, 0.88, 0.9 },
			icyTitleColor = { 0.68, 0.92, 1.0 },
			ebBg = { 0.00, 0.14, 0.20, 0.95 },
		},
	},
}

-- Warlock: 1 Affliction, 2 Demonology, 3 Destruction (retail). Key must match select(2, UnitClass("player")) == "WARLOCK".
ns.GuideData["WARLOCK"] = {
	[1] = {
		title = "Affliction Warlock Guide",
		icyTitle = "Icy Veins — Affliction Warlock leveling",
		link = "https://www.icy-veins.com/wow/affliction-warlock-leveling-guide",
		tips = {
			{ spell = 980, textKey = "GUIDE_TIP_339" },
			{ spell = 172, textKey = "GUIDE_TIP_340" },
			{ spell = 316099, textKey = "GUIDE_TIP_341" },
			{ spell = 198590, textKey = "GUIDE_TIP_342" },
			{ spell = 205179, textKey = "GUIDE_TIP_343" },
			{ spell = 686, textKey = "GUIDE_TIP_344" },
			{ spell = 325640, textKey = "GUIDE_TIP_345" },
			{ spell = 6353, textKey = "GUIDE_TIP_346" },
			{ spell = 48018, textKey = "GUIDE_TIP_347" },
			{ spell = 6201, textKey = "GUIDE_TIP_348" },
		},
		stats = "GUIDE_STATS_WARLOCK_AFFLICTION",
		gear = {
			"GUIDE_GEAR_WARLOCK_AFFLICTION_1",
			"GUIDE_GEAR_WARLOCK_AFFLICTION_2",
			"GUIDE_GEAR_WARLOCK_AFFLICTION_3",
			"GUIDE_GEAR_WARLOCK_AFFLICTION_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_10_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_10_ROT_2",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_10_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_10_DEF_2",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_10_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_30_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_30_ROT_2",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_30_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_30_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_60_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_60_ROT_2",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_60_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_60_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_80_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_80_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_80_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_AFFLICTION_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.16, 0.10, 0.22, 0.92 },
			topBar = { 0.30, 0.16, 0.44, 0.95 },
			titleColor = { 0.88, 0.76, 1.0 },
			sectionBar = { 0.36, 0.18, 0.50, 0.9 },
			sectionText = { 0.94, 0.88, 1.0 },
			icyBackdrop = { 0.18, 0.12, 0.28, 0.85 },
			icyBorder = { 0.62, 0.42, 0.88, 0.9 },
			icyTitleColor = { 0.90, 0.80, 1.0 },
			ebBg = { 0.14, 0.08, 0.20, 0.95 },
		},
	},
	[2] = {
		title = "Demonology Warlock Guide",
		icyTitle = "Icy Veins — Demonology Warlock leveling",
		link = "https://www.icy-veins.com/wow/demonology-warlock-leveling-guide",
		tips = {
			{ spell = 105174, textKey = "GUIDE_TIP_349" },
			{ spell = 104316, textKey = "GUIDE_TIP_350" },
			{ spell = 264178, textKey = "GUIDE_TIP_351" },
			{ spell = 265187, textKey = "GUIDE_TIP_352" },
			{ spell = 196277, textKey = "GUIDE_TIP_353" },
			{ spell = 686, textKey = "GUIDE_TIP_354" },
			{ spell = 267171, textKey = "GUIDE_TIP_355" },
			{ spell = 111898, textKey = "GUIDE_TIP_356" },
			{ spell = 104773, textKey = "GUIDE_TIP_357" },
			{ spell = 697, textKey = "GUIDE_TIP_358" },
		},
		stats = "GUIDE_STATS_WARLOCK_DEMONOLOGY",
		gear = {
			"GUIDE_GEAR_WARLOCK_DEMONOLOGY_1",
			"GUIDE_GEAR_WARLOCK_DEMONOLOGY_2",
			"GUIDE_GEAR_WARLOCK_DEMONOLOGY_3",
			"GUIDE_GEAR_WARLOCK_DEMONOLOGY_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_10_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_10_ROT_2",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_10_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_10_DEF_2",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_10_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_30_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_30_ROT_2",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_30_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_30_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_60_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_60_ROT_2",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_60_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_60_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_80_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_80_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_80_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_DEMONOLOGY_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.14, 0.08, 0.20, 0.92 },
			topBar = { 0.24, 0.12, 0.34, 0.95 },
			titleColor = { 0.82, 0.70, 0.96 },
			sectionBar = { 0.30, 0.14, 0.40, 0.9 },
			sectionText = { 0.90, 0.84, 0.98 },
			icyBackdrop = { 0.16, 0.10, 0.24, 0.85 },
			icyBorder = { 0.52, 0.34, 0.78, 0.9 },
			icyTitleColor = { 0.86, 0.76, 0.98 },
			ebBg = { 0.12, 0.08, 0.18, 0.95 },
		},
	},
	[3] = {
		title = "Destruction Warlock Guide",
		icyTitle = "Icy Veins — Destruction Warlock leveling",
		link = "https://www.icy-veins.com/wow/destruction-warlock-leveling-guide",
		tips = {
			{ spell = 116858, textKey = "GUIDE_TIP_359" },
			{ spell = 29722, textKey = "GUIDE_TIP_360" },
			{ spell = 17962, textKey = "GUIDE_TIP_361" },
			{ spell = 348, textKey = "GUIDE_TIP_362" },
			{ spell = 1122, textKey = "GUIDE_TIP_363" },
			{ spell = 5740, textKey = "GUIDE_TIP_364" },
			{ spell = 17877, textKey = "GUIDE_TIP_365" },
			{ spell = 80240, textKey = "GUIDE_TIP_366" },
			{ spell = 119898, textKey = "GUIDE_TIP_367" },
			{ spell = 104773, textKey = "GUIDE_TIP_368" },
		},
		stats = "GUIDE_STATS_WARLOCK_DESTRUCTION",
		gear = {
			"GUIDE_GEAR_WARLOCK_DESTRUCTION_1",
			"GUIDE_GEAR_WARLOCK_DESTRUCTION_2",
			"GUIDE_GEAR_WARLOCK_DESTRUCTION_3",
			"GUIDE_GEAR_WARLOCK_DESTRUCTION_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 242275, 242296 },
			flask = { 241322, 241327 },
			potion = { 241308, 241289 },
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_10_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_10_ROT_2",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_10_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_10_DEF_2",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_10_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_30_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_30_ROT_2",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_30_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_30_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_60_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_60_ROT_2",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_60_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_60_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_80_ROT_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_80_DEF_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_80_TAL_1",
					"GUIDE_ADVISOR_WARLOCK_DESTRUCTION_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.22, 0.10, 0.00, 0.92 },
			topBar = { 0.44, 0.20, 0.00, 0.95 },
			titleColor = { 1.0, 0.68, 0.34 },
			sectionBar = { 0.50, 0.24, 0.02, 0.9 },
			sectionText = { 1.0, 0.86, 0.70 },
			icyBackdrop = { 0.26, 0.12, 0.00, 0.85 },
			icyBorder = { 0.92, 0.50, 0.10, 0.9 },
			icyTitleColor = { 1.0, 0.72, 0.40 },
			ebBg = { 0.18, 0.08, 0.00, 0.95 },
		},
	},
}

-- Warrior: 1 Arms, 2 Fury, 3 Protection (retail). Key must match select(2, UnitClass("player")) == "WARRIOR".
ns.GuideData["WARRIOR"] = {
	[1] = {
		title = "Arms Warrior Guide",
		icyTitle = "Icy Veins — Arms Warrior leveling",
		link = "https://www.icy-veins.com/wow/arms-warrior-leveling-guide",
		tips = {
			{ spell = 12294, textKey = "GUIDE_TIP_369" },
			{ spell = 7384, textKey = "GUIDE_TIP_370" },
			{ spell = 167105, textKey = "GUIDE_TIP_371" },
			{ spell = 5308, textKey = "GUIDE_TIP_372" },
			{ spell = 227847, textKey = "GUIDE_TIP_373" },
			{ spell = 1464, textKey = "GUIDE_TIP_374" },
			{ spell = 118038, textKey = "GUIDE_TIP_375" },
			{ spell = 6552, textKey = "GUIDE_TIP_376" },
			{ spell = 107570, textKey = "GUIDE_TIP_377" },
			{ spell = 100, textKey = "GUIDE_TIP_378" },
		},
		stats = "GUIDE_STATS_WARRIOR_ARMS",
		gear = {
			"GUIDE_GEAR_WARRIOR_ARMS_1",
			"GUIDE_GEAR_WARRIOR_ARMS_2",
			"GUIDE_GEAR_WARRIOR_ARMS_3",
			"GUIDE_GEAR_WARRIOR_ARMS_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222772, 242296 },
			flask = { 241322, 241326, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_10_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_10_ROT_2",
					"GUIDE_ADVISOR_WARRIOR_ARMS_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_10_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_10_DEF_2",
					"GUIDE_ADVISOR_WARRIOR_ARMS_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_10_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_30_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_30_ROT_2",
					"GUIDE_ADVISOR_WARRIOR_ARMS_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_30_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_30_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_60_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_60_ROT_2",
					"GUIDE_ADVISOR_WARRIOR_ARMS_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_60_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_60_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_80_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_80_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_ARMS_80_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_ARMS_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.20, 0.10, 0.08, 0.92 },
			topBar = { 0.38, 0.16, 0.12, 0.95 },
			titleColor = { 0.95, 0.72, 0.62 },
			sectionBar = { 0.46, 0.20, 0.14, 0.9 },
			sectionText = { 0.98, 0.88, 0.82 },
			icyBackdrop = { 0.24, 0.12, 0.10, 0.85 },
			icyBorder = { 0.82, 0.42, 0.34, 0.9 },
			icyTitleColor = { 0.96, 0.78, 0.68 },
			ebBg = { 0.18, 0.10, 0.08, 0.95 },
		},
	},
	[2] = {
		title = "Fury Warrior Guide",
		icyTitle = "Icy Veins — Fury Warrior leveling",
		link = "https://www.icy-veins.com/wow/fury-warrior-leveling-guide",
		tips = {
			{ spell = 184367, textKey = "GUIDE_TIP_379" },
			{ spell = 23881, textKey = "GUIDE_TIP_380" },
			{ spell = 85288, textKey = "GUIDE_TIP_381" },
			{ spell = 5308, textKey = "GUIDE_TIP_382" },
			{ spell = 1719, textKey = "GUIDE_TIP_383" },
			{ spell = 1680, textKey = "GUIDE_TIP_384" },
			{ spell = 184364, textKey = "GUIDE_TIP_385" },
			{ spell = 6552, textKey = "GUIDE_TIP_386" },
			{ spell = 12323, textKey = "GUIDE_TIP_387" },
			{ spell = 6544, textKey = "GUIDE_TIP_388" },
		},
		stats = "GUIDE_STATS_WARRIOR_FURY",
		gear = {
			"GUIDE_GEAR_WARRIOR_FURY_1",
			"GUIDE_GEAR_WARRIOR_FURY_2",
			"GUIDE_GEAR_WARRIOR_FURY_3",
			"GUIDE_GEAR_WARRIOR_FURY_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222772, 242296 },
			flask = { 241322, 241326, 241327 },
			potion = { 241308, 241289 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_FURY_10_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_10_ROT_2",
					"GUIDE_ADVISOR_WARRIOR_FURY_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_FURY_10_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_10_DEF_2",
					"GUIDE_ADVISOR_WARRIOR_FURY_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_FURY_10_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_FURY_30_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_30_ROT_2",
					"GUIDE_ADVISOR_WARRIOR_FURY_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_FURY_30_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_FURY_30_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_FURY_60_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_60_ROT_2",
					"GUIDE_ADVISOR_WARRIOR_FURY_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_FURY_60_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_FURY_60_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_FURY_80_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_FURY_80_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_FURY_80_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_FURY_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.22, 0.06, 0.06, 0.92 },
			topBar = { 0.46, 0.10, 0.10, 0.95 },
			titleColor = { 1.0, 0.62, 0.62 },
			sectionBar = { 0.54, 0.14, 0.14, 0.9 },
			sectionText = { 1.0, 0.84, 0.84 },
			icyBackdrop = { 0.26, 0.08, 0.08, 0.85 },
			icyBorder = { 0.94, 0.24, 0.24, 0.9 },
			icyTitleColor = { 1.0, 0.68, 0.68 },
			ebBg = { 0.18, 0.06, 0.06, 0.95 },
		},
	},
	[3] = {
		title = "Protection Warrior Guide",
		icyTitle = "Icy Veins — Protection Warrior leveling",
		link = "https://www.icy-veins.com/wow/protection-warrior-leveling-guide",
		tips = {
			{ spell = 23922, textKey = "GUIDE_TIP_389" },
			{ spell = 6343, textKey = "GUIDE_TIP_390" },
			{ spell = 6572, textKey = "GUIDE_TIP_391" },
			{ spell = 2565, textKey = "GUIDE_TIP_392" },
			{ spell = 190456, textKey = "GUIDE_TIP_393" },
			{ spell = 107574, textKey = "GUIDE_TIP_394" },
			{ spell = 871, textKey = "GUIDE_TIP_395" },
			{ spell = 12975, textKey = "GUIDE_TIP_396" },
			{ spell = 6552, textKey = "GUIDE_TIP_397" },
			{ spell = 198304, textKey = "GUIDE_TIP_398" },
		},
		stats = "GUIDE_STATS_WARRIOR_PROTECTION",
		gear = {
			"GUIDE_GEAR_WARRIOR_PROT_1",
			"GUIDE_GEAR_WARRIOR_PROT_2",
			"GUIDE_GEAR_WARRIOR_PROT_3",
			"GUIDE_GEAR_WARRIOR_PROT_4",
		},
		consumables = {
			feast = { 255845, 255846 },
			food = { 222772, 242296 },
			flask = { 241326, 241322 },
			potion = { 191371, 241308 },
			weaponOil = 243734,
			rune = 259085,
		},
		leveling = {
			[10] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_10_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_10_ROT_2",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_10_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_10_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_10_DEF_2",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_10_DEF_3",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_10_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_10_TAL_2",
				},
			},
			[30] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_30_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_30_ROT_2",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_30_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_30_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_30_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_30_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_30_TAL_2",
				},
			},
			[60] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_60_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_60_ROT_2",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_60_ROT_3",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_60_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_60_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_60_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_60_TAL_2",
				},
			},
			[80] = {
				rotation = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_80_ROT_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_80_ROT_2",
				},
				defensives = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_80_DEF_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_80_DEF_2",
				},
				talentFocus = {
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_80_TAL_1",
					"GUIDE_ADVISOR_WARRIOR_PROTECTION_80_TAL_2",
				},
			},
		},
		theme = {
			tint = { 0.14, 0.14, 0.14, 0.92 },
			topBar = { 0.28, 0.28, 0.28, 0.95 },
			titleColor = { 0.90, 0.90, 0.90 },
			sectionBar = { 0.34, 0.34, 0.34, 0.9 },
			sectionText = { 0.96, 0.96, 0.96 },
			icyBackdrop = { 0.16, 0.16, 0.16, 0.85 },
			icyBorder = { 0.72, 0.72, 0.72, 0.9 },
			icyTitleColor = { 0.92, 0.92, 0.92 },
			ebBg = { 0.12, 0.12, 0.12, 0.95 },
		},
	},
}
