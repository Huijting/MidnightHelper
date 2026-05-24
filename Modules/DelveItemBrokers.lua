--[[
	Midnight Helper — minimap quick-use for delve consumables.

	Shows separate LibDBIcon buttons when you have:
	- L00T RAID-R Mini (curio radar)
	- Trovehunter's Bounty (Hidden Trove)

	Visible only while inside an active Midnight delve (API + zone match).
]]

local addonName, ns = ...

local C_Item = C_Item
local Config = ns.Config or {}

local ITEM_RADAR = Config.DELVE_ITEM_RAID_R_MINI or 244193
local ITEM_TREASURE = Config.DELVE_ITEM_TROVEHUNTER_BOUNTY or 252415
local FALLBACK_ICON = 134414

local ICON_RADAR = addonName .. "_DelveRadar"
local ICON_TREASURE = addonName .. "_DelveTreasure"

local BROKERS = {
	{
		name = ICON_RADAR,
		itemID = ITEM_RADAR,
		dbKey = "minimapDelveRadar",
		titleKey = "DELVE_MINIMAP_RADAR_TITLE",
		hintKey = "DELVE_MINIMAP_RADAR_HINT",
		secureName = "MidnightHelperUseDelveRadar",
	},
	{
		name = ICON_TREASURE,
		itemID = ITEM_TREASURE,
		dbKey = "minimapDelveTreasure",
		titleKey = "DELVE_MINIMAP_TREASURE_TITLE",
		hintKey = "DELVE_MINIMAP_TREASURE_HINT",
		secureName = "MidnightHelperUseDelveTreasure",
	},
}

local function GetItemCount(itemID)
	if not itemID then
		return 0
	end
	if C_Item and C_Item.GetItemCount then
		local ok, n = pcall(C_Item.GetItemCount, itemID)
		if ok and n then
			return tonumber(n) or 0
		end
	end
	if type(GetItemCount) == "function" then
		local ok2, n2 = pcall(GetItemCount, itemID)
		if ok2 and n2 then
			return tonumber(n2) or 0
		end
	end
	return 0
end

local function GetItemIcon(itemID)
	if C_Item and C_Item.GetItemIconByID then
		local ok, tex = pcall(C_Item.GetItemIconByID, itemID)
		if ok and tex then
			return tex
		end
	end
	return FALLBACK_ICON
end

local function GetItemLink(itemID)
	if C_Item and C_Item.GetItemLinkByID then
		local ok, link = pcall(C_Item.GetItemLinkByID, itemID)
		if ok and link then
			return link
		end
	end
	return ("item:%d"):format(itemID)
end

local function OpenDelvesTab()
	if ns.ShowMainUI then
		ns:ShowMainUI()
	end
	if ns.SelectTab then
		ns.SelectTab("delves")
	end
	if ns.db and ns.db.ui then
		ns.db.ui.delvesAccordionSection = "midnight"
	end
end

local function EnsureSecureUseButton(entry)
	if entry.useBtn then
		return entry.useBtn
	end
	local btn = CreateFrame("Button", entry.secureName, UIParent, "SecureActionButtonTemplate")
	btn:SetSize(1, 1)
	btn:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	btn:SetAttribute("type", "item")
	btn:SetAttribute("item", ("item:%d"):format(entry.itemID))
	btn:SetAttribute("macrotext", nil)
	btn:SetAttribute("spell", nil)
	btn:RegisterForClicks("AnyUp", "AnyDown")
	entry.useBtn = btn
	return btn
end

local function SetMinimapIconTexture(name, texture)
	local LibStub = _G.LibStub
	if not LibStub then
		return
	end
	local iconLib = LibStub:GetLibrary("LibDBIcon-1.0", true)
	if not iconLib or not iconLib.GetMinimapButton then
		return
	end
	local button = iconLib:GetMinimapButton(name)
	if button and button.icon and button.icon.SetTexture then
		button.icon:SetTexture(texture)
	end
	local obj = ns._mhDelveItemLDB and ns._mhDelveItemLDB[name]
	if obj then
		obj.icon = texture
	end
end

local function IsDelveItemsUiAllowed()
	if ns.IsDelveInstanceInProgress then
		return ns:IsDelveInstanceInProgress()
	end
	return ns.IsPlayerInActiveDelve and ns.IsPlayerInActiveDelve()
end

function ns:RefreshDelveItemBrokers()
	if not self._mhDelveItemBrokersInited then
		return
	end
	local LibStub = _G.LibStub
	if not LibStub then
		return
	end
	local iconLib = LibStub:GetLibrary("LibDBIcon-1.0", true)
	if not iconLib then
		return
	end

	if not IsDelveItemsUiAllowed() then
		for _, entry in ipairs(BROKERS) do
			if iconLib:IsRegistered(entry.name) then
				iconLib:Hide(entry.name)
			end
		end
		return
	end

	for _, entry in ipairs(BROKERS) do
		if entry.useBtn and not InCombatLockdown() then
			entry.useBtn:SetAttribute("type", "macro")
			entry.useBtn:SetAttribute("macrotext", ("/use item:%d"):format(entry.itemID))
		end
		local count = GetItemCount(entry.itemID)
		local advise = count > 0
		local tex = GetItemIcon(entry.itemID)
		SetMinimapIconTexture(entry.name, tex)
		if advise then
			if iconLib:IsRegistered(entry.name) then
				iconLib:Show(entry.name)
			end
		elseif iconLib:IsRegistered(entry.name) then
			iconLib:Hide(entry.name)
		end
	end
end

function ns:InitDelveItemBrokers()
	if self._mhDelveItemBrokersInited then
		return
	end
	if not self.db then
		return
	end

	local LibStub = _G.LibStub
	if not LibStub then
		return
	end
	local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
	local iconLib = LibStub:GetLibrary("LibDBIcon-1.0", true)
	if not ldb or not iconLib then
		return
	end

	self._mhDelveItemLDB = self._mhDelveItemLDB or {}

	for _, entry in ipairs(BROKERS) do
		EnsureSecureUseButton(entry)
		local db = self.db[entry.dbKey]
		if type(db) ~= "table" then
			db = { hide = false }
			self.db[entry.dbKey] = db
		end

		local obj = ldb:NewDataObject(entry.name, {
			type = "launcher",
			label = self:L(entry.titleKey),
			icon = GetItemIcon(entry.itemID),
			OnClick = function(_, btn)
				if GetItemCount(entry.itemID) < 1 then
					ns:RefreshDelveItemBrokers()
					return
				end
				if btn == "RightButton" then
					if ns.ShowDelveItemsPopup then
						ns:ShowDelveItemsPopup()
					end
					return
				end
				if ns.ToggleDelveItemsPopup then
					ns:ToggleDelveItemsPopup()
				end
			end,
			OnTooltipShow = function(tt)
				local count = GetItemCount(entry.itemID)
				tt:AddLine(ns:L(entry.titleKey), 1, 1, 1)
				tt:AddLine(ns:L(entry.hintKey), 0.86, 0.86, 0.82, true)
				tt:AddLine(ns:L("DELVE_ITEMS_POPUP_MINIMAP_HINT"), 0.75, 0.78, 0.85, true)
				tt:AddLine(" ")
				tt:AddLine(("|cffffffff%s|r x%d"):format(GetItemLink(entry.itemID), count), 0.82, 0.86, 0.92)
			end,
		})
		self._mhDelveItemLDB[entry.name] = obj

		local ok, err = pcall(function()
			iconLib:Register(entry.name, obj, db)
		end)
		if not ok and self.db.ui and self.db.ui.debug then
			print(("|cffffcc00%s|r LibDBIcon:Register(%s) failed: %s"):format(ns:L("PRINT_PREFIX"), entry.name, tostring(err)))
		end
		iconLib:Hide(entry.name)
	end

	self._mhDelveItemBrokersInited = true
	self:RefreshDelveItemBrokers()
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", function(_, event, arg1)
	if event == "ADDON_LOADED" then
		if arg1 ~= addonName then
			return
		end
		if ns.db then
			ns:InitDelveItemBrokers()
		end
		return
	end
	if not IsDelveItemsUiAllowed() then
		if ns.HideDelveItemsUiLeavingDelve then
			ns:HideDelveItemsUiLeavingDelve()
		elseif ns.RefreshDelveItemBrokers then
			ns:RefreshDelveItemBrokers()
		end
		eventFrame._mhWasInDelve = false
		return
	end
	if ns.RefreshDelveItemBrokers then
		ns:RefreshDelveItemBrokers()
	end
	if not InCombatLockdown() and ns.RefreshDelveItemsPopup then
		ns:RefreshDelveItemsPopup()
	end
end)

eventFrame:SetScript("OnUpdate", function(self, elapsed)
	self._elapsed = (self._elapsed or 0) + elapsed
	if self._elapsed < 0.5 then
		return
	end
	self._elapsed = 0
	local inDelve = IsDelveItemsUiAllowed()
	if not inDelve and self._mhWasInDelve then
		if ns.HideDelveItemsUiLeavingDelve then
			ns:HideDelveItemsUiLeavingDelve()
		elseif ns.RefreshDelveItemBrokers then
			ns:RefreshDelveItemBrokers()
		end
	end
	self._mhWasInDelve = inDelve and true or false
end)

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if self._mhDelveItemLDB then
			for _, entry in ipairs(BROKERS) do
				local obj = self._mhDelveItemLDB[entry.name]
				if obj then
					obj.label = self:L(entry.titleKey)
				end
			end
		end
	end
end
