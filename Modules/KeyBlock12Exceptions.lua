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
	⚠️ The spellbook reports a talent that REPLACES a spell under the replaced spell's id (KeybindAutoMap.lua, Blessed
	Hammer under 35395). So a line for such a spell carries both ids, and a "D" line is never keyed by an id another
	spec's real button reports (Steady Shot / Barbed Shot, Expunge / Naturalize were rejected for that reason).

	Source: four mh-research reviews + a second Opus check (scratchpad review12_g1..g4.md, review12_final.md, 24 Nov
	2026): 76 accepted lines, healers option A (Rob: "a ja": C = the healer's emergency heal, normal heals stay on 1-3).
	Facts per line (cooldowns, rotation use) are in review12_final.md: DB2 build 12.1.5.70961 and the 12.1.5 guides
	(Method / Icy Veins, Oct 2026). The "where it lands" of the moved spells is the helper's simulation of this allocator.
]]

ns.KEYBLOCK12_MN_EXCEPT = {
	-- Warrior
	[71] = { [190411] = "SHIFT-2", [1680] = "SHIFT-2" }, -- Whirlwind: AoE, not a form key
	[72] = { [184367] = "3", [1464] = "3", [6343] = "SHIFT-2" }, -- Rampage (spender, no cooldown) <-> Thunder Clap
	[73] = { [228920] = "SHIFT-2", [20243] = "SHIFT-3" }, -- Ravager <-> Devastate
	-- Paladin (Divine Shield 5 min is no "small, often" defensive; Redemption = the resurrect on Ctrl-R)
	[65] = { [498] = "Z", [403876] = "Z", [642] = "X", [7328] = "CTRL-R", [633] = "C" }, -- healer A: Lay on Hands on C
	[66] = { [53600] = "4", [31850] = "Z", [642] = "X", [7328] = "CTRL-R" }, -- Shield of the Righteous = the spender on 4
	[70] = { [642] = "C", [403876] = "Z", [1022] = "X", [7328] = "CTRL-R" },
	-- Hunter (Revive Pet = recovery out of combat)
	[253] = { [982] = "CTRL-R" },
	[254] = { [982] = "CTRL-R", [5384] = "SHIFT-X", [34477] = "SHIFT-Z" }, -- Feign Death, Misdirection
	[255] = { [982] = "CTRL-R", [5384] = "SHIFT-X", [34477] = "SHIFT-Z" },
	-- Rogue (Tricks of the Trade would fall to block D)
	[259] = { [57934] = "SHIFT-X" },
	[260] = { [57934] = "SHIFT-X" },
	[261] = { [57934] = "SHIFT-X" },
	-- Priest (healers A: Pain Suppression on C for Disc; Holy's Guardian Spirit is on C by rule)
	[256] = { [186263] = "D", [33206] = "C", [62618] = "X", [2006] = "CTRL-R" }, -- 186263 Shadow Mend: id only (Flash Heal button)
	[257] = { [2006] = "CTRL-R" }, -- Resurrection (role data added 24 Nov 2026)
	[258] = { [1227280] = "SHIFT-1", [15407] = "3", [585] = "3", [232698] = "CTRL-1", [2006] = "CTRL-R" },
	-- Death Knight (Anti-Magic Shell 1 min = the small defensive; Lichborne off the forms row; Raise Ally = resurrect)
	[250] = { [48707] = "Z", [49039] = "SHIFT-X", [50842] = "3", [195292] = "D", [61999] = "CTRL-R" },
	[251] = { [48707] = "Z", [49039] = "SHIFT-X", [49184] = "2", [196770] = "3", [207230] = "SHIFT-1", [61999] = "CTRL-R" },
	[252] = { [48707] = "Z", [49039] = "SHIFT-X", [61999] = "CTRL-R" },
	-- Shaman (Enhancement: Lightning Bolt = the Maelstrom spender on 4; Resto A: Nature's Swiftness on C)
	[263] = { [188196] = "4", [2645] = "CTRL-1", [2008] = "CTRL-R" },
	[264] = { [2008] = "CTRL-R", [378081] = "C", [108271] = "X" },
	[262] = { [2008] = "CTRL-R" },
	-- Mage (Conjure Refreshment = recovery on Ctrl-R)
	[62] = { [1449] = "SHIFT-1", [190336] = "CTRL-R" },
	[63] = { [190336] = "CTRL-R" },
	[64] = { [30455] = "4", [319836] = "4", [1449] = "D", [120] = "SHIFT-3", [157997] = "SHIFT-3", [190336] = "CTRL-R" },
	-- Warlock (Affliction: Unstable Affliction = the shard spender on 4)
	[265] = { [1259790] = "4", [1261153] = "SHIFT-3", [198590] = "1", [686] = "1" },
	[267] = { [152108] = "SHIFT-1" },
	-- Monk (Mistweaver A: Life Cocoon on C, Soothing Mist as the quick extra heal; Resuscitate on Ctrl-R)
	[269] = { [101546] = "SHIFT-1", [117952] = "D" },
	[270] = { [115178] = "CTRL-R", [116849] = "C", [115203] = "X", [115175] = "SHIFT-C" },
	-- Druid (Revive = resurrect on Ctrl-R; Resto A: Nature's Swiftness on C)
	[102] = { [50769] = "CTRL-R" },
	[103] = { [50769] = "CTRL-R", [5217] = "SHIFT-Q" },
	[104] = { [50769] = "CTRL-R" },
	[105] = { [50769] = "CTRL-R", [132158] = "C" },
	-- Demon Hunter (override buttons that only the superset dump sees: ids only)
	[577] = { [201427] = "D", [210152] = "D", [442294] = "D" },
	[1480] = { [1239123] = "SHIFT-1", [473728] = "3", [185123] = "D", [1217610] = "D" },
	-- Evoker (Devastation: Living Flame is the filler on 1; Preservation A: Rewind on C, Return on Ctrl-R)
	[1467] = { [361469] = "1", [362969] = "SHIFT-1", [359073] = "3" },
	[1468] = { [361227] = "CTRL-R", [1291636] = "SHIFT-1", [373861] = "SHIFT-1", [357208] = "SHIFT-3", [363534] = "C" },
}
