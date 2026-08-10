local _, ns = ...

--[[
	Midnight Helper — set up your bars without typing anything (`/mh setup`).

	Rob spent an evening running `/mh apply`, `/mh apply full go`, `/mh apply clean go`
	and `/mh editmode export` from memory, in the right order, on the right character.
	Then he cleaned his Hunter while his HUNTER was still on account-wide bindings — he
	had switched his Druid, not this one — and his Mage lost eight keys. His words:
	"stomme fout van mij". It was not. Nothing on screen told him which set this
	character was using at the moment he pressed go.

	So the state comes first and the buttons come second. The panel says who you are,
	which binding set you are on, and what would change — before offering anything that
	changes it.

	⚠️ Two rules this panel keeps:
	  * Nothing destructive on one click. Clear-and-refill and the binding cleanup both
	    arm first and act on a second, deliberate press.
	  * The account-bindings warning is ON the panel, not only in chat. Rob missed it in
	    chat while looking at his bars, which is exactly where a player looks.
]]

local PANEL_W, PANEL_H = 460, 400

local panel

local function BindingSetName()
	if not GetCurrentBindingSet then
		return nil
	end
	local ok, set = pcall(GetCurrentBindingSet)
	if not ok then
		return nil
	end
	return (set == 1 and "account") or (set == 2 and "character") or tostring(set)
end

--- How many keys the layout wants, so the panel can say something true about this spec
--- rather than a generic sentence.
local function LayoutSize()
	local spec = ns.MH_AutoMapSpecAndSlots and ns.MH_AutoMapSpecAndSlots()
	local n = 0
	for _ in pairs((spec and spec.spellByUiKey) or {}) do
		n = n + 1
	end
	return n
end

local function StatusText()
	local name = (UnitName and UnitName("player")) or "?"
	local _, class = UnitClass and UnitClass("player")
	local set = BindingSetName()
	local keys = LayoutSize()

	local lines = {}
	lines[#lines + 1] = ("|cffffd100%s|r  ·  %s  ·  |cffffffff%d|r toetsen in de layout")
		:format(tostring(name), tostring(class or "?"), keys)

	if set == "account" then
		lines[#lines + 1] = "|cffff9900Je keybindings zijn account-breed.|r Wat je hier"
		lines[#lines + 1] = "|cffff9900opruimt, ruim je op ál je personages op.|r"
	elseif set == "character" then
		lines[#lines + 1] = "|cff40c040Keybindings zijn van dit personage alleen.|r Veilig opruimen."
	else
		lines[#lines + 1] = "|cff9d9d9dKon de bindingsmodus niet lezen.|r"
	end
	return table.concat(lines, "\n")
end

--- A button that needs two presses: the first arms it and says what it will do, the
--- second does it. Used for anything that removes something.
local function MakeArmedButton(parent, label, armedLabel, fn)
	local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	b:SetSize(196, 24)
	b._armed = false
	b:SetText(label)
	b:SetScript("OnClick", function(self)
		if not self._armed then
			self._armed = true
			self:SetText(armedLabel)
			if C_Timer and C_Timer.After then
				C_Timer.After(6, function()
					if self._armed then
						self._armed = false
						self:SetText(label)
					end
				end)
			end
			return
		end
		self._armed = false
		self:SetText(label)
		fn()
		if panel and panel.Refresh then
			panel:Refresh()
		end
	end)
	return b
end

local function MakeButton(parent, label, fn)
	local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	b:SetSize(196, 24)
	b:SetText(label)
	b:SetScript("OnClick", function()
		fn()
		if panel and panel.Refresh then
			panel:Refresh()
		end
	end)
	return b
end

local function Build()
	if panel then
		return panel
	end
	local f = CreateFrame("Frame", "MidnightHelperLayoutWizard", UIParent, "BackdropTemplate")
	f:SetSize(PANEL_W, PANEL_H)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
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

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 16, -14)
	f.title:SetText("Je balken inrichten")

	f.status = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.status:SetPoint("TOPLEFT", 16, -42)
	f.status:SetPoint("TOPRIGHT", -16, -42)
	f.status:SetJustifyH("LEFT")
	f.status:SetSpacing(2)

	local y = -110

	local function Row(btn, note)
		btn:SetPoint("TOPLEFT", 16, y)
		local fs = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		fs:SetPoint("LEFT", btn, "RIGHT", 10, 0)
		fs:SetPoint("RIGHT", f, "RIGHT", -14, 0)
		fs:SetJustifyH("LEFT")
		fs:SetText(note)
		y = y - 30
	end

	Row(MakeButton(f, "1 · Wat zou er veranderen?", function()
		if ns.MH_ApplyLayout then
			ns.MH_ApplyLayout()
		end
	end), "Verandert niets. Zet het plan in je chat.")

	Row(MakeButton(f, "2 · Zet mijn layout neer", function()
		if ns.MH_ApplyLayout then
			ns.MH_ApplyLayout("go")
		end
	end), "Plaatst de spells en bindt de toetsen.")

	Row(MakeArmedButton(f, "3 · Balken leeghalen", "Zeker weten? Klik weer",
		function()
			if ns.MH_ApplyLayout then
				ns.MH_ApplyLayout("full go")
			end
		end), "Balk 1-6 leeg, jouw macro's naar 7-8. Doe daarna stap 2.")

	Row(MakeArmedButton(f, "4 · Dode toetsen opruimen", "Zeker weten? Klik weer",
		function()
			if ns.MH_ApplyLayout then
				ns.MH_ApplyLayout("clean go")
			end
		end), "Lees eerst de waarschuwing hierboven.")

	Row(MakeButton(f, "Waar horen mijn balken?", function()
		if ns.MH_ShowBarPlan then
			ns.MH_ShowBarPlan()
		end
	end), "Maten en volgorde voor dit personage.")

	Row(MakeButton(f, "Terugdraaien", function()
		if ns.MH_ApplyLayout then
			ns.MH_ApplyLayout("undo")
		end
	end), "Zet de laatste stap terug.")

	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.foot:SetPoint("BOTTOMLEFT", 16, 14)
	f.foot:SetPoint("BOTTOMRIGHT", -16, 14)
	f.foot:SetJustifyH("LEFT")
	f.foot:SetText("Volgorde als je opnieuw begint: 3, dan 2. Lees stap 1 als je twijfelt.")

	function f:Refresh()
		self.status:SetText(StatusText())
	end

	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end
	panel = f
	return f
end

--- `/mh setup`
function ns.MH_ShowLayoutWizard()
	local f = Build()
	f:Refresh()
	f:Show()
end
