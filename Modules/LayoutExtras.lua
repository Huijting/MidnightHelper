--[[
	Layout Extras — niet-keybind essentials in de Layout-tab (Rob, 3 jul 2026).

	Levert de "Consumables & extras"-kaart onder het toetsenbord: dingen die je
	WÉL op je bars hoort te zetten maar die geen muscle-memory-toets verdienen
	(flask, food, wapen-olie, augment rune, combat-pot, healing-pot, healthstone,
	on-use trinket, drums).

	Bouwt VOORT op de bestaande, geteste detectie in ConsumableReadyCheck.lua —
	we dupliceren geen item-data en geen bag/aura-scans. We roepen de publieke
	API's aan (ns.GetConsumableReadyData / ns.GetConsumableColumnIcons /
	ns.GetConsumableRecommendedItemIDs) en verrijken met on-use-trinket + drums.

	Never-lie: onbekende status (item-info nog niet gecached) → "unknown" (geel ?),
	nooit een vals "ontbreekt". Auto op de bars plaatsen kan niet (taint +
	combat-lockdown), dus dit is puur een guide/suggestie.
]]

local _, ns = ...

-- Void-Touched Drums (Leatherworking, Bloodlust-vervanger). Stabiel item-ID,
-- geverifieerd via Wowhead (Midnight S1). Bag-only detectie.
local DRUMS_ID = 244639

--------------------------------------------------------------------------------
-- Item-helpers (read-only, pcall-geguard)
--------------------------------------------------------------------------------

local function ItemName(id)
	if not id then
		return nil
	end
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and n and n ~= "" then
			return n
		end
	end
	if C_Item and C_Item.GetItemInfo then
		local ok, n = pcall(C_Item.GetItemInfo, id)
		if ok and n and n ~= "" then
			return n
		end
	end
	return nil
end

local function ItemIcon(id)
	if not (id and C_Item and C_Item.GetItemIconByID) then
		return nil
	end
	local ok, icon = pcall(C_Item.GetItemIconByID, id)
	return (ok and icon) or nil
end

local function ItemCount(id)
	if not id then
		return nil
	end
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return nil
	end
	local ok, n = pcall(fn, id)
	if ok then
		return n
	end
	return nil
end

-- Eerste uitgeruste trinket (slot 13/14) met een use-spell = on-use trinket.
-- @return itemID|nil
local function OnUseTrinketID()
	local getInv = GetInventoryItemID
	local getSpell = (C_Item and C_Item.GetItemSpell) or GetItemSpell
	if not (getInv and getSpell) then
		return nil
	end
	for _, slot in ipairs({ 13, 14 }) do
		local ok, id = pcall(getInv, "player", slot)
		if ok and id then
			local ok2, _name, sid = pcall(getSpell, id)
			if ok2 and sid then
				return id
			end
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- Status-normalisatie → "active" / "ready" / "missing" / "unknown"
--------------------------------------------------------------------------------

-- Buff-capable categorieën (flask/food/rune/weapon): buff actief = beste status.
local function BuffStatus(entry)
	if type(entry) ~= "table" then
		return "unknown"
	end
	if entry.buff == true then
		return "active"
	end
	local bag = entry.bag
	if bag == "best" or bag == "alt" or bag == true then
		return "ready"
	end
	if type(entry.count) == "number" and entry.count > 0 then
		return "ready"
	end
	-- buff=false alléén is niet genoeg om "missing" te zeggen als de tas onbekend
	-- is (never-lie). Alleen een bekend-lege tas telt als "missing".
	if bag == false then
		return "missing"
	end
	return "unknown"
end

-- Bag-only categorieën (cpot/hpot/hs/drums/trinket): alleen tas-aanwezigheid.
local function BagStatus(entry)
	if type(entry) ~= "table" then
		return "unknown"
	end
	local bag = entry.bag
	if bag == true or bag == "best" or bag == "alt" then
		return "ready"
	end
	if type(entry.count) == "number" and entry.count > 0 then
		return "ready"
	end
	if bag == false then
		return "missing"
	end
	return "unknown"
end

--------------------------------------------------------------------------------
-- Publiek: geordende extras-lijst voor de huidige speler/spec
--------------------------------------------------------------------------------

-- @return { { key, itemID, name, icon, tagKey, status }, ... } of nil
-- tagKey ∈ LAYOUT_TAG_PREPULL / _ONUSE / _PROF / _UTILITY
-- status ∈ "active" / "ready" / "missing" / "unknown"
function ns.GetLayoutExtras()
	if not ns.GetConsumableReadyData then
		return nil
	end
	local ok, data = pcall(ns.GetConsumableReadyData)
	if not ok or type(data) ~= "table" or type(data.rows) ~= "table" then
		return nil
	end

	-- Eigen rij zoeken.
	local me
	for i = 1, #data.rows do
		local r = data.rows[i]
		if r and r.unit == "player" then
			me = r
			break
		end
	end
	if not me then
		me = data.rows[1]
	end
	if type(me) ~= "table" then
		return nil
	end

	local icons = (ns.GetConsumableColumnIcons and ns.GetConsumableColumnIcons()) or {}
	local recIDs = (ns.GetConsumableRecommendedItemIDs and ns.GetConsumableRecommendedItemIDs()) or {}

	local out = {}
	local function add(key, entry, tagKey, statusFn, labelKey, forcedID)
		local id = forcedID or recIDs[key]
		out[#out + 1] = {
			key = key,
			itemID = id,
			-- Korte, stabiele categorielabel als hoofdtekst (voorkomt afgekapte
			-- lange itemnamen); de volledige itemnaam staat in de hover-tooltip.
			name = ns:L(labelKey),
			icon = icons[key] or ItemIcon(id) or "Interface\\Icons\\INV_Misc_QuestionMark",
			tagKey = tagKey,
			status = statusFn(entry),
		}
	end

	-- Pre-pull (buff-capable). weapon alleen als de spec olie gebruikt
	-- (me.weapon == nil bij specs met eigen imbue → overslaan).
	add("flask", me.flask, "LAYOUT_TAG_PREPULL", BuffStatus, "CONSREADY_FLASK")
	add("food", me.food, "LAYOUT_TAG_PREPULL", BuffStatus, "CONSREADY_FOOD")
	if me.weapon ~= nil then
		add("weapon", me.weapon, "LAYOUT_TAG_PREPULL", BuffStatus, "LAYOUT_EXTRA_WEAPON")
	end
	add("rune", me.rune, "LAYOUT_TAG_PREPULL", BuffStatus, "CONSREADY_RUNE")

	-- On-use (bag-only).
	add("cpot", me.cpot, "LAYOUT_TAG_ONUSE", BagStatus, "CONSREADY_CPOT")
	add("hpot", me.hpot, "LAYOUT_TAG_ONUSE", BagStatus, "CONSREADY_HPOT")
	add("hs", me.hs, "LAYOUT_TAG_ONUSE", BagStatus, "CONSREADY_HS")

	-- On-use trinket (uitgerust, heeft use-spell). Aanwezig = ready.
	local trID = OnUseTrinketID()
	if trID then
		out[#out + 1] = {
			key = "trinket",
			itemID = trID,
			name = ns:L("LAYOUT_EXTRA_TRINKET"),
			icon = ItemIcon(trID) or "Interface\\Icons\\INV_Misc_QuestionMark",
			tagKey = "LAYOUT_TAG_ONUSE",
			status = "ready",
		}
	end

	-- Utility: drums (Bloodlust-vervanger). Bag-only.
	local drumN = ItemCount(DRUMS_ID)
	out[#out + 1] = {
		key = "drums",
		itemID = DRUMS_ID,
		name = ns:L("LAYOUT_EXTRA_DRUMS"),
		icon = ItemIcon(DRUMS_ID) or "Interface\\Icons\\INV_Misc_QuestionMark",
		tagKey = "LAYOUT_TAG_UTILITY",
		status = (drumN == nil) and "unknown" or (drumN > 0 and "ready" or "missing"),
	}

	return out
end
