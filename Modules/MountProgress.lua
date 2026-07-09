--[[
	Weekly collectible-mount progress (Midnight 12.0.7).

	Several new mounts are earned by collecting a time-gated item over multiple
	weeks. This module tracks that progress and surfaces it on the This Week
	dashboard, hiding a mount once you've actually collected it.

	Verified IDs (docs/PTR_12.0.7_DATA.md + Wowhead, July 2026):
	  - Luminous Sporeglider = mount spell 1284973; earned with 4x Delicious
	    Sporesnack (item 269245), 1 per week from Rotmire in the Sporefall raid.

	Never-lie: item counts come from the live bag API and "collected?" from the
	Mount Journal — no fabricated progress. Item-count trackers only for now;
	achievement-based ones (e.g. Spawn of Vyranoth / Turbulent Timeways) follow.
]]

local _, ns = ...

local TRACKED = {
	{
		key = "sporeglider",
		mountSpellID = 1284973,   -- Luminous Sporeglider (Wowhead-verified)
		itemID = 269245,          -- Delicious Sporesnack (1/week, Rotmire/Sporefall)
		need = 4,
		fallbackName = "Luminous Sporeglider",
	},
}

--- @return isCollected(bool|nil), localizedName(string|nil)
local function MountCollected(spellID)
	if not (C_MountJournal and C_MountJournal.GetMountFromSpell and C_MountJournal.GetMountInfoByID) then
		return nil
	end
	local ok, mid = pcall(C_MountJournal.GetMountFromSpell, spellID)
	if not ok or not mid then
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

local function ItemCount(itemID)
	if itemID and C_Item and C_Item.GetItemCount then
		local ok, n = pcall(C_Item.GetItemCount, itemID)
		if ok and type(n) == "number" then
			return n
		end
	end
	return 0
end

--- Progress for tracked collectible mounts you have NOT collected yet.
--- @return list of { key, name, have, need }
function ns.GetWeeklyMountProgress()
	local out = {}
	for _, m in ipairs(TRACKED) do
		local collected, mountName = MountCollected(m.mountSpellID)
		if collected ~= true then -- false or nil (data not loaded) -> still show
			local have = math.min(ItemCount(m.itemID), m.need)
			out[#out + 1] = {
				key = m.key,
				name = (type(mountName) == "string" and mountName ~= "" and mountName) or m.fallbackName,
				have = have,
				need = m.need,
			}
		end
	end
	return out
end
