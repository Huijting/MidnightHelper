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

	Show/hide (Rob, 13 Sep 2026: "waarom laten we ze zelf niet dingen aan en uit zetten"):
	right-clicking a card hides that screen (ns.SetScreenHidden, Core.lua). The way back sits in
	the same room as the button: a line under the cards counts the hidden screens and offers them
	again. Settings -> Screens has the full list.

	Order (Rob, 13 Sep 2026: "kunnen we dit door users laten verplaatsen naar hun zin?" → "bouw
	het slepen maar"): drag a card to a new place in its room. Each room remembers its own order;
	right-click offers "Reset the order". Cards stay in their room, and Classic keeps 3.x.
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

-- Can the screen exist here (client, beta switch)? The player's own show/hide is asked
-- separately, so a hidden screen can still be offered back.
local function TabAvailable(id)
	if ns._mhSidebarTabAvailable then
		return ns._mhSidebarTabAvailable(id)
	end
	if ns._mhSidebarTabVisible then
		return ns._mhSidebarTabVisible(id)
	end
	return true
end

local function ScreenOf(c)
	return c.screen or c.id
end

local function CardLabel(c)
	local labelKey = c.labelKey or (ns._mhTabLabelById and ns._mhTabLabelById[c.id])
	return (labelKey and ns:L(labelKey)) or c.id
end

--- The room's screens as two lists: the cards to draw, and the ones the player hid (for the
--- "show again" line). A screen the client or a beta switch takes away is in neither.
local function CardsForRoom(roomId)
	local shown, hidden = {}, {}
	local function add(c)
		if ns.IsScreenHidden and ns.IsScreenHidden(ScreenOf(c)) then
			hidden[#hidden + 1] = c
		else
			shown[#shown + 1] = c
		end
	end
	if roomId == "tools" then
		for _, c in ipairs(TOOLS_CARDS) do
			local ok = true
			if c.beta then
				ok = not ns.IsBetaTabEnabled or ns.IsBetaTabEnabled(c.beta)
			elseif not c.screen then
				ok = TabAvailable(c.id) and ns.panels and ns.panels[c.id] ~= nil
			end
			if ok then
				add(c)
			end
		end
		return shown, hidden
	end
	for _, section in ipairs(ns._mhSidebarSections or {}) do
		if section.room == roomId then
			for _, id in ipairs(section.ids) do
				if TabAvailable(id) and ns.panels and ns.panels[id] then
					add({ id = id })
				end
			end
		end
	end
	return shown, hidden
end

--------------------------------------------------------------------------------
-- Card order. Each room keeps its own list of card ids in ns.db.ui.cardOrder[room], stored on
-- demand. A card the list does not know yet (new in an update) comes after the ordered ones,
-- in its default place among the others.
--------------------------------------------------------------------------------
local function SavedOrder(roomId)
	local ui = ns.db and ns.db.ui
	local t = type(ui) == "table" and type(ui.cardOrder) == "table" and ui.cardOrder[roomId]
	return type(t) == "table" and t or nil
end

local function OrderedCards(roomId, cards)
	local saved = SavedOrder(roomId)
	if not saved then
		return cards
	end
	local rank = {}
	for i, id in ipairs(saved) do
		rank[id] = rank[id] or i
	end
	local known, unknown = {}, {}
	for _, c in ipairs(cards) do
		if rank[c.id] then
			known[#known + 1] = c
		else
			unknown[#unknown + 1] = c
		end
	end
	table.sort(known, function(a, b)
		return rank[a.id] < rank[b.id]
	end)
	for _, c in ipairs(unknown) do
		known[#known + 1] = c
	end
	return known
end

local function ResetOrder(roomId)
	local ui = ns.db and ns.db.ui
	if type(ui) == "table" and type(ui.cardOrder) == "table" then
		ui.cardOrder[roomId] = nil
	end
	if ns.RefreshRoomLauncher then
		ns.RefreshRoomLauncher()
	end
end

-- Where slot n (1-based) sits in the grid Layout last measured.
local function SlotPoint(panel, slot)
	local g = panel._mhGeom
	local col = (slot - 1) % g.cols
	local row = math.floor((slot - 1) / g.cols)
	return col * (g.cardW + GAP), -row * (CARD_H + GAP)
end

--- Puts every card in its slot. While a card is dragged it follows the cursor, and the others
--- close up around the slot it would drop into.
local function PlaceCards(panel)
	if not (panel._mhGeom and panel._mhOrder) then
		return
	end
	local drag = panel._mhDrag
	local slot = 0
	for _, b in ipairs(panel._mhOrder) do
		if not (drag and b == drag.btn) then
			slot = slot + 1
			if drag and slot == drag.to then
				slot = slot + 1
			end
			local x, y = SlotPoint(panel, slot)
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", panel._mhBody, "TOPLEFT", x, y)
		end
	end
end

local function CursorInBody(panel)
	local body = panel._mhBody
	local left, top = body:GetLeft(), body:GetTop()
	if not (left and top) then
		return nil
	end
	local scale = body:GetEffectiveScale()
	local cx, cy = GetCursorPosition()
	return cx / scale - left, top - cy / scale
end

local function SlotAt(panel, x, y)
	local g = panel._mhGeom
	local col = math.min(g.cols - 1, math.max(0, math.floor(x / (g.cardW + GAP))))
	local row = math.max(0, math.floor(y / (CARD_H + GAP)))
	return math.max(1, math.min(#panel._mhOrder, row * g.cols + col + 1))
end

local function SaveOrder(panel)
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return
	end
	if type(ui.cardOrder) ~= "table" then
		ui.cardOrder = {}
	end
	local ids, seen = {}, {}
	for _, b in ipairs(panel._mhOrder) do
		ids[#ids + 1] = b._mhTarget
		seen[b._mhTarget] = true
	end
	-- Hidden cards keep their entry (after the rest), so the list stays whole.
	for _, id in ipairs(SavedOrder(panel._mhRoom) or {}) do
		if not seen[id] then
			ids[#ids + 1] = id
			seen[id] = true
		end
	end
	ui.cardOrder[panel._mhRoom] = ids
end

local function StartCardDrag(b)
	local panel = b._mhPanel
	if not (panel and panel._mhGeom and panel._mhOrder) or panel._mhDrag then
		return
	end
	local from
	for i, x in ipairs(panel._mhOrder) do
		if x == b then
			from = i
		end
	end
	if not from then
		return
	end
	GameTooltip:Hide()
	panel._mhDrag = { btn = b, from = from, to = from }
	b._mhLevel = b:GetFrameLevel()
	b:SetFrameLevel(b._mhLevel + 20)
	b:SetAlpha(0.85)
	b:SetScript("OnUpdate", function(self)
		local drag = panel._mhDrag
		local x, y = CursorInBody(panel)
		if not (drag and x) then
			return
		end
		self:ClearAllPoints()
		self:SetPoint("CENTER", panel._mhBody, "TOPLEFT", x, -y)
		local to = SlotAt(panel, x, y)
		if to ~= drag.to then
			drag.to = to
			PlaceCards(panel)
		end
	end)
end

--- Drops the dragged card (save) or puts it back (the panel hid, or re-laid out mid-drag).
local function EndCardDrag(panel, save)
	local drag = panel and panel._mhDrag
	if not drag then
		return
	end
	local b = drag.btn
	panel._mhDrag = nil
	b:SetScript("OnUpdate", nil)
	b:SetAlpha(1)
	if b._mhLevel then
		b:SetFrameLevel(b._mhLevel)
	end
	b._mhDragEnd = GetTime()
	if save and drag.to ~= drag.from then
		table.remove(panel._mhOrder, drag.from)
		table.insert(panel._mhOrder, drag.to, b)
		SaveOrder(panel)
	end
	PlaceCards(panel)
end

-- Blizzard's context menu (MenuUtil, 11.0+). Without it, the click does the one obvious thing
-- itself rather than nothing.
local function OpenMenu(owner, build)
	if MenuUtil and MenuUtil.CreateContextMenu then
		MenuUtil.CreateContextMenu(owner, function(_, root)
			build(root)
		end)
		return true
	end
	return false
end

local function ShowCardMenu(card)
	local screenId = card._mhScreen
	local hideable = screenId and ns.IsScreenHideable and ns.IsScreenHideable(screenId) and ns.SetScreenHidden
	local roomId = card._mhPanel and card._mhPanel._mhRoom
	local ordered = roomId and SavedOrder(roomId) ~= nil
	local opened = OpenMenu(card, function(root)
		root:CreateTitle(card._mhName:GetText() or screenId or "")
		if hideable then
			root:CreateButton(ns:L("ROOMCARD_HIDE"), function()
				ns.SetScreenHidden(screenId, true)
			end)
		end
		if ordered then
			root:CreateButton(ns:L("ROOMCARD_RESET_ORDER"), function()
				ResetOrder(roomId)
			end)
		end
		root:CreateDivider()
		root:CreateButton(ns:L("SCREENS_ALL_LINK"), function()
			if ns.SelectTab then
				ns.SelectTab("screens")
			end
		end)
	end)
	if not opened and hideable then
		ns.SetScreenHidden(screenId, true)
	end
end

local function ShowRestoreMenu(row)
	local hidden = row._mhHidden or {}
	if #hidden == 0 or not ns.SetScreenHidden then
		return
	end
	local function showAll()
		for _, c in ipairs(hidden) do
			ns.SetScreenHidden(ScreenOf(c), false)
		end
	end
	local opened = OpenMenu(row, function(root)
		root:CreateTitle(ns:L("ROOMCARD_RESTORE_TITLE"))
		for _, c in ipairs(hidden) do
			local screenId = ScreenOf(c)
			root:CreateButton(CardLabel(c), function()
				ns.SetScreenHidden(screenId, false)
			end)
		end
		if #hidden > 1 then
			root:CreateDivider()
			root:CreateButton(ns:L("ROOMCARD_RESTORE_ALL"), showAll)
		end
		root:CreateDivider()
		root:CreateButton(ns:L("SCREENS_ALL_LINK"), function()
			if ns.SelectTab then
				ns.SelectTab("screens")
			end
		end)
	end)
	if not opened then
		showAll()
	end
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
	-- Two lines, not one: the translated status lines run up to 30 characters (German
	-- "Wochenquests erledigt: 3 / 4") on a card ~140 px wide. The card has room below.
	status:SetWordWrap(true)
	if status.SetMaxLines then
		status:SetMaxLines(2)
	end
	status:SetTextColor(unpack(LOOK.status))

	local hl = b:CreateTexture(nil, "HIGHLIGHT")
	hl:SetAllPoints()
	hl:SetColorTexture(unpack(LOOK.hover))

	b._mhIcon, b._mhName, b._mhStatus = icon, name, status
	b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	-- Drag to reorder (Card order above). A drag only begins once the held mouse moves, so a
	-- plain click still opens the screen.
	b:RegisterForDrag("LeftButton")
	b:SetScript("OnDragStart", StartCardDrag)
	b:SetScript("OnDragStop", function(self)
		EndCardDrag(self._mhPanel, true)
	end)
	b:SetScript("OnClick", function(self, button)
		if self._mhDragEnd and GetTime() - self._mhDragEnd < 0.3 then
			return -- the mouse-up that ended a drag is not a click
		end
		if button == "RightButton" then
			ShowCardMenu(self)
			return
		end
		if self._mhTarget and ns.SelectTab then
			ns.SelectTab(self._mhTarget)
		end
	end)
	b:SetScript("OnEnter", function(self)
		if self._mhPanel and self._mhPanel._mhDrag then
			return
		end
		local hideable = self._mhScreen and ns.IsScreenHideable and ns.IsScreenHideable(self._mhScreen)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(self._mhName:GetText() or "", 1, 0.82, 0)
		if self._mhTagline then
			GameTooltip:AddLine(ns:L(self._mhTagline), 0.92, 0.92, 0.92, true)
		end
		local m = Palette().status
		GameTooltip:AddLine(ns:L("ROOMCARD_DRAG_HINT"), m[1], m[2], m[3], true)
		if hideable then
			GameTooltip:AddLine(ns:L("ROOMCARD_HIDE_HINT"), m[1], m[2], m[3], true)
		end
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
	EndCardDrag(panel, false) -- a re-layout mid-drag puts the card back
	local cards, hidden = CardsForRoom(roomId)
	cards = OrderedCards(roomId, cards)
	local screens = ns._mhLookScreens or {}
	panel._mhGeom = { cols = cols, cardW = cardW }
	panel._mhOrder = {}

	for i, c in ipairs(cards) do
		local b = panel._mhCards[i]
		if not b then
			b = MakeCard(panel._mhBody)
			panel._mhCards[i] = b
		end
		b:SetSize(cardW, CARD_H)
		b._mhPanel = panel
		panel._mhOrder[i] = b
		local screenId = ScreenOf(c)
		local screen = screens[screenId]
		if screen and ns._mhLookIconPath then
			b._mhIcon:SetTexture(ns._mhLookIconPath:format(screen.stem))
		else
			b._mhIcon:SetTexture(nil)
		end
		b._mhName:SetText(CardLabel(c))
		b._mhTagline = screen and screen.tagline
		b._mhTarget = c.id
		b._mhScreen = screenId
		b._mhStatus:SetText(StatusFor(screenId))
		b:Show()
	end
	for i = #cards + 1, #panel._mhCards do
		panel._mhCards[i]:Hide()
	end
	PlaceCards(panel)
	local rows = math.ceil(#cards / cols)
	local bodyH = math.max(1, rows * (CARD_H + GAP))
	-- The way back from a right-click, in the same room: "Hidden: 2 — show again".
	local restore = panel._mhRestore
	if restore then
		if #hidden > 0 then
			restore._mhHidden = hidden
			restore._mhText:SetText(ns:L("ROOMCARD_HIDDEN_FMT"):format(#hidden))
			restore:SetWidth((restore._mhText:GetStringWidth() or 120) + 8)
			restore:ClearAllPoints()
			restore:SetPoint("TOPLEFT", panel._mhBody, "TOPLEFT", 0, -bodyH)
			restore:Show()
			bodyH = bodyH + 24
		else
			restore._mhHidden = nil
			restore:Hide()
		end
	end
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

	local restore = CreateFrame("Button", nil, body)
	restore:SetHeight(20)
	local restoreText = restore:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	restoreText:SetPoint("LEFT", restore, "LEFT", 2, 0)
	restoreText:SetJustifyH("LEFT")
	local muted = Palette().status
	restoreText:SetTextColor(muted[1], muted[2], muted[3])
	restore._mhText = restoreText
	restore:SetScript("OnClick", ShowRestoreMenu)
	restore:SetScript("OnEnter", function(self)
		local h = Palette().name
		self._mhText:SetTextColor(h[1], h[2], h[3])
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(ns:L("ROOMCARD_RESTORE_TITLE"), 1, 0.82, 0)
		GameTooltip:AddLine(ns:L("ROOMCARD_RESTORE_HINT"), 0.92, 0.92, 0.92, true)
		GameTooltip:Show()
	end)
	restore:SetScript("OnLeave", function(self)
		local m = Palette().status
		self._mhText:SetTextColor(m[1], m[2], m[3])
		GameTooltip:Hide()
	end)
	restore:Hide()
	panel._mhRestore = restore

	panel._mhRoom = roomId
	panel._mhScroll = scroll
	panel._mhBody = body
	panel._mhCards = {}
	panel:SetScript("OnShow", Layout)
	panel:SetScript("OnHide", function(self)
		EndCardDrag(self, false)
	end)
	scroll:SetScript("OnSizeChanged", function()
		if panel:IsShown() then
			Layout(panel)
		end
	end)
	ns.panels[pid] = panel
	return panel
end

--- Opens the room's card grid. Returns false when the room button should keep its 3.x
--- behaviour: Classic look, or a room with fewer than two screens. Hidden screens count: a
--- room whose cards are all hidden still opens, on the line that brings them back.
function ns:OpenRoomLauncher(roomId)
	if self.IsClassicLookEnabled and self:IsClassicLookEnabled() then
		return false
	end
	local shown, hidden = CardsForRoom(roomId)
	if #shown + #hidden < 2 then
		return false
	end
	if not EnsurePanel(roomId) or not self.SelectTab then
		return false
	end
	self.SelectTab("room_" .. roomId)
	return true
end

--- Re-lays the open card grid after a screen was hidden or shown again.
function ns.RefreshRoomLauncher()
	for _, roomId in ipairs({ "me", "codex", "tools" }) do
		local panel = ns.panels and ns.panels["room_" .. roomId]
		if panel and panel:IsShown() then
			Layout(panel)
		end
	end
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
