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

-- Wider than it looks like it needs: the buttons size themselves to the longest
-- translated label (see Build), and the notes sit to their right.
local PANEL_W, PANEL_H = 520, 300

local panel

--------------------------------------------------------------------------------
-- What the last button actually did, ON the panel
--------------------------------------------------------------------------------

--- ⚠️ CHAT IS NOT WHERE PEOPLE LOOK, AND THE PANEL ALREADY KNEW THAT.
---
--- This file's own header says it: the account-bindings warning is on the panel
--- because Rob missed it in chat while staring at his bars. Then everything the
--- buttons ANSWER with went to chat anyway.
---
--- It caught him on his level-30 TwelveInchy, 11 Aug 2026. The bar preset refused —
--- he was sitting on one of Blizzard's presets, which cannot be edited — and said so,
--- in chat, with the fix. He read it, made a character layout, reloaded, and it worked.
--- His point: he knew to look there. Carola will press the button, see the panel not
--- change, and conclude the addon is broken.
---
--- So a button's answer lands here as well. Same words in both places — one locale key
--- read twice, never a second shortened copy, because two texts saying nearly the same
--- thing is how they drift apart.
---
--- ⚠️ Deliberately does NOT build the panel. Someone driving this from slash commands
--- has no panel open and does not want one appearing; the message waits in `lastResult`
--- and is drawn whenever the panel is next shown.
--- @param kind string  "ok" | "warn" | "info"
local lastResult

local RESULT_COLOUR = {
	ok = "|cff40c040",
	warn = "|cffff9900",
	info = "|cffd8d8d8",
}

function ns.MH_SetupSay(kind, text)
	if type(text) ~= "string" or text == "" then
		return
	end
	--- ⚠️ Strip the message's OWN colour codes first. Several of these strings are written
	--- for chat and colour a phrase themselves; wrapped in the panel colour, their `|r`
	--- ends the panel's colour early and the rest of the sentence falls back to white.
	--- The panel decides the colour here — one severity per message, not a patchwork.
	text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	lastResult = { kind = kind, text = text }
	if panel and panel.Refresh then
		panel:Refresh()
	end
end

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
		-- With the key block this is a feature, not a warning: the same keys on every character.
		lines[#lines + 1] = ns:L("MH_SETUP_ACCOUNT_BLOCK")
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
--- @param onArm function|nil  runs on the FIRST press, to show what the second would do
local function MakeArmedButton(parent, label, armedLabel, fn, onArm)
	local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	b:SetSize(196, 24)
	b._armed = false
	b:SetText(label)
	b:SetScript("OnClick", function(self)
		if not self._armed then
			self._armed = true
			self:SetText(armedLabel)
			--- ⚠️ THE BUTTON HAS TO SAY IT IS WAITING.
			---
			--- The thumb-key button was built with its own armed flag and a plain
			--- MakeButton, so its label never changed. Rob pressed it once, saw a plan in
			--- chat, and reasonably concluded it was done — the keys were still unbound.
			--- A two-press control that looks identical in both states is a one-press
			--- control that silently fails half the time.
			if onArm then
				onArm()
			end
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

	--- Every button on the panel, so the widest label can size all of them at the end.
	local buttons = {}

	local function Row(btn, note)
		btn:SetPoint("TOPLEFT", 16, y)
		local fs = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		fs:SetPoint("LEFT", btn, "RIGHT", 10, 0)
		fs:SetPoint("RIGHT", f, "RIGHT", -14, 0)
		fs:SetJustifyH("LEFT")
		fs:SetText(note)
		y = y - 30
		buttons[#buttons + 1] = btn
		return btn, fs
	end

	--- 5 Oct 2026, Rob chose option A: the key block (`/mh block`) is the way in now. The old v7 steps
	--- (own keys, plan, place, clear, dead keys, bar plan, thumb keys, bar preset, bars back, export) left
	--- this panel: "niemand heeft hem aangegeven als zijnde gebruikt … wat we nu gebouwd hebben is vele
	--- malen beter". Their slash commands still work. What stays: the block, Blizzard's Quick Keybind
	--- ("iets wat ik wel vaak gebruikt heb"), and the old undo for one release, so nobody who used the
	--- old steps is stranded without a way back.
	Row(MakeButton(f, ns:L("MH_SETUP_BTN_BLOCK"), function()
		if ns.ShowKeyBlock then
			f:Hide()
			ns.ShowKeyBlock()
		end
	end), ns:L("MH_SETUP_NOTE_BLOCK"))

	--- Blizzard's own Quick Keybind Mode: hover a button, press a key.
	Row(MakeButton(f, ns:L("MH_SETUP_BTN_QUICKBIND"), function()
		if ns.MH_OpenQuickKeybind then
			ns.MH_OpenQuickKeybind()
		end
	end), ns:L("MH_SETUP_NOTE_QUICKBIND"))


	Row(MakeButton(f, ns:L("MH_SETUP_BTN_UNDO"), function()
		if ns.MH_ApplyLayout then
			ns.MH_ApplyLayout("undo")
		end
	end), ns:L("MH_SETUP_NOTE_UNDO"))

	--- ⚠️ SIZE THE BUTTONS TO THE TEXT, DON'T PICK A NUMBER.
	---
	--- All seven were a fixed 196px and "Give this character its own keys" spilled out of
	--- its edges. Bumping the constant would fix English and break German, where the same
	--- label is "Eigene Tasten für diesen Charakter"; French and Portuguese are longer
	--- still. A hardcoded width is a bet that no translation is longer than the one you
	--- looked at.
	---
	--- So measure: widest rendered label wins, everything matches it, and the notes are
	--- anchored to the buttons so they follow along. Works for a language nobody has
	--- added yet.
	do
		local widest = 0
		for _, b in ipairs(buttons) do
			local fs = b.GetFontString and b:GetFontString()
			local w = fs and fs:GetStringWidth() or 0
			if w > widest then
				widest = w
			end
		end
		-- +26 for the template's own inner padding; never narrower than before.
		local w = math.max(196, math.ceil(widest) + 26)
		for _, b in ipairs(buttons) do
			b:SetWidth(w)
		end
	end

	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.foot:SetPoint("BOTTOMLEFT", 16, 14)
	f.foot:SetPoint("BOTTOMRIGHT", -16, 14)
	f.foot:SetJustifyH("LEFT")
	f.foot:SetText(ns:L("MH_SETUP_FOOT_BLOCK"))

	--- Anchored to the BOTTOM so it grows upward into empty space. Anchored to the top it
	--- would push every button down the moment a three-line answer arrived, and a panel
	--- whose buttons move while you are reading it is its own small betrayal.
	f.result = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.result:SetPoint("BOTTOMLEFT", 16, 34)
	f.result:SetPoint("BOTTOMRIGHT", -16, 34)
	f.result:SetJustifyH("LEFT")
	f.result:SetSpacing(2)
	f.result:SetWordWrap(true)

	function f:Refresh()
		self.status:SetText(StatusText())
		if lastResult then
			self.result:SetText((RESULT_COLOUR[lastResult.kind] or RESULT_COLOUR.info)
				.. lastResult.text .. "|r")
		else
			self.result:SetText("")
		end
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
