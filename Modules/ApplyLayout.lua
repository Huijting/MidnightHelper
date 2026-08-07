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
--- @param driveable table|nil  set of slots some binding command actually drives
---
--- ⚠️ PREFER A SLOT A KEY CAN REACH. Frozen Orb sat on Rob's bars twice: slot 121, on
--- the skyriding bar that no binding command drives, and slot 146, which one does. The
--- scan ran low to high, "found" it on 121, and reserved that — leaving the usable copy
--- on 146 unprotected, so the very next placement proposed writing Frostbolt over it
--- and then reported Frozen Orb as unplaceable. Reserving the copy nobody can press is
--- the same as reserving nothing.
local function SlotHoldingSpell(spellID, driveable)
	if not (spellID and GetActionInfo) then
		return nil
	end
	local fallback
	local override
	if C_SpellBook and C_SpellBook.FindSpellOverrideByID then
		local ok, o = pcall(C_SpellBook.FindSpellOverrideByID, spellID)
		if ok and type(o) == "number" and o ~= 0 then
			override = o
		end
	end
	for slot = 1, 180 do
		local ok, kind, id = pcall(GetActionInfo, slot)
		--- ⚠️ MACROS COUNT TOO. Rob's Counterspell, Remove Curse and Ice Block were all
		--- reported as "not on any bar" while sitting on his bars inside macros. The
		--- undo test showed why: a macro action reports ids 2139, 475 and 414658 —
		--- which are the spell ids of exactly those three. So for a macro the id we get
		--- is the spell it casts, and ignoring that made us offer to place a spell the
		--- player already had a button for.
		---
		--- Observed on one client rather than documented, so it only ever ADDS a match;
		--- if it is wrong somewhere the worst case is that we think a spell is placed
		--- when it is not, and say so, rather than moving anything.
		if ok and (kind == "spell" or kind == "macro") and id then
			if id == spellID or (override and id == override) then
				if not driveable or driveable[slot] then
					return slot
				end
				fallback = fallback or slot
			end
		end
	end
	return fallback
end

--- The action slot that already holds this item, so a potion already on a bar is left
--- where the player put it rather than duplicated somewhere else.
local function SlotHoldingItem(itemID)
	if not (itemID and GetActionInfo) then
		return nil
	end
	for slot = 1, 180 do
		local ok, kind, id = pcall(GetActionInfo, slot)
		if ok and kind == "item" and id == itemID then
			return slot
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
--- ⚠️ MACROS ARE OUT — proven, not feared. Rob applied and undid on 7 Aug: six of the
--- seven slots came back exactly, and the macro on slot 42 did not. We recorded its id
--- as 2139 and handed that to PickupMacro, which expects a macro INDEX; 2139 is
--- Counterspell's spell id. So for a macro action the second return of GetActionInfo is
--- not the index we need, and until something can restore one reliably a macro slot is
--- not a legitimate target. Losing somebody's macro is not a trade we get to make.
local RESTORABLE = { spell = true, item = true }

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
	local alreadyOk = 0
	if not ns.MH_AutoMapSpecAndSlots then
		return plan, missing, 0
	end
	local spec = ns.MH_AutoMapSpecAndSlots()
	if not (spec and spec.spellByUiKey) then
		return plan, missing, 0
	end
	--- ⚠️ FOLLOW THE OVERRIDE — third place this had to be fixed. The plan showed Blink,
	--- Invisibility and Ice Block while Rob's bars say Shimmer, Greater Invisibility and
	--- Ice Cold. We hold BASE ids because that is what the role data matches on, but the
	--- name a player reads has to be the one under their thumb; a plan naming a button
	--- that is not on the bar is the Alt+M fault again. Already corrected in
	--- KeybindAutoMap's NameForId and the layout's ProtoSpellName; this copy was missed.
	local NameFor = function(id)
		if not id then
			return "?"
		end
		local display = id
		if C_SpellBook and C_SpellBook.FindSpellOverrideByID then
			local okO, over = pcall(C_SpellBook.FindSpellOverrideByID, id)
			if okO and type(over) == "number" and over ~= 0 then
				display = over
			end
		end
		if C_Spell and C_Spell.GetSpellName then
			local ok, n = pcall(C_Spell.GetSpellName, display)
			if ok and n then
				return n
			end
			if display ~= id then
				local okB, b = pcall(C_Spell.GetSpellName, id)
				if okB and b then
					return b
				end
			end
		end
		return tostring(id)
	end
	local commandSlot = ns.MH_CommandSlotMap and ns.MH_CommandSlotMap() or {}
	local slotCommand = {}
	for command, slot in pairs(commandSlot) do
		slotCommand[slot] = command
	end
	-- Slots some binding command actually drives. A copy of a spell on any other
	-- slot cannot be reached by a key, so it must never win over one that can.
	local driveable = {}
	for _, slot in pairs(commandSlot) do
		driveable[slot] = true
	end

	--- Slots we are allowed to fill, in the order we would rather use them.
	---
	--- Bars 7 and 8 are left alone — Rob's rule, and a sensible default rather than a
	--- fact: somebody may already be using them, so it is a convention we state instead
	--- of an assumption we hide. Everything else is fair game now that undo is proven,
	--- with one ordering rule: empty slots first, so a working layout costs the player
	--- as little of their own arrangement as it can.
	local ALLOWED_BARS = {
		"ACTIONBUTTON", "MULTIACTIONBAR1BUTTON", "MULTIACTIONBAR2BUTTON",
		"MULTIACTIONBAR3BUTTON", "MULTIACTIONBAR4BUTTON", "MULTIACTIONBAR5BUTTON",
	}
	local function CandidateSlots()
		local empty, used = {}, {}
		for _, prefix in ipairs(ALLOWED_BARS) do
			for i = 1, 12 do
				local slot = commandSlot[prefix .. i]
				if slot then
					if SlotIsEmpty(slot) then
						empty[#empty + 1] = slot
					else
						local ok, kind = pcall(GetActionInfo, slot)
						if ok and RESTORABLE[kind] then
							used[#used + 1] = slot
						end
					end
				end
			end
		end
		for i = 1, #used do
			empty[#empty + 1] = used[i]
		end
		return empty
	end
	local candidates = CandidateSlots()
	local taken = {} -- slots this run has already claimed

	local function NextCandidate()
		for i = 1, #candidates do
			local slot = candidates[i]
			if not taken[slot] then
				taken[slot] = true
				return slot
			end
		end
		return nil
	end

	local function OccupantOf(slot)
		local ok, kind, id = pcall(GetActionInfo, slot)
		if not ok or not kind then
			return nil
		end
		local name = kind
		if kind == "spell" and id and C_Spell and C_Spell.GetSpellName then
			local okN, n = pcall(C_Spell.GetSpellName, id)
			name = (okN and n) or kind
		elseif kind == "item" and id and C_Item and C_Item.GetItemNameByID then
			local okI, n = pcall(C_Item.GetItemNameByID, id)
			name = (okI and n) or kind
		end
		return { kind = kind, id = id, name = name }
	end

	--- ⚠️ TWO PASSES, AND THE ORDER IS THE POINT. The first version walked
	--- `spellByUiKey` once with `pairs`, which has no order, so whichever spell reached
	--- a slot first owned it. Rob's plan came out proposing to put Frostbolt on slot
	--- 146 — on top of Frozen Orb — and then reported Frozen Orb as unplaceable,
	--- because its only other copy sits on the skyriding bar where no key can reach it.
	--- Applying that would have cost him a spell the layout itself prescribes.
	---
	--- So everything ALREADY on a bar claims its slot before anything is allowed to
	--- choose one. Same shape as the anchors-before-categories fix in the allocator
	--- yesterday: serve whoever has no alternative first.
	local ordered = {}
	for bindKey, entry in pairs(spec.spellByUiKey) do
		if entry and entry.id then
			ordered[#ordered + 1] = { bindKey = bindKey, entry = entry }
		end
	end
	table.sort(ordered, function(a, b)
		return ns.Keybind_CompareBindKeys(a.bindKey, b.bindKey)
	end)

	-- Pass 1: reserve every slot that already holds one of our spells.
	for _, row in ipairs(ordered) do
		local slot = SlotHoldingSpell(row.entry.id, driveable)
		if slot then
			taken[slot] = true
			row.existingSlot = slot
		end
	end

	-- Pass 2: decide what to do with each.
	for _, row in ipairs(ordered) do
		local bindKey, entry = row.bindKey, row.entry
		do
			local wowKey = ToWowKey(bindKey)
			local slot = row.existingSlot
			local command = slot and (slotCommand[slot] or CommandForSlot(slot))
			if not wowKey then
				missing[#missing + 1] = NameFor(entry.id) .. " (no usable key)"
			elseif command then
				--- Already on a bar somewhere. Point the key at it — unless it already
				--- does, in which case there is nothing to do and we say nothing. A
				--- plan full of no-ops is how a player stops reading the plan.
				if GetBindingAction and GetBindingAction(wowKey) == command then
					-- Nothing to do. Counted, not printed: a plan full of no-ops is how
					-- a player stops reading the plan, but a plan of eight lines for a
					-- layout of nineteen spells reads as if we only thought about eight.
					alreadyOk = alreadyOk + 1
					taken[slot] = true
				else
					plan[#plan + 1] = {
						key = bindKey, wowKey = wowKey, command = command,
						slot = slot, name = NameFor(entry.id),
					}
					taken[slot] = true
				end
			elseif slot then
				missing[#missing + 1] = NameFor(entry.id)
					.. (" (on slot %d, which no action button drives)"):format(slot)
			else
				-- Not on any bar. Put it somewhere we are allowed to, and bind the key.
				local target = PlacementForKey(wowKey, commandSlot)
				if target and not taken[target] then
					taken[target] = true
				else
					target = NextCandidate()
				end
				if target then
					local cmd = slotCommand[target]
					plan[#plan + 1] = {
						key = bindKey, wowKey = wowKey, command = cmd,
						slot = target, name = NameFor(entry.id), spellID = entry.id,
						place = true,
						occupant = OccupantOf(target),
						rebind = (GetBindingAction and GetBindingAction(wowKey) ~= cmd) or false,
					}
				else
					missing[#missing + 1] = NameFor(entry.id) .. " (no free slot on bars 1-6)"
				end
			end
		end
	end
	--- Consumables last, on whatever keys the spells did not want. They are pressed once
	--- or twice a fight, so by the scheme's own frequency rule they have no claim on a
	--- rotation key — and a rebuild that wiped Rob's healing potion and put nothing back
	--- would be a downgrade dressed as a layout.
	if ns.MH_ConsumableLayout then
		local usedKeys = {}
		for bindKey in pairs(spec.spellByUiKey) do
			usedKeys[bindKey] = true
		end
		local okC, consumables = pcall(ns.MH_ConsumableLayout, usedKeys)
		for i = 1, (okC and #consumables or 0) do
			local c = consumables[i]
			local wowKey = ToWowKey(c.key)
			local slot = SlotHoldingItem(c.itemID)
			local command = slot and (slotCommand[slot] or CommandForSlot(slot))
			if slot and command then
				if not (GetBindingAction and GetBindingAction(wowKey) == command) then
					plan[#plan + 1] = {
						key = c.key, wowKey = wowKey, command = command,
						slot = slot, name = c.name,
					}
				else
					alreadyOk = alreadyOk + 1
				end
				taken[slot] = true
			elseif wowKey then
				local target = NextCandidate()
				if target then
					plan[#plan + 1] = {
						key = c.key, wowKey = wowKey, command = slotCommand[target],
						slot = target, name = c.name, itemID = c.itemID,
						place = true, occupant = OccupantOf(target),
						rebind = (GetBindingAction and GetBindingAction(wowKey) ~= slotCommand[target]) or false,
					}
				else
					missing[#missing + 1] = c.name .. " (no free slot on bars 1-6)"
				end
			end
		end
	end

	table.sort(plan, function(a, b)
		return ns.Keybind_CompareBindKeys(a.key, b.key)
	end)
	table.sort(missing)
	return plan, missing, alreadyOk
end

--------------------------------------------------------------------------------
-- Full rebuild: empty bars 1-6, then lay the whole scheme out on them.
--
-- Rob's picture, 7 Aug: "we halen alle 6 de bars leeg (...) en dan alle keybindings
-- en spells erin". He is right that it removes a whole class of problem — if the bars
-- are empty, "something is already there" cannot happen.
--
-- ⚠️ NOTHING IS DESTROYED. Emptying a bar the naive way costs the player every macro,
-- flyout, mount and pet on it, and we PROVED this morning that we cannot put a macro
-- back: Rob lost one, because the id we record for a macro is the spell it casts and
-- PickupMacro wants an index. So anything we cannot recreate is MOVED to bars 7 and 8
-- — the space Rob wanted left free anyway — and undo moves it home. What we can
-- recreate exactly (spells, items) is simply cleared and restored from the snapshot.
--
-- ⚠️ It needs somewhere to move things TO. If bars 7 and 8 do not have room for
-- everything that must be relocated, the rebuild refuses rather than starting and
-- getting stuck halfway.
--------------------------------------------------------------------------------

local BARS_1_TO_6 = {
	"ACTIONBUTTON", "MULTIACTIONBAR1BUTTON", "MULTIACTIONBAR2BUTTON",
	"MULTIACTIONBAR3BUTTON", "MULTIACTIONBAR4BUTTON", "MULTIACTIONBAR5BUTTON",
}
local BARS_7_TO_8 = { "MULTIACTIONBAR6BUTTON", "MULTIACTIONBAR7BUTTON" }

local function SlotsOfBars(prefixes, commandSlot)
	local out = {}
	for _, prefix in ipairs(prefixes) do
		for i = 1, 12 do
			local slot = commandSlot[prefix .. i]
			if slot then
				out[#out + 1] = slot
			end
		end
	end
	table.sort(out)
	return out
end

--- What is in this slot, and can we put it back ourselves?
local function Occupant(slot)
	local ok, kind, id = pcall(GetActionInfo, slot)
	if not ok or not kind then
		return nil
	end
	return { slot = slot, kind = kind, id = id, recreatable = RESTORABLE[kind] or false }
end

--- @return table plan {clear, relocate, keep}, string|nil refusal
local function BuildRebuild(commandSlot)
	local work = { clear = {}, relocate = {} }
	local home = SlotsOfBars(BARS_1_TO_6, commandSlot)
	local spare = SlotsOfBars(BARS_7_TO_8, commandSlot)

	local freeSpare = {}
	for _, slot in ipairs(spare) do
		if SlotIsEmpty(slot) then
			freeSpare[#freeSpare + 1] = slot
		end
	end

	for _, slot in ipairs(home) do
		local occ = Occupant(slot)
		if occ then
			if occ.recreatable then
				work.clear[#work.clear + 1] = occ
			else
				local dest = table.remove(freeSpare, 1)
				if not dest then
					return nil, ("bars 7 and 8 have no room left; %d thing(s) would have nowhere to go"):format(
						#work.relocate + 1)
				end
				occ.dest = dest
				work.relocate[#work.relocate + 1] = occ
			end
		end
	end
	return work
end

--- `/mh apply` — say what would change. `/mh apply go` — do it. `/mh apply undo` — put it back.
function ns.MH_ApplyLayout(arg)
	ns.db = ns.db or {}

	if arg == "full" or arg == "full go" then
		local commandSlot = ns.MH_CommandSlotMap and ns.MH_CommandSlotMap() or {}
		local work, refusal = BuildRebuild(commandSlot)
		if not work then
			print(("%s cannot rebuild — %s."):format(Prefix(), tostring(refusal)))
			print("   |cff9d9d9dFree a few slots on bars 7-8 and try again. Nothing was touched.|r")
			return
		end
		if arg == "full" then
			-- To the file as well. Same rule, and the second time I forgot it.
			ns.db.rebuildPlan = { clear = {}, relocate = {} }
			for i = 1, #work.clear do
				local c = work.clear[i]
				ns.db.rebuildPlan.clear[i] = { slot = c.slot, kind = c.kind, id = c.id }
			end
			for i = 1, #work.relocate do
				local r = work.relocate[i]
				ns.db.rebuildPlan.relocate[i] = { slot = r.slot, dest = r.dest, kind = r.kind, id = r.id }
			end

			print(("%s rebuild would clear |cffffffff%d|r slot(s) and move |cffffffff%d|r thing(s) to bars 7-8:"):format(
				Prefix(), #work.clear, #work.relocate))
			for i = 1, #work.relocate do
				local r = work.relocate[i]
				print(("   |cff8ecfffmove|r %s from slot %d to %d"):format(tostring(r.kind), r.slot, r.dest))
			end
			print("   |cff9d9d9dNothing has changed. |cffffffff/mh apply full go|r to do it.|r")
			print("   |cff9d9d9dAfterwards run |cffffffff/mh apply go|r to fill the empty bars.|r")
			return
		end

		if InCombatLockdown and InCombatLockdown() then
			print(Prefix() .. " not in combat.")
			return
		end
		-- Relocate first: if we cleared first and then ran out of room, the thing we
		-- could not recreate would already be gone.
		local moved, cleared = 0, 0
		local snap = { relocated = {}, cleared = {} }
		for i = 1, #work.relocate do
			local r = work.relocate[i]
			local ok = pcall(function()
				PickupAction(r.slot)
				PlaceAction(r.dest)
				ClearCursor()
			end)
			pcall(ClearCursor)
			if ok then
				moved = moved + 1
				snap.relocated[#snap.relocated + 1] = { from = r.slot, to = r.dest }
			end
		end
		for i = 1, #work.clear do
			local c = work.clear[i]
			local ok = pcall(function()
				PickupAction(c.slot)
				ClearCursor()
			end)
			pcall(ClearCursor)
			if ok then
				cleared = cleared + 1
				snap.cleared[#snap.cleared + 1] = { slot = c.slot, kind = c.kind, id = c.id }
			end
		end
		ns.db.rebuildSnapshot = snap
		print(("%s rebuilt — |cffffffff%d|r moved to bars 7-8, |cffffffff%d|r cleared."):format(
			Prefix(), moved, cleared))
		print("   |cff9d9d9dNow run |cffffffff/mh apply|r to see the layout, then |cffffffff/mh apply go|r.|r")
		print("   |cff9d9d9d|cffffffff/mh apply undo|r puts the bars back.|r")
		return
	end

	if arg == "undo" then
		local snap = ns.db.bindSnapshot
		local placedSnap = ns.db.placedSnapshot
		local rebuild = ns.db.rebuildSnapshot
		local haveKeys = type(snap) == "table" and #snap > 0
		local havePlaced = type(placedSnap) == "table" and #placedSnap > 0
		local haveRebuild = type(rebuild) == "table"
			and ((#(rebuild.relocated or {}) > 0) or (#(rebuild.cleared or {}) > 0))
		if not haveKeys and not havePlaced and not haveRebuild then
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
					-- No macro branch: PickupMacro wants an index and the id we get is a
					-- spell id, which is exactly how Rob's macro was lost. Macro slots
					-- are refused as targets now, so this case cannot arise again.
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
		--- And the rebuild, in the reverse order it happened: first put back what we
		--- cleared, then walk the relocations home. Reverse order matters — a thing
		--- moved to bars 7-8 has to come back to a slot that is free again by then.
		local restored, returned = 0, 0
		if haveRebuild then
			for i = 1, #(rebuild.cleared or {}) do
				local row = rebuild.cleared[i]
				local ok = pcall(function()
					if row.kind == "spell" and row.id then
						if C_Spell and C_Spell.PickupSpell then
							C_Spell.PickupSpell(row.id)
						elseif PickupSpell then
							PickupSpell(row.id)
						end
						PlaceAction(row.slot)
					elseif row.kind == "item" and row.id then
						if C_Item and C_Item.PickupItem then
							C_Item.PickupItem(row.id)
						elseif PickupItem then
							PickupItem(row.id)
						end
						PlaceAction(row.slot)
					end
					ClearCursor()
				end)
				pcall(ClearCursor)
				if ok then
					restored = restored + 1
				end
			end
			for i = #(rebuild.relocated or {}), 1, -1 do
				local row = rebuild.relocated[i]
				local ok = pcall(function()
					PickupAction(row.to)
					PlaceAction(row.from)
					ClearCursor()
				end)
				pcall(ClearCursor)
				if ok then
					returned = returned + 1
				end
			end
		end

		ns.db.bindSnapshot = nil
		ns.db.placedSnapshot = nil
		ns.db.rebuildSnapshot = nil
		print(("%s undone — %d key(s) restored, %d slot(s) put back."):format(
			Prefix(), n, cleared))
		if haveRebuild then
			print(("   |cff9d9d9drebuild reversed: %d restored, %d moved home.|r"):format(restored, returned))
		end
		return
	end

	local plan, missing, alreadyOk = BuildPlan()
	if #plan == 0 and #missing == 0 then
		print(Prefix() .. " no layout to apply — run |cffffffff/mhautomap|r first.")
		return
	end

	if arg ~= "go" then
		--- The dry run goes to the file too. It used to print and nothing else, so the
		--- one person who needs to read it — whoever is being asked to approve it —
		--- could only screenshot chat. Same rule as every other long read here.
		ns.db.applyPlan = { rows = {}, missing = missing }
		for i = 1, #plan do
			local p = plan[i]
			ns.db.applyPlan.rows[i] = {
				key = p.wowKey, name = p.name, slot = p.slot, command = p.command,
				place = p.place or false, rebind = p.rebind or false,
				replaces = p.occupant and p.occupant.name or nil,
			}
		end

		ns.db.applyPlan.alreadyOk = alreadyOk
		print(("%s this would change |cffffffff%d|r thing(s); |cff40c040%d|r already correct."):format(
			Prefix(), #plan, alreadyOk))
		for i = 1, #plan do
			local p = plan[i]
			if p.place then
				local also = p.rebind and " |cff8ecfff+ rebind|r" or ""
				if p.occupant then
					-- Say what goes out, by name, before anything happens.
					print(("   |cffffd100%-10s|r %-24s |cffff9900slot %d — replaces %s|r%s"):format(
						p.wowKey, p.name, p.slot, tostring(p.occupant.name), also))
				else
					print(("   |cffffd100%-10s|r %-24s |cff40c040empty slot %d|r%s"):format(
						p.wowKey, p.name, p.slot, also))
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
		end
		-- A placement may ALSO move the key. Both halves need remembering, or an undo
		-- would put the slot back and leave the key pointing at the wrong button.
		if not p.place or p.rebind then
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
				if p.itemID then
					if C_Item and C_Item.PickupItem then
						C_Item.PickupItem(p.itemID)
					elseif PickupItem then
						PickupItem(p.itemID)
					end
				elseif C_Spell and C_Spell.PickupSpell then
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
			if p.rebind and p.command then
				if pcall(SetBinding, p.wowKey, p.command) then
					done = done + 1
				else
					failed = failed + 1
				end
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
