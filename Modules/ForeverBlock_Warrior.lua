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
}
