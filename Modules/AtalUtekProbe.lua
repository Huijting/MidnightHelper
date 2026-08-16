local _, ns = ...

--[[
	Midnight Helper — Vaults of Atal'Utek probe (/mh atal).

	WHY THIS EXISTS. Rob walked into the Vaults on 12 Aug 2026 and sent the "Altar of
	Corrosion" window: a node tree with its own currency, sitting inside 12.1 content
	that is live today and needs no season gate. MH knows nothing about it — the repo
	holds four passing mentions of the place and not one id.

	Everything we have came from a guide site, so nothing here is wired into a feature.
	This file only asks the client what it knows, so the next session can build on
	measurements instead of on somebody's datamine.

	⚠️ THE CURRENCY NAME IS EXACTLY THE TRAP THIS ADDON KEEPS WALKING INTO. The guide
	says "Corrosive Coin". docs/WATCHER_API_PROMPT.md records that Blizzard renamed
	that currency to **Corrosive Souls** on 14 July 2026, and that our own watcher got
	it wrong by quoting a source from before the rename. So the probe does not carry
	the name at all: it matches on "corros", asks the client for the rest, and prints
	whatever the client answers. Same call as /mh crestfind, which is how Mistcrest
	was settled after two rounds of guessing.

	UNVERIFIED, all of it, from Zygor's 12.1 pages via Rob's screenshots:
	  quest chain 98388 -> 97640 -> 98428, entrance ~47.24 / 60.79 on The Coiled Isle,
	  gossip 141688 on object "Altar of Corrosion" (269485) at 51.16 / 62.80,
	  "Corrode Spirit" costing 1000 of the currency.
	The quest LABELS below are from that same source. The game's own title is the
	check: a title that does not match means the id belongs to something else.

	Reads only. IsQuestFlaggedCompleted, IsOnQuest, GetCurrencyInfo, GetMapInfo and
	GetOptions are all plain queries — nothing here accepts, buys or selects anything.

	Coordinates from a guide are NOT turned into a waypoint. On 12 Aug the Crafting
	Orders pin proved the cost of that: the guide said 44.95 / 56.07, Rob's own
	/mh capture said 45.03 / 56.20, and close is precisely how you land someone next
	to an NPC instead of at it.
]]

--- The three quest ids the guide gives for the chain, with its labels.
--- Order is the chain order, so a player mid-chain shows as a run of completions
--- followed by one in the log.
local CHAIN = {
	{ 98388, "Into the Vaults of Atal'Utek" },
	{ 97640, "One Coin Too Many" },
	{ 98428, "The Altar of Corrosion" },

	-- Found in ZygorGuidesViewer on 15 Aug, unverified. Both sit in the same guide block
	-- as the three above -- which the client has already confirmed -- so they are better
	-- candidates than most, and still only candidates until a title comes back.
	--
	-- 98515 matters most: it is offered alongside 97640 at the same hub and asks for a
	-- Temple Patrol, a Temple Strike, a Temple Incursion and an Ancient Foe. Those are the
	-- four activities every guide says drop the discovery keys, so this quest is probably
	-- how a new player is taught they exist at all -- and we ship a three-step chain that
	-- does not mention it.
	{ 98515, "Vaults of Atal'Utek: A Toxic Tour" },
	{ 93417, "The Vaults of Atal'Utek: Altar of Fangs" },
}

--- The repeatables. Rob, reading the finished Codex article: "wat ik mis zijn de
--- vele daily's quest daar". The article says a rotating set exists and names not
--- one of them, which is the same as not saying it.
---
--- All ten ids come from ONE addon (Plumber's Midnight landing page) and nothing
--- else on this machine carries them, so there is no second source and no vote to
--- take. That is fine as a starting point and useless as proof: a title coming
--- back from the client is what turns each line into something shippable, and a
--- silent one stays out of the Codex however plausible it looks.
---
--- Only three sit in the Vaults itself; the weekly meta is picked up in Silvermoon
--- and pays for work done here, which is exactly the kind of thing a beginner
--- never finds on their own.
local REPEATABLE = {
	{ 95520, "Purging the Vaults", "weekly, at the entrance" },
	{ 98232, "Midnight: Vaults of Atal'Utek", "weekly meta, picked up in Silvermoon" },
	{ 96995, "Turn Back the Surge", "weekly, Coiled Isle surface" },

	-- The Coiled Isle portal chain (method.gg, 16 aug). Gates the portal we just added
	-- to MIDNIGHT_PORTALS, so a wrong id means the portal never appears for anyone.
	-- ✅ 96004 VERIFIED 16 aug on Rob's shaman: the client returns "Prey: A Slithering
	-- Threat", character for character. The portal gate rests on a real id.
	{ 96004, "Prey: A Slithering Threat", "unlocks the Coiled Isle portal" },
	-- ⚠️ 96466: UNDECIDED, and my first reading of it was wrong.
	--
	-- The server answered `serverKnowsIt = false` and I wrote that down as "the id is
	-- wrong". Rob pushed back: Method may have tested on the PTR, and a quest that only
	-- becomes real when Season 2 activates would look exactly like this today. He is
	-- right, and "the server has no such quest" only ever meant "not today".
	--
	-- 96004 resolving does NOT settle it. That one is gated behind Nightmare Prey Hunts
	-- too, so availability is clearly no obstacle to resolving — but 96004 already
	-- existed in Season 1, and 96466 may be new. The two are not comparable.
	--
	-- ⏰ RE-MEASURE AFTER THE RESET (S2 opens 18 aug US / 19 aug EU). Resolves then =
	-- the id was right all along and this note was the mistake. Still silent = a wrong
	-- id, and only then.
	{ 96466, "Prey: Anguish Island (undecided until the S2 reset)", "follow-up" },

	{ 96639, "Patrolling the Temple", "group daily" },
	{ 96640, "Bounty of the Cursed", "group daily" },
	{ 96641, "Relentless Strikes", "group daily" },
	{ 96642, "Decisive Incursions", "group daily" },
	{ 96643, "From Whence it Came", "group daily" },
	{ 96644, "Essence of Malice", "group daily" },
	{ 98420, "What's Out There?", "group daily" },
}

--- The word the currency family is built on. "Coin" and "Soul" are both live
--- candidates for the second half and neither is safe to filter on — the client
--- carries a dozen coins and several souls. "corros" survives the rename either way.
local CURRENCY_WORD = "corros"

--- Where Midnight currencies have landed so far (Dawncrests 3341-3347/3383, Voidlight
--- Marl 3316, Moxie 3402), plus room above for what 12.1 added. Deliberate range, not
--- a magic number; widen it from the command if nothing turns up.
local SWEEP_FROM, SWEEP_TO = 3300, 3800

--- ⚠️ MEASURED 13 Aug 2026 — AND IT FOUND ONLY HALF THE STORY.
---
--- Rob ran this inside the Vaults. The sweep answered cleanly: **Corrosive Coin = 3448**,
--- 3531 of them, filed under "Zones", described as "Spirits of the Amani within the
--- Vaults of Atal'Utek deal exclusively in this phantasmal token." Map 2509, parent 2512.
--- All three quest ids correct, though the game titles two of them longer than the guide
--- did ("Vaults of Atal'Utek: One Coin Too Many").
---
--- But his Corrosive Codex screenshot asks for **Corrosive Souls**, and the sweep did NOT
--- find that — even though "corros" would have matched it, in the name scan and the id
--- sweep both. So Corrosive Souls is not a currency in 3300..3800 and not in his currency
--- list at all, while the Codex shows he holds eleven of them.
---
--- The likeliest reading was that it is an ITEM, offered rather than spent. Hence the bag
--- scan below: a currency sweep cannot see an item, and concluding "it does not exist"
--- from a tool that could never have found it is how you get a confident wrong answer.
---
--- ✅ CONFIRMED the same evening, second run: **Corrosive Soul = item 273000**, eleven in
--- his bags. Not a currency at all, which is why every currency route missed it.
---
--- So three names, three different things, and they must not be conflated:
---
---     Corrosive Coin    currency 3448   the zone's ordinary coin (thousands held)
---     Corrosive Soul    item 273000     offered in the Corrosive Codex to unlock gifts
---     Spirit Corrosion  ?               the Altar of Corrosion tree; its counter read 0
---
--- The guides call the first two by each other's names. The client does not.
local BAG_WORD = "corros"

--- The Coiled Isle, measured off Rob's own client on 6 Aug (docs/RESEARCH_12_1.md).
--- The Vaults are a child map of it and their own id is what we are missing.
local COILED_ISLE_MAP = 2512

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH")
end

local function IsSecret(value)
	return value ~= nil and issecretvalue ~= nil and issecretvalue(value) == true
end

--- A string we may print, or nil. Anything secret or empty comes back as nil so the
--- caller says "unreadable" rather than printing a placeholder as if it were data.
local function SafeText(value)
	if type(value) ~= "string" or value == "" or IsSecret(value) then
		return nil
	end
	return value
end

local function Contains(text, needle)
	local s = SafeText(text)
	if not s then
		return false
	end
	return s:lower():find(needle, 1, true) ~= nil
end

-- ---------------------------------------------------------------------------
-- The quest chain
-- ---------------------------------------------------------------------------

local function QuestState(id)
	local done, onQuest, title = false, false, nil
	if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
		local ok, v = pcall(C_QuestLog.IsQuestFlaggedCompleted, id)
		done = (ok and v) and true or false
	end
	if C_QuestLog and C_QuestLog.IsOnQuest then
		local ok, v = pcall(C_QuestLog.IsOnQuest, id)
		onQuest = (ok and v) and true or false
	end
	if C_QuestLog and C_QuestLog.GetTitleForQuestID then
		local ok, v = pcall(C_QuestLog.GetTitleForQuestID, id)
		title = ok and SafeText(v) or nil
	end
	return done, onQuest, title
end

local function PrintChain(rows)
	print("   |cff8fd3ffQuest chain|r  (ids UNVERIFIED — the title is the check)")
	for _, row in ipairs(CHAIN) do
		local id, label = row[1], row[2]
		local done, onQuest, title = QuestState(id)
		local state
		if onQuest then
			state = "|cffffd100in your log|r"
		elseif done then
			state = "|cff40c040completed|r"
		else
			state = "|cff9d9d9d-|r"
		end
		local shown = title or "|cffff5040no title from the game|r"
		print(("      %d  %-32s %-16s %s"):format(id, label, state, shown))
		rows[#rows + 1] = {
			id = id, guideLabel = label, gameTitle = title,
			completed = done, onQuest = onQuest,
			matches = (title ~= nil) and (title == label) or nil,
		}
	end
	-- A guide label and a game title that differ are not automatically a wrong id --
	-- the client is localised and Rob plays on auto/English -- so this reports the
	-- disagreement instead of ruling on it.
	print("      |cff8a8f98A missing title means the id is wrong. A different title may just be your language.|r")
end

local function PrintRepeatable(rows)
	print("   |cff8fd3ffDailies and weeklies|r  (one addon's ids — the title is the check)")
	for _, row in ipairs(REPEATABLE) do
		local id, label, kind = row[1], row[2], row[3]
		local done, onQuest, title = QuestState(id)
		local state
		if onQuest then
			state = "|cffffd100in your log|r"
		elseif done then
			-- A daily you did today and a weekly you did this week both read as
			-- completed here; the flag resets with the quest, so this says "not
			-- available right now", not "finished forever".
			state = "|cff40c040done for now|r"
		else
			state = "|cff9d9d9d-|r"
		end
		local shown = title or "|cffff5040no title from the game|r"
		print(("      %d  %-30s %-14s %-22s %s"):format(id, label, state, kind, shown))
		rows[#rows + 1] = {
			id = id, guideLabel = label, kind = kind, gameTitle = title,
			completed = done, onQuest = onQuest,
			matches = (title ~= nil) and (title == label) or nil,
		}
	end
	print("      |cff8a8f98Titles come back for any real quest id, whether or not you can see the quest today.|r")
end

--- ⚠️ A silent title is not proof the id is wrong. SETTLED 15 Aug 2026, and it
--- went the way that costs you a real quest if you guess.
---
--- GetTitleForQuestID reads a client-side cache. On the first /mh atal nine ids
--- answered and the tenth -- the weekly meta you pick up in Silvermoon -- did
--- not. The nine were no control for that: every one is a quest Rob could
--- plausibly have seen, so they prove the API works and say nothing about a cache
--- miss. On the second run, with nothing changed but time, the tenth returned
--- "Midnight: Vaults of Atal'Utek" -- matching the addon's label exactly.
---
--- So the empty answer was a cold cache, and reading it as "the id is fake" would
--- have thrown away a real weekly that a player would otherwise never find.
---
--- RequestLoadQuestByID asks the server, which turns "no answer" into an answer.
--- It stays because the next id may not be lucky enough to warm up on its own.
local function ChaseMissingTitles(rows)
	if not (C_QuestLog and C_QuestLog.RequestLoadQuestByID and CreateFrame) then
		print("      |cff8a8f98No RequestLoadQuestByID here — a silent id stays undecided, not disproven.|r")
		return
	end
	local want, ids = {}, {}
	for _, r in ipairs(rows) do
		if not r.gameTitle then
			want[r.id] = r
			ids[#ids + 1] = r.id
		end
	end
	if #ids == 0 then
		return
	end
	print(("      |cff8a8f98Asking the server about %d id(s) the cache had nothing for...|r"):format(#ids))

	local f = CreateFrame("Frame")
	f:RegisterEvent("QUEST_DATA_LOAD_RESULT")
	f:SetScript("OnEvent", function(self, _, questID, success)
		local r = want[questID]
		if not r then
			return
		end
		want[questID] = nil
		local title
		if success and C_QuestLog.GetTitleForQuestID then
			local ok, v = pcall(C_QuestLog.GetTitleForQuestID, questID)
			title = ok and SafeText(v) or nil
		end
		r.gameTitle = title
		r.askedServer = true
		r.serverKnowsIt = success and true or false
		if title then
			print(("      %d  |cff40c040the server knows it:|r %s"):format(questID, title))
		elseif success then
			print(("      %d  |cffffd100loaded, but still no title|r"):format(questID))
		else
			print(("      %d  |cffff5040the server has no such quest — the id is wrong|r"):format(questID))
		end
		if not next(want) then
			self:UnregisterAllEvents()
			self:SetScript("OnEvent", nil)
		end
	end)
	for _, id in ipairs(ids) do
		pcall(C_QuestLog.RequestLoadQuestByID, id)
	end
end

-- ---------------------------------------------------------------------------
-- The currency, without ever naming it ourselves
-- ---------------------------------------------------------------------------

--- Walk the player's own currency list. Honest limit: a currency this character has
--- never earned may not be listed at all, so "not found" means "not in your list".
local function ScanCurrencyList(found)
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyListSize and C_CurrencyInfo.GetCurrencyListInfo) then
		print("   |cffff8080currency list API not available|r")
		return
	end
	local okSize, size = pcall(C_CurrencyInfo.GetCurrencyListSize)
	size = (okSize and tonumber(size)) or 0
	if size == 0 then
		print("   |cffe8c36ayour currency list is empty|r — open the Currencies tab once, then retry")
		return
	end
	local header = "?"
	local hits = 0
	for i = 1, size do
		local okI, info = pcall(C_CurrencyInfo.GetCurrencyListInfo, i)
		if okI and type(info) == "table" then
			local name = SafeText(info.name)
			if name and info.isHeader then
				header = name
			elseif name and (Contains(name, CURRENCY_WORD) or Contains(info.description, "atal")) then
				hits = hits + 1
				print(("      |cff40c040%-28s|r id %-6s qty %-8s under %s"):format(
					name, tostring(info.currencyID), tostring(info.quantity), header))
				found[#found + 1] = {
					source = "list", name = name, id = info.currencyID,
					qty = info.quantity, header = header,
				}
			end
		end
	end
	if hits == 0 then
		print(("      |cff9d9d9dnothing matching \"%s\" in your list (%d rows)|r"):format(CURRENCY_WORD, size))
	end
end

--- GetCurrencyInfo answers for any id, so this finds currencies the character has
--- never touched. Matches the name on "corros" and the description on "atal", because
--- a family rename would take the name with it and leave the description behind.
local function SweepCurrencyIds(from, to, found)
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		return
	end
	local a = math.floor(tonumber(from) or SWEEP_FROM)
	local b = math.floor(tonumber(to) or SWEEP_TO)
	if b < a then
		a, b = b, a
	end
	print(("   |cff8fd3ffCurrency sweep|r  ids %d-%d, name \"%s\" or description \"atal\""):format(
		a, b, CURRENCY_WORD))
	local hits = 0
	for id = a, b do
		local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
		if ok and type(info) == "table" then
			local name = SafeText(info.name)
			if name and (Contains(name, CURRENCY_WORD) or Contains(info.description, "atal")) then
				hits = hits + 1
				print(("      |cff40c040%-28s|r id %-6s qty %-8s max %s"):format(
					name, tostring(id), tostring(info.quantity), tostring(info.maxQuantity)))
				found[#found + 1] = {
					source = "sweep", name = name, id = id,
					qty = info.quantity, maxQuantity = info.maxQuantity,
					description = SafeText(info.description),
				}
			end
		end
	end
	if hits == 0 then
		print(("      |cffff8080nothing matched|r — try a wider range: /mh atal %d %d"):format(a - 300, b + 400))
	end
end

--- The bags, for whatever the Codex is really asking you to offer.
---
--- `C_Container` is the 11.x+ shape and the only one this client has; the old
--- `GetContainerItemInfo` globals are long gone, so there is no fallback to write.
local function ScanBagsForItems(found)
	local CC = C_Container
	if not (CC and CC.GetContainerNumSlots and CC.GetContainerItemInfo) then
		print("   |cff9d9d9dC_Container unavailable — cannot look in your bags.|r")
		return
	end
	print(("   |cff8fd3ffBags|r  items whose name contains \"%s\""):format(BAG_WORD))
	local hits = 0
	for bag = 0, 5 do
		local okN, slots = pcall(CC.GetContainerNumSlots, bag)
		for slot = 1, (okN and slots or 0) do
			local okI, info = pcall(CC.GetContainerItemInfo, bag, slot)
			if okI and type(info) == "table" then
				local name = SafeText(info.itemName)
				if name and Contains(name, BAG_WORD) then
					hits = hits + 1
					print(("      |cff40c040%-30s|r item %-8s x%s"):format(
						name, tostring(info.itemID), tostring(info.stackCount)))
					found[#found + 1] = {
						source = "bag", name = name, itemID = info.itemID,
						count = info.stackCount,
					}
				end
			end
		end
	end
	if hits == 0 then
		print("      |cff9d9d9dnothing matching in your bags|r")
		print("      |cff8a8f98The Codex counter may be a hidden currency rather than an item;|r")
		print("      |cff8a8f98then a wider sweep is the next thing to try, not this.|r")
	end
end

-- ---------------------------------------------------------------------------
-- Where you are standing
-- ---------------------------------------------------------------------------

local function PrintMap(out)
	if not (C_Map and C_Map.GetBestMapForUnit) then
		print("   |cffff8080C_Map not available|r")
		return
	end
	local okMap, mapID = pcall(C_Map.GetBestMapForUnit, "player")
	mapID = okMap and mapID or nil
	if not mapID then
		print("   |cffe8c36ano map for you right now|r (loading screen?)")
		return
	end
	local info
	if C_Map.GetMapInfo then
		local ok, mi = pcall(C_Map.GetMapInfo, mapID)
		info = ok and mi or nil
	end
	local name = (type(info) == "table" and SafeText(info.name)) or "?"
	local parent = (type(info) == "table" and info.parentMapID) or nil
	print(("   |cff8fd3ffWhere you are|r  uiMapID |cffffffff%s|r  %s  (parent %s)"):format(
		tostring(mapID), name, tostring(parent)))

	local x, y
	if C_Map.GetPlayerMapPosition then
		local okPos, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
		if okPos and pos and pos.GetXY then
			local okXY, px, py = pcall(pos.GetXY, pos)
			if okXY and px then
				x, y = px * 100, (py or 0) * 100
				print(("      you are at %.2f, %.2f"):format(x, y))
			end
		end
	end

	out.mapID, out.mapName, out.parentMapID, out.x, out.y = mapID, name, parent, x, y

	-- The one number this whole file is really after. The Vaults are a child map of
	-- The Coiled Isle (2512, measured 6 Aug), and their own id is not written down
	-- anywhere in the repo.
	local looksLikeVaults = Contains(name, "atal") or Contains(name, "vault")
	if looksLikeVaults or parent == COILED_ISLE_MAP then
		print(("      |cff40c040THIS IS THE ID WE NEED. Vaults uiMapID = %s|r"):format(tostring(mapID)))
	elseif mapID == COILED_ISLE_MAP then
		print("      you are on The Coiled Isle (2512). The Vaults are through the tunnel;")
		print("      run this again once you are inside.")
	end

	-- Coverage, because an unknown zone and an empty list must not look the same.
	if ns.IsZoneCovered then
		local covered, zoneKey = ns.IsZoneCovered(mapID)
		if covered then
			print(("      coverage: |cff40c040known|r as '%s'"):format(tostring(zoneKey)))
		else
			print("      coverage: |cffe8c36aNOT KNOWN to Midnight Helper|r — correct for now, nothing is broken")
		end
	end
end

-- ---------------------------------------------------------------------------
-- The altar itself, but only if it is open
-- ---------------------------------------------------------------------------

--- Reads the gossip window that happens to be open. No event is registered: the
--- altar is a place you stand at once, and a permanent listener for it would cost
--- every player something for a capture that happens twice.
local function PrintGossip(out)
	if not (C_GossipInfo and C_GossipInfo.GetOptions) then
		return
	end
	local ok, options = pcall(C_GossipInfo.GetOptions)
	if not ok or type(options) ~= "table" or #options == 0 then
		print("   |cff9d9d9dNo gossip window open.|r Stand at the Altar of Corrosion, talk to it, then run this again.")
		return
	end
	print(("   |cff8fd3ffGossip window|r  %d option(s)"):format(#options))
	local text
	if C_GossipInfo.GetText then
		local okText, value = pcall(C_GossipInfo.GetText)
		text = okText and SafeText(value) or nil
	end
	if text then
		print(("      text: %s"):format(text:sub(1, 120)))
	end
	out.gossip = { text = text, options = {} }
	for i, opt in ipairs(options) do
		if type(opt) == "table" then
			local label = SafeText(opt.name) or SafeText(opt.text) or "|cffff5040unreadable|r"
			local id = opt.gossipOptionID or opt.gossipOptionId or opt.orderIndex
			print(("      %d. id %-8s %s"):format(i, tostring(id), label))
			out.gossip.options[#out.gossip.options + 1] = {
				index = i, id = id, label = SafeText(opt.name) or SafeText(opt.text),
				status = opt.status, flags = opt.flags, spellID = opt.spellID,
			}
		end
	end
	print("      |cff8a8f98The guide says \"Corrode Spirit\" costs 1000. If the option text names a price, that settles it.|r")
end

-- ---------------------------------------------------------------------------
-- The three achievements — and the one thing we still take on trust
-- ---------------------------------------------------------------------------

--- ⚠️ ADDED 14 Aug 2026, AND THIS IS THE SECTION THAT MATTERS MOST NOW.
---
--- Modules/AchievementsData.lua now ships The Honored Dead as a routed twelve-node hunt.
--- Its coordinates come from HandyNotes_Midnight 150, which this repo trusts for
--- coordinates. Its criteria ids come from the same file, which this repo has NOT
--- trusted for ids since 13 Aug — `/mh rarequests` proved HandyNotes' Coiled Isle quest
--- band was not the flag the game actually fires.
---
--- So the hunt is shipped on a source that is half-trusted, and the failure is silent:
--- a wrong criteria id leaves the card stuck at 0/12 while the player stands on the
--- memorial. This asks the client for the truth instead. Anything the client prints
--- here beats anything a note file says.
local ACHIEVEMENTS = {
	{ id = 63610, label = "The Honored Dead (twelve memorials, map 2509)" },
	{ id = 63601, label = "the three rare elites on 2509 (locations still unknown)" },
	{ id = 62601, label = "the Underbelly (map 2613)" },

	-- Added 15 Aug with the island's own hunts. 63359 is the one that now SHIPS a
	-- routed twelve-plus-ten-node hunt on HandyNotes criteria, so it is the one that
	-- fails silently if those ids are wrong — a card stuck on 0/22 while you stand on
	-- the chest. The other three are on deck for the same treatment and are listed so
	-- one run answers for all of them.
	{ id = 63359, label = "Treasures of the Coiled Isle — SHIPPED, 22 nodes, verify these" },
	{ id = 63358, label = "the Coiled Isle rares (12 criteria in HandyNotes)" },
	{ id = 63395, label = "skyriding glyphs on 2512 (11 in HandyNotes)" },
	{ id = 63662, label = "Student of Hissstory (10 on 2512)" },
}

--- Exactly what AchievementsData.lua ships for 63610, in the order it ships them.
--- Present so the probe can say "these match" or "these do not" rather than leaving
--- Rob to compare two lists of six-digit numbers by eye.
local HONORED_DEAD_CRITERIA = {
	116407, 116408, 116409, 116410, 116411, 116412,
	116413, 116414, 116415, 116416, 116417, 116418,
}

local function PrintAchievements(out)
	if not (GetAchievementInfo and GetAchievementNumCriteria and GetAchievementCriteriaInfo) then
		print("   |cffff8080achievement API not available|r")
		return
	end
	print("   |cff8fd3ffAchievements|r  (criteria ids below come from YOUR client)")

	local shipped = {}
	for _, id in ipairs(HONORED_DEAD_CRITERIA) do
		shipped[id] = true
	end

	for _, row in ipairs(ACHIEVEMENTS) do
		local rec = { id = row.id, criteria = {} }
		local okInfo, _, name, _, completed = pcall(GetAchievementInfo, row.id)
		rec.name = okInfo and SafeText(name) or nil
		rec.completed = okInfo and completed and true or false
		print(("      |cffffffff%d|r  %s  — %s  %s"):format(
			row.id,
			rec.name or "|cffff5040no name from the game|r",
			row.label,
			rec.completed and "|cff40c040earned|r" or "|cff9d9d9dnot earned|r"))

		local okNum, num = pcall(GetAchievementNumCriteria, row.id)
		num = (okNum and tonumber(num)) or 0
		if num == 0 then
			print("         (the client lists no criteria for this id)")
		end
		local matched, unmatched = 0, 0
		for i = 1, num do
			-- criteriaID is the 10th return of GetAchievementCriteriaInfo.
			local okC, cName, _, cDone, _, _, _, _, _, _, criteriaID = pcall(GetAchievementCriteriaInfo, row.id, i)
			if okC then
				local cid = tonumber(criteriaID) or 0
				rec.criteria[#rec.criteria + 1] = { index = i, id = cid, name = SafeText(cName), done = cDone and true or false }
				local tag = ""
				if row.id == 63610 then
					if shipped[cid] then
						matched = matched + 1
						tag = "  |cff40c040(we ship this one)|r"
					else
						unmatched = unmatched + 1
						tag = "  |cffff5040(NOT in our data)|r"
					end
				end
				print(("         %2d  criteria |cffffffff%d|r  %s  %s%s"):format(
					i, cid, SafeText(cName) or "?", cDone and "done" or "-", tag))
			end
		end

		if row.id == 63610 and num > 0 then
			if unmatched == 0 and matched == #HONORED_DEAD_CRITERIA then
				print("         |cff40c040All twelve match what we ship — the hunt will tick off correctly.|r")
			else
				print(("         |cffff5040%d of the client's criteria are not in our data (%d matched).|r"):format(
					unmatched, matched))
				print("         |cffff5040Replace the criteria ids in Modules/AchievementsData.lua with the ones above.|r")
			end
		end

		out.achievements[#out.achievements + 1] = rec
	end
end

-- ---------------------------------------------------------------------------
-- /mh atal [from] [to]
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- The island's own structure — added 14 Aug 2026, for two of Rob's questions
-- ---------------------------------------------------------------------------

--- ⚠️ WHY. Rob asked two things a screenshot cannot settle.
---
--- 1. His Delves panel lists eleven delves and none of them are on the Coiled Isle.
---    That is not a client fact, it is OUR fact: `Modules/Delves.lua` carries a
---    hardcoded roster of eleven base-Midnight delves and the POI scan is driven by
---    those names. A delve 12.1 added can therefore never appear, however live it is.
---    The watchers name three (The Ring of Glory, Gnarldor Isle, Venomfall Deeps) --
---    from datamining in June, which is exactly the class of source this repo does
---    not ship from. So: ask the client what POIs the island actually has.
---
--- 2. His Vaults map shows four gold arrows, two at the bottom and one on the right.
---    They look like map transitions, and looking like one is not being one.
---
--- Both are read-only queries, and both are guarded: if an API is not there, this
--- says so rather than printing an empty list that reads like "there is nothing".
local MAPS_OF_INTEREST = {
	{ 2512, "The Coiled Isle" },
	{ 2509, "Vaults of Atal'Utek" },
	{ 2613, "The Underbelly" },
}

--- ⚠️ WIDENED 14 Aug, after the first run answered too narrowly.
---
--- The first POI sweep covered the three maps above and returned exactly one POI, a
--- world quest. No delve. It is tempting to read that as "the new delves are not live",
--- and it does not support that: it only says they are not on the Coiled Isle right now.
---
--- That they would be on the Coiled Isle was OUR assumption, never a measurement --
--- and "Gnarldor Isle" does not sound like a place on this island. So the POI sweep
--- runs over every Midnight zone the delve roster already knows, and a delve icon is
--- then found wherever it actually is instead of confirmed absent where we guessed.
--- Ids only, deliberately. These come from the delve roster in Modules/Delves.lua,
--- which stores entrance maps and not their names -- and of 2424 and 2437 this repo
--- records no name anywhere. Writing plausible ones here ("Quel'Danas", "Eversong")
--- would put an invention in the output of the one tool whose whole job is to be
--- believed over a guide. The client knows the names; it is asked for them below.
local MIDNIGHT_ZONES = { 2393, 2395, 2405, 2413, 2424, 2437, 2512, 2509, 2613 }

--- What the client calls a map, or the id if it will not say.
local function MapLabel(mapID)
	if C_Map and C_Map.GetMapInfo then
		local ok, info = pcall(C_Map.GetMapInfo, mapID)
		if ok and type(info) == "table" then
			local name = SafeText(info.name)
			if name then
				return name
			end
		end
	end
	return ("map %d"):format(mapID)
end

--- Where you can walk from one map into another. This is what the arrows on the
--- map are drawn from, so the count here should match what Rob counted by eye --
--- and if it does not, the arrows are something else and we learn that too.
local function PrintMapLinks(out)
	if not (C_Map and C_Map.GetMapLinksForMap) then
		print("   |cff9d9d9dC_Map.GetMapLinksForMap not on this client|r — the arrows stay unexplained; not a failure.")
		return
	end
	print("   |cff8fd3ffMap links|r  (the transitions the map draws arrows for)")
	for _, row in ipairs(MAPS_OF_INTEREST) do
		local mapID, label = row[1], row[2]
		local ok, links = pcall(C_Map.GetMapLinksForMap, mapID)
		if not ok or type(links) ~= "table" then
			print(("      %-24s |cff9d9d9dno answer|r"):format(label))
		elseif #links == 0 then
			print(("      %-24s |cff9d9d9d0 links|r"):format(label))
		else
			print(("      |cffffffff%s|r (%d) — %d link(s)"):format(label, mapID, #links))
			for i, link in ipairs(links) do
				local x, y
				if type(link.position) == "table" and link.position.GetXY then
					local okXY, px, py = pcall(link.position.GetXY, link.position)
					if okXY and px then x, y = px * 100, (py or 0) * 100 end
				end
				local name = SafeText(link.name) or "?"
				print(("         %d. -> map %-6s %-28s %s"):format(
					i, tostring(link.linkedUiMapID), name,
					x and ("%.2f, %.2f"):format(x, y) or "no position"))
				out.links[#out.links + 1] = {
					fromMap = mapID, toMap = link.linkedUiMapID,
					name = name, x = x, y = y,
				}
			end
		end
	end
end

--- Everything the island has a point of interest for. Deliberately unfiltered:
--- filtering on "delve" assumes we already know what a delve POI looks like in
--- 12.1, and that assumption is the thing being tested. The atlas name is the
--- useful column -- it is what the icon is drawn from.
local function PrintAreaPOIs(out)
	local API = C_AreaPoiInfo
	if not (API and API.GetAreaPOIForMap and API.GetAreaPOIInfo) then
		print("   |cff9d9d9dC_AreaPoiInfo not on this client|r — cannot list what is on the island.")
		return
	end
	print("   |cff8fd3ffPoints of interest|r  (every POI, with the atlas its icon comes from)")
	for _, mapID in ipairs(MIDNIGHT_ZONES) do
		local label = MapLabel(mapID)
		local okList, pois = pcall(API.GetAreaPOIForMap, mapID)
		if not okList or type(pois) ~= "table" or #pois == 0 then
			print(("      %-24s |cff9d9d9dnothing listed right now|r"):format(label))
		else
			print(("      |cffffffff%s|r (%d) — %d POI(s)"):format(label, mapID, #pois))
			for _, poiID in ipairs(pois) do
				local okI, info = pcall(API.GetAreaPOIInfo, mapID, poiID)
				if okI and type(info) == "table" then
					local name = SafeText(info.name) or "?"
					local atlas = SafeText(info.atlasName) or "-"
					local x, y
					if type(info.position) == "table" and info.position.GetXY then
						local okXY, px, py = pcall(info.position.GetXY, info.position)
						if okXY and px then x, y = px * 100, (py or 0) * 100 end
					end
					-- Highlight anything the icon calls a delve, without relying on it.
					local tag = Contains(atlas, "delve") and "  |cff40c040<- delve icon|r" or ""
					print(("         %-7s %-30s %-26s %s%s"):format(
						tostring(poiID), name, atlas,
						x and ("%.2f, %.2f"):format(x, y) or "-", tag))
					out.pois[#out.pois + 1] = {
						map = mapID, poiID = poiID, name = name,
						atlas = atlas, x = x, y = y,
					}
				end
			end
		end
	end
	print("      |cff8a8f98A POI list can be empty because nothing is up right now, not only|r")
	print("      |cff8a8f98because nothing exists. Empty here is not proof of absence.|r")
end

--- ⚠️ ADDED 14 Aug, because the sweep above asked the wrong question — and said so.
---
--- The wide run returned 21 POIs across nine zones and not one delve. That reads like
--- an answer. It is not: the eleven delves this addon already ships were not in it
--- either, and those certainly exist. Zul'Aman lists two portals and no Atal'Aman.
---
--- So GetAreaPOIForMap does not return delves at all, and every "no delve found" it
--- produced was a statement about the API. The only reason this was catchable is that
--- the sweep happened to carry eleven known-positive controls; without them the empty
--- result would have looked like news.
---
--- Delves.lua already knew the right call — C_AreaPoiInfo.GetDelvesForMap, which it
--- uses for bountiful state. That one is keyed on the map, not on a name, so unlike our
--- roster it can return a delve nobody has told it about. Which is the whole question.
local function PrintDelvePOIs(out)
	local API = C_AreaPoiInfo
	if not (API and API.GetDelvesForMap and API.GetAreaPOIInfo) then
		print("   |cff9d9d9dC_AreaPoiInfo.GetDelvesForMap not on this client|r — cannot enumerate delves.")
		return
	end
	print("   |cff8fd3ffDelves the client lists per map|r  (name-independent — this can find new ones)")
	local total = 0
	for _, mapID in ipairs(MIDNIGHT_ZONES) do
		local label = MapLabel(mapID)
		local okList, ids = pcall(API.GetDelvesForMap, mapID)
		local list = (okList and type(ids) == "table") and ids or {}
		if #list == 0 then
			print(("      %-24s |cff9d9d9d-|r"):format(label))
		else
			print(("      |cffffffff%s|r (%d) — %d delve(s)"):format(label, mapID, #list))
			for _, poiID in ipairs(list) do
				local okI, info = pcall(API.GetAreaPOIInfo, mapID, poiID)
				local name, atlas, x, y
				if okI and type(info) == "table" then
					name = SafeText(info.name)
					atlas = SafeText(info.atlasName)
					if type(info.position) == "table" and info.position.GetXY then
						local okXY, px, py = pcall(info.position.GetXY, info.position)
						if okXY and px then x, y = px * 100, (py or 0) * 100 end
					end
				end
				-- Ours or new? The roster is the eleven in Delves.lua; anything the
				-- client names that we do not carry is exactly what we came for.
				-- Not `f and f(name) or nil`: that idiom turns a false return into nil,
				-- and false is the answer this whole block exists to print.
				local known = nil
				if ns.IsKnownDelveName then
					known = ns.IsKnownDelveName(name)
				end
				local tag = ""
				if known == false then
					tag = "  |cff40c040<- NOT IN OUR ROSTER|r"
				elseif known == true then
					tag = "  |cff8a8f98(we ship this one)|r"
				end
				total = total + 1
				print(("         %-7s %-30s %-24s %s%s"):format(
					tostring(poiID), name or "?", atlas or "-",
					x and ("%.2f, %.2f"):format(x, y) or "-", tag))
				out.delves[#out.delves + 1] = {
					map = mapID, poiID = poiID, name = name,
					atlas = atlas, x = x, y = y, inRoster = known,
				}
			end
		end
	end
	if total == 0 then
		print("      |cffe8c36aNo delves on any of these maps.|r Since we ship eleven, that means")
		print("      |cffe8c36athis call is not answering either — not that there are none.|r")
	end
end

-- ---------------------------------------------------------------------------
-- The Corrosive Codex: is it a trait tree, and can we read it?
-- ---------------------------------------------------------------------------

--- The spec for the Codex module rests on one thing nobody has checked: whether the
--- twelve powers and their unlock state are readable at all without the player
--- standing at the altar. If they are not, half that spec is a cache that starts
--- empty and the UI has to say so.
---
--- Every comparable player-power system since Dragonflight is a C_Traits tree, so
--- that is the first place to look — but "Plumber does not list one for 12.1" is not
--- evidence of absence, only of nobody having added it.
---
--- ⚠️ THE CONTROLS ARE THE POINT. This sweep must find the player's class trees and
--- Runes of Power (tree 1186). If it finds nothing at all, the sweep is broken and
--- says nothing about the Codex. An empty result with the controls present is a real
--- answer: the Codex is not a trait tree and the spec needs a different approach.
local function SweepTraitTrees(out)
	if not (C_Traits and C_Traits.GetConfigIDByTreeID) then
		print("   |cffff8080C_Traits not available — cannot tell whether the Codex is a trait tree.|r")
		out.traitsAvailable = false
		return
	end
	out.traitsAvailable = true
	print("   |cff8fd3ffTrait trees|r  (your class trees and Runes of Power 1186 are the controls)")

	local hits = 0
	for treeID = 1, 1400 do
		local okC, configID = pcall(C_Traits.GetConfigIDByTreeID, treeID)
		if okC and configID then
			local nodes
			if C_Traits.GetTreeNodes then
				local okN, list = pcall(C_Traits.GetTreeNodes, treeID)
				nodes = (okN and type(list) == "table") and #list or nil
			end
			local currencies
			if C_Traits.GetTreeCurrencyInfo then
				local okCur, list = pcall(C_Traits.GetTreeCurrencyInfo, configID, treeID, false)
				if okCur and type(list) == "table" then
					currencies = {}
					for _, ci in ipairs(list) do
						local e = {
							traitCurrencyID = ci.traitCurrencyID,
							quantity = ci.quantity,
							spent = ci.spent,
						}
						-- ⚠️ A traitCurrencyID is not a currencyID; it is an indirection
						-- that points at either a real currency or an ITEM. Resolving it
						-- is what turns "tree 1057 shows 13 and Rob owns 13 Corrosive
						-- Souls" from a coincidence into an identification. Two numbers
						-- matching is where a wrong answer starts, not where it ends.
						if C_Traits.GetTraitCurrencyInfo and ci.traitCurrencyID then
							local okT, flags, cType, currencyTypesID, icon =
								pcall(C_Traits.GetTraitCurrencyInfo, ci.traitCurrencyID)
							if okT then
								e.flags, e.currencyType = flags, cType
								e.currencyTypesID, e.icon = currencyTypesID, icon
							end
						end
						currencies[#currencies + 1] = e
					end
				end
			end
			-- The config often names its own system, which beats every inference above.
			local cfgName, cfgType
			if C_Traits.GetConfigInfo then
				local okI, info = pcall(C_Traits.GetConfigInfo, configID)
				if okI and type(info) == "table" then
					cfgName, cfgType = info.name, info.type
				end
			end
			-- ⚠️ The names are the decider, not the currency.
			--
			-- The 15 aug run found no tree spending item 273000 — but five trees report
			-- a currency type whose target comes back empty, so "no tree spends it" may
			-- just be "I cannot see where those point". An absence I cannot read is not
			-- an absence.
			--
			-- A spell name cannot be misread. If a tree's nodes are Ula'tek's Gift and
			-- Ophidian Maw, that tree is the Corrosive Codex whatever its currency does;
			-- if no tree carries those names, it is not a trait tree at all. Stored, not
			-- printed — this is hundreds of lines and chat is the wrong place for it.
			local nodeNames
			if C_Traits.GetTreeNodes and C_Traits.GetNodeInfo then
				local okN, list = pcall(C_Traits.GetTreeNodes, treeID)
				if okN and type(list) == "table" then
					nodeNames = {}
					for idx = 1, math.min(#list, 60) do
						local okI, info = pcall(C_Traits.GetNodeInfo, configID, list[idx])
						if okI and type(info) == "table" and info.entryIDs then
							local entryID = info.entryIDs[1]
							if entryID and C_Traits.GetEntryInfo then
								local okE, e = pcall(C_Traits.GetEntryInfo, configID, entryID)
								if okE and type(e) == "table" and e.definitionID
									and C_Traits.GetDefinitionInfo then
									local okD, d = pcall(C_Traits.GetDefinitionInfo, e.definitionID)
									if okD and type(d) == "table" then
										local sid = d.spellID
										local sname, sdesc
										if sid and C_Spell then
											if C_Spell.GetSpellName then
												local okS, v = pcall(C_Spell.GetSpellName, sid)
												sname = okS and v or nil
											end
											-- ⚠️ The game's own effect text, and the reason
											-- this is here. valeera-s2-poisons records that
											-- the three poison spell ids from Wowhead were
											-- ALL wrong, which makes the effect descriptions
											-- from that same page worthless too — and those
											-- are what a curio recommendation would rest on.
											-- The client's text cannot be out of date and is
											-- already in the player's language.
											-- ⚠️ Ask the server BEFORE reading. The 15 aug run
											-- got a description for 88 of 409 named nodes;
											-- the rest were a cold spell cache, exactly like
											-- quest 98232 an hour earlier. Same shape, same
											-- fix, and the second pass below re-reads.
											if C_Spell.RequestLoadSpellData then
												pcall(C_Spell.RequestLoadSpellData, sid)
											end
											if C_Spell.GetSpellDescription then
												local okD, v = pcall(C_Spell.GetSpellDescription, sid)
												-- ⚠️ POSITIVE test, on purpose. Several spells
												-- return a bare "\r\n": empty to a reader, not
												-- empty to `~= ""`. A whitespace-stripping guard
												-- was tried first and CR+LF still reached the
												-- file — and I could not explain why, which is
												-- reason enough not to trust a rule shaped as
												-- "absence of the bad thing".
												--
												-- So require evidence of the good thing: at least
												-- one word character. A description with no
												-- letters and no digits is not a description,
												-- whatever it is made of.
												if okD and type(v) == "string" and v:find("%w") then
													sdesc = v
												end
											end
										end
										nodeNames[#nodeNames + 1] = {
											nodeID = list[idx], spellID = sid,
											name = sname, desc = sdesc,
											ranks = info.ranksPurchased,
											active = info.activeEntry
												and info.activeEntry.entryID or nil,
										}
									end
								end
							end
						end
					end
				end
			end

			hits = hits + 1
			out.traits[#out.traits + 1] = {
				treeID = treeID, configID = configID,
				nodes = nodes, currencies = currencies,
				configName = cfgName, configType = cfgType,
				nodeNames = nodeNames,
			}
			print(("      tree %-5d config %-10s nodes %-4s %s"):format(
				treeID, tostring(configID), tostring(nodes or "?"), cfgName or ""))
		end
	end
	if hits == 0 then
		print("      |cffff5040nothing at all — the sweep found no trees, so it proves nothing|r")
		return
	end
	print(("      |cff8a8f98%d trees. Full node/currency detail in the DB.|r"):format(hits))

	-- Second pass. RequestLoadSpellData above is asynchronous, so the descriptions it
	-- fetches are not there yet when the loop reads them — the first pass can only ever
	-- see what was already cached. This re-reads once the answers have had time to
	-- arrive, and reports how many it gained, so a run that gains nothing is visible as
	-- a failed fetch rather than passing for "these spells have no text".
	if C_Timer and C_Timer.After and C_Spell and C_Spell.GetSpellDescription then
		local before = 0
		for _, tree in ipairs(out.traits) do
			for _, n in ipairs(tree.nodeNames or {}) do
				if n.desc then
					before = before + 1
				end
			end
		end
		C_Timer.After(3, function()
			local after = 0
			for _, tree in ipairs(out.traits) do
				for _, n in ipairs(tree.nodeNames or {}) do
					if n.spellID and not n.desc then
						local okD, v = pcall(C_Spell.GetSpellDescription, n.spellID)
						-- Same positive test as the first pass; see the note there.
						if okD and type(v) == "string" and v:find("%w") then
							n.desc = v
						end
					end
					if n.desc then
						after = after + 1
					end
				end
			end
			print(("%s |cff8fd3ffspell text|r  %d descriptions at first read, |cffffffff%d|r after asking the server."):format(
				Prefix(), before, after))
			if after == before then
				print("   |cffffd100No gain — the fetch did nothing, so a missing description still means unknown.|r")
			end
			print("   |cff8a8f98/reload writes it.|r")
		end)
	end
end

-- ---------------------------------------------------------------------------
-- The soul ledger: measure what a source actually pays
-- ---------------------------------------------------------------------------

--- The Codex spec wants a "N souls still available this week" line, built from a
--- table of yields — 2 for the weekly, 2 for a Pinnacle Cache, 1 for the Foe, 6 for
--- the Journal. Those four numbers come from guides, and they are exactly the number
--- the spec's own section 5 forbids getting wrong.
---
--- Nobody has to grind for them. Corrosive Soul is item 273000, so the count is
--- readable at any moment; this watches it and writes down every change together with
--- what happened just before. Play a week normally and the table fills itself.
---
--- ⚠️ It records the seconds since the last quest turn-in; it does NOT decide that the
--- quest caused the change. A soul from a chest opened eight seconds after handing in
--- a weekly would look identical. Attribution is a judgement to make while reading a
--- column of these, not something to bake into the row that is being measured.
local SOUL_ITEM = 273000

local function SoulCount()
	local f = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not f then
		return nil
	end
	local ok, n = pcall(f, SOUL_ITEM)
	return (ok and tonumber(n)) or nil
end
ns.GetCorrosiveSoulCount = SoulCount

do
	local watcher = CreateFrame("Frame")
	local settled, pending, lastQuest, lastQuestAt, lastQuestTitle

	-- ⚠️ SETTLE BEFORE RECORDING. The first evening of data caught this: the ledger
	-- wrote 3 -> 0 at 21:24:12 and 0 -> 3 at 21:24:13, then the same pair again at
	-- 21:42. Rob spent nothing. The bag simply reads 0 for a moment while it rebuilds,
	-- and reacting to every BAG_UPDATE_DELAYED records that flicker as a transaction.
	--
	-- Left running a week, that fills the table with plus and minus threes and makes
	-- it easy to "measure" that a weekly pays 3 — which is exactly the number the
	-- spec says must never be wrong. An instrument gets tested before it is trusted.
	--
	-- So a change starts a timer instead of a row. Only the value that is still there
	-- afterwards counts, and a flicker that returns to where it started writes nothing
	-- at all, because nothing happened.
	local SETTLE = 3

	local function Record()
		pending = nil
		local now = SoulCount()
		if now == nil or settled == nil or now == settled then
			return
		end
		ns.db = ns.db or {}
		local log = ns.db.soulLedger
		if type(log) ~= "table" then
			log = {}
			ns.db.soulLedger = log
		end
		local at = (time and time()) or 0
		log[#log + 1] = {
			at = at, from = settled, to = now, delta = now - settled,
			quest = lastQuest, questTitle = lastQuestTitle,
			-- nil when no quest was handed in this session: an empty field is honest,
			-- a 0 would read as "at the same moment".
			secondsSinceQuest = lastQuestAt and (at - lastQuestAt) or nil,
		}
		while #log > 100 do
			table.remove(log, 1)
		end
		settled = now
	end

	watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
	watcher:RegisterEvent("BAG_UPDATE_DELAYED")
	watcher:RegisterEvent("QUEST_TURNED_IN")
	watcher:SetScript("OnEvent", function(_, event, arg1)
		if event == "QUEST_TURNED_IN" then
			lastQuest = arg1
			lastQuestAt = (time and time()) or 0
			if C_QuestLog and C_QuestLog.GetTitleForQuestID then
				local ok, v = pcall(C_QuestLog.GetTitleForQuestID, arg1)
				lastQuestTitle = (ok and type(v) == "string" and v ~= "") and v or nil
			end
			return
		end

		-- The baseline waits too. On 15 aug the very first row was 0 -> 3, which is
		-- not a gain: it is the bags not being loaded yet at the first read.
		if not (C_Timer and C_Timer.After) then
			settled = settled or SoulCount()
			return
		end
		if not pending then
			pending = true
			C_Timer.After(SETTLE, function()
				if settled == nil then
					settled = SoulCount()
					pending = nil
					return
				end
				Record()
			end)
		end
	end)
end

-- ---------------------------------------------------------------------------
-- The twelve powers: real spells, just not trait nodes
-- ---------------------------------------------------------------------------

--- ⚠️ LOOKUP TOOL, NOT SHIPPED LOGIC — the same rule AchievementFind.lua carries.
--- Resolving a spell by English name only works on an English client, so nothing in
--- the addon may ever do this at runtime. Names go in here, ids come out, and only
--- the ids get written into a data file.
---
--- Why this exists after concluding the Codex was unreadable: Blizzard's own hotfix
--- notes of 14 Aug name *Gorgoneion Gaze* and *Ula'tek's Gift*. That closes the one
--- alternative reading the trait sweep left open — the spec's names are Blizzard's,
--- not a guide's paraphrase, and they are still in none of the 19 trees. The
--- conclusion got stronger.
---
--- But it also means the powers are SPELLS. "Not a trait tree" was an answer about
--- one route, and I let it stand as an answer about the feature. If a power is a
--- spell, an active one is plausibly an aura on the player, and that is readable.
--- This asks the client for each id and then whether the player knows or carries it.
local CODEX_POWERS = {
	"Ula'tek's Gift", "Ouroboric Cycle", "Ophidian Maw", "Viperine Grasp",
	"Mephitic Cloud", "Miasma Geyser", "Insidious Venom", "Virulent Mucus",
	"Accursed Poison", "Plague of Corrosion", "Gorgoneion Gaze", "Lithic Plumage",
}

local function SweepCodexPowers(out)
	if not (C_Spell and C_Spell.GetSpellIDForSpellIdentifier) then
		print("   |cffff8080No GetSpellIDForSpellIdentifier — cannot look a power up by name.|r")
		return
	end
	-- ⚠️ TWO controls, and the first run had the wrong one.
	--
	-- 15 aug: "Auto Attack" resolved and all twelve powers did not, and I nearly took
	-- that for an answer. But Auto Attack is a spell Rob HAS. It proves the function
	-- works on the player's own spells and says nothing about whether name lookup
	-- reaches a spell they have never cast — which is exactly what the twelve are.
	-- Same mistake as the nine quests that answered being no control for the tenth.
	--
	-- So the control that matters is a spell that certainly exists and that a Paladin
	-- certainly does not have. If those resolve, the lookup reaches beyond the
	-- player's own book and twelve blanks are meaningful. If they do not, twelve
	-- blanks are just the shape of this API and prove nothing at all.
	local function Resolve(name)
		local ok, id = pcall(C_Spell.GetSpellIDForSpellIdentifier, name)
		return (ok and id) or nil
	end

	local mine = Resolve("Auto Attack")
	local foreign = Resolve("Fireball") or Resolve("Chaos Bolt")
	out.powerControlOwn = mine and true or false
	out.powerControlForeign = foreign and true or false

	print("   |cff8fd3ffCorrosive Codex powers|r  (name lookup)")
	print(("      control, a spell you have    : %s"):format(
		mine and "|cff40c040resolves|r" or "|cffff5040fails|r"))
	print(("      control, a spell you do NOT  : %s"):format(
		foreign and "|cff40c040resolves|r" or "|cffff5040fails|r"))
	if not foreign then
		print("      |cffffd100Name lookup does not reach spells you lack, so blanks below prove NOTHING.|r")
	end

	for _, label in ipairs(CODEX_POWERS) do
		local ok, sid = pcall(C_Spell.GetSpellIDForSpellIdentifier, label)
		sid = ok and sid or nil
		local known, hasAura
		if sid then
			if IsPlayerSpell then
				local okK, v = pcall(IsPlayerSpell, sid)
				known = okK and v or false
			end
			-- spellID-based aura reads keep working when auras go secret in 12.1;
			-- index iteration does not. This is the path that survives.
			if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
				local okA, v = pcall(C_UnitAuras.GetPlayerAuraBySpellID, sid)
				hasAura = okA and (v ~= nil) or nil
			end
		end
		out.powers[#out.powers + 1] = {
			name = label, spellID = sid, known = known, hasAura = hasAura,
		}
		print(("      %-22s %s%s"):format(label,
			sid and ("spell |cffffffff" .. sid .. "|r") or "|cff9d9d9dno id|r",
			known and "  |cff40c040known|r" or ""))
	end
	print("      |cff8a8f98English-client lookup only — ids go in a data file, names never ship.|r")
end

--- Enumerate what Rob actually carries, and read the names off that.
---
--- ⚠️ WHY THIS REPLACES THE LOOKUP. On 15 aug the name route came back empty for all
--- twelve — and the second control came back FALSE: a spell a Paladin does not have
--- does not resolve either. GetSpellIDForSpellIdentifier only reaches the player's own
--- book, so twelve blanks were the shape of the API and not a fact about the powers.
--- With the weaker control alone I would have written down "the powers are not spells".
---
--- So this goes the other way: enumerate the auras the player has and read the client's
--- own names off them. No guessing at names, no English-only lookup, and it works for
--- anything Blizzard ever adds — if a power is on him, it is in this list.
---
--- ⚠️ 12.1 aura rules: index iteration Lua-ERRORS once auras are secret, so every read
--- is behind pcall and the loop stops at the first failure rather than spraying errors.
--- The player's own auras are not expected to be secret; expected is not measured, and
--- the stored `stoppedAt` says where it gave up.
local function DumpPlayerAuras(out)
	if not (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) then
		print("   |cffff8080No GetAuraDataByIndex — cannot enumerate your auras.|r")
		return
	end
	for _, filter in ipairs({ "HELPFUL", "HARMFUL" }) do
		for i = 1, 60 do
			local ok, data = pcall(C_UnitAuras.GetAuraDataByIndex, "player", i, filter)
			if not ok then
				out.auraStoppedAt = ("%s #%d"):format(filter, i)
				break
			end
			if not data then
				break
			end
			-- A secret spellId compares as neither equal nor unequal to anything useful;
			-- tonumber on it is the cheap way to find out whether we may keep it.
			local sid = tonumber(data.spellId)
			local nm = data.name
			out.auras[#out.auras + 1] = {
				filter = filter, index = i, spellID = sid,
				name = (type(nm) == "string" and nm ~= "") and nm or nil,
				source = data.sourceUnit,
			}
		end
	end
	print(("   |cff8fd3ffYour auras|r  %d read%s  — the twelve powers, if active, are in here by name"):format(
		#out.auras, out.auraStoppedAt and (", stopped at " .. out.auraStoppedAt) or ""))
	if #out.auras == 0 then
		print("      |cffffd100Nothing at all — that is a failed read, not an empty buff bar.|r")
	end
end

function ns.PrintAtalUtekProbe(from, to)
	local prefix = Prefix()
	print(("%s Vaults of Atal'Utek probe — nothing here is wired into a feature yet."):format(prefix))

	local out = { at = (time and time()) or 0, chain = {}, repeatable = {}, currencies = {} }
	PrintChain(out.chain)
	PrintRepeatable(out.repeatable)
	ChaseMissingTitles(out.repeatable)
	ScanCurrencyList(out.currencies)
	SweepCurrencyIds(from, to, out.currencies)
	out.items = {}
	ScanBagsForItems(out.items)
	out.traits = {}
	SweepTraitTrees(out)
	out.powers = {}
	SweepCodexPowers(out)
	out.auras = {}
	DumpPlayerAuras(out)
	out.achievements = {}
	PrintMap(out)
	PrintAchievements(out)
	out.links, out.pois, out.delves = {}, {}, {}
	PrintMapLinks(out)
	PrintDelvePOIs(out)
	PrintAreaPOIs(out)
	PrintGossip(out)

	ns.db = ns.db or {}
	ns.db.atalProbe = out

	local souls = SoulCount()
	local ledger = (ns.db and type(ns.db.soulLedger) == "table") and #ns.db.soulLedger or 0
	print(("   |cff8fd3ffCorrosive Soul|r  item %d, you hold |cffffffff%s|r  ·  ledger has %d change(s)"):format(
		SOUL_ITEM, tostring(souls or "unreadable"), ledger))
	print("   |cff8a8f98It is an ITEM, not a currency — measured 15 aug, and the spec says otherwise.|r")

	print("   |cff8a8f98Saved to the DB — /reload writes the file. Names and ids come from your client, not from a guide.|r")
	print("   |cff8a8f98Next: /mh capture at the altar for its coordinates, and /mh zone inside the Vaults.|r")
	print("   |cff8a8f98Still open: docs/VAULTS_MEASUREMENTS.md lists what nobody has measured yet.|r")
end
