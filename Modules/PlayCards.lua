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

	WHY AND QUIZ (Rob, 10 Oct 2026: "uiteindelijk wordt het doel, voor iedereen, om zonder hulpmiddelen
	te spelen en gewoon te weten wat je doet en waarom"). A card can carry two optional extras:
	  W1..W5, WAOE  one "why" line per step: the mechanic behind the button, in the same plain words.
	                Only with `why = { checked, interface }`. A why line is more fragile than a step:
	                a talent change can make the explanation false while the button stays the same.
	                So they hide by themselves once the client is newer than the patch they were
	                checked on (`interface`), instead of explaining a mechanic that may be gone.
	  quiz = true   a quiz tab built FROM THE CARD ITSELF, no text of its own: each step with a spell
	                becomes a question with that spell blanked out (the step's LAST {SPELL}, or
	                `quizAnswer[step]`), the other spells on the card are the wrong choices, and the
	                why line is the explanation. One place per fact: a patch check of the card is
	                a check of the quiz.
	Frost Mage (64) is the pilot; the other specs follow only after Carola has used it.
]]

local _, ns = ...

-- source = shown under the card; checked = the day the guides were read.
local CARDS = {
	[70] = { -- Retribution Paladin
		steps = 4, aoe = false, hero = 2,
		source = "Icy Veins 25 Aug · Method 27 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[66] = { -- Protection Paladin
		-- 3 Oct 2026: fifth step = Hand of Reckoning (Rob's choice; Icy Veins' opener pulls with it,
		-- and it was on none of the four tabs). HERO2 now says Lightsmith is ONE button.
		steps = 5, aoe = true, hero = 2,
		source = "Method 3 Sep · Wowhead 12 Aug · Icy Veins 21 Sep 2026", -- rechecked 25 Sep + 3 Oct
	},
	[62] = { -- Arcane Mage
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 15 Aug · Method 13 Sep · Wowhead 4 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[262] = { -- Elemental Shaman
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 1 Sep · Wowhead 20 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[63] = { -- Fire Mage
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 17 Aug · Wowhead 16 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[64] = { -- Frost Mage
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 11 Aug · Wowhead 29 Aug 2026",
		-- Pilot for "why" lines + quiz (Rob, 10 Oct 2026, for Carola). See WHY AND QUIZ below.
		why = { checked = "2026-10-10", interface = 120100 },
		quiz = true,
	},
	[65] = { -- Holy Paladin
		steps = 4, aoe = true, hero = 2,
		source = "Method 27 Aug · Wowhead 20 Sep · Icy Veins 10 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[71] = { -- Arms Warrior
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 10 + 25 Aug · Method 25 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[72] = { -- Fury Warrior
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 10 + 25 Aug · Method 11 Aug · Wowhead 12 Aug 2026",
	},
	[73] = { -- Protection Warrior
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 18 Aug · Method 11 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[102] = { -- Balance Druid
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 15 Aug · Wowhead 3 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[103] = { -- Feral Druid
		steps = 5, aoe = true, hero = 2,
		source = "Method 1 Oct · Icy Veins 10 Aug · Wowhead 12 Aug 2026",
	},
	[104] = { -- Guardian Druid
		steps = 4, aoe = true, hero = 2,
		source = "Method 3 Sep · Icy Veins 10 Aug · Wowhead 12 Aug 2026",
	},
	[105] = { -- Restoration Druid
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 13 Sep · Wowhead 12 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[250] = { -- Blood Death Knight
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 4 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[251] = { -- Frost Death Knight
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 25 Sep · Method 27 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[252] = { -- Unholy Death Knight
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 8 Sep · Method 24 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[253] = { -- Beast Mastery Hunter
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 7 Sep · Method 5 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[254] = { -- Marksmanship Hunter
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 31 Aug · Method 5 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[255] = { -- Survival Hunter
		steps = 4, aoe = true, hero = 2,
		source = "Wowhead 23 Sep · Method 3 Sep · Icy Veins 30 Aug 2026",
	},
	[256] = { -- Discipline Priest
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 17 Aug · Method 17 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[257] = { -- Holy Priest
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 25 Aug · Method 17 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[258] = { -- Shadow Priest
		steps = 4, aoe = true, hero = 2,
		source = "Method 27 Aug · Wowhead 12 Aug · Icy Veins 11 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[259] = { -- Assassination Rogue
		steps = 4, aoe = true, hero = 2,
		source = "Wowhead 6 Sep · Method 12 Aug · Icy Veins 10 Aug 2026",
	},
	[260] = { -- Outlaw Rogue
		steps = 4, aoe = true, hero = 2,
		source = "Wowhead 27 Aug · Method 12 Aug · Icy Veins 10 Aug 2026",
	},
	[261] = { -- Subtlety Rogue
		steps = 4, aoe = true, hero = 2,
		source = "Wowhead 24 Aug · Method 19 Aug · Icy Veins 10 Aug 2026",
	},
	[263] = { -- Enhancement Shaman
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 23 Aug · Method 24 Aug · Wowhead 22 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[264] = { -- Restoration Shaman
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Method 11 Aug · Wowhead 5 Sep 2026",
	},
	[265] = { -- Affliction Warlock
		steps = 5, aoe = true, hero = 2,
		source = "Wowhead 7 Sep · Icy Veins 31 Aug · Method 12 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[266] = { -- Demonology Warlock
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 10 Aug · Wowhead 12 Aug · Method 27 Sep 2026",
	},
	[267] = { -- Destruction Warlock
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 31 Aug · Method 15 Aug · Wowhead 12 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[268] = { -- Brewmaster Monk
		steps = 4, aoe = true, hero = 2,
		source = "Method 11 Aug · Wowhead 12 Aug · Icy Veins 10 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[269] = { -- Windwalker Monk
		steps = 4, aoe = true, hero = 2,
		source = "Icy Veins 25 Aug · Wowhead 25 Aug · Method 18 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[270] = { -- Mistweaver Monk
		steps = 5, aoe = true, hero = 2,
		source = "Wowhead 30 Sep · Method 27 Aug · Icy Veins 12 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[577] = { -- Havoc Demon Hunter
		steps = 5, aoe = true, hero = 2,
		source = "Method 17 Sep · Icy Veins 30 Aug · Wowhead 17 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[581] = { -- Vengeance Demon Hunter
		steps = 5, aoe = true, hero = 2,
		source = "Method 27 Aug · Wowhead 12 Aug · Icy Veins 10 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[1467] = { -- Devastation Evoker
		steps = 4, aoe = true, hero = 2,
		source = "Wowhead 9 Sep · Method 25 Aug · Icy Veins 10 Aug 2026",
	},
	[1468] = { -- Preservation Evoker
		steps = 5, aoe = true, hero = 2,
		source = "Icy Veins 13 Aug · Method 20 Aug · Wowhead 21 Sep 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
	[1473] = { -- Augmentation Evoker
		steps = 5, aoe = true, hero = 2,
		source = "Method 25 Aug · Wowhead 17 Aug · Icy Veins 10 Aug 2026",
	},
	[1480] = { -- Devourer Demon Hunter
		steps = 5, aoe = true, hero = 2,
		source = "Method 18 Sep · Wowhead 2 Sep · Icy Veins 18 Aug 2026", -- rechecked 3 Oct 2026 (mh-research)
	},
}

--- The same card on midnighthelper.com (Rob, 4 Oct 2026). Slugs GEMETEN from the live sitemap that day:
--- 40 pages, English slug in every language; English at /play/<slug>/, the other six at /<xx>/play/<slug>/.
--- Written out rather than built from a spec name, so a translated or renamed spec never breaks a link.
local SITE_SLUGS = {
	[62] = "arcane-mage", [63] = "fire-mage", [64] = "frost-mage",
	[65] = "holy-paladin", [66] = "protection-paladin", [70] = "retribution-paladin",
	[71] = "arms-warrior", [72] = "fury-warrior", [73] = "protection-warrior",
	[102] = "balance-druid", [103] = "feral-druid", [104] = "guardian-druid", [105] = "restoration-druid",
	[250] = "blood-death-knight", [251] = "frost-death-knight", [252] = "unholy-death-knight",
	[253] = "beast-mastery-hunter", [254] = "marksmanship-hunter", [255] = "survival-hunter",
	[256] = "discipline-priest", [257] = "holy-priest", [258] = "shadow-priest",
	[259] = "assassination-rogue", [260] = "outlaw-rogue", [261] = "subtlety-rogue",
	[262] = "elemental-shaman", [263] = "enhancement-shaman", [264] = "restoration-shaman",
	[265] = "affliction-warlock", [266] = "demonology-warlock", [267] = "destruction-warlock",
	[268] = "brewmaster-monk", [269] = "windwalker-monk", [270] = "mistweaver-monk",
	[577] = "havoc-demon-hunter", [581] = "vengeance-demon-hunter", [1480] = "devourer-demon-hunter",
	[1467] = "devastation-evoker", [1468] = "preservation-evoker", [1473] = "augmentation-evoker",
}
local SITE_LANG = { nlNL = "nl/", deDE = "de/", frFR = "fr/", esES = "es/", esMX = "es/", ptBR = "pt/", itIT = "it/" }

function ns.PlayCardSiteURL(specID)
	local slug = specID and SITE_SLUGS[specID]
	if not slug then
		return nil
	end
	local code = ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode() or "enUS"
	return ("https://midnighthelper.com/%splay/%s/"):format(SITE_LANG[code] or "", slug)
end

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
--- `known` (optional): function(id) -> bool. A spell it says you do not have yet is grey instead of gold
--- (Rob, 25 Sep 2026, on a level 26 Druid: the card advised spells that character did not have yet).
local function Expand(text, known)
	local first
	text = tostring(text or ""):gsub("{SPELL:(%d+)}", function(id)
		id = tonumber(id)
		first = first or id
		local colour = (known and not known(id)) and "8a8a8a" or "ffd100"
		return ("|cff%s|Hspell:%d|h%s|h|r"):format(colour, id, SpellName(id))
	end)
	return text, first
end
ns.ExpandPlayCardText = Expand

--- The card for a spec, as plain data for the renderer, or nil when there is none yet.
--- { idea, steps = { {text, spellID}, ... }, aoe, mistake, hero = { {text, spellID}, ... }, source }
--- `known` (optional) greys out spells the character does not have yet; see Expand.
function ns.GetPlayCard(specID, known)
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
	local showWhy = ns.PlayCardWhyState(specID)
	out.idea = Expand(Part("IDEA"), known)
	for i = 1, c.steps do
		local t, id = Expand(Part("S" .. i), known)
		out.steps[#out.steps + 1] = { text = t, spellID = id, why = showWhy and (Expand(Part("W" .. i), known)) or nil }
	end
	if c.aoe then
		out.aoe = Expand(Part("AOE"), known)
		out.aoeWhy = showWhy and (Expand(Part("WAOE"), known)) or nil
	end
	out.mistake = Expand(Part("MISTAKE"), known)
	-- "In 3 steps", plain words, for healer cards (Rob, 7 Oct 2026 evening: the Holy card assumed you already knew
	-- Holy Power, Beacon, Dawnlight …). Only where the key exists in enUS, so other specs stay as they were.
	local easyKey = ("PLAYCARD_%d_EASY"):format(specID)
	if ns._mhLocales and ns._mhLocales.enUS and ns._mhLocales.enUS[easyKey] then
		out.easy = Expand(ns:L(easyKey), known)
	end
	for i = 1, c.hero or 0 do
		local t, id = Expand(Part("HERO" .. i), known)
		out.hero[#out.hero + 1] = { text = t, spellID = id }
	end
	return out
end

--- Are this card's why lines shown? @return shown (bool), reason (English, for /mh playcards check)
--- Hidden when the card has none, or when the client is newer than the patch they were checked on:
--- an explanation of a mechanic that may have changed is worse than none (see WHY AND QUIZ above).
function ns.PlayCardWhyState(specID)
	local c = specID and CARDS[specID]
	local w = c and c.why
	if not w then
		return false, "this card has no why lines yet"
	end
	local client = GetBuildInfo and select(4, GetBuildInfo())
	if type(client) == "number" and client > w.interface then
		return false, ("checked on %s for interface %d, client is %d: hidden until rechecked")
			:format(w.checked, w.interface, client)
	end
	return true, ("checked on %s for interface %d, client is %s"):format(w.checked, w.interface, tostring(client))
end

--- The quiz for a spec, built from its card (see WHY AND QUIZ above), or nil when the card has none.
--- { { question = text with the answer blanked, answer = spellID, choices = { 3 spellIDs, shuffled },
---     why = text or nil, step = "S1".."S5" or "AOE" }, ... } in card order.
function ns.GetPlayCardQuiz(specID)
	local c = specID and CARDS[specID]
	if not (c and c.quiz) then
		return nil
	end
	local showWhy = ns.PlayCardWhyState(specID)
	local parts = {}
	for i = 1, c.steps do
		parts[#parts + 1] = { key = "S" .. i, why = "W" .. i, override = c.quizAnswer and c.quizAnswer[i] }
	end
	if c.aoe then
		parts[#parts + 1] = { key = "AOE", why = "WAOE" }
	end
	-- Every spell on the card is a possible wrong choice.
	local raw, pool, seen = {}, {}, {}
	for _, p in ipairs(parts) do
		raw[p.key] = tostring(ns:L(("PLAYCARD_%d_%s"):format(specID, p.key)) or "")
		for id in raw[p.key]:gmatch("{SPELL:(%d+)}") do
			id = tonumber(id)
			if not seen[id] then
				seen[id] = true
				pool[#pool + 1] = id
			end
		end
	end
	local out = {}
	for _, p in ipairs(parts) do
		local text, answer = raw[p.key], p.override
		if not answer then
			for id in text:gmatch("{SPELL:(%d+)}") do
				answer = tonumber(id)
			end
		end
		-- A step without a spell (plain text) cannot be asked; nor can a card with too few spells.
		if answer and #pool >= 3 then
			local blanked = text:gsub("{SPELL:" .. answer .. "}", "{BLANK}", 1)
			local q = Expand(blanked):gsub("{BLANK}", "|cffffffff______|r")
			local wrong = {}
			for _, id in ipairs(pool) do
				if id ~= answer then
					wrong[#wrong + 1] = id
				end
			end
			local choices = { answer }
			while #choices < 3 and #wrong > 0 do
				choices[#choices + 1] = table.remove(wrong, math.random(#wrong))
			end
			for i = #choices, 2, -1 do
				local j = math.random(i)
				choices[i], choices[j] = choices[j], choices[i]
			end
			out[#out + 1] = {
				question = q,
				answer = answer,
				choices = choices,
				why = showWhy and (Expand(ns:L(("PLAYCARD_%d_%s"):format(specID, p.why)))) or nil,
				step = p.key,
			}
		end
	end
	return #out > 0 and out or nil
end

--- The level the cards are written for: the expansion's max level (90 in Midnight).
function ns.PlayCardMaxLevel()
	if GetMaxLevelForPlayerExpansion then
		local ok, lv = pcall(GetMaxLevelForPlayerExpansion)
		if ok and type(lv) == "number" and lv > 0 then
			return lv
		end
	end
	return 90
end

--- Does this character have the spell (talents and replaced buttons included)? Fails open: an
--- API hiccup shows gold, because grey on a spell you DO have would be the worse lie.
function ns.PlayCardKnowsSpell(id)
	if not id then
		return true
	end
	local ok, yes = pcall(function()
		return (IsPlayerSpell and IsPlayerSpell(id))
			or (IsSpellKnownOrOverridesKnown and IsSpellKnownOrOverridesKnown(id))
			or (C_SpellBook and C_SpellBook.IsSpellKnown and C_SpellBook.IsSpellKnown(id))
	end)
	if not ok then
		return true
	end
	return yes and true or false
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
	-- Why lines and quiz can be silently absent on purpose (stale patch): say which, and why.
	local cur = GetSpecialization and GetSpecializationInfo and GetSpecialization()
	local curID = cur and GetSpecializationInfo(cur)
	if curID then
		local shown, reason = ns.PlayCardWhyState(curID)
		local quiz = ns.GetPlayCardQuiz(curID)
		say(("  spec %s: why lines %s (%s) · quiz: %s"):format(tostring(curID), shown and "SHOWN" or "hidden",
			reason, quiz and (#quiz .. " questions") or "none"))
	end
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
