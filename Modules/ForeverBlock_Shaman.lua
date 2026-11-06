local _, ns = ...

--[[
	ForeverBlock_Shaman.lua — the key-block table for the Shaman in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 6 Nov 2026: "Ja, 1 tot en met 5" (after "vertrouw ik op jouw expertise mbt de classes"), so this is the proposal
	from docs/forever/FOREVER_SHAMAN_2026-11-06.md as written. The open questions there were settled with the proposal's
	own pick: Ctrl-1/2/3 = the three totem Calls, weapon imbues on block D, key 3 = Stormstrike only, Totemic Call on
	Shift-R.
	Ghost Wolf (form 16) has no bonus bar (BonusActionBar 0, DB2 70790) and no key needs a different spell in it, so
	there are no states and no baseGuard.
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.SHAMAN = {
	states = {},
	keys = {
		["1"] = { base = "Lightning Bolt" },
		["2"] = { base = "Flame Shock" },
		["3"] = { base = "Stormstrike" },
		["4"] = { base = "Frost Shock" },
		["5"] = { base = "Searing Totem" },
		["SHIFT-1"] = { base = "Chain Lightning" },
		["SHIFT-2"] = { base = "Chain Heal" },
		["SHIFT-4"] = { base = "Fire Nova" },
		["Q"] = { base = { "Lightning Mastery", "Rage of the Farseer" } },
		["F1"] = { base = "Mana Tide Totem" },
		["SHIFT-3"] = { base = "Nature's Swiftness" },
		["F3"] = { base = "Ancestral Spirit" },
		["SHIFT-F1"] = { base = "Riptide" },
		["E"] = { base = "Earth Shock" },
		["R"] = { base = "Ghost Wolf" },
		["SHIFT-R"] = { base = "Totemic Call" },
		["F"] = { base = "Stoneclaw Totem" },
		["Z"] = { base = "Stoneskin Totem" },
		["X"] = { base = "Grounding Totem" },
		["C"] = { base = "Healing Wave" },
		["SHIFT-Z"] = { base = { "Water Shield", "Lightning Shield" } },
		["SHIFT-X"] = { base = "Strength of Earth Totem" },
		["SHIFT-C"] = { base = "Cure Poison" },
		["V"] = { base = "Earthbind Totem" },
		["SHIFT-Q"] = { base = "Purge" },
		["SHIFT-F"] = { base = "Tremor Totem" },
		["SHIFT-V"] = { base = "Cure Disease" },
		["F2"] = { base = "Lesser Healing Wave" },
		["F4"] = { base = "Healing Stream Totem" },
		["SHIFT-E"] = { all = { "Blood Fury", "War Stomp", "Berserking", "Stoneform", "Skysight" } },
		["CTRL-1"] = { base = "Call of the Elements" },
		["CTRL-2"] = { base = "Call of the Ancestors" },
		["CTRL-3"] = { base = "Call of the Spirits" },
	},
	toBlockD = { "Rockbiter Weapon", "Flametongue Weapon", "Frostbrand Weapon", "Windfury Weapon", "Magma Totem",
		"Totemic Recall", "Astral Recall", "Water Walking",
		"Shatter Curse", "Cultivation", "Rapid Regeneration", "Find Treasure", "Walk on Air" },
	-- Placed through Blizzard's totem bar (Call of the Elements/Ancestors/Spirits) or the spellbook: count as handled.
	listed = { "Frost Resistance Totem", "Flametongue Totem", "Mana Spring Totem", "Poison Cleansing Totem",
		"Fire Resistance Totem", "Disease Cleansing Totem", "Nature Resistance Totem", "Windfury Totem", "Sentry Totem",
		"Windwall Totem", "Grace of Air Totem", "Water Breathing", "Far Sight" },
}
