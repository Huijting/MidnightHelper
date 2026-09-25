--[[
	Midnight Helper — "How you play" cards, one per spec.

	Rob, 19 Sep 2026: "Ik wil dat mh dat soort uitleg ook gaat geven, en ja voor alle specs, maar
	wel in eli10 formaat". Two player-made cheat sheets (Ret, Arcane) had just been checked by four
	research agents: the Arcane one was mostly 11.2 advice, the Ret one skipped the top of its own
	priority list. MH itself had no rotation text for any spec. This file started as the pilot: Ret (70),
	Arcane (62), Prot Paladin (66) and Elemental (262), chosen by Rob. He approved the form on 24 Sep
	("Ziet er goed uit"); the other 36 specs followed on 25 Sep, researched per class by six agents
	against 12.1 guides, every {SPELL:id} checked against Wowhead's live tooltip. Not seen in the game yet.

	The shape is fixed on purpose, because the whole point is that it stays short:
	  IDEA     one sentence: what the spec is about.
	  S1..S5   the buttons, most important first. One line each.
	  AOE      optional: what changes with more enemies.
	  MISTAKE  the one thing beginners get wrong.
	  HERO1/2  optional: one line per hero talent tree, only when it changes the steps.

	Text lives in the locale packs as PLAYCARD_<specID>_<PART>. Spell names are written as
	{SPELL:id} and resolved by the client, so every language gets the name its own spellbook uses.
	A spell without a confirmed 12.1 id is written as plain English text instead of a guessed id.

	Every card names its sources with a date. A rotation changes with a patch; the date is how a
	player (and we) can tell a card might be stale.
]]

local _, ns = ...

-- source = shown under the card; checked = the day the guides were read.
local CARDS = {
	[70] = { -- Retribution Paladin
		steps = 4, aoe = false, hero = 2,
		source = "Icy Veins 25 Aug · Method 27 Aug 2026", -- rechecked 25 Sep: still right
	},
	[66] = { -- Protection Paladin
		steps = 4, aoe = true, hero = 2,
		source = "Method 3 Sep · Wowhead 12 Aug · Icy Veins 21 Sep 2026", -- rechecked 25 Sep: still right
	},
	[62] = { -- Arcane Mage
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 15 Aug · Method 13 Sep 2026",
	},
	[262] = { -- Elemental Shaman
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 1 Sep · Wowhead 20 Sep 2026", -- rechecked 25 Sep: still right
	},
	[63] = { -- Fire Mage
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 17 Aug 2026",
	},
	[64] = { -- Frost Mage
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 11 Aug 2026",
	},
	[65] = { -- Holy Paladin
		steps = 4, aoe = true, hero = 2,
		source = "Method 27 Aug · Wowhead 20 Sep 2026",
	},
	[71] = { -- Arms Warrior
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 25 Aug 2026",
	},
	[72] = { -- Fury Warrior
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 11 Aug 2026",
	},
	[73] = { -- Protection Warrior
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 18 Aug · Method 11 Aug 2026",
	},
	[102] = { -- Balance Druid
		steps = 5, aoe = true, hero = 2,
		source = "Method 15 Aug · Wowhead 3 Sep 2026",
	},
	[103] = { -- Feral Druid
		steps = 5, aoe = true, hero = 2,
		source = "Method 20 Sep · Wowhead 12 Aug 2026",
	},
	[104] = { -- Guardian Druid
		steps = 4, aoe = true, hero = 2,
		source = "Method 3 Sep · Wowhead 12 Aug 2026",
	},
	[105] = { -- Restoration Druid
		steps = 4, aoe = true, hero = 2,
		source = "Method 13 Sep · Wowhead 12 Aug 2026",
	},
	[250] = { -- Blood Death Knight
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 4 Sep 2026",
	},
	[251] = { -- Frost Death Knight
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 14 Sep · Method 20 Sep 2026",
	},
	[252] = { -- Unholy Death Knight
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 8 Sep · Method 24 Sep 2026",
	},
	[253] = { -- Beast Mastery Hunter
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 24 Aug · Method 15 Aug 2026",
	},
	[254] = { -- Marksmanship Hunter
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 31 Aug · Method 5 Sep 2026",
	},
	[255] = { -- Survival Hunter
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 30 Aug · Method 3 Sep 2026",
	},
	[256] = { -- Discipline Priest
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 17 Aug · Method 17 Sep 2026",
	},
	[257] = { -- Holy Priest
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 25 Aug · Method 17 Sep 2026",
	},
	[258] = { -- Shadow Priest
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 11 Aug · Method 27 Aug 2026",
	},
	[259] = { -- Assassination Rogue
		steps = 4, aoe = true, hero = 2,
		source = "Method 12 Aug · Wowhead 6 Sep 2026",
	},
	[260] = { -- Outlaw Rogue
		steps = 4, aoe = true, hero = 2,
		source = "Method 12 Aug · Wowhead 27 Aug 2026",
	},
	[261] = { -- Subtlety Rogue
		steps = 4, aoe = true, hero = 2,
		source = "Method 19 Aug · Wowhead 24 Aug 2026",
	},
	[263] = { -- Enhancement Shaman
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 23 Aug · Method 24 Aug 2026",
	},
	[264] = { -- Restoration Shaman
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 11 Aug 2026",
	},
	[265] = { -- Affliction Warlock
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 31 Aug · Method 12 Aug 2026",
	},
	[266] = { -- Demonology Warlock
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 11 Aug 2026",
	},
	[267] = { -- Destruction Warlock
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 31 Aug · Method 15 Aug 2026",
	},
	[268] = { -- Brewmaster Monk
		steps = 4, aoe = true, hero = 2,
		source = "Method 11 Aug · Wowhead 12 Aug 2026",
	},
	[269] = { -- Windwalker Monk
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 11 Aug · Method 18 Aug 2026",
	},
	[270] = { -- Mistweaver Monk
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 12 Aug · Method 27 Aug 2026",
	},
	[577] = { -- Havoc Demon Hunter
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 30 Aug · Method 17 Sep 2026",
	},
	[581] = { -- Vengeance Demon Hunter
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 26 Aug · Method 11 Aug · Wowhead 12 Aug 2026",
	},
	[1467] = { -- Devastation Evoker
		steps = 4, aoe = true, hero = 2,
		source = "Method 25 Aug · Wowhead 9 Sep 2026",
	},
	[1468] = { -- Preservation Evoker
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 13 Aug · Method 20 Aug · Wowhead 21 Sep 2026",
	},
	[1473] = { -- Augmentation Evoker
		steps = 5, aoe = true, hero = 2,
		source = "Method 25 Aug · Wowhead 17 Aug 2026",
	},
	[1480] = { -- Devourer Demon Hunter
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 17 Aug · Wowhead 2 Sep · Method 18 Sep 2026",
	},
}

local function SpellName(id)
	if ns.HealerCooldownSpellName then
		return ns.HealerCooldownSpellName(id)
	end
	local n = C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(id)
	return (n and n ~= "") and n or ("spell " .. tostring(id))
end

--- {SPELL:id} -> the client's own name for it, in gold, as a spell hyperlink. Returns the text and
--- the first id it saw (the window shows that spell's icon in front of the step).
--- The link is why every name has its own tooltip: Rob, 25 Sep 2026, on his Shadow Priest, "wat ik wel
--- mis is dat de andere spells niet een tooltip geven, bv vampire touch". The window's frames turn
--- hyperlinks on (PlayCardWindow.lua); no brackets, so the text reads the same as before.
local function Expand(text)
	local first
	text = tostring(text or ""):gsub("{SPELL:(%d+)}", function(id)
		id = tonumber(id)
		first = first or id
		return ("|cffffd100|Hspell:%d|h%s|h|r"):format(id, SpellName(id))
	end)
	return text, first
end
ns.ExpandPlayCardText = Expand

--- The card for a spec, as plain data for the renderer, or nil when there is none yet.
--- { idea, steps = { {text, spellID}, ... }, aoe, mistake, hero = { {text, spellID}, ... }, source }
function ns.GetPlayCard(specID)
	local c = specID and CARDS[specID]
	if not c then
		return nil
	end
	-- Keys are built at runtime (PLAYCARD_<spec>_<part>), so the linter's "defined but unused"
	-- check lists them as a family; that is expected.
	local function Part(p)
		return ns:L(("PLAYCARD_%d_%s"):format(specID, p))
	end
	local out = { steps = {}, hero = {}, source = c.source }
	out.idea = Expand(Part("IDEA"))
	for i = 1, c.steps do
		local t, id = Expand(Part("S" .. i))
		out.steps[#out.steps + 1] = { text = t, spellID = id }
	end
	if c.aoe then
		out.aoe = Expand(Part("AOE"))
	end
	out.mistake = Expand(Part("MISTAKE"))
	for i = 1, c.hero or 0 do
		local t, id = Expand(Part("HERO" .. i))
		out.hero[#out.hero + 1] = { text = t, spellID = id }
	end
	return out
end

--- `/mh playcards check`: the switch, the spec the Academy would ask for, and what the Academy
--- decided the last time it drew. Rob, 24 Sep 2026: switch on, /reload, no error, no card.
function ns.PrintPlayCardCheck()
	local function say(s)
		print("|cffffd100MH|r " .. s)
	end
	local ui = ns.db and ns.db.ui
	say("Play card check:")
	-- The preview switch (ns.db.ui.playCards) is gone since 4.1.0; the cards show for everyone.
	say(("  ns.db present: %s · last tab: %s")
		:format(tostring(ns.db ~= nil), tostring(ui and ui.playCardTab or "play")))
	local tank = ns.GetPlayerTankSpecID and ns.GetPlayerTankSpecID()
	local classTank = ns.GetClassTankSpecID and ns.GetClassTankSpecID()
	local dps = ns.GetPlayerDpsSpecID and ns.GetPlayerDpsSpecID()
	say(("  tank spec now: %s (class tank spec: %s) · dps spec now: %s")
		:format(tostring(tank), tostring(classTank), tostring(dps)))
	local want = tank or classTank
	say(("  card for tank spec %s: %s"):format(tostring(want), (want and CARDS[want]) and "yes" or "NO"))
	local last = ns._playCardLast
	if last then
		say(("  last Academy draw: spec %s · switch %s · card %s · %d s ago")
			:format(tostring(last.spec), tostring(last.on), tostring(last.card),
				math.floor((GetTime and GetTime() or 0) - (last.at or 0))))
	else
		say("  last Academy draw: NONE since the /reload - the card slot was never reached")
	end
end

--- Which specs have a card. For /mh playcard and for the linter.
function ns.GetPlayCardSpecs()
	local ids = {}
	for id in pairs(CARDS) do
		ids[#ids + 1] = id
	end
	table.sort(ids)
	return ids
end
