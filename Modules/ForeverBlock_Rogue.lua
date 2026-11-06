local _, ns = ...

--[[
	ForeverBlock_Rogue.lua — the key-block table for the Rogue in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 6 Nov 2026: "Ja, 1 tot en met 5" (after "vertrouw ik op jouw expertise mbt de classes"), so this is the proposal
	from docs/forever/FOREVER_ROGUE_2026-11-06.md as written. The open questions there were settled with the proposal's
	own pick: Garrote on 1 in Stealth, Pick Pocket on F in Stealth (Feint on F outside it), racial heals on F4, ranged on
	Shift-2 by equipped weapon, C stays empty, poisons (items) stay on block D.
	Stealth = form 30 with BonusActionBar 1 (DB2 70790); stealth spells guard the base spells with [nobonusbar:1].
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.ROGUE = {
	states = {
		{ name = "stealth", cond = "[bonusbar:1]", guards = true },
		-- Ranged key only (Shift-2): pick the shot that matches the equipped ranged weapon.
		{ name = "gun", cond = "[equipped:Guns]" },
		{ name = "bow", cond = "[equipped:Bows]" },
		{ name = "xbow", cond = "[equipped:Crossbows]" },
	},
	baseGuard = "[nobonusbar:1]",
	keys = {
		["1"] = { stealth = "Garrote", base = "Sinister Strike" },
		["2"] = { stealth = "Ambush", base = "Backstab" },
		["3"] = { all = { "Mutilate", "Hemorrhage" } },
		["4"] = { all = "Eviscerate" },
		["5"] = { all = "Rupture" },
		["SHIFT-4"] = { all = "Slice and Dice" },
		["SHIFT-1"] = { all = "Blade Flurry" },
		["SHIFT-2"] = { gun = "Shoot Gun", bow = "Shoot Bow", xbow = "Shoot Crossbow", base = "Throw" },
		["SHIFT-3"] = { all = "Shank" },
		["Q"] = { all = { "Adrenaline Rush", "Death Mark" } },
		["F1"] = { all = "Cold Blood" },
		["F3"] = { all = "Preparation" },
		["SHIFT-F1"] = { all = "Riposte" },
		["E"] = { all = "Kick" },
		["R"] = { all = "Sprint" },
		["SHIFT-R"] = { all = "Stealth" },
		["F"] = { stealth = "Pick Pocket", base = "Feint" },
		["Z"] = { all = "Evasion" },
		["X"] = { all = "Vanish" },
		["SHIFT-Z"] = { all = "Expose Armor" },
		["SHIFT-X"] = { all = "Ghostly Strike" },
		["SHIFT-C"] = { all = "Premeditation" },
		["V"] = { stealth = "Cheap Shot", base = "Kidney Shot" },
		["SHIFT-Q"] = { stealth = "Sap", base = "Gouge" },
		["SHIFT-F"] = { all = "Distract" },
		["SHIFT-V"] = { all = "Blind" },
		["F4"] = { all = { "Cannibalize", "Rapid Regeneration", "Read Leyline" } },
		["SHIFT-E"] = { all = { "Shadowmeld", "Perception", "Blood Fury", "Stoneform", "Will of the Forsaken",
			"Escape Artist", "Berserking", "Walk on Air" } },
	},
	toBlockD = { "Pick Lock", "Disarm Trap", "Redirect", "Elune's Light", "Will to Survive", "Shatter Curse",
		"Find Treasure", "Eureka!", "Skysight" },
	listed = { "Poisons" }, -- the profession spell; may appear in the spellbook scan
}
