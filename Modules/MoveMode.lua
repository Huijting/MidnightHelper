local _, ns = ...

--[[
	MoveMode.lua — one switch "Move": every MH element on your screen at once, each with a "drag me" box.

	Rob, 11 Nov 2026 (IDEEEN "Eén schakelaar Verplaatsen voor alle MH-onderdelen op het scherm"), bouw-ja 12 Nov via the
	sparring chat: "Knop 'Verplaatsen'" — "Eén schakelaar die alle MH-onderdelen op je scherm zichtbaar maakt met
	'sleep mij'." Found in Settings (Midnight Helper -> on-screen buttons) and as /mh move. Midnight + Forever.

	How it works, and why this way:
	  - Each element already knows how to be dragged and where to save its place (its own OnDragStart/OnDragStop). The box
	    over it does not copy that: dragging the box calls THAT element's own scripts, so every place is saved exactly as
	    before (the secure click layers of the buff icon and the party panel move along, as they do on a normal drag).
	  - The box is NOT anchored to the element (an overlay anchored to a protected frame gets restricted in combat); it is
	    placed over it by hand, twice a second.
	  - An element that is hidden right now (no buff missing, no arrow) is shown while the switch is on, and hidden again
	    afterwards; its own update then decides. Elements whose frame does not exist (the feature is off, or never used
	    this session) are skipped: /mh move why lists both.
	  - Only out of combat. Entering combat switches it off (moving protected frames in combat is blocked).
	The list below is by frame name (measured with a grep on 12 Nov 2026: CreateFrame names + their OnDragStart);
	a module that gets a new on-screen frame adds a row here. Not tested in game yet.
]]

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- name = global frame name; label = locale key; drag = where the drag scripts live (default the frame itself).
local ELEMENTS = {
	{ name = "MidnightHelperMissingBuff", label = "MOVE_EL_BUFF" },
	{ name = "MidnightHelperActionPrompt", label = "MOVE_EL_PROMPT" },
	{ name = "MidnightHelperNativeArrow", label = "MOVE_EL_ARROW" },
	{ name = "MidnightHelperBriefNotice", label = "MOVE_EL_NOTICE" },
	{ name = "MidnightHelperToast", label = "MOVE_EL_TOAST" },
	{ name = "MidnightHelperQuickBar", label = "MOVE_EL_QUICKBAR" },
	{ name = "MidnightHelperMarkBar", label = "MOVE_EL_MARKBAR", drag = "_mhDragHandle" },
	{ name = "MidnightHelperPartyTargets", label = "MOVE_EL_PARTY" },
	{ name = "MidnightHelperForeverParty", label = "MOVE_EL_PARTY" }, -- Forever's small group panel (12 Nov 2026)
	{ name = "MidnightHelperForeverDoNow", label = "MOVE_EL_DONOW" }, -- Forever "Do this now" (12 Nov 2026)
	{ name = "MidnightHelperCombatSafety", label = "MOVE_EL_SAFETY" },
	-- 26 Nov 2026 (Rob, Forever: "Ik kon dus niet die bars verplaatsen"): the cast bars stack, with three sample bars
	-- while moving (preview = the function that shows them; only when the bars are switched on).
	-- labelAbove: the label sits above the box, not over the sample bars (Rob's screenshot 26 Nov: "Drag me: dangerous
	-- cast bars" ran right through the middle bar).
	{ name = "MidnightHelperCombatSafetyBars", label = "MOVE_EL_SAFETY_BARS", preview = "CombatSafetyBarsPreview",
		labelAbove = true },
	{ name = "MidnightHelperCombatLogLamp", label = "MOVE_EL_LAMP" },
	{ name = "MidnightHelperFpsPanel", label = "MOVE_EL_FPS" },
}

local active = false
local boxes = {} -- name -> overlay
local forced = {} -- name -> { alpha = n } for frames we showed
local ticker

local function DragSource(el, f)
	if el.drag then
		return f[el.drag]
	end
	return f
end

local function Usable(el)
	local f = _G[el.name]
	if not (f and f.GetScript and f.IsMovable) then
		return nil, "not on your screen (switched off, or not used yet)"
	end
	local src = DragSource(el, f)
	if not (src and src.GetScript and src:GetScript("OnDragStart")) then
		return nil, "cannot be dragged"
	end
	return f, src
end

local function Place(box, f)
	local l, b, w, h = f:GetLeft(), f:GetBottom(), f:GetWidth(), f:GetHeight()
	if not (l and b and w and h) then
		box:Hide()
		return
	end
	local s = (f:GetEffectiveScale() or 1) / (UIParent:GetEffectiveScale() or 1)
	box:ClearAllPoints()
	box:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", l * s, b * s)
	box:SetSize(math.max(w * s, 60), math.max(h * s, 24))
	box:Show()
end

local function Box(el)
	local box = boxes[el.name]
	if box then
		return box
	end
	box = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	box:SetFrameStrata("FULLSCREEN_DIALOG")
	box:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, edgeSize = 12,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	box:SetBackdropColor(0.1, 0.6, 0.2, 0.35)
	box:SetBackdropBorderColor(0.3, 1, 0.4, 0.95)
	box.text = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	box.text:SetTextColor(1, 1, 1)
	box.text:SetShadowOffset(1, -1)
	if el.labelAbove then
		-- On a dark strip just above the box, so it never covers what you are placing.
		box.textBg = box:CreateTexture(nil, "ARTWORK")
		box.textBg:SetColorTexture(0.05, 0.25, 0.08, 0.9)
		box.text:SetPoint("BOTTOM", box, "TOP", 0, 5)
		box.textBg:SetPoint("TOPLEFT", box.text, "TOPLEFT", -6, 3)
		box.textBg:SetPoint("BOTTOMRIGHT", box.text, "BOTTOMRIGHT", 6, -3)
	else
		box.text:SetPoint("CENTER")
	end
	box:EnableMouse(true)
	box:RegisterForDrag("LeftButton")
	box:SetScript("OnDragStart", function(self, button)
		if InCombatLockdown and InCombatLockdown() then
			return
		end
		local f, src = Usable(el)
		if f then
			self._dragging = true
			pcall(src:GetScript("OnDragStart"), src, button or "LeftButton")
		end
	end)
	box:SetScript("OnDragStop", function(self, button)
		self._dragging = false
		local f, src = Usable(el)
		if f and src:GetScript("OnDragStop") then
			pcall(src:GetScript("OnDragStop"), src, button or "LeftButton")
		elseif f then
			f:StopMovingOrSizing()
		end
	end)
	box:SetScript("OnUpdate", function(self)
		if self._dragging then
			local f = _G[el.name]
			if f then
				Place(self, f)
			end
		end
	end)
	boxes[el.name] = box
	return box
end

--- The frame's alpha as a plain number, or nil when the client gives a secret one. 26 Nov 2026 (Rob, Forever, BugSack:
--- "MoveMode.lua:144: attempt to compare a secret number value"): the cast warning sets its alpha with
--- SetAlphaFromBoolean, so GetAlpha() returns a secret number that may not be compared or stored.
local function PlainAlpha(f)
	local ok, a = pcall(f.GetAlpha, f)
	if not ok or type(a) ~= "number" or (issecretvalue and issecretvalue(a)) then
		return nil
	end
	return a
end

local function Tick()
	if not active then
		return
	end
	for _, el in ipairs(ELEMENTS) do
		local f = Usable(el)
		local box = boxes[el.name]
		if f and box then
			if not f:IsShown() then
				forced[el.name] = forced[el.name] or { shown = true, alpha = PlainAlpha(f) }
				f:Show()
			end
			-- Faded out (or secret: we cannot tell): fully visible while moving, put back afterwards.
			local a = PlainAlpha(f)
			if a == nil or a < 1 then
				forced[el.name] = forced[el.name] or { shown = false }
				if not forced[el.name].faded then
					forced[el.name].faded = true
					forced[el.name].fadeAlpha = a -- nil = it was secret
				end
				f:SetAlpha(1)
			end
			if not box._dragging then
				Place(box, f)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- A bar at the top while Move is on (26 Nov 2026). Rob: "Als ik op escape druk, blijft alles staan, dus dat schiet niet
-- op." → a "Done" button, and Escape stops Move: the bar is in UISpecialFrames (RegisterMidnightDialogPopup), so Escape
-- hides it and its OnHide stops Move.
--------------------------------------------------------------------------------
local bar
local Stop

local function Bar()
	if bar then
		return bar
	end
	local b = CreateFrame("Frame", "MidnightHelperMoveBar", UIParent, "BackdropTemplate")
	-- 26 Nov 2026 (Rob, Midnight: the first /mh move showed only this bar, no green boxes, and Done did nothing; a second
	-- /mh move showed everything). A new frame is SHOWN. The b:Hide() at the end ran after OnHide was set, so OnHide
	-- stopped Move that had just started, and Start then showed the bar anyway. Hidden first, before any script.
	b:Hide()
	-- _mhNoDock: no "Dock to window" button (retail); Rob's screenshot had it right across Done.
	b._mhNoDock = true
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(b) -- Escape closes it (= stops Move); Shift+scroll = size
	end
	b:SetFrameStrata("FULLSCREEN_DIALOG")
	b:SetSize(520, 40)
	b:SetPoint("TOP", UIParent, "TOP", 0, -12)
	b:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
	b:SetBackdropColor(0.04, 0.12, 0.05, 0.95)
	b:SetBackdropBorderColor(0.3, 1, 0.4, 0.95)
	b.text = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	b.text:SetPoint("LEFT", 12, 0)
	b.text:SetPoint("RIGHT", -100, 0)
	b.text:SetJustifyH("LEFT")
	b.done = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.done:SetSize(80, 24)
	b.done:SetPoint("RIGHT", -8, 0)
	b.done:SetScript("OnClick", function()
		Stop()
	end)
	b:SetScript("OnHide", function()
		if active then
			Stop()
		end
	end)
	b:Hide()
	bar = b
	return b
end

local function Changed()
	-- The buttons that say Open/Close (Forever Tools) and the settings checkbox follow.
	if ns.ForeverOverviewRefreshIfShown then
		pcall(ns.ForeverOverviewRefreshIfShown)
	end
end

function Stop(reason)
	if not active then
		return
	end
	active = false
	if bar then
		bar:Hide()
	end
	if ticker then
		ticker:Cancel()
		ticker = nil
	end
	for _, box in pairs(boxes) do
		box._dragging = false
		box:Hide()
	end
	for name, st in pairs(forced) do
		local f = _G[name]
		if f and not (InCombatLockdown and InCombatLockdown()) then
			if st.faded then
				-- A secret alpha is never stored: such a frame (the cast warning) goes back to 0, and its own next
				-- SetAlphaFromBoolean decides again.
				f:SetAlpha(st.fadeAlpha or 0)
			elseif st.alpha then
				f:SetAlpha(st.alpha)
			end
			if st.shown then
				f:Hide()
			end
		end
	end
	forced = {}
	for _, el in ipairs(ELEMENTS) do
		if el.preview and ns[el.preview] then
			pcall(ns[el.preview], false)
		end
	end
	-- Let the modules decide again what should be visible now.
	if ns.UpdateMissingBuff then
		pcall(ns.UpdateMissingBuff)
	end
	if ns.SyncNativeSetting then
		ns.SyncNativeSetting("mh_moveMode", false)
	end
	Changed()
	print(PREFIX .. (reason or ns:L("MOVE_OFF")))
end

local function Start()
	if active then
		return true
	end
	if InCombatLockdown and InCombatLockdown() then
		print(PREFIX .. ns:L("MOVE_NOT_IN_COMBAT"))
		return false
	end
	active = true
	local n = 0
	for _, el in ipairs(ELEMENTS) do
		if el.preview and ns[el.preview] then
			pcall(ns[el.preview], true) -- sample content, so there is something to see and the frame exists
		end
		local f = Usable(el)
		if f then
			local box = Box(el)
			box.text:SetText(ns:L("MOVE_DRAG_FMT"):format(ns:L(el.label)))
			n = n + 1
		end
	end
	Tick()
	if C_Timer and C_Timer.NewTicker then
		ticker = C_Timer.NewTicker(0.5, Tick)
	end
	local b = Bar()
	b.text:SetText(ns:L("MOVE_BAR_LINE"))
	b.done:SetText(ns:L("MOVE_BAR_DONE"))
	b:Show()
	if ns.SyncNativeSetting then
		ns.SyncNativeSetting("mh_moveMode", true)
	end
	Changed()
	print(PREFIX .. ns:L("MOVE_ON_FMT"):format(n))
	return true
end

function ns.IsMoveModeOn()
	return active
end

function ns.SetMoveMode(on)
	if on then
		Start()
	else
		Stop()
	end
end

function ns.MoveModeSlash(arg)
	arg = (arg or ""):lower()
	if arg == "why" or arg == "check" then
		print(PREFIX .. ("move: %s. Per element:"):format(active and "on" or "off"))
		for _, el in ipairs(ELEMENTS) do
			local f, why = Usable(el)
			print(("  %s (%s): %s"):format(ns:L(el.label), el.name,
				f and (f:IsShown() and "on screen" or "hidden now (shown while moving)") or why))
		end
	elseif arg == "on" then
		Start()
	elseif arg == "off" then
		Stop()
	elseif active then
		Stop()
	else
		Start()
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:SetScript("OnEvent", function()
	if active then
		Stop(ns:L("MOVE_COMBAT_OFF"))
	end
end)
