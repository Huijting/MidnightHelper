--[[
	MidnightHelper — Config.lua

	Currency IDs for profession UI (placeholders until official IDs are confirmed in-game).
	Load order: after Core.lua, before modules that read ns.Config.
]]

local addonName, ns = ...

local E = Enum and Enum.Profession

local Config = {
	--- World event / profession books (Unalloyed Abundance).
	UNALLOYED_ABUNDANCE_CURRENCY_CODE = 3401,
	--- Weekly tracker: Shards of Dundun (bags / weekly progress display).
	SHARD_OF_DUNDUN_ITEM_ID = 258901,
	--- Delve consumables (minimap quick-use + Delves tab currency line).
	DELVE_ITEM_RAID_R_MINI = 244193, -- L00T RAID-R Mini — highlights Mislaid Curiosities
	--- On-use spell from item tooltip (Scan the environment… for rest of delve).
	DELVE_ITEM_RAID_R_MINI_USE_SPELL = 1236623,
	--- Hidden helpful aura after using the mini (+ item on-use spell from GetItemSpell).
	DELVE_ITEM_RAID_R_MINI_SPELLS = { 1236623, 467033, 473679, 1236625 },
	DELVE_ITEM_TROVEHUNTER_BOUNTY = 252415, -- Trovehunter's Bounty — Hidden Trove
	--- Buff after using Trovehunter's Bounty (persists until the trove is earned).
	DELVE_ITEM_TROVEHUNTER_BOUNTY_SPELL = 1254631,
	--- Maps Enum.Profession → Artisan's Moxie currency ID for that trade.
	ARTISANS_MOXIE_CURRENCY_CODES = {},
}

if E then
	-- Placeholder sequential IDs (Herbalism = 3402 per Phase 72 spec); adjust when official IDs ship.
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Alchemy] = 3403
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Blacksmithing] = 3404
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Cooking] = 3405
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Enchanting] = 3406
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Engineering] = 3407
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Fishing] = 3408
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Herbalism] = 3402
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Inscription] = 3409
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Jewelcrafting] = 3410
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Leatherworking] = 3411
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Mining] = 3412
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Skinning] = 3413
	Config.ARTISANS_MOXIE_CURRENCY_CODES[E.Tailoring] = 3414
end

ns.Config = Config
