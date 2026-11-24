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
	-- 12 x 4 (Forever, 24 Nov 2026; /mh block style 12x4). From docs/forever/KEYBLOCK12_PRIEST.md (mh-research,
	-- checked by a second helper). Rob via Sparring 24-11: "laat een agent uitzoeken welke spells logisch zijn per class".
	keys12 = {
		["1"] = { base = { "Mind Flay", "Smite" }, why = "main attack: Smite, then Mind Flay once you have it" },
		["2"] = { base = "Shadow Word: Pain", why = "your damage over time; put it on first" },
		["3"] = { base = "Mind Blast", why = "shadow hit on an 8 s cooldown" },
		-- bang = "/cast !Shoot": a second press does not switch the wand off (second check, as the Mage's wand key).
		["4"] = { base = "Shoot", bang = true, why = "your wand: finish the enemy with it and save mana" },
		["Q"] = { base = "Power Infusion", why = "big cooldown: more spell damage and healing (talent)" },
		["E"] = { base = "Silence", why = "your interrupt (talent, 30): E is the kick key for every class" },
		["R"] = { base = "Levitate", why = "your movement spell: R is the move key for every class" },
		["F"] = { base = "Fade", why = "helper: enemies want to attack you less for a while" },
		["Z"] = { base = "Power Word: Shield", why = "small defensive: a shield on you or a friend" },
		["X"] = { base = { "Desperate Prayer", "Elune's Grace", "Feedback", "Shadowguard", "Touch of Weakness",
			"Contingency Plan" }, why = "your race's own priest spell; the same key for every race" },
		["C"] = { base = { "Greater Heal", "Heal", "Lesser Heal" }, why = "your main heal; a bigger one takes over when learned" },
		["V"] = { base = "Psychic Scream", why = "crowd control: enemies around you run away" },
		["SHIFT-1"] = { base = "Holy Nova", why = "AoE around you: hurts enemies, heals your group" },
		["SHIFT-2"] = { base = "Prayer of Healing", why = "AoE heal for a group" },
		["SHIFT-3"] = { base = "Devouring Plague", why = "second DoT, beside Mind Blast; it also heals you" },
		["SHIFT-4"] = { base = "Shadow Word: Death", why = "finisher beside the wand: only when it will kill" },
		["SHIFT-Q"] = { base = "Penance", why = "second cooldown: heal or hit every 12 s (talent)" },
		["SHIFT-E"] = { all = { "Will of the Forsaken", "Stoneform", "Shadowmeld", "Escape Artist", "Berserking",
			"Will to Survive" }, why = "your race spell: Shift-E for every class" },
		["SHIFT-R"] = { base = { "Starshards", "Chastise", "Divine Grace", "Hex of Weakness", "Dark Sacrifice",
			"Confounding Flash" }, why = "your race's other priest spell; no second movement spell" },
		["SHIFT-F"] = { base = "Mind Control", why = "crowd control 2" },
		["SHIFT-Z"] = { base = "Renew", why = "second small defensive: a heal over time, under Shield" },
		["SHIFT-X"] = { base = "Dispel Magic", why = "defensive: takes magic off a friend" },
		["SHIFT-C"] = { base = "Flash Heal", why = "quick heal: one key from your main heal on C" },
		["SHIFT-V"] = { base = "Shackle Undead", why = "crowd control 3: holds one Undead enemy" },
		["CTRL-1"] = { base = "Shadowform", why = "your form: press again to leave it, so you can heal" },
		["CTRL-2"] = { base = "Prayer of Mending", why = "Holy talent: a heal that jumps on" },
		["CTRL-3"] = { base = "Vampiric Embrace", why = "Shadow talent: your damage heals your group" },
		["CTRL-4"] = { base = "Holy Fire", why = "opener when Discipline plays alone; Ctrl on the wand key" },
		["CTRL-Q"] = { base = "Inner Focus", why = "cooldown: your next spell costs no mana" },
		["CTRL-E"] = { base = { "Abolish Disease", "Cure Disease" }, why = "helper: takes a disease off you or a friend" },
		["CTRL-R"] = { base = "Resurrection", why = "out of combat: brings a dead friend back" },
	},
}
