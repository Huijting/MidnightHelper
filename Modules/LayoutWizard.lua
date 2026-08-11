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
local PANEL_W, PANEL_H = 520, 584

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
		--- ⚠️ ONE PRESS IS NOT ENOUGH, AND THAT IS MEASURED TWICE.
		---
		--- `SaveBindings(2)` flips what `GetCurrentBindingSet()` reports straight away,
		--- so the panel turns green and it looks finished. On the PTR it then fell back:
		--- Rob pressed this, ran `/mh apply go`, reloaded — and the ACCOUNT file had
		--- grown from 0 to 664 bytes with no character file in sight, reading 1 again.
		--- His keys went to every character, the exact thing this button prevents.
		---
		--- What DID stick, found by Rob trying his own order: this button, then step 3
		--- (clear and refill), then 1 and 2, then a reload. That left
		--- `Mageme\bindings-cache.wtf` at 680 bytes and the set on 2.
		---
		--- ⚠️ Why that order works is NOT established. Two observations, no mechanism —
		--- most likely the set only persists once real keys are written into it, but
		--- that has not been isolated. So the note under the button tells the player to
		--- follow up with step 2 rather than pretending one click settles it, and no
		--- theory has been coded in. `LoadBindings` sat here briefly on the reasoning
		--- that switching and saving are different verbs; it was removed again because
		--- untested code that rewrites somebody's keybindings is not worth a hunch. The
		--- probe records whether that function exists, for when this is worth finishing.
		pcall(SaveBindings, 2)

		--- ⚠️ Ask again a moment later, not immediately.
		---
		--- Measured on the PTR: after Rob pressed this, `ns.db.bindingSetProbe` came back
		--- `raw = 2`, so the switch worked — but the panel still read "account-wide" and
		--- the button stayed enabled. The read straight after `SaveBindings` is too early;
		--- the client has not finished with it yet. A verification that runs before the
		--- thing it verifies is worse than none, because it reports a false failure.
		local function verify()
			local now = ns.Keybind_BindingSet and ns.Keybind_BindingSet()
			if now == "character" then
				print(Prefix() .. " " .. ns:L("MH_SETUP_CHARSET_DONE"))
			else
				print(Prefix() .. " " .. (ns:L("MH_SETUP_CHARSET_FAIL")):format(
					tostring(now or "?")))
			end
			if panel and panel.Refresh then
				panel:Refresh()
			end
		end
		if C_Timer and C_Timer.After then
			C_Timer.After(0.5, verify)
		else
			verify()
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

	--- The thumb-pad keys, for the mice that send numbers instead of mouse buttons.
	---
	--- Rob's Naga sends 6 7 8 9 0 - and he keeps them on bar 8 permanently. Doing that
	--- by hand in Blizzard's keybinding screen on every character is exactly the chore
	--- this panel exists to remove. Two presses, like the destructive ones: the first
	--- prints what would move, the second moves it.
	Row(MakeArmedButton(f, ns:L("MH_SETUP_BTN_PADKEYS"), ns:L("MH_SETUP_CONFIRM"),
		function()
			if ns.MH_PadKeysApply then
				ns.MH_PadKeysApply(true)
			end
		end,
		function()
			-- First press: print what the second one would move.
			if ns.MH_PadKeysApply then
				ns.MH_PadKeysApply(false)
			end
		end), ns:L("MH_SETUP_NOTE_PADKEYS"))

	--- Blizzard's own Quick Keybind Mode, next to our button rather than three menus
	--- away. Ours handles the six keys it knows; everything else is bound by hovering
	--- and pressing, which is faster than any list we could draw.
	Row(MakeButton(f, ns:L("MH_SETUP_BTN_QUICKBIND"), function()
		if ns.MH_OpenQuickKeybind then
			ns.MH_OpenQuickKeybind()
		end
	end), ns:L("MH_SETUP_NOTE_QUICKBIND"))

	--- The bars themselves, which the panel could describe but never hand over.
	---
	--- Rob went looking for the export string here first, which is the right instinct
	--- and it was not here — it lived behind `/mh editmode export`, a command you have
	--- to know exists. The panel is where somebody is already standing when they wonder
	--- about their bars.
	Row(MakeButton(f, ns:L("MH_SETUP_BTN_PRESET"), function()
		if ns.MH_ApplyBarPreset then
			ns.MH_ApplyBarPreset(false)
		end
	end), ns:L("MH_SETUP_NOTE_PRESET"))

	--- ⚠️ TWO UNDOS, AND THEY ARE NOT THE SAME UNDO.
	---
	--- The panel already had a button called "Undo" — it reverses the last spell/key
	--- action. Applying the bar preset is a different kind of change, and its way back
	--- is `/mh editmode restore`, a command that appeared nowhere on screen. Rob asked
	--- for exactly this: if it does not suit you, there has to be a button.
	---
	--- So the bar undo sits directly under the bar preset, where somebody who just
	--- pressed one looks for the other. Both keep their own wording so nobody has to
	--- guess which of the two they are pressing.
	Row(MakeButton(f, ns:L("MH_SETUP_BTN_BARSBACK"), function()
		if ns.MH_EditModeRestore then
			ns.MH_EditModeRestore()
		end
	end), ns:L("MH_SETUP_NOTE_BARSBACK"))

	Row(MakeButton(f, ns:L("MH_SETUP_BTN_EXPORT"), function()
		if ns.MH_EditModeExport then
			ns.MH_EditModeExport()
		end
	end), ns:L("MH_SETUP_NOTE_EXPORT"))

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
