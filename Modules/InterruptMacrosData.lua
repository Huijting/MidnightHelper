--[[
	Focus-based interrupt macros per class/spec ( Midnight Helper ).
	Keys: WoW class file token (UnitClass select(2)) + specialization index (GetSpecialization()).
	Spec indices match the client order for each class (same as GetSpecializationInfo index).
]]

local addonName, ns = ...

local M = [[#showtooltip
/cast [@focus,exists,nodead,harm] Mind Freeze
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Mind Freeze
/target focus
/clearfocus
/startattack]]

local D = [[#showtooltip
/cast [@focus,exists,nodead,harm] Disrupt
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Disrupt
/target focus
/clearfocus
/startattack]]

local SOLAR = [[#showtooltip
/cast [@focus,exists,nodead,harm] Solar Beam
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Solar Beam
/target focus
/clearfocus
/startattack]]

local SKULL = [[#showtooltip
/cast [@focus,exists,nodead,harm] Skull Bash
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Skull Bash
/target focus
/clearfocus
/startattack]]

local QUAKE = [[#showtooltip
/cast [@focus,exists,nodead,harm] Quell
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Quell
/target focus
/clearfocus
/startattack]]

local CS_HUNT = [[#showtooltip
/cast [@focus,exists,nodead,harm] Counter Shot
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Counter Shot
/target focus
/clearfocus
/startattack]]

local MUZZLE = [[#showtooltip
/cast [@focus,exists,nodead,harm] Muzzle
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Muzzle
/target focus
/clearfocus
/startattack]]

local CS_MAGE = [[#showtooltip
/cast [@focus,exists,nodead,harm] Counterspell
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Counterspell
/target focus
/clearfocus
/startattack]]

local SPEAR = [[#showtooltip
/cast [@focus,exists,nodead,harm] Spear Hand Strike
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Spear Hand Strike
/target focus
/clearfocus
/startattack]]

local REBUKE = [[#showtooltip
/cast [@focus,exists,nodead,harm] Rebuke
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Rebuke
/target focus
/clearfocus
/startattack]]

local SILENCE = [[#showtooltip
/cast [@focus,exists,nodead,harm] Silence
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Silence
/target focus
/clearfocus
/startattack]]

local KICK = [[#showtooltip
/cast [@focus,exists,nodead,harm] Kick
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Kick
/target focus
/clearfocus
/startattack]]

local WIND = [[#showtooltip
/cast [@focus,exists,nodead,harm] Wind Shear
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Wind Shear
/target focus
/clearfocus
/startattack]]

local COMMAND_DEMON = [[#showtooltip
/cast [@focus,exists,nodead,harm] Command Demon
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Command Demon
/target focus
/clearfocus
/startattack]]

local PUMMEL = [[#showtooltip
/cast [@focus,exists,nodead,harm] Pummel
/stopmacro [@focus,exists,nodead,harm]
/focus target
/cleartarget
/targetenemy
/cast Pummel
/target focus
/clearfocus
/startattack]]

--- [classToken][specIndex] = macro body (empty string = no team macro for that spec).
ns.InterruptMacrosByClassSpec = {
	DEATHKNIGHT = { [1] = M, [2] = M, [3] = M },
	DEMONHUNTER = { [1] = D, [2] = D },
	DRUID = { [1] = SOLAR, [2] = SKULL, [3] = SKULL, [4] = SKULL },
	--- Devastation, Preservation, Augmentation (client spec order).
	EVOKER = { [1] = QUAKE, [2] = QUAKE, [3] = QUAKE },
	HUNTER = { [1] = CS_HUNT, [2] = CS_HUNT, [3] = MUZZLE },
	MAGE = { [1] = CS_MAGE, [2] = CS_MAGE, [3] = CS_MAGE },
	MONK = { [1] = SPEAR, [2] = SPEAR, [3] = SPEAR },
	PALADIN = { [1] = REBUKE, [2] = REBUKE, [3] = REBUKE },
	PRIEST = { [1] = "", [2] = "", [3] = SILENCE },
	ROGUE = { [1] = KICK, [2] = KICK, [3] = KICK },
	SHAMAN = { [1] = WIND, [2] = WIND, [3] = WIND },
	WARLOCK = { [1] = COMMAND_DEMON, [2] = COMMAND_DEMON, [3] = COMMAND_DEMON },
	WARRIOR = { [1] = PUMMEL, [2] = PUMMEL, [3] = PUMMEL },
}
