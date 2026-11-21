local _, ns = ...

--[[
	ForeverVendors.lua — WoW Forever: "Where do I buy this?" Profession tools and General Goods / Trade Supplies, with
	the vendors on your side, nearest first, and an Arrow button per vendor.
	Rob, 9 Nov 2026: learned Fishing, needed a pole, could not find General Goods ("die moeten we ook vindbaar maken in
	Midnight Helper") → plan (list + arrow + a tip right after learning a profession without its tool) → "Yeah, je mag zo
	beginnen" → "Gaan we door zolang je kan".

	Data: ForeverVendorSpots.lua (Wowhead Forever, 9 Nov 2026). Rows with unsure = true or without a point are left out.
	The arrow is the same Blizzard waypoint + NativeArrow as the trainer arrow; it ends 5 yd from the vendor, or when you
	open THAT vendor's shop (MERCHANT_SHOW with the same npc id). Another shop on the way leaves it alone (the lesson of
	the trainer arrow, same day).
	Tip: when this character learns Fishing, Mining, Skinning or Blacksmithing and carries no tool for it, a small window
	names the nearest seller with a "Show the way" button. Once per profession per character; professions you already
	had when MH loaded are never announced.
	/mh vendor [fishing|mining|skinning|hammer|tinder|thief|general|trade] opens the list; /mh vendor check prints what MH
	knows (a module that can stay quiet needs that, CLAUDE.md).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- Categories in list order. item = the tool id in ForeverVendorSpots' `items`; kind = goods kind. `have` = items that
-- count as "you already have one" for the tip (better versions too; ids from ForeverToolGuard.lua / the vendor report).
local CATS = {
	{ key = "fishing", item = 6256, prof = "FISHING", have = { 6256, 6365, 6366, 6367, 12225, 19022, 19970 } },
	{ key = "strongpole", item = 6365 },
	{ key = "mining", item = 2901, prof = "MINING", have = { 2901, 6206, 259229, 260811 } },
	{ key = "skinning", item = 7005, prof = "SKINNING", have = { 7005, 269716, 260811 } },
	{ key = "hammer", item = 5956, prof = "BLACKSMITHING", have = { 5956, 285280, 285281, 260811 } },
	{ key = "tinder", item = 4471 },
	{ key = "thief", item = 5060 },
	{ key = "general", kind = "general", label = "FVEND_CAT_GENERAL" },
	{ key = "trade", kind = "trade", label = "FVEND_CAT_TRADE" },
	-- 17 Nov 2026 (Rob: "Straks zocht ik de bank en de AH in grootsteden. … Kunnen we dat nog erin krijgen?", and on
	-- mailbox + inn: "ja doe maar"): city services, data in ForeverCitySpots.lua. svc = the row kind there.
	{ key = "bank", svc = "bank", label = "FCITY_CAT_BANK" },
	{ key = "auction", svc = "auction", label = "FCITY_CAT_AUCTION" },
	{ key = "mail", svc = "mail", label = "FCITY_CAT_MAIL" },
	{ key = "inn", svc = "inn", label = "FCITY_CAT_INN" },
	-- 20 Nov 2026 (Rob: "… waarbij ik mijn spullen kan repareren en zeker verkopen?" → "ja doe maar"): vendors who repair
	-- (every vendor buys). Data: ForeverRepairData.lua (Zygor Forever + Wowhead Forever) plus what MH learns at every
	-- vendor window (CanMerchantRepair), see RepairSpots below.
	{ key = "repair", svc = "repair", label = "FCITY_CAT_REPAIR" },
	-- 21 Nov 2026 (Rob on Waylaid Crates: "Ja doe maar"): where you deliver a sealed crate or a Shipping Label — your
	-- side's trade representative (ForeverCrates.lua ns.FOREVER_CRATE_SPOTS). item = the empty crate, for its tooltip.
	{ key = "crates", svc = "crates", item = 248549, label = "FCITY_CAT_CRATES" },
	-- 21 Nov 2026 (Rob: "Ja, graag"): the library where a mage can cast Study (ForeverProfGuide.lua FOREVER_LIBRARY_SPOTS).
	{ key = "library", svc = "library", mage = true, label = "FCITY_CAT_LIBRARY" },
	-- 18 Nov 2026 (Rob: "ik ben nu op zoek naar de zeppelins in ogrimar … net zoals flight masters … HELP !!!" → "ja"):
	-- travel. transport = every boat/zeppelin/tram/portal stop (ForeverTravel.lua ns.ForeverTravelTransportSpots);
	-- flight = the flight masters (kind "flight" in ForeverCitySpots.lua). Their own heading "Travel" in Find.
	{ key = "transport", svc = "transport", travel = true, label = "FCITY_CAT_TRANSPORT" },
	{ key = "flight", svc = "flight", travel = true, label = "FCITY_CAT_FLIGHT" },
}
local CAT_BY_KEY = {}
for _, c in ipairs(CATS) do
	CAT_BY_KEY[c.key] = c
end
local ALIASES = { pole = "fishing", fish = "fishing", pick = "mining", knife = "skinning", smith = "hammer",
	blacksmithing = "hammer", flint = "tinder", tools = "thief", goods = "general", ah = "auction",
	mailbox = "mail", innkeeper = "inn" }

local function ItemName(id)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	-- Second way to the name (Rob, 11 Nov 2026: still "(loading...)" a day after the first fix).
	local info = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	if info then
		local ok, n = pcall(info, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	if C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, id) -- the name arrives later; the list redraws on GET_ITEM_INFO_RECEIVED
	end
	return ns:L("FVEND_ITEM_LOADING")
end

local function CatName(c)
	return c.label and ns:L(c.label) or ItemName(c.item)
end

local function Side()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" and "A") or (f == "Horde" and "H") or nil
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

local function PlayerWorld()
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
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

--- Vendors who repair: the data rows, minus any NPC MH saw NOT repair, plus every NPC MH saw repair that the data lacks
--- (with the client's own name and the place where you talked to him). Learned at MERCHANT_SHOW (below).
local function RepairSpots()
	local db = type(ns.db) == "table" and ns.db or {}
	local no = type(db.foreverNotRepair) == "table" and db.foreverNotRepair or {}
	local seen = type(db.foreverRepairSeen) == "table" and db.foreverRepairSeen or {}
	local out, have = {}, {}
	for _, v in ipairs(ns.FOREVER_REPAIR_SPOTS or {}) do
		if not no[v.npc] then
			local s = seen[v.npc]
			if s and s.name then
				-- the name your client showed beats Wowhead's English one (CLAUDE.md: the client name wins)
				v = { kind = v.kind, npc = v.npc, name = s.name, tag = v.tag, side = v.side, map = v.map, x = v.x, y = v.y }
			end
			out[#out + 1] = v
			have[v.npc] = true
		end
	end
	for npc, s in pairs(seen) do
		if not have[npc] and s.map and s.x and s.y then
			out[#out + 1] = { kind = "repair", npc = npc, name = s.name, side = s.side or "both", map = s.map, x = s.x,
				y = s.y, learned = true }
		end
	end
	return out
end

--- The vendors of a category on your side with a usable point, nearest first. Each: { v = row, dist = yards or nil }.
--- @return list, positionKnown
local function List(c)
	local side = Side()
	local rows = (c.svc == "transport" and ns.ForeverTravelTransportSpots and ns.ForeverTravelTransportSpots())
		or (c.svc == "repair" and RepairSpots())
		or (c.svc == "crates" and ns.FOREVER_CRATE_SPOTS)
		or (c.svc == "library" and ns.FOREVER_LIBRARY_SPOTS)
		or (c.svc and ns.FOREVER_CITY_SPOTS) or (c.kind and ns.FOREVER_GOODS_VENDORS) or ns.FOREVER_TOOL_VENDORS
	local pc, px, py = PlayerWorld()
	local out = {}
	for _, v in ipairs(rows or {}) do
		local sells
		if c.svc then
			sells = v.kind == c.svc
		elseif c.kind then
			sells = v.kind == c.kind
		else
			sells = false
			for _, id in ipairs(v.items or {}) do
				if id == c.item then
					sells = true
				end
			end
		end
		local mySide = v.side == "both" or (side and v.side == side)
		if sells and mySide and v.map and v.x and v.y and not v.unsure then
			local vc, vx, vy = World(v.map, v.x, v.y)
			local dist
			if pc and vc and pc == vc then
				dist = math.sqrt((vx - px) ^ 2 + (vy - py) ^ 2)
			end
			out[#out + 1] = { v = v, dist = dist }
		end
	end
	table.sort(out, function(a, b)
		if a.dist and b.dist then
			return a.dist < b.dist
		end
		if a.dist or b.dist then
			return a.dist ~= nil
		end
		return (a.v.name or "") < (b.v.name or "")
	end)
	return out, pc ~= nil
end

--- Arrow to one vendor (Blizzard waypoint + NativeArrow, like the trainer arrow).
local function GoTo(e, what, svc)
	local v = e.v
	local vname = v.name or what or "?" -- a mailbox has no NPC name: it is called what it is
	-- A place we saw this vendor from beats the rounded list value (ForeverSeenPlaces.lua, Rob 11 Nov 2026).
	local vx, vy = v.x, v.y
	if ns.ForeverPlaceFix then
		vx, vy = ns.ForeverPlaceFix(v.npc, v.map, v.x, v.y)
	end
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(v.map, vx, vy)) then
		if not ns._mhWaypointYielded then -- the Forever Leveling Guide steers: Core already said why
			print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		end
		return false
	end
	ns.lastTarget = { mapID = v.map, x = vx, y = vy,
		name = vname .. ((what and v.name) and (" (" .. what .. ")") or ""),
		-- A transport stop is the ship's or zeppelin's centre (DB2), 10-20 yd off the dock: arrive within 25 yd there.
		-- 21 Nov 2026: a platform with a zeppelin master is his spot, so 8 yd (Orgrimmar's two platforms are ~40 yd apart).
		via = "/mh vendor", arriveYards = (v.kind == "transport") and (v.master and 8 or 25) or 5, vendorNpc = v.npc or v.master,
		nearKey = "FARROW_NEAR_NPC", nearYards = 20 }
	ns._mhRouteOwner = "waypoint"
	print(PREFIX .. ns:L(svc and "FCITY_ARROW_SET_FMT" or "FVEND_ARROW_SET_FMT"):format(vname, ZoneName(v.map),
		e.dist and Distance(e.dist) or ns:L("FVEND_OTHER_CONT")))
	return true
end

--------------------------------------------------------------------------------
-- Window (same look as the profession-trainer window; Shift+scroll and Escape via RegisterMidnightDialogPopup)
--------------------------------------------------------------------------------
local W, H, LEFT_W, ROW_H = 660, 480, 170, 36
local win, selected, Fill

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverVendors", UIParent, "BackdropTemplate")
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
	f.catBtns = {}
	for i = 1, #CATS do
		local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		b:SetSize(LEFT_W, 24)
		b:SetPoint("TOPLEFT", 20, -50 - (i - 1) * 28)
		b:SetScript("OnClick", function(self)
			selected = self.cat
			Fill()
		end)
		-- 19 Nov 2026 (Rob: tooltips "overal waar een tooltip bestaat in de game"): a category that is an item (the
		-- tools) shows the item's own tooltip. Bank, inn and the like have no item: no tooltip.
		b:SetScript("OnEnter", function(self)
			local id = self.cat and self.cat.item
			if not (id and GameTooltip) then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			local ok = pcall(GameTooltip.SetHyperlink, GameTooltip, "item:" .. id)
			if ok then
				GameTooltip:Show()
			else
				GameTooltip:Hide()
			end
		end)
		b:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		f.catBtns[i] = b
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
	scroll:SetPoint("TOPLEFT", rx, -94)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -40, 44)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(W - rx - 44, 10)
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
	r.go = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
	r.go:SetSize(76, 22)
	r.go:SetPoint("RIGHT", r, "RIGHT", -2, 0)
	r.go:SetScript("OnClick", function(self)
		if self.entry then
			GoTo(self.entry, self.what, self.svc)
		end
	end)
	f.rows[i] = r
	return r
end

Fill = function()
	local f = Build()
	selected = selected or CATS[1]
	f.title:SetText(ns:L("FVEND_TITLE"))
	for i, b in ipairs(f.catBtns) do
		local c = CATS[i]
		b.cat = c
		b:SetText(CatName(c))
		if c == selected then
			b:LockHighlight()
		else
			b:UnlockHighlight()
		end
	end
	local list, posOk = List(selected)
	local what = CatName(selected)
	f.head:SetText(ns:L("FVEND_COUNT_FMT"):format(what, #list))
	local sub = ns:L((selected.svc and ("FCITY_SUB_" .. selected.svc:upper())) or (selected.kind and "FVEND_SUB_GOODS")
		or "FVEND_SUB_TOOL")
	if not posOk then
		sub = sub .. "  " .. ns:L("FVEND_NOPOS")
	end
	if #list == 0 then
		sub = sub .. "  " .. ns:L("FVEND_EMPTY")
	end
	f.sub:SetText(sub)
	local y = 0
	for i, e in ipairs(list) do
		local r = Row(f, i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, y)
		-- The tags in the data are Wowhead's English subtitles: only shown on an English client, where they match the
		-- NPC's own subtitle (the project rule: a game name is what THIS client shows).
		local loc = GetLocale and GetLocale() or "enUS"
		local english = loc == "enUS" or loc == "enGB"
		local tag = (english and e.v.tag and e.v.tag ~= "") and ("  |cff999999<" .. e.v.tag .. ">|r") or ""
		r.name:SetText((e.v.name or what) .. tag)
		r.info:SetText(ZoneName(e.v.map) .. " · " .. (e.dist and Distance(e.dist) or ns:L("FVEND_OTHER_CONT")))
		r.go:SetText(ns:L("FVEND_ARROW"))
		r.go.entry, r.go.what, r.go.svc = e, what, selected.svc
		r:Show()
		y = y - ROW_H - 4
	end
	for i = #list + 1, #f.rows do
		f.rows[i]:Hide()
	end
	f.child:SetHeight(math.max(10, -y))
	f.scroll:SetVerticalScroll(0)
	f.hint:SetText(ns:L("FVEND_HINT"))
	return f
end

--- 17 Nov 2026, product plan step 4 (the overview's Find tab, Rob: "ja ga maar door met 4 tot en met 9"): the
--- categories and their sellers, the same list as this window. Cats: { key, name, goods }. Rows: { name, tag, zone,
--- dist, map, x, y, go }; the tag only on an English client (Wowhead's English subtitles, see Fill above).
function ns.ForeverVendorFindCats()
	local out = {}
	local _, token = UnitClass("player")
	for _, c in ipairs(CATS) do
		if not c.mage or token == "MAGE" then -- 21 Nov 2026: the library only for mages
			out[#out + 1] = { key = c.key, name = CatName(c), goods = c.kind ~= nil, svc = c.svc, travel = c.travel,
				item = c.item } -- item: the tool's id, for its own tooltip in the Find tab (19 Nov 2026)
		end
	end
	return out
end

function ns.ForeverVendorFindRows(key)
	local c = CAT_BY_KEY[key]
	if not c then
		return {}, false
	end
	local list, posOk = List(c)
	local what = CatName(c)
	local loc = GetLocale and GetLocale() or "enUS"
	local english = loc == "enUS" or loc == "enGB"
	local rows = {}
	for _, e in ipairs(list) do
		local tag = (english and e.v.tag and e.v.tag ~= "") and e.v.tag or nil
		if c.svc == "repair" then
			-- Wowhead's English subtitle (Armorer, Weaponsmith …): only on an English client, like the shops above.
			tag = (english and e.v.tag and e.v.tag ~= "") and e.v.tag or nil
		elseif c.svc == "crates" then
			tag = e.v.tag -- already the client's word (measured per language, ForeverCrates.lua)
		elseif c.svc then
			-- Our own word, so every language: "neutral" on a Blackwater (neutral) auction house (ForeverCitySpots.lua).
			tag = e.v.neutral and ns:L("FCITY_NEUTRAL_TAG") or nil
		end
		rows[#rows + 1] = { name = e.v.name or what, tag = tag, note = e.v.note,
			zone = ZoneName(e.v.map), dist = e.dist, map = e.v.map, x = e.v.x, y = e.v.y,
			go = function()
				return GoTo(e, what, c.svc)
			end }
	end
	return rows, posOk
end

--------------------------------------------------------------------------------
-- Which city? (20 Nov 2026, overview layout D step 3; Rob via sparring: "…ik wil naar Ogrimai … Terwijl ik helemaal op
-- het andere werelddeel zit", and on the plan: "Ja"). The cities are the towns with an inn in ForeverCitySpots.lua
-- (GEMETEN data); a city's services are the bank / auction / mail / inn / flight / transport rows near its inn, plus
-- your class trainer. Mockup: Temp\claude\find_mockups\D_find.png.
--------------------------------------------------------------------------------
-- The six capitals are city maps of their own; every other town sits on a zone map, so its inn row carries `area` (the
-- AreaTable id, GEMETEN in Forever DB2 1.60.1.70959) for the client's own name, and `town` as the English fallback when
-- C_Map.GetAreaInfo gives nothing. One entry per town (Dalaran has two inns), several towns per zone map.
local CAPITAL = { [1453] = true, [1454] = true, [1455] = true, [1456] = true, [1457] = true, [1458] = true }
-- A town's services lie within this many yards of its inn (AFGELEID: Orgrimmar's zeppelin towers and Stormwind's
-- harbour are a few hundred yards from the inn; a village is small, and The Barrens has three inns on one map).
local CITY_RADIUS, TOWN_RADIUS = 700, 300

local function CityName(v)
	if v.area and C_Map and C_Map.GetAreaInfo then
		local ok, n = pcall(C_Map.GetAreaInfo, v.area)
		if ok and type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
			return n
		end
	end
	return v.town or ZoneName(v.map)
end

local function Bind()
	if GetBindLocation then
		local ok, b = pcall(GetBindLocation)
		if ok and type(b) == "string" and b ~= "" and not (issecretvalue and issecretvalue(b)) then
			return b
		end
	end
	return nil
end

--- Every town with an inn on your side: { key = map, map, x, y (the inn), name, zone, capital, dist, hearth }.
--- Capitals first (data order), then the other towns, nearest first.
function ns.ForeverFindCities()
	local side = Side()
	local pc, px, py = PlayerWorld()
	local bind = Bind()
	local out, seen = {}, {}
	for _, v in ipairs(ns.FOREVER_CITY_SPOTS or {}) do
		-- A string for a town, so it never meets a map number; an inn without a measured town is its own entry.
		local key = (v.area and ("a" .. v.area)) or (CAPITAL[v.map] and v.map) or ("n" .. tostring(v.npc or v.map))
		if v.kind == "inn" and v.map and v.x and v.y and not seen[key] and (v.side == "both" or (side and v.side == side)) then
			seen[key] = true
			local name = CityName(v)
			local vc, vx, vy = World(v.map, v.x, v.y)
			local dist
			if pc and vc and pc == vc then
				dist = math.sqrt((vx - px) ^ 2 + (vy - py) ^ 2)
			end
			out[#out + 1] = { key = key, map = v.map, x = v.x, y = v.y, inn = v, name = name,
				zone = (not CAPITAL[v.map]) and ZoneName(v.map) or nil, capital = CAPITAL[v.map] == true, dist = dist,
				hearth = bind ~= nil and bind == name, order = #out }
			-- The Hearthstone's own name from the client (item 6948, as Rest XP does): a game name, never ours.
			out[#out].hearthName = out[#out].hearth and ItemName(6948) or nil
		end
	end
	table.sort(out, function(a, b)
		if a.capital ~= b.capital then
			return a.capital
		end
		if a.capital then
			return a.order < b.order
		end
		if a.dist and b.dist then
			return a.dist < b.dist
		end
		if a.dist or b.dist then
			return a.dist ~= nil
		end
		return a.name < b.name
	end)
	return out, pc ~= nil
end

--- The services of one town (key from ns.ForeverFindCities): rows { name, info, why, map, x, y, go }. One row per
--- service (the one nearest to the inn); every boat / zeppelin / tram / portal stop gets its own row.
function ns.ForeverCityServiceRows(key)
	local city
	for _, c in ipairs((ns.ForeverFindCities())) do
		if c.key == key then
			city = c
		end
	end
	if not city then
		return {}, nil
	end
	local cc, cx, cy = World(city.map, city.x, city.y)
	if not cc then
		return {}, city
	end
	local pc, px, py = PlayerWorld()
	local here = pc == cc
	local function Near(map, x, y)
		local vc, vx, vy = World(map, x, y)
		if vc ~= cc then
			return nil
		end
		local d = math.sqrt((vx - cx) ^ 2 + (vy - cy) ^ 2)
		if d > (city.capital and CITY_RADIUS or TOWN_RADIUS) then
			return nil
		end
		local mine = here and math.sqrt((vx - px) ^ 2 + (vy - py) ^ 2) or nil
		return d, mine
	end
	local rows = {}
	local ORDER = { "inn", "bank", "auction", "mail", "repair", "flight", "transport" }
	for _, k in ipairs(ORDER) do
		local c = CAT_BY_KEY[k]
		local what = CatName(c)
		local list = List(c)
		local best, bestScore
		for _, e in ipairs(list) do
			local d, mine = Near(e.v.map, e.v.x, e.v.y)
			if d then
				local e2 = { v = e.v, dist = mine }
				if k == "transport" then
					rows[#rows + 1] = { e = e2, what = what, svc = c.svc, name = e.v.name or what, why = e.v.note }
				else
					-- The one nearest to THIS town's inn (not to you: in The Barrens the Crossroads flight master is nearer to
				-- you than Ratchet's, and it is not Ratchet's).
				local score = d
					if not bestScore or score < bestScore then
						best, bestScore = e2, score
					end
				end
			end
		end
		if best then
			rows[#rows + 1] = { e = best, what = what, svc = c.svc, name = what,
				who = best.v.name, neutral = best.v.neutral }
		end
	end
	local out = {}
	for _, r in ipairs(rows) do
		local e = r.e
		local info = r.who or ZoneName(e.v.map)
		if r.neutral then
			info = info .. "  |cff999999" .. ns:L("FCITY_NEUTRAL_TAG") .. "|r"
		end
		if e.dist then
			info = info .. " · " .. Distance(e.dist)
		end
		out[#out + 1] = { name = r.name, info = info, why = r.why, map = e.v.map, x = e.v.x, y = e.v.y,
			go = function()
				return GoTo(e, r.what, r.svc)
			end }
	end
	-- Your class trainer in this city (ForeverTrainer.lua's own list; the nearest one there).
	if ns.ForeverProfTrainerList then
		local ok, list = pcall(ns.ForeverProfTrainerList, nil)
		if ok and type(list) == "table" then
			for _, t in ipairs(list) do
				local c = t.c
				if c and c.map and c.x and c.y and Near(c.map, c.x, c.y) then
					local _, token = UnitClass("player")
					local cname = (ns.ForeverClassName and token and ns.ForeverClassName(token)) or UnitClass("player") or "?"
					local info = c.name or ZoneName(c.map)
					if here and t.dist then
						info = info .. " · " .. Distance(t.dist)
					end
					table.insert(out, math.min(2, #out + 1), { name = ns:L("FOV_FIND_CLASS_FMT"):format(cname), info = info,
						map = c.map, x = c.x, y = c.y,
						go = function()
							return ns.ForeverTrainerGoTo and ns.ForeverTrainerGoTo(c, t.dist, nil, nil)
						end })
					break
				end
			end
		end
	end
	return out, city
end

--- Arrow to a city's inn ("Route to <city>").
function ns.ForeverCityGo(key)
	for _, c in ipairs((ns.ForeverFindCities())) do
		if c.key == key then
			return GoTo({ v = c.inn, dist = c.dist }, c.name, "inn")
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Repair & sell (20 Nov 2026, Rob: "ja doe maar"): the nearest vendor who repairs, and learning which vendors do.
--------------------------------------------------------------------------------
local repairWhy = "not asked yet"

--- The nearest vendor who repairs on your continent and side: row { name, zone, dist, go, … } or nil + why.
function ns.ForeverRepairNearest()
	local rows, posOk = ns.ForeverVendorFindRows("repair")
	if not posOk then
		repairWhy = "your position cannot be read here"
		return nil, repairWhy
	end
	for _, r in ipairs(rows or {}) do
		if r.dist then
			repairWhy = ("nearest: %s, %d yd"):format(tostring(r.name), math.floor(r.dist + 0.5))
			return r
		end
	end
	repairWhy = ("none on this continent for your side (%d known in all)"):format(#(rows or {}))
	return nil, repairWhy
end

function ns.ForeverRepairWhy()
	return "last search: " .. repairWhy
end

--- Set the arrow to the nearest vendor who repairs; says so in chat when there is none (and why).
function ns.ForeverRepairGoNearest()
	local r = ns.ForeverRepairNearest()
	if r and r.go then
		return r.go()
	end
	print(PREFIX .. ns:L("FCITY_REPAIR_NONE"))
	return false
end

-- Learn at every vendor window: CanMerchantRepair says whether THIS vendor repairs. A repairer the data lacks is added
-- with the name your client shows and the place where you stand; a data row whose vendor does not repair is dropped.
local learn = CreateFrame("Frame")
learn:RegisterEvent("MERCHANT_SHOW")
learn:SetScript("OnEvent", function()
	pcall(function()
		if not (CanMerchantRepair and UnitGUID) then
			return
		end
		local guid = UnitGUID("npc")
		if type(guid) ~= "string" or (issecretvalue and issecretvalue(guid)) then
			return
		end
		-- 21 Nov 2026 (API watch, [MOET GEFIKST] #1): fields 2-5 loose. Since the Forever hotfix of 20 Nov the server and
		-- spawn fields are obfuscated (Blizzard, Patch 1.60.1 API changes: "replaced with obfuscated values"); the strict
		-- %d+ pattern could then miss and the learning would stop without a word. Same pattern as line ~1170 below.
		local npc = tonumber(guid:match("^Creature%-[^%-]+%-[^%-]+%-[^%-]+%-[^%-]+%-(%d+)"))
		if not npc then
			ns._mhRepairLearnWhy = "the vendor's GUID did not give an npc id: " .. guid:sub(1, 40)
			return
		end
		ns._mhRepairLearnWhy = ("last vendor window: npc %d"):format(npc)
		ns.db = ns.db or {}
		ns.db.foreverRepairSeen = type(ns.db.foreverRepairSeen) == "table" and ns.db.foreverRepairSeen or {}
		ns.db.foreverNotRepair = type(ns.db.foreverNotRepair) == "table" and ns.db.foreverNotRepair or {}
		if CanMerchantRepair() then
			ns.db.foreverNotRepair[npc] = nil
			local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
			local x, y
			if map and C_Map.GetPlayerMapPosition then
				local pos = C_Map.GetPlayerMapPosition(map, "player")
				if pos then
					x, y = pos:GetXY()
				end
			end
			local name = UnitName("npc")
			if name and (issecretvalue and issecretvalue(name)) then
				name = nil
			end
			ns.db.foreverRepairSeen[npc] = { name = name, map = map, x = x and math.floor(x * 10000 + 0.5) / 100,
				y = y and math.floor(y * 10000 + 0.5) / 100, side = Side() }
		else
			ns.db.foreverRepairSeen[npc] = nil
			for _, v in ipairs(ns.FOREVER_REPAIR_SPOTS or {}) do
				if v.npc == npc then
					ns.db.foreverNotRepair[npc] = true
				end
			end
		end
	end)
end)

function ns.ShowForeverVendors(key)
	-- Product plan step 4: every way into this window lands on the overview's Find tab (this window is the fallback).
	if ns.ShowForeverFind then
		ns.ShowForeverFind("shop", key and CAT_BY_KEY[key] and key or nil)
		return
	end
	local f = Build()
	if key and CAT_BY_KEY[key] then
		selected = CAT_BY_KEY[key]
	end
	if f:IsShown() and not key then
		f:Hide()
		return
	end
	if f:IsShown() then
		Fill()
	else
		f:Show()
	end
end

--------------------------------------------------------------------------------
-- The tip: a profession learned without its tool
--------------------------------------------------------------------------------
local tip
local function TipFrame()
	if tip then
		return tip
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverToolTip", UIParent, "BackdropTemplate")
	f:SetSize(420, 118)
	f:SetPoint("TOP", UIParent, "TOP", 0, -170)
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
	f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.text:SetPoint("TOPLEFT", 22, -32)
	f.text:SetPoint("RIGHT", f, "RIGHT", -22, 0)
	f.text:SetJustifyH("LEFT")
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	f.way = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.way:SetSize(150, 24)
	f.way:SetPoint("BOTTOMLEFT", 22, 18)
	f.way:SetText(ns:L("FVEND_TIP_WAY"))
	f.way:SetScript("OnClick", function(self)
		if self.entry then
			GoTo(self.entry, self.what)
		end
		f:Hide()
	end)
	f.all = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.all:SetSize(150, 24)
	f.all:SetPoint("LEFT", f.way, "RIGHT", 10, 0)
	f.all:SetText(ns:L("FVEND_TIP_ALL"))
	f.all:SetScript("OnClick", function(self)
		ns.ShowForeverVendors(self.key)
		f:Hide()
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	f:Hide()
	-- 17 Nov 2026: style A, like the overview (ForeverStyle.lua S.SkinWindow).
	if ns.ForeverStyle and ns.ForeverStyle.SkinOnShow then
		ns.ForeverStyle.SkinOnShow(f)
	end
	tip = f
	return f
end

local function HasTool(c)
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	for _, id in ipairs(c.have or {}) do
		local ok, n = pcall(fn, id) -- counts bags and what you wear (AFGELEID for Forever)
		if ok and type(n) == "number" and n > 0 then
			return true
		end
	end
	for _, slot in ipairs({ 16, 17 }) do -- a pole in your hands
		local id = GetInventoryItemID and GetInventoryItemID("player", slot)
		for _, h in ipairs(c.have or {}) do
			if id == h then
				return true
			end
		end
	end
	return false
end

--- 12 Nov 2026, for the profession card (ForeverProfGuide.lua): the client's name of a category's tool, or nil.
function ns.ForeverVendorItemName(key)
	local c = CAT_BY_KEY[key]
	return c and CatName(c) or nil
end

--- The tool's item id (for waiting until the client has its name), or nil.
function ns.ForeverVendorItemId(key)
	local c = CAT_BY_KEY[key]
	return c and c.item or nil
end

--- 12 Nov 2026, for "Do this now" (ForeverDoNow.lua): your professions whose tool you do not carry.
--- Each: { key = "skinning", prof = profession name as the client shows it, tool = item name }.
function ns.ForeverMissingTools()
	local mine = ns.ForeverMyProfessions and ns.ForeverMyProfessions()
	local out = {}
	if not mine then
		return out
	end
	for _, c in ipairs(CATS) do
		if c.prof and mine[c.prof] and not HasTool(c) then
			out[#out + 1] = { key = c.key, prof = ns.ForeverProfName and ns.ForeverProfName(c.prof, mine) or c.prof,
				tool = CatName(c) }
		end
	end
	return out
end

-- 21 Nov 2026 (Rob: "A"): the player GUID through ForeverCharKey.lua (the realm is "" since Blizzard's 20 Nov hotfix).
local function CharKey(tbl)
	local n, r = UnitFullName and UnitFullName("player")
	local legacy = n and (n .. "-" .. (r or (GetRealmName and GetRealmName()) or "")) or nil
	if legacy and ns.ForeverCharKey then
		return ns.ForeverCharKey("tool tip (foreverToolTipSeen)", legacy, tbl)
	end
	return legacy
end

local function Seen()
	local d = ns.db
	if not d then
		return nil
	end
	d.foreverToolTipSeen = d.foreverToolTipSeen or {}
	local key = CharKey(d.foreverToolTipSeen)
	if not key then
		return nil
	end
	d.foreverToolTipSeen[key] = d.foreverToolTipSeen[key] or {}
	return d.foreverToolTipSeen[key]
end

--- Fill the tip window. Rob, 10 Nov 2026: it said "you have no (loading...) yet" and stayed that way — the item name
--- was not cached yet and only the list window redrew on GET_ITEM_INFO_RECEIVED. Now the tip redraws too.
local function RenderTip(f)
	local c = f.tipCat
	if not c then
		return
	end
	local list = List(c)
	local best = list[1]
	local what = CatName(c)
	f.tipLoading = (what == ns:L("FVEND_ITEM_LOADING"))
	-- f.tipNeed (12 Nov 2026): shown because the game just said the tool is missing, not because you learned the
	-- profession; same window and button, another first sentence.
	if best then
		local dist = best.dist and Distance(best.dist) or ns:L("FVEND_OTHER_CONT")
		if f.tipNeed then
			f.text:SetText(ns:L("FVEND_NEED_FMT"):format(what, best.v.name, ZoneName(best.v.map), dist))
		else
			f.text:SetText(ns:L("FVEND_TIP_FMT"):format(f.tipProf, what, best.v.name, ZoneName(best.v.map), dist))
		end
		f.way.entry, f.way.what = best, what
		f.way:Enable()
	else
		if f.tipNeed then
			f.text:SetText(ns:L("FVEND_NEED_NONE_FMT"):format(what))
		else
			f.text:SetText(ns:L("FVEND_TIP_NONE_FMT"):format(f.tipProf, what))
		end
		f.way.entry = nil
		f.way:Disable()
	end
	f.all.key = c.key
end

--- Rob, 11 Nov 2026: the 10 Nov fix (redraw on GET_ITEM_INFO_RECEIVED) still left "(loading...)" in the tip. Why the
--- event did not land is not measured. So the tip no longer depends on that one event: it also asks the game's own
--- "tell me when this item has loaded" (ItemMixin ContinueOnItemLoad) and looks again every half second for 5 seconds.
--- The tip's chat line: the window's text, plus the way back to the list (Rob, 12 Nov 2026, via sparring: the tip comes
--- once, so the line now says which command opens the sellers again; his yes: "ja, die regelt ronde maar voor het skinny
--- knife ook", read back by sparring as "ja, die regel erbij").
local function TipChat(f)
	local line = PREFIX .. (f.text:GetText() or "")
	local key = f.tipCat and f.tipCat.key
	if key then
		line = line .. " " .. ns:L("FVEND_TIP_LIST_FMT"):format("/mh vendor " .. key)
	end
	return line
end

local function FinishTipName(f)
	if not (f and f:IsShown() and f.tipLoading) then
		return
	end
	RenderTip(f)
	if f.tipChatPending and not f.tipLoading then
		f.tipChatPending = nil
		print(TipChat(f))
	end
end

local function WaitForTipName(f)
	local id = f.tipCat and f.tipCat.item
	if not (id and f.tipLoading) then
		return
	end
	if Item and Item.CreateFromItemID then
		pcall(function()
			Item:CreateFromItemID(id):ContinueOnItemLoad(function()
				FinishTipName(f)
			end)
		end)
	end
	if C_Timer and C_Timer.NewTicker then
		local tries, ticker = 0, nil
		ticker = C_Timer.NewTicker(0.5, function()
			tries = tries + 1
			FinishTipName(f)
			if tries >= 10 or not f.tipLoading or not f:IsShown() then
				ticker:Cancel()
			end
		end)
	end
end

local ready = false -- professions known at login are recorded, never announced
local lastTip = "nothing checked yet"

local function CheckNewProfessions()
	local seen = Seen()
	local mine = ns.ForeverMyProfessions and ns.ForeverMyProfessions()
	if not (seen and mine) then
		lastTip = "professions or saved data not readable yet"
		return
	end
	for _, c in ipairs(CATS) do
		if c.prof and mine[c.prof] and not seen[c.prof] then
			seen[c.prof] = true
			if not ready then
				lastTip = "recorded at login: " .. c.prof
			elseif HasTool(c) then
				lastTip = c.prof .. " learned, tool already in your bags: quiet"
			else
				local f = TipFrame()
				f.tipCat = c
				f.tipNeed = nil
				f.tipProf = ns.ForeverProfName and ns.ForeverProfName(c.prof, mine) or c.prof
				RenderTip(f)
				f:Show()
				-- The chat line waits for the item name too: "(loading...)" in chat cannot be fixed afterwards.
				f.tipChatPending = f.tipLoading or nil
				if not f.tipLoading then
					print(TipChat(f))
				else
					WaitForTipName(f)
				end
				lastTip = c.prof .. " learned without its tool: tip shown"
			end
		end
	end
end

--------------------------------------------------------------------------------
-- The same tip when the GAME says the tool is missing (12 Nov 2026)
--------------------------------------------------------------------------------
-- Rob, 12 Nov 2026 (via sparring): Cisca had Skinning but no knife, and the game said so when she tried to skin; the tip
-- above never came, because she had the profession before MH knew about it. "Ja, laat hem dat uitzoeken en bouwen".
-- GEMETEN in Forever DB2 1.60.1.70888: the error text is GlobalStrings SPELL_FAILED_TOTEM_CATEGORY / SPELL_FAILED_TOTEMS
-- "Requires %s", with %s a TotemCategory name: 162 Blacksmith Hammer, 165 Mining Pick, 166 Skinning Knife (names per
-- client below, measured per locale). Fishing has no category: SPELL_FAILED_EQUIPPED_ITEM_CLASS "Must have a %s
-- equipped" (+ _MAINHAND), %s = the item subclass name, which the client gives us (C_Item.GetItemSubClassInfo 2, 20).
-- AFGELEID, not seen in game: that the text arrives as UI_ERROR_MESSAGE's message argument exactly like that.
-- /mh vendor check prints the last error MH heard and what it did with it, so one try in game settles it.
local TOOL_NAMES = {
	hammer = { "Blacksmith Hammer", "Schmiedehammer", "Marteau de forgeron", "Martillo de herrero", "Martelo de Ferreiro",
		"Кузнечный молот" },
	mining = { "Mining Pick", "Spitzhacke", "Pioche de mineur", "Pico de minería", "Picareta de Mineração",
		"Шахтерская кирка" },
	skinning = { "Skinning Knife", "Kürschnermesser", "Couteau à dépecer", "Cuchillo para desollar", "Faca de Esfolamento",
		"Нож для снятия шкур" },
}
local NEED_QUIET = 600 -- seconds: one tip per tool per 10 minutes, not one per click
local needShown = {}
local lastErr = "no error heard yet"
local lastAny = "none"

function ns.IsForeverToolNeedTipOn()
	return not (ns.db and ns.db.foreverToolNeedTip == false)
end

function ns.SetForeverToolNeedTipOn(on)
	if ns.db then
		ns.db.foreverToolNeedTip = on and true or false
	end
end

local function Matches(msg, fmt, name)
	if type(fmt) ~= "string" or not name then
		return false
	end
	local ok, s = pcall(string.format, fmt, name)
	return ok and s == msg
end

--- Which tool category does this error message ask for? Returns the CATS row or nil.
local function CatForError(msg)
	for key, names in pairs(TOOL_NAMES) do
		for _, n in ipairs(names) do
			if Matches(msg, SPELL_FAILED_TOTEM_CATEGORY, n) or Matches(msg, SPELL_FAILED_TOTEMS, n) then
				return CAT_BY_KEY[key]
			end
		end
	end
	local pole = "Fishing Pole"
	if C_Item and C_Item.GetItemSubClassInfo then
		local ok, n = pcall(C_Item.GetItemSubClassInfo, 2, 20)
		if ok and type(n) == "string" and n ~= "" then
			pole = n
		end
	end
	if Matches(msg, SPELL_FAILED_EQUIPPED_ITEM_CLASS, pole) or Matches(msg, SPELL_FAILED_EQUIPPED_ITEM_CLASS_MAINHAND, pole) then
		return CAT_BY_KEY.fishing
	end
	return nil
end

local function OnToolError(msg)
	if type(msg) ~= "string" or (issecretvalue and issecretvalue(msg)) then
		return
	end
	lastAny = msg -- any game error, so /mh vendor check shows the exact text if it did not match
	local c = CatForError(msg)
	if not c then
		return
	end
	lastErr = ("\"%s\" -> %s: "):format(msg, c.key)
	if not ns.IsForeverToolNeedTipOn() then
		lastErr = lastErr .. "switched off, quiet"
		return
	end
	if HasTool(c) then
		lastErr = lastErr .. "a tool is in your bags (a better one counts too): quiet"
		return
	end
	local now = GetTime and GetTime() or 0
	if needShown[c.key] and now - needShown[c.key] < NEED_QUIET then
		lastErr = lastErr .. ("shown %d s ago: quiet"):format(math.floor(now - needShown[c.key]))
		return
	end
	needShown[c.key] = now
	local f = TipFrame()
	f.tipCat = c
	f.tipNeed = true
	f.tipProf = nil
	RenderTip(f)
	f:Show()
	f.tipChatPending = f.tipLoading or nil
	if not f.tipLoading then
		print(TipChat(f))
	else
		WaitForTipName(f)
	end
	lastErr = lastErr .. "tip shown"
end

--------------------------------------------------------------------------------
-- /mh vendor
--------------------------------------------------------------------------------
function ns.ForeverVendorSlash(arg)
	arg = (arg or ""):lower()
	if arg == "tip on" or arg == "tip off" then
		ns.SetForeverToolNeedTipOn(arg == "tip on")
		if ns.SyncNativeSetting then
			ns.SyncNativeSetting("mh_foreverToolNeedTip", arg == "tip on")
		end
		print(PREFIX .. ns:L(arg == "tip on" and "FVEND_NEED_ON" or "FVEND_NEED_OFF"))
		return
	end
	if arg == "check" then
		local _, posOk = List(CATS[1])
		print(PREFIX .. ("vendors: %d tool rows, %d goods rows, %d city rows, your side %s, position %s"):format(
			#(ns.FOREVER_TOOL_VENDORS or {}), #(ns.FOREVER_GOODS_VENDORS or {}), #(ns.FOREVER_CITY_SPOTS or {}),
			tostring(Side()),
			posOk and "readable" or "NOT readable"))
		do
			local nSeen, nNo = 0, 0
			for _ in pairs((ns.db and ns.db.foreverRepairSeen) or {}) do
				nSeen = nSeen + 1
			end
			for _ in pairs((ns.db and ns.db.foreverNotRepair) or {}) do
				nNo = nNo + 1
			end
			print(("  repair: %d data rows, %d learned at a vendor window, %d dropped (that vendor did not repair). %s"):format(
				#(ns.FOREVER_REPAIR_SPOTS or {}), nSeen, nNo, ns.ForeverRepairWhy and ns.ForeverRepairWhy() or ""))
			print("  learning: " .. (ns._mhRepairLearnWhy or "no vendor window seen this session"))
		end
		for _, c in ipairs(CATS) do
			local list = List(c)
			local b = list[1]
			print(("  %s: %d on your side; nearest %s"):format(CatName(c), #list,
				b and (b.v.name .. " (" .. ZoneName(b.v.map) .. (b.dist and (", " .. Distance(b.dist)) or "") .. ")") or "-"))
		end
		print("  tip: " .. lastTip)
		print(("  tool missing (game error): %s; last: %s"):format(ns.IsForeverToolNeedTipOn() and "on" or "off", lastErr))
		print(("  last game error of any kind: \"%s\""):format(lastAny))
		return
	end
	ns.ShowForeverVendors(ALIASES[arg] or (arg ~= "" and arg) or nil)
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:RegisterEvent("MERCHANT_SHOW")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
ev:RegisterEvent("UI_ERROR_MESSAGE")
ev:SetScript("OnEvent", function(_, event, a1, a2)
	if event == "UI_ERROR_MESSAGE" then
		-- (errorType, message); older clients sent the message first, so take whichever is a string.
		pcall(OnToolError, type(a2) == "string" and a2 or a1)
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
		if not ready then
			C_Timer.After(3, function()
				CheckNewProfessions() -- records what you already have
				ready = true
			end)
		end
	elseif event == "SKILL_LINES_CHANGED" then
		if ready then
			C_Timer.After(0.5, CheckNewProfessions)
		end
	elseif event == "MERCHANT_SHOW" then
		-- Only the vendor the arrow points at ends the route.
		local lt = ns.lastTarget
		if lt and lt.via == "/mh vendor" and ns._mhRouteOwner == "waypoint" and lt.vendorNpc then
			local guid = UnitGUID and UnitGUID("npc")
			if type(guid) == "string" and not (issecretvalue and issecretvalue(guid)) then
				local id = tonumber(guid:match("^Creature%-[^%-]+%-[^%-]+%-[^%-]+%-[^%-]+%-(%d+)"))
				if id == lt.vendorNpc then
					ns._mhRouteOwner = nil
				end
			end
		end
	elseif event == "GET_ITEM_INFO_RECEIVED" then
		if win and win:IsShown() then
			Fill()
		end
		local f = tip
		if f and f:IsShown() and f.tipLoading then
			RenderTip(f)
			if f.tipChatPending and not f.tipLoading then
				f.tipChatPending = nil
				print(TipChat(f))
			end
		end
	end
end)
