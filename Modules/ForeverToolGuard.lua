local _, ns = ...

--[[
	ForeverToolGuard.lua — WoW Forever: warn before you lose your last tool (Skinning Knife, Mining Pick, rods …).

	Rob, 7 Nov 2026: he sold his Skinning Knife by accident ("net zoals mijn skinning knife :/") → "ja slim, doe maar"
	→ "ja doe maar" to this design. Three warnings, all for your LAST copy of a tool kind only:
	  1. At a vendor, the item's tooltip gets a red line: a right-click sells it.
	  2. Destroying it: an MH note under the game's own "Delete?" dialog.
	  3. Sold anyway: a small window "You just sold your last …" with a Buy back button.
	MH never touches the game's buttons, dialogs or bag clicks (that would taint selling, deleting and using items from
	the bags): only its own events, a tooltip post-call and its own frames.

	Data MEASURED 7 Nov 2026 (mh-research; wago.tools DB2 1.60.1.70862 ItemSparse.TotemCategoryID / SpellTotems; Gethe
	wow-ui-source branch `forever`, commit 9dc84f0d3b, for DELETE_ITEM_CONFIRM and the merchant/buyback calls):
	  - 22 items carry a tool category; 5060 Thieves' Tools and 4471 Flint and Tinder are asked for by item id.
	  - The four Shaman totems 5175-5178 cannot be sold or destroyed (SellPrice 0, flag 0x20): left out.
	  - Fishing poles are no tool category (you equip them): left out.
	Not measured: whether a better tool stands in for a lesser one (rods, Gnomish Army Knife). We count only items of the
	SAME kind, so having only a substitute can give one warning too many, never one too few.
	Untested in the client until Rob's test (docs/TESTLIJST.md): BuybackItem from our button, the tooltip post-call.
	/mh toolguard [on|off]; bare prints what it sees (a module whose normal result is silence needs that, CLAUDE.md).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- item id -> { kind = tool kind (items of one kind stand in for each other), how = "buy"/"craft"/"quest"/nil,
-- sell = false when the game will not buy it (SellPrice 0) }
local TOOLS = {
	[2901] = { kind = "pick", how = "buy" }, -- Mining Pick
	[6206] = { kind = "pick" }, -- Rock Chipper (drop)
	[259229] = { kind = "pick", how = "quest", sell = false }, -- Vindael's Spectral Pickaxe
	[7005] = { kind = "knife", how = "buy" }, -- Skinning Knife
	[269716] = { kind = "knife", how = "quest" }, -- Keen Skinning Knife
	[5956] = { kind = "hammer", how = "buy" }, -- Blacksmith Hammer
	[285280] = { kind = "hammer", how = "craft" }, -- Mithril Blacksmith Hammer
	[285281] = { kind = "hammer", how = "craft" }, -- Arcanite Blacksmith Hammer
	[260811] = { kind = "armyknife", how = "craft" }, -- Gnomish Army Knife
	[6219] = { kind = "spanner", how = "craft" }, -- Arclight Spanner
	[10498] = { kind = "gyro", how = "craft" }, -- Gyromatic Micro-Adjustor
	[9149] = { kind = "philo", how = "craft" }, -- Philosopher's Stone
	[13503] = { kind = "philo", how = "craft" }, -- Alchemist's Stone
	[6218] = { kind = "rod1", how = "craft" }, -- Runed Copper Rod
	[6339] = { kind = "rod2", how = "craft" }, -- Runed Silver Rod
	[11130] = { kind = "rod3", how = "craft" }, -- Runed Golden Rod
	[11145] = { kind = "rod4", how = "craft" }, -- Runed Truesilver Rod
	[16207] = { kind = "rod5", how = "craft" }, -- Runed Arcanite Rod
	[5060] = { kind = "thieves", how = "buy", sell = false }, -- Thieves' Tools
	[4471] = { kind = "flint", how = "buy" }, -- Flint and Tinder
}
local HOW_KEY = { buy = "TOOLG_HOW_BUY", craft = "TOOLG_HOW_CRAFT", quest = "TOOLG_HOW_QUEST" }

local function Settings()
	if not ns.db then
		return { on = true }
	end
	ns.db.foreverToolGuard = ns.db.foreverToolGuard or { on = true }
	return ns.db.foreverToolGuard
end

local function On()
	return Settings().on ~= false
end

local function Count(id)
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return nil
	end
	local ok, n = pcall(fn, id)
	return ok and tonumber(n) or nil
end

--- How many tools of this kind you carry (bags + equipped); nil when it cannot be read.
local function KindCount(kind)
	local total = 0
	for id, t in pairs(TOOLS) do
		if t.kind == kind then
			local n = Count(id)
			if n == nil then
				return nil
			end
			total = total + n
		end
	end
	return total
end

local function ItemName(id)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return "item " .. id
end

local function HowLine(t)
	return t.how and (" " .. ns:L(HOW_KEY[t.how])) or ""
end

local function IdFromLink(link)
	return type(link) == "string" and tonumber(link:match("item:(%d+)")) or nil
end

--------------------------------------------------------------------------------
-- 1. Tooltip at a vendor
--------------------------------------------------------------------------------
local function MerchantOpen()
	return MerchantFrame and MerchantFrame.IsShown and MerchantFrame:IsShown()
end

--- The vendor's OWN buttons: the items for sale and the buyback tab. Hovering those means buying, not selling.
--- Rob, 11 Nov 2026 (screenshot): hovering the Blacksmith Hammer in the vendor's list to BUY it said "Right-click sells
--- this, and it is your last one". The check only asked whether a vendor was open, not where the mouse was.
local function OnVendorList(tooltip)
	local owner = tooltip.GetOwner and tooltip:GetOwner()
	local name = owner and owner.GetName and owner:GetName()
	if type(name) ~= "string" then
		return false
	end
	return name:find("^MerchantItem") ~= nil or name:find("^MerchantBuyBack") ~= nil
end

local tooltipHooked = false
local function OnItemTooltip(tooltip, data)
	if not On() or tooltip ~= GameTooltip or not MerchantOpen() or OnVendorList(tooltip) then
		return
	end
	local id = type(data) == "table" and data.id
	local t = id and TOOLS[id]
	if not t or t.sell == false then
		return
	end
	local n = KindCount(t.kind)
	-- Exactly one: then the one you hover IS your last. Zero means you do not have it (it was <= 1, same screenshot).
	if n == 1 then
		tooltip:AddLine(ns:L("TOOLG_TIP_SELL"), 1, 0.3, 0.3, true)
	end
end
if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnItemTooltip)
	tooltipHooked = true
end

--------------------------------------------------------------------------------
-- 2. Destroying: our own note under the game's dialog (never written into it)
--------------------------------------------------------------------------------
local DELETE_DIALOGS = { "DELETE_ITEM", "DELETE_GOOD_ITEM", "DELETE_QUEST_ITEM", "DELETE_GOOD_QUEST_ITEM",
	"DELETE_ITEM_GAMEPAD", "DELETE_GOOD_ITEM_GAMEPAD", "DELETE_QUEST_ITEM_GAMEPAD", "DELETE_GOOD_QUEST_ITEM_GAMEPAD" }

local note
local function DeleteNote()
	if note then
		return note
	end
	note = CreateFrame("Frame", "MidnightHelperToolGuardNote", UIParent, "BackdropTemplate")
	note:SetFrameStrata("FULLSCREEN_DIALOG")
	note:SetSize(340, 60)
	if note.SetBackdrop then
		note:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
			insets = { left = 3, right = 3, top = 3, bottom = 3 } })
		note:SetBackdropColor(0.25, 0, 0, 0.92)
		note:SetBackdropBorderColor(1, 0.3, 0.3)
	end
	note.text = note:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	note.text:SetPoint("TOPLEFT", 10, -9)
	note.text:SetPoint("TOPRIGHT", -10, -9)
	note.text:SetJustifyH("LEFT")
	note:SetScript("OnUpdate", function(self)
		if not (self.dialog and self.dialog:IsShown()) then
			self:Hide()
		end
	end)
	note:Hide()
	return note
end

local function VisibleDeleteDialog()
	if not StaticPopup_FindVisible then
		return nil
	end
	for _, which in ipairs(DELETE_DIALOGS) do
		local ok, d = pcall(StaticPopup_FindVisible, which)
		if ok and d then
			return d
		end
	end
end

local function OnDeleteConfirm(guid)
	if not On() then
		return
	end
	local id
	if guid and C_Item and C_Item.GetItemIDByGUID then
		local ok, v = pcall(C_Item.GetItemIDByGUID, guid)
		id = ok and v or nil
	end
	if not id and GetCursorInfo then
		local kind, cid = GetCursorInfo()
		id = kind == "item" and cid or nil
	end
	local t = id and TOOLS[id]
	if not t then
		return
	end
	local n = KindCount(t.kind)
	if not n or n > 1 then
		return
	end
	-- the game's own handler shows the dialog on this same event; look for it a frame later
	C_Timer.After(0, function()
		local d = VisibleDeleteDialog()
		if not d then
			return
		end
		local f = DeleteNote()
		f.dialog = d
		f.text:SetText(ns:L("TOOLG_DELETE_FMT"):format(ItemName(id)) .. HowLine(t))
		f:SetHeight(math.max(40, f.text:GetStringHeight() + 18))
		f:ClearAllPoints()
		f:SetPoint("TOP", d, "BOTTOM", 0, -4)
		f:Show()
	end)
end

--------------------------------------------------------------------------------
-- 3. Sold anyway: a window with a Buy back button
--------------------------------------------------------------------------------
local soldWin
local function SoldWindow()
	if soldWin then
		return soldWin
	end
	local f = CreateFrame("Frame", "MidnightHelperToolGuardSold", UIParent, "BackdropTemplate")
	f:SetFrameStrata("DIALOG")
	f:SetSize(360, 112)
	f:SetPoint("TOP", UIParent, "TOP", 0, -160)
	if f.SetBackdrop then
		f:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 24,
			insets = { left = 6, right = 6, top = 6, bottom = 6 } })
	end
	-- the text starts below RegisterMidnightDialogPopup's "Dock to window" label (top-right, y -10 to -26); Rob, 7 Nov
	-- 2026 (screenshot): at -16 it ran over "You need it"
	f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.text:SetPoint("TOPLEFT", 16, -32)
	f.text:SetPoint("TOPRIGHT", -16, -32)
	f.text:SetJustifyH("LEFT")
	f.buy = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.buy:SetSize(130, 22)
	f.buy:SetPoint("BOTTOMRIGHT", f, "BOTTOM", -4, 12)
	f.buy:SetText(ns:L("TOOLG_BUYBACK"))
	f.close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.close:SetSize(130, 22)
	f.close:SetPoint("BOTTOMLEFT", f, "BOTTOM", 4, 12)
	f.close:SetText(CLOSE or "Close")
	f.close:SetScript("OnClick", function()
		f:Hide()
	end)
	f.buy:SetScript("OnClick", function()
		local id = f.itemId
		local done = false
		if id and GetNumBuybackItems and GetBuybackItemLink and BuybackItem and MerchantOpen() then
			for i = GetNumBuybackItems(), 1, -1 do
				if IdFromLink(GetBuybackItemLink(i)) == id then
					BuybackItem(i)
					done = true
					break
				end
			end
		end
		if not done then
			print(PREFIX .. ns:L("TOOLG_BUYBACK_FAIL"))
		end
		f:Hide()
	end)
	f:Hide()
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- Shift+scroll scales it, like every MH window
	end
	soldWin = f
	return f
end

local seenAtOpen = {} -- buyback item ids already there when this vendor opened
local alerted = {}

local function BuybackIds()
	local out = {}
	if not (GetNumBuybackItems and GetBuybackItemLink) then
		return out
	end
	for i = 1, GetNumBuybackItems() or 0 do
		local id = IdFromLink(GetBuybackItemLink(i))
		if id then
			out[id] = true
		end
	end
	return out
end

local function CheckSold()
	if not On() or not MerchantOpen() then
		return
	end
	for id in pairs(BuybackIds()) do
		local t = TOOLS[id]
		if t and not seenAtOpen[id] and not alerted[id] then
			local n = KindCount(t.kind)
			if n == 0 then
				alerted[id] = true
				local f = SoldWindow()
				f.itemId = id
				f.text:SetText(ns:L("TOOLG_SOLD_FMT"):format(ItemName(id)))
				f:Show()
			end
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("DELETE_ITEM_CONFIRM")
ev:RegisterEvent("MERCHANT_SHOW")
ev:RegisterEvent("MERCHANT_UPDATE")
ev:RegisterEvent("MERCHANT_CLOSED")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:SetScript("OnEvent", function(_, event, ...)
	if event == "DELETE_ITEM_CONFIRM" then
		local _, _, _, _, guid = ...
		OnDeleteConfirm(guid)
	elseif event == "MERCHANT_SHOW" then
		seenAtOpen = BuybackIds()
		alerted = {}
	elseif event == "MERCHANT_CLOSED" then
		if soldWin then
			soldWin:Hide()
		end
	elseif MerchantOpen() then -- MERCHANT_UPDATE / BAG_UPDATE_DELAYED
		C_Timer.After(0.2, CheckSold)
	end
end)

--- /mh toolguard [on|off]
function ns.ForeverToolGuardSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		Settings().on = (arg == "on")
		print(PREFIX .. "tool warnings " .. (arg == "on" and "on." or "off. /mh toolguard on brings them back."))
		return
	end
	print(PREFIX .. "tool warnings: " .. (On() and "on" or "off") .. " (/mh toolguard on|off).")
	print(("  vendor tooltip line: %s; delete event: yes; buyback calls: %s"):format(
		tooltipHooked and "hooked" or "NOT available on this client",
		(GetNumBuybackItems and GetBuybackItemLink and BuybackItem) and "present" or "MISSING"))
	local any = false
	local kinds = {}
	for id, t in pairs(TOOLS) do
		local n = Count(id)
		if n and n > 0 then
			any = true
			kinds[t.kind] = kinds[t.kind] or KindCount(t.kind)
			print(("  %s: %d (kind %s, %d in all -> %s)"):format(ItemName(id), n, t.kind, kinds[t.kind] or -1,
				(kinds[t.kind] or 0) <= 1 and "warned about" or "spare, no warning"))
		end
	end
	if not any then
		print("  you carry no tool from our list.")
	end
	if MerchantOpen() and GetNumBuybackItems then
		print(("  vendor open, %d in its buyback list."):format(GetNumBuybackItems() or 0))
	end
end
