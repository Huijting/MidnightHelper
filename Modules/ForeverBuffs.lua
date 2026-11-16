local _, ns = ...

--[[
	ForeverBuffs.lua — WoW Forever: the missing-buff button from Midnight, with Forever's own buffs.

	Rob, 8 Nov 2026: "Wat we verder hier ook nog niet hebben is een buffmelding ... In Midnight hebben we een mooie
	knop, die kunnen we indrukken dan. Kan dat bij deze ook?" → proposal → "Ja, bouw alle drie".

	MissingBuff.lua (icon, secure click-to-cast, events) is loaded in Forever too; on Forever its ns.GetMissingBuffs
	asks this file instead of MissingBuffData.lua (retail spell ids, specs, talents: none of that fits Forever).
	Spell ids come from ns.FOREVER_SPELL_IDS (ForeverSpellIds.lua, measured in wago DB2 wowf 1.60.1, all ranks).
	  - A buff counts as present when ANY rank of it, or of a spell that covers it (Prayer of Fortitude, Arcane
	    Brilliance, Gift of the Wild), is on you: another player's buff is fine.
	  - The button casts your HIGHEST known rank.
	  - Where a class has a choice (paladin blessing and aura, mage armor, shaman shield and weapon buff, warlock armor,
	    hunter aspect, warlock demon): the one you cast last wins; before that the first one you know (players choose).
	  - An aura MH cannot read counts as present: a wrong "missing" is worse than none (the ns.Aura rule).
	Left out on purpose: Battle Shout (costs rage, and a warrior has none out of combat), Shadow Protection and other
	situational buffs. Rogue poisons, stones and oils are ITEMS in Forever: since 16 Nov 2026 they have their own block
	(WEAPON_ITEMS), and the button puts the item on the weapon.
	  /mh buffs           per buff: known rank, on you or not, what the button would cast
	  /mh buffs on|off    the same switch as Midnight's setting (ns.db.ui.missingBuff)
]]

if not ns.IS_FOREVER then
	return
end

local IDS = ns.FOREVER_SPELL_IDS or {}

-- One entry per thing to keep up. `buff` = one spell; `choice` = any one of these counts, cast the last one used;
-- `covers` = bigger versions that count too; `imbue` = a main-hand weapon buff (GetWeaponEnchantInfo).
local DEFS = {
	PRIEST = {
		{ buff = "Power Word: Fortitude", covers = { "Prayer of Fortitude" } },
		{ buff = "Inner Fire" },
	},
	MAGE = {
		{ buff = "Arcane Intellect", covers = { "Arcane Brilliance" } },
		{ choice = { "Ice Armor", "Frost Armor", "Mage Armor" }, key = "mageArmor" },
	},
	DRUID = {
		{ buff = "Mark of the Wild", covers = { "Gift of the Wild" } },
		{ buff = "Thorns" },
	},
	WARLOCK = {
		{ choice = { "Demon Armor", "Demon Skin" }, key = "warlockArmor" },
	},
	PALADIN = {
		-- covers (11 Nov 2026): a Greater Blessing (your own or another paladin's) counts as present. Without it a
		-- Greater Blessing of Might on you read as "missing" (found by reading the code, not seen in game).
		{ choice = { "Blessing of Might", "Blessing of Wisdom", "Blessing of Kings" }, key = "paladinBlessing",
			covers = { "Greater Blessing of Might", "Greater Blessing of Wisdom", "Greater Blessing of Kings" } },
		{ choice = { "Devotion Aura", "Retribution Aura", "Concentration Aura" }, key = "paladinAura",
			textKey = "MBUFF_TXT_AURA" },
	},
	SHAMAN = {
		{ choice = { "Lightning Shield", "Water Shield" }, key = "shamanShield", textKey = "MBUFF_TXT_SHIELD" },
		{ imbue = { "Rockbiter Weapon", "Flametongue Weapon", "Frostbrand Weapon", "Windfury Weapon" },
			key = "shamanImbue", textKey = "MBUFF_TXT_IMBUE" },
	},
	HUNTER = {
		{ choice = { "Aspect of the Hawk", "Aspect of the Monkey", "Aspect of the Cheetah", "Aspect of the Pack",
			"Aspect of the Wild", "Aspect of the Beast" }, key = "hunterAspect" },
	},
}

local DEMONS = { "Summon Imp", "Summon Voidwalker", "Summon Succubus", "Summon Felhunter" }

local function Known(id)
	if IsPlayerSpell then
		local ok, k = pcall(IsPlayerSpell, id)
		if ok and k then
			return true
		end
	end
	if IsSpellKnown then
		local ok, k = pcall(IsSpellKnown, id)
		if ok and k then
			return true
		end
	end
	return false
end

--- The highest rank of `name` the player knows (ids are listed low to high), or nil.
local function BestRank(name)
	local ids = IDS[name]
	if not ids then
		return nil
	end
	for i = #ids, 1, -1 do
		if Known(ids[i]) then
			return ids[i]
		end
	end
	return nil
end

--- Is any rank of any of these names on the player? true / false / nil (could not read one: treat as present).
local function HasAny(names)
	local unreadable = false
	for _, name in ipairs(names) do
		for _, id in ipairs(IDS[name] or {}) do
			local has = ns.Aura.HasPlayerAura(id)
			if has == true then
				return true
			elseif has == nil then
				unreadable = true
			end
		end
	end
	if unreadable then
		return nil
	end
	return false
end

local function Last()
	if not ns.db then
		return {}
	end
	ns.db.foreverBuffLast = ns.db.foreverBuffLast or {}
	return ns.db.foreverBuffLast
end

--- The name to cast from a choice: the last one cast (if still known), else the first one known.
--- Second value (12 Nov 2026, for the tooltip that explains the pick): "last" or "first".
local function PickChoice(list, key)
	local last = Last()[key]
	if last and BestRank(last) then
		return last, "last"
	end
	for _, name in ipairs(list) do
		if BestRank(name) then
			return name, "first"
		end
	end
	return nil
end

--- The other names of a choice this player knows (for "cast one of these once and MH offers that one").
local function OthersKnown(list, picked)
	local out = {}
	for _, name in ipairs(list or {}) do
		if name ~= picked and BestRank(name) then
			out[#out + 1] = name
		end
	end
	return out
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and n then
			return n
		end
	end
	return "#" .. tostring(id)
end

local function SpellIcon(id)
	if C_Spell and C_Spell.GetSpellTexture then
		local ok, t = pcall(C_Spell.GetSpellTexture, id)
		if ok and t then
			return t
		end
	end
	return "Interface\\Icons\\INV_Misc_QuestionMark"
end

--- `pick`/`list` (12 Nov 2026): for a choice, why this one ("last"/"first") and the choice's names, so MissingBuff.lua's
--- tooltip can explain the pick (Rob, 11 Nov: "uitleggen welke MH kiest").
local function Entry(out, id, textKey, showCombat, pick, list, picked)
	local e = { spell = id, name = SpellName(id), icon = SpellIcon(id), textKey = textKey or "MBUFF_TXT_MISSING",
		showCombat = showCombat and true or false, macroTarget = false }
	if pick and list then
		local others = {}
		for _, n in ipairs(OthersKnown(list, picked)) do
			others[#others + 1] = SpellName(BestRank(n))
		end
		if #others > 0 then
			e.pickWhy, e.pickOthers = pick, others
		end
	end
	out[#out + 1] = e
end

local function Mounted()
	return (IsMounted and IsMounted()) or (UnitOnTaxi and UnitOnTaxi("player")) or false
end

--- What is in the main hand: "none", "fishing" (a fishing pole: no weapon buff fits on it) or "weapon".
--- Rob, 9 Nov 2026: with a Fishing Pole in his hands the Shaman kept seeing "WEAPON BUFF", and the game will not put
--- one on a pole. Item class 2 (weapon), subclass 20 = fishing pole (Enum.ItemWeaponSubclass.Fishingpole; AFGELEID
--- that Forever keeps the retail numbers, so the Enum is read when the client has it).
local FISHING_SUBCLASS = (Enum and Enum.ItemWeaponSubclass and Enum.ItemWeaponSubclass.Fishingpole) or 20
local function MainHand()
	local id = GetInventoryItemID and GetInventoryItemID("player", 16)
	if not id then
		return "none"
	end
	local info = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if info then
		local ok, _, _, _, _, _, classID, subclassID = pcall(info, id)
		if ok and classID == 2 and subclassID == FISHING_SUBCLASS then
			return "fishing"
		end
	end
	return "weapon"
end

--- Is there a TEMPORARY enchant (stone, oil, poison, shaman imbue) on this weapon slot? true / false / nil (cannot read).
--- 16 Nov 2026 (mh-research, Forever UI source 1.60.1.70938): C_Item.GetWeaponEnchantInfo(slot 0 = MH, 1 = OH) returns
--- entries {hasEnchant, enchantType (0 none, 1 permanent, 2 temporary, 3 imbue), …}; the global GetWeaponEnchantInfo is
--- only a deprecation shim behind the loadDeprecationFallbacks CVar. So the new one first, the old one as fallback, and
--- nil when neither answers: nil never makes a "missing" (the ns.Aura rule).
local function TempEnchant(slotIdx)
	if C_Item and C_Item.GetWeaponEnchantInfo then
		local ok, r = pcall(C_Item.GetWeaponEnchantInfo, slotIdx)
		if ok and type(r) == "table" then
			local list = (r.hasEnchant ~= nil or r.enchantType ~= nil) and { r } or r
			for _, e in ipairs(list) do
				if type(e) == "table" and e.hasEnchant and e.enchantType ~= 1 then
					return true
				end
			end
			return false
		end
	end
	if GetWeaponEnchantInfo then
		local ok, hasMH, _, _, _, hasOH = pcall(GetWeaponEnchantInfo)
		if ok then
			if slotIdx == 0 then
				return hasMH and true or false
			end
			return hasOH and true or false
		end
	end
	return nil
end
ns.ForeverTempEnchant = TempEnchant

--- Evaluate one def: name to cast (or nil when nothing is needed), and a short reason for /mh buffs.
local function Evaluate(d)
	if d.imbue then
		local name, pick = PickChoice(d.imbue, d.key)
		if not name then
			return nil, "none known"
		end
		local hand = MainHand()
		if hand == "fishing" then
			return nil, "fishing pole in hand"
		elseif hand == "none" then
			return nil, "no weapon in main hand"
		end
		local has = TempEnchant(0)
		if has == nil then
			return nil, "cannot read the weapon buff (counted as present)"
		elseif has then
			return nil, "weapon buff on"
		end
		return name, "no weapon buff", pick
	end
	local list = d.choice or { d.buff }
	local name, pick
	if d.choice then
		name, pick = PickChoice(d.choice, d.key)
	else
		name = BestRank(d.buff) and d.buff or nil
	end
	if not name then
		return nil, "not learned"
	end
	local look = {}
	for _, n in ipairs(list) do
		look[#look + 1] = n
	end
	for _, n in ipairs(d.covers or {}) do
		look[#look + 1] = n
	end
	local has = HasAny(look)
	if has == nil then
		return nil, "cannot read your buffs here (counted as present)"
	elseif has then
		return nil, "on you"
	end
	return name, "missing", pick
end

--------------------------------------------------------------------------------
-- Weapon ITEMS: sharpening stones, weightstones, oils, rogue poisons (16 Nov 2026).
-- Rob (via sparring), at a Rough Sharpening Stone in his bags: "kunnen we daar ook een waarschuwing voor krijgen als we
-- deze hebben en een juiste wapen hebben equiped om het te gebruiken en het er nog niet op zit ?" → stones only or also
-- oils and poisons: "alles :)".
-- Shown when: the item is in your bags, your level is high enough (poisons: rogue only), the weapon in that hand fits
-- it, and that hand has NO temporary enchant yet (Rob: "het er nog niet op zit"). Click = the item on that weapon
-- (type=item + target-slot, SecureTemplates.lua forever branch; out of combat only, like every click here).
-- All ids, levels and weapon masks GEMETEN by mh-research in wago DB2 wowf 1.60.1.70938 (ItemSparse, ItemXItemEffect,
-- SpellEquippedItems): sharp mask 33219, blunt 9264, Elemental 42483, poisons + Shadow/Frost Oil 173555, wizard/mana
-- oils by inventory type (any one-hand/2H/MH/OH weapon). Left out: Blackfathom Sharpening Stone (works only in BFD),
-- Oil of Immolation (a shield on you, not a weapon buff), warlock firestone/spellstone and mage imbue scrolls (class
-- items; not asked). Situational ones (Consecrated stone, Blessed Wizard Oil: vs undead) come last.
-- Order inside a kind = best first, so the button offers your best one.
--------------------------------------------------------------------------------
local W_SHARP = { [0] = true, [1] = true, [6] = true, [7] = true, [8] = true, [15] = true }
local W_BLUNT = { [4] = true, [5] = true, [10] = true, [13] = true }
local W_MELEE = { [0] = true, [1] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [10] = true,
	[13] = true, [15] = true }
local W_MELEE_SPEAR = { [17] = true }
for k in pairs(W_MELEE) do
	W_MELEE_SPEAR[k] = true
end
-- Wizard/mana oils: any weapon in a hand slot except ranged ones and the fishing pole (AFGELEID from the inventory-type
-- mask: no subclass limit; the pole is left out on purpose, as for the shaman imbue).
local W_OIL = { [11] = true, [12] = true }
for k in pairs(W_MELEE_SPEAR) do
	W_OIL[k] = true
end

local WEAPON_ITEMS = {
	-- rogue poisons (class ROGUE, AllowableClass 8)
	{ id = 8928, lvl = 60, fit = W_MELEE_SPEAR, rogue = true }, { id = 20844, lvl = 60, fit = W_MELEE_SPEAR, rogue = true },
	{ id = 8927, lvl = 52, fit = W_MELEE_SPEAR, rogue = true }, { id = 10922, lvl = 56, fit = W_MELEE_SPEAR, rogue = true },
	{ id = 8985, lvl = 54, fit = W_MELEE_SPEAR, rogue = true }, { id = 9186, lvl = 52, fit = W_MELEE_SPEAR, rogue = true },
	{ id = 3776, lvl = 50, fit = W_MELEE_SPEAR, rogue = true }, { id = 10921, lvl = 48, fit = W_MELEE_SPEAR, rogue = true },
	{ id = 8984, lvl = 46, fit = W_MELEE_SPEAR, rogue = true }, { id = 8926, lvl = 44, fit = W_MELEE_SPEAR, rogue = true },
	{ id = 10920, lvl = 40, fit = W_MELEE_SPEAR, rogue = true }, { id = 2893, lvl = 38, fit = W_MELEE_SPEAR, rogue = true },
	{ id = 6951, lvl = 38, fit = W_MELEE_SPEAR, rogue = true }, { id = 6950, lvl = 36, fit = W_MELEE_SPEAR, rogue = true },
	{ id = 10918, lvl = 32, fit = W_MELEE_SPEAR, rogue = true }, { id = 2892, lvl = 30, fit = W_MELEE_SPEAR, rogue = true },
	{ id = 6949, lvl = 28, fit = W_MELEE_SPEAR, rogue = true }, { id = 5237, lvl = 24, fit = W_MELEE_SPEAR, rogue = true },
	{ id = 6947, lvl = 20, fit = W_MELEE_SPEAR, rogue = true }, { id = 3775, lvl = 20, fit = W_MELEE_SPEAR, rogue = true },
	-- sharpening stones (sharp weapons; Elemental fits every melee weapon)
	{ id = 18262, lvl = 50, fit = W_MELEE }, { id = 287980, lvl = 1, fit = W_MELEE },
	{ id = 12404, lvl = 35, fit = W_SHARP }, { id = 7964, lvl = 25, fit = W_SHARP }, { id = 2871, lvl = 15, fit = W_SHARP },
	{ id = 2863, lvl = 5, fit = W_SHARP }, { id = 2862, lvl = 1, fit = W_SHARP }, { id = 287978, lvl = 1, fit = W_SHARP },
	-- weightstones (blunt weapons)
	{ id = 12643, lvl = 35, fit = W_BLUNT }, { id = 7965, lvl = 25, fit = W_BLUNT }, { id = 3241, lvl = 15, fit = W_BLUNT },
	{ id = 3240, lvl = 5, fit = W_BLUNT }, { id = 3239, lvl = 1, fit = W_BLUNT },
	-- oils
	{ id = 20749, lvl = 45, fit = W_OIL }, { id = 20748, lvl = 45, fit = W_OIL }, { id = 20750, lvl = 40, fit = W_OIL },
	{ id = 20747, lvl = 40, fit = W_OIL }, { id = 20746, lvl = 30, fit = W_OIL }, { id = 287979, lvl = 1, fit = W_OIL },
	{ id = 20745, lvl = 20, fit = W_OIL }, { id = 20744, lvl = 5, fit = W_OIL },
	{ id = 3829, lvl = 30, fit = W_MELEE_SPEAR }, { id = 3824, lvl = 24, fit = W_MELEE_SPEAR },
	-- situational (vs undead): only when nothing else fits
	{ id = 23122, lvl = 50, fit = W_OIL }, { id = 23123, lvl = 50, fit = W_OIL },
}

local function ItemCount(id)
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return 0
	end
	local ok, n = pcall(fn, id)
	return (ok and tonumber(n)) or 0
end

local function ItemName(id)
	local fn = (C_Item and C_Item.GetItemNameByID) or nil
	if fn then
		local ok, n = pcall(fn, id)
		if ok and n then
			return n
		end
	end
	if GetItemInfo then
		local ok, n = pcall(GetItemInfo, id)
		if ok and n then
			return n
		end
	end
	return "item #" .. tostring(id)
end

local function ItemIcon(id)
	local info = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if info then
		local ok, _, _, _, _, icon = pcall(info, id)
		if ok and icon then
			return icon
		end
	end
	return "Interface\\Icons\\INV_Misc_QuestionMark"
end

--- The weapon subclass in this inventory slot (16/17), or nil plus a reason.
local function WeaponSubclass(invSlot)
	local id = GetInventoryItemID and GetInventoryItemID("player", invSlot)
	if not id then
		return nil, "no weapon"
	end
	local info = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not info then
		return nil, "cannot read the weapon"
	end
	local ok, _, _, _, _, _, classID, subclassID = pcall(info, id)
	if not ok then
		return nil, "cannot read the weapon"
	end
	if classID ~= 2 then
		return nil, "not a weapon (shield or off-hand item)"
	end
	if subclassID == FISHING_SUBCLASS then
		return nil, "fishing pole"
	end
	return subclassID
end

--- For one hand: the item to put on it (def), or nil; plus a reason for /mh buffs.
local function PickWeaponItem(invSlot, isRogue, level)
	local sub, why = WeaponSubclass(invSlot)
	if not sub then
		return nil, why
	end
	local has = TempEnchant(invSlot == 16 and 0 or 1)
	if has == nil then
		return nil, "cannot read what is on the weapon (counted as present)"
	elseif has then
		return nil, "something is on it already"
	end
	local carried, fitsNot = 0, 0
	for _, d in ipairs(WEAPON_ITEMS) do
		if ItemCount(d.id) > 0 and (isRogue or not d.rogue) then
			carried = carried + 1
			if level < (d.lvl or 1) then
				fitsNot = fitsNot + 1
			elseif not d.fit[sub] then
				fitsNot = fitsNot + 1
			else
				return d, "nothing on it, you carry " .. ItemName(d.id)
			end
		end
	end
	if carried == 0 then
		return nil, "nothing on it, but you carry no stone/oil" .. (isRogue and "/poison" or "")
	end
	return nil, ("nothing on it; %d item(s) in your bags, none fits this weapon or your level"):format(fitsNot)
end

local function WeaponItemEntry(out, d, invSlot)
	out[#out + 1] = { item = d.id, slot = invSlot, name = ItemName(d.id), icon = ItemIcon(d.id),
		textKey = invSlot == 16 and "MBUFF_TXT_WEAPONITEM" or "MBUFF_TXT_WEAPONITEM_OH", showCombat = false,
		macroTarget = false }
end

--- Called by MissingBuff.lua's ns.GetMissingBuffs on Forever. Same entry shape as there.
function ns.GetForeverMissingBuffs()
	local out = {}
	local token = select(2, UnitClass("player"))
	local shamanImbueOffered = false
	for _, d in ipairs(DEFS[token] or {}) do
		local name, _, pick = Evaluate(d)
		if name then
			Entry(out, BestRank(name), d.textKey, nil, pick, d.choice or d.imbue, name)
			if d.imbue then
				shamanImbueOffered = true
			end
		end
	end
	-- Weapon items (stones, oils, poisons). A shaman whose imbue is offered for the main hand gets no item there: the
	-- spell costs nothing (bouwchat's choice, 16 Nov 2026). Not while mounted (you would not stop for it).
	if not Mounted() then
		local level = UnitLevel and UnitLevel("player") or 1
		local isRogue = token == "ROGUE"
		if not shamanImbueOffered then
			local d = PickWeaponItem(16, isRogue, level)
			if d then
				WeaponItemEntry(out, d, 16)
			end
		end
		local d2 = PickWeaponItem(17, isRogue, level)
		if d2 then
			WeaponItemEntry(out, d2, 17)
		end
	end
	-- Pets: a hunter or warlock who can call one and has none (not while mounted: the pet is gone then anyway).
	if not Mounted() then
		local hasPet = UnitExists("pet")
		local dead = hasPet and UnitIsDead("pet")
		if token == "HUNTER" and BestRank("Call Pet") then
			if not hasPet then
				Entry(out, BestRank("Call Pet"), "MBUFF_TXT_PET", true)
			elseif dead and BestRank("Revive Pet") then
				Entry(out, BestRank("Revive Pet"), "MBUFF_TXT_PET_DEAD", true)
			end
		elseif token == "WARLOCK" and not hasPet then
			local demon, pick = PickChoice(DEMONS, "warlockDemon")
			if demon then
				Entry(out, BestRank(demon), "MBUFF_TXT_PET", true, pick, DEMONS, demon)
			end
		end
	end
	return out
end

-- Remember the choice the player made: any rank of a choice spell cast by you becomes that choice's default.
local CHOICE_OF = {}
do
	local function add(list, key)
		for _, name in ipairs(list) do
			for _, id in ipairs(IDS[name] or {}) do
				CHOICE_OF[id] = { key = key, name = name }
			end
		end
	end
	for _, defs in pairs(DEFS) do
		for _, d in ipairs(defs) do
			if d.choice or d.imbue then
				add(d.choice or d.imbue, d.key)
			end
		end
	end
	add(DEMONS, "warlockDemon")
end

local castEv = CreateFrame("Frame")
castEv:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
castEv:SetScript("OnEvent", function(_, _, _, _, spellID)
	if issecretvalue and issecretvalue(spellID) then
		return
	end
	local c = CHOICE_OF[spellID]
	if c and ns.db then
		Last()[c.key] = c.name
	end
end)

--- /mh buffs: per buff what MH decided and why; on|off is the Midnight setting's switch.
function ns.ForeverBuffsSlash(arg)
	arg = (arg or ""):lower()
	local P = "|cffffcc00Midnight Helper:|r "
	if arg == "on" or arg == "off" then
		if ns.SetMissingBuffEnabled then
			ns.SetMissingBuffEnabled(arg == "on")
		end
		print(P .. ns:L(arg == "on" and "FBUFF_ON" or "FBUFF_OFF"))
		return
	end
	local token = select(2, UnitClass("player"))
	local on = not (ns.IsMissingBuffEnabled and ns.IsMissingBuffEnabled() == false)
	print(P .. ("buffs: %s, class %s, auras readable %s (/mh buffs on||off)"):format(on and "on" or "off",
		tostring(token), tostring(ns.Aura and ns.Aura.Trusted and ns.Aura.Trusted())))
	local defs = DEFS[token] or {}
	if #defs == 0 then
		print("  no buffs on the list for this class (on purpose: see ForeverBuffs.lua)")
	end
	for _, d in ipairs(defs) do
		local name, why, pick = Evaluate(d)
		local label = d.buff or table.concat(d.choice or d.imbue, " / ")
		print(("  %s: %s%s%s"):format(label, why, name and (" -> button casts " .. name .. " (" .. SpellName(BestRank(name)) ..
			", id " .. tostring(BestRank(name)) .. ")") or "",
			pick and (pick == "last" and " [cast last]" or " [none cast yet: first one known]") or ""))
	end
	print(("  pet: %s"):format(UnitExists("pet") and (UnitIsDead("pet") and "dead" or "out") or "none"))
	-- Weapon items (16 Nov 2026): per hand the weapon type, whether something is on it, and the decision.
	local level = UnitLevel and UnitLevel("player") or 1
	local api = (C_Item and C_Item.GetWeaponEnchantInfo) and "C_Item.GetWeaponEnchantInfo"
		or (GetWeaponEnchantInfo and "GetWeaponEnchantInfo (old)") or "none (cannot read: silent)"
	print("  weapon items (stones/oils/poisons), read via " .. api .. ":")
	for _, slot in ipairs({ 16, 17 }) do
		local sub = WeaponSubclass(slot)
		local d, why = PickWeaponItem(slot, token == "ROGUE", level)
		print(("    %s: weapon type %s; %s%s"):format(slot == 16 and "main hand" or "off hand", tostring(sub), why,
			d and (" -> button puts item " .. d.id .. " on slot " .. slot) or ""))
	end
	local now = ns.GetForeverMissingBuffs()
	print(("  missing now: %d (the big icon casts the first; the small ones beside it are next)"):format(#now))
	if now[1] and ns.MissingBuffSentence then
		local inCombat = InCombatLockdown and InCombatLockdown()
		print("  line under the icon: " .. ns.MissingBuffSentence(now[1], inCombat))
	end
end
