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

local BAR8_PREFIX = "MULTIACTIONBAR7BUTTON"
local BAR8_BUTTONS = 12

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

local function CommandFor(index)
	return BAR8_PREFIX .. tostring(index)
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
	return command, command:find(BAR8_PREFIX, 1, true) == 1
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

	local todo, already = {}, 0
	for _, key in ipairs(PAD_KEYS) do
		local command, isBar8 = Current(key)
		if isBar8 then
			already = already + 1
		else
			todo[#todo + 1] = { key = key, was = command }
		end
	end

	if #todo == 0 then
		print(("%s %s"):format(Prefix(), (ns:L("PADKEYS_ALL_SET")):format(already)))
		return
	end

	local free = FreeButtons()
	if #free < #todo then
		print(("%s %s"):format(Prefix(), (ns:L("PADKEYS_NO_ROOM")):format(#free, #todo)))
		return
	end

	if not confirmed then
		print(("%s %s"):format(Prefix(), (ns:L("PADKEYS_PLAN")):format(#todo)))
		for i, row in ipairs(todo) do
			print(("   |cffffd100%-3s|r -> %s%s"):format(
				row.key, free[i],
				row.was and ("   |cff9d9d9d(" .. ns:L("PADKEYS_WAS") .. " " .. row.was .. ")|r") or ""))
		end
		print("   |cff9d9d9d" .. ns:L("PADKEYS_PLAN_GO") .. "|r")
		return
	end

	--- Same snapshot slot `/mh apply undo` uses, so one undo covers this too rather
	--- than leaving a second kind of change with its own way back.
	local snap = {}
	local done = 0
	for i, row in ipairs(todo) do
		snap[#snap + 1] = { key = row.key, was = row.was or "" }
		if pcall(SetBinding, row.key, free[i]) then
			done = done + 1
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
