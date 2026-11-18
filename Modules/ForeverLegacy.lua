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

--------------------------------------------------------------------------------
-- Reputations & currencies card (18 Nov 2026). Rob via sparring: "1 eerst a daarna b / 2 Nu , voor de rares" → first
-- this card. The functions are GEMETEN in Rob's /mh repprobe (Forever, Horde character, 18 Nov): C_CurrencyInfo.
-- GetCurrencyInfo, C_Reputation.GetFactionDataByID / GetNumFactions / GetFactionDataByIndex work; the old globals are
-- missing. Names come from the client (its language). An answer we cannot read is said, never shown as 0.
--------------------------------------------------------------------------------
-- The five player currencies (DB2 CurrencyTypes Forever 70959; names/max GEMETEN in the probe: Real max 165).
local REP_CURRENCIES = { 1792, 3468, 3402, 3469, 515 }

-- The groups that matter for a Forever player (mh-research 18 Nov, docs/forever/ZOEKBALK_EN_VALUTA_2026-11-18.md).
-- side: only that side can earn it (A/H from the DB2 race masks, AFGELEID; matches the probe: the other side's
-- groups read nil or Hated). r = reaction index of the reward (5 Friendly, 6 Honored, 7 Revered, 8 Exalted).
-- Source per row in the comment; everything except the Seed Pod is from player guides (NOT measured in the game).
local REP_GROUPS = {
	-- ItemSparse 274379 RequiredLevel 60, MinFactionID 2765, MinReputation 6 (GEMETEN); quests: ConquestCapped 15 Nov,
	-- warcraftmaps 16 Nov; how to reach Revered: unknown.
	{ id = 2765, how = "FREP_HOW_HYJAL", rewards = { { 7, "FREP_R_HYJAL_7", measured = true } } },
	-- ConquestCapped 14 Nov.
	{ id = 2747, how = "FREP_HOW_BARKSKIN", rewards = { { 6, "FREP_R_BARKSKIN_6" }, { 7, "FREP_R_BARKSKIN_7" },
		{ 8, "FREP_R_BARKSKIN_8" } } },
	-- ConquestCapped 14 Nov (+ hotfix 11 Nov); Manna Biscuits at Friendly: enUS FCQ_OBJ_PA_HORSEFEED.
	{ id = 529, how = "FREP_HOW_ARGENT", rewards = { { 5, "FREP_R_ARGENT_5" }, { 6, "FREP_R_ARGENT_6" },
		{ 7, "FREP_R_ARGENT_7" } } },
	-- ConquestCapped 16 Nov.
	{ id = 576, how = "FREP_HOW_TIMBERMAW", rewards = { { 5, "FREP_R_TIMBERMAW_5" }, { 8, "FREP_R_TIMBERMAW_8" } } },
	-- ConquestCapped 14 Nov; reward list foreverdb.net (client data).
	{ id = 59, how = "FREP_HOW_THORIUM", rewards = { { 5, "FREP_R_THORIUM_5" } } },
	-- ConquestCapped 15 Nov.
	{ id = 609, how = "FREP_HOW_CENARION", rewards = { { 5, "FREP_R_CENARION_5" } } },
	-- LFCarry 14 Nov (quotes Blizzard's dev notes of 16 Oct: Horde no longer gains Kirin Tor).
	{ id = 2740, side = "Alliance", how = "FREP_HOW_KIRINTOR", rewards = { { 5, "FREP_R_AZURE_5" },
		{ 8, "FREP_R_TABARD_8" } } },
	-- foreverdb.net, ConquestCapped 17 Nov.
	{ id = 2787, side = "Horde", how = "FREP_HOW_EARTHEN", rewards = { { 5, "FREP_R_CLOUDY_5" } } },
	-- ConquestCapped 14 Nov; foreverdb.net.
	{ id = 2758, how = "FREP_HOW_NIGHTCLAW", rewards = { { 7, "FREP_R_NIGHTCLAW_7" }, { 8, "FREP_R_NIGHTCLAW_8" } } },
	-- wow-professions.com (undated), SenseOS 15 Nov.
	{ id = 2586, side = "Alliance", how = "FREP_HOW_MERCHANT", rewards = { { 5, "FREP_R_MERCHANT_5" },
		{ 8, "FREP_R_TABARD_8" } } },
	{ id = 2587, side = "Horde", how = "FREP_HOW_MERCHANT", rewards = { { 5, "FREP_R_MERCHANT_5" },
		{ 8, "FREP_R_TABARD_8" } } },
	-- Battleground groups: Exalted with each = 1 Legacy Point (ForeverChanges 7 Oct, EpicCarry 16 Nov; achievements
	-- 62046-62049 "Master of ..." GEMETEN in DB2).
	{ id = 509, side = "Alliance", how = "FREP_HOW_BG", rewards = { { 8, "FREP_R_BG_8" } } },
	{ id = 510, side = "Horde", how = "FREP_HOW_BG", rewards = { { 8, "FREP_R_BG_8" } } },
	{ id = 890, side = "Alliance", how = "FREP_HOW_BG", rewards = { { 8, "FREP_R_BG_8" } } },
	{ id = 889, side = "Horde", how = "FREP_HOW_BG", rewards = { { 8, "FREP_R_BG_8" } } },
	{ id = 730, side = "Alliance", how = "FREP_HOW_BG", rewards = { { 8, "FREP_R_BG_8" } } },
	{ id = 729, side = "Horde", how = "FREP_HOW_BG", rewards = { { 8, "FREP_R_BG_8" } } },
	{ id = 2799, side = "Alliance", how = "FREP_HOW_BG", rewards = { { 8, "FREP_R_BG_8" } } },
	{ id = 2798, side = "Horde", how = "FREP_HOW_BG", rewards = { { 8, "FREP_R_BG_8" } } },
	-- Goblin towns: ConquestCapped 16 Nov; foreverdb.net.
	{ id = 21, how = "FREP_HOW_TOWN", rewards = { { 5, "FREP_R_TOWN_5" }, { 7, "FREP_R_TOWN_7" } } },
	{ id = 369, how = "FREP_HOW_TOWN", rewards = { { 5, "FREP_R_TOWN_5" }, { 7, "FREP_R_TOWN_7" } } },
	{ id = 470, how = "FREP_HOW_TOWN", rewards = { { 5, "FREP_R_TOWN_5" }, { 7, "FREP_R_TOWN_7" } } },
	{ id = 577, how = "FREP_HOW_TOWN", rewards = { { 5, "FREP_R_TOWN_5" }, { 7, "FREP_R_TOWN_7" } } },
	{ id = 2827, how = "FREP_HOW_TOWN", rewards = { { 5, "FREP_R_TOWN_5" }, { 7, "FREP_R_TOWN_7" } } },
}

local REP_RANK_EN = { "Hated", "Hostile", "Unfriendly", "Neutral", "Friendly", "Honored", "Revered", "Exalted" }

--- The client's own word for a reputation rank (FACTION_STANDING_LABELn), English when the client has none.
local function RankName(r)
	r = tonumber(r)
	if not r then
		return nil
	end
	local v = rawget(_G, "FACTION_STANDING_LABEL" .. r)
	return (type(v) == "string" and v ~= "") and v or REP_RANK_EN[r]
end
ns.ForeverRankName = RankName

local function MySide()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" or f == "Horde") and f or nil
end

local function Faction(id)
	if not (C_Reputation and C_Reputation.GetFactionDataByID) then
		return nil, "missing"
	end
	local ok, d = pcall(C_Reputation.GetFactionDataByID, id)
	if not ok or type(d) ~= "table" or IsSecret(d.name) or type(d.name) ~= "string" then
		return nil, ok and "nil" or "error"
	end
	for _, k in ipairs({ "reaction", "currentStanding", "currentReactionThreshold", "nextReactionThreshold" }) do
		if IsSecret(d[k]) then
			return nil, "secret"
		end
	end
	return d
end

--- The five currencies: { id, name, qty, max } (max nil = no cap); `unreadable` = true when the client did not answer.
function ns.ForeverCurrencyViews()
	local out = {}
	for _, id in ipairs(REP_CURRENCIES) do
		local e = { id = id }
		local ok, c = false, nil
		if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
			ok, c = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
		end
		if ok and type(c) == "table" and type(c.name) == "string" and not IsSecret(c.name)
			and type(c.quantity) == "number" and not IsSecret(c.quantity) then
			e.name, e.qty = c.name, c.quantity
			local m = c.maxQuantity
			if type(m) == "number" and not IsSecret(m) and m > 0 then
				e.max = m
			end
			e.icon = c.iconFileID
		else
			e.unreadable = true
		end
		out[#out + 1] = e
	end
	return out
end

--- The groups for this character's side: { id, name, rank, r, have, need, next, how, measured } plus `unread` (ids the
--- client did not answer for), and `others` = the rest of the character's own reputation list (name + rank).
function ns.ForeverRepViews()
	local side = MySide()
	local out, unread, seen = {}, {}, {}
	for _, g in ipairs(REP_GROUPS) do
		if not g.side or g.side == side then
			local d = Faction(g.id)
			if d then
				seen[g.id] = true
				local e = { id = g.id, name = d.name, r = d.reaction, rank = RankName(d.reaction), how = ns:L(g.how) }
				local lo, hi, cur = d.currentReactionThreshold, d.nextReactionThreshold, d.currentStanding
				if type(lo) == "number" and type(hi) == "number" and type(cur) == "number" and hi > lo then
					e.have, e.need = cur - lo, hi - lo
				end
				for _, rw in ipairs(g.rewards) do
					if type(d.reaction) == "number" and rw[1] > d.reaction then
						e.next = ns:L(rw[2])
						e.nextRank = RankName(rw[1])
						e.measured = rw.measured
						break
					end
				end
				out[#out + 1] = e
			else
				unread[#unread + 1] = g.id
			end
		end
	end
	-- What the character's own reputation pane lists besides these (home cities etc.).
	local others = {}
	if C_Reputation and C_Reputation.GetNumFactions and C_Reputation.GetFactionDataByIndex then
		local okN, n = pcall(C_Reputation.GetNumFactions)
		n = okN and type(n) == "number" and not IsSecret(n) and math.min(n, 120) or 0
		for i = 1, n do
			local ok, d = pcall(C_Reputation.GetFactionDataByIndex, i)
			if ok and type(d) == "table" and not d.isHeader and type(d.factionID) == "number" and not seen[d.factionID]
				and type(d.name) == "string" and not IsSecret(d.name) and not IsSecret(d.reaction) then
				seen[d.factionID] = true
				others[#others + 1] = { id = d.factionID, name = d.name, rank = RankName(d.reaction) }
			end
		end
	end
	return out, unread, others
end

-- Refill the page while it is open when rep or currencies change (events GEMETEN valid in the probe).
do
	local ev = CreateFrame("Frame")
	for _, e in ipairs({ "UPDATE_FACTION", "CURRENCY_DISPLAY_UPDATE" }) do
		pcall(ev.RegisterEvent, ev, e)
	end
	ev:SetScript("OnEvent", function()
		if ns.ForeverOverviewRefreshPage then
			ns.ForeverOverviewRefreshPage("rep")
		end
	end)
end

--- Lines for This week (ForeverWeek.lua): only what can be measured. "Honor almost full" from 90% of the cap. The
--- Real ("N bosses left today") is NOT measurable (no client answer for which bosses you killed today): left out.
function ns.ForeverRepWeekLines()
	local lines = {}
	for _, c in ipairs(ns.ForeverCurrencyViews()) do
		if c.id == 1792 and c.qty and c.max and c.qty >= c.max * 0.9 then
			lines[#lines + 1] = { text = ns:L("FREP_WEEK_HONOR_FMT"):format(c.qty, c.max, c.name), tone = "warn" }
		end
	end
	return lines
end
