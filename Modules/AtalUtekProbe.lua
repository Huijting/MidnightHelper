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
}

--- The word the currency family is built on. "Coin" and "Soul" are both live
--- candidates for the second half and neither is safe to filter on — the client
--- carries a dozen coins and several souls. "corros" survives the rename either way.
local CURRENCY_WORD = "corros"

--- Where Midnight currencies have landed so far (Dawncrests 3341-3347/3383, Voidlight
--- Marl 3316, Moxie 3402), plus room above for what 12.1 added. Deliberate range, not
--- a magic number; widen it from the command if nothing turns up.
local SWEEP_FROM, SWEEP_TO = 3300, 3800

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
-- /mh atal [from] [to]
-- ---------------------------------------------------------------------------

function ns.PrintAtalUtekProbe(from, to)
	local prefix = Prefix()
	print(("%s Vaults of Atal'Utek probe — nothing here is wired into a feature yet."):format(prefix))

	local out = { at = (time and time()) or 0, chain = {}, currencies = {} }
	PrintChain(out.chain)
	ScanCurrencyList(out.currencies)
	SweepCurrencyIds(from, to, out.currencies)
	PrintMap(out)
	PrintGossip(out)

	ns.db = ns.db or {}
	ns.db.atalProbe = out

	print("   |cff8a8f98Saved to the DB — /reload writes the file. Names and ids come from your client, not from a guide.|r")
	print("   |cff8a8f98Next: /mh capture at the altar for its coordinates, and /mh zone inside the Vaults.|r")
end
