local _, ns = ...

--[[
	Midnight Helper — `/mh export`: your equipped gear and the equippable items in your bags, as
	text for the Midnight Helper Armory website ("Calculate best set").

	Why the addon: Blizzard's web API returns what you WEAR, never what is in your bags. So the
	bags have to come from the client, as text a player copies and pastes.

	🔴 THE FORMAT IS A CONTRACT WITH THE WEBSITE (docs from Rob, 28 Sep 2026). Do not change a
	field, its order or a slot name without changing the site in the same breath:

	    MH-EXPORT 1
	    char=<name>;class=<CLASSFILE>;spec=<spec name>;primary=<Strength|Agility|Intellect|?>
	    # where|slot|ilvl|quality|name|str|sta|crit|haste|mast|vers
	    E|head|285|epic|Helm of ...|541|839|121|81|0|0

	  where    E = equipped, B = in the bags
	  slot     head neck shoulder back chest wrist hands waist legs feet finger trinket mainhand offhand
	  ilvl     the real item level (C_Item.GetDetailedItemLevelInfo), not the base
	  quality  epic | rare (anything else is written as epic; the site only colours with it)
	  name     the client's item name, a "|" in it becomes "/"
	  str      YOUR SPEC'S primary stat, despite the column name. Only when the spec's primary stat
	           cannot be read does it fall back to Strength + Agility + Intellect added up.
	  numbers  whole numbers, a missing stat is 0
	  primary  extra key on the char line (28 Sep 2026). The site's parser ignores keys it does not
	           know, so the contract holds; it is there so a pasted export shows what we filtered on.
	  hands    12th field, weapons only (30 Sep 2026): 2 = takes both hands, 1 = one hand. Rob's Shaman
	           wore a staff and the site told him to add a shield from his bags, because nothing said
	           the staff filled the off hand too. The site picks weapons as a pair when this is present.
	  unique   13th field, rings and trinkets only (30 Sep 2026): <key>:<max>, empty when the item is not
	           Unique-Equipped. Rob's Shaman was told to wear a second Ouroboric Signet next to the one he
	           had on; its tooltip says Unique-Equipped. Key "i<itemID>" for a plain Unique-Equipped item,
	           "c<category>" for "Unique-Equipped: <category> (n)". Rings and trinkets only: a category
	           that spans other slots (embellishments) is not handled.

	Bag items you cannot use are left out (red-team review, 28 Sep 2026: the first version summed all
	three primaries and never looked at armour type, so a Protection Paladin could be told to wear an
	Intellect cloth robe or a caster mace):
	  - armour of another type than your class wears (plate/mail/leather/cloth; cloaks exempt), and
	  - items that carry a primary stat, but not yours.
	Equipped items are always written: they are what you wear, whatever they are.

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

-- GetSpecializationInfo's 6th return, the spec's primary stat: LE_UNIT_STAT_STRENGTH = 1,
-- LE_UNIT_STAT_AGILITY = 2, LE_UNIT_STAT_INTELLECT = 4.
-- VERIFY: MH does not read this return anywhere else yet. The char line's "primary=" shows what
-- came back; "?" there means we fell back to the old sum of all three.
local PRIMARY_BY_STAT = {
	[1] = { key = "ITEM_MOD_STRENGTH_SHORT", name = "Strength" },
	[2] = { key = "ITEM_MOD_AGILITY_SHORT", name = "Agility" },
	[4] = { key = "ITEM_MOD_INTELLECT_SHORT", name = "Intellect" },
}

-- The armour type each class wears (Enum.ItemArmorSubclass: 1 cloth, 2 leather, 3 mail, 4 plate).
local ARMOR_BY_CLASS = {
	WARRIOR = 4, PALADIN = 4, DEATHKNIGHT = 4,
	HUNTER = 3, SHAMAN = 3, EVOKER = 3,
	ROGUE = 2, DRUID = 2, MONK = 2, DEMONHUNTER = 2,
	MAGE = 1, PRIEST = 1, WARLOCK = 1,
}
-- Slots where the armour type matters. Cloaks are "cloth" for every class, so INVTYPE_CLOAK is not here.
local ARMOR_LOCS = {
	INVTYPE_HEAD = true, INVTYPE_SHOULDER = true, INVTYPE_CHEST = true, INVTYPE_ROBE = true,
	INVTYPE_WRIST = true, INVTYPE_HAND = true, INVTYPE_WAIST = true, INVTYPE_LEGS = true, INVTYPE_FEET = true,
}
local ITEM_CLASS_ARMOR = (Enum and Enum.ItemClass and Enum.ItemClass.Armor) or 4

-- Equip locations that fill both hands. Bows, guns and crossbows do; a wand is written as one
-- hand. VERIFY: whether a wand still blocks the off hand on 12.1 is not measured.
local TWO_HAND_LOCS = { INVTYPE_2HWEAPON = true, INVTYPE_RANGED = true, INVTYPE_RANGEDRIGHT = true }
local WAND = (Enum and Enum.ItemWeaponSubclass and Enum.ItemWeaponSubclass.Wand) or 19

local function Num(v)
	if v == nil or ns.IsSecretValue(v) then
		return 0
	end
	v = tonumber(v) or 0
	return math.floor(v + 0.5)
end

--- The item's stats. `primaryKey` is the spec's primary stat key, or nil to add up all three.
--- `out.otherPrimary` is true when the item carries a primary stat and it is not `primaryKey`.
local function Stats(link, primaryKey)
	local out = { str = 0, sta = 0, crit = 0, haste = 0, mast = 0, vers = 0, otherPrimary = false }
	if not (C_Item and C_Item.GetItemStats) then
		return out
	end
	local ok, s = pcall(C_Item.GetItemStats, link)
	if not ok or type(s) ~= "table" then
		return out
	end
	if primaryKey then
		out.str = Num(s[primaryKey])
		if out.str == 0 then
			for _, k in ipairs(PRIMARY_KEYS) do
				if Num(s[k]) > 0 then
					out.otherPrimary = true
				end
			end
		end
	else
		for _, k in ipairs(PRIMARY_KEYS) do
			out.str = out.str + Num(s[k])
		end
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

--- Equip location, item class and subclass (GetItemInfoInstant returns 4, 6 and 7).
local function EquipLoc(link)
	if not (C_Item and C_Item.GetItemInfoInstant) then
		return nil
	end
	local ok, _, _, _, loc, _, classID, subClassID = pcall(C_Item.GetItemInfoInstant, link)
	if ok and ns.CanAccessText(loc) then
		return loc, tonumber(classID), tonumber(subClassID)
	end
	return nil
end

--- The "hands" field for a weapon line ("|2" or "|1"), empty for every other slot.
local function Hands(slot, link)
	if slot ~= "mainhand" and slot ~= "offhand" then
		return ""
	end
	local loc, _, subClassID = EquipLoc(link)
	if loc and TWO_HAND_LOCS[loc] and not (loc == "INVTYPE_RANGEDRIGHT" and subClassID == WAND) then
		return "|2"
	end
	return "|1"
end

--- The "unique" field for a ring or trinket line ("|<hands>|<key>:<max>"), empty for other slots.
--- The tooltip is the source Pawn and AskMrRobot read (`ITEM_UNIQUE_EQUIPPABLE`, localised by the
--- game, so it matches every client language). `C_Item.GetItemUniqueness` is Zygor's route and only
--- the fallback. VERIFY: neither is measured in MH yet.
local function Unique(slot, link)
	if slot ~= "finger" and slot ~= "trinket" then
		return ""
	end
	local tag = rawget(_G, "ITEM_UNIQUE_EQUIPPABLE")
	local id = tonumber(link:match("item:(%d+)"))
	local key, max
	if type(tag) == "string" and tag ~= "" and C_TooltipInfo and C_TooltipInfo.GetHyperlink then
		local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
		local lines = ok and type(data) == "table" and data.lines
		for _, line in ipairs(type(lines) == "table" and lines or {}) do
			local text = line.leftText
			if ns.CanAccessText(text) and text:sub(1, #tag) == tag then
				local rest = text:sub(#tag + 1)
				if rest == "" then
					key, max = id and ("i" .. id), 1
				else
					-- "Unique-Equipped: <category> (<n>)"
					local cat, n = rest:match("^%s*:%s*(.-)%s*%((%d+)%)%s*$")
					if cat and cat ~= "" then
						key, max = "c" .. (cat:gsub("[|:]", "")), tonumber(n)
					end
				end
				break
			end
		end
	end
	if not key and id and C_Item and C_Item.GetItemUniqueness then
		local ok, fam, n = pcall(C_Item.GetItemUniqueness, id)
		if ok and type(fam) == "number" and not ns.IsSecretValue(fam) and fam > 0 then
			key, max = "f" .. fam, (type(n) == "number" and not ns.IsSecretValue(n) and n > 0) and n or 1
		end
	end
	if not key then
		return ""
	end
	return ("||%s:%d"):format(key, max or 1)
end

--- One line, or nil plus "pending" when the client has not cached the item yet, or nil plus
--- "unusable" when `skipOtherPrimary` is set and the item carries someone else's primary stat.
local function Line(where, slot, link, primaryKey, skipOtherPrimary)
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
	local s = Stats(link, primaryKey)
	if skipOtherPrimary and s.otherPrimary then
		return nil, "unusable"
	end
	return ("%s|%s|%d|%s|%s|%d|%d|%d|%d|%d|%d%s%s"):format(
		where, slot, ItemLevel(link), q, name, s.str, s.sta, s.crit, s.haste, s.mast, s.vers,
		Hands(slot, link), Unique(slot, link))
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
	local specName, primary = "?", nil
	if GetSpecialization and GetSpecializationInfo then
		local idx = GetSpecialization()
		if idx then
			local ok, _, sname, _, _, _, primaryStat = pcall(GetSpecializationInfo, idx)
			if ok and ns.CanAccessText(sname) then
				specName = sname
			end
			if ok and not ns.IsSecretValue(primaryStat) then
				primary = PRIMARY_BY_STAT[tonumber(primaryStat) or 0]
			end
		end
	end
	local primaryKey = primary and primary.key or nil
	local myArmor = ARMOR_BY_CLASS[tostring(classFile)]
	lines[#lines + 1] = "MH-EXPORT 1"
	-- Parentheses around each gsub: it returns two values, and the count would slide into the next %s.
	lines[#lines + 1] = ("char=%s;class=%s;spec=%s;primary=%s"):format(
		(tostring(charName):gsub("[;|=]", "")), tostring(classFile), (tostring(specName):gsub("[;|=]", "")),
		primary and primary.name or "?")
	lines[#lines + 1] = "# where|slot|ilvl|quality|name|str|sta|crit|haste|mast|vers|hands (weapons)|unique (rings, trinkets)"

	local function Add(where, slot, link)
		-- Only bag items are filtered: what you wear is written whatever it is.
		local line, why = Line(where, slot, link, primaryKey, where == "B" and primaryKey ~= nil)
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
				local loc, classID, subClassID
				if link then
					loc, classID, subClassID = EquipLoc(link)
				end
				local slot = LOC_TO_SLOT[loc or ""]
				-- Another class's armour type: skip. Subclass 0 (miscellaneous) and cloaks pass.
				if slot and myArmor and ARMOR_LOCS[loc] and classID == ITEM_CLASS_ARMOR
					and subClassID and subClassID >= 1 and subClassID <= 4 and subClassID ~= myArmor then
					slot = nil
				end
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
