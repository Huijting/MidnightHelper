--[[
	Midnight Helper — shared small-dialog chrome (gold frame, like Delve items popup).
]]

local _, ns = ...

local CONTENT_INSET = { L = 16, R = 16, T = 32, B = 16 }

function ns.ApplyMidnightDialogBackdrop(frame)
	if not frame or not frame.SetBackdrop then
		return
	end
	frame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	frame:SetBackdropColor(0.06, 0.06, 0.1, 0.94)
end

local MIN_SCALE, MAX_SCALE, SCALE_STEP = 0.7, 1.6, 0.1

--- Shift+scroll to resize, on every dialog rather than one of them.
---
--- The boss window has had this since Rob asked for it, and he has now asked again
--- looking at the setup panel: "dat moet eigenlijk gewoon voor al onze schermen". He is
--- right, and the reason it was not is that it was built into that one window instead of
--- into the thing every window already calls.
---
--- ⚠️ Only with Shift held. Plain scroll belongs to whatever is under the cursor — a
--- scroll frame, a list — and stealing it would break those.
---
--- ⚠️ Hook rather than replace. Some of these dialogs already handle the wheel; setting
--- our own script would silently kill theirs, which is the class of bug this project
--- keeps finding rather than causing.
---
--- Scale is remembered per frame name, so the panel someone made bigger stays bigger.
local function AttachScaling(frame, name)
	if frame._mhScalable then
		return
	end
	frame._mhScalable = true

	local function Saved()
		if not ns.db then
			return nil
		end
		ns.db.ui = ns.db.ui or {}
		ns.db.ui.dialogScale = ns.db.ui.dialogScale or {}
		return ns.db.ui.dialogScale
	end

	local store = Saved()
	local remembered = store and tonumber(store[name])
	if remembered then
		pcall(frame.SetScale, frame, remembered)
	end

	local function OnWheel(self, delta)
		if not (IsShiftKeyDown and IsShiftKeyDown()) then
			return
		end
		-- The travel popup parents the secure Hearthstone button: rescaling it in combat is a blocked action, and a
		-- pcall does not stop Blizzard from reporting that. Out of combat only, for every window alike.
		if InCombatLockdown and InCombatLockdown() then
			return
		end
		local cur = (self.GetScale and self:GetScale()) or 1
		local next_ = cur + (delta > 0 and SCALE_STEP or -SCALE_STEP)
		if next_ < MIN_SCALE then
			next_ = MIN_SCALE
		elseif next_ > MAX_SCALE then
			next_ = MAX_SCALE
		end
		if math.abs(next_ - cur) < 0.001 then
			return
		end
		pcall(self.SetScale, self, next_)
		local s = Saved()
		if s then
			s[name] = next_
		end
	end

	frame:EnableMouseWheel(true)
	if frame:GetScript("OnMouseWheel") then
		frame:HookScript("OnMouseWheel", OnWheel)
	else
		frame:SetScript("OnMouseWheel", OnWheel)
	end

	--- 🔴 Rob, 7 Oct 2026, on the shopping list: "ik kan deze niet met shift en scroll groter maken". The wheel goes to
	--- the TOPMOST frame under the cursor that takes it — a scroll list inside the window — so the window's own
	--- handler never ran over its content. Wrap those children: Shift = resize the window, otherwise their own scroll.
	--- Children made later (rows, a list built on first show) are picked up again on every show.
	local function WrapChildren(parent, depth)
		if depth > 6 or not parent.GetChildren then
			return
		end
		for _, child in ipairs({ parent:GetChildren() }) do
			if not child._mhScaleWrapped and child.IsMouseWheelEnabled and child:IsMouseWheelEnabled()
				and not (child.IsProtected and child:IsProtected()) then
				child._mhScaleWrapped = true
				local orig = child:GetScript("OnMouseWheel")
				child:SetScript("OnMouseWheel", function(c, delta, ...)
					if IsShiftKeyDown and IsShiftKeyDown() then
						OnWheel(frame, delta)
						return
					end
					if orig then
						return orig(c, delta, ...)
					end
				end)
			end
			WrapChildren(child, depth + 1)
		end
	end
	WrapChildren(frame, 1)
	frame:HookScript("OnShow", function(self)
		WrapChildren(self, 1)
	end)
end

--- Shift+scroll for a window that does not go through RegisterMidnightDialogPopup (no dock button, no Escape).
ns.MakeMidnightWindowScalable = AttachScaling

--- 🔴 "IK WIL DAT GEWOON ALLE SCHERMEN DIT MOETEN KUNNEN" — Rob, 7 Oct 2026, after the second time. Only the windows
--- that call RegisterMidnightDialogPopup had it (17 of them); the shopping lists, the course, the changelog and the
--- travel popup did not. Most windows are built lazily on first open, so a single pass at login finds almost none:
--- a light sweep picks each one up the moment it exists. Name lookups only, every 2 seconds.
--- ⚠️ NOT in this list, on purpose: windows with their OWN Shift+scroll (main window, boss window, delve coach,
--- consumable board, party targets, toasts, missing-buff/openables icons), alerts and bars that do not take the mouse,
--- secure bars, dropdown menus, and the tooltip-strata hover previews (mounts, rares, trading post).
local SCALABLE_WINDOWS = {
	"MidnightHelperBriefNotice", "MidnightHelperBarPlanCard", "MidnightHelperAltBoardCard",
	"MidnightHelperAltBoardWindow", "MidnightHelperChangelogFrame", "MidnightHelperCurioAdvicePanel",
	"MidnightHelperCraftShoppingList", "MidnightHelperRaidShoppingList", "MidnightHelperDelveCoachPicker",
	"MidnightHelperDelveCuriosPopup", "MidnightHelperDelveShareCopy", "MidnightHelperDelveItemsPopup",
	"MH_TravelPopup", "MidnightHelperDiscordCopyBox", "MidnightHelperFpsPanel", "MidnightHelperEditModeBox",
	"MidnightHelperRezLust", "MidnightHelperKeyBlock", "MidnightHelperModelPreview", "MidnightHelperMidnightAchList",
	"MidnightHelperLayoutWizard", "MidnightHelperGrowthPrompt", "MidnightHelperProfGuideUrlCopy",
	"MidnightHelperProfGuide", "MidnightHelperCourseWindow", "MidnightHelperPawnCopyBox",
	"MidnightHelperVaultReminderPopup", "MidnightHelperVaultAdvisorBanner", "MidnightHelperValeeraPopup",
	"MidnightHelperMapProbe",
}

local function SweepScalableWindows()
	for _, name in ipairs(SCALABLE_WINDOWS) do
		local f = _G[name]
		if f and not f._mhScalable and f.EnableMouseWheel then
			AttachScaling(f, name)
		end
	end
end

if C_Timer and C_Timer.NewTicker then
	C_Timer.NewTicker(2, function()
		-- Attaching restores a remembered scale, and the travel popup is protected in combat.
		if ns.db and not (InCombatLockdown and InCombatLockdown()) then
			SweepScalableWindows()
		end
	end)
end

--------------------------------------------------------------------------------
-- Docking: stick a dialog to the right edge of the main window
--------------------------------------------------------------------------------

--- Rob, 27 aug 2026: he searched MH for "stats", found the entry, and expected the
--- window to appear stuck to the right of the main frame instead of floating in the
--- middle. Offered three options and he picked the widest: every dialog can dock, with
--- a button to let go again.
---
--- ⚠️ DOCKED MEANS ATTACHED, INCLUDING WHEN THE MAIN WINDOW GOES AWAY. A dialog left
--- hanging in empty space after its anchor closed is worse than one that closes with
--- it. Reopening the main window does NOT bring it back — that would be a window
--- appearing unbidden, which this addon spent 27 aug removing from two other features.
---
--- ⚠️ NOT IN COMBAT. Some of these dialogs sit near action-bar work (BarPlanCard,
--- LayoutWizard), and re-anchoring a frame that parents a secure button is blocked in
--- combat. The move is deferred rather than attempted and lost.
local DOCK_GAP = 6
local docked = {}          -- frame -> saved key, for the ones currently attached
local pendingDock = {}     -- frame -> true, a move that combat postponed

local function MainWindow()
    local f = _G.MidnightHelperMainUI
    return (f and f.GetName) and f or nil
end

local function DockStore()
    if not ns.db then
        return nil
    end
    ns.db.ui = ns.db.ui or {}
    ns.db.ui.dialogDock = ns.db.ui.dialogDock or {}
    return ns.db.ui.dialogDock
end

local function ApplyDock(frame)
    local main = MainWindow()
    if not (frame and main) then
        return false
    end
    if InCombatLockdown and InCombatLockdown() then
        pendingDock[frame] = true
        return false
    end
    pendingDock[frame] = nil
    -- Scale differs per dialog, so the offset has to be expressed in the dialog's own
    -- units or a scaled-up window lands short of the edge it is supposed to touch.
    local s = (frame.GetScale and frame:GetScale()) or 1
    if s <= 0 then
        s = 1
    end
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", main, "TOPRIGHT", DOCK_GAP / s, 0)
    return true
end

--- Follow the main window, and leave with it.
local function EnsureDockWatcher()
    if ns._mhDockWatcher then
        return
    end
    local main = MainWindow()
    if not main then
        return
    end
    ns._mhDockWatcher = true

    main:HookScript("OnHide", function()
        for frame in pairs(docked) do
            if frame.IsShown and frame:IsShown() then
                frame:Hide()
            end
        end
    end)

    -- The main window is movable, and SetPoint alone does not follow a drag on some
    -- frames once they have been re-anchored, so re-apply when it stops moving.
    if main.HookScript and main:GetScript("OnDragStop") then
        main:HookScript("OnDragStop", function()
            for frame in pairs(docked) do
                ApplyDock(frame)
            end
        end)
    end

    local combat = CreateFrame("Frame")
    combat:RegisterEvent("PLAYER_REGEN_ENABLED")
    combat:SetScript("OnEvent", function()
        for frame in pairs(pendingDock) do
            ApplyDock(frame)
        end
    end)
end

--- @return boolean docked
function ns.IsMidnightDialogDocked(frame)
    return docked[frame] and true or false
end

--- Attach or release. Returns the new state.
function ns.SetMidnightDialogDocked(frame, want, name)
    if not frame then
        return false
    end
    name = name or (frame.GetName and frame:GetName())
    local store = DockStore()
    if want then
        if not MainWindow() then
            -- No anchor, no dock. Saying so beats a button that does nothing.
            return false
        end
        EnsureDockWatcher()
        docked[frame] = name or true
        if name and store then
            store[name] = true
        end
        ApplyDock(frame)
    else
        docked[frame] = nil
        pendingDock[frame] = nil
        if name and store then
            store[name] = nil
        end
        -- Released where it stands, not teleported home: the player just looked at it
        -- there.
        if not (InCombatLockdown and InCombatLockdown()) then
            local p, _rel, rp, x, y = frame:GetPoint(1)
            if p then
                frame:ClearAllPoints()
                frame:SetPoint(p, UIParent, rp or p, x or 0, y or 0)
            end
        end
    end
    if frame._mhDockBtn then
        frame._mhDockBtn:SetText(ns:L(want and "DIALOG_UNDOCK" or "DIALOG_DOCK"))
    end
    return want and true or false
end

--- A small text button, top-right of the dialog, next to the close button.
local function AttachDockButton(frame, name)
    if frame._mhDockBtn or not frame.CreateFontString then
        return
    end
    local b = CreateFrame("Button", nil, frame)
    b:SetSize(88, 16)
    b:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, -10)
    b:SetNormalFontObject("GameFontNormalSmall")
    b:SetHighlightFontObject("GameFontHighlightSmall")
    b:SetText(ns:L("DIALOG_DOCK"))
    b:SetScript("OnClick", function()
        ns.SetMidnightDialogDocked(frame, not ns.IsMidnightDialogDocked(frame), name)
    end)
    frame._mhDockBtn = b

    -- 🔴 DRAGGING A DOCKED WINDOW LETS GO OF IT. Without this the frame moves under the
    -- cursor while still counting as docked, and snaps back the next time the main
    -- window moves — the player would have to undo something they never knowingly did.
    -- Pulling a window off its anchor IS the gesture for undocking.
    if frame.GetScript and frame:GetScript("OnDragStart") then
        frame:HookScript("OnDragStart", function(self)
            if docked[self] then
                ns.SetMidnightDialogDocked(self, false, name)
            end
        end)
    end

    -- Restore what this window was last set to.
    local store = DockStore()
    if name and store and store[name] then
        ns.SetMidnightDialogDocked(frame, true, name)
    end
end

function ns.RegisterMidnightDialogPopup(frame)
	if not frame then
		return
	end
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	local name = frame.GetName and frame:GetName()
	-- Scaling needs a name to remember it by; an anonymous dialog simply does not get it.
	if name then
		AttachScaling(frame, name)
		AttachDockButton(frame, name)
	end
	if not name or type(UISpecialFrames) ~= "table" then
		return
	end
	for i = 1, #UISpecialFrames do
		if UISpecialFrames[i] == name then
			return
		end
	end
	UISpecialFrames[#UISpecialFrames + 1] = name
end

--- Center of screen, slightly above the character (same idea as Delve items popup).
function ns.PositionMidnightPopupAboveCharacter(frame, offsetY)
	if not frame then
		return
	end
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, tonumber(offsetY) or 120)
end

function ns.EnsureMidnightDialogTitleBar(frame)
	if frame._mhTitleBar and frame._mhContent then
		return frame._mhTitleBar, frame._mhContent
	end
	local content = CreateFrame("Frame", nil, frame)
	content:SetPoint("TOPLEFT", frame, "TOPLEFT", CONTENT_INSET.L, -CONTENT_INSET.T)
	content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -CONTENT_INSET.R, CONTENT_INSET.B)
	frame._mhContent = content

	local titleBar = CreateFrame("Frame", nil, content)
	titleBar:SetHeight(22)
	titleBar:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
	titleBar:SetPoint("TOPRIGHT", content, "TOPRIGHT", -28, 0)
	titleBar:EnableMouse(true)
	titleBar:RegisterForDrag("LeftButton")
	titleBar:SetScript("OnDragStart", function()
		frame:StartMoving()
	end)
	titleBar:SetScript("OnDragStop", function()
		frame:StopMovingOrSizing()
	end)
	frame._mhTitleBar = titleBar
	return titleBar, content
end

function ns.AttachMidnightDialogCloseButton(frame, onClose)
	local close = frame._mhCloseBtn
	if not close then
		close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
		frame._mhCloseBtn = close
	end
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)
	close:SetFrameLevel((frame:GetFrameLevel() or 100) + 50)
	close:EnableMouse(true)
	close:RegisterForClicks("AnyUp")
	close:SetScript("OnClick", function()
		if onClose then
			onClose()
		end
		frame:Hide()
	end)
	return close
end

function ns.StyleMidnightEditBoxHost(editBox, parent)
	if not editBox or not parent then
		return nil
	end
	local bg = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	bg:SetPoint("TOPLEFT", editBox, "TOPLEFT", -8, 6)
	bg:SetPoint("BOTTOMRIGHT", editBox, "BOTTOMRIGHT", 8, -6)
	if bg.SetBackdrop then
		bg:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 8,
			edgeSize = 10,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		})
		bg:SetBackdropColor(0.05, 0.05, 0.08, 0.92)
		bg:SetBackdropBorderColor(0.55, 0.45, 0.28, 0.9)
	end
	editBox:SetFrameLevel(bg:GetFrameLevel() + 2)
	return bg
end
