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
	local unplaced = {}
	for _, s in ipairs(left) do
		if not try(s, OVERFLOW, "overflow (" .. Family(s) .. ")") then
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
-- The picture
--------------------------------------------------------------------------------

local SLOT, GAP = 66, 6
local win

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
	GameTooltip:Show()
end

local function MakeSlot(parent)
	local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
	b:SetSize(SLOT, SLOT)
	b:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
	b:SetBackdropColor(0.10, 0.11, 0.14, 0.95)
	b:SetBackdropBorderColor(0.30, 0.32, 0.38, 1)
	b.icon = b:CreateTexture(nil, "ARTWORK")
	b.icon:SetSize(34, 34)
	b.icon:SetPoint("TOP", 0, -5)
	b.key = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	b.key:SetPoint("TOPLEFT", 3, -3)
	b.key:SetTextColor(1, 0.82, 0)
	b.task = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.task:SetPoint("BOTTOMLEFT", 2, 3)
	b.task:SetPoint("BOTTOMRIGHT", -2, 3)
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

	local barW = 4 * SLOT + 3 * GAP
	f.bars, f.slots = {}, {}
	for i, bar in ipairs(BLOCK) do
		local col = CreateFrame("Frame", nil, f)
		col:SetSize(barW, 3 * SLOT + 2 * GAP + 18)
		col:SetPoint("TOPLEFT", 22 + (i - 1) * (barW + 22), -86)
		col.head = col:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		col.head:SetPoint("TOPLEFT", 0, 0)
		f.bars[bar.id] = col
		for n, slot in ipairs(bar.slots) do
			local b = MakeSlot(col)
			local r, c = math.floor((n - 1) / 4), (n - 1) % 4
			b:SetPoint("TOPLEFT", c * (SLOT + GAP), -18 - r * (SLOT + GAP))
			f.slots[slot.key] = b
		end
	end
	f:SetSize(22 * 2 + 3 * barW + 2 * 22, 86 + 3 * SLOT + 2 * GAP + 18 + 96)

	f.unplaced = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.unplaced:SetPoint("BOTTOMLEFT", 22, 44)
	f.unplaced:SetPoint("RIGHT", -22, 0)
	f.unplaced:SetJustifyH("LEFT")
	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.foot:SetPoint("BOTTOMLEFT", 22, 20)
	f.foot:SetPoint("RIGHT", -22, 0)
	f.foot:SetJustifyH("LEFT")

	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	win = f
	return f
end

local function Refresh(f)
	local res, class = Build()
	local bars = ns.KeyBlockBars()
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
	f.foot:SetText(ns:L("KEYBLOCK_FOOT"))
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
