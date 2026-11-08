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
	Left out on purpose: Battle Shout (costs rage, and a warrior has none out of combat), rogue poisons (items in
	Forever, not spells), Shadow Protection and other situational buffs.
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
		{ choice = { "Blessing of Might", "Blessing of Wisdom", "Blessing of Kings" }, key = "paladinBlessing" },
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
local function PickChoice(list, key)
	local last = Last()[key]
	if last and BestRank(last) then
		return last
	end
	for _, name in ipairs(list) do
		if BestRank(name) then
			return name
		end
	end
	return nil
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

local function Entry(out, id, textKey, showCombat)
	out[#out + 1] = { spell = id, name = SpellName(id), icon = SpellIcon(id), textKey = textKey or "MBUFF_TXT_MISSING",
		showCombat = showCombat and true or false, macroTarget = false }
end

local function Mounted()
	return (IsMounted and IsMounted()) or (UnitOnTaxi and UnitOnTaxi("player")) or false
end

--- Evaluate one def: name to cast (or nil when nothing is needed), and a short reason for /mh buffs.
local function Evaluate(d)
	if d.imbue then
		local name = PickChoice(d.imbue, d.key)
		if not name then
			return nil, "none known"
		end
		local ok, hasMH = pcall(GetWeaponEnchantInfo)
		if ok and hasMH then
			return nil, "weapon buff on"
		end
		return name, "no weapon buff"
	end
	local list = d.choice or { d.buff }
	local name = d.choice and PickChoice(d.choice, d.key) or (BestRank(d.buff) and d.buff)
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
	return name, "missing"
end

--- Called by MissingBuff.lua's ns.GetMissingBuffs on Forever. Same entry shape as there.
function ns.GetForeverMissingBuffs()
	local out = {}
	local token = select(2, UnitClass("player"))
	for _, d in ipairs(DEFS[token] or {}) do
		local name = Evaluate(d)
		if name then
			Entry(out, BestRank(name), d.textKey)
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
			local demon = PickChoice(DEMONS, "warlockDemon")
			if demon then
				Entry(out, BestRank(demon), "MBUFF_TXT_PET", true)
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
		local name, why = Evaluate(d)
		local label = d.buff or table.concat(d.choice or d.imbue, " / ")
		print(("  %s: %s%s"):format(label, why, name and (" -> button casts " .. name .. " (" .. SpellName(BestRank(name)) ..
			", id " .. tostring(BestRank(name)) .. ")") or ""))
	end
	print(("  pet: %s"):format(UnitExists("pet") and (UnitIsDead("pet") and "dead" or "out") or "none"))
	print(("  on the button now: %d"):format(#ns.GetForeverMissingBuffs()))
end
