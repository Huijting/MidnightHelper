local _, ns = ...

--[[
	ForeverWear.lua — WoW Forever: "Upgrade: <item>" in Do this now, with [Wear it] and [Not this one].
	Rob, 23 Nov 2026 via Sparring 23-11, verbatim: "Ja, doe maar OR-B. Maar dan moet je wel opvallen dat hij erin staat.
	En als er meerdere zijn in je tas, dan moet het ook blijven staan." (OR-B = "wear B": a line in Do this now, no new
	window, plus a switch). The idea came from Polestar's upgrade notice; Polestar is GPL, so only the idea: own code.

	The verdict is MH's own and the only one: ns.ForeverGearTipText (ForeverQuestHint.lua), the green "MH: +3 Intellect"
	tooltip line and the pickup notice. So the three always agree. An item with a red tooltip line (you cannot wear it
	yet) is skipped, as the pickup notice does.
	Every upgrade in your bags gets its own line and stays until you wear it or click [Not this one] (remembered per
	item link, /mh wear reset forgets). After wearing one, the list is worked out again: the next item may no longer be
	better than what you now wear.
	[Wear it] equips with the game's own call, from your click, never in combat (the line says why). A Bind on Equip
	item still gets the game's own "bind it to you?" question. Switch: Settings "Show upgrades in Do this now".
	/mh wear why = every piece of gear in your bags with MH's verdict and the reason.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local GOOD = "|cff7fff7f"
local UP = "|TInterface\\Buttons\\Arrow-Up-Up:14:14|t"
local list = {} -- the last list shown, so a clicked [Wear it] / [Not this one] finds its item (index in the link)
local lastWhy = "not checked yet"

function ns.IsForeverWearOn()
	return not (type(ns.db) == "table" and ns.db.foreverWear == false)
end

function ns.SetForeverWear(v)
	ns.db = ns.db or {}
	if v then
		ns.db.foreverWear = nil -- on = the default
	else
		ns.db.foreverWear = false
	end
	if ns.ForeverDoNowUpdate then
		pcall(ns.ForeverDoNowUpdate)
	end
end

local function Skipped()
	ns.db = ns.db or {}
	if type(ns.db.foreverWearSkip) ~= "table" then
		ns.db.foreverWearSkip = {}
	end
	return ns.db.foreverWearSkip
end

local function IsRed(c)
	return type(c) == "table" and type(c.r) == "number" and not (issecretvalue and issecretvalue(c.r))
		and c.r > 0.95 and (c.g or 1) < 0.35 and (c.b or 1) < 0.35
end

--- true = a red tooltip line (cannot wear it yet), false = none, nil = no tooltip data yet.
local function CannotUse(link)
	if not (C_TooltipInfo and C_TooltipInfo.GetHyperlink) then
		return false
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

local function EquipLoc(link)
	local fn = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not fn then
		return nil
	end
	local ok, _, _, _, loc = pcall(fn, link)
	return ok and type(loc) == "string" and loc ~= "" and loc or nil
end

local SKIP_LOC = { INVTYPE_BAG = true, INVTYPE_NON_EQUIP_IGNORE = true, INVTYPE_AMMO = true, INVTYPE_QUIVER = true }

--- Every piece of gear in your bags with the verdict: { bag, slot, link, loc, ok, why, gains, reason, inv }.
local function Scan()
	local out = {}
	local C = C_Container
	if not (C and C.GetContainerNumSlots and C.GetContainerItemLink) then
		return out, "bags cannot be read on this client"
	end
	for bag = 0, (NUM_BAG_SLOTS or 4) do
		local okN, n = pcall(C.GetContainerNumSlots, bag)
		for slot = 1, (okN and n or 0) do
			local okL, link = pcall(C.GetContainerItemLink, bag, slot)
			if okL and type(link) == "string" and not (issecretvalue and issecretvalue(link)) then
				local loc = EquipLoc(link)
				if loc and not SKIP_LOC[loc] then
					local e = { bag = bag, slot = slot, link = link, loc = loc }
					if Skipped()[link] then
						e.why = "you clicked Not this one (/mh wear reset forgets)"
					else
						local red = CannotUse(link)
						if red then
							e.why = "red line in the tooltip: you cannot wear it (yet)"
						elseif red == nil then
							e.why = "tooltip data not there yet"
						elseif not ns.ForeverGearTipText then
							e.why = "gear check not loaded"
						else
							local okV, text, why, gains, reason, inv = pcall(ns.ForeverGearTipText, link)
							if not okV then
								e.why = "gear check failed: " .. tostring(text)
							elseif text then
								e.ok, e.gains, e.reason, e.inv = true, gains, reason, inv
							else
								e.why = why or "not better"
							end
						end
					end
					out[#out + 1] = e
				end
			end
		end
	end
	return out
end

--- The upgrades in your bags, one per item link (two of the same in your bags = one line).
local function Upgrades()
	if not ns.IsForeverWearOn() then
		lastWhy = "switched off in the settings"
		return {}
	end
	local all, why = Scan()
	if why then
		lastWhy = why
		return {}
	end
	local out, seen = {}, {}
	for _, e in ipairs(all) do
		if e.ok and not seen[e.link] then
			seen[e.link] = true
			out[#out + 1] = e
		end
	end
	lastWhy = ("%d piece(s) of gear in your bags, %d upgrade(s)"):format(#all, #out)
	return out
end

local function SlotName(loc)
	local s = loc and _G[loc]
	return type(s) == "string" and s or ""
end

--- For Do this now: { text = line with [Wear it] [Not this one], plain = the same without them, n = index }.
function ns.ForeverWearLines()
	list = Upgrades()
	local out = {}
	local combat = InCombatLockdown and InCombatLockdown()
	for i, e in ipairs(list) do
		local base = ns:L("FWEAR_LINE_FMT"):format(e.link, SlotName(e.loc), e.gains or "")
		local wear = combat and ("|cff9d9d9d" .. ns:L("FWEAR_COMBAT") .. "|r")
			or ("|Hmhwear:wear:" .. i .. "|h" .. GOOD .. "[" .. ns:L("FWEAR_BTN") .. "]|r|h")
		local skip = "|Hmhwear:skip:" .. i .. "|h|cffaaaaaa[" .. ns:L("FWEAR_SKIP") .. "]|r|h"
		out[#out + 1] = { text = UP .. " " .. GOOD .. base .. "|r  " .. wear .. "  " .. skip, plain = base, n = i,
			link = e.link }
	end
	return out
end

--- [Wear it] for line n (also the overview's button). From a click only; never in combat.
function ns.ForeverWearGo(n)
	local e = list[tonumber(n) or 1]
	if not e then
		print(PREFIX .. ns:L("FWEAR_GONE"))
		return false
	end
	if InCombatLockdown and InCombatLockdown() then
		print(PREFIX .. ns:L("FWEAR_COMBAT"))
		return false
	end
	-- The item may have moved since the list was made: find the same link again.
	local C = C_Container
	local okL, now = pcall(C.GetContainerItemLink, e.bag, e.slot)
	if not (okL and now == e.link) then
		local found
		for _, x in ipairs((Scan())) do
			if x.link == e.link then
				found = x
				break
			end
		end
		if not found then
			print(PREFIX .. ns:L("FWEAR_GONE"))
			return false
		end
		e.bag, e.slot = found.bag, found.slot
	end
	local equip = (C_Item and C_Item.EquipItemByName) or EquipItemByName
	if not equip then
		print(PREFIX .. "this client has no EquipItemByName.")
		return false
	end
	local ok, err = pcall(equip, e.link, e.inv)
	if not ok then
		print(PREFIX .. ns:L("FWEAR_FAILED_FMT"):format(tostring(err)))
		return false
	end
	print(PREFIX .. ns:L("FWEAR_DONE_FMT"):format(e.link))
	return true
end

--- [Not this one] for line n: never offer this item link again.
function ns.ForeverWearSkip(n)
	local e = list[tonumber(n) or 1]
	if not e then
		return
	end
	Skipped()[e.link] = true
	print(PREFIX .. ns:L("FWEAR_SKIPPED_FMT"):format(e.link))
	if ns.ForeverDoNowUpdate then
		pcall(ns.ForeverDoNowUpdate)
	end
end

--- A click on one of our links in the Do this now text. true = it was ours.
function ns.ForeverWearLinkClick(link)
	local what, n = tostring(link):match("^mhwear:(%a+):(%d+)$")
	if what == "wear" then
		ns.ForeverWearGo(n)
		return true
	elseif what == "skip" then
		ns.ForeverWearSkip(n)
		return true
	end
	return false
end

--- Hovering one of our links: the item's own tooltip for [Wear it], a short sentence for [Not this one].
function ns.ForeverWearLinkEnter(owner, link)
	local what, n = tostring(link):match("^mhwear:(%a+):(%d+)$")
	if not what or not GameTooltip then
		return false
	end
	local e = list[tonumber(n)]
	GameTooltip:SetOwner(owner, "ANCHOR_CURSOR")
	if what == "wear" and e then
		pcall(GameTooltip.SetHyperlink, GameTooltip, e.link)
	else
		GameTooltip:SetText(ns:L("FWEAR_SKIP_TIP"), 1, 1, 1, 1, true)
	end
	GameTooltip:Show()
	return true
end

--- /mh wear [why | reset]
function ns.ForeverWearSlash(arg)
	arg = (arg or ""):lower()
	if arg == "reset" then
		ns.db = ns.db or {}
		ns.db.foreverWearSkip = nil
		print(PREFIX .. ns:L("FWEAR_RESET"))
		if ns.ForeverDoNowUpdate then
			pcall(ns.ForeverDoNowUpdate)
		end
		return
	end
	local all, why = Scan()
	print(PREFIX .. ("upgrades in Do this now: %s. %s"):format(ns.IsForeverWearOn() and "on" or "off", why or lastWhy))
	for _, e in ipairs(all) do
		print(("  %s (%s, bag %d slot %d): %s"):format(e.link, e.loc, e.bag, e.slot,
			e.ok and ("UPGRADE: " .. tostring(e.gains) .. " (" .. tostring(e.reason) .. "), slot " .. tostring(e.inv))
			or tostring(e.why)))
	end
	if #all == 0 then
		print("  no gear in your bags.")
	end
end
