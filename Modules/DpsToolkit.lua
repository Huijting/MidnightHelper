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
	[251] = { { id = 51271, cd = 45 } }, -- Frost DK: Pillar of Frost
	[252] = { { id = 42650, cd = 90 }, { id = 391109, cd = 60 } }, -- Unholy DK: Army of the Dead, Dark Ascension
	[577] = { { id = 191427, cd = 120 } }, -- Havoc DH: Metamorphosis
	[102] = { { id = 194223, cd = 180 } }, -- Balance Druid: Celestial Alignment
	[103] = { { id = 106951, cd = 180 } }, -- Feral Druid: Berserk
	[1467] = { { id = 375087, cd = 120 } }, -- Devastation Evoker: Dragonrage
	[1473] = { { id = 403631, cd = 120 } }, -- Augmentation Evoker: Breath of Eons
	[253] = { { id = 19574, cd = 90 } }, -- BM Hunter: Bestial Wrath
	[254] = { { id = 288613, cd = 120 } }, -- MM Hunter: Trueshot
	[255] = { { id = 360952, cd = 120 } }, -- Survival Hunter: Coordinated Assault
	[62] = { { id = 365350, cd = 90 } }, -- Arcane Mage: Arcane Surge
	[63] = { { id = 190319, cd = 120 } }, -- Fire Mage: Combustion
	[64] = { { id = 12472, cd = 120 } }, -- Frost Mage: Icy Veins
	[269] = { { id = 123904, cd = 120 } }, -- Windwalker Monk: Invoke Xuen
	[70] = { { id = 31884, cd = 120 }, { id = 375576, cd = 60 } }, -- Ret Paladin: Avenging Wrath, Divine Toll
	[258] = { { id = 228260, cd = 120 }, { id = 10060, cd = 120 } }, -- Shadow Priest: Voidform, Power Infusion
	[259] = { { id = 360194, cd = 120 } }, -- Assassination Rogue: Deathmark
	[260] = { { id = 13750, cd = 180 } }, -- Outlaw Rogue: Adrenaline Rush
	[261] = { { id = 185313, cd = 20 } }, -- Subtlety Rogue: Shadow Dance
	[262] = { { id = 191634, cd = 60 }, { id = 114050, cd = 180 } }, -- Elemental Shaman: Stormkeeper, Ascendance
	[263] = { { id = 51533, cd = 90 }, { id = 114050, cd = 180 } }, -- Enhancement Shaman: Feral Spirit, Ascendance
	[265] = { { id = 205180, cd = 120 } }, -- Affliction Warlock: Summon Darkglare
	[266] = { { id = 265187, cd = 60 } }, -- Demonology Warlock: Summon Demonic Tyrant
	[267] = { { id = 1122, cd = 120 } }, -- Destruction Warlock: Summon Infernal
	[71] = { { id = 167105, cd = 45 } }, -- Arms Warrior: Colossus Smash
	[72] = { { id = 1719, cd = 90 } }, -- Fury Warrior: Recklessness
}

local DPS_SPECS = {
	[251] = true, [252] = true, [577] = true, [102] = true, [103] = true,
	[1467] = true, [1473] = true, [253] = true, [254] = true, [255] = true,
	[62] = true, [63] = true, [64] = true, [269] = true, [70] = true,
	[258] = true, [259] = true, [260] = true, [261] = true, [262] = true,
	[263] = true, [265] = true, [266] = true, [267] = true, [71] = true, [72] = true,
}

function ns.GetDpsCooldowns(specID)
	return specID and ns.DPS_COOLDOWNS[specID] or nil
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
