--[[
	Midnight Helper — Account snapshot (dedicated main tab + panel).

	Snapshots: MidnightHelperDB.charCurrencies[guid]
]]

local addonName, ns = ...

local COFFER_KEY = 3028
local COFFER_SHARDS = 3310
local UNDERCOIN = 2803
local UNTAINTED_MANA_CRYSTALS = 3356

--- Layout: keys / shards narrow; Undercoins wider so the header fits.
local PAD_L = 4
local PAD_R = 6
local COL_W_KEYS = 34
local COL_W_SHARDS = 62

local function GetColWShards()
	local loc = ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode()
	if loc == "deDE" or loc == "frFR" then
		return 70
	end
	return COL_W_SHARDS
end
local COL_W_UNDER = 96
local COL_W_VAULT = 110
local NUM_GAP = 4
local ROW_ACTION_W = 18
local ROW_ACTION_GAP = 4
local ROW_H = 17
local HEADER_ROW_H = 17

local accountPanelMounted = false
local ui = {}

local pendingSaveTimer

local function RowActionOffset()
	return ROW_ACTION_W + ROW_ACTION_GAP
end

local function TotalNumericBlockWidth()
	return PAD_R + COL_W_UNDER + GetColWShards() + COL_W_KEYS + 2 * NUM_GAP
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

local function FormatShardsCell(total, weekly, weeklyMax, weeklyStale)
	total = math.floor(tonumber(total) or 0)
	weekly = math.floor(tonumber(weekly) or 0)
	weeklyMax = math.floor(tonumber(weeklyMax) or 600)
	if weeklyMax <= 0 then
		return tostring(total)
	end
	if weeklyStale and weekly == 0 then
		return string.format(ns:L("ALT_SHARDS_CELL_STALE_FMT"), total)
	end
	return string.format(ns:L("ALT_SHARDS_CELL_FMT"), total, weekly, weeklyMax)
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
	if #s > 44 then
		s = string.sub(s, 1, 42) .. "…"
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
	if #s > 26 then
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
--- Three numeric columns (Keys, Shards, Undercoins): centered under each header band.
local function AnchorThreeNumericCells(keysFs, shardsFs, underFs, row)
	local rightShift = RowActionOffset()
	local cxUnder = PAD_R + COL_W_UNDER / 2
	local shardW = GetColWShards()
	local cxShards = PAD_R + COL_W_UNDER + NUM_GAP + shardW / 2
	local cxKeys = PAD_R + COL_W_UNDER + NUM_GAP + shardW + NUM_GAP + COL_W_KEYS / 2

	underFs:SetWidth(COL_W_UNDER)
	underFs:SetJustifyH("CENTER")
	underFs:ClearAllPoints()
	underFs:SetPoint("CENTER", row, "RIGHT", -(cxUnder + rightShift), 0)

	shardsFs:SetWidth(GetColWShards())
	shardsFs:SetJustifyH("CENTER")
	shardsFs:ClearAllPoints()
	shardsFs:SetPoint("CENTER", row, "RIGHT", -(cxShards + rightShift), 0)

	keysFs:SetWidth(COL_W_KEYS)
	keysFs:SetJustifyH("CENTER")
	keysFs:ClearAllPoints()
	keysFs:SetPoint("CENTER", row, "RIGHT", -(cxKeys + rightShift), 0)
end

local function LayoutNameCell(fs, row)
	fs:ClearAllPoints()
	fs:SetPoint("LEFT", row, "LEFT", PAD_L, 0)
	fs:SetPoint("RIGHT", row, "RIGHT", -(TotalNumericBlockWidth() + COL_W_VAULT + 6 + RowActionOffset()), 0)
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(false)
end

local function MakeDataRow(parent, idx)
	local row = CreateFrame("Frame", nil, parent)
	row:SetHeight(ROW_H)
	row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -(HEADER_ROW_H + (idx - 1) * ROW_H))
	row.bg = row:CreateTexture(nil, "BACKGROUND", nil, -3)
	row.bg:SetAllPoints()

	row.nameFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	LayoutNameCell(row.nameFs, row)
	row.vaultFs = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	row.vaultFs:SetWidth(COL_W_VAULT)
	row.vaultFs:SetJustifyH("RIGHT")
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

	row.keysFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.shardsFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.underFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	AnchorThreeNumericCells(row.keysFs, row.shardsFs, row.underFs, row)
	row.deleteBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
	row.deleteBtn:SetSize(ROW_ACTION_W, ROW_H - 2)
	row.deleteBtn:SetPoint("RIGHT", row, "RIGHT", -2, 0)
	row.deleteBtn:SetText("x")
	row.deleteBtn:SetAlpha(0.9)

	return row
end

local function MakeHeaderRow(parent)
	local row = CreateFrame("Frame", nil, parent)
	row:SetHeight(HEADER_ROW_H)
	row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)

	row.charH = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	LayoutNameCell(row.charH, row)
	row.charH:SetJustifyH("LEFT")

	row.keysH = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	row.shardsH = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	row.underH = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	AnchorThreeNumericCells(row.keysH, row.shardsH, row.underH, row)

	row.shardsHit = CreateFrame("Button", nil, row)
	row.shardsHit:SetSize(GetColWShards() + 12, HEADER_ROW_H)
	row.shardsHit:SetPoint("CENTER", row.shardsH, "CENTER")
	row.shardsHit:SetAlpha(0.001)
	row.shardsHit:EnableMouse(true)

	row.keysHit = CreateFrame("Button", nil, row)
	row.keysHit:SetSize(COL_W_KEYS + 12, HEADER_ROW_H)
	row.keysHit:SetPoint("CENTER", row.keysH, "CENTER")
	row.keysHit:SetAlpha(0.001)
	row.keysHit:EnableMouse(true)

	row.underHit = CreateFrame("Button", nil, row)
	row.underHit:SetSize(COL_W_UNDER + 12, HEADER_ROW_H)
	row.underHit:SetPoint("CENTER", row.underH, "CENTER")
	row.underHit:SetAlpha(0.001)
	row.underHit:EnableMouse(true)

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
			ui.emptyHint:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -HEADER_ROW_H - 2)
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
		content:SetHeight(math.max(HEADER_ROW_H + ROW_H, 28))
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
		ui.headerRow:Show()
	end

	for i, e in ipairs(entries) do
		if e.guid == curGuid then
			e.level = UnitLevel("player") or e.level
			e.ilvl = GetPlayerItemLevel()
			e.undercoin = GetCurrencyQty(UNDERCOIN)
			e.manaCrystals = GetCurrencyQty(UNTAINTED_MANA_CRYSTALS)
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
		row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(HEADER_ROW_H + (i - 1) * ROW_H))
		row:Show()
		if row.bg and row.bg.SetColorTexture then
			if (i % 2) == 1 then
				row.bg:SetColorTexture(1, 1, 1, 0.03)
			else
				row.bg:SetColorTexture(1, 1, 1, 0.08)
			end
		end

		local tag = ""
		if e.guid == curGuid then
			tag = " " .. ns:L("ALT_OVERVIEW_YOU")
		end
		local base = FormatCharLabel(e.name, e.realm) .. tag
		local lvl = math.floor(tonumber(e.level) or 0)
		local ilvl = math.floor(tonumber(e.ilvl) or 0)
		if lvl > 0 then
			base = base .. "  " .. ns:L("ALT_ROW_LEVEL_ILVL_FMT"):format(lvl, ilvl)
		end
		if SnapshotEntryIsStale(e) then
			base = base .. " " .. ns:L("ALT_STALE_WED_BADGE")
		end
		local prof = e.professions or ""
		if prof ~= "" then
			base = base .. "  |cff888888" .. prof .. "|r"
		end
		row.nameFs:SetText(base)
		if e.guid == curGuid then
			row.nameFs:SetTextColor(1, 0.92, 0.45)
		else
			row.nameFs:SetTextColor(0.95, 0.95, 0.95)
		end
		row.keysFs:SetText(tostring(e.keys))
		local shardsWeekly, shardsWeeklyStale = GetEffectiveShardsWeekly(e.shardsWeekly, e.ts)
		local shardsWeeklyMax = tonumber(e.shardsWeeklyMax) or 600
		row.shardsFs:SetText(FormatShardsCell(e.shards, shardsWeekly, shardsWeeklyMax, shardsWeeklyStale))
		if shardsWeeklyStale then
			row.shardsFs:SetTextColor(1, 0.82, 0.35)
		elseif shardsWeeklyMax > 0 and shardsWeekly >= shardsWeeklyMax then
			row.shardsFs:SetTextColor(0.45, 1, 0.55)
		else
			row.shardsFs:SetTextColor(0.95, 0.95, 0.95)
		end
		row.underFs:SetText(ns:L("ALT_UNDER_MANA_CELL_FMT"):format(
			math.floor(tonumber(e.undercoin) or 0),
			math.floor(tonumber(e.manaCrystals) or 0)
		))
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
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				if canDelete then
					GameTooltip:SetText(ns:L("ALT_OVERVIEW_DELETE_HINT"), 1, 0.85, 0.6, 1, true)
				else
					GameTooltip:SetText(ns:L("ALT_OVERVIEW_DELETE_DISABLED_HINT"), 0.8, 0.8, 0.8, 1, true)
				end
				GameTooltip:Show()
			end)
			row.deleteBtn:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
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
			row.vaultFs:SetText(ns:L("ALT_VAULT_EMPTY"))
			row.vaultFs:SetTextColor(0.58, 0.58, 0.58)
		else
			row.vaultFs:SetText(ns:L("ALT_VAULT_ROW_FMT"):format(worldUnlocked, dungeonUnlocked, raidUnlocked))
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
			if not GameTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:ClearLines()
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
			if self.vaultTip.shardsWeeklyStale then
				GameTooltip:AddLine(ns:L("ALT_TOOLTIP_SHARDS_WEEKLY_STALE"), 1, 0.82, 0.3, true)
			end
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
			if self.vaultTip.staleSinceReset then
				GameTooltip:AddLine(ns:L("ALT_VAULT_TOOLTIP_STALE_RESET"), 1, 0.82, 0.3, true)
			end
			GameTooltip:Show()
		end)
		row:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
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

	local bodyH = HEADER_ROW_H + #entries * ROW_H + 6
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
	h.keysH:SetText(ns:L("ALT_COL_KEYS"))
	h.shardsH:SetText(ns:L("ALT_COL_SHARDS"))
	local function wireHeaderHit(hit, sortBy, hintKey)
		if not hit then
			return
		end
		hit:SetScript("OnClick", function()
			SetAccountSnapshotSort(sortBy)
			RefreshAccountSnapshotToolbar()
			if ns._mhAltOverviewRefreshRows then
				ns:_mhAltOverviewRefreshRows()
			end
		end)
		if hintKey then
			hit:SetScript("OnEnter", function(self)
				if not GameTooltip then
					return
				end
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(ns:L(hintKey), 1, 0.92, 0.55, 1, true)
				GameTooltip:Show()
			end)
			hit:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end)
		end
	end
	wireHeaderHit(h.keysHit, "keys", "ALT_COL_KEYS_HINT")
	wireHeaderHit(h.shardsHit, "shards", "ALT_COL_SHARDS_HINT")
	wireHeaderHit(h.underHit, "undercoin", "ALT_COL_UNDER_MANA_HINT")
	h.underH:SetText(ns:L("ALT_COL_UNDER_MANA"))
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
	ui.pageTitle:SetPoint("TOPLEFT", host, "TOPLEFT", 10, -10)
	ui.pageTitle:SetPoint("TOPRIGHT", host, "TOPRIGHT", -10, -10)
	ui.pageTitle:SetJustifyH("LEFT")

	ui.hint = host:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
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
