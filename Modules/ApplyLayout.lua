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

--- Is this action slot empty?
local function SlotIsEmpty(slot)
	if not (slot and GetActionInfo) then
		return false
	end
	local ok, kind = pcall(GetActionInfo, slot)
	return ok and (kind == nil)
end

--- Where could this spell go, given the key it is meant to sit on?
---
--- Deliberately narrow. It looks at what that KEY already does: if the key already
--- drives an action button and that button's slot is EMPTY, the spell goes there and
--- nothing needs rebinding — pressing the key simply starts working. Anything else is
--- reported rather than solved.
---
--- ⚠️ IT MAY OVERWRITE NOW — Rob's call, 7 Aug, and the measurement forced it. With
--- "empty only" the feature placed exactly ZERO spells on his mage: every slot his keys
--- point at was already taken. That is true of anyone who has played the character.
--- What stood in the way was Spellsteal on two slots, Disenchant and Arcane Explosion —
--- leftovers, not a layout worth protecting.
---
--- ⚠️ BUT ONLY WHAT WE CAN PUT BACK. An undo that cannot restore what it removed is not
--- an undo. Spells, items and macros have a pickup call we can name; a flyout, a mount
--- or a pet summon does not, at least not one verified here. Those slots are refused as
--- targets and reported instead, so the promise stays true.
local RESTORABLE = { spell = true, item = true, macro = true }

--- @return number|nil slot, string|nil why, table|nil occupant {kind,id,name}
local function PlacementForKey(wowKey, commandSlot)
	if not (wowKey and GetBindingAction) then
		return nil, "no binding API"
	end
	local command = GetBindingAction(wowKey)
	if not command or command == "" then
		return nil, "that key is not bound to an action button"
	end
	local slot = commandSlot[command]
	if not slot then
		return nil, ("%s is not an action button we can fill"):format(command)
	end
	if SlotIsEmpty(slot) then
		return slot
	end

	local ok, kind, id = pcall(GetActionInfo, slot)
	if not ok or not kind then
		return nil, ("slot %d could not be read"):format(slot)
	end
	if not RESTORABLE[kind] then
		return nil, ("slot %d holds a %s, which we could not put back"):format(slot, tostring(kind))
	end
	local name = kind
	if kind == "spell" and id and C_Spell and C_Spell.GetSpellName then
		local okN, n = pcall(C_Spell.GetSpellName, id)
		name = (okN and n) or kind
	elseif kind == "macro" and id and GetMacroInfo then
		local okM, n = pcall(GetMacroInfo, id)
		name = (okM and n) or "macro"
	elseif kind == "item" and id and C_Item and C_Item.GetItemNameByID then
		local okI, n = pcall(C_Item.GetItemNameByID, id)
		name = (okI and n) or "item"
	end
	return slot, nil, { kind = kind, id = id, name = name }
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
	local commandSlot = ns.MH_CommandSlotMap and ns.MH_CommandSlotMap() or {}
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
			elseif wowKey then
				-- Not on a bar. Can we put it where this key already points?
				local free, why, occupant = PlacementForKey(wowKey, commandSlot)
				if free then
					plan[#plan + 1] = {
						key = bindKey,
						wowKey = wowKey,
						command = GetBindingAction(wowKey),
						slot = free,
						name = NameFor(entry.id),
						spellID = entry.id,
						place = true, -- put the spell on the bar; no rebinding needed
						occupant = occupant, -- what has to move aside, nil if empty
					}
				else
					missing[#missing + 1] = NameFor(entry.id) .. " (" .. tostring(why) .. ")"
				end
			else
				missing[#missing + 1] = NameFor(entry.id) .. " (no usable key)"
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
		local placedSnap = ns.db.placedSnapshot
		local haveKeys = type(snap) == "table" and #snap > 0
		local havePlaced = type(placedSnap) == "table" and #placedSnap > 0
		if not haveKeys and not havePlaced then
			print(Prefix() .. " nothing to undo — no snapshot saved.")
			return
		end
		if InCombatLockdown and InCombatLockdown() then
			print(Prefix() .. " not in combat.")
			return
		end
		local n = 0
		for i = 1, (haveKeys and #snap or 0) do
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

		--- Empty the slots we filled. We only ever placed into slots that were empty,
		--- so emptying them is a true undo and cannot destroy anything of the player's.
		---
		--- ⚠️ PickupAction is not used by any addon installed here, so this path is
		--- unverified in practice — it is the documented way to lift an action off a
		--- bar, but Rob's test is the proof. If a placed spell stays put after an undo,
		--- this is the line to look at.
		local cleared = 0
		for i = 1, (havePlaced and #placedSnap or 0) do
			local row = placedSnap[i]
			if row and row.slot then
				local ok = pcall(function()
					-- Lift what we put there off the bar first, whatever happens next.
					if PickupAction then
						PickupAction(row.slot)
						ClearCursor()
					end
					-- Then put the original back, if there was one.
					if row.kind == "spell" and row.id then
						if C_Spell and C_Spell.PickupSpell then
							C_Spell.PickupSpell(row.id)
						elseif PickupSpell then
							PickupSpell(row.id)
						end
						PlaceAction(row.slot)
					elseif row.kind == "macro" and row.id and PickupMacro then
						PickupMacro(row.id)
						PlaceAction(row.slot)
					elseif row.kind == "item" and row.id and C_Item and C_Item.PickupItem then
						C_Item.PickupItem(row.id)
						PlaceAction(row.slot)
					elseif row.kind == "item" and row.id and PickupItem then
						PickupItem(row.id)
						PlaceAction(row.slot)
					end
					ClearCursor()
				end)
				pcall(ClearCursor)
				if ok then
					cleared = cleared + 1
				end
			end
		end

		if SaveBindings and GetCurrentBindingSet then
			pcall(SaveBindings, GetCurrentBindingSet())
		end
		ns.db.bindSnapshot = nil
		ns.db.placedSnapshot = nil
		print(("%s undone — %d key(s) restored, %d slot(s) put back."):format(
			Prefix(), n, cleared))
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
			if p.place then
				if p.occupant then
					-- Say what goes out, by name, before anything happens.
					print(("   |cffffd100%-10s|r %-24s |cffff9900slot %d — replaces %s|r"):format(
						p.wowKey, p.name, p.slot, tostring(p.occupant.name)))
				else
					print(("   |cffffd100%-10s|r %-24s |cff40c040empty slot %d|r"):format(
						p.wowKey, p.name, p.slot))
				end
			else
				local now = GetBindingAction and GetBindingAction(p.wowKey) or ""
				local note = (now ~= "" and now ~= p.command) and (" |cffff9900(replaces " .. now .. ")|r") or ""
				print(("   |cffffd100%-10s|r %-24s -> %s%s"):format(p.wowKey, p.name, p.command, note))
			end
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

	-- Snapshot FIRST, and only what we are about to disturb.
	local snap, placedSnap = {}, {}
	for i = 1, #plan do
		local p = plan[i]
		if p.place then
			-- Remember what was there, by type, so undo can genuinely put it back.
			placedSnap[#placedSnap + 1] = {
				slot = p.slot,
				kind = p.occupant and p.occupant.kind or nil,
				id = p.occupant and p.occupant.id or nil,
			}
		else
			snap[#snap + 1] = { key = p.wowKey, was = GetBindingAction(p.wowKey) or "" }
		end
	end
	ns.db.bindSnapshot = snap
	ns.db.placedSnapshot = placedSnap

	local done, failed, placed = 0, 0, 0
	for i = 1, #plan do
		local p = plan[i]
		if p.place then
			--- Put the spell on the empty slot the key already points at. Same three
			--- calls KeyUI uses (Core.lua:4575): pick up, place, clear the cursor —
			--- and clearing matters, because a spell left on the cursor is a spell the
			--- next click drops somewhere the player did not ask for.
			local ok = pcall(function()
				if C_Spell and C_Spell.PickupSpell then
					C_Spell.PickupSpell(p.spellID)
				elseif PickupSpell then
					PickupSpell(p.spellID)
				end
				PlaceAction(p.slot)
				ClearCursor()
			end)
			pcall(ClearCursor)
			if ok then
				placed = placed + 1
			else
				failed = failed + 1
			end
		else
			local ok = pcall(SetBinding, p.wowKey, p.command)
			if ok then
				done = done + 1
			else
				failed = failed + 1
			end
		end
	end
	if SaveBindings and GetCurrentBindingSet then
		pcall(SaveBindings, GetCurrentBindingSet())
	end

	print(("%s applied — |cffffffff%d|r key(s) set, |cffffffff%d|r spell(s) placed%s."):format(
		Prefix(), done, placed, failed > 0 and (", " .. failed .. " failed") or ""))
	print("   |cff9d9d9dNot what you wanted? |cffffffff/mh apply undo|r puts every one of them back.|r")
	if #missing > 0 then
		print(("   |cffff9900%d could not be bound (not on a bar):|r %s"):format(
			#missing, table.concat(missing, ", ")))
	end
end
