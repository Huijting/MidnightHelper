local _, ns = ...

--[[
	ForeverBlock_Warlock.lua — the key-block table for the Warlock in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 6 Nov 2026: "Ja, 1 tot en met 5" (after "vertrouw ik op jouw expertise mbt de classes"), so this is the proposal
	from docs/forever/FOREVER_WARLOCK_2026-11-06.md as written. The open questions there were settled with the
	proposal's own pick: E stays empty (the only interrupt is the Felhunter's pet spell, untested in a macro),
	Ctrl-1/2/3 = Conflagrate / Wrack-or-Incinerate / Bane of Havoc with the demon summons on block D, Drain Soul on 4.
	No forms, stances or stealth (DB2 70790): no bar paging, so no states and no base guard.
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.WARLOCK = {
	states = {},
	keys = {
		["1"] = { base = "Shadow Bolt" },
		["2"] = { base = "Corruption" },
		["3"] = { base = "Immolate" },
		["4"] = { base = "Drain Soul" },
		["SHIFT-4"] = { base = "Shadowburn" },
		["5"] = { base = "Bane of Agony" },
		["SHIFT-1"] = { base = "Rain of Fire" },
		["SHIFT-2"] = { base = "Hellfire" },
		["Q"] = { base = "Soul Fire" },
		["F1"] = { base = "Bane of Doom" },
		["SHIFT-3"] = { base = "Amplify Curse" },
		["F3"] = { base = "Inferno" },
		["SHIFT-F1"] = { base = "Fel Domination" },
		-- E stays empty on purpose: no interrupt of its own (Spell Lock belongs to the Felhunter).
		["R"] = { base = "Curse of Exhaustion" },
		["SHIFT-R"] = { base = "Unending Breath" },
		["F"] = { base = "Life Tap" },
		["Z"] = { base = "Shadow Ward" },
		["X"] = { base = "Death Coil" },
		["C"] = { base = "Drain Life" },
		["F2"] = { base = "Health Funnel" },
		["F4"] = { base = "Siphon Life" },
		["V"] = { base = "Fear" },
		["SHIFT-Q"] = { base = "Banish" },
		["SHIFT-F"] = { base = "Howl of Terror" },
		["SHIFT-V"] = { base = { "Curse of the Elements", "Curse of Weakness" } },
		["SHIFT-Z"] = { base = { "Demon Armor", "Demon Skin" } },
		["SHIFT-X"] = { base = "Soul Link" },
		["SHIFT-C"] = { base = "Demonic Sacrifice" },
		["SHIFT-E"] = { base = { "Will to Survive", "Blood Fury", "Will of the Forsaken", "Escape Artist", "Berserking" } },
		["CTRL-1"] = { base = "Conflagrate" },
		-- Wrack (31 Affliction points) and Incinerate (31 Destruction points) can never both be known (51 points).
		["CTRL-2"] = { base = { "Wrack", "Incinerate" } },
		["CTRL-3"] = { base = "Bane of Havoc" },
	},
	toBlockD = { "Summon Imp", "Summon Voidwalker", "Summon Succubus", "Summon Incubus", "Summon Felhunter",
		"Create Healthstone", "Create Soulstone", "Searing Pain", "Curse of Recklessness", "Curse of Tongues",
		"Ritual of Summoning", "Perception", "Shatter Curse", "Cannibalize", "Eureka!", "Rapid Regeneration" },
	listed = { "Shoot", "Create Spellstone", "Create Firestone", "Drain Mana", "Subjugate Demon", "Eye of Kilrogg",
		"Sense Demons", "Detect Invisibility", "Ritual of Doom", "Portal of Summoning" },
}
