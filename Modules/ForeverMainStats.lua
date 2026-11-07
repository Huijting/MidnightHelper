local _, ns = ...

--[[
	ForeverMainStats.lua — per class, the primary stats that matter most while LEVELING solo in WoW Forever, for the
	quest reward hint (ForeverQuestHint.lua).

	Source: mh-research, 7 Nov 2026 — docs/forever/FOREVER_MAIN_STATS_2026-11-07.md (every row with its sources).
	  - GEMETEN: the Forever client has no primary stat to ask (wago ChrSpecialization 1.60.1.70862: PrimaryStatPriority 0
	    on every class row), so MH needs this table.
	  - GEMETEN in client strings: Agility gives attack power to Hunter and Rogue, to Druid only in Cat Form, to Warrior only
	    ranged; Shaman and Paladin get none from Agility.
	  - The default is the solo leveling role the guides agree on (Retribution, Enhancement, Feral, Shadow).
	  - Disputed: Ret Paladin and Enhancement Shaman (guides split Strength vs Intellect). Chosen: Strength first, flipping
	    to Intellect once the talent that converts Intellect is known (`later`); the levels are AFGELEID, the talent check is
	    what the hint uses.
	main    = in order; the hint weighs the first 1 and the second 0.5 (MH's own choice, AFGELEID).
	stamTie = Stamina breaks a tie (when it is not already a main stat).
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_MAIN_STATS = {
	WARRIOR = { main = { "STRENGTH", "AGILITY" }, stamTie = true },
	PALADIN = { main = { "STRENGTH", "INTELLECT" }, stamTie = true,
		later = { talent = "Champion of the Light", main = { "INTELLECT", "STRENGTH" } } },
	HUNTER = { main = { "AGILITY", "SPIRIT" }, stamTie = false,
		later = { talent = "Careful Aim", main = { "AGILITY", "INTELLECT" } } },
	ROGUE = { main = { "AGILITY", "STRENGTH" }, stamTie = true },
	PRIEST = { main = { "INTELLECT", "SPIRIT" }, stamTie = true },
	SHAMAN = { main = { "STRENGTH", "INTELLECT" }, stamTie = false,
		later = { talent = "Mental Dexterity", main = { "INTELLECT", "STRENGTH" } } },
	MAGE = { main = { "INTELLECT", "SPIRIT" }, stamTie = true },
	WARLOCK = { main = { "INTELLECT", "STAMINA" }, stamTie = true },
	DRUID = { main = { "AGILITY", "STRENGTH" }, stamTie = true },
}
