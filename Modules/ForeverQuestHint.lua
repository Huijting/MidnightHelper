local _, ns = ...

--[[
	ForeverQuestHint.lua — WoW Forever: which quest reward to take, and WHY, in one line.

	Rob, 7 Nov 2026: "En de doe de quest beloning tip maar ook" (idea 1 of docs/forever/REVIEW_GEARQUEST_2026-11-07.md).
	MH's angle is the explanation: GearQuest and Zygor put an arrow or a glow on a reward; MH says why.

	When a quest offers a choice (QUEST_COMPLETE, GetNumQuestChoices() > 1):
	  - every reward the game marks usable for you (GetQuestItemInfo's isUsable) and that you can wear is compared with
	    what you wear in that slot, on YOUR class's main stats (ns.FOREVER_MAIN_STATS, sourced in
	    docs/forever/FOREVER_MAIN_STATS_2026-11-07.md); Stamina breaks a tie;
	  - the biggest gain gets a green frame on its button and a line under the quest window:
	    "Take <item>: +5 Agility (your main stat as a Rogue) over what you wear";
	  - no gain for you: the one that sells for the most, said so plainly.
	Nothing is ever picked or clicked for you. Players choose: /mh questhint off turns it off; /mh questhint check prints
	the last decision per reward (a module whose normal result is silence needs that, CLAUDE.md).

	Ideas only from GearQuest (All Rights Reserved) and Zygor: no code or data taken. Item data can arrive a moment after
	the window opens, so it retries a few times (Zygor does the same; AFGELEID that Forever needs it).
	English only, like the other Forever texts.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local STAT_KEY = {
	STRENGTH = "ITEM_MOD_STRENGTH_SHORT", AGILITY = "ITEM_MOD_AGILITY_SHORT", INTELLECT = "ITEM_MOD_INTELLECT_SHORT",
	SPIRIT = "ITEM_MOD_SPIRIT_SHORT", STAMINA = "ITEM_MOD_STAMINA_SHORT",
}
local STAT_NAME = { STRENGTH = "Strength", AGILITY = "Agility", INTELLECT = "Intellect", SPIRIT = "Spirit",
	STAMINA = "Stamina" }

-- equipLoc → the inventory slot(s) it would replace (two for rings, trinkets and one-hand weapons).
local SLOTS = {
	INVTYPE_HEAD = { 1 }, INVTYPE_NECK = { 2 }, INVTYPE_SHOULDER = { 3 }, INVTYPE_BODY = { 4 }, INVTYPE_CHEST = { 5 },
	INVTYPE_ROBE = { 5 }, INVTYPE_WAIST = { 6 }, INVTYPE_LEGS = { 7 }, INVTYPE_FEET = { 8 }, INVTYPE_WRIST = { 9 },
	INVTYPE_HAND = { 10 }, INVTYPE_FINGER = { 11, 12 }, INVTYPE_TRINKET = { 13, 14 }, INVTYPE_CLOAK = { 15 },
	INVTYPE_WEAPON = { 16, 17 }, INVTYPE_2HWEAPON = { 16 }, INVTYPE_WEAPONMAINHAND = { 16 },
	INVTYPE_WEAPONOFFHAND = { 17 }, INVTYPE_SHIELD = { 17 }, INVTYPE_HOLDABLE = { 17 }, INVTYPE_RANGED = { 18 },
	INVTYPE_RANGEDRIGHT = { 18 }, INVTYPE_THROWN = { 18 }, INVTYPE_RELIC = { 18 },
}

local function Enabled()
	return not (ns.db and ns.db.foreverQuestHint == false)
end

local function Token()
	local _, token = UnitClass("player")
	return token
end

local function ClassName(token)
	local names = LOCALIZED_CLASS_NAMES_MALE
	return (names and names[token]) or (token and (token:sub(1, 1) .. token:sub(2):lower())) or "?"
end

--- Coins with their icons. Rob's screenshot showed "(9)": the global GetCoinTextureString is not there on Forever
--- (AFGELEID from that "(9)"); C_CurrencyInfo's is what the trainer window already uses and Rob saw it work there.
local function Money(c)
	if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
		local ok, s = pcall(C_CurrencyInfo.GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	if GetCoinTextureString then
		return GetCoinTextureString(c)
	end
	return tostring(c) .. "c"
end

local function StatName(k)
	local g = _G[STAT_KEY[k]]
	return (type(g) == "string" and g ~= "") and g or STAT_NAME[k]
end

--- name, quality, equipLoc, sellPrice for a link; nil while the client has not loaded it.
local function ItemInfo(link)
	local fn = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	if not (fn and link) then
		return nil
	end
	local ok, name, _, quality, _, _, _, _, _, equipLoc, _, sellPrice = pcall(fn, link)
	if not ok or not name then
		return nil
	end
	return name, quality, equipLoc, sellPrice or 0
end

--- 🔴 ARMOR — Rob, 7 Nov 2026 (screenshot, "denk dat het niet goed gaat ?!?"): Snow Boots (7 armor) against worn boots
--- (2 armor), no stats on either reward, and MH said "none is better". At low level armor is often the ONLY
--- difference. Read it from the stats table (RESISTANCE0_NAME, the classic key; GEMETEN in Forever by Rob, 19 Nov 2026:
--- /dump GetItemStats of his gloves = { RESISTANCE0_NAME = 4 }) or else from the
--- item's tooltip line ("%s Armor", Blizzard's ARMOR_TEMPLATE; the approach Zygor uses, and C_TooltipInfo.GetHyperlink
--- is what Baganator/Syndicator/Auctionator use on Forever — candidates, not proof).
local function Armor(link, t)
	local v = t and t.RESISTANCE0_NAME
	if type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
		return v
	end
	if not (C_TooltipInfo and C_TooltipInfo.GetHyperlink and link) then
		return 0
	end
	local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then
		return 0
	end
	local tpl = type(ARMOR_TEMPLATE) == "string" and ARMOR_TEMPLATE or "%s Armor"
	local pat = "^" .. tpl:gsub("([%(%)%.%+%-%*%?%[%]%^%$])", "%%%1"):gsub("%%s", "([%%d,%%.]+)") .. "$"
	for _, line in ipairs(data.lines) do
		local txt = line.leftText
		if type(txt) == "string" and not (issecretvalue and issecretvalue(txt)) then
			local n = txt:match(pat)
			if n then
				return tonumber((n:gsub("[,%.]", ""))) or 0
			end
		end
	end
	return 0
end

--- Damage per second of a weapon, or nil (not a weapon / not readable). Option A, 18 Nov 2026. The stats table first
--- (ITEM_MOD_DAMAGE_PER_SECOND_SHORT, GEMETEN in Forever GlobalStrings 19881; GetItemStats FILLS it in Forever, GEMETEN by
--- Rob 19 Nov 2026: his main hand gave { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2.58… }), else the tooltip line "(%s damage per second)" (DPS_TEMPLATE, GEMETEN GlobalStrings 12672; that the
--- weapon tooltip uses it is AFGELEID — the same way Armor() reads ARMOR_TEMPLATE).
local function Dps(link, t)
	local v = t and t.ITEM_MOD_DAMAGE_PER_SECOND_SHORT
	if type(v) == "number" and not (issecretvalue and issecretvalue(v)) and v > 0 then
		return v
	end
	if not (C_TooltipInfo and C_TooltipInfo.GetHyperlink and link) then
		return nil
	end
	local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then
		return nil
	end
	local tpl = type(DPS_TEMPLATE) == "string" and DPS_TEMPLATE or "(%s damage per second)"
	local pat = "^" .. tpl:gsub("([%(%)%.%+%-%*%?%[%]%^%$])", "%%%1"):gsub("%%s", "([%%d,%%.]+)") .. "$"
	for _, line in ipairs(data.lines) do
		for _, txt in ipairs({ line.leftText, line.rightText }) do
			if type(txt) == "string" and not (issecretvalue and issecretvalue(txt)) then
				local n = txt:match(pat)
				if n then
					-- "12,5" / "12.5" / "1,234.5" / "1.234,5": the LAST separator, followed by one or two digits, is the
					-- decimal mark; every other separator is a thousands mark
					local int, frac = n:match("^(.*)[,%.](%d%d?)$")
					if int then
						n = int:gsub("[,%.]", "") .. "." .. frac
					else
						n = n:gsub("[,%.]", "")
					end
					return tonumber(n)
				end
			end
		end
	end
	return nil
end

--- { STRENGTH = n, ..., ARMOR = n } for a link (the five primary stats + armor). An item without stats (plain cloth
--- boots) still gets its armor: the stats call may return nil for it.
-- Only these can have a "(x damage per second)" line: no tooltip read for a ring, a helm or a shield.
local WEAPON_LOC = { INVTYPE_WEAPON = true, INVTYPE_2HWEAPON = true, INVTYPE_WEAPONMAINHAND = true,
	INVTYPE_WEAPONOFFHAND = true, INVTYPE_RANGED = true, INVTYPE_RANGEDRIGHT = true, INVTYPE_THROWN = true }

local function Stats(link, equipLoc)
	if not link then
		return nil
	end
	local fn = (C_Item and C_Item.GetItemStats) or GetItemStats
	local t
	if fn then
		local ok, res = pcall(fn, link)
		t = (ok and type(res) == "table") and res or nil
	end
	t = t or {}
	local out = {}
	for k, key in pairs(STAT_KEY) do
		local v = t[key]
		if type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
			out[k] = v
		end
	end
	out.ARMOR = Armor(link, t)
	out.DPS = WEAPON_LOC[equipLoc] and Dps(link, t) or nil
	-- 25 Nov 2026 (Rob via Sparring, after his own /dump: Ley Staff 9513 gave ITEM_MOD_SPELL_POWER_SHORT = 2 next to
	-- Intellect 1, Spirit 1 and DPS 5.34 — GEMETEN by Rob in Forever; the plain GetItemStats is nil there). SPELL = spell
	-- damage ("damage and healing done by magical spells"). Other spell-ish keys (a healing-only or one-school line) are
	-- NOT known yet (no /dump of such an item): MH notes them as `spellUnknown` and then gives no verdict for a role that
	-- weighs spell damage (IsBetter), rather than a wrong "better". DB2 note: Ley Staff has no spell power row in
	-- ItemSparse (only Spirit and Intellect): the client makes it (the caster-weapon conversion, ~74% DPS).
	-- Rob's four dumps (25 Nov 2026, GEMETEN): 7049 Truefaith Gloves SPELL_HEALING_DONE 15 + SPELL_DAMAGE_DONE 5;
	-- 19395 Rejuvenating Gem SPELL_HEALING_DONE 66 + MANA_REGENERATION 9; 2231 Inferno Robe FIRE_DAMAGE_DONE 23; 2311
	-- White Leather Jerkin SPELL_POWER 2 (stat type 45 on leather is real spell power). The other schools' keys are
	-- GEMETEN in GlobalStrings 71091 (ITEM_MOD_<SCHOOL>_DAMAGE_DONE_SHORT), not yet seen on an item.
	local function Num(key)
		local v = t[key]
		if type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
			return v
		end
		return nil
	end
	out.SPELL = Num("ITEM_MOD_SPELL_POWER_SHORT") -- damage and healing
	out.HEAL = Num("ITEM_MOD_SPELL_HEALING_DONE_SHORT") -- healing only
	out.SDMG = Num("ITEM_MOD_SPELL_DAMAGE_DONE_SHORT") -- damage only
	out.MP5 = Num("ITEM_MOD_MANA_REGENERATION_SHORT")
	local KNOWN = { ITEM_MOD_SPELL_POWER_SHORT = true, ITEM_MOD_SPELL_HEALING_DONE_SHORT = true,
		ITEM_MOD_SPELL_DAMAGE_DONE_SHORT = true }
	for key, v in pairs(t) do
		if type(key) == "string" and type(v) == "number" then
			local school = key:match("^ITEM_MOD_(%u+)_DAMAGE_DONE_SHORT$")
			if school and school ~= "SPELL" then
				out.school = out.school or {}
				out.school[school] = v
			elseif not KNOWN[key] and (key:find("SPELL", 1, true) or key:find("HEAL", 1, true)) then
				out.spellUnknown = out.spellUnknown or {}
				out.spellUnknown[#out.spellUnknown + 1] = key
			end
		end
	end
	-- 🔴 25 Nov 2026 (Rob via Sparring: "Ja, op 1 en 2"). The ENCHANT counts too. Rob's Druid wore Nomadic Gloves (21
	-- armor) with a Light Armor Kit (enchant 15 = Armor +8, Stamina +1); grey Worn Leather Gloves (22 armor) in his bag
	-- were called "+1 Armor over what you wear" - swapping loses the kit: really -7 Armor, -1 Stamina. GEMETEN on that
	-- screenshot: the item's own armor (GetItemStats / the "%s Armor" line) leaves the kit out. Enchant = field 2 of the
	-- link; what it adds = ns.FOREVER_ENCH_STATS (ForeverEnchantData.lua, from DB2). x = a part MH cannot weigh.
	local e = tonumber(link:match("item:%-?%d+:(%d*)") or "")
	if e and e > 0 then
		local es = ns.FOREVER_ENCH_STATS and ns.FOREVER_ENCH_STATS[e]
		out.ench = { id = e, x = (not es) or es.x == 1 }
		for k, v in pairs(es or {}) do
			if k ~= "x" and type(v) == "number" then
				out[k] = (out[k] or 0) + v
			end
		end
	end
	return out
end

local WEIGHT = { 1, 0.5 } -- first main stat counts fully, the second half (ForeverMainStats.lua header; AFGELEID)

-- How much 1 point of spell damage counts in the score, for the def in use (ForeverMainStats.lua `spellW`; 0 = not at
-- all). Set by MainFor, which every verdict calls first. AFGELEID weights: 1 = like your first main stat (casters and
-- healers: on these items 1 spell damage is worth at least 1 Intellect for the spells themselves — a cautious 1, not
-- more), 0.5 = like a second stat (Retribution, Protection after Stamina). Not measured; the point is the direction.
local curSpellW = 0
local curHeal = false -- the role heals: Spell Healing counts, Spell Damage does not
local curSchools = {} -- schools whose own damage line counts for this spec (ForeverMainStats.lua `schools`)

--- The spell value of a stats table for the role in use: spell power (damage AND healing) plus, for a healer, the
--- healing-only line and half the mana per 5 seconds (AFGELEID, "small"); for a damage role the damage-only line and
--- the lines of the schools this spec casts.
local function SpellValue(stats)
	if not stats then
		return 0
	end
	local v = stats.SPELL or 0
	if curHeal then
		v = v + (stats.HEAL or 0) + 0.5 * (stats.MP5 or 0)
	else
		v = v + (stats.SDMG or 0)
		for school, n in pairs(stats.school or {}) do
			if curSchools[school] then
				v = v + n
			end
		end
	end
	return v
end

--- A spell line MH does not weigh for this role: an unknown key, or a school line this spec does not cast (a Fire line
--- for a Frost Mage, any school line for a healer). Then: no verdict (rather silent than a wrong "better").
local function SpellUnweighable(stats)
	if not stats then
		return nil
	end
	if stats.spellUnknown then
		return table.concat(stats.spellUnknown, "/")
	end
	for school in pairs(stats.school or {}) do
		if curHeal or not curSchools[school] then
			return school .. " damage line (not your spec's school)"
		end
	end
	return nil
end

--- This character's main stats: the `later` order once its talent is known (Mental Dexterity, Careful Aim, ...).
local function MainFor(def)
	curSpellW = (def and def.spellW) or 0
	curHeal = (def and def.role == "heal") or false
	curSchools = {}
	for _, s in ipairs((def and def.schools) or {}) do
		curSchools[s] = true
	end
	if not def then
		return nil
	end
	if def.later and ns.ForeverKnownSpell and ns.ForeverKnownSpell(def.later.talent) then
		return def.later.main
	end
	-- 16 Nov 2026: a role row where the guides disagree counts both stats the same (ForeverMainStats.lua, choice 3).
	if def.equal then
		def.main.equal = true
	end
	return def.main
end

--- The stat def for this character: by direction/role since 16 Nov 2026 (ns.ForeverStatDef), else the class table.
local function StatDef(token)
	if ns.ForeverStatDef then
		return (ns.ForeverStatDef(token))
	end
	return ns.FOREVER_MAIN_STATS and ns.FOREVER_MAIN_STATS[token]
end

--- Weighted main-stat score and the Stamina tie-breaker of a stats table.
local function Score(stats, main, stamTie)
	local s, staInMain = 0, false
	for i, k in ipairs(main or {}) do
		local w = (main.equal and i == 2) and 1 or (WEIGHT[i] or 0)
		s = s + ((stats and stats[k]) or 0) * w
		if k == "STAMINA" then
			staInMain = true
		end
	end
	local tie = (stamTie and not staInMain) and ((stats and stats.STAMINA) or 0) or 0
	if curSpellW > 0 then
		s = s + SpellValue(stats) * curSpellW
	end
	return s, tie
end

--- What the player wears in ONE slot: main score, stamina, armor, stats, link, equipLoc.
local function WornSlot(slot, main, stamTie)
	local link = GetInventoryItemLink and GetInventoryItemLink("player", slot)
	local _, _, loc = ItemInfo(link)
	local stats = link and Stats(link, loc) or {}
	local s, sta = Score(stats, main, stamTie)
	return { s = s, sta = sta, arm = stats.ARMOR or 0, dps = stats.DPS, stats = stats, link = link, slot = slot,
		equipLoc = loc, enchs = { stats.ench } }
end

-- Option A (Rob via sparring: "Ja", 18 Nov 2026). The old rule compared a one-hand weapon with the WEAKER of both hands,
-- and an empty off-hand counted as 0: with a two-hander nearly every one-hand weapon looked "better", also for classes
-- that cannot wield two weapons (Fable research, docs/forever/BETER_DAN_WAT_JE_DRAAGT_2026-11-18.md). Now:
local OFFHAND_WEAPON = { INVTYPE_WEAPON = true, INVTYPE_WEAPONOFFHAND = true }
local DUAL_WIELD = 674 -- GEMETEN DB2 SpellName 1.60.1.70959 "Dual Wield"

local function CanDualWield()
	-- the client's own answer first (C_SpellBook.IsSpellKnown: documented in Forever 1.60.1.70959)
	if C_SpellBook and C_SpellBook.IsSpellKnown then
		local ok, k = pcall(C_SpellBook.IsSpellKnown, DUAL_WIELD)
		if ok and k == true then
			return true
		end
	end
	if ns.ForeverKnownSpell then
		local ok, k = pcall(ns.ForeverKnownSpell, DUAL_WIELD)
		if ok and k then
			return true
		end
	end
	if IsPlayerSpell then
		local ok, k = pcall(IsPlayerSpell, DUAL_WIELD)
		if ok and k then
			return true
		end
	end
	return false
end

--- Two worn pieces as one (a two-hander replaces main hand AND off-hand).
local function Sum(a, b)
	local stats = {}
	for _, x in ipairs({ a, b }) do
		for k, v in pairs(x.stats or {}) do
			if type(v) == "number" and k ~= "DPS" then
				stats[k] = (stats[k] or 0) + v
			end
		end
	end
	-- DPS of both hands together: an empty main hand does 0; a second weapon counts in full (how much an off-hand
	-- weapon really adds in Forever is not measured, so a two-hander is only called "more DPS" when it beats both).
	local dps
	if not a.link then
		dps = b.dps or 0
	elseif a.dps then
		dps = a.dps + (b.dps or 0)
	end
	local enchs = {}
	for _, x in ipairs({ a, b }) do
		for _, en in ipairs(x.enchs or {}) do
			enchs[#enchs + 1] = en
		end
		if x.stats and x.stats.spellUnknown then
			stats.spellUnknown = x.stats.spellUnknown
		end
		for school, n in pairs((x.stats and x.stats.school) or {}) do
			stats.school = stats.school or {}
			stats.school[school] = (stats.school[school] or 0) + n
		end
	end
	return { s = a.s + b.s, sta = a.sta + b.sta, arm = a.arm + b.arm, dps = dps, stats = stats,
		link = a.link or b.link, slot = a.slot, equipLoc = a.equipLoc, enchs = enchs }
end

--- What a new item of this equipLoc would replace: main score, stamina, armor, stats, link, slot. nil = no fair
--- comparison (an off-hand item while you wear a two-hander: then you would give up the two-hander for it).
local function Worn(equipLoc, main, stamTie)
	if not SLOTS[equipLoc] then
		return nil
	end
	local first = SLOTS[equipLoc][1]
	local mh = (first == 16 or first == 17) and WornSlot(16, main, stamTie) or nil -- a ring never needs your weapon
	local twoHanderWorn = mh ~= nil and mh.equipLoc == "INVTYPE_2HWEAPON"
	if equipLoc == "INVTYPE_2HWEAPON" then
		-- replaces both hands: compare with what you hold in both together
		return twoHanderWorn and mh or Sum(mh, WornSlot(17, main, stamTie))
	elseif equipLoc == "INVTYPE_WEAPON" then
		if twoHanderWorn or not CanDualWield() then
			return mh -- only the main hand counts
		end
		local oh = WornSlot(17, main, stamTie)
		if not oh.link then
			return (mh.link and oh) or mh -- you can dual wield and that hand is empty: it fills the empty hand
		end
		if not OFFHAND_WEAPON[oh.equipLoc] then
			return mh -- a shield or an off-hand item: it would go in the main hand
		end
		local weaker = mh
		if oh.s < mh.s or (oh.s == mh.s and (oh.sta < mh.sta or (oh.sta == mh.sta and (oh.arm < mh.arm
			or (oh.arm == mh.arm and (oh.dps or 0) < (mh.dps or 0)))))) then
			weaker = oh -- same stats (most low-level weapons have none): the one with less DPS is the weaker
		end
		return weaker
	elseif equipLoc == "INVTYPE_WEAPONMAINHAND" then
		return mh
	elseif equipLoc == "INVTYPE_WEAPONOFFHAND" and not CanDualWield() then
		return nil -- this class cannot hold a weapon in the off-hand
	elseif SLOTS[equipLoc][1] == 17 and twoHanderWorn then
		return nil -- shield / off-hand item / off-hand weapon while you hold a two-hander
	end
	local best
	for _, slot in ipairs(SLOTS[equipLoc]) do
		local w = WornSlot(slot, main, stamTie)
		if not best or w.s < best.s or (w.s == best.s and (w.sta < best.sta or (w.sta == best.sta and w.arm < best.arm))) then
			best = w
		end
	end
	return best
end

local last = { at = nil, rows = {}, verdict = "none yet" } -- for /mh questhint check

--- "+3 Strength, +12 Armor" and the reason, for a row { stats, worn, ds, dsta, darm }. Shared by the quest hint and
--- the gear tooltip line, so both say the same thing about the same item.
--- Names the main stats, then Stamina when it breaks ties; each stat once (Warlock has Stamina as a main stat).
local function Explain(row, main, stamTie, token)
	local parts, done, shown = {}, {}, {}
	for _, k in ipairs(main) do
		shown[#shown + 1] = k
	end
	if stamTie then
		shown[#shown + 1] = "STAMINA"
	end
	for _, k in ipairs(shown) do
		if not done[k] then
			done[k] = true
			local gain = ((row.stats and row.stats[k]) or 0)
				- ((row.worn and row.worn.stats and row.worn.stats[k]) or 0)
			if gain ~= 0 then
				parts[#parts + 1] = ("%+d %s"):format(gain, StatName(k))
			end
		end
	end
	-- 25 Nov 2026: spell damage, when this role weighs it; a minus here is the spell damage you would lose.
	if curSpellW > 0 then
		local sg = SpellValue(row.stats) - SpellValue(row.worn and row.worn.stats)
		if math.abs(sg) >= 0.5 then
			-- the client's own word: "Spell Healing" for a healer, "Spell Damage" otherwise (GlobalStrings, GEMETEN)
			local w = _G[curHeal and "ITEM_MOD_SPELL_HEALING_DONE_SHORT" or "ITEM_MOD_SPELL_DAMAGE_DONE_SHORT"]
			w = (type(w) == "string" and w ~= "") and w or ns:L("FDONOW_STAT_SPELLDMG")
			parts[#parts + 1] = ("%+d %s"):format(math.floor(sg + (sg > 0 and 0.5 or -0.5)), w)
		end
	end
	if row.darm and row.darm ~= 0 then
		parts[#parts + 1] = ("%+d %s"):format(row.darm, (type(ARMOR) == "string" and ARMOR) or "Armor")
	end
	if row.ddps and math.abs(row.ddps) >= 0.05 then
		local w = ITEM_MOD_DAMAGE_PER_SECOND_SHORT
		parts[#parts + 1] = ("%+.1f %s"):format(row.ddps, (type(w) == "string" and w ~= "") and w or "damage per second")
	end
	local why
	if row.ds == 0 and row.dsta == 0 then
		why = (row.ddps and row.ddps >= 0.05) and ns:L("FQH_WHY_DPS") or ns:L("FQH_WHY_ARMOR")
	else
		why = ns:L("FQH_WHY_MAIN_FMT"):format(ClassName(token))
	end
	return parts, why
end

--- Does weapon damage count for these main stats? Only for Strength/Agility players (a caster's staff DPS does not).
local function Physical(main)
	for _, k in ipairs(main or {}) do
		if k == "STRENGTH" or k == "AGILITY" then
			return true
		end
	end
	return false
end

--- DPS difference new − worn for a weapon, or nil when it does not count or cannot be read. An empty hand = 0 DPS.
local function DeltaDps(stats, worn, main)
	if not Physical(main) then
		return nil
	end
	local new = stats and stats.DPS
	local old = worn and worn.link and worn.dps or nil
	if not new then
		-- a shield or off-hand item in the place of a weapon (or a weapon whose DPS cannot be read): you lose that damage
		return old and -old or nil
	end
	if worn and worn.link then
		if not worn.dps then
			return nil
		end
		return new - worn.dps
	end
	return new
end

--- Better = more main stats; equal → more Stamina (where it counts); still equal → more armor.
--- Weapons for Strength/Agility players (option A, 18 Nov 2026): never "better" with LESS damage per second; with equal
--- stats, more DPS is better. Stats up and DPS down = mixed: MH stays silent (saying "mixed" is option B).
--- The enchants on what you wear that you would lose (the new item does not carry the same one).
local function Lost(row)
	local out, newE = {}, row.stats and row.stats.ench and row.stats.ench.id
	for _, en in ipairs((row.worn and row.worn.enchs) or {}) do
		if en.id ~= newE then
			out[#out + 1] = en
		end
	end
	return out
end

--- " You lose the enchant on what you wear: Armor +8, Stamina +1." or "".
local function LoseText(row)
	local names = {}
	for _, en in ipairs(Lost(row)) do
		names[#names + 1] = (ns.ForeverEnchantName and ns.ForeverEnchantName(en.id)) or ("#" .. en.id)
	end
	if #names == 0 then
		return ""
	end
	return " " .. ns:L("FGEAR_LOSE_FMT"):format(table.concat(names, ", "))
end

local function IsBetter(row)
	-- An enchant you would lose that MH cannot weigh (a proc, weapon damage, spell power ...): no verdict, like "mixed".
	for _, en in ipairs(Lost(row)) do
		if en.x then
			return false
		end
	end
	-- A spell line MH cannot weigh yet (healing-only, one school) on either item, for a role that weighs spell damage:
	-- no verdict (25 Nov 2026: rather silent than a wrong "better").
	if curSpellW > 0 and (SpellUnweighable(row.stats) or SpellUnweighable(row.worn and row.worn.stats)) then
		return false
	end
	local dd = row.ddps
	if dd and math.abs(dd) < 0.05 then
		dd = 0
	end
	if dd and dd < 0 then
		return false
	end
	if row.ds > 0 then
		return true
	end
	if row.ds < 0 then
		return false
	end
	if dd and dd > 0 then
		return row.dsta >= 0 -- more DPS but less Stamina = mixed too: silent
	end
	return row.dsta > 0 or (row.dsta == 0 and row.darm > 0)
end

--- Is reward row a a better pick than row b? The same order as IsBetter: main stats, then DPS, Stamina, armor.
local function Outranks(a, b)
	if a.ds ~= b.ds then
		return a.ds > b.ds
	end
	local da, db = a.ddps or 0, b.ddps or 0
	if math.abs(da - db) >= 0.05 then
		return da > db
	end
	if a.dsta ~= b.dsta then
		return a.dsta > b.dsta
	end
	return a.darm > b.darm
end

--- The decision for the current quest window: { index, kind = "upgrade"/"money", text } or nil, plus "not ready".
local function Decide()
	local n = GetNumQuestChoices and GetNumQuestChoices() or 0
	if n < 2 then
		return nil, "fewer than 2 rewards to choose from"
	end
	local token = Token()
	local def = StatDef(token)
	local main = MainFor(def)
	local stamTie = def and def.stamTie
	local rows, best, bestMoney, unsure = {}, nil, nil, false
	for i = 1, n do
		local link = GetQuestItemLink and GetQuestItemLink("choice", i)
		local name, quality, equipLoc, sell = ItemInfo(link)
		if not name then
			return nil, "not ready"
		end
		local count, isUsable = 1, true
		if GetQuestItemInfo then
			local okQ, _, _, c, _, u = pcall(GetQuestItemInfo, "choice", i)
			if okQ then
				count, isUsable = c, u
			end
		end
		count = tonumber(count) or 1
		local row = { i = i, link = link, name = name, usable = isUsable and true or false, equipLoc = equipLoc,
			sell = (sell or 0) * count }
		-- Worn() == nil: no fair comparison (an off-hand item while you hold a two-hander, or an off-hand weapon for a
		-- class that cannot wield two): no verdict for this reward, never "better" (option A, 18 Nov 2026).
		local worn = (row.usable and SLOTS[equipLoc] and main) and Worn(equipLoc, main, stamTie) or nil
		if worn then
			local stats = Stats(link, equipLoc) or {}
			local s, sta = Score(stats, main, stamTie)
			row.s, row.sta, row.stats = s, sta, stats
			row.ds, row.dsta = s - worn.s, sta - worn.sta
			row.darm = (stats.ARMOR or 0) - worn.arm
			row.ddps = DeltaDps(stats, worn, main)
			row.worn = worn
			if IsBetter(row) and (not best or Outranks(row, best)) then
				best = row
			end
		elseif row.usable and SLOTS[equipLoc] and main then
			unsure, row.noCompare = true, true -- gear you can wear, but no fair comparison: MH has no verdict on it
		end
		if not bestMoney or row.sell > bestMoney.sell then
			bestMoney = row
		end
		rows[#rows + 1] = row
	end
	last.rows = rows
	if best then
		local parts, why = Explain(best, main, stamTie, token)
		-- Step 3 of "Which way do I go?" (19 Nov 2026): the hint also says whether your direction uses this weapon kind.
		local fit = ns.ForeverDirectionFitText and ns.ForeverDirectionFitText(best.link)
		local tail = LoseText(best) .. (fit and (" " .. fit) or "")
		if not best.worn or not best.worn.link then
			return { index = best.i, kind = "upgrade", text = ns:L("FQH_TAKE_EMPTY_FMT")
				:format(best.link, table.concat(parts, ", "), why) .. tail }
		end
		return { index = best.i, kind = "upgrade", text = ns:L("FQH_TAKE_FMT")
			:format(best.link, table.concat(parts, ", "), why) .. tail }
	end
	if not main then
		return { index = bestMoney.i, kind = "money", text = ns:L("FQH_NO_LIST_FMT"):format(bestMoney.link) }
	end
	if unsure then
		-- "None of these is better" would be a claim MH did not check for that reward: say nothing
		return nil, "a reward without a fair comparison (two-hander worn, or an off-hand weapon you cannot hold): no sell advice"
	end
	if bestMoney and bestMoney.sell > 0 then
		return { index = bestMoney.i, kind = "money", text = ns:L("FQH_SELL_FMT")
			:format(bestMoney.link, Money(bestMoney.sell)) }
	end
	return nil, "nothing better and nothing that sells"
end
ns.ForeverQuestHintDecide = Decide -- the offline check calls it

-- The marker: our own frames (parented to UIParent, never a child of Blizzard's buttons), placed on the reward button,
-- and the reason line under the quest window.
local glow, caption

local function RewardButton(i)
	local b = _G["QuestInfoRewardsFrameQuestInfoItem" .. i]
	if b then
		return b
	end
	local rf = QuestInfoFrame and QuestInfoFrame.rewardsFrame
	for _, btn in ipairs((rf and rf.RewardButtons) or {}) do
		if btn.GetID and btn:GetID() == i then
			return btn
		end
	end
	return nil
end

local function HideHint()
	if glow then
		glow:Hide()
	end
	if caption then
		caption:Hide()
	end
end

local function ShowHint(d)
	local b = RewardButton(d.index)
	if b and b:IsVisible() then
		if not glow then
			glow = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
			glow:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 2 })
			glow:SetFrameStrata("HIGH")
		end
		glow:SetBackdropBorderColor(d.kind == "upgrade" and 0.37 or 1, d.kind == "upgrade" and 1 or 0.82,
			d.kind == "upgrade" and 0.33 or 0, 1)
		glow:ClearAllPoints()
		glow:SetPoint("TOPLEFT", b, "TOPLEFT", -2, 2)
		glow:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 2, -2)
		glow:Show()
	end
	local anchor = QuestFrame and QuestFrame:IsVisible() and QuestFrame
	if anchor then
		if not caption then
			caption = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
			caption:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12,
				insets = { left = 3, right = 3, top = 3, bottom = 3 } })
			caption:SetBackdropColor(0, 0, 0, 0.85)
			caption:SetFrameStrata("HIGH")
			caption.text = caption:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			caption.text:SetPoint("TOPLEFT", 8, -7)
			caption.text:SetJustifyH("LEFT")
		end
		caption:ClearAllPoints()
		caption:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -2)
		caption:SetWidth(math.max(260, anchor:GetWidth()))
		caption.text:SetWidth(caption:GetWidth() - 16)
		caption.text:SetText("|cffffcc00MH:|r " .. d.text)
		caption:SetHeight(caption.text:GetStringHeight() + 14)
		caption:Show()
	else
		print(PREFIX .. d.text) -- no quest window to sit under: say it where it can be read
	end
end

local tries = 0
local function Run()
	if not Enabled() then
		last.verdict = "off (/mh questhint on)"
		return
	end
	local d, why = Decide()
	if not d and why == "not ready" and tries < 10 and C_Timer and C_Timer.After then
		tries = tries + 1
		C_Timer.After(0.2, Run)
		return
	end
	last.at = time and time() or nil
	if d then
		last.verdict = d.kind .. ": reward " .. d.index
		ShowHint(d)
	else
		last.verdict = why or "nothing"
		HideHint()
	end
end

function ns.ForeverQuestHintSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		if ns.db then
			ns.db.foreverQuestHint = (arg == "on")
		end
		print(PREFIX .. "quest reward hint " .. (arg == "on" and "on." or "off. /mh questhint on brings it back."))
		if arg == "off" then
			HideHint()
		end
		return
	end
	local main = MainFor(StatDef(Token()))
	local sch = {}
	for s in pairs(curSchools) do
		sch[#sch + 1] = s
	end
	print(PREFIX .. ("quest hint: %s; main stats for %s: %s; spell weight %s (%s; schools: %s); last decision: %s"):format(
		Enabled() and "on" or "off", ClassName(Token()), main and table.concat(main, ", ") or "none", tostring(curSpellW),
		curHeal and "healing" or "damage", #sch > 0 and table.concat(sch, ", ") or "none", last.verdict))
	for _, r in ipairs(last.rows or {}) do
		print(("  %d %s usable=%s slot=%s main=%s stam=%s armor=%s spell=%s gain=%s/%s/%s dps=%s sells=%s%s%s"):format(r.i,
			r.link or r.name, tostring(r.usable), tostring(r.equipLoc), tostring(r.s), tostring(r.sta),
			tostring(r.stats and r.stats.ARMOR), tostring(SpellValue(r.stats)), tostring(r.ds), tostring(r.dsta),
			tostring(r.darm), r.ddps and ("%+.1f"):format(r.ddps) or "n/a", tostring(r.sell),
			r.noCompare and " NO FAIR COMPARISON (two-hander worn / no dual wield)" or "",
			SpellUnweighable(r.stats) and (" SPELL LINE NOT WEIGHED: " .. SpellUnweighable(r.stats)) or ""))
	end
end

--[[ Gear tooltip line (Rob, 11 Nov 2026: "Alleen tooltipregel").
	Hover a piece of gear you could wear: when it beats what you wear on YOUR main stats, the tooltip gets one green line
	"MH: +3 Strength over what you wear (main stats for a Paladin)." Same math and words as the quest hint above.
	Why only a line and no bag arrows: Rob's Forever runs Pawn (arrows + tooltip already) and Baganator (replaces the
	Blizzard bags our retail arrows hook into) — measured in his AddOns.txt that day. MH adds the WHY, not another arrow.
	Silent for: items you cannot use (any red line in the tooltip: armor type, level, class — AFGELEID that Forever
	colours them like every client does), what you already wear, items that are not better. /mh geartip on|off. ]]

local function GearTipEnabled()
	return not (ns.db and ns.db.foreverGearTip == false)
end

local function IsRed(c)
	return type(c) == "table" and type(c.r) == "number" and not (issecretvalue and issecretvalue(c.r))
		and c.r > 0.95 and (c.g or 1) < 0.35 and (c.b or 1) < 0.35
end

--- Any red text in the tooltip = the game says you cannot use or wear this (yet).
local function CannotUse(data)
	for _, line in ipairs((data and data.lines) or {}) do
		if IsRed(line.leftColor) or IsRed(line.rightColor) then
			return true
		end
	end
	return false
end

local tipLast = "none yet" -- for /mh geartip

--------------------------------------------------------------------------------
-- "Which way do I go?" step 3 (19 Nov 2026; Rob via sparring: "we gaan akkoord met het voorstel van het bouwadvies").
-- The stats already follow your direction (ns.ForeverStatDef reads it, ForeverMainStats.lua). What was missing: the
-- weapon TYPE. A weapon (or shield) now says in its tooltip whether your direction uses that kind, and the quest-reward
-- hint says it too. Kinds from the player guides (ForeverDirection.lua GUIDE `fit` / `shield`); a direction whose guides
-- name no weapons stays silent. Weapon subclass ids GEMETEN in Forever DB2 ItemSubClass ClassID=2 (1.60.1.70959):
-- 0/1 Axe, 2 Bow, 3 Gun, 4/5 Mace, 6 Polearm, 7/8 Sword, 10 Staff, 13 Fist Weapon, 15 Dagger, 16 Thrown, 18 Crossbow.
-- One-hand ids are the even ones of each pair (0 axe, 4 mace, 7 sword) as ForeverWeapons' keys (axe / axe2 …).
--------------------------------------------------------------------------------
local WEAPON_KEY = { [0] = "axe", [1] = "axe2", [2] = "bow", [3] = "gun", [4] = "mace", [5] = "mace2", [6] = "polearm",
	[7] = "sword", [8] = "sword2", [10] = "staff", [13] = "fist", [15] = "dagger", [16] = "thrown", [18] = "crossbow" }

--- "fits your direction" / "your direction does not use this weapon type", or nil plus why not.
function ns.ForeverDirectionFitText(link)
	if not ns.ForeverDirectionWeaponFit then
		return nil, "no direction module"
	end
	local band, tree, fit, shieldName = ns.ForeverDirectionWeaponFit()
	if not band then
		return nil, "no direction chosen"
	end
	local info = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not (info and link) then
		return nil, "no item info"
	end
	local ok, _, _, _, _, _, classID, subID = pcall(info, link)
	if not ok then
		return nil, "item info failed"
	end
	if classID == 4 and subID == 6 then -- Armor / Shield
		if shieldName then
			return ns:L("FDIRFIT_YES_FMT"):format(tree), "yes"
		end
		return nil, "the guides do not say a shield for this direction"
	end
	if classID ~= 2 then
		return nil, "not a weapon"
	end
	local key = WEAPON_KEY[subID]
	if not key then
		return nil, "a weapon kind the guides do not rank (" .. tostring(subID) .. ")"
	end
	if type(fit) ~= "table" then
		return nil, "the guides name no weapons for this direction"
	end
	if fit[key] then
		return ns:L("FDIRFIT_YES_FMT"):format(tree), "yes"
	end
	return ns:L("FDIRFIT_NO_FMT"):format(tree), "no"
end

--- The line for this item link, or nil plus why not.
function ns.ForeverGearTipText(link)
	local name, _, equipLoc = ItemInfo(link)
	if not name then
		return nil, "item not loaded"
	end
	local slots = SLOTS[equipLoc]
	if not slots then
		return nil, "not gear (" .. tostring(equipLoc) .. ")"
	end
	for _, slot in ipairs(slots) do
		if GetInventoryItemLink and GetInventoryItemLink("player", slot) == link then
			return nil, "you wear it"
		end
	end
	local token = Token()
	local def = StatDef(token)
	local main = MainFor(def)
	if not main then
		return nil, "no main stats known for " .. tostring(token)
	end
	local stamTie = def and def.stamTie
	local worn = Worn(equipLoc, main, stamTie)
	if not worn then
		return nil, "no fair comparison (" .. tostring(equipLoc) .. ": two-hander worn, or no off-hand weapons for you)"
	end
	local stats = Stats(link, equipLoc) or {}
	local s, sta = Score(stats, main, stamTie)
	local row = { stats = stats, worn = worn, ds = s - worn.s, dsta = sta - worn.sta,
		darm = (stats.ARMOR or 0) - worn.arm }
	row.ddps = DeltaDps(stats, worn, main)
	if not IsBetter(row) then
		local lost = {}
		for _, en in ipairs(Lost(row)) do
			lost[#lost + 1] = en.id .. (en.x and " (cannot weigh it)" or "")
		end
		local unk = SpellUnweighable(stats) or SpellUnweighable(worn.stats)
		return nil, ("not better (main %+g, stamina %+g, armor %+d, dps %s, spell %s %+g x %s; enchant(s) you would "
			.. "lose: %s%s)"):format(row.ds, row.dsta, row.darm, row.ddps and ("%+.1f"):format(row.ddps) or "n/a",
			curHeal and "healing" or "damage", SpellValue(stats) - SpellValue(worn.stats), tostring(curSpellW),
			#lost > 0 and table.concat(lost, ", ") or "none",
			(unk and curSpellW > 0) and ("; spell line MH does not weigh here: " .. unk) or "")
	end
	local parts, why = Explain(row, main, stamTie, token)
	local gains = table.concat(parts, ", ")
	local lose = LoseText(row)
	-- 3rd/4th return: the pieces, for the pickup notice (PickupUpgrade.lua) that words it its own way. 5th (23 Nov 2026,
	-- ForeverWear.lua): the inventory slot it would replace (the weaker ring, the empty off-hand ...), for "Wear it".
	-- 6th (25 Nov 2026): " You lose the enchant …" or "", for the pickup notice.
	return ns:L("FGEAR_TIP_FMT"):format(gains, why) .. lose, nil, gains, why, row.worn and row.worn.slot, lose
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType
	and Enum.TooltipDataType.Item then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
		-- Only the tooltips you hover or click; not the "Currently equipped" comparison tooltips beside them.
		if not GearTipEnabled() or not (tooltip == GameTooltip or tooltip == ItemRefTooltip) then
			return
		end
		local ok, err = pcall(function()
			local _, link = tooltip:GetItem()
			if type(link) ~= "string" or (issecretvalue and issecretvalue(link)) then
				tipLast = "no readable item link"
				return
			end
			if CannotUse(data) then
				tipLast = "red line in the tooltip: you cannot use or wear it (yet)"
				return
			end
			local text, why = ns.ForeverGearTipText(link)
			tipLast = text and ("shown: " .. text) or why
			if text then
				tooltip:AddLine(text, 0.37, 1, 0.33, true)
			end
			-- Your direction and this weapon kind (step 3, 19 Nov 2026): light green = fits, orange = not used.
			local fitText, fitWhy = ns.ForeverDirectionFitText(link)
			if fitText then
				if fitWhy == "yes" then
					tooltip:AddLine("MH: " .. fitText, 0.6, 0.9, 0.6, true)
				else
					tooltip:AddLine("MH: " .. fitText, 1, 0.6, 0.25, true)
				end
			end
			tipLast = tipLast .. "; direction: " .. tostring(fitText or fitWhy)
			if text or fitText then
				tooltip:Show()
			end
		end)
		if not ok then
			tipLast = "error: " .. tostring(err)
		end
	end)
else
	tipLast = "this client has no TooltipDataProcessor: the line cannot be added"
end

--- /mh geartip [on|off]: the switch, and the last decision (its normal result is silence, CLAUDE.md).
function ns.ForeverGearTipSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		if ns.db then
			ns.db.foreverGearTip = (arg == "on")
		end
		print(PREFIX .. ns:L(arg == "on" and "FGEAR_TIP_ON" or "FGEAR_TIP_OFF"))
		return
	end
	print(PREFIX .. ("gear tooltip line: %s; last item you hovered: %s"):format(GearTipEnabled() and "on" or "off",
		tipLast))
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "QUEST_COMPLETE", "QUEST_FINISHED" }) do
	pcall(ev.RegisterEvent, ev, e) -- an event Forever dropped would throw (GearQuest review); a pcall keeps the rest alive
end
ev:SetScript("OnEvent", function(_, event)
	if event == "QUEST_FINISHED" then
		HideHint()
		return
	end
	tries = 0
	Run()
end)
