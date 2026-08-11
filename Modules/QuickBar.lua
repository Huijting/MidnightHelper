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

--- Leave a delve.
---
--- Rob pointed out that leaving IS available from your portrait — and so are the other
--- two this button already offers. Two of three on the bar just sends people hunting
--- for the third, so it belongs here whether or not the portrait can do it.
---
--- ⚠️ `C_PartyInfo.DelveTeleportOut` — MEASURED, not guessed, and nothing like the
--- names I would have tried.
---
--- The first version reasoned its way to `LeaveParty` and failed in Rob's delve. The
--- scan (`/mh delveexit`, run from inside one) then showed why: he was solo in a
--- SCENARIO, difficulty 208 "Delves", with a group of zero. There was no party to
--- leave, and the real call sits two entries away from the one I picked.
---
--- The fallbacks stay for content that is not a delve, and the whole attempt list is
--- still recorded — this addon has now been wrong twice about which call ends an
--- instance, and a third time should leave evidence rather than silence.
local function LeaveDelve()
	local tried = {}

	local function attempt(label, fn, ...)
		if type(fn) ~= "function" then
			tried[#tried + 1] = label .. "=absent"
			return false
		end
		local ok, err = pcall(fn, ...)
		tried[#tried + 1] = label .. (ok and "=ok" or ("=error:" .. tostring(err)))
		return ok
	end

	local _, instance = PartyCategories()

	-- The delve's own exit, first.
	if attempt("DelveTeleportOut", C_PartyInfo and C_PartyInfo.DelveTeleportOut) then
		return
	end
	-- In a group inside an instance, leaving the instance group is the way out.
	if instance ~= nil and attempt("LeaveParty(Instance)",
			C_PartyInfo and C_PartyInfo.LeaveParty, instance) then
		return
	end
	if attempt("LeaveInstanceParty", _G.LeaveInstanceParty) then
		return
	end
	if attempt("LeaveParty()", C_PartyInfo and C_PartyInfo.LeaveParty) then
		return
	end

	--- Nothing worked. Say so, and keep the attempt list for the next look — this is
	--- exactly the kind of question `/mh` probes exist to answer, and a delve is the
	--- only place it can be asked.
	if ns.db then
		ns.db.leaveDelveProbe = { at = time(), tried = tried, api = ns.MH_DelveExitScan and ns.MH_DelveExitScan() }
	end
	print(Prefix() .. " " .. ns:L("QUICKBAR_DELVE_UNKNOWN"))
end

--- `/mh delveexit` — everything this client offers that could leave a delve.
---
--- Rob's portrait menu can do it, so a call exists; `LeaveParty` is simply not it. Names
--- are not guessed at here — the client is enumerated: what state it says you are in,
--- every function in the party/LFG namespaces, and every global whose name mentions
--- leaving or exiting. A probe built on guessed names finds nothing for two different
--- reasons and cannot tell them apart.
function ns.MH_DelveExitScan()
	local out = { globals = {}, namespaces = {}, state = {} }

	if IsInInstance then
		local ok, inInstance, kind = pcall(IsInInstance)
		out.state.inInstance = ok and tostring(inInstance) or "error"
		out.state.instanceType = ok and tostring(kind) or "error"
	end
	if GetInstanceInfo then
		local ok, name, kind, diffID, diffName = pcall(GetInstanceInfo)
		if ok then
			out.state.name = tostring(name)
			out.state.type = tostring(kind)
			out.state.difficulty = ("%s (%s)"):format(tostring(diffID), tostring(diffName))
		end
	end
	if C_PartyInfo and C_PartyInfo.IsPartyFull then
		out.state.numGroup = GetNumGroupMembers and select(1, pcall(GetNumGroupMembers)) and
			tostring(GetNumGroupMembers()) or "?"
	end

	--- Whole namespaces, so a name nobody thought of still shows up.
	for _, nsName in ipairs({ "C_PartyInfo", "C_LFGInfo", "C_Scenario", "C_DelvesUI",
	                          "C_LFGList", "C_SummonInfo" }) do
		local tbl = _G[nsName]
		if type(tbl) == "table" then
			local names = {}
			for k, v in pairs(tbl) do
				if type(k) == "string" and type(v) == "function" then
					names[#names + 1] = k
				end
			end
			table.sort(names)
			out.namespaces[nsName] = names
		else
			out.namespaces[nsName] = "absent"
		end
	end

	--- Globals that mention leaving. `_G` is large, so this is the one broad sweep and
	--- it is filtered hard.
	for k, v in pairs(_G) do
		if type(k) == "string" and type(v) == "function" then
			local lower = k:lower()
			if lower:find("leave") or lower:find("teleportout") or lower:find("exitinstance") then
				out.globals[#out.globals + 1] = k
			end
		end
	end
	table.sort(out.globals)

	if ns.db then
		ns.db.delveExitScan = out
	end
	print(("%s delve-exit scan: |cffffffff%d|r matching global(s); state=%s/%s. "
		.. "|cff9d9d9dSaved \226\128\148 /reload to write the file.|r"):format(
		Prefix(), #out.globals, tostring(out.state.instanceType),
		tostring(out.state.name)))
	return out
end

--- Buttons, in order. `atlas` first because a missing texture file is a black square,
--- while a missing atlas simply draws nothing.
local ACTIONS = {
	{
		--- MH itself, first on the bar.
		---
		--- The whole reason this bar exists is that Rob's minimap icon disappeared into
		--- a button-collector addon — so the addon's own front door went with it. Same
		--- three clicks as that icon (window / board / settings), so whichever of the two
		--- a player uses, the muscle memory is identical.
		id = "mh",
		icon = "Interface\\AddOns\\MidnightHelper\\Media\\Addon_Icon",
		titleKey = "QUICKBAR_MH",
		linesKey = { "QUICKBAR_MH_L", "QUICKBAR_MH_R" },
		OnClick = function(_, button)
			if button == "RightButton" then
				if ns.ShowMainUI then
					ns:ShowMainUI()
				end
				if ns.SelectTab then
					ns.SelectTab("settings")
				end
				return
			end
			if ns.ToggleMainWindow then
				ns:ToggleMainWindow()
			end
		end,
	},
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
		linesKey = { "QUICKBAR_LEAVE_L", "QUICKBAR_LEAVE_R", "QUICKBAR_LEAVE_S" },
		OnClick = function(_, button)
			local home, instance = PartyCategories()
			if IsShiftKeyDown and IsShiftKeyDown() then
				LeaveDelve()
			elseif button == "RightButton" then
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
