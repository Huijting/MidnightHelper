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

local PANEL_W, PANEL_H = 460, 434

local panel

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

--- ⚠️ Asks the schema rather than reading `GetCurrentBindingSet() == 1` itself. That
--- comparison lived here, in ApplyLayout and in BarInventory, and when Rob switched his
--- Hunter to character-specific this panel still said account-wide — three copies of an
--- assumption cannot disagree usefully. See `ns.Keybind_BindingSet`.
local function BindingSetName()
	if not ns.Keybind_BindingSet then
		return nil, nil
	end
	return ns.Keybind_BindingSet()
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
	--- ⚠️ `local _, class = UnitClass and UnitClass("player")` reads fine and cannot
	--- work: the `and` squeezes UnitClass's several return values down to one, so the
	--- class token never arrives and the panel showed "?". Exactly the same mistake as
	--- `select(2, GetBuildInfo and GetBuildInfo() or nil)` earlier today — which I had
	--- already fixed once and written down.
	local className
	if UnitClass then
		local okC, localised = pcall(UnitClass, "player")
		className = okC and localised or nil
	end
	local set, raw = BindingSetName()

	local lines = {}
	lines[#lines + 1] = (ns:L("MH_SETUP_WHO")):format(
		tostring(name), tostring(className or "?"), LayoutSize())

	if set == "account" then
		lines[#lines + 1] = ns:L("MH_SETUP_ACCOUNT_WARN")
	elseif set == "character" then
		lines[#lines + 1] = ns:L("MH_SETUP_CHARACTER_OK")
	else
		-- The raw value goes on screen too. "I cannot tell" is only useful to a player
		-- if they can pass on what the game actually said.
		lines[#lines + 1] = ns:L("MH_SETUP_SET_UNKNOWN")
			.. (raw ~= nil and (" |cff9d9d9d(" .. tostring(raw) .. ")|r") or "")
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
	f.title:SetText(ns:L("MH_SETUP_TITLE"))

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
		return btn, fs
	end

	--- The switch itself, because the warning alone was not enough.
	---
	--- Rob read "your keybindings are account-wide", went to the options and set this
	--- character to its own keys "voor de zekerheid" — and the panel still said
	--- account-wide. It was right: `Account\...\bindings-cache.wtf` was rewritten at the
	--- moment of his reload while `...\Redisch\bindings-cache.wtf` sat at 0 bytes and
	--- untouched since March. The switch had not taken. A panel that names a problem and
	--- then sends the player elsewhere to fix it is where that goes wrong.
	---
	--- `SaveBindings` is the same call the options screen makes, and MH already uses it
	--- after every apply. It copies the keys you have into the chosen set — nothing is
	--- lost either way, and pressing it again on the account set puts you back.
	f.charBtn, f.charNote = Row(MakeButton(f, ns:L("MH_SETUP_BTN_CHARSET"), function()
		if not SaveBindings then
			return
		end
		--- ⚠️ 2 is MEASURED, not assumed. `ACCOUNT_BINDINGS`/`CHARACTER_BINDINGS` are gone
		--- on 12.x (the probe recorded both as nil), so the constants cannot be asked.
		--- What is known: `GetCurrentBindingSet()` returned 1 on Rob's Hunter while the
		--- account file was the one being written, so 1 is the account set and 2 is the
		--- only other value the call takes. And we verify rather than trust it — if the
		--- game does not come back reading "character", the panel says so.
		pcall(SaveBindings, 2)
		local now = ns.Keybind_BindingSet and ns.Keybind_BindingSet()
		if now == "character" then
			print(Prefix() .. " " .. ns:L("MH_SETUP_CHARSET_DONE"))
		else
			print(Prefix() .. " " .. (ns:L("MH_SETUP_CHARSET_FAIL")):format(
				tostring(now or "?")))
		end
	end), ns:L("MH_SETUP_NOTE_CHARSET"))

	Row(MakeButton(f, ns:L("MH_SETUP_BTN_PREVIEW"), function()
		if ns.MH_ApplyLayout then
			ns.MH_ApplyLayout()
		end
	end), ns:L("MH_SETUP_NOTE_PREVIEW"))

	Row(MakeButton(f, ns:L("MH_SETUP_BTN_APPLY"), function()
		if ns.MH_ApplyLayout then
			ns.MH_ApplyLayout("go")
		end
	end), ns:L("MH_SETUP_NOTE_APPLY"))

	Row(MakeArmedButton(f, ns:L("MH_SETUP_BTN_CLEAR"), ns:L("MH_SETUP_CONFIRM"),
		function()
			if ns.MH_ApplyLayout then
				ns.MH_ApplyLayout("full go")
			end
		end), ns:L("MH_SETUP_NOTE_CLEAR"))

	Row(MakeArmedButton(f, ns:L("MH_SETUP_BTN_CLEAN"), ns:L("MH_SETUP_CONFIRM"),
		function()
			if ns.MH_ApplyLayout then
				ns.MH_ApplyLayout("clean go")
			end
		end), ns:L("MH_SETUP_NOTE_CLEAN"))

	Row(MakeButton(f, ns:L("MH_SETUP_BTN_PLAN"), function()
		if ns.MH_ShowBarPlan then
			ns.MH_ShowBarPlan()
		end
	end), ns:L("MH_SETUP_NOTE_PLAN"))

	Row(MakeButton(f, ns:L("MH_SETUP_BTN_UNDO"), function()
		if ns.MH_ApplyLayout then
			ns.MH_ApplyLayout("undo")
		end
	end), ns:L("MH_SETUP_NOTE_UNDO"))

	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.foot:SetPoint("BOTTOMLEFT", 16, 14)
	f.foot:SetPoint("BOTTOMRIGHT", -16, 14)
	f.foot:SetJustifyH("LEFT")
	f.foot:SetText(ns:L("MH_SETUP_FOOT"))

	function f:Refresh()
		self.status:SetText(StatusText())
		-- Greyed out rather than hidden: a row that appears and disappears moves every
		-- button under it, and these buttons do different things.
		local set = ns.Keybind_BindingSet and ns.Keybind_BindingSet()
		local already = (set == "character")
		self.charBtn:SetEnabled(not already)
		self.charNote:SetText(already and ns:L("MH_SETUP_NOTE_CHARSET_OK")
			or ns:L("MH_SETUP_NOTE_CHARSET"))
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
