--[[
	GroupPlan.lua — the fifth "How you play" tab, "Group": buttons you press FOR SOMEONE ELSE
	(ally-target) or for the whole group, in plain words.

	3 Oct 2026. Proposed by the play-card audit (docs/playcards_audit_2026-10-03/), sketched for
	Prot Paladin, approved by Rob ("E en G zijn goedgekeurd"; tab name "Group" / "Groep").

	📌 OWN DATA, NOT KeybindRoles TAGS. Every matched KeybindRoles entry is handed to the key
	allocator (KeybindAutoMap.lua), so tagging new spells there could move binds, and most group
	spells of other classes are name-only there (a name only resolves out of your own spellbook).
	Here every row carries a CONFIRMED spell id. Ownership and the displayed name go through the
	same check as "Stay alive" (ns.SurvivalLiveName: IsPlayerSpell on the base, skip passives,
	show the override name), so an untalented spell drops off by itself.

	📌 A SPEC WITHOUT ROWS GETS NO TAB. The brief: "leave the tab out with a reason, never show it
	empty" (an empty-but-present box reads as advice). `/mh group` prints, per row, shown or why not.

	Row fields: step ("save" | "heal" | "free" | "raid" | "boost" | "rez"), id (spell id), name
	(English fallback for the trace only), note (optional locale key, a short remark), pet + alt
	(a pet's spell: checked in the pet spellbook, alt = the id as the hunter casts it). Rows are
	drawn in GROUP_STEPS order, then in list order.

	Data for every other spec: four mh-research rounds of 3 Oct 2026 (Wowhead tooltips read that
	day for every id, guides dated per spec in `source`). Talent choices (Intervene/Interpose,
	Revival/Restoral, Bloodlust/Heroism by faction) are listed both ways: the ownership check shows
	the one you have. No tab for Demon Hunter (only Darkness) and Rogue (Shroud is out of combat
	only, Tricks is a talent choice) - research advice, Rob may change it.
]]

local _, ns = ...

local GROUP_STEPS = {
	{ step = "save", key = "GROUP_STEP_SAVE" },
	{ step = "heal", key = "GROUP_STEP_HEAL" },
	{ step = "free", key = "GROUP_STEP_FREE" },
	{ step = "raid", key = "GROUP_STEP_RAID" },
	{ step = "boost", key = "GROUP_STEP_BOOST" },
	{ step = "rez", key = "GROUP_STEP_REZ" },
}

--- Per spec: source line (guides + dates) and rows. Research files: scratchpad cards\group_*.json.
ns.GROUP_PLAN = {
	-- Protection Paladin. Icy Veins 21 Aug + 21 Sep · Method 3 Sep · Wowhead 12 Aug 2026 (sketch, 3 Oct).
	[66] = {
		source = "Icy Veins 21 Aug + 21 Sep · Method 3 Sep · Wowhead 12 Aug 2026",
		rows = {
			{ step = "save", id = 6940, name = "Blessing of Sacrifice", note = "GROUP_NOTE_SAC" },
			{ step = "save", id = 1022, name = "Blessing of Protection", note = "GROUP_NOTE_BOP" },
			{ step = "save", id = 204018, name = "Blessing of Spellwarding", note = "GROUP_NOTE_SPELLWARD" },
			{ step = "heal", id = 85673, name = "Word of Glory", note = "GROUP_NOTE_WOG_OTHER" },
			{ step = "heal", id = 633, name = "Lay on Hands", note = "GROUP_NOTE_LOH" },
			{ step = "free", id = 1044, name = "Blessing of Freedom" },
			{ step = "raid", id = 465, name = "Devotion Aura", note = "GROUP_NOTE_AURA" },
			-- 391054: the id Rob's own client holds on his paladin's bar (SavedVariables, slot 63).
			{ step = "rez", id = 391054, name = "Intercession", note = "GROUP_NOTE_BREZ" },
			{ step = "rez", id = 7328, name = "Redemption", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Arms Warrior.
	[71] = {
		source = "Icy Veins 10 + 25 Aug · Method 25 Sep 2026",
		rows = {
			{ step = "save", id = 3411, name = "Intervene", note = "GROUP_NOTE_INTERVENE" },
			{ step = "save", id = 1244088, name = "Interpose", note = "GROUP_NOTE_INTERPOSE" },
			{ step = "free", id = 384100, name = "Berserker Shout", note = "GROUP_NOTE_BERSERKER_SHOUT" },
			{ step = "raid", id = 97462, name = "Rallying Cry", note = "GROUP_NOTE_RALLYING_CRY" },
		},
	},
	-- Fury Warrior.
	[72] = {
		source = "Icy Veins 10 + 25 Aug · Method 11 Aug · Wowhead 12 Aug 2026",
		rows = {
			{ step = "save", id = 3411, name = "Intervene", note = "GROUP_NOTE_INTERVENE" },
			{ step = "save", id = 1244088, name = "Interpose", note = "GROUP_NOTE_INTERPOSE" },
			{ step = "free", id = 384100, name = "Berserker Shout", note = "GROUP_NOTE_BERSERKER_SHOUT" },
			{ step = "raid", id = 97462, name = "Rallying Cry", note = "GROUP_NOTE_RALLYING_CRY" },
		},
	},
	-- Protection Warrior.
	[73] = {
		source = "Icy Veins 10 Aug + 10 Sep 2026",
		rows = {
			{ step = "save", id = 3411, name = "Intervene", note = "GROUP_NOTE_INTERVENE_2" },
			{ step = "free", id = 384100, name = "Berserker Shout", note = "GROUP_NOTE_BERSERKER_SHOUT" },
			{ step = "raid", id = 97462, name = "Rallying Cry", note = "GROUP_NOTE_RALLYING_CRY" },
		},
	},
	-- Blood Death Knight.
	[250] = {
		source = "Icy Veins 10 Aug · Wowhead 18 Aug 2026",
		rows = {
			{ step = "raid", id = 51052, name = "Anti-Magic Zone", note = "GROUP_NOTE_ANTI_MAGIC_ZONE" },
			{ step = "rez", id = 61999, name = "Raise Ally", note = "GROUP_NOTE_RAISE_ALLY" },
		},
	},
	-- Frost Death Knight.
	[251] = {
		source = "Icy Veins 14 Sep 2026",
		rows = {
			{ step = "raid", id = 51052, name = "Anti-Magic Zone", note = "GROUP_NOTE_ANTI_MAGIC_ZONE" },
			{ step = "rez", id = 61999, name = "Raise Ally", note = "GROUP_NOTE_RAISE_ALLY_2" },
		},
	},
	-- Unholy Death Knight.
	[252] = {
		source = "Icy Veins 8 Sep 2026",
		rows = {
			{ step = "raid", id = 51052, name = "Anti-Magic Zone", note = "GROUP_NOTE_ANTI_MAGIC_ZONE" },
			{ step = "rez", id = 61999, name = "Raise Ally", note = "GROUP_NOTE_RAISE_ALLY_2" },
		},
	},
	-- 577 Havoc Demon Hunter: NO TAB (Demon Hunter: only Darkness).
	-- 581 Vengeance Demon Hunter: NO TAB (Demon Hunter: only Darkness).
	-- 1480 Devourer Demon Hunter: NO TAB (Demon Hunter: only Darkness).
	-- Balance Druid.
	[102] = {
		source = "Method 15 Aug + 1 Oct · Wowhead 18 Aug · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "raid", id = 106898, name = "Stampeding Roar", note = "GROUP_NOTE_STAMPEDING_ROAR" },
			{ step = "boost", id = 29166, name = "Innervate", note = "GROUP_NOTE_INNERVATE" },
			{ step = "rez", id = 20484, name = "Rebirth", note = "GROUP_NOTE_REBIRTH" },
			{ step = "rez", id = 50769, name = "Revive", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Feral Druid.
	[103] = {
		source = "Method 1 Oct · Wowhead 18 Aug · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "raid", id = 106898, name = "Stampeding Roar", note = "GROUP_NOTE_STAMPEDING_ROAR_2" },
			{ step = "boost", id = 29166, name = "Innervate", note = "GROUP_NOTE_INNERVATE" },
			{ step = "rez", id = 20484, name = "Rebirth", note = "GROUP_NOTE_REBIRTH" },
			{ step = "rez", id = 50769, name = "Revive", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Guardian Druid.
	[104] = {
		source = "Method 3 Sep · Wowhead 18 Aug · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "raid", id = 106898, name = "Stampeding Roar", note = "GROUP_NOTE_STAMPEDING_ROAR_2" },
			{ step = "boost", id = 29166, name = "Innervate", note = "GROUP_NOTE_INNERVATE" },
			{ step = "rez", id = 20484, name = "Rebirth", note = "GROUP_NOTE_REBIRTH_2" },
			{ step = "rez", id = 50769, name = "Revive", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Restoration Druid.
	[105] = {
		source = "Method 13 Sep · Wowhead 18 Aug · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "save", id = 102342, name = "Ironbark", note = "GROUP_NOTE_IRONBARK" },
			{ step = "heal", id = 132158, name = "Nature's Swiftness", note = "GROUP_NOTE_NATURE_S_SWIFTNESS" },
			{ step = "raid", id = 740, name = "Tranquility", note = "GROUP_NOTE_TRANQUILITY" },
			{ step = "raid", id = 106898, name = "Stampeding Roar", note = "GROUP_NOTE_STAMPEDING_ROAR" },
			{ step = "rez", id = 20484, name = "Rebirth", note = "GROUP_NOTE_REBIRTH" },
			{ step = "rez", id = 50769, name = "Revive", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Brewmaster Monk.
	[268] = {
		source = "Method 27 Aug + 11 Aug · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "free", id = 116841, name = "Tiger's Lust", note = "GROUP_NOTE_TIGER_S_LUST" },
			{ step = "rez", id = 115178, name = "Resuscitate", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Windwalker Monk.
	[269] = {
		source = "Method 27 Aug · Icy Veins 11 Aug 2026",
		rows = {
			{ step = "free", id = 116841, name = "Tiger's Lust", note = "GROUP_NOTE_TIGER_S_LUST" },
			{ step = "rez", id = 115178, name = "Resuscitate", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Mistweaver Monk.
	[270] = {
		source = "Method 27 Aug · Icy Veins 12 Aug 2026",
		rows = {
			{ step = "save", id = 116849, name = "Life Cocoon", note = "GROUP_NOTE_LIFE_COCOON" },
			{ step = "free", id = 116841, name = "Tiger's Lust", note = "GROUP_NOTE_TIGER_S_LUST" },
			{ step = "raid", id = 115310, name = "Revival", note = "GROUP_NOTE_REVIVAL" },
			{ step = "raid", id = 388615, name = "Restoral", note = "GROUP_NOTE_RESTORAL" },
			{ step = "raid", id = 322118, name = "Invoke Yu'lon, the Jade Serpent", note = "GROUP_NOTE_YU_LON_THE_JADE_SERPEN" },
			{ step = "raid", id = 325197, name = "Invoke Chi-Ji, the Red Crane", note = "GROUP_NOTE_CHI_JI_THE_RED_CRANE" },
			{ step = "rez", id = 115178, name = "Resuscitate", note = "GROUP_NOTE_OOC" },
			{ step = "rez", id = 212051, name = "Reawaken", note = "GROUP_NOTE_REAWAKEN" },
		},
	},
	-- Devastation Evoker.
	[1467] = {
		source = "Method 25 Aug + 20 Aug · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "free", id = 370665, name = "Rescue", note = "GROUP_NOTE_RESCUE" },
			{ step = "raid", id = 374227, name = "Zephyr", note = "GROUP_NOTE_ZEPHYR" },
			{ step = "raid", id = 374968, name = "Time Spiral", note = "GROUP_NOTE_TIME_SPIRAL" },
			{ step = "boost", id = 390386, name = "Fury of the Aspects", note = "GROUP_NOTE_FURY_OF_THE_ASPECTS" },
			{ step = "boost", id = 369459, name = "Source of Magic", note = "GROUP_NOTE_SOURCE_OF_MAGIC" },
			{ step = "boost", id = 406732, name = "Spatial Paradox", note = "GROUP_NOTE_SPATIAL_PARADOX" },
			{ step = "rez", id = 361227, name = "Return", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Preservation Evoker.
	[1468] = {
		source = "Method 20 Aug · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "save", id = 357170, name = "Time Dilation", note = "GROUP_NOTE_TIME_DILATION" },
			{ step = "free", id = 370665, name = "Rescue", note = "GROUP_NOTE_RESCUE" },
			{ step = "raid", id = 363534, name = "Rewind", note = "GROUP_NOTE_REWIND" },
			{ step = "raid", id = 359816, name = "Dream Flight", note = "GROUP_NOTE_DREAM_FLIGHT" },
			{ step = "raid", id = 374227, name = "Zephyr", note = "GROUP_NOTE_ZEPHYR" },
			{ step = "boost", id = 390386, name = "Fury of the Aspects", note = "GROUP_NOTE_FURY_OF_THE_ASPECTS" },
			{ step = "boost", id = 369459, name = "Source of Magic", note = "GROUP_NOTE_SOURCE_OF_MAGIC_2" },
			{ step = "rez", id = 361227, name = "Return", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Augmentation Evoker.
	[1473] = {
		source = "Method 25 Aug + 20 Aug · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "save", id = 360827, name = "Blistering Scales", note = "GROUP_NOTE_BLISTERING_SCALES" },
			{ step = "free", id = 370665, name = "Rescue", note = "GROUP_NOTE_RESCUE" },
			{ step = "raid", id = 374227, name = "Zephyr", note = "GROUP_NOTE_ZEPHYR" },
			{ step = "raid", id = 374968, name = "Time Spiral", note = "GROUP_NOTE_TIME_SPIRAL" },
			{ step = "boost", id = 390386, name = "Fury of the Aspects", note = "GROUP_NOTE_FURY_OF_THE_ASPECTS" },
			{ step = "boost", id = 369459, name = "Source of Magic", note = "GROUP_NOTE_SOURCE_OF_MAGIC" },
			{ step = "boost", id = 406732, name = "Spatial Paradox", note = "GROUP_NOTE_SPATIAL_PARADOX" },
			{ step = "rez", id = 361227, name = "Return", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Elemental Shaman.
	[262] = {
		source = "Icy Veins 10 Aug + 26 Aug · Method 1 Sep 2026",
		rows = {
			{ step = "free", id = 8143, name = "Tremor Totem", note = "GROUP_NOTE_TREMOR_TOTEM" },
			{ step = "raid", id = 192077, name = "Wind Rush Totem", note = "GROUP_NOTE_WIND_RUSH_TOTEM" },
			{ step = "boost", id = 2825, name = "Bloodlust", note = "GROUP_NOTE_BLOODLUST" },
			{ step = "boost", id = 32182, name = "Heroism", note = "GROUP_NOTE_HEROISM" },
			{ step = "rez", id = 2008, name = "Ancestral Spirit", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Enhancement Shaman.
	[263] = {
		source = "Icy Veins 10 Aug + 23 Aug + 26 Aug 2026",
		rows = {
			{ step = "free", id = 8143, name = "Tremor Totem", note = "GROUP_NOTE_TREMOR_TOTEM" },
			{ step = "raid", id = 192077, name = "Wind Rush Totem", note = "GROUP_NOTE_WIND_RUSH_TOTEM" },
			{ step = "boost", id = 2825, name = "Bloodlust", note = "GROUP_NOTE_BLOODLUST" },
			{ step = "boost", id = 32182, name = "Heroism", note = "GROUP_NOTE_HEROISM" },
			{ step = "rez", id = 2008, name = "Ancestral Spirit", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Restoration Shaman.
	[264] = {
		source = "Icy Veins 10 Aug + 1 Sep + 2 Sep · Method 11 Aug · Wowhead 12 Aug 2026",
		rows = {
			{ step = "free", id = 8143, name = "Tremor Totem", note = "GROUP_NOTE_TREMOR_TOTEM" },
			{ step = "raid", id = 98008, name = "Spirit Link Totem", note = "GROUP_NOTE_SPIRIT_LINK_TOTEM" },
			{ step = "raid", id = 108280, name = "Healing Tide Totem", note = "GROUP_NOTE_HEALING_TIDE_TOTEM" },
			{ step = "raid", id = 192077, name = "Wind Rush Totem", note = "GROUP_NOTE_WIND_RUSH_TOTEM" },
			{ step = "boost", id = 2825, name = "Bloodlust", note = "GROUP_NOTE_BLOODLUST" },
			{ step = "boost", id = 32182, name = "Heroism", note = "GROUP_NOTE_HEROISM" },
			{ step = "rez", id = 2008, name = "Ancestral Spirit", note = "GROUP_NOTE_OOC" },
			{ step = "rez", id = 212048, name = "Ancestral Vision", note = "GROUP_NOTE_ANCESTRAL_VISION" },
		},
	},
	-- Discipline Priest.
	[256] = {
		source = "Icy Veins 10 Aug · Method 17 Sep 2026",
		rows = {
			{ step = "save", id = 33206, name = "Pain Suppression" },
			{ step = "save", id = 73325, name = "Leap of Faith", note = "GROUP_NOTE_LEAP_OF_FAITH" },
			{ step = "raid", id = 62618, name = "Power Word: Barrier", note = "GROUP_NOTE_POWER_WORD_BARRIER" },
			{ step = "boost", id = 10060, name = "Power Infusion", note = "GROUP_NOTE_POWER_INFUSION" },
			{ step = "rez", id = 2006, name = "Resurrection", note = "GROUP_NOTE_OOC" },
			{ step = "rez", id = 212036, name = "Mass Resurrection", note = "GROUP_NOTE_ANCESTRAL_VISION" },
		},
	},
	-- Holy Priest.
	[257] = {
		source = "Icy Veins 10 Aug · Method 17 Sep · Wowhead 12 Aug 2026",
		rows = {
			{ step = "save", id = 47788, name = "Guardian Spirit", note = "GROUP_NOTE_GUARDIAN_SPIRIT" },
			{ step = "save", id = 73325, name = "Leap of Faith", note = "GROUP_NOTE_LEAP_OF_FAITH" },
			{ step = "raid", id = 64843, name = "Divine Hymn", note = "GROUP_NOTE_DIVINE_HYMN" },
			{ step = "boost", id = 10060, name = "Power Infusion", note = "GROUP_NOTE_POWER_INFUSION" },
			{ step = "rez", id = 2006, name = "Resurrection", note = "GROUP_NOTE_OOC" },
			{ step = "rez", id = 212036, name = "Mass Resurrection", note = "GROUP_NOTE_ANCESTRAL_VISION" },
		},
	},
	-- Shadow Priest.
	[258] = {
		source = "Icy Veins 10 Aug · Method 27 Aug 2026",
		rows = {
			{ step = "save", id = 73325, name = "Leap of Faith", note = "GROUP_NOTE_LEAP_OF_FAITH" },
			{ step = "heal", id = 15286, name = "Vampiric Embrace", note = "GROUP_NOTE_VAMPIRIC_EMBRACE" },
			{ step = "boost", id = 10060, name = "Power Infusion", note = "GROUP_NOTE_POWER_INFUSION_2" },
			{ step = "rez", id = 2006, name = "Resurrection", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Affliction Warlock.
	[265] = {
		source = "Icy Veins 10 Aug + 31 Aug · Wowhead 21 Aug 2026",
		rows = {
			{ step = "raid", id = 111771, name = "Demonic Gateway", note = "GROUP_NOTE_DEMONIC_GATEWAY" },
			{ step = "raid", id = 29893, name = "Create Soulwell", note = "GROUP_NOTE_CREATE_SOULWELL" },
			{ step = "rez", id = 20707, name = "Soulstone", note = "GROUP_NOTE_SOULSTONE" },
		},
	},
	-- Demonology Warlock.
	[266] = {
		source = "Icy Veins 10 Aug + 31 Aug · Wowhead 21 Aug 2026",
		rows = {
			{ step = "raid", id = 111771, name = "Demonic Gateway", note = "GROUP_NOTE_DEMONIC_GATEWAY" },
			{ step = "raid", id = 29893, name = "Create Soulwell", note = "GROUP_NOTE_CREATE_SOULWELL" },
			{ step = "rez", id = 20707, name = "Soulstone", note = "GROUP_NOTE_SOULSTONE" },
		},
	},
	-- Destruction Warlock.
	[267] = {
		source = "Icy Veins 10 Aug · Method 15 Aug 2026",
		rows = {
			{ step = "raid", id = 111771, name = "Demonic Gateway", note = "GROUP_NOTE_DEMONIC_GATEWAY" },
			{ step = "raid", id = 29893, name = "Create Soulwell", note = "GROUP_NOTE_CREATE_SOULWELL" },
			{ step = "rez", id = 20707, name = "Soulstone", note = "GROUP_NOTE_SOULSTONE" },
		},
	},
	-- Holy Paladin.
	[65] = {
		source = "Icy Veins 10 Aug · Method 27 Aug 2026",
		rows = {
			{ step = "save", id = 6940, name = "Blessing of Sacrifice", note = "GROUP_NOTE_SAC" },
			{ step = "save", id = 1022, name = "Blessing of Protection", note = "GROUP_NOTE_PROTECTION" },
			{ step = "heal", id = 633, name = "Lay on Hands", note = "GROUP_NOTE_LAY_ON_HANDS" },
			{ step = "free", id = 1044, name = "Blessing of Freedom" },
			{ step = "raid", id = 31821, name = "Aura Mastery", note = "GROUP_NOTE_AURA_MASTERY" },
			{ step = "raid", id = 465, name = "Devotion Aura", note = "GROUP_NOTE_AURA" },
			{ step = "rez", id = 391054, name = "Intercession", note = "GROUP_NOTE_INTERCESSION" },
			{ step = "rez", id = 7328, name = "Redemption", note = "GROUP_NOTE_OOC" },
			{ step = "rez", id = 212056, name = "Absolution", note = "GROUP_NOTE_ABSOLUTION" },
		},
	},
	-- Retribution Paladin.
	[70] = {
		source = "Icy Veins 25 Aug · Method 27 Aug 2026",
		rows = {
			{ step = "save", id = 6940, name = "Blessing of Sacrifice", note = "GROUP_NOTE_SAC" },
			{ step = "save", id = 1022, name = "Blessing of Protection", note = "GROUP_NOTE_PROTECTION" },
			{ step = "heal", id = 633, name = "Lay on Hands", note = "GROUP_NOTE_LAY_ON_HANDS_2" },
			{ step = "heal", id = 85673, name = "Word of Glory", note = "GROUP_NOTE_WORD_OF_GLORY" },
			{ step = "free", id = 1044, name = "Blessing of Freedom" },
			{ step = "raid", id = 465, name = "Devotion Aura", note = "GROUP_NOTE_AURA" },
			{ step = "rez", id = 391054, name = "Intercession", note = "GROUP_NOTE_INTERCESSION" },
			{ step = "rez", id = 7328, name = "Redemption", note = "GROUP_NOTE_OOC" },
		},
	},
	-- Arcane Mage.
	[62] = {
		source = "Icy Veins 10 Aug 2026 · Wowhead",
		rows = {
			{ step = "raid", id = 414664, name = "Mass Invisibility", note = "GROUP_NOTE_MASS_INVISIBILITY" },
			{ step = "boost", id = 80353, name = "Time Warp", note = "GROUP_NOTE_TIME_WARP" },
		},
	},
	-- Fire Mage.
	[63] = {
		source = "Icy Veins 10 Aug 2026 · Wowhead",
		rows = {
			{ step = "raid", id = 414664, name = "Mass Invisibility", note = "GROUP_NOTE_MASS_INVISIBILITY" },
			{ step = "boost", id = 80353, name = "Time Warp", note = "GROUP_NOTE_TIME_WARP" },
		},
	},
	-- Frost Mage.
	[64] = {
		source = "Wowhead · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "raid", id = 414664, name = "Mass Invisibility", note = "GROUP_NOTE_MASS_INVISIBILITY" },
			{ step = "boost", id = 80353, name = "Time Warp", note = "GROUP_NOTE_TIME_WARP" },
		},
	},
	-- 259 Assassination Rogue: NO TAB (Rogue: Shroud is out of combat only, Tricks is a talent choice (research advice: hide)).
	-- 260 Outlaw Rogue: NO TAB (Rogue: same as Assassination).
	-- 261 Subtlety Rogue: NO TAB (Rogue: same as Assassination).
	-- Beast Mastery Hunter.
	[253] = {
		source = "Method 5 Sep · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "save", id = 53480, name = "Roar of Sacrifice", note = "GROUP_NOTE_ROAR_OF_SACRIFICE" },
			{ step = "free", id = 53271, name = "Master's Call", pet = true, alt = { 272682 }, note = "GROUP_NOTE_MASTER_S_CALL" },
			{ step = "boost", id = 264667, name = "Primal Rage", pet = true, alt = { 272678 }, note = "GROUP_NOTE_PRIMAL_RAGE" },
			{ step = "boost", id = 34477, name = "Misdirection", note = "GROUP_NOTE_MISDIRECTION" },
		},
	},
	-- Marksmanship Hunter.
	[254] = {
		source = "Method 5 Sep · Icy Veins 10 + 22 Aug 2026",
		rows = {
			{ step = "save", id = 53480, name = "Roar of Sacrifice", note = "GROUP_NOTE_ROAR_OF_SACRIFICE_2" },
			{ step = "boost", id = 466904, name = "Harrier's Cry", note = "GROUP_NOTE_TIME_WARP" },
			{ step = "boost", id = 34477, name = "Misdirection", note = "GROUP_NOTE_MISDIRECTION" },
		},
	},
	-- Survival Hunter.
	[255] = {
		source = "Method 3 Sep · Icy Veins 10 Aug 2026",
		rows = {
			{ step = "save", id = 53480, name = "Roar of Sacrifice", note = "GROUP_NOTE_ROAR_OF_SACRIFICE" },
			{ step = "free", id = 53271, name = "Master's Call", pet = true, alt = { 272682 }, note = "GROUP_NOTE_MASTER_S_CALL" },
			{ step = "boost", id = 264667, name = "Primal Rage", pet = true, alt = { 272678 }, note = "GROUP_NOTE_PRIMAL_RAGE" },
			{ step = "boost", id = 34477, name = "Misdirection", note = "GROUP_NOTE_MISDIRECTION" },
		},
	},
}

--- True when this spec has group data at all (decides whether the tab exists).
function ns.HasGroupPlan(specID)
	local d = specID and ns.GROUP_PLAN[specID]
	return d ~= nil and type(d.rows) == "table" and #d.rows > 0
end

function ns.GetGroupPlanSource(specID)
	local d = specID and ns.GROUP_PLAN[specID]
	return d and d.source or nil
end

--- A pet's spell (Primal Rage, Master's Call) sits in the PET spellbook, where IsPlayerSpell says no.
--- Same check GroupRezLust.lua already uses: IsSpellKnown(id, true). Tries the row id, then `alt`.
local function PetName(row)
	local ids = { row.id }
	for _, a in ipairs(row.alt or {}) do
		ids[#ids + 1] = a
	end
	local isk = rawget(_G, "IsSpellKnown")
	for _, id in ipairs(ids) do
		local known = false
		if type(isk) == "function" then
			local ok, v = pcall(isk, id, true)
			known = ok and v == true
		end
		if not known and IsPlayerSpell then
			local ok, v = pcall(IsPlayerSpell, id)
			known = ok and v == true
		end
		if known then
			local name = row.name
			if C_Spell and C_Spell.GetSpellName then
				local ok, n = pcall(C_Spell.GetSpellName, id)
				if ok and type(n) == "string" and n ~= "" then
					name = n
				end
			end
			return name, id
		end
	end
	return nil, "not in your or your pet's spellbook (" .. tostring(row.id) .. "); needs the right pet type"
end

--- @return table|nil steps  { { text, spellID, whenKey, noteKey }, ... } — same shape as Stay alive.
function ns.GetGroupPlan(specID, trace)
	local d = specID and ns.GROUP_PLAN[specID]
	if not d or type(d.rows) ~= "table" then
		return nil
	end
	local steps, already = {}, {}
	for _, gs in ipairs(GROUP_STEPS) do
		for _, row in ipairs(d.rows) do
			if row.step == gs.step then
				local name, idOrWhy
				if row.pet then
					name, idOrWhy = PetName(row)
				elseif ns.SurvivalLiveName then
					name, idOrWhy = ns.SurvivalLiveName(row.name, { id = row.id }, specID)
				else
					name, idOrWhy = row.name, row.id
				end
				local id = name and idOrWhy or nil
				local dedupe = id or name
				local shown = name and not already[dedupe]
				if shown then
					already[dedupe] = true
					steps[#steps + 1] = { text = name, spellID = id, whenKey = gs.key, noteKey = row.note }
				end
				if trace then
					trace[#trace + 1] = {
						key = row.name .. " (" .. tostring(row.id) .. ")",
						step = gs.step,
						shown = shown and true or false,
						why = shown and "" or (name and "same spell already listed") or idOrWhy,
					}
				end
			end
		end
	end
	return #steps > 0 and steps or nil
end

--- `/mh group` — what the Group tab shows for your spec, and why each row is in or out.
function ns.PrintGroupPlanTrace()
	local specID
	if ns.GetSpecialization and ns.GetSpecializationInfo then
		local idx = ns.GetSpecialization()
		specID = idx and ns.GetSpecializationInfo(idx) or nil
	end
	local prefix = ("|cffffcc00%s|r "):format(ns:L("PRINT_PREFIX"))
	if not ns.HasGroupPlan(specID) then
		print(prefix .. ("Group tab, spec %s: no group list yet, so the tab is hidden."):format(tostring(specID)))
		return
	end
	local trace = {}
	ns.GetGroupPlan(specID, trace)
	print(prefix .. ("Group tab, spec %s:"):format(tostring(specID)))
	for _, t in ipairs(trace) do
		print(("  %s %s |cff9d9d9d[%s]|r %s"):format(
			t.shown and "|cff40ff40+|r" or "|cffff8080-|r", t.key, t.step or "-", t.why or ""))
	end
end
