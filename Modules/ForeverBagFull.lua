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
	Never suggested: quest items, profession tools (ns.ForeverIsTool, ForeverToolGuard.lua), ingredients for a profession
	you have (ns.ReagentUseText green), gear better than what you wear (ns.ForeverGearTipText), Rare and better (Forever
	asks you to type DELETE for those), items without a vendor value, special bags.
	Step 2 (NOT built, after Rob's test): a Destroy button (your click + "sure?") that then loots, and "Sell MH junk" at a
	vendor. /mh bagfull test measures whether Forever lets an addon button do that: it calls the two functions on NOTHING
	(DeleteCursorItem with an empty cursor, UseContainerItem on an empty slot) from a click and from a timer, and records
	whether the game blocked them (ADDON_ACTION_BLOCKED / ADDON_ACTION_FORBIDDEN). No item can be lost by the test.
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
				elseif ns.ForeverIsTool and ns.ForeverIsTool(id) then
					skip("profession tool")
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
					best = { link = link, n = (okI and tonumber(qty)) or 1, value = v }
				end
			end
		end
	end
	return best
end

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------
local W, H, ROWS = 460, 300, 3
local win

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
		r.name:SetPoint("RIGHT", r, "RIGHT", -110, 0)
		r.name:SetJustifyH("LEFT")
		r.name:SetWordWrap(false)
		r.value = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		r.value:SetPoint("TOPRIGHT", r, "TOPRIGHT", 0, -1)
		r.value:SetJustifyH("RIGHT")
		r.why = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		r.why:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -3)
		r.why:SetPoint("RIGHT", r, "RIGHT", 0, 0)
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
			r:Show()
		else
			r.bag = nil
			r:Hide()
		end
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
	for _, how in ipairs({ "click", "timer" }) do
		local r = testLog[how] or {}
		print(("  from a %s: DeleteCursorItem %s, blocked: %s; UseContainerItem %s, blocked: %s"):format(how,
			tostring(r.delete), tostring(r.deleteBlocked or "no"), tostring(r.use), tostring(r.useBlocked or "no")))
	end
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
	b:SetScript("OnClick", function(self)
		RunTest("click")
		self:Hide()
		C_Timer.After(0.5, function()
			RunTest("timer")
			C_Timer.After(0.5, PrintTest)
		end)
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
