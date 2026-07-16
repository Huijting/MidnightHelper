--[[
	DPS toolkit (Rob 2026-07-15: the Role Academy had no DPS role at all). Per DPS
	spec, your big DAMAGE COOLDOWNS — the buttons to line up with the pull. Same
	spec-aware pattern as the healer/tank toolkits (coloured label + hover spell
	tooltip), rendered at the top of the new Role Academy DPS track.

	NEVER-LIE — every spellID + base cooldown is verified from Rob's installed data
	(JustAC/Data/SpellCooldowns.lua [id]=ms, cross-checked against the primary
	`cooldown_bar` role in KeybindRoles_*.lua), not guessed. Names resolve LIVE via
	C_Spell.GetSpellName. `cd` is seconds. This is the v1 (one signature burst CD
	per spec); more cooldowns + personal defensives are a planned follow-up.

	DPS specIDs: DK Frost 251 / Unholy 252; DH Havoc 577; Druid Balance 102 /
	Feral 103; Evoker Devastation 1467 / Augmentation 1473; Hunter BM 253 / MM 254
	/ Survival 255; Mage Arcane 62 / Fire 63 / Frost 64; Monk Windwalker 269;
	Paladin Retribution 70; Priest Shadow 258; Rogue Assassination 259 / Outlaw
	260 / Subtlety 261; Shaman Elemental 262 / Enhancement 263; Warlock Affliction
	265 / Demonology 266 / Destruction 267; Warrior Arms 71 / Fury 72.
]]

local _, ns = ...

ns.DPS_COOLDOWNS = {
	[251] = { { id = 51271, cd = 45 }, { id = 279302, cd = 90 }, { id = 47568, cd = 30 }, { id = 196770, cd = 20 } }, -- Frost DK: Pillar of Frost, Frostwyrm's Fury, Empower Rune Weapon (2 charges / 30s recharge), Remorseless Winter (20s core)
	-- Dark Ascension (391109) used to sit here: it is a SHADOW PRIEST talent, not an
	-- Unholy ability — Unholy's own APL (JustAC SimcRotations DEATHKNIGHT_3) never casts
	-- it. Moved to [258]. Dark Transformation skipped: two ids (APL casts 325554, the
	-- cooldown table has 1233448) — ambiguous, never guess. Summon Gargoyle has no
	-- cooldown entry to verify against.
	[252] = { { id = 42650, cd = 90 }, { id = 220143, cd = 90 }, { id = 207289, cd = 90 } }, -- Unholy DK: Army of the Dead, Apocalypse, Unholy Assault
	[577] = { { id = 191427, cd = 120 }, { id = 370965, cd = 90 }, { id = 198013, cd = 30 }, { id = 258860, cd = 40 } }, -- Havoc DH: Metamorphosis, The Hunt, Eye Beam (30s core), Essence Break (talent)
	[102] = { { id = 194223, cd = 180 }, { id = 102560, cd = 180 }, { id = 202770, cd = 60 }, { id = 205636, cd = 60 } }, -- Balance Druid: Celestial Alignment / Incarnation: Chosen of Elune (talent alt), Fury of Elune, Force of Nature (talent)
	[103] = { { id = 5217, cd = 30 }, { id = 106951, cd = 180 }, { id = 102543, cd = 180 }, { id = 274837, cd = 45 } }, -- Feral Druid: Tiger's Fury (30s core CD), Berserk / Incarnation: Avatar of Ashamane (talent alt — render filters to the one you have), Feral Frenzy (talent)
	[1467] = { { id = 375087, cd = 120 }, { id = 357208, cd = 30 }, { id = 359073, cd = 30 }, { id = 357210, cd = 120 } }, -- Devastation Evoker: Dragonrage, Fire Breath, Eternity Surge (the other empower), Deep Breath
	[1473] = { { id = 403631, cd = 120 }, { id = 395152, cd = 30 }, { id = 396286, cd = 40 } }, -- Augmentation Evoker: Breath of Eons, Ebon Might (30s core), Upheaval
	[253] = { { id = 19574, cd = 90 }, { id = 359844, cd = 120 }, { id = 321530, cd = 60 } }, -- BM Hunter: Bestial Wrath, Call of the Wild, Bloodshed (talent)
	[254] = { { id = 288613, cd = 120 }, { id = 257044, cd = 16 }, { id = 212431, cd = 30 } }, -- MM Hunter: Trueshot, Rapid Fire (16s core), Explosive Shot (talent)
	[255] = { { id = 360952, cd = 120 }, { id = 360966, cd = 90 }, { id = 259495, cd = 18 }, { id = 203415, cd = 45 } }, -- Survival Hunter: Coordinated Assault, Spearhead, Wildfire Bomb (18s core), Fury of the Eagle (talent)
	[62] = { { id = 365350, cd = 90 }, { id = 321507, cd = 45 }, { id = 153626, cd = 20 }, { id = 314791, cd = 60 } }, -- Arcane Mage: Arcane Surge, Touch of the Magi, Arcane Orb (talent), Shifting Power (talent)
	[63] = { { id = 190319, cd = 120 }, { id = 153561, cd = 45 }, { id = 44457, cd = 30 } }, -- Fire Mage: Combustion, Meteor, Living Bomb (talent)
	[64] = { { id = 12472, cd = 120 }, { id = 84714, cd = 60 }, { id = 205021, cd = 60 }, { id = 157997, cd = 25 } }, -- Frost Mage: Icy Veins, Frozen Orb (was missing), Ray of Frost / Ice Nova (talent picks)
	[269] = { { id = 123904, cd = 120 }, { id = 137639, cd = 90 }, { id = 113656, cd = 24 }, { id = 392983, cd = 35 } }, -- Windwalker Monk: Invoke Xuen, Storm Earth and Fire, Fists of Fury (24s core), Strike of the Windlord (talent)
	[70] = { { id = 31884, cd = 120 }, { id = 375576, cd = 60 }, { id = 343527, cd = 60 }, { id = 343721, cd = 60 } }, -- Ret Paladin: Avenging Wrath, Divine Toll, Execution Sentence / Final Reckoning (talent picks)
	[258] = { { id = 228260, cd = 120 }, { id = 391109, cd = 60 }, { id = 10060, cd = 120 }, { id = 263165, cd = 30 } }, -- Shadow Priest: Void Eruption / Dark Ascension (talent alt), Power Infusion, Void Torrent (30s core; id pinned by JustAC PRIEST_3 APL)
	[259] = { { id = 360194, cd = 120 }, { id = 385627, cd = 60 }, { id = 5938, cd = 30 } }, -- Assassination Rogue: Deathmark, Kingsbane, Shiv (30s damage-amp)
	[260] = { { id = 13750, cd = 180 }, { id = 51690, cd = 180 }, { id = 13877, cd = 30 }, { id = 271877, cd = 60 } }, -- Outlaw Rogue: Adrenaline Rush, Killing Spree, Blade Flurry (talent), Blade Rush (talent)
	[261] = { { id = 185313, cd = 20 }, { id = 121471, cd = 90 }, { id = 323654, cd = 90 }, { id = 426591, cd = 45 } }, -- Subtlety Rogue: Shadow Dance, Shadow Blades, Flagellation (talent), Goremaw's Bite (talent)
	-- Ascendance 114050 is genuinely SHARED by Elemental and Enhancement (verified:
	-- JustAC SimcRotations SHAMAN_1 and SHAMAN_2 both cast 114050; 114052 is the
	-- Restoration one per SpellCategories). Both entries below are correct as-is.
	[262] = { { id = 191634, cd = 60 }, { id = 114050, cd = 180 }, { id = 198067, cd = 120 }, { id = 192249, cd = 120 }, { id = 375982, cd = 30 } }, -- Elemental Shaman: Stormkeeper, Ascendance, Fire Elemental / Storm Elemental (talent alt), Primordial Wave (id pinned by SHAMAN_1 APL)
	[263] = { { id = 51533, cd = 90 }, { id = 114050, cd = 180 }, { id = 384352, cd = 60 }, { id = 197214, cd = 30 } }, -- Enhancement Shaman: Feral Spirit, Ascendance, Doom Winds (talent), Sundering (talent)
	[265] = { { id = 205180, cd = 120 }, { id = 325640, cd = 60 }, { id = 278350, cd = 30 }, { id = 205179, cd = 45 } }, -- Affliction Warlock: Summon Darkglare, Soul Rot, Vile Taint / Phantom Singularity (talent picks)
	[266] = { { id = 265187, cd = 60 }, { id = 111898, cd = 120 }, { id = 104316, cd = 20 }, { id = 264119, cd = 25 } }, -- Demonology Warlock: Summon Demonic Tyrant, Grimoire: Felguard, Call Dreadstalkers (20s core, was missing), Summon Vilefiend (talent)
	[267] = { { id = 1122, cd = 120 }, { id = 196447, cd = 25 }, { id = 152108, cd = 30 } }, -- Destruction Warlock: Summon Infernal, Channel Demonfire (talent), Cataclysm (talent). Havoc skipped: situational cleave, not a press-on-cooldown CD.
	[71] = { { id = 167105, cd = 45 }, { id = 107574, cd = 90 }, { id = 384318, cd = 90 }, { id = 227847, cd = 90 }, { id = 228920, cd = 90 } }, -- Arms Warrior: Colossus Smash, Avatar, Thunderous Roar (talent), Bladestorm / Ravager (talent alt)
	[72] = { { id = 1719, cd = 90 }, { id = 385059, cd = 45 }, { id = 107574, cd = 90 }, { id = 384318, cd = 90 } }, -- Fury Warrior: Recklessness, Odyn's Fury, Avatar (talent), Thunderous Roar (talent)
}

local DPS_SPECS = {
	[251] = true, [252] = true, [577] = true, [102] = true, [103] = true,
	[1467] = true, [1473] = true, [253] = true, [254] = true, [255] = true,
	[62] = true, [63] = true, [64] = true, [269] = true, [70] = true,
	[258] = true, [259] = true, [260] = true, [261] = true, [262] = true,
	[263] = true, [265] = true, [266] = true, [267] = true, [71] = true, [72] = true,
}

-- Personal defensives per DPS spec (Rob 2026-07-15: "voeg de personal
-- defensives toe voor dps"). Beginners forget DPS have these. IDs verified in
-- JustAC SpellCategories DEFENSIVE; cds from SpellCooldowns (nil where the CD
-- isn't in the data — the tooltip shows it, and FormatCD omits nil). never-lie.
ns.DPS_DEFENSIVES = {
	[251] = { { id = 48792, cd = 120 }, { id = 48707, cd = 60 } }, -- Frost DK: Icebound Fortitude, Anti-Magic Shell
	[252] = { { id = 48792, cd = 120 }, { id = 48707, cd = 60 } }, -- Unholy DK: Icebound Fortitude, Anti-Magic Shell
	[577] = { { id = 198589 }, { id = 196718, cd = 300 } }, -- Havoc DH: Blur, Darkness
	[102] = { { id = 22812, cd = 60 }, { id = 108238, cd = 90 } }, -- Balance Druid: Barkskin, Renewal
	[103] = { { id = 22812, cd = 60 }, { id = 61336, cd = 180 } }, -- Feral Druid: Barkskin, Survival Instincts
	[1467] = { { id = 363916, cd = 90 }, { id = 374348 } }, -- Devastation Evoker: Obsidian Scales, Renewing Blaze
	[1473] = { { id = 363916, cd = 90 }, { id = 374227, cd = 120 } }, -- Augmentation Evoker: Obsidian Scales, Zephyr
	[253] = { { id = 186265, cd = 180 }, { id = 109304, cd = 120 } }, -- BM Hunter: Aspect of the Turtle, Exhilaration
	[254] = { { id = 186265, cd = 180 }, { id = 109304, cd = 120 } }, -- MM Hunter: Aspect of the Turtle, Exhilaration
	[255] = { { id = 186265, cd = 180 }, { id = 109304, cd = 120 } }, -- Survival Hunter: Aspect of the Turtle, Exhilaration
	[62] = { { id = 45438, cd = 240 }, { id = 110959, cd = 120 } }, -- Arcane Mage: Ice Block, Greater Invisibility
	[63] = { { id = 45438, cd = 240 }, { id = 342245, cd = 60 } }, -- Fire Mage: Ice Block, Alter Time
	[64] = { { id = 45438, cd = 240 }, { id = 342245, cd = 60 } }, -- Frost Mage: Ice Block, Alter Time
	[269] = { { id = 122470, cd = 90 }, { id = 122278, cd = 120 } }, -- Windwalker Monk: Touch of Karma, Dampen Harm
	[70] = { { id = 184662 }, { id = 642, cd = 300 } }, -- Ret Paladin: Shield of Vengeance, Divine Shield
	[258] = { { id = 47585 }, { id = 19236, cd = 90 } }, -- Shadow Priest: Dispersion, Desperate Prayer
	[259] = { { id = 31224, cd = 120 }, { id = 5277, cd = 120 } }, -- Assassination Rogue: Cloak of Shadows, Evasion
	[260] = { { id = 31224, cd = 120 }, { id = 5277, cd = 120 } }, -- Outlaw Rogue: Cloak of Shadows, Evasion
	[261] = { { id = 31224, cd = 120 }, { id = 5277, cd = 120 } }, -- Subtlety Rogue: Cloak of Shadows, Evasion
	[262] = { { id = 108271, cd = 120 }, { id = 108281, cd = 120 } }, -- Elemental Shaman: Astral Shift, Ancestral Guidance
	[263] = { { id = 108271, cd = 120 }, { id = 108281, cd = 120 } }, -- Enhancement Shaman: Astral Shift, Ancestral Guidance
	[265] = { { id = 104773, cd = 180 }, { id = 108416, cd = 60 } }, -- Affliction Warlock: Unending Resolve, Dark Pact
	[266] = { { id = 104773, cd = 180 }, { id = 108416, cd = 60 } }, -- Demonology Warlock: Unending Resolve, Dark Pact
	[267] = { { id = 104773, cd = 180 }, { id = 108416, cd = 60 } }, -- Destruction Warlock: Unending Resolve, Dark Pact
	[71] = { { id = 118038, cd = 120 }, { id = 97462, cd = 180 } }, -- Arms Warrior: Die by the Sword, Rallying Cry
	[72] = { { id = 184364, cd = 120 }, { id = 97462, cd = 180 } }, -- Fury Warrior: Enraged Regeneration, Rallying Cry
}

function ns.GetDpsCooldowns(specID)
	return specID and ns.DPS_COOLDOWNS[specID] or nil
end

function ns.GetDpsDefensives(specID)
	return specID and ns.DPS_DEFENSIVES[specID] or nil
end

--- The player's current spec id IF it is a DPS spec we have data for, else nil.
function ns.GetPlayerDpsSpecID()
	if not (GetSpecialization and GetSpecializationInfo) then
		return nil
	end
	local idx = GetSpecialization()
	if not idx then
		return nil
	end
	local id = GetSpecializationInfo(idx)
	if id and DPS_SPECS[id] then
		return id
	end
	return nil
end

--- The player's CLASS's first DPS spec id (even if not active), or nil.
function ns.GetClassDpsSpecID()
	if not (GetNumSpecializations and GetSpecializationInfo) then
		return nil
	end
	local n = GetNumSpecializations() or 0
	for i = 1, n do
		local id = GetSpecializationInfo(i)
		if id and DPS_SPECS[id] then
			return id
		end
	end
	return nil
end
