local _, ns = ...

--[[
	ForeverBlock_Paladin.lua — the key-block table for the Paladin in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 6 Nov 2026: "Ja, alle drie" — he left the class choices to us ("vertrouw ik op jouw expertise"), so this is the
	proposal from docs/forever/FOREVER_PALADIN_2026-11-06.md as written, with one change: Sense Undead moved from
	toBlockD to listed, because block D was one place too full at level 60 (13 for 12; the proposal's own suggestion).
	The Paladin has no form or stance that pages the bar (DB2 SpellShapeshiftForm 70790), so there are no states.
	Blessings are pairs: in a group the Greater version, solo the normal one.
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.PALADIN = {
	states = {},
	keys = {
		["1"] = { base = "Holy Strike" },
		["2"] = { base = "Judgement" },
		["3"] = { base = { "Seal of Command", "Seal of Righteousness" } },
		["4"] = { base = "Hammer of Wrath" },
		["5"] = { base = "Exorcism" },
		["SHIFT-4"] = { base = "Holy Shield" },
		["SHIFT-1"] = { base = "Consecration" },
		["SHIFT-2"] = { base = "Hammer of the Righteous" },
		["Q"] = { base = "Lay on Hands" },
		["F1"] = { base = "Swift Judgement" },
		["SHIFT-3"] = { base = "Divine Favor" },
		["SHIFT-F1"] = { base = "Light's Vigil" },
		["F3"] = { pair = { cond = "[combat]", first = "Divine Intervention", second = "Redemption" } },
		["E"] = { base = "Hammer of Justice" },
		["R"] = { base = "Blessing of Freedom" },
		["SHIFT-R"] = { base = "Oath of Light" },
		["F"] = { base = "Seal of Fury" },
		["Z"] = { base = { "Divine Shield", "Divine Protection" } },
		["X"] = { base = "Templar's Bulwark" },
		["C"] = { base = "Holy Light" },
		["F2"] = { base = "Flash of Light" },
		["F4"] = { base = "Holy Shock" },
		["V"] = { base = "Repentance" },
		["SHIFT-Q"] = { base = "Turn Undead" },
		["SHIFT-F"] = { base = "Blessing of Protection" },
		["SHIFT-Z"] = { pair = { cond = "[group]", first = "Greater Blessing of Might", second = "Blessing of Might" } },
		["SHIFT-X"] = { pair = { cond = "[group]", first = "Greater Blessing of Kings", second = "Blessing of Kings" } },
		["SHIFT-V"] = { pair = { cond = "[group]", first = "Greater Blessing of Wisdom", second = "Blessing of Wisdom" } },
		["SHIFT-C"] = { base = { "Cleanse", "Purify" } },
		["SHIFT-E"] = { all = { "Stoneform", "Will to Survive", "Will of the Forsaken" } },
		["CTRL-1"] = { base = "Devotion Aura" },
		["CTRL-2"] = { base = "Retribution Aura" },
		["CTRL-3"] = { base = "Concentration Aura" },
	},
	toBlockD = {
		"Righteous Fury", "Seal of the Crusader", "Seal of Justice", "Seal of Light", "Seal of Wisdom",
		"Blessing of Sacrifice", "Holy Wrath", "Voice of Truth", "Shadow Resistance Aura", "Frost Resistance Aura",
		"Fire Resistance Aura", "Perception", "Find Treasure", "Cannibalize",
	},
	listed = { "Sense Undead" },
}
