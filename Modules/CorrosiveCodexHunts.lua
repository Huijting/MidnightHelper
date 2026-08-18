local _, ns = ...

--[[
	Midnight Helper — the four Altar of Corrosion nodes you cannot buy.

	The Codex article has said since 14 aug that four nodes sit behind a key you have
	to find, and it said plainly that WHERE those keys drop was not settled: three
	reads of the same database gave three different answers, so it named none.

	Icy Veins (16 aug 19:52 UTC) is the first source to describe the whole method
	rather than a drop table — unlock item, then starter item, then Er'inye — and it
	carries coordinates for three of the four objects we only had prose for. That is
	worth having, and it is still ONE source. So it goes in attributed: `claimSource`
	travels with every field that came from them, and the article says "Icy Veins
	says" rather than stating it as ours.

	✅ ONE THING IS ALREADY CROSS-CHECKED. The Feather of Tok'jara sits at
	2509 48.46 / 25.80 in our own article, written from a different source in July,
	and Icy Veins gives the same two numbers. Agreement between independent reads is
	the only reason any of this is more than a rumour.

	⚠️ AND ONE THING CONTRADICTS US, which is why nothing here is silently merged.
	Our article describes the fourth node's second option as getting straight back up
	when you die OUTSIDE the Vaults. Icy Veins calls it Spiritual Succession, an
	instant res IN Atal'Utek. Those cannot both be true. Neither is measured, so both
	are recorded and `/mh codexnodes` asks the client, which settles it the way
	`/mh curios` settles curio text: the node's own description, in the player's own
	language, from their own game.

	⚠️ uiMapIDs here (2509 Vaults, 2613 Underbelly, 2636, 2638) are a DIFFERENT id
	system from the zone ids elsewhere in this addon (Coiled Isle 16365, Vaults
	16535). Do not mix them.
]]

--- Each hunt: the item that unlocks it, the object that starts the quest, and the
--- pair of powers it opens. `nodeOptions` are the names each source uses — where two
--- sources disagree, BOTH are listed rather than one being chosen.
ns.CORROSIVE_KEY_HUNTS = {
	{
		key = "tokjara",
		unlockItem = "Spirit Loupe",
		unlockFrom = "ICV_UNLOCK_ANCIENT_FOE",
		starterItem = "Feather of Tok'jara",
		-- ✅ The one coordinate two independent sources agree on.
		mapID = 2509,
		x = 48.46,
		y = 25.80,
		whereKey = "ICV_WHERE_TOKJARA",
		nodeName = "Spectral Winds",
		nodeOptions = { "Spirit Walk", "Spectral Shipping" },
		claimSource = "icyveins-16aug",
		confirmedBy = "our own July article, same two numbers",
	},
	{
		key = "lynx",
		unlockItem = "Corroded Key",
		unlockFrom = "ICV_UNLOCK_TEMPLE_STRIKE",
		starterItem = "Mummified Lynx's Paw",
		-- ⚠️ Nine possible spots, not nine chests: Icy Veins presents these as the
		-- places the container can be, so the route visits them until one pays out.
		-- Our own article called this object "the Venom-Worn Coffer"; whether that is
		-- the same container under a different name is NOT established, so both names
		-- are kept and neither is deleted.
		mapID = 2509,
		spots = {
			{ 41.80, 10.80 }, { 40.10, 18.30 }, { 52.57, 10.73 },
			{ 53.67, 18.13 }, { 52.21, 54.59 }, { 53.02, 53.35 },
			{ 41.47, 53.44 }, { 42.46, 54.62 }, { 47.52, 38.37 },
		},
		whereKey = "ICV_WHERE_LYNX",
		alsoCalled = "Venom-Worn Coffer",
		nodeName = "Run of the Vaults",
		nodeOptions = { "Glideways", "Swift Steps" },
		claimSource = "icyveins-16aug",
	},
	{
		key = "szarith",
		unlockItem = "Excising Knife",
		unlockFrom = "ICV_UNLOCK_TEMPLE_INCURSION",
		starterItem = "Eye of Szarith",
		mapID = 2613, -- the Underbelly
		x = 68.60,
		y = 15.66,
		whereKey = "ICV_WHERE_SZARITH",
		nodeName = "Broodmaster",
		nodeOptions = { "Egg Specialist", "Egg Evasion" },
		claimSource = "icyveins-16aug",
	},
	{
		key = "medjai",
		unlockItem = "Dispelling Charm",
		unlockFrom = "ICV_UNLOCK_JINTAL",
		-- Where the charm itself comes from — a named NPC, on a side questline.
		unlockMapID = 2636,
		unlockX = 48.08,
		unlockY = 72.69,
		starterItem = "Lost Med'jai Amulet",
		mapID = 2638, -- Profaned Mausoleum
		x = 36.26,
		y = 23.70,
		whereKey = "ICV_WHERE_MEDJAI",
		alsoCalled = "Jin'tal's Reliquary",
		nodeName = "Spiritual Protection",
		nodeOptions = { "Surge Seniority", "Spiritual Succession" },
		-- ⚠️ THE CONTRADICTION. Our article: back up when you die OUTSIDE the Vaults.
		-- Icy Veins: instant res IN Atal'Utek. Recorded, not resolved.
		disputed = "ICV_DISPUTE_MEDJAI",
		claimSource = "icyveins-16aug",
	},
}

--- ⚠️ A CONTRADICTION I INVENTED, AND THEN HAD TO WITHDRAW.
---
--- For about an hour this file said Method and Icy Veins disagreed about where three
--- of the four objects are — Method putting all four on map 2509 while Icy Veins used
--- 2613 and 2638. That was wrong, and the way it went wrong is worth keeping.
---
--- I wrote it from a research summary that listed four 2509 coordinates, and read a
--- partial list as a complete one. The page itself gives TWO coordinates per object:
--- an entrance on 2509 and the object itself on the interior map. Read in full, the
--- two sources very nearly agree:
---
---     Eye of Szarith      Method 2613 68.52/15.86   ·  Icy Veins 2613 68.60/15.66
---     Lost Med'jai Amulet Method 2638 36.73/24.73   ·  Icy Veins 2638 36.26/23.70
---
--- Two independent reads within a few tenths of each other is agreement, not conflict.
--- The lesson is the older one: a summary is not the source. Both sets are kept below
--- because neither is measured, and the small spread is honest about that.
---
--- ✅ The Feather of Tok'jara stands apart: 2509 48.46/25.80 from our own July note,
--- from Icy Veins and from Method, character for character. Four reads, one answer.
ns.CORROSIVE_DISCOVERY_RIVAL = {
	source = "method-10aug",
	-- Entrances on the outer map, which Icy Veins does not give at all.
	entrances = {
		{ mapID = 2509, x = 54.83, y = 48.11, leadsTo = "medjai", label = "Profaned Mausoleum" },
		{ mapID = 2509, x = 47.23, y = 8.13, leadsTo = "szarith", label = "The Underbelly" },
	},
	-- Method's own interior coordinates, beside the Icy Veins ones above.
	interiors = {
		{ hunt = "medjai", mapID = 2638, x = 36.73, y = 24.73 },
		{ hunt = "szarith", mapID = 2613, x = 68.52, y = 15.86 },
		{ hunt = "tokjara", mapID = 2509, x = 48.46, y = 25.80 },
	},
	-- ⚠️ FIVE spots for the Venom-Worn Coffer where Icy Veins gives NINE, and only
	-- some of them line up (53.69/18.18 against 53.67/18.13; 47.48/37.59 against
	-- 47.52/38.37). Neither list is a subset of the other, so both are walked.
	coffer = {
		mapID = 2509,
		spots = { { 52.51, 53.85 }, { 41.96, 53.58 }, { 42.51, 12.01 },
			{ 47.48, 37.59 }, { 53.69, 18.18 } },
	},
}

--- ✅ Method supplies the ONE thing Icy Veins did not: which unlock item opens which
--- discovery, with an item id for every piece and a named quest per hunt. All four
--- pairings match what this file already had, which is the first time two sources
--- have confirmed each other on this content rather than just co-existing.
ns.CORROSIVE_DISCOVERY_IDS = {
	source = "method-10aug",
	medjai  = { unlock = 280005, starter = 278517, quest = 97661, questName = "The Protection of the Med'jai" },
	tokjara = { unlock = 280006, starter = 278523, quest = 97662, questName = "The Winds of Tok'jara" },
	lynx    = { unlock = 280004, starter = 278536, quest = 97669, questName = "The Luck of the Bound Spirit" },
	szarith = { unlock = 280003, starter = 278534, quest = 97668, questName = "The Watchful Gaze of Szarith" },
}

--- ⚠️ TWO SYSTEMS, AND WE HAD BEEN TREATING THEM AS ONE.
---
--- Method separates them cleanly across two pages, and once separated the whole
--- picture stops contradicting itself:
---
---   * the CORROSIVE CODEX — 12 individual powers, 8 Corrosive Souls each, no choice
---     pairs and no treasure gating at all;
---   * the ALTAR OF CORROSION talent tree — 24 talents bought with Spirit Corrosions,
---     of which exactly four are choice nodes behind these Discoveries.
---
--- Everything in this file is the SECOND one. The name of the file says Codex, which
--- is now the wrong word for what it holds; kept for the moment because renaming a
--- module mid-session is how load order breaks, and flagged here so the next person
--- does not inherit the confusion silently.
---
--- It also explains a "contradiction" the research flagged between Method's own
--- pages: souls being weekly-limited (Codex) while Altar upgrades have no time gate
--- (tree). Two currencies, two rules, one word doing double duty.
ns.CORROSIVE_SYSTEMS_NOTE = "altar-tree-not-codex-powers"

--- The chain these four feed, per Icy Veins. Named here so the article can say what
--- it is for; none of it is verified against an achievement id yet.
ns.CORROSIVE_REWARD_CHAIN = {
	allTraits = "Fully Corroded",
	meta = "Assault the Vault",
	mount = "Venomous Coiler",
	claimSource = "icyveins-16aug",
}

-- ---------------------------------------------------------------------------
-- /mh keys — the four hunts, with every coordinate clickable
-- ---------------------------------------------------------------------------

local function L(key)
	return (ns.L and ns:L(key)) or key
end

local function Way(mapID, x, y, label)
	if ns.GetWayLinkMarkup then
		return ns:GetWayLinkMarkup(mapID, x, y, label)
	end
	return ("%s (%.2f, %.2f)"):format(label, x, y)
end

function ns.ShowCorrosiveKeyHunts()
	print(("|cff8fd3ffMidnight Helper|r %s"):format(L("ICV_KEYS_TITLE")))
	for _, hunt in ipairs(ns.CORROSIVE_KEY_HUNTS) do
		print(("|cffffd100%s|r → |cffffffff%s|r  (%s: %s / %s)"):format(
			hunt.unlockItem, hunt.starterItem, hunt.nodeName,
			hunt.nodeOptions[1], hunt.nodeOptions[2]))
		print("   " .. L(hunt.unlockFrom))
		if hunt.unlockMapID and hunt.unlockX then
			print("   " .. Way(hunt.unlockMapID, hunt.unlockX, hunt.unlockY, hunt.unlockItem))
		end
		if hunt.x and hunt.y then
			print("   " .. Way(hunt.mapID, hunt.x, hunt.y, hunt.starterItem))
		end
		if hunt.spots then
			local parts = {}
			for i, s in ipairs(hunt.spots) do
				parts[#parts + 1] = Way(hunt.mapID, s[1], s[2], tostring(i))
			end
			print(("   %s %s"):format(L("ICV_SPOTS_PREFIX"), table.concat(parts, " ")))
		end
		if hunt.alsoCalled then
			print(("   |cff8a8f98%s %s|r"):format(L("ICV_ALSO_CALLED"), hunt.alsoCalled))
		end
		if hunt.disputed then
			print("   |cffff5040" .. L(hunt.disputed) .. "|r")
		end
	end
	print(("|cff8a8f98%s|r"):format(L("ICV_SOURCE_NOTE")))
end

-- ---------------------------------------------------------------------------
-- Mysterious Mix Master: the recipes, which is the part nobody can see
-- ---------------------------------------------------------------------------

--- ⚠️ THIS CORRECTS ME. I wrote that this achievement had "no route because the
--- containers have no fixed spots". Wowhead maps 197 of them on 2512 — 65 Cracked
--- Canopic Jars, 61 Venom-Clotted Baubles, 71 Singing Shells. Rob asked whether we
--- could just check instead of reasoning; we could, and the reasoning was wrong.
---
--- It stays routeless anyway, for a reason that survives the correction: a scatter of
--- 197 gatherables is a HandyNotes overlay, not a route, and the ingredients are
--- tradable so half of everyone will buy them.
---
--- ✅ THE REAL GAP IS THE RECIPES. Ten offerings, each an exact three-ingredient
--- combination, chosen through dialogue with NO visual feedback, and the ingredients
--- are only consumed on the THIRD choice. Get it wrong and the day is spent. That is
--- precisely the shape this addon exists for — explaining rather than tracking.
---
--- Source: Wowhead comment 6389799 (Lazey), decoded from the raw HTML rather than a
--- summariser, and independently matched against the MysteriousMixHelper addon's own
--- published table. Two arithmetic checks hold: every row sums to 3, and each
--- ingredient column totals exactly 10.
---
--- ⚠️ An addon already does this job (TheDooft/MysteriousMixHelper, on CurseForge).
--- We are not rebuilding it — a recipe line inside an achievement card the player is
--- already reading is a different thing from a dedicated helper, and mh-market-position
--- says our edge is the explaining, not the tracking.
ns.MIX_MASTER_INGREDIENTS = {
	[276124] = "Ancient Knucklebone",   -- Cracked Canopic Jar (object 654991)
	[276126] = "Serpent's Feather",     -- Venom-Clotted Bauble (object 656039)
	[276117] = "Clouded Blood-Pearl",   -- Singing Shell (object 656044)
}

--- criteriaID → { [itemID] = count }. Criteria ids measured on Rob's client 18 aug;
--- the counts are Lazey's table.
ns.MIX_MASTER_RECIPES = {
	[115810] = { [276117] = 3 },                                  -- Choleric
	[115811] = { [276126] = 1, [276117] = 2 },                    -- Virulent
	[115812] = { [276124] = 1, [276117] = 2 },                    -- Volatile
	[115815] = { [276126] = 3 },                                  -- Phlegmatic
	[115814] = { [276126] = 2, [276117] = 1 },                    -- Odious
	[115816] = { [276124] = 1, [276126] = 2 },                    -- Pestilent
	[115819] = { [276124] = 3 },                                  -- Melancholic
	[115817] = { [276124] = 2, [276117] = 1 },                    -- Fragile
	[115818] = { [276124] = 2, [276126] = 1 },                    -- Eerie
	[115813] = { [276124] = 1, [276126] = 1, [276117] = 1 },      -- Balanced
}

--- ⚠️ TWO GATES, AND WITHOUT THE SECOND THE CONTAINERS ARE EMPTY. Renown 3 with
--- Zul'jarra's Forces (2772) makes them appear at all; the "Ofi's Offerings" node on
--- the Altar of Corrosion tree is what puts ingredients inside them. A player with the
--- first and not the second loots nothing and concludes the addon is wrong.
ns.MIX_MASTER_GATES = { renownFaction = 2772, renownLevel = 3, altarNode = "Ofi's Offerings" }

--- Two NPCs are called Ofi the Sly and only one of them mixes. The swamp copy at
--- 61.0/32.6 has no cauldron dialogue; the cauldron is at Tokka's Landing.
ns.MIX_MASTER_CAULDRON = { mapID = 2512, x = 57.4, y = 48.7, npc = "Ofi the Sly" }

--- Every stop for the key hunts, in one flat route: the objects with a single known
--- spot first, then the nine candidate spots for the Lynx's Paw.
--- @return table stops
function ns.BuildCorrosiveKeyRoute()
	local stops = {}
	for _, hunt in ipairs(ns.CORROSIVE_KEY_HUNTS) do
		if hunt.x and hunt.y then
			stops[#stops + 1] = {
				mapID = hunt.mapID,
				x = hunt.x,
				y = hunt.y,
				name = hunt.starterItem,
				hunt = hunt.key,
			}
		end
	end
	for _, hunt in ipairs(ns.CORROSIVE_KEY_HUNTS) do
		if hunt.spots then
			for i, s in ipairs(hunt.spots) do
				stops[#stops + 1] = {
					mapID = hunt.mapID,
					x = s[1],
					y = s[2],
					name = ("%s (%d/%d)"):format(hunt.starterItem, i, #hunt.spots),
					hunt = hunt.key,
					candidate = true,
				}
			end
		end
	end
	return stops
end
