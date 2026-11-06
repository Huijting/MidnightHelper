local _, ns = ...

--[[
	ForeverBlock_Mage.lua — the key-block table for the Mage in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 6 Nov 2026: "Ja, alle drie" — he left the class choices to us ("vertrouw ik op jouw expertise"), so this is the
	proposal from docs/forever/FOREVER_MAGE_2026-11-06.md as written. Tree-neutral: the trainer basics every Mage has sit
	on 1/2/3/5, talent nukes on 4, F, Ctrl-2 and Shift-F1. No forms or stances (DB2 70790), so there are no states.
	Mage Armor, conjures and teleports/portals go to block D (the player's own Alt keys).
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.MAGE = {
	states = {},
	keys = {
		["1"] = { base = "Fireball" },
		["2"] = { base = "Frostbolt" },
		["3"] = { base = "Arcane Missiles" },
		["4"] = { base = "Pyroblast" },
		["5"] = { base = "Fire Blast" },
		["SHIFT-4"] = { base = "Flamestrike" },
		["SHIFT-1"] = { base = "Blizzard" },
		["SHIFT-2"] = { base = "Arcane Explosion" },
		["CTRL-1"] = { base = "Scorch" },
		["CTRL-2"] = { base = "Arcane Blast" },
		-- Rob, 6 Nov 2026 ("Doe maar" on 1B): the wand on Ctrl-3 until Frostfire Bolt is learned, then the bolt takes
		-- the place and Shoot goes to the player's own Alt keys. bang: a second press does not stop the wand.
		["CTRL-3"] = { base = { "Frostfire Bolt", "Shoot" }, bang = true },
		["Q"] = { base = { "Arcane Power", "Combustion" } },
		["F1"] = { base = "Evocation" },
		["SHIFT-3"] = { base = "Presence of Mind" },
		["F3"] = { base = "Blast Wave" },
		["SHIFT-F1"] = { base = "Arcane Wrath" },
		["E"] = { base = "Counterspell" },
		["R"] = { base = "Blink" },
		["SHIFT-R"] = { base = "Slow Fall" },
		["F"] = { base = "Ice Lance" },
		["Z"] = { base = "Mana Shield" },
		["X"] = { base = "Ice Barrier" },
		["C"] = { base = "Ice Block" },
		["SHIFT-C"] = { base = "Cold Snap" },
		["F2"] = { base = "Frost Ward" },
		["F4"] = { base = "Fire Ward" },
		["V"] = { base = "Frost Nova" },
		["SHIFT-Q"] = { base = "Polymorph" },
		["SHIFT-F"] = { base = "Cone of Cold" },
		["SHIFT-V"] = { base = "Remove Lesser Curse" },
		["SHIFT-Z"] = { base = { "Ice Armor", "Frost Armor" } },
		["SHIFT-X"] = { base = { "Arcane Brilliance", "Arcane Intellect" } },
		["SHIFT-E"] = { base = { "Blood Fury", "Berserking", "Eureka!", "Will of the Forsaken", "Will to Survive",
			"Read Leyline" } },
	},
	toBlockD = {
		"Mage Armor", "Amplify Magic", "Dampen Magic",
		"Conjure Water", "Conjure Food", "Conjure Mana Agate", "Conjure Mana Jade", "Conjure Mana Citrine",
		"Conjure Mana Ruby",
		"Teleport: Stormwind", "Teleport: Ironforge", "Teleport: Darnassus", "Teleport: Dalaran",
		"Teleport: Orgrimmar", "Teleport: Undercity", "Teleport: Thunder Bluff",
		"Portal: Stormwind", "Portal: Ironforge", "Portal: Darnassus",
		"Portal: Orgrimmar", "Portal: Undercity", "Portal: Thunder Bluff",
		"Polymorph: Cow", "Comprehend Scroll", "Study",
		"Perception", "Shatter Curse", "Cannibalize", "Escape Artist", "Rapid Regeneration", "Walk on Air",
	},
}
