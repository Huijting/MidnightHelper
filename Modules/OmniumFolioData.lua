--[[
	Omnium Folio — data-only (Rob-wens 17 jun, 1.8.2). De 12.0.7 borrowed-power
	rune-tree: 5 rijen, 1 per wekelijkse reset, geen gear-slot, vrij wisselbaar.

	Bron: ConquestCapped "Omnium Folio Guide" (10 jun 2026) — rune-namen +
	Wowhead spell-IDs — gekruist met MH's eigen PTR_12.0.7_DATA.md (de
	"Seeking Knowledge"-questketen 96410/96441-96444 was al in-huis bevestigd).
	Zie docs/PATCH_12_0_7_ADVICE.md voor de volledige verificatie + open punten.

	never-lie: spell-namen komen LIVE uit de spell-tooltip (GetSpellLinkMarkup);
	wij hardcoden alleen onze eigen korte effect-omschrijving + de aanbevelingen.
	Account-wide vs per-char is een OPEN discrepantie (CC zegt per-char, MH-note
	zei account) → de UI zegt dit eerlijk, geen harde claim.
]]

local _, ns = ...

-- 5 rijen. choice=false → geen keuze (iedereen krijgt 'm). De rune-key dient
-- als stabiele id voor de build-aanbevelingen hieronder.
ns.OMNIUM_FOLIO = {
	-- Unlock-keten: voltooien van quest[i] ontgrendelt rij i (rij 1 = intro).
	unlockQuests = { 96410, 96441, 96442, 96443, 96444 },
	unlockNpc = "Grand Magister Rommath", -- Magisters' Terrace (Isle of Quel'Danas)
	-- Folio-unlock-storyline "The Sunstrider Omnium" (Zygor-data, 19 jun):
	-- 96223 The Magister's Call -> 96225 -> 96226 -> 96227 -> 96228 -> 96229
	-- -> 96230 Unravelling the Wards -> 96231 The Grand Magister's Key-Cipher
	-- (Belo'vir's Arcane Vault; item 274261) -> 96232 -> 96233 -> 96410
	-- (Rommath overhandigt de Folio). Daarna ontgrendelen de weekly
	-- "Seeking Knowledge"-quests hieronder de rijen. Folio-item: spell 1302265.
	-- Eenmalige unlock-storyline (voltooien -> Folio-overhandiging bij 96410):
	unlockStoryQuests = { 96223, 96225, 96226, 96227, 96228, 96229, 96230, 96231, 96232, 96233 },

	-- Per-week objective van de wekelijkse "Seeking Knowledge"-quest (Wowhead-gids
	-- 12 jun + in-game). Index = week (1..5). De checklist toont het objective van
	-- de eerstvolgende-te-ontgrendelen rij. Item-IDs: Ritualized Arcana 274576,
	-- Dark-Ley Coalescence 274577.
	weeklyObjectiveKeys = {
		"OMNIUM_WK_OBJ_1",
		"OMNIUM_WK_OBJ_2",
		"OMNIUM_WK_OBJ_3",
		"OMNIUM_WK_OBJ_4",
		"OMNIUM_WK_OBJ_5",
	},

	rows = {
		{
			key = "core",
			week = 1,
			titleKey = "OMNIUM_ROW_CORE",
			choice = true,
			runes = {
				{ key = "orbs", spell = 1279596, nameKey = "OMNIUM_RUNE_ORBS", descKey = "OMNIUM_RUNE_ORBS_DESC" },
				{ key = "fire", spell = 1279599, nameKey = "OMNIUM_RUNE_FIRE", descKey = "OMNIUM_RUNE_FIRE_DESC" },
			},
		},
		{
			key = "def",
			week = 2,
			titleKey = "OMNIUM_ROW_DEF",
			choice = true,
			runes = {
				{ key = "selfmend", spell = 1279603, nameKey = "OMNIUM_RUNE_SELFMEND", descKey = "OMNIUM_RUNE_SELFMEND_DESC" },
				{ key = "shell", spell = 1279604, nameKey = "OMNIUM_RUNE_SHELL", descKey = "OMNIUM_RUNE_SHELL_DESC" },
				{ key = "lynx", spell = 1279605, nameKey = "OMNIUM_RUNE_LYNX", descKey = "OMNIUM_RUNE_LYNX_DESC" },
			},
		},
		{
			key = "ling",
			week = 3,
			titleKey = "OMNIUM_ROW_LING",
			choice = false,
			runes = {
				{ key = "lingering", spell = 1287555, nameKey = "OMNIUM_RUNE_LINGERING", descKey = "OMNIUM_RUNE_LINGERING_DESC" },
			},
		},
		{
			key = "stat",
			week = 4,
			titleKey = "OMNIUM_ROW_STAT",
			choice = true,
			runes = {
				{ key = "crit", spell = 1279609, nameKey = "OMNIUM_RUNE_CRIT", descKey = "OMNIUM_RUNE_CRIT_DESC" },
				{ key = "haste", spell = 1287774, nameKey = "OMNIUM_RUNE_HASTE", descKey = "OMNIUM_RUNE_HASTE_DESC" },
				{ key = "mastery", spell = 1287771, nameKey = "OMNIUM_RUNE_MASTERY", descKey = "OMNIUM_RUNE_MASTERY_DESC" },
				{ key = "vers", spell = 1279613, nameKey = "OMNIUM_RUNE_VERS", descKey = "OMNIUM_RUNE_VERS_DESC" },
			},
		},
		{
			key = "cap",
			week = 5,
			titleKey = "OMNIUM_ROW_CAP",
			choice = true,
			runes = {
				{ key = "overload", spell = 1279614, nameKey = "OMNIUM_RUNE_OVERLOAD", descKey = "OMNIUM_RUNE_OVERLOAD_DESC" },
				{ key = "residual", spell = 1279615, nameKey = "OMNIUM_RUNE_RESIDUAL", descKey = "OMNIUM_RUNE_RESIDUAL_DESC" },
				{ key = "echoes", spell = 1279616, nameKey = "OMNIUM_RUNE_ECHOES", descKey = "OMNIUM_RUNE_ECHOES_DESC" },
			},
		},
	},

	-- Aanbevolen pick per rij, per content-type (ConquestCapped-baselines).
	-- "spec" = volg je eigen spec-stat (geen vaste rune; UI toont een hint).
	modes = { "mplus", "raid", "pvp", "world" },
	builds = {
		mplus = { core = "orbs", def = "shell", ling = "lingering", stat = "spec", cap = "overload" },
		raid = { core = "orbs", def = "shell", ling = "lingering", stat = "spec", cap = "echoes" },
		pvp = { core = "orbs", def = "lynx", ling = "lingering", stat = "vers", cap = "overload" },
		world = { core = "orbs", def = "selfmend", ling = "lingering", stat = "vers", cap = "overload" },
	},
}
