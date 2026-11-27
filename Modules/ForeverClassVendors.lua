local _, ns = ...

--[[
	ForeverClassVendors.lua — WoW Forever: class reagents and ammunition — what you need, how many you have, and the
	nearest seller with the arrow.
	Rob, 27 Nov 2026, via Sparring 27-11, verbatim: "nr 4 ja" (idea 4 in docs/IDEEEN.md; Pathfinder Forever is All
	Rights Reserved: only the idea, own code; MMOBoom is not a source).

	Data: ForeverClassVendorData.lua (tools/forever_classvendors.py): which reagent each class spell uses and from which
	level (Blizzard DB2, GEMETEN; 0 of 23 spells off), the ammo per level (DB2), and the vendors (Zygor's lists).
	  Reagents: only for a spell you KNOW (IsPlayerSpell); for ranked spells (Rebirth, Gift of the Wild) the highest
	    rank you know decides the item. 0 in your bags = a to-do in Do this now; fewer than LOW = a tip.
	  Ammo: only with a bow or crossbow (arrows) or a gun (bullets) in your ranged slot. The best ammo for your level
	    (ItemSparse RequiredLevel). Fewer than one stack (200, ItemSparse VendorStackCount) = a tip, none = a to-do.
	    Whether Forever really uses up ammo: Zygor's own guide says so (GEMETEN in Zygor), in the game NOT measured.
	  Sellers: Find / /mh vendor reagent | arrows | bullets (a rogue's Flash Powder: /mh vendor thief, the same vendors,
	    GEMETEN by mh-research in QuestieDB: 18 of 18).
	LOW = 5 is MH's own choice (AFGELEID), not a game number.
	Switch: Quiet helpers "Class reagents and ammo in Do this now" / /mh vendor reagents on|off (default on).
	/mh vendor check prints the decision and the reason (a module that can stay quiet needs that, CLAUDE.md).
]]

if not ns.IS_FOREVER then
	return
end

local LOW = 5
local STACK = 200
local lastWhy = "not checked yet"

function ns.IsForeverClassVendLineOn()
	return not (type(ns.db) == "table" and ns.db.foreverClassVendLine == false)
end

function ns.SetForeverClassVendLine(on)
	ns.db = ns.db or {}
	if on then
		ns.db.foreverClassVendLine = nil -- on = the default
	else
		ns.db.foreverClassVendLine = false
	end
	if ns.ForeverDoNowUpdate then
		pcall(ns.ForeverDoNowUpdate)
	end
end

local function Readable(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

local function Count(id)
	local f = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not f then
		return 0
	end
	local ok, n = pcall(f, id)
	return (ok and Readable(n) and tonumber(n)) or 0
end

local function Knows(spell)
	if IsPlayerSpell then
		local ok, k = pcall(IsPlayerSpell, spell)
		if ok and Readable(k) and k then
			return true
		end
	end
	if IsSpellKnown then
		local ok, k = pcall(IsSpellKnown, spell)
		return ok and Readable(k) and k == true
	end
	return false
end

local function ItemName(id)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and type(n) == "string" and n ~= "" and Readable(n) then
			return n
		end
	end
	if C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, id)
	end
	return nil
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" and Readable(n) then
			return n
		end
	end
	if GetSpellInfo then
		local ok, n = pcall(GetSpellInfo, id)
		if ok and type(n) == "string" and n ~= "" and Readable(n) then
			return n
		end
	end
	return "#" .. tostring(id)
end

--- "arrows", "bullets" or nil: what your ranged weapon shoots (slot 18; bow 2 / crossbow 18 = arrows, gun 3 = bullets).
function ns.ForeverAmmoKind()
	if not GetInventoryItemID then
		return nil
	end
	local ok, id = pcall(GetInventoryItemID, "player", 18)
	if not (ok and type(id) == "number" and Readable(id)) then
		return nil
	end
	local f = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not f then
		return nil
	end
	local okI, _, _, _, _, _, class, sub = pcall(f, id)
	if not okI or class ~= 2 then
		return nil
	end
	if sub == 2 or sub == 18 then
		return "arrows"
	elseif sub == 3 then
		return "bullets"
	end
	return nil
end

--- The tier (1-4) of the best ammo your level can use, and that item.
function ns.ForeverAmmoTier(kind)
	local list = ns.FOREVER_AMMO and ns.FOREVER_AMMO[kind or ns.ForeverAmmoKind() or "arrows"] or {}
	local level = (UnitLevel and UnitLevel("player")) or 1
	local tier, item = 1, list[1] and list[1][1]
	for i, row in ipairs(list) do
		if level >= row[2] then
			tier, item = i, row[1]
		end
	end
	return tier, item
end

--- The nearest seller of a Find category ("reagent", "arrows", "bullets", "thief"): its Find row, or nil.
local function Nearest(key)
	if not ns.ForeverVendorFindRows then
		return nil
	end
	local ok, rows = pcall(ns.ForeverVendorFindRows, key)
	return ok and type(rows) == "table" and rows[1] or nil
end

local function SellerText(row)
	if not row then
		return ns:L("FCVEND_NO_SELLER")
	end
	return ns:L("FCVEND_SELLER_FMT"):format(row.name or "?", row.zone or "?",
		row.dist and (ns.ForeverTrainerDistance and ns.ForeverTrainerDistance(row.dist) or ("%d yd"):format(row.dist))
		or ns:L("FVEND_OTHER_CONT"))
end

--- The reagents your known spells need: { item, spell, have } per item (one per item, the first spell that needs it).
local function Needs()
	local _, token = UnitClass("player")
	local out, seen = {}, {}
	for _, g in ipairs((ns.FOREVER_CLASS_REAGENTS or {})[token or ""] or {}) do
		local pick
		for _, row in ipairs(g) do
			if Knows(row[1]) then
				pick = row
				if g.mode ~= "rank" then
					break
				end
			end
		end
		if pick and not seen[pick[2]] then
			seen[pick[2]] = true
			out[#out + 1] = { item = pick[2], spell = pick[1], have = Count(pick[2]) }
		end
	end
	return out, token
end

--- For Do this now: { text, key, now = true for a to-do } per line. key = the Find category of the seller.
function ns.ForeverClassVendorLines()
	if not ns.IsForeverClassVendLineOn() then
		lastWhy = "switched off (/mh vendor reagents on)"
		return {}
	end
	local out, why = {}, {}
	local needs, token = Needs()
	local key = (token == "ROGUE") and "thief" or "reagent"
	local seller
	for _, n in ipairs(needs) do
		local name = ItemName(n.item) or ("#" .. n.item)
		if n.have == 0 then
			seller = seller or Nearest(key)
			out[#out + 1] = { text = ns:L("FCVEND_NONE_FMT"):format(name, SpellName(n.spell), SellerText(seller),
				"/mh vendor " .. key), key = key, now = true }
		elseif n.have < LOW then
			seller = seller or Nearest(key)
			out[#out + 1] = { text = ns:L("FCVEND_LOW_FMT"):format(n.have, name, SellerText(seller), "/mh vendor " .. key),
				key = key }
		end
		why[#why + 1] = ("%s %d"):format(name, n.have)
	end
	local kind = ns.ForeverAmmoKind()
	if kind then
		local list = ns.FOREVER_AMMO and ns.FOREVER_AMMO[kind] or {}
		local have = 0
		for _, row in ipairs(list) do
			have = have + Count(row[1])
		end
		local _, best = ns.ForeverAmmoTier(kind)
		local name = best and (ItemName(best) or ("#" .. best)) or "?"
		if have < STACK then
			local row = Nearest(kind)
			out[#out + 1] = { text = ns:L(have == 0 and "FCVEND_AMMO_NONE_FMT" or "FCVEND_AMMO_LOW_FMT"):format(have, name,
				SellerText(row), "/mh vendor " .. kind), key = kind, now = have == 0 }
		end
		why[#why + 1] = ("%s: %d (best for your level: %s)"):format(kind, have, name)
	else
		why[#why + 1] = "no bow, crossbow or gun in your ranged slot"
	end
	lastWhy = (#needs == 0 and "no class reagent for a spell you know; " or "") .. table.concat(why, ", ")
		.. ("; %d line(s)"):format(#out)
	return out
end

function ns.ForeverClassVendorWhy()
	pcall(ns.ForeverClassVendorLines)
	return lastWhy
end
