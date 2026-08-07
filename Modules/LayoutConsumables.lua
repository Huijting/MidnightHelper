local _, ns = ...

--[[
	Midnight Helper — the two consumables that belong on a key.

	The keybind scheme covers spells and nothing else, so a full rebuild of the bars
	would wipe a player's potions and put nothing back. Rob's healing potion sat on slot
	3; after a rebuild it would simply be gone until he noticed.

	WHICH ONES. Only the healing potion and the combat potion. Every keybinding guide
	draws the same line: things you press during a fight get a key, things you prepare
	beforehand get clicked. Flask, food, feast, augment rune and weapon oil are all in
	`ConsumablesWowheadData.lua` too and all stay off the keyboard — binding them would
	spend two of the best remaining keys on buttons pressed once an hour.

	WHERE THE DATA COMES FROM. `ns.ConsumablesWowheadByClassSpec`, which already exists,
	is generated per class and spec, and carries real item ids. Nothing is invented here;
	if a spec is missing from that table this returns nothing rather than guessing.

	⚠️ ONLY WHAT THE PLAYER ACTUALLY CARRIES. A recommended potion the player does not
	own is advice, not a layout — putting it on a bar produces an empty-looking button
	and a key that does nothing. So the bags decide.
]]

--- Keys a consumable may take, worst-first among the good ones.
---
--- These are deliberately at the back of the queue. A potion is pressed once or twice
--- a fight, so by the scheme's own frequency rule it has no claim on a rotation key —
--- it takes what the spells left. The old standard put the potion on `Alt+C`, which is
--- no longer available at all: Alt left the scheme on 6 Aug because it breaks WoW's
--- self-cast modifier.
local CONSUMABLE_KEYS = { "T", "5", "R", "X", "Z", "C" }

local function SpecIndex()
	if C_SpecializationInfo and C_SpecializationInfo.GetSpecialization then
		local ok, s = pcall(C_SpecializationInfo.GetSpecialization)
		if ok and s then
			return s
		end
	end
	if GetSpecialization then
		local ok, s = pcall(GetSpecialization)
		if ok and s then
			return s
		end
	end
	return nil
end

local function HasItem(itemID)
	if not itemID then
		return false
	end
	if C_Item and C_Item.GetItemCount then
		local ok, n = pcall(C_Item.GetItemCount, itemID)
		if ok then
			return (n or 0) > 0
		end
	end
	if GetItemCount then
		local ok, n = pcall(GetItemCount, itemID)
		if ok then
			return (n or 0) > 0
		end
	end
	return false
end

local function ItemName(itemID)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, itemID)
		if ok and n then
			return n
		end
	end
	return tostring(itemID)
end

--- The best item of a category that the player is actually carrying.
local function CarriedBest(entry)
	if type(entry) ~= "table" then
		return nil
	end
	for _, list in ipairs({ entry.best, entry.alternates }) do
		if type(list) == "table" then
			for i = 1, #list do
				if HasItem(list[i]) then
					return list[i]
				end
			end
		end
	end
	return nil
end

--- @param usedKeys table  set of bind keys the spells already claimed
--- @return table { {itemID, name, key, category} }
function ns.MH_ConsumableLayout(usedKeys)
	usedKeys = usedKeys or {}
	local out = {}

	local _, class = UnitClass("player")
	local idx = SpecIndex()
	local byClass = ns.ConsumablesWowheadByClassSpec
	local spec = class and idx and byClass and byClass[class] and byClass[class][idx]
	if not spec then
		return out
	end

	--- Healing potion first: it is the one you reach for while dying, so it gets the
	--- better of the two remaining keys.
	local wanted = {
		{ category = "healingPotion", entry = spec.healingPotion },
		{ category = "combatPotion", entry = spec.combatPotion },
	}

	--- ⚠️ THE BARE KEYS RUN OUT, AND USED TO RUN OUT SILENTLY. Measured 7 Aug: with `T`
	--- reserved as the consumable anchor, 28 of 39 specs have exactly ONE bare key free —
	--- so the healing potion is placed and the combat potion simply was not, with nothing
	--- said about it.
	---
	--- A Shift layer is an honest home for the second one. The healing potion is the
	--- panic press and keeps a bare key; a combat potion is a deliberate pre-pull or
	--- burst press, and a modifier costs nothing there.
	local function NextFreeKey(startIndex)
		for i = startIndex, #CONSUMABLE_KEYS do
			local candidate = CONSUMABLE_KEYS[i]
			if not usedKeys[candidate] then
				return candidate, i + 1
			end
		end
		for i = 1, #CONSUMABLE_KEYS do
			local candidate = "Shift+" .. CONSUMABLE_KEYS[i]
			if not usedKeys[candidate] then
				return candidate, #CONSUMABLE_KEYS + 1
			end
		end
		return nil, #CONSUMABLE_KEYS + 1
	end

	local ki = 1
	for _, w in ipairs(wanted) do
		local itemID = CarriedBest(w.entry)
		if itemID then
			local key
			key, ki = NextFreeKey(ki)
			if key then
				out[#out + 1] = {
					itemID = itemID,
					name = ItemName(itemID),
					key = key,
					category = w.category,
				}
				usedKeys[key] = true
			end
		end
	end
	return out
end
