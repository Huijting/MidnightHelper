--[[
	Midnight Helper — 4.0 room card grid (Spec 37 concept A, part 2).

	Rob, 12 Sep 2026, after the mock-up: "doe maar 1 en 2". Clicking a sidebar room (Me / Codex /
	Tools) opens a grid: one card per screen with its icon, its name and, where a screen offers
	one, a single live status line (ns.RoomCardStatus). Hovering a card shows the screen's
	tagline; clicking opens the screen.

	The card list comes from the sidebar model itself (ns._mhSidebarSections plus the sidebar's
	own visibility test, shared by UI.lua), so a card can never lead to a screen the sidebar
	hides. Tools shows the Toolbox's sub-tabs as their own cards; SelectTab already routes those
	ids. A room with a single screen (Settings) and the Classic look keep the 3.x behaviour: the
	room button opens the room's first tab, and this file stays idle.

	Colours live in LOOK below so the palette decision (Rob asked for something fresher) is one
	edit, not a hunt.
]]

local addonName, ns = ...

--- Screen id -> function returning one short status line (or nil). Filled by the screens'
--- own data; a provider that errors or returns nothing just leaves the line empty.
ns.RoomCardStatus = ns.RoomCardStatus or {}

local CARD_MIN_W = 138
local CARD_H = 116
local GAP = 10
local ICON = 56

-- Palette C "Twilight lantern" (Rob's pick, 12 Sep), read from the shell's ns.LOOK_PALETTE;
-- the literals are fallbacks and the one card-only shade (the window colour, a step lighter).
local function Palette()
	local p = ns.LOOK_PALETTE or {}
	local header = p.header or { 0.957, 0.871, 0.604 }
	local accent = p.accent or { 0.788, 0.659, 1.0 }
	return {
		cardBg = { 0.153, 0.129, 0.271, 0.96 },
		cardEdge = p.hover or { 0.165, 0.129, 0.314, 1 },
		iconEdge = { header[1], header[2], header[3], 0.95 },
		hover = { accent[1], accent[2], accent[3], 0.12 },
		name = header,
		status = p.muted or { 0.722, 0.682, 0.859 },
	}
end

local TOOLS_CARDS = {
	{ id = "toolslaunch" },
	{ id = "consumables", screen = "consumables", labelKey = "TAB_CONSUMABLES" },
	{ id = "macros", screen = "macros", labelKey = "TAB_MACROS", beta = "macros" },
	{ id = "academy", screen = "academy", labelKey = "TAB_ACADEMY", beta = "academy" },
	-- "profoverview" lands on the hub's Overview, where Knowledge is spent; see SelectTab.
	{ id = "profoverview", screen = "professionsHub", labelKey = "TAB_PROFESSIONS" },
	{ id = "addons" },
}

local function TabVisible(id)
	if ns._mhSidebarTabVisible then
		return ns._mhSidebarTabVisible(id)
	end
	return true
end

local function CardsForRoom(roomId)
	local list = {}
	if roomId == "tools" then
		for _, c in ipairs(TOOLS_CARDS) do
			local ok = true
			if c.beta then
				ok = not ns.IsBetaTabEnabled or ns.IsBetaTabEnabled(c.beta)
			elseif not c.screen then
				ok = TabVisible(c.id) and ns.panels and ns.panels[c.id] ~= nil
			end
			if ok then
				list[#list + 1] = c
			end
		end
		return list
	end
	for _, section in ipairs(ns._mhSidebarSections or {}) do
		if section.room == roomId then
			for _, id in ipairs(section.ids) do
				if TabVisible(id) and ns.panels and ns.panels[id] then
					list[#list + 1] = { id = id }
				end
			end
		end
	end
	return list
end

local function MakeCard(parent)
	local LOOK = Palette()
	local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
	b:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	b:SetBackdropColor(unpack(LOOK.cardBg))
	b:SetBackdropBorderColor(unpack(LOOK.cardEdge))

	local icon = b:CreateTexture(nil, "ARTWORK")
	icon:SetSize(ICON, ICON)
	icon:SetPoint("TOP", b, "TOP", 0, -10)
	local edge = CreateFrame("Frame", nil, b, "BackdropTemplate")
	edge:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
	edge:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
	edge:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	edge:SetBackdropBorderColor(unpack(LOOK.iconEdge))

	local name = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	name:SetPoint("TOP", icon, "BOTTOM", 0, -7)
	name:SetPoint("LEFT", b, "LEFT", 6, 0)
	name:SetPoint("RIGHT", b, "RIGHT", -6, 0)
	name:SetJustifyH("CENTER")
	name:SetWordWrap(false)
	name:SetTextColor(LOOK.name[1], LOOK.name[2], LOOK.name[3])

	local status = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	status:SetPoint("TOP", name, "BOTTOM", 0, -3)
	status:SetPoint("LEFT", b, "LEFT", 6, 0)
	status:SetPoint("RIGHT", b, "RIGHT", -6, 0)
	status:SetJustifyH("CENTER")
	status:SetWordWrap(false)
	status:SetTextColor(unpack(LOOK.status))

	local hl = b:CreateTexture(nil, "HIGHLIGHT")
	hl:SetAllPoints()
	hl:SetColorTexture(unpack(LOOK.hover))

	b._mhIcon, b._mhName, b._mhStatus = icon, name, status
	b:SetScript("OnClick", function(self)
		if self._mhTarget and ns.SelectTab then
			ns.SelectTab(self._mhTarget)
		end
	end)
	b:SetScript("OnEnter", function(self)
		if not self._mhTagline then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(self._mhName:GetText() or "", 1, 0.82, 0)
		GameTooltip:AddLine(ns:L(self._mhTagline), 0.92, 0.92, 0.92, true)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", GameTooltip_Hide)
	return b
end

local function StatusFor(screenId)
	local fn = ns.RoomCardStatus[screenId]
	if not fn then
		return ""
	end
	local ok, s = pcall(fn)
	if ok and type(s) == "string" then
		return s
	end
	return ""
end

local function Layout(panel)
	local roomId = panel._mhRoom
	local roomDef = ns._mhSidebarRoomById and ns._mhSidebarRoomById[roomId]
	panel._mhTitle:SetText((roomDef and ns:L(roomDef.labelKey)) or roomId)

	local width = panel._mhScroll:GetWidth()
	if not width or width < 50 then
		return
	end
	local cols = math.max(1, math.floor((width + GAP) / (CARD_MIN_W + GAP)))
	local cardW = math.floor((width - GAP * (cols - 1)) / cols)
	local cards = CardsForRoom(roomId)
	local screens = ns._mhLookScreens or {}

	for i, c in ipairs(cards) do
		local b = panel._mhCards[i]
		if not b then
			b = MakeCard(panel._mhBody)
			panel._mhCards[i] = b
		end
		local col = (i - 1) % cols
		local row = math.floor((i - 1) / cols)
		b:ClearAllPoints()
		b:SetSize(cardW, CARD_H)
		b:SetPoint("TOPLEFT", panel._mhBody, "TOPLEFT", col * (cardW + GAP), -row * (CARD_H + GAP))
		local screenId = c.screen or c.id
		local screen = screens[screenId]
		if screen and ns._mhLookIconPath then
			b._mhIcon:SetTexture(ns._mhLookIconPath:format(screen.stem))
		else
			b._mhIcon:SetTexture(nil)
		end
		local labelKey = c.labelKey or (ns._mhTabLabelById and ns._mhTabLabelById[c.id])
		b._mhName:SetText((labelKey and ns:L(labelKey)) or c.id)
		b._mhTagline = screen and screen.tagline
		b._mhTarget = c.id
		b._mhStatus:SetText(StatusFor(screenId))
		b:Show()
	end
	for i = #cards + 1, #panel._mhCards do
		panel._mhCards[i]:Hide()
	end
	local rows = math.ceil(#cards / cols)
	local bodyH = math.max(1, rows * (CARD_H + GAP))
	panel._mhBody:SetSize(width, bodyH)
	-- No scroll bar while every card fits (Rob, 12 Sep: "verberg de schuifbalk maar"); it comes
	-- back as soon as the window is too short for the grid.
	local bar = panel._mhScroll.ScrollBar
	if bar then
		local fits = bodyH <= (panel._mhScroll:GetHeight() or 0)
		bar:SetShown(not fits)
		if fits then
			panel._mhScroll:SetVerticalScroll(0)
		end
	end
end

local function EnsurePanel(roomId)
	local pid = "room_" .. roomId
	if ns.panels and ns.panels[pid] then
		return ns.panels[pid]
	end
	local refs = ns._mhLayoutRefs
	if not (refs and refs.content and ns.panels) then
		return nil
	end
	local panel = CreateFrame("Frame", nil, refs.content)
	panel:SetAllPoints()
	panel:Hide()

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -12)
	local header = Palette().name
	title:SetTextColor(header[1], header[2], header[3])
	panel._mhTitle = title

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 10)
	-- The template's own range handler hides the bar at zero range when this is set; Layout
	-- decides as well, so the bar is right whichever runs last.
	scroll.scrollBarHideable = true
	local body = CreateFrame("Frame", nil, scroll)
	body:SetSize(1, 1)
	scroll:SetScrollChild(body)

	panel._mhRoom = roomId
	panel._mhScroll = scroll
	panel._mhBody = body
	panel._mhCards = {}
	panel:SetScript("OnShow", Layout)
	scroll:SetScript("OnSizeChanged", function()
		if panel:IsShown() then
			Layout(panel)
		end
	end)
	ns.panels[pid] = panel
	return panel
end

--- Opens the room's card grid. Returns false when the room button should keep its 3.x
--- behaviour: Classic look, or a room with fewer than two screens.
function ns:OpenRoomLauncher(roomId)
	if self.IsClassicLookEnabled and self:IsClassicLookEnabled() then
		return false
	end
	if #CardsForRoom(roomId) < 2 then
		return false
	end
	if not EnsurePanel(roomId) or not self.SelectTab then
		return false
	end
	self.SelectTab("room_" .. roomId)
	return true
end

--------------------------------------------------------------------------------
-- Status lines. Only screens whose data the addon ALREADY reads cheaply (UI map of
-- 12 Sep 2026); everything else keeps an empty line rather than a guess. A provider
-- whose source reports "unreadable" returns nil: a card claiming 0 for data it could
-- not read would be worse than a blank line. One fact per line, so it fits a card.
--------------------------------------------------------------------------------
local S = ns.RoomCardStatus

local function CountEntries(t)
	local n = 0
	for _ in pairs(t) do
		n = n + 1
	end
	return n
end

S.home = function()
	if not ns.GetNextWeeklyAction then
		return nil
	end
	local _, done, total = ns.GetNextWeeklyAction()
	if type(total) == "number" and total > 0 then
		return ns:L("ROOMCARD_WEEK_FMT"):format(done or 0, total)
	end
	return nil
end

-- This character's own snapshot, the same fields the Account snapshot's Vault column adds up.
S.delves = function()
	local guid = UnitGUID and UnitGUID("player")
	local snap = guid and ns.db and ns.db.charCurrencies and ns.db.charCurrencies[guid]
	if type(snap) ~= "table" then
		return nil
	end
	local unlocked = (tonumber(snap.vaultWorldUnlocked) or tonumber(snap.vaultUnlocked) or 0)
		+ (tonumber(snap.vaultDungeonUnlocked) or 0) + (tonumber(snap.vaultRaidUnlocked) or 0)
	local total = (tonumber(snap.vaultWorldTotal) or tonumber(snap.vaultTotal) or 0)
		+ (tonumber(snap.vaultDungeonTotal) or 0) + (tonumber(snap.vaultRaidTotal) or 0)
	if total > 0 then
		return ns:L("ROOMCARD_VAULT_FMT"):format(unlocked, total)
	end
	return nil
end

S.world = function()
	if not (ns.IsRitualWeeklyDone and ns.IsVoidAssaultWeeklyDone) then
		return nil
	end
	local n = (ns.IsRitualWeeklyDone() == true and 1 or 0) + (ns.IsVoidAssaultWeeklyDone() == true and 1 or 0)
	return ns:L("ROOMCARD_WEEKLIES_FMT"):format(n, 2)
end

S.events = function()
	if not (ns.GetOngoingWorldEvents and ns.GetWorldEventsLastScan) or not ns.GetWorldEventsLastScan() then
		return nil -- no scan yet: "0 live" would be a claim without a reading
	end
	local list = ns.GetOngoingWorldEvents()
	if type(list) ~= "table" then
		return nil
	end
	return ns:L("ROOMCARD_EVENTS_NOW_FMT"):format(CountEntries(list))
end

S.enchants = function()
	if not ns.GetGearEnchantSummary then
		return nil
	end
	local missing, sockets = ns.GetGearEnchantSummary()
	if missing == nil then
		return nil
	end
	if missing > 0 then
		return ns:L("ROOMCARD_ENCHANTS_MISSING_FMT"):format(missing)
	end
	if (sockets or 0) > 0 then
		return ns:L("ROOMCARD_SOCKETS_EMPTY_FMT"):format(sockets)
	end
	return ns:L("ROOMCARD_ENCHANTS_OK")
end

S.tier = function()
	if not ns.GetTierSetSummary then
		return nil
	end
	local worn, size = ns.GetTierSetSummary()
	if worn then
		return ns:L("ROOMCARD_TIER_FMT"):format(worn, size or 5)
	end
	return nil
end

-- Same filter as the vault reminder: a real player GUID with a stored name.
S.account = function()
	local bag = ns.db and ns.db.charCurrencies
	if type(bag) ~= "table" then
		return nil
	end
	local n = 0
	for guid, snap in pairs(bag) do
		if type(guid) == "string" and guid:match("^Player%-") and type(snap) == "table"
			and type(snap.name) == "string" and snap.name ~= "" and snap.name ~= "?" then
			n = n + 1
		end
	end
	if n > 0 then
		return ns:L("ROOMCARD_CHARS_FMT"):format(n)
	end
	return nil
end

S.raids = function()
	if not ns.GetRaidCoachSummary then
		return nil
	end
	local _, bosses = ns.GetRaidCoachSummary()
	if type(bosses) == "number" and bosses > 0 then
		return ns:L("ROOMCARD_BOSSES_FMT"):format(bosses)
	end
	return nil
end

S.professionsHub = function()
	if not ns.GetProfessionKnowledgeStatus then
		return nil
	end
	local sum, anyReadable = 0, false
	for _, p in ipairs(ns.GetProfessionKnowledgeStatus() or {}) do
		if p.readable then
			anyReadable = true
			sum = sum + (tonumber(p.unspent) or 0)
		end
	end
	if not anyReadable then
		return nil
	end
	if sum > 0 then
		return ns:L("ROOMCARD_KP_FMT"):format(sum)
	end
	return ns:L("ROOMCARD_KP_NONE")
end
