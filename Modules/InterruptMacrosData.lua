--[[
	Interrupt macros per class/spec ( Midnight Helper ).
	Keys: WoW class file token (UnitClass select(2)) + specialization index (GetSpecialization()).
	Spec indices match the client order for each class (same as GetSpecializationInfo index).

	One interrupt spell per spec (false = no interrupt for that spec); macro bodies
	are generated in two variants:
	- Focus: kicks focus if it is a living enemy, else current target. Never modifies focus.
	- Mouseover: kicks mouseover if it is a living enemy, else current target.
]]

local addonName, ns = ...

local SPELLS = {
	DEATHKNIGHT = { [1] = "Mind Freeze", [2] = "Mind Freeze", [3] = "Mind Freeze" },
	DEMONHUNTER = { [1] = "Disrupt", [2] = "Disrupt" },
	DRUID = { [1] = "Solar Beam", [2] = "Skull Bash", [3] = "Skull Bash", [4] = "Skull Bash" },
	--- Devastation, Preservation, Augmentation (client spec order).
	EVOKER = { [1] = "Quell", [2] = "Quell", [3] = "Quell" },
	HUNTER = { [1] = "Counter Shot", [2] = "Counter Shot", [3] = "Muzzle" },
	MAGE = { [1] = "Counterspell", [2] = "Counterspell", [3] = "Counterspell" },
	MONK = { [1] = "Spear Hand Strike", [2] = "Spear Hand Strike", [3] = "Spear Hand Strike" },
	PALADIN = { [1] = "Rebuke", [2] = "Rebuke", [3] = "Rebuke" },
	PRIEST = { [1] = false, [2] = false, [3] = "Silence" },
	ROGUE = { [1] = "Kick", [2] = "Kick", [3] = "Kick" },
	SHAMAN = { [1] = "Wind Shear", [2] = "Wind Shear", [3] = "Wind Shear" },
	WARLOCK = { [1] = "Command Demon", [2] = "Command Demon", [3] = "Command Demon" },
	WARRIOR = { [1] = "Pummel", [2] = "Pummel", [3] = "Pummel" },
}

ns.InterruptSpellsByClassSpec = SPELLS

local FOCUS_FMT = "#showtooltip\n/cast [@focus,harm,nodead][] %s"
local MOUSEOVER_FMT = "#showtooltip\n/cast [@mouseover,harm,nodead][] %s"

--- Returns the interrupt spell name for the spec, or nil if none.
function ns.MH_GetInterruptSpell(token, specIdx)
	local t = token and SPELLS[token]
	local spell = t and t[specIdx]
	if not spell or spell == "" then
		return nil
	end
	return spell
end

--- Returns a list of { name, desc, macro } variants, or nil if the spec has no interrupt.
--- Built per call so names/descriptions follow the active locale.
function ns.MH_GetInterruptMacroVariants(token, specIdx)
	local spell = ns.MH_GetInterruptSpell(token, specIdx)
	if not spell then
		return nil
	end
	return {
		{
			name = ns:L("MACROS_INTERRUPT_VARIANT_FOCUS"),
			desc = ns:L("MACROS_INTERRUPT_DESC_FOCUS"),
			macro = FOCUS_FMT:format(spell),
		},
		{
			name = ns:L("MACROS_INTERRUPT_VARIANT_MOUSEOVER"),
			desc = ns:L("MACROS_INTERRUPT_DESC_MOUSEOVER"),
			macro = MOUSEOVER_FMT:format(spell),
		},
	}
end
