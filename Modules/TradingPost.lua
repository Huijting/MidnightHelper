--[[
	Trading Post tab — this month's Trading Post wares, their Trader's Tender price,
	whether you have already bought them this month, and whether you already own the
	collectible. Fed by Blizzard's Perks Program API (C_PerksProgram), all confirmed live
	on Rob's client (10 jul): GetAvailableVendorItemIDs / GetVendorItemInfo (fields name,
	price, purchased, itemID, quality, speciesID, mountID, perksVendorCategoryID),
	GetCurrencyAmount, GetTimeRemaining.

	THE "COLD" PROBLEM. GetAvailableVendorItemIDs returns an EMPTY list until the Trading
	Post UI has been opened once this session — there is no request-the-wares call. So we
	CACHE the month's list (account-wide, since the selection is account-wide) the moment
	the data loads (PERKS_PROGRAM_DATA_REFRESH). After one open, every character sees the
	list all month without returning to the Post. Trader's Tender is always readable via
	the ordinary currency API, so the header is never blank.
]]

local _, ns = ...

local TENDER_CURRENCY = 2032 -- Trader's Tender (verified via Syndicator)

--------------------------------------------------------------------------------
-- Month key + always-available bits
--------------------------------------------------------------------------------

-- The Post resets on the 1st, so the calendar month is the cache key. A cached list from
-- a different month is stale and ignored until the Post is opened again.
local function MonthKey()
	if C_DateAndTime and C_DateAndTime.GetCurrentCalendarTime then
		local ok, t = pcall(C_DateAndTime.GetCurrentCalendarTime)
		if ok and type(t) == "table" and t.year and t.month then
			return ("%d-%02d"):format(t.year, t.month)
		end
	end
	if date then
		return date("%Y-%m")
	end
	return "?"
end

local function TraderTender()
	if C_PerksProgram and C_PerksProgram.GetCurrencyAmount then
		local ok, n = pcall(C_PerksProgram.GetCurrencyAmount)
		if ok and type(n) == "number" then
			return n
		end
	end
	if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local ok, ci = pcall(C_CurrencyInfo.GetCurrencyInfo, TENDER_CURRENCY)
		if ok and type(ci) == "table" and type(ci.quantity) == "number" then
			return ci.quantity
		end
	end
	return nil
end

local function TenderIcon(size)
	if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local ok, ci = pcall(C_CurrencyInfo.GetCurrencyInfo, TENDER_CURRENCY)
		if ok and type(ci) == "table" and ci.iconFileID then
			return ("|T%d:%d:%d:0:0|t"):format(ci.iconFileID, size or 14, size or 14)
		end
	end
	return ""
end

local function TimeRemaining()
	if C_PerksProgram and C_PerksProgram.GetTimeRemaining then
		local ok, sec = pcall(C_PerksProgram.GetTimeRemaining)
		if ok and type(sec) == "number" and sec > 0 then
			return sec
		end
	end
	-- GetTimeRemaining came back empty in-game (Rob 10 jul), and the Post always resets
	-- on the 1st, so compute it ourselves: seconds until 00:00 on the 1st of next month.
	if date and time then
		local ok, now = pcall(date, "*t")
		if ok and type(now) == "table" and now.year and now.month then
			local y, m = now.year, now.month + 1
			if m > 12 then
				m, y = 1, y + 1
			end
			local okE, resetE = pcall(time, { year = y, month = m, day = 1, hour = 0, min = 0, sec = 0 })
			local okN, nowE = pcall(time)
			if okE and okN and type(resetE) == "number" and type(nowE) == "number" and resetE > nowE then
				return resetE - nowE
			end
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- Reading the wares (live) and the account-wide monthly cache
--------------------------------------------------------------------------------

-- @return items|nil, complete(bool). `complete` is false until every ware has its
-- itemID — the perks data streams in, and GetVendorItemInfo returns price/purchased
-- before name/itemID load. We must not cache an itemID-less snapshot: another character
-- reads it cold and has nothing to resolve names from (that left the list nameless).
local function ReadLiveItems()
	if not (C_PerksProgram and C_PerksProgram.GetAvailableVendorItemIDs and C_PerksProgram.GetVendorItemInfo) then
		return nil
	end
	local okIDs, ids = pcall(C_PerksProgram.GetAvailableVendorItemIDs)
	if not okIDs or type(ids) ~= "table" or #ids == 0 then
		return nil -- "cold": the Post has not been opened this session
	end
	local out, complete = {}, true
	for _, id in ipairs(ids) do
		local ok, info = pcall(C_PerksProgram.GetVendorItemInfo, id)
		if ok and type(info) == "table" then
			if not info.itemID then
				complete = false
			end
			out[#out + 1] = {
				vendorItemID = info.perksVendorItemID or id,
				itemID = info.itemID, -- the key we resolve name/icon from, char-independently
				price = info.price,
				quality = info.quality,
				purchased = info.purchased and true or false,
				speciesID = info.speciesID,
				mountID = info.mountID,
				categoryID = info.perksVendorCategoryID,
			}
		end
	end
	return (#out > 0) and out or nil, complete
end

-- Category id -> display name, plus the vendor's own category order. GetCategoryInfo's
-- name is under `displayName` (confirmed in-game: category 2 = "Mounts"). Cached with the
-- items so a cold character shows the real headers, not bare IDs.
local function ReadCategories()
	if not (C_PerksProgram and C_PerksProgram.GetAvailableCategoryIDs and C_PerksProgram.GetCategoryInfo) then
		return nil, nil
	end
	local okIDs, ids = pcall(C_PerksProgram.GetAvailableCategoryIDs)
	if not okIDs or type(ids) ~= "table" or #ids == 0 then
		return nil, nil
	end
	local names, order = {}, {}
	for _, id in ipairs(ids) do
		order[#order + 1] = id
		local ok, info = pcall(C_PerksProgram.GetCategoryInfo, id)
		if ok and type(info) == "table" and info.displayName then
			names[id] = info.displayName
		end
	end
	return names, order
end

-- Snapshot the fully-loaded list + categories into the account-wide monthly cache.
local function RefreshCache(items, categories, order)
	if not items then
		return
	end
	ns.db = ns.db or {}
	ns.db.tradingPostCache = { month = MonthKey(), items = items, categories = categories, order = order }
end

--- Everything the panel needs.
--- @return table { items|nil, categories|nil, order|nil, tender|nil, timeRemaining|nil, isLive, cold }
---   items = the month's wares (live if loaded, else this month's cache, else nil).
---   categories = { [categoryID] = displayName }; order = vendor category order.
---   cold  = true when we have no list at all and the Post must be opened once.
function ns.GetTradingPostData()
	local live, complete = ReadLiveItems()
	local names, order = ReadCategories()
	if live and complete then
		RefreshCache(live, names, order) -- only persist a fully-loaded snapshot
	end
	local mk = MonthKey()
	local cache = ns.db and ns.db.tradingPostCache
	local fromCache = cache and cache.month == mk
	local items = live or (fromCache and cache.items) or nil
	return {
		items = items,
		categories = names or (fromCache and cache.categories) or nil,
		order = order or (fromCache and cache.order) or nil,
		tender = TraderTender(),
		timeRemaining = TimeRemaining(),
		isLive = live ~= nil,
		cold = items == nil,
	}
end

--- Name + icon for a ware, resolved from its itemID via the item cache — so any
--- character shows real names, not whatever the perks data had loaded when it was
--- cached. Returns nil name until the item streams in; the panel re-renders on
--- GET_ITEM_INFO_RECEIVED. Requests the load so it actually arrives.
function ns.ResolveTradingPostItem(it)
	local id = it and it.itemID
	if not id then
		return nil, nil
	end
	local name, icon
	if C_Item then
		if C_Item.GetItemNameByID then
			name = C_Item.GetItemNameByID(id)
		end
		if C_Item.GetItemIconByID then
			icon = C_Item.GetItemIconByID(id)
		end
		if not name and C_Item.RequestLoadItemDataByID then
			pcall(C_Item.RequestLoadItemDataByID, id)
		end
	end
	return name, icon
end

--- Do you already own this collectible (independent of buying it this month)?
function ns.TradingPostItemOwned(it)
	if not it then
		return false
	end
	if it.mountID and it.mountID > 0 and C_MountJournal and C_MountJournal.GetMountInfoByID then
		local info = { pcall(C_MountJournal.GetMountInfoByID, it.mountID) }
		-- 12th value of GetMountInfoByID is `isCollected`.
		if info[1] and info[12] == true then
			return true
		end
	end
	if it.speciesID and it.speciesID > 0 and C_PetJournal and C_PetJournal.GetNumCollectedInfo then
		local ok, numCollected = pcall(C_PetJournal.GetNumCollectedInfo, it.speciesID)
		if ok and type(numCollected) == "number" and numCollected > 0 then
			return true
		end
	end
	return false
end

--- "21d 8h" / "8h 30m" — nil when unknown.
function ns.FormatTradingPostReset(sec)
	if not sec or sec <= 0 then
		return nil
	end
	local d = math.floor(sec / 86400)
	local h = math.floor((sec % 86400) / 3600)
	if d > 0 then
		return ("%dd %dh"):format(d, h)
	end
	local m = math.floor((sec % 3600) / 60)
	return ("%dh %dm"):format(h, m)
end

ns.TradingPostTenderIcon = TenderIcon

--------------------------------------------------------------------------------
-- Panel (mirrors MountsPanel: title, dynamic subtitle, scroll list of item rows)
--------------------------------------------------------------------------------

local SIDE_PAD, TOP_PAD, ROW_H, GAP = 14, 12, 16, 2

local C = ns.UI_COLORS or {}
local COLOR_DIM = C.dim or { 0.75, 0.78, 0.82 }
local COLOR_GOOD = C.good or { 0.45, 0.95, 0.5 }
local COLOR_SOFT = C.soft or { 0.9, 0.82, 0.45 }
local COLOR_WARN = C.warn or { 1, 0.84, 0.18 }
local COLOR_HEADER = C.header or { 1, 0.82, 0 }

local ICON_BOUGHT = "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t "

local ui

local function QualityHex(q)
	if q and _G.ITEM_QUALITY_COLORS and _G.ITEM_QUALITY_COLORS[q] then
		return _G.ITEM_QUALITY_COLORS[q].hex
	end
	return "|cffffffff"
end

--------------------------------------------------------------------------------
-- Floating preview (replaces the item tooltip). Rob found the game's tooltip — with
-- its "Equipped" stat comparison on wearable wares — noisy; he asked for an image
-- instead. A bordered frame beside the window shows a large appearance icon + name +
-- price + status, and nothing else. Same floating-panel trick as the mounts/rares tabs.
--------------------------------------------------------------------------------

local preview

local function EnsurePreview()
	if preview then
		return preview
	end
	local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	f:SetSize(170, 150)
	f:SetFrameStrata("TOOLTIP")
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 14,
			insets = { left = 4, right = 4, top = 4, bottom = 4 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.07, 0.96)
		f:SetBackdropBorderColor(0.55, 0.46, 0.3, 0.9)
	end
	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetSize(88, 88)
	icon:SetPoint("TOP", f, "TOP", 0, -12)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93) -- trim the default icon border
	f.icon = icon
	local name = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	name:SetPoint("TOP", icon, "BOTTOM", 0, -8)
	name:SetPoint("LEFT", f, "LEFT", 8, 0)
	name:SetPoint("RIGHT", f, "RIGHT", -8, 0)
	name:SetJustifyH("CENTER")
	name:SetWordWrap(true)
	f.name = name
	local info = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	info:SetPoint("TOP", name, "BOTTOM", 0, -4)
	info:SetJustifyH("CENTER")
	f.info = info
	f:Hide()
	preview = f
	return f
end

local function HidePreview()
	if preview then
		preview:Hide()
	end
end

local function ShowPreview(row, it)
	local f = EnsurePreview()
	local name, icon = ns.ResolveTradingPostItem(it)
	f.icon:SetTexture(icon or 134400) -- 134400 = question-mark placeholder until it loads
	f.name:SetText((QualityHex(it.quality)) .. (name or ("item " .. tostring(it.itemID))) .. "|r")

	local bits = {}
	if it.price then
		bits[#bits + 1] = it.price .. " " .. TenderIcon(13)
	end
	if it.purchased then
		bits[#bits + 1] = "|cff7dd97d" .. ns:L("TRADINGPOST_BOUGHT") .. "|r"
	elseif it._owned then
		bits[#bits + 1] = "|cff9090a0" .. ns:L("TRADINGPOST_OWNED") .. "|r"
	end
	f.info:SetText(table.concat(bits, "   "))

	f:ClearAllPoints()
	local main = ns.mainUI
	if main then
		f:SetPoint("TOPLEFT", main, "TOPRIGHT", 8, -2)
	else
		f:SetPoint("LEFT", row, "RIGHT", 12, 0)
	end
	f:Show()
end

local function AcquireRow(i)
	local row = ui.rows[i]
	if row then
		return row
	end
	row = CreateFrame("Button", nil, ui.child)
	row:SetHeight(ROW_H)
	local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	if ns.MHScalableFont then
		fs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	end
	fs:SetPoint("LEFT", row, "LEFT", 0, 0)
	fs:SetPoint("RIGHT", row, "RIGHT", 0, 0)
	fs:SetJustifyH("LEFT")
	row.fs = fs
	row:SetScript("OnEnter", function(self)
		if self._mhItem then
			ShowPreview(self, self._mhItem)
		end
	end)
	row:SetScript("OnLeave", HidePreview)
	ui.rows[i] = row
	return row
end

local function PutRow(i, text, color, y, width)
	local row = AcquireRow(i)
	row:ClearAllPoints()
	row:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
	row:SetWidth(width)
	row.fs:SetText(text)
	row.fs:SetTextColor(color[1], color[2], color[3])
	row:Show()
	return ROW_H + GAP
end

function ns.RefreshTradingPostPanel()
	if not ui or not ui.child then
		return
	end
	local data = ns.GetTradingPostData()

	-- Subtitle: tender balance + reset countdown (always available, even when "cold").
	local parts = {}
	if data.tender then
		parts[#parts + 1] = ns:L("TRADINGPOST_TENDER_FMT"):format(data.tender, TenderIcon(13))
	end
	local reset = ns.FormatTradingPostReset(data.timeRemaining)
	if reset then
		parts[#parts + 1] = ns:L("TRADINGPOST_RESET_FMT"):format(reset)
	end
	ui.subtitle:SetText(#parts > 0 and table.concat(parts, "   ") or ns:L("TRADINGPOST_SUBTITLE"))

	local width = math.max((ui.child:GetWidth() or 400), 1)
	local y, ri = 0, 1
	for _, r in ipairs(ui.rows) do
		r:Hide()
	end

	if data.cold or not data.items then
		y = y + PutRow(ri, ns:L("TRADINGPOST_COLD"), COLOR_WARN, y, width)
		ui.child:SetHeight(y + 4)
		return
	end

	local tender = TenderIcon(13)
	for _, it in ipairs(data.items) do
		it._owned = ns.TradingPostItemOwned(it)
		it._done = it.purchased or it._owned
	end

	-- One item row. `y`/`ri` are the enclosing function's locals; the closure advances
	-- them. Name + icon come from the itemID (item cache), never a possibly-empty cached
	-- perks name — that's why another character showed a nameless list. Bought-this-month
	-- wins over owned (buying a collectible makes you own it, so owned-first mislabelled
	-- things bought this month; "already owned" is then reserved for what you had before).
	local function renderItem(it)
		local rname, ricon = ns.ResolveTradingPostItem(it)
		local iconStr = ricon and ("|T%d:%d:%d:0:0|t "):format(ricon, 18, 18) or ""
		local name = (QualityHex(it.quality)) .. (rname or ("item " .. tostring(it.itemID))) .. "|r"
		local price = it.price and (" — " .. it.price .. " " .. tender) or ""
		local suffix, color
		if it.purchased then
			suffix, color = "  " .. ICON_BOUGHT .. ns:L("TRADINGPOST_BOUGHT"), COLOR_GOOD
		elseif it._owned then
			suffix, color = "  |cff9090a0(" .. ns:L("TRADINGPOST_OWNED") .. ")|r", COLOR_DIM
		else
			suffix, color = "", COLOR_SOFT
		end
		local row = AcquireRow(ri)
		row._mhItem = it
		y = y + PutRow(ri, iconStr .. name .. price .. suffix, color, y, width)
		ri = ri + 1
	end

	-- Within any group: actionable first (cheapest first), then bought/owned dimmed.
	local function byActionThenPrice(a, b)
		if a._done ~= b._done then
			return not a._done
		end
		return (a.price or 0) < (b.price or 0)
	end

	local cats = data.categories
	if cats and next(cats) then
		-- Grouped by the vendor's own categories (Mounts, Weapons, Appearances, …). 43
		-- items in one flat list is a lot; the split the player sees at the Post is natural.
		local buckets, seen = {}, {}
		for _, it in ipairs(data.items) do
			local cid = it.categoryID or 0
			if not buckets[cid] then
				buckets[cid] = {}
				seen[#seen + 1] = cid
			end
			buckets[cid][#buckets[cid] + 1] = it
		end
		-- Vendor's category order first, then any leftover buckets.
		local orderList, placed = {}, {}
		for _, cid in ipairs(data.order or {}) do
			if buckets[cid] then
				orderList[#orderList + 1] = cid
				placed[cid] = true
			end
		end
		for _, cid in ipairs(seen) do
			if not placed[cid] then
				orderList[#orderList + 1] = cid
			end
		end
		for ci, cid in ipairs(orderList) do
			table.sort(buckets[cid], byActionThenPrice)
			if ci > 1 then
				y = y + GAP
			end
			y = y + PutRow(ri, cats[cid] or ns:L("TRADINGPOST_CAT_OTHER"), COLOR_HEADER, y, width)
			ri = ri + 1
			for _, it in ipairs(buckets[cid]) do
				renderItem(it)
			end
		end
	else
		-- No category names yet (cold cache from before categories were stored): flat list,
		-- actionable first, a single "already bought / owned" divider.
		local items = {}
		for _, it in ipairs(data.items) do
			items[#items + 1] = it
		end
		table.sort(items, byActionThenPrice)
		local doneShown = false
		for _, it in ipairs(items) do
			if it._done and not doneShown then
				doneShown = true
				y = y + GAP
				y = y + PutRow(ri, ns:L("TRADINGPOST_DONE_HEADER"), COLOR_DIM, y, width)
				ri = ri + 1
			end
			renderItem(it)
		end
	end
	ui.child:SetHeight(y + 4)
end

function ns.BuildTradingPostPanel(panel)
	if not panel or panel._mhTPBuilt then
		return
	end
	panel._mhTPBuilt = true
	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	if ns.MHScalableFont then
		title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	end
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("TAB_TRADINGPOST"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	if ns.MHScalableFont then
		subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	end
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	subtitle:SetText(ns:L("TRADINGPOST_SUBTITLE"))

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperTradingPostScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)

	ui = { panel = panel, title = title, subtitle = subtitle, scroll = scroll, child = child, rows = {} }

	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
		end
		if panel:IsShown() then
			ns.RefreshTradingPostPanel()
		end
	end
	scroll:SetScript("OnSizeChanged", syncWidth)
	syncWidth()
	panel:SetScript("OnShow", function()
		syncWidth()
		ns.RefreshTradingPostPanel()
	end)
	panel:SetScript("OnHide", HidePreview)
end

--------------------------------------------------------------------------------
-- Keep the panel current: cache the list the instant the (complete) Perks data loads,
-- and re-render when item names/icons stream in so a cold cache fills in its names.
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
ev:RegisterEvent("PERKS_PROGRAM_DATA_REFRESH")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
ev:SetScript("OnEvent", function(_, event)
	if event == "PERKS_PROGRAM_DATA_REFRESH" then
		local items, complete = ReadLiveItems()
		if items and complete then
			local names, order = ReadCategories()
			RefreshCache(items, names, order)
		end
	end
	-- GET_ITEM_INFO_RECEIVED fires constantly game-wide; only re-render when the tab is
	-- actually on screen (a name/icon just streamed in that we want to show).
	if ns.RefreshTradingPostPanel and ui and ui.panel and ui.panel:IsShown() then
		ns.RefreshTradingPostPanel()
	end
end)
