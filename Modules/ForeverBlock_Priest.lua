local _, ns = ...

--[[
	ForeverBlock_Priest.lua — the key-block table for the Priest in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 6 Nov 2026: "Ja, 1 tot en met 5" (after "vertrouw ik op jouw expertise mbt de classes"), so this is the proposal
	from docs/forever/FOREVER_PRIEST_2026-11-06.md as written. The open questions there were settled with the proposal's
	own pick: Mind Flay takes over key 1 from Smite once learned, the race's own priest spells share X and Shift-R,
	Shoot (wand) on 5, no Shadowform state.
	No states: Shadowform (form 28) has BonusActionBar 0 on Forever and does not page bar 1 (DB2 70790).
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.PRIEST = {
	states = {},
	keys = {
		["1"] = { base = { "Mind Flay", "Smite" } },
		["2"] = { base = "Shadow Word: Pain" },
		["3"] = { base = "Mind Blast" },
		["4"] = { base = "Holy Fire" },
		["SHIFT-4"] = { base = "Shadow Word: Death" },
		["5"] = { base = "Shoot" },
		["SHIFT-1"] = { base = "Holy Nova" },
		["SHIFT-2"] = { base = "Prayer of Healing" },
		["SHIFT-3"] = { base = "Devouring Plague" },
		["Q"] = { base = "Power Infusion" },
		["F1"] = { base = "Inner Focus" },
		["SHIFT-F1"] = { base = "Penance" },
		["F3"] = { base = "Resurrection" },
		["E"] = { base = "Silence" },
		["R"] = { base = "Levitate" },
		["SHIFT-R"] = { base = { "Starshards", "Chastise", "Divine Grace", "Hex of Weakness", "Dark Sacrifice", "Confounding Flash" } },
		["F"] = { base = "Fade" },
		["Z"] = { base = "Power Word: Shield" },
		["X"] = { base = { "Desperate Prayer", "Elune's Grace", "Feedback", "Shadowguard", "Touch of Weakness", "Contingency Plan" } },
		["C"] = { base = { "Greater Heal", "Heal", "Lesser Heal" } },
		["SHIFT-Z"] = { base = "Inner Fire" },
		["SHIFT-X"] = { base = { "Prayer of Fortitude", "Power Word: Fortitude" } },
		["SHIFT-C"] = { base = { "Abolish Disease", "Cure Disease" } },
		["V"] = { base = "Psychic Scream" },
		["SHIFT-Q"] = { base = "Shackle Undead" },
		["SHIFT-F"] = { base = "Mind Control" },
		["SHIFT-V"] = { base = "Dispel Magic" },
		["F2"] = { base = "Flash Heal" },
		["F4"] = { base = "Renew" },
		["SHIFT-E"] = { all = { "Will of the Forsaken", "Stoneform", "Shadowmeld", "Escape Artist", "Berserking", "Will to Survive" } },
		["CTRL-1"] = { base = "Shadowform" },
		["CTRL-2"] = { base = "Prayer of Mending" },
		["CTRL-3"] = { base = "Vampiric Embrace" },
	},
	toBlockD = {
		"Fear Ward", "Divine Spirit", "Prayer of Spirit", "Shadow Protection", "Prayer of Shadow Protection",
		"Mind Soothe", "Mind Vision", "Mana Burn", "Lightwell",
		"Perception", "Find Treasure", "Elune's Light", "Cannibalize", "Rapid Regeneration", "Eureka!",
	},
}
