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
local DEFAULT_BARS = { A = 5, B = 6, C = 7 }

function ns.KeyBlockBars()
	local saved = ns.db and ns.db.keyBlock and ns.db.keyBlock.bars
	return {
		A = (saved and saved.A) or DEFAULT_BARS.A,
		B = (saved and saved.B) or DEFAULT_BARS.B,
		C = (saved and saved.C) or DEFAULT_BARS.C,
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
	for _, s in ipairs(spells or {}) do
		list[#list + 1] = s
		s._done = nil
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
		return (mod == "SHIFT" and "Shift" or mod == "CTRL" and "Ctrl" or mod) .. " " .. base
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
	return { occ = occ, unplaced = unplaced, trace = trace, specID = specID, class = class }
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

local RESTORABLE = { spell = true, item = true }
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

local function OccupantName(kind, id)
	if kind == "spell" then
		return (SpellView(id))
	elseif kind == "item" and C_Item and C_Item.GetItemNameByID then
		return C_Item.GetItemNameByID(id) or ("item " .. tostring(id))
	elseif kind == "macro" and GetMacroInfo then
		local ok, n = pcall(GetMacroInfo, id)
		return (ok and n) or "macro"
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

--- What each fixed place should hold: { kind = "item", id = n } or nil plus a reason.
local function FixedWant(fixed)
	if fixed == "trinket" then
		local id = GetInventoryItemID and GetInventoryItemID("player", 13)
		if id then
			return { kind = "item", id = id }
		end
		return nil, "no trinket in your first trinket slot"
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
			if not want then
				row.action, row.why = "skip", why or "nothing for this place on this character"
			else
				local kind, id = Occupant(row.slot)
				if kind == want.kind and id == want.id then
					row.action = "keep"
				elseif kind == "spell" and want.kind == "spell" and C_SpellBook and C_SpellBook.FindSpellOverrideByID
					and id == select(2, pcall(C_SpellBook.FindSpellOverrideByID, want.id)) then
					row.action = "keep" -- the talent replacement of the same button
				elseif kind == nil then
					row.action = "place"
				elseif RESTORABLE[kind] then
					row.action = "place"
					row.replaces = { kind = kind, id = id, name = OccupantName(kind, id) }
				else
					row.action = "refuse"
					row.why = ("holds a %s (%s) that could not be put back"):format(tostring(kind), OccupantName(kind, id))
				end
			end
			rows[#rows + 1] = row
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
	local n = { place = 0, keep = 0, refuse = 0, skip = 0, replace = 0 }
	for _, r in ipairs(rows) do
		n[r.action] = n[r.action] + 1
		if r.action == "place" and r.replaces then
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
					r.replaces and (" |cffffcc00(replaces " .. r.replaces.name .. ")|r") or "")
			elseif r.action == "keep" then
				line = ("|cff9d9d9dalready there|r %s"):format(WantName(r.want))
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
	if ns.db.keyBlockSnapshot then
		print(p .. "the key block is already placed. |cffffffff/mh block undo|r first, then place again.")
		return false
	end
	local snap = { slots = {}, binds = {}, at = time and time() or nil }
	-- Snapshot everything we are about to touch, before touching anything.
	for _, r in ipairs(rows) do
		if r.action == "place" then
			local kind, id = Occupant(r.slot)
			snap.slots[#snap.slots + 1] = { slot = r.slot, kind = kind, id = id }
		end
		if r.action == "place" or r.action == "keep" then
			snap.binds[#snap.binds + 1] = { key = r.key, was = GetBindingAction and GetBindingAction(r.key) or "" }
		end
	end
	ns.db.keyBlockSnapshot = snap

	local placed, bound, failed = 0, 0, {}
	for _, r in ipairs(rows) do
		if r.action == "place" then
			local ok = pcall(function()
				ClearCursor()
				if r.want.kind == "spell" then
					if C_Spell and C_Spell.PickupSpell then
						C_Spell.PickupSpell(r.want.id)
					else
						PickupSpell(r.want.id)
					end
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
		if r.action == "place" or r.action == "keep" then
			if SetBinding(r.key, r.command) then
				bound = bound + 1
			end
		end
	end
	if SaveBindings and GetCurrentBindingSet then
		pcall(SaveBindings, GetCurrentBindingSet())
	end
	print(p .. ("key block placed: %d buttons, %d keys. |cffffffff/mh block undo|r puts everything back."):format(placed, bound))
	if #failed > 0 then
		print("   |cffff8080did not land:|r " .. table.concat(failed, ", "))
	end
	return true
end

function ns.KeyBlockUndo()
	local p = "|cffffcc00Midnight Helper:|r "
	local snap = ns.db and ns.db.keyBlockSnapshot
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
		local ok = pcall(function()
			ClearCursor()
			PickupAction(s.slot) -- lift ours off
			ClearCursor()
			if s.kind == "spell" and s.id then
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
	ns.db.keyBlockSnapshot = nil
	print(p .. ("key block undone: %d slots and %d keys back as they were."):format(restored, #(snap.binds or {})))
	return true
end

--------------------------------------------------------------------------------
-- The picture
--------------------------------------------------------------------------------

-- Rob, 5 Oct 2026 (screenshot): "Shift F1" ran through the icon and long names were cut. So the key
-- gets its own strip at the top, the icon sits under it, the name under that, and the place is wider.
local SLOT_W, SLOT_H, GAP = 84, 80, 6
local KEY_STRIP = 16
local win
local Refresh -- forward: the window's buttons redraw after placing or undoing

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
		if r.action == "place" and r.replaces then
			GameTooltip:AddLine(ns:L("KEYBLOCK_TIP_REPLACES_FMT"):format(r.replaces.name or "?"), 1, 0.6, 0.2, true)
		elseif r.action == "place" then
			GameTooltip:AddLine(ns:L("KEYBLOCK_TIP_PLACE"), 0.4, 0.9, 0.45, true)
		elseif r.action == "refuse" then
			GameTooltip:AddLine(ns:L("KEYBLOCK_TIP_REFUSE_FMT"):format(r.why or ""), 1, 0.35, 0.35, true)
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
	f:SetSize(22 * 2 + 3 * barW + 2 * 22, 86 + 3 * SLOT_H + 2 * GAP + 18 + 170)

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
	f.placeBtn = Btn("KEYBLOCK_BTN_PLACE", 22, function()
		if ns.KeyBlockPlace() then
			Refresh(f)
			f.foot:SetText(ns:L("KEYBLOCK_PLACED_DONE"))
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
		end
	end
	f.layoutBtn = Btn("KEYBLOCK_BTN_LAYOUT", 22 + 2 * 210, function()
		NeedReload(ns.MH_EditModeApplyKeyBlock())
	end)
	f.layoutUndoBtn = Btn("KEYBLOCK_BTN_LAYOUT_UNDO", 22 + 3 * 210, function()
		local ok = ns.MH_EditModeRestore and ns.MH_EditModeRestore()
		NeedReload(ok, ok and ns:L("KEYBLOCK_LAYOUT_RESTORED") or ns:L("KEYBLOCK_LAYOUT_NO_UNDO"))
	end)
	f.reloadBtn = Btn("KEYBLOCK_BTN_RELOAD", 22 + 4 * 210, function()
		ReloadUI()
	end)
	f.reloadBtn:SetWidth(120)
	f.reloadBtn:Hide()

	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	win = f
	return f
end

Refresh = function(f)
	local res, class = Build()
	local bars = ns.KeyBlockBars()
	-- Before placing: what "Place it" would do, per place. After placing, the picture is just the block.
	local placed = ns.db and ns.db.keyBlockSnapshot
	local planBy = {}
	if not placed then
		local rows = PlacePlan()
		for _, r in ipairs(rows or {}) do
			planBy[r.key] = r
		end
	end
	f.title:SetText(ns:L("KEYBLOCK_TITLE"))
	f.intro:SetText(res and ns:L("KEYBLOCK_INTRO") or ns:L("KEYBLOCK_NO_DATA"))
	for _, bar in ipairs(BLOCK) do
		f.bars[bar.id].head:SetText(ns:L("KEYBLOCK_BAR_FMT"):format(bar.id, bars[bar.id]))
		for _, slot in ipairs(bar.slots) do
			local b = f.slots[slot.key]
			local hit = res and res.occ[slot.key]
			local data = { key = slot.key, task = slot.task, fixed = slot.fixed }
			b.key:SetText(KeyLabel(slot.key))
			b.icon:SetTexture(nil)
			b.icon:SetDesaturated(false)
			b.icon:SetAlpha(1)
			if hit then
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
			local col = r and ((r.action == "place" and r.replaces and PLAN_BORDER.replace)
				or PLAN_BORDER[r.action])
			if col then
				b:SetBackdropBorderColor(col[1], col[2], col[3], 1)
			elseif r and (r.action == "keep" or r.action == "skip") then
				b:SetBackdropBorderColor(0.4, 0.4, 0.42, 1)
			end
			b.data = data
		end
	end
	if res and #res.unplaced > 0 then
		local names = {}
		for _, s in ipairs(res.unplaced) do
			names[#names + 1] = (SpellView(s.id))
		end
		f.unplaced:SetText(ns:L("KEYBLOCK_UNPLACED_FMT"):format(#names, table.concat(names, ", ")))
	elseif res then
		f.unplaced:SetText(ns:L("KEYBLOCK_UNPLACED_NONE"))
	else
		f.unplaced:SetText("")
	end
	-- Say up front what "Place it" would do, so the button is never a surprise.
	if placed then
		f.foot:SetText(ns:L("KEYBLOCK_PLACED_STATE"))
	else
		f.foot:SetText(ns.KeyBlockPreview(true) .. "|n" .. ns:L("KEYBLOCK_LEGEND"))
	end
end

function ns.ShowKeyBlock()
	local f = Ensure()
	f:ClearAllPoints()
	f:SetPoint("CENTER")
	Refresh(f)
	f:Show()
end

--- `/mh block why` — every place and why, in chat and in SavedVariables (Spec 30: a picture that
--- leaves a place empty must be able to say why).
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
end
