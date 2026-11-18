local _, ns = ...

--[[
	ForeverLegacy.lua — WoW Forever: Legacy Points, step 1.

	Rob, 17 Nov 2026 (via Sparring 17-11): "legacy points. Wat zijn het? Waar krijg ik het? Hoe krijg ik het? En hoe zet
	ik het in?" On the research: "Legacy ook bouwen en het gat met talented als fout laten repareren."

	Facts: docs/forever/LEGACY_VERIFIED_2026-11-17.md (Fable check against DB2 + Blizzard's own UI code, build 70938).
	We read the points EXACTLY the way Blizzard's Legacy window does (GEMETEN, Blizzard_LegacySystemUtil.lua):
	  configID = C_Traits.GetConfigIDByTreeID(1187)                     (the Professions tree; the currency is shared)
	  info     = C_Traits.GetTreeCurrencyInfo(configID, 1187, false)[1]  → quantity (available), maxQuantity (cap),
	                                                                       spent
	  earned   = C_MajorFactions.GetCurrentRenownLevel(2802)            (the big number in Blizzard's shield)
	Constants.LegacyConsts holds those ids in Forever; the numbers below are only the fallback.
	NOT measured: what this returns on a real character, or whether an addon may call it (the docs mark C_Traits
	"AllowedWhenUntainted"). So everything is pcall'd, nil = unreadable (not "zero points"), and:
	  - "Do this now" says "you have N unused Legacy Points" ONLY when the read succeeds and N > 0, out of combat.
	  - /mh legacy prints every reading, the decision and why, and stores it in ns.db.foreverLegacyProbe for Rob.
	Next step (after Rob's test): the explanation card (what / earn / spend / reset / 16 cap / rewards at Wiley).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

local function Consts()
	local c = rawget(_G, "Constants")
	local lc = type(c) == "table" and c.LegacyConsts or nil
	if type(lc) ~= "table" then
		lc = {}
	end
	return {
		faction = lc.LEGACY_REWARD_TRACK_FACTION_ID or 2802,
		tree = lc.LEGACY_TREE_PROFESSIONS_ID or 1187,
		currency = lc.LEGACY_POINTS_TRAIT_CURRENCY_ID or 4225,
		fromClient = next(lc) ~= nil,
	}
end

--- { earned, available, cap, spent, config, why } — any field nil = the client did not answer.
function ns.ForeverLegacyState()
	local k = Consts()
	local st = { fromClient = k.fromClient }
	if C_MajorFactions and C_MajorFactions.GetCurrentRenownLevel then
		local ok, v = pcall(C_MajorFactions.GetCurrentRenownLevel, k.faction)
		if ok and type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
			st.earned = v
		end
	end
	if not (C_Traits and C_Traits.GetConfigIDByTreeID and C_Traits.GetTreeCurrencyInfo) then
		st.why = "no C_Traits tree functions"
		return st
	end
	local okC, cfg = pcall(C_Traits.GetConfigIDByTreeID, k.tree)
	if not (okC and type(cfg) == "number" and cfg > 0) then
		st.why = okC and "no config for the Legacy tree (not unlocked yet, or not readable)" or ("error: " .. tostring(cfg))
		return st
	end
	st.config = cfg
	local okI, list = pcall(C_Traits.GetTreeCurrencyInfo, cfg, k.tree, false)
	local info = okI and type(list) == "table" and list[1] or nil
	if type(info) ~= "table" then
		st.why = okI and "no currency info" or ("error: " .. tostring(list))
		return st
	end
	local function num(v)
		if type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
			return v
		end
		return nil
	end
	st.available = num(info.quantity)
	st.cap = num(info.maxQuantity)
	st.spent = num(info.spent)
	st.currency = info.traitCurrencyID
	return st
end

--- The "Do this now" line, or nil plus the reason it stays silent.
function ns.ForeverLegacyNow()
	if InCombatLockdown and InCombatLockdown() then
		return nil, "in combat"
	end
	local st = ns.ForeverLegacyState()
	if st.available == nil then
		return nil, "available points unreadable (" .. tostring(st.why or "?") .. ") — silent on purpose"
	end
	-- GEMETEN 17 Nov 2026 on Rob's account without Legacy: earned 0, available 0, spent 0, cap 0. Blizzard's own button
	-- stays shut while renown 2802 is 0 (LEGACY_VERIFIED 2.11), so say that rather than "no unused points".
	if st.earned == 0 then
		return nil, "Legacy not unlocked yet (no point earned on this account)"
	end
	if st.available <= 0 then
		return nil, "no unused points"
	end
	-- The client's own words (GlobalStrings, GEMETEN per language in LEGACY_VERIFIED ch.10): the points' name and the
	-- name of the micro-menu button, so every language says what its screen says.
	local function G(key, fallback)
		local v = rawget(_G, key)
		return (type(v) == "string" and v ~= "") and v or fallback
	end
	return ns:L("FLEGACY_UNUSED_FMT"):format(st.available, G("LEGACY_REWARD_TRACK_POINTS", "Legacy Points"),
		G("LEGACY_BUTTON", "Legacy")), "unused points"
end

local function V(v)
	if v == nil then
		return "|cff9d9d9d? (unreadable)|r"
	end
	return tostring(v)
end

--- /mh legacy: every reading, the decision and why; stored for Rob's test.
function ns.ForeverLegacySlash()
	local st = ns.ForeverLegacyState()
	local line, why = ns.ForeverLegacyNow()
	print(PREFIX .. "Legacy Points — what the client lets us read"
		.. (st.fromClient and "" or " (Constants.LegacyConsts missing: using the measured ids)") .. ":")
	print(("  earned (renown 2802): %s"):format(V(st.earned)))
	print(("  available now: %s   spent: %s   cap per character: %s"):format(V(st.available), V(st.spent), V(st.cap)))
	if st.why then
		print("  why something is missing: " .. st.why)
	end
	local rank = ns.ForeverTalentedRank and ns.ForeverTalentedRank() or nil
	print(("  Talented rank: %s"):format(V(rank)))
	print(("  \"Do this now\": %s — %s"):format(line and "|cff40c040shows a line|r" or "silent", tostring(why)))
	if type(ns.db) == "table" then
		ns.db.foreverLegacyProbe = {
			at = time and time() or 0,
			earned = st.earned, available = st.available, spent = st.spent, cap = st.cap,
			config = st.config, currency = st.currency, fromClient = st.fromClient, why = st.why,
			talented = rank, decision = line and "line" or "silent", reason = why,
		}
		print("  saved in SavedVariables (foreverLegacyProbe) — /reload writes it to disk.")
	end
end

--------------------------------------------------------------------------------
-- /mh repprobe (18 Nov 2026). Rob via sparring: "we beginnen nu en ik volg jullie advies" — part B of
-- docs/forever/ZOEKBALK_EN_VALUTA_2026-11-18.md: ONLY measure, no card yet. Which currency and reputation functions
-- does the Forever client have, and what do they answer for the five player currencies, the factions of the report
-- and the rep tokens in your bags? Everything goes to ns.db.foreverRepProbe (/reload writes it to disk). A function
-- that is missing, errors or gives a secret value is written down as such: an empty answer must not look like "0".
--------------------------------------------------------------------------------
-- Ids: DB2 CurrencyTypes / Faction / ItemSparse, Forever 1.60.1.70959 (mh-research 18 Nov). The four Steamwheedle ids
-- (21, 369, 470, 577) are the classic ones, NOT measured in Forever: this probe is what measures them.
local PROBE_CURRENCIES = { 1792, 3468, 3402, 3469, 515, 3473, 3485 }
local PROBE_FACTIONS = { 2765, 2747, 529, 576, 59, 609, 2740, 2787, 2758, 2586, 2587, 509, 510, 889, 890, 729, 730,
	2799, 2798, 21, 369, 470, 577, 2827, 92, 93, 2826, 2782, 2819, 909, 749, 270, 910, 2802, 2800 }
local PROBE_ITEMS = { 12840, 12841, 12843, 12844, 12846, 21377, 21383, 235256, 273050, 263439, 20404, 274030, 248549,
	269025 }
local PROBE_EVENTS = { "UPDATE_FACTION", "CURRENCY_DISPLAY_UPDATE", "CHAT_MSG_COMBAT_FACTION_CHANGE",
	"MAJOR_FACTION_RENOWN_LEVEL_CHANGED", "BAG_UPDATE_DELAYED" }

local function IsSecret(v)
	return issecretvalue ~= nil and issecretvalue(v) == true
end

--- A table's plain fields only (numbers, strings, booleans); "secret" for a secret value.
local function Flat(t)
	if IsSecret(t) then
		return "secret"
	end
	if type(t) ~= "table" then
		return t
	end
	local o = {}
	for k, v in pairs(t) do
		if IsSecret(v) then
			o[k] = "secret"
		elseif type(v) == "number" or type(v) == "string" or type(v) == "boolean" then
			o[k] = v
		end
	end
	return o
end

--- Call `fn` (a dotted name like "C_Reputation.GetFactionDataByID") safely: "missing", "error: …", or its answers.
local function Ask(name, ...)
	local fn = _G
	for part in name:gmatch("[^%.]+") do
		fn = type(fn) == "table" and fn[part] or nil
	end
	if type(fn) ~= "function" then
		return "missing"
	end
	local function pack(...)
		return select("#", ...), { ... }
	end
	local n, r = pack(pcall(fn, ...))
	if not r[1] then
		return "error: " .. tostring(r[2])
	end
	if n <= 2 then
		if r[2] == nil then
			return "nil" -- answered nothing: not the same as 0 or an empty list
		end
		return Flat(r[2])
	end
	local out = {}
	for i = 2, n do
		local v = r[i]
		out[i - 1] = v == nil and "nil" or Flat(v)
	end
	return out
end

function ns.ForeverRepProbeSlash()
	local P = { at = time and time() or 0, build = select(2, GetBuildInfo and GetBuildInfo() or "") }
	-- 1. Which functions exist.
	P.api = {}
	for _, name in ipairs({ "C_CurrencyInfo.GetCurrencyInfo", "C_CurrencyInfo.GetCurrencyListSize",
		"C_CurrencyInfo.GetCurrencyListInfo", "C_Reputation.GetFactionDataByID", "C_Reputation.GetNumFactions",
		"C_Reputation.GetFactionDataByIndex", "C_Reputation.GetWatchedFactionData", "GetFactionInfoByID",
		"GetNumFactions", "GetFactionInfo", "C_MajorFactions.GetCurrentRenownLevel", "C_Item.GetItemCount",
		"GetItemCount", "C_EventUtils.IsEventValid" }) do
		local fn = _G
		for part in name:gmatch("[^%.]+") do
			fn = type(fn) == "table" and fn[part] or nil
		end
		P.api[name] = type(fn) == "function"
	end
	-- 2. Currencies.
	P.currency = {}
	for _, id in ipairs(PROBE_CURRENCIES) do
		P.currency[id] = Ask("C_CurrencyInfo.GetCurrencyInfo", id)
	end
	P.currencyListSize = Ask("C_CurrencyInfo.GetCurrencyListSize")
	-- 3. Factions by id, new and old function.
	P.faction, P.factionOld = {}, {}
	for _, id in ipairs(PROBE_FACTIONS) do
		P.faction[id] = Ask("C_Reputation.GetFactionDataByID", id)
		P.factionOld[id] = Ask("GetFactionInfoByID", id)
	end
	P.renownPvp = Ask("C_MajorFactions.GetCurrentRenownLevel", 2800)
	-- 4. The reputation list as the character pane has it (first 120 rows).
	P.numFactions = Ask("C_Reputation.GetNumFactions")
	P.list = {}
	local n = type(P.numFactions) == "number" and math.min(P.numFactions, 120) or 0
	for i = 1, n do
		local d = Ask("C_Reputation.GetFactionDataByIndex", i)
		if type(d) == "table" then
			P.list[i] = { id = d.factionID, name = d.name, reaction = d.reaction, standing = d.currentStanding,
				header = d.isHeader, min = d.currentReactionThreshold, max = d.nextReactionThreshold }
		else
			P.list[i] = d
		end
	end
	-- 5. Rep tokens in the bags.
	P.items = {}
	for _, id in ipairs(PROBE_ITEMS) do
		P.items[id] = Ask("C_Item.GetItemCount", id, true)
	end
	-- 6. Events the client knows.
	P.events = {}
	for _, e in ipairs(PROBE_EVENTS) do
		P.events[e] = Ask("C_EventUtils.IsEventValid", e)
	end
	if type(ns.db) == "table" then
		ns.db.foreverRepProbe = P
	end
	-- What it says in chat: short, the rest is in the file.
	local function yes(k)
		return P.api[k] and "|cff40c040yes|r" or "|cffff5555no|r"
	end
	print(PREFIX .. "currencies and reputations — what the client lets us read:")
	print(("  currency info: %s   reputation by id: %s (old: %s)   reputation list: %s   item count: %s"):format(
		yes("C_CurrencyInfo.GetCurrencyInfo"), yes("C_Reputation.GetFactionDataByID"), yes("GetFactionInfoByID"),
		yes("C_Reputation.GetFactionDataByIndex"), yes("C_Item.GetItemCount")))
	for _, id in ipairs({ 1792, 3468, 3402, 3469, 515 }) do
		local c = P.currency[id]
		if type(c) == "table" then
			print(("  %s: %s / %s"):format(tostring(c.name or id), tostring(c.quantity), tostring(c.maxQuantity)))
		else
			print(("  currency %d: %s"):format(id, tostring(c)))
		end
	end
	local readable = 0
	for _, id in ipairs(PROBE_FACTIONS) do
		if type(P.faction[id]) == "table" and P.faction[id].name then
			readable = readable + 1
		end
	end
	print(("  factions readable by id: %d of %d; reputation list rows: %s"):format(readable, #PROBE_FACTIONS,
		tostring(P.numFactions)))
	print("  saved in SavedVariables (foreverRepProbe) — /reload writes it to disk.")
end
