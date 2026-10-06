local _, ns = ...

--[[
	Midnight Helper — the fixed key block (4 Oct 2026, Rob's idea; plan in docs/KEYBLOCK_PLAN.md).

	One block of 36 places, three bars of 3 x 4. Every place has the same TASK and the same KEY for
	every class and spec, so muscle memory carries over between characters: 1 is always your main
	button, E always your interrupt, Z always the small defensive.

	THIS FILE ONLY DRAWS THE PICTURE (`/mh block`). Nothing here touches a bar or a binding. Placing
	it for you ("zet neer") is step two, after Rob's Edit Mode import test (KEYBLOCK_PLAN, Techniek).

	The rules are the ones the dry run of 4 Oct measured as variant C (fcdcd4fe scratchpad
	`keyblock/sim2.lua`: 39 of 40 specs fit everything but utility), plus the bar C keys Rob chose on
	4 Oct ("ik ga helemaal op jouw expertise af"): Shift is the second of the same kind.

	The spells come from KeybindAutoMap's own classification of the LIVE spellbook (8th return of
	ns.MH_AutoMapBuild), so the block shows what this character has, under the name it has now.
]]

-- WoW binding notation, so step two can hand these straight to SetBinding.
local BLOCK = {
	-- Block D (5 Oct 2026, Rob: "extra blok D, aan, links van A, vaste toetsen bedenken"): the player's OWN
	-- place on action bar 4 — toys, hearthstone, macros, whatever the block pushed aside. MH binds the keys
	-- and never fills or clears it. Alt + the same pattern as A, except Alt-Z: Blizzard's default for
	-- hiding the whole interface, so the last place is Alt-G.
	{ id = "D", own = true, slots = {
		{ key = "ALT-1", task = "KEYBLOCK_T_OWN" }, { key = "ALT-2", task = "KEYBLOCK_T_OWN" },
		{ key = "ALT-3", task = "KEYBLOCK_T_OWN" }, { key = "ALT-4", task = "KEYBLOCK_T_OWN" },
		{ key = "ALT-Q", task = "KEYBLOCK_T_OWN" }, { key = "ALT-E", task = "KEYBLOCK_T_OWN" },
		{ key = "ALT-R", task = "KEYBLOCK_T_OWN" }, { key = "ALT-F", task = "KEYBLOCK_T_OWN" },
		{ key = "ALT-X", task = "KEYBLOCK_T_OWN" }, { key = "ALT-C", task = "KEYBLOCK_T_OWN" },
		{ key = "ALT-V", task = "KEYBLOCK_T_OWN" }, { key = "ALT-G", task = "KEYBLOCK_T_OWN" },
	} },
	{ id = "A", slots = {
		{ key = "1", task = "KEYBLOCK_T_MAIN" }, { key = "2", task = "KEYBLOCK_T_ROT" },
		{ key = "3", task = "KEYBLOCK_T_ROT" }, { key = "4", task = "KEYBLOCK_T_SPENDER" },
		{ key = "SHIFT-1", task = "KEYBLOCK_T_AOE" }, { key = "SHIFT-2", task = "KEYBLOCK_T_AOE" },
		{ key = "SHIFT-3", task = "KEYBLOCK_T_CD3" }, { key = "F1", task = "KEYBLOCK_T_CD2" },
		{ key = "Z", task = "KEYBLOCK_T_DEF_SMALL" }, { key = "X", task = "KEYBLOCK_T_DEF2" },
		{ key = "C", task = "KEYBLOCK_T_DEF_BIG" }, { key = "V", task = "KEYBLOCK_T_CC" },
	} },
	{ id = "B", slots = {
		{ key = "5", task = "KEYBLOCK_T_ROT" }, { key = "Q", task = "KEYBLOCK_T_BIGCD" },
		{ key = "E", task = "KEYBLOCK_T_KICK" }, { key = "R", task = "KEYBLOCK_T_MOVE" },
		{ key = "F", task = "KEYBLOCK_T_TAUNT" }, { key = "T", task = "KEYBLOCK_T_POTION", fixed = "potion" },
		{ key = "F2", task = "KEYBLOCK_T_QHEAL" }, { key = "F4", task = "KEYBLOCK_T_RECUP" },
		{ key = "SHIFT-Q", task = "KEYBLOCK_T_CC" }, { key = "SHIFT-F", task = "KEYBLOCK_T_CC" },
		{ key = "SHIFT-R", task = "KEYBLOCK_T_MOVE2" }, { key = "SHIFT-T", task = "KEYBLOCK_T_STONE", fixed = "healthstone" },
	} },
	{ id = "C", slots = {
		{ key = "G", task = "KEYBLOCK_T_TRINKET", fixed = "trinket" }, { key = "CTRL-1", task = "KEYBLOCK_T_FORM1" },
		{ key = "CTRL-2", task = "KEYBLOCK_T_FORM2" }, { key = "CTRL-3", task = "KEYBLOCK_T_FORM3" },
		{ key = "F3", task = "KEYBLOCK_T_CD4" }, { key = "SHIFT-E", task = "KEYBLOCK_T_RACIAL" },
		{ key = "SHIFT-4", task = "KEYBLOCK_T_AOESPEND" }, { key = "SHIFT-F1", task = "KEYBLOCK_T_CD2B" },
		{ key = "SHIFT-Z", task = "KEYBLOCK_T_DEF_SMALL2" }, { key = "SHIFT-X", task = "KEYBLOCK_T_DEF2B" },
		{ key = "SHIFT-C", task = "KEYBLOCK_T_DEF_BIG2" }, { key = "SHIFT-V", task = "KEYBLOCK_T_CC" },
	} },
}
ns.KEYBLOCK_LAYOUT = BLOCK

--- Which action bar each block bar goes on. Default 5, 6, 7 (4 Oct 2026, Rob: "geen idee welke
--- balknummers, kies maar"): bar 1 pages with forms and stealth, 2-4 are where most players already
--- keep their own spells, and 8 holds Rob's mouse keys (MULTIACTIONBAR7). Shown on the picture only;
--- nothing is placed yet.
local DEFAULT_BARS = { A = 5, B = 6, C = 7, D = 4 }

function ns.KeyBlockBars()
	local saved = ns.db and ns.db.keyBlock and ns.db.keyBlock.bars
	return {
		A = (saved and saved.A) or DEFAULT_BARS.A,
		B = (saved and saved.B) or DEFAULT_BARS.B,
		C = (saved and saved.C) or DEFAULT_BARS.C,
		D = (saved and saved.D) or DEFAULT_BARS.D,
	}
end

-- Where each kind of spell may go, first free place wins. Ported from sim2.lua variant C.
local ANCHOR = {
	interrupt = { "E" },
	cooldown_bar = { "Q", "F1", "SHIFT-3", "F3", "SHIFT-F1" },
	defensive_1 = { "Z", "X", "C", "SHIFT-Z", "SHIFT-X", "SHIFT-C" },
	defensive_2 = { "X", "Z", "C", "SHIFT-X", "SHIFT-Z", "SHIFT-C" },
	defensive_3 = { "C", "Z", "X", "SHIFT-C", "SHIFT-Z", "SHIFT-X" },
	defensive_4 = { "C", "Z", "X", "SHIFT-C", "SHIFT-Z", "SHIFT-X" },
	heal_quick = { "F2" },
	heal_sustain = { "F4", "F2" },
	heal_ooc = { "F2", "F3" },
	mobility = { "R", "SHIFT-R" },
	utility_primary = { "R", "SHIFT-R" },
	utility_secondary = { "F", "SHIFT-R" },
}
local ANCHOR_ORDER = { "interrupt", "taunt", "cooldown_bar", "defensive_1", "defensive_2", "defensive_3",
	"defensive_4", "heal_quick", "heal_sustain", "heal_ooc", "mobility", "utility_primary", "utility_secondary" }

local CATEGORY = {
	main_rotation = { "1", "2", "3", "5", "SHIFT-1", "SHIFT-2" },
	raid_heal = { "1", "2", "3", "5", "SHIFT-1", "SHIFT-2" },
	spender = { "4", "5", "SHIFT-4" },
	defensive = { "Z", "X", "C", "SHIFT-Z", "SHIFT-X", "SHIFT-C" },
	cooldown = { "Q", "F1", "SHIFT-3", "F3", "SHIFT-F1" },
	dispel_cc = { "V", "SHIFT-Q", "SHIFT-F", "SHIFT-V" },
	utility = { "F", "SHIFT-R" },
	racial = { "SHIFT-E" },
	taunt = { "F" },
}
local CATEGORY_ORDER = { "main_rotation", "spender", "raid_heal", "defensive", "cooldown", "dispel_cc", "racial", "utility" }

local AOE_KEYS = { "SHIFT-1", "SHIFT-2", "SHIFT-4" }
local AOE_CATS = { main_rotation = true, spender = true, raid_heal = true }

-- What did not fit goes to bar C in this order (sim2.lua FAMILY_ORDER).
local FAMILY_ORDER = { rotation = 1, interrupt = 2, defensive = 3, heal = 4, cooldown = 5, taunt = 6,
	cc = 7, movement = 8, utility = 9, other = 10 }
local OVERFLOW = { "CTRL-1", "CTRL-2", "CTRL-3", "SHIFT-V", "SHIFT-C", "SHIFT-X", "SHIFT-Z", "SHIFT-F1",
	"SHIFT-4", "F3", "SHIFT-E" }

local function Family(s)
	if s.role == "interrupt" then return "interrupt" end
	if s.category == "taunt" then return "taunt" end
	if s.role == "cooldown_bar" or s.category == "cooldown" then return "cooldown" end
	if (s.role and s.role:find("^defensive")) or s.category == "defensive" then return "defensive" end
	if s.role == "heal_quick" or s.role == "heal_sustain" or s.role == "heal_ooc" then return "heal" end
	if s.role == "mobility" or s.role == "utility_primary" then return "movement" end
	if s.role == "utility_secondary" or s.category == "utility" then return "utility" end
	if s.category == "dispel_cc" then return "cc" end
	if AOE_CATS[s.category or ""] then return "rotation" end
	return "other"
end

--- "Shift+4" -> "SHIFT-4", the binding notation BLOCK uses.
local function BlockKey(bindKey)
	if type(bindKey) ~= "string" then
		return nil
	end
	local mod, base = bindKey:match("^(%a+)[%+%-](.+)$")
	if mod then
		return mod:upper() .. "-" .. base:upper()
	end
	return bindKey:upper()
end

local function IsBlockQ(s, specID)
	local q = s.blockQ
	if type(q) == "table" then
		return specID and q[specID] and true or false
	end
	return q == true
end

local function ByPriority(a, b)
	local pa, pb = tonumber(a.priority) or 99, tonumber(b.priority) or 99
	if pa ~= pb then
		return pa < pb
	end
	return (a.id or 0) < (b.id or 0)
end

--- Lay the classified spells over the block.
--- @return table occ   [blockKey] = { spell = s, why = "..." } for every filled spell place
--- @return table left  spells with no place, in family order
--- @return table trace one line per decision, for /mh block why
function ns.KeyBlockAllocate(spells, specID)
	local occ, trace, fixed = {}, {}, {}
	for _, bar in ipairs(BLOCK) do
		for _, slot in ipairs(bar.slots) do
			if slot.fixed then
				fixed[slot.key] = true
			end
		end
	end
	local function free(k)
		return not occ[k] and not fixed[k]
	end
	local function try(s, keys, why)
		for _, k in ipairs(keys) do
			if free(k) then
				occ[k] = { spell = s, why = why }
				s._done = true
				trace[#trace + 1] = { key = k, id = s.id, why = why }
				return true
			end
		end
		return false
	end

	local left = {}
	local list = {}
	-- blockAs[spec].onlyD (5 Oct 2026, Rob's Resto Druid): useful but off-role on this spec (Heart of the Wild,
	-- Stampeding Roar). It never competes for A/B/C; it goes straight to the "no place" list, which Place puts
	-- on a free Alt key of block D.
	local onlyD = {}
	for _, s in ipairs(spells or {}) do
		-- blockAs (healer round, 5 Oct 2026): one classifier entry that means something else on THIS spec's
		-- block (Word of Glory: Holy's spender on 4, Prot's self-heal on F2). Only the block reads it; the
		-- v7 allocator keeps the entry's own role. A copy, so the caller's table is never changed.
		local as = type(s.blockAs) == "table" and specID and s.blockAs[specID]
		if type(as) == "table" and as.onlyD then
			onlyD[#onlyD + 1] = { id = s.id, name = s.name, role = s.role, category = s.category, priority = s.priority }
		else
			if type(as) == "table" then
				s = { id = s.id, name = s.name, role = as.role, category = as.category,
					priority = as.priority or s.priority, bindKey = as.bindKey, blockForm = s.blockForm, blockQ = s.blockQ }
			end
			list[#list + 1] = s
			s._done = nil
		end
	end
	table.sort(list, ByPriority)

	-- 1. Druid forms: their own three places, Ctrl-1/2/3 (KeybindRoles_Druid.lua blockForm).
	for _, s in ipairs(list) do
		if type(s.blockForm) == "number" and not s._done then
			if not try(s, { "CTRL-" .. s.blockForm }, "form " .. s.blockForm) then
				left[#left + 1] = s
				s._done = true
			end
		end
	end
	-- 2. Q: the big cooldown this spec names (blockQ), before any other cooldown can take it.
	for _, s in ipairs(list) do
		if not s._done and IsBlockQ(s, specID) then
			try(s, { "Q" }, "big cooldown (blockQ)")
		end
	end
	-- 3. Fixed roles, in the order sim2 measured.
	for _, kind in ipairs(ANCHOR_ORDER) do
		for _, s in ipairs(list) do
			local hit = (kind == "taunt") and (s.category == "taunt") or (s.role == kind)
			if hit and not s._done then
				local keys = (kind == "taunt") and CATEGORY.taunt or ANCHOR[kind]
				if not try(s, keys, "role " .. kind) then
					left[#left + 1] = s
					s._done = true
				end
			end
		end
	end
	-- 4. A spell that asks for an AoE Shift key gets it, else another AoE key.
	for _, s in ipairs(list) do
		if not s._done and AOE_CATS[s.category or ""] then
			local want = BlockKey(s.bindKey)
			local isAoe = false
			for _, k in ipairs(AOE_KEYS) do
				if k == want then
					isAoe = true
				end
			end
			if isAoe then
				local keys = { want }
				for _, k in ipairs(AOE_KEYS) do
					if k ~= want then
						keys[#keys + 1] = k
					end
				end
				if not try(s, keys, "AoE twin (" .. tostring(s.bindKey) .. ")") then
					left[#left + 1] = s
					s._done = true
				end
			end
		end
	end
	-- 5. Any other key the data asks for, if it exists in the block and is free (Shift-C, Shift-V,
	-- Shift-F1 ...). A wish for a key outside the block (Ctrl-Q) simply falls through to step 6.
	for _, s in ipairs(list) do
		if not s._done and s.bindKey and not s.blockForm then
			local want = BlockKey(s.bindKey)
			if want and free(want) then
				try(s, { want }, "asked for " .. tostring(s.bindKey))
			end
		end
	end
	-- 6. Categories.
	for _, cat in ipairs(CATEGORY_ORDER) do
		for _, s in ipairs(list) do
			if not s._done and s.category == cat then
				if not try(s, CATEGORY[cat], "category " .. cat) then
					left[#left + 1] = s
					s._done = true
				end
			end
		end
	end
	for _, s in ipairs(list) do
		if not s._done then
			left[#left + 1] = s
			s._done = true
		end
	end
	-- 7. Overflow onto the free places of bar C, most-needed family first.
	table.sort(left, function(a, b)
		local fa, fb = FAMILY_ORDER[Family(a)] or 99, FAMILY_ORDER[Family(b)] or 99
		if fa ~= fb then
			return fa < fb
		end
		return ByPriority(a, b)
	end)
	-- A class with forms keeps Ctrl-1/2/3 for its forms, also the one it does not know. Rob, 5 Oct
	-- 2026, Guardian without Moonkin Form: Ctrl 3 got Remove Corruption, so "Ctrl 3 = form 3" stopped
	-- being true. An empty form key is better than a key that means something else on this druid.
	local overflow = OVERFLOW
	local hasForms = false
	for _, s in ipairs(list) do
		if type(s.blockForm) == "number" then
			hasForms = true
		end
	end
	if hasForms then
		overflow = {}
		for _, k in ipairs(OVERFLOW) do
			if not k:find("^CTRL%-") then
				overflow[#overflow + 1] = k
			end
		end
	end
	local unplaced = {}
	for _, s in ipairs(left) do
		if not try(s, overflow, "overflow (" .. Family(s) .. ")") then
			unplaced[#unplaced + 1] = s
			trace[#trace + 1] = { id = s.id, why = "no room (" .. Family(s) .. ")" }
		end
	end
	for _, s in ipairs(onlyD) do
		unplaced[#unplaced + 1] = s
		trace[#trace + 1] = { id = s.id, why = "block D only on this spec (blockAs onlyD)" }
	end
	return occ, unplaced, trace
end

--- Name + icon as the player sees them now (follow a talent's replacement, as NameForId does).
local function SpellView(id)
	if not id then
		return "?", nil
	end
	local show = id
	if C_SpellBook and C_SpellBook.FindSpellOverrideByID then
		local ok, over = pcall(C_SpellBook.FindSpellOverrideByID, id)
		if ok and type(over) == "number" and over ~= 0 then
			show = over
		end
	end
	local name, icon
	if C_Spell and C_Spell.GetSpellInfo then
		local ok, info = pcall(C_Spell.GetSpellInfo, show)
		if ok and type(info) == "table" then
			name, icon = info.name, info.iconID
		end
		if not name and show ~= id then
			ok, info = pcall(C_Spell.GetSpellInfo, id)
			if ok and type(info) == "table" then
				name, icon = info.name, info.iconID
			end
		end
	end
	return name or tostring(id), icon, show
end

--- Readable key: "SHIFT-1" -> "Shift 1".
local function KeyLabel(k)
	local mod, base = k:match("^(%u+)%-(.+)$")
	if mod then
		return (mod == "SHIFT" and "Shift" or mod == "CTRL" and "Ctrl" or mod == "ALT" and "Alt" or mod) .. " " .. base
	end
	return k
end
ns.KeyBlockKeyLabel = KeyLabel

local function Build()
	if not ns.MH_AutoMapBuild then
		return nil
	end
	local ok, _map, _m, _u, class, _cc, _up, _ids, spells, specID = pcall(ns.MH_AutoMapBuild)
	if not ok or type(spells) ~= "table" or #spells == 0 then
		return nil, class
	end
	local occ, unplaced, trace = ns.KeyBlockAllocate(spells, specID)
	-- Spells this character knows that are in none of our lists also get a key: a free Alt place on block D
	-- (Rob, 5 Oct 2026, after testing three Druid specs: "moeten we dit voor elke spec gaan doen?" — no: what MH
	-- does not know goes to D by itself, and never pushes anything off A/B/C). Noise and the spells left keyless
	-- on purpose are filtered out by KeybindUnclassified first.
	local unknown = 0
	if ns.KeybindUnclassified then
		local okU, names, _, ids = pcall(ns.KeybindUnclassified)
		if okU and type(names) == "table" and type(ids) == "table" then
			for i, n in ipairs(names) do
				if ids[i] then
					unplaced[#unplaced + 1] = { id = ids[i], name = n, unknown = true }
					unknown = unknown + 1
				end
			end
		end
	end
	-- Flyouts whose spells MH does not classify (Mage Portals, Teleports): the flyout itself goes on a free Alt key of
	-- block D, not its spells one by one (Rob, 6 Oct 2026). A flyout with a classified member (Hunter Mend Pet in Pet
	-- Utility) is left alone: those spells get their own keys.
	local classified = {}
	for _, s in ipairs(spells) do
		if s.name then
			classified[s.name] = true
		end
	end
	for _, fly in ipairs(ns._mhFlyouts or {}) do
		local own = false
		local noKey = ns.KeybindNoKeyOnPurpose or {}
		for name in pairs(fly.members or {}) do
			if classified[name] or noKey[name] then
				own = true
			end
		end
		if not own and fly.flyoutID and fly.index then
			unplaced[#unplaced + 1] = { kind = "flyout", id = fly.flyoutID, book = fly.index, name = fly.name,
				members = fly.members }
		end
	end
	return { occ = occ, unplaced = unplaced, trace = trace, specID = specID, class = class, unknown = unknown }
end

--------------------------------------------------------------------------------
-- Step 2: put it on the bars (5 Oct 2026, Rob: "A1 B1 C1")
--
-- A1: extra spells keep filling free places of bar C (what the picture shows is what gets placed).
-- B1: what stands on action bars 5/6/7 may be overwritten; a dry run says what first, and undo puts
--     every slot and every key back exactly.
-- C1: MH places the trinket you wear, and a healing potion / Healthstone from your bags.
--
-- Built on what /mh apply proved on Rob's characters (ApplyLayout.lua): PickupSpell/PlaceAction for
-- spells, PickupItem for items, a per-key binding snapshot, and NEVER a macro slot — on 7 Aug 2026 a
-- macro could not be restored by its id and was lost. A slot holding anything but a spell or an item
-- is refused and reported, never overwritten.
--------------------------------------------------------------------------------

-- Rob, 5 Oct 2026: "Blok C is absoluut anders dan wat wij voorgesteld hebben … die macro's moeten dan
-- maar ergens anders komen." So a macro is no longer refused: whatever a block place holds is first MOVED
-- to a free button on another bar (PickupAction + PlaceAction, a plain drag, so a macro travels as itself
-- and its id never needs looking up), and the undo swaps it straight back. The 7 Aug loss was a macro put
-- back BY ID after its index had shifted; the swap never uses the id. Taking a macro off a bar does not
-- delete it from the macro list either.
local RESTORABLE = { spell = true, item = true, macro = true }
--- 🔴 5 Oct 2026, Carola's Balance Druid: her bar 7 was full of MOUNTS. A mount is not RESTORABLE (Undo
--- cannot re-create it by id), so every block C place holding one was refused and kept the mount: Revive,
--- Prowl, Dash, Starfall, Ursol's Vortex and Remove Corruption never landed, while the picture showed them.
--- Moving aside is a plain drag (PickupAction + PlaceAction) and works for any action -- mount, pet, toy,
--- flyout, equipment set -- and Undo swaps it back the same way. So anything moves when it gets a free
--- button; only the by-id fallback in Undo (the moved thing is no longer where we put it) needs RESTORABLE.
local function Movable(kind)
	return kind ~= nil
end
local AUTOPUSH_CVAR = "AutoPushSpellToActionBar"
-- Bars that may receive what the block pushes aside, in this order. Never bar 1 (it pages with forms and
-- stealth), never bar 8 (Rob's mouse keys), never a block bar.
local MOVE_BARS = { 4, 2, 3 } -- bar 4 is block D (own stuff) since 5 Oct 2026, so it fills first
local HEALTHSTONE_ITEM = 5512 -- "Healthstone" (Wowhead item 5512, per language read 4 Oct 2026)

--- Bar number (1-8) -> binding prefix and first action slot (shared table from ApplyLayout.lua).
local function BarInfo(n)
	local t = ns.KEYBIND_BAR_COMMANDS
	return t and t[n] or nil
end

local function Occupant(slot)
	local ok, kind, id = pcall(GetActionInfo, slot)
	if not ok then
		return "?", nil
	end
	return kind, id
end

--- Is this button Blizzard's Single-Button Assistant? It reports as the spell it suggests, so only this
--- call can tell (same check as ApplyLayout.lua SlotIsAssistant).
local function IsAssist(slot)
	if not (slot and C_ActionBar and C_ActionBar.IsAssistedCombatAction) then
		return false
	end
	local ok, v = pcall(C_ActionBar.IsAssistedCombatAction, slot)
	return (ok and v) and true or false
end

local function OccupantName(kind, id)
	if kind == "spell" then
		return (SpellView(id))
	elseif kind == "item" and C_Item and C_Item.GetItemNameByID then
		return C_Item.GetItemNameByID(id) or ("item " .. tostring(id))
	elseif kind == "macro" and GetMacroInfo then
		local ok, n = pcall(GetMacroInfo, id)
		return (ok and n) or "macro"
	elseif kind == "flyout" and GetFlyoutInfo then
		local ok, n = pcall(GetFlyoutInfo, id)
		return (ok and type(n) == "string" and n) or "flyout"
	elseif kind == "summonmount" and C_MountJournal and C_MountJournal.GetMountInfoByID then
		local ok, n = pcall(C_MountJournal.GetMountInfoByID, id)
		return (ok and type(n) == "string" and n) or "mount"
	end
	return tostring(kind)
end

local function InBags(itemID)
	local count = (C_Item and C_Item.GetItemCount) or GetItemCount
	local ok, n = pcall(count, itemID)
	return ok and type(n) == "number" and n > 0
end

--- The healing potion this spec's consumables data names, first one you carry.
local function PotionInBags()
	local _, token = UnitClass("player")
	local idx = ns.GetSpecialization and ns.GetSpecialization()
	local spec = token and idx and ns.ConsumablesWowheadByClassSpec and ns.ConsumablesWowheadByClassSpec[token]
	local cat = spec and spec[idx] and spec[idx].healingPotion
	if not cat then
		return nil
	end
	for _, list in ipairs({ cat.best or {}, cat.alternates or {} }) do
		for _, id in ipairs(list) do
			if InBags(id) then
				return id
			end
		end
	end
	return nil
end

--- The trinkets you can PRESS, in slot order (13, then 14). Rob, 5 Oct 2026, on TwelveInchy: G held a
--- passive trinket, which does nothing on a button, and the second trinket slot was never looked at.
--- An item with a Use: effect reports its spell via GetItemSpell; a passive one reports none. If the
--- client offers no way to ask, every equipped trinket counts (the old behaviour, both slots).
local function UsableTrinkets()
	local out = {}
	local ask = (C_Item and C_Item.GetItemSpell) or GetItemSpell
	for _, invSlot in ipairs({ 13, 14 }) do
		local id = GetInventoryItemID and GetInventoryItemID("player", invSlot)
		if id then
			local usable = true
			if ask then
				local ok, spellName, spellID = pcall(ask, id)
				usable = ok and (spellName ~= nil or spellID ~= nil)
			end
			if usable then
				out[#out + 1] = id
			end
		end
	end
	return out
end

--- What each fixed place should hold: { kind = "item", id = n } or nil plus a reason.
local function FixedWant(fixed)
	if fixed == "trinket" then
		local id = UsableTrinkets()[1]
		if id then
			return { kind = "item", id = id }
		end
		return nil, "no trinket with a Use: effect equipped"
	elseif fixed == "potion" then
		local id = PotionInBags()
		if id then
			return { kind = "item", id = id }
		end
		return nil, "no healing potion in your bags"
	elseif fixed == "healthstone" then
		if InBags(HEALTHSTONE_ITEM) then
			return { kind = "item", id = HEALTHSTONE_ITEM }
		end
		return nil, "no Healthstone in your bags"
	end
	return nil
end

--- Which button of the bar a block place uses. MEASURED 5 Oct 2026 on Rob's bars 5/6/7 as 3 x 4
--- (Edit Mode via step 2b): the game fills a multi-row bar from the BOTTOM — buttons 1-4 are the bottom
--- row, 9-12 the top. The picture Rob approved has 1 2 3 4 on top and Z X C V at the bottom, like the
--- keyboard, so picture row 1 goes on buttons 9-12 and picture row 3 on buttons 1-4.
local function ButtonFor(i)
	local r, c = math.floor((i - 1) / 4), (i - 1) % 4
	return (2 - r) * 4 + c + 1
end

--- Spells that sit inside a flyout the block places (or that already sits on D): loose copies of them leave bar 1
--- and block D like doubles do. Filled by PlacePlan, read by WantedSpells. (Rob, 6 Oct 2026, Mage portals.)
local flyoutMemberIds = {}

--- The spells the block will hold after placing (placed or already there), with their talent overrides.
local function WantedSpells(rows)
	local wanted = {}
	for id in pairs(flyoutMemberIds) do
		wanted[id] = true
	end
	for _, r in ipairs(rows) do
		if r.want and r.want.kind == "spell" and (r.action == "place" or r.action == "keep") then
			wanted[r.want.id] = true
			if C_SpellBook and C_SpellBook.FindSpellOverrideByID then
				local okO, over = pcall(C_SpellBook.FindSpellOverrideByID, r.want.id)
				if okO and over then
					wanted[over] = true
				end
			end
		end
	end
	return wanted
end

--- The full plan: one row per block place.
--- row = { key, slot, command, want = {kind,id}|nil, action = "place"|"keep"|"refuse"|"skip", why, replaces }
local function PlacePlan()
	local res, class = Build()
	if not res then
		return nil, "no classified spells for " .. tostring(class)
	end
	local bars = ns.KeyBlockBars()
	local rows = {}
	for _, bar in ipairs(BLOCK) do
		local info = BarInfo(bars[bar.id])
		if not info then
			return nil, ("action bar %s has no binding command"):format(tostring(bars[bar.id]))
		end
		for i, slotDef in ipairs(bar.slots) do
			local btnNo = ButtonFor(i)
			local row = {
				key = slotDef.key, bar = bar.id, barNo = bars[bar.id],
				slot = info.first + btnNo - 1, command = info.prefix .. btnNo,
			}
			local hit = res.occ[slotDef.key]
			local want, why
			if hit then
				want = { kind = "spell", id = hit.spell.id }
			elseif slotDef.fixed then
				want, why = FixedWant(slotDef.fixed)
			end
			row.want = want
			if bar.own then
				-- Block D: the player's own place. MH binds the key and leaves the button alone.
				row.want = nil
				row.action = "own"
			elseif IsAssist(row.slot) then
				-- Never move or cover the Single-Button Assistant: an addon cannot put it back
				-- (ApplyLayout.lua, 10 Aug 2026; red team 5 Oct 2026).
				row.action = "refuse"
				row.why = "holds the Single-Button Assistant"
				row.whyKey = "KEYBLOCK_REFUSE_ASSIST"
			elseif not want then
				row.action, row.why = "skip", why or "nothing for this place on this character"
				-- Rob, 5 Oct 2026 ("1 ja"): an empty place on the picture is empty on the bar too. What
				-- stands there now moves aside like anything else the block replaces.
				local kind, id = Occupant(row.slot)
				if kind and Movable(kind) then
					row.action = "clear"
					row.replaces = { kind = kind, id = id, name = (kind == "macro" and GetActionText(row.slot))
						or OccupantName(kind, id) }
				end
			else
				local kind, id = Occupant(row.slot)
				if kind == want.kind and id == want.id then
					row.action = "keep"
				elseif kind == "spell" and want.kind == "spell" and C_SpellBook and C_SpellBook.FindSpellOverrideByID
					and id == select(2, pcall(C_SpellBook.FindSpellOverrideByID, want.id)) then
					row.action = "keep" -- the talent replacement of the same button
				elseif kind == nil then
					row.action = "place"
				elseif Movable(kind) then
					row.action = "place"
					row.replaces = { kind = kind, id = id, name = (kind == "macro" and GetActionText(row.slot))
						or OccupantName(kind, id) }
				else
					row.action = "refuse"
					row.why = ("holds a %s (%s) that could not be put back"):format(tostring(kind), OccupantName(kind, id))
					row.whyKey, row.whyArg = "KEYBLOCK_REFUSE_KIND_FMT", OccupantName(kind, id)
				end
			end
			rows[#rows + 1] = row
		end
	end
	-- A second trinket you can press: the first free place of bar C, in overflow order (Rob, 5 Oct 2026:
	-- "normaal hebben we twee trinkets, worden die ook allebei neergezet?"). Classes with forms keep Ctrl.
	local trinkets = UsableTrinkets()
	if trinkets[2] then
		local hasForms = false
		for _, o in pairs(res.occ) do
			if type(o.why) == "string" and o.why:find("^form") then
				hasForms = true
			end
		end
		local byKey = {}
		for _, r in ipairs(rows) do
			byKey[r.key] = r
		end
		for _, k in ipairs(OVERFLOW) do
			local r = byKey[k]
			if r and not r.want and not (hasForms and k:find("^CTRL%-"))
				and (r.action == "clear" or (r.action == "skip" and Occupant(r.slot) == nil)) then
				r.want = { kind = "item", id = trinkets[2] }
				r.action, r.why = "place", nil
				break
			end
		end
	end

	-- Give everything that gets replaced a free button elsewhere, so nothing leaves the bars. Block D (bar 4,
	-- the player's own) is the first place to park: what is moved aside is exactly "your own stuff".
	local isBlockBar = { [bars.A] = true, [bars.B] = true, [bars.C] = true }
	local free = {}
	for _, n in ipairs(MOVE_BARS) do
		local info = BarInfo(n)
		if info and not isBlockBar[n] then
			for b = 1, 12 do
				local slot = info.first + b - 1
				if not HasAction(slot) then
					free[#free + 1] = { slot = slot, bar = n, button = b }
				end
			end
		end
	end
	-- A spell the block itself places is not parked: it would only be a second copy on block D with a
	-- second key (Rob, 5 Oct 2026, Discipline: Flash Heal on 3 and on Alt C — "die dubbele kopieën gelijk
	-- opruimen"). It is lifted off instead; the snapshot keeps it, so Undo puts it back by id.
	local wanted = WantedSpells(rows)
	for _, r in ipairs(rows) do
		if (r.action == "place" or r.action == "clear") and r.replaces and r.replaces.kind == "spell"
			and wanted[r.replaces.id] then
			r.double = true
		end
	end
	for _, r in ipairs(rows) do
		if (r.action == "place" or r.action == "clear") and r.replaces and not r.double then
			local spot = table.remove(free, 1)
			if spot then
				r.moveTo = spot
			else
				-- No free button left: leave it alone rather than drop it (red team, 5 Oct 2026).
				r.action = "refuse"
				r.why = ("holds %s and there is no free button left on bars 2-4 to move it to"):format(
					tostring(r.replaces.name))
				r.whyKey, r.whyArg = "KEYBLOCK_REFUSE_NOROOM_FMT", tostring(r.replaces.name)
				r.replaces = nil
			end
		end
	end

	-- What found no place on A, B or C goes on a FREE Alt key of block D (Rob, 5 Oct 2026, on his Guardian:
	-- "ja, bouw het zo met blok D"). Mark of the Wild and Revive had "no room" while A/B/C still had empty
	-- places; putting them there would break "same job, same key" (5 is always a rotation button). D is the
	-- player's own bar, so only places that are empty AFTER parking are used, and a spell that already sits
	-- somewhere on D is not added again. Undo lifts it off like any placed button.
	local dInfo = BarInfo(bars.D)
	-- Probe (5 Oct 2026, Rob's Guardian: Revive did NOT land on D and the code reads fine): what this step saw
	-- and decided, in SavedVariables and as one chat line at Place. Silence must be tellable from broken.
	local probe = { dBar = bars.D, hasInfo = dInfo and true or false, unplaced = {}, freeD = {}, dRows = {},
		assigned = {}, skipped = {} }
	ns.db = ns.db or {}
	ns.db.keyBlockLeftoverProbe = probe
	for _, s in ipairs(res.unplaced or {}) do
		probe.unplaced[#probe.unplaced + 1] = tostring(s.name) .. ":" .. tostring(s.id)
	end
	res.leftoverProbe = probe
	flyoutMemberIds = {}
	for _, s in ipairs(res.unplaced or {}) do
		if s.kind == "flyout" then
			for _, mid in pairs(s.members or {}) do
				flyoutMemberIds[mid] = true
			end
		end
	end
	if dInfo and res.unplaced and #res.unplaced > 0 then
		local onD, onDFly = {}, {}
		for b = 1, 12 do
			local kind, id = Occupant(dInfo.first + b - 1)
			if kind == "spell" and id then
				onD[id] = true
			elseif kind == "flyout" and id then
				onDFly[id] = true
			end
		end
		-- A spell that is being moved aside onto D already lands there: MEASURED 5 Oct 2026 on Rob's Guardian,
		-- Mark of the Wild stood on bar 6, was parked on Alt X AND placed again as a leftover on Alt Q.
		for _, r in ipairs(rows) do
			if r.moveTo and r.moveTo.bar == bars.D and r.replaces and r.replaces.kind == "spell" and r.replaces.id then
				onD[r.replaces.id] = true
			end
		end
		local freeD = {}
		for _, spot in ipairs(free) do
			if spot.bar == bars.D then
				freeD[spot.slot] = true
			end
		end
		-- A D place holding a copy of a block spell is emptied by Place (the doubles step runs before the
		-- buttons are placed), so it counts as free too. MEASURED 5 Oct 2026 on Rob's Guardian: "free on D: 0"
		-- at planning time, and after placing D had 14 doubles removed and many empty places.
		for b = 1, 12 do
			local slot = dInfo.first + b - 1
			local kind, id = Occupant(slot)
			if kind == "spell" and id and (wanted[id] or flyoutMemberIds[id]) and not IsAssist(slot) then
				freeD[slot] = true
				onD[id] = nil -- that copy leaves; it is no reason to skip a spell
			end
		end
		for slot in pairs(freeD) do
			probe.freeD[#probe.freeD + 1] = slot
		end
		table.sort(probe.freeD)
		local dRows = {}
		for _, r in ipairs(rows) do
			if r.bar == "D" then
				probe.dRows[#probe.dRows + 1] = ("%s slot %d action %s free %s"):format(r.key, r.slot, tostring(r.action),
					tostring(freeD[r.slot] and true or false))
			end
			if r.bar == "D" and r.action == "own" and freeD[r.slot] then
				dRows[#dRows + 1] = r
			end
		end
		local n = 0
		for _, s in ipairs(res.unplaced) do
			if s.kind == "flyout" then
				if onDFly[s.id] then
					probe.skipped[#probe.skipped + 1] = tostring(s.name) .. ": flyout already on D"
				else
					n = n + 1
					local r = dRows[n]
					if not r then
						probe.skipped[#probe.skipped + 1] = tostring(s.name) .. ": no free place left on D"
						break
					end
					r.want = { kind = "flyout", id = s.id, book = s.book }
					r.action, r.leftover = "place", true
					onDFly[s.id] = true
					probe.assigned[#probe.assigned + 1] = tostring(s.name) .. " (flyout) -> " .. r.key
				end
			elseif not s.id then
				probe.skipped[#probe.skipped + 1] = tostring(s.name) .. ": no id"
			elseif onD[s.id] then
				probe.skipped[#probe.skipped + 1] = tostring(s.name) .. ": already on D"
			else
				n = n + 1
				local r = dRows[n]
				if not r then
					probe.skipped[#probe.skipped + 1] = tostring(s.name) .. ": no free place left on D"
					break
				end
				r.want = { kind = "spell", id = s.id }
				r.action, r.leftover = "place", true
				onD[s.id] = true
				probe.assigned[#probe.assigned + 1] = tostring(s.name) .. " -> " .. r.key
			end
		end
	end
	return rows, res
end

local function WantName(want)
	if not want then
		return "-"
	end
	return OccupantName(want.kind, want.id)
end

--- Is the Blizzard frame of this action bar on screen? (Bars 6/7 are off for most players.)
local BAR_FRAME = { [2] = "MultiBarBottomLeft", [3] = "MultiBarBottomRight", [4] = "MultiBarRight",
	[5] = "MultiBarLeft", [6] = "MultiBar5", [7] = "MultiBar6", [8] = "MultiBar7" }
local function BarShown(n)
	local f = BAR_FRAME[n] and _G[BAR_FRAME[n]]
	if not f then
		return nil
	end
	return f:IsShown() and true or false
end

--- @return string summary for the window, and prints the detail in chat
function ns.KeyBlockPreview(quiet)
	local rows, res = PlacePlan()
	local p = "|cffffcc00Midnight Helper:|r "
	if not rows then
		if not quiet then
			print(p .. "key block: " .. tostring(res))
		end
		return ns:L("KEYBLOCK_PLACE_NOTHING")
	end
	local n = { place = 0, keep = 0, refuse = 0, skip = 0, replace = 0, clear = 0, own = 0 }
	for _, r in ipairs(rows) do
		n[r.action] = n[r.action] + 1
		if r.replaces then
			n.replace = n.replace + 1
		end
	end
	if not quiet then
		print(p .. "key block, dry run — nothing changed yet:")
		for _, r in ipairs(rows) do
			local where = ("bar %d button %d"):format(r.barNo, r.slot - BarInfo(r.barNo).first + 1)
			local line
			if r.action == "place" then
				line = ("|cff40ff40place|r %s on %s%s"):format(WantName(r.want), where,
					r.replaces and (" |cffffcc00(replaces " .. r.replaces.name .. (r.double and ", a double" or "") .. ")|r") or "")
			elseif r.action == "keep" then
				line = ("|cff9d9d9dalready there|r %s"):format(WantName(r.want))
			elseif r.action == "clear" then
				line = ("|cffffcc00made empty|r %s: %s %s"):format(where, r.replaces.name or "?",
				r.double and "is a double and goes off" or "moves aside")
			elseif r.action == "refuse" then
				line = ("|cffff8080left alone|r %s: %s"):format(where, r.why)
			else
				line = ("|cff9d9d9dfree|r (%s)"):format(r.why or "")
			end
			print(("  %-8s %s"):format(KeyLabel(r.key), line))
		end
		local bars = ns.KeyBlockBars()
		for _, id in ipairs({ "A", "B", "C" }) do
			if BarShown(bars[id]) == false then
				print(("  |cffff8080action bar %d is hidden|r — turn it on in Options > Action Bars, or the keys work on an invisible bar."):format(bars[id]))
			end
		end
	end
	return ns:L("KEYBLOCK_PLACE_SUMMARY_FMT"):format(n.place, n.replace, n.keep, n.refuse, n.skip)
end

--- 🔴 ONE SNAPSHOT PER CHARACTER. MidnightHelperDB is account-wide, and until 5 Oct 2026 so was the
--- snapshot: Rob logged a low-level alt with his Paladin's block placed, where "Undo" would have put the
--- Paladin's buttons back onto the alt's bars and "Place it" refused because "already placed".
--- The one snapshot from before this fix has no owner; it is claimed by the character whose bars prove
--- it: a macro the snapshot moved aside still sits, by name, on the button it was moved to.
--- 🔴 PER CHARACTER AND SPEC (5 Oct 2026). Action bars belong to a spec: MEASURED on Rob's Paladin the
--- same evening — Prot had the block on its bars while Holy's bars were still his old ones. Keyed on the
--- character alone, Prot's window said "Update" with Holy's snapshot, and Undo there would have put
--- Holy's old buttons onto Prot's bars.
local function MyGUID()
	return UnitGUID and UnitGUID("player") or "?"
end

local function MyKey()
	local spec = "?"
	if ns.GetSpecialization and ns.GetSpecializationInfo then
		local ok, id = pcall(ns.GetSpecializationInfo, ns.GetSpecialization())
		if ok and id then
			spec = tostring(id)
		end
	end
	return MyGUID() .. ":" .. spec
end

--- Do this character's bars prove the snapshot is theirs? EVERY thing it moved aside must still sit on the
--- button it was moved to: a spell by id, an item by id, a macro by name.
--- ⚠️ MEASURED 5 Oct 2026: the first version accepted ONE matching macro name, and Rob's level-11 Hunter
--- claimed his Paladin's snapshot (a macro of the same name on the same button, account-wide macros).
local function ProvesMine(snap)
	local checked = 0
	for _, s in ipairs(snap.slots or {}) do
		if s.movedTo then
			local kind, id = Occupant(s.movedTo)
			if kind ~= s.kind then
				return false
			end
			if kind == "macro" then
				if GetActionText(s.movedTo) ~= s.name then
					return false
				end
			elseif id ~= s.id then
				return false
			end
			checked = checked + 1
		end
	end
	return checked > 0
end

local function GetSnap()
	local db = ns.db
	if not db then
		return nil
	end
	db.keyBlockSnapshots = db.keyBlockSnapshots or {}
	local mine = db.keyBlockSnapshots[MyKey()]
	-- Made on this character (owner stamped): trust it. Claimed from the old shared slot: prove it again,
	-- and hand it back unowned if this character's bars do not.
	if mine and mine.owner == MyKey() then
		return mine
	end
	if mine then
		if ProvesMine(mine) then
			mine.owner = MyKey()
			return mine
		end
		db.keyBlockSnapshots[MyKey()] = nil
		db.keyBlockSnapshot = db.keyBlockSnapshot or mine
	end
	-- A snapshot keyed by the character alone (before the spec was part of the key): it belongs to the
	-- spec whose bars prove it, and moves under that spec's key.
	local byChar = db.keyBlockSnapshots[MyGUID()]
	if byChar and ProvesMine(byChar) then
		byChar.owner = MyKey()
		db.keyBlockSnapshots[MyKey()] = byChar
		db.keyBlockSnapshots[MyGUID()] = nil
		return byChar
	end
	local old = db.keyBlockSnapshot
	if old and ProvesMine(old) then
		old.owner = MyKey()
		db.keyBlockSnapshots[MyKey()] = old
		db.keyBlockSnapshot = nil
		return old
	end
	return nil
end

local function SetSnap(v)
	ns.db = ns.db or {}
	ns.db.keyBlockSnapshots = ns.db.keyBlockSnapshots or {}
	if v then
		v.owner = MyKey()
	end
	ns.db.keyBlockSnapshots[MyKey()] = v
end

--- True when the block is placed on this character + spec's bars (there is an undo snapshot).
function ns.KeyBlockIsPlaced()
	return GetSnap() ~= nil
end

--- Do it. Snapshot first; one undo puts back every slot and key we touched.
function ns.KeyBlockPlace()
	local p = "|cffffcc00Midnight Helper:|r "
	if InCombatLockdown and InCombatLockdown() then
		print(p .. "not in combat.")
		return false
	end
	local rows, res = PlacePlan()
	if not rows then
		print(p .. "key block: " .. tostring(res))
		return false
	end
	ns.db = ns.db or {}
	if GetSnap() then
		print(p .. "the key block is already placed. |cffffffff/mh block undo|r first, then place again.")
		return false
	end
	local snap = { slots = {}, binds = {}, at = time and time() or nil }
	-- Snapshot everything we are about to touch, before touching anything.
	for _, r in ipairs(rows) do
		if r.action == "place" or r.action == "clear" then
			local kind, id = Occupant(r.slot)
			snap.slots[#snap.slots + 1] = { slot = r.slot, kind = kind, id = id,
				name = r.replaces and r.replaces.name, movedTo = r.moveTo and r.moveTo.slot }
		end
		-- EVERY block key goes to its own place, also an empty one (Rob's Hunter, 5 Oct 2026: Shift Z/X/C/V
		-- still pressed old buttons on bars 3 and 4, because only filled places were bound). An empty
		-- place's key now does nothing until something lands there — the same key, the same place.
		snap.binds[#snap.binds + 1] = { key = r.key, was = GetBindingAction and GetBindingAction(r.key) or "" }
	end
	SetSnap(snap)

	-- Rob, 5 Oct 2026 ("ik volg het advies"): with the block placed, Blizzard stops pushing new spells onto
	-- bar 1 — MH's own question puts them on the block. The old value is kept and Undo puts it back.
	-- CVar name MEASURED by mh-research (Blizzard forums: "/console AutoPushSpellToActionBar 0").
	if C_CVar and C_CVar.GetCVar then
		local okV, v = pcall(C_CVar.GetCVar, AUTOPUSH_CVAR)
		if okV and v ~= nil then
			snap.autoPush = v
			pcall(C_CVar.SetCVar, AUTOPUSH_CVAR, "0")
		end
	end

	-- And the doubles leave bar 1 (buttons 1-12 only — never the form/stealth pages, never the Single-
	-- Button Assistant, spells only; red team 5 Oct 2026). Each is recorded, so Undo puts it back.
	-- 5 Oct 2026 (Rob: "die dubbele kopieën gelijk opruimen"): the same for block D's bar, the player's own
	-- bar 4, so a block spell has one key. Spells only; items and macros stay.
	local wanted = WantedSpells(rows)
	local doubleSlots = {}
	for slot = 1, 12 do
		doubleSlots[#doubleSlots + 1] = slot
	end
	local dInfo = BarInfo(ns.KeyBlockBars().D)
	if dInfo then
		for b = 1, 12 do
			doubleSlots[#doubleSlots + 1] = dInfo.first + b - 1
		end
	end
	local doubles = 0
	for _, slot in ipairs(doubleSlots) do
		local kind, id = Occupant(slot)
		if kind == "spell" and wanted[id] and not IsAssist(slot) then
			pcall(function()
				ClearCursor()
				PickupAction(slot)
				ClearCursor()
			end)
			pcall(ClearCursor)
			if Occupant(slot) == nil then
				snap.slots[#snap.slots + 1] = { slot = slot, kind = "spell", id = id, name = OccupantName("spell", id) }
				doubles = doubles + 1
			end
		end
	end
	snap.bar1Doubles = doubles

	local placed, bound, failed, moved = 0, 0, {}, 0
	for _, r in ipairs(rows) do
		-- An empty place: move what is there aside (or, with no free button left, just lift it off;
		-- the undo then puts it back by kind).
		if r.action == "clear" then
			pcall(function()
				ClearCursor()
				PickupAction(r.slot)
				if r.moveTo then
					PlaceAction(r.moveTo.slot)
				end
				ClearCursor()
			end)
			pcall(ClearCursor)
			if r.moveTo and HasAction(r.moveTo.slot) then
				moved = moved + 1
			end
		end
		if r.action == "place" then
			-- Move what is there now to its free button first: a plain drag, so a macro stays itself.
			if r.moveTo then
				pcall(function()
					ClearCursor()
					PickupAction(r.slot)
					PlaceAction(r.moveTo.slot)
					ClearCursor()
				end)
				pcall(ClearCursor)
				if HasAction(r.moveTo.slot) then
					moved = moved + 1
				end
			end
			local ok = pcall(function()
				ClearCursor()
				if r.want.kind == "spell" then
					if C_Spell and C_Spell.PickupSpell then
						C_Spell.PickupSpell(r.want.id)
					else
						PickupSpell(r.want.id)
					end
				elseif r.want.kind == "flyout" then
					-- A flyout is picked up from its spellbook slot (the index the scan saw this same moment).
					C_SpellBook.PickupSpellBookItem(r.want.book, Enum.SpellBookSpellBank.Player)
				elseif C_Item and C_Item.PickupItem then
					C_Item.PickupItem(r.want.id)
				else
					PickupItem(r.want.id)
				end
				PlaceAction(r.slot)
				ClearCursor()
			end)
			pcall(ClearCursor)
			-- Verify by reading the slot back: the Single-Button Assistant taught us that a pickup
			-- can silently do nothing (ApplyLayout.lua, 10 Aug 2026).
			local kind = Occupant(r.slot)
			if ok and kind == r.want.kind then
				placed = placed + 1
			else
				failed[#failed + 1] = WantName(r.want)
			end
		end
		do
			if SetBinding(r.key, r.command) then
				bound = bound + 1
			end
		end
	end
	if SaveBindings and GetCurrentBindingSet then
		pcall(SaveBindings, GetCurrentBindingSet())
	end
	print(p .. ("key block placed: %d buttons, %d keys, %d moved aside (block D first), %d doubles off bar 1 and block D. |cffffffff/mh block undo|r puts everything back."):format(placed, bound, moved, doubles))
	if #failed > 0 then
		print("   |cffff8080did not land:|r " .. table.concat(failed, ", "))
	end
	-- What went to block D, or why not (probe, 5 Oct 2026). Full detail: ns.db.keyBlockLeftoverProbe.
	local lp = res and res.leftoverProbe
	if lp and (#lp.assigned > 0 or #lp.skipped > 0 or #lp.unplaced > 0) then
		print(("   block D: %s%s  |cff9d9d9d(free on D: %d, no place on A/B/C: %d)|r"):format(
			#lp.assigned > 0 and table.concat(lp.assigned, ", ") or "nothing placed",
			#lp.skipped > 0 and (" |cffffcc00— " .. table.concat(lp.skipped, ", ") .. "|r") or "",
			#lp.freeD, #lp.unplaced))
	end
	if ns.KeyBlockArmBar1 then
		ns.KeyBlockArmBar1()
	end
	return true
end

function ns.KeyBlockUndo()
	local p = "|cffffcc00Midnight Helper:|r "
	local snap = GetSnap()
	if not snap then
		print(p .. "nothing to undo — the key block was not placed.")
		return false
	end
	if InCombatLockdown and InCombatLockdown() then
		print(p .. "not in combat.")
		return false
	end
	for _, b in ipairs(snap.binds or {}) do
		if b.was and b.was ~= "" then
			SetBinding(b.key, b.was)
		else
			SetBinding(b.key)
		end
	end
	local restored = 0
	for _, s in ipairs(snap.slots or {}) do
		-- Moved aside: pick it up from where it went and drop it on its own button. That swap puts ours
		-- on the cursor, which is then dropped. No id lookup, so a macro comes back as itself.
		local movedKind = s.movedTo and Occupant(s.movedTo)
		local ok = pcall(function()
			ClearCursor()
			if s.movedTo and movedKind == s.kind then
				PickupAction(s.movedTo)
				PlaceAction(s.slot)
				ClearCursor()
				return
			end
			PickupAction(s.slot) -- lift ours off
			ClearCursor()
			if s.kind == "macro" and s.name and GetMacroIndexByName then
				local idx = GetMacroIndexByName(s.name)
				if idx and idx > 0 then
					PickupMacro(idx)
					PlaceAction(s.slot)
				end
			elseif s.kind == "spell" and s.id then
				if C_Spell and C_Spell.PickupSpell then
					C_Spell.PickupSpell(s.id)
				else
					PickupSpell(s.id)
				end
				PlaceAction(s.slot)
			elseif s.kind == "item" and s.id then
				if C_Item and C_Item.PickupItem then
					C_Item.PickupItem(s.id)
				else
					PickupItem(s.id)
				end
				PlaceAction(s.slot)
			end
			ClearCursor()
		end)
		pcall(ClearCursor)
		if ok then
			restored = restored + 1
		end
	end
	if SaveBindings and GetCurrentBindingSet then
		pcall(SaveBindings, GetCurrentBindingSet())
	end
	if snap.autoPush ~= nil and C_CVar and C_CVar.SetCVar then
		pcall(C_CVar.SetCVar, AUTOPUSH_CVAR, snap.autoPush)
	end
	SetSnap(nil)
	print(p .. ("key block undone: %d slots and %d keys back as they were."):format(restored, #(snap.binds or {})))
	if ns.KeyBlockArmBar1 then
		ns.KeyBlockArmBar1()
	end
	return true
end

--------------------------------------------------------------------------------
-- New spells after placing (5 Oct 2026, Rob levelled his Hunter 11 -> 12: "hoe gaan we daarmee om?").
-- Agreed: a "Bijwerken" button, a question when a new spell is learned (never in combat), and a switch
-- ask / automatic / never (default ask). Update only ADDS: what stands on the block keeps its place, so a
-- key never changes meaning. A new spell goes to its own place if that is empty, else to the first empty
-- place of bar C.
--------------------------------------------------------------------------------

local win -- the picture window (built further down)
local Refresh -- forward: the window's buttons redraw after placing, undoing or updating

--- What the plan wants that is on no block button yet, with where it would go.
--- @return table list of { row = planRow, target = planRow } (target = the place it lands on)
local function MissingRows()
	local rows = PlacePlan()
	if not rows then
		return {}
	end
	local present, empty, byKey = {}, {}, {}
	for _, r in ipairs(rows) do
		byKey[r.key] = r
		local kind, id = Occupant(r.slot)
		if kind and id then
			present[kind .. ":" .. tostring(id)] = true
			-- What this button turns into counts as present too. Rob, 6 Oct 2026 (Hunter): every pet swap asked
			-- "New for your key block: Primal Rage -> F1". The button holds Command Pet 272651; with a Ferocity pet
			-- the game overrides it to Primal Rage 272678 (MEASURED in his client by the site chat), and the scan
			-- sees 272678. Place it put 272651 down again, so the question came back on every SPELLS_CHANGED.
			-- C_Spell.GetOverrideSpell is the call measured in his client; the other is the one this file already uses.
			if kind == "spell" then
				for _, fn in pairs({ C_Spell and C_Spell.GetOverrideSpell, C_SpellBook and C_SpellBook.FindSpellOverrideByID }) do
					local ok, over = pcall(fn, id)
					if ok and type(over) == "number" and over ~= id then
						present["spell:" .. tostring(over)] = true
					end
				end
			end
		else
			empty[r.key] = true
		end
	end
	local function isPresent(want)
		if present[want.kind .. ":" .. tostring(want.id)] then
			return true
		end
		if want.kind == "spell" and C_SpellBook and C_SpellBook.FindSpellOverrideByID then
			local ok, over = pcall(C_SpellBook.FindSpellOverrideByID, want.id)
			if ok and over and present["spell:" .. tostring(over)] then
				return true
			end
		end
		return false
	end
	local out = {}
	for _, r in ipairs(rows) do
		if r.want and not isPresent(r.want) then
			local target
			if empty[r.key] then
				target = r
			elseif r.leftover then
				-- A block D thing (leftover, flyout, onlyD) never borrows a place on A/B/C. Rob, 6 Oct 2026: the
				-- popup offered Cone of Cold -> Ctrl 2, Portal -> Ctrl 3, Teleport -> Shift C. Its D place is only
				-- "free" because Place lifts loose copies off D first; Update does not, so it waits for Place.
				target = nil
			else
				for _, k in ipairs(OVERFLOW) do
					if empty[k] and byKey[k] then
						target = byKey[k]
						break
					end
				end
			end
			if target then
				empty[target.key] = nil
			end
			out[#out + 1] = { row = r, target = target }
		end
	end
	return out
end
ns.KeyBlockMissing = MissingRows

local function MissingName(m)
	return OccupantName(m.row.want.kind, m.row.want.id)
end

--- `Bijwerken`: add what is new, nothing else. Recorded in the same snapshot, so Undo takes it off too.
function ns.KeyBlockUpdate()
	local p = "|cffffcc00Midnight Helper:|r "
	if InCombatLockdown and InCombatLockdown() then
		print(p .. "not in combat.")
		return false
	end
	local snap = GetSnap()
	if not snap then
		print(p .. "the key block is not placed on this character yet — use \"Place it\" first.")
		return false
	end
	local added, names, rebound = 0, {}, false
	for _, m in ipairs(MissingRows()) do
		local t = m.target
		if t then
			local want = m.row.want
			pcall(function()
				ClearCursor()
				if want.kind == "spell" then
					if C_Spell and C_Spell.PickupSpell then
						C_Spell.PickupSpell(want.id)
					else
						PickupSpell(want.id)
					end
				elseif want.kind == "flyout" and want.book then
					C_SpellBook.PickupSpellBookItem(want.book, Enum.SpellBookSpellBank.Player)
				elseif C_Item and C_Item.PickupItem then
					C_Item.PickupItem(want.id)
				else
					PickupItem(want.id)
				end
				PlaceAction(t.slot)
				ClearCursor()
			end)
			pcall(ClearCursor)
			if Occupant(t.slot) == want.kind then
				-- First in the list: the undo must lift this off BEFORE it puts back what stood here before.
				table.insert(snap.slots, 1, { slot = t.slot })
				added = added + 1
				-- And the key goes with it. Rob, 5 Oct 2026: Rapid Fire landed on block A place 3, but "3"
				-- still pressed bar 1 (placed before every key was bound). Remember the old binding once.
				if GetBindingAction(t.key) ~= t.command then
					local known = false
					for _, b in ipairs(snap.binds or {}) do
						if b.key == t.key then
							known = true
						end
					end
					if not known then
						snap.binds = snap.binds or {}
						snap.binds[#snap.binds + 1] = { key = t.key, was = GetBindingAction(t.key) or "" }
					end
					SetBinding(t.key, t.command)
					rebound = true
				end
				names[#names + 1] = ("%s (%s)"):format(MissingName(m), KeyLabel(t.key))
			end
		end
	end
	-- Every block key on its own place, also on a block placed before 5 Oct evening (when empty places
	-- were not bound yet): bind any block key that still points elsewhere.
	local rows = PlacePlan()
	for _, r in ipairs(rows or {}) do
		if r.action ~= "refuse" and GetBindingAction(r.key) ~= r.command then
			local known = false
			for _, b in ipairs(snap.binds or {}) do
				if b.key == r.key then
					known = true
				end
			end
			if not known then
				snap.binds[#snap.binds + 1] = { key = r.key, was = GetBindingAction(r.key) or "" }
			end
			SetBinding(r.key, r.command)
			rebound = true
		end
	end
	if rebound and SaveBindings and GetCurrentBindingSet then
		pcall(SaveBindings, GetCurrentBindingSet())
	end
	ns.db.keyBlockAsked = ns.db.keyBlockAsked or {}
	ns.db.keyBlockAsked[MyKey()] = nil
	if added == 0 then
		print(p .. "key block: nothing new to add.")
	else
		print(p .. ("key block updated: %s."):format(table.concat(names, ", ")))
	end
	if win and win:IsShown() and Refresh then
		Refresh(win)
	end
	return true, added, names
end

--- Ask / automatic / never. Per account: it is how this player wants to be treated, not a character fact.
local NEW_MODES = { "ask", "auto", "never" }
function ns.KeyBlockNewMode()
	local m = ns.db and ns.db.keyBlockNewMode
	return (m == "auto" or m == "never") and m or "ask"
end

local function NextMode()
	local cur = ns.KeyBlockNewMode()
	for i, m in ipairs(NEW_MODES) do
		if m == cur then
			ns.db = ns.db or {}
			ns.db.keyBlockNewMode = NEW_MODES[i % #NEW_MODES + 1]
			return ns.db.keyBlockNewMode
		end
	end
end

local function AskKey(list)
	local ids = {}
	for _, m in ipairs(list) do
		ids[#ids + 1] = m.row.want.kind .. ":" .. tostring(m.row.want.id)
	end
	table.sort(ids)
	return table.concat(ids, ",")
end

if StaticPopupDialogs then
	StaticPopupDialogs["MH_KEYBLOCK_NEW"] = {
		text = "%s",
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function()
			ns.KeyBlockUpdate()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}
end

local pending = false
local watcher = CreateFrame("Frame")

--- Look for new spells. Never acts in combat: it waits for the fight to end.
local function CheckNew()
	pending = false
	if not GetSnap() then
		return
	end
	local mode = ns.KeyBlockNewMode()
	if mode == "never" then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		watcher:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	local list = {}
	for _, m in ipairs(MissingRows()) do
		if m.target then
			list[#list + 1] = m
		end
	end
	if #list == 0 then
		return
	end
	if mode == "auto" then
		ns.KeyBlockUpdate()
		return
	end
	-- "Later" means: not again for this same set. Something newer asks again; the button always works.
	ns.db.keyBlockAsked = ns.db.keyBlockAsked or {}
	local key = AskKey(list)
	if ns.db.keyBlockAsked[MyKey()] == key then
		return
	end
	ns.db.keyBlockAsked[MyKey()] = key
	local parts = {}
	for _, m in ipairs(list) do
		-- "->", not an arrow glyph: the popup font has no "→" (Rob's screenshot showed a box).
		parts[#parts + 1] = ("%s -> %s"):format(MissingName(m), KeyLabel(m.target.key))
	end
	-- Labels set on the dialog itself before showing: renaming the buttons in OnShow did not take on
	-- 12.1 (Rob saw Okay/Cancel).
	local dlg = StaticPopupDialogs and StaticPopupDialogs["MH_KEYBLOCK_NEW"]
	if dlg then
		dlg.button1 = ns:L("KEYBLOCK_NEW_PLACE")
		dlg.button2 = ns:L("KEYBLOCK_NEW_LATER")
	end
	if StaticPopup_Show then
		StaticPopup_Show("MH_KEYBLOCK_NEW", ns:L("KEYBLOCK_NEW_POPUP_FMT"):format(table.concat(parts, "\n")))
	end
end

watcher:RegisterEvent("SPELLS_CHANGED")
watcher:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
	-- SPELLS_CHANGED comes in bursts (login, level-up, talents): one look, two seconds after the last.
	if pending then
		return
	end
	pending = true
	if C_Timer and C_Timer.After then
		C_Timer.After(2, CheckNew)
	else
		CheckNew()
	end
end)

--------------------------------------------------------------------------------
-- The picture
--------------------------------------------------------------------------------

-- Rob, 5 Oct 2026 (screenshot): "Shift F1" ran through the icon and long names were cut. So the key
-- gets its own strip at the top, the icon sits under it, the name under that, and the place is wider.
-- 76 since block D made it four blocks wide; the window also shrinks to fit the screen (ShowKeyBlock).
local SLOT_W, SLOT_H, GAP = 76, 80, 6
local KEY_STRIP = 16

-- What "Place it" will do to each place, shown ON the picture (Rob, 5 Oct 2026: the dry run in chat was
-- "een lange lijst … geen idee wat ik daar op zou moeten letten"). Border colour per action.
local PLAN_BORDER = {
	place = { 0.25, 0.85, 0.35 },   -- green: goes here
	replace = { 1.0, 0.55, 0.1 },   -- orange: replaces what is there now
	refuse = { 0.95, 0.25, 0.25 },  -- red: left alone, MH cannot put it back
}

local function SlotTooltip(btn)
	local d = btn.data
	if not d then
		return
	end
	GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
	if d.spellID then
		GameTooltip:SetSpellByID(d.spellID)
		GameTooltip:AddLine(" ")
	end
	GameTooltip:AddLine(KeyLabel(d.key) .. " · " .. ns:L(d.task), 1, 0.82, 0)
	if d.fixed then
		GameTooltip:AddLine(ns:L("KEYBLOCK_FIXED_HINT"), 0.8, 0.8, 0.8, true)
	elseif not d.spellID then
		GameTooltip:AddLine(ns:L("KEYBLOCK_FREE_HINT"), 0.8, 0.8, 0.8, true)
	end
	local r = d.plan
	if r then
		GameTooltip:AddLine(" ")
		if (r.action == "place" or r.action == "clear") and r.replaces and r.moveTo then
			GameTooltip:AddLine(ns:L("KEYBLOCK_TIP_MOVES_FMT"):format(r.replaces.name or "?", r.moveTo.bar, r.moveTo.button),
				1, 0.6, 0.2, true)
		elseif r.action == "place" and r.replaces then
			GameTooltip:AddLine(ns:L("KEYBLOCK_TIP_REPLACES_FMT"):format(r.replaces.name or "?"), 1, 0.6, 0.2, true)
		elseif r.action == "place" then
			GameTooltip:AddLine(ns:L("KEYBLOCK_TIP_PLACE"), 0.4, 0.9, 0.45, true)
		elseif r.action == "refuse" then
			-- The player's language; `why` stays English for /mh block why and the chat dry run.
			local why = r.why or ""
			if r.whyKey then
				why = ns:L(r.whyKey):format(r.whyArg or "?")
			end
			GameTooltip:AddLine(ns:L("KEYBLOCK_TIP_REFUSE_FMT"):format(why), 1, 0.35, 0.35, true)
		elseif r.action == "keep" then
			GameTooltip:AddLine(ns:L("KEYBLOCK_TIP_KEEP"), 0.7, 0.7, 0.7, true)
		end
	end
	GameTooltip:Show()
end

local function MakeSlot(parent)
	local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
	b:SetSize(SLOT_W, SLOT_H)
	b:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
	b:SetBackdropColor(0.10, 0.11, 0.14, 0.95)
	b:SetBackdropBorderColor(0.30, 0.32, 0.38, 1)
	-- The key on its own strip, so nothing is ever drawn over it.
	b.keyBg = b:CreateTexture(nil, "BACKGROUND", nil, 1)
	b.keyBg:SetPoint("TOPLEFT", 1, -1)
	b.keyBg:SetPoint("TOPRIGHT", -1, -1)
	b.keyBg:SetHeight(KEY_STRIP)
	b.keyBg:SetColorTexture(0, 0, 0, 0.45)
	b.key = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	b.key:SetPoint("TOPLEFT", 4, -3)
	b.key:SetPoint("TOPRIGHT", -4, -3)
	b.key:SetJustifyH("LEFT")
	b.key:SetWordWrap(false)
	b.key:SetTextColor(1, 0.82, 0)
	b.icon = b:CreateTexture(nil, "ARTWORK")
	b.icon:SetSize(36, 36)
	b.icon:SetPoint("TOP", 0, -(KEY_STRIP + 5))
	b.task = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.task:SetPoint("BOTTOMLEFT", 3, 5)
	b.task:SetPoint("BOTTOMRIGHT", -3, 5)
	b.task:SetJustifyH("CENTER")
	b.task:SetWordWrap(false)
	b:SetScript("OnEnter", SlotTooltip)
	b:SetScript("OnLeave", GameTooltip_Hide)
	return b
end

local function Ensure()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperKeyBlock", UIParent, "BackdropTemplate")
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
	close:SetPoint("TOPRIGHT", -4, -4)
	f.intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.intro:SetPoint("TOPLEFT", 22, -42)
	f.intro:SetPoint("RIGHT", -22, 0)
	f.intro:SetJustifyH("LEFT")

	local barW = 4 * SLOT_W + 3 * GAP
	f.bars, f.slots = {}, {}
	for i, bar in ipairs(BLOCK) do
		local col = CreateFrame("Frame", nil, f)
		col:SetSize(barW, 3 * SLOT_H + 2 * GAP + 18)
		col:SetPoint("TOPLEFT", 22 + (i - 1) * (barW + 22), -86)
		col.head = col:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		col.head:SetPoint("TOPLEFT", 0, 0)
		f.bars[bar.id] = col
		for n, slot in ipairs(bar.slots) do
			local b = MakeSlot(col)
			local r, c = math.floor((n - 1) / 4), (n - 1) % 4
			b:SetPoint("TOPLEFT", c * (SLOT_W + GAP), -18 - r * (SLOT_H + GAP))
			f.slots[slot.key] = b
		end
	end
	f:SetSize(22 * 2 + #BLOCK * barW + (#BLOCK - 1) * 22, 86 + 3 * SLOT_H + 2 * GAP + 18 + 170)

	f.unplaced = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.unplaced:SetPoint("BOTTOMLEFT", 22, 124)
	f.unplaced:SetPoint("RIGHT", -22, 0)
	f.unplaced:SetJustifyH("LEFT")
	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.foot:SetPoint("BOTTOMLEFT", 22, 48)
	f.foot:SetPoint("RIGHT", -22, 0)
	f.foot:SetJustifyH("LEFT")

	-- Step 2 (5 Oct 2026): the dry run, the real thing, and the way back — in the window, where the
	-- player decides, with the outcome said here too (chat is a record, not an answer in place).
	local function Btn(key, x, onClick)
		local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		b:SetSize(200, 22)
		b:SetPoint("BOTTOMLEFT", x, 18)
		b:SetText(ns:L(key))
		b:SetScript("OnClick", onClick)
		return b
	end
	-- Once placed, the same button adds what is new ("Bijwerken"): one place to look, never both at once.
	f.placeBtn = Btn("KEYBLOCK_BTN_PLACE", 22, function()
		if GetSnap() then
			local ok, added, names = ns.KeyBlockUpdate()
			if ok then
				Refresh(f)
				f.foot:SetText(added and added > 0
					and ns:L("KEYBLOCK_UPDATE_DONE_FMT"):format(table.concat(names, ", "))
					or ns:L("KEYBLOCK_UPDATE_NOTHING"))
			end
		elseif ns.KeyBlockPlace() then
			Refresh(f)
			f.foot:SetText(ns:L("KEYBLOCK_PLACED_DONE"))
		end
	end)
	-- New spells: ask / automatic / never. Click to switch.
	f.modeBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.modeBtn:SetSize(300, 20)
	f.modeBtn:SetPoint("TOPRIGHT", -120, -16)
	f.modeBtn:SetScript("OnClick", function()
		NextMode()
		Refresh(f)
	end)
	-- Bars 2 and 3 back on screen, or hidden again (only while the block layout is on).
	f.oldBarsBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.oldBarsBtn:SetSize(240, 20)
	f.oldBarsBtn:SetPoint("RIGHT", f.modeBtn, "LEFT", -10, 0)
	f.oldBarsBtn:SetScript("OnClick", function()
		if not ns.MH_EditModeOldBars then
			return
		end
		local _, _, hidden = ns.MH_EditModeKeyBlockState()
		local ok, msg = ns.MH_EditModeOldBars(hidden)
		Refresh(f)
		f.foot:SetText(msg or "")
		if ok then
			f.reloadBtn:Show()
		end
	end)
	f.undoBtn = Btn("KEYBLOCK_BTN_UNDO", 22 + 210, function()
		if ns.KeyBlockUndo() then
			Refresh(f)
			f.foot:SetText(ns:L("KEYBLOCK_UNDO_DONE"))
		end
	end)
	-- Step 2b: the bars themselves, through Edit Mode. Both ways need a /reload, so after either
	-- the button turns into one: a change that only settles after a reload must say so where you click.
	local function NeedReload(ok, msg)
		f.foot:SetText(msg or "")
		if ok then
			f.reloadBtn:Show()
			-- The next step in the middle of the screen, not only in small print under the picture and in
			-- chat. Rob, 5 Oct 2026, on his Prot: "iemand anders is absoluut een noob … chat leest bijna
			-- niemand … ik weet niet wat ik moet doen nu".
			if StaticPopupDialogs and StaticPopup_Show then
				local d = StaticPopupDialogs["MH_KEYBLOCK_RELOAD"] or {
					text = "%s",
					OnAccept = function()
						ns.KeyBlockReloadAndReopen()
					end,
					timeout = 0,
					whileDead = true,
					hideOnEscape = true,
					preferredIndex = 3,
				}
				d.button1 = ns:L("KEYBLOCK_BTN_RELOAD")
				d.button2 = ns:L("KEYBLOCK_NEW_LATER")
				StaticPopupDialogs["MH_KEYBLOCK_RELOAD"] = d
				local pop = StaticPopup_Show("MH_KEYBLOCK_RELOAD", ns:L("KEYBLOCK_RELOAD_POPUP"))
				-- Above the key block window (both are DIALOG strata otherwise).
				if pop and pop.SetFrameStrata then
					pop:SetFrameStrata("FULLSCREEN_DIALOG")
				end
			end
		end
		if f.UpdateLayoutUndo then
			f.UpdateLayoutUndo()
		end
	end
	-- The way back NAMES the layout it puts back. Rob, 5 Oct 2026, pressing it on his Hunter: "waarom zegt
	-- hij iets over twelve retro?" — the block layout he undid was his Paladin's account layout, and a
	-- button called "my bars back" gave no hint of that. Grey when there is nothing to put back.
	-- Per layout since 5 Oct evening: it names THIS character's active layout, and is grey unless MH
	-- arranged that one (Rob's Paladin was offered "Put Oak back", his Hunter's layout).
	function f.UpdateLayoutUndo()
		local name, on, _, shared = ns.MH_EditModeKeyBlockState()
		if on then
			-- A shared (account) layout arranged by another character: Rob, 5 Oct 2026 on his Warlock on
			-- "twelve retro" ("ik zal iets verkeerd hebben, maar ik snap het niet"). Nothing was wrong, but the
			-- button never said that putting it back changes every character on that layout.
			local key = shared and "KEYBLOCK_BTN_LAYOUT_UNDO_SHARED_FMT" or "KEYBLOCK_BTN_LAYOUT_UNDO_FMT"
			f.layoutUndoBtn:SetText(ns:L(key):format(tostring(name)))
			f.layoutUndoBtn:Enable()
		else
			f.layoutUndoBtn:SetText(ns:L("KEYBLOCK_BTN_LAYOUT_UNDO"))
			f.layoutUndoBtn:Disable()
		end
	end
	-- On a preset (Modern/Classic) the same button first makes this spec a layout of its own.
	f.layoutBtn = Btn("KEYBLOCK_BTN_LAYOUT", 22 + 2 * 210, function()
		local _, _, _, onPreset = ns.MH_EditModeKeyBlockState()
		if onPreset and ns.MH_EditModeMakeOwnLayout then
			NeedReload(ns.MH_EditModeMakeOwnLayout())
		else
			NeedReload(ns.MH_EditModeApplyKeyBlock())
		end
	end)
	f.layoutUndoBtn = Btn("KEYBLOCK_BTN_LAYOUT_UNDO", 22 + 3 * 210, function()
		NeedReload(ns.MH_EditModeRestoreKeyBlock())
	end)
	-- Cheat sheet: a code for midnighthelper.com, to print or keep on a phone (route 1, 5 Oct 2026).
	f.exportBtn = Btn("KEYBLOCK_BTN_EXPORT", 22 + 4 * 210, function()
		ns.ShowKeyBlockExport()
	end)
	f.reloadBtn = Btn("KEYBLOCK_BTN_RELOAD", 22 + 5 * 210, function()
		ns.KeyBlockReloadAndReopen()
	end)
	f.reloadBtn:SetWidth(120)
	f.reloadBtn:Hide()

	-- Step-by-step guide (Rob, 5 Oct 2026, first look on his level-90 Hunter: "hele kleine letters … ik
	-- weet eigenlijk niet zo goed waar ik moet beginnen. Kan er een scherm komen die we aan of uit kunnen
	-- zetten met de stappen?"). A panel above the window in large type: each step, a tick once it is done,
	-- and a button that does exactly what the window's own button does.
	f.guideBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.guideBtn:SetSize(200, 20)
	f.guideBtn:SetPoint("TOPLEFT", 260, -16)
	f.guideBtn:SetScript("OnClick", function()
		ns.db = ns.db or {}
		ns.db.keyBlockGuideHidden = not ns.db.keyBlockGuideHidden
		Refresh(f)
	end)

	local g = CreateFrame("Frame", "MidnightHelperKeyBlockGuide", f, "BackdropTemplate")
	g:SetSize(760, 60)
	g:SetPoint("BOTTOM", f, "TOP", 0, 6)
	g:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	g:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
	g.title = g:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	g.title:SetPoint("TOPLEFT", 22, -18)
	g.rows = {}
	local function DoStep(which)
		if which == "place" then
			f.placeBtn:Click()
		elseif which == "layout" then
			f.layoutBtn:Click()
		elseif which == "pad" and ns.MH_PadKeysApply then
			ns.MH_PadKeysApply(true)
			Refresh(f)
		elseif which == "card" and ns.ShowPlayCardWindow then
			ns.ShowPlayCardWindow()
		elseif which == "sheet" then
			ns.ShowKeyBlockExport()
		end
	end
	for i = 1, 6 do
		local r = CreateFrame("Frame", nil, g)
		r:SetSize(716, 40)
		r:SetPoint("TOPLEFT", 22, -54 - (i - 1) * 44)
		r.mark = r:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
		r.mark:SetPoint("LEFT", 0, 0)
		r.mark:SetWidth(34)
		-- The tick as a real texture: a |T…|t escape in a 34-px font string was cut off and showed as
		-- "|TI…" on Rob's screen (5 Oct 2026).
		r.check = r:CreateTexture(nil, "OVERLAY")
		r.check:SetSize(26, 26)
		r.check:SetPoint("LEFT", 4, 0)
		r.check:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
		r.check:Hide()
		r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
		r.text:SetPoint("LEFT", 40, 0)
		r.text:SetPoint("RIGHT", -150, 0)
		r.text:SetJustifyH("LEFT")
		r.btn = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
		r.btn:SetSize(140, 26)
		r.btn:SetPoint("RIGHT", 0, 0)
		r.btn:SetScript("OnClick", function(self)
			DoStep(self.which)
		end)
		g.rows[i] = r
	end
	g:SetHeight(54 + 6 * 44 + 16)
	f.guide = g

	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	win = f
	return f
end

--- Fill the guide: what is done, what is next. The first step not done is the one to do now (gold).
local function UpdateGuide(f)
	local g = f.guide
	if not g then
		return
	end
	local hide = ns.db and ns.db.keyBlockGuideHidden
	f.guideBtn:SetText(ns:L(hide and "KEYBLOCK_GUIDE_SHOW" or "KEYBLOCK_GUIDE_HIDE"))
	g:SetShown(not hide)
	if hide then
		return
	end
	local placed = GetSnap() ~= nil
	-- Not `a and a()`: the `and` would keep only the first of the four results (lint [12]).
	local layoutOn, onPreset = false, false
	if ns.MH_EditModeKeyBlockState then
		local _, on, _, preset = ns.MH_EditModeKeyBlockState()
		layoutOn, onPreset = on, preset
	end
	local steps = {
		{ text = "KEYBLOCK_GUIDE_1", done = placed, which = "place", btn = "KEYBLOCK_GUIDE_DO" },
		-- Not done on a preset or a SHARED account layout, even when that layout is a block (Rob, 5 Oct 2026,
		-- on Warlockie and Reddish, both on his Paladin's "twelve retro": "als we vaker twelve retro tegen komen
		-- op een andere character dan moeten we dat zien te voorkomen!"). The step then offers a layout of this
		-- character's own, so nothing it changes reaches the others.
		{ text = onPreset and "KEYBLOCK_GUIDE_2_PRESET" or "KEYBLOCK_GUIDE_2", done = layoutOn and not onPreset, which = "layout",
			btn = "KEYBLOCK_GUIDE_DO" },
		{ text = "KEYBLOCK_GUIDE_3", which = "pad", btn = "KEYBLOCK_GUIDE_DO", optional = true },
		{ text = "KEYBLOCK_GUIDE_4", which = "card", btn = "KEYBLOCK_GUIDE_OPEN" },
		{ text = "KEYBLOCK_GUIDE_5", which = "sheet", btn = "KEYBLOCK_GUIDE_OPEN", optional = true },
		{ text = "KEYBLOCK_GUIDE_6" },
	}
	g.title:SetText(ns:L("KEYBLOCK_GUIDE_TITLE"))
	local current
	for i, s in ipairs(steps) do
		local r = g.rows[i]
		local isNext = not current and not s.done and not s.optional and s.which ~= nil
		if isNext then
			current = i
		end
		r.check:SetShown(s.done and true or false)
		if s.done then
			r.mark:SetText("")
		else
			r.mark:SetText(isNext and ("|cffffd100" .. i .. "|r") or ("|cff9d9d9d" .. i .. "|r"))
		end
		local col = s.done and "|cff9d9d9d" or (isNext and "|cffffffff" or "|cffd0d0d0")
		r.text:SetText(col .. ns:L(s.text) .. "|r")
		if s.which then
			r.btn.which = s.which
			r.btn:SetText(ns:L(s.btn))
			r.btn:Show()
			r.btn:SetEnabled(not s.done)
		else
			r.btn:Hide()
		end
	end
end

Refresh = function(f)
	local res, class = Build()
	local bars = ns.KeyBlockBars()
	-- Before placing: what "Place it" would do, per place. After placing, the picture is just the block.
	local placed = GetSnap()
	local planBy = {}
	if not placed then
		local rows = PlacePlan()
		for _, r in ipairs(rows or {}) do
			planBy[r.key] = r
		end
	end
	f.title:SetText(ns:L("KEYBLOCK_TITLE"))
	f.placeBtn:SetText(ns:L(GetSnap() and "KEYBLOCK_BTN_UPDATE" or "KEYBLOCK_BTN_PLACE"))
	f.modeBtn:SetText(ns:L("KEYBLOCK_MODE_FMT"):format(ns:L("KEYBLOCK_MODE_" .. ns.KeyBlockNewMode():upper())))
	local _, layoutOn, oldHidden, onPreset = ns.MH_EditModeKeyBlockState()
	f.layoutBtn:SetText(ns:L(onPreset and "KEYBLOCK_BTN_OWN_LAYOUT" or "KEYBLOCK_BTN_LAYOUT"))
	if layoutOn then
		f.oldBarsBtn:SetText(ns:L(oldHidden and "KEYBLOCK_BTN_OLDBARS_SHOW" or "KEYBLOCK_BTN_OLDBARS_HIDE"))
		f.oldBarsBtn:Show()
	else
		f.oldBarsBtn:Hide()
	end
	f.intro:SetText(res and ns:L("KEYBLOCK_INTRO") or ns:L("KEYBLOCK_NO_DATA"))
	for _, bar in ipairs(BLOCK) do
		f.bars[bar.id].head:SetText(ns:L("KEYBLOCK_BAR_FMT"):format(bar.id, bars[bar.id]))
		for n, slot in ipairs(bar.slots) do
			local b = f.slots[slot.key]
			local hit = res and res.occ[slot.key]
			local data = { key = slot.key, task = slot.task, fixed = slot.fixed }
			b.key:SetText(KeyLabel(slot.key))
			b.icon:SetTexture(nil)
			b.icon:SetDesaturated(false)
			b.icon:SetAlpha(1)
			local info = bar.own and BarInfo(bars[bar.id])
			if info then
				-- Block D shows what really stands on that button of your bar 4: it is yours, MH only binds.
				local actSlot = info.first + ButtonFor(n) - 1
				local tex = GetActionTexture and GetActionTexture(actSlot)
				local kind, id = Occupant(actSlot)
				b.icon:SetTexture(tex)
				b.task:SetText(kind and ((kind == "macro" and GetActionText(actSlot)) or OccupantName(kind, id))
					or ns:L(slot.task))
				b.task:SetTextColor(kind and 0.9 or 0.5, kind and 0.9 or 0.5, kind and 0.9 or 0.5)
				b:SetBackdropBorderColor(0.45, 0.35, 0.6, 1)
			elseif hit then
				local name, icon, shown = SpellView(hit.spell.id)
				data.spellID = shown
				b.icon:SetTexture(icon or 134400)
				b.task:SetText(name)
				b.task:SetTextColor(1, 1, 1)
				b:SetBackdropBorderColor(0.55, 0.45, 0.15, 1)
			elseif slot.fixed == "trinket" then
				local tex = GetInventoryItemTexture and GetInventoryItemTexture("player", 13)
				b.icon:SetTexture(tex)
				b.task:SetText(ns:L(slot.task))
				b.task:SetTextColor(0.85, 0.85, 0.85)
				b:SetBackdropBorderColor(0.35, 0.55, 0.45, 1)
			elseif slot.fixed then
				b.task:SetText(ns:L(slot.task))
				b.task:SetTextColor(0.85, 0.85, 0.85)
				b:SetBackdropBorderColor(0.35, 0.55, 0.45, 1)
			else
				b.task:SetText(ns:L(slot.task))
				b.task:SetTextColor(0.5, 0.5, 0.5)
				b:SetBackdropBorderColor(0.25, 0.27, 0.32, 1)
			end
			local r = planBy[slot.key]
			data.plan = r
			local col = r and (((r.action == "place" or r.action == "clear") and r.replaces and PLAN_BORDER.replace)
				or PLAN_BORDER[r.action])
			if col then
				b:SetBackdropBorderColor(col[1], col[2], col[3], 1)
			elseif r and (r.action == "keep" or r.action == "skip") then
				b:SetBackdropBorderColor(0.4, 0.4, 0.42, 1)
			end
			b.data = data
		end
	end
	-- Spells this character knows that MH has no role for. 5 Oct 2026, Carola's Balance Druid: Fury of
	-- Elune (in the Single-Button Assistant) had no place, and the window said "every spell MH knows has a
	-- place" -- true and useless, because MH did not know it. Same list as /mh binds (Spec 32 §1e).
	local unknownTxt = ""
	if res and ns.KeybindUnclassified then
		local okU, unknown = pcall(ns.KeybindUnclassified)
		if okU and type(unknown) == "table" and #unknown > 0 then
			unknownTxt = "  " .. ns:L("KEYBLOCK_UNKNOWN_FMT"):format(#unknown, table.concat(unknown, ", "))
		end
	end
	-- The unknown ones are in res.unplaced too (they go to block D), but the red line already names them.
	local names = {}
	for _, s in ipairs(res and res.unplaced or {}) do
		if not s.unknown then
			names[#names + 1] = (SpellView(s.id))
		end
	end
	if res and #names > 0 then
		f.unplaced:SetText(ns:L("KEYBLOCK_UNPLACED_FMT"):format(#names, table.concat(names, ", ")) .. unknownTxt)
	elseif res then
		f.unplaced:SetText((unknownTxt ~= "" and "" or ns:L("KEYBLOCK_UNPLACED_NONE")) .. unknownTxt)
	else
		f.unplaced:SetText("")
	end
	-- Say up front what "Place it" would do, so the button is never a surprise.
	local foot
	if placed then
		foot = ns:L("KEYBLOCK_PLACED_STATE")
	else
		foot = ns.KeyBlockPreview(true) .. "|n" .. ns:L("KEYBLOCK_LEGEND")
	end
	-- A hidden block bar means keys that press buttons nobody can see (Rob's Hunter, 5 Oct 2026). That
	-- warning was chat-only; it belongs where the player is looking.
	local hidden = {}
	for _, id in ipairs({ "D", "A", "B", "C" }) do
		if BarShown(bars[id]) == false then
			hidden[#hidden + 1] = tostring(bars[id])
		end
	end
	if #hidden > 0 then
		foot = "|cffff6060" .. ns:L("KEYBLOCK_BARS_HIDDEN_FMT"):format(table.concat(hidden, ", ")) .. "|r|n" .. foot
	end
	f.foot:SetText(foot)
	if f.UpdateLayoutUndo then
		f.UpdateLayoutUndo()
	end
	UpdateGuide(f)
end

function ns.ShowKeyBlock()
	local f = Ensure()
	-- Four blocks are wide: never wider than the screen.
	local w = f:GetWidth()
	local room = UIParent:GetWidth() * 0.96
	f:SetScale((w > room) and (room / w) or 1)
	f:ClearAllPoints()
	-- With the guide shown above it, the window sits low so both fit on the screen.
	if ns.db and ns.db.keyBlockGuideHidden then
		f:SetPoint("CENTER")
	else
		f:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 30)
	end
	Refresh(f)
	f:Show()
end

--- `/mh block why` — every place and why, in chat and in SavedVariables (Spec 30: a picture that
--- leaves a place empty must be able to say why).
--------------------------------------------------------------------------------
-- Cheat sheet for the website (5 Oct 2026, Rob: "iets wat ze kunnen uitprinten of op een ander scherm
-- zetten, zodat ze het kunnen leren" → route 1: a code to paste on midnighthelper.com).
--
-- 🔴 THE FORMAT IS A CONTRACT WITH THE WEBSITE, like MH-EXPORT (GearExport.lua):
--
--     MH-KEYBLOCK 1
--     char=<name>;class=<CLASSFILE>;specid=<id>;spec=<spec name>;bars=<D>,<A>,<B>,<C>
--     # block|key|task|kind|id|name
--     A|1|KEYBLOCK_T_MAIN|spell|19434|Aimed Shot
--
--   block  D A B C (picture order; D = the player's own, bar 4)
--   key    WoW binding notation: 1, SHIFT-1, CTRL-1, ALT-Q, F1 ...
--   task   the place's task as a locale KEY (KEYBLOCK_T_*), so the site can label it in any language
--   kind   spell | item | macro | empty
--   id     spell or item id (empty for a macro or an empty place)
--   name   as the client shows it; "|" becomes "/"
--
-- What a place holds: once the block is placed, what really stands on that button; before that, what
-- "Place it" would put there.
--------------------------------------------------------------------------------

function ns.BuildKeyBlockExport()
	local rows, res = PlacePlan()
	if not rows then
		return nil
	end
	local placed = GetSnap() ~= nil
	local taskBy = {}
	for _, bar in ipairs(BLOCK) do
		for _, slot in ipairs(bar.slots) do
			taskBy[slot.key] = slot.task
		end
	end
	local function clean(s)
		return (tostring(s or ""):gsub("[|\n]", "/"))
	end
	local specName = "?"
	if ns.GetSpecialization and ns.GetSpecializationInfo then
		local idx = ns.GetSpecialization()
		local ok, _, sname = pcall(ns.GetSpecializationInfo, idx)
		if ok and sname and (not ns.CanAccessText or ns.CanAccessText(sname)) then
			specName = sname
		end
	end
	local bars = ns.KeyBlockBars()
	local lines = {
		"MH-KEYBLOCK 1",
		("char=%s;class=%s;specid=%s;spec=%s;bars=%d,%d,%d,%d"):format(
			(tostring(UnitName and UnitName("player") or "?"):gsub("[;|=]", "")),
			tostring(res and res.class or (UnitClass and select(2, UnitClass("player"))) or "?"),
			tostring(res and res.specID or "?"), (specName:gsub("[;|=]", "")),
			bars.D, bars.A, bars.B, bars.C),
		"# block|key|task|kind|id|name",
	}
	for _, r in ipairs(rows) do
		local kind, id, name
		if placed or r.action == "own" then
			kind, id = Occupant(r.slot)
			if kind == "macro" then
				name, id = GetActionText(r.slot), nil
			elseif kind then
				name = OccupantName(kind, id)
			end
		elseif r.want then
			kind, id = r.want.kind, r.want.id
			name = OccupantName(kind, id)
		end
		if kind ~= "spell" and kind ~= "item" and kind ~= "macro" then
			kind, id, name = "empty", nil, nil
		end
		lines[#lines + 1] = ("%s|%s|%s|%s|%s|%s"):format(r.bar, r.key, taskBy[r.key] or "", kind,
			id and tostring(id) or "", clean(name))
	end
	return table.concat(lines, "\n")
end

--- `/mh block export` and the window's button: the code in the copy box everyone already knows.
function ns.ShowKeyBlockExport()
	local text = ns.BuildKeyBlockExport()
	if not text then
		print("|cffffcc00Midnight Helper:|r key block: no classified spells for this character.")
		return
	end
	if not ns.ShowShareCopyDialog then
		print(text)
		return
	end
	ns.ShowShareCopyDialog({
		id = "keyblockexport:" .. tostring(time and time() or 0),
		-- "|" is WoW's escape character in an edit box (GearExport.lua, 28 Sep 2026): written as "||".
		text = (text:gsub("|", "||")),
		titleKey = "KEYBLOCK_EXPORT_TITLE",
		hintKey = "KEYBLOCK_EXPORT_HINT",
		closeKey = "DELVE_SHARE_COPY_CLOSE",
		width = 560,
		height = 380,
	})
end

function ns.PrintKeyBlockTrace()
	local res, class = Build()
	local p = "|cffffcc00Midnight Helper:|r "
	if not res then
		print(p .. "key block: no classified spells for " .. tostring(class) .. ".")
		return
	end
	print(p .. ("key block, spec %s:"):format(tostring(res.specID)))
	local dump = { specID = res.specID, places = {}, unplaced = {} }
	for _, bar in ipairs(BLOCK) do
		for _, slot in ipairs(bar.slots) do
			local hit = res.occ[slot.key]
			local line
			if hit then
				line = ("%s %s = %s (%s) |cff9d9d9d[%s]|r"):format(bar.id, KeyLabel(slot.key), (SpellView(hit.spell.id)),
					tostring(hit.spell.id), hit.why)
			else
				line = ("%s %s = |cff9d9d9d%s|r"):format(bar.id, KeyLabel(slot.key), slot.fixed and ("fixed: " .. slot.fixed) or "free")
			end
			print("  " .. line)
			dump.places[#dump.places + 1] = { key = slot.key, id = hit and hit.spell.id, why = hit and hit.why or (slot.fixed or "free") }
		end
	end
	for _, s in ipairs(res.unplaced) do
		print(("  |cffff8080no room|r %s (%s) %s/%s"):format((SpellView(s.id)), tostring(s.id), tostring(s.role), tostring(s.category)))
		dump.unplaced[#dump.unplaced + 1] = { id = s.id, role = s.role, category = s.category }
	end
	if ns.db then
		ns.db.keyBlockProbe = dump
	end
	if ns.KeyBlockBar1Status then
		print("  " .. ns.KeyBlockBar1Status())
	end
end

--------------------------------------------------------------------------------
-- Bar 1 keys while the game swaps bar 1 (5 Oct 2026, Rob on a flying mount: the skyriding buttons on
-- bar 1 had no keys, because 1-5 now press the block). Checked by mh-research against Blizzard's 12.1.0
-- source: ActionButtonDown(id) presses whatever bar 1 shows (skyriding, vehicle, override, possess,
-- temporary shapeshift) and handles pet battles; a secure state handler may set override bindings in
-- combat (RestrictedFrames.lua: SetBinding -> SetOverrideBinding). [bonusbar:5] is skyriding; plain
-- [bonusbar] would also catch Cat Form and stealth, which must keep the block.
-- While one of those states is on, the digit keys of the block (1-5) press bar 1 buttons 1-5 in order;
-- afterwards the block is back. Override bindings are never saved, so nothing here touches the
-- player's binding file.
--------------------------------------------------------------------------------

local BAR1_DRIVER = "[petbattle][vehicleui][overridebar][possessbar][shapeshift][bonusbar:5] on; off"
local bar1 = CreateFrame("Frame", "MidnightHelperKeyBlockBar1", UIParent, "SecureHandlerStateTemplate")
bar1:SetAttribute("_onstate-mhbar1", [[
	self:ClearBindings()
	if newstate ~= "on" then return end
	for i = 1, (self:GetAttribute("n") or 0) do
		local k, c = self:GetAttribute("k" .. i), self:GetAttribute("c" .. i)
		if k and c then
			self:SetBinding(true, k, c)
		end
	end
]])
local bar1Armed, bar1Count, bar1Source = false, 0, "none"

--- Do the live bindings point a block key at a block bar? Also true on an alt that shares the account
--- binding set but never placed the block itself (red team / mh-research: arm on the bindings, not on
--- the snapshot).
local function BlockKeysLive()
	local bars = ns.KeyBlockBars()
	local info = BarInfo(bars.A)
	local cmd = GetBindingAction and GetBindingAction("1")
	return info and type(cmd) == "string" and cmd:find("^" .. info.prefix) ~= nil
end

function ns.KeyBlockArmBar1()
	if InCombatLockdown and InCombatLockdown() then
		return false -- attributes and drivers cannot change in combat; PLAYER_REGEN_ENABLED retries
	end
	local pairs_ = {}
	-- Always Blizzard's order: digit n presses bar 1 button n. Rob, 5 Oct 2026, skyriding on his Hunter:
	-- the buttons came out of order, because the first version gave each key back what it did BEFORE the
	-- block — and on his hunter that was an old layout where 2 pressed button 3 and 3 pressed button 4.
	-- Skyriding and vehicle buttons are numbered for 1, 2, 3 ..., so that is what the keys must do.
	if GetSnap() or BlockKeysLive() then
		bar1Source = "1-to-1"
		for _, bar in ipairs(BLOCK) do
			for _, slot in ipairs(bar.slots) do
				local d = tonumber(slot.key)
				if d and d >= 1 and d <= 9 then
					pairs_[#pairs_ + 1] = { slot.key, "ACTIONBUTTON" .. d }
				end
			end
		end
	else
		bar1Source = "none"
	end
	if #pairs_ == 0 then
		UnregisterStateDriver(bar1, "mhbar1")
		ClearOverrideBindings(bar1)
		bar1Armed, bar1Count = false, 0
		return true
	end
	for i, p in ipairs(pairs_) do
		bar1:SetAttribute("k" .. i, p[1])
		bar1:SetAttribute("c" .. i, p[2])
	end
	bar1:SetAttribute("n", #pairs_)
	RegisterStateDriver(bar1, "mhbar1", BAR1_DRIVER)
	bar1Armed, bar1Count = true, #pairs_
	return true
end

--- For /mh block why: armed or not, how many keys, from where, and the state right now.
function ns.KeyBlockBar1Status()
	local state = bar1:GetAttribute("state-mhbar1") or "?"
	if ns.db then
		ns.db.keyBlockBar1Probe = { armed = bar1Armed, keys = bar1Count, source = bar1Source, state = state }
	end
	return ("bar 1 keys during skyriding/vehicle/pet battle: %s, %d key(s) (%s), now %s"):format(
		bar1Armed and "armed" or "off", bar1Count, bar1Source, tostring(state))
end

--- "Reload now" from the key block: reload, and open the window again afterwards so the player can go on
--- with the next step. Rob, 5 Oct 2026, on Reddish: after step 2 he had to find the window again himself
--- ("met het tandwieltje rechtsboven") — "kunnen we hem automatisch opnieuw open laten doen?"
function ns.KeyBlockReloadAndReopen()
	ns.db = ns.db or {}
	ns.db.keyBlockReopen = true
	ReloadUI()
end

local bar1Events = CreateFrame("Frame")
bar1Events:RegisterEvent("PLAYER_ENTERING_WORLD")
bar1Events:RegisterEvent("PLAYER_REGEN_ENABLED")
bar1Events:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" and C_Timer and C_Timer.After then
		C_Timer.After(1, ns.KeyBlockArmBar1)
		if ns.db and ns.db.keyBlockReopen then
			ns.db.keyBlockReopen = nil
			C_Timer.After(2, function()
				if not (InCombatLockdown and InCombatLockdown()) and ns.ShowKeyBlock then
					ns.ShowKeyBlock()
				end
			end)
		end
	elseif event == "PLAYER_REGEN_ENABLED" and not bar1Armed then
		ns.KeyBlockArmBar1()
	end
end)
