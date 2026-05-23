--[[
	Midnight Helper — floating Delve consumables popup (RAID-R Mini + Trovehunter's Bounty).

	Large, draggable buttons visible only during an active delve when you carry the items.
	Minimap icons (in-delve only) open this popup on left-click; right-click quick-uses the item.
]]

local addonName, ns = ...

local C_Item = C_Item
local Config = ns.Config or {}

local ITEM_RADAR = Config.DELVE_ITEM_RAID_R_MINI or 244193
local ITEM_TREASURE = Config.DELVE_ITEM_TROVEHUNTER_BOUNTY or 252415

local POPUP_MIN_H = 168
local BTN_SIZE = 52
local BTN_W = BTN_SIZE + 10
local BTN_H = BTN_SIZE + 22
local BTN_GAP = 14

local ITEM_ROWS = {
	{
		itemID = ITEM_RADAR,
		titleKey = "DELVE_MINIMAP_RADAR_TITLE",
		hintKey = "DELVE_MINIMAP_RADAR_HINT",
		shortKey = "DELVE_ITEMS_POPUP_RADAR_SHORT",
		secureName = "MidnightHelperUseDelveRadar",
	},
	{
		itemID = ITEM_TREASURE,
		titleKey = "DELVE_MINIMAP_TREASURE_TITLE",
		hintKey = "DELVE_MINIMAP_TREASURE_HINT",
		shortKey = "DELVE_ITEMS_POPUP_TREASURE_SHORT",
		secureName = "MidnightHelperUseDelveTreasure",
	},
}

local popupFrame
local secureButtons = {}
local autoShowSuppressed = false
local autoShowRetryGen = 0
local bountyToastShownThisDelve = false

local function IsDelveItemsUiAllowed()
	return ns.IsPlayerInActiveDelve and ns.IsPlayerInActiveDelve()
end

function ns:ClearDelveItemsAutoShowSuppress()
	autoShowSuppressed = false
	if popupFrame then
		popupFrame._userClosed = false
	end
end

function ns:SuppressDelveItemsAutoShow()
	autoShowSuppressed = true
	if popupFrame then
		popupFrame._userClosed = true
	end
end

function ns:CancelDelveItemsAutoShowRetries()
	autoShowRetryGen = autoShowRetryGen + 1
end

function ns:HideDelveItemsUiLeavingDelve()
	self:CancelDelveItemsAutoShowRetries()
	bountyToastShownThisDelve = false
	self:HideDelveItemsPopup()
	if self.RefreshDelveItemBrokers then
		self:RefreshDelveItemBrokers()
	end
end

function ns:MaybeShowDelveBountyToast()
	if bountyToastShownThisDelve then
		return
	end
	if not IsDelveItemsUiAllowed() then
		return
	end
	local ui = ns.db and ns.db.ui
	local toastCfg = ui and ui.toast
	if toastCfg and (toastCfg.enabled == false or toastCfg.delveBounty == false) then
		return
	end
	if GetItemCount(ITEM_TREASURE) < 1 then
		return
	end
	if not ns.QueueMidnightToast then
		return
	end
	bountyToastShownThisDelve = true
	ns:QueueMidnightToast({
		id = "delve_bounty",
		icon = GetItemIcon(ITEM_TREASURE),
		titleKey = "TOAST_BOUNTY_TITLE",
		bodyKey = "TOAST_BOUNTY_BODY",
		onClick = function()
			if ns.ShowDelveItemsPopup then
				ns:ShowDelveItemsPopup()
			end
		end,
	})
end

function ns:PreviewDelveBountyToast()
	if not ns.QueueMidnightToast then
		return
	end
	ns:QueueMidnightToast({
		id = "delve_bounty_preview",
		icon = GetItemIcon(ITEM_TREASURE),
		titleKey = "TOAST_BOUNTY_TITLE",
		bodyKey = "TOAST_BOUNTY_BODY",
		onClick = function()
			if ns.ShowDelveItemsPopup then
				ns:ShowDelveItemsPopup()
			end
		end,
	})
end

function ns:ScheduleDelveItemsAutoShowRetries()
	if not IsDelveItemsUiAllowed() then
		return
	end
	autoShowRetryGen = autoShowRetryGen + 1
	local gen = autoShowRetryGen
	local delays = { 0.35, 1.0, 2.5, 5.0 }
	if not (C_Timer and C_Timer.After) then
		if gen == autoShowRetryGen and IsDelveItemsUiAllowed() and self.MaybeAutoShowDelveItemsPopup then
			self:MaybeAutoShowDelveItemsPopup()
		end
		return
	end
	for _, delay in ipairs(delays) do
		C_Timer.After(delay, function()
			if gen ~= autoShowRetryGen or not IsDelveItemsUiAllowed() then
				return
			end
			if ns.MaybeAutoShowDelveItemsPopup then
				ns:MaybeAutoShowDelveItemsPopup()
			end
		end)
	end
end

local function GetPopupSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return nil
	end
	if type(ui.delveItemsPopup) ~= "table" then
		ui.delveItemsPopup = {
			enabled = true,
			autoShowInDelve = true,
			point = "CENTER",
			relPoint = "CENTER",
			x = 0,
			y = 80,
			userPositioned = false,
		}
	end
	local s = ui.delveItemsPopup
	-- Migrate old default (far left) to centered layout once.
	if not s.userPositioned and s.point == "LEFT" and (tonumber(s.x) or 0) < -200 then
		s.point = "CENTER"
		s.relPoint = "CENTER"
		s.x = 0
		s.y = 80
	end
	return s
end

local function GetItemCount(itemID)
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

local function HasAnyDelveConsumable()
	for _, row in ipairs(ITEM_ROWS) do
		if GetItemCount(row.itemID) > 0 then
			return true
		end
	end
	return false
end

local function GetItemIcon(itemID)
	if C_Item and C_Item.GetItemIconByID then
		local ok, tex = pcall(C_Item.GetItemIconByID, itemID)
		if ok and tex then
			return tex
		end
	end
	return 134414
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

local function EnsureSecureUseButton(row)
	if secureButtons[row.itemID] then
		return secureButtons[row.itemID]
	end
	local btn = CreateFrame("Button", row.secureName, UIParent, "SecureActionButtonTemplate")
	btn:SetSize(1, 1)
	btn:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	btn:SetAttribute("type", "macro")
	btn:SetAttribute("macrotext", ("/use item:%d"):format(row.itemID))
	btn:RegisterForClicks("AnyUp", "AnyDown")
	secureButtons[row.itemID] = btn
	return btn
end

function ns:UseDelveConsumableItem(itemID)
	local titleKey
	for _, row in ipairs(ITEM_ROWS) do
		if row.itemID == itemID then
			titleKey = row.titleKey
			break
		end
	end
	local label = titleKey and ns:L(titleKey) or "Item"
	if InCombatLockdown() then
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("DELVE_MINIMAP_USE_COMBAT_FMT"):format(label)))
		return false
	end
	if GetItemCount(itemID) < 1 then
		if ns.RefreshDelveItemsPopup then
			ns:RefreshDelveItemsPopup()
		end
		return false
	end
	local btn
	for _, row in ipairs(ITEM_ROWS) do
		if row.itemID == itemID then
			btn = EnsureSecureUseButton(row)
			break
		end
	end
	if btn and btn.Click then
		btn:Click("LeftButton")
		return true
	end
	return false
end

local function ApplyCenterPoint(f)
	f:ClearAllPoints()
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
end

local function ApplySavedPoint(f)
	local s = GetPopupSettings()
	if not s or not s.userPositioned then
		ApplyCenterPoint(f)
		return
	end
	f:ClearAllPoints()
	f:SetPoint(s.point or "CENTER", UIParent, s.relPoint or "CENTER", tonumber(s.x) or 0, tonumber(s.y) or 80)
end

local function SavePoint(f, userMoved)
	local s = GetPopupSettings()
	if not s then
		return
	end
	if userMoved then
		s.userPositioned = true
	end
	local point, _, relPoint, x, y = f:GetPoint(1)
	if point then
		s.point = point
		s.relPoint = relPoint or point
		s.x = x or s.x
		s.y = y or s.y
	end
end

local function LayoutItemButtons(f, visibleCount)
	local rowHost = f._rowHost
	if not rowHost or not f._itemBtns then
		return
	end
	local visible = {}
	for _, btn in ipairs(f._itemBtns) do
		if btn:IsShown() then
			visible[#visible + 1] = btn
		end
	end
	local n = #visible
	if n == 0 then
		return
	end
	local totalW = n * BTN_W + (n - 1) * BTN_GAP
	f:SetWidth(math.max(180, totalW + 52))
	f:SetHeight(POPUP_MIN_H)
	if n == 1 then
		visible[1]:ClearAllPoints()
		visible[1]:SetPoint("CENTER", rowHost, "CENTER", 0, -2)
	elseif n == 2 then
		visible[1]:ClearAllPoints()
		visible[1]:SetPoint("RIGHT", rowHost, "CENTER", -BTN_GAP / 2, -2)
		visible[2]:ClearAllPoints()
		visible[2]:SetPoint("LEFT", rowHost, "CENTER", BTN_GAP / 2, -2)
	end
end

local function EnsurePopupFrame()
	if popupFrame then
		if popupFrame._rowHost and popupFrame._itemBtns then
			for _, btn in ipairs(popupFrame._itemBtns) do
				btn:SetSize(BTN_W, BTN_H)
			end
		end
		popupFrame:SetHeight(POPUP_MIN_H)
		return popupFrame
	end

	local f = CreateFrame("Frame", "MidnightHelperDelveItemsPopup", UIParent, "BackdropTemplate")
	f:SetSize(200, POPUP_MIN_H)
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(200)
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePoint(self, true)
	end)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.06, 0.06, 0.1, 0.94)
	end
	tinsert(UISpecialFrames, f:GetName())

	local titleBar = CreateFrame("Frame", nil, f)
	titleBar:SetHeight(22)
	titleBar:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -10)
	titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -28, -10)
	titleBar:EnableMouse(true)
	titleBar:RegisterForDrag("LeftButton")
	titleBar:SetScript("OnDragStart", function()
		f:StartMoving()
	end)
	titleBar:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		SavePoint(f, true)
	end)

	local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("CENTER", titleBar, "CENTER", -8, 0)
	title:SetJustifyH("CENTER")
	title:SetTextColor(1, 0.9, 0.55)
	f._title = title

	local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
	closeBtn:SetScript("OnClick", function()
		if ns.SuppressDelveItemsAutoShow then
			ns:SuppressDelveItemsAutoShow()
		else
			f._userClosed = true
		end
		f:Hide()
	end)
	f._closeBtn = closeBtn

	local hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	hint:SetPoint("TOP", titleBar, "BOTTOM", 0, -6)
	hint:SetPoint("LEFT", f, "LEFT", 14, 0)
	hint:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	hint:SetJustifyH("CENTER")
	hint:SetWordWrap(true)
	hint:SetTextColor(0.82, 0.8, 0.74)
	f._hint = hint

	local rowHost = CreateFrame("Frame", nil, f)
	rowHost:SetPoint("TOP", hint, "BOTTOM", 0, -8)
	rowHost:SetPoint("LEFT", f, "LEFT", 16, 0)
	rowHost:SetPoint("RIGHT", f, "RIGHT", -16, 0)
	rowHost:SetPoint("BOTTOM", f, "BOTTOM", 18, 0)
	f._rowHost = rowHost
	f._itemBtns = {}

	for i, row in ipairs(ITEM_ROWS) do
		local btn = CreateFrame("Button", nil, rowHost, "BackdropTemplate")
		btn:SetSize(BTN_W, BTN_H)
		btn:SetPoint("CENTER", rowHost, "CENTER", 0, 0)
		if btn.SetBackdrop then
			btn:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8X8",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = false,
				edgeSize = 10,
				insets = { left = 2, right = 2, top = 2, bottom = 2 },
			})
			btn:SetBackdropColor(0.08, 0.1, 0.14, 0.95)
			btn:SetBackdropBorderColor(0.55, 0.45, 0.22, 0.95)
		end

		local icon = btn:CreateTexture(nil, "ARTWORK")
		icon:SetSize(BTN_SIZE - 4, BTN_SIZE - 4)
		icon:SetPoint("TOP", btn, "TOP", 0, -6)
		btn._icon = icon

		local countFs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		countFs:SetPoint("TOPRIGHT", icon, "TOPRIGHT", 4, -2)
		countFs:SetTextColor(0.3, 1, 0.35)
		btn._countFs = countFs

		local labelFs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		labelFs:SetPoint("BOTTOM", btn, "BOTTOM", 0, 5)
		labelFs:SetPoint("LEFT", btn, "LEFT", 2, 0)
		labelFs:SetPoint("RIGHT", btn, "RIGHT", -2, 0)
		labelFs:SetJustifyH("CENTER")
		labelFs:SetWordWrap(true)
		labelFs:SetTextColor(0.95, 0.9, 0.74)
		btn._labelFs = labelFs

		btn._row = row
		btn:SetScript("OnClick", function()
			ns:UseDelveConsumableItem(row.itemID)
		end)
		btn:SetScript("OnEnter", function(self)
			if not GameTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(GetItemLink(row.itemID))
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(ns:L(row.hintKey), 0.86, 0.86, 0.82, true)
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)

		f._itemBtns[i] = btn
	end

	function f:RefreshLocale()
		self._title:SetText(ns:L("DELVE_ITEMS_POPUP_TITLE"))
		self._hint:SetText(ns:L("DELVE_ITEMS_POPUP_HINT"))
		for i, btn in ipairs(self._itemBtns) do
			local row = btn._row
			if row and btn._labelFs then
				btn._labelFs:SetText(ns:L(row.shortKey))
			end
		end
	end

	popupFrame = f
	return f
end

function ns:RefreshDelveItemsPopup()
	local s = GetPopupSettings()
	if not s or s.enabled == false then
		if popupFrame then
			popupFrame:Hide()
		end
		return
	end

	if not IsDelveItemsUiAllowed() then
		if popupFrame then
			popupFrame:Hide()
		end
		if ns.RefreshDelveItemBrokers then
			ns:RefreshDelveItemBrokers()
		end
		return
	end

	if not HasAnyDelveConsumable() then
		if popupFrame then
			popupFrame:Hide()
		end
		if ns.RefreshDelveItemBrokers then
			ns:RefreshDelveItemBrokers()
		end
		return
	end

	local f = EnsurePopupFrame()
	f:RefreshLocale()

	local visibleCount = 0
	for i, btn in ipairs(f._itemBtns) do
		local row = btn._row
		local count = row and GetItemCount(row.itemID) or 0
		if count > 0 then
			visibleCount = visibleCount + 1
			btn:Show()
			btn._icon:SetTexture(GetItemIcon(row.itemID))
			btn._countFs:SetText("x" .. count)
		else
			btn:Hide()
		end
	end

	if visibleCount == 0 then
		f:Hide()
		return
	end

	LayoutItemButtons(f, visibleCount)

	if ns.RefreshDelveItemBrokers then
		ns:RefreshDelveItemBrokers()
	end
end

function ns:ShowDelveItemsPopup()
	if not IsDelveItemsUiAllowed() then
		return false
	end
	local s = GetPopupSettings()
	if not s or s.enabled == false or not HasAnyDelveConsumable() then
		return false
	end
	self:ClearDelveItemsAutoShowSuppress()
	local f = EnsurePopupFrame()
	ns:RefreshDelveItemsPopup()
	ApplySavedPoint(f)
	f:Show()
	f:Raise()
	return true
end

function ns:HideDelveItemsPopup()
	if popupFrame then
		popupFrame:Hide()
	end
end

function ns:ToggleDelveItemsPopup()
	if popupFrame and popupFrame:IsShown() then
		self:SuppressDelveItemsAutoShow()
		popupFrame:Hide()
		return false
	end
	return self:ShowDelveItemsPopup()
end

function ns:MaybeAutoShowDelveItemsPopup()
	local s = GetPopupSettings()
	if not s or s.enabled == false or s.autoShowInDelve == false then
		return
	end
	if autoShowSuppressed or (popupFrame and popupFrame._userClosed) then
		return
	end
	if not HasAnyDelveConsumable() then
		return
	end
	if ns.IsPlayerInActiveDelve and ns.IsPlayerInActiveDelve() then
		self:ShowDelveItemsPopup()
	end
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
		return
	end

	local inDelve = IsDelveItemsUiAllowed()
	if not inDelve then
		if ns.HideDelveItemsUiLeavingDelve then
			ns:HideDelveItemsUiLeavingDelve()
		else
			if popupFrame then
				popupFrame:Hide()
			end
			if ns.RefreshDelveItemBrokers then
				ns:RefreshDelveItemBrokers()
			end
		end
		eventFrame._mhWasInDelve = false
		return
	end

	if event:find("ZONE") and ns.ScheduleDelveItemsAutoShowRetries then
		ns:ScheduleDelveItemsAutoShowRetries()
	end

	if inDelve and not eventFrame._mhWasInDelve and ns.ClearDelveItemsAutoShowSuppress then
		ns:ClearDelveItemsAutoShowSuppress()
		bountyToastShownThisDelve = false
	end
	eventFrame._mhWasInDelve = inDelve

	if ns.RefreshDelveItemsPopup then
		ns:RefreshDelveItemsPopup()
	end
	if ns.MaybeShowDelveBountyToast then
		ns:MaybeShowDelveBountyToast()
	end
	if ns.MaybeAutoShowDelveItemsPopup then
		ns:MaybeAutoShowDelveItemsPopup()
	end
end)

eventFrame:SetScript("OnUpdate", function(self, elapsed)
	self._elapsed = (self._elapsed or 0) + elapsed
	if self._elapsed < 1.0 then
		return
	end
	self._elapsed = 0
	local inDelve = IsDelveItemsUiAllowed()
	if inDelve and not self._mhWasInDelve then
		if ns.ClearDelveItemsAutoShowSuppress then
			ns:ClearDelveItemsAutoShowSuppress()
		end
		if ns.ScheduleDelveItemsAutoShowRetries then
			ns:ScheduleDelveItemsAutoShowRetries()
		end
	end
	if not inDelve and self._mhWasInDelve then
		if ns.HideDelveItemsUiLeavingDelve then
			ns:HideDelveItemsUiLeavingDelve()
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
		if popupFrame and popupFrame.RefreshLocale then
			popupFrame:RefreshLocale()
		end
	end
end
