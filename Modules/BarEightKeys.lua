local _, ns = ...

--[[
	Midnight Helper — put the thumb-pad keys on bar 8, from the setup panel.

	Rob's Naga sends the number keys 6 7 8 9 0 - rather than BUTTON4..BUTTON9, which the
	schema already notes is a thing a Naga can be configured to do. For the game they are
	ordinary keys; that they are his thumb is something only he knows. He keeps them on
	action bar 8 permanently and asked (11 Aug 2026) not to have to redo that in
	Blizzard's keybinding screen on every character.

	⚠️ OPT-IN, AND IT SAYS WHY. Most players do not have six thumb buttons — that is the
	rule this project had to be told twice (see the schema's own warning about assuming
	an MMO mouse). So nothing here runs on its own or during `/mh apply`; it is a button
	somebody presses because they recognise their own hardware in the description.

	⚠️ IT DOES NOT TIDY. If a key already points at bar 8 it is left exactly where it is,
	even when the order looks untidy — measured on Rob's Hunter, his six sit on buttons
	9, 10, 5, 6, 1 and 2 rather than 1-6, and every one of them has a spell under it that
	his hands already know. Renumbering them would be correct-looking and wrong. Only
	keys that are somewhere else, or nowhere, get placed.

	Bar 8 is `MULTIACTIONBAR7BUTTON*`, slots 169-180 — confirmed against Edit Mode's own
	label on 11 Aug. Three numbering schemes name this bar and only these two were known
	to agree until Rob checked the third.
]]

--- The keys, in the order the thumb pad has them.
local PAD_KEYS = { "6", "7", "8", "9", "0", "-" }

--- ⚠️ THE ORDER IS THE POINT, and I had it backwards.
---
--- First version placed a loose key in the lowest free button; second version put it
--- back where it had been. Rob then showed what he actually wants, which is neither:
--- 6 7 on the top row, 8 9 in the middle, 0 - at the bottom — the pad read the way the
--- thumb moves. His bar happened to hold them in the opposite order, so "leave what is
--- there" was protecting the arrangement he wanted changed.
---
--- ⚠️ A MULTI-ROW BAR NUMBERS FROM THE BOTTOM UP. Measured, not reasoned: buttons 1-2
--- were placed and landed on the BOTTOM row of Rob's three, so 6 and 7 ended up under
--- his thumb's last position instead of its first. Reading order and button order run
--- opposite on this bar.
---
--- So the rows are walked in reverse: 9-10 is the top pair, 5-6 the middle, 1-2 the
--- bottom. That puts 6 7 / 8 9 / 0 - down the pad the way the thumb travels.
---
--- ⚠️ A DEFAULT, NOT A LAW. Somebody with one row of 12 wants 1-6 instead. The plan is
--- printed before anything moves, so a layout this does not suit is visible rather than
--- discovered afterwards — and `/mh apply undo` puts it back.
local HOME_BUTTONS = { 9, 10, 5, 6, 1, 2 }

local BAR8_PREFIX = "MULTIACTIONBAR7BUTTON"
local BAR8_BUTTONS = 12

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

local function CommandFor(index)
	return BAR8_PREFIX .. tostring(index)
end

--- ⚠️ REMEMBER WHERE EACH KEY LIVES, because "a free button" is not "your button".
---
--- First version put a missing key into the lowest free button on bar 8. Rob unbound 6
--- and 7 — which sat on buttons 9 and 10 — and got them back on 3 and 4, because those
--- were free first. Tidy, and wrong: the spell under button 9 had not moved, so his
--- thumb now pressed something else.
---
--- So MH writes down where a pad key is whenever it sees one on bar 8, and puts it back
--- there. The player's arrangement is the arrangement; the lowest free button is only
--- the fallback for a key that has never been placed.
local function HomeStore()
	if not ns.db then
		return nil
	end
	ns.db.padKeyHome = ns.db.padKeyHome or {}
	return ns.db.padKeyHome
end

--- Where a key currently points: the command, and whether that command is on bar 8.
local function Current(key)
	if not GetBindingAction then
		return nil, false
	end
	local ok, command = pcall(GetBindingAction, key)
	if not ok or type(command) ~= "string" or command == "" then
		return nil, false
	end
	local onBar8 = command:find(BAR8_PREFIX, 1, true) == 1
	if onBar8 then
		-- Seen in place: this is its home from now on.
		local store = HomeStore()
		if store then
			store[key] = command
		end
	end
	return command, onBar8
end

--- Buttons on bar 8 that no key points at yet.
local function FreeButtons()
	local taken = {}
	for _, key in ipairs(PAD_KEYS) do
		local command = Current(key)
		if command then
			taken[command] = true
		end
	end
	-- Anything else bound to bar 8 counts as taken too, whoever bound it.
	if GetNumBindings and GetBinding then
		for i = 1, (GetNumBindings() or 0) do
			local okB, command, _, k1, k2 = pcall(GetBinding, i)
			if okB and type(command) == "string" and command:find(BAR8_PREFIX, 1, true) == 1 then
				if (k1 and k1 ~= "") or (k2 and k2 ~= "") then
					taken[command] = true
				end
			end
		end
	end
	local free = {}
	for i = 1, BAR8_BUTTONS do
		local c = CommandFor(i)
		if not taken[c] then
			free[#free + 1] = c
		end
	end
	return free
end

--- Open Blizzard's Quick Keybind Mode — hover a button, press a key, done.
---
--- Rob asked for this next to the pad-key button, and the pairing is the point: our
--- button handles the six keys it knows about, and anything else you want to bind by
--- hand is one click away instead of a menu hunt. Quick Keybind is also where the
--- "Character Specific Keybindings" tick lives, which is the setting that caused a
--- whole afternoon of confusion today.
---
--- ⚠️ THE ENTRY POINT IS ASKED FOR, NOT ASSUMED. `QuickKeybindFrame` is a Blizzard
--- global that may or may not be loaded, and its show method has moved before. Each
--- candidate is checked before use and the fallback is the ordinary keybindings panel;
--- if none exist the player is told rather than left clicking a dead button.
function ns.MH_OpenQuickKeybind()
	if InCombatLockdown and InCombatLockdown() then
		print(Prefix() .. " " .. ns:L("PADKEYS_COMBAT"))
		return
	end

	local f = _G.QuickKeybindFrame
	if f then
		-- Blizzard's own entry point when it exists; Show() otherwise.
		if type(f.OnQuickKeybindModeEnter) == "function" and pcall(f.OnQuickKeybindModeEnter, f) then
			return
		end
		if type(f.Show) == "function" and pcall(f.Show, f) then
			return
		end
	end

	--- Fall back to the plain keybindings panel. Two possible routes depending on how
	--- this client organises Settings; try both before giving up.
	if _G.Settings and _G.Settings.OpenToCategory then
		local ok = pcall(_G.Settings.OpenToCategory, "Keybindings")
		if ok then
			return
		end
	end
	if _G.KeyBindingFrame_LoadUI then
		pcall(_G.KeyBindingFrame_LoadUI)
	end
	if _G.KeyBindingFrame and type(_G.KeyBindingFrame.Show) == "function" then
		if pcall(_G.KeyBindingFrame.Show, _G.KeyBindingFrame) then
			return
		end
	end
	print(Prefix() .. " " .. ns:L("PADKEYS_NO_QUICKBIND"))
end

--- `/mh padkeys` — say where the six keys point, without changing anything.
function ns.MH_PadKeysReport()
	print(("%s %s"):format(Prefix(), ns:L("PADKEYS_REPORT_HEAD")))
	local onBar8 = 0
	for _, key in ipairs(PAD_KEYS) do
		local command, isBar8 = Current(key)
		if isBar8 then
			onBar8 = onBar8 + 1
		end
		print(("   |cffffd100%-3s|r %s"):format(
			key,
			command and ((isBar8 and "|cff40c040" or "|cff9d9d9d") .. command .. "|r")
				or ("|cff9d9d9d" .. ns:L("PADKEYS_UNBOUND") .. "|r")))
	end
	print(("   %s"):format((ns:L("PADKEYS_SUMMARY")):format(onBar8, #PAD_KEYS)))
end

--- Put the ones that are not on bar 8 there. Leaves the rest alone.
--- @param confirmed boolean  false prints the plan, true performs it
function ns.MH_PadKeysApply(confirmed)
	if InCombatLockdown and InCombatLockdown() then
		print(Prefix() .. " " .. ns:L("PADKEYS_COMBAT"))
		return
	end
	if not (SetBinding and SaveBindings) then
		return
	end

	--- Every key gets its ordered home; only the ones already there are left alone.
	--- "On bar 8 somewhere" is not good enough — being on the wrong button of the right
	--- bar is exactly the state Rob is trying to fix.
	local todo, already = {}, 0
	for i, key in ipairs(PAD_KEYS) do
		local want = CommandFor(HOME_BUTTONS[i] or i)
		local command = Current(key)
		if command == want then
			already = already + 1
		else
			todo[#todo + 1] = { key = key, was = command, target = want }
		end
	end

	if #todo == 0 then
		print(("%s %s"):format(Prefix(), (ns:L("PADKEYS_ALL_SET")):format(already)))
		return
	end

	--- ⚠️ Another pad key may be sitting on the button this one wants. That is normal
	--- when the whole set is being reordered — all six are rebound in one pass, so a
	--- collision between two of them resolves itself. Only a NON-pad binding in the way
	--- is a real obstruction, and it is named rather than quietly overwritten.
	local padKey = {}
	for _, k in ipairs(PAD_KEYS) do
		padKey[k] = true
	end
	local blocked = {}
	if GetNumBindings and GetBinding then
		local wanted = {}
		for _, row in ipairs(todo) do
			wanted[row.target] = row.key
		end
		for i = 1, (GetNumBindings() or 0) do
			local okB, command, _, k1, k2 = pcall(GetBinding, i)
			if okB and wanted[command] then
				for _, k in ipairs({ k1, k2 }) do
					if k and k ~= "" and not padKey[k] then
						blocked[#blocked + 1] = ("%s (%s)"):format(command, k)
					end
				end
			end
		end
	end

	if not confirmed then
		print(("%s %s"):format(Prefix(), (ns:L("PADKEYS_PLAN")):format(#todo)))
		for _, row in ipairs(todo) do
			print(("   |cffffd100%-3s|r -> %s%s"):format(
				row.key, row.target,
				row.was and ("   |cff9d9d9d(" .. ns:L("PADKEYS_WAS") .. " " .. row.was .. ")|r") or ""))
		end
		for _, b in ipairs(blocked) do
			print("   |cffff9900" .. (ns:L("PADKEYS_BLOCKED")):format(b) .. "|r")
		end
		print("   |cff9d9d9d" .. ns:L("PADKEYS_PLAN_GO") .. "|r")
		return
	end

	--- Same snapshot slot `/mh apply undo` uses, so one undo covers this too rather
	--- than leaving a second kind of change with its own way back.
	local snap = {}
	local done = 0
	for _, row in ipairs(todo) do
		snap[#snap + 1] = { key = row.key, was = row.was or "" }
		if row.target and pcall(SetBinding, row.key, row.target) then
			done = done + 1
			-- Placed on purpose: that button is now this key's home.
			local s = HomeStore()
			if s then
				s[row.key] = row.target
			end
		end
	end
	if GetCurrentBindingSet then
		pcall(SaveBindings, GetCurrentBindingSet())
	end
	ns.db = ns.db or {}
	ns.db.bindSnapshot = snap

	print(("%s %s"):format(Prefix(), (ns:L("PADKEYS_DONE")):format(done)))
	print("   |cff9d9d9d" .. ns:L("PADKEYS_UNDO") .. "|r")
end
