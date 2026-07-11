--[[
	Midnight Helper — bag upgrade arrows.
	Puts a small green arrow on bag items that are a clear upgrade for your spec,
	reusing the tooltip engine (ns.GetLootUpgradeInfo). Only the clear-cut case
	(better score AND not-lower ilvl) gets an arrow — same honesty bar as the
	tooltip line; sidegrades/lower items stay unmarked.

	Defensive: the retail bag API varies, so every hook/field is guarded and a bad
	item never breaks a bag button. Toggle with /mh bagarrows (on by default).
]]

local _, ns = ...

local ARROW_TEX = "Interface\\PetBattles\\BattleBar-AbilityBadge-Strong" -- green up badge

local function enabled()
	return not (ns.db and ns.db.bagUpgradeArrows == false)
end

local function getArrow(button)
	local a = button._mhUpArrow
	if not a then
		a = button:CreateTexture(nil, "OVERLAY")
		a:SetTexture(ARROW_TEX)
		a:SetSize(13, 13)
		a:SetPoint("TOPLEFT", 0, 0)
		button._mhUpArrow = a
	end
	return a
end

local function styleButton(button)
	local existing = button._mhUpArrow
	if not enabled() then
		if existing then
			existing:Hide()
		end
		return
	end
	local bag = button.GetBagID and button:GetBagID()
	local slot = button.GetID and button:GetID()
	if bag == nil or slot == nil then
		if existing then
			existing:Hide()
		end
		return
	end
	local link = C_Container and C_Container.GetContainerItemLink and C_Container.GetContainerItemLink(bag, slot)
	local show = false
	if link and ns.GetLootUpgradeInfo then
		local info = ns.GetLootUpgradeInfo(link)
		if info and (info.scoreDelta or 0) > 0 and (info.ilvlDelta or 0) >= 0 then
			show = true -- clear upgrade only (matches the green tooltip verdict)
		end
	end
	if show then
		getArrow(button):Show()
	elseif existing then
		existing:Hide()
	end
end

local function processFrame(frame)
	if not frame or type(frame.EnumerateValidItems) ~= "function" then
		return
	end
	for _, button in frame:EnumerateValidItems() do
		pcall(styleButton, button)
	end
end

local function refreshShownBags()
	for i = 1, 13 do
		local f = _G["ContainerFrame" .. i]
		if f and f:IsShown() then
			processFrame(f)
		end
	end
	if ContainerFrameCombinedBags and ContainerFrameCombinedBags:IsShown() then
		processFrame(ContainerFrameCombinedBags)
	end
end

-- Re-apply whenever Blizzard redraws a container (open, move, scroll).
if ContainerFrameMixin and ContainerFrameMixin.Update then
	hooksecurefunc(ContainerFrameMixin, "Update", processFrame)
end
if type(ContainerFrame_Update) == "function" then
	hooksecurefunc("ContainerFrame_Update", processFrame)
end

-- What counts as an upgrade shifts when you change gear, so re-eval open bags.
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
ev:SetScript("OnEvent", refreshShownBags)

-- /mh bagarrows — toggle the arrows.
function ns.ToggleBagUpgradeArrows()
	ns.db = ns.db or {}
	ns.db.bagUpgradeArrows = (ns.db.bagUpgradeArrows == false)
	refreshShownBags()
	return ns.db.bagUpgradeArrows ~= false
end
