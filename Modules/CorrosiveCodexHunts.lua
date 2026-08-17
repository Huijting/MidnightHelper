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

--- ⚠️ METHOD DISAGREES WITH ICY VEINS ABOUT WHERE THREE OF THE FOUR OBJECTS ARE.
---
--- Method's "Where to Find All of the Discoveries for the Altar of Corrosion"
--- (10 aug) puts all four on map 2509: 54.83/48.11, 48.46/25.80, 52.51/53.85 and
--- 47.23/8.13. Icy Veins puts two of them on entirely different maps — the Eye of
--- Szarith on 2613 and the Lost Med'jai Amulet on 2638.
---
--- ✅ They agree on exactly one: 48.46 / 25.80. That is the Feather of Tok'jara, and
--- with our own July note it now has THREE independent reads behind it. It is the
--- only coordinate in this file anyone should trust today.
---
--- ❌ The other three are one-source-each and the two sources contradict. So nothing
--- is overwritten and nothing is merged: Method's numbers sit here as a rival claim,
--- unpaired with the Icy Veins entries above, because pairing them would mean
--- deciding which object each belongs to and nobody knows that either.
---
--- Method also gives a quest id per discovery (97661, 97662, 97668, 97669) and item
--- 280005 for the Dispelling Charm. Those are in the /mh atal sweep — a quest that
--- resolves settles far more than a coordinate that does not.
ns.CORROSIVE_DISCOVERY_RIVAL = {
	source = "method-10aug",
	mapID = 2509,
	spots = { { 54.83, 48.11 }, { 48.46, 25.80 }, { 52.51, 53.85 }, { 47.23, 8.13 } },
	questIDs = { 97661, 97662, 97668, 97669 },
	dispellingCharmItem = 280005,
}

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
