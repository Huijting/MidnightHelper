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

--- ⚠️ ONE KIND OF KEY PER BAR. Until now nothing decided WHERE an ability should sit;
--- `PlacementForKey` followed whatever the key happened to be bound to already, and
--- anything unbound fell into the first free slot. Measured on Rob's mage 7 Aug 2026:
--- Cone of Cold, Spellsteal, his racial and his health potion all landed on the main
--- bar's first four buttons, reachable only via Shift+3, 7, Shift+E and T. Every one of
--- them worked, and the bar was unreadable. His words when this started: "ik hou veel
--- ruimte over, ik vind het er niet uitzien en het is zeer verwarrend."
---
--- So each group of keys gets a bar, and a fixed position inside it. Sizes come from
--- measuring all 39 specs, not from taste: numbers peak at 5, letters at 8 of a pool of
--- 9, the F-row at 4, Ctrl at 6, and Shift at 13 — which is why Shift needs two bars.
--- A bar holds 12 buttons and no argument makes 13 fit on one.
---
--- Letters run in keyboard order (top row, home row, bottom row) rather than in the
--- scheme's own priority order: you read a bar with your eyes and press with your hand,
--- and the eye matches position to position.
---
--- Bars 7 and 8 are deliberately absent. Those are the player's own — professions,
--- portals, disenchant — and nothing here may touch them.
local NUMBER_KEYS = { "1", "2", "3", "4", "5" }
local LETTER_KEYS = { "Q", "E", "R", "T", "F", "Z", "X", "C", "V" }
local FROW_KEYS = { "F1", "F2", "F3", "F4" }

local function WithModifier(mod, keys)
	local out = {}
	for i = 1, #keys do
		out[i] = mod .. "+" .. keys[i]
	end
	return out
end

local function Concat(...)
	local out = {}
	for _, list in ipairs({ ... }) do
		for i = 1, #list do
			out[#out + 1] = list[i]
		end
	end
	return out
end

--- barIndex is an index into BAR_COMMANDS above; `keys` is read as position 1..n.
--- An empty string is a deliberate gap — it keeps the positions after it lined up.
local BAR_PLAN = {
	{ barIndex = 1, label = "numbers", size = 6, keys = NUMBER_KEYS },
	{ barIndex = 2, label = "letters", size = 9, keys = LETTER_KEYS },
	{ barIndex = 3, label = "shift (numbers + F-row)", size = 7,
		keys = Concat(WithModifier("Shift", NUMBER_KEYS), WithModifier("Shift", FROW_KEYS)) },
	{ barIndex = 4, label = "shift (letters)", size = 8, keys = WithModifier("Shift", LETTER_KEYS) },
	{ barIndex = 5, label = "F-row", size = 6, keys = FROW_KEYS },
	-- The Ctrl layer and the thumb buttons share a bar. Both are overflow, both are small
	-- (Ctrl peaks at 6 per spec and the thumb buttons at 6), and together they fit inside
	-- one bar of 12. Ctrl has no fixed position: its 18 possible keys cannot be given one
	-- on a 12-button bar, so it fills in scheme order. Say that plainly rather than
	-- pretend the whole layout is positional.
	{ barIndex = 6, label = "ctrl + mouse", size = 6, keys = {}, fill = true },
}

--- ⚠️ PACKED, NOT PINNED. Every key used to get a fixed position in its bar, so a spec
--- that lacked `Shift+Q` left button one empty and the bar read as holes. Measured over
--- all 39 specs: numbers and letters and the F-row sit near full, but the Shift bars
--- carry 4 and 5 of nine and the Ctrl layer carries 2 of eighteen. Rob's word for the
--- result was "gatenkaas", and looking at his screenshot he is right — with bars side by
--- side, each one's empty middle reads as a hole in the whole block.
---
--- So a bar is filled from its first button, in the group's own order, using only the
--- keys THIS spec actually has. Same order everywhere, no gaps, and the only empty
--- buttons are a tail at the end which the player can size away in Edit Mode.
---
--- What this costs: learning a new ability can shift the ones after it by one button.
--- That is a rare, one-off nudge, against a permanent hole on every bar. The promise the
--- scheme actually needs is that the same KIND of key lives on the same bar in the same
--- ORDER — not that button four is forever Shift+T.
---
--- @param usedKeys table|nil  set of bind keys this spec has; nil packs the whole pool
--- @return table bindKey -> action slot
--- ⚠️ CENTRED, NOT LEFT-PACKED. Rob's idea, and it solves both halves of a problem I had
--- been treating as a trade-off.
---
--- Packing from button one removed the holes but left the tail on the right, so a bar
--- sized 9 with 5 keys showed its icons left of centre while the bar itself was centred.
--- I had offered him a choice: one portable size with a crooked tail, or a tight size per
--- character that needs redoing per spec. He asked why we do not start from the middle
--- instead — and that keeps the single portable size AND centres the content.
---
--- A bar of 9 holding 5 fills positions 3 to 7: two empty each side, symmetric, which
--- reads as deliberate rather than unfinished.
local function BuildPlannedSlots(usedKeys)
	local planned = {}
	for _, group in ipairs(BAR_PLAN) do
		local bar = BAR_COMMANDS[group.barIndex]
		if bar then
			local wanted = {}
			for i = 1, #group.keys do
				local key = group.keys[i]
				if key and key ~= "" and (not usedKeys or usedKeys[key]) then
					wanted[#wanted + 1] = key
				end
			end
			--- Centre the block inside the bar's own width. `size` is the width the
			--- player is told to set; without it there is nothing to centre within, so
			--- fall back to packing from the left.
			local width = group.size or #wanted
			local offset = 0
			if width > #wanted then
				offset = math.floor((width - #wanted) / 2)
			end
			for i = 1, #wanted do
				local pos = offset + i
				if pos <= 12 then
					planned[wanted[i]] = bar.first + (pos - 1)
				end
			end
		end
	end
	return planned
end

--- Slots on the overflow bar, in order, for the keys BAR_PLAN gives no fixed position.
local function OverflowSlots()
	local out = {}
	for _, group in ipairs(BAR_PLAN) do
		if group.fill then
			local bar = BAR_COMMANDS[group.barIndex]
			if bar then
				for pos = 1, 12 do
					out[#out + 1] = bar.first + (pos - 1)
				end
			end
		end
	end
	return out
end

--- ⚠️ THE SIZES ARE MEASURED, NOT CHOSEN. Each `size` above is the widest that bar ever
--- needs across all 39 specs: numbers peak at 5, letters at 8, shift-numbers at 7
--- (Affliction Warlock), shift-letters at 8 (Guardian and Restoration Druid), the F-row
--- at 4 and Ctrl at 6. Six is Edit Mode's minimum, so anything under it is rounded up.
---
--- Set the bars to these and one arrangement works on every character. Set them to what
--- the current spec uses and it is tighter but has to be redone per alt.
---
--- @return table rows { barIndex, label, size, used, keys }
function ns.MH_BarPlanSummary()
    local used = {}
    local spec = ns.MH_AutoMapSpecAndSlots and ns.MH_AutoMapSpecAndSlots()
    for bindKey in pairs((spec and spec.spellByUiKey) or {}) do
        used[bindKey] = true
    end
    if ns.MH_ConsumableLayout then
        local ok, cons = pcall(ns.MH_ConsumableLayout, {})
        for i = 1, (ok and #cons or 0) do
            used[cons[i].key] = true
        end
    end
    local out = {}
    for _, group in ipairs(BAR_PLAN) do
        local have, list = 0, {}
        for _, key in ipairs(group.keys) do
            if used[key] then
                have = have + 1
                list[#list + 1] = key
            end
        end
        -- The overflow bar has no fixed key list; count what actually landed there.
        if group.fill then
            local bar = BAR_COMMANDS[group.barIndex]
            for bindKey in pairs(used) do
                local mod = ns.Keybind_ParseBindKey and select(1, ns.Keybind_ParseBindKey(bindKey))
                if mod == "ctrl" then
                    have = have + 1
                    list[#list + 1] = bindKey
                end
            end
            if not bar then
                have = 0
            end
        end
        out[#out + 1] = {
            barIndex = group.barIndex,
            label = group.label,
            size = group.size or 6,
            used = have,
            keys = list,
        }
    end
    return out
end

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
--- The name the PLAYER sees, which is the override's, not the base id's. BuildPlan keeps
--- its own copy of this for historical reasons; this one exists so the layout record can
--- use it too without reaching inside that function.
local function NameForSpell(id)
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
	end
	return tostring(id)
end

--- ⚠️ IS THIS SLOT THE ASSISTANT WEARING SOMEONE ELSE'S FACE?
---
--- The Single-Button Assistant displays the spell it currently recommends, so
--- `GetActionInfo` on its slot answers "Frozen Orb" — Rob's slot 1, measured 10 Aug.
--- Two things follow, and the second is dangerous:
---
---   * searching for the assistant by spell id finds nothing, which is why I wrongly
---     concluded it was on no bar at all;
---   * every OTHER check sees a copy of Frozen Orb. The duplicate remover was one
---     successful placement away from clearing his assistant as a stray copy.
---
--- `C_ActionBar.IsAssistedCombatAction` is the only honest answer to "what is this".
local function SlotIsAssistant(slot)
	if not (slot and C_ActionBar and C_ActionBar.IsAssistedCombatAction) then
		return false
	end
	local ok, v = pcall(C_ActionBar.IsAssistedCombatAction, slot)
	return (ok and v) and true or false
end

local function SlotHoldingSpell(spellID, driveable)
	if not (spellID and GetActionInfo) then
		return nil
	end
	-- The assistant answers to its own id, never to the spell it is displaying.
	if ns.Keybind_AssistantSpellID and spellID == ns.Keybind_AssistantSpellID() then
		for slot = 1, 180 do
			if SlotIsAssistant(slot) then
				return slot
			end
		end
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
		-- An assistant slot is displaying somebody else's spell. It is not a copy of it.
		if ok and (kind == "spell" or kind == "macro") and id and not SlotIsAssistant(slot) then
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

	--- Where BAR_PLAN says this key belongs. Nil when the key has no fixed position
	--- (the Ctrl layer) or when the bar is not one this client drives.
	--- The keys THIS spec has, so the bars pack instead of leaving holes. Consumables and
	--- the assistant count too — they occupy buttons like anything else.
	local usedKeys = {}
	for bindKey in pairs(spec.spellByUiKey) do
		usedKeys[bindKey] = true
	end
	if ns.MH_ConsumableLayout then
		local okU, cons = pcall(ns.MH_ConsumableLayout, {})
		for i = 1, (okU and #cons or 0) do
			usedKeys[cons[i].key] = true
		end
	end
	if ns.Keybind_AssistantSpellID and ns.Keybind_AssistantSpellID() then
		usedKeys["1"] = true
	end
	local plannedSlot = BuildPlannedSlots(usedKeys)
	local overflow = OverflowSlots()

	--- Slots on bars 1-6 — the layout's own space. Bars 7 and 8 belong to the player and
	--- are never cleared, only reported. Built from BAR_COMMANDS rather than the helper
	--- further down the file, which is out of scope here.
	local ourBars = {}
	for i = 1, 6 do
		local bar = BAR_COMMANDS[i]
		if bar then
			for n = 0, 11 do
				ourBars[bar.first + n] = true
			end
		end
	end

	--- The planned home first, the shared overflow bar second. Only then do we fall back
	--- on where the key happens to be bound today — that fallback is what scattered the
	--- layout in the first place, so it stops being the opening move.
	--- A slot the player has taken over is not a candidate, planned home or not. Moving
	--- their change back is the exact behaviour SlotOwnership exists to prevent.
	local function Free(slot)
		if not slot or taken[slot] or not slotCommand[slot] then
			return false
		end
		if ns.MH_SlotIsUserOwned and ns.MH_SlotIsUserOwned(slot) then
			return false
		end
		return true
	end

	local function PlannedTarget(bindKey)
		local slot = plannedSlot[bindKey]
		if Free(slot) then
			return slot
		end
		for i = 1, #overflow do
			if Free(overflow[i]) then
				return overflow[i]
			end
		end
		return nil
	end

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
	--
	--- ⚠️ UNLESS THE PLANNED HOME IS FREE. Measured on Rob's mage, 8 Aug 2026, on a
	--- clean Blizzard UI: 20 of 23 abilities landed exactly where BAR_PLAN wanted them,
	--- and three did not — Counterspell, Ice Cold and Remove Curse, all sitting on bar 7.
	--- `apply full` deliberately does not clear bars 7 and 8 because those are the
	--- player's own, so those three still had a home, took this branch, and got a
	--- binding pointing at the wrong bar instead of a place on the right one.
	---
	--- The bar plan has to outrank where a spell happens to be, or a rebuild can never
	--- undo the scattering it exists to fix. But only when the planned slot is genuinely
	--- free: if something else already holds it, moving would start a chain of shuffles
	--- for no gain, and staying put with a working key is the better answer.
	for _, row in ipairs(ordered) do
		local slot = SlotHoldingSpell(row.entry.id, driveable)
		if slot then
			local home = plannedSlot[row.bindKey]
			local homeIsBetter = home and home ~= slot and Free(home)
			if homeIsBetter then
				-- Leave `existingSlot` unset so pass 2 places it at home.
				row.strandedCopy = slot
			else
				taken[slot] = true
				row.existingSlot = slot
			end
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
				--- BAR_PLAN first, then the key's current home, then any free slot.
				---
				--- The order matters and it used to be the other way round: following
				--- the existing binding first is what put Cone of Cold, a racial and a
				--- health potion side by side on the main bar. Where a key happens to
				--- point today is history, not a plan.
				local target = PlannedTarget(bindKey)
				if target then
					taken[target] = true
				else
					target = PlacementForKey(wowKey, commandSlot)
					if target and not taken[target] then
						taken[target] = true
					else
						target = NextCandidate()
					end
				end
				if target then
					local cmd = slotCommand[target]
					plan[#plan + 1] = {
						key = bindKey, wowKey = wowKey, command = cmd,
						slot = target, name = NameFor(entry.id), spellID = entry.id,
						place = true,
						--- ⚠️ ONE ABILITY, ONE PLACE — on OUR bars.
						---
						--- Rob had Frozen Orb on slot 1 and slot 49 at once, which made
						--- the plan read "Frozen Orb replaces Frozen Orb". A duplicate is
						--- not just untidy: the layout promises that a key and a button
						--- are the same thing, and a second copy on a different key
						--- quietly breaks that promise.
						---
						--- Only on bars 1-6. A copy on bars 7 or 8 is the player's own
						--- doing and stays; we report it and leave it alone.
						stranded = row.strandedCopy,
						-- Never an assistant slot: it is displaying this spell, not
						-- holding a copy of it, and clearing it would delete the
						-- assistant the player put there.
						clearStranded = (row.strandedCopy and ourBars[row.strandedCopy]
							and not SlotIsAssistant(row.strandedCopy)) or nil,
						occupant = OccupantOf(target),
						rebind = (GetBindingAction and GetBindingAction(wowKey) ~= cmd) or false,
					}
				else
					missing[#missing + 1] = NameFor(entry.id) .. " (no free slot on bars 1-6)"
				end
			end
		end
	end
	--- The assistant, on the key the layout kept free for it.
	---
	--- `C_AssistedCombat.GetActionSpell()` gives the spell that represents the button —
	--- measured on the 12.1 PTR as 1229376, "Single-Button Assistant", and asked for
	--- fresh every time rather than written down. Without it the reserved key was an
	--- empty promise: we held `1` back and left the player to drag the thing there.
	---
	--- Nothing happens on a character that has no assistant, which is the whole reason
	--- this can be on by default: the slot simply stays empty, exactly as Rob put it.
	--- ⚠️ WE CANNOT PLACE THE ASSISTANT, MEASURED 10 AUG 2026 ON LIVE.
	---
	--- `C_AssistedCombat.GetActionSpell()` returns 1229376 and `C_Spell.GetSpellName`
	--- turns it into "Single-Button Assistant", so it looks like an ordinary spell all
	--- the way up to the moment you try to put it somewhere: `C_Spell.PickupSpell` picks
	--- up nothing, `PlaceAction` changes nothing, and neither raises an error. Rob ran
	--- the apply three times and slot 1 kept holding Frozen Orb while the addon claimed
	--- success.
	---
	--- I had written in this very file that the function's name was "suggestive and
	--- suggestive is not evidence", then treated a returned number as evidence anyway.
	--- The id resolving to a name proves the id is real; it proves nothing about whether
	--- the action can be picked up.
	---
	--- So the row is still planned — the verification below will tell us honestly if a
	--- future patch starts allowing it — but the failure now says what to do instead.
	--- Once the game has refused it on THIS build, stop proposing it. A plan that always
	--- carries a line which never works is the same silent wrongness in a louder font.
	--- Keyed to the build so a patch that starts allowing it is noticed on its own.
	--- ⚠️ `select(2, GetBuildInfo and GetBuildInfo() or nil)` looked right and always gave
	--- nil: the and/or squeezes GetBuildInfo's several return values down to one, so
	--- there is no second value left to select. The refusal was therefore never
	--- remembered and the dead row kept being proposed. Take the values properly.
	local build
	if GetBuildInfo then
		local okB, _, b = pcall(GetBuildInfo)
		build = okB and b or nil
	end
	local refusedHere = (ns.db and ns.db.assistantRefusedBuild) == build and build ~= nil

	local assistantID = ns.Keybind_AssistantSpellID and ns.Keybind_AssistantSpellID()
	if assistantID and refusedHere then
		missing[#missing + 1] = NameForSpell(assistantID)
			.. " (an addon cannot place this — drag it from your spellbook once)"
		local home = plannedSlot["1"]
		if home then
			taken[home] = true
		end
	elseif assistantID and (ns.db and ns.db.sbaForce) and not (ns.db and ns.db.sbaOff) then
		local target = plannedSlot["1"]
		local already = SlotHoldingSpell(assistantID, driveable)
		if already then
			taken[already] = true
			local cmd = slotCommand[already] or CommandForSlot(already)
			if cmd and GetBindingAction and GetBindingAction("1") ~= cmd then
				plan[#plan + 1] = {
					key = "1", wowKey = "1", command = cmd, slot = already,
					name = NameForSpell(assistantID),
				}
			end
		elseif target and slotCommand[target] and not taken[target] then
			local occ = OccupantOf(target)
			if occ and not RESTORABLE[occ.kind] then
				missing[#missing + 1] = NameForSpell(assistantID)
					.. (" (slot %d holds a %s we could not put back)"):format(target, tostring(occ.kind))
			else
				taken[target] = true
				plan[#plan + 1] = {
					key = "1", wowKey = "1", command = slotCommand[target],
					slot = target, name = NameForSpell(assistantID), spellID = assistantID,
					place = true, occupant = occ,
					rebind = (GetBindingAction and GetBindingAction("1") ~= slotCommand[target]) or false,
				}
			end
		else
			missing[#missing + 1] = NameForSpell(assistantID)
				.. (target and " (no action button drives slot " .. target .. ")" or " (no slot for key 1)")
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
				-- The potion lives on T, and T is a letter key, so BAR_PLAN has a home
				-- for it like anything else. Only fall to a free slot if that is taken.
				local target = PlannedTarget(c.key)
				if target then
					taken[target] = true
				else
					target = NextCandidate()
				end
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

	--- ⚠️ NEVER CLEAR THE ASSISTANT'S SLOT. Rob had dragged the Single-Button Assistant
	--- onto slot 1 himself; a rebuild wiped it, and we cannot put it back because an
	--- addon cannot place it. Removing something we are unable to restore is the one
	--- thing this whole rebuild is designed not to do — the reason macros and battle pets
	--- are relocated rather than cleared. The assistant slipped through because it looks
	--- like an ordinary spell to GetActionInfo.
	--- Also: any slot that IS the assistant, wherever it sits. Looking only at the
	--- planned key-1 slot assumed the player had put it where we expected, and the
	--- assistant reports as whatever spell it is suggesting, so an ordinary occupant
	--- check would happily clear it as a stray spell.
	local keepSlot = nil
	if ns.Keybind_AssistantSpellID and ns.Keybind_AssistantSpellID() then
		keepSlot = BuildPlannedSlots()["1"]
	end

	for _, slot in ipairs(home) do
		local occ = (slot ~= keepSlot and not SlotIsAssistant(slot)) and Occupant(slot) or nil
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
		--- ⚠️ FORGET WHAT WE CLAIMED. A rebuild empties the very slots SlotOwnership is
		--- watching, so the next plan found our abilities gone and blamed the player:
		--- "3 slot(s) you changed yourself". Rob had changed nothing — we had. And the
		--- accusation is not cosmetic, it permanently excludes those slots from the
		--- layout.
		---
		--- After a rebuild the record describes bars that no longer exist, exactly as it
		--- does after an undo. Wipe it; `/mh apply go` claims afresh.
		if ns.MH_ForgetSlots then
			ns.MH_ForgetSlots()
		end
		print(("%s rebuilt — |cffffffff%d|r moved to bars 7-8, |cffffffff%d|r cleared."):format(
			Prefix(), moved, cleared))
		print("   |cff9d9d9dNow run |cffffffff/mh apply|r to see the layout, then |cffffffff/mh apply go|r.|r")
		print("   |cff9d9d9d|cffffffff/mh apply undo|r puts the bars back.|r")
		return
	end

		--- `/mh apply clean` — unbind keys that point at our bars but belong to no layout.
	---
	--- Rob's bars after the rebuild, read off the buttons: `a-5 a-0 a-E a-R a-F a-G a-C`
	--- on bar 1, `a-F1 a-F2 a-F3` on bar 4. Alt bindings, all of them, left over from the
	--- scheme as it stood before 6 Aug 2026 — the day Alt was dropped. They point at
	--- slots we now fill with something else, so a button shows one key and does another,
	--- which is the exact confusion this whole layout exists to remove.
	---
	--- ⚠️ ONLY BARS 1-6, AND ONLY WHAT NO LAYOUT CLAIMS. Bars 7 and 8 are the player's
	--- own and are not read for this at all. Keys the layout assigns are kept, and so is
	--- any RESERVED key — `1` drives Blizzard's Assisted Combat button, the layout leaves
	--- its slot deliberately empty, and so it would otherwise look exactly like cruft.
	---
	--- Started as an Alt-only sweep on 8 Aug 2026 and Rob asked for the rest the same
	--- morning, once the first pass proved itself: removing `a-F2` revealed the `s-E`
	--- underneath it, a working Shift+E that the dead binding had been masking on the
	--- button all along.
	if arg == "clean" or arg == "clean go" then
		if not (GetNumBindings and GetBinding) then
			print(Prefix() .. " this client does not expose the binding API.")
			return
		end
		local commandSlot = ns.MH_CommandSlotMap and ns.MH_CommandSlotMap() or {}
		local ours = {}
		for _, slot in ipairs(SlotsOfBars(BARS_1_TO_6, commandSlot)) do
			ours[slot] = true
		end

		--- Two things must survive, and forgetting either would take a working key away.
		---
		--- Keys the layout assigns, obviously. And RESERVED keys: `1` drives Blizzard's
		--- Assisted Combat button and the layout deliberately leaves it empty, so it is
		--- absent from the layout's own list and would otherwise look exactly like cruft.
		local keep = {}
		local specNow = ns.MH_AutoMapSpecAndSlots and ns.MH_AutoMapSpecAndSlots()
		if specNow and specNow.spellByUiKey then
			for bindKey in pairs(specNow.spellByUiKey) do
				local k = ToWowKey(bindKey)
				if k then
					keep[k] = true
				end
			end
		end
		if ns.MH_ConsumableLayout then
			local okC, cons = pcall(ns.MH_ConsumableLayout, {})
			for i = 1, (okC and #cons or 0) do
				local k = ToWowKey(cons[i].key)
				if k then
					keep[k] = true
				end
			end
		end
		local reserved = ns.Keybind_ReservedBaseKeys and ns.Keybind_ReservedBaseKeys() or {}

		local dead = {}
		for i = 1, (GetNumBindings() or 0) do
			local okB, command, _, key1, key2 = pcall(GetBinding, i)
			if okB and command and commandSlot[command] and ours[commandSlot[command]] then
				for _, key in ipairs({ key1, key2 }) do
					if key and key ~= "" and not keep[key] then
						local base = key:match("[^%-]+$") or key
						if not reserved[base] then
							dead[#dead + 1] = { key = key, command = command }
						end
					end
				end
			end
		end

		--- ⚠️ ACCOUNT-WIDE BINDINGS MAKE THIS A CROSS-CHARACTER EDIT.
		---
		--- Measured on Rob's Hunter, 10 Aug: Shift+1 to Shift+4, Shift+F1 and 6 were all
		--- bound to empty slots and none was in the Hunter's layout. They are his MAGE's
		--- keys — action bar contents are per character, key bindings are not, and his
		--- set is the account one. Cleaning here would have stripped them from the Mage
		--- as well, and he would have found out the next time he logged in and pressed
		--- Shift+1 for Frozen Orb.
		---
		--- Said, not refused. Tidying really does need doing; it just must not be a
		--- surprise. `SaveBindings(GetCurrentBindingSet())` already writes to whichever
		--- set the player chose, so the warning only has to name it.
		local accountBindings = GetCurrentBindingSet and select(1, pcall(GetCurrentBindingSet))
			and (GetCurrentBindingSet() == 1)
		if accountBindings and #dead > 0 then
			print(Prefix() .. " |cffff9900your keybindings are account-wide.|r")
			print("   |cff9d9d9dRemoving these takes them off your other characters too. If a key")
			print("   below belongs to an alt, run |cffffffff/mh apply|r there first and leave it be.|r")
		end

		if arg == "clean" then
			ns.db.cleanPlan = dead
			ns.db.cleanAccountWide = accountBindings and true or false
			print(("%s |cffffffff%d|r key(s) point at our bars but belong to no layout:"):format(
				Prefix(), #dead))
			for i = 1, #dead do
				print(("   |cffffd100%-10s|r -> %s"):format(dead[i].key, dead[i].command))
			end
			print("   |cff9d9d9dKeys the layout uses are kept, and so is the assistant's key.|r")
			print("   |cff9d9d9dNothing has changed. |cffffffff/mh apply clean go|r to remove them.|r")
			return
		end

		if InCombatLockdown and InCombatLockdown() then
			print(Prefix() .. " not in combat.")
			return
		end
		local snap, n = {}, 0
		for i = 1, #dead do
			snap[#snap + 1] = { key = dead[i].key, was = dead[i].command }
			if pcall(SetBinding, dead[i].key) then
				n = n + 1
			end
		end
		if SaveBindings and GetCurrentBindingSet then
			pcall(SaveBindings, GetCurrentBindingSet())
		end
		-- Same snapshot slot the rest of apply uses, so one undo covers everything.
		ns.db.bindSnapshot = snap
		print(("%s removed |cffffffff%d|r dead Alt binding(s)."):format(Prefix(), n))
		print("   |cff9d9d9d|cffffffff/mh apply undo|r puts them back.|r")
		return
	end

--- `/mh apply reclaim` — hand the slots you changed back to the layout.
	---
	--- Explicit on purpose. A slot stops being ours the moment the player moves it and
	--- never returns on its own, not even if they put our ability back later. Deciding
	--- that for them is the behaviour we removed.
	if arg == "reclaim" then
		local n = ns.MH_ReclaimSlots and ns.MH_ReclaimSlots() or 0
		if n == 0 then
			print(Prefix() .. " nothing to reclaim — no slots are marked as yours.")
		else
			print(("%s |cffffffff%d|r slot(s) handed back to the layout."):format(Prefix(), n))
			print("   |cff9d9d9d/mh apply|r to see what would change now.|r")
		end
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
		-- The bars are back the way they were, so a record of what we had placed now
		-- describes a world that no longer exists. Keeping it would make the next run
		-- announce that the player "changed" slots an undo changed.
		if ns.MH_ForgetSlots then
			ns.MH_ForgetSlots()
		end
		print(("%s undone — %d key(s) restored, %d slot(s) put back."):format(
			Prefix(), n, cleared))
		if haveRebuild then
			print(("   |cff9d9d9drebuild reversed: %d restored, %d moved home.|r"):format(restored, returned))
		end
		return
	end

	--- ⚠️ TWO DIFFERENT THINGS WORE THE SAME MESSAGE. "no layout to apply — run
	--- /mhautomap first" was printed whenever the plan came back empty, which happens for
	--- two unrelated reasons: the spellbook scan produced nothing, or it produced a
	--- layout in which every key is already correct. Rob hit it on 7 Aug 2026 with
	--- /mhautomap reporting 23 placed one line above, which makes the advice not just
	--- unhelpful but visibly wrong. Ask the layout directly instead of inferring its
	--- state from the size of the plan.
	--- Before anything is planned, check the slots we filled last time. Any that no
	--- longer hold what we put there have been changed by the player and stop being ours.
	local handedOver = ns.MH_ReconcileSlots and ns.MH_ReconcileSlots() or 0
	if handedOver > 0 then
		print(("%s |cffffd100%d|r slot(s) you changed yourself — those are yours now, we leave them alone."):format(
			Prefix(), handedOver))
	end

	local specNow = ns.MH_AutoMapSpecAndSlots and ns.MH_AutoMapSpecAndSlots()
	local layoutSize = 0
	if specNow and specNow.spellByUiKey then
		for _ in pairs(specNow.spellByUiKey) do
			layoutSize = layoutSize + 1
		end
	end
	local plan, missing, alreadyOk = BuildPlan()
	if layoutSize == 0 then
		print(Prefix() .. " no layout — the spellbook scan came back empty.")
		print("   |cff9d9d9dThis can happen right after a reload. Try again, or run |cffffffff/mhautomap|r to see the scan.|r")
		return
	end
	--- What the layout WANTS, key by key, and where each ability sits right now. Written
	--- on every dry run including the one with nothing to do — an evening of diagnosing
	--- "three abilities are missing" was spent inferring this from slot numbers because
	--- the quiet path wrote nothing at all.
	local function RecordLayout()
		local out = {}
		if specNow and specNow.spellByUiKey then
			for bindKey, entry in pairs(specNow.spellByUiKey) do
				local slot = entry and entry.id and SlotHoldingSpell and SlotHoldingSpell(entry.id) or nil
				out[#out + 1] = {
					key = bindKey,
					name = entry and entry.id and NameForSpell(entry.id) or "?",
					onSlot = slot,
				}
			end
			table.sort(out, function(a, b)
				return ns.Keybind_CompareBindKeys(a.key, b.key)
			end)
		end
		return out
	end

	if #plan == 0 and #missing == 0 then
		ns.db.applyPlan = { rows = {}, missing = {}, alreadyOk = alreadyOk, layout = RecordLayout() }
		print(("%s nothing to change — all |cffffffff%d|r key(s) already point at the right slot."):format(
			Prefix(), alreadyOk))
		print("   |cff9d9d9dThe whole layout is in SavedVariables — |cffffffff/reload|r to read it.|r")
		return
	end

	if arg ~= "go" then
		--- The dry run goes to the file too. It used to print and nothing else, so the
		--- one person who needs to read it — whoever is being asked to approve it —
		--- could only screenshot chat. Same rule as every other long read here.
		-- The layout goes in on EVERY dry run, not only the quiet one. It was added for
		-- the case with nothing to report and then missing from the case that actually
		-- needed reading — the PTR run where the assistant did not appear and the record
		-- that would have said why came back empty.
		ns.db.applyPlan = { rows = {}, missing = missing, layout = RecordLayout() }
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
					print(("   |cffffd100%-10s|r %-24s |cff40c040empty slot %d|r%s%s"):format(
						p.wowKey, p.name, p.slot, also,
						p.clearStranded and (" |cff8ecfff(the duplicate on slot %d goes)|r"):format(p.clearStranded)
							or (p.stranded and (" |cff9d9d9d(a copy stays on slot %d — your bar, your call)|r"):format(p.stranded) or "")))
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
		--- A bar that is switched off in Edit Mode has no buttons, so BAR_PLAN cannot use
		--- it and everything quietly piles onto the bars that are on. That is the failure
		--- this whole feature exists to end, so name it instead of letting it happen.
		local off = {}
		local cs = ns.MH_CommandSlotMap and ns.MH_CommandSlotMap() or {}
		local haveSlot = {}
		for _, s in pairs(cs) do
			haveSlot[s] = true
		end
		for _, group in ipairs(BAR_PLAN) do
			local bar = BAR_COMMANDS[group.barIndex]
			if bar and not haveSlot[bar.first] then
				off[#off + 1] = ("bar %d (%s)"):format(group.barIndex, group.label)
			end
		end
		if #off > 0 then
			print(("   |cffff9900%d bar(s) the layout wants are switched off:|r %s"):format(
				#off, table.concat(off, ", ")))
			print("   |cff9d9d9dTurn them on in Edit Mode, or those keys share a bar with the rest.|r")
		end

		--- ⚠️ A BAR CAN BE TOO SHORT, AND THAT FAILS SILENTLY.
		---
		--- Edit Mode's icon-count slider hides buttons; it does not remove the action
		--- slots behind them. So a bar set to 6 still has slots 7-12, apply will happily
		--- fill one, and the ability lands on a button the player cannot see. Rob was
		--- about to size two bars to 6 that need 7 and 8 on some specs — measured over
		--- all 39: shift-numbers peaks at 7 (Affliction Warlock), shift-letters at 8
		--- (Guardian and Restoration Druid).
		---
		--- Same shape as the switched-off warning, one level finer, and worth the extra
		--- check precisely because the slider makes it so easy to do.
		local hidden = {}
		for i = 1, #plan do
			local p = plan[i]
			local cmd = p.command
			if cmd then
				local frameName = cmd:gsub("BUTTON(%d+)$", "Button%1")
					:gsub("^ACTIONBUTTON", "ActionButton")
					:gsub("^MULTIACTIONBAR1", "MultiBarBottomLeft")
					:gsub("^MULTIACTIONBAR2", "MultiBarBottomRight")
					:gsub("^MULTIACTIONBAR3", "MultiBarRight")
					:gsub("^MULTIACTIONBAR4", "MultiBarLeft")
					:gsub("^MULTIACTIONBAR5", "MultiBar5")
					:gsub("^MULTIACTIONBAR6", "MultiBar6")
					:gsub("^MULTIACTIONBAR7", "MultiBar7")
				local f = _G and _G[frameName]
				if f and f.IsShown then
					local okS, shown = pcall(f.IsShown, f)
					if okS and not shown then
						hidden[#hidden + 1] = ("%s (%s)"):format(p.name, p.wowKey)
					end
				end
			end
		end
		if #hidden > 0 then
			print(("   |cffff9900%d would land on a button you cannot see — that bar is too short:|r"):format(#hidden))
			print("   " .. table.concat(hidden, ", "))
			print("   |cff9d9d9dMake the bar longer in Edit Mode. Sizes that fit every spec:|r")
			print("   |cff9d9d9dnumbers 6, letters 8, shift-numbers 7, shift-letters 8, F-row 6, ctrl 6.|r")
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
			-- A duplicate we are about to remove is remembered the same way, or undo
			-- would put the ability back in one place and leave the other gone.
			if p.clearStranded then
				placedSnap[#placedSnap + 1] = {
					slot = p.clearStranded, kind = "spell", id = p.spellID,
				}
			end
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
			--- ⚠️ DID IT ACTUALLY LAND? `pcall` only says the three calls did not raise
			--- an error, and that is not the same as the slot changing. On 10 Aug the
			--- Single-Button Assistant reported "2 spell(s) placed" three times in a row
			--- while slot 1 kept holding Frozen Orb: `C_Spell.PickupSpell(1229376)`
			--- returns nothing placeable, quietly. Three rounds of Rob's time went to a
			--- success message we had no evidence for.
			---
			--- So ask the slot. An ability that did not arrive is a failure, said out
			--- loud, and its duplicate is NOT cleared.
			if ok and p.spellID and GetActionInfo then
				local okI, kind, id = pcall(GetActionInfo, p.slot)
				--- ⚠️ A PLACED SPELL CAN REPORT ITS OVERRIDE. Measured on Rob's Hunter:
				--- Barbed Shot, Cobra Shot and Primal Rage were all reported as "the game
				--- refused to put it on slot N" while sitting on exactly those slots. We
				--- place the base id and the bar answers with whichever the game prefers
				--- — the same thing that made Ice Block read as Ice Cold.
				---
				--- `SlotHoldingSpell` has known about overrides for weeks; this check did
				--- not. Two pieces of code answering "is this spell here?" differently,
				--- for the fourth time this week.
				local override
				if p.spellID and C_SpellBook and C_SpellBook.FindSpellOverrideByID then
					local okO, o = pcall(C_SpellBook.FindSpellOverrideByID, p.spellID)
					if okO and type(o) == "number" and o ~= 0 then
						override = o
					end
				end
				-- The assistant never reports its own id; ask what the slot IS instead.
				local landed = okI and ((kind == "spell" and (id == p.spellID or (override and id == override)))
					or (kind == "item" and id == p.itemID)
					or (ns.Keybind_AssistantSpellID and p.spellID == ns.Keybind_AssistantSpellID()
						and SlotIsAssistant(p.slot)))
				if not landed then
					ok = false
					missing[#missing + 1] = p.name .. (" (the game refused to put it on slot %d)"):format(p.slot)
					-- Remember a refusal of the assistant so we stop proposing it here.
					if ns.Keybind_AssistantSpellID and p.spellID == ns.Keybind_AssistantSpellID() then
						if GetBuildInfo then
							local okB, _, b = pcall(GetBuildInfo)
							ns.db.assistantRefusedBuild = okB and b or nil
						end
					end
				end
			end
			--- The old copy goes, so the ability lives in exactly one place on our bars.
			--- After the placement, never before: if the placement failed we would have
			--- deleted the only copy.
			if ok and p.clearStranded then
				pcall(function()
					PickupAction(p.clearStranded)
					ClearCursor()
				end)
				pcall(ClearCursor)
			end
			if ok then
				placed = placed + 1
				-- Write down that this one is ours, so a later run can tell our own
				-- work apart from something the player moved.
				if ns.MH_ClaimSlot then
					ns.MH_ClaimSlot(p.slot, p.itemID and "item" or "spell", p.itemID or p.spellID, p.wowKey)
				end
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
		print(("   |cffff9900%d could not be done:|r %s"):format(
			#missing, table.concat(missing, ", ")))
		-- The one refusal we know the cause of, so the player is not left guessing.
		for i = 1, #missing do
			if missing[i]:find("Assistant") then
				print("   |cff9d9d9dThe assistant cannot be placed by an addon. Drag it from your")
				print("   spellbook onto that button once — MH keeps the key free for it.|r")
				break
			end
		end
	end
end
