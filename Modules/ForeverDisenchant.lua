local _, ns = ...

--[[
	ForeverDisenchant.lua — WoW Forever: can this item be disenchanted? (18 Nov 2026)
	Rob, via sparring, letterlijk: "Toevallig heb ik een enchanter nu geleerd. Hoe kan ik zien of ik iets kan
	disenchanten? En als we dat niet zo sterk kunnen zien, kunnen wij dat dan zelf maken voor onze tassen?" → on the
	proposal "Ja, dat mag zo. En de tassen die ik zelf gebruik zijn van Baconator [Baganator] …" → "ja".

	Research: docs/forever/DISENCHANT_2026-11-18.md (mh-research + a second, independent Opus check). In short:
	- GEMETEN (DB2 Forever 1.60.1.70959, ItemDisenchantLoot): only weapons (class 2) and armor (class 4) of quality 2-4
	  (green, blue, purple) have a result row, per item-level band (ForeverDisenchantData.lua BRACKETS). SkillRequired
	  is 0 on every row: in Forever no skill gate (AFGELEID; guide + wiki agree), so the line says yes or no.
	- GEMETEN: ItemSparse Flags_0 bit 0x8000 (TrinityCore ITEM_FLAG_NO_DISENCHANT) on 1615 items (PvP rank gear,
	  insignia, enchanter wands, costume sets) → "no". That the server uses the bit = AFGELEID.
	- No sell price: TrinityCore refuses those; Forever's server NOT measured → "probably, not sure", never "no".
	- The client has no "can be disenchanted" function (GEMETEN in Blizzard's Forever UI source).

	Three things, each with its own switch (stille helpers):
	1. A tooltip line on weapons and armor, only for a character that knows Enchanting (foreverDisenchant, on).
	2. A small Disenchant icon on the items that can, in Blizzard's bags and in Baganator (same switch). Baganator is
	   All Rights Reserved: we only CALL its public API (Baganator.API.RegisterCornerWidget), nothing is copied.
	3. A "Disenchant next" button (foreverDisenchantNext, OFF: players choose). A SecureActionButton with type "spell",
	   spell 13262 and target-bag/target-slot (GEMETEN in Forever's SecureTemplates.lua): one click = one cast on the
	   item it shows. MH picks the next item only out of combat; the button hides in combat; no loop, no timer.
	4. Ctrl+Shift+click on a bag item = Disenchant it (foreverDisenchantClick, on; 25 Nov 2026). Rob via sparring,
	   letterlijk: "Kunnen wij een knop in de tooltip bouwen als we een item kunnen disenchanten? Zodat ik niet eerst
	   disenchant moet drukken, dan het ding wat ik wil disenchanten, maar dat we gewoon de tooltip daarvan kunnen
	   gebruiken." → on the proposal (Ctrl+Shift+click, Blizzard bags + Baganator, Disenchant first): "Ja". Idea seen in
	   ForeverForge Bags (licence unknown, not installed): nothing taken from it, own build.
	   How: ONE secure button (parented to UIParent, never anchored to a bag button: that would make the bags
	   protected). When the item tooltip shows a "yes" item in your own bags (bag 0..NUM_BAG_SLOTS; the link at that
	   bag/slot must match the tooltip), MH moves the button over that slot out of combat, with the same attributes as
	   the next button. A state driver "[combat] hide; [mod:ctrl,mod:shift] show; hide" shows it only while Ctrl and
	   Shift are both held, so a plain click always reaches the bag slot. Leaving the slot, a bag change or the slot
	   holding another item = disarm. Blizzard bag buttons and Baganator's live buttons both have GetBagID()/GetID()
	   (GEMETEN: Baganator ItemViewCommon/ItemButton.lua:628).

	/mh disenchant prints every decision (CLAUDE.md: a module that can stay quiet needs that).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local DE_SPELL = 13262
local ICON = "Interface\\Icons\\INV_Enchant_Disenchant"

local function On()
	return not (ns.db and ns.db.foreverDisenchant == false)
end

local function NextOn()
	return ns.db and ns.db.foreverDisenchantNext == true
end

local function ClickOn()
	return not (ns.db and ns.db.foreverDisenchantClick == false)
end

local function Enchanter()
	local ok, mine = pcall(function()
		return ns.ForeverMyProfessions and ns.ForeverMyProfessions()
	end)
	return ok and type(mine) == "table" and mine.ENCHANTING ~= nil
end

local function SpellIcon()
	if C_Spell and C_Spell.GetSpellTexture then
		local ok, t = pcall(C_Spell.GetSpellTexture, DE_SPELL)
		if ok and t then
			return t
		end
	end
	return ICON
end

local NO_DE -- set of item ids that never can (built once from the data file)
local function NoSet()
	if not NO_DE then
		NO_DE = {}
		for _, id in ipairs((ns.FOREVER_DE_DATA or {}).noDisenchant or {}) do
			NO_DE[id] = true
		end
	end
	return NO_DE
end

local function InBracket(classID, quality, ilvl)
	for _, b in ipairs((ns.FOREVER_DE_DATA or {}).brackets or {}) do
		if b[1] == classID and b[2] == quality and ilvl >= b[3] and ilvl <= b[4] then
			return true
		end
	end
	return false
end

--- Can this item be disenchanted? @return "yes" | "unsure" | "no" | nil (item not loaded yet), reason key
function ns.ForeverDisenchantVerdict(item)
	if not (item and C_Item and C_Item.GetItemInfo) then
		return nil
	end
	local ok, _, _, quality, ilvl, _, _, _, maxStack, _, _, sellPrice, classID, _, bindType = pcall(C_Item.GetItemInfo, item)
	if not ok or quality == nil then
		return nil
	end
	if classID ~= 2 and classID ~= 4 then
		return "no", "FDE_WHY_KIND"
	end
	if quality < 2 or quality > 4 then
		return "no", "FDE_WHY_QUALITY"
	end
	local id = C_Item.GetItemInfoInstant and select(1, C_Item.GetItemInfoInstant(item))
	if id and NoSet()[id] then
		return "no", "FDE_WHY_FLAG"
	end
	if (maxStack or 1) > 1 then
		return "no", "FDE_WHY_STACK"
	end
	if bindType == 4 then
		return "no", "FDE_WHY_QUEST"
	end
	if not InBracket(classID, quality, ilvl or 0) then
		return "no", "FDE_WHY_LEVEL"
	end
	if (sellPrice or 0) == 0 then
		return "unsure", "FDE_WHY_NOPRICE"
	end
	return "yes"
end

local last = { tip = "none yet", bags = "none yet", baganator = "not seen", next = "off", click = "no bag item hovered yet" }
local ClickHover -- section 4; the tooltip calls it for a "yes" item

--------------------------------------------------------------------------------
-- 1. Tooltip line
--------------------------------------------------------------------------------
if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType
	and Enum.TooltipDataType.Item then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip)
		if not On() or not (tooltip == GameTooltip or tooltip == ItemRefTooltip) or not Enchanter() then
			return
		end
		local ok, err = pcall(function()
			local _, link = tooltip:GetItem()
			if not link then
				return
			end
			local v, why = ns.ForeverDisenchantVerdict(link)
			if v == nil or why == "FDE_WHY_KIND" then
				-- Readable reason first, the internal code after it for us (Rob 18 Nov read the bare code as a bug).
				last.tip = why and ("skipped: " .. ns:L(why) .. " (" .. why .. ")") or "skipped: item not loaded"
				return
			end
			-- The client's own words where it has them (GlobalStrings ITEM_DISENCHANT_ANY_SKILL "Disenchantable" and
			-- ITEM_DISENCHANT_NOT_DISENCHANTABLE "Cannot be disenchanted", present in all Forever locales, GEMETEN
			-- DB2 70959): every language says what its client says (CLAUDE.md: client name wins).
			local yesWord = type(ITEM_DISENCHANT_ANY_SKILL) == "string" and ITEM_DISENCHANT_ANY_SKILL or nil
			local noWord = type(ITEM_DISENCHANT_NOT_DISENCHANTABLE) == "string" and ITEM_DISENCHANT_NOT_DISENCHANTABLE or nil
			if v == "yes" then
				tooltip:AddLine(yesWord and ("MH: " .. yesWord) or ns:L("FDE_TIP_YES"), 0.6, 0.4, 1)
				if tooltip == GameTooltip and ClickHover then
					ClickHover(tooltip, link)
				end
			elseif v == "unsure" then
				tooltip:AddLine(ns:L("FDE_TIP_UNSURE"), 1, 0.82, 0.2, true)
			else
				tooltip:AddLine(noWord and ("MH: %s (%s)"):format(noWord, ns:L(why))
					or ns:L("FDE_TIP_NO_FMT"):format(ns:L(why)), 0.6, 0.6, 0.6, true)
			end
			last.tip = v .. " " .. tostring(why or "")
			tooltip:Show()
		end)
		if not ok then
			last.tip = "error: " .. tostring(err)
		end
	end)
else
	last.tip = "this client has no TooltipDataProcessor"
end

--------------------------------------------------------------------------------
-- 2a. Blizzard bags: a small icon on what can be disenchanted. A post-hook of each frame's UpdateItems (the secure
-- path runs first); our own textures, kept in our own table, never a script of Blizzard's buttons.
--------------------------------------------------------------------------------
local marks = setmetatable({}, { __mode = "k" })

local function Mark(btn, show)
	local t = marks[btn]
	if not t then
		if not show then
			return
		end
		t = btn:CreateTexture(nil, "OVERLAY", nil, 6)
		t:SetSize(14, 14)
		t:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
		t:SetTexture(SpellIcon())
		marks[btn] = t
	end
	t:SetShown(show)
end

local function PaintFrame(frame)
	if not (frame and frame.EnumerateValidItems) then
		return
	end
	local want = On() and Enchanter()
	local n = 0
	for _, btn in frame:EnumerateValidItems() do
		local show = false
		if want and btn.GetBagID and C_Container and C_Container.GetContainerItemInfo then
			local okI, info = pcall(C_Container.GetContainerItemInfo, btn:GetBagID(), btn:GetID())
			if okI and info and info.hyperlink then
				show = ns.ForeverDisenchantVerdict(info.hyperlink) == "yes"
			end
		end
		Mark(btn, show)
		if show then
			n = n + 1
		end
	end
	last.bags = ("%d marked in %s"):format(n, frame.GetName and frame:GetName() or "a bag")
end

local hooked = {}
local function HookBags()
	local frames = {}
	if ContainerFrameContainer and ContainerFrameContainer.ContainerFrames then
		for _, fr in ipairs(ContainerFrameContainer.ContainerFrames) do
			frames[#frames + 1] = fr
		end
	end
	for i = 1, 13 do
		frames[#frames + 1] = _G["ContainerFrame" .. i]
	end
	frames[#frames + 1] = ContainerFrameCombinedBags
	for _, fr in ipairs(frames) do
		if fr and not hooked[fr] and fr.UpdateItems then
			hooked[fr] = true
			hooksecurefunc(fr, "UpdateItems", PaintFrame)
		end
	end
end

local function RepaintBags()
	for fr in pairs(hooked) do
		if fr.IsShown and fr:IsShown() then
			pcall(PaintFrame, fr)
		end
	end
end

--------------------------------------------------------------------------------
-- 2b. Baganator: its public corner-widget API (Baganator API\Main.lua; signature in the research doc).
--------------------------------------------------------------------------------
local bagRegistered = false
local function HookBaganator()
	if bagRegistered or not (Baganator and Baganator.API and Baganator.API.RegisterCornerWidget) then
		return
	end
	local ok, err = pcall(Baganator.API.RegisterCornerWidget, ns:L("FDE_BAGANATOR_LABEL"), "midnighthelper_disenchant",
		function(corner, details)
			if not (On() and Enchanter()) then
				return false
			end
			local v = details and details.itemLink and ns.ForeverDisenchantVerdict(details.itemLink)
			if v == nil then
				return nil -- not loaded yet: Baganator asks again later
			end
			return v == "yes"
		end,
		function(itemButton)
			local t = itemButton:CreateTexture(nil, "OVERLAY")
			t:SetSize(15, 15)
			t:SetTexture(SpellIcon())
			return t
		end,
		{ corner = "top_left", priority = 1 })
	bagRegistered = ok
	last.baganator = ok and "registered (Baganator: Customise lets you move or hide it)" or ("error: " .. tostring(err))
end

local function RefreshBaganator()
	if bagRegistered and Baganator.API.RequestItemButtonsRefresh and Baganator.Constants
		and Baganator.Constants.RefreshReason then
		pcall(Baganator.API.RequestItemButtonsRefresh, { Baganator.Constants.RefreshReason.ItemWidgets })
	end
end

--------------------------------------------------------------------------------
-- 3. "Disenchant next": the visible part is the secure button itself (parented to UIParent, never to a bag
-- button). Out of combat MH sets target-bag/target-slot to the next "yes" item; the player clicks: one cast.
--------------------------------------------------------------------------------
local skip = {} -- itemLink → true for this session (right-click)
local btn

local function PickNext()
	if not (C_Container and C_Container.GetContainerNumSlots) then
		return nil
	end
	for bag = 0, (NUM_BAG_SLOTS or 4) do
		local okN, n = pcall(C_Container.GetContainerNumSlots, bag)
		for slot = 1, (okN and n or 0) do
			local okI, info = pcall(C_Container.GetContainerItemInfo, bag, slot)
			local link = okI and info and info.hyperlink
			if link and not info.isLocked and not skip[link] and ns.ForeverDisenchantVerdict(link) == "yes" then
				return bag, slot, link, info.iconFileID
			end
		end
	end
	return nil
end

local function UpdateNext()
	if not btn then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		btn.pending = true
		return
	end
	btn.pending = nil
	if not (NextOn() and Enchanter()) then
		UnregisterStateDriver(btn, "visibility")
		btn:Hide()
		last.next = NextOn() and "on, but this character has no Enchanting" or "off"
		return
	end
	local bag, slot, link, icon = PickNext()
	if bag then
		btn:SetAttribute("type1", "spell")
		btn:SetAttribute("spell", DE_SPELL)
		btn:SetAttribute("target-bag", bag)
		btn:SetAttribute("target-slot", slot)
		btn.icon:SetTexture(icon or SpellIcon())
		btn.icon:SetDesaturated(false)
		btn.label:SetText(ns:L("FDE_NEXT_FMT"):format(link))
		btn.link = link
		last.next = ("bag %d slot %d: %s"):format(bag, slot, link)
	else
		btn:SetAttribute("type1", nil)
		btn:SetAttribute("target-bag", nil)
		btn:SetAttribute("target-slot", nil)
		btn.icon:SetTexture(SpellIcon())
		btn.icon:SetDesaturated(true)
		btn.label:SetText(ns:L("FDE_NEXT_NONE"))
		btn.link = nil
		last.next = "nothing to disenchant in your bags"
	end
	RegisterStateDriver(btn, "visibility", "[combat] hide; show")
end

local function MakeButton()
	if btn or not CreateFrame then
		return
	end
	btn = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")
	btn:SetSize(36, 36)
	btn:SetFrameStrata("DIALOG")
	local pos = ns.db and ns.db.foreverDisenchantPos
	if type(pos) == "table" and pos[1] then
		btn:SetPoint(pos[1], UIParent, pos[1], pos[2] or 0, pos[3] or 0)
	else
		btn:SetPoint("RIGHT", UIParent, "RIGHT", -260, 0)
	end
	btn:RegisterForClicks("LeftButtonUp")
	-- Pin the click phase (Fable check, 18 Nov 2026): without this the CVar ActionButtonUseKeyDown decides, and "on" leaves
	-- an Up-only button dead (Forever SecureTemplates.lua, SecureActionButton_ShouldUseOnKeyDown; FastMark.lua pins too).
	btn:SetAttribute("useOnKeyDown", false)
	-- Alt+left is for moving: no action then.
	btn:SetAttribute("alt-type1", "")
	btn.icon = btn:CreateTexture(nil, "ARTWORK")
	btn.icon:SetAllPoints()
	btn.label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	btn.label:SetPoint("TOP", btn, "BOTTOM", 0, -2)
	btn:SetMovable(true)
	btn:RegisterForDrag("LeftButton")
	btn:SetScript("OnDragStart", function(self)
		if IsAltKeyDown() and not InCombatLockdown() then
			self:StartMoving()
		end
	end)
	btn:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local p, _, _, x, y = self:GetPoint(1)
		if ns.db then
			ns.db.foreverDisenchantPos = { p, x, y }
		end
	end)
	-- Right-click: skip this item for this session (not a secure click: RegisterForClicks is left only).
	btn:HookScript("OnMouseUp", function(self, mouse)
		if mouse == "RightButton" and self.link and not InCombatLockdown() then
			skip[self.link] = true
			print(PREFIX .. ns:L("FDE_SKIPPED_FMT"):format(self.link))
			UpdateNext()
		end
	end)
	btn:HookScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		if self.link then
			GameTooltip:SetHyperlink(self.link)
		else
			GameTooltip:SetText(ns:L("FDE_NEXT_NONE"))
		end
		GameTooltip:AddLine(ns:L("FDE_NEXT_TIP"), 1, 1, 1, true)
		GameTooltip:Show()
	end)
	btn:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	btn:Hide()
end

--------------------------------------------------------------------------------
-- 4. Ctrl+Shift+click on a bag item (see the header). One secure button that sits over the hovered slot while
-- Ctrl+Shift is held. It is never anchored to the bag button: MH places it by screen position on UIParent.
--------------------------------------------------------------------------------
local over -- the secure overlay button
local hover -- { owner, bag, slot, link }: the bag slot whose tooltip said "yes"
local armedFor -- the hover the overlay is placed on

local function LinkAt(bag, slot)
	if not (C_Container and C_Container.GetContainerItemInfo) then
		return nil
	end
	local ok, info = pcall(C_Container.GetContainerItemInfo, bag, slot)
	return ok and info and info.hyperlink or nil
end

--- Bag and slot of a bag button (Blizzard's or Baganator's), only for your own bags. nil when it is not one.
local function SlotOf(owner)
	if not (owner and owner.GetID) then
		return nil
	end
	local okB, bag = pcall(function()
		local b = owner.GetBagID and owner:GetBagID()
		if type(b) == "number" then
			return b
		end
		-- Baganator's classic-style buttons keep the bag id on their parent (ItemButton.lua:1286, SetBagItem). Only for a
		-- Baganator button (it carries .BGR): a character-sheet slot also has an id, and its parent would read as bag 0.
		if type(owner.BGR) ~= "table" then
			return nil
		end
		local p = owner.GetParent and owner:GetParent()
		return p and p.GetID and p:GetID()
	end)
	local okS, slot = pcall(owner.GetID, owner)
	if not (okB and okS and type(bag) == "number" and type(slot) == "number") then
		return nil
	end
	if bag < 0 or bag > (NUM_BAG_SLOTS or 4) or slot < 1 then
		return nil -- bank, keyring or something that is not a bag slot: you can only disenchant from your bags
	end
	return bag, slot
end

local function Disarm(reason)
	armedFor = nil
	if not over then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		over.pendingDisarm = true -- the state driver already hides it in combat
		return
	end
	over.pendingDisarm = nil
	UnregisterStateDriver(over, "visibility")
	over:Hide()
	over:SetAttribute("type", nil)
	over:SetAttribute("target-bag", nil)
	over:SetAttribute("target-slot", nil)
	if reason then
		last.click = "off: " .. reason
	end
end

local function MakeOverlay()
	if over or not CreateFrame then
		return
	end
	over = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")
	over:SetFrameStrata("FULLSCREEN_DIALOG")
	over:RegisterForClicks("LeftButtonUp")
	over:SetAttribute("useOnKeyDown", false) -- same reason as the next button (ActionButtonUseKeyDown)
	over:SetAttribute("spell", DE_SPELL)
	local glow = over:CreateTexture(nil, "OVERLAY")
	glow:SetAllPoints()
	glow:SetColorTexture(0.6, 0.4, 1, 0.35)
	local mark = over:CreateTexture(nil, "OVERLAY", nil, 1)
	mark:SetSize(16, 16)
	mark:SetPoint("CENTER")
	mark:SetTexture(SpellIcon())
	over:HookScript("OnEnter", function(self)
		if armedFor then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			pcall(GameTooltip.SetBagItem, GameTooltip, armedFor.bag, armedFor.slot)
			GameTooltip:AddLine(ns:L("FDE_CLICK_ARMED"), 0.6, 0.4, 1, true)
			GameTooltip:Show()
		end
	end)
	over:HookScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)
	-- While shown: stop as soon as the mouse is elsewhere, the bag closed, or the slot holds another item.
	local acc = 0
	over:HookScript("OnUpdate", function(self, elapsed)
		acc = acc + elapsed
		if acc < 0.1 then
			return
		end
		acc = 0
		local a = armedFor
		if not a then
			return Disarm("nothing armed")
		end
		if not self:IsMouseOver() then
			return Disarm("mouse left the slot")
		end
		if not (a.owner.IsVisible and a.owner:IsVisible()) then
			return Disarm("the bag closed")
		end
		if LinkAt(a.bag, a.slot) ~= a.link then
			return Disarm("the slot holds another item now")
		end
	end)
	over:HookScript("PostClick", function()
		local a = armedFor
		last.click = a and ("cast on bag %d slot %d: %s"):format(a.bag, a.slot, a.link) or "clicked, nothing armed"
	end)
	over:Hide()
end

local function Arm()
	local h = hover
	if not (h and over and ClickOn() and Enchanter()) then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		last.click = "not in combat"
		return
	end
	if not (h.owner:IsVisible() and h.owner:IsMouseOver()) or LinkAt(h.bag, h.slot) ~= h.link then
		hover = nil
		return Disarm("the slot under the mouse changed")
	end
	if armedFor == h then
		return
	end
	local okL, l, b, w, hgt = pcall(function()
		return h.owner:GetLeft(), h.owner:GetBottom(), h.owner:GetWidth(), h.owner:GetHeight()
	end)
	if not (okL and l and b and w and hgt) then
		return Disarm("could not read where the slot is")
	end
	local s = h.owner:GetEffectiveScale() / UIParent:GetEffectiveScale()
	over:ClearAllPoints()
	over:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", l * s, b * s)
	over:SetSize(w * s, hgt * s)
	over:SetFrameLevel(math.min(10000, (h.owner:GetFrameLevel() or 0) + 20))
	over:SetAttribute("type", "spell")
	over:SetAttribute("target-bag", h.bag)
	over:SetAttribute("target-slot", h.slot)
	armedFor = h
	RegisterStateDriver(over, "visibility", "[combat] hide; [mod:ctrl,mod:shift] show; hide")
	last.click = ("armed on bag %d slot %d: %s"):format(h.bag, h.slot, h.link)
end

ClickHover = function(tooltip, link)
	if not (ClickOn() and Enchanter()) then
		return
	end
	local owner = tooltip.GetOwner and tooltip:GetOwner()
	if owner == over then
		return
	end
	local bag, slot = SlotOf(owner)
	if not bag then
		last.click = "tooltip is not on one of your bag slots"
		return
	end
	if LinkAt(bag, slot) ~= link then
		last.click = "the item in that slot is not the tooltip's item"
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		last.click = "not in combat"
		return
	end
	tooltip:AddLine(ns:L("FDE_CLICK_HINT"), 0.6, 0.4, 1, true)
	if not (hover and hover.owner == owner and hover.bag == bag and hover.slot == slot and hover.link == link) then
		hover = { owner = owner, bag = bag, slot = slot, link = link }
		last.click = ("ready on bag %d slot %d (hold Ctrl+Shift)"):format(bag, slot)
	end
	if IsControlKeyDown() and IsShiftKeyDown() then
		Arm()
	end
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:RegisterEvent("MODIFIER_STATE_CHANGED")
ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:SetScript("OnEvent", function(_, event, arg1)
	if event == "PLAYER_LOGIN" then
		HookBags()
		HookBaganator()
		MakeButton()
		MakeOverlay()
		UpdateNext()
	elseif event == "ADDON_LOADED" then
		if arg1 == "Baganator" then
			HookBaganator()
		end
	elseif event == "MODIFIER_STATE_CHANGED" then
		if hover and IsControlKeyDown() and IsShiftKeyDown() then
			Arm()
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		hover = nil
		Disarm("combat started")
	elseif event == "PLAYER_REGEN_ENABLED" then
		if btn and btn.pending then
			UpdateNext()
		end
		if over and over.pendingDisarm then
			Disarm()
		end
	else -- bags changed, or a profession learned
		if event == "BAG_UPDATE_DELAYED" and armedFor then
			hover = nil
			Disarm("your bags changed")
		end
		UpdateNext()
		if event == "SKILL_LINES_CHANGED" then
			RepaintBags()
			RefreshBaganator()
		end
	end
end)

--- Called by the quiet-helper switches (ForeverOverview.lua) after a change.
function ns.ForeverDisenchantRefresh()
	if not ClickOn() then
		hover = nil
		Disarm("switched off")
	end
	HookBags()
	RepaintBags()
	RefreshBaganator()
	UpdateNext()
end

--- /mh disenchant [on|off|next on|next off]: the switches and the last decisions.
function ns.ForeverDisenchantSlash(arg)
	arg = (arg or ""):lower()
	ns.db = ns.db or {}
	if arg == "on" then
		ns.db.foreverDisenchant = nil
	elseif arg == "off" then
		ns.db.foreverDisenchant = false
	elseif arg == "next on" then
		ns.db.foreverDisenchantNext = true
	elseif arg == "next off" then
		ns.db.foreverDisenchantNext = nil
	elseif arg == "click on" then
		ns.db.foreverDisenchantClick = nil
	elseif arg == "click off" then
		ns.db.foreverDisenchantClick = false
	end
	ns.ForeverDisenchantRefresh()
	local known = false
	if C_SpellBook and C_SpellBook.IsSpellKnown then
		local ok, k = pcall(C_SpellBook.IsSpellKnown, DE_SPELL)
		known = ok and k
	end
	local yes, unsure, no = 0, 0, 0
	if C_Container and C_Container.GetContainerNumSlots then
		for bag = 0, (NUM_BAG_SLOTS or 4) do
			local okN, n = pcall(C_Container.GetContainerNumSlots, bag)
			for slot = 1, (okN and n or 0) do
				local okI, info = pcall(C_Container.GetContainerItemInfo, bag, slot)
				if okI and info and info.hyperlink then
					local v, why = ns.ForeverDisenchantVerdict(info.hyperlink)
					if v == "yes" then
						yes = yes + 1
					elseif v == "unsure" then
						unsure = unsure + 1
					elseif v == "no" and why ~= "FDE_WHY_KIND" then
						no = no + 1
					end
				end
			end
		end
	end
	print(PREFIX .. ("disenchant: tooltip + bag icons %s, next button %s; Enchanting learned: %s; spell 13262 known (spellbook): %s"):format(
		On() and "on" or "off", NextOn() and "on" or "off", tostring(Enchanter()), tostring(known)))
	print(("  in your bags: %d yes, %d not sure (no sell price), %d weapons/armor that cannot"):format(yes, unsure, no))
	print("  last tooltip: " .. last.tip .. " | bags: " .. last.bags .. " | Baganator: " .. last.baganator)
	print("  next button: " .. last.next)
	print(("  Ctrl+Shift+click: %s; last: %s"):format(ClickOn() and "on" or "off", last.click))
end
