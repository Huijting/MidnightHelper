local _, ns = ...

--[[
	ForeverWeapons.lua — WoW Forever: "Weapon trainers". Which weapons your class may learn, which ones you know, and the
	weapon masters on your side that teach the one you pick, nearest first, with an arrow and the way there.
	Rob, 10 Nov 2026 (Night Elf Druid, level 10): "Waar leer ik mace gebruiken met mijn druid in darnasses?" → "dit is
	trouwens ook weer zoiets voor onze guide" → plan → "Ja, bouw maar".

	Data: docs/forever/FOREVER_WEAPON_MASTERS_2026-11-10.md (mh-research, 10 Nov 2026).
	  - Places: Wowhead Forever tooltip pins + Zygor Forever, agree within 0.5 (MEASURED). uiMapIds as ForeverVendorSpots.
	  - Who teaches what: Warcraft Tavern (Forever) + classic data + in-game gossip + Zygor agree (DERIVED; Wowhead Forever
	    has no "Teaches" tab). Disputed (Sayoc + Staves) is left out until measured.
	  - Which class may learn what: Forever client table SkillRaceClassInfo, build 1.60.1.70862 (MEASURED).
	  - Cost: 10 silver; Polearms 1 gold from level 20 (client MinLevel + a player report).
	MH measures the rest itself: opening one of these eight trainers saves what his window lists to
	MidnightHelperDB.foreverWeaponSeen (TRAINER_SHOW). /mh weapons check prints that and what MH thinks you know.
	"Known" = IsPlayerSpell(spell id of the weapon skill) — AFGELEID for Forever, the check shows it.
	/mh weapons [check] · tiles in the Me room and Tools → Single windows · a line on the start page.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- Weapon skills in list order. classes = class bits (Warrior 1, Paladin 2, Hunter 4, Rogue 8, Priest 16, Shaman 64,
-- Mage 128, Warlock 256, Druid 1024) from the Forever SkillRaceClassInfo rows. cost in copper.
local WEAPONS = {
	{ spell = 198, key = "mace", classes = 1115 }, -- One-Handed Maces
	{ spell = 199, key = "mace2", classes = 1091 }, -- Two-Handed Maces
	{ spell = 196, key = "axe", classes = 79 }, -- One-Handed Axes (Rogue: new in Forever)
	{ spell = 197, key = "axe2", classes = 71 }, -- Two-Handed Axes
	{ spell = 201, key = "sword", classes = 399 }, -- One-Handed Swords
	{ spell = 202, key = "sword2", classes = 7 }, -- Two-Handed Swords
	{ spell = 200, key = "polearm", classes = 1031, level = 20, cost = 10000 }, -- Polearms (Druid: new in Forever)
	{ spell = 227, key = "staff", classes = 1493 }, -- Staves
	{ spell = 1180, key = "dagger", classes = 1501 }, -- Daggers
	{ spell = 15590, key = "fist", classes = 1101 }, -- Fist Weapons
	{ spell = 264, key = "bow", classes = 13 }, -- Bows
	{ spell = 5011, key = "crossbow", classes = 13 }, -- Crossbows
	{ spell = 266, key = "gun", classes = 13 }, -- Guns
	{ spell = 2567, key = "thrown", classes = 13 }, -- Thrown
}
local DEFAULT_COST = 1000

-- city: route key (see Route below). x/y rounded from Zygor / Warcraft Tavern; Woo Ping on the Forever Stormwind map
-- (63.8,69.0; the 57,57 pins are the classic map).
local TRAINERS = {
	{ npc = 11867, name = "Woo Ping", side = "A", map = 1453, x = 63.8, y = 69.0, city = "SW",
		teaches = { 201, 202, 227, 1180, 5011, 200 } },
	{ npc = 11865, name = "Buliwyf Stonehand", side = "A", map = 1455, x = 61.2, y = 89.5, city = "IF",
		teaches = { 196, 197, 198, 199, 266, 15590 } },
	{ npc = 13084, name = "Bixi Wobblebonk", side = "A", map = 1455, x = 62.2, y = 89.6, city = "IF",
		teaches = { 1180, 2567, 5011 } },
	{ npc = 11866, name = "Ilyenia Moonfire", side = "A", map = 1457, x = 57.6, y = 46.7, city = "DARN",
		teaches = { 227, 264, 1180, 2567, 15590 } },
	-- Sayoc: Warcraft Tavern adds Staves (227); classic data and gossip say no → left out until measured.
	{ npc = 11868, name = "Sayoc", side = "H", map = 1454, x = 81.5, y = 19.6, city = "ORG",
		teaches = { 196, 197, 264, 1180, 2567, 15590 } },
	{ npc = 2704, name = "Hanashi", side = "H", map = 1454, x = 81.5, y = 19.6, city = "ORG",
		teaches = { 196, 197, 227, 264, 2567 } },
	{ npc = 11869, name = "Ansekhwa", side = "H", map = 1456, x = 40.9, y = 62.7, city = "TB",
		teaches = { 198, 199, 227, 266 } },
	{ npc = 11870, name = "Archibald", side = "H", map = 1458, x = 57.3, y = 32.8, city = "UC",
		teaches = { 201, 202, 1180, 5011, 200 } },
}
local TRAINER_BY_NPC = {}
for _, t in ipairs(TRAINERS) do
	TRAINER_BY_NPC[t.npc] = t
end

-- The continent each city is on (0 = Eastern Kingdoms, 1 = Kalimdor; the world-position "continent" C_Map returns).
local CITY_CONT = { SW = 0, IF = 0, UC = 0, DARN = 1, ORG = 1, TB = 1 }

--------------------------------------------------------------------------------
-- Helpers (same shape as ForeverVendors.lua)
--------------------------------------------------------------------------------
local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	if GetSpellInfo then
		local ok, n = pcall(GetSpellInfo, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return "spell " .. id
end

local function Known(id)
	for _, fn in ipairs({ _G.IsPlayerSpell, _G.IsSpellKnown }) do
		if fn then
			local ok, v = pcall(fn, id)
			if ok and v then
				return true
			end
		end
	end
	return false
end

local function Side()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" and "A") or (f == "Horde" and "H") or nil
end

local function ClassBit()
	local _, _, id = UnitClass("player")
	return id and (2 ^ (id - 1)) or 0
end

local function HasBit(mask, bit)
	return bit > 0 and math.floor(mask / bit) % 2 == 1
end

local function World(map, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(x / 100, y / 100))
	if not ok or not cont or not pos then
		return nil
	end
	local okXY, wx, wy = pcall(pos.GetXY, pos)
	if not okXY or not wx or (issecretvalue and (issecretvalue(wx) or issecretvalue(wy) or issecretvalue(cont))) then
		return nil
	end
	return cont, wx, wy
end

local function PlayerMap()
	return C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
end

local function PlayerWorld()
	local map = PlayerMap()
	if not map or not C_Map.GetPlayerMapPosition then
		return nil
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, map, "player")
	if not ok or not pos then
		return nil
	end
	local okXY, x, y = pcall(pos.GetXY, pos)
	if not okXY or not x or (issecretvalue and (issecretvalue(x) or issecretvalue(y))) then
		return nil
	end
	return World(map, x * 100, y * 100)
end

local function ZoneName(map)
	local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
	return info and info.name or ("map " .. tostring(map))
end

local function Distance(yards)
	if ns.ForeverTrainerDistance then
		return ns.ForeverTrainerDistance(yards)
	end
	return ("%d yd"):format(math.floor(yards + 0.5))
end

local function Money(c)
	if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
		local ok, s = pcall(C_CurrencyInfo.GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	return GetCoinTextureString and GetCoinTextureString(c) or (tostring(c) .. "c")
end

local function Teaches(t, spell)
	for _, s in ipairs(t.teaches) do
		if s == spell then
			return true
		end
	end
	return false
end

--- The weapons your class may learn, in list order. Each: { w = row, known = bool, name = client name }.
local function MyWeapons()
	local bit, out = ClassBit(), {}
	for _, w in ipairs(WEAPONS) do
		if HasBit(w.classes, bit) then
			out[#out + 1] = { w = w, known = Known(w.spell), name = SpellName(w.spell) }
		end
	end
	return out
end

--- The weapon keys you could learn right now (level reached, not known yet, a trainer on your side teaches it).
--- 12 Nov 2026: a list, so "Do this now" can say how many fit your direction.
function ns.ForeverWeaponsLearnable()
	local side, lvl, out = Side(), UnitLevel and UnitLevel("player") or 1, {}
	for _, e in ipairs(MyWeapons()) do
		if not e.known and lvl >= (e.w.level or 1) then
			for _, t in ipairs(TRAINERS) do
				if t.side == side and Teaches(t, e.w.spell) then
					out[#out + 1] = e.w.key
					break
				end
			end
		end
	end
	return out
end

--- How many weapons you could learn right now (the start page uses this).
function ns.ForeverWeaponsLearnableCount()
	return #ns.ForeverWeaponsLearnable()
end

--- The way to a trainer's city when you are not there yet, or nil. sameCont: you are on the city's continent.
local function Route(t, pcont)
	local here = PlayerMap()
	if here == t.map then
		return nil
	end
	-- 10 Nov 2026: from where YOU stand (ForeverTravel.lua). The fixed texts below assumed a start in your own capital.
	if ns.ForeverTravelSentence then
		local ok, s, walk = pcall(ns.ForeverTravelSentence, t.map, t.x, t.y)
		if ok and s then
			return s
		elseif ok and walk then
			return nil -- you can walk there: no route line
		end
	end
	local far = pcont ~= nil and CITY_CONT[t.city] ~= pcont
	if pcont == nil then
		far = true -- position unreadable: the long way is the safe one to show
	end
	local key = "FWEAP_ROUTE_" .. t.city .. (far and "_FAR" or "_NEAR")
	local s = ns:L(key)
	if s == key or s == "" then
		return nil -- a near route that needs no words (e.g. inside Undercity's own zone)
	end
	return s
end

--- The trainers on your side that teach a weapon, nearest first. Each: { t = row, dist = yards or nil }.
local function List(spell)
	local side = Side()
	local pc, px, py = PlayerWorld()
	local out = {}
	for _, t in ipairs(TRAINERS) do
		if t.side == side and Teaches(t, spell) then
			local tc, tx, ty = World(t.map, t.x, t.y)
			local dist
			if pc and tc and pc == tc then
				dist = math.sqrt((tx - px) ^ 2 + (ty - py) ^ 2)
			end
			out[#out + 1] = { t = t, dist = dist }
		end
	end
	table.sort(out, function(a, b)
		if a.dist and b.dist then
			return a.dist < b.dist
		end
		if a.dist or b.dist then
			return a.dist ~= nil
		end
		return a.t.name < b.t.name
	end)
	return out, pc
end

local function GoTo(e, what)
	local t = e.t
	-- A place we saw this weapon master from beats the rounded list value (ForeverSeenPlaces.lua, Rob 11 Nov 2026).
	local tx, ty = t.x, t.y
	if ns.ForeverPlaceFix then
		tx, ty = ns.ForeverPlaceFix(t.npc, t.map, t.x, t.y)
	end
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(t.map, tx, ty)) then
		print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		return false
	end
	ns.lastTarget = { mapID = t.map, x = tx, y = ty, name = t.name .. (what and (" (" .. what .. ")") or ""),
		via = "/mh weapons", arriveYards = 5, weaponNpc = t.npc, nearKey = "FARROW_NEAR_NPC", nearYards = 20 }
	ns._mhRouteOwner = "waypoint"
	if ns.ForeverTrainerMark then
		pcall(ns.ForeverTrainerMark, { npc = t.npc, name = t.name })
	end
	print(PREFIX .. ns:L("FVEND_ARROW_SET_FMT"):format(t.name, ZoneName(t.map),
		e.dist and Distance(e.dist) or ns:L("FVEND_OTHER_CONT")))
	return true
end

--------------------------------------------------------------------------------
-- Window (same look as "Where do I buy this?"; Shift+scroll and Escape via RegisterMidnightDialogPopup)
--------------------------------------------------------------------------------
local W, H, LEFT_W, BTN_STEP = 700, 500, 200, 27
local win, selected, Fill

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverWeapons", UIParent, "BackdropTemplate")
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
	f.wBtns = {}
	for i = 1, #WEAPONS do
		local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		b:SetSize(LEFT_W, 24)
		b:SetPoint("TOPLEFT", 20, -50 - (i - 1) * BTN_STEP)
		b:SetScript("OnClick", function(self)
			selected = self.spell
			Fill()
		end)
		f.wBtns[i] = b
	end
	local rx = 20 + LEFT_W + 16
	f.head = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.head:SetPoint("TOPLEFT", rx, -52)
	f.head:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.head:SetJustifyH("LEFT")
	f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.sub:SetPoint("TOPLEFT", f.head, "BOTTOMLEFT", 0, -4)
	f.sub:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.sub:SetJustifyH("LEFT")
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", rx, -104)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -40, 64)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(W - rx - 44, 10)
	scroll:SetScrollChild(child)
	f.scroll, f.child, f.rows = scroll, child, {}
	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.hint:SetPoint("BOTTOMLEFT", 22, 18)
	f.hint:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.hint:SetJustifyH("LEFT")
	-- 12 Nov 2026: what your chosen direction pairs with (ForeverDirection.lua), above the hint.
	f.dir = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.dir:SetPoint("BOTTOMLEFT", f.hint, "TOPLEFT", 0, 6)
	f.dir:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.dir:SetJustifyH("LEFT")
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
	r:SetWidth(f.child:GetWidth())
	r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.name:SetPoint("TOPLEFT", 4, -2)
	r.name:SetPoint("RIGHT", r, "RIGHT", -84, 0)
	r.name:SetJustifyH("LEFT")
	r.name:SetWordWrap(false)
	r.info = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.info:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -2)
	r.info:SetPoint("RIGHT", r, "RIGHT", -84, 0)
	r.info:SetJustifyH("LEFT")
	r.info:SetWordWrap(false)
	r.route = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	r.route:SetPoint("TOPLEFT", r.info, "BOTTOMLEFT", 0, -3)
	r.route:SetPoint("RIGHT", r, "RIGHT", -4, 0)
	r.route:SetJustifyH("LEFT")
	r.route:SetWordWrap(true)
	r.go = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
	r.go:SetSize(76, 22)
	r.go:SetPoint("TOPRIGHT", r, "TOPRIGHT", -2, -4)
	r.go:SetScript("OnClick", function(self)
		if self.entry then
			GoTo(self.entry, self.what)
		end
	end)
	f.rows[i] = r
	return r
end

Fill = function()
	local f = Build()
	f.title:SetText(ns:L("FWEAP_TITLE"))
	local mine = MyWeapons()
	local lvl = UnitLevel and UnitLevel("player") or 1
	-- Default pick: the first weapon you do not know yet (else the first one).
	local found = false
	for _, e in ipairs(mine) do
		if e.w.spell == selected then
			found = true
		end
	end
	if not found then
		selected = nil
		for _, e in ipairs(mine) do
			if not e.known then
				selected = e.w.spell
				break
			end
		end
		selected = selected or (mine[1] and mine[1].w.spell)
	end
	local cur
	-- 12 Nov 2026 (Rob via sparring: "1 en 2, de wapens er meteen bij"): mark what fits your chosen direction. Only a
	-- mark: nothing is hidden, the player chooses (the fit itself comes from player guides, ForeverDirection.lua).
	local band, tree, fit, shieldName
	if ns.ForeverDirectionWeaponFit then
		band, tree, fit, shieldName = ns.ForeverDirectionWeaponFit()
	end
	for i, b in ipairs(f.wBtns) do
		local e = mine[i]
		if e then
			b.spell = e.w.spell
			local label = e.name
			if e.known then
				label = "|cff9d9d9d" .. label .. "  " .. ns:L("FWEAP_KNOWN_TAG") .. "|r"
			elseif lvl < (e.w.level or 1) then
				label = "|cff9d9d9d" .. label .. "  " .. ns:L("FWEAP_LEVEL_TAG_FMT"):format(e.w.level) .. "|r"
			end
			if fit and fit[e.w.key] then
				label = "|cff40ff40+|r " .. label
			end
			b:SetText(label)
			b:Show()
			if e.w.spell == selected then
				b:LockHighlight()
				cur = e
			else
				b:UnlockHighlight()
			end
		else
			b:Hide()
		end
	end
	if not band then
		f.dir:SetText("")
	elseif fit then
		local names = {}
		for _, e in ipairs(mine) do
			if fit[e.w.key] then
				names[#names + 1] = e.name
			end
		end
		if shieldName then
			names[#names + 1] = shieldName
		end
		f.dir:SetText(ns:L("FWEAP_DIR_FIT_FMT"):format(tree, table.concat(names, ", ")))
	else
		f.dir:SetText(ns:L("FWEAP_DIR_NONE_FMT"):format(tree))
	end
	if not cur then
		f.head:SetText(ns:L("FWEAP_NONE"))
		f.sub:SetText("")
		for _, r in ipairs(f.rows) do
			r:Hide()
		end
		f.hint:SetText(ns:L("FWEAP_HINT"))
		return f
	end
	local list, pcont = List(cur.w.spell)
	f.head:SetText(ns:L("FWEAP_COUNT_FMT"):format(cur.name, #list))
	local cost = Money(cur.w.cost or DEFAULT_COST)
	local sub
	if cur.known then
		sub = ns:L("FWEAP_SUB_KNOWN")
	elseif cur.w.level and lvl < cur.w.level then
		sub = ns:L("FWEAP_SUB_LEVEL_FMT"):format(cur.w.level, cost)
	else
		sub = ns:L("FWEAP_SUB_LEARN_FMT"):format(cost)
	end
	if pcont == nil then
		sub = sub .. "  " .. ns:L("FVEND_NOPOS")
	end
	if #list == 0 then
		sub = sub .. "  " .. ns:L("FWEAP_EMPTY")
	end
	f.sub:SetText(sub)
	local y = 0
	for i, e in ipairs(list) do
		local r = Row(f, i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, y)
		r.name:SetText(e.t.name)
		r.info:SetText(ZoneName(e.t.map) .. " · " .. (e.dist and Distance(e.dist) or ns:L("FVEND_OTHER_CONT")))
		local route = Route(e.t, pcont)
		r.route:SetText(route and (ns:L("FWEAP_ROUTE_LABEL") .. " " .. route) or "")
		local h = 38 + (route and (r.route:GetStringHeight() + 4) or 0)
		r:SetHeight(h)
		r.go:SetText(ns:L("FVEND_ARROW"))
		r.go.entry, r.go.what = e, cur.name
		r:Show()
		y = y - h - 6
	end
	for i = #list + 1, #f.rows do
		f.rows[i]:Hide()
	end
	f.child:SetHeight(math.max(10, -y))
	f.scroll:SetVerticalScroll(0)
	f.hint:SetText(ns:L("FWEAP_HINT"))
	return f
end

--- A new direction was chosen (ForeverDirection.lua): redraw when open.
function ns.ForeverWeaponsRefresh()
	if win and win:IsShown() then
		Fill()
	end
end

function ns.ShowForeverWeapons()
	local f = Build()
	if f:IsShown() then
		f:Hide()
	else
		f:Show()
	end
end

--------------------------------------------------------------------------------
-- Measuring: what a weapon master's own window lists (the teach lists above are DERIVED)
--------------------------------------------------------------------------------
local lastSeen = "no weapon master opened yet this session"

local function NpcId()
	local guid = UnitGUID and UnitGUID("npc")
	if type(guid) ~= "string" or (issecretvalue and issecretvalue(guid)) then
		return nil
	end
	return tonumber(guid:match("^Creature%-[^%-]+%-[^%-]+%-[^%-]+%-[^%-]+%-(%d+)"))
end

local function RecordTrainer(npc)
	local t = TRAINER_BY_NPC[npc]
	if not (t and ns.db and GetNumTrainerServices and GetTrainerServiceInfo) then
		return
	end
	local okN, n = pcall(GetNumTrainerServices)
	n = okN and tonumber(n) or 0
	local rows = {}
	for i = 1, n do
		local ok, name, s1, s2 = pcall(GetTrainerServiceInfo, i)
		if ok and type(name) == "string" and name ~= "" then
			rows[#rows + 1] = name .. " = " .. tostring(s1) .. (s2 ~= nil and ("/" .. tostring(s2)) or "")
		end
	end
	-- The window's own filters can hide rows (TalentsForeverBook, 9 Nov changelog: "filters stay the way you set them").
	local filters = {}
	if GetTrainerServiceTypeFilter then
		for _, k in ipairs({ "available", "unavailable", "used" }) do
			local ok, v = pcall(GetTrainerServiceTypeFilter, k)
			filters[#filters + 1] = k .. "=" .. (ok and tostring(v) or "?")
		end
	end
	ns.db.foreverWeaponSeen = ns.db.foreverWeaponSeen or {}
	ns.db.foreverWeaponSeen[npc] = { name = t.name, at = date("%Y-%m-%d %H:%M"), rows = rows,
		filters = table.concat(filters, " "), level = UnitLevel("player"), class = select(2, UnitClass("player")) }
	lastSeen = ("%s: %d rows saved (filters %s)"):format(t.name, #rows, #filters > 0 and table.concat(filters, " ") or "?")
end

--------------------------------------------------------------------------------
-- /mh weapons
--------------------------------------------------------------------------------
function ns.ForeverWeaponsSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" then
		local _, _, classId = UnitClass("player")
		print(PREFIX .. ("weapons: class %s (bit %d), side %s, level %d, %d weapon masters in the data"):format(
			tostring(classId), ClassBit(), tostring(Side()), UnitLevel("player") or 0, #TRAINERS))
		local test = {}
		for _, name in ipairs({ "IsPlayerSpell", "IsSpellKnown" }) do
			test[#test + 1] = name .. (_G[name] and " yes" or " MISSING")
		end
		print("  known via: " .. table.concat(test, ", "))
		for _, e in ipairs(MyWeapons()) do
			local list = List(e.w.spell)
			print(("  %s (%d): %s; %d trainer(s) on your side%s"):format(e.name, e.w.spell,
				e.known and "KNOWN" or "not known", #list, list[1] and (", nearest " .. list[1].t.name) or ""))
		end
		local seen = ns.db and ns.db.foreverWeaponSeen
		local n = 0
		for npc, s in pairs(seen or {}) do
			n = n + 1
			print(("  measured %s (%d) on %s: %d rows"):format(s.name or "?", npc, s.at or "?", #(s.rows or {})))
		end
		print("  trainer windows measured: " .. n .. " · this session: " .. lastSeen)
		return
	end
	ns.ShowForeverWeapons()
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------
local ev = CreateFrame("Frame")
ev:RegisterEvent("TRAINER_SHOW")
ev:RegisterEvent("SPELLS_CHANGED")
ev:SetScript("OnEvent", function(_, event)
	if event == "TRAINER_SHOW" then
		local npc = NpcId()
		if npc and TRAINER_BY_NPC[npc] then
			-- The list fills a moment after the window opens.
			C_Timer.After(0.5, function()
				RecordTrainer(npc)
			end)
			local lt = ns.lastTarget
			if lt and lt.via == "/mh weapons" and ns._mhRouteOwner == "waypoint" and lt.weaponNpc == npc then
				ns._mhRouteOwner = nil -- you found him: NativeArrow tears the route down
			end
		end
	elseif event == "SPELLS_CHANGED" then
		if win and win:IsShown() then
			Fill() -- a weapon just learned turns grey
		end
	end
end)
