--[[
	Durability warning (Rob, 27 sep 2026).

	Rob showed "Ready Check Marks & Buffs" (All Rights Reserved: the IDEA only, no code) and
	asked what MH could use. Measured that morning: nothing in MH looked at durability at all.
	Blizzard's own armour doll only appears once gear is nearly broken; this says it earlier,
	at the two moments it still helps: walking into content, and a ready check.

	⚠️ CENTRE OF THE SCREEN, NOT ONLY CHAT. Rob, 3 sep: "niemand kijkt in de chat". The warning
	uses the raid-warning frame (plain UI, no protected call) and ALSO prints a chat line, so
	there is a record with the item link after the big text has faded.

	Silence is the normal outcome here, so `/mh durability` prints the decision and the reason,
	and `/mh durability test` runs the real warning path with the real numbers.
]]

local _, ns = ...

local DEFAULT_THRESHOLD = 30
local MIN_THRESHOLD, MAX_THRESHOLD = 5, 80

-- Every slot that can wear out. Shirt (4) and tabard (19) never do; the rest simply
-- return nil when empty or when the item has no durability (trinkets, rings).
local SLOTS = { 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18 }

local function Db()
	return ns.db and ns.db.ui
end

function ns.IsDurabilityWarnEnabled()
	local ui = Db()
	return not (type(ui) == "table" and ui.durabilityWarn == false)
end

function ns.SetDurabilityWarnEnabled(v)
	local ui = Db()
	if type(ui) == "table" then
		ui.durabilityWarn = v and true or false
	end
end

function ns.GetDurabilityThreshold()
	local ui = Db()
	local v = type(ui) == "table" and tonumber(ui.durabilityThreshold) or nil
	if not v then
		return DEFAULT_THRESHOLD
	end
	return math.max(MIN_THRESHOLD, math.min(MAX_THRESHOLD, v))
end

function ns.SetDurabilityThreshold(v)
	local ui = Db()
	if type(ui) == "table" then
		ui.durabilityThreshold = math.floor((tonumber(v) or DEFAULT_THRESHOLD) + 0.5)
	end
end

ns.DurabilityThresholdBounds = { min = MIN_THRESHOLD, max = MAX_THRESHOLD, default = DEFAULT_THRESHOLD }

local function Secret(v)
	return issecretvalue and issecretvalue(v)
end

--- The worst slot and the whole-set average, both in percent.
--- @return number|nil lowest, number|nil slot, number|nil average, table perSlot
function ns.GetDurabilityState()
	local lowest, lowSlot = nil, nil
	local cur, max = 0, 0
	local per = {}
	if not GetInventoryItemDurability then
		return nil, nil, nil, per
	end
	for _, slot in ipairs(SLOTS) do
		local ok, c, m = pcall(GetInventoryItemDurability, slot)
		if ok and c and m and not Secret(c) and not Secret(m) and m > 0 then
			local pct = c / m * 100
			per[#per + 1] = { slot = slot, pct = pct }
			cur, max = cur + c, max + m
			if not lowest or pct < lowest then
				lowest, lowSlot = pct, slot
			end
		end
	end
	local avg = max > 0 and (cur / max * 100) or nil
	return lowest, lowSlot, avg, per
end

local function SlotLink(slot)
	if slot and GetInventoryItemLink then
		local ok, link = pcall(GetInventoryItemLink, "player", slot)
		if ok and type(link) == "string" then
			return link
		end
	end
	return nil
end

local function Prefix()
	return ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
end

--- Show the warning. Same path for the real trigger and for `/mh durability test`.
local function Warn(lowest, slot)
	local pct = math.floor(lowest + 0.5)
	local big = ns:L("DURABILITY_WARN_FMT"):format(pct)
	if RaidNotice_AddMessage and RaidWarningFrame then
		local info = ChatTypeInfo and ChatTypeInfo["RAID_WARNING"] or { r = 1, g = 0.3, b = 0.1 }
		pcall(RaidNotice_AddMessage, RaidWarningFrame, big, info)
	end
	local link = SlotLink(slot)
	print(("%s %s%s"):format(Prefix(), big,
		link and (" " .. ns:L("DURABILITY_WORST_FMT"):format(link)) or ""))
end

--- @return boolean warned, string reason
local function Evaluate(force)
	if not force and not ns.IsDurabilityWarnEnabled() then
		return false, "turned off in settings"
	end
	local lowest, slot = ns.GetDurabilityState()
	if not lowest then
		return false, "no durability could be read"
	end
	local limit = ns.GetDurabilityThreshold()
	if not force and lowest >= limit then
		return false, ("lowest item %.0f%% is not below %d%%"):format(lowest, limit)
	end
	Warn(lowest, slot)
	return true, ("lowest item %.0f%%, limit %d%%"):format(lowest, limit)
end

-- Walking into content. One warning per instance, not one per loading screen.
local lastInstance
local function InContentKey()
	if not IsInInstance then
		return nil
	end
	local inside, kind = IsInInstance()
	if not inside or not (kind == "party" or kind == "raid" or kind == "scenario") then
		return nil
	end
	local id = GetInstanceInfo and select(8, GetInstanceInfo())
	return tostring(kind) .. ":" .. tostring(id)
end

local function CheckOnEntry()
	local key = InContentKey()
	if not key then
		lastInstance = nil
		return
	end
	if key == lastInstance then
		return
	end
	lastInstance = key
	Evaluate(false)
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("READY_CHECK")
ev:SetScript("OnEvent", function(_, event)
	if event == "READY_CHECK" then
		Evaluate(false)
		return
	end
	-- Durability and instance info settle a moment after the loading screen.
	if C_Timer and C_Timer.After then
		C_Timer.After(2, CheckOnEntry)
	else
		CheckOnEntry()
	end
end)

--- `/mh durability` prints the decision and the numbers; `/mh durability test` shows the
--- real warning with your real lowest item, whatever the limit.
function ns.DurabilityCommand(arg)
	if arg == "test" then
		local warned, why = Evaluate(true)
		if not warned then
			print(("%s durability test: nothing shown -- %s"):format(Prefix(), why))
		end
		return
	end
	local lowest, slot, avg, per = ns.GetDurabilityState()
	print(("%s durability: warning %s, limit %d%%"):format(Prefix(),
		ns.IsDurabilityWarnEnabled() and "on" or "off", ns.GetDurabilityThreshold()))
	if not lowest then
		print("   no durability could be read (no gear with durability equipped?)")
		return
	end
	print(("   lowest %.0f%% (slot %d) %s · all gear together %.0f%%"):format(
		lowest, slot or 0, SlotLink(slot) or "", avg or 0))
	for _, p in ipairs(per) do
		if p.pct < 100 then
			print(("      slot %2d  %3.0f%%  %s"):format(p.slot, p.pct, SlotLink(p.slot) or ""))
		end
	end
	local key = InContentKey()
	print(("   inside a dungeon/raid/delve now: %s · would warn: %s"):format(
		key and "yes" or "no", (lowest < ns.GetDurabilityThreshold()) and "yes" or "no"))
	print("   it warns on entering a dungeon, raid or delve, and on a ready check. "
		.. "/mh durability test shows it now.")
end
