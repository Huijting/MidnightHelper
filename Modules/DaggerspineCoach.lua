--[[
	Daggerspine Point ritual-boss-scaffold (14 jun). De tweede Ritual Site in de
	rotatie. We registreren de boss-entry vast (picker + 3D-model + stage-info)
	zodat het klaarstaat zodra Daggerspine de actieve week is; de exacte
	abilities + scenario/stepIDs vullen we uit Robs eerste run (spy + death
	recaps), net zoals we de Broken Throne hebben opgebouwd.

	Web-geverifieerd (14 jun datamining): zone 16939; eindboss Lady Selen'vjar
	npc 257498 (Ritual Chest object 602746); stage 2 = void-empowered Mindbreaker
	(npc nog te bevestigen). Stages: Ritual Roles / Beast From the Deep /
	Summoner's Fall.

	Géén auto-trigger hier: Daggerspine's scenarioID/stepIDs kennen we nog niet
	(Broken Throne = 3236). Die leert de spy zodra Rob de site draait; daarna
	kunnen we de trigger generaliseren.
]]

local _, ns = ...

local ENTRY = {
	key = "ritual_daggerspine",
	name = "Daggerspine Point",
	bosses = {
		{
			key = "mindbreaker",
			name = "Empowered Mindbreaker",
			-- Stage 2 "Beast From the Deep"; npcID nog onbekend → model leert
			-- zich vanzelf van het boss1-frame zodra Rob de stage draait.
		},
		{
			key = "selenvjar",
			name = "Lady Selen'vjar",
			-- Stage 3 "Summoner's Fall"; web-geverifieerd npc 257498.
			seedCreatureId = 257498,
		},
	},
}

ns.CUSTOM_BOSS_ENTRIES = ns.CUSTOM_BOSS_ENTRIES or {}
ns.CUSTOM_BOSS_ENTRIES[ENTRY.key] = ENTRY
if type(ns.DUNGEON_TIPS) == "table" then
	ns.DUNGEON_TIPS[ENTRY.key] = {
		mindbreaker = { steps = "RITUAL_BOSS_MINDBREAKER_STEPS" },
		selenvjar = { steps = "RITUAL_BOSS_SELENVJAR_STEPS" },
	}
end
