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

-- The window's own SetResizeBounds caps it at 1000x920 UI units, so asking for more is
-- pointless: a bigger *picture* comes from scaling the frame, not from sizing it.
local SHOT_W, SHOT_H = 1000, 780
local PREVIEW_W = 250 -- the floating 3D preview, which must stay on screen beside it

-- How much of the screen's height the window should fill. Pixels are what a gallery
-- thumbnail is judged on, and they depend on the UI scale, not on the resolution.
local FILL_HEIGHT = 0.72

local STEP_DELAY = 0.9 -- long enough for the async model / tip re-measure ticks

local savedScale -- the user's window scale, restored when the run ends

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

	-- `b` is the distance from the screen BOTTOM, which is what the game actually knows.
	-- The crop script turns it into a top-left y using the real image height, so a
	-- GetPhysicalScreenSize() that disagrees with the rendered resolution (a remote
	-- desktop, a non-native window mode) cannot silently shift every crop downwards.
	local x = math.floor(left + 0.5)
	local w = math.floor(right - left + 0.5)
	local h = math.floor(top - bottom + 0.5)
	local b = math.floor(bottom + 0.5)
	local y = math.floor(physH - top + 0.5) -- kept for eyeballing in the chat log
	return { x = math.max(x, 0), y = math.max(y, 0), w = w, h = h, b = math.max(b, 0) }
end

--- Scale the frame so the window fills FILL_HEIGHT of the screen — without letting it,
--- or the preview beside it, run off the edge. On a low UI scale the window is only a
--- few hundred pixels tall, which would make the gallery images smaller than hand-made
--- ones. Scaling the frame (not the game's UI scale) leaves everything else alone.
local function ShotScale(main)
	if not main.SetScale then
		return nil
	end
	local pw, ph = GetPhysicalScreenSize()
	local uiEff = UIParent:GetEffectiveScale()
	if not (pw and ph and uiEff and uiEff > 0) then
		return nil
	end
	local byHeight = (ph * FILL_HEIGHT) / SHOT_H
	local byWidth = (pw * 0.9) / (SHOT_W + PREVIEW_W)
	local own = math.min(byHeight, byWidth) / uiEff
	return math.max(0.5, math.min(own, 3))
end

--- Park the window at the shot size, scale and position. This must run AFTER SelectTab:
--- selecting a tab restores the user's saved size and position, which silently undid an
--- earlier call — every shot of the first run came out at the user's own window size.
local function ParkWindow(main)
	if savedScale and main.SetScale then
		local s = ShotScale(main)
		if s then
			main:SetScale(s)
		end
	end
	ns._mhProgrammaticResize = true
	main:SetSize(SHOT_W, SHOT_H)
	ns._mhProgrammaticResize = false
	main:ClearAllPoints()
	main:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

local function RestoreWindow(main, savedFormat)
	if savedFormat and SetCVar then
		pcall(SetCVar, "screenshotFormat", savedFormat)
	end
	if savedScale and main and main.SetScale then
		main:SetScale(savedScale)
		savedScale = nil
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

	ns.db = ns.db or {}
	ns.db.devShotRects = {}

	savedScale = (main.GetScale and main:GetScale()) or 1

	local pw, ph = GetPhysicalScreenSize()
	Say(("screen %dx%d, ui scale %.3f, window scale %.2f -> %.2f — %d shots, stand still (~%ds).")
		:format(pw, ph, UIParent:GetEffectiveScale(), savedScale, ShotScale(main) or savedScale,
			#SHOTS, math.ceil(#SHOTS * (STEP_DELAY * 2 + 0.35))))

	local i, taken = 0, 0
	local takeNext -- forward-declared: `next` is a Lua global, never shadow it
	takeNext = function()
		i = i + 1
		local shot = SHOTS[i]
		if not shot then
			RestoreWindow(main, savedFormat)
			Say(("done — %d/%d shots. /reload, then run tools\\Crop-Shots.bat."):format(taken, #SHOTS))
			return
		end

		-- Every step is guarded: one bad scene must never take the rest of the run with
		-- it (a hidden tab did exactly that on the first outing).
		local ok, err = pcall(ns.SelectTab, shot.tab)
		if not ok then
			Say(("|cffff6060skipped|r %s — tab '%s': %s"):format(shot.name, tostring(shot.tab), tostring(err)))
			C_Timer.After(0.1, takeNext)
			return
		end

		C_Timer.After(STEP_DELAY, function()
			-- AFTER the tab settles: SelectTab restores the user's saved size/position.
			ParkWindow(main)
			if shot.setup then
				local sok, serr = pcall(shot.setup)
				if not sok then
					Say(("|cffff6060setup failed|r %s: %s"):format(shot.name, tostring(serr)))
				end
			end

			-- Let the resize re-layout and the model's async re-apply tick land.
			C_Timer.After(0.35, function()
				local extra = shot.frames and select(2, pcall(shot.frames)) or nil
				local rok, rect = pcall(PixelRect, main, extra, shot.pad)
				if rok and rect then
					rect.name = shot.name
					ns.db.devShotRects[#ns.db.devShotRects + 1] = rect
					Screenshot()
					taken = taken + 1
					Say(("%d/%d  %s  (%dx%d at %d,%d)"):format(i, #SHOTS, shot.name, rect.w, rect.h, rect.x, rect.y))
				else
					Say(("|cffff6060no rect|r %s"):format(shot.name))
				end
				C_Timer.After(STEP_DELAY, takeNext)
			end)
		end)
	end
	takeNext()
end
