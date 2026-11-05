local _, ns = ...

--[[
	ForeverBlock_Druid.lua — the APPROVED key-block table for the Druid in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 5 Nov 2026: "ja goedzo" on docs/PLAN_FOREVER_DRUID_BLOK_2026-11-05.md; placed and seen working on his level 8
	Night Elf Druid the same evening ("whoohoo het werkt"). Spells and levels: docs/FOREVER_DRUID_SPELLS_2026-11-05.md.

	Forms by bar paging, not by form index (which depends on the order forms were learned):
	  bonusbar 1/2 = Cat (and Prowl), 3 = Bear, 4 = Moonkin. AFGELEID from Rob's /mh spellbook dump (Attack on slots
	  73/85/97/109 = pages 7-10) and EllesmereUI's paging; Moonkin keeps the caster spells, so the base guard excludes
	  1-3 only. To be tested at level 10 (Bear) and 20 (Cat).
	Two additions to the approved table: War Stomp on Shift-E for a Tauren (no Shadowmeld), and `open` on R so Bear keeps
	Travel/Aquatic Form ("idem" in the table; the offline test caught the first version guarding it).
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.DRUID = {
	states = {
		{ name = "bear", cond = "[bonusbar:3]", guards = true },
		{ name = "cat", cond = "[bonusbar:1/2]", guards = true },
		{ name = "swim", cond = "[swimming]" },
	},
	baseGuard = "[nobonusbar:1/2/3]",
	keys = {
		["1"] = { bear = "Maul", cat = "Claw", base = "Wrath" },
		["2"] = { bear = "Lacerate", cat = "Rake", base = "Moonfire" },
		["3"] = { bear = "Primal Bite", cat = "Shred", base = "Starfire" },
		["4"] = { cat = "Rip", base = "Insect Swarm" },
		["SHIFT-4"] = { cat = "Ferocious Bite" },
		["5"] = { all = "Faerie Fire" },
		["SHIFT-1"] = { bear = "Swipe", base = "Hurricane" },
		["SHIFT-2"] = { bear = "Demoralizing Roar", base = "Wild Growth" },
		["Q"] = { bear = "Enrage", cat = "Shifting Power", base = "Tranquility" },
		["F1"] = { base = "Innervate" },
		["SHIFT-3"] = { base = "Nature's Swiftness" },
		["SHIFT-F1"] = { base = "Swiftmend" },
		["F3"] = { pair = { cond = "[combat]", first = "Rebirth", second = "Revive" } },
		["E"] = { bear = "Feral Charge", cat = "Feral Charge" },
		["V"] = { bear = "Bash", cat = "Pounce", base = "Entangling Roots" },
		["SHIFT-Q"] = { base = "Hibernate" },
		["SHIFT-F"] = { bear = "Challenging Roar", base = "Soothe Animal" },
		["SHIFT-V"] = { base = "Remove Curse" },
		["SHIFT-C"] = { base = { "Abolish Poison", "Cure Poison" } },
		["R"] = { cat = "Dash", swim = "Aquatic Form", base = "Travel Form", open = true },
		["SHIFT-R"] = { cat = "Prowl" },
		["F"] = { bear = "Growl", cat = "Cower" },
		["Z"] = { all = "Barkskin" },
		["X"] = { bear = "Frenzied Regeneration", base = "Nature's Grasp" },
		["C"] = { base = "Healing Touch" },
		["F2"] = { base = "Regrowth" },
		["F4"] = { base = "Rejuvenation" },
		["SHIFT-Z"] = { base = "Thorns" },
		["SHIFT-X"] = { base = { "Gift of the Wild", "Mark of the Wild" } },
		["SHIFT-E"] = { all = { "Shadowmeld", "War Stomp" } },
		["CTRL-1"] = { base = { "Dire Bear Form", "Bear Form" } },
		["CTRL-2"] = { base = "Cat Form" },
		["CTRL-3"] = { base = "Moonkin Form" },
	},
	toBlockD = { "Teleport: Moonglade", "Track Humanoids", "Ravage", "Elune's Light" },
}
