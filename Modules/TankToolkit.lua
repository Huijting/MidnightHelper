--[[
	Tank toolkit (Rob 2026-07-15: "de tank-role is onderbelicht, geen spells").
	Mirrors the healer toolkit: per tank spec, your ACTIVE MITIGATION buttons (the
	survival you keep up) + your DEFENSIVE COOLDOWNS (the big saves), each with a
	coloured label + one-liner. Rendered spec-aware at the top of the Role Academy
	TANK track (RoleAcademy.lua RenderTankToolkit), with hover spell tooltips.

	NEVER-LIE — every spellID + base cooldown is from Rob's installed data, not
	guessed:
	  - JustAC/Data/SpellCooldowns.lua   -> [spellID] = cooldownMs (the `cd`)
	  - JustAC/Data/SpellCategories.lua  -> DEFENSIVE membership + spec (e.g.
	    [187827] = Metamorphosis (Vengeance), [190456] = Ignore Pain)
	  - JustAC/Data/SpellArchetypes.lua  -> Shield of the Righteous 53600 / Death
	    Strike 49998 / Marrowrend 195182 (resource-based mitigation, no cooldown)
	Spell NAMES resolve LIVE via C_Spell.GetSpellName. `cd` is seconds, or nil
	when the button is resource-based / its CD isn't in the data (tooltip shows
	the real one). Active-mitigation buttons are mostly resource-based, so they
	carry a `tag` (what they do) rather than a cooldown.

	Tank specIDs: Prot Paladin 66, Prot Warrior 73, Guardian Druid 104, Blood DK
	250, Brewmaster Monk 268, Vengeance DH 581.
]]

local _, ns = ...

-- Active-mitigation tags (what the button does): label + one-liner + colour.
local MIT = {
	block = "TANKKIT_MIT_BLOCK",
	absorb = "TANKKIT_MIT_ABSORB",
	armor = "TANKKIT_MIT_ARMOR",
	selfheal = "TANKKIT_MIT_SELFHEAL",
	brew = "TANKKIT_MIT_BREW",
}
local MIT_DESC = {
	block = "TANKKIT_MITDESC_BLOCK",
	absorb = "TANKKIT_MITDESC_ABSORB",
	armor = "TANKKIT_MITDESC_ARMOR",
	selfheal = "TANKKIT_MITDESC_SELFHEAL",
	brew = "TANKKIT_MITDESC_BREW",
}
local MIT_COLOR = {
	block = "ffffd060",
	absorb = "ff5fe0b0",
	armor = "ffb0a070",
	selfheal = "ff40c040",
	brew = "ff70d0d0",
}

-- Defensive-cooldown kinds: label + one-liner + colour (kind drives both).
local TCD = {
	dr = "TANKKIT_CD_DR",
	immunity = "TANKKIT_CD_IMMUNITY",
	magic = "TANKKIT_CD_MAGIC",
	selfheal = "TANKKIT_CD_SELFHEAL",
	raid = "TANKKIT_CD_RAID",
}
local TCD_DESC = {
	dr = "TANKKIT_CDDESC_DR",
	immunity = "TANKKIT_CDDESC_IMMUNITY",
	magic = "TANKKIT_CDDESC_MAGIC",
	selfheal = "TANKKIT_CDDESC_SELFHEAL",
	raid = "TANKKIT_CDDESC_RAID",
}
local TCD_COLOR = {
	dr = "ff40a0ff",
	immunity = "ffffe040",
	magic = "ffc080ff",
	selfheal = "ff40c040",
	raid = "ffff9040",
}

ns.TANK_MITIGATION = {
	[66] = { -- Protection Paladin
		{ id = 53600, tag = "block" }, -- Shield of the Righteous
	},
	[73] = { -- Protection Warrior
		{ id = 2565, tag = "block" }, -- Shield Block
		{ id = 190456, tag = "absorb" }, -- Ignore Pain
	},
	[104] = { -- Guardian Druid
		{ id = 192081, tag = "armor" }, -- Ironfur
		{ id = 22842, tag = "selfheal" }, -- Frenzied Regeneration
	},
	[250] = { -- Blood Death Knight
		{ id = 49998, tag = "selfheal" }, -- Death Strike
		{ id = 195182, tag = "armor" }, -- Marrowrend (builds Bone Shield)
	},
	[268] = { -- Brewmaster Monk
		{ id = 119582, tag = "brew" }, -- Purifying Brew
		{ id = 322507, tag = "absorb" }, -- Celestial Brew
	},
	[581] = { -- Vengeance Demon Hunter
		{ id = 203720, tag = "armor" }, -- Demon Spikes
	},
}

-- 17 Sep 2026 (docs/audit_2026-09-17): removed Last Stand (passive on Shield Wall in 12.1), Dampen
-- Harm and Zen Meditation (gone); added Sentinel, Blessing of Spellwarding, Demoralizing Shout and
-- Darkness; Metamorphosis got its 2 min; Barkskin is 45 s. Shown filtered on your own spec now.
ns.TANK_COOLDOWNS = {
	[66] = { -- Protection Paladin
		{ id = 31850, cd = 90, kind = "dr" }, -- Ardent Defender
		{ id = 86659, cd = 180, kind = "dr" }, -- Guardian of Ancient Kings
		{ id = 389539, cd = 120, kind = "dr" }, -- Sentinel (up to 30% less damage taken)
		{ id = 204018, kind = "magic" }, -- Blessing of Spellwarding (talent; shares its cooldown with Blessing of Protection)
		{ id = 642, cd = 300, kind = "immunity" }, -- Divine Shield
	},
	[73] = { -- Protection Warrior
		{ id = 1160, cd = 45, kind = "dr" }, -- Demoralizing Shout (enemies deal 20% less to you)
		{ id = 871, cd = 180, kind = "dr" }, -- Shield Wall
		{ id = 97462, cd = 180, kind = "raid" }, -- Rallying Cry
		{ id = 23920, cd = 25, kind = "magic" }, -- Spell Reflection
	},
	[104] = { -- Guardian Druid
		{ id = 22812, cd = 45, kind = "dr" }, -- Barkskin
		{ id = 61336, cd = 180, kind = "dr" }, -- Survival Instincts (2 charges baseline)
	},
	[250] = { -- Blood Death Knight
		{ id = 55233, cd = 90, kind = "selfheal" }, -- Vampiric Blood
		{ id = 48792, cd = 120, kind = "dr" }, -- Icebound Fortitude
		{ id = 48707, cd = 60, kind = "magic" }, -- Anti-Magic Shell
		{ id = 49028, cd = 120, kind = "dr" }, -- Dancing Rune Weapon
	},
	[268] = { -- Brewmaster Monk
		{ id = 115203, cd = 360, kind = "dr" }, -- Fortifying Brew
	},
	[581] = { -- Vengeance Demon Hunter
		{ id = 204021, cd = 60, kind = "dr" }, -- Fiery Brand
		{ id = 212084, cd = 40, kind = "selfheal" }, -- Fel Devastation
		{ id = 187827, cd = 120, kind = "dr" }, -- Metamorphosis (Vengeance)
		{ id = 196718, cd = 300, kind = "raid" }, -- Darkness
	},
}

local TANK_SPECS = { [66] = true, [73] = true, [104] = true, [250] = true, [268] = true, [581] = true }

function ns.GetTankMitigation(specID)
	return specID and ns.TANK_MITIGATION[specID] or nil
end

function ns.GetTankCooldowns(specID)
	return specID and ns.TANK_COOLDOWNS[specID] or nil
end

--- The player's current spec id IF it is a tank spec we have data for, else nil.
function ns.GetPlayerTankSpecID()
	if not (GetSpecialization and GetSpecializationInfo) then
		return nil
	end
	local idx = GetSpecialization()
	if not idx then
		return nil
	end
	local id = GetSpecializationInfo(idx)
	if id and TANK_SPECS[id] then
		return id
	end
	return nil
end

--- The player's CLASS's tank spec id (even if not active), or nil.
function ns.GetClassTankSpecID()
	if not (GetNumSpecializations and GetSpecializationInfo) then
		return nil
	end
	local n = GetNumSpecializations() or 0
	for i = 1, n do
		local id = GetSpecializationInfo(i)
		if id and TANK_SPECS[id] then
			return id
		end
	end
	return nil
end

-- Label + guidance keys (nil-safe), for RoleAcademy to render.
function ns.GetTankMitigationLabelKey(tag)
	return MIT[tag]
end
function ns.GetTankMitigationDescKey(tag)
	return MIT_DESC[tag]
end
function ns.GetTankCooldownKindKey(kind)
	return TCD[kind]
end
function ns.GetTankCooldownDescKey(kind)
	return TCD_DESC[kind]
end

-- Coloured "[Block]" / "[Damage reduction]" labels.
function ns.TankMitigationTagLabel(tag)
	local key = MIT[tag]
	if not key then
		return ""
	end
	return ("|c%s[%s]|r"):format(MIT_COLOR[tag] or "ffffffff", ns:L(key))
end
function ns.TankCooldownKindLabel(kind)
	local key = TCD[kind]
	if not key then
		return ""
	end
	return ("|c%s[%s]|r"):format(TCD_COLOR[kind] or "ffffffff", ns:L(key))
end
