--[[
	Midnight Helper - Event-style toast notifications (achievement / loot toast look).
	Queue-based; click optional. Phase 1: Trovehunter's Bounty in delves.
]]

local _, ns = ...

local Config = ns.Config or {}
local ITEM_TREASURE = Config.DELVE_ITEM_TROVEHUNTER_BOUNTY or 252415

local TOAST_W = 320
local TOAST_H = 64
local ICON_SIZE = 40
local ICON_PAD_L = 14
local DISPLAY_SEC = 4.25
local FADE_IN_SEC = 0.35
local FADE_OUT_SEC = 0.45
local GAP_SEC = 0.2

local toastFrame
local queue = {}
local activeSpec
local hideTimer
local fadeGen = 0

local function GetToastSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { enabled = true, delveBounty = true }
	end
	if type(ui.toast) ~= "table" then
		ui.toast = { enabled = true, delveBounty = true }
	end
	return ui.toast
end

local function ResolveText(spec, field)
	if not spec then
		return ""
	end
	local key = spec[field .. "Key"]
	if key and ns.L then
		local s = ns:L(key)
		if s and s ~= key then
			return s
		end
	end
	return spec[field] or ""
end

local function ResolveItemIcon(spec)
	if spec.icon then
		return spec.icon
	end
	local itemID = spec.itemID or ITEM_TREASURE
	if ns.GetDelveItemIcon then
		return ns:GetDelveItemIcon(itemID)
	end
	if C_Item and C_Item.GetItemIconByID then
		local ok, tex = pcall(C_Item.GetItemIconByID, itemID)
		if ok and tex then
			return tex
		end
	end
	return 134414
end

local function ApplyItemQualityBorder(iconRing, itemID)
	if not iconRing or not itemID then
		return
	end
	local r, g, b = 1, 0.75, 0.15
	if C_Item and C_Item.GetItemQualityByID and ITEM_QUALITY_COLORS then
		local ok, quality = pcall(C_Item.GetItemQualityByID, itemID)
		if ok and quality and ITEM_QUALITY_COLORS[quality] then
			local c = ITEM_QUALITY_COLORS[quality].color
			if c then
				r, g, b = c:GetRGB()
			end
		end
	end
	if iconRing.SetVertexColor then
		iconRing:SetVertexColor(r, g, b, 0.95)
	end
end

local function ApplyToastContent(spec)
	local root = toastFrame and toastFrame.content
	if not root or not spec then
		return
	end
	local itemID = spec.itemID or ITEM_TREASURE
	local iconTex = ResolveItemIcon(spec)
	if root.icon then
		root.icon:SetTexture(iconTex)
		root.icon:Show()
	end
	if root.iconSlot then
		root.iconSlot:Show()
	end
	if root.iconRing then
		ApplyItemQualityBorder(root.iconRing, itemID)
	end
	local title = ResolveText(spec, "title")
	local body = ResolveText(spec, "body")
	if root.title then
		root.title:SetText(title ~= "" and title or "Trovehunter Bounty detected!")
		root.title:Show()
	end
	if root.body then
		root.body:SetText(body ~= "" and body or "Use it for Hidden Treasure.")
		root.body:Show()
	end
end

local function EnsureToastFrame()
	if toastFrame then
		return toastFrame
	end

	local f = CreateFrame("Button", "MidnightHelperToast", UIParent, "BackdropTemplate")
	f:SetSize(TOAST_W, TOAST_H)
	f:SetPoint("TOP", UIParent, "TOP", 0, -118)
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:SetFrameLevel(120)
	f:Hide()
	f:EnableMouse(true)
	f:RegisterForClicks("LeftButtonUp")

	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.07, 0.06, 0.1, 0.94)
		f:SetBackdropBorderColor(1, 0.82, 0.2, 1)
	end

	-- Child frame above backdrop paint (BackdropTemplate can cover direct children).
	local content = CreateFrame("Frame", nil, f)
	content:SetAllPoints()
	content:SetFrameLevel(f:GetFrameLevel() + 10)
	if content.SetPropagateMouseClicks then
		content:SetPropagateMouseClicks(true)
	end
	if content.SetPropagateMouseMotion then
		content:SetPropagateMouseMotion(true)
	end
	f.content = content

	local iconSlot = CreateFrame("Frame", nil, content)
	iconSlot:SetSize(ICON_SIZE + 4, ICON_SIZE + 4)
	iconSlot:SetPoint("LEFT", content, "LEFT", ICON_PAD_L, 0)
	if iconSlot.SetPropagateMouseClicks then
		iconSlot:SetPropagateMouseClicks(true)
	end
	content.iconSlot = iconSlot

	local icon = iconSlot:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("TOPLEFT", iconSlot, "TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", iconSlot, "BOTTOMRIGHT", -2, 2)
	content.icon = icon

	local iconRing = iconSlot:CreateTexture(nil, "OVERLAY")
	iconRing:SetPoint("TOPLEFT", iconSlot, "TOPLEFT", -3, 3)
	iconRing:SetPoint("BOTTOMRIGHT", iconSlot, "BOTTOMRIGHT", 3, -3)
	content.iconRing = iconRing
	if iconRing.SetAtlas then
		local ok = pcall(function()
			iconRing:SetAtlas("loottoast-itemborder", true)
		end)
		if not ok then
			iconRing:SetTexture("Interface\\COMMON\\WhiteIconFrame")
		end
	else
		iconRing:SetTexture("Interface\\COMMON\\WhiteIconFrame")
	end
	ApplyItemQualityBorder(iconRing, ITEM_TREASURE)

	local textLeft = ICON_PAD_L + ICON_SIZE + 16
	local title = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", content, "TOPLEFT", textLeft, -10)
	title:SetPoint("TOPRIGHT", content, "TOPRIGHT", -12, -10)
	title:SetHeight(16)
	title:SetJustifyH("LEFT")
	title:SetJustifyV("TOP")
	title:SetTextColor(1, 0.84, 0.2)
	content.title = title

	local body = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	body:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
	body:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -12, 10)
	body:SetJustifyH("LEFT")
	body:SetJustifyV("TOP")
	body:SetWordWrap(true)
	body:SetTextColor(0.95, 0.95, 0.95)
	content.body = body

	f:SetScript("OnClick", function()
		if activeSpec and activeSpec.onClick then
			activeSpec.onClick(activeSpec)
		end
	end)

	f:SetScript("OnEnter", function(self)
		if activeSpec and activeSpec.onClick then
			if self.EnableMouse then
				self:EnableMouse(true)
			end
			if SetCursor then
				SetCursor("Interface\\CURSOR\\Point")
			end
			if GameTooltip then
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(ns:L("TOAST_CLICK_HINT"), 1, 1, 1)
				GameTooltip:Show()
			end
		end
	end)
	f:SetScript("OnLeave", function()
		if ResetCursor then
			ResetCursor()
		end
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)

	toastFrame = f
	return f
end

local function CancelHideTimer()
	if hideTimer and C_Timer and C_Timer.Cancel then
		pcall(C_Timer.Cancel, hideTimer)
	end
	hideTimer = nil
end

local function FinishToast()
	CancelHideTimer()
	activeSpec = nil
	if toastFrame then
		toastFrame:Hide()
		toastFrame:SetAlpha(1)
	end
	if #queue > 0 and C_Timer and C_Timer.After then
		C_Timer.After(GAP_SEC, function()
			if ns.ShowNextMidnightToast then
				ns:ShowNextMidnightToast()
			end
		end)
	end
end

local function StartHideTimer()
	CancelHideTimer()
	if not (C_Timer and C_Timer.After) then
		return
	end
	hideTimer = C_Timer.After(DISPLAY_SEC, function()
		hideTimer = nil
		if not toastFrame or not toastFrame:IsShown() then
			FinishToast()
			return
		end
		fadeGen = fadeGen + 1
		local gen = fadeGen
		if UIFrameFadeOut then
			UIFrameFadeOut(toastFrame, FADE_OUT_SEC, toastFrame:GetAlpha(), 0)
		end
		C_Timer.After(FADE_OUT_SEC + 0.05, function()
			if gen ~= fadeGen then
				return
			end
			FinishToast()
		end)
	end)
end

function ns.ShowNextMidnightToast()
	if activeSpec or #queue == 0 then
		return
	end
	local s = GetToastSettings()
	if not s.enabled then
		wipe(queue)
		return
	end

	local spec = table.remove(queue, 1)
	activeSpec = spec
	local f = EnsureToastFrame()
	ApplyToastContent(spec)
	f:SetAlpha(1)
	f:Show()
	if f.content then
		f.content:Show()
	end
	if f.Raise then
		f:Raise()
	end
	fadeGen = fadeGen + 1
	if UIFrameFadeIn then
		f:SetAlpha(0)
		UIFrameFadeIn(f, FADE_IN_SEC, 0, 1)
	else
		f:SetAlpha(1)
	end
	StartHideTimer()
end

function ns.QueueMidnightToast(spec)
	if type(spec) ~= "table" then
		return
	end
	local s = GetToastSettings()
	if not s.enabled then
		return
	end
	if spec.id then
		for i = 1, #queue do
			if queue[i].id == spec.id then
				return
			end
		end
		if activeSpec and activeSpec.id == spec.id then
			return
		end
	end
	queue[#queue + 1] = spec
	if not activeSpec then
		ns.ShowNextMidnightToast()
	end
end

function ns.ClearMidnightToastQueue()
	wipe(queue)
	activeSpec = nil
	CancelHideTimer()
	fadeGen = fadeGen + 1
	if toastFrame then
		toastFrame:Hide()
	end
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if activeSpec and toastFrame and toastFrame:IsShown() then
			ApplyToastContent(activeSpec)
		end
	end
end
