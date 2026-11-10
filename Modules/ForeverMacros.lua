local _, ns = ...

--[[
	ForeverMacros.lua — WoW Forever: "Handy macros", a window with ready macros for every character.
	Rob, 9 Nov 2026: asked for the best macros in Forever per class and race → research (docs/forever/
	FOREVER_MACROS_2026-11-09_A/B/C.md) → "Plan maken voor MH" → plan step 3 → "Gaan we door zolang je kan".

	Each row: a short title, one line on what it does, and a Make button. MH puts the macro in this character's macro
	list ("MH+ <name>"); you drag it to a bar yourself. Nothing is placed or bound for you (players choose).
	Language-safe: spells by id (the client's own name), items as "item:<id>" — never an English name in a /cast or /use.
	The heal, mana and bandage macros use the best item you CARRY; MH rewrites a made one when your bags change, out of
	combat, so it never points at a potion you no longer have. Without any such item it keeps the old text.
	Not measured in Forever: "/use item:<id>" in a macro (modern-client syntax, AFGELEID) — docs/TESTLIJST.md.
	/mh macros opens it; /mh macros check prints what each row would write (a module that can stay quiet needs that).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local MACRO_PREFIX = "MH+ "
local ICON = "INV_MISC_QUESTIONMARK"
local MAX_LEN = 255 -- GEMETEN: client string MACROFRAME_CHAR_LIMIT "%d/255", Forever 1.60.1.70862

-- Best first. Item ids GEMETEN in wago ItemSparse, Forever 1.60.1.70862 (docs/forever/FOREVER_MACROS_2026-11-09_A.md §4).
-- The three perishable potions (268881-268883) are new in Forever; their order Minor/Lesser/plain is AFGELEID from the ids.
local STONES = { 9421, 5510, 5509, 5511, 5512 }
local POTIONS = { 13446, 3928, 1710, 268883, 929, 268882, 858, 268881, 118 }
local BANDAGES = { 14530, 14529, 8545, 8544, 6451, 6450, 3531, 3530, 2581, 1251 }

-- Active racials: spell id GEMETEN in wago SpellName 70862 (same doc §3); `pre` = lines before the /cast (AFGELEID:
-- stop a cast or swing that would delay or cancel it).
local RACIALS = {
	{ id = 1259718 }, -- Will to Survive (Human)
	{ id = 20600 }, -- Perception (Human)
	{ id = 20594, pre = "/stopcasting" }, -- Stoneform (Dwarf)
	{ id = 20580, pre = "/stopattack\n/stopcasting" }, -- Shadowmeld (Night Elf)
	{ id = 1259799 }, -- Elune's Light (Night Elf)
	{ id = 20589, pre = "/stopcasting" }, -- Escape Artist (Gnome)
	{ id = 1259823 }, -- Eureka! (Gnome)
	{ id = 20572 }, -- Blood Fury (Orc)
	{ id = 1299026, pre = "/stopcasting" }, -- Shatter Curse (Orc)
	{ id = 7744 }, -- Will of the Forsaken (Undead)
	{ id = 20577, pre = "/stopattack" }, -- Cannibalize (Undead)
	{ id = 20549, pre = "/stopcasting" }, -- War Stomp (Tauren)
	{ id = 20554 }, -- Berserking (Troll)
	{ id = 1260270, pre = "/stopattack" }, -- Rapid Regeneration (Troll)
	{ id = 1259416 }, -- Walk on Air (Skyborne)
	{ id = 1259705 }, -- Read Leyline (Skyborne, High Order)
	{ id = 1259686 }, -- Skysight (Skyborne, Windshaper)
}

local function Count(id)
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return 0
	end
	local ok, n = pcall(fn, id)
	return (ok and type(n) == "number") and n or 0
end

local function BestCarried(list)
	for _, id in ipairs(list) do
		if Count(id) > 0 then
			return id
		end
	end
	return nil
end

local function KnownSpell(id)
	for _, fn in ipairs({ IsPlayerSpell, IsSpellKnown }) do
		if fn then
			local ok, v = pcall(fn, id)
			if ok and v == true then
				return true
			end
		end
	end
	return false
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
			return n
		end
	end
	return nil
end

-- Spell ids GEMETEN in ForeverSpellIds.lua (wago wowf 70862): Auto Shot 75, Shoot (wand) 5019.
local AUTO_SHOT, SHOOT = 75, 5019
local WAND_SUBCLASS = (Enum and Enum.ItemWeaponSubclass and Enum.ItemWeaponSubclass.Wand) or 19

--- "shot" (Hunter who knows Auto Shot), "wand" (Mage/Priest/Warlock with a wand in the ranged slot), or "melee".
local function AttackKind()
	local _, token = UnitClass("player")
	if token == "HUNTER" and KnownSpell(AUTO_SHOT) then
		return "shot"
	end
	if token == "MAGE" or token == "PRIEST" or token == "WARLOCK" then
		local id = GetInventoryItemID and GetInventoryItemID("player", 18)
		local info = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
		if id and info and KnownSpell(SHOOT) then
			local ok, _, _, _, _, _, classID, subclassID = pcall(info, id)
			if ok and classID == 2 and subclassID == WAND_SUBCLASS then
				return "wand"
			end
		end
	end
	return "melee"
end

--------------------------------------------------------------------------------
-- The rows. build() returns the macro text, or nil plus a reason key. `auto` = rewritten when the bags change.
--------------------------------------------------------------------------------
local DEFS = {
	{
		key = "heal", name = "Heal", title = "FMAC_HEAL_TITLE", desc = "FMAC_HEAL_DESC", auto = true,
		build = function()
			local stone, potion = BestCarried(STONES), BestCarried(POTIONS)
			if stone and potion then
				return ("#showtooltip\n/use [mod:shift] item:%d; item:%d"):format(potion, stone)
			elseif stone or potion then
				return ("#showtooltip\n/use item:%d"):format(stone or potion)
			end
			return nil, "FMAC_WHY_NO_HEAL"
		end,
	},
	{
		key = "bandage", name = "Bandage", title = "FMAC_BANDAGE_TITLE", desc = "FMAC_BANDAGE_DESC", auto = true,
		build = function()
			local b = BestCarried(BANDAGES)
			if not b then
				return nil, "FMAC_WHY_NO_BANDAGE"
			end
			return ("#showtooltip\n/use [@mouseover,help,nodead][@player] item:%d"):format(b)
		end,
	},
	{
		-- Rob, 9 Nov 2026: tested it, the target worked but "/startattack" only swings the weapon; he expected a ranged
		-- attack → "ja doe maar" on: Hunter = Auto Shot, Mage/Priest/Warlock with a wand = Shoot, everyone else melee.
		-- Rebuilt when the bags change (`auto`), so equipping a wand later updates it.
		key = "attack", name = "Attack", title = "FMAC_ATTACK_TITLE", auto = true,
		descFn = function()
			return AttackKind() == "shot" and "FMAC_ATTACK_DESC_SHOT" or AttackKind() == "wand" and "FMAC_ATTACK_DESC_WAND"
				or "FMAC_ATTACK_DESC"
		end,
		build = function()
			local kind = AttackKind()
			if kind == "shot" or kind == "wand" then
				local nm = SpellName(kind == "shot" and AUTO_SHOT or SHOOT)
				if nm then
					return "#showtooltip\n/targetenemy [noharm][dead]\n/cast !" .. nm
				end
			end
			return "/targetenemy [noharm][dead]\n/startattack"
		end,
	},
	{
		key = "focus", name = "Focus", title = "FMAC_FOCUS_TITLE", desc = "FMAC_FOCUS_DESC",
		build = function()
			return "/clearfocus [mod:shift]\n/stopmacro [mod:shift]\n/focus [@mouseover,exists,nodead][]"
		end,
	},
	{
		key = "skull", name = "Skull", title = "FMAC_SKULL_TITLE", desc = "FMAC_SKULL_DESC",
		build = function()
			-- Plain "8", not "!8": the "!" (never toggle off) is documented for modern clients; not measured in Forever.
			return "/tm [@mouseover,exists,nodead][] 8"
		end,
	},
	{
		key = "trinkets", name = "Trinkets", title = "FMAC_TRINKETS_TITLE", desc = "FMAC_TRINKETS_DESC",
		build = function()
			return "/use 13\n/use 14"
		end,
	},
}

--------------------------------------------------------------------------------
-- Class macros. Rob, 10 Nov 2026: "Top 5" per class from docs/forever/FOREVER_MACROS_POPULAR_2026-11-10.md (counted in
-- 12 Forever sources + player posts) → "Ja. Mooi." on the plan. Each `tpl` names spells only as {id} (or {id:rank} for
-- Name(Rank N)); FillTpl puts in the client's own spell name, so the macro works in every client language.
-- `need` must be known (else grey: level not reached / train it first); `talent` rows are hidden until known.
-- `warn`: "twopress" (stance swap + ability takes two presses in Forever) or "formbar" (the druid form bar bug),
-- both GEMETEN in player forum posts (POPULAR §0). Data and ids: see the note above CLASS_MACROS.
--------------------------------------------------------------------------------
-- Ids GEMETEN in wago DB2, Forever 1.60.1.70862 (SpellName, SkillLineAbility, SpellLevels; talents via
-- TraitDefinition). Texts from the named sources in the POPULAR doc; the NEW rows are taken word for word from one
-- source each (AFGELEID choice). Changed on purpose: the Warlock demon button has no [pet:family] (that word is
-- translated per client); the Priest dispel is shortened; tplShort = the version used when the client's spell
-- names make the full one longer than 255 bytes (ruRU measured 258 for Taunt and Healing Touch).
local CLASS_MACROS = {
	-- WARRIOR
	{ class = "WARRIOR", key = "taunt", name = "Taunt", need = 355, level = 10, talent = false, warn = "twopress", -- W6
		tpl = "#showtooltip\n/cast [mod:shift,stance:1,@mouseover,harm,nodead][mod:shift,stance:1] {694}; [mod:shift] {2457}; [stance:2,@mouseover,harm,nodead][stance:2] {355}; {71}",
		tplShort = "#showtooltip\n/cast [mod:shift,stance:1] {694}; [mod:shift] {2457}; [stance:2,@mouseover,harm,nodead][stance:2] {355}; {71}" },
	{ class = "WARRIOR", key = "overpower", name = "Overpower", need = 7384, level = 12, talent = false, warn = "twopress", -- W2
		tpl = "#showtooltip {7384}\n/startattack\n/cast [stance:1] {7384}; {2457}" },
	{ class = "WARRIOR", key = "shieldbash", name = "Shield Bash", need = 72, level = 12, talent = false, warn = nil, -- W5
		tpl = "#showtooltip\n/cast [stance:3,@focus,harm,nodead][stance:3] {6552}; [@focus,harm,nodead][] {72}" },
	{ class = "WARRIOR", key = "execute", name = "Execute", need = 5308, level = 24, talent = false, warn = "twopress", -- W3
		tpl = "#showtooltip {5308}\n/startattack\n/cast [stance:2] {2457}; {5308}" },
	{ class = "WARRIOR", key = "charge", name = "Charge", need = 100, level = 4, talent = false, warn = "twopress", -- W1
		tpl = "#showtooltip\n/startattack\n/cast [nocombat,stance:1] {100}; [combat,stance:3] {20252}; [nocombat] {2457}; {2458}" },
	-- ROGUE
	{ class = "ROGUE", key = "opener", name = "Opener", need = 1752, level = 1, talent = false, warn = nil, -- R2
		tpl = "#showtooltip\n/cast [stealth,mod:shift] {1833}; [stealth,mod:ctrl] {703}; [stealth] {8676}; {1752}\n/startattack [nostealth]" },
	{ class = "ROGUE", key = "sap", name = "Sap", need = 6770, level = 10, talent = false, warn = nil, -- R4
		tpl = "#showtooltip {6770}\n/cast [nostealth] !{1784}; [@mouseover,harm,nodead][@focus,harm,nodead][] {6770}" },
	{ class = "ROGUE", key = "kick", name = "Kick", need = 1766, level = 12, talent = false, warn = nil, -- R5
		tpl = "#showtooltip {1766}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {1766}" },
	{ class = "ROGUE", key = "pickpocket", name = "Pick Pocket", need = 921, level = 4, talent = false, warn = nil, -- R3
		tpl = "#showtooltip\n/cast [stealth] {921}\n/cast [stealth,mod:shift] {703}; [stealth] {1833}; {1752}" },
	{ class = "ROGUE", key = "blind", name = "Blind", need = 2094, level = 34, talent = false, warn = nil, -- NEW
		tpl = "#showtooltip {2094}\n/cast [@mouseover,harm,nodead][@focus,harm,nodead][harm,nodead] {2094}" },
	-- HUNTER
	{ class = "HUNTER", key = "feign", name = "Feign Death", need = 5384, level = 30, talent = false, warn = nil, -- H8
		tpl = "#showtooltip {5384}\n/stopattack\n/petfollow\n/cast {5384}" },
	{ class = "HUNTER", key = "meleeweave", name = "Melee Weave", need = 2973, level = 1, talent = false, warn = nil, -- H4
		tpl = "#showtooltip {2973}\n/startattack\n/cast {1495}\n/cast {2973}" },
	{ class = "HUNTER", key = "petcontrol", name = "Pet Control", need = 883, level = 10, talent = false, warn = nil, -- NEW
		tpl = "/petfollow [mod:shift]\n/petstay [mod:ctrl]\n/petattack [nomod,@mouseover,harm,nodead][nomod]" },
	{ class = "HUNTER", key = "huntersmark", name = "Mark + Pet", need = 1130, level = 6, talent = false, warn = nil, -- H1
		tpl = "#showtooltip {1130}\n/petattack\n/cast {1130}" },
	{ class = "HUNTER", key = "petcare", name = "Pet Care", need = 883, level = 10, talent = false, warn = nil, -- H5
		tpl = "#showtooltip\n/cast [@pet,dead][mod:shift] {982}; [nopet] {883}; {136}" },
	-- PALADIN
	{ class = "PALADIN", key = "holylight", name = "Holy Light", need = 635, level = 1, talent = false, warn = nil, -- P7
		tpl = "#showtooltip\n/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] {19750}; [@mouseover,help,nodead][help,nodead][@player] {635}" },
	{ class = "PALADIN", key = "holystrike", name = "Holy Strike", need = 679, level = 6, talent = false, warn = nil, -- P2
		tpl = "#showtooltip {679}\n/startattack\n/cast [nomod:shift] {20271}\n/cast {679}" },
	{ class = "PALADIN", key = "divineshield", name = "DivineShield", need = 498, level = 6, talent = false, warn = nil, -- NEW
		tpl = "#showtooltip\n/stopcasting\n/cancelaura [mod:shift] {498}\n/cancelaura [mod:shift] {642}\n/cast [nomod] {642}\n/cast [nomod] {498}" },
	{ class = "PALADIN", key = "holyshock", name = "Holy Shock", need = 1311606, level = 30, talent = true, warn = nil, -- NEW
		tpl = "#showtooltip\n/cast [@mouseover,help,nodead][@mouseover,harm,nodead][] {1311606}" },
	{ class = "PALADIN", key = "protectally", name = "Protect Ally", need = 1022, level = 10, talent = false, warn = nil, -- NEW
		tpl = "#showtooltip {1022}\n/stopcasting\n/cast [mod:alt,@player][@mouseover,help,nodead][help,nodead][@player] {1022}" },
	-- SHAMAN
	{ class = "SHAMAN", key = "earthshock", name = "Earth Shock", need = 8042, level = 4, talent = false, warn = nil, -- S4
		tpl = "#showtooltip {8042}\n/stopcasting\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {8042}" },
	{ class = "SHAMAN", key = "healwave", name = "Healing Wave", need = 331, level = 1, talent = false, warn = nil, -- S6
		tpl = "#showtooltip\n/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] {8004}; [@mouseover,help,nodead][help,nodead][@player] {331}" },
	{ class = "SHAMAN", key = "totems", name = "Totems", need = 66842, level = 20, talent = false, warn = nil, -- S1
		tpl = "#showtooltip\n/cast [mod:shift] {36936}; [mod:ctrl] {437009}; {66842}" },
	{ class = "SHAMAN", key = "purge", name = "Purge", need = 370, level = 12, talent = false, warn = nil, -- S5
		tpl = "#showtooltip {370}\n/cast [@mouseover,harm,nodead][@focus,harm,nodead][] {370}" },
	{ class = "SHAMAN", key = "firenova", name = "Fire Nova", need = 408341, level = 12, talent = false, warn = nil, -- NEW
		tpl = "#showtooltip\n/cast [mod:shift] {3599}; {408341}" },
	-- MAGE
	{ class = "MAGE", key = "counterspell", name = "Counterspell", need = 2139, level = 24, talent = false, warn = nil, -- M2
		tpl = "#showtooltip {2139}\n/stopcasting\n/cast [@mouseover,harm,nodead][] {2139}" },
	{ class = "MAGE", key = "polymorph", name = "Polymorph", need = 118, level = 8, talent = false, warn = nil, -- M1
		tpl = "#showtooltip {118}\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {118}" },
	{ class = "MAGE", key = "frostnova", name = "Frost Nova", need = 122, level = 10, talent = false, warn = nil, -- M3
		tpl = "#showtooltip\n/stopcasting\n/cast [mod:ctrl] {1953}; {122}" },
	{ class = "MAGE", key = "decurse", name = "Decurse", need = 475, level = 18, talent = false, warn = nil, -- M8
		tpl = "#showtooltip {475}\n/cast [@mouseover,help,nodead][help,nodead][@player] {475}" },
	{ class = "MAGE", key = "frostbolt", name = "Frostbolt", need = 116, level = 4, talent = false, warn = nil, -- M7
		tpl = "#showtooltip\n/cast [mod:shift] {116:rank}; {116}" },
	-- WARLOCK
	{ class = "WARLOCK", key = "fear", name = "Fear", need = 5782, level = 8, talent = false, warn = nil, -- W2
		tpl = "#showtooltip\n/petfollow [nomod,@mouseover,noexists]\n/cast [mod:ctrl,@mouseover,harm,nodead][mod:ctrl] {710}; [@mouseover,harm,nodead][] {5782}" },
	{ class = "WARLOCK", key = "agony", name = "Bane Agony", need = 980, level = 8, talent = false, warn = nil, -- NEW
		tpl = "#showtooltip\n/cast [@mouseover,harm,nodead][] {980}" },
	{ class = "WARLOCK", key = "demonbutton", name = "Demon Button", need = 697, level = 10, talent = false, warn = nil, -- W8
		tpl = "#showtooltip\n/cast {19244}\n/cast {6358}\n/cast {7812}\n/cast {2947}" },
	{ class = "WARLOCK", key = "curses", name = "Curses", need = 702, level = 4, talent = false, warn = nil, -- NEW
		tpl = "#showtooltip\n/cast [mod:shift,@mouseover,harm,nodead][mod:shift] {704}; [mod:ctrl,@mouseover,harm,nodead][mod:ctrl] {440892}; [@mouseover,harm,nodead][] {702}" },
	{ class = "WARLOCK", key = "summon", name = "Summon Demon", need = 697, level = 10, talent = false, warn = nil, -- NEW
		tpl = "#showtooltip\n/cast [combat] {18708}\n/cast [mod:shift] {697}; [mod:ctrl] {712}; [mod:alt] {691}; {688}" },
	-- PRIEST
	{ class = "PRIEST", key = "flashheal", name = "Flash Heal", need = 2061, level = 20, talent = false, warn = nil, -- P3
		tpl = "#showtooltip {2061}\n/cast [@mouseover,help,nodead][@target,help,nodead][@player] {2061}" },
	{ class = "PRIEST", key = "dispel", name = "Dispel", need = 527, level = 18, talent = false, warn = nil, -- P4
		tpl = "#showtooltip\n/cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl,help,nodead][mod:ctrl,@player] {552}; [@mouseover,exists,nodead][exists,nodead][@player] {527}" },
	{ class = "PRIEST", key = "pwshield", name = "PW Shield", need = 17, level = 6, talent = false, warn = nil, -- P1
		tpl = "#showtooltip {17}\n/stopcasting\n/cast [@mouseover,help,nodead][@target,help,nodead][@player] {17}" },
	{ class = "PRIEST", key = "penance", name = "Penance", need = 402174, level = 30, talent = true, warn = nil, -- NEW
		tpl = "#showtooltip {402174}\n/cast [@mouseover,help,nodead][@mouseover,harm,nodead][] {402174}" },
	{ class = "PRIEST", key = "swpain", name = "SW Pain", need = 589, level = 4, talent = false, warn = nil, -- NEW
		tpl = "#showtooltip {589}\n/cast [@mouseover,harm,nodead][] {589}" },
	-- DRUID
	{ class = "DRUID", key = "healtouch", name = "Heal Touch", need = 5185, level = 1, talent = false, warn = nil, -- D8
		tpl = "#showtooltip\n/cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl,help,nodead][mod:ctrl,@player] {5188:rank}; [@mouseover,help,nodead][help,nodead][@player] {5185}",
		tplShort = "#showtooltip\n/cast [mod:ctrl] {5188:rank}; [@mouseover,help,nodead][help,nodead][@player] {5185}" },
	{ class = "DRUID", key = "rejuv", name = "Rejuvenation", need = 774, level = 4, talent = false, warn = nil, -- NEW
		tpl = "#showtooltip {774}\n/cast [@mouseover,help,nodead][help,nodead][@player] {774}" },
	{ class = "DRUID", key = "wildbuffs", name = "Wild Buffs", need = 1126, level = 1, talent = false, warn = nil, -- NEW
		tpl = "#showtooltip\n/cast [mod:shift] {21849}; [mod:ctrl,@mouseover,help,nodead][mod:ctrl,help,nodead][mod:ctrl,@player] {467}; [@mouseover,help,nodead][help,nodead][@player] {1126}" },
	{ class = "DRUID", key = "travel", name = "Travel", need = 783, level = 30, talent = false, warn = "formbar", -- D2
		tpl = "#showtooltip\n/cast [swimming] {1066}; [outdoors] {783}; {768}" },
	{ class = "DRUID", key = "innervate", name = "Innervate", need = 29166, level = 40, talent = false, warn = nil, -- D4
		tpl = "#showtooltip {29166}\n/cancelform\n/cast [@mouseover,help,nodead][help,nodead][@player] {29166}" },
}

local function SpellSubtext(id)
	local fn = (C_Spell and C_Spell.GetSpellSubtext) or GetSpellSubtext
	if not fn then
		return nil
	end
	local ok, s = pcall(fn, id)
	if ok and type(s) == "string" and s ~= "" and not (issecretvalue and issecretvalue(s)) then
		return s
	end
	return nil
end

--- Template → macro text in the client's language, or nil when a spell name cannot be read.
local function FillTpl(tpl)
	local bad = false
	local out = tpl:gsub("{(%d+):rank}", function(id)
		id = tonumber(id)
		local nm, sub = SpellName(id), SpellSubtext(id)
		if not nm then
			bad = true
			return ""
		end
		return sub and (nm .. "(" .. sub .. ")") or nm
	end)
	out = out:gsub("{(%d+)}", function(id)
		local nm = SpellName(tonumber(id))
		if not nm then
			bad = true
			return ""
		end
		return nm
	end)
	if bad then
		return nil
	end
	return out
end

local function ClassRow(c)
	return {
		key = "c_" .. c.key, name = c.name, cls = c,
		plainTitleFn = function()
			return SpellName(c.need) or c.name
		end,
		desc = "FMAC_C_" .. c.class .. "_" .. c.key:upper(),
		build = function()
			if not KnownSpell(c.need) then
				local lvl = UnitLevel and UnitLevel("player") or 0
				if c.level and lvl < c.level then
					return nil, "FMAC_WHY_LEVEL_FMT", c.level
				end
				return nil, "FMAC_WHY_TRAIN"
			end
			local body = FillTpl(c.tpl)
			if body and #body > MAX_LEN and c.tplShort then
				body = FillTpl(c.tplShort)
			end
			if not body then
				return nil, "FMAC_WHY_FAILED"
			end
			return body
		end,
	}
end

--- The rows for this character: the fixed ones, one per active racial it knows, then its class macros.
local function Rows()
	local rows = {}
	for _, d in ipairs(DEFS) do
		rows[#rows + 1] = d
	end
	for _, r in ipairs(RACIALS) do
		if KnownSpell(r.id) then
			local nm = SpellName(r.id)
			if nm then
				rows[#rows + 1] = {
					key = "racial" .. r.id, name = nm, plainTitle = nm, desc = "FMAC_RACIAL_DESC",
					build = function()
						return "#showtooltip\n" .. (r.pre and (r.pre .. "\n") or "") .. "/cast " .. nm
					end,
				}
			end
		end
	end
	local _, token = UnitClass("player")
	local first = true
	for _, c in ipairs(CLASS_MACROS) do
		if c.class == token and (not c.talent or KnownSpell(c.need)) then
			if first then
				rows[#rows + 1] = { header = true, key = "c_header" }
				first = false
			end
			rows[#rows + 1] = ClassRow(c)
		end
	end
	return rows
end

--- Macro names may hold 16 characters (mmonster.co 3 Nov 2026, a claim; the client cuts longer ones, AFGELEID).
local function MacroName(d)
	return (MACRO_PREFIX .. d.name):sub(1, 16)
end

local function Exists(d)
	local idx = GetMacroIndexByName and GetMacroIndexByName(MacroName(d)) or 0
	return (idx and idx > 0) and idx or nil
end

--- Make or rewrite one macro. @return true, or nil plus a reason key.
local function Make(d)
	if InCombatLockdown and InCombatLockdown() then
		return nil, "FMAC_WHY_COMBAT"
	end
	local body, why, arg = d.build()
	if not body then
		return nil, why, arg
	end
	if #body > MAX_LEN then
		return nil, "FMAC_WHY_LONG"
	end
	local name = MacroName(d)
	local idx = Exists(d)
	if idx then
		local _, icon, old = GetMacroInfo(idx)
		if old ~= body then
			pcall(EditMacro, idx, name, icon or ICON, body)
		end
		return true
	end
	local _, perChar = GetNumMacros()
	if (perChar or 0) >= (MAX_CHARACTER_MACROS or 18) then
		return nil, "FMAC_WHY_FULL"
	end
	local ok = pcall(CreateMacro, name, ICON, body, true)
	if not ok then
		return nil, "FMAC_WHY_FAILED"
	end
	return true
end

--- A reason key (plus its one number, for the _FMT ones) as text.
local function Why(why, arg)
	local s = ns:L(why or "FMAC_WHY_FAILED")
	if arg ~= nil then
		s = s:format(arg)
	end
	return s
end

--- Rewrite the made "auto" macros (bags changed). Never creates one, never erases one when nothing is carried.
local function RefreshAuto()
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	for _, d in ipairs(DEFS) do
		if d.auto and Exists(d) and d.build() then
			Make(d)
		end
	end
end

--------------------------------------------------------------------------------
-- Window (same look as the profession-trainer window; Shift+scroll and Escape via RegisterMidnightDialogPopup)
--------------------------------------------------------------------------------
local W, H, ROW_H = 560, 470, 52 -- 52 (was 46): a class row can carry a warning after its line
local win, Fill

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverMacros", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
	f:SetPoint("CENTER", 0, 40)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 22, -18)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.sub:SetPoint("TOPLEFT", 22, -44)
	f.sub:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.sub:SetJustifyH("LEFT")
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 20, -78)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -40, 44)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(W - 64, 10)
	scroll:SetScrollChild(child)
	f.scroll, f.child, f.rows = scroll, child, {}
	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.hint:SetPoint("BOTTOMLEFT", 22, 18)
	f.hint:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.hint:SetJustifyH("LEFT")
	f:SetScript("OnShow", function()
		Fill()
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

local function Row(f, i)
	local r = f.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, f.child)
	r:SetSize(f.child:GetWidth(), ROW_H)
	r.name = r:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	r.name:SetPoint("TOPLEFT", 4, -2)
	r.name:SetPoint("RIGHT", r, "RIGHT", -96, 0)
	r.name:SetJustifyH("LEFT")
	r.info = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.info:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -2)
	r.info:SetPoint("RIGHT", r, "RIGHT", -96, 0)
	r.info:SetJustifyH("LEFT")
	r.go = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
	r.go:SetSize(88, 22)
	r.go:SetPoint("RIGHT", r, "RIGHT", -2, 0)
	r.go:SetScript("OnClick", function(self)
		local d = self.def
		if not d then
			return
		end
		local ok, why, arg = Make(d)
		if ok then
			print(PREFIX .. ns:L("FMAC_MADE_FMT"):format(MacroName(d)))
			if ShowMacroFrame then
				pcall(ShowMacroFrame) -- open the macro window so you can drag it (AFGELEID that Forever has it)
			end
		else
			print(PREFIX .. Why(why, arg))
		end
		Fill()
	end)
	f.rows[i] = r
	return r
end

Fill = function()
	local f = Build()
	f.title:SetText(ns:L("FMAC_TITLE"))
	f.sub:SetText(ns:L("FMAC_SUB"))
	f.hint:SetText(ns:L("FMAC_HINT"))
	local y = 0
	local rows = Rows()
	for i, d in ipairs(rows) do
		local r = Row(f, i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, y)
		if d.header then
			local cls = UnitClass and UnitClass("player") or ""
			r.name:SetText(ns:L("FMAC_CLASS_HEADER_FMT"):format(cls))
			r.info:SetText(ns:L("FMAC_CLASS_SUB"))
			r.go.def = nil
			r.go:Hide()
		else
			r.go:Show()
			r.name:SetText(d.plainTitleFn and d.plainTitleFn() or d.plainTitle or ns:L(d.title))
			local body, why, arg = d.build()
			local info = ns:L(d.descFn and d.descFn() or d.desc)
			if d.cls and d.cls.warn then
				info = info .. "  |cffffd200" .. ns:L(d.cls.warn == "twopress" and "FMAC_WARN_TWOPRESS"
					or "FMAC_WARN_FORMBAR") .. "|r"
			end
			if not body then
				local col = (why == "FMAC_WHY_LEVEL_FMT" or why == "FMAC_WHY_TRAIN") and "|cff9d9d9d" or "|cffff7f7f"
				info = info .. "  " .. col .. Why(why, arg) .. "|r"
			end
			r.info:SetText(info)
			r.go.def = d
			r.go:SetText(ns:L(Exists(d) and "FMAC_BTN_UPDATE" or "FMAC_BTN_MAKE"))
			if body then
				r.go:Enable()
			else
				r.go:Disable()
			end
		end
		r:Show()
		y = y - ROW_H - 4
	end
	for i = #rows + 1, #f.rows do
		f.rows[i]:Hide()
	end
	f.child:SetHeight(math.max(10, -y))
	return f
end

function ns.ShowForeverMacros()
	local f = Build()
	if f:IsShown() then
		f:Hide()
	else
		f:Show()
	end
end

--- /mh macros [check]
function ns.ForeverMacrosSlash(arg)
	arg = (arg or ""):lower()
	if arg ~= "check" then
		ns.ShowForeverMacros()
		return
	end
	print(PREFIX .. "handy macros: what each row would write now")
	local _, token = UnitClass("player")
	local nClass = 0
	for _, c in ipairs(CLASS_MACROS) do
		if c.class == token then
			nClass = nClass + 1
		end
	end
	print(("  class %s: %d class macros in the data (talent ones hidden until known)"):format(tostring(token), nClass))
	for _, d in ipairs(Rows()) do
		if not d.header then
			local body, why, arg = d.build()
			print(("  %s [%s]: %s"):format(MacroName(d), Exists(d) and "made" or "not made",
				body and ("%d chars | %s"):format(#body, (body:gsub("\n", " | ")))
					or ("nothing: " .. tostring(why) .. (arg and (" " .. tostring(arg)) or ""))))
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") -- a wand in or out changes the Attack macro
ev:SetScript("OnEvent", function()
	RefreshAuto()
	if win and win:IsShown() then
		Fill()
	end
end)
