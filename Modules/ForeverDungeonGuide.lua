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
--- With `split`, the loot is left out of the text and comes back as a second value: a list of { item = id, text = line }
--- plus the note line as a third. The window draws those as rows of their own, so each item gets the game's tooltip
--- (Rob, 19 Nov 2026: "overal waar een tooltip bestaat in de game wil ik ook in de addon zien"). Links inside a font
--- string do not answer the mouse inside a ScrollFrame (PlayCardWindow.lua:99, DelveTipMarkup.lua:483), so: rows.
function ns.ForeverDungeonGuideText(map, split)
	local g = Data()[map]
	if not g then
		return ns:L("FDG_NONE")
	end
	local parts = {}
	local headAt = {} -- line index in `parts` -> boss, for the boss-name lines (split mode: their own hover row)
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
		headAt[#parts] = b
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
	local rows, note
	if g.loot and #g.loot > 0 then
		parts[#parts + 1] = "|cffdbb56b" .. ns:L("FDG_LOOT_HEAD") .. "|r"
		rows = {}
		for _, l in ipairs(g.loot) do
			local name = ItemName(l.item)
			local boss = byNpc[l.boss]
			local line = ("   %s%s%s|r  %s"):format(l.part and ("|cff9d9d9d" .. PartName(l.part) .. ":|r ") or "",
				ItemColor(l.item), name or ("#" .. l.item), ns:L(l.role))
				.. (boss and ("  |cff9d9d9d" .. ns:L("FDG_FROM_FMT"):format(BossName(boss)) .. "|r") or "")
			rows[#rows + 1] = { item = l.item, text = line }
			if not split then
				parts[#parts + 1] = line
			end
		end
		note = "|cff9d9d9d" .. ns:L("FDG_LOOT_NOTE") .. "|r"
		if not split then
			parts[#parts + 1] = note
		end
	end
	if split then
		-- Fourth value: the same text cut into blocks; a boss-name line is a block of its own with `boss`, so the window
		-- can give it a hover (the 3D model, 19 Nov 2026). Joined with "\n" the blocks are the first value again.
		local blocks, cur = {}, {}
		for i, line in ipairs(parts) do
			if headAt[i] then
				if #cur > 0 then
					blocks[#blocks + 1] = { text = table.concat(cur, "\n") }
					cur = {}
				end
				blocks[#blocks + 1] = { text = line, boss = headAt[i] }
			else
				cur[#cur + 1] = line
			end
		end
		if #cur > 0 then
			blocks[#blocks + 1] = { text = table.concat(cur, "\n") }
		end
		return table.concat(parts, "\n"), rows or {}, note, blocks
	end
	return table.concat(parts, "\n")
end

--------------------------------------------------------------------------------
-- 3D model on hover (19 Nov 2026). Rob via sparring: "wanneer ik bijvoorbeeld op Captain Greenskin ga staan, dat we ook
-- plaatjes krijgen ... dat moet geen apart groot scherm worden ... puur luxe extra"; "Ja, dat klopt uiteindelijk wel."
-- Mouse on a boss name in the guide → a small frame beside the guide with the boss turning (PlayerModel:SetCreature
-- with the boss's npc id, b.npc). Leave the name → gone. Whether SetCreature draws an npc the client has not seen yet
-- is NOT measured in Forever: when no model loaded after 1.5 s the frame hides itself (as the trainer model does,
-- ForeverTrainer.lua ShowModel) — no empty black box.
--------------------------------------------------------------------------------
local modelFrame
local modelToken = 0

local function ModelFrame()
	if modelFrame then
		return modelFrame
	end
	local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate") -- unnamed: a hover picture, not a window
	f:SetSize(200, 240)
	f:SetFrameStrata("TOOLTIP")
	f:SetClampedToScreen(true)
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	f:SetBackdropColor(0.04, 0.04, 0.06, 0.95)
	f:SetBackdropBorderColor(0.6, 0.5, 0.2, 0.9)
	f.m = CreateFrame("PlayerModel", nil, f)
	f.m:SetPoint("TOPLEFT", 6, -6)
	f.m:SetPoint("BOTTOMRIGHT", -6, 24)
	f.m:SetScript("OnUpdate", function(self, elapsed)
		self._facing = ((self._facing or 0.45) + elapsed * 0.6) % (2 * math.pi)
		if self.SetFacing then
			pcall(self.SetFacing, self, self._facing)
		end
	end)
	f.name = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	f.name:SetPoint("BOTTOMLEFT", 6, 6)
	f.name:SetPoint("BOTTOMRIGHT", -6, 6)
	f.name:SetJustifyH("CENTER")
	f:Hide()
	modelFrame = f
	return f
end

local function HideModel()
	modelToken = modelToken + 1
	if modelFrame then
		modelFrame:Hide()
	end
end

local function ShowModel(b)
	local npc = b and b.npc
	if not (npc and win and win:IsShown()) then
		HideModel()
		return
	end
	local f = ModelFrame()
	if not f.m.SetCreature then
		return
	end
	modelToken = modelToken + 1
	local token = modelToken
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", win, "TOPRIGHT", 6, -40)
	f.name:SetText(BossName(b))
	local function apply()
		f.m:ClearModel()
		f.m:SetCreature(npc)
		if f.m.SetPortraitZoom then
			f.m:SetPortraitZoom(0) -- the whole figure
		end
		if f.m.SetCamDistanceScale then
			f.m:SetCamDistanceScale(1.0)
		end
		if f.m.SetPosition then
			f.m:SetPosition(0, 0, 0)
		end
	end
	if not pcall(apply) then
		f:Hide()
		return
	end
	f:Show()
	if not (C_Timer and C_Timer.After) then
		return
	end
	-- Models load async: once more, then hide the frame if nothing loaded.
	C_Timer.After(0.2, function()
		if token == modelToken and f:IsShown() then
			pcall(apply)
		end
	end)
	C_Timer.After(1.5, function()
		if token ~= modelToken or not f.m.GetModelFileID then
			return
		end
		local ok, fid = pcall(f.m.GetModelFileID, f.m)
		if ok and (fid == nil or fid == 0) then
			f:Hide()
		end
	end)
end

-- The game's own item tooltip on a loot row; shift-click puts the link in chat, as on any item in the game.
local function LootEnter(self)
	if not (GameTooltip and self.item) then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	pcall(GameTooltip.SetHyperlink, GameTooltip, "item:" .. self.item)
	GameTooltip:Show()
end

local function LootLeave()
	if GameTooltip then
		GameTooltip:Hide()
	end
end

-- The game's own handler, like RaidShoppingList.lua:520 (shift = chat link, ctrl = dressing room); ChatEdit_InsertLink
-- only as a fallback (a deprecation alias in 12.1, same note there).
local function LootClick(self)
	if not (self.item and IsModifierKeyDown and IsModifierKeyDown()) then
		return
	end
	local info = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	local ok, _, link = pcall(info, self.item)
	if not (ok and type(link) == "string") then
		return
	end
	if HandleModifiedItemClick and HandleModifiedItemClick(link) then
		return
	end
	if IsModifiedClick and IsModifiedClick("CHATLINK") and ChatEdit_InsertLink then
		pcall(ChatEdit_InsertLink, link)
	end
end

--- One reusable row per loot line, under the body text (so the mouse finds it inside the ScrollFrame).
local function LootRow(f, i)
	f.lootRows = f.lootRows or {}
	local r = f.lootRows[i]
	if r then
		return r
	end
	r = CreateFrame("Button", nil, f.child)
	f._mhNewFs = true -- Fill skins and measures again (a string made after the window opened has no skin font yet)
	r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.text:SetPoint("TOPLEFT", 0, 0)
	r.text:SetJustifyH("LEFT")
	r.text:SetJustifyV("TOP")
	local hl = r:CreateTexture(nil, "HIGHLIGHT")
	hl:SetAllPoints()
	hl:SetColorTexture(1, 1, 1, 0.08)
	r.hl = hl
	r:SetScript("OnEnter", LootEnter)
	r:SetScript("OnLeave", LootLeave)
	r:SetScript("OnClick", LootClick)
	f.lootRows[i] = r
	return r
end

local Fill

-- 19 Nov 2026 (Rob: "Excavation Site Wetlands, dat die niet helemaal erin past"; after the first fix, 2cc98f6: "staat nog
-- steeds buiten zijn grenzen"). Why that fix did nothing (GEMETEN in the code): it measured at Build, and the Forever
-- skin (ForeverStyle.lua SkinButton) sets its own, larger font on every button AFTER that, on show; a disabled button
-- (the chosen dungeon) swaps fonts too. So: measure every time the list is filled and once more after the skin's late
-- pass, and shrink with S.Font (RefreshFonts then keeps the small size). Still too wide at the smallest size: two lines.
local LABEL_ROOM = LEFT_W - 4 - 12
local LABEL_MIN = 8
local function FitLabel(b)
	local fs = b and b.GetFontString and b:GetFontString()
	if not fs then
		return
	end
	fs:SetWidth(0) -- measure the whole name, not a width set last time
	fs:SetWordWrap(false)
	local file, size, flags = fs:GetFont()
	size = math.floor((size or 12) + 0.5)
	local w = fs:GetStringWidth() or 0
	b._mhLabelW = w
	if w <= LABEL_ROOM then
		return
	end
	while size > LABEL_MIN and (fs:GetStringWidth() or 0) > LABEL_ROOM do
		size = size - 1
		if S and S.Font and file then
			S.Font(fs, file, size, "Fonts\\FRIZQT__.TTF", flags)
		elseif file then
			fs:SetFont(file, size, flags or "")
		end
	end
	b._mhLabelSize = size
	fs:SetWidth(LABEL_ROOM)
	if (fs:GetStringWidth() or 0) > LABEL_ROOM then
		fs:SetWordWrap(true)
		if fs.SetMaxLines then
			fs:SetMaxLines(2)
		end
	end
end

local function FitLabels(f)
	for _, b in ipairs(f and f.btns or {}) do
		FitLabel(b)
	end
end

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
		-- Long names: FitLabel (after the Forever skin, which sets its own larger font on every button), see below.
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
	f:HookScript("OnHide", HideModel) -- the boss model never stays behind on its own
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
	FitLabels(f) -- after SetEnabled above: a disabled button swaps its font
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
	local text, rows, note, blocks = ns:L("FDG_NONE"), {}, nil, nil
	if selected then
		text, rows, note, blocks = ns.ForeverDungeonGuideText(selected, true)
	end
	local width = f.body:GetWidth() or (W - 200)
	local y = 0
	-- 19 Nov 2026: the text as blocks, one font string each; a boss name is a block of its own with a hover area that
	-- shows his 3D model beside the guide (ShowModel). Without blocks (no guide for this map): the one body text.
	f.blockFs, f.blockHot = f.blockFs or {}, f.blockHot or {}
	local nb = 0
	if blocks then
		f.body:SetText("")
		for i, blk in ipairs(blocks) do
			nb = i
			local fs = f.blockFs[i]
			if not fs then
				fs = f.child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				fs:SetJustifyH("LEFT")
				fs:SetJustifyV("TOP")
				if fs.SetSpacing then
					fs:SetSpacing(3)
				end
				f.blockFs[i] = fs
				f._mhNewFs = true
			end
			fs:SetWidth(width)
			fs:ClearAllPoints()
			fs:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, -y)
			fs:SetText(blk.text)
			fs:Show()
			local h = math.max(12, fs:GetStringHeight() or 12)
			local hot = f.blockHot[i]
			if blk.boss and blk.boss.npc then
				if not hot then
					hot = CreateFrame("Frame", nil, f.child)
					hot:EnableMouse(true)
					hot:SetScript("OnEnter", function(self)
						ShowModel(self.boss)
					end)
					hot:SetScript("OnLeave", HideModel)
					f.blockHot[i] = hot
				end
				hot.boss = blk.boss
				hot:ClearAllPoints()
				hot:SetPoint("TOPLEFT", fs, "TOPLEFT")
				hot:SetSize(math.max(20, math.min(width, fs:GetStringWidth() or width)), h)
				hot:Show()
			elseif hot then
				hot:Hide()
				hot.boss = nil
			end
			y = y + h + 3
		end
	else
		f.body:SetText(text)
		y = (f.body:GetStringHeight() or 0) + 3
	end
	for i = nb + 1, #f.blockFs do
		f.blockFs[i]:Hide()
		if f.blockHot[i] then
			f.blockHot[i]:Hide()
		end
	end
	-- Loot rows under the text: one Button each, so the item's own tooltip shows on hover (19 Nov 2026).
	local n = 0
	for _, l in ipairs(rows or {}) do
		n = n + 1
		local r = LootRow(f, n)
		r.item = l.item
		r:EnableMouse(true)
		r.hl:Show()
		r.text:SetWidth(width)
		r.text:SetText(l.text)
		local h = math.max(14, r.text:GetStringHeight() or 14)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, -y)
		r:SetSize(width, h)
		r:Show()
		y = y + h + 3
	end
	if note then
		n = n + 1
		local r = LootRow(f, n)
		r.item = nil
		r:EnableMouse(false) -- the note is text, not an item: no hover, no highlight
		r.hl:Hide()
		r.text:SetWidth(width)
		r.text:SetText(note)
		local h = math.max(14, r.text:GetStringHeight() or 14)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, -y)
		r:SetSize(width, h)
		r:Show()
		y = y + h + 3
	end
	for i = n + 1, #(f.lootRows or {}) do
		f.lootRows[i]:Hide()
	end
	f.child:SetHeight(math.max(10, y + 10))
	-- New text strings this fill (another dungeon, more blocks or loot rows): give them the Forever skin font now and lay
	-- out once more, so heights are measured in the font that is drawn (Rob's screenshot, 19 Nov 2026: long loot lines on
	-- two rows). The skin skips strings it already did; the flag stops a loop.
	if f._mhNewFs and not f._mhRefill and S and S.SkinWindow and f:IsShown() then
		f._mhNewFs = nil
		f._mhRefill = true
		S.SkinWindow(f, f.title)
		Fill()
		f._mhRefill = nil
		return
	end
	f._mhNewFs = nil
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
		-- The skin's late pass (ForeverStyle.lua SkinOnShow: 0.1 s) sets fonts again (RefreshFonts); fill once more after
		-- it, so the list names are fitted and the text heights measured in the drawn font.
		C_Timer.After(0.25, function()
			if win and win:IsShown() then
				Fill()
			end
		end)
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

--------------------------------------------------------------------------------
-- Small boss card (19 Nov 2026). Rob via sparring: "als ik zo meteen een baas aanklik in een dungeon, krijg ik dan
-- hetzelfde scherm te zien? Of ... een kleiner, wat makkelijker scherm ... dit vult best wel weer veel beeld"; "Ja, dat
-- klopt uiteindelijk wel." Inside a dungeon, targeting a boss of this guide shows ONE small card: his name, what he
-- does, the tip. Another target (not a boss of the guide) hides it again. Not while the big guide is open (that one
-- already marks him). A switch in Quiet helpers (players choose; on by default): ns.db.foreverBossCard ~= false.
-- Silence rule: /mh bosses check says whether the card is on and why it did (not) show.
--------------------------------------------------------------------------------
local CARD_W = 300
local card
local cardWhy = "no boss targeted yet"

function ns.IsForeverBossCardOn()
	return not (type(ns.db) == "table" and ns.db.foreverBossCard == false)
end

function ns.SetForeverBossCard(on)
	if type(ns.db) ~= "table" then
		return
	end
	-- Not `(not on) and false or nil`: that is always nil in Lua (lint [29]; the Moving portrait trap of 18 Nov).
	if on then
		ns.db.foreverBossCard = nil
	else
		ns.db.foreverBossCard = false
		if card then
			card:Hide()
		end
	end
end

--- The lines for one boss, the same as on his part of the big guide.
local function BossLines(b)
	local out = {}
	for _, k in ipairs(b.does or {}) do
		out[#out + 1] = ns:L(k)
	end
	if b.tip then
		out[#out + 1] = "|cffeeb055" .. ns:L("FDG_TIP") .. "|r " .. ns:L(b.tip)
	end
	if b.one then
		out[#out + 1] = "|cff9d9d9d" .. ns:L("FDG_ONE_SOURCE") .. "|r"
	end
	return out
end

local function BuildCard()
	if card then
		return card
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverBossCard", UIParent, "BackdropTemplate")
	f:SetSize(CARD_W, 120)
	f:SetFrameStrata("MEDIUM")
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	local pos = type(ns.db) == "table" and ns.db.foreverBossCardPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -260, -180)
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		if type(ns.db) == "table" then
			local p, _, rp, x, y = self:GetPoint(1)
			ns.db.foreverBossCardPos = { p, rp, x, y }
		end
	end)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.title:SetPoint("TOPLEFT", 12, -10)
	f.title:SetPoint("RIGHT", f, "RIGHT", -28, 0)
	f.title:SetJustifyH("LEFT")
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)
	close:SetScale(0.8)
	f.body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.body:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -6)
	f.body:SetWidth(CARD_W - 24)
	f.body:SetJustifyH("LEFT")
	f.body:SetJustifyV("TOP")
	if f.body.SetSpacing then
		f.body:SetSpacing(2)
	end
	f.open = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.open:SetSize(120, 20)
	f.open:SetPoint("BOTTOMRIGHT", -10, 8)
	f.open:SetScript("OnClick", function(self)
		f:Hide()
		ns.ShowForeverDungeonGuide(self.map)
	end)
	if S and S.SkinOnShow then
		S.SkinOnShow(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- Shift+scroll = size (the rule for every MH window), Escape closes
	end
	f:Hide()
	card = f
	return f
end

--- Show the card for boss `b` of dungeon `map` (nil = hide it).
local function ShowCard(map, b)
	if not b then
		if card then
			card:Hide()
		end
		return
	end
	local f = BuildCard()
	local head = BossName(b)
	if b.rare then
		head = head .. "  |cff9d9d9d" .. ns:L("FDG_RARE") .. "|r"
	end
	f.title:SetText(head)
	f.body:SetText(table.concat(BossLines(b), "\n"))
	f.open:SetText(ns:L("FDG_TITLE")) -- the guide's own name: this button opens it
	f.open.map = map
	f:SetHeight(10 + (f.title:GetStringHeight() or 14) + 6 + (f.body:GetStringHeight() or 14) + 10 + 20 + 10)
	f:Show()
end

local function CardDecision(map, b)
	if not ns.IsForeverBossCardOn() then
		return false, "switched off (Quiet helpers)"
	end
	if not b then
		return false, "target is not a boss of the guide"
	end
	local inInst = IsInInstance and select(1, IsInInstance())
	if not inInst then
		return false, "not inside a dungeon"
	end
	if win and win:IsShown() then
		return false, "the big guide is open (it marks him there)"
	end
	return true, "boss of the guide targeted inside a dungeon"
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_TARGET_CHANGED")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_TARGET_CHANGED" then
		local id = NpcOf("target")
		local found, boss
		for map, g in pairs(Data()) do
			for _, b in ipairs(g.bosses or {}) do
				if IsBoss(b, id) then
					found, boss = map, b
				end
			end
		end
		targetNpc = found and id or nil
		if found then
			selected = found
		end
		-- The small boss card (19 Nov 2026): shown or hidden, and why (for /mh bosses check).
		local show, why = CardDecision(found, boss)
		cardWhy = why
		ShowCard(found, show and boss or nil)
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
		print(("  small boss card: %s; last decision: %s"):format(ns.IsForeverBossCardOn() and "on" or "off", cardWhy))
		-- List labels (19 Nov 2026): every name wider than its button, what MH measured and the size it chose.
		if win and win.btns then
			local wide = 0
			for _, b in ipairs(win.btns) do
				local fs = b:GetFontString()
				local _, size = fs and fs:GetFont()
				-- _mhLabelSize stays set once a name was shrunk (later fills measure the already small name).
				if (b._mhLabelW or 0) > LABEL_ROOM or b._mhLabelSize then
					wide = wide + 1
					print(("  list: %s — measured %d px, room %d px, font now %s, drawn %d px"):format(tostring(fs and fs:GetText()),
						math.floor(b._mhLabelW + 0.5), LABEL_ROOM, tostring(size and math.floor(size + 0.5)),
						math.floor((fs and fs:GetStringWidth() or 0) + 0.5)))
				end
			end
			print(("  list: %d of %d names needed a smaller font (open the guide first to measure)"):format(wide, #win.btns))
		else
			print("  list: not built yet — open the guide once, then /mh bosses check again")
		end
		return
	end
	ns.ShowForeverDungeonGuide()
end
