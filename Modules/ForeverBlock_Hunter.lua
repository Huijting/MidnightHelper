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
		["1"] = { base = "Auto Shot", bang = true },
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
		["SHIFT-R"] = { base = "Strider Kick" },
		["F"] = { base = "Distracting Shot" },
		["Z"] = { base = "Disengage" },
		["X"] = { base = "Feign Death" },
		["C"] = { base = "Deterrence" },
		["V"] = { base = "Freezing Trap" },
		["SHIFT-Q"] = { base = "Concussive Shot" },
		["SHIFT-F"] = { base = "Wing Clip" },
		["SHIFT-V"] = { base = "Counterattack" },
		["SHIFT-Z"] = { base = "Hunter's Mark" },
		["SHIFT-X"] = { base = "Trueshot Aura" },
		["SHIFT-C"] = { base = "Mongoose Bite" },
		["F2"] = { base = "Mend Pet" },
		["F4"] = { base = "Call Pet" },
		["CTRL-1"] = { base = "Aspect of the Hawk" },
		["CTRL-2"] = { base = "Aspect of the Monkey" },
		["CTRL-3"] = { base = "Aspect of the Beast" },
		["SHIFT-E"] = { all = { "Shadowmeld", "War Stomp", "Stoneform", "Blood Fury", "Berserking", "Perception", "Walk on Air" } },
	},
	toBlockD = {
		"Volley", "Frost Trap", "Viper Sting", "Scorpid Sting", "Scare Beast", "Aspect of the Pack", "Aspect of the Wild",
		"Tranquilizing Shot", "Flare", "Feed Pet", "Dismiss Pet",
		"Will to Survive", "Shatter Curse", "Find Treasure", "Elune's Light", "Cultivation", "Rapid Regeneration",
		"Read Leyline", "Skysight",
	},
	listed = {
		"Tame Beast", "Beast Training", "Beast Lore", "Eyes of the Beast", "Eagle Eye", "Immolation Trap",
		"Track Beasts", "Track Humanoids", "Track Undead", "Track Hidden", "Track Elementals", "Track Demons",
		"Track Giants", "Track Dragonkin",
	},
}
