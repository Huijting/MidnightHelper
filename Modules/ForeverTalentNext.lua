local _, ns = ...

--[[
	ForeverTalentNext.lua — WoW Forever: "Talent point: put it in <Talent> (n/max)" in Do this now.

	Rob, 21 Nov 2026 (via sparring): How you play is "weer heel veel tekst", and he did not see "waar ik mijn punten ... in
	zou moeten stoppen ... Wil ik snel levelen, maar ook wel tanken." On the proposal "'Do this now' zegt bij elk nieuw level
	welk talent je nu moet kiezen ... Dan hoef je die hele lijst nooit te lezen", literally: "Ja, doe dat maar".

	How it decides (no guessing per level):
	  1. Only when you have an unused class talent point: C_Traits.GetTreeCurrencyInfo(config, tree) — the same call MH
	     uses for Legacy Points (ForeverLegacy.lua). nil = not readable → silent, and /mh talent says so.
	  2. The order = your direction (ForeverDirection.lua, the tree you chose); no direction = the class's levelling tree
	     (DEFAULT below), and the line says that.
	  3. MH reads every node of that order in the real tree (C_Traits.GetNodeInfo → ranksPurchased) and names the FIRST
	     step that is not done yet. So a point you put elsewhere does not confuse it; it only skips what you already have.
	Orders: ORDERS below, one public source each (named per order). Node ids GEMETEN in DB2 (see the table comments).
	Reading C_Traits in the game for this = AFGELEID until Rob's /mh talent shows it (the trees were measured for the
	"Which way?" question through the same calls, ForeverMacros.lua SpecBand).
	Switch: Quiet helpers (on by default). Diagnosis: /mh talent.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- Trait tree per class (same as ForeverMacros.lua TREE, GEMETEN in DB2 TraitTree).
local TREE = { WARRIOR = 1117, PALADIN = 1100, HUNTER = 1091, ROGUE = 1111, PRIEST = 1114, SHAMAN = 1082, MAGE = 1112,
	WARLOCK = 1116, DRUID = 1089 }
-- Class talent point currency (GEMETEN 17 Nov 2026, TraitCurrencySource → currency 3820, ForeverMacros.lua Talented note).
local TALENT_CURRENCY = 3820

-- The tree a class levels with when no direction is chosen (band numbers as ForeverDirection / the role texts).
local DEFAULT = { PALADIN = 3 }

--[[ ORDERS[class][band] = { source = "...", steps = { { node = id, spell = id, name = "English", to = ranks }, ... } }
	`to` = the rank this step brings the talent to (a talent of 5 ranks in one go = one step with to = 5). ]]
-- Node and spell ids GEMETEN 21 Nov 2026 (mh-research, wago DB2 Forever 1.60.1.71037: SpellName → TraitDefinition →
-- TraitNodeEntry → TraitNodeXTraitNodeEntry → TraitNode in tree 1100; MaxRanks match every step; the bouwchat re-checked
-- 3 entries → nodes: 130436→105707, 137873→110875, 130352→105628). The order itself = the named guide (AFGELEID).
local function S(node, spell, name, to)
	return { node = node, spell = spell, name = name, to = to }
end
local ORDERS = {
	PALADIN = {
		-- Retribution (band 3): guided.news "WoW Forever: Dein Vergelter-Paladin Easy Leveln von 1 bis 60", Sascha
		-- Asendorf, 21 Nov 2026 (12 Holy / 8 Protection / 31 Retribution at 60).
		[3] = { source = "guided.news, Retribution levelling guide (21 Nov 2026)", steps = {
			S(105707, 20060, "Deflection", 5),
			S(105703, 20117, "Conviction", 3),
			S(105705, 25956, "Improved Judgement", 2),
			S(105699, 26022, "Pursuit of Justice", 2),
			S(105696, 20375, "Seal of Command", 1),
			S(105701, 1311074, "Sanctified Judgement", 2),
			S(105697, 20111, "Two-Handed Weapon Specialization", 3),
			S(105700, 1311087, "Sacred Arbiter", 1),
			S(105701, 1311074, "Sanctified Judgement", 3),
			S(105693, 20049, "Vengeance", 3),
			S(105694, 20066, "Repentance", 1),
			S(105706, 20101, "Benediction", 1),
			S(110882, 1311084, "Champion of the Light", 5),
			S(105692, 1310735, "Unsealed Wrath", 1),
			S(113630, 20262, "Divine Strength", 5),
			S(110871, 1310899, "Reverence", 2),
			S(105334, 20224, "Improved Seals", 5),
			S(105332, 20257, "Divine Intellect", 5),
			S(105638, 20189, "Precision", 3),
		} },
		-- Protection (band 2): stillsixty.com "Protection Paladin Guide", updated 17 Nov 2026 (0 / 42 / 9 at 60). Steps 1-14
		-- reach Shieldsworn at 40 (its gate: 30 points in the Protection tab, TraitCond 50987, GEMETEN); the rest is the
		-- guide's table after 40.
		[2] = { source = "stillsixty.com, Protection Paladin guide (17 Nov 2026)", steps = {
			S(105626, 20127, "Redoubt", 5),
			S(105638, 20189, "Precision", 3),
			S(105632, 1224697, "Sacred Duty", 2),
			S(105625, 1311015, "Templar's Bulwark", 1),
			S(110874, 20150, "Shield Specialization", 2),
			S(105630, 20143, "Toughness", 2),
			S(105634, 20468, "Improved Righteous Fury", 3),
			S(110878, 1310994, "Swift Judgement", 1),
			S(105630, 20143, "Toughness", 3),
			S(105628, 20925, "Holy Shield", 1),
			S(105627, 20177, "Reckoning", 5),
			S(110879, 1311034, "Iron Creed", 3),
			S(105630, 20143, "Toughness", 4),
			S(110875, 1328544, "Shieldsworn", 1),
			S(105630, 20143, "Toughness", 5),
			S(105636, 20096, "Anticipation", 5),
			S(105332, 20257, "Divine Intellect", 5),
			S(105706, 20101, "Benediction", 5),
			S(105705, 25956, "Improved Judgement", 2),
			S(105703, 20117, "Conviction", 2),
		} },
	},
}
ns.FOREVER_TALENT_ORDERS = ORDERS -- the offline check reads it

function ns.IsForeverTalentNextOn()
	return not (type(ns.db) == "table" and ns.db.foreverTalentNext == false)
end

function ns.SetForeverTalentNext(on)
	if type(ns.db) ~= "table" then
		return
	end
	-- plain branches (lint [29])
	if on then
		ns.db.foreverTalentNext = nil
	else
		ns.db.foreverTalentNext = false
	end
end

local function num(v)
	if type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
		return v
	end
	return nil
end

--- The config for this class's tree, or nil + why.
local function Config(tree)
	if not (C_Traits and C_Traits.GetNodeInfo) then
		return nil, "no C_Traits"
	end
	local cfg
	if C_ClassTalents and C_ClassTalents.GetActiveConfigID then
		local ok, v = pcall(C_ClassTalents.GetActiveConfigID)
		if ok and num(v) then
			cfg = v
		end
	end
	if cfg and C_Traits.GetConfigInfo then
		local ok, info = pcall(C_Traits.GetConfigInfo, cfg)
		local has = false
		for _, t in ipairs(ok and type(info) == "table" and info.treeIDs or {}) do
			if t == tree then
				has = true
			end
		end
		if not has then
			cfg = nil
		end
	end
	if not cfg and C_Traits.GetConfigIDByTreeID then
		local ok, v = pcall(C_Traits.GetConfigIDByTreeID, tree)
		if ok and num(v) and v > 0 then
			cfg = v
		end
	end
	if not cfg then
		return nil, "no talent config"
	end
	return cfg
end

--- Unused class talent points, or nil + why.
local function FreePoints(cfg, tree)
	if not C_Traits.GetTreeCurrencyInfo then
		return nil, "no GetTreeCurrencyInfo"
	end
	local ok, list = pcall(C_Traits.GetTreeCurrencyInfo, cfg, tree, false)
	if not (ok and type(list) == "table") then
		return nil, ok and "no currency info" or ("error: " .. tostring(list))
	end
	local pick
	for _, c in ipairs(list) do
		if type(c) == "table" and c.traitCurrencyID == TALENT_CURRENCY then
			pick = c
		end
	end
	pick = pick or list[1]
	if type(pick) ~= "table" or num(pick.quantity) == nil then
		return nil, "currency quantity not readable"
	end
	return pick.quantity, nil, pick.traitCurrencyID
end

local function Ranks(cfg, node)
	local ok, info = pcall(C_Traits.GetNodeInfo, cfg, node)
	if not (ok and type(info) == "table") then
		return nil, nil
	end
	return num(info.ranksPurchased) or num(info.currentRank), num(info.maxRanks)
end

local function SpellName(id, fallback)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return fallback
end

--- The order for this character: order, band, where the band came from.
local function Order()
	local _, cls = UnitClass("player")
	local band, src
	if ns.GetForeverDirection then
		band = ns.GetForeverDirection()
		src = band and "your direction"
	end
	if not band then
		band, src = DEFAULT[cls], "no direction chosen: the class's levelling tree"
	end
	local byClass = ORDERS[cls]
	return byClass and band and byClass[band], band, src, cls
end

--- The decision: { free, step, cur, max, name, order, band, src, why }.
function ns.ForeverTalentNextState()
	local st = {}
	if not ns.IsForeverTalentNextOn() then
		st.why = "switched off (Quiet helpers)"
		return st
	end
	local order, band, src, cls = Order()
	st.band, st.src, st.class = band, src, cls
	if not order then
		st.why = "no talent order for this class and tree yet"
		return st
	end
	st.order = order
	local tree = TREE[cls]
	local cfg, whyC = Config(tree)
	if not cfg then
		st.why = whyC
		return st
	end
	st.config = cfg
	local free, whyF, cur = FreePoints(cfg, tree)
	st.free, st.currency = free, cur
	if free == nil then
		st.why = "unused points not readable (" .. tostring(whyF) .. ") — silent on purpose"
		return st
	end
	if free < 1 then
		st.why = "no unused talent point"
		return st
	end
	for i, s in ipairs(order.steps) do
		local have, max = Ranks(cfg, s.node)
		if have == nil then
			st.why = ("node %d (%s) not readable"):format(s.node, s.name)
			return st
		end
		if have < s.to then
			st.step, st.index, st.cur, st.max = s, i, have, max or s.to
			st.name = SpellName(s.spell, s.name)
			st.why = ("step %d of %d: %s has %d, the order wants %d"):format(i, #order.steps, s.name, have, s.to)
			return st
		end
	end
	st.why = "every step of the order is done"
	return st
end

--- The Do this now line, or nil. Second value: the spell id (for the tooltip).
function ns.ForeverTalentNextLine()
	if InCombatLockdown and InCombatLockdown() then
		return nil
	end
	local ok, st = pcall(ns.ForeverTalentNextState)
	if not (ok and type(st) == "table" and st.step) then
		return nil
	end
	local link = st.name
	if ns.ForeverSpellLinkText then
		local okL, l = pcall(ns.ForeverSpellLinkText, st.step.spell, st.name)
		if okL and type(l) == "string" then
			link = l
		end
	end
	local s
	if st.free > 1 then
		s = ns:L("FTALENT_NEXT_MANY_FMT"):format(st.free, link, st.cur + 1, st.max)
	else
		s = ns:L("FTALENT_NEXT_FMT"):format(link, st.cur + 1, st.max)
	end
	if st.src ~= "your direction" then
		s = s .. " " .. ns:L("FTALENT_NO_DIR")
	end
	return s, st.step.spell
end

--- Open the game's talent window (AFGELEID: the names exist in this client family; pcall'd).
function ns.ForeverOpenTalents()
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	for _, fn in ipairs({
		function() return PlayerSpellsUtil and PlayerSpellsUtil.ToggleClassTalentFrame and PlayerSpellsUtil.ToggleClassTalentFrame() end,
		function() return ToggleTalentFrame and ToggleTalentFrame() end,
	}) do
		local ok = pcall(fn)
		if ok and ((PlayerSpellsUtil and PlayerSpellsUtil.ToggleClassTalentFrame) or ToggleTalentFrame) then
			return
		end
	end
end

--- /mh talent: what MH reads, which order, and why this talent (or why nothing).
function ns.ForeverTalentSlash()
	local st = ns.ForeverTalentNextState()
	print(PREFIX .. "next talent: " .. (ns.IsForeverTalentNextOn() and "on" or "off") .. " (Quiet helpers).")
	print(("  class %s, tree band %s (%s), order: %s"):format(tostring(st.class), tostring(st.band), tostring(st.src),
		st.order and (st.order.source .. ", " .. #st.order.steps .. " steps") or "none"))
	print(("  talent config %s, unused points %s (currency %s)"):format(tostring(st.config), tostring(st.free),
		tostring(st.currency)))
	if st.order and st.config then
		for i, s in ipairs(st.order.steps) do
			local have, max = Ranks(st.config, s.node)
			if i <= 40 then
				print(("    %2d. %s %s/%s (want %d)%s"):format(i, s.name, tostring(have), tostring(max), s.to,
					st.index == i and "  <- next" or ""))
			end
		end
	end
	print("  decision: " .. (st.step and ("put it in " .. tostring(st.name)) or "nothing to say") .. " — " .. tostring(st.why))
	local line = ns.ForeverTalentNextLine()
	print("  line in Do this now: " .. (line or "none"))
	if type(ns.db) == "table" then
		ns.db.foreverTalentProbe = { free = st.free, config = st.config, band = st.band, why = st.why,
			index = st.index, at = time and time() or nil }
	end
end
