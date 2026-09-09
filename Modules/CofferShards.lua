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

--- Forward-declared: `GetCofferShardStatus` below needs it, and it is defined further down
--- beside the observer it reads from. Without this the earlier function would capture a
--- global nil instead — the exact thing lint check [6] exists to catch.
local ShardsPerPickup

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
		-- Per pickup: what this player's own game has been paying, once it has seen enough
		-- to say. Falls back to the wiki figure, and says which it used so no caller has to
		-- guess whether the number is measured.
		local per, measured = ShardsPerPickup()
		t.perPickup = per
		t.perPickupMeasured = measured and true or false
		t.raresLeft = math.ceil(t.remaining / per)
	end
	return t
end

--------------------------------------------------------------------------------
--- 🔑 WHAT YOUR OWN GAME PAYS, instead of what a wiki says it pays.
---
--- 🔴 THE CONSTANT ABOVE WAS MEASURED WRONG ON 9 Sep 2026 and cannot be repaired by picking a
--- better number: Journey rank 10 states every source pays more, so the rate depends on how
--- far along the player is. Any single figure here is wrong for somebody.
---
--- 📌 SO WE WATCH INSTEAD OF LOOKING UP. Same move as the giver observation added the same
--- morning, and the same machinery as the soul ledger that already follows item 273000: record
--- what actually arrived, and the number is right at every rank and survives a tuning hotfix
--- nobody told us about.
---
--- ⚠️ DELIBERATELY NOT ATTRIBUTED TO RARES. Shards also come from chests, treasures and
--- finished delves, and `Rares.lua` fires no "you killed one" signal, so calling a gain "a
--- rare" would be a guess dressed as a fact -- and quest flags are exactly what today proved
--- untrustworthy. What is recorded is "a pickup paid N", which is also the quantity the panel
--- actually needs: how many more pickups fill the cap.
--------------------------------------------------------------------------------

local GAIN_LOG_MAX = 40
local MIN_OBSERVATIONS = 3

local function GainLog()
	ns.db = ns.db or {}
	if type(ns.db.shardGains) ~= "table" then
		ns.db.shardGains = {}
	end
	return ns.db.shardGains
end

--- The gain size seen most often, or nil while we have not seen enough.
---
--- ⚠️ CLIPPED GAINS ARE EXCLUDED, and that matters more here than it looks. Near the weekly
--- cap the game hands over only what still fits, so a 75 arrives as a 12 -- and a handful of
--- those would drag the mode down and quietly shorten every estimate. A gain is only counted
--- when there was room for it. The count of skipped ones is reported rather than hidden.
--- @return number|nil size, number seen, number clean, number skipped
function ns.GetObservedShardGain()
	local clean, skipped = {}, 0
	for _, row in ipairs(GainLog()) do
		if row.clipped then
			skipped = skipped + 1
		elseif type(row.gain) == "number" and row.gain > 0 then
			clean[#clean + 1] = row.gain
		end
	end
	if #clean < MIN_OBSERVATIONS then
		return nil, 0, #clean, skipped
	end
	local tally = {}
	for _, g in ipairs(clean) do
		tally[g] = (tally[g] or 0) + 1
	end
	local best, bestN = nil, 0
	for g, n in pairs(tally) do
		if n > bestN or (n == bestN and best and g > best) then
			best, bestN = g, n
		end
	end
	-- A mode that is not actually typical says nothing. Half of a mixed bag is not a rate.
	if bestN * 2 < #clean then
		return nil, bestN, #clean, skipped
	end
	return best, bestN, #clean, skipped
end

--- What one pickup pays, and whether that is measured or borrowed.
--- @return number amount, boolean measured
function ShardsPerPickup()
	local observed = ns.GetObservedShardGain()
	if observed then
		return observed, true
	end
	return SHARDS_PER_RARE, false
end

do
	local lastQty
	local f = CreateFrame("Frame")
	f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function()
		local s = ns.GetCofferShardStatus()
		if not s then
			return
		end
		--- 🔴 The first reading only ESTABLISHES the baseline. Without this, logging in looks
		--- like a gain of everything you own and one bogus row poisons the mode for good.
		if lastQty == nil then
			lastQty = s.quantity
			return
		end
		local gain = s.quantity - lastQty
		lastQty = s.quantity
		if gain <= 0 then
			return -- spending a key, or the reset: not a payout
		end
		-- Room BEFORE this gain: if the payout was larger than the space, it was cut short.
		local roomBefore = s.remaining and (s.remaining + gain) or nil
		local log = GainLog()
		log[#log + 1] = {
			at = time(),
			gain = gain,
			clipped = (roomBefore ~= nil and gain >= roomBefore) or nil,
		}
		while #log > GAIN_LOG_MAX do
			table.remove(log, 1)
		end
	end)
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
			:format(s.remaining, s.raresLeft, s.perPickup or SHARDS_PER_RARE))
	end

	--- The observer's own state, because its normal output is a number that looks the same
	--- whether it was measured or borrowed — and "borrowed" is the one that was wrong.
	local size, seen, clean, skipped = ns.GetObservedShardGain()
	if size then
		print(("   |cff77dd77per pickup            = %d  MEASURED in your game (%d of %d payouts)|r")
			:format(size, seen, clean))
	elseif clean and clean > 0 then
		print(("   |cffffd100per pickup            = %d  still the wiki figure — %d payout(s) seen, need %d that agree|r")
			:format(SHARDS_PER_RARE, clean, MIN_OBSERVATIONS))
	else
		print(("   |cffffd100per pickup            = %d  still the wiki figure — no payout observed yet|r")
			:format(SHARDS_PER_RARE))
	end
	if skipped and skipped > 0 then
		print(("   |cff8a8f98%d payout(s) ignored: they landed against the weekly cap and were cut short.|r")
			:format(skipped))
	end
end
