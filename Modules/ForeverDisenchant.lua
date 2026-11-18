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

local last = { tip = "none yet", bags = "none yet", baganator = "not seen", next = "off" }

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
				last.tip = "skipped: " .. tostring(why or "item not loaded")
				return
			end
			-- The client's own words where it has them (GlobalStrings ITEM_DISENCHANT_ANY_SKILL "Disenchantable" and
			-- ITEM_DISENCHANT_NOT_DISENCHANTABLE "Cannot be disenchanted", present in all Forever locales, GEMETEN
			-- DB2 70959): every language says what its client says (CLAUDE.md: client name wins).
			local yesWord = type(ITEM_DISENCHANT_ANY_SKILL) == "string" and ITEM_DISENCHANT_ANY_SKILL or nil
			local noWord = type(ITEM_DISENCHANT_NOT_DISENCHANTABLE) == "string" and ITEM_DISENCHANT_NOT_DISENCHANTABLE or nil
			if v == "yes" then
				tooltip:AddLine(yesWord and ("MH: " .. yesWord) or ns:L("FDE_TIP_YES"), 0.6, 0.4, 1)
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
-- Events
--------------------------------------------------------------------------------
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:SetScript("OnEvent", function(_, event, arg1)
	if event == "PLAYER_LOGIN" then
		HookBags()
		HookBaganator()
		MakeButton()
		UpdateNext()
	elseif event == "ADDON_LOADED" then
		if arg1 == "Baganator" then
			HookBaganator()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if btn and btn.pending then
			UpdateNext()
		end
	else -- bags changed, or a profession learned
		UpdateNext()
		if event == "SKILL_LINES_CHANGED" then
			RepaintBags()
			RefreshBaganator()
		end
	end
end)

--- Called by the quiet-helper switches (ForeverOverview.lua) after a change.
function ns.ForeverDisenchantRefresh()
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
end
