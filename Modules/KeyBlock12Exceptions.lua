local _, ns = ...

--[[
	KeyBlock12Exceptions.lua — WoW Midnight, key block layout "12 x 4": the exceptions per spec.

	Rob via Sparring 24-11, 24 Nov 2026: "A A A" = 1a: the 12 x 4 block comes from the same role data as the old block
	(KeybindRoles_*.lua) through a second role-to-key table (KeyBlock.lua ANCHOR12 / CATEGORY12), then mh-research checks
	every spec and a second Opus helper checks that; where the rule table puts a spell against the job of a key, an
	exception here fixes it. KeyBlockAllocate applies these first (step 0), only for 12 x 4 in Midnight.

	[specID] = { [spellID] = "KEY" (binding notation: "C", "SHIFT-C", "CTRL-R") or "D" (block D) }
	By spell ID: in the game a spell's name is the client's localised spellbook name. A string key (the English name as
	in KeybindRoles) is matched only as a fallback, i.e. on an English client.
]]

ns.KEYBLOCK12_MN_EXCEPT = {
}
