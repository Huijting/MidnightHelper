--[[
	Layout sub-tab: ISO-style keyboard preview (NL/UK-like):
	L-shaped Enter spans Q + Caps only (no stub key on Q row); \| sits on the home row (before Enter),
	not beside Z. AltGr / RWin / Menu on the bottom; RShift aligns with RCtrl (no arrow island).
	Midnight-bound keys stay bright; other keys are dimmed.
	v6 modifier layers: a key with Shift/Ctrl/Alt binds shows a cyan "+N" badge; the tooltip lists
	every layer (base first, then Shift → Ctrl → Alt — see Modules/KeybindSchema.lua v6).
]]

local addonName, ns = ...

local KW, KH = 30, 26
local GAP = 5

local MODIFIER_KEYS = {
	Esc = true,
	Caps = true,
	--- LShift / LCtrl / LAlt: highlighted as team “preferred” keys (see PREFERRED_BAR_KEYS), not dimmed modifiers.
	RShift = true,
	RCtrl = true,
	RAlt = true,
	LWin = true,
	RWin = true,
	Menu = true,
	BkSp = true,
	Enter = true,
	[" "] = true,
}

--- Default WoW-style movement; always shown bright green in this preview.
local MOVEMENT_KEYS = {
	W = true,
	A = true,
	S = true,
	D = true,
}

--- Tab: team uses it to cycle targets quickly (cyan highlight).
local TARGET_KEYS = {
	Tab = true,
}

--- Extra function-row + modifier keys the Midnight team keeps free for spells / combos (same “lit” treatment as F1).
local PREFERRED_BAR_KEYS = {
	F2 = true,
	F3 = true,
	F4 = true,
	LShift = true,
	LCtrl = true,
	LAlt = true,
}

local COLOR_TEXT_SPELL = { 1, 0.88, 0.42 }
local COLOR_TEXT_MOVEMENT = { 0.2, 1, 0.38 }
local COLOR_TEXT_TARGET = { 0.35, 0.85, 1 }
local COLOR_TEXT_DIM = { 0.52, 0.5, 0.46 }

local function ProtoEnsureGlow(btn)
	if not btn or not btn.CreateTexture then
		return nil
	end
	if not btn._mhProtoGlow then
		local g = btn:CreateTexture(nil, "OVERLAY", nil, 7)
		g:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
		g:SetBlendMode("ADD")
		g:SetPoint("TOPLEFT", btn, "TOPLEFT", -5, 5)
		g:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 5, -5)
		g:Hide()
		btn._mhProtoGlow = g
	end
	return btn._mhProtoGlow
end

--- Small cyan "+N" in the key's top-right corner = N extra Shift/Ctrl/Alt binds on this key.
local function ProtoEnsureLayerBadge(btn)
	if not btn or not btn.CreateFontString then
		return nil
	end
	if not btn._mhProtoLayerBadge then
		local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		fs:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -2, -2)
		fs:SetTextColor(0.55, 0.85, 1)
		fs:Hide()
		btn._mhProtoLayerBadge = fs
	end
	return btn._mhProtoLayerBadge
end

local function ProtoCountModifierLayers(layers)
	local n = 0
	for i = 1, #(layers or {}) do
		local bk = layers[i] and layers[i].bindKey
		if bk and ns.Keybind_GetModifier and ns.Keybind_GetModifier(bk) then
			n = n + 1
		end
	end
	return n
end

function ns.KeyboardLayoutPrototype_SetHighlight(panel, uiKey)
	if panel then
		panel._mhProtoHighlightKey = uiKey
	end
	ns._mhLayoutHighlightKey = uiKey
end

function ns.MH_GuideOpenLayoutForKey(uiKey)
	if not uiKey or uiKey == "" then
		return false
	end
	if ns.EnsureMainUI then
		local main = ns:EnsureMainUI()
		if main and not main:IsShown() and ns.ToggleMainWindow then
			ns:ToggleMainWindow()
		end
	end
	if ns.SelectTab then
		ns.SelectTab("guide")
	end
	if ns._mhSelectGuideSubTab then
		ns._mhSelectGuideSubTab("layout")
	end
	local panel = ns._mhGuideLayoutPanel
	ns.KeyboardLayoutPrototype_SetHighlight(panel, uiKey)
	if panel then
		if ns.BuildKeyboardLayoutPrototypePanel then
			ns.BuildKeyboardLayoutPrototypePanel(panel)
		end
		if ns.KeyboardLayoutPrototype_Refresh then
			ns.KeyboardLayoutPrototype_Refresh(panel)
		end
		local scroll = _G.MidnightHelperKeyboardProtoScroll
		local btn = panel._mhProtoButtons and panel._mhProtoButtons[uiKey]
		if scroll and scroll.SetVerticalScroll and btn and btn._mhProtoLayoutY then
			local viewH = scroll:GetHeight() or 320
			local maxScroll = 0
			if scroll.GetVerticalScrollRange then
				maxScroll = scroll:GetVerticalScrollRange() or 0
			end
			local target = btn._mhProtoLayoutY - viewH * 0.35
			if target < 0 then
				target = 0
			end
			if target > maxScroll then
				target = maxScroll
			end
			scroll:SetVerticalScroll(target)
		end
	end
	return true
end

function ns.MH_GuideOpenLayoutForSpell(spellId)
	local slug = ns.MH_GetHunterKeybindSlugForUi and ns.MH_GetHunterKeybindSlugForUi()
	if not slug then
		return false
	end
	if ns.MH_Keybind_IsGuideSpellWithoutKeycap and ns.MH_Keybind_IsGuideSpellWithoutKeycap(spellId, slug) then
		return false
	end
	local layoutKey = ns.MH_Keybind_GetLayoutUiKeyForSpell and ns.MH_Keybind_GetLayoutUiKeyForSpell(spellId, slug)
	if not layoutKey then
		layoutKey = ns.MH_Keybind_GetUiKeyForSpell and ns.MH_Keybind_GetUiKeyForSpell(spellId, slug)
		if layoutKey and ns.Keybind_GetBaseUiKey then
			layoutKey = ns.Keybind_GetBaseUiKey(layoutKey) or layoutKey
		end
	end
	if not layoutKey then
		return false
	end
	return ns.MH_GuideOpenLayoutForKey(layoutKey)
end

local function ProtoResolveSlug()
	local slug = ns.MH_GetHunterKeybindSlugForUi and ns.MH_GetHunterKeybindSlugForUi()
	if slug then
		return slug
	end
	--- No Midnight map for this class/spec (yet). The old code had two traps here: a stale
	--- `db.guide.preview` in SavedVars blanked the board, and everything else silently fell
	--- back to the Hunter starter map (wrong binds on e.g. an Elemental Shaman). Now: nil →
	--- Refresh shows the board dimmed + an honest "no map yet" hint under the subtitle.
	return nil
end

--- ⚠️ Same rule as KeybindAutoMap's NameForId: the layout must print the name that is
--- on the player's bar, not the one in our table. A talent that replaces a spell
--- replaces its name too — Ice Block reads as Ice Cold, Blink as Shimmer, Invisibility
--- as Greater Invisibility. We hold base ids on purpose (matching needs them); only
--- the displayed name follows the override.
local function ProtoSpellName(spellId)
	local sid = tonumber(spellId)
	if not sid or sid < 1 or not C_Spell or not C_Spell.GetSpellInfo then
		return nil
	end
	local display = sid
	if C_SpellBook and C_SpellBook.FindSpellOverrideByID then
		local okO, over = pcall(C_SpellBook.FindSpellOverrideByID, sid)
		if okO and type(over) == "number" and over ~= 0 then
			display = over
		end
	end
	local ok, si = pcall(C_Spell.GetSpellInfo, display)
	if ok and si and si.name and si.name ~= "" then
		return si.name
	end
	if display ~= sid then
		local okB, sb = pcall(C_Spell.GetSpellInfo, sid)
		if okB and sb and sb.name and sb.name ~= "" then
			return sb.name
		end
	end
	return nil
end

local function ProtoTooltipForKey(uiKey, slot, spec)
	if not spec or not spec.spellByUiKey then
		return ns:L("LAYOUT_KEY_EMPTY_TOOLTIP")
	end
	local layers = ns.Keybind_GetBindingsOnBase and ns.Keybind_GetBindingsOnBase(spec, uiKey) or {}
	if #layers == 0 then
		local sp = spec.spellByUiKey[uiKey]
		if sp and sp.id then
			layers = { { bindKey = uiKey, entry = sp } }
		end
	end
	if #layers == 0 then
		return ns:L("LAYOUT_KEY_EMPTY_TOOLTIP")
	end
	local lines = {}
	if slot and slot.categoryLocaleKey then
		local cat = ns:L(slot.categoryLocaleKey)
		if cat ~= "" then
			lines[#lines + 1] = ns:L("LAYOUT_KEY_ROLE_TOOLTIP_FMT"):format(cat)
		end
	end
	for i = 1, #layers do
		local layer = layers[i]
		local entry = layer.entry
		local cap = ns.Keybind_FormatKeycap and ns.Keybind_FormatKeycap(layer.bindKey) or layer.bindKey
		--- Toon de SPELL-naam; val alleen terug op het rol-label als de naam niet resolvet
		--- (auto-map-entries hebben een role, maar we willen "Voidform", niet "cooldown bar").
		local name = entry and ProtoSpellName(entry.id)
		if not name and entry and entry.role and ns.Keybind_GetRoleLocaleKey then
			local rk = ns.Keybind_GetRoleLocaleKey(entry.role)
			if rk and rk ~= "" then
				local roleLabel = ns:L(rk)
				if roleLabel ~= "" then
					name = roleLabel
				end
			end
		end
		if name then
			lines[#lines + 1] = ns:L("LAYOUT_KEY_BIND_LAYER_FMT"):format(cap, name)
		end
	end
	if #lines == 0 then
		return ns:L("LAYOUT_KEY_EMPTY_TOOLTIP")
	end
	return table.concat(lines, "\n")
end

--- Build pixel positions: ISO block (Enter spans Q+Caps only), RShift flush with RCtrl.
--- Esc+F-row centered on main block width.
local function BuildKeyPositions()
	local P = {}
	local CELL = KW + GAP
	local M = 10
	local yF = 6
	local yTopMain = yF + KH + 14
	local yNum = yTopMain
	local yQ = yNum + KH + GAP
	local yA = yQ + KH + GAP
	local yZ = yA + KH + GAP
	local yBot = yZ + KH + GAP + 6

	local function bumpMainRight(xm, xy)
		local w = (type(xy[3]) == "number" and xy[3]) or KW
		return math.max(xm, xy[1] + w)
	end

	-- Number row
	local y = yNum
	local x = M
	local numRow = { "`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=" }
	for i = 1, #numRow do
		P[numRow[i]] = { x, y }
		x = x + CELL
	end
	local bkW = CELL * 2
	P["BkSp"] = { x + GAP, y, bkW }
	local numBlockRight = x + GAP + bkW

	local tabW = CELL * 1.52
	local capsW = tabW

	-- Q row: Tab, Q…P, [, ] — Enter column only below (no stub key on Q row)
	P["Tab"] = { M, yQ, tabW }
	local xq = M + tabW + GAP
	local qRow = { "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]" }
	for i = 1, #qRow do
		P[qRow[i]] = { xq + (i - 1) * CELL, yQ }
	end
	local enterX = xq + #qRow * CELL + GAP
	local enterW = CELL * 1.22
	local enterH = 2 * KH + GAP
	P["Enter"] = { enterX, yQ, enterW, enterH }

	-- Caps row
	P["Caps"] = { M, yA, capsW }
	local xa = M + capsW + GAP
	local aRow = { "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "\\" }
	for i = 1, #aRow do
		P[aRow[i]] = { xa + (i - 1) * CELL, yA }
	end

	-- Bottom row first (defines right edge for RShift alignment)
	y = yBot
	local lcW = CELL * 1.12
	local lwW = CELL * 1.04
	local laW = CELL * 1.04
	local spW = CELL * 5.95
	local raW = CELL * 1.14
	local rwW = CELL * 1.04
	local menuW = CELL * 1.02
	local rcW = CELL * 1.12
	x = M
	P["LCtrl"] = { x, y, lcW }
	x = x + lcW + GAP
	P["LWin"] = { x, y, lwW }
	x = x + lwW + GAP
	P["LAlt"] = { x, y, laW }
	x = x + laW + GAP
	P[" "] = { x, y, spW }
	x = x + spW + GAP
	P["RAlt"] = { x, y, raW }
	x = x + raW + GAP
	P["RWin"] = { x, y, rwW }
	x = x + rwW + GAP
	P["Menu"] = { x, y, menuW }
	x = x + menuW + GAP
	P["RCtrl"] = { x, y, rcW }
	local botRight = x + rcW

	-- Shift row: LShift then Z…/ (no \| here — backslash is on the home row); Z aligns under A
	local lsW = capsW
	P["LShift"] = { M, yZ, lsW }
	local zStart = M + lsW + GAP
	local zRow = { "Z", "X", "C", "V", "B", "N", "M", ",", ".", "/" }
	for i = 1, #zRow do
		P[zRow[i]] = { zStart + (i - 1) * CELL, yZ }
	end
	local rShiftLeft = zStart + #zRow * CELL + GAP
	local rsW = botRight - rShiftLeft
	P["RShift"] = { rShiftLeft, yZ, rsW }

	local mainRight = M
	for k, xy in pairs(P) do
		if k ~= "Enter" then
			mainRight = bumpMainRight(mainRight, xy)
		end
	end
	mainRight = bumpMainRight(mainRight, P["Enter"])

	local escW = CELL * 1.05
	local fStripW = 12 * CELL - GAP
	local topStripW = escW + GAP + fStripW
	local topStart = M + (mainRight - M - topStripW) / 2
	if topStart < M then
		topStart = M
	end
	P["Esc"] = { topStart, yF, escW }
	local f0 = topStart + escW + GAP
	for i = 1, 12 do
		P["F" .. i] = { f0 + (i - 1) * CELL, yF }
	end

	--- The thumb pad, to the right of the board.
	---
	--- ⚠️ ADDED 6 Aug, closing a hole this addon made for itself the same evening. The
	--- allocator started handing out mouse buttons an hour earlier — on Rob's Frost Mage
	--- that is Remove Curse and Spellsteal — and this picture could not draw them. Not
	--- "shown as empty": absent. Two of his nineteen bindings existed only in a chat
	--- dump. A layout view that silently omits part of the layout is worse than none.
	---
	--- ⚠️ ONE COLUMN, not two. The first attempt laid it out 2 across by 3 down, like the
	--- pad itself. It rendered as M4, M6, M8 — the right-hand column fell off the edge of
	--- the panel, so half the thumb buttons were invisible again, which is the very thing
	--- adding them was meant to fix. The panel does not scroll sideways, so anything past
	--- its width simply is not there.
	---
	--- A single column of six is 186px tall, which fits inside the board's own height,
	--- and needs one key's width beside the number block. Players with two buttons see
	--- two: the refresh hides any beyond `mouseButtonCount` rather than drawing keys
	--- nobody has.
	do
		local padX = math.max(numBlockRight, mainRight) + GAP
		local padY = yQ
		for i = 1, 6 do
			P["BUTTON" .. (i + 3)] = { padX, padY + (i - 1) * (KH + GAP) }
		end
	end

	local maxX, maxY = 0, 0
	for _, xy in pairs(P) do
		local w = (type(xy[3]) == "number" and xy[3]) or KW
		local h = (type(xy[4]) == "number" and xy[4]) or KH
		maxX = math.max(maxX, xy[1] + w)
		maxY = math.max(maxY, xy[2] + h)
	end

	maxX = math.max(maxX, numBlockRight, topStart + topStripW)
	--- Room for the beginner legend under the board (still inside the scroll child).
	--- Generous on purpose: the exact height is computed further down from the number
	--- of lines the active locale actually has, and this only has to not clip it.
	local LEGEND_AREA_H = 96
	maxY = maxY + LEGEND_AREA_H
	return P, maxX + M + 10, maxY + M + 12
end

local KEY_POS, HOST_W, HOST_H = BuildKeyPositions()

-- ===================== Spell-strook (Plan B): categorie-kaarten =====================
-- Onderrand van het toetsenbord + startpunt van de kaarten (onder de legenda).
local KB_BOTTOM = 0
for _, xy in pairs(KEY_POS) do
	local h = (type(xy[4]) == "number" and xy[4]) or KH
	KB_BOTTOM = math.max(KB_BOTTOM, xy[2] + h)
end
--- How tall the legend actually is, rather than how tall it used to be.
---
--- ⚠️ These were fixed numbers (76 and 106) sized for a five-line legend. Adding the
--- M4-M9 line made it six, and the last line disappeared behind the filter chips —
--- Rob spotted it within a minute of the reload. A constant that has to be updated
--- whenever a translator adds a line is a trap, so it is counted instead: every "\n"
--- in the string is a line, and the chips and cards sit below whatever that comes to.
--- The other five languages differ in length and now get the same treatment for free.
local LEGEND_LINE_H = 13
local function LegendLineCount()
	local s = (ns.L and ns:L("LAYOUT_LEGEND")) or ""
	local n = 1
	for _ in s:gmatch("\n") do
		n = n + 1
	end
	return n
end
local LEGEND_H = 8 + LegendLineCount() * LEGEND_LINE_H + 10
local CHIPS_Y = KB_BOTTOM + LEGEND_H       -- filter-chips onder de legenda
local CARDS_TOP = CHIPS_Y + 30             -- kaarten onder de chips

--- Filter-chips (mockup B): Alles / Alleen modifier-laag / Alleen ankers.
local FILTER_CHIPS = {
	{ id = "all",    labelKey = "LAYOUT_FILTER_ALL" },
	{ id = "mod",    labelKey = "LAYOUT_FILTER_MOD" },
	{ id = "anchor", labelKey = "LAYOUT_FILTER_ANCHOR" },
	{ id = "extras", labelKey = "LAYOUT_FILTER_EXTRAS" },
}

--- v6-anker-toetsen (vaste rol, muscle-memory): interrupt/movement/defensives/cooldown/heals.
local ANCHOR_KEYS = { E = true, Q = true, Z = true, C = true, V = true, F1 = true, F2 = true, F3 = true, F4 = true }

local function PassesCardFilter(filter, base, mod)
	if filter == "extras" then
		return false
	end
	if filter == "mod" then
		return mod ~= nil
	end
	if filter == "anchor" then
		return (base and ANCHOR_KEYS[base] and not mod) and true or false
	end
	return true
end

--- Kaart-groepen in weergavevolgorde (mockup B).
local CARD_GROUPS = {
	{ id = "builder",   labelKey = "LAYOUT_CARD_BUILDER" },
	{ id = "spender",   labelKey = "LAYOUT_CARD_SPENDER" },
	{ id = "aoe",       labelKey = "LAYOUT_CARD_AOE" },
	{ id = "raidheal",  labelKey = "LAYOUT_CARD_RAIDHEAL" },
	{ id = "interrupt", labelKey = "LAYOUT_CARD_INTERRUPT" },
	{ id = "movement",  labelKey = "LAYOUT_CARD_MOVEMENT" },
	{ id = "utility",   labelKey = "LAYOUT_CARD_UTILITY" },
	{ id = "defensive", labelKey = "LAYOUT_CARD_DEFENSIVE" },
	{ id = "taunt",     labelKey = "LAYOUT_CARD_TAUNT" },
	{ id = "cc",        labelKey = "LAYOUT_CARD_CC" },
	{ id = "cooldowns", labelKey = "LAYOUT_CARD_COOLDOWNS" },
	{ id = "selfheal",  labelKey = "LAYOUT_CARD_SELFHEAL" },
}

--- Categorie-token per base-toets: auto-map heeft role/category op de entry; hand-map niet,
--- daar leiden we het af uit het slot (maps_to_column -> ColumnToCategory).
local function CategoryTokenForBase(slots, baseKey)
	if type(slots) == "table" then
		for i = 1, #slots do
			local s = slots[i]
			if s and s.ui_key == baseKey and s.maps_to_column and ns.Keybind_ColumnToCategory then
				return ns.Keybind_ColumnToCategory(s.maps_to_column)
			end
		end
	end
	return nil
end

--- Bind -> kaart-groep-id. Ankers E (interrupt) en Q (movement) altijd vast; AoE = Shift-laag
--- van een builder/spender.
local function GroupForBind(entry, baseKey, mod, catToken)
	if baseKey == "E" then return "interrupt" end
	if baseKey == "Q" then return "movement" end
	local role = entry and entry.role
	if role == "interrupt" then return "interrupt" end
	if role == "utility_primary" or role == "mobility" then return "movement" end
	if role == "cooldown_bar" then return "cooldowns" end
	if role == "heal_quick" or role == "heal_ooc" or role == "heal_sustain" then return "selfheal" end
	if type(role) == "string" and role:find("^defensive") then return "defensive" end
	local cat = (entry and entry.category) or catToken
	if cat == "taunt" then return "taunt" end
	if cat == "raid_heal" then return "raidheal" end
	if cat == "main_rotation" then return (mod == "shift") and "aoe" or "builder" end
	if cat == "spender" then return (mod == "shift") and "aoe" or "spender" end
	if cat == "dispel_cc" then return "cc" end
	if cat == "cooldown" then return "cooldowns" end
	if cat == "defensive" then return "defensive" end
	if cat == "selfheal" then return "selfheal" end
	return "utility"
end

local function ProtoReleaseCards(panel)
	if panel._mhCards then
		for i = 1, #panel._mhCards do
			panel._mhCards[i]:Hide()
		end
	end
	panel._mhCardCount = 0
end

local MOD_TO_KEY = { shift = "LShift", ctrl = "LCtrl", alt = "LAlt" }

--- Trekt verbindingslijn #idx van een toets (btn) naar een spell-rij (row). Herbruikbare Lines op
--- de host (idx 1 = base-toets, goud; idx 2 = modifier-toets bij Shift/Ctrl/Alt-bind, cyaan).
local function ProtoDrawConnector(panel, row, btn, idx)
	local host = panel._mhProtoHost
	if not host then
		return
	end
	panel._mhConnectors = panel._mhConnectors or {}
	local line = panel._mhConnectors[idx]
	if not line then
		line = host:CreateLine(nil, "OVERLAY")
		line:SetThickness(2.5)
		panel._mhConnectors[idx] = line
	end
	if idx == 2 then
		line:SetColorTexture(0.4, 0.8, 1, 0.95)
	else
		line:SetColorTexture(1, 0.82, 0.3, 0.95)
	end
	line:ClearAllPoints()
	line:SetStartPoint("BOTTOM", btn, 0, -1)
	line:SetEndPoint("LEFT", row, -1, 0)
	line:Show()
end

local function ProtoCardRow(card, i)
	card._rows = card._rows or {}
	local row = card._rows[i]
	if not row then
		row = CreateFrame("Frame", nil, card)
		row:EnableMouse(true)
		row:SetScript("OnEnter", function(self)
			if GameTooltip and (self._spellId or self._itemId) then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				if self._itemId then
					GameTooltip:SetItemByID(self._itemId)
				else
					GameTooltip:SetSpellByID(self._spellId)
				end
				GameTooltip:Show()
			end
			-- Hover -> gloed op de fysieke toets + verbindingslijn (single-target-heals via
			-- mouseover hebben geen toets). Bij een Shift/Ctrl/Alt-bind een 2e lijn naar de modifier.
			local panel = self._panel
			if panel and self._targetKey and panel._mhProtoButtons then
				local btns = panel._mhProtoButtons
				panel._mhHoverBtns = {}
				local btn = btns[self._targetKey]
				if btn then
					local glow = ProtoEnsureGlow(btn)
					if glow then
						glow:SetVertexColor(1, 0.85, 0.3, 1)
						glow:Show()
					end
					btn:SetAlpha(1)
					panel._mhHoverBtns[#panel._mhHoverBtns + 1] = btn
					ProtoDrawConnector(panel, self, btn, 1)
				end
				local modKey = self._targetMod and MOD_TO_KEY[self._targetMod]
				local mbtn = modKey and btns[modKey]
				if mbtn then
					local glow = ProtoEnsureGlow(mbtn)
					if glow then
						glow:SetVertexColor(0.4, 0.8, 1, 1)
						glow:Show()
					end
					mbtn:SetAlpha(1)
					panel._mhHoverBtns[#panel._mhHoverBtns + 1] = mbtn
					ProtoDrawConnector(panel, self, mbtn, 2)
				end
			end
		end)
		row:SetScript("OnLeave", function(self)
			if GameTooltip then
				GameTooltip:Hide()
			end
			local panel = self._panel
			if panel then
				if panel._mhHoverBtns then
					for _, b in ipairs(panel._mhHoverBtns) do
						if b._mhProtoGlow then
							b._mhProtoGlow:Hide()
						end
					end
					panel._mhHoverBtns = nil
				end
				if panel._mhConnectors then
					for _, l in ipairs(panel._mhConnectors) do
						l:Hide()
					end
				end
			end
		end)
		local icon = row:CreateTexture(nil, "ARTWORK")
		icon:SetPoint("LEFT", row, "LEFT", 2, 0)
		icon:SetSize(22, 22)
		icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		row._icon = icon
		local cap = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		cap:SetPoint("RIGHT", row, "RIGHT", -2, 0)
		cap:SetJustifyH("RIGHT")
		row._cap = cap
		-- Spec 08 stop-tag ("(silence)"/"(stun)") gets its OWN FontString between the name
		-- and the key. Appending it to the name made a long name eat it: "Hammer of
		-- Justice (stun)" truncated to "Hammer of Justice…" and the reason — the whole point
		-- of the cross-listing — vanished (Rob 16 jul). Now the name truncates on its own
		-- and the tag always reads. Empty string = zero width, so untagged rows look the same.
		local stopTag = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		stopTag:SetPoint("RIGHT", cap, "LEFT", -6, 0)
		stopTag:SetJustifyH("RIGHT")
		stopTag:SetWordWrap(false)
		row._stopTag = stopTag
		local name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		name:SetPoint("LEFT", icon, "RIGHT", 6, 0)
		name:SetPoint("RIGHT", stopTag, "LEFT", -4, 0)
		name:SetJustifyH("LEFT")
		name:SetWordWrap(false)
		row._name = name
		card._rows[i] = row
	end
	return row
end

local function ProtoAcquireCard(panel)
	panel._mhCards = panel._mhCards or {}
	panel._mhCardCount = (panel._mhCardCount or 0) + 1
	local idx = panel._mhCardCount
	local card = panel._mhCards[idx]
	if not card then
		card = CreateFrame("Frame", nil, panel._mhProtoHost, "BackdropTemplate")
		if card.SetBackdrop then
			card:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8X8",
				edgeFile = "Interface\\Buttons\\WHITE8X8",
				edgeSize = 1,
				insets = { left = 1, right = 1, top = 1, bottom = 1 },
			})
			card:SetBackdropColor(0.12, 0.09, 0.06, 0.92)
			card:SetBackdropBorderColor(0.42, 0.29, 0.11, 1)
		end
		local t = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		t:SetPoint("TOP", card, "TOP", 0, -5)
		t:SetTextColor(1, 0.82, 0.3)
		card._title = t
		card._rows = {}
		-- Hover de kaart (buiten een spell-rij) -> één-regel-uitleg van de categorie-kop
		-- (F4.5: "Builder/Spender/AoE/..." is dev-jargon voor een nieuweling). De spell-rijen
		-- houden hun eigen spell-tooltip; die liggen als children bovenop en winnen.
		card:EnableMouse(true)
		card:SetScript("OnEnter", function(self)
			if not self._tipKey then
				return
			end
			local tip = ns:L(self._tipKey)
			if not tip or tip == "" or tip == self._tipKey then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			-- NB: GameTooltip:SetText's 5th arg is alpha (a number), NOT a wrap flag —
			-- passing a boolean errors. The title is short, so no wrap needed anyway.
			GameTooltip:SetText(self._title and self._title:GetText() or "", 1, 0.82, 0.3)
			GameTooltip:AddLine(tip, 0.9, 0.9, 0.9, true) -- AddLine's 5th arg IS wrapText
			GameTooltip:Show()
		end)
		card:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		panel._mhCards[idx] = card
	end
	-- Reset: verberg alle bestaande rijen van een hergebruikte kaart. Anders blijven stale rijen
	-- van een vorige (grotere) kaart zichtbaar en overlappen ze de volgende kaart.
	if card._rows then
		for i = 1, #card._rows do
			card._rows[i]:Hide()
		end
	end
	card._tipKey = nil -- hergebruikte kaart: geen stale tooltip van een vorige categorie
	return card
end

--- Bouwt de categorie-kaarten onder het toetsenbord uit de huidige map (hand-map of auto-map).
local function ProtoUpdateChipVisuals(panel)
	if not panel._mhChips then
		return
	end
	local active = panel._mhCardFilter or "all"
	for i = 1, #panel._mhChips do
		local chip = panel._mhChips[i]
		if chip._id == active then
			if chip.SetBackdropColor then
				chip:SetBackdropColor(0.9, 0.7, 0.15, 0.95)
			end
			chip._text:SetTextColor(0.1, 0.08, 0.03)
		else
			if chip.SetBackdropColor then
				chip:SetBackdropColor(0.14, 0.1, 0.07, 0.9)
			end
			chip._text:SetTextColor(0.72, 0.64, 0.5)
		end
	end
end

--- Filter-chips onder de legenda (Alles / Alleen modifier-laag / Alleen ankers).
local function ProtoBuildFilterChips(panel)
	if panel._mhChips or not panel._mhProtoHost then
		return
	end
	local host = panel._mhProtoHost
	panel._mhChips = {}
	local x = 10
	for _, def in ipairs(FILTER_CHIPS) do
		local chip = CreateFrame("Button", nil, host, "BackdropTemplate")
		chip:SetHeight(22)
		if chip.SetBackdrop then
			chip:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8X8",
				edgeFile = "Interface\\Buttons\\WHITE8X8",
				edgeSize = 1,
			})
			chip:SetBackdropBorderColor(0.42, 0.29, 0.11, 1)
		end
		local t = chip:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		t:SetPoint("CENTER")
		t:SetText(ns:L(def.labelKey))
		chip._text = t
		chip._id = def.id
		local w = t:GetStringWidth()
		if not w or w < 10 then
			w = 40
		end
		chip:SetWidth(w + 22)
		chip:SetPoint("TOPLEFT", host, "TOPLEFT", x, -CHIPS_Y)
		chip:SetScript("OnClick", function()
			panel._mhCardFilter = def.id
			ProtoUpdateChipVisuals(panel)
			if ns.KeyboardLayoutPrototype_Refresh then
				ns.KeyboardLayoutPrototype_Refresh(panel)
			end
		end)
		panel._mhChips[#panel._mhChips + 1] = chip
		x = x + chip:GetWidth() + 8
	end
	ProtoUpdateChipVisuals(panel)
end

local EXTRA_READY = "|TInterface/RAIDFRAME/ReadyCheck-Ready:0|t"
local EXTRA_NOTREADY = "|TInterface/RAIDFRAME/ReadyCheck-NotReady:0|t"
local EXTRA_WAITING = "|TInterface/RAIDFRAME/ReadyCheck-Waiting:0|t"

--- Eén cel in de extras-balk: icoon + naam + tag + ✓/✗-status + hover-tooltip. Bewust
--- NIET klikbaar: een secure knop in dit dynamische in-paneel-grid propageert "protected"
--- omhoog naar het hele venster (venster niet meer sluitbaar in combat) óf vergt fragiele
--- absolute-coördinaat-plaatsing. Klikken-om-te-gebruiken zit op het Consumable Board.
local function ProtoExtraCell(card, i)
	card._cells = card._cells or {}
	local cell = card._cells[i]
	if cell then
		return cell
	end
	cell = CreateFrame("Frame", nil, card)
	cell:EnableMouse(true)
	local hl = cell:CreateTexture(nil, "BACKGROUND")
	hl:SetAllPoints(cell)
	hl:SetColorTexture(1, 0.82, 0.3, 0.10)
	hl:Hide()
	cell._hl = hl
	local icon = cell:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("LEFT", cell, "LEFT", 2, 0)
	icon:SetSize(22, 22)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	cell._icon = icon
	local tag = cell:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	tag:SetPoint("RIGHT", cell, "RIGHT", -2, 0)
	tag:SetJustifyH("RIGHT")
	cell._tag = tag
	local nm = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	nm:SetPoint("LEFT", icon, "RIGHT", 6, 0)
	nm:SetPoint("RIGHT", tag, "LEFT", -6, 0)
	nm:SetJustifyH("LEFT")
	nm:SetWordWrap(false)
	cell._name = nm
	cell:SetScript("OnEnter", function(self)
		if self._itemId and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetItemByID(self._itemId)
			GameTooltip:Show()
		end
		if self._hl then
			self._hl:Show()
		end
	end)
	cell:SetScript("OnLeave", function(self)
		if GameTooltip then
			GameTooltip:Hide()
		end
		if self._hl then
			self._hl:Hide()
		end
	end)
	card._cells[i] = cell
	return cell
end

--- Volle-breedte "Consumables & extras"-balk onderaan de kaarten: icoon + naam + tag +
--- ✓/✗-status (uit de bestaande consumables-detectie) + hover-tooltip. @return hoogte
local function ProtoRenderExtrasBar(panel, host, extras, pad, usableW, topOffset, titleH, rowH)
	local card = panel._mhExtrasCard
	if not card then
		card = CreateFrame("Frame", nil, host, "BackdropTemplate")
		if card.SetBackdrop then
			card:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8X8",
				edgeFile = "Interface\\Buttons\\WHITE8X8",
				edgeSize = 1,
				insets = { left = 1, right = 1, top = 1, bottom = 1 },
			})
			card:SetBackdropColor(0.12, 0.09, 0.06, 0.92)
			card:SetBackdropBorderColor(0.42, 0.29, 0.11, 1)
		end
		local t = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		t:SetPoint("TOP", card, "TOP", 0, -5)
		t:SetTextColor(1, 0.82, 0.3)
		card._title = t
		panel._mhExtrasCard = card
	end
	card._title:SetText(ns:L("LAYOUT_CARD_EXTRAS"))

	local COLS = 3
	local GAPX = 10
	-- Binnenmarge (pad) aan beide zijden meerekenen, anders loopt de rechterkolom
	-- (incl. de tag rechts) buiten het kader.
	local cellW = math.floor((usableW - 2 * pad - (COLS - 1) * GAPX) / COLS)
	local n = #extras
	local rows = math.ceil(n / COLS)
	local cardH = titleH + rows * rowH + 10
	card:ClearAllPoints()
	card:SetPoint("TOPLEFT", host, "TOPLEFT", pad, -topOffset)
	card:SetSize(usableW, cardH)
	card:Show()

	for i = 1, n do
		local sp = extras[i]
		local r = math.floor((i - 1) / COLS)
		local c = (i - 1) % COLS
		local cell = ProtoExtraCell(card, i)
		cell:ClearAllPoints()
		cell:SetPoint("TOPLEFT", card, "TOPLEFT", pad + c * (cellW + GAPX), -(titleH + r * rowH))
		cell:SetSize(cellW, rowH - 4)
		cell._icon:SetTexture(sp.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
		local mark = EXTRA_WAITING
		if sp.status == "active" or sp.status == "ready" then
			mark = EXTRA_READY
		elseif sp.status == "missing" then
			mark = EXTRA_NOTREADY
		end
		cell._name:SetText(mark .. " " .. (sp.name or "?"))
		cell._tag:SetText(ns:L(sp.tagKey))
		cell._tag:SetTextColor(0.72, 0.6, 0.4)
		cell._itemId = sp.itemID
		cell:Show()
	end
	if card._cells then
		for i = n + 1, #card._cells do
			card._cells[i]:Hide()
		end
	end
	panel._mhExtrasCardH = cardH
	return cardH
end

local function ProtoRefreshCards(panel, spec, slots)
	ProtoReleaseCards(panel)
	local host = panel._mhProtoHost
	if not host then
		return HOST_H
	end

	local filter = panel._mhCardFilter or "all"
	local groups = {}
	if spec and spec.spellByUiKey then
		for bindKey, entry in pairs(spec.spellByUiKey) do
			if type(entry) == "table" and entry.id then
				local mod, base = ns.Keybind_ParseBindKey(bindKey)
				if PassesCardFilter(filter, base, mod) then
					local catToken = CategoryTokenForBase(slots, base)
					local gid = GroupForBind(entry, base, mod, catToken)
					groups[gid] = groups[gid] or {}
					table.insert(groups[gid], {
						bindKey = bindKey,
						base = base,
						mod = mod,
						id = entry.id,
						name = ProtoSpellName(entry.id) or ("#" .. tostring(entry.id)),
					})
				end
			end
		end
	end
	-- Spec 08 cross-listing: mirror every bound "alsoStop" spell into the interrupt card with
	-- its REAL key + a stop-type tag, so the scattered stop-toolkit reads as one group. We only
	-- MIRROR — the spell keeps its own card and key (Avenger's Shield stays a builder on 2).
	if spec and spec.spellByUiKey then
		for bindKey, entry in pairs(spec.spellByUiKey) do
			if type(entry) == "table" and entry.id and entry.alsoStop then
				local mod, base = ns.Keybind_ParseBindKey(bindKey)
				if PassesCardFilter(filter, base, mod)
					and GroupForBind(entry, base, mod, CategoryTokenForBase(slots, base)) ~= "interrupt" then
					local tag = ns:L("KEYBIND_TAG_" .. tostring(entry.alsoStop):upper())
					groups["interrupt"] = groups["interrupt"] or {}
					table.insert(groups["interrupt"], {
						bindKey = bindKey,
						base = base,
						mod = mod,
						id = entry.id,
						name = ProtoSpellName(entry.id) or ("#" .. tostring(entry.id)),
						stopTag = tag, -- rendered in its own FontString so a long name can't eat it
					})
				end
			end
		end
	end

	for _, list in pairs(groups) do
		table.sort(list, function(a, b)
			if (a.base or "") ~= (b.base or "") then
				return (a.base or "") < (b.base or "")
			end
			return ns.Keybind_ModifierRank(a.bindKey) < ns.Keybind_ModifierRank(b.bindKey)
		end)
	end

	local COLS = 3
	local GAPC = 12
	local pad = 10
	local usableW = HOST_W - 2 * pad
	local cardW = math.floor((usableW - (COLS - 1) * GAPC) / COLS)
	local titleH, rowH = 24, 30
	local colY = {}
	for i = 1, COLS do
		colY[i] = 0
	end

	for _, g in ipairs(CARD_GROUPS) do
		local list = groups[g.id]
		if list and #list > 0 then
			local col = 1
			for i = 2, COLS do
				if colY[i] < colY[col] then
					col = i
				end
			end
			local x = pad + (col - 1) * (cardW + GAPC)
			local y = CARDS_TOP + colY[col]
			local cardH = titleH + #list * rowH + 10
			local card = ProtoAcquireCard(panel)
			card:ClearAllPoints()
			card:SetPoint("TOPLEFT", host, "TOPLEFT", x, -y)
			card:SetSize(cardW, cardH)
			card:Show()
			card._title:SetText(ns:L(g.labelKey))
			card._tipKey = g.labelKey .. "_TIP"
			for i = 1, #list do
				local sp = list[i]
				local row = ProtoCardRow(card, i)
				row._spellId = sp.id
				row._itemId = nil
				row._panel = panel
				row._targetKey = sp.base
				row._targetMod = sp.mod
				row:ClearAllPoints()
				row:SetPoint("TOPLEFT", card, "TOPLEFT", pad, -(titleH + (i - 1) * rowH))
				row:SetSize(cardW - pad * 2, rowH - 4)
				local tex = C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(sp.id)
				row._icon:SetTexture(tex or "Interface\\Icons\\INV_Misc_QuestionMark")
				row._name:SetText(sp.name)
				row._stopTag:SetText(sp.stopTag and ("(" .. sp.stopTag .. ")") or "")
				row._cap:SetText(ns.Keybind_FormatKeycap(sp.bindKey) or sp.bindKey)
				if sp.mod == "shift" then
					row._cap:SetTextColor(0.35, 0.85, 1)
				elseif sp.mod == "ctrl" then
					row._cap:SetTextColor(0.55, 1, 0.55)
				elseif sp.mod == "alt" then
					row._cap:SetTextColor(1, 0.5, 0.5)
				else
					row._cap:SetTextColor(1, 0.82, 0.3)
				end
				row:Show()
			end
			colY[col] = colY[col] + cardH + GAPC
		end
	end

	-- Extra kaart: healer single-target-heals via mouseover/click-cast (geen fysieke toets, v6 §6).
	local cc = spec and spec.clickCast
	if filter == "all" and type(cc) == "table" and #cc > 0 then
		local col = 1
		for i = 2, COLS do
			if colY[i] < colY[col] then
				col = i
			end
		end
		local x = pad + (col - 1) * (cardW + GAPC)
		local y = CARDS_TOP + colY[col]
		local cardH = titleH + #cc * rowH + 10
		local card = ProtoAcquireCard(panel)
		card:ClearAllPoints()
		card:SetPoint("TOPLEFT", host, "TOPLEFT", x, -y)
		card:SetSize(cardW, cardH)
		card:Show()
		card._title:SetText(ns:L("LAYOUT_CARD_STHEAL"))
		for i = 1, #cc do
			local sp = cc[i]
			local row = ProtoCardRow(card, i)
			row._spellId = sp.id
			row._panel = panel
			row._targetKey = nil
			row._targetMod = nil
			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", card, "TOPLEFT", pad, -(titleH + (i - 1) * rowH))
			row:SetSize(cardW - pad * 2, rowH - 4)
			local tex = C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(sp.id)
			row._icon:SetTexture(tex or "Interface\\Icons\\INV_Misc_QuestionMark")
			row._name:SetText(sp.name)
			row._stopTag:SetText("") -- self-heal rows never carry a stop-tag
			row._cap:SetText(ns:L("LAYOUT_STHEAL_TAG"))
			row._cap:SetTextColor(0.5, 0.8, 1)
			row:Show()
		end
		colY[col] = colY[col] + cardH + GAPC
	end

	-- Volle-breedte "Consumables & extras"-balk onderaan de kaarten (klikbaar om te
	-- gebruiken, geen keybind). ✓/✗-status uit de bestaande consumables-detectie.
	-- Afgeschermd met pcall: een fout in de extras-render mag de rest van de Layout
	-- nooit breken. Bij een fout printen we 'm één keer zodat we 'm kunnen fixen.
	local okExtras, errExtras = pcall(function()
		local extras = (filter == "all" or filter == "extras") and ns.GetLayoutExtras and ns.GetLayoutExtras()
		if type(extras) == "table" and #extras > 0 then
			local topY = 0
			for i = 1, COLS do
				topY = math.max(topY, colY[i])
			end
			local usedH = ProtoRenderExtrasBar(panel, host, extras, pad, usableW, CARDS_TOP + topY, titleH, rowH)
			for i = 1, COLS do
				colY[i] = topY + usedH + GAPC
			end
		elseif panel._mhExtrasCard then
			panel._mhExtrasCard:Hide()
		end
	end)
	if not okExtras and not panel._mhExtrasErrShown then
		panel._mhExtrasErrShown = true
		print("|cffff5555MH extras-fout:|r " .. tostring(errExtras))
	end

	local maxCol = 0
	for i = 1, COLS do
		maxCol = math.max(maxCol, colY[i])
	end
	if maxCol <= 0 then
		return HOST_H
	end
	return CARDS_TOP + maxCol + 14
end
-- =================== einde spell-strook ===================

local function ProtoAttachTooltip(btn, text)
	if not btn then
		return
	end
	btn:SetScript("OnEnter", function(self)
		local gt = _G.GameTooltip
		if not gt or not self then
			return
		end
		gt:SetOwner(self, "ANCHOR_CURSOR")
		gt:SetText(text, nil, nil, nil, nil, true)
		gt:Show()
	end)
	btn:SetScript("OnLeave", function()
		local gt = _G.GameTooltip
		if gt then
			gt:Hide()
		end
	end)
	btn:SetScript("OnClick", function(self)
		if self._mhProtoTipText then
			local ts = self._mhProtoTipText
			if ts == "" then
				return
			end
			if DEFAULT_CHAT_FRAME then
				DEFAULT_CHAT_FRAME:AddMessage("|cffaaeeffMidnight Helper (Layout):|r " .. ts)
			end
		end
	end)
end

local function PlainTooltipText(raw)
	if not raw then
		return ""
	end
	return raw:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
end

local function ProtoTooltipForDimmedKey(uiKey)
	if MODIFIER_KEYS[uiKey] then
		return ns:L("LAYOUT_KEY_MODIFIER_TOOLTIP")
	end
	return ns:L("LAYOUT_KEY_UNUSED_TOOLTIP")
end

local function LabelForPrototypeKey(uiKey)
	-- "BUTTON4" does not fit on a 30px key and reads as jargon. M4 is what the thumb
	-- pad is called in every guide.
	local mouseN = type(uiKey) == "string" and uiKey:match("^BUTTON(%d+)$")
	if mouseN then
		return "M" .. mouseN
	end
	if uiKey == " " then
		return "Space"
	end
	if uiKey == "\\" then
		return "\\"
	end
	if uiKey == "BkSp" then
		return "Back"
	end
	if uiKey == "Esc" then
		return "Esc"
	end
	if uiKey == "LWin" then
		return "Win"
	end
	if uiKey == "RWin" then
		return "Win"
	end
	if uiKey == "Menu" then
		return "Menu"
	end
	if uiKey == "RAlt" then
		return "AltGr"
	end
	if uiKey == "LCtrl" or uiKey == "RCtrl" then
		return "Ctrl"
	end
	if uiKey == "LAlt" then
		return "Alt"
	end
	if uiKey == "LShift" or uiKey == "RShift" then
		return "Shift"
	end
	return uiKey
end

local function ProtoKeycapLabel(btn)
	if not btn or not btn.GetRegions then
		return nil
	end
	local fs = btn.GetFontString and btn:GetFontString()
	if fs then
		return fs
	end
	for _, r in ipairs({ btn:GetRegions() }) do
		if r and r.GetObjectType and r:IsObjectType("FontString") then
			return r
		end
	end
	return nil
end

function ns.KeyboardLayoutPrototype_Refresh(panel)
	if not panel or not panel._mhProtoButtons then
		return
	end
	local ref = ns.KeybindingReference
	local slug = ProtoResolveSlug()
	local spec = slug and ref and ref.specsById and ref.specsById[slug]
	local slots
	local usingAuto = false

	--- ⚠️ THE LIVE MAP WINS. Until 6 Aug a hand-written map, where one existed, beat the
	--- spellbook. Seven specs have one, and they are tables typed months ago against a
	--- talent build somebody had at the time. On Rob's Frost Mage the hand-map offers
	--- Glacial Spike on 5 and Cold Snap on X — neither of which is in his spellbook. So
	--- the tab was teaching him keys for buttons he does not own, which is the same
	--- failure as the Alt+M promise and the "Purge" label: confident, specific, wrong.
	---
	--- The auto-map reads what the player actually has, follows talent overrides, and
	--- since this evening walks the whole book rather than the first section of it. A
	--- hand-map cannot beat that; it can only be a fallback for a class the classifier
	--- does not cover yet.
	if ns.MH_AutoMapSpecAndSlots then
		local aSpec, aSlots = ns.MH_AutoMapSpecAndSlots()
		if aSpec and aSlots and next(aSpec.spellByUiKey or {}) then
			spec = aSpec
			slots = aSlots
			usingAuto = true
		end
	end
	if not usingAuto then
		if slug and ref and spec then
			slots = (ns.Keybinding_GetSlotsForSlug and ns.Keybinding_GetSlotsForSlug(slug)) or ref.slots
		end
		slots = slots or {}
	end
	local highlightKey = panel._mhProtoHighlightKey or ns._mhLayoutHighlightKey
	if highlightKey and ns.Keybind_GetBaseUiKey then
		highlightKey = ns.Keybind_GetBaseUiKey(highlightKey) or highlightKey
	end
	local slotByUi = {}
	local usedUiKeys = {}
	if type(slots) == "table" then
		for i = 1, #slots do
			local s = slots[i]
			if s and s.ui_key then
				slotByUi[s.ui_key] = s
				usedUiKeys[s.ui_key] = true
			end
		end
	end

	--- Only draw thumb buttons the player says they have. Two is an ordinary mouse; the
	--- rest of the pad would otherwise be six keys nobody can press, which is the exact
	--- kind of confident-but-wrong picture this whole evening was spent removing.
	local mouseCount = tonumber(ns.db and ns.db.mouseButtonCount) or 2

	for uiKey, btn in pairs(panel._mhProtoButtons) do
		if btn then
			local mouseN = type(uiKey) == "string" and tonumber(uiKey:match("^BUTTON(%d+)$"))
			if mouseN then
				btn:SetShown((mouseN - 3) <= mouseCount)
			end
			local slot = slotByUi[uiKey]
			local layers = spec and ns.Keybind_GetBindingsOnBase and ns.Keybind_GetBindingsOnBase(spec, uiKey) or {}
			local hasSpell = #layers > 0
			local tip
			local plain
			local fs = ProtoKeycapLabel(btn)
			local function tintLabel(rgb)
				if fs and fs.SetTextColor then
					fs:SetTextColor(rgb[1], rgb[2], rgb[3])
				end
			end

			if MOVEMENT_KEYS[uiKey] then
				tip = ns:L("LAYOUT_KEY_MOVEMENT_TOOLTIP")
				plain = PlainTooltipText(tip)
				btn:SetAlpha(1)
				tintLabel(COLOR_TEXT_MOVEMENT)
			elseif TARGET_KEYS[uiKey] then
				tip = ns:L("LAYOUT_KEY_TAB_TOOLTIP")
				plain = PlainTooltipText(tip)
				btn:SetAlpha(1)
				tintLabel(COLOR_TEXT_TARGET)
			elseif PREFERRED_BAR_KEYS[uiKey] and not usedUiKeys[uiKey] then
				tip = ns:L("LAYOUT_KEY_PREFERRED_TOOLTIP")
				plain = PlainTooltipText(tip)
				btn:SetAlpha(1)
				tintLabel(COLOR_TEXT_SPELL)
			elseif not usedUiKeys[uiKey] or (uiKey == "G" and not hasSpell) then
				tip = ProtoTooltipForDimmedKey(uiKey)
				plain = PlainTooltipText(tip)
				btn:SetAlpha(0.32)
				tintLabel(COLOR_TEXT_DIM)
			else
				tip = ProtoTooltipForKey(uiKey, slot, spec)
				plain = PlainTooltipText(tip)
				if hasSpell then
					btn:SetAlpha(1)
				else
					btn:SetAlpha(0.62)
				end
				tintLabel(COLOR_TEXT_SPELL)
			end

			btn._mhProtoTipText = plain
			ProtoAttachTooltip(btn, tip)

			local badge = ProtoEnsureLayerBadge(btn)
			if badge then
				local extra = hasSpell and ProtoCountModifierLayers(layers) or 0
				if extra > 0 then
					badge:SetText("+" .. extra)
					badge:Show()
				else
					badge:Hide()
				end
			end

			local glow = ProtoEnsureGlow(btn)
			if glow then
				if highlightKey and uiKey == highlightKey then
					glow:Show()
					glow:SetVertexColor(1, 0.88, 0.25, 0.95)
					btn:SetAlpha(1)
					local extra = ns:L("LAYOUT_KEY_HIGHLIGHT_FROM_GUIDE")
					btn._mhProtoTipText = plain .. "\n" .. PlainTooltipText(extra)
					ProtoAttachTooltip(btn, tip .. "\n" .. extra)
				else
					glow:Hide()
				end
			end
		end
	end

	if panel._header then
		panel._header:SetText(ns:L("TAB_LEVELING_SUB_LAYOUT"))
	end
	if panel._mhProtoSubtitle then
		local subText = ns:L("LAYOUT_PROTOTYPE_SUBTITLE")
		if usingAuto then
			subText = subText .. "\n|cff66ccff" .. ns:L("LAYOUT_AUTOMAP_NOTE") .. "|r"
		elseif not slug then
			subText = subText .. "\n|cffffb347" .. ns:L("LAYOUT_NO_MAP_HINT") .. "|r"
		end
		panel._mhProtoSubtitle:SetText(subText)
	end
	if panel._mhProtoLegend then
		panel._mhProtoLegend:SetText(ns:L("LAYOUT_LEGEND"))
	end

	local cardsH = ProtoRefreshCards(panel, spec, slots)
	if panel._mhProtoHost then
		panel._mhProtoHost:SetSize(HOST_W, math.max(HOST_H, cardsH or HOST_H))
	end
end

function ns.BuildKeyboardLayoutPrototypePanel(panel)
	if not panel then
		return
	end
	--- Earlier builds could set `_mhProtoBuilt` before failing (e.g. host without `CreateModulePanel` `_header`).
	if panel._mhProtoBuilt and not panel._mhProtoHost then
		panel._mhProtoBuilt = false
	end
	if panel._mhProtoBuilt then
		return
	end

	if panel._body then
		panel._body:Hide()
	end

	if not panel._header then
		local header = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
		header:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -12)
		panel._header = header
	else
		panel._header:ClearAllPoints()
		panel._header:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -12)
	end
	panel._header:SetText(ns:L("TAB_LEVELING_SUB_LAYOUT"))

	if not panel._mhProtoBg then
		local bg = CreateFrame("Frame", nil, panel, "BackdropTemplate")
		bg:SetFrameStrata(panel:GetFrameStrata())
		bg:SetFrameLevel(math.max(0, (panel:GetFrameLevel() or 0) - 1))
		bg:SetAllPoints()
		if bg.SetBackdrop then
			bg:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8X8",
				tile = false,
				edgeSize = 1,
				insets = { left = 0, right = 0, top = 0, bottom = 0 },
			})
		end
		if bg.SetBackdropColor then
			bg:SetBackdropColor(0.07, 0.07, 0.09, 0.97)
		end
		panel._mhProtoBg = bg
	end

	local sub = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	sub:SetPoint("TOPLEFT", panel._header, "BOTTOMLEFT", 0, -6)
	sub:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -14)
	sub:SetJustifyH("LEFT")
	sub:SetWordWrap(true)
	sub:SetSpacing(3)
	sub:SetText(ns:L("LAYOUT_PROTOTYPE_SUBTITLE"))
	sub:SetTextColor(0.78, 0.74, 0.68)
	panel._mhProtoSubtitle = sub

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperKeyboardProtoScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetFrameStrata(panel:GetFrameStrata())
	scroll:SetFrameLevel(math.max(1, (panel:GetFrameLevel() or 0) + 5))
	scroll:SetPoint("TOPLEFT", sub, "BOTTOMLEFT", -4, -10)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, 12)

	local host = CreateFrame("Frame", nil, scroll)
	host:SetSize(HOST_W, HOST_H)
	scroll:SetScrollChild(host)
	panel._mhProtoHost = host

	panel._mhProtoButtons = {}

	for uiKey, xy in pairs(KEY_POS) do
		local b = CreateFrame("Button", nil, host, "UIPanelButtonTemplate")
		local w = KW
		local h = KH
		if type(xy[3]) == "number" then
			w = xy[3]
		end
		if type(xy[4]) == "number" then
			h = xy[4]
		end
		b:SetSize(w, h)
		b:SetPoint("TOPLEFT", host, "TOPLEFT", xy[1], -xy[2])
		b:SetText(LabelForPrototypeKey(uiKey))
		b._mhProtoLayoutY = xy[2]
		panel._mhProtoButtons[uiKey] = b
	end

	if not panel._mhProtoLegend then
		local leg = host:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		leg:SetPoint("TOPLEFT", host, "TOPLEFT", 8, -(KB_BOTTOM + 8))
		leg:SetPoint("TOPRIGHT", host, "TOPRIGHT", -10, -(KB_BOTTOM + 8))
		leg:SetJustifyH("LEFT")
		leg:SetJustifyV("TOP")
		leg:SetWordWrap(true)
		leg:SetSpacing(2)
		panel._mhProtoLegend = leg
	end
	panel._mhProtoLegend:SetText(ns:L("LAYOUT_LEGEND"))

	ProtoBuildFilterChips(panel)
	ns.KeyboardLayoutPrototype_Refresh(panel)

	if not panel._mhProtoEvents then
		panel._mhProtoEvents = true
		panel:RegisterEvent("PLAYER_LEVEL_UP")
		panel:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		panel:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		panel:RegisterEvent("PLAYER_ENTERING_WORLD")
		panel:RegisterEvent("TRAIT_CONFIG_UPDATED") -- losse talent / loadout-swap (M+ vs raid)
		panel:RegisterEvent("SPELLS_CHANGED")       -- nieuwe spell geleerd (leveling)
		panel:SetScript("OnEvent", function(_, event)
			if event == "SPELLS_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
				-- Kunnen vaak vuren; alleen hertekenen als de tab open is.
				if panel:IsShown() then
					ns.KeyboardLayoutPrototype_Refresh(panel)
				end
			elseif
				event == "PLAYER_LEVEL_UP"
				or event == "PLAYER_SPECIALIZATION_CHANGED"
				or event == "ACTIVE_TALENT_GROUP_CHANGED"
				or event == "PLAYER_ENTERING_WORLD"
			then
				ns.KeyboardLayoutPrototype_Refresh(panel)
			end
		end)

		panel:SetScript("OnShow", function()
			ns.KeyboardLayoutPrototype_Refresh(panel)
		end)
	end

	panel._mhProtoBuilt = true
end
