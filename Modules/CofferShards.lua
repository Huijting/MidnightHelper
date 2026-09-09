--[[
	Coffer Key Shards (currency 3310) — ONE reader, and how many rares are left.

	⚠️ WHY THIS FILE EXISTS. Three places already read this currency and two of them
	are byte-identical copies of the same function, under the same name:

	  • Modules/AltOverview.lua:280   GetShardQuantityAndMax()
	  • Modules/Delves.lua:1671       GetShardQuantityAndMax()   <- same code, same name
	  • Modules/ShardCapAlert.lua:28  GetWeeklyShards()          <- reads a DIFFERENT field

	That is the fifth time in this repo that one question had several answers, and the
	unfixed copy shipped the worse one. So a fourth copy was not an option.

	✅ MEASURED 9 Sep 2026, and the answer is: they agree. Rob's client reports
	`maxQuantity = 0` and `maxWeeklyQuantity = 600`. Both copies test `maxQ <= 0` and fall
	back, so all three modules end up on 600 and nothing is wrong today.

	⚠️ IT STAYS A TRAP, for the reason it was written down. The fallback only rescues them
	because maxQuantity is ZERO. The day Blizzard publishes a real lifetime cap — say 2000 —
	the fallback stops firing, the two screens quietly switch to showing the lifetime cap and
	the alert keeps using the weekly one, and neither screen looks broken. `/mh shards` now
	says which case you are in rather than hinting at the order.

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

--- 🔴 MEASURED 9 Sep 2026 AND THE WIKI FIGURE IS WRONG FOR THIS PLAYER. Rob ran a clean
--- before-and-after on a fresh character: 600 of weekly headroom, nothing else looted in
--- between, Delver's Journey rank 10 (account-wide, confirmed on that character).
---
---     quantity                447 -> 522   = +75
---     quantityEarnedThisWeek    0 ->  75   = +75
---
--- Both counters agree, so ONE RARE PAID 75, not the 50 the Warcraft Wiki lists.
---
--- ⚠️ AND THE RATE IS NOT A CONSTANT AT ALL. Journey rank 10 states that "Coffer Key Shards
--- earned from all sources is increased", so what a rare pays depends on how far along the
--- player is. A single number in this file is therefore wrong by design for somebody.
---
--- 🔴 DO NOT READ 75 AS "the base is 50 and rank 10 adds 50%". That ratio would be built out
--- of one measured number and one wiki number, and a ratio is no better than its worse half.
--- The base has never been measured either.
---
--- 📌 WHAT THIS COSTS TODAY, so the size of it is on the record: with 525 shards left the
--- panel told Rob "about 11 rares" where the true answer was 7. That error only ever appears
--- for players who progressed furthest, and it never gets reported, because you simply reach
--- the cap earlier than the addon promised.
---
--- Kept at 50 for now rather than swapped for 75: replacing one unverified constant with a
--- second one that is only right at rank 10 trades a known error for a hidden one. The fix is
--- to watch what YOUR game actually pays -- see docs/NEXT_SESSION.md.
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
	print(("   maxQuantity           = %d   |cff8a8f98<- the other two read this first|r"):format(s.totalMax))

	--- 🔴 THIS BLOCK NEARLY CAUSED A BUG REPORT ABOUT A BUG THAT DOES NOT EXIST. Rob ran the
	--- probe on 9 Sep 2026 and it printed `maxQuantity = 0` beside "AltOverview and Delves use
	--- this first". Read together, that says those two screens are dividing by zero. They are
	--- not: both copies test `maxQ <= 0` and fall back, so all three modules agree in practice.
	---
	--- 📌 The hint was written before anyone had measured, when only the ORDER was known. The
	--- moment a real zero appeared it invited the wrong conclusion — and a diagnostic that
	--- misleads its reader is worse than one that says less, because it is trusted.
	--- ⚠️ So it now reports what the fallback actually DOES, per case, instead of hinting.
	if s.totalMax <= 0 and s.weeklyMax > 0 then
		print("   |cff77dd77maxQuantity is 0 = 'no lifetime cap'. Both other readers test <= 0|r")
		print("   |cff77dd77and fall back to maxWeeklyQuantity, so all three agree on 600.|r")
	elseif s.weeklyMax > 0 and s.totalMax > 0 and s.weeklyMax ~= s.totalMax then
		print("   |cffff5555They differ AND both are above zero — the fallback never fires, so|r")
		print("   |cffff5555the two screens show the lifetime cap and the alert the weekly one.|r")
	elseif s.weeklyMax == s.totalMax and s.weeklyMax > 0 then
		print("   |cff77dd77Identical, so the disagreement is harmless today. It stays a trap.|r")
	end
	if s.remaining then
		print(("   left this week        = %d  (about %d rares at %d each)")
			:format(s.remaining, s.raresLeft, SHARDS_PER_RARE))
	end
end
