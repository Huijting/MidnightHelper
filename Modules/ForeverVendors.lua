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
}
local CAT_BY_KEY = {}
for _, c in ipairs(CATS) do
	CAT_BY_KEY[c.key] = c
end
local ALIASES = { pole = "fishing", fish = "fishing", pick = "mining", knife = "skinning", smith = "hammer",
	blacksmithing = "hammer", flint = "tinder", tools = "thief", goods = "general" }

local function ItemName(id)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
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

--- The vendors of a category on your side with a usable point, nearest first. Each: { v = row, dist = yards or nil }.
--- @return list, positionKnown
local function List(c)
	local side = Side()
	local rows = c.kind and ns.FOREVER_GOODS_VENDORS or ns.FOREVER_TOOL_VENDORS
	local pc, px, py = PlayerWorld()
	local out = {}
	for _, v in ipairs(rows or {}) do
		local sells
		if c.kind then
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
local function GoTo(e, what)
	local v = e.v
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(v.map, v.x, v.y)) then
		print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		return false
	end
	ns.lastTarget = { mapID = v.map, x = v.x, y = v.y, name = v.name .. (what and (" (" .. what .. ")") or ""),
		via = "/mh vendor", arriveYards = 5, vendorNpc = v.npc }
	ns._mhRouteOwner = "waypoint"
	print(PREFIX .. ns:L("FVEND_ARROW_SET_FMT"):format(v.name, ZoneName(v.map),
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
			GoTo(self.entry, self.what)
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
	local sub = ns:L(selected.kind and "FVEND_SUB_GOODS" or "FVEND_SUB_TOOL")
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
		r.name:SetText(e.v.name .. tag)
		r.info:SetText(ZoneName(e.v.map) .. " · " .. (e.dist and Distance(e.dist) or ns:L("FVEND_OTHER_CONT")))
		r.go:SetText(ns:L("FVEND_ARROW"))
		r.go.entry, r.go.what = e, what
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

function ns.ShowForeverVendors(key)
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

local function CharKey()
	local n, r = UnitFullName and UnitFullName("player")
	return n and (n .. "-" .. (r or GetRealmName() or "")) or nil
end

local function Seen()
	local d, key = ns.db, CharKey()
	if not (d and key) then
		return nil
	end
	d.foreverToolTipSeen = d.foreverToolTipSeen or {}
	d.foreverToolTipSeen[key] = d.foreverToolTipSeen[key] or {}
	return d.foreverToolTipSeen[key]
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
				local list = List(c)
				local best = list[1]
				local what = CatName(c)
				local f = TipFrame()
				local profName = ns.ForeverProfName and ns.ForeverProfName(c.prof, mine) or c.prof
				if best then
					f.text:SetText(ns:L("FVEND_TIP_FMT"):format(profName, what, best.v.name, ZoneName(best.v.map),
						best.dist and Distance(best.dist) or ns:L("FVEND_OTHER_CONT")))
					f.way.entry, f.way.what = best, what
					f.way:Enable()
				else
					f.text:SetText(ns:L("FVEND_TIP_NONE_FMT"):format(profName, what))
					f.way.entry = nil
					f.way:Disable()
				end
				f.all.key = c.key
				f:Show()
				print(PREFIX .. f.text:GetText())
				lastTip = c.prof .. " learned without its tool: tip shown"
			end
		end
	end
end

--------------------------------------------------------------------------------
-- /mh vendor
--------------------------------------------------------------------------------
function ns.ForeverVendorSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" then
		local _, posOk = List(CATS[1])
		print(PREFIX .. ("vendors: %d tool rows, %d goods rows, your side %s, position %s"):format(
			#(ns.FOREVER_TOOL_VENDORS or {}), #(ns.FOREVER_GOODS_VENDORS or {}), tostring(Side()),
			posOk and "readable" or "NOT readable"))
		for _, c in ipairs(CATS) do
			local list = List(c)
			local b = list[1]
			print(("  %s: %d on your side; nearest %s"):format(CatName(c), #list,
				b and (b.v.name .. " (" .. ZoneName(b.v.map) .. (b.dist and (", " .. Distance(b.dist)) or "") .. ")") or "-"))
		end
		print("  tip: " .. lastTip)
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
ev:SetScript("OnEvent", function(_, event)
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
	end
end)
