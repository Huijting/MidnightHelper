--[[
	Consumable Ready Board — icoon-stijl (Rob-keuze 21 jun 2026).

	Zwevend bordje dat automatisch verschijnt bij ritual/delve/dungeon-entry.
	Eén rij per groepslid; elke cel is een ECHT item-/spell-icoon (RCC-look) met
	een status-badge (groen vinkje = klaar/actief, amber vinkje = wel op zak maar
	niet gebruikt, rood kruis = ontbreekt, geel = onbekend) + count. De eigen rij
	is klikbaar om consumables te gebruiken (secure knoppen). Sleepbaar, schaalbaar
	(shift+scroll), positie opgeslagen. Verbergt bij de pull.

	Kolommen: consumables (flask/rune/weapon/cpot/hpot/food/hs) + raid/class-buffs
	(alleen die waarvan de gever-class in de groep zit). In een groep ziet alleen
	de leader de hele groep; niet-leaders zien enkel hun eigen rij (gating zit in
	GetConsumableReadyData).

	Data: ns.GetConsumableReadyData() — never-lie, dezelfde bron als de chat-versie.
]]

local _, ns = ...

local READY = "Interface\\RAIDFRAME\\ReadyCheck-Ready"
local NOTREADY = "Interface\\RAIDFRAME\\ReadyCheck-NotReady"
local WAITING = "Interface\\RAIDFRAME\\ReadyCheck-Waiting"
local FALLBACK_ICON = 134400 -- INV_Misc_QuestionMark

local MAX_ROWS = 5
local ROW_H = 26
local HEADER_Y = -40
local ICON = 22
local NAME_X = 12
local CONSUM_X0 = 104
local COL_STEP = 28
local RAIDBUFF_GAP = 16
local MAX_RAIDBUFFS = 6
local AUTO_HIDE_SEC = 25
local MIN_SCALE, MAX_SCALE = 0.7, 1.6

-- Vaste consumable-kolomvolgorde. Index → x.
local CONSUM_ORDER = { "flask", "rune", "weapon", "cpot", "hpot", "food", "hs" }
local function ConsumX(i)
	return CONSUM_X0 + (i - 1) * COL_STEP
end
local RAIDBUFF_X0 = CONSUM_X0 + #CONSUM_ORDER * COL_STEP + RAIDBUFF_GAP
local function RaidX(i)
	return RAIDBUFF_X0 + (i - 1) * COL_STEP
end
-- Raid-buff-x ná de zichtbare consumables (dynamisch: nConsum = aantal getoonde
-- consumable-kolommen). Sluit aaneengesloten aan met een kleine gap ervoor.
local function RaidXDyn(nConsum, i)
	return ConsumX(nConsum + i) + RAIDBUFF_GAP
end

local board

local function GetWinSettings()
	if not (ns.db and ns.db.ui) then
		return {}
	end
	if type(ns.db.ui.consumableBoard) ~= "table" then
		ns.db.ui.consumableBoard = {}
	end
	return ns.db.ui.consumableBoard
end

local function CurScale()
	local s = GetWinSettings()
	local sc = tonumber(s.scale) or 1
	if sc < MIN_SCALE then
		sc = MIN_SCALE
	elseif sc > MAX_SCALE then
		sc = MAX_SCALE
	end
	return sc
end

local function ApplySavedPosition(f)
	local s = GetWinSettings()
	local scale = f:GetScale() or 1
	f:ClearAllPoints()
	if tonumber(s.x) and tonumber(s.y) and UIParent then
		f:SetPoint("CENTER", UIParent, "CENTER", s.x / scale, s.y / scale)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 280 / scale, 120 / scale)
	end
end

local function SavePosition(f)
	local s = GetWinSettings()
	local scale = f:GetScale() or 1
	local cx, cy = f:GetCenter()
	if cx and cy and UIParent then
		s.x = cx * scale - (UIParent:GetWidth() / 2)
		s.y = cy * scale - (UIParent:GetHeight() / 2)
	end
end

-- Spell-icoon (fileID) ophalen, taint-/versie-veilig.
local function SpellIcon(spellID)
	if not spellID then
		return FALLBACK_ICON
	end
	if C_Spell and C_Spell.GetSpellTexture then
		local ok, tex = pcall(C_Spell.GetSpellTexture, spellID)
		if ok and tex then
			return tex
		end
	end
	if GetSpellTexture then
		local ok, tex = pcall(GetSpellTexture, spellID)
		if ok and tex then
			return tex
		end
	end
	return FALLBACK_ICON
end

--------------------------------------------------------------------------------
-- Cel = item-/spell-icoon + status-badge + count. status: true/"best"=groen,
-- "alt"=amber (wel op zak, niet gebruikt), false=rood, nil=onbekend (geel).
--------------------------------------------------------------------------------

local function NewCell(parent, x, y)
	local icon = parent:CreateTexture(nil, "ARTWORK")
	icon:SetSize(ICON, ICON)
	icon:SetPoint("CENTER", parent, "TOPLEFT", x, y)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93) -- iconen netjes bijsnijden
	icon:Hide()
	local badge = parent:CreateTexture(nil, "OVERLAY")
	badge:SetSize(11, 11)
	badge:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -4)
	badge:Hide()
	local count = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	count:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT", -3, -2)
	count:Hide()
	local timer = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	timer:SetPoint("BOTTOM", icon, "TOP", 0, 0)
	timer:SetTextColor(0.7, 0.9, 1)
	timer:Hide()
	return { icon = icon, badge = badge, count = count, timer = timer }
end

local function PlaceCell(cell, x, y)
	cell.icon:ClearAllPoints()
	cell.icon:SetPoint("CENTER", cell.icon:GetParent(), "TOPLEFT", x, y)
end

local function HideCell(cell)
	cell.icon:Hide()
	cell.badge:Hide()
	cell.count:Hide()
	cell.timer:Hide()
	if cell.hit then
		cell.hit:Hide()
	end
end

-- Resterende tijd kort formatteren (h/m/s).
local function FmtRemain(sec)
	if not sec or sec <= 0 then
		return nil
	end
	if sec >= 3600 then
		return math.floor(sec / 3600 + 0.5) .. "h"
	elseif sec >= 60 then
		return math.floor(sec / 60 + 0.5) .. "m"
	end
	return math.floor(sec) .. "s"
end

local function SetCell(cell, iconFile, status, count)
	if not iconFile then
		HideCell(cell)
		return
	end
	cell.icon:SetTexture(iconFile)
	local ready = (status == true or status == "best" or status == "alt")
	cell.icon:SetDesaturated(not ready)
	cell.icon:Show()

	cell.badge:SetVertexColor(1, 1, 1)
	if status == true or status == "best" then
		cell.badge:SetTexture(READY)
	elseif status == "alt" then
		cell.badge:SetTexture(READY)
		cell.badge:SetVertexColor(1, 0.82, 0.35)
	elseif status == false then
		cell.badge:SetTexture(NOTREADY)
	else
		cell.badge:SetTexture(WAITING)
	end
	cell.badge:Show()

	if count and count > 1 then
		cell.count:SetText(count)
		cell.count:Show()
	else
		cell.count:Hide()
	end
end

-- Gecombineerde status uit een {bag=..,buff=..}-entry. flask/rune/weapon/food:
-- buff=groen, wel-op-zak=amber, geen=rood, onbekend=nil. pot/hs (geen buff):
-- op-zak=groen, geen=rood.
local function ComboStatus(e, hasBuff)
	if not e then
		return nil
	end
	if hasBuff then
		if e.buff == true then
			return true
		end
		if e.bag and e.bag ~= false then
			return "alt"
		end
		if e.bag == false then
			return false
		end
		return nil
	end
	if e.bag and e.bag ~= false then
		return true
	end
	if e.bag == false then
		return false
	end
	return nil
end

local function ClassColorName(name, classToken)
	local color = classToken and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classToken]
	if color and color.colorStr then
		return "|c" .. color.colorStr .. (name or "?") .. "|r"
	end
	return name or "?"
end

-- Voegt "Heeft: <namen>" (groen), "Mist: <namen>" (rood) en "Kan ik niet zien:
-- <namen>" (grijs) toe aan de tooltip, class-gekleurd.
-- info = { spellID, has={{name,class}...}, missing={...}, unknown={...} }
--
-- Die derde regel is niet cosmetisch. ConsumableReadyCheck vult al drie bakjes,
-- maar hier werden er maar twee getekend — dus zodra 12.1 andermans auras secret
-- maakt, belandt IEDEREEN in `unknown` en bleef de tooltip volledig leeg. Een lege
-- tooltip leest als "er mist niets", en dat is precies de zelfverzekerde leugen
-- die MH nooit mag vertellen. Nu zegt hij wat hij niet kan zien.
local function AddHolderLines(info)
	if not (info and GameTooltip) then
		return
	end
	if info.has and #info.has > 0 then
		local t = {}
		for _, e in ipairs(info.has) do
			t[#t + 1] = ClassColorName(e.name, e.class)
		end
		GameTooltip:AddLine(ns:L("CONSREADY_HAS") .. " " .. table.concat(t, ", "), 0.4, 1, 0.4, true)
	end
	if info.missing and #info.missing > 0 then
		local t = {}
		for _, e in ipairs(info.missing) do
			t[#t + 1] = ClassColorName(e.name, e.class)
		end
		GameTooltip:AddLine(ns:L("CONSREADY_MISSING") .. " " .. table.concat(t, ", "), 1, 0.45, 0.45, true)
	end
	if info.unknown and #info.unknown > 0 then
		local t = {}
		for _, e in ipairs(info.unknown) do
			t[#t + 1] = ClassColorName(e.name, e.class)
		end
		GameTooltip:AddLine(ns:L("CONSREADY_UNKNOWN") .. " " .. table.concat(t, ", "), 0.62, 0.62, 0.62, true)
		-- Alleen onleesbaar? Zeg dan expliciet dat dit géén "alles in orde" is.
		local anyRead = (info.has and #info.has > 0) or (info.missing and #info.missing > 0)
		if not anyRead then
			GameTooltip:AddLine(ns:L("CONSREADY_UNKNOWN_HINT"), 0.62, 0.62, 0.62, true)
		end
	end
end

local function EnsureBoard()
	if board then
		return board
	end
	local f = CreateFrame("Frame", "MidnightHelperConsumableBoard", UIParent, "BackdropTemplate")
	f:SetSize(300, 120)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function()
		f:StartMoving()
	end)
	f:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		SavePosition(f)
	end)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 24,
			insets = { left = 8, right = 8, top = 8, bottom = 8 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.09, 0.95)
	end
	f:SetScale(CurScale())
	f:Hide()
	ApplySavedPosition(f)

	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(_, delta)
		if not IsShiftKeyDown() then
			return
		end
		local st = GetWinSettings()
		local sc = CurScale() + (delta > 0 and 0.1 or -0.1)
		if sc < MIN_SCALE then
			sc = MIN_SCALE
		elseif sc > MAX_SCALE then
			sc = MAX_SCALE
		end
		st.scale = sc
		SavePosition(f)
		f:SetScale(sc)
		ApplySavedPosition(f)
	end)

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -12)
	title:SetPoint("RIGHT", f, "RIGHT", -28, 0)
	title:SetJustifyH("LEFT")
	title:SetTextColor(1, 0.82, 0.2)
	f._title = title

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
	close:SetScript("OnClick", function()
		f:Hide()
	end)

	-- Rij-widgets: per rij de 7 consumable-cellen (vaste x) + een pool van
	-- raid-buff-cellen (dynamisch gepositioneerd in Render).
	f._rows = {}
	for i = 1, MAX_ROWS do
		local y = HEADER_Y - (i - 1) * ROW_H
		local name = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		name:SetPoint("LEFT", f, "TOPLEFT", NAME_X, y)
		name:SetJustifyH("LEFT")
		name:SetWidth(CONSUM_X0 - NAME_X - 6)
		local row = { name = name, consum = {}, raid = {} }
		for c = 1, #CONSUM_ORDER do
			row.consum[CONSUM_ORDER[c]] = NewCell(f, ConsumX(c), y)
		end
		for r = 1, MAX_RAIDBUFFS do
			local cell = NewCell(f, RaidX(r), y)
			-- Hover-frame voor de "wie heeft 'm"-tooltip (volgt het icoon).
			local hit = CreateFrame("Frame", nil, f)
			hit:SetSize(ICON + 4, ICON + 4)
			hit:SetPoint("CENTER", cell.icon, "CENTER", 0, 0)
			hit:EnableMouse(true)
			hit:Hide()
			hit:SetScript("OnEnter", function(self)
				if not (GameTooltip and self._buffKey and f._raidHolders) then
					return
				end
				local info = f._raidHolders[self._buffKey]
				if not info then
					return
				end
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				pcall(GameTooltip.SetSpellByID, GameTooltip, info.spellID)
				AddHolderLines(info)
				GameTooltip:Show()
			end)
			hit:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end)
			cell.hit = hit
			row.raid[r] = cell
		end
		row._y = y
		f._rows[i] = row
	end

	-- "Klik om te gebruiken" op de EIGEN rij (rij 1). Onzichtbare secure
	-- click-catchers over de consumable-cellen → type=item. Attributen/Show/Hide
	-- alleen buiten combat (UpdateUseButtons).
	f._useBtns = {}
	do
		local y1 = HEADER_Y
		local idx = { flask = 1, rune = 2, weapon = 3, cpot = 4, hpot = 5, food = 6, hs = 7 }
		for cat, i in pairs(idx) do
			local btn = CreateFrame("Button", "MidnightHelperConsumeUse" .. cat, f, "SecureActionButtonTemplate")
			btn:SetSize(ICON + 4, ICON + 4)
			btn:SetPoint("CENTER", f, "TOPLEFT", ConsumX(i), y1)
			btn:RegisterForClicks("AnyUp", "AnyDown")
			btn:EnableMouse(true)
			btn:SetFrameLevel((f:GetFrameLevel() or 1) + 10)
			btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
			btn._cat = cat
			btn:SetScript("OnEnter", function(self)
				if GameTooltip and self._itemID then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					pcall(GameTooltip.SetItemByID, GameTooltip, self._itemID)
					if self._owned then
						GameTooltip:AddLine(ns:L("CONSREADY_USE_HINT"), 0.6, 1, 0.6)
					else
						GameTooltip:AddLine(ns:L("CONSREADY_NOT_IN_BAG"), 1, 0.4, 0.4)
					end
					GameTooltip:Show()
				end
			end)
			btn:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end)
			f._useBtns[cat] = btn
		end
	end

	-- Secure knop voor JOUW class-raid-buff (mage → Arcane Intellect casten).
	-- Eén knop; positie + spell worden in UpdateUseButtons gezet (buiten combat),
	-- want de raid-buff-kolommen zijn dynamisch van plek.
	do
		local btn = CreateFrame("Button", "MidnightHelperRaidBuffCast", f, "SecureActionButtonTemplate")
		btn:SetSize(ICON + 4, ICON + 4)
		btn:SetPoint("CENTER", f, "TOPLEFT", RaidX(1), HEADER_Y)
		btn:RegisterForClicks("AnyUp", "AnyDown")
		btn:EnableMouse(true)
		btn:SetFrameLevel((f:GetFrameLevel() or 1) + 10)
		btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		btn:SetScript("OnEnter", function(self)
			if not (GameTooltip and self._spellID) then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			pcall(GameTooltip.SetSpellByID, GameTooltip, self._spellID)
			GameTooltip:AddLine(ns:L("CONSREADY_CAST_HINT"), 0.6, 1, 0.6)
			if self._buffKey and f._raidHolders then
				AddHolderLines(f._raidHolders[self._buffKey])
			end
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		f._raidBtn = btn
	end

	local hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hint:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 10)
	hint:SetText(ns:L("CONSREADY_BOARD_HINT"))
	hint:SetTextColor(0.55, 0.54, 0.5)
	f._hint = hint

	board = f
	return f
end


-- Configureer de "use"-knoppen van de speler. ALLEEN buiten combat.
local function UpdateUseButtons(f)
	if not (f and f._useBtns) then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	local owned = ns.GetOwnConsumableItemIDs and ns.GetOwnConsumableItemIDs() or {}
	local rec = ns.GetConsumableRecommendedItemIDs and ns.GetConsumableRecommendedItemIDs() or {}
	local slotOf = f._slotOf or {}
	for cat, btn in pairs(f._useBtns) do
		local slot = slotOf[cat]
		if slot then
			btn:ClearAllPoints()
			btn:SetPoint("CENTER", f, "TOPLEFT", ConsumX(slot), HEADER_Y)
			local id = owned[cat]
			if id then
				btn._itemID = id
				btn._owned = true
				btn:SetAttribute("type", "item")
				btn:SetAttribute("item", "item:" .. id)
			else
				btn._itemID = rec[cat] -- aanbevolen item, puur voor de tooltip
				btn._owned = false
				btn:SetAttribute("type", nil)
				btn:SetAttribute("item", nil)
			end
			btn:Show() -- altijd tonen: ook voor de hover-tooltip als je 't niet hebt
		else
			-- categorie niet getoond (bv. healthstone zonder Warlock) → knop weg
			btn._itemID = nil
			btn:SetAttribute("type", nil)
			btn:SetAttribute("item", nil)
			btn:Hide()
		end
	end

	-- Eigen class-raid-buff klikbaar maken (casten). Gebruik de OPGESLAGEN cel-x
	-- (f._raidX) zodat de knop exact op de Skyfury/Arcane-cel valt.
	local rb = f._raidBtn
	if rb then
		local pClass = select(2, UnitClass("player"))
		local defs = f._raidDefs or {}
		local def
		for i = 1, #defs do
			if defs[i].class == pClass then
				def = defs[i]
				break
			end
		end
		local x = def and f._raidX and f._raidX[def.key]
		local spellName
		if def then
			if C_Spell and C_Spell.GetSpellName then
				spellName = C_Spell.GetSpellName(def.spellID)
			elseif GetSpellInfo then
				spellName = GetSpellInfo(def.spellID)
			end
		end
		if def and x and spellName then
			rb:ClearAllPoints()
			rb:SetPoint("CENTER", f, "TOPLEFT", x, HEADER_Y)
			rb._spellID = def.spellID
			rb._buffKey = def.key
			rb:SetAttribute("type", "spell")
			rb:SetAttribute("spell", spellName)
			rb:Show()
		else
			rb._spellID = nil
			rb._buffKey = nil
			rb:SetAttribute("type", nil)
			rb:SetAttribute("spell", nil)
			rb:Hide()
		end
	end
end

local function Render()
	local f = EnsureBoard()
	local data = ns.GetConsumableReadyData and ns.GetConsumableReadyData() or { rows = {} }
	local icons = ns.GetConsumableColumnIcons and ns.GetConsumableColumnIcons() or {}
	local raidDefs = data.raidBuffs or {}
	local nRaid = math.min(#raidDefs, MAX_RAIDBUFFS)

	if f._title then
		local d = data.dungeon
		f._title:SetText(
			(d and d ~= "") and ns:L("CONSREADY_HEADER_FMT"):format(d) or ns:L("CONSREADY_HEADER")
		)
	end

	-- "Buff-relevante" categorieën (tonen amber als wel-op-zak maar niet gebruikt).
	local hasBuffCat = { flask = true, rune = true, weapon = true, food = true }

	-- Dynamische kolommen: getoonde consumables uit data.consumColumns (aaneen-
	-- gesloten, geen gaten); raid-buffs daarna. Opgeslagen op f voor UpdateUseButtons.
	local consumCols = data.consumColumns or CONSUM_ORDER
	local slotOf = {}
	for s, cat in ipairs(consumCols) do
		slotOf[cat] = s
	end
	local nConsum = #consumCols
	f._slotOf = slotOf
	f._nConsum = nConsum
	f._raidDefs = raidDefs
	-- Exacte cel-x per raid-buff (zodat de cast-knop precies op de cel valt).
	f._raidX = {}
	for r = 1, nRaid do
		if raidDefs[r] then
			f._raidX[raidDefs[r].key] = RaidXDyn(nConsum, r)
		end
	end
	-- Wie heeft elke raid-buff (volledige groep) — voor de hover-tooltip.
	f._raidHolders = ns.GetRaidBuffHolders and ns.GetRaidBuffHolders() or {}

	local used = 0
	for i = 1, MAX_ROWS do
		local row = f._rows[i]
		local entry = data.rows[i]
		if entry then
			used = used + 1
			row.name:SetText(ClassColorName(entry.name, entry.classToken))
			row.name:Show()

			for _, cat in ipairs(CONSUM_ORDER) do
				local cell = row.consum[cat]
				local slot = slotOf[cat]
				local e = entry[cat]
				if slot and (cat ~= "weapon" or e) then
					PlaceCell(cell, ConsumX(slot), row._y)
					SetCell(cell, icons[cat], ComboStatus(e, hasBuffCat[cat]), e and e.count)
				else
					HideCell(cell)
				end
			end

			-- Raid-buffs (dynamisch): alleen de actieve defs, ná de consumables.
			for r = 1, MAX_RAIDBUFFS do
				local cell = row.raid[r]
				local def = raidDefs[r]
				if def and r <= nRaid then
					PlaceCell(cell, RaidXDyn(nConsum, r), row._y)
					-- `has` is DRIE standen: true / false / nil (= niet te lezen).
					-- Het stond hier als `has and true or false`, waardoor nil naar
					-- false werd geplet en een onleesbare speler een rood "mist"-kruis
					-- kreeg. SetCell kent de derde stand allang (nil → WAITING-badge),
					-- dus geef 'm gewoon door. Zonder dit beschuldigt MH vanaf 12.1 de
					-- halve groep van buffs die het simpelweg niet kán zien.
					local has = entry.raidbuffs and entry.raidbuffs[def.key]
					SetCell(cell, SpellIcon(def.spellID), has, nil)
					if cell.hit then
						cell.hit._buffKey = def.key
						cell.hit:Show()
					end
				else
					HideCell(cell)
				end
			end
		else
			row.name:Hide()
			for _, cell in pairs(row.consum) do
				HideCell(cell)
			end
			for _, cell in pairs(row.raid) do
				HideCell(cell)
			end
		end
	end

	-- Buff-timers boven de cellen — alleen de eigen rij (rij 1 = speler; daar is
	-- ruimte erboven). expirationTime kan secret zijn → GetPlayerBuffRemaining guardt.
	do
		local pr = f._rows[1]
		if pr and data.rows[1] then
			local rem = ns.GetPlayerBuffRemaining and ns.GetPlayerBuffRemaining() or {}
			local function setT(cell, sec)
				if not (cell and cell.timer) then
					return
				end
				local s = FmtRemain(sec)
				if s and cell.icon:IsShown() then
					cell.timer:SetText(s)
					cell.timer:Show()
				else
					cell.timer:Hide()
				end
			end
			setT(pr.consum.flask, rem.flask)
			setT(pr.consum.rune, rem.rune)
			setT(pr.consum.weapon, rem.weapon)
			setT(pr.consum.food, rem.food)
			pr.consum.cpot.timer:Hide()
			pr.consum.hpot.timer:Hide()
			pr.consum.hs.timer:Hide()
			for r = 1, MAX_RAIDBUFFS do
				local def = raidDefs[r]
				setT(pr.raid[r], def and rem["rb_" .. def.key])
			end
		end
	end

	-- Dynamische breedte: tot de laatste zichtbare kolom.
	local rightX = (nRaid > 0) and RaidXDyn(nConsum, nRaid) or ConsumX(nConsum)
	local w = rightX + ICON + 16
	f:SetWidth(math.max(w, 220))

	local h = (-HEADER_Y) + math.max(1, used) * ROW_H + 24
	f:SetHeight(h)

	UpdateUseButtons(f)
end

local hideTimer

function ns.ShowConsumableBoard()
	local f = EnsureBoard()
	Render()
	f:Show()
	if hideTimer and hideTimer.Cancel then
		pcall(hideTimer.Cancel, hideTimer)
	end
	if C_Timer and C_Timer.NewTimer then
		hideTimer = C_Timer.NewTimer(AUTO_HIDE_SEC, function()
			ns.HideConsumableBoard() -- combat-veilig
		end)
	end
end

function ns.HideConsumableBoard()
	if not board then
		return
	end
	-- Het bord heeft secure knoppen als kinderen → protected → in combat geen
	-- Hide (ADDON_ACTION_BLOCKED). Daarom uitstellen tot PLAYER_REGEN_ENABLED.
	if InCombatLockdown and InCombatLockdown() then
		board._pendingHide = true
		return
	end
	board._pendingHide = nil
	board:Hide()
end

function ns.RefreshConsumableBoard()
	if board and board:IsShown() then
		Render()
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("ENCOUNTER_START")
ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("UNIT_AURA")
ev:SetScript("OnEvent", function(_, event)
	if event == "ENCOUNTER_START" or event == "PLAYER_REGEN_DISABLED" then
		ns.HideConsumableBoard()
	elseif event == "PLAYER_REGEN_ENABLED" then
		if board and board._pendingHide then
			ns.HideConsumableBoard()
		end
	elseif event == "UNIT_AURA" then
		ns.RefreshConsumableBoard()
	end
end)
