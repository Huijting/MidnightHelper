local _, ns = ...

--[[
	KeysHub.lua — one door for everything about your keys (Rob, 21 Oct 2026: "Doe A: één vaste ingang 'Toetsen' met een
	simpel startvenster en drie grote knoppen, op elk level zichtbaar").

	Why: the survey had the keybind coach at 12× "never / don't know", 0× "often" (docs/SURVEY_RESULTS.md). Measured
	that day: the keyboard was a sub-tab ("Layout") of the Leveling tab, which hides itself at level 90, and the rest
	lived in four separate windows behind slash commands (/mh block, /mh presses, /mh setup, /mh binds).

	This window adds nothing new: three big buttons open what already exists.
	  1. Set up my keys      -> the key block (KeyBlock.lua)
	  2. Which spells I press -> the presses window with its Swap tips (KeyPresses.lua)
	  3. Show my keyboard     -> the Layout keyboard in a window of its own, so it works at every level
	Doors in: a card in the Tools room (RoomLauncher.lua), the first tile on the Tools launchpad, the search bar, and
	/mh mykeys.
]]

local hub, kbWin

local function Build()
	if hub then
		return hub
	end
	local f = CreateFrame("Frame", "MidnightHelperKeysHub", UIParent, "BackdropTemplate")
	f:SetSize(440, 360)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- Shift+scroll scales it, like every MH window
	end
	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 18, -16)
	title:SetPoint("TOPRIGHT", -40, -16)
	title:SetJustifyH("LEFT")
	title:SetText(ns:L("KEYSHUB_TITLE"))

	local intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	intro:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	intro:SetPoint("RIGHT", f, "RIGHT", -18, 0)
	intro:SetJustifyH("LEFT")
	intro:SetText(ns:L("KEYSHUB_INTRO"))

	local anchor = intro
	f.rows = {}
	local function Row(btnKey, descKey, onClick)
		local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		b:SetHeight(32)
		b:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -16)
		b:SetPoint("RIGHT", f, "RIGHT", -18, 0)
		b:SetText(ns:L(btnKey))
		b:SetScript("OnClick", function()
			f:Hide()
			onClick()
		end)
		local d = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		d:SetPoint("TOPLEFT", b, "BOTTOMLEFT", 4, -4)
		d:SetPoint("RIGHT", f, "RIGHT", -22, 0)
		d:SetJustifyH("LEFT")
		d:SetSpacing(2)
		d:SetTextColor(0.82, 0.8, 0.74)
		d:SetText(ns:L(descKey))
		anchor = d
		f.rows[#f.rows + 1] = { btn = b, desc = d, descKey = descKey }
		return d
	end

	Row("KEYSHUB_BLOCK_BTN", "KEYSHUB_BLOCK_DESC", function()
		if ns.ShowKeyBlock then
			ns.ShowKeyBlock()
		end
	end)
	f.pressesDesc = Row("KEYSHUB_PRESSES_BTN", "KEYSHUB_PRESSES_DESC", function()
		if ns.KeyPressesCommand then
			ns.KeyPressesCommand(nil)
		end
	end)
	Row("KEYSHUB_KEYBOARD_BTN", "KEYSHUB_KEYBOARD_DESC", function()
		ns.ShowKeysKeyboard(nil)
	end)

	hub = f
	return f
end

local function Refresh(f)
	-- Counting starts off (SettingsDefs mh_keyPresses), and then the Swap tips have nothing to say: tell the player
	-- before the click, in the same place as the button (CLAUDE.md: "zet de uitleg in dezelfde kamer als de knop").
	local text = ns:L("KEYSHUB_PRESSES_DESC")
	if ns.IsKeyPressesEnabled and not ns.IsKeyPressesEnabled() then
		text = text .. "|n|cffffcc00" .. ns:L("KEYSHUB_PRESSES_OFF") .. "|r"
	end
	f.pressesDesc:SetText(text)
	-- Grow with the text, so a longer translation never runs out of the bottom.
	local top = f:GetTop()
	local bottom = f.rows[#f.rows].desc:GetBottom()
	if top and bottom then
		f:SetHeight(math.max(240, top - bottom + 22))
	end
end

function ns.ShowKeysHub()
	local f = Build()
	f:Show()
	Refresh(f)
end

function ns.ToggleKeysHub()
	if hub and hub:IsShown() then
		hub:Hide()
	else
		ns.ShowKeysHub()
	end
end

--- The Layout keyboard in a window of its own. The same builder as the Leveling tab's Layout sub-tab, on its own
--- panel, so it does not depend on that tab being shown (it hides itself at level 90).
--- @param highlightKey string|nil a key to light up (ns.MH_GuideOpenLayoutForKey); nil clears an old highlight
--- @return Frame|nil the keyboard panel
function ns.ShowKeysKeyboard(highlightKey)
	if not ns.BuildKeyboardLayoutPrototypePanel then
		return nil
	end
	if not kbWin then
		local f = CreateFrame("Frame", "MidnightHelperKeysKeyboard", UIParent, "BackdropTemplate")
		f:SetSize(760, 600)
		f:SetPoint("CENTER")
		f:SetFrameStrata("HIGH")
		f:SetClampedToScreen(true)
		f:EnableMouse(true)
		f:SetMovable(true)
		f:RegisterForDrag("LeftButton")
		f:SetScript("OnDragStart", f.StartMoving)
		f:SetScript("OnDragStop", f.StopMovingOrSizing)
		f:Hide()
		if ns.ApplyMidnightDialogBackdrop then
			ns.ApplyMidnightDialogBackdrop(f)
		end
		if ns.RegisterMidnightDialogPopup then
			ns.RegisterMidnightDialogPopup(f)
		end
		local inner = CreateFrame("Frame", nil, f)
		inner:SetPoint("TOPLEFT", 8, -8)
		inner:SetPoint("BOTTOMRIGHT", -8, 8)
		f.inner = inner
		if ns.AttachMidnightDialogCloseButton then
			ns.AttachMidnightDialogCloseButton(f, function()
				f:Hide()
			end)
		end
		kbWin = f
	end
	if ns.KeyboardLayoutPrototype_SetHighlight then
		ns.KeyboardLayoutPrototype_SetHighlight(kbWin.inner, highlightKey)
	end
	kbWin:Show()
	ns.BuildKeyboardLayoutPrototypePanel(kbWin.inner)
	if ns.KeyboardLayoutPrototype_Refresh then
		ns.KeyboardLayoutPrototype_Refresh(kbWin.inner)
	end
	return kbWin.inner
end
