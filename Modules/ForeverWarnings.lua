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
		return { bags = true, bagsAt = 2, rest = true, mana = 40, health = 50, pole = true }
	end
	d.foreverWarn = d.foreverWarn or {}
	local s = d.foreverWarn
	if s.pole == nil then s.pole = true end
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
		ns.FireAccessibleAlert(big, false, 6) -- 6 s instead of 2 (Rob: "die was heel snel weg")
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

--- Does the player have a mana bar at all? (the maximum is readable in Forever: Rob measured "max 232").
local function HasManaBar()
	local ok, max = pcall(UnitPowerMax, "player", MANA)
	if not ok or max == nil then
		return false
	end
	return Secret(max) or (type(max) == "number" and max > 0)
end

--------------------------------------------------------------------------------
-- The secret path. GEMETEN by Rob, 8 Nov 2026 (/mh rest on a priest out of combat): UnitHealth, UnitPower(mana),
-- UnitHealthPercent and UnitPowerPercent are all SECRET in Forever; only the maximums are readable. MH may not
-- compare a secret, so it cannot decide "under 40%". What it may do is hand the secret to the screen: a colour curve
-- turns the percentage into an alpha of 1 (below the limit) or 0 (above), and SetAlpha accepts that secret. So the
-- game shows the line or keeps it invisible; MH never learns which. Same pattern as DandersFrames' HealthFade and MF
-- Nameplates (read as a candidate there; whether Forever's client accepts it is what /mh rest test shows).
-- Consequences, on purpose: no number in the text, no chat line, no sound (MH would not know when to make them).
--------------------------------------------------------------------------------

local curveCache = {}
local function AlphaCurve(limit)
	if curveCache[limit] then
		return curveCache[limit]
	end
	if not (C_CurveUtil and C_CurveUtil.CreateColorCurve and CreateColor) then
		return nil
	end
	local ok, curve = pcall(C_CurveUtil.CreateColorCurve)
	if not ok or not curve then
		return nil
	end
	if Enum and Enum.LuaCurveType and curve.SetType then
		pcall(curve.SetType, curve, Enum.LuaCurveType.Linear)
	end
	local show, hide = CreateColor(1, 1, 1, 1), CreateColor(1, 1, 1, 0)
	if limit > 100 then -- /mh rest test show: always visible, the positive control for the whole road
		curve:AddPoint(0, show)
		curve:AddPoint(1, show)
	else
		local pos = math.max(0.002, math.min(0.998, limit / 100))
		curve:AddPoint(0, show)
		curve:AddPoint(pos - 0.001, show)
		curve:AddPoint(pos + 0.001, hide)
		curve:AddPoint(1, hide)
	end
	curveCache[limit] = curve
	return curve
end

local hint
local function EnsureHint()
	if hint then
		return hint
	end
	local f = CreateFrame("Frame", "MidnightHelperRestHint", UIParent)
	f:SetSize(600, 80)
	f:SetPoint("TOP", UIParent, "TOP", 0, -230)
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	-- No background: its visibility would have to be "either line shows", and that is a secret too.
	local function line(y)
		local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
		t:SetPoint("TOP", f, "TOP", 0, y)
		t:SetTextColor(1, 0.85, 0.1)
		t:SetShadowOffset(2, -2)
		t:SetShadowColor(0, 0, 0, 1)
		return t
	end
	f.mana = line(0)
	f.health = line(-34)
	f:Hide()
	hint = f
	return f
end

--- Show the two lines for a few seconds; each one's alpha comes from the game. Returns what it could hand over.
local function ShowSecretHint(manaLimit, healthLimit)
	local f = EnsureHint()
	local function apply(fs, fn, limit, key, ...)
		fs:SetText(ns:L(key))
		local curve = AlphaCurve(limit)
		if not (curve and type(fn) == "function") then
			fs:SetAlpha(0)
			return false
		end
		local args = { ... }
		args[#args + 1] = curve
		local ok, color = pcall(fn, "player", unpack(args))
		if not ok or not color or not color.GetRGBA then
			fs:SetAlpha(0)
			return false
		end
		local _, _, _, a = color:GetRGBA()
		local okA = pcall(fs.SetAlpha, fs, a)
		if not okA then
			fs:SetAlpha(0)
		end
		return okA
	end
	local manaOk = false
	if HasManaBar() then
		manaOk = apply(f.mana, UnitPowerPercent, manaLimit, "FWARN_REST_LOW_MANA", MANA, false)
	else
		f.mana:SetAlpha(0)
	end
	local healthOk = apply(f.health, UnitHealthPercent, healthLimit, "FWARN_REST_LOW_HEALTH", false)
	f:Show()
	f._token = (f._token or 0) + 1
	local token = f._token
	C_Timer.After(4, function()
		if hint and hint._token == token then
			hint:Hide()
		end
	end)
	return manaOk, healthOk
end
ns._ForeverRestSecretHint = ShowSecretHint -- /mh rest test goes through the same door

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
	local mana, health = ManaPct(), HealthPct()
	if health == nil or (mana == nil and HasManaBar()) then
		-- Secret (Forever, measured): the game decides whether the lines are visible.
		-- NO 30-second pause here (Rob, 8 Nov 2026: "De ene keer komt hij wel, de andere keer komt hij niet"). The pause
		-- started on every enemy, also when the lines stayed invisible because your mana was fine, so the next enemy
		-- within 30 s got nothing even with low mana. MH cannot know whether it showed, so it cannot pause on it.
		restState.lastKey = key
		local mOk, hOk = ShowSecretHint(s.mana, s.health)
		restState.lastWhy = ("values are secret: handed to the screen (mana line %s, health line %s); the game decides "
			.. "if you see them"):format(mOk and "ok" or "could not", hOk and "ok" or "could not")
		return
	end
	if now - restState.lastAt < REST_GAP then -- readable path only: here MH knows it really warned
		restState.lastWhy = ("asked again within %d s: quiet"):format(REST_GAP)
		return
	end
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
-- 3. Fishing pole still in your hands
-- Rob, 9 Nov 2026: "als welke karakter dan ook een vishengel heeft in zijn handen en iets target die die eventueel aan
-- kan vallen, dat die waarschuwt" → plan (also when a fight starts; once per enemy, 30 s apart; /mh pole on|off;
-- remember the weapons from before) → "Ja, dit klopt zo. ... een mace en een shield, dat hij dat ook onthoudt".
-- MH never swaps the gear itself: whether that is allowed in a fight is not measured.
--------------------------------------------------------------------------------

local POLE_GAP = 30
local FISHING_SUBCLASS = (Enum and Enum.ItemWeaponSubclass and Enum.ItemWeaponSubclass.Fishingpole) or 20
local poleState = { lastAt = 0, lastKey = nil, lastWhy = "nothing checked yet" }

local function IsPole(itemID)
	if not itemID then
		return false
	end
	local info = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not info then
		return false
	end
	local ok, _, _, _, _, _, classID, subclassID = pcall(info, itemID)
	return ok and classID == 2 and subclassID == FISHING_SUBCLASS
end

local function PoleInHand()
	return IsPole(GetInventoryItemID and GetInventoryItemID("player", 16))
end

--- Remember main hand + off-hand (the shield too) while they are NOT a pole, per character, so the warning can say
--- what to put back. Saved in the character's own entry, so an alt never gets another character's weapons.
local function CharKey()
	local n, r = UnitFullName and UnitFullName("player")
	return n and (n .. "-" .. (r or GetRealmName() or "")) or nil
end

local function RememberGear()
	local d, key = ns.db, CharKey()
	if not (d and key) or PoleInHand() then
		return
	end
	d.foreverPoleGear = d.foreverPoleGear or {}
	d.foreverPoleGear[key] = {
		main = GetInventoryItemLink("player", 16),
		off = GetInventoryItemLink("player", 17),
	}
end

local function SavedGear()
	local d, key = ns.db, CharKey()
	local g = d and key and d.foreverPoleGear and d.foreverPoleGear[key]
	if type(g) ~= "table" then
		return nil
	end
	local list = {}
	if g.main then list[#list + 1] = g.main end
	if g.off then list[#list + 1] = g.off end
	return #list > 0 and table.concat(list, " + ") or nil
end

--- why: "target" (you picked an enemy) or "fight" (a fight started).
local function CheckPole(why)
	local s = Settings()
	if not s.pole then
		poleState.lastWhy = "switched off (/mh pole on)"
		return
	end
	if not PoleInHand() then
		poleState.lastWhy = "no fishing pole in your main hand"
		return
	end
	local key
	if why == "target" then
		if not (UnitExists("target") and UnitCanAttack("player", "target") == true) then
			return -- not an enemy: no decision to record
		end
		if UnitIsDead("target") == true then
			poleState.lastWhy = "target is dead"
			return
		end
		key = TargetKey()
		if key and key == poleState.lastKey then
			poleState.lastWhy = "same enemy as last time: told you once"
			return
		end
	end
	local now = GetTime()
	if now - poleState.lastAt < POLE_GAP then
		poleState.lastWhy = ("asked again within %d s: quiet"):format(POLE_GAP)
		return
	end
	poleState.lastAt, poleState.lastKey = now, key
	local msg = ns:L("FWARN_POLE_MSG")
	if ns.FireAccessibleAlert then
		ns.FireAccessibleAlert(msg, false, 5)
	end
	local gear = SavedGear()
	print(PREFIX .. msg .. (gear and (" " .. ns:L("FWARN_POLE_GEAR_FMT"):format(gear)) or "") ..
		" |cff888888" .. ns:L("FWARN_POLE_OFF_HINT") .. "|r")
	poleState.lastWhy = ("warned (%s)"):format(why == "fight" and "a fight started" or "you targeted an enemy")
end

function ns.ForeverPoleSlash(arg)
	local s = Settings()
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		s.pole = (arg == "on")
		print(PREFIX .. ns:L(s.pole and "FWARN_POLE_ON" or "FWARN_POLE_OFF"))
		return
	end
	print(PREFIX .. ("fishing pole warning: %s (/mh pole on||off)"):format(s.pole and "on" or "off"))
	print(("  main hand: %s, pole: %s"):format(tostring(GetInventoryItemLink("player", 16) or "empty"),
		PoleInHand() and "yes" or "no"))
	print("  remembered gear: " .. (SavedGear() or "nothing yet (equip your weapon once)"))
	print("  last decision: " .. poleState.lastWhy)
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
	print(PREFIX .. ("bags warning: %s, warns at %d free (/mh bags on||off, /mh bags <0-10>)"):format(
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
	elseif arg == "test" or arg == "test show" then
		-- The same door as a real enemy (ShowSecretHint). "test" uses your limits: visible only when you are below
		-- them. "test show" uses a limit above 100%: both lines must show; if they do not, the road itself is broken.
		local show = arg == "test show"
		local mOk, hOk = ShowSecretHint(show and 101 or s.mana, show and 101 or s.health)
		print(PREFIX .. ("rest test%s: mana line %s, health line %s. %s"):format(show and " show" or "",
			HasManaBar() and (mOk and "handed to the screen" or "COULD NOT") or "no mana bar",
			hOk and "handed to the screen" or "COULD NOT",
			show and "Both lines should be on your screen now." or
			("Visible only below %d%% mana / %d%% health."):format(s.mana, s.health)))
		return
	elseif (what == "mana" or what == "health") and num then
		s[what] = math.max(0, math.min(100, tonumber(num)))
		print(PREFIX .. ns:L(what == "mana" and "FWARN_REST_MANA_AT_FMT" or "FWARN_REST_HEALTH_AT_FMT"):format(s[what]))
		return
	end
	local mana, health = ManaPct(), HealthPct()
	-- "||" not "|": chat reads "|h" as the start of a link and ate "mana|health" into "manaealth" (Rob's screenshot).
	print(PREFIX .. ("rest warning: %s, mana under %d%%, health under %d%% (/mh rest on||off, /mh rest mana <n>, /mh rest health <n>, /mh rest test [show])")
		:format(s.rest and "on" or "off", s.mana, s.health))
	print(("  now: mana %s, health %s, fighting %s"):format(mana and (mana .. "%") or "none/unreadable",
		health and (health .. "%") or "unreadable", InFight() and "yes" or "no"))
	-- What the client really hands over (Rob, 8 Nov 2026: a priest read "mana none/unreadable, health unreadable").
	-- secret = the game hides the number from addons; nil = the call gave nothing; error = the call failed.
	local function raw(fn, ...)
		if type(fn) ~= "function" then
			return "no such API"
		end
		local ok, v = pcall(fn, ...)
		if not ok then
			return "error"
		end
		if Secret(v) then
			return "secret"
		end
		return tostring(v)
	end
	print(("  client: UnitHealth %s / max %s, UnitPower(mana) %s / max %s, power type %s"):format(
		raw(UnitHealth, "player"), raw(UnitHealthMax, "player"), raw(UnitPower, "player", MANA),
		raw(UnitPowerMax, "player", MANA), raw(UnitPowerType, "player")))
	local curve = CurveConstants and CurveConstants.ScaleTo100
	print(("  client: UnitHealthPercent %s, UnitPowerPercent(mana) %s"):format(
		raw(UnitHealthPercent, "player", false, curve), raw(UnitPowerPercent, "player", MANA, false, curve)))
	print("  last decision: " .. restState.lastWhy)
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:RegisterEvent("PLAYER_TARGET_CHANGED")
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_TARGET_CHANGED" then
		CheckRest()
		CheckPole("target")
	elseif event == "PLAYER_REGEN_DISABLED" then
		CheckPole("fight")
	elseif event == "PLAYER_EQUIPMENT_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
		-- Half a second later: taking a two-handed pole fires one event per slot, and a moment where the shield is
		-- already gone but the mace is still in hand would make MH forget the shield (AFGELEID; the delay is cheap).
		C_Timer.After(0.5, RememberGear)
	else
		if event == "BAG_UPDATE_DELAYED" or bagState.pending then
			CheckBags()
		end
		-- The game keeps you "in combat" a few seconds after a kill. Picking the next enemy in that time used to end
		-- in "already fighting"; when the fight state ends, look at the enemy you have selected once more.
		if event == "PLAYER_REGEN_ENABLED" then
			C_Timer.After(0.5, CheckRest)
		end
	end
end)
