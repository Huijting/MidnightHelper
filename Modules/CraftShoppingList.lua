local _, ns = ...

--[[
	Midnight Helper — a shopping list for your profession (`/mh craftshop`).

	Cisca via Rob, 6 Oct 2026: "een lijst waarbij ik kan zien wat ik nodig heb voor onder andere alchemie, wat ik
	moet gaan kopen of farmen". Rob chose: its own window, the amount is "times to craft", one list per character.

	How it works:
	  - In the profession window, MH's side panel offers "+ <recipe> on your shopping list". It reads the recipe the
	    player is looking at (ProfessionsFrame.CraftingPage.SchematicForm:GetRecipeInfo(), Blizzard's own Create
	    button reads it the same way) and its reagents (C_TradeSkillUI.GetRecipeSchematic). The reagents are stored
	    WITH the entry, so the list never needs the profession window again.
	  - The window adds up every reagent over all listed recipes and counts what you have the way Blizzard's own
	    crafting UI counts: all quality ranks of a reagent together (the ranks are separate item ids).
	  - Buying reuses the raid shopping list's helpers (ns.MHShop): bank / Warband bank / mail counts, click to search
	    the auction house, shift-click to link, and Auctionator.

	Sources: mh-research 6 Oct 2026, Blizzard UI 12.1.0 (69933): Blizzard_ProfessionsRecipeTracker (have/need over
	all ranks), Blizzard_ProfessionsCrafting (SchematicForm, OnRecipeSelected), ItemUtil.GetCraftingReagentCount.
	Not in v1: which rank to buy, reagents you craft yourself, vendor reagents, where to farm.

	Only Basic, required reagent slots are listed: optional and finishing reagents are a choice, not a need.
]]

local WIDTH = 460
local ROW_H = 30
local CALLER_LIST = "MH craft - "

local win
local Refresh

local function L(k)
	return ns:L(k)
end

local function Shop()
	return ns.MHShop or {}
end

local function MyGuid()
	local g = UnitGUID and UnitGUID("player")
	return type(g) == "string" and g or nil
end

--- This character's list: { { recipeID, name, icon, times, qmin, qmax, slots = { { ids = {..}, qty = n } } } }
local function MyList()
	local g = MyGuid()
	if not (g and ns.db) then
		return {}
	end
	ns.db.craftShop = ns.db.craftShop or {}
	ns.db.craftShop[g] = ns.db.craftShop[g] or { list = {} }
	return ns.db.craftShop[g].list
end

--------------------------------------------------------------------------------
-- Reading the recipe the player is looking at
--------------------------------------------------------------------------------

local function SchematicForm()
	local pf = _G.ProfessionsFrame
	local page = pf and pf.CraftingPage
	return page and page.SchematicForm or nil
end

--- @return table|nil recipeInfo, number|nil level
function ns.CraftShopCurrentRecipe()
	local pf = _G.ProfessionsFrame
	local sf = SchematicForm()
	if not (pf and pf:IsShown() and sf and sf.GetRecipeInfo) then
		return nil
	end
	local ok, info = pcall(sf.GetRecipeInfo, sf)
	if not ok or type(info) ~= "table" or not info.recipeID then
		return nil
	end
	local level
	if sf.GetCurrentRecipeLevel then
		local okL, lv = pcall(sf.GetCurrentRecipeLevel, sf)
		level = okL and lv or nil
	end
	return info, level
end

--- The reagents of a recipe: Basic, required slots only. @return table|nil entry, string|nil why
local function ReadRecipe(info, level)
	if not (C_TradeSkillUI and C_TradeSkillUI.GetRecipeSchematic) then
		return nil, "GetRecipeSchematic missing"
	end
	local ok, sch = pcall(C_TradeSkillUI.GetRecipeSchematic, info.recipeID, false, level)
	if not ok or type(sch) ~= "table" then
		return nil, "no schematic"
	end
	local basic = Enum and Enum.CraftingReagentType and Enum.CraftingReagentType.Basic
	local slots = {}
	for _, s in ipairs(sch.reagentSlotSchematics or {}) do
		if s.required and (basic == nil or s.reagentType == basic) and (s.quantityRequired or 0) > 0 then
			local ids = {}
			for _, r in ipairs(s.reagents or {}) do
				if type(r.itemID) == "number" then
					ids[#ids + 1] = r.itemID
				end
			end
			if #ids > 0 then -- a currency slot has no item id; it is not bought at the auction house
				slots[#slots + 1] = { ids = ids, qty = s.quantityRequired }
			end
		end
	end
	return {
		recipeID = info.recipeID,
		name = info.name or sch.name or ("recipe " .. tostring(info.recipeID)),
		icon = info.icon or sch.icon,
		qmin = sch.quantityMin, qmax = sch.quantityMax,
		slots = slots,
	}
end

--- Put the recipe on the list `times` times (added to it when it is there already).
function ns.CraftShopAdd(times)
	times = math.floor(tonumber(times) or 0)
	if times < 1 then
		return false
	end
	local info, level = ns.CraftShopCurrentRecipe()
	if not info then
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_NO_RECIPE")))
		return false
	end
	local entry, why = ReadRecipe(info, level)
	ns.db = ns.db or {}
	ns.db.craftShopProbe = { recipeID = info.recipeID, level = level, why = why,
		slots = entry and #entry.slots or nil, t = time and time() or 0 }
	if not entry then
		print(("|cffffcc00%s|r %s (%s)"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_NO_RECIPE"), tostring(why)))
		return false
	end
	local list = MyList()
	for _, e in ipairs(list) do
		if e.recipeID == entry.recipeID then
			e.times = (e.times or 0) + times
			e.slots = entry.slots -- the recipe may have changed with a patch: the newest read wins
			print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_ADDED_FMT"):format(e.times, e.name)))
			if win and win:IsShown() then
				Refresh()
			end
			return true
		end
	end
	entry.times = times
	list[#list + 1] = entry
	print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_ADDED_FMT"):format(times, entry.name)))
	if win and win:IsShown() then
		Refresh()
	end
	return true
end

--- Ask how many times, then add. A StaticPopup with an edit box: nothing protected.
if StaticPopupDialogs then
	StaticPopupDialogs["MH_CRAFTSHOP_ADD"] = {
		text = "%s",
		button1 = OKAY,
		button2 = CANCEL,
		hasEditBox = true,
		OnShow = function(self)
			local eb = self.editBox or self.EditBox
			if eb then
				eb:SetNumeric(true)
				eb:SetText("1")
				eb:HighlightText()
			end
		end,
		OnAccept = function(self)
			local eb = self.editBox or self.EditBox
			ns.CraftShopAdd(eb and eb:GetText())
		end,
		EditBoxOnEnterPressed = function(self)
			ns.CraftShopAdd(self:GetText())
			self:GetParent():Hide()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}
end

function ns.CraftShopAskAdd()
	local info = ns.CraftShopCurrentRecipe()
	if not info then
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_NO_RECIPE")))
		return
	end
	if StaticPopup_Show then
		StaticPopup_Show("MH_CRAFTSHOP_ADD", L("CRAFTSHOP_ASK_FMT"):format(info.name or "?"))
	end
end

function ns.CraftShopCount()
	return #MyList()
end

--------------------------------------------------------------------------------
-- The window
--------------------------------------------------------------------------------

local function SetStatus(text)
	if win then
		win.statusText = text
		Refresh()
	end
end

local function ShowCopy(name)
	if win then
		win.copyText = name
		Refresh()
		win.copy:SetFocus()
		win.copy:HighlightText()
	end
end

local function OnRowClick(row)
	local S = Shop()
	if not row.itemID then
		return
	end
	if IsModifiedClick and IsModifiedClick("CHATLINK") then
		if S.LinkInChat then
			S.LinkInChat(row.itemID)
		end
		return
	end
	local name = S.ItemName and S.ItemName(row.itemID)
	if not name then
		Refresh()
		return
	end
	if not (S.SearchAuctionHouse and S.SearchAuctionHouse(name)) then
		ShowCopy(name)
	end
end

local function ToAuctionator()
	local S = Shop()
	if not (S.SendTermsToAuctionator and win and win.buyList) then
		return
	end
	local terms = {}
	for _, b in ipairs(win.buyList) do
		local name = S.ItemName and S.ItemName(b.id)
		if name and not name:find("[;^\"]") then
			terms[#terms + 1] = { searchString = name, isExact = true, quantity = b.qty }
		end
	end
	local listName = CALLER_LIST .. ((UnitName and UnitName("player")) or "?")
	local result = S.SendTermsToAuctionator(terms, listName)
	if result == "nothing" then
		SetStatus(L("RAIDSHOP_AUCTIONATOR_NOTHING"))
	elseif result == "search" then
		SetStatus(L("RAIDSHOP_AUCTIONATOR_SEARCH"))
	elseif result == "list" then
		SetStatus(L("RAIDSHOP_AUCTIONATOR_LIST_FMT"):format(listName, #terms))
	else
		SetStatus("|cffff8080" .. L("RAIDSHOP_AUCTIONATOR_FAILED") .. "|r")
	end
end

local function Build()
	local f = CreateFrame("Frame", "MidnightHelperCraftShoppingList", UIParent, "BackdropTemplate")
	f:SetSize(WIDTH, 160)
	f:SetPoint("CENTER", UIParent, "CENTER", 120, 60)
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
	tinsert(UISpecialFrames, "MidnightHelperCraftShoppingList")

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -14)
	f.title:SetTextColor(1, 0.82, 0.2)

	f.intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.intro:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -40)
	f.intro:SetWidth(WIDTH - 32)
	f.intro:SetJustifyH("LEFT")
	f.intro:SetWordWrap(true)

	f.recipeLines, f.rows = {}, {}
	f.reagHead = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.reagHead:SetTextColor(1, 0.82, 0.2)
	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.foot:SetWidth(WIDTH - 32)
	f.foot:SetJustifyH("LEFT")
	f.foot:SetWordWrap(true)

	f.auct = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.auct:SetSize(140, 22)
	f.auct:SetScript("OnClick", ToAuctionator)
	f.clear = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.clear:SetSize(110, 22)
	f.clear:SetScript("OnClick", function()
		local g = MyGuid()
		if g and ns.db and ns.db.craftShop then
			ns.db.craftShop[g] = { list = {} }
		end
		Refresh()
	end)
	f.copyLabel = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.copy = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
	f.copy:SetSize(200, 20)
	f.copy:SetAutoFocus(false)
	f.copy:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
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
	f:RegisterEvent("ITEM_DATA_LOAD_RESULT")
	f:Hide()
	return f
end

local function RecipeLine(i)
	local r = win.recipeLines[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, win)
	r:SetSize(WIDTH - 32, 18)
	r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.text:SetPoint("LEFT", r, "LEFT", 0, 0)
	r.text:SetJustifyH("LEFT")
	r.del = CreateFrame("Button", nil, r, "UIPanelCloseButton")
	r.del:SetSize(20, 20)
	r.del:SetPoint("RIGHT", r, "RIGHT", 0, 0)
	r.del:SetScript("OnClick", function(self)
		local list = MyList()
		local idx = self:GetParent().index
		if idx and list[idx] then
			table.remove(list, idx)
		end
		Refresh()
	end)
	win.recipeLines[i] = r
	return r
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
	r.label:SetPoint("LEFT", r.icon, "RIGHT", 8, 0)
	r.label:SetWidth(210)
	r.label:SetJustifyH("LEFT")
	r.label:SetWordWrap(false)
	r.count = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.count:SetJustifyH("RIGHT")
	r.where = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	r.where:SetPoint("TOPRIGHT", r.count, "BOTTOMRIGHT", 0, -1)
	r.where:SetJustifyH("RIGHT")
	r.status = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.status:SetPoint("RIGHT", r, "RIGHT", 0, 0)
	r.status:SetWidth(104)
	r.status:SetJustifyH("RIGHT")
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

--- All reagents over all listed recipes, one row per reagent (keyed by its first item id, ranks together).
local function Totals(list)
	local byKey, order = {}, {}
	for _, e in ipairs(list) do
		for _, s in ipairs(e.slots or {}) do
			local key = s.ids[1]
			local t = byKey[key]
			if not t then
				t = { ids = s.ids, need = 0 }
				byKey[key] = t
				order[#order + 1] = t
			end
			t.need = t.need + (s.qty or 0) * (e.times or 1)
		end
	end
	return order
end

local function HaveInBags(ids)
	local n = 0
	for _, id in ipairs(ids) do
		local ok, c = pcall(C_Item.GetItemCount, id)
		if ok and type(c) == "number" then
			n = n + c
		end
	end
	return n
end

Refresh = function()
	if not win then
		return
	end
	local S = Shop()
	local list = MyList()
	win.title:SetText(L("CRAFTSHOP_TITLE"))
	win.intro:SetText(#list == 0 and L("CRAFTSHOP_EMPTY") or L("CRAFTSHOP_INTRO"))
	local y = -40 - win.intro:GetStringHeight() - 8

	for i, e in ipairs(list) do
		local r = RecipeLine(i)
		r.index = i
		local yield = ""
		if e.qmin and e.qmax and e.qmax > 1 then
			local lo, hi = e.qmin * e.times, e.qmax * e.times
			yield = "  |cff9aa0a8" .. L("CRAFTSHOP_YIELD_FMT"):format(lo == hi and tostring(lo) or (lo .. "-" .. hi)) .. "|r"
		end
		r.text:SetText(("%d× %s%s"):format(e.times or 1, e.name or "?", yield))
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y)
		r:Show()
		y = y - 20
	end
	for i = #list + 1, #win.recipeLines do
		win.recipeLines[i]:Hide()
	end

	local totals = Totals(list)
	win.buyList = {}
	if #totals > 0 then
		win.reagHead:SetText(L("CRAFTSHOP_REAGENTS"))
		win.reagHead:ClearAllPoints()
		win.reagHead:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y - 6)
		win.reagHead:Show()
		y = y - 6 - win.reagHead:GetStringHeight() - 4
	else
		win.reagHead:Hide()
	end
	for i, t in ipairs(totals) do
		local have = HaveInBags(t.ids)
		local inMail = S.MailCount and S.MailCount(t.ids) or 0
		local inBank = S.BankCount and S.BankCount(t.ids) or 0
		local toBuy = math.max(0, t.need - have - inMail - inBank)
		local id = t.ids[1]
		if toBuy > 0 then
			win.buyList[#win.buyList + 1] = { id = id, qty = toBuy }
		end
		local r = Row(i)
		r.itemID = id
		r.icon:SetTexture(S.ItemIcon and S.ItemIcon(id) or 134400)
		r.label:SetText((S.ItemName and S.ItemName(id)) or "…")
		r.count:SetText(("%d / %d"):format(have, t.need))
		if have >= t.need then
			r.status:SetText("|cff40ff40" .. L("RAIDSHOP_ENOUGH") .. "|r")
		elseif toBuy == 0 then
			r.status:SetText("|cffffd100" .. L("RAIDSHOP_PICKUP") .. "|r")
		else
			r.status:SetText("|cffff5555" .. L("RAIDSHOP_BUY_FMT"):format(toBuy) .. "|r")
		end
		local where = {}
		if inMail > 0 then
			where[#where + 1] = L("RAIDSHOP_IN_MAIL_FMT"):format(inMail)
		end
		if inBank > 0 then
			where[#where + 1] = L("RAIDSHOP_IN_BANK_FMT"):format(inBank)
		end
		r.where:SetText(table.concat(where, ", "))
		r.count:ClearAllPoints()
		r.count:SetPoint("RIGHT", r, "RIGHT", -110, #where > 0 and 6 or 0)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y)
		r:Show()
		y = y - ROW_H
	end
	for i = #totals + 1, #win.rows do
		win.rows[i]:Hide()
	end

	win.foot:SetText(L("CRAFTSHOP_FOOT") .. " " .. L("RAIDSHOP_CLICK_HINT"))
	win.foot:ClearAllPoints()
	win.foot:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y - 6)
	y = y - 6 - win.foot:GetStringHeight() - 8

	local x = 16
	if S.HasAuctionator and S.HasAuctionator() and #totals > 0 then
		win.auct:SetText(L("RAIDSHOP_BTN_AUCTIONATOR"))
		win.auct:ClearAllPoints()
		win.auct:SetPoint("TOPLEFT", win, "TOPLEFT", x, y)
		win.auct:Show()
		x = x + 150
	else
		win.auct:Hide()
	end
	if #list > 0 then
		win.clear:SetText(L("CRAFTSHOP_CLEAR"))
		win.clear:ClearAllPoints()
		win.clear:SetPoint("TOPRIGHT", win, "TOPRIGHT", -16, y)
		win.clear:Show()
	else
		win.clear:Hide()
	end
	local barH = (win.auct:IsShown() or win.clear:IsShown()) and 26 or 0
	y = y - barH
	if win.copyText then
		win.copyLabel:SetText(L("RAIDSHOP_COPY_LABEL"))
		win.copyLabel:ClearAllPoints()
		win.copyLabel:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y - 5)
		win.copyLabel:Show()
		win.copy:ClearAllPoints()
		win.copy:SetPoint("LEFT", win.copyLabel, "RIGHT", 10, 0)
		win.copy:SetWidth(math.max(80, WIDTH - 60 - win.copyLabel:GetStringWidth()))
		win.copy.fixed = win.copyText
		win.copy:SetText(win.copyText)
		win.copy:Show()
		y = y - 26
	else
		win.copyLabel:Hide()
		win.copy:Hide()
	end
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

--- `/mh craftshop`: open (or close) the list.
function ns.ShowCraftShoppingList()
	win = win or Build()
	if win:IsShown() then
		win:Hide()
		return
	end
	win.copyText, win.statusText = nil, nil
	Refresh()
	win:Show()
end

--- `/mh craftshop why`: what MH sees right now (CLAUDE.md: a feature that can stay silent needs a way to see why).
function ns.CraftShopWhy()
	local p = ("|cffffcc00%s|r"):format(L("PRINT_PREFIX"))
	local pf = _G.ProfessionsFrame
	print(("%s craftshop: profession window %s"):format(p, (pf and pf:IsShown()) and "open" or "closed"))
	local info, level = ns.CraftShopCurrentRecipe()
	if info then
		local entry, why = ReadRecipe(info, level)
		print(("   recipe %s (%s), level %s: %s"):format(tostring(info.recipeID), tostring(info.name), tostring(level),
			entry and (#entry.slots .. " basic reagent slot(s)") or ("NOT read: " .. tostring(why))))
		for _, s in ipairs(entry and entry.slots or {}) do
			print(("     %d× item %s (%d rank id(s))"):format(s.qty, tostring(s.ids[1]), #s.ids))
		end
	else
		print("   no recipe selected (open your profession and click a recipe)")
	end
	print(("   your list: %d recipe(s)"):format(#MyList()))
end

-- Side panel refresh when the player picks another recipe (Blizzard's own event; EventRegistry calls it securely).
if EventRegistry and EventRegistry.RegisterCallback then
	-- A moment LATER: our callback is registered at load, before Blizzard_Professions' own, so it runs first and read
	-- the previous recipe from the form. Rob, 6 Oct 2026 (screenshot): Hood selected, panel said Shoulderguards.
	EventRegistry:RegisterCallback("ProfessionsRecipeListMixin.Event.OnRecipeSelected", function()
		if C_Timer and C_Timer.After then
			C_Timer.After(0.1, function()
				if ns.RefreshProfessionSidePanel then
					pcall(ns.RefreshProfessionSidePanel)
				end
			end)
		end
	end, "MidnightHelperCraftShop")
end
