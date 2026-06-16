--[[
	Tier Set data (Rob-wens 16 jun, 1.8.1). Per class de set-naam, en per spec de
	2-set/4-set-bonus-spell-IDs zodat het paneel klikbare links toont (de live
	spell-tooltip geeft de actuele, gelokaliseerde bonus — never-lie-vriendelijk).

	Bron-posture: namen + IDs uit Wowhead 12.0.7-PTR (research 16 jun, zie
	SESSION_NOTES). De IDs zijn PTR-bevestigd; de tuning-waarden bewegen nog →
	het paneel toont een "bevestig in-game"-voet en leunt op de live tooltips.
	De DH-spec "Devourer" (nieuw in Midnight) heeft nog geen bevestigde specID →
	bewust weggelaten (paneel toont dan set-naam + "bekijk in-game").

	specID's zijn de stabiele retail-spec-IDs (al jaren onveranderd).
]]

local _, ns = ...

-- Tier-slots (INVSLOT): head, shoulder, chest, hands, legs.
ns.TIER_SLOTS = { 1, 3, 5, 10, 7 }

-- Set-naam per class (classFile → naam). Confirmed (Blizzard-blog / Icy-Veins).
ns.TIER_SET_BY_CLASS = {
	DEATHKNIGHT = "Relentless Rider's Lament",
	DEMONHUNTER = "Devouring Reaver's Sheathe",
	DRUID = "Sprouts of the Luminous Bloom",
	EVOKER = "Livery of the Black Talon",
	HUNTER = "Primal Sentry's Camouflage",
	MAGE = "Voidbreaker's Accordance",
	MONK = "Way of Ra-den's Chosen",
	PALADIN = "Luminant Verdict's Vestments",
	PRIEST = "Blind Oath's Burden",
	ROGUE = "Motley of the Grim Jest",
	SHAMAN = "Mantle of the Primal Core",
	WARLOCK = "Reign of the Abyssal Immolator",
	WARRIOR = "Rage of the Night Ender",
}

-- 2-set / 4-set-bonus-spell-IDs per specID (Wowhead 12.0.7-PTR).
ns.TIER_SPEC_BONUS = {
	-- Death Knight
	[250] = { s2 = 1264799, s4 = 1264800 }, -- Blood
	[251] = { s2 = 1264801, s4 = 1264802 }, -- Frost
	[252] = { s2 = 1264803, s4 = 1264804 }, -- Unholy
	-- Demon Hunter (Devourer = nieuw, specID onbevestigd → weggelaten)
	[577] = { s2 = 1264806, s4 = 1264807 }, -- Havoc
	[581] = { s2 = 1264808, s4 = 1264809 }, -- Vengeance
	-- Druid
	[102] = { s2 = 1264810, s4 = 1264811 }, -- Balance
	[103] = { s2 = 1264812, s4 = 1264813 }, -- Feral
	[104] = { s2 = 1264815, s4 = 1264816 }, -- Guardian
	[105] = { s2 = 1264817, s4 = 1264818 }, -- Restoration
	-- Evoker
	[1467] = { s2 = 1264821, s4 = 1264822 }, -- Devastation
	[1468] = { s2 = 1264823, s4 = 1264824 }, -- Preservation
	[1473] = { s2 = 1264819, s4 = 1264820 }, -- Augmentation
	-- Hunter
	[253] = { s2 = 1264825, s4 = 1264826 }, -- Beast Mastery
	[254] = { s2 = 1264828, s4 = 1264829 }, -- Marksmanship
	[255] = { s2 = 1264830, s4 = 1264831 }, -- Survival
	-- Mage
	[62] = { s2 = 1264832, s4 = 1264833 }, -- Arcane
	[63] = { s2 = 1264834, s4 = 1264835 }, -- Fire
	[64] = { s2 = 1264836, s4 = 1264837 }, -- Frost
	-- Monk
	[268] = { s2 = 1264838, s4 = 1264839 }, -- Brewmaster
	[270] = { s2 = 1264840, s4 = 1264841 }, -- Mistweaver
	[269] = { s2 = 1264842, s4 = 1264843 }, -- Windwalker
	-- Paladin
	[65] = { s2 = 1264844, s4 = 1264845 }, -- Holy
	[66] = { s2 = 1264846, s4 = 1264847 }, -- Protection
	[70] = { s2 = 1264848, s4 = 1264849 }, -- Retribution
	-- Priest
	[256] = { s2 = 1264850, s4 = 1264851 }, -- Discipline
	[257] = { s2 = 1264852, s4 = 1264853 }, -- Holy
	[258] = { s2 = 1264854, s4 = 1264855 }, -- Shadow
	-- Rogue
	[259] = { s2 = 1264856, s4 = 1264857 }, -- Assassination
	[260] = { s2 = 1264858, s4 = 1264859 }, -- Outlaw
	[261] = { s2 = 1264860, s4 = 1264861 }, -- Subtlety
	-- Shaman
	[262] = { s2 = 1264862, s4 = 1264863 }, -- Elemental
	[263] = { s2 = 1264864, s4 = 1264865 }, -- Enhancement
	[264] = { s2 = 1264866, s4 = 1264867 }, -- Restoration
	-- Warlock
	[265] = { s2 = 1264869, s4 = 1264870 }, -- Affliction
	[266] = { s2 = 1264871, s4 = 1264872 }, -- Demonology
	[267] = { s2 = 1264873, s4 = 1264874 }, -- Destruction
	-- Warrior
	[71] = { s2 = 1264875, s4 = 1264876 }, -- Arms
	[72] = { s2 = 1264877, s4 = 1264878 }, -- Fury
	[73] = { s2 = 1264879, s4 = 1264880 }, -- Protection
}
