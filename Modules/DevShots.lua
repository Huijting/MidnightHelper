--[[
	Screenshot rig — `/mh shots`. Undocumented on purpose: it exists so the CurseForge
	gallery can be re-shot in twenty seconds instead of being hand-assembled every
	release, which is where the inconsistency came from.

	What it does: parks the main window at a fixed size and position, walks a list of
	scenes (open this tab, pop that preview), and calls Screenshot() between each. It
	also records the exact pixel rectangle to crop for every shot into SavedVariables,
	so tools/Crop-Shots.ps1 can cut them all identically afterwards.

	What it cannot do, and why the operator still matters:
	  - It cannot hide the world behind the window. Stand somewhere dark and flat
	    ONCE; all seven scenes are shot from that spot.
	  - It cannot move the OS mouse cursor, so a real hover is impossible. Where a
	    hover is the point (the mount preview) it calls the hover handler directly.

	Screenshot() is an ordinary, unprotected API (since 1.0.0). The rig switches the
	screenshotFormat CVar to png for the run and restores whatever you had.

	Ships with the addon but is inert until invoked: no events, no frames, no hooks.
]]

local _, ns = ...

-- A wide, comfortably readable window. Text legibility beats information density in a
-- gallery thumbnail; the window clamps this itself if the display is smaller.
local SHOT_W, SHOT_H = 1120, 780
local STEP_DELAY = 0.9 -- long enough for the async model / tip re-measure ticks

--- Scenes, in gallery order. `pad` grows the crop rectangle for things that render
--- outside the main window (the floating 3D preview, the search result list).
local SHOTS = {
	{ name = "01-this-week", tab = "home" },
	{
		name = "02-mounts-preview",
		tab = "mounts",
		setup = function()
			if ns.DevHoverFirstMountRow then
				ns.DevHoverFirstMountRow()
			end
		end,
		frames = function()
			return ns.DevGetMountPreviewFrame and ns.DevGetMountPreviewFrame() or nil
		end,
	},
	{ name = "03-raids", tab = "raids" },
	{
		name = "04-search-boss",
		tab = "home",
		setup = function()
			if ns.DevShowNavResults then
				ns.DevShowNavResults("Chimaerus")
			end
		end,
	},
	{ name = "05-class-coach", tab = "guide" },
	{ name = "06-alts", tab = "account" },
	{ name = "07-void-rituals", tab = "world" },
}

local function Say(msg)
	print("|cffffcc00Midnight Helper shots:|r " .. msg)
end

--- Screen-pixel rectangle (top-left origin) covering `frame`, unioned with `extra`,
--- grown by `pad`. WoW frame coords are bottom-left origin and scale-relative, so we
--- multiply by the frame's effective scale and flip against the physical height.
local function PixelRect(frame, extra, pad)
	if not frame then
		return nil
	end
	local _, physH = GetPhysicalScreenSize()
	local s = frame:GetEffectiveScale()
	local left, right = frame:GetLeft() * s, frame:GetRight() * s
	local top, bottom = frame:GetTop() * s, frame:GetBottom() * s

	if extra and extra:IsShown() then
		local es = extra:GetEffectiveScale()
		left = math.min(left, extra:GetLeft() * es)
		right = math.max(right, extra:GetRight() * es)
		top = math.max(top, extra:GetTop() * es)
		bottom = math.min(bottom, extra:GetBottom() * es)
	end

	pad = pad or {}
	left = left - (pad.left or 0)
	right = right + (pad.right or 0)
	top = top + (pad.top or 0)
	bottom = bottom - (pad.bottom or 0)

	local x = math.floor(left + 0.5)
	local y = math.floor(physH - top + 0.5) -- flip to a top-left origin
	local w = math.floor(right - left + 0.5)
	local h = math.floor(top - bottom + 0.5)
	return { x = math.max(x, 0), y = math.max(y, 0), w = w, h = h }
end

local function RestoreWindow(savedFormat)
	if savedFormat and SetCVar then
		pcall(SetCVar, "screenshotFormat", savedFormat)
	end
	if ns.ApplySavedMainWindowSize then
		pcall(ns.ApplySavedMainWindowSize, ns)
	end
	if ns.ApplySavedMainWindowPosition then
		pcall(ns.ApplySavedMainWindowPosition, ns)
	end
	if ns.DevGetMountPreviewFrame then
		local f = ns.DevGetMountPreviewFrame()
		if f then
			f:Hide()
		end
	end
end

function ns.RunDevShots()
	if InCombatLockdown and InCombatLockdown() then
		Say("not in combat, please.")
		return
	end
	local main = ns.mainUI
	if not main or not ns.SelectTab then
		Say("open the window once first (Alt+M), then run this again.")
		return
	end

	local savedFormat = GetCVar and GetCVar("screenshotFormat") or nil
	if SetCVar then
		pcall(SetCVar, "screenshotFormat", "png")
	end

	if ns.ShowMainUI then
		ns:ShowMainUI()
	end

	-- Park the window: fixed size, centred. The programmatic-resize guard keeps this
	-- from being remembered as a size the user chose.
	ns._mhProgrammaticResize = true
	main:SetSize(SHOT_W, SHOT_H)
	ns._mhProgrammaticResize = false
	main:ClearAllPoints()
	main:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

	ns.db = ns.db or {}
	ns.db.devShotRects = {}

	Say(("taking %d shots — stand still, this takes about %d seconds.")
		:format(#SHOTS, math.ceil(#SHOTS * STEP_DELAY * 2)))

	local i = 0
	local takeNext -- forward-declared: `next` is a Lua global, never shadow it
	takeNext = function()
		i = i + 1
		local shot = SHOTS[i]
		if not shot then
			RestoreWindow(savedFormat)
			Say("done. /reload, then run tools\\Crop-Shots.ps1 (it reads the crop rects from SavedVariables).")
			return
		end

		ns.SelectTab(shot.tab)
		if shot.setup then
			pcall(shot.setup)
		end

		-- Grace for the tab to lay out (and for the model's async re-apply tick), then
		-- shoot and record the rectangle that frame actually occupies.
		C_Timer.After(STEP_DELAY, function()
			local extra = shot.frames and shot.frames() or nil
			local rect = PixelRect(main, extra, shot.pad)
			if rect then
				rect.name = shot.name
				ns.db.devShotRects[#ns.db.devShotRects + 1] = rect
			end
			Screenshot()
			Say(("%d/%d  %s"):format(i, #SHOTS, shot.name))
			C_Timer.After(STEP_DELAY, takeNext)
		end)
	end
	takeNext()
end
