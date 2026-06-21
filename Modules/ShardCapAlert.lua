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

-- Aan/uit (Settings; standaard aan). Community-verzoek 21 jun (gadrinonturalyon).
function ns.IsShardCapAlertEnabled()
	return not (ns.db and ns.db.ui and ns.db.ui.shardCapAlert == false)
end
function ns.SetShardCapAlertEnabled(v)
	if ns.db and ns.db.ui then
		ns.db.ui.shardCapAlert = v and true or false
	end
end

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
	if not ns.IsShardCapAlertEnabled() then
		return -- door de speler uitgezet (Settings)
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

	-- Eén popup per character per week: vink de week NU af, op het beslismoment.
	-- De oude dedupe-in-onShow vinkte pas af als de toast écht in beeld kwam —
	-- stond 'ie bij login in de wachtrij achter een andere toast (of zette de
	-- show-callback niet door), dan bleef de week onafgevinkt en kwam de popup
	-- élke login terug (Rob 21 jun). Nu deterministisch: 1×/week, daarna pas weer
	-- na de reset als de cap opnieuw gehaald wordt (nieuwe anchor).
	ns.db.shardCapAlert[guid] = anchor

	if ns.QueueMidnightToast then
		ns.QueueMidnightToast({
			id = "shardcap",
			title = ns:L("SHARD_CAP_TOAST_TITLE_FMT"):format(earned, maxW),
			body = ns:L("SHARD_CAP_TOAST_BODY"),
			icon = icon,
			displaySec = 10,
			-- Geluid: READY_CHECK (Rob 11 jun, live getest) — het legendary-
			-- jingle bleek in-game nauwelijks hoorbaar, de ready-check knalt
			-- er wél doorheen en blijft anders dan de rare-alert-wekker.
			soundKit = SOUNDKIT and SOUNDKIT.READY_CHECK or nil,
			onShow = function()
				if ns.PrintChatKey then
					ns:PrintChatKey("SHARD_CAP_CHAT_FMT", earned, maxW)
				end
			end,
		})
	elseif ns.PrintChatKey then
		ns:PrintChatKey("SHARD_CAP_CHAT_FMT", earned, maxW)
	end
end

-- /mh shardtest — vuurt de toast (incl. geluid) direct af, zonder dedupe of
-- cap-eis. Debug-hulpmiddel (Rob 11 jun: geluid testen zonder farm-rondje).
function ns.TestShardCapAlert()
	local earned, maxW, icon = GetWeeklyShards()
	earned, maxW = earned or 600, (maxW and maxW > 0) and maxW or 600
	if ns.QueueMidnightToast then
		ns.QueueMidnightToast({
			id = "shardcap-test",
			title = ns:L("SHARD_CAP_TOAST_TITLE_FMT"):format(earned, maxW),
			body = ns:L("SHARD_CAP_TOAST_BODY"),
			icon = icon,
			displaySec = 10,
			soundKit = SOUNDKIT and SOUNDKIT.READY_CHECK or nil,
		})
		print("|cffffcc00MH:|r shardtest fired (soundKit="
			.. tostring(SOUNDKIT and SOUNDKIT.READY_CHECK) .. ")")
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
