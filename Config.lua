--[[
	MidnightHelper — Config.lua

	Currency IDs for the profession UI. Anything unverified stays OUT: a wrong
	currency id does not show nothing, it shows another currency's real balance
	under your profession's name (proved with /mh moxie, 19 jul).
	Load order: after Core.lua, before modules that read ns.Config.
]]

local addonName, ns = ...

local E = Enum and Enum.Profession

local Config = {
	--- World event / profession books (Unalloyed Abundance).
	--- DELIBERATELY nil. 3401 was the last survivor of the guessed batch, and /mh moxie
	--- (Rob, 19 jul) showed the game calls it "12.0 Delves - Personal Tracker - S1 Weekly
	--- Turn-In (Hidden)" -- a hidden internal counter, not a player currency. Worse than a
	--- dead id: it resolves, so the panel happily showed that counter's balance under the
	--- Unalloyed Abundance label and compared it against recipe costs.
	--- Do NOT fill this in from a wiki or a plausible-looking number. Confirm in-game first:
	--- the name GetCurrencyInfo returns must actually read "Unalloyed Abundance".
	UNALLOYED_ABUNDANCE_CURRENCY_CODE = nil,
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

-- Artisan's Moxie currency ids — DELIBERATELY EMPTY.
--
-- This table held 13 guessed ids (3402-3414): only Herbalism 3402 came from a
-- spec and the rest were counted up alphabetically from it. Rob ran `/mh moxie`
-- in-game on 2026-07-19 and the game answered: TEN of the thirteen do not exist
-- at all, and the three that do are unrelated currencies —
--   3405 = Field Accolade          (was labelled Cooking)
--   3409 = [DNT] 12.0 Midseason - Voidforge Unlock - Turn-In Tracker (Inscription)
--   3410 = Slayer's Duellum        (Jewelcrafting)
-- Even 3402 does not resolve. So every id was wrong, and three of them made the
-- profession panel print another currency's real balance as your Moxie, with the
-- recipe tooltip comparing that balance against a cost. Showing nothing is right.
--
-- Every consumer guards on the lookup (Profession.lua:610, :810, :1481), so an
-- empty table simply omits the Moxie line. Fill it ONLY with ids confirmed by
-- `/mh moxie` naming the actual Artisan's Moxie for that profession.

ns.Config = Config
