--[[
	Midnight Helper — Loot upgrade tips.
	Answers the everyday beginner question "should I put this on?" by adding one
	line to an item's tooltip: is it an upgrade over what you have equipped in that
	slot, for your spec. Reuses the Great Vault scorer + your spec's stat weights
	(ns.GetLootUpgradeInfo in VaultAdvisor.lua) — no second stat model.

	never-lie: item level is exact; the spec verdict is guide-based stat weights, so
	only clear-cut cases are called Upgrade/Lower — a higher-ilvl-but-worse-stats (or
	vice-versa) item is honestly a "Sidegrade", a judgment call. Nothing shows when we
	can't compare (non-gear, empty slot, no weights).

	Toggle with /mh loot (on by default).
]]

local _, ns = ...

local COLORS = {
	upgrade = { 0.20, 1.00, 0.20 },
	side = { 1.00, 0.82, 0.20 },
	lower = { 0.60, 0.60, 0.60 },
}

local function enabled()
	return not (ns.db and ns.db.lootUpgradeTips == false)
end

local function ilvlNote(delta)
	if delta > 0 then
		return (ns:L("LOOT_UP_ILVL_UP_FMT")):format(delta)
	elseif delta < 0 then
		return (ns:L("LOOT_UP_ILVL_DOWN_FMT")):format(-delta)
	end
	return ns:L("LOOT_UP_ILVL_SAME")
end

local function verdict(info)
	local s, i = info.scoreDelta, info.ilvlDelta
	if s > 0 and i >= 0 then
		return "LOOT_UP_UPGRADE", COLORS.upgrade
	elseif s < 0 and i <= 0 then
		return "LOOT_UP_LOWER", COLORS.lower
	end
	return "LOOT_UP_SIDEGRADE", COLORS.side
end

local function addLine(tooltip, link)
	if not enabled() or not ns.GetLootUpgradeInfo then
		return
	end
	local info = ns.GetLootUpgradeInfo(link)
	if not info then
		return
	end
	-- exact match = you're almost certainly looking at the item you already wear.
	if info.ilvlDelta == 0 and info.scoreDelta == 0 then
		return
	end
	local key, c = verdict(info)
	local text = ("|cffffcc00MH|r %s · %s %s"):format(ns:L(key), ilvlNote(info.ilvlDelta), ns:L("LOOT_UP_FORSPEC"))
	tooltip:AddLine(text, c[1], c[2], c[3])
end

local function Init()
	if ns._mhLootUpgradeHooked then
		return
	end
	if not (TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType and Enum.TooltipDataType.Item) then
		return
	end
	ns._mhLootUpgradeHooked = true

	pcall(TooltipDataProcessor.AddTooltipPostCall, Enum.TooltipDataType.Item, function(tooltip, data)
		if tooltip ~= GameTooltip and tooltip ~= ItemRefTooltip then
			return -- keep shopping/compare tooltips clean
		end
		if type(data) ~= "table" then
			return
		end
		local link = data.hyperlink
		if not link and TooltipUtil and TooltipUtil.GetDisplayedItem then
			local _, l = TooltipUtil.GetDisplayedItem(tooltip)
			link = l
		end
		if not link then
			return
		end
		local ok = pcall(addLine, tooltip, link)
		if not ok then
			-- one bad tooltip must never break the game's tooltip; stay silent.
		end
	end)
end

-- /mh loot — toggle the tooltip tips. Returns the new on/off state.
function ns.ToggleLootUpgradeTips()
	ns.db = ns.db or {}
	ns.db.lootUpgradeTips = (ns.db.lootUpgradeTips == false)
	return ns.db.lootUpgradeTips ~= false
end

Init()
