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

	Read-only: no secure buttons, nothing protected, safe in combat.
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

	f:SetScript("OnEvent", function()
		if f:IsShown() then
			Refresh()
		end
	end)
	f:RegisterEvent("BAG_UPDATE_DELAYED")
	f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
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
	for i, d in ipairs(rows) do
		local r = Row(i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y)
		r.itemID = d.itemID
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
	local foot = L("RAIDSHOP_FOOT")
	if not hasSpec then
		foot = L("RAIDSHOP_NO_DATA") .. " " .. foot
	elseif missing == 0 then
		foot = "|cff40ff40" .. L("RAIDSHOP_ALL_SET") .. "|r " .. foot
	end
	win.foot:SetText(foot)
	win.foot:ClearAllPoints()
	win.foot:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y - 6)
	win:SetHeight(-y + 16 + win.foot:GetStringHeight() + 6)
end

--- `/mh ready`: open (or close) the shopping list.
function ns.ShowRaidShoppingList()
	win = win or Build()
	if win:IsShown() then
		win:Hide()
		return
	end
	Refresh()
	win:Show()
end
