--[[
	Midnight Helper — Account snapshot (dedicated main tab + panel).

	Snapshots: MidnightHelperDB.charCurrencies[guid]
]]

local addonName, ns = ...

local COFFER_KEY = 3028
local COFFER_SHARDS = 3310
local UNDERCOIN = 2803
local UNTAINTED_MANA_CRYSTALS = 3356
--- Catalyst charges. GEMETEN 25 aug 2026 in Robs client: dit is een PER-CHARACTER
--- currency met een maximum van 8, niet account-breed zoals ik eerst aannam. Zijn
--- tooltip toonde "Total Maximum: 1/8" plus zeven characters met elk 1 -- dus zeven
--- omzettingen die je alleen ziet door zeven keer in te loggen. Precies waar dit
--- overzicht voor bestaat.
local VENOMBLIGHT_MANAFLUX = 3465
local MANAFLUX_CAP = 8

--- Layout, Spec 38 option A (10 Sep 2026). From the row's right edge inwards: crystals, Undercoins,
--- Week, Shards, Keys - then the Vault column, and the name takes what is left. Shards used to be one
--- cell "201 (354/600)" that did not fit its 62 px; wallet and week are two columns now. The two
--- currencies were one cell "2121 / 0" under a header ("Under / Mana") that four languages translated
--- as a preposition; they are two columns headed by Blizzard's own currency icons.
local PAD_L = 4
local PAD_R = 6
local COL_W_KEYS = 40
local COL_W_SHARDS = 56

local function GetColWShards()
	local loc = ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode()
	if loc == "deDE" or loc == "frFR" then
		return 64
	end
	return COL_W_SHARDS
end
local COL_W_WEEK = 76
local COL_W_COIN = 52
local COL_W_CRYSTAL = 44
local COL_W_VAULT = 72
local NUM_GAP = 4

--- The numeric columns in the order they sit, from the right edge inwards.
local NUM_COL_ORDER = { "crystal", "coin", "week", "shards", "keys" }
local function NumColW(key)
	if key == "shards" then
		return GetColWShards()
	elseif key == "keys" then
		return COL_W_KEYS
	elseif key == "week" then
		return COL_W_WEEK
	elseif key == "coin" then
		return COL_W_COIN
	end
	return COL_W_CRYSTAL
end
local ROW_ACTION_W = 18
local ROW_ACTION_GAP = 4
--- Spec 38 §3.4, 10 Sep 2026: 17 -> 20. At 17 px a cell that wrapped to two lines stuck out above and
--- below its row, which is the "lines running into each other" on Rob's screenshot. The cells no
--- longer wrap (see AnchorNumericCells), and the extra 3 px is breathing room.
local ROW_H = 20
local HEADER_ROW_H = 17

--- Count and cut by CHARACTER, not by byte (Spec 38 §3.4). `#s` counts bytes, so a name with an
--- umlaut or accent - and every " · " between professions, a two-byte dot - was measured too long
--- and could be cut in the middle of a character. A UTF-8 character starts at any byte that is not
--- a continuation byte (\128-\191).
local function Utf8Len(s)
	if strlenutf8 then
		return strlenutf8(s)
	end
	local _, n = s:gsub("[^\128-\191]", "")
	return n
end

local function Utf8Head(s, n)
	local count = 0
	for pos in s:gmatch("()[^\128-\191]") do
		count = count + 1
		if count > n then
			return s:sub(1, pos - 1)
		end
	end
	return s
end

-- Geschaalde rijhoogtes: groeien mee met de content-tekstschaal zodat grotere
-- letters niet over elkaar vallen. Bij schaal 1.0 leveren ze exact ROW_H /
-- HEADER_ROW_H op (×1.0 verandert niets). Rij-hoogte EN Y-stap gebruiken
-- dezelfde functie, dus ze blijven gesynchroniseerd.
local function ContentScale()
	return (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
end
local function RowH()
	return ROW_H * ContentScale()
end
local function HeaderRowH()
	return HEADER_ROW_H * ContentScale()
end

local accountPanelMounted = false
local ui = {}

local pendingSaveTimer

local function RowActionOffset()
	return ROW_ACTION_W + ROW_ACTION_GAP
end

local function TotalNumericBlockWidth()
	local w = PAD_R
	for i, key in ipairs(NUM_COL_ORDER) do
		w = w + NumColW(key) + (i > 1 and NUM_GAP or 0)
	end
	return w
end

-- Example-reward item level for a vault activity. nil when the slot has no
-- example reward yet or the item isn't in the client cache — never guessed;
-- the next snapshot save fills it in once the cache warms up.
local function GetActivityRewardIlvl(activityId)
	if not (activityId and C_WeeklyRewards and C_WeeklyRewards.GetExampleRewardItemHyperlinks) then
		return nil
	end
	local ok, link = pcall(C_WeeklyRewards.GetExampleRewardItemHyperlinks, activityId)
	if not ok or type(link) ~= "string" or link == "" then
		return nil
	end
	-- Same API the Delves-tab vault block uses (C_Item first, legacy fallback).
	local getIlvl = (C_Item and C_Item.GetDetailedItemLevelInfo) or GetDetailedItemLevelInfo
	if getIlvl then
		local okL, ilvl = pcall(getIlvl, link)
		if okL and tonumber(ilvl) and tonumber(ilvl) > 0 then
			return math.floor(tonumber(ilvl))
		end
	end
	return nil
end

local function BuildVaultCategorySnapshot(activities, wantedType)
	local rows = {}
	local maxProgress = 0
	for _, a in ipairs(activities) do
		if type(a) == "table" and tonumber(a.type) == wantedType and tonumber(a.threshold) then
			rows[#rows + 1] = a
			local p = math.floor(tonumber(a.progress) or 0)
			if p > maxProgress then
				maxProgress = p
			end
		end
	end

	if #rows == 0 then
		return { unlocked = 0, total = 0, progress = 0, nextThreshold = 0, available = false, slots = {} }
	end

	table.sort(rows, function(a, b)
		return (tonumber(a.threshold) or 0) < (tonumber(b.threshold) or 0)
	end)

	local unlocked = 0
	local nextThreshold = tonumber(rows[1].threshold) or 0
	for _, a in ipairs(rows) do
		local th = tonumber(a.threshold) or 0
		if maxProgress >= th then
			unlocked = unlocked + 1
		elseif th > 0 then
			nextThreshold = th
			break
		end
	end

	-- Per-slot detail so alts can see WHAT is locked in, not just how many:
	-- t = threshold, p = progress, l = registered activity level (delve tier /
	-- keystone level), i = example-reward ilvl (unlocked slots only).
	local slots = {}
	for _, a in ipairs(rows) do
		local th = tonumber(a.threshold) or 0
		local p = math.floor(tonumber(a.progress) or 0)
		slots[#slots + 1] = {
			t = th,
			p = p,
			l = math.floor(tonumber(a.level) or 0),
			i = (p >= th) and GetActivityRewardIlvl(a.id) or nil,
		}
	end

	return {
		unlocked = unlocked,
		total = #rows,
		progress = maxProgress,
		nextThreshold = nextThreshold,
		available = true,
		slots = slots,
	}
end

local function GetVaultSnapshot()
	if not C_WeeklyRewards or not C_WeeklyRewards.GetActivities then
		return {
			world = { unlocked = 0, total = 0, progress = 0, nextThreshold = 0, available = false },
			dungeons = { unlocked = 0, total = 0, progress = 0, nextThreshold = 0, available = false },
			raids = { unlocked = 0, total = 0, progress = 0, nextThreshold = 0, available = false },
			anyAvailable = false,
			dataLoaded = false,
		}
	end
	local ok, acts = pcall(C_WeeklyRewards.GetActivities)
	if not ok or type(acts) ~= "table" then
		return {
			world = { unlocked = 0, total = 0, progress = 0, nextThreshold = 0, available = false },
			dungeons = { unlocked = 0, total = 0, progress = 0, nextThreshold = 0, available = false },
			raids = { unlocked = 0, total = 0, progress = 0, nextThreshold = 0, available = false },
			anyAvailable = false,
			dataLoaded = false,
		}
	end

	local raids = BuildVaultCategorySnapshot(acts, 3)
	local dungeons = BuildVaultCategorySnapshot(acts, 1)
	local world = BuildVaultCategorySnapshot(acts, 6)
	local hasAvailableRewards = false
	if C_WeeklyRewards and C_WeeklyRewards.HasAvailableRewards then
		local okAvail, avail = pcall(C_WeeklyRewards.HasAvailableRewards)
		if okAvail and avail then
			hasAvailableRewards = true
		end
	end
	local anyAvailable = raids.available or dungeons.available or world.available
	return {
		world = world,
		dungeons = dungeons,
		raids = raids,
		anyAvailable = anyAvailable,
		hasAvailableRewards = hasAvailableRewards,
		-- False while the server hasn't pushed weekly rewards data yet (empty
		-- GetActivities right after login). Used to avoid clobbering a good
		-- saved snapshot with zeros.
		dataLoaded = #acts > 0,
	}
end

-- Shared so the vault banner counts filled slots with exactly this logic rather
-- than a second copy of it. Runtime call only: this file loads after
-- VaultAdvisor.lua.
ns.GetVaultSnapshot = GetVaultSnapshot

local function IsResetDayNow()
	-- Region-correct: "reset day" = first 24h of the current weekly cycle,
	-- derived from the live API (US=Tue, EU=Wed, at the actual server reset).
	if C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset then
		local ok, secs = pcall(C_DateAndTime.GetSecondsUntilWeeklyReset)
		if ok and type(secs) == "number" and secs > 0 then
			return secs > 6 * 86400
		end
	end
	-- Fallback only (API unavailable): EU-style local Wednesday.
	local now = date("*t")
	return now and tonumber(now.wday) == 4 -- 1=Sunday, 4=Wednesday
end

local function GetLocalResetAnchorTs()
	-- Single source of truth: DelveWeeklyTrackers derives the anchor from
	-- C_DateAndTime.GetSecondsUntilWeeklyReset (region/timezone-correct).
	if ns.MhGetWeeklyResetAnchorTs then
		return ns.MhGetWeeklyResetAnchorTs()
	end
	-- Fallback only (module not loaded): EU-style local Wednesday 08:00.
	local now = time()
	local t = date("*t", now)
	if not t then
		return now
	end
	local daysSinceReset = ((tonumber(t.wday) or 1) - 4) % 7 -- Wednesday anchor
	local resetDay = {
		year = t.year,
		month = t.month,
		day = t.day - daysSinceReset,
		hour = 8,
		min = 0,
		sec = 0,
	}
	local anchor = time(resetDay)
	if anchor and now < anchor then
		anchor = anchor - 7 * 24 * 60 * 60
	end
	return anchor or now
end

local function FormatRelativeTime(ts)
	local v = tonumber(ts) or 0
	if v <= 0 then
		return ns:L("ALT_UPDATED_UNKNOWN")
	end
	local d = math.max(0, math.floor(time() - v))
	if d < 60 then
		return ns:L("ALT_UPDATED_SECONDS"):format(d)
	elseif d < 3600 then
		return ns:L("ALT_UPDATED_MINUTES"):format(math.floor(d / 60))
	elseif d < 86400 then
		return ns:L("ALT_UPDATED_HOURS"):format(math.floor(d / 3600))
	end
	return ns:L("ALT_UPDATED_DAYS"):format(math.floor(d / 86400))
end

--------------------------------------------------------------------------------
local function GetPlayerItemLevel()
	if GetAverageItemLevel then
		local ok, overall, equipped = pcall(GetAverageItemLevel)
		if ok then
			local v = tonumber(equipped) or tonumber(overall) or 0
			if v > 0 then
				return math.floor(v + 0.5)
			end
		end
	end
	return 0
end

--- Spec 38 §1e / option A: the two currency headers show Blizzard's own icon, and the tooltip title
--- is the currency's name as the client gives it - right in every language by construction. The
--- old header "Under / Mana" was translated as a preposition in four packs ("Unter", "Sous",
--- "Bajo", "Menos"); Under was short for Undercoins.
local function CurrencyIconAndName(id)
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		return nil, nil
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
	if not ok or type(info) ~= "table" then
		return nil, nil
	end
	return info.iconFileID, info.name
end

local function GetCurrencyQty(id)
	local cid = tonumber(id)
	if not cid or not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then
		return 0
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, cid)
	if ok and info then
		local q = info.quantity
		if q ~= nil then
			return tonumber(q) or 0
		end
	end
	return 0
end

-- Wallet total, weekly earned toward cap, weekly max (Blizzard resets weekly on Wednesday).
local function GetShardQuantityAndMax()
	if not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then
		return 0, 0, 600
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, COFFER_SHARDS)
	if not ok or not info or type(info) ~= "table" then
		return 0, 0, 600
	end
	local qty = math.floor(tonumber(info.quantity) or 0)
	local earned = math.floor(tonumber(info.quantityEarnedThisWeek) or 0)
	local maxQ = tonumber(info.maxQuantity)
	if not maxQ or maxQ <= 0 then
		maxQ = tonumber(info.maxWeeklyQuantity)
	end
	if not maxQ or maxQ <= 0 then
		maxQ = 600
	end
	return qty, earned, math.floor(maxQ)
end

local function GetEffectiveShardsWeekly(weekly, snapshotTs)
	local w = math.floor(tonumber(weekly) or 0)
	local ts = tonumber(snapshotTs) or 0
	if ts > 0 and ts < GetLocalResetAnchorTs() then
		return 0, true
	end
	return w, false
end

local function GetPlayerProfessionsText()
	if not GetProfessions or not GetProfessionInfo then
		return ""
	end
	local parts = {}
	local p1, p2, archaeology, fishing, cooking, firstAid = GetProfessions()
	for _, slot in ipairs({ p1, p2, archaeology, fishing, cooking, firstAid }) do
		if slot then
			local ok, name = pcall(function()
				return (select(1, GetProfessionInfo(slot)))
			end)
			if ok and type(name) == "string" and name ~= "" then
				parts[#parts + 1] = name
			end
		end
	end
	local s = table.concat(parts, " · ")
	return s
end

local function GetShortProfessionsText(fullText)
	local s = tostring(fullText or "")
	-- Per character, not per byte (Spec 38 §3.4): the " · " between professions is a two-byte dot.
	if Utf8Len(s) > 44 then
		s = Utf8Head(s, 42) .. "…"
	end
	return s
end

local function SaveCurrentSnapshot()
	local db = ns.db
	if not db then
		return
	end
	if type(db.charCurrencies) ~= "table" then
		db.charCurrencies = {}
	end

	local guid = UnitGUID("player")
	if not guid then
		return
	end

	local nm, realm = UnitFullName("player")
	if type(nm) ~= "string" or nm == "" then
		nm = UnitName("player")
	end
	if type(nm) ~= "string" or nm == "" then
		nm = "?"
	end
	realm = realm or (GetRealmName and GetRealmName()) or ""

	local professionsFull = GetPlayerProfessionsText()
	local profAbund, profDundun, profMoxie = 0, 0, ""
	if ns.GetProfessionWeeklySnapshot then
		profAbund, profDundun, profMoxie = ns.GetProfessionWeeklySnapshot()
	end
	local shardQty, shardWeekly, shardMax = GetShardQuantityAndMax()
	local dcCompleted, dcBanked, dcInProgress, dcTotal = 0, 0, 0, 0
	if ns.GetDelverCallSnapshotCounts then
		dcCompleted, dcBanked, dcInProgress, dcTotal = ns.GetDelverCallSnapshotCounts()
	end
	local troveStatus, troveInBag = "available", 0
	if ns.GetTrovehunterSnapshotCounts then
		troveStatus, troveInBag = ns.GetTrovehunterSnapshotCounts()
	end
	local gildedProgress, gildedMax = 0, 4
	if ns.GetGildedStashSnapshotCounts then
		gildedProgress, gildedMax = ns.GetGildedStashSnapshotCounts()
	end
	local saCompleted, saActive, saMax = 0, 0, 3
	if ns.GetSpecialAssignmentSnapshotCounts then
		saCompleted, saActive, saMax = ns.GetSpecialAssignmentSnapshotCounts()
	end
	-- Keep a reference to the previous record: if weekly rewards data is not
	-- loaded yet (right after login) we restore its vault fields below instead
	-- of persisting the zeroed defaults.
	local prev = db.charCurrencies[guid]
	db.charCurrencies[guid] = {
		name = nm,
		realm = realm,
		keys = GetCurrencyQty(COFFER_KEY),
		shards = shardQty,
		shardsWeekly = shardWeekly,
		shardsWeeklyMax = shardMax,
		undercoin = GetCurrencyQty(UNDERCOIN),
		manaCrystals = GetCurrencyQty(UNTAINTED_MANA_CRYSTALS),
		manaflux = GetCurrencyQty(VENOMBLIGHT_MANAFLUX),
		level = UnitLevel("player") or 0,
		ilvl = GetPlayerItemLevel(),
		vaultUnlocked = 0,
		vaultTotal = 0,
		vaultProgress = 0,
		vaultNextThreshold = 0,
		vaultAvailable = 0,
		vaultWorldUnlocked = 0,
		vaultWorldTotal = 0,
		vaultWorldProgress = 0,
		vaultWorldNextThreshold = 0,
		vaultWorldAvailable = 0,
		vaultDungeonUnlocked = 0,
		vaultDungeonTotal = 0,
		vaultDungeonProgress = 0,
		vaultDungeonNextThreshold = 0,
		vaultDungeonAvailable = 0,
		vaultRaidUnlocked = 0,
		vaultRaidTotal = 0,
		vaultRaidProgress = 0,
		vaultRaidNextThreshold = 0,
		vaultRaidAvailable = 0,
		vaultHasAvailableRewards = 0,
		professions = GetShortProfessionsText(professionsFull),
		professionsFull = professionsFull,
		profAbundance = profAbund,
		profDundun = profDundun,
		profMoxie = profMoxie,
		delverCompleted = dcCompleted,
		delverBanked = dcBanked,
		delverInProgress = dcInProgress,
		delverTotal = dcTotal,
		troveStatus = troveStatus,
		troveInBag = troveInBag,
		gildedProgress = gildedProgress,
		gildedMax = gildedMax,
		saCompleted = saCompleted,
		saActive = saActive,
		saMax = saMax,
		-- Spec 39 (11 Sep 2026): every currency the Currencies tab lists, keyed by id, with the
		-- amount earned this week and in total. Added, never renamed; old records have no `cur`.
		cur = (ns.MH_CurrencySnapshotExtra and ns.MH_CurrencySnapshotExtra()) or (prev and prev.cur) or nil,
		ts = time(),
	}
	local snap = GetVaultSnapshot()
	-- Right after PLAYER_LOGIN the weekly rewards data is often not loaded yet
	-- (GetActivities returns an empty table). Writing the snapshot then would
	-- clobber last session's good vault values with zeros. The table above was
	-- just replaced with zeroed defaults, so restore the vault fields from the
	-- previous record (prev, captured before the replace) and keep its ts so
	-- staleness logic doesn't treat the carried-over vault data as fresh.
	-- WEEKLY_REWARDS_UPDATE -> ScheduleSave() rewrites everything shortly after.
	local prevHadVaultData = prev and (
		(tonumber(prev.vaultWorldTotal) or 0) > 0
		or (tonumber(prev.vaultDungeonTotal) or 0) > 0
		or (tonumber(prev.vaultRaidTotal) or 0) > 0
	)
	if not snap.dataLoaded and prevHadVaultData then
		local cur = db.charCurrencies[guid]
		local vaultFields = {
			"vaultUnlocked", "vaultTotal", "vaultProgress", "vaultNextThreshold", "vaultAvailable",
			"vaultWorldUnlocked", "vaultWorldTotal", "vaultWorldProgress", "vaultWorldNextThreshold", "vaultWorldAvailable",
			"vaultDungeonUnlocked", "vaultDungeonTotal", "vaultDungeonProgress", "vaultDungeonNextThreshold", "vaultDungeonAvailable",
			"vaultRaidUnlocked", "vaultRaidTotal", "vaultRaidProgress", "vaultRaidNextThreshold", "vaultRaidAvailable",
			"vaultHasAvailableRewards",
			"vaultWorldSlots", "vaultDungeonSlots", "vaultRaidSlots",
		}
		for _, k in ipairs(vaultFields) do
			cur[k] = prev[k]
		end
		cur.ts = prev.ts
		return
	end
	db.charCurrencies[guid].vaultWorldUnlocked = snap.world.unlocked
	db.charCurrencies[guid].vaultWorldTotal = snap.world.total
	db.charCurrencies[guid].vaultWorldProgress = snap.world.progress
	db.charCurrencies[guid].vaultWorldNextThreshold = snap.world.nextThreshold
	db.charCurrencies[guid].vaultWorldAvailable = snap.world.available and 1 or 0
	db.charCurrencies[guid].vaultDungeonUnlocked = snap.dungeons.unlocked
	db.charCurrencies[guid].vaultDungeonTotal = snap.dungeons.total
	db.charCurrencies[guid].vaultDungeonProgress = snap.dungeons.progress
	db.charCurrencies[guid].vaultDungeonNextThreshold = snap.dungeons.nextThreshold
	db.charCurrencies[guid].vaultDungeonAvailable = snap.dungeons.available and 1 or 0
	db.charCurrencies[guid].vaultRaidUnlocked = snap.raids.unlocked
	db.charCurrencies[guid].vaultRaidTotal = snap.raids.total
	db.charCurrencies[guid].vaultRaidProgress = snap.raids.progress
	db.charCurrencies[guid].vaultRaidNextThreshold = snap.raids.nextThreshold
	db.charCurrencies[guid].vaultRaidAvailable = snap.raids.available and 1 or 0
	db.charCurrencies[guid].vaultHasAvailableRewards = snap.hasAvailableRewards and 1 or 0
	db.charCurrencies[guid].vaultWorldSlots = snap.world.slots
	db.charCurrencies[guid].vaultDungeonSlots = snap.dungeons.slots
	db.charCurrencies[guid].vaultRaidSlots = snap.raids.slots
	db.charCurrencies[guid].vaultUnlocked = snap.world.unlocked
	db.charCurrencies[guid].vaultTotal = snap.world.total
	db.charCurrencies[guid].vaultProgress = snap.world.progress
	db.charCurrencies[guid].vaultNextThreshold = snap.world.nextThreshold
	db.charCurrencies[guid].vaultAvailable = snap.anyAvailable and 1 or 0
end

local function ScheduleSave()
	if pendingSaveTimer then
		return
	end
	pendingSaveTimer = true
	if C_Timer and C_Timer.After then
		C_Timer.After(1.2, function()
			pendingSaveTimer = false
			SaveCurrentSnapshot()
			if ns._mhAltOverviewRefreshRows then
				ns:_mhAltOverviewRefreshRows()
			end
		end)
	else
		pendingSaveTimer = false
		SaveCurrentSnapshot()
		if ns._mhAltOverviewRefreshRows then
			ns:_mhAltOverviewRefreshRows()
		end
	end
end

local function FormatCharLabel(name, realm)
	local nm = name
	if type(nm) ~= "string" or nm == "" or nm == "?" then
		return ns:L("ALT_OVERVIEW_UNKNOWN")
	end
	local r = realm
	if type(r) ~= "string" then
		r = ""
	end
	local s = nm .. (r ~= "" and ("-" .. r) or "")
	-- Per character (Spec 38 §3.4): an accented name or realm counted two bytes per letter.
	if Utf8Len(s) > 26 then
		return nm .. "…"
	end
	return s
end

local ACCOUNT_SNAPSHOT_SORT_CYCLE = { "name", "level", "keys", "shards", "undercoin", "updated" }

local function GetAccountSnapshotSettings()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return {
			sortBy = "name",
			sortDesc = false,
			filterStaleOnly = false,
			filterHasKeysOnly = false,
			filterShardCapOnly = false,
			filterDundunIncompleteOnly = false,
		}
	end
	if type(uiDb.accountSnapshot) ~= "table" then
		uiDb.accountSnapshot = {
			sortBy = "name",
			sortDesc = false,
			filterStaleOnly = false,
			filterHasKeysOnly = false,
			filterShardCapOnly = false,
			filterDundunIncompleteOnly = false,
		}
	end
	local s = uiDb.accountSnapshot
	if s.filterShardCapOnly == nil then
		s.filterShardCapOnly = false
	end
	if s.filterDundunIncompleteOnly == nil then
		s.filterDundunIncompleteOnly = false
	end
	return s
end

local DUNDUN_WEEKLY_CAP = 8

local WEEKLY_TABLE_FILTER_FIELDS = {
	stale = "filterStaleOnly",
	keys = "filterHasKeysOnly",
	shards = "filterShardCapOnly",
	dundun = "filterDundunIncompleteOnly",
}

local EntryHasProfessionSnapshot
local EntryShardsBelowCap
local EntryDundunIncomplete

local function SnapshotEntryIsStale(e)
	local _, shardsWeeklyStale = GetEffectiveShardsWeekly(e.shardsWeekly, e.ts)
	local staleSinceReset = (tonumber(e.ts) or 0) > 0 and (tonumber(e.ts) or 0) < GetLocalResetAnchorTs()
	return shardsWeeklyStale or staleSinceReset
end

EntryHasProfessionSnapshot = function(e)
	if not e then
		return false
	end
	if type(e.professionsFull) == "string" and e.professionsFull ~= "" then
		return true
	end
	if (tonumber(e.profAbundance) or 0) > 0 then
		return true
	end
	if (tonumber(e.profDundun) or 0) > 0 then
		return true
	end
	if type(e.profMoxie) == "string" and e.profMoxie ~= "" then
		return true
	end
	return false
end

EntryShardsBelowCap = function(e)
	if SnapshotEntryIsStale(e) then
		return false
	end
	local weekly = GetEffectiveShardsWeekly(e.shardsWeekly, e.ts)
	local maxW = math.floor(tonumber(e.shardsWeeklyMax) or 600)
	if maxW <= 0 then
		return false
	end
	return weekly < maxW
end

EntryDundunIncomplete = function(e)
	if not EntryHasProfessionSnapshot(e) or SnapshotEntryIsStale(e) then
		return false
	end
	return (tonumber(e.profDundun) or 0) < DUNDUN_WEEKLY_CAP
end

--- Spec 38 option B §4 (11 Sep 2026, Rob chose points 4 and 6): characters below the game's max
--- level fold under one line. The spec's own test - "all three vault rows unavailable" - folds
--- nobody on Rob's account: his screenshot of 10 Sep shows a level 15 at "0/9", because the client
--- hands every level a vault. The max level comes from the game (ns.GetDelveCapLevel, the same
--- gate as the Bountiful weekly), so it is still no number of ours. Level 0 means "not saved", and
--- a guess never hides a row; the current character is never folded away.
local function EntryIsLeveling(e, curGuid)
	if e.guid == curGuid then
		return false
	end
	local cap = ns.GetDelveCapLevel and tonumber(ns.GetDelveCapLevel())
	if not cap or cap <= 0 then
		return false
	end
	local lvl = tonumber(e.level) or 0
	return lvl > 0 and lvl < cap
end

--- Spec 38 option B §6: what is still open this week on one character, most urgent first, from
--- data the snapshot already holds. At most three lines; a tooltip is not a to-do app.
local function NextSteps(tip)
	local out = {}
	local function add(text, r, g, b)
		if #out < 3 then
			out[#out + 1] = { text = text, r = r or 0.9, g = g or 0.9, b = b or 0.9 }
		end
	end
	if tip.hasAvailableRewards then
		add(ns:L("ALT_NEXT_CLAIM"), 1, 0.84, 0.18)
	end
	-- Things that are lost unless you act come before things that merely wait.
	local mf = tonumber(tip.manaflux)
	if mf and mf >= MANAFLUX_CAP then
		add(ns:L("ALT_NEXT_FLUX_FMT"):format(mf, MANAFLUX_CAP), 1, 0.72, 0.3)
	end
	local wMax = tonumber(tip.shardsWeeklyMax) or 0
	local w = tonumber(tip.shardsWeekly) or 0
	if wMax > 0 and w < wMax then
		add(ns:L("ALT_NEXT_SHARDS_FMT"):format(wMax - w, w, wMax))
	end
	-- The vault row closest to its next choice.
	local best
	for _, pair in ipairs({
		{ tip.world, "ALT_VAULT_WORLD" },
		{ tip.dungeons, "ALT_VAULT_DUNGEONS" },
		{ tip.raids, "ALT_VAULT_RAIDS" },
	}) do
		local c = pair[1]
		if c and c.available and c.unlocked < c.total and c.nextThreshold > c.progress then
			local left = c.nextThreshold - c.progress
			if not best or left < best.left then
				best = { left = left, c = c, label = ns:L(pair[2]) }
			end
		end
	end
	if best then
		add(ns:L("ALT_NEXT_VAULT_FMT"):format(best.label, best.left, best.c.progress, best.c.nextThreshold))
	end
	local k = tonumber(tip.keys) or 0
	if k > 0 then
		add(ns:L("ALT_NEXT_KEYS_FMT"):format(k))
	end
	return out
end

local function FilterSnapshotEntries(entries, settings)
	local out = {}
	for i = 1, #entries do
		local e = entries[i]
		if settings.filterStaleOnly and not SnapshotEntryIsStale(e) then
			-- skip
		elseif settings.filterHasKeysOnly and (tonumber(e.keys) or 0) <= 0 then
			-- skip
		elseif settings.filterShardCapOnly and not EntryShardsBelowCap(e) then
			-- skip
		elseif settings.filterDundunIncompleteOnly and not EntryDundunIncomplete(e) then
			-- skip
		else
			out[#out + 1] = e
		end
	end
	return out
end

local function CompareSnapshotEntries(a, b, currentGuid, sortBy, sortDesc)
	local ag = a.guid or ""
	local bg = b.guid or ""
	local ac = (ag == currentGuid) and 0 or 1
	local bc = (bg == currentGuid) and 0 or 1
	if ac ~= bc then
		return ac < bc
	end

	local av, bv
	if sortBy == "level" then
		av, bv = tonumber(a.level) or 0, tonumber(b.level) or 0
	elseif sortBy == "keys" then
		av, bv = tonumber(a.keys) or 0, tonumber(b.keys) or 0
	elseif sortBy == "shards" then
		av, bv = tonumber(a.shards) or 0, tonumber(b.shards) or 0
	elseif sortBy == "undercoin" then
		av, bv = tonumber(a.undercoin) or 0, tonumber(b.undercoin) or 0
	elseif sortBy == "updated" then
		av, bv = tonumber(a.ts) or 0, tonumber(b.ts) or 0
	else
		local na = string.lower(tostring(a.name or ""))
		local nb = string.lower(tostring(b.name or ""))
		if na ~= nb then
			return sortDesc and (na > nb) or (na < nb)
		end
		local ra = string.lower(tostring(a.realm or ""))
		local rb = string.lower(tostring(b.realm or ""))
		if ra ~= rb then
			return sortDesc and (ra > rb) or (ra < rb)
		end
		return ag < bg
	end

	if av ~= bv then
		if sortDesc then
			return av > bv
		end
		return av < bv
	end

	local na = string.lower(tostring(a.name or ""))
	local nb = string.lower(tostring(b.name or ""))
	if na ~= nb then
		return na < nb
	end
	return ag < bg
end

local function SortSnapshotEntries(entries, currentGuid, settings)
	local sortBy = settings and settings.sortBy or "name"
	local sortDesc = settings and settings.sortDesc
	if sortDesc == nil then
		sortDesc = sortBy ~= "name"
	end
	table.sort(entries, function(a, b)
		return CompareSnapshotEntries(a, b, currentGuid, sortBy, sortDesc)
	end)
end

local function CycleAccountSnapshotSort()
	local settings = GetAccountSnapshotSettings()
	local idx = 1
	for i = 1, #ACCOUNT_SNAPSHOT_SORT_CYCLE do
		if ACCOUNT_SNAPSHOT_SORT_CYCLE[i] == settings.sortBy then
			idx = i
			break
		end
	end
	idx = (idx % #ACCOUNT_SNAPSHOT_SORT_CYCLE) + 1
	settings.sortBy = ACCOUNT_SNAPSHOT_SORT_CYCLE[idx]
	if settings.sortBy == "name" then
		settings.sortDesc = false
	else
		settings.sortDesc = true
	end
end

local function SetAccountSnapshotSort(sortBy)
	local settings = GetAccountSnapshotSettings()
	settings.sortBy = sortBy
	if sortBy == "name" then
		settings.sortDesc = false
	else
		settings.sortDesc = true
	end
end

local function FitToolbarButton(btn, minWidth)
	if not btn or not btn.GetFontString then
		return
	end
	local fs = btn:GetFontString()
	if not fs or not fs.GetStringWidth then
		return
	end
	local w = fs:GetStringWidth() + 28
	btn:SetWidth(math.max(minWidth or 72, w))
end

local function ClearAccountSnapshotTableFilters()
	local s = GetAccountSnapshotSettings()
	s.filterStaleOnly = false
	s.filterHasKeysOnly = false
	s.filterShardCapOnly = false
	s.filterDundunIncompleteOnly = false
end

local function AccountSnapshotAnyTableFilterActive()
	local s = GetAccountSnapshotSettings()
	return s.filterStaleOnly
		or s.filterHasKeysOnly
		or s.filterShardCapOnly
		or s.filterDundunIncompleteOnly
end

local function RefreshAccountSnapshotToolbar()
	if not ui.sortBtn then
		return
	end
	local settings = GetAccountSnapshotSettings()
	local sortKey = "ALT_SNAPSHOT_SORT_NAME"
	if settings.sortBy == "level" then
		sortKey = "ALT_SNAPSHOT_SORT_LEVEL"
	elseif settings.sortBy == "keys" then
		sortKey = "ALT_SNAPSHOT_SORT_KEYS"
	elseif settings.sortBy == "shards" then
		sortKey = "ALT_SNAPSHOT_SORT_SHARDS"
	elseif settings.sortBy == "undercoin" then
		sortKey = "ALT_SNAPSHOT_SORT_UNDER"
	elseif settings.sortBy == "updated" then
		sortKey = "ALT_SNAPSHOT_SORT_UPDATED"
	end
	ui.sortBtn:SetText(ns:L(sortKey))
	FitToolbarButton(ui.sortBtn, 108)

	if ui.clearFilterBtn then
		local filtered = AccountSnapshotAnyTableFilterActive()
		local total = 0
		if ns._mhAltOverviewCollectEntries then
			total = #ns:_mhAltOverviewCollectEntries()
		end
		if filtered then
			ui.clearFilterBtn:Show()
			ui.clearFilterBtn:Enable()
			if total > 0 then
				ui.clearFilterBtn:SetText(ns:L("ALT_SNAPSHOT_SHOW_ALL_FMT"):format(total))
			else
				ui.clearFilterBtn:SetText(ns:L("ALT_SNAPSHOT_SHOW_ALL"))
			end
			FitToolbarButton(ui.clearFilterBtn, 100)
		else
			ui.clearFilterBtn:Hide()
		end
	end
end

function ns.MhAccountSnapshotAnyTableFilterActive()
	return AccountSnapshotAnyTableFilterActive()
end

function ns.MhClearAccountSnapshotTableFilters()
	if not AccountSnapshotAnyTableFilterActive() then
		return
	end
	ClearAccountSnapshotTableFilters()
	RefreshAccountSnapshotToolbar()
	if ns._mhAltOverviewRefreshRows then
		ns:_mhAltOverviewRefreshRows()
	end
	if ns.RefreshAccountWeeklyChecklist then
		ns.RefreshAccountWeeklyChecklist()
	end
end

function ns:MhToggleAccountSnapshotWeeklyFilter(kind)
	local field = kind and WEEKLY_TABLE_FILTER_FIELDS[kind]
	if not field then
		return
	end
	local s = GetAccountSnapshotSettings()
	local turningOn = not s[field]
	ClearAccountSnapshotTableFilters()
	if turningOn then
		s[field] = true
	end
	RefreshAccountSnapshotToolbar()
	if ns._mhAltOverviewRefreshRows then
		ns:_mhAltOverviewRefreshRows()
	end
	if ns.RefreshAccountWeeklyChecklist then
		ns.RefreshAccountWeeklyChecklist()
	end
end

function ns:MhIsAccountSnapshotWeeklyFilterActive(kind)
	local field = kind and WEEKLY_TABLE_FILTER_FIELDS[kind]
	if not field then
		return false
	end
	return GetAccountSnapshotSettings()[field] == true
end

--------------------------------------------------------------------------------
--- The numeric columns (Spec 38 option A: Keys, Shards, Week, Undercoins, crystals), each centred
--- under its header band. `cells` is keyed like NUM_COL_ORDER; a missing key is skipped.
local function AnchorNumericCells(cells, row)
	--- Spec 38 §1a/§3.1, 10 Sep 2026: these cells had only a width and a CENTER anchor, so WoW
	--- wrapped "201 (354/600)" onto two lines inside a 17 px row - the overlap on Rob's screenshot.
	--- One line, always. Too wide now truncates instead of spilling into the neighbouring rows.
	local rightShift = RowActionOffset()
	local x = PAD_R
	for _, key in ipairs(NUM_COL_ORDER) do
		local w = NumColW(key)
		local fs = cells[key]
		if fs then
			fs:SetWordWrap(false)
			if fs.SetMaxLines then
				fs:SetMaxLines(1)
			end
			fs:SetWidth(w)
			fs:SetJustifyH("CENTER")
			fs:ClearAllPoints()
			fs:SetPoint("CENTER", row, "RIGHT", -(x + w / 2 + rightShift), 0)
		end
		x = x + w + NUM_GAP
	end
end

--- Spec 38 option A, second pass (10 Sep 2026): level and item level are their own column, right-
--- aligned against Vault, as the spec's mock-up had it ("90 · 279"). Inside the name cell they were
--- the last thing on the line, so a long name truncated the numbers - Rob's screenshot showed
--- "Purlymixanox-Bloodhoof Lv90 · 269 i…". Now only the name can be cut.
local COL_W_LVL = 60
local function LvlCellRightOffset()
	return TotalNumericBlockWidth() + 4 + COL_W_VAULT + 8 + RowActionOffset()
end

local function LayoutLvlCell(fs, row)
	fs:ClearAllPoints()
	fs:SetWidth(COL_W_LVL)
	fs:SetPoint("RIGHT", row, "RIGHT", -LvlCellRightOffset(), 0)
	fs:SetJustifyH("RIGHT")
	fs:SetWordWrap(false)
	if fs.SetMaxLines then
		fs:SetMaxLines(1)
	end
end

local function LayoutNameCell(fs, row)
	fs:ClearAllPoints()
	fs:SetPoint("LEFT", row, "LEFT", PAD_L, 0)
	fs:SetPoint("RIGHT", row, "RIGHT", -(LvlCellRightOffset() + COL_W_LVL + 6), 0)
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(false)
end

local function MakeDataRow(parent, idx)
	local row = CreateFrame("Frame", nil, parent)
	local rowH = RowH()
	row:SetHeight(rowH)
	row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -(HeaderRowH() + (idx - 1) * rowH))
	row.bg = row:CreateTexture(nil, "BACKGROUND", nil, -3)
	row.bg:SetAllPoints()

	row.nameFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.nameFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	LayoutNameCell(row.nameFs, row)
	row.lvlFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.lvlFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	LayoutLvlCell(row.lvlFs, row)
	row.vaultFs = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	row.vaultFs:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	row.vaultFs:SetWidth(COL_W_VAULT)
	row.vaultFs:SetJustifyH("RIGHT")
	-- Spec 38 §3.1: one line, like the numeric cells.
	row.vaultFs:SetWordWrap(false)
	if row.vaultFs.SetMaxLines then
		row.vaultFs:SetMaxLines(1)
	end
	row.vaultFs:SetPoint("RIGHT", row, "RIGHT", -(TotalNumericBlockWidth() + 4 + RowActionOffset()), 0)
	row.vaultGlow = row:CreateTexture(nil, "BACKGROUND", nil, -1)
	row.vaultGlow:SetAllPoints()
	row.vaultGlow:SetColorTexture(0.2, 0.9, 0.3, 0.12)
	row.vaultGlow:Hide()
	row.vaultPulse = row.vaultGlow:CreateAnimationGroup()
	row.vaultPulse:SetLooping("REPEAT")
	do
		local fadeIn = row.vaultPulse:CreateAnimation("Alpha")
		fadeIn:SetOrder(1)
		fadeIn:SetFromAlpha(0.08)
		fadeIn:SetToAlpha(0.2)
		fadeIn:SetDuration(1.7)
		fadeIn:SetSmoothing("IN_OUT")
		local fadeOut = row.vaultPulse:CreateAnimation("Alpha")
		fadeOut:SetOrder(2)
		fadeOut:SetFromAlpha(0.2)
		fadeOut:SetToAlpha(0.08)
		fadeOut:SetDuration(1.7)
		fadeOut:SetSmoothing("IN_OUT")
	end
	row.vaultTextPulse = row.vaultFs:CreateAnimationGroup()
	row.vaultTextPulse:SetLooping("REPEAT")
	do
		local tIn = row.vaultTextPulse:CreateAnimation("Alpha")
		tIn:SetOrder(1)
		tIn:SetFromAlpha(0.45)
		tIn:SetToAlpha(1.0)
		tIn:SetDuration(0.85)
		tIn:SetSmoothing("IN_OUT")
		local tOut = row.vaultTextPulse:CreateAnimation("Alpha")
		tOut:SetOrder(2)
		tOut:SetFromAlpha(1.0)
		tOut:SetToAlpha(0.45)
		tOut:SetDuration(0.85)
		tOut:SetSmoothing("IN_OUT")
	end

	local function Cell()
		local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		return fs
	end
	row.keysFs = Cell()
	row.shardsFs = Cell()
	row.weekFs = Cell()
	row.coinFs = Cell()
	row.crystalFs = Cell()
	AnchorNumericCells({ keys = row.keysFs, shards = row.shardsFs, week = row.weekFs,
		coin = row.coinFs, crystal = row.crystalFs }, row)
	row.deleteBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
	row.deleteBtn:SetSize(ROW_ACTION_W, rowH - 2)
	row.deleteBtn:SetPoint("RIGHT", row, "RIGHT", -2, 0)
	row.deleteBtn:SetText("x")
	row.deleteBtn:SetAlpha(0.9)
	--- Spec 38 option A: the × shows only while the pointer is on this row. Ten always-visible
	--- delete buttons read as the table's main action; it is the rarest one.
	row.deleteBtn:Hide()

	return row
end

local function MakeHeaderRow(parent)
	local row = CreateFrame("Frame", nil, parent)
	local headerH = HeaderRowH()
	row:SetHeight(headerH)
	row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)

	row.charH = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	row.charH:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	LayoutNameCell(row.charH, row)
	row.charH:SetJustifyH("LEFT")
	row.lvlH = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	row.lvlH:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	LayoutLvlCell(row.lvlH, row)

	local function HeaderCell()
		local fs = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		fs:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
		return fs
	end
	row.keysH = HeaderCell()
	row.shardsH = HeaderCell()
	row.weekH = HeaderCell()
	row.coinH = HeaderCell()
	row.crystalH = HeaderCell()
	AnchorNumericCells({ keys = row.keysH, shards = row.shardsH, week = row.weekH,
		coin = row.coinH, crystal = row.crystalH }, row)

	--- Spec 38 §3.3, 10 Sep 2026: the vault column had no header at all, so "W0 D0 R0" explained
	--- itself to nobody. Same anchor as the data rows' vaultFs. The hit button carries only the
	--- tooltip - the vault has no sort key.
	row.vaultH = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	row.vaultH:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	row.vaultH:SetWidth(COL_W_VAULT)
	row.vaultH:SetJustifyH("RIGHT")
	row.vaultH:SetWordWrap(false)
	row.vaultH:SetPoint("RIGHT", row, "RIGHT", -(TotalNumericBlockWidth() + 4 + RowActionOffset()), 0)
	row.vaultHit = CreateFrame("Button", nil, row)
	row.vaultHit:SetSize(COL_W_VAULT, headerH)
	row.vaultHit:SetPoint("CENTER", row.vaultH, "CENTER")
	row.vaultHit:SetAlpha(0.001)
	row.vaultHit:EnableMouse(true)

	--- One invisible hit button per numeric header: a tooltip, plus a sort click where a sort key
	--- exists. Exactly the column's width now - the old +12 made neighbouring buttons overlap.
	local function Hit(fs, w)
		local b = CreateFrame("Button", nil, row)
		b:SetSize(w, headerH)
		b:SetPoint("CENTER", fs, "CENTER")
		b:SetAlpha(0.001)
		b:EnableMouse(true)
		return b
	end
	row.lvlHit = Hit(row.lvlH, COL_W_LVL)
	row.keysHit = Hit(row.keysH, COL_W_KEYS)
	row.shardsHit = Hit(row.shardsH, GetColWShards())
	row.weekHit = Hit(row.weekH, COL_W_WEEK)
	row.coinHit = Hit(row.coinH, COL_W_COIN)
	row.crystalHit = Hit(row.crystalH, COL_W_CRYSTAL)

	return row
end

--------------------------------------------------------------------------------
local function IsValidPlayerGuid(guid)
	return type(guid) == "string" and guid ~= "" and string.match(guid, "^Player%-") ~= nil
end

local function IsUsableSnapshotName(name)
	if type(name) ~= "string" then
		return false
	end
	local n = name:match("^%s*(.-)%s*$") or ""
	if n == "" or n == "?" then
		return false
	end
	return true
end

function ns:_mhAltOverviewDeleteSnapshotGuid(guid)
	if not ns.db or type(ns.db.charCurrencies) ~= "table" then
		return
	end
	if type(guid) ~= "string" or guid == "" then
		return
	end
	ns.db.charCurrencies[guid] = nil
	if ns._mhAltOverviewRefreshRows then
		ns:_mhAltOverviewRefreshRows()
	end
end

local function ConfirmDeleteSnapshotGuid(guid, label)
	if type(guid) ~= "string" or guid == "" then
		return
	end
	if not StaticPopupDialogs or not StaticPopup_Show then
		return
	end
	local key = "MIDNIGHTHELPER_ALT_SNAPSHOT_DELETE_CONFIRM"
	if not StaticPopupDialogs[key] then
		StaticPopupDialogs[key] = {
			text = "",
			button1 = ACCEPT,
			button2 = CANCEL,
			OnAccept = function(_, data)
				if data and data.guid and ns._mhAltOverviewDeleteSnapshotGuid then
					ns:_mhAltOverviewDeleteSnapshotGuid(data.guid)
				end
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
	end
	StaticPopupDialogs[key].text = ns:L("ALT_OVERVIEW_DELETE_CONFIRM_FMT")
	StaticPopup_Show(key, tostring(label or "?"), nil, { guid = guid })
end

function ns:_mhAltOverviewCollectEntries()
	local bag = ns.db and ns.db.charCurrencies
	local entries = {}
	if type(bag) ~= "table" then
		return entries
	end

	for guid, snap in pairs(bag) do
		if
			type(snap) == "table"
			and type(guid) == "string"
			and IsValidPlayerGuid(guid)
			and IsUsableSnapshotName(snap.name)
		then
			entries[#entries + 1] = {
				guid = guid,
				name = snap.name,
				realm = snap.realm or "",
				keys = tonumber(snap.keys) or 0,
				shards = tonumber(snap.shards) or 0,
				shardsWeekly = tonumber(snap.shardsWeekly) or 0,
				shardsWeeklyMax = tonumber(snap.shardsWeeklyMax) or 600,
				undercoin = tonumber(snap.undercoin) or 0,
				manaCrystals = tonumber(snap.manaCrystals) or tonumber(snap.voidlightMarl) or 0,
				-- nil, niet 0: een snapshot van vóór deze kolom weet het niet, en dat
				-- is iets anders dan "deze character heeft er geen".
				manaflux = tonumber(snap.manaflux),
				level = tonumber(snap.level) or 0,
				ilvl = tonumber(snap.ilvl) or 0,
				vaultUnlocked = tonumber(snap.vaultUnlocked) or 0,
				vaultTotal = tonumber(snap.vaultTotal) or 0,
				vaultProgress = tonumber(snap.vaultProgress) or 0,
				vaultNextThreshold = tonumber(snap.vaultNextThreshold) or 0,
				vaultAvailable = tonumber(snap.vaultAvailable) or 0,
				vaultWorldUnlocked = tonumber(snap.vaultWorldUnlocked) or tonumber(snap.vaultUnlocked) or 0,
				vaultWorldTotal = tonumber(snap.vaultWorldTotal) or tonumber(snap.vaultTotal) or 0,
				vaultWorldProgress = tonumber(snap.vaultWorldProgress) or tonumber(snap.vaultProgress) or 0,
				vaultWorldNextThreshold = tonumber(snap.vaultWorldNextThreshold) or tonumber(snap.vaultNextThreshold) or 0,
				vaultWorldAvailable = tonumber(snap.vaultWorldAvailable) or tonumber(snap.vaultAvailable) or 0,
				vaultDungeonUnlocked = tonumber(snap.vaultDungeonUnlocked) or 0,
				vaultDungeonTotal = tonumber(snap.vaultDungeonTotal) or 0,
				vaultDungeonProgress = tonumber(snap.vaultDungeonProgress) or 0,
				vaultDungeonNextThreshold = tonumber(snap.vaultDungeonNextThreshold) or 0,
				vaultDungeonAvailable = tonumber(snap.vaultDungeonAvailable) or 0,
				vaultRaidUnlocked = tonumber(snap.vaultRaidUnlocked) or 0,
				vaultRaidTotal = tonumber(snap.vaultRaidTotal) or 0,
				vaultRaidProgress = tonumber(snap.vaultRaidProgress) or 0,
				vaultRaidNextThreshold = tonumber(snap.vaultRaidNextThreshold) or 0,
				vaultRaidAvailable = tonumber(snap.vaultRaidAvailable) or 0,
				vaultHasAvailableRewards = tonumber(snap.vaultHasAvailableRewards) or 0,
				vaultWorldSlots = type(snap.vaultWorldSlots) == "table" and snap.vaultWorldSlots or nil,
				vaultDungeonSlots = type(snap.vaultDungeonSlots) == "table" and snap.vaultDungeonSlots or nil,
				vaultRaidSlots = type(snap.vaultRaidSlots) == "table" and snap.vaultRaidSlots or nil,
				professions = type(snap.professions) == "string" and snap.professions or "",
				professionsFull = type(snap.professionsFull) == "string" and snap.professionsFull
					or (type(snap.professions) == "string" and snap.professions or ""),
				profAbundance = tonumber(snap.profAbundance) or 0,
				profDundun = tonumber(snap.profDundun) or 0,
				profMoxie = type(snap.profMoxie) == "string" and snap.profMoxie or "",
				delverCompleted = tonumber(snap.delverCompleted) or 0,
				delverBanked = tonumber(snap.delverBanked) or 0,
				delverInProgress = tonumber(snap.delverInProgress) or 0,
				delverTotal = tonumber(snap.delverTotal) or 0,
				troveStatus = type(snap.troveStatus) == "string" and snap.troveStatus or "available",
				troveInBag = tonumber(snap.troveInBag) or 0,
				gildedProgress = tonumber(snap.gildedProgress) or 0,
				gildedMax = tonumber(snap.gildedMax) or 4,
				saCompleted = tonumber(snap.saCompleted) or 0,
				saActive = tonumber(snap.saActive) or 0,
				saMax = tonumber(snap.saMax) or 3,
				ts = tonumber(snap.ts) or 0,
			}
		end
	end
	return entries
end

function ns:_mhAltOverviewSyncExpandState()
	local entries = self:_mhAltOverviewCollectEntries()
	local n = #entries
	if ui.expandPanel then
		ui.expandPanel:Show()
	end
	if ui.hint then
		ui.hint:Show()
	end
	self:_mhAltOverviewApplyTitle(n)
end

function ns:_mhAltOverviewApplyTitle(savedCount)
	if not ui.pageTitle then
		return
	end
	local base = ns:L("ALT_OVERVIEW_TITLE")
	ui.pageTitle:SetFormattedText("%s  (%d)", base, savedCount or 0)
end

function ns:_mhAltOverviewRefreshRows()
	local scroll = ui.scroll
	local content = ui.content
	if not scroll or not content then
		return
	end

	for _, row in ipairs(ui.dataRows or {}) do
		row:Hide()
	end
	ui.dataRows = ui.dataRows or {}
	if ui.levelGroupRow then
		ui.levelGroupRow:Hide()
	end
	if ui.legendFs then
		ui.legendFs:Hide()
	end

	local settings = GetAccountSnapshotSettings()
	local allEntries = self:_mhAltOverviewCollectEntries()
	local entries = FilterSnapshotEntries(allEntries, settings)
	local curGuid = UnitGUID("player")
	SortSnapshotEntries(entries, curGuid, settings)
	local isResetDay = IsResetDayNow()

	local cw = content:GetWidth()
	if cw < 80 then
		cw = 400
	end
	content:SetWidth(cw)

	if #entries == 0 then
		if ui.emptyHint then
			ui.emptyHint:ClearAllPoints()
			ui.emptyHint:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -HeaderRowH() - 2)
			ui.emptyHint:SetWidth(cw - 8)
			if #allEntries > 0 then
				if AccountSnapshotAnyTableFilterActive() then
					ui.emptyHint:SetText(ns:L("ALT_SNAPSHOT_FILTER_EMPTY_HINT"))
				else
					ui.emptyHint:SetText(ns:L("ALT_SNAPSHOT_FILTER_EMPTY"))
				end
			else
				ui.emptyHint:SetText(ns:L("ALT_OVERVIEW_EMPTY"))
			end
			ui.emptyHint:Show()
		end
		if ui.headerRow then
			ui.headerRow:Hide()
		end
		content:SetHeight(math.max(HeaderRowH() + RowH(), 28))
		if scroll.UpdateScrollChildRect then
			scroll:UpdateScrollChildRect()
		end
		self:_mhAltOverviewSyncExpandState()
		return
	end

	if ui.emptyHint then
		ui.emptyHint:Hide()
	end
	if ui.headerRow then
		-- Header-hoogte mee laten schalen met de tekstgrootte, zodat de eerste
		-- datarij (die op HeaderRowH() begint) er niet overheen valt.
		ui.headerRow:SetHeight(HeaderRowH())
		ui.headerRow:Show()
	end

	-- Spec 38 option B §4: leveling characters go under one fold line below the rest. Only from
	-- two on: folding a single row into a line of its own saves nothing and hides it.
	local levelers = {}
	for _, e in ipairs(entries) do
		if EntryIsLeveling(e, curGuid) then
			levelers[#levelers + 1] = e
		end
	end
	local groupSlot
	if #levelers >= 2 then
		local shown = {}
		for _, e in ipairs(entries) do
			if not EntryIsLeveling(e, curGuid) then
				shown[#shown + 1] = e
			end
		end
		groupSlot = #shown + 1
		if settings.levelersExpanded then
			for _, e in ipairs(levelers) do
				shown[#shown + 1] = e
			end
		end
		entries = shown
	else
		levelers = {}
	end

	for i, e in ipairs(entries) do
		if e.guid == curGuid then
			e.level = UnitLevel("player") or e.level
			e.ilvl = GetPlayerItemLevel()
			e.undercoin = GetCurrencyQty(UNDERCOIN)
			e.manaCrystals = GetCurrencyQty(UNTAINTED_MANA_CRYSTALS)
			e.manaflux = GetCurrencyQty(VENOMBLIGHT_MANAFLUX)
			if ns.GetProfessionWeeklySnapshot then
				e.profAbundance, e.profDundun, e.profMoxie = ns.GetProfessionWeeklySnapshot()
			end
		end
		local row = ui.dataRows[i]
		if not row then
			row = MakeDataRow(content, i)
			ui.dataRows[i] = row
		end
		row:SetWidth(cw)
		-- Hoogte opnieuw zetten zodat een gewijzigde tekstschaal de gecachete rij
		-- mee laat groeien en in sync blijft met de Y-stap hieronder.
		row:SetHeight(RowH())
		-- The fold line takes one slot; the leveling rows under it move down by one.
		local slot = (groupSlot and i >= groupSlot) and (i + 1) or i
		row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(HeaderRowH() + (slot - 1) * RowH()))
		row:Show()
		if row.bg and row.bg.SetColorTexture then
			if (slot % 2) == 1 then
				row.bg:SetColorTexture(1, 1, 1, 0.03)
			else
				row.bg:SetColorTexture(1, 1, 1, 0.08)
			end
		end

		local tag = ""
		if e.guid == curGuid then
			tag = " " .. ns:L("ALT_OVERVIEW_YOU")
		end
		--- Spec 38 option A: name and "(you)" only. Professions left the row (the tooltip has the
		--- full list), level/ilvl moved to their own column, and the orange "(relog)" badge -
		--- "(neu einloggen)" in German - became a clock and a dimmed row, with the reason at the top
		--- of the tooltip.
		local stale = SnapshotEntryIsStale(e)
		local base = FormatCharLabel(e.name, e.realm) .. tag
		if stale then
			base = base .. " |TInterface\\Icons\\INV_Misc_PocketWatch_01:0|t"
		end
		row.nameFs:SetText(base)
		local lvl = math.floor(tonumber(e.level) or 0)
		local ilvl = math.floor(tonumber(e.ilvl) or 0)
		row.lvlFs:SetText(lvl > 0 and ("%d · %d"):format(lvl, ilvl) or "")
		if stale then
			row.lvlFs:SetTextColor(0.55, 0.55, 0.55)
		else
			row.lvlFs:SetTextColor(0.6, 0.8, 1)
		end
		if e.guid == curGuid then
			row.nameFs:SetTextColor(1, 0.92, 0.45)
		elseif stale then
			row.nameFs:SetTextColor(0.6, 0.6, 0.6)
		else
			row.nameFs:SetTextColor(0.95, 0.95, 0.95)
		end
		local plain = stale and 0.55 or 0.95
		row.keysFs:SetText(tostring(e.keys))
		row.keysFs:SetTextColor(plain, plain, plain)
		local shardsWeekly, shardsWeeklyStale = GetEffectiveShardsWeekly(e.shardsWeekly, e.ts)
		local shardsWeeklyMax = tonumber(e.shardsWeeklyMax) or 600
		-- Wallet and week are two columns now: "201 (354/600)" never fitted one 62 px cell.
		row.shardsFs:SetText(tostring(math.floor(tonumber(e.shards) or 0)))
		row.shardsFs:SetTextColor(plain, plain, plain)
		if shardsWeeklyStale or shardsWeeklyMax <= 0 then
			row.weekFs:SetText("—")
			row.weekFs:SetTextColor(0.55, 0.55, 0.55)
		elseif shardsWeekly >= shardsWeeklyMax then
			-- Never colour alone (WoW has a colour-blind mode): the tick says "capped" too.
			row.weekFs:SetText(("%d/%d |TInterface\\RaidFrame\\ReadyCheck-Ready:0|t"):format(shardsWeekly, shardsWeeklyMax))
			row.weekFs:SetTextColor(0.45, 1, 0.55)
		else
			row.weekFs:SetText(("%d/%d"):format(shardsWeekly, shardsWeeklyMax))
			row.weekFs:SetTextColor(plain, plain, plain)
		end
		row.coinFs:SetText(tostring(math.floor(tonumber(e.undercoin) or 0)))
		row.coinFs:SetTextColor(plain, plain, plain)
		row.crystalFs:SetText(tostring(math.floor(tonumber(e.manaCrystals) or 0)))
		row.crystalFs:SetTextColor(plain, plain, plain)
		if row.deleteBtn then
			local canDelete = e.guid ~= curGuid
			row.deleteBtn:SetEnabled(canDelete)
			row.deleteBtn:SetAlpha(canDelete and 0.9 or 0.35)
			row.deleteBtn:SetScript("OnClick", function()
				if canDelete then
					ConfirmDeleteSnapshotGuid(e.guid, FormatCharLabel(e.name, e.realm))
				end
			end)
			row.deleteBtn:SetScript("OnEnter", function(self)
				if not GameTooltip then
					return
				end
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				if canDelete then
					GameTooltip:SetText(ns:L("ALT_OVERVIEW_DELETE_HINT"), 1, 0.85, 0.6, 1, true)
				else
					GameTooltip:SetText(ns:L("ALT_OVERVIEW_DELETE_DISABLED_HINT"), 0.8, 0.8, 0.8, 1, true)
				end
				GameTooltip:Show()
			end)
			row.deleteBtn:SetScript("OnLeave", function(self)
				if GameTooltip then
					GameTooltip:Hide()
				end
				if not row:IsMouseOver() then
					self:Hide()
				end
			end)
		end
		local worldUnlocked = math.max(0, math.floor(tonumber(e.vaultWorldUnlocked) or 0))
		local worldTotal = math.max(0, math.floor(tonumber(e.vaultWorldTotal) or 0))
		local worldProgress = math.max(0, math.floor(tonumber(e.vaultWorldProgress) or 0))
		local worldNextT = math.max(0, math.floor(tonumber(e.vaultWorldNextThreshold) or 0))
		local worldAvailable = (tonumber(e.vaultWorldAvailable) or 0) == 1 or worldTotal > 0
		local dungeonUnlocked = math.max(0, math.floor(tonumber(e.vaultDungeonUnlocked) or 0))
		local dungeonTotal = math.max(0, math.floor(tonumber(e.vaultDungeonTotal) or 0))
		local dungeonProgress = math.max(0, math.floor(tonumber(e.vaultDungeonProgress) or 0))
		local dungeonNextT = math.max(0, math.floor(tonumber(e.vaultDungeonNextThreshold) or 0))
		local dungeonAvailable = (tonumber(e.vaultDungeonAvailable) or 0) == 1 or dungeonTotal > 0
		local raidUnlocked = math.max(0, math.floor(tonumber(e.vaultRaidUnlocked) or 0))
		local raidTotal = math.max(0, math.floor(tonumber(e.vaultRaidTotal) or 0))
		local raidProgress = math.max(0, math.floor(tonumber(e.vaultRaidProgress) or 0))
		local raidNextT = math.max(0, math.floor(tonumber(e.vaultRaidNextThreshold) or 0))
		local raidAvailable = (tonumber(e.vaultRaidAvailable) or 0) == 1 or raidTotal > 0
		local hasAvailableRewards = (tonumber(e.vaultHasAvailableRewards) or 0) == 1
		local available = worldAvailable or dungeonAvailable or raidAvailable
		local unlockedAny = (worldUnlocked + dungeonUnlocked + raidUnlocked) > 0
		if hasAvailableRewards then
			row.vaultFs:SetText(ns:L("ALT_VAULT_CLAIM_READY"))
			row.vaultFs:SetTextColor(1, 0.84, 0.18)
		elseif (not hasAvailableRewards) and ((tonumber(e.ts) or 0) > 0 and (tonumber(e.ts) or 0) < GetLocalResetAnchorTs()) and unlockedAny then
			row.vaultFs:SetText(ns:L("ALT_VAULT_CLAIM_LIKELY"))
			row.vaultFs:SetTextColor(1, 0.72, 0.22)
		elseif not available then
			row.vaultFs:SetText("—")
			row.vaultFs:SetTextColor(0.58, 0.58, 0.58)
		else
			--- Spec 38 option A: one count over all three rows ("1/9") instead of "W1 D0 R0", whose
			--- letters became "M D R" or "Mu Ma R" in three languages. Each row is in the tooltip.
			row.vaultFs:SetText(("%d/%d"):format(worldUnlocked + dungeonUnlocked + raidUnlocked,
				math.max(1, worldTotal + dungeonTotal + raidTotal)))
			if unlockedAny then
				row.vaultFs:SetTextColor(0.38, 0.95, 0.42)
			elseif worldProgress > 0 or dungeonProgress > 0 or raidProgress > 0 then
				row.vaultFs:SetTextColor(0.9, 0.82, 0.45)
			else
				row.vaultFs:SetTextColor(0.58, 0.58, 0.58)
			end
		end
		row.vaultTip = {
			world = {
				available = worldAvailable,
				unlocked = worldUnlocked,
				total = worldTotal,
				progress = worldProgress,
				nextThreshold = worldNextT,
				slots = e.vaultWorldSlots,
				showLevel = true,
			},
			dungeons = {
				available = dungeonAvailable,
				unlocked = dungeonUnlocked,
				total = dungeonTotal,
				progress = dungeonProgress,
				nextThreshold = dungeonNextT,
				slots = e.vaultDungeonSlots,
				showLevel = true,
			},
			-- Raid activity "level" encodes difficulty, not a tier — hide it
			-- until its semantics are confirmed in-game (ilvl still shows).
			raids = {
				available = raidAvailable,
				unlocked = raidUnlocked,
				total = raidTotal,
				progress = raidProgress,
				nextThreshold = raidNextT,
				slots = e.vaultRaidSlots,
				showLevel = false,
			},
			availableAny = available,
			unlockedAny = unlockedAny,
			hasAvailableRewards = hasAvailableRewards,
			lastUpdated = tonumber(e.ts) or 0,
			-- ts == 0 means "no snapshot timestamp yet", not "stale" (same
			-- guard as IsSnapshotStale and the row staleness check above).
			staleSinceReset = (tonumber(e.ts) or 0) > 0 and (tonumber(e.ts) or 0) < GetLocalResetAnchorTs(),
			likelyClaim = false,
			professionsFull = e.professionsFull or "",
			profAbundance = tonumber(e.profAbundance) or 0,
			profDundun = tonumber(e.profDundun) or 0,
			profMoxie = type(e.profMoxie) == "string" and e.profMoxie or "",
			shardsTotal = tonumber(e.shards) or 0,
			shardsWeekly = shardsWeekly,
			shardsWeeklyMax = shardsWeeklyMax,
			shardsWeeklyStale = shardsWeeklyStale,
			keys = tonumber(e.keys) or 0,
			level = lvl,
			ilvl = ilvl,
			manaCrystals = tonumber(e.manaCrystals) or 0,
			manaflux = tonumber(e.manaflux),
			undercoin = tonumber(e.undercoin) or 0,
		}
		row.vaultTip.likelyClaim = (not row.vaultTip.hasAvailableRewards) and row.vaultTip.staleSinceReset and unlockedAny
		if row.vaultGlow then
			if isResetDay and (hasAvailableRewards or row.vaultTip.likelyClaim or (available and unlockedAny)) then
				row.vaultGlow:Show()
				if row.vaultPulse and not row.vaultPulse:IsPlaying() then
					row.vaultPulse:Play()
				end
				if hasAvailableRewards and row.vaultTextPulse and not row.vaultTextPulse:IsPlaying() then
					row.vaultTextPulse:Play()
				elseif (not hasAvailableRewards) and row.vaultTextPulse and row.vaultTextPulse:IsPlaying() then
					row.vaultTextPulse:Stop()
					row.vaultFs:SetAlpha(1.0)
				end
			else
				if row.vaultPulse and row.vaultPulse:IsPlaying() then
					row.vaultPulse:Stop()
				end
				if row.vaultTextPulse and row.vaultTextPulse:IsPlaying() then
					row.vaultTextPulse:Stop()
				end
				row.vaultFs:SetAlpha(1.0)
				row.vaultGlow:SetAlpha(0.12)
				row.vaultGlow:Hide()
			end
		end
		row:SetScript("OnEnter", function(self)
			if self.deleteBtn then
				self.deleteBtn:Show()
			end
			if not GameTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:ClearLines()
			--- Spec 38 option A: the dimmed row's reason comes first, where the badge used to be.
			if self.vaultTip.staleSinceReset or self.vaultTip.shardsWeeklyStale then
				GameTooltip:AddLine(ns:L("ALT_ROW_STALE_TOOLTIP"), 1, 0.82, 0.3, true)
				GameTooltip:AddLine(" ")
			else
				--- Spec 38 option B §6: open with the next step. A stale row's next step is the relog
				--- line above - its numbers are from before the reset, so steps built on them would lie.
				GameTooltip:AddLine(ns:L("ALT_NEXT_HEAD"), 1, 0.9, 0.5)
				local steps = NextSteps(self.vaultTip)
				if #steps == 0 then
					GameTooltip:AddLine(ns:L("ALT_NEXT_NONE"), 0.6, 0.9, 0.6, true)
				else
					for _, s in ipairs(steps) do
						GameTooltip:AddLine("• " .. s.text, s.r, s.g, s.b, true)
					end
				end
				GameTooltip:AddLine(" ")
			end
			if (tonumber(self.vaultTip.level) or 0) > 0 then
				GameTooltip:AddLine(
					ns:L("ALT_TOOLTIP_LEVEL_ILVL_FMT"):format(
						tonumber(self.vaultTip.level) or 0,
						tonumber(self.vaultTip.ilvl) or 0
					),
					0.9,
					0.9,
					0.9
				)
			end
			GameTooltip:AddLine(ns:L("ALT_TOOLTIP_KEYS"):format(tonumber(self.vaultTip.keys) or 0), 0.9, 0.9, 0.9)
			--- Catalyst charges, and a warning when this character has stopped gaining.
			--- ⚠️ nil means "captured before we tracked this", NOT zero. Printing 0 for a
			--- character that may be sitting on 8 would be worse than printing nothing.
			local mf = tonumber(self.vaultTip.manaflux)
			if mf then
				local capped = mf >= MANAFLUX_CAP
				GameTooltip:AddLine(
					ns:L("ALT_TOOLTIP_MANAFLUX_FMT"):format(mf, MANAFLUX_CAP),
					capped and 1 or 0.75, capped and 0.82 or 0.88, capped and 0.35 or 1)
				if capped then
					GameTooltip:AddLine(ns:L("ALT_TOOLTIP_MANAFLUX_CAPPED"), 1, 0.82, 0.35, true)
				end
			end
			GameTooltip:AddLine(
				ns:L("ALT_TOOLTIP_UNDER_MANA_FMT"):format(
					tonumber(self.vaultTip.undercoin) or 0,
					tonumber(self.vaultTip.manaCrystals) or 0
				),
				0.75,
				0.88,
				1
			)
			GameTooltip:AddLine(" ")
			if self.vaultTip.professionsFull and self.vaultTip.professionsFull ~= "" then
				GameTooltip:AddLine(ns:L("ALT_TOOLTIP_PROFESSIONS"), 0.9, 0.9, 0.9)
				GameTooltip:AddLine(self.vaultTip.professionsFull, 0.75, 0.82, 1, true)
				if string.find(self.vaultTip.professionsFull, "…", 1, true) then
					GameTooltip:AddLine(ns:L("ALT_TOOLTIP_PROFESSIONS_SYNC_HINT"), 0.8, 0.8, 0.8, true)
				end
				local abund = tonumber(self.vaultTip.profAbundance) or 0
				local dundun = tonumber(self.vaultTip.profDundun) or 0
				local moxie = self.vaultTip.profMoxie or ""
				if abund > 0 or dundun > 0 or moxie ~= "" then
					GameTooltip:AddLine(ns:L("ALT_TOOLTIP_PROF_WEEKLY_TITLE"), 0.9, 0.9, 0.5)
					if abund > 0 then
						GameTooltip:AddLine(ns:L("ALT_TOOLTIP_PROF_ABUND_FMT"):format(abund), 0.75, 0.88, 1)
					end
					GameTooltip:AddLine(ns:L("ALT_TOOLTIP_PROF_DUNDUN_FMT"):format(dundun), 0.75, 0.88, 1)
					if moxie ~= "" then
						GameTooltip:AddLine(ns:L("ALT_TOOLTIP_PROF_MOXIE_FMT"):format(moxie), 0.75, 0.88, 1, true)
					end
				end
				GameTooltip:AddLine(" ")
			end
			GameTooltip:AddLine(
				ns:L("ALT_TOOLTIP_SHARDS_TOTAL"):format(self.vaultTip.shardsTotal or 0),
				0.9,
				0.9,
				0.9
			)
			GameTooltip:AddLine(
				ns:L("ALT_TOOLTIP_SHARDS_WEEKLY"):format(
					self.vaultTip.shardsWeekly or 0,
					self.vaultTip.shardsWeeklyMax or 600
				),
				0.75,
				0.88,
				1
			)
			-- (ALT_TOOLTIP_SHARDS_WEEKLY_STALE stood here; Rob's screenshot showed the relog advice
			-- twice. ALT_ROW_STALE_TOOLTIP at the top covers this case too.)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(ns:L("ALT_VAULT_TOOLTIP_TITLE"), 1, 0.9, 0.5)
			if self.vaultTip.hasAvailableRewards then
				GameTooltip:AddLine(ns:L("ALT_VAULT_TOOLTIP_CLAIM_READY"), 1, 0.84, 0.18, true)
				GameTooltip:AddLine(ns:L("ALT_VAULT_TOOLTIP_RESET_CONTEXT"), 0.82, 0.82, 0.82, true)
				GameTooltip:AddLine(" ")
			elseif self.vaultTip.likelyClaim then
				GameTooltip:AddLine(ns:L("ALT_VAULT_TOOLTIP_CLAIM_LIKELY"), 1, 0.72, 0.22, true)
				GameTooltip:AddLine(ns:L("ALT_VAULT_TOOLTIP_CLAIM_LIKELY_NOTE"), 0.84, 0.84, 0.84, true)
				GameTooltip:AddLine(" ")
			end
			if not self.vaultTip.availableAny then
				GameTooltip:AddLine(ns:L("ALT_VAULT_TOOLTIP_UNAVAILABLE"), 0.85, 0.85, 0.85, true)
			else
				local function AddVaultCategory(label, cat)
					if not cat.available then
						GameTooltip:AddLine(ns:L("ALT_VAULT_TOOLTIP_ROW_UNAVAILABLE"):format(label), 0.65, 0.65, 0.65)
						return
					end
					GameTooltip:AddLine(
						ns:L("ALT_VAULT_TOOLTIP_ROW_READY"):format(label, cat.unlocked, math.max(1, cat.total)),
						0.9,
						0.9,
						0.9
					)
					GameTooltip:AddLine(
						ns:L("ALT_VAULT_TOOLTIP_ROW_NEXT"):format(label, cat.progress, math.max(1, cat.nextThreshold)),
						0.75,
						0.82,
						1
					)
					-- Per-slot detail (last registered values): what gear quality
					-- is locked in, so on an alt you can see whether higher
					-- delve/ritual tiers are still worth running this week.
					-- Only shows fields the snapshot really captured (never lie).
					if type(cat.slots) == "table" then
						for i, s in ipairs(cat.slots) do
							local t = tonumber(s.t) or 0
							local p = tonumber(s.p) or 0
							local l = cat.showLevel and (tonumber(s.l) or 0) or 0
							local iv = tonumber(s.i) or 0
							if t > 0 and p >= t then
								if iv > 0 and l > 0 then
									GameTooltip:AddLine("  " .. ns:L("ALT_VAULT_SLOT_ILVL_LVL_FMT"):format(i, iv, l), 0.38, 0.95, 0.42)
								elseif iv > 0 then
									GameTooltip:AddLine("  " .. ns:L("ALT_VAULT_SLOT_ILVL_FMT"):format(i, iv), 0.38, 0.95, 0.42)
								elseif l > 0 then
									GameTooltip:AddLine("  " .. ns:L("ALT_VAULT_SLOT_OPEN_LVL_FMT"):format(i, l), 0.55, 0.9, 0.55)
								else
									GameTooltip:AddLine("  " .. ns:L("ALT_VAULT_SLOT_OPEN_FMT"):format(i), 0.55, 0.9, 0.55)
								end
							else
								GameTooltip:AddLine("  " .. ns:L("ALT_VAULT_SLOT_LOCKED_FMT"):format(i, p, math.max(1, t)), 0.6, 0.6, 0.6)
							end
						end
					end
				end

				AddVaultCategory(ns:L("ALT_VAULT_WORLD"), self.vaultTip.world)
				AddVaultCategory(ns:L("ALT_VAULT_DUNGEONS"), self.vaultTip.dungeons)
				AddVaultCategory(ns:L("ALT_VAULT_RAIDS"), self.vaultTip.raids)

				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(
					ns:L("ALT_VAULT_RESET_GLOW_HINT"),
					0.7,
					0.9,
					0.7,
					true
				)
			end
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(
				ns:L("ALT_VAULT_TOOLTIP_LAST_UPDATED"):format(FormatRelativeTime(self.vaultTip.lastUpdated)),
				0.72,
				0.72,
				0.72,
				true
			)
			-- (ALT_VAULT_TOOLTIP_STALE_RESET used to close this tooltip; ALT_ROW_STALE_TOOLTIP
			-- now opens it, so saying it twice would only push the details apart.)
			GameTooltip:Show()
		end)
		row:SetScript("OnLeave", function(self)
			if GameTooltip then
				GameTooltip:Hide()
			end
			-- Moving onto the × is leaving the row too; keep it while the pointer is on it.
			if self.deleteBtn and not self.deleteBtn:IsMouseOver() then
				self.deleteBtn:Hide()
			end
		end)
		if row.abundFs then
			row.abundFs:Hide()
		end
		if row.moxFs then
			row.moxFs:Hide()
		end
	end

	for j = #entries + 1, #ui.dataRows do
		ui.dataRows[j]:Hide()
	end

	local slots = #entries
	if groupSlot then
		slots = slots + 1
		local g = ui.levelGroupRow
		if not g then
			g = CreateFrame("Button", nil, content)
			g.bg = g:CreateTexture(nil, "BACKGROUND")
			g.bg:SetAllPoints()
			g.bg:SetColorTexture(1, 1, 1, 0.05)
			g.fs = g:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
			g.fs:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
			g.fs:SetPoint("LEFT", g, "LEFT", PAD_L, 0)
			g.fs:SetPoint("RIGHT", g, "RIGHT", -4, 0)
			g.fs:SetJustifyH("LEFT")
			g.fs:SetWordWrap(false)
			g:SetScript("OnClick", function()
				local s = GetAccountSnapshotSettings()
				s.levelersExpanded = not s.levelersExpanded
				ns:_mhAltOverviewRefreshRows()
			end)
			g:SetScript("OnEnter", function(self)
				if not GameTooltip then
					return
				end
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				GameTooltip:ClearLines()
				GameTooltip:AddLine(self.fs:GetText() or "", 1, 0.9, 0.5, true)
				for _, nm in ipairs(self._mhNames or {}) do
					GameTooltip:AddLine("  " .. nm, 0.9, 0.9, 0.9)
				end
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(ns:L("ALT_LEVEL_GROUP_TT_NOTE"), 0.75, 0.75, 0.75, true)
				local expanded = GetAccountSnapshotSettings().levelersExpanded
				GameTooltip:AddLine(ns:L(expanded and "ALT_LEVEL_GROUP_TT_HIDE" or "ALT_LEVEL_GROUP_TT_SHOW"), 0.6, 0.9, 0.6, true)
				GameTooltip:Show()
			end)
			g:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end)
			ui.levelGroupRow = g
		end
		local cap = ns.GetDelveCapLevel and tonumber(ns.GetDelveCapLevel()) or 0
		g.fs:SetText(("%s %s"):format(settings.levelersExpanded and "−" or "+",
			ns:L("ALT_LEVEL_GROUP_FMT"):format(#levelers, cap)))
		local names = {}
		for _, e in ipairs(levelers) do
			names[#names + 1] = ("%s  %s"):format(FormatCharLabel(e.name, e.realm),
				ns:L("ALT_ROW_LEVEL_ONLY_FMT"):format(math.floor(tonumber(e.level) or 0)))
		end
		g._mhNames = names
		g:ClearAllPoints()
		g:SetHeight(RowH())
		g:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(HeaderRowH() + (groupSlot - 1) * RowH()))
		g:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -(HeaderRowH() + (groupSlot - 1) * RowH()))
		g:Show()
	end

	--- Spec 38 option B §6: one legend line under the table, so the clock and the green need no
	--- guessing, and the reader learns that the tooltips hold the explanations.
	if not ui.legendFs then
		ui.legendFs = content:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		ui.legendFs:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
		ui.legendFs:SetJustifyH("LEFT")
		ui.legendFs:SetWordWrap(true)
	end
	local legendTop = HeaderRowH() + slots * RowH() + 6
	ui.legendFs:ClearAllPoints()
	ui.legendFs:SetPoint("TOPLEFT", content, "TOPLEFT", PAD_L, -legendTop)
	ui.legendFs:SetPoint("TOPRIGHT", content, "TOPRIGHT", -4, -legendTop)
	ui.legendFs:SetText(ns:L("ALT_TABLE_LEGEND"))
	ui.legendFs:Show()
	local legendH = math.max(ui.legendFs:GetStringHeight() or 0, RowH())

	local bodyH = legendTop + legendH + 6
	content:SetHeight(math.max(bodyH, 24))
	if scroll.UpdateScrollChildRect then
		scroll:UpdateScrollChildRect()
	end

	self:_mhAltOverviewSyncExpandState()
	if ns.RefreshAccountWeeklyChecklist then
		ns.RefreshAccountWeeklyChecklist()
	end
end

function ns:_mhAltOverviewRefreshHeaderTexts()
	if not ui.headerRow then
		return
	end
	local h = ui.headerRow
	h.charH:SetText(ns:L("ALT_COL_CHARACTER"))
	h.lvlH:SetText(ns:L("ALT_COL_LEVEL_ILVL"))
	h.keysH:SetText(ns:L("ALT_COL_KEYS"))
	h.shardsH:SetText(ns:L("ALT_COL_SHARDS"))
	--- sortBy nil = tooltip only (Week, crystals). titleFn, when given, supplies a title line from
	--- the client (the currency's own name) above the hint.
	local function wireHeaderHit(hit, sortBy, hintKey, titleFn)
		if not hit then
			return
		end
		if sortBy then
			hit:SetScript("OnClick", function()
				SetAccountSnapshotSort(sortBy)
				RefreshAccountSnapshotToolbar()
				if ns._mhAltOverviewRefreshRows then
					ns:_mhAltOverviewRefreshRows()
				end
			end)
		else
			hit:SetScript("OnClick", nil)
		end
		if hintKey then
			hit:SetScript("OnEnter", function(self)
				if not GameTooltip then
					return
				end
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				local title = titleFn and titleFn()
				-- hintKey may be a function: the currency columns build their hint from the
				-- Currencies tab's "what it is for" line, so the two pages cannot disagree.
				local hint = (type(hintKey) == "function") and hintKey() or ns:L(hintKey)
				if type(title) == "string" and title ~= "" then
					GameTooltip:SetText(title, 1, 0.92, 0.55)
					GameTooltip:AddLine(hint, 0.9, 0.9, 0.9, true)
				else
					GameTooltip:SetText(hint, 1, 0.92, 0.55, 1, true)
				end
				GameTooltip:Show()
			end)
			hit:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end)
		end
	end
	-- Spec 38 option A: Shards is the wallet only now; Week, Undercoins and crystals are new columns.
	local coinIcon = CurrencyIconAndName(UNDERCOIN)
	local crystalIcon, crystalName = CurrencyIconAndName(UNTAINTED_MANA_CRYSTALS)
	h.weekH:SetText(ns:L("ALT_COL_WEEK"))
	h.coinH:SetText(coinIcon and ("|T" .. coinIcon .. ":0|t") or ns:L("ALT_COL_UNDERCOINS"))
	h.crystalH:SetText(crystalIcon and ("|T" .. crystalIcon .. ":0|t") or (crystalName or "?"))
	wireHeaderHit(h.lvlHit, "level", "ALT_COL_LEVEL_ILVL_HINT")
	wireHeaderHit(h.keysHit, "keys", "ALT_COL_KEYS_HINT")
	wireHeaderHit(h.shardsHit, "shards", "ALT_COL_SHARDS_WALLET_HINT")
	wireHeaderHit(h.weekHit, nil, "ALT_COL_WEEK_HINT")
	-- Spec 38 option B §6: what it is for comes from Spec 39's line on the Currencies tab; the old
	-- shared hint sent both currencies to Zah'ran, and Undercoin's main vendor is Naleidea.
	wireHeaderHit(h.coinHit, "undercoin", function()
		return ns:L("CURACC_USE_UNDERCOIN") .. "\n" .. ns:L("ALT_HINT_RESET_NOT_WEEKLY")
	end, function()
		return select(2, CurrencyIconAndName(UNDERCOIN))
	end)
	wireHeaderHit(h.crystalHit, nil, function()
		return ns:L("CURACC_USE_MANA") .. "\n" .. ns:L("ALT_HINT_RESET_NOT_WEEKLY")
	end, function()
		return select(2, CurrencyIconAndName(UNTAINTED_MANA_CRYSTALS))
	end)
	-- Spec 38 §3.3: the vault header. The hint names the three rows in order by their own
	-- translated names, so it explains "W D R" and the French/Spanish "M D R" alike.
	if h.vaultH then
		h.vaultH:SetText(ns:L("ALT_COL_VAULT"))
	end
	if h.vaultHit then
		h.vaultHit:SetScript("OnEnter", function(self)
			if not GameTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(ns:L("ALT_COL_VAULT_HINT_FMT"):format(ns:L("ALT_VAULT_WORLD"),
				ns:L("ALT_VAULT_DUNGEONS"), ns:L("ALT_VAULT_RAIDS"), ns:L("ALT_VAULT_CLAIM_READY")),
				1, 0.92, 0.55, 1, true)
			GameTooltip:Show()
		end)
		h.vaultHit:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
	end
	if h.abundH then
		h.abundH:Hide()
	end
	if h.moxH then
		h.moxH:Hide()
	end
end

function ns:MhAccountEntryIsStale(e)
	return SnapshotEntryIsStale(e)
end

function ns:MhGetEffectiveShardsWeekly(weekly, snapshotTs)
	return GetEffectiveShardsWeekly(weekly, snapshotTs)
end

function ns:MhAccountEntryShardsBelowCap(e)
	return EntryShardsBelowCap(e)
end

function ns:MhAccountEntryDundunIncomplete(e)
	return EntryDundunIncomplete(e)
end

function ns:_mhAltOverviewRefreshTexts()
	if ui.hint then
		ui.hint:SetText(ns:L("ALT_OVERVIEW_HINT"))
	end
	if ns.RefreshAccountWeeklyChecklist then
		ns.RefreshAccountWeeklyChecklist()
	end
	RefreshAccountSnapshotToolbar()
	do
		local list = self:_mhAltOverviewCollectEntries()
		self:_mhAltOverviewApplyTitle(#list)
	end
	self:_mhAltOverviewRefreshHeaderTexts()
	self:_mhAltOverviewRefreshRows()
end

local function BuildAccountSnapshotHost(host)
	ui.host = host

	ui.pageTitle = host:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	ui.pageTitle:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	ui.pageTitle:SetPoint("TOPLEFT", host, "TOPLEFT", 10, -10)
	ui.pageTitle:SetPoint("TOPRIGHT", host, "TOPRIGHT", -10, -10)
	ui.pageTitle:SetJustifyH("LEFT")

	ui.hint = host:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	ui.hint:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	ui.hint:SetPoint("TOPLEFT", ui.pageTitle, "BOTTOMLEFT", 0, -6)
	ui.hint:SetPoint("TOPRIGHT", ui.pageTitle, "BOTTOMRIGHT", 0, -6)
	ui.hint:SetJustifyH("LEFT")

	local function AnchorToolbarBelowWeekly()
		if ui.toolbar and ui.weeklyBlock then
			ui.toolbar:ClearAllPoints()
			ui.toolbar:SetPoint("TOPLEFT", ui.weeklyBlock, "BOTTOMLEFT", 0, -6)
			ui.toolbar:SetPoint("TOPRIGHT", ui.weeklyBlock, "BOTTOMRIGHT", 0, -6)
		end
	end

	if ns.MountAccountWeeklyChecklist then
		ui.weeklyBlock = ns.MountAccountWeeklyChecklist(host, ui.hint, AnchorToolbarBelowWeekly)
		AnchorToolbarBelowWeekly()
	else
		ui.weeklyBlock = ui.hint
	end

	ui.toolbar = CreateFrame("Frame", nil, host)
	ui.toolbar:SetHeight(24)
	ui.toolbar:SetPoint("TOPLEFT", ui.weeklyBlock, "BOTTOMLEFT", 0, -6)
	ui.toolbar:SetPoint("TOPRIGHT", ui.weeklyBlock, "BOTTOMRIGHT", 0, -6)

	ui.sortBtn = CreateFrame("Button", nil, ui.toolbar, "UIPanelButtonTemplate")
	ui.sortBtn:SetSize(148, 22)
	ui.sortBtn:SetPoint("LEFT", ui.toolbar, "LEFT", 0, 0)
	ui.sortBtn:SetScript("OnClick", function()
		CycleAccountSnapshotSort()
		RefreshAccountSnapshotToolbar()
		if ns._mhAltOverviewRefreshRows then
			ns:_mhAltOverviewRefreshRows()
		end
	end)

	ui.clearFilterBtn = CreateFrame("Button", nil, ui.toolbar, "UIPanelButtonTemplate")
	ui.clearFilterBtn:SetSize(120, 22)
	ui.clearFilterBtn:SetPoint("LEFT", ui.sortBtn, "RIGHT", 6, 0)
	ui.clearFilterBtn:Hide()
	ui.clearFilterBtn:SetScript("OnClick", function()
		if ns.MhClearAccountSnapshotTableFilters then
			ns.MhClearAccountSnapshotTableFilters()
		end
	end)
	ui.clearFilterBtn:SetScript("OnEnter", function(self)
		if not GameTooltip then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:SetText(ns:L("ALT_SNAPSHOT_SHOW_ALL_HINT"), 1, 0.92, 0.55, 1, true)
		GameTooltip:Show()
	end)
	ui.clearFilterBtn:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)

	RefreshAccountSnapshotToolbar()

	ui.expandPanel = CreateFrame("Frame", nil, host)
	ui.expandPanel:SetPoint("TOPLEFT", ui.toolbar, "BOTTOMLEFT", 0, -8)
	ui.expandPanel:SetPoint("BOTTOMRIGHT", host, "BOTTOMRIGHT", -8, 8)

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperAltOverviewScroll", ui.expandPanel)
	scroll:SetPoint("TOPLEFT", ui.expandPanel, "TOPLEFT", 0, 0)
	scroll:SetPoint("BOTTOMRIGHT", ui.expandPanel, "BOTTOMRIGHT", 0, 0)
	scroll:EnableMouseWheel(true)

	local content = CreateFrame("Frame", nil, scroll)
	content:SetHeight(40)
	scroll:SetScrollChild(content)

	ui.scroll = scroll
	ui.content = content

	ui.headerRow = MakeHeaderRow(content)
	ui.emptyHint = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	ui.emptyHint:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	ui.emptyHint:SetJustifyH("LEFT")
	ui.emptyHint:Hide()

	local step = (WORLDWIDE_SCROLL_STEP and math.floor(WORLDWIDE_SCROLL_STEP * 0.65)) or 22
	scroll:SetScript("OnMouseWheel", function(self, delta)
		local cur = self:GetVerticalScroll() or 0
		local max = self:GetVerticalScrollRange() or 0
		local nextv = cur - delta * step
		if nextv < 0 then
			nextv = 0
		elseif nextv > max then
			nextv = max
		end
		self:SetVerticalScroll(nextv)
	end)

	content:SetScript("OnSizeChanged", function(self)
		local w = self:GetWidth()
		for _, row in ipairs(ui.dataRows or {}) do
			if row and row:IsShown() then
				row:SetWidth(w)
			end
		end
		if ui.headerRow then
			ui.headerRow:SetWidth(w)
		end
	end)

	ns:_mhAltOverviewRefreshTexts()
end

local function MountAccountSnapshotPanel()
	if accountPanelMounted then
		return
	end
	local panel = ns.panels and ns.panels.account
	if not panel then
		return
	end

	accountPanelMounted = true

	if panel._header then
		panel._header:Hide()
	end
	if panel._body then
		panel._body:Hide()
	end

	local host = CreateFrame("Frame", "MidnightHelperAccountSnapshotHost", panel)
	host:SetAllPoints(panel)

	BuildAccountSnapshotHost(host)

	host:SetScript("OnShow", function()
		SaveCurrentSnapshot()
		if ns.RefreshAccountWeeklyChecklist then
			ns.RefreshAccountWeeklyChecklist()
		end
		if ns._mhAltOverviewRefreshRows then
			ns:_mhAltOverviewRefreshRows()
		end
	end)

	host:SetScript("OnSizeChanged", function()
		local w = host:GetWidth() or 0
		if ui.content then
			ui.content:SetWidth(math.max(80, w - 28))
		end
		if ns._mhAltOverviewRefreshRows then
			ns:_mhAltOverviewRefreshRows()
		end
	end)
end

function ns:_mhAltOverviewAfterEnsure()
	MountAccountSnapshotPanel()
	SaveCurrentSnapshot()
	if ns._mhAltOverviewRefreshRows then
		ns:_mhAltOverviewRefreshRows()
	end
end

--------------------------------------------------------------------------------
do
	local orig = ns.EnsureMainUI
	function ns:EnsureMainUI(...)
		local main = orig(self, ...)
		self:_mhAltOverviewAfterEnsure()
		return main
	end
end

--------------------------------------------------------------------------------
do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if self._mhAltOverviewRefreshTexts then
			self:_mhAltOverviewRefreshTexts()
		end
	end
end

--------------------------------------------------------------------------------
--- Delves accordion changes: refresh snapshot rows (same underlying character data).
function ns:_mhAltOverviewAccordionSync()
	if self._mhAltOverviewRefreshRows then
		self:_mhAltOverviewRefreshRows()
	end
end

--------------------------------------------------------------------------------
local ev = CreateFrame("Frame", nil, UIParent)
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ev:RegisterEvent("WEEKLY_REWARDS_UPDATE")
ev:RegisterEvent("QUEST_TURNED_IN")
ev:RegisterEvent("QUEST_LOG_UPDATE")
ev:RegisterEvent("SCENARIO_COMPLETED")
ev:SetScript("OnEvent", function(_, event)
	if not ns.db then
		return
	end
	if event == "PLAYER_LOGIN" then
		SaveCurrentSnapshot()
		if ns.RefreshAccountWeeklyChecklist then
			ns.RefreshAccountWeeklyChecklist()
		end
		if ns._mhAltOverviewRefreshRows then
			ns:_mhAltOverviewRefreshRows()
		end
	elseif event == "CURRENCY_DISPLAY_UPDATE" then
		ScheduleSave()
	elseif event == "WEEKLY_REWARDS_UPDATE" then
		ScheduleSave()
	elseif event == "QUEST_TURNED_IN" or event == "QUEST_LOG_UPDATE" then
		-- Keeps Delver's Call counts current; ScheduleSave coalesces the churn.
		ScheduleSave()
	elseif event == "SCENARIO_COMPLETED" then
		ScheduleSave()
	end
end)
