--[[
	Events-tab (fase A, vervolg op het Broker_MidnightEvents-absorptieplan).
	Een eigen tabblad met ÁLLE Midnight wereld-events — los van Void & Rituals
	(dat blijft puur Ritual Sites + Void Assaults) en los van Home.

	Twee secties: "Nu bezig" (goud, klikbaar met route als we coords kennen) en
	"Komt eraan" (gedimd, met resttijd). Hover toont wat het event is + wat het
	oplevert (EventInfoData). Data komt read-only uit de taint-veilige getters
	ns.GetOngoingWorldEvents()/GetUpcomingWorldEvents().

	Never-lie: we tonen alleen wat de scheduler teruggeeft; geen data = niets.
]]

local _, ns = ...

local SIDE_PAD, TOP_PAD = 16, 12
local EVENT_LINE_H = 16
local NOW_POOL = 4   -- zelden meer dan 2-3 lopende events
local SOON_POOL = 10 -- geplande events (24u)

local COLOR_HEADER = { 1, 0.82, 0.0 }
local COLOR_DIM = { 0.6, 0.62, 0.68 }
local COLOR_GOLD = { 1, 0.84, 0.18 }

local ui

--------------------------------------------------------------------- Layout
local function Relayout()
	if not ui or not ui.child then
		return
	end
	local width = ui.child:GetWidth()
	if not width or width <= 0 then
		return
	end
	local y = 4
	for _, el in ipairs(ui.order) do
		local w = el.w
		if w:IsShown() then
			local indent = el.indent or 0
			y = y + (el.gapTop or 0)
			w:ClearAllPoints()
			w:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent, -y)
			w:SetWidth(math.max(width - indent, 1))
			if el.line then
				y = y + EVENT_LINE_H
			else
				y = y + math.max(w:GetStringHeight() or 0, 1)
			end
		end
	end
	ui.child:SetHeight(math.max(y + 8, 1))
end

--------------------------------------------------------------------- Helpers
local function MakeFS(parent, font, color)
	local fs = parent:CreateFontString(nil, "OVERLAY", font)
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	if color then
		fs:SetTextColor(color[1], color[2], color[3])
	end
	return fs
end

local function MakeEventLine(parent)
	local btn = CreateFrame("Button", nil, parent)
	btn:SetHeight(EVENT_LINE_H)
	local label = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	label:SetJustifyH("LEFT")
	label:SetWordWrap(false)
	label:SetPoint("LEFT", btn, "LEFT", 0, 0)
	label:SetPoint("RIGHT", btn, "RIGHT", 0, 0)
	btn.label = label
	btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	local hl = btn:GetHighlightTexture()
	if hl then
		hl:SetAllPoints(btn)
	end
	btn:SetScript("OnEnter", function(self)
		local e, info = self._mhEvent, self._mhInfo
		if not e then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(tostring(e.name or ""), 1, 0.84, 0.18)
		if e.zoneName then
			GameTooltip:AddLine(tostring(e.zoneName), 0.7, 0.7, 0.7)
		end
		if info then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(ns:L(info.descKey), 1, 1, 1, true)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(ns:L("EVENT_INFO_REWARD_LABEL"), 1, 0.82, 0)
			GameTooltip:AddLine(ns:L(info.rewardKey), 0.8, 0.9, 0.8, true)
		end
		if self._mhClickable then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(ns:L("EVENT_INFO_CLICK_HINT"), 0.5, 0.8, 1)
		end
		GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	btn:EnableMouse(false)
	btn:Hide()
	return btn
end

-- Vul één regel-knop met een event (now=goud+klikbaar, soon=gedimd).
local function FillLine(btn, e, isNow)
	local label = btn.label
	local info = (e.areaPoiID and ns.GetEventInfo) and ns.GetEventInfo(e.areaPoiID) or nil
	local clickable = (isNow and e.uiMapID and e.posX and e.posY) and true or false

	if isNow then
		local txt = tostring(e.name or "?")
		if e.zoneName then
			txt = txt .. " \226\128\148 " .. tostring(e.zoneName) -- em-dash
		end
		if clickable then
			txt = txt .. "  |TInterface\\Icons\\INV_Misc_Map_01:12:12|t"
		end
		label:SetText(txt)
		label:SetTextColor(COLOR_GOLD[1], COLOR_GOLD[2], COLOR_GOLD[3])
	else
		label:SetText(ns:L("WORLD_EVENT_SOON_FMT"):format(
			tostring(e.name or "?"),
			tostring(e.zoneName or "?"),
			(ns.FormatEventDuration and ns.FormatEventDuration(e.inSeconds)) or "?"))
		label:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	end

	btn._mhEvent = e
	btn._mhInfo = info
	btn._mhClickable = clickable
	if clickable then
		local mapID, x, y, nm = e.uiMapID, e.posX, e.posY, e.name
		btn:SetScript("OnClick", function()
			if ns.AddSmartTomTomWay then
				ns.AddSmartTomTomWay(mapID, x, y, nm)
			end
		end)
	else
		btn:SetScript("OnClick", nil)
	end
	btn:EnableMouse(clickable or info ~= nil)
	btn:Show()
end

local function HideLine(btn)
	btn._mhEvent = nil
	btn._mhInfo = nil
	btn._mhClickable = nil
	btn:EnableMouse(false)
	btn:SetScript("OnClick", nil)
	btn:Hide()
end

----------------------------------------------------------------------- Refresh
function ns.RefreshEventsPanel()
	if not ui or not ui.panel or not ui.panel:IsVisible() then
		return
	end

	-- Titels/labels (her)zetten zodat een taalwissel meteen doorkomt.
	ui.title:SetText(ns:L("TAB_EVENTS"))
	ui.subtitle:SetText(ns:L("EVENTS_SUBTITLE"))
	ui.nowHeader:SetText(ns:L("WORLD_EVENTS_NOW"))
	ui.soonHeader:SetText(ns:L("WORLD_EVENTS_SOON"))

	local ongoing = (ns.GetOngoingWorldEvents and ns.GetOngoingWorldEvents()) or {}
	local upcoming = (ns.GetUpcomingWorldEvents and ns.GetUpcomingWorldEvents()) or {}

	ui.nowHeader:SetShown(#ongoing > 0)
	for i, btn in ipairs(ui.nowLines) do
		local e = ongoing[i]
		if e then
			FillLine(btn, e, true)
		else
			HideLine(btn)
		end
	end

	ui.soonHeader:SetShown(#upcoming > 0)
	for i, btn in ipairs(ui.soonLines) do
		local e = upcoming[i]
		if e then
			FillLine(btn, e, false)
		else
			HideLine(btn)
		end
	end

	if #ongoing == 0 and #upcoming == 0 then
		ui.emptyFs:SetText(ns:L("EVENTS_NONE"))
		ui.emptyFs:Show()
	else
		ui.emptyFs:Hide()
	end

	Relayout()
end

------------------------------------------------------------------------- Build
function ns.BuildEventsPanel(panel)
	if not panel or panel._mhEventsBuilt then
		return
	end
	panel._mhEventsBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("TAB_EVENTS"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	subtitle:SetText(ns:L("EVENTS_SUBTITLE"))

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperEventsScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -10)
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
		order = {},
		nowLines = {},
		soonLines = {},
	}

	local function push(w, gapTop, indent, line)
		ui.order[#ui.order + 1] = { w = w, gapTop = gapTop, indent = indent, line = line }
	end

	ui.nowHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	ui.nowHeader:SetText(ns:L("WORLD_EVENTS_NOW"))
	push(ui.nowHeader, 2, 0)
	for i = 1, NOW_POOL do
		local btn = MakeEventLine(child)
		push(btn, i == 1 and 6 or 2, 8, true)
		ui.nowLines[i] = btn
	end

	ui.soonHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	ui.soonHeader:SetText(ns:L("WORLD_EVENTS_SOON"))
	push(ui.soonHeader, 14, 0)
	for i = 1, SOON_POOL do
		local btn = MakeEventLine(child)
		push(btn, i == 1 and 6 or 2, 8, true)
		ui.soonLines[i] = btn
	end

	ui.emptyFs = MakeFS(child, "GameFontDisableSmall", COLOR_DIM)
	ui.emptyFs:SetText(ns:L("EVENTS_NONE"))
	push(ui.emptyFs, 8, 0)

	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
			Relayout()
		end
	end
	scroll:SetScript("OnSizeChanged", syncWidth)
	syncWidth()

	panel:SetScript("OnShow", function()
		syncWidth()
		ns.RefreshEventsPanel()
	end)

	-- Live meelopen terwijl de tab open is (data ververst elke ~5s in de
	-- EventScheduler-ticker; hier alleen opnieuw renderen).
	local acc = 0
	panel:SetScript("OnUpdate", function(self, dt)
		acc = acc + (dt or 0)
		if acc >= 2 then
			acc = 0
			if self:IsVisible() then
				ns.RefreshEventsPanel()
			end
		end
	end)

	ns.EventsPanel = panel
	ns.RefreshEventsPanel()
end

-- Taalwissel: titel/subtitel/headers meenemen (regels herbouwen bij refresh).
do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_EVENTS"))
			ui.subtitle:SetText(ns:L("EVENTS_SUBTITLE"))
			ui.nowHeader:SetText(ns:L("WORLD_EVENTS_NOW"))
			ui.soonHeader:SetText(ns:L("WORLD_EVENTS_SOON"))
			if ui.panel and ui.panel:IsVisible() then
				ns.RefreshEventsPanel()
			end
		end
	end
end
