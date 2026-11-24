local _, ns = ...

--[[
	ForeverBlock_Paladin.lua — the key-block table for the Paladin in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 6 Nov 2026: "Ja, alle drie" — he left the class choices to us ("vertrouw ik op jouw expertise"), so this is the
	proposal from docs/forever/FOREVER_PALADIN_2026-11-06.md as written, with one change: Sense Undead moved from
	toBlockD to listed, because block D was one place too full at level 60 (13 for 12; the proposal's own suggestion).
	The Paladin has no form or stance that pages the bar (DB2 SpellShapeshiftForm 70790), so there are no states.
	Blessings are pairs: in a group the Greater version, solo the normal one.
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.PALADIN = {
	states = {},
	keys = {
		["1"] = { base = "Holy Strike" },
		["2"] = { base = "Judgement" },
		["3"] = { base = { "Seal of Command", "Seal of Righteousness" } },
		["4"] = { base = "Hammer of Wrath" },
		["5"] = { base = "Exorcism" },
		["SHIFT-4"] = { base = "Holy Shield" },
		["SHIFT-1"] = { base = "Consecration" },
		["SHIFT-2"] = { base = "Hammer of the Righteous" },
		["Q"] = { base = "Lay on Hands" },
		["F1"] = { base = "Swift Judgement" },
		["SHIFT-3"] = { base = "Divine Favor" },
		["SHIFT-F1"] = { base = "Light's Vigil" },
		["F3"] = { pair = { cond = "[combat]", first = "Divine Intervention", second = "Redemption" } },
		["E"] = { base = "Hammer of Justice" },
		["R"] = { base = "Blessing of Freedom" },
		["SHIFT-R"] = { base = "Oath of Light" },
		["F"] = { base = "Seal of Fury" },
		["Z"] = { base = { "Divine Shield", "Divine Protection" } },
		["X"] = { base = "Templar's Bulwark" },
		["C"] = { base = "Holy Light" },
		["F2"] = { base = "Flash of Light" },
		["F4"] = { base = "Holy Shock" },
		["V"] = { base = "Repentance" },
		["SHIFT-Q"] = { base = "Turn Undead" },
		["SHIFT-F"] = { base = "Blessing of Protection" },
		["SHIFT-Z"] = { pair = { cond = "[group]", first = "Greater Blessing of Might", second = "Blessing of Might" } },
		["SHIFT-X"] = { pair = { cond = "[group]", first = "Greater Blessing of Kings", second = "Blessing of Kings" } },
		["SHIFT-V"] = { pair = { cond = "[group]", first = "Greater Blessing of Wisdom", second = "Blessing of Wisdom" } },
		["SHIFT-C"] = { base = { "Cleanse", "Purify" } },
		["SHIFT-E"] = { all = { "Stoneform", "Will to Survive", "Will of the Forsaken" } },
		["CTRL-1"] = { base = "Devotion Aura" },
		["CTRL-2"] = { base = "Retribution Aura" },
		["CTRL-3"] = { base = "Concentration Aura" },
	},
	toBlockD = {
		"Righteous Fury", "Seal of the Crusader", "Seal of Justice", "Seal of Light", "Seal of Wisdom",
		"Blessing of Sacrifice", "Holy Wrath", "Voice of Truth", "Shadow Resistance Aura", "Frost Resistance Aura",
		"Fire Resistance Aura", "Perception", "Find Treasure", "Cannibalize",
	},
	listed = { "Sense Undead" },
	-- 12 x 4 (Forever, 24 Nov 2026; /mh block style 12x4). From docs/forever/KEYBLOCK12_PALADIN.md (mh-research,
	-- checked by a second helper). Rob via Sparring 24-11: "laat een agent uitzoeken welke spells logisch zijn per class".
	keys12 = {
		["1"] = { base = "Holy Strike", why = "main hit: press it whenever it is ready" },
		["2"] = { base = "Judgement", why = "rotation: Judgement whenever ready; it keeps your seal" },
		["3"] = { base = { "Seal of Command", "Seal of Righteousness" }, why = "your seal: Command once you have it, else Righteousness" },
		-- 24 Nov 2026 (same fallback as the Warlock's key 3, Sparring 24-11): Hammer of Wrath comes at 44, Exorcism at 20, so
		-- key 4 was empty from 20 to 43 while Exorcism sat on Shift-4. Exorcism here until you have Hammer of Wrath.
		["4"] = { base = { "Hammer of Wrath", "Exorcism" }, why = "execute at 20% health; Exorcism until Hammer of Wrath (44)" },
		["Q"] = { base = "Lay on Hands", why = "big cooldown and emergency: full heal, all your mana" },
		["E"] = { base = "Hammer of Justice", why = "no interrupt: this stun stops a cast" },
		["R"] = { base = "Blessing of Freedom", why = "movement: nothing can slow you for a while" },
		["F"] = { base = "Seal of Fury", why = "tank seal: with it on, Judgement taunts" },
		["Z"] = { base = { "Divine Shield", "Divine Protection" }, why = "your shield: one key, they share a cooldown" },
		["X"] = { base = "Templar's Bulwark", why = "second defensive: absorbs damage for 8 seconds" },
		["C"] = { base = "Holy Light", why = "big heal: your big defensive when you are alone" },
		["V"] = { base = "Repentance", why = "crowd control: takes one Humanoid out" },
		["SHIFT-1"] = { base = "Consecration", why = "AoE: two or more enemies" },
		["SHIFT-2"] = { base = "Swift Judgement", why = "a second Judgement with its own cooldown" },
		["SHIFT-3"] = { base = "Divine Favor", why = "cooldown: your next heal is a sure crit" },
		["SHIFT-4"] = { base = "Exorcism", why = "second special hit: Undead and Demons only" },
		["SHIFT-Q"] = { base = "Light's Vigil", why = "second cooldown: then Holy Shock on that same friend" },
		["SHIFT-E"] = { all = { "Stoneform", "Will to Survive", "Will of the Forsaken" }, why = "your race spell" },
		["SHIFT-R"] = { base = "Holy Shock", why = "instant heal or hit, also while you move" },
		["SHIFT-F"] = { base = "Turn Undead", why = "second crowd control: Undead only" },
		["SHIFT-Z"] = { base = "Holy Shield", why = "second small defensive: tank block, press when ready" },
		["SHIFT-X"] = { base = "Blessing of Protection", why = "defensive: saves a friend in trouble" },
		["SHIFT-C"] = { base = "Flash of Light", why = "quick heal, next to Holy Light on C" },
		["SHIFT-V"] = { base = { "Cleanse", "Purify" }, why = "remove a bad effect from a friend" },
		["CTRL-1"] = { base = "Devotion Aura", why = "aura 1: more armor; switch on and leave on" },
		["CTRL-2"] = { base = "Retribution Aura", why = "aura 2: holy damage to what hits your group" },
		["CTRL-3"] = { base = "Concentration Aura", why = "aura 3: casters get interrupted less" },
		["CTRL-4"] = { pair = { cond = "[group]", first = "Greater Blessing of Wisdom", second = "Blessing of Wisdom" }, why = "Blessing of Wisdom (60 min), the Greater one in a group" },
		["CTRL-Q"] = { pair = { cond = "[group]", first = "Greater Blessing of Might", second = "Blessing of Might" }, why = "Blessing of Might (60 min), the Greater one in a group" },
		["CTRL-E"] = { pair = { cond = "[group]", first = "Greater Blessing of Kings", second = "Blessing of Kings" }, why = "Blessing of Kings (60 min), the Greater one in a group" },
		["CTRL-R"] = { pair = { cond = "[combat]", first = "Divine Intervention", second = "Redemption" }, why = "Redemption brings a friend back; in a fight Divine Intervention" },
	},
}
