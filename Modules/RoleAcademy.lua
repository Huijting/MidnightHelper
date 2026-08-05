--[[
	Midnight Helper — Role Academy (tank / heal confidence, group content ramp).
]]

local addonName, ns = ...

local TRACK_TANK = "tank"
local TRACK_HEAL = "heal"
local TRACK_DPS = "dps"

local PREFLIGHT_KEYS = {
	tank = { "interrupt", "defensive", "consumables", "taunt" },
	heal = { "macros", "defensive", "consumables", "practice" },
	dps = { "rotation", "cooldowns", "defensive", "interrupt" },
}

local PREFLIGHT_LABEL_KEYS = {
	tank = {
		interrupt = "ACADEMY_PREF_TANK_INTERRUPT",
		defensive = "ACADEMY_PREF_TANK_DEFENSIVE",
		consumables = "ACADEMY_PREF_TANK_CONSUMABLES",
		taunt = "ACADEMY_PREF_TANK_TAUNT",
	},
	heal = {
		macros = "ACADEMY_PREF_HEAL_MACROS",
		defensive = "ACADEMY_PREF_HEAL_DEFENSIVE",
		consumables = "ACADEMY_PREF_HEAL_CONSUMABLES",
		practice = "ACADEMY_PREF_HEAL_PRACTICE",
	},
	dps = {
		rotation = "ACADEMY_PREF_DPS_ROTATION",
		cooldowns = "ACADEMY_PREF_DPS_COOLDOWNS",
		defensive = "ACADEMY_PREF_DPS_DEFENSIVE",
		interrupt = "ACADEMY_PREF_DPS_INTERRUPT",
	},
}

local SECTION_KEYS = {
	tank = {
		{ "ACADEMY_TANK_INTRO_TITLE", "ACADEMY_TANK_INTRO_BODY" },
		{ "ACADEMY_TANK_PULL_TITLE", "ACADEMY_TANK_PULL_BODY" },
		{ "ACADEMY_TANK_WIPE_TITLE", "ACADEMY_TANK_WIPE_BODY" },
		{ "ACADEMY_TANK_DUNGEON_TITLE", "ACADEMY_TANK_DUNGEON_BODY" },
		{ "ACADEMY_TANK_RAID_TITLE", "ACADEMY_TANK_RAID_BODY" },
		{ "ACADEMY_TANK_CHAT_TITLE", "ACADEMY_TANK_CHAT_BODY" },
		{ "ACADEMY_TANK_LADDER_TITLE", "ACADEMY_TANK_LADDER_BODY" },
		{ "ACADEMY_TANK_BOTH_TITLE", "ACADEMY_TANK_BOTH_BODY" },
	},
	heal = {
		{ "ACADEMY_HEAL_INTRO_TITLE", "ACADEMY_HEAL_INTRO_BODY" },
		{ "ACADEMY_HEAL_TRIAGE_TITLE", "ACADEMY_HEAL_TRIAGE_BODY" },
		{ "ACADEMY_HEAL_MANA_TITLE", "ACADEMY_HEAL_MANA_BODY" },
		{ "ACADEMY_HEAL_POSITION_TITLE", "ACADEMY_HEAL_POSITION_BODY" },
		{ "ACADEMY_HEAL_COOLDOWNS_TITLE", "ACADEMY_HEAL_COOLDOWNS_BODY" },
		{ "ACADEMY_HEAL_MISTAKES_TITLE", "ACADEMY_HEAL_MISTAKES_BODY" },
		{ "ACADEMY_HEAL_WIPE_TITLE", "ACADEMY_HEAL_WIPE_BODY" },
		{ "ACADEMY_HEAL_CONFIDENCE_TITLE", "ACADEMY_HEAL_CONFIDENCE_BODY" },
		{ "ACADEMY_HEAL_DUNGEON_TITLE", "ACADEMY_HEAL_DUNGEON_BODY" },
		{ "ACADEMY_HEAL_RAID_TITLE", "ACADEMY_HEAL_RAID_BODY" },
		{ "ACADEMY_HEAL_CHAT_TITLE", "ACADEMY_HEAL_CHAT_BODY" },
		{ "ACADEMY_HEAL_LADDER_TITLE", "ACADEMY_HEAL_LADDER_BODY" },
		{ "ACADEMY_HEAL_BOTH_TITLE", "ACADEMY_HEAL_BOTH_BODY" },
	},
	dps = {
		{ "ACADEMY_DPS_INTRO_TITLE", "ACADEMY_DPS_INTRO_BODY" },
		{ "ACADEMY_DPS_ROTATION_TITLE", "ACADEMY_DPS_ROTATION_BODY" },
		{ "ACADEMY_DPS_COOLDOWNS_TITLE", "ACADEMY_DPS_COOLDOWNS_BODY" },
		{ "ACADEMY_DPS_MECHANICS_TITLE", "ACADEMY_DPS_MECHANICS_BODY" },
		{ "ACADEMY_DPS_UTILITY_TITLE", "ACADEMY_DPS_UTILITY_BODY" },
		{ "ACADEMY_DPS_MISTAKES_TITLE", "ACADEMY_DPS_MISTAKES_BODY" },
		{ "ACADEMY_DPS_PRACTICE_TITLE", "ACADEMY_DPS_PRACTICE_BODY" },
		{ "ACADEMY_DPS_BOTH_TITLE", "ACADEMY_DPS_BOTH_BODY" },
	},
}

local SCROLL_BOTTOM = 12
local NAV_H = 32
local PREFLIGHT_ROW_MIN = 24
local CHAT_ROW_H = 24
local CHAT_COPY_BTN = 22
local CHAT_ROW_GAP = 3

local function SL(key)
	if ns.SafeL then
		return ns:SafeL(key)
	end
	return ns:L(key)
end

local function GetTrack()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return TRACK_TANK
	end
	if ui.roleAcademyTrack == TRACK_HEAL or ui.roleAcademyTrack == TRACK_DPS then
		return ui.roleAcademyTrack
	end
	return TRACK_TANK
end

local function SetTrack(track)
	if not ns.db then
		return
	end
	if type(ns.db.ui) ~= "table" then
		ns.db.ui = {}
	end
	if track == TRACK_HEAL or track == TRACK_DPS then
		ns.db.ui.roleAcademyTrack = track
	else
		ns.db.ui.roleAcademyTrack = TRACK_TANK
	end
end

local function EnsurePreflightBag()
	if not ns.db then
		return nil
	end
	if type(ns.db.ui) ~= "table" then
		ns.db.ui = {}
	end
	if type(ns.db.ui.roleAcademyPreflight) ~= "table" then
		ns.db.ui.roleAcademyPreflight = { tank = {}, heal = {}, dps = {} }
	end
	local bag = ns.db.ui.roleAcademyPreflight
	-- Elke bestaande track MOET hier een tabel hebben: SetPreflightChecked schrijft
	-- rechtstreeks in bag[track][key], dus een ontbrekende track is een nil-index-
	-- crash zodra iemand een vinkje zet. `dps` ontbrak sinds die track erbij kwam
	-- (Rob 19 jul) — vandaar een lus over PREFLIGHT_KEYS in plaats van met de hand.
	for track in pairs(PREFLIGHT_KEYS) do
		if type(bag[track]) ~= "table" then
			bag[track] = {}
		end
	end
	return bag
end

local function GetPreflightChecked(track, key)
	local bag = EnsurePreflightBag()
	if not bag then
		return false
	end
	local t = bag[track]
	return t and t[key] and true or false
end

local function SetPreflightChecked(track, key, checked)
	local bag = EnsurePreflightBag()
	if not bag then
		return
	end
	bag[track][key] = checked and true or false
end

local function TintTrackBtn(btn, active)
	if not btn or not btn.GetRegions then
		return
	end
	local tint = active and { 0.96, 0.93, 0.86 } or { 0.7, 0.66, 0.6 }
	for _, region in ipairs({ btn:GetRegions() }) do
		if region.GetObjectType and region:IsObjectType("Texture") and region.SetVertexColor then
			region:SetVertexColor(tint[1], tint[2], tint[3])
		end
	end
end

local function RefreshClassLine(panel)
	if not panel._classLine then
		return
	end
	local classLocalized = UnitClass("player") or "?"
	local specName = "-"
	if GetSpecialization and GetSpecializationInfo then
		local idx = GetSpecialization()
		if idx and idx > 0 then
			local _, name = GetSpecializationInfo(idx)
			if name and name ~= "" then
				specName = name
			end
		end
	end
	panel._classLine:SetText(SL("ACADEMY_CLASS_FMT"):format(classLocalized, specName))
end

local function RebuildPreflightChecks(panel)
	-- Content font scale: the per-row floor scales so checked rows don't crowd;
	-- actual row height also follows the (scaled) label's GetStringHeight.
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local prefRowMin = PREFLIGHT_ROW_MIN * s
	local track = GetTrack()
	local keys = PREFLIGHT_KEYS[track] or {}
	local labels = PREFLIGHT_LABEL_KEYS[track] or {}
	local checks = panel._preflightChecks or {}
	for i = 1, #checks do
		checks[i]:Hide()
	end
	panel._preflightChecks = panel._preflightChecks or {}

	local parent = panel._preflightBox
	if not parent then
		return
	end

	local boxW = math.max(280, (parent:GetWidth() or 400) - 16)
	local labelW = boxW - 36
	local y = -28
	for i = 1, #keys do
		local key = keys[i]
		local chk = panel._preflightChecks[i]
		if not chk then
			chk = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
			panel._preflightChecks[i] = chk
			chk:SetScript("OnClick", function(self)
				SetPreflightChecked(GetTrack(), self._mhPrefKey, self:GetChecked())
			end)
		end
		chk._mhPrefKey = key
		chk:Show()
		chk:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, y)
		chk:SetChecked(GetPreflightChecked(track, key))
		local labelKey = labels[key]
		local txt = chk.text or _G[chk:GetName() .. "Text"]
		local rowH = prefRowMin
		if txt and txt.SetText and labelKey then
			if txt.SetFontObject then
				txt:SetFontObject(ns.MHScalableFont("GameFontHighlight"))
			end
			if txt.SetWidth then
				txt:SetWidth(labelW)
			end
			if txt.SetWordWrap then
				txt:SetWordWrap(true)
			end
			txt:SetText(SL(labelKey))
			if txt.SetTextColor then
				txt:SetTextColor(0.95, 0.9, 0.74)
			end
			if txt.GetStringHeight then
				rowH = math.max(prefRowMin, math.ceil(txt:GetStringHeight() or 14) + 8)
			end
		end
		y = y - rowH
	end

	if panel._preflightHint then
		local hint = panel._preflightHint
		hint:ClearAllPoints()
		hint:SetWidth(boxW)
		hint:SetText(SL("ACADEMY_PREF_HINT"))
		hint:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, y - 6)
		local hintH = hint:GetStringHeight() or 14
		parent:SetHeight(math.max(72, -y + hintH + 16))
	end
end

local function IsChatBodyKey(bodyKey)
	return bodyKey and bodyKey:find("_CHAT_BODY", 1, true) ~= nil
end

local function SplitChatLines(text)
	local lines = {}
	if not text or text == "" then
		return lines
	end
	for line in string.gmatch(text, "([^\n]+)") do
		lines[#lines + 1] = line
	end
	return lines
end

local function ChatLineForCopy(line)
	local inner = line:match('^%s*"(.*)"%s*$')
	if inner then
		return inner
	end
	return line:gsub('^"', ""):gsub('"$', "")
end

local function HighlightEditBox(eb)
	if not eb or not eb.SetFocus then
		return
	end
	eb:SetFocus(true)
	local t = eb:GetText() or ""
	if eb.HighlightText then
		eb:HighlightText(0, string.len(t))
	end
end

local function StyleChatEditBox(eb)
	if not eb or eb._mhChatStyled then
		return
	end
	eb._mhChatStyled = true
	eb:SetAutoFocus(false)
	eb:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	eb:SetTextInsets(6, 6, 3, 3)
	eb:EnableMouse(true)
	eb:SetTextColor(0.92, 0.9, 0.82)
	local bg = eb:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", eb, "TOPLEFT", -2, 2)
	bg:SetPoint("BOTTOMRIGHT", eb, "BOTTOMRIGHT", 2, -2)
	bg:SetColorTexture(0.06, 0.06, 0.08, 0.85)
	eb._mhBg = bg
	eb:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	eb:SetScript("OnEditFocusGained", function(self)
		HighlightEditBox(self)
	end)
end

local function StyleChatCopyBtn(btn)
	if not btn or btn._mhChatCopyStyled then
		return
	end
	btn._mhChatCopyStyled = true
	local tex = btn:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints()
	pcall(function()
		if tex.SetAtlas then
			tex:SetAtlas("transmog-icon-chat")
		end
		if not tex.GetTexture or not tex:GetTexture() or tex:GetTexture() == 0 then
			if tex.SetAtlas then
				tex:SetAtlas("Garr_SearchIcon")
			end
		end
		if not tex.GetTexture or not tex:GetTexture() or tex:GetTexture() == 0 then
			tex:SetTexture(134400)
		end
	end)
	local hi = btn:CreateTexture(nil, "HIGHLIGHT")
	hi:SetAllPoints()
	hi:SetColorTexture(1, 1, 1, 0.12)
end

local function AcquireChatRow(panel, parent, index)
	panel._academyChatRows = panel._academyChatRows or {}
	local row = panel._academyChatRows[index]
	if not row then
		row = CreateFrame("Frame", nil, parent)
		row:SetHeight(CHAT_ROW_H)
		local eb = CreateFrame("EditBox", nil, row)
		StyleChatEditBox(eb)
		eb:SetPoint("LEFT", row, "LEFT", 0, 0)
		eb:SetHeight(CHAT_ROW_H)
		local copyBtn = CreateFrame("Button", nil, row)
		copyBtn:SetSize(CHAT_COPY_BTN, CHAT_COPY_BTN)
		copyBtn:SetPoint("RIGHT", row, "RIGHT", -2, 0)
		StyleChatCopyBtn(copyBtn)
		copyBtn:SetScript("OnClick", function()
			HighlightEditBox(eb)
		end)
		copyBtn:SetScript("OnEnter", function(self)
			if _G.GameTooltip then
				_G.GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				_G.GameTooltip:SetText(SL("ACADEMY_CHAT_COPY_TIP"), 1, 1, 1, 1, true)
				_G.GameTooltip:Show()
			end
		end)
		copyBtn:SetScript("OnLeave", function()
			if _G.GameTooltip then
				_G.GameTooltip:Hide()
			end
		end)
		row._eb = eb
		row._copyBtn = copyBtn
		panel._academyChatRows[index] = row
	end
	row:SetParent(parent)
	row:Show()
	return row
end

-- One line in the spec-aware healer toolkit. Headers are gold; spell rows are
-- indented and carry the coloured [label] markup from HealerCooldowns.lua. When
-- a spellID is given (spell rows), the row is wrapped in a mouse-enabled frame
-- that shows the real spell tooltip on hover.
local function AddToolkitLine(panel, child, cw, y, text, header, spellID)
	local font = header and "GameFontNormal" or "GameFontHighlightSmall"
	local indent = header and 4 or 10
	local width = cw - (header and 0 or 6)

	if spellID and not header then
		local rowf = CreateFrame("Frame", nil, child)
		rowf:SetPoint("TOPLEFT", child, "TOPLEFT", indent, y)
		rowf:SetWidth(width)
		local fs = rowf:CreateFontString(nil, "OVERLAY", font)
		fs:SetFontObject(ns.MHScalableFont(font))
		fs:SetPoint("TOPLEFT", rowf, "TOPLEFT", 0, 0)
		fs:SetWidth(width)
		fs:SetJustifyH("LEFT")
		fs:SetWordWrap(true)
		fs:SetSpacing(2)
		fs:SetTextColor(0.86, 0.84, 0.78)
		fs:SetText(text)
		local h = fs:GetStringHeight() or 14
		rowf:SetHeight(h)
		rowf:EnableMouse(true)
		rowf:SetScript("OnEnter", function(self)
			if not (GameTooltip and GameTooltip.SetSpellByID) then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:SetSpellByID(spellID)
			GameTooltip:Show()
		end)
		rowf:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		rowf:Show()
		panel._academySectionFs[#panel._academySectionFs + 1] = rowf
		return y - h - 5
	end

	local fs = child:CreateFontString(nil, "OVERLAY", font)
	fs:SetFontObject(ns.MHScalableFont(font))
	fs:SetPoint("TOPLEFT", child, "TOPLEFT", indent, y)
	fs:SetWidth(width)
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	fs:SetSpacing(2)
	if header then
		fs:SetTextColor(1, 0.82, 0.4)
	else
		fs:SetTextColor(0.86, 0.84, 0.78)
	end
	fs:SetText(text)
	fs:Show()
	panel._academySectionFs[#panel._academySectionFs + 1] = fs
	local h = fs:GetStringHeight() or 14
	return y - h - (header and 6 or 5)
end

-- Spec-aware healer toolkit (healer initiative, piece 1): the player's own core
-- heals + cooldowns, shown at the top of the HEAL track so both green beginners
-- and veterans see THEIR spells with the coloured labels. Verified data lives in
-- Modules/HealerCooldowns.lua. Returns the new y cursor.
local function ToolkitSpecName(specID)
	if GetSpecializationInfoByID then
		local ok, _, name = pcall(GetSpecializationInfoByID, specID)
		if ok and name and name ~= "" then
			return name
		end
	end
	return ""
end

local function RenderHealerToolkit(panel, child, y, cw)
	local activeID = ns.GetPlayerHealerSpecID and ns.GetPlayerHealerSpecID()
	-- On a non-heal spec, preview the class's healer spec (a Prot Paladin sees the
	-- Holy toolkit) instead of showing nothing. Classes with no healer spec fall
	-- through to a short note.
	local specID = activeID or (ns.GetClassHealerSpecID and ns.GetClassHealerSpecID())
	if not specID then
		y = AddToolkitLine(panel, child, cw, y, SL("HEALTOOLKIT_HEAD"), true)
		y = AddToolkitLine(panel, child, cw, y, "|cff9d9d9d" .. SL("HEALTOOLKIT_NONE") .. "|r", false)
		return y - 8
	end
	if not activeID then
		-- Preview banner: this is the class's healer spec, not the active one.
		y = AddToolkitLine(panel, child, cw, y,
			"|cff9d9d9d" .. (SL("HEALTOOLKIT_PREVIEW_FMT")):format(ToolkitSpecName(specID)) .. "|r", false)
	end
	local heals = ns.GetHealerCoreHeals and ns.GetHealerCoreHeals(specID)
	if heals then
		y = AddToolkitLine(panel, child, cw, y, SL("HEALTOOLKIT_HEALS_HEAD"), true)
		for _, h in ipairs(heals) do
			local line = ("%s |cffffd100%s|r — %s"):format(
				ns.HealerCoreHealTagLabel(h.tag),
				ns.HealerCooldownSpellName(h.id),
				SL(ns.GetHealerCoreHealDescKey(h.tag) or "")
			)
			y = AddToolkitLine(panel, child, cw, y, line, false, h.id)
		end
	end
	local cds = ns.GetHealerCooldowns and ns.GetHealerCooldowns(specID)
	if cds then
		y = y - 4
		y = AddToolkitLine(panel, child, cw, y, SL("HEALTOOLKIT_CDS_HEAD"), true)
		for _, c in ipairs(cds) do
			local line = ("%s |cffffd100%s|r |cff9d9d9d(%s)|r — %s"):format(
				ns.HealerCooldownKindLabel(c.kind),
				ns.HealerCooldownSpellName(c.id),
				ns.FormatHealerCooldown(c.cd),
				SL(ns.GetHealerCooldownWhenKey(c.when) or "")
			)
			y = AddToolkitLine(panel, child, cw, y, line, false, c.id)
		end
	end
	local defs = ns.GetHealerDefensives and ns.GetHealerDefensives(specID)
	if defs then
		y = y - 4
		y = AddToolkitLine(panel, child, cw, y, SL("HEALTOOLKIT_DEF_HEAD"), true)
		for _, d in ipairs(defs) do
			local cdText = d.cd and (" |cff9d9d9d(" .. ns.FormatHealerCooldown(d.cd) .. ")|r") or ""
			local line = ("|cff40a0ff[%s]|r |cffffd100%s|r%s"):format(
				SL("DPSKIT_TAG_DEF"), ns.HealerCooldownSpellName(d.id), cdText
			)
			y = AddToolkitLine(panel, child, cw, y, line, false, d.id)
		end
	end
	local dispel = ns.GetHealerDispel and ns.GetHealerDispel(specID)
	if dispel then
		y = y - 4
		y = AddToolkitLine(panel, child, cw, y, SL("HEALTOOLKIT_DISPEL_HEAD"), true)
		local line = ("|cffffd100%s|r — %s"):format(
			ns.HealerCooldownSpellName(dispel.id),
			(SL("HEALTOOLKIT_DISPEL_FMT")):format(ns.FormatDispelTypes(dispel.types))
		)
		y = AddToolkitLine(panel, child, cw, y, line, false, dispel.id)
	end
	return y - 10
end

-- "What you can dispel" for NON-healing specs — Rob's point (2026-07-15) that
-- non-healers dispel too, so a Prot Paladin or a Mage should see it as well.
-- Shared by the tank and DPS toolkits; the healer track has its own richer line.
-- Shows nothing at all when this character knows no dispel: an empty section is
-- less honest than no section.
local function AddDispelSection(panel, child, y, cw)
	local dispels = ns.GetKnownClassDispels and ns.GetKnownClassDispels()
	if not dispels or #dispels == 0 then
		return y
	end
	y = y - 4
	y = AddToolkitLine(panel, child, cw, y, SL("HEALTOOLKIT_DISPEL_HEAD"), true)
	for _, d in ipairs(dispels) do
		local line = ("|cffffd100%s|r — %s"):format(
			ns.HealerCooldownSpellName(d.id),
			(SL("HEALTOOLKIT_DISPEL_FMT")):format(ns.FormatDispelTypes(d.types))
		)
		y = AddToolkitLine(panel, child, cw, y, line, false, d.id)
	end
	return y
end

-- Spec-aware tank toolkit (Rob 2026-07-15): the player's active mitigation +
-- defensive cooldowns at the top of the TANK track, mirroring the healer one.
-- Verified data lives in Modules/TankToolkit.lua. Returns the new y cursor.
local function RenderTankToolkit(panel, child, y, cw)
	local activeID = ns.GetPlayerTankSpecID and ns.GetPlayerTankSpecID()
	local specID = activeID or (ns.GetClassTankSpecID and ns.GetClassTankSpecID())
	if not specID then
		y = AddToolkitLine(panel, child, cw, y, SL("TANKKIT_HEAD"), true)
		y = AddToolkitLine(panel, child, cw, y, "|cff9d9d9d" .. SL("TANKKIT_NONE") .. "|r", false)
		return y - 8
	end
	if not activeID then
		y = AddToolkitLine(panel, child, cw, y,
			"|cff9d9d9d" .. (SL("HEALTOOLKIT_PREVIEW_FMT")):format(ToolkitSpecName(specID)) .. "|r", false)
	end
	local mit = ns.GetTankMitigation and ns.GetTankMitigation(specID)
	if mit then
		y = AddToolkitLine(panel, child, cw, y, SL("TANKKIT_MIT_HEAD"), true)
		for _, m in ipairs(mit) do
			local line = ("%s |cffffd100%s|r — %s"):format(
				ns.TankMitigationTagLabel(m.tag),
				ns.HealerCooldownSpellName(m.id),
				SL(ns.GetTankMitigationDescKey(m.tag) or "")
			)
			y = AddToolkitLine(panel, child, cw, y, line, false, m.id)
		end
	end
	local cds = ns.GetTankCooldowns and ns.GetTankCooldowns(specID)
	if cds then
		y = y - 4
		y = AddToolkitLine(panel, child, cw, y, SL("TANKKIT_CDS_HEAD"), true)
		for _, c in ipairs(cds) do
			local cdText = c.cd and (" |cff9d9d9d(" .. ns.FormatHealerCooldown(c.cd) .. ")|r") or ""
			local line = ("%s |cffffd100%s|r%s — %s"):format(
				ns.TankCooldownKindLabel(c.kind),
				ns.HealerCooldownSpellName(c.id),
				cdText,
				SL(ns.GetTankCooldownDescKey(c.kind) or "")
			)
			y = AddToolkitLine(panel, child, cw, y, line, false, c.id)
		end
	end
	y = AddDispelSection(panel, child, y, cw)
	return y - 10
end

-- Spec-aware DPS toolkit (Rob 2026-07-15: the Academy had no DPS role). Your big
-- damage cooldowns at the top of the DPS track. Verified data lives in
-- Modules/DpsToolkit.lua. Returns the new y cursor.
--- "Stay alive" — the buttons in the order a fight needs them.
---
--- Built from ns.GetSurvivalPlan, which reads the KeybindRoles classifier rather
--- than a table written here, so it covers every class the moment it renders.
---
--- Silent when there is no plan: a class without classifier data draws nothing at
--- all rather than an empty heading, because an empty box under "stay alive" reads
--- as "you have nothing" and that is the opposite of true.
local function RenderSurvivalPlan(panel, child, y, cw)
	local steps = ns.GetSurvivalPlan and ns.GetSurvivalPlan()
	if not steps then
		return y
	end

	y = AddToolkitLine(panel, child, cw, y, SL("SURVIVAL_HEAD"), true)
	y = AddToolkitLine(panel, child, cw, y, "|cff9d9d9d" .. SL("SURVIVAL_INTRO") .. "|r", false)

	local step = 0
	for _, s in ipairs(steps) do
		step = step + 1
		-- Numbered, because the number IS the content: which one first.
		local line = ("|cffffcc00%d.|r |cffffffff%s|r%s — %s"):format(
			step, s.text,
			s.bindKey and (" |cff9d9d9d[" .. s.bindKey .. "]|r") or "",
			SL(s.whenKey))
		y = AddToolkitLine(panel, child, cw, y, line, false, s.spellID)
	end
	return y - 6
end

local function RenderDpsToolkit(panel, child, y, cw)
	local activeID = ns.GetPlayerDpsSpecID and ns.GetPlayerDpsSpecID()
	local specID = activeID or (ns.GetClassDpsSpecID and ns.GetClassDpsSpecID())
	if not specID then
		y = AddToolkitLine(panel, child, cw, y, SL("DPSKIT_HEAD"), true)
		y = AddToolkitLine(panel, child, cw, y, "|cff9d9d9d" .. SL("DPSKIT_NONE") .. "|r", false)
		return y - 8
	end
	if not activeID then
		y = AddToolkitLine(panel, child, cw, y,
			"|cff9d9d9d" .. (SL("HEALTOOLKIT_PREVIEW_FMT")):format(ToolkitSpecName(specID)) .. "|r", false)
	end
	-- On your OWN active spec, hide abilities you don't have — e.g. Berserk vs its
	-- talent replacement Incarnation, or an untalented Feral Frenzy — so the list
	-- shows what's actually on your bars. When previewing another spec (no activeID)
	-- we can't know their talents, so show everything. Fail open on any API hiccup.
	local function toolkitHas(id)
		if not (activeID and IsPlayerSpell) then
			return true
		end
		local ok, known = pcall(IsPlayerSpell, id)
		if not ok then
			return true
		end
		return known
	end
	local function shownEntries(list)
		local out = {}
		for _, e in ipairs(list or {}) do
			if toolkitHas(e.id) then
				out[#out + 1] = e
			end
		end
		return out
	end

	local cds = shownEntries(ns.GetDpsCooldowns and ns.GetDpsCooldowns(specID))
	if #cds > 0 then
		y = AddToolkitLine(panel, child, cw, y, SL("DPSKIT_CDS_HEAD"), true)
		y = AddToolkitLine(panel, child, cw, y, "|cff9d9d9d" .. SL("DPSKIT_GUIDE") .. "|r", false)
		for _, c in ipairs(cds) do
			local line = ("|cffff6060[%s]|r |cffffd100%s|r |cff9d9d9d(%s)|r"):format(
				SL("DPSKIT_TAG_BURST"), ns.HealerCooldownSpellName(c.id), ns.FormatHealerCooldown(c.cd)
			)
			y = AddToolkitLine(panel, child, cw, y, line, false, c.id)
		end
	end
	-- The "personal defensives" block used to sit here and was removed on 5 Aug,
	-- Rob's call. The survival card above it lists the same spells AND says when to
	-- press them, so this repeated them with less information.
	--
	-- It was also actively confusing: this block names spells by their base id, so
	-- Rob's card read "Ice Cold" at the top and "Ice Block" here — one button under
	-- two names on one page. Fixing the name would have kept the duplication;
	-- deleting the block removes both problems, and the page now reads simply:
	-- stay alive, then do damage.
	--
	-- `ns.DPS_DEFENSIVES` and `ns.GetDpsDefensives` are deliberately left in
	-- DpsToolkit.lua. Nothing renders them now, but they are verified per-spec data
	-- and the obvious source for a future "is your defensive off cooldown" cue.
	y = AddDispelSection(panel, child, y, cw)
	return y - 10
end

local function RebuildScrollContent(panel)
	local scroll = panel._academyScroll
	local child = panel._academyScrollChild
	if not scroll or not child then
		return
	end

	for _, fs in ipairs(panel._academySectionFs or {}) do
		if fs then
			fs:Hide()
			fs:SetParent(nil)
		end
	end
	panel._academySectionFs = {}

	for _, row in ipairs(panel._academyChatRows or {}) do
		if row then
			row:Hide()
		end
	end

	-- Content font scale: chat-line rows are fixed-height cells, so scale the row
	-- height, edit-box height, copy button AND the Y-advance together. Section
	-- bodies already grow via GetStringHeight, so they need no constant scaling.
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local chatRowH = CHAT_ROW_H * s
	local chatCopyBtn = CHAT_COPY_BTN * s

	local track = GetTrack()
	local sections = SECTION_KEYS[track] or SECTION_KEYS.tank
	local y = -4
	local cw = math.max(320, (scroll:GetWidth() or 400) - 28)

	-- Spec-aware toolkits sit above the reading chapters, per track.
	if track == TRACK_HEAL then
		y = RenderHealerToolkit(panel, child, y, cw)
	elseif track == TRACK_TANK then
		y = RenderTankToolkit(panel, child, y, cw)
	elseif track == TRACK_DPS then
		-- Survival first, damage second. Carola dies to rares on a Frost Mage
		-- (Rob, 4 Aug); the cooldown list below tells her how to kill faster,
		-- which is not her problem. Order on the page is the advice.
		y = RenderSurvivalPlan(panel, child, y, cw)
		y = RenderDpsToolkit(panel, child, y, cw)
	end

	for i = 1, #sections do
		local titleKey, bodyKey = sections[i][1], sections[i][2]
		local titleFs = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		titleFs:SetFontObject(ns.MHScalableFont("GameFontNormal"))
		titleFs:SetPoint("TOPLEFT", child, "TOPLEFT", 4, y)
		titleFs:SetWidth(cw)
		titleFs:SetJustifyH("LEFT")
		titleFs:SetTextColor(1, 0.9, 0.55)
		titleFs:SetText(SL(titleKey))
		titleFs:Show()
		panel._academySectionFs[#panel._academySectionFs + 1] = titleFs

		local _, th = titleFs:GetFont()
		th = th or 14
		y = y - th - 4

		if IsChatBodyKey(bodyKey) then
			local hintFs = child:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
			hintFs:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
			hintFs:SetPoint("TOPLEFT", child, "TOPLEFT", 4, y)
			hintFs:SetWidth(cw)
			hintFs:SetJustifyH("LEFT")
			hintFs:SetWordWrap(true)
			hintFs:SetTextColor(0.55, 0.53, 0.48)
			hintFs:SetText(SL("ACADEMY_CHAT_HINT"))
			hintFs:Show()
			panel._academySectionFs[#panel._academySectionFs + 1] = hintFs

			local hh = hintFs:GetStringHeight() or 14
			y = y - hh - 6

			local lines = SplitChatLines(SL(bodyKey))
			for j = 1, #lines do
				local row = AcquireChatRow(panel, child, j)
				row:ClearAllPoints()
				row:SetPoint("TOPLEFT", child, "TOPLEFT", 4, y)
				row:SetSize(cw, chatRowH)
				row._eb:SetHeight(chatRowH)
				if row._copyBtn then
					row._copyBtn:SetSize(chatCopyBtn, chatCopyBtn)
				end
				row._eb:SetWidth(cw - chatCopyBtn - 6)
				row._eb:SetText(ChatLineForCopy(lines[j]))
				y = y - chatRowH - CHAT_ROW_GAP
			end
			for j = #lines + 1, #(panel._academyChatRows or {}) do
				panel._academyChatRows[j]:Hide()
			end
			y = y - 10
		else
			local bodyFs = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			bodyFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
			bodyFs:SetPoint("TOPLEFT", child, "TOPLEFT", 4, y)
			bodyFs:SetWidth(cw)
			bodyFs:SetJustifyH("LEFT")
			bodyFs:SetWordWrap(true)
			bodyFs:SetSpacing(3)
			bodyFs:SetTextColor(0.82, 0.8, 0.74)
			bodyFs:SetText(SL(bodyKey))
			bodyFs:Show()
			panel._academySectionFs[#panel._academySectionFs + 1] = bodyFs

			local bh = bodyFs:GetStringHeight() or 40
			y = y - bh - 14
		end
	end

	child:SetSize(cw + 8, math.max(120, -y + 8))
	if scroll.UpdateScrollChildRect then
		scroll:UpdateScrollChildRect()
	end
	if scroll.SetVerticalScroll then
		scroll:SetVerticalScroll(0)
	end
end

function ns.MH_RefreshRoleAcademyPanel(panel)
	if not panel or not panel._academyBuilt then
		return
	end
	if panel._header and panel._header.SetText then
		panel._header:SetText(SL("TAB_ACADEMY"))
	end
	if panel._subtitle and panel._subtitle.SetText then
		panel._subtitle:SetText(SL("ACADEMY_SUBTITLE"))
	end
	if panel._preflightTitle and panel._preflightTitle.SetText then
		panel._preflightTitle:SetText(SL("ACADEMY_PREF_TITLE"))
	end
	if panel._btnTank and panel._btnTank.SetText then
		panel._btnTank:SetText(SL("ACADEMY_TRACK_TANK"))
	end
	if panel._btnHeal and panel._btnHeal.SetText then
		panel._btnHeal:SetText(SL("ACADEMY_TRACK_HEAL"))
	end
	if panel._btnDps and panel._btnDps.SetText then
		panel._btnDps:SetText(SL("ACADEMY_TRACK_DPS"))
	end
	local track = GetTrack()
	TintTrackBtn(panel._btnTank, track == TRACK_TANK)
	TintTrackBtn(panel._btnHeal, track == TRACK_HEAL)
	TintTrackBtn(panel._btnDps, track == TRACK_DPS)
	RefreshClassLine(panel)
	RebuildPreflightChecks(panel)
	RebuildScrollContent(panel)
end

function ns.BuildRoleAcademyPanel(panel)
	if not panel or panel._academyBuilt then
		return
	end
	panel._academyBuilt = true

	if panel._body then
		panel._body:Hide()
	end

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	subtitle:SetPoint("TOPLEFT", panel._header, "BOTTOMLEFT", 0, -6)
	subtitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -6)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.78, 0.76, 0.7)
	panel._subtitle = subtitle

	local nav = CreateFrame("Frame", nil, panel)
	nav:SetHeight(NAV_H)
	nav:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	nav:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -8)
	panel._academyNav = nav

	local btnTank = CreateFrame("Button", nil, nav, "UIPanelButtonTemplate")
	btnTank:SetSize(100, 24)
	btnTank:SetPoint("TOPLEFT", nav, "TOPLEFT", 0, -4)
	btnTank:SetScript("OnClick", function()
		SetTrack(TRACK_TANK)
		ns.MH_RefreshRoleAcademyPanel(panel)
	end)
	panel._btnTank = btnTank

	local btnHeal = CreateFrame("Button", nil, nav, "UIPanelButtonTemplate")
	btnHeal:SetSize(100, 24)
	btnHeal:SetPoint("LEFT", btnTank, "RIGHT", 8, 0)
	btnHeal:SetScript("OnClick", function()
		SetTrack(TRACK_HEAL)
		ns.MH_RefreshRoleAcademyPanel(panel)
	end)
	panel._btnHeal = btnHeal

	local btnDps = CreateFrame("Button", nil, nav, "UIPanelButtonTemplate")
	btnDps:SetSize(100, 24)
	btnDps:SetPoint("LEFT", btnHeal, "RIGHT", 8, 0)
	btnDps:SetScript("OnClick", function()
		SetTrack(TRACK_DPS)
		ns.MH_RefreshRoleAcademyPanel(panel)
	end)
	panel._btnDps = btnDps

	local classLine = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	classLine:SetFontObject(ns.MHScalableFont("GameFontHighlight"))
	classLine:SetPoint("TOPLEFT", nav, "BOTTOMLEFT", 0, -4)
	classLine:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -4)
	classLine:SetJustifyH("LEFT")
	classLine:SetTextColor(0.85, 0.82, 0.65)
	panel._classLine = classLine

	local preflightBox = CreateFrame("Frame", nil, panel, "BackdropTemplate")
	preflightBox:SetPoint("TOPLEFT", classLine, "BOTTOMLEFT", -4, -6)
	preflightBox:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, -6)
	preflightBox:SetHeight(72)
	if preflightBox.SetBackdrop then
		preflightBox:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		})
		preflightBox:SetBackdropColor(0.08, 0.08, 0.1, 0.45)
		preflightBox:SetBackdropBorderColor(0.45, 0.4, 0.3, 0.5)
	end
	panel._preflightBox = preflightBox

	local preflightTitle = preflightBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	preflightTitle:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	preflightTitle:SetPoint("TOPLEFT", preflightBox, "TOPLEFT", 8, -6)
	preflightTitle:SetTextColor(1, 0.88, 0.45)
	panel._preflightTitle = preflightTitle

	local preflightHint = preflightBox:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	preflightHint:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	preflightHint:SetJustifyH("LEFT")
	preflightHint:SetWordWrap(true)
	panel._preflightHint = preflightHint

	panel._preflightChecks = {}

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperAcademyScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", preflightBox, "BOTTOMLEFT", 0, -8)
	scroll:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 8, SCROLL_BOTTOM)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, SCROLL_BOTTOM)
	panel._academyScroll = scroll

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)
	panel._academyScrollChild = child
	panel._academySectionFs = {}

	scroll:SetScript("OnSizeChanged", function()
		if panel:IsShown() then
			ns.MH_RefreshRoleAcademyPanel(panel)
		end
	end)

	panel:SetScript("OnShow", function(self)
		ns.MH_RefreshRoleAcademyPanel(self)
	end)

	panel._mhRefreshAcademy = function()
		ns.MH_RefreshRoleAcademyPanel(panel)
	end

	ns.MH_RefreshRoleAcademyPanel(panel)
end
