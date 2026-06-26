--[[
	Midnight Helper — Achievements (proof: treasure routing).

	Reads live completion from quest flags (a treasure's quest flips completed
	when you loot it — same signal we use for profession treasures), then routes
	the ones you still miss with the shared AddSmartTomTomWay engine. Nearest
	incomplete first; plays nice with the reset/treasure routes via the
	ns._mhRouteOwner arbiter.

	Data: ns.ACHIEVEMENT_TREASURES (AchievementsData.lua).
	Command: /mh treasures  (first entry = Eversong Woods for now).
]]

local _, ns = ...

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

-- A treasure is "done" per its achievement CRITERION (authoritative — matches
-- what WoW counts toward the achievement), falling back to the treasure's quest
-- flag only if the criterion API is unavailable.
local function NodeDone(achievementID, node)
	if achievementID and node.criteria and GetAchievementCriteriaInfoByID then
		local ok, _, _, completed = pcall(GetAchievementCriteriaInfoByID, achievementID, node.criteria)
		if ok and completed ~= nil then
			return completed and true or false
		end
	end
	if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted and node.quest then
		local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, node.quest)
		return ok and done or false
	end
	return false
end

-- entry from ns.ACHIEVEMENT_TREASURES -> (doneCount, total, { incomplete nodes }).
function ns.GetTreasureProgress(entry)
	local done, incomplete = 0, {}
	for _, node in ipairs(entry.nodes or {}) do
		if NodeDone(entry.achievementID, node) then
			done = done + 1
		else
			incomplete[#incomplete + 1] = node
		end
	end
	return done, #(entry.nodes or {}), incomplete
end

local function AchievementName(entry)
	if GetAchievementInfo and entry.achievementID then
		local _, name = GetAchievementInfo(entry.achievementID)
		if name and name ~= "" then
			return name
		end
	end
	if entry.nameKey and ns.L then
		return ns:L(entry.nameKey)
	end
	return "Treasures"
end

-- Map coords -> world (yard) coords: isotropic and comparable ACROSS maps,
-- unlike raw 0..1 map coords (whose x/y scales differ per zone). Same approach
-- as the Rares nearest-route, so distances are correct wherever you stand.
local function MapPosToWorld(mapID, x01, y01)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, _, world = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(x01, y01))
	if ok and type(world) == "table" then
		local wx, wy
		if world.GetXY then
			wx, wy = world:GetXY()
		else
			wx, wy = world.x, world.y
		end
		if type(wx) == "number" and type(wy) == "number" then
			return wx, wy
		end
	end
	return nil
end

local function NodeWorld(node)
	return MapPosToWorld(node.mapID, (node.x or 0) / 100, (node.y or 0) / 100)
end

local function PlayerWorld()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil
	end
	local pmap = C_Map.GetBestMapForUnit("player")
	if not pmap then
		return nil
	end
	local pos = C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(pmap, "player")
	if not pos then
		return nil
	end
	local px, py = pos:GetXY()
	if not (px and py) then
		return nil
	end
	return MapPosToWorld(pmap, px, py)
end

-- Greedy nearest-neighbor order over the incomplete nodes, starting from the
-- player: pin 1 is the truly nearest, then the nearest to that, etc.
local function OrderNearest(nodes)
	local pool, anyWorld = {}, false
	for _, n in ipairs(nodes) do
		local nx, ny = NodeWorld(n)
		if nx then
			anyWorld = true
		end
		pool[#pool + 1] = { node = n, wx = nx, wy = ny }
	end
	if not anyWorld then
		return nodes -- world coords unavailable: keep listed order
	end
	local curx, cury = PlayerWorld()
	local out = {}
	while #pool > 0 do
		local bestI, bestD
		for i, p in ipairs(pool) do
			local d = math.huge
			if p.wx and curx then
				local dx, dy = p.wx - curx, p.wy - cury
				d = dx * dx + dy * dy
			end
			if not bestD or d < bestD then
				bestD, bestI = d, i
			end
		end
		local chosen = table.remove(pool, bestI)
		out[#out + 1] = chosen.node
		if chosen.wx then
			curx, cury = chosen.wx, chosen.wy
		end
	end
	return out
end

--------------------------------------------------------------------------------
-- Hint toast: a small dismissable popup for the treasure you're routed to, with
-- what to do first and a waypoint button per missing prerequisite. Stays until
-- you close it (no auto-fade); replaced when the route advances.
--------------------------------------------------------------------------------
local toast

local function EnsureToast()
	if toast then
		return toast
	end
	local f = CreateFrame("Frame", "MidnightHelperTreasureToast", UIParent, "BackdropTemplate")
	f:SetSize(330, 120)
	f:SetPoint("TOP", UIParent, "TOP", 0, -200)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	-- Shift + mouse wheel scales the toast bigger/smaller (remembered).
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(self, delta)
		if not IsShiftKeyDown() then
			return
		end
		local s = math.max(0.6, math.min(2.2, (self:GetScale() or 1) + (delta > 0 and 0.1 or -0.1)))
		self:SetScale(s)
		if ns.db and ns.db.ui then
			ns.db.ui.treasureToastScale = s
		end
	end)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true, tileSize = 8, edgeSize = 1,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		})
		f:SetBackdropColor(0.08, 0.08, 0.10, 0.96)
		f:SetBackdropBorderColor(0.85, 0.7, 0.3, 0.95)
	end

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
	close:SetScript("OnClick", function()
		f:Hide()
	end)

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.title:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -10)
	f.title:SetPoint("RIGHT", f, "RIGHT", -28, 0)
	f.title:SetJustifyH("LEFT")
	f.title:SetTextColor(1, 0.82, 0.2)

	f.body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.body:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -6)
	f.body:SetPoint("RIGHT", f, "RIGHT", -12, 0)
	f.body:SetJustifyH("LEFT")
	f.body:SetWordWrap(true)
	f.body:SetTextColor(0.92, 0.92, 0.92)

	f.btns = {}
	if ns.db and ns.db.ui and ns.db.ui.treasureToastScale then
		f:SetScale(ns.db.ui.treasureToastScale)
	end
	-- Auto-close once its treasure is completed, independent of any active route
	-- (so it also works when opened by hand from the tab's Waypoint button).
	f:RegisterEvent("CRITERIA_UPDATE")
	f:RegisterEvent("QUEST_LOG_UPDATE")
	f:RegisterEvent("QUEST_TURNED_IN")
	f:RegisterEvent("ACHIEVEMENT_EARNED")
	f:SetScript("OnEvent", function()
		if ns.MaybeCloseTreasureToast then
			ns.MaybeCloseTreasureToast()
		end
	end)
	f:Hide()
	toast = f
	return f
end

function ns.ShowTreasureToast(node)
	if not node or (not node.note and not (node.prereqs and #node.prereqs > 0)) then
		if toast then
			toast._node = nil
			toast:Hide()
		end
		return
	end
	local f = EnsureToast()
	f._node = node -- remember it so we can auto-close once it's completed
	for _, b in ipairs(f.btns) do
		b:Hide()
	end
	f.title:SetText(node.name or "Treasure")
	f.body:SetText(node.note or "")

	-- Button 1 routes back to the treasure itself (so you never lose it when the
	-- TomTom arrow clears on arrival); the rest are its prerequisites.
	local targets = { { name = (node.name or "Treasure") .. " — the chest", mapID = node.mapID, x = node.x, y = node.y } }
	for _, p in ipairs(node.prereqs or {}) do
		targets[#targets + 1] = p
	end
	local prev, n = f.body, 0
	for i, p in ipairs(targets) do
		n = i
		local b = f.btns[i]
		if not b then
			b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
			b:SetHeight(20)
			f.btns[i] = b
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -6)
		b:SetPoint("RIGHT", f, "RIGHT", -12, 0)
		b:SetText("|cffaaccff->|r " .. (p.name or "?"))
		b:SetScript("OnClick", function()
			if ns.AddSmartTomTomWay then
				ns.AddSmartTomTomWay(p.mapID, p.x, p.y, p.name)
			end
		end)
		b:Show()
		prev = b
	end

	local bodyH = (node.note and (f.body:GetStringHeight() or 24)) or 0
	f:SetHeight(28 + bodyH + 10 + n * 26 + 8)
	f:Show()
end

-- Close the toast on its own once the treasure it shows is completed — even if
-- you opened it by hand (tapping a Waypoint button) rather than via the route.
function ns.MaybeCloseTreasureToast()
	if not (toast and toast:IsShown() and toast._node) then
		return
	end
	local node = toast._node
	local achID
	for _, entry in ipairs(ns.ACHIEVEMENT_TREASURES or {}) do
		for _, n in ipairs(entry.nodes or {}) do
			if n == node then
				achID = entry.achievementID
				break
			end
		end
		if achID then
			break
		end
	end
	if NodeDone(achID, node) then
		toast._node = nil
		toast:Hide()
	end
end

--------------------------------------------------------------------------------
-- Active route with auto-advance: as you loot each treasure, the arrow moves to
-- the next still-missing one (same idea as the reset route). Stands down when
-- another navigation feature (reset / profession treasure) takes the arrow.
--------------------------------------------------------------------------------
local activeEntry, routeSig, advancePending, advanceFrame

local function IncompleteSig(nodes)
	local t = {}
	for i, n in ipairs(nodes) do
		t[i] = n.criteria or n.quest or i
	end
	table.sort(t)
	return table.concat(t, ",")
end

-- silent = re-assert the arrow/backup on a zone change without spamming chat or
-- re-popping the toast (used by the zone-change re-assert below).
local function IssueRoute(entry, firstTime, silent)
	local done, total, incomplete = ns.GetTreasureProgress(entry)
	local title = AchievementName(entry)
	if ns.IsTomTomReady and ns.IsTomTomReady() then
		pcall(function()
			_G.TomTom:ClearAllWaypoints()
		end)
	end
	if #incomplete == 0 then
		ns.lastTarget = nil
		routeSig, activeEntry = nil, nil
		if ns._mhRouteOwner == "achievement" then
			ns._mhRouteOwner = nil
		end
		if ns.ShowTreasureToast then
			ns.ShowTreasureToast(nil)
		end
		print(("%s %s — all %d treasures done."):format(Prefix(), title, total))
		return
	end
	incomplete = OrderNearest(incomplete)
	ns._mhRouteOwner = "achievement" -- claim the shared arrow (others stand down)
	if ns.CancelResetRoute then
		ns.CancelResetRoute()
	end
	for i, node in ipairs(incomplete) do
		-- Signature: AddSmartTomTomWay(map, x, y, name, skipTravelUI, skipCrazyArrow).
		-- Crazy arrow only on pin 1 (the nearest). The travel assistant (portal / HS
		-- popup) fires only on the FIRST route's pin 1 — advancing to the next treasure
		-- in-zone, or a silent zone re-assert, must never nag a portal. This also avoids
		-- a false "go to Harandar" suggestion from sub-maps like The Den (2576), where
		-- "are you already in the zone?" reads false against the main map (2413).
		local isLead = (i == 1)
		local skipCrazyArrow = not isLead
		local skipTravelUI = (not isLead) or (not firstTime)
		ns.AddSmartTomTomWay(node.mapID, node.x, node.y, node.name, skipTravelUI, skipCrazyArrow)
	end
	local first = incomplete[1]
	ns.lastTarget = { mapID = first.mapID, x = first.x, y = first.y, name = first.name }
	routeSig = IncompleteSig(incomplete)
	-- Backup marker: while you're on a different map than the treasure (e.g. inside
	-- Silvermoon City with the next treasure out in Eversong Woods), TomTom's crazy
	-- arrow can't show a direction yet — add a Blizzard SuperTrack waypoint so you
	-- still get in-world guidance until you reach the treasure's map.
	if ns.SetBlizzardUserWaypoint and C_Map and C_Map.GetBestMapForUnit then
		local pm = C_Map.GetBestMapForUnit("player")
		if pm and pm ~= first.mapID then
			ns.SetBlizzardUserWaypoint(first.mapID, first.x, first.y)
		end
	end
	if not silent then
		if firstTime then
			print(("%s %s — %d/%d done; routing to %d remaining (next: %s)."):format(
				Prefix(), title, done, total, #incomplete, first.name))
		else
			print(("%s Next treasure: %s (%d/%d)."):format(Prefix(), first.name, done, total))
		end
		if first.note then
			print(("%s  |cffaaccff-> %s|r"):format(Prefix(), first.note))
		end
		if ns.ShowTreasureToast then
			ns.ShowTreasureToast(first)
		end
	end
end

local function Advance()
	if not activeEntry then
		return
	end
	if ns._mhRouteOwner and ns._mhRouteOwner ~= "achievement" then
		activeEntry, routeSig = nil, nil -- another route owns the arrow now
		return
	end
	local _, _, incomplete = ns.GetTreasureProgress(activeEntry)
	if IncompleteSig(incomplete) ~= routeSig then
		IssueRoute(activeEntry, false) -- a treasure got looted: advance the arrow
	end
end

local function ScheduleAdvance()
	if not activeEntry or advancePending then
		return
	end
	advancePending = true
	if C_Timer and C_Timer.After then
		C_Timer.After(1.0, function() -- debounce QUEST_LOG_UPDATE bursts
			advancePending = false
			Advance()
		end)
	else
		advancePending = false
		Advance()
	end
end

-- When you change zones, TomTom's crazy arrow drops if the treasure is on a
-- different map (e.g. passing through Silvermoon City between Eversong and
-- Harandar). Re-assert the arrow + Blizzard backup on every zone change so the
-- guidance reappears on its own — no need for a toast button.
local reassertPending
local function ScheduleReassert()
	if not activeEntry or reassertPending then
		return
	end
	if ns._mhRouteOwner and ns._mhRouteOwner ~= "achievement" then
		return
	end
	reassertPending = true
	local function go()
		reassertPending = false
		if activeEntry and ns._mhRouteOwner == "achievement" then
			IssueRoute(activeEntry, false, true) -- silent re-assert
		end
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0.7, go) -- let the map settle after the load screen
	else
		go()
	end
end

-- Keepalive: zone-change events don't catch every transition (flying out of a
-- city, taxi hops), and the game can drop the SuperTrack waypoint mid-flight. A
-- light 3s ticker re-applies the Blizzard backup the moment it falls away, while
-- the target is on a different map than you — so the cross-zone arrow stays up
-- the whole trip. It only re-sets when tracking has actually dropped (no flicker).
local backupTicker
local function StopBackupTicker()
	if backupTicker then
		backupTicker:Cancel()
		backupTicker = nil
	end
end
local function StartBackupTicker()
	if backupTicker or not (C_Timer and C_Timer.NewTicker) then
		return
	end
	backupTicker = C_Timer.NewTicker(3, function()
		if not activeEntry or ns._mhRouteOwner ~= "achievement" then
			StopBackupTicker()
			return
		end
		local t = ns.lastTarget
		if not (t and ns.SetBlizzardUserWaypoint and C_Map and C_Map.GetBestMapForUnit) then
			return
		end
		local pm = C_Map.GetBestMapForUnit("player")
		if not pm or pm == t.mapID then
			return -- on the treasure's own map; TomTom's arrow handles it
		end
		local tracking = C_SuperTrack and C_SuperTrack.IsSuperTrackingUserWaypoint
			and C_SuperTrack.IsSuperTrackingUserWaypoint()
		local hasWp = C_Map.HasUserWaypoint and C_Map.HasUserWaypoint()
		if not tracking or not hasWp then
			ns.SetBlizzardUserWaypoint(t.mapID, t.x, t.y) -- re-apply the dropped arrow
		end
	end)
end

local function EnsureAdvanceFrame()
	if advanceFrame then
		return
	end
	advanceFrame = CreateFrame("Frame")
	advanceFrame:RegisterEvent("QUEST_LOG_UPDATE")
	advanceFrame:RegisterEvent("QUEST_TURNED_IN")
	advanceFrame:RegisterEvent("QUEST_REMOVED")
	advanceFrame:RegisterEvent("CRITERIA_UPDATE")
	advanceFrame:RegisterEvent("ACHIEVEMENT_EARNED")
	advanceFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	advanceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	advanceFrame:SetScript("OnEvent", function(_, event)
		if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
			ScheduleReassert()
		else
			if ns.MaybeCloseTreasureToast then
				ns.MaybeCloseTreasureToast()
			end
			ScheduleAdvance()
		end
	end)
end

-- Route to the still-missing treasures, and keep the arrow advancing to the
-- next one as you loot them.
function ns.RouteAchievementTreasures(entry)
	if not entry or not ns.AddSmartTomTomWay then
		return
	end
	activeEntry = entry
	EnsureAdvanceFrame()
	IssueRoute(entry, true)
	StartBackupTicker() -- keep the cross-zone arrow alive on the way there
end

--------------------------------------------------------------------------------
-- Achievements TAB: a list of tracked achievements, each with live progress, a
-- Route button (same engine as /mh treasures) and an expandable checklist whose
-- rows carry a per-treasure waypoint button. Data-driven over
-- ns.ACHIEVEMENT_TREASURES, so new zones show up automatically.
--------------------------------------------------------------------------------
local CHECK_DONE = "Interface\\RaidFrame\\ReadyCheck-Ready"
local CHECK_TODO = "Interface\\RaidFrame\\ReadyCheck-NotReady"

local function TL(key)
	return (ns.L and ns:L(key)) or key
end

local achPanelState -- { panel, scroll, child, intro, empty, cards = {...} }

local function LayoutAchPanel()
	local st = achPanelState
	if not st then
		return
	end
	local w = st.scroll and st.scroll:GetWidth() or 0
	if w and w > 0 then
		st.child:SetWidth(w)
	end
	local headerW = (w > 0 and w - 8) or 360
	local y = -2
	for _, card in ipairs(st.cards) do
		card.header:ClearAllPoints()
		card.header:SetPoint("TOPLEFT", st.child, "TOPLEFT", 0, y)
		card.header:SetWidth(headerW)
		card.arrow:SetText(card.expanded and "-" or "+")
		y = y - 28
		if card.expanded then
			for _, row in ipairs(card.rows) do
				row.frame:ClearAllPoints()
				row.frame:SetPoint("TOPLEFT", st.child, "TOPLEFT", 20, y)
				row.frame:SetWidth((w > 0 and w - 28) or 340)
				row.frame:Show()
				y = y - 22
			end
			y = y - 8
		else
			for _, row in ipairs(card.rows) do
				row.frame:Hide()
			end
			y = y - 4
		end
	end
	st.child:SetHeight(math.max(10, -y + 10))
end

local function RefreshAchPanel()
	local st = achPanelState
	if not st then
		return
	end
	for _, card in ipairs(st.cards) do
		local done, total = ns.GetTreasureProgress(card.entry)
		local complete = (total > 0 and done >= total)
		card.title:SetText(AchievementName(card.entry))
		local col = complete and "ff66dd66" or "ffffcc00"
		card.progress:SetText(("|c%s%d/%d|r"):format(col, done, total))
		card.routeBtn:SetText(complete and TL("ACH_TAB_DONE") or TL("ACH_TAB_ROUTE"))
		if complete then
			card.routeBtn:Disable()
		else
			card.routeBtn:Enable()
		end
		for _, row in ipairs(card.rows) do
			local nd = NodeDone(card.entry.achievementID, row.node)
			row.check:SetTexture(nd and CHECK_DONE or CHECK_TODO)
			if nd then
				row.name:SetText("|cff808080" .. (row.node.name or "?") .. "|r")
			else
				row.name:SetText(row.node.name or "?")
			end
			row.wp:SetText(TL("ACH_TAB_WAYPOINT"))
		end
	end
	LayoutAchPanel()
end

local function RelocalizeAchPanel()
	local st = achPanelState
	if not st then
		return
	end
	if st.intro then
		st.intro:SetText(TL("ACH_TAB_INTRO"))
	end
	if st.empty then
		st.empty:SetText(TL("ACH_TAB_EMPTY"))
	end
	RefreshAchPanel()
end

local function BuildAchCard(st, entry)
	local card = { entry = entry, rows = {}, expanded = true }

	local header = CreateFrame("Button", nil, st.child)
	header:SetHeight(24)
	local hl = header:CreateTexture(nil, "HIGHLIGHT")
	hl:SetAllPoints()
	hl:SetColorTexture(1, 1, 1, 0.06)
	card.header = header

	card.arrow = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	card.arrow:SetPoint("LEFT", header, "LEFT", 2, 0)
	card.arrow:SetWidth(14)
	card.arrow:SetJustifyH("CENTER")

	card.title = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	card.title:SetPoint("LEFT", card.arrow, "RIGHT", 4, 0)
	card.title:SetJustifyH("LEFT")

	card.progress = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	card.progress:SetPoint("LEFT", card.title, "RIGHT", 10, 0)

	local routeBtn = CreateFrame("Button", nil, header, "UIPanelButtonTemplate")
	routeBtn:SetSize(78, 20)
	routeBtn:SetPoint("RIGHT", header, "RIGHT", -2, 0)
	routeBtn:SetScript("OnClick", function()
		ns.RouteAchievementTreasures(entry)
	end)
	card.routeBtn = routeBtn

	header:SetScript("OnClick", function()
		card.expanded = not card.expanded
		LayoutAchPanel()
	end)

	for _, node in ipairs(entry.nodes or {}) do
		local row = { node = node }
		local rf = CreateFrame("Frame", nil, st.child)
		rf:SetHeight(20)
		row.frame = rf

		row.check = rf:CreateTexture(nil, "ARTWORK")
		row.check:SetSize(15, 15)
		row.check:SetPoint("LEFT", rf, "LEFT", 0, 0)

		row.name = rf:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		row.name:SetPoint("LEFT", row.check, "RIGHT", 6, 0)
		row.name:SetJustifyH("LEFT")

		local wp = CreateFrame("Button", nil, rf, "UIPanelButtonTemplate")
		wp:SetSize(72, 18)
		wp:SetPoint("RIGHT", rf, "RIGHT", -2, 0)
		wp:SetScript("OnClick", function()
			if ns.AddSmartTomTomWay then
				ns.AddSmartTomTomWay(node.mapID, node.x, node.y, node.name)
			end
			-- Multi-step? also show the hint toast with its prereq buttons.
			if (node.note or node.prereqs) and ns.ShowTreasureToast then
				ns.ShowTreasureToast(node)
			end
		end)
		row.name:SetPoint("RIGHT", wp, "LEFT", -6, 0)
		row.wp = wp

		card.rows[#card.rows + 1] = row
	end

	st.cards[#st.cards + 1] = card
end

function ns.BuildAchievementsPanel(panel)
	-- Drop the generic CreateModulePanel placeholder body (it would overlap our
	-- own intro line otherwise).
	if panel._body then
		panel._body:SetText("")
		panel._body:Hide()
	end

	local intro = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	intro:SetPoint("TOPLEFT", panel._header, "BOTTOMLEFT", 0, -6)
	intro:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
	intro:SetJustifyH("LEFT")
	intro:SetText(TL("ACH_TAB_INTRO"))

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", intro, "BOTTOMLEFT", 0, -10)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, 12)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)
	scroll:SetScript("OnSizeChanged", function()
		LayoutAchPanel()
	end)

	achPanelState = { panel = panel, scroll = scroll, child = child, intro = intro, cards = {} }

	local list = ns.ACHIEVEMENT_TREASURES or {}
	if #list == 0 then
		local empty = child:CreateFontString(nil, "OVERLAY", "GameFontDisableLarge")
		empty:SetPoint("TOPLEFT", child, "TOPLEFT", 4, -8)
		empty:SetText(TL("ACH_TAB_EMPTY"))
		achPanelState.empty = empty
	else
		for _, entry in ipairs(list) do
			BuildAchCard(achPanelState, entry)
		end
	end

	-- Live refresh when shown + on completion/quest events.
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("CRITERIA_UPDATE")
	ev:RegisterEvent("ACHIEVEMENT_EARNED")
	ev:RegisterEvent("QUEST_LOG_UPDATE")
	ev:SetScript("OnEvent", function()
		if panel:IsShown() then
			RefreshAchPanel()
		end
	end)
	panel:HookScript("OnShow", RefreshAchPanel)

	-- Relabel on language change (titles come from the API and follow the game
	-- locale automatically; the surrounding chrome we relocalize here).
	do
		local orig = ns.RefreshLocaleUI
		function ns:RefreshLocaleUI(...)
			if orig then
				orig(self, ...)
			end
			RelocalizeAchPanel()
		end
	end

	RefreshAchPanel()
end

-- Pick the treasure achievement for the zone the player is standing in (so
-- /mh treasures "just works" wherever you are); fall back to the first entry.
function ns.PickTreasureEntryForZone()
	local list = ns.ACHIEVEMENT_TREASURES or {}
	local pm = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if pm then
		for _, entry in ipairs(list) do
			for _, node in ipairs(entry.nodes or {}) do
				if node.mapID == pm then
					return entry
				end
			end
		end
	end
	return list[1]
end

-- Slash hook (Core.lua calls this early, like the delve-items handler).
function ns:RunAchievementSlashCommand(msg)
	if msg == "treasures" or msg == "treasure" then
		local entry = ns.PickTreasureEntryForZone()
		if not entry then
			print(("%s no treasure achievement data loaded."):format(Prefix()))
			return true
		end
		ns.RouteAchievementTreasures(entry)
		return true
	end
	return false
end
