--[[
	Openables — toont openbare tas-items (caches, lockboxes, satchels, quest-containers)
	met een klik-om-te-openen knop + uitklaplijst (Rob-wens, 4 jul 2026). Eigen versie,
	geïnspireerd op "New Openables"; geen code-kopie.

	Detectie (never-lie, locale-veilig, 12.x-secret-safe): een tas-item is "openbaar"
	als zijn tooltip de gelokaliseerde regel ITEM_OPENABLE ("<Right Click to Open>")
	bevat. We gebruiken bewust NIET "heeft een use-spell" (dan zouden potions/food ook
	als openbaar tellen → vals-positief). C_TooltipInfo.GetBagItem levert de tooltip-
	regels zonder zichtbaar frame; secret-values guarden we weg.

	Openen = het item gebruiken via een SecureActionButton (type=item, item="bag slot").
	Secure attributen/positie/zichtbaarheid mogen niet in combat gewijzigd worden — dus
	we (her)opbouwen alleen buiten combat; een state-driver verbergt de knop in combat.
]]

local _, ns = ...

--------------------------------------------------------------------------------
-- Detectie
--------------------------------------------------------------------------------

local function IsSecret(v)
	return v ~= nil and issecretvalue ~= nil and issecretvalue(v) == true
end

-- @return true als het item in (bag,slot) openbaar is
local function SlotIsOpenable(bag, slot)
	if not (C_TooltipInfo and C_TooltipInfo.GetBagItem) then
		return false
	end
	local ok, data = pcall(C_TooltipInfo.GetBagItem, bag, slot)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then
		return false
	end
	local openLine = ITEM_OPENABLE -- "<Right Click to Open>" (gelokaliseerd)
	for _, line in ipairs(data.lines) do
		local text = line and line.leftText
		if text and not IsSecret(text) then
			if openLine and (text == openLine or (strfind and strfind(text, openLine, 1, true))) then
				return true
			end
		end
	end
	return false
end

-- @return geordende lijst { { bag, slot, itemID, name, icon, count }, ... }
local function ScanOpenables()
	local out = {}
	if not (C_Container and C_Container.GetContainerNumSlots) then
		return out
	end
	-- 0 = backpack, 1-4 = tassen, 5 = reagent-bag. GetContainerNumSlots geeft 0 voor
	-- niet-bestaande tassen, dus de loop is veilig.
	for bag = 0, 5 do
		local slots = C_Container.GetContainerNumSlots(bag) or 0
		for slot = 1, slots do
			if SlotIsOpenable(bag, slot) then
				local info = C_Container.GetContainerItemInfo(bag, slot)
				if info then
					-- Level-vereiste: verberg items die je nog niet kunt openen (bv. een
					-- level-60-cache op level 23). itemMinLevel = 5e return van GetItemInfo.
					local minLvl = info.itemID and C_Item and C_Item.GetItemInfo
						and select(5, C_Item.GetItemInfo(info.itemID))
					local plvl = (UnitLevel and UnitLevel("player")) or 999
					if not minLvl or minLvl <= plvl then
						out[#out + 1] = {
							bag = bag,
							slot = slot,
							itemID = info.itemID,
							name = info.itemName or (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(info.itemID)) or "?",
							icon = info.iconFileID or "Interface\\Icons\\INV_Misc_Bag_08",
							count = info.stackCount or 1,
						}
					end
				end
			end
		end
	end
	return out
end

ns.GetOpenables = ScanOpenables

--------------------------------------------------------------------------------
-- Aan/uit + settings
--------------------------------------------------------------------------------

local function Enabled()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return true
	end
	return uiDb.openables ~= false
end

function ns.IsOpenablesEnabled()
	return Enabled()
end

function ns.SetOpenablesEnabled(v)
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) == "table" then
		uiDb.openables = v and true or false
	end
	if ns.UpdateOpenables then
		ns.UpdateOpenables()
	end
end

--------------------------------------------------------------------------------
-- UI: hoofdknop (open volgende) + teller-badge + uitklaplijst
--------------------------------------------------------------------------------

local ROWH = 24
local MAXROWS = 12
local frame -- main secure button (UIParent)

local function ApplyOpenAttr(btn, entry)
	-- Alleen buiten combat: secure "gebruik item"-attribuut op bag/slot.
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	if entry then
		btn:SetAttribute("type", "item")
		btn:SetAttribute("item", entry.bag .. " " .. entry.slot)
	else
		btn:SetAttribute("type", nil)
		btn:SetAttribute("item", nil)
	end
end

local function StyleAsBox(f)
	if not f.SetBackdrop then
		return
	end
	f:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 13,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	f:SetBackdropColor(0.08, 0.07, 0.05, 0.92)
	f:SetBackdropBorderColor(1, 0.82, 0.2, 1) -- goud
end

local function EnsureRow(i)
	local rows = frame._rows
	local r = rows[i]
	if r then
		return r
	end
	-- Secure rij-knop als KIND van de hoofdknop (frame). Kind van een frame anchoren
	-- aan dat frame mag; positie ligt vast, we wijzigen alleen attribuut + show/hide
	-- (buiten combat). Zo geen "cannot anchor protected frame".
	r = CreateFrame("Button", nil, frame, "SecureActionButtonTemplate")
	r:SetHeight(ROWH)
	r:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -6 - (i - 1) * (ROWH + 2))
	r:SetPoint("RIGHT", frame, "RIGHT", 120, 0)
	r:RegisterForClicks("AnyUp", "AnyDown")
	if r.SetBackdrop then
		r:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
		r:SetBackdropColor(0.14, 0.11, 0.07, 0.9)
	end
	local icon = r:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("LEFT", r, "LEFT", 3, 0)
	icon:SetSize(ROWH - 6, ROWH - 6)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	r._icon = icon
	local nm = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	nm:SetPoint("LEFT", icon, "RIGHT", 6, 0)
	nm:SetPoint("RIGHT", r, "RIGHT", -6, 0)
	nm:SetJustifyH("LEFT")
	nm:SetWordWrap(false)
	r._name = nm
	r:SetScript("OnEnter", function(self)
		if self._bag and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetBagItem(self._bag, self._slot)
			GameTooltip:Show()
		end
		if r.SetBackdropColor then
			r:SetBackdropColor(0.25, 0.2, 0.1, 0.95)
		end
	end)
	r:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
		if r.SetBackdropColor then
			r:SetBackdropColor(0.14, 0.11, 0.07, 0.9)
		end
	end)
	r:Hide()
	rows[i] = r
	return r
end

local function EnsureFrame()
	if frame then
		return frame
	end
	local f = CreateFrame("Button", "MidnightHelperOpenables", UIParent, "SecureActionButtonTemplate")
	f:SetSize(40, 40)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:RegisterForClicks("LeftButtonUp", "LeftButtonDown") -- links = openen
	f:RegisterForDrag("RightButton") -- rechts-slepen verplaatst
	f:SetMovable(true)
	f:EnableMouse(true)
	local pos = ns.db and ns.db.ui and ns.db.ui.openablesPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", -220, 120)
	end
	if ns.db and ns.db.ui and ns.db.ui.openablesScale then
		f:SetScale(ns.db.ui.openablesScale)
	end
	-- gouden rand
	local border = CreateFrame("Frame", nil, f, "BackdropTemplate")
	border:SetPoint("TOPLEFT", f, "TOPLEFT", -4, 4)
	border:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 4, -4)
	if border.SetBackdrop then
		border:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 13 })
		border:SetBackdropBorderColor(1, 0.82, 0.2, 1)
	end
	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints(f)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	f._icon = icon
	-- teller-badge
	local badge = f:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	badge:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
	badge:SetTextColor(1, 0.9, 0.4)
	f._badge = badge
	-- uitklap-pijltje (niet-secure) rechtsboven
	local toggle = CreateFrame("Button", nil, f)
	toggle:SetSize(16, 16)
	toggle:SetPoint("TOPRIGHT", f, "TOPRIGHT", 6, 6)
	toggle:SetNormalTexture("Interface\\Buttons\\UI-SquareButton-Down")
	toggle:SetScript("OnClick", function()
		frame._expanded = not frame._expanded
		if ns.db and ns.db.ui then
			ns.db.ui.openablesExpanded = frame._expanded
		end
		if ns.UpdateOpenables then
			ns.UpdateOpenables()
		end
	end)
	f._toggle = toggle
	f._rows = {}
	f._expanded = ns.db and ns.db.ui and ns.db.ui.openablesExpanded or false
	-- state-driver: verberg in combat (openen kan toch niet in combat; en secure
	-- attributen/positie mogen daar niet wijzigen). Buiten combat sturen we zelf.
	RegisterStateDriver(f, "visibility", "[combat] hide; nil")
	f:SetScript("OnDragStart", function(self)
		if InCombatLockdown and InCombatLockdown() then
			return
		end
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local p, _, rp, x, y = self:GetPoint()
		if p and ns.db and ns.db.ui then
			ns.db.ui.openablesPos = { p, rp, x, y }
		end
	end)
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(self, delta)
		if not IsShiftKeyDown() then
			return
		end
		local s = math.max(0.5, math.min(2.5, (self:GetScale() or 1) + (delta > 0 and 0.1 or -0.1)))
		self:SetScale(s)
		if ns.db and ns.db.ui then
			ns.db.ui.openablesScale = s
		end
	end)
	f:SetScript("OnEnter", function(self)
		if self._topBag and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetBagItem(self._topBag, self._topSlot)
			GameTooltip:AddLine(ns:L("OPEN_TIP_HINT"), 0.7, 0.7, 0.7, true)
			GameTooltip:Show()
		end
	end)
	f:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	f:Hide()
	frame = f
	return f
end

-- geluid bij een NIEUW openbaar item
local lastCount = 0

function ns.UpdateOpenables()
	if not Enabled() then
		if frame then
			frame:Hide()
		end
		lastCount = 0
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		return -- niks aan protected frames in combat; state-driver regelt de zichtbaarheid
	end
	local list = ScanOpenables()
	local n = #list
	if n == 0 then
		if frame then
			frame:Hide()
		end
		lastCount = 0
		return
	end
	local f = EnsureFrame()
	-- geluid als er iets bijkwam (tenzij uitgezet in settings)
	local soundOn = not (ns.db and ns.db.ui and ns.db.ui.openablesSound == false)
	if n > lastCount and soundOn and PlaySound then
		PlaySound((SOUNDKIT and SOUNDKIT.IG_BACKPACK_OPEN) or 5274, "SFX")
	end
	lastCount = n

	local top = list[1]
	f._icon:SetTexture(top.icon)
	f._topBag, f._topSlot = top.bag, top.slot
	f._badge:SetText(n > 1 and tostring(n) or "")
	ApplyOpenAttr(f, top)

	-- rijen (uitklaplijst)
	local showRows = frame._expanded
	for i = 1, MAXROWS do
		local e = list[i]
		local r = f._rows[i]
		if showRows and e then
			r = EnsureRow(i)
			r._icon:SetTexture(e.icon)
			r._name:SetText((e.count and e.count > 1 and (e.count .. "x ") or "") .. (e.name or "?"))
			r._bag, r._slot = e.bag, e.slot
			ApplyOpenAttr(r, e)
			r:Show()
		elseif r then
			r:Hide()
		end
	end
	f:Show()
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

local throttle = 0
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:RegisterEvent("ITEM_LOCK_CHANGED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("PLAYER_LEVEL_UP") -- level-gated cache wordt openbaar bij het juiste level
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED") -- item-info kwam alsnog binnen (level/naam)

local function Schedule()
	if throttle > 0 then
		return
	end
	throttle = 1
	if C_Timer and C_Timer.After then
		C_Timer.After(0.3, function()
			throttle = 0
			ns.UpdateOpenables()
		end)
	else
		throttle = 0
		ns.UpdateOpenables()
	end
end

ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
		EnsureFrame()
	end
	Schedule()
end)
