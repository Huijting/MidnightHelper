local addonName, ns = ...

local ROW_BASE = 34
local ROW_NOTE_EXTRA = 14
local ROW_ALT_EXTRA = 18
local ICON_SIZE = 20
local TYPE_COL_W = 112
local ICON_PAD = 4

local CATEGORIES = {
	{ key = "flask", labelKey = "GUIDE_CONS_TYPE_FLASK" },
	{ key = "combatPotion", labelKey = "GUIDE_CONS_TYPE_COMBAT" },
	{ key = "healingPotion", labelKey = "GUIDE_CONS_TYPE_HEALING" },
	{ key = "weaponOil", labelKey = "GUIDE_CONS_TYPE_WEAPON" },
	{ key = "augmentRune", labelKey = "GUIDE_CONS_TYPE_RUNE" },
	{ key = "feast", labelKey = "GUIDE_CONS_TYPE_FEAST" },
	{ key = "personalFood", labelKey = "GUIDE_CONS_TYPE_FOOD" },
}

local QUALITY_RGB = {
	[0] = { 0.62, 0.62, 0.62 },
	[1] = { 1.0, 1.0, 1.0 },
	[2] = { 0.12, 1.0, 0.0 },
	[3] = { 0.0, 0.44, 0.87 },
	[4] = { 0.64, 0.21, 0.93 },
	[5] = { 1.0, 0.5, 0.0 },
}


function ns.MH_GetConsumablesWowheadForSpec(classToken, specIndex)
	if not classToken or not specIndex or specIndex < 1 then
		return nil
	end
	local t = ns.ConsumablesWowheadByClassSpec and ns.ConsumablesWowheadByClassSpec[string.upper(classToken)]
	return t and t[specIndex]
end

local function ItemDisplayName(itemID)
	if not itemID then
		return ""
	end
	if C_Item and C_Item.GetItemInfo then
		local n = C_Item.GetItemInfo(itemID)
		if n and n ~= "" then
			return n
		end
	end
	if GetItemInfo then
		local n = GetItemInfo(itemID)
		if n and n ~= "" then
			return n
		end
	end
	return "Item " .. tostring(itemID)
end

local function ItemQualityRGB(itemID)
	local quality
	if C_Item and C_Item.GetItemQualityByID then
		quality = C_Item.GetItemQualityByID(itemID)
	end
	if quality == nil and GetItemInfo then
		_, _, quality = GetItemInfo(itemID)
	end
	if quality ~= nil and QUALITY_RGB[quality] then
		local c = QUALITY_RGB[quality]
		return c[1], c[2], c[3]
	end
	if GetItemQualityColor and quality ~= nil then
		local c = GetItemQualityColor(quality)
		if type(c) == "table" and c.GetRGB then
			return c:GetRGB()
		end
		if type(c) == "table" and c.r then
			return c.r, c.g, c.b
		end
	end
	return 0.92, 0.90, 0.82
end

local function ItemIcon(itemID)
	if not itemID then
		return 134400
	end
	if C_Item and C_Item.GetItemIconByID then
		local tex = C_Item.GetItemIconByID(itemID)
		if tex then
			return tex
		end
	end
	if GetItemIcon then
		local tex = GetItemIcon(itemID)
		if tex then
			return tex
		end
	end
	return 134400
end

local function ShowConsumableItemTooltip(owner, itemID, noteText)
	if not owner or not itemID then
		return
	end
	local gt = _G.GameTooltip
	if not gt or not gt.SetOwner then
		return
	end
	gt:SetOwner(owner, "ANCHOR_RIGHT")
	gt:ClearLines()
	local ok = pcall(function()
		if gt.SetItemByID then
			gt:SetItemByID(itemID)
		elseif gt.SetHyperlink then
			gt:SetHyperlink("item:" .. tostring(itemID))
		end
	end)
	if ok and noteText and noteText ~= "" and gt.AddLine then
		gt:AddLine(" ")
		gt:AddLine(noteText, 0.75, 0.82, 0.9, true)
	end
	if ok then
		gt:Show()
	end
end

local function FormatPlainNameList(ids)
	if not ids or #ids < 1 then
		return ""
	end
	local parts = {}
	for i = 1, #ids do
		parts[#parts + 1] = ItemDisplayName(ids[i])
	end
	return table.concat(parts, " / ")
end

local function CategoryNote(cat)
	if not cat then
		return ""
	end
	if cat.noteKey and cat.noteKey ~= "" then
		local s = ns:L(cat.noteKey)
		if s and s ~= cat.noteKey then
			return s
		end
	end
	return cat.noteEn or cat.noteNl or ""
end

local function ClearFrameChildren(frame)
	if not frame or not frame.GetChildren then
		return
	end
	local children = { frame:GetChildren() }
	for i = 1, #children do
		local c = children[i]
		if c and c.Hide then
			c:Hide()
			c:SetParent(nil)
		end
	end
end

--- Rebuild consumables list inside host (Macros tab scroll child).
function ns.MH_BuildConsumablesIntoHost(host, classToken, specIdx, fullW)
	if not host then
		return 0
	end
	ClearFrameChildren(host)
	host._mhItemRows = {}

	local specData = ns.MH_GetConsumablesWowheadForSpec(classToken, specIdx)
	local textW = math.max(200, (fullW or 400) - TYPE_COL_W - ICON_SIZE - 24)
	host:SetWidth(textW + TYPE_COL_W + ICON_SIZE + 16)

	if not specData then
		local empty = host:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		empty:SetPoint("TOPLEFT", host, "TOPLEFT", 8, -4)
		empty:SetWidth(textW + TYPE_COL_W)
		empty:SetJustifyH("LEFT")
		empty:SetTextColor(0.75, 0.72, 0.65)
		empty:SetText(ns:L("MACROS_CONS_NO_DATA"))
		host:SetHeight(32)
		return 32
	end

	local contentY = -4
	local totalH = 8

	local function addRow(label, bestIds, altIds, note)
		local rowH = ROW_BASE
		if altIds and #altIds > 0 then
			rowH = rowH + ROW_ALT_EXTRA
		end
		if note and note ~= "" then
			rowH = rowH + ROW_NOTE_EXTRA
		end

		local row = CreateFrame("Frame", nil, host)
		row:SetSize(textW + TYPE_COL_W + ICON_SIZE + 8, rowH)
		row:SetPoint("TOPLEFT", host, "TOPLEFT", 4, contentY)

		local typeFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		typeFs:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -4)
		typeFs:SetWidth(TYPE_COL_W)
		typeFs:SetJustifyH("LEFT")
		typeFs:SetTextColor(1, 0.88, 0.45)
		typeFs:SetText(label)

		local primaryId = bestIds and bestIds[1]
		local icon = row:CreateTexture(nil, "ARTWORK")
		icon:SetSize(ICON_SIZE, ICON_SIZE)
		icon:SetPoint("TOPLEFT", typeFs, "TOPRIGHT", ICON_PAD, 2)
		if primaryId then
			icon:SetTexture(ItemIcon(primaryId))
		end

		local bestFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		bestFs:SetPoint("TOPLEFT", icon, "TOPRIGHT", ICON_PAD, -2)
		bestFs:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, 0)
		bestFs:SetJustifyH("LEFT")
		bestFs:SetWordWrap(true)
		if primaryId then
			local r, g, b = ItemQualityRGB(primaryId)
			bestFs:SetTextColor(r, g, b)
			bestFs:SetText(ItemDisplayName(primaryId))
			host._mhItemRows[#host._mhItemRows + 1] = { id = primaryId, fs = bestFs, icon = icon }
		else
			bestFs:SetTextColor(0.9, 0.88, 0.82)
			bestFs:SetText("")
		end

		local anchor = bestFs
		if altIds and #altIds > 0 then
			local altFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			altFs:SetPoint("TOPLEFT", bestFs, "BOTTOMLEFT", 0, -2)
			altFs:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, 0)
			altFs:SetJustifyH("LEFT")
			altFs:SetWordWrap(true)
			altFs:SetTextColor(0.82, 0.80, 0.74)
			altFs:SetText(ns:L("GUIDE_CONS_ALSO_FMT"):format(FormatPlainNameList(altIds)))
			anchor = altFs
			for i = 1, #altIds do
				host._mhItemRows[#host._mhItemRows + 1] = { id = altIds[i], fs = altFs }
			end
		end

		if note and note ~= "" then
			local noteFs = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
			noteFs:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -2)
			noteFs:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, 0)
			noteFs:SetJustifyH("LEFT")
			noteFs:SetWordWrap(true)
			noteFs:SetTextColor(0.65, 0.63, 0.58)
			noteFs:SetText(note)
		end

		local hit = CreateFrame("Button", nil, row)
		hit:SetPoint("TOPLEFT", row, "TOPLEFT", TYPE_COL_W, 0)
		hit:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 0)
		hit:SetScript("OnEnter", function(self)
			if primaryId then
				ShowConsumableItemTooltip(self, primaryId, note)
			end
		end)
		hit:SetScript("OnLeave", function()
			if _G.GameTooltip then
				_G.GameTooltip:Hide()
			end
		end)

		contentY = contentY - rowH - 4
		totalH = totalH + rowH + 4
		return rowH
	end

	for i = 1, #CATEGORIES do
		local def = CATEGORIES[i]
		if def.key ~= "weaponOil" or not specData.omitWeaponOil then
			local cat = specData[def.key]
			if cat and cat.best and #cat.best > 0 then
				addRow(ns:L(def.labelKey), cat.best, cat.alternates, CategoryNote(cat))
			end
		end
	end

	host:SetHeight(math.max(48, totalH + 8))
	return host:GetHeight()
end

function ns.MH_EnsureConsumablesItemListener(host)
	if not host or host._mhConsItemListener then
		return
	end
	host._mhConsItemListener = true
	host:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	host:SetScript("OnEvent", function(_, _itemID, success)
		if not success or not host._mhItemRows then
			return
		end
		for i = 1, #host._mhItemRows do
			local row = host._mhItemRows[i]
			if row.id then
				if row.fs then
					local r, g, b = ItemQualityRGB(row.id)
					row.fs:SetTextColor(r, g, b)
					row.fs:SetText(ItemDisplayName(row.id))
				end
				if row.icon and row.icon.SetTexture then
					row.icon:SetTexture(ItemIcon(row.id))
				end
			end
		end
	end)
end
