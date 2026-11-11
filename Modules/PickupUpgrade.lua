local _, ns = ...

--[[
	PickupUpgrade.lua — "you just picked up an upgrade", on the screen (step d; Rob, 11 Nov 2026: "Ja, allebei").

	Rob: at low level you run around and things land in your bags by themselves; now you keep the bags open to see if an
	upgrade came in. So when a piece of gear ENTERS your bags and is clearly better than what you wear, a short notice
	says so (ns.ShowBriefNotice: fades by itself, draggable, Shift+scroll) and one line goes to chat as a record.

	How "entered" is seen: on BAG_UPDATE_DELAYED the item links in your bags are counted and compared with the last
	count. A link whose count went up is new. Not announced: the first count after login (that is what you already had),
	anything while a vendor or the bank is open (bought or moved on purpose), and a link you were wearing a moment ago
	(you took it off).
	The verdict, per game:
	  Forever   ns.ForeverGearTipText (ForeverQuestHint.lua): your class's main stats, Stamina, armor. Same as the green
	            tooltip line and the quest-reward hint, so all three say the same thing.
	  Midnight  ns.GetLootUpgradeInfo (VaultAdvisor.lua): item level + secondary stats with your spec's weights. Coarser,
	            and it needs a spec. Only a CLEAR upgrade counts: higher item level AND a better score.
	  Both      an item whose tooltip has a red line (you cannot wear or use it, or not yet) is skipped.
	In a fight the notice waits until the fight ends. /mh pickup [on|off] is the switch and prints the last decision.
]]

local PREFIX = "|cffffcc00Midnight Helper:|r "
local counts -- link -> how many; nil until the first count after login
local worn = {} -- links you wore at the last count
local pending = {} -- links waiting for item data, -> tries
local queued = {} -- notices that waited for the end of a fight
local last = "nothing picked up yet"

local function Enabled()
	return not (ns.db and ns.db.pickupUpgrade == false)
end

local function Open(frameName)
	local f = _G[frameName]
	return f and f.IsShown and f:IsShown()
end

local function BagCounts()
	local out = {}
	if not (C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerItemLink) then
		return nil
	end
	for bag = 0, (NUM_BAG_SLOTS or 4) do
		local ok, n = pcall(C_Container.GetContainerNumSlots, bag)
		for slot = 1, (ok and n or 0) do
			local okL, link = pcall(C_Container.GetContainerItemLink, bag, slot)
			if okL and type(link) == "string" and not (issecretvalue and issecretvalue(link)) then
				local info = C_Container.GetContainerItemInfo and C_Container.GetContainerItemInfo(bag, slot)
				local stack = (type(info) == "table" and tonumber(info.stackCount)) or 1
				out[link] = (out[link] or 0) + stack
			end
		end
	end
	return out
end

local function WornLinks()
	local out = {}
	for slot = 1, 19 do
		local link = GetInventoryItemLink and GetInventoryItemLink("player", slot)
		if link then
			out[link] = true
		end
	end
	return out
end

local function IsGear(link)
	local fn = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not fn then
		return false
	end
	local ok, _, _, _, equipLoc = pcall(fn, link)
	return ok and type(equipLoc) == "string" and equipLoc ~= "" and equipLoc ~= "INVTYPE_BAG"
		and equipLoc ~= "INVTYPE_NON_EQUIP_IGNORE" and equipLoc ~= "INVTYPE_AMMO" and equipLoc ~= "INVTYPE_QUIVER"
end

local function IsRed(c)
	return type(c) == "table" and type(c.r) == "number" and not (issecretvalue and issecretvalue(c.r))
		and c.r > 0.95 and (c.g or 1) < 0.35 and (c.b or 1) < 0.35
end

--- true = a red line (cannot use/wear), false = none, nil = the tooltip data is not there yet.
local function CannotUse(link)
	if not (C_TooltipInfo and C_TooltipInfo.GetHyperlink) then
		return false -- cannot look: let the verdict decide
	end
	local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" or #data.lines == 0 then
		return nil
	end
	for _, line in ipairs(data.lines) do
		if IsRed(line.leftColor) or IsRed(line.rightColor) then
			return true
		end
	end
	return false
end

local function ItemName(link)
	local fn = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	local ok, name = pcall(fn, link)
	return ok and name or nil
end

--- The notice text for this link, or nil plus why not; "wait" = the item data has not arrived yet.
local function Verdict(link)
	if not ItemName(link) then
		return nil, "wait"
	end
	local red = CannotUse(link)
	if red == nil then
		return nil, "wait"
	elseif red then
		return nil, "red line in the tooltip: you cannot use or wear it (yet)"
	end
	if ns.IS_FOREVER then
		if not ns.ForeverGearTipText then
			return nil, "Forever gear check not loaded"
		end
		local text, why, gains, reason = ns.ForeverGearTipText(link)
		if not text then
			return nil, why
		end
		return ns:L("PICKUP_FMT"):format(link, ns:L("PICKUP_DETAIL_FMT"):format(gains, reason))
	end
	if not ns.GetLootUpgradeInfo then
		return nil, "Midnight gear check not loaded"
	end
	local info = ns.GetLootUpgradeInfo(link)
	if not info then
		return nil, "no verdict (no spec yet, nothing worn in that slot, or no item level)"
	end
	if not ((info.ilvlDelta or 0) > 0 and (info.scoreDelta or 0) > 0) then
		return nil, ("not a clear upgrade (item level %+d, score %+.1f)"):format(info.ilvlDelta or 0, info.scoreDelta or 0)
	end
	return ns:L("PICKUP_FMT"):format(link, ns:L("PICKUP_MIDNIGHT_FMT"):format(info.newIlvl or 0, info.ilvlDelta,
		info.equippedName or "?"))
end

local function Announce(text)
	if InCombatLockdown and InCombatLockdown() then
		queued[#queued + 1] = text
		return
	end
	if ns.ShowBriefNotice then
		ns.ShowBriefNotice(text, 7)
	end
	print(PREFIX .. text)
end

local function Consider(link)
	local text, why = Verdict(link)
	if why == "wait" then
		pending[link] = (pending[link] or 0) + 1
		if pending[link] <= 5 and C_Timer and C_Timer.After then
			C_Timer.After(1, function()
				if pending[link] then
					Consider(link)
				end
			end)
		else
			pending[link] = nil
			last = link .. ": item data never arrived"
		end
		return
	end
	pending[link] = nil
	last = link .. ": " .. (text and "shown" or tostring(why))
	if text then
		Announce(text)
	end
end

local function Recount()
	local now = BagCounts()
	if not now then
		last = "bags cannot be read on this client"
		return
	end
	local wasWorn = worn
	worn = WornLinks()
	if not counts then
		counts = now -- first count after login: what you already carry
		return
	end
	local old = counts
	counts = now
	if not Enabled() or Open("MerchantFrame") or Open("BankFrame") then
		return
	end
	for link, n in pairs(now) do
		if n > (old[link] or 0) and not wasWorn[link] and IsGear(link) then
			Consider(link)
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		-- Bags can be half-loaded right after a loading screen: count again after a moment, without announcing.
		counts = nil
		if C_Timer and C_Timer.After then
			C_Timer.After(2, function()
				pcall(Recount)
			end)
		end
	elseif event == "BAG_UPDATE_DELAYED" then
		local ok, err = pcall(Recount)
		if not ok then
			last = "error: " .. tostring(err)
		end
	elseif event == "PLAYER_REGEN_ENABLED" and #queued > 0 then
		local list = queued
		queued = {}
		for _, text in ipairs(list) do
			Announce(text)
		end
	end
end)

--- /mh pickup [on|off]
function ns.PickupUpgradeSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		if ns.db then
			ns.db.pickupUpgrade = (arg == "on")
		end
		print(PREFIX .. ns:L(arg == "on" and "PICKUP_ON" or "PICKUP_OFF"))
		return
	end
	print(PREFIX .. ("pickup notice: %s; %s game check; last item: %s"):format(Enabled() and "on" or "off",
		ns.IS_FOREVER and "Forever" or "Midnight", last))
end
