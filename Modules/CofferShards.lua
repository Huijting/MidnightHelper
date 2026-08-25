--[[
	Coffer Key Shards (currency 3310) — ONE reader, and how many rares are left.

	⚠️ WHY THIS FILE EXISTS. Three places already read this currency and two of them
	are byte-identical copies of the same function, under the same name:

	  • Modules/AltOverview.lua:280   GetShardQuantityAndMax()
	  • Modules/Delves.lua:1671       GetShardQuantityAndMax()   <- same code, same name
	  • Modules/ShardCapAlert.lua:28  GetWeeklyShards()          <- reads a DIFFERENT field

	That is the fifth time in this repo that one question had several answers, and the
	unfixed copy shipped the worse one. So a fourth copy was not an option.

	🔴 THE THREE DISAGREE, AND IT MATTERS. The two copies take `maxQuantity` first and
	only fall back to `maxWeeklyQuantity`; ShardCapAlert takes `maxWeeklyQuantity` and
	nothing else. Those are different numbers: one is how many you may HOLD, the other
	how many you may EARN in a week. If they ever differ, two screens are wrong and the
	alert is right — or the reverse. Nobody has measured which.

	So this file does NOT quietly pick a winner for the existing screens. It exposes both
	fields by name, uses the weekly one for the weekly question (the field whose name says
	what it is), and ships `/mh shards` so one command in game settles it. Migrating the
	other three is a separate step, after the measurement — see docs/NEXT_SESSION.md.

	WHAT IT IS FOR. Rob, 25 aug 2026, wanted a second route button that walks past EVERY
	rare rather than only the open ones, because he was farming shards. Researched instead
	of built: the weekly cap is 600 and a rare pays 50, so twelve rares fill it. If a rare
	pays once per week — which our own rare flag was measured to be — then the existing
	button already walks him past exactly the ones that still pay, and "all rares" would
	route him past dead ends.

	⚠️ Not proven. Warcraft Wiki lists rares at 50 shards and the 600 cap, but NO source
	states whether a rare you already killed this week pays again. Which is why the line
	below counts what is LEFT instead of asserting how the lockout works: true either way.
]]

local _, ns = ...

local COFFER_SHARDS = 3310

--- What one rare pays. Warcraft Wiki (25 aug 2026), consistent with 600/12.
--- ⚠️ A wiki figure, not measured in Rob's client. Only ever used to turn a shard
--- count into "about N rares", never to claim a total we could get wrong.
local SHARDS_PER_RARE = 50

--- Every field this currency gives us, named, with nothing guessed.
--- Returns nil when the API is unavailable — never zeros, because "0 of 600" and
--- "we could not read it" must not look the same to a caller.
function ns.GetCofferShardStatus()
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		return nil
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, COFFER_SHARDS)
	if not ok or type(info) ~= "table" then
		return nil
	end
	local weeklyMax = math.floor(tonumber(info.maxWeeklyQuantity) or 0)
	local totalMax = math.floor(tonumber(info.maxQuantity) or 0)
	local earned = math.floor(tonumber(info.quantityEarnedThisWeek) or 0)
	local t = {
		quantity = math.floor(tonumber(info.quantity) or 0),
		earnedThisWeek = earned,
		weeklyMax = weeklyMax,
		totalMax = totalMax,
		iconFileID = info.iconFileID,
	}
	-- No weekly cap exposed => no weekly claim. Silence beats a number we invented.
	if weeklyMax > 0 then
		t.remaining = math.max(weeklyMax - earned, 0)
		t.capped = t.remaining == 0
		t.raresLeft = math.ceil(t.remaining / SHARDS_PER_RARE)
	end
	return t
end

--- One line for the rares panel: how much of this week's cap is left, in rares.
--- Returns nil whenever we cannot say something true — capped, unreadable, or no
--- weekly maximum published.
function ns.GetCofferShardRareLine()
	local s = ns.GetCofferShardStatus()
	if not s or not s.remaining then
		return nil
	end
	if s.capped then
		return ns:L("SHARDS_CAP_REACHED")
	end
	return (ns:L("SHARDS_REMAINING_FMT")):format(s.remaining, s.weeklyMax, s.raresLeft)
end

--- /mh shards — prints the raw fields, because three modules disagree about which
--- one is the weekly cap and the client is the only thing that can settle it.
function ns.PrintCofferShardProbe()
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	local s = ns.GetCofferShardStatus()
	if not s then
		print(prefix .. " C_CurrencyInfo.GetCurrencyInfo(3310) gave nothing.")
		print("   That is not the same as 'you have no shards' — the read failed.")
		return
	end
	print(prefix .. " Coffer Key Shards (currency 3310):")
	print(("   quantity              = %d"):format(s.quantity))
	print(("   quantityEarnedThisWeek= %d"):format(s.earnedThisWeek))
	print(("   maxWeeklyQuantity     = %d   |cff8a8f98<- ShardCapAlert uses this|r"):format(s.weeklyMax))
	print(("   maxQuantity           = %d   |cff8a8f98<- AltOverview and Delves use this first|r"):format(s.totalMax))
	if s.weeklyMax > 0 and s.totalMax > 0 and s.weeklyMax ~= s.totalMax then
		print("   |cffff5555They differ — so two screens and the alert cannot both be right.|r")
	elseif s.weeklyMax == s.totalMax and s.weeklyMax > 0 then
		print("   |cff77dd77Identical, so the disagreement is harmless today. It stays a trap.|r")
	end
	if s.remaining then
		print(("   left this week        = %d  (about %d rares at %d each)")
			:format(s.remaining, s.raresLeft, SHARDS_PER_RARE))
	end
end
