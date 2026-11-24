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
	-- 12 x 4 (Forever, 24 Nov 2026; /mh block style 12x4). From docs/forever/KEYBLOCK12_ROGUE.md (mh-research,
	-- checked by a second helper). Rob via Sparring 24-11: "laat een agent uitzoeken welke spells logisch zijn per class".
	keys12 = {
		-- Bar A (no modifier)
		["1"] = { stealth = "Garrote", base = "Sinister Strike", why = "main hit; Garrote from Stealth" },
		["2"] = { stealth = "Ambush", base = "Backstab", why = "Backstab from behind; Ambush from Stealth" },
		-- 24 Nov 2026 (same fallback as the Warlock's key 3, Sparring 24-11): without Mutilate or Hemorrhage (Combat, the
		-- default tree) key 3 stayed empty all game while Shank (trainer, level 24) sat on Shift-3. Now Shank is the fallback.
		["3"] = { all = { "Mutilate", "Hemorrhage", "Shank" }, why = "talent builder: Mutilate or Hemorrhage; Shank without them" },
		["4"] = { all = "Eviscerate", why = "main finisher: Eviscerate" },
		["Q"] = { all = { "Adrenaline Rush", "Death Mark" }, why = "your level-40 talent: Adrenaline Rush or Death Mark" },
		["E"] = { all = "Kick", why = "your interrupt: E is the kick key for every class" },
		["R"] = { all = "Sprint", why = "movement: Sprint" },
		["F"] = { stealth = "Pick Pocket", base = "Feint", why = "Feint lowers threat; Pick Pocket from Stealth" },
		["Z"] = { all = "Evasion", why = "small defensive: Evasion" },
		["X"] = { all = "Vanish", why = "escape: Vanish (needs a Flash Powder)" },
		["C"] = { all = "Preparation", why = "emergency: Preparation readies Vanish, Evasion, Sprint" },
		["V"] = { stealth = "Cheap Shot", base = "Kidney Shot", why = "stun: Kidney Shot; Cheap Shot from Stealth" },
		-- Bar B (Shift)
		["SHIFT-1"] = { all = "Blade Flurry", why = "AoE: Blade Flurry, your only two-target tool" },
		["SHIFT-2"] = { gun = "Shoot Gun", bow = "Shoot Bow", xbow = "Shoot Crossbow", base = "Throw",
			why = "ranged pull: the shot for your weapon, else Throw" },
		["SHIFT-3"] = { all = "Shank", why = "Shank: short cooldown, gives Energy back" },
		["SHIFT-4"] = { all = "Slice and Dice", why = "second finisher: Slice and Dice" },
		["SHIFT-Q"] = { all = "Cold Blood", why = "second cooldown: Cold Blood before a big finisher" },
		["SHIFT-E"] = { all = { "Shadowmeld", "Perception", "Blood Fury", "Stoneform", "Will of the Forsaken",
			"Escape Artist", "Berserking", "Walk on Air" }, why = "your race spell" },
		["SHIFT-R"] = { all = "Stealth", why = "Stealth in and out; same key as the Druid's Prowl" },
		["SHIFT-F"] = { stealth = "Sap", base = "Gouge", why = "crowd control 2: Gouge; Sap from Stealth" },
		["SHIFT-Z"] = { all = "Riposte", why = "after a parry: Riposte disarms the enemy" },
		["SHIFT-X"] = { all = "Ghostly Strike", why = "defensive hit: Ghostly Strike gives more dodge" },
		["SHIFT-C"] = { all = "Premeditation", why = "Premeditation: 2 combo points before your opener" },
		["SHIFT-V"] = { all = "Blind", why = "crowd control 3: Blind (needs a Blinding Powder)" },
		-- Bar C (Ctrl); CTRL-1/2/3 stay empty (no forms); CTRL-F/Z/X/C/V are the fixed items
		["CTRL-4"] = { all = "Rupture", why = "third finisher: Rupture, on key 4 like Eviscerate" },
		["CTRL-Q"] = { all = "Distract", why = "utility: Distract" },
		["CTRL-E"] = { all = "Expose Armor", why = "group finisher: Expose Armor" },
		["CTRL-R"] = { all = { "Cannibalize", "Rapid Regeneration", "Read Leyline" },
			why = "your race's heal, outside a fight" },
	},
}
