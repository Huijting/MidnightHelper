local _, ns = ...

--[[
	Midnight Helper — "Klaar voor de raid?": a shopping list for a raid night (`/mh ready`).

	Rob, 5 Oct 2026, the evening of a raid: "een knop waarbij ik in één keer zie welke consumables ik nog
	even snel moet halen voor de raid, in plaats van alleen maar het hele overzicht te bekijken", and
	"kunnen we van de MH Ready niet een schermpje maken in plaats van alleen in de tekst?". He chose a
	switch at the top: learning a new boss (progression) or farm.

	One row per consumable: icon, the item your spec should use, how many you carry against how many a
	night needs, and in red how many to buy. Counts come from ConsumableReadyCheck.lua
	(ns.GetRaidShoppingData), the same bag counts as the chat check and the group board.
	Unknown is shown as "?", never as a zero (the client may not have the item cached yet).

	No secure buttons, nothing protected. Clicking a row searches the auction house (or shows the name to copy),
	shift-click links it, and "To Auctionator" hands the list to Auctionator — see "Buying" below. Nothing is bought.
]]

local MODES = { "prog", "farm" }
local ROW_H = 30
local WIDTH = 440

local win

local function L(k)
	return ns:L(k)
end

local function Mode()
	local m = ns.db and ns.db.ui and ns.db.ui.raidShopMode
	return (m == "farm") and "farm" or "prog"
end

local function SetMode(m)
	ns.db = ns.db or {}
	ns.db.ui = ns.db.ui or {}
	ns.db.ui.raidShopMode = m
end

local function ItemName(id)
	if not id then
		return nil
	end
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	if C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, id)
	end
	return nil
end

local function ItemIcon(id)
	if id and C_Item and C_Item.GetItemIconByID then
		local ok, icon = pcall(C_Item.GetItemIconByID, id)
		if ok and icon then
			return icon
		end
	end
	return 134400 -- question mark
end

local Refresh

--------------------------------------------------------------------------------
-- Buying (Rob, 6 Oct 2026: "kunnen we de items clickable maken ... zodat ik die eenvoudig in de AH kan kopen?",
-- and he wanted all four ways). Sources: mh-research 6 Oct, Blizzard UI source 12.1.0 (69933) and the installed
-- Auctionator's public API (v1). MH never buys anything itself: it searches, the player buys.
--------------------------------------------------------------------------------

local CALLER = "Midnight Helper"

--- One list per character. Rob, 6 Oct 2026: "wat gebeurt er als ik naar een andere char ga ... moeten we misschien
--- een naam meegeven?" — yes: CreateShoppingList replaces a list of the same name, so one shared name would let
--- the next character wipe this one's list.
local function ListName()
	local me = UnitName and UnitName("player")
	return (type(me) == "string" and me ~= "") and ("MH raid - " .. me) or "Midnight Helper raid"
end

local function ItemLink(id)
	if id and C_Item and C_Item.GetItemInfo then
		local ok, _, link = pcall(C_Item.GetItemInfo, id)
		if ok and type(link) == "string" then
			return link
		end
	end
	return nil
end

--- The name to search for. Rob, 6 Oct 2026 (screenshots): "Hearty Royal Roast" had no listing at all, while a
--- search for "Royal Roast" found Royal Roast and Impossibly Royal Roast. So for Hearty food we search without the
--- prefix: that finds the plain dish and, when someone sells one, the Hearty one too (Blizzard's search is a
--- substring search). Only the English prefix is known; other clients search the full name.
local function SearchName(id)
	local name = ItemName(id)
	local short = name and name:match("^Hearty (.+)$")
	return short or name, short ~= nil
end

--- Blizzard_AuctionHouseUI is load-on-demand, so AuctionHouseFrame is nil until the first visit.
local function AuctionHouseOpen()
	return AuctionHouseFrame and AuctionHouseFrame:IsShown() and true or false
end

--- 1) At the auction house: put the name in Blizzard's search bar and search. Order matters (measured in the
--- source): the bar clears its text OnShow, so first the Buy tab, then the text, then the search. The chosen
--- category on the left is cleared, as Blizzard's own search button does, or a category hides the potions.
local function SearchAuctionHouse(name)
	if not (name and AuctionHouseOpen()) or (InCombatLockdown and InCombatLockdown()) then
		return false
	end
	local f = AuctionHouseFrame
	return pcall(function()
		if not f:SetSearchText(name) then
			-- On the Sell/Auctions tab or an Auctionator tab SetSearchText refuses: go to Buy first.
			if f.BuyTab then
				f.BuyTab:Click()
			end
			f:SetSearchText(name)
		end
		local cats = f.GetCategoriesList and f:GetCategoriesList()
		if cats and cats.SetSelectedCategory then
			cats:SetSelectedCategory(nil)
		end
		f.SearchBar:StartSearch()
	end) == true
end

--- 3) Shift-click: a link in chat. ChatEdit_InsertLink is only a deprecation alias in 12.1; this is the live path.
local function LinkInChat(id)
	local link = ItemLink(id)
	if not link then
		return
	end
	if HandleModifiedItemClick and HandleModifiedItemClick(link) then
		return
	end
	if ChatFrameUtil and ChatFrameUtil.LinkItem then
		pcall(ChatFrameUtil.LinkItem, id, link)
	end
end

local function Auctionator1()
	local a = _G.Auctionator
	return a and a.API and a.API.v1
end

local ShowCopy, SetStatus

local function OnRowClick(row)
	local id = row.itemID
	if not id or row.info then
		return -- Healthstone: nothing to buy
	end
	if IsModifiedClick and IsModifiedClick("CHATLINK") then
		LinkInChat(id)
		return
	end
	local name = ItemName(id)
	if not name then
		Refresh() -- the name was asked for; the event above redraws when it arrives
		return
	end
	if not SearchAuctionHouse((SearchName(id))) then
		ShowCopy(name) -- 2) elsewhere: the name to copy
	end
end

--- 4) Everything still to buy into Auctionator, with the amount filled in. At the auction house Auctionator
--- searches right away (MultiSearchAdvanced); elsewhere it becomes a shopping list "MH raid - <character>",
--- replaced each time (CreateShoppingList replaces a list of the same name, so it has our own name).
local function ToAuctionator()
	local api = Auctionator1()
	if not (api and win and win.buyList) then
		return
	end
	local terms = {}
	for _, b in ipairs(win.buyList) do
		local name, hearty = SearchName(b.id)
		if name and not name:find("[;^\"]") then
			-- Hearty food: not exact, so Auctionator shows the plain dish and any Hearty one (see SearchName).
			terms[#terms + 1] = { searchString = name, isExact = not hearty, quantity = b.qty }
		end
	end
	if #terms == 0 then
		SetStatus(L("RAIDSHOP_AUCTIONATOR_NOTHING"))
		return
	end
	local ok
	if AuctionHouseOpen() and api.MultiSearchAdvanced then
		ok = pcall(api.MultiSearchAdvanced, CALLER, terms)
		if ok then
			SetStatus(L("RAIDSHOP_AUCTIONATOR_SEARCH"))
		end
	elseif api.CreateShoppingList and api.ConvertToSearchString then
		ok = pcall(function()
			local strings = {}
			for _, t in ipairs(terms) do
				strings[#strings + 1] = api.ConvertToSearchString(CALLER, t)
			end
			api.CreateShoppingList(CALLER, ListName(), strings)
		end)
		if ok then
			SetStatus(L("RAIDSHOP_AUCTIONATOR_LIST_FMT"):format(ListName(), #terms))
		end
	end
	if not ok then
		SetStatus("|cffff8080" .. L("RAIDSHOP_AUCTIONATOR_FAILED") .. "|r")
	end
end

local function Build()
	local f = CreateFrame("Frame", "MidnightHelperRaidShoppingList", UIParent, "BackdropTemplate")
	f:SetSize(WIDTH, 120)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	if ns.ApplyMidnightDialogBackdrop then
		pcall(ns.ApplyMidnightDialogBackdrop, f)
	end
	tinsert(UISpecialFrames, "MidnightHelperRaidShoppingList") -- Escape closes it

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -14)
	f.title:SetTextColor(1, 0.82, 0.2)

	-- The switch Rob asked for: two buttons, the chosen one lit.
	f.modeBtns = {}
	for i, m in ipairs(MODES) do
		local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		b:SetSize((WIDTH - 40) / 2, 24)
		b:SetPoint("TOPLEFT", f, "TOPLEFT", 16 + (i - 1) * ((WIDTH - 40) / 2 + 8), -42)
		b:SetScript("OnClick", function()
			SetMode(m)
			Refresh()
		end)
		b.mode = m
		f.modeBtns[i] = b
	end

	f.intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.intro:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -74)
	f.intro:SetWidth(WIDTH - 32)
	f.intro:SetJustifyH("LEFT")
	f.intro:SetWordWrap(true)

	f.rows = {}
	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.foot:SetWidth(WIDTH - 32)
	f.foot:SetJustifyH("LEFT")
	f.foot:SetWordWrap(true)

	-- Bottom bar: the Auctionator button (only when Auctionator is loaded) and the copy box.
	f.auct = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.auct:SetSize(140, 22)
	f.auct:SetScript("OnClick", ToAuctionator)
	f.copyLabel = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.copy = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
	f.copy:SetSize(200, 20)
	f.copy:SetAutoFocus(false)
	f.copy:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	-- Typing must not change the name: put it back and select it again.
	f.copy:SetScript("OnTextChanged", function(self, user)
		if user and self.fixed then
			self:SetText(self.fixed)
			self:HighlightText()
		end
	end)
	f.copy:SetScript("OnEditFocusGained", function(self)
		self:HighlightText()
	end)
	f.copyLabel:Hide()
	f.copy:Hide()
	f.status = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.status:SetWidth(WIDTH - 32)
	f.status:SetJustifyH("LEFT")
	f.status:SetWordWrap(true)

	f:SetScript("OnEvent", function()
		if f:IsShown() then
			Refresh()
		end
	end)
	f:RegisterEvent("BAG_UPDATE_DELAYED")
	f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	-- C_Item.RequestLoadItemDataByID answers with this one, not GET_ITEM_INFO_RECEIVED. Rob's screenshot 6 Oct 2026:
	-- Food stayed "…" while Auctionator already had the name, so the window never heard the answer. (AFGELEID)
	f:RegisterEvent("ITEM_DATA_LOAD_RESULT")
	f:Hide()
	return f
end

local function Row(i)
	local r = win.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, win)
	r:SetSize(WIDTH - 32, ROW_H)
	r.icon = r:CreateTexture(nil, "ARTWORK")
	r.icon:SetSize(24, 24)
	r.icon:SetPoint("LEFT", r, "LEFT", 0, 0)
	r.label = r:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	r.label:SetPoint("TOPLEFT", r.icon, "TOPRIGHT", 8, 2)
	r.label:SetJustifyH("LEFT")
	r.item = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.item:SetPoint("TOPLEFT", r.label, "BOTTOMLEFT", 0, -1)
	r.item:SetWidth(220)
	r.item:SetJustifyH("LEFT")
	r.item:SetWordWrap(false)
	r.count = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.count:SetPoint("RIGHT", r, "RIGHT", -110, 0)
	r.count:SetJustifyH("RIGHT")
	r.status = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.status:SetPoint("RIGHT", r, "RIGHT", 0, 0)
	r.status:SetWidth(104)
	r.status:SetJustifyH("RIGHT")
	-- Tooltip of the item to buy, so the exact name and quality can be checked before the auction house.
	r:EnableMouse(true)
	r:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			OnRowClick(self)
		end
	end)
	r:SetScript("OnEnter", function(self)
		if self.itemID and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			pcall(GameTooltip.SetItemByID, GameTooltip, self.itemID)
			GameTooltip:Show()
		end
	end)
	r:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	win.rows[i] = r
	return r
end

Refresh = function()
	if not win then
		return
	end
	local mode = Mode()
	win.title:SetText(L("RAIDSHOP_TITLE"))
	for _, b in ipairs(win.modeBtns) do
		b:SetText(L(b.mode == "farm" and "RAIDSHOP_MODE_FARM" or "RAIDSHOP_MODE_PROG"))
		if b.mode == mode then
			b:LockHighlight()
		else
			b:UnlockHighlight()
		end
	end
	win.intro:SetText(L(mode == "farm" and "RAIDSHOP_INTRO_FARM" or "RAIDSHOP_INTRO_PROG"))

	local rows, hasSpec = ns.GetRaidShoppingData(mode)
	local y = -74 - win.intro:GetStringHeight() - 10
	local missing = 0
	win.buyList = {}
	for i, d in ipairs(rows) do
		-- Optional rows (the augment rune) go along too: Rob, 6 Oct 2026, "ook de rune kwam niet in de shopping list".
		if d.itemID and not d.info and d.have and d.need > d.have then
			win.buyList[#win.buyList + 1] = { id = d.itemID, qty = d.need - d.have }
		end
		local r = Row(i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y)
		r.itemID = d.itemID
		r.info = d.info
		r.icon:SetTexture(ItemIcon(d.itemID))
		r.label:SetText(L(d.labelKey))
		r.item:SetText(ItemName(d.itemID) or (d.itemID and "…" or L("RAIDSHOP_NO_DATA")))
		if d.info then
			-- Healthstone: nothing to buy, a Warlock hands them out.
			r.count:SetText(d.have and tostring(d.have) or "?")
			r.status:SetText("|cff9aa0a8" .. L(d.info) .. "|r")
		elseif d.have == nil then
			r.count:SetText("? / " .. d.need)
			r.status:SetText("|cffffd100?|r")
		elseif d.need == 0 then
			r.count:SetText(tostring(d.have))
			r.status:SetText("|cff9aa0a8" .. L("RAIDSHOP_NOT_NEEDED") .. "|r")
		elseif d.have >= d.need then
			r.count:SetText(("%d / %d"):format(d.have, d.need))
			r.status:SetText("|cff40ff40" .. L("RAIDSHOP_ENOUGH") .. "|r")
		else
			r.count:SetText(("%d / %d"):format(d.have, d.need))
			if d.optional then
				r.status:SetText("|cffe8c36a" .. L("RAIDSHOP_OPTIONAL_FMT"):format(d.need - d.have) .. "|r")
			else
				missing = missing + 1
				r.status:SetText("|cffff5555" .. L("RAIDSHOP_BUY_FMT"):format(d.need - d.have) .. "|r")
			end
		end
		r:Show()
		y = y - ROW_H
	end
	for i = #rows + 1, #win.rows do
		win.rows[i]:Hide()
	end
	local foot = L("RAIDSHOP_FOOT") .. " " .. L("RAIDSHOP_CLICK_HINT")
	if not hasSpec then
		foot = L("RAIDSHOP_NO_DATA") .. " " .. foot
	elseif missing == 0 then
		foot = "|cff40ff40" .. L("RAIDSHOP_ALL_SET") .. "|r " .. foot
	end
	win.foot:SetText(foot)
	win.foot:ClearAllPoints()
	win.foot:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y - 6)
	y = y - 6 - win.foot:GetStringHeight() - 8

	-- Bottom bar: Auctionator button on the left (only when it is loaded), the copy box to its right.
	local x = 16
	if Auctionator1() then
		win.auct:SetText(L("RAIDSHOP_BTN_AUCTIONATOR"))
		win.auct:ClearAllPoints()
		win.auct:SetPoint("TOPLEFT", win, "TOPLEFT", x, y)
		win.auct:Show()
		x = x + 150
	else
		win.auct:Hide()
	end
	local barH = Auctionator1() and 24 or 0
	if win.copyText then
		win.copyLabel:SetText(L("RAIDSHOP_COPY_LABEL"))
		win.copyLabel:ClearAllPoints()
		win.copyLabel:SetPoint("TOPLEFT", win, "TOPLEFT", x, y - 5)
		win.copyLabel:Show()
		win.copy:ClearAllPoints()
		win.copy:SetPoint("LEFT", win.copyLabel, "RIGHT", 10, 0)
		win.copy:SetWidth(math.max(80, WIDTH - 16 - (x + win.copyLabel:GetStringWidth() + 10)))
		win.copy.fixed = win.copyText
		win.copy:SetText(win.copyText)
		win.copy:Show()
		barH = 24
	else
		win.copyLabel:Hide()
		win.copy:Hide()
	end
	y = y - barH
	if win.statusText then
		win.status:SetText(win.statusText)
		win.status:ClearAllPoints()
		win.status:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y - 4)
		win.status:Show()
		y = y - 4 - win.status:GetStringHeight()
	else
		win.status:Hide()
	end
	win:SetHeight(-y + 14)
end

ShowCopy = function(name)
	win.copyText = name
	Refresh()
	win.copy:SetFocus()
	win.copy:HighlightText()
end

SetStatus = function(text)
	win.statusText = text
	Refresh()
end

--- `/mh ready`: open (or close) the shopping list.
function ns.ShowRaidShoppingList()
	win = win or Build()
	if win:IsShown() then
		win:Hide()
		return
	end
	win.copyText, win.statusText = nil, nil
	Refresh()
	win:Show()
end
