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
	-- 12 x 4 (Forever, 24 Nov 2026; /mh block style 12x4). From docs/forever/KEYBLOCK12_SHAMAN.md (mh-research,
	-- checked by a second helper). Rob via Sparring 24-11: "laat een agent uitzoeken welke spells logisch zijn per class".
	keys12 = {
		["1"] = { base = "Lightning Bolt", why = "main attack spell" },
		["2"] = { base = "Flame Shock", why = "rotation: fire damage, then more over time" },
		["3"] = { base = "Stormstrike", why = "rotation (Enhancement): press it whenever it is ready" },
		["4"] = { base = "Searing Totem", why = "your damage totem: put it down at every pull" },
		["Q"] = { base = { "Lightning Mastery", "Rage of the Farseer" }, why = "big cooldown of your talent tree" },
		["E"] = { base = "Earth Shock", why = "your interrupt: E is the kick key for every class" },
		["R"] = { base = "Ghost Wolf", why = "movement: run as a wolf" },
		["F"] = { base = "Stoneclaw Totem", why = "no taunt: enemies attack this totem instead" },
		["Z"] = { base = "Stoneskin Totem", why = "small defensive: less damage from melee hits" },
		["X"] = { base = "Grounding Totem", why = "second defensive: catches one harmful spell" },
		["C"] = { base = "Healing Wave", why = "big heal: your big defensive, you have no shield wall" },
		["V"] = { base = "Earthbind Totem", why = "crowd control: slows enemies near it" },
		["SHIFT-1"] = { base = "Chain Lightning", why = "AoE: hits several enemies" },
		["SHIFT-2"] = { base = "Chain Heal", why = "AoE heal: cast it on your Riptide target" },
		["SHIFT-3"] = { base = "Nature's Swiftness", why = "cooldown: next nature spell is instant, then Healing Wave (C)" },
		["SHIFT-4"] = { base = "Fire Nova", why = "AoE: needs a Fire totem down, like Searing Totem (4)" },
		["SHIFT-Q"] = { base = "Mana Tide Totem", why = "second cooldown: mana back for your group" },
		["SHIFT-E"] = { all = { "Blood Fury", "War Stomp", "Berserking", "Stoneform", "Skysight" }, why = "your race spell" },
		["SHIFT-R"] = { base = "Totemic Call", why = "second movement: moves your totems to you" },
		["SHIFT-F"] = { base = "Tremor Totem", why = "second control key: removes fear, charm and sleep" },
		["SHIFT-Z"] = { base = { "Water Shield", "Lightning Shield" }, why = "second small defensive: your shield" },
		["SHIFT-X"] = { base = "Riptide", why = "heal over time on the tank, then Chain Heal (Shift-2)" },
		["SHIFT-C"] = { base = "Lesser Healing Wave", why = "quick heal, next to Healing Wave on C" },
		["SHIFT-V"] = { base = "Frost Shock", why = "third control key: slows; shares the shock cooldown" },
		["CTRL-1"] = { base = "Call of the Elements", why = "totem set 1 from your totem bar" },
		["CTRL-2"] = { base = "Call of the Ancestors", why = "totem set 2 from your totem bar" },
		["CTRL-3"] = { base = "Call of the Spirits", why = "totem set 3 from your totem bar" },
		["CTRL-4"] = { base = "Strength of Earth Totem", why = "buff totem; before level 20 there is no totem bar" },
		["CTRL-Q"] = { base = "Cure Poison", why = "remove poison from a friend" },
		["CTRL-E"] = { base = "Cure Disease", why = "remove a disease from a friend" },
		["CTRL-R"] = { base = "Ancestral Spirit", why = "bring a dead friend back, outside a fight" },
	},
}
