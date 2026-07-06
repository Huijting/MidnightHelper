--[[
	Midnight Helper — interactive UI tour (coach-marks). The "wow" upgrade of the
	Start Here "How it works" walkthrough: a guided overlay that highlights real UI
	frames one step at a time with a gold box and a callout bubble (title/body +
	Back / Next / Skip + step counter).

	Robust by design: highlight + bubble anchor RELATIVE to the live target frame
	(no manual coordinate maths, so it survives any UI scale), and a step whose
	target frame isn't available is skipped, so the tour never points at nothing.
	The main UI is shown first so every frame has a position.
]]

local _, ns = ...

-- Steps. frameFn resolves the live target frame (nil/hidden = skipped). anchor =
-- where the callout sits vs the target: "BELOW" (default) / "ABOVE" / "RIGHT".
local STEPS = {
	{
		frameFn = function() return ns._mhLayoutRefs and ns._mhLayoutRefs.sidebar end,
		titleKey = "TOUR_CM_ROOMS_TITLE", bodyKey = "TOUR_CM_ROOMS_BODY", anchor = "RIGHT",
	},
	{
		frameFn = function() return ns.mhSearchBar end,
		titleKey = "TOUR_CM_SEARCH_TITLE", bodyKey = "TOUR_CM_SEARCH_BODY", anchor = "BELOW",
	},
	{
		frameFn = function() return ns.mhFavRow end,
		titleKey = "TOUR_CM_FAV_TITLE", bodyKey = "TOUR_CM_FAV_BODY", anchor = "BELOW",
	},
	{
		frameFn = function() return _G.MidnightHelperInfoToggleBtn end,
		titleKey = "TOUR_CM_INFO_TITLE", bodyKey = "TOUR_CM_INFO_BODY", anchor = "BELOW",
	},
	{
		frameFn = function() return ns._mhLayoutRefs and ns._mhLayoutRefs.content end,
		titleKey = "TOUR_CM_CONTENT_TITLE", bodyKey = "TOUR_CM_CONTENT_BODY", anchor = "ABOVE",
	},
}

local overlay
local active = {} -- the steps that actually have a target this run
local idx = 0

local function EnsureOverlay()
	if overlay then
		return overlay
	end
	local o = CreateFrame("Frame", "MidnightHelperTourOverlay", UIParent)
	o:SetFrameStrata("FULLSCREEN_DIALOG")
	o:SetAllPoints(UIParent)
	o:EnableMouse(true) -- swallow background clicks during the guided tour
	o:Hide()

	-- ESC ends the tour instead of closing the main window underneath it (F4.2).
	-- The overlay captures keyboard while shown; ESCAPE is consumed (not propagated)
	-- so the game menu / main window don't also react, other keys pass through so
	-- movement still works. On hide (ESC, Skip, or EndUITour) the step index resets.
	o:EnableKeyboard(true)
	o:SetPropagateKeyboardInput(true)
	o:SetScript("OnKeyDown", function(self, key)
		if key == "ESCAPE" then
			self:SetPropagateKeyboardInput(false)
			ns.EndUITour()
		else
			self:SetPropagateKeyboardInput(true)
		end
	end)
	o:SetScript("OnHide", function()
		idx = 0
	end)

	-- Gold highlight box: a frame anchored to the target's corners, with 4 edge lines.
	local hl = CreateFrame("Frame", nil, o)
	hl:SetFrameLevel(o:GetFrameLevel() + 2)
	local function edge()
		local t = hl:CreateTexture(nil, "OVERLAY")
		t:SetColorTexture(1, 0.82, 0.2, 0.95)
		return t
	end
	local top, bottom, left, right = edge(), edge(), edge(), edge()
	top:SetPoint("TOPLEFT", hl, "TOPLEFT", 0, 0)
	top:SetPoint("TOPRIGHT", hl, "TOPRIGHT", 0, 0)
	top:SetHeight(2)
	bottom:SetPoint("BOTTOMLEFT", hl, "BOTTOMLEFT", 0, 0)
	bottom:SetPoint("BOTTOMRIGHT", hl, "BOTTOMRIGHT", 0, 0)
	bottom:SetHeight(2)
	left:SetPoint("TOPLEFT", hl, "TOPLEFT", 0, 0)
	left:SetPoint("BOTTOMLEFT", hl, "BOTTOMLEFT", 0, 0)
	left:SetWidth(2)
	right:SetPoint("TOPRIGHT", hl, "TOPRIGHT", 0, 0)
	right:SetPoint("BOTTOMRIGHT", hl, "BOTTOMRIGHT", 0, 0)
	right:SetWidth(2)
	o.hl = hl

	-- Callout bubble.
	local bubble = CreateFrame("Frame", nil, o, "BackdropTemplate")
	bubble:SetSize(330, 138)
	bubble:SetFrameLevel(o:GetFrameLevel() + 6)
	bubble:SetClampedToScreen(true)
	if bubble.SetBackdrop then
		bubble:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true, tileSize = 8, edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		})
		bubble:SetBackdropColor(0.10, 0.09, 0.12, 0.98)
		bubble:SetBackdropBorderColor(0.85, 0.7, 0.35, 1)
	end
	o.bubble = bubble

	local title = bubble:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetFontObject(ns.MHScalableFont and ns.MHScalableFont("GameFontHighlightLarge") or "GameFontHighlightLarge") -- volg de tekstschaal (F4.6)
	title:SetPoint("TOPLEFT", bubble, "TOPLEFT", 12, -10)
	title:SetPoint("RIGHT", bubble, "RIGHT", -12, 0)
	title:SetJustifyH("LEFT")
	bubble.title = title

	local body = bubble:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	body:SetFontObject(ns.MHScalableFont and ns.MHScalableFont("GameFontHighlightSmall") or "GameFontHighlightSmall") -- volg de tekstschaal (F4.6)
	body:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
	body:SetPoint("RIGHT", bubble, "RIGHT", -12, 0)
	body:SetJustifyH("LEFT")
	body:SetWordWrap(true)
	body:SetTextColor(0.88, 0.86, 0.8)
	bubble.body = body

	local counter = bubble:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	counter:SetPoint("BOTTOMLEFT", bubble, "BOTTOMLEFT", 12, 11)
	bubble.counter = counter

	local function mkBtn(w, onClick)
		local b = CreateFrame("Button", nil, bubble, "UIPanelButtonTemplate")
		b:SetSize(w, 20)
		b:SetScript("OnClick", onClick)
		return b
	end
	bubble.skip = mkBtn(64, function() ns.EndUITour() end)
	bubble.skip:SetPoint("BOTTOMRIGHT", bubble, "BOTTOMRIGHT", -12, 8)
	bubble.next = mkBtn(72, function() ns._mhTourStep(1) end)
	bubble.next:SetPoint("RIGHT", bubble.skip, "LEFT", -6, 0)
	bubble.back = mkBtn(60, function() ns._mhTourStep(-1) end)
	bubble.back:SetPoint("RIGHT", bubble.next, "LEFT", -6, 0)

	overlay = o
	return o
end

-- Position the highlight + bubble onto the current step's target.
local function ApplyStep()
	local o = overlay
	local step = active[idx]
	if not step then
		ns.EndUITour()
		return
	end
	local f = step.frameFn and step.frameFn()
	if not f then
		ns.EndUITour()
		return
	end

	o.hl:ClearAllPoints()
	o.hl:SetPoint("TOPLEFT", f, "TOPLEFT", -3, 3)
	o.hl:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 3, -3)
	o.hl:Show()

	local b = o.bubble
	b:ClearAllPoints()
	local a = step.anchor or "BELOW"
	if a == "RIGHT" then
		b:SetPoint("LEFT", f, "RIGHT", 12, 0)
	elseif a == "ABOVE" then
		b:SetPoint("BOTTOM", f, "TOP", 0, 12)
	else
		b:SetPoint("TOP", f, "BOTTOM", 0, -12)
	end

	b.title:SetText(ns:L(step.titleKey))
	b.body:SetText(ns:L(step.bodyKey))
	b.counter:SetText(("%d / %d"):format(idx, #active))

	if idx <= 1 then
		b.back:Disable()
	else
		b.back:Enable()
	end
	b.back:SetText(ns:L("TOUR_CM_BACK"))
	b.next:SetText(ns:L(idx >= #active and "TOUR_CM_DONE" or "TOUR_CM_NEXT"))
	b.skip:SetText(ns:L("TOUR_CM_SKIP"))
end

-- Advance (1) / go back (-1); finishing past the last step ends the tour.
function ns._mhTourStep(delta)
	if #active == 0 then
		return
	end
	idx = idx + (delta or 1)
	if idx > #active then
		ns.EndUITour()
		return
	end
	if idx < 1 then
		idx = 1
	end
	ApplyStep()
end

function ns.EndUITour()
	if overlay then
		overlay:Hide()
	end
	idx = 0
end

function ns.StartUITour()
	-- The main window must be open so frames have a position.
	if ns.ShowMainUI then
		ns:ShowMainUI()
	end
	EnsureOverlay()
	-- Safety net: if the main window ever hides while the tour runs (e.g. closed by
	-- other means), end the tour too so the click-blocking overlay can't outlive it (F4.2).
	if ns.mainUI and not ns._mhTourHookedMain then
		ns._mhTourHookedMain = true
		ns.mainUI:HookScript("OnHide", function()
			if overlay and overlay:IsShown() then
				ns.EndUITour()
			end
		end)
	end
	-- Build the run from steps whose target frame is available right now.
	wipe(active)
	for _, s in ipairs(STEPS) do
		local f = s.frameFn and s.frameFn()
		if f then
			active[#active + 1] = s
		end
	end
	if #active == 0 then
		return
	end
	idx = 1
	overlay:Show()
	ApplyStep()
end
