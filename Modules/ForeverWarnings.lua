local _, ns = ...

--[[
	ForeverWarnings.lua — WoW Forever: two warnings you would otherwise notice too late.

	Rob, 8 Nov 2026: "Wat ik merk met Forever is dat je heel snel door je tasruimte heen bent ... Kunnen we een melding
	krijgen als we bijvoorbeeld nog maar 2 lege plekken hebben? Dat is hetzelfde met mana ... Als we iets aan willen
	vallen en we hebben eigenlijk veel te weinig mana" → proposal → "Ja, bouw alle drie".

	1. Bags almost full: one big message in the middle of the screen (ns.FireAccessibleAlert, the same door as every MH
	   alert) when the free slots in your normal bags drop to the limit (2 by default), and once more at 0. Not again
	   until you made room and filled up again. The chat line adds how many grey items you could sell, and for how much.
	   In combat it waits until the fight is over. Special bags (quiver, soul bag, herb bag) do not count.
	2. Low mana or health before a fight: when you target an enemy you can attack while you are not fighting, and your
	   mana is under 40% (only when you have mana) or your health under 50%. Once per enemy, at most every 30 seconds.
	Players choose (both switchable, limits adjustable):
	  /mh bags            what MH sees now and why it did or did not warn (a module that is normally quiet needs this)
	  /mh bags on|off     /mh bags <0-10>   the number of free slots that warns
	  /mh rest            the same diagnosis for mana and health
	  /mh rest on|off     /mh rest mana <0-100>   /mh rest health <0-100>
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local REST_GAP = 30

local function Settings()
	local d = ns.db
	if not d then
		return { bags = true, bagsAt = 2, rest = true, mana = 40, health = 50 }
	end
	d.foreverWarn = d.foreverWarn or {}
	local s = d.foreverWarn
	if s.bags == nil then s.bags = true end
	if s.bagsAt == nil then s.bagsAt = 2 end
	if s.rest == nil then s.rest = true end
	if s.mana == nil then s.mana = 40 end
	if s.health == nil then s.health = 50 end
	return s
end

local function Secret(v)
	return issecretvalue and issecretvalue(v)
end

local function InFight()
	return (InCombatLockdown and InCombatLockdown()) or (UnitAffectingCombat and UnitAffectingCombat("player") == true)
end

--------------------------------------------------------------------------------
-- 1. Bags
--------------------------------------------------------------------------------

local C = C_Container
local LAST_BAG = NUM_BAG_SLOTS or 4

--- Free slots in the normal bags (bag family 0), and how many bags were read.
local function FreeSlots()
	if not (C and C.GetContainerNumFreeSlots) then
		return nil
	end
	local free, read = 0, 0
	for bag = 0, LAST_BAG do
		local ok, n, family = pcall(C.GetContainerNumFreeSlots, bag)
		if ok and type(n) == "number" and (family == nil or family == 0) then
			free = free + n
			read = read + 1
		end
	end
	return free, read
end

--- Grey items in the bags: how many stacks and what a vendor pays (copper; 0 when the price is not cached yet).
local function Greys()
	local count, copper = 0, 0
	if not (C and C.GetContainerNumSlots and C.GetContainerItemInfo) then
		return 0, 0
	end
	for bag = 0, LAST_BAG do
		local okN, slots = pcall(C.GetContainerNumSlots, bag)
		for slot = 1, (okN and slots) or 0 do
			local ok, info = pcall(C.GetContainerItemInfo, bag, slot)
			if ok and type(info) == "table" and info.quality == 0 and not info.hasNoValue then
				count = count + 1
				local price = info.itemID and C_Item and C_Item.GetItemInfo and select(11, C_Item.GetItemInfo(info.itemID))
				if type(price) == "number" then
					copper = copper + price * (info.stackCount or 1)
				end
			end
		end
	end
	return count, copper
end

local function Money(c)
	if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
		local ok, s = pcall(C_CurrencyInfo.GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	return tostring(c)
end

local bagState = { low = false, full = false, pending = nil, lastFree = nil, lastWhy = "not checked yet" }

local function BagMessage(free)
	local s = Settings()
	local big = free == 0 and ns:L("FWARN_BAGS_FULL") or ns:L("FWARN_BAGS_LOW_FMT"):format(free)
	if ns.FireAccessibleAlert then
		ns.FireAccessibleAlert(big, false)
	end
	local line = big
	local n, copper = Greys()
	if n > 0 then
		line = line .. " " .. (copper > 0 and ns:L("FWARN_BAGS_GREYS_FMT"):format(n, Money(copper))
			or ns:L("FWARN_BAGS_GREYS_NOPRICE_FMT"):format(n))
	end
	print(PREFIX .. line .. " |cff888888" .. ns:L("FWARN_BAGS_OFF_HINT") .. "|r")
	bagState.lastWhy = ("warned at %d free (limit %d)"):format(free, s.bagsAt)
end

local function CheckBags()
	local s = Settings()
	local free = FreeSlots()
	bagState.lastFree = free
	if not s.bags then
		bagState.lastWhy = "switched off (/mh bags on)"
		return
	end
	if not free then
		bagState.lastWhy = "bag slots cannot be read here"
		return
	end
	if free > s.bagsAt then
		bagState.low, bagState.full, bagState.pending = false, false, nil
		bagState.lastWhy = ("%d free, above the limit of %d: nothing to say"):format(free, s.bagsAt)
		return
	end
	local due = (not bagState.low) or (free == 0 and not bagState.full)
	if not due then
		bagState.lastWhy = ("%d free: already told you, waiting until you make room"):format(free)
		return
	end
	if InFight() then
		bagState.pending = true -- PLAYER_REGEN_ENABLED tries again
		bagState.lastWhy = ("%d free, in a fight: the message waits until it is over"):format(free)
		return
	end
	bagState.low = true
	bagState.full = free == 0
	bagState.pending = nil
	BagMessage(free)
end

--------------------------------------------------------------------------------
-- 2. Mana and health before a fight
--------------------------------------------------------------------------------

local MANA = (Enum and Enum.PowerType and Enum.PowerType.Mana) or 0
local restState = { lastAt = 0, lastKey = nil, lastWhy = "no enemy targeted yet" }

--- Percent (0-100) of a player value, or nil when it cannot be read (secret, or no maximum).
local function Pct(cur, max)
	if Secret(cur) or Secret(max) or type(cur) ~= "number" or type(max) ~= "number" or max <= 0 then
		return nil
	end
	return math.floor(cur / max * 100 + 0.5)
end

local function ManaPct()
	if not (UnitPower and UnitPowerMax) then
		return nil
	end
	local okM, max = pcall(UnitPowerMax, "player", MANA)
	if not okM or Secret(max) or type(max) ~= "number" or max <= 0 then
		return nil -- no mana bar (warrior, rogue): nothing to warn about
	end
	local ok, cur = pcall(UnitPower, "player", MANA)
	return ok and Pct(cur, max) or nil
end

local function HealthPct()
	local ok, cur = pcall(UnitHealth, "player")
	local okM, max = pcall(UnitHealthMax, "player")
	return (ok and okM) and Pct(cur, max) or nil
end

local function TargetKey()
	local g = UnitGUID and UnitGUID("target")
	if type(g) == "string" and not Secret(g) then
		return g
	end
	return nil
end

local function CheckRest()
	local s = Settings()
	if not s.rest then
		restState.lastWhy = "switched off (/mh rest on)"
		return
	end
	if not (UnitExists("target") and UnitCanAttack("player", "target") == true) then
		return -- not an enemy: no decision to record
	end
	if UnitIsDead("target") == true then
		restState.lastWhy = "target is dead"
		return
	end
	if InFight() then
		restState.lastWhy = "already fighting: too late to drink"
		return
	end
	local key = TargetKey()
	local now = GetTime()
	if key and key == restState.lastKey then
		restState.lastWhy = "same enemy as last time: told you once"
		return
	end
	if now - restState.lastAt < REST_GAP then
		restState.lastWhy = ("asked again within %d s: quiet"):format(REST_GAP)
		return
	end
	local mana, health = ManaPct(), HealthPct()
	local lowMana = mana and mana < s.mana
	local lowHealth = health and health < s.health
	if not (lowMana or lowHealth) then
		restState.lastWhy = ("mana %s, health %s: enough"):format(mana and (mana .. "%") or "none",
			health and (health .. "%") or "unreadable")
		return
	end
	local msg
	if lowMana and lowHealth then
		msg = ns:L("FWARN_REST_BOTH_FMT"):format(mana, health)
	elseif lowMana then
		msg = ns:L("FWARN_REST_MANA_FMT"):format(mana)
	else
		msg = ns:L("FWARN_REST_HEALTH_FMT"):format(health)
	end
	restState.lastAt, restState.lastKey = now, key
	if ns.FireAccessibleAlert then
		ns.FireAccessibleAlert(msg, false)
	end
	print(PREFIX .. msg .. " |cff888888" .. ns:L("FWARN_REST_OFF_HINT") .. "|r")
	restState.lastWhy = ("warned: mana %s, health %s"):format(mana and (mana .. "%") or "none",
		health and (health .. "%") or "?")
end

--------------------------------------------------------------------------------
-- Commands
--------------------------------------------------------------------------------

function ns.ForeverBagsSlash(arg)
	local s = Settings()
	arg = (arg or ""):lower()
	local n = tonumber(arg)
	if arg == "on" or arg == "off" then
		s.bags = (arg == "on")
		bagState.low, bagState.full = false, false
		print(PREFIX .. ns:L(s.bags and "FWARN_BAGS_ON" or "FWARN_BAGS_OFF"))
		return
	elseif n then
		s.bagsAt = math.max(0, math.min(10, math.floor(n)))
		bagState.low, bagState.full = false, false
		print(PREFIX .. ns:L("FWARN_BAGS_AT_FMT"):format(s.bagsAt))
		return
	end
	local free, read = FreeSlots()
	local n2, copper = Greys()
	print(PREFIX .. ("bags warning: %s, warns at %d free (/mh bags on|off, /mh bags <0-10>)"):format(
		s.bags and "on" or "off", s.bagsAt))
	print(("  free in normal bags: %s (%s bags read), grey items %d worth %s"):format(tostring(free),
		tostring(read), n2, Money(copper)))
	print("  last decision: " .. bagState.lastWhy)
end

function ns.ForeverRestSlash(arg)
	local s = Settings()
	arg = (arg or ""):lower()
	local what, num = arg:match("^(%a+)%s+(%d+)$")
	if arg == "on" or arg == "off" then
		s.rest = (arg == "on")
		print(PREFIX .. ns:L(s.rest and "FWARN_REST_ON" or "FWARN_REST_OFF"))
		return
	elseif (what == "mana" or what == "health") and num then
		s[what] = math.max(0, math.min(100, tonumber(num)))
		print(PREFIX .. ns:L(what == "mana" and "FWARN_REST_MANA_AT_FMT" or "FWARN_REST_HEALTH_AT_FMT"):format(s[what]))
		return
	end
	local mana, health = ManaPct(), HealthPct()
	print(PREFIX .. ("rest warning: %s, mana under %d%%, health under %d%% (/mh rest on|off, /mh rest mana|health <n>)")
		:format(s.rest and "on" or "off", s.mana, s.health))
	print(("  now: mana %s, health %s, fighting %s"):format(mana and (mana .. "%") or "none/unreadable",
		health and (health .. "%") or "unreadable", InFight() and "yes" or "no"))
	print("  last decision: " .. restState.lastWhy)
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("PLAYER_TARGET_CHANGED")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_TARGET_CHANGED" then
		CheckRest()
	elseif event == "BAG_UPDATE_DELAYED" or bagState.pending then
		CheckBags()
	end
end)
