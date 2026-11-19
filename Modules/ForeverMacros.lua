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
	/mh macros keys (17 Nov 2026) checks, per MH+ macro on a bar, whether Shift/Ctrl/Alt+its key is bound to something else.
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

-- 17 Nov 2026, macro idea 1 (Rob via sparring: "Ja, die 10 macro-ideeën zijn een goed idee. Werk maar uit."). Plain
-- water and food without a second effect, best first, { item id, level the item needs }. GEMETEN in wago DB2 wowf
-- 1.60.1.70938 (ItemSparse/ItemEffect/SpellEffect; docs/forever/MACRO_IDEAS_2026-11-17.md §1b/§1c). Conjured first
-- within a tier (free, and it vanishes) = AFGELEID choice. The cooked-fish vendor line is buff food in Forever: left out.
local WATER = {
	{ 231778, 55 }, { 8079, 55 }, { 18300, 55 },
	{ 8078, 45 }, { 8766, 45 }, { 23161, 45 },
	{ 8077, 35 }, { 1645, 35 }, { 19300, 35 },
	{ 3772, 25 }, { 1708, 25 }, { 4791, 25 }, { 17405, 25 },
	{ 2136, 15 }, { 1205, 15 }, { 9451, 15 }, { 19299, 15 },
	{ 2288, 5 }, { 1179, 5 }, { 17404, 5 }, { 252027, 5 },
	{ 5350, 1 }, { 159, 1 }, { 252031, 1 },
}
local FOOD = {
	{ 22895, 55 },
	{ 8076, 45 }, { 8952, 45 }, { 8932, 45 }, { 8953, 45 }, { 8950, 45 }, { 8948, 45 }, { 11415, 45 }, { 16171, 45 },
	{ 8075, 35 }, { 4599, 35 }, { 3927, 35 }, { 4602, 35 }, { 4601, 35 }, { 4608, 35 }, { 16168, 35 }, { 17408, 35 },
	{ 1487, 25 }, { 3771, 25 }, { 1707, 25 }, { 4539, 25 }, { 4544, 25 }, { 4607, 25 }, { 16169, 25 },
	{ 1114, 15 }, { 3770, 15 }, { 422, 15 }, { 4538, 15 }, { 4542, 15 }, { 4606, 15 }, { 16170, 15 },
	{ 1113, 5 }, { 2287, 5 }, { 414, 5 }, { 4537, 5 }, { 4541, 5 }, { 4605, 5 }, { 252026, 5 }, { 252029, 5 },
	{ 252030, 5 }, { 252032, 5 },
	{ 5349, 1 }, { 117, 1 }, { 2070, 1 }, { 4536, 1 }, { 4540, 1 }, { 4604, 1 }, { 252022, 1 }, { 252023, 1 },
	{ 252028, 1 },
}
local CONJURE_WATER = 5504 -- rank 1; the name casts the highest one you know: KL, docs §0.1

-- Warlock and mage stones, best first (docs §3, GEMETEN). Mana gems: each gem is its own spell NAME, highest first.
local SOULSTONES = { 16896, 16895, 16893, 16892, 5232 }
local MANA_GEMS = { 8008, 8007, 5513, 5514 }
local CONJURE_GEMS = { 10054, 10053, 3552, 759 }

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

--- The best carried item of a { id, level } list that this character is high enough for.
local function BestEdible(list)
	local lvl = UnitLevel and UnitLevel("player") or 60
	for _, e in ipairs(list) do
		if e[2] <= lvl and Count(e[1]) > 0 then
			return e[1]
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

--- The highest rank you know of the spell family that holds `id` (ns.FOREVER_SPELL_IDS, ranks low to high), else `id`
--- itself when you know it, else nil. 17 Nov 2026, from the Fable check of the macro rows (mh-research, GEMETEN in DB2
--- 70938): (1) on ptBR rank 1 of Arcane Intellect and on esMX ranks 1/3 of Create Healthstone carry ANOTHER name than
--- the higher ranks, so "/cast <rank-1 name>" cast the weak rank; (2) for Stealth, Vanish, Eviscerate and Prowl each rank
--- supersedes the one below, so rank 1 may no longer count as known after rank 2 (AFGELEID; Rob's test in TESTLIJST)
--- and the row said "learn this spell first". Asking for the top known rank fixes both. Sparring, verbatim: "Ja, bouwen
--- na stap 9".
local rankIndex
local function TopKnown(id)
	if not rankIndex then
		rankIndex = {}
		for _, ids in pairs(ns.FOREVER_SPELL_IDS or {}) do
			for _, v in ipairs(ids) do
				rankIndex[v] = ids
			end
		end
	end
	local list = rankIndex[id]
	if list then
		for i = #list, 1, -1 do
			if KnownSpell(list[i]) then
				return list[i]
			end
		end
		return nil
	end
	return KnownSpell(id) and id or nil
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
		-- Macro idea 1 (17 Nov 2026): eat and drink on one press. Food and drink are separate cooldown groups (DB2
		-- SpellCategories 11 and 59, GEMETEN); both on one press = AFGELEID + guide claim (Rankedboost). Mage: Ctrl =
		-- Conjure Water. Skips an item you are too low for.
		key = "eatdrink", name = "Eat Drink", title = "FMAC_EAT_TITLE", desc = "FMAC_EAT_DESC", auto = true,
		build = function()
			local water, food = BestEdible(WATER), BestEdible(FOOD)
			local conjId = TopKnown(CONJURE_WATER)
			local conj = conjId and SpellName(conjId)
			local lines = { "#showtooltip" }
			if conj then
				lines[#lines + 1] = "/cast [mod:ctrl] " .. conj
				lines[#lines + 1] = "/stopmacro [mod:ctrl]"
			end
			if water then
				lines[#lines + 1] = ("/use item:%d"):format(water)
			end
			if food then
				lines[#lines + 1] = ("/use item:%d"):format(food)
			end
			if not (water or food) then
				if conj then
					return "#showtooltip\n/cast " .. conj
				end
				return nil, "FMAC_WHY_NO_FOOD"
			end
			return table.concat(lines, "\n")
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
-- 17 Nov 2026, macro ideas 3-5: rows whose text follows your bags or your form bar (ClassRow calls tplFn).
local function WarlockHealthstoneTpl()
	local s = BestCarried(STONES)
	if s then
		return ("#showtooltip\n/cast [mod:ctrl] {6201}\n/stopmacro [mod:ctrl]\n/use item:%d"):format(s)
	end
	return "#showtooltip {6201}\n/cast {6201}"
end

local function WarlockSoulstoneTpl()
	local s = BestCarried(SOULSTONES)
	if s then
		return ("#showtooltip\n/cast [mod:ctrl] {693}\n/stopmacro [mod:ctrl]\n/use [@mouseover,help,nodead][help,nodead][@player] item:%d"):format(s)
	end
	return "#showtooltip {693}\n/cast {693}"
end

local function MageGemTpl()
	local gem = BestCarried(MANA_GEMS)
	if gem then
		return ("#showtooltip\n/cast [mod:ctrl] {12051}\n/stopmacro [mod:ctrl]\n/use item:%d"):format(gem)
	end
	for _, id in ipairs(CONJURE_GEMS) do
		if KnownSpell(id) then
			return ("#showtooltip\n/cast [mod:ctrl] {12051}; {%d}"):format(id)
		end
	end
	return nil, "FMAC_WHY_TRAIN"
end

local function HunterAspectTpl()
	-- Out of combat Cheetah once known (20), else Hawk; in combat Hawk; Ctrl = Monkey. Pack (40) left out: it dazes the
	-- whole group when one of you is hit (DB2 description, GEMETEN in docs §4) — a choice Rob may flip.
	return "#showtooltip\n/cast [mod:ctrl] !{13163}; [combat] !{13165}; " .. (KnownSpell(5118) and "!{5118}" or "!{13165}")
end

local function DruidProwlTpl()
	-- The cat's number on the form bar is read from the client (docs §5: it shifts when a druid skipped a form quest).
	if GetNumShapeshiftForms and GetShapeshiftFormInfo then
		for i = 1, GetNumShapeshiftForms() or 0 do
			local ok, _, _, _, sid = pcall(GetShapeshiftFormInfo, i)
			if ok and sid == 768 then
				return ("#showtooltip {5215}\n/cast [noform:%d] !{768}; [nostealth] {5215}"):format(i)
			end
		end
	end
	return nil, "FMAC_WHY_NO_CATFORM"
end

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
	-- Rob, 11 Nov 2026 (via the sparring chat, "Klein en midden"; here "Ja, alleen klein"): the Paladin has no interrupt
	-- in Forever, so its "stop" button is Hammer of Justice, a stun (GEMETEN: 853 Hammer of Justice, 1152 Purify in wago
	-- SpellName wowf 1.60.1.70888; Rob's trainer window showed both at level 8). Target order: mouse, then focus, then your
	-- target (the same as Sap and Blind; Kick and Shield Bash put focus first).
	{ class = "PALADIN", key = "hammer", name = "Hammer Stun", need = 853, level = 8, talent = false, warn = nil,
		tpl = "#showtooltip {853}\n/cast [@mouseover,harm,nodead][@focus,harm,nodead][] {853}" },
	{ class = "PALADIN", key = "purify", name = "Purify", need = 1152, level = 8, talent = false, warn = nil,
		tpl = "#showtooltip {1152}\n/cast [@mouseover,help,nodead][help,nodead][@player] {1152}" },
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
	-- 17 Nov 2026, the ten macro ideas (Rob via sparring: "Ja, die 10 macro-ideeën zijn een goed idee. Werk maar uit.").
	-- Ids and levels GEMETEN in wago DB2 wowf 1.60.1.70938, rank-1 ids (docs/forever/MACRO_IDEAS_2026-11-17.md). The
	-- modifier is Ctrl throughout; /mh macros keys shows when Ctrl+your key belongs to another button. Texts written
	-- by MH from standard macro syntax; nothing taken from the Forever Leveling Guide (All Rights Reserved).
	-- Idea 2: buff mouse → target → you, Ctrl = group version (a reagent; without it the cast just fails).
	{ class = "MAGE", key = "intellect", name = "Intellect", need = 1459, level = 1, talent = false, warn = nil,
		tpl = "#showtooltip\n/cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl,help,nodead][mod:ctrl,@player] {23028}; [@mouseover,help,nodead][help,nodead][@player] {1459}" },
	{ class = "PRIEST", key = "fortitude", name = "Fortitude", need = 1243, level = 1, talent = false, warn = nil,
		tpl = "#showtooltip\n/cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl,help,nodead][mod:ctrl,@player] {21562}; [@mouseover,help,nodead][help,nodead][@player] {1243}" },
	{ class = "PRIEST", key = "spirit", name = "Spirit", need = 14752, level = 30, talent = false, warn = nil,
		tpl = "#showtooltip\n/cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl,help,nodead][mod:ctrl,@player] {27681}; [@mouseover,help,nodead][help,nodead][@player] {14752}" },
	-- Idea 3: stones and gems (item:<id> from your bags, rebuilt when your bags change).
	{ class = "WARLOCK", key = "healthstone", name = "Healthstone", need = 6201, level = 10, talent = false, warn = nil,
		tplFn = WarlockHealthstoneTpl },
	{ class = "WARLOCK", key = "soulstone", name = "Soulstone", need = 693, level = 18, talent = false, warn = nil,
		tplFn = WarlockSoulstoneTpl },
	{ class = "MAGE", key = "managem", name = "Mana Gem", need = 759, level = 28, talent = false, warn = nil,
		tplFn = MageGemTpl },
	-- Idea 4: hunter aspects.
	{ class = "HUNTER", key = "aspects", name = "Aspects", need = 13165, level = 10, talent = false, warn = nil,
		tplFn = HunterAspectTpl },
	-- Idea 5: druid Prowl from any form.
	{ class = "DRUID", key = "prowl", name = "Prowl", need = 5215, level = 20, talent = false, warn = nil,
		tplFn = DruidProwlTpl },
	-- Idea 6: warlock Shadow Bolt sends the demon too; Ctrl = demon back.
	{ class = "WARLOCK", key = "shadowbolt", name = "Shadow Bolt", need = 686, level = 1, talent = false, warn = nil,
		tpl = "#showtooltip {686}\n/petfollow [mod:ctrl]\n/stopmacro [mod:ctrl]\n/petattack\n/cast {686}" },
	-- Idea 7: resurrect the dead friend under your mouse, else your target (out of combat only, DB2 GEMETEN).
	{ class = "PRIEST", key = "res", name = "Resurrect", need = 2006, level = 10, talent = false, warn = nil,
		tpl = "#showtooltip {2006}\n/cast [@mouseover,help,dead][] {2006}" },
	{ class = "SHAMAN", key = "res", name = "Resurrect", need = 2008, level = 12, talent = false, warn = nil,
		tpl = "#showtooltip {2008}\n/cast [@mouseover,help,dead][] {2008}" },
	{ class = "PALADIN", key = "res", name = "Resurrect", need = 7328, level = 12, talent = false, warn = nil,
		tpl = "#showtooltip {7328}\n/cast [@mouseover,help,dead][] {7328}" },
	-- Idea 8: crowd control that remembers its enemy: no focus yet (or a dead one) → your target becomes the focus;
	-- Ctrl = make your target the new focus. Mage Polymorph, Warlock Fear and Rogue Sap rows already exist.
	{ class = "PRIEST", key = "shackle", name = "Shackle", need = 9484, level = 20, talent = false, warn = nil,
		tpl = "#showtooltip {9484}\n/focus [@focus,noexists][@focus,dead][mod:ctrl]\n/cast [@focus,harm,nodead][] {9484}" },
	{ class = "DRUID", key = "hibernate", name = "Hibernate", need = 2637, level = 18, talent = false, warn = nil,
		tpl = "#showtooltip {2637}\n/focus [@focus,noexists][@focus,dead][mod:ctrl]\n/cast [@focus,harm,nodead][] {2637}" },
	-- Idea 9: rogue. Sprint and Vanish have no global cooldown and Sprint does not break Stealth (DB2 GEMETEN).
	{ class = "ROGUE", key = "stealth", name = "Stealth", need = 1784, level = 1, talent = false, warn = nil,
		tpl = "#showtooltip {1784}\n/cast [mod:ctrl] {2983}\n/cast [nostealth] {1784}" },
	{ class = "ROGUE", key = "vanish", name = "VanishSprint", need = 1856, level = 22, talent = false, warn = nil,
		tpl = "#showtooltip {1856}\n/cast {2983}\n/cast {1856}" },
	{ class = "ROGUE", key = "finisher", name = "Finisher", need = 2098, level = 1, talent = false, warn = nil,
		tpl = "#showtooltip\n/startattack\n/cast [mod:ctrl] {5171}; {2098}" },
	-- Idea 10: shaman fire totem, Ctrl = Magma (26). Recall/Call sit in the Totems row already.
	{ class = "SHAMAN", key = "firetotem", name = "Fire Totem", need = 3599, level = 10, talent = false, warn = nil,
		tpl = "#showtooltip\n/cast [mod:ctrl] {8190}; {3599}" },
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
		id = tonumber(id)
		local nm = SpellName(TopKnown(id) or id) -- the name of the rank you know (see TopKnown)
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
			return SpellName(TopKnown(c.need) or c.need) or c.name
		end,
		desc = (c.spec and "FMAC_S_" or "FMAC_C_") .. c.class .. "_" .. c.key:upper(),
		build = function()
			if not TopKnown(c.need) then
				local lvl = UnitLevel and UnitLevel("player") or 0
				-- A talent comes sooner with the Legacy perk Talented (17 Nov 2026).
				local need = c.level and (c.talent and ns.ForeverTalentLevel and ns.ForeverTalentLevel(c.level) or c.level)
				if need and lvl < need then
					return nil, "FMAC_WHY_LEVEL_FMT", need
				end
				return nil, "FMAC_WHY_TRAIN"
			end
			-- 17 Nov 2026: a row whose text depends on your bags or form bar builds its own template (`tplFn`).
			local tpl, why, arg = c.tpl, nil, nil
			if c.tplFn then
				tpl, why, arg = c.tplFn()
				if not tpl then
					return nil, why or "FMAC_WHY_FAILED", arg
				end
			end
			local body = FillTpl(tpl)
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

--------------------------------------------------------------------------------
-- Spec macros. Rob, 10 Nov 2026: "Ja bouw maar" on the top 3 per spec (27 specs) from
-- docs/forever/FOREVER_MACROS_SPECS_2026-11-10.md. Same row format as CLASS_MACROS plus `spec` (1/2/3 = talent tree
-- left/middle/right) and `credit` ("cwf" = text from classicwowforever.com, CC BY 4.0 → credit line in the window).
-- Shown: a talent row once its talent is known; a non-talent row only when your spec is that tree. Your spec first.
--------------------------------------------------------------------------------
-- 81 rows, ids GEMETEN in wago DB2 Forever 1.60.1.70862 (talent = TraitDefinition in that tree's band). `level`
-- of a talent row = max(spell level, 10 + points its row needs): the +10 is AFGELEID. Not tested in the client.
local SPEC_MACROS = {
	-- WARRIOR spec 1
	{ class = "WARRIOR", spec = 1, key = "mortalstrike", name = "MortalStrike", need = 12294, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip [mod:shift] {1715}; {12294}\n/startattack\n/cast [mod:shift] {1715}; {12294}" },
	{ class = "WARRIOR", spec = 1, key = "sweeping", name = "Sweeping", need = 12292, level = 30, talent = true, warn = "twopress", credit = "cwf", -- NEW #2
		tpl = "#showtooltip {12292}\n/cast [nostance:1] {2457}\n/cast {12292}" },
	{ class = "WARRIOR", spec = 1, key = "spearing", name = "Spearing", need = 1310222, level = 25, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {1310222}\n/startattack\n/cast {1310222}" },
	-- WARRIOR spec 2
	{ class = "WARRIOR", spec = 2, key = "bloodthirst", name = "Bloodthirst", need = 23881, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {23881}\n/startattack\n/cast {23881}\n/cast [mod:shift] {78}" },
	{ class = "WARRIOR", spec = 2, key = "deathwish", name = "Death Wish", need = 12328, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {12328}\n/cast {2687}\n/cast {12328}\n/use 14" },
	{ class = "WARRIOR", spec = 2, key = "whirlwind", name = "Whirlwind", need = 1680, level = 36, talent = false, warn = "twopress", credit = "cwf", -- NEW #3
		tpl = "#showtooltip {1680}\n/cast [nostance:3] {2458}\n/cast {1680}" },
	-- WARRIOR spec 3
	{ class = "WARRIOR", spec = 3, key = "shieldslam", name = "Shield Slam", need = 23922, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {23922}\n/startattack\n/cast {23922}\n/cast {6572}\n/cast {7386}" },
	{ class = "WARRIOR", spec = 3, key = "revenge", name = "Revenge", need = 6572, level = 14, talent = false, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {6572}\n/startattack\n/cast [mod:shift] {2565}\n/cast {6572}" },
	{ class = "WARRIOR", spec = 3, key = "shieldwall", name = "Shield Wall", need = 871, level = 28, talent = false, warn = "twopress", credit = "cwf", -- NEW #3
		tpl = "#showtooltip {871}\n/cast [mod:shift] {12975}\n/cast [nostance:2] {71}\n/cast {871}" },
	-- ROGUE spec 1
	{ class = "ROGUE", spec = 1, key = "coldblood", name = "Cold Blood", need = 14177, level = 25, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip [mod:shift] {399956}; {2098}\n/cast {14177}\n/cast [mod:shift] {399956}; {2098}" },
	{ class = "ROGUE", spec = 1, key = "mutilate", name = "Mutilate", need = 399956, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {399956}\n/startattack\n/cast {399956}" },
	{ class = "ROGUE", spec = 1, key = "shankvenom", name = "Shank Venom", need = 399956, level = 40, talent = true, warn = nil, credit = "cwf", -- REPLACES #3 (Venom is passive)
		tpl = "#showtooltip {1329283}\n/startattack\n/cast {1329283}\n/cast {399956}" },
	-- ROGUE spec 2
	{ class = "ROGUE", spec = 2, key = "adrenaline", name = "Adrenaline", need = 13750, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {13750}\n/use 13\n/use 14\n/cast {13750}" },
	{ class = "ROGUE", spec = 2, key = "bladeflurry", name = "Blade Flurry", need = 13877, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {13877}\n/cancelaura [mod:shift] {13877}\n/startattack [nomod]\n/cast [nomod] {13877}" },
	{ class = "ROGUE", spec = 2, key = "riposte", name = "Riposte", need = 14251, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {1752}\n/startattack\n/cast {14251}\n/cast {1752}" },
	-- ROGUE spec 3
	{ class = "ROGUE", spec = 3, key = "premed", name = "Premeditate", need = 14183, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip [mod:shift] {8676}; {703}\n/cast [stealth] {14183}\n/cast [mod:shift] {8676}; {703}" },
	{ class = "ROGUE", spec = 3, key = "ghostly", name = "Ghostly", need = 14278, level = 25, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {14278}\n/startattack [nostealth]\n/cast {14278}\n/cast {53}" },
	{ class = "ROGUE", spec = 3, key = "preparation", name = "Preparation", need = 14185, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {14185}\n/stopattack [mod:shift]\n/cast [mod:shift] {1856}; {5277}\n/cast {2983}\n/cast {14185}" },
	-- HUNTER spec 1
	{ class = "HUNTER", spec = 1, key = "intimidate", name = "Intimidation", need = 19577, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {19577}\n/petattack\n/cast {19577}" },
	{ class = "HUNTER", spec = 1, key = "bestialwrath", name = "BestialWrath", need = 19574, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {19574}\n/petattack\n/use 13\n/cast [mod:shift] {3045}\n/cast {19574}" },
	{ class = "HUNTER", spec = 1, key = "hawk", name = "Summon Hawk", need = 1293241, level = 25, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {1293241}\n/petattack [@mouseover,harm,nodead][]\n/cast [@mouseover,harm,nodead][] {1293241}" },
	-- HUNTER spec 2
	{ class = "HUNTER", spec = 2, key = "scatter", name = "Scatter Shot", need = 19503, level = 30, talent = true, warn = nil, credit = nil, -- NEW #1
		tpl = "#showtooltip {19503}\n/petfollow\n/cast [@mouseover,harm,nodead][] {19503}" },
	{ class = "HUNTER", spec = 2, key = "aimedmulti", name = "Aimed+Multi", need = 19434, level = 20, talent = false, warn = nil, credit = "cwf", -- H3 #2
		tpl = "#showtooltip\n/cast [mod:shift] {2643}; [mod:ctrl,@mouseover,harm,nodead] {2643}; {19434}\n/cast !{75}" },
	{ class = "HUNTER", spec = 2, key = "snipershot", name = "Sniper Shot", need = 1310687, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #4 (replaces #3 H1-type)
		tpl = "#showtooltip {1310687}\n/cast [mod:shift,@mouseover,harm,nodead][] {1310687}\n/cast !{75}" },
	-- HUNTER spec 3
	{ class = "HUNTER", spec = 3, key = "striderkick", name = "Strider Kick", need = 1317257, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {1317257}\n/startattack [nomod]\n/cast [mod:shift,@mouseover,harm,nodead][] {1317257}" },
	{ class = "HUNTER", spec = 3, key = "counterattack", name = "Counter Atk", need = 19306, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {19306}\n/cast [mod:shift] {19263}\n/startattack\n/cast [@mouseover,harm,nodead][] {19306}" },
	{ class = "HUNTER", spec = 3, key = "deterrence", name = "Deterrence", need = 19263, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {19263}\n/cast {19263}\n/cast !{13163}" },
	-- PALADIN spec 1
	{ class = "PALADIN", spec = 1, key = "lightsvigil", name = "Light Vigil", need = 1310911, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #2 (#1 = built holyshock)
		tpl = "#showtooltip [mod:shift] {1311606}; {1310911}\n/cast [mod:shift,@mouseover,exists,nodead][mod:shift,exists,nodead] {1311606}; [@mouseover,help,nodead][help,nodead][@player] {1310911}" },
	{ class = "PALADIN", spec = 1, key = "divinefavor", name = "DivineFavor", need = 20216, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip [mod:shift] {19750}; {635}\n/cast {20216}\n/cast [mod:shift,@mouseover,help,nodead][mod:shift] {19750}; [@mouseover,help,nodead][help,nodead][@player] {635}",
		tplShort = "#showtooltip\n/cast {20216}\n/cast [mod:shift] {19750}; [@mouseover,help,nodead][help,nodead][@player] {635}" },
	{ class = "PALADIN", spec = 1, key = "cleanse", name = "Cleanse", need = 1152, level = 8, talent = false, warn = nil, credit = "cwf", -- NEW #5 (#4 = built P7)
		tpl = "#showtooltip\n/cast [@mouseover,help,nodead][help,nodead][@player] {4987}\n/cast [@mouseover,help,nodead][help,nodead][@player] {1152}" },
	-- PALADIN spec 2
	{ class = "PALADIN", spec = 2, key = "judgement", name = "Judgement", need = 20271, level = 4, talent = false, warn = nil, credit = nil, -- P4 #1
		tpl = "#showtooltip {20271}\n/cast [mod:shift,@mouseover,harm,nodead][mod:shift] {1310994}; [@mouseover,harm,nodead][] {20271}" },
	{ class = "PALADIN", spec = 2, key = "righteous", name = "Righteous", need = 407632, level = 40, talent = false, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip [mod:shift] {679}; {407632}\n/startattack\n/cast [mod:shift] {679}; {407632}" },
	{ class = "PALADIN", spec = 2, key = "holyshield", name = "Holy Shield", need = 20925, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {20925}\n/startattack\n/cast {20271}\n/cast {20925}" },
	-- PALADIN spec 3
	{ class = "PALADIN", spec = 3, key = "sealcommand", name = "Seal Command", need = 20375, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip [mod:shift] {20375}; {20271}\n/cast [mod:shift] {20375}; {20271}" },
	{ class = "PALADIN", spec = 3, key = "retopener", name = "Ret Opener", need = 20375, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #3 (#2 = built P2)
		tpl = "#showtooltip\n/castsequence reset=10 {21082}, {20271}, {20375}\n/startattack" },
	{ class = "PALADIN", spec = 3, key = "hammerwrath", name = "HammerWrath", need = 24275, level = 44, talent = false, warn = nil, credit = "cwf", -- NEW #4
		tpl = "#showtooltip [mod:shift] {24275}; {679}\n/startattack\n/cast [mod:shift] {24275}; {679}" },
	-- SHAMAN spec 1
	{ class = "SHAMAN", spec = 1, key = "lightmastery", name = "Lightning", need = 16166, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip [mod:shift] {421}; {403}\n/cast {16166}\n/cast [mod:shift] {421}; {403}" },
	{ class = "SHAMAN", spec = 1, key = "boltchain", name = "Bolt+Chain", need = 403, level = 1, talent = false, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip [mod:shift] {421}; {403}\n/stopcasting [mod:shift]\n/cast [mod:shift] {421}; {403}" },
	{ class = "SHAMAN", spec = 1, key = "earthbind", name = "Earthbind", need = 2484, level = 6, talent = false, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip [mod:shift] {8056}; {2484}\n/stopcasting\n/cast [mod:shift,@mouseover,harm,nodead][mod:shift] {8056}; {2484}" },
	-- SHAMAN spec 2
	-- level 25, was 40 (12 Nov 2026, Rob: "Ja, laat hem die twee spell-levels meten en gelijktrekken"). GEMETEN in DB2
	-- wowf 1.60.1.70888: TraitDefinition 134204 -> node 104743 (tree 1082) -> group 11353 -> TraitCond 42798,
	-- SpentAmountRequired 15, so the 16th talent point = level 25. Same as ForeverHowToPlay.lua (Shaman, "25").
	{ class = "SHAMAN", spec = 2, key = "stormstrike", name = "Stormstrike", need = 17364, level = 25, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {17364}\n/startattack\n/cast {17364}" },
	{ class = "SHAMAN", spec = 2, key = "shockswing", name = "Shock+Swing", need = 8050, level = 10, talent = false, warn = nil, credit = nil, -- S8 #2
		tpl = "#showtooltip [mod:shift] {8056}; {8050}\n/startattack\n/cast [mod:shift] {8056}; {8050}" },
	{ class = "SHAMAN", spec = 2, key = "farseer", name = "Rage Farseer", need = 425336, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {425336}\n/startattack\n/use 13\n/use 14\n/cast {425336}\n/cast {17364}" },
	-- SHAMAN spec 3
	{ class = "SHAMAN", spec = 3, key = "swiftwave", name = "Swift Wave", need = 16188, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {331}\n/cast {16188}\n/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] {1064}; [@mouseover,help,nodead][help,nodead][@player] {331}",
		tplShort = "#showtooltip {331}\n/cast {16188}\n/cast [mod:shift] {1064}; [@mouseover,help,nodead][help,nodead][@player] {331}" },
	{ class = "SHAMAN", spec = 3, key = "riptide", name = "Riptide", need = 408521, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {408521}\n/cast [@mouseover,help,nodead][help,nodead][@player] {408521}" },
	{ class = "SHAMAN", spec = 3, key = "chainheal", name = "Chain Heal", need = 1064, level = 40, talent = false, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {1064}\n/cast [@mouseover,help,nodead][help,nodead][@player] {1064}" },
	-- MAGE spec 1
	{ class = "MAGE", spec = 1, key = "arcanepower", name = "Arcane Power", need = 12042, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {400574}\n/use 13\n/use 14\n/cast {12042}\n/cast [nochanneling] {400574}" },
	{ class = "MAGE", spec = 1, key = "arcaneblast", name = "Arcane Blast", need = 400574, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {400574}\n/cast [mod:shift,nochanneling] {5143}; [mod:ctrl,nochanneling] {116}; [nochanneling] {400574}" },
	{ class = "MAGE", spec = 1, key = "arcanewrath", name = "Arcane Wrath", need = 1326079, level = 25, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {1326079}\n/stopcasting\n/use [mod:shift] 13\n/use [mod:shift] 14\n/cast [mod:shift] {12042}\n/cast {12043}\n/cast {1326079}" },
	-- MAGE spec 2
	{ class = "MAGE", spec = 2, key = "pyroopener", name = "Pyro Opener", need = 11366, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip [nocombat] {11366}; {133}\n/cast [nocombat] {11366}; {133}" },
	{ class = "MAGE", spec = 2, key = "combustion", name = "Combustion", need = 11129, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {11129}\n/use 13\n/use 14\n/cast {11129}\n/cast [mod:shift] {2948}; {133}" },
	{ class = "MAGE", spec = 2, key = "blastwave", name = "Blast Wave", need = 11113, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {11113}\n/stopcasting\n/cast {11113}" },
	-- MAGE spec 3
	{ class = "MAGE", spec = 3, key = "iceblock", name = "Ice Block", need = 11958, level = 25, talent = true, warn = nil, credit = "cwf", -- M6 #1
		tpl = "#showtooltip [mod:shift] {12472}; {11958}\n/stopcasting\n/cancelaura {11958}\n/cast [mod:shift] {12472}; {11958}" },
	{ class = "MAGE", spec = 3, key = "icelance", name = "Ice Lance", need = 1312002, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {1312002}\n/stopcasting\n/cast [mod:shift] {2136}; [mod:ctrl] {120}; {1312002}" },
	{ class = "MAGE", spec = 3, key = "icebarrier", name = "Ice Barrier", need = 11426, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {11426}\n/stopcasting\n/cast [mod:shift] {12472}\n/cast {11426}" },
	-- WARLOCK spec 1
	{ class = "WARLOCK", spec = 1, key = "exhaustion", name = "Exhaustion", need = 18223, level = 25, talent = true, warn = nil, credit = "cwf", -- NEW #2 (#1 = built agony)
		tpl = "#showtooltip {18223}\n/stopcasting\n/cast {18288}\n/cast [@mouseover,harm,nodead][] {18223}" },
	{ class = "WARLOCK", spec = 1, key = "channels", name = "Channels", need = 689, level = 14, talent = false, warn = nil, credit = "cwf", -- W6 #3
		tpl = "#showtooltip\n/cast [mod:alt] {1454}; [nochanneling,mod:ctrl] {1316697}; [nochanneling,mod:shift] {1120}; [nochanneling] {689}" },
	{ class = "WARLOCK", spec = 1, key = "siphonlife", name = "Siphon Life", need = 18265, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #4
		tpl = "#showtooltip {18265}\n/cast [@mouseover,harm,nodead][] {18265}" },
	-- WARLOCK spec 2
	{ class = "WARLOCK", spec = 2, key = "demonsac", name = "Demon Sac", need = 18788, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #2 (#1 = built summon)
		tpl = "#showtooltip {18788}\n/cast {18788}\n/cast [mod:shift] {688}; [mod:ctrl] {697}; [mod:alt] {712}; {691}",
		tplShort = "#showtooltip\n/cast {18788}\n/cast [mod:shift] {688}; [mod:ctrl] {697}; [mod:alt] {712}; {691}" },
	{ class = "WARLOCK", spec = 2, key = "healthfunnel", name = "HealthFunnel", need = 755, level = 12, talent = false, warn = nil, credit = "cwf", -- W3 #3
		tpl = "#showtooltip {755}\n/stopcasting [mod:shift]\n/stopmacro [mod:shift]\n/cast [@pet,exists,nodead,nochanneling] {755}" },
	{ class = "WARLOCK", spec = 2, key = "searingpain", name = "Searing Pain", need = 5676, level = 18, talent = false, warn = nil, credit = "cwf", -- NEW #4
		tpl = "#showtooltip {5676}\n/petattack [@mouseover,harm,nodead][harm,nodead]\n/cast [@mouseover,harm,nodead][] {5676}" },
	-- WARLOCK spec 3
	{ class = "WARLOCK", spec = 3, key = "banehavoc", name = "Bane Havoc", need = 1225228, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {1225228}\n/cast [@mouseover,harm,nodead][] {1225228}" },
	{ class = "WARLOCK", spec = 3, key = "shadowburn", name = "Shadowburn", need = 17877, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {17877}\n/cast [@mouseover,harm,nodead][] {17877}" },
	{ class = "WARLOCK", spec = 3, key = "nukepicker", name = "Nuke Picker", need = 1293817, level = 25, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip\n/cast [mod:shift] {412758}; [mod:ctrl] {1293817}; [mod:alt] {17877}; {686}" },
	-- PRIEST spec 1
	{ class = "PRIEST", spec = 1, key = "powerinfuse", name = "Power Infuse", need = 10060, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #2 (#1 = built penance)
		tpl = "#showtooltip {10060}\n/cast [mod:alt,@player][@mouseover,help,nodead][help,nodead][@player] {10060}" },
	-- talentLevel 20: the macro needs Greater Heal (40), but the talent itself comes at 20 (row of 10 points; priest roles
	-- research 17 Nov 2026). "Do this now" names the TALENT level (ns.ForeverDirectionTalents).
	{ class = "PRIEST", spec = 1, key = "innerfocus", name = "Inner Focus", need = 14751, level = 40, talentLevel = 20, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {2060}\n/cast {14751}\n/cast [@mouseover,help,nodead][help,nodead][@player] {2060}" },
	{ class = "PRIEST", spec = 1, key = "prayerheal", name = "Prayer Heal", need = 596, level = 30, talent = false, warn = nil, credit = "cwf", -- P8 #4
		tpl = "#showtooltip {596}\n/cast [@mouseover,help,nodead][help,nodead][@player] {596}" },
	-- PRIEST spec 2
	{ class = "PRIEST", spec = 2, key = "mending", name = "PrayerMend", need = 401859, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {401859}\n/cast [@mouseover,help,nodead][help,nodead][@player] {401859}" },
	{ class = "PRIEST", spec = 2, key = "renew", name = "Renew", need = 139, level = 8, talent = false, warn = nil, credit = "cwf", -- P2 #2
		tpl = "#showtooltip {139}\n/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] {6077:rank}; [@mouseover,help,nodead][help,nodead][@player] {139}" },
	{ class = "PRIEST", spec = 2, key = "holynova", name = "Holy Nova", need = 15237, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {15237}\n/stopcasting [mod:shift]\n/cast [mod:shift] {15237}; {15237:rank}" },
	-- PRIEST spec 3
	{ class = "PRIEST", spec = 3, key = "silence", name = "Silence", need = 15487, level = 30, talent = true, warn = nil, credit = nil, -- NEW #1
		tpl = "#showtooltip {15487}\n/stopcasting\n/cast [@focus,harm,nodead][@mouseover,harm,nodead][] {15487}" },
	{ class = "PRIEST", spec = 3, key = "mindflay", name = "Mind Flay", need = 15407, level = 20, talent = true, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip {15407}\n/cast [nochanneling] {15407}" },
	{ class = "PRIEST", spec = 3, key = "shadowform", name = "Shadowform", need = 15473, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {15473}\n/cancelaura [mod:shift] {15473}\n/cast [nomod,noform:1] {15473}" },
	-- DRUID spec 1
	{ class = "DRUID", spec = 1, key = "insectswarm", name = "InsectSwarm", need = 5570, level = 25, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {5570}\n/cast [@mouseover,harm,nodead][] {5570}" },
	{ class = "DRUID", spec = 1, key = "starwrath", name = "Starfire", need = 2912, level = 20, talent = false, warn = nil, credit = "cwf", -- NEW #2
		tpl = "#showtooltip [mod:shift] {5176}; {2912}\n/cast [mod:shift] {5176}; {2912}" },
	{ class = "DRUID", spec = 1, key = "moonkinheal", name = "Moonkin Heal", need = 24858, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip\n/cancelform\n/castsequence [@player] reset=10 {8936}, {24858}" },
	-- DRUID spec 2
	{ class = "DRUID", spec = 2, key = "feralcharge", name = "Feral Charge", need = 1238122, level = 20, talent = true, warn = nil, credit = nil, -- NEW #1
		tpl = "#showtooltip {1238122}\n/cast {1238122}\n/startattack" },
	{ class = "DRUID", spec = 2, key = "growl", name = "Growl", need = 6795, level = 10, talent = false, warn = nil, credit = "cwf", -- DX3 #2
		tpl = "#showtooltip {6795}\n/cast [@mouseover,harm,nodead][] {6795}" },
	-- level 40 stays: GEMETEN 12 Nov 2026 in DB2 wowf 1.60.1.70888: TraitDefinition 134417 -> node 104956 (tree 1089) ->
	-- group 11341 -> TraitCond 42781, SpentAmountRequired 30, so the 31st talent point = level 40. Blizzard's beta deep
	-- dive (30 Sep) called it a 16-point talent; the live build does not.
	{ class = "DRUID", spec = 2, key = "primalbite", name = "Primal Bite", need = 407995, level = 40, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {407995}\n/startattack\n/cast {407995}" },
	-- DRUID spec 3
	{ class = "DRUID", spec = 3, key = "swifttouch", name = "Swift Touch", need = 17116, level = 30, talent = true, warn = nil, credit = "cwf", -- NEW #1
		tpl = "#showtooltip {17116}\n/cancelform\n/cast {17116}\n/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] {8936}; [@mouseover,help,nodead][help,nodead][@player] {5185}",
		tplShort = "#showtooltip\n/cancelform\n/cast {17116}\n/cast [mod:shift] {8936}; [@mouseover,help,nodead][help,nodead][@player] {5185}" },
	{ class = "DRUID", spec = 3, key = "rebirth", name = "Rebirth", need = 20484, level = 20, talent = false, warn = nil, credit = "cwf", -- D5 #2
		tpl = "#showtooltip [combat] {20484}; {437138}\n/cast [@mouseover,help,dead,combat][help,dead,combat] {20484}\n/cast [@mouseover,help,dead,nocombat][help,dead,nocombat] {437138}" },
	{ class = "DRUID", spec = 3, key = "swiftmend", name = "Swiftmend", need = 18562, level = 25, talent = true, warn = nil, credit = "cwf", -- NEW #3
		tpl = "#showtooltip {18562}\n/cast [@mouseover,help,nodead][help,nodead][@player] {18562}" },
}
-- Tree names per client, GEMETEN in DB2 TalentTab; deDE 'Verstärk'/'Wiederherst' are cut short in Blizzard's data,
-- written out in full here (AFGELEID). No itIT (wago has English only); itIT falls back to enUS.
local SPEC_NAMES = {
	WARRIOR = {
		enUS = { "Arms", "Fury", "Protection" },
		deDE = { "Waffen", "Furor", "Schutz" },
		frFR = { "Armes", "Fureur", "Protection" },
		esES = { "Armas", "Furia", "Protección" },
		esMX = { "Armas", "Furia", "Protección" },
		ptBR = { "Armas", "Fúria", "Proteção" },
		ruRU = { "Оружие", "Неистовство", "Защита" },
	},
	PALADIN = {
		enUS = { "Holy", "Protection", "Retribution" },
		deDE = { "Heilig", "Schutz", "Vergeltung" },
		frFR = { "Sacré", "Protection", "Vindicte" },
		esES = { "Sagrado", "Protección", "Reprensión" },
		esMX = { "Sagrado", "Protección", "Reprensión" },
		ptBR = { "Sagrado", "Proteção", "Retribuição" },
		ruRU = { "Свет", "Защита", "Воздаяние" },
	},
	HUNTER = {
		enUS = { "Beast Mastery", "Marksmanship", "Survival" },
		deDE = { "Tierherrschaft", "Treffsicherheit", "Überleben" },
		frFR = { "Maîtrise des bêtes", "Précision", "Survie" },
		esES = { "Dominio de bestias", "Puntería", "Supervivencia" },
		esMX = { "Bestias", "Puntería", "Supervivencia" },
		ptBR = { "Domínio das Feras", "Precisão", "Sobrevivência" },
		ruRU = { "Чувство зверя", "Стрельба", "Выживание" },
	},
	ROGUE = {
		enUS = { "Assassination", "Combat", "Subtlety" },
		deDE = { "Meucheln", "Kampf", "Täuschung" },
		frFR = { "Assassinat", "Combat", "Finesse" },
		esES = { "Asesinato", "Combate", "Sutileza" },
		esMX = { "Asesinato", "Combate", "Sutileza" },
		ptBR = { "Assassinato", "Combate", "Subterfúgio" },
		ruRU = { "Ликвидация", "Бой", "Скрытность" },
	},
	PRIEST = {
		enUS = { "Discipline", "Holy", "Shadow" },
		deDE = { "Disziplin", "Heilig", "Schatten" },
		frFR = { "Discipline", "Sacré", "Ombre" },
		esES = { "Disciplina", "Sagrado", "Sombra" },
		esMX = { "Disciplina", "Sagrado", "Sombra" },
		ptBR = { "Disciplina", "Sagrado", "Sombra" },
		ruRU = { "Послушание", "Свет", "Тьма" },
	},
	SHAMAN = {
		enUS = { "Elemental", "Enhancement", "Restoration" },
		deDE = { "Elementar", "Verstärkung", "Wiederherstellung" },
		frFR = { "Elémentaire", "Amélioration", "Restauration" },
		esES = { "Elemental", "Mejora", "Recuperación" },
		esMX = { "Elemental", "Mejora", "Restauración" },
		ptBR = { "Elemental", "Aperfeiçoamento", "Restauração" },
		ruRU = { "Стихии", "Совершенствование", "Исцеление" },
	},
	MAGE = {
		enUS = { "Arcane", "Fire", "Frost" },
		deDE = { "Arkan", "Feuer", "Frost" },
		frFR = { "Arcanes", "Feu", "Givre" },
		esES = { "Arcano", "Fuego", "Escarcha" },
		esMX = { "Arcano", "Fuego", "Escarcha" },
		ptBR = { "Arcano", "Fogo", "Gelo" },
		ruRU = { "Тайная магия", "Огонь", "Лед" },
	},
	WARLOCK = {
		enUS = { "Affliction", "Demonology", "Destruction" },
		deDE = { "Gebrechen", "Dämonologie", "Zerstörung" },
		frFR = { "Affliction", "Démonologie", "Destruction" },
		esES = { "Aflicción", "Demonología", "Destrucción" },
		esMX = { "Aflicción", "Demonología", "Destrucción" },
		ptBR = { "Suplício", "Demonologia", "Destruição" },
		ruRU = { "Колдовство", "Демонология", "Разрушение" },
	},
	DRUID = {
		enUS = { "Balance", "Feral Combat", "Restoration" },
		deDE = { "Gleichgewicht", "Wilder Kampf", "Wiederherstellung" },
		frFR = { "Equilibre", "Combat farouche", "Restauration" },
		esES = { "Equilibrio", "Combate feral", "Recuperación" },
		esMX = { "Equilibrio", "Combate feral", "Restauración" },
		ptBR = { "Equilíbrio", "Combate Feral", "Restauração" },
		ruRU = { "Баланс", "Сила зверя", "Исцеление" },
	},
}

-- Trait tree per class, GEMETEN in wago DB2 TraitTree (Forever 1.60.1.70862); the three talent tabs are PosX bands
-- 1020-2820 / 5020-6820 / 9080-10880 (DB2, cross-checked 467/467 against TalentsForeverBook). Reading them through
-- C_ClassTalents/C_Traits is AFGELEID: Wow.exe has those names and not GetTalentTabInfo (measured), not run in game.
local TREE = { WARRIOR = 1117, PALADIN = 1100, HUNTER = 1091, ROGUE = 1111, PRIEST = 1114, SHAMAN = 1082, MAGE = 1112,
	WARLOCK = 1116, DRUID = 1089 }

--- @return band (1-3) or nil, the points table, and a reason when nil.
local function SpecBand()
	local _, cls = UnitClass("player")
	local tree = TREE[cls]
	if not (tree and C_Traits and C_Traits.GetTreeNodes and C_Traits.GetNodeInfo) then
		return nil, nil, "no C_Traits"
	end
	local ok, best, pts, why = pcall(function()
		local cfg = C_ClassTalents and C_ClassTalents.GetActiveConfigID and C_ClassTalents.GetActiveConfigID()
		local info = cfg and C_Traits.GetConfigInfo and C_Traits.GetConfigInfo(cfg)
		local has = false
		for _, t in ipairs(info and info.treeIDs or {}) do
			if t == tree then
				has = true
			end
		end
		if not has and C_Traits.GetConfigIDByTreeID then
			cfg = C_Traits.GetConfigIDByTreeID(tree)
		end
		if not cfg then
			return nil, nil, "no config"
		end
		local p = { 0, 0, 0 }
		for _, id in ipairs(C_Traits.GetTreeNodes(tree) or {}) do
			local n = C_Traits.GetNodeInfo(cfg, id)
			if n and type(n.posX) == "number" then
				local b = n.posX < 4000 and 1 or (n.posX < 8000 and 2 or 3)
				p[b] = p[b] + (n.ranksPurchased or 0)
			end
		end
		local top = (p[1] >= p[2] and p[1] >= p[3]) and 1 or (p[2] >= p[3] and 2 or 3)
		if p[top] == 0 then
			return nil, p, "no points"
		end
		for b = 1, 3 do
			if b ~= top and p[b] == p[top] then
				return nil, p, "tie"
			end
		end
		return top, p
	end)
	if not ok then
		return nil, nil, "error: " .. tostring(best)
	end
	return best, pts, why
end

local function SpecName(cls, band)
	local t = SPEC_NAMES[cls]
	if not t then
		return nil
	end
	local loc = GetLocale and GetLocale() or "enUS"
	local names = t[loc] or (loc == "esMX" and t.esES) or t.enUS
	return names and names[band]
end
-- 12 Nov 2026: the "Which way?" question (ForeverDirection.lua) uses the same tree names and the same point count.
ns.ForeverSpecBand = SpecBand
ns.ForeverSpecName = SpecName

--[[ The Legacy perk Talented (17 Nov 2026; Rob via Sparring 17-11: "het gat met talented als fout laten repareren").
	GEMETEN by sparring's helper in DB2 1.60.1.70938: TraitCurrencySource 37163-37167 give 1 class talent point (currency
	3820) at PlayerLevel 9/8/7/6/5 for Talented rank 1-5; the perk is node 110298 in tree 1188 (spell 1225474).
	AFGELEID: talent points at level L = L - 9 + rank, so a talent of "level B" (first point at 10) comes at B - rank;
	the config is found with C_Traits.GetConfigIDBySystemID(45) or GetConfigIDByTreeID(1188); the rank comes from WHICH
	tier entry is active (see TALENTED_ENTRY_RANK below; corrected the same day). NOT measured in the client: what we read is written to ns.db.foreverTalentedProbe
	(Rob: /reload, then the SavedVariables file says it). nil = not readable: the texts then say "sooner with Talented". ]]
local TALENTED_NODE, LEGACY_SYSTEM, ADVENTURE_TREE = 110298, 45, 1188
-- GEMETEN 17 Nov 2026 in DB2 1.60.1.70938 (local cache): TraitNode 110298 has Type 1 (tiered; plain talents are 0, control
-- nodes 104743 / 104956); TraitNodeXTraitNodeEntry gives five entries, each MaxRanks 1, in _Index order 100..500:
-- 136852, 137374, 137373, 137372, 137371 = rank 1..5. So the rank is WHICH entry is active, not currentRank (a hint from
-- sparring's look at another addon, measured here in our own data). Which field the client fills = NOT measured yet:
-- the probe below stores them all.
local TALENTED_ENTRY_RANK = { [136852] = 1, [137374] = 2, [137373] = 3, [137372] = 4, [137371] = 5 }

function ns.ForeverTalentedRank()
	if not (C_Traits and C_Traits.GetNodeInfo) then
		return nil, "no C_Traits.GetNodeInfo"
	end
	-- By tree first, the way Blizzard's own Legacy window does it (GEMETEN in Blizzard_LegacySystemUtil.lua, build 70938,
	-- docs/forever/LEGACY_VERIFIED_2026-11-17.md 7.x); the system id only as a fallback (Blizzard does not use it).
	local cfg, src
	if C_Traits.GetConfigIDByTreeID then
		local ok, v = pcall(C_Traits.GetConfigIDByTreeID, ADVENTURE_TREE)
		if ok and type(v) == "number" and v > 0 then
			cfg, src = v, "tree 1188"
		end
	end
	if not cfg and C_Traits.GetConfigIDBySystemID then
		local ok, v = pcall(C_Traits.GetConfigIDBySystemID, LEGACY_SYSTEM)
		if ok and type(v) == "number" and v > 0 then
			cfg, src = v, "system 45"
		end
	end
	local rank, why
	local probe = { cfg = cfg, src = src }
	local function num(v)
		if type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
			return v
		end
		return nil
	end
	if cfg then
		local ok, info = pcall(C_Traits.GetNodeInfo, cfg, TALENTED_NODE)
		if ok and type(info) == "table" then
			local cur, bought = num(info.currentRank), num(info.ranksPurchased)
			local entry = type(info.activeEntry) == "table" and num(info.activeEntry.entryID) or nil
			probe.currentRank, probe.ranksPurchased, probe.maxRanks = cur, bought, num(info.maxRanks)
			probe.activeEntry, probe.activeRank = entry, num(type(info.activeEntry) == "table" and info.activeEntry.rank)
			if type(info.entryIDs) == "table" then
				probe.entryIDs = {}
				for i, e in ipairs(info.entryIDs) do
					probe.entryIDs[i] = num(e)
				end
			end
			--- 🔴 GEMETEN 17 Nov 2026 on Rob's account WITHOUT Legacy (earned 0, cap 0; foreverTalentedProbe):
			--- activeEntry = 136852 (the rank-1 entry) while currentRank, ranksPurchased and activeEntry.rank are all 0.
			--- A tiered node points at its FIRST entry even when nothing is bought, so the entry alone said "rank 1" and
			--- every talent level came out one level too early. The entry only counts when something is bought.
			local activeRank = probe.activeRank
			local anyBought = (cur and cur > 0) or (bought and bought > 0) or (activeRank and activeRank > 0)
			local allZero = (cur == 0 or cur == nil) and (bought == 0 or bought == nil) and (activeRank == 0 or activeRank == nil)
				and (cur ~= nil or bought ~= nil or activeRank ~= nil)
			if anyBought and entry and TALENTED_ENTRY_RANK[entry] then
				rank = TALENTED_ENTRY_RANK[entry]
			elseif allZero then
				rank = 0 -- nothing bought (whatever entry the node points at)
			else
				why = "rank not readable (no known active entry)"
			end
		else
			why = "node 110298 not readable"
		end
	else
		why = "no Legacy config"
	end
	if ns.db then
		probe.rank, probe.why, probe.at = rank, why, time and time() or nil
		ns.db.foreverTalentedProbe = probe
	end
	return rank, why or src
end

--- The earliest level of a talent of "level B" for this character: B - Talented rank (never below 5).
function ns.ForeverTalentLevel(base)
	local r = ns.ForeverTalentedRank()
	if type(r) == "number" and r > 0 then
		return math.max(5, base - r), true
	end
	return base, r ~= nil
end

--- The talent spells of one tree, lowest level first: { id, level, known } (SPEC_MACROS, talent = true; the levels follow
--- the "first point at 10, one per level" rule, AFGELEID except where a comment there says GEMETEN), corrected for the
--- Legacy perk Talented when its rank is readable (known = the rank was read). For "Do this now".
function ns.ForeverDirectionTalents(cls, band)
	local out = {}
	for _, d in ipairs(SPEC_MACROS) do
		if d.class == cls and d.spec == band and d.talent and d.need and d.level then
			local lvl, known = ns.ForeverTalentLevel(d.talentLevel or d.level)
			out[#out + 1] = { id = d.need, level = lvl, known = known }
		end
	end
	table.sort(out, function(a, b)
		return a.level < b.level
	end)
	return out
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
		if c.class == token and (not c.talent or TopKnown(c.need)) then
			if first then
				rows[#rows + 1] = { header = true, key = "c_header" }
				first = false
			end
			rows[#rows + 1] = ClassRow(c)
		end
	end
	local band = SpecBand()
	local picked, credit = {}, false
	for pass = 1, 2 do -- your spec first, then talent rows of the other trees
		for _, c in ipairs(SPEC_MACROS) do
			if c.class == token and ((pass == 1) == (c.spec == band)) then
				if (c.talent and TopKnown(c.need)) or (not c.talent and c.spec == band) then
					picked[#picked + 1] = c
					credit = credit or c.credit == "cwf"
				end
			end
		end
	end
	if #picked > 0 then
		rows[#rows + 1] = { header = true, key = "s_header", spec = band, credit = credit }
		for _, c in ipairs(picked) do
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
	-- Class rows built from your bags or form bar (tplFn, 17 Nov 2026): same rule, only a macro you already made.
	for _, d in ipairs(Rows()) do
		if d.cls and d.cls.tplFn and Exists(d) and d.build() then
			Make(d)
		end
	end
end

--------------------------------------------------------------------------------
-- Keys: does Shift/Ctrl/Alt + the macro's key reach the macro? (17 Nov 2026; /mh macros keys and the window)
--------------------------------------------------------------------------------
local KEY_BAR_PREFIXES = { "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton",
	"MultiBarLeftButton", "MultiBar5Button", "MultiBar6Button", "MultiBar7Button" }
local KEY_BAR_COMMANDS = { "ACTIONBUTTON", "MULTIACTIONBAR1BUTTON", "MULTIACTIONBAR2BUTTON", "MULTIACTIONBAR3BUTTON",
	"MULTIACTIONBAR4BUTTON", "MULTIACTIONBAR5BUTTON", "MULTIACTIONBAR6BUTTON", "MULTIACTIONBAR7BUTTON" }
local KEY_MODS = { "ALT", "CTRL", "SHIFT" } -- the client's own order in a key name (ALT-CTRL-SHIFT-1)

--- Which modifiers a macro body tests: mod:shift/ctrl/alt (also inside nomod: and a/b lists); a bare [mod] or [nomod]
--- tests all three.
local function MacroMods(body)
	local m, low = {}, (body or ""):lower()
	for list in low:gmatch("mod:([%a/]+)") do
		for w in list:gmatch("%a+") do
			if w == "shift" or w == "ctrl" or w == "alt" then
				m[w:upper()] = true
			end
		end
	end
	if low:find("mod[%],]") then
		m.SHIFT, m.CTRL, m.ALT = true, true, true
	end
	return m
end

--- "SHIFT-1" -> { SHIFT = true }, "1". The key "-" and "SHIFT--" stay intact.
local function SplitKey(key)
	local have, base = {}, key
	while true do
		local pre, rest = base:match("^(%u+)%-(.+)$")
		if pre == "ALT" or pre == "CTRL" or pre == "SHIFT" or pre == "META" then
			have[pre], base = true, rest
		else
			break
		end
	end
	return have, base
end

local function KeyText(key)
	return (GetBindingText and GetBindingText(key)) or key
end

--- Rob, 17 Nov 2026: "B" = a warning on the row plus a button that frees the key, but ONLY for Blizzard's own page keys
--- (Action Page 1-6, next/previous page). Never a key of MH's key block (MULTIACTIONBAR…), never another addon's.
local function Freeable(act)
	return type(act) == "string" and (act:match("^ACTIONPAGE%d$") ~= nil or act == "NEXTACTIONPAGE"
		or act == "PREVIOUSACTIONPAGE")
end

--- Taken combinations for one macro by name: { { key = "SHIFT-5", act = "ACTIONPAGE5", mod = "SHIFT" }, … } over every
--- Blizzard bar button that holds it and has a key.
local function MacroClashes(name)
	local out, seen = {}, {}
	local idx = GetMacroIndexByName and GetMacroIndexByName(name) or 0
	if not (idx and idx > 0) then
		return out
	end
	local mods = MacroMods(select(3, GetMacroInfo(idx)))
	for n, prefix in ipairs(KEY_BAR_PREFIXES) do
		for i = 1, 12 do
			local b = _G[prefix .. i]
			local slot = b and b.action
			if b and type(slot) ~= "number" and ActionButton_GetPagedID then
				local ok, v = pcall(ActionButton_GetPagedID, b)
				slot = ok and v or nil
			end
			if type(slot) == "number" and GetActionInfo and GetActionInfo(slot) == "macro"
				and GetActionText and GetActionText(slot) == name then
				local command = KEY_BAR_COMMANDS[n] .. i
				for _, key in ipairs(GetBindingKey and { GetBindingKey(command) } or {}) do
					local have, base = SplitKey(key)
					for _, m in ipairs(KEY_MODS) do
						if mods[m] and not have[m] then
							local combo = {}
							for _, mm in ipairs(KEY_MODS) do
								if have[mm] or mm == m then
									combo[#combo + 1] = mm
								end
							end
							combo[#combo + 1] = base
							local comboKey = table.concat(combo, "-")
							local okA, act = pcall(GetBindingAction, comboKey, true)
							if okA and act and act ~= "" and act ~= command and not seen[comboKey] then
								seen[comboKey] = true
								out[#out + 1] = { key = comboKey, act = act, mod = m }
							end
						end
					end
				end
			end
		end
	end
	return out
end

--- Unbind the freeable keys of a clash list; remembered in ns.db.foreverFreedKeys for the undo.
local function FreeKeys(list)
	if InCombatLockdown and InCombatLockdown() then
		print(PREFIX .. ns:L("FMAC_WHY_COMBAT"))
		return 0
	end
	local db = ns.db
	if db then
		db.foreverFreedKeys = db.foreverFreedKeys or {}
	end
	local n = 0
	for _, c in ipairs(list) do
		if Freeable(c.act) and GetBindingAction(c.key, true) == c.act then
			pcall(SetBinding, c.key) -- no command = unbind; verified by reading the key back
			local after = GetBindingAction(c.key, true)
			if after == nil or after == "" then
				n = n + 1
				if db then
					table.insert(db.foreverFreedKeys, { key = c.key, was = c.act })
				end
				print(PREFIX .. ns:L("FMAC_KEY_FREED_FMT"):format(KeyText(c.key), _G["BINDING_NAME_" .. c.act] or c.act))
			end
		end
	end
	if n > 0 and SaveBindings and GetCurrentBindingSet then
		pcall(SaveBindings, GetCurrentBindingSet())
	end
	return n
end

--- Put every freed key back, if nothing else took it since.
local function UndoFreedKeys()
	if InCombatLockdown and InCombatLockdown() then
		print(PREFIX .. ns:L("FMAC_WHY_COMBAT"))
		return
	end
	local list = ns.db and ns.db.foreverFreedKeys
	if not (list and #list > 0) then
		print(PREFIX .. ns:L("FMAC_KEY_UNDO_NONE"))
		return
	end
	local n = 0
	for _, e in ipairs(list) do
		local now = GetBindingAction(e.key, true)
		if (now == nil or now == "") and SetBinding(e.key, e.was) then
			n = n + 1
		end
	end
	ns.db.foreverFreedKeys = nil
	if SaveBindings and GetCurrentBindingSet then
		pcall(SaveBindings, GetCurrentBindingSet())
	end
	print(PREFIX .. ns:L("FMAC_KEY_UNDONE_FMT"):format(n))
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
	f.hint:SetPoint("RIGHT", f, "RIGHT", -150, 0)
	f.hint:SetJustifyH("LEFT")
	-- 17 Nov 2026: puts back every key "Free key" took (shown only when there is something to undo).
	f.undo = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.undo:SetSize(118, 22)
	f.undo:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -24, 14)
	f.undo:SetScript("OnClick", function()
		UndoFreedKeys()
		Fill()
	end)
	f.undo:Hide()
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
	-- 17 Nov 2026 (Rob: "B"): frees a Blizzard page key that blocks this macro's Shift/Ctrl/Alt part.
	r.free = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
	r.free:SetSize(88, 22)
	r.free:SetPoint("TOP", r.go, "BOTTOM", 0, -2)
	r.free:SetScript("OnClick", function(self)
		if self.list then
			FreeKeys(self.list)
		end
		Fill()
	end)
	r.free:Hide()
	f.rows[i] = r
	return r
end

-- The client's own words, English as fallback. GEMETEN in GlobalStrings wowf 70938 deDE: SHIFT_KEY_TEXT "UMSCHALT",
-- CTRL_KEY_TEXT "STRG", ALT_KEY_TEXT "ALT" (capitals) → written as "Umschalt", "Strg", "Alt" (byte-wise lower: Cyrillic
-- stays as the client wrote it).
local function ModWord(g, fallback)
	if type(g) ~= "string" or g == "" then
		return fallback
	end
	return g:sub(1, 1) .. g:sub(2):lower()
end
local MOD_WORD = {
	SHIFT = ModWord(SHIFT_KEY_TEXT, "Shift"),
	CTRL = ModWord(CTRL_KEY_TEXT, "Ctrl"),
	ALT = ModWord(ALT_KEY_TEXT, "Alt"),
}

--- One row as the player reads it: title, the line under it (with warnings and taken keys), the keys "Free key" may
--- free, and the macro text (nil = cannot be made now). Shared by this window and the overview's Keys tab (17 Nov 2026,
--- product plan step 5) so both always say the same.
local function View(d)
	if d.header and d.key == "s_header" then
		local _, tok = UnitClass("player")
		local sn = d.spec and SpecName(tok, d.spec)
		return sn and ns:L("FMAC_SPEC_HEADER_FMT"):format(sn) or ns:L("FMAC_SPEC_HEADER_NONE"),
			ns:L("FMAC_SPEC_SUB") .. (d.credit and ("  |cff9d9d9d" .. ns:L("FMAC_SPEC_CREDIT") .. "|r") or "")
	elseif d.header then
		local cls = UnitClass and UnitClass("player") or ""
		return ns:L("FMAC_CLASS_HEADER_FMT"):format(cls), ns:L("FMAC_CLASS_SUB")
	end
	local title = d.plainTitleFn and d.plainTitleFn() or d.plainTitle or ns:L(d.title)
	local body, why, arg = d.build()
	local info = ns:L(d.descFn and d.descFn() or d.desc)
	if d.cls and d.cls.warn then
		info = info .. "  |cffffd200" .. ns:L(d.cls.warn == "twopress" and "FMAC_WARN_TWOPRESS"
			or "FMAC_WARN_FORMBAR") .. "|r"
	end
	-- Self Cast Key set + modifier + @mouseover in this macro: say so on the row (Core.lua, 16 Nov 2026).
	local scWarn = ns.SelfCastMacroWarning and ns.SelfCastMacroWarning(body)
	if scWarn then
		info = info .. "  " .. scWarn
	end
	if not body then
		local col = (why == "FMAC_WHY_LEVEL_FMT" or why == "FMAC_WHY_TRAIN") and "|cff9d9d9d" or "|cffff7f7f"
		info = info .. "  " .. col .. Why(why, arg) .. "|r"
	end
	-- Made and on a bar with a key: is Shift/Ctrl/Alt + that key taken by another binding? (Rob, 17 Nov 2026: "B")
	local freeable = {}
	if Exists(d) then
		for _, c in ipairs(MacroClashes(MacroName(d))) do
			info = info .. "\n|cffff7f7f" .. ns:L("FMAC_KEY_TAKEN_FMT"):format(KeyText(c.key),
				_G["BINDING_NAME_" .. c.act] or c.act, MOD_WORD[c.mod] or c.mod) .. "|r"
			if Freeable(c.act) then
				freeable[#freeable + 1] = c
			end
		end
	end
	-- 5th/6th (19 Nov 2026): why it cannot be made now and its argument (the level), for the overview's chip.
	return title, info, freeable, body, why, arg
end

--- The Make button: make or rewrite, say so in chat, open the macro window to drag it. @return true when made.
local function MakeClick(d)
	local ok, why, arg = Make(d)
	if ok then
		print(PREFIX .. ns:L("FMAC_MADE_FMT"):format(MacroName(d)))
		if ShowMacroFrame then
			pcall(ShowMacroFrame) -- open the macro window so you can drag it (AFGELEID that Forever has it)
		end
	else
		print(PREFIX .. Why(why, arg))
	end
	return ok
end

--- 17 Nov 2026, product plan step 5 (the overview's Keys tab): every row of this window, ready to draw. Each:
--- { header = true, title, info } or { title, info, made, canMake, make = fn, free = fn or nil }. Second value: true
--- when "Undo freed keys" has something to put back.
function ns.ForeverMacroViews()
	local out = {}
	for _, d in ipairs(Rows()) do
		local title, info, freeable, body, why, arg = View(d)
		if d.header then
			out[#out + 1] = { header = true, title = title, info = info }
		else
			-- 19 Nov 2026 (the macro rest, Rob: "we gaan akkoord met het voorstel van het bouwadvies"): the text (for the
			-- Copy button), the key, and why/level (for the chip Ready / Made / Level N / Trainer).
			out[#out + 1] = { title = title, info = info, made = Exists(d) ~= nil, canMake = body ~= nil,
				body = body, key = d.key, why = why, whyArg = arg,
				make = function()
					return MakeClick(d)
				end,
				free = (freeable and #freeable > 0) and function()
					FreeKeys(freeable)
				end or nil }
		end
	end
	local freed = ns.db and ns.db.foreverFreedKeys
	return out, freed ~= nil and #freed > 0
end

function ns.ForeverMacroUndoFreedKeys()
	UndoFreedKeys()
end

--------------------------------------------------------------------------------
-- "A new macro you can make" (19 Nov 2026, the macro rest). A macro becomes makeable when you learn its spell (at
-- the trainer, after a level-up). The rows that can be made are noted at login (the baseline: no message for what you
-- could already make); a row that becomes makeable later and is not made yet gets one chat line, once per session.
-- Silent when nothing is new; /mh macros says the last check (silence rule).
--------------------------------------------------------------------------------
local canBefore -- key -> true: makeable at the last check (nil until the baseline)
local newSaid = {}
local newWhy = "no check yet"

local function CheckNewMacros()
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	local now, fresh = {}, {}
	for _, d in ipairs(Rows()) do
		if not d.header and d.key then
			local title, _, _, body = View(d)
			if body then
				now[d.key] = true
				if canBefore and not canBefore[d.key] and not Exists(d) and not newSaid[d.key] then
					newSaid[d.key] = true
					fresh[#fresh + 1] = title
				end
			end
		end
	end
	local baseline = canBefore == nil
	canBefore = now
	if baseline then
		newWhy = "baseline taken (nothing is 'new' from before this login)"
		return
	end
	if #fresh > 0 then
		-- The 2nd %s = the tab's own name in this language (FOV_TAB_KEYS), so the sentence names what you see.
		print(PREFIX .. ns:L("FMAC_NEW_FMT"):format(table.concat(fresh, ", "), ns:L("FOV_TAB_KEYS")))
		newWhy = "said: " .. table.concat(fresh, ", ")
	else
		newWhy = "nothing new"
	end
end
ns.ForeverMacroNewWhy = function()
	return newWhy
end

local nev = CreateFrame("Frame")
pcall(nev.RegisterEvent, nev, "PLAYER_ENTERING_WORLD")
pcall(nev.RegisterEvent, nev, "SPELLS_CHANGED")
pcall(nev.RegisterEvent, nev, "PLAYER_LEVEL_UP")
local newTimer
nev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		nev:UnregisterEvent("PLAYER_ENTERING_WORLD")
		C_Timer.After(3, CheckNewMacros) -- the baseline
		return
	end
	if canBefore == nil then
		return -- before the baseline: the login burst of SPELLS_CHANGED
	end
	if newTimer then
		newTimer:Cancel()
	end
	newTimer = C_Timer.NewTimer(1.5, CheckNewMacros) -- SPELLS_CHANGED comes in bursts while you train
end)

Fill = function()
	local f = Build()
	f.title:SetText(ns:L("FMAC_TITLE"))
	f.sub:SetText(ns:L("FMAC_SUB"))
	f.hint:SetText(ns:L("FMAC_HINT"))
	local freed = ns.db and ns.db.foreverFreedKeys
	f.undo:SetText(ns:L("FMAC_BTN_UNDO_KEYS"))
	f.undo:SetShown(freed ~= nil and #freed > 0)
	local y = 0
	local rows = Rows()
	for i, d in ipairs(rows) do
		local r = Row(f, i)
		r.free:Hide()
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, y)
		local title, info, freeable, body = View(d)
		r.name:SetText(title)
		r.info:SetText(info)
		r.free.list = nil
		if d.header then
			r.go.def = nil
			r.go:Hide()
		else
			r.go:Show()
			if freeable and #freeable > 0 then
				r.free.list = freeable
				r.free:SetText(ns:L("FMAC_BTN_FREE"))
				r.free:Show()
			end
			r.go.def = d
			r.go:SetText(ns:L(Exists(d) and "FMAC_BTN_UPDATE" or "FMAC_BTN_MAKE"))
			if body then
				r.go:Enable()
			else
				r.go:Disable()
			end
		end
		r:Show()
		-- 17 Nov 2026 (Rob's screenshot, paladin): a long line (the Self Cast warning) ran over the next row because every
		-- row was ROW_H tall. The row now grows with its text; ROW_H stays the minimum.
		local h = ROW_H
		local okN, hn = pcall(r.name.GetStringHeight, r.name)
		local okI, hi = pcall(r.info.GetStringHeight, r.info)
		if okN and okI and type(hn) == "number" and type(hi) == "number" then
			h = math.max(ROW_H, math.ceil(2 + hn + 2 + hi + 4))
		end
		if r.free:IsShown() then
			h = math.max(h, 66) -- room for the second button under Make
		end
		r:SetHeight(h)
		y = y - h - 4
	end
	for i = #rows + 1, #f.rows do
		f.rows[i]:Hide()
	end
	f.child:SetHeight(math.max(10, -y))
	return f
end

function ns.ShowForeverMacros()
	-- 17 Nov 2026 (product plan step 5): every way into this window lands on the overview's Keys tab (fallback here).
	if ns.ShowForeverOverviewPage then
		ns.ShowForeverOverviewPage("keys", true)
		return
	end
	local f = Build()
	if f:IsShown() then
		f:Hide()
	else
		f:Show()
	end
end

--- /mh macros [check]
--[[ /mh macros keys — 17 Nov 2026 (open point "mogelijke fout", Sparring 17 nov). A macro that reads [mod:shift] on key 1
	never sees Shift from the keyboard when Shift+1 has a binding of its own: the client fires that binding instead and
	only falls back to the plain key when the modified key is free (AFGELEID, standard WoW binding behaviour - this command
	is the measurement). GEMETEN 17 nov in Rob's Forever bindings-cache.wtf: MH's own key block binds Shift+1..4, Ctrl+1..3,
	Alt+1..4 and the Shift/Alt variants of Q E R F Z X C V T. READ ONLY: GetBindingKey/GetBindingAction, nothing changes.
	Writes ns.db.foreverMacroKeysProbe so the answer can be read from SavedVariables after a /reload.
	GEMETEN in the client 17 Nov 2026 (Rob, paladin 14): "MH+ Holy Light … key 5: SHIFT-5 is taken by Action Page 5",
	and Shift+5 did not cast Flash of Light. The helpers live above the window (it shows the same check per row). ]]
local function KeysCheck()
	print(PREFIX .. "handy macros on your bars: does Shift/Ctrl/Alt reach them from the keyboard?")
	local probe = { at = time and time() or nil, rows = {} }
	local scanned, found, keyed, clashes = 0, 0, 0, 0
	for n, prefix in ipairs(KEY_BAR_PREFIXES) do
		for i = 1, 12 do
			local b = _G[prefix .. i]
			local slot = b and b.action
			if b and type(slot) ~= "number" and ActionButton_GetPagedID then
				local ok, v = pcall(ActionButton_GetPagedID, b)
				slot = ok and v or nil
			end
			if type(slot) == "number" then
				scanned = scanned + 1
				local kind = GetActionInfo and GetActionInfo(slot)
				local name = kind == "macro" and GetActionText and GetActionText(slot)
				if type(name) == "string" and name:sub(1, #MACRO_PREFIX) == MACRO_PREFIX then
					found = found + 1
					local idx = GetMacroIndexByName and GetMacroIndexByName(name) or 0
					local body = idx and idx > 0 and select(3, GetMacroInfo(idx)) or nil
					local mods = MacroMods(body)
					local command = KEY_BAR_COMMANDS[n] .. i
					local keys = GetBindingKey and { GetBindingKey(command) } or {}
					local where = ("Action Bar %d button %d"):format(n, i)
					local row = { name = name, bar = n, btn = i, command = command, keys = keys, clash = {} }
					local modList = {}
					for _, m in ipairs(KEY_MODS) do
						if mods[m] then
							modList[#modList + 1] = m
						end
					end
					row.mods = table.concat(modList, ",")
					if #modList == 0 then
						print(("  %s (%s): uses no Shift/Ctrl/Alt - nothing to check."):format(name, where))
					elseif #keys == 0 then
						print(("  %s (%s): no key on this button - with the mouse Shift/Ctrl/Alt work."):format(name, where))
					else
						keyed = keyed + 1
						for _, key in ipairs(keys) do
							local have, base = SplitKey(key)
							local parts = {}
							for _, m in ipairs(modList) do
								if not have[m] then
									local combo = {}
									for _, mm in ipairs(KEY_MODS) do
										if have[mm] or mm == m then
											combo[#combo + 1] = mm
										end
									end
									combo[#combo + 1] = base
									local comboKey = table.concat(combo, "-")
									local okA, act = pcall(GetBindingAction, comboKey, true)
									act = okA and act or nil
									if act and act ~= "" and act ~= command then
										clashes = clashes + 1
										row.clash[#row.clash + 1] = comboKey .. "=" .. act
										local label = _G["BINDING_NAME_" .. act] or act
										parts[#parts + 1] = ("|cffff8080%s is taken by %s|r"):format(KeyText(comboKey), label)
									else
										parts[#parts + 1] = ("|cff80ff80%s free|r"):format(KeyText(comboKey))
									end
								end
							end
							print(("  %s (%s), key %s: %s"):format(name, where, KeyText(key),
								#parts > 0 and table.concat(parts, ", ") or "the key already holds the modifier"))
						end
					end
					probe.rows[#probe.rows + 1] = row
				end
			end
		end
	end
	probe.scanned, probe.found, probe.keyed, probe.clashes = scanned, found, keyed, clashes
	if ns.db then
		ns.db.foreverMacroKeysProbe = probe
	end
	print(("  scanned %d bar buttons, %d handy macros on them, %d with a key and a modifier, %d taken combinations."):format(
		scanned, found, keyed, clashes))
	if clashes > 0 then
		print("  |cffffcc00A taken combination fires its own button, not this macro's Shift/Ctrl/Alt part.|r Nothing was changed.")
		print("  " .. ns:L("FMAC_KEY_CHAT_HINT"))
	end
end

function ns.ForeverMacrosSlash(arg)
	arg = (arg or ""):lower()
	if arg == "keys" then
		KeysCheck()
		return
	end
	if arg == "keys undo" then
		UndoFreedKeys()
		return
	end
	if arg ~= "check" then
		ns.ShowForeverMacros()
		return
	end
	print(PREFIX .. "handy macros: what each row would write now")
	print("  new-macro notice: " .. newWhy)
	local _, token = UnitClass("player")
	local nClass = 0
	for _, c in ipairs(CLASS_MACROS) do
		if c.class == token then
			nClass = nClass + 1
		end
	end
	print(("  class %s: %d class macros in the data (talent ones hidden until known)"):format(tostring(token), nClass))
	local band, pts, why = SpecBand()
	print(("  spec: %s (points per tree %s)%s"):format(band and (tostring(band) .. " = " .. tostring(SpecName(token, band)))
		or "none", pts and table.concat(pts, "/") or "?", why and ("  [" .. why .. "]") or ""))
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
-- New talent or spell → the class/spec rows change. pcall: an unknown event name throws (CLAUDE.md, 8 Aug 2026).
pcall(ev.RegisterEvent, ev, "SPELLS_CHANGED")
pcall(ev.RegisterEvent, ev, "TRAIT_CONFIG_UPDATED")
ev:SetScript("OnEvent", function()
	RefreshAuto()
	if win and win:IsShown() then
		Fill()
	end
	if ns.ForeverOverviewRefreshPage then
		ns.ForeverOverviewRefreshPage("keys") -- the overview's Keys tab shows the same rows (product plan step 5)
	end
end)
