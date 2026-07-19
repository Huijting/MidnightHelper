--[[
	Midnight Helper — Valeera / delve companion curio recommendations by season and role.
	Item names come from the client (GetItemInfo); this file holds item IDs only.
]]

local _, ns = ...

local ITEM_PORCELAIN_BLADE_TIP = 257683
local ITEM_MANDATE_SACRED_DEATH = 249225
local ITEM_OVERFLOWING_VOIDSPIRE = 257866

--- @type table<number, { default: table<string, {combat: number, utility: number}>, nemesis?: table<string, {combat: number, utility: number}> }>
ns.DELVE_CURIOS_BY_SEASON = {
	[1] = {
		default = {
			dps = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_MANDATE_SACRED_DEATH },
			heal = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_MANDATE_SACRED_DEATH },
			tank = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_MANDATE_SACRED_DEATH },
		},
		nemesis = {
			dps = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_OVERFLOWING_VOIDSPIRE },
			heal = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_OVERFLOWING_VOIDSPIRE },
			tank = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_OVERFLOWING_VOIDSPIRE },
		},
	},
}

ns.DELVE_CURIO_ITEM_IDS = {}
do
	local seen = ns.DELVE_CURIO_ITEM_IDS
	for _, pack in pairs(ns.DELVE_CURIOS_BY_SEASON) do
		if type(pack) == "table" then
			for _, bucket in pairs(pack) do
				if type(bucket) == "table" then
					for _, pick in pairs(bucket) do
						if type(pick) == "table" then
							if pick.combat then
								seen[pick.combat] = true
							end
							if pick.utility then
								seen[pick.utility] = true
							end
						end
					end
				end
			end
		end
	end
end

function ns.IsDelveCurioItemID(itemID)
	return ns.DELVE_CURIO_ITEM_IDS[tonumber(itemID)] == true
end

ns.DELVE_CURIO_ROLES = { "dps", "heal", "tank" }

ns.DELVE_CURIO_ROLE_ATLASES = {
	dps = { "roleicon-tiny-dps", "spec-role-dps" },
	heal = { "roleicon-tiny-healer", "spec-role-healer" },
	tank = { "roleicon-tiny-tank", "spec-role-tank" },
}

ns.DELVE_CURIO_ROLE_LABEL_KEYS = {
	dps = "DELVE_CURIO_ROLE_DPS",
	heal = "DELVE_CURIO_ROLE_HEAL",
	tank = "DELVE_CURIO_ROLE_TANK",
}

function ns.GetDelvesSeasonNumber()
	if C_DelvesUI and C_DelvesUI.GetCurrentDelvesSeasonNumber then
		local ok, sn = pcall(C_DelvesUI.GetCurrentDelvesSeasonNumber)
		if ok and sn ~= nil then
			return math.max(1, math.floor(tonumber(sn) or 1))
		end
	end
	return 1
end

--- Curio advice for a season, or nil when we have none for it.
--- NO fallback to season 1. This used to `return ns.DELVE_CURIOS_BY_SEASON[1]`
--- for any unknown season, which reads as harmless but is the worst case in
--- practice: on the normal Season 2 path the API correctly reports season 2, we
--- have no pack for it, and the advisor would then confidently recommend Season 1
--- curios — items that may not even exist any more. Every consumer already guards
--- for nil (they hide the line), so nothing is better than something wrong.
function ns.GetDelveCurioSeasonTable(season)
	season = tonumber(season) or ns.GetDelvesSeasonNumber()
	return ns.DELVE_CURIOS_BY_SEASON[season]
end

--- Recommendations for one role; variant is "default" or "nemesis".
function ns.GetDelveCurioPick(season, role, variant)
	local pack = ns.GetDelveCurioSeasonTable(season)
	if not pack then
		return nil
	end
	variant = variant or "default"
	local bucket = pack[variant] or pack.default
	if not bucket then
		return nil
	end
	return bucket[role] or bucket.dps
end

function ns.RequestDelveCurioItemData(season)
	season = tonumber(season) or (ns.GetDelvesSeasonNumber and ns:GetDelvesSeasonNumber()) or 1
	local pack = ns.GetDelveCurioSeasonTable(season)
	if not pack or not C_Item or not C_Item.RequestLoadItemDataByID then
		return
	end
	local seen = {}
	local function req(id)
		id = tonumber(id)
		if id and not seen[id] then
			seen[id] = true
			pcall(C_Item.RequestLoadItemDataByID, id)
		end
	end
	for _, bucket in pairs(pack) do
		if type(bucket) == "table" then
			for _, pick in pairs(bucket) do
				if type(pick) == "table" then
					req(pick.combat)
					req(pick.utility)
				end
			end
		end
	end
end

function ns.GetDelveCurioItemName(itemID)
	itemID = tonumber(itemID)
	if not itemID then
		return "?"
	end
	if C_Item and C_Item.GetItemInfo then
		local ok, name = pcall(C_Item.GetItemInfo, itemID)
		if ok and name and name ~= "" then
			return name
		end
	end
	if GetItemInfo then
		local name = GetItemInfo(itemID)
		if name and name ~= "" then
			return name
		end
	end
	return ("#%d"):format(itemID)
end

function ns.GetDelveCurioItemIcon(itemID)
	itemID = tonumber(itemID)
	if not itemID then
		return 134400
	end
	if C_Item and C_Item.GetItemIconByID then
		local ok, tex = pcall(C_Item.GetItemIconByID, itemID)
		if ok and tex then
			return tex
		end
	end
	if GetItemIcon then
		local tex = GetItemIcon(itemID)
		if tex then
			return tex
		end
	end
	return 134400
end

function ns.GetDelveCurioItemLink(itemID)
	itemID = tonumber(itemID)
	if not itemID then
		return nil
	end
	if C_Item and C_Item.GetItemLink then
		local ok, link = pcall(C_Item.GetItemLink, itemID)
		if ok and link then
			return link
		end
	end
	if GetItemLink then
		return GetItemLink(itemID)
	end
	return nil
end

function ns.IsPlayerInNemesisDelve()
	if ns.GetActiveDelveTipEntryForPlayer then
		local entry = ns:GetActiveDelveTipEntryForPlayer()
		if entry and entry.rosterName == "Torment's Rise" then
			return true
		end
	end
	return false
end
