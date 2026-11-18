local _, ns = ...

--[[
	ForeverDungeonGuide.lua — WoW Forever: who the bosses are, what they do, one tip, and a few items worth knowing.
	Step 1 (18 Nov 2026), Rob via sparring, letterlijk: "Ja bouw maar" (on the advice "A+ in small steps"), and the same
	day: "Zuinig is goed maar het moet wel foutloos 💪".

	Why: Forever has no Dungeon Journal. GEMETEN: the Journal* DB2 tables are absent in 1.60.1.70959 and
	Blizzard_EncounterJournal.toc line 7 allows only "standard, classic" (docs/forever/DUNGEONGIDS_*.md).
	Rob, 14 Nov: MH explains in its own way, it does NOT rebuild the DungeonJournal addon — so: a few lines per boss,
	2-3 items per dungeon, no drop chances (the guides quote Classic chances; Wowhead Forever differs).

	Data: ForeverDungeonGuideData.lua (generated from the mh-research data, every line with its sources; a line with one
	source says so in the text). Boss names per language from DB2 DungeonEncounter; item names from the client.
	Step 1 = the nine dungeons up to level ~32: six classic ones and three new in Forever (Hall of Thanes, Ruins of
	Lordaeron, Excavation Site; Rob: "Die nieuwe dungeons erbij. En dan later nog een keer controleren." — they carry
	`recheck` and say so on top). A second, independent check (docs/forever/DUNGEONGIDS_CONTROLE3_2026-11-18.md) found 9
	errors; all fixed. Plan: step 2 = dungeons 32-60, step 3 = the raids (open 9 Dec), with fresh sources.
	Step 2a (18 Nov 2026, Rob via sparring: "Ga maar verder met 2"): 11 more dungeons ~28-55 (Gnomeregan, Razorfen
	Kraul, Scarlet Monastery, Razorfen Downs, Uldaman, Zul'Farrak, Maraudon + new: City of Dalaran, The Drowned City,
	Krol'dok Stronghold, Alcaz Prison). New here: the dungeon list scrolls, a dungeon with wings is one page with a
	header per wing (`part`, an FDGP_* key), its level range spans all wings, and extraNpc may be a list. Two
	independent checks (docs/forever/DUNGEONGIDS_CONTROLE2A_*_2026-11-18.md): 0 errors, 23 risks; text repairs done.
	Step 2b (same day): the last 8 dungeons up to 60 (Sunken Temple, Blackrock Depths, Dire Maul, Blackrock Spire,
	Scholomance, Stratholme + new: Blackmaw Hold, The Shaper's Terrace): 28 dungeons, 267 bosses. Boss names per
	language now follow Rob's choice "B" (via sparring, 18 Nov 2026): the NAME PLATE (Wowhead Forever npc name per
	locale), not the DB2 DungeonEncounter name — for every dungeon; see docs/CLIENT_NAMES_2026-10-20.md.

	Open it: the "Bosses" button on a dungeon row (overview → Dungeons & group), or /mh bosses. Inside a dungeon it opens
	on that dungeon; targeting a boss marks him (as Midnight's boss window does).
]]

if not ns.IS_FOREVER then
	return
end

local S = ns.ForeverStyle
local W, H, LEFT_W = 660, 470, 170 -- 660 (was 640): room for the list's scroll bar, the text keeps its width
local win
local selected -- instance map id
local targetNpc -- npc id of your target, when it is a boss of this guide

local function Data()
	return ns.FOREVER_DGUIDE or {}
end

local function Order()
	-- The guide's dungeons in the order of ns.FOREVER_DUNGEONS (level order), each once. A dungeon with wings (Scarlet
	-- Monastery: four rows, one map 189) is one page; its level range spans all its rows (step 2a, 18 Nov 2026).
	local out, seen, range = {}, {}, {}
	for _, d in ipairs(ns.FOREVER_DUNGEONS or {}) do
		if Data()[d.map] then
			if not seen[d.map] then
				seen[d.map] = true
				out[#out + 1] = d
				range[d.map] = { min = d.min or 0, max = d.max or 0 }
			else
				local r = range[d.map]
				r.min = math.min(r.min, d.min or r.min)
				r.max = math.max(r.max, d.max or r.max)
			end
		end
	end
	return out, range
end

local function DungeonName(d)
	if GetRealZoneText then
		local ok, v = pcall(GetRealZoneText, d.map)
		if ok and type(v) == "string" and v ~= "" then
			return v
		end
	end
	return d.name
end

-- Is `id` this boss? extraNpc is one id (Sneed's Shredder) or a list (The Lost Dwarves: three dwarves, step 2a).
local function IsBoss(b, id)
	if not id then
		return false
	end
	if b.npc == id then
		return true
	end
	local x = b.extraNpc
	if type(x) == "table" then
		for _, v in ipairs(x) do
			if v == id then
				return true
			end
		end
		return false
	end
	return x ~= nil and x == id
end

-- A wing's name: a FDGP_* key (step 2a; Maraudon's parts have no name in the client, so they are translated), or
-- plain text.
local function PartName(p)
	if type(p) == "string" and p:find("^FDGP_") then
		return ns:L(p)
	end
	return tostring(p)
end

local function BossName(b)
	local loc = GetLocale and GetLocale()
	return (loc and b.names and b.names[loc]) or b.name
end

-- True while the text built last had an item without its name yet ("#id"); Fill() then retries a few times. Fable
-- check, 18 Nov 2026: waiting for GET_ITEM_INFO_RECEIVED alone stuck on Forever before (ForeverVendors.lua:66, :571;
-- RequestLoadItemDataByID answers with ITEM_DATA_LOAD_RESULT, RaidShoppingList.lua:726) — same cure as ForeverVendors.
local missingItem = false
local waitingItem = {} -- item id -> true while a load callback is registered: one per item, not one per refill. Fable C1

local function ItemName(id)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	local info = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	if info then
		local ok, n = pcall(info, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	if C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, id)
	end
	if Item and Item.CreateFromItemID and not waitingItem[id] then
		waitingItem[id] = true
		pcall(function()
			Item:CreateFromItemID(id):ContinueOnItemLoad(function()
				waitingItem[id] = nil
				if ns.ForeverDungeonGuideRefresh then
					ns.ForeverDungeonGuideRefresh()
				end
			end)
		end)
	end
	missingItem = true
	return nil
end

local function ItemColor(id)
	if C_Item and C_Item.GetItemQualityByID then
		local ok, q = pcall(C_Item.GetItemQualityByID, id)
		if ok and type(q) == "number" and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[q] then
			return ITEM_QUALITY_COLORS[q].hex or "|cffffffff"
		end
	end
	return "|cffffffff"
end

--- The whole text for one dungeon (one font string: simple, and it wraps).
function ns.ForeverDungeonGuideText(map)
	local g = Data()[map]
	if not g then
		return ns:L("FDG_NONE")
	end
	local parts = {}
	local byNpc = {}
	local recheck = g.recheck
	missingItem = false
	for _, b in ipairs(g.bosses or {}) do
		-- A boss without a known npc id (Ruins of Lordaeron's captain) has no entry here; the offline test found that
		-- `byNpc[nil] = b` broke the whole page (18 Nov 2026).
		if b.npc then
			byNpc[b.npc] = b
		end
		recheck = recheck or b.recheck
	end
	-- A dungeon that is new in Forever: sources are thin, Rob wants it checked again later ("En dan later nog een keer
	-- controleren", 18 Nov 2026) — say so on top instead of sounding surer than we are.
	if recheck then
		parts[#parts + 1] = "|cffeeb055" .. ns:L("FDG_RECHECK") .. "|r"
		parts[#parts + 1] = " "
	end
	local part
	for i, b in ipairs(g.bosses or {}) do
		-- A wing starts: its name as a small header (an FDGP_* key, translated; PartName).
		if b.part and b.part ~= part then
			part = b.part
			parts[#parts + 1] = "|cffeeb055— " .. PartName(part) .. " —|r"
		end
		-- extraNpc: Sneed's Shredder marks Sneed too (second check, 18 Nov 2026).
		local here = IsBoss(b, targetNpc)
		local head = ("%d. %s"):format(i, BossName(b))
		if b.rare then
			head = head .. "  |cff9d9d9d" .. ns:L("FDG_RARE") .. "|r"
		end
		if here then
			head = "|cff66ff66> " .. head .. "  " .. ns:L("FDG_TARGET") .. "|r"
		else
			head = "|cffdbb56b" .. head .. "|r"
		end
		parts[#parts + 1] = head
		for _, k in ipairs(b.does or {}) do
			parts[#parts + 1] = "   " .. ns:L(k)
		end
		if b.tip then
			parts[#parts + 1] = "   |cffeeb055" .. ns:L("FDG_TIP") .. "|r " .. ns:L(b.tip)
		end
		if b.one then
			parts[#parts + 1] = "   |cff9d9d9d" .. ns:L("FDG_ONE_SOURCE") .. "|r"
		end
		parts[#parts + 1] = " "
	end
	if g.loot and #g.loot > 0 then
		parts[#parts + 1] = "|cffdbb56b" .. ns:L("FDG_LOOT_HEAD") .. "|r"
		for _, l in ipairs(g.loot) do
			local name = ItemName(l.item)
			local boss = byNpc[l.boss]
			parts[#parts + 1] = ("   %s%s%s|r  %s"):format(l.part and ("|cff9d9d9d" .. PartName(l.part) .. ":|r ") or "",
				ItemColor(l.item), name or ("#" .. l.item), ns:L(l.role))
				.. (boss and ("  |cff9d9d9d" .. ns:L("FDG_FROM_FMT"):format(BossName(boss)) .. "|r") or "")
		end
		parts[#parts + 1] = "|cff9d9d9d" .. ns:L("FDG_LOOT_NOTE") .. "|r"
	end
	return table.concat(parts, "\n")
end

local Fill

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverDungeonGuide", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
	f:SetPoint("CENTER", 0, 40)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 20, -16)
	f.title:SetText(ns:L("FDG_TITLE"))
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)
	-- The dungeon list scrolls: 9 dungeons fitted, step 2 brings ~28 (18 Nov 2026). Room for 13 rows of 28 px.
	f.btns = {}
	local order = Order()
	local list = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	list:SetPoint("TOPLEFT", 18, -50)
	list:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 18, 40)
	list:SetWidth(LEFT_W)
	local listChild = CreateFrame("Frame", nil, list)
	listChild:SetSize(LEFT_W, math.max(10, #order * 28))
	list:SetScrollChild(listChild)
	f.list = list
	for i, d in ipairs(order) do
		local b = CreateFrame("Button", nil, listChild, "UIPanelButtonTemplate")
		b:SetSize(LEFT_W - 4, 24)
		b:SetPoint("TOPLEFT", 0, -(i - 1) * 28)
		b.map = d.map
		b:SetText(DungeonName(d))
		b:SetScript("OnClick", function(self)
			selected = self.map
			Fill()
		end)
		f.btns[i] = b
	end
	local rx = 18 + LEFT_W + 34 -- 20 px more since 18 Nov: the list's scroll bar sits to the right of the list
	f.head = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.head:SetPoint("TOPLEFT", rx, -52)
	f.head:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.head:SetJustifyH("LEFT")
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", rx, -76)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -36, 40)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(W - rx - 44, 10)
	scroll:SetScrollChild(child)
	f.body = child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.body:SetPoint("TOPLEFT", 0, 0)
	f.body:SetWidth(W - rx - 50)
	f.body:SetJustifyH("LEFT")
	f.body:SetJustifyV("TOP")
	if f.body.SetSpacing then
		f.body:SetSpacing(3)
	end
	f.scroll, f.child = scroll, child
	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.hint:SetPoint("BOTTOMLEFT", 20, 16)
	f.hint:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.hint:SetJustifyH("LEFT")
	f.hint:SetText(ns:L("FDG_HINT"))
	f:SetScript("OnShow", function()
		Fill()
	end)
	if S and S.SkinOnShow then
		S.SkinOnShow(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

Fill = function()
	local f = win
	if not (f and f:IsShown()) then
		return
	end
	local order, range = Order()
	if not selected or not Data()[selected] then
		local here = ns.ForeverCurrentDungeonMap and ns.ForeverCurrentDungeonMap()
		selected = (here and Data()[here] and here) or (order[1] and order[1].map)
	end
	for i, b in ipairs(f.btns) do
		b:SetEnabled(b.map ~= selected)
		-- Opened on a dungeon further down (its row's button, or you are inside it): scroll the list so it shows. Only
		-- when the choice changed (Fable C2: every item/target event refills, and would pull the list back while you
		-- scroll); marked done only once the scroll range is known (keeps the second Fill at first opening useful).
		if b.map == selected and f.list and f.scrolledFor ~= selected then
			local top, view = (i - 1) * 28, f.list:GetHeight() or 0
			local range = f.list:GetVerticalScrollRange() or 0
			if view > 0 and (range > 0 or #f.btns * 28 <= view) then
				local cur = f.list:GetVerticalScroll() or 0
				if top < cur or top + 28 > cur + view then
					f.list:SetVerticalScroll(math.max(0, math.min(top, range)))
				end
				f.scrolledFor = selected
			end
		end
	end
	local d
	for _, x in ipairs(order) do
		if x.map == selected then
			d = x
		end
	end
	local r = d and range[d.map]
	f.head:SetText(d and ("%s  |cff9d9d9d%d-%d|r"):format(DungeonName(d), r and r.min or d.min or 0, r and r.max or d.max or 0)
		or "")
	-- Another dungeon: its text starts at the top (Fable C3; it kept the old scroll position).
	if f.shownMap ~= selected then
		f.shownMap = selected
		f.scroll:SetVerticalScroll(0)
	end
	f.body:SetText(selected and ns.ForeverDungeonGuideText(selected) or ns:L("FDG_NONE"))
	f.child:SetHeight(math.max(10, (f.body:GetStringHeight() or 0) + 10))
	-- An item name was not loaded yet: try again every 0.5 s, at most 10 times, while the window is open.
	if missingItem and not f.nameTicker and C_Timer and C_Timer.NewTicker then
		local tries, ticker = 0, nil
		ticker = C_Timer.NewTicker(0.5, function()
			tries = tries + 1
			if not f:IsShown() or tries >= 10 then
				ticker:Cancel()
				f.nameTicker = nil
				return
			end
			Fill()
			if not missingItem then
				ticker:Cancel()
				f.nameTicker = nil
			end
		end)
		f.nameTicker = ticker
	end
end

--- Refill an open window (an item's data arrived).
function ns.ForeverDungeonGuideRefresh()
	if win and win:IsShown() then
		Fill()
	end
end

--- Open the guide, on `map` when given (a dungeon row's button), else on where you are.
function ns.ShowForeverDungeonGuide(map)
	local f = Build()
	if map and Data()[map] then
		selected = map
	end
	if f:IsShown() and not map then
		f:Hide()
		return
	end
	f:Show()
	Fill()
	-- On the very first opening the list has no scroll range yet (AFGELEID: layout comes a frame later); one more Fill
	-- then scrolls a dungeon low in the list into view.
	if C_Timer and C_Timer.After then
		C_Timer.After(0, Fill)
	end
end

--- Is there a guide for this instance map? (the overview shows the button only then)
function ns.ForeverDungeonHasGuide(map)
	return map ~= nil and Data()[map] ~= nil
end

-- Targeting a boss of this guide marks him; entering a dungeon selects it. Both only refill an open window.
local function NpcOf(unit)
	if not (UnitGUID and UnitExists and UnitExists(unit)) then
		return nil
	end
	local ok, guid = pcall(UnitGUID, unit)
	if not ok or type(guid) ~= "string" or (issecretvalue and issecretvalue(guid)) then
		return nil
	end
	local kind, _, _, _, _, id = strsplit("-", guid)
	if kind == "Creature" or kind == "Vehicle" then
		return tonumber(id)
	end
	return nil
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_TARGET_CHANGED")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_TARGET_CHANGED" then
		local id = NpcOf("target")
		local found
		for map, g in pairs(Data()) do
			for _, b in ipairs(g.bosses or {}) do
				if IsBoss(b, id) then
					found = map
				end
			end
		end
		targetNpc = found and id or nil
		if found then
			selected = found
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		local here = ns.ForeverCurrentDungeonMap and ns.ForeverCurrentDungeonMap()
		if here and Data()[here] then
			selected = here
		end
	end
	if win and win:IsShown() then
		Fill()
	end
end)

--- /mh bosses: open the guide; /mh bosses check: what MH has (a quiet module needs a way to see why).
function ns.ForeverDungeonGuideSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" then
		local P = "|cffffcc00Midnight Helper:|r "
		local nB, nL = 0, 0
		for _, g in pairs(Data()) do
			nB = nB + #(g.bosses or {})
			nL = nL + #(g.loot or {})
		end
		print(P .. ("boss guide: %d dungeons, %d bosses, %d items; you are in map %s; target npc %s"):format(#Order(), nB,
			nL, tostring(ns.ForeverCurrentDungeonMap and ns.ForeverCurrentDungeonMap()), tostring(NpcOf("target"))))
		return
	end
	ns.ShowForeverDungeonGuide()
end
