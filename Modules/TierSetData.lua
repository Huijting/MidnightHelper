--[[
	Tier Set data — what is left of it.

	🔴 THE TWO TABLES THAT USED TO LIVE HERE ARE GONE (29 aug 2026, Rob's call).

	`ns.TIER_SET_BY_CLASS` held 13 class set names and `ns.TIER_SPEC_BONUS` held ~38 spec
	entries of 2-set/4-set bonus spell IDs. Both came from a Wowhead 12.0.7-PTR datamine
	researched on 16 June, which is SEASON 1 — and they were still being shown as this
	season's truth on 28 aug, more than a week into Season 2. Rob and his tester could not
	make sense of the Tier Sets page; the reason was that we were naming the wrong set.

	A table keyed to a season rots every season. This one rotted three times without anyone
	noticing, because nothing about a wrong name looks wrong.

	Everything those tables held is in the tooltip of a tier piece the player is WEARING:
	the set name, the count, all five piece names, and both bonus texts — already
	translated by the game, and impossible to have stale. `ReadWornTierSet` in
	`TierSet.lua` reads it. Measured on Rob's Shaman, 29 aug 2026.

	⚠️ WHAT WE GAVE UP, ON PURPOSE. Worn gear answers "which set am I wearing", not "which
	set is my class's THIS SEASON". Rob's Shaman wears last season's tier, so his gear says
	"Mantle of the Primal Core" — correct about him, and no answer at all for someone with
	nothing on. There is no client source for the second question. The page now answers the
	one it can, and says so plainly when there is nothing to read.

	🔴 DO NOT REINTRODUCE A SET TABLE TO CLOSE THAT GAP. That is precisely the thing that was
	wrong for three months. If a client-side source for the current season's set is ever
	found, use that; a hand-maintained list is not a source.
]]

local _, ns = ...

-- Tier-slots (INVSLOT): head, shoulder, chest, hands, legs. Kept because it is a fact
-- about the game's slot numbering, not about a season — and TierSet.lua walks it.
ns.TIER_SLOTS = { 1, 3, 5, 10, 7 }
