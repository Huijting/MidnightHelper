local _, ns = ...

--[[
	The "Solo" tab of How you play, for the seven healer specs: how to play a delve or the Labyrinth on your own, with
	Valeera, when you have never healed before.

	Rob, 25 Oct 2026, on his Resto Druid in the Labyrinth: "Is het niet een eenvoudige lijstje even voor mij hier te maken
	… Klik eerst dit, dan dat, dan zus" → "Ja, maak een Solo-stuk voor alle 7 healers". He tried the cheat sheet in game
	first and it worked (Symbiotic Relationship on Valeera; it cannot target yourself).

	Four blocks per spec: before the fight, attack, heal with your clicks, when it goes wrong. The attack block is NOT here:
	it is ns.HealerSoloSteps (HealerSolo.lua), the same list the key block and the website use, so they cannot disagree.

	Facts: mh-research 25 Oct 2026 (wago 12.1.5.70575 + Icy Veins / Wowhead / Method delve builds of 12-24 Oct), reports
	solo_healers_A/B_2026-10-25.md in the side-session notes. Every spell id is measured for its spec in that build.

	Rows:
	  { id = spellId, key = "SOLO_..." }  a spell, its icon and name from the client;
	  { code = "M", key = "SOLO_..." }   one of the spec's clicks (ClickCast.lua): the spell and the click label come from
	                                      the layout, so the two can never drift apart.
	A spell this character does not know is shown grey, like on the Clicks tab: a talent you did not take.
]]

ns.HEALER_SOLO_GUIDE = {
	[105] = { -- Restoration Druid
		pre = {
			{ code = "M", key = "SOLO_105_PRE_LIFEBLOOM" },
			{ code = "SM", key = "SOLO_105_PRE_SYMBIOTIC" },
			{ id = 1126, key = "SOLO_105_PRE_MOTW" }, -- Mark of the Wild
		},
		move = "SOLO_105_MOVE",
		heal = {
			{ code = "L", key = "SOLO_105_H_L" },
			{ code = "R", key = "SOLO_105_H_R" },
			{ code = "CR", key = "SOLO_105_H_CR" },
			{ code = "AL", key = "SOLO_105_H_AL" },
		},
		bad = {
			{ id = 22812, key = "SOLO_105_BAD_BARKSKIN" }, -- Barkskin
			{ code = "CM", key = "SOLO_105_BAD_IRONBARK" },
			{ id = 132158, key = "SOLO_105_BAD_NS" }, -- Nature's Swiftness
			{ code = "CL", key = "SOLO_105_BAD_CURE" },
			{ code = "AR", key = "SOLO_105_BAD_REBIRTH" },
			{ id = 99, key = "SOLO_105_BAD_CC" }, -- Incapacitating Roar
		},
	},
	[65] = { -- Holy Paladin
		pre = {
			{ code = "SM", key = "SOLO_65_PRE_BEACON" },
			{ id = 465, key = "SOLO_65_PRE_AURA" }, -- Devotion Aura
			{ id = 433568, key = "SOLO_65_PRE_RITE" }, -- Rite of Sanctification (Lightsmith)
		},
		move = "SOLO_65_MOVE",
		heal = {
			{ code = "L", key = "SOLO_65_H_L" },
			{ code = "R", key = "SOLO_65_H_R" },
			{ code = "M", key = "SOLO_65_H_M" },
			{ code = "CR", key = "SOLO_65_H_CR" },
		},
		bad = {
			{ id = 498, key = "SOLO_65_BAD_DP" }, -- Divine Protection
			{ code = "CM", key = "SOLO_65_BAD_LOH" },
			{ id = 642, key = "SOLO_65_BAD_SHIELD" }, -- Divine Shield
			{ code = "CL", key = "SOLO_65_BAD_CLEANSE" },
			{ code = "AR", key = "SOLO_65_BAD_RES" },
			{ id = 853, key = "SOLO_65_BAD_CC" }, -- Hammer of Justice
		},
	},
	[256] = { -- Discipline Priest
		pre = {
			{ id = 21562, key = "SOLO_256_PRE_FORT" }, -- Power Word: Fortitude
			{ code = "L", key = "SOLO_256_PRE_SHIELD" },
			{ code = "CR", key = "SOLO_256_PRE_PLEA" },
		},
		move = "SOLO_256_MOVE",
		heal = {
			{ code = "M", key = "SOLO_256_H_M" },
			{ code = "R", key = "SOLO_256_H_R" },
			{ code = "AL", key = "SOLO_256_H_AL" },
		},
		bad = {
			{ id = 19236, key = "SOLO_256_BAD_PRAYER" }, -- Desperate Prayer
			{ id = 586, key = "SOLO_256_BAD_FADE" }, -- Fade
			{ code = "CM", key = "SOLO_256_BAD_PS" },
			{ code = "CL", key = "SOLO_256_BAD_PURIFY" },
			{ code = "AR", key = "SOLO_256_BAD_LEAP" },
			{ id = 8122, key = "SOLO_256_BAD_CC" }, -- Psychic Scream
		},
	},
	[257] = { -- Holy Priest
		pre = {
			{ id = 21562, key = "SOLO_257_PRE_FORT" }, -- Power Word: Fortitude
			{ code = "L", key = "SOLO_257_PRE_POM" },
		},
		move = "SOLO_257_MOVE",
		heal = {
			{ code = "M", key = "SOLO_257_H_M" },
			{ code = "R", key = "SOLO_257_H_R" },
		},
		bad = {
			{ id = 19236, key = "SOLO_257_BAD_PRAYER" }, -- Desperate Prayer
			{ code = "CM", key = "SOLO_257_BAD_GS" },
			{ id = 586, key = "SOLO_257_BAD_FADE" }, -- Fade
			{ code = "CL", key = "SOLO_257_BAD_PURIFY" },
			{ code = "AR", key = "SOLO_257_BAD_LEAP" },
			{ id = 8122, key = "SOLO_257_BAD_CC" }, -- Psychic Scream
		},
	},
	[264] = { -- Restoration Shaman
		pre = {
			{ id = 52127, key = "SOLO_264_PRE_WATER" }, -- Water Shield
			{ code = "M", key = "SOLO_264_PRE_EARTH" },
			{ id = 382021, key = "SOLO_264_PRE_WEAPON" }, -- Earthliving Weapon
		},
		move = "SOLO_264_MOVE",
		heal = {
			{ code = "L", key = "SOLO_264_H_L" },
			{ code = "R", key = "SOLO_264_H_R" },
			{ code = "CR", key = "SOLO_264_H_CR" },
			{ code = "CM", key = "SOLO_264_H_CM" },
		},
		bad = {
			{ id = 108271, key = "SOLO_264_BAD_ASTRAL" }, -- Astral Shift
			{ id = 5394, key = "SOLO_264_BAD_HST" }, -- Healing Stream Totem
			{ code = "CL", key = "SOLO_264_BAD_PURIFY" },
			{ id = 20608, key = "SOLO_264_BAD_REINC" }, -- Reincarnation
			{ id = 57994, key = "SOLO_264_BAD_KICK" }, -- Wind Shear
		},
	},
	[270] = { -- Mistweaver Monk
		pre = {
			{ code = "L", key = "SOLO_270_PRE_RENEW" },
		},
		move = "SOLO_270_MOVE",
		heal = {
			{ code = "R", key = "SOLO_270_H_R" },
			{ code = "M", key = "SOLO_270_H_M" },
		},
		bad = {
			{ id = 115203, key = "SOLO_270_BAD_BREW" }, -- Fortifying Brew
			{ code = "CM", key = "SOLO_270_BAD_COCOON" },
			{ id = 322101, key = "SOLO_270_BAD_EXPEL" }, -- Expel Harm
			{ code = "CL", key = "SOLO_270_BAD_DETOX" },
			{ id = 119381, key = "SOLO_270_BAD_CC" }, -- Leg Sweep
		},
	},
	[1468] = { -- Preservation Evoker
		pre = {
			{ id = 364342, key = "SOLO_1468_PRE_BRONZE" }, -- Blessing of the Bronze
			{ code = "L", key = "SOLO_1468_PRE_ECHO" },
			{ code = "R", key = "SOLO_1468_PRE_REVERSION" },
		},
		move = "SOLO_1468_MOVE",
		heal = {
			{ code = "M", key = "SOLO_1468_H_M" },
			{ code = "CR", key = "SOLO_1468_H_CR" },
		},
		bad = {
			{ id = 363916, key = "SOLO_1468_BAD_SCALES" }, -- Obsidian Scales
			{ id = 363534, key = "SOLO_1468_BAD_REWIND" }, -- Rewind
			{ code = "CM", key = "SOLO_1468_BAD_TD" },
			{ code = "CL", key = "SOLO_1468_BAD_NATURALIZE" },
			{ id = 368970, key = "SOLO_1468_BAD_CC" }, -- Tail Swipe
		},
	},
}

function ns.HasSoloGuide(specID)
	return specID ~= nil and ns.HEALER_SOLO_GUIDE[specID] ~= nil
end
