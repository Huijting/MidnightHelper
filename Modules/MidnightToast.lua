--[[
	Midnight Helper - Event-style toast notifications (achievement / loot toast look).
	Queue-based; click optional. Phase 1: Trovehunter's Bounty in delves.
]]

local _, ns = ...

local TOAST_W = 328
local TOAST_H = 72
local ICON_SIZE = 44
local DISPLAY_SEC = 4.25
local FADE_IN_SEC = 0.35
local FADE_OUT_SEC = 0.45
local GAP_SEC = 0.2

local TEX = {
	bg = "Interface\\AchievementFrame\\UI-Achievement-Alert-Background",
	border = "Interface\\AchievementFrame\\UI-Achievement-Alert-Border",
	glow = "Interface\\AchievementFrame\\UI-Achievement-Icon-Glow",
}

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

local function ApplyToastContent(spec)
	if not toastFrame or not spec then
		return
	end
	if spec.icon and toastFrame.icon then
		toastFrame.icon:SetTexture(spec.icon)
		toastFrame.icon:Show()
	elseif toastFrame.icon then
		toastFrame.icon:Hide()
	end
	if toastFrame.title then
		toastFrame.title:SetText(ResolveText(spec, "title"))
	end
	if toastFrame.body then
		toastFrame.body:SetText(ResolveText(spec, "body"))
	end
end

local function EnsureToastFrame()
	if toastFrame then
		return toastFrame
	end

	local f = CreateFrame("Button", "MidnightHelperToast", UIParent, "BackdropTemplate")
	f:SetSize(TOAST_W, TOAST_H)
	f:SetPoint("TOP", UIParent, "TOP", 0, -118)
	f:SetFrameStrata("TOAST")
	f:SetFrameLevel(5000)
	f:Hide()
	f:EnableMouse(true)
	f:RegisterForClicks("LeftButtonUp")

	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = TEX.bg,
			edgeFile = TEX.border,
			tile = false,
			edgeSize = 28,
			insets = { left = 8, right = 8, top = 8, bottom = 8 },
		})
		f:SetBackdropColor(1, 1, 1, 1)
		f:SetBackdropBorderColor(1, 0.82, 0, 1)
	end

	local glow = f:CreateTexture(nil, "BACKGROUND")
	glow:SetTexture(TEX.glow)
	glow:SetBlendMode("ADD")
	glow:SetPoint("CENTER", f, "LEFT", 36, 0)
	glow:SetSize(96, 96)
	glow:SetAlpha(0.55)
	f.glow = glow

	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetSize(ICON_SIZE, ICON_SIZE)
	icon:SetPoint("LEFT", f, "LEFT", 18, 0)
	f.icon = icon

	local iconBorder = f:CreateTexture(nil, "OVERLAY")
	iconBorder:SetTexture("Interface\\COMMON\\WhiteIconFrame")
	iconBorder:SetSize(ICON_SIZE + 10, ICON_SIZE + 10)
	iconBorder:SetPoint("CENTER", icon, "CENTER", 0, 0)
	iconBorder:SetVertexColor(1, 0.75, 0.15, 0.9)

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOPLEFT", icon, "TOPRIGHT", 14, -4)
	title:SetPoint("RIGHT", f, "RIGHT", -16, 0)
	title:SetJustifyH("LEFT")
	title:SetTextColor(1, 0.82, 0)
	f.title = title

	local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	body:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
	body:SetPoint("RIGHT", f, "RIGHT", -16, 0)
	body:SetJustifyH("LEFT")
	body:SetWordWrap(true)
	f.body = body

	f:SetScript("OnClick", function()
		if activeSpec and activeSpec.onClick then
			activeSpec.onClick(activeSpec)
		end
	end)

	f:SetScript("OnEnter", function(self)
		if activeSpec and activeSpec.onClick and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(ns:L("TOAST_CLICK_HINT"), 1, 1, 1)
			GameTooltip:Show()
		end
	end)
	f:SetScript("OnLeave", function()
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
	f:SetAlpha(0)
	f:Show()
	if f.Raise then
		f:Raise()
	end
	fadeGen = fadeGen + 1
	if UIFrameFadeIn then
		UIFrameFadeIn(f, FADE_IN_SEC, 0, 1)
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
