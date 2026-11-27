local _, ns = ...

--[[
	ForeverBlock_Warrior.lua — the key-block table for the Warrior in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 6 Nov 2026: "Ja, 1 tot en met 5" (after "vertrouw ik op jouw expertise mbt de classes"), so this is the proposal
	from docs/forever/FOREVER_WARRIOR_2026-11-06.md as written. The open questions there were settled with the
	proposal's own pick: key 2 = each stance's own strike, Ctrl-1/2/3 = Battle/Defensive/Berserker (stance-bar order),
	Charge stays on R in Defensive (works with the Vanguard talent), no stance-dance macros (a key never changes stance).
	bonusbar 1/2/3 = Battle/Defensive/Berserker (DB2 SpellShapeshiftForm.BonusActionBar, build 1.60.1.70790).
	No guards and no baseGuard: every "all" spell works in every stance, and no key mixes one with stance spells.
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.WARRIOR = {
	states = {
		{ name = "battle", cond = "[bonusbar:1]" },
		{ name = "defensive", cond = "[bonusbar:2]" },
		{ name = "berserker", cond = "[bonusbar:3]" },
	},
	keys = {
		-- Block A
		["1"] = { all = "Heroic Strike" },
		["2"] = { battle = "Overpower", defensive = "Revenge", berserker = "Whirlwind" },
		["3"] = { all = { "Mortal Strike", "Bloodthirst", "Shield Slam" } },
		["4"] = { battle = "Execute", berserker = "Execute" },
		["SHIFT-1"] = { battle = "Thunder Clap", defensive = "Thunder Clap" },
		["SHIFT-2"] = { all = "Demoralizing Shout" },
		["SHIFT-3"] = { all = "Death Wish" },
		["F1"] = { all = "Bloodrage" },
		["Z"] = { defensive = "Shield Block" },
		["X"] = { all = "Last Stand" },
		["C"] = { battle = "Retaliation", defensive = "Shield Wall" },
		["V"] = { battle = "Hamstring", defensive = "Disarm", berserker = "Hamstring" },
		-- Block B
		["5"] = { all = "Sunder Armor" },
		["Q"] = { battle = "Sweeping Strikes", berserker = "Recklessness" },
		["E"] = { battle = "Shield Bash", defensive = "Shield Bash", berserker = "Pummel" },
		["R"] = { battle = "Charge", defensive = "Charge", berserker = "Intercept" }, -- Defensive: Vanguard talent only
		["F"] = { battle = "Mocking Blow", defensive = "Taunt" },
		["F2"] = { all = "Victory Rush" },
		["SHIFT-Q"] = { all = "Intimidating Shout" },
		["SHIFT-F"] = { all = "Challenging Shout" },
		["SHIFT-R"] = { all = "Piercing Howl" },
		-- Block C
		["CTRL-1"] = { all = "Battle Stance" },
		["CTRL-2"] = { all = "Defensive Stance" },
		["CTRL-3"] = { all = "Berserker Stance" },
		["F3"] = { battle = "Spearing Strike" },
		["SHIFT-E"] = { all = { "Blood Fury", "Berserking", "Stoneform", "Will of the Forsaken", "War Stomp",
			"Escape Artist", "Shadowmeld", "Will to Survive", "Walk on Air" } },
		["SHIFT-4"] = { all = "Cleave" },
		["SHIFT-F1"] = { all = "Reckless Swings" },
		["SHIFT-Z"] = { battle = "Rend", defensive = "Rend" },
		["SHIFT-X"] = { all = "Battle Shout" },
		["SHIFT-C"] = { all = "Slam" },
		["SHIFT-V"] = { battle = "Concussion Blow", defensive = "Concussion Blow", berserker = "Berserker Rage" },
	},
	toBlockD = { "Shoot Bow", "Shoot Gun", "Shoot Crossbow", "Throw", "Perception", "Shatter Curse", "Find Treasure",
		"Cannibalize", "Cultivation", "Eureka!", "Elune's Light", "Rapid Regeneration", "Read Leyline", "Skysight" },
	-- 12 x 4 (Forever, 24 Nov 2026; /mh block style 12x4). From docs/forever/KEYBLOCK12_WARRIOR.md (mh-research,
	-- checked by a second helper). Rob via Sparring 24-11: "laat een agent uitzoeken welke spells logisch zijn per class".
	keys12 = {
		-- Bar A (no modifier)
		["1"] = { all = "Heroic Strike", why = "main hit in every stance" },
		["2"] = { battle = "Overpower", defensive = "Revenge", berserker = "Whirlwind",
			why = "your stance's own strike: Overpower, Revenge or Whirlwind" },
		["3"] = { all = { "Mortal Strike", "Bloodthirst", "Shield Slam" }, why = "your level-40 talent strike" },
		-- 27 Nov 2026 (Rob via Sparring 27-11: "Ik volg uiteraard je advies."): key 4 was empty in Defensive Stance while the
		-- tank's Sunder Armor sat on Shift-C. GEMETEN (DB2 71139): Execute only in Battle/Berserker, Sunder in every stance.
		["4"] = { battle = "Execute", defensive = "Sunder Armor", berserker = "Execute",
			why = "finisher Execute below 20% health; in Defensive Stance the tank's Sunder Armor" },
		["Q"] = { battle = "Sweeping Strikes", berserker = "Recklessness", why = "big cooldown of your stance" },
		["E"] = { battle = "Shield Bash", defensive = "Shield Bash", berserker = "Pummel",
			why = "your interrupt: E is the kick key for every class" },
		["R"] = { battle = "Charge", defensive = "Charge", berserker = "Intercept",
			why = "movement: Charge, or Intercept in Berserker Stance" }, -- Defensive: Vanguard talent only
		["F"] = { battle = "Mocking Blow", defensive = "Taunt", why = "taunt: Taunt, or Mocking Blow in Battle Stance" },
		["Z"] = { defensive = "Shield Block", berserker = "Berserker Rage",
			why = "small defensive: Shield Block or Berserker Rage" },
		["X"] = { all = "Last Stand", why = "emergency button: Last Stand" },
		["C"] = { battle = "Retaliation", defensive = "Shield Wall", why = "big defensive: Shield Wall or Retaliation" },
		["V"] = { battle = "Hamstring", defensive = "Disarm", berserker = "Hamstring",
			why = "crowd control: Hamstring, or Disarm in Defensive Stance" },
		-- Bar B (Shift)
		["SHIFT-1"] = { battle = "Thunder Clap", defensive = "Thunder Clap", why = "AoE: Thunder Clap" },
		["SHIFT-2"] = { all = "Demoralizing Shout", why = "AoE: Demoralizing Shout" },
		["SHIFT-3"] = { all = "Death Wish", why = "cooldown: Death Wish" },
		["SHIFT-4"] = { all = "Cleave", why = "AoE rage spender: Cleave" },
		["SHIFT-Q"] = { all = "Bloodrage", why = "second cooldown: Bloodrage, Rage to start a fight" },
		["SHIFT-E"] = { all = { "Blood Fury", "Berserking", "Stoneform", "Will of the Forsaken", "War Stomp",
			"Escape Artist", "Shadowmeld", "Will to Survive", "Walk on Air" }, why = "your race spell" },
		["SHIFT-R"] = { all = "Piercing Howl", why = "no second movement: Piercing Howl slows enemies" },
		["SHIFT-F"] = { all = "Intimidating Shout", why = "crowd control 2: Intimidating Shout" },
		["SHIFT-Z"] = { battle = "Rend", defensive = "Rend", why = "bleed: Rend, kept where it was" },
		["SHIFT-X"] = { all = "Victory Rush", why = "your self heal after a kill: Victory Rush" },
		-- 27 Nov 2026: Sunder Armor moved to 4 (Defensive Stance); Shift-C is free.
		-- Concussion Blow has no stance limit (GEMETEN: no SpellShapeshift row), so Berserker too.
		["SHIFT-V"] = { battle = "Concussion Blow", defensive = "Concussion Blow", berserker = "Concussion Blow",
			why = "crowd control 3: stun, in every stance" },
		-- Bar C (Ctrl); CTRL-F/Z/X/C/V are the fixed items
		["CTRL-1"] = { all = "Battle Stance", why = "stance 1" },
		["CTRL-2"] = { all = "Defensive Stance", why = "stance 2" },
		["CTRL-3"] = { all = "Berserker Stance", why = "stance 3" },
		["CTRL-4"] = { all = "Slam", why = "no fourth stance, so Slam lives here" },
		["CTRL-Q"] = { all = "Battle Shout", why = "buff: Battle Shout, before the fight" },
		["CTRL-E"] = { all = "Challenging Shout", why = "rare tank button: Challenging Shout" },
		["CTRL-R"] = { all = "Reckless Swings", why = "Rage back: Reckless Swings (costs health)" },
	},
}
