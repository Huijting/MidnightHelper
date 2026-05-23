--[[
	MidnightHelper — Universal leveling guide (data-driven).
	Data: Addons/GuideData.lua · Tab-label: UI.lua ("Leveling Guides").
]]

local addonName, ns = ...

local TIP_ICON_SIZE = 24
local TIP_ROW_HEIGHT = 32
local TIP_ROW_GAP = 8
local CONS_ROW_HEIGHT = 24
local CONS_ROW_GAP = 2
local ADVISOR_BOX_HEIGHT = 240
local ADVISOR_TAB_H = 22
local ADVISOR_TAB_GAP = 6
local SPEC_HEADER_ICON_SIZE = 32
local CONS_COPY_BTN = 18
local consNameCopyFrame
-- Forward declarations used by early helper functions (before UI refs block below).
local currentLink = ""
local lastGuideCenterFs

local DEFAULT_THEME = {
	tint = { 0.06, 0.06, 0.08, 0.92 },
	topBar = { 0.15, 0.15, 0.18, 0.95 },
	titleColor = { 0.85, 0.88, 0.92 },
	sectionBar = { 0.22, 0.22, 0.26, 0.9 },
	sectionText = { 0.9, 0.88, 0.82 },
	icyBackdrop = { 0.08, 0.08, 0.10, 0.85 },
	icyBorder = { 0.4, 0.4, 0.45, 0.9 },
	icyTitleColor = { 0.85, 0.9, 1.0 },
	ebBg = { 0.1, 0.1, 0.12, 0.95 },
}

local function SpellIconFile(spellID)
	if not spellID then
		return nil
	end
	local ok, icon = pcall(function()
		if C_Spell and C_Spell.GetSpellInfo then
			local si = C_Spell.GetSpellInfo(spellID)
			if si and si.iconID then
				return si.iconID
			end
		end
		return nil
	end)
	if ok and icon then
		return icon
	end
	return 134400
end

local function ShowSpellTooltipForIcon(owner, spellID)
	if not owner or not spellID then
		return
	end
	local gt = _G.GameTooltip
	if not gt or not gt.SetOwner then
		return
	end
	gt:SetOwner(owner, "ANCHOR_RIGHT", 4, 0)
	gt:ClearLines()
	local ok, err = pcall(function()
		if gt.SetSpellByID then
			gt:SetSpellByID(spellID)
		elseif gt.SetHyperlink then
			gt:SetHyperlink("spell:" .. tostring(spellID))
		end
	end)
	if ok then
		gt:Show()
	elseif ns.db and ns.db.ui and ns.db.ui.debug then
		print("|cffffcc00Midnight Helper:|r Guide spell-tooltip:", err)
	end
end

local function ShowGuideStatsGlossaryTooltip(owner)
	local gt = _G.GameTooltip
	if not owner or not gt or not gt.SetOwner then
		return
	end
	gt:SetOwner(owner, "ANCHOR_RIGHT", 4, 0)
	gt:ClearLines()
	gt:AddLine(ns:L("GUIDE_STATS_GLOSSARY_TITLE"), 1, 0.82, 0, true)
	gt:AddLine(" ")
	gt:AddDoubleLine(ns:L("GUIDE_STAT_AGILITY"), ns:L("GUIDE_STAT_AGILITY_DESC"), 1, 1, 1, 0.85, 0.85, 0.85)
	gt:AddDoubleLine(ns:L("GUIDE_STAT_STRENGTH"), ns:L("GUIDE_STAT_STRENGTH_DESC"), 1, 1, 1, 0.85, 0.85, 0.85)
	gt:AddDoubleLine(ns:L("GUIDE_STAT_INTELLECT"), ns:L("GUIDE_STAT_INTELLECT_DESC"), 1, 1, 1, 0.85, 0.85, 0.85)
	gt:AddDoubleLine(ns:L("GUIDE_STAT_HASTE"), ns:L("GUIDE_STAT_HASTE_DESC"), 1, 1, 1, 0.85, 0.85, 0.85)
	gt:AddDoubleLine(ns:L("GUIDE_STAT_MASTERY"), ns:L("GUIDE_STAT_MASTERY_DESC"), 1, 1, 1, 0.85, 0.85, 0.85)
	gt:AddDoubleLine(ns:L("GUIDE_STAT_VERSATILITY"), ns:L("GUIDE_STAT_VERSATILITY_DESC"), 1, 1, 1, 0.85, 0.85, 0.85)
	gt:AddDoubleLine(ns:L("GUIDE_STAT_CRIT"), ns:L("GUIDE_STAT_CRIT_DESC"), 1, 1, 1, 0.85, 0.85, 0.85)
	gt:AddLine(" ")
	gt:AddLine(ns:L("GUIDE_STATS_GLOSSARY_HINT"), 0.7, 0.7, 0.7, true)
	gt:Show()
end

--- Resolve display name from item ID (cache may load async; GET_ITEM_INFO_RECEIVED updates rows).
local function GetConsumableItemDisplayName(itemID)
	if not itemID then
		return ""
	end
	if C_Item and C_Item.GetItemNameByID then
		local n = C_Item.GetItemNameByID(itemID)
		if n and n ~= "" then
			return n
		end
	end
	if C_Item and C_Item.GetItemInfo then
		local info = C_Item.GetItemInfo(itemID)
		if type(info) == "table" and info.itemName and info.itemName ~= "" then
			return info.itemName
		end
	end
	if GetItemInfo then
		local n = select(1, GetItemInfo(itemID))
		if n and n ~= "" then
			return n
		end
	end
	return "Item " .. tostring(itemID)
end

--- Minimum character level to use the item (itemMinLevel). NOT item level / ilvl — see C_Item.GetItemInfo.
--- Returns nil when item info is still unknown/unavailable (cache not ready yet).
local function GetConsumableRequiredLevel(itemID)
	if not itemID then
		return nil
	end
	if C_Item and C_Item.GetItemInfo then
		local a, b, c, d, itemMinLevel = C_Item.GetItemInfo(itemID)
		if type(a) == "table" then
			local m = a.itemMinLevel or a.minLevel
			if type(m) == "number" then
				return m
			end
		elseif type(itemMinLevel) == "number" then
			return itemMinLevel
		end
	end
	if GetItemInfo then
		local reqLevel = select(5, GetItemInfo(itemID))
		if type(reqLevel) == "number" then
			return reqLevel
		end
	end
	return nil
end

local function IsConsumableUsableNow(itemID)
	if not itemID then
		return false
	end
	local reqLevel = GetConsumableRequiredLevel(itemID)
	if reqLevel == nil then
		-- Unknown item requirements should never be treated as "usable now".
		return false
	end
	local curLevel = UnitLevel and (UnitLevel("player") or 0) or 0
	-- Guide intent: "can your character use this by level?" Do not use C_Item.IsUsableItem — it often returns
	-- false when the item is not in bags, which wrongly marks recommendations as locked.
	if reqLevel <= 0 then
		return true
	end
	return reqLevel <= curLevel
end

--- Pick first candidate usable at current level (GuideData order = priority). If none yet, pick locked item with lowest required level.
local function ResolveBestConsumableForLevel(candidates)
	if type(candidates) ~= "table" or #candidates == 0 then
		return nil, false, 0
	end
	local curLevel = UnitLevel and (UnitLevel("player") or 0) or 0
	for i = 1, #candidates do
		local id = tonumber(candidates[i])
		if id and id > 0 then
			local req = GetConsumableRequiredLevel(id)
			if req ~= nil and IsConsumableUsableNow(id) and (req <= curLevel or req <= 0) then
				return id, true, req
			end
		end
	end
	local bestLocked, bestLockedReq
	for i = 1, #candidates do
		local id = tonumber(candidates[i])
		if id and id > 0 then
			local req = GetConsumableRequiredLevel(id)
			if req and req > curLevel then
				if (not bestLocked) or req < bestLockedReq then
					bestLocked, bestLockedReq = id, req
				end
			end
		end
	end
	if bestLocked then
		return bestLocked, false, bestLockedReq or 0
	end
	return nil, false, 0
end

--- Extra lines after SetItemByID: use English WoW terms (Flask, Feast, stat names, etc.).
local function AppendConsumableGuideExtraLines(gt, itemID)
	if not gt or not gt.AddLine or not itemID then
		return
	end
	local id = itemID
	if id == 255845 then
		gt:AddLine("Feast for the whole group (Silvermoon Parade).", 0.85, 0.85, 0.55, true)
		return
	end
	if id == 259085 then
		gt:AddLine("+Primary stat. Stacks with Flask and Food.", 0.72, 0.88, 1.0, true)
		return
	end
	if id == 241327 then
		gt:AddLine("Increases Critical Strike for 1 hour. Persists through death.", 0.75, 0.9, 0.75, true)
		return
	end
	if id == 241324 then
		gt:AddLine("Increases Agility for 1 hour. Persists through death.", 0.75, 0.9, 0.75, true)
		return
	end
	if id == 241326 then
		gt:AddLine("Increases Strength for 1 hour. Persists through death.", 0.75, 0.9, 0.75, true)
		return
	end
	if id == 241308 then
		gt:AddLine("Burst primary stat for ~30 sec (use during cooldowns / opener).", 0.9, 0.78, 0.58, true)
		return
	end
	if id == 241289 then
		gt:AddLine("Large stat boost during burst (e.g. Bloodlust / opener).", 0.9, 0.75, 0.55, true)
		return
	end
	if id == 191371 or id == 191369 then
		gt:AddLine("Major heal and temporary HP boost when in danger.", 0.85, 0.65, 0.55, true)
	end
	if id == 243734 or id == 243733 then
		gt:AddLine("Temporary weapon coating — secondary stats while active.", 0.82, 0.88, 0.72, true)
	end
	if id == 211878 or id == 211880 then
		gt:AddLine("Emergency heal — keep a stack in your bags while leveling and in keys.", 0.75, 0.95, 0.78, true)
	end
end

local function ShowItemTooltipForConsumable(owner, itemID)
	if not owner or not itemID then
		return
	end
	local gt = _G.GameTooltip
	if not gt or not gt.SetOwner then
		return
	end
	gt:SetOwner(owner, "ANCHOR_RIGHT")
	gt:ClearLines()
	local ok, err = pcall(function()
		if gt.SetItemByID then
			gt:SetItemByID(itemID)
		elseif gt.SetHyperlink then
			gt:SetHyperlink("item:" .. tostring(itemID))
		end
	end)
	if ok then
		AppendConsumableGuideExtraLines(gt, itemID)
		gt:Show()
	elseif ns.db and ns.db.ui and ns.db.ui.debug then
		print("|cffffcc00Midnight Helper:|r Guide item-tooltip:", err)
	end
end

local function EnsureConsNameCopyFrame()
	if consNameCopyFrame then
		return consNameCopyFrame
	end
	local f = CreateFrame("Frame", "MidnightHelperConsNameCopy", UIParent, "BackdropTemplate")
	f:SetSize(400, 100)
	f:SetFrameStrata("DIALOG")
	f:SetFrameLevel(2000)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		})
		f:SetBackdropColor(0.08, 0.08, 0.10, 0.98)
		f:SetBackdropBorderColor(0.4, 0.42, 0.5, 0.95)
	end
	local inst = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	inst:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -12)
	inst:SetPoint("TOPRIGHT", f, "TOPRIGHT", -12, -12)
	inst:SetJustifyH("LEFT")
	inst:SetTextColor(0.9, 0.88, 0.8)
	inst:SetText("Press Ctrl+C to copy the name for the Auction House.")
	local eb = CreateFrame("EditBox", nil, f)
	eb:SetAutoFocus(false)
	eb:SetMultiLine(false)
	eb:SetMaxLetters(256)
	eb:SetFontObject("GameFontHighlight")
	eb:SetTextInsets(8, 8, 6, 6)
	eb:SetHeight(30)
	eb:SetPoint("TOPLEFT", inst, "BOTTOMLEFT", 0, -10)
	eb:SetPoint("RIGHT", f, "RIGHT", -12, 0)
	local ebBg = eb:CreateTexture(nil, "BACKGROUND")
	ebBg:SetAllPoints()
	ebBg:SetColorTexture(0.1, 0.1, 0.14, 0.95)
	eb:SetTextColor(0.92, 0.9, 0.85)
	eb:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
		f:Hide()
	end)
	eb:SetScript("OnEditFocusGained", function(self)
		self:HighlightText(0, -1)
	end)
	eb:SetScript("OnMouseUp", function(self)
		if not self:HasFocus() then
			self:SetFocus()
		end
		self:HighlightText(0, -1)
	end)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
	close:SetScript("OnClick", function()
		eb:ClearFocus()
		f:Hide()
	end)
	f._edit = eb
	f:Hide()
	consNameCopyFrame = f
	return f
end

--- Temporary EditBox popup for copy-paste of item name (no OS clipboard API in WoW).
local function ShowConsumableNameCopyPopup(anchor, itemName, theme)
	if not itemName or itemName == "" then
		return
	end
	local f = EnsureConsNameCopyFrame()
	f:SetParent(UIParent)
	local th = theme or DEFAULT_THEME
	if f.SetBackdropBorderColor and th and th.titleColor then
		local c = th.titleColor
		f:SetBackdropBorderColor(c[1], c[2], c[3], 0.95)
	end
	f:ClearAllPoints()
	if anchor then
		f:SetPoint("TOP", anchor, "BOTTOM", 0, -6)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
	end
	f:Show()
	f:Raise()
	local eb = f._edit
	eb:SetText(itemName)
	eb:SetAutoFocus(true)
	eb:SetFocus()
	eb:HighlightText(0, -1)
	if C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			if eb and f:IsShown() then
				eb:SetFocus()
				eb:HighlightText(0, -1)
			end
		end)
	end
end

-- Remove every direct child of the scroll content so refresh never stacks overlapping regions.
local function DestroyAllChildren(parent)
	if not parent or not parent.GetChildren then
		return
	end
	for _ = 1, 64 do
		local children = { parent:GetChildren() }
		if #children == 0 then
			break
		end
		for i = 1, #children do
			local c = children[i]
			if c then
				c:Hide()
				c:SetParent(nil)
			end
		end
	end
end

-- FontStrings created on scrollContent are regions, not child frames — clear them too.
local function DestroyAllRegions(parent)
	if not parent or not parent.GetRegions then
		return
	end
	for _ = 1, 128 do
		local regions = { parent:GetRegions() }
		if #regions == 0 then
			break
		end
		for i = 1, #regions do
			local r = regions[i]
			if r and r.SetParent then
				r:Hide()
				r:SetParent(nil)
			end
		end
	end
end

-- Centered onboarding / placeholder copy inside scrollContent (tips/links hidden).
local function PlaceCenteredGuideMessage(parent, fullW, markup)
	if lastGuideCenterFs and lastGuideCenterFs.SetParent then
		lastGuideCenterFs:Hide()
		lastGuideCenterFs:SetParent(nil)
		lastGuideCenterFs = nil
	end
	local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	fs:SetWidth(math.max(160, fullW - 40))
	fs:SetPoint("CENTER", parent, "CENTER", 0, 0)
	fs:SetJustifyH("CENTER")
	if fs.SetJustifyV then
		fs:SetJustifyV("MIDDLE")
	end
	fs:SetWordWrap(true)
	fs:SetTextColor(0.88, 0.86, 0.78)
	fs:SetText(markup)
	lastGuideCenterFs = fs
	local textH = fs:GetStringHeight() or 100
	parent:SetHeight(math.max(160, textH + 56))
	currentLink = ""
end

local function ApplyTheme(theme, tintTex, topBarTex, titleFs)
	local t = theme or DEFAULT_THEME
	local function c4(k)
		local v = t[k] or DEFAULT_THEME[k]
		return v[1], v[2], v[3], v[4]
	end
	if tintTex and tintTex.SetColorTexture then
		tintTex:SetColorTexture(c4("tint"))
	end
	if topBarTex and topBarTex.SetColorTexture then
		topBarTex:SetColorTexture(c4("topBar"))
	end
	if titleFs and titleFs.SetTextColor then
		local tc = t.titleColor or DEFAULT_THEME.titleColor
		titleFs:SetTextColor(tc[1], tc[2], tc[3])
	end
end

--------------------------------------------------------------------------------
-- UI refs (built once)
--------------------------------------------------------------------------------
local guideRoot
local guideTopBar
local specHeaderIcon
local tintTex
local topBarTex
local titleFs
local scroll
local guideScrollBar
local guideScrollUpBtn
local guideScrollDownBtn
local guideContentBorder
local guideThemeGlowOuter
local scrollContent
local syncingGuideScrollBar

local function SyncGuideScrollBarState()
	if not scroll or not guideScrollBar then
		return
	end
	local maxScroll = scroll:GetVerticalScrollRange() or 0
	local curScroll = scroll:GetVerticalScroll() or 0
	if curScroll < 0 then
		curScroll = 0
	elseif curScroll > maxScroll then
		curScroll = maxScroll
	end

	guideScrollBar:SetMinMaxValues(0, maxScroll)
	syncingGuideScrollBar = true
	guideScrollBar:SetValue(curScroll)
	syncingGuideScrollBar = false

	if maxScroll <= 0 then
		guideScrollBar:Disable()
		guideScrollBar:SetAlpha(0.45)
	else
		guideScrollBar:Enable()
		guideScrollBar:SetAlpha(1)
	end

	if guideScrollUpBtn then
		local canUp = maxScroll > 0 and curScroll > 0
		guideScrollUpBtn:SetEnabled(canUp)
		guideScrollUpBtn:SetAlpha(canUp and 1 or 0.45)
	end
	if guideScrollDownBtn then
		local canDown = maxScroll > 0 and curScroll < maxScroll
		guideScrollDownBtn:SetEnabled(canDown)
		guideScrollDownBtn:SetAlpha(canDown and 1 or 0.45)
	end
end

-- Dutch role labels for onboarding (Midnight 12.0.5 — align with in-game spec UI: Tank / Melee DPS / Ranged DPS / Healer / Support).
local function SpecOnboardingRoleNL(classToken, specIdx)
	local roles = {
		DRUID = { [1] = "Ranged DPS", [2] = "Melee DPS", [3] = "Tank", [4] = "Healer" },
		DEATHKNIGHT = { [1] = "Tank", [2] = "Melee DPS", [3] = "Melee DPS" },
		DEMONHUNTER = { [1] = "Melee DPS", [2] = "Tank", [3] = "Ranged DPS" },
		EVOKER = { [1] = "Ranged DPS", [2] = "Healer", [3] = "Support" },
		HUNTER = { [1] = "Ranged DPS", [2] = "Ranged DPS", [3] = "Melee DPS" },
		-- Mage: all three specs are Ranged DPS; UI adds parentheses around the role text — store without "()" here.
		MAGE = { [1] = "Ranged DPS", [2] = "Ranged DPS", [3] = "Ranged DPS" },
		MONK = { [1] = "Tank", [2] = "Healer", [3] = "Melee DPS" },
		PALADIN = { [1] = "Healer", [2] = "Tank", [3] = "Melee DPS" },
		PRIEST = { [1] = "Healer", [2] = "Healer", [3] = "Ranged DPS" },
		ROGUE = { [1] = "Melee DPS", [2] = "Melee DPS", [3] = "Melee DPS" },
		SHAMAN = { [1] = "Ranged DPS", [2] = "Melee DPS", [3] = "Healer" },
		WARLOCK = { [1] = "Ranged DPS", [2] = "Ranged DPS", [3] = "Ranged DPS" },
		WARRIOR = { [1] = "Melee DPS", [2] = "Melee DPS", [3] = "Tank" },
	}
	return roles[classToken] and roles[classToken][specIdx] or nil
end

local function OnboardingSpecShortLabel(classToken, title)
	local label = (title or ""):gsub("%s+Guide$", "")
	label = label:gsub("%s+Demon Hunter$", "")
	label = label:gsub("%s+Death Knight$", "")
	label = label:gsub("%s+Hunter$", "")
	label = label:gsub("%s+Evoker$", "")
	label = label:gsub("%s+Druid$", "")
	label = label:gsub("%s+Mage$", "")
	label = label:gsub("%s+Monk$", "")
	label = label:gsub("%s+Paladin$", "")
	label = label:gsub("%s+Priest$", "")
	label = label:gsub("%s+Rogue$", "")
	label = label:gsub("%s+Shaman$", "")
	label = label:gsub("%s+Warlock$", "")
	label = label:gsub("%s+Warrior$", "")
	return label
end

local function TalentUIShortcutDisplay()
	local cmd = "TOGGLETALENTS"
	if GetBindingKey then
		local key = GetBindingKey(cmd)
		if key and key ~= "" and GetBindingText then
			return GetBindingText(key, "KEY_", 1) or key
		end
	end
	return "N"
end

local function FormatSpecOptionLabel(classToken, specIdx, title)
	local label = OnboardingSpecShortLabel(classToken, title)
	if label == "" then
		label = "Spec " .. tostring(specIdx)
	end
	local role = SpecOnboardingRoleNL(classToken, specIdx)
	if role then
		return string.format("Spec %d: %s (%s)", specIdx, label, role)
	end
	return string.format("Spec %d: %s", specIdx, label)
end

--- Each `gear` line is either a locale key (`GUIDE_GEAR_…`) or legacy raw text.
local function ResolveGuideGearLine(line)
	if type(line) ~= "string" or line == "" then
		return ""
	end
	if string.match(line, "^GUIDE_GEAR_") then
		return ns:L(line)
	end
	return line
end

local GUIDE_STAT_HIGHLIGHT_COLOR = "|cff7fd4ff"
local GUIDE_STAT_RESET_COLOR = "|r"
local GUIDE_STAT_TERMS = {
	"Critical Strike",
	"Versatility",
	"Intellect",
	"Strength",
	"Agility",
	"Mastery",
	"Haste",
	"Crit",
}

local function HighlightGuideStatTerms(text)
	if type(text) ~= "string" or text == "" then
		return text
	end
	local out = text
	for i = 1, #GUIDE_STAT_TERMS do
		local term = GUIDE_STAT_TERMS[i]
		local esc = term:gsub("(%W)", "%%%1")
		-- Keep matching conservative (word boundaries) to avoid partial replacements.
		local pat = "(%f[%a])(" .. esc .. ")(%f[%A])"
		out = out:gsub(pat, function(a, b, c)
			return a .. GUIDE_STAT_HIGHLIGHT_COLOR .. b .. GUIDE_STAT_RESET_COLOR .. c
		end)
	end
	return out
end

local function BuildGuideGearText(classToken, specIdx, data)
	local statLead = ""
	if type(data) == "table" and type(data.stats) == "string" and data.stats ~= "" then
		local statText = data.stats
		if string.match(statText, "^GUIDE_") then
			statText = ns:L(statText)
		end
		statLead = "|cffffcc00" .. ns:L("GUIDE_STAT_PRIORITY_LABEL") .. "|r\n" .. statText
	end

	if type(data) == "table" and type(data.gear) == "table" and #data.gear > 0 then
		local parts = {}
		for i = 1, #data.gear do
			parts[#parts + 1] = ResolveGuideGearLine(data.gear[i])
		end
		local gearText = table.concat(parts, "\n")
		if statLead ~= "" then
			return statLead .. "\n\n" .. gearText
		end
		return gearText
	end

	local function withStatPriority(body)
		if statLead ~= "" then
			return statLead .. "\n\n" .. body
		end
		return body
	end

	local role = SpecOnboardingRoleNL(classToken, specIdx) or ""
	if role == "Tank" then
		return withStatPriority(ns:L("GUIDE_GEAR_ROLE_TANK"))
	end
	if role == "Healer" then
		return withStatPriority(ns:L("GUIDE_GEAR_ROLE_HEALER"))
	end
	if role == "Support" then
		return withStatPriority(ns:L("GUIDE_GEAR_ROLE_SUPPORT"))
	end
	if role == "Ranged DPS" then
		return withStatPriority(ns:L("GUIDE_GEAR_ROLE_RANGED_DPS"))
	end
	if role == "Melee DPS" then
		return withStatPriority(ns:L("GUIDE_GEAR_ROLE_MELEE_DPS"))
	end
	if statLead ~= "" then
		return statLead
	end
	return data and data.stats or ""
end

local function NormalizeGuideLevelingLines(lines)
	if type(lines) == "string" and lines ~= "" then
		lines = { lines }
	end
	if type(lines) ~= "table" then
		return {}
	end
	local out = {}
	for i = 1, #lines do
		local row = lines[i]
		if type(row) == "string" and row ~= "" then
			if string.match(row, "^GUIDE_") then
				row = ns:L(row)
			end
			out[#out + 1] = row
		end
	end
	return out
end

local function ResolveGuideLevelingBracket(levelingData, level)
	if type(levelingData) ~= "table" then
		return nil, nil
	end
	local lvl = tonumber(level) or 10
	local bestLevel, bestEntry
	local minLevel, minEntry
	for k, v in pairs(levelingData) do
		local n = tonumber(k)
		if n and type(v) == "table" then
			if (not minLevel) or n < minLevel then
				minLevel, minEntry = n, v
			end
			if n <= lvl and ((not bestLevel) or n > bestLevel) then
				bestLevel, bestEntry = n, v
			end
		end
	end
	if bestEntry then
		return bestLevel, bestEntry
	end
	return minLevel, minEntry
end

local ADVISOR_DEFENSIVE_KEYWORDS = {
	"defensive",
	"defensives",
	"defense",
	"survival",
	"shield",
	"heal",
	"healing",
	"interrupt",
	"stun",
	"mitigation",
	"verdediging",
	"verdedig",
	"schild",
	"genees",
	"healing",
	"onderbreek",
	"overleving",
}

local function ResolveAdvisorArchetype(roleLabel)
	local role = string.lower(tostring(roleLabel or ""))
	if string.find(role, "tank", 1, true) then
		return "tank"
	end
	if string.find(role, "healer", 1, true) or string.find(role, "heal", 1, true) then
		return "healer"
	end
	if string.find(role, "support", 1, true) or string.find(role, "aug", 1, true) then
		return "support"
	end
	if string.find(role, "melee", 1, true) then
		return "melee"
	end
	return "caster"
end

local function BuildGroupsAdvisorLines(roleLabel, bracketKey)
	local arch = string.upper(ResolveAdvisorArchetype(roleLabel))
	local bk = tonumber(bracketKey) or 10
	local prefix = "GUIDE_GROUPS_" .. arch .. "_" .. tostring(bk) .. "_"
	local lines = {}
	for i = 1, 3 do
		local key = prefix .. i
		local s = ns:L(key)
		if type(s) == "string" and s ~= "" and s ~= key then
			lines[#lines + 1] = s
		end
	end
	return lines
end

local function BuildAutoAdvisorLeveling(data, roleLabel)
	local pool = {}
	for i = 1, #(data and data.tips or {}) do
		local tip = data.tips[i]
		local s = tip and (tip.textKey and ns:L(tip.textKey) or tip.text)
		if type(s) == "string" and s ~= "" then
			pool[#pool + 1] = s
		end
	end
	if #pool == 0 then
		return nil
	end

	local defensivePool = {}
	local offensivePool = {}
	for i = 1, #pool do
		local lower = string.lower(pool[i])
		local isDef = false
		for k = 1, #ADVISOR_DEFENSIVE_KEYWORDS do
			if string.find(lower, ADVISOR_DEFENSIVE_KEYWORDS[k], 1, true) then
				isDef = true
				break
			end
		end
		if isDef then
			defensivePool[#defensivePool + 1] = pool[i]
		else
			offensivePool[#offensivePool + 1] = pool[i]
		end
	end
	if #offensivePool == 0 then
		offensivePool = pool
	end
	if #defensivePool == 0 then
		defensivePool = pool
	end

	local function pickRows(src, startIdx, want)
		local out = {}
		if #src == 0 then
			return out
		end
		for step = 0, want - 1 do
			local idx = ((startIdx + step - 1) % #src) + 1
			out[#out + 1] = src[idx]
		end
		return out
	end

	local arch = ResolveAdvisorArchetype(roleLabel)
	local roleKeys = {
		tank = { "GUIDE_LEVEL_ADVISOR_AUTO_TALENT_TANK_1", "GUIDE_LEVEL_ADVISOR_AUTO_TALENT_TANK_2" },
		healer = { "GUIDE_LEVEL_ADVISOR_AUTO_TALENT_HEALER_1", "GUIDE_LEVEL_ADVISOR_AUTO_TALENT_HEALER_2" },
		support = { "GUIDE_LEVEL_ADVISOR_AUTO_TALENT_SUPPORT_1", "GUIDE_LEVEL_ADVISOR_AUTO_TALENT_SUPPORT_2" },
		melee = { "GUIDE_LEVEL_ADVISOR_AUTO_TALENT_MELEE_1", "GUIDE_LEVEL_ADVISOR_AUTO_TALENT_MELEE_2" },
		caster = { "GUIDE_LEVEL_ADVISOR_AUTO_TALENT_RANGED_1", "GUIDE_LEVEL_ADVISOR_AUTO_TALENT_RANGED_2" },
	}
	local selectedKeys = roleKeys[arch] or roleKeys.caster
	local talentFocus = { ns:L(selectedKeys[1]), ns:L(selectedKeys[2]) }

	local function bracketEntry(offStart, offCount, defStart, defCount, bk)
		return {
			rotation = pickRows(offensivePool, offStart, offCount),
			defensives = pickRows(defensivePool, defStart, defCount),
			talentFocus = talentFocus,
			groups = BuildGroupsAdvisorLines(roleLabel, bk),
		}
	end

	return {
		[10] = bracketEntry(1, 3, 1, 2, 10),
		[30] = bracketEntry(2, 3, 2, 2, 30),
		[60] = bracketEntry(3, 3, 3, 2, 60),
		[80] = bracketEntry(4, 2, 4, 2, 80),
	}
end

function ns.ClearGuideUI()
	if not scrollContent then
		return
	end

	-- Frames only; FontStrings on scrollContent are cleared via lastGuideCenterFs / child frames (e.g. gearHost).
	DestroyAllChildren(scrollContent)
	DestroyAllRegions(scrollContent)
	if lastGuideCenterFs and lastGuideCenterFs.SetParent then
		lastGuideCenterFs:Hide()
		lastGuideCenterFs:SetParent(nil)
		lastGuideCenterFs = nil
	end
end

-- Before the player finalizes a spec, GetSpecialization() is often nil/0, or 5+ (legacy "initial" / tutorial) while 1..GetNumSpecializations() is the only valid range.
local function IsPlayerSpecLockedIn()
	if not GetSpecialization or not GetNumSpecializations then
		return false
	end
	local n = GetNumSpecializations() or 0
	if n < 1 then
		return false
	end
	local s = GetSpecialization()
	if s == nil or s < 1 then
		return false
	end
	return s <= n
end

--------------------------------------------------------------------------------
-- Search / preview: other class+spec + jump to main tabs (Guide.lua owns UI).
--------------------------------------------------------------------------------
local guideSearchIndexBuilt = false
local guideSearchEntries = {}
local ScheduleGuidePopulate

local CLASS_SEARCH_ALIASES = {
	DEATHKNIGHT = "death knight deathknight dk",
	DEMONHUNTER = "demon hunter demonhunter dh",
	EVOKER = "evoker",
	HUNTER = "hunter",
	MAGE = "mage",
	MONK = "monk",
	PALADIN = "paladin pala",
	PRIEST = "priest",
	ROGUE = "rogue",
	SHAMAN = "shaman sham",
	WARLOCK = "warlock lock",
	WARRIOR = "warrior war",
	DRUID = "druid",
}

local function SanitizeGuideDb()
	local db = ns.db
	if not db then
		return nil
	end
	if type(db.guide) ~= "table" then
		db.guide = {
			preview = false,
			classToken = "",
			specIndex = 0,
		}
	end
	return db.guide
end

local function ClassFileToClassID(classToken)
	local up = string.upper(tostring(classToken or ""))
	local n = GetNumClasses and GetNumClasses() or 0
	for i = 1, n do
		local ok, _, file, id = pcall(GetClassInfo, i)
		if ok and file and id and string.upper(tostring(file)) == up then
			return id
		end
	end
	return nil
end

local function SpecIconForClassSpecIndex(classToken, specIdx)
	local cid = ClassFileToClassID(classToken)
	if not cid or not specIdx or specIdx < 1 or not GetSpecializationInfoForClassID then
		return nil
	end
	local ok, _, _, _, icon = pcall(GetSpecializationInfoForClassID, cid, specIdx)
	if ok and icon and ((type(icon) == "number" and icon > 0) or (type(icon) == "string" and icon ~= "")) then
		return icon
	end
	return nil
end

local function EnsureGuideSearchIndex()
	if guideSearchIndexBuilt then
		return
	end
	guideSearchIndexBuilt = true
	local gd = ns.GuideData
	if type(gd) ~= "table" then
		return
	end
	for classFile, specs in pairs(gd) do
		if type(classFile) == "string" and type(specs) == "table" then
			local extra = CLASS_SEARCH_ALIASES[string.upper(classFile)] or ""
			for idx = 1, 12 do
				local e = specs[idx]
				if type(e) == "table" and type(e.title) == "string" and e.title ~= "" then
					local tl = string.lower(e.title)
					local cf = string.lower(classFile)
					local blob = tl .. " " .. cf .. " " .. string.lower(extra)
					guideSearchEntries[#guideSearchEntries + 1] = {
						classFile = string.upper(classFile),
						specIndex = idx,
						title = e.title,
						blob = blob,
					}
				end
			end
		end
	end
	table.sort(guideSearchEntries, function(a, b)
		if a.classFile ~= b.classFile then
			return a.classFile < b.classFile
		end
		return (a.specIndex or 0) < (b.specIndex or 0)
	end)
end

local function TrimString(s)
	return (tostring(s or ""):gsub("^%s*(.-)%s*$", "%1"))
end

local function GuideChatMsg(key, ...)
	local fmt = ns:L(key)
	local text = fmt
	if select("#", ...) > 0 then
		text = fmt:format(...)
	end
	print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), text))
end

-- Words stripped when matching a spec alongside consumable search terms (e.g. "food frost" → frost).
local CONSUMABLE_SEARCH_TOKENS = {
	consumable = true,
	consumables = true,
	flask = true,
	flasks = true,
	feast = true,
	food = true,
	potion = true,
	potions = true,
	verbruik = true,
	verbruiks = true,
	runeforg = true,
	runeforge = true,
	oil = true,
}

local function ScoreGuideSearchRow(row, needle)
	if not needle or needle == "" or not row.blob:find(needle, 1, true) then
		return nil
	end
	local titleL = string.lower(row.title)
	local score = 0
	if titleL:find(needle, 1, true) then
		score = score + 400
	end
	if #needle > 0 and #needle <= #titleL and titleL:sub(1, #needle) == needle then
		score = score + 200
	end
	score = score - (#row.title) * 0.05
	return score
end

local function FindBestGuideSearchEntry(q)
	local best, bestScore = nil, -1e9
	local function consider(needle)
		if not needle or needle == "" then
			return
		end
		for i = 1, #guideSearchEntries do
			local row = guideSearchEntries[i]
			local score = ScoreGuideSearchRow(row, needle)
			if score and score > bestScore then
				bestScore = score
				best = row
			end
		end
	end
	consider(q)
	for w in string.gmatch(q, "%S+") do
		if not CONSUMABLE_SEARCH_TOKENS[w] then
			consider(w)
		end
	end
	return best
end

local function QueryHasConsumableKeyword(q, qHitsFn)
	if qHitsFn({
		"consumable",
		"consumables",
		"flask",
		"flasks",
		"feast",
		"food",
		"potion",
		"potions",
		"healing pot",
		"weapon oil",
		"runeforg",
		"verbruik",
		"verbruiks",
	}) then
		return true
	end
	for w in string.gmatch(q, "%S+") do
		if CONSUMABLE_SEARCH_TOKENS[w] then
			return true
		end
	end
	return false
end

local function ApplyGuideSearchQuery(raw)
	EnsureGuideSearchIndex()
	local q = string.lower(TrimString(raw))
	if q == "" then
		GuideChatMsg("SEARCH_CHAT_EMPTY")
		return
	end

	local function qHits(words)
		for i = 1, #words do
			if q:find(words[i], 1, true) then
				return true
			end
		end
		return false
	end

	if qHits({
		"in groups",
		"ingroup",
		"in group",
		"groepen",
		"groep",
		"group tips",
		"dungeon tips",
		"interrupt priority",
		"interrupt prio",
	}) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("guide")
			ns._mhGuideAdvisorTab = "groups"
			if ns._mhSelectGuideSubTab then
				ns._mhSelectGuideSubTab("guide")
			end
		end
		GuideChatMsg("SEARCH_CHAT_GUIDE_GROUPS")
		return
	end

	if qHits({
		"academy",
		"role academy",
		"masterclass",
		"master class",
		"tank track",
		"heal track",
		"leren tank",
		"leren heal",
		"tanken",
		"healen",
		"group role",
		"dungeon anxiety",
		"raid anxiety",
		"mentor",
	}) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("academy")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_ACADEMY")
		return
	end

	if qHits({
		"delve",
		"delves",
		"vault",
		"great vault",
		"undertyr",
		"bountiful",
		"companion",
		"brann",
		"zekvir",
		"undercoin",
		"undercoins",
		"delves key",
		"curios",
		"curio",
		"spore",
		"dreadshore",
		"stormstout",
		"dornogal",
		"delves &",
		"delves and",
		"m+ teleport",
		"m+ teleports",
	}) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("delves")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_DELVES")
		return
	end

	if qHits({ "prof", "beroep", "treasure", "kp", "recipe", "craft" }) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("professions")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_PROFESSIONS")
		return
	end

	if qHits({ "smc", "silvermoon", "city guide", "harandar", "voidstorm", "bazaar" }) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("smcguide")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_SMC")
		return
	end

	local smcRows = ns._mhSMCGuideSearchRows
	if type(smcRows) == "table" and #smcRows > 0 then
		local smcBest, smcScore = nil, -1e9
		for si = 1, #smcRows do
			local srow = smcRows[si]
			local blob = srow.blob
			local pt = srow.point
			if type(blob) == "string" and blob:find(q, 1, true) and type(pt) == "table" then
				local score = 120
				local lab = string.lower(tostring(pt.label or ""))
				if lab:find(q, 1, true) then
					score = score + 350
				end
				if #q > 0 and #q <= #lab and lab:sub(1, #q) == q then
					score = score + 180
				end
				score = score - #blob * 0.01
				if score > smcScore then
					smcScore = score
					smcBest = srow
				end
			end
		end
		if smcBest and smcBest.point then
			local p = smcBest.point
			if ns.ShowMainUI and ns.SelectTab then
				ns:ShowMainUI()
				ns.SelectTab("smcguide")
			end
			local function doJump()
				if ns.JumpSMCCityGuideToPoint then
					ns.JumpSMCCityGuideToPoint(p)
				end
			end
			if C_Timer and C_Timer.After then
				C_Timer.After(0.05, doJump)
			else
				doJump()
			end
			GuideChatMsg("SEARCH_CHAT_SMC_PIN_FMT", tostring(p.label or "?"))
			return
		end
	end

	if q:find("addons", 1, true) and not q:find("platynator", 1, true) and not q:find("wago", 1, true) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("addons")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_ADDONS")
		return
	end

	if qHits({ "platynator", "wago", "visual guide" }) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("addons")
		end
		if ns.SelectAddonSubTab and ns._mhAddonSubTabById and ns._mhAddonSubTabById.platynator then
			ns.SelectAddonSubTab("platynator")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_ADDONS_PLATY")
		return
	end

	if qHits({ "leveling", "icy", "gids", "guide tab" }) then
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("guide")
		end
		GuideChatMsg("SEARCH_CHAT_TAB_GUIDE")
		return
	end

	local best = FindBestGuideSearchEntry(q)
	local wantsConsumables = QueryHasConsumableKeyword(q, qHits)

	if not best and not wantsConsumables then
		GuideChatMsg("SEARCH_CHAT_NO_MATCH_FMT", tostring(raw))
		return
	end

	local gdb = SanitizeGuideDb()
	if best and gdb then
		gdb.preview = true
		gdb.classToken = best.classFile
		gdb.specIndex = best.specIndex
	elseif wantsConsumables and gdb then
		gdb.preview = false
		gdb.classToken = ""
		gdb.specIndex = 0
	end
	if ns.RefreshGuideTabVisibility then
		ns:RefreshGuideTabVisibility()
	end
	if ns.ShowMainUI and ns.SelectTab then
		ns:ShowMainUI()
		if wantsConsumables then
			ns.SelectTab("consumables")
		else
			ns.SelectTab("guide")
		end
	end
	if wantsConsumables then
		if best then
			GuideChatMsg("SEARCH_CHAT_CONS_PREVIEW_FMT", best.title, best.classFile, best.specIndex)
		else
			GuideChatMsg("SEARCH_CHAT_TAB_CONSUMABLES")
		end
	else
		GuideChatMsg("SEARCH_CHAT_GUIDE_PREVIEW_FMT", best.title, best.classFile, best.specIndex)
	end
	ScheduleGuidePopulate()
	if ns.MH_RefreshMacrosPanel then
		ns.MH_RefreshMacrosPanel()
	end
	if ns.MH_RefreshConsumablesPanel then
		ns.MH_RefreshConsumablesPanel()
	end
end

local function ClearGuidePreviewAndRefresh()
	local gdb = SanitizeGuideDb()
	if gdb then
		gdb.preview = false
		gdb.classToken = ""
		gdb.specIndex = 0
	end
	if ns.RefreshGuideTabVisibility then
		ns:RefreshGuideTabVisibility()
	end
	if ns.mhSearchEdit and ns.mhSearchEdit.SetText then
		ns.mhSearchEdit:SetText("")
	end
	ScheduleGuidePopulate()
	GuideChatMsg("SEARCH_CHAT_GUIDE_PREVIEW_CLEARED")
	if ns.MH_RefreshMacrosPanel then
		ns.MH_RefreshMacrosPanel()
	end
	if ns.MH_RefreshConsumablesPanel then
		ns.MH_RefreshConsumablesPanel()
	end
end

ns.MH_RunSearchQuery = ApplyGuideSearchQuery
ns.MH_ClearSearchAndPreview = ClearGuidePreviewAndRefresh

local function PopulateUniversalGuideContent()
	if guideRoot and not guideRoot:IsVisible() then
		return
	end
	ns.ClearGuideUI()
	if not scrollContent or not titleFs then
		return
	end

	local playerName = UnitName("player") or "?"
	-- select(2, …) = English class file tag — keys: ["DRUID"], ["DEATHKNIGHT"], ["DEMONHUNTER"], ["EVOKER"], ["HUNTER"], ["MAGE"], ["MONK"], ["PALADIN"], ["PRIEST"], ["ROGUE"], ["SHAMAN"], ["WARLOCK"], ["WARRIOR"].
	local classFile = select(2, UnitClass("player"))
	local classToken = (classFile and string.upper(classFile)) or ""
	local level = UnitLevel("player") or 0
	local fullW = math.max(200, scrollContent:GetWidth() or 520)
	local specIdx = (GetSpecialization and GetSpecialization()) or 0
	local specIsLocked = IsPlayerSpecLockedIn()

	local gdb = SanitizeGuideDb()
	if gdb and gdb.preview then
		local ct = type(gdb.classToken) == "string" and string.upper(gdb.classToken) or ""
		local ix = tonumber(gdb.specIndex) or 0
		if ct == "" or ix < 1 or not (ns.GuideData and ns.GuideData[ct] and ns.GuideData[ct][ix]) then
			gdb.preview = false
			gdb.classToken = ""
			gdb.specIndex = 0
		end
	end

	local guideIsPreviewView = gdb and gdb.preview == true and type(gdb.classToken) == "string" and gdb.classToken ~= ""
	if guideIsPreviewView then
		classToken = string.upper(gdb.classToken)
		specIdx = tonumber(gdb.specIndex) or 1
	end

	--- Spec icon in top bar; subtle themed rim + soft outer glow on the guide body (titleColor).
	local function syncGuideTopBarAndScrollBorder(thForBorder)
		thForBorder = thForBorder or DEFAULT_THEME
		local c = (thForBorder.titleColor or DEFAULT_THEME.titleColor)
		if guideThemeGlowOuter and guideThemeGlowOuter.SetBackdropBorderColor then
			guideThemeGlowOuter:SetBackdropBorderColor(c[1], c[2], c[3], 0.12)
		end
		if guideContentBorder and guideContentBorder.SetBackdropBorderColor then
			guideContentBorder:SetBackdropBorderColor(c[1], c[2], c[3], 0.38)
		end
		if not guideTopBar or not titleFs or not specHeaderIcon then
			return
		end
		if (level < 10 and not guideIsPreviewView) or ((not specIsLocked) and (not guideIsPreviewView)) or not specIdx or specIdx < 1 then
			specHeaderIcon:Hide()
			titleFs:ClearAllPoints()
			titleFs:SetPoint("LEFT", guideTopBar, "LEFT", 10, 0)
			titleFs:SetPoint("RIGHT", guideTopBar, "RIGHT", -10, 0)
			return
		end
		local specIcon
		if guideIsPreviewView then
			specIcon = SpecIconForClassSpecIndex(classToken, specIdx)
		else
			local ok, ic = pcall(function()
				return select(4, GetSpecializationInfo(specIdx))
			end)
			if ok then
				specIcon = ic
			end
		end
		local iconOk = specIcon
			and (
				(type(specIcon) == "number" and specIcon > 0)
				or (type(specIcon) == "string" and specIcon ~= "")
			)
		if iconOk then
			specHeaderIcon:SetTexture(specIcon)
			specHeaderIcon:Show()
			titleFs:ClearAllPoints()
			titleFs:SetPoint("LEFT", specHeaderIcon, "RIGHT", 6, 0)
			titleFs:SetPoint("RIGHT", guideTopBar, "RIGHT", -10, 0)
		else
			specHeaderIcon:Hide()
			titleFs:ClearAllPoints()
			titleFs:SetPoint("LEFT", guideTopBar, "LEFT", 10, 0)
			titleFs:SetPoint("RIGHT", guideTopBar, "RIGHT", -10, 0)
		end
	end

	ApplyTheme(DEFAULT_THEME, tintTex, topBarTex, titleFs)

	-- A: Under level 10 — no spec UI yet; goal is level 10 (unless previewing another spec from search).
	if level < 10 and not guideIsPreviewView then
		titleFs:SetText(ns:L("GUIDE_TITLE_FMT"):format(playerName))
		syncGuideTopBarAndScrollBorder(DEFAULT_THEME)
		PlaceCenteredGuideMessage(scrollContent, fullW, ns:L("GUIDE_MSG_UNDER_10"))
		if scroll and scroll.SetVerticalScroll then
			scroll:SetVerticalScroll(0)
		end
		if scroll and scroll.UpdateScrollChildRect then
			scroll:UpdateScrollChildRect()
		end
		return
	end

	-- B: Level 10+ but specialization not in the valid 1..GetNumSpecializations() range yet (nil, 0, 5, …) — list options from GuideData.
	if not specIsLocked and not guideIsPreviewView then
		titleFs:SetText(ns:L("GUIDE_TITLE_FMT"):format(playerName))
		local keyHint = TalentUIShortcutDisplay()
		local parts = {
			ns:L("GUIDE_SPEC_CHOOSE_TITLE"),
			"",
			ns:L("GUIDE_SPEC_KEY_FMT"):format(keyHint),
			"",
			ns:L("GUIDE_SPEC_OPTIONS_LABEL"),
			"",
		}
		local specLinesStart = #parts
		local cg = (ns.GuideData and classToken ~= "" and ns.GuideData[classToken]) or nil
		if cg then
			for idx = 1, 12 do
				local entry = cg[idx]
				if entry and type(entry) == "table" and entry.title then
					local label = OnboardingSpecShortLabel(classToken, entry.title)
					local role = SpecOnboardingRoleNL(classToken, idx)
					if role then
						parts[#parts + 1] = string.format("%d: %s (%s)", idx, label, role)
					else
						parts[#parts + 1] = string.format("%d: %s", idx, label)
					end
				end
			end
		end
		if #parts == specLinesStart then
			parts[#parts + 1] = ns:L("GUIDE_SPEC_NONE_FOR_CLASS")
		end
		PlaceCenteredGuideMessage(scrollContent, fullW, table.concat(parts, "\n"))
		syncGuideTopBarAndScrollBorder(DEFAULT_THEME)
		if scroll and scroll.SetVerticalScroll then
			scroll:SetVerticalScroll(0)
		end
		if scroll and scroll.UpdateScrollChildRect then
			scroll:UpdateScrollChildRect()
		end
		return
	end

	-- C and normal path: locked spec index 1..specCount.
	local data
	if ns.GuideData and classToken ~= "" and ns.GuideData[classToken] then
		data = ns.GuideData[classToken][specIdx]
	end

	local theme = (data and data.theme) or DEFAULT_THEME
	ApplyTheme(theme, tintTex, topBarTex, titleFs)

	if not data then
		titleFs:SetText(ns:L("GUIDE_TITLE_FMT"):format(playerName))
		syncGuideTopBarAndScrollBorder(theme)
		PlaceCenteredGuideMessage(scrollContent, fullW, ns:L("GUIDE_NOT_READY"))
		if scroll and scroll.SetVerticalScroll then
			scroll:SetVerticalScroll(0)
		end
		if scroll and scroll.UpdateScrollChildRect then
			scroll:UpdateScrollChildRect()
		end
		return
	end

	local headerRole = SpecOnboardingRoleNL(classToken, specIdx)
	local previewMark = guideIsPreviewView and ns:L("GUIDE_PREVIEW_MARK") or ""
	if guideIsPreviewView then
		if headerRole then
			titleFs:SetText(data.title .. " (" .. headerRole .. ")" .. previewMark)
		else
			titleFs:SetText(data.title .. previewMark)
		end
	else
		if headerRole then
			titleFs:SetText(data.title .. " (" .. headerRole .. ") — " .. playerName)
		else
			titleFs:SetText(data.title .. " — " .. playerName)
		end
	end
	syncGuideTopBarAndScrollBorder(theme)

	local y = 0

	local function nextY(h)
		y = y - h
		return y
	end

	local function addSectionHeader(parent, text, w, barH, gapAfter, th)
		barH = barH or 24
		gapAfter = gapAfter or 4
		local bar = CreateFrame("Frame", nil, parent)
		bar:SetSize(w, barH)
		bar:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y)
		local bt = bar:CreateTexture(nil, "BACKGROUND")
		bt:SetAllPoints()
		local sb = th.sectionBar or DEFAULT_THEME.sectionBar
		bt:SetColorTexture(sb[1], sb[2], sb[3], sb[4])
		local accent = bar:CreateTexture(nil, "OVERLAY")
		accent:SetHeight(1)
		accent:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 4, 0)
		accent:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -4, 0)
		local ac = th.titleColor or DEFAULT_THEME.titleColor
		accent:SetColorTexture(ac[1], ac[2], ac[3], 0.45)
		local fs = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalMed3")
		fs:SetPoint("LEFT", bar, "LEFT", 8, 0)
		fs:SetJustifyH("LEFT")
		fs:SetText(text)
		local st = th.sectionText or DEFAULT_THEME.sectionText
		fs:SetTextColor(st[1], st[2], st[3])
		nextY(barH + gapAfter)
		return bar
	end

	local th = theme

	addSectionHeader(scrollContent, ns:L("GUIDE_SECTION_TOP_TIPS_FMT"):format(playerName), fullW, 24, 4, th)

	local layoutSlug = ns.MH_GetHunterKeybindSlugForUi and ns.MH_GetHunterKeybindSlugForUi()
	if layoutSlug then
		local hintBar = CreateFrame("Frame", nil, scrollContent)
		hintBar:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, y)
		hintBar:SetWidth(fullW)
		local tipsHintFs = hintBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		tipsHintFs:SetPoint("TOPLEFT", hintBar, "TOPLEFT", 4, 0)
		tipsHintFs:SetWidth(fullW - 8)
		tipsHintFs:SetJustifyH("LEFT")
		tipsHintFs:SetWordWrap(true)
		tipsHintFs:SetSpacing(2)
		tipsHintFs:SetText(ns:L("GUIDE_TIPS_KEY_HINT"))
		tipsHintFs:SetTextColor(0.78, 0.74, 0.68)
		local hintH = tipsHintFs:GetStringHeight()
		if not hintH or hintH < 1 then
			hintH = 36
		end
		hintBar:SetHeight(hintH)
		nextY(hintH + 8)
	end

	local tipsHost = CreateFrame("Frame", nil, scrollContent)
	tipsHost:SetSize(fullW, 1)
	tipsHost:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, y)

	local padX = 6
	local yy = 0
	for i, tip in ipairs(data.tips or {}) do
		local row = CreateFrame("Frame", nil, tipsHost)
		row:SetSize(fullW - 8, TIP_ROW_HEIGHT)
		row:SetPoint("TOPLEFT", tipsHost, "TOPLEFT", 0, yy)

		local iconHit = CreateFrame("Button", nil, row)
		iconHit:SetSize(TIP_ICON_SIZE + 6, TIP_ICON_SIZE + 6)
		iconHit:SetPoint("CENTER", row, "LEFT", TIP_ICON_SIZE / 2, 0)
		iconHit:EnableMouse(true)
		iconHit:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		local hi = iconHit:CreateTexture(nil, "HIGHLIGHT")
		hi:SetAllPoints()
		hi:SetColorTexture(1, 1, 1, 0.12)

		local icon = iconHit:CreateTexture(nil, "ARTWORK")
		icon:SetSize(TIP_ICON_SIZE, TIP_ICON_SIZE)
		icon:SetPoint("CENTER", iconHit, "CENTER", 0, 0)
		icon:SetTexture(SpellIconFile(tip.spell))

		local sid = tip.spell
		iconHit:SetScript("OnEnter", function(self)
			ShowSpellTooltipForIcon(self, sid)
		end)
		iconHit:SetScript("OnLeave", function()
			if _G.GameTooltip then
				_G.GameTooltip:Hide()
			end
		end)
		iconHit:SetScript("OnClick", function(self)
			ShowSpellTooltipForIcon(self, sid)
		end)

		local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetPoint("TOPLEFT", iconHit, "TOPRIGHT", padX - 3, 0)
		fs:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", -4, 0)
		fs:SetJustifyH("LEFT")
		if fs.SetJustifyV then
			fs:SetJustifyV("MIDDLE")
		end
		fs:SetSpacing(2)
		fs:SetWordWrap(true)
		fs:SetTextColor(0.92, 0.90, 0.82)
		local tipStr = (ns.MH_ResolveGuideTipText and ns:MH_ResolveGuideTipText(tip))
			or (tip.textKey and ns:L(tip.textKey))
			or tip.text
			or ""
		fs:SetText(tipStr)

		local slug = ns.MH_GetHunterKeybindSlugForUi and ns.MH_GetHunterKeybindSlugForUi()
		local uiKey = slug and sid and ns.MH_Keybind_GetUiKeyForSpell and ns.MH_Keybind_GetUiKeyForSpell(sid, slug)
		local keycap = slug
			and sid
			and ns.MH_Keybind_GetKeycapLabelForSpell
			and ns.MH_Keybind_GetKeycapLabelForSpell(sid, slug)
		local keyLabel = keycap or uiKey
		local noKeycap = slug and sid and ns.MH_Keybind_IsGuideSpellWithoutKeycap
			and ns.MH_Keybind_IsGuideSpellWithoutKeycap(sid, slug)
		if uiKey and not noKeycap and ns.MH_GuideOpenLayoutForSpell then
			fs:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", -36, 0)
			local keyBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
			keyBtn:SetSize(30, 22)
			keyBtn:SetPoint("RIGHT", row, "RIGHT", -2, 0)
			keyBtn:SetText(keyLabel or uiKey)
			local fsKey = keyBtn:GetFontString()
			if fsKey and fsKey.SetTextColor then
				fsKey:SetTextColor(1, 0.88, 0.42)
			end
			keyBtn:SetScript("OnClick", function()
				ns.MH_GuideOpenLayoutForSpell(sid)
			end)
			keyBtn:SetScript("OnEnter", function(self)
				local gt = _G.GameTooltip
				if not gt then
					return
				end
				gt:SetOwner(self, "ANCHOR_LEFT")
				gt:SetText(ns:L("GUIDE_TIP_LAYOUT_KEY_BTN_FMT"):format(keyLabel or uiKey), 1, 1, 1)
				gt:Show()
			end)
			keyBtn:SetScript("OnLeave", function()
				local gt = _G.GameTooltip
				if gt then
					gt:Hide()
				end
			end)
		end

		yy = yy - TIP_ROW_HEIGHT - TIP_ROW_GAP
	end
	tipsHost:SetHeight(math.abs(yy))
	nextY(math.abs(yy) + 8)
	-- If later code errors before the final SetHeight, keep at least the tips area visible.
	scrollContent:SetHeight(math.max(1, math.abs(y) + 20))

	addSectionHeader(scrollContent, ns:L("GUIDE_SECTION_LEVEL_ADVISOR"), fullW, nil, nil, th)
	local advisorHost = CreateFrame("Frame", nil, scrollContent, "BackdropTemplate")
	if advisorHost.SetBackdrop then
		advisorHost:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		})
		local ib = th.icyBackdrop or DEFAULT_THEME.icyBackdrop
		local br = th.icyBorder or DEFAULT_THEME.icyBorder
		advisorHost:SetBackdropColor(ib[1], ib[2], ib[3], ib[4])
		advisorHost:SetBackdropBorderColor(br[1], br[2], br[3], 0.85)
	end
	advisorHost:SetSize(fullW - 8, ADVISOR_BOX_HEIGHT)
	advisorHost:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 4, y)
	local advisorTitle = advisorHost:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	advisorTitle:SetPoint("TOPLEFT", advisorHost, "TOPLEFT", 10, -10)
	advisorTitle:SetJustifyH("LEFT")
	advisorTitle:SetTextColor(0.90, 0.88, 0.78)
	advisorTitle:SetText(ns:L("GUIDE_LEVEL_ADVISOR_BETA"))

	local selectedLevel = math.max(10, math.min(90, tonumber(level) or 10))
	local selectedTab = ns._mhGuideAdvisorTab or "rotation"
	if ns._mhGuideAdvisorTab then
		ns._mhGuideAdvisorTab = nil
	end
	local effectiveLeveling = data.leveling
	local bracketKey, bracketEntry = ResolveGuideLevelingBracket(effectiveLeveling, selectedLevel)
	if not bracketEntry then
		local autoLeveling = BuildAutoAdvisorLeveling(data, headerRole)
		if autoLeveling then
			effectiveLeveling = autoLeveling
			bracketKey, bracketEntry = ResolveGuideLevelingBracket(effectiveLeveling, selectedLevel)
			advisorTitle:SetText(ns:L("GUIDE_LEVEL_ADVISOR_BETA") .. " " .. ns:L("GUIDE_LEVEL_ADVISOR_AUTO_BADGE"))
		end
	end

	if bracketEntry then
		local tabDefs = {
			{ key = "rotation", labelKey = "GUIDE_LEVEL_ADVISOR_TAB_ROTATION", dataKey = "rotation" },
			{ key = "defensives", labelKey = "GUIDE_LEVEL_ADVISOR_TAB_DEFENSIVES", dataKey = "defensives" },
			{ key = "groups", labelKey = "GUIDE_LEVEL_ADVISOR_TAB_GROUPS", dataKey = "groups" },
			{ key = "talentFocus", labelKey = "GUIDE_LEVEL_ADVISOR_TAB_TALENTS", dataKey = "talentFocus" },
		}
		local tabButtons = {}
		local prevBtn
		for i = 1, #tabDefs do
			local td = tabDefs[i]
			local label = ns:L(td.labelKey)
			if label == td.labelKey then
				if td.dataKey == "groups" then
					label = "In groups"
				elseif td.dataKey == "talentFocus" then
					label = "Talents"
				end
			end
			local btn = CreateFrame("Button", nil, advisorHost, "UIPanelButtonTemplate")
			btn:SetHeight(ADVISOR_TAB_H)
			btn:SetText(label)
			local fs = btn.GetFontString and btn:GetFontString()
			local textW = 64
			if fs and fs.GetStringWidth then
				textW = fs:GetStringWidth() or textW
			end
			btn:SetWidth(math.min(130, math.max(72, math.ceil(textW) + 20)))
			if prevBtn then
				btn:SetPoint("LEFT", prevBtn, "RIGHT", ADVISOR_TAB_GAP, 0)
			else
				btn:SetPoint("TOPLEFT", advisorHost, "TOPLEFT", 10, -32)
			end
			btn._mhTabKey = td.key
			btn._mhDataKey = td.dataKey
			tabButtons[#tabButtons + 1] = btn
			prevBtn = btn
		end

		local levelLabel = advisorHost:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		levelLabel:SetPoint("TOPLEFT", advisorHost, "TOPLEFT", 10, -58)
		levelLabel:SetJustifyH("LEFT")
		levelLabel:SetTextColor(0.95, 0.90, 0.62)

		local slider = CreateFrame("Slider", nil, advisorHost, "OptionsSliderTemplate")
		slider:SetPoint("TOPLEFT", advisorHost, "TOPLEFT", 88, -62)
		slider:SetPoint("TOPRIGHT", advisorHost, "TOPRIGHT", -18, -62)
		slider:SetMinMaxValues(10, 90)
		slider:SetValueStep(1)
		slider:SetObeyStepOnDrag(true)
		slider:SetValue(selectedLevel)
		if slider.Low then
			slider.Low:SetText("10")
		end
		if slider.High then
			slider.High:SetText("90")
		end
		if slider.Text then
			slider.Text:SetText("")
		end

		local bodyFs = advisorHost:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		bodyFs:SetPoint("TOPLEFT", advisorHost, "TOPLEFT", 10, -92)
		bodyFs:SetPoint("BOTTOMRIGHT", advisorHost, "BOTTOMRIGHT", -10, 10)
		bodyFs:SetJustifyH("LEFT")
		bodyFs:SetJustifyV("TOP")
		bodyFs:SetWordWrap(true)
		bodyFs:SetSpacing(3)
		bodyFs:SetTextColor(0.92, 0.90, 0.84)

		local function refreshAdvisor()
			bracketKey, bracketEntry = ResolveGuideLevelingBracket(effectiveLeveling, selectedLevel)
			levelLabel:SetText(ns:L("GUIDE_LEVEL_ADVISOR_LEVEL_FMT"):format(selectedLevel))
			for i = 1, #tabButtons do
				local b = tabButtons[i]
				local active = b._mhDataKey == selectedTab
				b:SetAlpha(active and 1 or 0.85)
			end
			local lines = {}
			if bracketEntry and selectedTab then
				if selectedTab == "groups" then
					lines = NormalizeGuideLevelingLines(bracketEntry.groups)
					if #lines == 0 then
						lines = BuildGroupsAdvisorLines(headerRole, bracketKey)
					end
				else
					lines = NormalizeGuideLevelingLines(bracketEntry[selectedTab])
				end
			end
			local out = {}
			if bracketKey then
				out[#out + 1] = ns:L("GUIDE_LEVEL_ADVISOR_BRACKET_FMT"):format(bracketKey)
				out[#out + 1] = ""
			end
			if #lines == 0 then
				out[#out + 1] = ns:L("GUIDE_LEVEL_ADVISOR_EMPTY_TAB")
			else
				for i = 1, #lines do
					out[#out + 1] = "• " .. lines[i]
				end
				if selectedTab == "talentFocus" then
					local milestones = NormalizeGuideLevelingLines(bracketEntry.talentMilestones)
					if #milestones > 0 then
						out[#out + 1] = ""
						out[#out + 1] = ns:L("GUIDE_LEVEL_ADVISOR_MILESTONES_HEADER")
						for i = 1, #milestones do
							out[#out + 1] = "• " .. milestones[i]
						end
					end
				end
			end
			bodyFs:SetText(table.concat(out, "\n"))
		end

		for i = 1, #tabButtons do
			local b = tabButtons[i]
			b:SetScript("OnClick", function(self)
				selectedTab = self._mhDataKey or self._mhTabKey
				refreshAdvisor()
			end)
		end
		slider:SetScript("OnValueChanged", function(_, value)
			selectedLevel = math.floor((tonumber(value) or selectedLevel) + 0.5)
			refreshAdvisor()
		end)
		refreshAdvisor()
	else
		local emptyFs = advisorHost:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		emptyFs:SetPoint("TOPLEFT", advisorHost, "TOPLEFT", 10, -34)
		emptyFs:SetPoint("TOPRIGHT", advisorHost, "TOPRIGHT", -10, -34)
		emptyFs:SetPoint("BOTTOMLEFT", advisorHost, "BOTTOMLEFT", 10, 10)
		emptyFs:SetJustifyH("LEFT")
		emptyFs:SetJustifyV("TOP")
		emptyFs:SetWordWrap(true)
		emptyFs:SetSpacing(3)
		emptyFs:SetTextColor(0.88, 0.84, 0.76)
		emptyFs:SetText(ns:L("GUIDE_LEVEL_ADVISOR_NO_DATA"))
	end
	nextY(ADVISOR_BOX_HEIGHT + 12)

	local wowheadCons = ns.MH_GetConsumablesWowheadForSpec and ns.MH_GetConsumablesWowheadForSpec(classToken, specIdx)
	local cons = data.consumables
	local function consumableEntryPresent(v)
		if type(v) == "number" and v > 0 then
			return true
		end
		if type(v) == "table" then
			for i = 1, #v do
				local n = tonumber(v[i])
				if n and n > 0 then
					return true
				end
			end
		end
		return false
	end
	local hasLegacyCons = false
	if cons then
		for _, ck in ipairs({ "feast", "food", "flask", "potion", "healingPotion", "weaponOil", "rune" }) do
			if consumableEntryPresent(cons[ck]) then
				hasLegacyCons = true
				break
			end
		end
	end
	if wowheadCons or hasLegacyCons then
		addSectionHeader(scrollContent, ns:L("GUIDE_SECTION_CONSUMABLES_KIT"), fullW, nil, nil, th)
		local consHost = CreateFrame("Frame", nil, scrollContent)
		consHost:SetWidth(fullW)
		local ry = -4

		local hintFs = consHost:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		hintFs:SetPoint("TOPLEFT", consHost, "TOPLEFT", 8, ry)
		hintFs:SetWidth(fullW - 16)
		hintFs:SetJustifyH("LEFT")
		hintFs:SetWordWrap(true)
		hintFs:SetTextColor(0.78, 0.76, 0.7)
		hintFs:SetText(ns:L("GUIDE_CONSUMABLES_SIDEBAR_HINT"))
		ry = ry - (hintFs:GetStringHeight() or 18) - 8

		local openConsBtn = CreateFrame("Button", nil, consHost, "UIPanelButtonTemplate")
		openConsBtn:SetSize(168, 24)
		openConsBtn:SetPoint("TOPLEFT", consHost, "TOPLEFT", 8, ry)
		openConsBtn:SetText(ns:L("GUIDE_CONSUMABLES_OPEN_TAB"))
		openConsBtn:SetScript("OnClick", function()
			if guideIsPreviewView and ns.MH_SetConsumablesPreview then
				ns.MH_SetConsumablesPreview(classToken, specIdx)
			end
			if ns.ShowMainUI then
				ns:ShowMainUI()
			end
			if ns.SelectTab then
				ns.SelectTab("consumables")
			end
		end)
		ry = ry - 30

		if wowheadCons and ns.MH_BuildConsumablesIntoHost then
			local listHost = CreateFrame("Frame", nil, consHost)
			listHost:SetPoint("TOPLEFT", consHost, "TOPLEFT", 4, ry)
			local listH = ns.MH_BuildConsumablesIntoHost(listHost, classToken, specIdx, fullW - 12)
			if ns.MH_EnsureConsumablesItemListener then
				ns.MH_EnsureConsumablesItemListener(listHost)
			end
			ry = ry - (listH or 48) - 4
		elseif hasLegacyCons and cons then
		local order = {
			{ key = "feast", label = "Feast" },
			{ key = "food", label = "Solo food" },
			{ key = "flask", label = "Flask" },
			{ key = "potion", label = "Potion" },
			{ key = "healingPotion", label = ns:L("GUIDE_CONSUMABLE_LABEL_HEALING_POTION") },
			{ key = "weaponOil", label = ns:L("GUIDE_CONSUMABLE_LABEL_WEAPON_OIL") },
			{ key = "rune", label = "Augment Rune" },
		}
		local role = SpecOnboardingRoleNL(classToken, specIdx) or ""
		local roleFoodFallback = {
			["Ranged DPS"] = 242275,
			["Healer"] = 242275,
			["Support"] = 242275,
			["Melee DPS"] = 222710,
			["Tank"] = 222772,
		}
		local roleFlaskFallback = {
			["Ranged DPS"] = 241322,
			["Healer"] = 241322,
			["Support"] = 241322,
			["Melee DPS"] = 241324,
			["Tank"] = 241326,
		}
		local explicitFoodList = type(cons.food) == "table" and #cons.food > 0
		local explicitFlaskList = type(cons.flask) == "table" and #cons.flask > 0
		local function AddCandidate(candidates, seen, maybeID)
			local id = tonumber(maybeID)
			if id and id > 0 and not seen[id] then
				seen[id] = true
				candidates[#candidates + 1] = id
			end
		end
		local function AddDataCandidates(candidates, seen, value)
			if type(value) == "table" then
				for i = 1, #value do
					AddCandidate(candidates, seen, value[i])
				end
			else
				AddCandidate(candidates, seen, value)
			end
		end
		local usableRows = {}
		local earliestLockedLevel = nil
		for _, entry in ipairs(order) do
			local candidates = {}
			local seen = {}
			AddDataCandidates(candidates, seen, cons[entry.key])
			if entry.key == "food" and roleFoodFallback[role] and not explicitFoodList then
				AddCandidate(candidates, seen, roleFoodFallback[role])
			elseif entry.key == "flask" and roleFlaskFallback[role] and not explicitFlaskList then
				AddCandidate(candidates, seen, roleFlaskFallback[role])
			elseif entry.key == "potion" then
				AddCandidate(candidates, seen, 241308) -- Light's Potential (primary stat burst)
				AddCandidate(candidates, seen, 241289) -- Potion of Recklessness
				AddCandidate(candidates, seen, 191371) -- Withering Vitality (defensive fallback)
			elseif entry.key == "flask" then
				-- Leveling fallback (DF): Charged Phial of Alacrity (req lvl 61) when Midnight flasks are not usable yet.
				AddCandidate(candidates, seen, 191348)
			elseif entry.key == "feast" then
				AddCandidate(candidates, seen, 255845)
				AddCandidate(candidates, seen, 255846)
			elseif entry.key == "healingPotion" then
				AddCandidate(candidates, seen, 211878)
				AddCandidate(candidates, seen, 211880)
			elseif entry.key == "rune" then
				AddCandidate(candidates, seen, 259085)
			end
			local itemID, usableNow, reqLevel = ResolveBestConsumableForLevel(candidates)
			if type(itemID) == "number" and itemID > 0 and usableNow then
				usableRows[#usableRows + 1] = {
					label = entry.label,
					itemID = itemID,
				}
			elseif type(itemID) == "number" and itemID > 0 and (not usableNow) and reqLevel and reqLevel > 0 then
				if (not earliestLockedLevel) or reqLevel < earliestLockedLevel then
					earliestLockedLevel = reqLevel
				end
			end
		end

		local hasUsableRows = #usableRows > 0
		consHost._itemRows = {}
		local legacyRy = ry
		if hasUsableRows then
			for i = 1, #usableRows do
				local rowData = usableRows[i]
				local itemID = rowData.itemID
				local entryLabel = rowData.label or ""
				local row = CreateFrame("Frame", nil, consHost)
				row:SetSize(fullW - 8, CONS_ROW_HEIGHT)
				row:SetPoint("TOPLEFT", consHost, "TOPLEFT", 8, legacyRy)

				local labelFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
				labelFs:SetPoint("LEFT", row, "LEFT", 0, 0)
				labelFs:SetJustifyH("LEFT")
				labelFs:SetTextColor(1.0, 1.0, 0.6)
				labelFs:SetText(entryLabel .. ": ")

				local copyBtn = CreateFrame("Button", nil, row)
				copyBtn:SetSize(CONS_COPY_BTN, CONS_COPY_BTN)
				copyBtn:SetPoint("RIGHT", row, "RIGHT", -2, 0)
				local copyTex = copyBtn:CreateTexture(nil, "ARTWORK")
				copyTex:SetAllPoints()
				-- All icon setup in pcall: GetTexture/Atlas on atlas-based textures can error in some client builds.
				if not pcall(function()
					if copyTex.SetAtlas then
						copyTex:SetAtlas("transmog-icon-chat")
					end
					if not copyTex.GetTexture or not copyTex:GetTexture() or copyTex:GetTexture() == 0 then
						if copyTex.SetAtlas then
							copyTex:SetAtlas("Garr_SearchIcon")
						end
					end
					if not copyTex.GetTexture or not copyTex:GetTexture() or copyTex:GetTexture() == 0 then
						copyTex:SetTexture(134400)
					end
				end) then
					pcall(function()
						copyTex:SetTexture(134400)
					end)
				end
				copyBtn:SetFrameLevel(row:GetFrameLevel() + 3)
				local copyHi = copyBtn:CreateTexture(nil, "HIGHLIGHT")
				copyHi:SetAllPoints()
				copyHi:SetColorTexture(1, 1, 1, 0.12)

				local nameFs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
				nameFs:SetPoint("LEFT", labelFs, "RIGHT", 0, 0)
				nameFs:SetPoint("RIGHT", copyBtn, "LEFT", -6, 0)
				nameFs:SetJustifyH("LEFT")
				nameFs:SetWordWrap(false)
				nameFs:SetTextColor(0.90, 0.88, 0.80)
				local disp = GetConsumableItemDisplayName(itemID)
				nameFs:SetText(disp)

				local iid = itemID
				copyBtn:SetScript("OnClick", function()
					if _G.GameTooltip then
						_G.GameTooltip:Hide()
					end
					ShowConsumableNameCopyPopup(copyBtn, GetConsumableItemDisplayName(iid) or "", th)
				end)

				local itemHit = CreateFrame("Button", nil, row)
				itemHit:EnableMouse(true)
				itemHit:RegisterForClicks("LeftButtonUp", "RightButtonUp")
				itemHit:SetFrameLevel(row:GetFrameLevel() + 2)
				local w = nameFs:GetStringWidth() or 0
				if w < 8 then
					w = 100
				end
				-- Single anchor to FontString; dual corner anchors to FontStrings can error and abort Populate.
				itemHit:SetSize(w + 6, CONS_ROW_HEIGHT)
				itemHit:SetPoint("TOPLEFT", nameFs, "TOPLEFT", -2, 0)
				local hi = itemHit:CreateTexture(nil, "HIGHLIGHT")
				hi:SetAllPoints()
				hi:SetColorTexture(1, 1, 1, 0.08)
				itemHit:SetScript("OnEnter", function(self)
					ShowItemTooltipForConsumable(self, iid)
				end)
				itemHit:SetScript("OnLeave", function()
					if _G.GameTooltip then
						_G.GameTooltip:Hide()
					end
				end)
				itemHit:SetScript("OnClick", function(self)
					ShowItemTooltipForConsumable(self, iid)
				end)

				consHost._itemRows[#consHost._itemRows + 1] = { id = itemID, nameFs = nameFs, copyBtn = copyBtn, itemID = itemID, theme = th }

				legacyRy = legacyRy - CONS_ROW_HEIGHT - CONS_ROW_GAP
			end
			ry = legacyRy
		else
			local noUsableFs = consHost:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			noUsableFs:SetPoint("TOPLEFT", consHost, "TOPLEFT", 8, legacyRy)
			noUsableFs:SetPoint("TOPRIGHT", consHost, "TOPRIGHT", -8, -2)
			noUsableFs:SetJustifyH("LEFT")
			noUsableFs:SetWordWrap(true)
			noUsableFs:SetTextColor(0.92, 0.86, 0.76)
			local curLevel = UnitLevel and (UnitLevel("player") or 0) or 0
			local notice = ns:L("GUIDE_CONSUMABLES_NONE_USABLE")
			if earliestLockedLevel and earliestLockedLevel > 0 and curLevel < earliestLockedLevel then
				notice = notice .. "\n" .. ns:L("GUIDE_CONSUMABLES_NEXT_UNLOCK_FMT"):format(earliestLockedLevel)
			elseif curLevel >= 61 then
				notice = ns:L("GUIDE_CONSUMABLES_USE_SIDEBAR")
			end
			noUsableFs:SetText(notice)
			local noticeHeight = noUsableFs:GetStringHeight() or 28
			ry = legacyRy - (noticeHeight + 8)
		end
		consHost:RegisterEvent("GET_ITEM_INFO_RECEIVED")
		consHost:SetScript("OnEvent", function(self, _, itemID, success)
			if not itemID or not self._itemRows then
				return
			end
			if success == false then
				return
			end
			for i = 1, #self._itemRows do
				local r = self._itemRows[i]
				if r and r.id == itemID and r.nameFs then
					r.nameFs:SetText(GetConsumableItemDisplayName(itemID))
					if ScheduleGuidePopulate then
						ScheduleGuidePopulate()
					end
					return
				end
			end
			if ScheduleGuidePopulate then
				ScheduleGuidePopulate()
			end
		end)
		end

		consHost:SetHeight(math.max(8, math.abs(ry) - CONS_ROW_GAP))
		consHost:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 0, y)
		local ch = consHost:GetHeight() or 24
		nextY(ch + 12)
	end

	addSectionHeader(scrollContent, ns:L("GUIDE_SECTION_ICY_LINK"), fullW, nil, nil, th)

	local nextStepBox = CreateFrame("Frame", nil, scrollContent, "BackdropTemplate")
	if nextStepBox.SetBackdrop then
		nextStepBox:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		})
		local ib = th.icyBackdrop or DEFAULT_THEME.icyBackdrop
		local br = th.icyBorder or DEFAULT_THEME.icyBorder
		nextStepBox:SetBackdropColor(ib[1], ib[2], ib[3], ib[4])
		nextStepBox:SetBackdropBorderColor(br[1], br[2], br[3], br[4])
	end
	nextStepBox:SetSize(fullW - 8, 178)
	nextStepBox:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 4, y)

	local icyTitleFs = nextStepBox:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	icyTitleFs:SetPoint("TOPLEFT", nextStepBox, "TOPLEFT", 12, -10)
	icyTitleFs:SetPoint("TOPRIGHT", nextStepBox, "TOPRIGHT", -12, -10)
	icyTitleFs:SetJustifyH("LEFT")
	local itc = th.icyTitleColor or DEFAULT_THEME.icyTitleColor
	icyTitleFs:SetTextColor(itc[1], itc[2], itc[3])
	icyTitleFs:SetText(data.icyTitle or ns:L("GUIDE_ICY_FALLBACK_TITLE"))

	currentLink = data.link or ""
	local link = currentLink

	local icyLinkEdit = CreateFrame("EditBox", nil, nextStepBox)
	icyLinkEdit:SetAutoFocus(false)
	icyLinkEdit:SetMultiLine(false)
	icyLinkEdit:SetMaxLetters(512)
	icyLinkEdit:SetFontObject("GameFontHighlightSmall")
	icyLinkEdit:SetTextInsets(8, 8, 6, 6)
	icyLinkEdit:SetHeight(30)
	icyLinkEdit:SetPoint("BOTTOMLEFT", nextStepBox, "BOTTOMLEFT", 10, 10)
	icyLinkEdit:SetPoint("BOTTOMRIGHT", nextStepBox, "BOTTOMRIGHT", -10, 10)
	local ebBg = icyLinkEdit:CreateTexture(nil, "BACKGROUND")
	ebBg:SetAllPoints()
	local eb = th.ebBg or DEFAULT_THEME.ebBg
	ebBg:SetColorTexture(eb[1], eb[2], eb[3], eb[4])
	icyLinkEdit:SetTextColor(0.85, 0.95, 1.0)
	icyLinkEdit:SetText(link)
	icyLinkEdit:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	icyLinkEdit:SetScript("OnEditFocusGained", function(self)
		self:HighlightText()
	end)
	icyLinkEdit:SetScript("OnMouseUp", function(self)
		if not self:HasFocus() then
			self:SetFocus()
		end
		self:HighlightText()
	end)
	icyLinkEdit:SetScript("OnTextChanged", function(self, userInput)
		if userInput and link ~= "" then
			self:SetText(link)
		end
	end)

	local nextStepBodyFs = nextStepBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	nextStepBodyFs:SetPoint("TOPLEFT", icyTitleFs, "BOTTOMLEFT", 0, -8)
	nextStepBodyFs:SetPoint("BOTTOMRIGHT", icyLinkEdit, "TOPRIGHT", 0, 8)
	nextStepBodyFs:SetJustifyH("LEFT")
	nextStepBodyFs:SetSpacing(3)
	nextStepBodyFs:SetWordWrap(true)
	nextStepBodyFs:SetTextColor(0.93, 0.91, 0.84)
	nextStepBodyFs:SetText(ns:L("GUIDE_ICY_BODY"))

	nextY(178 + 12)

	local gearBar = addSectionHeader(scrollContent, ns:L("GUIDE_SECTION_GEAR"), fullW, 24, 14, th)
	local glossaryBtn = CreateFrame("Button", nil, gearBar, "UIPanelButtonTemplate")
	glossaryBtn:SetSize(58, 20)
	glossaryBtn:SetPoint("RIGHT", gearBar, "RIGHT", -6, 0)
	glossaryBtn:SetText(ns:L("GUIDE_STATS_GLOSSARY_BUTTON"))
	glossaryBtn:SetScript("OnEnter", function(self)
		ShowGuideStatsGlossaryTooltip(self)
	end)
	glossaryBtn:SetScript("OnLeave", function()
		if _G.GameTooltip then
			_G.GameTooltip:Hide()
		end
	end)
	glossaryBtn:SetScript("OnClick", function(self)
		ShowGuideStatsGlossaryTooltip(self)
	end)
	local gearHost = CreateFrame("Frame", nil, scrollContent)
	gearHost:SetWidth(fullW - 16)
	gearHost:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 8, y)
	local gearFs = gearHost:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	gearFs:SetPoint("TOPLEFT", gearHost, "TOPLEFT", 0, 0)
	gearFs:SetPoint("TOPRIGHT", gearHost, "TOPRIGHT", 0, 0)
	gearFs:SetJustifyH("LEFT")
	gearFs:SetSpacing(5)
	gearFs:SetWordWrap(true)
	gearFs:SetTextColor(0.90, 0.88, 0.80)
	gearFs:SetText(HighlightGuideStatTerms(BuildGuideGearText(classToken, specIdx, data)))
	local gearH = math.max(24, (gearFs:GetStringHeight() or 24) + 8)
	gearHost:SetHeight(gearH)
	nextY(gearH + 12)

	scrollContent:SetHeight(math.abs(y) + 20)
	if scroll and scrollContent then
		scroll:SetScrollChild(scrollContent)
		scrollContent:Show()
		if scrollContent.Raise then
			scrollContent:Raise()
		end
		if scroll.SetHorizontalScroll then
			scroll:SetHorizontalScroll(0)
		end
		if scroll.UpdateScrollChildRect then
			scroll:UpdateScrollChildRect()
		end
	end
	if scroll and scroll.SetVerticalScroll then
		scroll:SetVerticalScroll(0)
	end
	SyncGuideScrollBarState()

	local layoutPanel = ns._mhGuideLayoutPanel
	if layoutPanel and layoutPanel._mhProtoBuilt and ns.KeyboardLayoutPrototype_Refresh then
		ns.KeyboardLayoutPrototype_Refresh(layoutPanel)
	end
	if ns.MH_RefreshMacrosPanel then
		ns.MH_RefreshMacrosPanel()
	end
end

-- Populate after layout: ScrollFrame often reports height 0 during the same frame as Show/Create.
ScheduleGuidePopulate = function()
	if not C_Timer or not C_Timer.After then
		PopulateUniversalGuideContent()
		return
	end
	local attempts = 0
	local function try()
		attempts = attempts + 1
		if not scroll or not scrollContent or not guideRoot then
			return
		end
		-- Main window can become visible a frame later than panel:Show; retry instead of aborting once.
		if not guideRoot:IsVisible() then
			if attempts < 24 then
				C_Timer.After(0.05, try)
			end
			return
		end
		local h = scroll:GetHeight() or 0
		if h < 8 and attempts < 40 then
			C_Timer.After(0.05, try)
			return
		end
		PopulateUniversalGuideContent()
	end
	C_Timer.After(0, try)
end

--- Chat diagnostics: `/mh guide` (no valid `/run MidnightHelper` — that is not Lua).
function ns._mhGuidePrintLayout()
	print("|cffffcc00Midnight Helper|r — guide layout")
	if not guideRoot then
		print("  guideRoot: (nil — UI not built)")
		return
	end
	local vis = tostring(guideRoot:IsVisible())
	local shown = tostring(guideRoot:IsShown())
	local sw, sh = 0, 0
	local cur, max = 0, 0
	local cw, ch, children = 0, 0, 0
	if scroll then
		sw, sh = scroll:GetWidth() or 0, scroll:GetHeight() or 0
		cur = scroll:GetVerticalScroll() or 0
		max = scroll:GetVerticalScrollRange() or 0
	end
	if scrollContent then
		cw, ch = scrollContent:GetWidth() or 0, scrollContent:GetHeight() or 0
		children = #( { scrollContent:GetChildren() } )
	end
	print(string.format("  root: visible=%s shown=%s", vis, shown))
	print(string.format("  scroll: %.0fx%.0f  range %.1f/%.1f", sw, sh, cur, max))
	print(string.format("  content: %.0fx%.0f  children=%d", cw, ch, children))
end

function ns:_mhGuideRefresh()
	if guideRoot and guideRoot:IsVisible() then
		ScheduleGuidePopulate()
	end
end

function ns.SetupUniversalGuideModule()
	if ns._mhUniversalGuideUiBuilt then
		return
	end

	local panel = ns.panels and (ns.panels.guideBody or ns.panels.guide)
	if not panel then
		if ns.db and ns.db.ui and ns.db.ui.debug then
			print("|cffffcc00" .. ns:L("PRINT_PREFIX") .. "|r " .. ns:L("GUIDE_PANEL_MISSING"))
		end
		return
	end

	ns._mhUniversalGuideUiBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local root = CreateFrame("Frame", "MidnightHelperUniversalGuideFrame", panel)
	root:SetAllPoints(panel)
	root:SetFrameLevel((panel:GetFrameLevel() or 0) + 2)
	guideRoot = root

	tintTex = root:CreateTexture(nil, "BACKGROUND", nil, -6)
	tintTex:SetAllPoints()

	local margin = 10
	local marginTop = 6
	local topBar = CreateFrame("Frame", nil, root)
	topBar:SetHeight(36)
	topBar:SetPoint("TOPLEFT", root, "TOPLEFT", margin, -marginTop)
	topBar:SetPoint("TOPRIGHT", root, "TOPRIGHT", -margin, -marginTop)
	topBarTex = topBar:CreateTexture(nil, "BACKGROUND")
	topBarTex:SetAllPoints()
	guideTopBar = topBar

	specHeaderIcon = topBar:CreateTexture(nil, "OVERLAY", nil, 2)
	specHeaderIcon:SetSize(SPEC_HEADER_ICON_SIZE, SPEC_HEADER_ICON_SIZE)
	specHeaderIcon:SetPoint("LEFT", topBar, "LEFT", 8, 0)
	specHeaderIcon:Hide()

	titleFs = topBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titleFs:SetPoint("LEFT", topBar, "LEFT", 10, 0)
	titleFs:SetPoint("RIGHT", topBar, "RIGHT", -10, 0)
	titleFs:SetJustifyH("LEFT")

	-- Host + inset scroll: backdrop border must sit *around* the viewport. If the border shares the
	-- ScrollFrame rect, the frame is transparent and the edge shows through gaps (icons/rows) —
	-- looks like a "broken" vertical line through content.
	local scrollInset = 2
	local scrollBarGutter = 22
	local scrollHost = CreateFrame("Frame", "MidnightHelperGuideScrollHost", root)
	scrollHost:SetPoint("TOPLEFT", topBar, "BOTTOMLEFT", 0, -4)
	scrollHost:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -(margin + 30), margin)
	scrollHost:SetFrameStrata(root:GetFrameStrata())
	scrollHost:SetFrameLevel((root:GetFrameLevel() or 0) + 12)
	scrollHost:EnableMouse(false)

	-- Themed outer glow + thin rim (behind scroll); colors follow spec theme via syncGuideTopBarAndScrollBorder.
	local bd = {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		tile = true,
		tileSize = 8,
		edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	}
	guideThemeGlowOuter = CreateFrame("Frame", "MidnightHelperGuideThemeGlow", scrollHost, "BackdropTemplate")
	guideThemeGlowOuter:SetPoint("TOPLEFT", scrollHost, "TOPLEFT", -3, 3)
	guideThemeGlowOuter:SetPoint("BOTTOMRIGHT", scrollHost, "BOTTOMRIGHT", 3, -3)
	guideThemeGlowOuter:SetFrameStrata(scrollHost:GetFrameStrata())
	guideThemeGlowOuter:SetFrameLevel(scrollHost:GetFrameLevel())
	if guideThemeGlowOuter.SetBackdrop then
		local glowBd = {}
		for k, v in pairs(bd) do
			glowBd[k] = v
		end
		glowBd.edgeSize = 4
		guideThemeGlowOuter:SetBackdrop(glowBd)
		guideThemeGlowOuter:SetBackdropColor(0, 0, 0, 0)
		local tc = DEFAULT_THEME.titleColor
		guideThemeGlowOuter:SetBackdropBorderColor(tc[1], tc[2], tc[3], 0.1)
	end
	guideThemeGlowOuter:EnableMouse(false)

	guideContentBorder = CreateFrame("Frame", "MidnightHelperGuideThemeRim", scrollHost, "BackdropTemplate")
	guideContentBorder:SetAllPoints(scrollHost)
	guideContentBorder:SetFrameStrata(scrollHost:GetFrameStrata())
	guideContentBorder:SetFrameLevel(scrollHost:GetFrameLevel() + 1)
	if guideContentBorder.SetBackdrop then
		guideContentBorder:SetBackdrop(bd)
		guideContentBorder:SetBackdropColor(0, 0, 0, 0)
		local tc = DEFAULT_THEME.titleColor
		guideContentBorder:SetBackdropBorderColor(tc[1], tc[2], tc[3], 0.35)
	end
	guideContentBorder:EnableMouse(false)

	-- Plain ScrollFrame (no UIPanelScrollFrameTemplate): template layers can hide the scroll child on 12.x.
	scroll = CreateFrame("ScrollFrame", "MidnightHelperUniversalGuideScroll", scrollHost)
	scroll:SetPoint("TOPLEFT", scrollHost, "TOPLEFT", scrollInset, -scrollInset)
	scroll:SetPoint("BOTTOMRIGHT", scrollHost, "BOTTOMRIGHT", -scrollInset - scrollBarGutter, scrollInset)
	scroll:SetFrameStrata(scrollHost:GetFrameStrata())
	scroll:SetFrameLevel(scrollHost:GetFrameLevel() + 2)
	scroll:EnableMouse(true)
	scroll:EnableMouseWheel(true)
	local scrollFill = scroll:CreateTexture(nil, "BACKGROUND", nil, -8)
	scrollFill:SetAllPoints()
	scrollFill:SetColorTexture(0.04, 0.042, 0.055, 1)
	local scrollStep = (_G.WORLDWIDE_SCROLL_STEP and math.floor(_G.WORLDWIDE_SCROLL_STEP * 0.75)) or 30
	scroll:SetScript("OnMouseWheel", function(self, delta)
		local maxScroll = self:GetVerticalScrollRange() or 0
		if maxScroll <= 0 then
			return
		end
		local nextScroll = self:GetVerticalScroll() - (delta * scrollStep)
		if nextScroll < 0 then
			nextScroll = 0
		elseif nextScroll > maxScroll then
			nextScroll = maxScroll
		end
		self:SetVerticalScroll(nextScroll)
		SyncGuideScrollBarState()
	end)
	if scroll.SetHorizontalScroll then
		scroll:SetHorizontalScroll(0)
	end

	scrollContent = CreateFrame("Frame", "MidnightHelperUniversalGuideScrollContent", scroll)
	-- Do not ClearAllPoints/SetPoint here: ScrollFrame:SetScrollChild positions the child;
	-- manual anchors fight the engine and shift content horizontally (~one viewport width).
	scrollContent:SetFrameStrata(scroll:GetFrameStrata())
	scrollContent:SetFrameLevel(scroll:GetFrameLevel() + 1)
	scrollContent:SetWidth(1)
	scrollContent:SetHeight(1)
	scroll:SetScrollChild(scrollContent)
	scroll:SetScript("OnVerticalScroll", function(self, offset)
		SyncGuideScrollBarState()
	end)

	guideScrollBar = CreateFrame("Slider", nil, scrollHost)
	guideScrollBar:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 2, 0)
	guideScrollBar:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", 2, 0)
	guideScrollBar:SetWidth(16)
	guideScrollBar:SetOrientation("VERTICAL")
	guideScrollBar:SetFrameLevel(scrollHost:GetFrameLevel() + 4)
	local barBg = guideScrollBar:CreateTexture(nil, "BACKGROUND")
	barBg:SetAllPoints()
	barBg:SetColorTexture(0.07, 0.07, 0.09, 0.88)
	local thumb = guideScrollBar:CreateTexture(nil, "OVERLAY")
	thumb:SetSize(16, 28)
	thumb:SetColorTexture(0.72, 0.74, 0.78, 0.96)
	guideScrollBar:SetThumbTexture(thumb)
	guideScrollBar:SetScript("OnEnter", function()
		thumb:SetColorTexture(0.86, 0.88, 0.92, 1.0)
	end)
	guideScrollBar:SetScript("OnLeave", function()
		thumb:SetColorTexture(0.72, 0.74, 0.78, 0.96)
	end)
	guideScrollBar:SetMinMaxValues(0, 0)
	guideScrollBar:SetValue(0)
	guideScrollBar:SetValueStep(1)
	guideScrollBar:SetObeyStepOnDrag(false)
	guideScrollBar:SetScript("OnValueChanged", function(self, value)
		if syncingGuideScrollBar then
			return
		end
		if scroll and scroll.SetVerticalScroll then
			scroll:SetVerticalScroll(value or 0)
		end
		SyncGuideScrollBarState()
	end)

	guideScrollUpBtn = CreateFrame("Button", nil, scrollHost)
	guideScrollUpBtn:SetSize(20, 20)
	guideScrollUpBtn:SetPoint("BOTTOM", guideScrollBar, "TOP", 0, 4)
	guideScrollUpBtn:SetFrameLevel(scrollHost:GetFrameLevel() + 5)
	guideScrollUpBtn:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
	guideScrollUpBtn:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
	guideScrollUpBtn:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight")
	guideScrollUpBtn:SetScript("OnClick", function()
		if not scroll then
			return
		end
		local nextScroll = math.max(0, (scroll:GetVerticalScroll() or 0) - 40)
		scroll:SetVerticalScroll(nextScroll)
		SyncGuideScrollBarState()
	end)

	guideScrollDownBtn = CreateFrame("Button", nil, scrollHost)
	guideScrollDownBtn:SetSize(20, 20)
	guideScrollDownBtn:SetPoint("TOP", guideScrollBar, "BOTTOM", 0, -4)
	guideScrollDownBtn:SetFrameLevel(scrollHost:GetFrameLevel() + 5)
	guideScrollDownBtn:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
	guideScrollDownBtn:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
	guideScrollDownBtn:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight")
	guideScrollDownBtn:SetScript("OnClick", function()
		if not scroll then
			return
		end
		local maxScroll = scroll:GetVerticalScrollRange() or 0
		local nextScroll = math.min(maxScroll, (scroll:GetVerticalScroll() or 0) + 40)
		scroll:SetVerticalScroll(nextScroll)
		SyncGuideScrollBarState()
	end)

	root:SetScript("OnShow", function()
		if scrollContent and scroll then
			scrollContent:SetWidth(math.max(200, scroll:GetWidth() - 8))
		end
		ScheduleGuidePopulate()
	end)

	-- Do not call PopulateUniversalGuideContent() from here: changing scrollContent height during Populate
	-- can fire OnSizeChanged synchronously and re-enter Populate → ClearGuideUI() wipes half-built UI.
	scroll:SetScript("OnSizeChanged", function()
		if scrollContent and scroll then
			scrollContent:SetWidth(math.max(200, scroll:GetWidth() - 8))
		end
		SyncGuideScrollBarState()
	end)

	local evt = CreateFrame("Frame")
	evt:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	evt:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	evt:RegisterEvent("PLAYER_ENTERING_WORLD")
	evt:RegisterEvent("PLAYER_LEVEL_UP")
	evt:SetScript("OnEvent", function()
		if ns._mhUniversalGuideUiBuilt and guideRoot and guideRoot:IsVisible() then
			ScheduleGuidePopulate()
		end
	end)

	if scrollContent and scroll then
		scrollContent:SetWidth(math.max(200, scroll:GetWidth() - 8))
	end
	ScheduleGuidePopulate()
end

local function HookEnsureMainUI()
	if ns._mhGuideEnsureHooked then
		return
	end
	ns._mhGuideEnsureHooked = true

	local orig = ns.EnsureMainUI
	function ns:EnsureMainUI(...)
		local main = orig(self, ...)
		if ns.SetupUniversalGuideModule then
			ns.SetupUniversalGuideModule()
		end
		return main
	end
end

HookEnsureMainUI()
