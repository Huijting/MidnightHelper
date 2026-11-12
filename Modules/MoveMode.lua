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
	box.text = box:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	box.text:SetPoint("CENTER")
	box.text:SetTextColor(1, 1, 1)
	box.text:SetShadowOffset(1, -1)
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

local function Tick()
	if not active then
		return
	end
	for _, el in ipairs(ELEMENTS) do
		local f = Usable(el)
		local box = boxes[el.name]
		if f and box then
			if not f:IsShown() then
				forced[el.name] = forced[el.name] or { alpha = f:GetAlpha() }
				f:Show()
			end
			if forced[el.name] and f:GetAlpha() < 1 then
				f:SetAlpha(1)
			end
			if not box._dragging then
				Place(box, f)
			end
		end
	end
end

local function Stop(reason)
	if not active then
		return
	end
	active = false
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
			f:SetAlpha(st.alpha or 1)
			f:Hide()
		end
	end
	forced = {}
	-- Let the modules decide again what should be visible now.
	if ns.UpdateMissingBuff then
		pcall(ns.UpdateMissingBuff)
	end
	if ns.SyncNativeSetting then
		ns.SyncNativeSetting("mh_moveMode", false)
	end
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
