local _, ns = ...

--[[
	ForeverBagFull.lua — WoW Forever: "Bags full" — the three cheapest things in your bags, and WHY they can go (idea 1,
	option MIDDEL, step 1). Rob, 20 Nov 2026 (via sparring), verbatim: "Beide ja" on "Tas vol: Middel, in twee stappen?".
	His idea: "Wanneer je tas vol zit, kijken wat is dan het goedkoopste. Wat is trash … En of wat je kan looten dat beter is
	of meer waarde heeft."

	Step 1 (this file): MH does NOTHING to your items. When the game says your bags are full (UI_ERROR_MESSAGE with
	ERR_INV_FULL — what Blizzard's own LootFrame listens for, GEMETEN in the Forever UI source 1.60.1.70959), a small window
	lists the three cheapest items (vendor value x stack) with the reason, and, while a loot window is open, compares the
	loot with your cheapest item. You throw away or sell yourself.
	Never suggested: quest items, profession tools (ns.ForeverIsTool, ForeverToolGuard.lua), food, drink, ammunition and
	class reagents (KeepKind, 22 Nov 2026), ingredients for a profession
	you have (ns.ReagentUseText green), gear better than what you wear (ns.ForeverGearTipText), Rare and better (Forever
	asks you to type DELETE for those), items without a vendor value, special bags.
	Step 2 (built 20 Nov 2026 after Rob's test, see the Step 2 block below): Destroy per row (with a "sure?"), Pick up the
	loot, and "Sell MH junk" at a vendor — only ever from a click. /mh bagfull test calls DeleteCursorItem (empty cursor)
	and UseContainerItem (empty slot) from a click and records whether the game blocked them, and whether you stood at a
	vendor. No item can be lost by the test.
	/mh bagfull           what MH saw last and why it showed or stayed quiet; /mh bagfull show = the window now (same door)
	/mh bagfull on|off    the automatic window (default on)
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local C = C_Container
local LAST_BAG = NUM_BAG_SLOTS or 4
local GAP = 20 -- seconds: the automatic window at most once per this many seconds
local last = { why = "nothing seen yet", at = nil }

local function Settings()
	ns.db = ns.db or {}
	ns.db.foreverBagFull = type(ns.db.foreverBagFull) == "table" and ns.db.foreverBagFull or { on = true }
	return ns.db.foreverBagFull
end

local function Readable(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

local function Money(c)
	if ns.ForeverStyle and ns.ForeverStyle.Money then
		local ok, s = pcall(ns.ForeverStyle.Money, c)
		if ok and s then
			return s
		end
	end
	if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
		local ok, s = pcall(C_CurrencyInfo.GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	return tostring(c)
end

local function SellPrice(idOrLink)
	local f = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	if not f then
		return nil
	end
	local ok, name, _, _, _, _, _, _, _, equipLoc, _, price = pcall(f, idOrLink)
	if not ok or not name then
		if C_Item and C_Item.RequestLoadItemDataByID and type(idOrLink) == "number" then
			pcall(C_Item.RequestLoadItemDataByID, idOrLink)
		end
		return nil
	end
	return tonumber(price), equipLoc
end

local function IsQuestItem(bag, slot)
	if C and C.GetContainerItemQuestInfo then
		local ok, q = pcall(C.GetContainerItemQuestInfo, bag, slot)
		if ok and type(q) == "table" and (q.isQuestItem or q.questID) then
			return true
		end
	end
	return false
end

--- Is it a profession tool, in the widest sense? 20 Nov 2026, Rob's own test (screenshot): the window offered his
--- [Fishing Pole] as "Gear that is not better than what you wear" — "Hij wil mijn fishing pole weggooien. Maar mijn fishing
--- pole die wil ik niet weggooien, want die heb ik nodig om te vissen." ForeverToolGuard's list has no rods, so:
---   1. ForeverToolGuard's tools (pick, knife, hammer, spanner, runed rods, philosopher's stone …);
---   2. every fishing pole by kind (weapon subclass Fishing Pole), whatever its id;
---   3. the fishing poles MH knows by id (ForeverVendors.lua, the fishing category's "have" list);
---   4. item class Profession (19), in case Forever has profession gear.
--- Whether you have the profession does not matter: a tool is never suggested.
local FISHING_POLES = { [6256] = true, [6365] = true, [6366] = true, [6367] = true, [12225] = true, [19022] = true,
	[19970] = true }
local POLE_SUBCLASS = (Enum and Enum.ItemWeaponSubclass and Enum.ItemWeaponSubclass.Fishingpole) or 20
local function IsTool(id)
	if ns.ForeverIsTool and ns.ForeverIsTool(id) then
		return true
	end
	if FISHING_POLES[id] then
		return true
	end
	local f = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if f then
		local ok, _, _, _, _, _, classID, subclassID = pcall(f, id)
		if ok and ((classID == 2 and subclassID == POLE_SUBCLASS) or classID == 19) then
			return true
		end
	end
	return false
end

--- What you carry to use: food, drink, ammunition, the reagents of class spells, and quest items by their item class.
--- 22 Nov 2026 (bags, point a): GEMETEN in DB2 1.60.1.71037, all of these passed the filter before: 286 sellable kinds of
--- food and drink, 14 of ammunition, the class reagents (Rune of Teleportation, Ankh, Symbol of Kings ...).
---   FOOD_ELSEWHERE = a Food or Drink spell, but not item class 0/5 (raw fish, holiday food, a few new Forever dishes).
---   class reagents = item class 5 and 15/1; Blinding Powder is the one that a class spell uses and is filed as Junk.
local FOOD_ELSEWHERE = { [4603] = true, [5845] = true, [6289] = true, [6291] = true, [6303] = true, [6308] = true,
	[6317] = true, [6361] = true, [6362] = true, [6458] = true, [8365] = true, [8959] = true, [13754] = true,
	[13756] = true, [13758] = true, [13759] = true, [13760] = true, [13888] = true, [13889] = true, [17405] = true,
	[19997] = true, [20388] = true, [20389] = true, [20390] = true, [21071] = true, [21153] = true, [21241] = true,
	[23161] = true, [206177] = true, [232436] = true, [232438] = true, [238637] = true, [238639] = true,
	[240945] = true, [251917] = true, [275893] = true }
local BLINDING_POWDER = 5530
--- The reason this item is never suggested or destroyed by MH, or nil.
local function KeepKind(id)
	if FOOD_ELSEWHERE[id] then
		return "food or drink"
	elseif id == BLINDING_POWDER then
		return "class reagent"
	end
	local f = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not f then
		return "item kind not readable"
	end
	local ok, _, _, _, _, _, class, sub = pcall(f, id)
	if not ok or type(class) ~= "number" then
		return "item kind not readable" -- not knowing is never a reason to throw away
	end
	if class == 0 and sub == 5 then
		return "food or drink"
	elseif class == 6 then
		return "ammunition"
	elseif class == 5 or (class == 15 and sub == 1) then
		return "class reagent"
	elseif class == 12 then
		return "quest item"
	end
	return nil
end

--- Is it an ingredient for a profession you have? (ReagentUse.lua colours that line green.)
local function ForMyProfession(id)
	if not ns.ReagentUseText then
		return false
	end
	local ok, text, r = pcall(ns.ReagentUseText, id)
	return ok and text ~= nil and r == 0.37
end

--- Every item that may go, cheapest first: { bag, slot, id, link, name, icon, n, value, why }; plus counts of what was
--- left out and why (for /mh bagfull).
local function Candidates()
	local out, skipped = {}, {}
	local function skip(k)
		skipped[k] = (skipped[k] or 0) + 1
	end
	if not (C and C.GetContainerNumSlots and C.GetContainerItemInfo) then
		return out, { ["no C_Container"] = 1 }
	end
	for bag = 0, LAST_BAG do
		local family = 0
		if C.GetContainerNumFreeSlots then
			local okF, _, fam = pcall(C.GetContainerNumFreeSlots, bag)
			family = okF and fam or 0
		end
		local okN, slots = pcall(C.GetContainerNumSlots, bag)
		for slot = 1, (okN and family == 0 and slots) or 0 do
			local ok, info = pcall(C.GetContainerItemInfo, bag, slot)
			if ok and type(info) == "table" and Readable(info.itemID) then
				local id, q = info.itemID, info.quality
				local price, equipLoc = SellPrice(info.hyperlink or id)
				if info.hasNoValue then
					skip("no vendor value")
				elseif price == nil then
					skip("item data not loaded yet")
				elseif price <= 0 then
					skip("no vendor value")
				elseif type(q) == "number" and q >= 3 then
					skip("Rare or better")
				elseif IsQuestItem(bag, slot) then
					skip("quest item")
				elseif IsTool(id) then
					skip("profession tool")
				elseif KeepKind(id) then
					skip(KeepKind(id))
				elseif ForMyProfession(id) then
					skip("ingredient for your profession")
				else
					local isGear = type(equipLoc) == "string" and equipLoc ~= "" and equipLoc ~= "INVTYPE_BAG"
						and equipLoc ~= "INVTYPE_NON_EQUIP_IGNORE"
					local upgrade = false
					if isGear and info.hyperlink and ns.ForeverGearTipText then
						local okU, t = pcall(ns.ForeverGearTipText, info.hyperlink)
						upgrade = okU and t ~= nil
					end
					if upgrade then
						skip("better than what you wear")
					else
						local why = (q == 0 and "FBAG_WHY_GREY") or (isGear and "FBAG_WHY_GEAR") or "FBAG_WHY_CHEAP"
						out[#out + 1] = { bag = bag, slot = slot, id = id, link = info.hyperlink, icon = info.iconFileID,
							name = info.itemName, n = info.stackCount or 1, value = price * (info.stackCount or 1), why = why,
							q = q }
					end
				end
			end
		end
	end
	table.sort(out, function(a, b)
		if a.value ~= b.value then
			return a.value < b.value
		end
		return (a.q or 0) < (b.q or 0)
	end)
	return out, skipped
end

--- The loot window's most valuable item you could not pick up: { link, n, value } or nil.
local function LootBest()
	if not (GetNumLootItems and GetLootSlotLink and GetLootSlotInfo) then
		return nil
	end
	local okN, n = pcall(GetNumLootItems)
	if not okN or type(n) ~= "number" then
		return nil
	end
	local best
	for i = 1, n do
		local okL, link = pcall(GetLootSlotLink, i)
		if okL and type(link) == "string" then
			local okI, _, _, qty = pcall(GetLootSlotInfo, i)
			local price = SellPrice(link)
			if price then
				local v = price * ((okI and tonumber(qty)) or 1)
				if not best or v > best.value then
					best = { link = link, n = (okI and tonumber(qty)) or 1, value = v, slot = i }
				end
			end
		end
	end
	return best
end

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------
local W, H, ROWS = 480, 360, 3
local win
local AskDestroy, LootIt -- step 2, defined below (both only ever run from a click)

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverBagFull", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
	f:SetPoint("CENTER", 0, 120)
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
	f.title:SetPoint("RIGHT", f, "RIGHT", -36, 0)
	f.title:SetJustifyH("LEFT")
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	-- 21 Nov 2026: the loot line's item link shows the game's tooltip (the rows already show the bag item's tooltip).
	if ns.ForeverHookLinks then
		ns.ForeverHookLinks(f)
	end
	f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.sub:SetPoint("TOPLEFT", 22, -44)
	f.sub:SetPoint("RIGHT", f, "RIGHT", -22, 0)
	f.sub:SetJustifyH("LEFT")
	f.rows = {}
	for i = 1, ROWS do
		local r = CreateFrame("Button", nil, f)
		r:SetSize(W - 44, 40)
		r:SetPoint("TOPLEFT", 22, -66 - (i - 1) * 46)
		r.icon = r:CreateTexture(nil, "ARTWORK")
		r.icon:SetSize(34, 34)
		r.icon:SetPoint("LEFT", 0, 0)
		r.name = r:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		r.name:SetPoint("TOPLEFT", r.icon, "TOPRIGHT", 8, -1)
		r.name:SetPoint("RIGHT", r, "RIGHT", -190, 0)
		r.name:SetJustifyH("LEFT")
		r.name:SetWordWrap(false)
		-- Step 2 (Rob, 20 Nov 2026: "toch wil ik graag die knop erbij per stuk. Dat we dat kunnen destroyen."): Destroy,
		-- with a "sure?" first. Only from this click (his test: from a timer the game blocks it).
		r.del = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
		r.del:SetSize(96, 22)
		r.del:SetPoint("RIGHT", r, "RIGHT", 0, 0)
		r.del:SetText(ns:L("FBAG_DESTROY"))
		r.del:SetScript("OnClick", function(self)
			if self.entry and AskDestroy then
				AskDestroy(self.entry)
			end
		end)
		r.del:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(ns:L("FBAG_DESTROY"), 1, 0.82, 0)
			GameTooltip:AddLine(ns:L("FBAG_DESTROY_TIP"), 1, 1, 1, true)
			GameTooltip:Show()
		end)
		r.del:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		r.value = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		r.value:SetPoint("TOPRIGHT", r.del, "TOPLEFT", -8, 0)
		r.value:SetJustifyH("RIGHT")
		r.why = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		r.why:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -3)
		r.why:SetPoint("RIGHT", r.del, "LEFT", -8, 0)
		r.why:SetJustifyH("LEFT")
		r.why:SetTextColor(0.7, 0.7, 0.7)
		r:SetScript("OnEnter", function(self)
			if self.bag then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				pcall(GameTooltip.SetBagItem, GameTooltip, self.bag, self.slot)
				GameTooltip:Show()
			end
		end)
		r:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		f.rows[i] = r
	end
	f.loot = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.loot:SetPoint("TOPLEFT", 22, -66 - ROWS * 46 - 6)
	f.loot:SetPoint("RIGHT", f, "RIGHT", -22, 0)
	f.loot:SetJustifyH("LEFT")
	-- Picking up the loot is its own click: the server frees the bag slot only after the destroy, so the same click
	-- cannot loot yet (AFGELEID; Rob's test decides).
	f.lootBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.lootBtn:SetSize(160, 22)
	f.lootBtn:SetPoint("TOPLEFT", f.loot, "BOTTOMLEFT", 0, -6)
	f.lootBtn:SetText(ns:L("FBAG_LOOT_BTN"))
	f.lootBtn:SetScript("OnClick", function(self)
		if self.slot and LootIt then
			LootIt(self.slot)
		end
	end)
	f.lootBtn:Hide()
	-- 20 Nov 2026 (Rob: "… waarbij ik mijn spullen kan repareren en zeker verkopen?" → "ja doe maar"): the way to the
	-- nearest vendor who repairs (every vendor buys), named in the window itself (TomTom users never see our arrow label).
	f.repBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.repBtn:SetSize(150, 22)
	f.repBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -22, 40)
	f.repBtn:SetText(ns:L("FCITY_CAT_REPAIR"))
	f.repBtn:SetScript("OnClick", function()
		if ns.ForeverRepairGoNearest then
			ns.ForeverRepairGoNearest()
		end
	end)
	f.repInfo = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.repInfo:SetPoint("RIGHT", f.repBtn, "LEFT", -10, 0)
	f.repInfo:SetPoint("LEFT", f, "BOTTOMLEFT", 22, 51) -- 21 Nov 2026 (Rob): was f "LEFT" = mid-height, through row 3
	f.repInfo:SetJustifyH("LEFT")
	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.hint:SetPoint("BOTTOMLEFT", 22, 18)
	f.hint:SetPoint("RIGHT", f, "RIGHT", -22, 0)
	f.hint:SetJustifyH("LEFT")
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

local function Fill(list, loot)
	local f = Build()
	f.title:SetText(ns:L("FBAG_TITLE"))
	f.sub:SetText(ns:L(#list > 0 and "FBAG_SUB" or "FBAG_NONE"))
	for i, r in ipairs(f.rows) do
		local e = list[i]
		if e then
			r.bag, r.slot = e.bag, e.slot
			r.icon:SetTexture(e.icon or 134400)
			r.name:SetText((e.link or e.name or "?") .. (e.n > 1 and (" x" .. e.n) or ""))
			r.value:SetText(Money(e.value))
			r.why:SetText(ns:L(e.why))
			r.del.entry = e
			r:Show()
		else
			r.bag = nil
			r.del.entry = nil
			r:Hide()
		end
	end
	if loot and loot.slot then
		f.lootBtn.slot = loot.slot
		f.lootBtn:Show()
	else
		f.lootBtn.slot = nil
		f.lootBtn:Hide()
	end
	local cheapest = list[1]
	if loot and cheapest then
		local key = loot.value > cheapest.value and "FBAG_LOOT_MORE_FMT" or "FBAG_LOOT_LESS_FMT"
		f.loot:SetText(ns:L(key):format(loot.link, Money(loot.value), Money(cheapest.value)))
	elseif loot then
		f.loot:SetText(ns:L("FBAG_LOOT_ONLY_FMT"):format(loot.link, Money(loot.value)))
	else
		f.loot:SetText("")
	end
	f.hint:SetText(ns:L("FBAG_HINT"))
	local near
	if ns.ForeverRepairNearest then
		local ok, r = pcall(ns.ForeverRepairNearest)
		near = ok and r or nil
	end
	if near then
		local dist = ns.ForeverTrainerDistance and near.dist and ns.ForeverTrainerDistance(math.floor(near.dist + 0.5))
			or (near.dist and ("%d yd"):format(math.floor(near.dist + 0.5))) or ""
		f.repInfo:SetText(ns:L("FBAG_REPAIR_NEAR_FMT"):format(tostring(near.name), tostring(near.zone), dist))
		f.repBtn:Enable()
	else
		f.repInfo:SetText(ns:L("FCITY_REPAIR_NONE"))
		f.repBtn:Disable()
	end
end

--- Open the window now. `why` goes to /mh bagfull. The automatic trigger and /mh bagfull show both come here.
local function Show(why)
	local list, skipped = Candidates()
	local loot = (LootFrame and LootFrame:IsShown()) and LootBest() or nil
	last.why = ("%s: %d candidates, cheapest %s; left out: %s"):format(why, #list,
		list[1] and ("%s (%d copper)"):format(tostring(list[1].name), list[1].value) or "none",
		(function()
			local t = {}
			for k, n in pairs(skipped) do
				t[#t + 1] = k .. " " .. n
			end
			return #t > 0 and table.concat(t, ", ") or "nothing"
		end)())
	last.at = GetTime and GetTime() or 0
	Fill(list, loot)
	Build():Show()
end

--------------------------------------------------------------------------------
-- Step 2 (Rob, 20 Nov 2026: "toch wil ik graag die knop erbij per stuk. Dat we dat kunnen destroyen."): Destroy,
-- Pick up the loot, and Sell MH junk at a vendor. GEMETEN in Rob's /mh bagfull test (Forever, empty cursor / empty
-- slot): from a click DeleteCursorItem and UseContainerItem were not blocked; from a timer UseContainerItem was
-- (ADDON_ACTION_BLOCKED). So all three run ONLY inside a click (a button, or the "sure?" popup's Yes), never from a timer
-- or an event. If the game blocks one anyway (a real item may be stricter than an empty cursor), MH puts the item back,
-- says so in chat, and for selling hides its button for good (db.sellBlocked).
--------------------------------------------------------------------------------
local watch -- { kind = "delete"/"sell"/"loot", at = GetTime(), name } while one of our clicks is running
local blockEv = CreateFrame("Frame")
blockEv:RegisterEvent("ADDON_ACTION_BLOCKED")
blockEv:RegisterEvent("ADDON_ACTION_FORBIDDEN")
blockEv:SetScript("OnEvent", function(_, event, addon)
	if not watch or addon ~= "MidnightHelper" or (GetTime() - watch.at) > 2 then
		return
	end
	local s = Settings()
	s.blocked = s.blocked or {}
	s.blocked[watch.kind] = event
	if watch.kind == "delete" then
		pcall(ClearCursor)
		print(PREFIX .. ns:L("FBAG_DESTROY_BLOCKED"))
	elseif watch.kind == "sell" then
		s.sellBlocked = true
		print(PREFIX .. ns:L("FBAG_SELL_BLOCKED"))
	end
	watch = nil
end)

local function RefreshSoon()
	-- display only: re-reading the bags after the server answered
	C_Timer.After(0.6, function()
		if win and win:IsShown() then
			pcall(Show, "after your click")
		end
	end)
end

local function SameItem(e)
	local ok, info = pcall(C.GetContainerItemInfo, e.bag, e.slot)
	return ok and type(info) == "table" and info.itemID == e.id and info
end

--- The "sure?" popup's Yes: a click, so the destroy runs inside it.
local function DoDestroy(e)
	local info = SameItem(e)
	if not info or IsTool(e.id) or KeepKind(e.id) or IsQuestItem(e.bag, e.slot) or (tonumber(info.quality) or 0) >= 3 then
		print(PREFIX .. ns:L("FBAG_DESTROY_GONE"))
		RefreshSoon()
		return
	end
	watch = { kind = "delete", at = GetTime(), name = e.name }
	pcall(ClearCursor)
	pcall(C.PickupContainerItem, e.bag, e.slot)
	local okC, kind, cid = pcall(GetCursorInfo)
	if not (okC and kind == "item" and cid == e.id) then
		pcall(ClearCursor)
		print(PREFIX .. ns:L("FBAG_DESTROY_GONE"))
		RefreshSoon()
		return
	end
	pcall(DeleteCursorItem)
	if CursorHasItem and CursorHasItem() then
		-- still on the cursor: the game did not take it; put it back where it was
		pcall(ClearCursor)
		print(PREFIX .. ns:L("FBAG_DESTROY_BLOCKED"))
	else
		print(PREFIX .. ns:L("FBAG_DESTROY_DONE_FMT"):format(e.link or e.name or "?"))
	end
	RefreshSoon()
end

-- Only a key of our own is added; the global table itself is never assigned (that would taint it).
local DESTROY_POPUP = {
	text = "%s",
	button1 = YES,
	button2 = NO,
	OnAccept = function(_, data)
		if data then
			DoDestroy(data)
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
	preferredIndex = 3,
}
if StaticPopupDialogs then
	StaticPopupDialogs.MH_BAGFULL_DESTROY = DESTROY_POPUP
end

AskDestroy = function(e)
	if not SameItem(e) then
		print(PREFIX .. ns:L("FBAG_DESTROY_GONE"))
		RefreshSoon()
		return
	end
	local label = (e.link or e.name or "?") .. ((e.n or 1) > 1 and (" x" .. e.n) or "")
	if StaticPopup_Show and StaticPopupDialogs and StaticPopupDialogs.MH_BAGFULL_DESTROY then
		StaticPopup_Show("MH_BAGFULL_DESTROY", ns:L("FBAG_DESTROY_CONFIRM_FMT"):format(label), nil, e)
	end
end

LootIt = function(slot)
	watch = { kind = "loot", at = GetTime() }
	if LootSlot then
		pcall(LootSlot, slot)
	end
	RefreshSoon()
end

--- Sell MH junk: grey items only (the same never-list as the window), at most 12 per click (the buyback tab holds 12,
--- Blizzard's MerchantFrame.lua BUYBACK_ITEMS_PER_PAGE, GEMETEN in the Forever UI source).
local sellBtn
local function Greys()
	local out = {}
	for _, e in ipairs((Candidates())) do
		if e.why == "FBAG_WHY_GREY" then
			out[#out + 1] = e
		end
	end
	return out
end

local function UpdateSellButton()
	if not sellBtn then
		return
	end
	local s = Settings()
	local n = #Greys()
	if s.sellBlocked or not (MerchantFrame and MerchantFrame:IsShown()) or n == 0 then
		sellBtn:Hide()
		return
	end
	sellBtn:SetText(ns:L("FBAG_SELL_BTN_FMT"):format(n))
	sellBtn:Show()
end

local function SellJunk()
	if not (MerchantFrame and MerchantFrame:IsShown()) then
		return
	end
	watch = { kind = "sell", at = GetTime() }
	local sold, copper = 0, 0
	for _, e in ipairs(Greys()) do
		if sold >= 12 or Settings().sellBlocked then
			break
		end
		if SameItem(e) and pcall(C.UseContainerItem, e.bag, e.slot) then
			sold = sold + 1
			copper = copper + (e.value or 0)
		end
	end
	if sold > 0 and not Settings().sellBlocked then
		print(PREFIX .. ns:L("FBAG_SELL_DONE_FMT"):format(sold, Money(copper)))
	end
	C_Timer.After(0.8, UpdateSellButton) -- display only
end

local merchantEv = CreateFrame("Frame")
merchantEv:RegisterEvent("MERCHANT_SHOW")
merchantEv:RegisterEvent("MERCHANT_CLOSED")
merchantEv:RegisterEvent("BAG_UPDATE_DELAYED")
merchantEv:SetScript("OnEvent", function(_, event)
	if event == "MERCHANT_SHOW" and not sellBtn and MerchantFrame then
		sellBtn = CreateFrame("Button", nil, MerchantFrame, "UIPanelButtonTemplate")
		sellBtn:SetSize(170, 24)
		sellBtn:SetPoint("TOPLEFT", MerchantFrame, "BOTTOMLEFT", 0, -4)
		sellBtn:SetScript("OnClick", SellJunk)
		sellBtn:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self:GetText() or "", 1, 0.82, 0)
			GameTooltip:AddLine(ns:L("FBAG_SELL_TIP"), 1, 1, 1, true)
			GameTooltip:Show()
		end)
		sellBtn:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end
	pcall(UpdateSellButton)
end)

--------------------------------------------------------------------------------
-- The trigger: the game says "Inventory is full"
--------------------------------------------------------------------------------
local lastAuto = -1000
local ev = CreateFrame("Frame")
ev:RegisterEvent("UI_ERROR_MESSAGE")
ev:SetScript("OnEvent", function(_, _, _, message)
	if not (Readable(message) and message == ERR_INV_FULL) then
		return
	end
	if not Settings().on then
		last.why = "the game said bags full, but the window is switched off (/mh bagfull on)"
		return
	end
	local now = GetTime and GetTime() or 0
	if now - lastAuto < GAP then
		last.why = ("the game said bags full again within %d s: not shown twice"):format(GAP)
		return
	end
	lastAuto = now
	local ok, err = pcall(Show, "the game said bags full")
	if not ok then
		last.why = "error: " .. tostring(err)
	end
end)

--------------------------------------------------------------------------------
-- /mh bagfull test — may an addon button destroy and sell in Forever? (for step 2)
--------------------------------------------------------------------------------
local testFrame, testLog, testBtn
local function EmptySlot()
	if not (C and C.GetContainerNumSlots and C.GetContainerItemInfo) then
		return nil
	end
	for bag = 0, LAST_BAG do
		local okN, slots = pcall(C.GetContainerNumSlots, bag)
		for slot = 1, (okN and slots) or 0 do
			local ok, info = pcall(C.GetContainerItemInfo, bag, slot)
			if ok and info == nil then
				return bag, slot
			end
		end
	end
	return nil
end

local function RunTest(how)
	testLog[how] = testLog[how] or {}
	local r = testLog[how]
	-- The game reports a block as an event, possibly a frame later: it is filed under the phase that runs now (the two
	-- phases are 0.5 s apart) and under the function name it carries.
	testLog.phase = how
	-- Destroy: only with an EMPTY cursor, so nothing can be destroyed.
	local okC, cursor = pcall(GetCursorInfo)
	if okC and cursor == nil and DeleteCursorItem then
		local ok, err = pcall(DeleteCursorItem)
		r.delete = ok and "called" or ("error: " .. tostring(err))
	else
		r.delete = "skipped: something is on the cursor"
	end
	-- Sell / use: only on an EMPTY bag slot, so nothing happens to an item.
	local bag, slot = EmptySlot()
	if bag and C and C.UseContainerItem then
		local ok, err = pcall(C.UseContainerItem, bag, slot)
		r.use = ok and "called" or ("error: " .. tostring(err))
	else
		r.use = "skipped: no empty bag slot"
	end
end

local function PrintTest()
	local db = Settings()
	testLog.phase = nil
	db.test = testLog
	print(PREFIX .. "bagfull test (stored in MidnightHelperDB.foreverBagFull.test after /reload):")
	local r = testLog.click or {}
	print(("  from a click%s: DeleteCursorItem %s, blocked: %s; UseContainerItem %s, blocked: %s"):format(
		testLog.atVendor and " at a vendor" or " (not at a vendor)", tostring(r.delete), tostring(r.deleteBlocked or "no"),
		tostring(r.use), tostring(r.useBlocked or "no")))
	local junk = "?"
	if C_MerchantFrame and C_MerchantFrame.IsSellAllJunkEnabled then
		local ok, v = pcall(C_MerchantFrame.IsSellAllJunkEnabled)
		junk = ok and tostring(v) or "error"
	end
	print("  Blizzard's Sell All Junk enabled: " .. junk .. " (true only means the merchant button can show)")
end

local function StartTest()
	testLog = { at = time and time() or 0 }
	if not testFrame then
		local tf = CreateFrame("Frame")
		tf:RegisterEvent("ADDON_ACTION_BLOCKED")
		tf:RegisterEvent("ADDON_ACTION_FORBIDDEN")
		tf:SetScript("OnEvent", function(_, event, addon, fn)
			local r = testLog and testLog.phase and testLog[testLog.phase]
			if r then
				local key = tostring(fn):find("Delete") and "deleteBlocked" or "useBlocked"
				r[key] = ("%s (%s, %s)"):format(event, tostring(addon), tostring(fn))
			end
		end)
		testFrame = tf
	end
	testBtn = testBtn or CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
	local b = testBtn
	b:SetSize(260, 32)
	b:ClearAllPoints()
	b:SetPoint("CENTER", 0, 200)
	b:SetFrameStrata("DIALOG")
	b:SetText(ns:L("FBAG_TEST_BTN"))
	-- 20 Nov 2026, Rob's test: from a timer UseContainerItem was ADDON_ACTION_BLOCKED (BugGrabber showed it in red). So the
	-- test only tries from the click now; MH never calls these from a timer or an event.
	b:SetScript("OnClick", function(self)
		testLog.atVendor = (MerchantFrame and MerchantFrame:IsShown()) and true or false
		RunTest("click")
		self:Hide()
		C_Timer.After(0.5, PrintTest) -- printing only
	end)
	b:Show()
	print(PREFIX .. ns:L("FBAG_TEST_START"))
end

--------------------------------------------------------------------------------
-- /mh bagfull [show | test | on | off]
--------------------------------------------------------------------------------
function ns.ForeverBagFullSlash(arg)
	arg = (arg or ""):lower()
	local s = Settings()
	if arg == "on" or arg == "off" then
		s.on = (arg == "on")
		print(PREFIX .. ns:L(s.on and "FBAG_ON" or "FBAG_OFF"))
		return
	end
	if arg == "show" then
		Show("/mh bagfull show")
		return
	end
	if arg == "test" then
		StartTest()
		return
	end
	print(PREFIX .. ("bagfull: automatic window %s. Last: %s"):format(s.on and "on" or "off (/mh bagfull on)", last.why))
	local list, skipped = Candidates()
	print(("  now: %d items could go; cheapest: %s"):format(#list,
		list[1] and ("%s, %d copper (%s)"):format(tostring(list[1].name), list[1].value, list[1].why) or "none"))
	local t = {}
	for k, n in pairs(skipped) do
		t[#t + 1] = k .. " " .. n
	end
	print("  left out: " .. (#t > 0 and table.concat(t, ", ") or "nothing"))
	print("  /mh bagfull show = the window now, /mh bagfull test = may an addon button destroy/sell here (step 2)")
end
