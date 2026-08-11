local _, ns = ...

--[[
	Midnight Helper — the potion keys, off the action bars.

	`LayoutConsumables.lua` puts your healing and combat potion on a bar slot and binds a
	key to that slot. Two costs come with that, and both were measured on 7 Aug:

	  * `T` has to be RESERVED as the consumable anchor, so the spell allocator may never
	    use it. One of the best keys on the keyboard, held back for a potion.
	  * With `T` reserved, 28 of 39 specs have exactly one bare key left, so the combat
	    potion lands on a Shift layer or not at all.

	And a third, which is what Rob keeps running into: a bar rebuild wipes the slot, so
	the potion vanishes until somebody notices.

	A secure button fixes all three. Borrowed from `!Pig`, where Rob spotted a "Key
	Binding" button next to a discard action: they publish `CLICK <frame>:LeftButton` in
	their Bindings.xml, so an addon action becomes bindable in Blizzard's own keybinding
	screen without a macro and without taint. The button lives outside the action bars,
	so it costs no slot, and the binding survives every rebuild because it is attached to
	the button rather than to slot 47.

	⚠️ SECURE FRAME RULES (see also MissingBuff.lua):
	  * attributes may only be set OUT of combat — the item changes as your bags do, so
	    updates are deferred to PLAYER_REGEN_ENABLED when a fight is on;
	  * parented to UIParent, never to one of our own windows, so nothing of ours becomes
	    protected by association.

	⚠️ It offers a key, it does not take one. Nothing is bound by default: an addon that
	silently claims `T` on install is the behaviour this project keeps complaining about.
	The binding appears in Blizzard's list under "Midnight Helper" and the player decides.
]]

local BUTTONS = {
	{ name = "MidnightHelperHealPotion", category = "healingPotion" },
	{ name = "MidnightHelperCombatPotion", category = "combatPotion" },
}

local frames = {}
local pending = false

--- Which item this category resolves to right now, or nil when the bags have none.
---
--- Reuses `ns.MH_ConsumableLayout`, so there is one answer to "which potion" rather than
--- a second copy of the bag-scanning logic drifting away from the first.
local function WantedItem(category)
	if not ns.MH_ConsumableLayout then
		return nil
	end
	local ok, list = pcall(ns.MH_ConsumableLayout, {})
	if not ok or type(list) ~= "table" then
		return nil
	end
	for _, entry in ipairs(list) do
		if entry.category == category then
			return entry.itemID, entry.name
		end
	end
	return nil
end

local function ApplyItems()
	if InCombatLockdown and InCombatLockdown() then
		pending = true
		return
	end
	pending = false
	for _, def in ipairs(BUTTONS) do
		local btn = frames[def.name]
		if btn then
			local itemID = WantedItem(def.category)
			if itemID then
				btn:SetAttribute("type", "item")
				btn:SetAttribute("item", "item:" .. tostring(itemID))
			else
				-- Nothing carried: clear rather than leave yesterday's potion armed.
				btn:SetAttribute("type", nil)
				btn:SetAttribute("item", nil)
			end
		end
	end
end

local function Build()
	if next(frames) then
		return
	end
	for _, def in ipairs(BUTTONS) do
		local btn = CreateFrame("Button", def.name, UIParent, "SecureActionButtonTemplate")
		btn:SetSize(1, 1)
		btn:SetPoint("CENTER")
		btn:RegisterForClicks("AnyUp", "AnyDown")
		--- Invisible on purpose: this exists to be a keybinding target. A visible extra
		--- button would be a second thing to position and a second thing to explain.
		btn:SetAlpha(0)
		btn:EnableMouse(false)
		frames[def.name] = btn
	end
	ApplyItems()
end

--- What the two bindings are called in Blizzard's keybinding screen.
---
--- These globals are shared across every addon, so the frame names are namespaced —
--- a bare "HEALPOTION" would collide with whoever else had the same idea.
_G["BINDING_NAME_CLICK MidnightHelperHealPotion:LeftButton"] =
	(ns.L and ns:L("POTIONKEY_HEAL")) or "Healing potion"
_G["BINDING_NAME_CLICK MidnightHelperCombatPotion:LeftButton"] =
	(ns.L and ns:L("POTIONKEY_COMBAT")) or "Combat potion"

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("BAG_UPDATE_DELAYED")
f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
		Build()
		return
	end
	if event == "PLAYER_REGEN_ENABLED" then
		-- Leaving combat: apply whatever we could not set while locked down.
		if pending then
			ApplyItems()
		end
		return
	end
	ApplyItems()
end)

--- `/mh potionkeys` — what the two buttons currently point at, and whether a key is set.
function ns.MH_PotionKeyReport()
	local prefix = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH:")
	Build()
	for _, def in ipairs(BUTTONS) do
		local itemID, itemName = WantedItem(def.category)
		local command = ("CLICK %s:LeftButton"):format(def.name)
		local key
		if GetBindingKey then
			local okK, k = pcall(GetBindingKey, command)
			key = okK and k or nil
		end
		print(("%s %s \226\128\148 %s | %s"):format(
			prefix,
			tostring(_G["BINDING_NAME_" .. command] or def.category),
			itemID and tostring(itemName or itemID) or ns:L("POTIONKEY_NONE"),
			key and ("|cffffffff" .. key .. "|r") or ns:L("POTIONKEY_UNBOUND")))
	end
	print("   |cff9d9d9d" .. ns:L("POTIONKEY_WHERE") .. "|r")
end
