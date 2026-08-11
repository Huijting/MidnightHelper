local _, ns = ...

--[[
	Midnight Helper — a small bar for the things you otherwise type (`/mh bar`).

	Rob hides MH's minimap icon inside a button-collector addon, so the shift-click
	reload added this morning is unreachable for him. He also pointed at `!Pig`'s
	toolbar: one button whose left/right/shift-clicks are three different ways to leave
	a group. Both wants are the same want — a couple of actions somewhere reachable that
	are not a slash command you have to remember.

	⚠️ OFF BY DEFAULT, and it stays off until switched on in Settings. A bar that appears
	on your screen uninvited is the behaviour this addon keeps objecting to in others.

	⚠️ WHAT THE BUTTONS MAY DO. Reload is ours to call. Leaving a group goes through
	`C_PartyInfo.LeaveParty`, and whether it accepts a category argument is checked
	against the client rather than assumed — `Enum.PartyCategory` is read, not hardcoded,
	and a button whose API is missing is disabled with a tooltip saying so instead of
	failing silently on click.

	Position is remembered per account, like the other movable frames.
]]

local BAR_NAME = "MidnightHelperQuickBar"
local BTN, PAD = 26, 4
local bar

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH:")
end

local function Enabled()
	return not not (ns.db and ns.db.ui and ns.db.ui.quickBar)
end

--- Does this client take a party category, and what are the values?
---
--- Read rather than assumed: `Enum.PartyCategory` is the game's own table, so if a name
--- changes the button turns itself off instead of calling nonsense.
local function PartyCategories()
	local e = Enum and Enum.PartyCategory
	if type(e) ~= "table" then
		return nil, nil
	end
	return e.Home, e.Instance
end

local function LeaveGroup(category)
	if not (C_PartyInfo and C_PartyInfo.LeaveParty) then
		print(Prefix() .. " " .. ns:L("QUICKBAR_NO_API"))
		return
	end
	local ok
	if category ~= nil then
		ok = pcall(C_PartyInfo.LeaveParty, category)
	else
		ok = pcall(C_PartyInfo.LeaveParty)
	end
	if not ok then
		print(Prefix() .. " " .. ns:L("QUICKBAR_NO_API"))
	end
end

--- Buttons, in order. `atlas` first because a missing texture file is a black square,
--- while a missing atlas simply draws nothing.
local ACTIONS = {
	{
		id = "reload",
		icon = "Interface\\Buttons\\UI-RefreshButton",
		titleKey = "QUICKBAR_RELOAD",
		linesKey = { "QUICKBAR_RELOAD_L" },
		OnClick = function()
			if InCombatLockdown and InCombatLockdown() then
				print(Prefix() .. " " .. ns:L("BROKER_RELOAD_COMBAT"))
				return
			end
			if C_UI and C_UI.Reload then
				C_UI.Reload()
			elseif ReloadUI then
				ReloadUI()
			end
		end,
	},
	{
		id = "leave",
		icon = "Interface\\Buttons\\UI-GroupLoot-Pass-Up",
		titleKey = "QUICKBAR_LEAVE",
		linesKey = { "QUICKBAR_LEAVE_L", "QUICKBAR_LEAVE_R" },
		OnClick = function(_, button)
			local home, instance = PartyCategories()
			if button == "RightButton" then
				LeaveGroup(instance)
			else
				LeaveGroup(home)
			end
		end,
	},
	{
		id = "setup",
		icon = "Interface\\Buttons\\UI-OptionsButton",
		titleKey = "QUICKBAR_SETUP",
		linesKey = { "QUICKBAR_SETUP_L" },
		OnClick = function()
			if ns.MH_ShowLayoutWizard then
				ns.MH_ShowLayoutWizard()
			end
		end,
	},
}

local function Build()
	if bar then
		return bar
	end
	local f = CreateFrame("Frame", BAR_NAME, UIParent, "BackdropTemplate")
	f:SetSize(#ACTIONS * (BTN + PAD) + PAD, BTN + PAD * 2)
	f:SetFrameStrata("MEDIUM")
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		-- Remember where it was put, like the main window does.
		local point, _, relPoint, x, y = self:GetPoint()
		if ns.db then
			ns.db.ui = ns.db.ui or {}
			ns.db.ui.quickBarPos = { point = point, relPoint = relPoint, x = x, y = y }
		end
	end)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.07, 0.85)
		f:SetBackdropBorderColor(0.55, 0.46, 0.3, 0.9)
	end

	local pos = ns.db and ns.db.ui and ns.db.ui.quickBarPos
	if type(pos) == "table" and pos.point then
		f:SetPoint(pos.point, UIParent, pos.relPoint or pos.point, pos.x or 0, pos.y or 0)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 0, -180)
	end

	for i, act in ipairs(ACTIONS) do
		local b = CreateFrame("Button", nil, f)
		b:SetSize(BTN, BTN)
		b:SetPoint("LEFT", f, "LEFT", PAD + (i - 1) * (BTN + PAD), 0)
		b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		b:SetNormalTexture(act.icon)
		b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		b:SetScript("OnClick", act.OnClick)
		b:SetScript("OnEnter", function(self)
			if not GameTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:SetText(ns:L(act.titleKey), 1, 0.9, 0.6)
			for _, k in ipairs(act.linesKey or {}) do
				GameTooltip:AddLine(ns:L(k), 0.85, 0.85, 0.85, true)
			end
			GameTooltip:AddLine(ns:L("QUICKBAR_DRAG"), 0.55, 0.55, 0.6, true)
			GameTooltip:Show()
		end)
		b:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
	end

	bar = f
	return f
end

function ns.MH_RefreshQuickBar()
	if not Enabled() then
		if bar then
			bar:Hide()
		end
		return
	end
	Build():Show()
end

--- `/mh bar` — show or hide it, and remember the choice.
function ns.MH_ToggleQuickBar()
	ns.db = ns.db or {}
	ns.db.ui = ns.db.ui or {}
	ns.db.ui.quickBar = not Enabled()
	ns.MH_RefreshQuickBar()
	print(("%s %s"):format(Prefix(),
		ns:L(Enabled() and "QUICKBAR_ON" or "QUICKBAR_OFF")))
end

function ns.IsQuickBarShown()
	return Enabled()
end

function ns.SetQuickBarShown(v)
	ns.db = ns.db or {}
	ns.db.ui = ns.db.ui or {}
	ns.db.ui.quickBar = not not v
	ns.MH_RefreshQuickBar()
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:SetScript("OnEvent", function()
	ns.MH_RefreshQuickBar()
end)
