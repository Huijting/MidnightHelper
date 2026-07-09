--[[
	Weekly collectible-mount progress (Midnight 12.0.7).

	Several new mounts are earned by collecting a time-gated item or by
	maintaining a weekly buff over multiple weeks. This module tracks that
	progress and surfaces it on the This Week dashboard, hiding a mount once
	you've actually collected it, and showing a short "how to get it" hint.

	Verified IDs (docs/PTR_12.0.7_DATA.md + Wowhead, July 2026):
	  - Luminous Sporeglider = mount spell 1284973; 4x Delicious Sporesnack
	    (item 269245), ~1 per week from Rotmire in the Sporefall raid.
	  - Spawn of Vyranoth = mount item 258884; achievement 61463 "Master of the
	    Turbulent Timeways V" (Gain Mastery of the Timeways in 4 of the event's
	    5 weeks).

	Never-lie: item counts come from the live bag API, achievement progress from
	the achievement API, and "collected?" from the Mount Journal — no fabricated
	progress. Two source types:
	  - itemID       -> progress = live bag count (GetItemCount).
	  - achievementID -> progress = the achievement's first-criterion quantity.
]]

local _, ns = ...

local TRACKED = {
	{
		key = "sporeglider",
		mountSpellID = 1284973,   -- Luminous Sporeglider (Wowhead-verified)
		itemID = 269245,          -- Delicious Sporesnack (1/week, Rotmire/Sporefall)
		need = 4,
		fallbackName = "Luminous Sporeglider",
		howToKey = "MOUNTPROG_SPOREGLIDER_HOWTO",
	},
	{
		key = "vyranoth",
		mountItemID = 258884,     -- Spawn of Vyranoth (teaches the mount)
		achievementID = 61463,    -- Master of the Turbulent Timeways V (4 of 5 weeks)
		need = 4,
		fallbackName = "Spawn of Vyranoth",
		howToKey = "MOUNTPROG_VYRANOTH_HOWTO",
	},
}

--- @return isCollected(bool|nil), localizedName(string|nil)
local function InfoFromMountID(mid)
	if not (mid and C_MountJournal and C_MountJournal.GetMountInfoByID) then
		return nil
	end
	-- GetMountInfoByID: name, spellID, icon, isActive, isUsable, sourceType,
	-- isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected, mountID.
	local v = { pcall(C_MountJournal.GetMountInfoByID, mid) }
	if not v[1] then
		return nil
	end
	return v[12] == true, v[2]
end

local function MountStatus(m)
	if m.mountSpellID and C_MountJournal and C_MountJournal.GetMountFromSpell then
		local ok, mid = pcall(C_MountJournal.GetMountFromSpell, m.mountSpellID)
		if ok and mid then
			return InfoFromMountID(mid)
		end
	end
	if m.mountItemID and C_MountJournal and C_MountJournal.GetMountFromItem then
		local ok, mid = pcall(C_MountJournal.GetMountFromItem, m.mountItemID)
		if ok and mid then
			return InfoFromMountID(mid)
		end
	end
	return nil, nil
end

local function ItemCount(itemID)
	if itemID and C_Item and C_Item.GetItemCount then
		local ok, n = pcall(C_Item.GetItemCount, itemID)
		if ok and type(n) == "number" then
			return n
		end
	end
	return 0
end

--- Progress from an achievement's first criterion (quantity), e.g. weeks done.
local function AchievementQuantity(achID)
	if not (achID and GetAchievementCriteriaInfo) then
		return 0
	end
	-- Returns: criteriaString, criteriaType, completed, quantity, reqQuantity, ...
	local ok, _cs, _ct, _completed, quantity = pcall(GetAchievementCriteriaInfo, achID, 1)
	if ok and type(quantity) == "number" then
		return quantity
	end
	return 0
end

--- Progress for tracked collectible mounts you have NOT collected yet.
--- @return list of { key, name, have, need, howToKey }
function ns.GetWeeklyMountProgress()
	local out = {}
	for _, m in ipairs(TRACKED) do
		local collected, mountName = MountStatus(m)
		if collected ~= true then -- false or nil (data not loaded) -> still show
			local have
			if m.itemID then
				have = ItemCount(m.itemID)
			elseif m.achievementID then
				have = AchievementQuantity(m.achievementID)
			else
				have = 0
			end
			out[#out + 1] = {
				key = m.key,
				name = (type(mountName) == "string" and mountName ~= "" and mountName) or m.fallbackName,
				have = math.min(have, m.need),
				need = m.need,
				howToKey = m.howToKey,
			}
		end
	end
	return out
end
