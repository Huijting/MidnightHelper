local _, ns = ...

--[[
	ForeverReadyBoard.lua — WoW Forever: the group consumable board, like Midnight's Consumable Ready Check.

	Rob, 23 Nov 2026 (via sparring, literally): "voor morgen, een consumable venster voor de party in forever zoals in
	midnight" + "en de buffs natuurlijk". 24 Nov 2026 on the proposal: "Ja maak maar", and on "Bedoel je doe jouw advies
	(A)?": "ja". Option A, as Sparring 24-11 wrote it:
	  - one board, a row per group member (you + party1-4);
	  - YOUR things only: elixir/flask, food (Well Fed), something on your weapon, health potion, mana potion (mana users),
	    healthstone (only with a Warlock in the group). Green = on you / in your bags, amber = in your bags but not used,
	    red = not there, yellow question mark = MH cannot read it;
	  - then the class buffs for EVERY member (Arcane Intellect, Fortitude, Mark of the Wild, a Blessing): who misses it,
	    who can give it (tooltip). A column only shows when its class is in the group. Your own buff: click the cell to
	    cast it on that member (secure, out of combat only);
	  - other players' bags: NOT in A (that needs addon messages, option B, later). Their buffs come from their auras.
	  - opens at a ready check (switch: /mh readyboard auto on|off) and with /mh readyboard; /mh readycheck = what MH read
	    and why (the "a module that can stay silent needs a way to see that it did" rule, CLAUDE.md).
	Why a new file and not ConsumableReadyCheck/Board: those lean on retail items, specs and the MHCons comms, and are
	not in the Forever toc. The lessons are copied, not the code:
	  - secure buttons live on UIParent and are POSITIONED by screen coordinates, never parented to or anchored on the
	    board (ConsumableReadyBoard.lua PlaceSecure, ADDON_ACTION_FORBIDDEN 24 Aug 2026);
	  - they close WITH the board (state driver off + hidden), and in a fight that waits for the end (7 Oct 2026);
	  - nil = unreadable, never "missing" (ns.Aura rule). In a fight Forever refuses other members' auras (GEMETEN with
	    /mh partytest, NEXT_SESSION_ARCHIVE r.1522), so the board closes when a fight starts.
	Ids: buffs from ns.FOREVER_SPELL_IDS (wago DB2 wowf, measured); items from ns.FOREVER_CONSUMABLES
	(ForeverReadyBoardData.lua, measured by mh-research 24 Nov 2026); weapon items from ForeverBuffs.lua.
	NOT measured: anything in the game. Built and checked offline only.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local UNITS = { "player", "party1", "party2", "party3", "party4" }
local READY = "Interface\\RAIDFRAME\\ReadyCheck-Ready"
local NOTREADY = "Interface\\RAIDFRAME\\ReadyCheck-NotReady"
local WAITING = "Interface\\RAIDFRAME\\ReadyCheck-Waiting"
local QUESTION = 134400 -- INV_Misc_QuestionMark

local ROW_H, ICON, COL_STEP = 26, 22, 28
local HEADER_Y = -46 -- centre of the column icons
local ROW0_Y = HEADER_Y - 28
local NAME_X, NAME_W = 14, 104
local CONS_X0 = NAME_X + NAME_W + 14
local GAP = 14
local MIN_SCALE, MAX_SCALE = 0.5, 1.6

local MANA = { MAGE = true, PRIEST = true, WARLOCK = true, DRUID = true, PALADIN = true, SHAMAN = true, HUNTER = true }

-- Your own things. buff = it gives an aura (green when on you, amber when only in your bags).
local CONS = {
	{ key = "flask", label = "FCONS_COL_FLASK", buff = true },
	{ key = "food", label = "FCONS_COL_FOOD", buff = true },
	{ key = "weapon", label = "FCONS_COL_WEAPON" },
	{ key = "hpot", label = "FCONS_COL_HPOT" },
	{ key = "mpot", label = "FCONS_COL_MPOT", mana = true },
	{ key = "hs", label = "FCONS_COL_HS", warlock = true },
}

-- Class buffs for everyone. names = every spell that counts (bigger group versions too); cast = what YOUR click casts.
local BUFFS = {
	{ key = "int", giver = "MAGE", manaOnly = true, names = { "Arcane Intellect", "Arcane Brilliance" },
		cast = { "Arcane Intellect" } },
	{ key = "fort", giver = "PRIEST", names = { "Power Word: Fortitude", "Prayer of Fortitude" },
		cast = { "Power Word: Fortitude" } },
	{ key = "motw", giver = "DRUID", names = { "Mark of the Wild", "Gift of the Wild" }, cast = { "Mark of the Wild" } },
	-- Any blessing counts (players choose which one). Your click: the blessing you cast last (ForeverBuffs.lua remembers
	-- it as paladinBlessing), else the first one you know.
	{ key = "bless", giver = "PALADIN", label = "FCONS_COL_BLESS",
		names = { "Blessing of Might", "Blessing of Wisdom", "Blessing of Kings", "Greater Blessing of Might",
			"Greater Blessing of Wisdom", "Greater Blessing of Kings" },
		cast = { "Blessing of Might", "Blessing of Wisdom", "Blessing of Kings" }, lastKey = "paladinBlessing" },
}

local board
local lastRead -- what the last read of the group found (for a later look; the board reads fresh each time)
local securePending, secureWaiter

--------------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------------
local function Settings()
	if not ns.db then
		return {}
	end
	if type(ns.db.foreverReadyBoard) ~= "table" then
		ns.db.foreverReadyBoard = {}
	end
	return ns.db.foreverReadyBoard
end

local function AutoOn()
	return Settings().auto ~= false
end

local function InCombat()
	return InCombatLockdown and InCombatLockdown() or false
end

--------------------------------------------------------------------------------
-- Small readers (all pcall: a missing API must never break the board)
--------------------------------------------------------------------------------
local function Known(id)
	for _, fn in ipairs({ C_SpellBook and C_SpellBook.IsSpellKnown or false, IsPlayerSpell or false,
		IsSpellKnown or false }) do
		if fn then
			local ok, v = pcall(fn, id)
			if ok and v == true then
				return true
			end
		end
	end
	return false
end

local function Ids(name)
	return (ns.FOREVER_SPELL_IDS or {})[name] or {}
end

--- Highest rank you know of the first name in the list you know: id, english name.
local function BestOf(names)
	for _, name in ipairs(names) do
		local ids = Ids(name)
		for i = #ids, 1, -1 do
			if Known(ids[i]) then
				return ids[i], name
			end
		end
	end
	return nil
end

local function CastFor(def)
	if def.lastKey and ns.db and type(ns.db.foreverBuffLast) == "table" then
		local last = ns.db.foreverBuffLast[def.lastKey]
		if last then
			local id = BestOf({ last })
			if id then
				return id, last
			end
		end
	end
	return BestOf(def.cast)
end

local function SpellName(id)
	if id and C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" then
			return n
		end
	end
	return id and ("#" .. tostring(id)) or "?"
end

local function SpellIcon(id)
	if id and C_Spell and C_Spell.GetSpellTexture then
		local ok, t = pcall(C_Spell.GetSpellTexture, id)
		if ok and t then
			return t
		end
	end
	return QUESTION
end

local function ItemCount(id)
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return 0
	end
	local ok, n = pcall(fn, id)
	return (ok and tonumber(n)) or 0
end

local function ItemIcon(id)
	local info = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if id and info then
		local ok, _, _, _, _, icon = pcall(info, id)
		if ok and icon then
			return icon
		end
	end
	return QUESTION
end

local function ItemName(id)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and n then
			return n
		end
	end
	return "item #" .. tostring(id)
end

local function Level()
	return (UnitLevel and UnitLevel("player")) or 1
end

--- The data lists, never nil.
local function Data(key)
	local d = ns.FOREVER_CONSUMABLES or {}
	return d[key] or {}
end

--------------------------------------------------------------------------------
-- Reading
--------------------------------------------------------------------------------
--- Every helpful aura id on a unit, in one scan. @return set or nil, reason (nil = cannot read: never "missing")
local function UnitAuraSet(unit)
	if not UnitExists(unit) then
		return nil, "no unit"
	end
	if InCombat() then
		return nil, "in a fight: the game hides buffs"
	end
	if unit ~= "player" then
		if UnitIsConnected and not UnitIsConnected(unit) then
			return nil, "offline"
		end
		if UnitIsVisible and not UnitIsVisible(unit) then
			return nil, "too far away to see"
		end
	end
	if not (ns.Aura and ns.Aura.Trusted and ns.Aura.Trusted()) then
		return nil, "auras not readable here"
	end
	if not (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) then
		return nil, "no C_UnitAuras.GetAuraDataByIndex"
	end
	local set, secret = {}, false
	for i = 1, 80 do
		local ok, a = pcall(C_UnitAuras.GetAuraDataByIndex, unit, i, "HELPFUL")
		if not ok then
			return nil, "the game refused: " .. tostring(a)
		end
		if not a then
			break
		end
		local sid = a.spellId
		if sid == nil or (issecretvalue and issecretvalue(sid)) then
			secret = true
		else
			set[sid] = true
		end
	end
	return set, nil, secret
end

local function HasAnyIn(set, secret, names)
	for _, name in ipairs(names) do
		for _, id in ipairs(Ids(name)) do
			if set[id] then
				return true
			end
		end
	end
	-- A secret id could be ours: then unknown, not missing (the Beacon of Light rule, Auras.lua 5 Oct 2026).
	if secret then
		return nil
	end
	return false
end

--- Your carried items from a list ({ item = id, lvl = n } or plain ids): best usable one first. @return id, count, total
local function Carried(list)
	local best, bestN, total = nil, 0, 0
	local lvl = Level()
	for _, e in ipairs(list) do
		local id = type(e) == "table" and (e.item or e.id) or e
		local need = type(e) == "table" and e.lvl or 1
		local n = id and ItemCount(id) or 0
		if n > 0 and lvl >= (need or 1) then
			total = total + n
			if not best then
				best, bestN = id, n
			end
		end
	end
	return best, bestN, total
end

local function AuraIds(list)
	local out = {}
	for _, e in ipairs(list) do
		if type(e) == "table" and e.aura then
			out[#out + 1] = e.aura
		end
	end
	return out
end

local function SelfHasAnyAura(ids)
	if not ns.Aura or not ns.Aura.HasPlayerAura then
		return nil
	end
	local unknown = false
	for _, id in ipairs(ids) do
		local h = ns.Aura.HasPlayerAura(id)
		if h == true then
			return true, id
		elseif h == nil then
			unknown = true
		end
	end
	if unknown then
		return nil
	end
	return false
end

--- One cell for your own row. @return { status, icon, count, why, item, spell }
--- status: "on" green, "bag" amber, "none" red, nil = unreadable (yellow).
local function ReadOwn(key)
	if key == "flask" or key == "food" then
		local list, auras
		if key == "flask" then
			list, auras = Data("flask"), AuraIds(Data("flask"))
		else
			-- Food: every "Well Fed" plus the measured food buffs with another name; utility food (fishing, herbalism,
			-- speed) is no fight buff, so neither its aura nor its item counts (ForeverReadyBoardData.lua auras_util).
			local food = Data("food")
			list, auras = {}, {}
			for _, e in ipairs(food.items or {}) do
				if not e.util then
					list[#list + 1] = e
				end
			end
			for _, id in ipairs(food.auras or {}) do
				auras[#auras + 1] = id
			end
			for _, id in ipairs(food.auras_other or {}) do
				auras[#auras + 1] = id
			end
		end
		local id, n, total = Carried(list)
		if #auras == 0 then
			return { status = nil, icon = ItemIcon(id or (list[1] and (list[1].item or list[1]))), why = "no measured ids" }
		end
		local on, auraId = SelfHasAnyAura(auras)
		if on == true then
			return { status = "on", icon = SpellIcon(auraId), spell = auraId, why = "the buff is on you", count = total }
		end
		if id then
			return { status = "bag", icon = ItemIcon(id), item = id, count = total,
				why = (on == nil and "buff unreadable; " or "") .. ("in your bags: %s x%d"):format(ItemName(id), n) }
		end
		if on == nil then
			return { status = nil, icon = ItemIcon(list[1] and (list[1].item or list[1])), why = "buff unreadable" }
		end
		return { status = "none", icon = ItemIcon(list[1] and (list[1].item or list[1])), why = "not on you, none in bags" }
	end
	if key == "weapon" then
		local mh = GetInventoryItemID and GetInventoryItemID("player", 16)
		if not mh then
			return { hidden = true, why = "no weapon in your main hand" }
		end
		local has = ns.ForeverTempEnchant and ns.ForeverTempEnchant(0)
		local list = ns.FOREVER_WEAPON_ITEMS or {}
		local id, _, total = Carried(list)
		if has == true then
			return { status = "on", icon = ItemIcon(mh), why = "something is on your main-hand weapon", count = total }
		elseif has == nil then
			return { status = nil, icon = ItemIcon(mh), why = "cannot read your weapon buff" }
		end
		if id then
			return { status = "bag", icon = ItemIcon(id), item = id, count = total,
				why = "nothing on it; in your bags: " .. ItemName(id) }
		end
		return { status = "none", icon = ItemIcon(mh), why = "nothing on your weapon, no stone/oil in bags" }
	end
	-- hpot / mpot / hs: having them is being ready.
	local list = Data(key)
	local id, _, total = Carried(list)
	local first = list[1] and (list[1].item or list[1])
	if #list == 0 then
		return { status = nil, icon = QUESTION, why = "no measured ids" }
	end
	if id then
		return { status = "on", icon = ItemIcon(id), item = id, count = total, why = ("%d in your bags"):format(total) }
	end
	return { status = "none", icon = ItemIcon(first), item = first, why = "none in your bags" }
end

--- Who is in the group, and what MH can read. Everything the board and /mh readycheck show.
local function Read()
	local r = { rows = {}, givers = {}, consCols = {}, buffCols = {}, at = time and time() or 0, combat = InCombat() }
	for _, unit in ipairs(UNITS) do
		if UnitExists(unit) then
			local name = UnitName(unit)
			local _, cls = UnitClass(unit)
			local row = { unit = unit, name = name, class = cls, buffs = {} }
			row.auras, row.auraWhy, row.secret = UnitAuraSet(unit)
			r.rows[#r.rows + 1] = row
			if cls then
				r.givers[cls] = r.givers[cls] or {}
				table.insert(r.givers[cls], { name = name, class = cls })
			end
		end
	end
	local _, myClass = UnitClass("player")
	-- Your own columns.
	for _, c in ipairs(CONS) do
		local show = true
		if c.mana and not MANA[myClass or ""] then
			show = false
		end
		if c.warlock and not r.givers.WARLOCK then
			show = false
		end
		if show then
			local cell = ReadOwn(c.key)
			if not cell.hidden then
				r.consCols[#r.consCols + 1] = { def = c, cell = cell }
			end
		end
	end
	-- Buff columns: only a class that is in the group (you included).
	for _, b in ipairs(BUFFS) do
		if r.givers[b.giver] then
			local col = { def = b, cells = {} }
			if myClass == b.giver then
				col.castId, col.castName = CastFor(b)
			end
			local someIds = Ids(b.names[1])
			col.icon = SpellIcon(col.castId or someIds[#someIds])
			for i, row in ipairs(r.rows) do
				local cell = {}
				if b.manaOnly and row.class and not MANA[row.class] then
					cell.na = true
				elseif not row.auras then
					cell.status, cell.why = nil, row.auraWhy
				else
					local has = HasAnyIn(row.auras, row.secret, b.names)
					cell.status = (has == true and "on") or (has == false and "none") or nil
					cell.why = has == nil and "a buff with a hidden id: unknown" or (has and "has it" or "misses it")
				end
				col.cells[i] = cell
			end
			r.buffCols[#r.buffCols + 1] = col
		end
	end
	lastRead = r
	return r
end
ns.ForeverReadyBoardRead = Read -- the offline check calls it

--------------------------------------------------------------------------------
-- Secure click buttons (your own buff on a member). On UIParent, positioned by hand, out of combat only.
--------------------------------------------------------------------------------
local castBtns = {}
local DRIVER = "[combat] hide; nil"

local function PlaceSecure(btn)
	if not (btn and board) or InCombat() then
		return
	end
	-- Same as ConsumableReadyBoard.lua PlaceSecure: board and button are both children of UIParent with the same scale,
	-- so the board's own left/top plus the cell offset is the button's centre.
	local left, top = board:GetLeft(), board:GetTop()
	btn:ClearAllPoints()
	if left and top then
		btn:SetScale(board:GetScale() or 1)
		btn:SetPoint("CENTER", UIParent, "BOTTOMLEFT", left + (btn._dx or 0), top + (btn._dy or 0))
	else
		btn:SetPoint("CENTER", UIParent, "CENTER", 0, 400)
	end
end

local function SetSecureLive(on)
	if InCombat() then
		securePending = true
		if not secureWaiter then
			secureWaiter = CreateFrame("Frame")
			secureWaiter:SetScript("OnEvent", function(self)
				self:UnregisterEvent("PLAYER_REGEN_ENABLED")
				if securePending then
					securePending = nil
					SetSecureLive(board and board:IsShown() or false)
				end
			end)
		end
		secureWaiter:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	for _, b in ipairs(castBtns) do
		if on and b._live then
			RegisterStateDriver(b, "visibility", DRIVER)
		else
			UnregisterStateDriver(b, "visibility")
			b:Hide()
		end
	end
end

local function CastButton(i)
	if castBtns[i] then
		return castBtns[i]
	end
	local b = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")
	b:SetSize(ICON + 4, ICON + 4)
	b:RegisterForClicks("AnyUp", "AnyDown")
	b:EnableMouse(true)
	b:SetFrameStrata("DIALOG")
	b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	b:Hide()
	-- Scripts only for the tooltip (as ConsumableReadyBoard's cast button); the click itself is the secure template's.
	b:SetScript("OnEnter", function(self)
		if not GameTooltip then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if self._spellID then
			pcall(GameTooltip.SetSpellByID, GameTooltip, self._spellID)
		end
		if self._tip then
			self._tip()
		end
		GameTooltip:AddLine(ns:L("FCONS_CLICK_FMT"):format(SpellName(self._spellID), self._who or "?"), 0.6, 1, 0.6, true)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	castBtns[i] = b
	return b
end

--------------------------------------------------------------------------------
-- The board
--------------------------------------------------------------------------------
local function ClassColour(name, cls)
	local c = cls and RAID_CLASS_COLORS and RAID_CLASS_COLORS[cls]
	if c and c.colorStr then
		return "|c" .. c.colorStr .. (name or "?") .. "|r"
	end
	return name or "?"
end

local function SavePos(f)
	local s = Settings()
	local cx, cy = f:GetCenter()
	local sc = f:GetScale() or 1
	if cx and cy then
		s.x = cx * sc - UIParent:GetWidth() / 2
		s.y = cy * sc - UIParent:GetHeight() / 2
	end
end

local function ApplyPos(f)
	local s = Settings()
	local sc = f:GetScale() or 1
	f:ClearAllPoints()
	if tonumber(s.x) and tonumber(s.y) then
		f:SetPoint("CENTER", UIParent, "CENTER", s.x / sc, s.y / sc)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 160 / sc)
	end
end

local function NewCell(f)
	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetSize(ICON, ICON)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	local badge = f:CreateTexture(nil, "OVERLAY")
	badge:SetSize(11, 11)
	badge:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -4)
	local count = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	count:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT", -3, -2)
	local hit = CreateFrame("Frame", nil, f)
	hit:SetSize(ICON, ICON)
	hit:SetPoint("CENTER", icon, "CENTER")
	hit:EnableMouse(true)
	hit:SetScript("OnEnter", function(self)
		if self._tip and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			self._tip()
			GameTooltip:Show()
		end
	end)
	hit:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	local cell = { icon = icon, badge = badge, count = count, hit = hit }
	function cell:Hide()
		icon:Hide()
		badge:Hide()
		count:Hide()
		hit:Hide()
	end
	function cell:Place(x, y)
		icon:ClearAllPoints()
		icon:SetPoint("CENTER", f, "TOPLEFT", x, y)
	end
	function cell:Set(tex, status, n, tip)
		icon:SetTexture(tex or QUESTION)
		icon:SetDesaturated(status ~= "on" and status ~= "bag")
		icon:Show()
		badge:SetVertexColor(1, 1, 1)
		if status == "on" then
			badge:SetTexture(READY)
		elseif status == "bag" then
			badge:SetTexture(READY)
			badge:SetVertexColor(1, 0.82, 0.35)
		elseif status == "none" then
			badge:SetTexture(NOTREADY)
		else
			badge:SetTexture(WAITING)
		end
		badge:Show()
		if n and n > 1 then
			count:SetText(n)
			count:Show()
		else
			count:Hide()
		end
		hit._tip = tip
		hit:Show()
	end
	return cell
end

local cellPool = {}
local function Cell(f, i)
	if not cellPool[i] then
		cellPool[i] = NewCell(f)
	end
	return cellPool[i]
end

local STATUS_KEY = { on = "FCONS_ST_ON", bag = "FCONS_ST_BAG", none = "FCONS_ST_NONE" }

local function NamesLine(label, list, r, g, b)
	if #list > 0 then
		local t = {}
		for _, e in ipairs(list) do
			t[#t + 1] = ClassColour(e.name, e.class)
		end
		GameTooltip:AddLine(label .. " " .. table.concat(t, ", "), r, g, b, true)
	end
end

local function Render()
	local f = board
	if not f then
		return
	end
	local r = Read()
	for _, c in ipairs(cellPool) do
		c:Hide()
	end
	for _, fs in ipairs(f._names) do
		fs:Hide()
	end
	local n = 0
	-- Header icons + their tooltips.
	local x = CONS_X0
	local consX = {}
	for i, col in ipairs(r.consCols) do
		consX[i] = x
		n = n + 1
		local h = Cell(f, n)
		h:Place(x, HEADER_Y)
		local label = ns:L(col.def.label)
		h:Set(col.cell.icon, "on", nil, function()
			GameTooltip:AddLine(label, 1, 0.82, 0.2)
			GameTooltip:AddLine(ns:L("FCONS_SELF_ONLY"), 0.8, 0.8, 0.8, true)
		end)
		h.badge:Hide()
		h.icon:SetDesaturated(false)
		x = x + COL_STEP
	end
	x = x + GAP
	local buffX = {}
	for i, col in ipairs(r.buffCols) do
		buffX[i] = x
		n = n + 1
		local h = Cell(f, n)
		h:Place(x, HEADER_Y)
		local def, givers = col.def, r.givers[col.def.giver] or {}
		h:Set(col.icon, "on", nil, function()
			GameTooltip:AddLine(def.label and ns:L(def.label) or SpellName(Ids(def.names[1])[1]), 1, 0.82, 0.2)
			NamesLine(ns:L("FCONS_CAN_GIVE"), givers, 0.6, 1, 0.6)
		end)
		h.badge:Hide()
		h.icon:SetDesaturated(false)
		x = x + COL_STEP
	end
	local width = math.max(x + 10, 300)
	-- Rows.
	local myCast = {}
	for ri, row in ipairs(r.rows) do
		local y = ROW0_Y - (ri - 1) * ROW_H
		local fs = f._names[ri]
		fs:SetText(ClassColour(row.name, row.class))
		fs:ClearAllPoints()
		fs:SetPoint("LEFT", f, "TOPLEFT", NAME_X, y)
		fs:Show()
		if row.unit == "player" then
			for ci, col in ipairs(r.consCols) do
				n = n + 1
				local c = Cell(f, n)
				c:Place(consX[ci], y)
				local cell = col.cell
				local label = ns:L(col.def.label)
				c:Set(cell.icon, cell.status, cell.count, function()
					GameTooltip:AddLine(label, 1, 0.82, 0.2)
					if cell.item then
						GameTooltip:AddLine(ItemName(cell.item), 1, 1, 1)
					end
					GameTooltip:AddLine(ns:L(STATUS_KEY[cell.status] or "FCONS_ST_UNKNOWN"), 0.85, 0.85, 0.85, true)
				end)
			end
		elseif ri == 2 and #r.consCols > 0 then
			-- once, on the first other row: why their things are empty (option A).
			n = n + 1
			local c = Cell(f, n)
			c:Place(consX[1], y)
			c:Set(QUESTION, nil, nil, function()
				GameTooltip:AddLine(ns:L("FCONS_OTHERS_TITLE"), 1, 0.82, 0.2)
				GameTooltip:AddLine(ns:L("FCONS_OTHERS_BODY"), 0.85, 0.85, 0.85, true)
			end)
			c.badge:Hide()
		end
		for bi, col in ipairs(r.buffCols) do
			local cell = col.cells[ri]
			if cell and not cell.na then
				n = n + 1
				local c = Cell(f, n)
				c:Place(buffX[bi], y)
				local def = col.def
				local tip = function()
					GameTooltip:AddLine(def.label and ns:L(def.label) or SpellName(Ids(def.names[1])[1]), 1, 0.82, 0.2)
					GameTooltip:AddLine(ClassColour(row.name, row.class) .. ": "
						.. ns:L((cell.status == "on" and "FCONS_BUFF_HAS") or (cell.status == "none" and "FCONS_BUFF_MISSES")
							or "FCONS_BUFF_UNKNOWN"), 0.9, 0.9, 0.9, true)
					NamesLine(ns:L("FCONS_CAN_GIVE"), r.givers[def.giver] or {}, 0.6, 1, 0.6)
				end
				c:Set(col.icon, cell.status, nil, tip)
				if col.castId then
					myCast[#myCast + 1] = { x = buffX[bi], y = y, unit = row.unit, id = col.castId, who = row.name, tip = tip }
				end
			end
		end
	end
	local rowsH = #r.rows * ROW_H
	f:SetSize(width, -ROW0_Y + rowsH + 22)
	f._foot:SetText(ns:L(#r.rows <= 1 and "FCONS_FOOT_SOLO" or "FCONS_FOOT"))
	f._foot:SetWidth(width - 28)
	f._lastCast = myCast
	-- The click buttons: only out of combat (secure).
	if not InCombat() then
		for i, b in ipairs(castBtns) do
			if not myCast[i] then
				b._live = false
				UnregisterStateDriver(b, "visibility")
				b:Hide()
			end
		end
		for i, m in ipairs(myCast) do
			local b = CastButton(i)
			b._dx, b._dy = m.x, m.y
			b._spellID, b._who, b._tip = m.id, m.who, m.tip
			b:SetAttribute("type", "spell")
			b:SetAttribute("spell", m.id)
			b:SetAttribute("unit", m.unit)
			b._live = true
			PlaceSecure(b)
		end
		SetSecureLive(f:IsShown())
	end
end

local function Build()
	if board then
		return board
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverReadyBoard", UIParent, "BackdropTemplate")
	f:SetSize(320, 140)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		if not InCombat() then
			self:StartMoving()
		end
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePos(self)
		for _, b in ipairs(castBtns) do
			PlaceSecure(b)
		end
	end)
	if f.SetBackdrop then
		f:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", tile = true, tileSize = 32, edgeSize = 24,
			insets = { left = 8, right = 8, top = 8, bottom = 8 } })
	end
	local sc = tonumber(Settings().scale) or 1
	f:SetScale(math.min(MAX_SCALE, math.max(MIN_SCALE, sc)))
	ApplyPos(f)
	-- Own Shift+scroll (not the DialogPopup sweep: the click buttons have to follow the new size).
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(self, delta)
		if not IsShiftKeyDown() or InCombat() then
			return
		end
		local s = Settings()
		local new = math.min(MAX_SCALE, math.max(MIN_SCALE, (self:GetScale() or 1) + (delta > 0 and 0.1 or -0.1)))
		SavePos(self)
		s.scale = new
		self:SetScale(new)
		ApplyPos(self)
		for _, b in ipairs(castBtns) do
			PlaceSecure(b)
		end
	end)
	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -14)
	title:SetText(ns:L("FCONS_TITLE"))
	f.title = title
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
	close:SetScript("OnClick", function()
		f:Hide()
	end)
	f._names = {}
	for i = 1, #UNITS do
		local fs = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetWidth(NAME_W)
		fs:SetJustifyH("LEFT")
		fs:SetWordWrap(false)
		f._names[i] = fs
	end
	local foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	foot:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 10)
	foot:SetJustifyH("LEFT")
	f._foot = foot
	-- Live while shown: auras, bags, group.
	local ev = CreateFrame("Frame")
	local queued = false
	local function Queue()
		if queued or not f:IsShown() then
			return
		end
		queued = true
		C_Timer.After(0.3, function()
			queued = false
			if f:IsShown() and not InCombat() then
				Render()
			end
		end)
	end
	ev:SetScript("OnEvent", function(_, event, unit)
		if event == "UNIT_AURA" and unit and not (unit == "player" or unit:find("^party%d$")) then
			return
		end
		Queue()
	end)
	f:SetScript("OnShow", function()
		for _, e in ipairs({ "UNIT_AURA", "BAG_UPDATE_DELAYED", "GROUP_ROSTER_UPDATE", "UNIT_INVENTORY_CHANGED" }) do
			pcall(ev.RegisterEvent, ev, e)
		end
		Render()
	end)
	f:SetScript("OnHide", function()
		ev:UnregisterAllEvents()
		SetSecureLive(false)
	end)
	if ns.ForeverStyle and ns.ForeverStyle.SkinOnShow then
		ns.ForeverStyle.SkinOnShow(f)
	end
	f:Hide()
	board = f
	return f
end

--------------------------------------------------------------------------------
-- Opening and closing
--------------------------------------------------------------------------------
--- /mh readyboard (and the minimap/launchpad routes that already call this name): show or hide the board.
function ns.ShowConsumableBoard()
	if InCombat() then
		print(PREFIX .. ns:L("FCONS_COMBAT"))
		return
	end
	local f = Build()
	if f:IsShown() then
		f:Hide()
	else
		f:Show()
	end
end

local function AutoOpen()
	if not AutoOn() or InCombat() then
		return
	end
	local f = Build()
	if f:IsShown() then
		Render()
	else
		f:Show()
	end
end

local ev = CreateFrame("Frame")
pcall(ev.RegisterEvent, ev, "READY_CHECK")
pcall(ev.RegisterEvent, ev, "PLAYER_REGEN_DISABLED")
ev:SetScript("OnEvent", function(_, event)
	if event == "READY_CHECK" then
		AutoOpen()
	elseif event == "PLAYER_REGEN_DISABLED" then
		-- A fight starts: the game stops showing buffs, so the board would only show question marks. Close it (not
		-- secure, so allowed in combat; its click buttons hide through their state driver and are cleaned up after).
		if board and board:IsShown() then
			board:Hide()
		end
	end
end)

--------------------------------------------------------------------------------
-- /mh readycheck: what MH read and why. /mh readyboard auto on|off: open at a ready check.
--------------------------------------------------------------------------------
function ns.ForeverReadyBoardAuto(arg)
	if arg == "on" or arg == "off" then
		Settings().auto = (arg == "on")
	end
	print(PREFIX .. ns:L(AutoOn() and "FCONS_AUTO_ON" or "FCONS_AUTO_OFF"))
end

function ns.PrintConsumableReadyCheck()
	local r = Read()
	print(PREFIX .. ("group board (Forever): %d member(s), %s, auto at ready check %s, data %s"):format(#r.rows,
		r.combat and "IN A FIGHT (buffs hidden)" or "out of combat", AutoOn() and "on" or "off",
		ns.FOREVER_CONSUMABLES and "loaded" or "MISSING"))
	for _, col in ipairs(r.consCols) do
		local c = col.cell
		print(("  you, %s: %s — %s"):format(col.def.key, tostring(c.status or "unknown"), tostring(c.why)))
	end
	for _, c in ipairs(CONS) do
		local shown = false
		for _, col in ipairs(r.consCols) do
			if col.def == c then
				shown = true
			end
		end
		if not shown then
			print(("  you, %s: not shown (%s)"):format(c.key, c.mana and "you have no mana" or (c.warlock
				and "no Warlock in the group" or "nothing to show, e.g. no weapon")))
		end
	end
	for _, row in ipairs(r.rows) do
		print(("  %s (%s): buffs %s"):format(tostring(row.name), tostring(row.class),
			row.auras and ("readable" .. (row.secret and ", some ids hidden" or "")) or ("NOT readable: " .. tostring(row.auraWhy))))
	end
	for _, col in ipairs(r.buffCols) do
		local parts = {}
		for i, cell in ipairs(col.cells) do
			local row = r.rows[i]
			parts[#parts + 1] = tostring(row and row.name) .. "=" .. (cell.na and "n/a" or tostring(cell.status or "?"))
		end
		print(("  buff %s (giver %s)%s: %s"):format(col.def.key, col.def.giver,
			col.castId and (" — your click casts " .. SpellName(col.castId) .. " (" .. col.castId .. ")") or "",
			table.concat(parts, ", ")))
	end
	if #r.buffCols == 0 then
		print("  no buff columns: no Mage, Priest, Druid or Paladin in the group")
	end
	if type(ns.db) == "table" then
		local dump = { at = r.at, combat = r.combat, members = #r.rows, cons = {}, buffs = {} }
		for _, col in ipairs(r.consCols) do
			dump.cons[col.def.key] = { status = col.cell.status, why = col.cell.why, item = col.cell.item }
		end
		for _, col in ipairs(r.buffCols) do
			local cells = {}
			for i, cell in ipairs(col.cells) do
				cells[i] = cell.na and "n/a" or (cell.status or "?")
			end
			dump.buffs[col.def.key] = cells
		end
		ns.db.foreverReadyProbe = dump
	end
end
