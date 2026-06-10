--[[
	Weekly shard-cap alert (Rob, 10 Jun): one toast per character per week the
	moment the weekly Coffer Shards cap (600) is reached — so you can stop
	farming rares/world quests for shards and move on. After it fires it stays
	silent until the next weekly reset (per character, stored in SavedVariables
	keyed by the region-correct reset anchor).

	Reads the same currency the Account Snapshot tracks (COFFER_SHARDS 3310,
	quantityEarnedThisWeek vs maxWeeklyQuantity). never-lie: no alert when the
	API doesn't expose a weekly max.
]]

local _, ns = ...

local COFFER_SHARDS = 3310

-- earned-this-week, weekly max, currency icon (nil-safe).
local function GetWeeklyShards()
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		return nil
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, COFFER_SHARDS)
	if not ok or type(info) ~= "table" then
		return nil
	end
	local earned = math.floor(tonumber(info.quantityEarnedThisWeek) or 0)
	local maxW = math.floor(tonumber(info.maxWeeklyQuantity) or 0)
	return earned, maxW, info.iconFileID
end

local function CurrentAnchor()
	if ns.MhGetWeeklyResetAnchorTs then
		local ok, ts = pcall(ns.MhGetWeeklyResetAnchorTs)
		if ok and tonumber(ts) and ts > 0 then
			return ts
		end
	end
	return nil
end

local function Check()
	if not ns.db then
		return -- SavedVariables not loaded yet; the next event retries
	end
	local guid = UnitGUID and UnitGUID("player")
	if not guid then
		return
	end
	local earned, maxW, icon = GetWeeklyShards()
	if not earned or not maxW or maxW <= 0 or earned < maxW then
		return
	end
	local anchor = CurrentAnchor()
	if not anchor then
		return -- can't anchor the week reliably -> rather silent than wrong
	end
	ns.db.shardCapAlert = ns.db.shardCapAlert or {}
	if ns.db.shardCapAlert[guid] == anchor then
		return -- already announced this week on this character
	end
	ns.db.shardCapAlert[guid] = anchor

	if ns.QueueMidnightToast then
		ns.QueueMidnightToast({
			id = "shardcap",
			title = ns:L("SHARD_CAP_TOAST_TITLE_FMT"):format(earned, maxW),
			body = ns:L("SHARD_CAP_TOAST_BODY"),
			icon = icon,
			displaySec = 10,
		})
	end
	if ns.PrintChatKey then
		ns:PrintChatKey("SHARD_CAP_CHAT_FMT", earned, maxW)
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		-- Currency data can lag right after a loading screen; check shortly
		-- after so a character that logs in already capped gets its toast.
		if C_Timer and C_Timer.After then
			C_Timer.After(5, Check)
		else
			Check()
		end
	else
		Check()
	end
end)
