local _, ns = ...

--[[
	ForeverReagentSource.lua — WoW Forever: "where do I get this?" for a crafting reagent.

	Rob, 22 Nov 2026 via sparring, verbatim: "1 b" (option B), "plek ja" (the tooltip is the main place, plus MH's own
	Skill up window) and later that day "overnemen, ja" (places and numbers from Zygor; no texts, notes or code).
	Data + rule: ForeverReagentSourceData.lua.

	One line:
	  "MH: Gathered with Mining"
	  "MH: Dropped by monsters"                  no place on purpose
	  "MH: Sold by Felika (Orgrimmar, 120 yd)"   the nearest seller MH KNOWS on your side (not every seller is known,
	                                              so the text never says "nearest")
	Silent when the item is not in the data, or when no seller of your side is known: not knowing is not a place.
	Shown by ReagentUse.lua's tooltip hook (the same switch, /mh usedfor on|off) and in the Skill up shopping list, where
	a button sets the arrow. /mh usedfor prints the last decision and why.
]]

if not ns.IS_FOREVER then
	return
end

local last = "none asked yet"

local function ByLanguage(all)
	local loc = GetLocale and GetLocale()
	return (all and loc and all[loc]) or (all and all.enUS) or {}
end

--- The seller row for this item on your side ({ name, zone, dist, go }), or nil plus why.
function ns.ForeverReagentSeller(id)
	local list = id and ns.REAGENT_SOLD_BY and ns.REAGENT_SOLD_BY[id]
	if not list then
		return nil, "no seller list"
	end
	if not ns.ForeverVendorSoldBy then
		return nil, "the vendor list is not loaded"
	end
	local set = {}
	for _, npc in ipairs(list) do
		set[npc] = true
	end
	local row = ns.ForeverVendorSoldBy(id, set, ByLanguage(ns.REAGENT_SELLER_NAMES))
	if not row then
		return nil, "no known seller on your side"
	end
	return row
end

--- The line for this item and, when it is sold, the seller row; or nil plus nil (the reason is in /mh usedfor).
function ns.ForeverReagentSourceText(id)
	local code = id and ns.REAGENT_GATHERED and ns.REAGENT_GATHERED[id]
	if code then
		local name = ByLanguage(ns.REAGENT_GATHER_NAMES)[code]
		if name then
			last = ("item %d: gathered (%s)"):format(id, code)
			return ns:L("FSRC_GATHER_FMT"):format(name)
		end
	end
	if id and ns.REAGENT_SOLD_BY and ns.REAGENT_SOLD_BY[id] then
		local row, why = ns.ForeverReagentSeller(id)
		if row then
			local where = row.zone .. (row.dist and (", " .. row.dist) or "")
			last = ("item %d: sold by npc %s, %s"):format(id, tostring(row.npc), row.dist and "nearest known by distance"
				or "position or continent unknown: first by name")
			return ns:L("FSRC_BUY_FMT"):format(row.name, where), row
		end
		last = ("item %d: silent, %s"):format(id, tostring(why))
		return nil
	end
	if id and ns.REAGENT_DROPS and ns.REAGENT_DROPS[id] then
		last = ("item %d: monsters drop it (no place)"):format(id)
		return ns:L("FSRC_DROP")
	end
	last = ("item %s: silent, not among the items with two sources"):format(tostring(id))
	return nil
end

--- For /mh usedfor.
function ns.ForeverReagentSourceLast()
	return last
end
