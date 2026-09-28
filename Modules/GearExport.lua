local _, ns = ...

--[[
	Midnight Helper — `/mh export`: your equipped gear and the equippable items in your bags, as
	text for the Midnight Helper Armory website ("Calculate best set").

	Why the addon: Blizzard's web API returns what you WEAR, never what is in your bags. So the
	bags have to come from the client, as text a player copies and pastes.

	🔴 THE FORMAT IS A CONTRACT WITH THE WEBSITE (docs from Rob, 28 Sep 2026). Do not change a
	field, its order or a slot name without changing the site in the same breath:

	    MH-EXPORT 1
	    char=<name>;class=<CLASSFILE>;spec=<spec name>
	    # where|slot|ilvl|quality|name|str|sta|crit|haste|mast|vers
	    E|head|285|epic|Helm of ...|541|839|121|81|0|0

	  where    E = equipped, B = in the bags
	  slot     head neck shoulder back chest wrist hands waist legs feet finger trinket mainhand offhand
	  ilvl     the real item level (C_Item.GetDetailedItemLevelInfo), not the base
	  quality  epic | rare (anything else is written as epic; the site only colours with it)
	  name     the client's item name, a "|" in it becomes "/"
	  str      the PRIMARY stat, Strength + Agility + Intellect added up, despite the column name
	  numbers  whole numbers, a missing stat is 0

	Reused, not rebuilt: the copy window is the one /mh binds and the delve share use
	(ns.ShowShareCopyDialog: draggable, Escape closes, text focused and selected). The API calls are
	the ones VaultAdvisor.lua and GearEnchantCheck.lua already make on 12.1.

	Items the client has not cached yet have no name or stats. They are counted, their data is
	requested, and the text rebuilds itself once GET_ITEM_INFO_RECEIVED has gone quiet -- the same
	settle-then-redraw the How you play window uses for its Consumables tab.
]]

-- Equipped inventory slots in contract order. 4 (shirt) and 19 (tabard) are left out.
-- The slot NAME comes from the inventory slot, not the item: a one-hand weapon in slot 17 is an
-- offhand. Slot numbers as VaultAdvisor.lua:143-164 maps them (INVTYPE -> inventory slot).
local EQUIPPED = {
	{ 1, "head" }, { 2, "neck" }, { 3, "shoulder" }, { 15, "back" }, { 5, "chest" }, { 9, "wrist" },
	{ 10, "hands" }, { 6, "waist" }, { 7, "legs" }, { 8, "feet" }, { 11, "finger" }, { 12, "finger" },
	{ 13, "trinket" }, { 14, "trinket" }, { 16, "mainhand" }, { 17, "offhand" },
}

-- Bag items: equip location -> slot name. Shirt, tabard, bags, profession gear and anything else
-- is not in the contract and is skipped.
local LOC_TO_SLOT = {
	INVTYPE_HEAD = "head", INVTYPE_NECK = "neck", INVTYPE_SHOULDER = "shoulder",
	INVTYPE_CLOAK = "back", INVTYPE_CHEST = "chest", INVTYPE_ROBE = "chest",
	INVTYPE_WRIST = "wrist", INVTYPE_HAND = "hands", INVTYPE_WAIST = "waist",
	INVTYPE_LEGS = "legs", INVTYPE_FEET = "feet", INVTYPE_FINGER = "finger",
	INVTYPE_TRINKET = "trinket",
	INVTYPE_WEAPON = "mainhand", INVTYPE_WEAPONMAINHAND = "mainhand", INVTYPE_2HWEAPON = "mainhand",
	-- VERIFY: not in the contract's list, but a ranged weapon sits in the main hand (slot 16,
	-- VaultAdvisor.lua:163-164). Written as mainhand so a hunter's bow is not silently dropped.
	INVTYPE_RANGED = "mainhand", INVTYPE_RANGEDRIGHT = "mainhand",
	INVTYPE_WEAPONOFFHAND = "offhand", INVTYPE_SHIELD = "offhand", INVTYPE_HOLDABLE = "offhand",
}

-- C_Item.GetItemStats keys. Crit, haste, mastery, versatility (both spellings) and intellect are
-- the keys VaultAdvisor.lua:469-474 reads on 12.1.
-- VERIFY: ITEM_MOD_STRENGTH_SHORT, ITEM_MOD_AGILITY_SHORT and ITEM_MOD_STAMINA_SHORT are not read
-- anywhere in MH yet; they are the GlobalStrings names other installed addons use for the same
-- table (BetterCharacterPanel.lua:358-359). Test on a strength or agility character.
local PRIMARY_KEYS = { "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_AGILITY_SHORT", "ITEM_MOD_INTELLECT_SHORT" }

local function Num(v)
	if v == nil or ns.IsSecretValue(v) then
		return 0
	end
	v = tonumber(v) or 0
	return math.floor(v + 0.5)
end

local function Stats(link)
	local out = { str = 0, sta = 0, crit = 0, haste = 0, mast = 0, vers = 0 }
	if not (C_Item and C_Item.GetItemStats) then
		return out
	end
	local ok, s = pcall(C_Item.GetItemStats, link)
	if not ok or type(s) ~= "table" then
		return out
	end
	for _, k in ipairs(PRIMARY_KEYS) do
		out.str = out.str + Num(s[k])
	end
	out.sta = Num(s.ITEM_MOD_STAMINA_SHORT)
	out.crit = Num(s.ITEM_MOD_CRIT_RATING_SHORT)
	out.haste = Num(s.ITEM_MOD_HASTE_RATING_SHORT)
	out.mast = Num(s.ITEM_MOD_MASTERY_RATING_SHORT)
	out.vers = Num(s.ITEM_MOD_VERSATILITY or s.ITEM_MOD_VERSATILITY_SHORT)
	return out
end

local function ItemLevel(link)
	if C_Item and C_Item.GetDetailedItemLevelInfo then
		local ok, ilvl = pcall(C_Item.GetDetailedItemLevelInfo, link)
		if ok then
			return Num(ilvl)
		end
	end
	return 0
end

local function EquipLoc(link)
	if not (C_Item and C_Item.GetItemInfoInstant) then
		return nil
	end
	local ok, _, _, _, loc = pcall(C_Item.GetItemInfoInstant, link)
	if ok and ns.CanAccessText(loc) then
		return loc
	end
	return nil
end

--- One line, or nil plus "pending" when the client has not cached the item yet.
local function Line(where, slot, link)
	if not (C_Item and C_Item.GetItemInfo) then
		return nil
	end
	local ok, name, _, quality = pcall(C_Item.GetItemInfo, link)
	if not ok or not ns.CanAccessText(name) or name == "" then
		local id = link:match("item:(%d+)")
		if id and C_Item.RequestLoadItemDataByID then
			pcall(C_Item.RequestLoadItemDataByID, tonumber(id))
		end
		return nil, "pending"
	end
	-- Enum.ItemQuality: 3 = Rare, 4 = Epic. The site only colours with it (contract).
	local q = (not ns.IsSecretValue(quality) and quality == 3) and "rare" or "epic"
	name = (name:gsub("|", "/"):gsub("[\r\n]", " "))
	local s = Stats(link)
	return ("%s|%s|%d|%s|%s|%d|%d|%d|%d|%d|%d"):format(
		where, slot, ItemLevel(link), q, name, s.str, s.sta, s.crit, s.haste, s.mast, s.vers)
end

local function Link(ok, v)
	return ok and ns.CanAccessText(v) and v ~= "" and v or nil
end

--- Build the export text.
--- @return string text, number items, number pending
function ns.BuildGearExport()
	local lines, items, pending = {}, 0, 0

	local charName = (UnitName and UnitName("player")) or "?"
	local classFile = UnitClass and select(2, UnitClass("player")) or "?"
	local specName = "?"
	if GetSpecialization and GetSpecializationInfo then
		local idx = GetSpecialization()
		local sname = idx and select(2, GetSpecializationInfo(idx))
		if ns.CanAccessText(sname) then
			specName = sname
		end
	end
	lines[#lines + 1] = "MH-EXPORT 1"
	-- Parentheses around each gsub: it returns two values, and the count would slide into the next %s.
	lines[#lines + 1] = ("char=%s;class=%s;spec=%s"):format(
		(tostring(charName):gsub("[;|=]", "")), tostring(classFile), (tostring(specName):gsub("[;|=]", "")))
	lines[#lines + 1] = "# where|slot|ilvl|quality|name|str|sta|crit|haste|mast|vers"

	local function Add(where, slot, link)
		local line, why = Line(where, slot, link)
		if line then
			lines[#lines + 1] = line
			items = items + 1
		elseif why == "pending" then
			pending = pending + 1
		end
	end

	for _, e in ipairs(EQUIPPED) do
		local link = GetInventoryItemLink and Link(pcall(GetInventoryItemLink, "player", e[1]))
		if link then
			Add("E", e[2], link)
		end
	end

	-- Backpack (0) and the four bag slots. The reagent bag (5) is left out. VERIFY: NUM_BAG_SLOTS is
	-- 4 on retail; the repo's own bag loops use 0-4 (DelveItemsPopup.lua:286) with 5 as the reagent bag
	-- (Openables.lua:234).
	local CC = C_Container
	if CC and CC.GetContainerNumSlots and CC.GetContainerItemInfo then
		for bag = 0, (NUM_BAG_SLOTS or 4) do
			local okN, n = pcall(CC.GetContainerNumSlots, bag)
			for slotIdx = 1, (okN and tonumber(n) or 0) do
				local okI, info = pcall(CC.GetContainerItemInfo, bag, slotIdx)
				local link = okI and type(info) == "table" and Link(true, info.hyperlink) or nil
				local slot = link and LOC_TO_SLOT[EquipLoc(link) or ""]
				if slot then
					Add("B", slot, link)
				end
			end
		end
	end
	return table.concat(lines, "\n"), items, pending
end

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------

local showCount = 0
local waiting = false
local settleAt = 0

local function Show(isRefresh)
	local text, items, pending = ns.BuildGearExport()
	-- A fresh id per build: the shared dialog toggles closed when asked for the id it already shows,
	-- and a refresh must replace the text instead.
	showCount = showCount + 1
	-- 🔴 "|" IS WOW'S ESCAPE CHARACTER. Rob's first paste (28 Sep 2026) came back mangled: "E|head"
	-- as "Eead", "|rare" as "are", "|neck" as a line break -- the edit box read |h, |r, |n and |t as
	-- hyperlink, colour, newline and texture codes and swallowed them. Written as "||" it shows (and
	-- copies) as one plain "|", which is what the website's contract needs.
	ns.ShowShareCopyDialog({
		id = "gearexport:" .. showCount,
		text = (text:gsub("|", "||")),
		titleKey = "GEAREXPORT_TITLE",
		hintKey = pending > 0 and "GEAREXPORT_HINT_PENDING" or "GEAREXPORT_HINT",
		closeKey = "DELVE_SHARE_COPY_CLOSE",
		width = 560,
		height = 380,
	})
	if not isRefresh then
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), (ns:L("GEAREXPORT_COUNT_FMT")):format(items)))
	end
	if pending > 0 then
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), (ns:L("GEAREXPORT_PENDING_FMT")):format(pending)))
		waiting = true
		settleAt = (GetTime and GetTime() or 0) + 1
	else
		waiting = false
	end
end

--- `/mh export`
function ns.ShowGearExport()
	if not ns.ShowShareCopyDialog then
		print((ns.BuildGearExport()))
		return
	end
	Show(false)
end

-- Items that were not cached: wait until the arrivals go quiet for a second, then rebuild once --
-- but only while our export is still the text on screen.
local ev = CreateFrame("Frame")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
ev:SetScript("OnEvent", function()
	if not waiting then
		return
	end
	settleAt = (GetTime and GetTime() or 0) + 1
	if C_Timer and C_Timer.After then
		C_Timer.After(1.05, function()
			if not waiting or (GetTime and GetTime() or 0) < settleAt then
				return
			end
			local dlg = _G.MidnightHelperDelveShareCopy
			if dlg and dlg:IsShown() and type(dlg._mhEntryId) == "string" and dlg._mhEntryId:match("^gearexport:") then
				Show(true)
			else
				waiting = false
			end
		end)
	end
end)
