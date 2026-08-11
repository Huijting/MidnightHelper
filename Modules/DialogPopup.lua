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
