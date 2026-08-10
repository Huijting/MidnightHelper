local _, ns = ...

--[[
	Midnight Helper — move an anchor to the key your hands already know (`/mh anchor`).

	Rob, 10 Aug 2026: "normaal zou ik op 6 een interrupt zetten, op 7 bv een shield, op a
	taunt". Years of muscle memory, and the scheme was overruling it — while using those
	same thumb buttons as the drain for whatever fitted nowhere else. Dragon's Breath got
	his best key because it was leftover, not because it mattered.

	The scheme's value was never in WHICH key holds the interrupt. It is that the answer
	is the same on every character you play. So the key becomes the player's choice and
	the sameness is kept: an override applies to every spec, and the key it claims is
	taken out of the overflow pool so nothing else can land on it.

	⚠️ This does NOT duplicate. Moving the interrupt to `6` means `E` no longer holds it —
	one thing, one place. Two keys for one ability is how you end up hesitating at the
	moment hesitating is expensive.
]]

--- What may be moved. Roles resolve to exactly one key, which is what makes them
--- anchors; the three single-slot categories are included because they behave the same.
--- Everything else has a list to choose from and has no anchor to move.
local MOVABLE = {
	interrupt = "Interrupt",
	utility_primary = "Movement",
	utility_secondary = "Utility",
	mobility = "Mobility",
	defensive_1 = "Small defensive",
	defensive_2 = "Defensive",
	defensive_3 = "Big defensive",
	defensive_4 = "Dispel / CC",
	cooldown_bar = "Big cooldown",
	heal_quick = "Quick self-heal",
	heal_ooc = "Heal out of combat",
	heal_sustain = "Sustain / HoT",
	spender = "Spender",
	taunt = "Taunt",
}

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

--- Where this anchor sits today, override or default.
local function CurrentKey(name)
	local override = ns.Keybind_AnchorOverride and ns.Keybind_AnchorOverride(name)
	if override then
		return override, true
	end
	local schema = ns.KeybindSchema
	local role = schema and schema.roles and schema.roles[name]
	if role and role.ui_key then
		return role.ui_key, false
	end
	local slots = ns.Keybind_GetCategorySlots and ns.Keybind_GetCategorySlots(name)
	if slots and slots[1] then
		return slots[1], false
	end
	return nil, false
end

--- A key we are willing to anchor to.
---
--- Two sources, and the second is the point of the whole feature: the v6 keyboard pool,
--- and any key the player's own mouse was MEASURED to send. Rob's thumb buttons send
--- `6 7 8 9 0 -`, which the keyboard pool bans as too far a reach — true for a left hand
--- walking up the number row, false for a thumb resting on them.
local function KeyIsAllowed(base)
	if not base then
		return false, "not a key"
	end
	local schema = ns.KeybindSchema
	if schema and schema.excludedBaseKeys and schema.excludedBaseKeys[base] then
		return false, base .. " is excluded from the scheme"
	end
	for _, k in ipairs((schema and schema.baseSlotFillOrder) or {}) do
		if k == base then
			return true
		end
	end
	for _, k in ipairs({ "E", "F1", "F2", "F3", "F4", "T" }) do
		if k == base then
			return true
		end
	end
	for _, entry in ipairs((ns.db and ns.db.mouseDetect) or {}) do
		local k = entry and entry.key and ns.Keybind_NormalizeBaseKey(entry.key)
		if k == base then
			return true
		end
	end
	return false, ("%s is not in the scheme's keys, and your mouse was not measured sending it — run |cffffffff/mh mouse detect|r"):format(base)
end

local function List()
	print(Prefix() .. " anchors — |cffffffff/mh anchor <name> <key>|r to move one:")
	local names = {}
	for name in pairs(MOVABLE) do
		names[#names + 1] = name
	end
	table.sort(names)
	for _, name in ipairs(names) do
		local key, moved = CurrentKey(name)
		print(("   |cffffd100%-18s|r %-6s %s%s"):format(
			name, tostring(key or "-"), MOVABLE[name],
			moved and " |cff40c040(yours)|r" or ""))
	end
	print("   |cff9d9d9d/mh anchor reset|r puts them all back.|r")
end

--- `/mh anchor` · `/mh anchor <name> <key>` · `/mh anchor <name> off` · `/mh anchor reset`
function ns.MH_Anchor(arg)
	ns.db = ns.db or {}
	arg = tostring(arg or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if arg == "" then
		return List()
	end
	if arg == "reset" then
		ns.db.anchorOverrides = nil
		print(Prefix() .. " anchors back to the scheme's own keys.")
		print("   |cff9d9d9d/reload, then /mh apply.|r")
		return
	end

	local name, key = arg:match("^(%S+)%s+(%S+)$")
	if not name or not MOVABLE[name] then
		print(Prefix() .. " |cffff9900which anchor?|r Use one of the names below.")
		return List()
	end

	ns.db.anchorOverrides = ns.db.anchorOverrides or {}
	if key:lower() == "off" then
		ns.db.anchorOverrides[name] = nil
		local back = CurrentKey(name)
		print((Prefix() .. " %s back to |cffffffff%s|r."):format(name, tostring(back)))
		print("   |cff9d9d9d/reload, then /mh apply.|r")
		return
	end

	local base = ns.Keybind_NormalizeBaseKey and ns.Keybind_NormalizeBaseKey(key)
	local ok, why = KeyIsAllowed(base)
	if not ok then
		print((Prefix() .. " |cffff9900cannot use %s:|r %s"):format(tostring(key), tostring(why)))
		return
	end

	-- One key, one anchor. Silently letting two roles share a key would produce a layout
	-- whose second half depends on allocation order, which is the bug shape this whole
	-- system keeps tripping over.
	for other, k in pairs(ns.db.anchorOverrides) do
		if other ~= name and ns.Keybind_NormalizeBaseKey(k) == base then
			print((Prefix() .. " |cffff9900%s is already your %s anchor.|r"):format(base, other))
			print(("   |cff9d9d9dFree it first: |cffffffff/mh anchor %s off|r"):format(other))
			return
		end
	end

	ns.db.anchorOverrides[name] = base
	print((Prefix() .. " %s is now on |cffffffff%s|r, on every character."):format(
		MOVABLE[name], base))
	print("   |cff9d9d9dNothing else can take that key now. |cffffffff/reload|r, then |cffffffff/mh apply|r.|r")
end
