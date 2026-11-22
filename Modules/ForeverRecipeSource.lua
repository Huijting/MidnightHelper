local _, ns = ...

--[[
	ForeverRecipeSource.lua — WoW Forever: "where do I get this recipe?" for a recipe you do not know.

	Rob, 22 Nov 2026 via sparring, verbatim: "1 b", "plek ja" (tooltip + MH's Skill up window), "overnemen, ja" and
	"alles advies" (Classic data may be the second source and MH says so; Polestar's CC BY recordings as a second source).
	Data, rule and credit: ForeverRecipeSourceData.lua.

	  "MH: The recipe is sold by Kendra (Stormwind City, 120 yd)"   an arrow only to an npc two sources name for THIS recipe
	  "MH: A trainer teaches this recipe"                           two sources for the kind, none for which trainer
	  "Needs: Nightclaw Druids (Friendly), Merchant's Favor"        reputation, payment, specialisation, class
	  "Classic data, not yet seen in Forever"                       the sources may carry old data
	Never "a trainer of that profession". Silent when not in the data or the recipe is the other side's.
	/mh skillup probe prints the last decision and the credit.
]]

if not ns.IS_FOREVER then
	return
end

local last = "none asked yet"
-- The two commerce factions are one condition, per side (DB2 Faction 2586 Alliance, 2587 Horde).
local SIDE_OF_FACTION = { [2586] = "A", [2587] = "H" }

local function Side()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" and "A") or (f == "Horde" and "H") or nil
end

--- The game's name in this client's language, else English.
local function Name(key)
	local all = ns.RECIPE_SOURCE_NAMES or {}
	local t = GetLocale and all[GetLocale()]
	return (t and t[key]) or (all.enUS and all.enUS[key])
end

--- The npcs of this recipe on your side, as vendor rows.
local function Spots(e, side)
	local out = {}
	if not side or (e.side and e.side ~= side) then
		return out
	end
	for _, v in ipairs(e.npc or {}) do
		local id = v < 0 and -v or v -- a negative id = this npc rests on possibly old Classic data
		local p = ns.RECIPE_NPC and ns.RECIPE_NPC[id]
		if p and (p[4] == "both" or p[4] == side) then
			out[#out + 1] = { npc = id, name = Name("N" .. id), map = p[1], x = p[2], y = p[3], side = p[4], old = v < 0 }
		end
	end
	return out
end

--- Cheap: would this recipe get an arrow for you? (Skill up sorts on it.)
function ns.ForeverRecipeHasArrow(spell)
	local e = ns.RECIPE_SOURCE and ns.RECIPE_SOURCE[spell]
	return e ~= nil and #Spots(e, Side()) > 0
end

local function Needs(e, side)
	local out = {}
	if e.spec then
		out[#out + 1] = Name("P" .. e.spec)
	end
	if e.class then
		out[#out + 1] = (LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[e.class]) or e.class
	end
	for _, r in ipairs(e.rep or {}) do
		local only = SIDE_OF_FACTION[r[1]]
		if not only or only == side then
			local name, level = Name("F" .. r[1]), _G["FACTION_STANDING_LABEL" .. r[2]]
			if name then
				out[#out + 1] = level and ("%s (%s)"):format(name, level) or name
			end
		end
	end
	for _, p in ipairs(e.pay or {}) do
		local name
		if p[1] == "c" then
			name = Name("C" .. p[2])
		elseif C_Item and C_Item.GetItemNameByID then
			local ok, n = pcall(C_Item.GetItemNameByID, p[2])
			name = (ok and type(n) == "string" and n ~= "") and n or nil
			if not name and C_Item.RequestLoadItemDataByID then
				pcall(C_Item.RequestLoadItemDataByID, p[2])
			end
			name = name or ns:L("FVEND_ITEM_LOADING")
		end
		if name then
			out[#out + 1] = name
		end
	end
	return #out > 0 and table.concat(out, ", ") or nil
end

local PLAIN = { T = "FRSRC_TRAINER", S = "FRSRC_SOLD", D = "FRSRC_DROP", Q = "FRSRC_QUEST", K = "FRSRC_START" }
local NAMED = { T = "FRSRC_TRAINER_FMT", S = "FRSRC_SOLD_FMT" }

--- The lines for this recipe and, with an arrow, the row { npc, name, zone, dist, go }; or nil.
function ns.ForeverRecipeSourceLines(spell)
	local e = spell and ns.RECIPE_SOURCE and ns.RECIPE_SOURCE[spell]
	if not e then
		last = ("recipe %s: silent, not among the recipes with two sources"):format(tostring(spell))
		return nil
	end
	local side = Side()
	if e.side and e.side ~= side then
		last = ("recipe %d: silent, the other side's recipe or your side not readable"):format(spell)
		return nil
	end
	local spots, row = Spots(e, side), nil
	if #spots > 0 and NAMED[e.k] and ns.ForeverVendorNearestOf then
		row = ns.ForeverVendorNearestOf(spots, e.k == "T")
	end
	local lines = {}
	if row then
		lines[1] = ns:L(NAMED[e.k]):format(row.name, row.zone .. (row.dist and (", " .. row.dist) or ""))
	else
		lines[1] = ns:L(PLAIN[e.k])
	end
	local needs = Needs(e, side)
	if needs then
		lines[#lines + 1] = ns:L("FRSRC_NEEDS_FMT"):format(needs)
	end
	local old = e.old
	if row then
		old = row.old
	end
	if old then
		lines[#lines + 1] = ns:L("FRSRC_CLASSIC")
	end
	last = ("recipe %d: kind %s, %s%s"):format(spell, e.k, row and ("arrow possible to npc " .. row.npc)
		or "no npc with two sources and a point on your side", old and ", Classic data" or "")
	return lines, row
end

--- For /mh skillup probe.
function ns.ForeverRecipeSourceLast()
	return last, "includes Polestar Recorder sessions by the Polestar authors, CC BY 4.0, github.com/fitzforge/polestar"
end
