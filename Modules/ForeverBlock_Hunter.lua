local _, ns = ...

--[[
	ForeverBlock_Hunter.lua — the key-block table for the Hunter in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 6 Nov 2026: "Ja, alle drie" — he left the class choices to us ("vertrouw ik op jouw expertise"), so this is the
	proposal from docs/forever/FOREVER_HUNTER_2026-11-06.md, ranged-first, with `bang` on key 1: "/cast !Auto Shot" so a
	second press does not stop the shooting (Classic behaviour; not yet measured in Forever).
	The Hunter has no form, stance or stealth that pages the bar (DB2 70790), so there are no states. Melee and ranged
	get separate keys: macros have no condition for distance.
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.HUNTER = {
	states = {},
	keys = {
		-- 28 Nov 2026 (the key swap, ForeverBlock.lua SwapOn): Hunter's Mark takes key 1 once learned (level 6), Auto Shot
		-- then moves to Shift-Z; before that Auto Shot stays on 1 (fallback) and Shift-Z is empty. Rob measured that
		-- Serpent Sting and Arcane Shot start Auto Shot by themselves, Hunter's Mark does not. swapNote = the alert.
		["1"] = { base = { "Hunter's Mark", "Auto Shot" }, bang = { ["Auto Shot"] = true },
			swapNote = { to = "Hunter's Mark", moved = "Auto Shot", movedKey = "SHIFT-Z" } },
		["2"] = { base = "Serpent Sting" },
		["3"] = { base = "Arcane Shot" },
		["4"] = { base = "Aimed Shot" },
		["5"] = { base = "Raptor Strike" },
		["SHIFT-1"] = { base = "Multi-Shot" },
		["SHIFT-2"] = { base = { "Explosive Trap", "Immolation Trap" } },
		["SHIFT-3"] = { base = "Intimidation" },
		["SHIFT-4"] = { base = "Sniper Shot" },
		["Q"] = { base = "Rapid Fire" },
		["F1"] = { base = "Bestial Wrath" },
		["SHIFT-F1"] = { base = "Summon Hawk" },
		["F3"] = { base = "Revive Pet" },
		["E"] = { base = "Scatter Shot" },
		["R"] = { base = "Aspect of the Cheetah" },
		-- Rob, 6 Nov 2026 ("Doe maar" on 2B): Ctrl-1/2/3 stay the pet's keys, so the main aspect moved here and
		-- Strider Kick, Aspect of the Monkey and Aspect of the Beast went to block D.
		["SHIFT-R"] = { base = "Aspect of the Hawk" },
		["F"] = { base = "Distracting Shot" },
		["Z"] = { base = "Disengage" },
		["X"] = { base = "Feign Death" },
		["C"] = { base = "Deterrence" },
		["V"] = { base = "Freezing Trap" },
		["SHIFT-Q"] = { base = "Concussive Shot" },
		["SHIFT-F"] = { base = "Wing Clip" },
		["SHIFT-V"] = { base = "Counterattack" },
		["SHIFT-Z"] = { base = "Auto Shot", bang = true },
		["SHIFT-X"] = { base = "Trueshot Aura" },
		["SHIFT-C"] = { base = "Mongoose Bite" },
		["F2"] = { base = "Mend Pet" },
		["F4"] = { base = "Call Pet" },
		-- The pet's three commands, in the order of Blizzard's pet bar (attack, follow, stay). From level 10 (Call Pet).
		["CTRL-1"] = { cmd = { text = "/petattack", needs = "Call Pet", label = "Pet: Attack", icon = "Ability_GhoulFrenzy" } },
		["CTRL-2"] = { cmd = { text = "/petfollow", needs = "Call Pet", label = "Pet: Follow", icon = "Ability_Tracking" } },
		["CTRL-3"] = { cmd = { text = "/petstay", needs = "Call Pet", label = "Pet: Stay", icon = "Spell_Nature_TimeStop" } },
		["SHIFT-E"] = { all = { "Shadowmeld", "War Stomp", "Stoneform", "Blood Fury", "Berserking", "Perception", "Walk on Air" } },
	},
	-- Block D has 12 places. The pet keys sent Monkey, Beast and Strider Kick here (14-15 at 60), so Rob chose ("ja",
	-- 6 Nov 2026) to move the out-of-combat Feed Pet, Dismiss Pet and Scare Beast to `listed` (place them yourself).
	toBlockD = {
		"Aspect of the Monkey", "Aspect of the Beast", "Strider Kick",
		"Volley", "Frost Trap", "Viper Sting", "Scorpid Sting", "Aspect of the Pack", "Aspect of the Wild",
		"Tranquilizing Shot", "Flare",
		"Will to Survive", "Shatter Curse", "Find Treasure", "Elune's Light", "Cultivation", "Rapid Regeneration",
		"Read Leyline", "Skysight",
	},
	listed = {
		"Feed Pet", "Dismiss Pet", "Scare Beast",
		"Tame Beast", "Beast Training", "Beast Lore", "Eyes of the Beast", "Eagle Eye", "Immolation Trap",
		"Track Beasts", "Track Humanoids", "Track Undead", "Track Hidden", "Track Elementals", "Track Demons",
		"Track Giants", "Track Dragonkin",
	},
	-- 12 x 4 (Forever, 24 Nov 2026; /mh block style 12x4). From docs/forever/KEYBLOCK12_HUNTER.md (mh-research,
	-- checked by a second helper). Rob via Sparring 24-11: "laat een agent uitzoeken welke spells logisch zijn per class".
	keys12 = {
		-- Bar A (no modifier)
		["1"] = { base = { "Hunter's Mark", "Auto Shot" }, bang = { ["Auto Shot"] = true },
			swapNote = { to = "Hunter's Mark", moved = "Auto Shot", movedKey = "SHIFT-Z" },
			why = "first press of a fight: Hunter's Mark from level 6 (Auto Shot until then)" },
		["2"] = { base = "Serpent Sting", why = "Serpent Sting first, damage over time" },
		["3"] = { base = "Arcane Shot", why = "instant shot: Arcane Shot" },
		["4"] = { base = "Aimed Shot", why = "big shot: Aimed Shot (stand still)" },
		["Q"] = { base = "Rapid Fire", why = "big cooldown: Rapid Fire" },
		["E"] = { base = { "Scatter Shot", "Intimidation" }, why = "stop a cast: Scatter Shot, or your pet's Intimidation" },
		["R"] = { base = "Aspect of the Cheetah", why = "movement: Aspect of the Cheetah" },
		["F"] = { base = "Mend Pet", why = "help spell: Mend Pet heals your pet" },
		["Z"] = { base = "Disengage", why = "small defensive: Disengage lowers threat up close" },
		["X"] = { base = "Feign Death", why = "second defensive: Feign Death" },
		["C"] = { base = "Deterrence", why = "big defensive: Deterrence" },
		["V"] = { base = "Freezing Trap", why = "crowd control: Freezing Trap" },
		-- Bar B (Shift)
		["SHIFT-1"] = { base = "Multi-Shot", why = "AoE: Multi-Shot" },
		["SHIFT-2"] = { base = { "Explosive Trap", "Immolation Trap" }, why = "AoE trap: Explosive, before 34 Immolation" },
		["SHIFT-3"] = { base = "Summon Hawk", why = "Summon Hawk shares a cooldown with Arcane Shot on 3" },
		["SHIFT-4"] = { base = { "Sniper Shot", "Bestial Wrath" }, why = "level-40 talent: Sniper Shot or Bestial Wrath" },
		["SHIFT-Q"] = { base = "Concussive Shot", why = "slow: Concussive Shot" },
		["SHIFT-E"] = { all = { "Shadowmeld", "War Stomp", "Stoneform", "Blood Fury", "Berserking", "Perception",
			"Walk on Air" }, why = "your race spell" },
		["SHIFT-R"] = { base = "Aspect of the Hawk", why = "main aspect: Aspect of the Hawk" },
		["SHIFT-F"] = { base = "Wing Clip", why = "crowd control 2: Wing Clip slows up close" },
		["SHIFT-Z"] = { base = "Auto Shot", bang = true,
			why = "Auto Shot from level 6 (a second press keeps shooting); Serpent Sting and Arcane Shot start it too" },
		["SHIFT-X"] = { base = "Raptor Strike", why = "melee hit: Raptor Strike, was key 5" },
		["SHIFT-C"] = { base = "Mongoose Bite", why = "melee: Mongoose Bite after a dodge" },
		["SHIFT-V"] = { base = "Counterattack", why = "crowd control 3: Counterattack after a parry" },
		-- Bar C (Ctrl); CTRL-F/Z/X/C/V are the fixed items
		["CTRL-1"] = { cmd = { text = "/petattack", needs = "Call Pet", label = "Pet: Attack", icon = "Ability_GhoulFrenzy" },
			why = "pet: attack your target" },
		["CTRL-2"] = { cmd = { text = "/petfollow", needs = "Call Pet", label = "Pet: Follow", icon = "Ability_Tracking" },
			why = "pet: follow you" },
		["CTRL-3"] = { cmd = { text = "/petstay", needs = "Call Pet", label = "Pet: Stay", icon = "Spell_Nature_TimeStop" },
			why = "pet: stay where it is" },
		["CTRL-4"] = { base = "Call Pet", why = "Call Pet, next to the three pet keys" },
		["CTRL-Q"] = { base = "Trueshot Aura", why = "group buff: Trueshot Aura" },
		["CTRL-E"] = { base = "Distracting Shot", why = "taunt: Distracting Shot, rarely needed" },
		["CTRL-R"] = { base = "Revive Pet", why = "your dead pet back: Revive Pet" },
	},
	-- 28 Nov 2026: the layout of the swapped keys when the player switches "Swap keys" off (the old behaviour).
	noSwap = {
		keys = {
			["1"] = { base = "Auto Shot", bang = true },
			["SHIFT-Z"] = { base = "Hunter's Mark" },
		},
		keys12 = {
			["1"] = { base = "Auto Shot", bang = true, why = "main button: Auto Shot; a second press keeps shooting" },
			["SHIFT-Z"] = { base = "Hunter's Mark", why = "Hunter's Mark, once per enemy" },
		},
	},
}
