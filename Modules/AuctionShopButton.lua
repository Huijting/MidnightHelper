local _, ns = ...

--[[
	A button on the auction house window that opens the shopping lists.

	Rob, 9 Oct 2026, standing at the auction house: "hoe maakte ik ook alweer mijn raid lijstje voor ah?" — and then
	"hoe lossen we dat op voor onze users als ik het al niet weet". The lists (Ready for the raid? and Shopping for your
	profession, /mh ready and /mh craftshop) live under Tools, which is not where you are when you need them. MEASURED
	that day: no MH module did anything when the auction house opened. Rob chose "a button on the AH window, always
	visible, with 'X to buy' when the list misses something", switchable in Settings.

	The number is the sum of what the two lists themselves count, with their own rules (mail and bank count as had,
	optional rows and the Healthstone never count, vendor reagents stay off): ns.RaidShopMissingCount (rows) and
	ns.CraftShopToBuyCount (reagents to buy; not CraftShopTerms, which skips items whose name has not loaded yet). Click = /mh ready, which has the Raid | Profession tabs on top.

	Not secure, nothing protected: a plain button parented to Blizzard's AuctionHouseFrame (load-on-demand, so it is
	hooked when Blizzard_AuctionHouseUI loads). On by default; Settings -> Window, or ns.db.ahShopButton = false.
]]

local btn

local function Enabled()
	return not (ns.db and ns.db.ahShopButton == false)
end

function ns.IsAhShopButtonEnabled()
	return Enabled()
end

function ns.SetAhShopButtonEnabled(v)
	ns.db = ns.db or {}
	ns.db.ahShopButton = v and true or false
	if btn then
		btn:SetShown(Enabled() and AuctionHouseFrame and AuctionHouseFrame:IsShown() or false)
	end
end

--- What both lists would mark Buy right now: total, raid part, profession part. pcall: a list that cannot answer
--- counts as 0, never as an error.
local function ToBuy()
	local raid, craft = 0, 0
	if ns.RaidShopMissingCount then
		local ok, c = pcall(ns.RaidShopMissingCount)
		raid = ok and tonumber(c) or 0
	end
	if ns.CraftShopToBuyCount then
		local ok, c = pcall(ns.CraftShopToBuyCount)
		craft = ok and tonumber(c) or 0
	end
	return raid + craft, raid, craft
end

-- Rob, 9 Oct 2026 evening: after a purchase the number stayed put, with the fix below in and after a /reload.
-- Every recount writes why and what it found to ns.db.ahShopProbe (last 15), so his SavedVariables show whether
-- the purchase reached the button at all.
local function Probe(reason, n, raid, craft)
	if not ns.db then
		return
	end
	ns.db.ahShopProbe = ns.db.ahShopProbe or {}
	local p = ns.db.ahShopProbe
	p[#p + 1] = ("%s %s n=%d raid=%d craft=%d"):format(date and date("%H:%M:%S") or "", reason, n, raid, craft)
	while #p > 15 do
		table.remove(p, 1)
	end
end

local function Update(reason)
	if not btn then
		return
	end
	local n, raid, craft = ToBuy()
	btn.raid, btn.craft = raid, craft
	Probe(reason or "?", n, raid, craft)
	if n > 0 then
		btn:SetText(ns:L("AHSHOP_BTN_FMT"):format(n))
	else
		btn:SetText(ns:L("AHSHOP_BTN"))
	end
	btn:SetWidth(math.max(150, (btn:GetFontString() and btn:GetFontString():GetStringWidth() or 120) + 28))
end

--- Called by RaidShoppingList when a purchase is noted as "on its way". Rob, 9 Oct 2026: the window showed the bought
--- item in the mail at once, but the button only dropped after he took the mail - nothing changes in the bags before
--- that, so BAG_UPDATE_DELAYED never fired.
function ns.RefreshAhShopButton()
	if btn and btn:IsShown() then
		Update("purchase")
	else
		Probe(btn and "purchase-hidden" or "purchase-nobutton", -1, -1, -1)
	end
end

local function Build()
	if btn or not AuctionHouseFrame then
		return
	end
	btn = CreateFrame("Button", "MidnightHelperAuctionShopButton", AuctionHouseFrame, "UIPanelButtonTemplate")
	btn:SetHeight(22)
	-- Under the window's bottom-right corner: the Buy/Sell/Auctions tabs (and Auctionator's) sit bottom-left.
	btn:SetPoint("TOPRIGHT", AuctionHouseFrame, "BOTTOMRIGHT", -4, -2)
	btn:SetScript("OnClick", function()
		if ns.ShowRaidShoppingList then
			ns.ShowRaidShoppingList()
		end
	end)
	btn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText(ns:L("AHSHOP_TIP_TITLE"))
		GameTooltip:AddLine(ns:L("AHSHOP_TIP_BODY"), 1, 1, 1, true)
		-- Where the number comes from (Rob, 9 Oct: "doe die tooltip maar"). The counts of the last recount, so the
		-- tooltip agrees with the text on the button.
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(("%s: %d   ·   %s: %d"):format(ns:L("SHOPTAB_RAID"), self.raid or 0,
			ns:L("SHOPTAB_CRAFT"), self.craft or 0), 1, 0.82, 0)
		GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

local function OnShow()
	Build()
	if not btn then
		return
	end
	btn:SetShown(Enabled())
	if Enabled() then
		Update("open")
	end
end

local hooked = false
local function Hook()
	if hooked or not AuctionHouseFrame then
		return
	end
	hooked = true
	AuctionHouseFrame:HookScript("OnShow", OnShow)
	if AuctionHouseFrame:IsShown() then
		OnShow()
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("BAG_UPDATE_DELAYED")
f:SetScript("OnEvent", function(_, event, name)
	if event == "ADDON_LOADED" then
		if name == "Blizzard_AuctionHouseUI" or AuctionHouseFrame then
			Hook()
		end
	elseif event == "BAG_UPDATE_DELAYED" then
		-- Buying something lowers the number while you stand there.
		if btn and btn:IsShown() then
			Update("bags")
		end
	end
end)
