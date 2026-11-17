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
