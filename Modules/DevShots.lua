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
--
-- 900 tall, not 780: the sidebar has no overflow handling — its tabs stack downwards while
-- the About button is pinned to the bottom — so a short window slides the last group under
-- it. At 780 the "Alts & history" group collided with About in the first clean run.
local SHOT_W, SHOT_H = 1000, 900
local PREVIEW_W = 250 -- the floating 3D preview, which must stay on screen beside it

-- How much of the screen's height the window should fill. Pixels are what a gallery
-- thumbnail is judged on, and they depend on the UI scale, not on the resolution.
local FILL_HEIGHT = 0.78

local STEP_DELAY = 0.9 -- long enough for the async model / tip re-measure ticks

local savedScale -- the user's window scale, restored when the run ends

--------------------------------------------------------------------------------
-- Hiding the rest of the UI
--
-- Cropping to the window does not help when another addon's frames sit ON TOP of it:
-- action bars and quest trackers landed inside the crop. Hiding UIParent removes them,
-- but MH hangs under UIParent and would vanish with it — so reparent MH (and its floating
-- preview) to WorldFrame first, which survives.
--
-- This calls UIParent:Hide() directly, not the Alt+Z binding, which the keybind coach
-- uses. A safety timer puts the UI back even if the run dies halfway: a player left
-- staring at an empty screen would rightly never trust this command again.
--------------------------------------------------------------------------------

local uiHidden = false
local savedParents = {}

--- Reparent while KEEPING the frame's on-screen size. WorldFrame's effective scale is 1,
--- UIParent's is the user's UI scale, so a naive SetParent makes everything jump. Remember
--- the old parent and scale; put both back afterwards.
---
--- The main window is reparented to WorldFrame; the floating 3D preview is reparented to
--- the main window instead. Hung straight off WorldFrame its backdrop and its PlayerModel
--- both refused to draw — you saw the border and the sky through it. As a child of a frame
--- that draws correctly, it draws correctly.
---
--- `matchParent` means "share the parent's scale" rather than "keep your pixel size": the
--- preview must grow with the window it is pinned to, or it shrinks beside a blown-up
--- window. Only the main window itself wants its size preserved.
local function Reparent(frame, newParent, matchParent)
	if not frame or not newParent or frame:GetParent() == newParent or savedParents[frame] then
		return
	end
	local oldEff = frame:GetEffectiveScale()
	savedParents[frame] = { parent = frame:GetParent(), scale = frame:GetScale() }
	frame:SetParent(newParent)
	if not frame.SetScale then
		return
	end
	if matchParent then
		frame:SetScale(1)
		return
	end
	local pe = newParent:GetEffectiveScale()
	if pe and pe > 0 then
		frame:SetScale(oldEff / pe)
	end
end

local function RestoreGameUI()
	if not uiHidden then
		return
	end
	uiHidden = false
	for frame, saved in pairs(savedParents) do
		if frame and saved.parent then
			pcall(frame.SetParent, frame, saved.parent)
			if frame.SetScale and saved.scale then
				pcall(frame.SetScale, frame, saved.scale)
			end
		end
	end
	savedParents = {}
	if not UIParent:IsShown() then
		UIParent:Show()
	end
end

local function HideGameUI(main)
	if uiHidden or not UIParent:IsShown() then
		return
	end
	Reparent(main, WorldFrame)
	UIParent:Hide()
	uiHidden = true
	if C_Timer and C_Timer.After then
		C_Timer.After(90, RestoreGameUI) -- never strand the player without a UI
	end
end

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
	--- Two scenes for the 12.1 / Season 2 work, added 18 aug.
	---
	--- ⚠️ `/mh keys` and `/mh plan` were on the shot list too and are NOT here. Both
	--- print to the chat frame, and this rig hides UIParent — so the chat is not even on
	--- screen when the shutter fires. They cannot be photographed until they have a
	--- window; pretending otherwise would produce two pictures of an empty backdrop.
	{
		name = "08-achievements-coiled-isle",
		tab = "achievements",
		setup = function()
			--- Open on the hunt with the most to show: several steps, and the shared
			--- route button in the header that replaced ten identical ones.
			if ns.DevExpandAchCard then
				ns.DevExpandAchCard("Soft Underbelly")
			end
		end,
	},
	{
		name = "09-delve-coach-ring-of-glory",
		--- No tab: the coach is its own window. `preview` so it opens on a delve the
		--- player is not standing in — the whole point of a gallery picture.
		setup = function()
			if ns.ShowDelveCoach then
				ns:ShowDelveCoach("ring_of_glory", { preview = true })
			end
		end,
		base = function()
			return ns.DevGetDelveCoachFrame and ns.DevGetDelveCoachFrame() or nil
		end,
	},
	--- 🔴 ADDED 2 sep 2026 (Spec 31 B10b), and it was the most expensive omission on the
	--- gallery. MEASURED 31 aug across ~20 delve/profession addons: not one of them tells a
	--- player WHERE to spend Knowledge. CraftSim simulates a craft, Myu's counts points,
	--- Profession Shopping List counts what is left to buy — the advice itself lives only on
	--- Wowhead and Icy Veins and had never been in game. So the one thing this addon does that
	--- nothing else does was the one thing a visitor to the CurseForge page could not see.
	---
	--- `profoverview` rather than `professions`: the legacy id lands on Treasures & Books,
	--- which is what Rob got on 22 July when he clicked a Knowledge line and received a
	--- treasure list. Overview is where the advice line lives.
	---
	--- ⚠️ THIS SCENE DEPENDS ON THE LOGGED-IN CHARACTER, which none of the others do. Run it
	--- on someone with Midnight professions and points to spend, or it photographs an honest
	--- empty page. Rob's Tailoring/Enchanting characters are the ones to use.
	{ name = "10-professions-advice", tab = "profoverview" },
}

local function Say(msg)
	print("|cffffcc00Midnight Helper shots:|r " .. msg)
end

--- Screen pixels per scale-1 UI unit.
---
--- `frame:GetLeft() * frame:GetEffectiveScale()` does NOT give pixels — it gives units in
--- WoW's scale-1 UI space, which is always 768 tall no matter the resolution. On a 1440p
--- screen one such unit is 1440/768 = 1.875 pixels. Missing this factor is why the window
--- was sized to 1944 real pixels on a 1440-pixel screen and hung off the bottom, while
--- every number in the log looked perfectly consistent with itself.
local function PixelsPerUnit()
	local _, ph = GetPhysicalScreenSize()
	local uiH = UIParent:GetHeight() * UIParent:GetEffectiveScale() -- ~768, always
	if ph and uiH and uiH > 0 then
		return ph / uiH
	end
	return 1
end

--- Screen-pixel rectangle (top-left origin) covering `frame`, unioned with `extra`,
--- grown by `pad`. WoW frame coords are bottom-left origin and scale-relative, so we
--- multiply by the frame's effective scale and flip against the physical height.
local function PixelRect(frame, extra, pad)
	if not frame then
		return nil
	end
	local _, physH = GetPhysicalScreenSize()
	local ppu = PixelsPerUnit()
	local s = frame:GetEffectiveScale() * ppu
	local left, right = frame:GetLeft() * s, frame:GetRight() * s
	local top, bottom = frame:GetTop() * s, frame:GetBottom() * s

	if extra and extra:IsShown() then
		local es = extra:GetEffectiveScale() * ppu
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
	-- Nothing is clamped here. Clamping `b` to zero once hid the fact that the window
	-- hung 269 pixels off the bottom of the screen: the number looked plausible and the
	-- crops were quietly wrong. A negative value is information, not an error.
	local x = math.floor(left + 0.5)
	local w = math.floor(right - left + 0.5)
	local h = math.floor(top - bottom + 0.5)
	local b = math.floor(bottom + 0.5)
	local y = math.floor(physH - top + 0.5) -- for eyeballing in the chat log
	return { x = x, y = y, w = w, h = h, b = b }
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
	-- Against the ACTUAL parent: once the UI is hidden the window hangs off WorldFrame,
	-- whose effective scale is 1, not the user's UI scale.
	local parent = main:GetParent() or UIParent
	local parentEff = parent:GetEffectiveScale()
	if not (pw and ph and parentEff and parentEff > 0) then
		return nil
	end
	local ppu = PixelsPerUnit()
	local byHeight = (ph * FILL_HEIGHT) / (SHOT_H * ppu)
	local byWidth = (pw * 0.9) / ((SHOT_W + PREVIEW_W) * ppu)
	local own = math.min(byHeight, byWidth) / parentEff
	return math.max(0.3, math.min(own, 3))
end

--- Centre the window by computing its pixel position, not by trusting a CENTER anchor.
--- On the first ultrawide run a CENTER-to-CENTER anchor left the window at x=701 with its
--- bottom 269 pixels BELOW the screen, so a third of it was never captured. Anchoring
--- from BOTTOMLEFT with measured offsets leaves nothing to interpretation.
local function CenterWindow(main)
	local pw, ph = GetPhysicalScreenSize()
	local s = main:GetEffectiveScale() * PixelsPerUnit() -- pixels per frame unit
	if not (pw and ph and s and s > 0) then
		return
	end
	local wpx, hpx = main:GetWidth() * s, main:GetHeight() * s
	local leftPx = math.max((pw - wpx) / 2, 0)
	local bottomPx = math.max((ph - hpx) / 2, 0)
	-- UIParent's bottom-left is the screen's bottom-left (its GetLeft/GetBottom are 0),
	-- and SetPoint offsets are expressed in the moved frame's own units.
	main:ClearAllPoints()
	main:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", leftPx / s, bottomPx / s)
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
	CenterWindow(main)
end

local function RestoreWindow(main, savedFormat)
	if savedFormat and SetCVar then
		pcall(SetCVar, "screenshotFormat", savedFormat)
	end
	RestoreGameUI() -- parents and scales first...
	if savedScale and main and main.SetScale then
		main:SetScale(savedScale) -- ...then the window scale the user actually had
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
	--- The coach was opened in preview mode for its own scene; leaving it on screen would
	--- have the operator close a window they never opened.
	if ns.HideDelveCoach then
		pcall(ns.HideDelveCoach, ns, true)
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
	Say(("screen %dx%d, ui scale %.3f, %.3f px per unit — %d shots, stand still (~%ds).")
		:format(pw, ph, UIParent:GetEffectiveScale(), PixelsPerUnit(),
			#SHOTS, math.ceil(#SHOTS * (STEP_DELAY * 2 + 0.35))))
	Say("hiding the rest of the UI — it comes back when the run ends (or after 90s, whatever happens).")

	-- Everything below runs with UIParent hidden, so these prints only become visible
	-- again afterwards. That is fine: they are a record, not a progress bar.
	HideGameUI(main)

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
		--
		-- ⚠️ `tab` is OPTIONAL since 18 aug. Not everything worth showing lives in the
		-- main window: the Delve Coach is its own window, and calling SelectTab(nil) for
		-- it would fail the scene for a tab it never wanted.
		if shot.tab then
			local ok, err = pcall(ns.SelectTab, shot.tab)
			if not ok then
				Say(("|cffff6060skipped|r %s — tab '%s': %s"):format(shot.name, tostring(shot.tab), tostring(err)))
				C_Timer.After(0.1, takeNext)
				return
			end
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

			--- A scene may name a DIFFERENT window as the subject. It is then centred and
			--- cropped in the main window's place, and the main window is pushed out of
			--- the picture rather than hidden: hiding it makes the tab machinery re-run on
			--- the next scene and the run loses its footing. Off-screen is enough — the
			--- crop is a rectangle, not a screenshot of everything.
			local subject = main
			if shot.base then
				local bok, bframe = pcall(shot.base)
				if bok and bframe then
					subject = bframe
					if uiHidden then
						Reparent(subject, WorldFrame)
					end
					main:ClearAllPoints()
					main:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -5000, 0)
				else
					Say(("|cffff6060no window|r %s — skipped"):format(shot.name))
					C_Timer.After(0.1, takeNext)
					return
				end
			end

			-- Let the resize re-layout and the model's async re-apply tick land.
			C_Timer.After(0.35, function()
				local extra = shot.frames and select(2, pcall(shot.frames)) or nil
				if uiHidden and extra then
					-- The floating preview would vanish with UIParent. Hang it under the
					-- main window (which draws fine on WorldFrame) and run the scene's
					-- setup a second time: a PlayerModel loads nothing while it is
					-- invisible, so the first pass left an empty bordered box.
					Reparent(extra, main, true)
					if shot.setup then
						pcall(shot.setup)
					end
				end
				-- One more tick when a model had to reload after becoming visible.
				C_Timer.After(extra and 0.5 or 0, function()
					CenterWindow(subject) -- right before the shutter: nothing may drift
					local rok, rect = pcall(PixelRect, subject, extra, shot.pad)
					if rok and rect then
						rect.name = shot.name
						-- WoW names its screenshots WoWScrnShot_MMDDYY_HHMMSS, so stamp the
						-- shot at the moment of the shutter and let the crop script match by
						-- name. Picking "the N newest files" instead breaks the moment a stray
						-- manual screenshot lands in the folder — which is what happened.
						rect.t = date("%m%d%y_%H%M%S")
						ns.db.devShotRects[#ns.db.devShotRects + 1] = rect
						Screenshot()
						taken = taken + 1

						-- Say it out loud when the window is not entirely on screen: a crop of
						-- a half-visible window looks plausible and is silently wrong.
						local pw2, ph2 = GetPhysicalScreenSize()
						local offscreen = rect.b < 0 or rect.x < 0 or (rect.x + rect.w) > pw2 or (rect.b + rect.h) > ph2
						Say(("%d/%d  %s  (%dx%d at x=%d, %dpx above the bottom)%s")
							:format(i, #SHOTS, shot.name, rect.w, rect.h, rect.x, rect.b,
								offscreen and "  |cffff6060OFF SCREEN|r" or ""))
					else
						Say(("|cffff6060no rect|r %s"):format(shot.name))
					end
					C_Timer.After(STEP_DELAY, takeNext)
				end)
			end)
		end)
	end
	takeNext()
end
