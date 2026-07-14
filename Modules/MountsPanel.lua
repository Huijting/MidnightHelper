--[[
	Collectible mounts tab — a dedicated page listing the new Midnight (12.0.7)
	collectible mounts you have NOT earned yet, each with its progress (X of N) and
	a short how-to (and a route button where we have verified coords). Data comes from
	ns.GetWeeklyMountProgress() (Modules/MountProgress.lua); this file is only the UI.
	A mount drops off the list the moment it is collected.

	Hovering a mount name shows a floating 3D preview beside the Midnight Helper window
	(bordered + clipped so a big mount can't spill out — Rares does the same trick), plus
	the item/mount tooltip near the cursor. Split out of the Home dashboard once the list
	grew long enough to earn its own tab (Rob, 9 jul).
]]

local _, ns = ...

local SIDE_PAD = 14
local TOP_PAD = 12
local LINE_H = 15
local NAME_H = 17
local BTN_H = 22
local MOUNT_GAP = 6

-- Shared status palette (UI.lua). The fallbacks keep this module standalone.
local C = ns.UI_COLORS or {}
local COLOR_DIM = C.dim or { 0.75, 0.78, 0.82 }
local COLOR_GOOD = C.good or { 0.45, 0.95, 0.5 }
local COLOR_SOFT = C.soft or { 0.9, 0.82, 0.45 }
local COLOR_WARN = C.warn or { 1, 0.84, 0.18 }

local ICON_HAVE = "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t "
local ICON_MISS = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t "

local ui

--------------------------------------------------------------------------------
-- Row pools
--------------------------------------------------------------------------------

local function AcquireRow(i)
	local row = ui.rows[i]
	if row then
		return row
	end
	row = CreateFrame("Button", nil, ui.child)
	row:SetHeight(LINE_H)
	local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	fs:SetPoint("LEFT", row, "LEFT", 0, 0)
	fs:SetPoint("RIGHT", row, "RIGHT", 0, 0)
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	row.fs = fs
	ui.rows[i] = row
	return row
end

local function AcquireButton(i)
	local btn = ui.btns[i]
	if btn then
		return btn
	end
	btn = CreateFrame("Button", nil, ui.child, "UIPanelButtonTemplate")
	btn:SetHeight(BTN_H)
	ui.btns[i] = btn
	return btn
end

--------------------------------------------------------------------------------
-- Floating 3D preview (own little window next to Midnight Helper)
--------------------------------------------------------------------------------

local mountPreview
local mountPreviewGen = 0

local function EnsureMountPreview()
	if mountPreview then
		return mountPreview
	end
	local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	f:SetSize(240, 300)
	f:SetFrameStrata("TOOLTIP")
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 20,
			insets = { left = 6, right = 6, top = 6, bottom = 6 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.09, 0.95)
	end
	-- Clip frame keeps the model inside the border even if the display renders large.
	local clip = CreateFrame("Frame", nil, f)
	clip:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -10)
	clip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -10, 10)
	if clip.SetClipsChildren then
		clip:SetClipsChildren(true)
	end
	local model = CreateFrame("PlayerModel", nil, clip)
	model:SetAllPoints(clip)
	model:EnableMouse(false)
	f._model = model
	f:Hide()
	mountPreview = f
	return f
end

local function HideMountPreview()
	if mountPreview then
		mountPreview:Hide()
	end
end

-- Resolve a mount's creatureDisplayID and show it beside the main window.
local function ShowMountPreview(row, mountID)
	local displayID
	if mountID and C_MountJournal and C_MountJournal.GetMountInfoExtraByID then
		local info = { pcall(C_MountJournal.GetMountInfoExtraByID, mountID) }
		if info[1] and type(info[2]) == "number" and info[2] > 0 then
			displayID = info[2] -- creatureDisplayID (1st return value)
		end
	end
	if not displayID then
		HideMountPreview()
		return
	end
	local f = EnsureMountPreview()
	f:ClearAllPoints()
	-- Stick it just to the right of the whole Midnight Helper window; fall back to
	-- anchoring off the hovered row if the main frame isn't available.
	local main = ns.mainUI
	if main then
		f:SetPoint("TOPLEFT", main, "TOPRIGHT", 8, -2)
	else
		f:SetPoint("LEFT", row, "RIGHT", 16, 0)
	end
	mountPreviewGen = mountPreviewGen + 1
	local gen = mountPreviewGen
	-- Async re-apply: the first SetDisplayInfo often renders empty until the model
	-- data streams in (same trick as the boss/rare previews).
	local function apply()
		local mv = f._model
		mv:ClearModel()
		mv:SetDisplayInfo(displayID)
		if mv.SetPortraitZoom then
			pcall(mv.SetPortraitZoom, mv, 0) -- 0 = whole body
		end
		if mv.SetPosition then
			pcall(mv.SetPosition, mv, 0, 0, 0)
		end
		if mv.SetCamDistanceScale then
			pcall(mv.SetCamDistanceScale, mv, 1.8) -- pull the camera back so big mounts fit
		end
		if mv.SetFacing then
			pcall(mv.SetFacing, mv, 0.45)
		end
	end
	if not pcall(apply) then
		HideMountPreview()
		return
	end
	f:Show()
	if C_Timer and C_Timer.After then
		C_Timer.After(0.2, function()
			if gen == mountPreviewGen and f:IsShown() then
				pcall(apply)
			end
		end)
	end
end

--- Screenshot rig (/mh shots): pop the 3D preview for the first mount without a real
--- mouse. Only the preview — no tooltip, which would cover the very list we want shown.
function ns.DevHoverFirstMountRow()
	local row = ui and ui.rows and ui.rows[1]
	if row and row._mhMountID then
		ShowMountPreview(row, row._mhMountID)
	end
end

--- The floating preview frame, so the rig can include it in the crop rectangle.
function ns.DevGetMountPreviewFrame()
	return mountPreview
end

--------------------------------------------------------------------------------
-- Tooltip (near the cursor)
--------------------------------------------------------------------------------

local function ShowMountTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	local ok = false
	local mid = self._mhMountID
	if mid and C_MountJournal and C_MountJournal.GetMountInfoByID and GameTooltip.SetMountBySpellID then
		local info = { pcall(C_MountJournal.GetMountInfoByID, mid) }
		local spellID = info[1] and info[3] -- GetMountInfoByID returns name, spellID, ...
		if spellID then
			ok = pcall(GameTooltip.SetMountBySpellID, GameTooltip, spellID)
		end
	end
	if not ok and self._mhItemID and GameTooltip.SetItemByID then
		ok = pcall(GameTooltip.SetItemByID, GameTooltip, self._mhItemID)
	end
	if not ok and self._mhSpellID and GameTooltip.SetSpellByID then
		ok = pcall(GameTooltip.SetSpellByID, GameTooltip, self._mhSpellID)
	end
	if not ok then
		GameTooltip:SetText(self._mhName or "")
	end
	GameTooltip:Show()
end

-- Row hover: tooltip near the cursor + the floating 3D preview beside the window.
local function OnMountRowEnter(self)
	ShowMountTooltip(self)
	ShowMountPreview(self, self._mhMountID)
end

local function OnMountRowLeave()
	GameTooltip:Hide()
	HideMountPreview()
end

-- How-to rows that mention a currency (Voidlight Marl) hover Blizzard's own currency
-- tooltip, so you can see your balance without leaving the tab.
local function OnCurrencyRowEnter(self)
	if not self._mhCurrency then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	if GameTooltip.SetCurrencyByID then
		pcall(GameTooltip.SetCurrencyByID, GameTooltip, self._mhCurrency)
	end
	GameTooltip:Show()
end

--------------------------------------------------------------------------------
-- List
--------------------------------------------------------------------------------

-- Lay out one text row at vertical offset y; returns the height it consumed. Pass a
-- `tip` table { mountID, itemID, spellID, name } to make the row hover a preview.
local function PutRow(i, text, color, bold, y, width, tip, currencyID)
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local row = AcquireRow(i)
	row.fs:SetFontObject(ns.MHScalableFont(bold and "GameFontNormal" or "GameFontHighlightSmall"))
	row.fs:SetText(text or "")
	local c = color or COLOR_DIM
	row.fs:SetTextColor(c[1], c[2], c[3])
	row:ClearAllPoints()
	row:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
	row:SetWidth(width)
	local base = (bold and NAME_H or LINE_H) * s
	local th = (row.fs.GetStringHeight and row.fs:GetStringHeight()) or 0
	row:SetHeight(math.max(base, th + 2))
	if tip then
		row._mhMountID = tip.mountID
		row._mhItemID = tip.itemID
		row._mhSpellID = tip.spellID
		row._mhName = tip.name
		row._mhCurrency = nil
		row:EnableMouse(true)
		row:SetScript("OnEnter", OnMountRowEnter)
		row:SetScript("OnLeave", OnMountRowLeave)
	elseif currencyID then
		row._mhCurrency = currencyID
		row._mhMountID, row._mhItemID, row._mhSpellID = nil, nil, nil
		row:EnableMouse(true)
		row:SetScript("OnEnter", OnCurrencyRowEnter)
		row:SetScript("OnLeave", OnMountRowLeave)
	else
		row:EnableMouse(false)
		row:SetScript("OnEnter", nil)
		row:SetScript("OnLeave", nil)
	end
	row:Show()
	return row:GetHeight()
end

function ns.RefreshMountsPanel()
	if not ui or not ui.child then
		return
	end
	local width = math.max((ui.child:GetWidth() or 400), 1)
	local y = 0
	local ri, bi = 1, 1

	local mounts = ns.GetWeeklyMountProgress and ns.GetWeeklyMountProgress(true) or {}
	if not mounts or #mounts == 0 then
		y = y + PutRow(ri, ns:L("MOUNTS_PANEL_EMPTY"), COLOR_GOOD, false, y, width)
		ri = ri + 1
	else
		-- In-progress first, then a "Collected" header with the ones you already own.
		local ordered = {}
		for _, m in ipairs(mounts) do
			if not m.collected then
				ordered[#ordered + 1] = m
			end
		end
		for _, m in ipairs(mounts) do
			if m.collected then
				ordered[#ordered + 1] = m
			end
		end

		local collectedHeaderShown = false
		for _, m in ipairs(ordered) do
			if m.collected and not collectedHeaderShown then
				collectedHeaderShown = true
				y = y + MOUNT_GAP
				y = y + PutRow(ri, ns:L("MOUNTS_PANEL_COLLECTED_HEADER"), COLOR_DIM, true, y, width)
				ri = ri + 1
			end

			local nameText, color
			if m.collected then
				nameText = ICON_HAVE .. m.name
				color = COLOR_GOOD
			elseif m.need then
				nameText = ICON_MISS .. ns:L("HOME_COLLECTIBLE_FMT"):format(m.name, m.have, m.need)
				-- Green once the requirement is met (ready to grab), yellow while short.
				color = (m.have >= m.need) and COLOR_GOOD or COLOR_SOFT
			else
				-- No honest X-of-N (RNG hunt / puzzle): just the name behind the cross.
				nameText = ICON_MISS .. m.name
				color = COLOR_SOFT
			end
			y = y + PutRow(ri, nameText, color, true, y, width,
				{ mountID = m.mountID, itemID = m.mountItemID, spellID = m.mountSpellID, name = m.name })
			ri = ri + 1

			-- Collected mounts need no how-to / route — just the ✓ line.
			if not m.collected then
				if m.howToKey then
					y = y + PutRow(ri, ns:L(m.howToKey), COLOR_DIM, false, y, width, nil, m.currencyID)
					ri = ri + 1
				end
				if m.route and ns.AddSmartTomTomWay then
					local rname = ns:L(m.route.nameKey or "")
					local btn = AcquireButton(bi)
					bi = bi + 1
					y = y + 4
					btn:ClearAllPoints()
					btn:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 0, -y)
					btn:SetText(ns:L("MOUNTPROG_ROUTE_BTN_FMT"):format(rname))
					local tw = (btn.GetTextWidth and btn:GetTextWidth() or 160) + 28
					btn:SetWidth(math.min(math.max(tw, 120), width))
					btn:SetScript("OnClick", function()
						if ns.MH_TomTomClearAll then
							ns.MH_TomTomClearAll()
						end
						ns.AddSmartTomTomWay(m.route.mapID, m.route.x, m.route.y, rname)
					end)
					btn:Show()
					y = y + BTN_H
				end
			end
			y = y + MOUNT_GAP
		end
	end

	-- Whole-collection farming across every expansion is a different job than this
	-- current-season checklist — point serious collectors at the specialist addon
	-- (honest referral, no overlap, nothing copied from it).
	y = y + MOUNT_GAP + 4
	y = y + PutRow(ri, ns:L("MOUNTS_MRP_HINT"), COLOR_DIM, false, y, width)
	ri = ri + 1

	for i = ri, #ui.rows do
		ui.rows[i]:Hide()
	end
	for i = bi, #ui.btns do
		ui.btns[i]:Hide()
	end
	ui.child:SetHeight(math.max(y + 8, 1))
end

function ns.BuildMountsPanel(panel)
	if not panel or panel._mhMountsBuilt then
		return
	end
	panel._mhMountsBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("TAB_MOUNTS"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	subtitle:SetText(ns:L("MOUNTS_PANEL_SUBTITLE"))

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperMountsScroll", panel, "UIPanelScrollFrameTemplate")
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
		btns = {},
	}

	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
		end
		if panel:IsShown() then
			ns.RefreshMountsPanel()
		end
	end
	scroll:SetScript("OnSizeChanged", syncWidth)
	syncWidth()

	panel:SetScript("OnShow", function()
		syncWidth()
		ns.RefreshMountsPanel()
	end)
	panel:SetScript("OnHide", HideMountPreview)

	ns.MountsPanel = panel
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_MOUNTS"))
		end
		if ui and ui.subtitle then
			ui.subtitle:SetText(ns:L("MOUNTS_PANEL_SUBTITLE"))
		end
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshMountsPanel()
		end
	end
end

-- Refresh when anything that changes progress fires (guarded: unknown event names
-- on a given client just no-op instead of erroring).
local ev = CreateFrame("Frame")
for _, e in ipairs({
	"PLAYER_ENTERING_WORLD",
	"BAG_UPDATE_DELAYED",
	"ACHIEVEMENT_EARNED",
	"CRITERIA_UPDATE",
	"MAJOR_FACTION_RENOWN_LEVEL_CHANGED",
	"NEW_MOUNT_ADDED",
}) do
	pcall(ev.RegisterEvent, ev, e)
end
ev:SetScript("OnEvent", function()
	if ui and ui.panel and ui.panel:IsShown() then
		ns.RefreshMountsPanel()
	end
end)
