--[[
	Raids page (Codex) — the Raid Coach in the same shape as the Dungeon Coach: one
	collapsible button per raid; expanding it lists every boss with its numbered steps,
	role lines and clickable {SPELL:} links.

	No new data. The raids and their tips already live in Modules/RaidCoachData.lua
	(registered into ns.CUSTOM_BOSS_ENTRIES and ns.DUNGEON_TIPS) with the step bodies in
	Locales/RaidTips.lua (6 languages). This file only renders them, reusing the Dungeon
	Coach helpers — GetDungeonBossName resolves localized boss names from the Encounter
	Journal via each boss's encounterID, so the names follow the player's language.

	Built because the Raid Coach only lived behind the floating boss window (/mh bosswin),
	which still auto-opens on ENCOUNTER_START; this page is for preparing beforehand.

	The body is a read-only multi-line EditBox (not a FontString) because that is what
	makes the spell links clickable — same pattern, and same height measurement, as
	Modules/DungeonGuide.lua.
]]

local _, ns = ...

local SIDE_PAD = 14
local TOP_PAD = 12
local BTN_H = 22
local GAP = 6
local BODY_INDENT = 10

-- Shared status palette (UI.lua). The fallbacks keep this module standalone.
local C = ns.UI_COLORS or {}
local COLOR_DIM = C.dim or { 0.75, 0.78, 0.82 }

local ui

--------------------------------------------------------------------------------
-- Collapse state (remembered in the DB)
--------------------------------------------------------------------------------

local function IsCollapsed(key, index)
	ns.db = ns.db or {}
	local map = ns.db.raidCoachCollapsed
	if map and map[key] ~= nil then
		return map[key] == true
	end
	-- First raid open by default, so the page immediately shows what it offers.
	return index ~= 1
end

local function ToggleCollapsed(key, index)
	ns.db = ns.db or {}
	ns.db.raidCoachCollapsed = ns.db.raidCoachCollapsed or {}
	ns.db.raidCoachCollapsed[key] = not IsCollapsed(key, index)
	if ns.RefreshRaidsPanel then
		ns.RefreshRaidsPanel()
	end
end

--------------------------------------------------------------------------------
-- Body text: every boss of one raid
--------------------------------------------------------------------------------

local function BuildRaidBody(raid)
	local lines = {}
	-- S2-tips zijn geschreven vóór de opening van 18 aug, uit DBM- en journal-data.
	-- Die herkomst hoort op het scherm tot iemand ze live heeft nagelopen — een tip
	-- die stiekem uit een datamine komt is precies wat deze addon niet doet.
	if raid.season == 2 then
		lines[#lines + 1] = "|cff8a8f98" .. ns:L("RAID_PRERELEASE_NOTE") .. "|r"
		lines[#lines + 1] = " "
	end
	local bosses = raid.bosses or {}
	for i, b in ipairs(bosses) do
		local bossName = (ns.GetDungeonBossName and ns.GetDungeonBossName(b, raid, i)) or b.name or "?"
		lines[#lines + 1] = "|cffe8c36a" .. bossName .. "|r"
		local tips = ns.GetDungeonBossTips and ns.GetDungeonBossTips(raid.key, b.key)
		if tips then
			if tips.steps then
				lines[#lines + 1] = ns:L(tips.steps)
			end
			if tips.tank then
				lines[#lines + 1] = (_G.INLINE_TANK_ICON or "") .. " " .. ns:L(tips.tank)
			end
			if tips.healer then
				lines[#lines + 1] = (_G.INLINE_HEALER_ICON or "") .. " " .. ns:L(tips.healer)
			end
			if tips.dps then
				lines[#lines + 1] = (_G.INLINE_DAMAGER_ICON or "") .. " " .. ns:L(tips.dps)
			end
		end
		if i < #bosses then
			lines[#lines + 1] = " "
		end
	end
	local body = table.concat(lines, "|n")
	if ns.ExpandDelveTipMarkup then
		body = ns:ExpandDelveTipMarkup(body) -- {SPELL:id} -> clickable links
	end
	return body
end

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

local function Relayout()
	if not ui or not ui.child then
		return
	end
	local width = ui.child:GetWidth()
	if not width or width <= 0 then
		return
	end
	local y = 4
	local tipHeightChanged = false

	for idx, row in ipairs(ui.rows) do
		local collapsed = IsCollapsed(row.raid.key, idx)
		local plainName = (ns.GetDungeonDisplayName and ns.GetDungeonDisplayName(row.raid)) or row.raid.name or "?"
		-- ASCII indicator: arrow glyphs render as boxes in the WoW fonts.
		row.btn:SetText((collapsed and "|cff8a8f98[+]|r " or "|cff8a8f98[-]|r ") .. plainName)
		row.btn:ClearAllPoints()
		row.btn:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
		row.btn:SetWidth(math.max(width, 1))
		row.btn:Show()
		y = y + BTN_H + 2

		if collapsed then
			row.body:Hide()
		else
			row.body:Show()
			row.body:ClearAllPoints()
			row.body:SetPoint("TOPLEFT", ui.child, "TOPLEFT", BODY_INDENT, -y)
			row.body:SetWidth(math.max(width - BODY_INDENT, 1))
			-- Height = lines x line height, measured AFTER SetWidth. The first measure
			-- after the box becomes visible is stale (the text was set while hidden), so
			-- a height change schedules exactly one re-measure next frame; two passes
			-- that agree end the loop. Same trick as the Dungeon Coach.
			local lineH = 14
			if row.body.GetFont then
				local _, fontH = row.body:GetFont()
				if fontH and fontH > 0 then
					lineH = fontH + 2
				end
			end
			local numLines = (row.body.GetNumLines and row.body:GetNumLines()) or 1
			local h = math.max(numLines * lineH + 4, 14)
			if row.body._mhLastH ~= h then
				row.body._mhLastH = h
				tipHeightChanged = true
			end
			row.body:SetHeight(h)
			y = y + h
		end
		y = y + GAP
	end

	ui.child:SetHeight(math.max(y + 8, 1))

	if tipHeightChanged and C_Timer and C_Timer.After and not ui._mhRelayoutPending then
		ui._mhRelayoutPending = true
		C_Timer.After(0, function()
			ui._mhRelayoutPending = false
			Relayout()
		end)
	end
end

function ns.RefreshRaidsPanel()
	if not ui or not ui.child then
		return
	end
	for _, row in ipairs(ui.rows) do
		row.body:SetText(BuildRaidBody(row.raid))
	end
	Relayout()
end

--------------------------------------------------------------------------------
-- Build
--------------------------------------------------------------------------------

function ns.BuildRaidsPanel(panel)
	if not panel or panel._mhRaidsBuilt then
		return
	end
	panel._mhRaidsBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("TAB_RAIDS"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	subtitle:SetText(ns:L("RAIDS_PANEL_SUBTITLE"))

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperRaidsScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)

	ui = {
		panel = panel,
		title = title,
		subtitle = subtitle,
		scroll = scroll,
		child = child,
		rows = {},
	}

	local raids = (ns.GetRaidCoachRaids and ns.GetRaidCoachRaids()) or {}
	for idx, raid in ipairs(raids) do
		local btn = CreateFrame("Button", nil, child, "UIPanelButtonTemplate")
		btn:SetHeight(BTN_H)
		btn:SetScript("OnClick", function()
			ToggleCollapsed(raid.key, idx)
		end)

		-- Read-only multi-line EditBox: this is what makes the spell links clickable.
		local body = CreateFrame("EditBox", nil, child)
		body:SetMultiLine(true)
		body:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		body:SetJustifyH("LEFT")
		body:SetAutoFocus(false)
		body:EnableMouse(true)
		if body.SetMaxLetters then
			body:SetMaxLetters(0)
		end
		body:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
		body._mhTipBox = true
		if ns.AttachDelveTipHyperlinksToEditBox then
			ns:AttachDelveTipHyperlinksToEditBox(body)
		end

		ui.rows[#ui.rows + 1] = { raid = raid, btn = btn, body = body }
	end

	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
		end
		if panel:IsShown() then
			ns.RefreshRaidsPanel()
		end
	end
	scroll:SetScript("OnSizeChanged", syncWidth)
	syncWidth()

	panel:SetScript("OnShow", function()
		syncWidth()
		ns.RefreshRaidsPanel()
	end)

	ns.RaidsPanel = panel
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_RAIDS"))
		end
		if ui and ui.subtitle then
			ui.subtitle:SetText(ns:L("RAIDS_PANEL_SUBTITLE"))
		end
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshRaidsPanel()
		end
	end
end
