local _, ns = ...

--[[
	Midnight Helper — actually set the keys (`/mh apply`).

	Until now the addon drew a plan and the player transcribed it by hand. Rob asked
	why we would not just place them, and the honest answer was: no reason, only
	caution. Every comparable addon on his disk closes the loop — KeyUI, OPie,
	EllesmereUI, ConsolePort. `SetBinding` is not protected.

	WHAT IT DOES. For every key in the live auto-map it finds the action bar slot that
	already holds that spell and binds the key to that slot's command. It does NOT move
	anything on your bars — that is a separate, more invasive step, and it comes later.
	A spell that is not on any bar is reported, not guessed at.

	SAFETY, IN THE ORDER IT HAPPENS:
	  1. Nothing at all in combat.
	  2. `/mh apply` on its own only PRINTS what it would do. Applying takes
	     `/mh apply go`, typed deliberately.
	  3. Before the first change, the current binding of every key we are about to
	     touch is written to SavedVariables — including keys that were bound to
	     nothing, so restoring can clear them again.
	  4. `/mh apply undo` puts every one of them back exactly as it was.

	The snapshot is per-key rather than the whole binding set: it is precisely what we
	disturbed, so undo cannot have side effects on bindings we never touched.

	⚠️ SLOT NUMBERS ARE THE GAME'S, NOT OURS. Action bar 1 is slots 1-12, and the other
	bars sit at fixed offsets. Cross-checked against KeyUI/Mappings.lua:85, which maps
	the same binding names to the same numbers.
]]

--- Binding command -> first action slot. The rest of each bar follows by +1.
local BAR_COMMANDS = {
	{ prefix = "ACTIONBUTTON",           first = 1 },
	{ prefix = "MULTIACTIONBAR1BUTTON",  first = 61 },
	{ prefix = "MULTIACTIONBAR2BUTTON",  first = 49 },
	{ prefix = "MULTIACTIONBAR3BUTTON",  first = 25 },
	{ prefix = "MULTIACTIONBAR4BUTTON",  first = 37 },
	{ prefix = "MULTIACTIONBAR5BUTTON",  first = 145 },
	{ prefix = "MULTIACTIONBAR6BUTTON",  first = 157 },
	{ prefix = "MULTIACTIONBAR7BUTTON",  first = 169 },
}

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

--- Which binding command drives this action slot?
local function CommandForSlot(slot)
	for i = 1, #BAR_COMMANDS do
		local bar = BAR_COMMANDS[i]
		local n = slot - bar.first
		if n >= 0 and n < 12 then
			return bar.prefix .. (n + 1)
		end
	end
	return nil
end

--- Our bind keys read "Shift+1"; WoW's binding system wants "SHIFT-1".
local function ToWowKey(bindKey)
	if not ns.Keybind_ParseBindKey then
		return bindKey
	end
	local mod, base = ns.Keybind_ParseBindKey(bindKey)
	if not base then
		return nil
	end
	if not mod then
		return base
	end
	return string.upper(mod) .. "-" .. base
end

--- The action slot that already holds this spell, following talent overrides.
---
--- Both ids are checked because a replaced spell sits on the bar under whichever the
--- game feels like reporting — Ice Block and Ice Cold are the same button.
local function SlotHoldingSpell(spellID)
	if not (spellID and GetActionInfo) then
		return nil
	end
	local override
	if C_SpellBook and C_SpellBook.FindSpellOverrideByID then
		local ok, o = pcall(C_SpellBook.FindSpellOverrideByID, spellID)
		if ok and type(o) == "number" and o ~= 0 then
			override = o
		end
	end
	for slot = 1, 180 do
		local ok, kind, id = pcall(GetActionInfo, slot)
		if ok and kind == "spell" and id then
			if id == spellID or (override and id == override) then
				return slot
			end
		end
	end
	return nil
end

--- @return table plan  { {key, wowKey, command, slot, name} }, table missing {names}
local function BuildPlan()
	local plan, missing = {}, {}
	if not ns.MH_AutoMapSpecAndSlots then
		return plan, missing
	end
	local spec = ns.MH_AutoMapSpecAndSlots()
	if not (spec and spec.spellByUiKey) then
		return plan, missing
	end
	local NameFor = function(id)
		if C_Spell and C_Spell.GetSpellName then
			local ok, n = pcall(C_Spell.GetSpellName, id)
			if ok and n then
				return n
			end
		end
		return tostring(id)
	end
	for bindKey, entry in pairs(spec.spellByUiKey) do
		if entry and entry.id then
			local wowKey = ToWowKey(bindKey)
			local slot = SlotHoldingSpell(entry.id)
			local command = slot and CommandForSlot(slot)
			if wowKey and command then
				plan[#plan + 1] = {
					key = bindKey,
					wowKey = wowKey,
					command = command,
					slot = slot,
					name = NameFor(entry.id),
				}
			else
				missing[#missing + 1] = NameFor(entry.id) .. (slot and " (slot " .. slot .. ", no command)" or " (not on any bar)")
			end
		end
	end
	table.sort(plan, function(a, b)
		return ns.Keybind_CompareBindKeys(a.key, b.key)
	end)
	table.sort(missing)
	return plan, missing
end

--- `/mh apply` — say what would change. `/mh apply go` — do it. `/mh apply undo` — put it back.
function ns.MH_ApplyLayout(arg)
	ns.db = ns.db or {}

	if arg == "undo" then
		local snap = ns.db.bindSnapshot
		if type(snap) ~= "table" or #snap == 0 then
			print(Prefix() .. " nothing to undo — no snapshot saved.")
			return
		end
		if InCombatLockdown and InCombatLockdown() then
			print(Prefix() .. " not in combat.")
			return
		end
		local n = 0
		for i = 1, #snap do
			local row = snap[i]
			if row and row.key then
				-- An empty `was` means the key held nothing; clearing restores that.
				if row.was and row.was ~= "" then
					SetBinding(row.key, row.was)
				else
					SetBinding(row.key)
				end
				n = n + 1
			end
		end
		if SaveBindings and GetCurrentBindingSet then
			pcall(SaveBindings, GetCurrentBindingSet())
		end
		ns.db.bindSnapshot = nil
		print(("%s undone — %d key(s) put back the way they were."):format(Prefix(), n))
		return
	end

	local plan, missing = BuildPlan()
	if #plan == 0 and #missing == 0 then
		print(Prefix() .. " no layout to apply — run |cffffffff/mhautomap|r first.")
		return
	end

	if arg ~= "go" then
		print(("%s this would set |cffffffff%d|r key(s):"):format(Prefix(), #plan))
		for i = 1, #plan do
			local p = plan[i]
			local now = GetBindingAction and GetBindingAction(p.wowKey) or ""
			local note = (now ~= "" and now ~= p.command) and (" |cffff9900(replaces " .. now .. ")|r") or ""
			print(("   |cffffd100%-10s|r %-24s -> %s%s"):format(p.wowKey, p.name, p.command, note))
		end
		if #missing > 0 then
			print(("   |cffff9900%d not on a bar, so they cannot be bound:|r %s"):format(
				#missing, table.concat(missing, ", ")))
		end
		print("   |cff9d9d9dNothing has changed. |cffffffff/mh apply go|r to do it, |cffffffff/mh apply undo|r afterwards.|r")
		return
	end

	if InCombatLockdown and InCombatLockdown() then
		print(Prefix() .. " not in combat.")
		return
	end
	if not (SetBinding and GetBindingAction) then
		print(Prefix() .. " this client does not expose the binding API.")
		return
	end

	-- Snapshot FIRST, and only the keys we are about to disturb.
	local snap = {}
	for i = 1, #plan do
		local p = plan[i]
		snap[#snap + 1] = { key = p.wowKey, was = GetBindingAction(p.wowKey) or "" }
	end
	ns.db.bindSnapshot = snap

	local done, failed = 0, 0
	for i = 1, #plan do
		local p = plan[i]
		local ok = pcall(SetBinding, p.wowKey, p.command)
		if ok then
			done = done + 1
		else
			failed = failed + 1
		end
	end
	if SaveBindings and GetCurrentBindingSet then
		pcall(SaveBindings, GetCurrentBindingSet())
	end

	print(("%s applied — |cffffffff%d|r key(s) set%s."):format(
		Prefix(), done, failed > 0 and (", " .. failed .. " failed") or ""))
	print("   |cff9d9d9dNot what you wanted? |cffffffff/mh apply undo|r puts every one of them back.|r")
	if #missing > 0 then
		print(("   |cffff9900%d could not be bound (not on a bar):|r %s"):format(
			#missing, table.concat(missing, ", ")))
	end
end
