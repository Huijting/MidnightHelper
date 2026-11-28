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
		-- 28 Nov 2026 (key swap, step b; ForeverBlock.lua SwapOn): Arcane Blast (a talent, 20 at the earliest) takes key 1
		-- once learned and Fireball moves to Ctrl-2; without the talent nothing changes (Fireball on 1, Ctrl-2 empty).
		["1"] = { base = { "Arcane Blast", "Fireball" },
			swapNote = { moved = "Fireball", movedKey = "CTRL-2" } },
		["2"] = { base = "Frostbolt" },
		["3"] = { base = "Arcane Missiles" },
		["4"] = { base = "Pyroblast" },
		["5"] = { base = "Fire Blast" },
		["SHIFT-4"] = { base = "Flamestrike" },
		["SHIFT-1"] = { base = "Blizzard" },
		["SHIFT-2"] = { base = "Arcane Explosion" },
		["CTRL-1"] = { base = "Scorch" },
		["CTRL-2"] = { base = "Fireball" },
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
	-- Block D has 12 places; an Alliance Mage at 60 had about 19 (research file, AFGELEID). Rob chose ("ja", 6 Nov 2026)
	-- to move the travel spells (all teleports and portals) and Comprehend Scroll / Study to `listed`: about 10 remain.
	toBlockD = {
		"Mage Armor", "Amplify Magic", "Dampen Magic",
		"Conjure Water", "Conjure Food", "Conjure Mana Agate", "Conjure Mana Jade", "Conjure Mana Citrine",
		"Conjure Mana Ruby",
		"Polymorph: Cow",
		"Perception", "Shatter Curse", "Cannibalize", "Escape Artist", "Rapid Regeneration", "Walk on Air",
	},
	listed = {
		"Teleport: Stormwind", "Teleport: Ironforge", "Teleport: Darnassus", "Teleport: Dalaran",
		"Teleport: Orgrimmar", "Teleport: Undercity", "Teleport: Thunder Bluff",
		"Portal: Stormwind", "Portal: Ironforge", "Portal: Darnassus",
		"Portal: Orgrimmar", "Portal: Undercity", "Portal: Thunder Bluff",
		"Comprehend Scroll", "Study",
	},
	-- 12 x 4 (Forever, 24 Nov 2026; /mh block style 12x4). From docs/forever/KEYBLOCK12_MAGE.md (mh-research,
	-- checked by a second helper). Rob via Sparring 24-11: "laat een agent uitzoeken welke spells logisch zijn per class".
	keys12 = {
		["1"] = { base = { "Arcane Blast", "Fireball" }, swapNote = { moved = "Fireball", movedKey = "CTRL-2" },
			why = "main nuke: Fireball, or Arcane Blast once you have that talent" },
		["2"] = { base = "Frostbolt", why = "main frost nuke; most guides level as Frost" },
		["3"] = { base = "Arcane Missiles", why = "arcane nuke; press it at once when Missile Barrage lights" },
		-- 4 <-> SHIFT-3 after the second check (KEYBLOCK12_REVIEW.md): Pyroblast is a Fire talent from 20 and Frost is
		-- the default tree, so 4 stayed empty for most mages; every mage has Fire Blast from level 6.
		["4"] = { base = "Fire Blast", why = "instant hit on an 8 s cooldown; also a finisher" },
		["Q"] = { base = { "Arcane Power", "Combustion" }, why = "your big damage cooldown (talent, 40)" },
		["E"] = { base = "Counterspell", why = "your interrupt: E is the kick key for every class" },
		["R"] = { base = "Blink", why = "your movement: R is the move key for every class" },
		["F"] = { base = "Ice Lance", why = "Frost: hit a Frozen enemy; shares a cooldown with Fire Blast" },
		["Z"] = { base = "Mana Shield", why = "small defensive" },
		["X"] = { base = "Ice Barrier", why = "second defensive: a shield that soaks damage (talent, 40)" },
		["C"] = { base = "Ice Block", why = "big defensive and emergency button; a Mage has no stun" },
		["V"] = { base = "Frost Nova", why = "crowd control: freezes the enemies around you" },
		["SHIFT-1"] = { base = "Blizzard", why = "AoE: hits several enemies" },
		["SHIFT-2"] = { base = "Arcane Explosion", why = "AoE around you" },
		["SHIFT-3"] = { base = "Pyroblast", why = "Fire talent: opener and Heating Up spender" },
		["SHIFT-4"] = { base = "Flamestrike", why = "fire AoE, under Pyroblast on 4" },
		["SHIFT-Q"] = { base = "Presence of Mind", why = "second cooldown: next cast instant; beside Arcane Power" },
		["SHIFT-E"] = { base = { "Blood Fury", "Berserking", "Eureka!", "Will of the Forsaken", "Will to Survive",
			"Read Leyline" }, why = "your race spell: Shift-E for every class" },
		["SHIFT-R"] = { base = "Slow Fall", why = "second movement: fall slowly" },
		["SHIFT-F"] = { base = "Cone of Cold", why = "crowd control 2: frost cone when the enemy is close" },
		["SHIFT-Z"] = { base = "Frost Ward", why = "second small defensive: a ward against frost" },
		["SHIFT-X"] = { base = "Fire Ward", why = "defensive: a ward against fire; shares a cooldown with Frost Ward" },
		["SHIFT-C"] = { base = "Cold Snap", why = "big defensive 2: resets your other Frost cooldowns" },
		["SHIFT-V"] = { base = "Polymorph", why = "crowd control 3: takes one enemy out of the fight" },
		["CTRL-1"] = { base = "Scorch", why = "no forms, so a spell: Fire's cast when the enemy is close" },
		["CTRL-2"] = { base = "Fireball", why = "Fireball, once Arcane Blast has taken key 1" },
		-- Same as the old block (Rob, 6 Nov 2026, "Doe maar" on 1B): wand until Frostfire Bolt is learned.
		["CTRL-3"] = { base = { "Frostfire Bolt", "Shoot" }, bang = true, why = "your wand until Frostfire Bolt (40) takes it" },
		["CTRL-4"] = { base = "Arcane Wrath", why = "Arcane talent hit; after Arcane Blast or Presence of Mind" },
		["CTRL-Q"] = { base = "Remove Lesser Curse", why = "helper: takes a curse off you or a friend" },
		["CTRL-E"] = { base = "Blast Wave", why = "cooldown: instant fire blast around you (Fire talent)" },
		["CTRL-R"] = { base = "Evocation", why = "recovery: gets your mana back" },
	},
	-- 28 Nov 2026 (key plan, Mage Frost): only with the direction Frost (band 3, ForeverDirection), Frostbolt takes key 1
	-- once learned (level 4) and Fireball moves to 2; before 4, Fireball stays on 1 and 2 is empty. Ctrl-2 keeps Arcane
	-- Blast (a Frost mage does not have it), so Fireball is not on two keys. Same in both layouts.
	dirKeys = {
		[3] = {
			keys = {
				["1"] = { base = { "Frostbolt", "Fireball" }, swapNote = { moved = "Fireball", movedKey = "2" } },
				["2"] = { base = "Fireball" },
				["CTRL-2"] = { base = "Arcane Blast" },
			},
			keys12 = {
				["1"] = { base = { "Frostbolt", "Fireball" }, swapNote = { moved = "Fireball", movedKey = "2" },
					why = "Frost: Frostbolt is your main nuke from level 4" },
				["2"] = { base = "Fireball", why = "Fireball, once Frostbolt has taken key 1" },
				["CTRL-2"] = { base = "Arcane Blast", why = "Arcane's talent nuke" },
			},
		},
	},
	-- 28 Nov 2026: the old layout of the swapped keys, for "Swap keys" off.
	noSwap = {
		keys = {
			["1"] = { base = "Fireball" },
			["CTRL-2"] = { base = "Arcane Blast" },
		},
		keys12 = {
			["1"] = { base = "Fireball", why = "main fire nuke from level 1; the old block's key 1" },
			["CTRL-2"] = { base = "Arcane Blast", why = "Arcane's talent nuke, as in the old block" },
		},
	},
}
